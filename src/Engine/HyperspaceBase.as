// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{

import B3DEffect.*;
import Base3D.Bos;
import Base3D.BosObj;

import flash.display.*;
import flash.events.*;
import flash.system.*;
import flash.geom.*;
import flash.utils.*;

import flash.display3D.*;
import com.adobe.utils.PerspectiveMatrix3D;

public class HyperspaceBase extends Sprite
{
//	static public var Self:HyperspaceBase = null;

	public var SP:Space = null;
	
	public static const ZForFullZ:Number = 0.2; // Пространство в z буфере для полной сцены
	public static const ZForFar:Number = 0.00; // Z пространство для дальнего плана
	
	public var m_RootFleetId:uint = 0;
	public var m_CurTime:Number = 0;
	public var m_ServerTime:Number = 0;
	
	public var m_CotlMap:Dictionary = new Dictionary();
	public var m_LoadCotl:Boolean = false;

	public var m_BG:HyperspaceBG = null;
	public var m_Dust:HyperspaceDust = null;
	public var m_EntityList:Vector.<HyperspaceEntity> = new Vector.<HyperspaceEntity>();
	public var m_CotlList:Vector.<HyperspaceCotl> = new Vector.<HyperspaceCotl>();
	public var m_PlanetList:Vector.<HyperspacePlanet> = new Vector.<HyperspacePlanet>();
	public var m_BulletList:Vector.<HyperspaceBullet> = new Vector.<HyperspaceBullet>();
	public var m_StarLayer:MovieClip = null;
	public var m_FleetList:Vector.<HyperspaceFleet> = new Vector.<HyperspaceFleet>();
	public var m_ShuttleList:Vector.<HyperspaceShuttle> = new Vector.<HyperspaceShuttle>();
	public var m_ContainerList:Vector.<HyperspaceContainer> = new Vector.<HyperspaceContainer>();
	public var m_SelectLayer:Sprite = null;
	
	public var m_MatView:PerspectiveMatrix3D = new PerspectiveMatrix3D();
	public var m_MatViewInv:Matrix3D = new Matrix3D();
	public var m_MatPer:PerspectiveMatrix3D = new PerspectiveMatrix3D();
	public var m_MatViewPer:Matrix3D = new Matrix3D();
	public var m_Frustum:C3DFrustum = new C3DFrustum();

	public var m_CamZoneX:int = 0;
	public var m_CamZoneY:int = 0;
	public var m_CamPos:Vector3D = new Vector3D();
	public var m_CamRotate:Number = 0 * Space.ToRad;
	public var m_CamAngle:Number = 40.0 * Space.ToRad;// * C3D.ToRad;

	static public const CamDistMin:Number=800.0;
	static public const CamDistMax:Number=2800.0;
	static public const CamDistDefault:Number=1500.0;
	public var m_CamDist:Number = CamDistDefault;
	public var m_CamDistTo:Number = CamDistDefault;
	public var m_CamDistTime:Number = 0;
	public var m_CamDistDir:int = 0;
	public var m_CamDistChangeTime:Number = 0;
	public var m_FactorScr2WorldDist:Number = 1.0;

	public var m_Fov:Number = 45.0 * C3D.ToRad;

//	public var m_OffX:Number = 0.0;
//	public var m_OffY:Number = 0.0;
//	static public const OffMaxRange:Number = 10000.0;

	public var m_LightRotate:Number = 0.628318530717958;
	public var m_LightAngle:Number = 1.0995574287564276;
	public var m_Light:Vector3D = new Vector3D(1.0, 1.0, 0.5);
	public var m_LightPlanetRotate:Number = 1.500983156715124;
	public var m_LightPlanetAngle:Number = -0.9075712110370512;
	public var m_LightPlanet:Vector3D = new Vector3D(1.0, 1.0, 0.5);
	public var m_View:Vector3D = new Vector3D(0.0, 0.0, 0.0);

	public var m_ZoneMinX:int = 0;
	public var m_ZoneMinY:int = 0;
	public var m_ZoneCntX:int = 0;
	public var m_ZoneCntY:int = 0;
	public var m_ZoneSize:int = 0;

	static public var m_TPos:Vector3D = new Vector3D();
	static public var m_TDir:Vector3D = new Vector3D();
	static public var m_TPlane:Vector3D = new Vector3D();
	static public var m_TMatrixA:Matrix3D = new Matrix3D();
	static public var m_TMatrixB:Matrix3D = new Matrix3D();
	static public var m_TMatrixC:Matrix3D = new Matrix3D();

	public var m_ShadowColor:uint = 0xB8000021;
	
	public var m_SysModify:int = 0; // 1-view 2-light 3-planetlight
	
	public var m_TestEffect:Effect = null;// new Effect();
	
	public var m_Bos:Bos = new Bos();

	public var m_DrawLast:Number = 0;

	public function HyperspaceBase(sp:Space)
	{
		SP = sp;
		visible = false;

		m_Light.normalize();
		
		m_BG=new HyperspaceBG(this);
		addChild(m_BG);
		
		m_Dust = new HyperspaceDust(this);
		
		m_StarLayer=new MovieClip();
		addChild(m_StarLayer);
		m_SelectLayer = new Sprite();
		addChild(m_SelectLayer);

		doubleClickEnabled = true;
		mouseEnabled = false;
		mouseChildren = false; 

		//m_MatPer.perspectiveFieldOfViewRH(m_Fov, Number(EM.stage.stageWidth) / EM.stage.stageHeight, 1.0, 5000.0);
		m_MatPer.identity();
		m_MatPer.perspectiveFieldOfViewRH(m_Fov, Number(C3D.m_SizeX) / C3D.m_SizeY, 0.0, 1.0);
		m_MatView.identity();
	}
	
	public function FactorScr2WorldDist(x:Number, y:Number, z:Number):Number // Преобразуем кол-во пикселей на экране в длину (по расстоянию от камеры до центра)
	{
		x = -m_MatView.rawData[3 * 4 + 0] - x;
		y = -m_MatView.rawData[3 * 4 + 1] - y;
		z = -m_MatView.rawData[3 * 4 + 2] - z;
		var dist:Number = Math.sqrt(x * x + y * y + z * z);
		return  dist * m_FactorScr2WorldDist;
	}

	public function WorldToScreen(v:Vector3D):void
	{
		var v2:Vector3D = m_MatViewPer.transformVector(v);
		v.x = (v2.x / v2.w) * C3D.m_SizeX * 0.5 + (C3D.m_SizeX * 0.5);
		v.y = -(v2.y / v2.w) * C3D.m_SizeY * 0.5 + (C3D.m_SizeY * 0.5);
		v.z = 0.0;
		v.w = 0.0;
	}

	public function GetCotl(id:uint, testload:Boolean = true, reload:Boolean = false):SpaceCotl
	{
		if (id == 0) return null;

		var cotl:SpaceCotl = null;
		if (m_CotlMap[id] == undefined) {
			cotl = new SpaceCotl(SP, this);
			cotl.m_EntityType = SpaceEntity.TypeCotl;
			cotl.m_Id = id;
			m_CotlMap[id] = cotl;
			//m_CotlAll.push(cotl);
		} else {
			cotl = m_CotlMap[id];
		}

		if (reload) { cotl.m_Reload = true; m_LoadCotl = true; }
		else if (m_CurTime > (cotl.m_LoadTime + 60000)) { cotl.m_Reload = true; m_LoadCotl = true; }

		if (testload && cotl.m_LoadTime == 0) return null;
		return cotl;
	}
	
	public function BulletDel(hb:HyperspaceBullet):void
	{
		if (hb == null) return;
		if (hb.m_Del) return;
		hb.m_Del = true;
		
		hb.Clear();
		
		var u:int;
		u = m_BulletList.indexOf(hb);
		if(u>=0) m_BulletList.splice(u, 1);
		
		u = m_EntityList.indexOf(hb);
		if (u >= 0) m_EntityList.splice(u, 1);
	}
	
	public function BulletAdd(bullettype:int, fromtype:int, fromid:uint, tgttype:int, tgtid:uint):HyperspaceBullet
	{
		var hb:HyperspaceBullet = new HyperspaceBullet(this);
		hb.m_BulletType = bullettype;
		hb.m_EntityType = SpaceEntity.TypeBullet;
		hb.m_FromType = fromtype;
		hb.m_FromId = fromid;
		hb.m_TargetType = tgttype;
		hb.m_TargetId = tgtid;

		m_BulletList.push(hb);
		m_EntityList.push(hb);

		return hb;
	}

	public function HyperspaceFleetById(id:uint):HyperspaceFleet
	{
		var u:int;
		var hf:HyperspaceFleet;

		for(u=0;u<m_FleetList.length;u++) {
			hf=m_FleetList[u];
			if(hf.m_Id==id) return hf;
		}
		return null;
	}
	
	public function HyperspaceEntityById(type:int, id:uint):HyperspaceEntity
	{
		var u:int;
		var he:HyperspaceEntity;
		if (type == 0) return null;
		if (id == 0) return null;
		for (u = 0; u < m_EntityList.length; u++) {
			he = m_EntityList[u];
			if (he.m_EntityType==type && he.m_Id == id) return he;
		}
		return null;
	}

	public function HyperspaceCotlById(id:uint):HyperspaceCotl
	{
		var u:int;
		var hc:HyperspaceCotl;
		if (id == 0) return null;
		for (u = 0; u < m_CotlList.length; u++) {
			hc = m_CotlList[u];
			if (hc.m_CotlId == id) return hc;
		}
		return null;
	}

	public function HyperspacePlanetById(id:uint):HyperspacePlanet
	{
		var u:int;
		var hp:HyperspacePlanet;
		if (id == 0) return null;
		for (u = 0; u < m_PlanetList.length; u++) {
			hp = m_PlanetList[u];
			if (hp.m_Id == id) return hp;
		}
		return null;
	}
	
	public function CalcPick(mpx:int, mpy:int, vpos:Vector3D, vdir:Vector3D):void
	{
		var wrleft:int = 0;
		var wrtop:int = 0;
		var wrright:int = C3D.m_SizeX;// m_Map.m_StageSizeX;
		var wrbottom:int = C3D.m_SizeY;// m_Map.m_StageSizeY;

		var vx:Number =  ( ( ( 2.0 * Number(mpx - wrleft) ) / Number(wrright - wrleft) ) - 1 ) / m_MatPer.rawData[0 * 4 + 0];
		var vy:Number = -( ( ( 2.0 * Number(mpy - wrtop) ) / Number(wrbottom - wrtop) ) - 1 ) / m_MatPer.rawData[1 * 4 + 1];
		var vz:Number =  -1.0;

		vdir.x = vx * m_MatViewInv.rawData[0 * 4 + 0] + vy * m_MatViewInv.rawData[1 * 4 + 0] + vz * m_MatViewInv.rawData[2 * 4 + 0];
		vdir.y = vx * m_MatViewInv.rawData[0 * 4 + 1] + vy * m_MatViewInv.rawData[1 * 4 + 1] + vz * m_MatViewInv.rawData[2 * 4 + 1];
		vdir.z = vx * m_MatViewInv.rawData[0 * 4 + 2] + vy * m_MatViewInv.rawData[1 * 4 + 2] + vz * m_MatViewInv.rawData[2 * 4 + 2];
		vdir.normalize();
//trace(vx, vy, "                ",vdir.x,vdir.y,vdir.z);

		vpos.x = m_MatViewInv.rawData[3 * 4 + 0];
		vpos.y = m_MatViewInv.rawData[3 * 4 + 1];
		vpos.z = m_MatViewInv.rawData[3 * 4 + 2];
	}
	
	public static function PlaneFromPointNormal(pos:Vector3D, normal:Vector3D, out:Vector3D):void
	{
		out.x = normal.x;
		out.y = normal.y;
		out.z = normal.z;
		out.w = 0;
		out.normalize();
		out.w = -(out.x * pos.x + out.y * pos.y + out.z * pos.z);
	}
	
	public static function PlaneIntersectionLine(pl:Vector3D, v0:Vector3D, v1:Vector3D, out:Vector3D):Boolean
	{
		var d0: Number = pl.x * v0.x + pl.y * v0.y + pl.z * v0.z - pl.w;
		var d1: Number = pl.x * v1.x + pl.y * v1.y + pl.z * v1.z - pl.w;
		var m: Number = d1 - d0;
		if ((m > -0.00000001) && (m < 0.00000001)) return false;
		m = d1 / m;
		out.x = v1.x + ( v0.x - v1.x ) * m;
		out.y = v1.y + ( v0.y - v1.y ) * m;
		out.z = v1.z + ( v0.z - v1.z ) * m;
		//out.w = 0;
		return true;
	}
	
	public function PickWorldCoord(mpx:int, mpy:int, out:Vector3D):Boolean
	{
		var z:Number = 0;
		var ent:SpaceEntity = SP.EntityFind(SpaceEntity.TypeFleet, m_RootFleetId);
		if (ent != null) z = ent.m_PosZ;

		var vpos:Vector3D = new Vector3D();
		var vdir:Vector3D = new Vector3D();

		CalcPick(mpx, mpy, vpos, vdir);
		vpos.x += m_CamZoneX * m_ZoneSize + m_CamPos.x;// + m_OffX;
		vpos.y += m_CamZoneY * m_ZoneSize + m_CamPos.y;// + m_OffY;

		vpos.z += m_CamPos.z;

		//var pl:Vector3D = new Vector3D();
		PlaneFromPointNormal(new Vector3D(0, 0, -z), new Vector3D(0, 0, 1), m_TPlane);

		vdir.x = vpos.x + vdir.x;
		vdir.y = vpos.y + vdir.y;
		vdir.z = vpos.z + vdir.z;

		if (!PlaneIntersectionLine(m_TPlane, vpos, vdir, out)) return false;

//vpos.x = out.x - (ent.m_PosX + ent.m_ZoneX * SP.m_ZoneSize);
//vpos.y = out.y - (ent.m_PosY + ent.m_ZoneY * SP.m_ZoneSize);
//vpos.z = out.z - (ent.m_PosZ);
//trace(vpos.x, vpos.y, vpos.z);

//trace("WorldCoord", out.x, out.y, out.z);
		return true;
	}
	
	public function PickPlanet(orbit:Boolean = false):SpacePlanet
	{
		var i:int;
		var planet:SpacePlanet;
		var ent:SpaceEntity;
		var offx:Number, offy:Number, offz:Number;
		var r:Number;

		var vpos:Vector3D = new Vector3D();
		var vdir:Vector3D = new Vector3D();

		CalcPick(mouseX, mouseY, vpos, vdir);

		for (i = 0; i < SP.m_EntityList.length; i++) {
			ent = SP.m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypePlanet) continue;
			planet = ent as SpacePlanet;
			if ((planet.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) continue;

			offx = planet.m_PosX - m_CamPos.x + (planet.m_ZoneX - m_CamZoneX) * SP.m_ZoneSize;
			offy = planet.m_PosY - m_CamPos.y + (planet.m_ZoneY - m_CamZoneY) * SP.m_ZoneSize;
			offz = planet.m_PosZ - m_CamPos.z;

			r = planet.m_Radius;;
			if (orbit) {
				if ((planet.m_PlanetFlag & SpacePlanet.FlagTypeMask) != SpacePlanet.FlagTypeSun && (planet.m_PlanetFlag & SpacePlanet.FlagTypeMask) != SpacePlanet.FlagTypePlanet) continue;
				r += SpaceShip.RadiusToOrbitPlanet * 2.0;
			}
			var oi:Object = Space.IntersectSphere(offx, offy, offz, r, vpos.x, vpos.y, vpos.z, vdir.x, vdir.y, vdir.z);
			if (oi == null) continue;
			
			return planet;
		}
		return null;
	}
	
	public function PickCotl(orbit:Boolean = false):SpaceCotl
	{
		var i:int;
		var cotl:SpaceCotl;
		var ent:SpaceEntity;
		var offx:Number, offy:Number, offz:Number;
		var r:Number;

		var vpos:Vector3D = new Vector3D();
		var vdir:Vector3D = new Vector3D();

		CalcPick(mouseX, mouseY, vpos, vdir);

		for (i = 0; i < SP.m_EntityList.length; i++) {
			ent = SP.m_EntityList[i];
			if (ent.m_EntityType != SpaceEntity.TypeCotl) continue;
			cotl = ent as SpaceCotl;

			offx = cotl.m_PosX - m_CamPos.x + (cotl.m_ZoneX - m_CamZoneX) * SP.m_ZoneSize;
			offy = cotl.m_PosY - m_CamPos.y + (cotl.m_ZoneY - m_CamZoneY) * SP.m_ZoneSize;
			offz = cotl.m_PosZ - m_CamPos.z;

			r = Space.EmpireCotlSizeToRadius(cotl.m_CotlSize);
			if (orbit) r += SpaceShip.RadiusToOrbitCotl * 2.0;
			else r *= 0.5;
			var oi:Object = Space.IntersectSphere(offx, offy, offz, r, vpos.x, vpos.y, vpos.z, vdir.x, vdir.y, vdir.z);
			if (oi == null) continue;
			
			return cotl;
		}
		return null;
	}
	
	public function PickEntity():HyperspaceEntity
	{
		var i:int;
		var hf:HyperspaceFleet;
		var hp:HyperspacePlanet;
		var he:HyperspaceEntity;
		var hcont:HyperspaceContainer;
		var offx:Number, offy:Number, offz:Number;
		var r:Number;

		var vpos:Vector3D = new Vector3D();
		var vdir:Vector3D = new Vector3D();

		CalcPick(mouseX, mouseY, vpos, vdir);
		
		var best:HyperspaceEntity = null;
		var bestt:Number = 0;

		//for (i = 0; i < m_FleetList.length; i++) {
		for (i = 0; i < m_EntityList.length; i++) {
			he = m_EntityList[i];

			offx = he.m_PosX - m_CamPos.x + (he.m_ZoneX - m_CamZoneX) * SP.m_ZoneSize;
			offy = he.m_PosY - m_CamPos.y + (he.m_ZoneY - m_CamZoneY) * SP.m_ZoneSize;
			offz = he.m_PosZ - m_CamPos.z;

			if (he.m_EntityType == SpaceEntity.TypeFleet) {
				hf = he as HyperspaceFleet;

				r = hf.m_Radius * 0.5;

			} else if (he.m_EntityType == SpaceEntity.TypePlanet) {
				hp = he as HyperspacePlanet;

				if ((hp.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) continue;

				r = hp.m_Radius;

			} else if (he.m_EntityType == SpaceEntity.TypeContainer) {
				hcont = he as HyperspaceContainer;
				if (!hcont.m_Vis) continue;
				r = hcont.m_Radius;

			} else continue;

			var oi:Object = Space.IntersectSphere(offx, offy, offz, r, vpos.x, vpos.y, vpos.z, vdir.x, vdir.y, vdir.z);
			if (oi == null) continue;

			if (best == null || Number(oi) < bestt) {
				bestt = Number(oi);
				best = he;
			}
		}
		return best;
	}
	
	public function CamDistMove():void
	{
		var ct:Number=m_CurTime;

		if (m_CamDistTime == 0) m_CamDistTime = ct;
		if(ct<m_CamDistTime+10) return;

		var cd:Number = m_CamDist;

		var dir:Number=m_CamDistTo-cd;

		var speed:Number=2.0*Number(ct-m_CamDistTime);

		if (Math.abs(dir) <= speed) cd = m_CamDistTo;
		else if (dir < 0.0) cd -= speed;
		else cd += speed;

		//ChangeCamDist(cd,ct,false);
		m_CamDist = cd;

		m_CamDistTime=ct;
	}

	public function CamDistChange():void
	{
		if(m_CamDistChangeTime>m_CurTime) return;
		m_CamDistChangeTime=m_CurTime+100;

		var speed:Number = 0.1;

		if(m_CamDistDir<0) {
			m_CamDistTo = Math.max(CamDistMin, m_CamDistTo * (1.0 - speed));

			if ((m_CamDistTo - CamDistMin) < CamDistMin * speed * 0.5) m_CamDistTo = CamDistMin;
		} else {
			m_CamDistTo = Math.min(CamDistMax, m_CamDistTo * (1.0 + speed));

			if (CamDistMax - m_CamDistTo < CamDistMax * speed * 0.5) m_CamDistTo = CamDistMax;
		}
	}
	
	public function CamCalcMat():void
	{
		m_MatView.identity();
		m_MatView.appendRotation(m_CamRotate * Space.ToGrad, Vector3D.Z_AXIS);
		m_MatView.appendRotation(-m_CamAngle * Space.ToGrad, Vector3D.X_AXIS);
		m_MatView.appendTranslation(0.0, 0.0, -m_CamDist);
		m_MatViewInv.copyFrom(m_MatView);
		m_MatViewInv.invert();

		m_View = m_MatViewInv.transformVector(new Vector3D(0.0, 0.0, 0.0, 1.0));
	}

	public function CamCalc(dt:Number):void
	{
		if (m_CamDistDir != 0) CamDistChange();
		if (m_CamDistTo != m_CamDist) CamDistMove();
		else {
			m_CamDistTime=0;
			//if (m_CamDistDir != 0) m_CamDistDir = 0;
		}

		CamCalcMat();
	}
	
	public function CalcShadowLengthAll(he:HyperspaceEntity, r:Number):Number
	{
		var u:int;
		var hf2:HyperspaceFleet;
		var hs2:HyperspaceShuttle;
		var dx:Number, dy:Number, dz:Number;

		var sl:Number = r;

		for (u = 0; u < m_FleetList.length; u++) {
			hf2 = m_FleetList[u];
			if (he == hf2) continue;
			if (!hf2.m_InDraw) continue;

			dx = hf2.m_PosX - he.m_PosX + m_ZoneSize * (hf2.m_ZoneX - he.m_ZoneX);
			dy = hf2.m_PosY - he.m_PosY + m_ZoneSize * (hf2.m_ZoneY - he.m_ZoneY);
			dz = hf2.m_PosZ - he.m_PosZ;

			r = CalcShadowLength(0.0, 0.0, 0.0, r, dx, dy, dz, hf2.m_Radius);
			if (r > sl) sl = r;
		}

		for (u = 0; u < m_ShuttleList.length; u++) {
			hs2 = m_ShuttleList[u];
			if (he == hs2) continue;
			if (!hs2.m_InDraw) continue;

			dx = hs2.m_PosX - he.m_PosX + m_ZoneSize * (hs2.m_ZoneX - he.m_ZoneX);
			dy = hs2.m_PosY - he.m_PosY + m_ZoneSize * (hs2.m_ZoneY - he.m_ZoneY);
			dz = hs2.m_PosZ - he.m_PosZ;

			r = CalcShadowLength(0.0, 0.0, 0.0, r, dx, dy, dz, hs2.m_Radius);
			if (r > sl) sl = r;
		}
//trace("ShadowLength:", hs.m_ShadowLength);
		return sl;
	}
	
	public function Draw():void
	{
		var i:int, u:int;
		var dx:Number, dy:Number, dz:Number, r:Number, f:Number;
		var hf:HyperspaceFleet, hf2:HyperspaceFleet;
		var hc:HyperspaceCotl;
		var hp:HyperspacePlanet;
		var hb:HyperspaceBullet;
		var hs:HyperspaceShuttle;
		var hcont:HyperspaceContainer;
		var ent:SpaceEntity;
		var ship:SpaceShip;
		var bobj:BosObj;

		if (!C3D.IsReady()) return;
//trace("draw");

		m_Bos.Clear();

		m_Light.x = Math.sin(m_LightRotate);
		m_Light.y = Math.sin(m_LightAngle) * Math.cos(m_LightRotate);
		m_Light.z = Math.cos(m_LightAngle);
		m_Light.normalize();

		m_LightPlanet.x = Math.sin(m_LightPlanetRotate);
		m_LightPlanet.y = Math.sin(m_LightPlanetAngle) * Math.cos(m_LightPlanetRotate);
		m_LightPlanet.z = Math.cos(m_LightPlanetAngle);
		m_LightPlanet.normalize();

		m_MatView.identity();
		m_MatView.appendRotation(m_CamRotate * Space.ToGrad, Vector3D.Z_AXIS);
		m_MatView.appendRotation(-m_CamAngle * Space.ToGrad, Vector3D.X_AXIS);
		m_MatView.appendTranslation(0.0, 0.0, -m_CamDist);

		var ct:Number = m_CurTime;
		var dt:Number = ct - m_DrawLast;
		if (dt < 5) return;
		if (dt > 1000) dt = 1000;
		m_DrawLast = ct;
		
		// CalcPos
		for(i=0;i<m_PlanetList.length;i++) {
			hp = m_PlanetList[i];
			hp.CalcPos();
		}
		for(i=0;i<m_FleetList.length;i++) {
			hf = m_FleetList[i];
			hf.CalcPos();
		}
		for(i=0;i<m_ShuttleList.length;i++) {
			hs = m_ShuttleList[i];
			hs.CalcPos();
		}
		for(i=0;i<m_ContainerList.length;i++) {
			hcont = m_ContainerList[i];
			hcont.CalcPos();
		}

		// Cam pos
		CamCalc(dt);

		m_Frustum.Clac(m_MatViewInv, m_MatPer);

//		m_CamPos.x += m_OffX;
//		m_CamPos.y += m_OffY;
		
		//m_BG.SetOffset(m_CamZoneX * SP.m_ZoneSize + m_CamPos.x, m_CamZoneY * SP.m_ZoneSize + m_CamPos.y);

		// CalcMatrix
		for(i=0;i<m_FleetList.length;i++) {
			hf = m_FleetList[i];
			hf.CalcMatrix();
		}
		for(i=0;i<m_ShuttleList.length;i++) {
			hs = m_ShuttleList[i];
			hs.CalcMatrix();
		}
		for(i=0;i<m_ContainerList.length;i++) {
			hcont = m_ContainerList[i];
			hcont.CalcMatrix();
		}
		
		// GraphTakt
		for(i=0;i<m_FleetList.length;i++) {
			hf = m_FleetList[i];
			hf.GraphTakt(dt);
		}
		for(i=0;i<m_ShuttleList.length;i++) {
			hs = m_ShuttleList[i];
			hs.GraphTakt(dt);
		}
		for (i = m_BulletList.length - 1; i >= 0; i--) {
			hb = m_BulletList[i];
			if (!hb.GraphTakt(dt)) {
				BulletDel(hb);
			}
		}
		for(i=0;i<m_ContainerList.length;i++) {
			hcont = m_ContainerList[i];
			hcont.GraphTakt(dt);
		}

		if (m_TestEffect != null) {
			//if (!EM.m_FormInput.visible) {
			if(!StdMap.Main.FI.visible) {
				StyleManager.m_EditId = "";
				m_TestEffect.Clear();
				m_TestEffect = null;
				//EM.m_FormInputTimeline.Hide();
			} else {
				m_TestEffect.GraphTakt(dt);
			}
		}

//		C3D.FrameBegin();

		//C3D.SetMainRanderTexture();
		
//trace(m_CamPos.x + "\t" + m_CamPos.y + "\t" + m_CamPos.z);

		//m_MatView.lookAtRH(new Vector3D(0.0, 0.0, -1000.0), new Vector3D(0.0, 0.0, 0.0), new Vector3D(0.0, 1.0, 0.0));

		// Calc Min/Max Z
		// Может не правильно работать, если объекты друг в друге. Так как бинарное разбиение не режет объекты пополам.
		// Для уменьшения неправильных случаев нужно правильно выбирать очерёдность объектов.
		// Чем больше тем раньше?
		var minz:Number = 10000.0;
		var maxz:Number = 0.0;
		//var dx:Number, dy:Number, 
		for (i = 0; i < m_PlanetList.length; i++) {
			hp = m_PlanetList[i];
			if ((hp.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeCenter) continue;
			dx = hp.m_PosX - m_CamPos.x + m_ZoneSize * (hp.m_ZoneX - m_CamZoneX);
			dy = hp.m_PosY - m_CamPos.y + m_ZoneSize * (hp.m_ZoneY - m_CamZoneY);
			dz = hp.m_PosZ - (m_CamPos.z);
			hp.m_InDraw = m_Frustum.IsIn(dx, dy, dz, hp.m_Radius + 200.0);
			if (hp.m_InDraw) {
				f = -(dx * m_MatView.rawData[0 * 4 + 2] + dy * m_MatView.rawData[1 * 4 + 2] + dz * m_MatView.rawData[2 * 4 + 2] + m_MatView.rawData[3 * 4 + 2]);
				r = hp.m_Radius + 200.0;
				if ((f - r) < minz) minz = f - r;
				if ((f + r) > maxz) maxz = f + r;

				m_Bos.ObjAdd(dx, dy, dz, hp.m_Radius).m_Ptr = hp;
			}
		}
		for(i=0;i<m_FleetList.length;i++) {
			hf = m_FleetList[i];
			dx = hf.m_PosX - m_CamPos.x + m_ZoneSize * (hf.m_ZoneX - m_CamZoneX);
			dy = hf.m_PosY - m_CamPos.y + m_ZoneSize * (hf.m_ZoneY - m_CamZoneY);
			dz = hf.m_PosZ - m_CamPos.z;
			hf.m_InDraw = m_Frustum.IsIn(dx, dy, dz, hf.m_Radius);
			if (hf.m_InDraw && !hf.IsReadyForDraw()) hf.m_InDraw = false;
			if (hf.m_InDraw) {
				f = -(dx * m_MatView.rawData[0 * 4 + 2] + dy * m_MatView.rawData[1 * 4 + 2] + dz * m_MatView.rawData[2 * 4 + 2] + m_MatView.rawData[3 * 4 + 2]);
				r = hf.m_Radius * 2; // *2 - для теней
				if ((f - r) < minz) minz = f - r;
				if ((f + r) > maxz) maxz = f + r;

				m_Bos.ObjAdd(dx, dy, dz, hf.m_Radius).m_Ptr = hf;
			}
		}
//		for (i = 0; i < m_CotlList.length; i++) {
//			hc = m_CotlList[i];
//			dx = hc.m_X - m_CamPos.x + m_ZoneSize * (hc.m_ZoneX - m_CamZoneX);
//			dy = hc.m_Y - m_CamPos.y + m_ZoneSize * (hc.m_ZoneY - m_CamZoneY);
//			dz = hc.m_Z - (m_CamPos.z);
//			hc.m_InDraw = m_Frustum.IsIn(dx, dy, dz, hc.m_Radius);
//			if (hc.m_InDraw) {
//			//if(false) { // Они ресуются без Z буфера. странно но почемуто учитывается z при рисовании созвездия
//				f = -(dx * m_MatView.rawData[0 * 4 + 2] + dy * m_MatView.rawData[1 * 4 + 2] + dz * m_MatView.rawData[2 * 4 + 2] + m_MatView.rawData[3 * 4 + 2]);
//				r = hc.m_Radius;
//				if ((f - r) < minz) minz = f - r;
//				if ((f + r) > maxz) maxz = f + r;
//			}
//		}
		for(i=0;i<m_ShuttleList.length;i++) {
			hs = m_ShuttleList[i];
			dx = hs.m_PosX - m_CamPos.x + m_ZoneSize * (hs.m_ZoneX - m_CamZoneX);
			dy = hs.m_PosY - m_CamPos.y + m_ZoneSize * (hs.m_ZoneY - m_CamZoneY);
			dz = hs.m_PosZ - m_CamPos.z;
			hs.m_InDraw = m_Frustum.IsIn(dx, dy, dz, hs.m_Radius);
			if (hs.m_InDraw && !hs.IsReadyForDraw()) hs.m_InDraw = false;
			if (hs.m_InDraw) {
				f = -(dx * m_MatView.rawData[0 * 4 + 2] + dy * m_MatView.rawData[1 * 4 + 2] + dz * m_MatView.rawData[2 * 4 + 2] + m_MatView.rawData[3 * 4 + 2]);
				r = hs.m_Radius * 2; // *2 - для теней
				if ((f - r) < minz) minz = f - r;
				if ((f + r) > maxz) maxz = f + r;

				m_Bos.ObjAdd(dx, dy, dz, hs.m_Radius).m_Ptr = hs;
			}
		}
		for(i=0;i<m_ContainerList.length;i++) {
			hcont = m_ContainerList[i];
			dx = hcont.m_PosX - m_CamPos.x + m_ZoneSize * (hcont.m_ZoneX - m_CamZoneX);
			dy = hcont.m_PosY - m_CamPos.y + m_ZoneSize * (hcont.m_ZoneY - m_CamZoneY);
			dz = hcont.m_PosZ - m_CamPos.z;
			hcont.m_InDraw = hcont.m_Vis;
			if (hcont.m_InDraw) hcont.m_InDraw = m_Frustum.IsIn(dx, dy, dz, hcont.m_Radius);
			if (hcont.m_InDraw && !hcont.IsReadyForDraw()) hcont.m_InDraw = false;
			if (hcont.m_InDraw) {
				f = -(dx * m_MatView.rawData[0 * 4 + 2] + dy * m_MatView.rawData[1 * 4 + 2] + dz * m_MatView.rawData[2 * 4 + 2] + m_MatView.rawData[3 * 4 + 2]);
				r = hcont.m_Radius * 2; // *2 - для теней
				if ((f - r) < minz) minz = f - r;
				if ((f + r) > maxz) maxz = f + r;

				m_Bos.ObjAdd(dx, dy, dz, hcont.m_Radius).m_Ptr = hcont;
			}
		}
		if (minz < 1.0) minz = 1.0;
		if (maxz > 100000.0) maxz = 100000.0;

//		minz = 1.0;
//		maxz = 10000.0;

//trace("min/max z", minz, maxz);
		m_MatPer.perspectiveFieldOfViewRH(m_Fov, Number(C3D.m_SizeX) / C3D.m_SizeY, minz, maxz);
		var sss:Number = ((1.0 - ZForFar) - ZForFullZ);
		m_MatPer.appendScale(1.0, 1.0, sss);
		m_MatPer.appendTranslation(0.0, 0.0, ZForFullZ);
		
		m_MatViewPer.copyFrom(m_MatView);
		m_MatViewPer.append(m_MatPer);
		m_FactorScr2WorldDist = Math.tan(m_Fov * 0.5) / Number(C3D.m_SizeY >> 1);

		// Расчитываем длину теней
		for(i=0;i<m_FleetList.length;i++) {
			hf = m_FleetList[i];
			if (!hf.m_InDraw) continue;
			hf.m_ShadowLength = CalcShadowLengthAll(hf, hf.m_Radius);
		}
		for(i=0;i<m_ShuttleList.length;i++) {
			hs = m_ShuttleList[i];
			if (!hs.m_InDraw) continue;
			hs.m_ShadowLength = CalcShadowLengthAll(hs, hs.m_Radius);
		}

		// Draw Before
		m_Bos.Sort(m_MatViewInv.rawData[3 * 4 + 0], m_MatViewInv.rawData[3 * 4 + 1], m_MatViewInv.rawData[3 * 4 + 2]);

		for (i = 0; i < m_FleetList.length; i++) {
			hf = m_FleetList[i];
			if (hf.m_InDraw) hf.DrawPrepare(dt);
		}
		for (i = 0; i < m_ShuttleList.length; i++) {
			hs = m_ShuttleList[i];
			if (hs.m_InDraw) hs.DrawPrepare(dt);
		}
		for (i = 0; i < m_PlanetList.length; i++) {
			hp = m_PlanetList[i];
			if(hp.m_InDraw) hp.DrawPrepare(dt);
		}
		for (i = 0; i < m_ContainerList.length; i++) {
			hcont = m_ContainerList[i];
			if(hcont.m_InDraw) hcont.DrawPrepare(dt);
		}

		// PassBG
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE );
		C3D.Context.setDepthTest(false, Context3DCompareMode.ALWAYS);
		C3D.Context.setStencilActions();
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.NONE);

		var adx:Number = 0;// 1900 / 2;// EM.m_CurTime / 50;
		var ady:Number = adx;
		
		var bgx:Number = m_CamZoneX * m_ZoneSize + m_CamPos.x;
		var bgy:Number = m_CamZoneY * m_ZoneSize + m_CamPos.y;
		if (m_CamPos.z != 0.0) {
			m_TPos.x = m_CamPos.x; m_TPos.y = m_CamPos.y; m_TPos.z = 0;
			m_TDir.x = 0.0; m_TDir.y = 0.0; m_TDir.z = 1.0;
			PlaneFromPointNormal(m_TPos, m_TDir, m_TPlane);
			m_TPos.x = m_CamPos.x + m_View.x;
			m_TPos.y = m_CamPos.y + m_View.y;
			m_TPos.z = m_CamPos.z + m_View.z;
			if (PlaneIntersectionLine(m_TPlane, m_CamPos, m_TPos, m_TDir)) {
				bgx = m_CamZoneX * m_ZoneSize + m_TDir.x;
				bgy = m_CamZoneY * m_ZoneSize + m_TDir.y;
			}
		}

		m_BG.Draw( bgx + adx, bgy + ady, 0);
		//m_BG.Draw( m_CamZoneX * m_ZoneSize + m_CamPos.x + adx, m_CamZoneY * m_ZoneSize + m_CamPos.y + ady, 1);
		m_BG.Draw( bgx + adx, bgy + ady, 2);

//			m_BG.Draw( (m_CamPos.x + adx) / 6, (m_CamPos.y + ady) / 6, 0);
//			m_BG.Draw( (m_CamPos.x + adx + 500) / 5 , (m_CamPos.y + ady + 500) / 5, 1);
//			m_BG.Draw( (m_CamPos.x + adx + 1000) / 4, (m_CamPos.y + ady + 1000) / 4, 2);

		//m_BG.Draw( m_CamPos.x / 2 + 1500, m_CamPos.y / 2 + 1500);

		// Pass.Cotl
		C3D.Context.setDepthTest(false, Context3DCompareMode.ALWAYS);
		C3D.Context.setCulling(Context3DTriangleFace.NONE);
		for (i = 0; i < m_CotlList.length; i++) {
			hc = m_CotlList[i];
			if (!hc.m_InDraw) continue;
			hc.PTakt(dt);
			hc.PDraw();
		}

/*			if (m_TestCotl == null) {
			m_TestCotl = new HyperspaceCotl(m_Map);
			m_TestCotl.m_ForTest = true;
			m_TestCotl.m_CotlId = 1;
			m_TestCotl.m_X = EM.m_FleetPosX;
			m_TestCotl.m_Y = EM.m_FleetPosY;
			m_TestCotl.PInit();
		}
		m_TestCotl.PTakt(dt);
		m_TestCotl.PDraw();*/

		// PassBG.Grid
		//C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		//m_BG.DrawGrid();

		// Pass Z
		C3D.m_Pass = C3D.PassZ;
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		C3D.Context.setDepthTest(true, Context3DCompareMode.LESS);
		C3D.Context.setStencilActions();
		C3D.Context.setColorMask(false, false, false, false);
		C3D.Context.setCulling(Context3DTriangleFace.FRONT);

		bobj = m_Bos.m_ObjFirst;
		while (bobj != null) {
			if (bobj.m_Ptr is HyperspaceFleet) HyperspaceFleet(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceShuttle) HyperspaceShuttle(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceContainer) HyperspaceContainer(bobj.m_Ptr).Draw();
			bobj = bobj.m_ObjNext;
		}
		//for(i=0;i<m_FleetList.length;i++) {
		//	hf = m_FleetList[i];
		//	if(hf.m_InDraw) hf.Draw();
		//}

		// Pass stencil shadow
		C3D.m_Pass = C3D.PassShadow;
		C3D.Context.setDepthTest(false, Context3DCompareMode.LESS);
		C3D.Context.setColorMask(false, false, false, false);

		bobj = m_Bos.m_ObjFirst;
		while (bobj != null) {
			if (bobj.m_Ptr is HyperspaceFleet) HyperspaceFleet(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceShuttle) HyperspaceShuttle(bobj.m_Ptr).Draw();
			bobj = bobj.m_ObjNext;
		}
//		for(i=0;i<m_FleetList.length;i++) {
//			hf = m_FleetList[i];
//			if(hf.m_InDraw) hf.Draw();
//		}

		// Pass Color on NoShadow side
		C3D.m_Pass = C3D.PassDif;
		C3D.Context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.FRONT);
		C3D.Context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL);
		C3D.Context.setStencilReferenceValue(0);

		bobj = m_Bos.m_ObjFirst;
		while (bobj != null) {
			if (bobj.m_Ptr is HyperspaceFleet) {
				HyperspaceFleet(bobj.m_Ptr).Draw();
			}
			else if (bobj.m_Ptr is HyperspaceShuttle) {
				HyperspaceShuttle(bobj.m_Ptr).Draw();
			}
			else if (bobj.m_Ptr is HyperspaceContainer) {
				HyperspaceContainer(bobj.m_Ptr).Draw();
			}
			bobj = bobj.m_ObjNext;
		}
//		for(i=0;i<m_FleetList.length;i++) {
//			hf = m_FleetList[i];
//			if(hf.m_InDraw) hf.Draw();
//		}

		// Pass Color on Shadow side
		C3D.m_Pass = C3D.PassDifShadow;
		C3D.Context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.FRONT);
		C3D.Context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.NOT_EQUAL);
		C3D.Context.setStencilReferenceValue(0);

		bobj = m_Bos.m_ObjFirst;
		while (bobj != null) {
			if (bobj.m_Ptr is HyperspaceFleet) HyperspaceFleet(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceShuttle) HyperspaceShuttle(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceContainer) HyperspaceContainer(bobj.m_Ptr).Draw();
			bobj = bobj.m_ObjNext;
		}
//		for(i=0;i<m_FleetList.length;i++) {
//			hf = m_FleetList[i];
//			if(hf.m_InDraw) hf.Draw();
//		}

		// Pass stencil rect
		C3D.Context.setDepthTest(false, Context3DCompareMode.ALWAYS);
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.NONE);
		C3D.Context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.NOT_EQUAL, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP, Context3DStencilAction.KEEP);
		C3D.Context.setStencilReferenceValue(0);

		//C3D.SetFConstColor(0, 0x8F0000FF);
		C3D.SetFConst_Color(0, m_ShadowColor);

		C3D.ShaderRectShadow();
		C3D.VBRectShadow();
		C3D.DrawQuad();

		// Pass luminescence
		C3D.m_Pass = C3D.PassLum;
		C3D.Context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.FRONT);
		C3D.Context.setStencilActions();

		bobj = m_Bos.m_ObjFirst;
		while (bobj != null) {
			if (bobj.m_Ptr is HyperspaceFleet) HyperspaceFleet(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceShuttle) HyperspaceShuttle(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceContainer) HyperspaceContainer(bobj.m_Ptr).Draw();
			bobj = bobj.m_ObjNext;
		}
//		for(i=0;i<m_FleetList.length;i++) {
//			hf = m_FleetList[i];
//			if(hf.m_InDraw) hf.Draw();
//		}
		
		// По порядку рисуем все "прозрачные" обекты
//trace("Draw.Transparent");
		bobj = m_Bos.m_ObjLast;
		while (bobj != null) {
			if (bobj.m_Ptr is HyperspaceFleet) {
				hf = HyperspaceFleet(bobj.m_Ptr);
//trace("    Fleet", hf.m_Id);

				C3D.m_Pass = C3D.PassParticle;
				//C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
				//C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE );
				C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
				C3D.Context.setDepthTest(false, Context3DCompareMode.LESS);
				C3D.Context.setStencilActions();
				C3D.Context.setColorMask(true, true, true, true);
				C3D.Context.setCulling(Context3DTriangleFace.NONE);

				hf.Draw();

			} else if (bobj.m_Ptr is HyperspaceShuttle) {
				hs = HyperspaceShuttle(bobj.m_Ptr);
//trace("    Shuttle", hs.m_Id);

				C3D.m_Pass = C3D.PassParticle;
				C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
				C3D.Context.setDepthTest(false, Context3DCompareMode.LESS);
				C3D.Context.setStencilActions();
				C3D.Context.setColorMask(true, true, true, true);
				C3D.Context.setCulling(Context3DTriangleFace.NONE);

				hs.Draw();

			} else if (bobj.m_Ptr is HyperspacePlanet) {
				hp = HyperspacePlanet(bobj.m_Ptr);
//trace("    Planet", hp.m_Id);

				C3D.m_Pass = C3D.PassDif;
				C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
				C3D.Context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
				C3D.Context.setStencilActions();
				C3D.Context.setColorMask(true, true, true, true);
				C3D.Context.setCulling(Context3DTriangleFace.FRONT);

				hp.Draw();

			} else if (bobj.m_Ptr is HyperspaceContainer) {
				hcont = HyperspaceContainer(bobj.m_Ptr);
//trace("    Container", hcont.m_Id);

				C3D.m_Pass = C3D.PassParticle;
				C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
				C3D.Context.setDepthTest(false, Context3DCompareMode.LESS);
				C3D.Context.setStencilActions();
				C3D.Context.setColorMask(true, true, true, true);
				C3D.Context.setCulling(Context3DTriangleFace.NONE);

				hcont.Draw();
			}
			bobj = bobj.m_ObjPrev;
		}

		// Z-буфер на все пространство.
		m_MatPer.perspectiveFieldOfViewRH(m_Fov, Number(C3D.m_SizeX) / C3D.m_SizeY, 1.0, 10000.0);
		m_MatPer.appendScale(1.0, 1.0, ZForFullZ);
		
		m_MatViewPer.copyFrom(m_MatView);
		m_MatViewPer.append(m_MatPer);

		C3D.m_Pass = C3D.PassZ;
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		C3D.Context.setDepthTest(true, Context3DCompareMode.LESS);
		C3D.Context.setStencilActions();
		C3D.Context.setColorMask(false, false, false, false);
		C3D.Context.setCulling(Context3DTriangleFace.FRONT);

		bobj = m_Bos.m_ObjFirst;
		while (bobj != null) {
			if (bobj.m_Ptr is HyperspaceFleet) HyperspaceFleet(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceShuttle) HyperspaceShuttle(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspacePlanet) HyperspacePlanet(bobj.m_Ptr).Draw();
			else if (bobj.m_Ptr is HyperspaceContainer) HyperspaceContainer(bobj.m_Ptr).Draw();
			bobj = bobj.m_ObjNext;
		}

		// Pass helper
		var h:C3DHelper;

		C3D.m_Pass = C3D.PassDif;
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		//C3D.Context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
		C3D.Context.setDepthTest(false, Context3DCompareMode.ALWAYS);
		C3D.Context.setStencilActions();
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.FRONT);

		// Pass helper bos
		if (false) {
			var ar:Array = new Array();
			
//			h = new C3DHelper();
//			h.Sphere(0 - (m_CamZoneX * m_ZoneSize + m_CamPos.x), 0 - (m_CamZoneY * m_ZoneSize + m_CamPos.y), 100 - (m_CamPos.z), 100, 0xff0000ff);
//			ar.push(h);

//			h = new C3DHelper();
//			h.Arrow(0.0, 0.0, 0.0, 100.0, 0.0, 0.0, 1.0, 5.0, 10.0, 0xffff0000);
//			ar.push(h);

//			h = new C3DHelper();
//			h.Arrow(0.0, 0.0, 0.0, 0.0, 100.0, 0.0, 1.0, 5.0, 10.0, 0xff00ff00);
//			ar.push(h);

//			h = new C3DHelper();
//			h.Arrow(0.0, 0.0, 0.0, 0.0, 0.0, 100.0, 1.0, 5.0, 10.0, 0xff0000ff);
//			ar.push(h);
			
//			h = new C3DHelper();
//			h.Arrow(0.0, 0.0, 0.0, 100.0, 100.0, 100.0, 1.0, 5.0, 10.0, 0xffffffff);
//			ar.push(h);

			if (m_Bos.m_NodeRoot) {
				m_Bos.m_NodeRoot.Helper(ar);
			}

			bobj = m_Bos.m_ObjFirst;
			while (bobj != null) {
				h = new C3DHelper();
				h.Sphere(bobj.m_X, bobj.m_Y, bobj.m_Z, 3.0, 0xffff0000);
				ar.push(h);
				bobj = bobj.m_ObjNext;
			}
			C3DHelper.Draw(ar, m_MatViewPer);
		}
		
		// Pass effect
		C3D.m_Pass = C3D.PassParticle;
		//C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		//C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE );
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		C3D.Context.setDepthTest(false, Context3DCompareMode.LESS);
		C3D.Context.setStencilActions();
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.NONE);

//		for(i=0;i<m_FleetList.length;i++) {
//			hf = m_FleetList[i];
//			if(hf.m_InDraw) hf.Draw();
//		}
		
		for (i = 0; i < m_BulletList.length; i++) {
			hb = m_BulletList[i];
			hb.Draw();
		}

		if (m_TestEffect != null) {
			m_TestEffect.Draw(m_CurTime, m_MatViewPer, m_MatView, m_MatViewInv, m_FactorScr2WorldDist);
		}
		
		// Dust
		//C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE );
		m_Dust.Draw();

		// Interface
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		C3D.Context.setDepthTest(false, Context3DCompareMode.ALWAYS);
		C3D.Context.setStencilActions();
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.NONE);

		for(i=0;i<m_ShuttleList.length;i++) {
			hs = m_ShuttleList[i];
			if(hs.m_InDraw) hs.DrawText();
		}
		for(i=0;i<m_FleetList.length;i++) {
			hf = m_FleetList[i];
			if(hf.m_InDraw) hf.DrawText();
		}
		for(i=0;i<m_ContainerList.length;i++) {
			hcont = m_ContainerList[i];
			if(hcont.m_InDraw) hcont.DrawText();
		}

/*			if (m_TestHalo == null) {
			m_TestHalo = new C3DHalo();
			m_TestHalo.InitBufs();
		}

		var tex:Texture = C3D.GetTexture("halo.png");
		if (tex) {
			C3D.Context.setDepthTest(true, Context3DCompareMode.LESS);
			C3D.SetTexture(0, tex);
			m_TestHalo.Draw(m_MatViewPer, m_CamDist, 502.0, 0.5, 100.0);
			C3D.SetTexture(0, null);
		}*/

/*		if (m_TestTextLine == null) {
			m_TestTextLine = new C3DTextLine();
			m_TestTextLine.SetFont("normal_outline");
			//m_TestTextLine.SetText("Hello world!!!\nline 2V.\nline 3");
			m_TestTextLine.SetText("Word0 Word1 Word2 Word3 Word4 Word5 Word6 Word7 Word8 Word9 Word10 Word11 Word12 Word13 Word14 Word15 Word16");
			m_TestTextLine.SetFormat( 2, 200, true, 20);
		}
		m_TestTextLine.Draw(150 + 0.5, 200, 1, 1, 0xffff0000);
		m_TestTextLine.Draw(150 + 0.3, 200, 1, -1, 0xffffff00);
		m_TestTextLine.Draw(150, 200, -1, 1, 0xff0000ff);
		m_TestTextLine.Draw(150, 200, -1, -1, 0xff00ffff);*/

		//if (m_HyperspaceEngine == null) {
		//	m_HyperspaceEngine = new HyperspaceEngine();
		//	m_HyperspaceEngine.Init(0.0, 0.0, 0.0,
		//		1.0, 0.0, 0.0,
		//		0.0, 1.0, 0.0,
		//		1.5, 0.0, 0.0, 0xffffffff);
		//		
		//	for (i = 0; i < 50; i++) m_HyperspaceEngine.Takt(20);
		//}
		//m_HyperspaceEngine.Takt(dt);
		//m_HyperspaceEngine.Takt(0);
		//m_HyperspaceEngine.Draw();

		// Final
		//C3D.RanderMainTexture();
	}
	
	public function CalcShadowLength(oposx:Number, oposy:Number, oposz:Number, oradius:Number, rposx:Number, rposy:Number, rposz:Number, rradius:Number):Number
	{
		var shadowdirx:Number = -m_Light.x;
		var shadowdiry:Number = -m_Light.y;
		var shadowdirz:Number = -m_Light.z;

		var vx:Number = rposx - oposx;
		var vy:Number = rposy - oposy;
		var vz:Number = rposz - oposz;

		var t:Number = vx * shadowdirx + vy * shadowdiry + vz * shadowdirz;
		if (t < -(oradius + rradius)) return oradius; // обект находится впереди

		var px:Number = oposx + t * shadowdirx - rposx;
		var py:Number = oposy + t * shadowdiry - rposy;
		var pz:Number = oposz + t * shadowdirz - rposz;

		if ((px * px + py * py + pz * pz) > (oradius + rradius) * (oradius + rradius)) return oradius; // Объект находится далеко в стороне

		return t + rradius;
	}
}
	
}