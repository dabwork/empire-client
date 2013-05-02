// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import flash.display.*;
import flash.geom.*;
import flash.system.*;
import flash.utils.*;

public class User
{
    static public const AccessDevAssignRights:uint = 1 << 16;
    static public const AccessDevView:uint = 1 << 17;
    static public const AccessDevEditMap:uint = 1 << 18;
    static public const AccessDevEditCode:uint = 1 << 19;
    static public const AccessDevEditOps:uint = 1 << 20;
    static public const AccessGalaxyJump:uint = 1 << 24;
    static public const AccessGalaxyAdmin:uint = 1 << 25;
    static public const AccessGalaxyOps:uint = 1 << 26;
    static public const AccessGalaxyText:uint = 1 << 27;

	public var m_Id:uint=0;
	public var m_Version:uint=0;
	public var m_LoadDate:Number=0;
	public var m_SysName:String='';
	public var m_Score:int=0;
	public var m_Rest:int=0;
	public var m_Exp:int=0;
	public var m_Rating:int = 0;
	public var m_CombatRating:int = 0;
	public var m_Race:int;
	public var m_Flag:uint = 0;

	public var m_PlanetShieldEnd:Number=0;
	public var m_PlanetShieldCooldown:Number=0;
	public var m_HourPlanetShield:Number=0;

	public var m_ExitDate:Number=0;

	public var m_GetTime:Number=0;

	public var m_RelNum:int=0;
	public var m_RelVer:uint=0;

	public var m_HomeworldCotlId:int=0;
	public var m_HomeworldSectorX:int=0;
	public var m_HomeworldSectorY:int=0;
	public var m_HomeworldPlanetNum:int=-1;
//	public var m_CitadelCotlId:int=0;
//	public var m_CitadelSectorX:int=0;
//	public var m_CitadelSectorY:int=0;
//	public var m_CitadelPlanetNum:int=-1;

	public var m_UnionId:uint = 0;

	public var m_CombatId:uint = 0;

	public var m_Team:int = 0;
	public var m_PowerMul:uint = 0;
	public var m_ManufMul:uint = 0;

	public var m_Tech:Vector.<uint> = new Vector.<uint>(Common.TechCnt, true);
	public var m_Cpt:Array = null;
	public var m_BuildingLvl:Vector.<uint> = new Vector.<uint>(Common.BuildingTypeCnt, true);

	public var m_IB1_Type:uint = 0;
	public var m_IB1_Date:Number = 0;
	public var m_IB2_Type:uint = 0;
	public var m_IB2_Date:Number = 0;

	public function User()
	{
		var i:int;
		for (i = 0; i < Common.TechCnt; i++) m_Tech[i] = 0;
		for (i = 0; i < Common.BuildingTypeCnt; i++) m_BuildingLvl[i] = 0;
	}
	
	public function Unload():void
	{
		m_Version=0;
		m_LoadDate=0;
		m_SysName='';
		m_Score=0;
		m_Rest=0;
		m_Exp=0;
		m_Rating = 0;
		m_CombatRating = 0;
		m_Race;

		m_PlanetShieldEnd=0;
		m_PlanetShieldCooldown=0;
		m_HourPlanetShield=0;

		m_ExitDate=0;

		m_GetTime=0;

		m_RelNum=0;
		m_RelVer=0;
	
		m_HomeworldCotlId=0;
		m_HomeworldSectorX=0;
		m_HomeworldSectorY=0;
		m_HomeworldPlanetNum=-1;
//		m_CitadelCotlId=0;
//		m_CitadelSectorX=0;
//		m_CitadelSectorY=0;
//		m_CitadelPlanetNum=-1;
	
		m_UnionId=0;
	}

	public function CalcDirLvl(dir:int):int
	{
		var i:int,u:int;
		var lvl:int=0;
		for(i=0;i<Common.TechCnt;i++) {
			var val:uint=m_Tech[i];
			for(u=0;u<32;u++) {
				if(Common.TechDir[32*i+u]!=dir) continue;
				if(val & (1<<u)) lvl++;
			}
		}
		return lvl;
	}

	public function GetCpt(id:uint):Cpt
	{
		id&=~Common.FlagshipIdFlag;
		if(m_Cpt==null) return null;
		var i:int;
		for(i=0;i<m_Cpt.length;i++) {
			var cpt:Cpt=m_Cpt[i];
			if((cpt.m_Id & ~(Common.FlagshipIdFlag))==id) return cpt;
		}
		return null;
	}

	public function GetCptNum(id:uint):int
	{
		id&=~Common.FlagshipIdFlag;
		if(m_Cpt==null) return -1;
		var i:int;
		for(i=0;i<m_Cpt.length;i++) {
			var cpt:Cpt=m_Cpt[i];
			if((cpt.m_Id & ~(Common.FlagshipIdFlag))==id) return i;
		}
		return -1;
	}

	public function AddCpt(id:uint):Cpt
	{
		var cpt:Cpt=GetCpt(id);
		if(cpt!=null) return cpt;
		
		if(m_Cpt==null) m_Cpt=new Array();
		
		cpt = new Cpt();
		m_Cpt.push(cpt);
		cpt.m_Id=id & (~Common.FlagshipIdFlag);

		return cpt; 
	}
}

}
