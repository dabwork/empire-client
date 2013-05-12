// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import B3DEffect.Effect;
import Base.BaseMath;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.display3D.*;
import flash.utils.*;

public class HyperspaceContainer extends HyperspaceEntity
{
	public var m_Tmp:int = 0;

	public var m_Vis:Boolean = false;
	public var m_IconTake:Boolean = false;

	public var m_PosSmooth:HyperspaceSmooth = new HyperspaceSmooth();

	public var m_InDraw:Boolean = false;

	public var m_Model:C3DModel = null;

	public var m_Radius:Number = 30;

	public var m_World:Matrix3D = new Matrix3D();
	public var m_WorldInv:Matrix3D = new Matrix3D();

	public var m_Angle:Number = 0.0;
	public var m_Pitch:Number = 0.0;
	public var m_Roll:Number = 0.0;
	
	public var m_SpeedX:Number = 0.0;
	public var m_SpeedY:Number = 0.0;
	
	static public var m_TPos:Vector3D = new Vector3D();

	public function HyperspaceContainer(hs:HyperspaceBase)
	{
		super(hs);
	}

	public function Clear():void
	{
		ClearGraph();
	}
	
	public function ClearGraph():void
	{
		var i:int;

		if(m_Model!=null) {
			m_Model.Clear();
			m_Model = null;
		}
	}
	
	public function SetFormation():void
	{
		ClearGraph();

		var cm:C3DModel;

		m_Model = new C3DModel();
		cm = m_Model.AddChild();
		cm.m_MeshPath = "Container/part.mesh";
		cm.m_Texture0 = C3D.GetTexture("Container/dif.png");
		cm.m_Texture1 = C3D.GetTexture("empty");
		cm.m_Texture2 = C3D.GetTexture("empty");
		//cm.m_Flag |= C3DModel.FlagMeshShadow;
		cm.m_FunBeforeDraw = DrawContainerBefore;
		
		var rnd:PRnd = new PRnd(getTimer() ^ m_Id);
		rnd.RndEx();
		m_Angle = rnd.RndFloat( -Space.pi, Space.pi);
		m_Roll = rnd.RndFloat( -Space.pi, Space.pi);

//		if(m_Speed.Len2()>0.0f) {
		m_Pitch = rnd.RndFloat( -Space.pi, Space.pi);
	}

	public function IsMeshLoaded(model:C3DModel = null):Boolean
	{
		if (model == null) model = m_Model;
		if (model == null) return false;
		
		if (model.m_MeshPath != null && model.m_MeshPath.length > 0 && model.m_Mesh == null) return false;
		
		if (model.m_Child != null) {
			var i:int;
			for (i = 0; i < model.m_Child.length; i++) {
				if (model.m_Child[i] == null) continue;
				if (!IsMeshLoaded(model.m_Child[i])) return false;
			}
		}
		return true;
	}

	public function Update(cont:SpaceContainer, playershuttle:SpaceShuttle = null):void
	{
		if (m_ZoneX != cont.m_ZoneX || m_ZoneY != cont.m_ZoneY) m_PosSmooth.AddOffset(HS.SP.m_ZoneSize * (m_ZoneX - cont.m_ZoneX), HS.SP.m_ZoneSize * (m_ZoneY - cont.m_ZoneY), 0.0);
		m_ZoneX = cont.m_ZoneX;
		m_ZoneY = cont.m_ZoneY;
		m_PosSmooth.Add(HS.m_CurTime + 200, cont.m_PosX, cont.m_PosY, cont.m_PosZ);
		m_Vis = cont.m_Vis && (cont.m_Flag & SpaceContainer.FlagNoMove) == 0 && (cont.m_Flag & SpaceContainer.FlagDestroy) == 0;
		
//trace(cont.m_SpeedX, cont.m_SpeedY);
		m_SpeedX = cont.m_SpeedX;
		m_SpeedY = cont.m_SpeedY;

		var i:int;

		m_IconTake = false;
		if (cont.m_Take != null && playershuttle != null)
		for (i = 0; i < SpaceContainer.TakeMax; i++) {
			if (cont.m_Take[i * 3 + 0] != SpaceEntity.TypeShuttle) continue;
			if (cont.m_Take[i * 3 + 1] != playershuttle.m_Id) continue;

			m_IconTake = true;
			break;
		}
	}

	public function CalcPos():void
	{
		m_PosSmooth.GetB(HS.m_CurTime, HyperspaceBase.m_TPos);
		m_PosX = HyperspaceBase.m_TPos.x;
		m_PosY = HyperspaceBase.m_TPos.y;
		m_PosZ = HyperspaceBase.m_TPos.z;
	}

	public function CalcMatrix():void
	{
		C3D.CalcMatrixShipOri(m_World, m_Angle, m_Pitch, m_Roll);
		m_World.appendTranslation(
			m_PosX - HS.m_CamPos.x + HS.m_ZoneSize * (m_ZoneX - HS.m_CamZoneX),
			m_PosY - HS.m_CamPos.y + HS.m_ZoneSize * (m_ZoneY - HS.m_CamZoneY),
			m_PosZ - HS.m_CamPos.z);
		m_WorldInv.copyFrom(m_World);
		m_WorldInv.invert();
	}

	public function GraphTakt(step:Number):void
	{
		var s:Number = Math.sqrt(m_SpeedX * m_SpeedX + m_SpeedY * m_SpeedY);
		if (s > 2.0) s = 2.0;
		if(s) {
			s *= 0.0005 * step;
//trace(s, 0.0005 * step, m_SpeedX, m_SpeedY);
			m_Angle = BaseMath.AngleNorm(m_Angle + s);
			m_Pitch = BaseMath.AngleNorm(m_Pitch + s);
			m_Roll = BaseMath.AngleNorm(m_Roll + s);

		} else if (m_Pitch != 0.0) {
			s = 0.009 * step;
			if (Math.abs(m_Pitch) < s) m_Pitch = 0.0;
			else if (BaseMath.AngleDist(m_Pitch, 0.0) < 0.0) m_Pitch -= s;
			else m_Pitch += s;
		}
	}

	public function IsReadyForDraw():Boolean
	{
		if (m_Model == null) return false;
		if (!m_Model.GraphPrepare()) return false;
		return true;
	}

	public function DrawPrepare(dt:Number):void
	{
		m_Model.CalcMatrix(m_World);
	}
	
	public function DrawContainerBefore(model:C3DModel, mwvp:Matrix3D):Boolean
	{
		var v:Vector3D;

		C3D.SetVConstMatrix(0, mwvp);

		if(C3D.m_Pass==C3D.PassDif || C3D.m_Pass==C3D.PassDifShadow) {
			v = model.m_MatrixWorldInv.deltaTransformVector(HS.m_Light);
			v.w = 0.0;
			v.normalize();
			C3D.SetVConst(4, v);
		}

		if (C3D.m_Pass == C3D.PassDif || C3D.m_Pass==C3D.PassDifShadow ) {
			v = model.m_MatrixWorldInv.transformVector(HS.m_View);
			v.w = 0.0;
			v.normalize();
			v.x = -v.x;
			v.y = -v.y;
			v.z = -v.z;
			C3D.SetVConst(5, v);
		}
		
		return true;
	}

	public function Draw():void
	{
		if (m_Model == null) return;

		if (C3D.m_Pass == C3D.PassShadow) {

		} else if (C3D.m_Pass == C3D.PassZ) {
			C3D.ShaderShip(false, false, false);
//trace("DrawContainer Z texMask:", C3D.m_Shader_TextureMask.toString(2));
			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassDif || C3D.m_Pass == C3D.PassDifShadow) {
			C3D.SetVConst(6, new Vector3D(0.0, 0.5, 1.0, 2.0));
			C3D.SetVConst(7, new Vector3D(0.1, 1.0 / 0.4, 0.5, 10.0));

			C3D.SetFConst(1, new Vector3D(0.0, 0.5, 1.0, 2.0));
			C3D.SetFConst(2, new Vector3D(0.1, 1.0 / 0.4, 0.5, 10.0));

			C3D.SetFConst_Color(4, 0xFF00496B); // 4-Color
			C3D.SetFConst_Color(5, 0xFF3B3B3B,3.0); // 5-Ambient
			C3D.SetFConst_Color(6, 0xFF3B3222,3.0); // 6-Diffuse
			C3D.SetFConst_Color(7, 0xFF262F15,3.0); // 7-Reflection
			C3D.SetFConst_Color(8, HS.m_ShadowColor); // 8-Shadow

			C3D.ShaderShip(true, C3D.m_Pass == C3D.PassDif, false);
//trace("DrawContainer Color texMask:", C3D.m_Shader_TextureMask.toString(2));
//if(C3D.m_Shader_TextureMask == 0) {
//trace("err!");
//C3D.ShaderShip(true, C3D.m_Pass == C3D.PassDif, false);
//}
			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassLum) {
//			C3D.ShaderShip(false, false, true);
//			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassParticle) {
		}
	}
	
	public function DrawText():void
	{
		var v:Number;
		var tex:C3DTexture;

		var offx:Number = m_PosX - HS.m_CamPos.x + HS.m_ZoneSize * (m_ZoneX - HS.m_CamZoneX);
		var offy:Number = m_PosY - HS.m_CamPos.y + HS.m_ZoneSize * (m_ZoneY - HS.m_CamZoneY);
		var offz:Number = m_PosZ - (HS.m_CamPos.z);

		while (m_IconTake) {
			tex = C3D.GetTexture("font/intf.png");
			if (tex == null || tex.tex == null) break;

			m_TPos.x = offx;
			m_TPos.y = offy;
			m_TPos.z = offz;
			HS.WorldToScreen(m_TPos);

			C3D.DrawImg(tex, 0xffffffff, m_TPos.x - 5 - 20, m_TPos.y + 5, 20, 20, 0, 8, 20, 20);

			break;
		}
	}
}

}