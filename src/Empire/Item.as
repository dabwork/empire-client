// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
	
public class Item
{
	static public const BonusCnt:int = 16;
	static public const CoefCnt:int = 16;
	
//	static public const stNone:int=0;
//	static public const stBlue:int=1;
//	static public const stGreen:int=2;
//	static public const stRed:int=3;
//	static public const stYellow:int=4;
	
	static public const btArmour:int=1;
	static public const btPower:int=2;
	static public const btRepair:int=3;
	static public const btArmourAll:int=4;
	static public const btMinePower:int=5;

	public var m_Id:uint=0;
	public var m_SlotType:int=0;
	public var m_Lvl:int=0;
	public var m_StackMax:int=0;
	public var m_Img:uint = 0;
	public var m_Step:int=0;
	public var m_OwnerId:uint=0;

	public var m_BonusType:Vector.<uint> = new Vector.<uint>(BonusCnt, true);
	public var m_BonusVal:Vector.<int> = new Vector.<int>(BonusCnt, true);
	public var m_BonusDif:Vector.<int> = new Vector.<int>(BonusCnt, true);

	public var m_CoefCnt:Vector.<uint> = new Vector.<uint>(BonusCnt, true);
	public var m_CoefShift:Vector.<uint> = new Vector.<uint>(BonusCnt, true);
	public var m_CoefBit:Vector.<uint> = new Vector.<uint>(BonusCnt, true);
	public var m_Coef:Vector.<int> = new Vector.<int>(BonusCnt * CoefCnt, true);

	public var m_LoadDate:Number=0;
	public var m_GetTime:Number=0;

	public function Item()
	{
		var i:int, u:int;
		for (i = 0; i < BonusCnt; i++) {
			m_BonusType[i] = 0;
			m_BonusVal[i] = 0;
			m_BonusDif[i] = 0;
			m_CoefCnt[i] = 0;
			for (u = 0; u < CoefCnt; u++) {
				m_Coef[i * CoefCnt + u] = 0;
			}
		}
	}

	public function IsEq():Boolean
	{
		return m_SlotType == Hangar.stEnergy || m_SlotType == Hangar.stCharge || m_SlotType == Hangar.stCore;
	}

	public function IsEqReactor():Boolean
	{
		var i:int;
		if (!IsEq()) return false;
		for (i = 0; i < BonusCnt; i++) {
			if (m_BonusType[i] != Common.ItemBonusEnergy) continue;
			if (m_Coef[i * CoefCnt + 0] > 0) return true;
		}
		return false;
	}
}

}
