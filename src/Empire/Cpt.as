// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import flash.display.*;
import flash.geom.*;
import flash.system.*;
import flash.utils.*;

public class Cpt
{
	public var m_Id:uint=0;

	public var m_CotlId:int=0;
	public var m_SectorX:int=0;
	public var m_SectorY:int=0;
	public var m_PlanetNum:int=-1;
//	var m_ArrivalTime:Number=0;

	public var m_PortalCooldown:Number = 0;
	public var m_InvuCooldown:Number = 0;
	public var m_AcceleratorCooldown:Number = 0;
	public var m_CoverCooldown:Number = 0;
	public var m_ExchangeCooldown:Number = 0;
	public var m_GravitorCooldown:Number = 0;
	public var m_RechargeCooldown:Number = 0;
	public var m_ConstructorCooldown:Number = 0;

	public var m_Flag:int = 0;

	public var m_Race:int=Common.RaceNone;
	public var m_Face:int=0;

	public var m_Name:String;
	
//	var m_StatTransportCnt:int=0;
//	var m_StatCorvetteCnt:int=0;
//	var m_StatCruiserCnt:int=0;
//	var m_StatDreadnoughtCnt:int=0;
//	var m_StatInvaderCnt:int=0;
//	var m_StatDevastatorCnt:int=0;
//	var m_StatGroupCnt:int=0;

	public var m_Talent:Array=new Array(Common.TalentCnt);

	public function Cpt()
	{
		var i:int;
		for(i=0;i<Common.TalentCnt;i++) m_Talent[i]=0;
	}

	public function CalcVecLvl(vec:int):int
	{
		var i:int,u:int;
		var lvl:int=0;
		for(i=0;i<Common.TalentCnt;i++) {
			var val:uint=m_Talent[i];
			for(u=0;u<32;u++) {
				if(Common.TalentVec[32*i+u]!=vec) continue;
				if(val & (1<<u)) lvl++;
			}
		}
		return lvl;
	}

	public function CalcAllLvl():int
	{
		var i:int,u:int;
		var lvl:int=0;
		for(i=0;i<Common.TalentCnt;i++) {
			var val:uint=m_Talent[i];
			for(u=0;u<32;u++) {
				if(val & (1<<u)) lvl++;
			}
		}
		return lvl;
	}

	public function InHyperspace():Boolean
	{
		return (m_CotlId==0) && (m_PlanetNum>=0);
	}
}

}
