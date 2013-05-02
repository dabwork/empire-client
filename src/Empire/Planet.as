// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
	import flash.display.Shape;

	public class Planet
	{
		public var m_Sector:Sector = null;
		public var m_PlanetNum:int;

		public var m_Flag:uint;
		public var m_PosX:int;
		public var m_PosY:int;
		public var m_Owner:uint;
		public var m_Race:uint;
		public var m_Level:int;
		public var m_LevelBuy:int=0;
		//public var m_HP:int;
//		public var m_ConstructionPoint:int=0;
		public var m_OreItem:uint;
		public var m_Path:uint;
		public var m_ShieldVal:uint;
		public var m_ShieldEnd:Number;
		public var m_Radiation:int = 0;
		public var m_Island:int=0;
		public var m_PortalPlanet:int = 0;
		public var m_PortalSectorX:int = 0;
		public var m_PortalSectorY:int = 0;
		public var m_PortalCnt:int = 0;
		public var m_PortalOwner:uint = 0;
		public var m_PortalCotlId:uint = 0;
		public var m_NeutralCooldown:Number = 0;
		public var m_Route0:uint = 0;
		public var m_Route1:uint = 0;
		public var m_Route2:uint = 0;
		public var m_Team:int = 0;
		public var m_ATT:uint = 0;

		public var m_GravWellCooldown:Number = 0;
		public var m_PotentialCooldown:Number = 0;

		public var m_AISpace:int = 0;
		public var m_AIProtect:int = 0;
		public var m_AIFromCenter:int = 0;
		public var m_AINeedTransport:uint = 0;
		public var m_AINeedInvader:uint = 0;
		public var m_AINeedCorvette:uint = 0;
		public var m_AINeedCruiser:uint = 0;
		public var m_AINeedDreadnought:uint = 0;
		public var m_AINeedDevastator:uint = 0;

		public var m_GravitorTime:Number = 0;
		public var m_GravitorOwner:uint = 0;
		
//		public var m_AutoBuildType:int=0;
//		public var m_AutoBuildCnt:int=0;
//		public var m_AutoBuildTime:int=0;
//		public var m_AutoBuildWait:int=0;
		public var m_Refuel:int=0;

		public var m_LandingPlace:int=0;

		public var m_FindScore:Number=0;
		public var m_FindPrev:Planet = null;

		public var m_Engineer:uint = 0;
		public var m_Machinery:uint = 0;

		public var m_EngineerNeed:int = 0;
		public var m_MachineryNeed:int = 0;

		public var m_SupplyUse:int = 0;

		public var m_Manuf:uint = 0;

		public var m_EPS_Val:int = 0;
		public var m_EPS_AtkPower:int = 0;
		public var m_EPS_TimeOff:uint = 0;
		
		public var m_VisTime:Number = 0;
		public var m_FindMask:uint = 0;
		
		public var m_Vis:Boolean = false;

		static public const PlanetCellCnt:int = 12;
		static public const PlanetItemCnt:int = 16;

		public var m_Cell:Vector.<uint> = new Vector.<uint>(PlanetCellCnt,true);
		public var m_CellBuildFlag:uint = 0;
		public var m_CellBuildEnd:Number = 0;

		public var m_Item:Vector.<PlanetItem> = new Vector.<PlanetItem>(PlanetItemCnt, true);

		public var m_BtlEvent:Vector.<BtlEvent> = new Vector.<BtlEvent>();

		static public const PlanetFlagHomeworld:uint=1;
		static public const PlanetFlagLarge:uint=2;
        static public const PlanetFlagWormhole:uint=4;
        static public const PlanetFlagWormholePrepare:uint=8;
        static public const PlanetFlagWormholeOpen:uint=16;
        static public const PlanetFlagWormholeClose:uint=32;
        static public const PlanetFlagStabilizer:uint=128;
        static public const PlanetFlagCitadel:uint=256;
		static public const PlanetFlagGlobalShield:uint=512;
		static public const PlanetFlagBuildSDM:uint=1024;              
		static public const PlanetFlagSun:uint=2048;
		static public const PlanetFlagGigant:uint=4096;
		static public const PlanetFlagRich:uint=8192;
		static public const PlanetFlagGravitor:uint=1<<14;
		static public const PlanetFlagGravitorSci:uint=1<<15;
		static public const PlanetFlagGravitorSciPrepare:uint=1<<16;
		static public const PlanetFlagArrivalDef:uint=1<<17;
		static public const PlanetFlagArrivalAtk:uint=1<<18;
		//static public const PlanetFlagCapture:uint = 1 << 19;
		static public const PlanetFlagNoCapture:uint = 1 << 19;
		static public const PlanetFlagPortalFlagship:uint = 1 << 20;
		static public const PlanetFlagAutoBuild:uint = 1 << 21;
		static public const PlanetFlagGravWell:uint = 1 << 23;
		static public const PlanetFlagEnclave:uint = 1 << 24;
		static public const PlanetFlagLowRadiation:uint = 1 << 25;
		static public const PlanetFlagLocalShield:uint = 1 << 26;
		static public const PlanetFlagPotential:uint = 1 << 27;
		static public const PlanetFlagDestroyed:uint = 1 << 28;
		static public const PlanetFlagNoMove:uint = 1 << 29;

		static public const PlanetAtmNone:uint = 0;
		static public const PlanetAtmHydrogen:uint = 1;
		static public const PlanetAtmAcid:uint = 2;
		static public const PlanetAtmOxigen:uint = 3;
		static public const PlanetAtmNitric:uint = 4;

		static public const PlanetTmpCold:uint = 0;
		static public const PlanetTmpCalid:uint = 1;
		static public const PlanetTmpHot:uint = 2;
		
		static public const PlanetTecPassive:uint = 0;
		static public const PlanetTecDynamic:uint = 1;
		static public const PlanetTecSeismic:uint = 2;

		//public var m_Ship:Array;
		public var m_Ship:Vector.<Ship> = new Vector.<Ship>(Common.ShipOnPlanetMax,true);

		public function Planet(sec:Sector, planetnum:int)
		{
			var i:int;
			
			m_Sector=sec;
			m_PlanetNum=planetnum;

			//m_Ship=new Array(Common.ShipOnPlanetMax);
			for(i=0;i<Common.ShipOnPlanetMax;i++) {
				m_Ship[i]=new Ship();
			}
			
			for (i = 0; i < PlanetItemCnt; i++) {
				m_Item[i] = new PlanetItem();
			}
			
//			m_ConstructionPoint=0;
			m_Path=0;			
		}
		
		public function BuildingSpeed():int
		{
			if(m_Flag & PlanetFlagLarge) return 4;
			else return 2;
		}
		
		public function IsExist():Boolean
		{
			var i:int;
			var ship:Ship;

			if(m_Sector==null) return false;
			if(m_PlanetNum>=m_Sector.m_Planet.length) return false;

			if(!(m_Flag & PlanetFlagWormhole)) return true;

			if(m_Flag & (PlanetFlagWormholePrepare | PlanetFlagWormholeOpen | PlanetFlagWormholeClose)) return true;

			for(i=0;i<Common.ShipOnPlanetMax;i++) {
				ship=m_Ship[i];
				if(ship.m_Type!=Common.ShipTypeNone) return true;
				if(ship.m_ItemType!=Common.ItemTypeNone) return true;
			}
			
			for (i = 0; i < m_BtlEvent.length; i++) {
				var e:BtlEvent = m_BtlEvent[i];
				if (e.m_Type != BtlEvent.TypeExplosion) continue;
				if (e.m_Slot == 100) return true;
			}

			return false;
		}
		
		public function ConstructionLvl(bt:uint, withbild:Boolean=true):int
		{
			var i:int;
			var lvl:int=0;
			for(i=0;i<PlanetCellCnt;i++) {
				var v:uint=m_Cell[i];
				if((v>>3)!=bt) continue;

				lvl+=v&7;
				if (withbild && (m_CellBuildFlag & (1 << i))) lvl--;
			}
			return lvl;
		}

		public function ExistBuilding(bt:uint):Boolean
		{
			var i:int;
			var lvl:int=0;
			for(i=0;i<PlanetCellCnt;i++) {
				var v:uint=m_Cell[i];
				if((v>>3)!=bt) continue;

				return true;
			}
			return false;
		}
		
		public function PlanetItemMax(withbild:Boolean=true):int
		{
			var i:int;
			
			var picnt:int = 0;
			for (i = 0; i < m_Ship.length; i++) {
				if (m_Ship[i].m_Type == Common.ShipTypeServiceBase && (!withbild || (m_Ship[i].m_Flag & Common.ShipFlagBuild)==0)) picnt += m_Ship[i].m_Cnt;
			}
			if (picnt > 4) picnt = 4;
			
			if (m_Owner != 0 || EmpireMap.Self.IsEdit()) {
				picnt++;
				picnt += ConstructionLvl(Common.BuildingTypeStorage,withbild);
			}
			
			if (picnt < 0) return 0;
			//else if (picnt >= Planet.PlanetItemCnt) return Planet.PlanetItemCnt;
			return picnt;
		}
		
		public function PlanetCalcEnergy():int
		{
			var e:int = 0;
			var i:int;

			for(i=0;i<PlanetCellCnt;i++) {
				var v:uint = m_Cell[i];

				var bt:int = v >> 3;
				if (bt == 0) continue;
				var lvl:int = v & 7;

				e += Common.BuildingEnergy[bt * Common.BuildingLvlCnt + lvl - 1];
			}
			return e;
		}

		public function PlanetCellType(icell:int):int // 0=out 1=normal -1=ore
		{
			if (m_Flag & (PlanetFlagSun | PlanetFlagWormhole | PlanetFlagGigant)) return 0;

			if ((m_Flag & PlanetFlagLarge) != 0) {
				if (icell<0 || icell>=PlanetCellCnt) return 0;
				if (icell == 4 || icell == 7) return -1;
			} else {
				if (icell<0 || icell>7) return 0;
				if (icell == 3) return -1;
			}

			return 1;
		}

		public function PlanetNeedSupplyLvl():int
		{
			var ret:int = 0;
			var i:int, u:int;

			for(i=0;i<PlanetCellCnt;i++) {
				var v:uint = m_Cell[i];

				var bt:int = v >> 3;
				if (bt == 0) continue;
				var lvl:int = v & 7;
				if ((m_CellBuildFlag & (1 << i)) != 0) lvl--;
				if (lvl < 1) continue;

				for (u = 0; u < Common.BuildingItem.length; u++) {
					if (Common.BuildingItem[u].BuildingType != bt) continue;
					if (Common.BuildingItem[u].ItemType == 0) continue;

					ret += lvl;
					break;
				}
			}
			
			return ret;
		}
		
		public function PlanetNeedSupplyMax():int
		{
			var ret:int = PlanetNeedSupplyLvl();
			if (ret <= 0) return 0;

			ret = (ret * (45 + ret)) >> 4;
			if (ret > 212) ret = 212;
			return ret;
		}
		
		public function PlanetDefectFactor():int
		{
			var b:int;
			var ret:int=0;

			var lvl:int = PlanetNeedSupplyLvl();
			if (lvl <= 0) return 0;
			var sm:int = PlanetNeedSupplyMax();
			if (sm <= 0) return 0;

			var a:int = 90 - (lvl << 1);
			if (a < 0) a = 0;

			if (m_Engineer < sm) {
				b = a + Math.floor(((100 - a) * m_Engineer) / sm);
				if (b > 100) b = 100;
				ret = Math.max(ret, 100 - b);
			}

			if (m_Machinery < sm) {
				b = a + Math.floor(((100 - a) * m_Machinery) / sm);
				if (b > 100) b = 100;
				ret = Math.max(ret, 100 - b);
			}

			return ret;
		}
		
		public function PlanetLevelMax():int
		{
			var i:int, lvl:int;

			var ret:int = 0;
			if (m_Owner /*&& (m_Owner & Common.OwnerAI) == 0*/) {
				ret = 10;
				
				for(i=0;i<PlanetCellCnt;i++) {
					var v:uint=m_Cell[i];
					if(v==0) continue;

					lvl=v&7;
					if (m_CellBuildFlag & (1 << i)) lvl--;
					if (lvl <= 0) continue;
					ret += 19 * lvl;
				}
			}
			return ret;
		}

		public function PlanetItemRemoveByBuilding(bt:uint):void
		{
			var i:int, p:int, u:int;
			var pi:PlanetItem;
			var ship:Ship;

			var ok:Boolean = false;
			for (i = 0; i < PlanetItemCnt; i++) {
				pi = m_Item[i];
				if (pi.m_Type == 0) continue;
				if (pi.m_Complete != 0) continue;
				if (pi.m_Broken != 0) continue;
				if (pi.m_Cnt != 0) continue;
				if ((pi.m_Flag & PlanetItem.PlanetItemFlagBuild) == 0) continue;
				
				if ((m_Flag & (PlanetFlagGigant | PlanetFlagLarge)) == (PlanetFlagGigant | PlanetFlagLarge) && pi.m_Type == Common.ItemTypeHydrogen) {
					for (u = 0; u < Common.ShipOnPlanetMax; u++) {
						ship = m_Ship[u];
						if (ship.m_Type != Common.ShipTypeServiceBase) continue;
						break;
					}
					if (u < Common.ShipOnPlanetMax) continue;
				} else {
					for (u = 0; u < Common.BuildingItem.length; u++) {
						var obj:Object = Common.BuildingItem[u];
						if (obj.Build == 0) continue;
						if (obj.BuildingType != bt) continue;
						if (obj.ItemType != pi.m_Type) continue;
						if (ConstructionLvl(bt, false) <= 0) continue;
						break;
					}
					if (u < Common.BuildingItem.length) continue;
				}
				
				pi.Clear();
				ok = true;
			}
			if(ok) PlanetItemOptimizeLand();
		}
		
		public function PlanetItemBuildByBuilding(bt:uint):void
		{
			var i:int, p:int;
			var pi:PlanetItem;

			var it:uint = 0;

			if ((m_Flag & (PlanetFlagGigant | PlanetFlagLarge)) == (PlanetFlagGigant | PlanetFlagLarge)) {
				it = Common.ItemTypeHydrogen;
			} else {
				for (i = 0; i < Common.BuildingItem.length; i++) {
					var obj:Object = Common.BuildingItem[i];
					if (obj.Build == 0) continue;
					if (obj.BuildingType != bt) continue;
					if (obj.ItemType == 0) continue;
					it = obj.ItemType;
					break;
				}
			}
			if (it == 0) return;
			if (it == Common.ItemTypeTechnician || it == Common.ItemTypeNavigator) return;

			var storage:int = PlanetItemMax(it != Common.ItemTypeHydrogen);

			PlanetItemOptimizeLand(storage);

			// Ищем уже назначенное производство
			for(i=0;i<PlanetItemCnt;i++) {
				pi = m_Item[i];
				if (pi.m_Type == it && (pi.m_Flag & PlanetItem.PlanetItemFlagBuild) != 0) break;
			}
			if (i < storage) return; // Нашли и итем внутри слкадов
			if (i >= storage && i < PlanetItemCnt) {
				// Нашли но за приделами. Перемещаем во внутрь склада.
				p = PlanetItemAllocEmptyPlaceInStorage(storage);

				for(i=0;i<PlanetItemCnt;i++) { // Заного ищем так как PlanetItemAllocEmptyPlaceInStorage может изменить слоты итемов.
					pi = m_Item[i];
					if (pi.m_Type == it && (pi.m_Flag & PlanetItem.PlanetItemFlagBuild) != 0) break;
				}
				if (i >= PlanetItemCnt) return;

				if (p >= 0) m_Item[p].Swap(m_Item[i]);
				PlanetItemOptimizeLand(storage);
				return;
			}

			// Ищем итем с неназначеным производством
			for (i = 0; i < PlanetItemCnt; i++) {
				pi = m_Item[i];
				if (pi.m_Type == it && (pi.m_Flag & PlanetItem.PlanetItemFlagBuild) == 0) break;
			}
			if(i<storage) {
				 // Нашли и итем внутри слкадов
				m_Item[i].m_Flag |= PlanetItem.PlanetItemFlagBuild | PlanetItem.PlanetItemFlagShowCnt;
				return;
			}
			if(i>=storage && i<PlanetItemCnt) {
				// Нашли но за приделами. Перемещаем во внутрь склада.
				p = PlanetItemAllocEmptyPlaceInStorage(storage);

				for(i=0;i<PlanetItemCnt;i++) { // Заного ищем так как PlanetItemAllocEmptyPlaceInStorage может изменить слоты итемов.
					pi = m_Item[i];
					if (pi.m_Type == it && (pi.m_Flag & PlanetItem.PlanetItemFlagBuild) == 0) break;
				}
				if (i >= PlanetItemCnt) return;

				if (p >= 0) m_Item[p].Swap(m_Item[i]);
				PlanetItemOptimizeLand(storage);
				return;
			}
			
			// Не нашли. Назначем в пустое место.
			p=PlanetItemAllocEmptyPlaceInStorage(storage);
			if(p<0) return;

			pi=m_Item[p];
			pi.m_Type=it;
			pi.m_Cnt=0;
			pi.m_Complete=0;
			pi.m_Broken=0;
			pi.m_Flag = PlanetItem.PlanetItemFlagBuild | PlanetItem.PlanetItemFlagShowCnt;

			PlanetItemOptimizeLand(storage);
		}
		
		public function PlanetItemOptimizeLand(storage:int=-1):void
		{
			var i:int, u:int;

			if (storage < 0) storage = PlanetItemMax();
			if (storage < 0) return;
			if (storage >= PlanetItemCnt) return;

			// Удаляем пустые земленные слоты
			i=storage;
			while(i<PlanetItemCnt) {
				if(m_Item[i].m_Type) { i++; continue; }

				var cntdel:int=1;
				while ((i + cntdel) < PlanetItemCnt) { if (m_Item[i + cntdel].m_Type) break; cntdel++; }
				if (cntdel >= (PlanetItemCnt - i)) break;

				var cntcopy:int = 0;
				while ((i + cntdel + cntcopy) < PlanetItemCnt) { if (!m_Item[i + cntdel].m_Type) break; cntcopy++; }
				if (cntcopy <= 0) break;

				for (u = 0; u < cntcopy; u++) m_Item[i + u].Copy(m_Item[i + cntdel + u]);
				for (u = 0; u < cntdel; u++) m_Item[i + cntcopy + u].Clear();

				i += cntcopy;
			}
		}

		public function PlanetItemAllocEmptyPlaceInStorage(storage:int):int
		{
			var i:int;
			var pi:PlanetItem;

			//var storage:int=PlanetItemMax();
			if(storage<=0) return -1;

			for (i = 0; i < storage; i++) {
				pi=m_Item[i];
				if (!pi.m_Type) return i;
			}

			for(i=0;i<PlanetItemCnt;i++) {
				pi=m_Item[i];
				if(!pi.m_Type) break;
			}
			if(i>=PlanetItemCnt) return -1;
			var cntcopy:int = i;

			for (i = cntcopy - 1; i >= 0; i--) m_Item[1 + i].Copy(m_Item[0 + i]);
			m_Item[0].Clear();
			return 0;
		}
		
		public function get ShipOnPlanetLow():int
		{
			return (m_Flag & PlanetFlagWormhole)?16:15;
		}
	}
}
