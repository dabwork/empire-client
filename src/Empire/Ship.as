// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
	public class Ship
	{
		public var m_Id:uint;
		public var m_Owner:uint;
//		public var m_FleetCptId:uint;
		public var m_ArrivalTime:Number;
		public var m_FromSectorX:int;
		public var m_FromSectorY:int;
		public var m_FromPlanet:int;
		public var m_FromPlace:int;
		public var m_Type:int;
		public var m_Race:uint;
		public var m_Cnt:int;
		public var m_CntDestroy:int;
		public var m_HP:int;
		public var m_Shield:int;
//		public var m_DestroyTime:Number;
		public var m_CargoType:uint;
		public var m_CargoCnt:int;
		public var m_BattleTimeLock:Number;
		public var m_Fuel:int;
		public var m_Flag:uint;
		public var m_Path:uint;
		public var m_Group:uint;
		public var m_Link:uint;

		public var m_ItemType:int;
		public var m_ItemCnt:int;

		public var m_OrbitItemType:int;
		public var m_OrbitItemCnt:int;
		public var m_OrbitItemOwner:uint;
		public var m_OrbitItemTimer:Number; 

		public var m_InvuFromId:uint = 0;
        public var m_AbilityCooldown0:Number = 0;
		public var m_AbilityCooldown1:Number = 0;
		public var m_AbilityCooldown2:Number = 0;
		public var m_AbilityCooldown3:Number = 0;

		public function Ship()
		{
			m_Type=Common.ShipTypeNone;
			//m_DestroyTime=0;
			m_ItemType=Common.ItemTypeNone;
			m_OrbitItemType=Common.ItemTypeNone;
		}

		public function Clear():void
		{
			m_Id=0;
			m_Owner=0;
//			m_FleetCptId=0;
			m_ArrivalTime=0;
			m_FromSectorX=0;
			m_FromSectorY=0;
			m_FromPlanet=0;
			m_FromPlace=0;
			m_Type=Common.ShipTypeNone;
			m_Race=Common.RaceNone;
			m_Cnt=0;
			m_CntDestroy=0;
			m_HP=0;
			m_Shield = 0;
			m_CargoType = 0;
			m_CargoCnt=0;
			m_BattleTimeLock=0;
			m_Fuel=0;
			m_Flag=0;
			m_Path=0;
			m_Group=0;
			m_ItemType=Common.ItemTypeNone;
			m_ItemCnt = 0;
			m_Link = 0;
			
			m_InvuFromId = 0;
			m_AbilityCooldown0 = 0;
			m_AbilityCooldown1 = 0;
			m_AbilityCooldown2 = 0;
			m_AbilityCooldown3 = 0;

/*			if(!dropitem) {
				m_ItemType=Common.ItemTypeNone;
				m_ItemCnt=0;
				m_ItemTimer=0;
			}*/
		}

		public function Copy(src:Ship):void
		{
			m_Id=src.m_Id;
			m_Owner=src.m_Owner;
//			m_FleetCptId=src.m_FleetCptId;
			m_ArrivalTime=src.m_ArrivalTime;
			m_FromSectorX=src.m_FromSectorX;
			m_FromSectorY=src.m_FromSectorY;
			m_FromPlanet=src.m_FromPlanet;
			m_FromPlace=src.m_FromPlace;
			m_Type=src.m_Type;
			m_Race=src.m_Race;
			m_Cnt=src.m_Cnt;
			m_CntDestroy=src.m_CntDestroy;
			m_HP=src.m_HP;
			m_Shield = src.m_Shield;
			m_CargoType=src.m_CargoType;
			m_CargoCnt=src.m_CargoCnt;
			m_BattleTimeLock=src.m_BattleTimeLock;
			m_Fuel=src.m_Fuel;
			m_Flag=src.m_Flag;
			m_Path=0;
			m_Group=src.m_Group;

//			var itype:int=m_ItemType;
//			var icnt:int=m_ItemCnt;
//			var itimer:Number=m_ItemTimer;

			m_ItemType=src.m_ItemType;
			m_ItemCnt=src.m_ItemCnt;
//			m_ItemTimer=src.m_ItemTimer;

			m_InvuFromId = src.m_InvuFromId;
			m_AbilityCooldown0 = src.m_AbilityCooldown0;
			m_AbilityCooldown1 = src.m_AbilityCooldown1;
			m_AbilityCooldown2 = src.m_AbilityCooldown2;
			m_AbilityCooldown3 = src.m_AbilityCooldown3;

			if (m_Race == Common.RacePeople && m_Type != Common.ShipTypeFlagship && !Common.IsBase(m_Type)) m_Shield = 0;
			
			m_Link = 0;


	/*		if(!takeitem) return;
			if(itype==Common.ItemTypeNone) return;
			
			if(itype==Common.ItemTypeAntimatter || itype==Common.ItemTypeElectronics || itype==Common.ItemTypeMetal || itype==Common.ItemTypeProtoplasm || itype==Common.ItemTypeNodes) {
				
			} 
			else if(itype==Common.ItemTypeModule) {
				m_CargoCnt+=icnt;

			} else if(itype==Common.ItemTypeFuel) {
				var fm:int=EmpireMap.Self.FuelMax(m_Owner,m_Type);
        		if(icnt+m_Fuel>=fm) m_Fuel=fm;
		        else m_Fuel+=icnt;

		    } else if(itype==Common.ItemTypeDouble) {
		        m_Cnt+=Math.min(m_Cnt,icnt);
		        var smc:int=EmpireMap.Self.ShipMaxCnt(m_Owner,m_Type);
		        if(m_Cnt>smc) m_Cnt=smc;
		        
		    } else if(m_ItemType==itype) {
		    	m_ItemCnt+=icnt;

			} else {
		        m_ItemType=itype;
		        m_ItemCnt=icnt;
		        m_ItemTimer=0;
			}*/
		}
		
		public function TakeItem():void
		{
			if (!m_OrbitItemType) return;
			
			var idesc:Item = UserList.Self.GetItem(m_OrbitItemType);
			if (!idesc) return;
			
			if (idesc.IsEq()) {
				if (m_CargoType) return;
				m_CargoType = m_OrbitItemType;
				m_CargoCnt = m_OrbitItemCnt;
				
			} else if(m_OrbitItemType==Common.ItemTypeAntimatter || m_OrbitItemType==Common.ItemTypeElectronics || m_OrbitItemType==Common.ItemTypeMetal || m_OrbitItemType==Common.ItemTypeProtoplasm || m_OrbitItemType==Common.ItemTypeNodes) {
			}
			else if(m_OrbitItemType==Common.ItemTypeModule) {
				m_CargoCnt+=m_OrbitItemCnt;

			} else if(m_OrbitItemType==Common.ItemTypeFuel) {
				var fm:int=EmpireMap.Self.FuelMax(m_Owner,m_Id,m_Type);
        		if(m_OrbitItemCnt+m_Fuel>=fm) m_Fuel=fm;
		        else m_Fuel+=m_OrbitItemCnt;

		    } else if(m_OrbitItemType==Common.ItemTypeDouble) {
		    	if(m_Type==Common.ShipTypeFlagship) return;
		        m_Cnt+=Math.min(m_Cnt,m_OrbitItemCnt);
		        var smc:int=EmpireMap.Self.ShipMaxCnt(m_Owner,m_Type);
		        if(m_Cnt>smc) m_Cnt=smc;

    		} else if(m_OrbitItemType==Common.ItemTypeMine) {
        		return;

			} else if(m_OrbitItemType==m_ItemType) {
        		var cnt:int=m_OrbitItemCnt;
        		if(m_ItemCnt+cnt>Common.ItemMaxCnt) cnt=Common.ItemMaxCnt-m_ItemCnt;
        		if(cnt<=0) return;

        		m_OrbitItemCnt-=cnt;
        		m_ItemCnt+=cnt;

        		if(m_OrbitItemCnt>0) {
		            return;
		        }

    		} else if(m_ItemType==Common.ItemTypeNone) {
		    	m_ItemType=m_OrbitItemType;
		    	m_ItemCnt=m_OrbitItemCnt;

    		} else {
        		return;
    		}

	        m_OrbitItemType=Common.ItemTypeNone;
			m_OrbitItemCnt=0;
			m_OrbitItemOwner=0;
			m_OrbitItemTimer=0;
		}
	}
}
