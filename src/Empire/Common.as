// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import flash.display3D.textures.Texture;

import flash.display.*;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

// В текстах учесть
// Из гиперпространства выходим
// В гиперпространство входим

public class Common
{
	static public const OwnerAI:uint = 0x80000000;
	static public const OwnerAI0:uint = 0x80000000;// OwnerAI | 0;
	static public const OwnerAI1:uint = 0x80000001;// OwnerAI | 1;
	static public const OwnerAI2:uint = 0x80000002;// OwnerAI | 2;
	static public const OwnerAI3:uint = 0x80000003;// OwnerAI | 3;

	static public const TrainingCotlId:uint = 45;

	static public const CitadelMax:int = 5;
	static public const ShipOnPlanetLowSys:int = 15;
	static public const ShipOnPlanetMax:int = ShipOnPlanetLowSys + 4;
	static public const RouteMax:int=3;
	static public const ShipMaxCnt:int=999;
	static public const GroupInPlanetMax:int=6;
	static public const BattleGroupInPlanetMax:int=5;
	static public const FleetSlotMax:int = 7;
	static public const FleetItemCnt:int = 64;
//	static public const SlotOnCotlMax:int=128;
	static public const FleetModuleMax:int = 30000000;
	static public const StorageMul:int = 100;

//	static public const FleetSpeed:Number=0.1;

	static public const GaalBarrierMax:int = 400000;

	static public const PlanetRichMul:int = 2;
	static public const MulFactor:int = 10;
	static public const RelocateCost:int = 15000;
	static public const BuyNameCost:int = 30000;
	static public const CotlDevCost:int = 1000;

//	static public const FleetActionDefault:int = 0;
//	static public const FleetActionMove:int = 1;
//	static public const FleetActionJump:int = 2;
//	static public const FleetActionFollow:int = 3;
//	static public const FleetActionAttack:int = 4;
//	static public const FleetActionCombat:int = 5;
//	static public const FleetActionStealth:int = 6;

	static public const FleetActionInOpenSpace:int = 10;
	static public const FleetActionInOrbitCotl:int = 11;
	static public const FleetActionInCombat:int = 12;

	static public const CotlTypeUser:int=1;
	static public const CotlTypeRich:int=2;
	static public const CotlTypeProtect:int = 3;  
	static public const CotlTypeCombat:int = 4;

	static public const CotlOrbitRadius:int=100;

	static public const ShipSpeedPerSecond:int=35;
	static public const ResearchBonusPlusar:int=3;

	static public const DefaultJumpRadius:int = 600;
	static public const PlanetMinDist:int = 240;

	static public const NewEmpireCooldown:int = 15 * 60;
	static public const NewBaseCooldown:int = 30 * 60;

	static public const HomeworldModuleInc:int = 150;
	static public const BaseModuleInc:int = 10;

//	static public const ThreatSun:int=1000;
//	static public const ThreatGigant:int=500;
//	static public const ThreatTini:int=100;

	static public const TradeNalog:int=1;

	static public const OccupancyCritical:int=70;
	static public const OccupancyRichCritical:int=98;

	static public const RichFactor:int = 10;

	static public const EPS_ValMax:int = 300000000;
	static public const EPS_AtkMax:int = Math.floor(EPS_ValMax / (60 * 15)); //60 * 60 * 2

	static public const MinePower:int=200;

	static public const MaxArmour:int = 204;
//	static public const MaxAccuracy:int = 1280;
//	static public const MaxMinePower:int = 1000;
//	static public const MaxRepairAll:int = 1000;
//	static public const MinSupply:int = 26;

	//static public const RG_CotlRadius:Number=100.0;
	static public const RG_SectorSize:Number=500;
	static public const RG_SectorMulY:Number=10000;

	static public const OpsFlagEnterShip:uint=1<<0;
	static public const OpsFlagEnterFlagship:uint=1<<1;
	static public const OpsFlagLeaveShip:uint=1<<2;
	static public const OpsFlagLeaveFlagship:uint=1<<3;
	static public const OpsFlagBuildShip:uint=1<<4;
	static public const OpsFlagBuildFlagship:uint=1<<5;
	static public const OpsFlagBuildWarBase:uint=1<<6;
	static public const OpsFlagBuildSciBase:uint=1<<7;
	static public const OpsFlagBuildShipyard:uint = 1 << 8;
	static public const OpsFlagBuildServiceBase:uint = 1 << 9;
	static public const OpsFlagBuildMask:uint=OpsFlagBuildShip|OpsFlagBuildFlagship|OpsFlagBuildWarBase|OpsFlagBuildSciBase|OpsFlagBuildShipyard|OpsFlagBuildServiceBase;
	static public const OpsFlagItemToHyperspace:uint=1<<10;
	static public const OpsFlagPulsarEnterActive:uint=1<<11;
	static public const OpsFlagNeutralBuild:uint=1<<12;
	static public const OpsFlagEnterSingleInvader:uint = 1 << 13;

	static public const OpsFlagWin1:uint = 1 << 14;
	static public const OpsFlagWin2:uint = 1 << 15;
	static public const OpsFlagWin3:uint = 1 << 16;
	static public const OpsFlagWinOccupyHomeworld:uint = OpsFlagWin1;
	static public const OpsFlagWinMaxPlanet:uint = OpsFlagWin2;
	static public const OpsFlagWinScore:uint = OpsFlagWin1 | OpsFlagWin2;
	static public const OpsFlagWinCtrlCitadel:uint = OpsFlagWin3;
	static public const OpsFlagWinMaxEnclave:uint = OpsFlagWin3 | OpsFlagWin1;
	static public const OpsFlagWinMask:uint = OpsFlagWin1 | OpsFlagWin2 | OpsFlagWin3;

	static public const OpsFlagRelGlobalOff:uint = 1 << 17;
	static public const OpsFlagKlingBuild:uint = 1 << 18;
	static public const OpsFlagWormholeLong:uint = 1 << 19;
	static public const OpsFlagWormholeFast:uint = 1 << 20;
	static public const OpsFlagWormholeRoam:uint = 1 << 21;
	static public const OpsFlagEnterTransport:uint = 1 << 22;
	static public const OpsFlagLeaveTransport:uint = 1 << 23;
	static public const OpsFlagEnclave:uint = 1 << 24;
	static public const OpsFlagPlanetShield:uint = 1 << 25;
	static public const OpsFlagPlayerExp:uint = 1 << 26;
	static public const OpsFlagBuilding:uint = 1 << 27;

	static public const OpsFlagViewAll:uint = 1 << 28;

	static public const OpsFlagAll:Object = (1 << 29) - 1;

	static public const OpsPriceTypeAntimatter:int = 1;
	static public const OpsPriceTypeMetal:int = 2;
	static public const OpsPriceTypeElectronics:int = 3;
	static public const OpsPriceTypeProtoplasm:int = 4;
	static public const OpsPriceTypeNodes:int = 5;
	static public const OpsPriceTypeFuel:int = 6;
	static public const OpsPriceTypeModule:int = 7;
	static public const OpsPriceTypeEGM:int = 8;
	static public const OpsPriceTypeCr:int = 9;
	static public const OpsPriceTypeCnt:int = 10;

	static public const HoldSlotTypeNone:int=0;
	static public const HoldSlotTypeBlue:int=1;
	static public const HoldSlotTypeGreen:int=2;
	static public const HoldSlotTypeRed:int=3;
	static public const HoldSlotTypeYellow:int=4;

	static public const CptHoldSlotMax:int=16;
	static public const CptHoldSlotType:Array=[
		HoldSlotTypeBlue,HoldSlotTypeBlue,HoldSlotTypeBlue,HoldSlotTypeBlue,
		HoldSlotTypeBlue,HoldSlotTypeBlue,HoldSlotTypeBlue,HoldSlotTypeBlue,
		HoldSlotTypeGreen,HoldSlotTypeGreen,HoldSlotTypeGreen,HoldSlotTypeGreen,
		HoldSlotTypeRed,HoldSlotTypeRed,HoldSlotTypeRed,
		HoldSlotTypeYellow
	];

	static public const TeamMaxShift:int=3;
	static public const TeamRelDefault:int=0;
	static public const TeamRelWar:int=1;
	static public const TeamRelPeace:int=2;

	static public const GameStateWait:uint = 1;
	static public const GameStateFirstBattleAI:uint = 2;
	static public const GameStateEnd:uint = 4;
	static public const GameStatePlacing:uint = 16;
	static public const GameStateEnemy:uint = 32;
	static public const GameStateBegin:uint = 64;
	static public const GameStateTraining:uint = 128;
	static public const GameStateDevelopment:uint = 256;

	static public const CotlRestartPeriod:int = 1 * 60;

	static public const ShipPortalTime:Number = 10;
	static public const StationPortalTime:Number = 10;
    static public const FlagshipPortalTime:Number = 10;
    static public const DevastatorBombTime:Number = 3 * 60;
	static public const DevastatorBombTimeGrantar:Number = 2 * 60;

	static public const FuelCostEGM:int = 1;

	static public const QuarkBaseCostQuarkCore:int = 1000;

    static public const AccessPlusarModule:uint=1;
    static public const AccessPlusarCaptain:uint=2;
    static public const AccessPlusarTech:uint=4;
    static public const AccessPlusarShieldGlobal:uint=8;
    static public const AccessPlusarShieldLocal:uint=16;
    static public const AccessPact:uint=32;
    static public const AccessNewStoreSDM:uint=64;
    static public const AccessNewStoreTech:uint=128;
    static public const AccessNewStoreRes:uint=256;

	static public const UserFlagPlanetShieldOn:uint=1;
	static public const UserFlagAutoShieldEmpire:uint=2;
	static public const UserFlagAutoShieldEnclave:uint=4;
    static public const UserFlagAutoShieldColony:uint=8;
    static public const UserFlagAutoShieldMask:uint=UserFlagAutoShieldEmpire|UserFlagAutoShieldEnclave|UserFlagAutoShieldColony;
    static public const UserFlagTechNext:uint = 16;
	static public const UserFlagAutoProgress:uint = 32;
	static public const UserFlagAutoTransportNet:uint = 1 << 6;
	static public const UserFlagAutoTransport:uint = 1 << 7;
	static public const UserFlagAutoDefence:uint = 1 << 8;
	static public const UserFlagPlayerControl:uint = 1 << 9;
	static public const UserFlagVisAll:uint = 1 << 11; // Просмотр для всех
	static public const UserFlagImportIfEnemy:uint = 1 << 12; // Не импортировать если враг
	static public const UserFlagNewGame:uint = uint(1 << 31);// 0x80000000;// uint(1) << 31;
	static public const UserFlagTraining:uint = 1 << 30;
	static public const UserFlagAccountTmp:uint = 1 << 29;
	static public const UserFlagAccountFull:uint = 1 << 28;
	static public const UserFlagRankShift:uint = 16;
	static public const UserFlagRankMask:uint = 7 << UserFlagRankShift; // 0-новечек 1-кадет 2-пилот

	static public const UserRankNovice:uint = 0;
	static public const UserRankCadet:uint = 1; // 10000 развитие
	static public const UserRankPilot:uint = 2; // 100000 развитие
	static public const UserRankWingman:uint = 3; // 3x50-флагмана
	static public const UserRankLeader:uint = 4; // установить контроль над 10 созвездиями
	static public const UserRankAce:uint = 5; // захватить лички 2 игроков ранга не ниже Ace.
	static public const UserRankCommander:uint = 6; // захватить галактику

	static public const UserRankName:Array = ["Новичок", "Кадет", "Пилот", "Капитан", "Истребитель", "Ас", "Командор"];

	static public const RaceNone:uint=0;
	static public const RaceGrantar:uint=1;
	static public const RacePeleng:uint=2;
	static public const RacePeople:uint=3;
	static public const RaceTechnol:uint=4;
	static public const RaceGaal:uint=5;
	static public const RaceKling:uint=6;

	static public const RaceFaceCnt:Array=[0,5,5,9,4,4];
	static public const RaceSysName:Array=["None","Grantar","Peleng","People","Technol","Gaal","Klissans"];
	static public const RaceName:Array = ["None", "Грантары", "Пеленги", "Люди", "Технолы", "Гаальцы", "Клисаны"];

	//static public const TransportLogicLock:Number=10*1000;
	//static public const LogicLockAfterMove:Number=30*1000;
	//static public const LogicLockAfterBuild:Number=30*1000;
	static public const BattleLock:Number=4;
	static public const NeutralBuildTime:Number = 15;
	static public const EjectTime:int = 60;

	static public const ShipTypeNone:int=0;
	static public const ShipTypeTransport:int=1;
	static public const ShipTypeCorvette:int=2;
	static public const ShipTypeCruiser:int=3;
	static public const ShipTypeDreadnought:int=4;
	static public const ShipTypeInvader:int=5;
	static public const ShipTypeDevastator:int=6;
	static public const ShipTypeWarBase:int=7;
	static public const ShipTypeShipyard:int=8;
	static public const ShipTypeKling0:int=9;
	static public const ShipTypeKling1:int=10;
	static public const ShipTypeSciBase:int=11;
	static public const ShipTypeFlagship:int = 12;
	static public const ShipTypeServiceBase:int = 13;
	static public const ShipTypeQuarkBase:int = 14;
	static public const ShipTypeCnt:int = 15;

	public static function IsBase(t:int):Boolean { return (t == ShipTypeWarBase) || (t == ShipTypeShipyard) || (t == ShipTypeSciBase) || (t == ShipTypeServiceBase) || (t == ShipTypeQuarkBase); }
	//public static function IsLowOrbit(n:int):Boolean { return n >= ShipOnPlanetLow; }

//	static public const CptFlagGravitor:uint = 1 << 1;

	static public const oldShipFlagAutoReturn:uint=1;
    static public const oldShipFlagAutoLogic:uint=2;
    static public const ShipFlagBattle:uint=4;
    static public const ShipFlagBuild:uint=8;
    static public const ShipFlagStabilizer:uint=16;
    static public const ShipFlagCapture:uint=32;
    static public const ShipFlagBuildSDM:uint=64;
    static public const ShipFlagPortal:uint=128;
    static public const ShipFlagBomb:uint=256;
    static public const ShipFlagInvu:uint=512;
    static public const ShipFlagMine:uint=1024;
    static public const ShipFlagExchange:uint=2048;
    static public const ShipFlagNoToBattle:uint=4096;
	static public const ShipFlagAIRoute:uint = 1 << 13;
	static public const ShipFlagAIAttack:uint = 1 << 14;
	static public const ShipFlagPolar:uint = 1 << 16;
	static public const ShipFlagInvu2:uint = 1 << 18;
	static public const ShipFlagExtract:uint = 1 << 19;
	static public const ShipFlagTransiver:uint = 1 << 20;
	static public const ShipFlagPhantom:uint = 1 << 21;
	static public const ShipFlagSiege:uint = 1 << 22;
	static public const ShipFlagNanits:uint = 1 << 23;
	static public const ShipFlagEject:uint = 1 << 26;

	static public const FlagshipIdFlag:uint=0x80000000;

	static public const ItemTypeNone:int=0;		// complate
	static public const ItemTypeModule:int=1;	// complate
	static public const ItemTypeArmour:int=2;	// complate
	static public const ItemTypePower:int=3;	// complate
	static public const ItemTypeRepair:int=4;	// complate
	static public const ItemTypeJump:int=5;
	static public const ItemTypeBuild:int=6;
	static public const ItemTypeFuel:int=7;		// complate
	static public const ItemTypeDouble:int=8;	// complate
	static public const ItemTypeMonuk:int=9;
	static public const ItemTypeAntimatter:int=10;
	static public const ItemTypeMetal:int=12;
	static public const ItemTypeElectronics:int=13;
	static public const ItemTypeProtoplasm:int=14;
	static public const ItemTypeNodes:int=15;
	static public const ItemTypeArmour2:int=16;
	static public const ItemTypePower2:int=17;
	static public const ItemTypeRepair2:int=18;
	static public const ItemTypeMine:int=19;
	static public const ItemTypeEGM:int = 20;
	static public const ItemTypeMoney:int = 21;
	static public const ItemTypeTitan:int= 22;
	static public const ItemTypeSilicon:int=23;
	static public const ItemTypeCrystal:int=24;
	static public const ItemTypeXenon:int=25;
	static public const ItemTypeHydrogen:int = 26;
	static public const ItemTypeFood:int = 27;
	static public const ItemTypePlasma:int = 28;
	static public const ItemTypeMachinery:int = 29;
	static public const ItemTypeEngineer:int = 30;
	static public const ItemTypeTechnician:int = 31;
	static public const ItemTypeNavigator:int = 32;
	static public const ItemTypeQuarkCore:int = 33;
	static public const ItemTypeCnt:int = 34;
	
	static public const ItemTypeSysName:Array = [	
		"ItemTypeNone",
		"ItemTypeModule",
		"ItemTypeArmour",
		"ItemTypePower",
		"ItemTypeRepair",
		"ItemTypeJump",
		"ItemTypeBuild",
		"ItemTypeFuel",
		"ItemTypeDouble",
		"ItemTypeMonuk",
		"ItemTypeAntimatter",
		"",
		"ItemTypeMetal",
		"ItemTypeElectronics",
		"ItemTypeProtoplasm",
		"ItemTypeNodes",
		"ItemTypeArmour2",
		"ItemTypePower2",
		"ItemTypeRepair2",
		"ItemTypeMine",
		"ItemTypeEGM",
		"ItemTypeMoney",
		"ItemTypeTitan",
		"ItemTypeSilicon",
		"ItemTypeCrystal",
		"ItemTypeXenon",
		"ItemTypeHydrogen",
		"ItemTypeFood",
		"ItemTypePlasma",
		"ItemTypeMachinery",
		"ItemTypeEngineer",
		"ItemTypeTechnician",
		"ItemTypeNavigator",
		"ItemTypeQuarkCore"
	];

	static public const ItemArmourMetal:int=25*5;
	static public const ItemArmourElectronics:int=10*5;
	static public const ItemArmour2Metal:int=50*5;
	static public const ItemArmour2Electronics:int=20*5;
	static public const ItemArmour2Nodes:int=5*5;

	static public const ItemRepairMetal:int=10*5;
	static public const ItemRepairElectronics:int=25*5;
	static public const ItemRepair2Metal:int=20*5;
	static public const ItemRepair2Electronics:int=50*5;
	static public const ItemRepair2Protoplasm:int=20*5;

	static public const ItemPowerAntimatter:int=10*5;
	static public const ItemPowerElectronics:int=25*5;
	static public const ItemPower2Antimatter:int=20*5;
	static public const ItemPower2Electronics:int=50*5;
	static public const ItemPower2Protoplasm:int=20*5;

	static public const ItemFuelAntimatter:int=50;
	static public const ItemFuelMetal:int=20;
	
	static public const ResChangeFactor:int=20;

	static public const BonusArmour:int=26;//38;
	static public const BonusArmour2:int=51;//76;
	static public const BonusMonuk:int=25;
	static public const BonusPower:int = 26;
	static public const BonusPower2:int = 51;
	static public const BonusRepair:int = 500;// 10;
	static public const BonusRepair2:int = 1000;// 20;
	static public const BonusBuild:int = 4;

	static public const FleetFuelMax:int = 30000;

	static public const FuelFlyOne:int = 20;
	static public const FuelMax:int = 6 * FuelFlyOne;
	static public const FuelPlanetReload:int = 4 * FuelFlyOne;
	static public const FuelFromHyperspaceNeed:int = 10;
	static public const FuelFromHyperspaceLoad:int = 6 * FuelFlyOne;
	static public const FuelToHyperspace:int = 2 * FuelFlyOne;
//	static public const FuelMax:int=60;
	static public const ResMax:int=10000000;
	static public const ItemMaxCnt:int=9999;
	static public const ResNeedRezervFactor:int=30;

	static public const PlanetLevelCost:int=200;
	static public const PlanetLevelSDM:int=20;
	
	static public const BuildPlanetLvlMax:int=999;
	static public const BuildStationMax:int=20;

    //static public const ConstructionPointMax:int=1000000;
	static public const CargoMax:int=40;
	
	static public const SackHide:int=10000; 

	static public const PathMoveMax:int=64;

//	static public const SupplyLow:int=1000;
//	static public const SupplyNormal:int=2000;
//	static public const SupplyMuch:int=40000;

	static public const CitadelCost:int=5000;
	static public const CitadelMinDist:int=20;

	static public const TicketTypeAttack:int=1; // State: 0-begin 1-end
	static public const TicketTypePact:int=2; // State: 0-Send 1-Query 2-Accept 3-Reject 4-Complate 5-NoRes 6-TimeOut 7-change 8-break
	static public const TicketTypeCapture:int=3; // State: 0x10000-capture 0x20000-lost 0x000-colony 0x100-homeworld 0x200-citadel 0x300-empire 0x400-enclave 0xff-itemtype
	static public const TicketTypeSack:int=4;
	static public const TicketTypeFleetMoveError:int=5;
	static public const TicketTypeUnionJoin:int=6;
	static public const TicketTypeAnnihilation:int = 7;
	static public const TicketTypeCombatInvite:int = 8; // State: 1-Duel 2-Join 4-To 8-Query 16-NoAnser 32-Ok 64-Cancel
	
	static public const ttciDuel:int = 1;
	static public const ttciJoin:int = 2;
	static public const ttciTo:int = 4;
	static public const ttciQuery:int = 8;
	static public const ttciNoAnser:int = 16;
	static public const ttciOk:int = 32;
	static public const ttciCancel:int = 64;

	static public const StabilizerTime:int=180;
	//static public const StabilizerConsumption:int=3;

	static public const PactPass:uint=1<<0;
	static public const PactNoFly:uint=1<<1;
	static public const PactNoBattle:uint=1<<2;
	static public const PactProtect:uint=1<<3;
	static public const PactControl:uint=1<<4;
	static public const PactBuild:uint=1<<5;
	static public const PactWar:uint=1<<6;

	static public const PactPercent:Array		= new Array(0, 13, 26, 38, 51, 64, 77, 77);//(0, 13, 26, 52, 77, 103, 128, 128); 

	static public const FuelConsumptionStep:int = 200;
	static public const FleetFuelConsumption:Array	= new Array(5, 20, 50, 2, 5);
//	static public const FleetFormationCost:Array	= new Array(0, 200000, 1000000, 10000, 50000); 
//	static public const FleetFormationCargoMul:Array = new Array(1, 1, 1, 5, 10);
//	static public const FleetMassMax:Array = new Array(300000, 900000, 1400000, 450000, 600000);
	static public const FleetMassMax:int = 1400000;
	static public const FleetHoldLvlCnt:int = 6;
	static public const FleetHoldRowByLvl:Array = new Array(3, 4, 5, 6, 7, 8);
	static public const FleetHoldLvlCost:Array = new Array(0, 10000, 30000, 80000, 250000, 400000);
	static public const FleetHoldCargoLvlCnt:int = 11;
	static public const FleetHoldCargoMulByLvl:Array = new Array(1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20);
	static public const FleetHoldCargoLvlCost:Array = new Array(0, 20000, 60000, 160000, 500000, 800000, 1600000, 3200000, 6400000, 12800000, 25600000);

	static public const FleetSpeed:Array = new Array(0.13, 0.10, 0.07, 0.10, 0.07);
	static public const FleetSpeedAngle:Array = new Array(0.001 * Math.PI, 0.0007 * Math.PI, 0.0003 * Math.PI, 0.0007 * Math.PI, 0.0003 * Math.PI);

	static public const PlusarModuleCost:int=4500;
	static public const PlusarCaptainCost:int=3000;
	static public const PlusarTechCost:int=4000;
	static public const PlusarControlCost:int=35000;
	static public const PlusarModuleBonus:int=128;
	static public const PlusarResBonus:int=103;//52;
	static public const PlusarPlanetShieldCost:int=200;
	static public const PlusarPlanetShieldPeriod:int=48*60*60;
	static public const PlusarPlanetShieldEnd:int=30*60;

	static public const CostNewUnion:int=10000;
	static public const CostRenameUnion:int=10000;

	static public const GlobalShieldSleepPeriod:int=8;
	static public const GlobalShieldSleepPeriodPlusar:int=10;

	static public const CotlBonusAntimatter:int = 1;
	static public const CotlBonusMetal:int = 2;
	static public const CotlBonusElectronics:int = 3;
	static public const CotlBonusProtoplasm:int = 4;
	static public const CotlBonusNodes:int = 5;
	static public const CotlBonusCorvetteArmour:int = 6; 		// x
	static public const CotlBonusCorvetteAccuracy:int = 7;		// x
	static public const CotlBonusCruiserArmour:int = 8;			// x
	static public const CotlBonusCruiserAccuracy:int = 9;		// x
	static public const CotlBonusDreadnoughtArmour:int = 10;	// x
	static public const CotlBonusDreadnoughtAccuracy:int = 11;	// x
	static public const CotlBonusDevastatorArmour:int = 12;		// x
	static public const CotlBonusDevastatorAccuracy:int = 13;	// x
	static public const CotlBonusDevastatorBomb:int = 14;		// x
	static public const CotlBonusWarBaseArmour:int = 15;		// x
	static public const CotlBonusWarBaseAccuracy:int = 16;		// x
	static public const CotlBonusWarBaseArmourAll:int = 17;		// x
	static public const CotlBonusShipyardSupply:int = 18;		// x
	static public const CotlBonusShipyardRepairAll:int = 19;	// x
	static public const CotlBonusSciBaseSupply:int = 20;		// x
	static public const CotlBonusMinePower:int = 21;			// x
	static public const CotlBonusPlanetEmpireCnt:int = 22;		// x
	static public const CotlBonusPlanetEnclaveCnt:int = 23;		// x
	static public const CotlBonusPlanetColonyCnt:int = 24;		// x
	static public const CotlBonusCnt:int = 25;

	static public const CotlBonusCorvetteArmourVal:Array = [13, 18, 23, 26]; //10% [32, 48, 60, 64]
	static public const CotlBonusCruiserArmourVal:Array = [18, 28, 33, 36, 38]; //15% [38, 57, 66, 72, 77]
	static public const CotlBonusDreadnoughtArmourVal:Array = [18, 28, 33, 36, 38]; //15% [38, 57, 66, 72, 77]
	static public const CotlBonusDevastatorArmourVal:Array = [10, 15, 20, 23]; //9% [19, 28, 32, 38]
	static public const CotlBonusWarBaseArmourVal:Array = [13, 18, 23, 26]; //10% [25, 37, 46, 51]
	static public const CotlBonusWarBaseArmourAllVal:Array = [13, 21, 26]; //10% [13, 21, 26]

	static public const CotlBonusCorvetteAccuracyVal:Array = [90, 141, 167, 180, 192];//[192, 295, 333, 359, 384];
	static public const CotlBonusCruiserAccuracyVal:Array = [51, 77, 90, 97, 102];//[90, 141, 167, 180, 192];
	static public const CotlBonusDreadnoughtAccuracyVal:Array = [90, 141, 167, 180, 192];//[192, 295, 333, 359, 384];
	static public const CotlBonusDevastatorAccuracyVal:Array = [51, 77, 90, 97, 102];//[90, 141, 167, 180, 192];
	static public const CotlBonusWarBaseAccuracyVal:Array = [51, 77, 90, 97, 102];//[90, 141, 167, 180, 192];

	static public const CotlBonusDevastatorBombVal:Array = [300, 450, 525, 570, 590, 600];
	static public const CotlBonusShipyardSupplyVal:Array = [64, 90, 116, 128];
	static public const CotlBonusSciBaseSupplyVal:Array = [64, 90, 116, 128];

	static public const CotlBonusShipyardRepairAllVal:Array = [100, 150, 175, 200];
	static public const CotlBonusMinePowerVal:Array = [100, 150, 175, 200];
	
	static public const CotlBonusPlanetEmpireCntVal:Array = [25, 40, 50];
	static public const CotlBonusPlanetEnclaveCntVal:Array = [15, 22, 30];
	static public const CotlBonusPlanetColonyCntVal:Array = [10, 15, 20];

	static public function CotlBonusVal(bt:int):Array
	{
		if (bt == CotlBonusCorvetteArmour) return CotlBonusCorvetteArmourVal;
		else if (bt == CotlBonusCorvetteAccuracy) return CotlBonusCorvetteAccuracyVal;
		else if (bt == CotlBonusCruiserArmour) return CotlBonusCruiserArmourVal;
		else if (bt == CotlBonusCruiserAccuracy) return CotlBonusCruiserAccuracyVal;
		else if (bt == CotlBonusDreadnoughtArmour) return CotlBonusDreadnoughtArmourVal;
		else if (bt == CotlBonusDreadnoughtAccuracy) return CotlBonusDreadnoughtAccuracyVal;
		else if (bt == CotlBonusDevastatorArmour) return CotlBonusDevastatorArmourVal;
		else if (bt == CotlBonusDevastatorAccuracy) return CotlBonusDevastatorAccuracyVal;
		else if (bt == CotlBonusDevastatorBomb) return CotlBonusDevastatorBombVal;
		else if (bt == CotlBonusWarBaseArmour) return CotlBonusWarBaseArmourVal;
		else if (bt == CotlBonusWarBaseAccuracy) return CotlBonusWarBaseAccuracyVal;
		else if (bt == CotlBonusWarBaseArmourAll) return CotlBonusWarBaseArmourAllVal;
		else if (bt == CotlBonusShipyardSupply) return CotlBonusShipyardSupplyVal;
		else if (bt == CotlBonusShipyardRepairAll) return CotlBonusShipyardRepairAllVal;
		else if (bt == CotlBonusSciBaseSupply) return CotlBonusSciBaseSupplyVal;
		else if (bt == CotlBonusMinePower) return CotlBonusMinePowerVal;
		else if (bt == CotlBonusPlanetEmpireCnt) return CotlBonusPlanetEmpireCntVal;
		else if (bt == CotlBonusPlanetEnclaveCnt) return CotlBonusPlanetEnclaveCntVal;
		else if (bt == CotlBonusPlanetColonyCnt) return CotlBonusPlanetColonyCntVal;
		return null;
	}
	
	static public function CotlBonusValEx(bt:int, lvl:int):int
	{
		if (lvl < 1) return 0;
		var ar:Array = CotlBonusVal(bt);
		if (ar == null) return 0;
		if (lvl >= ar.length) return ar[ar.length-1];
		return ar[lvl-1];
	}

	static public const CotlBonusTypeList:Array = [
		CotlBonusAntimatter, CotlBonusMetal, CotlBonusElectronics, CotlBonusProtoplasm, CotlBonusNodes,
		CotlBonusCorvetteArmour, CotlBonusCorvetteAccuracy, CotlBonusCruiserArmour, CotlBonusCruiserAccuracy, CotlBonusDreadnoughtArmour, CotlBonusDreadnoughtAccuracy, CotlBonusDevastatorArmour,
		CotlBonusDevastatorAccuracy, CotlBonusDevastatorBomb, CotlBonusWarBaseArmour, CotlBonusWarBaseAccuracy, CotlBonusWarBaseArmourAll, CotlBonusShipyardSupply, CotlBonusShipyardRepairAll,
		CotlBonusSciBaseSupply, CotlBonusMinePower, CotlBonusPlanetEmpireCnt, CotlBonusPlanetEnclaveCnt, CotlBonusPlanetColonyCnt];

	static public const TechProgress:int = 0; 
	static public const TechEconomy:int = 1;
	static public const TechTransport:int = 2;
	static public const TechCorvette:int = 3;
	static public const TechCruiser:int = 4;
	static public const TechDreadnought:int = 5;
	static public const TechInvader:int = 6;
	static public const TechDevastator:int = 7;
	static public const TechWarBase:int = 8;
	static public const TechShipyard:int = 9;
	static public const TechSciBase:int = 10;
	static public const TechQuarkBase:int = 11;
	static public const TechCnt:int = 12;

	static public function IsTechOff(t:int):Boolean { return (t == TechEconomy) /*|| (t==TechQuarkBase)*/ || (t<0) || (t>=TechCnt); }

	static public const TechProgressCost:Array		= new Array(0, 0, 0, 0, 0, 0); //new Array(3, 5, 2, 0, 0, 0); 
	static public const TechEconomyCost:Array		= new Array(0, 0, 0, 0, 0, 0); //new Array(3, 2, 5, 0, 0, 0); 
	static public const TechTransportCost:Array		= new Array(0, 0, 0, 1, 0, 0); //new Array(3, 4, 3, 1, 0, 0); 
	static public const TechCorvetteCost:Array		= new Array(0, 0, 0, 1, 0, 0); //new Array(4, 3, 3, 1, 0, 0); 
	static public const TechCruiserCost:Array		= new Array(0, 0, 0, 2, 0, 0); //new Array(1, 8, 1, 2, 0, 0); 
	static public const TechDreadnoughtCost:Array	= new Array(0, 0, 0, 2, 0, 0); //new Array(4, 1, 5, 2, 0, 0); 
	static public const TechInvaderCost:Array		= new Array(0, 0, 0, 2, 0, 0); //new Array(3, 3, 4, 2, 0, 0); 
	static public const TechDevastatorCost:Array	= new Array(0, 0, 0, 2, 0, 0); //new Array(2, 1, 7, 2, 0, 0);
	static public const TechWarBaseCost:Array		= new Array(0, 0, 0, 3, 0, 0); //new Array(3, 4, 3, 3, 0, 0); 
	static public const TechShipyardCost:Array		= new Array(0, 0, 0, 3, 0, 0); //new Array(3, 3, 4, 3, 0, 0); 
	static public const TechSciBaseCost:Array		= new Array(0, 0, 0, 3, 0, 0); //new Array(5, 2, 3, 3, 0, 0);
	static public const TechQuarkBaseCost:Array		= new Array(0, 0, 0,10, 0, 1);

	static public const DirEmpireMax:int=1;
	static public const DirEnclaveMax:int=2;
	static public const DirColonyMax:int=3;
//	static public const DirPlanetLevelMax:int=4;
	static public const DirShipMassMax:int=4;
	static public const DirShipSpeed:int=5;
	static public const DirPlanetProtect:int=6;
	static public const DirCaptureSlow:int=7;

//	static public const DirModuleSpeed:int=9;	
//	static public const DirResSpeed:int=10;
//	static public const DirSupplyNormal:int=11;
//	static public const DirSupplyMuch:int=12;
//	static public const DirModuleMax:int=13;
//	static public const DirResMax:int=14;
//	static public const DirCitadelCost:int=15;
//	static public const DirPlanetLavelCost:int=16;

	static public const DirTransportPrice:int=17;
	static public const DirTransportCnt:int=18;
	//static public const DirTransportSupply:int=19;
	static public const DirTransportMass:int=19;
//	static public const DirTransportFuel:int=20;
	static public const DirTransportArmour:int=21;
	static public const DirTransportWeapon:int=22;
	static public const DirTransportCargo:int=23;

	static public const DirCorvettePrice:int=25;
	static public const DirCorvetteCnt:int=26;
	//static public const DirCorvetteSupply:int=27;
	static public const DirCorvetteMass:int=27;
//	static public const DirCorvetteFuel:int=28;
	static public const DirCorvetteArmour:int=29;
	static public const DirCorvetteWeapon:int=30;
	static public const DirCorvetteAccuracy:int=31;
	static public const DirCorvetteStealth:int=32;

	static public const DirCruiserAccess:int=33;
	static public const DirCruiserPrice:int=34;
	static public const DirCruiserCnt:int=35;
	//static public const DirCruiserSupply:int=36;
	static public const DirCruiserMass:int=36;
//	static public const DirCruiserFuel:int=37;
	static public const DirCruiserArmour:int=38;
	static public const DirCruiserWeapon:int=39;
	static public const DirCruiserAccuracy:int=40;

	static public const DirDreadnoughtAccess:int=41;
	static public const DirDreadnoughtPrice:int=42;
	static public const DirDreadnoughtCnt:int=43;
	//static public const DirDreadnoughtSupply:int=44;
	static public const DirDreadnoughtMass:int=44;
//	static public const DirDreadnoughtFuel:int=45;
	static public const DirDreadnoughtArmour:int=46;
	static public const DirDreadnoughtWeapon:int=47;
	static public const DirDreadnoughtAccuracy:int=48;

	static public const DirInvaderPrice:int=49;
	static public const DirInvaderCnt:int=50;
	//static public const DirInvaderSupply:int=51;
	static public const DirInvaderMass:int=51;
//	static public const DirInvaderFuel:int=52;
	static public const DirInvaderArmour:int=53;
	static public const DirInvaderWeapon:int=54;
	static public const DirInvaderCaptureSpeed:int=55;

	static public const DirDevastatorAccess:int=57;
	static public const DirDevastatorPrice:int=58;
	static public const DirDevastatorCnt:int=59;
	//static public const DirDevastatorSupply:int=60;
	static public const DirDevastatorMass:int=60;
//	static public const DirDevastatorFuel:int=61;
	static public const DirDevastatorArmour:int=62;
	static public const DirDevastatorWeapon:int=63;
	static public const DirDevastatorAccuracy:int=64;
	static public const DirDevastatorBomb:int=89;

	static public const DirWarBaseAccess:int=65;
	static public const DirWarBasePrice:int=66;
	static public const DirWarBaseCnt:int=67;
	//static public const DirWarBaseSupply:int=68;
	static public const DirWarBaseMass:int=68;
	static public const DirWarBaseArmour:int=69;
	static public const DirWarBaseAccuracy:int=70;
	static public const DirWarBaseRepair:int=71;
	static public const DirWarBaseArmourAll:int=72;

	static public const DirShipyardAccess:int=73;
	static public const DirShipyardPrice:int=74;
	static public const DirShipyardCnt:int=75;
	//static public const DirShipyardSupply:int=76;
	static public const DirShipyardMass:int=76;
	static public const DirShipyardArmour:int=77;
	static public const DirShipyardAccuracy:int=78;
	static public const DirShipyardRepair:int=79;
	static public const DirShipyardRepairAll:int=80;

	static public const DirSciBaseAccess:int=81;
	static public const DirSciBasePrice:int=82;
	static public const DirSciBaseCnt:int=83;
	//static public const DirSciBaseSupply:int=84;
	static public const DirSciBaseMass:int=84;
	static public const DirSciBaseArmour:int=85;
	static public const DirSciBaseAccuracy:int=86;
	static public const DirSciBaseRepair:int=87;
	static public const DirSciBaseStabilizer:int=88;  // need

    static public const DirQuarkBaseAccess:int=90;
//	static public const DirQuarkBaseMass:int=91;
	static public const DirQuarkBaseWeapon:int=92;
	static public const DirQuarkBaseAccuracy:int=93;
	static public const DirQuarkBaseArmour:int=94;
	static public const DirQuarkBaseRepair:int=95;
	static public const DirQuarkBaseAntiGravitor:int = 96;
	static public const DirQuarkBaseGravWell:int = 97;
	static public const DirQuarkBaseBlackHole:int = 98;
	static public const DirQuarkBaseHP:int = 99;
	static public const DirQuarkBaseShield:int = 100;
	static public const DirQuarkBaseShieldReduce:int = 101;
	static public const DirQuarkBaseShieldInc:int = 102;
	static public const DirQuarkBaseAntiShield:int = 103;

	static public const DirEmpireMaxLvl:Array=[ 40, 60, 90, 120, 150 ];//[ 30, 40, 60, 80, 110 ];
	static public const DirEnclaveMaxLvl:Array=[ 5, 20, 40, 60, 100 ];//[ 2, 20, 30, 40, 70 ];
	static public const DirColonyMaxLvl:Array=[ 5, 10, 15, 20, 30 ];
	//static public const DirPlanetLevelMaxLvl:Array=[ 399, 499, 599, 699, 899, 999 ];
	static public const DirShipMassMaxLvlEmp:Array = [8000, 10000, 12000, 14000, 16000, 18000];//[5000, 7000, 9000, 11000, 13000, 15000];// [6000, 8000, 11000, 14000, 17000, 20000];// [300000, 400000, 600000, 800000, 1000000, 1200000];
	static public const DirShipMassMaxLvlEnc:Array = [2500, 3000, 3500, 4000, 4500, 5000];// [1200, 1700, 2200, 2800, 3500, 4000];
	static public const DirShipMassMaxLvlDef:Array = [4000, 5000, 7000, 9000, 11000, 13000];
	static public const DirShipSpeedLvl:Array=[ 75, 100, 125 ];
	static public const DirShipSpeedLvlRC:Array=[ 30, 40, 50 ];
	static public const DirPlanetProtectLvl:Array=[ 0, 2, 4, 6, 8 ];
	static public const DirPlanetProtectLvlRC:Array=[ 0, 5, 10, 15, 20 ];
	static public const DirCaptureSlowLvl:Array=[ 0, 25, 50, 75, 100 ];

//	static public const DirModuleSpeedLvl:Array=[ 20,19,18,17,16 ];	
//	static public const DirResSpeedLvl:Array=[ 100,105,110,115,120 ];
//	static public const DirResSpeedLvlRC:Array=[ 0,12,25,38,51 ];
//	static public const DirSupplyNormalLvl:Array=[ 1000, 2000, 4000, 6000, 8000 ];
//	static public const DirSupplyMuchLvl:Array=[ 30000, 40000, 60000, 80000, 100000 ];
//	static public const DirModuleMaxLvl:Array=[ 60000, 90000, 130000, 170000, 200000 ];//[ 200000, 500000, 800000, 1100000, 1500000 ];
//	static public const DirResMaxLvl:Array=[ 100000, 500000, 1000000, 10000000, 30000000 ];
//	static public const DirCitadelCostLvl:Array=[ 200000, 100000, 50000 ];
//	static public const DirPlanetLavelCostLvl:Array=[ 300, 260, 220, 170, 150 ];
	
	static public const ModuleMaxMul:int=5;

	static public const DirTransportPriceLvl:Array=[160,140,120,100,80];
	static public const DirTransportCntLvl:Array=[199,399,599,799,999];
	//static public const DirTransportSupplyLvl:Array=[512,384,256];
	static public const DirTransportMassLvl:Array=[50,40,30];
//	static public const DirTransportFuelLvl:Array=[20,40,60];
	static public const DirTransportArmourLvl:Array = [0, 8, 15, 20, 26];//[0, 13, 26, 38, 51];
	static public const DirTransportWeaponLvl:Array=[0,1,2];
	static public const DirTransportCargoLvl:Array=[40,60,100,150,200,300,500];

	static public const DirCorvettePriceLvl:Array = [100, 90, 80, 70, 60];// [50, 45, 40, 35, 30];//[30,25,20,15,10];
	static public const DirCorvetteCntLvl:Array=[199,399,599,799,999];
	//static public const DirCorvetteSupplyLvl:Array=[512,384,256];
	static public const DirCorvetteMassLvl:Array = [20,15,10];// [10, 7, 5];
//	static public const DirCorvetteFuelLvl:Array=[20,40,60];
	static public const DirCorvetteArmourLvl:Array = [13, 15, 18, 20, 23, 26];// [0, 5, 10, 15, 20, 26];//[0, 13, 26, 38, 51, 64];
	static public const DirCorvetteWeaponLvl:Array=[3,4,5,6];
	static public const DirCorvetteAccuracyLvl:Array = [64, 77, 90, 102, 115, 128];//[0,21,42,85,106,128];// [0, 64, 128, 256, 320, 384];// [0, 128, 256, 512, 640, 768];
	static public const DirCorvetteStealthLvl:Array=[0,1];

	static public const DirCruiserAccessLvl:Array=[0,1];
	static public const DirCruiserPriceLvl:Array = [300, 250, 200, 150, 100];
	static public const DirCruiserCntLvl:Array = [199, 399, 599, 799, 999];
	//static public const DirCruiserSupplyLvl:Array=[640,512,384,256];
	static public const DirCruiserMassLvl:Array = [20, 17, 14, 10];
//	static public const DirCruiserFuelLvl:Array=[20,40,60];
	static public const DirCruiserArmourLvl:Array = [23, 26, 28, 31, 33, 36, 38];//[0, 5, 8, 15, 23, 30, 38];//[0, 13, 26, 38, 51, 64, 77];
	static public const DirCruiserWeaponLvl:Array=[1,2,3,4,5,6];
	static public const DirCruiserAccuracyLvl:Array = [77, 115, 154, 192];// [0, 64, 128, 192];// [0, 128, 256, 384];

	static public const DirDreadnoughtAccessLvl:Array=[0,1];
	static public const DirDreadnoughtPriceLvl:Array = [350, 300, 250, 200, 150];// [450, 400, 350, 300, 250];
	static public const DirDreadnoughtCntLvl:Array=[199,399,599,799,999];
	//static public const DirDreadnoughtSupplyLvl:Array=[512,384,256];
	static public const DirDreadnoughtMassLvl:Array = [25, 20, 15];// [70, 55, 40];
//	static public const DirDreadnoughtFuelLvl:Array=[20,40,60];
	static public const DirDreadnoughtArmourLvl:Array = [23, 28, 33, 38];// [0, 13, 26, 38];//[0, 26, 51, 77];
	static public const DirDreadnoughtWeaponLvl:Array=[10,20,30];
	static public const DirDreadnoughtAccuracyLvl:Array = [192, 230, 269, 307, 346, 384];// [0,128,256,512,640,768];

	static public const DirInvaderPriceLvl:Array = [50, 45, 40, 35, 30];
	static public const DirInvaderCntLvl:Array = [199, 399, 599, 799, 999];
	//static public const DirInvaderSupplyLvl:Array=[512,384,256];
	static public const DirInvaderMassLvl:Array = [20, 15, 10];
//	static public const DirInvaderFuelLvl:Array=[20,40,60];
	static public const DirInvaderArmourLvl:Array = [0, 8, 15, 20, 26];//[0, 13, 26, 38, 51];
	static public const DirInvaderWeaponLvl:Array = [0, 1, 2];
	static public const DirInvaderCaptureSpeedLvl:Array = [179, 198, 223, 256, 295, 359, 449];// [218, 231, 243, 256, 272, 292, 308];//[0, 51, 102, 154, 204, 256, 307];

	static public const DirDevastatorAccessLvl:Array = [0, 1];
	static public const DirDevastatorPriceLvl:Array = [700,600,500,400,300];// [350, 300, 250, 200, 150];
	static public const DirDevastatorCntLvl:Array=[199,399,599,799,999];
	//static public const DirDevastatorSupplyLvl:Array=[512,384,256];
	static public const DirDevastatorMassLvl:Array = [30, 25, 20];// [25, 20, 15];
//	static public const DirDevastatorFuelLvl:Array=[20,40,60];
	static public const DirDevastatorArmourLvl:Array = [0, 8, 15, 23];//[0, 13, 26, 38];
	static public const DirDevastatorWeaponLvl:Array = [5, 6, 7, 8];
	static public const DirDevastatorAccuracyLvl:Array = [102, 120, 138, 156, 174, 192];// [0, 64, 90, 115, 154, 192];// [0, 128, 179, 230, 307, 384];
	static public const DirDevastatorAccuracyHitLvl:Array = [141, 154, 166, 179, 192, 205];//[102, 115, 128, 153, 179, 205];
	static public const DirDevastatorBombLvl:Array=[350,400,450,500,550,600];
	
	static public const DirWarBaseAccessLvl:Array=[0,1];
	static public const DirWarBasePriceLvl:Array=[30000,25000,20000,15000,10000];
	static public const DirWarBaseCntLvl:Array=[1,2,5,10,20];
	//static public const DirWarBaseSupplyLvl:Array=[512,384,256];
	static public const DirWarBaseMassLvl:Array=[500,400,250];
	static public const DirWarBaseArmourLvl:Array = [15, 18, 20, 23, 26];//[0, 8, 15, 20, 26];//[0, 13, 26, 38, 51];
	static public const DirWarBaseAccuracyLvl:Array = [192, 256, 320, 384];//[0, 128, 256, 384];// [0, 64, 128, 192];
	static public const DirWarBaseRepairLvl:Array=[10,15,20,25,30];
	static public const DirWarBaseArmourAllLvl:Array=[0,10,18,26];

	static public const DirShipyardAccessLvl:Array=[0,1];
	static public const DirShipyardPriceLvl:Array=[30000,25000,20000,15000,10000];
	static public const DirShipyardCntLvl:Array=[1,2,4];
	//static public const DirShipyardSupplyLvl:Array=[768,640,512,384,256];
	static public const DirShipyardMassLvl:Array=[30000,25000,20000,15000,10000];
	static public const DirShipyardArmourLvl:Array = [0, 8, 15, 23];//[0, 13, 26, 38];
	static public const DirShipyardAccuracyLvl:Array=[0, 64, 128, 192];// [0,128,256,384];
	static public const DirShipyardRepairLvl:Array=[10,15,20,25,30];
	static public const DirShipyardRepairAllLvl:Array = [0, 100, 150, 250];

	static public const DirSciBaseAccessLvl:Array=[0,1];
	static public const DirSciBasePriceLvl:Array=[30000,25000,20000,15000,10000];
	static public const DirSciBaseCntLvl:Array=[1,2,4];
	//static public const DirSciBaseSupplyLvl:Array=[768,640,512,384,256];
	static public const DirSciBaseMassLvl:Array=[900,800,700,600,500];
	static public const DirSciBaseArmourLvl:Array = [0, 8, 15, 23];//[0, 13, 26, 38];
	static public const DirSciBaseAccuracyLvl:Array=[0, 64, 128, 192];// [0,128,256,384];
	static public const DirSciBaseRepairLvl:Array=[10,15,20,25,30];
	static public const DirSciBaseStabilizerLvl:Array = [100, 70];

	static public const DirQuarkBaseAccessLvl:Array = [0, 1];
//	static public const DirQuarkBaseMassLvl:Array = [600000, 550000, 500000, 450000, 400000];
	static public const DirQuarkBaseWeaponLvl:Array = [5000, 8000, 10000];
	static public const DirQuarkBaseAccuracyLvl:Array = [0, 64, 128];// [0, 128, 256];
	static public const DirQuarkBaseArmourLvl:Array = [0,26,51];// [0, 51, 102];
	static public const DirQuarkBaseRepairLvl:Array = [50,500,1000,2000];
	static public const DirQuarkBaseAntiGravitorLvl:Array = [0, 20, 15, 10, 5];
	static public const DirQuarkBaseGravWellLvl:Array = [0, 55, 35, 15];
	static public const DirQuarkBaseBlackHoleLvl:Array = [0, 30, 10];// [0, 70, 50, 30];
	static public const DirQuarkBaseHPLvl:Array = [500000,1000000,2000000];
	static public const DirQuarkBaseShieldLvl:Array = [500000,1000000,2000000];
	static public const DirQuarkBaseShieldReduceLvl:Array = [0,26,51];//[0, 51, 102];
	static public const DirQuarkBaseShieldIncLvl:Array = [25, 250, 500, 750];
	static public const DirQuarkBaseAntiShieldLvl:Array = [0, 30, 15, 5];

	static public const ResearchPeriod:Array=[50,100,150,200,300,500,800,1200,1700,2300,3000,3800,4700];

	static public const DirEmpireMaxDesc:Array=new Array();
	static public const DirEnclaveMaxDesc:Array=new Array();
	static public const DirColonyMaxDesc:Array=new Array();
	//static public const DirPlanetLevelMaxDesc:Array=new Array();
	static public const DirShipMassMaxDesc:Array = new Array();
	static public const DirShipSpeedDesc:Array=new Array();
	static public const DirPlanetProtectDesc:Array=new Array();
	static public const DirCaptureSlowDesc:Array=new Array();

	//static public const DirModuleSpeedDesc:Array=new Array();	
	//static public const DirResSpeedDesc:Array=new Array();
	//static public const DirSupplyNormalDesc:Array=new Array();
	//static public const DirSupplyMuchDesc:Array=new Array();
	//static public const DirModuleMaxDesc:Array=new Array();
	//static public const DirResMaxDesc:Array=new Array();
	//static public const DirCitadelCostDesc:Array=new Array();
	//static public const DirPlanetLavelCostDesc:Array=new Array();

	static public const DirTransportPriceDesc:Array=new Array();
	static public const DirTransportCntDesc:Array=new Array();
	//static public const DirTransportSupplyDesc:Array=new Array();
	static public const DirTransportMassDesc:Array=new Array();
//	static public const DirTransportFuelDesc:Array=new Array();
	static public const DirTransportArmourDesc:Array=new Array();
	static public const DirTransportWeaponDesc:Array=new Array();
	static public const DirTransportCargoDesc:Array=new Array();

	static public const DirCorvettePriceDesc:Array=new Array();
	static public const DirCorvetteCntDesc:Array=new Array();
	//static public const DirCorvetteSupplyDesc:Array=new Array();
	static public const DirCorvetteMassDesc:Array=new Array();
//	static public const DirCorvetteFuelDesc:Array=new Array();
	static public const DirCorvetteArmourDesc:Array=new Array();
	static public const DirCorvetteWeaponDesc:Array=new Array();
	static public const DirCorvetteAccuracyDesc:Array=new Array();
	static public const DirCorvetteStealthDesc:Array=new Array();

	static public const DirCruiserAccessDesc:Array=new Array();
	static public const DirCruiserPriceDesc:Array=new Array();
	static public const DirCruiserCntDesc:Array=new Array();
	//static public const DirCruiserSupplyDesc:Array=new Array();
	static public const DirCruiserMassDesc:Array=new Array();
//	static public const DirCruiserFuelDesc:Array=new Array();
	static public const DirCruiserArmourDesc:Array=new Array();
	static public const DirCruiserWeaponDesc:Array=new Array();
	static public const DirCruiserAccuracyDesc:Array=new Array();

	static public const DirDreadnoughtAccessDesc:Array=new Array();
	static public const DirDreadnoughtPriceDesc:Array=new Array();
	static public const DirDreadnoughtCntDesc:Array=new Array();
	//static public const DirDreadnoughtSupplyDesc:Array=new Array();
	static public const DirDreadnoughtMassDesc:Array=new Array();
//	static public const DirDreadnoughtFuelDesc:Array=new Array();
	static public const DirDreadnoughtArmourDesc:Array=new Array();
	static public const DirDreadnoughtWeaponDesc:Array=new Array();
	static public const DirDreadnoughtAccuracyDesc:Array=new Array();

	static public const DirInvaderPriceDesc:Array=new Array();
	static public const DirInvaderCntDesc:Array=new Array();
	//static public const DirInvaderSupplyDesc:Array=new Array();
	static public const DirInvaderMassDesc:Array=new Array();
//	static public const DirInvaderFuelDesc:Array=new Array();
	static public const DirInvaderArmourDesc:Array=new Array();
	static public const DirInvaderWeaponDesc:Array=new Array();
	static public const DirInvaderCaptureSpeedDesc:Array=new Array();

	static public const DirDevastatorAccessDesc:Array=new Array();
	static public const DirDevastatorPriceDesc:Array=new Array();
	static public const DirDevastatorCntDesc:Array=new Array();
	//static public const DirDevastatorSupplyDesc:Array=new Array();
	static public const DirDevastatorMassDesc:Array=new Array();
//	static public const DirDevastatorFuelDesc:Array=new Array();
	static public const DirDevastatorArmourDesc:Array=new Array();
	static public const DirDevastatorWeaponDesc:Array=new Array();
	static public const DirDevastatorAccuracyDesc:Array=new Array();
	static public const DirDevastatorBombDesc:Array=new Array();

	static public const DirWarBaseAccessDesc:Array=new Array();
	static public const DirWarBasePriceDesc:Array=new Array();
	static public const DirWarBaseCntDesc:Array=new Array();
	//static public const DirWarBaseSupplyDesc:Array=new Array();
	static public const DirWarBaseMassDesc:Array=new Array();
	static public const DirWarBaseArmourDesc:Array=new Array();
	static public const DirWarBaseAccuracyDesc:Array=new Array();
	static public const DirWarBaseRepairDesc:Array=new Array();
	static public const DirWarBaseArmourAllDesc:Array=new Array();

	static public const DirShipyardAccessDesc:Array=new Array();
	static public const DirShipyardPriceDesc:Array=new Array();
	static public const DirShipyardCntDesc:Array=new Array();
	//static public const DirShipyardSupplyDesc:Array=new Array();
	static public const DirShipyardMassDesc:Array=new Array();
	static public const DirShipyardArmourDesc:Array=new Array();
	static public const DirShipyardAccuracyDesc:Array=new Array();
	static public const DirShipyardRepairDesc:Array=new Array();
	static public const DirShipyardRepairAllDesc:Array=new Array();

	static public const DirSciBaseAccessDesc:Array=new Array();
	static public const DirSciBasePriceDesc:Array=new Array();
	static public const DirSciBaseCntDesc:Array=new Array();
	//static public const DirSciBaseSupplyDesc:Array=new Array();
	static public const DirSciBaseMassDesc:Array=new Array();
	static public const DirSciBaseArmourDesc:Array=new Array();
	static public const DirSciBaseAccuracyDesc:Array=new Array();
	static public const DirSciBaseRepairDesc:Array=new Array();
	static public const DirSciBaseStabilizerDesc:Array=new Array();

	static public const DirQuarkBaseAccessDesc:Array=new Array();
//	static public const DirQuarkBaseMassDesc:Array=new Array();
	static public const DirQuarkBaseWeaponDesc:Array=new Array();
	static public const DirQuarkBaseAccuracyDesc:Array=new Array();
	static public const DirQuarkBaseArmourDesc:Array=new Array();
	static public const DirQuarkBaseRepairDesc:Array=new Array();
	static public const DirQuarkBaseAntiGravitorDesc:Array=new Array();
	static public const DirQuarkBaseGravWellDesc:Array=new Array();
	static public const DirQuarkBaseBlackHoleDesc:Array = new Array();
	static public const DirQuarkBaseHPDesc:Array = new Array();
	static public const DirQuarkBaseShieldDesc:Array = new Array();
	static public const DirQuarkBaseShieldReduceDesc:Array = new Array();
	static public const DirQuarkBaseShieldIncDesc:Array = new Array();
	static public const DirQuarkBaseAntiShieldDesc:Array = new Array();

	static public const DirImg:Array=["",
		"DirEmpireMax","DirEnclaveMax","DirColonyMax","DirPlanetLevelMax"/*"DirPlanetLevelMax"*/,"DirShipSpeed","DirPlanetProtect","DirCaptureSlow","",
		"DirModuleSpeed","DirResSpeed","DirSupplyNormal","DirSupplyMuch","DirModuleMax","DirResMax","DirCitadelCost","DirPlanetLavelCost",
		"DirPrice","DirCnt","DirSupply","DirFuel","DirArmour","DirWeapon","DirCargo","",
		"DirPrice","DirCnt","DirSupply","DirFuel","DirArmour","DirWeapon","DirAccuracy","DirStealth",
		"DirCruiserAccess","DirPrice","DirCnt","DirSupply","DirFuel","DirArmour","DirWeapon","DirAccuracy",
		"DirDreadnoughtAccess","DirPrice","DirCnt","DirSupply","DirFuel","DirArmour","DirWeapon","DirAccuracy",
		"DirPrice","DirCnt","DirSupply","DirFuel","DirArmour","DirWeapon","DirCapture","",
		"DirDevastatorAccess","DirPrice","DirCnt","DirSupply","DirFuel","DirArmour","DirMissile","DirAccuracy",
		"DirWarBaseAccess","DirPrice","DirCnt","DirSupply","DirArmour","DirAccuracy","DirRepair","DirArmourAll",
		"DirShipyardAccess","DirPrice","DirCnt","DirSupply","DirArmour","DirAccuracy","DirRepair","DirRepairAll",
		"DirSciBaseAccess","DirPrice","DirCnt","DirSupply","DirArmour","DirAccuracy","DirRepair","DirStabilizer",
		"DirBomb",
		"DirQuarkBaseAccess","DirSupply","DirWeapon","DirAccuracy","DirArmour","DirRepair","DirQuarkBaseAntiGravitor","DirQuarkBaseGravWell","DirQuarkBaseBlackHole","VecProtectHP","VecProtectShield","VecProtectShieldReduce","VecProtectShieldInc","VecProtectInvulnerability2"
	];

	static public const TechDir:Array=[
//Progress 
		DirEmpireMax,		DirShipSpeed,		DirPlanetProtect,		DirShipMassMax,
		DirCaptureSlow,		DirColonyMax,		DirPlanetProtect,		0,
		DirEmpireMax,		0,					DirPlanetProtect,		DirShipMassMax,
		DirEmpireMax,		DirColonyMax,		DirEnclaveMax,			DirShipMassMax,
		DirCaptureSlow,		DirShipSpeed,		DirEnclaveMax,			0,
		DirCaptureSlow,		DirColonyMax,		DirPlanetProtect,		DirShipMassMax,
		DirEmpireMax,		0,					DirEnclaveMax,			0,
		DirCaptureSlow,		DirColonyMax,		DirEnclaveMax,			DirShipMassMax
		,

// Economy
//		DirModuleSpeed,		DirSupplyNormal,	0,						DirResMax,
//		DirModuleMax,		DirSupplyNormal,	DirPlanetLavelCost,		DirResSpeed,
//		DirModuleSpeed,		DirSupplyNormal,	0,						DirResSpeed,
//		DirModuleMax,		DirSupplyNormal,	DirPlanetLavelCost,		DirResMax,
//		DirModuleSpeed,		DirSupplyMuch,		DirCitadelCost,			DirResSpeed,
//		DirModuleMax,		DirSupplyMuch,		DirPlanetLavelCost,		DirResMax,
//		DirModuleMax,		DirSupplyMuch,		DirCitadelCost,			DirResMax,
//		DirModuleSpeed,		DirSupplyMuch,		DirPlanetLavelCost,		DirResSpeed
		0,					0,					0,						0,
		0,					0,					0,						0,
		0,					0,					0,						0,
		0,					0,					0,						0,
		0,					0,					0,						0,
		0,					0,					0,						0,
		0,					0,					0,						0,
		0,					0,					0,						0
		,

// Transport
		DirTransportPrice,	DirTransportCnt,	DirTransportCargo,		DirTransportArmour,
		0,					DirTransportCnt,	DirTransportCargo,		0,
		DirTransportPrice,	DirTransportMass,	0,						DirTransportArmour,
		0,					0,					DirTransportCargo,		DirTransportArmour,
		DirTransportPrice,	DirTransportCnt,	0,						DirTransportWeapon,
		0,					DirTransportCnt,	DirTransportCargo,		0,
		DirTransportPrice,	0,					DirTransportCargo,		DirTransportArmour,
		0,					DirTransportMass,	DirTransportCargo,		DirTransportWeapon
		,
// Corvette
		DirCorvettePrice,	DirCorvetteCnt,		DirCorvetteWeapon,		DirCorvetteArmour,
		0,					DirCorvetteCnt,		DirCorvetteAccuracy,	0,
		DirCorvettePrice,	DirCorvetteMass,	DirCorvetteAccuracy,	DirCorvetteArmour,
		0,					DirCorvetteMass,	DirCorvetteWeapon,		DirCorvetteArmour,
		0,					DirCorvetteCnt,		DirCorvetteAccuracy,	0,
		DirCorvettePrice,	DirCorvetteCnt,		DirCorvetteWeapon,		DirCorvetteArmour,
		DirCorvettePrice,	0,					DirCorvetteAccuracy,	DirCorvetteArmour,
		0,					DirCorvetteStealth,	DirCorvetteAccuracy,	0
		,

// Cruiser
		DirCruiserAccess,	DirCruiserCnt,		DirCruiserAccuracy,		0,
		DirCruiserPrice,	DirCruiserCnt,		DirCruiserWeapon,		DirCruiserArmour,
		0,					DirCruiserMass,		DirCruiserWeapon,		DirCruiserArmour,
		DirCruiserPrice,	DirCruiserMass,		DirCruiserAccuracy,		DirCruiserArmour,
		0,					DirCruiserCnt,		DirCruiserWeapon,		DirCruiserArmour,
		DirCruiserPrice,	DirCruiserCnt,		DirCruiserWeapon,		0,
		DirCruiserPrice,	DirCruiserMass,		DirCruiserAccuracy,		DirCruiserArmour,
		0,					0,					DirCruiserWeapon,		DirCruiserArmour
		,
// Dreadnought
		DirDreadnoughtAccess,	0,						DirDreadnoughtAccuracy,		0,
		DirDreadnoughtPrice,	DirDreadnoughtCnt,		0,							DirDreadnoughtArmour,
		0,						DirDreadnoughtMass,		DirDreadnoughtAccuracy,		DirDreadnoughtArmour,
		DirDreadnoughtPrice,	DirDreadnoughtMass,		DirDreadnoughtAccuracy,		0,
		0,						DirDreadnoughtCnt,		0,							DirDreadnoughtWeapon,
		DirDreadnoughtPrice,	DirDreadnoughtCnt,		0,							DirDreadnoughtWeapon,
		DirDreadnoughtPrice,	DirDreadnoughtCnt,		DirDreadnoughtAccuracy,		DirDreadnoughtArmour,
		0,						0,						DirDreadnoughtAccuracy,		0
		,

// Invader
		DirInvaderPrice,	DirInvaderCnt,		DirInvaderCaptureSpeed,			DirInvaderArmour,
		0,					DirInvaderCnt,		DirInvaderCaptureSpeed,			0,
		DirInvaderPrice,	DirInvaderMass,		0,								DirInvaderArmour,
		0,					DirInvaderMass,		DirInvaderCaptureSpeed,			DirInvaderArmour,
		0,					DirInvaderCnt,		DirInvaderCaptureSpeed,			DirInvaderWeapon,
		DirInvaderPrice,	DirInvaderCnt,		0,								0,
		DirInvaderPrice,	0,					DirInvaderCaptureSpeed,			DirInvaderArmour,
		0,					0,					DirInvaderCaptureSpeed,			DirInvaderWeapon
		,

// Devastator
		DirDevastatorAccess,	0,						DirDevastatorAccuracy,		DirDevastatorBomb,
		DirDevastatorPrice,		DirDevastatorCnt,		DirDevastatorWeapon,		DirDevastatorBomb,
		0,						DirDevastatorMass,		DirDevastatorAccuracy,		DirDevastatorArmour,
		DirDevastatorPrice,		DirDevastatorCnt,		DirDevastatorWeapon,		DirDevastatorBomb,
		0,						DirDevastatorCnt,		DirDevastatorAccuracy,		DirDevastatorArmour,
		DirDevastatorPrice,		DirDevastatorMass,		DirDevastatorAccuracy,		DirDevastatorBomb,
		DirDevastatorPrice,		DirDevastatorCnt,		DirDevastatorWeapon,		DirDevastatorArmour,
		0,						0,						DirDevastatorAccuracy,		DirDevastatorBomb
		,

// WarBase
		DirWarBaseAccess,	DirWarBaseCnt,		0,						0,
		DirWarBasePrice,	0,					DirWarBaseRepair,		DirWarBaseArmour,
		0,					DirWarBaseCnt,		DirWarBaseRepair,		DirWarBaseArmour,
		DirWarBasePrice,	DirWarBaseMass,		DirWarBaseAccuracy,		DirWarBaseArmourAll,
		0,					DirWarBaseMass,		DirWarBaseRepair,		DirWarBaseArmour,
		DirWarBasePrice,	DirWarBaseCnt,		DirWarBaseRepair,		DirWarBaseArmourAll,
		DirWarBasePrice,	DirWarBaseCnt,		DirWarBaseAccuracy,		DirWarBaseArmourAll,
		0,					0,					DirWarBaseAccuracy,		DirWarBaseArmour
		,

// Shipyard
		DirShipyardAccess,		DirShipyardMass,	0,						0,
		DirShipyardPrice,		0,					DirShipyardRepair,		DirShipyardArmour,
		0,						DirShipyardCnt,		DirShipyardRepair,		DirShipyardRepairAll,
		DirShipyardPrice,		DirShipyardMass,	DirShipyardAccuracy,	DirShipyardArmour,
		0,						DirShipyardMass,	DirShipyardRepair,		DirShipyardArmour,
		DirShipyardPrice,		DirShipyardMass,	DirShipyardRepair,		DirShipyardRepairAll,
		DirShipyardPrice,		DirShipyardCnt,		DirShipyardAccuracy,	0,
		0,						0,					DirShipyardAccuracy,	DirShipyardRepairAll
		,

// SciBase
		DirSciBaseAccess,		0,					DirSciBaseRepair,		0,
		DirSciBasePrice,		DirSciBaseCnt,		DirSciBaseRepair,		DirSciBaseArmour,
		0,						DirSciBaseMass,		DirSciBaseAccuracy,		0,
		DirSciBasePrice,		DirSciBaseMass,		DirSciBaseAccuracy,		DirSciBaseArmour,
		0,						DirSciBaseMass,		DirSciBaseRepair,		DirSciBaseArmour,
		DirSciBasePrice,		DirSciBaseMass,		DirSciBaseRepair,		0,
		DirSciBasePrice,		DirSciBaseCnt,		DirSciBaseAccuracy,		0,
		0,						0,					DirSciBaseStabilizer,	0
		,

// QuarkBase
        DirQuarkBaseAccess,     DirQuarkBaseBlackHole,	DirQuarkBaseWeapon,     DirQuarkBaseArmour,
        DirQuarkBaseShieldInc,  DirQuarkBaseHP,         DirQuarkBaseAccuracy,   DirQuarkBaseAntiGravitor,
        DirQuarkBaseShieldInc,  DirQuarkBaseShield,     DirQuarkBaseRepair,     DirQuarkBaseShieldReduce,
        DirQuarkBaseGravWell,   DirQuarkBaseAntiShield,	DirQuarkBaseRepair,     DirQuarkBaseAntiGravitor,
        DirQuarkBaseShieldInc,  DirQuarkBaseHP,     	DirQuarkBaseAccuracy,   DirQuarkBaseAntiGravitor,
        DirQuarkBaseGravWell,   DirQuarkBaseAntiShield, DirQuarkBaseRepair,     DirQuarkBaseShieldReduce,
        0,                      DirQuarkBaseShield,  	DirQuarkBaseWeapon,     DirQuarkBaseArmour,
        DirQuarkBaseGravWell,   DirQuarkBaseAntiShield, DirQuarkBaseBlackHole,	DirQuarkBaseAntiGravitor
	];

	static public const CptSlotMax:int=4;
	static public const CptMax:int=3;
	static public const CptMaxLvl:int=50;
	static public const CptCostTech:int = 400;
	static public const ExpMax:int = 81000000;

    static public const TalentMove:int=0;
	static public const TalentDef:int=1;
	static public const TalentAtc:int=2;
	static public const TalentSys:int=3;
	static public const TalentCnt:int=4;

	static public const VecMoveSpeed:int=1;
//	static public const VecMoveFuel:int=2;
	static public const VecMoveIntercept:int=3;
	static public const VecMoveAccelerator:int=4;
	static public const VecMovePortal:int=5;
	static public const VecMoveRadar:int=6;
	static public const VecMoveCover:int=7;
	static public const VecMoveExchange:int=8;

	static public const VecProtectHP:int=9;
	static public const VecProtectArmour:int=10;
	static public const VecProtectShield:int=11;
	static public const VecProtectShieldInc:int=12;
	static public const VecProtectShieldReduce:int=13;
	static public const VecProtectInvulnerability:int=14;
	static public const VecProtectRepair:int = 15;
	static public const VecProtectAntiExchange:int = 16;

	static public const VecAttackCannon:int=17;
	static public const VecAttackLaser:int=18;
	static public const VecAttackMissile:int=19;
	static public const VecAttackAccuracy:int=20;
	static public const VecAttackMine:int=21;
	static public const VecAttackTransiver:int=22;

	static public const VecSystemSensor:int=25;
	static public const VecSystemStealth:int=26;
	static public const VecSystemRecharge:int=27;
	static public const VecSystemHacker:int=28;
	static public const VecSystemJummer:int=29;
	static public const VecSystemDisintegrator:int=30;
	static public const VecSystemConstructor:int=31;

	static public const VecMoveGravitor:int=33;

	static public const VecCnt:int=34;

	static public const VecImg:Array=["",
		"DirShipSpeed","DirFuel","VecMoveIntercept","VecMoveAccelerator","VecMovePortal","VecMoveRadar","VecMoveCover","VecMoveExchange",
		"VecProtectHP","DirArmour","VecProtectShield","VecProtectShieldInc","VecProtectShieldReduce","VecProtectInvulnerability","DirRepair","VecProtectAntiExchange",
		"DirWeapon","VecAttackLaser","DirMissile","DirAccuracy","VecAttackMine","VecAttackTransiver","","",
		"VecSystemSensor","DirStealth","VecSystemRecharge","VecSystemHacker","VecSystemJummer","VecSystemDisintegrator","VecSystemConstructor","",
		"VecMoveGravitor"
	];
	
	static public const VecProtectAntiExchange_NeedTalent:int = 26;

	static public const TalentVec:Array=[
// Move 
		0,					VecMoveSpeed,			VecMoveGravitor,		0,
		VecMoveCover,		VecMoveAccelerator,		VecMoveGravitor,		VecMovePortal,
		0,					VecMoveIntercept,		VecMoveRadar,			VecMovePortal,
		VecMoveCover,		VecMoveAccelerator,		VecMoveRadar,			0,
		0,					0,						VecMoveRadar,			VecMovePortal,
		VecMoveCover,		VecMoveAccelerator,		VecMoveGravitor,		VecMovePortal,
		0,					VecMoveSpeed,			VecMoveRadar,			VecMovePortal,
		VecMoveCover,		VecMoveAccelerator,		VecMoveRadar,			VecMoveExchange		
		,
// Protect 
		VecProtectHP,		VecProtectShield,			VecProtectArmour,		VecProtectShieldInc,
		VecProtectHP,		VecProtectShield,			VecProtectShieldReduce,	VecProtectRepair,
		VecProtectHP,		VecProtectShield,			VecProtectShieldReduce,	VecProtectRepair,
		0,					VecProtectInvulnerability,	VecProtectArmour,		VecProtectShieldInc,
		VecProtectHP,		VecProtectShield,			VecProtectShieldReduce,	VecProtectRepair,
		VecProtectHP,		VecProtectShield,			VecProtectShieldReduce,	VecProtectRepair,
		VecProtectHP,		VecProtectShield,			VecProtectArmour,		VecProtectShieldInc,
	VecProtectAntiExchange,	VecProtectInvulnerability,	VecProtectArmour,		VecProtectShieldInc
		,
// Attack 
		VecAttackCannon,	VecAttackLaser,		VecAttackMissile,			0,
		0,					VecAttackLaser,		VecAttackMine,				VecAttackAccuracy,
		VecAttackCannon,	0,					VecAttackMissile,			VecAttackAccuracy,
		VecAttackCannon,	VecAttackLaser,		VecAttackMissile,			0,
		0,					VecAttackLaser,		VecAttackMine,				VecAttackAccuracy,
		VecAttackCannon,	0,					VecAttackMissile,			VecAttackAccuracy,
		VecAttackCannon,	VecAttackLaser,		VecAttackMine,				0,
		0,					0,					VecAttackMine,				0
		,
// System
		VecSystemHacker,	VecSystemRecharge,		VecSystemSensor,		VecAttackTransiver,
		VecSystemHacker,	VecSystemRecharge,		VecSystemJummer,		VecSystemConstructor,
		VecSystemHacker,	VecSystemDisintegrator,	VecSystemJummer,		VecSystemConstructor,
		VecSystemStealth,	VecSystemRecharge,		VecSystemSensor,		VecAttackTransiver,
		VecSystemHacker,	VecSystemDisintegrator,	VecSystemJummer,		VecSystemConstructor,
		VecSystemHacker,	VecSystemRecharge,		VecSystemSensor,		VecAttackTransiver,
		VecSystemHacker,	VecSystemDisintegrator,	VecSystemJummer,		VecSystemConstructor,
		VecSystemStealth,	0,						VecSystemSensor,		VecAttackTransiver
	];

	static public const VecMoveSpeedLvl:Array=[75, 100, 125];
//	static public const VecMoveFuelLvl:Array=[20, 40, 100];
	static public const VecMoveInterceptLvl:Array=[0,1];
	static public const VecMoveAcceleratorLvl:Array=[0,20,15,10,5];
	static public const VecMovePortalLvl:Array=[0,1000,2000,3000,4000,5000];
	static public const VecMoveRadarLvl:Array=[0,10,20,30,40,50];
	static public const VecMoveCoverLvl:Array=[0,20,15,10,5];
	static public const VecMoveExchangeLvl:Array=[0,1];

	static public const VecProtectHPLvl:Array=[0,20000,40000,80000,140000,250000,450000];
	static public const VecProtectArmourLvl:Array = [0,13,26,38,51];// [0, 26, 51, 77, 102];
	static public const VecProtectShieldLvl:Array=[0,20000,40000,80000,140000,250000,450000];
	static public const VecProtectShieldIncLvl:Array=[50,200,300,400,600];
	static public const VecProtectShieldReduceLvl:Array = [0, 26, 51, 77, 102];// [0,13,26,38,51];
	static public const VecProtectInvulnerabilityLvl:Array=[0,1,2];
	static public const VecProtectRepairLvl:Array = [0, 200, 400, 600, 800];
	static public const VecProtectAntiExchangeLvl:Array=[0,1];

	static public const VecAttackCannonLvl:Array = [0, 300, 600, 900, 1350, 1800];// [0, 200, 400, 600, 900, 1200];
	static public const VecAttackLaserLvl:Array=[0, 250, 500, 800, 1100, 1400];
	static public const VecAttackMissileLvl:Array=[0, 300, 700, 1100, 1500];
	static public const VecAttackAccuracyLvl:Array=[0,64,128,256,320];
	static public const VecAttackMineLvl:Array=[0,100,500,2000,10000];
	static public const VecAttackTransiverLvl:Array=[0, 300, 500, 700, 1000];

	static public const VecSystemSensorLvl:Array=[0,2,4,6,8];
	static public const VecSystemSensorLvlDestroy:Array = [0, 20, 40, 80, 120];
	static public const VecSystemSensorLvlDetonation:Array = [256, 179, 128, 77, 26];// [256, 218, 179, 141, 102];
	static public const VecSystemStealthLvl:Array=[0,1,2];
	static public const VecSystemRechargeLvl:Array=[0,40000,80000,160000,320000];//[0,20000,40000,80000,160000,320000];
	static public const VecSystemHackerLvl:Array = [0, 1, 2, 4, 6, 8, 10];//[0, 2, 4, 6, 8, 10];
	static public const VecSystemJummerLvl:Array=[0,15,25,35,45];
	static public const VecSystemDisintegratorLvl:Array=[0,13,26,38];
	static public const VecSystemConstructorLvl:Array=[0,40000,80000,160000,320000];

	static public const VecMoveGravitorLvl:Array=[0, 60, 45, 30];
	static public const VecMoveGravitorPeriod:Array = [0, 120, 210, 300];

	static public const VecMoveSpeedDesc:Array=new Array();
//	static public const VecMoveFuelDesc:Array=new Array();
	static public const VecMoveInterceptDesc:Array=new Array();
	static public const VecMoveAcceleratorDesc:Array=new Array();
	static public const VecMovePortalDesc:Array=new Array();
	static public const VecMoveRadarDesc:Array=new Array();
	static public const VecMoveCoverDesc:Array=new Array();
	static public const VecMoveExchangeDesc:Array=new Array();

	static public const VecProtectHPDesc:Array=new Array();
	static public const VecProtectArmourDesc:Array=new Array();
	static public const VecProtectShieldDesc:Array=new Array();
	static public const VecProtectShieldIncDesc:Array=new Array();
	static public const VecProtectShieldReduceDesc:Array=new Array();
	static public const VecProtectInvulnerabilityDesc:Array=new Array();
	static public const VecProtectRepairDesc:Array = new Array();
	static public const VecProtectAntiExchangeDesc:Array=new Array();

	static public const VecAttackCannonDesc:Array=new Array();
	static public const VecAttackLaserDesc:Array=new Array();
	static public const VecAttackMissileDesc:Array=new Array();
	static public const VecAttackAccuracyDesc:Array=new Array();
	static public const VecAttackMineDesc:Array=new Array();
	static public const VecAttackTransiverDesc:Array=new Array();

	static public const VecSystemSensorDesc:Array=new Array();
	static public const VecSystemStealthDesc:Array=new Array();
	static public const VecSystemRechargeDesc:Array=new Array();
	static public const VecSystemHackerDesc:Array=new Array();
	static public const VecSystemJummerDesc:Array=new Array();
	static public const VecSystemDisintegratorDesc:Array=new Array();
	static public const VecSystemConstructorDesc:Array=new Array();

	static public const VecMoveGravitorDesc:Array=new Array();

	//	                                            0       Transport   		Corvette    		Cruiser     		Dreadnought     		Invader     		Devastator				WarBase				Shipyard    		Kling0		Kling1		SciBase				Flagship    ServiceBase,	QuarkBase
	static public const ShipCost:Array=			[   0,      100,        		20,         		100,        		150,            		30,         		300,       				10000,   			10000,				8,			80,			10000,				0,			10000,			4000000];
	static public const ShipCostSDM:Array=		[	0,      10,         		2,         			10,         		15,             		3,          		30,       				1000,       		1000,       		1,          8,          1000,				1000,		1000,			100000];

	static public const ShipCostDir:Array=		[   0,      DirTransportPrice,	DirCorvettePrice,	DirCruiserPrice,	DirDreadnoughtPrice,	DirInvaderPrice,	DirDevastatorPrice,		DirWarBasePrice,   	DirShipyardPrice,	0,			0,			DirSciBasePrice,	0,			0,				0];
	static public const ShipMaxCntDir:Array=	[   0,      DirTransportCnt,	DirCorvetteCnt,		DirCruiserCnt,		DirDreadnoughtCnt,		DirInvaderCnt,		DirDevastatorCnt,    	DirWarBaseCnt,   	DirShipyardCnt,		0,			0,			DirSciBaseCnt,		0,			0,				0];
	//static public const ShipSupplyDir:Array=	[   0,      DirTransportSupply,	DirCorvetteSupply,	DirCruiserSupply,	DirDreadnoughtSupply,	DirInvaderSupply,	DirDevastatorSupply,   	DirWarBaseSupply,  	DirShipyardSupply,	0,			0,			DirSciBaseSupply,	0,			0];
	static public const ShipMassDir:Array=		[   0,      DirTransportMass,	DirCorvetteMass,	DirCruiserMass,		DirDreadnoughtMass,		DirInvaderMass,		DirDevastatorMass,   	DirWarBaseMass,  	DirShipyardMass,	0,			0,			DirSciBaseMass,		0,			0,				0];
//	static public const ShipFuelDir:Array=		[   0,      DirTransportFuel,	DirCorvetteFuel,	DirCruiserFuel,		DirDreadnoughtFuel,		DirInvaderFuel,		DirDevastatorFuel,     	0,  				0,					0,			0,			0,					0,			0,				0];
	static public const ShipArmourDir:Array=	[   0,      DirTransportArmour,	DirCorvetteArmour,	DirCruiserArmour,	DirDreadnoughtArmour,	DirInvaderArmour,	DirDevastatorArmour,    DirWarBaseArmour,  	DirShipyardArmour,	0,			0,			DirSciBaseArmour,	0,			0,				DirQuarkBaseArmour];
	static public const ShipPowerDir:Array=		[   0,      DirTransportWeapon,	DirCorvetteWeapon,	DirCruiserWeapon,	DirDreadnoughtWeapon,	DirInvaderWeapon,	DirDevastatorWeapon,    0,  				0,					0,			0,			0,					0,			0,				DirQuarkBaseWeapon];
	static public const ShipAccuracyDir:Array=	[   0,      0,					DirCorvetteAccuracy,DirCruiserAccuracy,	DirDreadnoughtAccuracy,	0,					DirDevastatorAccuracy,	DirWarBaseAccuracy,	DirShipyardAccuracy,0,			0,			DirSciBaseAccuracy,	0,			0,				DirQuarkBaseAccuracy];
	static public const ShipAccessDir:Array=	[   0,      0,					0,					DirCruiserAccess,	DirDreadnoughtAccess,	0,					DirDevastatorAccess,    DirWarBaseAccess,  	DirShipyardAccess,	0,			0,			DirSciBaseAccess,	0,			0,				DirQuarkBaseAccess];
	static public const ShipRepairDir:Array=	[   0,      0,					0,					0,					0,						0,					0,       				DirWarBaseRepair,  	DirShipyardRepair,	0,			0,			DirSciBaseRepair,	0,			0,				DirQuarkBaseRepair];

	static public const ShipMaxHP:Array =		[   0,      80,					200,        		1000,       		400,            		80,         		100,          			80000,				20000,				100,		5000,		20000,				10000,		20000,			1000000];
	static public const ShipMaxShield:Array=	[   0,      80,					200,        		1000,       		400,            		80,         		100,          			0,					0,					0,			0,			0,					0,			0,				0];
	static public const ShipPower:Array=		[   0,      0,          		3,          		1,          		20,             		0,          		1,	       				500,				200,				3,			10,			200,				500,		200,			10000];
	static public const ShipScore:Array=		[   0,      1,                  1,                  2,                  2,                      1,                  2,                      100,                100,                0,          0,          100,                300,		100,			5000];
//	static public const ShipSupplyA:Array=    	[   0,      0,          		0,          		1,          		8,              		0,          		4,          			5,         			20,					0,			0,			10,					0,			20];
//	static public const ShipSupplyM:Array=    	[   0,      0,          		1,          		3,          		2,              		4,          		2,          			5,         			20,					0,			0,			10,					0,			20];
//	static public const ShipSupplyE:Array=    	[   0,      1,          		0,          		1,          		8,              		0,          		5,          			5,         			20,					0,			0,			10,					0,			20];
//	static public const ShipSupplyS:Array=    	[   0,      8,          		8,          		8,          		8,              		8,          		8,          			6,          		0,					0,			0,			0,					0,			0];
	static public const ShipToBattle:Array =	[   0,      0,                  2,                  7,                  3,                      1,                  3,                      5,                  4,					9,          9,          4,                  6,          4,              5];
	static public const ShipBuildSpeed:Array =	[   0,      -2,          		1,        			3,          		3,             			1,         			3,       				10,					10,					0,			0,			10,					12,			10,				14];
	static public const ShipLowOrbit:Array =	[   false,	true,				false,        		false,          	false,             		false,         		false,       			false,				true,				false,		false,		true,				false,		true,			false];
	static public const ShipAtkMass:Array=		[   false,	false,				true,        		true,          		true,             		true,         		true,       			false,				false,				true,		true,		false,				true,		false,			true];
static public const ShipHitPriorCorvette:Array =[   0,      8,                  5,                  4,                  9,                      7,                  9,                      4,                  8,					2,          1,          8,                  6,          8,              6];

	static public const ShipName:Array=			[	"",		"Transport","Corvette",	"Cruiser",	"Dreadnought",	"Invader",	"Devastator",	"Military base",	"Shipyard", "Kling0", "Kling1", "Scientific base",	"Flagship", "Service base", "Quark base"];
	static public const ShipNameM:Array=		[	"",		"Transport","Corvette",	"Cruiser",	"Dreadnought",	"Invader",	"Devastator",	"Military base",	"Shipyard", "Kling0", "Kling1", "Scientific base",	"Flagship", "Service base", "Quark base"];
	static public const ShipDesc:Array=			[	"",		"Transport","Corvette",	"Cruiser",	"Dreadnought",	"Invader",	"Devastator",	"Military base",	"Shipyard", "Kling0", "Kling1", "Scientific base",	"Flagship", "Service base", "Quark base"];
	static public const ShipNameForCnt:Array=	[	"",		"Transport","Corvette",	"Cruiser",	"Dreadnought",	"Invader",	"Devastator",	"Military base",	"Shipyard", "Kling0", "Kling1", "Scientific base",	"Flagship", "Service base", "Quark base"];

	static public const ItemName:Array=			[	"",		"Module","Armour I","Power I","Repare I","Jump","Build","Fuel","Double","Monuk","Antimatter","Titanium","Electronics","Protoplasm","Nods","Armour II","Power II","Repare II"];
	static public const ItemDesc:Array=			[	"",		"Module","Armour I","Power I","Repare I","Jump","Build","Fuel","Double","Monuk","Antimatter","Titanium","Electronics","Protoplasm","Nods","Armour II","Power II","Repare II"];

	static public const BuildingName:Array =	[	"",		"Energy", "Shield", "Missile", "Terraform", "Storage", "Xenon", "Titan", "Silicon", "Crystal", "Farm", "Electronics", "Metal", "Antimatter", "Plasma", "City", "Module", "Tech", "Fuel", "Power", "Armour", "Droid", "Machinery", "Engineer", "Mine", "Technician", "Navigator"];
	static public const BuildingDesc:Array =	[	"",		"Energy", "Shield", "Missile", "Terraform", "Storage", "Xenon", "Titan", "Silicon", "Crystal", "Farm", "Electronics", "Metal", "Antimatter", "Plasma", "City", "Module", "Tech", "Fuel", "Power", "Armour", "Droid", "Machinery", "Engineer", "Mine", "Technician", "Navigator"];

	static public const TechName:Array =		[	"Progress", "Economy", "Transport", "Corvette", "Cruiser", "Dreadnought", "Invader", "WarBase", "Shipyard", "QuarkBase" ];
	static public const DirName:Array=new Array();
	static public const DirPar:Array=new Array();
	static public const DirParSuf:Array=new Array();
	
	static public const TalentName:Array=		[	"Move", "Protect", "Attack", "System" ];
	static public const VecName:Array=new Array();

	static public const FinalPower:Array=new Array();

	//static public const TxtHyperspaceCotlEdit=3;

	static public const BuildingCityNalog:int = 4;

	static public const BuildingTypeEnergy:uint = 1;		// H!		base
	static public const BuildingTypeLab:uint = 2;			//  		base
	static public const BuildingTypeMissile:uint = 3;		//			base
	static public const BuildingTypeTerraform:uint = 4;		//			base
	static public const BuildingTypeStorage:uint = 5;		// H!		base
	static public const BuildingTypeXenon:uint = 6;			// H!		mining
	static public const BuildingTypeTitan:uint = 7;			// H!		mining
	static public const BuildingTypeSilicon:uint = 8;		// H!		mining
	static public const BuildingTypeCrystal:uint = 9;		// H!		mining
	static public const BuildingTypeFarm:uint = 10;			// H!		refining
	static public const BuildingTypeElectronics:uint = 11;	//			refining
	static public const BuildingTypeMetal:uint = 12;		// H		refining
	static public const BuildingTypeAntimatter:uint = 13;	// H		refining
	static public const BuildingTypePlasma:uint = 14;		// H		refining
	static public const BuildingTypeCity:uint = 15;			// H		live		production
	static public const BuildingTypeModule:uint = 16;		// H		production	production
	static public const BuildingTypeTech:uint = 17;			// H		live		production
	static public const BuildingTypeFuel:uint = 18;			// H		production	production
	static public const BuildingTypePower:uint = 19;		//			equipment
	static public const BuildingTypeArmour:uint = 20;		//			equipment
	static public const BuildingTypeDroid:uint = 21;		//			equipment
	static public const BuildingTypeMachinery:uint = 22;	//			production	supply
	static public const BuildingTypeEngineer:uint = 23;		// H		live		supply
	static public const BuildingTypeMine:uint = 24;			// H		production	production
	static public const BuildingTypeTechnician:uint = 25;	// 			line		pilot
	static public const BuildingTypeNavigator:uint = 26;	// H		live		pilot
	static public const BuildingTypeCnt:uint = 27;

	static public const BuildingLvlCnt:int = 5;

	static public const BuildingCost:Array = [
		0, 0, 0, 0, 0,
		1000,4000,15000, 65000,250000, // Energy
		1000,4000,15000, 65000,250000, // Lab
		1000,4000,15000, 65000,250000, // Missile
		1000,4000,15000, 65000,250000, // Terraform
		500, 2000, 8000, 15000, 65000, // Storage
		500, 2000, 8000, 15000, 65000, // Xenon
		500, 2000, 8000, 15000, 65000, // Titan
		500, 2000, 8000, 15000, 65000, // Silicon
		500, 2000, 8000, 15000, 65000, // Crystal
		1000,4000,15000, 65000,250000, // Farm
		1000,4000,15000, 65000,250000, // Electronics
		1000,4000,15000, 65000,250000, // Metal
		1000,4000,15000, 65000,250000, // Antimatter
		1000,4000,15000, 65000,250000, // Plasma
		1000,4000,15000, 65000,250000, // City
		2000,8000,30000,120000,480000, // Module
		4000,16000,60000,240000,960000, // Tech
		2000,8000,30000,120000,480000, // Fuel
		2000,8000,30000,120000,480000, // Power
		2000,8000,30000,120000,480000, // Armour
		2000,8000,30000,120000,480000, // Droid
		2000,8000,30000,120000,480000, // Machinery
		2000,8000,30000,120000,480000, // Engineer
		2000,8000,30000,120000,480000, // Mine
		2000,8000,30000,120000,480000, // Technician
		2000,8000,30000,120000,480000 // Navigator
	];

	static public const BuildingEnergy:Array = [
		0, 0, 0, 0, 0,
		11,21,32,42,53, // Energy
		-5,-10,-15,-20,-25, // Lab
		-5,-10,-15,-20,-25, // Missile
		-5,-10,-15,-20,-25, // Terraform
		-1,-2,-3, -4, -5, //-1,-2,-4, -8,-16, // Storage
		-5,-10,-15,-20,-25, // Xenon
		-5,-10,-15,-20,-25, // Titan
		-5,-10,-15,-20,-25, // Silicon
		-5,-10,-15,-20,-25, // Crystal
		-5,-10,-15,-20,-25, // Farm
		-5,-10,-15,-20,-25, // Electronics
		-5,-10,-15,-20,-25, // Metal
		-5,-10,-15,-20,-25, // Antimatter
		-5,-10,-15,-20,-25, // Plasma
		-5,-10,-15,-20,-25, // City
		-5,-10,-15,-20,-25, // Module
		-5,-10,-15,-20,-25, // Tech
		-5,-10,-15,-20,-25, // Fuel
		-5,-10,-15,-20,-25, // Power
		-5,-10,-15,-20,-25, // Armour
		-5,-10,-15,-20,-25, // Droid
		-5,-10,-15,-20,-25, // Machinery
		-5,-10,-15,-20,-25, // Engineer
		-5,-10,-15,-20,-25, // Mine
		-5,-10,-15,-20,-25, // Technician
		-5,-10,-15,-20,-25 // Navigator

/*		0, 0, 0, 0, 0,
		4,8,16,32,64, // Energy
		-1,-2,-4,-8,-16, // Shield
		-1,-2,-4,-8,-16, // Missile
		-1,-2,-4,-8,-16, // Terraform
		-1,-2,-4,-8,-16, // Storage
		-1,-2,-4,-8,-16, // Xenon
		-1,-2,-4,-8,-16, // Titan
		-1,-2,-4,-8,-16, // Silicon
		-1,-2,-4,-8,-16, // Crystal
		-1,-2,-4,-8,-16, // Farm
		-1,-2,-4,-8,-16, // Electronics
		-1,-2,-4,-8,-16, // Metal
		-1,-2,-4,-8,-16, // Antimatter
		-1,-2,-4,-8,-16, // Plasma
		-2,-4,-8,-16,-32, // City
		-2,-4,-8,-16,-32, // Module
		-2,-4,-8,-16,-32, // Tech
		-2,-4,-8,-16,-32, // Fuel
		-2,-4,-8,-16,-32, // Power
		-2,-4,-8,-16,-32, // Armour
		-2,-4,-8,-16,-32, // Droid
		-2,-4,-8,-16,-32, // Machinery
		-2,-4,-8,-16,-32, // Engineer
		-2,-4,-8,-16,-32, // Mine
		-2,-4,-8,-16,-32, // Technician
		-2,-4,-8,-16,-32 // Navigator
*/
	];

	static public const BuildingTechLvlCost:Array = [
		0, 0, 0, 0, 0,
		 750,1500, 6000,25000, 95000, // Energy
		 500,1000, 4000,15000, 65000, // Lab
		1000,3000,15000,65000,250000, // Missile
		1000,3000,15000,65000,250000, // Terraform
		 500,1000, 3000,15000, 65000, // Storage
		 500,1000, 4000,15000, 65000, // Xenon
		 500,1000, 4000,15000, 65000, // Titan
		 500,1000, 4000,15000, 65000, // Silicon
		 500,1000, 4000,15000, 65000, // Crystal
		1000,3000,15000,65000,250000, // Farm
		1000,3000,15000,65000,250000, // Electronics
		1000,3000,15000,65000,250000, // Metal
		1000,3000,15000,65000,250000, // Antimatter
		1000,3000,15000,65000,250000, // Plasma
		1000,3000,15000,65000,250000, // City
		1000,3000,15000,65000,250000, // Module
		2000,6000,30000,130000,500000, // Tech
		1000,3000,15000,65000,250000, // Fuel
		1000,3000,15000,65000,250000, // Power
		1000,3000,15000,65000,250000, // Armour
		1000,3000,15000,65000,250000, // Droid
		1000,3000,15000,65000,250000, // Machinery
		1000,3000,15000,65000,250000, // Engineer
		1000,3000,15000,65000,250000, // Mine
		1000,3000,15000,65000,250000, // Technician
		1000,3000,15000,65000,250000 // Navigator
	];

	static public const BuildingItem:Array = new Array();

	static public const ItemBonusArmourCorvette:int = 1;
	static public const ItemBonusArmourCruiser:int = 2;
	static public const ItemBonusArmourDreadnought:int = 3;
	static public const ItemBonusArmourDevastator:int = 4;
	static public const ItemBonusAccuracyCorvette:int = 5;
	static public const ItemBonusAccuracyCruiser:int = 6;
	static public const ItemBonusAccuracyDreadnought:int = 7;
	static public const ItemBonusAccuracyDevastator:int = 8;

	static public const ItemBonusEnergy:int = 16;
	static public const ItemBonusCharge:int = 17;
	static public const ItemBonusChargeMax:int = 18;
	static public const ItemBonusSpeed:int = 19;
	static public const ItemBonusManoeuvrability:int = 20;
	static public const ItemBonusShieldReduce:int = 21;
	static public const ItemBonusShieldMax:int = 22;
	static public const ItemBonusShieldInc:int = 23;
	static public const ItemBonusShieldIncA:int = 24;
	static public const ItemBonusSpeedA:int = 25;
	static public const ItemBonusManoeuvrabilityA:int = 26;
	
	static public const ItemBonusParent:Vector.<int> = new <int>[
	0,//0
	0,//ItemBonusArmourCorvette:int = 1;
	0,//ItemBonusArmourCruiser:int = 2;
	0,//ItemBonusArmourDreadnought:int = 3;
	0,//ItemBonusArmourDevastator:int = 4;
	0,//ItemBonusAccuracyCorvette:int = 5;
	0,//ItemBonusAccuracyCruiser:int = 6;
	0,//ItemBonusAccuracyDreadnought:int = 7;
	0,//ItemBonusAccuracyDevastator:int = 8;
	0,//9
	0,//10
	0,//11
	0,//12
	0,//13
	0,//14
	0,//15
	0,//ItemBonusEnergy:int = 16;
	0,//ItemBonusCharge:int = 17;
	0,//ItemBonusChargeMax:int = 18;
	0,//ItemBonusSpeed:int = 19;
	0,//ItemBonusManoeuvrability:int = 20;
	0,//ItemBonusShieldReduce:int = 21;
	0,//ItemBonusShieldMax:int = 22;
	0,//ItemBonusShieldInc:int = 23;
	ItemBonusShieldInc,//ItemBonusShieldIncA:int = 24;
	ItemBonusSpeed,//ItemBonusSpeedA:int = 25;
	ItemBonusManoeuvrability//ItemBonusManoeuvrabilityA:int = 26;
	];

//	static public const ItemBonusCnt:int = 15;

	static public const UnionTypeAlliance:int = 1;
	static public const UnionTypePirate:int = 2;
	static public const UnionTypeClan:int = 3;
	static public const UnionTypeMercenary:int = 4;
	static public const UnionTypeTrader:int = 5;
	static public const UnionTypeEmpire:int = 6;
	static public const UnionTypeRepublic:int = 7;
	
	static public const ToLink:Vector.<int> = new <int>[
		11, 12, 13, 14, 15,
		26, 10,  8,  9, 16,
		25, 2,  31,  1, 17,
		24, 6,   4,  5, 18,
		23, 22, 21, 20, 19
	];
	
	static public const FromLink:Vector.<int> = new <int>[
		0,0,
		1,0,
		-1,0,
		0,0,
		0,1,
		1,1,
		-1,1,
		0,0,
		0,-1,
		1,-1,
		-1,-1,
		-2,-2,
		-1,-2,
		0,-2,
		1,-2,
		2,-2,
		2,-1,
		2,0,
		2,1,
		2,2,
		1,2,
		0,2,
		-1,2,
		-2,2,
		-2,1,
		-2,0,
		-2,-1,
		0,0,
		0,0,
		0,0,
		0,0,
		0,0
	];
	
	static public const UnionTypeName:Array =	["None", "Альянс", "Пираты", "Клан", "Наемники", "Торговцы", "Империя", "Республика"];

	static public const ItemBonusName:Array =	[];// ["None", "Armour corvette", "Armour cruiser", "Armour dreadnought", "Armour devastator", "Accuracy corvette", "Accuracy cruiser", "Accuracy dreadnought", "Accuracy devastator"];

	static public const TxtMonthForDate:Array = ["января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"];

	static public const News:Object = {
		Export:"Продажа <Cnt> <Goods> по цене <Price> cr за <Step> ед. Созвездие игрока <F> (<FUnion>).",
		Import:"Покупка <Cnt> <Goods> по цене <Price> cr за <Step> ед. Созвездие игрока <F> (<FUnion>).",
		Export2:"Продажа <Cnt> <Goods> по цене <Price> cr за <Step> ед. Созвездие <Cotl>. Игрок <F> (<FUnion>).",
		Import2:"Покупка <Cnt> <Goods> по цене <Price> cr за <Step> ед. Созвездие <Cotl>. Игрок <F> (<FUnion>).",
		CombatBegin:"Нападение <F> (<FUnion>) на <S> (<SUnion>).",
		DuelBegin:"Поединок между <F> (<FUnion>) и <S> (<SUnion>).",
		CombatWinAtk:"<F> (<FUnion>) успешно атаковал <S> (<SUnion>).",
		CombatWinDef:"<S> (<SUnion>) успешно отразил атаку <F> (<FUnion>).",
		CombatBegin2:"Нападение <F> (<FUnion>), <FList> на <S> (<SUnion>), <SList>.",
		DuelBegin2:"Поединок между <F> (<FUnion>), <FList> и <S> (<SUnion>), <SList>.",
		CombatWinAtk2:"<F> (<FUnion>), <FList> успешно атаковали <S> (<SUnion>), <SList>.",
		CombatWinDef2:"<S> (<SUnion>), <SList> успешно отразили атаку <F> (<FUnion>), <FList>.",
		DestroyFlagship1:"<F> (<FUnion>) уничтожил флагман капитана <Name1> (<Lvl1>) игрока <S> (<SUnion>).",
		DestroyFlagship2:"<F> (<FUnion>) уничтожил флагманы капитанов <Name1> (<Lvl1>), <Name2> (<Lvl2>) игрока <S> (<SUnion>).",
		DestroyFlagship3:"<F> (<FUnion>) уничтожил флагманы капитанов <Name1> (<Lvl1>), <Name2> (<Lvl2>), <Name3> (<Lvl3>) игрока <S> (<SUnion>).",
		DestroyQuarkBase:"<F> (<FUnion>) уничтожил разрушитель <S> (<SUnion>).",
		CotlCapture:"Созвездие <Cotl> захвачено игроком <F> (<FUnion>). Получено <Exp> опыта.",
		CotlCtrl:"Альянс <FUnion>, благодаря игроку <F>, установил контроль над созвездием <Cotl>. Получено <Exp> опыта.",
		CotlCtrl2:"Альянс <FUnion>, благодаря игроку <F>, забрал контроль над созвездием <Cotl> у альянса <SUnion>. Получено <Exp> опыта.",
		CotlPrepare:"Через <Period> минут откроется созвездие <Cotl>. Награда за захват: <Exp> опыта.",
		CotlReady:"Открылось созвездие <Cotl>. Награда за захват: <Exp> опыта.",
		HomeworldCapture:"Игрок <F> (<FUnion>) захватил столицу игрока <S> (<SUnion>). Получено <Exp> опыта.",
		Invasion:"Вторжение игрока <F> (<FUnion>) в созвездие игрока <S> (<SUnion>).",
		Battle:"Столкновение между <F> (<FUnion>) и <S> (<SUnion>) в созвездии <Cotl>.",
		Battle2:"Столкновение между <F> (<FUnion>) и <S> (<SUnion>) в созвездии игрока <Cotl>."
	};

	static public const Txt:Object = {
		FormatDate:"<D> <M> <Y>",
		Select:"Выбрать",
		Build:"Построить",
		BuildFlagship:"Построить флагман для",
		Count:"Количество",
		Broken:"Повреждения",
		ItemComplete:"Завершено",
		Price:"Цена",
		Sum:"Сумма",
		Atm:"Атмосфера",
		Tmp:"Температура",
		Tec:"Тектоника",
		CntDestroy:"Уничтоженных",
		Mass:"Масса",
		Fuel:"Топливо",
		Armour:"Броня",
		ShieldReduce:"Рассеивание",
		MaxHP:"Структура",
		MaxShield:"Щит",
		ValShield:"Напряжение",
		IncShield:"Регенерация",
		ValBarrier:"Барьер",
		Damage:"Повреждения",
		Repair:"Ремонт",
		Power:"Ударная сила",
		PowerCannon:"Пушка",
		PowerLaser:"Лазер",
		PowerMissile:"Ракеты",
		PowerTransiver:"Трансивер",
		Accuracy:"Точность",
		Cost:"Стоимость",
		Planet:"Малая планета",
		PlanetLarge:"Обитаемая планета",
		Sun:"Звезда",
		Pulsar:"Пульсар",
		PulsarOn:"Активный",
		PulsarOff:"Пассивный",
		PulsarTimeOn:"Активируется через",
		PulsarTimeOff:"Деактивируется через",
		Gigant:"Газовый гигант",
		PlanetTini:"Карликовая планета",
		PlanetRich:"Радужный мир",
		Radiation:"Радиация",
		RadiationLow:"Слабая радиация",
		ThreatSun:"Радиационная угроза",
		ThreatGigant:"Астероидная угроза",
		ThreatTini:"Астероидная угроза",
		Wormhole:"Червоточина",
		WormholeRoam:"Блуждающая червоточина",
		WormholePrepare:"Стабилизируется",
		WormholeOpen:"Стабилизирована",
		WormholeClose:"Дестабилизирована",
		WormholeOpenTime:"Время до открытия",
		WormholeCloseTime:"Время до закрытия",
		Module:"Модули",
		Res:"Модули",
		ResInc:"Объем производства",//"Строительство",
		BuildItem:"Специализация",//"Производство",
		Level:"Инфраструктура",
		PlanetRefuel:"Пополнение топлива", 
		PlanetNoCapture:"(Захват невозможен)", 
		PlanetNoMove:"(Перелет невозможен)", 
		Cancel:"Отменить",
		Max:"MAX",
		Homeworld:"Столица",
		Citadel:"Цитадель",
		Empire:"Империя",
		Enclave:"Анклав",
		Colony:"Колония",
		Base:"База",
		District:"Сфера",
		Outpost:"Форпост",
		DistrictPlanetCnt:"Планет в вашей сфере",
		MaxEnclaveTarget:"Цель: Захват <Val>% планет.",
		MaxEnclaveTime:"До окончания",
		OccupyHomeworldTime:"Прикрытие",
		NewHomeworld:"Столица империи",
		Phantom:"Фантом",
		MiniMapLarge:"Большая карта",
		MiniMapSmall:"Малая карта",
		MiniMapPlanet:"Планеты",
		MiniMapShowPlanet:"Отобразить планеты",
		MiniMapHidePlanet:"Скрыть планеты",
		MiniMapShip:"Корабли",
		MiniMapShowShip:"Отобразить корабли",
		MiniMapHideShip:"Скрыть корабли",
		MiniMapScaleDefault:"Масштаб по умолчанию",
		MiniMapRes:"Ресурсы",
		MiniMapAllShip:"Все корабли",
		MiniMapPlayerShip:"Корабли игрока",
		FormMiniMapWormholes:"Червоточины",
		FormMiniMapGravitor:"Гравиторы",
		FormMiniMapColony:"Колонии",
		FormMiniMapMine:"Мины",
		FormMiniMapNoCapture:"Нельзя захватывать",
		Owner:"Владелец",
		Load:"Загрузка",
		Neutral:"Нейтральная",
		User:"Игрок",
		RewardExp:"Награда за захват",
		Exp:"опыта",
		UserPlanetCnt:"Всего планет",
		EmpirePlanetCnt:"Планет в империи",
		EnclavePlanetCnt:"Планет в анклаве",
		ColonyPlanetCnt:"Планет в колониях",
		GravitorSciCnt:"Научных гравиторов",
		StatMineCnt:"Заминированных слотов",
		UserShipCnt:"Всего кораблей",
		UserShipMassDefMax:"Предельная масса обороны",
		UserShipMassDef:"Масса обороны",
		UserShipMassAtkMax:"Предельная масса нападения",
		UserShipMassAtk:"Масса нападения",
		UserRating:"Рейтинг развития",
		CombatRating:"Боевой рейтинг",
		UserScore:"Боевая слава",
		UserRest:"Очки отдыха",
		UserExp:"Очки опыта",
		UserKlingDestroyCnt:"Клисан уничтожено",
		Stat:"Статистика",
		//StatUpdateTime:"Расчет и Статистика обновляются раз в минуту.",
		StatUpdateTime:"Расчет и обновление статистики происходит раз в минуту.",
		MsgNewEmpire:"<p align='center'><font color='#ff0000'>ВНИМАНИЕ!</font> Старая империя будет уничтожена. Вы действительно хотите основать новую империю?</p>",
		ButFind:"Найти",
		ButClose:"Закрыть",
		ButCancel:"Отменить",
		ButChange:"Обменять",
		ButSave:"Сохранить",
		RandomFon:"Случайный",
		Split:"Распределить",
		ButRes:"Ресурсы",
		ButTech:"Технологии",
		ButGive:"Снарядить",
		ButDestroy:"Взорвать",
		ButDestroyPlanet:"Взорвать планетоид",
		QueryDestroyPlanet:"[justify]Вы можете взорвать планетоид в своем созвездии в том случае, если планеты не образуют отдельной группы. Невозможно взорвать пульсар и червоточину. Вместе с уничтожением планетоида, будут уничтожены все постройки, корабли, товары.[br]Стоимость операции <Cost> cr. и <QC> кварковых ядер размещённых на орбите в трюме транспорта. [br][br]Вы уверены, что хотите взорвать планетоид?[/justify]",
		ButExtract:"Собирать: Водород",
		ButPolar:"Поляризация щита (E)",
		ButPolar2:"Поляризация щита",
		ButTransiver:"Трансиверный лазер (E)",
		ButSiege:"Осадный режим (E)",
		ButNanits:"Наниты (E)",
		ButNoToBattle:"Походный режим (Q)",
		ButAIRoute:"Следовать маршруту (C)", 
		ButAIAttack:"Атаковать (Z)",
		ButLink:"Цель (X)",
		AutoBuild:"Автоматическая постройка",
		ButBomb:"Аннигиляция",
		ButSetBlasting:"Заминировать",
		ButClearBlasting:"Разминировать",
		ButRecharge:"Зарядник - Восстановить щиты",
		ButConstructor:"Конструктор - Восстановить структуру",
		ButInvu:"Протонный щит",
		ButGravitor:"Гравитор",
		ButGravitorOn:"Активировать гравитор", 
		ButGravitorOff:"Деактивировать гравитор", 
		ButGravitorSci:"Научный гравитор",
		ButGravitorFlagship:"Флагманский гравитор",
		ButEject:"Перебросить флот",
		ButMine:"Устанавливать мины",
		ButMineDestroy:"Подорвать мины",
		ButMineDestroyQuery:"Вы уверены, что хотите подорвать мины на этой орбите этой планеты?",
		ButTransition:"Квантовый переход (E)",
		ButBarrier:"Освободить барьер (E)",
		ButExchange:"Квантовый переход",
		ButCancelBuild:"Отменить постройку",
		ButLeave:"Покинуть планету",
		ButDestroyEmpire:"Уничтожить империю",
		ButChangeRace:"Сменить столицу и расу",
		DestroyEmpireQuery:"Для уничтожения империи введите слово 'DELETE'",
		DestroyEmpireCom:"При уничтожении империи теряются одна технология в каждой ветке.\nИмперию нельзя уничтожить, если в созвездии есть враг.",
		DestroyEmpire:"Уничтожить",
		ButLoad:"Загрузить модули",
		ButUnloadModule:"Выгрузить модули",
		ButUnload:"Выгрузить",
		ButSack:"Грабить модули",
		ButRefuel:"Заправить",
		ButDropEq:"Выбросить оборудование",
		JumpWormhole:"На другую сторону червоточины (пробел)",
		Eq:"Оборудование",
		FormResCaption:"Ресурсы империи",
		FormResItemBuildQuery:"Вы действительно хотите создать оборудование ?",
		StatResCnt:"В наличии",
		StatResInc:"Приход",
		StatResDec:"Снабжение",
		BonusPower:"Ударная сила",
		BonusArmour:"Броня",
		BonusRepair:"Ремонт",
		MinePower:"Урон",
		ChangeFrom:"Обменять",
		ChangeTo:"на",
		OpComplate:"Операция успешно выполнена.",
		ResSupplyNone:"отсутствует",
		ResSupplyLow:"низкое",
		ResSupplyNormal:"нормальное",
		ResSupplyH:"высокое",
		BuildTime:"Построится через",
		PortalTime:"До перехода через портал",
		EjectTime:"До переброски",
		BombTime:"Аннигиляция через",
		BlastingTime:"Подрыв через",
		ButPlusar:"Инжекторы",
		ButBase:"Основать базу",
		QueryBase:"База - это центр вашей территории в данном созвездии. Для основания базы требуется [clr]<Val>[/clr] cr.[br][br]Вы действительно хотите основать базу на этой планете?",
		ButCitadel:"Основать цитадель",
		QueryCitadel:"Цитадель - это центр вашего анклава за пределами империи. Для основания цитадели требуется [clr]<Val>[/clr] cr.[br][br]Вы действительно хотите основать цитадель на этой планете?",
		ButStabilizerOn:"Включить стабилизатор",
		ButStabilizerOff:"Выключить стабилизатор",
		ButWormhole:"Открыть червоточину",
		ErrorOpenWormhole:"Чтобы открыть червоточину нужно соблюдение нескольких условий:[br]- В радиусе перехода от планеты с научной станцией должно быть свободное место.[br]- Червоточина открывается взамен существующей не стабилизированной червоточины.[br]- В созвездии не должно быть вражеских кораблей.[br]- Расстояние между выходами червоточины не должно быть менее 5 секторов. [br]- Стоимость открытия равна 200 000 ед. протоплазмы, которая должна находиться на одной из планет.",
		ButPortalOn:"Активировать портал",
		ButPortalHyperOn:"Активировать гипер-портал",
		ButPortalOff:"Деактивировать портал",
		ButPortalJump:"На другую сторону портала (пробел)",
		ButPortalHyperJump:"На другую сторону гипер-портала (пробел)",
		ButPortalGo:"Начать переход через портал (~)",
		ButPortalCancel:"Отменить переход через портал (~)",
		PortalNoTech:"Чтобы использовать портал у вас должен быть активирован инжектор науки или контроля.",
		TechPortalNoPlusar:"Переход возможен только при активном\nинжекторе науки или контроля.",
		TechAntiExchangeNeed:"Для изучения требуется 26 защитных технологий.",
		StabilizerQuery:"Стабилизатор предназначен для предотвращения закрытия червоточин в радиусе одного перелета. [br][br]Вы действительно хотите включить стабилизатор?",
		ToCotlMenu:"Созвездие игрока",
		PactMenu:"Договор",
		PactWar:"Объявить о нападении",
		PactCaption:"Договор между <font color='#ffff00'><You></font> и <font color='#ffff00'><User></font>",
		PactCaptionQuery:"Игрок <font color='#ffff00'><User></font> предлагает заключить договор",
		PactYouCaption:"Вы обязуетесь",
		PactOtherCaption:"Противоположная сторона обязуется",
		PactYouPass:"Мирно пропускать корабли противоположной стороны на свою территорию.",
		PactOtherPass:"Мирно пропускать Ваши корабли на свою территорию.",
		PactYouNoFly:"Не летать на территорию противоположной стороны.",
		PactOtherNoFly:"Не летать на вашу территорию.",
		PactYouNoBattle:"Не вести бой с противоположной стороной вне своих территорий.",
		PactOtherNoBattle:"Не вести бой с Вами вне своих территорий.",
		PactYouPay:"Платить противоположной стороне от добычи",
		PactOtherPay:"Платить вам от добычи",
		PactYouProtect:"Защищать противоположную сторону и получать оплату за успешную оборону.",
		PactOtherProtect:"Защищать Вас и получать оплату за успешную оборону.",
		PactYouControl:"Разрешить противоположной стороне управлять вашими кораблями.",
		PactOtherControl:"Разрешить Вам управлять кораблями противоположной стороны.",
		PactYouBuild:"Разрешить противоположной стороне строить ваши корабли и инфраструктуру планет.",
		PactOtherBuild:"Разрешить Вам строить у противоположной стороны корабли и инфраструктуру планет.",
		PactAntimatter:"Антиматерии",
		PactMetal:"Металла",
		PactElectronics:"Электроники",
		PactProtoplasm:"Протоплазмы",
		PactNodes:"Нодов",
		PactPeriod:"Продолжительность",
		PactHour:"дней",
		PactOffer:"Предложить",
		PactBreak:"Расторгнуть",
		PactReject:"Отклонить",
		PactAccept:"Принять",
		PactListBut:"Договора", 
		PactListCaption:"Список договоров",
		PactListName:"Игрок",
		PactListUnion:"Альянс",
		PactListDate:"До окончания",
		PactListRes:"Ресурсы",
		Cpt:"Капитан",
		CptAll:"Ваши капитаны",
		CptNew:"Новый капитан",
		CptReplace:"Заменить капитана",
		CptDelete:"Уволить капитана",
		CptTalent:"Технологии флагмана",
		CptEq:"Оборудование флагмана",
		CptDeleteQuery:'Чтобы уволить капитана "<Name>" введите слово "DELETE":',
		//CptDeleteWarning:"[crt]ВНИМАНИЕ ![/crt] При удалении будет потерян весь опыт, потраченный на[br]изучение технологий капитана. Если вы хотите сохранить опыт, вам нужно сначала[br]взять перераспределение технологий, затем разучить технологии удаляемого[br]капитана и только затем удалить капитана.",
		CptDeleteWarning:"[justify][crt]ВНИМАНИЕ ![/crt] При увольнении будет потерян весь опыт, потраченный на изучение технологий капитана. Если вы хотите сохранить опыт, вам нужно сначала взять перераспределение технологий, затем разучить технологии увольняемого капитана и только затем уволить капитана.[/justify]",
		CptDeleteBut:"УВОЛИТЬ",
		CptNoMore:"Вы не можете иметь больше 4 капитанов.",
		CptNoChangeExistFlagship:"Вы не можете поменять капитана, так как у данного есть флагман.",

		FormDialogMaxQuest:"У вас на выполнение придельное количество квестов. Вы не можете взять больше.",

		FormBattleSearchBut:"В бой!",
		FormBattleBar1:"1x1",
		FormBattleBar2:"2x2",
		FormBattleBarFlagship:"С флагманами",
		FormBattleSearch:"Поиск <Val>...",
		FormBattleCombat:"Битва <Val>...",
		FormBattleDuel:"Поединок ...",
		FormBattleSearchNoFlagship:"[crt]ВНИМАНИЕ ![/crt] При битве с флагманами во флоте должны находиться флагманы.",
		FormBattleSearchNoMass:"[crt]ВНИМАНИЕ ![/crt] Для битвы вы должны иметь во флоте не менее [clr]300 000[/clr] кт массы кораблей.",
		FormBattleWaitCnt:"Игроков в очереди",
		FormBattleWaitNeedCnt:"[crt]Не хватает игроков.[/crt]",
		FormBattleWaitEnd:"До начала поиска",

		FormPlusarButReplenish:"ПОПОЛНИТЬ",
		FormPlusarCaption:"ИНЖЕКТОР",
		FormPlusarModulePage:"производства",
		FormPlusarModuleCaption:"Инжектор производства",
		FormPlusarModuleText:"[justify][p]Во время действия данного инжектора объем производства товаров финального цикла (деньги - cr, модули, топливо, оборудование, инженеры, пилоты и т.д.) увеличивается на 50%.[/p][/justify][br]Продолжительность: [clr]7[/clr] дней", 
		FormPlusarModuleQuery:"Вы действительно хотите активировать инжектор производства?",
		FormPlusarModuleQuery2:"Вы действительно хотите продлить инжектор производства?",
		FormPlusarCaptainPage:"капитанов",
		FormPlusarCaptainCaption:"Инжектор капитанов",
		FormPlusarCaptainText:"[justify][p]При активации данного инжектора Вы можете иметь сразу 3 флагмана. Дополнительно Вы получаете удвоенный приход очков опыта.[/p][/justify][br]Продолжительность: [clr]7[/clr] дней", 
		FormPlusarCaptainQuery:"Вы действительно хотите активировать инжектор капитанов?",
		FormPlusarCaptainQuery2:"Вы действительно хотите продлить инжектор капитанов?",
		FormPlusarTechPage:"науки",
		FormPlusarTechCaption:"Инжектор науки",
		FormPlusarTechText:"[justify][p]При активации инжектор позволяет изучать технологии дальше 4 уровня, ускоряет ход исследований в 3 раза, увеличивает продолжительность работы глобального планетарного щита на 2 часа, дает возможность ставить в очередь изучение вторую технологию, а также разрешает кораблям проходить через портал.[/p][/justify][br]Продолжительность: [clr]7[/clr] дней",
		FormPlusarTechQuery:"Вы действительно хотите активировать инжектор науки?",
		FormPlusarTechQuery2:"Вы действительно хотите продлить инжектор науки?",
		FormPlusarControlPage:"контроля",
		FormPlusarControlCaption:"Инжектор контроля",
		FormPlusarControlText:"[justify][p]Комплексный инжектор, в который входят инжекторы производства, капитанов и науки. Инжектор, за одинаковый промежуток времени, стоит дешевле на [clr]<Val>%[/clr] чем его составляющие вместе взятые.[/p][p]При продлении любого инжектора (до истечения срока его работы), применяется накопительная скидка.[/p][/justify][br]Продолжительность: [clr]30[/clr] дней", 
		FormPlusarControlQuery:"Вы действительно хотите активировать инжектор контроля?",
		FormPlusarControlQuery2:"Вы действительно хотите продлить инжектор контроля?",
		FormPlusarCost:"Стоимость активации: [clr]<Val>[/clr] egm",
		FormPlusarCost2:"Стоимость продления: [clr]<Val>[/clr] egm с учетом скидки в [clr]<Discount>%[/clr].",
		FormPlusarEGM:"На вашем счету [clr]<Val>[/clr] egm.",
		FormPlusarButOn:"АКТИВИРОВАТЬ",
		FormPlusarButProlong:"ПРОДЛИТЬ",
		FormPulsarPlusarOn:"[crt]Инжектор активирован.[/crt] До завершения",
		NoEnoughEGM:"На вашем счете не хватает egm для активации инжектора.",
		NoEnoughEGM2:"На вашем счете не хватает egm.",
		NoEnoughMoney:"Не хватает денег (cr).",
		NoEnoughRes:"Не хватает товара.",
		NoEnoughModule:"Не хватает модулей.",
		ErrOverload:"Операция отклонена в связи с переполнением ангаров!",
		ErrData:"Ошибка в данных",
		AIGameSet:"Поведение компьютерной империи",
		AIGameSetTransportNet:"Автоматическая транспортная сеть",
		AIGameSetTransport:"Транспорты для перевозки грузов",
		AIGameSetDefence:"Постройка обороны",
		ErrNoHomeworld:"Торговля не возможна, так как нет столицы.",
		ButPlanetShield:"Активировать планетарный щит",
		ButPlanetShieldOff:"Деактивировать планетарный щит",
		PlusarPlanetShield:
		"<p align='justify'>Активированный планетарный щит поглощает энергию кораблей, тем самым замедляя скорость боя и захват планет. В первый час активации щит работает на полной мощности. При этом он замедляет бой в 100 раз. Каждый следующий час эффективность щита падает, что ведет к увеличению скорости боя на 2%. После 48 часов щит автоматически отключается. Щит никак не влияет, если бой идет не между игроками. Если на орбите планеты идет битва, то щит потребляет при полной нагрузке 15000 модулей в час. </p>\n" + 
		"Стоимость: <font color='#ffff00'>200</font> egm.\n\n" + 
		"Вы действительно хотите активировать планетарный щит?",
		PlusarPlanetShieldOff:
		"На деактивацию планетарного щита уходит 30 минут.\n"+
		"Вы действительно хотите деактивировать планетарный щит?",
		ShildPower:"Планетарный щит",
		DeactivateShieldTime:"Деактивация через",
		DeactivateShieldTimeFull:"Деактивация планетарного щита",
		GlobalShieldFrom:"Планетарный щит через",
		GloablShieldCooldown:"Восстановление щита",
		LocalShieldVal:"Планетарный щит анклава",
		LocalShieldAtk:"Угроза",
		LocalShieldEnd:"Деактивация через",
		FormTechCaption:"Технологии империи",
		NextLvl:"Следующий уровень",
		TechCostLvl:"Стоимость",
		TechNoRes:"У вас не хватает ресурсов для изучения выбранной технологии.",
		TechResearch:"Изучается",
		TechProgress:"\n        Исследовано <font color='#ffff00'><Val></font> из <font color='#ffff00'><Max></font>. Скорость <font color='#ffff00'><Speed></font> ед. в час.\n        До завершения осталось <font color='#ffff00'><Time></font> минут.",
		TechResearchNext:"Следующая",
		TechResearchNoMore:"Чтобы получить доступ к возможности задавать две технологии для изучения, вам надо активировать инжектор науки или контроля.",
		TechNeedPrev:"Чтобы изучить данную технологию вы должны сначала изучить 2 технологии в вышестоящем ряду.",
		TechNeedCadet:"Технологии 3 уровня можно изучить, только если вы достигли звания кадет.",
		TechNeedPlusar:"Технологии начиная с 4 уровня можно изучить, только если активирован инжектор науки или контроля.",
		TechUnResearchQuery:"Вы уверены, что хотите уничтожить технологию?",
		TechShowFullList:"Ctrl - посмотреть все неизученные уровни технологии.",
		TechGravWell:"[clr]Гравитационный колодец[/clr] - не позволяет покинуть планету любому звену кораблей в течении [clr]5[/clr] минут. Закрывает все порталы и блокирует их открытие.",
		TechBlackHole:"[clr]Черная дыра[/clr] - мгновенно поглощает звено кораблей. Не действует на разрушители.",
		InfoAntiGravitor:"Гравитационный стабилизатор",
		InfoGravWell:"Гравитационный колодец",
		InfoBlackHole:"Черная дыра",
		InfoAntiShield:"Инвариатор",
		CooldownAntiGravitor:"До гравитационного стабилизатора",
		CooldownGravWell:"До гравитационного колодца",
		CooldownBlackHole:"До черной дыры",
		CooldownAntiShield:"До инвариатора",
		GravWellOff:"До окончания гравитационного колодца",
		PotentialOff:"До окончания гравитационного потенциала",
		ReloadReactor:"Перезагрузка реактора",
		TalentCaption:"Технологии флагмана",
		TalentCpt:"Капитан",
		InvuOff:"До деактивации протонного щита",
		InvuOn:"До готовности протонного щита",
		RechargeOn:"До восстановления зарядника",
		ConstructorOn:"До восстановления конструктора",
		GravitorOff:"До деактивации гравитора",
		GravitorPrepare:"До активации научного гравитора", 
		GravitorOn:"До готовности гравитора",
		GravitorAccess:"До гравитора",
		AcceleratorOn:"До ускорения",
		CoverOn:"До прикрытия",
		ExchangeOn:"До готовности квантового перехода",
		BarrierOn:"До возможности освободить барьер",
		PortalOn:"До готовности активации портала",
		PortalCnt:"Осталось кораблей до деактивации портала",
//		PortalInfo:"Игроком [clr]<User>[/clr] установлен портал.",
//		PortalInfoFlagship:"Игроком [clr]<User>[/clr] установлен флагманский портал.",
//		PortalInfoHyperspace:"Игроком [clr]<User>[/clr] установлен гипер-портал.",
		PortalInfo:"Портал",
		PortalInfoFlagship:"Флагманский портал",
		PortalInfoHyperspace:"Гипер-портал",
		PortalInfoHyperspaceCotlOther:"в созвездие <Name>",
		PortalInfoHyperspaceCotlUser:"в созвездие игрока <Name>",
		
		SupplyByPact:"По договорам",
		OutControl:"Вне контроля",
		Occupy:"Оккупирована",
		SDMMax:"Макс. очки развития",
		SDM:"Остаток очков развития",
		BuildSDM:"Строить корабли за sdm",
		MulTime:"Мультипликатор",
		CurrencyModule:"модули",
		CurrencySDM:"sdm",
		FormSetCaption:"НАСТРОЙКИ",
		SetBut:"Настройки",
		HourPlanetShield:"Час активации планетарных щитов",
		
		FormSetHourPlanetShield:"- час активации планетарных щитов.",
		FormSetAccessKey:"- код доступа.",
		FormSetHint:"подсказки.",
		FormSetFPS:"отображение FPS.",
		FormSetFPSMax:"- максимальный FPS",
		FormSetScopeVis:"границы видимости.",
		FormSetUnprintable:"Фильтр нецензурной лексики",
		FormSetTabGame:"игра",
		FormSetTabGraph:"графика",
		FormSetFon:"отображение фона.",
		FormSetShieldPercent:"отдельное отображение числовых процентов щита.",
		FormSetButSave:"СОХРАНИТЬ",
		FormSetButFon:"ФОН",
		FormSetButFlashSettings:"FLASH",
		FormSetButFlashSettings2:"FLASH 2",
		
//		SetACCaption:"Если напали на планету с военной базой, то автоматически включать планетарный щит на:",
//		SetACEmpire:"планете империи",
//		SetACEnclave:"планете анклава",
//		SetACColony:"планете колонии",
//		SetACTail:"Стоимость каждого включения 200 egm.",
//		SetSimpleBattle:"Упрощенное отображение боя",
//		SetFon:"Фон",
//		SetGrid:"Сектора",
//		SetVis:"Границы видимости",
//		SetModule:"Отображение модулей",
//		SetInfo:"Отображение дополнительной информации",
//		SetShipType:"Корабли",
//		SetShipTypeVector:"Векторные",
//		SetShipTypeSprite:"Спрайтовые",
//		SetShipTypeSpriteS3:"Спрайтовые со сглаживанием",

		PortalCaption:"Портал",
		PortalSector:"Сектор",
		PortalSet:"Установить",
		AdviserBut:"Советник",
		EmpireDestroyTime:"Осталось до распада империи",
		RestartTime:"Осталось до рестарта созвездия",
		PrepareTime:"Осталось до готовности созвездия",
		GalaxyMapClanIcon:"Иконки альянсов",
		GalaxyMapCurBattle:"Текущие битвы",
		CotlDef:"В защите",
		CotlAtk:"В атаке",
		CotlCaptureAndControl:"Захватить и установить контроль", 
		CotlCapture:"Захватить созвездие",
		CotlCaptureQuery:"Вы уверены, что хотите захватить созвездие?",
		CotlCaptureNextHour:"Час открытия",
		CotlBuyControl:"Установить контроль", 
		CotlBuyControlQuery:"Вы уверены, что хотите установить контроль над созвездием за [clr]<Price> <Val>[/clr]?", 
		CotlBuyControlQueryPlusEgm:"Вы уверены, что хотите установить контроль над созвездием за [clr]<Price> <Val>[/clr]  и  [clr]<PriceEGM> egm[/clr]?", 
		CotlPrice:"За [clr]<Price> <Val>[/clr] возможно установить контроль над созвездием.", 
		CotlPriceEgm:"За [clr]<Price> <Val>[/clr] и [clr]<PriceEGM> egm[/clr] возможно установить контроль над созвездием.",  //  Что поднимает следующие параметры:
		CotlSessionContinue:"От старта",
		CotlSessionEnd:"До завершения",
		CotlSessionBegin:"До старта",
		SessionEnd:"До окончания игры",
		SessionBegin:"До начала игры",
		RaceChangeCooldown:"Вы можете сменить столицу и расу через: <Val>",
		NewBaseCooldown:"Вы можете создать базу в этом созвездии через: <Val>",
		NewCitadelCooldown:"Вы можете основать цитадель в этом созвездии через: <Val>",
		NewCitadelMax:"Нельзя иметь больше 5 цитаделей.",
		NewEmpireCooldown:"Вы можете создать новую империю через: <Val>",
		
		FormNewCptCaption:"НОВЫЙ КАПИТАН",
		FormNewCptReplaceCaption:"ЗАМЕНА КАПИТАНА",
		FormNewCptDeleteCaption:"УВОЛИТЬ КАПИТАНА",
		FormNewCptName:"Имя",
		//FormNewCptNameEng:"Имя латиницей",
		FormNewCptRace:"Раса",
		FormNewCptButReplace:"ЗАМЕНИТЬ",
		FormNewCptButOk:"НАНЯТЬ",
		FormNewCptButCancel:"ОТКАЗАТЬСЯ",

		CptMaxLvl:"Вы уже достигли максимального [clr]<Val>[/clr] уровня технологий капитана.",
		CptNoExpForTech:"Вам не хватает [clr]<Val>[/clr] очков опыта, чтобы изучить технологию.",
		CptLvl:"Уровень",
		Exp:"Опыт",
//		ShipExp:"Владелец обладает <font color='#BfBf00'><Rest></font> очками отдыха.\nЕсли вы уничтожите эти корабли, то\nзаработаете <font color='#BfBf00'><Exp></font> очков опыта.",
		ShipExp:"Если вы уничтожите эти корабли, то заработаете [clr]<Exp>[/clr] очков опыта.",
		FlagshipExp:"Если вы уничтожите этот флагман, то заработаете <font color='#BfBf00'><Exp></font> очков опыта.", 
		MobExp:"Если вы уничтожите эти корабли, то заработаете <font color='#BfBf00'><Exp></font> очков опыта.",
		UnknowExp:"Невозможно рассчитать получаемый вами опыт при уничтожении  этих кораблей.",
//		NoExp:"У владельца нет очков отдыха, поэтому уничтожение этих кораблей не принесет\nочков опыта.",
		CostExp:"Стоимость изучения новой технологии <font color='#ffff00'><Cost></font> очков опыта.\nУ вас имеется <font color='#ffff00'><Exp></font> очков опыта.",
		FleetUser:"Флот игрока",
		CotlRich:"Центральное созвездие",
		CotlUser:"Созвездие игрока",
		CotlOccupancy:"Занятость созвездия",
		CotlProtect:"Под защитой",
		CotlProtectTime:"До окончания защиты",
		CotlProtectPermanent:"Под постоянной защитой",
//		FleetToHyperspace:"В гиперпространство",
		FlagshipPowerDec:"Мощность флагманов",
		FlagshipPowerDecShort:"Мощность",
		SoundChannel:"Радио канал", 
		SoundVol:"Громкость", 
		SoundOn:"Включить радио канал", 
		SoundOff:"Выключить радио канал", 
		SoundLoadPls:"Загрузить список каналов...", 
		ItemBonusEndTime:"До завершения",
		FindUser:"Найти",
		FindCotlKeyword:"созвездие",
		FindImportKeyword:"импорт",
		FindExportKeyword:"экспорт",
		FleetCaption:"Флот",
		FleetDesc:"Флот под командованием капитана предназначен\nдля операций в других созвездиях.",
		FleetCpt:"Корабли входят во флот капитана",
		FleetOut:"Корабли вне флота",
		FleetNew:"Флагман образует ядро флота",
		FleetArrival:"Время до прибытия",
		FleetGroupCnt:"Звеньев",
		FleetIn:"Во флоте капитана",
		FleetMoveError:"Перелет флота запрещен согласно параграфу #<Val>.",
		FleetMoveErrorNoReady:"Корабли флота не готовы к гиперпереходу.",
		FleetMoveErrorBattle:"Корабли флота не могут покинуть орбиту боя.",
		FleetMoveErrorNoShip:"Нет кораблей во флоте.",
		FleetMoveErrorNoFlagship:"Нет флагмана во флоте.",
		FleetMoveErrorMuch:"На орбите планеты слишком много ваших кораблей.",
		FormRaceCaption:"Раса империи",
		FormRaceCaption2:"Выберите расу для новой империи:",
		FormRaceCaption2Pay:"Выберете расу для империи:",
		FormRaceWarningDestroy:"[crt]ВНИМАНИЕ![/crt] У вас уже есть империя. При основании новой столицы старая империя будет уничтожена.",
		FormRaceWarningPay:"[crt]ВНИМАНИЕ![/crt] Стоимость смены расы без уничтожения империи равна [clr]<Val>[/clr] egm.",
		FormRaceButOk:"Основать",
		FormRaceButOkPay:"Сменить",
		FormRaceWarningWait:"Раса сменится через несколько секунд.",
		FormRaceShip:"Корабли",
		FormRaseFeatures:"Особенности",
		FormRaseFeaturesGrantar:
			 "- Структура кораблей на 60% больше.[br]"
			+"- Девастаторы аннигилируют быстрее и наносят вражеским кораблям дополнительно 100% урона.[br]",
		FormRaseFeaturesPeleng:
			 "- Скорость кораблей на 50% больше, что позволяет покинуть бой, при этом не теряя скорость при уходе с орбиты вражеской планеты.[br]"
			+"- На передовой ударная сила кораблей увеличивается на 50%.[br]"
			+"- Крейсеры на передовой с вероятностью 20% взламывают 4 крейсера противника.[br]",
		FormRaseFeaturesPeople:
			 "- В бою корабли используют нанитов, которые разбирают структуру вражеских кораблей для ремонта своих собственных. Что увеличивает урон на 30% и ремонтирует собственные корабли со скорость 25% от повреждений вражеских кораблей.[br]",
		FormRaseFeaturesTechnol:
			 "- Корабли, при потере 50% структуры, оснащены энергетическим щитом, который блокирует 95% повреждений с 30% коэффициентом рассеивания.[br]"
			+"- Дредноуты могут менять режим лазера с боевого на трансиверный. Что позволяет восстанавливать щиты у кораблей.[br]",
		FormRaseFeaturesGaal:
			 "- Корабли оснащены барьером, который уменьшает урон на 25%, при этом накапливает энергию, позволяющую мгновенно нанести большой урон вражеским кораблям.[br]",
		FormRadarGalaxyMap:"Галактическая карта",
		FormRadarRadar:"Радар", // Гиперпространственный
		UnionCaption:"Альянс",
		UnionNewCaption:"Создание нового альянса",
		UnionNewDesc:"Стоимость создания нового альянса\nсоставляет <font color='#ffff00'><Val></font> egm.",
		UnionNewCreate:"Создать",
		UnionNewType:"Тип",
		UnionNewCptName:"Русское имя",
		UnionNewCptNameEng:"Имя латиницей",
		FormUnionPageMember:"Состав",
		FormUnionPageInfo:"Информация",
		FormUnionPageNames:"Названия",
		FormUnionPageBonus:"Бонус", 
		FormUnionName:"Название альянса",
		FormUnionNameLang:"Русское название альянса",
		FormUnionNameEng:"Название альянса латиницей",
		FormUnionDesc:"Краткое описание (по-русски)",
		FormUnionDescEng:"Краткое описание (по-английски)",
		FormUnionSite:"Сайт",
		FormUnionAdmin:"Лидер",
		FormUnionEmblemSmall:"Малая эмблема",
		FormUnionEmblemLarge:"Большая эмблема",
		FormUnionHello:"Объявление",
		FormUnionInfo:"Текст",
		FormUnionRenameCost:"Стоимость переименования альянса\nсоставляет <font color='#ffff00'><Val></font> egm.",
		FormUnionUser:"Игрок",
		FormUnionRank:"Звание",
		FormUnionJoin:"Пригласить в альянс",
		FormUnionCancelQuery:"Вы хотите отозвать заявку на присоединение к альянсу?",
		FormUnionJoinQuery:"Вы хотите войти в альянс?",
		FormUnionAccessTitle:"Права:",
		FormUnionAccessHeader:"Изменение шапки",
		FormUnionAccessInfo:"Изменение информации",
		FormUnionAccessInvite:"Приглашние в альянс",
		FormUnionAccessExclusion:"Исключение из альянса",
		FormUnionAccessRank:"Изменение звания",
		FormUnionAccessAccess:"Изменение прав",
		FormUnionAccessChatEdit:"Администрирование чата",
		FormUnionLeave:"Покинуть",
		FormUnionLeaveNoAdmin:"Лидер может покинуть альянс, только если он один в альянсе.",
		FormUnionLeaveQuery:"Вы действительно хотите покинуть альянс?",
		FormUnionExclusion:"Исключить из альянса",
		FormUnionChangeAdmin:"Передать право лидера",
		FormUnionChangeAdminQuery:"Вы уверены, что хотите передать право лидера?",
		FormUnionNameUnion:"Альянс",
		FormUnionNameRank:"Звание",
		FormUnionNameAdmin:"Лидер",
		FormUnionNameRank0:"Звание 1",
		FormUnionNameRank1:"Звание 2",
		FormUnionNameRank2:"Звание 3",
		FormUnionNameRank3:"Звание 4",
		FormUnionNameRank4:"Звание 5",
		FormUnionNameCapLang:"По-русски",
		FormUnionNameCapEng:"По-английски",
		FormUnionCotlCnt:"Вы захватили [clr]<Val>[/clr] созвездий.[br]Что составляет [clr]<Proc>%[/clr] от галактики.",
		UnionErrExistName:"Ошибка. Альянс с таким именем уже существует.",
		UnionErrExistNameEng:"Ошибка. Альянс с таким латинским именем уже существует.",
		FormUnionErrImgFormat:"Ошибка. Изображение должно быть в формате png.",
		FormUnionErrImgSmallSize:"Ошибка. Избражение должно быть 24 на 24 пикселя и не привышать 4 кб.",
		FormUnionErrImgLargeSize:"Ошибка. Избражение должно быть 100 на 100 пикселей и не привышать 16 кб.",
		FormUnionErrDescLine:"Ошибка. В описании не должно быть больше 2 строк.",
		FormUnionErrHelloLine:"Ошибка. В объявлении не должно быть больше 6 строк.",
		FormUnionErrInfoLine:"Ошибка. В объявлении не должно быть больше 50 строк.",
		FormUnionErrText:"Ошибка в данных введенными вами.",
		FormUnionErrAlreadyJoin:"Пользователь уже состоит в альянсе",
		FormUnionErrAccess:"Ошибка: Нет доступа.",
		FormTalentButRelocate:"Перераспределить",
		FormTalentQueryRelocate:"За [clr]15 000[/clr] egm вы можете войти в [clr]60[/clr] минутный режим перераспределения всех технологий у всех капитанов.\nВы хотите активировать этот режим?",
		FormTalentTimeRelocate:"До завершения режима перераспределения\nосталось <font color='#ffff00'><Val></font> минут.",
		FormTalentNoUnresech:"Разучить технологию вы можете только в режиме перераспределения.",

		FormEnterCaption:"ВХОД",
		FormEnterName:"E-mail",
		FormEnterPassword:"Пароль",
		FormEnterBut:"ВОЙТИ",
		FormEnterButTraining:"ОБУЧЕНИЕ",
		FormEnterSaveName:"Запомнить имя",
		FormEnterSaveAll:"Запомнить ключ доступа",
		FormEnterHWOff:"Чтобы продолжить вы должны войти в настройки и включить аппаратное ускорение. Затем перезайти в игру.",
		FormEnterHWOffAIR:"Чтобы продолжить вы должны войти в игру через сайт и включить аппаратное ускорение графики. После чего вы можете играть как в браузере так и в клиентской версии игры.",
		FormEnterHWOldDriver:"Чтобы продолжить вы должны установить новую версию драйвера к вашей видеокарте.",
		FormEnterFlashOps:"НАСТРОЙКИ",
		FormEnterButExit:"ВЫХОД",
		FormEnterServer:"Сервер",
		FormEnterProtocol:"Протокол",
		FormEnterScale:"Масштаб",
		FormEnterTxtTraining:"[justify]Начав обучение, вы в интерактивном режиме познакомитесь со многими аспектами достаточно сложной, но интересной игры. По завершению обучения вам предложат создать новый аккаунт, после чего вы сможете совместно играть с другими игроками.[/justify]",
		FormEnterTabTraining:"обучение",
		FormEnterTabLogin:"логин",
		FormEnterTabSet:"настройки",
		FormEnterProtocolRaw:"Raw",
		FormEnterProtocolDefaultHTTP:"Default HTTP",
		FormEnterNewNameCaption:"ИМЯ",
		FormEnterNewNameCaptionNewName:"НОВОЕ ИМЯ",
		FormEnterNewNameTxtNewName:"Ваш псевдоним купил другой игрок. Введите ваш новый псевдоним:",
		FormEnterNewNameTxt:"Введите ваш публичный псевдоним, чтобы отличать вас от других игроков:",
		FormEnterNewNameErrName:"Ошибочное имя.",
		FormEnterNewNameErrLen:"Имя должно содержать от 2 до 16 символов.",
		FormEnterNewNameErrChar:"Имя должно состоять только из букв одного алфавита, цифр или пробела.",
		FormEnterNewNameErrBadWord:"В имени не должна содержаться ненормативная лексика.",
		FormEnterNewNameErrReserve:"Имя зарезервировано.",
		FormEnterNewNameErrNone:"Имя свободно.",
		FormEnterNewNameErrUse:"Имя занято. Выберите другое.",
		FormEnterContinue:"ПРОДОЛЖИТЬ",

		FormBuyNameMenu:"Покупка имени",
		FormBuyNameCaption:"ПОКУПКА ИМЕНИ",
		FormBuyNameTxt:"[justify][p]За <Price> egm вы можете купить новый псевдоним. Купить можно только тот псевдоним, который не куплен другим игроком. Если другой игрок использует псевдоним купленный вами, то ему придется сменить свой псевдоним на новый.[/p][p]Кроме того, при покупке имени, вам дается либо продлевается инжектор контроля на 15 дней.[/p][/justify]",
		FormBuyNameButBuy:"КУПИТЬ",
		FormBuyNameComplate:"Псевдоним успешно приобретен. Изменения вступят через несколько секунд.",

		FormRegCloneMenu:"Регистрация клона",
		FormRegCloneCaption:"РЕГИСТРАЦИЯ КЛОНА",
		FormRegCloneTxt:"[justify][p]Если у вас имеется больше одного аккаунта, то вы должны зарегистрировать дополнительные аккаунты как клоны. Для этого введите в нижеследующие поля e-mail и  пароль основного аккаунта. И после регистрации данный аккаунт будет привязан к основному как клон.[/p][p]Допускается одновременно играть только на одном аккаунте, но при этом другие аккаунты будут заблокированы на две недели. По истечению этого времени вы можете переключиться на любой другой клон-аккаунт. Блокировка и переключение происходит автоматически при входе в игру.[/p] [p][crt]ВНИМАНИЕ ![/crt] Запрещено иметь не зарегистрированных клонов званием “кадет” и выше. Не соблюдение этого закона влечёт за собой блокирование доступа к игре и большому штрафу![/p] [/justify]",
		FormRegCloneBut:"РЕГИСТРАЦИЯ",
		FormRegCloneErrNoAccess:"[crt]ОШИБКА[/crt]. Скорей всего вы не правильно указали e-mail и пароль основного аккаунта.",
		FormRegCloneErrNeedOther:"[crt]ОШИБКА[/crt]. Требуется указать основной аккаунт или другой клон-аккаунт.",
		FormRegCloneComplate:"Клон успешно зарегистрирован.",

		FormRegMenu:"Регистрация",
		FormRegEmailCaption:"РЕГИСТРАЦИЯ",
		FormRegEmailText:"[justify][p]Пройдя процедуру регистрации, введя email и пароль для входа в игру, вы конвертируете данный временный аккаунт в постоянный и привяжете его к свой почтовому ящику.[/p][p]Пожалуйста, укажите правильный email, для того чтобы в случае утраты пароля вы смогли восстановить доступ к аккаунту.[/p][p][crt]ВНИМАНИЕ![/crt] Запрещено использовать не зарегистрированных клонов. Не честных игроков выявляем, затем штрафуем и банем.[/p][/justify][br]",
		FormRegEmailComplate:"[justify]Регистрация завершена.[/justify]",
		FormRegEmail:"Email",
		FormRegPassword:"Пароль",
		FormRegReg:"РЕГИСТРАЦИЯ",
		FormRegErrUse:"На данный email уже зарегистрирован аккаунт. Укажите другой.",
		FormRegErrChar:"Не корректный email.",
		FormRegErrPwdLen:"Не указан пароль.",

		FormNewsCaption:"Галактические новости",
		FormNewsLinkImport:"Импорт",
		FormNewsLinkExport:"Экспорт",

		HyperspaceStar:"Звезда",
		HyperspacePlanet:"Планета",
		HyperspaceSputnik:"Спутник",
		HyperspaceInCotl:"в созвездии",
		HyperspaceInCotlUser:"в созвездии игрока",

		HyperspaceAddCotlProtect:"Добавить защитное созвездие",
		HyperspaceCotlEditCaption:"Параметры созвездия", 
		HyperspaceCotlId:"Идентификатор", 
		HyperspaceCotlType:"Тип",
		HyperspaceCotlPfx:"Префикс",
		HyperspaceCotlName:"Название",
		HyperspaceCotlDesc:"Описание",
		HyperspaceCotlSize:"Размер",
		HyperspaceCotlProtectDate:"Защита до",
		HyperspaceCotlDevTime:"До окончания разработки",
		HyperspaceCotlDevDays:"Дней",
		HyperspaceCotlBonus:"Бонус", 
		HyperspaceCotlBonusVal:"Значение", 
		HyperspaceCotlRewardExp:"Опыт", 
		HyperspaceCotlMaxRating:"Максимальный рейтинг", 
		HyperspaceCotlDevNeed:"Свободно для разработки.",
		HyperspaceCotlDevelopment:"В разработке",
		HyperspaceCotlTemplate:"Шаблон",
		HyperspaceCotlPortalEnterShip:"Вход кораблей",
		HyperspaceCotlPortalEnterFlagship:"Вход флагманов",
		HyperspaceCotlPortalEnterAllItem:"Все товары",
		HyperspaceCotlCombat:"Битва",
		HyperspaceCotlDev:"Разработчик",
		HyperspaceCotlAccessAssignRights:"Назначение прав",
		HyperspaceCotlAccessView:"Просмотр",
		HyperspaceCotlAccessEditMap:"Изменение карты",
		HyperspaceCotlAccessEditCode:"Изменение кода",
		HyperspaceCotlAccessEditOps:"Изменение настроек",
		HyperspaceCotlDevBuy:"Купить разработку",
		HyperspaceCotlDevBuyContinue:"Продлить разработку",
		HyperspaceCotlDevBuyQuery:"Вы можете начать разрабатывать данное созвездие за <Cost> cr. Право на разработку выдается сроком на один день.",
		HyperspaceCotlDevBuyContinueQuery:"Вы можете продлить на один день право разрабатывать данное созвездие за <Cost> cr.",
		HyperspacePlanetName:"Планета",
		HyperspaceRace:"Раса",
		HyperspaceZoneEdit:"Редактировать зону",
		HyperspaceZoneRating:"Рейтинг",
		HyperspaceZonePrice:"Стоимость",
		HyperspaceZoneDev0:"Разработчик 1",
		HyperspaceZoneDev1:"Разработчик 2",
		HyperspaceZoneDev2:"Разработчик 3",
		HyperspaceZoneDev3:"Разработчик 4",
		FormFleetBarAutoPilot:"Автоматическая работа пилотов",
		FormFleetBarAutoGive:"Автоматическое снаряжение кораблей",
		FormFleetBarDestroyShip:"Взорвать",
		FormFleetBarDestroyShipQuery:"Вы действительно хотите взорвать корабли?",
		FormFleetBarCaption:"Флот",
		FormFleetBarLoadFuel:"Заправить топливом",
		FormFleetBarLoadFuelTxt:"Объем топлива, которым нужно заправить флот:",
		FormFleetBarLoadFuelOk:"Заправить",
		FormFleetBarBuyFuel:"Купить топливо",
		FormFleetBarBuyFuelCaption:"Покупка топлива", 
		FormFleetBarBuyFuelCost:"Стоимость (egm)", 
		FormFleetBarBuyFuelCnt:"Вы хотите купить <font color='#ffff00'><Cnt></font> ед. топлива за <font color='#ffff00'><Sum></font> egm?", 
		FormFleetBarBuyHoldLvl:"Расширение трюма",
		FormFleetBarBuyHoldLvlQuery:"Вы хотите купить для трюма флота 8 дополнительных мест за [clr]<Val>[/clr] cr?",
		FormFleetBarBuyHoldCargoLvl:"Расширение транспортного трюма",
		FormFleetBarBuyHoldCargoLvlQuery:"Вы хотите расширить транспортный трюм до [clr]x<Mul>[/clr] за [clr]<Val>[/clr] cr?",
		FormFleetBarReturn:"Возврат",
		FormFleetBarFleetType:"Построение",
		FormFleetBarCotlMove:"Бесплатный перенос созвездия",
		FormFleetBarCotlMovePay:"Платный перенос созвездия",
		FormFleetBarReturnQuery:"Один раз в [clr]8[/clr] часов вы можете вернуть свой флот на орбиту вашего созвездия. Вы хотите вернуть флот?",
//		FormFleetBarCotlMoveQuery:"Один раз в 14 дней вы можете перенести ваше созвездие в то место, где находится ваш флот. Вы хотите переместить созвездие?", 
		//FormFleetBarCotlMoveQuery:"Вы можете перенести ваше созвездие в то место, где находится ваш флот. Если ваш рейтинг меньше [clr]50000[/clr] очков, то после переноса созвездия вы в течение [clr]23[/clr] часов не сможете повторно (бесплатно) перенести созвездие. Если ваш рейтинг больше [clr]50000[/clr] очков, то вы не сможете перенести (бесплатно) созвездие в течение [clr]14[/clr] дней.\n\n Вы уверены, что хотите перенести созвездие?",
		//FormFleetBarCotlMoveQueryPay:"Вы можете за [clr]10000[/clr] egm перенести ваше созвездие в то место, где находится ваш флот. После переноса созвездия вы в течение [clr]7[/clr] дней - не сможете повторно (платно) перенести созвездие.\n\n Вы уверены, что хотите перенести созвездие?",
		FormFleetBarReturnCooldown:"Вернуть флот на орбиту вашего созвездия можно через [clr]<Val>[/clr].",
		//FormFleetBarCotlMoveCooldown:"Бесплатно перенести ваше созвездие можно через [clr]<Val>[/clr].",
		//FormFleetBarCotlMoveCooldownPay:"Платно перенести ваше созвездие можно через [clr]<Val>[/clr].",

		FormFleetItemUse:"Использовать",
		FormFleetItemDestroy:"Уничтожить",
		FormFleetItemDestroyQuery:"Вы действительно хотите уничтожить товар в трюме флота?",
		FormFleetItemAdd:"Добавить",
		FormFleetItemChangeBroken:"Повреждения",

		FormGiveCaption:"Снарядить",
		FormGiveOk:"Снарядить",
		FormGiveCnt:"Количество",
		FormGiveType:"Оборудование",

		FormCombatCaptionCombat:"Битва",
		FormCombatCaptionDuel:"Поединок",
		FormCombatCaptionBattle:"Битва",//"Сражение",
		FormCombatCaptionFlagship:"с флагманами",
		FormCombatFeaturesCombat:"Особености: [clr]Модули - 50%, Опыт - 100%, Захват товара[/clr]",
		FormCombatFeaturesDuel:"Особености: [clr]Модули - 90%, Опыт - 10%[/clr]",
		FormCombatFeaturesBattle:"Особености: [clr]Модули - 50%, Опыт - 300%[/clr]",
		FormCombatModeCombat:"Флот",
		FormCombatModeStat:"Статистика",
		FormCombatModeRes:"Награда",
		FormCombatView:"Просмотр битвы",
		FormCombatOffer:"Вызвать на поединок",
		FormCombatAtk:"Нападение",
		FormCombatDef:"Защита",
		FormCombatAtkCaption:"Нападение",
		FormCombatDefCaption:"Защита",
		FormCombatUser:"Игроки",
		FormCombatRating:"Рейтинг",
		FormCombatMass:"Флот",
		FormCombatLost:"Потери",
		FormCombatDestroy:"Уничтожено",
		FormCombatDamage:"Урон",
		FormCombatModule:"Модули",
		FormCombatExp:"Опыт",
		FormCombatReturn:"(Возврат)",
		FormCombatInvite:"Пригласить в битву",
		FormCombatLeave:"Покинуть битву",
		FormCombatLeaveAndJump:"Покинуть и вернуться",
		FormCombatReady:"Готов к битве",
		FormCombatReadyShow:"Готово к битве",
		FormCombatEnter:"Войти в битву",
		FormCombatReadyTime:"Битва начнется через",
		FormCombatTimeBegin:"До начала",
		FormCombatTimeEnd:"До завершения",
		FormCombatTimePlacing:"Расстановка кораблей. До начала активных действий: <Val>.",
		FormCombatMsgBegin:"[center]До начала активных действий разместите[br]корабли на стартовых позициях.[/center][br][center]Цель: [clr]Уничтожение флота неприятеля и[br]удержание ключевых планет.[/clr][/center]",
		FormCombatWin:"Победа!",
		FormCombatLoss:"Поражение!",
		FormCombatWinUser:"Победил",
		FormCombatWinUsers:"Победили",
		FormCombatWinAtk:"Победила нападающая сторона!",
		FormCombatWinDef:"Победила защищающаяся сторона!",
		FormCombatItemWin:"Товары в космосе",
		FormCombatItemLoss:"Потерянные товары",
		FormCombatItemTake:"Вы подобрали товары",
		FormCombatTake:"Подобрать",
		FormCombatNewOwner:"Новый владелец",
		FormCombatJoinQuery:"Вы согласны?",
		FormCombatExclude:"Исключить",
		FormCombatUp:"Вверх",
		FormCombatDown:"Вниз",
		FormCombatErrInBattle:"Операция отклонена. Игрок уже участвует в битве.",
		FormCombatErrNoReady:"Операция отклонена. Двигатели флота игрока должны быть отключены.",

		FormHistModeDesc:"Описание",
		FormHistModeJournal:"Журнал",
		FormHistModeImport:"Импорт",
		FormHistModeExport:"Экспорт",
		FormHistModeFind:"Поиск",
		FormHistGoodsCotl:"Созвездие",
		FormHistGoodsType:"Товар",
		FormHistGoodsDist:"сек.",//"Расстояние",
		FormHistGoodsCntIndefinitely:"неограниченно",
		FormHistGoodsCntImport:"Требуется",//"Требуемый объем",
		FormHistGoodsCntExport:"Продается",//"Продаваемый объем",
		FormHistGoodsCntImport2:"Требуемый объем",
		FormHistGoodsCntExport2:"Продаваемый объем",
		FormHistGoodsStorage:"Объем: Владелец",
		FormHistGoodsStorage2:"Хранимый объем",
		FormHistGoodsMoney:"cr: Владелец",
		FormHistGoodsMoney2:"cr",
		FormHistGoodsCnt:"Объем",
		FormHistGoodsName:"Наименование",
		FormHistGoodsStep:"ед.",
		FormHistGoodsPrice:"Цена",
		FormHistGoodsStorage:"Хранимый объем",
		FormHistTradeSum:"Сумма",
		FormHistTradePrice:"Цена",
		FormHistImportCaption:"Импортировать",
		FormHistExportCaption:"Экспортировать",
		FormHistAdd:"Добавить",
		FormHistEdit:"Изменить",
		FormHistBuy:"Купить",
		FormHistSell:"Продать",
		FormHistGoodsAdd:"Добавить товар",
		FormHistGoodsEdit:"Изменить товар",
		FormHistGoodsDelete:"Удалить товар",
		FormHistAddCaption:"Добавить запись",
		FormHistEditCaption:"Изменить запись",
		FormHistDeleteCaption:"Удалить запись",
		FormHistDeleteQuery:"Вы действительно хотите удалить запись?",
		FormHistDate:"Приоритет",
		FormHistType:"Тип",
		FormHistTypeText:"Простой",
		FormHistTypeExt:"Расширенный",
		FormHistTypeLog:"Лог",
		FormHistText:"Текст",
		FormHistPages:"Запись",
		FormHistEnter:"Войти",
		FormHistJournal:"Журнал",
		FormHistErrTextLen:"Ошибка: Текст должен быть от 1 до 15000 символов.",
		FormHistErrText:"Ошибка: В тексте присутствует недопустимый символ <CharCode> в позиции <Offset>.",
		FormHistErrTagUnknown:"Неизвестный тэг в позиции <Offset>.",
		FormHistErrStackEmpty:"Для закрывающего тэга [<Tag>] в позиции <Offset> должен присутствовать открывающий тэг.",
		FormHistErrStackRemove:"Найден неправильный закрывающий тэг в позиции <Offset>. Требуется закрывающий тэг: [/<Tag>].",
		FormHistErrStackFill:"Не хватает закрывающего тэга [/<Tag>] в позиции <Offset>.",
		FormHistErrStackSmall:"Слишком много вложенных тэгов в позиции <Offset>.",
		FormHistErrURL:"Неправильный адрес в позиции <Offset>.",
		FormHistErrText:"Недопустимые символы в позиции <Offset>.",
		FormHistTradeItemNoMore:"У вас уже есть данный товар в торговой секции. Измените его, а не добавляйте новый.",
		FormHistBeacon:"Радиомаяк",
		FormHistBeaconQuery:"Во включенном состоянии радиомаяка, ваше созвездие видно на больших расстояниях. Вы уверены, что хотите его включить?",

		FormMenuTech:"Технологии",
		FormMenuPactList:"Договора",
		FormMenuUnion:"Альянс",
		FormMenuPlusar:"Инжекторы",
//		FormMenuAdviser:"Советник",
//		FormMenuTraining:"Обучение",
		FormMenuNormalScreen:"В оконный режим",
		FormMenuFullScreen:"На полный экран",
		FormMenuSet:"Настройки",
		FormMenuCotlJump:"Перенос созвездия",
		FormMenuCotlNew:"Новое созвездие",
		FormMenuExit:"Выход",
		FormMenuDefSave:"Запомнить оборону",
		FormMenuDefSaveQuery:"Вы уверены, что хотите запомнить расстановку кораблей, чтобы в дальнейшем можно было автоматически восстановить оборону?",
		FormMenuDefLoad:"Восстановить оборону",
		FormMenuDefLoadQuery:"Вы уверены, что хотите восстановить оборону в сохраненной ранее конфигурации?",
		FormMenuDefOpOk:"Операция успешно выполнена.",
		FormMenuDefNeedModule:"Для восстановления не хватает <Val> модулей в трюме флота.",

		FormItemBalansCaption:"Баланс",
		FormItemBalansCnt:"В наличии",
		FormItemBalansNeed:"Потребление",
		FormItemBalansProd:"Производство",
		FormItemBalansBalans:"Баланс",

		FormPlanetItemBalans:"Баланс",
		FormPlanetToFleet:"В трюм флота (пробел)",
		FormPlanetToFleetMoney:"Собрать (пробел)",
		FormPlanetSackToFleet:"Грабить в трюм флота (пробел)",
		FormPlanetSackToFleetMoney:"Грабить (пробел)",
		FormPlanetToTransport:"Загрузить в транспорты",
		FormPlanetBuilding:"Планетарные постройки",
		FormPlanetCellUpgrade:"Улучшить",
		FormPlanetCellUpgradeBut:"[Улучшить (пробел)]",
		FormPlanetCellCancel:"Отменить (пробел)",
		FormPlanetCellDestroy:"Разрушить",
		FormPlanetCellDestroyQuery:"Вы действительно хотите разрушить постройку на планете?",
		FormPlanetCellDestroyModuleQuery:"Вы действительно хотите потратить <Val> модулей, чтобы разрушить постройку на планете?",
		FormPlanetItemShowCnt:"Отображение количества",
		FormPlanetItemNoMove:"Не перевозить",
		FormPlanetItemToPortal:"Перебрасывать через портал",
		FormPlanetItemImport:"Импортировать",
		FormPlanetItemExport:"Экспортировать",
		FormPlanetItemExportInfo:"При автоматическом экспорте товара, раз в минуту товар перевозится с планеты в хранилище созвездия.[br]При одном цикле перевозки - потребляется топливо, которое должно находиться на планете.",
		FormPlanetItemImportInfo:"При автоматическом импорте товара, раз в минуту товар перевозится на планету из хранилища созвездия.",
		FormPlanetItemDestroy:"Уничтожить",
		FormPlanetItemDestroyQuery:"Вы действительно хотите уничтожить?",
		FormPlanetItemClear:"Очистить",
		FormPlanetItemBuildDefectFactor:"Брак",
		FormPlanetItemBuild:"Производить",
		FormPlanetItemBuildNav:"Обучать",
		FormPlanetItemBuildIncHomeworldModule:"Столичное производство",
		FormPlanetItemBuildIncBaseModule:"Производство на базе",
		FormPlanetItemBuildInc:"Производство",
		FormPlanetItemBuildDec:"Потребление",
		FormPlanetItemBuildChain:"Цикл производства",
		FormPlanetItemBuildBase:"Производимые товары",
		FormPlanetItemBuildSupply:"Потребляемые товары",
		FormPlanetItemBuildAdd:"Дополнительное производство",
		FormPlanetItemEditItem:"Редактируемый товар",
		FormPlanetItemDifficult:"Сложность",
		FormPlanetEnergy:"Электроэнергия",
		FormPlanetNoEnough:"Недостаточно электроэнергии.",
		FormPlanetNoEnoughDel:"Операция недопустима, так как будет недостаточно электроэнергии.",
		FormPlanetStorageSize:"Объем",
		FormPlanetCityNalog:"Деньги от налогов",
		FormPlanetCityNalog2:"Налоги",
		FormPlanetBuildErrNoCrystalOre:"Построить невозможно, так как на планете нет кристаллических разломов.",
		FormPlanetBuildErrNoTitanOre:"Построить невозможно, так как на планете нет ильменитовых месторождений.",
		FormPlanetBuildErrNoSiliconOre:"Построить невозможно, так как на планете нет кварцитных месторождений.",
		FormPlanetBuildingNeedLargePlanet:"Построить можно только на обитаемых планетах.",
		FormPlanetBuildingNeedSmallPlanet:"Построить можно только на малых планетах.",

		FormPlanetOreCrystalName:"Кристаллический разлом",
		FormPlanetOreTitanName:"Ильменитовое месторождение",
		FormPlanetOreSiliconName:"Кварцитное месторождение",
		FormPlanetOreCrystalDesc:"Из разлома можно добывать антикристаллы, если построить кристаллический резак.",
		FormPlanetOreTitanDesc:"Из месторождения можно добывать титан, если построить титановый рудник.",
		FormPlanetOreSiliconDesc:"Из месторождения можно добывать кремний, если построить кремниевый рудник.",

		FormPlanetBonusCaptionNavigator:"Навыки",
		FormPlanetBonusChangeErrorBuildNav:"В процессе обучения невозможно поменять навык у пилотов.",
		FormPlanetBonusChangeErrorCntNav:"Невозможно поменять навык у обученных пилотов.",

		FormConstructionSelect:"Выбрать постройку...",
		FormConstructionCaption:"Планетарные постройки",
		FormConstructionPageBase:"Основные",
		FormConstructionPageMining:"Добывающие",
		FormConstructionPageRefining:"Перерабатывающие",
		FormConstructionPageLive:"Культурные",
		FormConstructionPageProduction:"Производственные",
		FormConstructionPageEquipment:"Технологические",
		FormConstructionBuyLvlFirst:"Открыть за [clr]<Val>[/clr] cr",
		FormConstructionBuyLvlFirstQuery:"Вы хотите открыть постройку за [clr]<Val>[/clr] cr?",
		FormConstructionBuyLvlQuery:"Вы хотите перейти на следующий технологический уровень за [clr]<Val>[/clr] cr?",

		FormSplitItemCaption:"Распределение",
		FormSplitItemOk:"Распределить",

		FormHyperspaceAttackQuery:"Атаковать флот?",
		//FormHyperspaceQueryStealthOff:"Двигатели флота выключены. Это значит, что неприятель не может установить точные координаты вашего флота и не может напасть. Вы уверены, что хотите включить двигатели флота и совершить перелет?",
		//FormHyperspaceQueryStealthOff:"Вы уверены, что хотите включить двигатели флота и совершить перелет?[br][br]<font color='#A0A0A0'>Примечание: У вас выключены двигатели флота. Это значит, что неприятель не может установить точные координаты вашего флота, а следовательно не может напасть.</font>",
		//FormHyperspaceButStealthOff:"Включить",
		//FormHyperspaceButStealthCancel:"Не включать",
		FormHyperspaceLeaveOrbitQuery:"Вы уверены, что хотите покинуть орбиту созвездия?",
		FormHyperspaceLeaveOrbitLeave:"ПОКИНУТЬ",
		FormHyperspaceLeaveOrbitStay:"ОСТАТЬСЯ",

		FormFleetTypeCaption:"Построение флота",
		FormFleetType0Caption:"Разведывательное",
		FormFleetType1Caption:"Боевое",
		FormFleetType2Caption:"Походное",
		FormFleetType3Caption:"Грузовое",
		FormFleetType4Caption:"Транспортное",
		FormFleetTypeActivate:"Активировать",
		FormFleetTypeOpen:"Открыть за [clr]<Val>[/clr] cr",
		FormFleetTypeOpenQuery:"Вы уверены, что хотите открыть это построение флота за [clr]<Val>[/clr] cr?",
		FormFleetTypeNoChangeEmptyTransportCargo:"Невозможно изменить построение флота.[br]Сначала вы должны очистить транспортные слоты.",
		FormFleetTypeNoChangeLimitTransportCargo:"Невозможно изменить построение флота, так как трюмы будут переполнены.[br]Сначала необходимо ограничить число товаров в транспортных слотах.",
		FormFleetTypeNoChangeLimitMass:"Невозможно изменить построение флота, так как масса флота слишком большая.[br]Сначала необходимо вывести лишние корабли из флота.",
		FormFleetTypeNoChangeLimitSlot:"Невозможно изменить построение флота, так как занято седьмое место во флоте.",
		FormFleetTypeNoHomeOrbit:"Построение флота можно изменить, только если флот находится на орбите вашего личного созвездия или созвездия с вашим анклавом.",
		FormFleetTypeNoCotlMove:"В грузовом или транспортном построении нельзя перенести личное созвездие.",

//		FormFleetType0Txt:"[center]Скорость: [clr]Высокая[/clr][/center][center]Расход топлива: [clr]50[/clr][/center][center]Масса флота: [clr]300 000[/clr][/center]", //[center]Мест: [clr]6[/clr][/center]
//		FormFleetType1Txt:"[center]Скорость: [clr]Средняя[/clr][/center][center]Расход топлива: [clr]200[/clr][/center][center]Масса флота: [clr]900 000[/clr][/center]",
//		FormFleetType2Txt:"[center]Скорость: [clr]Низкая[/clr][/center][center]Расход топлива: [clr]500[/clr][/center][center]Масса флота: [clr]1 400 000[/clr][/center]",
//		FormFleetType3Txt:"[center]Скорость: [clr]Средняя[/clr][/center][center]Расход топлива: [clr]20[/clr][/center][center]Масса флота: [clr]450 000[/clr][/center][center]Транспортный трюм: [clr]x5[/clr][/center]",
//		FormFleetType4Txt:"[center]Скорость: [clr]Низкая[/clr][/center][center]Расход топлива: [clr]50[/clr][/center][center]Масса флота: [clr]600 000[/clr][/center][center]Транспортный трюм: [clr]x10[/clr][/center]",

		FormFleetType0Txt:"[center]Масса флота: [clr]300 000[/clr][/center]", //[center]Мест: [clr]6[/clr][/center]
		FormFleetType1Txt:"[center]Масса флота: [clr]900 000[/clr][/center]",
		FormFleetType2Txt:"[center]Масса флота: [clr]1 400 000[/clr][/center]",
		FormFleetType3Txt:"[center]Масса флота: [clr]450 000[/clr][/center][center]Транспортный трюм: [clr]x5[/clr][/center]",
		FormFleetType4Txt:"[center]Масса флота: [clr]600 000[/clr][/center][center]Транспортный трюм: [clr]x10[/clr][/center]",
		
		HangarMoveSlot:"Переместить платформу",
		HangarDelSlot:"Уничтожить платформу",
		HangarDelSlotQuery:"Вы уверены, что хотите уничтожить платформу?",
		HangarAddSlot:"Купить платформу",
		HangarAddSlotCaption:"Платформа",
		HangarAddSlotBuy:"Купить",
		HangarAddSlotText:"За <Price> cr вы можете купить новую платформу для размещения на ней нового оборудования.",
		HangarAddSlotType:"Тип платформы",
		HangarAddSlotErrMax:"У корабля не может быть более 32 платформ.",
		
		HangarNeedMoreEnergy:"Не хватает энергии",
		HangarCoreEnergy:"Заряд",

		HangarSlotEnergy:"Распределитель",//"Платформа распределения",//"Распределитель",//"Энергетическая платформа",
		HangarSlotCharge:"Концентратор",//"Платформа потребления",//"Концентратор",//"Энергетическая платформа",
		HangarSlotCore:"Ядро",//"Концентратор",//"Платформа ядра",
		HangarSlotSupply:"Снабжение",//"Платформа снаряжения",//"Уселитель",//"Платформа снабжения",

		HangarSlotEnergyDesc:"Распределитель служит для коммутации оборудования установленного в нем. Распределительные платформы могут быть соединены между собой и подключены к ядру, в который поступает излишек энергии.",
		HangarSlotChargeDesc:"Концентратор непосредственно подключается к ядру и потребляет заряд, тем самым позволяет оборудованию работать в активной фазе, что увеличивает характеристики оборудования установленного в нем.",
		HangarSlotCoreDesc:"Ядро преобразует излишек энергии в заряд и накапливает его для дальнейшего использования в концентраторах для активной фазы работы оборудования.",
		HangarSlotSupplyDesc:"Платформы снабжения обеспечивают хранение и использование материалов для различных нужд корабля.",

		StorageCaption:"Созвездие",
		StoragePageDesc:"i",//"Описание",
		StoragePageJournal:"Журнал",//"Журнал",
		StoragePageStorage:"Хранилище",
		StoragePageImport:"Импорт",
		StoragePageExport:"Экспорт",
		StoragePageFind:"Поиск",
		StorageOp:"Меню",
//		StorageAdd:"Добавить",//"+",
		StorageChange:"Изменить",
		StorageDel:"Удалить",
		StorageGoodsChangeCaption:"Изменить",
		StorageImportCaption:"Импортировать",
		StorageExportCaption:"Экспортировать",
		StorageChangeEx:"Изменить детально",
		StorageGoods:"Товар",
		StorageCnt:"Кол-во",
		StorageLimitImport:"Предел",
		StorageLimitExport:"Предел",
		StoragePrice:"Цена",
		StorageMin:"Минимально",
		StorageMax:"Максимально",
		StorageNeedMoney:"Для обеспечения импорта товаров, в хранилище, не хватает <Sum> cr.",
		StorageEd:"ед.",
		StorageStep:"за <Val> ед.",
		StorageBuy:"Купить",
		StorageSell:"Продать",
		StorageSum:"Сумма",
		StorageSearch:"Поиск",
		StorageSearchImport:"Импорт",
		StorageSearchExport:"Экспорт",
		StorageSearchCotl:"Созвездие",
		StorageGoToCaption:"Настройки",
		StorageGoToPage:"Запись",
		StorageGoTo:"Установить",
		StorageFilter:"Фильтр",
		StorageEnter:"Войти",
		StorageErrAccess:"Ошибка: Нет доступа.",
		StorageSack:"Грабить",
		StorageSackCaption:"Грабить",
		StorageSackCnt:"Кол-во",

		ItemPageCurrency:"Валюта",
		ItemPageOre:"Элементы",
		ItemPageRefine:"Сырьё",
		ItemPageSupply:"Снабжение",
		ItemPageMaterial:"Материалы",
		ItemPageOutfit:"Снаряжение",
		ItemPagePilot:"Пилоты",
		ItemPageOther:"Другое",
		ItemPageEq:"Оборудование",
		
		BonusPagePilot:"Пилоты",
		BonusPageShip:"Корабли",

		TicketExAttack:"Идет бой",
		TicketExAttackEnd:"Завершился бой",
		TicketExAttackCotlUser:"Вторжение",
		TicketCaptureTake:"Захват планеты",
		TicketCaptureLost:"Потеря планеты",
		TicketExSack:"Разграбление ресурсов",
		TicketExSackNewOwner:"Грабитель",

		TicketAttackUserCotl:"Нападение на ваше созвездие в секторе <SectorX>,<SectorY>. Агрессор <User> (<UserUnion>) ",
		TicketAttack:"Идет бой на вашей планете в секторе <SectorX>,<SectorY> с агрессором <User> (<UserUnion>) ",
		TicketAttackEnd:"Завершился бой в секторе <SectorX>,<SectorY> с агрессором <User> (<UserUnion>).",
		TicketPactSend:"Вы отправили договор игроку <User> (<UserUnion>)",
		TicketPactQuery:"Вы получили договор от игрока <User> (<UserUnion>)",
		TicketPactAccept:"Вы заключили договор с игроком <User> (<UserUnion>)",
		TicketPactReject:"Договор с игроком <User> (<UserUnion>) был отклонен.",
		TicketPactComplate:"Завершен договор между Вами и игроком <User> (<UserUnion>).",
		TicketPactNoRes:"Не хватает ресурсов для заключения договора между Вами и игроком <User> (<UserUnion>).",
		TicketPactTimeOut:"Игрок <User> (<UserUnion>) не ответил на предложенный Вами договор.",
		TicketPactTimeOut2:"Вы не ответили на договор предложенный игроком <User> (<UserUnion>).",
		TicketPactChange:"Договор с игроком <User> (<UserUnion>) не заключен, так как изменились условия.",
		TicketPactBreak:"Разорван договор между вами и игроком <User> (<UserUnion>).",

//		TicketPactSend_Union:"Вы отправили договор игроку [clr]<User>[/clr] ([clr]<Union>[/clr])",
//		TicketPactQuery_Union:"Вы получили договор от игрока [clr]<User>[/clr] ([clr]<Union>[/clr])",
//		TicketPactAccept_Union:"Вы заключили договор с игроком [clr]<User>[/clr] ([clr]<Union>[/clr])",
//		TicketPactReject_Union:"Договор с игроком [clr]<User>[/clr] ([clr]<Union>[/clr]) был отклонен.",
//		TicketPactComplate_Union:"Договор между Вами и игроком [clr]<User>[/clr] ([clr]<Union>[/clr]) завершен.",
//		TicketPactNoRes_Union:"Не хватает ресурсов для заключения договора между Вами и игроком [clr]<User>[/clr] ([clr]<Union>[/clr]).",
//		TicketPactTimeOut_Union:"Игрок [clr]<User>[/clr] ([clr]<Union>[/clr]) не ответил на предложенный Вами договор.",
//		TicketPactTimeOut2_Union:"Вы не ответили на договор предложенный игроком [clr]<User>[/clr] ([clr]<Union>[/clr]).",
//		TicketPactChange_Union:"Договор с игроком [clr]<User>[/clr] ([clr]<Union>[/clr]) не заключен, так как изменились условия.",
//		TicketPactBreak_Union:"Разорван договор между вами и игроком [clr]<User>[/clr] ([clr]<Union>[/clr]).",
		
		TicketUnionJoinFromQuery:"Вы предложили игроку <User> войти в альянс <Union>.",
		TicketUnionJoinFromAccept:"Игрок <User> присоединился к альянсу <Union>.",
		TicketUnionJoinFromCancel:"Вы отозвали заявку на присоединения игрока <User> к альянсу <Union>.",
		TicketUnionJoinFromCancel2:"Игрок <User> отказался войти в альянс <Union>.",
		TicketUnionJoinToQuery:"Игрок <User> предложил вам войти в альянс <Union>.",
		TicketUnionJoinToAccept:"Вы вошли в альянс <Union>.",
		TicketUnionJoinToCancel:"Игрок <User> отозвал заявку на присоединение вас к альянсу <Union>.",
		TicketUnionJoinToCancel2:"Вы отказались войти в альянс <Union>.",
		TicketCaptureCaptureUser:"Вы захватили планету игрока <User> (<UserUnion>).",
		TicketCaptureCapture:"Вы захватили планету.",
		TicketCaptureLostUser:"Игрок <User> (<UserUnion>) захватил вашу планету.",
		TicketCaptureLost:"Вы потеряли планету.",
		TicketCaptureAntimatter:"Захвачено антиматерии",
		TicketCaptureMetal:"Захвачено металла",
		TicketCaptureElectronics:"Захвачено электроники",
		TicketCaptureProtoplasm:"Захвачено протоплазмы",
		TicketCaptureNodes:"Захвачено нодов",
		TicketSack:"Игрок <User> разграбил планету на <Val> модулей.", 
		TicketDelete:"Удалить запись",
		TicketAnnihilation:"Игрок <User> аннигилирует девастаторы.", 

//		TicketCombatNew:"Игрок <User> (<UserUnion>) вызывает вас на битву.",
//		TicketCombatJoin:"Игрок <User> (<UserUnion>) призывает вас присоединиться к битве.",

		TicketCombat_Duel_New_From_Query:"Вы вызвали игрока <User> (<UserUnion>) на поединок.",
		TicketCombat_Duel_New_From_NoAnswer:"Игрок <User> (<UserUnion>) не ответил на ваш вызов и не примет участие в поединке.",
		TicketCombat_Duel_New_From_Ok:"Игрок <User> (<UserUnion>) принял ваш вызов и примет участие в поединке.",
		TicketCombat_Duel_New_From_Cancel:"Игрок <User> (<UserUnion>) отказался участвовать в поединке.",

		TicketCombat_Duel_New_To_Query:"Игрок <User> (<UserUnion>) вызывает вас на поединок.",
		TicketCombat_Duel_New_To_NoAnswer:"Вы не ответили игроку <User> (<UserUnion>) на предложенный им поединок.",
		TicketCombat_Duel_New_To_Ok:"Вы согласились на поединок с игроком <User> (<UserUnion>).",
		TicketCombat_Duel_New_To_Cancel:"Вы отказались от поединка с игроком <User> (<UserUnion>).",

		TicketCombat_Duel_Join_From_Query:"Вы попросили игрока <User> (<UserUnion>) принять участие в поединке на вашей стороне.",
		TicketCombat_Duel_Join_From_NoAnswer:"Игрок <User> (<UserUnion>) не ответил на вашу просьбу и не примет участие в поединке на вашей стороне.",
		TicketCombat_Duel_Join_From_Ok:"Игрок <User> (<UserUnion>) принял вашу просьбу и примет участие в поединке на вашей стороне.",
		TicketCombat_Duel_New_From_Cancel:"Игрок <User> (<UserUnion>) отказался участвовать в поединке на вашей стороне.",

		TicketCombat_Duel_Join_To_Query:"Игрок <User> (<UserUnion>) просит вас принять участие в поединке на его стороне.",
		TicketCombat_Duel_Join_To_NoAnswer:"Вы не ответили игроку <User> (<UserUnion>) на его просьбу участия в поединке на его стороне.",
		TicketCombat_Duel_Join_To_Ok:"Вы согласились принять участие в поединке на стороне игрока <User> (<UserUnion>).",
		TicketCombat_Duel_Join_To_Cancel:"Вы отказались принять участие в поединке на стороне игрока <User> (<UserUnion>).",

		TicketCombat_Battle_New_From_Query:"Вы вызвали игрока <User> (<UserUnion>) на битву.",
		TicketCombat_Battle_New_From_NoAnswer:"Игрок <User> (<UserUnion>) не ответил на ваш вызов и не примет участие в битве.",
		TicketCombat_Battle_New_From_Ok:"Игрок <User> (<UserUnion>) принял ваш вызов и примет участие в битве.",
		TicketCombat_Battle_New_From_Cancel:"Игрок <User> (<UserUnion>) отказался участвовать в битве.",

		TicketCombat_Battle_New_To_Query:"Игрок <User> (<UserUnion>) вызывает вас на битву.",
		TicketCombat_Battle_New_To_NoAnswer:"Вы не ответили игроку <User> (<UserUnion>) на предложенную им битву.",
		TicketCombat_Battle_New_To_Ok:"Вы согласились на битву с игроком <User> (<UserUnion>).",
		TicketCombat_Battle_New_To_Cancel:"Вы отказались от битвы с игроком <User> (<UserUnion>).",

		TicketCombat_Battle_Join_From_Query:"Вы попросили игрока <User> (<UserUnion>) принять участие в битве на вашей стороне.",
		TicketCombat_Battle_Join_From_NoAnswer:"Игрок <User> (<UserUnion>) не ответил на вашу просьбу и не примет участие в битве на вашей стороне.",
		TicketCombat_Battle_Join_From_Ok:"Игрок <User> (<UserUnion>) принял вашу просьбу и примет участие в битве на вашей стороне.",
		TicketCombat_Battle_New_From_Cancel:"Игрок <User> (<UserUnion>) отказался участвовать в битве на вашей стороне.",

		TicketCombat_Battle_Join_To_Query:"Игрок <User> (<UserUnion>) просит вас принять участие в битве на его стороне.",
		TicketCombat_Battle_Join_To_NoAnswer:"Вы не ответили игроку <User> (<UserUnion>) на его просьбу участия в битве на его стороне.",
		TicketCombat_Battle_Join_To_Ok:"Вы согласились принять участие в битве на стороне игрока <User> (<UserUnion>).",
		TicketCombat_Battle_Join_To_Cancel:"Вы отказались принять участие в битве на стороне игрока <User> (<UserUnion>).",

//		QueryExit:"На <font color='#ffff00'><Val></font> (+2 часа) вы можете установить время, когда ваше созвездие станет неактивным. В этом состоянии оно становится неуязвимым, и на него никто не может напасть. Как только вы вновь войдете в игру, ваше созвездие станет активным.\nУстановить время деактивации?",

		FormExitCaption:"ВЫХОД",
		FormExitFast:"быстрый",
		FormExitLong:"долгий",
		FormExitCotlJumpCaption:"ПЕРЕНОС СОЗВЕЗДИЯ",
		FormExitCotlJumpDefault:"стандартный",
		FormExitCotlJumpPay:"платный",
		FormExitNewCpation:"НОВОЕ СОЗВЕЗДИЕ",
		FormExitNewRnd:"случайное",
		FormExitNewClear:"обучение",
		//FormExitNewGame:"Начать заново",

		FormExitLongHour:"Часов",
		FormDeleteCotlKey:"Ключевое слово",

		FormExitFastBut:"БЫСТРЫЙ ВЫХОД",
		FormExitLongBut:"ДОЛГИЙ ВЫХОД",
		FormExitCotlMoveBut:"ПЕРЕНОС СОЗВЕЗДИЯ",
		FormExitCotlMovePayBut:"ПЛАТНЫЙ ПЕРЕНОС СОЗВЕЗДИЯ",
		FormExitDeleteCotlBut:"УДАЛИТЬ СОЗВЕЗДИЕ",
		FormExitNewGameBut:"НАЧАТЬ ЗАНОВО",

		FormExitFastText:'[justify]Нажав на кнопку "[clr]Быстрый выход[/clr]", вы в течении 60 секунд покинете игру, при этом ваше созвездие становится неактивным и на него никто не может напасть.[/justify][br]'+
			'[justify]Быстрый выход не работает если в вашем созвездии есть враг. Вам нужно либо очистить родной сектор от неприятеля перед выходом, либо начать долгий выход при этом защищая свою территорию до истечения времени.[/justify][br]' +
			'[justify]Если вы просто закроете игру, то по истечению 5 минут активируется быстрый выход.[/justify]',
		FormExitLongText:'[justify]Указав количество часов и нажав кнопку "[clr]Долгий выход[/clr]" вы установите время когда покинете игру. По истечению этого времени ваше созвездие станет неактивным и вы в течение 30 минут не сможете войти в игру.[/justify][br]'+
			'[justify]Если вы просто закроете игру и в вашем созвездии есть неприятель, то по истечению 15 минут активируется долгий выход.[/justify]',
		FormExitCotlMoveText:'[justify]Вы можете бесплатно перенести ваше созвездие в то место, где находится ваш флот. Если ваш рейтинг меньше [clr]50000[/clr] очков, то после переноса созвездия вы в течение [clr]23[/clr] часов не сможете повторно (бесплатно) перенести созвездие. Если ваш рейтинг больше [clr]50000[/clr] очков, то вы не сможете перенести (бесплатно) созвездие в течение [clr]14[/clr] дней.[/justify][br]' +
			"[justify]При переносе происходит быстрый выход. Если в вашем созвездии враг, то перенести созвездие нельзя.[/justify]",
		FormExitCotlMovePayText:'[justify]Вы можете за [clr]10000[/clr] egm перенести ваше созвездие в то место, где находится ваш флот. После переноса созвездия вы в течение [clr]7[/clr] дней - не сможете повторно (платно) перенести созвездие.[/justify][br]' +
			"[justify]При переносе происходит быстрый выход. Если в вашем созвездии враг, то перенести созвездие нельзя.[/justify]",
		FormExitCotlMoveCooldown:"Перенос будет доступен через [clr]<Val>[/clr].",
		FormExitDeleteCotlText:'[justify]Если вам не понравилось сгенерированное для вас созвездие, вы можете его удалить, при условии, что в нем нет неприятеля. При этом вы выходите из игры, а все корабли и планеты в вашем созвездии уничтожаются. После повторного входа в игру вам будет сгенерировано новое созвездие.[/justify][br]'+
			'[justify]Чтобы удалить созвездие введете ключевое слово "[clr]DELETE[/clr]"</font> а затем нажмете кнопку "[clr]Удалить созвездие[/clr]"[/justify]',
		FormExitNewGameText:'[justify]Если вы хотите начать с чистого листа, то введете ключевое слово "[clr]NEW GAME[/clr]" а затем нажмете кнопку "[clr]Начать заново[/clr]". При этом вы выходите из игры, а все ваши ресурсы, достижения и т.д. - будут удалены. (За исключением суммы egm на вашем счету.) После повторного входа в игру вы сможете начать с чистого листа.[/justify]',

//		QueryExit:"<font color='#00FFFF'>Быстрый выход</font>  - Если в вашем созвездии нет неприятеля, то вы быстро покидаете игру, при этом ваше созвездие становится неактивным и на него никто не может напасть.\n\n"+
//		"Если быстрый выход не активировался, это значит, что в вашем созвездии есть враг. Вам нужно либо очистить родной сектор от неприятеля перед выходом, либо начать долгий выход при этом защищая свою территорию до истечения времени.\n\n"+
//		"<font color='#00FFFF'>Долгий выход</font> – На <font color='#ffff00'><Val></font> (+2 часа) вы можете установить время, когда покинете игру, при этом ваше созвездие станет неактивным. После долгого выхода вы не сможете в течение 30 минут войти в игру.\n\n"+
//		"Также вы можете просто закрыть окно браузера. Тогда по истечении 5 минут, если в вашем созвездии нет неприятеля, активируется быстрый выход. А если есть неприятель, то по истечении 15 минут активируется долгий выход.\n\n"+
//		"<font color='#00FFFF'>Удалить созвездие</font> – если вам не понравилось сгенерированное для вас созвездие, вы можете его удалить, при условии, что в нем нет неприятеля. При этом вы выходите из игры, а все корабли и планеты в вашем созвездии уничтожаются. После повторного входа в игру вам будет сгенерировано новое созвездие.",
//		ExitButDelete:"Удалить созвездие",
//		ExitButExitFast:"Быстрый выход",
//		ExitButExitLong:"Долгий выход",
//		CotlDeleteQuery:"Для удаления созвездия введите слово 'DELETE'",
//		CotlDelete:"Удалить",

		ExitNoAgain:"Вы не можете повторно задать время выхода из игры.",
		ExitDate:"До выхода",
		ExitBegin:"Начат процесс выхода из игры.",
		ExitTimeout:"Вы не можете войти на сервер. Попробуйте зайти через: <Val>",
		ActiveAtk:"Активное нападение.",
		Ban:"Заблокирован доступ в игру для этого аккаунта.", // [br]Пожалуйста, внимательно прочитайте правила, чтобы больше их не нарушать.
		BanDate:"Заблокирован доступ в игру для этого аккаунта.[br]Вход будет разрешен через: <Val>", // [br]Пожалуйста, внимательно прочитайте правила, чтобы больше их не нарушать.
		WarningNoAttackFleetInStealth:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете определить координаты флота,[br]а следовательно не можете напасть на него.",
		WarningNoMoveFleetInCombat:"[center][crt]ВНИМАНИЕ![/crt] Флот не может перемещаться, пока участвует в битве.",
		WarningNoBuildFlagshipIsBuildShip:"[center][crt]ВНИМАНИЕ![/crt] Нельзя начать строить флагман,[br]если на планете уже строятся корабли.[/center]",
		WarningNoBuildNoHomeworld:"[crt]ВНИМАНИЕ![/crt] Запрещено строить флот без столицы.",
		WarningNoMoreBuild:"[crt]ВНИМАНИЕ![/crt] На орбите планеты можно строить только одну эскадру.",
		WarningNoBuild:"[crt]ВНИМАНИЕ![/crt] На орбите данной планеты вы не можете построить корабли.",
		WarningMaxGroup:"[center][crt]ВНИМАНИЕ![/crt] На орбите планеты не может быть больше[br]6 звеньев дружественных или вражеских кораблей.[/center]",
		WarningRear:"[crt]ВНИМАНИЕ![/crt] Флот не может быть размещен в тылу врага.",
		WarningNoFuel:"[crt]ВНИМАНИЕ![/crt] Не хватает топлива.",
		WarningNeedMoreFuelForFly:"[crt]ВНИМАНИЕ![/crt] Требуется [clr]<Val>[/clr] ед. топлива.",
		WarningNoLeaveBattle:"[crt]ВНИМАНИЕ![/crt] Флот не может покинуть орбиту боя.",
		WarningNoToPulsar:"[crt]ВНИМАНИЕ![/crt] Вы не можете выйти на орбиту активного пульсара.",
		WarningPactNoFly:"[crt]ВНИМАНИЕ![/crt] Вы заключили договор, по которому не можете находиться на орбите этой планеты.",
		WarningLargeRating:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете переместить корабли, так как[br]ваш рейтинг слишком высок для данного созвездия.[/center]", 
		WarningItemFar:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете переместить товар, так как ваш флот[br]не находится на орбите данного созвездия.[/center]",
		WarningItemMoveHoldOverload:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете переместить товар,[br]так как будет переполнение трюмов.[/center]",
		WarningItemMoveBattle:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете переместить товар,[br]так как на орбите планеты находятся вражеские корабли.[/center]",
		WarningItemNoAccessOpByRank:"[center][crt]ВНИМАНИЕ![/crt] Данная операция запрещена по конвенции о званиях.[/center]",
		WarningFleetFar:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете переместить корабли, так как ваш флот[br]не находится на орбите данного созвездия.[/center]",
		WarningFleetFarFuel:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете загрузить топливо, так как ваши корабли не[br]находятся на орбите созвездия империи или анклава.[/center]",
		WarningFleetFarEx:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете совершить данную операцию, так как ваш флот[br]не находится на орбите данного созвездия.[/center]",
		WarningFleetFromHyperspaceProtectZone:"[center][crt]ВНИМАНИЕ![/crt] Для этого созвездия корабли могут выйти из гиперпространства[br]только в специальные зоны.[/center]", 
//		WarningFleetFromHyperspaceEnemy:"[center][crt]ВНИМАНИЕ![/crt] Корабли не могут выйти на эту планету из[br]гиперпространства, так как вне битвы на ней нет ваших\nкораблей, а враг находится слишком близко.[/center]",
		WarningFleetFromHyperspaceEnemy:"[center][crt]ВНИМАНИЕ![/crt] Если по близости враг, то корабли могут выходить из[br]гиперпространства только на дружественную планету.[/center]",
		WarningFleetFromHyperspaceEnemyAll:"[center][crt]ВНИМАНИЕ![/crt] В полностью занятое созвездие, корабли могут выйти[br]из гиперпространство только на необитаемые планеты.[/center]",
		WarningFleetFromHyperspaceWormhole:"[center][crt]ВНИМАНИЕ![/crt] Корабли не могут выходить из гиперпространства[br]на орбиту пульсара или обычной червоточины.[/center]",
		WarningFleetFromHyperspaceWormholeOpen:"[center][crt]ВНИМАНИЕ![/crt] Корабли не могут выходить из гиперпространства[br]на орбиту нестабилизированной червоточины.[/center]",
		WarningFleetFromHyperspaceRank:"[center][crt]ВНИМАНИЕ![/crt] Корабли не могут выходить из[br]гиперпространства в созвездие новичка.",
		WarningFleetFromHyperspaceRank2:"[center][crt]ВНИМАНИЕ![/crt] Корабли новичка не могут выходить[br]из гиперпространства в другие созвездия.",
		WarningFleetToHyperspaceBattle:"[center][crt]ВНИМАНИЕ![/crt] Во время боя корабли не могут[br]совершить переход в гиперпространство.[/center]",
		WarningFleetToHyperspaceNoFuel:"[center][crt]ВНИМАНИЕ![/crt] Корабли не могут перейти в гиперпространство,[br]так как у них должно быть не менее 2ед. топлива.[/center]",
		WarningFleetToHyperspaceInCombat:"[center][crt]ВНИМАНИЕ![/crt] Во время битвы запрещен ручной переход[br]кораблей в гиперпространство.[/center]",
		WarningFleetFromHyperspaceNoFuel:"[center][crt]ВНИМАНИЕ![/crt] Корабли не могут выйти из гиперпространства,[br]так как во флоте должно быть не менее 10ед. топлива.[/center]",
		WarningFleetFromHyperspaceProtectNoFuel:"[center][crt]ВНИМАНИЕ![/crt] Корабли не могут выйти из гиперпространства,[br]так как во флоте не хватает топлива.[/center]", 
		WarningFleetNoAccessShipFromHyperspace:"[center][crt]ВНИМАНИЕ![/crt] В данное созвездие запрещено выходить[br]кораблям из гиперпространства.[/center]",
		WarningFleetNoAccessTransportFromHyperspace:"[center][crt]ВНИМАНИЕ![/crt] В данное созвездие запрещено выходить[br]транспортам из гиперпространства.[/center]",
		WarningFleetNoAccessInvaderFromHyperspace:"[center][crt]ВНИМАНИЕ![/crt] В данное созвездие запрещено выходить[br]штурмовикам из гиперпространства.[/center]",
		WarningFleetNoAccessFlagshipFromHyperspace:"[center][crt]ВНИМАНИЕ![/crt] В данное созвездие запрещено выходить[br]флагманам из гиперпространства.[/center]",
		WarningFleetNoAccessShipToHyperspace:"[center][crt]ВНИМАНИЕ![/crt] Из данного созвездия запрещено входить[br]кораблям в гиперпространство.[/center]",
		WarningFleetNoAccessTransportToHyperspace:"[center][crt]ВНИМАНИЕ![/crt] Из данного созвездия запрещено входить[br]транспортам в гиперпространство.[/center]",
		WarningFleetNoAccessInvaderToHyperspace:"[center][crt]ВНИМАНИЕ![/crt] Из данного созвездия запрещено входить[br]штурмовикам в гиперпространство.[/center]",
		WarningFleetNoAccessFlagshipToHyperspace:"[center][crt]ВНИМАНИЕ![/crt] Из данного созвездия запрещено входить[br]флагманам в гиперпространство.[/center]",
		WarningFleetNoAccessItemMove:"[center][crt]ВНИМАНИЕ![/crt] Для данного созвездия запрещено перемещать товар[br]между планетой и флотом.[/center]",
		WarningInDevNoExtract:"[center][crt]ВНИМАНИЕ![/crt] В режиме разработки, запрещено извлекать[br]из созвездия корабли и товары.[/center]",
		WarningFleetAddShipOutMass:"[center][crt]ВНИМАНИЕ![/crt] Корабли не могут перейти в гиперпространство,[br]так как будет превышена предельная масса флота.[/center]",
		WarningFleetFormationNoFromHyperspace:"[center][crt]ВНИМАНИЕ![/crt] В грузовом или транспортном построении корабли могут выходить[br]из гиперпространства только в свое личное созвездие или на планеты анклава.[/center]",
		WarningFleetOutLimitCombat:"[center][crt]ВНИМАНИЕ![/crt] Для битвы вы исчерпали  лимит массы кораблей.[/center]",
		WarningCotlWait:"[center][crt]ВНИМАНИЕ![/crt] Созвездие в режиме ожидания.[br]Подождите до начала активных действий.[/center]",
		WarningCotlProtectSimple:"[center][crt]ВНИМАНИЕ![/crt] Созвездие находится под защитой.[/center]",
		WarningCotlProtect:"[center][crt]ВНИМАНИЕ![/crt] Созвездие находится под защитой. Ваши корабли не могут выйти[br]из гиперпространства в это созвездие.[/center]",
		WarningCotlProtectOnlyHome:"[center][crt]ВНИМАНИЕ![/crt] Когда ваше созвездие находится под защитой, вы можете выходить кораблями[br]из гиперпространства только в свое личное созвездие или на планеты анклава.[/center]",
		WarningCotlOnlyBase:"[center][crt]ВНИМАНИЕ![/crt] Для данного созвездия, вы можете выходить кораблями[br]из гиперпространства только в свой личный сфере.[/center]",
		WarningCotlOnlyRWH:"[center][crt]ВНИМАНИЕ![/crt] Для данного созвездия, вы можете выходить кораблями[br]из гиперпространства только на открытые блуждающие червоточины.[/center]",
		WarningCotlProtectNoCitadel:"[center][crt]ВНИМАНИЕ![/crt] Когда ваше созвездие находится под защитой, то запрещено основывать цитадель.[/center]",
		WarningDestroy:"<p align='center'>Вы действительно хотите взорвать корабли?</p>",
		WarningLeave:"<p align='center'>Вы действительно хотите покинуть планету?</p>",
		WarningBomb:"<p align='center'>Вы действительно хотите аннигилировать эскадру?</p>",
		//WarningNoBuildMass:"[center][crt]ВНИМАНИЕ![/crt] Построить новые корабли невозможно,[br]так как ваш флот достиг предельной массы кораблей.[/center]",
		WarningNoBuildMass:"[center][crt]ВНИМАНИЕ![/crt] Построить новые корабли невозможно, так как[br]ваш флот будет превышать предельно допустимую массу.[/center]",
		WarningNoBuildSupport:"[crt]ВНИМАНИЕ![/crt] У вас отрицательный ресурсный баланс.[br]Чтобы строить корабли нужно иметь для снабжения\nзапас ресурсов в количестве:\n\n",
		WarningNoBuildBattle:"[crt]ВНИМАНИЕ![/crt] Вне столицы и цитадели во время битвы нельзя строить корабли.",
		WarningNoBuildInfrBattle:"[crt]ВНИМАНИЕ![/crt] Во время битвы на планете нельзя строить инфраструктуру.",
		WarningNoBuildSDMUser:"[crt]ВНИМАНИЕ![/crt] Строить за sdm можно только в личном созвездии.",
		QueryPlanetShild:"<p align='justify'>Планетарный щит – предназначен для защиты планеты и кораблей на её орбите в течение 24 часов. Первый час щит снижает урон, получаемый Вашими кораблями, на 80%. Каждый следующий час эффективность щита падает на 2%. Кроме того, время захвата планеты при включенном щите увеличивается в 5 раз.</p>\n\n<p align='left'>Стоимость включения: 200 egm.</p>\n\n<p align='left'>Вы уверены, что хотите включить планетарный щит для защиты планеты?</p>",
		WarningNoEgm:"Для выполнения данной операции у вас не хватает игровой валюты(egm). Вы хотите пополнить счет?",
		WarningNoRes:"[crt]ВНИМАНИЕ![/crt] Для выполнения данной операции у вас не хватает ресурсов.",
		WarningCitadelDist:"[crt]ВНИМАНИЕ![/crt] Цитадель не может быть основана ближе 20 секторов от столицы.",
		WarningNoCaptureLvl:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете захватить данную планету, так как[br]количество атакующих штурмовиков должно быть не меньше уровня инфраструктуры планеты.[/center]",
		WarningNoCaptureEmpire:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете захватить данную планету, так как[br]у Вас предельное количество планет в империи.[/center]",
		WarningNoCaptureEnclave:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете захватить данную планету, так как[br]у Вас предельное количество планет в анклаве.[/center]",
		WarningNoCaptureColony:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете захватить данную планету, так как[br]у Вас предельное количество колоний.[/center]",
		WarningNoCapturePlanet:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете захватить данную планету, так как[br]у Вас предельное количество планет во всей империи.[/center]",
		WarningNoMorePortal:"[crt]ВНИМАНИЕ![crt] Только одно звено кораблей может проходить через портал.",
		WarningMoveGravitor:"[crt]ВНИМАНИЕ![/crt] Гравитационные возмущения не позволяют выйти на орбиту планеты.",
		WarningMoveGravitorPulsar:"[crt]ВНИМАНИЕ![/crt] Гравитационные возмущения не позволяют кораблям выйти на орбиту пульсара.",
		WarningNoMoreCpt:"[center][crt]ВНИМАНИЕ![/crt] Чтобы иметь больше одного флагмана нужно[br]активировать инжектор капитанов или контроля.[/center]",
		WarningNoPortalCnt:"[crt]ВНИМАНИЕ![/crt] Корабли не могут перейти через портал, так как их слишком много.",
		WarningNoPortalOwner:"[crt]ВНИМАНИЕ![/crt] Корабли не могут перейти через вражеский портал.", 
		WarningNoLeaveAccupation:"[crt]ВНИМАНИЕ![/crt] Вы не можете покинуть оккупированную планету.",
		WarningNoRating:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете войти в созвездие, так как[br]ваши рейтинги сильно отличаются.[/center]",
		WarningNoAccessCombat:"[center][crt]ВНИМАНИЕ![/crt] Вы не можете участвовать в этой битве.[/center]",
		WarningOpBattle:"[center][crt]ВНИМАНИЕ![/crt] Во время битвы данная операция запрещена.[/center]",
//		WarningPathNoCtrl:"[center][clr]СОВЕТ![/clr] При прокладке маршрута не стоит постоянно удерживать контрольную[br]клавишу, так как flash начинает сильно тормозить.[/center]",
		WarningPathNotFound:"[center][crt]ВНИМАНИЕ![/crt] Если маршрут не прокладывается на большое расстояние,[br]то скорее всего вам нужно сначала просмотреть весь предполагаемый маршрут,[br] для того чтобы загрузились нужные сектора.[/center]",
		WarningBuildingNeedLargePlanet:"[center][crt]ВНИМАНИЕ![/crt] Данную постройку можно построить только на обитаемых планетах.[/center]",
		WarningBuildingNeedSmallPlanet:"[center][crt]ВНИМАНИЕ![/crt] Данную постройку можно построить только на малых планетах.[/center]",
		WarningBuildingLabAndModule:"[center][crt]ВНИМАНИЕ![/crt] Запрещена постройка на одной планете лаборатории и сборочного комплекса.[/center]",
		WarningNoMorePilot:"[center][crt]ВНИМАНИЕ![/crt] Нельзя использовать более одного механика или навигатора.[/center]",
		WarningNoCancelBuildFlagshipInRelocate:"[center][crt]ВНИМАНИЕ![/crt] Запрещено отменять строительство флагмана[br]в режиме перераспределения технологий.[/center]",
		WarningOutWarehouse:"Не работает - вне склада.",
		WarningNoMoreQuarkBase:"[center][crt]ВНИМАНИЕ![/crt] Запрещено иметь больше одного гравитационного разрушителя.[/center]",
		WarningNeedQuarkCore:"[center][crt]ВНИМАНИЕ![/crt] Требуется [clr]<Val>[/clr] кварковых ядер.[/center]",
		WarningNeedSingleQuarkCore:"[center][crt]ВНИМАНИЕ![/crt] Требуется одно кварковое ядро.[/center]",
		WarningNeedBattleMode:"[center][crt]ВНИМАНИЕ![/crt] Разрушитель должен быть в боевом режиме.[/center]",
		WarningNeedReloadReactor:"[center][crt]ВНИМАНИЕ![/crt] Идет перезагрузка реактора.[/center]",
		WarningCotlOpNoAccessIsDev:"[center][crt]ВНИМАНИЕ![/crt] Операция запрещена, так как созвездие в режиме разработки.[/center]",
		WarningNoMoveInPlacing:"[center][crt]ВНИМАНИЕ![/crt] Во время расстановки запрещено движение кораблей.[/center]",
		WarningNoGravWellRadiation:"[center][crt]ВНИМАНИЕ![/crt] При радиации нельзя активировать гравитационный колодец.[/center]",
		WarningNoOpEnemy:"[center][crt]ВНИМАНИЕ![/crt] Даная операция невозможна, так как созвездие[br]блокируют вражеские корабли.[/center]",
		WarningQuarkBasePortalLimit:"[crt]ВНИМАНИЕ![/crt] Разрушитель можно портировать только в личное[br]созвездие, между планетами анклава или на орбиту цитадели.",
		WarningNotFoundWormhole:"[center][crt]ВНИМАНИЕ![/crt] В радиусе перелета от научной[br]станции отсутствует место для червоточины.[/center]",
		WarningNotQuarkCoreForWormhole:"[center][crt]ВНИМАНИЕ![/crt] Для открытия червоточины[br]требуется [clr]10[/clr] кварковых ядер у научной станции.[/center]",
		WarningAutoPilotOn:"[center][clr]ВНИМАНИЕ![/clr] Активация пилотов.[/center]",
		WarningAutoPilotOff:"[center][clr]ВНИМАНИЕ![/clr] Пилоты отключены.[/center]",
		WarningOpErrEnemy:"[center][crt]ВНИМАНИЕ![/crt] Операция не возможна,[br]пока в созвездии есть вражеские корабли.[/center]",
		WarningItemActiveAtk:"[center][crt]ВНИМАНИЕ![/crt] Вывозить товары из созвездия[br]может только тот, кто активно нападает.[/center]",
		WarningOpActiveAtk:"[center][crt]ВНИМАНИЕ![/crt] Выполнить операцию может[br]только тот, кто активно нападает.[/center]",

		ButBuyEgm:"Пополнить счет",
		LostQuery:"Сервер не ответил на запрос", // Связь неустойчива.
		NoCacheFlash:"У вас отключено локальное хранилище, без которого невозможно играть.",
		NoCacheFlashAIR:"Чтобы продолжить вы должны войти в игру через сайт и включить локальное хранилище. После чего вы можете играть как в браузере так и в клиентской версии игры.",
		FindHelp:
			"Примеры:\n" +
			"    импорт созвездие гурт\n" +
			"    экспорт топлива объемом 10000... по цене 1...100 за 1000 ед\n" +
			"\n"+
			"Дистанция поиска: <font color='#ffff00'>500</font> секторов.\n",
//			"\n"+
//			"<font color='#808080'>Примечание:</font>\n"+
//			"    <font color='#808080'>(100 пс = 1 сектор)</font>\n",
//			"    <font color='#808080'>Оплата за поиск не взимается, если ничего не найдено.</font>\n",
//			"Стоимость поиска: <font color='#ffff00'>1</font> cr.\n"+
		FindError: "Некорректный запрос.",
		FindNotFound: "Не найдено.",
		Hint:"hint",
		GalaxyAward:"Альянс, который честно и не нарушая правил игры захватил 80% галактики, получает весь банк в размере [clr]<Val>[/clr] WMR. Деньги перечисляются на кошелек лидера альянса.",
		Zone0:"Дальний космос",
		Zone1:"Враждебная зона",
		Zone2:"Умеренная зона",
		Zone3:"Защищенная зона",
		ZoneModuleMul:"Приход модулей",
		ZoneRatingRange:"Если разместить свое созвездие в этой зоне, то на вас сможет напасть игрок с рейтингом развития в диапазоне [clr]<Min>[/clr]...[clr]<Max>[/clr].",
		ZoneRatingRangeAny:"Если разместить свое созвездие в дальнем космосе, то на вас сможет напасть любой игрок."
	};
	
	static public const TxtQuest:Object = {
		BreakQuestQuery:"Вы действительно хотите отказаться от задания?",
		Task:"Цель",
		TaskPlanet:"на <Val> планетах",
		TaskPlanetNeutral:"нейтральных",
		TaskPlanetPlayer:"своих",
		TaskPlanetFriend:"дружественных",
		TaskPlanetEnemy:"вражеских",
		In:"в",
		InCotl:"созвездии",
		InCotlUser:"созвездии игрока",
		CotlHome:"вашем созвездии",
		CotlEnclave:"созвездии с вашем анклавом",
		TaskActionNewHomeworld:"Основать столицу.",
		TaskDestroyShip:"Уничтожение <Type>: <Val>/<Cnt>. <User>",
		TaskBuildShip:"Постройка <Type>: <Val>/<Cnt>.",
		TaskCapture:"Захват планет: <Val>/<Cnt>.",
		TaskPlaceShip:"Размещение <Type>: <Val>/<Cnt>.",
		Ships:"кораблей",
		Complate:"Выполнено",
		ErrHoldPlace:"Не хватает места в трюме для получения награды!",
		Reward:"Награда",
		RewardExp:"Опыт",
		RewardMoney:"Деньги"
	};
	

	public static const PlanetAtmName:Array = ["Разряженная", "Водородная", "Углекислотная", "Кислородная", "Азотная"];
	public static const PlanetTmpName:Array = ["Холодная", "Теплая", "Горячая"];
	public static const PlanetTecName:Array = ["Пассивная", "Динамическая", "Сейсмическая"];

	public static const kwImport:int = 1;
	public static const kwExport:int = 2;
	public static const kwCotl:int = 3;
	public static const kwPrice:int = 4;
	public static const kwSpace:int = 5;
	public static const kwAt:int = 6;
	public static const kwPeriod:int = 7;
	public static const kwTwo:int = 8;
	public static const kwModule:int = 100;
	public static const kwArmour:int = 101;
	public static const kwPower:int = 102;
	public static const kwRepair:int = 103;
	public static const kwFuel:int = 104;
	public static const kwMonuk:int = 105;
	public static const kwAntimatter:int = 106;
	public static const kwMetal:int = 107;
	public static const kwElectronics:int = 108;
	public static const kwProtoplasm:int = 109;
	public static const kwNodes:int = 110;
	public static const kwMine:int = 111;
	public static const kwEGM:int = 112;
	
	public static const kwTitan:int = 113;
	public static const kwSilicon:int = 114;
	public static const kwCrystal:int = 115;
	public static const kwXenon:int = 116;
	public static const kwHydrogen:int = 117;
	public static const kwFood:int = 118;
	public static const kwPlasma:int = 119;
	public static const kwMachinery:int = 120;
	public static const kwEngineer:int = 121;
	public static const kwTechnician:int = 122;
	public static const kwNavigator:int = 123;
	public static const kwQuarkCore:int = 124;
	
	public static const FindKeyWord:Array = [
		"импорт", kwImport, "import", kwImport,
		"экспорт", kwExport, "export", kwExport,
		"созвездие", kwCotl, "constellation", kwCotl, "cotl", kwCotl,
		"за", kwAt, "at", kwAt,
		"цена", kwPrice, "price", kwPrice,
		"объем", kwSpace, "обем", kwSpace, "space", kwSpace, "volume", kwSpace,
		"...", kwPeriod, 
		"модули", kwModule,	"module", kwModule,
		"броня", kwArmour, "armour", kwArmour,
		"усилитель", kwPower, "power", kwPower,
		"дроид", kwRepair, "droid", kwRepair,
		"топливо", kwFuel, "fuel", kwFuel,
		"монуклиятор", kwMonuk, "monuk", kwMonuk,
		"антиматерия", kwAntimatter, "antimatter", kwAntimatter,
		"металл", kwMetal, "metal", kwMetal,
		"электроника", kwElectronics, "electronics", kwElectronics,
		"протоплазма", kwProtoplasm, "protoplasm", kwProtoplasm,
		"ноды", kwNodes, "nodes", kwNodes,
		"мины", kwMine, "mine", kwMine,
		"egm", kwEGM,
		"титан", kwTitan, "titan", kwTitan,
		"кремний", kwSilicon, "silicon", kwSilicon,
		"антикристаллы", kwCrystal, "crystal", kwCrystal, "anticrystal", kwCrystal,
		"ксенон", kwXenon, "xenon", kwXenon, 
		"водород", kwHydrogen, "hydrogen", kwHydrogen,
		"продовольствие", kwFood, "food", kwFood,
		"плазма", kwPlasma, "plasma", kwPlasma,
		"техника", kwMachinery, "machinery", kwMachinery,
		"инженеры", kwEngineer, "engineer", kwEngineer,
		"механик", kwTechnician, "mechanic", kwTechnician,
		"навигатор", kwNavigator, "navigator", kwNavigator,
		"кварковые", kwQuarkCore, "ядра", kwQuarkCore, "quark", kwQuarkCore, "core", kwQuarkCore,
		"2", kwTwo, "II", kwTwo, "ii", kwTwo
	];

	public static const CotlName:Dictionary = new Dictionary();
	public static const CotlBonusName:Array = ["", 		"Antimatte", "Metal",	"Electronics",	"Protoplasm",	"Nodes",	"CorvetteArmour",	"CorvetteAccuracy",		"CruiserArmour",	"CruiserAccuracy",	"DreadnoughtArmour",	"DreadnoughtAccuracy",	"DevastatorArmour",	"DevastatorAccuracy",	"DevastatorBomb",	"WarBaseArmour",	"WarBaseAccuracy",	"WarBaseArmourAll",		"ShipyardSupply",	"ShipyardRepairAll",	"SciBaseSupply",	"MinePower",	"PlanetEmpireCnt",	"PlanetCitadelCnt",	"PlanetColonyCnt"];
	public static const CotlBonusProc:Array = [false,	false,		false,		false,			false,			false,		true,				true,					true,				true,				true,					true,					true,				true,					false,				true,				true,				true,					true,				false,					true, 				false,			false,				false,				false];
	public static const OpsPriceTypeNameSys:Array = ["none", "Antimatter", "Metal", "Electronics", "Protoplasm", "Nodes", "Fuel", "Module", "EGM", "Cr"];
	public static const OpsPriceTypeName:Array = ["none", "Antimatter", "Metal", "Electronics", "Protoplasm", "Nodes", "Fuel", "Module", "EGM", "Cr"];
	public static const OpsPriceTypeName2:Array = ["none", "Antimatter", "Metal", "Electronics", "Protoplasm", "Nodes", "Fuel", "Module", "EGM", "Cr"];
	public static const WarningHideTime:int = 4000;

	static public const TxtChat:Object = {
		LikeLetter:""
			+"еёe"
			+",оo"
			+",аa"
			+",рp"
			+",кk"
			+",хx"
			+",сc"
			+",мm"
		,
		// [] - необезательно
		// () - обезательно
		// {} - вариант предыдущего
		GoodWord:""
			+"не[ ]бан"
			+",оск(о){а}рбля"
			+",п(о){а}тр(е){и}бля(ют){ть}"
			+",с[ ]уч(е){ё}т(о){а}м"
			+",к(о){а}р(а){о}бл"
			+",к(и){е}н(о){f}т(е){и}атр"
			+",п(о){а}тр(е){и}бля"
			+",as[s]asin"
			+",ас[с]асин"
			+",рубл"
			+",страх"
			+",флаг"
		,
		BadWord:""
			+"с[ц]ук(а){и},с[ц]уч[ь][ка]{ар[а]{ы}}"
			+",к(о){а}з(е){ё}л,к(о){а}злы"
			+",урод[ы][ами]"
			+",нед(о){а}ум[ок][ки]"
			+",нед(о){а}нос(о){а}к"
			+",ублюд[о]{а}(к){ч[ь][е]{к[а]{и}}{ный}}[и][ам][и]"
			+",пр(и){е}дур[ок]{к[и]{а}}"
			+",д(и){е}бил[а][ы][оид[ы]]"
			+",др(о){а}ч[ь][ил[к][а]{и}][ит[ь]][и]"
			+",[на]{от}ху(й){и}{е}[ня]{я}{ло}{сос},[на]хуя[рил[и]{а}]"
			+",[от]п(и){е}{ё}(з){с}д[а][(и){е}ть]"
			+",п(и){е}{ё}д(о){а}р[ас[ы]]{юг(а){и}}{ч(у){а}г}"
			+",п(и){е}{ё}рд(ун[ы]{а}){нут[ь]}{ет[ь]}"
			+",педик,педри"
			+",муд(а){о}к[а]{и}"
			+",[от]{аб}{об}(и){е}{ё}б(ат[ь]){(а){о}н[ут]{ен}{ин}[ый]}"
			+",трах[ат[ь]]"
			+",г(о){а}вн(о){а}"
			+",жоп(о){а}"
			+",п(е){ё}р[д]нут[ь],п(е){ё}рд(н[ул]{и}){и}{(е){ё}[ж][ь]}"
			+",б[е]{ё}зднут[ь]"
			+",бля[д[ь]][т[ь]]"
			+",[по]{от}хер[ня]"
			+",з(о){а}луп(а){ы}"
			+",нахуя" // нах - нельзя. так как: находит
			+",г(а){о}ндон[ы]"
			+",пох(р){у}" // пох - нельзя. так как походный
			+",с(о){а}си"
			+",ид(и){е}{ё}от"
			+",suk(a){i},such"
			+",засал[и]"
			+",idiot,urod,mudak"
			+",pid(a){o}r"
			+",g(a){o}ndon"
			+",k(o){a}zel"
			+",pridur(o){a}k"
			+",p(i){e}zd(a){u}"
			+",f(u){a}ck[of]"
			+",shit,shite,shat"
		,
		LostConnection:"Связь с сервером потеряна",
		PageMain:"Чат",
		PageRename:"Переименовать",
		PageAdd:"Добавить",
		PageDelete:"Удалить",
		RenameCaption:"Название странички чата",
		AddCaption:"Название новой странички чата",
		Channels:"Каналы",
		SilentAll:"Вам запрещено писать в чате.",
		SilentCommon:"Вам запрещено писать <Val> в публичных каналах чата.",
		Silent:"Безмолвие",
		SilentCaption:"Минут, в течение которых игрок не\nсможет писать в текущем канале:",
		SilentTail:"0 - снять безмолвие с игрока.",
		UserList:"Список игроков",
		UserListOnlineName:"Онлайн (по алфавиту)",
		UserListOnlineDate:"Онлайн (по времени)",
		UserListOnlineUnion:"Альянс",
		UserListOnlineNutral:"Нейтральные",
		UserListIgnore:"Игнорируемые",
		Ignore:"Игнорировать",
		IgnoreOut:"Удалить из списка",
		IgnoreGeneral:"Игнорировать: Общий чат",
		IgnoreClan:"Игнорировать: Альянсовый чат",
		IgnoreWhisper:"Игнорировать: Личные сообщения"
	};

	static public const TxtEdit:Object = {
		ChangeCnt:"Изменить количество",
		CotlSet:"Параметры созвездия",
		MapEdit:"Редактировать карту",
		MapSave:"Сохранить карту",
		PowerMul:"Сила кораблей (%)",
		ManufMul:"Скорость производства (*)",
		LootMul:"Лут (%)",
		LootForPlayerMul:"Лут игрока (%)",
		MapUnload:"Выгрузить карту",
		MapUnloadQuery:"Вы действительно хотите выгрузить карту?",
//		MapUnloadNormal:"Выгрузить игровую карту",
//		MapUnloadNormalQuery:"Вы хотите выгрузить игровую карту?",
		MapDelete:"Удалить карту",
		MapDeleteQuery:"Для удаления карты введите слово 'DELETE'",
		MapChangeOptions:"Изменить настройки карты",
		MapChangeOptionsEx:"Изменить настройки карты 2",
		MapChangeCode:"Код",
		MapChangeConsumption:"Потребление",
		MapChangeViewStat:"Статистика",
		MapChangeOpsEnterShip:"Корабли игрока могут войти в созвездие",
		MapChangeOpsEnterTransport:"Транспорты игрока могут войти в созвездие",
		MapChangeOpsEnterFlagship:"Флагманы игрока могут войти в созвездие",
		MapChangeOpsLeaveShip:"Корабли игрока могут покинуть созвездие",
		MapChangeOpsLeaveTransport:"Транспорты игрока могут покинуть созвездие",
		MapChangeOpsLeaveFlagship:"Флагманы игрока могут покинуть созвездие",
		MapChangeOpsBuildShip:"Строительство кораблей",
		MapChangeOpsBuildFlagship:"Строительство флагманов",
		MapChangeOpsBuildWarBase:"Строительство военных баз",
		MapChangeOpsBuildSciBase:"Строительство научных станций",
		MapChangeOpsBuildShipyard:"Строительство верфей",
		MapChangeOpsRelGloablOff:"Договора не работают внутри созвездия",
		MapChangeOpsItemToHyperspace:"Вывоз товаров из созвездия",
		MapChangeOpsBuilding:"Строительство зданий",
		MapChangeOpsViewAll:"Просмотр для всех",
		MapChangeOpsJumpRadius:"Дальность перелета",
		MapChangeOpsModuleProduction:"Объем производства товаров (*)",
		MapChangeOpsCostBuildLvl:"Стоимость постройки инфраструктуры (%)",
		MapChangeOpsSpeedCapture:"Время захвата планет", 
		MapChangeOpsSpeedBuild:"Время постройки кораблей (%)",
		MapChangeOpsRestartCooldown:"Перезагрузка созвездия (в минутах)",
		MapChangeOpsProtectCooldown:"Время защиты (в минутах)",
		MapChangeOpsStartTime:"Запуск (созвездия, БЧТ) (в минутах)",
		MapChangeOpsPulsarActive:"Активность (пульсаров, БЧТ) (в минутах)", 
		MapChangeOpsPulsarPassive:"Пассивность (пульсаров, БЧТ) (в минутах)", 
		MapChangeOpsPulsarEnterActive:"Войти в созвездие можно только когда пульсар активен",
		MapChangeOpsNeutralBuild:"Нейтральные корабли",
		MapChangeOpsKlingBuild:"Клисаны",
		MapChangeOpsWormholeLong:"Долгие червоточины",
		MapChangeOpsWormholeFast:"Быстрые червоточины",
		MapChangeOpsWormholeRoam:"Блуждающие червоточины",
		MapChangeOpsEnterSingleInvader:"Входить может только один штурмовик", 
		MapChangeOpsWin:"Цель", 
		MapChangeOpsWinOccupyCitadel:"Оккупация", 
		MapChangeOpsWinMaxPlanet:"Планеты", 
//		MapChangeOpsWinScore:"Боевая слава", 
		MapChangeOpsWinCtrlCitadel:"Контроль цитаделей", 
		MapChangeOpsWinMaxEnclave:"Доминирующий анклав",
		MapChangeOpsRewardExp:"Опыт", 
		MapChangeOpsWinScore:"Очков для победы", 
		MapChangeOpsMaxRating:"Максимальный рейтинг", 
		MapChangeOpsPriceEnterType:"Цена входа", 
		MapChangeOpsPriceCaptureType:"Цена захвата", 
		MapChangeOpsPriceCaptureEgm:"Цена захвата в egm", 
		MapChangeOpsEnclave:"Анклав",
		MapChangeOpsPlanetShield:"Планетарный щит",
		MapChangeOpsPlayerExp:"Опыт за корабли игроков",
		MapChangeOpsTeamOwner:"Команда владельцев",
		MapChangeOpsTeamEnemy:"Команда врагов",
		MapChangeSize:"Изменить размер карты",
		MapChangeRandomizeNeutral:"Рандомезировать нейтралов",
		MapChangeRandomizeNeutralQuery:"На основании расы планеты спавнятся нейтральные корабли соответствующей расы. Вы уверены, что хотите случайно назначить расу каждой планете? Все нейтральные корабли будут удалены.",
		MapChangeRandomizeElement:"Рандомезировать специализацию",
		MapChangeRandomizeElementQuery:"Вы уверены, что хотите случайно назначить специализацию каждой захватываемой планете?",
		MapChangeSizeLeft:"Слева",
		MapChangeSizeRight:"Справа",
		MapChangeSizeTop:"Сверху",
		MapChangeSizeBottom:"Снизу",
		Add:"Добавить", 
		ButAdd:"ДОБАВИТЬ",
		AddPlanet:"Создать планетоид",
		EditPlanet:"Изменить планетоид",
		DeletePlanet:"Удалить планетоид",
		DeletePlanetQuery:"Вы действительно хотите удалить планетоид?",
		EditPlanetName:"Изменить описание планетоида",
		EditPlanetSpawn:"Спавн звеньев",
		SpawnSave:"Изменить",
		SpawnPageBase:"Общие",
		SpawnPageGroup:"Звенья",
		SpawnPageEq:"Снаряжение",
		SpawnPageFind:"Поиск",
		SpawnPageDelete:"Удаление",
		SpawnEmpty:"Пропуск",
		SpawnNoToBattle:"Пхд",
		SpawnCnt:"Кол-во",
		SpawnAtk:"Атака",
		SpawnRoute:"След",
		SpawnKey:"Ключ",
		SpawnKeyAnd:"Маска ключа",
		SpawnKeyEq:"Проверка ключа",
		SpawnFindRadius:"Радиус",
		SpawnDeleteOn:"Удалять при повреждении",
		SpawnDeleteNoFlagship:"Удалять при отсутствии флагмана или разрушителя",
		SpawnDeleteProc:"Повреждения (%)",
		SpawnDeleteGroup:"Кол-во звеньев",
		SpawnPeriod:"Период (в секундах)",
		SpawnPeriodIfEnemy:"Период если враг",
		SpawnPeriodRnd:"Разброс (в секундах)",
		SpawnTarget:"Цель",
		SpawnTargetNone:"",
		SpawnTargetSelf:"Текущая",
		SpawnTargetTgt:"Целевая",
		SpawnEq:"Оборудование",
		SpawnCargo:"Трюм",
		SpawnDelete:"Удалить",
		SpawnCodeError:"Ошибка разбора кода. Прежде чем менять исправьте код.",
		SpawnCodeErrorNotNew:"Не найдена строка в коде, которая указывает начало нового определения. Прежде чем менять исправьте код.",
		Name:"Название",
		Desc:"Описание",
		OpenWormhole:"Открыть червоточину",
		CloseWormhole:"Закрыть червоточину",
		OpenPlanet:"Открыть планетоид",
		AddShip:"Создать звено кораблей",
		EditShip:"Изменить звено кораблей",
		DeleteShip:"Удалить звено кораблей",
		DeleteShipQuery:"Вы действительно хотите удалить звено кораблей?",
		EditOrbitItem:"Изменить товар", 
		DeleteOrbitItem:"Удалить товар", 
		DeleteOrbitItemQuery:"Вы действительно хотите удалить товар?", 
		Add:"Создать",
		Edit:"Изменить",
		ButEdit:"ИЗМЕНИТЬ",
		PlanetType:"Тип",
		PlanetSun:"Звезда",
		PlanetPulsar:"Пульсар",
		PlanetWormhole:"Червоточина",
		PlanetWormholeRoam:"Блуждающая червоточина",
		PlanetAsteroid:"Карликовая планета",
		PlanetGigant:"Газовый гигант",
		PlanetSmall:"Малая планета",
		PlanetLarge:"Обитаемая планета",
		PlanetRich:"Радужный мир",
		PlanetPageMain:"Основные",
		PlanetPageAdd:"Дополнительные",
		PlanetTimer:"Таймер",
		PlanetStabilizer:"Стабилизация",
		ShipType:"Тип",
		ItemType:"Тип", 
		Owner:"Владелец",
		OwnerNone:"Отсутствует",
		OwnerAI0:"AI 1",
		OwnerAI1:"AI 2",
		OwnerAI2:"AI 3",
		OwnerAI3:"AI 4",
		CptAI0:"CptAI 1",
		CptAI1:"CptAI 2",
		CptAI2:"CptAI 3",
		Level:"Инфраструктура",
		Race:"Раса",
		Cnt:"Количество",
		Module:"Модули",
		Fuel:"Топливо",
		BuildItem:"Специализация",
		BuildItemNone:"Отсутствует",
		ProtectRemove:"Снять защиту",
		UpdateMap:"Обновить карту",
		Eq:"Оборудование",
		EqCnt:"Кол-во оборудования",
		Cargo:"Товар",
		CargoCnt:"Кол-во товара",
		OwnerOptions:"Параметры AI",
		OwnerTech:"Технологии AI", 
		ArrivalAtk:"Место высадки для нападения", 
		ArrivalDef:"Место высадки для защиты", 
		Capture:"Возможно захватить планету", 
		NoCapture:"Нельзя захватить планету (специальные правила)",
		NoMove:"Нельзя выйти на орбиту планеты",
		PlanetFindMask:"Ключ",
		AutoRefuel:"Заправка", 
		AutoBuild:"Автоматическая постройка кораблей", 
		AutoBuildType:"Тип", 
		AutoBuildCnt:"Количество", 
		AutoBuildTime:"Время", 
		AutoBuildWait:"Ожидание", 
		BuildShipNone:"Отсутствует", 
		FleetAddShip:"Добавить корабли",
		FormTeamRelCaption:"Отношения команд",
		Team:"Команда",
		FormItemImgCpation:"Изображения итемов",
		FormItemManagerCpation:"Редактор итемов",
		EditItemCaption:"Параметры итема",
		ItemName:"Название",
		ItemDesc:"Описание",
		ItemSlotType:"Слот",
		ItemLvl:"Уровень",
		ItemStackMax:"Размер стека",
		ChangeCotlPos:"Перенести созвездие",
		ErrorCotlInGameMode:"[crt]ОШИБКА![/crt] Созвездие в игровом режиме.",
		ErrorCotlInEditMode:"[crt]ОШИБКА![/crt] Созвездие в режиме редактирования.",
		ErrorCotlInDevelopment:"[crt]ОШИБКА![/crt] Созвездие в режиме разработки.",
		VisAll:"Просмотр для всех",
		ImportIfEnemy:"Импортировать если враг",
		AutoProgress:"Автоматическое развитие",
		PlayerControl:"Игрок может управлять кораблями",
		SpaceStyleCaption:"Оформление созвездия",
		SpaceStyleMain:"Общие",
		SpaceStyleBGLayer1:"Слой 1",
		SpaceStyleBGLayer2:"Слой 2",
		SpaceStyleBGLayer3:"Слой 3",
		SpaceStyleBGLayer4:"Слой 4",
		SpaceStyleBGImg1:"Спрайт 1",
		SpaceStyleBGImg2:"Спрайт 2",
		SpaceStyleBGImg3:"Спрайт 3",
		SpaceStyleBGImg4:"Спрайт 4",
		SpaceStyleBGClr1:"Цвет спрайта 1",
		SpaceStyleBGClr2:"Цвет спрайта 2",
		SpaceStyleBGClr3:"Цвет спрайта 3",
		SpaceStyleBGClr4:"Цвет спрайта 4",
		SpaceStyleSize:"Размер",
		SpaceStyleOff:"Смещение",
		SpaceStyleZ:"Z",
		SpaceStyleBeginLayer:"Начало",
		SpaceStyleFillColor:"Цвет заполнения",
		SpaceStyleFillImg:"Спрайт заполнения",
		SpaceStyleColorGrid:"Цвет секторов",
		SpaceStyleColorCoord:"Цвет координат",
		SpaceStyleColorTrade:"Цвет торговых маршрутов",
		SpaceStyleColorRoute:"Цвет военных маршрутов",
		SpaceStyleFlipX:"FlipX",
		SpaceStyleFlipY:"FlipY",
		SpaceStyleRotate:"Rotate",
		FormQuestManagerCpation:"Редактор квестов",
		StatCaption:"Статистика",
		StatSecEmptyCnt:"Пустых секторов",
		StatPlanetCnt:"Всего планетоидов",
		StatPulsarCnt: "Пульсаров",
		StatSunCnt: "Звезд",
		StatWormholeCnt: "Червоточин",
		StatGigantCnt: "Газовых гигантов",
		StatTiniCnt: "Карликовых планет",
		StatRichCnt: "Радужных миров",
		StatLiveCnt: "Обитаемых планет",
		StatSmallCnt: "Малых планет",
		StatOwner: "Владелец",
		StatOwnerNeutral: "Нейтральный",
		StatGoodsPlanet: "Товар на планетах",
		StatGoodsShip: "Товар на кораблях или орбите планет",
		StatShips: "Кораблей",
		StatMaxSize: "Размер карты",
		StatShipKeys: "Ключи кораблей",
		ConsumptionCaption:"Потребление"
//		Consumption:""
	};

	static public const Hint:Object={
		Load:"Загрузка",
		ConnectServer:"Соединение с сервером",
		NoServer:"Связь с сервером прервана.",
		IncorrectNameOrPassword:"Связь с сервером прервана. Неправильное имя или пароль.",
		LockIP:"Связь с сервером прервана. Ваш IP адрес заблокирован.\nПопробуйте войти через <Val> секунд, когда блокировка будет снята.",
		ErrorNo:"Ошибка",
		ErrorVersion:"Неправильная версия клиента.",
		FirstNewHomeworld:"New Homeworld",
		WaitBeginGame:"Wait while game begins"
	};
	
	public static const HintWormhole:int = 1;
	public static const HintWormholeRoam:int = 2;
	public static const HintSun:int = 3;
	public static const HintPulsar:int = 4;
	public static const HintPlanetNormal:int = 5;
	public static const HintKling:int = 6;
	public static const HintShip:int = 7;
	public static const HintTransport:int = 8;
	public static const HintGigant:int = 9;
	public static const HintTiny:int = 10;

	public static const HintList:Array = [
		HintWormhole,		"Через червоточины могут проходить корабли.",0,
		HintWormhole,		"Если поблизости есть занятые планеты, то из червоточин появляются клисаны.",0,
		HintWormhole,		"Чем больше занятых планет, тем больше клисан.", 0,
		HintWormholeRoam,	"Блуждающие червоточины открываются в наименее защищенном месте созвездия.", 0,
		HintWormholeRoam,	"На орбиту открытой блуждающей червоточины всегда могут выходить корабли из флота.", 0,
		HintSun,			"Во время битвы корабли могут покинуть орбиту звезды.", 0,
		HintSun,			"Если активирован гравитор, то невозможно покинуть орбиту где идет бой.", 0,
		HintPulsar,			"Если на орбите пульсара разместить научную базу и активировать гравитор, то тогда на ее орбиту не сможет выйти ни один корабль.", 0,
		HintGigant,			"С газового гиганта сервисная платформа может добывать водород.", 0,
		HintGigant,			"Чтобы построить сервисную платформу нужно разместить на орбите транспорты с модулями.", 0,
		HintGigant,			"Во время битвы корабли могут покинуть орбиту газового гиганта, если нет вражеского флагмана с перехватом.", 0,
		HintGigant,			"Если активирован гравитор, то невозможно покинуть орбиту где идет бой.", 0,
		HintTiny,			"Во время битвы корабли могут покинуть орбиту карликовой планеты, если нет вражеского флагмана с перехватом.", 0,
		HintTiny,			"Если активирован гравитор, то невозможно покинуть орбиту где идет бой.", 0,
		HintPlanetNormal,	"Между планетами можно проложить транспортный маршрут. Для этого нужно кликнуть по планете и протянуть линию до другой планеты.", 0,
		HintPlanetNormal,	"Транспортный маршрут предназначен для автоматической перевозки товаров с помощью транспортов.", 0,
		HintPlanetNormal,	"Если на обитаемой или малой планете находится военная база в боевом режиме, то орбиту боя не могут покинуть корветы и девастаторы.", 0,
		HintPlanetNormal,	"Если активирован гравитор, то невозможно покинуть орбиту где идет бой.", 0,
		HintKling,			"Против клисан эффективно строить военные базы.",0,
		HintKling,			"Если вы не справляетесь с клисанами, то уменьшите количество захваченных планет.",0,
		HintKling,			"Клисаны летят на ту планету, где больше звеньев кораблей.",0,
		HintKling,			"В первую очередь клисаны летят на самый большой анклав.",0,
		HintShip,			"Кликнув по кораблю и при этом удерживая кнопку мышки, можно указать орбитальный слот в который полетит корабль.",0,
		HintShip,			"Ctrl - разделить эскадру.",0,
		HintShip,			"Ctrl - прокладка маршрута.",0,
		HintShip,			"Пробел - горячая клавиша быстрого перемещения кораблей во флот.",0,
		HintShip,			"1,2,3,4,5,6 - горячие клавиши быстрого извлечения кораблей из флота.",0,
		HintShip,			"Звено кораблей можно привязать к планете, тогда оно будет автоматически выполнять свою основную функцию.",0,
		HintTransport,		"Если привязать транспорты, то тогда они будут автоматически обслуживать планету, перевозя грузы по транспортному маршруту.", 0,
		HintTransport,		"Если привязанный транспорт не перевозит груз, то скорей всего он не требуется на планетах по транспортному маршруту или просто на планете не хватает места.",0,
		HintTransport,		"С помощью транспортов и горячей клавиши Ctrl можно извлекать модули из флота.",0
	];
	
	public static const Hist:Object = {
		Battle:"Битва между игроками [clr]<Owner1>[/clr] и [clr]<Owner2>[/clr].", 
		Defence:"Защита игрока [clr]<Owner1>[/clr] от игрока [clr]<Owner2>[/clr].", 
		Period:"Продолжительность", 
		UserRecv:"Игрок [clr]<Owner>[/clr] заработал [clr]<Score>[/clr] очков боевой славы, а также [clr]<Exp>[/clr] ед. опыта.", 
		UserLost:"Потери игрока [clr]<Owner>[/clr]", 
		TransportLost:"Транспортов", 
		CorvetteLost:"Корветов", 
		CruiserLost:"Крейсеров", 
		DreadnoughtLost:"Дредноутов", 
		InvaderLost:"Штурмовиков", 
		DevastatorLost:"Девастаторов", 
		WarBaseLost:"Военных баз", 
		ShipyardLost:"Верфей", 
		SciBaseLost:"Научных станций", 
		FlagshipLost:"Флагманов", 
		LostFromMine:"Подорванных на минах", 
		LostFromHack:"Взломанных", 
		LostShipFromAnnihilation:"Аннигилированных кораблей", 
		LostBaseFromAnnihilation:"Аннигилированных баз", 
		PlanetLost:"Планет", 
		AntimatterLost:"Разграблено антиматерии", 
		MetalLost:"Разграблено металла", 
		ElectronicsLost:"Разграблено электроники", 
		ProtoplasmLost:"Разграблено протоплазмы", 
		NodesLost:"Разграблено нодов", 
		Author:"Пишет",
		Date:"Дата",
		Sell:"Продажа игроком <User>",
		Buy:"Покупка игроком <User>",
		Sack:"Грабёж игроком <User>",
		Goods:"Товар",
		GoodsCnt:"Количество",
		GoodsSum:"Сумма"
		};

	// (прошло 1,2,5) (через 1,2,5)
	public static const ScSecond:Array = 	['секунда',	'секунды',	'секунд',			'секунду',	'секунды',	'секунд'];
    public static const ScMinute:Array = 	['минута',	'минуты',	'минут',			'минуту',	'минуты',	'минут'];
    public static const ScHour:Array = 		['час',		'часа',		'часов',			'час',		'часа',		'часов'];
	public static const ScDay:Array = 		['день',	'дня',		'дней',				'день',		'дня',		'дней'];
	
	public static const RomanNum:Array = 	["0", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"];
	
	public static const ChangeWordForNews1:Dictionary = new Dictionary();
	public static const ChangeWordForNews2:Dictionary = new Dictionary();
	public static const ChangeWordForNews5:Dictionary = new Dictionary();

	public static function LangInitRus():void
	{
		ShipName[ShipTypeTransport]="Транспорт";
		ShipName[ShipTypeCorvette]="Корвет";
		ShipName[ShipTypeCruiser]="Крейсер";
		ShipName[ShipTypeDreadnought]="Дредноут";
		ShipName[ShipTypeInvader]="Штурмовик";
		ShipName[ShipTypeDevastator]="Девастатор";
		ShipName[ShipTypeWarBase]="Военная база";
		ShipName[ShipTypeShipyard]="Верфь";
		ShipName[ShipTypeKling0]="Мутенок";
		ShipName[ShipTypeKling1]="Нондус";
		ShipName[ShipTypeSciBase]="Научная станция";
		ShipName[ShipTypeFlagship] = "Флагман";
		ShipName[ShipTypeServiceBase] = "Сервисная платформа";
		ShipName[ShipTypeQuarkBase]="Разрушитель";

		ShipNameM[ShipTypeTransport]="Транспорты";
		ShipNameM[ShipTypeCorvette]="Корветы";
		ShipNameM[ShipTypeCruiser]="Крейсера";
		ShipNameM[ShipTypeDreadnought]="Дредноуты";
		ShipNameM[ShipTypeInvader]="Штурмовики";
		ShipNameM[ShipTypeDevastator]="Девастаторы";
		ShipNameM[ShipTypeWarBase]="Военные базы";
		ShipNameM[ShipTypeShipyard]="Верфи";
		ShipNameM[ShipTypeKling0]="Мутята";
		ShipNameM[ShipTypeKling1]="Нондусы";
		ShipNameM[ShipTypeSciBase]="Научные станции";
		ShipNameM[ShipTypeFlagship] = "Флагманы";
		ShipNameM[ShipTypeServiceBase] = "Сервисные платформы";
		ShipNameM[ShipTypeQuarkBase]="Разрушители";

		ShipNameForCnt[ShipTypeTransport]="Транспортов";
		ShipNameForCnt[ShipTypeCorvette]="Корветов";
		ShipNameForCnt[ShipTypeCruiser]="Крейсеров";
		ShipNameForCnt[ShipTypeDreadnought]="Дредноутов";
		ShipNameForCnt[ShipTypeInvader]="Штурмовиков";
		ShipNameForCnt[ShipTypeDevastator]="Девастаторов";
		ShipNameForCnt[ShipTypeWarBase]="Военных баз";
		ShipNameForCnt[ShipTypeShipyard]="Верфей";
		ShipNameForCnt[ShipTypeKling0]="Мутят";
		ShipNameForCnt[ShipTypeKling1]="Нондусов";
		ShipNameForCnt[ShipTypeSciBase]="Научных станций";
		ShipNameForCnt[ShipTypeFlagship] = "Флагманов";
		ShipNameForCnt[ShipTypeServiceBase] = "Сервисных платформ";
		ShipNameForCnt[ShipTypeQuarkBase]="Разрушителей";

		ShipDesc[ShipTypeTransport]="Корабль, предназначенный для перевозки грузов.";
		ShipDesc[ShipTypeCorvette]="Корабль, предназначенный для мобильных операций. При этом его скорость позволяет покинуть орбиту боя.";
		ShipDesc[ShipTypeCruiser]="Корабль, предназначенный для сдерживания врага, способный вести огонь сразу по двум ближайшим целям.";
		ShipDesc[ShipTypeDreadnought]="Дальнобойный корабль, способный на расстоянии уничтожать вражеские корабли.";
		ShipDesc[ShipTypeInvader]="Корабль, предназначенный для захвата планет.";
		ShipDesc[ShipTypeDevastator]="Корабль, предназначенный для уничтожения кораблей на орбите другой планеты.";
		ShipDesc[ShipTypeWarBase]="Орбитальная база, предназначенная для защиты планет.";
		ShipDesc[ShipTypeShipyard]="Космическая станция, предназначенная для постройки кораблей на орбите планеты.";
		ShipDesc[ShipTypeKling0]="Быстрое и опасное органическое создание.";
		ShipDesc[ShipTypeKling1]="Невероятно причудливая органическая жизнь.";
		ShipDesc[ShipTypeSciBase]="Научная станция, предназначенная для изучения окружающего космического пространства.";
		ShipDesc[ShipTypeFlagship] = "Многофункциональный корабль, предназначенный для формирования ядра флота.";
		ShipDesc[ShipTypeServiceBase] = "Платформа, предназначена для хранения и извлечения ресурсов с планет не пригодных для обитания.";
		ShipDesc[ShipTypeQuarkBase]="Гравитационный разрушитель - мощнейшая база предназначенная для подавления флагманов противника.";

		ItemName[ItemTypeModule]="Модуль";
		ItemName[ItemTypeArmour]="Броня I";
		ItemName[ItemTypePower]="Усилитель I";
		ItemName[ItemTypeRepair]="Дроид I";
		ItemName[ItemTypeJump]="Ускоритель";
		ItemName[ItemTypeBuild]="Строитель";
		ItemName[ItemTypeFuel]="Топливо";
		ItemName[ItemTypeDouble]="Аномалия";
		ItemName[ItemTypeMonuk]="Монуклиятор";

		ItemName[ItemTypeAntimatter]="Антиматерия";
		ItemName[ItemTypeMetal]="Металл";
		ItemName[ItemTypeElectronics]="Электроника";
		ItemName[ItemTypeProtoplasm]="Протоплазма";
		ItemName[ItemTypeNodes]="Ноды";
		ItemName[ItemTypeArmour2]="Броня II";
		ItemName[ItemTypePower2]="Усилитель II";
		ItemName[ItemTypeRepair2]="Дроид II";
		
		ItemName[ItemTypeMine]="Мины";

		ItemDesc[ItemTypeModule]="Применяется для строительства[br]кораблей.";
		ItemDesc[ItemTypeArmour]="Увеличивает защитные характеристики[br]кораблей.";
		ItemDesc[ItemTypePower]="Предназначен для усиления огневой[br]мощи кораблей.";
		ItemDesc[ItemTypeRepair]="Восстанавливает поврежденную[br]структуру кораблей.";
		ItemDesc[ItemTypeJump]="Увеличивает скорость кораблей и[br]позволяет покинуть поле боя.";
		ItemDesc[ItemTypeBuild]="Предназначен для производства модулей[br]на орбите планеты.";
		ItemDesc[ItemTypeFuel]="Используется кораблями для передвижения[br]между планетами.";
		ItemDesc[ItemTypeDouble]="Неизученная аномалия, раздваивает корабль,[br]прошедший сквозь нее.";
		ItemDesc[ItemTypeMonuk]="Увеличивает защитные свойства[br]кораблей на орбите.";

		ItemDesc[ItemTypeAntimatter]="Применяется для производства[br]топлива и оборудования.";
		ItemDesc[ItemTypeMetal]="Применяется для производства[br]оборудования.";
		ItemDesc[ItemTypeElectronics]="Применяется для производства[br]оборудования.";
		ItemDesc[ItemTypeProtoplasm]="Органическая материя[br]клисанского происхождения.";
		ItemDesc[ItemTypeNodes]="Простейшие микроэлементы доминаторов.";
		ItemDesc[ItemTypeArmour2]="Увеличивает защитные характеристики[br]кораблей.";
		ItemDesc[ItemTypePower2]="Предназначен для усиления огневой[br]мощи кораблей.";
		ItemDesc[ItemTypeRepair2]="Восстанавливает поврежденную[br]структуру кораблей.";
		
		ItemDesc[ItemTypeMine]="В орбитальном слоте, где размещены[br]мины, наносятся повреждения кораблям.";

		BuildingName[BuildingTypeEnergy] = "Электростанция";
		BuildingName[BuildingTypeLab] = "Лаборатория";
		BuildingName[BuildingTypeMissile] = "Ракетная база";
		BuildingName[BuildingTypeTerraform] = "Климатическая станция";
		BuildingName[BuildingTypeStorage] = "Склад";
		BuildingName[BuildingTypeXenon] = "Ксеноновая скважина";
		BuildingName[BuildingTypeTitan] = "Титановый рудник";
		BuildingName[BuildingTypeSilicon] = "Кремниевый рудник";
		BuildingName[BuildingTypeCrystal] = "Кристаллический резак";
		BuildingName[BuildingTypeFarm] = "Ферма";
		BuildingName[BuildingTypeElectronics] = "Электротехнический комбинат";
		BuildingName[BuildingTypeMetal] = "Горнорудный комбинат";
		BuildingName[BuildingTypeAntimatter] = "Антипротонный ускоритель";
		BuildingName[BuildingTypePlasma] = "Плазмотрон";
		BuildingName[BuildingTypeCity] = "Город";
		BuildingName[BuildingTypeModule] = "Сборочный комплекс";
		BuildingName[BuildingTypeTech] = "Научный центр";
		BuildingName[BuildingTypeFuel] = "Термоядерный поляризатор";
		BuildingName[BuildingTypePower] = "Завод усилителей";
		BuildingName[BuildingTypeArmour] = "Завод брони";
		BuildingName[BuildingTypeDroid] = "Завод дроидов";
		BuildingName[BuildingTypeMachinery] = "Машиностроительная фабрика";
		BuildingName[BuildingTypeEngineer] = "Университет";
		BuildingName[BuildingTypeMine] = "Миностроительный завод";
		BuildingName[BuildingTypeTechnician] = "Академия механиков";
		BuildingName[BuildingTypeNavigator] = "Академия навигаторов";

		BuildingDesc[BuildingTypeEnergy] = "Вырабатывает электроэнергию, которая потребляется всеми постройками на планете.";
		BuildingDesc[BuildingTypeLab] = "В лаборатории ученые изучают планету и собирают нужные ресурсы.";
		BuildingDesc[BuildingTypeMissile] = "Наносит урон вражеским кораблям на орбите планеты.";
		BuildingDesc[BuildingTypeTerraform] = "Терраморфирует планету, что обеспечивает разворачивание нужного направления производства.";
		BuildingDesc[BuildingTypeStorage] = "Обеспечивает хранение ресурсов на планете.";
		BuildingDesc[BuildingTypeXenon] = "Добывает ксенон из недр планеты.";
		BuildingDesc[BuildingTypeTitan] = "Добывает титан из ильменитового месторождения.";
		BuildingDesc[BuildingTypeSilicon] = "Добывает кремний из кварцитного месторождения.";
		BuildingDesc[BuildingTypeCrystal] = "Добывает антикристаллы из кристаллических разломов.";
		BuildingDesc[BuildingTypeFarm] = "Производит продовольствие.";
		BuildingDesc[BuildingTypeElectronics] = "Производит электронику.";
		BuildingDesc[BuildingTypeMetal] = "Производит металл.";
		BuildingDesc[BuildingTypeAntimatter] = "Производит антиматерию.";
		BuildingDesc[BuildingTypePlasma] = "Производит плазму.";
		BuildingDesc[BuildingTypeCity] = "Обеспечивает проживание большому количеству населения.";
		BuildingDesc[BuildingTypeModule] = "Производит сборку модулей.";
		BuildingDesc[BuildingTypeTech] = "Производит кварковые ядра.";
		BuildingDesc[BuildingTypeFuel] = "Производит топливо.";
		BuildingDesc[BuildingTypePower] = "Производит все виды усилителей.";
		BuildingDesc[BuildingTypeArmour] = "Производит все виды брони.";
		BuildingDesc[BuildingTypeDroid] = "Производит все виды дроидов.";
		BuildingDesc[BuildingTypeMachinery] = "Производит технику, которая используется для снабжения планет.";
		BuildingDesc[BuildingTypeEngineer] = "Обучает инженеров, которые обеспечивают работу всех зданий на планетах.";
		BuildingDesc[BuildingTypeMine] = "Производит орбитальные мины.";
		BuildingDesc[BuildingTypeTechnician] = "Готовит механиков, которые эффективно управляют флотом.";
		BuildingDesc[BuildingTypeNavigator] = "Готовит навигаторов, которые эффективно управляют флотом.";

		TechName[TechProgress]="Развитие";
		TechName[TechEconomy]="Экономика";
		TechName[TechTransport]="Транспорт";
		TechName[TechCorvette]="Корвет";
		TechName[TechCruiser]="Крейсер";
		TechName[TechDreadnought]="Дредноут";
		TechName[TechInvader]="Штурмовик";
		TechName[TechDevastator]="Девастатор";
		TechName[TechWarBase]="Военная база";
		TechName[TechShipyard]="Верфь";
		TechName[TechSciBase] = "Научная станция";
		TechName[TechQuarkBase]="Разрушитель";
		
		DirName[DirEmpireMax]="Образование"; // Агрокультура Образование
		DirName[DirEnclaveMax]="Патриотизм";
		DirName[DirColonyMax]="Воинственность";
		//DirName[DirPlanetLevelMax]="Индустриализация";
		DirName[DirShipMassMax] = "Логистика";// "Индустриализация";
		DirName[DirShipSpeed]="Двигатели";
		DirName[DirPlanetProtect]="Оборона";
		DirName[DirCaptureSlow]="Сопротивление";

//		DirName[DirModuleSpeed]="Нанокомпьютеры"; // Компьютеры	
//		DirName[DirResSpeed]="Роботостроение"; // Mining
//		DirName[DirSupplyNormal]="Логистика";
//		DirName[DirSupplyMuch]="Полиция";
//		DirName[DirModuleMax]="Хранение";
//		DirName[DirResMax]="Переработка";// Очищение "Переработка" "Хранилища";
//		DirName[DirCitadelCost]="Экспансия";
//		DirName[DirPlanetLavelCost]="Менеджмент";

		DirName[DirTransportPrice]="Оптимизация";
		DirName[DirTransportCnt]="Построение";
		//DirName[DirTransportSupply]="Износостойкость";
		DirName[DirTransportMass]="Минимизация";
//		DirName[DirTransportFuel]="Топливные баки";
		DirName[DirTransportArmour]="Броня";
		DirName[DirTransportWeapon]="Орудия";
		DirName[DirTransportCargo]="Трюм";

		DirName[DirCorvettePrice]="Оптимизация";
		DirName[DirCorvetteCnt]="Построение";
		//DirName[DirCorvetteSupply]="Износостойкость";
		DirName[DirCorvetteMass]="Минимизация";
//		DirName[DirCorvetteFuel]="Топливные баки";
		DirName[DirCorvetteArmour]="Броня";
		DirName[DirCorvetteWeapon]="Орудия";
		DirName[DirCorvetteAccuracy]="Точность";
		DirName[DirCorvetteStealth]="Невидимость";

		DirName[DirCruiserAccess]="Крейсер";
		DirName[DirCruiserPrice]="Оптимизация";
		DirName[DirCruiserCnt]="Построение";
		//DirName[DirCruiserSupply]="Износостойкость";
		DirName[DirCruiserMass]="Минимизация";
//		DirName[DirCruiserFuel]="Топливные баки";
		DirName[DirCruiserArmour]="Броня";
		DirName[DirCruiserWeapon]="Орудия";
		DirName[DirCruiserAccuracy]="Точность";

		DirName[DirDreadnoughtAccess]="Дредноут";
		DirName[DirDreadnoughtPrice]="Оптимизация";
		DirName[DirDreadnoughtCnt]="Построение";
		//DirName[DirDreadnoughtSupply]="Износостойкость";
		DirName[DirDreadnoughtMass]="Минимизация";
//		DirName[DirDreadnoughtFuel]="Топливные баки";
		DirName[DirDreadnoughtArmour]="Броня";
		DirName[DirDreadnoughtWeapon]="Орудия";
		DirName[DirDreadnoughtAccuracy]="Точность";

		DirName[DirInvaderPrice]="Оптимизация";
		DirName[DirInvaderCnt]="Построение";
		//DirName[DirInvaderSupply]="Износостойкость";
		DirName[DirInvaderMass]="Минимизация";
//		DirName[DirInvaderFuel]="Топливные баки";
		DirName[DirInvaderArmour]="Броня";
		DirName[DirInvaderWeapon]="Орудия";
		DirName[DirInvaderCaptureSpeed]="Бомбы";

		DirName[DirDevastatorAccess]="Строительство девастаторов";
		DirName[DirDevastatorPrice]="Оптимизация";
		DirName[DirDevastatorCnt]="Построение";
		//DirName[DirDevastatorSupply]="Износостойкость";
		DirName[DirDevastatorMass]="Минимизация";
//		DirName[DirDevastatorFuel]="Топливные баки";
		DirName[DirDevastatorArmour]="Броня";
		DirName[DirDevastatorWeapon]="Ракеты";
		DirName[DirDevastatorAccuracy]="Точность";
		DirName[DirDevastatorBomb]="Аннигиляция";

		DirName[DirWarBaseAccess]="Военная база";
		DirName[DirWarBasePrice]="Оптимизация";
		DirName[DirWarBaseCnt]="Построение";
		//DirName[DirWarBaseSupply]="Износостойкость";
		DirName[DirWarBaseMass]="Минимизация";
		DirName[DirWarBaseArmour]="Броня";
		DirName[DirWarBaseAccuracy]="Точность";
		DirName[DirWarBaseRepair]="Ремонт";
		DirName[DirWarBaseArmourAll]="Отражение";

		DirName[DirShipyardAccess]="Верфь";
		DirName[DirShipyardPrice]="Оптимизация";
		DirName[DirShipyardCnt]="Построение";
		//DirName[DirShipyardSupply]="Износостойкость";
		DirName[DirShipyardMass]="Минимизация";
		DirName[DirShipyardArmour]="Броня";
		DirName[DirShipyardAccuracy]="Точность";
		DirName[DirShipyardRepair]="Ремонт";
		DirName[DirShipyardRepairAll]="Бригада дроидов";

		DirName[DirSciBaseAccess]="Научная станция";
		DirName[DirSciBasePrice]="Оптимизация";
		DirName[DirSciBaseCnt]="Построение";
		//DirName[DirSciBaseSupply]="Износостойкость";
		DirName[DirSciBaseMass]="Минимизация";
		DirName[DirSciBaseArmour]="Броня";
		DirName[DirSciBaseAccuracy]="Точность";
		DirName[DirSciBaseRepair]="Ремонт";
		DirName[DirSciBaseStabilizer] = "Улучшенный стабилизатор";
		
		DirName[DirQuarkBaseAccess]="Гравитационный разрушитель";
//		DirName[DirQuarkBaseMass]="Минимизация";
		DirName[DirQuarkBaseWeapon]="Орудия";
		DirName[DirQuarkBaseAccuracy]="Точность";
		DirName[DirQuarkBaseArmour]="Броня";
		DirName[DirQuarkBaseRepair]="Ремонт";
		DirName[DirQuarkBaseAntiGravitor]="Гравитационный стабилизатор";
		DirName[DirQuarkBaseGravWell]="Гравитационный колодец";
		DirName[DirQuarkBaseBlackHole]="Миниатюрная черная дыра";
		DirName[DirQuarkBaseHP] = "Структура";
		DirName[DirQuarkBaseShield] = "Щит";
		DirName[DirQuarkBaseShieldReduce] = "Рассеивание";
		DirName[DirQuarkBaseShieldInc] = "Регенерация";
		DirName[DirQuarkBaseAntiShield]="Инвариатор";

		DirPar[DirEmpireMax]="Максимальное количество планет в империи";
		DirPar[DirEnclaveMax]="Максимальное количество планет в анклаве";
		DirPar[DirColonyMax]="Максимальное количество колониальных планет";
		//DirPar[DirPlanetLevelMax]="Максимальная инфраструктура планет";
		DirPar[DirShipMassMax]="Максимальная масса кораблей";
		DirPar[DirShipSpeed]="Скорость кораблей";
		DirPar[DirPlanetProtect]="Броня кораблей возле планет империи";
		DirPar[DirCaptureSlow]="Сопротивление захвату планет";

		DirPar[DirModuleSpeed]="Скорость производства модулей";	
		DirPar[DirResSpeed]="Добыча ресурсов";
		DirPar[DirSupplyNormal]="Эффективное снабжение до";
		DirPar[DirSupplyMuch]="Удвоенное снабжение после";
		DirPar[DirModuleMax]="Максимальное количество модулей";
		DirPar[DirResMax]="Максимальное количество ресурсов";
		DirPar[DirCitadelCost]="Стоимость основания цитадели";
		DirPar[DirPlanetLavelCost]="Стоимость инфраструктуры";

		DirPar[DirTransportPrice]="Стоимость";
		DirPar[DirTransportCnt]="Предел кораблей в звене";
		//DirPar[DirTransportSupply]="Снабжение";
		DirPar[DirTransportMass]="Масса";
//		DirPar[DirTransportFuel]="Максимальный запас топлива";
		DirPar[DirTransportArmour]="Броня";
		DirPar[DirTransportWeapon]="Ударная сила";
		DirPar[DirTransportCargo]="Объем перевозимых грузов";

		DirPar[DirCorvettePrice]="Стоимость";
		DirPar[DirCorvetteCnt]="Предел кораблей в звене";
		//DirPar[DirCorvetteSupply]="Снабжение";
		DirPar[DirCorvetteMass]="Масса";
//		DirPar[DirCorvetteFuel]="Максимальный запас топлива";
		DirPar[DirCorvetteArmour]="Броня";
		DirPar[DirCorvetteWeapon]="Ударная сила";
		DirPar[DirCorvetteAccuracy]="Ударная сила";
		DirPar[DirCorvetteStealth]="";

		DirPar[DirCruiserAccess]="";
		DirPar[DirCruiserPrice]="Стоимость";
		DirPar[DirCruiserCnt]="Предел кораблей в звене";
		//DirPar[DirCruiserSupply]="Снабжение";
		DirPar[DirCruiserMass]="Масса";
//		DirPar[DirCruiserFuel]="Максимальный запас топлива";
		DirPar[DirCruiserArmour]="Броня";
		DirPar[DirCruiserWeapon]="Ударная сила";
		DirPar[DirCruiserAccuracy]="Ударная сила";

		DirPar[DirDreadnoughtAccess]="";
		DirPar[DirDreadnoughtPrice]="Стоимость";
		DirPar[DirDreadnoughtCnt]="Предел кораблей в звене";
		//DirPar[DirDreadnoughtSupply]="Снабжение";
		DirPar[DirDreadnoughtMass]="Масса";
//		DirPar[DirDreadnoughtFuel]="Максимальный запас топлива";
		DirPar[DirDreadnoughtArmour]="Броня";
		DirPar[DirDreadnoughtWeapon]="Ударная сила";
		DirPar[DirDreadnoughtAccuracy]="Ударная сила";

		DirPar[DirInvaderPrice]="Стоимость";
		DirPar[DirInvaderCnt]="Предел кораблей в звене";
		//DirPar[DirInvaderSupply]="Снабжение";
		DirPar[DirInvaderMass]="Масса";
//		DirPar[DirInvaderFuel]="Максимальный запас топлива";
		DirPar[DirInvaderArmour]="Броня";
		DirPar[DirInvaderWeapon]="Ударная сила";
		DirPar[DirInvaderCaptureSpeed]="Скорость захвата";

		DirPar[DirDevastatorAccess]="";
		DirPar[DirDevastatorPrice]="Стоимость";
		DirPar[DirDevastatorCnt]="Предел кораблей в звене";
		//DirPar[DirDevastatorSupply]="Снабжение";
		DirPar[DirDevastatorMass]="Масса";
//		DirPar[DirDevastatorFuel]="Максимальный запас топлива";
		DirPar[DirDevastatorArmour]="Броня";
		DirPar[DirDevastatorWeapon]="Ударная сила";
		DirPar[DirDevastatorAccuracy]="Ударная сила";

		DirPar[DirWarBaseAccess]="";
		DirPar[DirWarBasePrice]="Стоимость";
		DirPar[DirWarBaseCnt]="Предел баз в звене";
		//DirPar[DirWarBaseSupply]="Снабжение";
		DirPar[DirWarBaseMass]="Масса";
		DirPar[DirWarBaseArmour]="Броня";
		DirPar[DirWarBaseAccuracy]="Ударная сила";
		DirPar[DirWarBaseRepair]="Ремонт";
		DirPar[DirWarBaseArmourAll]="Броня всех кораблей на орбите";

		DirPar[DirShipyardAccess]="";
		DirPar[DirShipyardPrice]="Стоимость";
		DirPar[DirShipyardCnt]="Предел верфей в звене";
		//DirPar[DirShipyardSupply]="Снабжение";
		DirPar[DirShipyardMass]="Масса";
		DirPar[DirShipyardArmour]="Броня";
		DirPar[DirShipyardAccuracy]="Ударная сила";
		DirPar[DirShipyardRepair]="Ремонт";
		DirPar[DirShipyardRepairAll]="Ремонт всех кораблей на орбите";

		DirPar[DirSciBaseAccess]="";
		DirPar[DirSciBasePrice]="Стоимость";
		DirPar[DirSciBaseCnt]="Предел баз в звене";
		//DirPar[DirSciBaseSupply]="Снабжение";
		DirPar[DirSciBaseMass]="Масса";
		DirPar[DirSciBaseArmour]="Броня";
		DirPar[DirSciBaseAccuracy]="Ударная сила";
		DirPar[DirSciBaseRepair]="Ремонт";
		DirPar[DirSciBaseStabilizer]="Потребление протоплазмы";

		DirParSuf[DirEmpireMax]="";
		DirParSuf[DirEnclaveMax]="";
		DirParSuf[DirColonyMax]="";
		DirParSuf[DirPlanetLevelMax] = "";
		DirParSuf[DirShipMassMax]="";
		DirParSuf[DirShipSpeed]="%";
		DirParSuf[DirPlanetProtect]="%";
		DirParSuf[DirCaptureSlow]="%";

//		DirParSuf[DirModuleSpeed]="%";	
//		DirParSuf[DirResSpeed]="%";
//		DirParSuf[DirSupplyNormal]=" кораблей";
//		DirParSuf[DirSupplyMuch]=" кораблей";
//		DirParSuf[DirModuleMax]="";
//		DirParSuf[DirResMax]="";
//		DirParSuf[DirCitadelCost]="";
//		DirParSuf[DirPlanetLavelCost]="";

		DirParSuf[DirTransportPrice]="";
		DirParSuf[DirTransportCnt]="";
		//DirParSuf[DirTransportSupply]="%";
		DirParSuf[DirTransportMass]="";
//		DirParSuf[DirTransportFuel]="";
		DirParSuf[DirTransportArmour]="%";
		DirParSuf[DirTransportWeapon]="";
		DirParSuf[DirTransportCargo]="";

		DirParSuf[DirCorvettePrice]="";
		DirParSuf[DirCorvetteCnt]="";
		//DirParSuf[DirCorvetteSupply]="%";
		DirParSuf[DirCorvetteMass]="";
//		DirParSuf[DirCorvetteFuel]="";
		DirParSuf[DirCorvetteArmour]="%";
		DirParSuf[DirCorvetteWeapon]="";
		DirParSuf[DirCorvetteAccuracy]="%";
		DirParSuf[DirCorvetteStealth]="";

		DirParSuf[DirCruiserAccess]="";
		DirParSuf[DirCruiserPrice]="";
		DirParSuf[DirCruiserCnt]="";
		//DirParSuf[DirCruiserSupply] = "%";
		DirParSuf[DirCruiserMass] = "";
//		DirParSuf[DirCruiserFuel]="";
		DirParSuf[DirCruiserArmour]="%";
		DirParSuf[DirCruiserWeapon]="";
		DirParSuf[DirCruiserAccuracy]="%";

		DirParSuf[DirDreadnoughtAccess]="";
		DirParSuf[DirDreadnoughtPrice]="";
		DirParSuf[DirDreadnoughtCnt]="";
		//DirParSuf[DirDreadnoughtSupply]="%";
		DirParSuf[DirDreadnoughtMass]="";
//		DirParSuf[DirDreadnoughtFuel]="";
		DirParSuf[DirDreadnoughtArmour]="%";
		DirParSuf[DirDreadnoughtWeapon]="";
		DirParSuf[DirDreadnoughtAccuracy]="%";

		DirParSuf[DirInvaderPrice]="";
		DirParSuf[DirInvaderCnt]="";
		//DirParSuf[DirInvaderSupply]="%";
		DirParSuf[DirInvaderMass]="";
//		DirParSuf[DirInvaderFuel]="";
		DirParSuf[DirInvaderArmour]="%";
		DirParSuf[DirInvaderWeapon]="";
		DirParSuf[DirInvaderCaptureSpeed]="%";

		DirParSuf[DirDevastatorAccess]="";
		DirParSuf[DirDevastatorPrice]="";
		DirParSuf[DirDevastatorCnt]="";
		//DirParSuf[DirDevastatorSupply]="%";
		DirParSuf[DirDevastatorMass]="";
//		DirParSuf[DirDevastatorFuel]="";
		DirParSuf[DirDevastatorArmour]="%";
		DirParSuf[DirDevastatorWeapon]="";
		DirParSuf[DirDevastatorAccuracy]="%";

		DirParSuf[DirWarBaseAccess]="";
		DirParSuf[DirWarBasePrice]="";
		DirParSuf[DirWarBaseCnt]="";
		//DirParSuf[DirWarBaseSupply]="%";
		DirParSuf[DirWarBaseMass]="";
		DirParSuf[DirWarBaseArmour]="%";
		DirParSuf[DirWarBaseAccuracy]="%";
		DirParSuf[DirWarBaseRepair]="";
		DirParSuf[DirWarBaseArmourAll]="%";

		DirParSuf[DirShipyardAccess]="";
		DirParSuf[DirShipyardPrice]="";
		DirParSuf[DirShipyardCnt]="";
		//DirParSuf[DirShipyardSupply] = "%";
		DirParSuf[DirShipyardMass] = "%";
		DirParSuf[DirShipyardArmour]="%";
		DirParSuf[DirShipyardAccuracy]="%";
		DirParSuf[DirShipyardRepair]="";
		DirParSuf[DirShipyardRepairAll]="";

		DirParSuf[DirSciBaseAccess]="";
		DirParSuf[DirSciBasePrice]="";
		DirParSuf[DirSciBaseCnt]="";
		//DirParSuf[DirSciBaseSupply]="%";
		DirParSuf[DirSciBaseArmour]="%";
		DirParSuf[DirSciBaseAccuracy]="%";
		DirParSuf[DirSciBaseRepair]="";
		DirParSuf[DirSciBaseStabilizer]="%";

		DirEmpireMaxDesc.push("Империя может состоять из <Val> планет.");
		DirEnclaveMaxDesc.push("Анклав может состоять из <Val> планет.");
		DirColonyMaxDesc.push("Вы можете иметь <Val> колониальных планет.");
		//DirPlanetLevelMaxDesc.push("Инфраструктура планет может быть развита до <Val> уровня.");
		//DirShipMassMaxDesc.push("Каждая планета в империи или анклаве[br]может содержать до <Val> кт кораблей.");
		DirShipMassMaxDesc.push("Каждая планета в империи/анклаве может содержать до <Val>/<Val2> кт[br]кораблей-атаки и <Val3> кт кораблей-обороны.");
		DirShipSpeedDesc.push("Корабли развивают <Val>% скорость.");
		DirPlanetProtectDesc.push("Планеты вашей империи не защищают ваши корабли.");
		DirPlanetProtectDesc.push("Планеты вашей империи дают <Val>% брони вашим кораблям.");
		DirCaptureSlowDesc.push("У планет вашей империи нет оборонительных систем.");
		DirCaptureSlowDesc.push("Захватывать планеты вашей империи противник будет дольше на <Val>%.");

//		DirModuleSpeedDesc.push("Планеты производят модули раз в <Val> секунд.");	
//		DirResSpeedDesc.push("Добыча ресурсов составляет <Val>%.");
//		DirSupplyNormalDesc.push("Эффективное снабжение до <Val> кораблей.");
//		DirSupplyMuchDesc.push("Удвоенное снабжение после <Val> кораблей.");
//		DirModuleMaxDesc.push("Склады обычных планеты вмещают <Val> модулей.\nСклады столицы и цитадели вмещают  <Val2> модулей.");
//		DirResMaxDesc.push("Планеты могут хранить <Val> ресурсов каждого типа.");
//		DirCitadelCostDesc.push("Цитадель можно основать за <Val> ресурсов каждого типа.");
//		DirPlanetLavelCostDesc.push("Постройка инфраструктуры стоит <Val> модулей.");

		DirTransportPriceDesc.push("Для постройки транспорта требуется <Val> модулей.");
		DirTransportCntDesc.push("В звене может находиться до <Val> транспортов.");
		DirTransportMassDesc.push("Масса транспорта составляет <Val> кт.");
		DirTransportArmourDesc.push("Броня транспортов не уменьшает полученный урон.");
		DirTransportArmourDesc.push("Броня транспортов уменьшает полученный урон на <Val>%.");
		DirTransportWeaponDesc.push("Транспорт не наносит урон.");
		DirTransportWeaponDesc.push("Транспорт наносит <Val> урона в секунду.");
		DirTransportCargoDesc.push("Транспорт может перевозить до <Val> ед. товара.");

		DirCorvettePriceDesc.push("Для постройки корвета требуется <Val> модулей.");
		DirCorvetteCntDesc.push("В звене может находиться до <Val> корветов.");
		DirCorvetteMassDesc.push("Масса корвета составляет <Val> кт.");
		//DirCorvetteArmourDesc.push("Броня корветов не уменьшает полученный урон.");
		DirCorvetteArmourDesc.push("Броня корветов уменьшает полученный урон на <Val>%.");
		DirCorvetteWeaponDesc.push("Корвет наносит <Val> урона в секунду.");
		//DirCorvetteAccuracyDesc.push("Ударная сила корветов не увеличивается.");
		DirCorvetteAccuracyDesc.push("Ударная сила корветов увеличивается на <Val>%.");
		DirCorvetteStealthDesc.push("Технология невидимости корветов - <font color='#ffff00'>не изучена</font>.");
		DirCorvetteStealthDesc.push("Технология невидимости корветов - <font color='#ffff00'>изучена</font>.");

		DirCruiserAccessDesc.push("Технология строительства крейсеров - <font color='#ffff00'>не изучена</font>.");
		DirCruiserAccessDesc.push("Технология строительства крейсеров - <font color='#ffff00'>изучена</font>.");
		DirCruiserPriceDesc.push("Для постройки крейсера требуется <Val> модулей.");
		DirCruiserCntDesc.push("В звене может находиться до <Val> крейсеров.");
		DirCruiserMassDesc.push("Масса крейсера составляет <Val> кт.");
		//DirCruiserArmourDesc.push("Броня крейсеров не уменьшает полученный урон.");
		DirCruiserArmourDesc.push("Броня крейсеров уменьшает полученный урон на <Val>%.");
		DirCruiserWeaponDesc.push("Крейсер наносит <Val> урона в секунду.");
		//DirCruiserAccuracyDesc.push("Ударная сила крейсеров не увеличивается.");
		DirCruiserAccuracyDesc.push("Ударная сила крейсеров увеличивается на <Val>%.");

		DirDreadnoughtAccessDesc.push("Технология строительства дредноутов - <font color='#ffff00'>не изучена</font>.");
		DirDreadnoughtAccessDesc.push("Технология строительства дредноутов - <font color='#ffff00'>изучена</font>.");
		DirDreadnoughtPriceDesc.push("Для постройки дредноута требуется <Val> модулей.");
		DirDreadnoughtCntDesc.push("В звене может находиться до <Val> дредноутов.");
		DirDreadnoughtMassDesc.push("Масса дредноута составляет <Val> кт.");
		//DirDreadnoughtArmourDesc.push("Броня дредноутов не уменьшает полученный урон.");
		DirDreadnoughtArmourDesc.push("Броня дредноутов уменьшает полученный урон на <Val>%.");
		DirDreadnoughtWeaponDesc.push("Дредноут наносит <Val> урона в секунду.");
		//DirDreadnoughtAccuracyDesc.push("Ударная сила дредноутов не увеличивается.");
		DirDreadnoughtAccuracyDesc.push("Ударная сила дредноутов увеличивается на <Val>%.");

		DirInvaderPriceDesc.push("Для постройки штурмовика требуется <Val> модулей.");
		DirInvaderCntDesc.push("В звене может находиться до <Val> штурмовиков.");
		DirInvaderMassDesc.push("Масса штурмовика составляет <Val> кт.");
		DirInvaderArmourDesc.push("Броня штурмовиков не уменьшает полученный урон.");
		DirInvaderArmourDesc.push("Броня штурмовиков уменьшает полученный урон на <Val>%.");
		DirInvaderWeaponDesc.push("Штурмовик не наносит урон.");
		DirInvaderWeaponDesc.push("Штурмовик наносит <Val> урона в секунду.");
		DirInvaderCaptureSpeedDesc.push("Захват планет осуществляется с <Val>% скоростью.");

		DirDevastatorAccessDesc.push("Технология строительства девастаторов - <font color='#ffff00'>не изучена</font>.");
		DirDevastatorAccessDesc.push("Технология строительства девастаторов - <font color='#ffff00'>изучена</font>.");
		DirDevastatorPriceDesc.push("Для постройки девастатора требуется <Val> модулей.");
		DirDevastatorCntDesc.push("В звене может находиться до <Val> девастаторов.");
		DirDevastatorMassDesc.push("Масса девастатора составляет <Val> кт.");
		DirDevastatorArmourDesc.push("Броня девастаторов не уменьшает полученный урон.");
		DirDevastatorArmourDesc.push("Броня девастаторов уменьшает полученный урон на <Val>%.");
		DirDevastatorWeaponDesc.push("Девастатор наносит <Val> урона в секунду.");
		DirDevastatorAccuracyDesc.push("Ракеты девастаторов попадают в цель с <Val2>% вероятностью.");
		DirDevastatorAccuracyDesc.push("Ударная сила девастаторов увеличивается на <Val>%,\nпри этом ракеты попадают в цель с <Val2>% вероятностью.");
		DirDevastatorBombDesc.push("Аннигилирование одного девастатора ведет к\nповреждению <Val> ед. структуры у всех кораблей на орбите.");

		DirWarBaseAccessDesc.push("Технология строительства военных баз - <font color='#ffff00'>не изучена</font>.");
		DirWarBaseAccessDesc.push("Технология строительства военных баз - <font color='#ffff00'>изучена</font>.");
		DirWarBasePriceDesc.push("Для постройки военной базы требуется <Val> модулей.");
		DirWarBaseCntDesc.push("В звене может находиться до <Val> военных баз.");
		DirWarBaseMassDesc.push("Масса военной базы составляет <Val> кт.");
		//DirWarBaseArmourDesc.push("Броня военных баз не уменьшает полученный урон.");
		DirWarBaseArmourDesc.push("Броня военных баз уменьшает полученный урон на <Val>%.");
		//DirWarBaseAccuracyDesc.push("Ударная сила военных баз не увеличивается.");
		DirWarBaseAccuracyDesc.push("Ударная сила военных баз увеличивается на <Val>%.");
		DirWarBaseRepairDesc.push("Военной базой ремонтируется <Val> структуры в секунду\nво время битвы и <Val2> - вне битвы.");
		DirWarBaseArmourAllDesc.push("Корабли на орбите не получают дополнительную броню.");
		DirWarBaseArmourAllDesc.push("Все Ваши корабли на орбите получают дополнительно <Val>% брони.");

		DirShipyardAccessDesc.push("Технология строительства верфей - <font color='#ffff00'>не изучена</font>.");
		DirShipyardAccessDesc.push("Технология строительства верфей - <font color='#ffff00'>изучена</font>.");
		DirShipyardPriceDesc.push("Для постройки верфи требуется <Val> модулей.");
		DirShipyardCntDesc.push("В звене может находиться до <Val> верфей.");
		//DirShipyardSupplyDesc.push("Для снабжения верфи требуется <Val>% ресурсов.");
		DirShipyardMassDesc.push("Масса верфи составляет <Val> кт.");
		DirShipyardArmourDesc.push("Броня верфей не уменьшает полученный урон.");
		DirShipyardArmourDesc.push("Броня верфей уменьшает полученный урон на <Val>%.");
		DirShipyardAccuracyDesc.push("Ударная сила верфей не увеличивается.");
		DirShipyardAccuracyDesc.push("Ударная сила верфей увеличивается на <Val>%.");
		DirShipyardRepairDesc.push("Верфь ремонтирует <Val> структуры в секунду\nво время битвы и <Val2> - вне битвы.");
		DirShipyardRepairAllDesc.push("Верфь не ремонтирует корабли на орбите.");
		DirShipyardRepairAllDesc.push("Верфь ремонтирует <Val> структуры в секунду у всех ваших\nкораблей на орбите во время битвы и <Val2> - вне битвы.\nСкорость ремонта баз в 16 раз меньше.");

		DirSciBaseAccessDesc.push("Технология строительства научных станций - <font color='#ffff00'>не изучена</font>.");
		DirSciBaseAccessDesc.push("Технология строительства научных станций - <font color='#ffff00'>изучена</font>.");
		DirSciBasePriceDesc.push("Для постройки научной базы требуется <Val> модулей.");
		DirSciBaseCntDesc.push("В звене может находиться до <Val> научных станций.");
		//DirSciBaseSupplyDesc.push("Для снабжения научных станций требуется <Val>% ресурсов.");
		DirSciBaseMassDesc.push("Масса научной станции составляет <Val> кт.");
		DirSciBaseArmourDesc.push("Броня научных станций не уменьшает полученный урон.");
		DirSciBaseArmourDesc.push("Броня научных станций уменьшает полученный урон на <Val>%.");
		DirSciBaseAccuracyDesc.push("Ударная сила научных станций не увеличивается.");
		DirSciBaseAccuracyDesc.push("Ударная сила научных станций увеличивается на <Val>%.");
		DirSciBaseRepairDesc.push("Научная станция ремонтирует <Val> структуры в секунду\nво время битвы и <Val2> - вне битвы.");
		DirSciBaseStabilizerDesc.push("Стабилизатор потребляет <Val>% протоплазмы.");

		DirQuarkBaseAccessDesc.push("Технология строительства разрушителя - [clr]не изучена[/clr].");
		DirQuarkBaseAccessDesc.push("Технология строительства разрушителя - [clr]изучена[/clr].");
//		DirQuarkBaseMassDesc.push("Масса разрушителя составляет <Val> кт.");
		DirQuarkBaseWeaponDesc.push("Разрушитель наносит <Val> урона в секунду.");
		DirQuarkBaseAccuracyDesc.push("Ударная сила разрушителя не увеличивается.");
		DirQuarkBaseAccuracyDesc.push("Ударная сила разрушителя увеличивается на <Val>%.");
		DirQuarkBaseArmourDesc.push("Броня разрушителя не уменьшает полученный урон.");
		DirQuarkBaseArmourDesc.push("Броня разрушителя уменьшает полученный урон на <Val>%.");
		DirQuarkBaseRepairDesc.push("Разрушитель ремонтирует <Val> структуры в секунду\nво время битвы и <Val2> - вне битвы.");
		DirQuarkBaseAntiGravitorDesc.push("Технология гравитационной стабилизации - [clr]не изучена[/clr].");
		DirQuarkBaseAntiGravitorDesc.push("Разрушитель стабилизирует гравитационное поле раз в <Val> минут.");
		DirQuarkBaseGravWellDesc.push("Технология гравитационного колодца - [clr]не изучена[/clr].");
		DirQuarkBaseGravWellDesc.push("Разрушитель создает гравитационный колодец раз в <Val> минут.");
		DirQuarkBaseBlackHoleDesc.push("Технология миниатюрных черных дыр - [clr]не изучена[/clr].");
		DirQuarkBaseBlackHoleDesc.push("Разрушитель создает миниатюрную черную дыру раз в <Val> минут.");
		DirQuarkBaseHPDesc.push("Разрушитель может выдерживать\n <Val> ед. повреждений.");
		DirQuarkBaseShieldDesc.push("Энергетическое поле блокирует\n <Val> ед. повреждений.");
		DirQuarkBaseShieldReduceDesc.push("Энергетическое поле получает максимальный урон.");
		DirQuarkBaseShieldReduceDesc.push("Урон энергетическому полю уменьшается на <Val>%.");
		DirQuarkBaseShieldIncDesc.push("Энергетическое поле восстанавливает <Val> ед. в секунду\nВ режиме поляризации щита: <Val2> ед. в секунду.");
		DirQuarkBaseAntiShieldDesc.push("Технология инвариатор - [clr]не изучена[/clr].");
		DirQuarkBaseAntiShieldDesc.push("Разрушитель переносит на себя протонный щит с цели, раз в <Val> минут.");

		TalentName[TalentMove] = "Движение";
		TalentName[TalentDef] = "Защита";
		TalentName[TalentAtc] = "Атака";
		TalentName[TalentSys] = "Системы";
		
		VecName[VecMoveSpeed]="Двигатель";
//		VecName[VecMoveFuel]="Топливный бак";
		VecName[VecMoveIntercept]="Перехват";
		VecName[VecMoveAccelerator]="Ускорение";
		VecName[VecMovePortal]="Портал";
		VecName[VecMoveRadar]="Радар";
		VecName[VecMoveCover]="Прикрытие";
		VecName[VecMoveExchange]="Квантовый переход";

		VecName[VecProtectHP]="Структура";
		VecName[VecProtectArmour]="Броня";
		VecName[VecProtectShield]="Щит";
		VecName[VecProtectShieldInc]="Регенерация";
		VecName[VecProtectShieldReduce]="Рассеивание";
		VecName[VecProtectInvulnerability]="Протонный щит";
		VecName[VecProtectRepair] = "Ремонт";
		VecName[VecProtectAntiExchange]="Квантовый якорь";

		VecName[VecAttackCannon]="Пушка";
		VecName[VecAttackLaser]="Лазер";
		VecName[VecAttackMissile]="Ракеты";
		VecName[VecAttackAccuracy]="Точность";
		VecName[VecAttackMine]="Мины";
		VecName[VecAttackTransiver]="Трансивер";
		
		VecName[VecSystemSensor]="Сенсор";
		VecName[VecSystemStealth]="Невидимость";
		VecName[VecSystemRecharge]="Зарядник";
		VecName[VecSystemHacker]="Хакерство";
		VecName[VecSystemJummer]="Глушак";
		VecName[VecSystemDisintegrator]="Ресинхронизатор";
		VecName[VecSystemConstructor]="Конструктор";

		VecName[VecMoveGravitor]="Гравитор";

		VecMoveSpeedDesc.push("Флагман развивает <Val>% скорость.");
//		VecMoveFuelDesc.push("Флагман может иметь запас топлива до <Val> ед.");
		VecMoveInterceptDesc.push("Вражеские корабли могут покинуть орбиту боя.");
		VecMoveInterceptDesc.push("Вражеские корабли без прикрытия или ускорения\nне могут покинуть орбиту боя за исключением\nорбит звезд.");
		VecMoveAcceleratorDesc.push("Флагман не может покинуть орбиту боя.");
		VecMoveAcceleratorDesc.push("Флагман может покинуть орбиту боя раз в <Val> минут.");
		VecMoveAcceleratorDesc.push("Флагман может покинуть орбиту боя раз в <Val> минут.\nА также преодолевать гравитационные возмущения.");
		VecMovePortalDesc.push("Технология портала - <font color='#ffff00'>не изучена</font>.");
		VecMovePortalDesc.push("Флагман может открыть портал раз в <font color='#ffff00'>30</font> минут\nи быстро перебросить <Val> кораблей.");
		VecMoveRadarDesc.push("Технология радара - <font color='#ffff00'>не изучена</font>.");
		VecMoveRadarDesc.push("Радар флагмана может обнаружить корабли, преодолевая помехи до <Val> уровня.");
		VecMoveCoverDesc.push("Флагман не может прикрыть корабли.");
		VecMoveCoverDesc.push("Флагман может прикрыть звено кораблей, чтобы оно[br]раз в <Val> минут могло покинуть орбиту боя.");
		VecMoveExchangeDesc.push("Квантовый переход - <font color='#ffff00'>не изучен</font>.");
		VecMoveExchangeDesc.push("Раз в <font color='#ffff00'>30</font> минут может мгновенно обменять Ваши корабли на\nвражеские корабли, находящиеся на другой планете.");

		VecProtectHPDesc.push("Флагман может выдерживать\nдополнительно <Val> ед. повреждений.");
		VecProtectArmourDesc.push("Броня флагмана не уменьшает полученный урон.");
		VecProtectArmourDesc.push("Броня флагмана уменьшает полученный урон на <Val>%.");
		VecProtectShieldDesc.push("Энергетическое поле блокирует\nдополнительно <Val> ед. повреждений.");
		VecProtectShieldIncDesc.push("Энергетическое поле восстанавливает <Val> ед. в секунду.\nВ режиме поляризации щита: <Val2> ед. в секунду.");
		VecProtectShieldReduceDesc.push("Энергетическое поле получает максимальный урон.");
		VecProtectShieldReduceDesc.push("Урон энергетическому полю уменьшается на <Val>%.");
		VecProtectInvulnerabilityDesc.push("Флагман не оснащен протонным щитом.");
		VecProtectInvulnerabilityDesc.push("При активации флагман становится\nнеуязвимым к повреждению на <font color='#ffff00'>2</font> минуты.");
		VecProtectInvulnerabilityDesc.push("При активации весь флот на орбите становится\nнеуязвимым к повреждению на <font color='#ffff00'>2</font> минуты.");
		VecProtectRepairDesc.push("Флагман не ремонтирует структуру.");
		VecProtectRepairDesc.push("Флагман ремонтирует <Val> структуры в секунду.");
		VecProtectAntiExchangeDesc.push("Квантовый якорь - <font color='#ffff00'>не изучен</font>.");
		VecProtectAntiExchangeDesc.push("Блокирует квантовые перемещения всех ваших флагманов.");

		VecAttackCannonDesc.push("У флагмана отсутствует пушка.");
		VecAttackCannonDesc.push("Пушка флагмана наносит <Val> урона в секунду.");
		VecAttackLaserDesc.push("У флагмана отсутствует лазер.");
		VecAttackLaserDesc.push("Лазер флагмана наносит  <Val> урона в секунду.");
		VecAttackMissileDesc.push("У флагмана отсутствуют ракеты.");
		VecAttackMissileDesc.push("Ракеты флагмана наносят <Val> урона в секунду.");
		VecAttackAccuracyDesc.push("Ударная сила флагмана не увеличивается.");
		VecAttackAccuracyDesc.push("Ударная сила всего вооружения флагмана увеличивается на <Val>%.");
		VecAttackMineDesc.push("Флагман не может устанавливать мины.");
		VecAttackMineDesc.push("Флагман может установить до <Val> мин в орбитальный слот.");
		VecAttackTransiverDesc.push("У флагмана отсутствует трансиверный лазер.");
		VecAttackTransiverDesc.push("Трансиверный лазер восстанавливает <Val> ед.\nнапряжения энергетического поля в секунду.\nВ режиме поляризации щита: <Val2> ед. в секунду.");

		VecSystemSensorDesc.push("Технология обнаружения мин - <font color='#ffff00'>не изучена</font>.");
		VecSystemSensorDesc.push("Флагман обнаруживает мины на дистанции <Val> орбитальных\nслотов, а также уничтожает вражеские мины из пушки\nили лазера с эффективностью <Val2> мин в секунду.[br]Флагманы на одной орбите обходят  <Val3>% мин.");
		VecSystemStealthDesc.push("Технология невидимости флагмана - <font color='#ffff00'>не изучена</font>.");
		VecSystemStealthDesc.push("Вне боя флагман невидим.");
		VecSystemStealthDesc.push("Вне боя флот невидим на орбите с флагманом.");
		VecSystemRechargeDesc.push("Технология зарядчика - <font color='#ffff00'>не изучена</font>.");
		VecSystemRechargeDesc.push("Раз в <font color='#ffff00'>10</font> минут зарядчик позволяет восстановить <Val> ед. напряжения щита.");
		VecSystemHackerDesc.push("Технология взлома систем кораблей - <font color='#ffff00'>не изучена</font>.");
		VecSystemHackerDesc.push("Каждую секунду <Val> кораблей из вражеского звена подвергаются[br]взлому бортовых систем. Что в свою очередь ведет к  [clr]15%[/clr] шансу[br]перехода кораблей под ваше командование.");
		VecSystemJummerDesc.push("Технология постановки помех - <font color='#ffff00'>не изучена</font>.");
		VecSystemJummerDesc.push("Генерирует помехи <Val> уровня, что препятствует обнаружению кораблей.");
		VecSystemDisintegratorDesc.push("Технология ресинхронизации - <font color='#ffff00'>не изучена</font>.");
		VecSystemDisintegratorDesc.push("Броня и рассеивание вражеских кораблей на\nорбите с флагманом падает на  <Val>%.");
		VecSystemConstructorDesc.push("Технология конструктора - <font color='#ffff00'>не изучена</font>.");
		VecSystemConstructorDesc.push("Раз в <font color='#ffff00'>10</font> минут можно разобрать как дружественные, так и вражеские\nкорабли для восстановления  <Val> структуры флагмана.");

		VecMoveGravitorDesc.push("У флагмана отсутствует гравитор.");
            VecMoveGravitorDesc.push("При активации гравитора раз в <Val> минут,\nна орбиту планеты в течение  <font color='#ffff00'><Val2></font> секунд\nне могут выйти корабли.");

		Txt.Build="Построить";

//		Hint.FirstNewHomeworld=
//			"<p align='center'><font size='+1' color='#ffff00'>На данный момент у вас нет империи.</font></p>"
//			+"<p align='center'>Для основания новой империи выберете подходящую нейтральную планету.</p>"
//			+"<br><p align='center'><font size='-1' color='#D0D0D0'>(Чтобы сделать это, кликнете кнопкой мышки на планете и выберите пункт \"Столица новой империи\")</font></p>";

		Hint.WaitBeginGame="Сервер подготавливается для начала новой игры.\nПожалуйста, подождите <Val> минут.";

		CotlBonusName[CotlBonusAntimatter] = "Антиматерия";
		CotlBonusName[CotlBonusMetal] = "Металл";
		CotlBonusName[CotlBonusElectronics] = "Электроника";
		CotlBonusName[CotlBonusProtoplasm] = "Протоплазма";
		CotlBonusName[CotlBonusNodes] = "Ноды";
		CotlBonusName[CotlBonusCorvetteArmour] = "Защита корветов";
		CotlBonusName[CotlBonusCorvetteAccuracy] = "Точность корветов";
		CotlBonusName[CotlBonusCruiserArmour] = "Защита крейсеров";
		CotlBonusName[CotlBonusCruiserAccuracy] = "Точность крейсеров";
		CotlBonusName[CotlBonusDreadnoughtArmour] = "Защита дредноутов";
		CotlBonusName[CotlBonusDreadnoughtAccuracy] = "Точность дредноутов";
		CotlBonusName[CotlBonusDevastatorArmour] = "Защита девастаторов";
		CotlBonusName[CotlBonusDevastatorAccuracy] = "Точность девастаторов";
		CotlBonusName[CotlBonusDevastatorBomb] = "Аннигиляция девастаторов";
		CotlBonusName[CotlBonusWarBaseArmour] = "Броня военных баз";
		CotlBonusName[CotlBonusWarBaseAccuracy] = "Точность военных баз";
		CotlBonusName[CotlBonusWarBaseArmourAll] = "Отражение военных баз";
		CotlBonusName[CotlBonusShipyardSupply] = "Снабжение верфей";
		CotlBonusName[CotlBonusShipyardRepairAll] = "Дроиды верфей";
		CotlBonusName[CotlBonusSciBaseSupply] = "Снабжение научных станций";
		CotlBonusName[CotlBonusMinePower] = "Урон от мин";
		CotlBonusName[CotlBonusPlanetEmpireCnt] = "Планет в империи";
		CotlBonusName[CotlBonusPlanetEnclaveCnt] = "Планет в анклаве";
		CotlBonusName[CotlBonusPlanetColonyCnt] = "Планет в колониях";

		OpsPriceTypeName[OpsPriceTypeAntimatter] = "Антиматерия";
		OpsPriceTypeName[OpsPriceTypeMetal] = "Металл";
		OpsPriceTypeName[OpsPriceTypeElectronics] = "Электроника";
		OpsPriceTypeName[OpsPriceTypeProtoplasm] = "Протоплазма";
		OpsPriceTypeName[OpsPriceTypeNodes] = "Ноды";
		OpsPriceTypeName[OpsPriceTypeFuel] = "Топливо";
		OpsPriceTypeName[OpsPriceTypeModule] = "Модули";
		OpsPriceTypeName[OpsPriceTypeEGM] = "egm";
		OpsPriceTypeName[OpsPriceTypeCr] = "cr";
		
		OpsPriceTypeName2[OpsPriceTypeAntimatter] = "антиматерии";
		OpsPriceTypeName2[OpsPriceTypeMetal] = "металла";
		OpsPriceTypeName2[OpsPriceTypeElectronics] = "электроники";
		OpsPriceTypeName2[OpsPriceTypeProtoplasm] = "протоплазмы";
		OpsPriceTypeName2[OpsPriceTypeNodes] = "нодов";
		OpsPriceTypeName2[OpsPriceTypeFuel] = "ед. топлива";
		OpsPriceTypeName2[OpsPriceTypeModule] = "модулей";
		OpsPriceTypeName2[OpsPriceTypeEGM] = "egm";
		OpsPriceTypeName2[OpsPriceTypeCr] = "cr";

		ItemBonusName[ItemBonusArmourCorvette] = "Защита корветов";
		ItemBonusName[ItemBonusArmourCruiser] = "Защита крейсеров";
		ItemBonusName[ItemBonusArmourDreadnought] = "Защита дредноутов";
		ItemBonusName[ItemBonusArmourDevastator] = "Защита девастаторов";
		ItemBonusName[ItemBonusAccuracyCorvette] = "Точность корветов";
		ItemBonusName[ItemBonusAccuracyCruiser] = "Точность крейсеров";
		ItemBonusName[ItemBonusAccuracyDreadnought] = "Точность дредноутов";
		ItemBonusName[ItemBonusAccuracyDevastator] = "Точность девастаторов";

		ItemBonusName[ItemBonusEnergy] = "Энергия";
		ItemBonusName[ItemBonusCharge] = "Заряд"; // Заряд
		ItemBonusName[ItemBonusChargeMax] = "Ёмкость";
		ItemBonusName[ItemBonusSpeed] = "Скорость";
		ItemBonusName[ItemBonusManoeuvrability] = "Маневренность";
		ItemBonusName[ItemBonusShieldReduce] = "Рассеивание";
		ItemBonusName[ItemBonusShieldMax] = "Щит";
		ItemBonusName[ItemBonusShieldInc] = "Регенерация";

		ItemBonusName[ItemBonusShieldIncA] = "Регенерация (А)";
		ItemBonusName[ItemBonusSpeedA] = "Скорость (А)";
		ItemBonusName[ItemBonusManoeuvrabilityA] = "Маневренность (А)";

		CotlName[5] = "Орион";
		CotlName[6] = "Эридан";

		ChangeWordForNews1["Модули"] = "модуля";
		ChangeWordForNews1["Броня I"] = "брони I";
		ChangeWordForNews1["Броня II"] = "брони II";
		ChangeWordForNews1["Усилитель I"] = "усилителя I";
		ChangeWordForNews1["Усилитель II"] = "усилителя II";
		ChangeWordForNews1["Дроид I"] = "дроида I";
		ChangeWordForNews1["Дроид II"] = "дроида II";
		ChangeWordForNews1["Топливо"] = "топлива";
		ChangeWordForNews1["Аномалия"] = "аномалии";
		ChangeWordForNews1["Монуклиятор"] = "монуклиятора";
		ChangeWordForNews1["Антиматерия"] = "антиматерии";
		ChangeWordForNews1["Металл"] = "металла";
		ChangeWordForNews1["Электроника"] = "электроники";
		ChangeWordForNews1["Протоплазма"] = "протоплазмы";
		ChangeWordForNews1["Ноды"] = "нода";
		ChangeWordForNews1["Мины"] = "мины";
		ChangeWordForNews1["Титан"] = "титана";
		ChangeWordForNews1["Кремний"] = "кремния";
		ChangeWordForNews1["Антикристаллы"] = "антикристалла";
		ChangeWordForNews1["Ксенон"] = "ксенона";
		ChangeWordForNews1["Водород"] = "водорода";
		ChangeWordForNews1["Продовольствие"] = "продовольствия";
		ChangeWordForNews1["Плазма"] = "плазмы";
		ChangeWordForNews1["Техника"] = "техника";
		ChangeWordForNews1["Инженеры"] = "инженера";
		ChangeWordForNews1["Механик"] = "механика";
		ChangeWordForNews1["Навигатор"] = "навигатора";
		ChangeWordForNews1["Кварковые ядра"] = "кваркового ядра";

		ChangeWordForNews2["Модули"] = "модуля";
		ChangeWordForNews2["Броня I"] = "брони I";
		ChangeWordForNews2["Броня II"] = "брони II";
		ChangeWordForNews2["Усилитель I"] = "усилителея I";
		ChangeWordForNews2["Усилитель II"] = "усилителея II";
		ChangeWordForNews2["Дроид I"] = "дроидов I";
		ChangeWordForNews2["Дроид II"] = "дроидов II";
		ChangeWordForNews2["Топливо"] = "топлива";
		ChangeWordForNews2["Аномалия"] = "аномалии";
		ChangeWordForNews2["Монуклиятор"] = "монуклиятора";
		ChangeWordForNews2["Антиматерия"] = "антиматерии";
		ChangeWordForNews2["Металл"] = "металла";
		ChangeWordForNews2["Электроника"] = "электроники";
		ChangeWordForNews2["Протоплазма"] = "протоплазмы";
		ChangeWordForNews2["Ноды"] = "нодов";
		ChangeWordForNews2["Мины"] = "мин";
		ChangeWordForNews2["Титан"] = "титана";
		ChangeWordForNews2["Кремний"] = "кремния";
		ChangeWordForNews2["Антикристаллы"] = "антикристалла";
		ChangeWordForNews2["Ксенон"] = "ксенона";
		ChangeWordForNews2["Водород"] = "водорода";
		ChangeWordForNews2["Продовольствие"] = "продовольствия";
		ChangeWordForNews2["Плазма"] = "плазмы";
		ChangeWordForNews2["Техника"] = "техника";
		ChangeWordForNews2["Инженеры"] = "инженера";
		ChangeWordForNews2["Механик"] = "механика";
		ChangeWordForNews2["Навигатор"] = "навигатора";
		ChangeWordForNews2["Кварковые ядра"] = "кварковых ядра";

		ChangeWordForNews5["Модули"] = "модулей";
		ChangeWordForNews5["Броня I"] = "брони I";
		ChangeWordForNews5["Броня II"] = "брони II";
		ChangeWordForNews5["Усилитель I"] = "усилителей I";
		ChangeWordForNews5["Усилитель II"] = "усилителей II";
		ChangeWordForNews5["Дроид I"] = "дроидов I";
		ChangeWordForNews5["Дроид II"] = "дроидов II";
		ChangeWordForNews5["Топливо"] = "топлива";
		ChangeWordForNews5["Аномалия"] = "аномалии";
		ChangeWordForNews5["Монуклиятор"] = "монуклияторов";
		ChangeWordForNews5["Антиматерия"] = "антиматерии";
		ChangeWordForNews5["Металл"] = "металла";
		ChangeWordForNews5["Электроника"] = "электроники";
		ChangeWordForNews5["Протоплазма"] = "протоплазмы";
		ChangeWordForNews5["Ноды"] = "нодов";
		ChangeWordForNews5["Мины"] = "мин";
		ChangeWordForNews5["Титан"] = "титана";
		ChangeWordForNews5["Кремний"] = "кремния";
		ChangeWordForNews5["Антикристаллы"] = "антикристаллов";
		ChangeWordForNews5["Ксенон"] = "ксенона";
		ChangeWordForNews5["Водород"] = "водорода";
		ChangeWordForNews5["Продовольствие"] = "продовольствия";
		ChangeWordForNews5["Плазма"] = "плазмы";
		ChangeWordForNews5["Техника"] = "техники";
		ChangeWordForNews5["Инженеры"] = "инженеров";
		ChangeWordForNews5["Механик"] = "механиков";
		ChangeWordForNews5["Навигатор"] = "навигаторов";
		ChangeWordForNews5["Кварковые ядра"] = "кварковых ядер";
	}

	public static function ChangeWord(w:String, dl:Dictionary):String
	{
		if (dl[w] == undefined) return w;
		return dl[w];
	}
	
	public static function ChangeWords(w:String, dl:Dictionary):String
	{
		var out:String = "";
		var ar:Array = w.split(" ");

		var i:int;
		var len:int = ar.length;
		while (i < len) {
			if (i != 0) out += "";

			if ((i + 2) < len && dl[ar[i] + " " + ar[i + 1] + " " + ar[i + 2]] != undefined) {
				out += dl[ar[i] + " " + ar[i + 1] + " " + ar[i + 2]];
				i += 3;
			} else if ((i + 1) < len && dl[ar[i] + " " + ar[i + 1]] != undefined) {
				out += dl[ar[i] + " " + ar[i + 1]];
				i += 2;
			} else if (dl[ar[i]] != undefined) {
				out += dl[ar[i]];
				i++;
			} else {
				out += ar[i];
				i++;
			}
		}

		return out;
	}

	public static function ChangeWordForNews(w:String, cnt:int):String
	{
		cnt = cnt % 100;
		if (cnt >= 11 && cnt <= 19) return ChangeWords(w, ChangeWordForNews5);
		else if ((cnt % 10) == 1) return ChangeWords(w, ChangeWordForNews1);
		else if ((cnt % 10) >= 2 && (cnt % 10) <= 4) return ChangeWords(w, ChangeWordForNews2);
		else return ChangeWords(w, ChangeWordForNews5);
	}

	public static function GetTime():Number
	{
		return (new Date()).getTime();
	}
	
	public static function MatrixForGradientLine(fx:Number,fy:Number,tx:Number,ty:Number):Matrix
	{
		var w:Number=tx-fx;
		var h:Number=ty-fy;

		var angle:Number=Math.atan2(h,w);
		var cos:Number = Math.cos(angle);
		var sin:Number = Math.sin(angle)

		var w2:Number = Math.abs(w * cos) + Math.abs(h * sin);
		var h2:Number = Math.abs(h * cos) + Math.abs(w * sin);
		var max:Number = Math.max(w2, h2, Math.abs(w * cos), Math.abs(h * sin), Math.abs(h * cos), Math.abs(w * sin));

		var mat:Matrix = new Matrix();
		mat.createGradientBox(max, max, 0, 0, 0);  
		mat.rotate(angle);
		mat.translate(fx,fy);

		return mat;
	}
	
	public static function CalcFinalPower(pm:Number=1000):void
	{
		var i:Number;
		
//		var str:String="";
		
		FinalPower.length=0;
		FinalPower.push(0);
//		str+=(0).toString();
		
		for(i=1;i<=(pm>>1);i++) {
			var v:int=Math.round(Math.min(pm*0.25,i-Math.min(0.25,(i*i)/(pm*pm))*pm));
			FinalPower.push(v);
//			str+=","+v.toString();						
		}
//		trace(str);
	}

	public static function TechCost(tech:int, r:int):int
	{	
		if (tech == Common.TechProgress) return Common.TechProgressCost[r];
		else if (tech == Common.TechEconomy) return Common.TechEconomyCost[r];
		else if (tech == Common.TechTransport) return Common.TechTransportCost[r];
		else if (tech == Common.TechCorvette) return Common.TechCorvetteCost[r];
		else if (tech == Common.TechCruiser) return Common.TechCruiserCost[r];
		else if (tech == Common.TechDreadnought) return Common.TechDreadnoughtCost[r];
		else if (tech == Common.TechInvader) return Common.TechInvaderCost[r];
		else if (tech == Common.TechDevastator) return Common.TechDevastatorCost[r];
		else if (tech == Common.TechWarBase) return Common.TechWarBaseCost[r];
		else if (tech == Common.TechShipyard) return Common.TechShipyardCost[r];
		else if (tech == Common.TechSciBase) return Common.TechSciBaseCost[r];
		else if (tech == Common.TechQuarkBase) return Common.TechQuarkBaseCost[r];
		throw Error("");
	}

	public static function FormatPeriod(t:Number):String
	{
		var a:int;
		var s:String='';
		
		t=Math.floor(t);
		if(t<0) t=0;

		a=Math.floor(t / 3600);
		if(a>0) {
			s+=a.toString()+":";
		}

		a=Math.floor((t % 3600)/60);
		if(a<10) s+="0";
		s+=a.toString()+":";

		a=t % 60;
		if(a<10) s+="0";
		s+=a.toString();

		return s;	
	}
	
	public static function IntToSc(val:int, ar:Array, off:int=0):String
	{
		if (val >= 11 && val <= 19) return ar[2+off];
		else if ((val % 10) == 1) return ar[0+off];
		else if((val % 10)>=2 && (val % 10)<=4) return ar[1+off];
		else return ar[2+off];
	}
	
	public static function FormatPeriodLong(t:Number,printsec:Boolean=true,off:int=0):String
	{
		var k:int;
		var s:String='';

		t=Math.floor(t);
		if (t < 0) t = 0;
		
		var printmin:Boolean = true;

		// Day
		k = Math.floor(t / 86400);
		t = t % 86400;
		if (k > 0) {
			if (s.length > 0) s += ", ";
			s += k.toString() + " " + IntToSc(k, ScDay, off);
			printsec = false;
			printmin = false;
		}

		// Hour
		k = Math.floor(t / 3600);
		t = t % 3600;
		if (k > 0) {
			if (s.length > 0) s += ", ";
			s += k.toString() + " " + IntToSc(k, ScHour, off);
			printsec = false;
		}

		// Minute
		k = Math.floor(t / 60);
		t = t % 60;
		if (k > 0 && printmin) {
			if (s.length > 0) s += ", ";
			s += k.toString() + " " + IntToSc(k, ScMinute, off);
		}
		
		// Second
		k = Math.floor(t);
		if (((k > 0) || (k == 0 && s.length == 0)) && printsec) {
			if (s.length > 0) s += ", ";
			s += k.toString() + " " + IntToSc(k, ScSecond, off);
		}
		
		return s;
	}
	
	
	public static function NormHour(h:int):int
	{
		while(h>=24) h-=24;
		while(h<0) h+=24;
		return h;
	}
	
	public static function UIStdBut(but:Button):void
	{
		but.emphasized=false;
		but.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		but.setStyle("embedFonts", true);
		but.textField.antiAliasType=AntiAliasType.ADVANCED;
		but.textField.gridFitType=GridFitType.PIXEL;
	}

	public static function UIStdLabel(l:Label, size:int=13, color:uint=0xc4fff2):void
	{
		l.setStyle("textFormat", new TextFormat("Calibri",size,color));
		l.setStyle("embedFonts", true);
		l.textField.antiAliasType=AntiAliasType.ADVANCED;
		l.textField.gridFitType=GridFitType.PIXEL;
	}

	public static function UIStdTextField(l:TextField, size:int=13, color:uint=0xc4fff2):void
	{
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background=false;
		l.multiline=false;
		l.autoSize=TextFieldAutoSize.LEFT;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.PIXEL;
		l.defaultTextFormat=new TextFormat("Calibri",size,color);
		l.embedFonts = true;
	}

	public static function UIStdInput(i:TextInput):void
	{
		i.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		i.setStyle("embedFonts", true);
		i.textField.antiAliasType=AntiAliasType.ADVANCED;
		i.textField.gridFitType=GridFitType.PIXEL;
	}

	public static function UIStdComboBox(i:ComboBox):void
	{
		var tf:TextFormat=new TextFormat("Calibri",13,0xc4fff2)
		i.setStyle("textFormat", tf);
		i.setStyle("embedFonts", true);
		i.textField.setStyle("textFormat", tf);
		i.textField.setStyle("embedFonts", true);
		i.textField.textField.antiAliasType=AntiAliasType.ADVANCED;
		i.textField.textField.gridFitType=GridFitType.PIXEL;
		i.dropdown.setRendererStyle("textFormat", tf);
		i.dropdown.setRendererStyle("embedFonts", true);
	}
	
	public static function UIChatBar(obj:Object):void
	{
		obj.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
		obj.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
		obj.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
		obj.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);

		obj.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
		obj.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
		obj.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
		obj.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
		obj.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);

		obj.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
		obj.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
		obj.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
		obj.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);

		obj.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
		obj.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
		obj.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
		obj.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);
	}

	public static function UIEditBar(obj:Object):void
	{
		obj.setStyle("trackUpSkin",Edit_ScrollTrack_skin);
		obj.setStyle("trackOverSkin",Edit_ScrollTrack_skin);
		obj.setStyle("trackDownSkin",Edit_ScrollTrack_skin);
		obj.setStyle("trackDisabledSkin",Edit_ScrollTrack_skin);

		obj.setStyle("thumbUpSkin",Edit_ScrollThumb_upSkin);
		obj.setStyle("thumbOverSkin",Edit_ScrollThumb_upSkin);
		obj.setStyle("thumbDownSkin",Edit_ScrollThumb_upSkin);
		obj.setStyle("thumbDisabledSkin",Edit_ScrollThumb_upSkin);
		obj.setStyle("thumbIcon",Edit_ScrollBar_thumbIcon);

		obj.setStyle("upArrowDownSkin",Edit_ScrollArrowUp_upSkin);
		obj.setStyle("upArrowOverSkin",Edit_ScrollArrowUp_upSkin);
		obj.setStyle("upArrowUpSkin",Edit_ScrollArrowUp_upSkin);
		obj.setStyle("upArrowDisabledSkin",Edit_ScrollArrowUp_upSkin);

		obj.setStyle("downArrowDownSkin",Edit_ScrollArrowDown_upSkin);
		obj.setStyle("downArrowOverSkin",Edit_ScrollArrowDown_upSkin);
		obj.setStyle("downArrowUpSkin",Edit_ScrollArrowDown_upSkin);
		obj.setStyle("downArrowDisabledSkin",Edit_ScrollArrowDown_upSkin);
	}

	public static function UICheck(cb:CheckBox):void
	{
		cb.setStyle("disabledIcon",CheckBox_P_disabledIcon);
		cb.setStyle("disabledSkin",CheckBox_P_disabledIcon);
		cb.setStyle("selectedDisabledIcon",CheckBox_P_selectedDisabledIcon);
		cb.setStyle("selectedDisabledSkin",CheckBox_P_selectedDisabledIcon);
		
		cb.setStyle("downIcon",CheckBox_P_disabledIcon);
		cb.setStyle("downSkin",CheckBox_P_disabledIcon);
		cb.setStyle("selectedDownIcon",CheckBox_P_selectedDisabledIcon);
		cb.setStyle("selectedDownSkin",CheckBox_P_selectedDisabledIcon);
		
		cb.setStyle("overIcon",CheckBox_P_disabledIcon);
		cb.setStyle("overSkin",CheckBox_P_disabledIcon);
		cb.setStyle("selectedOverIcon",CheckBox_P_selectedDisabledIcon);
		cb.setStyle("selectedOverSkin",CheckBox_P_selectedDisabledIcon);
		
		cb.setStyle("upIcon",CheckBox_P_disabledIcon);
		cb.setStyle("upSkin",CheckBox_P_disabledIcon);
		cb.setStyle("selectedUpIcon",CheckBox_P_selectedDisabledIcon);
		cb.setStyle("selectedUpSkin",CheckBox_P_selectedDisabledIcon);

		cb.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		cb.setStyle("embedFonts", true);
		cb.textField.antiAliasType=AntiAliasType.ADVANCED;
		cb.textField.gridFitType=GridFitType.PIXEL;
	}

	public static function DateToSysStr(d:Date):String
	{
		var val:String="";
		
		val+=d.fullYear.toString()+"-";
		
		if((d.month+1)<10) val+="0";
		val+=(d.month+1).toString()+"-";
		
		if(d.date<10) val+="0";
		val+=d.date.toString()+" ";
		
		if(d.hours<10) val+="0";
		val+=d.hours.toString()+":";
		
		if(d.minutes<10) val+="0";
		val+=d.minutes.toString()+":";
		
		if(d.seconds<10) val+="0";
		val+=d.seconds.toString();
		
		return val;
	}

	public static function DateToStr(d:Date, sec:Boolean=true):String
	{
		var val:String="";
		
		val+=(d.fullYear+2000).toString()+"-";
		
		if((d.month+1)<10) val+="0";
		val+=(d.month+1).toString()+"-";
		
		if(d.date<10) val+="0";
		val+=d.date.toString()+" ";
		
		if(d.hours<10) val+="0";
		val+=d.hours.toString()+":";
		
		if(d.minutes<10) val+="0";
		val+=d.minutes.toString();
		
		if(sec) {
			val+=":";
			if(d.seconds<10) val+="0";
			val+=d.seconds.toString();
		}
		
		return val;
	}

	public static function DateToStrEx(d:Date, sec:Boolean = true):String
	{
		var val:String="(";

		if(d.hours<10) val+="0";
		val+=d.hours.toString()+":";

		if(d.minutes<10) val+="0";
		val+=d.minutes.toString();

		if(sec) {
			val+=":";
			if(d.seconds<10) val+="0";
			val+=d.seconds.toString();
		}

		val += ") " + Txt.FormatDate;

		val = BaseStr.Replace(val, "<Y>", (d.fullYear + 2000).toString());

		val = BaseStr.Replace(val, "<M>", TxtMonthForDate[d.month]);

		if(d.date<10) val = BaseStr.Replace(val, "<D>", "0"+d.date.toString());
		else val = BaseStr.Replace(val, "<D>", d.date.toString());

		return val;
	}

	public static function CotlProtectCalcPeriod(start:int,period:int,dt:Date):int
	{
    	if(start<0) start=0;
    	else if(start>=68400) start=68400;

    	if(period<60) period=60;
    	else if(period>68400) period=68400;

    	var st:int=dt.hours*60*60+dt.minutes*60+dt.seconds;
    	var hour_period:int=Math.floor(period/(60*60));
    	if((period % (60*60))!=0) hour_period++;

    	var t:int=st-start;
    	if(t<0) t=24*60*60-start+st;

    	t=t % (hour_period*60*60);

    	if(t<period) {
        	//t=period-t;

        	return t;
    	} else {
        	t=hour_period*60*60-t;

    	    return -t;
	    }
	}

	static public function CreateByName(name:String):Object
	{
		var cl:Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
		if (cl == null) throw Error("NotFoundClass: " + name);
		return new cl();
	}
	
	static public function CalcExpInt(str:String, def:int = 0):int
	{
		var cc:CodeCompiler = new CodeCompiler();
		
		try {
			cc.m_Src = new CodeSrc(str);
			cc.parseFun();
			cc.prepare();
			if (cc.m_Src.err) return def;

			var cr:Code = new Code();
			var r:* = cr.runFun(cc);
			return int(r);
			
		} catch (err:*) {
			return def;
		}
		return def;
	}

	static public const ItemImgList:Dictionary=new Dictionary();
	static public const ItemImgArray:Array=new Array();
	
	public static function ItemImgVec(no:int, nonull:Boolean=true):Sprite
	{
		var s:Sprite=null;
		var cl:Class;
		
		if(ItemImgList[no]!=undefined) {
			var obj:Object = ItemImgList[no];
			if (obj.VecScale < 0) {
			} else if(obj.VecName!=null) {
				cl=ApplicationDomain.currentDomain.getDefinition("Item"+obj.VecName) as Class;
				s=new cl();
				s.scaleX=obj.VecScale;
				s.scaleY=obj.VecScale;
			}
		}

		if(s==null && nonull) {
			cl=ApplicationDomain.currentDomain.getDefinition("ItemModule") as Class;
			s=new cl();
			s.scaleX=2.0;
			s.scaleY=2.0;
		}
		s.mouseEnabled = false;
		
		return s;
	}
	
	public static function ItemImg(no:int, nonull:Boolean = true):DisplayObject
	{
		var s:Sprite=null;
		var cl:Class;
		
		if (ItemImgList[no] != undefined) {
			var obj:Object = ItemImgList[no];
			if (obj.VecScale < 0) {
				obj = LoadManager.Self.Get("item/" + obj.VecName + "h.png");
				if (obj is Bitmap) {
					//var bm:Bitmap = obj as Bitmap;
					var bm:Bitmap = new Bitmap();
					bm.bitmapData = (obj as Bitmap).bitmapData;
					s = new Sprite();
					bm.x = -(bm.width >> 1);
					bm.y = -(bm.height >> 1);
					s.addChild(bm);
				} else return null;
			} else if(obj.VecName!=null) {
				cl=ApplicationDomain.currentDomain.getDefinition("sp"+obj.VecName) as Class;
				s=new cl();
			}
		}

		if(s==null && nonull) {
			cl=ApplicationDomain.currentDomain.getDefinition("spModule") as Class;
			s=new cl();
			s.scaleX=2.0;
			s.scaleY=2.0;
		}
		if(s) s.mouseEnabled = false;
		
		return s;
	}
	
	public static function ItemEqImg(no:int, anim:Boolean):BitmapData
	{
		var s:Sprite=null;
		var cl:Class;
		
		if (ItemImgList[no] != undefined) {
			var obj:Object = ItemImgList[no];
			if (obj.VecScale < 0) {
				obj = LoadManager.Self.Get("item/" + obj.VecName + (anim?"a.png":"i.png"));
				if (obj is Bitmap) {
					return (obj as Bitmap).bitmapData;
				} else return null;
			}
		}

		return null;
	}

	public static function ItemScale(no:int):Number
	{
		if (ItemImgList[no] != undefined) {
			var obj:Object = ItemImgList[no];
			return obj.VecScale;
		}
		return 1.0;
	}

	public static function ItemTex(no:int):Texture
	{
		var s:Sprite;
		var ob:Object;
		var cl:Class;

		if (ItemImgList[no] != undefined) {
			var obj:Object = ItemImgList[no];
			if (obj.Tex == undefined || obj.Tex == null) {
				if (obj.VecScale < 0) {
					ob = LoadManager.Self.Get("item/" + obj.VecName + "h.png");
					if (ob is Bitmap) {
						var bm:BitmapData = (ob as Bitmap).bitmapData;
						
						if (bm.width < 64 && bm.height < 64) {
							var nbm:BitmapData = new BitmapData(64, 64, true, 0);
							nbm.copyPixels(bm, new Rectangle(0, 0, bm.width, bm.height), new Point((nbm.width >> 1) - (bm.width >> 1), (nbm.height >> 1) - (bm.height >> 1)));
							bm = nbm;
						}

						obj.Tex = C3D.CreateTextureFromBM(bm, false);
					} else return null;
				} else {
					cl = ApplicationDomain.currentDomain.getDefinition("sp" + obj.VecName) as Class;
					s = new cl();
					obj.Tex = C3D.CreateTextureFromSprite(64, 64, s, 32, 32);
				}
			}
			return obj.Tex;
		}
		return null;
	}
	
	public static function IemTexClear():void
	{
		var i:int;
		for (i = 0; i < ItemImgArray.length; i++) {
			var obj:Object = ItemImgArray[i];
			if (obj == null) continue;
			if (obj.Tex != undefined && obj.Tex != null) {
				obj.Tex.dispose();
				obj.Tex = null;
			}			
		}
	}

	public static function ItemImgAdd(no:int,vecname:String=null,vecscale:Number=1.0):void
	{
		var obj:Object=new Object();
		obj.No=no;
		obj.VecName=vecname;
		obj.VecScale=vecscale;
		ItemImgList[no]=obj;
		
		ItemImgArray.push(obj);
	}
	
	public static function ItemImgInit():void
	{
		ItemImgAdd(1,"Module",0.9);
		ItemImgAdd(2,"Armour",0.9);
		ItemImgAdd(3,"Power",0.9);
		ItemImgAdd(4,"Repair",0.9);
		ItemImgAdd(5,"Jump",0.9);
		ItemImgAdd(6,"Build",0.9);
		ItemImgAdd(7,"Fuel",0.9);
		ItemImgAdd(8,"Double",0.9);
		ItemImgAdd(9,"Monuk",0.9);
		ItemImgAdd(10,"Antimatter",0.9);
		ItemImgAdd(12,"Metal",1.0);
		ItemImgAdd(13,"Electronics",1.0);
		ItemImgAdd(14,"Protoplasm",0.9);
		ItemImgAdd(15,"Nodes",0.9);
		ItemImgAdd(16,"Armour2",0.9);
		ItemImgAdd(17,"Power2",0.9);
		ItemImgAdd(18,"Repair2",0.9);
		ItemImgAdd(19, "Mine", 0.9);
		ItemImgAdd(21,"Ore01",0.9);
		ItemImgAdd(22,"Ore02",0.9);
		ItemImgAdd(23,"Ore03",0.9);
		ItemImgAdd(24,"Ore04",0.9);
		ItemImgAdd(25,"Ore05",0.9);
		ItemImgAdd(26,"Ore06",0.9);
		ItemImgAdd(27,"Ore07",0.9);
		ItemImgAdd(28,"Ore08",0.9);
		ItemImgAdd(29,"Ore09",0.9);
		ItemImgAdd(30,"Ore10",0.9);
		ItemImgAdd(31,"Money",1.0);
		ItemImgAdd(32,"Mass",0.9);
		ItemImgAdd(33, "Food", 0.9);
		ItemImgAdd(34, "Machinery", 1.0);
		ItemImgAdd(35, "Plasma", 1.0);
		ItemImgAdd(36, "Engineer", 0.8);
		ItemImgAdd(37, "Technician", 0.8);
		ItemImgAdd(38, "Navigator", 0.8);
		ItemImgAdd(39, "Egm", 1.0);
		
		ItemImgAdd(256, "engine0", -1);
		ItemImgAdd(257, "reactor0", -1);
		ItemImgAdd(258, "core0", -1);
		ItemImgAdd(259, "generator0", -1);
	}
	
	public static function ItemIsFinalLoop(itype:int):Boolean
	{
		itype &= 0xffff;
		
		if (itype == ItemTypeModule) return true;
		else if (itype == ItemTypeArmour) return true;
		else if (itype == ItemTypePower) return true;
		else if (itype == ItemTypeRepair) return true;
		else if (itype == ItemTypeFuel) return true;
		else if (itype == ItemTypeArmour2) return true;
		else if (itype == ItemTypePower2) return true;
		else if (itype == ItemTypeRepair2) return true;
		else if (itype == ItemTypeMine) return true;
		else if (itype == ItemTypeMoney) return true;
		else if (itype == ItemTypeMachinery) return true;
		else if (itype == ItemTypeEngineer) return true;
		else if (itype == ItemTypeTechnician) return true;
		else if (itype == ItemTypeNavigator) return true;
		else if (itype == ItemTypeQuarkCore) return true;
		return false;
	}
	
	public static function ItemCanOnShip(itype:int, shiptype:int):Boolean
	{
		if (itype == ItemTypePower) return true;
		else if (itype == ItemTypePower2) return true;
		else if (itype == ItemTypeArmour) return true;
		else if (itype == ItemTypeArmour2) return true;
		else if (itype == ItemTypeRepair) return true;
		else if (itype == ItemTypeRepair2) return true;
		else if (itype == ItemTypeMonuk) return true;
		//else if (itype == ItemTypeMine && shiptype == ShipTypeFlagship) return true;
		return false;
	}

	public static function FillBonusItem(menu:CtrlPopupMenu, curit:uint = 0):int
	{
		var str:String;
		var i:int, k:int;
		var idesc:Item;
		var ba:Array = new Array();

		var em:EmpireMap = EmpireMap.Self;

		menu.widthMin = 300;
		
		var off:int = menu.ItemCnt;
		
		menu.ItemAdd(Common.Txt.BonusPagePilot, null, 0, null, false);
		menu.ItemAdd(ItemBonusName[ItemBonusArmourCorvette], ItemBonusArmourCorvette, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusArmourCruiser], ItemBonusArmourCruiser, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusArmourDreadnought], ItemBonusArmourDreadnought, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusArmourDevastator], ItemBonusArmourDevastator, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusAccuracyCorvette], ItemBonusAccuracyCorvette, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusAccuracyCruiser], ItemBonusAccuracyCruiser, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusAccuracyDreadnought], ItemBonusAccuracyDreadnought, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusAccuracyDevastator], ItemBonusAccuracyDevastator, 1);

		menu.ItemAdd(Common.Txt.BonusPageShip, null, 0, null, false);
		menu.ItemAdd(ItemBonusName[ItemBonusEnergy], ItemBonusEnergy, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusCharge], ItemBonusCharge, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusChargeMax], ItemBonusChargeMax, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusSpeed], ItemBonusSpeed, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusSpeedA], ItemBonusSpeedA, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusManoeuvrability], ItemBonusManoeuvrability, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusManoeuvrabilityA], ItemBonusManoeuvrabilityA, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusShieldReduce], ItemBonusShieldReduce, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusShieldMax], ItemBonusShieldMax, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusShieldInc], ItemBonusShieldInc, 1);
		menu.ItemAdd(ItemBonusName[ItemBonusShieldIncA], ItemBonusShieldIncA, 1);
		
		for (; off < menu.ItemCnt; off++) {
			if (menu.ItemSelect(off)!=undefined && menu.ItemData(off) == curit) return off;
		}
		return -1;
	}

	public static function FillMenuItem(menu:CtrlPopupMenu, curit:uint = 0, money:Boolean = true, egm:Boolean = true, eq:Boolean = false):int
	{
		var str:String;
		var i:int, u:int, k:int, p:int, r:int;
		var idesc:Item;
//		var ar:Array = new Array();
		var ba:Array = new Array();

		var em:EmpireMap = EmpireMap.Self;

		menu.widthMin = 300;
		
		var off:int = menu.ItemCnt;
		
		menu.ItemAdd(Common.Txt.ItemPageCurrency, null, 0, null, false);
		if (money) menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeMoney), Common.ItemTypeMoney, 1);
		if (egm) menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeEGM), Common.ItemTypeEGM, 1);

		menu.ItemAdd(Common.Txt.ItemPageOre, null, 0, null, false);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeHydrogen), Common.ItemTypeHydrogen, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeXenon), Common.ItemTypeXenon, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeTitan), Common.ItemTypeTitan, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeSilicon), Common.ItemTypeSilicon, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeCrystal), Common.ItemTypeCrystal, 1);
		
		menu.ItemAdd(Common.Txt.ItemPageRefine, null, 0, null, false);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeAntimatter), Common.ItemTypeAntimatter, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeMetal), Common.ItemTypeMetal, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeElectronics), Common.ItemTypeElectronics, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeFood), Common.ItemTypeFood, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypePlasma), Common.ItemTypePlasma, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeProtoplasm), Common.ItemTypeProtoplasm, 1);

		menu.ItemAdd(Common.Txt.ItemPageSupply, null, 0, null, false);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeMachinery), Common.ItemTypeMachinery, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeEngineer), Common.ItemTypeEngineer, 1);

		menu.ItemAdd(Common.Txt.ItemPageMaterial, null, 0, null, false);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeModule), Common.ItemTypeModule, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeFuel), Common.ItemTypeFuel, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeMine), Common.ItemTypeMine, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeQuarkCore), Common.ItemTypeQuarkCore, 1);

		menu.ItemAdd(Common.Txt.ItemPageOutfit, null, 0, null, false);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeArmour), Common.ItemTypeArmour, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeArmour2), Common.ItemTypeArmour2, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypePower), Common.ItemTypePower, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypePower2), Common.ItemTypePower2, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeRepair), Common.ItemTypeRepair, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeRepair2), Common.ItemTypeRepair2, 1);
		menu.ItemAdd(em.Txt_ItemName(Common.ItemTypeMonuk), Common.ItemTypeMonuk, 1);

		menu.ItemAdd(Common.Txt.ItemPagePilot, null, 0, null, false);

		var itn:int;
		var it:uint = 0;
		for (itn = 0; itn < 2; itn++) {
			if (itn == 0) it = Common.ItemTypeTechnician;
			else if (itn == 1) it = Common.ItemTypeNavigator;
			
			idesc = UserList.Self.GetItem(it);
			if (idesc == null) continue;

			ba.length = 0;
			
			if (it == (curit & 0xffff)) it = curit;

			k = menu.ItemAdd(em.ItemName(it), it, 1);

			for (i = 4; i < 12; i++) {
				if (idesc.m_BonusType[i] == 0) continue;

				if (ba[idesc.m_BonusType[i]] == undefined) {
					var ib0:int = (it >> 16) & 15;
					var ib1:int = (it >> 20) & 15;
					var ib2:int = (it >> 24) & 15;
					var ib3:int = (it >> 28) & 15;

					str = Common.ItemBonusName[idesc.m_BonusType[i]];
					if (ib0 == i || ib1 == i || ib2 == i || ib3 == i) str += ": +" + Math.round(idesc.m_BonusVal[i] * 100.0 / 256.0).toString() + "%";
					
					ba[idesc.m_BonusType[i]] = menu.ItemAdd(str, idesc.m_BonusType[i], 2, null, k);
				}

				menu.SwitchAdd(ba[idesc.m_BonusType[i]], "*"/*Math.round(idesc.m_BonusVal[i] * 100.0 / 256.0).toString() + "%"*/, i, false, FillMenuItemPilotCB);
			}
		}

		menu.ItemAdd(Common.Txt.ItemPageEq, null, 0, null, false);
		for (itn = 0; itn <= 3; itn++) {
			if (itn == 0) it = 256;
			else if (itn == 1) it = 257;
			else if (itn == 2) it = 258;
			else if (itn == 3) it = 259;

			idesc = UserList.Self.GetItem(it);
			if (idesc == null) continue;

			k = menu.ItemAdd(em.ItemName(it), it, 1);
			
			for (i = 0; i < Item.BonusCnt; i++) {
				if (!idesc.m_BonusType[i]) continue;
				if (ItemBonusParent[idesc.m_BonusType[i]]) continue;
				if (idesc.m_CoefCnt[i] <= 0) continue;

				r = (it >> (16 + idesc.m_CoefShift[i])) & ((1 << idesc.m_CoefBit[i]) - 1);
				if (r >= idesc.m_CoefCnt[i]) r = idesc.m_CoefCnt[i] - 1;

				str = Common.ItemBonusName[idesc.m_BonusType[i]] + ": " + idesc.m_Coef[i * Item.CoefCnt + r].toString();
				p = menu.ItemAdd(str, i, 2, null, k);

				for (u = 0; u < idesc.m_CoefCnt[i]; u++) {
					menu.SwitchAdd(p, "*", u, u == r, FillMenuItemEqCB);
				}
			}
		}

		for (; off < menu.ItemCnt; off++) {
			if (menu.ItemSelect(off) === true && menu.ItemData(off) == curit) return off;
		}
		return -1;
	}
	
	private static function FillMenuItemPilotCB(menu:CtrlPopupMenu, itno:int, swno:int):void
	{
		var i:int, u:int, k:int, p:int;
		var cnt:int = menu.switchCnt(itno);
		if(menu.switchOn(itno, swno)) {
			for (i = 0; i < cnt; i++) menu.switchOn(itno, i, i == swno);
		}
		var itp:int = menu.itemParent(itno);
		if (itp < 0) return;

		var idesc:Item = UserList.Self.GetItem(menu.ItemData(itp));
		if (idesc == null) return;

		i = menu.switchData(itno, swno);

		var str:String = Common.ItemBonusName[idesc.m_BonusType[i]];
		if (menu.switchOn(itno, swno)) str += ": +" + Math.round(idesc.m_BonusVal[i] * 100.0 / 256.0).toString() + "%";
		menu.itemTextSet(itno, str);

		var it:uint = menu.ItemData(itp) & 0xffff;

		i = 0;
		p = 16;
		for (; (u = menu.itemChild(itp, i)) >= 0; i++ ) {
			cnt = menu.switchCnt(u);
			for (k = 0; k < cnt; k++) {
				if (menu.switchOn(u, k)) {
					it |= menu.switchData(u, k) << p;
					p += 4;
				}
			}
		}
		
		menu.itemDataSet(itp, it);
		menu.itemTextSet(itp, EmpireMap.Self.ItemName(it));
	}
	
	private static function FillMenuItemEqCB(menu:CtrlPopupMenu, itno:int, swno:int):void
	{
		var i:int, u:int, k:int, p:int, r:int;
		var str:String;
		
		var cnt:int = menu.switchCnt(itno);
		for (i = 0; i < cnt; i++) menu.switchOn(itno, i, i == swno);
		var itp:int = menu.itemParent(itno);
		if (itp < 0) return;

		var idesc:Item = UserList.Self.GetItem(menu.ItemData(itp));
		if (idesc == null) return;

		i = menu.ItemData(itno);
		r = menu.switchData(itno, swno);

		str = Common.ItemBonusName[idesc.m_BonusType[i]] + ": " + idesc.m_Coef[i * Item.CoefCnt + r].toString();
		menu.itemTextSet(itno, str);

		var it:uint = menu.ItemData(itp) & 0xffff;
		
		for (p = 0; (u = menu.itemChild(itp, p)) >= 0; p++ ) {
			i = menu.ItemData(u);
			cnt = menu.switchCnt(u);
			for (k = 0; k < cnt; k++) {
				if (menu.switchOn(u, k)) {
					r = menu.switchData(u, k);

					it |= (((1 << idesc.m_CoefBit[i]) - 1) & r) << (16 + idesc.m_CoefShift[i]);
				}
			}
		}

		menu.itemDataSet(itp, it);
		menu.itemTextSet(itp, EmpireMap.Self.ItemName(it));
	}
	
	public static function BuildingItemAdd(build:int, building_type:int, item_type:int, cnt1:int, cnt2:int, cnt3:int, cnt4:int, cnt5:int):void
	{
		var obj:Object=new Object();
		obj.Build=build;
		obj.ItemType=item_type;
		obj.BuildingType = building_type;
		obj.Cnt = new Vector.<int>(1+5);
		obj.Cnt[0] = 0;
		obj.Cnt[1] = cnt1;
		obj.Cnt[2] = cnt2;
		obj.Cnt[3] = cnt3;
		obj.Cnt[4] = cnt4;
		obj.Cnt[5] = cnt5;
		BuildingItem.push(obj);
	}

	public static function BuildingItemInit():void
	{
		
//1. инженеры и техника имеют максимум на 1-м уровне (удельная добыча 50, против удельной добычи на 5-м - 0.47). Разница 6.28%.
//Такая же как раньше с городами
//2. академии механиков и навигаторов. тут разница просто колоссальная: 25% между 1-м и 5-м уровнем. На 1-м: удельная добыча - 6, на 5-м -  4.67
//3. заводы усилителей, брони, дроидов.
//тут разница 9.38 % между 2 - м и 5 - м. (70 против 64)

		BuildingItemAdd(-1, 	BuildingTypeCrystal, 		ItemTypeCrystal, 		1, 2, 3, 4, 5);
		BuildingItemAdd(-1, 	BuildingTypeTitan, 			ItemTypeTitan, 			1, 2, 3, 4, 5);
		BuildingItemAdd(-1, 	BuildingTypeSilicon, 		ItemTypeSilicon, 		1, 2, 3, 4, 5);
		BuildingItemAdd(-1, 	BuildingTypeXenon, 			ItemTypeXenon, 			1, 2, 3, 4, 5);

		BuildingItemAdd(-1,		BuildingTypeFarm,			ItemTypeFood, 			1, 2, 3, 4, 5);
		BuildingItemAdd(0,		BuildingTypeFarm,			ItemTypeHydrogen, 		2, 4, 6, 8, 10);
		BuildingItemAdd(0,		BuildingTypeFarm,			ItemTypeXenon, 			2, 4, 6, 8, 10);

		BuildingItemAdd(-1,		BuildingTypeElectronics,	ItemTypeElectronics,	1, 2, 3, 4, 5);
		BuildingItemAdd(0,		BuildingTypeElectronics,	ItemTypeSilicon, 		2, 4, 6, 8, 10);
		BuildingItemAdd(0,		BuildingTypeElectronics,	ItemTypeXenon, 			2, 4, 6, 8, 10);

		BuildingItemAdd(-1,		BuildingTypeMetal,			ItemTypeMetal,			1, 2, 3, 4, 5);
		BuildingItemAdd(0,		BuildingTypeMetal,			ItemTypeTitan,	 		2, 4, 6, 8, 10);
		BuildingItemAdd(0,		BuildingTypeMetal,			ItemTypeHydrogen,		2, 4, 6, 8, 10);

		BuildingItemAdd(-1,		BuildingTypeAntimatter,		ItemTypeAntimatter,		1, 2, 3, 4, 5);
		BuildingItemAdd(0,		BuildingTypeAntimatter,		ItemTypeCrystal, 		2, 4, 6, 8, 10);
		BuildingItemAdd(0,		BuildingTypeAntimatter,		ItemTypeXenon,			2, 4, 6, 8, 10);

		BuildingItemAdd(-1,		BuildingTypePlasma,			ItemTypePlasma,			1, 2, 3, 4, 5);
		BuildingItemAdd(0,		BuildingTypePlasma,			ItemTypeXenon, 			2, 4, 6, 8, 10);
		BuildingItemAdd(0,		BuildingTypePlasma,			ItemTypeHydrogen,		2, 4, 6, 8, 10);

		// Lab
		BuildingItemAdd(10,		BuildingTypeLab,			ItemTypeModule,			5, 10, 15, 20, 25); // 4, 8, 12, 16, 20 // 3 6 9 12 15
		BuildingItemAdd(0,		BuildingTypeLab,			ItemTypeHydrogen, 		4, 8, 12, 16, 20); // 8, 16, 24, 32,40 // 4, 4, 4, 4, 4
		BuildingItemAdd(-1,		BuildingTypeLab,			ItemTypeFuel,			6, 10, 16, 24, 32);
		BuildingItemAdd(0,		BuildingTypeLab,			ItemTypeCrystal, 		3, 5, 8, 12, 16);

		// CityBase:
		// 3.5/25.0/6.0/5.0=0.0046 - базовый прирост на один уровень постройки
		// (0.006*6*1000*3*60*24)/1000=155 - за день одна непрокаченная планета

		// City:
		// ((((1000.0+4000.0+16000.0+64000.0+256000.0)*25.0)/3.0)/31.0)/(24.0*60.0*3.0*6.0)=3.5 - прокаченая планета производит за цикл
		// 3.5*1000.0/5.0=700 - одна прокаченная постройка
		// (150.0*5.0*3.0*60.0)/1000*24=3240 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeCity,			ItemTypeMoney,			190, 384, 582, 816, 1080);
		BuildingItemAdd(0,		BuildingTypeCity,			ItemTypeFood, 			2, 4, 6, 8, 10);
		BuildingItemAdd(0,		BuildingTypeCity,			ItemTypeElectronics,	2, 4, 6, 8, 10);

		// Module:
		// ((6.0*50.0+3.0*100.0)*3.0*60.0*24.0)/(24.0*60.0*3.0*3.0)=200 - прокаченая планета производит за цикл
		// 200.0*1.0/5.0=40 - одна прокаченная постройка
		// (12.0*5.0*3.0*60.0)/1*24=259200 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeModule,			ItemTypeModule,			8, 16, 24, 32, 40);
		BuildingItemAdd(0,		BuildingTypeModule,			ItemTypeElectronics, 	2, 4, 6, 8, 10);
		BuildingItemAdd(0,		BuildingTypeModule,			ItemTypeMetal,			2, 4, 6, 8, 10);

		// Tech
		BuildingItemAdd(-1,		BuildingTypeTech,			ItemTypeQuarkCore,		3, 7, 11, 16, 21);
		BuildingItemAdd(0,		BuildingTypeTech,			ItemTypeAntimatter,		3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeTech,			ItemTypeElectronics,	1, 2, 3, 4, 5);

		// Fuel
		// 10000.0/(24.0*60.0*3.0*2.0)=1.2
		// 1.2*1000.0/5.0=240 - одна прокаченная постройка
		// (50.0*5.0*3.0*60.0)/1000*24=1080 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeFuel,			ItemTypeFuel,			50, 110, 180, 260, 350);// 60, 100, 170, 240, 320); // x2
		BuildingItemAdd(0,		BuildingTypeFuel,			ItemTypeAntimatter, 	3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeFuel,			ItemTypeMetal,			1, 2, 3, 4, 5);

		// Power
		// 10000.0/(24.0*60.0*3.0*1.0)=2.4
		// 2.4*1000.0/5.0=480 - одна прокаченная постройка
		// (120.0*5.0*3.0*60.0)/1000*24=2592 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypePower,			ItemTypePower,			65, 136, 214, 300, 390);
		BuildingItemAdd(0,		BuildingTypePower,			ItemTypePlasma, 		3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypePower,			ItemTypeMetal,			1, 2, 3, 4, 5);
		BuildingItemAdd(-1,		BuildingTypePower,			ItemTypePower2,			65, 136, 214, 300, 390);
		BuildingItemAdd(0,		BuildingTypePower,			ItemTypePlasma, 		3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypePower,			ItemTypeMetal,			1, 2, 3, 4, 5);
		BuildingItemAdd(0,		BuildingTypePower,			ItemTypeProtoplasm,		1, 2, 3, 4, 5);

		// Armour
		// 10000.0/(24.0*60.0*3.0*1.0)=2.4
		// 2.4*1000.0/5.0=480 - одна прокаченная постройка
		// (120.0*5.0*3.0*60.0)/1000*24=2592 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeArmour,			ItemTypeArmour,			65, 136, 214, 300, 390);
		BuildingItemAdd(0,		BuildingTypeArmour,			ItemTypeMetal,	 		3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeArmour,			ItemTypeElectronics,	1, 2, 3, 4, 5);
		BuildingItemAdd(-1,		BuildingTypeArmour,			ItemTypeArmour2,		65, 136, 214, 300, 390);
		BuildingItemAdd(0,		BuildingTypeArmour,			ItemTypeMetal,	 		3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeArmour,			ItemTypeElectronics,	1, 2, 3, 4, 5);
		BuildingItemAdd(0,		BuildingTypeArmour,			ItemTypeProtoplasm,		1, 2, 3, 4, 5);

		// Droid
		// 10000.0/(24.0*60.0*3.0*1.0)=2.4
		// 2.4*1000.0/5.0=480 - одна прокаченная постройка
		// (120.0*5.0*3.0*60.0)/1000*24=2592 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeDroid,			ItemTypeRepair,			65, 136, 214, 300, 390);
		BuildingItemAdd(0,		BuildingTypeDroid,			ItemTypeElectronics,	3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeDroid,			ItemTypeMetal,			1, 2, 3, 4, 5);
		BuildingItemAdd(-1,		BuildingTypeDroid,			ItemTypeRepair2,		65, 136, 214, 300, 390);
		BuildingItemAdd(0,		BuildingTypeDroid,			ItemTypeElectronics,	3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeDroid,			ItemTypeMetal,			1, 2, 3, 4, 5);
		BuildingItemAdd(0,		BuildingTypeDroid,			ItemTypeProtoplasm,		1, 2, 3, 4, 5);

		// Machinery
		// 15000.0/(24.0*60.0*3.0*2.0)=1.75
		// 1.75*1000.0/5.0=350 - одна прокаченная постройка
		// (75.0*5.0*3.0*60.0)/1000*24=1620 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeMachinery,		ItemTypeMachinery,		50, 105, 165, 230, 300);
		BuildingItemAdd(0,		BuildingTypeMachinery,		ItemTypeElectronics,	3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeMachinery,		ItemTypePlasma,			1, 2, 3, 4, 5);

		// Engineer
		// 15000.0/(24.0*60.0*3.0*2.0)=1.75
		// 1.75*1000.0/5.0=350 - одна прокаченная постройка
		// (75.0*5.0*3.0*60.0)/1000*24=1620 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeEngineer,		ItemTypeEngineer,		50, 105, 165, 230, 300);
		BuildingItemAdd(0,		BuildingTypeEngineer,		ItemTypeFood,			3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeEngineer,		ItemTypePlasma,			1, 2, 3, 4, 5);

		// Mine
		// 200000.0/(24.0*60.0*3.0*1.0)=45
		// 45.0*1.0/5.0=9 - одна прокаченная постройка
		// (3.0*5.0*3.0*60.0)/1*24=64800 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeMine,			ItemTypeMine,			10, 20, 30, 40, 50); // 4, 8, 12, 16, 20
		BuildingItemAdd(0,		BuildingTypeMine,			ItemTypeAntimatter,		3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeMine,			ItemTypePlasma,			1, 2, 3, 4, 5);

		// Technician
		// 1.0/(24.0*60.0*3.0*2.0)=0.000116
		// 0.000116*1000000.0/5.0=24 - одна прокаченная постройка
		// (6.0*5.0*3.0*60.0)/1000000.0*24=0.1296 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeTechnician,		ItemTypeTechnician,		5, 11, 17, 23, 30);
		BuildingItemAdd(0,		BuildingTypeTechnician,		ItemTypeMetal,			3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeTechnician,		ItemTypeFood,			1, 2, 3, 4, 5);

		// Navigator
		// 1.0/(24.0*60.0*3.0*2.0)=0.000116
		// 0.000116*1000000.0/5.0=24 - одна прокаченная постройка
		// (6.0*5.0*3.0*60.0)/1000000.0*24=0.1296 - за день одна непрокаченная планета
		// /1.5 - инжектор
		BuildingItemAdd(-1,		BuildingTypeNavigator,		ItemTypeNavigator,		5, 11, 17, 23, 30);
		BuildingItemAdd(0,		BuildingTypeNavigator,		ItemTypeElectronics,	3, 6, 9, 12, 15);
		BuildingItemAdd(0,		BuildingTypeNavigator,		ItemTypeFood,			1, 2, 3, 4, 5);
	};

	public static function StackMax(n:int,storage:int,stackmax:int):int
	{
		if(storage<Planet.PlanetItemCnt) return stackmax;
		var m:int,k:int;
		if (Planet.PlanetItemCnt == 16) {
			m = storage >> 4;
			k = storage & 15;
		} else {
			m = Math.floor(storage / Planet.PlanetItemCnt);
			k = storage % Planet.PlanetItemCnt;
		}
		var r:int = stackmax * m;
		if (n < k) r += stackmax;
		return r;
	}
}

}
