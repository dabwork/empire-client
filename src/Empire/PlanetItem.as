// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
	
public class PlanetItem
{
	public var m_Type:uint = 0;
	public var m_Cnt:int = 0;
	public var m_Owner:uint = 0;
	public var m_Complete:int = 0;
	public var m_Broken:int = 0;
	public var m_Flag:uint = 0;

	static public const PlanetItemFlagBuild:uint = 1;
	static public const PlanetItemFlagShowCnt:uint = 2;
	static public const PlanetItemFlagNoMove:uint = 4;
	static public const PlanetItemFlagToPortal:uint = 8;
	static public const PlanetItemFlagImport:uint = 16;
	static public const PlanetItemFlagExport:uint = 32;

	public function PlanetItem()
	{
	}
	
	public function Clear():void
	{
		m_Type = 0;
		m_Cnt = 0;
		m_Complete = 0;
		m_Broken = 0;
		m_Flag = 0;
	}

	public function Copy(src:PlanetItem):void
	{
		m_Type = src.m_Type;
		m_Cnt = src.m_Cnt;
		m_Complete = src.m_Complete;
		m_Broken = src.m_Broken;
		m_Flag = src.m_Flag;
	}
	
	public function Swap(pi:PlanetItem):void
	{
		var dw:uint;
		var it:int;
		dw = m_Type; m_Type = pi.m_Type; pi.m_Type = dw;
		it = m_Cnt; m_Cnt = pi.m_Cnt; pi.m_Cnt = it;
		it = m_Complete; m_Complete = pi.m_Complete; pi.m_Complete = it;
		it = m_Broken; m_Broken = pi.m_Broken; pi.m_Broken = it;
		dw = m_Flag; m_Flag = pi.m_Flag; pi.m_Flag = dw;
	}
}

}
