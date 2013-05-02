// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Matrix;
import flash.utils.Dictionary;
import flash.utils.Timer;

public class GraphShipImgs extends Sprite
{
/*	private var m_Map:EmpireMap;

	public var m_List:Dictionary = new Dictionary();
	public var m_ListMissile:Dictionary = new Dictionary();

	public var m_CalcWidth:Boolean = false;

	public var m_Prepare:Boolean = false;
	public var m_SmoothOk:Boolean = false;

	public var m_Test:Boolean = false;

	public var m_SmoothCalc:Array = new Array();
	public var m_SmoothCalcNum:int = 0;

	public var m_ShipCalcTimer:Timer = new Timer(1);

	public function GraphShipImgs(map:EmpireMap)
	{
		m_ShipCalcTimer.addEventListener("timer",ShipCalcTimer);
		m_ShipCalcTimer.stop();
		m_Map = map;
	}
	
	public function GetImage(type:int, race:int, subtype:int, scale:Number, angle:Number, offx:Number, offy:Number):BitmapData
	{
		if (Common.IsBase(type)) {
			race = 0;
			angle = 0;
		}
		if (type == Common.ShipTypeKling0 || type == Common.ShipTypeKling1) { race = Common.RaceKling;  }
		if (type == Common.ShipTypeFlagship) { race = Common.RaceNone; }
		
		var aoff:Number = 128;
		var ai:Number = aoff + Math.round((Common.AngleNorm(angle) / Math.PI) * aoff); if (ai < 0) ai = 0; else if(ai>=aoff*2) ai=aoff*2-1;
		//if (ai < 128) ai = 128; else if(ai>=128+64) ai=128;
		var si:int = 0;
		if(scale<0.95) si=1;

		var spm:Number = 3;
		var kx:Number = Math.floor(offx * spm); if (kx >= spm) kx = 0;
		var ky:Number = Math.floor(offy * spm); if (ky >= spm) ky = 0;
		var key:uint = (uint(type) << 24) | (uint(race) << 20) | (subtype << 16) | (si<<12) | ai | (kx<<8) | (ky<<10);

		if (m_List[key] != undefined) {
			return m_List[key];
		}

//if(m_Test) trace("Calc: " + Common.ShipName[type] + " " + Common.RaceSysName[race] + " Scale=" + si.toString() + " Angle=" + ai.toString() + " off=" + kx.toString() + "," + ky.toString());

		var sp:Sprite = GraphShip.GetImageByType(type, race, subtype);
		//sp.rotation=angle * 180.0 / Math.PI

		var size:Number = 70;
		if (m_CalcWidth) size = 150;
		else if (race == Common.RaceGrantar) { 
			if (type == Common.ShipTypeTransport) { if (si == 0) size = 50; else sizex = 40; }
			else if (type == Common.ShipTypeCorvette) { if (si == 0) size = 42; else sizex = 34; }
			else if (type == Common.ShipTypeCruiser) { if (si == 0) size = 54; else sizex = 44; }
			else if (type == Common.ShipTypeDreadnought) { if (si == 0) size = 52; else sizex = 42; }
			else if (type == Common.ShipTypeInvader) { if (si == 0) size = 56; else sizex = 46; }
			else if (type == Common.ShipTypeDevastator) { if (si == 0) size = 54; else sizex = 44; }
		} else if (race == Common.RacePeleng) { 
			if (type == Common.ShipTypeTransport) { if (si == 0) size = 58; else sizex = 48; }
			else if (type == Common.ShipTypeCorvette) { if (si == 0) size = 50; else sizex = 40; }
			else if (type == Common.ShipTypeCruiser) { if (si == 0) size = 58; else sizex = 46; }
			else if (type == Common.ShipTypeDreadnought) { if (si == 0) size = 64; else sizex = 52; }
			else if (type == Common.ShipTypeInvader) { if (si == 0) size = 54; else sizex = 44; }
			else if (type == Common.ShipTypeDevastator) { if (si == 0) size = 56; else sizex = 46; }
		} else if (race == Common.RacePeople) { 
			if (type == Common.ShipTypeTransport) { if (si == 0) size = 54; else sizex = 44; }
			else if (type == Common.ShipTypeCorvette) { if (si == 0) size = 48; else sizex = 38; }
			else if (type == Common.ShipTypeCruiser) { if (si == 0) size = 58; else sizex = 48; }
			else if (type == Common.ShipTypeDreadnought) { if (si == 0) size = 52; else sizex = 42; }
			else if (type == Common.ShipTypeInvader) { if (si == 0) size = 58; else sizex = 48; }
			else if (type == Common.ShipTypeDevastator) { if (si == 0) size = 62; else sizex = 50; }
		} else if (race == Common.RaceTechnol) {
			if (type == Common.ShipTypeTransport) { if (si == 0) size = 54; else sizex = 44; }
			else if (type == Common.ShipTypeCorvette) { if (si == 0) size = 54; else sizex = 44; }
			else if (type == Common.ShipTypeCruiser) { if (si == 0) size = 52; else sizex = 42; }
			else if (type == Common.ShipTypeDreadnought) { if (si == 0) size = 54; else sizex = 44; }
			else if (type == Common.ShipTypeInvader) { if (si == 0) size = 58; else sizex = 46; }
			else if (type == Common.ShipTypeDevastator) { if (si == 0) size = 48; else sizex = 38; }
		} else if (race == Common.RaceGaal) { 
			if (type == Common.ShipTypeTransport) { if (si == 0) size = 62; else sizex = 50; }
			else if (type == Common.ShipTypeCorvette) { if (si == 0) size = 56; else sizex = 44; }
			else if (type == Common.ShipTypeCruiser) { if (si == 0) size = 48; else sizex = 38; }
			else if (type == Common.ShipTypeDreadnought) { if (si == 0) size = 56; else sizex = 44; }
			else if (type == Common.ShipTypeInvader) { if (si == 0) size = 56; else sizex = 44; }
			else if (type == Common.ShipTypeDevastator) { if (si == 0) size = 54; else sizex = 44; }
		} else if (type == Common.ShipTypeWarBase) {
			if (si == 0) size = 66; else sizex = 54;
		} else if (type == Common.ShipTypeShipyard) {
			if (si == 0) size = 66; else sizex = 54;
		} else if (type == Common.ShipTypeSciBase) {
			if (si == 0) size = 62; else sizex = 50;
		} else if (type == Common.ShipTypeServiceBase) {
			if (si == 0) size = 66; else sizex = 54;
		} else if (type == Common.ShipTypeQuarkBase) {
			if (si == 0) size = 66; else sizex = 54;
		} else if (type == Common.ShipTypeKling0) {
			if (si == 0) size = 42; else sizex = 34;
		} else if (type == Common.ShipTypeKling1) {
			if (si == 0) size = 66; else sizex = 52;
		}

		var sizex:Number = size;
		var sizey:Number = size;

		var bm:BitmapData = new BitmapData(sizex, sizey, true, 0);

		var m:Matrix = new Matrix();
		m.scale(sp.scaleX * scale,sp.scaleX * scale);
		//m.rotate(angle);
		m.rotate((Number(ai - Number(aoff)) / Number(aoff)) * Math.PI);
		m.translate(Math.floor(sizex/2) + (1.0/Number(spm)) * Number(kx), Math.floor(sizey/2) + (1.0/Number(spm)) * Number(ky));

		bm.draw(sp, m, null, null, null, true);

		m_List[key] = bm;

		return bm;
	}

	public function GetMissile(angle:Number):BitmapData
	{
		var ai:int = 200 + Math.round((Common.AngleNorm(angle) / Math.PI) * 64);
		//var si:int = Math.round(scale * 32);
		var key:uint = ai;
		
		if (m_ListMissile[key] != undefined) {
			return m_ListMissile[key];
		}
		
		var sp:Sprite = new Missile();
		//sp.rotation=angle * 180.0 / Math.PI
		
		var bm:BitmapData = new BitmapData(20, 20, true, 0);
		
		var m:Matrix = new Matrix();
		//m.scale(sp.scaleX * scale,sp.scaleX * scale);
		m.rotate(angle);
		m.translate(10, 10);
		
		bm.draw(sp, m);
		
		m_ListMissile[key] = bm;
		
		return bm;
	}
	
	public function BitmapCalcTrimLeft(bmd:BitmapData):int
	{
		var x:int, y:int;
		for (x = 0; x < bmd.width; x++) {
			for (y = 0; y < bmd.height; y++) {
				if (bmd.getPixel32(x, y)!=0) return x;
			}
		}
		return 0;
	}

	public function BitmapCalcTrimRight(bmd:BitmapData):int
	{
		var x:int, y:int;
		for (x = bmd.width - 1; x >= 0 ; x--) {
			for (y = 0; y < bmd.height; y++) {
				if (bmd.getPixel32(x, y)!=0) return bmd.width-(x+1);
			}
		}
		return 0;
	}

	public function BitmapCalcTrimTop(bmd:BitmapData):int
	{
		var x:int, y:int;
		for (y = 0; y < bmd.height; y++) {
			for (x = 0; x < bmd.width; x++) {
				if (bmd.getPixel32(x, y)!=0) return y;
			}
		}
		return 0;
	}

	public function BitmapCalcTrimBottom(bmd:BitmapData):int
	{
		var x:int, y:int;
		for (y = bmd.height - 1; y >= 0 ; y--) {
			for (x = 0; x < bmd.width; x++) {
				if (bmd.getPixel32(x, y) != 0) return bmd.height - (y + 1);
			}
		}
		return 0;
	}

	public function CalcShipImgSizeInner(type:int, race:int, subtype:int, scale:Number):void
	{
		var a:Number, cx:Number, cy:Number;
		var bmd:BitmapData;
		var maxsizex:int = 0;
		var maxsizey:int = 0;

		a = 0.0;
		while(true) {
			if(m_CalcWidth) {
				bmd = GetImage(type, race, subtype, scale, a, 0.0, 0.0);
				
				cx = Math.floor(bmd.width / 2);
				cy = Math.floor(bmd.height / 2);

				var sx:int = Math.max(cx - 0 - BitmapCalcTrimLeft(bmd), bmd.width - cx - BitmapCalcTrimRight(bmd));
				sx = sx * 2 + 2;

				var sy:int = Math.max(cy - 0 - BitmapCalcTrimTop(bmd), bmd.height - cy - BitmapCalcTrimBottom(bmd));
				sy = sy * 2 + 2;

//trace(sx,sy);

				maxsizex = Math.max(maxsizex, sx);
				maxsizey = Math.max(maxsizey, sy);
			} else {
				for (cy = 0.0; cy < 1.0; cy += 1.0 / 3.0) {
					for (cx = 0.0; cx < 1.0; cx += 1.0 / 3.0) {
						//GetImage(type, race, subtype, scale, a, cx, cy);
						//if (cx == 0.0 && cy == 0.0) continue;
						var obj:Object = new Object();
						obj.Type = type;
						obj.Race = race;
						obj.SubType = subtype;
						obj.Scale = scale;
						obj.Angle = a;
						obj.OffX = cx;
						obj.OffY = cy;
						m_SmoothCalc.push(obj);
					}
				}
				GetImage(type, race, subtype, scale, a, 0.0, 0.0);
			}

			if (Common.IsBase(type)) break;
			a += Math.PI / 180.0 * 1.0;
			if (a >= Math.PI * 0.5) break;
		}

		if(m_CalcWidth) trace("SIS: " + Common.ShipName[type] + " " + Common.RaceSysName[race] + " Scale=" + scale.toString() + " Size=" + Math.max(maxsizex, maxsizey).toString());
	}

	public function CalcShipImgSize():void
	{
		var r:int;
		
		var calcw:Boolean = true;

		if(calcw) m_CalcWidth = true;
		
		var scalenormal:Number = 1.0;
		var scalesmall:Number = 0.8;
		
		for (r = Common.RaceGrantar; r <= Common.RaceGaal; r++) {
			CalcShipImgSizeInner(Common.ShipTypeTransport, r, 0, scalenormal);
//			CalcShipImgSizeInner(Common.ShipTypeTransport, r, 0, scalesmall);
			CalcShipImgSizeInner(Common.ShipTypeCorvette, r, 0, scalenormal);
//			CalcShipImgSizeInner(Common.ShipTypeCorvette, r, 0, scalesmall);
			CalcShipImgSizeInner(Common.ShipTypeCruiser, r, 0, scalenormal);
//			CalcShipImgSizeInner(Common.ShipTypeCruiser, r, 0, scalesmall);
			CalcShipImgSizeInner(Common.ShipTypeDreadnought, r, 0, scalenormal);
//			CalcShipImgSizeInner(Common.ShipTypeDreadnought, r, 0, scalesmall);
			CalcShipImgSizeInner(Common.ShipTypeInvader, r, 0, scalenormal);
//			CalcShipImgSizeInner(Common.ShipTypeInvader, r, 0, scalesmall);
			CalcShipImgSizeInner(Common.ShipTypeDevastator, r, 0, scalenormal);
//			CalcShipImgSizeInner(Common.ShipTypeDevastator, r, 0, scalesmall);
		}

		CalcShipImgSizeInner(Common.ShipTypeWarBase, Common.RaceNone, 0, scalenormal);
//		CalcShipImgSizeInner(Common.ShipTypeWarBase, Common.RaceNone, 0, scalesmall);
		CalcShipImgSizeInner(Common.ShipTypeShipyard, Common.RaceNone, 0, scalenormal);
//		CalcShipImgSizeInner(Common.ShipTypeShipyard, Common.RaceNone, 0, scalesmall);
		CalcShipImgSizeInner(Common.ShipTypeSciBase, Common.RaceNone, 0, scalenormal);
//		CalcShipImgSizeInner(Common.ShipTypeSciBase, Common.RaceNone, 0, scalesmall);
		CalcShipImgSizeInner(Common.ShipTypeServiceBase, Common.RaceNone, 0, scalenormal);
//		CalcShipImgSizeInner(Common.ShipTypeServiceBase, Common.RaceNone, 0, scalesmall);
		
		CalcShipImgSizeInner(Common.ShipTypeKling0, Common.RaceKling, 0, scalenormal);
//		CalcShipImgSizeInner(Common.ShipTypeKling0, Common.RaceKling, 0, scalesmall);
		CalcShipImgSizeInner(Common.ShipTypeKling1, Common.RaceKling, 0, scalenormal);
//		CalcShipImgSizeInner(Common.ShipTypeKling1, Common.RaceKling, 0, scalesmall);

		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 0, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 1, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 2, scalenormal);

		if (calcw) {
			m_CalcWidth = false;
			m_List.length = 0;
			m_List = new Dictionary();
		}
		
//		m_Test = true;
	}

	public function PrepareShip():void
	{
return;
//		CalcShipImgSize();

		if (m_Map.m_Set_ShipType == 0) return;

		if (m_Prepare) {
			if(m_Map.m_Set_ShipType==2 && !m_SmoothOk && !m_ShipCalcTimer.running) m_ShipCalcTimer.start();
			return;
		}
		m_Prepare = true;

		var r:int;

		var scalenormal:Number = 1.0;

		for (r = Common.RaceGrantar; r <= Common.RaceGaal; r++) {
			CalcShipImgSizeInner(Common.ShipTypeTransport, r, 0, scalenormal);
			CalcShipImgSizeInner(Common.ShipTypeCorvette, r, 0, scalenormal);
			CalcShipImgSizeInner(Common.ShipTypeCruiser, r, 0, scalenormal);
			CalcShipImgSizeInner(Common.ShipTypeDreadnought, r, 0, scalenormal);
			CalcShipImgSizeInner(Common.ShipTypeInvader, r, 0, scalenormal);
			CalcShipImgSizeInner(Common.ShipTypeDevastator, r, 0, scalenormal);
		}

		CalcShipImgSizeInner(Common.ShipTypeWarBase, Common.RaceNone, 0, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeShipyard, Common.RaceNone, 0, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeSciBase, Common.RaceNone, 0, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeServiceBase, Common.RaceNone, 0, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeQuarkBase, Common.RaceNone, 0, scalenormal);

		CalcShipImgSizeInner(Common.ShipTypeKling0, Common.RaceKling, 0, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeKling1, Common.RaceKling, 0, scalenormal);

		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 0, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 1, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 2, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 3, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 4, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 5, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 6, scalenormal);
		CalcShipImgSizeInner(Common.ShipTypeFlagship, Common.RaceNone, 7, scalenormal);

		if (m_Map.m_Set_ShipType == 2) m_ShipCalcTimer.start();
	}

	public function ShipCalcTimer(event:TimerEvent):void
	{
		var loop:int;
		for (loop = 0; loop < 10; loop++) {
			var obj:Object = m_SmoothCalc[m_SmoothCalcNum];
			m_SmoothCalcNum++;

			GetImage(obj.Type, obj.Race, obj.SubType, obj.Scale, obj.Angle, obj.OffX, obj.OffY);

			if (m_SmoothCalcNum >= m_SmoothCalc.length) {
				m_SmoothCalc.length = 0;
				m_SmoothOk = true;
				m_ShipCalcTimer.stop();
				return;
			}
		}
	}*/
};

}