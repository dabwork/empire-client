// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
	public class Sector
	{
		public var m_SectorX:int;
		public var m_SectorY:int;

		public var m_Version:uint;
		public var m_VersionSlow:uint;
		public var m_Planet:Array;

//		public var m_WormholeNextDate:Number;
//		public var m_WormholeTgtSectorX:int;
//        public var m_WormholeTgtSectorY:int;

		//public var m_LoadAfterVersion:uint;
		
		public var m_LoadAfterActionNo:int=0;
		public var m_LoadAfterActionNo_Time:Number=0;

		public var m_UpdateTime:Number=0;

		public var m_Off:Boolean = false;
		public var m_NeedLoad:Boolean = false;

		public var m_Infl:uint=0;

		public function Sector(x:int, y:int)
		{
			m_SectorX=x;
			m_SectorY=y;

			//m_LoadAfterVersion=0;
			m_Planet=new Array();
		}
	}
}
