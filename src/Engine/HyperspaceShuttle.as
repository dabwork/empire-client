package Engine
{

import B3DEffect.Effect;
import Base.*;
import flash.display.*;
import flash.display3D.textures.Texture;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class HyperspaceShuttle extends HyperspaceEntity
{
	public var m_Tmp:int = 0;

	public var m_PFlag:uint = 0;

	public var m_PosSmooth:HyperspaceSmooth = new HyperspaceSmooth();
	public var m_AngleSmooth:HyperspaceSmooth = new HyperspaceSmooth();
	public var m_PitchSmooth:HyperspaceSmooth = new HyperspaceSmooth();
	public var m_RollSmooth:HyperspaceSmooth = new HyperspaceSmooth();

	public var m_Angle:Number = 0;		// курс		(rotate z)          matrix_roll*matrix_pitch*matrix_angle
	public var m_Pitch:Number = 0;		// тангаж	(rotate x)
	public var m_Roll:Number = 0;		// крен		(rotate y)

	public var m_State:uint = 0;
	public var m_StateTime:uint = 0;

	public var m_InDraw:Boolean = false;

	public var m_PlaceX:Number = 0;
	public var m_PlaceY:Number = 0;

	public var m_Model:C3DModel = null;

	public var m_EffectList:Vector.<Object> = new Vector.<Object>();

	public var m_ReadyEffect:Boolean = false;
	
	public var m_EngineOn:Boolean = false;
	public var m_EnginePower:Number = 0.0;
	
	public var m_Radius:Number = 0;
	public var m_ShadowLength:Number = 0.0;

	public var m_World:Matrix3D = new Matrix3D();
	public var m_WorldInv:Matrix3D = new Matrix3D();
	
	public var m_TextLine:C3DTextLine = new C3DTextLine();
	
	static public var m_TPos:Vector3D = new Vector3D();
	
	public function HyperspaceShuttle(hs:HyperspaceBase)
	{
		super(hs);
		
		m_TextLine.SetFont("big_outline");
		m_TextLine.SetColor(0xffffffff);
		m_TextLine.SetFormat(0);
	}	

	public function Clear():void
	{
		ClearGraph();
		
		m_TextLine.free();
	}
	
	public function ClearGraph():void
	{
		var i:int;

		if(m_Model!=null) {
			m_Model.Clear();
			m_Model = null;
		}
		for (i = 0; i < m_EffectList.length; i++) {
			var obj:Object = m_EffectList[i];
			if (obj.m_Effect != null) {
				if (obj.m_Effect is Effect) (obj.m_Effect as Effect).Clear();
			}
			m_EffectList[i] = null;
		}
		m_EffectList.length = 0;
		m_ReadyEffect = false;
	}

	public function SetText(str:String):void
	{
		m_TextLine.SetText(str);
	}

	public function SetFormation():void
	{
		ClearGraph();

		var cm:C3DModel;

		m_Model = new C3DModel();
		cm = m_Model.AddChild();
		cm.m_MeshPath = "Shuttle/part.mesh";
		cm.m_Texture0 = C3D.GetTexture("Shuttle/dif.jpg");
		cm.m_Texture1 = C3D.GetTexture("Shuttle/lum.png");
		cm.m_Texture2 = C3D.GetTexture("Shuttle/clr.jpg");
		cm.m_Flag |= C3DModel.FlagMeshShadow;
		cm.m_FunBeforeDraw = DrawShipBefore;
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
	
	public function CreateEffect(model:C3DModel = null):void
	{
		var i:int, u:int;
		var obj:Object;
		var m:Matrix3D;

		if (model == null) model = m_Model;
		if (model == null) return;

		if (model.m_Mesh != null) {
			for (i = 0; i < model.m_Mesh.m_ConnectCnt; i++) {
				u = model.m_Mesh.ConnectId(i);

				if (u == 0x100 || u == 0x101 || u == 0x102 || u == 0x103) {
//continue;
					obj = new Object();
					m_EffectList.push(obj);

					obj.m_Effect = new Effect();
					obj.m_Effect.Run("engine0");

					//obj.m_Effect = new HyperspaceEngine();
					if (u == 0x100) obj.m_Size = 0.9;
					else obj.m_Size = 0.5;
					obj.m_First = true;

					u = model.m_Mesh.Connect(i, 0);
					if (u < 0) continue;

					m = model.m_Mesh.m_Matrix[u];

					obj.m_Pos = m.transformVector(new Vector3D(0.0, 0.0, 0.0));
					obj.m_Dir = m.deltaTransformVector(new Vector3D(0.0, 1.0, 0.0));
				}
			}
		}
		
		if(model.m_Child!=null) {
			for (i = 0; i < model.m_Child.length; i++) {
				if (model.m_Child[i] == null) continue;
				CreateEffect(model.m_Child[i]);
			}
		}
	}
	
	public function Update(ship:SpaceShip):void
	{
		m_PFlag = ship.m_PFlag;

		m_EngineOn = (ship.m_SpeedMoveX * ship.m_SpeedMoveX + ship.m_SpeedMoveY * ship.m_SpeedMoveY + ship.m_SpeedMoveZ * ship.m_SpeedMoveZ) > 0.5;
		if (ship.m_PFlag & (SpaceShip.PFlagInOrbitCotl | SpaceShip.PFlagInOrbitPlanet)) m_EngineOn = false;

		if (m_ZoneX != ship.m_ZoneX || m_ZoneY != ship.m_ZoneY) m_PosSmooth.AddOffset(HS.SP.m_ZoneSize * (m_ZoneX - ship.m_ZoneX), HS.SP.m_ZoneSize * (m_ZoneY - ship.m_ZoneY), 0.0);
		m_ZoneX = ship.m_ZoneX;
		m_ZoneY = ship.m_ZoneY;
		m_PosSmooth.Add(HS.m_CurTime + 200, ship.m_PosX, ship.m_PosY, ship.m_PosZ);

		m_AngleSmooth.Add(HS.m_CurTime + 200, ship.m_Angle);
		m_PitchSmooth.Add(HS.m_CurTime + 200, ship.m_Pitch);
		m_RollSmooth.Add(HS.m_CurTime + 200, ship.m_Roll);

		m_PlaceX = ship.m_PlaceX;
		m_PlaceY = ship.m_PlaceY;

		var prevstate:uint = m_State;
		m_State = ship.m_State;
		m_StateTime = ship.m_StateTime;

		m_Radius = ship.m_Radius;
	}

	public function CalcPos():void
	{
		m_PosSmooth.GetB(HS.m_CurTime, HyperspaceBase.m_TPos);
		m_PosX = HyperspaceBase.m_TPos.x;
		m_PosY = HyperspaceBase.m_TPos.y;
		m_PosZ = HyperspaceBase.m_TPos.z;
		m_Angle = m_AngleSmooth.GetAngle(HS.m_CurTime);
		m_Pitch = m_PitchSmooth.GetAngle(HS.m_CurTime);
		m_Roll = m_RollSmooth.GetAngle(HS.m_CurTime);
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
	}

	public function IsReadyForDraw():Boolean
	{
		if (m_Model == null) return false;
		if (!m_Model.GraphPrepare()) return false;
		if ((m_State & SpaceShip.StateLive) == 0 && (m_State & SpaceShip.StateDestroy) == 0) return false;
		return true;
	}
	
	public function DrawPrepare(dt:Number):void
	{
		var i:int, u:int;
		var obj:Object;

		m_Model.CalcMatrix(m_World);

		if (m_EngineOn) {
			if (m_EnginePower < 1.0) m_EnginePower = Math.min(1.0, m_EnginePower + 0.001 * dt);
		} else {
			if (m_EnginePower > 0.0) m_EnginePower = Math.max(0.0, m_EnginePower - 0.001 * dt);
		}

		var upsrc:Vector3D = m_World.transformVector(new Vector3D(0.0, 0.0, 1.0));

		if (!m_ReadyEffect && IsMeshLoaded()) {
			m_ReadyEffect = true;
			CreateEffect();
		}
		
		var pos:Vector3D;
		var dir:Vector3D;

		for (i = 0; i < m_EffectList.length; i++) {
			obj = m_EffectList[i];
			if (obj.m_Effect is Effect) {
				pos = m_World.transformVector(obj.m_Pos);
				dir = m_World.deltaTransformVector(obj.m_Dir);

				var ef:Effect = obj.m_Effect as Effect;
				if (obj.Matx == undefined) obj.Matx = new Matrix3D();
				var mat:Matrix3D = obj.Matx;

				ef.SetDir(dir.x, dir.y, dir.z);
				ef.SetUp(upsrc.x, upsrc.y, upsrc.z);
				//ef.SetNormal(dir.x, dir.y, dir.z);
				ef.SetPathDist(100);
				ef.SetPos(pos.x, pos.y, pos.z);
				ef.SetA(obj.m_Size);
				ef.SetB(m_EnginePower * 0.5 * Math.min(3.0, 1.0/*m_Forsage*/));

				var dirx:Vector3D = dir.crossProduct(upsrc);
				dirx.normalize();
				var up:Vector3D = dir.crossProduct(dirx);
				up.normalize();

				var m:Matrix3D = new Matrix3D();
				m.copyFrom(mat);

				mat.copyRawDataFrom(new <Number>[
					dirx.x, dirx.y, dirx.z, 0.0,
					up.x, up.y, up.z, 0.0,
					dir.x, dir.y, dir.z, 0.0,
					0.0, 0.0, 0.0, 1.0]);

				if (obj.m_First) {
					obj.m_First = false;
					(obj.m_Effect as Effect).GraphTakt(2000);
				} else {
					var mi:Matrix3D = new Matrix3D();
					mi.copyFrom(mat);
					mi.invert();
					m.append(mi);

					ef.ParticleDirMulMatrix(m,2);
				}
				(obj.m_Effect as Effect).GraphTakt(dt);

			} else if (obj.m_Effect is HyperspaceEngine) {
				pos = m_World.transformVector(obj.m_Pos);
				pos.x += HS.m_CamPos.x;
				pos.y += HS.m_CamPos.y;
				pos.z += HS.m_CamPos.z;
				dir = m_World.deltaTransformVector(obj.m_Dir);

				HyperspaceEngine(obj.m_Effect).Init(pos.x,pos.y,pos.z,
					dir.x, dir.y, dir.z,
					upsrc.x, upsrc.y, upsrc.z,
					obj.m_Size, m_EnginePower, /*m_Forsage*/1.0 - 1.0, 0xffffffff);
				if (obj.m_First) {
					obj.m_First = false;
					for (u = 0; u < 50; u++) HyperspaceEngine(obj.m_Effect).Takt(20);	
				}
				HyperspaceEngine(obj.m_Effect).Takt(dt);
			}
		}
	}
	
	public function DrawShipBefore(model:C3DModel, mwvp:Matrix3D):Boolean
	{
		var v:Vector3D;

		C3D.SetVConstMatrix(0, mwvp);

		if(C3D.m_Pass==C3D.PassDif || C3D.m_Pass==C3D.PassDifShadow || C3D.m_Pass==C3D.PassShadow) {
			v = model.m_MatrixWorldInv.deltaTransformVector(HS.m_Light);
			v.w = 0.0;
			v.normalize();
			C3D.SetVConst(4, v);

			if (C3D.m_Pass == C3D.PassShadow) {
				v.x = -v.x * m_ShadowLength;
				v.y = -v.y * m_ShadowLength;
				v.z = -v.z * m_ShadowLength;
				C3D.SetVConst(5, v);
			}
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
//			if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;
			
			C3D.SetVConst(6, new Vector3D(0.0, 0.5, 1.0, 2.0));
			C3D.SetFConst(1, new Vector3D(0.0, 0.5, 1.0, 2.0));

			C3D.ShaderMeshShadow();
			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassZ) {
//			if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;
			
			C3D.ShaderShip(false, false, false);
			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassDif || C3D.m_Pass == C3D.PassDifShadow) {
//			if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;
			
			C3D.SetVConst(6, new Vector3D(0.0, 0.5, 1.0, 2.0));
			C3D.SetVConst(7, new Vector3D(0.1, 1.0 / 0.4, 0.5, 10.0));

			C3D.SetFConst(1, new Vector3D(0.0, 0.5, 1.0, 2.0));
			C3D.SetFConst(2, new Vector3D(0.1, 1.0 / 0.4, 0.5, 10.0));

			C3D.SetFConst_Color(4, 0xFF00496B); // 4-Color
			C3D.SetFConst_Color(5, 0xFF7B7B7B,3.0); // 5-Ambient
			C3D.SetFConst_Color(6, 0xFF6B6252,3.0); // 6-Diffuse
			C3D.SetFConst_Color(7, 0xFF564F35,3.0); // 7-Reflection
			C3D.SetFConst_Color(8, HS.m_ShadowColor); // 8-Shadow

			C3D.ShaderShip(true, C3D.m_Pass == C3D.PassDif, false);
			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassLum) {
//			if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;
			
			C3D.ShaderShip(false, false, true);
			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassParticle) {
			var i:int;
			var obj:Object;

			for (i = 0; i < m_EffectList.length; i++) {
//				if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) break;

				obj = m_EffectList[i];
				if (obj.m_Effect is Effect) {
					(obj.m_Effect as Effect).Draw(HS.m_CurTime, HS.m_MatViewPer, HS.m_MatView, HS.m_MatViewInv, HS.m_FactorScr2WorldDist);
				} else if (obj.m_Effect is HyperspaceEngine) {
					HyperspaceEngine(obj.m_Effect).Draw();
				}
			}
		}
	}

	public function DrawText():void
	{
		var v:Number;
		var tex:C3DTexture;

//		if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;

		var offx:Number = m_PosX - HS.m_CamPos.x + HS.m_ZoneSize * (m_ZoneX - HS.m_CamZoneX);
		var offy:Number = m_PosY - HS.m_CamPos.y + HS.m_ZoneSize * (m_ZoneY - HS.m_CamZoneY);
		var offz:Number = m_PosZ - (HS.m_CamPos.z);

		offy -= m_Radius * 0.8;
		m_TPos.x = offx;
		m_TPos.y = offy;
		m_TPos.z = offz;
		//var v:Vector3D = new Vector3D(offx, offy, offz);
		HS.WorldToScreen(m_TPos);
		m_TextLine.Prepare();
		if(m_TextLine.m_Font!=null) {
			m_TextLine.Draw(0, -1, m_TPos.x, m_TPos.y - (m_TextLine.m_Font.lineHeight >> 1), 0, 1);
		}
	}
}
	
}