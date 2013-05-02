// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import flash.display.*;
import flash.text.TextField;

public class FleetSlot
{
	public var m_Id:uint=0;
	public var m_Type:int=Common.ShipTypeNone;
	public var m_Cnt:int=0;
	public var m_CntDestroy:int=0;
	public var m_HP:int=0;
	public var m_Shield:int=0;
	public var m_ItemType:int=Common.ItemTypeNone;
	public var m_ItemCnt:int=0;

	public var m_SlotN:Sprite=null;
	public var m_SlotA:Sprite=null;
	public var m_Ship:Sprite=null;
	public var m_Txt:TextField=null;
	public var m_ItemIcon:Sprite=null;
	public var m_ItemTypeShow:int=-1;
	
	public var m_GraphType:int=-1;
	public var m_GraphRace:int=-1;
	public var m_GraphOwner:int=-1;
	public var m_GraphSubType:int=-1;

	public function FleetSlot()
	{
	}

	public function Copy(src:FleetSlot):void
	{
		m_Id=src.m_Id;
		m_Type=src.m_Type;
		m_Cnt=src.m_Cnt;
		m_CntDestroy=src.m_CntDestroy;
		m_HP=src.m_HP;
		m_Shield=src.m_Shield;
		m_ItemType=src.m_ItemType;
		m_ItemCnt=src.m_ItemCnt;
	}

	public function Clear():void
	{
		m_Id=0;
		m_Type=Common.ShipTypeNone;
		m_Cnt=0;
		m_CntDestroy=0;
		m_HP=0;
		m_Shield=0;
		m_ItemType=Common.ItemTypeNone;
		m_ItemCnt=0;
	}
}

}
