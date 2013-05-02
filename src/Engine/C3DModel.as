package Engine
{

import flash.display3D.*;
import flash.display3D.textures.Texture;
import flash.events.Event;
import flash.geom.Matrix3D;
import flash.utils.*;

public class C3DModel
{
	static public const FlagMeshShadow:uint = 1;
	static public const FlagMatrix:uint = 2;
	
	public var m_Name:String = null;
	public var m_Type:uint = 0;
	public var m_Id:uint = 0;
	
	public var m_Flag:uint = 0;
	
	public var m_Frame:int = 0;

	public var m_FunBeforeDraw:Function = null;
	//public var m_FunAfterDraw:Function = null;

	public var m_Parent:C3DModel = null;

	public var m_Mesh:C3DMesh = null;
	public var m_MeshShadow:C3DMesh = null;
	public var m_MeshPath:String = null;

	public var m_Texture0:C3DTexture = null;
	public var m_Texture1:C3DTexture = null;
	public var m_Texture2:C3DTexture = null;
	public var m_Texture3:C3DTexture = null;

	public var m_ConnectId:uint = 0;

	public var m_Child:Array = null;

	public var m_Matrix:Matrix3D = new Matrix3D();
	public var m_MatrixWorld:Matrix3D = new Matrix3D();
	public var m_MatrixWorldInv:Matrix3D = new Matrix3D();
	
	public var m_MatrixTmp:Matrix3D = new Matrix3D();

	public function C3DModel():void
	{
	}

	public function Clear():void
	{
		GraphClear();
		DeleteAllChild();
		m_Name = null;
		m_Type = 0;
		m_Id = 0;
		m_Flag = 0;
		m_FunBeforeDraw = null;
		//m_FunAfterDraw = null;
		
		m_Matrix.identity();
	}

	public function DeleteAllChild():void
	{
		var i:int;
		if (m_Child == null) return;
		for (i = m_Child.length - 1; i >= 0; i--) {
			var m:C3DModel = m_Child[i];
			m.Clear();
			m.m_Parent = null;
			m_Child.splice(i, 1);
		}
		m_Child = null;
	}
	
	public function DeleteChild(child:C3DModel):Boolean
	{
		if (child == null) return false;
		if (child.m_Parent == null) return false;
		if (child.m_Parent != this) throw Error("C3DModel.DeleteChild");
		if (m_Child == null) throw Error("C3DModel.DeleteChild");
		var i:int = m_Child.indexOf(child);
		if (i < 0) throw Error("C3DModel.DeleteChild");;
		
		child.Clear();
		child.m_Parent = null;
		m_Child.splice(i, 1);
		return true;
	}
	
	public function AddChild(child:C3DModel = null):C3DModel
	{
		if (child == null) child = new C3DModel();
		if (child.m_Parent != null) throw Error("C3DModel.AddChild");
		if (m_Child == null) m_Child = new Array();
		child.m_Parent = this;
		m_Child.push(child);
		return child;
	}

	public function Context3DCreate(e:Event):void
	{
		if (m_Texture0 != null) m_Texture0 = null;
		if (m_Texture1 != null) m_Texture1 = null;
		if (m_Texture2 != null) m_Texture2 = null;
		if (m_Texture3 != null) m_Texture3 = null;
	}

	public function GraphClear(child:Boolean = true):void
	{
		var i:int;

		if(m_Mesh!=null) {
			m_Mesh.Clear();
			m_Mesh = null;
		}
		if(m_MeshShadow!=null) {
			m_MeshShadow.Clear();
			m_MeshShadow = null;
		}
		if (m_Texture0 != null) m_Texture0 = null;
		if (m_Texture1 != null) m_Texture1 = null;
		if (m_Texture2 != null) m_Texture2 = null;
		if (m_Texture3 != null) m_Texture3 = null;

		if (child && m_Child != null) {
			for (i = 0; i < m_Child.length; i++) {
				var m:C3DModel = m_Child[i];
				m.GraphClear(true);
			}
		}
	}

	public function GraphPrepare(child:Boolean = true):Boolean
	{
		var i:int;
		var ok:Boolean = true;

		if (m_MeshPath != null) {
			if(m_Mesh==null) {
				var o:Object = LoadManager.Self.Get(m_MeshPath);
				if (o != null && (o is ByteArray)) {
					(o as ByteArray).endian=Endian.LITTLE_ENDIAN;
					m_Mesh = new C3DMesh();
					m_Mesh.Init(o as ByteArray);
					m_Mesh.GraphPrepare();
				} else ok = false;
			}
			if((m_Flag & FlagMeshShadow)!=0 && m_MeshShadow==null && m_Mesh!=null && ok) {
				m_MeshShadow = new C3DMesh();
				m_MeshShadow.GraphBuildShadowMesh(m_Mesh);
			}
		} else {
			if(m_Mesh!=null) {
				m_Mesh.Clear();
				m_Mesh = null;
			}
			if(m_MeshShadow!=null) {
				m_MeshShadow.Clear();
				m_MeshShadow = null;
			}
		}
		
		if (m_Texture0 != null && m_Texture0.Get() == null) ok = false;
		if (m_Texture1 != null && m_Texture1.Get() == null) ok = false;
		if (m_Texture2 != null && m_Texture2.Get() == null) ok = false;
		if (m_Texture3 != null && m_Texture3.Get() == null) ok = false;

		if (child && m_Child != null) {
			for (i = 0; i < m_Child.length; i++) {
				var m:C3DModel = m_Child[i];
				if (!m.GraphPrepare(true)) ok = false;
			}
		}

		return ok;
	}
	
	public function CalcMatrix(m:Matrix3D):void
	{
		var i:int;

		var needinit:Boolean = true;

		if(m_Flag & FlagMatrix) {
			if (needinit) { m_MatrixWorld.copyFrom(m_Matrix); needinit = false; }
			else m_MatrixWorld.append(m_Matrix);
		}

		if ((m_ConnectId != 0) && (m_Parent != null) && (m_Parent.m_Mesh != null)) {
			i = m_Parent.m_Mesh.ConnectById(m_ConnectId);
			i = m_Parent.m_Mesh.Connect(i, m_Parent.m_Frame);
			if (i >= 0) {
				if (needinit) { m_MatrixWorld.copyFrom(m_Parent.m_Mesh.m_Matrix[i]); needinit = false; }
				else m_MatrixWorld.append(m_Parent.m_Mesh.m_Matrix[i]);
			}
		}

		if (needinit) { m_MatrixWorld.copyFrom(m); needinit = false;  }
		else m_MatrixWorld.append(m);

		if (m_Child != null) {
			for (i = 0; i < m_Child.length; i++) {
				var cm:C3DModel = m_Child[i];
				cm.CalcMatrix(m_MatrixWorld);
			}
		}

		if (m_Mesh != null) {
			var fr:C3DMeshFrame = m_Mesh.m_Frame[m_Frame];
			if (fr.m_MatrixNo >= 0) {
				m_MatrixWorld.prepend(m_Mesh.m_Matrix[fr.m_MatrixNo]);
			}
		}

		m_MatrixWorldInv.copyFrom(m_MatrixWorld);
		m_MatrixWorldInv.invert();
	}

	public function Draw(m:Matrix3D, child:Boolean = true):void
	{
		var i:int;

		while (GraphPrepare(child)) {
			if (C3D.m_Pass == C3D.PassShadow) {
				if (m_MeshShadow != null) {
					C3D.VBMesh(m_MeshShadow,true,false);

					m_MatrixTmp.copyFrom(m_MatrixWorld);
					m_MatrixTmp.append(m);
					if (m_FunBeforeDraw != null) {
						if (!m_FunBeforeDraw(this, m_MatrixTmp)) break;
					}

					C3D.Context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.ALWAYS, Context3DStencilAction.INCREMENT_WRAP, Context3DStencilAction.KEEP, Context3DStencilAction.INCREMENT_WRAP);
					C3D.Context.setCulling(Context3DTriangleFace.FRONT);
					C3D.DrawMesh();
					C3D.Context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.ALWAYS, Context3DStencilAction.DECREMENT_WRAP, Context3DStencilAction.KEEP, Context3DStencilAction.INCREMENT_WRAP);
					C3D.Context.setCulling(Context3DTriangleFace.BACK);
					C3D.DrawMesh();

					//if (m_FunAfterDraw!=null) m_FunAfterDraw(this);
				}
			} else {
				if (m_Mesh != null) {
					C3D.VBMesh(m_Mesh, 
						C3D.m_Pass == C3D.PassDif || C3D.m_Pass == C3D.PassDifShadow, 
						C3D.m_Pass == C3D.PassDif || C3D.m_Pass == C3D.PassDifShadow || C3D.m_Pass == C3D.PassLum);

					m_MatrixTmp.copyFrom(m_MatrixWorld);
					m_MatrixTmp.append(m);
					if (m_FunBeforeDraw != null) {
						if (!m_FunBeforeDraw(this, m_MatrixTmp)) break;
					}

//trace(C3D.m_Shader_TextureMask, m_Texture0Path, m_Texture1Path, m_Texture2Path);
					var ts:uint = 0;
					if (m_Texture0 != null && (C3D.m_Shader_TextureMask & (1 << 0)) != 0) { ts |= 1 << 0; C3D.SetTexture(0, m_Texture0.tex); }
					if (m_Texture1 != null && (C3D.m_Shader_TextureMask & (1 << 1)) != 0) { ts |= 1 << 1; C3D.SetTexture(1, m_Texture1.tex); }
					if (m_Texture2 != null && (C3D.m_Shader_TextureMask & (1 << 2)) != 0) { ts |= 1 << 2; C3D.SetTexture(2, m_Texture2.tex); }
					if (m_Texture3 != null && (C3D.m_Shader_TextureMask & (1 << 3)) != 0) { ts |= 1 << 3; C3D.SetTexture(3, m_Texture3.tex); }

					C3D.DrawMesh();

					if ((ts & (1 << 0)) != 0) C3D.SetTexture(0, null);
					if ((ts & (1 << 1)) != 0) C3D.SetTexture(1, null);
					if ((ts & (1 << 2)) != 0) C3D.SetTexture(2, null);
					if ((ts & (1 << 3)) != 0) C3D.SetTexture(3, null);
					//if (m_FunAfterDraw!=null) m_FunAfterDraw(this);
				}
			}
			break;
		}

		if (child && m_Child != null) {
			for (i = 0; i < m_Child.length; i++) {
				var cm:C3DModel = m_Child[i];
				cm.Draw(m,true);
			}
		}
	}
}

}
