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

CONFIG::air {
import flash.filesystem.*;
import flash.filesystem.File;
import flash.filesystem.FileStream;
import flash.filesystem.FileMode;
}

public class HyperspaceFleet extends HyperspaceEntity
{
//	public var m_FleetId:int=0;
	public var m_CotlId:uint = 0;
	public var m_Owner:uint = 0;
	public var m_Union:uint = 0;

	public var m_PFlag:uint = 0;
	
	public var m_Order:uint = 0;

//	public var m_BG:Sprite=null;
//	public var m_Name:TextField=null;

	public var m_Tmp:int = 0;
	
//	public var m_ZoneX:int = 0;
//	public var m_ZoneY:int = 0;

	public var m_PosSmooth:HyperspaceSmooth = new HyperspaceSmooth();
	public var m_AngleSmooth:HyperspaceSmooth = new HyperspaceSmooth();
	public var m_PitchSmooth:HyperspaceSmooth = new HyperspaceSmooth();
	public var m_RollSmooth:HyperspaceSmooth = new HyperspaceSmooth();

//	public var m_X:Number = 0;
//	public var m_Y:Number = 0;
//	public var m_Z:Number = 0;
	public var m_Angle:Number = 0;		// курс		(rotate z)          matrix_roll*matrix_pitch*matrix_angle
	public var m_Pitch:Number = 0;		// тангаж	(rotate x)
	public var m_Roll:Number = 0;		// крен		(rotate y)
	public var m_Forsage:Number = 1.0;
	
	public var m_HP:int = 0;
	public var m_Shield:int = 0;
	public var m_State:uint = 0;
	public var m_StateTime:uint = 0;

	public var m_InDraw:Boolean = false;

	//// m_Target* - нужно только для того чтобы передать на сервер команду. Не участвует в расчетах.
	////public var m_TargetX:Number = 0;
	////public var m_TargetY:Number = 0;
	public var m_TargetType:int = 0;
	public var m_TargetId:uint = 0;

	public var m_PlaceX:Number = 0;
	public var m_PlaceY:Number = 0;

	public var m_OldTargetX:int = -2000000000;
	public var m_OldTargetY:int = -2000000000;

	public var m_Formation:int = -1;

	public var m_CorrectTime:Number = 0;
	
	public var m_OnOrbitId:uint = 0;
	
	public var m_AimX:Number = 0;
	public var m_AimY:Number = 0;
	
	public var m_Model:C3DModel = null;

	public var m_EffectList:Vector.<Object> = new Vector.<Object>();

	public var m_ReadyWeapon:Boolean = false;
	public var m_ReadyEffect:Boolean = false;

	public var m_EngineOn:Boolean = false;
//	bool m_EngineOff;
	public var m_EnginePower:Number = 0.0;
	
	public var m_Radius:Number = 0;
	public var m_ShadowLength:Number = 0.0;

	public var m_TextLine:C3DTextLine = new C3DTextLine();

	public static var m_HitMesh:Dictionary = new Dictionary();

	public var m_WeaponList:Vector.<HyperspaceWeapon> = new Vector.<HyperspaceWeapon>();
	
	public var m_World:Matrix3D = new Matrix3D();
	public var m_WorldInv:Matrix3D = new Matrix3D();
	
	public var m_ExplosionTime:Number = -1;
	public var m_Explosion:Effect = null;

	static public var m_TPos:Vector3D = new Vector3D();

	public function HyperspaceFleet(hs:HyperspaceBase)
	{
		super(hs);
		//m_Map.m_Hyperspace.m_FleetList.push(this);
		
		//m_BG=new Fleet2();
		//m_BG.blendMode=BlendMode.OVERLAY;
		//addChild(m_BG);
		
		m_Formation = -1;

		m_TextLine.SetFont("big_outline");
		m_TextLine.SetColor(0xffffffff);
		m_TextLine.SetFormat(0);

/*		m_Name=new TextField();
		m_Name.width=1;
		m_Name.height=1;
		m_Name.type=TextFieldType.DYNAMIC;
		m_Name.selectable=false;
		m_Name.textColor=0x753d13;
		m_Name.background=true;
		m_Name.backgroundColor=0x80000000;
		m_Name.alpha=0.8;
		m_Name.multiline=false;
		m_Name.autoSize=TextFieldAutoSize.LEFT;
		m_Name.gridFitType=GridFitType.NONE;
		m_Name.defaultTextFormat=new TextFormat("Calibri",12,0xffff13);
		m_Name.embedFonts=true;
		m_Name.visible=false;
		addChild(m_Name);*/
	}
	
	public function Clear():void
	{
		ClearGraph();
		
		m_TextLine.free();
	}
	
	public function ClearGraph():void
	{
		var i:int;
		var w:HyperspaceWeapon;

		//var sme:int = m_Map.m_Hyperspace.m_FleetList.indexOf(this);
		//if(sme>=0) m_Map.m_Hyperspace.m_FleetList.splice(sme,1);
		
		for (i = 0; i < m_WeaponList.length; i++) {
			w = m_WeaponList[i];
			w.m_Model = null;
			if (w.m_Bullet != null) { HS.BulletDel(w.m_Bullet); w.m_Bullet = null; }
		}
		m_WeaponList.length = 0;

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
		m_ReadyWeapon = false;
		m_ReadyEffect = false;
	}

	public function SetText(str:String):void
	{
		m_TextLine.SetText(str);
	}
	
	public function SetFormation(i:int):void
	{
		if (m_Formation == i) return;
		m_Formation = i;
		
		var obj:Object;
		
//		if (m_BG != null) {
//			removeChild(m_BG);
//			m_BG = null;
//		}

		ClearGraph();
		
		var cm:C3DModel;

//		if (m_Map.m_Set_3D) {
		if(1) {
			m_Model = new C3DModel();
			cm = m_Model.AddChild();
			cm.m_MeshPath = "ship1/p1.mesh";
			cm.m_Texture0 = C3D.GetTexture("ship1/dif.png");
			cm.m_Texture1 = C3D.GetTexture("ship1/lum.png");
			cm.m_Texture2 = C3D.GetTexture("ship1/clr.jpg");
			cm.m_Flag |= C3DModel.FlagMeshShadow;
			cm.m_FunBeforeDraw = DrawShipBefore;

			cm = m_Model.AddChild();
			cm.m_MeshPath = "ship1/p2.mesh";
			cm.m_Texture0 = C3D.GetTexture("ship1/dif.png");
			cm.m_Texture1 = C3D.GetTexture("ship1/lum.png");
			cm.m_Texture2 = C3D.GetTexture("ship1/clr.jpg");
			cm.m_FunBeforeDraw = DrawShipBefore;
			cm.m_Flag |= C3DModel.FlagMeshShadow;

			cm = m_Model.AddChild();
			cm.m_MeshPath = "ship1/p3.mesh";
			cm.m_Texture0 = C3D.GetTexture("ship1/dif.png");
			cm.m_Texture1 = C3D.GetTexture("ship1/lum.png");
			cm.m_Texture2 = C3D.GetTexture("ship1/clr.jpg");
			cm.m_FunBeforeDraw = DrawShipBefore;
			cm.m_Flag |= C3DModel.FlagMeshShadow;
			
			AddWeapon(0x200);
			AddWeapon(0x201);
			AddWeapon(0x202);
		}
/*		if (1) {
			m_Model = new C3DModel();
			cm = m_Model.AddChild();
			cm.m_MeshPath = "ShipDrone/p1.mesh";
			cm.m_Texture0 = C3D.GetTexture("ShipDrone/dif.jpg");
			cm.m_Texture1 = C3D.GetTexture("ShipDrone/lum.dds");
			cm.m_Texture2 = C3D.GetTexture("empty");
			cm.m_Flag |= C3DModel.FlagMeshShadow;
			cm.m_FunBeforeDraw = DrawShipBefore;

			AddWeapon(0x200);
		}*/

//			var cm:C3DModel = m_Model.AddChild();
//			cm.m_MeshPath = "empire/Ship1/test_Torus.mesh";
//			cm.m_FunBeforeDraw = DrawShipBefore;

/*			obj = new Object();
			m_EffectList.push(obj);
			obj.m_Prepare = false;
			obj.m_Effect = new HyperspaceEngine();
			obj.m_Size = 1.5;
			obj.m_ConnectId = 0x100;
			obj.m_First = true;*/

/*			obj = new Object();
			m_EffectList.push(obj);
			obj.m_Prepare = false;
			obj.m_Effect = new HyperspaceEngine();
			obj.m_Size = 1.1;
			obj.m_ConnectId = 0x101;
			obj.m_First = true;*/

/*			obj = new Object();
			m_EffectList.push(obj);
			obj.m_Prepare = false;
			obj.m_Effect = new HyperspaceEngine();
			obj.m_Size = 1.1;
			obj.m_ConnectId = 0x102;
			obj.m_First = true;*/

/*		} else {
			var str:String = "";
			if (m_Formation == 0) str = "Fleet0";
			else if (m_Formation == 1) str = "Fleet1";
			else if (m_Formation == 2) str = "Fleet2";
			else if (m_Formation == 3) str = "Fleet3";
			else if (m_Formation == 4) str = "Fleet4";
			if (str.length <= 0) return;

			var cl:Class = ApplicationDomain.currentDomain.getDefinition(str) as Class;
			m_BG = new cl();
			addChildAt(m_BG, 0);
		}*/
	}

/*	public var m_WeaponModel:C3DModel = null;

	public function CreateWeapon():void
	{
		var cm:C3DModel;
		cm = FindModelByConnectId(0x200);
		if (cm != null) {
			m_WeaponModel = AddWeapon(cm,0x200);
		}
		cm = FindModelByConnectId(0x201);
		if (cm != null) {
			m_WeaponModel = AddWeapon(cm,0x201);
		}
		cm = FindModelByConnectId(0x202);
		if (cm != null) {
			m_WeaponModel = AddWeapon(cm,0x202);
		}
	}*/

	public function AddWeapon(connectid:uint, defaultangle:Number = 0.0):void
	{
		var w:HyperspaceWeapon = new HyperspaceWeapon();
		m_WeaponList.push(w);
		w.m_ConnectId = connectid;
		w.m_DeafultAngle = defaultangle;
	}
	
	public function PrepareWeapon():Boolean
	{
		var w:HyperspaceWeapon;
		var model:C3DModel;
		var cm:C3DModel;
		var cmb:C3DModel;
		var i:int, no:int;
		var v:Vector3D;
		var ret:Boolean = true;
		for (i = 0; i < m_WeaponList.length; i++) {
			w = m_WeaponList[i];
			if (w.m_InitBarel) continue;

			if (w.m_Model == null) {
				model = FindModelByConnectId(w.m_ConnectId);
				if (model == null) { ret = false; continue; }
				
				no = model.m_Mesh.ConnectById(w.m_ConnectId);
				no = model.m_Mesh.Connect(no, 0);
				if (no < 0) throw Error("PrepareWeapon");

				v = model.m_Mesh.m_Matrix[no].transformVector(new Vector3D(0.0, 0.0, 0.0));
				w.m_PosX = v.x;
				w.m_PosY = v.y;
				w.m_PosZ = v.z;

				cm = model.AddChild();
				cm.m_MeshPath = "weapon1/p1.mesh";
				cm.m_Texture0 = C3D.GetTexture("weapon1/dif.png");
				cm.m_Texture1 = C3D.GetTexture("empty");
				cm.m_Texture2 = C3D.GetTexture("empty");
				cm.m_FunBeforeDraw = DrawShipBefore;
				cm.m_Flag |= C3DModel.FlagMeshShadow;
				cm.m_ConnectId = w.m_ConnectId;
				w.m_Model = cm;

				cmb = cm.AddChild();
				cmb.m_MeshPath = "weapon1/p2.mesh";
				cmb.m_Texture0 = C3D.GetTexture("weapon1/dif.png");
				cmb.m_Texture1 = C3D.GetTexture("empty");
				cmb.m_Texture2 = C3D.GetTexture("empty");
				cmb.m_FunBeforeDraw = DrawShipBefore;
				cmb.m_Flag |= C3DModel.FlagMeshShadow;
				cmb.m_ConnectId = 0x10768;
			}

			if (w.m_Model==null) { ret = false; continue; }
			if (!w.m_Model.GraphPrepare()) { ret = false; continue; }

			no = w.m_Model.m_Mesh.ConnectById(0x10768);
			no = w.m_Model.m_Mesh.Connect(no, 0);
			if (no < 0) { ret = false; continue; }

			v = w.m_Model.m_Mesh.m_Matrix[no].transformVector(new Vector3D(0.0, 0.0, 0.0));
			w.m_BarrelPosX = v.x;
			w.m_BarrelPosY = v.y;
			w.m_BarrelPosZ = v.z;

			if (w.m_Model.m_Child.length <= 0) { ret = false; continue; }
			model = w.m_Model.m_Child[0];
			no = model.m_Mesh.ConnectById(0x1076A);
			no = model.m_Mesh.Connect(no, 0);
			if (no < 0) { ret = false; continue; }

			v = model.m_Mesh.m_Matrix[no].transformVector(new Vector3D(0.0, 0.0, 0.0));
			w.m_BarrelLen = Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
			w.m_BarrelDirX = v.x / w.m_BarrelLen;
			w.m_BarrelDirY = v.y / w.m_BarrelLen;
			w.m_BarrelDirZ = v.z / w.m_BarrelLen;

			w.m_InitBarel = true;
		}
		return ret;
	}

	public function FindModelByConnectId(connectid:uint, model:C3DModel=null):C3DModel
	{
		if (model == null) model = m_Model;
		if (model == null) return null;
		
		var i:int,no:int;
		
		if(model.m_Mesh!=null) {
			no = model.m_Mesh.ConnectById(connectid);
			if (no >= 0) return model;
		}
		if(model.m_Child!=null) {
			for (i = 0; i < model.m_Child.length; i++) {
				if (model.m_Child[i] == null) continue;
				var model2:C3DModel=FindModelByConnectId(connectid, model.m_Child[i]);
				if (model2 != null) return model2;
			}
		}
		return null;
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
					if (u == 0x100) obj.m_Size = 1.5;
					else obj.m_Size = 0.9;
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

	public function SetName(str:String):void
	{
		if(str==null) str='';
//		if(m_Name.text==str) return;
//		m_Name.text=str;
//		m_Name.visible=str.length>0;
	}

	public function Update(ship:SpaceShip):void// fleet:FleetDyn = null):void
	{
		m_PFlag = ship.m_PFlag;
		m_Order = ship.m_Order;

		//m_EngineOn = ((ship.m_DesX - ship.m_PosX) * (ship.m_DesX - ship.m_PosX) + (ship.m_DesY - ship.m_PosY) * (ship.m_DesY - ship.m_PosY) + (ship.m_DesZ - ship.m_PosZ) * (ship.m_DesZ - ship.m_PosZ)) > 200.0;
		m_EngineOn = (ship.m_SpeedMoveX * ship.m_SpeedMoveX + ship.m_SpeedMoveY * ship.m_SpeedMoveY + ship.m_SpeedMoveZ * ship.m_SpeedMoveZ) > 0.5;
		if (ship.m_PFlag & (SpaceShip.PFlagInOrbitCotl | SpaceShip.PFlagInOrbitPlanet)) m_EngineOn = false;
		//m_ZoneX = ship.m_ZoneX;
		//m_ZoneY = ship.m_ZoneY;

		if (m_ZoneX != ship.m_ZoneX || m_ZoneY != ship.m_ZoneY) m_PosSmooth.AddOffset(HS.SP.m_ZoneSize * (m_ZoneX - ship.m_ZoneX), HS.SP.m_ZoneSize * (m_ZoneY - ship.m_ZoneY), 0.0);
		m_ZoneX = ship.m_ZoneX;
		m_ZoneY = ship.m_ZoneY;
//trace((HS.m_CurTime + 200).toString() + "\t" + ship.m_PosX.toString() + "\t" + ship.m_PosY.toString() + "\t" + ship.m_PosZ);
		m_PosSmooth.Add(HS.m_CurTime + 200, ship.m_PosX, ship.m_PosY, ship.m_PosZ);

		m_AngleSmooth.Add(HS.m_CurTime + 200, ship.m_Angle);
		m_PitchSmooth.Add(HS.m_CurTime + 200, ship.m_Pitch);
		m_RollSmooth.Add(HS.m_CurTime + 200, ship.m_Roll);

		m_TargetType = ship.m_TargetType;
		m_TargetId = ship.m_TargetId;

		m_PlaceX = ship.m_PlaceX;
		m_PlaceY = ship.m_PlaceY;

		var prevstate:uint = m_State;
		m_HP = ship.m_HP;
		m_Shield = ship.m_Shield;
		m_State = ship.m_State;
		m_StateTime = ship.m_StateTime;

		if (m_State & SpaceShip.StateDestroy) {
			if (m_ExplosionTime < 0) {
				m_ExplosionTime = HS.m_CurTime;
				if (m_Explosion != null) { m_Explosion.Clear(); m_Explosion = null; }
				if((prevstate & SpaceShip.StateLive) != 0) {
					m_Explosion = new Effect();
					m_Explosion.Run("expl0");
				} else {
					m_State &= ~SpaceShip.StateDestroy;
				}
			} else if (m_Explosion == null) {
				m_State &= ~SpaceShip.StateDestroy;
			}
		} else {
			m_ExplosionTime = -1;
			if (m_Explosion != null) { m_Explosion.Clear(); m_Explosion = null; }
		}

//		m_X = ship.m_PosX;
//		m_Y = ship.m_PosY;
//		m_Z = ship.m_PosZ;
//		m_Angle = ship.m_Angle;
//		m_Pitch = ship.m_Pitch;
//		m_Roll = ship.m_Roll;
		
		m_Forsage = ship.m_Forsage;
		//m_TargetX = ship.m_PlaceX;
		//m_TargetY = ship.m_PlaceY;
		
		m_Owner = ship.m_Owner;
		m_Union = ship.m_Union;
		
		m_Radius = ship.m_Radius;

//		x = m_Map.m_Hyperspace.WorldToMapX(m_X);
//		y = m_Map.m_Hyperspace.WorldToMapY(m_Y);
/*		if(m_BG!=null) {
			m_BG.rotation = m_Angle * 180.0 / Math.PI;
			if (m_TargetType == Common.FleetActionStealth || m_TargetType==Common.FleetActionCombat || m_TargetType==Common.FleetActionJump) {
				m_BG.alpha = 0.6;
			} else {
				m_BG.alpha = 1.0;
			}
		}

		if(m_Name.visible) {
			m_Name.x=-(m_Name.width>>1);
			m_Name.y=20;
		}

		if(m_Map.m_Debug) {
			graphics.clear();
			
			var fd:FleetDyn = m_Map.m_Hyperspace.FleetDynById(m_FleetId);
			if (fd != null) {
				graphics.lineStyle(8.0, 0xffff, 0.5);
				var tx:Number = m_Map.m_Hyperspace.WorldToMapX(fd.m_X);
				var ty:Number = m_Map.m_Hyperspace.WorldToMapY(fd.m_Y);
				graphics.moveTo(tx - x, ty - y);
				tx = m_Map.m_Hyperspace.WorldToMapX(fd.m_TgtX);
				ty = m_Map.m_Hyperspace.WorldToMapY(fd.m_TgtY);
				graphics.lineTo(tx - x, ty - y);
	//trace(fd.m_X, fd.m_Y, fd.m_TgtX, fd.m_TgtY);
			}

			graphics.lineStyle(4.0, 0x0000ff, 0.5);
			graphics.moveTo(0, 0);
			graphics.lineTo(m_TargetX - m_X, m_TargetY - m_Y);
			
			graphics.lineStyle(2.0, 0xff0000, 0.5);
			graphics.moveTo(0, 0);
			graphics.lineTo(m_AimX - m_X, m_AimY - m_Y);
		}*/
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
		var i:int;
		var w:HyperspaceWeapon;
		var he:HyperspaceEntity;
		var v:Vector3D;
		var aim_px:Number, aim_py:Number, aim_pz:Number;
		var aim_dx:Number, aim_dy:Number, aim_dz:Number;
		var tpx:Number, tpy:Number, tpz:Number;
		var r:Number, angle1need:Number, angle2need:Number;
		var sa:Number, ad:Number;
		var fire_ok:Boolean;

		for (i = 0; i < m_WeaponList.length; i++) {
			w = m_WeaponList[i];

			angle1need = w.m_DeafultAngle;
			angle2need = 0.0;
			fire_ok = false;

			if (m_TargetType == 0 && w.m_AimTargetType != 0) { w.m_AimTargetType = 0; w.m_AimTargetId = 0; } 

			while (w.m_InitBarel) {
				he = HS.HyperspaceEntityById(m_TargetType, m_TargetId);
				if (he == null) break;
				
				if ((m_TargetType != w.m_AimTargetType || m_TargetId != w.m_AimTargetId) && he.m_EntityType == SpaceEntity.TypeFleet) {
					(he as HyperspaceFleet).CalcAimPoint(0.0, 0.0, 0.0, m_TPos);
					w.m_AimTargetType = m_TargetType;
					w.m_AimTargetId = m_TargetId;
					w.m_AimPosX = m_TPos.x;
					w.m_AimPosY = m_TPos.y;
					w.m_AimPosZ = m_TPos.z;
					(he as HyperspaceFleet).CalcAimPoint(w.m_AimPosX, w.m_AimPosY, w.m_AimPosZ, m_TPos);
					w.m_AimToX = m_TPos.x;
					w.m_AimToY = m_TPos.y;
					w.m_AimToZ = m_TPos.z;
				}
				
				if (he.m_EntityType == SpaceEntity.TypeFleet) {
					tpx = w.m_AimToX - w.m_AimPosX;
					tpy = w.m_AimToY - w.m_AimPosY;
					tpz = w.m_AimToZ - w.m_AimPosZ;
					ad = tpx * tpx + tpy * tpy + tpz * tpz;
					sa = step * 0.02;
					if (ad < sa * sa) {
						(he as HyperspaceFleet).CalcAimPoint(w.m_AimPosX, w.m_AimPosY, w.m_AimPosZ, m_TPos);
						w.m_AimToX = m_TPos.x;
						w.m_AimToY = m_TPos.y;
						w.m_AimToZ = m_TPos.z;
					} else {
						ad = sa / Math.sqrt(ad);
						w.m_AimPosX += tpx * ad;
						w.m_AimPosY += tpy * ad;
						w.m_AimPosZ += tpz * ad;
					}

					m_TPos.x = w.m_AimPosX;
					m_TPos.y = w.m_AimPosY;
					m_TPos.z = w.m_AimPosZ;
					v = (he as HyperspaceFleet).m_World.transformVector(m_TPos);
					m_TPos.x = v.x;
					m_TPos.y = v.y;
					m_TPos.z = v.z;
				} else {
					m_TPos.x = he.m_PosX - m_PosX + HS.SP.m_ZoneSize * (he.m_ZoneX - m_ZoneX);
					m_TPos.y = he.m_PosY - m_PosY + HS.SP.m_ZoneSize * (he.m_ZoneY - m_ZoneY);
					m_TPos.z = he.m_PosZ - m_PosZ;
				}
				v = m_WorldInv.transformVector(m_TPos);
				aim_px = v.x; aim_py = v.y; aim_pz = v.z;

				//HyperHS.SP.m_TPos.x = he.m_PosX - m_PosX + HS.SP.m_ZoneSize * (he.m_ZoneX - m_ZoneX);
				//HyperHS.SP.m_TPos.y = he.m_PosY - m_PosY + HS.SP.m_ZoneSize * (he.m_ZoneY - m_ZoneY);
				//HyperHS.SP.m_TPos.z = he.m_PosZ - m_PosZ + HS.SP.m_ZoneSize * (he.m_ZoneZ - m_ZoneZ);
				//v = m_WorldInv.deltaTransformVector(HyperHS.SP.m_TPos);
				//aim_dx = v.x; aim_dy = v.y; aim_dz = v.z;

				tpx = he.m_PosX - m_PosX + HS.SP.m_ZoneSize * (he.m_ZoneX - m_ZoneX);
				tpy = he.m_PosY - m_PosY + HS.SP.m_ZoneSize * (he.m_ZoneY - m_ZoneY);
				if ((tpx * tpx + tpy * tpy) >= (1000.0 * 1000.0)) break;

				tpx = aim_px; tpy = aim_py; tpz = aim_pz;

				angle1need = Math.atan2(tpx, tpy);
				r = Math.sqrt(tpx * tpx + tpy * tpy + tpz * tpz);
				if (Math.abs(r) < 0.00001) angle2need = 0;
				else angle2need = Math.asin(tpz / r);

				fire_ok = true;

				break;
			}

			sa = 0.18 * Space.ToRad * step;

			ad = BaseMath.AngleDist(w.m_Angle, angle1need);
			if (ad < -sa) { w.m_Angle -= sa; fire_ok = false; }
			else if (ad > sa) { w.m_Angle += sa; fire_ok = false; }
			else {
				w.m_Angle=angle1need;
				//fire_ok=true;
			}

			ad=BaseMath.AngleDist(w.m_Angle2,angle2need);
			if (ad < -sa) { w.m_Angle2 -= sa; fire_ok = false; }
			else if (ad > sa) { w.m_Angle2 += sa; fire_ok = false; }
			else {
				w.m_Angle2=angle2need;
				//fire_ok=true;
			}

			if (fire_ok) {
				if (w.m_Bullet == null) {
					w.m_Bullet = HS.BulletAdd(HyperspaceBullet.BulletTypeLaser, m_EntityType, m_Id, m_TargetType, m_TargetId);
				} else {
					w.m_Bullet.m_TargetType = m_TargetType;
					w.m_Bullet.m_TargetId = m_TargetId;
				}
				C3D.CalcBarrelMatrix(HyperspaceBase.m_TMatrixA, w.m_Angle, w.m_Angle2, w.m_BarrelPosX, w.m_BarrelPosY, w.m_BarrelPosZ);
				HyperspaceBase.m_TMatrixA.appendTranslation(w.m_PosX, w.m_PosY, w.m_PosZ);
				HyperspaceBase.m_TMatrixA.append(m_World);

				HyperspaceBase.m_TPos.x = w.m_BarrelDirX * w.m_BarrelLen;
				HyperspaceBase.m_TPos.y = w.m_BarrelDirY * w.m_BarrelLen;
				HyperspaceBase.m_TPos.z = w.m_BarrelDirZ * w.m_BarrelLen;
				v = HyperspaceBase.m_TMatrixA.transformVector(HyperspaceBase.m_TPos);
				w.m_Bullet.m_DuloX = v.x;
				w.m_Bullet.m_DuloY = v.y;
				w.m_Bullet.m_DuloZ = v.z;

				HyperspaceBase.m_TPos.x = w.m_BarrelDirX;
				HyperspaceBase.m_TPos.y = w.m_BarrelDirY;
				HyperspaceBase.m_TPos.z = w.m_BarrelDirZ;
				v = HyperspaceBase.m_TMatrixA.deltaTransformVector(HyperspaceBase.m_TPos);
				w.m_Bullet.m_DuloDirX = v.x;
				w.m_Bullet.m_DuloDirY = v.y;
				w.m_Bullet.m_DuloDirZ = v.z;

				HyperspaceBase.m_TPos.x = 0.0;
				HyperspaceBase.m_TPos.y = 0.0;
				HyperspaceBase.m_TPos.z = 1.0;
				v = HyperspaceBase.m_TMatrixA.deltaTransformVector(HyperspaceBase.m_TPos);
				w.m_Bullet.m_DuloUpX = v.x;
				w.m_Bullet.m_DuloUpY = v.y;
				w.m_Bullet.m_DuloUpZ = v.z;

				w.m_Bullet.m_AimPosX = w.m_AimPosX;
				w.m_Bullet.m_AimPosY = w.m_AimPosY;
				w.m_Bullet.m_AimPosZ = w.m_AimPosZ;

			} else {
				if (w.m_Bullet != null) { HS.BulletDel(w.m_Bullet); w.m_Bullet = null; }
			}

//			w.m_Angle = angle1need;
//			w.m_Angle2 = angle2need;
		}
	}

	public function IsReadyForDraw():Boolean
	{
		if (m_Model == null) return false;
		if (!m_Model.GraphPrepare()) return false;
		if (!PrepareWeapon()) return false;
		if ((m_State & SpaceShip.StateLive) == 0 && (m_State & SpaceShip.StateDestroy) == 0) return false;
		//if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return false;
		return true;
	}

	public function DrawPrepare(dt:Number):void
	{
		var i:int, u:int;
		var obj:Object;
		var w:HyperspaceWeapon;

		for (i = 0; i < m_WeaponList.length; i++) {
			w = m_WeaponList[i];
			if (w.m_Model == null) continue;
			w.m_Model.m_Flag |= C3DModel.FlagMatrix;
			w.m_Model.m_Matrix.identity();
			w.m_Model.m_Matrix.appendRotation( -w.m_Angle * Space.ToGrad, Vector3D.Z_AXIS);

			if (w.m_Model.m_Child.length > 0) {
				var model:C3DModel = w.m_Model.m_Child[0]
				model.m_Flag |= C3DModel.FlagMatrix;
				model.m_Matrix.identity();
				model.m_Matrix.appendRotation( w.m_Angle2 * Space.ToGrad, Vector3D.X_AXIS);
			}
		}

		m_Model.CalcMatrix(m_World);
		//m.appendScale(50.0, 50.0, 1.0);
		//m.appendTranslation( -25.0, -25.0, 0.0);
		//m.appendTranslation(m_Map.WorldToScreenX(m_PosX) - 0.5 * m_Map.stage.stageWidth, m_Map.WorldToScreenY(m_PosY) - 0.5 * m_Map.stage.stageHeight, 0.0);

		//m.copyFrom(m_Map.m_Hyperspace.m_MatView);
		//m.append(m_Map.m_Hyperspace.m_MatPer);

		if (m_EngineOn) {
			if (m_EnginePower < 1.0) m_EnginePower = Math.min(1.0, m_EnginePower + 0.001 * dt);
		} else {
			if (m_EnginePower > 0.0) m_EnginePower = Math.max(0.0, m_EnginePower - 0.001 * dt);
		}

		var upsrc:Vector3D = m_World.transformVector(new Vector3D(0.0, 0.0, 1.0));

//		if (!m_ReadyWeapon && IsMeshLoaded()) {
//			m_ReadyWeapon = true;
//			CreateWeapon();
//		}

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
				ef.SetB(m_EnginePower * Math.min(3.0, m_Forsage));

				var dirx:Vector3D = dir.crossProduct(upsrc);
				dirx.normalize();
				var up:Vector3D = dir.crossProduct(dirx);
				up.normalize();

//				var m:Matrix3D = new Matrix3D(new <Number>[
//					mat.rawData[0], mat.rawData[1], mat.rawData[2], mat.rawData[3],
//					mat.rawData[4], mat.rawData[5], mat.rawData[6], mat.rawData[7],
//					mat.rawData[8], mat.rawData[9], mat.rawData[10], mat.rawData[11],
//					0.0, 0.0, 0.0, 1.0
//					], true);
				var m:Matrix3D = new Matrix3D();
				m.copyFrom(mat);

//if(i == 0) trace("dirx:\t" + Common.FormatFloat(dirx.x, 5) + "\t" + Common.FormatFloat(dirx.y, 5) + "\t" + Common.FormatFloat(dirx.z, 5) +
//	"\tup:\t" + Common.FormatFloat(up.x, 5) +"\t" + Common.FormatFloat(up.y, 5) +"\t" + Common.FormatFloat(up.z, 5) +
//	"\tdir:\t" + Common.FormatFloat(dir.x, 5) +"\t" + Common.FormatFloat(dir.y, 5) +"\t" + Common.FormatFloat(dir.z, 5));


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
					obj.m_Size, m_EnginePower, m_Forsage-1.0, 0xffffffff);
				if (obj.m_First) {
					obj.m_First = false;
					for (u = 0; u < 50; u++) HyperspaceEngine(obj.m_Effect).Takt(20);	
				}
				HyperspaceEngine(obj.m_Effect).Takt(dt);
			}
		}
		if (m_Explosion != null) {
			var offx:Number = m_PosX - HS.m_CamPos.x + HS.m_ZoneSize * (m_ZoneX - HS.m_CamZoneX);
			var offy:Number = m_PosY - HS.m_CamPos.y + HS.m_ZoneSize * (m_ZoneY - HS.m_CamZoneY);
			var offz:Number = m_PosZ - (HS.m_CamPos.z);

			m_Explosion.SetPos(offx, offy, offz);
			m_Explosion.GraphTakt(dt);
		}
	}
	
	public function DrawShipBefore(model:C3DModel, mwvp:Matrix3D):Boolean
	{
		var v:Vector3D;

		C3D.SetVConstMatrix(0, mwvp);

//		v = mwvp.transformVector(new Vector3D(0.0, 0.0, 0.0, 1.0));
//		v = mwvp.transformVector(new Vector3D(0.0, 0.0, 0.0, 0.5));
//		v = mwvp.transformVector(new Vector3D(0.0, 0.0, 0.0, 0.0));

//		v = mwvp.transformVector(new Vector3D(0.0, 100.0, 0.0, 1.0));
//		v = mwvp.transformVector(new Vector3D(0.0, 100.0, 0.0, 0.5));
//		v = mwvp.transformVector(new Vector3D(0.0, 100.0, 0.0, 0.0));

		if(C3D.m_Pass==C3D.PassDif || C3D.m_Pass==C3D.PassDifShadow || C3D.m_Pass==C3D.PassShadow) {
			v = model.m_MatrixWorldInv.deltaTransformVector(HS.m_Light);
			v.w = 0.0;
			v.normalize();
			C3D.SetVConst(4, v);
			//C3D.SetFConst(0, v);

			if (C3D.m_Pass == C3D.PassShadow) {
				v.x = -v.x * m_ShadowLength;
				v.y = -v.y * m_ShadowLength;
				v.z = -v.z * m_ShadowLength;
				C3D.SetVConst(5, v);
			}
		}

		if (C3D.m_Pass == C3D.PassDif || C3D.m_Pass==C3D.PassDifShadow ) {
			v = model.m_MatrixWorldInv.transformVector(HS.m_View);
			//C3D.SetFConst(3, new Vector3D(v.x,v.y,-v.z));
			v.w = 0.0;
			v.normalize();
			v.x = -v.x;
			v.y = -v.y;
			v.z = -v.z;
			C3D.SetVConst(5, v);
			//C3D.SetFConst(3, v);
		}
		
		return true;// m_WeaponModel == model;
	}

	public function Draw():void
	{
		if (m_Model == null) return;

//		var t_dif:Texture = C3D.GetTexture("empire/Ship1/dif.png?v=1");
//		if (t_dif == null) return;
//		var t_lum:Texture = C3D.GetTexture("empire/Ship1/lum.png?v=1");
//		if (t_lum == null) return;
//		var t_clr:Texture = C3D.GetTexture("empire/Ship1/clr.jpg?v=1");
//		if (t_clr == null) return;

		if (C3D.m_Pass == C3D.PassShadow) {
			if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;
			
			C3D.SetVConst(6, new Vector3D(0.0, 0.5, 1.0, 2.0));
			C3D.SetFConst(1, new Vector3D(0.0, 0.5, 1.0, 2.0));

			C3D.ShaderMeshShadow();
			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassZ) {
			if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;
			
			C3D.ShaderShip(false, false, false);
			m_Model.Draw(HS.m_MatViewPer);

		} else if (C3D.m_Pass == C3D.PassDif || C3D.m_Pass == C3D.PassDifShadow) {
			if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;
			
//			C3D.SetTexture(0, t_dif);
//			C3D.SetTexture(1, null);
//			C3D.SetTexture(2, t_clr);

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

//			C3D.SetTexture(0, null);
//			C3D.SetTexture(1, null);
//			C3D.SetTexture(2, null);

		} else if (C3D.m_Pass == C3D.PassLum) {
			if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;
			
//			C3D.SetTexture(1, t_lum);

			C3D.ShaderShip(false, false, true);
			m_Model.Draw(HS.m_MatViewPer);

//			C3D.SetTexture(1, null);

		} else if (C3D.m_Pass == C3D.PassParticle) {
			var i:int;
			var obj:Object;

			for (i = 0; i < m_EffectList.length; i++) {
				if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) break;
				
				obj = m_EffectList[i];
				if (obj.m_Effect is Effect) {
					(obj.m_Effect as Effect).Draw(HS.m_CurTime, HS.m_MatViewPer, HS.m_MatView, HS.m_MatViewInv, HS.m_FactorScr2WorldDist);
				} else if (obj.m_Effect is HyperspaceEngine) {
					HyperspaceEngine(obj.m_Effect).Draw();
				}
			}
			
			if (m_Explosion != null) {
				m_Explosion.Draw(HS.m_CurTime, HS.m_MatViewPer, HS.m_MatView, HS.m_MatViewInv, HS.m_FactorScr2WorldDist);
			}
		}
	}

	public function DrawText():void
	{
		var v:Number;
		var tex:C3DTexture;

		if (m_ExplosionTime >= 0 && HS.m_CurTime > (m_ExplosionTime + 300)) return;

		var offx:Number = m_PosX - HS.m_CamPos.x + HS.m_ZoneSize * (m_ZoneX - HS.m_CamZoneX);
		var offy:Number = m_PosY - HS.m_CamPos.y + HS.m_ZoneSize * (m_ZoneY - HS.m_CamZoneY);
		var offz:Number = m_PosZ - (HS.m_CamPos.z);

		while (m_State & SpaceShip.StateBuild) {
			tex = C3D.GetTexture("font/intf.png");
			if (tex == null || tex.tex == null) break;

			m_TPos.x = offx;
			m_TPos.y = offy;
			m_TPos.z = offz;
			HS.WorldToScreen(m_TPos);

			C3D.DrawImg(tex, 0xBB000000, m_TPos.x - 26, m_TPos.y - 6, 102, 10.0, 2, 2, 1, 1);

			v = (HS.m_ServerTime-(1000 * Number(m_StateTime))) / 10000.0;
			if (v < 0) v = 0;
			else if (v > 1.0) v = 1.0;

			C3D.DrawImg(tex, 0xffffff00, m_TPos.x - 25, m_TPos.y - 5, v * 100, 8.0, 2, 2, 1, 1);

			break;
		}

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

		var maxhp:int = 1000;
		var maxshield:int = 1000;
		while (m_HP != maxhp || m_Shield != maxshield) {
			tex = C3D.GetTexture("font/intf.png");
			if (tex == null || tex.tex == null) break;

			C3D.DrawImg(tex, 0xBB000000, m_TPos.x - 25, m_TPos.y - 20, 5 * 10, 12.0, 2, 2, 1, 1);

			v = Math.round(10 * m_HP / maxhp);
			if (v < 0) v = 0;
			else if (v > 10) v = 10;
	//		if (v == 0 && m_HP > 0)vhp = 1;

			if(v>0) {
				C3D.DrawImg(tex, 0xffff0000, m_TPos.x - 25, m_TPos.y - 20, 5 * v, 6.0, 0, 0, 5 * v+1, 6);
			}

			v = Math.round(10 * m_Shield / maxshield);
			if (v < 0) v = 0;
			else if (v > 10) v = 10;
	//		if (v == 0 && m_Shield > 0) vhp = 1;

			if(v>0) {
				C3D.DrawImg(tex, 0xff00e1dd, m_TPos.x - 25, m_TPos.y - 14, 5 * v, 6.0, 0, 0, 5 * v+1, 6);
			}
			
			break;
		}
	}

	public function Pick(px:Number, py:Number, pz:Number, dx:Number, dy:Number, dz:Number, out_p:Vector3D, out_n:Vector3D = null):Boolean
	{
		var hm:C3DHitMesh = HitMesh(1);
		if (hm == null) return false;

		var m:Matrix3D = new Matrix3D();
		C3D.CalcMatrixShipOri(m, m_Angle, m_Pitch, m_Roll);
		m.invert();

		var p:Vector3D = m.transformVector(new Vector3D(px, py, pz))
		var d:Vector3D = m.deltaTransformVector(new Vector3D(dx, dy, dz))

		var t:Number = hm.Pick(p.x, p.y, p.z, d.x, d.y, d.z, out_n);
		if (t < 0.0) return false;

		out_p.x = px + dx * t;
		out_p.y = py + dy * t;
		out_p.z = pz + dz * t;
		return true;
	}
	
	public function CalcAimPoint(bx:Number, by:Number, bz:Number, out:Vector3D):void
	{
		out.x = Math.random() * 120.0 - 60.0;
		out.y = Math.random() * 160.0 - 80.0;
		out.z = Math.random() * 40.0 - 20.0;
	}
	
	public function CalcHit(vfromx:Number, vfromy:Number, vfromz:Number, vtox:Number, vtoy:Number, vtoz:Number, out:Vector3D, out_normal:Vector3D = null):Boolean
	{
		var hm:C3DHitMesh = HitMesh(1);
		if (hm == null) return false;

		var v:Vector3D;
		m_TPos.x = vfromx;
		m_TPos.y = vfromy;
		m_TPos.z = vfromz;
		v = m_WorldInv.transformVector(m_TPos);
		var vpx:Number = v.x;
		var vpy:Number = v.y;
		var vpz:Number = v.z;

		m_TPos.x = vtox - vfromx;
		m_TPos.y = vtoy - vfromy;
		m_TPos.z = vtoz - vfromz;
		v = m_WorldInv.deltaTransformVector(m_TPos);
		var vdx:Number = v.x;
		var vdy:Number = v.y;
		var vdz:Number = v.z;

//var t1:Number = getTimer();
		var t:Number = hm.Pick(vpx, vpy, vpz, vdx, vdy, vdz, out_normal);
//var t2:Number = getTimer();
//trace(t2-t1);
		if (t < 0.0) return false;

		if (out_normal != null) {
			v = m_World.deltaTransformVector(out_normal);
			out_normal.x = v.x;
			out_normal.y = v.y;
			out_normal.z = v.z;
		}

		out.x = vfromx + (vtox - vfromx) * t;
		out.y = vfromy + (vtoy - vfromy) * t;
		out.z = vfromz + (vtoz - vfromz) * t;
		return true;
	}

	public static function HitMesh(typeid:uint):C3DHitMesh
	{
		if (m_HitMesh[typeid] != undefined) return m_HitMesh[typeid];
		
		var hm:C3DHitMesh = null;

		if (typeid == 1) {
			var ba:ByteArray = LoadManager.Self.Get("ship1/geo.hit") as ByteArray;
			
			if (ba == null) return null;
			ba.uncompress();
			hm = new C3DHitMesh();
			hm.Load(ba);
		}
		
		if (hm != null) m_HitMesh[typeid] = hm;
		return hm;
	}
	
	public static function HitMesh2(typeid:uint):C3DHitMesh
	{
		if (m_HitMesh[typeid] != undefined) return m_HitMesh[typeid];

		var mesh:C3DMesh;
		var hm:C3DHitMesh = null;

		if (typeid == 1) {
			var o1:Object = LoadManager.Self.Get("ship1/p1.mesh");
			var o2:Object = LoadManager.Self.Get("ship1/p2.mesh");
			var o3:Object = LoadManager.Self.Get("ship1/p3.mesh");

			if ((o1 != null && (o1 is ByteArray)) && (o2 != null && (o2 is ByteArray)) && (o3 != null && (o3 is ByteArray))) {
				mesh = new C3DMesh();

				hm = new C3DHitMesh();
		
				(o1 as ByteArray).endian=Endian.LITTLE_ENDIAN;
				mesh.Init(o1 as ByteArray);
				hm.Add(mesh);

				(o2 as ByteArray).endian=Endian.LITTLE_ENDIAN;
				mesh.Init(o2 as ByteArray);
				hm.Add(mesh);

				(o3 as ByteArray).endian=Endian.LITTLE_ENDIAN;
				mesh.Init(o3 as ByteArray);
				hm.Add(mesh);

			}
		}
		
		if (hm != null) {
			hm.Calc();

			m_HitMesh[typeid] = hm;

			CONFIG::air {
				var ba:ByteArray = new ByteArray();
				hm.Save(ba);
				ba.compress();

				var f:File = File.applicationStorageDirectory.resolvePath("ship" + typeid.toString() + ".hit");
				trace(f.nativePath);
				var s:FileStream = new FileStream();
				s.open(f, FileMode.WRITE);
				s.writeBytes(ba);
				s.close();
			}
			
			return hm;
		}
		
		return null;
	}
}

}
