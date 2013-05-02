// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import B3DEffect.Effect;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.display3D.*;
import flash.utils.*;
	
public class HyperspacePlanet extends HyperspaceEntity
{
//	public var m_PlanetId:int = 0;
	public var m_Style:uint = 0;
	public var m_PlanetFlag:int = 0;
	public var m_CenterId:uint = 0;
	public var m_OrbitRadius:Number = 0.0;
	public var m_Radius:Number=0;
	public var m_CotlId:uint = 0;
	
	public var m_PosSmooth:HyperspaceSmooth = new HyperspaceSmooth();
	
//	public var m_ZoneX:Number = 0;
//	public var m_ZoneY:Number = 0;
//	public var m_X:Number = 0;
//	public var m_Y:Number = 0;
//	public var m_Z:Number = 0;

	public var m_Tmp:int=0;

	//private static var m_Model:C3DModel = null;

	public var m_InDraw:Boolean = false;

	public var m_Effect:Effect = null;

	public function HyperspacePlanet(hs:HyperspaceBase)
	{
		super(hs);
		//HS.m_PlanetList.push(this);
	}
	
	public function Clear():void
	{
		if(m_Effect!=null) {
			m_Effect.Clear();
			m_Effect = null;
		}
		//var i:int = HS.m_PlanetList.indexOf(this);
		//if (i >= 0) HS.m_PlanetList.splice(i, 1);

//		if(m_Model!=null) {
//			m_Model.Clear();
//			m_Model = null;
//		}
	}

	public function Syn(splanet:SpacePlanet):void
	{
		if (m_ZoneX != splanet.m_ZoneX || m_ZoneY != splanet.m_ZoneY) m_PosSmooth.AddOffset(HS.SP.m_ZoneSize * (m_ZoneX - splanet.m_ZoneX), HS.SP.m_ZoneSize * (m_ZoneY - splanet.m_ZoneY), 0.0);
		m_ZoneX = splanet.m_ZoneX;
		m_ZoneY = splanet.m_ZoneY;
		m_PosSmooth.Add(HS.m_CurTime + 200, splanet.m_PosX, splanet.m_PosY, splanet.m_PosZ);

		m_ZoneX = splanet.m_ZoneX;
		m_ZoneY = splanet.m_ZoneY;
//		m_X = splanet.m_PosX;
//		m_Y = splanet.m_PosY;
//		m_Z = splanet.m_PosZ;
		//m_Style = splanet.m_Style;
		m_PlanetFlag = splanet.m_PlanetFlag;
		m_CenterId = splanet.m_CenterId;
		m_OrbitRadius = splanet.m_OrbitRadius;
		m_Radius = splanet.m_Radius;
		m_CotlId = splanet.m_CotlId;

		if ((m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) return;

		if (m_Style == 0) {
			var cl:uint = 0;
			if ((m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeSun) cl |= HyperspacePlanetStyle.ClassSun;
			if ((m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypePlanet) cl |= HyperspacePlanetStyle.ClassPlanet;
			if ((m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeSputnik) cl |= HyperspacePlanetStyle.ClassSputnik;
			m_Style = HyperspacePlanetStyle.find(cl, (m_CotlId ^ splanet.m_PlanetNum) * 12345);
		}

		if ((m_Effect == null) && (m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeSun) {
			m_Effect = new Effect();
			m_Effect.Run("sun0");
			m_Effect.GraphTakt(2000);
		}

/*		if(m_Model==null) {
			m_Model = new C3DModel();
			var cm:C3DModel = m_Model.AddChild();
			cm.m_MeshPath = "empire/planet.mesh";
			cm.m_Texture0 = C3D.GetTexture("empire/planet00.jpg");
			cm.m_FunBeforeDraw = DrawPlanetBefore;
		}*/
	}
	
	private static var m_MeshSphere:C3DMesh = null;
	private static var m_MeshSimple:C3DMesh = null;
	
	public static function MeshSphere(simple:Boolean = false):C3DMesh
	{
		var o:Object;
		if (simple) {
			if (m_MeshSimple != null) return m_MeshSimple;

			o = LoadManager.Self.Get("planet/simple.mesh");
			if (o != null && (o is ByteArray)) {
				(o as ByteArray).endian=Endian.LITTLE_ENDIAN;
				m_MeshSimple = new C3DMesh();
				m_MeshSimple.Init(o as ByteArray);
				m_MeshSimple.GraphPrepare();
				return m_MeshSimple;
			}
		} else {
			if (m_MeshSphere != null) return m_MeshSphere;

			o = LoadManager.Self.Get("planet/sphere.mesh");
			if (o != null && (o is ByteArray)) {
				(o as ByteArray).endian=Endian.LITTLE_ENDIAN;
				m_MeshSphere = new C3DMesh();
				m_MeshSphere.Init(o as ByteArray);
				m_MeshSphere.GraphPrepare();
				return m_MeshSphere;
			}
		}
		return null;
	}

	public function CalcPos():void
	{
		m_PosSmooth.GetB(HS.m_CurTime, HyperspaceBase.m_TPos);
		m_PosX = HyperspaceBase.m_TPos.x;
		m_PosY = HyperspaceBase.m_TPos.y;
		m_PosZ = HyperspaceBase.m_TPos.z;
	}

	public function DrawPrepare(dt:Number):void
	{
		var i:int, u:int;
		var obj:Object;

		if ((m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) return;
		//if (m_Model == null) return;

		if (m_Effect != null) {
			var offx:Number = m_PosX - HS.m_CamPos.x + HS.m_ZoneSize * (m_ZoneX - HS.m_CamZoneX);// - HS.m_View.x * 5.0;
			var offy:Number = m_PosY - HS.m_CamPos.y + HS.m_ZoneSize * (m_ZoneY - HS.m_CamZoneY);// - HS.m_View.y * 5.0;
			var offz:Number = m_PosZ - (HS.m_CamPos.z);// - HS.m_View.z * 5.0;
			
			m_Effect.SetPos(offx, offy, offz);
//			m_Effect.SetUp();
			m_Effect.GraphTakt(dt);
		}

/*
		var m:Matrix3D = new Matrix3D();
		m.identity();
		m.appendScale(m_Radius * 0.01, m_Radius * 0.01, m_Radius * 0.01);
		var a:Number = (Math.floor(EmpireMap.Self.m_CurTime) % 100000) / 100000.0 * 2.0 * Math.PI;
		m.appendRotation(a * Space.ToGrad, Vector3D.Z_AXIS);
		m.appendRotation(15.0, Vector3D.X_AXIS);
		m.appendRotation(45.0, Vector3D.Z_AXIS);
		m.appendTranslation(
			m_X - HS.m_CamPos.x + HS.SP.m_ZoneSize * (m_ZoneX - HS.m_CamZoneX),
			m_Y - HS.m_CamPos.y + HS.SP.m_ZoneSize * (m_ZoneY - HS.m_CamZoneY),
			m_Z - HS.m_CamPos.z);

		m_Model.CalcMatrix(m);
*/
	}

/*	public function DrawPlanetBefore(model:C3DModel, mwvp:Matrix3D):Boolean
	{
		var v:Vector3D;
		C3D.SetVConstMatrix(0, mwvp);
		
		v = model.m_MatrixWorldInv.deltaTransformVector(HS.m_LightPlanet);
		v.w = 0.0;
		v.normalize();
		C3D.SetFConst(2, v);

		v = model.m_MatrixWorldInv.transformVector(HS.m_View);
		v.w = 0.0;
		v.normalize();
		C3D.SetFConst_n(3, -v.x, -v.y, -v.z, 0.0);

		return true;
	}*/
	
	public function Draw():void
	{
		if ((m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) return;
//		if (!HyperspacePlanetStyle.prepare()) return;
		if (m_Style == 0) return;
		
		

//		if (m_Model == null) return;

/*
		var t_halo:C3DTexture = null;
		if (style.HaloBlend != 0) t_halo = C3D.GetTexture(style.HaloTexture);

		if (!m_Model.GraphPrepare()) return;
		if (t_halo != null && t_halo.tex == null) return;
		
//trace("DrawPlanet");

		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(1, 0.1, 1.0 / 0.4, 0.5, 10.0);
//		C3D.SetFConst_n(1, 0.0, 1.0 / 1.0, 1.0, 10.0);

		C3D.SetFConst_Color(5, 0xFF3F3030, 3.0); // 5-Ambient
		C3D.SetFConst_Color(6, 0xFF271414, 3.0); // 6-Diffuse
		C3D.SetFConst_Color(7, 0xFF190606, 3.0, 50.0); // 7-Reflection
		C3D.SetFConst_Color(8, HS.m_ShadowColor); // 8-Shadow 

		C3D.SetFConst_n(9, 0.5, 1.3, 0.5, 0.0); // 9-Gamma

		C3D.ShaderPlanet();
//C3D.Context.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		m_Model.Draw(HS.m_MatViewPer);
		
		var dx:Number = HS.m_View.x - offx;
		var dy:Number = HS.m_View.y - offy;
		var dz:Number = HS.m_View.z - offz;
		var d:Number = 1.0 / Math.sqrt(dx * dx + dy * dy + dz * dz);
		dx *= d;
		dy *= d;
		dz *= d;

		offx += dx * 20.0;
		offy += dy * 20.0;
		offz += dz * 20.0;*/

		var l:int;
		var layer:Object;
		var texture:C3DTexture;
		var light:Vector3D;
		var mesh:C3DMesh;

		var offx:Number = m_PosX - HS.m_CamPos.x + HS.m_ZoneSize * (m_ZoneX - HS.m_CamZoneX);// - HS.m_View.x * 5.0;
		var offy:Number = m_PosY - HS.m_CamPos.y + HS.m_ZoneSize * (m_ZoneY - HS.m_CamZoneY);// - HS.m_View.y * 5.0;
		var offz:Number = m_PosZ - (HS.m_CamPos.z);// - HS.m_View.z * 5.0;

		var style:Object = HyperspacePlanetStyle.m_Map[m_Style];

		var ok:Boolean = true;
		for (l = 0; l < style.Layer.length; l++) {
			layer = style.Layer[l];
			if (layer.Shader == HyperspacePlanetStyle.ShaderOff) continue;
			if(layer.Texture.length>0) {
				texture = C3D.GetTexture(layer.Texture);
				if (texture == null || texture.tex == null) ok = false;
			}
			if (layer.Shader == HyperspacePlanetStyle.ShaderSphere && MeshSphere() == null) ok = false;
			if (layer.Shader == HyperspacePlanetStyle.ShaderSimple && MeshSphere(true) == null) ok = false;
		}
		if (!ok) return;

		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(1, 0.1, 1.0 / 0.4, 0.5, 10.0);

		var vl:Vector3D = new Vector3D();
		var d:Number;

		var sundirx:Number = HS.m_View.x - offx;
		var sundiry:Number = HS.m_View.y - offy;
		var sundirz:Number = HS.m_View.z - offz;
		if (m_CenterId != 0) {
			var sun:HyperspacePlanet = this;
			while (sun.m_CenterId != 0) {
				sun = HS.HyperspacePlanetById(sun.m_CenterId);
				if (sun == null) break;
				if ((sun.m_PlanetFlag & SpacePlanet.FlagTypeMask) != SpacePlanet.FlagTypeSun) continue;

				sundirx = sun.m_PosX - m_PosX + HS.m_ZoneSize * (sun.m_ZoneX - m_ZoneX);
				sundiry = sun.m_PosY - m_PosY + HS.m_ZoneSize * (sun.m_ZoneY - m_ZoneY);
				d = Math.sqrt(sundirx * sundirx + sundiry * sundiry);
				sundirz = sun.m_PosZ - m_PosZ + d * 0.25;
				d = 1.0 / Math.sqrt(sundirx * sundirx + sundiry * sundiry + sundirz * sundirz);
				sundirx *= d; sundiry *= d; sundirz *= d;
				break;
			}
		}

		for (l = 0; l < style.Layer.length; l++) {
			layer = style.Layer[l];

			if (layer.Shader == HyperspacePlanetStyle.ShaderOff) continue;
			if (layer.Blend == HyperspacePlanetStyle.BlendOff) continue;
			if (C3D.m_Pass == C3D.PassZ && layer.Shader == HyperspacePlanetStyle.ShaderHalo) continue;
			
			if (layer.Texture.length <= 0) continue;

			texture = C3D.GetTexture(layer.Texture);
			if (texture == null) continue;

//			if (layer.Shader == HyperspacePlanetStyle.ShaderHalo) {
//			} else continue;

			if(layer.Blend==1) C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ); // alpha
			else if(layer.Blend==2) C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE ); // add
			else C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR ); // screen

			C3D.SetFConst_Color(5, layer.Ambient, 3.0);
			C3D.SetFConst_Color(6, layer.Diffuse, 3.0);
			C3D.SetFConst_Color(7, layer.Reflection | 0xff000000, 3.0, (1.0 - Number((layer.Reflection >> 24) & 255) / 255.0) * 50.0);
			C3D.SetFConst_Color(8, layer.Shadow);
			C3D.SetFConst_Gamma(9, layer.Gamma);
			C3D.SetFConst_TransformAlpha(10, layer.Alpha);

//C3D.Context.setDepthTest(false, Context3DCompareMode.ALWAYS);
			C3D.SetTexture(0, texture.tex);
			
			var r:Number = m_Radius * layer.RadiusMul;

			vl.x = HS.m_LightPlanet.x;
			vl.y = HS.m_LightPlanet.y;
			vl.z = HS.m_LightPlanet.z;
			if (layer.Light == HyperspacePlanetStyle.LightView) {
				vl.x = HS.m_View.x-offx;
				vl.y = HS.m_View.y-offy;
				vl.z = HS.m_View.z-offz;
				vl.normalize();
			} else if (layer.Light == HyperspacePlanetStyle.LightSun) {
				vl.x = sundirx;
				vl.y = sundiry;
				vl.z = sundirz;
			}

			if (layer.Shader == HyperspacePlanetStyle.ShaderHalo) {
				C3D.DrawHalo(HS.m_MatViewPer, HS.m_MatView, HS.m_MatViewInv, offx, offy, offz, r, layer.InnerSize, layer.OuterSize, layer.Color, true, vl, HS.m_View);

			} else if (layer.Shader == HyperspacePlanetStyle.ShaderSphere || layer.Shader == HyperspacePlanetStyle.ShaderSimple) {
				mesh = MeshSphere(layer.Shader == HyperspacePlanetStyle.ShaderSimple);

				C3D.SetFConst_Color(4, layer.Color);

				var m:Matrix3D = new Matrix3D();
				m.identity();
				m.appendScale(r * 0.01, r * 0.01, r * 0.01);
				var a:Number = Number(Math.floor(HS.m_CurTime) % Math.abs(layer.Period * 1000)) / Math.abs(layer.Period * 1000) * 2.0 * Math.PI;
				if (layer.Period < 0) a = -a;
				m.appendRotation((layer.Rotate + a) * Space.ToGrad, Vector3D.Z_AXIS);
				m.appendRotation(layer.AngleA, Vector3D.X_AXIS);
				m.appendRotation(layer.AngleB, Vector3D.Z_AXIS);
				m.appendTranslation(offx, offy, offz);

				var minv:Matrix3D = new Matrix3D();
				minv.copyFrom(m);
				minv.invert();

				m.append(HS.m_MatViewPer);

				C3D.SetVConstMatrix(0, m);
		
				var v:Vector3D;
				v = minv.deltaTransformVector(vl);
				v.w = 0.0;
				v.normalize();
				C3D.SetFConst(2, v);

				vl.x = HS.m_View.x-offx;
				vl.y = HS.m_View.y-offy;
				vl.z = HS.m_View.z-offz;
				v = minv.transformVector(vl);// HS.m_View);
				v.normalize();
				C3D.SetFConst_n(3, -v.x, -v.y, -v.z, 0.0);
				
				C3D.ShaderPlanet();
				C3D.VBMesh(mesh);
				C3D.DrawMesh();
			}

			C3D.SetTexture(0, null);
		}
		
		if (m_Effect != null) {
			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setDepthTest(false, Context3DCompareMode.LESS);
			m_Effect.Draw(HS.m_CurTime, HS.m_MatViewPer, HS.m_MatView, HS.m_MatViewInv, HS.m_FactorScr2WorldDist);
		}
	}
}
	
}