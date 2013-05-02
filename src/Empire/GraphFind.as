// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;

public class GraphFind extends Sprite
{
	private var m_Map:EmpireMap;
	
	public var m_CotlId:uint=0;
	public var m_SectorX:int=0; 
	public var m_SectorY:int=0;
	public var m_PlanetNum:int=-1;
	public var m_ShipNum:int=-1;
	public var m_ShipId:uint=0;
	
	public var m_TimeAdd:Number=0;
	public var m_TimeBegin:Number=0;
	
	public var m_Delay:Number = 0;
	
	public var m_Graph:Sprite = new GraphFindEx();

	public function GraphFind(map:EmpireMap, cotlid:uint, secx:int, secy:int, planetnum:int, shipnum:int, shipid:uint)
	{
		m_Map = map;
		
		addChild(m_Graph);

		m_CotlId=cotlid;	
		m_SectorX=secx;
		m_SectorY=secy;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_ShipId=shipid;

		m_TimeAdd=Common.GetTime();
		
		visible=false;		
	}
	
	public function Update():Boolean
	{
		var i:int;
		var planet:Planet=null;
		if(Server.Self.m_CotlId==m_CotlId) planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		var gship:GraphShip=null;
		if(m_ShipId!=0) gship=m_Map.GetGraphShipById(m_ShipId);
		else if (m_ShipNum >= 0) gship = m_Map.GetGraphShip(m_SectorX, m_SectorY, m_PlanetNum, m_ShipNum);
		else if (m_ShipNum == -2) {
			if (planet != null) {
				for (i = 0; i < Common.ShipOnPlanetMax; i++) {
					var ship:Ship = planet.m_Ship[i];
					if (ship.m_Type == Common.ShipTypeQuarkBase && ship.m_Owner == Server.Self.m_UserId) break;
				}
				if (i < Common.ShipOnPlanetMax) gship = m_Map.GetGraphShip(m_SectorX, m_SectorY, m_PlanetNum, i);
			}
		}

		if (m_TimeBegin != 0) {
			if (m_ShipNum == -2) {
				if(gship==null) return false;
			} else if(m_ShipNum<0 && m_ShipId==0) {
				if(planet==null) return false;
			} else {
				if(gship==null) return false;
			}
		} else {
			if (m_ShipNum == -2) {
				if(gship!=null) m_TimeBegin=Common.GetTime();
			} else if(m_ShipNum<0 && m_ShipId==0) {
				if(planet!=null) m_TimeBegin=Common.GetTime();
			} else {
				if(gship!=null) m_TimeBegin=Common.GetTime();
			}
			
			if(m_TimeBegin==0 && (Common.GetTime()-m_TimeAdd)>3000) return false;
		}

		if(m_TimeBegin==0) return true;

		var p:Number = (Common.GetTime() - (m_TimeBegin + m_Delay)) / 1000;
		if(p<=0.0) return true;
		if(p>=1.0) return false;

		visible=true;

		if(gship) {
			x=gship.x;
			y=gship.y;
		} else {
			x = m_Map.WorldToScreenX(planet.m_PosX, planet.m_PosY);
			y = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(planet.m_PosY);
		}

		p=p*p;

		scaleX=1.0-p*0.7;
		scaleY=1.0-p*0.7;
		alpha=1.0-p*0.9;
		
		return true;
	}
}

}
