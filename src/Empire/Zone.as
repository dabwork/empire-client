// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
	public class Zone
	{
		public var m_ZoneX:int;
		public var m_ZoneY:int;

		//public var m_VersionStatic:uint=0;
		//public var m_VersionDynamic:uint=0;
		
		//public var m_UpdateTime:Number=0;
		
		//public var m_CotlList:Array=new Array();
		//public var m_FleetList:Array=new Array();
		
		public var m_Lvl:int=0;
		
		public var m_GetTime:Number = 0;
		
		public function Zone(x:int, y:int)
		{
			m_ZoneX=x;
			m_ZoneY=y;
		}
	}
}
