// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import Base3D.*;
import QE.*;
import B3DEffect.StyleManager;
import flash.sampler.*;
import fl.controls.*;
import flash.display.*;
import flash.display3D.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;
import flash.desktop.*;
//import flash.filesystem.*; 
import com.adobe.utils.PerspectiveMatrix3D;
import Empire.FormDialog;

public class EmpireMap extends StdMap
{
	public static const GameVersion:int = 177;
	public static const GameVersionSub:int = 0;// String = "";

	public var RunFromLocal:Boolean = true;

	public static var Self:EmpireMap = null;

	public var HS:Hyperspace = null;
	public var SP:Space = null;

	public var m_Lang:int=Server.LANG_RUS;

	private const SendUpdatePeriod:int=1000;
	private const SendUpdateAfterActionPeriod:int=500;

	public var m_EmpireEdit:Boolean = false;

	public var m_ServerCalcTimeSyn:Number = 0;
	public var m_ServerCalcTimeSynRecvTime:Number = 0;

	public var m_ServerGlobalTimeSyn:Number = 0;
	public var m_ServerGlobalTimeSynRecvTime:Number = 0;

	public var m_ConnectTime:Number=0;
	public var m_ConnectDate:Date=new Date();
	public var m_DifClientServerHour:int=0;

	public var m_MoveMap:Boolean;
	public var m_MoveMapBegin:Boolean;
	public var m_OldPosX:int;
	public var m_OldPosY:int;

	public var m_StateConnect:int; // 0-need connect 1-complate -1-error
	public var m_StateGv:Boolean = false;
	public var m_StateCurUser:Boolean = false;
	public var m_StateCpt:Boolean = false;
	public var m_StateSector:Boolean = false;
	public var m_StateEnterCotl:Boolean = false;
	public var m_StateQuest:Boolean = false;

	public var m_RootCotlId:uint=0;//
	public var m_RootFleetId:uint=0;
	public var m_SectorSize:int;
	public var m_CotlType:int;
	public var m_CotlOwnerId:uint;
	public var m_CotlUnionId:uint;
	public var m_CotlZoneLvl:int;
	public var m_EmpireColony:Boolean=false;
	public var m_SectorMinX:int;
	public var m_SectorMinY:int;
	public var m_SectorCntX:int;
	public var m_SectorCntY:int;
	public var m_WorldVer:uint;
	public var m_StateVer:uint;
	public var m_Edit:Boolean; // Карта для редактирования
	public var m_BuildSpeed:int;
	public var m_ModuleMul:int;
	public var m_ResMul:int;
	public var m_SupplyMul:int;
	public var m_TechSpeed:int;
	public var m_InfrCostMul:int;
	public var m_EmpireLifeTime:int;
	public var m_SessionPeriod:int;
	public var m_SessionStart:int;
	public var m_Access:uint;
	public var m_StateLoad:Boolean = true;
	public var m_GameState:uint;
	public var m_GameTime:uint;
	public var m_ReadyTime:uint;
	public var m_DefScore:int = 0;
	public var m_AtkScore:int = 0;
	public var m_BasePlanetCnt:int = 0;
	public var m_AllPlanetCnt:int = 0;
	public var m_BaseSectorX:int=0;
	public var m_BaseSectorY:int=0;
	public var m_BasePlanetNum:int = -1;
	public var m_PlanetDestroy:int = 0;

	public var m_OpsFlag:uint;
	public var m_OpsModuleMul:int;
	public var m_OpsCostBuildLvl:int;
	public var m_OpsSpeedCapture:int;
	public var m_OpsSpeedBuild:int;
	public var m_OpsRestartCooldown:uint;
	public var m_OpsStartTime:uint;
	public var m_OpsPulsarActive:int;
	public var m_OpsPulsarPassive:int;
	public var m_OpsMaxRating:int;
	public var m_OpsWinScore:int;
	public var m_OpsRewardExp:int;
	public var m_OpsPriceEnter:int;
	public var m_OpsPriceEnterType:int;
	public var m_OpsPriceCapture:int;
	public var m_OpsPriceCaptureType:int;
	public var m_OpsPriceCaptureEgm:int;
	public var m_OpsProtectCooldown:uint;
	public var m_OpsTeamOwner:int;
	public var m_OpsTeamEnemy:int;
	public var m_OpsJumpRadius:int = Common.DefaultJumpRadius;
	
	public var JumpRadius2:int = Common.DefaultJumpRadius * Common.DefaultJumpRadius;

	private var m_Sector:Array=null;

	public var m_NoCacheStr:String;
	public var m_NoCacheNo:int;

	public var m_BG:GraphBG=null;

	private var m_WaitAnswer:Number=0;
	private var m_WaitAnswer2:Number=0;

	public var m_PlanetList:Array;
	public var m_ShipList:Array;
	private var m_ItemList:Array;
	public var m_BulletList:Vector.<GraphBullet> = new Vector.<GraphBullet>();
	public var m_ExplosionList:Vector.<GraphExplosion> = new Vector.<GraphExplosion>();

	public var m_CurSectorX:int;
	public var m_CurSectorY:int;
	public var m_CurPlanetNum:int;
	public var m_CurShipNum:int;
	public var m_CurSpecial:int; // 0-none 1-portal

	public var m_MoveSectorX:int;
	public var m_MoveSectorY:int;
	public var m_MovePlanetNum:int;
	public var m_MoveShipNum:int;
	public var m_MoveOwner:uint;
	public var m_MoveListNum:Array=new Array();
	public var m_MovePath:Array=new Array();

	public static var ActionNone:int=0;
	public static var ActionMove:int=1;
	public static var ActionPlanet:int=2;
	public static var ActionPathMove:int=3;
	public static var ActionSplit:int=4;
	public static var ActionShowRadius:int=5;
	public static var ActionExchange:int=6;
	public static var ActionConstructor:int=7;
	public static var ActionPlanetMove:int=8;
	public static var ActionPortal:int=9;
	public static var ActionRoute:int = 10;
	public static var ActionRecharge:int=11;
	public static var ActionAntiGravitor:int = 12;
	public static var ActionGravWell:int = 13;
	public static var ActionBlackHole:int = 14;
	public static var ActionTransition:int = 15;
	public static var ActionWormhole:int = 16;
	public static var ActionLink:int = 17;
	public static var ActionEject:int = 18

	public var m_Action:int = ActionNone;
	public var m_ActionShipNum:int = -1;

	public var m_ShipPlaceCooldown:Number=0;

	public var m_GalaxyAward:int = 0;

	public var m_UserAnm:uint = 0;
	public var m_UserVersion:uint=0;
	public var m_PactVersion:uint=0;
	public var m_TicketVer:uint=0;
	public var m_HomeworldSectorX:int=0;
	public var m_HomeworldSectorY:int=0;
	public var m_HomeworldPlanetNum:int=-1;
	public var m_HomeworldCotlId:int=0;
	public var m_HomeworldIsland:int=0;
	public var m_CitadelSectorX:Vector.<int> = new Vector.<int>(Common.CitadelMax);
	public var m_CitadelSectorY:Vector.<int> = new Vector.<int>(Common.CitadelMax);
	public var m_CitadelNum:Vector.<int> = new Vector.<int>(Common.CitadelMax);
	public var m_CitadelCotlId:Vector.<uint> = new Vector.<uint>(Common.CitadelMax);
	public var m_CitadelIsland:Vector.<uint> = new Vector.<uint>(Common.CitadelMax);
	public var m_HomeworldCotlX:int = 0;
	public var m_HomeworldCotlY:int = 0;
	public var m_CitadelCotlX:Vector.<int> = new Vector.<int>(Common.CitadelMax);
	public var m_CitadelCotlY:Vector.<int> = new Vector.<int>(Common.CitadelMax);
	public var m_FleetPosAnm:int = 0;
	public var m_FleetPosX:int = 0;
	public var m_FleetPosY:int = 0;
	public var m_FleetAction:int = 0;
	public var m_FleetTgtId:uint = 0;
	public var m_FleetFuelUse:int = 0;
	public var m_UserPlanetCnt:int=0;
	public var m_UserEmpirePlanetCnt:int = 0;
	public var m_UserEnclavePlanetCnt:int = 0;
	public var m_UserColonyPlanetCnt:int = 0;
	public var m_UserGravitorSciCnt:int = 0;
	public var m_UserKlingDestroyCnt:int=0;
	public var m_UserDominatorDestroyCnt:int=0;
	public var m_UserStatShipCnt:Array = new Array();
	public var m_UserStatMineCnt:int = 0;
	public var m_UserAccess:uint = 0;
	public var m_UserAddModuleEnd:Number;
	public var m_UserCaptainEnd:Number;
	public var m_UserTechEnd:Number;
	public var m_UserControlEnd:Number;
	public var m_UserEGM:int=0;
	public var m_UserSDMMax:int=0;
	public var m_UserSDM:int=0;
	public var m_UserHourPlanetShield:uint=0;
	public var m_UserFlag:uint=0;
	public var m_UserPlanetShieldCooldown:Number=0;
	public var m_UserPlanetShieldEnd:Number=0;
	public var m_UserResearchSpeed:int=0;
	public var m_UserResearchLeft:int=0;
	public var m_UserResearchTech:int=0;
	public var m_UserResearchDir:int=0;
	public var m_UserResearchTechNext:int=0;
	public var m_UserResearchDirNext:int=0;
	public var m_UserAccessKey:uint=0;
	public var m_UserEmpireCreateTime:Number=0;
	public var m_UserMulTime:int=0;
	public var m_UserRelocate:int = 0;
	public var m_UserCitadelBuildDate:Number = 0;
	public var m_UserQuestId:Vector.<int> = new Vector.<int>(QEManager.QuestMax);
	public var m_UserExistClone:Boolean = false;
	public var m_UnionId:uint=0;
	public var m_UnionAccess:uint=0;
	public var m_UnionIdOld:uint=0;
	public var m_UnionHelloPrint:String = "";

	public var m_LastViewCitadelCotlId:int = 0;
	public var m_LastViewCitadelSecX:int = 0;
	public var m_LastViewCitadelSecY:int = 0;
	public var m_LastViewCitadelPlanet:int = 0;

	public var m_UserCombatRating:uint = 0;
	public var m_UserCombatId:uint = 0;
	public var m_CombatMass:int = 0;
	public var m_CombatMassMax:int = 0;
	public var m_CombatFlag:uint = 0;

//	public var m_MapEditor:Boolean = false;
	public var m_AutoOff:Boolean = false;

	public var m_UpdateSendNum:uint;
	public var m_UpdateRecvNum:uint;
	public var m_SendActionAfterRecvNum:uint;

	public var m_LogicAction:Array=new Array();

	public var m_PathLayer:MovieClip;
	public var m_PathLayer2:MovieClip;
	public var m_ShipPlaceList:Vector.<GraphShipPlace> = new Vector.<GraphShipPlace>();
	public var m_VisLayer:Bitmap;
	public var m_ShieldLayer:MovieClip;
	public var m_FindLayer:MovieClip;
	public var m_TxtLayer:MovieClip;
	public var m_TxtLayer2:MovieClip;
	public var m_TxtExtractLayer:TextField;

	public var m_FormTime:FormTime;
	public var m_FormInfoBar:FormInfoBar;
	public var m_FormCptBar:FormCptBar;
	public var m_FormFleetBar:FormFleetBar;
	public var m_FormQuestBar:FormQuestBar;
	
	// Float form
	public var m_FormMiniMap:FormMiniMap;
	public var m_FormRadar:FormRadar;
	public var m_FormBattleBar:FormBattleBar;
	public var m_FormFleetItem:FormFleetItem;
	public var m_FormPlanet:FormPlanet;
//	public var m_FormFleetType:FormFleetType;
	public var m_FormItemBalans:FormItemBalans;
	public var m_FormCombat:FormCombat;
	public var m_FormNews:FormNews;

	//
	public var m_FormDialog:FormDialog;
	public var m_Hangar:Hangar;
	public var m_FormChat:FormChat;
	public var m_MoveItem:GraphMoveItem;
	public var m_FormConstruction:FormConstruction;
	public var m_FormBuild:FormBuild;
	public var m_FormSplit:FormSplit;
	public var m_FormTech:FormTech;
	public var m_FormTalent:FormTalent;
	public var m_FormRace:FormRace;
	public var m_FormTeamRel:FormTeamRel;
	public var m_FormPortal:FormPortal;
	public var m_FormPlusar:FormPlusar;
	public var m_FormPactList:FormPactList;
	public var m_FormItemManager:FormItemManager;
	public var m_FormQuestManager:FormQuestManager;
	public var m_FormItemImg:FormItemImg;
	public var m_FormPact:FormPact;
	public var m_FormHist:FormHist;
	public var m_FormStorage:FormStorage;
	public var m_FormUnion:FormUnion;
	public var m_FormUnionNew:FormUnionNew;
	public var m_FormSet:FormSet;
	public var m_FormExit:FormExit;
	public var m_FormNewCpt:FormNewCpt;
	public var m_FormInput:FormInput;
	public var m_FormBegin:Sprite = null;
	public var m_FormEnter:FormEnter;
	public var m_FormMenu:FormMenu;
//	public var m_FormMenuEx:CtrlPopupMenu;
	public var m_FPSLayer:TextField;

	public var m_Info:Info;

	public var m_GraphSelect:GraphSelect = null;
	public var m_GraphMovePath:GraphMovePath = null;

	public var m_RelVersion:uint=0;
	public var m_Rel:ByteArray = new ByteArray();
	public var m_RelCnt:int = 0;
	public var m_RelOwnerNum:Dictionary = new Dictionary();

	public var m_ScrollTime:Number;
	public var m_ScrollOn:Boolean=false;
	
	public var m_FirstEnterCotl:Boolean=true;

	public var m_Test:Boolean;

	public var m_CMShipBuildType:Array=[Common.ShipTypeCorvette,Common.ShipTypeCruiser,Common.ShipTypeDreadnought,Common.ShipTypeDevastator,Common.ShipTypeInvader/*,Common.ShipTypeDevastator*/,Common.ShipTypeWarBase,Common.ShipTypeShipyard,Common.ShipTypeSciBase,Common.ShipTypeTransport];
	public var m_CMItemBuild:Array=new Array();

	public var m_LoaderPlanet:Loader=null;
	public var m_LoaderShip:Loader=null;
	public var m_LoaderCommon:Loader=null;
	public var m_LoadComplate:Boolean=false;

	public var m_ContentMenuShow:Boolean = false;
	
	static public const DebugAISpace:uint = 1;
	static public const DebugAIShip:uint = 2;

	public var m_Timer:Timer=new Timer(10);//30); //20

	public var m_SendGv_Time:Number = 0;

	public var m_ScrollLeft:Boolean=false;
	public var m_ScrollRight:Boolean=false;
	public var m_ScrollUp:Boolean=false;
	public var m_ScrollDown:Boolean=false;

	public var m_GoToBirthSector:Boolean=true;

	public var m_GoShow:Boolean=false;
	public var m_GoCotlId:uint=0;
	public var m_GoSectorX:int=0;
	public var m_GoSectorY:int=0;
	public var m_GoPlanet:int=-1;
	public var m_GoShipNum:int=-1;
	public var m_GoShipId:int=0;
	public var m_GoOpen:Boolean=false;

	public var m_Set_Hint:Boolean = true;

	public var m_Set_Ship:Boolean = true;
	public var m_Set_ShipGraph:Boolean = true;
	public var m_Set_ShipText:Boolean = true;
	public var m_Set_Planet:Boolean=true;
	public var m_Set_Item:Boolean=true;
	public var m_Set_Bullet:Boolean=true;
	public var m_Set_Explosion:Boolean=true;
	public var m_Set_VisOn:Boolean = false;
	public var m_Set_Unprintable:Boolean = true;
	public var m_Set_ScopeVis:Boolean = true;
	public var m_Set_FPSOn:Boolean=false;
	public var m_Set_FPSMax:int = 100;
	public var m_Set_ShieldPercent:Boolean = false;
	
	public var m_Set_ShowWormholePoint:Boolean = false;
	public var m_Set_ShowColony:Boolean = false;
	public var m_Set_ShowGravitor:Boolean = false;
	public var m_Set_ShowMine:Boolean = false;
	public var m_Set_ShowNoCapture:Boolean = false;
	
	public var m_FPS_UpdatePeriod:int=1;
	public var m_FPS:int=0;
	public var m_FPSCalc:int=0;
	public var m_FPSCalcTime:Number=0;
	
	public var m_NetStatOn:Boolean = false;
	
	public var m_ImgPortal:BitmapData = null;
	public var m_ImgPortal2:BitmapData = null;
	
	public var m_TmpVal:Number=0;

	public var m_ReconnectTimer:Timer=new Timer(1000,1);

	public var m_LockTimeNewId:Number=0;
	
	public var m_ActionNoComplate:int=0;
	public var m_LoadUserAfterActionNo:int=0;
	public var m_LoadUserAfterActionNo_Time:Number=0;
	
	public var m_ImgStdUnionLarge:BitmapData=new ImgStdUnionLarge(0,0);
	public var m_ImgStdUnionSmall:BitmapData=new ImgStdUnionSmall(0,0);

	public var m_TxtTime:Number=0;
	public var m_TxtVersion:uint=0;
	public var m_TxtCotlVersion:uint=0;
	public var m_Txt:ByteArray=new ByteArray();
	public var m_TxtCotl:ByteArray=new ByteArray();

	public var m_ItemVersion:uint=0;
	public var m_GalaxyAllCotlCnt:int = 0;

	public var m_TeamRel:Array=new Array((1<<Common.TeamMaxShift)*(1<<Common.TeamMaxShift));
	public var m_TeamRelVer:uint=0;

	public var m_SpawnList:Array = new Array();

	public var m_Reenter:Boolean = false;

	public var m_ItfNews:Boolean = false;
	public var m_ItfChat:Boolean = false;
	public var m_ItfBattle:Boolean = false;
	public var m_ItfFleet:Boolean = false;

	//private var m_MemoryController:MemoryController = new utils.MemoryController();

	public var m_RotateShipTimer:Timer = new Timer(5);

	public var m_MB_ItemType:uint = 0;
	public var m_MB_SectorX:int = 0;
	public var m_MB_SectorY:int = 0;
	public var m_MB_PlanetNum:int = 0;
	public var m_MB_LoadSector:Array = new Array();
	public var m_MB_Send:Boolean = false;
	public var m_MB_Hist:Array = new Array();

	public var m_ViewBattleTimeSelfWithUser:Number = 0; // Как давно мы видели, что наши корабли сражались с кораблями другого игрока

	public var m_ShowWelcome:Boolean = false;

	public var m_MatView:PerspectiveMatrix3D = new PerspectiveMatrix3D();
	public var m_MatViewInv:Matrix3D = new Matrix3D();
	public var m_MatPer:PerspectiveMatrix3D = new PerspectiveMatrix3D();
	public var m_MatViewPer:Matrix3D = new Matrix3D();
	public var m_Frustum:C3DFrustum = new C3DFrustum();

	public var m_CamSectorX:int = 0;
	public var m_CamSectorY:int = 0;
	public var m_CamPos:Vector3D = new Vector3D();
	public var m_CamRotate:Number = 0 * Space.ToRad;
	public var m_CamAngle:Number = 180.0 * Space.ToRad;// * C3D.ToRad;

	static public const CamDistMin:Number=2000.0;
	static public const CamDistMax:Number=6000.0;
	static public const CamDistDefault:Number = 3700.0;
	static public const CamDistArray:Vector.<Number> = new <Number>[2000.0, 2850.0, 3700.0, 4850.0, 6000.0];
	public var m_CamDist:Number = CamDistDefault;
	public var m_CamDistTo:Number = CamDistDefault;
	public var m_CamDistTime:Number = 0;
	public var m_CamDistDir:int = 0;
	public var m_CamDistChangeTime:Number = 0;
	public var m_FactorScr2WorldDist:Number = 1.0;

	public var m_Fov:Number = 15.0 * C3D.ToRad;
	public var m_FovHalfTan:Number = Math.tan(m_Fov * 0.5);

	public var m_LightPlanetRotate:Number = 1.0471975511965976;
	public var m_LightPlanetAngle:Number = -2.303834612632513;
	public var m_LightPlanet:Vector3D = new Vector3D(1.0, 1.0, 0.5);
	public var m_View:Vector3D = new Vector3D(0.0, 0.0, 0.0);
	
	public var m_SysModify:int = 0; // 0-off 1-view 3-planetlight

	public var m_ConsumptionType:Vector.<uint> = new Vector.<uint>(4, true);
	public var m_ConsumptionCnt:Vector.<int> = new Vector.<int>(4, true);

	static public var m_TPos:Vector3D = new Vector3D();
	static public var m_TDir:Vector3D = new Vector3D();
	static public var m_TPlane:Vector3D = new Vector3D();
	static public var m_TMatrixA:Matrix3D = new Matrix3D();
	static public var m_TMatrixB:Matrix3D = new Matrix3D();
	static public var m_TMatrixC:Matrix3D = new Matrix3D();
	static public var m_TV0:Vector3D = new Vector3D();
	static public var m_TV1:Vector3D = new Vector3D();
	static public var m_TV2:Vector3D = new Vector3D();
	static public var m_TV3:Vector3D = new Vector3D();
	
	public function IsWinMaxEnclave():Boolean { return (m_CotlType == Common.CotlTypeRich) && (m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinMaxEnclave; }
	public function IsWinOccupyHomeworld():Boolean { return (m_CotlType == Common.CotlTypeRich) && (m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinOccupyHomeworld; }
	public function IsAccountTmp():Boolean { if (m_UserFlag & Common.UserFlagAccountTmp) return true; return false; }

	public function get OffsetX():int { return m_CamPos.x + m_CamSectorX * m_SectorSize; }
	public function get OffsetY():int { return m_CamPos.y + m_CamSectorY * m_SectorSize; }

	public function get ScopeVis():Boolean { return m_Set_ScopeVis && (!C3D.m_GraphSimple); }

//		public var m_Window:NativeWindow = null;

	public override function AddDebugMsg(str:String):void { m_FormChat.AddDebugMsg(str); }

	public function EmpireMap()
	{
		super();
		Self = this;
		
		CONFIG::mobil {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}

		var so:SharedObject = SharedObject.getLocal("EGEmpireData");
		if (so != null) so.data.test = 123;
	}
	
	public override function init():void
	{
		super.init();

		BaseStr.TagSetCallback("user", TagUser);

		var i:int;

		SP = new Space(null);
		HS = new Hyperspace(this, SP);
		SP.HS = HS;

		HS.m_CurTime = m_CurTime;
		HS.m_ServerTime = m_ServerCalcTime;

		QEManager.Self = new QEManager();

		m_RotateShipTimer.addEventListener("timer", RotateShipTimer);
		m_RotateShipTimer.start();

		m_ImgPortal = new ImgPortal(80, 88);
		m_ImgPortal2 = new ImgPortal2(80, 88);

		m_Rel.endian=Endian.LITTLE_ENDIAN;
		m_Txt.endian=Endian.LITTLE_ENDIAN;
		m_TxtCotl.endian=Endian.LITTLE_ENDIAN;

		Common.CalcFinalPower(4000);

		Common.LangInitRus();

		Server.Self=new Server();
		Server.Self.addEventListener("ConnectClose", RecvConnectClose);

		LoadManager.Self = new LoadManager();
		LoadManager.Self.addEventListener(ProgressEvent.PROGRESS, PreloaderUpdate);
		LoadManager.Self.addEventListener("LoadError", LoadError);
		LoadManager.Self.addEventListener("Complete", PreloaderComplate);

		UserList.Self = new UserList();
		
		m_Test=false;

		m_UpdateSendNum=1;
		m_UpdateRecvNum=0;
		m_SendActionAfterRecvNum=0;

		m_ServerCalcTimeSyn = 0;
		m_ServerCalcTimeSynRecvTime = 0;

		m_ServerGlobalTimeSyn = 0;
		m_ServerGlobalTimeSynRecvTime=0;

		//m_UserId=0;

		m_CurSectorX=0;
		m_CurSectorY=0;
		m_CurPlanetNum=0;

		m_BG = new GraphBG(this);
		m_BG.visible = false;
		addBeforeFloat(m_BG);

		m_PathLayer = new MovieClip();
		m_PathLayer.mouseEnabled = false;
		m_PathLayer.mouseChildren = false;
		addBeforeFloat(m_PathLayer);

		m_PathLayer2 = new MovieClip();
		m_PathLayer2.mouseEnabled = false;
		m_PathLayer2.mouseChildren = false;
		addBeforeFloat(m_PathLayer2);

		m_VisLayer = new Bitmap();
		addBeforeFloat(m_VisLayer);

		m_ShieldLayer = new MovieClip();
		m_ShieldLayer.mouseEnabled = false;
		m_ShieldLayer.mouseChildren = false;
		addBeforeFloat(m_ShieldLayer);

		m_FindLayer = new MovieClip();
		m_FindLayer.mouseEnabled = false;
		m_FindLayer.mouseChildren = false;
		addBeforeFloat(m_FindLayer);

		m_GraphSelect = new GraphSelect(this);

		m_TxtLayer = new MovieClip();
		m_TxtLayer.mouseEnabled = false;
		m_TxtLayer.mouseChildren = false;
		addBeforeFloat(m_TxtLayer);

		m_TxtLayer2 = new MovieClip();
		m_TxtLayer2.mouseEnabled = false;
		m_TxtLayer2.mouseChildren = false;
		addBeforeFloat(m_TxtLayer2);
		
		m_FormTime=new FormTime(this);
		addBeforeFloat(m_FormTime);

		addBeforeFloat(HS);

		m_Hangar=new Hangar(this);
		m_Hangar.visible=false;
		addBeforeFloat(m_Hangar);

		m_FormInfoBar=new FormInfoBar(this);
		addBeforeFloat(m_FormInfoBar);
		m_FormInfoBar.Hide();

		m_TxtExtractLayer=new TextField();
		m_TxtExtractLayer.visible=false;
		m_TxtExtractLayer.width=1;
		m_TxtExtractLayer.height=1;
		m_TxtExtractLayer.type=TextFieldType.DYNAMIC;
		m_TxtExtractLayer.selectable=false;
		m_TxtExtractLayer.border=true;
		m_TxtExtractLayer.borderColor=0xffff00;
		m_TxtExtractLayer.background=true;
		m_TxtExtractLayer.backgroundColor=0x000000;
		m_TxtExtractLayer.multiline=false;
		m_TxtExtractLayer.autoSize=TextFieldAutoSize.LEFT;
		m_TxtExtractLayer.antiAliasType=AntiAliasType.ADVANCED;
		m_TxtExtractLayer.gridFitType=GridFitType.PIXEL;
		m_TxtExtractLayer.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_TxtExtractLayer.embedFonts=true;
		m_TxtExtractLayer.alpha=0.8;
		addBeforeFloat(m_TxtExtractLayer);

		// Float form
		m_FormCptBar=new FormCptBar(this);
		m_FormCptBar.Hide();
		addIntoFloat(m_FormCptBar);
		
		m_FormFleetBar=new FormFleetBar(this);
		m_FormFleetBar.Hide();
		addIntoFloat(m_FormFleetBar);

		m_FormChat=new FormChat();
		m_FormChat.Hide()
		addIntoFloat(m_FormChat);

		m_FormMiniMap=new FormMiniMap(this);
		m_FormMiniMap.Hide();
		addIntoFloat(m_FormMiniMap);

		m_FormRadar=new FormRadar(this);
		m_FormRadar.Hide();
		addIntoFloat(m_FormRadar);

		m_FormBattleBar=new FormBattleBar();
		m_FormBattleBar.Hide();
		addIntoFloat(m_FormBattleBar);

		m_FormFleetItem=new FormFleetItem(this);
		m_FormFleetItem.Hide();
		addIntoFloat(m_FormFleetItem);
		
		m_FormPlanet=new FormPlanet(this);
		m_FormPlanet.Hide()
		addIntoFloat(m_FormPlanet);
		
		m_FormItemBalans=new FormItemBalans(this);
		m_FormItemBalans.Hide()
		addIntoFloat(m_FormItemBalans);

//		m_FormFleetType = new FormFleetType(this);
//		m_FormFleetType.Hide();
//		addIntoFloat(m_FormFleetType);
		
		m_FormHist=new FormHist(this);
		m_FormHist.visible=false;
		addIntoFloat(m_FormHist);

		m_FormStorage=new FormStorage(this);
		m_FormStorage.visible=false;
		addIntoFloat(m_FormStorage);

		m_FormCombat = new FormCombat(this);
		m_FormCombat.visible = false;
		addIntoFloat(m_FormCombat);

		m_FormNews = new FormNews(this);
		m_FormNews.visible = false;
		addIntoFloat(m_FormNews);

		m_FormQuestBar=new FormQuestBar(this);
		m_FormQuestBar.Hide();
		addIntoFloat(m_FormQuestBar);

		m_FormPlusar=new FormPlusar(this);
		addIntoFloat(m_FormPlusar);

		m_FormSet=new FormSet();
		addIntoFloat(m_FormSet);

		m_FormDialog = new FormDialog();// this);
		addIntoFloat(m_FormDialog);
//		addIntoFloat(new FormAialog());

		m_FormExit=new FormExit(this);
		addIntoFloat(m_FormExit);

		m_FormNewCpt=new FormNewCpt(this);
		addIntoFloat(m_FormNewCpt);

		//
		m_GraphMovePath=new GraphMovePath(this);

		m_FormConstruction=new FormConstruction(this);
		m_FormConstruction.Hide()
		addAfterFloat(m_FormConstruction);

		m_FormBuild=new FormBuild(this);
		m_FormBuild.visible=false;
		addAfterFloat(m_FormBuild);

		m_FormSplit=new FormSplit(this);
		m_FormSplit.visible=false;
		addAfterFloat(m_FormSplit);

		m_FormTech=new FormTech(this);
		m_FormTech.visible=false;
		addAfterFloat(m_FormTech);

		m_FormTalent=new FormTalent(this);
		m_FormTalent.visible=false;
		addAfterFloat(m_FormTalent);

		m_FormRace=new FormRace(this);
		m_FormRace.visible=false;
		addAfterFloat(m_FormRace);

		m_FormTeamRel=new FormTeamRel(this);
		m_FormTeamRel.visible=false;
		addAfterFloat(m_FormTeamRel);

		m_FormPortal=new FormPortal(this);
		m_FormPortal.visible=false;
		addAfterFloat(m_FormPortal);

		m_FormPactList=new FormPactList(this);
		m_FormPactList.visible=false;
		addAfterFloat(m_FormPactList);
		
		m_FormItemManager=new FormItemManager(this);
		m_FormItemManager.visible=false;
		addAfterFloat(m_FormItemManager);
		
		m_FormQuestManager = new FormQuestManager(this);
		m_FormQuestManager.visible = false;
		addAfterFloat(m_FormQuestManager);

		m_FormItemImg=new FormItemImg(this);
		m_FormItemImg.visible=false;
		addAfterFloat(m_FormItemImg);

		m_FormPact=new FormPact(this);
		m_FormPact.visible=false;
		addAfterFloat(m_FormPact);
		
		m_FormUnion=new FormUnion(this);
		m_FormUnion.visible=false;
		addAfterFloat(m_FormUnion);

		m_FormUnionNew=new FormUnionNew(this);
		m_FormUnionNew.visible=false;
		addAfterFloat(m_FormUnionNew);

		m_FormInput=new FormInput(this);
		m_FormInput.visible=false;
		addAfterFloat(m_FormInput);
		
		m_FormBegin = new Sprite();
		m_FormBegin.visible = false;
		addAfterFloat(m_FormBegin);

		m_FormEnter = new FormEnter(this);
		addAfterFloat(m_FormEnter);

		m_MoveItem = new GraphMoveItem(this);
		m_MoveItem.visible = false;
		addAfterFloat(m_MoveItem);
		
		m_FormMenu=new FormMenu();
		m_FormMenu.visible = false;
		addAfterFloat(m_FormMenu);

//		m_FormMenuEx = new CtrlPopupMenu();
		
		m_FPSLayer=new TextField();
		m_FPSLayer.visible=false;
		m_FPSLayer.width=1;
		m_FPSLayer.height=1;
		m_FPSLayer.type=TextFieldType.DYNAMIC;
		m_FPSLayer.selectable=false;
		m_FPSLayer.textColor=0xffffff;
		m_FPSLayer.background=true;
		m_FPSLayer.backgroundColor=0x80000000;
		m_FPSLayer.multiline=false;
		m_FPSLayer.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_FPSLayer.autoSize=TextFieldAutoSize.LEFT;
		m_FPSLayer.gridFitType=GridFitType.NONE;
		m_FPSLayer.embedFonts=true;
		m_FPSLayer.text="FPS: 0";
		m_FPSLayer.alpha=0.6;
		addAfterFloat(m_FPSLayer);

		m_Info=new Info(this);
		addAfterFloat(m_Info);
		m_Info.Hide();

		m_PlanetList=new Array();
		m_ShipList=new Array();
		m_ItemList = new Array();

		m_CamSectorX = 0;
		m_CamSectorY = 0;
		m_CamPos.x = 0;
		m_CamPos.y = 0;
		m_CamPos.z = 0;

		m_MoveMap=false;
		m_MoveMapBegin=false;
		
		m_SectorSize=0;
		m_CotlType=0;
		m_CotlOwnerId=0;
		m_CotlUnionId=0;
		m_CotlZoneLvl=0;
		m_EmpireColony=false;
		m_SectorMinX=0;
		m_SectorMinY=0;
		m_SectorCntX=0;
		m_SectorCntY=0;
		m_WorldVer = 0;
		m_StateVer = 0;
		m_Edit=false;
		m_BuildSpeed=256;
		m_ModuleMul=1;
		m_ResMul=1;
		m_SupplyMul=1;
		m_TechSpeed=256;
		m_InfrCostMul=256;
		m_EmpireLifeTime=0;
		m_SessionPeriod=0;
		m_SessionStart = 0;
		m_StateLoad = true;
		m_GameState=0;
		m_GameTime=0;
		m_ReadyTime=0;
		m_Access = 0;
		m_PlanetDestroy = 0;

		m_WaitAnswer=0;
		m_WaitAnswer2=0;
		
		m_ScrollTime=0;

		var now:Date = new Date();
		m_NoCacheStr=""+now.fullYear+""+now.month+""+now.date+""+now.hours+""+now.minutes+""+now.seconds;
		m_NoCacheNo=0;
		//trace(m_NoCacheStr);

		if (loaderInfo.parameters["Protocol"] != undefined) {
			if (loaderInfo.parameters["Protocol"] == "Raw") Server.Self.m_Protocol = Server.ProtocolRaw;
			else if (loaderInfo.parameters["Protocol"] == "SocketHTTP") Server.Self.m_Protocol = Server.ProtocolSocketHTTP;
			else if (loaderInfo.parameters["Protocol"] == "PostHTTP") Server.Self.m_Protocol = Server.ProtocolPostHTTP;
			else if (loaderInfo.parameters["Protocol"] == "DefaultHTTP") Server.Self.m_Protocol = Server.ProtocolDefaultHTTP;
		}

		if(loaderInfo.parameters["ServerAdr"]!=undefined) {
			RunFromLocal=false;
			Server.Self.m_ServerAdr=loaderInfo.parameters["ServerAdr"];
			if(Server.Self.m_ServerAdr.length>0) {
				Server.Self.m_ServerAdr="http://"+Server.Self.m_ServerAdr+"/";
				Security.loadPolicyFile(Server.Self.m_ServerAdr+"crossdomain.xml");
			}
		}
		Server.Self.m_HyperserverServerAdr = Server.Self.m_ServerAdr;
		//Security.loadPolicyFile("http://elementalgames.com:8888/crossdomain.xml");

		if(loaderInfo.parameters["LocalChat"]!=undefined) {
			Server.Self.m_LocalChatName=loaderInfo.parameters["LocalChat"];
		} else {
			Server.Self.m_LocalChatName = "Empire.Andromeda";
		}

//			if(m_Session.length<=0) {
//				m_FormEnter.Run();
//			} else {
//				m_FormEnter.Connect();
//				var loader:URLLoader = new URLLoader();
//				loader.dataFormat = URLLoaderDataFormat.BINARY;
//				loader.addEventListener(Event.COMPLETE, ConnectComplete);
//				//loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ConnectErrorSec);
//				loader.addEventListener(IOErrorEvent.IO_ERROR, ConnectError);
//				var lr:URLRequest = new URLRequest("http://www.elementalgames.com:8000/emconnect?s="+m_Session+"&nc="+m_NoCacheStr+m_NoCacheNo); m_NoCacheNo++;
////				lr.cacheResponse=false;
////				lr.useCache=false;
//				loader.load(lr);
//			}

		Update();

		//stage.doubleClickEnabled=true; 
		//stage.addEventListener(MouseEvent.DOUBLE_CLICK,onDblClick);
		//doubleClickEnabled=true; 
		//addEventListener(MouseEvent.DOUBLE_CLICK,onDblClick,true);
		
		m_Timer.addEventListener("timer",Takt);
		m_Timer.start();
		
		m_ReconnectTimer.addEventListener("timer",ReconnectTimer);
		m_ReconnectTimer.stop();

		LoadGraphBegin();

//			startSampling();
	}

	public override function InitializeC3D():void
	{
		super.InitializeC3D();
		Common.IemTexClear();
		GraphShip.ClearTextTex();
		
		if (m_FormEnter != null) m_FormEnter.ShowVersion();
	}
	
	public function TagUser(src:String):String
	{
		var ch:int;
		var ts:int = 0;
		var tl:int = src.length;

		while (tl > 0) {
			ch = src.charCodeAt(ts);
			if (ch != 32 && ch != 9) break;
			ts++;
			tl--;
		}

		var add:int = BaseStr.ParseIntLen(src, ts, tl);
		if (add <= 0) return "[User " + src + "]";

		var id:uint = uint(src.substr(ts, add));

		var user:User = UserList.Self.GetUser(id);
		if (user != null) {
			return "[" + Txt_CotlOwnerName(0, id) + "]";
		}

		return "[User " + id.toString() + "]";
	}

	public function AfterLoadGraph():void
	{
		var sfe:Boolean=true;
		//while(Server.Self.m_Protocol != Server.ProtocolDefaultHTTP) {
		while(true) {
			if(loaderInfo.parameters["SessionUserId"]==undefined) break;
			//if(loaderInfo.parameters["SessionIPKey"]==undefined) break;
			if(loaderInfo.parameters["ServerEnterKey"]==undefined) break;

			var userid:uint=uint(loaderInfo.parameters["SessionUserId"]);
			if(!userid) break;

			//var session:String=loaderInfo.parameters["SessionIPKey"];
			//if(session.length<=0) break;

			Server.Self.m_UserId=userid;
			Server.Self.m_Session=loaderInfo.parameters["ServerEnterKey"];
			Server.Self.m_ServerEnterKey=loaderInfo.parameters["ServerEnterKey"];
			//if(Server.Self.m_ServerEnterKey.length<=0) break;

			//m_UserId=userid;
//				m_Session=session;
			//Server.Self.ConnectAccept(userid,session);

			sfe=false;
			m_FormEnter.Connect();
			break;
		}
		if(sfe) {
			m_FormEnter.Show();
		}
	}

	public override function onDeactivate(e:Event):void
	{
		super.onDeactivate(e);
		
		m_ScrollLeft=false;
		m_ScrollRight=false;
		m_ScrollUp=false;
		m_ScrollDown = false;
		
		m_MoveMap=false;
		m_MoveMapBegin=false;
		m_Action = ActionNone;
	}
	
	public function BeforeConnect():void
	{
		var i:int;
		
		m_EmpireEdit=false;
		
		var user:User=null;
		if (Server.Self.m_UserId != 0) user = UserList.Self.GetUser(Server.Self.m_UserId, false);
		
		m_FormChat.m_OnlineUserVersion=0;

		m_FormInfoBar.TicketClear();
		m_FormCptBar.Clear();
		m_FormQuestBar.Clear();
		m_FormFleetBar.Clear();
		m_FormFleetItem.Clear();

		m_ServerCalcTimeSyn = 0;
		m_ServerCalcTimeSynRecvTime = 0;

		m_ServerGlobalTimeSyn = 0;
		m_ServerGlobalTimeSynRecvTime=0;

		m_StateConnect = 0;
		m_StateGv = false;
		m_StateCurUser = false;
		m_StateCpt = false;
		m_StateSector = false;
		m_StateEnterCotl = false;
		m_StateQuest = false;
		
		m_UserAnm = 0;
		m_UserVersion=0;
		m_PactVersion=0;
		m_TicketVer=0;
		m_FormMiniMap.m_MapVersion=0;
		m_UserPlanetCnt=0;
		m_UserEmpirePlanetCnt = 0;
		m_UserEnclavePlanetCnt = 0;
		m_UserColonyPlanetCnt = 0;
		m_UserGravitorSciCnt = 0;
		m_UserKlingDestroyCnt=0;
		m_UserDominatorDestroyCnt=0;

		if(user) {
			for(i=0;i<Common.TechCnt;i++) user.m_Tech[i]=0;
		}
		m_UserResearchSpeed=0;
		m_UserResearchLeft=0;
		m_UserResearchTech=0;
		m_UserResearchDir=0;
		m_UserResearchTechNext=0;
		m_UserResearchDirNext=0;
		m_UserAddModuleEnd=0;
		m_UserCaptainEnd=0;
		m_UserTechEnd=0;
		m_UserControlEnd=0;
		m_UserEGM=0;
		m_UserSDMMax=0;
		m_UserSDM=0;
		m_UserHourPlanetShield=0;
		m_UserFlag=0;
		m_UserPlanetShieldCooldown=0;
		m_UserPlanetShieldEnd = 0;
		for (i = 0; i < QEManager.QuestMax; i++) m_UserQuestId[i] = 0;
		m_UnionId=0;
		m_UnionIdOld=0;
		m_UnionAccess=0;
		m_UnionHelloPrint = "";
		m_FleetPosAnm = 0;
		m_FleetPosX = 0;
		m_FleetPosY = 0;
		m_FleetAction = 0;
		m_FleetTgtId = 0;
		m_FleetFuelUse = 0;
		
		for (i = 0; i < Common.CitadelMax;i++) {
			m_CitadelSectorX[i] = 0;
			m_CitadelSectorY[i] = 0;
			m_CitadelNum[i] = -1;
			m_CitadelCotlId[i] = 0;
		}

		m_LastViewCitadelCotlId = 0;
		m_LastViewCitadelSecX = 0;
		m_LastViewCitadelSecY = 0;
		m_LastViewCitadelPlanet = 0;

		m_UserCombatRating = 0;
		m_UserCombatId = 0;

		m_TxtTime=0;
		m_TxtCotlVersion=0;
		
//		m_MapEditor = false;
		m_AutoOff = false;

		m_FirstEnterCotl=true;
		
		m_FormRadar.m_GalaxyMapTime=0;
		m_FormRadar.m_GalaxyMapVersion=0;
		
		m_ItemVersion = 0;
		
		m_GalaxyAllCotlCnt = 0;
		
		ClearForNewConn();

		m_UserStatShipCnt.length=0;
		for (i = 0; i < Common.ShipTypeCnt; i++) m_UserStatShipCnt.push(0);
		m_UserStatMineCnt = 0;
		
		m_FormTime.Hide();
		
		m_FormUnionNew.m_Access = true; 
	}
	
	public function ClearForNewCotl():void
	{
		var i:int,cnt:int;
		
		m_Reenter = false;
		
		m_StateSector = false;
		m_StateEnterCotl = false;
		
		cnt=(1<<Common.TeamMaxShift)*(1<<Common.TeamMaxShift);
		for(i=0;i<cnt;i++) m_TeamRel[i]=0;
		m_TeamRelVer=0;
		
		Server.Self.m_ServerKey=-1;
		Server.Self.m_ClearCnt=-1;
		
		m_ActionNoComplate=0;
		m_LoadUserAfterActionNo=0;
		m_LoadUserAfterActionNo_Time = 0;
		
		MB_Clear();
		
		if(m_Sector!=null) m_Sector.length=0;
		m_Sector=null;
		m_CotlType=0;
		m_CotlOwnerId=0;
		m_CotlUnionId=0;
		m_CotlZoneLvl=0;
		m_EmpireColony=false;
		m_SectorMinX=0;
		m_SectorMinY=0;
		m_SectorCntX=0;
		m_SectorCntY = 0;
		m_OpsJumpRadius = Common.DefaultJumpRadius;
		JumpRadius2 = Common.DefaultJumpRadius * Common.DefaultJumpRadius;
		m_WorldVer = 0;
		m_StateVer = 0;
		m_PlanetDestroy = 0;

		m_CombatMass = 0;
		m_CombatMassMax = 0;
		m_CombatFlag = 0;

		m_DefScore = 0;
		m_AtkScore = 0;
		m_BasePlanetCnt = 0;
		m_AllPlanetCnt = 0;
		m_BaseSectorX = 0;
		m_BaseSectorY = 0;
		m_BasePlanetNum= -1;

		//m_Edit=false; здесь не чистим чтобы знать

		m_StateLoad = true;
		m_GameState=0;
		m_GameTime=0;
		m_ReadyTime=0;

		m_UserVersion=0;
		m_PactVersion=0;
		m_TicketVer=0;
		m_RelVersion=0;
		
		m_OpsFlag=0;
		m_OpsModuleMul=0;
		m_OpsCostBuildLvl=0;
		m_OpsSpeedCapture=0;
		m_OpsSpeedBuild=0;
		m_OpsRestartCooldown=0;
		m_OpsStartTime=0;
		m_OpsPulsarActive=0;
		m_OpsPulsarPassive=0;
		m_OpsMaxRating = 0;
		m_OpsWinScore=0;
		m_OpsRewardExp=0;
		m_OpsPriceEnter=0;
		m_OpsPriceEnterType=0;
		m_OpsPriceCapture=0;
		m_OpsPriceCaptureType = 0;
		m_OpsPriceCaptureEgm = 0;
		m_OpsProtectCooldown=0;
		m_OpsTeamOwner = 0;
		m_OpsTeamEnemy = 0;
		
		m_WaitAnswer=0;
		m_WaitAnswer2 = 0;
		
		m_ShowWelcome = false;
		
		m_SpawnList.length = 0;
		
		BulletClear();
		
		m_FormCombat.m_ShowAfterEnd = true;
		
		m_FormMiniMap.Hide();
		m_FormMiniMap.ClearForNewCotl();
		m_FormPlanet.Hide();
		m_FormItemBalans.Hide();
//		m_FormFleetType.Hide();
		
		m_BG.Clear();
	}

	public function ClearForNewConn():void
	{
		ClearForNewCotl();
		
		m_UserExistClone = false;

		m_SendGv_Time = 0;

		m_Edit = false;

		m_ItfNews = false;
		m_ItfChat = false;
		m_ItfBattle = false;
		m_ItfFleet = false;

		m_StateConnect = 0;

		m_GalaxyAward = 0;

		m_ViewBattleTimeSelfWithUser = 0;
		
		m_UserAccess = 0;

		QEManager.Clear();

		m_FormCptBar.m_CptVersion=0;
		m_FormFleetBar.ClearForNewConn();
		m_FormFleetItem.ClearForNewConn();
		HS.ClearForNewConn();
		m_Hangar.ClearForNewConn();
		m_FormCombat.ClearForNewConn();
		if (HS.visible) HS.Hide(); 
		if (m_Hangar.visible) m_Hangar.Hide();
		if (m_FormNews.visible) m_FormNews.Hide();
		m_FormNews.ClearForNewConn();
		m_FormQuestBar.ClearForNewConn();

		m_FormSet.LoadSet();
		var deffps:int=m_Set_FPSMax;
		m_Set_FPSMax=0;
		SetFPSMax(deffps);

		m_FormFleetBar.AutoPilotLoad();
		m_FormFleetBar.AutoGiveLoad();
	}

	public function RecvConnectClose(e:Event):void
	{
//			m_ConnectState=0;

		m_StateConnect = -1;

		m_FormMiniMap.Hide();
		m_FormBattleBar.Hide();
		m_FormInfoBar.Hide();
		m_FormCptBar.Hide();
		m_FormFleetBar.Hide();
		m_FormQuestBar.Hide();
		m_FormFleetItem.Hide();
		m_FormChat.Hide();
		m_FormDialog.Hide();
		HS.ConnectClose();
		FormHideAll();
		Update();

		//m_FormHint.Show(Common.Hint.NoServer);
		//trace("ConnectError: " + event);

		if (C3D.m_FatalError.length <= 0) m_FormEnter.Show();
		else {
			m_FormHint.Show("Fatal error:\n" + C3D.m_FatalError);
		}
	}

	public function IsConnect():Boolean
	{
		return m_StateConnect>0;
	}

	public function IsEdit():Boolean
	{
		return m_Edit;
	}
	
	public function IsEditMap():Boolean
	{
		return IsEdit() && ((CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) != 0);
	}
	
	public function IsViewMap():Boolean
	{
		return IsEdit() && ((CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap) == 0);
	}
	
	public function IsEditCode():Boolean
	{
		return IsEdit() && ((CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditCode) != 0);
	}

	public function GoRootCotl():void
	{
		//var vh=HS.visible;
		//ChangeCotlServer(m_RootCotlId);
		//SetCenter(0,0);
		//m_FormMiniMap.SetCenter(m_OffsetX,m_OffsetY);
		//if(vh) HS.Show();

		if(m_HomeworldPlanetNum>=0) {
			GoTo(false,m_HomeworldCotlId,m_HomeworldSectorX,m_HomeworldSectorY,m_HomeworldPlanetNum);
		} else {
			GoTo(false,m_RootCotlId,0,0,0);
		}
	}

	public function GoTo(show:Boolean, cotlid:uint, secx:int=0, secy:int=0, planetnum:int=-1, shipnum:int=-1, shipid:int=0):void
	{
		m_GoShow=show;
		m_GoCotlId=cotlid;
		m_GoSectorX=secx;
		m_GoSectorY=secy;
		m_GoPlanet=planetnum;
		m_GoShipNum=shipnum;
		m_GoShipId=shipid;
		m_GoOpen = m_GoPlanet < 0;
		
		GoToProcess();
	}
	
	public function GoToProcess():void
	{
//			if(m_GoPlanet<0) return;
		
		if(m_GoCotlId!=Server.Self.m_CotlId || m_Edit==true) {
			var cotl:SpaceCotl=HS.GetCotl(m_GoCotlId);
			if(cotl==null) {
//					m_FormGalaxy.LoadCotlById(m_GoCotlId);
				return;
			}

			//if(!s(m_GoCotlId)) { m_GoCotlId=0; m_GoSectorX=0; m_GoSectorY=0; m_GoPlanet=-1; m_GoShipNum=-1; m_GoShipId=0; }
			ChangeCotlServer(m_GoCotlId);
			return;
		}
		
		if(m_GoPlanet>=0) {
			var ra:Array;
			
			ra=m_FormMiniMap.GetPlanetPos(m_GoSectorX,m_GoSectorY,m_GoPlanet);
			if(ra==null) return;
			
			if (HS.visible) HS.Hide();
			if (m_Hangar.visible) m_Hangar.Hide();

			SetCenter(ra[0],ra[1]);
			m_FormMiniMap.SetCenter(OffsetX,OffsetY);
					
			if (m_GoShow) {
				AddGraphFind(m_GoCotlId,m_GoSectorX,m_GoSectorY,m_GoPlanet,m_GoShipNum,m_GoShipId);
			}
		}
		
		m_GoCotlId=0; m_GoSectorX=0; m_GoSectorY=0; m_GoPlanet=-1; m_GoShipNum=-1; m_GoShipId=0;
	}
	
	public function ChangeCotlServer(cotl_id:uint):void
	{
		var cotl:SpaceCotl = HS.GetCotl(cotl_id);
		if (cotl == null) return;// false;
		//if(cotl.m_ServerAdr==0) return false;
		
		var user:User;

		if(cotl.m_CotlType==Common.CotlTypeUser) {
			user=UserList.Self.GetUser(cotl.m_AccountId/*cotl.m_OwnerId*/);
			if(user==null) return;// false;
			if (user.m_ExitDate != 0 && user.m_ExitDate < GetServerGlobalTime()) return;// false;
		}

		Server.Self.Query("emcotlenter","&id="+cotl.m_Id.toString(),ChangeCotlServerRecv,false);

		//ChangeCotlServerEx(cotl.m_Id,cotl.m_ServerAdr,cotl.m_ServerPort,cotl.m_ServerNum);
		return;// true;
	}
	
	public function ChangeCotlServerRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int = buf.readUnsignedByte();
		if (err == Server.ErrorExist) m_FormHint.Show(Common.TxtEdit.ErrorCotlInEditMode, Common.WarningHideTime);
		else if (err == Server.ErrorInDevelopment) m_FormHint.Show(Common.TxtEdit.ErrorCotlInDevelopment, Common.WarningHideTime);
		if(err) {
			m_GoCotlId=0; m_GoSectorX=0; m_GoSectorY=0; m_GoPlanet=-1; m_GoShipNum=-1; m_GoShipId=0;
			return;
		}

		m_Edit = false;

		var cotlid:uint=buf.readUnsignedInt();
		var adr:uint=buf.readUnsignedInt();
		var port:int=buf.readInt();
		var num:int=buf.readInt();

		if (HS.visible) HS.Hide();
		if (m_Hangar.visible) m_Hangar.Hide();
		ChangeCotlServerEx(cotlid,adr,port,num);
	}

	public function ChangeCotlServerEx(cotl_id:uint, adr:uint, port:uint, num:uint):void
	{
		while(m_CotlType!=0) {
			var cotl:SpaceCotl = HS.GetCotl(Server.Self.m_CotlId);
			if(cotl==null) break;
			cotl.m_OldOffsetSet = true;
			cotl.m_OldOffsetX = OffsetX;
			cotl.m_OldOffsetY = OffsetY;
			break;
		}
		
		ClearForNewCotl();
//			m_ConnectState=0;

		Server.Self.m_CotlId=cotl_id;
		Server.Self.m_ServerAdr="http://"+(adr & 255).toString()+"."+((adr >> 8) & 255).toString()+"."+((adr >> 16) & 255).toString()+"."+((adr >> 24) & 255).toString()+":"+port.toString()+"/";
//trace("ChangeCotlServerAfter",Server.Self.m_ServerAdr,adr);
		Server.Self.m_ServerNum=num;
		
//trace("emconnect from ChangeCotlServerEx");
		Server.Self.Query("emconnect","",ConnectComplete,false);
	}
	
	public function Reenter():void
	{
		ClearForNewCotl();
//			m_ConnectState=0;
		m_Reenter=true;
		Server.Self.Query("emconnect","",ConnectComplete,false);
	}

	public function IsSpaceOff():Boolean
	{
		if(!m_LoadComplate) return true;
		if (m_StateConnect < 0) return true;
		return false;
	}
	
	public function IsSpaceLock():Boolean
	{
		if(IsSpaceOff()) return true;
		if (m_FormBuild.visible) return true;
		if (m_FormConstruction.visible) return true;
		if(m_FormSplit.visible) return true;
		if(m_FormTech.visible) return true;
		if (m_FormTalent.visible) return true;
		if (m_FormRace.visible) return true;
		if(m_FormTeamRel.visible) return true;
		if(m_FormPortal.visible) return true;
		if(m_FormPactList.visible) return true;
		if (m_FormItemManager.visible) return true;
		if (m_FormQuestManager.visible) return true;
		if(m_FormItemImg.visible) return true;
		if(m_FormPact.visible) return true;
		if(m_FormUnion.visible) return true;
		if(m_FormUnionNew.visible) return true;
		if (m_FormInput.visible) return true;
		if(m_FormEnter.visible) return true;
		if(FormMessageBox.Self.visible) return true;
		if (m_FormChat.IsSpaceLock()) return true;
		if (FI.visible && FI.m_SoftLock) return true;

		return false;
	}

	private var m_LoadGraphBeginComplate:Boolean = false;

	public function LoadGraphBegin():void
	{
		LoadManager.Self.m_VerList["ver.txt"] = GameVersion.toString() + "_" + GameVersionSub.toString() + ",0";
		LoadManager.Self.Get("ver.txt");
	}

	public function LoadGraph():void
	{
		if (m_LoaderCommon != null) {
			return;
		}
		if (C3D.m_FatalError.length > 0) return;
		
		//var variables:URLVariables = new URLVariables();
		//variables.ver = GameVersion.toString();
		//var addstr:String="";
		//if(!RunFromLocal) addstr="?ver="+GameVersion.toString();
		
		var r:URLRequest;
		var str:String;

		m_FormHint.Show(Common.Hint.Load);
		
		var ib:int, ie:int;
		for (var key:Object in LoadManager.Self.m_VerList) {
			str = LoadManager.Self.m_VerList[key];
			ib = str.indexOf(",");
			if (ib < 0) continue;
			ib++;
			
			ie = str.indexOf(",", ib);
			if (ie < 0) ie = str.length;
			
			str = str.substring(ib, ie);
			if (int(str) == 0) continue;
			
			LoadManager.Self.Get(key as String);
		}

/*		LoadManager.Self.Get("news_rus.txt");
		LoadManager.Self.Get("stars1.png");
		LoadManager.Self.Get("stars2.png");
		LoadManager.Self.Get("stars3.png");
*/

		var ctx:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);

//			m_LoaderBackground=new Loader();
//			m_LoaderBackground.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,PreloaderUpdate);
//			m_LoaderBackground.contentLoaderInfo.addEventListener(Event.COMPLETE,PreloaderComplate);
//			m_LoaderBackground.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, QueryErrorGraph);
//			//r=new URLRequest(); r.url="empire/gbackground.swf"; r.data = variables;
//			m_LoaderBackground.load(new URLRequest("empire/gbackground.swf"+addstr),ctx);

		m_LoaderPlanet=new Loader();
		m_LoaderPlanet.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,PreloaderUpdate);
		m_LoaderPlanet.contentLoaderInfo.addEventListener(Event.COMPLETE,PreloaderComplate);
		m_LoaderPlanet.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, QueryErrorGraph);
		//r=new URLRequest(); r.url="empire/gplanet.swf"; r.data = variables;
		
		try {
			m_LoaderPlanet.load(new URLRequest(LoadManager.Self.GetFileFromPath("gplanet.swf")), ctx);//
		} catch (e:Object) {
			C3D.m_FatalError += "LoadGraph.Error: " + e.toString() + "\n";
			LoadError(null);
			return;
		}

		m_LoaderShip=new Loader();
		m_LoaderShip.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,PreloaderUpdate);
		m_LoaderShip.contentLoaderInfo.addEventListener(Event.COMPLETE,PreloaderComplate);
		m_LoaderShip.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, QueryErrorGraph);
		//r=new URLRequest(); r.url="empire/gship.swf"; r.data = variables;
		try {
			m_LoaderShip.load(new URLRequest(LoadManager.Self.GetFileFromPath("gship.swf")),ctx);
		} catch (e:Object) {
			C3D.m_FatalError += "LoadGraph.Error: " + e.toString() + "\n";
			LoadError(null);
			return;
		}

		m_LoaderCommon=new Loader();
		m_LoaderCommon.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,PreloaderUpdate);
		m_LoaderCommon.contentLoaderInfo.addEventListener(Event.COMPLETE,PreloaderComplate);
		m_LoaderCommon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, QueryErrorGraph);
		//r=new URLRequest(); r.url="empire/gcommon.swf"; r.data = variables;
		try {
			m_LoaderCommon.load(new URLRequest(LoadManager.Self.GetFileFromPath("gcommon.swf")), ctx);
		} catch (e:Object) {
			C3D.m_FatalError += "LoadGraph.Error: " + e.toString() + "\n";
			LoadError(null);
			return;
		}

/*			m_LoaderDialog=new URLLoader();
		m_LoaderDialog.dataFormat = URLLoaderDataFormat.TEXT;
		m_LoaderDialog.addEventListener(ProgressEvent.PROGRESS,PreloaderUpdate);
		m_LoaderDialog.addEventListener(Event.COMPLETE,PreloaderComplate);
		m_LoaderDialog.addEventListener(IOErrorEvent.IO_ERROR, QueryErrorGraph);
		//r=new URLRequest(); r.url="empire/adviser_rus.txt"; r.data = variables;
		try {
			m_LoaderDialog.load(new URLRequest(LoadManager.Self.GetFileFromPath("adviser_rus.txt")));
		} catch (e:Object) {
			EmpireMap.Self.m_FatalError += "LoadGraph.Error: " + e.toString() + "\n";
			LoadError(null);
			return;
		}*/

		HyperspacePlanetStyle.prepare();
		StyleManager.prepare();
	}

//		public var ttttt:String = "";
	public function QueryErrorGraph(event:IOErrorEvent):void
	{
		C3D.m_FatalError += "LoadGraph.Error: " + event.text + "\n";
		LoadError(event);
		//m_PCE = true;
		//if(event.target is URLLoader) m_FormHint.Show(Common.Hint.Load + ". " + event.text + "\n" + (event.target as URLLoader).toString());
		//else
		
		//m_FormHint.Show(Common.Hint.Load + ". " + event.text);
			
//			ttttt += "\n" + Common.Hint.Load + ". " + event.text
//				+ "\n" + event.target.toString()
//				+"\nPlanet=" + ((event.target == m_LoaderPlanet) || ((event.target is LoaderInfo) && (event.target as LoaderInfo).loader==m_LoaderPlanet)).toString()
//				+"\nShip=" + ((event.target == m_LoaderShip) || ((event.target is LoaderInfo) && (event.target as LoaderInfo).loader==m_LoaderShip)).toString()
//				+"\nLoaderCommon=" + ((event.target == m_LoaderCommon) || ((event.target is LoaderInfo) && (event.target as LoaderInfo).loader==m_LoaderCommon)).toString()
//				+"\nLoaderDialog=" + ((event.target == m_LoaderDialog)).toString();
		//m_FormHint.Show(ttttt);
	}

	public function LoadError(e:Event):void
	{
//			m_FormHint.Show("ERROR: Load");
//			m_FatalError += "LoadError\n";

		if (C3D.m_FatalError.length > 0) {
			m_FormHint.Show("Fatal error:\n" + C3D.m_FatalError);
		}

		m_PCE = true;
		Server.Self.ConnectClose();

//			m_FormEnter.Run();
	}
	
	public function PreloaderUpdate(evt:ProgressEvent = null):void
	{
		if (m_PCE) return;

		var loadcnt:int=0;
		var totalcnt:int = 0;
		
//			if (!Server.Self.IsConnect()) return;

//			loadcnt+=m_LoaderBackground.contentLoaderInfo.bytesLoaded;
//			totalcnt+=m_LoaderBackground.contentLoaderInfo.bytesTotal;

		if(m_LoaderPlanet!=null) {
			loadcnt+=m_LoaderPlanet.contentLoaderInfo.bytesLoaded;
			totalcnt += m_LoaderPlanet.contentLoaderInfo.bytesTotal;
		}

		if(m_LoaderShip!=null) {
			loadcnt+=m_LoaderShip.contentLoaderInfo.bytesLoaded;
			totalcnt += m_LoaderShip.contentLoaderInfo.bytesTotal;
		}

		if(m_LoaderCommon!=null) {
			loadcnt+=m_LoaderCommon.contentLoaderInfo.bytesLoaded;
			totalcnt += m_LoaderCommon.contentLoaderInfo.bytesTotal;
		}

//			loadcnt+=m_LoaderDialog.contentLoaderInfo.bytesLoaded;
//			totalcnt+=m_LoaderDialog.contentLoaderInfo.bytesTotal;

/*			if(m_LoaderDialog!=null) {
			loadcnt += m_LoaderDialog.bytesLoaded;
			totalcnt += m_LoaderDialog.bytesTotal;
		}*/
		
		var i:int;
		for (i = 0; i < LoadManager.Self.m_LoadArray.length; i++) {
			var obj:Object = LoadManager.Self.m_LoadArray[i];
			if (obj.Loader == undefined) continue;
			if (obj.Loader is Loader) {
				loadcnt += (obj.Loader as Loader).contentLoaderInfo.bytesLoaded;
				totalcnt += (obj.Loader as Loader).contentLoaderInfo.bytesTotal;
			} else if (obj.Loader is URLLoader) {
				loadcnt += (obj.Loader as URLLoader).bytesLoaded;
				totalcnt += (obj.Loader as URLLoader).bytesTotal;
			}
		}

		m_FormHint.Show(Common.Hint.Load + " " + (Math.floor(100 * loadcnt / totalcnt)) + '% (' + BaseStr.FormatBigInt(loadcnt >> 10) + ' kb)\nWait: ' + m_WaitStr);

		//trace("Load: "+Math.floor(100*loadcnt/totalcnt));
	}
	
	private var m_PCE:Boolean = false;
	private var m_WaitStr:String = "";
	
//	private var m_LoaderBackgroundComplate:Boolean=false;
	private var m_LoaderPlanetComplate:Boolean=false;
	private var m_LoaderShipComplate:Boolean=false;
	private var m_LoaderCommonComplate:Boolean=false;
//	private var m_LoaderDialogComplate:Boolean=false;

	public function PreloaderComplate(evt:Event):void
	{
		if (m_PCE) return;
		
		var str:String;

		if (!m_LoadGraphBeginComplate) {
			str = LoadManager.Self.Get("ver.txt") as String;	
			if (str != null && str.length > 0) {
				LoadManager.Self.ParseVer(str);
				m_LoadGraphBeginComplate = true;
				
				LoadGraph();
			}
		}
//			if(m_LoaderBackground.contentLoaderInfo.bytesLoaded<=0 || m_LoaderBackground.contentLoaderInfo.bytesLoaded<m_LoaderBackground.contentLoaderInfo.bytesTotal) return;
//			if(m_LoaderPlanet.contentLoaderInfo.bytesLoaded<=0 || m_LoaderPlanet.contentLoaderInfo.bytesLoaded<m_LoaderPlanet.contentLoaderInfo.bytesTotal) return;
//			if(m_LoaderShip.contentLoaderInfo.bytesLoaded<=0 || m_LoaderShip.contentLoaderInfo.bytesLoaded<m_LoaderShip.contentLoaderInfo.bytesTotal) return;
//			if(m_LoaderCommon.contentLoaderInfo.bytesLoaded<=0 || m_LoaderCommon.contentLoaderInfo.bytesLoaded<m_LoaderCommon.contentLoaderInfo.bytesTotal) return;
//			if(m_LoaderDialog.bytesLoaded<=0 || m_LoaderDialog.bytesLoaded<m_LoaderDialog.bytesTotal) return;

//trace(evt.target);
//			if(evt.target==m_LoaderBackground.contentLoaderInfo) m_LoaderBackgroundComplate=true;
//			else
		m_WaitStr = "";
		if (evt.target == m_LoaderPlanet.contentLoaderInfo) m_LoaderPlanetComplate = true;
		else if(evt.target==m_LoaderShip.contentLoaderInfo) m_LoaderShipComplate=true;
		else if(evt.target==m_LoaderCommon.contentLoaderInfo) m_LoaderCommonComplate=true;
		//else if(evt.target==m_LoaderDialog) m_LoaderDialogComplate=true;

//FormChat.Self.AddDebugMsg(m_LoaderBackgroundComplate.toString()+" "+m_LoaderPlanetComplate.toString()+" "+m_LoaderShipComplate.toString()+" "+m_LoaderCommonComplate.toString()+" "+m_LoaderDialogComplate.toString());

		if (!m_LoaderPlanetComplate) { m_WaitStr = "planet"; return; }
		if (!m_LoaderShipComplate) { m_WaitStr = "ship"; return; }
		if (!m_LoaderCommonComplate) { m_WaitStr = "common"; return; }
//			if (!m_LoaderDialogComplate) { m_WaitStr = "dialog"; return; }
		
		var i:int;
		for (i = 0; i < LoadManager.Self.m_LoadArray.length; i++) {
			var obj:Object = LoadManager.Self.m_LoadArray[i];
			if (!obj.Complete) { m_WaitStr = obj.Path; return; }
		}

		str = LoadManager.Self.Get("set.txt") as String;
		if (str == null) { m_WaitStr = "set"; return; }

		if (!SpacePath.Init(SpaceShip.gstShip1, ["ship1/path.mesh"])) { m_WaitStr = "SpacePath ship1"; return; }

		m_PCE = true;
		
		Set.Load(str);
		
		C3D.Init(stage);

//			LoadManager.Self.Get("empire/bg04.jpg");

		Common.ItemImgInit();
		Common.BuildingItemInit();

/*FormChat.Self.AddDebugMsg("Load complate. "+m_LoaderBackground.contentLoaderInfo.bytesLoaded.toString()+
" "+m_LoaderPlanet.contentLoaderInfo.bytesLoaded.toString()+
" "+m_LoaderShip.contentLoaderInfo.bytesLoaded.toString()+
" "+m_LoaderCommon.contentLoaderInfo.bytesLoaded.toString()+
" "+m_LoaderDialog.bytesLoaded.toString()
);*/

		m_LoadComplate=true;
		m_FormHint.Hide();
		AfterLoadGraph();
	}

	public override function onStageResize(e:Event):void 
	{
		super.onStageResize(e);

		m_FormChat.StageResize();
		m_FormInfoBar.StageResize();
		m_FormFleetBar.StageResize();
		m_FormFleetItem.StageResize();
		m_FormCptBar.StageResize();
		m_FormMiniMap.StageResize();
		m_FormRadar.StageResize();
		m_FormQuestBar.StageResize();
		m_FormBattleBar.StageResize();
		m_FormCombat.StageResize();
		m_FormConstruction.StageResize();
		m_FormInput.StageResize();
		m_FormNews.StageResize();
		m_FormPact.StageResize();
		m_FormPactList.StageResize();
		m_FormPlanet.StageResize();
		m_FormQuestManager.StageResize();
		m_FormSplit.StageResize();
		m_FormTech.StageResize();
		m_FormTime.StageResize();
		m_FormUnion.StageResize();
		m_FormUnionNew.StageResize();

		m_Info.Hide();

		HS.StageResize();
		HS.m_BG.NeedUpdate();
		m_Hangar.StageResize();
		Update();
		m_FormMenu.Clear();
		//if (HS.visible) HS.Show(); 
		//if (m_Hangar.visible) m_Hangar.Show(); 
	}

	public override function onStageMouseLeave(e:Event):void
	{
		m_ScrollOn=false;
	}

	public function onDblClick(e:MouseEvent):void
	{
		m_FormMenu.Clear();
	}
	
	public override function onRightMouseDownHandler(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		m_FormMenu.Clear();
		
		if (!IsSpaceLock()) {
			CancelAll();

			m_MoveMap = false;
			MouseUnlock();

			CalcPick(mouseX, mouseY);
		}
	}

	public override function onMouseDownHandler(e:MouseEvent):void
	{
		super.onMouseDownHandler(e);
//trace(e.currentTarget.toString() + " dispatches MouseEvent. Local coords [" + e.localX + "," + e.localY + "] Stage coords [" + e.stageX + "," + e.stageY + "]");

		if (m_Hangar.visible) { m_Hangar.onMouseDown(e); return; }
		else if (HS.visible) { HS.onMouseDown(e); return; }
		
		e.stopImmediatePropagation();
		m_ContentMenuShow = false;
		
//trace("EmpireMap.MouseDown");
		
		onMouseMoveHandler(e);

		while(!IsSpaceLock()) {
			var sec:Sector;
			var planet:Planet;
			var ship:Ship;
			
			if (m_Action == ActionPathMove && m_FormMiniMap.IsMouseIn()) {
				m_FormMiniMap.onMouseDown(e);
				return;
			} else if (m_Action == ActionPathMove && m_FormCptBar.IsMouseIn()) {
				m_FormCptBar.onMouseDown(e);
				return;
			}
			
			if(m_FormDialog.IsMouseIn()) {
				break;
			} 
			if(m_FormHist.IsMouseIn()) {
				break;
			} 
			if(m_FormBuild.IsMouseIn()) {
				break;
			} 
			if(m_FormInfoBar.IsMouseIn()) {
				break;
			}
			stage.focus=this;

			while(m_Info.visible && m_Info.m_ShipNum>=0) {
				var gship:GraphShip=GetGraphShip(m_Info.m_SectorX,m_Info.m_SectorY,m_Info.m_PlanetNum,m_Info.m_ShipNum);
				if(gship==null) break;

				ship=GetShip(m_Info.m_SectorX,m_Info.m_SectorY,m_Info.m_PlanetNum,m_Info.m_ShipNum);
				if(ship==null) break;

				if (ship.m_Flag & (/*@Common.ShipFlagAutoLogic | Common.ShipFlagAutoReturn |*/ Common.ShipFlagCapture | Common.ShipFlagAIRoute)) { }
				else if (ship.m_Link != 0) { }
				else if (ship.m_Path != 0) { }
				else break;

				//if(ship.m_ArrivalTime<GetServerTime()) break;

				if(!IsEdit()) {
					var ac:Action=new Action(this);
					ac.ActionCancelAutoMove(ship.m_Id,m_Info.m_SectorX,m_Info.m_SectorY);
					m_LogicAction.push(ac);
				}

				break;
			}

			if(m_CurPlanetNum<0) {
				MouseLock();
				m_MoveMap = true;
				m_MoveMapBegin = false;
				m_OldPosX = e.stageX;
				m_OldPosY = e.stageY;
event_mousemove_cnt = 0;
event_touchmove_cnt = 0;

			} else if(m_CurSpecial==1) {
				MouseLock();

			} else if(m_CurPlanetNum>=0 && m_CurShipNum>=0 && m_Action==ActionNone) {
				while(true) {
					sec=GetSector(m_CurSectorX,m_CurSectorY);
					if(sec==null) break;
					planet=sec.m_Planet[m_CurPlanetNum];
					ship=planet.m_Ship[m_CurShipNum];
					//if(ship.m_Owner!=Server.Self.m_UserId) break;
					if(!IsEdit()) {
						if(ship.m_Type==Common.ShipTypeNone) break;
						if (m_CurShipNum < planet.ShipOnPlanetLow && !AccessControl(ship.m_Owner)) break;
					}

					if(!IsEdit() && (e.ctrlKey || e.altKey || e.shiftKey) && (ship.m_Flag & Common.ShipFlagPhantom)==0) m_Action=ActionSplit;
					else {
						//if(ship.m_Flag & Common.ShipFlagBuild) break;
						m_Action=ActionMove;
						m_ShipPlaceCooldown=Common.GetTime();
					}

					MouseLock();

					m_MoveSectorX=m_CurSectorX;
					m_MoveSectorY=m_CurSectorY;
					m_MovePlanetNum=m_CurPlanetNum;
					m_MoveShipNum=m_CurShipNum;
					m_MoveOwner=ship.m_Owner;
					m_MoveListNum.length=0;
					m_MovePath.length=0;

					CalcPick(mouseX,mouseY);
					InfoUpdate(mouseX,mouseY);

					break;
				}
			} else if(m_CurPlanetNum>=0 && m_CurShipNum<0 && m_Action==ActionNone) {
				while(true) {
					sec=GetSector(m_CurSectorX,m_CurSectorY);
					if(sec==null) break;
					planet=sec.m_Planet[m_CurPlanetNum];

					m_MoveSectorX=m_CurSectorX;
					m_MoveSectorY=m_CurSectorY;
					m_MovePlanetNum=m_CurPlanetNum;
					m_MoveShipNum=-1;
					m_MoveListNum.length=0;
					m_MovePath.length=0;

					//if(planet.m_Owner==Server.Self.m_UserId) {
					if (IsEdit() && (e.shiftKey)) {
						MouseLock();
						m_Action=ActionPlanetMove;
					} else if ((e.ctrlKey || e.altKey || e.shiftKey) && RouteAccess(planet, Server.Self.m_UserId) && planet.m_Vis) {
						MouseLock();
						m_Action=ActionRoute;
						
					} else if (/*AccessBuild(planet.m_Owner)*/(RouteAccess(planet, Server.Self.m_UserId) && planet.m_Vis) || (IsEdit() && !(e.ctrlKey || e.altKey || e.shiftKey))) {
						MouseLock();

						m_Action=ActionPlanet;
						m_ShipPlaceCooldown=Common.GetTime();

					} else {
						if(e.ctrlKey || e.altKey || e.shiftKey) {
							var user:User=UserList.Self.GetUser(planet.m_Owner);
							if(user!=null && planet.m_Vis) {
								if(FormChat.Self.Msg.text.length>0) FormChat.Self.MsgAddText("["+EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id)+"]");
								else FormChat.Self.SetToUserId(user.m_Id);
							}
							break;
						}

						MouseLock();
						m_Action=ActionShowRadius;
					}
					CalcPick(mouseX,mouseY);
					InfoUpdate(mouseX,mouseY);

					break;
				}
			} else if(m_Action==ActionPortal) {
				while(true) {
					if (m_CurPlanetNum < 0) break;

					if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum) {
						MouseUnlock();
						m_MoveMap=false;
						m_Action=ActionNone;
						CalcPick(mouseX,mouseY);
						break;
					}

					SendAction("emportal",""+m_MoveSectorX+"_"+m_MoveSectorY+"_"+m_MovePlanetNum+"_"+m_MoveShipNum+"_"+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum);

					MouseUnlock();
					m_Action=ActionNone;
					CalcPick(mouseX,mouseY);
					break;
				}
				return;
				
			} else if (m_Action == ActionLink || m_Action == ActionEject) {
				while(true) {
					if (m_CurPlanetNum < 0) break;

					if (IsEdit()) {
						ac=new Action(this);
						ac.ActionCopy(0, m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, m_MoveShipNum, m_CurSectorX, m_CurSectorY, m_CurPlanetNum, (m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum)?m_CurShipNum:-1, 0);
						m_LogicAction.push(ac);
					} else {
						ac=new Action(this);
						ac.ActionMove(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, m_MoveShipNum, m_CurSectorX, m_CurSectorY, m_CurPlanetNum, (m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum)?m_CurShipNum:-1);
						m_LogicAction.push(ac);
						
						ac = new Action(this);
						ac.ActionSpecial(36, m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, m_MoveShipNum);
						m_LogicAction.push(ac);
					}

					MouseUnlock();
					m_Action=ActionNone;
					CalcPick(mouseX,mouseY);
					break;
				}
				return;
				
			} else if(m_Action==ActionWormhole) {
				while(true) {
					if (m_CurPlanetNum < 0) break;

					if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum) {
						MouseUnlock();
						m_MoveMap=false;
						m_Action=ActionNone;
						CalcPick(mouseX,mouseY);
						break;
					}

					ProcessActionWormhole();

					MouseUnlock();
					m_Action=ActionNone;
					CalcPick(mouseX,mouseY);
					break;
				}
				return;

			} else if(m_Action==ActionAntiGravitor) {
				if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum && m_MoveShipNum==m_CurShipNum) {
					m_MoveMap = false;
					MouseUnlock();
					m_Action=ActionNone;
					MenuShip();
					return;
				} else {
					ActionAntiGravitorProcess();
				}
				MouseUnlock();
				m_Action=ActionNone;
				CalcPick(mouseX,mouseY);
				return;
				
			} else if(m_Action==ActionGravWell) {
				if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum && m_MoveShipNum==m_CurShipNum) {
					m_MoveMap = false;
					MouseUnlock();
					m_Action=ActionNone;
					MenuShip();
					return;
				} else {
					ActionGravWellProcess();
				}
				MouseUnlock();
				m_Action=ActionNone;
				CalcPick(mouseX,mouseY);
				return;

			} else if(m_Action==ActionBlackHole) {
				if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum && m_MoveShipNum==m_CurShipNum) {
					m_MoveMap = false;
					MouseUnlock();
					m_Action=ActionNone;
					MenuShip();
					return;
				} else {
					ActionBlackHoleProcess();
				}
				MouseUnlock();
				m_Action=ActionNone;
				CalcPick(mouseX,mouseY);
				return;

			} else if(m_Action==ActionTransition) {
				if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum && m_MoveShipNum==m_CurShipNum) {
					m_MoveMap = false;
					MouseUnlock();
					m_Action=ActionNone;
					MenuShip();
					return;
				} else {
					ActionTransitionProcess();
				}
				MouseUnlock();
				m_Action=ActionNone;
				CalcPick(mouseX,mouseY);
				return;

			} else if(m_Action==ActionExchange) {
				if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum && m_MoveShipNum==m_CurShipNum) {
					m_MoveMap = false;
					MouseUnlock();
					m_Action=ActionNone;
					MenuShip();
					return;
				} else {
					ActionExchangeProcess();
				}
				MouseUnlock();
				m_Action=ActionNone;
				CalcPick(mouseX,mouseY);
				return;

			} else if(m_Action==ActionConstructor) {
//					if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum && m_MoveShipNum==m_CurShipNum) {
//						m_MoveMap=false;
//						m_Action=ActionNone;
//						m_GraphMovePath.Update();
//						MenuShip();
//						return;
//					} else {
				if (m_ActionShipNum < 0) {
					m_ActionShipNum = m_CurShipNum;
					return;
				} else {
					SendAction("emconstructor", "" + m_MoveSectorX.toString() + "_" + m_MoveSectorY.toString() + "_" + m_MovePlanetNum.toString() + "_" + m_MoveShipNum.toString() + "_" + m_CurShipNum.toString() + "_" + m_ActionShipNum.toString());

					MouseUnlock();
					m_Action=ActionNone;
					CalcPick(mouseX,mouseY);
				}
				return;
				
			} else if(m_Action==ActionRecharge) {
				SendAction("emrecharge",""+m_MoveSectorX.toString()+"_"+m_MoveSectorY.toString()+"_"+m_MovePlanetNum.toString()+"_"+m_MoveShipNum.toString()+"_"+m_CurShipNum.toString());
				
				MouseUnlock();
				m_Action=ActionNone;
				CalcPick(mouseX,mouseY);
				return;
			}
			break;
		}
	}

	public override function onMouseUpHandler(e:MouseEvent):void
	{
		var ac:Action;

		if (m_Hangar.visible) { m_Hangar.onMouseUp(e); return; }
		else if (HS.visible) { HS.onMouseUp(e); return; }

		e.stopImmediatePropagation();

		m_ContentMenuShow=false;

//			var ctrlcnt:int = 0;
//			if (e.altKey) ctrlcnt++;
//			if (e.shiftKey) ctrlcnt++;
//			if (e.ctrlKey) ctrlcnt++;
		
		if(!IsSpaceLock()) {
			var i:int;
			var sec:Sector;
			var planet:Planet;
			var ship:Ship;
			var user:User;

			if(m_Action==ActionMove && m_FormFleetBar.IsMouseIn()) {
				//if(m_FormFleetBar.m_SlotMouse>=0) {
					ac=new Action(this);
					ac.ActionToHyperspace(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveShipNum,m_FormFleetBar.m_SlotMouse);
					m_LogicAction.push(ac);
				//}
			
			} else if (m_CurSpecial == 1) {
				MouseUnlock();
				MenuPortal();

			} else if(m_MoveMap) {
				m_MoveMap = false;
				if (m_Action == ActionNone || m_Action == ActionPortal || m_Action == ActionLink || m_Action == ActionEject || m_Action == ActionWormhole || m_Action == ActionExchange || m_Action == ActionConstructor || m_Action == ActionRecharge || m_Action == ActionAntiGravitor || m_Action == ActionGravWell || m_Action == ActionBlackHole || m_Action == ActionTransition) MouseUnlock();
				CalcPick(mouseX,mouseY);

				if(!m_MoveMapBegin && (CotlDevAccess(Server.Self.m_CotlId) || m_EmpireEdit) && m_Action==ActionNone) MenuEditGlobal();
			
				return;

			} else if (m_Action == ActionPathMove && m_FormMiniMap.IsMouseIn()) {
				m_FormMiniMap.onMouseUp(e);
				return;

			} else if(m_Action==ActionMove) {
				if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum && m_MoveShipNum==m_CurShipNum) {
					m_MoveMap = false;
					MouseUnlock();
					m_Action=ActionNone;
					MenuShip();
					return;
				} else {
					if(IsEdit()) {
						while(true) {
							if(m_CurPlanetNum<0) break;
							if(m_MovePlanetNum<0) break;
							if(m_MoveShipNum<0) break;

							ship=GetShip(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveShipNum);

							var newid:uint=0;
							var kind:int=0;

							if(ship.m_Type!=Common.ShipTypeNone) {
								if(e.ctrlKey || e.altKey || e.shiftKey) {
									newid=NewShipId(Server.Self.m_UserId);
									if(newid==0) break;
								}
							} else {
								if(e.ctrlKey || e.altKey || e.shiftKey) kind=1;
								else kind=2;
							}
							if (IsEdit() && m_CurShipNum<0) break;
							ac=new Action(this);
							ac.ActionCopy(newid,m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveShipNum,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum,kind);
							m_LogicAction.push(ac);
							break;
						}
					} else {
						ActionMoveProcess();
					}
				}

			} else if(m_Action==ActionSplit) {
				if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum) {
					if(m_MoveShipNum!=m_CurShipNum && m_CurShipNum>=0) {
						m_FormSplit.Run(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveShipNum,m_CurShipNum);

					} else if(m_MoveShipNum==m_CurShipNum) {
						while(true) {
							sec=GetSector(m_CurSectorX,m_CurSectorY);
							if(sec==null) break;
							planet=sec.m_Planet[m_CurPlanetNum];
							ship=planet.m_Ship[m_CurShipNum];
							if(ship.m_Type==Common.ShipTypeNone || Common.IsBase(ship.m_Type)) break;
							//if(ship.m_Owner!=Server.Self.m_UserId) break;
							if(!AccessControl(ship.m_Owner)) break;

							m_MoveSectorX=m_CurSectorX;
							m_MoveSectorY=m_CurSectorY;
							m_MovePlanetNum=m_CurPlanetNum;
							m_MoveShipNum=m_CurShipNum;
							m_MoveOwner=ship.m_Owner;
							m_MoveListNum.length=0;
							m_MovePath.length = 0;

							MouseLock();
							
							m_Action=ActionPathMove;
							CalcPick(mouseX,mouseY);
							InfoUpdate(mouseX, mouseY);
							
							m_MenuShipLastId = ship.m_Id
							m_MenuShipLastTime = Common.GetTime();
	
							return;
						}
					}						
				}

			} else if((m_Action==ActionShowRadius || m_Action==ActionPlanetMove) && m_CurPlanetNum>=0) {
				if (m_MoveSectorX == m_CurSectorX && m_MoveSectorY == m_CurSectorY && m_MovePlanetNum == m_CurPlanetNum) {
					MouseUnlock();
					m_MoveMap=false;
					m_Action=ActionNone;
					MenuPlanet();
				} else {
					MouseUnlock();
					var srcpl:Planet = GetPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);
					var despl:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);

					//EditMapChangePlanetSet(despl, m_CurSectorX, m_CurSectorY, m_CurPlanetNum, srcpl.m_Flag, srcpl.m_Owner, srcpl.m_Level, srcpl.m_Race, srcpl.m_Machinery, srcpl.m_Engineer, srcpl.m_OreItem, srcpl.m_Refuel, srcpl.m_Team, srcpl.m_AutoBuildType, srcpl.m_AutoBuildCnt, srcpl.m_AutoBuildTime, srcpl.m_AutoBuildWait);
					if (srcpl != null && despl != null) EditMapCopyPlanet(despl, srcpl);

					m_MoveMap=false;
					m_Action=ActionNone;
				}
				return;

			} else if(m_Action==ActionRoute && m_CurPlanetNum>=0 && (m_CurShipNum<0)) {
				if((m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum)) {
					planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
					if((planet!=null) && (planet.m_Owner!=0) && (planet.m_Owner&Common.OwnerAI)==0) {
						user=UserList.Self.GetUser(planet.m_Owner);
						if(user!=null && planet.m_Vis) {
							if(FormChat.Self.Msg.text.length>0) FormChat.Self.MsgAddText("["+EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id)+"]");
							else FormChat.Self.SetToUserId(user.m_Id);
						}
					}
				} else {
					ActionPathProcess(true);
				}

			} else if (m_Action == ActionPlanetMove) {
				if (e.shiftKey && e.ctrlKey) {
					PickWorldCoord(mouseX, mouseY, m_TPickPos);
					Server.Self.Query("emedcotlspecial",
						"&type=7&val=" +
						Math.round(m_TPickPos.x).toString() + "_" +
						Math.round(m_TPickPos.y).toString() + "_" +
						"0_" +
						m_MoveSectorX.toString() + "_" +
						m_MoveSectorY.toString() + "_" +
						m_MovePlanetNum.toString(),
						EditMapChangeSizeRecv,false);
					
				} else {
					PickWorldCoord(mouseX, mouseY, m_TPickPos);
//trace("PlanetMoveTo:", Math.round(m_TPickPos.x).toString(), Math.round(m_TPickPos.y).toString());
					Server.Self.Query("emedcotlspecial", "&type=6&val=" + m_MoveSectorX.toString() + "_" + m_MoveSectorY.toString() + "_" + m_MovePlanetNum.toString() + "_" + Math.round(m_TPickPos.x).toString() + "_" + Math.round(m_TPickPos.y).toString(), EditMapChangeSizeRecv, false);
				}
				MouseUnlock();
				m_MoveMap=false;
				m_Action = ActionNone;
				return;

			} else if(m_Action==ActionPlanet && m_CurPlanetNum>=0 && (m_CurShipNum<0) && !(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum)) {
				ActionPathProcess(false/*e.ctrlKey || e.altKey || e.shiftKey*/);

			} else if(m_Action==ActionPlanet && m_CurPlanetNum>=0 && m_CurShipNum<0) {
				if(e.ctrlKey || e.altKey || e.shiftKey) {
					planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
					if(planet!=null) {
						user=UserList.Self.GetUser(planet.m_Owner);
						if(user!=null && planet.m_Vis) {
							if(FormChat.Self.Msg.text.length>0) FormChat.Self.MsgAddText("["+EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id)+"]");
							else FormChat.Self.SetToUserId(user.m_Id);
						}
					}
				} else {
					MouseUnlock();
					m_MoveMap=false;
					m_Action=ActionNone;
					MenuPlanet();
					return;
				}

			} else if (m_Action == ActionPathMove) {
				while(true) {
					if(m_CurPlanetNum<0) break;

					if(m_CurShipNum>=0) {
						if(m_MoveSectorX!=m_CurSectorX || m_MoveSectorY!=m_CurSectorY || m_MovePlanetNum!=m_CurPlanetNum) break;

						ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
						if ((Common.GetTime() - m_MenuShipLastTime) < StdMap.DblClickTime && ship != null && m_MenuShipLastId == ship.m_Id) {
							planet = GetPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);
							ship = GetShip(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, m_MoveShipNum);
							if (planet != null && ship != null && m_MoveShipNum < planet.ShipOnPlanetLow && !Common.IsBase(ship.m_Type)) {
								var ship2:Ship;
								for (i = 0; i < planet.ShipOnPlanetLow; i++) {
									if (i == m_MoveShipNum) continue;
									ship2 = planet.m_Ship[i];
									if (ship2.m_Type == Common.ShipTypeNone) continue;
									if (ship2.m_ArrivalTime > GetServerCalcTime()) continue;
									if (Common.IsBase(ship2.m_Type)) continue;
									if (!AccessControl(ship2.m_Owner)) continue;
									m_MoveListNum.push(i);
									if ((1 + m_MoveListNum.length) >= Common.GroupInPlanetMax) break;
								}
							}
							
						} else if(m_MoveShipNum==m_CurShipNum) {
							if (m_MoveListNum.length <= 0) {
								MouseUnlock();
								m_Action=ActionNone;
								CalcPick(mouseX,mouseY);
							} else {
								m_MoveShipNum=m_MoveListNum[0];
								m_MoveListNum.splice(0,1);
							}
						} else {
							i=m_MoveListNum.indexOf(m_CurShipNum);
							if(i>=0) m_MoveListNum.splice(i,1);
							else {
								ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
								if(ship!=null && ship.m_Type!=Common.ShipTypeNone && ship.m_Owner==m_MoveOwner) m_MoveListNum.push(m_CurShipNum);
							}
						}

						break;
					}

					if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum) {
						m_MovePath.length=0;
						break;
					}

					var fromplanet:Planet=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
					if(fromplanet==null) break;

					if(m_MovePath.length>0) fromplanet=m_MovePath[m_MovePath.length-1];

					var toplanet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
					if(toplanet==null) break;
					
					if (m_MovePath.length > 0 && m_MovePath[m_MovePath.length - 1] == toplanet) {
						MouseUnlock();
						ActionPathMoveProcess();
						m_Action=ActionNone;
						CalcPick(mouseX,mouseY);
						break;
					}

					for(i=0;i<m_MovePath.length;i++) {
						if(m_MovePath[i]==toplanet) break;
					}

					if(i<m_MovePath.length) {
						m_MovePath.splice(i+1,m_MovePath.length-(i+1));
					} else {
						var ra:Array = FindPath(fromplanet, toplanet, m_MoveOwner);
						
						if(ra.length<=0 && m_Set_Hint) m_FormHint.Show(Common.Txt.WarningPathNotFound,Common.WarningHideTime);

						if(m_MovePath.length<=0) {
							for(i=0;i<ra.length;i++) m_MovePath.push(ra[i]);
						} else {
							for(i=1;i<ra.length;i++) m_MovePath.push(ra[i]);
						}
					}
					
					//if(m_Set_Hint && (e.ctrlKey || e.shiftKey || e.altKey)) m_FormHint.Show(Common.Txt.WarningPathNoCtrl,Common.WarningHideTime);

					break;
				}
				return;
			}

			MouseUnlock();
			m_MoveMap=false;
			m_Action=ActionNone;
			CalcPick(mouseX,mouseY);
		}
	}

	public var event_mousemove_cnt:int = 0;
	public var event_touchmove_cnt:int = 0;

	public override function onTouchMoveHandler(e:TouchEvent):void
	{
		if(m_MoveMap) event_touchmove_cnt++;
	}

	public override function onMouseMoveHandler(e:MouseEvent):void
	{
		if (m_MoveMap) event_mousemove_cnt++;
		
		if (m_Hangar.visible) { m_Hangar.onMouseMove(e); return; }
		else if (HS.visible) { HS.onMouseMove(e); return; }

		if (FormChat.Self.IsScroll()) return;
		if (m_FormItemManager.IsScroll()) return;
		
		e.stopImmediatePropagation();
		m_ScrollOn=true;
		if(!IsSpaceLock() && !m_ContentMenuShow /*&& !m_FormMenu.visible*/) { // исправленно: m_FormMenu.visible - почемуто без этого коректно не работает на некоторых компьютеров. а должно!

			if(m_MoveMap) {
				m_MoveMapBegin=true;
				SetCenter(OffsetX-(e.stageX-m_OldPosX),OffsetY-(e.stageY-m_OldPosY));
				m_OldPosX=e.stageX;
				m_OldPosY=e.stageY;
				m_GoOpen=false;
				//m_FormMiniMap.ScrollToView();
				m_FormMiniMap.NeedScrollToViewAndUpdate();
				
			} else if (m_Action == ActionPathMove && m_FormMiniMap.IsMouseIn()) {
				m_FormMiniMap.onMouseMove(e);
				return;

			} else if(m_Action==ActionMove && m_FormFleetBar.IsMouseIn()) {
				m_CurPlanetNum = -1;
				m_CurShipNum = -1;
				var ra:Array = CalcPickEx(x, y, false);
				m_CurSectorX = ra[0];
				m_CurSectorY = ra[1];
				m_GraphSelect.SetRadius(0);
				if (m_FormMiniMap.m_ShowWormholePath != false || m_FormMiniMap.m_ShowPortalPath != false) m_FormMiniMap.Update();
				m_FormFleetBar.onMouseMove(e);
				return;

			} else if (m_Action == ActionMove || m_Action == ActionPathMove || m_Action == ActionSplit || m_Action == ActionExchange || m_Action == ActionConstructor || m_Action == ActionRecharge || m_Action == ActionPortal || m_Action == ActionLink || m_Action == ActionEject || m_Action == ActionWormhole || m_Action == ActionAntiGravitor || m_Action == ActionGravWell || m_Action == ActionBlackHole || m_Action == ActionTransition) {

			} else if(m_FormInfoBar.IsMouseIn()) {
				return;
			} else if(m_FormDialog.IsMouseIn()) {
				m_Info.Hide();
				return;
			} else if(m_FormHist.IsMouseIn()) {
				m_Info.Hide();
				return;
			}
			m_FormMiniMap.SetCurOwner(0);
			CalcPick(e.stageX,e.stageY);

			InfoUpdate(e.stageX,e.stageY);
		}
	}

	public override function onMouseWheelHandler(e:MouseEvent):void
	{
		if (IsFocusInputAndMouse()) return;

		if (m_Hangar.visible) { m_Hangar.onMouseWheelHandler(e); return; }
		else if (HS.visible) { HS.onMouseWheelHandler(e); return; }

		e.stopImmediatePropagation();

		var d:int = e.delta;

		if (d < 0) {
			m_CamDistDir = 1;
			m_CamDistChangeTime = 0;
			CamDistChange();
			m_CamDistDir = 0;
		} else if (d > 0) {
			m_CamDistDir = -1;
			m_CamDistChangeTime = 0;
			CamDistChange();
			m_CamDistDir = 0;
		}
	}

	public function CancelAll():Boolean
	{
		var ret:Boolean = false;
		
		if (m_FormMenu.visible) {
			m_FormMenu.Clear();
			return false;
		}
		if(HS.visible) {
			HS.CancelAction();
			return false;
		}
		if(m_FormFleetBar.m_SlotMove>=0 && m_FormFleetBar.m_SlotMoveBegin) {
			m_FormFleetBar.SlotMoveBegin(-1);
			ret=true;
		}
		if(m_Action!=ActionNone) {
			MouseUnlock();
			m_Action=ActionNone;
			ret=true;
		}
		
		return ret;
	}

	public override function onKeyDownHandler(e:KeyboardEvent):void
	{
		var ac:Action;
		var ship:Ship;

		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;

//FormChat.Self.AddDebugMsg("key down " + e.keyCode);
		if(e.keyCode==27) {
			//e.stopImmediatePropagation();
		
			//if(m_FormGalaxy.visible) {
			//	m_FormGalaxy.CancelAction();
			//	return;
			//} else
/*				if(HS.visible) {
				HS.CancelAction();
				return;
			}
			if(m_FormFleetBar.m_SlotMove>=0 && m_FormFleetBar.m_SlotMoveBegin) {
				m_FormFleetBar.SlotMoveBegin(-1);
			}
			m_Action=ActionNone;
			m_GraphMovePath.Update();*/

			CancelAll();

			MouseUnlock();
			m_MoveMap=false;
			CalcPick(mouseX, mouseY);
			
		} else if (e.keyCode == 13 && !addkey && !IsSpaceLock() && m_FormChat.visible && !IsFocusInput()) {
			m_FormChat.BeginEditMsg();

		} else if((e.keyCode==17 || e.keyCode==16) && m_FormTech.visible) { // ctrl shift
			m_FormTech.onMouseMoveHandler(new MouseEvent(MouseEvent.MOUSE_MOVE,true,false,0,0,null,true));

		} else if((e.keyCode==17 || e.keyCode==16) && m_FormTalent.visible) { // ctrl shift
			m_FormTalent.onMouseMoveHandler(new MouseEvent(MouseEvent.MOUSE_MOVE,true,false,0,0,null,true));

		} else if(e.keyCode==90) {
//				m_TmpVal=m_TmpVal-1;
//				FormChat.Self.AddDebugMsg("VmpVal="+m_TmpVal.toString());
		} else if(e.keyCode==88) {
//				m_TmpVal=m_TmpVal+1;
//				FormChat.Self.AddDebugMsg("VmpVal="+m_TmpVal.toString());

		} else if (e.ctrlKey && e.keyCode>=49 && e.keyCode<(49+10)) {
			C3D.m_ShowState = e.keyCode-49
			return;
		}
		
		if (m_Hangar.visible) { m_Hangar.onKeyDownHandler(e); return; }
		else if (HS.visible) { HS.onKeyDownHandler(e); return; }

		while(true) {
//trace(stage.focus);
			if(IsSpaceLock()) break;

			if(stage.focus==null) {}
			else if((stage.focus is TextField) && ((stage.focus as TextField).type==TextFieldType.INPUT)) break;
			
			//if(m_FormMenu.visible && e.keyCode!=17 && e.keyCode!=16) m_FormMenu.Clear(); 
		
			if (e.keyCode == 36) { // Home
				m_CamDistTo = CamDistDefault;

			} else if (e.keyCode == 35) { // End
				m_CamDistTo = CamDistMax;

			} else if (e.keyCode == 48 && e.shiftKey) { // Shift+0
				m_SysModify = 0;

			} else if (e.keyCode == 49 && e.shiftKey) { // Shift+1
				m_SysModify = 1;

			} else if (e.keyCode == 50 && e.shiftKey) { // Shift+2
				m_SysModify = 2;

			} else if (e.keyCode == 51 && e.shiftKey) { // shift+3
				m_SysModify = 3;

			} else if (m_SysModify != 0 && ((e.keyCode == 38 || e.keyCode == 87))) {
				if (m_SysModify == 1) m_CamAngle += 1.0 * Space.ToRad;
				else if (m_SysModify == 3) m_LightPlanetAngle += 1.0 * Space.ToRad;

			} else if(m_SysModify != 0 && ((e.keyCode==40 || e.keyCode==83))) {
				if (m_SysModify == 1) m_CamAngle -= 1.0 * Space.ToRad;
				else if (m_SysModify == 3) m_LightPlanetAngle -= 1.0 * Space.ToRad;

			} else if(m_SysModify != 0 && ((e.keyCode==37 || e.keyCode==65))) {
				if (m_SysModify == 1) m_CamRotate += 1.0 * Space.ToRad;
				else if (m_SysModify == 3) m_LightPlanetRotate += 1.0 * Space.ToRad;

			} else if(m_SysModify != 0 && ((e.keyCode==39 || e.keyCode==68))) {
				if (m_SysModify == 1) m_CamRotate -= 1.0 * Space.ToRad;
				else if (m_SysModify == 3) m_LightPlanetRotate -= 1.0 * Space.ToRad;

			} else if (e.keyCode == 33) { // PageUp
				if (m_CamDistDir != -1) {
					m_CamDistDir = -1;
					m_CamDistChangeTime = 0;
					CamDistChange();
				}

			} else if (e.keyCode == 34) { // PageDown
				if (m_CamDistDir != 1) {
					m_CamDistDir = 1;
					m_CamDistChangeTime=0;
					CamDistChange();
				}
			} else if((e.keyCode==38 || e.keyCode==87) && !addkey) {
			
				m_ScrollUp=true;

			} else if((e.keyCode==40 || e.keyCode==83) && !addkey) {
				m_ScrollDown=true;

			} else if((e.keyCode==37 || e.keyCode==65) && !addkey) {
				m_ScrollLeft=true;

			} else if((e.keyCode==39 || e.keyCode==68) && !addkey) {
				m_ScrollRight = true;
				
			//} else if (e.keyCode == 32 && m_FormFleetItem.IsMouseIn()) {
				//trace("SPACE fleet item");
				//m_FormFleetItem.
				
			} else if (e.keyCode == 32 && m_CurSpecial == 1) { // Space portal
				MsgPortalJump(null, 0);
				
			} else if (e.keyCode == 32 && m_CurPlanetNum >= 0 && m_CurShipNum < 0) { // space planet
				var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
				if (planet != null) {
					if(planet.m_Flag & Planet.PlanetFlagWormhole) JumpWormhole();
					else SpacePlanet();
				}

			} else if (e.keyCode == 32 && m_CurPlanetNum >= 0 && m_CurShipNum >= 0) { // space ship
				ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);

				if(ship!=null && ship.m_Type!=Common.ShipTypeNone && ship.m_Owner==Server.Self.m_UserId) {
					ac=new Action(this);
					ac.ActionToHyperspace(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum,-1);
					m_LogicAction.push(ac);
				}

			} else if(e.keyCode>=49 && e.keyCode<(49+7)) { // 1-7
				if(m_FormFleetBar.m_SlotMove==(e.keyCode-49) && m_FormFleetBar.m_SlotMoveBegin) m_FormFleetBar.SlotMoveBegin(-1); 
				else m_FormFleetBar.SlotMoveBegin(e.keyCode-49);

			} else if(e.keyCode==81 && m_CurPlanetNum>=0 && m_CurShipNum>=0) { // Q
				ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
				if(AccessControl(ship.m_Owner) || IsEdit()) {
					ActionNoToBattle();
				}

			} else if(e.keyCode==90 && m_CurPlanetNum>=0 && m_CurShipNum>=0) { // Z
				ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);

				if(ship!=null && ship.m_Type!=Common.ShipTypeNone && !Common.IsBase(ship.m_Type) && (IsEdit() || AccessControl(ship.m_Owner))) {
					ActionAIAttack();
				}

			} else if(e.keyCode==67 && m_CurPlanetNum>=0 && m_CurShipNum>=0) { // C
				ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);

				if(ship!=null && ship.m_Type!=Common.ShipTypeNone && !Common.IsBase(ship.m_Type) && (IsEdit() || AccessControl(ship.m_Owner))) {
					ActionAIRoute();
				}
				
			} else if(e.keyCode==88 && m_CurPlanetNum>=0 && m_CurShipNum>=0) { // X
				ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);

				if (ship != null && ship.m_Type != Common.ShipTypeNone && (IsEdit() || AccessControl(ship.m_Owner))) {
					MsgLinkOn();
				}

			} else if(e.keyCode==73 && (e.altKey || e.ctrlKey || e.shiftKey) && m_EmpireEdit) { // I
				m_FormItemManager.Show();

//				} else if(e.keyCode==81 && (e.altKey || e.ctrlKey || e.shiftKey) && m_EmpireEdit) { // Q
//					m_FormQuestManager.Show();

			} else if(e.keyCode==69 && m_CurPlanetNum>=0 && m_CurShipNum>=0) { // E
				ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
				if ((ship != null && AccessControl(ship.m_Owner)) || IsEdit()) {
					if (ship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(ship.m_Type) && ship.m_Race == Common.RaceGaal) {
						if(ship.m_AbilityCooldown0<=GetServerCalcTime()) MsgBarrier();
					}
					else if (ship.m_Type == Common.ShipTypeDreadnought && ship.m_Race == Common.RaceTechnol) ActionTransiver();
					else if (ship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(ship.m_Type) && ship.m_Race == Common.RacePeople) ActionNanits();
					else ActionPolar();
				}
				
			} else if (e.keyCode == 192 && m_CurPlanetNum >= 0 && m_CurShipNum >= 0) { // ~
				planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
				if(planet!=null && planet.m_PortalPlanet>0 && planet.m_PortalPlanet<5) {
					MsgPortalGo();
				}

			} else if (e.keyCode == 83 && addkey) { // Ctrl-S
				if (m_CurPlanetNum >= 0) {
					var gp:GraphPlanet = GetGraphPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
					if (gp != null && gp.m_Style != 0) {
						m_Info.Hide();
						HyperspacePlanetStyle.Edit(gp.m_Style);
					}
				} else {
					SpaceStyle();
				}

			} else if (e.keyCode == 72 && !IsFocusInput()) { // H
				if (Hangar.Self.visible) {
					Hangar.Self.Hide();
					ItfUpdate();
				} else {
					FormHideAll();
					Hangar.Self.Show();
					ItfUpdate();
				}
			}

			break;
		}
	}
	
	public override function onKeyUpHandler(e:KeyboardEvent):void
	{
		if((e.keyCode==17 || e.keyCode==16) && m_FormTech.visible) {
			m_FormTech.onMouseMoveHandler(new MouseEvent(MouseEvent.MOUSE_MOVE,true,false,0,0,null,false));
			
		} else if((e.keyCode==17 || e.keyCode==16) && m_FormTalent.visible) {
			m_FormTalent.onMouseMoveHandler(new MouseEvent(MouseEvent.MOUSE_MOVE,true,false,0,0,null,false));
		}
		
		//trace("key up "+e.keyCode);
/*			if(e.keyCode==17) {
			if(m_Action==ActionPathMove) {
				ActionPathMoveProcess();

				m_Action=ActionNone;
				CalcPick(mouseX,mouseY);
				m_GraphMovePath.Update();
			}
		}*/

		if (HS.visible) {
			HS.onKeyUpHandler(e);
			return;
		}

		while(true) {
			if(IsSpaceLock()) break;
			
			if(stage.focus==null) {}
			else if((stage.focus is TextField) && ((stage.focus as TextField).type==TextFieldType.INPUT)) break;

			//if(m_FormMenu.visible && e.keyCode!=17 && e.keyCode!=16) m_FormMenu.Clear(); 

			if (e.keyCode == 33) { // PageUp
				m_CamDistDir=0;

			} else if (e.keyCode == 34) { // PageDown
				m_CamDistDir = 0;

			} else if(e.keyCode==38 || e.keyCode==87) {
				m_ScrollUp=false;

			} else if(e.keyCode==40 || e.keyCode==83) {
				m_ScrollDown=false;

			} else if(e.keyCode==37 || e.keyCode==65) {
				m_ScrollLeft=false;

			} else if(e.keyCode==39 || e.keyCode==68) {
				m_ScrollRight=false;
			}
			break;
		}
	}

	public function SpacePlanet():void
	{
		var i:int;
		var score:int, bscore:int;
		var gp:GraphPlanet;
		
		if ((m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeCombat) && ((m_OpsFlag & Common.OpsFlagItemToHyperspace) == 0)) return;

		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;
		
		for (i = 0; i < m_PlanetList.length; i++) {
			gp=m_PlanetList[i];
			if(gp.m_SectorX==m_CurSectorX && gp.m_SectorY==m_CurSectorY && gp.m_PlanetNum==m_CurPlanetNum) break;
		}
		if (i >= m_PlanetList.length) return;
		
		var itemtype:uint = gp.m_PointsType;
		if (itemtype == 0) return;

		var m:int = planet.PlanetItemMax();

		var u:int = -1;

		for (i = Planet.PlanetItemCnt-1; i >= 0 ; i--) {
			var pi:PlanetItem = planet.m_Item[i];
			if (pi.m_Type != itemtype) continue;
			if (pi.m_Cnt <= 0) continue;

			score = Math.max(0x10000000 - pi.m_Cnt, 0);
			if (i >= m) score |= 0x40000000;

			if ((u < 0) || (score > bscore)) {
				bscore = score;
				u = i;
			}
		}
		if (u < 0) return;

		var ac:Action = new Action(this);
		ac.ActionItemMove(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, 1, u, 2, -1, 0);
		m_LogicAction.push(ac);
	}

	public function Takt(event:TimerEvent=null):void
	{
		var dx:int, dy:int;

//test_text.text = "test " + test_text_cnt.toString();
//test_text.backgroundColor = 0xffffff;
//test_text.textColor = 0xffff00;
//test_text_cnt++;
//trace(test_text_cnt);

		if(C3D.m_FatalError.length>0) {
			m_FormHint.Show("Fatal error:\n" + C3D.m_FatalError);
			m_Timer.stop();
			return;
		}

var t00:int = getTimer();
		m_CurTime = Common.GetTime();
		HS.m_CurTime = m_CurTime;
		if(!IsSpaceOff()) {
			m_ServerCalcTime = GetServerCalcTime();
			HS.m_ServerTime = GetServerGlobalTime();

			SendGv();
		} else {
			m_ServerCalcTime = 0;
			HS.m_ServerTime = GetServerGlobalTime();
		}

		dx = 0;
		dy = 0;

var t01:int = getTimer();
		if (m_FormFleetBar.visible) m_FormFleetBar.AutoPilotUpdate();

var t02:int = getTimer();
		while(!IsSpaceLock() && m_ScrollOn && !m_MoveMap && ((m_ScrollTime+20)<Common.GetTime())) {
			m_ScrollTime=Common.GetTime();

			if(m_FormMiniMap.m_Move) break;
			if(m_FormMiniMap.m_Float) break;
			if(m_FormRadar.m_Float) break;
			//if(m_FormMiniMap.IsMouseIn()) break;
			//if(m_FormChat.IsMouseIn()) break;
			
//if(m_FormFleetBar.m_SlotMove>=0) trace(m_FormFleetBar.IsMouseIn());

			if (m_Action == ActionMove && m_FormFleetBar.IsMouseIn()) break;
			else if (m_Action == ActionMove) { }
			else if (m_Action == ActionTransition) { }
			else if (m_Action == ActionExchange) { }
			else if (m_Action == ActionConstructor) { }
			else if (m_Action == ActionRecharge) { }
			else if (m_Action == ActionPlanet) { }
			else if (m_Action == ActionRoute) { }
			else if (m_Action == ActionShowRadius) { }
			else if (m_Action == ActionPlanetMove) { }
			else if (m_FormFleetBar.m_SlotMove >= 0 && !m_FormFleetBar.IsMouseIn()) { }
			else if (m_Action == ActionAntiGravitor) { }
			else if (m_Action == ActionGravWell) { }
			else if (m_Action == ActionBlackHole) { }
			else break;

			var range:int = 150;
			var speedmax:int = 20;
			
			var mx:int = stage.mouseX;
			var my:int = stage.mouseY;

			if (mx < range || my < range || mx >= (stage.stageWidth - range) || my >= (stage.stageHeight - range)) {
				if (mx < range) {
					dx += -Math.round((range-mx) / range * speedmax);
				} else if (mx >= (stage.stageWidth - range)) {
					dx += Math.round((mx - (stage.stageWidth - range)) / range * speedmax);
				}
				if (dx < -speedmax) dx = -speedmax;
				else if (dx > speedmax) dx = speedmax;

				if (my < range) {
					dy += -Math.round((range-my) / range * speedmax);
				} else if (my >= (stage.stageHeight - range)) {
					dy += Math.round((my - (stage.stageHeight - range)) / range * speedmax);
				}
				if (dy < -speedmax) dy = -speedmax;
				else if (dy > speedmax) dy = speedmax;
			}

//				if((stage.mouseY>=0) && (stage.mouseY<stage.stageHeight/*-FormInfoBar.BarHeight*/)) {
//					if(stage.mouseX<range && stage.mouseX>=0) dx+=-Math.round((range-stage.mouseX)/range*speedmax);
//					else if(stage.mouseX>stage.stageWidth-range && stage.mouseX<=stage.stageWidth) dx+=Math.round((stage.mouseX-(stage.stageWidth-range))/range*speedmax);
//				}

//				if(stage.mouseY<range && stage.mouseY>=0) dy+=-Math.round((range-stage.mouseY)/range*speedmax);
//				else if(stage.mouseY>stage.stageHeight/*-FormInfoBar.BarHeight*/-range && stage.mouseY<=stage.stageHeight/*-FormInfoBar.BarHeight*/) dy+=Math.round((stage.mouseY-(stage.stageHeight/*-FormInfoBar.BarHeight*/-range))/range*speedmax);
			
			break;
		}
var t03:int = getTimer();
		
		if(m_ScrollUp || m_ScrollDown || m_ScrollLeft || m_ScrollRight) {
			var step:int=Math.round(Math.min(stage.stageHeight,stage.stageWidth)/30);
			
			if(m_ScrollUp) dy-=step;//Math.round(stage.stageHeight/30);
			if(m_ScrollDown) dy+=step;//Math.round(stage.stageHeight/30);
			if(m_ScrollLeft) dx-=step;//Math.round(stage.stageWidth/30);
			if(m_ScrollRight) dx+=step;//Math.round(stage.stageWidth/30);
		}

		if(dx!=0 || dy!=0) {
			SetCenter(OffsetX+dx,OffsetY+dy);
			m_GoOpen=false;
			//m_FormMiniMap.Update();
			//m_FormMiniMap.ScrollToView();
			m_FormMiniMap.NeedScrollToViewAndUpdate();
		}

var t04:int = getTimer();
		if(m_FormCptBar.m_QueryCptDscTimer!=0 && Common.GetTime()>m_FormCptBar.m_QueryCptDscTimer) { m_FormCptBar.m_QueryCptDscTimer=Common.GetTime()+3000; m_FormCptBar.QueryCptDsc(); }

		HS.Takt();
var t05:int = getTimer();
		//Update();
		SendLoadSector();

var t06:int = getTimer();
		while(IsConnect() && m_LockTimeNewId<Common.GetTime()) {
			var cotl:SpaceCotl = HS.GetCotl(Server.Self.m_CotlId);
			if(cotl==null) break;

			var newcntneed:int=0;
			if(Server.Self.m_ServerKey!=cotl.m_NewIdServerKey || Server.Self.m_ClearCnt!=cotl.m_NewIdClearCnt) newcntneed=2;
			else {
				if(cotl.m_NewId==0) newcntneed++; 
				if(cotl.m_NewId2==0) newcntneed++;
			}

			if(newcntneed<=0) break;
			
			m_LockTimeNewId=Common.GetTime()+5000;
			Server.Self.Query("emnewid","&val="+newcntneed.toString(),AnswerNewId,false);

			break;
		}
var t07:int = getTimer();

		Update();
		
var t08:int = getTimer();
if((t08 - t00) > 50 && EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("!SLOW.EMT " + 
(t01 - t00).toString() 
+ " " + (t02 - t01).toString() 
+ " " + (t03 - t02).toString() 
+ " " + (t04 - t03).toString() 
+ " " + (t05 - t04).toString()
+ " " + (t06 - t05).toString()
+ " " + (t07 - t06).toString()
+ " " + (t08 - t07).toString()
);
	}

	public function AnswerNewId(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(ErrorFromServer(buf.readUnsignedByte())) return;

		m_LockTimeNewId=Common.GetTime()+100;

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		var cotlid:uint=sl.LoadDword();
		var serverkey:int=sl.LoadInt();
		var clearcnt:int=sl.LoadInt();
		var newid:uint=sl.LoadDword();
		var newcnt:uint=sl.LoadDword();			

		sl.LoadEnd();

		var cotl:SpaceCotl = HS.GetCotl(cotlid);
		if(cotl==null) return;

		if(newcnt<=0) return;
		
		if(cotl.m_NewIdServerKey!=serverkey || cotl.m_NewIdClearCnt!=clearcnt) {
			cotl.m_NewIdServerKey=serverkey;
			cotl.m_NewIdClearCnt=clearcnt;
			cotl.m_NewId=0;
			cotl.m_NewId2=0;
		}

		if(cotl.m_NewId==0 && newcnt>0) {
			cotl.m_NewId=newid;
			newid+=2;
			newcnt--;
//trace("RecvNewId:",cotl.m_NewId,"CotlId:",cotlid,"ServerKey:",serverkey);
		}

		if(cotl.m_NewId2==0 && newcnt>0) {
			cotl.m_NewId2=newid;
			newid+=2;
			newcnt--;
//trace("RecvNewId:",cotl.m_NewId2,"CotlId:",cotlid,"ServerKey:",serverkey);
		}
	}
	
	public function IsVisCamSector():Boolean
	{
		var sec:Sector = GetSector(m_CamSectorX, m_CamSectorY);
		if (sec == null) return false;
		
		var i:int;
		var planet:Planet;
		for (i = 0; i < sec.m_Planet.length; i++) {
			planet = sec.m_Planet[i];
			if (planet.m_Vis) return true;
		}
		return false;
	}

	public function SetCenter(x:int, y:int):void
	{
		var secx:int = Math.floor(x / m_SectorSize);
		var secy:int = Math.floor(y / m_SectorSize);
		var px:Number = x - secx * m_SectorSize;
		var py:Number = y - secy * m_SectorSize;

		if (secx == m_CamSectorX && secy == m_CamSectorY && px == m_CamPos.x && py == m_CamPos.y) return;

		m_CamSectorX = secx;
		m_CamSectorY = secy;
		m_CamPos.x = px;
		m_CamPos.y = py;
	}

/*		public function VisUpdate():void
	{
		var i:int,u:int,k:int,x:int,y:int;
		var sec:Sector;
		var planet:Planet;
		var ship2:Ship;
		var re:Rectangle=new Rectangle();
		var pt:Point=new Point();

		if(m_GraphJumpRadius.m_PlanetNum>=0 || HS.visible || !m_Set_Vis) {
			m_VisLayer.bitmapData=null;
			return;
		}
		if(m_CotlType==Common.CotlTypeUser && m_CotlOwnerId==Server.Self.m_UserId && m_HomeworldPlanetNum<0) {
			m_VisLayer.bitmapData=null;
			return;
		}
		if ((m_CotlType == Common.CotlTypeCombat || m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeRich) && (m_OpsFlag & Common.OpsFlagViewAll) != 0) {
			m_VisLayer.bitmapData=null;
			return;
		}
		if(IsEdit()) {
			m_VisLayer.bitmapData=null;
			return;
		}
		
		var mat:Matrix=new Matrix();
		
		var bm:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0xB0000000);
		
		var spcircle:Sprite=new Sprite();
		spcircle.graphics.lineStyle(2.5,0x8f8f0f,0.4);
		spcircle.graphics.drawCircle(0,0,m_OpsJumpRadius);
		
//			var bmcircle:BitmapData = new BitmapData(Common.JumpRadius*2+2, Common.JumpRadius*2+2, true, 0x00000000);
//			mat.identity();
//			mat.translate(Common.JumpRadius+1,Common.JumpRadius+1);
//			bmcircle.draw(spcircle,mat);

		var spfill:Sprite=new Sprite();
		spfill.graphics.lineStyle(0.0,0x000000,0.0);
		spfill.graphics.beginFill(0x000000,1.0);
		spfill.graphics.drawCircle(0,0,m_OpsJumpRadius-1);
		spfill.graphics.endFill();

//			var bmfill:BitmapData = new BitmapData(Common.JumpRadius*2+2, Common.JumpRadius*2+2, true, 0x00000000);
//			mat.identity();
//			mat.translate(Common.JumpRadius+1,Common.JumpRadius+1);
//			bmfill.draw(spfill,mat);

//			m_VisLayer.graphics.clear();
//			m_VisLayer.graphics.beginFill(0x000000,0.5);
//			m_VisLayer.graphics.drawRect(-100,-100,stage.stageWidth+200,stage.stageHeight+200);
//m_VisLayer.graphics.endFill();

//			m_VisLayer.graphics.lineStyle(1.5,0xffff00,1.0);

		if(!IsSpaceOff()) {
//				var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize)-1);
//				var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize)-1);
//				var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+2);
//				var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(ScreenToWorldY(stage.stageHeight) / m_SectorSize) + 2);

			if (!PickWorldCoord(0, 0, m_TV0)) return;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

			for (y = sy; y < ey; y++) {
				for (x = sx; x < ex; x++) {
					i = (x - m_SectorMinX) + (y - m_SectorMinY) * m_SectorCntX;
					if (i < 0 || i >= m_SectorCntX * m_SectorCntY) throw Error("");
					if (!(m_Sector[i] is Sector)) continue;
					sec = m_Sector[i];

					for(i=0;i<sec.m_Planet.length;i++) {
						planet=sec.m_Planet[i];
						
						while(true) {
							if(planet.m_Owner==Server.Self.m_UserId) {}
							else if(AccessControl(planet.m_Owner)) {}
							else if(AccessBuild(planet.m_Owner)) {}
							else if(IsFriendEx(planet, planet.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) {}
							else {
								for(k=0;k<Common.ShipOnPlanetMax;k++) {
									ship2=planet.m_Ship[k];

									if(ship2.m_Type==Common.ShipTypeNone) continue;
									if(ship2.m_Owner==0) continue;

									if(ship2.m_Owner==Server.Self.m_UserId) break
									if(AccessControl(ship2.m_Owner)) break
									if(AccessBuild(ship2.m_Owner)) break
									if(IsFriendEx(planet, ship2.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) break
								}
								if(k>=Common.ShipOnPlanetMax) break;
							}

							mat.identity();
							WorldToScreenX(planet.m_PosX, planet.m_PosY);
							mat.translate(m_TWSPos.x,m_TWSPos.y);
							bm.draw(spcircle,mat);
							
							//re.left=0; re.top=0;
							//re.right=bmcircle.width; re.bottom=bmcircle.height;
							//pt.x=WorldToScreenX(planet.m_PosX)-(bmcircle.width>>1);
							//pt.y=WorldToScreenY(planet.m_PosY)-(bmcircle.height>>1);
							//bm.copyPixels(bmcircle,re,pt,null,null,true);

							break;
						}
					}
				}
			}
			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) continue;
					sec=m_Sector[i];

					for(i=0;i<sec.m_Planet.length;i++) {
						planet=sec.m_Planet[i];

						while(true) {
							if(planet.m_Owner==Server.Self.m_UserId) {}
							else if(AccessControl(planet.m_Owner)) {}
							else if(AccessBuild(planet.m_Owner)) {}
							else if(IsFriendEx(planet, planet.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) {}
							else {
								for(k=0;k<Common.ShipOnPlanetMax;k++) {
									ship2=planet.m_Ship[k];

									if(ship2.m_Type==Common.ShipTypeNone) continue;
									if(ship2.m_Owner==0) continue;

									if(ship2.m_Owner==Server.Self.m_UserId) break
									if(AccessControl(ship2.m_Owner)) break
									if(AccessBuild(ship2.m_Owner)) break
									if(IsFriendEx(planet, ship2.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) break
								}
								if(k>=Common.ShipOnPlanetMax) break;
							}

							mat.identity();
							WorldToScreenX(planet.m_PosX, planet.m_PosY);
							mat.translate(m_TWSPos.x, m_TWSPos.y);
							bm.draw(spfill, mat, null, BlendMode.ERASE);
							//re.left=0; re.top=0;
							//re.right=bmfill.width; re.bottom=bmfill.height;
							//pt.x=WorldToScreenX(planet.m_PosX)-(bmfill.width>>1);
							//pt.y=WorldToScreenY(planet.m_PosY)-(bmfill.height>>1);
							//bm.copyPixels(bmfill,re,pt,null,null,true);

							break;
						}
					}
				}
			}
		}
//			m_VisLayer.graphics.endFill();
		
		if(m_VisLayer.bitmapData!=null) m_VisLayer.bitmapData.dispose(); 

		m_VisLayer.bitmapData=bm;
	}*/

	public function PlanetUpdate():void
	{
		var i:int,u:int,k:int,x:int,y:int;
		var sec:Sector;
		var planet:Planet;
		var gp:GraphPlanet;
		var ship:Ship;
		
		//var st:Number = GetServerTime();

		for(i=0;i<m_PlanetList.length;i++) {
			gp=m_PlanetList[i];
			gp.m_Tmp=0;
		}
//trace("A01");
		if(!IsSpaceOff() && !HS.visible && m_Set_Planet) {
//				var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize)-1);
//				var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize)-1);
//				var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+2);
//				var ey:int=Math.min(m_SectorMinY+m_SectorCntY,Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize)+2);
			if (!PickWorldCoord(0, 0, m_TV0)) return;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);
			
			for each (sec in m_Sector) {
				if (sec == null) continue;
				for(i=0;i<sec.m_Planet.length;i++) {
					planet = sec.m_Planet[i];
					planet.m_Vis = false;
				}
			}

//trace("A02");
			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) continue;
					sec=m_Sector[i];

//trace("A03");
					for(i=0;i<sec.m_Planet.length;i++) {
						planet=sec.m_Planet[i];

						if (!planet.IsExist()) {
							if ((planet.m_Flag & Planet.PlanetFlagWormhole) && m_Set_ShowWormholePoint) { }
							else if (!IsEdit()) continue;
						}

						var isvis:Boolean = IsVisCalc(planet);
						planet.m_Vis = isvis;

//trace("A05");
						for(u=0;u<m_PlanetList.length;u++) {
							gp=m_PlanetList[u];
							
							if(gp.m_SectorX==x && gp.m_SectorY==y && gp.m_PlanetNum==i) break;
						}
						if(u>=m_PlanetList.length) {
							gp=new GraphPlanet(this);
							gp.m_SectorX=x;
							gp.m_SectorY=y;
							gp.m_PlanetNum=i;
							m_PlanetList.push(gp);
						}
						gp.m_Tmp=1;
						//if(planet.m_Owner==m_UserId) gp.SetColor(0x0000ff);
						//else gp.SetColor(0x404040);
						
//trace("A06");
						gp.m_PosX = planet.m_PosX;
						gp.m_PosY = planet.m_PosY;

						gp.m_Path = planet.m_Path;
						gp.m_Route0 = planet.m_Route0;
						gp.m_Route1 = planet.m_Route1;
						gp.m_Route2 = planet.m_Route2;

						gp.m_Vis = isvis;

//if(planet.m_Flag & Planet.PlanetFlagWormhole) trace("Wormhole",planet.m_PosX,planet.m_PosX);

						var str:String='';
						if(planet.m_Flag & (Planet.PlanetFlagWormholePrepare)) {
							str = Common.FormatPeriod((planet.m_NeutralCooldown - m_ServerCalcTime) / 1000);
							gp.SetColor(0x404000);
						}
						else if (planet.m_Flag & (Planet.PlanetFlagWormholeOpen)) {
							if ((m_CotlType == Common.CotlTypeCombat || m_CotlType == Common.CotlTypeProtect) && (m_OpsFlag & (Common.OpsFlagWormholeLong | Common.OpsFlagWormholeFast | Common.OpsFlagWormholeRoam)) == 0) str = "∞";
							else if(planet.m_Flag & Planet.PlanetFlagStabilizer) str="∞";
							else str=Common.FormatPeriod((planet.m_NeutralCooldown-m_ServerCalcTime)/1000);
							gp.SetColor(0x004000);
						}
						else if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
							if (planet.m_NeutralCooldown == 0) str = "∞";
							else str=Common.FormatPeriod((planet.m_NeutralCooldown-m_ServerCalcTime)/1000);
							if(planet.m_Flag & Planet.PlanetFlagStabilizer) gp.SetColor(0x004000);
							else gp.SetColor(0x404000);
						}
						else if(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant)) {}
						else if(!isvis) {}
						else {
							str=planet.m_Level.toString();
							if(AccessBuild(planet.m_Owner) && planet.m_LevelBuy>0) str+="+"+planet.m_LevelBuy.toString();

//								if(m_Action==ActionPlanet && m_CurSectorX==x && m_CurSectorY==y && m_CurPlanetNum==i && m_CurShipNum<0 && m_AddCnt>0) {
//									if(m_CurSectorX==m_MoveSectorX && m_CurSectorY==m_MoveSectorY && m_CurPlanetNum==m_MovePlanetNum) {
//										str+="+"+m_AddCnt;
//									}
//								}
							gp.SetColor(ColorByOwner(planet,planet.m_Owner));
						}
						if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {}
						else if (planet.m_Owner == 0 && planet.m_Level == 0 && (planet.m_Flag & Planet.PlanetFlagNoCapture) != 0)  str = "";
						gp.SetLvl(str);

//trace("A07");
						str='';
						if(!isvis) {}
						else {
							str+=TxtCotl_PlanetName(x,y,i);
							if(str.length>0) str="<font size='+1' color='#00ffff'>"+str+"</font>\n";
							else if (planet.m_Flag & Planet.PlanetFlagHomeworld) str += "<font size='+1' color='#00ffff'>" + Common.Txt.Homeworld + "</font>\n";
							else if((planet.m_Flag & Planet.PlanetFlagCitadel) && IsWinMaxEnclave()) str+="<font size='+1' color='#00ffff'>"+Common.Txt.Base+"</font>\n";
							else if(planet.m_Flag & Planet.PlanetFlagCitadel) str+="<font size='+1' color='#00ffff'>"+Common.Txt.Citadel+"</font>\n";
							else if (IsWinMaxEnclave()) {
								if((planet.m_Owner!=0) && (planet.m_Flag & Planet.PlanetFlagEnclave)) str+="<font size='+1' color='#00ffff'>"+Common.Txt.District+"</font>\n";
								else if((planet.m_Owner!=0)) str+="<font size='+1' color='#00ffff'>"+Common.Txt.Outpost+"</font>\n";
							}
							else if (m_CotlType != Common.CotlTypeProtect && m_CotlType != Common.CotlTypeCombat) {
								if ((m_CotlType == Common.CotlTypeRich) && (planet.m_Owner != 0) && (planet.m_Owner & Common.OwnerAI) == 0 && (m_OpsFlag & Common.OpsFlagEnclave) == 0) { }
//									else if(!m_EmpireColony && planet.m_Owner!=0 && planet.m_Owner==m_CotlOwnerId) str+="<font size='+1' color='#00ffff'>"+Common.Txt.Empire+"</font>\n";
//									else if(m_EmpireColony && planet.m_Owner==Server.Self.m_UserId && planet.m_Island!=0 && planet.m_Island==m_HomeworldIsland) str+="<font size='+1' color='#00ffff'>"+Common.Txt.Empire+"</font>\n";
								else if (planet.m_Owner != 0 && m_CotlType == Common.CotlTypeUser && planet.m_Owner == m_CotlOwnerId) {
									if(!m_EmpireColony && IsEmpirePlanet(planet)) str+="<font size='+1' color='#00ffff'>"+Common.Txt.Empire+"</font>\n";
									else if (m_EmpireColony && planet.m_Island != 0 && planet.m_Island == m_HomeworldIsland) str+="<font size='+1' color='#00ffff'>"+Common.Txt.Empire+"</font>\n";
									else str+="<font size='+1' color='#00ffff'>"+Common.Txt.Colony+"</font>\n";
								}
								else if (planet.m_Owner == Server.Self.m_UserId && (planet.m_Flag & Planet.PlanetFlagEnclave) != 0 /*planet.m_Island!=0 && planet.m_Island==m_CitadelIsland*/) str += "<font size='+1' color='#00ffff'>" + Common.Txt.Enclave + "</font>\n";
								else if(planet.m_Owner==Server.Self.m_UserId) str+="<font size='+1' color='#00ffff'>"+Common.Txt.Colony+"</font>\n";
							}
						}

						var user:User=UserList.Self.GetUser(planet.m_Owner);
						//if(isvis && user!=null) str+=""+user.m_Name+"\n";
						if(isvis && planet.m_Owner!=0) str+=Txt_CotlOwnerName(Server.Self.m_CotlId,planet.m_Owner)+"\n";
						if (m_Debug) str += "Island: " + planet.m_Island.toString() + "\n";
						if (m_Debug) str += "Supply: " + planet.m_MachineryNeed.toString() + " " + planet.m_EngineerNeed.toString() + "\n";
						if (m_Debug) str += "SupplyUse: " + planet.m_SupplyUse.toString() + "\n";
						if (m_DebugFlag & DebugAISpace) str += "AISpace: " + planet.m_AISpace.toString() + "\n";
						if (m_DebugFlag & DebugAISpace) str += "AIProtect: " + planet.m_AIProtect.toString() + "\n";
						if (m_DebugFlag & DebugAISpace) str += "AIFromCenter: " + planet.m_AIFromCenter.toString() + "\n";
						if (m_DebugFlag & DebugAIShip) str += "AINeedTransport: " + planet.m_AINeedTransport.toString() + "\n";
						if (m_DebugFlag & DebugAIShip) str += "AINeedInvader: " + planet.m_AINeedInvader.toString() + "\n";
						if (m_DebugFlag & DebugAIShip) str += "AINeedCruiser: " + planet.m_AINeedCruiser.toString() + "\n";
						if (m_DebugFlag & DebugAIShip) str += "AINeedDreadnought: " + planet.m_AINeedDreadnought.toString() + "\n";
						gp.SetName(str);

						gp.Update();
						if(!isvis) {
							gp.SetPortal(0);
							gp.SetGravitor(0);
							gp.SetRadiation(0);
						} else {
							if (planet.m_PortalPlanet > 0 && planet.m_PortalPlanet < 5 && (planet.m_Flag & Planet.PlanetFlagWormhole) == 0) {
								if (m_CurSpecial == 1 && m_CurSectorX == x && m_CurSectorY == y && m_CurPlanetNum == i) gp.SetPortal(2);
								else gp.SetPortal(1);
							} else gp.SetPortal(0);

							if(planet.m_Flag & Planet.PlanetFlagGravitor) gp.SetGravitor(3);
							else if(planet.m_Flag & Planet.PlanetFlagGravitorSci) gp.SetGravitor(2);
							else if (planet.m_Flag & Planet.PlanetFlagGravitorSciPrepare) gp.SetGravitor(1);
							else if (planet.m_GravitorTime > m_ServerCalcTime) gp.SetGravitor(4);
							else gp.SetGravitor(0);

							if (planet.m_Radiation == 0) gp.SetRadiation(0);
							else gp.SetRadiation(0.4+0.6+(Math.abs(planet.m_Radiation)/1000));
						}

						//if(!isvis) gp.SetPoints("");
						//else if((m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeRich) && (m_OpsFlag & Common.OpsFlagBuildMask)==0 && m_OpsCostBuildLvl==0 && m_OpsModuleMul==0) gp.SetPoints("");
						//else if(IsEdit()) gp.SetPoints(planet.m_ConstructionPoint.toString());
						//else if(!AccessBuild(planet.m_Owner)) gp.SetPoints("");
						//else gp.SetPoints(planet.m_ConstructionPoint.toString());
						
						var item_type:uint = 0;
						var item_cnt:int = 0;
						if (!isvis) gp.SetPoints(0,"");
						//else if (!AccessBuild(planet.m_Owner)) gp.SetPoints(0,"");
						while (true) {
							if (!isvis) { gp.SetPoints(0, ""); break; }
							if (planet.m_Owner == 0) {
								for (u = 0; u < Common.ShipOnPlanetMax; u++) {
									ship = planet.m_Ship[u];
									if (ship.m_Type != Common.ShipTypeServiceBase) continue;
									if (ship.m_Owner != Server.Self.m_UserId) continue;
									break;
								}
								if(u>=Common.ShipOnPlanetMax) { gp.SetPoints(0, ""); break; }
							} else if(planet.m_Owner!=Server.Self.m_UserId) { gp.SetPoints(0, ""); break; }
							
							for (u = 0; u < planet.m_Item.length; u++) {
								if (planet.m_Item[u].m_Type == 0) continue;
								if ((planet.m_Item[u].m_Flag & PlanetItem.PlanetItemFlagShowCnt) == 0) continue;

								var _item_type:uint = planet.m_Item[u].m_Type;
								var _item_cnt:int = 0;

								for (k = 0; k < planet.m_Item.length; k++) {
									if (planet.m_Item[k].m_Type != _item_type) continue;
									_item_cnt += planet.m_Item[k].m_Cnt;
								}

								if (item_type == 0 || _item_cnt > item_cnt) {
									item_type = _item_type;
									item_cnt = _item_cnt;
								}
							}
							if(item_type==0) gp.SetPoints(0,"");
							else gp.SetPoints(item_type, "         "+BaseStr.FormatBigInt(item_cnt).toString()+" ");
							//else gp.SetPoints(item_type, " "+BaseStr.FormatBigInt(item_cnt).toString()+"       ");
							break;
						}

						gp.SetFlag(planet.m_Flag);
//trace("A08");

						//if(!m_Set_Info) gp.SetItemType(Common.ItemTypeNone);
						//else
						if(planet.m_Flag & Planet.PlanetFlagWormhole) {}
						else if ((m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeCombat) && !IsEdit()) { }
						else if (m_CotlType == Common.CotlTypeRich && (m_OpsFlag & Common.OpsFlagEnclave) == 0) { }
						else gp.SetItemType(planet.m_OreItem);

						gp.SetRaceType(Common.RaceNone); 
						//if(!m_Set_Info) gp.SetRaceType(Common.RaceNone); 
						//else if(!isvis) gp.SetRaceType(planet.m_Race);
						//else if(planet.m_Owner==0) gp.SetRaceType(planet.m_Race);
						//else gp.SetRaceType(Common.RaceNone);

						gp.SetRefuel(planet.m_Refuel != 0);

						gp.SetGravWell((planet.m_Flag & Planet.PlanetFlagGravWell) != 0);
						gp.SetPotential((planet.m_Flag & Planet.PlanetFlagPotential)!=0);

						if(!isvis) gp.SetShield(-1);
						else if(planet.m_Flag & (Planet.PlanetFlagGlobalShield|Planet.PlanetFlagLocalShield)) gp.SetShield(1);
						else if(planet.m_ShieldEnd<=m_ServerCalcTime) gp.SetShield(-1);
						else {
							if((planet.m_ShieldEnd-Common.PlusarPlanetShieldEnd*1000)<=m_ServerCalcTime) gp.SetShield(0);
							else gp.SetShield(1);
						} 
						
						gp.m_Spawn = false;
						if (IsEdit()) {
							if (m_SpawnList[((planet.m_Sector.m_SectorX & 0xfff) << 2) | ((planet.m_Sector.m_SectorY & 0xfff) << (12 + 2)) | planet.m_PlanetNum] != undefined) {
								gp.m_Spawn = true;
							}
						}
						
						gp.Update();
					}
				}
			}
		}

		for(i=m_PlanetList.length-1;i>=0;i--) {
			gp=m_PlanetList[i];
			if(gp.m_Tmp==0) {
				gp.Clear();
				m_PlanetList.splice(i,1);
			}
		}
	}

	public function PathUpdate():void
	{
return;
		var i:int,u:int,x:int,y:int,k:int,route:int;
		var sec:Sector;
		var planet:Planet;
		var planet2:Planet;
		var gp:GraphPath;
		var tsecx:int;
		var tsecy:int;
		var tplanet:int;

		for(i=0;i<m_PathLayer.numChildren;i++) {
			gp=m_PathLayer.getChildAt(i) as GraphPath;
			gp.m_Tmp=0;
		}
		for(i=0;i<m_PathLayer2.numChildren;i++) {
			gp=m_PathLayer2.getChildAt(i) as GraphPath;
			gp.m_Tmp=0;
		}

		if(!IsSpaceOff() && !HS.visible ) {
//				var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize)-1);
//				var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize)-1);
//				var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+2);
//				var ey:int=Math.min(m_SectorMinY+m_SectorCntY,Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize)+2);
			if (!PickWorldCoord(0, 0, m_TV0)) return;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) continue;
					sec=m_Sector[i];
					
					for(i=0;i<sec.m_Planet.length;i++) {
						planet=sec.m_Planet[i];

						var isvis:Boolean=planet.m_Vis;

						if(planet.m_Path!=0) {
						//if(false) {
							tsecx=x;
							tsecy=y;
							tplanet=(planet.m_Path>>4)&7;

							if(planet.m_Path & 1) tsecx+=1;
							else if(planet.m_Path & 2) tsecx-=1;
							if(planet.m_Path & 4) tsecy+=1;
							else if(planet.m_Path & 8) tsecy-=1;

							if(x==tsecx && y==tsecy && i==tplanet) break;

							planet2=GetPlanet(tsecx,tsecy,tplanet);
							if(planet2==null) break;

							for(u=0;u<m_PathLayer.numChildren;u++) {
								gp=m_PathLayer.getChildAt(u) as GraphPath;
								if(gp.m_Type==0 && gp.m_SectorX==x && gp.m_SectorY==y && gp.m_PlanetNum==i && gp.m_TargetSectorX==tsecx && gp.m_TargetSectorY==tsecy && gp.m_TargetPlanetNum==tplanet) break;
							}
							if(u>=m_PathLayer.numChildren) {
								gp=new GraphPath(this);
								gp.m_Type=0;
								gp.m_SectorX=x;
								gp.m_SectorY=y;
								gp.m_PlanetNum=i;
								gp.m_TargetSectorX=tsecx;
								gp.m_TargetSectorY=tsecy;
								gp.m_TargetPlanetNum=tplanet;
								m_PathLayer.addChild(gp);
							}
//trace("GraphPath",gp.m_SectorX,gp.m_SectorY,gp.m_PlanetNum,gp.m_TargetSectorX,gp.m_TargetSectorY,gp.m_TargetPlanetNum);
							gp.m_Vis = isvis && (m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || RouteAccess(planet, Server.Self.m_UserId) || IsFriendEx(planet,planet.m_Owner,planet.m_Race,Server.Self.m_UserId,0));
							gp.m_TargetVis = planet2.m_Vis && (m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || RouteAccess(planet2, Server.Self.m_UserId) || IsFriendEx(planet2,planet2.m_Owner,planet2.m_Race,Server.Self.m_UserId,0));
							gp.m_Tmp=1;
							gp.Update();
						}
						for (k = 0; k < Common.RouteMax; k++) {
							if (k == 0) route = planet.m_Route0;
							else if (k == 1) route = planet.m_Route1;
							else route = planet.m_Route2;
							if (route != 0) {
								tsecx = x;
								tsecy = y;
								tplanet = (route >> 4) & 7;

								if (route & 1) tsecx += 1;
								else if (route & 2) tsecx -= 1;
								if (route & 4) tsecy += 1;
								else if (route & 8) tsecy -= 1;

								if (x == tsecx && y == tsecy && i == tplanet) break;
								
								planet2=GetPlanet(tsecx,tsecy,tplanet);
								if(planet2==null) break;

								for(u=0;u<m_PathLayer2.numChildren;u++) {
									gp=m_PathLayer2.getChildAt(u) as GraphPath;
									if(gp.m_Type==1 && gp.m_SectorX==x && gp.m_SectorY==y && gp.m_PlanetNum==i && gp.m_TargetSectorX==tsecx && gp.m_TargetSectorY==tsecy && gp.m_TargetPlanetNum==tplanet) break;
								}
								if(u>=m_PathLayer2.numChildren) {
									gp=new GraphPath(this);
									gp.m_Type=1;
									gp.m_SectorX=x;
									gp.m_SectorY=y;
									gp.m_PlanetNum=i;
									gp.m_TargetSectorX=tsecx;
									gp.m_TargetSectorY=tsecy;
									gp.m_TargetPlanetNum=tplanet;
									m_PathLayer2.addChild(gp);
								}
								gp.m_Tmp=1;
								gp.m_Vis = isvis && (RouteAccess(planet, Server.Self.m_UserId) || IsFriendEx(planet, planet.m_Owner, planet.m_Race, Server.Self.m_UserId, 0));
								gp.m_TargetVis=planet2.m_Vis && (RouteAccess(planet2,Server.Self.m_UserId) || IsFriendEx(planet2,planet2.m_Owner,planet2.m_Race,Server.Self.m_UserId,0));
								gp.Update();
							}
						}
					}
				}
			}
		}

		for(i=m_PathLayer.numChildren-1;i>=0;i--) {
			gp=m_PathLayer.getChildAt(i) as GraphPath;

			if(gp.m_Tmp==0) {
				m_PathLayer.removeChild(gp);
			}
		}
		for(i=m_PathLayer2.numChildren-1;i>=0;i--) {
			gp=m_PathLayer2.getChildAt(i) as GraphPath;
			
			if(gp.m_Tmp==0) {
				m_PathLayer2.removeChild(gp);
			}
		}
	}

	public function ShipUpdate(dt:Number):void
	{
		var i:int,u:int,k:int,x:int,y:int,subtype:int,j:int;
		var sec:Sector;
		var planet:Planet;
		var planet2:Planet;
		var ship:Ship;
		var ship2:Ship;
		var gs:GraphShip;
		var user:User;
		var a_control:Boolean;
		var a_build:Boolean;
		var str:String;
		var str2:String;

		var isedit:Boolean=IsEdit();
		//var servertime:Number = m_ServerTime;// GetServerTime();
		//m_CurTime = Common.GetTime();
		//m_ServerTime = GetServerTime();

//var t1:Number=0;
//var t2:Number=0;
//var t3:Number=0;
//var t4:Number=0;			
//var t5:Number=0;
//var t6:Number=0;
//var t7:Number=0;
//var ta0:Number=Common.GetTime();

		for(i=0;i<m_ShipList.length;i++) {
			gs=m_ShipList[i];
			gs.m_Tmp=0;
		}
//trace("FB Start");

		if(m_StateConnect>=1 && !HS.visible && m_Set_Ship) {
//				var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize)-1);
//				var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize)-1);
//				var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+2);
//				var ey:int=Math.min(m_SectorMinY+m_SectorCntY,Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize)+2);
			if (!PickWorldCoord(0, 0, m_TV0)) return;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) continue;
					sec=m_Sector[i];
					if(sec.m_Off) continue;
					
					for(i=0;i<sec.m_Planet.length;i++) {
						planet=sec.m_Planet[i];

						var isvis:Boolean=planet.m_Vis;

						for(k=0;k<Common.ShipOnPlanetMax;k++) {
							ship=planet.m_Ship[k];
							if(ship.m_Type==Common.ShipTypeNone) continue;


//var _t0=Common.GetTime();
							for(u=0;u<m_ShipList.length;u++) {
								gs=m_ShipList[u];

								if(gs.m_Owner==ship.m_Owner && gs.m_Id==ship.m_Id) break;
							}
							if(u>=m_ShipList.length) {
								gs=new GraphShip(this);
								gs.m_Owner=ship.m_Owner;
								gs.m_Id=ship.m_Id;
								m_ShipList.push(gs);
							}
							gs.m_Tmp=1;
							gs.m_SectorX=x;
							gs.m_SectorY=y;
							gs.m_PlanetNum=i;
							gs.m_ShipNum = k;
							gs.m_ShipNumLO = k >= planet.ShipOnPlanetLow;
							gs.m_ArrivalTime=ship.m_ArrivalTime;
							gs.m_Flag=ship.m_Flag;
							gs.m_FromSectorX=ship.m_FromSectorX;
							gs.m_FromSectorY=ship.m_FromSectorY;
							gs.m_FromPlanet=ship.m_FromPlanet;
							gs.m_FromPlace = ship.m_FromPlace;

							gs.m_IsFlyOtherPlanet = IsFlyOtherPlanet(ship, planet);

							subtype=0;
							if(ship.m_Type==Common.ShipTypeFlagship) {
								subtype=CalcFlagshipSubtype(ship.m_Owner,ship.m_Id);
							}

							a_control=false;
							a_build=false;
							if(ship.m_Owner==Server.Self.m_UserId) a_control=true;
							else {
								j=GetRel(ship.m_Owner,Server.Self.m_UserId);
								if((j & Common.PactControl)!=0) a_control=true;
								if((j & Common.PactBuild)!=0) a_build=true;
							}

							gs.SetType(ship.m_Type, ship.m_Race, subtype, ((ship.m_Flag & Common.ShipFlagBattle) != 0) && (k < planet.ShipOnPlanetLow), ((ship.m_Flag & Common.ShipFlagNoToBattle) != 0) || !a_control || ship.m_Type == Common.ShipTypeTransport || (ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagPortal |Common.ShipFlagEject | Common.ShipFlagBomb)) != 0);//ship.m_Type!=Common.ShipTypeTransport);

							if (ship.m_Type == Common.ShipTypeFlagship) {
								gs.SetName(Txt_CptName(Server.Self.m_CotlId, ship.m_Owner, ship.m_Id));
							}
/*								if(ship.m_Type==Common.ShipTypeFlagship && ship.m_Owner==Server.Self.m_UserId) {
								var objcd:Object=m_FormCptBar.CptDsc(ship.m_Id);
								if(objcd!=null) {
									gs.SetName(objcd.Name);
								}
							} else if(ship.m_Type==Common.ShipTypeFlagship) {
								user=UserList.Self.GetUser(ship.m_Owner);
								if(user!=null) {
									var cpt:Cpt=user.GetCpt(ship.m_Id);
									if((cpt!=null) && (cpt.m_Name!=null)) {
										gs.SetName(cpt.m_Name);
									}
								}
							}*/

							var hidebar:Boolean = false;
							if(ship.m_Owner==Server.Self.m_UserId) {}
							else if(IsFriendEx(planet, ship.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) {}
							//else if((GetRel(ship.m_Owner,Server.Self.m_UserId) & (Common.PactControl | Common.PactBuild))!=0);
							else if(a_control || a_build) {}
							else if(CalcRadarPower(planet, Server.Self.m_UserId)>=0) {}
							else { hidebar = true; }

							str=ship.m_Cnt.toString();
							str2=null;
//								if(m_Action==ActionPlanet && m_CurSectorX==x && m_CurSectorY==y && m_CurPlanetNum==i && m_CurShipNum==k && m_AddCnt>0) {
//									str+="+"+m_AddCnt;
//								}

							var sh:int = 0;
							var shmax:int = 0;
							var hp:int = 0;
							var hpmax:int = 0;

							if (ship.m_Type == Common.ShipTypeFlagship || ship.m_Type == Common.ShipTypeQuarkBase) {
								str = "";
/*									if (ShipMaxHP(ship.m_Owner, ship.m_Id, ship.m_Type,ship.m_Race) == 0) str="";
								else {
									str=""+Math.round(ship.m_HP/ShipMaxHP(ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Race)*100).toString()+"%\n";
									if(ship.m_Flag & Common.ShipFlagPolar) {
										str2="("+Math.round(ship.m_Shield/ShipMaxShield(ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Race,ship.m_Cnt)*100).toString()+"%)";
									} else {
										str+=""+Math.round(ship.m_Shield/ShipMaxShield(ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Race,ship.m_Cnt)*100).toString()+"%";
									}
								}*/
								hpmax = ShipMaxHP(ship.m_Owner, ship.m_Id, ship.m_Type,ship.m_Race);
								if (hpmax > 0/* && ship.m_HP < j*/) {
									hp = Math.max(1, Math.min(10, Math.round((ship.m_HP / hpmax) * 10)));
									
									//str=""+Math.round(ship.m_HP/hpmax*100).toString()+"%";
								}
							}
							
							if (ship.m_Type == Common.ShipTypeFlagship || ship.m_Type == Common.ShipTypeQuarkBase || ship.m_Race == Common.RaceTechnol) {
								shmax = ShipMaxShield(ship.m_Owner, ship.m_Id, ship.m_Type,ship.m_Race,ship.m_Cnt);
								if (shmax > 0/* && ship.m_Shield < j*/) {
									sh = Math.max(1, Math.min(10, Math.round((ship.m_Shield / shmax) * 10)));
//										if (ship.m_Flag & Common.ShipFlagPolar) {
//											gs.SetShieldBar(j, 10, 1);
//											//str2="("+Math.round(ship.m_Shield/j*100).toString()+"%)";
//										} else {
//											gs.SetShieldBar(j, 10, 0);
//											//str+="\n"+Math.round(ship.m_Shield/j*100).toString()+"%";
//										}
								}
							} else if (ship.m_Race == Common.RaceGaal && !Common.IsBase(ship.m_Type) && ship.m_Shield > 0) {
								sh = Math.max(1, Math.min(10, Math.round((ship.m_Shield / Common.GaalBarrierMax) * 10)));

//								} else if (ship.m_Race == Common.RacePeople && !Common.IsBase(ship.m_Type) && ship.m_Shield > 0) {
//									sh = Math.max(1, Math.min(10, Math.round((ship.m_Shield / 50000) * 10)));
							}

							if (ship.m_Type == Common.ShipTypeFlagship || ship.m_Type == Common.ShipTypeQuarkBase) {
								if (m_Set_ShieldPercent) {
									str = Math.min(100, Math.round((ship.m_HP) / (hpmax) * 100)).toString() + "%";
									str2 = Math.min(100, Math.round((ship.m_Shield) / (shmax) * 100)).toString() + "%";
								} else {
									str = "" + Math.min(100, Math.round((ship.m_HP + ship.m_Shield) / (hpmax + shmax) * 100)).toString() + "%";
								}
							}
							
							if (hidebar || (hp <= 0 && sh <= 0) || 
								((ship.m_Race == Common.RaceTechnol || ship.m_Type == Common.ShipTypeFlagship || Common.IsBase(ship.m_Type)) && (ship.m_HP >= hpmax) && (ship.m_Shield >= shmax) && ((ship.m_Flag & Common.ShipFlagPolar) == 0))) 
							{
								gs.SetHPBar(0, 0, 0);
								gs.SetShieldBar(0, 0, 0);
							} else {
								if (hp > 0) gs.SetHPBar(hp, 10, 0);
								else gs.SetHPBar(0, 0, 0);

								if(ship.m_Race == Common.RaceGaal && ship.m_Type != Common.ShipTypeFlagship && ship.m_Type != Common.ShipTypeQuarkBase) gs.SetShieldBar(sh, 10, 2);
								else if (sh > 0 && (ship.m_Flag & Common.ShipFlagPolar) != 0) gs.SetShieldBar(sh, 10, 1);
								else if (sh > 0) gs.SetShieldBar(sh, 10, 0);
								else gs.SetShieldBar(0, 0, 0);
							}
//var _t1=Common.GetTime();

//								if(ship.m_Owner==Server.Self.m_UserId) {}
//								else if(IsFriendEx(planet, ship.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) {}
//								//else if((GetRel(ship.m_Owner,Server.Self.m_UserId) & (Common.PactControl | Common.PactBuild))!=0);
//								else if(a_control || a_build) {}
//								else if(CalcRadarPower(planet, Server.Self.m_UserId)>=0) {}
//								else { str="-"; str2="-"; }
							//if (ship.m_Flag & Common.ShipFlagSiege) str = "[" + str + "]";
							if (ship.m_Flag & Common.ShipFlagPhantom) { str = "-" + ship.m_HP.toString() + "-"; str2 = null; }
							else {
								if (hidebar && str.length > 0) { str = "-"; str2 = null; }
								if (hidebar && str2 != null && str2.length > 0) { str = "-"; str2 = null; }
							}

							if (/*Common.IsLowOrbit(k)*/k>=planet.ShipOnPlanetLow && !(m_CurSectorX == x && m_CurSectorY == y && m_CurPlanetNum == i && m_CurShipNum == k)) { str = ""; str2 = null; }

							gs.SetCnt(str);
							gs.SetCnt2(str2, (ship.m_Flag & Common.ShipFlagPolar) != 0);

//var _t2=Common.GetTime();
							//if (!m_Set_Module) gs.SetPoints(0, "");
							//else
							if(ship.m_Type!=Common.ShipTypeTransport && !(m_CurSectorX==x && m_CurSectorY==y && m_CurPlanetNum==i && m_CurShipNum==k)) gs.SetPoints(0, "");
							else if(ship.m_CargoType!=0 && ship.m_Race!=Common.RaceKling) gs.SetPoints(ship.m_CargoType,"          "+BaseStr.FormatBigInt(ship.m_CargoCnt)+" ");
							else gs.SetPoints(0,"");

							if (Common.IsBase(ship.m_Type)) gs.SetFuel("");
							else if(ship.m_Flag & Common.ShipFlagPhantom) gs.SetFuel("");
							else if ((IsEdit() || AccessControl(ship.m_Owner)) && m_CurSectorX == x && m_CurSectorY == y && m_CurPlanetNum == i && m_CurShipNum == k) gs.SetFuel(Math.floor(ship.m_Fuel / Common.FuelFlyOne).toString());
							else gs.SetFuel("");

							if (/*Common.IsLowOrbit(k)*/k>=planet.ShipOnPlanetLow && !(m_CurSectorX == x && m_CurSectorY == y && m_CurPlanetNum == i && m_CurShipNum == k)) {
								gs.SetItemType(0);
								gs.SetItemCnt("");
							} else {
								gs.SetItemType(ship.m_ItemType);
								if(ship.m_ItemType!=Common.ItemTypeNone && m_CurSectorX==x && m_CurSectorY==y && m_CurPlanetNum==i && m_CurShipNum==k) gs.SetItemCnt(ship.m_ItemCnt.toString());
								else gs.SetItemCnt("");
							}

							//if(ship.m_Owner==m_UserId) gs.SetColor(0x0000ff);
							//else gs.SetColor(0x404040);

if(ship.m_Owner == 2147483650) {
	trace(1);
}
							gs.SetColor(ColorByOwner(planet,ship.m_Owner));
//var _t3=Common.GetTime();

							var pb:Number;
							if(ship.m_Flag & Common.ShipFlagBomb) {
								if (ship.m_Type == Common.ShipTypeDevastator && ship.m_Race == Common.RaceGrantar) pb = Common.DevastatorBombTimeGrantar * 1000;
								else if (ship.m_Type == Common.ShipTypeDevastator) pb = Common.DevastatorBombTime * 1000;
								else if (ship.m_Owner == 0 || (ship.m_Owner & Common.OwnerAI) != 0) pb = (60 * 2) * 1000;
								else if ((m_CotlType == Common.CotlTypeRich || m_CotlType == Common.CotlTypeProtect) && (m_OpsFlag & Common.OpsFlagEnclave) == 0) pb = (60 * 5) * 1000;
								else if (m_CotlType == Common.CotlTypeUser) pb = 1000 * 60 * 60 * 2;
								else pb = (60 * 5) * 1000;
								pb = 100 * (m_ServerCalcTime - (ship.m_BattleTimeLock - pb)) / pb;
								if (pb <= 5) pb = 5;
								else if (pb > 100) pb = 100;
								gs.SetBuildState(Math.round(pb), 0xff0000);

							} else if(ship.m_Flag & Common.ShipFlagPortal) {
								pb=Common.ShipPortalTime*1000;
								if(Common.IsBase(ship.m_Type)) pb=Common.StationPortalTime*1000;
								if(planet.m_PortalCnt>0) pb=Common.FlagshipPortalTime*1000;
								//trace("time:",GetServerTime()-(ship.m_BattleTimeLock-pb),"period:",pb);
								pb=100*(m_ServerCalcTime-(ship.m_BattleTimeLock-pb))/pb;
								if(pb<=5) pb=5;
								else if(pb>100) pb=100;
								gs.SetBuildState(Math.round(pb),0x0000ff);

							} else if(ship.m_Flag & Common.ShipFlagEject) {
								pb = Common.EjectTime * 1000;
								pb = 100 * (m_ServerCalcTime-(ship.m_BattleTimeLock - pb)) / pb;
								if (pb <= 5) pb = 5;
								else if (pb > 100) pb = 100;
								gs.SetBuildState(Math.round(pb), 0xff00ff);

							} else if(ship.m_Flag & Common.ShipFlagBuild) {
								pb = CalcBuildTime(planet, ship.m_Owner, ship.m_Id, ship.m_Type, ship.m_Cnt) * 1000;
								for(j=0;j<Common.ShipOnPlanetMax;j++) {
									if(j==k) continue;
									ship2=planet.m_Ship[j];
									if(ship2.m_Type==Common.ShipTypeNone) continue;
									if(ship2.m_Owner!=ship.m_Owner) continue;
									if(!(ship2.m_Flag & Common.ShipFlagBuild)) continue;

									pb+=CalcBuildTime(planet,ship2.m_Owner,ship2.m_Id,ship2.m_Type,ship2.m_Cnt)*1000;
								}
								if(ship.m_Owner==0) pb=Common.NeutralBuildTime*1000;
								//trace("time:",GetServerTime()-(ship.m_BattleTimeLock-pb),"period:",pb);
								pb=100*(m_ServerCalcTime-(ship.m_BattleTimeLock-pb))/pb;
								if(pb<=5) pb=5;
								else if(pb>100) pb=100;
								gs.SetBuildState(Math.round(pb));

							} else {
								gs.SetBuildState(0);
							}
//var _t4=Common.GetTime();

							if(ship.m_Flag & Common.ShipFlagStabilizer) gs.SetEffect(1);
							else gs.SetEffect(0);

							gs.SetInvu((ship.m_Flag & (Common.ShipFlagInvu | Common.ShipFlagInvu2))!=0);

							if(isedit || a_control) {
								gs.SetAIRoute((ship.m_Flag & Common.ShipFlagAIRoute)!=0);
								gs.SetAIAttack((ship.m_Flag & Common.ShipFlagAIAttack)!=0);
							} else {
								gs.SetAIRoute(false);
								gs.SetAIAttack(false);
							}

//var _t5=Common.GetTime();
/*								var st:int=StealthType(planet,ship,Server.Self.m_UserId);
							if(st==2) gs.SetStealth(st,1.0);
							else {
								var alphavis:Number=1.0;
								var isvisfrom:Boolean=isvis;
								while(true) {
									if(ship.m_ArrivalTime<=servertime) break;
									if(ship.m_FromSectorX==x && ship.m_FromSectorY==y && ship.m_FromPlanet==i) break;
									if((ship.m_Flag & Common.ShipFlagExchange)!=0) break;
									planet2=GetPlanet(ship.m_FromSectorX,ship.m_FromSectorY,ship.m_FromPlanet);
									if(!planet2) break;
									isvisfrom=IsVis(planet2);
									if(isvis==isvisfrom) break;
									
									var flytime:Number=CalcFlyTimeEx(CalcSpeed(ship.m_Owner,ship.m_Id,ship.m_Type),planet.m_PosX,planet.m_PosY,planet2.m_PosX,planet2.m_PosY)*1000;

									alphavis=(ship.m_ArrivalTime-servertime)/flytime;
									if(isvis) alphavis=1.0-alphavis; 
									if(alphavis<0.0) alphavis=0.0;
									else if(alphavis>1.0) alphavis=1.0;
									break;
								}
								
								if(isvis==isvisfrom) {
									if(isvis) gs.SetStealth(st,1.0);
									else gs.SetStealth(2,1.0);
								} else {
									gs.SetStealth(st,alphavis);
								}
								
							}*/
							if (!isvis) gs.SetStealth( -1, dt);
							else if (ship.m_Flag & Common.ShipFlagPhantom) gs.SetStealth(1, dt);
							else gs.SetStealth(StealthType(planet,ship,Server.Self.m_UserId),dt);

							gs.CalcPos();
//var _t6=Common.GetTime();
							gs.Update(isvis);
//var _t7=Common.GetTime();
//t1+=_t1-_t0;
//t2+=_t2-_t1;
//t3+=_t3-_t2;
//t4+=_t4-_t3;
//t5+=_t5-_t4;
//t6+=_t6-_t5;
//t7+=_t7-_t6;
						}
					}
				}
			}
		}

//var ta1:Number=Common.GetTime();			
		for(i=m_ShipList.length-1;i>=0;i--) {
			gs=m_ShipList[i];
			if(gs.m_Tmp==0) {
//if(gs.m_Type==Common.ShipTypeTransport) trace("Transport graph delete");
//if(gs.m_Owner) trace("Ship graph delete ",gs.m_Owner,gs.m_Id);
				gs.Clear();
				m_ShipList.splice(i,1);
			}
		}
//var ta2:Number=Common.GetTime();			
//m_FormHint.Show(
//	t1.toString()+
//	" "+t2.toString()+
//	" "+t3.toString()+
//	" "+t4.toString()+
//	" "+t5.toString()+
//	" "+t6.toString()+
//	" "+t7.toString()+
///	" All:"+(ta1-ta0).toString()+" "+(ta2-ta1).toString(),Common.WarningHideTime);
	}
	
	public function GraphClear():void
	{
		var i:int;
		var gs:GraphShip;

		for(i=m_ShipList.length-1;i>=0;i--) {
			gs=m_ShipList[i];
			gs.Clear();
			m_ShipList.splice(i,1);
		}
	}
	
	public function ItemUpdate():void
	{
		var i:int,u:int,k:int,x:int,y:int;
		var sec:Sector;
		var planet:Planet;
		var ship:Ship;
		var gi:GraphItem;

		for(i=0;i<m_ItemList.length;i++) {
			gi=m_ItemList[i];
			gi.m_Tmp=0;
		}

		if(m_StateConnect>=1 && !HS.visible && m_Set_Item) {
//				var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize)-1);
//				var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize)-1);
//				var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+2);
//				var ey:int=Math.min(m_SectorMinY+m_SectorCntY,Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize)+2);
			if (!PickWorldCoord(0, 0, m_TV0)) return;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) continue;
					sec=m_Sector[i];
					if(sec.m_Off) continue;

					for(i=0;i<sec.m_Planet.length;i++) {
						planet=sec.m_Planet[i];

						if(!planet.m_Vis) continue;

						for(k=0;k<Common.ShipOnPlanetMax;k++) {
							ship=planet.m_Ship[k];
							if(ship.m_OrbitItemType==Common.ItemTypeNone) continue;
							//if(ship.m_Type!=Common.ShipTypeNone) continue;
							
							if(ship.m_OrbitItemType==Common.ItemTypeMine && !IsShowMine(k,ship,planet,Server.Self.m_UserId)) continue;

							for(u=0;u<m_ItemList.length;u++) {
								gi=m_ItemList[u];

								if(gi.m_SectorX==x && gi.m_SectorY==y && gi.m_PlanetNum==i && gi.m_ShipNum==k) break;
							}
							if(u>=m_ItemList.length) {
								gi=new GraphItem(this);
								gi.m_SectorX=x;
								gi.m_SectorY=y;
								gi.m_PlanetNum=i;
								gi.m_ShipNum=k;
								m_ItemList.push(gi);
							}
							gi.m_Tmp=1;
							gi.SetType(ship.m_OrbitItemType);
							gi.SetCnt(ship.m_OrbitItemCnt.toString());
							gi.SetColor(0xffff00);
							gi.Update();
						}
					}
				}
			}
		}

		for(i=m_ItemList.length-1;i>=0;i--) {
			gi=m_ItemList[i];
			if(gi.m_Tmp==0) {
				gi.Clear();
				m_ItemList.splice(i,1);
			}
		}
	}

	public function BulletAdd():GraphBullet
	{
		var gb:GraphBullet=new GraphBullet(this);
		m_BulletList.push(gb);
		gb.m_BeginTime=Common.GetTime();
		gb.m_EndTime=gb.m_BeginTime+1000;
		gb.m_FromX=0;
		gb.m_FromY=0;
		gb.m_ToX=100;
		gb.m_ToY=100;
		return gb;
	}

	public function BulletUpdate():void
	{
		var i:int;
		
		if(!m_Set_Bullet) {
			BulletClear();
			return;
		}

		for (i = m_BulletList.length - 1; i >= 0; i--) {
			var gb:GraphBullet = m_BulletList[i];
			if(!gb.Update()) {
				m_BulletList.splice(i,1);
			}
		}
	}
	
	public function BulletClear():void
	{
		//var i:int;
		//for (i = m_BulletList.length - 1; i >= 0; i--) {
		//	var gb:GraphBullet=m_BulletList[i];
		//	m_BulletList.splice(i, 1);
		//}
		m_BulletList.length = 0;
	}
	
	public function ExplosionUpdate():void
	{
		var i:int,u:int,k:int,x:int,y:int;
		var sec:Sector;
		var planet:Planet;
		var ship:Ship;
		var gs:GraphShip;
		var dobj:DisplayObject;
		var ge:GraphExplosion;
		var ar:Array;

		if(m_StateConnect>=1 && !HS.visible && m_Set_Explosion) {
//				var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize));
//				var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize));
//				var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+1);
//				var ey:int=Math.min(m_SectorMinY+m_SectorCntY,Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize)+1);
			if (!PickWorldCoord(0, 0, m_TV0)) return;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) continue;
					sec=m_Sector[i];

					for(i=0;i<sec.m_Planet.length;i++) {
						planet=sec.m_Planet[i];
						
						if (!planet.m_Vis) continue;
						
						for (k = 0; k < planet.m_BtlEvent.length; k++) {
							var e:BtlEvent = planet.m_BtlEvent[k];
							if (e.m_Type != BtlEvent.TypeExplosion) continue;

							for (u = 0; u < m_ExplosionList.length; u++) {
								ge=m_ExplosionList[u];
								if (ge.m_SectorX == x && ge.m_SectorY == y && ge.m_PlanetNum == i && ge.m_PlaceNum == e.m_Slot && ge.m_Id == e.m_Id) break;
							}
							if (u < m_ExplosionList.length) continue;

//trace("Explosion 01");
							if(e.m_Id==0) {}
							else if(e.m_Slot!=100) {
								gs=GetGraphShip(x,y,i,e.m_Slot);
								if (gs == null) continue;
								if (gs.m_Id != e.m_Id) continue;
							}

							ge=new GraphExplosion(this,e.m_Slot == 100);
							ge.m_SectorX=x; ge.m_SectorY=y;
							ge.m_PlanetNum=i;
							ge.m_PlaceNum = e.m_Slot;
							ge.m_Id = e.m_Id;
							ge.m_DestroyTime = e.m_Time;
							if (e.m_Id == 0) {
								CalcShipPlaceEx(planet, e.m_Slot, m_TPos);
								ge.m_CenterX = m_TPos.x;
								ge.m_CenterY = m_TPos.y;
							}
							else if (e.m_Slot == 100) { ge.m_CenterX = planet.m_PosX; ge.m_CenterY = planet.m_PosY; }
							else { ge.m_CenterX = gs.m_PosX; ge.m_CenterY = gs.m_PosY; }
							m_ExplosionList.push(ge);
						}

/*							for(k=0;k<Common.ShipOnPlanetMax;k++) {
							ship=planet.m_Ship[k];

							//if(ship.m_DestroyTime+8000<=GetServerTime()) continue;
							continue;
//trace("Explosion 00");

							for(u=0;u<m_ExplosionLayer.numChildren;u++) {
								dobj=m_ExplosionLayer.getChildAt(u);
								ge=dobj as GraphExplosion;
								if(ge.m_SectorX==x && ge.m_SectorY==y && ge.m_PlanetNum==i && ge.m_PlaceNum==k && ge.m_DestroyTime==ship.m_DestroyTime) break;
							}
							if(u<m_ExplosionLayer.numChildren) continue;

//trace("Explosion 01");
							gs=GetGraphShip(x,y,i,k);
							if(gs==null) continue;

							ge=new GraphExplosion(this);
							ge.m_SectorX=x; ge.m_SectorY=y;
							ge.m_PlanetNum=i;
							ge.m_PlaceNum=k;
							//ge.m_DestroyTime=ship.m_DestroyTime;
							ge.m_CenterX=gs.m_PosX; ge.m_CenterY=gs.m_PosY;
							m_ExplosionLayer.addChild(ge);
						}*/
					}
				}
			}
		}

		for(i=m_ExplosionList.length-1;i>=0;i--) {
			ge = m_ExplosionList[i];

			if (ge.m_DestroyTime + 9000 <= m_ServerCalcTime) {
				ge.Clear();
				m_ExplosionList.splice(i, 1);
			} else {
				ge.Update();
			}
		}
	}
	
	public function TeamType():int // -1-no access 0-atk 1-def
	{
		if (m_CotlType != Common.CotlTypeCombat) return -1;
		var u:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (u == null) return -1;
		if (u.m_Team < 0) return -1;
		if (u.m_Team == m_OpsTeamEnemy) return 0;
		else if (u.m_Team == m_OpsTeamOwner) return 1;
		return -1;
	}
	
	public function ShipPlaceUpdate():void
	{
		var i:int,u:int,t:int;
		var gsp:GraphShipPlace;
		var planet:Planet, planet2:Planet;
		var ship:Ship, ship2:Ship;
		var tt:int;

		for (i = 0; i < m_ShipPlaceList.length; i++) {
			gsp = m_ShipPlaceList[i];
			gsp.m_Tmp = 0;
		}

		while(true) {
			if (m_Action == ActionMove && m_CurPlanetNum >= 0) {
				planet = GetPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);
				if (planet == null) break;
				if (m_MoveShipNum<0 || m_MoveShipNum>=Common.ShipOnPlanetMax) break;
				ship = planet.m_Ship[m_MoveShipNum];

				planet2 = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
				if (planet2 == null) break;

				while((ship!=null) && (!(ship.m_Flag & (Common.ShipFlagBomb)))) {

					if((ship.m_Flag & Common.ShipFlagBuild)!=0 && (m_MoveSectorX!=m_CurSectorX || m_MoveSectorY!=m_CurSectorY || m_MovePlanetNum!=m_CurPlanetNum)) break;

					if (m_MoveSectorX != m_CurSectorX || m_MoveSectorY != m_CurSectorY || m_MovePlanetNum != m_CurPlanetNum || m_MoveShipNum != m_CurShipNum) { }
					else if (m_ShipPlaceCooldown + 200 > Common.GetTime()) break;

					for (u = 0; u < Common.ShipOnPlanetMax; u++) {
						if (u >= planet2.ShipOnPlanetLow) {
							if ((planet2.m_Flag & Planet.PlanetFlagWormhole) != 0) continue;
							if (!Common.ShipLowOrbit[ship.m_Type]) continue;
							if (!AccessLowOrbit(planet2, ship.m_Owner, ship.m_Race)) break;
						}
						if(!IsEdit() && !CalcTestMoveTo(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,u)) continue;
						ship2 = planet2.m_Ship[u];
						if (ship2.m_Type != Common.ShipTypeNone && ship2.m_ArrivalTime>m_ServerCalcTime) continue;

						for(i=0;i<m_ShipPlaceList.length;i++) {
							gsp = m_ShipPlaceList[i];
							if (gsp.m_SectorX == m_CurSectorX && gsp.m_SectorY == m_CurSectorY && gsp.m_PlanetNum == m_CurPlanetNum && gsp.m_ShipNum == u) break;
						}
						if(i>=m_ShipPlaceList.length) {
							gsp = new GraphShipPlace(this, m_CurSectorX, m_CurSectorY, m_CurPlanetNum, u);
							m_ShipPlaceList.push(gsp);
						}
						gsp.m_Tmp=1;
					}
					break;
				}
			} else if (m_FormFleetBar.m_SlotMove >= 0 && m_CurPlanetNum >= 0) {
				planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
				if (planet == null) break;
				tt = -1;
				if ((m_CotlType == Common.CotlTypeCombat) && (planet.m_Flag & Planet.PlanetFlagWormhole) != 0) tt = TeamType();

				var slot:FleetSlot = m_FormFleetBar.m_FleetSlot[m_FormFleetBar.m_SlotMove];

				for (u = 0; u < Common.ShipOnPlanetMax; u++) {
					if (u >= planet.ShipOnPlanetLow) {
						if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0) continue;
						if (!Common.ShipLowOrbit[slot.m_Type]) continue;
						if (!AccessLowOrbit(planet, Server.Self.m_UserId, Common.RaceNone)) continue;
					}

					ship = planet.m_Ship[u];
					if (ship.m_Type != Common.ShipTypeNone) continue;
					if (tt >= 0 && (u & 1) != tt) continue;

					for (i = 0; i < m_ShipPlaceList.length; i++) {
						gsp = m_ShipPlaceList[i];
						if (gsp.m_SectorX == m_CurSectorX && gsp.m_SectorY == m_CurSectorY && gsp.m_PlanetNum == m_CurPlanetNum && gsp.m_ShipNum == u) break;
					}
					if (i >= m_ShipPlaceList.length) {
						gsp = new GraphShipPlace(this, m_CurSectorX, m_CurSectorY, m_CurPlanetNum, u);
						m_ShipPlaceList.push(gsp);
					}
					gsp.m_Tmp=1;
				}
			}
			else if (m_Action == ActionSplit && m_MovePlanetNum >= 0) {
				planet = GetPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);
				if (planet == null) break;
				if (m_MoveShipNum<0 || m_MoveShipNum>=Common.ShipOnPlanetMax) break;
				ship = planet.m_Ship[m_MoveShipNum];
				var lo:Boolean = Common.ShipLowOrbit[ship.m_Type];
				if (lo && !AccessLowOrbit(planet, ship.m_Owner, ship.m_Race)) lo = false;

				if ((ship != null) && (!(ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb)))) {
					var srcshiptype:int = ship.m_Type;
					for (u = 0; u < Common.ShipOnPlanetMax; u++) {
						if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0 && /*Common.IsLowOrbit(u)*/ u>=planet.ShipOnPlanetLow) continue;
						ship=planet.m_Ship[u];
						if(ship.m_Type==Common.ShipTypeNone) {
							if(CntFriendGroup(planet,m_MoveOwner,Common.RaceNone)>=Common.GroupInPlanetMax) continue;
							if(srcshiptype!=Common.ShipTypeCorvette && IsRear(planet,u,m_MoveOwner,Common.RaceNone,true)) continue;
						} else {
							//if(ship.m_Owner!=Server.Self.m_UserId) continue;
							//if (IsFlyOtherPlanet(ship, planet)) continue;
							if (ship.m_ArrivalTime > m_ServerCalcTime) continue;
							if (srcshiptype != ship.m_Type) continue;
							if(!AccessControl(ship.m_Owner)) continue;
						}

						if (planet.m_Flag & Planet.PlanetFlagWormhole) {
							if (u >= planet.ShipOnPlanetLow)  continue;
							if ((m_MoveShipNum & 1) != (u & 1)) continue;
						}
						if ((u >= planet.ShipOnPlanetLow) && (!lo)) {
							continue;
						}

						for (i = 0; i < m_ShipPlaceList.length; i++) {
							gsp = m_ShipPlaceList[i];
							if (gsp.m_SectorX == m_MoveSectorX && gsp.m_SectorY == m_MoveSectorY && gsp.m_PlanetNum == m_MovePlanetNum && gsp.m_ShipNum == u) break;
						}
						if (i >= m_ShipPlaceList.length) {
							gsp = new GraphShipPlace(this, m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, u);
							m_ShipPlaceList.push(gsp);
						}
						gsp.m_Tmp=1;
					}
				}
			}
			break;
		}

		for (i = m_ShipPlaceList.length - 1; i >= 0; i--) {
			gsp = m_ShipPlaceList[i];

			if(gsp.m_Tmp==0) {
				gsp.Clear();
				m_ShipPlaceList.splice(i, 1);
			} else {
				gsp.Update();
			}
		}
	}
	
	public var m_JumpRadiusShow:Boolean = false;

	public function JumpRadiusUpdate():void
	{
		m_JumpRadiusShow = false;
		//m_GraphJumpRadius_PlanetNum=-1;

		while(m_Action==ActionMove || m_Action==ActionPlanet  || m_Action==ActionRoute || m_Action==ActionShowRadius || m_Action==ActionExchange || m_Action==ActionAntiGravitor || m_Action==ActionGravWell || m_Action==ActionBlackHole || m_Action==ActionTransition) {
			if(IsEdit()) {
				if(m_Action==ActionMove) break;
			}
			if ((m_MoveSectorX != m_CurSectorX || m_MoveSectorY != m_CurSectorY || m_MovePlanetNum != m_CurPlanetNum) || (m_Action == ActionAntiGravitor || m_Action == ActionGravWell || m_Action == ActionBlackHole)) {
				m_JumpRadiusShow = true;
//					m_GraphJumpRadius.m_SectorX=m_MoveSectorX;
//					m_GraphJumpRadius.m_SectorY=m_MoveSectorY;
//					m_GraphJumpRadius.m_PlanetNum=m_MovePlanetNum;
			}
			break;
		} 
//			m_GraphJumpRadius.Update();
	}

	public function FormTimerUpdate():void
	{
		var cotl:SpaceCotl;
		var v:Number;
		var s:String = "";
		
		var showinhyper:Boolean = false;

		if(m_EmpireLifeTime!=0 && m_UserPlanetCnt>0) {
			v = (m_UserEmpireCreateTime + m_EmpireLifeTime * 1000 - GetServerGlobalTime()) / 1000;
			if (v < 60 * 60) s += "<font color='#1dfd7c'>" + Common.Txt.EmpireDestroyTime + ": " + Common.FormatPeriod(v).toString() + "</color>\n";
		}

		while ((m_CotlType == Common.CotlTypeProtect) && (m_SessionPeriod > 0)) {
			var ra:Array=GameStateLeftTime();

			if(ra[0]==0 && ra[1]<60*60) s+="<font color='#1dfd7c'>"+Common.Txt.SessionEnd+": "+Common.FormatPeriod(ra[1]).toString()+"</color>\n";
			else if(ra[0]!=0) {
				s=Common.Hint.WaitBeginGame;
				s=s.replace(/<Val>/g,Common.FormatPeriod(ra[1]));
				s="<font color='#1dfd7c'>"+s+"</color>\n";
			}
			
/*				
//				m_SessionStart=15*60*60;
//				m_SessionPeriod=5*60*60;

			var sd:Date=GetServerDate();
			var st:int=sd.hours*60*60+sd.minutes*60+sd.seconds;

			//var start_minute:int=m_SessionStart % (60*60);
			//var end_minute:int=(start_minute+(m_SessionPeriod % (60*60))) % (60*60);
			var hour_period:int=Math.floor(m_SessionPeriod/(60*60));
			if((m_SessionPeriod % (60*60))!=0) hour_period++;
			//if(start_minute>=end_minute) hour_period++;

			var t:int=st-m_SessionStart;
			if(t<0) t=24*60*60-m_SessionStart+st;
			if(t<0) throw Error("");

//trace("m_SessionPeriod="+m_SessionPeriod.toString()+" st="+st.toString()+" start_minute="+start_minute.toString()+" hour_period="+hour_period.toString()+" t="+t.toString()+" tafter="+(t % (hour_period*60*60)).toString());
			t=t % (hour_period*60*60);

			if(t<m_SessionPeriod) {
				s+="<font color='#1dfd7c'>"+Common.Txt.SessionEnd+": "+Common.FormatPeriod(m_SessionPeriod-t).toString()+"</color>\n";
				break;
			} else {
//trace((hour_period-1)*60*60+start_minute,t);
				s+="<font color='#1dfd7c'>"+Common.Txt.SessionBegin+": "+Common.FormatPeriod((hour_period*60*60)-t).toString()+"</color>\n";
				break;
			}*/

			break;
		}

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if (user != null && user.m_ExitDate != 0) {
			showinhyper = true;
			s = "<font color='#1dfd7c'>" + Common.Txt.ExitDate + ": " + Common.FormatPeriod((user.m_ExitDate-GetServerGlobalTime()) / 1000) + "</font>";
			
			if (user.m_ExitDate < GetServerGlobalTime()) {
				m_FormHint.Show(Common.Txt.ExitBegin);
				Server.Self.ConnectClose();
				m_FormEnter.visible=false;
				return;
			}
		}
		if(m_CotlType==Common.CotlTypeUser && m_CotlOwnerId!=Server.Self.m_UserId) {
			user=UserList.Self.GetUser(m_CotlOwnerId);
			if (user != null && user.m_ExitDate != 0) {
				if (!HS.visible) s = "<font color='#1dfd7c'>" + Common.Txt.ExitDate + ": " + Common.FormatPeriod((user.m_ExitDate-GetServerGlobalTime()) / 1000) + "</font>";

				if (user.m_ExitDate < GetServerGlobalTime()) {
					if(m_HomeworldPlanetNum>=0) {
						GoTo(false,m_HomeworldCotlId,m_HomeworldSectorX,m_HomeworldSectorY,m_HomeworldPlanetNum);
//						} else if(m_CitadelNum>=0) {
//							GoTo(false,m_CitadelCotlId,m_CitadelSectorX,m_CitadelSectorY,m_CitadelNum);
					} else {
						//ChangeCotlServerSimple(m_RootCotlId);
						GoTo(false, m_RootCotlId);
					}
				}
			}
		}

		if((m_CotlType==Common.CotlTypeProtect) && !IsEdit() && m_GameTime!=0) {
			v = (m_GameTime * 1000 - m_ServerCalcTime) / 1000;
			s+="<font color='#1dfd7c'>"+Common.Txt.RestartTime+": "+Common.FormatPeriod(v).toString()+"</color>\n";

			if(v<=0) {
				m_GameState=0;
				m_GameTime=0;
				GoRootCotl();
			}
		}

		if ((m_CotlType == Common.CotlTypeCombat) && (!IsEdit()) && (m_GameState & Common.GameStateEnd) != 0) {
			s = "<font color='#1dfd7c'>";
			if (m_AtkScore >= m_OpsWinScore) s += Common.Txt.FormCombatWinAtk;
			else s += Common.Txt.FormCombatWinDef;
			v = (1000 * Number(m_GameTime) - m_ServerCalcTime);
			s += " " + Common.Txt.FormCombatTimeEnd +": " +Common.FormatPeriodLong(v / 1000) + "</color>\n";

			if (m_FormCombat.m_ShowAfterEnd) {
				m_FormCombat.m_ShowAfterEnd = false;
				m_FormCombat.ShowEx(m_CotlUnionId);
			}
			//if ((!m_FormCombat.visible) && (m_CombatId != 0) && (m_FormCombat.m_CombatCotlId == Server.Self.m_CotlId) && m_FormCombat.m_ShowAfterEnd) {
			//	m_FormCombat.m_ShowAfterEnd = false;
			//	m_FormCombat.Show();
			//}

			if ((v < 0) && (m_GoCotlId == 0)) {
				GoRootCotl();
			}

		} else if ((m_CotlType == Common.CotlTypeCombat) && (!IsEdit()) && (m_GameState & Common.GameStatePlacing) != 0  && (m_GameState & Common.GameStateEnd) == 0) {
			v = (1000 * Number(m_GameTime) - m_ServerCalcTime);

			if (!m_ShowWelcome) {
				m_ShowWelcome = true;
				s = Common.Txt.FormCombatMsgBegin;
				s = BaseStr.Replace(s, "<Val>", "[clr]" + Common.FormatPeriodLong(v / 1000) + "[/clr]");
				m_FormHint.Show(s, 20000);
			}

			s = "<font color='#1dfd7c'>" + Common.Txt.FormCombatTimePlacing + "</color>\n";
			s = BaseStr.Replace(s, "<Val>", Common.FormatPeriodLong(v / 1000));
			//s += Common.Txt.FormCombatTimePlacing +": " +Common.FormatPeriodLong(v / 1000) + "</color>\n";
			
		} else if (m_CotlType == Common.CotlTypeCombat && (!IsEdit()) && (m_OpsWinScore > 0)) {
			s = "<font color='#1dfd7c'>";
			s += Common.Txt.FormCombatAtk + ": " + Math.floor(100 * (m_AtkScore / m_OpsWinScore)).toString() + "%";
			s += "   " + Common.Txt.FormCombatDef + ": " + Math.floor(100 * (m_DefScore / m_OpsWinScore)).toString() + "%";
			s += "</color>\n";

		} else if (IsWinMaxEnclave()) {
			s = "<font color='#1dfd7c'>";
			if (m_BasePlanetCnt <= 0 || m_AllPlanetCnt <= 0) s += BaseStr.Replace(Common.Txt.MaxEnclaveTarget,"<Val>",m_OpsWinScore.toString());
			else s += Common.Txt.DistrictPlanetCnt + ": " + m_BasePlanetCnt.toString() + " (" + Math.floor((m_BasePlanetCnt * 100.0) / m_AllPlanetCnt).toString() + "%).";

			cotl = HS.GetCotl(Server.Self.m_CotlId);
			if (cotl != null && cotl.m_ProtectTime > GetServerGlobalTime()) {
				s += " " + Common.Txt.CotlProtect + ": " + Common.FormatPeriodLong((cotl.m_ProtectTime-GetServerGlobalTime()) / 1000);

			} else if((m_GameState & Common.GameStateBegin)!=0) {
				v = (1000 * Number(m_GameTime + m_OpsRestartCooldown * 60) - m_ServerCalcTime);
				//if (v < (60 * 60 * 1000)) 
				s += " " + Common.Txt.MaxEnclaveTime + ": " + Common.FormatPeriodLong(v / 1000);
			}

			s += "</color>\n";

		} else if (IsWinOccupyHomeworld()) {
			cotl = HS.GetCotl(Server.Self.m_CotlId);
			if (cotl != null && cotl.m_ProtectTime > GetServerGlobalTime()) {
				s = "<font color='#1dfd7c'>";
				s += " " + Common.Txt.CotlProtect + ": " + Common.FormatPeriodLong((cotl.m_ProtectTime-GetServerGlobalTime()) / 1000);
				s += "</color>\n";

			} else if (1000 * Number(m_GameTime) > m_ServerCalcTime) {
				s = "<font color='#1dfd7c'>";
				s += " " + Common.Txt.OccupyHomeworldTime + ": " + Common.FormatPeriodLong((1000 * Number(m_GameTime) - m_ServerCalcTime) / 1000);
				s += "</color>\n";
			}
		}

		if(HS.visible) {
			if(showinhyper && s.length>0) m_FormTime.Show(s);
			else m_FormTime.Hide();
		} else {
			if(s.length>0) m_FormTime.Show(s);
			else m_FormTime.Hide();
			
		}
	}
	
	public function ChatHelloUpdate():void
	{
		if(m_UnionId==0) return;
		var uni:Union=UserList.Self.GetUnion(m_UnionId);
		if(uni==null) return;

		if(m_UnionHelloPrint==uni.m_Hello) return;

		var chid:uint=m_FormChat.ClanChannelId();
		if(chid==0) return;

		m_UnionHelloPrint=uni.m_Hello;

		if(m_UnionHelloPrint.length<=0) return;

		m_FormChat.AddChanelMsg(chid,m_UnionHelloPrint);
	}
	
	public function QuestTimeDrop():void
	{
		m_QuestTime = m_CurTime-490;
	}

	private var m_UpdateTime:Number=0;
	private var m_QuestTime:Number = 0;
	//private var m_UpdateTimeVis:Number=0;
	public function Update():void
	{
		if (!C3D.IsReady()) return;

		var curtime:Number = m_CurTime;// Common.GetTime();
		if(m_UpdateTime+(m_FPS_UpdatePeriod>>1)>curtime) { /*trace("skip");*/ return; }
//trace(Common.GetTime()-m_UpdateTime);
		var dt:Number=curtime-m_UpdateTime;
		if(dt>1000) dt=1000;
		m_UpdateTime = curtime;
		
//trace("Update");

		m_FPSCalc++;
		if(m_FPSCalcTime+500<=Common.GetTime()) {
			m_FPS=m_FPSCalc*2;
			m_FPSCalc=0;
			m_FPSCalcTime=Common.GetTime();
		}

		if(test_text!=null) {
			test_text.text = m_FPS.toString() + " mmc:" + event_mousemove_cnt.toString() + " tmc" + event_touchmove_cnt.toString();
		}

		if (IsConnect()) {
			if (StateEnterCotl()) { m_QuestTime = m_CurTime; }
			else {
				if (m_QuestTime == 0) m_QuestTime = m_CurTime;
				if ((m_QuestTime + 500) < m_CurTime) {
					m_QuestTime = m_CurTime;
					QEManager.Process(QEManager.FromTakt);
				}
			}
		}

		//C3D.FrameBegin(false);
		C3D.FrameBegin(true);

		m_GetRel_owner1=0;
		m_GetRel_owner2=0;
		m_GetRel_res=0;

		m_IsFriendHome_homeowner=0;
		m_IsFriendHome_owner2=0;
		m_IsFriendHome_res=false;

		m_IsFriendEx_pown=0;
		m_IsFriendEx_owner1=0;
		m_IsFriendEx_owner2=0;
		m_IsFriendEx_res=false;

		m_IsVis_Planet=null;
		m_IsVis_ret=false;

		//if (m_Set_3D && !HS.visible) {
		//	if (C3D.Context == null) return;
		//	C3D.FrameBegin();
		//}

		//m_BG.visible = !HS.visible;

		if(!IsSpaceOff()) {
			if(!IsEdit() && (m_Action==ActionPathMove || m_Action==ActionMove || m_Action==ActionExchange || m_Action==ActionConstructor || m_Action==ActionRecharge || m_Action==ActionPortal || m_Action==ActionLink || m_Action==ActionEject || m_Action==ActionWormhole || m_Action==ActionAntiGravitor || m_Action==ActionGravWell || m_Action==ActionBlackHole || m_Action==ActionTransition)) {
				var fromship:Ship=GetShip(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveShipNum);
				if(fromship!=null && (fromship.m_Type==Common.ShipTypeNone || !(m_MoveShipNum>=Common.ShipOnPlanetMax || AccessControl(fromship.m_Owner)))) {
					m_Action=ActionNone;
				}
			}

			SendAutoGive();

var t00:int = getTimer();
			ProcessAction();
var t01:int = getTimer();

			//Update();

			if (m_Hangar.visible) {
			} else if (HS.visible) {
				HS.Draw();
			} else {
				Draw();
			}

			if(!m_Set_FPSOn && !m_NetStatOn) {
				m_FPSLayer.visible=false;
			} else {
				m_FPSLayer.visible=true;
				var str:String = "FPS: " + m_FPS.toString();
				//if (!m_GraphShipImgs.m_SmoothOk && m_GraphShipImgs.m_ShipCalcTimer.running) str += "\nSSC: "+Math.round(m_GraphShipImgs.m_SmoothCalcNum*100/m_GraphShipImgs.m_SmoothCalc.length)+"%";
				if(m_NetStatOn) {
					str+="\nMemory: "+BaseStr.FormatBigInt(System.totalMemory);
					str+="\n"+Server.Self.CommandStatPrint();
				}
				m_FPSLayer.htmlText=str;
				m_FPSLayer.y=0;
				m_FPSLayer.x=(stage.stageWidth>>1)-(m_FPSLayer.width>>1);
			}

			//if (HS.visible) {
			//	m_BG.visible = false;
			//} else {
			//	m_BG.visible = true;
			//	m_BG.SetOffset(m_OffsetX, m_OffsetY);
			//}
var t02:int = getTimer();

			
//				if(m_UpdateTimeVis+1000<Common.GetTime()) {
//					m_UpdateTimeVis=Common.GetTime();
//					VisUpdate();
//				}
			PlanetUpdate();
var t03:int = getTimer();
			PathUpdate();
var t04:int = getTimer();
			ExplosionUpdate(); // Перед кораблями чтобы можно было найти какой корабль взорвался
var t05:int = getTimer();
			ItemUpdate();
var t06:int = getTimer();
			ShipUpdate(dt);
var t07:int = getTimer();
			BulletUpdate();
var t08:int = getTimer();
			ShipPlaceUpdate();
var t09:int = getTimer();
var t10:int = getTimer();
			if(m_FormFleetBar.m_SlotMove>=0) m_FormFleetBar.UpdateMove(); 
var t11:int = getTimer();
			JumpRadiusUpdate();
var t12:int = getTimer();
			FormTimerUpdate();
var t13:int = getTimer();
			UpdateGraphFind();
var t14:int = getTimer();

			ChatHelloUpdate();

//				if(m_MoveMap) {
//					m_FormMiniMap.Update();
//					SendLoadSector();
//				}

var t15:int = getTimer();
if((t15 - t00) > 50 && EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("!SLOW.EMU " + 
(t01 - t00).toString() 
+ " " + (t02 - t01).toString() 
+ " " + (t03 - t02).toString() 
+ " " + (t04 - t03).toString() 
+ " " + (t05 - t04).toString()
+ " " + (t06 - t05).toString()
+ " " + (t07 - t06).toString()
+ " " + (t08 - t07).toString()
+ " " + (t09 - t08).toString()
+ " " + (t10 - t09).toString()
+ " " + (t11 - t10).toString()
+ " " + (t12 - t11).toString()
+ " " + (t13 - t12).toString()
+ " " + (t14 - t13).toString()
+ " " + (t15 - t14).toString()
);

		}

		C3D.FrameEnd();

		//if (m_Set_3D && !HS.visible) C3D.FrameEnd();
	}

/*		private function DrawImg(bm:BitmapData, x:int, y:int):void
	{
		var m:Matrix=new Matrix();
		m.identity();
		m.translate(x-bm.width/2, y-bm.height/2);
		//graphics.draw(m_ImgPlanet,m);

		graphics.lineStyle(1,0x000099,0);
		graphics.beginBitmapFill(bm,m,true);
		graphics.drawRect(x-bm.width/2, y-bm.height/2, bm.width, bm.height);
		graphics.endFill();
	}*/

	static public var m_TWSPos:Vector3D = new Vector3D();

	public function WorldToScreenX(x:Number, y:Number):Number
	{
		//return x - m_OffsetX + (stage.stageWidth >> 1);
		m_TWSPos.x = x - (m_CamPos.x + m_CamSectorX * m_SectorSize);
		m_TWSPos.y = y - (m_CamPos.y + m_CamSectorY * m_SectorSize);
		WorldToScreen(m_TWSPos);
		return m_TWSPos.x;
	}

	public function WorldToScreenY(x:Number, y:Number):Number
	{
		//return y-m_OffsetY+(stage.stageHeight>>1);
		m_TWSPos.x = x - (m_CamPos.x + m_CamSectorX * m_SectorSize);
		m_TWSPos.y = y - (m_CamPos.y + m_CamSectorY * m_SectorSize);
		WorldToScreen(m_TWSPos);
		return m_TWSPos.y;
	}

//		public function ScreenToWorldX(x:Number):Number
//		{
//			return x+m_OffsetX-(stage.stageWidth>>1);
//		}

//		public function ScreenToWorldY(y:Number):Number
//		{
//			return y+m_OffsetY-(stage.stageHeight>>1);
//		}

	public function CalcPickEx(px:int, py:int, pickportal:Boolean):Array
	{
		var i:int,u:int,k:int,x:int,y:int;
		var tx:Number,ty:Number,r:Number,mr:Number;
		var sec:Sector;
		var ra:Array;

		PickWorldCoord(px, py, m_TPickPos);
		px = Math.round(m_TPickPos.x);// ScreenToWorldX(px);
		py = Math.round(m_TPickPos.y);// ScreenToWorldY(py);

		var secx:int=Math.floor(px/m_SectorSize);
		var secy:int=Math.floor(py/m_SectorSize);

		//if(m_FormMiniMap.IsMouseIn()) return [secx,secy,-1,-1];
		//if(m_FormChat.IsMouseIn()) return [secx,secy,-1,-1];
		if (m_FormDialog.IsMouseIn()) return [secx, secy, -1, -1];
		//if (m_FormPlanet.IsMouseIn()) return [secx, secy, -1, -1];
		if(m_FormHist.IsMouseIn()) return [secx,secy,-1,-1];
		if(m_FormInfoBar.IsMouseIn()) return [secx,secy,-1,-1];
		//if(m_FormCptBar.IsMouseIn()) return [secx,secy,-1,-1];
		//if (m_FormFleetBar.IsMouseIn()) return [secx, secy, -1, -1];
		//if (m_FormFleetItem.IsMouseIn()) return [secx, secy, -1, -1];

		var sx:int=Math.max(m_SectorMinX,secx-1);
		var sy:int=Math.max(m_SectorMinY,secy-1);
		var ex:int=Math.min(m_SectorMinX+m_SectorCntX,secx+2);
		var ey:int = Math.min(m_SectorMinY + m_SectorCntY, secy + 2);
		
		var special:int = 0;

		var ww:Number = Number(C3D.m_SizeY >> 1) / (m_FovHalfTan * EmpireMap.Self.m_CamDist);
		
		if(pickportal)
		for(i=0;i<m_PlanetList.length;i++) {
			var gp:GraphPlanet = m_PlanetList[i];
			if (gp.m_PortalState <= 0) continue;

//				tx = WorldToScreenX(gp.m_PosX, gp.m_PosY) - 60.0 * ww - px;
//				ty = EmpireMap.m_TWSPos.y - 60.0 * ww - py;
			tx = gp.m_PosX - 90.0 - px;
			ty = gp.m_PosY - 90.0 - py;

			//if ((tx * tx + ty * ty) > (50 * 50 * ww * ww)) continue;
			if ((tx * tx + ty * ty) > (40 * 40)) continue;
//trace(tx, ty, Math.sqrt(tx * tx + ty * ty));

			special = 1;
			planet = GetPlanet(gp.m_SectorX, gp.m_SectorY, gp.m_PlanetNum);
			if (planet == null) return [secx, secy, -1, -1, special];
			
			k=-1;
			for (u = 0; u < Common.ShipOnPlanetMax; u++) {
				CalcShipPlaceEx(planet, u, m_TPos);
				tx = px - m_TPos.x;
				ty = py - m_TPos.y;
				r = tx * tx + ty * ty;

				if(r<(30*30) && (k<0 || r<mr)) {
					k=u;
					mr=r;
				}
			}
			if(k>=0) {
				return [gp.m_SectorX, gp.m_SectorY, gp.m_PlanetNum, k, special];
			}
			
			return [gp.m_SectorX, gp.m_SectorY, gp.m_PlanetNum, -1, special];
		}

		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
				if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
				if(!(m_Sector[i] is Sector)) continue;
				sec=m_Sector[i];

				for(i=0;i<sec.m_Planet.length;i++) {
					var planet:Planet=sec.m_Planet[i];
					if(!planet.IsExist()) {
						if(!IsEdit()) continue;
					}
					//if(!IsVis(planet)) continue;
					tx=px-planet.m_PosX;
					ty=py-planet.m_PosY;
					r=tx*tx+ty*ty;

					if(r<(40*40)) {
						return [x, y, i, -1, special];

					} else if(r<(120*120)) {
						k=-1;
						for(u=0;u<Common.ShipOnPlanetMax;u++) {
							ra=CalcShipPlace(planet,u);
							tx=px-ra[0];
							ty=py-ra[1];
							r = tx * tx + ty * ty;

							if(r<(30*30) && (k<0 || r<mr)) {
								k=u;
								mr=r;
							}
						}
						if(k>=0) {
							return [x, y, i, k, special];
						}
					}
				}
			}
		}
		
		return [secx, secy, -1, -1, special];
	}
	
	public function CalcPick(x:int, y:int):void
	{
		var p:int,i:int,tt:int;
		var planet:Planet;
		var planet2:Planet;
		var ship:Ship;
		var ship2:Ship;
		var gsp:GraphShipPlace;

		m_CurPlanetNum=-1;
		m_CurShipNum = -1;
		m_CurSpecial = 0;

		var ra:Array = CalcPickEx(x, y, m_Action == ActionNone);
		m_CurSectorX=ra[0];
		m_CurSectorY=ra[1];
		var curplanet:int=ra[2];
		var curship:int = ra[3];
		var special:int = ra[4];

		var sr:int=0;
		
		var swh:Boolean=false;
		var spr:Boolean=false;

		var ww:Number = Number(C3D.m_SizeY >> 1) / (m_FovHalfTan * EmpireMap.Self.m_CamDist);

/*			if (curplanet < 0) {
			if(m_Action==ActionNone)
			for(i=0;i<m_PlanetList.length;i++) {
				var gp:GraphPlanet = m_PlanetList[i];
				if (gp.m_PortalState <= 0) continue;
				//if (gp.m_Portal == null) continue;

				//var tx:int = gp.x + gp.m_Portal.x + 36 - x;
				//var ty:int = gp.y + gp.m_Portal.y + 43 - y;

				var tx:Number = WorldToScreenX(gp.m_PosX, gp.m_PosY) - 60.0 * ww - x;
				var ty:Number = EmpireMap.m_TWSPos.y - 60.0 * ww - y;

				if ((tx * tx + ty * ty) > (50 * 50 * ww * ww)) continue;

				m_CurSectorX = gp.m_SectorX;
				m_CurSectorY = gp.m_SectorY;
				m_CurPlanetNum = gp.m_PlanetNum;
				m_CurSpecial = 1;
			}
		}*/
		
		while (special != 0 && curplanet >= 0 && curship >= 0 && m_Action == ActionNone) {
			planet = GetPlanet(m_CurSectorX, m_CurSectorY, curplanet);
			if (planet == null) break;
			ship = planet.m_Ship[curship];
			if (ship.m_Type == Common.ShipTypeNone) { curship = -1; break; }
			if (ship.m_ArrivalTime > m_ServerCalcTime) { curship = -1; break; }
			break;
		}
		if (special != 0 && curplanet >= 0 && curship < 0 && m_Action == ActionNone) {
			m_CurPlanetNum = curplanet;
			m_CurSpecial = special;
			spr = true;
		}
		else {
			while (true) {
				planet = GetPlanet(m_CurSectorX, m_CurSectorY, curplanet);
				if(planet==null) break;

				var isvis:Boolean = planet.m_Vis;

				if (curship < 0) {
					if (planet.m_Flag & (Planet.PlanetFlagWormholePrepare | Planet.PlanetFlagWormholeOpen | Planet.PlanetFlagWormholeClose)) swh = true;
//						if (planet.m_PortalPlanet > 0 && planet.m_PortalPlanet < 5) { spr = true; }
					
					if (m_Action == ActionMove) {
						if (m_MoveSectorX != m_CurSectorX || m_MoveSectorY != m_CurSectorY || m_MovePlanetNum != curplanet || m_MoveShipNum != curship) {
							if (!IsEdit() && !CalcTestMoveTo(m_CurSectorX, m_CurSectorY, curplanet, curship)) break;
						}
					}
					if(m_FormFleetBar.m_SlotMove>=0) {
						break;
					}
					if (m_Action == ActionAntiGravitor) {
						swh=false; spr=false;
						
						planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if(planet2==null) break;

						x=planet.m_PosX-planet2.m_PosX;
						y=planet.m_PosY-planet2.m_PosY;
						if((x*x+y*y)>JumpRadius2) break;
					}
					if(m_Action==ActionGravWell) {
						swh=false; spr=false;

						planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if(planet2==null) break;

						x=planet.m_PosX-planet2.m_PosX;
						y=planet.m_PosY-planet2.m_PosY;
						if((x*x+y*y)>JumpRadius2) break;
					}
					if (m_Action == ActionTransition) {
						swh = false; spr = false;

						break;
					}
					if(m_Action==ActionBlackHole) {
						if(m_MoveSectorX!=m_CurSectorX || m_MoveSectorY!=m_CurSectorY || m_MovePlanetNum!=curplanet) {
							planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
							if(planet2==null) break;

							x=planet.m_PosX-planet2.m_PosX;
							y=planet.m_PosY-planet2.m_PosY;
							if((x*x+y*y)>JumpRadius2) break;
						} else break;
					}
					if (m_Action == ActionConstructor) break;
					if (m_Action == ActionRecharge) break;
					if (m_Action == ActionSplit) break;
					if (m_Action == ActionPathMove) { }
					if (m_Action == ActionPortal) { }
					if (m_Action == ActionLink || m_Action == ActionEject) {
						if(curplanet<0) break;
						planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if (planet2 == null) break;

						ship = GetShip(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, m_MoveShipNum);
						if (ship == null) break;

						if (ship.m_Type == Common.ShipTypeSciBase) {
							if (EjectAccess(planet2, planet, ship.m_Owner, ship.m_Race) == 0) break;
						} else {
							x = planet.m_PosX - planet2.m_PosX;
							y = planet.m_PosY - planet2.m_PosY;
							if ((x * x + y * y) > JumpRadius2) break;
						}
					}
					if (m_Action == ActionWormhole) { }
					if (m_Action == ActionShowRadius) {
						if(m_MoveSectorX!=m_CurSectorX || m_MoveSectorY!=m_CurSectorY || m_MovePlanetNum!=curplanet) break;
					}
					if(m_Action==ActionPlanetMove) {
						//if(m_MoveSectorX!=m_CurSectorX || m_MoveSectorY!=m_CurSectorY || m_MovePlanetNum!=curplanet) break;
						if(curplanet<0) break;
					}
					if(m_Action==ActionPlanet) {
						//if(planet.m_Owner!=Server.Self.m_UserId) break;
/*							if(!IsEdit()) {
							if(!AccessBuild(planet.m_Owner)) break;
						}

						planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if(planet2==null) break;
						//if(planet2.m_Owner!=Server.Self.m_UserId) break;
						if(!IsEdit()) {
							if(!AccessBuild(planet2.m_Owner)) break;
						}*/
						if(curplanet<0) break;
						planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if(planet2==null) break;
						
						if(!RouteAccess(planet,Server.Self.m_UserId)) break;
						if(!planet.m_Vis) break;

						x=planet.m_PosX-planet2.m_PosX;
						y=planet.m_PosY-planet2.m_PosY;
						if((x*x+y*y)>JumpRadius2) break;
					}
					if(m_Action==ActionRoute) {
						if(curplanet<0) break;
						planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if(planet2==null) break;
						
						if(!RouteAccess(planet,Server.Self.m_UserId)) break;
						if(!planet.m_Vis) break;

						x=planet.m_PosX-planet2.m_PosX;
						y=planet.m_PosY-planet2.m_PosY;
						if((x*x+y*y)>JumpRadius2) break;
					}

					m_CurPlanetNum=curplanet;
					if(planet.m_Flag & Planet.PlanetFlagLarge) sr=35;
					else sr=30;
					m_GraphSelect.SetPos(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);

				} else {
					ship = planet.m_Ship[curship];

					if(IsEdit()) {}
					else if (ship.m_Type == Common.ShipTypeNone || ship.m_ArrivalTime > m_ServerCalcTime) {
						if (special != 0 && curplanet >= 0 && m_Action == ActionNone) {
							m_CurPlanetNum = curplanet;
							m_CurSpecial = special;
							break;
						}
					}
				
					if (curship >= planet.ShipOnPlanetLow && (planet.m_Flag & Planet.PlanetFlagWormhole) != 0) break;

					if(IsEdit()) {}
					else if (ship.m_Type != Common.ShipTypeNone && ship.m_ArrivalTime > m_ServerCalcTime) break;

					if(m_FormFleetBar.m_SlotMove>=0) {
						if (ship.m_Type != Common.ShipTypeNone) break;

						var slot:FleetSlot = m_FormFleetBar.m_FleetSlot[m_FormFleetBar.m_SlotMove];
						if (curship >= planet.ShipOnPlanetLow) {
							if (!Common.ShipLowOrbit[slot.m_Type]) break;
							if (!AccessLowOrbit(planet, Server.Self.m_UserId, Common.RaceNone)) break;
						}

						if (m_CotlType == Common.CotlTypeCombat && (planet.m_Flag & Planet.PlanetFlagWormhole) != 0) {
							tt = TeamType();
							if (tt >= 0 && tt != (curship & 1)) break;
						}

					} else if(m_Action==ActionNone) {
						//if(ship.m_Owner!=Server.Self.m_UserId) break;
						if(!isvis) break;
						if(!IsEdit()) {
							if (ship.m_Type == Common.ShipTypeNone) break;
							if ((curship < planet.ShipOnPlanetLow) && !AccessControl(ship.m_Owner)) break;
							if (StealthType(planet, ship, Server.Self.m_UserId) == 2) break;
						}

					} else if(m_Action==ActionMove) {
						if(m_MoveSectorX!=m_CurSectorX || m_MoveSectorY!=m_CurSectorY || m_MovePlanetNum!=curplanet || m_MoveShipNum!=curship) {
							if(!IsEdit() && !CalcTestMoveTo(m_CurSectorX,m_CurSectorY,curplanet,curship)) break;
						}

					} else if(m_Action==ActionAntiGravitor) {
						if(!isvis) break;
						break;
						
					} else if(m_Action==ActionGravWell) {
						if(!isvis) break;
						break;

					} else if(m_Action==ActionBlackHole) {
						planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if(planet2==null) break;

						x=planet.m_PosX-planet2.m_PosX;
						y=planet.m_PosY-planet2.m_PosY;
						if ((x * x + y * y) > JumpRadius2) break;

						if (ship.m_Type == Common.ShipTypeNone) break;
						if (ship.m_Type == Common.ShipTypeQuarkBase) break;

					} else if(m_Action==ActionExchange) {
						if(!isvis) break;
						break;

					} else if(m_Action==ActionTransition) {
						if (!isvis) break;
						
						planet2=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if(planet2==null) break;

						x=planet.m_PosX-planet2.m_PosX;
						y=planet.m_PosY-planet2.m_PosY;
						if ((x * x + y * y) > JumpRadius2) break;
						
						if (ship.m_Type == Common.ShipTypeFlagship) break;
						if (Common.IsBase(ship.m_Type)) break;
						
						ship2 = GetShip(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, m_MoveShipNum);
						if (ship2 == null) break;
						if (ship2.m_Type == Common.ShipTypeNone) break;
						
						if (!IsFriendEx(planet2, ship2.m_Owner, ship2.m_Race, ship.m_Owner, ship.m_Race)) break;

					} else if(m_Action==ActionConstructor) {
						if(!(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet)) break;
						if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet && m_MoveShipNum==curship) {}
						else {
							if(m_ActionShipNum==-1) {
								//if(ship.m_Owner!=m_MoveOwner) break;
								if (ship.m_Type == Common.ShipTypeFlagship) break;
								if (Common.IsBase(ship.m_Type)) break;
							} else {
								if ((ship.m_Type != Common.ShipTypeFlagship) && (ship.m_Type != Common.ShipTypeQuarkBase)) break;
							}
						}

					} else if(m_Action==ActionRecharge) {
						if(!(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet)) break;
						if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet && m_MoveShipNum==curship) {}
						else {
							if(ship.m_Owner!=m_MoveOwner) break;
							if ((ship.m_Type != Common.ShipTypeFlagship) && (ship.m_Type != Common.ShipTypeQuarkBase) && (ship.m_Race != Common.RaceTechnol)) break;
						}

					} else if(m_Action==ActionSplit) {
						if(!(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet)) break;
						if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet && m_MoveShipNum==curship) {}
						else if(!IsEdit() && !CalcTestMoveTo(m_CurSectorX,m_CurSectorY,curplanet,curship)) break;

					} else if(m_Action==ActionPathMove) {
						if(!(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet)) break;
						if(ship.m_Type==Common.ShipTypeNone || Common.IsBase(ship.m_Type)) break;
						//if(ship.m_Owner!=Server.Self.m_UserId) break;
						if(!AccessControl(ship.m_Owner)) break;

					} else if(m_Action==ActionPortal) {
						if(!(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet)) break;
						if(ship.m_Type==Common.ShipTypeNone || Common.IsBase(ship.m_Type)) break;
						//if(ship.m_Owner!=Server.Self.m_UserId) break;
						if(!AccessControl(ship.m_Owner)) break;

					} else if (m_Action == ActionLink || m_Action == ActionEject) {
						if (m_MoveSectorX != m_CurSectorX || m_MoveSectorY != m_CurSectorY || m_MovePlanetNum != curplanet || m_MoveShipNum != curship) break;
					
					} else if(m_Action==ActionWormhole) {
						if(!(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==curplanet)) break;
						if(ship.m_Type==Common.ShipTypeNone || Common.IsBase(ship.m_Type)) break;
						if (!AccessControl(ship.m_Owner)) break;

					} else if(m_Action==ActionShowRadius) {
						break;

					} else if(m_Action==ActionPlanetMove) {
						break;

					} else if (m_Action == ActionPlanet) {
						break;
/*							if(m_CurSectorX!=m_MoveSectorX || m_CurSectorY!=m_MoveSectorY || curplanet!=m_MovePlanetNum) break;

						if(IsEdit()) break;
						else if(ship.m_Type==Common.ShipTypeNone) {
							for(p=0;p<m_ShipPlaceLayer.numChildren;p++) {
								gsp=m_ShipPlaceLayer.getChildAt(p) as GraphShipPlace;
								if(gsp.m_SectorX==m_CurSectorX && gsp.m_SectorY==m_CurSectorY && gsp.m_PlanetNum==curplanet && gsp.m_ShipNum==curship) break;
							}
							if(p>=m_ShipPlaceLayer.numChildren) break;									
						} else {
							//if(ship.m_Owner!=Server.Self.m_UserId) break;
							if(!AccessBuild(ship.m_Owner)) break;
							if(ship.m_Cnt>=ShipMaxCnt(ship.m_Owner,ship.m_Type)) break;
							if(ShipCost(planet.m_Owner,ship.m_Id,ship.m_Type)>PlanetItemGet(planet.m_Owner,planet,Common.ItemTypeModule,true)) break;
						}*/

					} else if(m_Action==ActionRoute) {
						break;
					}
					m_CurPlanetNum=curplanet;
					m_CurShipNum=curship;
					sr=20;
					m_GraphSelect.SetPos(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
				}

				break;					
			}
		}

		m_GraphSelect.SetRadius(sr);
		
		if(m_FormMiniMap.m_ShowWormholePath!=swh || m_FormMiniMap.m_ShowPortalPath!=spr) m_FormMiniMap.Update();
	}

/*		public function CalcPickOld(x,y:int):void
	{
		x=ScreenToWorldX(x);
		y=ScreenToWorldY(y);

		m_CurSectorX=Math.floor(x/m_SectorSize);
		m_CurSectorY=Math.floor(y/m_SectorSize);
		m_CurPlanetNum=-1;
		m_CurShipNum=-1;

		var ship:Ship;
		var gsp:GraphShipPlace;

		var sr:int=0;

		while(m_CurSectorX>=m_SectorMinX && m_CurSectorX<m_SectorMinX+m_SectorCntX && m_CurSectorY>=m_SectorMinY && m_CurSectorY<m_SectorMinY+m_SectorCntY) {
			var i,u,k,p:int;
			var tx,ty,r,mr:Number;
			var ra:Array;
			var sec:Sector=GetSector(m_CurSectorX,m_CurSectorY);//m_Sector[i];
			if(sec==null) break;

			for(i=0;i<sec.m_Planet.length;i++) {
				var planet:Planet=sec.m_Planet[i];
				r=(x-planet.m_PosX)*(x-planet.m_PosX)+(y-planet.m_PosY)*(y-planet.m_PosY);
				if(r<(40*40)) {
					if(m_Action==ActionMove) break;
					if(m_Action==ActionPlanet) {
						if(planet.m_Owner!=Server.Self.m_UserId) break;
						
						var planet2:Planet=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
						if(planet2==null) break;
						if(planet2.m_Owner!=Server.Self.m_UserId) break;
						
						var x:int=planet.m_PosX-planet2.m_PosX;
						var y:int=planet.m_PosY-planet2.m_PosY;
						if((x*x+y*y)>JumpRadius2) break;
					}

					m_CurPlanetNum=i;
					if(planet.m_Flag & Planet.PlanetFlagLarge) sr=35;
					else sr=30;
					m_GraphSelect.SetPos(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);

					break;
				} else if(r<(120*120)) {
					k=-1;
					for(u=0;u<Common.ShipOnPlanetMax;u++) {
						ra=CalcShipPlace(planet,u);
						tx=x-ra[0];
						ty=y-ra[1];
						r=tx*tx+ty*ty
						
						if(r<(30*30) && (k<0 || r<mr)) {
							k=u;
							mr=r;
						}
					}
					while(k>=0) {
						ship=planet.m_Ship[k];
//trace(" Ship "+ship.m_Type+" Onwer="+ship.m_Owner);

						if(ship.m_ArrivalTime>GetServerTime()) break;

						if(m_Action==ActionNone) {
							if(ship.m_Type==Common.ShipTypeNone) break;
							if(ship.m_Owner!=Server.Self.m_UserId) break;
							
						} else if(m_Action==ActionMove) {
							if(!CalcTestMoveTo(m_CurSectorX,m_CurSectorY,i,k)) break;
							
						} else if(m_Action==ActionPlanet) {
							if(m_CurSectorX!=m_MoveSectorX || m_CurSectorY!=m_MoveSectorY || i!=m_MovePlanetNum) break;
							
							if(ship.m_Type==Common.ShipTypeNone) {
								for(p=0;p<m_ShipPlaceLayer.numChildren;p++) {
									gsp=m_ShipPlaceLayer.getChildAt(p) as GraphShipPlace;
									if(gsp.m_SectorX==m_CurSectorX && gsp.m_SectorY==m_CurSectorY && gsp.m_PlanetNum==i && gsp.m_ShipNum==k) break;
								}
//trace(""+p+"/"+m_ShipPlaceLayer.numChildren);
								if(p>=m_ShipPlaceLayer.numChildren) break;									
							} else {
								if(ship.m_Owner!=Server.Self.m_UserId) break;
								if(ship.m_Cnt>=Common.ShipMaxCnt) break;
								if(Common.ShipCost[ship.m_Type]>planet.m_ConstructionPoint) break;
							}							
						}
						m_CurPlanetNum=i;
						m_CurShipNum=k;
						sr=20;
						m_GraphSelect.SetPos(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
						break;
					}

					break;
				}
			}
			break;	
		}

		m_GraphSelect.SetRadius(sr);
	}*/

	public function CalcPickGraph(x:int, y:int, shipexist:Boolean):Array
	{
		var ra:Array = CalcPickEx(x, y, true);
		
		var secx:int = ra[0];
		var secy:int = ra[1];
		var planetnum:int = ra[2];
		var shipnum:int = ra[3];
		var special:int = ra[4];

		var i:int;
		var ship:Ship;
		var planet:Planet;

//trace("!!!CalcPickGraph00", secx, secy, planetnum, shipnum, special);
		if(planetnum>=0) {
			if(shipnum<0) {
//trace("!!!CalcPickGraph01");
				return ra;
			} else {
				ship=GetShip(secx,secy,planetnum,shipnum);
				if (ship != null && ship.m_Type == Common.ShipTypeNone && ship.m_OrbitItemType != Common.ItemTypeNone) {
//trace("!!!CalcPickGraph02");
					return ra;
				}

				planet=GetPlanet(secx,secy,planetnum);
				if (!planet.m_Vis) {
//trace("!!!CalcPickGraph03");
					return [secx, secy, planetnum, -1, special];
				}
				if (StealthType(planet, ship, Server.Self.m_UserId) == 2) {
//trace("!!!CalcPickGraph04");
					return [secx, secy, planetnum, -1, special];
				}

				if (!shipexist) {
//trace("!!!CalcPickGraph05");
					//return ra;
					return [secx, secy, planetnum, -1, special];
					//return [secx, secy, -1, -1, 0];
				}

				if (ship != null && ship.m_Type != Common.ShipTypeNone && ship.m_ArrivalTime <= m_ServerCalcTime) {
//trace("!!!CalcPickGraph06");
					return ra;
//						return [secx, secy, -1, -1, 0];
				}
			}
		}

		if (!shipexist) return [secx, secy, planetnum, -1, special];

//trace(secx,secy,planetnum,shipnum);

//trace("!!!CalcPickGraph07");
		PickWorldCoord(x, y, m_TPickPos);
		x = Math.round(m_TPickPos.x);// ScreenToWorldX(x);
		y = Math.round(m_TPickPos.y);// ScreenToWorldY(y);

		for(i=0;i<m_ShipList.length;i++) {
			var gs:GraphShip=m_ShipList[i];

			var tx:Number=gs.m_PosX-x;
			var ty:Number=gs.m_PosY-y;

			if((tx*tx+ty*ty)<(30*30)) {
				ship=GetShip(gs.m_SectorX,gs.m_SectorY,gs.m_PlanetNum,gs.m_ShipNum);
				planet=GetPlanet(gs.m_SectorX,gs.m_SectorY,gs.m_PlanetNum);
				if(ship!=null && ship.m_Type!=Common.ShipTypeNone && planet.m_Vis && StealthType(planet,ship,Server.Self.m_UserId)!=2) {
//trace("!!!CalcPickGraph08");
					return [gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 0];
				}
			}
		}
		
//trace("!!!CalcPickGraph09", secx, secy, planetnum, -1, special);
		if(shipnum>=0 && special==0) return [secx, secy, -1, -1, 0];
		return [secx, secy, planetnum, -1, special];
	}

	public function InfoUpdate(x:int, y:int):void
	{
		var ra:Array=CalcPickGraph(x,y,m_Action!=ActionPlanet);
		var secx:int=ra[0];
		var secy:int=ra[1];
		var planetnum:int=ra[2];
		var shipnum:int = ra[3];
		var special:int = ra[4];

		var i:int,u:int,k:int;
		var ship:Ship;
		var planet:Planet;

/*			x=ScreenToWorldX(x);
		y=ScreenToWorldY(y);

		var secx:int=Math.floor(x/m_SectorSize);
		var secy:int=Math.floor(y/m_SectorSize);
		var planetnum=-1;
		var shipnum=-1;

		var sr:int=0;

		while(secx>=m_SectorMinX && secx<m_SectorMinX+m_SectorCntX && secy>=m_SectorMinY && secy<m_SectorMinY+m_SectorCntY) {
			var tx,ty,r,mr:Number;
			var ra:Array;
			var sec:Sector=GetSector(secx,secy);
			if(sec==null) break;

			for(i=0;i<sec.m_Planet.length;i++) {
				planet=sec.m_Planet[i];
				r=(x-planet.m_PosX)*(x-planet.m_PosX)+(y-planet.m_PosY)*(y-planet.m_PosY);
				if(r<(40*40)) {
					planetnum=i;
					if(planet.m_Flag & Planet.PlanetFlagLarge) sr=30;
					else sr=25;
					m_GraphSelect.SetPos(secx,secy,planetnum);

					break;
				} else if(r<(120*120)) {
					k=-1;
					for(u=0;u<Common.ShipOnPlanetMax;u++) {
						ra=CalcShipPlace(planet,u);
						tx=x-ra[0];
						ty=y-ra[1];
						r=tx*tx+ty*ty
						
						if(r<(30*30) && (k<0 || r<mr)) {
							k=u;
							mr=r;
						}
					}
					while(k>=0) {
						ship=planet.m_Ship[k];
						if(ship.m_ArrivalTime>GetServerTime()) break;

						planetnum=i;
						shipnum=k;
						break;
					}

					break;
				}
			}
			break;	
		}*/

		var infohide:Boolean = true;
/*			while (special != 0 && planetnum >= 0 && shipnum >= 0 && m_Action == ActionNone) {
			planet = GetPlanet(secx, secy, planetnum);
			if (planet == null) break;
			ship = planet.m_Ship[shipnum];
			if (ship.m_Type == Common.ShipTypeNone) { shipnum = -1; break; }
			if (ship.m_ArrivalTime > m_ServerTime) { shipnum = -1; break; }
			break;
		}*/

		if(shipnum>=0 && m_Action==ActionPlanet && !IsEdit()) {
			for (i = 0; i < m_ShipPlaceList.length; i++) {
				var gsp:GraphShipPlace = m_ShipPlaceList[i];
				if (gsp.m_SectorX == secx && gsp.m_SectorY == secy && gsp.m_PlanetNum == planetnum && gsp.m_ShipNum == shipnum) {
//						m_Info.ShowShipType(gsp.m_ShipType,secx,secy,planetnum,shipnum);
					infohide = false;
					break;
				}
			}
		}

		if(!infohide) {}
		else if(shipnum>=0 && (m_Action==ActionNone || m_Action==ActionPlanet)) {
			ship=GetShip(secx,secy,planetnum,shipnum);
			planet=GetPlanet(secx,secy,planetnum);
			if(ship!=null && planet!=null && planet.m_Vis) {
//trace("A",ship.m_Type,ship.m_OrbitItemType);
				if(ship.m_Type==Common.ShipTypeNone && ship.m_OrbitItemType!=Common.ItemTypeNone) {
//trace("B",ship.m_Type,ship.m_OrbitItemType);

					while(true) {
						if(ship.m_OrbitItemType==Common.ItemTypeMine) {
							if(!IsShowMine(shipnum,ship,planet,Server.Self.m_UserId)) break;
						}
						
						var ira:Array = CalcShipPlace(planet, shipnum);
						WorldToScreenX(ira[0], ira[1]);
						m_Info.ShowItemEx(ship,ship.m_OrbitItemType, ship.m_OrbitItemCnt, ship.m_OrbitItemOwner, 0, 0, m_TWSPos.x - 20, m_TWSPos.y - 20, 40, 40);

						break;
					}
				} else {
					m_Info.ShowShipLive(secx, secy, planetnum, shipnum);

					var gs:GraphShip=GetGraphShip(secx,secy,planetnum,shipnum);
					if (gs != null) {
						i = m_ShipList.indexOf(gs);
						if (i >= 0) {
							m_ShipList.splice(i, 1);
							m_ShipList.push(gs);
						}
						//gs.MoveTop();
					}

				}
				infohide=false;
			}
		} else if (planetnum >= 0 && special == 1 && m_Action == ActionNone) {
			planet = GetPlanet(secx, secy, planetnum);
			if (planet != null) {
				m_Info.ShowPortal(secx, secy, planetnum);
				infohide=false;
			}

		} else if(planetnum>=0 && (m_Action==ActionNone || m_Action==ActionPlanet)) {
			planet = GetPlanet(secx, secy, planetnum);
			if (planet != null) {
				m_Info.ShowPlanetLive(secx, secy, planetnum);
				infohide=false;
			}
		}

		if(infohide) m_Info.Hide();
	}
	
	public function CalcTestMoveTo(sectorx:int,sectory:int,planetnum:int,shipnum:int) : Boolean
	{
		var tt:int;

		if(m_MoveSectorX==sectorx && m_MoveSectorY==sectory && m_MovePlanetNum==planetnum && m_MoveShipNum==shipnum) return false;

		// Откуда летим
		var planetfrom:Planet=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
		if(planetfrom==null) return false;
		if(m_MoveShipNum<0 || m_MoveShipNum>=Common.ShipOnPlanetMax) return false;
		var shipfrom:Ship=planetfrom.m_Ship[m_MoveShipNum];
		if(shipfrom==null) return false;
		if(shipfrom.m_Type==Common.ShipTypeNone) return false;
		//if(shipfrom.m_Owner!=Server.Self.m_UserId) return false;
		if(!AccessControl(shipfrom.m_Owner)) return false;
		if (shipfrom.m_Flag & (Common.ShipFlagBomb)) return false;
		
		if((shipfrom.m_Flag & Common.ShipFlagBuild)!=0 && (m_MoveSectorX!=sectorx || m_MoveSectorY!=sectory || m_MovePlanetNum!=planetnum) && shipnum>=0) return false;

		if(!(m_MoveSectorX==sectorx && m_MoveSectorY==sectory && m_MovePlanetNum==planetnum)) {
			// Станции не могу перемещаться между планетами
			if(Common.IsBase(shipfrom.m_Type)) return false;

			// Корабли за исключением корвета не могут перемещаться между планетами во время битвы
			//if(shipfrom.m_Type!=Common.ShipTypeCorvette && IsBattle(planetfrom,shipfrom.m_Owner,shipfrom.m_Race)) return false;
			if(!CanLeavePlanet(planetfrom,shipfrom)) return false;
		}

		// Куда летим
		var planet:Planet=GetPlanet(sectorx,sectory,planetnum);
		if (planet == null) return false;
		if (planet.m_Flag & Planet.PlanetFlagNoMove) return false;

		if(((planetfrom.m_PosX-planet.m_PosX)*(planetfrom.m_PosX-planet.m_PosX)+(planetfrom.m_PosY-planet.m_PosY)*(planetfrom.m_PosY-planet.m_PosY))>JumpRadius2) return false;
		
		if (planetfrom != planet) {
			if(planet.m_Flag & Planet.PlanetFlagWormhole) {
				if (m_CotlType == Common.CotlTypeCombat) {
					tt = TeamType();
					if (tt >= 0 && tt != (shipnum & 1)) return false;
				} else {
					if (shipnum & 1) return false;
				}
			}
		} else if(planet.m_Flag & Planet.PlanetFlagWormhole) {
			if((shipnum & 1)!=(m_MoveShipNum & 1)) return false;
		}

		if(shipnum<0) return true;

		if(shipnum>=Common.ShipOnPlanetMax) return false;
		var ship:Ship=planet.m_Ship[shipnum];

		if (shipnum >= planet.ShipOnPlanetLow) {
			if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
			if (!Common.ShipLowOrbit[shipfrom.m_Type]) return false;
			if (!AccessLowOrbit(planet, shipfrom.m_Owner, shipfrom.m_Race)) return false;
		}

		if(ship.m_Type==Common.ShipTypeNone) {
			return true;

		} else if(StealthType(planet,ship,Server.Self.m_UserId)==2) {
			return true;

		} else if(!planet.m_Vis) {
			return true;

		} else {
			//if(ship.m_Owner!=Server.Self.m_UserId) return false;
			if(!AccessControl(ship.m_Owner)) return false;
			if(ship.m_Cnt>=ShipMaxCnt(ship.m_Owner,ship.m_Type)) return false;
			if(m_MoveSectorX!=sectorx || m_MoveSectorY!=sectory || m_MovePlanetNum!=planetnum) return false;

			if(shipfrom.m_Type!=ship.m_Type) return false;
			if(shipfrom.m_Owner!=ship.m_Owner) return false;

			return true;
		}

		return false;
	}
	
	private var m_RotateShipLastTime:Number = 0;
	private var m_RotateShipAngle:Number = 0;
	
	public function RotateShipTimer(event:TimerEvent):void
	{
		var ct:Number = Common.GetTime();
		var s:Number = ct-m_RotateShipLastTime;
		if (s < 5) return;
		m_RotateShipLastTime = ct;
		if (s > 1000) return;

//			if (!m_Set_VectorShip) return;
//			if (!m_Set_VectorShip) s >>=1;
		
		m_RotateShipAngle += Math.PI * 2.0 * (s % (1000 * 120)) / (1000 * 120);
		m_RotateShipAngle = BaseMath.AngleNorm(m_RotateShipAngle);
	}

	public function CalcShipPlaceEx(planet:Planet, placenum:int, out:Vector3D):void
	{
		var tx:Number = planet.m_PosX;
		var ty:Number = planet.m_PosY;

		var a:Number;
		var r:Number;
		var u:int;

		if (placenum >= planet.ShipOnPlanetLow) {
			//a = Math.PI * 0.125 + Math.PI * 0.25 * (placenum - Common.ShipOnPlanetLow);
			a = 36.0 * Space.ToRad + 72.0 * Space.ToRad * (placenum - planet.ShipOnPlanetLow);
			if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) != 0) r = 55;
			else r = 45;
		} else {
//				a = Math.PI * 0.125 * placenum;
//				if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) != 0) {
//					if (placenum & 1) r = 105;
//					else r = 85;
//				} else {
//					if (placenum & 1) r = 100;
//					else r = 80;
//				}

			if (planet.ShipOnPlanetLow == 16) {
				a = Math.PI * 0.125 * placenum;
				if (placenum & 1) r = 90;
				else r = 75;
			} else {
				u = placenum % 3;
				if (u == 0) { a = 0.0; r = 90;/* 75;*/ } // 100 - слишком много
				else if (u == 1) { a = 24.0 * Space.ToRad; r = 90; }
				else { a = 48.0 * Space.ToRad; r = 90; }
				a += Math.floor(placenum / 3) * 72.0 * Space.ToRad;
			}

			if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) != 0) r += 5;
		}

		a += Math.PI * 2.0 * (m_CurTime % (1000 * 120)) / (1000 * 120);

		out.x = r * Math.sin(a) + tx;
		out.y = -r * Math.cos(a) + ty;
		out.z = BaseMath.AngleNorm(a + Math.PI * 0.5);
	}

	public function CalcShipPlace(planet:Planet, placenum:int):Array
	{
		var tx:Number=planet.m_PosX;
		var ty:Number=planet.m_PosY;

		var a:Number;
		var r:Number;
		var u:int;

		if (placenum >= planet.ShipOnPlanetLow) {
//				a = Math.PI * 0.125 + Math.PI * 0.25 * (placenum - Common.ShipOnPlanetLow);
			a = 36.0 * Space.ToRad + 72.0 * Space.ToRad * (placenum - planet.ShipOnPlanetLow);
			if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) != 0) r = 50;
			else r = 45;
		} else {
//				a = Math.PI * 0.125 * placenum;
//				if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) != 0) {
//					if (placenum & 1) r = 105;
//					else r = 85;
//				} else {
//					if (placenum & 1) r = 100;
//					else r = 80;
//				}

			if (planet.ShipOnPlanetLow == 16) {
				a = Math.PI * 0.125 * placenum;
				if (placenum & 1) r = 90;
				else r = 75;
			} else {
				u = placenum % 3;
				if (u == 0) { a = 0.0; r = 90;/* 75;*/ }
				else if (u == 1) { a = 24.0 * Space.ToRad; r = 90; }
				else { a = 48.0 * Space.ToRad; r = 90; }
				a += Math.floor(placenum / 3) * 72.0 * Space.ToRad;
			}
			
			if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) != 0) r += 5;
		}

		//a += m_RotateShipAngle;
		a += Math.PI * 2.0 * (Common.GetTime() % (1000 * 120)) / (1000 * 120);

		return [r * Math.sin(a) + tx, -r * Math.cos(a) + ty, BaseMath.AngleNorm(a + Math.PI * 0.5)];
	}

	public function GetSector(sx:int,sy:int):Sector
	{
		var sec:Sector=null;
		if(m_Sector==null) return null;
		var i:int=(sx-m_SectorMinX)+(sy-m_SectorMinY)*m_SectorCntX;
		if(i<0 || i>=m_SectorCntX*m_SectorCntY) return null;
		if(!(m_Sector[i] is Sector)) return null;
		sec=m_Sector[i];
		return sec;
	}

	public function GetSectorEx(sx:int,sy:int):Sector
	{
		var sec:Sector=null;
		if(m_Sector==null) return null;
		if (sx<m_SectorMinX || sx>=m_SectorMinX+m_SectorCntX) return null;
		if (sy<m_SectorMinY || sy>=m_SectorMinY+m_SectorCntY) return null;
		var i:int=(sx-m_SectorMinX)+(sy-m_SectorMinY)*m_SectorCntX;
		if (i<0 || i>=m_SectorCntX*m_SectorCntY) return null;
		if (!(m_Sector[i] is Sector)) {
			m_Sector[i] = new Sector(sx, sy);
		}
		sec=m_Sector[i];
		return sec;
	}

	public function GetPlanet(sx:int,sy:int,num:int):Planet
	{
		var sec:Sector=GetSector(sx,sy);
		if(sec==null) return null;
		if(num<0 || num>=sec.m_Planet.length) return null;
		return sec.m_Planet[num];
	}

	public function GetShip(sx:int,sy:int,planetnum:int,shipnum:int):Ship
	{
		if(shipnum<0 || shipnum>=Common.ShipOnPlanetMax) return null;
		var planet:Planet=GetPlanet(sx,sy,planetnum);
		if(planet==null) return null;
		return planet.m_Ship[shipnum];
	}

	public function GetGraphShip(sx:int,sy:int,planetnum:int,shipnum:int):GraphShip
	{
		for (var u:int = 0; u < m_ShipList.length; u++) {
			var gs:GraphShip = m_ShipList[u];
			if(gs.m_SectorX==sx && gs.m_SectorY==sy && gs.m_PlanetNum==planetnum && gs.m_ShipNum==shipnum) return gs;
		}
		return null;
	}

/*		public function GetGraphShipById(owner:uint, id:uint):GraphShip
	{
		for (var u:int = 0; u < m_ShipList.length; u++) {
			var gs:GraphShip = m_ShipList[u];
			if (gs.m_Owner == owner && gs.m_Id == id) return gs;
		}
		return null;
	}*/

	public function GetGraphPlanet(sx:int,sy:int,planetnum:int):GraphPlanet
	{
		for (var u:int = 0; u < m_PlanetList.length; u++) {
			var gp:GraphPlanet=m_PlanetList[u];
			if(gp.m_SectorX==sx && gp.m_SectorY==sy && gp.m_PlanetNum==planetnum) return gp;
		}
		return null;
	}
	
	public function GetGraphShipById(id:uint):GraphShip
	{
		for(var u:int=0;u<m_ShipList.length;u++) {
			var gs:GraphShip=m_ShipList[u];
			if(gs.m_Id==id) return gs;
		}
		return null;
	}
	
	public function Link(planet:Planet, ship:Ship):Planet
	{
		var p:uint = ship.m_Link;
		if (!p) return null;

		var sec:Sector = planet.m_Sector;
		var sx:int = sec.m_SectorX;
		var sy:int = sec.m_SectorY;
		
		sx += Common.FromLink[((p & 31) << 1) + 0];
		sy += Common.FromLink[((p & 31) << 1) + 1];
		
		if (sx < m_SectorMinX) return null;
		else if (sx >= m_SectorMinX + m_SectorCntX) return null;
		if (sy < m_SectorMinY) return null;
		else if (sy >= m_SectorMinY + m_SectorCntY) return null;
		
/*		if(p & 1) {
			sx++;
			if (p & 64) sx++;
			if (sx >= m_SectorMinX + m_SectorCntX) return null;
		}
		if(p & 2) {
			sx--;
			if (p & 64) sx--;
			if (sx < m_SectorMinX) return null;
		}
		if(p & 4) {
			sy++;
			if (p & 128) sy++;
			if (sy >= m_SectorMinY + m_SectorCntY) return null;
		}
		if(p & 8) {
			sy--;
			if (p & 128) sy--;
			if (sy < m_SectorMinY) return null;
		}*/
		sec = GetSector(sx, sy);
		if (sec == null) return null;
		var pn:int = (p >> 5) & 3;
		if (pn >= sec.m_Planet.length) return null;
		return sec.m_Planet[pn];
	}

	public function LinkSet(ps:Planet, ship:Ship, planet:Planet):void
	{
		if(!planet) {
			ship.m_Link = 0;
			return;
		}

		var x:int = planet.m_Sector.m_SectorX - ps.m_Sector.m_SectorX;
		if (x < -2 || x > 2) { ship.m_Link = 0; return; } 
		var y:int = planet.m_Sector.m_SectorY - ps.m_Sector.m_SectorY;
		if (y < -2 || y > 2) { ship.m_Link = 0; return; }

		ship.m_Link = Common.ToLink[(x + 2) + (y + 2) * 5] | (planet.m_PlanetNum << 5);

//		if (secx - 2 == to_secx) p |= 2 | 64;
//		else if (secx - 1 == to_secx) p |= 2;
//		else if (secx + 2 == to_secx) p |= 1 | 64;
//		else if (secx + 1 == to_secx) p |= 1;
//		else if (secx != to_secx) { ship.m_Link = 0; return; }

//		if (secy - 2 == to_secy) p |= (2 << 2) | 128;
//		else if (secy - 1 == to_secy) p |= 2 << 2;
//		else if (secy + 2 == to_secy) p |= (1 << 2) | 128;
//		else if (secy + 1 == to_secy) p |= 1 << 2;
//		else if (secy != to_secy) { ship.m_Link = 0; return; }

//		ship.m_Link = p | (planet.m_PlanetNum << 4);
	}

	public function ReconnectTimer(event:TimerEvent=null):void
	{
		m_ReconnectTimer.stop();
//trace("emconnect from ReconnectTimer",Server.Self.m_Session);
		Server.Self.Query("emconnect","",ConnectComplete,false);
	}

	public function RecvWaitReady(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		while(true) {
			if(loader.bytesTotal<1) { ErrorFromServer(Server.ErrorData); break; }
			var buf:ByteArray=loader.data;
			buf.endian=Endian.LITTLE_ENDIAN;

			var err:int = buf.readUnsignedByte();

			if (err == 0) {
				m_ReconnectTimer.start();
				break;
			}
			
			ToOnlyHyperspace();
			break;
		}
	}
	
	public function ToOnlyHyperspace():void
	{
		Server.Self.m_CotlId = 0;

		if(!HS.visible) {
			FormHideAll();
			HS.Show();
		}
	}

	public override function ErrorFromServer(err:uint, errstr:String = ''):Boolean
	{
		var s:String;
		
		if(err==0 && errstr.length<=0) return false;
		if(err==Server.ErrorNoReady) {
			ClearForNewCotl();
			//m_ConnectState = 0;
			
			s = "&id=" + Server.Self.m_CotlId;
			if(IsEdit()) s+="&e=1"
			Server.Self.Query("emcotladr", s, RecvWaitReady, false);
			
			return true;
		}
		s=Common.Hint.NoServer;
		if(err!=0) s+=" "+Common.Hint.ErrorNo+": "+err.toString();
		if(errstr.length>0) s+=" "+errstr;
		m_FormHint.Show(s);
		//trace("Server error: "+err);

		super.ErrorFromServer(err, errstr);

		m_FormEnter.Show();

		return true;
	}

	/*public function ConnectError(event:IOErrorEvent):void
	{
		m_ConnectState=-1;
		m_FormMiniMap.Hide();
		m_FormInfoBar.Hide();
		m_FormChat.Hide();
		Update();
		
		m_FormHint.Show(Common.Hint.NoServer);
		//trace("ConnectError: " + event);
		
		m_FormEnter.Run();
	}*/

	public function PreconnectComplete(event:Event):void
	{
		var s:String;
//trace("!!!PreconnectComplete00");

		var loader:URLLoader = URLLoader(event.target);

		while(true) {
			if(loader.bytesTotal<1) { ErrorFromServer(Server.ErrorData); break; }
			var buf:ByteArray=loader.data;
			buf.endian=Endian.LITTLE_ENDIAN;

			var err:int = buf.readUnsignedByte();
			if (err == 60) {
				buf.position = 0;
				var str:String = buf.readUTFBytes(buf.length);
				ErrorFromServer(0, str);
				break;
			}
//trace("!!!PreconnectComplete",err);
			if(err==Server.ErrorExitTimeout) {
				s="\n"+Common.Txt.ExitTimeout;
				s=s.replace(/<Val>/g,Common.FormatPeriod(buf.readUnsignedInt()));
				ErrorFromServer(0,s);
				break;
			} else if(err==Server.ErrorBan) {
				var so:SharedObject = SharedObject.getLocal("EGEmpireData");
				if(so!=null) so.data.uid=undefined;

				var bdate:uint = buf.readUnsignedInt();
				if (bdate == 0xffffffff) {
					s="\n"+Common.Txt.Ban;
				} else {
					s = "\n" + Common.Txt.BanDate;
					s = BaseStr.Replace(s, "<Val>", Common.FormatPeriodLong(bdate));
				}
				ErrorFromServer(0, s);
				break;
			}
			if(ErrorFromServer(err)) break;

			var userid:uint=buf.readUnsignedInt();
			if(userid!=Server.Self.m_UserId) {
				ErrorFromServer(0,"System");
				break;
			}
			var skey:String=buf.readUnsignedInt().toString(16);
			var snum:uint=buf.readUnsignedInt();
			while(skey.length<8) skey="0"+skey;
//trace("skey",skey.toString());
			Server.Self.ConnectAccept(userid/*m_UserId*/,skey+snum.toString(16));

			while(buf.position<buf.length) {
				var cotl_id:uint=buf.readUnsignedInt();
				if(cotl_id==0) break;
				var adr_len:int=buf.readUnsignedByte();
				var adr:String=buf.readUTFBytes(adr_len);
				var port:int=buf.readUnsignedInt();
				var num:int=buf.readUnsignedInt();

//trace("PC",cotl_id,adr_len,adr,port,num);

				m_RootCotlId=cotl_id;
				Server.Self.m_CotlId=cotl_id;
				Server.Self.m_ServerAdr="http://"+adr+":"+port.toString()+"/";
				Server.Self.m_ServerNum=num;

				//m_FormGalaxy.GoTo(cotl_id);

				//break;
			}

			m_RootFleetId = buf.readUnsignedInt();
			HS.m_RootFleetId = m_RootFleetId;

			adr_len = buf.readUnsignedByte();
			adr = buf.readUTFBytes(adr_len);
			port = buf.readUnsignedInt();
			Server.Self.m_SpaceServerAdr = "http://" + adr + ":" + port.toString() + "/";

			m_EmpireEdit = buf.readUnsignedByte() != 0;

//			m_MapEditor = buf.readUnsignedByte() != 0; 

			m_AutoOff = buf.readUnsignedByte() != 0; 

			UserList.Self.ItemClear();
			m_ItemVersion = buf.readUnsignedInt();
			m_GalaxyAllCotlCnt = buf.readUnsignedInt();
			
			m_UserExistClone = buf.readUnsignedByte() != 0;

			if (C3D.m_FatalError.length > 0) return;
			//m_FormGalaxy.LoadCotlById(m_RootCotlId, true);
			HS.GetCotl(m_RootCotlId);
			HS.LoadCotl();

			QueryTxt();
			if (C3D.m_FatalError.length > 0) return;

			HS.Run();
			if (C3D.m_FatalError.length > 0) return;

			UserList.Self.GetItem(Common.ItemTypeTechnician);
			UserList.Self.GetItem(Common.ItemTypeNavigator);

//trace("emconnect from PreconnectComplete");
			Server.Self.Query("emconnect","",ConnectComplete,false);
			
			break;
		}
	}

	public function ConnectComplete(event:Event):void
	{
		var i:int,cnt:int;
		var ra:Array;

		var loader:URLLoader = URLLoader(event.target);

		var foncfg:String = "";

		while(true) {
//trace(loader.bytesTotal);
			if(loader.bytesTotal<1) { ErrorFromServer(Server.ErrorData); break; }
			var buf:ByteArray=loader.data;
			buf.endian=Endian.LITTLE_ENDIAN;

			var err:int=buf.readUnsignedByte();
//trace(err);
			if(ErrorFromServer(err)) break;
			
			if(loader.bytesTotal<1+8*4+1) { ErrorFromServer(0,Common.Hint.ErrorVersion); break; }

			UserList.Self.GetUser(Common.OwnerAI0,false).Unload();
			UserList.Self.GetUser(Common.OwnerAI1,false).Unload();
			UserList.Self.GetUser(Common.OwnerAI2,false).Unload();
			UserList.Self.GetUser(Common.OwnerAI3,false).Unload();

			if(buf.readUnsignedInt()!=GameVersion) { /*trace("ver");*/ ErrorFromServer(0,Common.Hint.ErrorVersion); break; }
			Server.Self.m_ConnNo=buf.readInt();
			Server.Self.m_ServerKey=buf.readInt();
			Server.Self.m_ClearCnt=buf.readInt();
			m_SectorSize=buf.readInt();
			m_CotlType=buf.readInt();
			m_CotlOwnerId=buf.readUnsignedInt();
			m_CotlUnionId=buf.readUnsignedInt();
			m_CotlZoneLvl=buf.readInt();
			m_EmpireColony=m_CotlType==0;
			m_SectorMinX=buf.readInt();
			m_SectorMinY=buf.readInt();
			m_SectorCntX=buf.readInt();
			m_SectorCntY = buf.readInt();
			m_OpsJumpRadius = buf.readInt();
			JumpRadius2 = m_OpsJumpRadius * m_OpsJumpRadius;
			m_WorldVer = buf.readUnsignedShort();
			m_StateVer = buf.readUnsignedShort();

//				m_FleetPosX = buf.readInt();
//				m_FleetPosY = buf.readInt();

			var cotl:SpaceCotl = HS.GetCotl(m_RootCotlId, false);
//				cotl.m_PosX = buf.readInt();
//				cotl.m_PosY = buf.readInt();
//				cotl.m_ZoneX = Math.floor(cotl.m_PosX / Space.Self.m_ZoneSize);
//				cotl.m_ZoneY = Math.floor(cotl.m_PosY / Space.Self.m_ZoneSize);
//				cotl.m_PosX = cotl.m_PosX - cotl.m_ZoneX * Space.Self.m_ZoneSize;
//				cotl.m_PosY = cotl.m_PosY - cotl.m_ZoneY * Space.Self.m_ZoneSize;

			//if(m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich) {
				m_OpsFlag=buf.readUnsignedInt();
				m_OpsModuleMul=buf.readUnsignedInt();
				m_OpsCostBuildLvl=buf.readUnsignedInt();
				m_OpsSpeedCapture=buf.readUnsignedInt();
				m_OpsSpeedBuild=buf.readUnsignedInt();
				m_OpsRestartCooldown=buf.readUnsignedInt();
				m_OpsStartTime=buf.readUnsignedInt();
				m_OpsPulsarActive=buf.readUnsignedInt();
				m_OpsPulsarPassive = buf.readUnsignedInt();
				m_OpsWinScore=buf.readUnsignedInt();
				m_OpsRewardExp=buf.readUnsignedInt();
				m_OpsPriceEnter=buf.readUnsignedInt();
				m_OpsPriceEnterType=buf.readUnsignedInt();
				m_OpsPriceCapture=buf.readUnsignedInt();
				m_OpsPriceCaptureType = buf.readUnsignedInt();
				m_OpsPriceCaptureEgm = buf.readUnsignedInt();
				m_OpsProtectCooldown=buf.readUnsignedInt();
				m_OpsTeamOwner = buf.readByte();
				m_OpsTeamEnemy = buf.readByte();
			//}
			m_OpsMaxRating=buf.readUnsignedInt();
			m_Edit=buf.readByte()!=0;
			HS.m_ZoneMinX=buf.readInt();
			HS.m_ZoneMinY=buf.readInt();
			HS.m_ZoneCntX=buf.readInt();
			HS.m_ZoneCntY=buf.readInt();
			HS.m_ZoneSize = buf.readInt();
			SP.m_ZoneMinX = HS.m_ZoneMinX;
			SP.m_ZoneMinY = HS.m_ZoneMinY;
			SP.m_ZoneCntX = HS.m_ZoneCntX;
			SP.m_ZoneCntY = HS.m_ZoneCntY;
			SP.m_ZoneSize = HS.m_ZoneSize;
			m_BuildSpeed=buf.readInt();
			m_ModuleMul=buf.readInt();
			m_ResMul=buf.readInt();
			m_SupplyMul=buf.readInt();
			m_TechSpeed=buf.readInt();
			m_InfrCostMul=buf.readInt();
			m_EmpireLifeTime=buf.readInt();
			m_SessionPeriod=buf.readInt();
			m_SessionStart=buf.readInt();
			m_Access=buf.readUnsignedInt();
			m_GameState=buf.readUnsignedInt();
			m_GameTime=buf.readUnsignedInt();
			m_ReadyTime = buf.readUnsignedInt();
			if (m_CotlType == Common.CotlTypeUser) m_PlanetDestroy = buf.readUnsignedByte();
			else m_PlanetDestroy = 0;

			cnt = buf.readUnsignedShort();
			if (cnt > 0) foncfg = buf.readUTFBytes(cnt);

			LoadTeamRel(buf);
//				m_TeamRelVer=buf.readUnsignedInt();
//				if(m_TeamRelVer!=0) {
//					cnt=(1<<Common.TeamMaxShift)*(1<<Common.TeamMaxShift);
//					for(i=0;i<cnt;i++) m_TeamRel[i]=buf.readUnsignedByte();
//				}

//trace("m_EmpireLifeTime",m_EmpireLifeTime);
			m_ServerGlobalTimeSyn = 1000 * buf.readUnsignedInt();
			m_ServerGlobalTimeSynRecvTime = Common.GetTime();

			m_ServerCalcTimeSyn = 1000 * buf.readUnsignedInt();
			m_ServerCalcTimeSynRecvTime = Common.GetTime();

			var strservertime:String = buf.readUTFBytes(19);
			m_ConnectTime = m_ServerGlobalTimeSyn;
			m_ConnectDate = new Date(int(strservertime.substr(0, 4)), int(strservertime.substr(5, 2)) - 1, int(strservertime.substr(8, 2)), int(strservertime.substr(11, 2)), int(strservertime.substr(14, 2)), int(strservertime.substr(17, 2)));
			m_DifClientServerHour = Math.round(((new Date()).getTime() - m_ConnectDate.getTime()) / (60 * 60 * 1000));

			//m_UserId
//				var userid:uint=buf.readUnsignedInt();
//				var skey:String=buf.readUnsignedInt().toString(16);
//				var snum:uint=buf.readUnsignedInt();
//				while(skey.length<8) skey="0"+skey;
//trace("skey",skey.toString());
//				Server.Self.ConnectAccept(userid/*m_UserId*/,skey+snum.toString(16));

			//var user:User=new User();
			//m_UserList[userid]=user;
			var user:User=UserList.Self.GetUser(/*userid*/Server.Self.m_UserId,false);

			user.m_SysName='';
			var namelen:int=buf.readUnsignedByte();
			if (buf.position + namelen > buf.length) { ErrorFromServer(Server.ErrorData); break; }
			if (namelen > 0) user.m_SysName = buf.readUTFBytes(namelen);
			//for(i=0;i<namelen;i++) {
			//	user.m_Name+=String.fromCharCode(buf.readUnsignedByte());
			//}
//trace(""+m_UserId+" "+user.m_Name+" "+buf.position+" "+buf.length);

			m_HomeworldPlanetNum = buf.readByte();
			if (m_HomeworldPlanetNum == 0) {
				m_HomeworldPlanetNum = -1;
				m_HomeworldSectorX = 0;
				m_HomeworldSectorY = 0;
				m_HomeworldCotlId = 0;
			} else {
				m_HomeworldPlanetNum--;
				m_HomeworldSectorX = buf.readShort();
				m_HomeworldSectorY = buf.readShort();
				m_HomeworldCotlId = buf.readUnsignedInt();

				//m_OffsetX=Math.round(m_HomeworldSectorX*m_SectorSize+m_SectorSize/2);
				//m_OffsetY=Math.round(m_HomeworldSectorY*m_SectorSize+m_SectorSize/2);
//					SetCenter(Math.round(m_HomeworldSectorX*m_SectorSize+m_SectorSize/2),Math.round(m_HomeworldSectorY*m_SectorSize+m_SectorSize/2))
			}
			//m_CitadelNum=-1;

			var consum:Boolean = buf.readByte() != 0;
			if (consum) {
				m_ConsumptionType[0] = buf.readUnsignedInt();
				m_ConsumptionCnt[0] = buf.readInt();
				m_ConsumptionType[1] = buf.readUnsignedInt();
				m_ConsumptionCnt[1] = buf.readInt();
				m_ConsumptionType[2] = buf.readUnsignedInt();
				m_ConsumptionCnt[2] = buf.readInt();
				m_ConsumptionType[3] = buf.readUnsignedInt();
				m_ConsumptionCnt[3] = buf.readInt();
			}

			var sizemmpp:int = buf.readInt();
//trace("sizemmpp",sizemmpp);
			var m_MMPlanetPos:ByteArray = new ByteArray();
			m_FormMiniMap.m_PlanetPos.length = 0;
			buf.readBytes(m_FormMiniMap.m_PlanetPos, 0, sizemmpp);
			m_FormMiniMap.m_PlanetPos.uncompress();
			m_FormMiniMap.SetCenter(OffsetX, OffsetY);
			m_FormMiniMap.m_MMQueryTime = 0;
			//if (!HS.visible) m_FormMiniMap.Show();
			//if (m_ItfBattle) m_FormBattleBar.Show();

			m_Sector = new Array(m_SectorCntX * m_SectorCntY);
			m_StateConnect = 1;

			ItfUpdate();

			QueryTxtCotl();

			m_FormChat.QueryChList();
			m_FormInfoBar.Show();
			if (C3D.m_FatalError.length > 0) return;

			m_FormHint.Hide();

			if(m_Reenter) {}
			else {
				while(m_CotlType!=0) {
					cotl=HS.GetCotl(Server.Self.m_CotlId);
					if (cotl == null) break;

					SetCenter(cotl.m_OldOffsetX,cotl.m_OldOffsetY);
					m_FormMiniMap.SetCenter(OffsetX,OffsetY);
					break;
				}

				if(m_GoPlanet<0 && m_HomeworldPlanetNum>=0 && m_HomeworldCotlId==Server.Self.m_CotlId && m_FirstEnterCotl) {
					m_FirstEnterCotl=false;
					GoTo(false,m_HomeworldCotlId,m_HomeworldSectorX,m_HomeworldSectorY,m_HomeworldPlanetNum);

				} else if(m_GoPlanet>=0) {
					GoToProcess();
				}
			}
			m_Reenter=false;

			SendLoadSector();

			m_FormCptBar.QueryCptDsc();

			if (C3D.m_FatalError.length > 0) return;

			stage.focus = this;
			
			FonInit(foncfg);
			
			HintNewHomeworldUpdate();
			
			if (IsEdit()) CodeQuery(null);
			break;
		}

		Update();
		
/*			goto tg;
		
tg:			var t0:int = getTimer();
		for (i = 0; i < 1000000; i++) {
			aaa();
		}
		var t1:int = getTimer();
		for (i = 0; i < 1000000; i++) {
			bbb();
		}
		var t2:int = getTimer();
		//trace(t1 - t0, t2 - t1, vaaa);
		FormChat.Self.AddDebugMsg("inline: " + (t1 - t0).toString() + " " + (t2 - t1).toString() + " " + vaaa.toString());*/
	}

/*		public var vaaa:int = 0;
	public function aaa():void
	{
		vaaa++;
	}
	[inline] public final function bbb():void
	{
		vaaa++;
	}*/

	public function StateReady():Boolean
	{
		if (!IsConnect()) return false;
		if (!m_StateCurUser) return false;
		if (!m_StateCpt) return false;
		if (!m_StateGv) return false;
		if (!m_StateQuest) return false;
		return true;
	}

	public function StateEnterCotl():Boolean
	{
		if (m_StateEnterCotl) return false;
		if (!StateReady()) return false;
		if (!m_StateSector) return false;
		if (HS.visible) return false;
		if (!QEManager.IsProcessPrepare()) return false;

		m_StateEnterCotl = true;
		m_ItfNews = true;
		m_ItfChat = true;
		m_ItfBattle = true;
		m_ItfFleet = true;
//trace("StateEnterCotl");

		QEManager.Process(QEManager.FromEnterCotl);
		m_FormQuestBar.Update();

		ItfUpdate();

		return true;
	}

	public function ItfUpdate():void
	{
		var itffleet:Boolean = m_ItfFleet;
		var itfchat:Boolean = m_ItfChat;
		var itfbattle:Boolean = m_ItfBattle;
		var itfradar:Boolean = HS.visible && (m_StateConnect >= 1);
		var itfminimap:Boolean = !HS.visible && (m_StateConnect >= 1);
		var itfcptbar:Boolean = (m_StateConnect >= 1);
		var itfquestbar:Boolean = (m_StateConnect >= 1);

		if (m_Hangar.visible) {
			itfbattle = false;
			itfradar = false;
			itfminimap = false;
			itfcptbar = false;
			itfquestbar = false;
		}
		
		if (itffleet && !m_FormFleetBar.visible) { m_FormFleetBar.Show(); }
		else if (!itffleet && m_FormFleetBar.visible) { m_FormFleetBar.Hide(); }

		if (itfchat && !m_FormChat.visible) { m_FormChat.Show(); EmpireMap.Self.m_FormInfoBar.StageResize(); }
		else if (!itfchat && m_FormChat.visible) { m_FormChat.Hide(); EmpireMap.Self.m_FormInfoBar.StageResize(); }

		if (itfradar && !m_FormRadar.visible) { m_FormRadar.Show(); }
		else if (!itfradar && m_FormRadar.visible) { m_FormRadar.Hide(); }

		if (itfminimap && !m_FormMiniMap.visible) { m_FormMiniMap.Show(); }
		else if (!itfminimap && m_FormMiniMap.visible) { m_FormMiniMap.Hide(); }

		if (itfbattle && !m_FormBattleBar.visible) { m_FormBattleBar.Show(); }
		else if(!itfbattle && m_FormBattleBar.visible) { m_FormBattleBar.Hide(); }

		if (itfcptbar && !m_FormCptBar.visible) { m_FormCptBar.Show(); }
		else if (!itfcptbar && m_FormCptBar.visible) { m_FormCptBar.Hide(); }

		if (itfquestbar && !m_FormQuestBar.visible) { m_FormQuestBar.Show(); }
		else if (!itfquestbar && m_FormQuestBar.visible) { m_FormQuestBar.Hide(); }
	}

	public function FonInit(foncfg:String):void
	{
		if (Server.Self.m_CotlId == 0) return;

		if (m_BG.m_SaveList[Server.Self.m_CotlId] != undefined) {
			if (!m_BG.CfgLoad(m_BG.m_SaveList[Server.Self.m_CotlId])) m_BG.CfgRandom(Server.Self.m_CotlId);
		} else if(foncfg.length>0) {
			if (!m_BG.CfgLoad(foncfg)) m_BG.CfgRandom(Server.Self.m_CotlId);
		} else {
			m_BG.CfgRandom(Server.Self.m_CotlId);
		}
		m_BG.Clear();
		//m_BG.onLoadComplate(null);
		//m_BG.NeedUpdate();
	}
	
	public function LoadTeamRel(buf:ByteArray):void
	{
		var i:int,cnt:int;
		var user:User;

		m_TeamRelVer=buf.readUnsignedInt();
		if(m_TeamRelVer==0) return;
		
		for(i=0;i<4;i++) {
			user=UserList.Self.GetUser(Common.OwnerAI0+i,false);
			if(user==null) continue;
			user.m_Team=0;
		}
		
		cnt=(1<<Common.TeamMaxShift)*(1<<Common.TeamMaxShift);
		for(i=0;i<cnt;i++) m_TeamRel[i]=buf.readUnsignedByte();
		
		while(true) {
			var userid:uint=buf.readUnsignedInt();
			if(userid==0) break;
			var team:int=buf.readByte();
			
			user=UserList.Self.GetUser(userid,false);
			if(user==null) continue;
			user.m_Team=team;
//trace("!!!LoadTeamRel UserId:",user.m_Id,"Team:",team);
		}
	}
	
	private var m_AutoGiveTime:Number = 0;
	
	private function SendAutoGive():void
	{
		var i:int,u:int,x:int,y:int,a:int;
		var sec:Sector;
		var planet:Planet;
		var ship:Ship;
		
		if (IsEdit()) return;
		if (m_AutoOff) return;
		if (!m_FormFleetBar.m_AutoGive) return;
		
		if ((m_CurTime-m_AutoGiveTime) < 30000) return;
		m_AutoGiveTime = m_CurTime;
		
		if (IsSpaceOff()) return;
		if (HS.visible) return;
		if (Server.Self.m_CotlId == 0) return;

//			var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize)-1);
//			var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize)-1);
//			var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+2);
//			var ey:int=Math.min(m_SectorMinY+m_SectorCntY,Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize)+2);
		if (!PickWorldCoord(0, 0, m_TV0)) return;
		if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
		if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
		if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
		var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
		var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
		var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
		var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
				if (i<0 || i>=m_SectorCntX*m_SectorCntY) continue;
				if (!(m_Sector[i] is Sector)) continue;
				sec = m_Sector[i];

				for (i = 0; i < sec.m_Planet.length; i++) {
					planet = sec.m_Planet[i];

					if (!IsBattle(planet, Server.Self.m_UserId, Common.RaceNone, false, true)) continue;

					for (u = 0; u < Common.ShipOnPlanetMax; u++) {
						ship = planet.m_Ship[u];

						if(ship.m_Type==Common.ShipTypeNone) continue;
						if(ship.m_Owner!=Server.Self.m_UserId) continue;
						if (ship.m_Flag & (Common.ShipFlagBomb | Common.ShipFlagBuild | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) continue;
						if (!ship.m_ItemType) continue;

						if (ship.m_ItemType == Common.ItemTypeArmour) { }
						else if (ship.m_ItemType == Common.ItemTypeArmour2) { }
						else if (ship.m_ItemType == Common.ItemTypePower) { }
						else if (ship.m_ItemType == Common.ItemTypePower2) { }
						else if (ship.m_ItemType == Common.ItemTypeRepair) { }
						else if (ship.m_ItemType == Common.ItemTypeRepair2) { }
						else if (ship.m_ItemType == Common.ItemTypeMonuk) { }
						else continue;

						a=100-ship.m_ItemCnt;
						if (a<=0 || a>100) continue;
						
						if (m_FormFleetBar.FleetSysItemGet(ship.m_ItemType) <= 0) continue;

						Server.Self.Query('emautogive', '&val=' + sx.toString() + "_" + sy.toString() + "_" + (ex - sx).toString() + "_" + (ey - sy).toString(), SendActionComplete, false);
						return;
					}
				}
			}
		}
	}
	
	private function SendGv():void
	{
		if ((m_SendGv_Time + 2000) > m_CurTime) return;
		if (Server.Self.IsSendCommand("gv")) return;
		m_SendGv_Time = m_CurTime;

		var i:int, u:int;
		var id:uint;
		var qe:QEEngine;
		var ql:Vector.<uint> = new Vector.<uint>();
		for (i = 0; i < m_UserQuestId.length; i++) {
			id = m_UserQuestId[i];
			if (id == 0) continue;
			
			for (u = 0; u < ql.length; u += 2) {
				if (ql[u] == id) break;
			}
			if (u < ql.length) continue;
			
			ql.push(id);

			qe = QEManager.FindById(id);
			if (qe == null) ql.push(0);
			else ql.push(qe.m_Anm);
		}
		for (i = 0; i < QEManager.m_EngineList.length; i++) {
			qe = QEManager.m_EngineList[i];
			if (!qe.m_StateReady) continue;

			for (u = 0; u < ql.length; u += 2) {
				if (ql[u] == qe.m_Id) break;
			}
			if (u < ql.length) continue;

			ql.push(qe.m_Id);
			ql.push(qe.m_Anm);
		}

		var flag:uint = 0;

		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;
		var sl:SaveLoad=new SaveLoad();

		sl.SaveBegin(ba);
		sl.SaveDword(flag);
		sl.SaveDword(m_UserAnm);
		sl.SaveDword(m_FleetPosAnm);
		sl.SaveDword(m_FormFleetBar.m_FleetAnm);
		sl.SaveInt(ql.length>>1)
		for (i = 0; i < ql.length; i++) sl.SaveDword(ql[i]);
		sl.SaveEnd();

		Server.Self.QuerySmallHS("gv",false,Server.sqGv,ba,RecvGv);
	}

	public var m_RecvUserAfterAnm:uint = 0;
	public var m_RecvUserAfterAnm_Time:Number = 0;

	private function RecvGv(errcode:uint, buf:ByteArray):void
	{
		if (ErrorFromServer(errcode)) return;

		var updateradar:Boolean = false;

		var vdw:uint,vdw2:uint;
		var vint:int;
		var i:int;

		var sl:SaveLoad = new SaveLoad();

		var off:int = buf.readShort();
		var offquest:int = buf.readShort();

		sl.LoadBegin(buf);
		var useranm:uint = sl.LoadDword();
		while (useranm != 0) {
			if (!(useranm >= m_RecvUserAfterAnm || (m_RecvUserAfterAnm_Time + 5000) < m_CurTime)) {
//trace("Gv skip user");
				break;
			}

			m_UserAnm = useranm;
			if (m_UserAnm >= Server.Self.m_Anm) Server.Self.m_Anm = m_UserAnm;
//trace("Gv recv user", m_UserAnm);

			var user:User = UserList.Self.GetUser(Server.Self.m_UserId, false);

			vdw = sl.LoadDword();
			vdw2 = vdw & 0xffffff00;
			if (vdw2 == 0xffffff00) {
				var tc:int = sl.LoadInt();
				var fs:Boolean = sl.LoadInt() != 0;
				m_FormBattleBar.m_WaitEnd = 1000 * sl.LoadDword();
				m_FormBattleBar.m_WaitCnt = sl.LoadInt();
				if (m_FormBattleBar.m_Search != true || m_FormBattleBar.m_Set_PlayerCnt != tc || m_FormBattleBar.m_Set_Flagship != fs) {
					m_FormBattleBar.m_Search = true;
					m_FormBattleBar.m_Set_PlayerCnt = tc;
					m_FormBattleBar.m_Set_Flagship = fs;
					updateradar = true;
				}
				vdw = 0;
			} else if (m_FormBattleBar.m_Search) {
				m_FormBattleBar.m_Search = false;
				m_FormBattleBar.m_WaitEnd = 0;
				m_FormBattleBar.m_WaitCnt = 0;
				updateradar = true;
			}
			if (vdw != m_UserCombatId) { m_UserCombatId = vdw; updateradar = true;  }

			m_HomeworldPlanetNum=sl.LoadInt();
			if(m_HomeworldPlanetNum<0) {
				m_HomeworldSectorX=0;
				m_HomeworldSectorY=0;
				m_HomeworldCotlId=0;
			} else {
				m_HomeworldSectorX=sl.LoadInt();
				m_HomeworldSectorY=sl.LoadInt();
				vint = sl.LoadInt(); if (vint != m_HomeworldCotlId) { m_HomeworldCotlId = vint; updateradar = true; }
			}

			m_HomeworldCotlX = sl.LoadInt();
			m_HomeworldCotlY = sl.LoadInt();

//trace("HomeworldIsland",m_HomeworldIsland);
			i = 0;
			while(true) {
				var citadelnum:int = sl.LoadInt();
				if (citadelnum < 0) break;
				m_CitadelNum[i] = citadelnum;
				m_CitadelSectorX[i] = sl.LoadInt();
				m_CitadelSectorY[i] = sl.LoadInt();
				vint = sl.LoadInt(); if (vint != m_CitadelCotlId[i]) { m_CitadelCotlId[i] = vint; updateradar = true; }
				m_CitadelCotlX[i] = sl.LoadInt();
				m_CitadelCotlY[i] = sl.LoadInt();
				i++;
			}
			for (; i < Common.CitadelMax; i++) {
				m_CitadelNum[i] = -1;
				m_CitadelSectorX[i] = 0;
				m_CitadelSectorY[i] = 0;
				if (m_CitadelCotlId[i] != 0) { m_CitadelCotlId[i] = 0; updateradar = true; }
				m_CitadelCotlX[i] = 0;
				m_CitadelCotlY[i] = 0;
			}

//				m_FleetPosX = sl.LoadInt();
//				m_FleetPosY = sl.LoadInt();

			user.m_Race = sl.LoadDword();
//trace("Gv: Race:", user.m_Race);
			m_UserPlanetCnt = sl.LoadInt();
			m_UserEmpirePlanetCnt = sl.LoadInt();
			m_UserEnclavePlanetCnt = sl.LoadInt();
			m_UserColonyPlanetCnt = sl.LoadInt();
			m_UserGravitorSciCnt = sl.LoadInt();
			user.m_Score = sl.LoadInt();
			user.m_Rest = sl.LoadInt();
			user.m_Exp = sl.LoadInt();
			user.m_Rating = sl.LoadInt();
			user.m_CombatRating = sl.LoadInt();
			user.m_ExitDate = 1000 * sl.LoadDword();
			m_UserKlingDestroyCnt = sl.LoadInt();
			m_UserDominatorDestroyCnt = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeTransport] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeCorvette] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeCruiser] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeDreadnought] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeInvader] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeDevastator] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeWarBase] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeShipyard] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeSciBase] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeServiceBase] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeQuarkBase] = sl.LoadInt();
			m_UserStatMineCnt = sl.LoadInt();
			m_UserAccess = sl.LoadDword();

			while (true) {
				var cptid:uint = sl.LoadDword();
				if (cptid == 0) break;

				var portalCooldown:uint=sl.LoadDword();
				var invuCooldown:uint=sl.LoadDword();
				var acceleratorCooldown:uint=sl.LoadDword();
				var coverCooldown:uint=sl.LoadDword();
				var exchangeCooldown:uint=sl.LoadDword();
				var gravitorCooldown:uint=sl.LoadDword();
				var rechargeCooldown:uint=sl.LoadDword();
				var constructorCooldown:uint=sl.LoadDword();

				var us:User = UserList.Self.GetUser(Server.Self.m_UserId);
				if (us != null/* && (m_GameState & Common.GameStateDevelopment) == 0*/) {
					var cpt:Cpt=us.AddCpt(cptid);

					cpt.m_PortalCooldown = portalCooldown * 1000;
					cpt.m_InvuCooldown = invuCooldown * 1000;
					cpt.m_AcceleratorCooldown = acceleratorCooldown * 1000;
					cpt.m_CoverCooldown = coverCooldown * 1000;
					cpt.m_ExchangeCooldown = exchangeCooldown * 1000;
					cpt.m_GravitorCooldown = gravitorCooldown * 1000;
					cpt.m_RechargeCooldown = rechargeCooldown * 1000;
					cpt.m_ConstructorCooldown = constructorCooldown * 1000;
					cpt.m_Flag = 0;
				}
			}

			for (i = 0; i < QEManager.QuestMax; i++) {
				m_UserQuestId[i] = sl.LoadDword();
			}

			break;
		}

		sl.LoadEnd();

		buf.position = off;
		m_FormFleetBar.RecvFleet(buf);
		
		buf.position = offquest;
		QEManager.RecvQuest(buf);
		
		m_StateGv = true;
//trace("StateGv");
		
//trace("RecvGv", m_HomeworldCotlId, m_HomeworldSectorX, m_HomeworldSectorY, m_HomeworldPlanetNum);
		HintNewHomeworldUpdate();

		if (updateradar) m_FormMiniMap.Update();
		if (updateradar) m_FormRadar.Update();
		if (updateradar) m_FormBattleBar.Update();
	}

	private var m_SendLoadSector_sx:int=0;
	private var m_SendLoadSector_sy:int=0;
	private var m_SendLoadSector_ex:int=0;
	private var m_SendLoadSector_ey:int = 0;
	private var m_LoadSectorAll:Boolean = false;
	
	private function SendLoadSector():void
	{
		var i:int,x:int,y:int;
		var sec:Sector;

		//trace("size "+stage.stageWidth+","+stage.stageHeight);
		//trace("topleft "+ScreenToWorldX(0)+","+ScreenToWorldY(0)+" "+Math.floor(ScreenToWorldX(0)/m_SectorSize)+","+Math.floor(ScreenToWorldY(0)/m_SectorSize));
		//trace("bottomright "+ScreenToWorldX(stage.stageWidth)+","+ScreenToWorldY(stage.stageHeight)+" "+Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+","+Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize));
		
		if (IsSpaceOff()) return; 
		if (Server.Self.m_CotlId == 0) return;
		
		if (Server.Self.IsSendCommand("sector")) return;

//			var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize)-1);
//			var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize)-1);
//			var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+2);
//			var ey:int=Math.min(m_SectorMinY+m_SectorCntY,Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize)+2);

		if (m_LoadSectorAll) {
			sx = m_SectorMinX;
			sy = m_SectorMinY;
			ex = m_SectorMinX + m_SectorCntX;
			ey = m_SectorMinY + m_SectorCntY;
		} else {
			if (!PickWorldCoord(0, 0, m_TV0)) return;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);
		}

		if(sx!=m_SendLoadSector_sx || sy!=m_SendLoadSector_sy || ex!=m_SendLoadSector_ex || ey!=m_SendLoadSector_ey) {
			if(Common.GetTime()<m_WaitAnswer2) return;
		} else {
			if(Common.GetTime()<m_WaitAnswer) return;
		}
		
		m_SendLoadSector_sx=sx;
		m_SendLoadSector_sy=sy;
		m_SendLoadSector_ex=ex;
		m_SendLoadSector_ey=ey;

		// Загружаем на единичку со всех сторон больше секторов. Чтобы видеть если корабль улетает

		//trace("x="+sx+"..."+ex+"  y="+sy+"..."+ey);

		MB_Calc();

		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;
		var sl:SaveLoad=new SaveLoad();
		sl.SaveBegin(ba);

		sl.SaveDword(Server.Self.m_ServerNum);
		sl.SaveDword(Server.Self.m_ConnNo);
		
		var fl:uint = 0;
		if (m_StateLoad) fl |= 1;
		if ((m_TxtTime + 10000) < Common.GetTime()) fl |= 1;
		if (m_Debug || m_DebugFlag != 0) fl |= 2;
		sl.SaveDword(fl);
		
		m_StateLoad = false;

		if((sx<ex) && (sy<ey) && (!HS.visible) && Server.Self.m_CotlId!=0) {
			sl.SaveInt(ex-sx);
			sl.SaveInt(ey-sy);
			sl.SaveInt(sx);
			sl.SaveInt(sy);

			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) m_Sector[i]=new Sector(x,y);
					sec=m_Sector[i];

					sl.SaveDword(sec.m_Version);
					sl.SaveDword(sec.m_VersionSlow);
//if(sec.m_SectorX == -2 && sec.m_SectorY == -10) trace("Sec.Query",sec.m_SectorX,sec.m_SectorY,"Ver:",sec.m_Version,sec.m_VersionSlow);
				}
			}
		} else {
			sl.SaveInt(0);
		}

		var offls:int = 0;
		if((!HS.visible) && Server.Self.m_CotlId!=0) {
			for (i = 0; offls < m_MB_LoadSector.length && i < 100; offls++, i++) {
				sec = m_MB_LoadSector[offls];
				if (sec.m_SectorX >= sx && sec.m_SectorX < ex && sec.m_SectorY >= sy && sec.m_SectorY < ey) continue;

				sl.SaveInt(sec.m_SectorX);
				sl.SaveInt(sec.m_SectorY);
				sl.SaveDword(sec.m_Version);
				sl.SaveDword(sec.m_VersionSlow);
			}
		}

		sl.SaveEnd();

//trace("QueryMap: ",Server.Self.m_CotlId,Server.Self.m_ServerAdr);
		Server.Self.QuerySmall("sector", true, Server.sqSector, ba, RecvMap);
		m_QueryMapTime = Common.GetTime();

		while ((!HS.visible) && (Server.Self.m_CotlId != 0) && (offls < m_MB_LoadSector.length)) {
			ba.clear();
			sl.SaveBegin(ba);

			sl.SaveDword(Server.Self.m_ServerNum);
			sl.SaveDword(Server.Self.m_ConnNo);

			fl = 0;
			sl.SaveDword(fl);

			sl.SaveInt(0);

			for (i = 0; offls < m_MB_LoadSector.length && i < 100; offls++, i++) {
				sec = m_MB_LoadSector[offls];
				if (sec.m_SectorX >= sx && sec.m_SectorX < ex && sec.m_SectorY >= sy && sec.m_SectorY < ey) continue;

				sl.SaveInt(sec.m_SectorX);
				sl.SaveInt(sec.m_SectorY);
				sl.SaveDword(sec.m_Version);
				sl.SaveDword(sec.m_VersionSlow);
			}

			sl.SaveEnd();

			Server.Self.QuerySmall("sector", true, Server.sqSector, ba, RecvMap);
		}

/*			var str:String="";//'&un='+m_UpdateSendNum;

		if((sx<ex) && (sy<ey) && (!HS.visible)) {
		//trace("x="+sx+"..."+ex+"  y="+sy+"..."+ey);
		//sx=0; sy=0;	ex=1; ey=1;
			var ls:String=null;
			var i,x,y:int;
			var sec:Sector;
			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) m_Sector[i]=new Sector(x,y);
					sec=m_Sector[i];

					if(ls==null) ls="";
					else ls+="_";
					ls+=x+"_"+y+"_"+sec.m_Version;
				}
			}
			if(ls!=null) str+="&sec="+ls; 
//trace("    SendLoadSector 01 time="+(getTimer()-t1));
		}*/

//trace("Query="+str);

		m_WaitAnswer=Common.GetTime()+SendUpdatePeriod*5;
		m_WaitAnswer2=Common.GetTime()+(SendUpdatePeriod>>2);

//			if(m_TxtTime+10000<Common.GetTime()) str+="&tv=1";
//			if(m_Debug) str+="&d=1";

//			Server.Self.Query("emmap",str,RecvMap,false);

		m_UpdateSendNum++;
	}

/*		private function RecvMap(event:Event):void
	{
		var ver:uint;

//			if(m_Sector==null) return;

		var loader:URLLoader = URLLoader(event.target);
//trace("RecvMap",loader.bytesTotal);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(ErrorFromServer(buf.readUnsignedByte())) return;*/
	
	public function ClearVerMap():void
	{
		var i:int;
		if (m_Sector == null) return;
		var cnt:int = m_SectorMinX * m_SectorMinY;
		if (m_Sector.length != cnt) return;
		for (i = 0; i < cnt; i++) {
			if (!(m_Sector[i] is Sector)) continue;
			(m_Sector[i] as Sector).m_Version = 0;
			(m_Sector[i] as Sector).m_VersionSlow = 0;
		}
	}
	
	private var m_QueryMapTime:Number = 0;

	private function RecvMap(errcode:uint, buf:ByteArray):void
	{
		var ver:uint, verslow:uint;

//			if(!m_FormNews.visible) m_FormNews.Show();

		if (Planet.PlanetCellCnt != 12) throw("Error");

		if(ErrorFromServer(errcode)) return;
		if(buf==null || buf.length<=0) throw Error("RecvMap");

		var debug:Boolean=buf.readUnsignedByte()!=0;

		var rt:Number=buf.readUnsignedInt();
		rt*=1000;
		//if(rt>m_ServerTime) {
		var nt:Number = rt;// + (new Date()).getTime() - Common.GetTime();
		var sct:Number = 1000 * buf.readUnsignedInt();

//trace("dif:", Math.abs(GetServerTime() - nt), " delay:", Common.GetTime() - m_QueryMapTime, "rt:", rt);
		if ((m_QueryMapTime + 500) > Common.GetTime()) { // Если получили быстрый ответ то можно корректировать время.
			if (Math.abs(GetServerGlobalTime() - nt) > 3000) {
				m_ServerGlobalTimeSyn = rt;
				m_ServerGlobalTimeSynRecvTime = Common.GetTime();
//trace("		newtime dif:", Math.abs(GetServerTime() - nt));
			}
			if (Math.abs(GetServerCalcTime() - sct) > 3000) {
				m_ServerCalcTimeSyn = sct;
				m_ServerCalcTimeSynRecvTime = Common.GetTime();
//trace("		newtime dif:", Math.abs(GetServerTime() - nt));
			}
		}
		
		//var urn:int=buf.readUnsignedInt();
/*			if(urn<=m_UpdateRecvNum) return;
		if(urn<m_SendActionAfterRecvNum) {
//trace("RecvMap Cancel. SendNum="+m_UpdateSendNum+" RecvNum="+m_UpdateRecvNum+" SendActionAfterRecvNum="+m_SendActionAfterRecvNum+" urn="+urn);

			return; // Если была отправлен action то нужно принимать карты только те на которые был отправлен запрос после отправки action-а.
		} 
		m_UpdateRecvNum=urn;
//trace("RecvMap Ok. SendNum="+m_UpdateSendNum+" RecvNum="+m_UpdateRecvNum+" SendActionAfterRecvNum="+m_SendActionAfterRecvNum);
*/
		ver = buf.readUnsignedShort();
		if(ver!=m_WorldVer) {
			Reenter();
			return;
		}

		ver = buf.readUnsignedShort();
		if (ver != m_StateVer) {
			m_StateVer = ver;
			m_StateLoad = true;
		}

		var cotlid:uint=buf.readUnsignedInt();

		if(buf.readUnsignedInt()!=m_UserVersion) QuerySessionUser();

		ver=buf.readUnsignedInt();
		if(ver!=m_FormMiniMap.m_MapVersion) { m_FormMiniMap.m_MapVersion=ver; m_FormMiniMap.QueryOwner(); }

		ver=buf.readUnsignedInt();
		if(ver>m_RelVersion) { m_RelVersion=ver; QueryRel(); }

		ver=buf.readUnsignedInt();
		if(ver>m_FormChat.m_OnlineUserVersion) { m_FormChat.m_OnlineUserVersion=ver; m_FormChat.QueryOnlineUser(); }

//			ver=buf.readUnsignedInt();
//			if(/*m_FormFleetBar.m_OrderWaitEnd.length<=0 &&*/ (ver>m_FormFleetBar.m_FleetVersion) && (m_FormFleetBar.m_LoadFleetLock<=0)) { m_FormFleetBar.m_FleetVersion=ver; m_FormFleetBar.QueryFleet(); }

//			ver = buf.readUnsignedInt();
//			if (ver > m_FormCombat.m_CombatVer) { /*m_FormCombat.m_CombatVer = ver;*/ m_FormCombat.QueryCombat(); }

		var f:uint = buf.readUnsignedByte();
		if ((f & 1) != 0) {
			m_TxtTime=Common.GetTime();
			ver=buf.readUnsignedInt();
			if(ver>m_TxtVersion) { m_TxtVersion=ver; QueryTxt(); }
//trace("m_TxtVersion:",m_TxtVersion);

			ver=buf.readUnsignedInt();
			if(ver>m_TxtCotlVersion) { m_TxtCotlVersion=ver; QueryTxtCotl(); }
//trace("m_TxtCotlVersion:",m_TxtCotlVersion);

			ver=buf.readUnsignedInt();
			if (ver > m_ItemVersion) { m_ItemVersion = ver; UserList.Self.ItemClear(); }

			ver = buf.readUnsignedInt();
			if (ver > m_FormNews.m_NewsForUserVer) m_FormNews.NewsForUserQuery();

			m_GameState=buf.readUnsignedInt();
			m_GameTime=buf.readUnsignedInt();

			m_CotlUnionId=buf.readUnsignedInt();
			m_CotlZoneLvl=buf.readInt();
			
			ver=buf.readUnsignedInt();
			if (ver > m_TeamRelVer) { m_TeamRelVer = ver; QueryTeamRel(); }
			
			m_PlanetDestroy = buf.readByte();
		}
		
		if ((f & 2) != 0) {
			m_DefScore = buf.readInt();
			m_AtkScore = buf.readInt();
		} else {
			m_DefScore = 0;
			m_AtkScore = 0;
		}

		if ((f & 4) != 0) {
			m_AllPlanetCnt = buf.readShort();
			m_BasePlanetCnt = buf.readShort();
			m_BaseSectorX = buf.readShort();
			m_BaseSectorY = buf.readShort();
			m_BasePlanetNum = buf.readByte();
		} else {
			m_AllPlanetCnt = 0;
			m_BasePlanetCnt = 0;
			m_BaseSectorX = 0;
			m_BaseSectorY = 0;
			m_BasePlanetNum = -1;
		}

var tm0:int=System.totalMemory;

		m_ActionNoComplate=buf.readUnsignedInt();
//trace(Server.Self.m_ConnNo,"=",m_ActionNoComplate);

		//m_FleetPosX = buf.readUnsignedInt();
		//m_FleetPosY = buf.readUnsignedInt();
//trace(m_FleetPosX,m_FleetPosY);

		var x:int,y:int,size:int,newpos:int,i:int,u:int,t:int,planetcnt:int;
		var ndm:Boolean=false;
		var sl:SaveLoad=new SaveLoad();
		var sec:Sector;
		var planet:Planet;
		var ship:Ship;
		var fl:uint;
		var slow:Boolean;
		var dw:uint;
		
		var lastuser:User=null;

		//planet=new Planet();
		
		var lsc:int = 0;

//trace("RecvMap begin",cotlid,Server.Self.m_CotlId);
		while(cotlid==Server.Self.m_CotlId && m_Sector!=null) {
			newpos=buf.position;
			size=buf.readUnsignedShort();
//trace(size);
			if(size==0) break;
			newpos+=size;
			var content:Boolean=size>(2+12);

			//ver=buf.readUnsignedInt();
			//if(ver!=GameVersion) { ndm=true; break; }
			ver = buf.readUnsignedInt();
			verslow = buf.readUnsignedInt();
			//size=buf.readUnsignedInt();
			x=buf.readShort();
			y=buf.readShort();
//trace("    Sector",x,y,size,ver,verslow);
//if(x == -2 && y == -10) trace("Sec.Answer",x,y,"Ver:",ver,verslow,"Size:",size,"Content:",content);

			i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
			if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
			if(!(m_Sector[i] is Sector)) m_Sector[i]=new Sector(x,y);
			sec=m_Sector[i];
			sec.m_UpdateTime=Common.GetTime();
			sec.m_Off = false;

			lsc++;

//if(m_ActionNoComplate<sec.m_LoadAfterAfterActionNo && content) trace("Skip sector",x,y);
			if((m_ActionNoComplate>=sec.m_LoadAfterActionNo || (sec.m_LoadAfterActionNo_Time+5000)<Common.GetTime()) &&/*ver>sec.m_LoadAfterVersion && */content) {
				sec.m_Version = ver;
				sec.m_VersionSlow = verslow;
//trace("Sector x="+x+" y="+y+" v="+ver+" size="+size);

				//sec.m_Planet.length=0;

				sl.LoadBegin(buf);
				
				fl = sl.LoadDword();
				slow=(fl&1)!=0;
//if(x == -2 && y == -10) trace("Sec.Answer Slow:",slow);

//					sec.m_WormholeNextDate=sl.LoadDword();
//					sec.m_WormholeNextDate*=1000;
//					sec.m_WormholeTgtSectorX=sl.LoadInt();
//					sec.m_WormholeTgtSectorY=sl.LoadInt();
//trace("Wormhole",sec.m_WormholeNextDate,sec.m_WormholeTgtSectorX,sec.m_WormholeTgtSectorY);

				planetcnt=0;
				while(true) {
					x=sl.LoadInt();
					if(!x) break;
					y=sl.LoadInt();

					if(planetcnt>=sec.m_Planet.length) sec.m_Planet.push(new Planet(sec,planetcnt));
					planet=sec.m_Planet[planetcnt];
					planetcnt++;

					planet.m_Path=0;
					//planet.m_ConstructionPoint=0;
					planet.m_LevelBuy=0;

					planet.m_PosX=x;
					planet.m_PosY=y;
					planet.m_Flag = sl.LoadDword();
					planet.m_ATT = sl.LoadDword();
//if(planet.m_Flag & Planet.PlanetFlagWormhole) trace("RecvWormhole", planet.m_PosX, planet.m_PosY);

					planet.m_Owner=sl.LoadDword();
					if(planet.m_Owner!=0 && (lastuser==null || lastuser.m_Id!=planet.m_Owner)) lastuser=UserList.Self.GetUser(planet.m_Owner,false,true); 
					
					planet.m_Level = sl.LoadInt();
					planet.m_LevelBuy = sl.LoadInt();
					planet.m_Race = sl.LoadDword();
					//if(IsEdit()) planet.m_ConstructionPoint=sl.LoadInt();
					//else sl.LoadInt(); // ConstructionPoint
					planet.m_OreItem=sl.LoadDword();
					planet.m_ShieldVal=sl.LoadDword();
					planet.m_ShieldEnd = sl.LoadDword() * 1000;
					planet.m_Radiation = sl.LoadInt();
					planet.m_Island = sl.LoadDword();

					if ((m_CotlType == Common.CotlTypeRich) && (planet.m_Flag & Planet.PlanetFlagEnclave) != 0) {
						planet.m_EPS_Val = sl.LoadInt();
						if (planet.m_Flag & Planet.PlanetFlagLocalShield) {
							planet.m_EPS_AtkPower = sl.LoadInt();
							planet.m_EPS_TimeOff = sl.LoadDword();
						}
					}

					planet.m_PortalPlanet=sl.LoadDword();
					if(planet.m_PortalPlanet!=0) {
						planet.m_PortalSectorX=sl.LoadInt();
						planet.m_PortalSectorY=sl.LoadInt();
						planet.m_PortalCnt=sl.LoadInt();
						planet.m_PortalOwner=sl.LoadDword();
						planet.m_PortalCotlId=sl.LoadDword();
					} else {
						planet.m_PortalSectorX=0;
						planet.m_PortalSectorY=0;
						planet.m_PortalCnt=0;
						planet.m_PortalOwner=0;
						planet.m_PortalCotlId=0;
					}
					if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge) || (planet.m_Flag & Planet.PlanetFlagWormhole) != 0) {
						planet.m_NeutralCooldown=1000*sl.LoadDword();
					} else {
						planet.m_NeutralCooldown=0;
					}
					
					planet.m_Path = sl.LoadDword();
					planet.m_Route0=sl.LoadDword();
					planet.m_Route1=sl.LoadDword();
					planet.m_Route2=sl.LoadDword();

					if (IsEdit() || m_CotlType == Common.CotlTypeCombat) {
						planet.m_Team=sl.LoadInt();
					}

					//if (planet.m_Flag & (Planet.PlanetFlagGravitorSciPrepare | Planet.PlanetFlagGravitor))
					planet.m_GravitorTime = 1000 * sl.LoadDword();
					if (planet.m_Flag & (Planet.PlanetFlagGravitorSciPrepare | Planet.PlanetFlagGravitorSci | Planet.PlanetFlagGravitor)) planet.m_GravitorOwner = sl.LoadDword();

					planet.m_VisTime = 1000 * sl.LoadDword();
					if (IsEdit()) planet.m_FindMask = sl.LoadDword();

//						planet.m_AutoBuildType=sl.LoadInt();
//						if(planet.m_AutoBuildType!=0 || IsEdit()) {
//							planet.m_AutoBuildCnt=sl.LoadInt();
//							planet.m_AutoBuildTime=sl.LoadInt();
//							planet.m_AutoBuildWait=sl.LoadInt();
//						} else {
//							planet.m_AutoBuildCnt=0;
//							planet.m_AutoBuildTime=0;
//							planet.m_AutoBuildWait=0;
//						}
					planet.m_Refuel=sl.LoadInt();

					if (m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeCombat) planet.m_LandingPlace = sl.LoadInt();

					if (planet.m_Flag & Planet.PlanetFlagGravWell) planet.m_GravWellCooldown = 1000 * sl.LoadDword();
					else planet.m_GravWellCooldown = 0;

					if (planet.m_Flag & Planet.PlanetFlagPotential) planet.m_PotentialCooldown = 1000 * sl.LoadDword();
					else planet.m_PotentialCooldown = 0;

					i = 0;
					while (true) {
						var e_type:uint = sl.LoadDword();
						if (e_type == 0) break;
						var e:BtlEvent = null;
						if (i < planet.m_BtlEvent.length) {
							e = planet.m_BtlEvent[i];
						} else {
							e = new BtlEvent();
							planet.m_BtlEvent.push(e);
						}
						i++;

						e.m_Type = e_type;
						e.m_Time = 1000*sl.LoadDword();
						e.m_Slot = sl.LoadDword();
						e.m_Id = sl.LoadDword();
					}
					if (i < planet.m_BtlEvent.length) planet.m_BtlEvent.splice(i, planet.m_BtlEvent.length - i);

					if (slow) {
						planet.m_CellBuildFlag = sl.LoadDword();
						planet.m_CellBuildEnd = 1000 * sl.LoadDword();
						dw = sl.LoadDword();
						planet.m_Cell[0] = dw & 255;
						planet.m_Cell[1] = (dw>>8) & 255;
						planet.m_Cell[2] = (dw>>16) & 255;
						planet.m_Cell[3] = (dw>>24) & 255;
						dw = sl.LoadDword();
						planet.m_Cell[4] = dw & 255;
						planet.m_Cell[5] = (dw>>8) & 255;
						planet.m_Cell[6] = (dw>>16) & 255;
						planet.m_Cell[7] = (dw>>24) & 255;
						dw = sl.LoadDword();
						planet.m_Cell[8] = dw & 255;
						planet.m_Cell[9] = (dw>>8) & 255;
						planet.m_Cell[10] = (dw>>16) & 255;
						planet.m_Cell[11] = (dw >> 24) & 255;

						for (i = 0; i < Planet.PlanetItemCnt; i++) {
							planet.m_Item[i].m_Type = 0;
							planet.m_Item[i].m_Cnt = 0;
							planet.m_Item[i].m_Complete = 0;
							planet.m_Item[i].m_Broken = 0;
							planet.m_Item[i].m_Flag = 0;
						}

						while (true) {
							var pit:uint = sl.LoadDword();
							if (pit == 0) break;
							i = sl.LoadDword();
							planet.m_Item[i].m_Type = pit;
							planet.m_Item[i].m_Cnt = sl.LoadInt();
							planet.m_Item[i].m_Owner = sl.LoadDword();
							planet.m_Item[i].m_Complete = sl.LoadInt();
							planet.m_Item[i].m_Broken = sl.LoadInt();
							planet.m_Item[i].m_Flag = sl.LoadDword();
						}

						planet.m_Engineer = sl.LoadDword();
						planet.m_Machinery = sl.LoadDword();
						if (debug) planet.m_EngineerNeed = sl.LoadInt();
						if (debug) planet.m_MachineryNeed = sl.LoadInt();
						if (debug) planet.m_SupplyUse = sl.LoadDword();
					}
					
					if(debug) {
						planet.m_AISpace = sl.LoadInt();
						planet.m_AIProtect = sl.LoadInt();
						planet.m_AIFromCenter=sl.LoadDword();
						planet.m_AINeedTransport=sl.LoadDword();
						planet.m_AINeedInvader=sl.LoadDword();
						planet.m_AINeedCorvette=sl.LoadDword();
						planet.m_AINeedCruiser=sl.LoadDword();
						planet.m_AINeedDreadnought=sl.LoadDword();
						planet.m_AINeedDevastator=sl.LoadDword();
					}

					//trace("    Planet x="+x+" y="+y);

					for(i=0;i<Common.ShipOnPlanetMax;i++) {
						ship=planet.m_Ship[i];
						ship.m_Type=Common.ShipTypeNone;
//							ship.m_DestroyTime=0;
						ship.m_ItemType=Common.ItemTypeNone;
						ship.m_OrbitItemType=Common.ItemTypeNone;
						ship.m_OrbitItemCnt=0;
						ship.m_OrbitItemOwner=0;
						ship.m_OrbitItemTimer = 0;
						ship.m_InvuFromId = 0;
						ship.m_AbilityCooldown0 = 0;
						ship.m_AbilityCooldown1 = 0;
						ship.m_AbilityCooldown2 = 0;
					}

					while(true) {
						u=sl.LoadDword();
						if(!u) break;
						u--;
						ship=planet.m_Ship[u];

//							ship.m_DestroyTime=sl.LoadDword();
//							ship.m_DestroyTime*=1000;

						ship.m_Type=sl.LoadDword();
						if(ship.m_Type!=Common.ShipTypeNone) {
							ship.m_Id=sl.LoadDword();

							ship.m_Owner=sl.LoadDword();
							if(ship.m_Owner!=0 && (lastuser==null || lastuser.m_Id!=ship.m_Owner)) lastuser=UserList.Self.GetUser(ship.m_Owner,false,true); 

							//ship.m_FleetCptId=sl.LoadDword();
							ship.m_Race=sl.LoadDword();
							ship.m_ArrivalTime=sl.LoadDword();
							ship.m_ArrivalTime*=1000;
							ship.m_FromSectorX=sl.LoadInt();
							ship.m_FromSectorY=sl.LoadInt();
							ship.m_FromPlanet=sl.LoadDword();
							ship.m_FromPlace=sl.LoadDword();
							ship.m_Cnt=sl.LoadInt();
							ship.m_CntDestroy=sl.LoadInt();
							ship.m_HP=sl.LoadInt();
							ship.m_Shield = sl.LoadInt();
							ship.m_CargoType = sl.LoadDword();
							if (ship.m_CargoType != 0) ship.m_CargoCnt = sl.LoadInt();
							else ship.m_CargoCnt = 0;
							ship.m_BattleTimeLock=sl.LoadDword();
							ship.m_BattleTimeLock*=1000;
							ship.m_Fuel=sl.LoadDword();
							ship.m_Flag = sl.LoadDword();
							ship.m_Link = sl.LoadDword();
							if (IsEdit()) {
								ship.m_Group = sl.LoadDword();
							}
							else ship.m_Group=0;

							if ((ship.m_Flag & (Common.ShipFlagInvu | Common.ShipFlagInvu2)) != 0) ship.m_InvuFromId = sl.LoadDword();
							if (ship.m_Type == Common.ShipTypeQuarkBase || ((ship.m_Race == Common.RaceGaal) && (ship.m_Type != Common.ShipTypeFlagship) && (!Common.IsBase(ship.m_Type)))) ship.m_AbilityCooldown0 = 1000 * sl.LoadDword();
							else if (ship.m_Race == Common.RacePeleng && ship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(ship.m_Type)) ship.m_AbilityCooldown0 = 1000 * sl.LoadDword();
							if (ship.m_Type == Common.ShipTypeQuarkBase) ship.m_AbilityCooldown1 = 1000 * sl.LoadDword();
							if (ship.m_Type == Common.ShipTypeQuarkBase) ship.m_AbilityCooldown2 = 1000 * sl.LoadDword();

							if(ship.m_Type==Common.ShipTypeFlagship) {
//trace("flagship",u);
								var us:User=UserList.Self.GetUser(ship.m_Owner,false);
								//var cpt:Cpt=us.AddCpt(ship.m_Id);
								var cpt:Cpt = us.GetCpt(ship.m_Id);
								if (cpt != null) {
									cpt.m_PortalCooldown=sl.LoadDword()*1000;
									cpt.m_InvuCooldown=sl.LoadDword()*1000;
									cpt.m_AcceleratorCooldown=sl.LoadDword()*1000;
									cpt.m_CoverCooldown=sl.LoadDword()*1000;
									cpt.m_ExchangeCooldown=sl.LoadDword()*1000;
									cpt.m_GravitorCooldown=sl.LoadDword()*1000;
									cpt.m_RechargeCooldown=sl.LoadDword()*1000;
									cpt.m_ConstructorCooldown = sl.LoadDword() * 1000;
									cpt.m_Flag = sl.LoadDword();
								} else {
									sl.LoadDword();
									sl.LoadDword();
									sl.LoadDword();
									sl.LoadDword();
									sl.LoadDword();
									sl.LoadDword();
									sl.LoadDword();
									sl.LoadDword();
									sl.LoadDword();
								}
							}

							ship.m_Path=sl.LoadDword();
						}

						ship.m_ItemType=sl.LoadDword();
						if(ship.m_ItemType!=Common.ItemTypeNone) {
							ship.m_ItemCnt=sl.LoadDword();
						}

						ship.m_OrbitItemType=sl.LoadDword();
						if(ship.m_OrbitItemType!=Common.ItemTypeNone) {
							ship.m_OrbitItemOwner=sl.LoadDword();
							ship.m_OrbitItemTimer=sl.LoadDword();
							ship.m_OrbitItemTimer*=1000;
							ship.m_OrbitItemCnt=sl.LoadDword();
//trace("OrbitItem",ship.m_OrbitItemType,ship.m_OrbitItemCnt);
						}
//trace("load ship cnt="+ship.m_Cnt);
					}
				}
				sl.LoadEnd();

				if(planetcnt<sec.m_Planet.length) sec.m_Planet.splice(planetcnt,sec.m_Planet.length-planetcnt);
				
				sec.m_Infl=buf.readUnsignedInt();

/*					while(true) {
					var planetnum:int=buf.readUnsignedByte();
					if(planetnum==0) break;
					planetnum--;
					if(planetnum>=sec.m_Planet.length) throw Error("data");
					planet=sec.m_Planet[planetnum];
					planet.m_Path=buf.readUnsignedByte();
//						planet.m_ConstructionPoint=buf.readInt();
					planet.m_LevelBuy=buf.readUnsignedShort();
				}*/

				ndm = true;

			} else {
//trace("RecvSector Cancel. ver="+ver+" LoadAfterVersion="+sec.m_LoadAfterVersion);

			}

			buf.position=newpos;
		}
		
		m_StateSector = true;

		if(ndm) {
			Update();
		}

//trace(lsc);
		if (m_LoadSectorAll && lsc == m_SectorCntX * m_SectorCntY) {
			m_LoadSectorAll = false;
			EditMapShowStat();
		}

		DeleteOldShip();
		
		//m_BG.ILUpdate();

		m_WaitAnswer=Common.GetTime()+SendUpdatePeriod;
//trace("    RecvMap complate "+m_NoCacheNo+" time="+(getTimer()-t1));
	}

	public function DeleteOldShip():void
	{
		var u:int;
		var k:int;
		var planet:Planet;
		var ship:Ship;
		var sec:Sector;
		
		if(m_Sector==null) return;

		if (m_Action == ActionPathMove) return;
		if (m_Action == ActionPortal) return;
		if (m_Action == ActionLink || m_Action == ActionEject) return;
		if (m_Action == ActionWormhole) return;

//			var sx:int=Math.max(m_SectorMinX,Math.floor(ScreenToWorldX(0)/m_SectorSize)-1);
//			var sy:int=Math.max(m_SectorMinY,Math.floor(ScreenToWorldY(0)/m_SectorSize)-1);
//			var ex:int=Math.min(m_SectorMinX+m_SectorCntX,Math.floor(ScreenToWorldX(stage.stageWidth)/m_SectorSize)+2);
//			var ey:int=Math.min(m_SectorMinY+m_SectorCntY,Math.floor(ScreenToWorldY(stage.stageHeight)/m_SectorSize)+2);
		if (!PickWorldCoord(0, 0, m_TV0)) return;
		if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return;
		if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return;
		if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return;
		var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
		var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
		var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
		var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

		var ct:Number=Common.GetTime();
		var i:int=m_Sector.length-1;
		while(i>=0) {
			if(m_Sector[i] is Sector) {
				sec=m_Sector[i];

				if(sec.m_SectorX>=sx && sec.m_SectorX<ex && sec.m_SectorY>=sy && sec.m_SectorY<ey) {
				}
				else if(sec.m_UpdateTime!=0 && (sec.m_UpdateTime+4000<ct)) {
					sec.m_Off=true;

/*						sec.m_UpdateTime=0;
					sec.m_LoadAfterVersion=0;
					sec.m_Version=0;

					for(u=0;u<sec.m_Planet.length;u++) {
						planet=sec.m_Planet[u];
						for(k=0;k<planet.m_Ship.length;k++) {
							ship=planet.m_Ship[k];
							ship.m_Type=Common.ShipTypeNone;
							ship.m_ItemType=Common.ItemTypeNone;
						}
					}*/

				}
			}
			i--;
		}
	}
	
	public function QueryTeamRel():void
	{
			Server.Self.Query("emteamrel","",AnswerTeamRel,false);	
	}
	
	public function AnswerTeamRel(event:Event):void
	{
		var i:int,cnt:int;

		var loader:URLLoader = URLLoader(event.target);
		
		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;
		
		if(ErrorFromServer(buf.readUnsignedByte())) return;
		
		LoadTeamRel(buf);

/*			var ver:uint=buf.readUnsignedInt();
trace("AnswerTeamRel",ver);

		cnt=(1<<Common.TeamMaxShift)*(1<<Common.TeamMaxShift);
		
		m_TeamRelVer=ver;
		if(m_TeamRelVer!=0) {
			for(i=0;i<cnt;i++) m_TeamRel[i]=buf.readUnsignedByte();
		} else {
			for(i=0;i<cnt;i++) m_TeamRel[i]=0;
		}*/
	}

	public function QueryTxt():void
	{
		Server.Self.Query("emtxt","&gt=1&gk=0&val="+Server.Self.m_Lang.toString(),AnswerTxt,false);
	}

	public function QueryTxtCotl():void
	{
		var cotlid:uint = TxtRemapCotl(Server.Self.m_CotlId);
		Server.Self.Query("emtxt", "&gt=2&gk=" + cotlid.toString() + "&val=" + Server.Self.m_Lang.toString(), AnswerTxt, false);
	}

	public function AnswerTxt(event:Event):void
	{
		var i:int,cnt:int;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(ErrorFromServer(buf.readUnsignedByte())) return;

		var gt:uint=buf.readUnsignedInt();
		var gk:uint=buf.readUnsignedInt();
		var lang:int=buf.readUnsignedByte();
		
		if(buf.position>=buf.length) return;
		
		var ver:uint=buf.readUnsignedInt();
		var size:uint=buf.readUnsignedInt();
//trace("AnswerTxt size=",size,"ver=",ver,"gt=",gt,"gk=",gk,"lang=",lang);

		var cotlid:uint = TxtRemapCotl(Server.Self.m_CotlId);

		if(gt==1) {
			m_TxtVersion=ver;
			m_Txt.length=0;
			if(size<=0) return;
			buf.readBytes(m_Txt,0,size);
			m_Txt.uncompress();
			
			if(m_FormItemManager.visible) m_FormItemManager.UpdateItem(); 

		} else if(gt==2 && gk==cotlid) {
			m_TxtCotlVersion=ver;
			m_TxtCotl.length=0;
			if(size<=0) return;
			buf.readBytes(m_TxtCotl,0,size);
			m_TxtCotl.uncompress();
		}
//trace(TxtItf(1));
//trace(TxtItf(2));
	}

	public function TxtSys(txt:ByteArray, type:int, vkey:uint):String
	{
		if(txt.length<=4) return "";
		txt.position=0;
		var cnt:int=txt.readUnsignedInt();
		if(cnt<=0) return "";
//if(txt==m_TxtEng) trace("cnt:",cnt);

		var cv:int;
		var v:uint;

		var istart:int=0;
		var iend:int=cnt-1;
		while(true) {
			var icur:int=istart+((iend-istart) >> 1);
			txt.position=4+icur*12;
			v=txt.readUnsignedInt();
//if(txt==m_TxtEng) trace("icur:",icur,"v:",v);

			if(type<v) cv=-1;
			else if(type>v) cv=1;
			else {
				v=txt.readUnsignedInt();
//if(txt==m_TxtEng) trace("v2:",v);
				if(vkey<v) cv=-1;
				else if(vkey>v) cv=1;
				else cv=0;
			}
			if(cv==0) {
				v=txt.readUnsignedInt();
//if(txt==m_TxtEng) trace("off:",v);
				txt.position=4+cnt*12+v;
				v=txt.readUnsignedShort();
				return txt.readUTFBytes(v);
			}
			else if(cv<0) iend=icur-1;
			else istart=icur+1;
			if(iend<istart) return "";
		}
		return "";
	}
	
	public function TxtFind(txt:ByteArray, type:int, find_str:String):uint
	{
		var tkey:uint;
		var i:int;
		
		find_str = find_str.toLocaleLowerCase();

		if(txt.length<=4) return 0;
		txt.position=0;
		var cnt:int=txt.readUnsignedInt();
		if(cnt<=0) return 0;
		
		var cv:int;
		var v:uint;

		var istart:int=0;
		var iend:int=cnt-1;
		while(true) {
			var icur:int=istart+((iend-istart) >> 1);
			txt.position=4+icur*12;
			v=txt.readUnsignedInt();

			if(type<v) cv=-1;
			else if(type>v) cv=1;
			else {
				for (i = icur; i < cnt; i++) {
					txt.position = 4 + i * 12;
					if (txt.readUnsignedInt() != type) break;
					tkey = txt.readUnsignedInt();
					v = txt.readUnsignedInt();
					
					txt.position=4+cnt*12+v;
					v=txt.readUnsignedShort();
					if (txt.readUTFBytes(v).toLocaleLowerCase() == find_str) return tkey;
				}
				
				for (i = icur-1; i >= 0; i--) {
					txt.position = 4 + i * 12;
					if (txt.readUnsignedInt() != type) break;
					tkey = txt.readUnsignedInt();
					v = txt.readUnsignedInt();
					
					txt.position=4+cnt*12+v;
					v=txt.readUnsignedShort();
					if (txt.readUTFBytes(v).toLocaleLowerCase() == find_str) return tkey;
				}
				return 0;
			}

			if(cv==0) {
				return 0;
			}
			else if(cv<0) iend=icur-1;
			else istart=icur+1;
			if(iend<istart) return 0;
		}
		return 0;
	}

	public function TxtRemapCotl(cotlid:uint):uint
	{
		if (cotlid == Server.Self.m_CotlId && m_CotlType == Common.CotlTypeUser && (m_GameState & Common.GameStateTraining) != 0) return Common.TrainingCotlId;
		else if (m_CotlType == Common.CotlTypeCombat && m_CotlOwnerId != 0) cotlid = m_CotlOwnerId;
		return cotlid;
	}

	public function Txt(type:int, vkey:int):String		{ return TxtSys(m_Txt, type, vkey); }
	public function Txt_CotlPfx(cotlid:uint):String		{ return TxtSys(m_Txt,9,cotlid); }
	public function Txt_CotlName(cotlid:uint):String	{ return TxtSys(m_Txt,1,cotlid); }
	public function Txt_CotlDesc(cotlid:uint):String	{ return TxtSys(m_Txt,2,cotlid); }
	public function Txt_ItemName(itemid:uint):String	{ return TxtSys(m_Txt,7,itemid & 0xffff); }
	public function Txt_ItemDesc(itemid:uint):String	{ return TxtSys(m_Txt,8,itemid); }
	public function TxtCotl_PlanetName(secx:int, secy:int, num:int):String	{ return TxtSys(m_TxtCotl,1,((8192+secx)<<(14+2))+((8192+secy)<<(2))+num); }
	public function TxtCotl_PlanetDesc(secx:int, secy:int, num:int):String	{ return TxtSys(m_TxtCotl,2,((8192+secx)<<(14+2))+((8192+secy)<<(2))+num); }
	public function Txt_CotlOwnerName(cotlid:uint, owner:uint, full:Boolean = false):String
	{
		var str:String = "";
		if (owner == Common.OwnerAI0) { str = TxtSys(m_Txt, 3, TxtRemapCotl(cotlid)); if (str.length <= 0) str = Common.TxtEdit.OwnerAI0; }
		else if (owner == Common.OwnerAI1) { str = TxtSys(m_Txt, 4, TxtRemapCotl(cotlid)); if (str.length <= 0) str = Common.TxtEdit.OwnerAI1; }
		else if (owner == Common.OwnerAI2) { str = TxtSys(m_Txt, 5, TxtRemapCotl(cotlid)); if (str.length <= 0) str = Common.TxtEdit.OwnerAI2; }
		else if (owner == Common.OwnerAI3) { str = TxtSys(m_Txt, 6, TxtRemapCotl(cotlid)); if (str.length <= 0) str = Common.TxtEdit.OwnerAI3; }
		else if (owner != 0) {
			var user:User = UserList.Self.GetUser(owner);
			if (user != null) {
				str = user.m_SysName;
				if ((user.m_Flag & Common.UserFlagAccountFull) == 0) {
					str += "*";
					if (full) {
						var dw:uint = CRC32.calc(0, owner.toString());
						str += (dw % (36 * 36)).toString(36);
					}
				}
			}
			else str = "-" + Common.Txt.Load + "-";
		}

		return str;
	}

	public function Txt_CptName(cotlid:uint, owner:uint, cptid:uint):String
	{
		var str:String = "";
		if (owner & Common.OwnerAI) {
			str = TxtSys(m_Txt, 224 + (owner & 3) * 4 + (cptid & 3), TxtRemapCotl(cotlid));
			if (str.length <= 0) {
				if ((cptid & 3) == 0) str = Common.TxtEdit.CptAI0;
				else if ((cptid & 3) == 1) str = Common.TxtEdit.CptAI1;
				else str = Common.TxtEdit.CptAI2;
			}
		} else if (owner != 0) {
			if (owner == Server.Self.m_UserId) {
				var objcd:Object = m_FormCptBar.CptDsc(cptid);
				if (objcd != null) str = objcd.Name;
			} else {
				var user:User = UserList.Self.GetUser(owner);
				if (user != null) {
					var cpt:Cpt = user.GetCpt(cptid);
					if (cpt != null && cpt.m_Name != null) {
						str = cpt.m_Name;
					}
				}
			}
		}
		return str;
	}

	public function CotlName(id:uint, full:Boolean=false):String
	{
		var str:String="";

		var cotl:SpaceCotl = HS.GetCotl(id);
		//if (cotl == null) return "-";

		if(full) {
			var pfx:String = Txt_CotlPfx(id);
			if (pfx.length > 0) str += pfx + " ";
		}

		str += Txt_CotlName(id);
//			if(cotl.m_Type==Common.CotlTypeRich) { str=Common.Txt.CotlRich+" "+str; }
		if (cotl!=null && str == '' && cotl.m_CotlType == Common.CotlTypeUser) {
			if(full) str = Common.Txt.CotlUser+" ";

			var user:User=null;
			if (cotl.m_CotlType == Common.CotlTypeUser) user = UserList.Self.GetUser(cotl.m_AccountId);
			if(user!=null) str+=EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
		}
		if(str=='') str='-';
		return str;
	}

	public function QueryRel():void
	{
		Server.Self.Query("emrel",'',AnswerRel,false);
	}

	public function AnswerRel(event:Event):void
	{
		var i:int;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(ErrorFromServer(buf.readUnsignedByte())) return;

		m_RelVersion=buf.readUnsignedInt();
		var size:uint=buf.readUnsignedInt();
//trace("AnswerRel size=",size);

		m_Rel.length=0;
		if(size<=0) return;
		buf.readBytes(m_Rel,0,size);
		m_Rel.uncompress();
		
		m_RelOwnerNum = new Dictionary();
		m_Rel.position=0;
		var cnt:int = m_Rel.readUnsignedInt();
		m_RelCnt = cnt;
		for(i=0;i<cnt;i++) {
			var own:uint = m_Rel.readUnsignedInt();
			m_RelOwnerNum[own] = i;
		}
	}
/*Error: Error #2030: Обнаружен конец файла.
at flash.utils::ByteArray/readBytes()
at EmpireMap/AnswerRel()
at flash.events::EventDispatcher/dispatchEventFunction()
at flash.events::EventDispatcher/dispatchEvent()
at flash.net::URLLoader/onComplete()*/

	public function QuerySessionUser():void
	{
		var uid:uint=0;
		var so:SharedObject = SharedObject.getLocal("EGEmpireData");
		if(so!=null && so.size!=0 && so.data.uid!=undefined) uid=so.data.uid;

		if(uid==0) {
			ErrorFromServer(0,Common.Txt.NoCacheFlash);
			return;
		}

//trace(uid);
//			Server.Self.Query("emsuser","&id="+uid.toString(),AnswerSessionUser,false);

		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;
		var sl:SaveLoad=new SaveLoad();
		sl.SaveBegin(ba);

		sl.SaveDword(Server.Self.m_ServerNum);
		sl.SaveDword(Server.Self.m_ConnNo);
		sl.SaveDword(uid);

		sl.SaveEnd();

		Server.Self.QuerySmall("emsuser",true,Server.sqSUser,ba,AnswerSessionUser);
	}

/*		public function AnswerSessionUser(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint=buf.readUnsignedByte();*/
	private function AnswerSessionUser(errcode:uint, buf:ByteArray):void
	{
		var i:int, u:int, cnt:int, vint:int;
		var ver:uint, vdw:uint;
		
		if (errcode == Server.ErrorBan) {
			var s:String = "";
			var bdate:uint = buf.readUnsignedInt();
			if (bdate == 0xffffffff) {
				s="\n"+Common.Txt.Ban;
			} else {
				s = "\n" + Common.Txt.BanDate;
				s = BaseStr.Replace(s, "<Val>", Common.FormatPeriodLong(bdate));
			}

			ErrorFromServer(0,s);
			return;
		}

		if(ErrorFromServer(errcode)) return;
		if(buf==null || buf.length<=0) throw Error("AnswerSessionUser");

		if(!(m_ActionNoComplate>=m_LoadUserAfterActionNo || (m_LoadUserAfterActionNo_Time+5000)<Common.GetTime())) {
//trace("skip session user");
			return;
		}

		m_UserVersion=buf.readUnsignedInt();

		//var user:User=m_UserList[Server.Self.m_UserId];
		var user:User = UserList.Self.GetUser(Server.Self.m_UserId, false);
		
		var updatefleet:Boolean = false;
		var updateradar:Boolean = false;

		if(buf.length-buf.position>0) {
			//cnt=buf.readUnsignedByte();
			//for(i=0;i<cnt;i++) buf.readUnsignedInt();

			m_UserAccessKey=buf.readUnsignedInt();

			var sl:SaveLoad=new SaveLoad();
			sl.LoadBegin(buf);

			m_GalaxyAward = sl.LoadInt();
			
			m_HomeworldIsland = sl.LoadInt();
			
			for (i = 0; i < Common.CitadelMax; i++) {
				m_CitadelIsland[i] = sl.LoadInt();
			}

/*				m_HomeworldPlanetNum=sl.LoadInt();
			if(m_HomeworldPlanetNum<0) {
				m_HomeworldSectorX=0;
				m_HomeworldSectorY=0;
				m_HomeworldCotlId=0;
				m_HomeworldIsland=0;
			} else {
				m_HomeworldSectorX=sl.LoadInt();
				m_HomeworldSectorY=sl.LoadInt();
				vint = sl.LoadInt(); if (vint != m_HomeworldCotlId) { m_HomeworldCotlId = vint; updateradar = true; }
				m_HomeworldIsland=sl.LoadInt();
			}

//trace("HomeworldIsland",m_HomeworldIsland);
			m_CitadelNum=sl.LoadInt();
			if(m_CitadelNum<0) {
				m_CitadelSectorX=0;
				m_CitadelSectorY=0;
				m_CitadelCotlId=0;
				m_CitadelIsland=0;
			} else {
				m_CitadelSectorX=sl.LoadInt();
				m_CitadelSectorY=sl.LoadInt();
				vint = sl.LoadInt(); if (vint != m_CitadelCotlId) { m_CitadelCotlId = vint; updateradar = true; }
				m_CitadelIsland=sl.LoadInt();
			}*/
			/*user.m_Race=sl.LoadDword();
			m_UserPlanetCnt=sl.LoadInt();
			m_UserEmpirePlanetCnt=sl.LoadInt();
			m_UserEnclavePlanetCnt=sl.LoadInt();
			m_UserColonyPlanetCnt=sl.LoadInt();
			user.m_Score=sl.LoadInt();
			user.m_Rest=sl.LoadInt();
			user.m_Exp=sl.LoadInt();
			user.m_Rating = sl.LoadInt();
			user.m_CombatRating = sl.LoadInt();
			user.m_ExitDate=1000*sl.LoadDword();
			m_UserKlingDestroyCnt=sl.LoadInt();
			m_UserDominatorDestroyCnt=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeTransport]=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeCorvette]=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeCruiser]=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeDreadnought]=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeInvader]=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeDevastator]=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeWarBase]=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeShipyard]=sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeSciBase] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeServiceBase] = sl.LoadInt();
			m_UserStatShipCnt[Common.ShipTypeQuarkBase] = sl.LoadInt();*/
			//m_UserStatShipCnt=sl.LoadInt();
			m_UserAddModuleEnd = sl.LoadDword() * 1000;
			m_UserCaptainEnd = sl.LoadDword() * 1000;
			m_UserTechEnd = sl.LoadDword() * 1000;
			m_UserControlEnd = sl.LoadDword() * 1000;
			m_UserEGM = sl.LoadInt();
			m_UserSDMMax = sl.LoadInt();
			m_UserSDM = sl.LoadInt();
			m_UserMulTime = sl.LoadInt();
			m_UserRelocate = sl.LoadInt();
			ver = sl.LoadDword(); if (ver > m_FormCptBar.m_CptVersion) { /*m_FormCptBar.m_CptVersion = ver;*/ m_FormCptBar.QueryCpt(); }
			ver = sl.LoadDword(); if (ver > m_PactVersion) { /*m_PactVersion = ver;*/ QueryPactList(); } 
			ver = sl.LoadDword(); if (ver > m_TicketVer) { /*m_TicketVer = ver;*/ QueryTicketList(); }

			m_UserCombatRating = sl.LoadInt();
			//vdw = sl.LoadDword(); if (vdw != m_UserCombatId) { m_UserCombatId = vdw; updateradar = true;  }

			var ct:int = sl.LoadInt();
			if(ct==Common.CotlTypeCombat) {
				vint = sl.LoadInt(); if (vint != m_CombatMass) { m_CombatMass = vint; updatefleet = true; }
				vint = sl.LoadInt(); if (vint != m_CombatMassMax) { m_CombatMassMax = vint; updatefleet = true; }
				vdw = sl.LoadDword(); if (vdw != m_CombatFlag) { m_CombatFlag = vdw; updatefleet = true; }
			} else {
				if (0 != m_CombatMass) { m_CombatMass = 0; updatefleet = true; }
				if (0 != m_CombatMassMax) { m_CombatMassMax = 0; updatefleet = true; }
				if (0 != m_CombatFlag) { m_CombatFlag = 0; updatefleet = true; }
			}
			if (ct == Common.CotlTypeRich || ct == Common.CotlTypeProtect) {
				m_UserCitadelBuildDate = 1000 * sl.LoadDword();
			}

			m_UnionId=sl.LoadDword();
			m_UnionAccess=sl.LoadDword();

			UserList.Self.GetUnion(m_UnionId);

			m_UserHourPlanetShield=sl.LoadDword();
			m_UserFlag = sl.LoadDword();
//trace("UserFlag:", m_UserFlag.toString(2));
			m_UserPlanetShieldCooldown=sl.LoadDword()*1000;
			m_UserPlanetShieldEnd=sl.LoadDword()*1000;
			m_UserEmpireCreateTime=sl.LoadDword()*1000;

			//m_GameState=sl.LoadDword();
			//m_GameTime=sl.LoadDword();

			for(u=0;u<Common.TechCnt;u++) user.m_Tech[u]=sl.LoadDword();
			m_UserResearchSpeed=sl.LoadInt();
			m_UserResearchLeft=sl.LoadInt();
//trace(m_UserResearchSpeed,m_UserResearchLeft);
			if(m_UserResearchLeft>0) {
				m_UserResearchTech=sl.LoadDword();
				m_UserResearchDir=sl.LoadDword();
			} else {
				m_UserResearchTech=0;
				m_UserResearchDir=0;
			}
			if(m_UserFlag & Common.UserFlagTechNext) {
				m_UserResearchTechNext=sl.LoadDword();
				m_UserResearchDirNext=sl.LoadDword();
			} else {
				m_UserResearchTechNext=0;
				m_UserResearchDirNext=0;
			}
			for (u = 0; (u + 4) <= Common.BuildingTypeCnt; u+=4) {
				var dw:uint = sl.LoadDword();
				user.m_BuildingLvl[u+0] = (dw) & 255;
				user.m_BuildingLvl[u+1] = (dw>>8) & 255;
				user.m_BuildingLvl[u+2] = (dw>>16) & 255;
				user.m_BuildingLvl[u+3] = (dw>>24) & 255;
			}
			for (; u < Common.BuildingTypeCnt; u++) {
				user.m_BuildingLvl[u] = sl.LoadDword();
			}
			
			user.m_IB1_Type = sl.LoadDword();
			if (user.m_IB1_Type != 0) user.m_IB1_Date = 1000 * sl.LoadDword();
			else user.m_IB1_Date = 0;
			user.m_IB2_Type = sl.LoadDword();
			if (user.m_IB2_Type != 0) user.m_IB2_Date = 1000 * sl.LoadDword();
			else user.m_IB2_Type = 0;
			
			sl.LoadEnd();

		} else {
		//	m_HomeworldSectorX=0;
		//	m_HomeworldSectorY=0;
		//	m_HomeworldPlanetNum=-1;
		//	m_CitadelNum=-1;
		}
		
		m_StateCurUser = true;
//trace("StateCurUser");
		
		if(m_UnionIdOld!=m_UnionId) {
			m_UnionIdOld=m_UnionId;
			m_FormChat.QueryChList();
		}

//			m_FormRes.UpdateResDec();
		m_FormInfoBar.Update();
		if(m_FormPlusar.visible) m_FormPlusar.Update();
		if (m_FormTech.visible) m_FormTech.Update();
		if (updatefleet) m_FormFleetBar.Update();
		if (updateradar) m_FormMiniMap.Update();
		if (updateradar) m_FormRadar.Update();
	}

	public function HintNewHomeworldUpdate():void
	{
//			if (m_HomeworldPlanetNum < 0 && (!Hyperspace.Self.visible) && (!m_FormRace.visible) && (m_GameState & Common.GameStateWait) == 0 && (m_CotlType == Common.CotlTypeUser) && (m_CotlOwnerId == Server.Self.m_UserId)) {
//				m_FormHint.Show(Common.Hint.FirstNewHomeworld);
//			} else {
//				if (m_FormHint.Text() == Common.Hint.FirstNewHomeworld) {
//					m_FormHint.Hide();
//				}
//			}
	}

	public function QueryPactList():void
	{
		if (Server.Self.IsSendCommand("empactlist")) return;
		Server.Self.Query("empactlist",'',m_FormPactList.AnswerPactList,false);
	}

	public function QueryTicketList():void
	{
		if (Server.Self.IsSendCommand("emticketlist")) return;
		Server.Self.Query("emticketlist",'',m_FormInfoBar.AnswerTicketList,false);
	}
	
	public function MenuPlanet():void
	{
		var i:int,t:int;
		var str:String;
		var ship:Ship;
		var obj:Object;

//			FormHideAll();
		m_FormMenu.Clear();

		if(m_CurPlanetNum<0) return;

		var sec:Sector=GetSector(m_CurSectorX,m_CurSectorY);
		if(sec==null) return;
		var planet:Planet = sec.m_Planet[m_CurPlanetNum];

		if (planet.m_Flag & Planet.PlanetFlagWormhole) {}
		else if (IsEdit()) { }
		else if(m_HomeworldCotlId==0) {}
		else {
			if (planet.m_Vis) {
				if (!IsEdit() && m_CotlType == Common.CotlTypeCombat) { }
				else m_FormPlanet.Show(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
			}
			return;
		}

		if (m_FormPlanet.visible) m_FormPlanet.Hide();
		m_FormPlanet.m_SectorX = m_CurSectorX;
		m_FormPlanet.m_SectorY = m_CurSectorY;
		m_FormPlanet.m_PlanetNum = m_CurPlanetNum;

		if(planet.m_Flag & Planet.PlanetFlagWormhole) {
			m_FormMenu.Add(Common.Txt.JumpWormhole,JumpWormhole);

		} else if(!planet.m_Vis) return;

		if ((planet.m_PortalPlanet != 0) && (planet.m_Flag & Planet.PlanetFlagWormhole) == 0) {
			if(planet.m_PortalCotlId==0) m_FormMenu.Add(Common.Txt.ButPortalJump,MsgPortalJump,0);
			else m_FormMenu.Add(Common.Txt.ButPortalHyperJump,MsgPortalHyperJump,0);
		}

		if ((m_GameState & Common.GameStateWait) == 0) {
			while(!IsEdit() && (planet.m_Owner==0) && (planet.m_Flag & Planet.PlanetFlagNoCapture)==0 && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))) {
				if(m_CotlType==0) {}
				else if(m_CotlType==Common.CotlTypeUser && Server.Self.m_UserId==m_CotlOwnerId) {}
				else break;
				m_FormMenu.Add(Common.Txt.NewHomeworld,MsgNewHomeworld);
				break;
			}

			m_FormMenu.Add();

			if ((planet.m_Flag & Planet.PlanetFlagHomeworld) != 0 && (planet.m_Owner & Common.OwnerAI) != 0 && (m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeCombat || m_CotlType == Common.CotlTypeRich) && (m_OpsFlag & Common.OpsFlagPlanetShield) != 0 && m_CotlUnionId==m_UnionId) {
				m_FormMenu.Add(Common.Txt.AIGameSet,MsgAIGameSet,planet.m_Owner);
			}

			if(IsEdit()) {
				m_FormMenu.Add();
				if ((planet.m_Flag & Planet.PlanetFlagWormhole) == 0) m_FormMenu.Add(Common.TxtEdit.OpenPlanet, EditMapOpenPlanet);
				if (IsEditMap() && (planet.m_Flag & Planet.PlanetFlagWormhole) != 0) {
					m_FormMenu.Add(Common.TxtEdit.CloseWormhole, EditMapCloseWormhole);
					m_FormMenu.Add(Common.TxtEdit.OpenWormhole, EditMapOpenWormhole);
				}
				if (IsEditMap()) m_FormMenu.Add(Common.TxtEdit.AddShip, EditMapAddShip);
				m_FormMenu.Add(Common.TxtEdit.EditPlanet, EditMapChangePlanet);
				m_FormMenu.Add(Common.TxtEdit.EditPlanetName, EditMapChangePlanetName);
				m_FormMenu.Add(Common.TxtEdit.EditPlanetSpawn, EditMapChangeSpawn);
				if (IsEditMap()) m_FormMenu.Add(Common.TxtEdit.DeletePlanet, EditMapDeletePlanet);
			}
			
		}

		var cx:int = WorldToScreenX(planet.m_PosX, planet.m_PosY);
		var cy:int = m_TWSPos.y;// WorldToScreenY(planet.m_PosY);

		m_FormMenu.SetCaptureMouseMove(true);
		m_FormMenu.Show(cx-30,cy-30,cx+30,cy+30);
	}

	public function MenuPortal():void
	{
		var i:int,t:int;
		var str:String;
		var ship:Ship;
		var obj:Object;

		FormHideAll();
		m_FormMenu.Clear();
		
		if(m_CurPlanetNum<0) return;

		var sec:Sector=GetSector(m_CurSectorX,m_CurSectorY);
		if(sec==null) return;
		var planet:Planet = sec.m_Planet[m_CurPlanetNum];
		
		if (planet.m_PortalPlanet != 0)
		{
			if (planet.m_PortalCotlId == 0) m_FormMenu.Add(Common.Txt.ButPortalJump, MsgPortalJump, 0);
			else m_FormMenu.Add(Common.Txt.ButPortalHyperJump, MsgPortalHyperJump, 0);
		}

		var cx:int = WorldToScreenX(planet.m_PosX, planet.m_PosY);
		var cy:int = m_TWSPos.y;// WorldToScreenY(planet.m_PosY);

		m_FormMenu.SetCaptureMouseMove(true);
		m_FormMenu.Show(cx - 100 - 30, cy - 100 - 30, cx - 100 + 30, cy - 100 + 30);
	}

	private var m_MenuShipLastId:uint = 0;
	private var m_MenuShipLastTime:Number = 0;

	public function MenuShip():void
	{
		var i:int;
		var obj:Object;
		var user:User;
		var cpt:Cpt;

		FormHideAll();
		m_FormMenu.Clear();

		if(m_CurPlanetNum<0) return;
		if(m_CurShipNum<0) return;

		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if (ship == null) return;
		
		if (m_MenuShipLastId == ship.m_Id && (Common.GetTime() - m_MenuShipLastTime) < StdMap.DblClickTime) {
			var ac:Action=new Action(this);
			ac.ActionSpecial(26,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
			m_LogicAction.push(ac);

			return;
		}

		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if (planet == null) return;

		while((m_GameState & Common.GameStateWait)==0) {
			if(ship.m_Type==Common.ShipTypeNone) break;
			if (ship.m_ArrivalTime > m_ServerCalcTime) break;

			if (IsEditMap() || AccessControl(ship.m_Owner)) {
				m_FormMenu.Add(Common.Txt.ButNoToBattle,ActionNoToBattle).Check=(ship.m_Flag & Common.ShipFlagNoToBattle)!=0;
			}
			if ((IsEditMap() || AccessControl(ship.m_Owner)) && !Common.IsBase(ship.m_Type) && (ship.m_Flag & Common.ShipFlagPhantom)==0) {
				m_FormMenu.Add(Common.Txt.ButAIAttack, ActionAIAttack).Check = (ship.m_Flag & Common.ShipFlagAIAttack) != 0;
				m_FormMenu.Add(Common.Txt.ButAIRoute, ActionAIRoute);//.Check=(ship.m_Flag & Common.ShipFlagAIRoute)!=0;
			}
			if (((ship.m_Type == Common.ShipTypeFlagship) || (ship.m_Type == Common.ShipTypeQuarkBase) || (ship.m_Race == Common.RaceTechnol)) && ShipMaxShield(ship.m_Owner, ship.m_Id, ship.m_Type, ship.m_Race, ship.m_Cnt) > 0 && AccessControl(ship.m_Owner) && (ship.m_Flag & Common.ShipFlagPhantom)==0) {
				if (ship.m_Type == Common.ShipTypeDreadnought && ship.m_Race == Common.RaceTechnol) m_FormMenu.Add(Common.Txt.ButPolar2, ActionPolar).Check = (ship.m_Flag & Common.ShipFlagPolar) != 0;
				else m_FormMenu.Add(Common.Txt.ButPolar, ActionPolar).Check = (ship.m_Flag & Common.ShipFlagPolar) != 0;
			} 
			if (ship.m_Type == Common.ShipTypeDreadnought && ship.m_Race == Common.RaceTechnol && (ship.m_Flag & Common.ShipFlagPhantom)==0) {
				m_FormMenu.Add(Common.Txt.ButTransiver, ActionTransiver).Check = (ship.m_Flag & Common.ShipFlagTransiver) != 0;
			}
			if (ship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(ship.m_Type) && ship.m_Race == Common.RacePeople) {
				m_FormMenu.Add(Common.Txt.ButNanits, ActionNanits).Check = (ship.m_Flag & Common.ShipFlagNanits) != 0;
			}
			
			if ((IsEditMap() || AccessControl(ship.m_Owner)) && ship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(ship.m_Type) && ship.m_Race == Common.RaceGaal) {
				obj=m_FormMenu.Add(Common.Txt.ButBarrier);
				obj.Disable=true;

				if (ship.m_Shield > 0 && ship.m_AbilityCooldown0 <= m_ServerCalcTime) {
					obj.Disable=false;
					obj.Fun=MsgBarrier;
				}
			}

			if (IsEditMap()/* || AccessControl(ship.m_Owner)*/) {
				m_FormMenu.Add(Common.Txt.ButLink, MsgLinkOn);
			}

//				if (ship.m_Type == Common.ShipTypeServiceBase && AccessControl(ship.m_Owner)) {
//					obj = m_FormMenu.Add(Common.Txt.ButExtract);
//					if (planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) {
//						obj.Fun = ActionExtract;
//						obj.Check = (ship.m_Flag & Common.ShipFlagExtract) != 0;
//					} else obj.Disable = true;
//				} 
			m_FormMenu.Add();

			if(ship.m_Type==Common.ShipTypeFlagship && ship.m_Owner==Server.Self.m_UserId && (ship.m_Flag & Common.ShipFlagPhantom)==0) {
				m_FormMenu.Add(Common.Txt.CptTalent,MsgTalent,ship.m_Id & (~Common.FlagshipIdFlag));
			}

			if(planet.m_PortalPlanet!=0 && planet.m_PortalPlanet<5 && (ship.m_Flag & Common.ShipFlagPhantom)==0 && AccessControl(ship.m_Owner)) {
//					if(ship.m_Type==Common.ShipTypeSciBase) {
//						m_FormMenu.Add(Common.Txt.ButPortalJump,MsgPortalJump);
//					}

				if((ship.m_Flag & Common.ShipFlagPortal)==0) {
					m_FormMenu.Add(Common.Txt.ButPortalGo,MsgPortalGo);
				} else {
					m_FormMenu.Add(Common.Txt.ButPortalCancel,MsgPortalGo);
				}
			}
			m_FormMenu.Add();

			if (AccessControl(ship.m_Owner) && (ship.m_Flag & Common.ShipFlagPhantom)==0) {
				obj = m_FormMenu.Add(Common.Txt.ButGive);
				obj.Fun = MsgGive;
				//if (!IsBattle(planet, ship.m_Owner, Common.RaceNone, false)) obj.Fun = MsgGive;
				//else obj.Disable = true;
			}

			if (AccessControl(ship.m_Owner) /*&& planet.m_Owner!=0*/ && (ship.m_Flag & Common.ShipFlagPhantom) == 0) {

				if (ship.m_Type == Common.ShipTypeTransport) {
					obj = m_FormMenu.Add(Common.Txt.ButLoad);
					if (!RouteAccess(planet, Server.Self.m_UserId)) obj.Disable = true;
					else obj.Fun = MsgLoad;
				}

				//if(planet.m_Owner==0 || ship.m_Owner==planet.m_Owner) obj=m_FormMenu.Add(Common.Txt.ButLoad);
				//else obj = m_FormMenu.Add(Common.Txt.ButSack);
				//if (ship.m_Type == Common.ShipTypeTransport) obj.Fun = MsgLoad;
				//else obj.Disable = true;

				if (ship.m_CargoType != 0 && ship.m_CargoCnt > 0) m_FormMenu.Add(Common.Txt.ButUnload + ": " + Txt_ItemName(ship.m_CargoType)).Fun = MsgUnload;
				else m_FormMenu.Add(Common.Txt.ButUnload).Disable = true;
			}

/*				if ((ship.m_Flag & Common.ShipFlagPhantom) == 0) {
				if (ship.m_Type!=Common.ShipTypeDevastator && m_CurShipNum >= Common.ShipOnPlanetLow) {
					obj = m_FormMenu.Add((ship.m_Flag & Common.ShipFlagBomb)?Common.Txt.ButClearBlasting:Common.Txt.ButSetBlasting);
					
					var fctrl:Boolean = false;
					var fenemy:Boolean = false;
					for (i = 0; i < Common.ShipOnPlanetLow; i++) {
						var ship2:Ship = planet.m_Ship[i];
						if (ship2.m_Type == Common.ShipTypeNone) continue;
						if (ship2.m_Flag & (Common.ShipFlagPhantom | Common.ShipFlagBuild)) continue;
						if (IsFlyOtherPlanet(ship2,planet)) continue;

						if (!fenemy && !IsFriendEx(planet, ship2.m_Owner, ship2.m_Race, Server.Self.m_UserId, Common.RaceNone)) fenemy = true;
						if (!fctrl && AccessControl(ship2.m_Owner)) fctrl = true;
						if (fenemy && fctrl) break;
					}
					if(fenemy) obj.Disable = true;
					else if (!fctrl && !AccessControl(ship.m_Owner)) obj.Disable = true;
					else {
						obj.Fun = MsgBlasting;
					}
				}
			}*/

			if((AccessControl(ship.m_Owner) || IsEdit()) && (ship.m_Flag & Common.ShipFlagPhantom)==0) {
//					if (!Common.IsBase(ship.m_Type)) m_FormMenu.Add(Common.Txt.ButRefuel, MsgRefuel);

				if(!IsEdit()) {
					if (ship.m_ItemType == Common.ItemTypeNone || ship.m_ItemType == Common.ItemTypeMine) m_FormMenu.Add(Common.Txt.ButDropEq).Disable = true;
					else m_FormMenu.Add(Common.Txt.ButDropEq, MsgDropEq);
				}

				m_FormMenu.Add();

				if (ship.m_Type == Common.ShipTypeSciBase && !(ship.m_Flag & Common.ShipFlagBuild)) {
					m_FormMenu.Add(Common.Txt.ButPortalOn, MsgPortalOn);

					if (!IsEdit() && (m_GameState & Common.GameStateTraining) == 0 && planet.m_PortalPlanet == 0 && (m_CotlType == Common.CotlTypeUser || m_CotlType == Common.CotlTypeRich)) m_FormMenu.Add(Common.Txt.ButPortalHyperOn, MsgPortalHyperOn);
					if(planet.m_PortalPlanet==0) {
					} else {
						m_FormMenu.Add(Common.Txt.ButPortalOff,MsgPortalOff);
					}

					if((planet.m_Flag & (Planet.PlanetFlagGravitorSci|Planet.PlanetFlagGravitorSciPrepare))==0) {
						obj = m_FormMenu.Add(Common.Txt.ButGravitorOn);
						
						if (planet.m_GravitorTime > m_ServerCalcTime) obj.Disable = true;
						else obj.Fun = MsgGravitorSci;
					} else {
						m_FormMenu.Add(Common.Txt.ButGravitorOff,MsgGravitorSci);
					}

					if(ship.m_Flag & Common.ShipFlagStabilizer) {
						m_FormMenu.Add(Common.Txt.ButStabilizerOff,MsgStabilizerOff);
					} else {
						obj=m_FormMenu.Add(Common.Txt.ButStabilizerOn);

						//if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) obj.Disable = true;
						//else 
						obj.Fun = MsgStabilizerOn;
					}

					if ((ship.m_Owner == Server.Self.m_UserId) && (m_CotlType == Common.CotlTypeUser) && (m_CotlOwnerId == Server.Self.m_UserId) && (m_GameState & Common.GameStateTraining) == 0) {
						m_FormMenu.Add(Common.Txt.ButWormhole, MsgWormhole);
					}

					if (1) {
						m_FormMenu.Add(Common.Txt.ButEject, MsgEjectOn);
					}
				}

				if (!IsViewMap() && m_CurShipNum < planet.ShipOnPlanetLow && ship.m_Type == Common.ShipTypeDevastator) {
					obj = m_FormMenu.Add(Common.Txt.ButBomb);
					if (ship.m_Cnt < 500) obj.Disable = true;
					else obj.Fun = MsgBomb;
				}

				if (!IsViewMap() && ship.m_Type == Common.ShipTypeQuarkBase && DirValE(ship.m_Owner, Common.DirQuarkBaseAntiGravitor) > 0) {
					obj=m_FormMenu.Add(Common.Txt.InfoAntiGravitor);
					obj.Disable = true;

					if (ship.m_AbilityCooldown0 <= m_ServerCalcTime) {
						obj.Disable=false;
						obj.Fun=MsgAntiGravitor;
					}
				}

				if (!IsViewMap() && ship.m_Type == Common.ShipTypeQuarkBase && DirValE(ship.m_Owner, Common.DirQuarkBaseGravWell) > 0) {
					obj=m_FormMenu.Add(Common.Txt.InfoGravWell);
					obj.Disable = true;

					if (ship.m_AbilityCooldown1 <= m_ServerCalcTime) {
						obj.Disable=false;
						obj.Fun=MsgGravWell;
					}
				}

				if (!IsViewMap() && ship.m_Type == Common.ShipTypeQuarkBase && DirValE(ship.m_Owner, Common.DirQuarkBaseBlackHole) > 0) {
					obj=m_FormMenu.Add(Common.Txt.InfoBlackHole);
					obj.Disable = true;

					if (ship.m_AbilityCooldown2 <= m_ServerCalcTime) {
						obj.Disable=false;
						obj.Fun=MsgBlackHole;
					}
				}
				
				if(!IsViewMap() && ship.m_Type==Common.ShipTypeFlagship && VecValE(ship.m_Owner, ship.m_Id, Common.VecSystemRecharge)>0) {
					obj=m_FormMenu.Add(Common.Txt.ButRecharge);
					obj.Disable=true;

					while(true) {
						user=UserList.Self.GetUser(ship.m_Owner,false);
						if(user==null) break;
						cpt=user.GetCpt(ship.m_Id);
						if(cpt==null) break;
						if (cpt.m_RechargeCooldown <= m_ServerCalcTime) {
							obj.Disable=false;
							obj.Fun=MsgRecharge;
						}
						break;
					}
				}
				if(!IsViewMap() && ship.m_Type==Common.ShipTypeFlagship && VecValE(ship.m_Owner, ship.m_Id, Common.VecSystemConstructor)>0) {
					obj=m_FormMenu.Add(Common.Txt.ButConstructor);
					obj.Disable=true;

					while(true) {
						user=UserList.Self.GetUser(ship.m_Owner,false);
						if(user==null) break;
						cpt=user.GetCpt(ship.m_Id);
						if(cpt==null) break;
						if (cpt.m_ConstructorCooldown <= m_ServerCalcTime) {
							obj.Disable=false;
							obj.Fun=MsgConstructor;
						}
						break;
					}
				}
				if(!IsViewMap() && ship.m_Type==Common.ShipTypeFlagship && VecValE(ship.m_Owner, ship.m_Id, Common.VecProtectInvulnerability)>0) {
					obj=m_FormMenu.Add(Common.Txt.ButInvu);
					obj.Disable=true;

					while(true) {
						user=UserList.Self.GetUser(ship.m_Owner,false);
						if (user == null) break;
						cpt=user.GetCpt(ship.m_Id);
						if (cpt == null) break;

						//(ship.m_Flag & Common.ShipFlagInvu)==0

						if (cpt.m_InvuCooldown <= m_ServerCalcTime) {
							obj.Disable=false;
							obj.Fun=MsgInvu;
						}
						break;
					}
				}
				if(!IsViewMap() && ship.m_Type==Common.ShipTypeFlagship && VecValE(ship.m_Owner, ship.m_Id, Common.VecMoveGravitor)>0) {
					obj=m_FormMenu.Add(Common.Txt.ButGravitor);
					obj.Disable=true;

					while ((planet.m_Flag & Planet.PlanetFlagGravitor) == 0) {
						if (planet.m_GravitorTime > m_ServerCalcTime) break;
						user=UserList.Self.GetUser(ship.m_Owner,false);
						if(user==null) break;
						cpt=user.GetCpt(ship.m_Id);
						if(cpt==null) break;
						if(cpt.m_GravitorCooldown<=m_ServerCalcTime) {
							obj.Disable=false;
							obj.Fun=MsgGravitor;
						}
						break;
					}
				}
				if(!IsViewMap() && ship.m_Type==Common.ShipTypeFlagship && VecValE(ship.m_Owner, ship.m_Id, Common.VecAttackMine)>0) {
					obj = m_FormMenu.Add(Common.Txt.ButMine);
					if (planet.m_Flag & Planet.PlanetFlagWormhole) obj.Disable = true;
					else obj.Fun = MsgMine;

					obj = m_FormMenu.Add(Common.Txt.ButMineDestroy);
					if (planet.m_Flag & Planet.PlanetFlagWormhole) obj.Disable = true;
					else obj.Fun = MsgMineDestroy;
				}

				if(!IsViewMap() && ship.m_Type==Common.ShipTypeFlagship && VecValE(ship.m_Owner, ship.m_Id, Common.VecMoveExchange)>0) {
					obj=m_FormMenu.Add(Common.Txt.ButExchange);
					obj.Disable=true;

					while(true) {
						user=UserList.Self.GetUser(ship.m_Owner,false);
						if(user==null) break;
						cpt=user.GetCpt(ship.m_Id);
						if(cpt==null) break;
						if (cpt.m_ExchangeCooldown <= m_ServerCalcTime) {
							obj.Disable=false;
							obj.Fun=MsgExchange;
						}
						break;
					}
				}
				if(!IsViewMap() && ship.m_Type==Common.ShipTypeFlagship && VecValE(ship.m_Owner, ship.m_Id, Common.VecMovePortal)>0) {
					obj=m_FormMenu.Add(Common.Txt.ButPortalOn);
					obj.Disable=true;

					while(true) {
						user=UserList.Self.GetUser(ship.m_Owner,false);
						if(user==null) break;
						cpt=user.GetCpt(ship.m_Id);
						if(cpt==null) break;
						if (cpt.m_PortalCooldown <= m_ServerCalcTime) {
							obj.Disable=false;
							obj.Fun=MsgFlagshipPortal;
						}
						break;
					}
					if(planet.m_PortalPlanet==0) {
					} else {
						m_FormMenu.Add(Common.Txt.ButPortalOff,MsgPortalOff);
					}
				}
			}

			m_FormMenu.Add();

			if (!IsEdit() && ship.m_Type == Common.ShipTypeTransport && ship.m_CargoType == Common.ItemTypeQuarkCore && m_CotlType == Common.CotlTypeUser && m_CotlOwnerId == Server.Self.m_UserId) {
				obj = m_FormMenu.Add(Common.Txt.ButDestroyPlanet);
				if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) obj.Disable = true;
				else if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0) obj.Disable = true;
				else obj.Fun = MsgDestroyPlanet;
			}
			if(!IsEdit() && AccessBuild(ship.m_Owner)) {
				if(ship.m_Flag & Common.ShipFlagBuild) {
					m_FormMenu.Add(Common.Txt.ButCancelBuild,MsgBuildCancel);
				} else {
					obj=m_FormMenu.Add(Common.Txt.ButDestroy);
					if (ship.m_Type != Common.ShipTypeTransport && ship.m_Type != Common.ShipTypeInvader && IsBattle(planet, ship.m_Owner, ship.m_Race, false)) {
						obj.Disable=true;
					} else {
						obj.Fun=MsgDestroy;
					}
				}
			}

			while(ship.m_Owner==Server.Self.m_UserId) {
				if(Common.IsBase(ship.m_Type)) break;
				user=UserList.Self.GetUser(ship.m_Owner);
				if(user==null) break;

//					var sh:Boolean=true;

//					m_FormMenu.Add();
//					m_FormMenu.Add(Common.Txt.FleetToHyperspace,MsgToHyperspace);

/*					for(i=0;i<user.m_Cpt.length;i++) {
					cpt=user.m_Cpt[i];
					if(cpt==null) continue;
					if(cpt.m_Id==0) continue;

					var cptdsc:Object=m_FormCptBar.CptDsc(cpt.m_Id);
					if(cptdsc==null) continue;

					if(sh) {
						sh=false;
						m_FormMenu.Add(Common.Txt.FleetCpt+":");
					}

					obj=m_FormMenu.Add("        "+cptdsc.Name,null,cpt.m_Id);
					if(cpt.m_PlanetNum<0 || cpt.m_ArrivalTime!=0 || cpt.m_CotlId!=Server.Self.m_CotlId) obj.Disable=true;
					else if((ship.m_Type==Common.ShipTypeFlagship) && ((ship.m_Id & (~Common.FlagshipIdFlag))==cpt.m_Id)) {
						obj.Disable=true;
					}
					else obj.Fun=ActionChangeFleet;
					obj.Check=ship.m_FleetCptId==cpt.m_Id;
				}
				if(ship.m_Type==Common.ShipTypeFlagship) obj=m_FormMenu.Add(Common.Txt.FleetNew,null,0);
				else obj=m_FormMenu.Add(Common.Txt.FleetOut,null,0);
				obj.Fun=ActionChangeFleet;
				obj.Check=ship.m_FleetCptId==0;*/

				break;
			}

			m_FormMenu.Add();
			if (IsEdit()) {
				m_FormMenu.Add(Common.TxtEdit.EditShip, EditMapChangeShip);
			}
			if (IsEditMap()) {
				m_FormMenu.Add(Common.TxtEdit.DeleteShip, EditMapDeleteShip);
			}

			break;
		}

		while ((m_GameState & Common.GameStateWait) == 0) {
			if (ship.m_Type != Common.ShipTypeNone) break;
			if (!IsEdit()) break;

			m_FormMenu.Add(Common.TxtEdit.EditShip, EditMapChangeShip);
			m_FormMenu.Add(Common.TxtEdit.EditOrbitItem, EditMapChangeOrbitItem);
			if (IsEditMap()) m_FormMenu.Add(Common.TxtEdit.DeleteOrbitItem, EditMapDeleteOrbitItem);

			break;
		}

		var ra:Array = CalcShipPlace(planet, m_CurShipNum);
		var cx:int = WorldToScreenX(ra[0], ra[1]);
		var cy:int = m_TWSPos.y;// WorldToScreenY(ra[1]);

		m_FormMenu.SetCaptureMouseMove(true);
		m_FormMenu.Show(cx - 30, cy - 30, cx + 30, cy + 30);

		m_MenuShipLastId = ship.m_Id
		m_MenuShipLastTime = Common.GetTime();
	}

	public override function onContextMenuSelectHandler(event:ContextMenuEvent):void
	{
		super.onContextMenuSelectHandler(event);
		
		CancelAll();
		
		if(IsSpaceLock()) return;
		m_MoveMap=false;
		m_Action=ActionNone;
		CalcPick(mouseX,mouseY);

		m_ContentMenuShow=true;
	}
	
	private function JumpWormhole(...args):void
	{
		m_ContentMenuShow=false;

		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;
		if(!(planet.m_Flag & Planet.PlanetFlagWormhole)) return;
		if(!(planet.m_Flag & (Planet.PlanetFlagWormholePrepare | Planet.PlanetFlagWormholeOpen))) return;

		m_GoOpen=false;
		SetCenter(Math.round(planet.m_PortalSectorX * m_SectorSize + m_SectorSize / 2), Math.round(planet.m_PortalSectorY * m_SectorSize + m_SectorSize / 2))
		m_FormMiniMap.SetCenter(OffsetX,OffsetY);
	}

	public function SendAction(type:String, val:String):int
	{
		var an:int=Server.Self.Query(type,'&val='+val,SendActionComplete,false);

		m_WaitAnswer=Common.GetTime()+SendUpdateAfterActionPeriod;
		m_WaitAnswer2=Common.GetTime()+SendUpdateAfterActionPeriod;
		return an;
	}

	public function SendActionEx(cotlid:uint, type:String, val:String):int
	{
		var oldcotlid:int;
		var oldadr:String=null;
		var oldnum:int;
		if(m_CotlType!=0 && cotlid!=Server.Self.m_CotlId) {
			var cotl:SpaceCotl = HS.GetCotl(cotlid);
			if(cotl!=null) {
				oldcotlid=Server.Self.m_CotlId;
				oldadr=Server.Self.m_ServerAdr;
				oldnum=Server.Self.m_ServerNum;
				Server.Self.m_CotlId=cotlid;
				Server.Self.m_ServerAdr="http://"+(cotl.m_ServerAdr & 255).toString()+"."+((cotl.m_ServerAdr >> 8) & 255).toString()+"."+((cotl.m_ServerAdr >> 16) & 255).toString()+"."+((cotl.m_ServerAdr >> 24) & 255).toString()+":"+cotl.m_ServerPort.toString()+"/";
				Server.Self.m_ServerNum=cotl.m_ServerNum;
			}
		} 
		var an:int=SendAction(type,val);
		if(oldadr!=null) {
			Server.Self.m_CotlId=oldcotlid;
			Server.Self.m_ServerAdr=oldadr;
			Server.Self.m_ServerNum=oldnum;
		}
		return an;
	}

	private function SendActionComplete(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		while(true) {
//trace("LoadAfterVersion Size="+loader.bytesTotal);
			if(loader.bytesTotal<1) break;

			var buf:ByteArray=loader.data;
			buf.endian=Endian.LITTLE_ENDIAN;

			if(ErrorFromServer(buf.readUnsignedByte())) return;
			
/*				if(loader.bytesTotal<1+4) break;
			var userver:uint=buf.readUnsignedInt();
			if(userver!=0) {
			}

			while(buf.position+3*4<=buf.length) {
				var sx:int=buf.readInt();
				var sy:int=buf.readInt();
				var ver:uint=buf.readUnsignedInt();

				var sec:Sector=GetSector(sx,sy);
				if(sec) {
//trace("LoadAfterVersion "+ver);
					sec.m_LoadAfterVersion=ver;
				}
			}*/
			break;
		}
	}

	private function MsgTalent(obj:Object, data:uint):void
	{
		FormHideAll();
		m_FormTalent.m_Owner = Server.Self.m_UserId;
		m_FormTalent.m_CptId = data;
		m_FormTalent.Show();
	}

	private function MsgWar(...args):void
	{
		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if(planet==null) return;

		FormHideAll();
//			m_FormWar.m_UserId=planet.m_Owner;
//			m_FormWar.Show();
	}

	private function MsgPact(...args):void
	{
		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if(planet==null) return;

		FormHideAll();
		m_FormPact.m_UserId=planet.m_Owner;
		m_FormPact.Show(FormPact.ModePreset);
	}

	private function MsgLoad(...args):void
	{
		m_ContentMenuShow=false;
		
		var ac:Action=new Action(this);
		ac.ActionCargo(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum,1);
		m_LogicAction.push(ac);
	}

	private function MsgUnload(...args):void
	{
		m_ContentMenuShow=false;
		
		var ac:Action=new Action(this);
		ac.ActionCargo(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum,-1);
		m_LogicAction.push(ac);
	}

	private function MsgPortalGo(...args):void
	{
		var u:int;
		var fok:Boolean;
		m_ContentMenuShow = false;
		
		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;
		if (planet.m_PortalPlanet <= 0) return;
		
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if (ship == null || ship.m_Type == Common.ShipTypeNone) return;
		
		if((ship.m_Flag & Common.ShipFlagPortal)==0) {
			if (ship.m_Type == Common.ShipTypeQuarkBase || ship.m_Type == Common.ShipTypeFlagship) {

				var qccnt:int = 0;
				for (var i:int = 0; i < Common.ShipOnPlanetMax; i++) {
					var ship2:Ship = planet.m_Ship[i];
					if (ship2.m_Type == 0) continue;
					if (ship2.m_CargoType != Common.ItemTypeQuarkCore) continue;
					if (IsFlyOtherPlanet(ship2, planet)) continue;
					if (ship2.m_Owner != ship.m_Owner && !IsFriendEx(planet, ship.m_Owner, ship.m_Race, ship2.m_Owner, ship2.m_Race)) continue;
					qccnt += ship2.m_CargoCnt;
				}

				if(planet.m_PortalCotlId==0) {
					//if ((ship.m_CargoType != Common.ItemTypeQuarkCore) || (ship.m_CargoCnt <= 0)) {
					if (ship.m_Type == Common.ShipTypeQuarkBase && qccnt < 1) {
						m_FormHint.Show(Common.Txt.WarningNeedSingleQuarkCore, Common.WarningHideTime); 
						return;
					}

					if (ship.m_Type == Common.ShipTypeQuarkBase) {
						fok=false;
						while(true) {
							if (m_CotlType == Common.CotlTypeUser && m_CotlOwnerId == ship.m_Owner) { fok = true; break; }
							if (m_CotlType != Common.CotlTypeRich) break;
							//if (planet2.m_Owner != ship->m_Owner) break;

							//if (m_CitadelCotlId != Server.Self.m_CotlId) break;
							for (u = 0; u < Common.CitadelMax; u++) {
								if (m_CitadelCotlId[u] == Server.Self.m_CotlId) break;
							}
							if (u >= Common.CitadelMax) break;

							//SStat * stat=StatGet(ship->m_Owner);
							//if(!stat) break;
							//if(planet2->m_Island!=stat->m_EnclaveIsland) break;

							fok = true;
							break;
						}
						if(!fok) { m_FormHint.Show(Common.Txt.WarningQuarkBasePortalLimit, Common.WarningHideTime); return; }
					}
					
				} else {
					//if ((ship.m_CargoType != Common.ItemTypeQuarkCore) || (ship.m_CargoCnt < 10)) {
					if (ship.m_Type == Common.ShipTypeQuarkBase && qccnt < 10) {
						m_FormHint.Show(BaseStr.Replace(Common.Txt.WarningNeedQuarkCore, "<Val>", "10"), Common.WarningHideTime); 
						return;
					} else if (ship.m_Type == Common.ShipTypeFlagship && qccnt < 5) {
						m_FormHint.Show(BaseStr.Replace(Common.Txt.WarningNeedQuarkCore, "<Val>", "5"), Common.WarningHideTime); 
						return;
					}

					if (ship.m_Type == Common.ShipTypeQuarkBase && ship.m_Owner == Server.Self.m_UserId) {
						fok=false;
						while(true) {
							if(planet.m_PortalCotlId==m_HomeworldCotlId) {}
							//else if (m_CitadelNum >= 0 && (planet.m_PortalPlanet - 1) == m_CitadelNum && planet.m_PortalCotlId == m_CitadelCotlId && planet.m_PortalSectorX == m_CitadelSectorX && planet.m_PortalSectorY == m_CitadelSectorY) { }
							else if (CitadelFindEx(planet.m_PortalCotlId, planet.m_PortalSectorX, planet.m_PortalSectorY, planet.m_PortalPlanet - 1) >= 0) {}
							else break;

							fok = true;
							break;
						}
						if (!fok) { m_FormHint.Show(Common.Txt.WarningQuarkBasePortalLimit, Common.WarningHideTime); return; }
					}
				}
			}

			if (Server.Self.m_UserId == ship.m_Owner) {
				if (m_GameState & (Common.GameStateTraining | Common.GameStateDevelopment)) { }
				else if ((m_Access & Common.AccessPlusarTech) && PlusarTech()) { }
				else {
					m_Info.Hide();
					FormMessageBox.Run(Common.Txt.PortalNoTech,Common.Txt.ButClose);

					return;
				}
			}
		}

		var ac:Action=new Action(this);
		ac.ActionSpecial(5,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}
	
	public function MsgPortalHyperJump(f:Object, t:int):void
	{
		var planet:Planet = null;
		if (t == 0) planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		else planet = GetPlanet(m_FormPlanet.m_SectorX, m_FormPlanet.m_SectorY, m_FormPlanet.m_PlanetNum);
		if(planet==null) return;
		if(planet.m_PortalPlanet<=0) return;
		if(planet.m_PortalCotlId==0) return;
		
		GoTo(true,planet.m_PortalCotlId,planet.m_PortalSectorX,planet.m_PortalSectorY,planet.m_PortalPlanet-1);
	}

	public function MsgPortalJump(f:Object, t:int):void
	{
		m_ContentMenuShow=false;

		var planet:Planet = null;
		if (t == 0) planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		else planet = GetPlanet(m_FormPlanet.m_SectorX, m_FormPlanet.m_SectorY, m_FormPlanet.m_PlanetNum);
		if(planet==null) return;
		if(planet.m_PortalPlanet<=0) return;
		
		if (planet.m_PortalCotlId != 0) {
			GoTo(true,planet.m_PortalCotlId,planet.m_PortalSectorX,planet.m_PortalSectorY,planet.m_PortalPlanet-1);
		} else {
			m_GoOpen=false;
			SetCenter(Math.round(planet.m_PortalSectorX*m_SectorSize+m_SectorSize/2),Math.round(planet.m_PortalSectorY*m_SectorSize+m_SectorSize/2))
			m_FormMiniMap.SetCenter(OffsetX, OffsetY);
		}
	}

	private function MsgPortalOff(...args):void
	{
		m_ContentMenuShow=false;

		SendAction("emportal",""+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum+"_"+m_CurShipNum+"_"+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum);
	}
	
	private function MsgPortalHyperOn(...args):void
	{
		SendAction("emportal",""+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum+"_"+m_CurShipNum+"_0_0_-1");
	}

	private function MsgWormhole(...args):void
	{
		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if(planet==null) return;
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if(ship==null) return;

		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=ship.m_Owner;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		m_Action=ActionWormhole;
		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function ProcessActionWormhole():void
	{
		var num:int, i:int, x:int, y:int, dx:int, dy:int, v:int;
		var ok:Boolean;
		var planet:Planet, planet2:Planet;
		var ship:Ship;
		var sec:Sector;
		var findprotoplasm:Boolean = false;
		var findwormhole:int = 0;
		var findscibase:int = 0;

		for (num = 0; num < 2; num++) {
			if (num == 0) planet = GetPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);
			else planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
			if (planet == null) continue;

			if (!findprotoplasm) {
				v = PlanetItemGet_Sub(Server.Self.m_UserId, planet, Common.ItemTypeProtoplasm, false);
				if (v >= 200000) findprotoplasm = true;
			}

			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship = planet.m_Ship[i];
				if (ship.m_Type != Common.ShipTypeSciBase) continue;
				//if (!IsFriendEx(planet, ship.m_Owner, ship.m_Race, Server.Self.m_UserId, Common.RaceNone)) continue;
				if (ship.m_Owner != Server.Self.m_UserId) continue;
				if (ship.m_Flag & Common.ShipFlagBuild) continue;
				findscibase++;
				break;
			}

			ok = false;
			for (y = planet.m_Sector.m_SectorY - 1; y <= planet.m_Sector.m_SectorY + 1; y++) {
				for (x = planet.m_Sector.m_SectorX - 1; x <= planet.m_Sector.m_SectorX + 1; x++) {
					sec = GetSector(x, y);
					if (sec == null) continue;

					for (i = 0; i < sec.m_Planet.length; i++) {
						planet2 = sec.m_Planet[i];
						if (planet2.m_Flag & Planet.PlanetFlagWormhole) continue;
						if (planet2.m_Flag & (Planet.PlanetFlagWormholeOpen | Planet.PlanetFlagWormholeClose | Planet.PlanetFlagWormholePrepare)) continue;

						dx = planet.m_PosX - planet2.m_PosX;
						dy = planet.m_PosY - planet2.m_PosY;

						if ((dx * dx + dy * dy) > JumpRadius2) continue;

						findwormhole++;
						ok = true;
						break;
					}
					if (ok) break;
				}
				if (ok) break;
			}
		}

		if ((!findprotoplasm) || (findwormhole < 2) || (findscibase < 2) || ((m_GameState & Common.GameStateEnemy) != 0)) {
			FormMessageBox.RunErr(Common.Txt.ErrorOpenWormhole);
			return;
		}

		SendAction("emwormhole", "" + m_MoveSectorX + "_" + m_MoveSectorY + "_" + m_MovePlanetNum + "_" + m_MoveShipNum + "_" + m_CurSectorX + "_" + m_CurSectorY + "_" + m_CurPlanetNum);
	}

	private function MsgLinkOn(...args):void
	{
		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;
		var ship:Ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		if (ship == null) return;

		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=ship.m_Owner;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		m_Action=ActionLink;
		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function MsgEjectOn(...args):void
	{
		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;
		var ship:Ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		if (ship == null) return;

		m_MoveSectorX = m_CurSectorX;
		m_MoveSectorY = m_CurSectorY;
		m_MovePlanetNum = m_CurPlanetNum;
		m_MoveShipNum = m_CurShipNum;
		m_MoveOwner = ship.m_Owner;
		m_MoveListNum.length = 0;
		m_MovePath.length = 0;

		m_Action = ActionEject;
		CalcPick(mouseX, mouseY);
		InfoUpdate(mouseX, mouseY);
	}

	private function MsgPortalOn(...args):void
	{
		m_ContentMenuShow=false;

		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if(planet==null) return;
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if(ship==null) return;

		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=ship.m_Owner;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		m_Action=ActionPortal;
		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);

//			CloseForModal();

//			m_FormPortal.m_SectorX=m_CurSectorX;
//			m_FormPortal.m_SectorY=m_CurSectorY;
//			m_FormPortal.m_PlanetNum=m_CurPlanetNum;
//			m_FormPortal.Show();
	}
	
	private function MsgFlagshipPortal(...args):void
	{
		m_ContentMenuShow=false;

		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if(planet==null) return;
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if(ship==null) return;
		
		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=ship.m_Owner;
		m_MoveListNum.length=0;
		m_MovePath.length=0;
		
		m_Action=ActionPortal;
		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function MsgStabilizerOff(...args):void
	{
		m_ContentMenuShow=false;
		
		var ac:Action=new Action(this);
		ac.ActionSpecial(2,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgStabilizerOn(...args):void
	{
		//m_ContentMenuShow=false;
		//CloseForModal();
		//FormMessageBox.Run(Common.Txt.StabilizerQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionStabilizer);
		ActionStabilizer();
	}
	
	private function ActionStabilizer():void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(1,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}
	
	private function MsgDropEq(...args):void
	{
		m_ContentMenuShow=false;

		var ac:Action=new Action(this);
		ac.ActionCargo(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum,10);
		m_LogicAction.push(ac);
	}

	private function MsgRefuel(...args):void
	{
		m_ContentMenuShow=false;
		
		var ac:Action=new Action(this);
		ac.ActionCargo(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum,0);
		m_LogicAction.push(ac);
	}
	
	public var m_ItemGiveCnt:int = 1;
	public var m_ItemGiveType:uint = Common.ItemTypeNone;

	private function MsgGive(...args):void
	{
		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;
		var ship:Ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		if (ship == null) return;
		
		var gt:uint = m_ItemGiveType;
		if (gt == Common.ItemTypeFuel) { }
		else if (gt == Common.ItemTypeQuarkCore && (ship.m_Type == Common.ShipTypeQuarkBase || ship.m_Type == Common.ShipTypeSciBase || ship.m_Type == Common.ShipTypeFlagship)) { }
		else if (gt == Common.ItemTypeMine && (ship.m_Type == Common.ShipTypeFlagship)) { }
		else if (ship.m_ItemType != 0) gt = ship.m_ItemType;
		
//			m_ContentMenuShow=false;
		FormHideAll();
//			m_FormRes.Show(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);

		m_FormInput.Init();
		m_FormInput.AddLabel(Common.Txt.FormGiveCaption,18);

		m_FormInput.AddLabel(Common.Txt.FormGiveType + ":");
		m_FormInput.Col();
		m_FormInput.AddComboBox();
		m_FormInput.AddItem(Txt_ItemName(Common.ItemTypeArmour), Common.ItemTypeArmour, Common.ItemTypeArmour == gt);
		m_FormInput.AddItem(Txt_ItemName(Common.ItemTypeArmour2), Common.ItemTypeArmour2, Common.ItemTypeArmour2 == gt);
		m_FormInput.AddItem(Txt_ItemName(Common.ItemTypePower), Common.ItemTypePower, Common.ItemTypePower == gt);
		m_FormInput.AddItem(Txt_ItemName(Common.ItemTypePower2), Common.ItemTypePower2, Common.ItemTypePower2 == gt);
		m_FormInput.AddItem(Txt_ItemName(Common.ItemTypeRepair), Common.ItemTypeRepair, Common.ItemTypeRepair == gt);
		m_FormInput.AddItem(Txt_ItemName(Common.ItemTypeRepair2), Common.ItemTypeRepair2, Common.ItemTypeRepair2 == gt);
		m_FormInput.AddItem(Txt_ItemName(Common.ItemTypeMonuk), Common.ItemTypeMonuk, Common.ItemTypeMonuk == gt);
		m_FormInput.AddItem(Txt_ItemName(Common.ItemTypeQuarkCore), Common.ItemTypeQuarkCore, Common.ItemTypeQuarkCore == gt);

//			while (planet.m_Owner == ship.m_Owner || IsFriendEx(planet, planet.m_Owner, planet.m_Race, ship.m_Owner, ship.m_Race)) {
//				if ((m_CotlType == Common.CotlTypeRich || m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeCombat) && (m_OpsFlag & Common.OpsFlagLeaveShip) == 0) break;
//				m_FormInput.AddItem(Txt_ItemName(Common.ItemTypeFuel), Common.ItemTypeFuel, Common.ItemTypeFuel == gt);
//				break;
//			}

		if (ship.m_Type == Common.ShipTypeFlagship) {
			m_FormInput.AddItem(Txt_ItemName(Common.ItemTypeMine), Common.ItemTypeMine, Common.ItemTypeMine == gt);
		}

		m_FormInput.AddLabel(Common.Txt.FormGiveCnt+":");
		m_FormInput.Col();
		var ti:TextInput = m_FormInput.AddInput(m_ItemGiveCnt.toString(), 8, true, 0);
		ti.setSelection(0, ti.text.length);

		m_FormInput.ColAlign();
		m_FormInput.Run(ActionGive, Common.Txt.FormGiveOk, Common.Txt.Cancel);

		ti.setFocus();
	}

	private function ActionGive():void
	{
		var itype:int = m_FormInput.GetInt(0);
		var icnt:int = m_FormInput.GetInt(1);
		
		m_ItemGiveCnt = icnt;
		m_ItemGiveType = itype;
		
		var ac:Action=new Action(this);
		ac.ActionGive(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum, itype, icnt);
		m_LogicAction.push(ac);
	}

	private function MsgBomb(...args):void
	{
		m_ContentMenuShow=false;

		FormHideAll();
		FormMessageBox.Run(Common.Txt.WarningBomb,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionBomb);
	}

	private function ActionBomb():void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(6,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgBlasting(...args):void
	{
		var ac:Action = new Action(this);
		ac.ActionSpecial(6, m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function ActionNoToBattle(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(14,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}
	
	private function ActionPolar(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(20,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}
	
	private function ActionTransiver(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(23,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function ActionSiege(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(24,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}
	
	private function ActionNanits(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(30,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function ActionExtract(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(21,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function ActionAIRoute(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(15,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function ActionAIAttack(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(16,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgAntiGravitor(...args):void
	{
		var ship:Ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		if (ship.m_Type != Common.ShipTypeQuarkBase) return;
		if ((ship.m_Flag & Common.ShipFlagBattle) == 0) {
			m_FormHint.Show(Common.Txt.WarningNeedBattleMode, Common.WarningHideTime);
			return;
		}
		if (ship.m_BattleTimeLock > m_ServerCalcTime) {
			m_FormHint.Show(Common.Txt.WarningNeedReloadReactor, Common.WarningHideTime); 
			return;
		}
		if ((ship.m_CargoType != Common.ItemTypeQuarkCore) || (ship.m_CargoCnt <= 0)) {
			m_FormHint.Show(Common.Txt.WarningNeedSingleQuarkCore, Common.WarningHideTime); 
			return;
		}

		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=0;
		m_Action=ActionAntiGravitor;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function ActionAntiGravitorProcess():void
	{
		SendAction("emabil", "1_" + m_MoveSectorX.toString() + "_" + m_MoveSectorY.toString() + "_" + m_MovePlanetNum.toString() + "_" + m_MoveShipNum.toString() + "_" + m_CurSectorX.toString() + "_" + m_CurSectorY.toString() + "_" + m_CurPlanetNum.toString() + "_-1");
	}

	private function MsgGravWell(...args):void
	{
		var ship:Ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		if (ship.m_Type != Common.ShipTypeQuarkBase) return;
		if ((ship.m_Flag & Common.ShipFlagBattle) == 0) {
			m_FormHint.Show(Common.Txt.WarningNeedBattleMode, Common.WarningHideTime);
			return;
		}
		if (ship.m_BattleTimeLock > m_ServerCalcTime) {
			m_FormHint.Show(Common.Txt.WarningNeedReloadReactor, Common.WarningHideTime); 
			return;
		}
		if ((ship.m_CargoType != Common.ItemTypeQuarkCore) || (ship.m_CargoCnt <= 0)) {
			m_FormHint.Show(Common.Txt.WarningNeedSingleQuarkCore, Common.WarningHideTime); 
			return;
		}

		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=0;
		m_Action=ActionGravWell;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function ActionGravWellProcess():void
	{
		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;
		if (planet.m_Radiation > 0) {
			m_FormHint.Show(Common.Txt.WarningNoGravWellRadiation, Common.WarningHideTime);
			return;
		}
		
		SendAction("emabil", "2_" + m_MoveSectorX.toString() + "_" + m_MoveSectorY.toString() + "_" + m_MovePlanetNum.toString() + "_" + m_MoveShipNum.toString() + "_" + m_CurSectorX.toString() + "_" + m_CurSectorY.toString() + "_" + m_CurPlanetNum.toString() + "_-1");
	}

	private function MsgBlackHole(...args):void
	{
		var ship:Ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		if (ship.m_Type != Common.ShipTypeQuarkBase) return;
		if ((ship.m_Flag & Common.ShipFlagBattle) == 0) {
			m_FormHint.Show(Common.Txt.WarningNeedBattleMode, Common.WarningHideTime);
			return;
		}
		if (ship.m_BattleTimeLock > m_ServerCalcTime) {
			m_FormHint.Show(Common.Txt.WarningNeedReloadReactor, Common.WarningHideTime); 
			return;
		}
		if ((ship.m_CargoType != Common.ItemTypeQuarkCore) || (ship.m_CargoCnt <= 0)) {
			m_FormHint.Show(Common.Txt.WarningNeedSingleQuarkCore, Common.WarningHideTime); 
			return;
		}

		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=0;
		m_Action=ActionBlackHole;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function ActionBlackHoleProcess():void
	{
		SendAction("emabil", "3_" + m_MoveSectorX.toString() + "_" + m_MoveSectorY.toString() + "_" + m_MovePlanetNum.toString() + "_" + m_MoveShipNum.toString() + "_" + m_CurSectorX.toString() + "_" + m_CurSectorY.toString() + "_" + m_CurPlanetNum.toString() + "_" + m_CurShipNum.toString());
	}

	private function MsgBarrier(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(29,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgTransition(...args):void
	{
		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=0;
		m_Action=ActionTransition;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function ActionTransitionProcess():void
	{
		SendAction("emabil", "4_" + m_MoveSectorX.toString() + "_" + m_MoveSectorY.toString() + "_" + m_MovePlanetNum.toString() + "_" + m_MoveShipNum.toString() + "_" + m_CurSectorX.toString() + "_" + m_CurSectorY.toString() + "_" + m_CurPlanetNum.toString() + "_" + m_CurShipNum.toString());
	}

	private function MsgExchange(...args):void
	{
		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=0;
		m_Action=ActionExchange;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function ActionExchangeProcess():void
	{
		SendAction("emexchange",""+m_MoveSectorX.toString()+"_"+m_MoveSectorY.toString()+"_"+m_MovePlanetNum.toString()+"_"+m_MoveShipNum.toString()+"_"+m_CurSectorX.toString()+"_"+m_CurSectorY.toString()+"_"+m_CurPlanetNum.toString());
	}

	private function MsgRecharge(...args):void
	{
		m_ContentMenuShow=false;

//			var ac:Action=new Action(this);
//			ac.ActionSpecial(10,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
//			m_LogicAction.push(ac);

		var ship:Ship=GetShip(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveShipNum);
		if(ship==null) return;
		if(ship.m_Type!=Common.ShipTypeFlagship) return;

		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=ship.m_Owner;
		m_Action=ActionRecharge;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function MsgConstructor(...args):void
	{
		m_ContentMenuShow=false;
		
		var ship:Ship=GetShip(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveShipNum);
		if(ship==null) return;
		if(ship.m_Type!=Common.ShipTypeFlagship) return;

		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=m_CurShipNum;
		m_MoveOwner=ship.m_Owner;
		m_Action=ActionConstructor;
		m_MoveListNum.length=0;
		m_MovePath.length = 0;
		m_ActionShipNum = -1;

		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	private function MsgInvu(...args):void
	{
		m_ContentMenuShow=false;

		var ac:Action=new Action(this);
		ac.ActionSpecial(7,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgGravitor(...args):void
	{
		m_ContentMenuShow=false;

		var ac:Action=new Action(this);
		ac.ActionSpecial(9,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgGravitorSci(...args):void
	{
		m_ContentMenuShow=false;

		var ac:Action=new Action(this);
		ac.ActionSpecial(17,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgMine(...args):void
	{
		m_ContentMenuShow=false;

		var ac:Action=new Action(this);
		ac.ActionSpecial(8,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgMineDestroy(...args):void
	{
		FormMessageBox.Run(Common.Txt.ButMineDestroyQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, MsgMineDestroySend);
	}
	
	private function MsgMineDestroySend():void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(34, m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgDestroyPlanet(...args):void
	{
		var i:int;
		var str:String = Common.Txt.QueryDestroyPlanet;
		
		var cost:int = 1000;
		for (i = 0; i < m_PlanetDestroy; i++) cost *= 2;
		str = BaseStr.Replace(str, "<QC>", "[clr]" + (cost).toString() + "[/clr]");

		cost = 2000000;
		for (i = 0; i < m_PlanetDestroy; i++) cost *= 2;
		str = BaseStr.Replace(str, "<Cost>", "[clr]" + BaseStr.FormatBigInt(cost) + "[/clr]");
		FormMessageBox.Run(str,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionDestroyPlanet);
	}

	private function ActionDestroyPlanet():void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(31, m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private function MsgDestroy(...args):void
	{
		m_ContentMenuShow=false;

		FormHideAll();
		if(m_CurShipNum<0) FormMessageBox.Run(Common.Txt.WarningLeave,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionDestroy);
		else FormMessageBox.Run(Common.Txt.WarningDestroy,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionDestroy);
	}

	private function ActionDestroy():void
	{
		var ac:Action=new Action(this);
		ac.ActionDestroy(0,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}

	private var m_AIGameSet_Owner:uint = 0;
	
	private function MsgAIGameSet(obj:Object, owner:uint):void
	{
		FormHideAll();
		
		var user:User = UserList.Self.GetUser(owner);
		if (user == null) return;
		
		m_AIGameSet_Owner = owner;

		m_FormInput.Init(400);

		m_FormInput.AddLabel(Common.Txt.AIGameSet,15,0xffff00);

		m_FormInput.AddCheck((user.m_Flag & Common.UserFlagAutoTransportNet) != 0, Common.Txt.AIGameSetTransportNet);
		m_FormInput.AddCheck((user.m_Flag & Common.UserFlagAutoTransport) != 0, Common.Txt.AIGameSetTransport);
		m_FormInput.AddCheck((user.m_Flag & Common.UserFlagAutoDefence) != 0, Common.Txt.AIGameSetDefence);

		m_FormInput.AddLabel(Common.Txt.HourPlanetShield + ":");
		m_FormInput.Col();
		m_FormInput.AddInput(Common.NormHour(user.m_HourPlanetShield+m_DifClientServerHour).toString(), 2, true)
		
		m_FormInput.ColAlign();
		m_FormInput.Run(ActionAIGameSet);
	}
	
	private function ActionAIGameSet():void
	{
		var fl:uint = 0;
		if (m_FormInput.GetInt(0) != 0) fl |= Common.UserFlagAutoTransportNet;
		if (m_FormInput.GetInt(1) != 0) fl |= Common.UserFlagAutoTransport;
		if (m_FormInput.GetInt(2) != 0) fl |= Common.UserFlagAutoDefence;

		var shieldhour:int=Common.NormHour(m_FormInput.GetInt(3)-m_DifClientServerHour);

		SendAction("emaigameset",m_AIGameSet_Owner.toString(16)+"_"+fl.toString(16)+"_"+shieldhour.toString());
	}

	private function MsgBuildCancel(...args):void
	{
		m_ContentMenuShow=false;
		
		var ac:Action=new Action(this);
		ac.ActionDestroy(1,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);
	}
	
	private function MsgPlanetShield(...args):void
	{
		m_ContentMenuShow=false;
		
		FormHideAll();
		FormMessageBox.Run(Common.Txt.PlusarPlanetShield,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionPlanetShield);
	}

	private function ActionPlanetShield():void
	{
		if(m_UserEGM<Common.PlusarPlanetShieldCost) {
			FormMessageBox.Run(Common.Txt.NoEnoughEGM,Common.Txt.ButClose);
		} else {
			SendAction("emplusar","3_"+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum);
		}
	}

	private function MsgPlanetShieldOff(...args):void
	{
		m_ContentMenuShow=false;
		
		FormHideAll();
		FormMessageBox.Run(Common.Txt.PlusarPlanetShieldOff,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionPlanetShieldOff);
	}

	private function ActionPlanetShieldOff():void
	{
		SendAction("emplusar","4_"+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum);
	}

	public function MsgNewHomeworld(...args):void
	{
		m_FormPlanet.Hide();
		FormHideAll();
		
		if (m_GameState & Common.GameStateEnemy) {
			m_FormHint.Show(Common.Txt.WarningNoOpEnemy, Common.WarningHideTime);
			
		} else if (GetServerGlobalTime() < (m_UserEmpireCreateTime + Common.NewEmpireCooldown * 1000)) {
			var str:String=Common.Txt.NewEmpireCooldown;
			//str=str.replace(/<Val>/g,Common.FormatPeriod(((m_UserEmpireCreateTime+Common.NewEmpireCooldown*1000)-GetServerTime())/1000));
			str = BaseStr.Replace(str, "<Val>", Common.FormatPeriodLong(((m_UserEmpireCreateTime + Common.NewEmpireCooldown * 1000) - GetServerGlobalTime()) / 1000));
			FormMessageBox.Run(str,Common.Txt.ButClose);
		} else {
			//FormMessageBox.Run(Common.Txt.MsgNewEmpire,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionNewHomeworld);
			m_FormRace.Show(false);
		}
	}

	private function ActionNewHomeworld():void
	{
		if(m_CurPlanetNum<0) return;
		SendAction("emnewhomeworld",""+m_FormPlanet.m_SectorX+"_"+m_FormPlanet.m_SectorY+"_"+m_FormPlanet.m_PlanetNum);
	}

	public function NewShipId(owner:uint):uint
	{
		var cotl:SpaceCotl = HS.GetCotl(Server.Self.m_CotlId);
		if(cotl==null) return 0;
		
		if(Server.Self.m_ServerKey!=cotl.m_NewIdServerKey || Server.Self.m_ClearCnt!=cotl.m_NewIdClearCnt) return 0;

		var id:uint;
		if(cotl.m_NewId!=0) { id=cotl.m_NewId; cotl.m_NewId=0; }
		else if(cotl.m_NewId2!=0) { id=cotl.m_NewId2; cotl.m_NewId2=0; }
		else return 0;
		
//trace("NewId:",id);
		return id;

/*			var id:uint;
		var user:User=UserList.Self.GetUser(owner);
		if(user==null) return 0;
		if(user.m_NewId!=0) { id=user.m_NewId; user.m_NewId=0; }
		else if(user.m_NewId2!=0) { id=user.m_NewId2; user.m_NewId2=0; }
		else return 0;
		return id;*/
	}

	private function ActionBuildShip(e:ContextMenuEvent):void
	{
		m_ContentMenuShow=false;
		
		if(m_CurPlanetNum<0) return;

		var t:int;

		for(t=0;t<m_CMItemBuild.length;t++) {
			if(m_CMItemBuild[t]==e.target) break;
		}
		if(t>=m_CMItemBuild.length) t=Common.ShipTypeNone;
		else t=m_CMShipBuildType[t];
//trace("Build "+t);

		var sec:Sector=GetSector(m_CurSectorX,m_CurSectorY);
		if(sec==null) return;
		var planet:Planet=sec.m_Planet[m_CurPlanetNum];

		FormHideAll();
		m_FormBuild.Run(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,-1/*m_CurShipNum*/,t,-1);

//			var num:int=planet.FindBuildPlace(m_UserId,t,1);
//			if(num<0) return;
//			SendAction("embuild",""+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum+"_"+num+"_"+t+"_"+1);
	}
	
	private function ActionBuildShip2(obj:Object, data:int):void
	{
		m_ContentMenuShow=false;
		
		if(m_CurPlanetNum<0) return;

		var t:int=data;

		var sec:Sector=GetSector(m_CurSectorX,m_CurSectorY);
		if(sec==null) return;
		var planet:Planet=sec.m_Planet[m_CurPlanetNum];

		FormHideAll();
		m_FormBuild.Run(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,-1/*m_CurShipNum*/,t,-1);

//			var num:int=planet.FindBuildPlace(m_UserId,t,1);
//			if(num<0) return;
//			SendAction("embuild",""+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum+"_"+num+"_"+t+"_"+1);
	}
	
	private function ActionBuildFlagship(obj:Object, data:int):void
	{
		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if(planet==null) return;
		var sn:int=CalcBuildPlace(planet,planet.m_Owner);
		if(sn<0) return;
		
		var ac:Action=new Action(this);
		ac.ActionBuild(data,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,sn,Common.ShipTypeFlagship,1,0,planet.m_Owner);
		m_LogicAction.push(ac);
	}

	public function SortNum(a:int, b:int):int {
		if(a<b) return -1;
		if(a>b) return 1;
		return 0;
	}
	
	public function ActionPathMoveProcess():void
	{
		var i:int,u:int,k:int,off:int,v:int;

		if(m_MovePath.length<2) return;
		if(m_MovePath.length>(Common.PathMoveMax+1)) return;

		m_MoveListNum.push(m_MoveShipNum);
		m_MoveListNum.sort(SortNum);
		
		var planet:Planet = GetPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);
		if (planet == null) return;

		var sopl:int=planet.ShipOnPlanetLow;

		off=0;
		if(m_MoveListNum.length>1) {
			v=-1;
			for(i=0;i<m_MoveListNum.length;i++) {
				k=m_MoveListNum[i];
				u=i+1; if(u>=m_MoveListNum.length) u=0;
				u=m_MoveListNum[u];

				if (k >= sopl) k = -1;
				if(u>=k) k=u-k;
				else k=Common.ShipOnPlanetMax-k+u;
				
				if(v<0 || k>v) {
					v=k;
					off=i;
				}
			}
			off++;
			if(off>=m_MoveListNum.length) off=0;
		}
//trace(m_MoveListNum,"First:",m_MoveListNum[off]);

		var gn:uint=Math.round(Math.random()*30000)<<8;
		
		var speed:int = 0;
		
		if (m_MoveListNum.length < 1) return;
		if (m_MoveListNum.length > 7) { throw Error("PathShipCnt>7"); return; }

		for(u=0;u<m_MoveListNum.length;u++) {
			var ship2:Ship = GetShip(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, m_MoveListNum[u]);
			//var ship2:GraphShip=GetGraphShip(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, m_MoveListNum[k]);
			if (ship2 == null) continue;
			
			var sp:int = CalcSpeed(ship2.m_Owner, ship2.m_Id, ship2.m_Type);
			if(u==0) speed=sp;
			else if(sp<speed) speed=sp;
		}

		var shipnum0:int = -1;
		var shipnum1:int = -1;
		var shipnum2:int = -1;
		var shipnum3:int = -1;
		var shipnum4:int = -1;
		var shipnum5:int = -1;
		var shipnum6:int = -1;
		for(u=0;u<m_MoveListNum.length;u++) {
			k = off + u;
			if (k >= m_MoveListNum.length) k -= m_MoveListNum.length;
			
			if (u == 0) shipnum0 = m_MoveListNum[k];
			else if (u == 1) shipnum1 = m_MoveListNum[k];
			else if (u == 2) shipnum2 = m_MoveListNum[k];
			else if (u == 3) shipnum3 = m_MoveListNum[k];
			else if (u == 4) shipnum4 = m_MoveListNum[k];
			else if (u == 5) shipnum5 = m_MoveListNum[k];
			else if (u == 6) shipnum6 = m_MoveListNum[k];
		}

		var a:Array=new Array();

		for (i = 1; i < m_MovePath.length; i++) {
			var fromplanet:Planet = m_MovePath[i - 1];
			var toplanet:Planet = m_MovePath[i];

			var o:uint = CalcPlanetOffset(fromplanet.m_Sector.m_SectorX, fromplanet.m_Sector.m_SectorY, fromplanet.m_PlanetNum, toplanet.m_Sector.m_SectorX, toplanet.m_Sector.m_SectorY, toplanet.m_PlanetNum);
			if (!o) return;
			if (o.toString(16).length != 2) throw Error("ActionPathMoveProcess");

			a.push(o);
		}

		var ac:Action = new Action(this);
		ac.ActionPathMove(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, shipnum0, shipnum1, shipnum2, shipnum3, shipnum4, shipnum5, shipnum6, gn /*| (m_MoveListNum.length << 4) | (u)*/, speed, a);
		m_LogicAction.push(ac);
	}

	private function ActionMoveProcess():void
	{
		if(m_CurPlanetNum<0) return;
		if(m_MovePlanetNum<0) return;
		
		//if(m_CurShipNum<0) return;
		if(m_MoveShipNum<0) return;
		
		//if(m_MoveSectorX==m_CurSectorX && m_MoveSectorY==m_CurSectorY && m_MovePlanetNum==m_CurPlanetNum && m_MoveShipNum==m_CurShipNum) return;

		var ac:Action=new Action(this);
		ac.ActionMove(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveShipNum,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		m_LogicAction.push(ac);

//			if(ac.Process()) {
//				SendAction("emmove",""+m_MoveSectorX+"_"+m_MoveSectorY+"_"+m_MovePlanetNum+"_"+m_MoveShipNum+"_"+m_CurSectorX+"_"+m_CurSectorY+"_"+m_CurPlanetNum+"_"+m_CurShipNum);
//m_Test=true; trace("========= TEST ===========");
//				Update();
//m_Test=false;
//			}
	}

	private function ActionPathProcess(route:Boolean):void
	{
		var planet:Planet=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
		if(planet==null) return;
		
		var kind:int=0;
		if(route) kind=1;

		var ac:Action=new Action(this);

		ac.ActionPath(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,kind);

/*			var p:uint=planet.m_Path;
		if(route) p=planet.m_Route;
		if(p==CalcPlanetOffset(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_CurSectorX,m_CurSectorY,m_CurPlanetNum)) {
			ac.ActionPath(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,kind);

		} else {
			ac.ActionPath(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,kind);
		}*/
		m_LogicAction.push(ac);
	}
	
	private function ProcessAction():void
	{
		var i:int; 
		var an:int;
		var sec:Sector;
		if(m_LogicAction.length<=0) return;

//			if(m_UpdateRecvNum<m_SendActionAfterRecvNum) return;

		while(m_LogicAction.length>0) {
			var ac:Action=m_LogicAction[0];
			m_LogicAction.splice(0,1);

			if(ac.m_Type==Action.ActionTypeMove) {
				if(ac.Process()) {
					an=SendAction("emmove",""+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_ShipNum+"_"+ac.m_TargetSectorX+"_"+ac.m_TargetSectorY+"_"+ac.m_TargetPlanetNum+"_"+ac.m_TargetNum);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
					sec=GetSector(ac.m_TargetSectorX,ac.m_TargetSectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeCancelAutoMove) {
				if(ac.Process()) {
					an=SendAction("emcam",""+ac.m_Id.toString(16)+"_"+ac.m_SectorX+"_"+ac.m_SectorY);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeCopy) {
				if(ac.Process()) {
					an=SendAction("emcopy",""+ac.m_Id.toString()+"_"+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_ShipNum+"_"+ac.m_TargetSectorX+"_"+ac.m_TargetSectorY+"_"+ac.m_TargetPlanetNum+"_"+ac.m_TargetNum+"_"+ac.m_Kind);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
					sec=GetSector(ac.m_TargetSectorX,ac.m_TargetSectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypePathMove) {
				if(ac.Process()) {
					var p:String='';
					for (i = 0; i < ac.m_Path.length; i++) p += ac.m_Path[i].toString(16);
					an = SendAction("empathmove", "" + ac.m_SectorX + "_" + ac.m_SectorY + "_" + ac.m_PlanetNum
						+"_" + ac.m_Tmp0.toString()
						+"_" + ac.m_Tmp1.toString()
						+"_" + ac.m_Tmp2.toString()
						+"_" + ac.m_Tmp3.toString()
						+"_" + ac.m_Tmp4.toString()
						+"_" + ac.m_Tmp5.toString()
						+"_" + ac.m_Tmp6.toString()
						+"_" + ac.m_Id + "_" + ac.m_Kind + "_" + p);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeBuild) {
				if(ac.Process()) {
					an = SendAction("embuild", "" + ac.m_Id + "_" + ac.m_SectorX + "_" + ac.m_SectorY + "_" + ac.m_PlanetNum + "_" + ac.m_ShipNum + "_" + ac.m_Kind + "_" + ac.m_Cnt + "_" + ac.m_TargetNum + "_" + uint(ac.m_TargetPlanetNum).toString(10));

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeConstruction) {
				if(ac.Process()) {
					an=SendAction("emcstion",""+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_ShipNum+"_"+ac.m_Kind+"_"+ac.m_Id);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypePath) {
				if(ac.Process()) {
					if(ac.m_Kind!=0) an=SendAction("empath",""+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_TargetSectorX+"_"+ac.m_TargetSectorY+"_"+ac.m_TargetPlanetNum+"_"+ac.m_Kind.toString());
					else an=SendAction("empath",""+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_TargetSectorX+"_"+ac.m_TargetSectorY+"_"+ac.m_TargetPlanetNum);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }

					sec=GetSector(ac.m_TargetSectorX,ac.m_TargetSectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeSplit) {
				if(ac.Process()) {
					an=SendAction("emsplit",""+ac.m_Id+"_"+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_ShipNum+"_"+ac.m_TargetNum+"_"+ac.m_Cnt+"_"+ac.m_Kind);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeMake) {
				if(ac.Process()) {
					m_LoadUserAfterActionNo=SendAction("emmake",""+ac.m_Kind+"_"+ac.m_Cnt);
					m_LoadUserAfterActionNo_Time=Common.GetTime();
				}
			} else if(ac.m_Type==Action.ActionTypeGive) {
				if(ac.Process()) {
					an=SendAction("emgive",""+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_ShipNum+"_"+ac.m_Kind+"_"+ac.m_Cnt);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
					
					m_LoadUserAfterActionNo=an;
					m_LoadUserAfterActionNo_Time=Common.GetTime();
				}
			} else if(ac.m_Type==Action.ActionTypeDestroy) {
				if(ac.Process()) {
					an=SendAction("emdestroy",""+ac.m_Kind.toString()+"_"+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_ShipNum);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeCargo) {
				if(ac.Process()) {
					an=SendAction("emcargo",""+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_ShipNum+"_"+ac.m_Kind);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeResChange) {
				if(ac.Process()) {
					m_LoadUserAfterActionNo=SendAction("emreschange",""+ac.m_Kind+"_"+ac.m_Id+"_"+ac.m_Cnt);
					m_LoadUserAfterActionNo_Time=Common.GetTime();
				}
			} else if(ac.m_Type==Action.ActionTypeSpecial) {
				if(ac.Process()) {
					an=SendAction("emspecial",""+ac.m_Kind+"_"+ac.m_SectorX+"_"+ac.m_SectorY+"_"+ac.m_PlanetNum+"_"+ac.m_ShipNum);

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
					
					m_LoadUserAfterActionNo=an;
					m_LoadUserAfterActionNo_Time=Common.GetTime();
				}
			} else if(ac.m_Type==Action.ActionTypeResearch) {
				if(ac.Process()) {
					if(ac.m_Id==Server.Self.m_UserId) m_LoadUserAfterActionNo=SendActionEx(m_RootCotlId,"emresearch",""+ac.m_Kind.toString()+"_"+ac.m_TargetNum.toString());
					else m_LoadUserAfterActionNo=SendAction("emresearch",""+ac.m_Kind.toString()+"_"+ac.m_TargetNum.toString()+"_"+ac.m_Id.toString());
					m_LoadUserAfterActionNo_Time=Common.GetTime();
				}
			} else if(ac.m_Type==Action.ActionTypeTalent) {
				if(ac.Process()) {
					m_LoadUserAfterActionNo = SendAction("emtalent", "" + uint(ac.m_Tmp0).toString(16) + "_" + ac.m_Id.toString() + "_" + ac.m_Kind.toString() + "_" + ac.m_TargetNum.toString());
					m_LoadUserAfterActionNo_Time = Common.GetTime();
				}
			} else if(ac.m_Type==Action.ActionTypeToHyperspace) {
				if (ac.Process()) {
					Server.Self.m_Anm += 256;
					an=SendAction("emtohyperspace",
						""+ac.m_SectorX.toString()+
						"_"+ac.m_SectorY.toString()+
						"_"+ac.m_PlanetNum.toString()+
						"_"+ac.m_ShipNum.toString()+
						"_" + ac.m_TargetNum.toString() +
						"_" + Server.Self.m_Anm.toString()
						);
					m_FormFleetBar.m_RecvFleetAfterAnm = Server.Self.m_Anm;
					m_FormFleetBar.m_RecvFleetAfterAnm_Time = m_CurTime;

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=m_CurTime; }
				}
			} else if(ac.m_Type==Action.ActionTypeFromHyperspace) {
				if (ac.Process()) {
					Server.Self.m_Anm += 256;
					an=SendAction("emfromhyperspace",
						""+ac.m_SectorX.toString()+
						"_"+ac.m_SectorY.toString()+
						"_"+ac.m_PlanetNum.toString()+
						"_"+ac.m_ShipNum.toString()+
						"_"+ac.m_Id.toString()+
						"_"+ac.m_TargetNum.toString()+
						"_"+ac.m_Cnt.toString()+
						"_"+ac.m_Kind.toString()+
						"_"+ac.m_TargetPlanetNum.toString()+
						"_" + ac.m_TargetSectorX.toString() +
						"_" + Server.Self.m_Anm.toString()
						);
					m_FormFleetBar.m_RecvFleetAfterAnm = Server.Self.m_Anm;
					m_FormFleetBar.m_RecvFleetAfterAnm_Time = m_CurTime;

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=m_CurTime; }
				}
			} else if(ac.m_Type==Action.ActionTypeFleetFuel) {
				if (ac.Process()) {
					Server.Self.m_Anm += 256;
					an=SendAction("emfleetfuel",ac.m_Cnt.toString());
					m_FormFleetBar.m_RecvFleetAfterAnm = Server.Self.m_Anm;
					m_FormFleetBar.m_RecvFleetAfterAnm_Time = m_CurTime;
					m_LoadUserAfterActionNo=an;
					m_LoadUserAfterActionNo_Time=m_CurTime;
				}
			} else if(ac.m_Type==Action.ActionTypeItemMove) {
				if (ac.Process()) {
					Server.Self.m_Anm += 256;
					an=SendAction("emitemmove",
						""+ac.m_SectorX.toString()+
						"_"+ac.m_SectorY.toString()+
						"_"+ac.m_PlanetNum.toString()+
						"_"+ac.m_Kind.toString()+
						"_"+ac.m_Id.toString()+
						"_"+ac.m_TargetPlanetNum.toString()+
						"_"+ac.m_TargetNum.toString()+
						"_" + ac.m_Cnt.toString() +
						"_" + Server.Self.m_Anm.toString()
						);
					m_FormFleetBar.m_RecvFleetAfterAnm = Server.Self.m_Anm;
					m_FormFleetBar.m_RecvFleetAfterAnm_Time = m_CurTime;
					
					if(ac.m_PlanetNum>=0) {
						sec=GetSector(ac.m_SectorX,ac.m_SectorY);
						if (sec != null) { sec.m_LoadAfterActionNo = an; sec.m_LoadAfterActionNo_Time = m_CurTime; }
					}
				}
			} else if(ac.m_Type==Action.ActionTypePlanetItemOp) {
				if (ac.Process()) {
					an=SendAction("empiop",""+ac.m_SectorX.toString()+"_"+ac.m_SectorY.toString()+"_"+ac.m_PlanetNum.toString()+"_"+ac.m_Id.toString()+"_"+ac.m_Kind.toString()+"_"+ac.m_Cnt.toString());

					sec=GetSector(ac.m_SectorX,ac.m_SectorY);
					if(sec!=null) { sec.m_LoadAfterActionNo=an; sec.m_LoadAfterActionNo_Time=Common.GetTime(); }
				}
			} else if(ac.m_Type==Action.ActionTypeBuildingLvlBuy) {
				if (ac.Process()) {
					Server.Self.m_Anm += 256;
					if(ac.m_Id==Server.Self.m_UserId) m_LoadUserAfterActionNo=SendActionEx(m_RootCotlId,"emblb",""+ac.m_Id.toString()+"_"+ac.m_Kind.toString());
					else m_LoadUserAfterActionNo=SendAction("emblb",""+ac.m_Id.toString()+"_"+ac.m_Kind.toString());
					m_LoadUserAfterActionNo_Time = Common.GetTime();

					m_FormFleetBar.m_RecvFleetAfterAnm = Server.Self.m_Anm;
					m_FormFleetBar.m_RecvFleetAfterAnm_Time = m_CurTime;
				}
			} else if(ac.m_Type==Action.ActionTypeFleetSpecial) {
				if (ac.Process()) {
					Server.Self.m_Anm += 256;
					m_LoadUserAfterActionNo=SendActionEx(m_RootCotlId,"emfleetspeciala",""+ac.m_Kind.toString()+"_"+ac.m_Id.toString());
					m_LoadUserAfterActionNo_Time = Common.GetTime();

					m_FormFleetBar.m_RecvFleetAfterAnm = Server.Self.m_Anm;
					m_FormFleetBar.m_RecvFleetAfterAnm_Time = m_CurTime;
				}
//				} else if(ac.m_Type==Action.ActionTypeCombat) {
//					if(ac.Process()) {
//						/*m_FormCombat.m_LoadCombatAfterActionNo=*/SendAction("emcombata",ac.m_Kind.toString()+"_"+ac.m_Id.toString()+"_"+ac.m_Cnt.toString());
//						//m_FormCombat.m_LoadCombatAfterActionNo_Time=Common.GetTime();
//					}
			}
		}

		m_SendActionAfterRecvNum=m_UpdateSendNum;
//trace("ProcessAction. SendNum="+m_UpdateSendNum+" RecvNum="+m_UpdateRecvNum+" SendActionAfterRecvNum="+m_SendActionAfterRecvNum);
	}

	public function GetServerCalcTime():Number
	{
		if (IsEdit()) return m_ServerCalcTimeSyn;
		else return m_ServerCalcTimeSyn + (new Date()).getTime() - m_ServerCalcTimeSynRecvTime;
	}

	public function GetServerGlobalTime():Number
	{
		return m_ServerGlobalTimeSyn + (new Date()).getTime() - m_ServerGlobalTimeSynRecvTime;
	}

	public function GetServerDate():Date
	{
		var d:Date=new Date();
		d.setTime(m_ConnectDate.getTime() + (GetServerGlobalTime() - m_ConnectTime));
		return d;
	}

	public function IsFriend(owner1:uint, race1:uint, owner2:uint, race2:uint):Boolean
	{
		if(!owner1) {
			if(owner1!=owner2) return false;
			return race1==race2;
		}
		
		if(owner1==owner2) return true;
		return false;			
	}
	
	private var m_IsFriendEx_pown:uint=0;
	private var m_IsFriendEx_owner1:uint=0;
	private var m_IsFriendEx_owner2:uint=0;
	private var m_IsFriendEx_res:Boolean=false;
	public function IsFriendEx(planet:Planet, owner1:uint, race1:uint, owner2:uint, race2:uint):Boolean
	{
		if(planet==null || !owner1 || !owner2) return IsFriend(owner1,race1,owner2,race2);

		if(owner1==owner2) return true;
		
//			if(m_CotlType==Common.CotlTypeProtect && (m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0) return false;

		if(m_Rel.length<=0) return false;

		if(m_IsFriendEx_pown==planet.m_Owner && m_IsFriendEx_owner1==owner1 && m_IsFriendEx_owner2==owner2) return m_IsFriendEx_res;
		m_IsFriendEx_pown=planet.m_Owner;
		m_IsFriendEx_owner1=owner1;
		m_IsFriendEx_owner2=owner2;
		
		if(/*m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich*/true) {
			var user1:User=UserList.Self.GetUser(owner1,false);
			var user2:User=UserList.Self.GetUser(owner2,false);

			var teamrel:int=0;
			if(user1!=null && user2!=null && user1.m_Team>=0 && user1.m_Team<(1<<Common.TeamMaxShift) && user2.m_Team>=0 && user2.m_Team<(1<<Common.TeamMaxShift)) {
				teamrel=m_TeamRel[user1.m_Team+(user2.m_Team<<Common.TeamMaxShift)];
			} else if(m_CotlType==Common.CotlTypeCombat) { m_IsFriendEx_res=false; return false; }
			
			if(teamrel==Common.TeamRelWar) { m_IsFriendEx_res=false; return false; }
			else if(teamrel==Common.TeamRelPeace) { m_IsFriendEx_res=true; return m_IsFriendEx_res; }
			else if((m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0) { m_IsFriendEx_res=false; return false; }
		}

		var i:int,off:int;

		var relnum1:int=0;
		var relnum2:int=0;

//			m_Rel.position=0;
//    		var cnt:int=m_Rel.readUnsignedInt();
//    		for(i=0;i<cnt;i++) {
//    			var own:uint=m_Rel.readUnsignedInt();
//    			if(own==owner1) relnum1=i;
//    			if(own==owner2) relnum2=i;
//    		}
		var cnt:int = m_RelCnt;
		if (m_RelOwnerNum[owner1] != undefined) relnum1 = m_RelOwnerNum[owner1];
		if (m_RelOwnerNum[owner2] != undefined) relnum2 = m_RelOwnerNum[owner2];
		
		if(relnum1<=0) { m_IsFriendEx_res=false; return false; }
		if(relnum2<=0) { m_IsFriendEx_res=false; return false; }

		if(planet.m_Owner==owner1) {
			m_Rel.position=4+4*cnt+relnum1*cnt+relnum2;				
			if(m_Rel.readUnsignedByte() & Common.PactPass) { m_IsFriendEx_res=true; return true; }

		} else if(planet.m_Owner==owner2) {
			m_Rel.position=4+4*cnt+relnum2*cnt+relnum1;				
			if(m_Rel.readUnsignedByte() & Common.PactPass) { m_IsFriendEx_res=true; return true; }

		} else {
			m_Rel.position=4+4*cnt+relnum1*cnt+relnum2;				
			if(m_Rel.readUnsignedByte() & Common.PactNoBattle) { m_IsFriendEx_res=true; return true; }
		}

		m_IsFriendEx_res=false;
		return false;
	}
	
	public function IsFriendEx2(planet_own:uint, owner1:uint, race1:uint, owner2:uint, race2:uint):Boolean
	{
		if(planet_own==0 || !owner1 || !owner2) return IsFriend(owner1,race1,owner2,race2);

		if(owner1==owner2) return true;

		if((m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat) && (m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0) return false;
		
		if(m_Rel.length<=0) return false;

		if(m_IsFriendEx_pown==planet_own && m_IsFriendEx_owner1==owner1 && m_IsFriendEx_owner2==owner2) return m_IsFriendEx_res;
		m_IsFriendEx_pown=planet_own;
		m_IsFriendEx_owner1=owner1;
		m_IsFriendEx_owner2=owner2;

		if(/*m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich*/true) {
			var user1:User=UserList.Self.GetUser(owner1,false);
			var user2:User=UserList.Self.GetUser(owner2,false);
			
			var teamrel:int=0;
			if(user1!=null && user2!=null && user1.m_Team>=0 && user1.m_Team<(1<<Common.TeamMaxShift) && user2.m_Team>=0 && user2.m_Team<(1<<Common.TeamMaxShift)) {
				teamrel=m_TeamRel[user1.m_Team+(user2.m_Team<<Common.TeamMaxShift)];
			} else if(m_CotlType==Common.CotlTypeCombat) { m_IsFriendEx_res=false; return false; }
			
			if(teamrel==Common.TeamRelWar) { m_IsFriendEx_res=false; return false; }
			else if(teamrel==Common.TeamRelPeace) { m_IsFriendEx_res=true; return m_IsFriendEx_res; }
			else if((m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0) { m_IsFriendEx_res=false; return false; }
		}

		var i:int,off:int;
		
		var relnum1:int=0;
		var relnum2:int=0;

/*    		var user1:User=UserList.Self.GetUser(owner1);
		var user2:User=user1;
		if(owner1!=owner2) user2=UserList.Self.GetUser(owner2);
		
		if(user1!=null && user1.m_RelVer==m_RelVersion) relnum1=user1.m_RelNum;
		if(user2!=null && user2.m_RelVer==m_RelVersion) relnum2=user2.m_RelNum;

		if(relnum1==0 || relnum2==0) {*/
/*				m_Rel.position=0;
			var cnt:int=m_Rel.readUnsignedInt();
			for(i=0;i<cnt;i++) {
				var own:uint=m_Rel.readUnsignedInt();
				if(own==owner1) relnum1=i;
				if(own==owner2) relnum2=i;
			}
			if(relnum1<=0) { m_IsFriendEx_res=false; return false; }
			if(relnum2<=0) { m_IsFriendEx_res=false; return false; }*/
		var cnt:int = m_RelCnt;
		if (m_RelOwnerNum[owner1] != undefined) relnum1 = m_RelOwnerNum[owner1];
		if (m_RelOwnerNum[owner2] != undefined) relnum2 = m_RelOwnerNum[owner2];
			
/*	    		if(user1!=null) { user1.m_RelNum=relnum1; user1.m_RelVer=m_RelVersion; }
			if(user2!=null) { user2.m_RelNum=relnum2; user2.m_RelVer=m_RelVersion; }
		}*/

		if(planet_own==owner1) {
			m_Rel.position=4+4*cnt+relnum1*cnt+relnum2;				
			if(m_Rel.readUnsignedByte() & Common.PactPass)  { m_IsFriendEx_res=true; return true; }

		} else if(planet_own==owner2) {
			m_Rel.position=4+4*cnt+relnum2*cnt+relnum1;				
			if(m_Rel.readUnsignedByte() & Common.PactPass)  { m_IsFriendEx_res=true; return true; }

		} else {
			m_Rel.position=4+4*cnt+relnum1*cnt+relnum2;				
			if(m_Rel.readUnsignedByte() & Common.PactNoBattle)  { m_IsFriendEx_res=true; return true; }
		}

		m_IsFriendEx_res=false;
		return false;
	}

	private var m_IsFriendHome_homeowner:uint=0;
	private var m_IsFriendHome_owner2:uint=0;
	private var m_IsFriendHome_res:Boolean=false;
	public function IsFriendHome(homeowner:uint, owner2:uint):Boolean
	{
		if(homeowner==owner2) return true;

//			if(m_CotlType==Common.CotlTypeProtect && (m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0) return false;

		if(m_Rel.length<=0) return false;

		if(m_IsFriendHome_homeowner==homeowner && m_IsFriendHome_owner2==owner2) return m_IsFriendHome_res;
		m_IsFriendHome_homeowner=homeowner;
		m_IsFriendHome_owner2=owner2;

		if(/*m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich*/true) {
			var user1:User=UserList.Self.GetUser(homeowner,false);
			var user2:User=UserList.Self.GetUser(owner2,false);
			
			var teamrel:int=0;
			if(user1!=null && user2!=null && user1.m_Team>=0 && user1.m_Team<(1<<Common.TeamMaxShift) && user2.m_Team>=0 && user2.m_Team<(1<<Common.TeamMaxShift)) {
				teamrel=m_TeamRel[user1.m_Team+(user2.m_Team<<Common.TeamMaxShift)];
			} else if(m_CotlType==Common.CotlTypeCombat) { m_IsFriendHome_res=false; return false; }
			
			if(teamrel==Common.TeamRelWar) { m_IsFriendHome_res=false; return false; }
			else if(teamrel==Common.TeamRelPeace) { m_IsFriendHome_res=true; return m_IsFriendHome_res; }
			else if((m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0) { m_IsFriendHome_res=false; return false; }
		}

		var i:int,off:int;

		var relnum1:int=0;
		var relnum2:int=0;

/*			m_Rel.position=0;
		var cnt:int=m_Rel.readUnsignedInt();
		for(i=0;i<cnt;i++) {
			var own:uint=m_Rel.readUnsignedInt();
			if(own==homeowner) relnum1=i;
			if(own==owner2) relnum2=i;
		}*/
		var cnt:int = m_RelCnt;
		if (m_RelOwnerNum[homeowner] != undefined) relnum1 = m_RelOwnerNum[homeowner];
		if (m_RelOwnerNum[owner2] != undefined) relnum2 = m_RelOwnerNum[owner2];
		
		if(relnum1<=0) { m_IsFriendHome_res=false; return false; }
		if(relnum2<=0) { m_IsFriendHome_res=false; return false; }

		m_Rel.position=4+4*cnt+relnum1*cnt+relnum2;				
		if(m_Rel.readUnsignedByte() & Common.PactPass) { m_IsFriendHome_res=true; return true; }

		m_IsFriendHome_res=false;
		return false;
	}

	private var m_GetRel_owner1:uint=0;
	private var m_GetRel_owner2:uint=0;
	private var m_GetRel_res:uint=0;
	public function GetRel(owner1:uint, owner2:uint):uint
	{
//			if(m_CotlType==Common.CotlTypeProtect && (m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0) return 0;

		if(m_Rel.length<=0) return 0;

		if(m_GetRel_owner1==owner1 && m_GetRel_owner2==owner2) return m_GetRel_res;
		m_GetRel_owner1=owner1;
		m_GetRel_owner2=owner2;

		var user1:User=UserList.Self.GetUser(owner1,false);
		var user2:User=UserList.Self.GetUser(owner2,false);
		if (/*m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich*/user1 && user2) {
//if(user1.m_Id==4 || user2.m_Id==4) trace("rel00", user1.m_Id, user2.m_Id, user1.m_Team, user2.m_Team);
			var teamrel:int=0;
			if(user1!=null && user2!=null && user1.m_Team>=0 && user1.m_Team<(1<<Common.TeamMaxShift) && user2.m_Team>=0 && user2.m_Team<(1<<Common.TeamMaxShift)) {
				teamrel=m_TeamRel[user1.m_Team+(user2.m_Team<<Common.TeamMaxShift)];
			} else if(m_CotlType==Common.CotlTypeCombat) { m_GetRel_res=0; return 0; }

//if(user1.m_Id==4 || user2.m_Id==4) trace("rel01", teamrel);
			if(teamrel==Common.TeamRelWar) { m_GetRel_res=0; return 0; }
			else if (teamrel == Common.TeamRelPeace) {
				m_GetRel_res = Common.PactPass | Common.PactNoBattle;
				//if(m_CotlType==Common.CotlTypeRich) m_GetRel_res = Common.PactPass | Common.PactNoBattle | Common.PactControl | Common.PactBuild;
				//else m_GetRel_res = Common.PactPass | Common.PactNoBattle;

				if ((user1.m_Id & Common.OwnerAI) == 0 && (user2.m_Id & Common.OwnerAI) != 0 && (user2.m_Flag & Common.UserFlagPlayerControl) != 0) m_GetRel_res |= Common.PactControl;
				else if ((user1.m_Id & Common.OwnerAI) != 0 && (user2.m_Id & Common.OwnerAI) == 0 && (user1.m_Flag & Common.UserFlagPlayerControl) != 0) m_GetRel_res |= Common.PactControl;

//if(user1.m_Id==4 || user2.m_Id==4) trace("rel02", m_GetRel_res.toString(16));
				return m_GetRel_res;
			}
			else if((m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0) { m_GetRel_res=0; return 0; }
		}

		var i:int,off:int;
		
		var relnum1:int=0;
		var relnum2:int=0;

/*			m_Rel.position=0;
		var cnt:int=m_Rel.readUnsignedInt();
		for(i=0;i<cnt;i++) {
			var own:uint=m_Rel.readUnsignedInt();
			if(own==owner1) relnum1=i;
			if(own==owner2) relnum2=i;
		}*/
		var cnt:int = m_RelCnt;
		if (m_RelOwnerNum[owner1] != undefined) relnum1 = m_RelOwnerNum[owner1];
		if (m_RelOwnerNum[owner2] != undefined) relnum2 = m_RelOwnerNum[owner2];
		
		if(relnum1<=0) { m_GetRel_res=0; return 0; }
		if(relnum2<=0) { m_GetRel_res=0; return 0; }

		m_Rel.position=4+4*cnt+relnum1*cnt+relnum2;	
		m_GetRel_res=m_Rel.readUnsignedByte();			
		return m_GetRel_res;
	}
	
	public function AccessControl(owner:uint):Boolean
	{
		if(owner==Server.Self.m_UserId) return true;
		return (GetRel(owner,Server.Self.m_UserId) & Common.PactControl)!=0;
	}

	public function AccessBuild(owner:uint):Boolean
	{
		if(owner==Server.Self.m_UserId) return true;
		return (GetRel(owner,Server.Self.m_UserId) & Common.PactBuild)!=0;
	}

	public function ColorByOwner(planet:Planet, owner:uint, minimap:Boolean=false):uint
	{
//if(owner!=0) trace("ColorByOwner ",owner,m_UserId);
		var user:User;
		
		if(minimap) {
			if(!owner) return 0xA0A0A0;
			if (owner == Server.Self.m_UserId) return 0x00f0ff;//ffff00;
			
			if (m_CotlType == Common.CotlTypeCombat) {
				user = UserList.Self.GetUser(Server.Self.m_UserId);
				if (user != null && user.m_Team < 0) {
					user = UserList.Self.GetUser(owner);
					if (user != null && user.m_Team >= 0) {
						if (user.m_Team == m_OpsTeamOwner) return 0x4f6f00;
						else return 0xff0000;
					}
				}
			}
			
			if(IsFriendEx(planet,owner,Common.RaceNone,Server.Self.m_UserId,Common.RaceNone)) return 0x4f6f00;
			return 0xff0000;

		} else {
			if(!owner) return 0x404040;
			if (owner == Server.Self.m_UserId) return 0x0040E0;//ffff00;

			if (m_CotlType == Common.CotlTypeCombat) {
				user = UserList.Self.GetUser(Server.Self.m_UserId);
				if (user != null && user.m_Team < 0) {
					user = UserList.Self.GetUser(owner);
					if (user != null && user.m_Team >= 0) {
						if (user.m_Team == m_OpsTeamOwner) return 0x306000;
						else return 0x800000;
					}
				}
			}

			if(IsFriendEx(planet,owner,Common.RaceNone,Server.Self.m_UserId,Common.RaceNone)) return 0x306000;
			return 0x800000;
		}
	}

	public function CntFriendGroup(planet:Planet, owner:uint, race:uint, inbattle:Boolean=false):int
	{
		var i:int,cnt:int;
		var ship:Ship;
		
		var sopl:int = planet.ShipOnPlanetLow;
		cnt=0;
		for(i=0;i<sopl;i++) {
			ship=planet.m_Ship[i];
			if(ship.m_Type==Common.ShipTypeNone) continue;

			if(IsFriendEx(planet,ship.m_Owner,ship.m_Race,owner,race)) {
				if(!inbattle) cnt++;
				else if(ship.m_Flag & Common.ShipFlagBattle) cnt++;
			}
		}
		return cnt;
	}

	public function CntEnemyGroup(planet:Planet, owner:uint, race:uint):int
	{
		var i:int,cnt:int;
		var ship:Ship;
		
		var sopl:int = planet.ShipOnPlanetLow;
		cnt=0;
		for(i=0;i<sopl;i++) {
			ship=planet.m_Ship[i];
			if(ship.m_Type==Common.ShipTypeNone) continue;

			if(!IsFriendEx(planet,ship.m_Owner,ship.m_Race,owner,race)) cnt++;
		}
		return cnt;
	}

	public function HaveEnemyInBattle(planet:Planet, owner:uint, race:int, test:Boolean=false):Boolean
	{
		var i:int;

		for(i=0;i<Common.ShipOnPlanetMax;i++) {
			var ship:Ship=planet.m_Ship[i];
			if(ship.m_Type==Common.ShipTypeNone) continue;
			if(ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb)) continue;
			if(!(ship.m_Flag & Common.ShipFlagBattle)) continue;
			if(IsFriendEx(planet,owner,race,ship.m_Owner,ship.m_Race)) continue;

			return true;
		}

		return false;
	}
	
	public function FindOwnerOtherPlanet(owner:uint, race:uint,  secx:int,secy:int,plnum:int, fromnum:int, inbattle:Boolean):int
	{
		var i:int,n:int,cnt:int,d:int,find:int,findr:int;
		var ship:Ship;
		var isfriend:Boolean;
		var btl:Boolean;

		var pl:Planet=GetPlanet(secx,secy,plnum);
		if(pl==null) return -1;

		var sopl:int = pl.ShipOnPlanetLow;
		cnt = (sopl >> 1);
		if (sopl & 1) cnt++;
		
		var cur_ownerid:uint = 0xffffffff;
		var cur_race:int = -1;
		var cur_friend:Boolean = false;

		find=-1;
		n=fromnum; if(n>=sopl) n=0;
		for(i=0;i<cnt;i++) {
			ship=pl.m_Ship[n];
			if (ship.m_Type != Common.ShipTypeNone /*&& (!(ship.m_Flag & Common.ShipFlagBuild))*/ && (ship.m_ArrivalTime <= m_ServerCalcTime || (ship.m_FromSectorX == secx && ship.m_FromSectorY == secy && ship.m_FromPlanet == plnum))) {
				btl=(ship.m_Flag & Common.ShipFlagBattle)!=0;

				if (btl == inbattle) {
					if (owner == ship.m_Owner && race == ship.m_Race) { find = n; findr = i; break; }

					if (cur_ownerid != ship.m_Owner || cur_race != ship.m_Race) {
						cur_ownerid = ship.m_Owner;
						cur_race = ship.m_Race;
						cur_friend = IsFriendEx(pl, owner, race, ship.m_Owner, ship.m_Race);
					}
					if (cur_friend) { find=n; findr=i; break; }
				}
			}

			n++; if(n>=sopl) n=0; else if(n>=sopl) n=0;
		}

		n=fromnum-1; if(n<0 || n>=sopl) n=sopl-1;
		for(i=0;i<cnt;i++) {
			ship=pl.m_Ship[n];
			if (ship.m_Type != Common.ShipTypeNone /*&& (!(ship.m_Flag & Common.ShipFlagBuild))*/ && (ship.m_ArrivalTime <= m_ServerCalcTime || (ship.m_FromSectorX == secx && ship.m_FromSectorY == secy && ship.m_FromPlanet == plnum))) {
				btl=(ship.m_Flag & Common.ShipFlagBattle)!=0;

				if (btl == inbattle) {
					if (owner == ship.m_Owner && race == ship.m_Race) {
						if(find<0) return n;
						if(i<findr) return n;
						return find;
					}

					if (cur_ownerid != ship.m_Owner || cur_race != ship.m_Race) {
						cur_ownerid = ship.m_Owner;
						cur_race = ship.m_Race;
						cur_friend = IsFriendEx(pl, owner, race, ship.m_Owner, ship.m_Race);
					}
					if (cur_friend) { 
						if(find<0) return n;
						if(i<findr) return n;
						return find;
					}
				}
			}

			n--; if(n<0) n=sopl-1;
		}

		return find;
	}

	public function FindEnemyOtherPlanet(owner:uint, race:uint, secx:int,secy:int,plnum:int, fromnum:int, typemask:uint, inbattle:Boolean, skipnum:int=-1):int
	{
		var i:int,n:int,cnt:int,d:int,find:int,findr:int;
		var ship:Ship;
		var isfriend:Boolean;
		var btl:Boolean;

		var pl:Planet=GetPlanet(secx,secy,plnum);
		if(pl==null) return -1;

		var sopl:int = pl.ShipOnPlanetLow;
		cnt = (sopl >> 1);
		if (sopl & 1) cnt++;

		find=-1;
		n=fromnum; if(n>=sopl) n=0;
		for(i=0;i<cnt;i++) {
			ship=pl.m_Ship[n];
			if (ship.m_Type != Common.ShipTypeNone /*&& (!(ship.m_Flag & Common.ShipFlagBuild))*/ && (ship.m_ArrivalTime <= m_ServerCalcTime || (ship.m_FromSectorX == secx && ship.m_FromSectorY == secy && ship.m_FromPlanet == plnum))) {
				btl=(ship.m_Flag & Common.ShipFlagBattle)!=0;
				isfriend=IsFriendEx(pl,owner,race,ship.m_Owner,ship.m_Race);

				if(skipnum!=n && !isfriend && btl==inbattle) {
					if((1<<ship.m_Type) & typemask) {
						find=n;
						findr=i;
						break;						
					}						
				}
			}

			n++; if(n>=sopl) n=0;
		}

		n = fromnum - 1; if (n<0 || n>=sopl) n=sopl-1;
		for(i=0;i<cnt;i++) {
			ship=pl.m_Ship[n];
			if (ship.m_Type != Common.ShipTypeNone /*&& (!(ship.m_Flag & Common.ShipFlagBuild))*/ && (ship.m_ArrivalTime <= m_ServerCalcTime || (ship.m_FromSectorX == secx && ship.m_FromSectorY == secy && ship.m_FromPlanet == plnum))) {
				btl=(ship.m_Flag & Common.ShipFlagBattle)!=0;
				isfriend=IsFriendEx(pl,owner,race,ship.m_Owner,ship.m_Race);

				if(skipnum!=n && !isfriend && btl==inbattle) {
					if((1<<ship.m_Type) & typemask) {
//if(skipnum) trace("find second "+n);
						if(find<0) return n;
						if(i<findr) return n;

						return find;						
					}						
				}
			}

			n--; if(n<0) n=sopl-1;
		}

		return find;
	}

	public function IsInFrontLine(planet:Planet, fromnum:int):Boolean
	{
		var n:int,i:int;
		var ship:Ship;
		var sopl:int = planet.ShipOnPlanetLow;
		var cnt:int = sopl - 1;

		var fromship:Ship=planet.m_Ship[fromnum];
		if(fromship.m_Type==Common.ShipTypeNone) return false;

		n=fromnum+1; if(n>=sopl) n=0;
		for (i = 0; i < cnt; i++) {
			ship = planet.m_Ship[n];
			if ((ship.m_Type != Common.ShipTypeNone) && ((ship.m_Flag & Common.ShipFlagBattle) != 0)) {
				if (IsFriendEx(planet, fromship.m_Owner, fromship.m_Race, ship.m_Owner, ship.m_Race)) break;
				return true;
			}
			n++; if (n >= sopl) n = 0;
		}

		n=fromnum-1; if(n<0) n=sopl-1;
		for(i=0;i<cnt;i++) {
			ship = planet.m_Ship[n];
			if ((ship.m_Type != Common.ShipTypeNone) && ((ship.m_Flag & Common.ShipFlagBattle) != 0)) {
				if (IsFriendEx(planet, fromship.m_Owner, fromship.m_Race, ship.m_Owner, ship.m_Race)) break;
				return true;
			}
			n--; if(n<0) n=sopl-1;
		}
		return false;
	}

	public function FindNearEnemy(secx:int,secy:int,plnum:int, fromnum:int, typemask:uint, depth:int, inbattle:Boolean, skipnum:int=-1):int
	{
		var i:int, n:int, cnt:int, d:int, find:int, findr:int, findprior:int, p:int;
		var ship:Ship;
		var isfriend:Boolean;
		var btl:Boolean;

		var pl:Planet=GetPlanet(secx,secy,plnum);
		if (pl == null) return -1;
		var sopl:int = pl.ShipOnPlanetLow;

		var fromship:Ship=pl.m_Ship[fromnum];
		if(fromship.m_Type==Common.ShipTypeNone) return -1;

		cnt=sopl-1;

		find = -1;
		findprior = 0;
		d=0;
		n=fromnum+1; if(n>=sopl) n=0;
		for(i=0;i<cnt;i++) {
			ship=pl.m_Ship[n];
			if (ship.m_Type != Common.ShipTypeNone /*&& (!(ship.m_Flag & Common.ShipFlagBuild))*/ && (ship.m_ArrivalTime <= m_ServerCalcTime || (ship.m_FromSectorX == secx && ship.m_FromSectorY == secy && ship.m_FromPlanet == plnum))) {
				btl=(ship.m_Flag & (Common.ShipFlagBattle|Common.ShipFlagBomb))!=0;
				isfriend=IsFriendEx(pl,fromship.m_Owner,fromship.m_Race,ship.m_Owner,ship.m_Race);

				if(skipnum!=n && !isfriend && btl==inbattle) {
					if((1<<ship.m_Type) & typemask) {
						find=n;
						findr = i;
						if (fromship.m_Type == Common.ShipTypeCorvette) findprior = (Common.ShipHitPriorCorvette[ship.m_Type] << 16);// | Math.max(0, 999 - ship.m_Cnt);
						break;						
					}						
				}
				if(btl!=inbattle) {}
				else if(isfriend && !btl) {}
///					else if (fromship.m_Type == Common.ShipTypeCorvette && inbattle) {
////					if ((ship.m_Flag & Common.ShipFlagPhantom) != 0) break;
//						if (!isfriend && ship.m_Type == Common.ShipTypeCruiser) { }
//						else if (!isfriend && ship.m_Type == Common.ShipTypeCorvette) { }
////					else if(isfriend && ship.m_Type==Common.ShipTypeCorvette) {}
//						else break;
//					}
				else if (fromship.m_Type == Common.ShipTypeCorvette && inbattle && isfriend) break;
				else {
					d++;
					if (d >= depth) break;
				}
			} else {
//					if(fromship.m_Type==Common.ShipTypeCorvette && inbattle && depth>1) break;
				if(fromship.m_Type==Common.ShipTypeCorvette && depth>1) {
					d++;
					if (d >= depth) break;
				}
			}

			n++; if(n>=sopl) n=0;
		}

		d=0;
		n=fromnum-1; if(n<0) n=sopl-1;
		for(i=0;i<cnt;i++) {
			ship=pl.m_Ship[n];
			if (ship.m_Type != Common.ShipTypeNone /*&& (!(ship.m_Flag & Common.ShipFlagBuild))*/ && (ship.m_ArrivalTime <= m_ServerCalcTime || (ship.m_FromSectorX == secx && ship.m_FromSectorY == secy && ship.m_FromPlanet == plnum))) {
				btl=(ship.m_Flag & (Common.ShipFlagBattle|Common.ShipFlagBomb))!=0;
				isfriend=IsFriendEx(pl,fromship.m_Owner,fromship.m_Race,ship.m_Owner,ship.m_Race);

				if(skipnum!=n && !isfriend && btl==inbattle) {
					if((1<<ship.m_Type) & typemask) {
//if(skipnum) trace("find second "+n);
						if(find<0) return n;
						if (i < findr) return n;

						p = 0;
						if (fromship.m_Type == Common.ShipTypeCorvette) p = (Common.ShipHitPriorCorvette[ship.m_Type] << 16);// | Math.max(0, 999 - ship.m_Cnt);
						if (p > findprior) return n;

						return find;						
					}						
				}
				if(btl!=inbattle) {}
				else if(isfriend && !btl) {}
//					else if (fromship.m_Type == Common.ShipTypeCorvette && inbattle) {
////					if ((ship.m_Flag & Common.ShipFlagPhantom) != 0) break;
//						if (!isfriend && ship.m_Type == Common.ShipTypeCruiser) { }
//						else if (!isfriend && ship.m_Type == Common.ShipTypeCorvette) { }
////					else if(isfriend && ship.m_Type==Common.ShipTypeCorvette) {}
//						else break;
//					}
				else if (fromship.m_Type == Common.ShipTypeCorvette && inbattle && isfriend) break;
				else {
					d++;
					if(d>=depth) break;
				}
			} else {
//					if(fromship.m_Type==Common.ShipTypeCorvette && inbattle && depth>1) break;
				if (fromship.m_Type == Common.ShipTypeCorvette && depth > 1) {
					d++;
					if (d >= depth) break;
				}
			}

			n--; if(n<0) n=sopl-1;
		}

		return find;
	}

	public function FindForTransiver(secx:int,secy:int,plnum:int, fromnum:int):int
	{
		var i:int;
		var ship:Ship;

		var pl:Planet=GetPlanet(secx,secy,plnum);
		if (pl == null) return -1;
		var sopl:int = pl.ShipOnPlanetLow;

		var fromship:Ship=pl.m_Ship[fromnum];
		if(fromship.m_Type==Common.ShipTypeNone) return -1;
		
		var vm:uint;
		var ri:int=-1;

		for(i=0;i<sopl;i++) {
			ship=pl.m_Ship[i];

			if (ship.m_Type == Common.ShipTypeFlagship) { }
			else if (ship.m_Type == Common.ShipTypeQuarkBase) { }
			else if (ship.m_Race == Common.RaceTechnol) { }
			else continue;

			if (/*(!(ship.m_Flag & Common.ShipFlagBuild)) &&*/ (ship.m_ArrivalTime <= m_ServerCalcTime || (ship.m_FromSectorX == secx && ship.m_FromSectorY == secy && ship.m_FromPlanet == plnum))) { }
			else continue;

			if(ship.m_Owner==fromship.m_Owner) {}
			else if(IsFriendEx(pl,fromship.m_Owner,fromship.m_Race,ship.m_Owner,ship.m_Race)) {}
			else continue;

			//var shm:int=VecValE(ship.m_Owner,ship.m_Id,Common.VecProtectShield);
			var shm:int = 0;
			shm = ShipMaxShield(ship.m_Owner, ship.m_Id, ship.m_Type, ship.m_Race, ship.m_Cnt);
			if (shm <= 0) continue;
			if(ship.m_Shield>=shm) continue;
			var v:uint = (ship.m_Shield << 8) / shm;
			if(ship.m_Type!=Common.ShipTypeFlagship && ship.m_Type!=Common.ShipTypeQuarkBase) v|=0x80000000;

			if(ri<0 || v<vm) {
				ri=i;
				vm=v;
			}
		}
		
		return ri;
	}
	
	public function FindForMine(secx:int,secy:int,plnum:int, fromnum:int):int
	{
		var i:int;
		var ship:Ship;

		var pl:Planet=GetPlanet(secx,secy,plnum);
		if (pl == null) return -1;
		var sopl:int = pl.ShipOnPlanetLow;

		var fromship:Ship=pl.m_Ship[fromnum];
		if(fromship.m_Type!=Common.ShipTypeFlagship) return -1;

		var maxdist:int=VecValE(fromship.m_Owner, fromship.m_Id, Common.VecSystemSensor);

		var i1:int=fromnum;
		var i2:int=fromnum;
		for(i=0;i<maxdist;i++) {
			i1++; if(i1>=sopl) i1=0;
			i2--; if(i2<0) i2=sopl-1;

			ship=pl.m_Ship[i1];
			while(true) {
				if(ship.m_OrbitItemType!=Common.ItemTypeMine) break;
				if(ship.m_OrbitItemOwner==fromship.m_Owner) break;
				if(ship.m_Type!=Common.ShipTypeNone) break;
//					if(!IsShowMine(i1,ship,pl,fromship.m_Owner)) break;

				if(IsFriendEx(pl,fromship.m_Owner,fromship.m_Race,ship.m_OrbitItemOwner,Common.RaceNone)) break;

				return i1;
			}

			ship=pl.m_Ship[i2];
			while(true) {
				if(ship.m_OrbitItemType!=Common.ItemTypeMine) break;
				if(ship.m_OrbitItemOwner==fromship.m_Owner) break;
				if(ship.m_Type!=Common.ShipTypeNone) break;
//					if(!IsShowMine(i2,ship,pl,fromship.m_Owner)) break;

				if(IsFriendEx(pl,fromship.m_Owner,fromship.m_Race,ship.m_OrbitItemOwner,Common.RaceNone)) break;

				return i2;
			}
		}
		return -1;
	}

	public function IsBattle(planet:Planet, owner:uint, race:uint, testinbattle:Boolean=true, testbuild:Boolean=true):Boolean
	{
		var i:int;

		if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
		var sopl:int = planet.ShipOnPlanetLow;

		for(i=0;i<sopl;i++) {
			var ship:Ship=planet.m_Ship[i];
			if(ship.m_Type==Common.ShipTypeNone) continue;
			if (testinbattle && (ship.m_Flag & Common.ShipFlagBattle) == 0) continue;
			if(testbuild && (ship.m_Flag & Common.ShipFlagBuild)!=0) continue;
//		        if(ship.m_ArrivalTime>GetServerTime()) continue;
//		        if(!(ship.m_ArrivalTime<=GetServerTime() || (ship.m_FromSectorX==planet.m_Sector.m_SectorX && ship.m_FromSectorY==planet.m_Sector.m_SectorY && ship.m_FromPlanet==planet.m_PlanetNum))) continue;
			if (/*testinbattle && */IsFlyOtherPlanet(ship, planet)) continue;

			if(!IsFriendEx(planet,ship.m_Owner,ship.m_Race,owner,race)) return true;
		}
		return false;
	}

	public function IsBattleIgnoreNeutral(planet:Planet, owner:uint, race:uint, testinbattle:Boolean=true, testbuild:Boolean=true):Boolean
	{
		var i:int;

		if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
		var sopl:int = planet.ShipOnPlanetLow;

		for(i=0;i<sopl;i++) {
			var ship:Ship=planet.m_Ship[i];
			if (ship.m_Type == Common.ShipTypeNone) continue;
			if (ship.m_Owner == 0) continue;
			if (testinbattle && (ship.m_Flag & Common.ShipFlagBattle) == 0) continue;
			if(testbuild && (ship.m_Flag & Common.ShipFlagBuild)!=0) continue;
//		        if(ship.m_ArrivalTime>GetServerTime()) continue;
//		        if(!(ship.m_ArrivalTime<=GetServerTime() || (ship.m_FromSectorX==planet.m_Sector.m_SectorX && ship.m_FromSectorY==planet.m_Sector.m_SectorY && ship.m_FromPlanet==planet.m_PlanetNum))) continue;
			if (/*testinbattle && */IsFlyOtherPlanet(ship, planet)) continue;

			if(!IsFriendEx(planet,ship.m_Owner,ship.m_Race,owner,race)) return true;
		}
		return false;
	}

	public function IsBuild(planet:Planet):Boolean
	{
		var i:int;

		for(i=0;i<Common.ShipOnPlanetMax;i++) {
			var ship:Ship=planet.m_Ship[i];
			if(ship.m_Type==Common.ShipTypeNone) continue;
			if(ship.m_Flag & Common.ShipFlagBuild) return true;
		}

		return false;
	}

	public function ExistFriendShip(planet:Planet, owner:uint, race:uint, and_low_orbit:Boolean, skipshipflag:uint):Boolean
	{
		var cnt:int=planet.ShipOnPlanetLow;
		if(and_low_orbit) cnt=Common.ShipOnPlanetMax;

		var cur_own:uint=0;
		var cur_friend:Boolean=false;

		var i:int;
		for (i = 0; i < cnt; i++) {
			var ship:Ship = planet.m_Ship[i];
			if (ship.m_Type == Common.ShipTypeNone) continue;
			if (ship.m_Flag & skipshipflag) continue;
			if (IsFlyOtherPlanet(ship, planet)) continue;

			if(!ship.m_Owner) {
				if(owner) continue;
				if(ship.m_Race!=race) continue;
				return true;
			}

			if(ship.m_Owner==owner) return true;

			if (cur_own != ship.m_Owner) {
				cur_own = ship.m_Owner;
				cur_friend = IsFriendEx(planet, ship.m_Owner, ship.m_Race, owner, race);
			}
			if (cur_friend) return true;
		}

		return false;
	}
	
	public function ExistEnemyShip(planet:Planet, owner:uint, race:uint, and_low_orbit:Boolean, skipshipflag:uint, skipneutral:Boolean):Boolean
	{
		var cnt:int = planet.ShipOnPlanetLow;
		if (and_low_orbit) cnt = Common.ShipOnPlanetMax;

		var cur_own:uint = 0;
		var cur_enemy:Boolean = false;

		var i:int;
		for (i = 0; i < cnt; i++) {
			var ship:Ship = planet.m_Ship[i];
			if (ship.m_Type == Common.ShipTypeNone) continue;
			if (ship.m_Flag & skipshipflag) continue;
			if (IsFlyOtherPlanet(ship, planet)) continue;
			if (skipneutral && ship.m_Owner == 0) continue;

			if(!ship.m_Owner) {
				if(owner) return true;
				if(ship.m_Race==race) continue;
				return true;
			}

			if(ship.m_Owner==owner) continue;

			if(cur_own!=ship.m_Owner) {
				cur_own = ship.m_Owner;
				cur_enemy = !IsFriendEx(planet, ship.m_Owner, ship.m_Race, owner, race);
			}
			if(cur_enemy) return true;
		}

		return false;
	}

	public function CanLeavePlanet(planet:Planet, ship:Ship):Boolean
	{
		var i:int;
		var cd:Number;
		var user:User;
		var cpt:Cpt;
		var ship2:Ship;
		
		if (planet.m_Flag & Planet.PlanetFlagGravWell) return false;
		
		var gravitor:Boolean = (planet.m_Flag & (Planet.PlanetFlagGravitor | Planet.PlanetFlagGravitorSci)) != 0;

		if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0) return true;
		if ((planet.m_Flag & Planet.PlanetFlagSun) != 0 && !gravitor) return true;
		if (ship.m_Flag & Common.ShipFlagPhantom) return true;

		if(!IsBattle(planet,ship.m_Owner,ship.m_Race)) return true;

		var ret:Boolean=true;
		while(true) {
//				if (((planet.m_Flag & Planet.PlanetFlagGigant) == 0)) {
//					if (((ship.m_Type == Common.ShipTypeCorvette) || (ship.m_Race == Common.RacePeleng && ship.m_Type != Common.ShipTypeFlagship))) { ret = false; break; }
//				}

			if(gravitor) {
				if (ExistFriendShip(planet, planet.m_GravitorOwner, Common.RaceNone, false, Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPhantom)) ret = false;
				break;
			}

			if (planet.m_Flag & Planet.PlanetFlagPotential) return true;

			if (((planet.m_Flag & Planet.PlanetFlagGigant) == 0)) {
				if (ship.m_Type == Common.ShipTypeCorvette || ship.m_Type == Common.ShipTypeDevastator) {}
				else if (ship.m_Race == Common.RacePeleng && ship.m_Type != Common.ShipTypeFlagship && ship.m_AbilityCooldown0 <= m_ServerCalcTime) { }
				else { ret = false; break; }
			}

			for(i=0;i<Common.ShipOnPlanetMax;i++) {
				ship2=planet.m_Ship[i];
				
				if(ship2.m_Type==Common.ShipTypeNone) continue;
				if(ship2.m_Flag & Common.ShipFlagBuild) continue;
				if (!(ship2.m_ArrivalTime <= m_ServerCalcTime || (ship2.m_FromSectorX == planet.m_Sector.m_SectorX && ship2.m_FromSectorY == planet.m_Sector.m_SectorY && ship2.m_FromPlanet == planet.m_PlanetNum))) continue;

				if(ship2.m_Type==Common.ShipTypeWarBase) {}
				else if(ship2.m_Type==Common.ShipTypeFlagship) {
					if(ship2.m_Owner!=ship.m_Owner && !IsFriendEx(planet,ship2.m_Owner,ship2.m_Race,ship.m_Owner,ship.m_Race)) {
						if(VecValE(ship2.m_Owner, ship2.m_Id, Common.VecMoveIntercept)!=0) { ret=false; break; }
					}
					continue;
				}
				else continue;
				if((planet.m_Flag & Planet.PlanetFlagGigant)==0) {
					if((ship2.m_Flag & Common.ShipFlagBattle)==0) continue;
					if(ship2.m_Owner!=ship.m_Owner && !IsFriendEx(planet,ship2.m_Owner,ship2.m_Race,ship.m_Owner,ship.m_Race)) { ret=false; break; }
				}
			}

			if (ret && (planet.m_Flag & Planet.PlanetFlagGigant) == 0) {
				if (ship.m_Type == Common.ShipTypeCorvette || ship.m_Type == Common.ShipTypeDevastator) { }
				else if (ship.m_Race == Common.RacePeleng && ship.m_Type != Common.ShipTypeFlagship) {
//						if (setcooldown) {
//							ship.m_AbilityCooldown0 = GetServerTime() + 10 * 100;
//						}
					return true;
				}
			}
			
			break;
		}
		
		if(ret==false) {
			while(ship.m_Type==Common.ShipTypeFlagship) {
				cd=VecValE(ship.m_Owner, ship.m_Id, Common.VecMoveAccelerator);
				if(cd<=0) break;
				user=UserList.Self.GetUser(ship.m_Owner);
				if(user==null) break;
				cpt=user.GetCpt(ship.m_Id);
				if(cpt==null) break;

				if (cpt.m_AcceleratorCooldown <= m_ServerCalcTime) return true;
				break;
			}

			user=null;			
			for(i=0;i<Common.ShipOnPlanetMax;i++) {
				ship2=planet.m_Ship[i];
				if(ship.m_Owner!=ship2.m_Owner) continue;
				if(ship2.m_Type!=Common.ShipTypeFlagship) continue;
				if(ship.m_Id==ship2.m_Id) continue;

				if(ship2.m_Flag & Common.ShipFlagBuild) continue;
				if (!(ship2.m_ArrivalTime <= m_ServerCalcTime || (ship2.m_FromSectorX == planet.m_Sector.m_SectorX && ship2.m_FromSectorY == planet.m_Sector.m_SectorY && ship2.m_FromPlanet == planet.m_PlanetNum))) continue;

				if(user==null) user=UserList.Self.GetUser(ship2.m_Owner);
				if(user==null) break;
				cpt=user.GetCpt(ship2.m_Id);
				if(cpt==null) continue;
				cd=VecValE(ship2.m_Owner, ship2.m_Id, Common.VecMoveCover);
				if(cd<=0) continue;

				if (cpt.m_CoverCooldown <= m_ServerCalcTime) return true;
			}
		}

		return ret;
	}

	public function IsRear(planet:Planet, place:int, owner:uint, race:uint, enemy:Boolean, skip_corvette:Boolean = false):Boolean
	{
		var sp:Ship;
		var sn:Ship;

		if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
		var sopl:int = planet.ShipOnPlanetLow;

		if(place>0) sp=planet.m_Ship[place-1];
		else sp=planet.m_Ship[sopl-1];
	
		if (sp.m_Type == Common.ShipTypeNone) return false;
		if (skip_corvette && sp.m_Type == Common.ShipTypeCorvette) return false;
		if(!(sp.m_Flag & Common.ShipFlagBattle)) return false;
		if(IsFriendEx(planet,owner,race,sp.m_Owner,sp.m_Race)==enemy) return false;
	
		if(place<sopl-1) sn=planet.m_Ship[place+1];
		else sn=planet.m_Ship[0];

		if (sn.m_Type == Common.ShipTypeNone) return false;
		if (skip_corvette && sn.m_Type == Common.ShipTypeCorvette) return false;
		if(!(sn.m_Flag & Common.ShipFlagBattle)) return false;
		if(IsFriendEx(planet,owner,race,sn.m_Owner,sn.m_Race)==enemy) return false;

		return true;
	}

	public function IsRearEnemyStealth(planet:Planet, place:int, owner:uint, race:uint):Boolean
	{
		var sp:Ship;
		var sn:Ship;

		if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
		var sopl:int = planet.ShipOnPlanetLow;

		if(place>0) sp=planet.m_Ship[place-1];
		else sp=planet.m_Ship[sopl-1];

		if(sp.m_Type==Common.ShipTypeNone) return false;
		if(!(sp.m_Flag & Common.ShipFlagBattle)) return false;
		if(IsFriendEx(planet,owner,race,sp.m_Owner,sp.m_Race)==true) return false;

		if(place<sopl-1) sn=planet.m_Ship[place+1];
		else sn=planet.m_Ship[0];

		if(sn.m_Type==Common.ShipTypeNone) return false;
		if(!(sn.m_Flag & Common.ShipFlagBattle)) return false;
		if(IsFriendEx(planet,owner,race,sn.m_Owner,sn.m_Race)==true) return false;

		//if(!IsVis(planet)) return true;
		if(StealthType(planet,sp,owner)==2) return true;
		if(StealthType(planet,sn,owner)==2) return true;

		return false;
	}

	public function RaceByOwner(owner:uint, race:uint = 0/*Common.RaceNone*/):uint
	{
		if(owner!=0) {
			var user:User=UserList.Self.GetUser(owner,true);
			if(user!=null) {
				return user.m_Race;
			}
			
/*				if(m_UserList[owner]!=undefined) {
				var user:User=m_UserList[owner] as User;
				race=user.m_Race;
			}*/
		}
		return race;
	}
	
	public function CalcBuildPlace(planet:Planet, owner:uint):int
	{
		var i:int, score:int, bscore:int, cnt:int;
		var ship:Ship;
		var sopl:int = planet.ShipOnPlanetLow;

		var shipnum:int=-1;
		for(i=0;i<sopl;i++) {
			ship=planet.m_Ship[i];
			if(ship.m_Type!=Common.ShipTypeNone) continue;
			if(ship.m_OrbitItemType==Common.ItemTypeMine && IsFriendEx(planet,owner,Common.RaceNone,ship.m_OrbitItemOwner,Common.RaceNone)) continue;

			score=0;
			if(ship.m_ItemType==Common.ItemTypeNone) score+=2;
			if(IsRear(planet,i,owner,Common.RaceNone,false)) score+=1;
			else if(IsRear(planet,i,owner,Common.RaceNone,true)) continue;

			if(shipnum<0 || score>bscore) {
				shipnum=i;
				bscore=score;
				cnt=1;
			} else if(score==bscore) {
				cnt++;
				var kv:int=10000/cnt;
				if(Math.random()*10000<=kv) { shipnum=i; }
			}
		}
		return shipnum;
	}

	public function CalcBuildMaxCnt(buildforowner:uint, type:int, secx:int, secy:int, planetnum:int, shipnum:int = -1):int
	{
		var planet:Planet=GetPlanet(secx,secy,planetnum);
		if(planet==null) return 0;

		var cnt:int=ShipMaxCnt(buildforowner,type);
		var cost:int;

		if(type==Common.ShipTypeNone) {
			//cost=Common.DirPlanetLavelCostLvl[Common.DirPlanetLavelCostLvl.length-1];
			cost = Common.PlanetLevelCost;
		
			//if(planet.m_Owner==Server.Self.m_UserId) {
			//	cnt=DirValE(planet.m_Owner,Common.DirPlanetLevelMax);
			//	cost=DirValE(planet.m_Owner,Common.DirPlanetLavelCost);
			//}
			cnt = Common.BuildPlanetLvlMax;

			if(m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich) cost=(cost*m_OpsCostBuildLvl)>>8;
			else cost=(cost*m_InfrCostMul)>>8;
			
			cnt=Math.max(0,Math.min(cnt-(planet.m_Level+planet.m_LevelBuy),Math.floor(PlanetItemGet_Sub(Server.Self.m_UserId,planet,Common.ItemTypeModule,true)/cost)));
			if(cnt<=0) return 0;
			if(planet.m_LevelBuy+cnt>Common.BuildPlanetLvlMax) cnt=Common.BuildPlanetLvlMax-planet.m_LevelBuy;
			return Math.max(0,cnt);
		}
		
		if(shipnum>=0) {
			var ship:Ship=GetShip(secx,secy,planetnum,shipnum);
			if(ship==null) return 0;
			
			if(ship.m_Type!=Common.ShipTypeNone) {
				type=ship.m_Type;
				cnt-=ship.m_Cnt;
				
				if(Common.IsBase(type)) {
					if(ship.m_Cnt+cnt>Common.BuildStationMax) cnt=Common.BuildStationMax-ship.m_Cnt;
					if(cnt<0) cnt=0;
				}
			}
		} 

		var module:int = PlanetItemGet_Sub(Server.Self.m_UserId, planet, Common.ItemTypeModule, true);
		cost = ShipCost(buildforowner, 0, type);
		cnt=Math.min(cnt,Math.floor(module/cost));
		if(Common.IsBase(type)) {
			if(cnt>Common.BuildStationMax) cnt=Common.BuildStationMax;
		}
		return cnt;
	}

	public function CalcBuildMaxCntSDM(buildforowner:uint, type:int, secx:int, secy:int, planetnum:int, shipnum:int = -1):int
	{
		var planet:Planet=GetPlanet(secx,secy,planetnum);
		if(planet==null) return 0;

		var cnt:int=ShipMaxCnt(buildforowner,type);

		if(type==Common.ShipTypeNone) {
			//cnt=DirValE(planet.m_Owner,Common.DirPlanetLevelMax);
			cnt = Common.BuildPlanetLvlMax;
			cnt=Math.max(0,Math.min(cnt-planet.m_Level,Math.floor(m_UserSDM/Common.PlanetLevelSDM)));
			if(planet.m_LevelBuy+cnt>Common.BuildPlanetLvlMax) cnt=Common.BuildPlanetLvlMax-planet.m_LevelBuy;
			return Math.max(0,cnt);
		}
		
		if(shipnum>=0) {
			var ship:Ship=GetShip(secx,secy,planetnum,shipnum);
			if(ship==null) return 0;

			if(ship.m_Type!=Common.ShipTypeNone) {
				type=ship.m_Type;
				cnt-=ship.m_Cnt;
			}
		} 

		cnt=Math.min(cnt,Math.floor(m_UserSDM/Common.ShipCostSDM[type]));
		if(Common.IsBase(type)) {
			if(cnt>Common.BuildStationMax) cnt=Common.BuildStationMax;
		}
		return cnt;
	}

	public function CalcPlanetOffset(secx:int,secy:int,planetnum:int, to_secx:int,to_secy:int,to_planetnum:int):uint
	{
		var p:uint=0;

		if(secx-1==to_secx) p|=2;
		else if(secx+1==to_secx) p|=1;
		else if(secx!=to_secx) return 0;

		if(secy-1==to_secy) p|=2<<2;
		else if(secy+1==to_secy) p|=1<<2;
		else if(secy!=to_secy) return 0;

		if(planetnum==to_planetnum && p==0) return 0;

		p|=to_planetnum<<4;

		return p | 0x80;
	}

	public override function InfoHide():void
	{
		super.InfoHide();
		m_Info.Hide();
	}

	public override function FormHideAll():void // Закрываем все ненужные окна
	{
		super.FormHideAll();

		m_FormBuild.visible = false;
		//m_FormPlanet.visible = false;
		m_FormConstruction.visible = false;
		m_FormSplit.Hide();
		m_FormMenu.Clear();
//			m_FormRes.Hide();
//			m_FormResChange.Hide();
		m_FormTech.Hide();
		m_FormTalent.Hide();
		m_FormRace.Hide();
		m_FormTeamRel.Hide();
		m_FormPortal.Hide();
		m_FormPlusar.Hide();
		m_FormDialog.Hide();
		m_FormPactList.Hide();
		m_FormItemManager.Hide();
		m_FormQuestManager.Hide();
		m_FormItemImg.Hide();
		m_FormPact.Hide();
		m_FormHist.Hide();
		m_FormStorage.Hide();
		m_FormSet.Hide();
		m_FormUnion.Hide();
		m_FormUnionNew.Hide();
		m_FormExit.Hide();
		m_FormNewCpt.Hide();
		m_FormInput.Hide();
		m_FormCombat.Hide();
		m_FormPlanet.Hide();
		m_FormEnter.visible = false;
		m_FormNews.visible = false;
		m_Info.Hide();
	}

	public function AccessBaseOrbit(planet:Planet, owner:uint, race:uint):Boolean // доступ к опорной орбите с нижней орбиты
	{
		if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;

		var i:int;
		var ship:Ship;
		
		if (CntFriendGroup(planet, owner, race) >= Common.GroupInPlanetMax) return false;

		for (i = 0; i < Common.ShipOnPlanetMax; i++) {
			ship = planet.m_Ship[i];
			if (ship.m_Type == Common.ShipTypeNone) continue;
			if (ship.m_Owner == owner) continue;
			if (ship.m_Flag & Common.ShipFlagBuild) continue;
			if (IsFlyOtherPlanet(ship, planet)) continue;
			if (IsFriendEx(planet, ship.m_Owner, ship.m_Type, owner, race)) continue;
			return false;
		}

		return true;
	}

	public function AccessLowOrbit(planet:Planet, owner:uint, race:uint):Boolean
	{
		if (planet.m_Flag & Planet.PlanetFlagWormhole) return false;
		var sopl:int = planet.ShipOnPlanetLow;

		if((planet.m_Flag & Planet.PlanetFlagNoCapture) && owner && (owner & Common.OwnerAI)==0) return false;

		var i:int;
		var ship:Ship;

		for (i = 0; i < Common.ShipOnPlanetMax; i++) {
			ship = planet.m_Ship[i];
			if (ship.m_Type == Common.ShipTypeNone) continue;
			if (ship.m_Owner == owner) continue;
			if (ship.m_Flag & Common.ShipFlagBuild) continue;
			if (IsFlyOtherPlanet(ship, planet)) continue;
			if (IsFriendEx(planet, ship.m_Owner, ship.m_Type, owner, race)) continue;
			return false;
		}

		if (m_CotlType == Common.CotlTypeUser) {
			if (m_CotlOwnerId == owner) return true;
			if (IsFriendEx(planet, m_CotlOwnerId, Common.RaceNone, owner, race)) return true;
			return false;
		}

		for (i = sopl; i < Common.ShipOnPlanetMax; i++) {
			ship = planet.m_Ship[i];
			if (ship.m_Type == Common.ShipTypeNone) continue;

			if (ship.m_Owner == owner) continue;
			if (!IsFriendEx(planet, ship.m_Owner, ship.m_Race, owner, race)) return false;
		}
		return true;
	}

	public function CalcEmptyPlace(planet:Planet, owner:uint, race:uint, testmine:Boolean = false, skipmine:Boolean = false):int
	{
		var i:int,score:int,bscore:int,cnt:int;
		var ship:Ship;

		var add:int = 1;
		if (planet.m_Flag & Planet.PlanetFlagWormhole) add = 2;
		var sopl:int = planet.ShipOnPlanetLow;

		var shipnum:int=-1;
		for(i=0;i<sopl;i+=add) {
			ship=planet.m_Ship[i];
			if (ship.m_Type != Common.ShipTypeNone) continue;
			if (skipmine && ship.m_OrbitItemType == Common.ItemTypeMine) continue;
			if(testmine && ship.m_OrbitItemType==Common.ItemTypeMine && IsFriendEx(planet,owner,race,ship.m_OrbitItemOwner,Common.RaceNone)) continue;

			score=0;
			if(ship.m_ItemType==Common.ItemTypeNone) score+=2;
			if (IsRear(planet, i, owner, Common.RaceNone, false)) score += 1;
			else if (IsRear(planet, i, owner, Common.RaceNone, true)) continue;

			if(shipnum<0 || score>bscore) {
				shipnum=i;
				bscore=score;
				cnt=1;
			} else if(score==bscore) {
				cnt++;
				var kv:int=10000/cnt;
				if(Math.random()*10000<=kv) { shipnum=i; }
			}
		}
		return shipnum;
	}

	public function CalcEmptyPlaceEx(planet:Planet, owner:uint, race:uint, group:uint):int
	{
		var i:int,u:int,k:int, cnt:int, score:int, bscore:int;
		var ship:Ship;

		var shipcnt:int=(group >> 4) & 15;
		var shipoff:int=group & 15;
		group = group & 0xffff00;
		
		var off:int = 0;
		if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0 && (m_CotlType == Common.CotlTypeCombat)) {
			off = TeamType();
			if (off < 0) return -1;
		}

		if (shipcnt <= 1) return CalcEmptyPlace(planet, owner, race, true);

		var add:int=1;
		if (planet.m_Flag & Planet.PlanetFlagWormhole) add = 2;
		var sopl:int = planet.ShipOnPlanetLow;

		// Ищем назначеное место
		for(i=off;i<sopl;i+=add) {
			ship=planet.m_Ship[i];
			if(ship.m_Type==Common.ShipTypeNone) continue;
			if (ship.m_Owner != owner) continue;
			if (!ship.m_Group) continue;
			if((ship.m_Group & 0xffff00)!=group) continue;

			i=i-(ship.m_Group & 15)*add;
			if(i<0) i=sopl+i;
			break;
		}

		// Если место еще не назначено то исчем подходящие
		if(i<0 || i>=sopl) {
			var ee:Array=new Array();
			ee.length=Common.ShipOnPlanetMax;
			for(i=0;i<Common.ShipOnPlanetMax;i++) ee[i]=0;

			// Подсчитываем кол-во в начале.
			cnt=0;
			if(!IsRear(planet,0,owner,race,true)) {
				for(u=0;u<sopl;u++) {
					ship=planet.m_Ship[u];
					if(ship.m_Type==Common.ShipTypeNone) {
						if(ship.m_OrbitItemType==Common.ItemTypeMine && IsFriendEx(planet,owner,race,ship.m_OrbitItemOwner,Common.RaceNone)) {}
						else cnt++;
					} else {
						if(!IsFriendEx(planet,owner, race, ship.m_Owner, ship.m_Race)) break;
					}
				}
			}

			// Теперь для всех назначаем в обратном порядке.
			for (i = sopl - 1; i >= 0; i--) {
				ship=planet.m_Ship[i];
				if(ship.m_Type==Common.ShipTypeNone) {
					if(ship.m_OrbitItemType==Common.ItemTypeMine && IsFriendEx(planet,owner,race,ship.m_OrbitItemOwner,Common.RaceNone)) {}
					else {
						cnt++;
						ee[i]=cnt;
					}
				} else {
					if(!IsFriendEx(planet,owner, race, ship.m_Owner, ship.m_Race)) cnt=0;
				}
			}
//trace("CntEmpty:",ee);

			// Ищем лучшее
			var shipnum:int=-1;
			for(i=off;i<sopl;i+=add) {
				if(ee[i]<=1) continue;

				score=ee[i];
				if(score<shipcnt) score=100-score;
				else {
					score=100;
					k=i;
					for(u=0;u<shipcnt;u++,k+=add) {
						if(k>=sopl) k=k-sopl;
						ship=planet.m_Ship[k];
						if(ship.m_Type!=Common.ShipTypeNone) break;
						else if(ship.m_OrbitItemType==Common.ItemTypeMine && IsFriendEx(planet,owner,race,ship.m_OrbitItemOwner,Common.RaceNone)) break;
						score++;
					}
				}

				if(shipnum<0 || score>bscore) {
					shipnum=i;
					bscore=score;
					cnt=1;
				} else if(score==bscore) {
					cnt++;
					var kv:int=10000/cnt;
					if(Math.random()*10000<=kv) { shipnum=i; }
				}
			}
			i=shipnum;
		}

		// Место под данный корабль
		if(i<0 || i>=sopl) return CalcEmptyPlace(planet,owner,race,true);
		i+=shipoff*add;
		if(i>=sopl) i=i-sopl;

		for(u=off;u<sopl;u+=add,i+=add) {
			if(i>=sopl) i=i-sopl;
			ship=planet.m_Ship[i];

			if(ship.m_Type!=Common.ShipTypeNone) continue;
			else if(ship.m_OrbitItemType==Common.ItemTypeMine && IsFriendEx(planet,owner,race,ship.m_OrbitItemOwner,Common.RaceNone)) continue;
			
			if(IsRear(planet,i,owner,race,true)) continue;
//trace("EmptyPlaceEx:",i," Group:",group.toString(16));
			return i;
		}
		return -1;
	}

	public function CitadelExistAny():Boolean
	{
		var i:int;
		for (i = 0; i < Common.CitadelMax; i++) {
			if (m_CitadelNum[i] < 0) continue;
			return true;
		}
		return false;
	}

	public function CitadelExist(cotlid:uint):Boolean
	{
		var i:int;
		for (i = 0; i < Common.CitadelMax; i++) {
			if (m_CitadelCotlId[i] != cotlid) continue;
			return true;
		}
		return false;
	}

	public function CitadelFind(cotlid:uint):int
	{
		var i:int;
		for (i = 0; i < Common.CitadelMax; i++) {
			if (m_CitadelCotlId[i] != cotlid) continue;
			return i;
		}
		return -1;
	}

	public function CitadelFindEx(cotlid:uint, secx:int, secy:int, planetnum:int):int
	{
		var i:int;
		for (i = 0; i < Common.CitadelMax; i++) {
			if (m_CitadelCotlId[i] != cotlid) continue;
			if (m_CitadelSectorX[i] != secx) continue;
			if (m_CitadelSectorY[i] != secy) continue;
			if (m_CitadelNum[i] != planetnum) continue;
			return i;
		}
		return -1;
	}

	public function ClearPlanetPath(planet:Planet):void
	{
		planet.m_Path=0;

		var sx:int=Math.max(m_SectorMinX,planet.m_Sector.m_SectorX-1);
		var sy:int=Math.max(m_SectorMinY,planet.m_Sector.m_SectorY-1);
		var ex:int=Math.min(m_SectorMinX+m_SectorCntX,planet.m_Sector.m_SectorX+2);
		var ey:int=Math.min(m_SectorMinY+m_SectorCntY,planet.m_Sector.m_SectorY+2);

		var i:int,x:int,y:int;
		var sec:Sector;
		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
				if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
				if(!(m_Sector[i] is Sector)) continue;
				sec=m_Sector[i];
				
				for(i=0;i<sec.m_Planet.length;i++) {
					var p2:Planet=sec.m_Planet[i];
					if(p2.m_Path==0) continue;
					if(p2.m_Path!=CalcPlanetOffset(x,y,i, planet.m_Sector.m_SectorX,planet.m_Sector.m_SectorY,planet.m_PlanetNum)) continue;
					p2.m_Path=0;						
				}
			}
		}
	}

	public function FindPath(fromplanet:Planet, toplanet:Planet, owner:uint):Array
	{
		var i:int,x:int,y:int;
		var planet2:Planet,planet:Planet;
		var sec:Sector;

		var out:Array=new Array();
		var list:Array=new Array();

		fromplanet.m_FindScore=1;
		list.push(fromplanet);
		var off:int=0;

		var nextlevel:int=list.length;
		var find:int=0;
		
		while(off<list.length) {
			planet=list[off];
			off++;

			var sx:int=Math.max(m_SectorMinX,planet.m_Sector.m_SectorX-1);
			var sy:int=Math.max(m_SectorMinY,planet.m_Sector.m_SectorY-1);
			var ex:int=Math.min(m_SectorMinX+m_SectorCntX,planet.m_Sector.m_SectorX+2);
			var ey:int=Math.min(m_SectorMinY+m_SectorCntY,planet.m_Sector.m_SectorY+2);
//trace("Rect",sx,sy,ex,ey);

			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) continue;
					sec=m_Sector[i];

					for(i=0;i<sec.m_Planet.length;i++) {
						planet2=sec.m_Planet[i];
						if (planet2 == planet) continue;
						if (planet2.m_Flag & Planet.PlanetFlagNoMove) continue;
						if((planet2.m_Flag & Planet.PlanetFlagWormhole) && (planet2!=fromplanet) && (planet2!=toplanet)) continue;

						var d:Number=Math.sqrt((planet.m_PosX-planet2.m_PosX)*(planet.m_PosX-planet2.m_PosX)+(planet.m_PosY-planet2.m_PosY)*(planet.m_PosY-planet2.m_PosY));
//trace("    d=",d);

						if(d>m_OpsJumpRadius) continue;

						if(planet2.m_Vis) {
							if((planet2!=fromplanet) && (planet2!=toplanet) && planet2.m_Owner!=owner/*Server.Self.m_UserId*/) d*=2.0;
						}

						if((planet2.m_FindScore<=0) || ((planet.m_FindScore+d)<planet2.m_FindScore)) {
							planet2.m_FindScore=planet.m_FindScore+d;
							planet2.m_FindPrev=planet;
							list.push(planet2);
						}
						if(find==0) {
							if(planet2==toplanet) find=1;
						}
					}
				}
			}

			if(off>=nextlevel) {
				nextlevel=list.length;
				if(find>0) find++;
				if(find>3) break;
			}
		}
		
		if(find>0) {
			planet=toplanet;
			while(planet!=null) {
				out.splice(0,0,planet);
				planet=planet.m_FindPrev;
			}
			//out.splice(0,0,fromplanet);
		} 

		for(i=0;i<list.length;i++) {
			planet=list[i];
			planet.m_FindScore=0;
			planet.m_FindPrev=null;
		}

		return out;
	}

	public function CalcBuildTime(planet:Planet, owner:uint, cptid:uint, type:int, cnt:int):int
	{
		var i:int=0;

		var sycnt:int=0;
		for(var u:int=0;u<Common.ShipOnPlanetMax;u++) {
			var ship:Ship=planet.m_Ship[u];
			if(ship.m_Type!=Common.ShipTypeShipyard) continue;
			if(ship.m_Flag & Common.ShipFlagBuild) continue;
			if(ship.m_Owner!=owner) continue;
			sycnt+=ship.m_Cnt;
		}
		
		if(type==Common.ShipTypeFlagship) {
			var lvl:int=60;
	
			while(true) {
				var user:User=UserList.Self.GetUser(owner);
				if(user==null) break;
				var cpt:Cpt=user.GetCpt(cptid);
				if(cpt==null) break;
	
				lvl=1+cpt.CalcAllLvl();
				break;
			}
	
			i=180*(10+((lvl-1)<<1));
		} else {
			i=Common.ShipBuildSpeed[type];

			if(i<0) i=cnt>>(-i);
			else if(i>0) i=cnt<<i;
			else i=cnt;
		
			i=(i*m_BuildSpeed)>>8;
		}
		
		//if(m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich) {
//trace("OpsSpeedBuild1:", i, m_OpsSpeedBuild);
			i = (i * m_OpsSpeedBuild) >> 8;
//trace("OpsSpeedBuild2:", i);
		//}

		if(sycnt<=1) {}
		else if(sycnt<=2) i=i>>1;
		else if(sycnt<=3) i=(i*85)>>8;
		else i=i>>2;

		if(i<5) i=5;

		return i;
	}

	public function PactDecProc(type:int):int
	{
		var f:uint;
		var i:int;
		var obj:Object;

		var v:int=0;

/*			for(i=0;i<m_FormPactList.m_List.length;i++) {
			obj=m_FormPactList.m_List[i];
			if(obj.Period!=0) continue;

			if(Server.Self.m_UserId==obj.User1) f=obj.Flag1;
			else f=obj.Flag2;

			if(type==Common.ItemTypeAntimatter) v+=Common.PactPercent[(f >> (16+0)) & 7];
			else if(type==Common.ItemTypeMetal) v+=Common.PactPercent[(f >> (16+3)) & 7];
			else if(type==Common.ItemTypeElectronics) v+=Common.PactPercent[(f >> (16+6)) & 7];
			else if(type==Common.ItemTypeProtoplasm) v+=Common.PactPercent[(f >> (16+9)) & 7];
			else if(type==Common.ItemTypeNodes) v+=Common.PactPercent[(f >> (16+12)) & 12];
		}*/
		
		if(v>256) v=256;

		return v;
	}
	
	public function DirValAr(dir:int, rc:Boolean=false):Array
	{
		var ar:Array=null;

		if(rc) {
			if(dir==Common.DirEmpireMax) ar=Common.DirEmpireMaxLvl;
			else if(dir==Common.DirEnclaveMax) ar=Common.DirEnclaveMaxLvl;
			else if(dir==Common.DirColonyMax) ar=Common.DirColonyMaxLvl;
			//else if(dir==Common.DirPlanetLevelMax) ar=Common.DirPlanetLevelMaxLvl;
			else if (dir == Common.DirShipMassMax) ar = Common.DirShipMassMaxLvlEmp;
			else if(dir==Common.DirShipSpeed) ar=Common.DirShipSpeedLvlRC;
			else if(dir==Common.DirPlanetProtect) ar=Common.DirPlanetProtectLvlRC;
			else if(dir==Common.DirCaptureSlow) ar=Common.DirCaptureSlowLvl;
//				else if(dir==Common.DirModuleSpeed) ar=Common.DirModuleSpeedLvl;	
//				else if(dir==Common.DirResSpeed) ar=Common.DirResSpeedLvlRC;
//				else if(dir==Common.DirSupplyNormal) ar=Common.DirSupplyNormalLvl;
//				else if(dir==Common.DirSupplyMuch) ar=Common.DirSupplyMuchLvl;
//				else if(dir==Common.DirModuleMax) ar=Common.DirModuleMaxLvl;
//				else if(dir==Common.DirResMax) ar=Common.DirResMaxLvl;
//				else if(dir==Common.DirCitadelCost) ar=Common.DirCitadelCostLvl;
//				else if(dir==Common.DirPlanetLavelCost) ar=Common.DirPlanetLavelCostLvl;
			
			else if(dir==Common.DirTransportPrice) ar=Common.DirTransportPriceLvl;
			else if(dir==Common.DirTransportCnt) ar=Common.DirTransportCntLvl;
			//else if(dir==Common.DirTransportSupply) ar=Common.DirTransportSupplyLvl;
			else if(dir==Common.DirTransportMass) ar=Common.DirTransportMassLvl;
//				else if(dir==Common.DirTransportFuel) ar=Common.DirTransportFuelLvl;
			else if(dir==Common.DirTransportArmour) ar=Common.DirTransportArmourLvl;
			else if(dir==Common.DirTransportWeapon) ar=Common.DirTransportWeaponLvl;
			else if(dir==Common.DirTransportCargo) ar=Common.DirTransportCargoLvl;

			else if(dir==Common.DirCorvettePrice) ar=Common.DirCorvettePriceLvl;
			else if(dir==Common.DirCorvetteCnt) ar=Common.DirCorvetteCntLvl;
			//else if(dir==Common.DirCorvetteSupply) ar=Common.DirCorvetteSupplyLvl;
			else if(dir==Common.DirCorvetteMass) ar=Common.DirCorvetteMassLvl;
//				else if(dir==Common.DirCorvetteFuel) ar=Common.DirCorvetteFuelLvl;
			else if(dir==Common.DirCorvetteArmour) ar=Common.DirCorvetteArmourLvl;
			else if(dir==Common.DirCorvetteWeapon) ar=Common.DirCorvetteWeaponLvl;
			else if(dir==Common.DirCorvetteAccuracy) ar=Common.DirCorvetteAccuracyLvl;
			else if(dir==Common.DirCorvetteStealth) ar=Common.DirCorvetteStealthLvl;

			else if(dir==Common.DirCruiserAccess) ar=Common.DirCruiserAccessLvl;
			else if(dir==Common.DirCruiserPrice) ar=Common.DirCruiserPriceLvl;
			else if(dir==Common.DirCruiserCnt) ar=Common.DirCruiserCntLvl;
			//else if(dir==Common.DirCruiserSupply) ar=Common.DirCruiserSupplyLvl;
			else if(dir==Common.DirCruiserMass) ar=Common.DirCruiserMassLvl;
//				else if(dir==Common.DirCruiserFuel) ar=Common.DirCruiserFuelLvl;
			else if(dir==Common.DirCruiserArmour) ar=Common.DirCruiserArmourLvl;
			else if(dir==Common.DirCruiserWeapon) ar=Common.DirCruiserWeaponLvl;
			else if(dir==Common.DirCruiserAccuracy) ar=Common.DirCruiserAccuracyLvl;

			else if(dir==Common.DirDreadnoughtAccess) ar=Common.DirDreadnoughtAccessLvl;
			else if(dir==Common.DirDreadnoughtPrice) ar=Common.DirDreadnoughtPriceLvl;
			else if(dir==Common.DirDreadnoughtCnt) ar=Common.DirDreadnoughtCntLvl;
			//else if(dir==Common.DirDreadnoughtSupply) ar=Common.DirDreadnoughtSupplyLvl;
			else if(dir==Common.DirDreadnoughtMass) ar=Common.DirDreadnoughtMassLvl;
//				else if(dir==Common.DirDreadnoughtFuel) ar=Common.DirDreadnoughtFuelLvl;
			else if(dir==Common.DirDreadnoughtArmour) ar=Common.DirDreadnoughtArmourLvl;
			else if(dir==Common.DirDreadnoughtWeapon) ar=Common.DirDreadnoughtWeaponLvl;
			else if(dir==Common.DirDreadnoughtAccuracy) ar=Common.DirDreadnoughtAccuracyLvl;

			else if(dir==Common.DirInvaderPrice) ar=Common.DirInvaderPriceLvl;
			else if(dir==Common.DirInvaderCnt) ar=Common.DirInvaderCntLvl;
			//else if(dir==Common.DirInvaderSupply) ar=Common.DirInvaderSupplyLvl;
			else if(dir==Common.DirInvaderMass) ar=Common.DirInvaderMassLvl;
//				else if(dir==Common.DirInvaderFuel) ar=Common.DirInvaderFuelLvl;
			else if(dir==Common.DirInvaderArmour) ar=Common.DirInvaderArmourLvl;
			else if(dir==Common.DirInvaderWeapon) ar=Common.DirInvaderWeaponLvl;
			else if(dir==Common.DirInvaderCaptureSpeed) ar=Common.DirInvaderCaptureSpeedLvl;

			else if(dir==Common.DirDevastatorAccess) ar=Common.DirDevastatorAccessLvl;
			else if(dir==Common.DirDevastatorPrice) ar=Common.DirDevastatorPriceLvl;
			else if(dir==Common.DirDevastatorCnt) ar=Common.DirDevastatorCntLvl;
			//else if(dir==Common.DirDevastatorSupply) ar=Common.DirDevastatorSupplyLvl;
			else if(dir==Common.DirDevastatorMass) ar=Common.DirDevastatorMassLvl;
//				else if(dir==Common.DirDevastatorFuel) ar=Common.DirDevastatorFuelLvl;
			else if(dir==Common.DirDevastatorArmour) ar=Common.DirDevastatorArmourLvl;
			else if(dir==Common.DirDevastatorWeapon) ar=Common.DirDevastatorWeaponLvl;
			else if(dir==Common.DirDevastatorAccuracy) ar=Common.DirDevastatorAccuracyLvl;
			else if(dir==Common.DirDevastatorBomb) ar=Common.DirDevastatorBombLvl;

			else if(dir==Common.DirWarBaseAccess) ar=Common.DirWarBaseAccessLvl;
			else if(dir==Common.DirWarBasePrice) ar=Common.DirWarBasePriceLvl;
			else if(dir==Common.DirWarBaseCnt) ar=Common.DirWarBaseCntLvl;
			//else if(dir==Common.DirWarBaseSupply) ar=Common.DirWarBaseSupplyLvl;
			else if(dir==Common.DirWarBaseMass) ar=Common.DirWarBaseMassLvl;
			else if(dir==Common.DirWarBaseArmour) ar=Common.DirWarBaseArmourLvl;
			else if(dir==Common.DirWarBaseAccuracy) ar=Common.DirWarBaseAccuracyLvl;
			else if(dir==Common.DirWarBaseRepair) ar=Common.DirWarBaseRepairLvl;
			else if(dir==Common.DirWarBaseArmourAll) ar=Common.DirWarBaseArmourAllLvl;

			else if(dir==Common.DirShipyardAccess) ar=Common.DirShipyardAccessLvl;
			else if(dir==Common.DirShipyardPrice) ar=Common.DirShipyardPriceLvl;
			else if(dir==Common.DirShipyardCnt) ar=Common.DirShipyardCntLvl;
			//else if(dir==Common.DirShipyardSupply) ar=Common.DirShipyardSupplyLvl;
			else if(dir==Common.DirShipyardMass) ar=Common.DirShipyardMassLvl;
			else if(dir==Common.DirShipyardArmour) ar=Common.DirShipyardArmourLvl;
			else if(dir==Common.DirShipyardAccuracy) ar=Common.DirShipyardAccuracyLvl;
			else if(dir==Common.DirShipyardRepair) ar=Common.DirShipyardRepairLvl;
			else if(dir==Common.DirShipyardRepairAll) ar=Common.DirShipyardRepairAllLvl;

			else if(dir==Common.DirSciBaseAccess) ar=Common.DirSciBaseAccessLvl;
			else if(dir==Common.DirSciBasePrice) ar=Common.DirSciBasePriceLvl;
			else if(dir==Common.DirSciBaseCnt) ar=Common.DirSciBaseCntLvl;
			//else if(dir==Common.DirSciBaseSupply) ar=Common.DirSciBaseSupplyLvl;
			else if(dir==Common.DirSciBaseMass) ar=Common.DirSciBaseMassLvl;
			else if(dir==Common.DirSciBaseArmour) ar=Common.DirSciBaseArmourLvl;
			else if(dir==Common.DirSciBaseAccuracy) ar=Common.DirSciBaseAccuracyLvl;
			else if(dir==Common.DirSciBaseRepair) ar=Common.DirSciBaseRepairLvl;
			else if (dir == Common.DirSciBaseStabilizer) ar = Common.DirSciBaseStabilizerLvl;

			else if (dir == Common.DirQuarkBaseAccess) ar = Common.DirQuarkBaseAccessLvl;
			//else if (dir == Common.DirQuarkBaseMass) ar = Common.DirQuarkBaseMassLvl;
			else if (dir == Common.DirQuarkBaseWeapon) ar = Common.DirQuarkBaseWeaponLvl;
			else if (dir == Common.DirQuarkBaseAccuracy) ar = Common.DirQuarkBaseAccuracyLvl;
			else if (dir == Common.DirQuarkBaseArmour) ar = Common.DirQuarkBaseArmourLvl;
			else if (dir == Common.DirQuarkBaseRepair) ar = Common.DirQuarkBaseRepairLvl;
			else if (dir == Common.DirQuarkBaseAntiGravitor) ar = Common.DirQuarkBaseAntiGravitorLvl;
			else if (dir == Common.DirQuarkBaseGravWell) ar = Common.DirQuarkBaseGravWellLvl;
			else if (dir == Common.DirQuarkBaseBlackHole) ar = Common.DirQuarkBaseBlackHoleLvl;
			else if (dir == Common.DirQuarkBaseHP) ar = Common.DirQuarkBaseHPLvl;
			else if (dir == Common.DirQuarkBaseShield) ar = Common.DirQuarkBaseShieldLvl;
			else if (dir == Common.DirQuarkBaseShieldReduce) ar = Common.DirQuarkBaseShieldReduceLvl;
			else if (dir == Common.DirQuarkBaseShieldInc) ar = Common.DirQuarkBaseShieldIncLvl;
			
		} else {
			if(dir==Common.DirEmpireMax) ar=Common.DirEmpireMaxLvl;
			else if(dir==Common.DirEnclaveMax) ar=Common.DirEnclaveMaxLvl;
			else if(dir==Common.DirColonyMax) ar=Common.DirColonyMaxLvl;
			//else if(dir==Common.DirPlanetLevelMax) ar=Common.DirPlanetLevelMaxLvl;
			else if(dir==Common.DirShipMassMax) ar=Common.DirShipMassMaxLvlEmp;
			else if(dir==Common.DirShipSpeed) ar=Common.DirShipSpeedLvl;
			else if(dir==Common.DirPlanetProtect) ar=Common.DirPlanetProtectLvl;
			else if(dir==Common.DirCaptureSlow) ar=Common.DirCaptureSlowLvl;
//				else if(dir==Common.DirModuleSpeed) ar=Common.DirModuleSpeedLvl;	
//				else if(dir==Common.DirResSpeed) ar=Common.DirResSpeedLvl;
//				else if(dir==Common.DirSupplyNormal) ar=Common.DirSupplyNormalLvl;
//				else if(dir==Common.DirSupplyMuch) ar=Common.DirSupplyMuchLvl;
//				else if(dir==Common.DirModuleMax) ar=Common.DirModuleMaxLvl;
//				else if(dir==Common.DirResMax) ar=Common.DirResMaxLvl;
//				else if(dir==Common.DirCitadelCost) ar=Common.DirCitadelCostLvl;
//				else if(dir==Common.DirPlanetLavelCost) ar=Common.DirPlanetLavelCostLvl;
			
			else if(dir==Common.DirTransportPrice) ar=Common.DirTransportPriceLvl;
			else if(dir==Common.DirTransportCnt) ar=Common.DirTransportCntLvl;
			//else if(dir==Common.DirTransportSupply) ar=Common.DirTransportSupplyLvl;
			else if(dir==Common.DirTransportMass) ar=Common.DirTransportMassLvl;
//				else if(dir==Common.DirTransportFuel) ar=Common.DirTransportFuelLvl;
			else if(dir==Common.DirTransportArmour) ar=Common.DirTransportArmourLvl;
			else if(dir==Common.DirTransportWeapon) ar=Common.DirTransportWeaponLvl;
			else if(dir==Common.DirTransportCargo) ar=Common.DirTransportCargoLvl;

			else if(dir==Common.DirCorvettePrice) ar=Common.DirCorvettePriceLvl;
			else if(dir==Common.DirCorvetteCnt) ar=Common.DirCorvetteCntLvl;
			//else if(dir==Common.DirCorvetteSupply) ar=Common.DirCorvetteSupplyLvl;
			else if(dir==Common.DirCorvetteMass) ar=Common.DirCorvetteMassLvl;
//				else if(dir==Common.DirCorvetteFuel) ar=Common.DirCorvetteFuelLvl;
			else if(dir==Common.DirCorvetteArmour) ar=Common.DirCorvetteArmourLvl;
			else if(dir==Common.DirCorvetteWeapon) ar=Common.DirCorvetteWeaponLvl;
			else if(dir==Common.DirCorvetteAccuracy) ar=Common.DirCorvetteAccuracyLvl;
			else if(dir==Common.DirCorvetteStealth) ar=Common.DirCorvetteStealthLvl;

			else if(dir==Common.DirCruiserAccess) ar=Common.DirCruiserAccessLvl;
			else if(dir==Common.DirCruiserPrice) ar=Common.DirCruiserPriceLvl;
			else if(dir==Common.DirCruiserCnt) ar=Common.DirCruiserCntLvl;
			//else if(dir==Common.DirCruiserSupply) ar=Common.DirCruiserSupplyLvl;
			else if(dir==Common.DirCruiserMass) ar=Common.DirCruiserMassLvl;
//				else if(dir==Common.DirCruiserFuel) ar=Common.DirCruiserFuelLvl;
			else if(dir==Common.DirCruiserArmour) ar=Common.DirCruiserArmourLvl;
			else if(dir==Common.DirCruiserWeapon) ar=Common.DirCruiserWeaponLvl;
			else if(dir==Common.DirCruiserAccuracy) ar=Common.DirCruiserAccuracyLvl;

			else if(dir==Common.DirDreadnoughtAccess) ar=Common.DirDreadnoughtAccessLvl;
			else if(dir==Common.DirDreadnoughtPrice) ar=Common.DirDreadnoughtPriceLvl;
			else if(dir==Common.DirDreadnoughtCnt) ar=Common.DirDreadnoughtCntLvl;
			//else if (dir == Common.DirDreadnoughtSupply) ar = Common.DirDreadnoughtSupplyLvl;
			else if(dir==Common.DirDreadnoughtMass) ar=Common.DirDreadnoughtMassLvl;
//				else if(dir==Common.DirDreadnoughtFuel) ar=Common.DirDreadnoughtFuelLvl;
			else if(dir==Common.DirDreadnoughtArmour) ar=Common.DirDreadnoughtArmourLvl;
			else if(dir==Common.DirDreadnoughtWeapon) ar=Common.DirDreadnoughtWeaponLvl;
			else if(dir==Common.DirDreadnoughtAccuracy) ar=Common.DirDreadnoughtAccuracyLvl;

			else if(dir==Common.DirInvaderPrice) ar=Common.DirInvaderPriceLvl;
			else if(dir==Common.DirInvaderCnt) ar=Common.DirInvaderCntLvl;
			//else if(dir==Common.DirInvaderSupply) ar=Common.DirInvaderSupplyLvl;
			else if(dir==Common.DirInvaderMass) ar=Common.DirInvaderMassLvl;
//				else if(dir==Common.DirInvaderFuel) ar=Common.DirInvaderFuelLvl;
			else if(dir==Common.DirInvaderArmour) ar=Common.DirInvaderArmourLvl;
			else if(dir==Common.DirInvaderWeapon) ar=Common.DirInvaderWeaponLvl;
			else if(dir==Common.DirInvaderCaptureSpeed) ar=Common.DirInvaderCaptureSpeedLvl;

			else if(dir==Common.DirDevastatorAccess) ar=Common.DirDevastatorAccessLvl;
			else if(dir==Common.DirDevastatorPrice) ar=Common.DirDevastatorPriceLvl;
			else if(dir==Common.DirDevastatorCnt) ar=Common.DirDevastatorCntLvl;
			//else if(dir==Common.DirDevastatorSupply) ar=Common.DirDevastatorSupplyLvl;
			else if(dir==Common.DirDevastatorMass) ar=Common.DirDevastatorMassLvl;
//				else if(dir==Common.DirDevastatorFuel) ar=Common.DirDevastatorFuelLvl;
			else if(dir==Common.DirDevastatorArmour) ar=Common.DirDevastatorArmourLvl;
			else if(dir==Common.DirDevastatorWeapon) ar=Common.DirDevastatorWeaponLvl;
			else if(dir==Common.DirDevastatorAccuracy) ar=Common.DirDevastatorAccuracyLvl;
			else if(dir==Common.DirDevastatorBomb) ar=Common.DirDevastatorBombLvl;

			else if(dir==Common.DirWarBaseAccess) ar=Common.DirWarBaseAccessLvl;
			else if(dir==Common.DirWarBasePrice) ar=Common.DirWarBasePriceLvl;
			else if(dir==Common.DirWarBaseCnt) ar=Common.DirWarBaseCntLvl;
			//else if(dir==Common.DirWarBaseSupply) ar=Common.DirWarBaseSupplyLvl;
			else if(dir==Common.DirWarBaseMass) ar=Common.DirWarBaseMassLvl;
			else if(dir==Common.DirWarBaseArmour) ar=Common.DirWarBaseArmourLvl;
			else if(dir==Common.DirWarBaseAccuracy) ar=Common.DirWarBaseAccuracyLvl;
			else if(dir==Common.DirWarBaseRepair) ar=Common.DirWarBaseRepairLvl;
			else if(dir==Common.DirWarBaseArmourAll) ar=Common.DirWarBaseArmourAllLvl;

			else if(dir==Common.DirShipyardAccess) ar=Common.DirShipyardAccessLvl;
			else if(dir==Common.DirShipyardPrice) ar=Common.DirShipyardPriceLvl;
			else if(dir==Common.DirShipyardCnt) ar=Common.DirShipyardCntLvl;
			//else if (dir == Common.DirShipyardSupply) ar = Common.DirShipyardSupplyLvl;
			else if(dir==Common.DirShipyardMass) ar=Common.DirShipyardMassLvl;
			else if(dir==Common.DirShipyardArmour) ar=Common.DirShipyardArmourLvl;
			else if(dir==Common.DirShipyardAccuracy) ar=Common.DirShipyardAccuracyLvl;
			else if(dir==Common.DirShipyardRepair) ar=Common.DirShipyardRepairLvl;
			else if(dir==Common.DirShipyardRepairAll) ar=Common.DirShipyardRepairAllLvl;

			else if(dir==Common.DirSciBaseAccess) ar=Common.DirSciBaseAccessLvl;
			else if(dir==Common.DirSciBasePrice) ar=Common.DirSciBasePriceLvl;
			else if(dir==Common.DirSciBaseCnt) ar=Common.DirSciBaseCntLvl;
			//else if(dir==Common.DirSciBaseSupply) ar=Common.DirSciBaseSupplyLvl;
			else if(dir==Common.DirSciBaseMass) ar=Common.DirSciBaseMassLvl;
			else if(dir==Common.DirSciBaseArmour) ar=Common.DirSciBaseArmourLvl;
			else if(dir==Common.DirSciBaseAccuracy) ar=Common.DirSciBaseAccuracyLvl;
			else if(dir==Common.DirSciBaseRepair) ar=Common.DirSciBaseRepairLvl;
			else if(dir==Common.DirSciBaseStabilizer) ar=Common.DirSciBaseStabilizerLvl;
			
			else if (dir == Common.DirQuarkBaseAccess) ar = Common.DirQuarkBaseAccessLvl;
			//else if (dir == Common.DirQuarkBaseMass) ar = Common.DirQuarkBaseMassLvl;
			else if (dir == Common.DirQuarkBaseWeapon) ar = Common.DirQuarkBaseWeaponLvl;
			else if (dir == Common.DirQuarkBaseAccuracy) ar = Common.DirQuarkBaseAccuracyLvl;
			else if (dir == Common.DirQuarkBaseArmour) ar = Common.DirQuarkBaseArmourLvl;
			else if (dir == Common.DirQuarkBaseRepair) ar = Common.DirQuarkBaseRepairLvl;
			else if (dir == Common.DirQuarkBaseAntiGravitor) ar = Common.DirQuarkBaseAntiGravitorLvl;
			else if (dir == Common.DirQuarkBaseGravWell) ar = Common.DirQuarkBaseGravWellLvl;
			else if (dir == Common.DirQuarkBaseBlackHole) ar = Common.DirQuarkBaseBlackHoleLvl;
			else if (dir == Common.DirQuarkBaseHP) ar = Common.DirQuarkBaseHPLvl;
			else if (dir == Common.DirQuarkBaseShield) ar = Common.DirQuarkBaseShieldLvl;
			else if (dir == Common.DirQuarkBaseShieldReduce) ar = Common.DirQuarkBaseShieldReduceLvl;
			else if (dir == Common.DirQuarkBaseShieldInc) ar = Common.DirQuarkBaseShieldIncLvl;
		}
		
		return ar;
	}

	public function DirValLvl(owner:uint, dir:int):int
	{
		if(owner==0) return 0;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return 0;
		
		return user.CalcDirLvl(dir);
	}
	
	public function DirValE(owner:uint, dir:int, rc:Boolean=false):int
	{
		if(owner==0) return 0;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return 0;
		
		var lvl:int=user.CalcDirLvl(dir);
		var ar:Array=DirValAr(dir,rc);

		if(ar==null) return 0;
		if(lvl<0 || lvl>=ar.length) return 0;

		return ar[lvl];			
	}

	public function VecValAr(dir:int):Array
	{
		var ar:Array=null;

		if(dir==Common.VecMoveSpeed) ar=Common.VecMoveSpeedLvl;
//			else if(dir==Common.VecMoveFuel) ar=Common.VecMoveFuelLvl;
		else if(dir==Common.VecMoveIntercept) ar=Common.VecMoveInterceptLvl;
		else if(dir==Common.VecMoveAccelerator) ar=Common.VecMoveAcceleratorLvl;
		else if(dir==Common.VecMovePortal) ar=Common.VecMovePortalLvl;
		else if(dir==Common.VecMoveRadar) ar=Common.VecMoveRadarLvl;
		else if(dir==Common.VecMoveCover) ar=Common.VecMoveCoverLvl;
		else if(dir==Common.VecMoveExchange) ar=Common.VecMoveExchangeLvl;	
		
		else if(dir==Common.VecProtectHP) ar=Common.VecProtectHPLvl;
		else if(dir==Common.VecProtectArmour) ar=Common.VecProtectArmourLvl;
		else if(dir==Common.VecProtectShield) ar=Common.VecProtectShieldLvl;
		else if(dir==Common.VecProtectShieldInc) ar=Common.VecProtectShieldIncLvl;
		else if(dir==Common.VecProtectShieldReduce) ar=Common.VecProtectShieldReduceLvl;
		else if(dir==Common.VecProtectInvulnerability) ar=Common.VecProtectInvulnerabilityLvl;
		else if (dir == Common.VecProtectRepair) ar = Common.VecProtectRepairLvl;
		else if(dir==Common.VecProtectAntiExchange) ar=Common.VecProtectAntiExchangeLvl;	

		else if(dir==Common.VecAttackCannon) ar=Common.VecAttackCannonLvl;
		else if(dir==Common.VecAttackLaser) ar=Common.VecAttackLaserLvl;
		else if(dir==Common.VecAttackMissile) ar=Common.VecAttackMissileLvl;
		else if(dir==Common.VecAttackAccuracy) ar=Common.VecAttackAccuracyLvl;
		else if(dir==Common.VecAttackMine) ar=Common.VecAttackMineLvl;
		else if(dir==Common.VecAttackTransiver) ar=Common.VecAttackTransiverLvl;

		else if(dir==Common.VecSystemSensor) ar=Common.VecSystemSensorLvl;
		else if(dir==Common.VecSystemStealth) ar=Common.VecSystemStealthLvl;
		else if(dir==Common.VecSystemRecharge) ar=Common.VecSystemRechargeLvl;
		else if(dir==Common.VecSystemHacker) ar=Common.VecSystemHackerLvl;
		else if(dir==Common.VecSystemJummer) ar=Common.VecSystemJummerLvl;
		else if(dir==Common.VecSystemDisintegrator) ar=Common.VecSystemDisintegratorLvl;
		else if(dir==Common.VecSystemConstructor) ar=Common.VecSystemConstructorLvl;

		else if(dir==Common.VecMoveGravitor) ar=Common.VecMoveGravitorLvl;
		
		return ar;
	}

	public function VecValE(owner:uint, cptid:uint, vec:int):int
	{
		if(owner==0) return 0;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return 0;
		
		var cpt:Cpt=user.GetCpt(cptid);
		if(cpt==null) return 0;
		
		var lvl:int=cpt.CalcVecLvl(vec);
//if(vec==Common.VecProtectShield) trace(owner,cptid,lvl);
		var ar:Array=VecValAr(vec);

		if(ar==null) return 0;
		if(lvl<0 || lvl>=ar.length) return 0;

		return ar[lvl];			
	}
	
	public function CalcFlagshipSubtype(owner:uint, cptid:uint):int
	{
		var i:int;
		
		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return 1;
		
		var cpt:Cpt=user.GetCpt(cptid);
		if(cpt==null) return 1;
		
		var mspd:uint=cpt.m_Talent[0];
		var mprt:uint=cpt.m_Talent[1];
		var matk:uint=cpt.m_Talent[2];
		var msys:uint=cpt.m_Talent[3];
		
		var cspd:int=0;
		var cprt:int=0;
		var catk:int=0;
		var csys:int = 0;

		var anchor:int = 0;
		var invu:int = 0;
		
		var m:uint=1;

		for(i=0;i<32;i++) {
			if((mspd & m)!=0) cspd++;
			if ((mprt & m) != 0) {
				cprt++;
				if (Common.TalentVec[Common.TalentDef * 32 + i] == Common.VecProtectAntiExchange) anchor++;
				else if(Common.TalentVec[Common.TalentDef * 32 + i] == Common.VecProtectInvulnerability) invu++;
			}
			if((matk & m)!=0) catk++;
			if((msys & m)!=0) csys++;
			m=m<<1;
		}

		var r:int = 0;
		if (msys > mspd) r += 4;
		
		if (/*mprt >= 15*/ (anchor>=1 || invu>=2) && matk >= 12) r += 3;
		else if (/*mprt >= 15*/(anchor>=1 || invu>=2)) r += 2;
		else if (matk >= 12) r += 1;
		
		return r;

//			if(cspd>catk && cspd>csys) return 0;
//			else if(catk>csys) return 1;
//			else if(csys>0) return 2;

//			return 1;
	}
	
	public function ShipMaxHP(owner:uint, cptid:uint, type:int, race:uint):int
	{
		if(type==Common.ShipTypeFlagship) {
			var user:User=UserList.Self.GetUser(owner,false);
			if(user==null) return Common.ShipMaxHP[type];

			var cpt:Cpt=user.GetCpt(cptid);
			if(cpt==null) return Common.ShipMaxHP[type];

			return (cpt.CalcAllLvl() + 1) * 1000 + VecValE(owner, cptid, Common.VecProtectHP);
			
		} else if (type == Common.ShipTypeQuarkBase) {
			return DirValE(owner, Common.DirQuarkBaseHP);
		}

		var hp:int = Common.ShipMaxHP[type];
		if ((race == Common.RaceGrantar) && (!Common.IsBase(type))) hp = ((hp * (256 + 154)) >> 8);//160% //hp += hp >> 1;
		else if ((race == Common.RaceTechnol) && (!Common.IsBase(type))) hp >>= 1;
		return hp;
	}

	public function ShipMaxShield(owner:uint, cptid:uint, type:int, race:uint, cnt:int):int
	{
		if(type==Common.ShipTypeFlagship) {
//trace(owner, cptid, VecValE(owner, cptid, Common.VecProtectShield));
			var user:User=UserList.Self.GetUser(owner,false);
			if(user==null) return Common.ShipMaxHP[type];

			var cpt:Cpt=user.GetCpt(cptid);
			if(cpt==null) return Common.ShipMaxHP[type];

			return (cpt.CalcAllLvl() + 1) * 1000 + VecValE(owner, cptid, Common.VecProtectShield);

		} else if (type == Common.ShipTypeQuarkBase) {
			return DirValE(owner, Common.DirQuarkBaseShield);
		} else if (race == Common.RaceTechnol) {
			return Common.ShipMaxShield[type] * cnt;
		}

		return 0;
	}
	
	public function ShieldAdd(shipto:Ship, shipfrom:Ship):void
	{
		if (shipfrom.m_Shield <= 0) return;
		if (shipto.m_Type == Common.ShipTypeFlagship || shipto.m_Type == Common.ShipTypeQuarkBase) return;
		if (shipto.m_Race == Common.RaceTechnol) {
			shipto.m_Shield += shipfrom.m_Shield;

		} else if (shipto.m_Race == Common.RaceGaal) {
			shipto.m_Shield += shipfrom.m_Shield;
			if (shipto.m_Shield > Common.GaalBarrierMax) shipto.m_Shield = Common.GaalBarrierMax;
		}
	}
	
	public function CargoMax(shiptype:int, cnt:int):int
	{
		if (shiptype == Common.ShipTypeFlagship) return 1000000;
		else if (Common.IsBase(shiptype)) return 100000 * cnt;
		if (cnt > 999) cnt = 999;
		return cnt * 500;
	}

	public function ShipCost(owner:uint, cptid:uint, type:int):int
	{
		var user:User;
		
		var v:int=Common.ShipCost[type];

		if(owner==0) return v;
		
		if(type==Common.ShipTypeFlagship) {
			user=UserList.Self.GetUser(owner,false);
			if(user==null) return Common.ShipCost[type];

			var cpt:Cpt=user.GetCpt(cptid);
			if(cpt==null) return Common.ShipCost[type];

			return 4000+cpt.CalcAllLvl()*40000;
		}

		if(Common.ShipCostDir[type]==0) return v;

		user=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		var ar:Array=DirValAr(Common.ShipCostDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipCostDir[type]);
		if(lvl<0 || lvl>=ar.length) return 0;

		return ar[lvl];
	}
	
	public function ShipMaxCnt(owner:uint, type:int):int
	{
		if (type == Common.ShipTypeFlagship) return 1;
		else if (type == Common.ShipTypeServiceBase) return 4;
		else if (type == Common.ShipTypeQuarkBase) return 1;
		var v:int = Common.ShipMaxCnt;
		
		if(owner==0) return v;
		if(Common.ShipMaxCntDir[type]==0) return v;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		var ar:Array=DirValAr(Common.ShipMaxCntDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipMaxCntDir[type]);
		if(lvl<0 || lvl>=ar.length) return 0;

		return ar[lvl];
	} 

	public function ShipMass(owner:uint, cptid:uint, type:int):int
	{
		var v:int=0;

		if (owner == 0) return v;
		
		if(type==Common.ShipTypeFlagship) {
			user=UserList.Self.GetUser(owner,false);
			if(user==null) return 0;

			var cpt:Cpt=user.GetCpt(cptid);
			if(cpt==null) return 0;

			return 1000+cpt.CalcAllLvl()*1000;
		}
		if (type == Common.ShipTypeServiceBase) return 500;
		else if (type == Common.ShipTypeQuarkBase) return 200000;

		if(Common.ShipMassDir[type]==0) return v;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		var ar:Array=DirValAr(Common.ShipMassDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipMassDir[type]);
		if(lvl<0 || lvl>=ar.length) return 0;

		return ar[lvl];
	} 

	public function FuelMax(owner:uint, id:uint, type:int):int
	{
		return Common.FuelMax;
/*			var v:int=Common.FuelMax;

		if(owner==0) return v;

		if(type==Common.ShipTypeFlagship) {
			return VecValE(owner, id, Common.VecMoveFuel);
		}

		if(Common.ShipFuelDir[type]==0) return v;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		var ar:Array=DirValAr(Common.ShipFuelDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipFuelDir[type]);
		if (lvl<0 || lvl>=ar.length) return 0;
		
		return ar[lvl];*/
	}

	public function ShipArmour(owner:uint, id:uint, type:int):int
	{
		var i:int,u:int,k:int;
		var v:int=0;

		if(owner==0) return v;

		if(type==Common.ShipTypeFlagship) {
			return VecValE(owner, id, Common.VecProtectArmour);
		}

		var user:User=UserList.Self.GetUser(owner,false);
		if (user == null) return v;
		
		if(user.m_UnionId!=0) {
			var uni:Union=UserList.Self.GetUnion(user.m_UnionId,false);
			if(uni!=null) {
				if (type == Common.ShipTypeCorvette) v = Common.CotlBonusValEx(Common.CotlBonusCorvetteArmour, uni.m_Bonus[Common.CotlBonusCorvetteArmour]);
				else if (type == Common.ShipTypeCruiser) v = Common.CotlBonusValEx(Common.CotlBonusCruiserArmour,uni.m_Bonus[Common.CotlBonusCruiserArmour]);
				else if (type == Common.ShipTypeDreadnought) v = Common.CotlBonusValEx(Common.CotlBonusDreadnoughtArmour,uni.m_Bonus[Common.CotlBonusDreadnoughtArmour]);
				else if (type == Common.ShipTypeDevastator) v = Common.CotlBonusValEx(Common.CotlBonusDevastatorArmour,uni.m_Bonus[Common.CotlBonusDevastatorArmour]);
				else if (type == Common.ShipTypeWarBase) v = Common.CotlBonusValEx(Common.CotlBonusWarBaseArmour,uni.m_Bonus[Common.CotlBonusWarBaseArmour]);
			}
		}

		while (user.m_IB1_Type != 0 && ((user.m_IB1_Type & 0x8000) != 0)) {
			if (type == Common.ShipTypeCorvette) u = Common.ItemBonusArmourCorvette;
			else if (type == Common.ShipTypeCruiser) u = Common.ItemBonusArmourCruiser;
			else if (type == Common.ShipTypeDreadnought) u = Common.ItemBonusArmourDreadnought;
			else if (type == Common.ShipTypeDevastator) u = Common.ItemBonusArmourDevastator;
			else break;

			var item:Item = UserList.Self.GetItem(user.m_IB1_Type & 0x7fff);
			if (item == null) break;
			for (i = 0; i < 4; i++) {
				k = (user.m_IB1_Type >> (16 + i * 4)) & 15;
				if (k == 0) break;
				if (item.m_BonusType[k] == u) {
					v = Math.max(v, item.m_BonusVal[k]);
					break;
				}
			}
			break;
		}

		if(Common.ShipArmourDir[type]==0) return v;

		var ar:Array=DirValAr(Common.ShipArmourDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipArmourDir[type]);
		if(lvl<0 || lvl>=ar.length) return v;

		return ar[lvl]+v;
	}

	public function ShipShieldReduce(owner:uint, id:uint, type:int, race:uint):int
	{
		var i:int,u:int,k:int;
		var v:int=0;

		if(owner==0) return v;

		if(type==Common.ShipTypeFlagship) {
			return VecValE(owner, id, Common.VecProtectShieldReduce);

		} else if (type == Common.ShipTypeQuarkBase) {
			return DirValE(owner, Common.DirQuarkBaseShieldReduce);
		}

		if (race != Common.RaceTechnol) return 0;
		if (Common.IsBase(type)) return 0;

		var user:User=UserList.Self.GetUser(owner,false);
		if (user == null) return v;

		if (user.m_UnionId != 0) {
			var uni:Union=UserList.Self.GetUnion(user.m_UnionId,false);
			if(uni!=null) {
				if (type == Common.ShipTypeCorvette) v = Common.CotlBonusValEx(Common.CotlBonusCorvetteArmour, uni.m_Bonus[Common.CotlBonusCorvetteArmour]);
				else if (type == Common.ShipTypeCruiser) v = Common.CotlBonusValEx(Common.CotlBonusCruiserArmour,uni.m_Bonus[Common.CotlBonusCruiserArmour]);
				else if (type == Common.ShipTypeDreadnought) v = Common.CotlBonusValEx(Common.CotlBonusDreadnoughtArmour,uni.m_Bonus[Common.CotlBonusDreadnoughtArmour]);
				else if (type == Common.ShipTypeDevastator) v = Common.CotlBonusValEx(Common.CotlBonusDevastatorArmour,uni.m_Bonus[Common.CotlBonusDevastatorArmour]);
			}
		}

		while (user.m_IB1_Type != 0 && ((user.m_IB1_Type & 0x8000) != 0)) {
			if (type == Common.ShipTypeCorvette) u = Common.ItemBonusArmourCorvette;
			else if (type == Common.ShipTypeCruiser) u = Common.ItemBonusArmourCruiser;
			else if (type == Common.ShipTypeDreadnought) u = Common.ItemBonusArmourDreadnought;
			else if (type == Common.ShipTypeDevastator) u = Common.ItemBonusArmourDevastator;
			else break;

			var item:Item = UserList.Self.GetItem(user.m_IB1_Type & 0x7fff);
			if (item == null) break;
			for (i = 0; i < 4; i++) {
				k = (user.m_IB1_Type >> (16 + i * 4)) & 15;
				if (k == 0) break;
				if (item.m_BonusType[k] == u) {
					v = Math.max(v, item.m_BonusVal[k]);
					break;
				}
			}
			break;
		}
		
		return 77 + v;
	}

	public function ShipPower(owner:uint, type:int):int
	{
		var v:int=Common.ShipPower[type];

		if(owner==0) return v;
		if(Common.ShipPowerDir[type]==0) return v;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		var ar:Array=DirValAr(Common.ShipPowerDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[0];//ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipPowerDir[type]);
		if(lvl<0 || lvl>=ar.length) return 0;

		return ar[lvl];
	}

	public function ShipAccuracy(owner:uint, type:int):int
	{
		var i:int, u:int, k:int;
		var v:int=0;

		if(owner==0) return v;
		if(Common.ShipAccuracyDir[type]==0) return v;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		if(user.m_UnionId!=0) {
			var uni:Union=UserList.Self.GetUnion(user.m_UnionId,false);
			if(uni!=null) {
				if (type == Common.ShipTypeCorvette) v = Common.CotlBonusValEx(Common.CotlBonusCorvetteAccuracy, uni.m_Bonus[Common.CotlBonusCorvetteAccuracy]);
				else if (type == Common.ShipTypeCruiser) v = Common.CotlBonusValEx(Common.CotlBonusCruiserAccuracy,uni.m_Bonus[Common.CotlBonusCruiserAccuracy]);
				else if (type == Common.ShipTypeDreadnought) v = Common.CotlBonusValEx(Common.CotlBonusDreadnoughtAccuracy,uni.m_Bonus[Common.CotlBonusDreadnoughtAccuracy]);
				else if (type == Common.ShipTypeDevastator) v = Common.CotlBonusValEx(Common.CotlBonusDevastatorAccuracy,uni.m_Bonus[Common.CotlBonusDevastatorAccuracy]);
				else if (type == Common.ShipTypeWarBase) v = Common.CotlBonusValEx(Common.CotlBonusWarBaseAccuracy,uni.m_Bonus[Common.CotlBonusWarBaseAccuracy]);
			}
		}

		while (user.m_IB2_Type != 0 && ((user.m_IB2_Type & 0x8000) != 0)) {
			if (type == Common.ShipTypeCorvette) u = Common.ItemBonusAccuracyCorvette;
			else if (type == Common.ShipTypeCruiser) u = Common.ItemBonusAccuracyCruiser;
			else if (type == Common.ShipTypeDreadnought) u = Common.ItemBonusAccuracyDreadnought;
			else if (type == Common.ShipTypeDevastator) u = Common.ItemBonusAccuracyDevastator;
			else break;

			var item:Item = UserList.Self.GetItem(user.m_IB2_Type & 0x7fff);
			if (item == null) break;
			for (i = 0; i < 4; i++) {
				k = (user.m_IB2_Type >> (16 + i * 4)) & 15;
				if (k == 0) break;
				if (item.m_BonusType[k] == u) {
					v = Math.max(v, item.m_BonusVal[k]);
					break;
				}
			}
			break;
		}

		var ar:Array=DirValAr(Common.ShipAccuracyDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipAccuracyDir[type]);
		if (lvl<0 || lvl>=ar.length) return 0;

		v += ar[lvl];

/*			if(type==Common.ShipTypeCorvette) { if(v>1152) v=1152; }
		else if (type == Common.ShipTypeCruiser) { if(v>576) v=576; }
		else if (type == Common.ShipTypeDreadnought) { if(v>1152) v=1152; }
		else if (type == Common.ShipTypeDevastator) { if(v>576) v=576; }
		else if (type == Common.ShipTypeWarBase) { if(v>576) v=576; }*/

		return v;
	}
	
	public function BuildAccess(owner:uint, st:int):Boolean
	{
		if(m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich) {
			if(st==Common.ShipTypeFlagship) {
				if(!(m_OpsFlag & Common.OpsFlagBuildFlagship)) return false; 
			} else if(st==Common.ShipTypeWarBase) {
				if(!(m_OpsFlag & Common.OpsFlagBuildWarBase)) return false;
			} else if(st==Common.ShipTypeSciBase) {
				if(!(m_OpsFlag & Common.OpsFlagBuildSciBase)) return false;
			} else if(st==Common.ShipTypeShipyard) {
				if (!(m_OpsFlag & Common.OpsFlagBuildShipyard)) return false;
			} else if(st==Common.ShipTypeInvader) {
				if (m_OpsSpeedCapture == 0 || !(m_OpsFlag & Common.OpsFlagBuildShip)) return false;

				if ((m_OpsFlag & Common.OpsFlagEnterSingleInvader) != 0) { }
				// else if ((m_OpsFlag & Common.OpsFlagItemToHyperspace)==0 && (owner & Common.OwnerAI) == 0) return false; для IsWinMaxEnclave это не нужно

			} else if(st==Common.ShipTypeTransport) {
				if(!(m_OpsFlag & Common.OpsFlagBuildShip)) return false;

				if ((m_OpsFlag & Common.OpsFlagLeaveTransport) == 0) { }
				//else if ((m_OpsFlag & Common.OpsFlagItemToHyperspace)==0 && (owner & Common.OwnerAI) == 0) return false; // Чтобы не разбирали на модули

			} else {
				if(!(m_OpsFlag & Common.OpsFlagBuildShip)) return false;
			}
		}
		return true;
	}

	public function ShipAccess(owner:uint, type:int):Boolean
	{
		var v:Boolean=true;

		if(owner==0) return v;
		if(Common.ShipAccessDir[type]==0) return v;

		v=false;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		var ar:Array=DirValAr(Common.ShipAccessDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipAccessDir[type]);
		if(lvl<0 || lvl>=ar.length) return false;

		return ar[lvl]!=0;
	}

	public function ShipRepair(owner:uint, id:uint, type:int):int
	{
		var v:int=0;

		if(owner==0) return v;
		
		if(type==Common.ShipTypeFlagship) {
			return VecValE(owner, id, Common.VecProtectRepair);
		}
		if (type == Common.ShipTypeServiceBase) return 30;
		
		if(Common.ShipRepairDir[type]==0) return v;

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		var ar:Array=DirValAr(Common.ShipRepairDir[type]);
		//if(owner!=Server.Self.m_UserId) return ar[ar.length-1];

		var lvl:int=user.CalcDirLvl(Common.ShipRepairDir[type]);
		if(lvl<0 || lvl>=ar.length) return 0;

		return ar[lvl];
	}

	public function PlanetEmpireMax(owner:uint):int
	{
		var v:int = DirValE(owner, Common.DirEmpireMax);

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		if(user.m_UnionId) {
			var uni:Union=UserList.Self.GetUnion(user.m_UnionId,false);
			if(uni!=null) v+=Common.CotlBonusValEx(Common.CotlBonusPlanetEmpireCnt,uni.m_Bonus[Common.CotlBonusPlanetEmpireCnt]);
		}

		return v;
	}

	public function PlanetEnclaveMax(owner:uint):int
	{
		var v:int = DirValE(owner, Common.DirEnclaveMax);

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		if(user.m_UnionId) {
			var uni:Union=UserList.Self.GetUnion(user.m_UnionId,false);
			if(uni!=null) v+=Common.CotlBonusValEx(Common.CotlBonusPlanetEnclaveCnt,uni.m_Bonus[Common.CotlBonusPlanetEnclaveCnt]);
		}

		return v;
	}

	public function PlanetColonyMax(owner:uint):int
	{
		var v:int = DirValE(owner, Common.DirColonyMax);

		var user:User=UserList.Self.GetUser(owner,false);
		if(user==null) return v;

		if(user.m_UnionId) {
			var uni:Union=UserList.Self.GetUnion(user.m_UnionId,false);
			if(uni!=null) v+=Common.CotlBonusValEx(Common.CotlBonusPlanetColonyCnt,uni.m_Bonus[Common.CotlBonusPlanetColonyCnt]);
		}

		return v;
	}

	public function TechCalcAllLvl():int
	{
		var i:int,u:int;
		var lvl:int=0;
		var user:User=UserList.Self.GetUser(Server.Self.m_UserId,false);
		for(i=0;i<Common.TechCnt;i++) {
			var val:uint=user.m_Tech[i];
			for (u = 0; u < 32; u++) { // , val = val >> 1
				if ((val & (1 << u)) != 0) lvl++;
			}
		}
		return lvl;
	}

	public function CanResearch(user:User,tech:int,dir:int,tech_add:int=-1,dir_add:int=0):Boolean
	{
		if(tech<0 || tech>=Common.TechCnt) return false;
		if(dir<0 || dir>=32) return false;

		if(Common.TechDir[tech*32+dir]==0) return false;

		//var user:User=UserList.Self.GetUser(Server.Self.m_UserId,false);
		var val:uint=user.m_Tech[tech];

		if(tech==tech_add) val|=1<<dir_add;

		if(val & (1<<dir)) return false;
		var row:int=dir>>2;
		for(var i:int=row-1;i>=0;i--) {
			var cnt:int=0;
			for(var u:int=0;u<4;u++) {
				if(val&(1<<((i<<2)+u))) cnt++;
			}
			if(cnt<2) return false;
		}
		return true;
	}

	public function IsUnResearch(user:User, tech:int, dir:int):Boolean
	{
		if(tech<0 || tech>=Common.TechCnt) return false;
		if(dir<0 || dir>=32) return false;

		var val:uint=user.m_Tech[tech];
		if(val & (1<<dir)) return true;
		return false;
	}

	public function CanUnResearch(user:User,tech:int,dir:int):Boolean
	{
		if(tech<0 || tech>=Common.TechCnt) return false;
		if(dir<0 || dir>=32) return false;
		var i:int,cnt:int;

		var val:uint=user.m_Tech[tech];

		if(user.m_Id==Server.Self.m_UserId) {		
			var val2:uint=0;
			if(m_UserResearchLeft>0 && m_UserResearchTech==tech) val2|=1<<m_UserResearchDir;
			if((m_UserFlag & Common.UserFlagTechNext) && m_UserResearchTechNext==tech) val2|=1<<m_UserResearchDirNext;
			val|=val2;
		}
	
		if(!(val & (1<<dir))) return false;
		var row:int=dir>>2;
		for(i=(row+1)*4;i<32;i++) {
			if(val & (1<<i)) break;
		}
		if(i>=32) return true;
		cnt=0;
		for(i=0;i<4;i++) {
			if(val2 & (1<<(row*4+i))) {}
			else {
				if(val & (1<<(row*4+i))) cnt++;
			}
		}

		return cnt>=3;
	}

	public function CalcTechCost(userid:uint, tech:int,allow_research:Boolean=true):Array
	{
		var ra:Array=new Array(6);
		ra[0]=0; ra[1]=0; ra[2]=0; ra[3]=0; ra[4]=0; ra[5]=0;

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId,false);
		if(user==null) return ra;

		var i:int,u:int,cur:int;
		var val:uint;

		var kof:int=0;
		var kof_p:int = 0;
		var kof_n:int = 0;
		var kof_q:int = 0;

		for(i=0;i<Common.TechCnt;i++) {
			val=user.m_Tech[i];
			cur=0;
			for(u=0;u<32;u++,val=val>>1) {
				if(val & 1) {
					cur++;
					kof++;
					if(cur>2 && Common.TechCost(i,3)!=0) kof_p++;
					if (cur > 2 && Common.TechCost(i, 4) != 0) kof_n++;
					if (Common.TechCost(i, 5) != 0 && tech == i) kof_q++;
				}
			}
		}

		if(userid==Server.Self.m_UserId) {
			if(allow_research && m_UserResearchLeft>0) {
				kof++;

				if(Common.TechCost(m_UserResearchTech,3)!=0) {
					val=user.m_Tech[m_UserResearchTech];
					cur=0;
					for(u=0;u<32;u++,val=val>>1) {
						if(val & 1) {
							cur++;
							if(cur>=1) { kof_p++; break; }
						}
					}
				}
				if(Common.TechCost(m_UserResearchTech,4)!=0) {
					val=user.m_Tech[m_UserResearchTech];
					cur=0;
					for(u=0;u<32;u++,val=val>>1) {
						if(val & 1) {
							cur++;
							if(cur>=1) { kof_n++; break; }
						}
					}
				}
				if (Common.TechCost(m_UserResearchTech, 5) != 0 && m_UserResearchTech == tech) {
					kof_q++;
				}
			} 
		}

		var ar:Array=null;
		if(tech==Common.TechProgress) ar=Common.TechProgressCost;
		else if(tech==Common.TechEconomy) ar=Common.TechEconomyCost;
		else if(tech==Common.TechTransport) ar=Common.TechTransportCost;
		else if(tech==Common.TechCorvette) ar=Common.TechCorvetteCost;
		else if(tech==Common.TechCruiser) ar=Common.TechCruiserCost;
		else if(tech==Common.TechDreadnought) ar=Common.TechDreadnoughtCost;
		else if(tech==Common.TechInvader) ar=Common.TechInvaderCost;
		else if(tech==Common.TechDevastator) ar=Common.TechDevastatorCost;
		else if(tech==Common.TechWarBase) ar=Common.TechWarBaseCost;
		else if(tech==Common.TechShipyard) ar=Common.TechShipyardCost;
		else if (tech == Common.TechSciBase) ar = Common.TechSciBaseCost;
		else if (tech == Common.TechQuarkBase) ar = Common.TechQuarkBaseCost;
		else return ra;

		kof = Math.min(500000, (1 + kof) * (1 + kof) * (1 + (kof >> 3)));
		kof_p = Math.min(100000, (1 + kof_p) * (1 + kof_p)); //  * (1 + (kof_p >> 5))
		kof_n = Math.min(100000, (1 + kof_n) * (1 + kof_n)); //  * (1 + (kof_n >> 5))
		kof_q = 4 * (10 + kof_q + 1) * (10 + kof_q + 1);

		ra[0] = ar[0] * kof;
		ra[1] = ar[1] * kof;
		ra[2] = ar[2] * kof;
		ra[5] = ar[5] * kof_q;

		if(Common.TechCost(tech,3)!=0) {
			val=user.m_Tech[tech];
			cur=0;
			for(u=0;u<32;u++,val=val>>1) {
				if(val & 1) {
					cur++;
					if(cur>=2) { ra[3]=ar[3]*kof_p; break; }
				}
			}
		}

		if(Common.TechCost(tech,4)!=0) {
			val=user.m_Tech[tech];
			cur=0;
			for(u=0;u<32;u++,val=val>>1) {
				if(val & 1) {
					cur++;
					if(cur>=2) { ra[4]=ar[4]*kof_n; break; }
				}
			}
		}

		return ra;
	}

	public function CanTalentOn(user:User,cpt:Cpt,talent:int,vec:int):Boolean
	{
		var u:int;
		
		if(talent<0 || talent>=Common.TalentCnt) return false;
		if(vec<0 || vec>=32) return false;

		var dir:int = Common.TalentVec[talent * 32 + vec];
		if(dir==0) return false;

		var val:uint=cpt.m_Talent[talent];

		if(val & (1<<vec)) return false;
		var row:int=vec>>2;
		for(var i:int=row-1;i>=0;i--) {
			var cnt:int=0;
			for(u=0;u<4;u++) {
				if(val&(1<<((i<<2)+u))) cnt++;
			}
			if(cnt<2) return false;
		}
		
		if (dir == Common.VecProtectAntiExchange) {
			u = 0;
			val = cpt.m_Talent[talent];
			for (i = 0; i < 32; i++, val >>= 1) {
				if (val & 1) u++;
			}
			if (u < Common.VecProtectAntiExchange_NeedTalent) return false;
		}
		
		return true;
	}

	public function IsTalentOff(user:User,cpt:Cpt,talent:int,vec:int):Boolean
	{
		if(talent<0 || talent>=Common.TalentCnt) return false;
		if(vec<0 || vec>=32) return false;

		var val:uint=cpt.m_Talent[talent];
		if(val & (1<<vec)) return true;
		return false;
	}

	public function CanTalentOff(user:User,cpt:Cpt,talent:int,vec:int):Boolean
	{
		if(talent<0 || talent>=Common.TalentCnt) return false;
		if(vec<0 || vec>=32) return false;
		var i:int,cnt:int,u:int;

		var val:uint=cpt.m_Talent[talent];
	
		var val2:uint=0;
		val|=val2;
	
		if (!(val & (1 << vec))) return false;
		
		if (Common.TalentVec[talent * 32 +vec]!=Common.VecProtectAntiExchange) {
			var rae:Boolean = false;
			u = 0;
			var valtest:uint = cpt.m_Talent[talent];
			for (i = 0; i < 32; i++, valtest >>= 1) {
				if (valtest & 1) {
					if (Common.TalentVec[talent * 32 +i] == Common.VecProtectAntiExchange) rae = true;
					else u++;
				}
			}
			if (rae && u <= Common.VecProtectAntiExchange_NeedTalent) return false;
		}

		var row:int=vec>>2;
		for(i=(row+1)*4;i<32;i++) {
			if(val & (1<<i)) break;
		}
		if(i>=32) return true;
		cnt=0;
		for(i=0;i<4;i++) {
			if(val2 & (1<<(row*4+i))) {}
			else {
				if(val & (1<<(row*4+i))) cnt++;
			}
		}
		
		return cnt>=3;
	}
	
	public function EjectAccess(fromplanet:Planet, toplanet:Planet, owner:uint, race:int):int
	{
		if (fromplanet == toplanet) return 0;

		var sx:int = Math.max(m_SectorMinX, fromplanet.m_Sector.m_SectorX - 1);
		var sy:int = Math.max(m_SectorMinY, fromplanet.m_Sector.m_SectorY - 1);
		var ex:int = Math.min(m_SectorMinX + m_SectorCntX, fromplanet.m_Sector.m_SectorX + 2);
		var ey:int = Math.min(m_SectorMinY + m_SectorCntY, fromplanet.m_Sector.m_SectorY + 2);

		var i:int, u:int, x:int, y:int, x2:int, y2:int;
		var dx:int, dy:int;
		var sec:Sector, sec2:Sector;
		var p:Planet, p2:Planet;
		var ret:int = 0;
		for (y = sy; y < ey; y++) {
			for (x = sx; x < ex; x++) {
				i = (x - m_SectorMinX) + (y - m_SectorMinY) * m_SectorCntX;
				if (i < 0 || i >= m_SectorCntX * m_SectorCntY) throw Error("");
				if (!(m_Sector[i] is Sector)) continue;
				sec = m_Sector[i];

				for (i = 0; i < sec.m_Planet.length; i++) {
					p = sec.m_Planet[i];
					if (p.m_Flag & Planet.PlanetFlagWormhole) continue;
					if ((p.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) continue;
					if (p.m_Flag & (Planet.PlanetFlagGravitor | Planet.PlanetFlagGravitorSci)) continue;
					if (p == fromplanet) continue;

					dx = fromplanet.m_PosX - p.m_PosX;
					dy = fromplanet.m_PosY - p.m_PosY;
					if ((dx * dx + dy * dy) > JumpRadius2) continue;

					if (p == toplanet) return 1;

					var sx2:int = Math.max(m_SectorMinX, p.m_Sector.m_SectorX - 1);
					var sy2:int = Math.max(m_SectorMinY, p.m_Sector.m_SectorY - 1);
					var ex2:int = Math.min(m_SectorMinX + m_SectorCntX, p.m_Sector.m_SectorX + 2);
					var ey2:int = Math.min(m_SectorMinY + m_SectorCntY, p.m_Sector.m_SectorY + 2);

					var find:Boolean = false;

					for (y2 = sy2; y2 < ey2; y2++) {
						for (x2 = sx2; x2 < ex2; x2++) {
							i = (x2 - m_SectorMinX) + (y2 - m_SectorMinY) * m_SectorCntX;
							if (i < 0 || i >= m_SectorCntX * m_SectorCntY) throw Error("");
							if (!(m_Sector[i] is Sector)) continue;
							sec2 = m_Sector[i];

							for (u = 0; u < sec2.m_Planet.length; u++) {
								p2 = sec2.m_Planet[u];
								if (p2.m_Flag & Planet.PlanetFlagWormhole) continue;
								if ((p2.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) continue;
								if (p2.m_Flag & (Planet.PlanetFlagGravitor | Planet.PlanetFlagGravitorSci)) continue;
								if (p2 != toplanet) continue;

								dx = p.m_PosX - p2.m_PosX;
								dy = p.m_PosY - p2.m_PosY;
								if ((dx * dx + dy * dy) > JumpRadius2) continue;

								find = true;
								break;
							}
							if (find) break;
						}
						if (find) break;
					}
					if (!find) continue;

					if (!ExistEnemyShip(p, owner, race, false, Common.ShipFlagBuild, true)) return 1;
					ret = 2;
				}
			}
		}
		return ret;
	}

	public function IsNearIsland(planet:Planet, island:int):Boolean
	{
		var sx:int=Math.max(m_SectorMinX,planet.m_Sector.m_SectorX-1);
		var sy:int=Math.max(m_SectorMinY,planet.m_Sector.m_SectorY-1);
		var ex:int=Math.min(m_SectorMinX+m_SectorCntX,planet.m_Sector.m_SectorX+2);
		var ey:int=Math.min(m_SectorMinY+m_SectorCntY,planet.m_Sector.m_SectorY+2);

		var i:int,x:int,y:int;
		var sec:Sector;
		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
				if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
				if(!(m_Sector[i] is Sector)) continue;
				sec=m_Sector[i];

				for(i=0;i<sec.m_Planet.length;i++) {
					var p2:Planet=sec.m_Planet[i];

					if(p2.m_Island!=island) continue; 

					var dx:int=planet.m_PosX-p2.m_PosX;
					var dy:int=planet.m_PosY-p2.m_PosY;

					if((dx*dx+dy*dy)>JumpRadius2) continue;
					
					return true;
				}
			}
		}
		return false;
	}

	public function IsNearIslandCitadel(planet:Planet):uint
	{
		var sx:int=Math.max(m_SectorMinX,planet.m_Sector.m_SectorX-1);
		var sy:int=Math.max(m_SectorMinY,planet.m_Sector.m_SectorY-1);
		var ex:int=Math.min(m_SectorMinX+m_SectorCntX,planet.m_Sector.m_SectorX+2);
		var ey:int=Math.min(m_SectorMinY+m_SectorCntY,planet.m_Sector.m_SectorY+2);

		var i:int, k:int, x:int, y:int;
		var sec:Sector;
		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
				if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
				if(!(m_Sector[i] is Sector)) continue;
				sec=m_Sector[i];

				for (k = 0; k < sec.m_Planet.length; k++) {
					var p2:Planet=sec.m_Planet[k];

					var dx:int=planet.m_PosX-p2.m_PosX;
					var dy:int=planet.m_PosY-p2.m_PosY;

					if ((dx * dx + dy * dy) > JumpRadius2) continue;

					for (i = 0; i < Common.CitadelMax; i++) {
						if (m_CitadelIsland[i] == p2.m_Island) break;
					}
					if (i < Common.CitadelMax) return m_CitadelIsland[i];
				}
			}
		}
		return 0;
	}

	public function CalcSpeed(owner:uint, cptid:uint, type:int):int
	{
		var user:User;
		var v:int=Common.ShipSpeedPerSecond;
		
		user = null;
		if(owner!=0) user=UserList.Self.GetUser(owner);
			
		while(type==Common.ShipTypeFlagship) {
			if(user==null) break;
			var cpt:Cpt=user.GetCpt(cptid);
			if(cpt==null) break;
			v=Common.DirShipSpeedLvlRC[cpt.CalcVecLvl(Common.VecMoveSpeed)];
			break;
		}
		
		while(type!=Common.ShipTypeFlagship) {
			//v=Common.DirShipSpeedLvlRC[m_FormTech.CalcDirLvl(Common.DirShipSpeed)];
//trace("CS00",user,owner);
			if(user==null) return v;
			v=Common.DirShipSpeedLvlRC[user.CalcDirLvl(Common.DirShipSpeed)];
//trace("CS01",v);
			break;
		}

		if(type==Common.ShipTypeTransport) {}
		else if ((type == Common.ShipTypeCorvette) || ((user != null) && (user.m_Race == Common.RacePeleng)/* && (type != Common.ShipTypeFlagship)*/)) {
			v=v+(v>>1);
		}
		
		return v;
	}

	public function CalcFlyTimeEx(speed:int, owner:uint, race:uint, fromplanet:Planet, toplanet:Planet):int
	{
		if (race!=Common.RacePeleng && fromplanet.m_Owner != 0 && owner != 0 && !IsFriendEx(fromplanet, owner, Common.RaceNone, fromplanet.m_Owner, Common.RaceNone)) speed >>= 1;

		var dx:int = fromplanet.m_PosX - toplanet.m_PosX;
		var dy:int = fromplanet.m_PosY - toplanet.m_PosY;
		
		return Math.floor(Math.floor(Math.sqrt(dx * dx + dy * dy)) / speed) + 1;
	}

	public function CalcFlyTime(owner:uint, cptid:uint, type:int, race:uint, fromplanet:Planet, toplanet:Planet):int
	{
		var v:int = CalcSpeed(owner, cptid, type);	
		var dx:int = fromplanet.m_PosX - toplanet.m_PosX;
		var dy:int = fromplanet.m_PosY - toplanet.m_PosY;

		if (race!=Common.RacePeleng && fromplanet.m_Owner != 0 && owner != 0 && !IsFriendEx(fromplanet, owner, Common.RaceNone, fromplanet.m_Owner, Common.RaceNone)) v >>= 1;

		return Math.floor(Math.floor(Math.sqrt(dx * dx + dy * dy)) / v) + 1;
	}

	public function GameStateLeftTime():Array
	{
		if(m_SessionPeriod<=0) return null;

		var sd:Date=GetServerDate();
		var st:int=sd.hours*60*60+sd.minutes*60+sd.seconds;

		var hour_period:int=Math.floor(m_SessionPeriod/(60*60));
		if((m_SessionPeriod % (60*60))!=0) hour_period++;

		var t:int=st-m_SessionStart;
		if(t<0) t=24*60*60-m_SessionStart+st;
		if(t<0) throw Error("");

		t=t % (hour_period*60*60);

		if(t<m_SessionPeriod) {
			return [0,m_SessionPeriod-t];
		} else {
			return [1,(hour_period*60*60)-t];
		}
	}

	public function StealthType(planet:Planet, ship:Ship, owner:uint):int
	{
		var i:int, k:int;
		var ship2:Ship;
		var r:int=0;

		if(planet==null) return r;
		if(ship==null) return r;
		if(ship.m_Type==Common.ShipTypeNone) return r;
		if(!ship.m_Owner) return r;

		if(ship.m_Type==Common.ShipTypeCorvette && DirValE(ship.m_Owner,Common.DirCorvetteStealth)!=0) {
			r=2;
		} else if(ship.m_Type==Common.ShipTypeFlagship) {
			if(VecValE(ship.m_Owner, ship.m_Id, Common.VecSystemStealth)!=0) {
				r=2;
			}
		}

		if(r==0) {
			for(i=0;i<Common.ShipOnPlanetMax;i++) {
				ship2=planet.m_Ship[i];

				if(ship2.m_Type!=Common.ShipTypeFlagship) continue;
				if(ship.m_Owner!=ship2.m_Owner) continue;
				if(ship2.m_Flag & Common.ShipFlagBuild) continue;

				if(VecValE(ship2.m_Owner, ship2.m_Id, Common.VecSystemStealth)>=2) { 
					r=2;
				}
			}
		}
		
		if(r==2 && IsEdit()) r=1;

		if(r==2) {
			if(ship.m_Owner==owner) r=1;
			else if(IsFriendEx(planet, ship.m_Owner, Common.RaceNone, owner, Common.RaceNone)) r=1;
			else if((GetRel(ship.m_Owner,owner) & (Common.PactControl | Common.PactBuild))!=0) r=1;
		}

		if(r==2) {
			if(IsBattle(planet, ship.m_Owner, ship.m_Race, false, false)) r=1;
		}
		
		if(r==2) {
			if(CalcRadarPower(planet, owner)>0) r=1;
		}
		
		return r;
	}

	public function CalcRadarPower(planet:Planet, owner:uint):int
	{
		var i:int, k:int;
		var ship2:Ship;
		var planet2:Planet;

		var radar:int=0;
		var pomehi:int=0;

		var sec:Sector=planet.m_Sector;
		var fsx:int=Math.max(m_SectorMinX,sec.m_SectorX-1);
		var fsy:int=Math.max(m_SectorMinY,sec.m_SectorY-1);
		var esx:int=Math.min(m_SectorMinX+m_SectorCntX,sec.m_SectorX+2);
		var esy:int=Math.min(m_SectorMinY+m_SectorCntY,sec.m_SectorY+2);

		for(var sy:int=fsy;sy<esy;sy++) {
			for(var sx:int=fsx;sx<esx;sx++) {
//	                for(k=0;k<sec.m_Planet.length;k++) {
//						var planet2:Planet=GetPlanet(sx,sy,k);
//						if(planet2==null) continue;		                	
				i=(sx-m_SectorMinX)+(sy-m_SectorMinY)*m_SectorCntX;
				if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
				if(!(m_Sector[i] is Sector)) continue;
				sec=m_Sector[i];

				for(k=0;k<sec.m_Planet.length;k++) {
					planet2=sec.m_Planet[k];

					var dx:int=planet2.m_PosX-planet.m_PosX;
					var dy:int=planet2.m_PosY-planet.m_PosY;
					if((dx*dx+dy*dy)>JumpRadius2) continue;

					for(i=0;i<Common.ShipOnPlanetMax;i++) {
						ship2=planet2.m_Ship[i];

						if(ship2.m_Type!=Common.ShipTypeFlagship) continue;
						if(ship2.m_Flag & Common.ShipFlagBuild) continue;

						if(IsFriendEx(planet2, owner, Common.RaceNone, ship2.m_Owner, ship2.m_Race)) {
							radar=Math.max(radar,VecValE(ship2.m_Owner, ship2.m_Id, Common.VecMoveRadar));
						} else {
							pomehi=Math.max(pomehi,VecValE(ship2.m_Owner, ship2.m_Id, Common.VecSystemJummer));
						}
					}
				}
			}
		}

		return radar-pomehi;
	}
		
	public function AddGraphFind(cotlid:int, secx:int, secy:int, planetnum:int, shipnum:int=-1, shipid:uint=0):void
	{
		var gf:GraphFind=new GraphFind(this,cotlid,secx,secy,planetnum,shipnum,shipid);
		gf.m_Delay=0;
		m_FindLayer.addChild(gf);

		gf=new GraphFind(this,cotlid,secx,secy,planetnum,shipnum,shipid);
		gf.m_Delay=100;
		m_FindLayer.addChild(gf);

		gf=new GraphFind(this,cotlid,secx,secy,planetnum,shipnum,shipid);
		gf.m_Delay=200;
		m_FindLayer.addChild(gf);
	}
	
	public function UpdateGraphFind():void
	{
		var gf:GraphFind;
		var i:int;

		for(i=m_FindLayer.numChildren-1;i>=0;i--) {
			gf=m_FindLayer.getChildAt(i) as GraphFind;
			if(!gf.Update()) {
				m_FindLayer.removeChild(gf);
			}
		}
	}

	public function IsShowMine(placeno:int, ship:Ship, planet:Planet, owner:uint):Boolean
	{
		var i:int;
		if(IsEdit()) return true;
		if(ship.m_OrbitItemOwner==owner) return true;
		if(AccessControl(ship.m_OrbitItemOwner)) return true;
		if(AccessBuild(ship.m_OrbitItemOwner)) return true;
		
		if(ship.m_Type!=Common.ShipTypeNone) {
			if(ship.m_Owner==owner) return true;
			if(IsFriendEx(planet, ship.m_Owner, Common.RaceNone, owner, Common.RaceNone)) return true;
		}

		if(IsFriendEx(planet, ship.m_OrbitItemOwner, Common.RaceNone, owner, Common.RaceNone)) return true;

		for(i=0;i<Common.ShipOnPlanetMax;i++) {
			var ship2:Ship=planet.m_Ship[i];
			if(ship2.m_Type!=Common.ShipTypeFlagship) continue;
			if(ship2.m_Flag & Common.ShipFlagBuild) continue;

			if(ship2.m_Owner==owner) {}
			else if(!IsFriendEx(planet, ship2.m_Owner, Common.RaceNone, owner, Common.RaceNone)) continue;

			var maxdist:int=VecValE(ship2.m_Owner, ship2.m_Id, Common.VecSystemSensor);
			if(maxdist>=8) return true;

			var t:int=placeno-i;
			if(t<0) t=Common.ShipOnPlanetMax+t;
			if(t<=maxdist) return true;
			if((Common.ShipOnPlanetMax-t)<=maxdist) return true;
		}

		return false; 			
	}

	public var m_IsVis_Planet:Planet = null;
	public var m_IsVis_Range:Boolean = false;
	public var m_IsVis_ret:Boolean = false;
	public function IsVisCalc(planet:Planet, range:Boolean = true):Boolean
	{
//return true;
		var i:int,k:int;
		var ship2:Ship;
		var planet2:Planet;
		var sec:Sector;
		var user:User;

		if (m_IsVis_Planet == planet && m_IsVis_Range == range) return m_IsVis_ret;
		m_IsVis_Planet = planet;
		m_IsVis_Range = range;

		if(IsEdit()) { m_IsVis_ret=true; return true; }

		if (planet == null) { m_IsVis_ret = false; return false; }
		if (m_Set_VisOn) { m_IsVis_ret = true; return true; }

		var userinlandingplace:Boolean=false;

		if (m_CotlType == Common.CotlTypeCombat && (m_GameState & Common.GameStatePlacing) != 0) {
			i = TeamType();
			if (planet.m_Team < 0) return false;
			if (i == 0 && planet.m_Team == m_OpsTeamEnemy) m_IsVis_ret = true;
			else if (i == 1 && planet.m_Team == m_OpsTeamOwner) m_IsVis_ret = true;
			else m_IsVis_ret = false;
//trace("IsVis Combat",m_IsVis_ret);
			return m_IsVis_ret;
		}
		if ((m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeRich || m_CotlType == Common.CotlTypeCombat) && (m_OpsFlag & Common.OpsFlagViewAll) != 0) { m_IsVis_ret = true; return true; }

		if (planet.m_VisTime > m_ServerCalcTime) { m_IsVis_ret = true; return true; }

		while(m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeProtect) {
			for(i=0;i<m_FormMiniMap.m_LandingAccess.length;i++) {
				if(m_FormMiniMap.m_LandingAccess[i]==Server.Self.m_UserId) { userinlandingplace=true; break; }
			}

			if((planet.m_Flag & Planet.PlanetFlagArrivalDef)!=0 && m_UnionId==m_CotlUnionId) {}
			else if((planet.m_Flag & Planet.PlanetFlagArrivalAtk)!=0 && m_UnionId!=m_CotlUnionId) {}
			else break;
			
			if(planet.m_LandingPlace<=0 || planet.m_LandingPlace>=m_FormMiniMap.m_LandingAccess.length) break;
			
			if(m_FormMiniMap.m_LandingAccess[planet.m_LandingPlace]==0 && !userinlandingplace) { m_IsVis_ret=true; return true; }
			else if(m_FormMiniMap.m_LandingAccess[planet.m_LandingPlace]==Server.Self.m_UserId) { m_IsVis_ret=true; return true; }
			
			break;
		}

		if ((m_CotlType == Common.CotlTypeUser) && (m_CotlOwnerId == Server.Self.m_UserId) && (m_HomeworldPlanetNum < 0) && ((m_GameState & Common.GameStateTraining) == 0)) {
			m_IsVis_ret = true; 
			return true;
		}

		if ((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) {
			if ((planet.m_Flag & (Planet.PlanetFlagWormholePrepare | Planet.PlanetFlagWormholeOpen)) != 0) { m_IsVis_ret=true; return true; }
		}

		if (planet.m_Owner == Server.Self.m_UserId) { m_IsVis_ret = true; return true; }
		if (planet.m_Owner) {
			user = UserList.Self.GetUser(planet.m_Owner);
			if(user && (user.m_Flag & Common.UserFlagVisAll)) { m_IsVis_ret = true; return true; }
		}
		if((GetRel(planet.m_Owner,Server.Self.m_UserId) & (Common.PactControl|Common.PactBuild))!=0) { m_IsVis_ret=true; return true; }
		if(IsFriendEx(planet, planet.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) { m_IsVis_ret=true; return true; }

		var fsx:int=Math.max(m_SectorMinX,planet.m_Sector.m_SectorX-1);
		var fsy:int=Math.max(m_SectorMinY,planet.m_Sector.m_SectorY-1);
		var esx:int=Math.min(m_SectorMinX+m_SectorCntX,planet.m_Sector.m_SectorX+2);
		var esy:int=Math.min(m_SectorMinY+m_SectorCntY,planet.m_Sector.m_SectorY+2);

		var lastowner:uint=planet.m_Owner;

		for(var sy:int=fsy;sy<esy;sy++) {
			for(var sx:int=fsx;sx<esx;sx++) {
//	                for(k=0;k<sec.m_Planet.length;k++) {
//						planet2=GetPlanet(sx,sy,k);
//						if(planet2==null) continue;
						
				i=(sx-m_SectorMinX)+(sy-m_SectorMinY)*m_SectorCntX;
				if(i<0 || i>=m_SectorCntX*m_SectorCntY) continue;
				if(!(m_Sector[i] is Sector)) continue;
				sec=m_Sector[i];

				for(k=0;k<sec.m_Planet.length;k++) {
					planet2=sec.m_Planet[k];

					var dx:int=planet2.m_PosX-planet.m_PosX;
					var dy:int = planet2.m_PosY - planet.m_PosY;
					if(range) {
						if ((dx * dx + dy * dy) > JumpRadius2) continue;
					} else {
						if ((dx * dx + dy * dy) > 1) continue;
					}
					
					if (planet2.m_VisTime > m_ServerCalcTime) { m_IsVis_ret = true; return true; }

					while(m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat) {
						if((planet2.m_Flag & Planet.PlanetFlagArrivalDef)!=0 && m_UnionId==m_CotlUnionId) {}
						else if((planet2.m_Flag & Planet.PlanetFlagArrivalAtk)!=0 && m_UnionId!=m_CotlUnionId) {}
						else break;

						if(planet2.m_LandingPlace<=0 || planet2.m_LandingPlace>=m_FormMiniMap.m_LandingAccess.length) break;

						if(m_FormMiniMap.m_LandingAccess[planet2.m_LandingPlace]==0 && !userinlandingplace) { m_IsVis_ret=true; return true; }
						else if(m_FormMiniMap.m_LandingAccess[planet2.m_LandingPlace]==Server.Self.m_UserId) { m_IsVis_ret=true; return true; }
						
						break;
					}

					if ((planet2.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) {
						if ((planet2.m_Flag & (Planet.PlanetFlagWormholePrepare | Planet.PlanetFlagWormholeOpen)) != 0) { m_IsVis_ret=true; return true; }
					}

					if(planet2.m_Owner!=0 && lastowner!=planet2.m_Owner) {
						if(planet2.m_Owner==Server.Self.m_UserId) { m_IsVis_ret=true; return true; }
						if (planet2.m_Owner) {
							user = UserList.Self.GetUser(planet2.m_Owner);
							if(user && (user.m_Flag & Common.UserFlagVisAll)) { m_IsVis_ret = true; return true; }
						}
						//if(AccessControl(planet2.m_Owner)) return true;
						//if(AccessBuild(planet2.m_Owner)) return true;
						if((GetRel(planet2.m_Owner,Server.Self.m_UserId) & (Common.PactControl|Common.PactBuild))!=0) { m_IsVis_ret=true; return true; }
						if(IsFriendEx(planet2, planet2.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) { m_IsVis_ret=true; return true; }
						lastowner=planet2.m_Owner;
					}

					for(i=0;i<Common.ShipOnPlanetMax;i++) {
						ship2=planet2.m_Ship[i];

						if(ship2.m_Type==Common.ShipTypeNone) continue;
						if(ship2.m_Owner==0) continue;

						if(lastowner!=ship2.m_Owner) {
							if(ship2.m_Owner==Server.Self.m_UserId) { m_IsVis_ret=true; return true; }
							if (ship2.m_Owner) {
								user = UserList.Self.GetUser(ship2.m_Owner);
								if(user && (user.m_Flag & Common.UserFlagVisAll)) { m_IsVis_ret = true; return true; }
							}
							//if(AccessControl(ship2.m_Owner)) return true;
							//if(AccessBuild(ship2.m_Owner)) return true;
							if((GetRel(ship2.m_Owner,Server.Self.m_UserId) & (Common.PactControl|Common.PactBuild))!=0) { m_IsVis_ret=true; return true; }
							if(IsFriendEx(planet2, ship2.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) { m_IsVis_ret=true; return true; }
							lastowner=ship2.m_Owner;
						}
					}
				}
			}
		}
		m_IsVis_ret=false;
		return false;
	}

	public function TestExitFromHyperspace(tx:int, ty:int, planetnum:int, owner:uint):Boolean
	{
		var sx:int,sy:int,ex:int,ey:int,x:int,y:int,i:int,u:int;
		var ship:Ship;

		var planet:Planet=GetPlanet(tx,ty,planetnum);
		if(planet==null) return false;
		
/*			var ff:Boolean=false;
		if(planet.m_Owner==owner) ff=true;
		for(u=0;u<Common.ShipOnPlanetMax;u++) {
			ship=planet.m_Ship[u];
			if(ship.m_Type==Common.ShipTypeNone) continue;
			if(ship.m_Owner==0) continue;
			
			if(ship.m_Owner==owner) ff=true;
			else if(!IsFriendEx(planet, ship.m_Owner, Common.RaceNone, owner, Common.RaceNone)) return false;
		}
		if(ff) return true;*/

		var ff:Boolean=false;
		if (planet.m_Owner == owner || IsFriendEx(planet, planet.m_Owner, Common.RaceNone, owner, Common.RaceNone)) ff = true;
		var sopl:int = planet.ShipOnPlanetLow;
		for(u=0;u<sopl;u++) {
			ship=planet.m_Ship[u];
			if(ship.m_Type==Common.ShipTypeNone/* || ship.m_Type==Common.ShipTypeTransport*/) continue;
			if(ship.m_Owner==0) continue;
			
			if(ship.m_Owner==owner) {}// ff=true;
			else if(!IsFriendEx(planet, ship.m_Owner, Common.RaceNone, owner, Common.RaceNone)) return false;
		}
		if(ff) return true;

		sx=Math.max(m_SectorMinX,tx-1);
		sy=Math.max(m_SectorMinY,ty-1);
		ex=Math.min(m_SectorMinX+m_SectorCntX,tx+2);
		ey=Math.min(m_SectorMinY+m_SectorCntY,ty+2);

		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				var sec:Sector=GetSector(x,y);
				if(sec==null) continue;

				for(i=0;i<sec.m_Planet.length;i++) {
					planet=sec.m_Planet[i];

					if(planet.m_Owner!=0) {
						if(!IsFriendEx(planet, planet.m_Owner, Common.RaceNone, owner, Common.RaceNone)) return false;
					}

					for(u=0;u<sopl;u++) {
						ship=planet.m_Ship[u];
						if(ship.m_Type==Common.ShipTypeNone/* || ship.m_Type==Common.ShipTypeTransport*/) continue;
						if(ship.m_Owner==0) continue;

						if(!IsFriendEx(planet, ship.m_Owner, Common.RaceNone, owner, Common.RaceNone)) return false;
					}
				}
			}
		}
		
		return true;
	}

	public function TestRatingFlyCotl(tgt_owner:uint,zonelvl:int):Boolean
	{
		var tgtuser:User=UserList.Self.GetUser(tgt_owner);
		if(tgtuser==null) return false;

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return false;

		zonelvl&=3;
		if(zonelvl==0) return true;

		var m:int=(tgtuser.m_Rating+user.m_Rating)>>1;
		var d:int=Math.max(tgtuser.m_Rating,user.m_Rating)-m;
		
		if(zonelvl==1) return d<=Math.floor(m/3);
		else if(zonelvl==2) return d<=Math.floor(m/5);
		else return d<=Math.floor(m/11);
//			return d<=(m>>2);
	}
	
	public function CalcBuildingBuildTime(bt:int, lvl:int):int
	{
		var t:int = 10;
		if (lvl == 1) t = 10;
		else if (lvl == 2) t = 20;
		else if (lvl == 3) t = 30;
		else if (lvl == 4) t = 40;
		else if (lvl == 5) t = 50;
		return t;
	}
	
	public function SetFPSMax(v:int):void
	{
		if(v<1) v=1;
		else if(v>1000) v=1000;
		if(v==m_Set_FPSMax) return;
		m_Set_FPSMax=v;
		m_FPS_UpdatePeriod = Math.ceil(1000 / m_Set_FPSMax);
		m_Timer.delay = Math.max(1, m_FPS_UpdatePeriod);
		stage.frameRate = m_Set_FPSMax;
//trace("m_FPS_UpdatePeriod:",m_FPS_UpdatePeriod);
	}

	public function OnOrbitCotl(cotlid:uint):Boolean
	{
		if (m_FleetAction != Common.FleetActionInOrbitCotl) return false;
		if (m_FleetTgtId != cotlid) return false;
		return true;
	}
	
//		public function OnOrbitCotl(cotl:SpaceCotl, x:int, y:int):Boolean
//		{
//			var r:int=Common.EmpireCotlSizeToRadius(cotl.m_Size)+Common.CotlOrbitRadius;
//			x-=cotl.m_X;
//			y-=cotl.m_Y;
//			if((x*x+y*y)>(r*r)) return false;
//			return true;
//		}

	private var m_EditX:int=0;
	private var m_EditY:int=0;
	public function MenuEditGlobal():void
	{
		PickWorldCoord(mouseX, mouseY, m_TPickPos);
		m_EditX = Math.round(m_TPickPos.x);// ScreenToWorldX(mouseX);
		m_EditY = Math.round(m_TPickPos.y);// ScreenToWorldY(mouseY);

		FormHideAll();
		m_FormMenu.Clear();

		if (IsEdit() && (CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditMap)) {
			m_FormMenu.Add(Common.TxtEdit.AddPlanet, EditMapAddPlanet);
			m_FormMenu.Add(Common.TxtEdit.MapChangeSize, EditMapChangeSize);
			m_FormMenu.Add(Common.TxtEdit.MapChangeRandomizeNeutral, EditMapChangeRandomizeNeutral);
			m_FormMenu.Add(Common.TxtEdit.MapChangeRandomizeElement, EditMapChangeRandomizeElement);
		}

		if (IsEdit() && (CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditOps)) {
			m_FormMenu.Add(Common.TxtEdit.FormTeamRelCaption, EditMapTeamRel);
		}

		if (CotlDevAccess(Server.Self.m_CotlId) & (SpaceCotl.DevAccessEditOps)) {
			m_FormMenu.Add();
			m_FormMenu.Add(Common.TxtEdit.OwnerOptions+":");
			m_FormMenu.Add("    "+Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI0),EditMapOptionsAI,Common.OwnerAI0);
			m_FormMenu.Add("    "+Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI1),EditMapOptionsAI,Common.OwnerAI1);
			m_FormMenu.Add("    "+Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI2),EditMapOptionsAI,Common.OwnerAI2);
			m_FormMenu.Add("    "+Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI3),EditMapOptionsAI,Common.OwnerAI3);
			
			m_FormMenu.Add();
			m_FormMenu.Add(Common.TxtEdit.OwnerTech+":");
			m_FormMenu.Add("    "+Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI0),EditMapTechAI,Common.OwnerAI0);
			m_FormMenu.Add("    "+Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI1),EditMapTechAI,Common.OwnerAI1);
			m_FormMenu.Add("    "+Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI2),EditMapTechAI,Common.OwnerAI2);
			m_FormMenu.Add("    " + Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI3), EditMapTechAI, Common.OwnerAI3);
		}

		m_FormMenu.Add();
		//if(m_CotlType==Common.CotlTypeProtect || m_CotlType==Common.CotlTypeCombat || m_CotlType==Common.CotlTypeRich) {
		if (CotlDevAccess(Server.Self.m_CotlId) & (SpaceCotl.DevAccessEditOps|SpaceCotl.DevAccessView)) {
			m_FormMenu.Add(Common.TxtEdit.MapChangeOptions, EditMapChangeOptions);
			m_FormMenu.Add(Common.TxtEdit.MapChangeOptionsEx, EditMapChangeOptionsEx);
		}
		if (CotlDevAccess(Server.Self.m_CotlId) & (SpaceCotl.DevAccessEditCode|SpaceCotl.DevAccessView)) {
			m_FormMenu.Add(Common.TxtEdit.MapChangeCode, EditMapChangeCode);
		}
		//}
		if (m_UserAccess & User.AccessGalaxyOps) {
			m_FormMenu.Add(Common.TxtEdit.MapChangeConsumption, ConsumptionEditMap);
		}

		if (CotlDevAccess(Server.Self.m_CotlId) & (SpaceCotl.DevAccessView)) {
			m_FormMenu.Add(Common.TxtEdit.MapChangeViewStat, EditMapViewStat);
		}

		if (CotlDevAccess(Server.Self.m_CotlId) & (SpaceCotl.DevAccessEditOps|SpaceCotl.DevAccessEditMap|SpaceCotl.DevAccessEditCode)) {
			if (!IsEdit() && (m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeCombat)) {}
			else m_FormMenu.Add(Common.TxtEdit.MapSave, EditCotlMapSave);
		
			m_FormMenu.Add(Common.TxtEdit.MapUnload, EditCotlMapUnload);
		}
		if ((CotlDevAccess(Server.Self.m_CotlId) & (SpaceCotl.DevAccessEditOps | SpaceCotl.DevAccessEditMap | SpaceCotl.DevAccessEditCode)) == (SpaceCotl.DevAccessEditOps | SpaceCotl.DevAccessEditMap | SpaceCotl.DevAccessEditCode)) {
			m_FormMenu.Add(Common.TxtEdit.MapDelete, EditCotlMapDelete);
		}

		m_FormMenu.Add();
		
		if (m_UserAccess & User.AccessGalaxyOps) {
			m_FormMenu.Add(Common.TxtEdit.ProtectRemove, ProtectRemove);
		}
		
		m_FormMenu.Add(Common.TxtEdit.UpdateMap,EditMapUpdateMap);

		var cx:int=mouseX;
		var cy:int=mouseY;

		m_FormMenu.Show(cx-1,cy-1,cx+1,cy+1);
	}

	private function ProtectRemove(...args):void
	{
		var ac:Action=new Action(this);
		ac.ActionSpecial(33,0,0,-1,-1);
		m_LogicAction.push(ac);
	}
			
	private function EditCotlMapSave(...args):void
	{
		SendAction("emedcotlspecial","&type=2");
	}

	private function EditCotlMapUnload(...args):void
	{
		FormMessageBox.Run(Common.TxtEdit.MapUnloadQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, EditCotlMapUnloadSend);
	}

	private function EditCotlMapUnloadSend():void
	{
		SendAction("emedcotlspecial", "&type=3");
		
		//GoRootCotl();
	}

	private function EditCotlMapDelete(...args):void
	{
		FormHideAll();
		
		m_FormInput.Init(400);

		m_FormInput.AddLabel(Common.TxtEdit.MapDeleteQuery+":");

		m_FormInput.AddInput("",9,false,Server.LANG_ENG).addEventListener(Event.CHANGE,EditCotlMapDeleteChange);

		m_FormInput.ColAlign();
		m_FormInput.Run(EditCotlMapDeleteSend,Common.TxtEdit.MapDelete);
		m_FormInput.m_ButOk.visible=false;
	}
	
	private function EditCotlMapDeleteChange(e:Event):void
	{
		m_FormInput.m_ButOk.visible=m_FormInput.GetStr(0)=='DELETE';
	}

	private function EditCotlMapDeleteSend():void
	{
		SendAction("emedcotlspecial", "&type=4");
		
		GoRootCotl();
	}

	public function EditMapUpdateMap(...args):void
	{
		Server.Self.Query("emedcotlspecial","&type=5&left=0&top=0&right=0&bottom=0",EditMapChangeSizeRecv,false);
	}
	
	public function EditMapChangeOptions(...args):void
	{
		var i:int;

		FI.Init(480,600);
		FI.caption = Common.TxtEdit.MapChangeOptions;
		
		FI.TabAdd("page 1");
		FI.tab = 0;
		
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagEnterShip)!=0,Common.TxtEdit.MapChangeOpsEnterShip);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagEnterFlagship)!=0,Common.TxtEdit.MapChangeOpsEnterFlagship);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagEnterTransport)!=0,Common.TxtEdit.MapChangeOpsEnterTransport);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagEnterSingleInvader)!=0,Common.TxtEdit.MapChangeOpsEnterSingleInvader);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagLeaveShip)!=0,Common.TxtEdit.MapChangeOpsLeaveShip);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagLeaveFlagship)!=0,Common.TxtEdit.MapChangeOpsLeaveFlagship);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagLeaveTransport)!=0,Common.TxtEdit.MapChangeOpsLeaveTransport);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagBuildShip)!=0,Common.TxtEdit.MapChangeOpsBuildShip);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagBuildFlagship)!=0,Common.TxtEdit.MapChangeOpsBuildFlagship);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagBuildWarBase)!=0,Common.TxtEdit.MapChangeOpsBuildWarBase);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagBuildSciBase)!=0,Common.TxtEdit.MapChangeOpsBuildSciBase);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagBuildShipyard)!=0,Common.TxtEdit.MapChangeOpsBuildShipyard);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagItemToHyperspace) != 0, Common.TxtEdit.MapChangeOpsItemToHyperspace);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagBuilding) != 0, Common.TxtEdit.MapChangeOpsBuilding);
		
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagViewAll) != 0, Common.TxtEdit.MapChangeOpsViewAll);
		
		FI.TabAdd("page 2");

		FI.AddLabel(Common.TxtEdit.MapChangeOpsJumpRadius+":");
		FI.Col();
		FI.AddInput(m_OpsJumpRadius.toString(), 5, true, 0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsModuleProduction+":");
		FI.Col();
		FI.AddInput(m_OpsModuleMul.toString(),5,true,0);

		//FI.AddLabel(Common.TxtEdit.MapChangeOpsCostBuildLvl+":");
		//FI.Col();
		//FI.AddInput(Math.round((m_OpsCostBuildLvl*100)/256).toString(),4,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsSpeedCapture+":");
		FI.Col();
		FI.AddInput(m_OpsSpeedCapture.toString()/*Math.round((m_OpsSpeedCapture*100)/256).toString()*/,4,true,0);
		
		FI.AddLabel(Common.TxtEdit.MapChangeOpsSpeedBuild+":");
		FI.Col();
		FI.AddInput(Math.round((m_OpsSpeedBuild*100)/256).toString(),4,true,0);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagRelGlobalOff)!=0,Common.TxtEdit.MapChangeOpsRelGloablOff);

		FI.TabAdd("page 3");

		FI.AddLabel(Common.TxtEdit.MapChangeOpsRestartCooldown+":");
		FI.Col();
		FI.AddInput(m_OpsRestartCooldown.toString(),6,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsStartTime+":");
		FI.Col();
		FI.AddInput(m_OpsStartTime.toString(),6,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsPulsarActive+":");
		FI.Col();
		FI.AddInput(m_OpsPulsarActive.toString(),3,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsPulsarPassive+":");
		FI.Col();
		FI.AddInput(m_OpsPulsarPassive.toString(),3,true,0);
		
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagPulsarEnterActive)!=0,Common.TxtEdit.MapChangeOpsPulsarEnterActive);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagNeutralBuild)!=0,Common.TxtEdit.MapChangeOpsNeutralBuild);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagKlingBuild)!=0,Common.TxtEdit.MapChangeOpsKlingBuild);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagWormholeLong) != 0, Common.TxtEdit.MapChangeOpsWormholeLong);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagWormholeFast) != 0, Common.TxtEdit.MapChangeOpsWormholeFast);
		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagWormholeRoam) != 0, Common.TxtEdit.MapChangeOpsWormholeRoam);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagEnclave) != 0, Common.TxtEdit.MapChangeOpsEnclave);

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagPlanetShield) != 0, Common.TxtEdit.MapChangeOpsPlanetShield);
		
		FI.AddLabel(Common.TxtEdit.MapChangeOpsTeamOwner+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem("---",-1,m_OpsTeamOwner==-1);
		for(i=0;i<(1<<Common.TeamMaxShift);i++) {
			FI.AddItem(String.fromCharCode(65+i),i,i==m_OpsTeamOwner);
		}

		FI.AddLabel(Common.TxtEdit.MapChangeOpsTeamEnemy+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem("---",-1,m_OpsTeamEnemy==-1);
		for(i=0;i<(1<<Common.TeamMaxShift);i++) {
			FI.AddItem(String.fromCharCode(65+i),i,i==m_OpsTeamEnemy);
		}

		FI.TabAdd("page 4");

		FI.AddCheckBox((m_OpsFlag & Common.OpsFlagPlayerExp) != 0, Common.TxtEdit.MapChangeOpsPlayerExp);
		
		FI.AddLabel(Common.TxtEdit.MapChangeOpsWin+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.MapChangeOpsWinOccupyCitadel,0,(m_OpsFlag & Common.OpsFlagWinMask)==Common.OpsFlagWinOccupyHomeworld);
		FI.AddItem(Common.TxtEdit.MapChangeOpsWinMaxPlanet,1,(m_OpsFlag & Common.OpsFlagWinMask)==Common.OpsFlagWinMaxPlanet);
//			FI.AddItem(Common.TxtEdit.MapChangeOpsWinScore, 2, (m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinScore);
		FI.AddItem(Common.TxtEdit.MapChangeOpsWinCtrlCitadel, 3, (m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinCtrlCitadel);
		FI.AddItem(Common.TxtEdit.MapChangeOpsWinMaxEnclave,4,(m_OpsFlag & Common.OpsFlagWinMask)==Common.OpsFlagWinMaxEnclave);
		
		FI.AddLabel(Common.TxtEdit.MapChangeOpsWinScore+":");
		FI.Col();
		FI.AddInput(m_OpsWinScore.toString(), 9, true, 0);
		
		FI.AddLabel(Common.TxtEdit.MapChangeOpsRestartCooldown+":");
		FI.Col();
		FI.AddInput(m_OpsProtectCooldown.toString(),6,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsRewardExp+":");
		FI.Col();
		FI.AddInput(m_OpsRewardExp.toString(),6,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsMaxRating+":");
		FI.Col();
		FI.AddInput(m_OpsMaxRating.toString(),6,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsPriceEnterType+":");
		FI.AddComboBox();
		for(i=0;i<Common.OpsPriceTypeCnt;i++) {
			FI.AddItem(Common.OpsPriceTypeName[i],i,i==m_OpsPriceEnterType);
		}
		FI.Col();
		FI.AddInput(m_OpsPriceEnter.toString(),8,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsPriceCaptureType+":");
		FI.AddComboBox();
		for(i=0;i<Common.OpsPriceTypeCnt;i++) {
			FI.AddItem(Common.OpsPriceTypeName[i],i,i==m_OpsPriceCaptureType);
		}
		FI.Col();
		FI.AddInput(m_OpsPriceCapture.toString(),8,true,0);

		FI.AddLabel(Common.TxtEdit.MapChangeOpsPriceCaptureEgm + ":");
		FI.Col();
		FI.AddInput(m_OpsPriceCaptureEgm.toString(),8,true,0);

		if (CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditOps) FI.Run(EditMapChangeOptionsSend, Common.TxtEdit.ButEdit, StdMap.Txt.ButCancel);
		else FI.Run(null, null, StdMap.Txt.ButCancel);
	}

	public function EditMapChangeOptionsSend():void
	{
		var cur:int=0;

		var flag:uint=0;

		if(FI.GetInt(cur)) flag|=Common.OpsFlagEnterShip;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagEnterFlagship;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagEnterTransport;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagEnterSingleInvader;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagLeaveShip;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagLeaveFlagship;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagLeaveTransport;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagBuildShip;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagBuildFlagship;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagBuildWarBase;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagBuildSciBase;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagBuildShipyard;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagItemToHyperspace;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagBuilding;
		cur++;

		if(FI.GetInt(cur)) flag|=Common.OpsFlagViewAll;
		cur++;

		var jr:int = FI.GetInt(cur);
		cur++;
		var modulemul:int = FI.GetInt(cur);
		cur++;
		var costbuildlvl:int = 0;// Math.floor((FI.GetInt(cur) * 256) / 100);
		//cur++;
		var speedcapture:int=FI.GetInt(cur);//Math.floor((FI.GetInt(cur)*256)/100);
		cur++;
		var speedbuild:int=Math.floor((FI.GetInt(cur)*256)/100);
		cur++;

		if(FI.GetInt(cur)) flag|=Common.OpsFlagRelGlobalOff;
		cur++;

		var restartcooldown:int=FI.GetInt(cur);
		cur++;
		var starttime:int=FI.GetInt(cur);
		cur++;
		var pulsaractive:int=FI.GetInt(cur);
		cur++;
		var pulsarpassive:int=FI.GetInt(cur);
		cur++;

		if(FI.GetInt(cur)) flag|=Common.OpsFlagPulsarEnterActive;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagNeutralBuild;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagKlingBuild;
		cur++;
		
		if(FI.GetInt(cur)) flag|=Common.OpsFlagWormholeLong;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagWormholeFast;
		cur++;
		if(FI.GetInt(cur)) flag|=Common.OpsFlagWormholeRoam;
		cur++;

		if(FI.GetInt(cur)) flag|=Common.OpsFlagEnclave;
		cur++;

		if(FI.GetInt(cur)) flag|=Common.OpsFlagPlanetShield;
		cur++;

		var teamowner:int=FI.GetInt(cur);
		cur++;
		var teamenemy:int=FI.GetInt(cur);
		cur++;

		if(FI.GetInt(cur)) flag|=Common.OpsFlagPlayerExp;
		cur++;

		var wint:int=FI.GetInt(cur);
		cur++;
		if (wint == 0) flag |= Common.OpsFlagWinOccupyHomeworld;
		else if (wint == 1) flag |= Common.OpsFlagWinMaxPlanet;
//			else if (wint == 2) flag |= Common.OpsFlagWinScore;
		else if (wint == 3) flag |= Common.OpsFlagWinCtrlCitadel;
		else if (wint == 4) flag |= Common.OpsFlagWinMaxEnclave;

		var winscore:int=FI.GetInt(cur);
		cur++;
		var protectcooldown:int = FI.GetInt(cur);
		cur++;
		var rewardexp:int=FI.GetInt(cur);
		cur++;
		var maxrating:int=FI.GetInt(cur);
		cur++;
		var priceentertype:int=FI.GetInt(cur);
		cur++;
		var priceenter:int=FI.GetInt(cur);
		cur++;
		var pricecapturetype:int=FI.GetInt(cur);
		cur++;
		var pricecapture:int=FI.GetInt(cur);
		cur++;
		var pricecapture_egm:int=FI.GetInt(cur);
		cur++;

		Server.Self.Query("emedcotlspecial", "&type=13&val=" + flag.toString(16) + "_ffffffff"
			+"_" + jr.toString()
			+"_" + modulemul.toString()
			+"_" + costbuildlvl.toString()
			+"_" + speedcapture.toString()
			+"_" + speedbuild.toString()
			+"_" + restartcooldown.toString()
			+"_" + starttime.toString()
			+"_" + pulsaractive.toString()
			+"_" + pulsarpassive.toString()
			+"_" + rewardexp.toString()
			+"_" + maxrating.toString()
			+"_" + priceentertype.toString()
			+"_" + priceenter.toString()
			+"_" + pricecapturetype.toString()
			+"_" + pricecapture.toString()
			+"_" + pricecapture_egm.toString()
			+"_" + teamowner.toString()
			+"_" + teamenemy.toString()
			+"_" + winscore.toString()
			+"_" + protectcooldown.toString()
			,EditMapChangeSizeRecv,false);
	}

	public function EditMapChangeOptionsEx(...args):void
	{
		var py:int, px:int, i:int, u:int, k:int;
		var user:User;
		var str:String = "";

		str += "EnterShip=" + ((m_OpsFlag & Common.OpsFlagEnterShip) != 0).toString()+"\n";
		str += "EnterFlagship=" + ((m_OpsFlag & Common.OpsFlagEnterFlagship) != 0).toString() + "\n";
		str += "EnterTransport=" + ((m_OpsFlag & Common.OpsFlagEnterTransport) != 0).toString() + "\n";
		str += "EnterSingleInvader="+((m_OpsFlag & Common.OpsFlagEnterSingleInvader)!=0).toString()+"\n";
		str += "LeaveShip=" + ((m_OpsFlag & Common.OpsFlagLeaveShip) != 0).toString()+"\n";
		str += "LeaveFlagship=" + ((m_OpsFlag & Common.OpsFlagLeaveFlagship) != 0).toString()+"\n";
		str += "LeaveTransport=" + ((m_OpsFlag & Common.OpsFlagLeaveTransport) != 0).toString() + "\n";

		str += "\n";

		str += "BuildShip=" + ((m_OpsFlag & Common.OpsFlagBuildShip) != 0).toString() + "\n";
		str += "BuildFlagship=" + ((m_OpsFlag & Common.OpsFlagBuildFlagship) != 0).toString() + "\n";
		str += "BuildWarBase=" + ((m_OpsFlag & Common.OpsFlagBuildWarBase) != 0).toString() + "\n";
		str += "BuildSciBase=" + ((m_OpsFlag & Common.OpsFlagBuildSciBase) != 0).toString() + "\n";
		str += "BuildShipyard=" + ((m_OpsFlag & Common.OpsFlagBuildShipyard) != 0).toString() + "\n";

		str += "\n";

		str += "ItemToHyperspace=" + ((m_OpsFlag & Common.OpsFlagItemToHyperspace) != 0).toString() + "\n";
		str += "Building=" + ((m_OpsFlag & Common.OpsFlagBuilding) != 0).toString() + "\n";
		str += "ViewAll=" + ((m_OpsFlag & Common.OpsFlagViewAll) != 0).toString()+"\n";
		str += "JumpRadius=" + m_OpsJumpRadius.toString() + "\n";
		str += "ModuleMul=" + m_OpsModuleMul.toString() + "\n";
		//str += "CostBuildLvl=" + Math.round((m_OpsCostBuildLvl*100)/256).toString()+"\n";
		str += "SpeedCapture=" + m_OpsSpeedCapture.toString() + "\n";
		str += "SpeedBuild=" + Math.round((m_OpsSpeedBuild*100)/256).toString()+"\n";

		str += "\n";

		str += "RestartCooldown=" + m_OpsRestartCooldown.toString() + "\n";
		str += "StartTime=" + m_OpsStartTime.toString() + "\n";
		str += "PulsarActive=" + m_OpsPulsarActive.toString() + "\n";
		str += "PulsarPassive=" + m_OpsPulsarPassive.toString() + "\n";

		str += "\n";

		str += "RelGlobalOff=" + ((m_OpsFlag & Common.OpsFlagRelGlobalOff) != 0).toString() + "\n";
		str += "PulsarEnterActive=" + ((m_OpsFlag & Common.OpsFlagPulsarEnterActive) != 0).toString() + "\n";
		str += "NeutralBuild=" + ((m_OpsFlag & Common.OpsFlagNeutralBuild) != 0).toString() + "\n";
		str += "KlingBuild=" + ((m_OpsFlag & Common.OpsFlagKlingBuild) != 0).toString() + "\n";
		str += "WormholeLong=" + ((m_OpsFlag & Common.OpsFlagWormholeLong) != 0).toString() + "\n";
		str += "WormholeFast=" + ((m_OpsFlag & Common.OpsFlagWormholeFast) != 0).toString() + "\n";
		str += "WormholeRoam=" + ((m_OpsFlag & Common.OpsFlagWormholeRoam) != 0).toString() + "\n";
		str += "Enclave=" + ((m_OpsFlag & Common.OpsFlagEnclave) != 0).toString() + "\n";
		str += "PlanetShield=" + ((m_OpsFlag & Common.OpsFlagPlanetShield) != 0).toString() + "\n";

		str += "TeamOwner=" + m_OpsTeamOwner.toString() + "\n";
		str += "TeamEnemy=" + m_OpsTeamEnemy.toString() + "\n";

		str += "\n";

		if ((m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinOccupyHomeworld) str += "WinType=OccupyHomeworld\n";
		else if ((m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinMaxPlanet) str += "WinType=MaxPlanet\n";
//			else if ((m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinScore) str += "WinType=Score\n";
		else if ((m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinCtrlCitadel) str += "WinType=CtrlCitadel\n";
		else if ((m_OpsFlag & Common.OpsFlagWinMask) == Common.OpsFlagWinMaxEnclave) str += "WinType=MaxEnclave\n";
		else str += "WinType=None\n";

		str += "PlayerExp=" + ((m_OpsFlag & Common.OpsFlagPlayerExp) != 0).toString() + "\n";
		str += "WinScore=" + (m_OpsWinScore).toString() + "\n";
		str += "ProtectCooldown=" + (m_OpsProtectCooldown).toString() + "\n";
		str += "RewardExp=" + (m_OpsRewardExp).toString() + "\n";
		str += "MaxRating=" + (m_OpsMaxRating).toString() + "\n";
		str += "PriceEnter=" + Common.OpsPriceTypeNameSys[m_OpsPriceEnterType].toString() +"," + m_OpsPriceEnter.toString() + "\n";
		str += "PriceCapture=" + Common.OpsPriceTypeNameSys[m_OpsPriceCaptureType].toString() +"," + m_OpsPriceCapture.toString() + "\n";
		str += "PriceCaptureEgm=" + (m_OpsPriceCaptureEgm).toString() + "\n";

		str += "\n";

		var cntcell:int=1<<Common.TeamMaxShift;
		for (py = 0; py < cntcell; py++) {
			str += "TeamRel"+String.fromCharCode(65+py)+"=";
			for(px=0;px<cntcell;px++) {
				str+=(m_TeamRel[px+py*cntcell]).toString();

			}
			str += "\n";
		}

		str += "\n";

		for (i = 0; i < 4; i++) {
			user = UserList.Self.GetUser(Common.OwnerAI0 + i);
			if (user == null) throw Error("Err");

			str += "(AI"+i.toString()+")\n";

			if (i == 0 && Txt_CotlOwnerName(Server.Self.m_CotlId, user.m_Id) == Common.TxtEdit.OwnerAI0)  str += "Name=\n";
			else if (i == 1 && Txt_CotlOwnerName(Server.Self.m_CotlId, user.m_Id) == Common.TxtEdit.OwnerAI1)  str += "Name=\n";
			else if (i == 2 && Txt_CotlOwnerName(Server.Self.m_CotlId, user.m_Id) == Common.TxtEdit.OwnerAI2)  str += "Name=\n";
			else if (i == 3 && Txt_CotlOwnerName(Server.Self.m_CotlId, user.m_Id) == Common.TxtEdit.OwnerAI3)  str += "Name=\n";
			else str += "Name=" + Txt_CotlOwnerName(Server.Self.m_CotlId, user.m_Id) + "\n";
			str += "Team=" + user.m_Team.toString() + "\n";
			str += "Race=" + Common.RaceSysName[user.m_Race] + "\n";
			str += "PowerMul=" + Math.round(user.m_PowerMul * 100 / 256).toString() + "\n";
			str += "ManufMul=" + Math.round(user.m_ManufMul * 100 / 256).toString() + "\n";
			//str += "AutoProgress=" + ((user.m_Flag & Common.UserFlagAutoProgress) != 0).toString() + "\n";
			str += "PlayerControl=" + ((user.m_Flag & Common.UserFlagPlayerControl) != 0).toString() + "\n";
			str += "VisAll=" + ((user.m_Flag & Common.UserFlagVisAll) != 0).toString() + "\n";
			str += "ImportIfEnemy=" + ((user.m_Flag & Common.UserFlagImportIfEnemy) != 0).toString() + "\n";

			for (u = 0; u < Common.TechCnt; u++) {
				if (u == Common.TechProgress) str += "TechProgress=";
				else if (u == Common.TechEconomy) str += "TechEconomy=";
				else if (u == Common.TechTransport) str += "TechTransport=";
				else if (u == Common.TechCorvette) str += "TechCorvette=";
				else if (u == Common.TechCruiser) str += "TechCruiser=";
				else if (u == Common.TechDreadnought) str += "TechDreadnought=";
				else if (u == Common.TechInvader) str += "TechInvader=";
				else if (u == Common.TechDevastator) str += "TechDevastator=";
				else if (u == Common.TechWarBase) str += "TechWarBase=";
				else if (u == Common.TechShipyard) str += "TechShipyard=";
				else if (u == Common.TechSciBase) str += "TechSciBase=";
				else if (u == Common.TechQuarkBase) str += "TechQuarkBase=";
				else throw Error("Err");

				for (k = 0; k < 32; k++) {
					if ((user.m_Tech[u] & (1 << k)) != 0) str += "1";
					else str += "0";
				}

				str += "\n";
			}

			str += "\n";
		}

		FI.Init(480,550);
		FI.caption = Common.TxtEdit.MapChangeOptions;

		FI.AddCode(str, 60000, true, Server.Self.m_Lang, true).heightMin = 400;

		if (CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditOps) FI.Run(EditMapChangeOptionsExSend, Common.TxtEdit.ButEdit, StdMap.Txt.ButCancel);
		else FI.Run(null, null, StdMap.Txt.ButCancel);
	}

	public function StrToBool(src:String):Boolean
	{
		if (src == null) return false;
		
		var ch:int;
		var sme:int = 0;
		var len:int = src.length;
		
		while (sme < len) {
			ch=src.charCodeAt(sme);
			if (ch == 32 || ch == 9 || ch == 0x0d || ch == 0x0a) {
				sme++;
				continue;
			}
			break;
		}
		
		while (len > sme) {
			ch=src.charCodeAt(len-1);
			if (ch == 32 || ch == 9 || ch == 0x0d || ch == 0x0a) {
				len--;
				continue;
			}
			break;
		}
		
		if (sme >= len) return false;

		if (BaseStr.IsTagEq(src, sme, len - sme, "true", "TRUE")) return true;
		if (BaseStr.IsTagEq(src, sme, len - sme, "1", "1")) return true;
		return false;
	}

	public function EditMapChangeOptionsExSend():void
	{
		var src:String = FI.GetStr(0);
		
		var start:int,num:int,i:int,ots:int,off:int,u:int,k:int;
		var sme:int=0;
		var srclen:int=src.length;
		var ch:int;
		var name:String,val:String;
		var out:String="";

		var user:User = null;
		var cu:Object = null;
		var userlist:Array = new Array();

		var teamcnt:int = 1 << Common.TeamMaxShift;
		
		var teamrel:Array = new Array(teamcnt * teamcnt);
		for (i = 0; i < teamcnt * teamcnt; i++) teamrel[i] = 0;
		var teamrelset:Boolean = false;
		
		var flag:uint = 0;
		var flagset:uint = 0;
		var jr:int = -1;
		var modulemul:int = -1;
		var costbuildlvl:int = -1;
		var speedcapture:int = -1;
		var speedbuild:int = -1;
		var restartcooldown:int = -1;
		var starttime:int = -1;
		var pulsaractive:int = -1;
		var pulsarpassive:int = -1;
		var teamowner:int = -2;
		var teamenemy:int = -2;
		var winscore:int = -1;
		var protectcooldown:int = -1;
		var rewardexp:int = -1;
		var maxrating:int = -1;
		var priceentertype:int = -1;
		var priceenter:int = -1;
		var pricecapturetype:int = -1;
		var pricecapture:int = -1;
		var pricecapture_egm:int = -1;

		while(true) {
			if(sme>=srclen) {
				break;
			}
			ch=src.charCodeAt(sme);
			sme++;

			if(ch==32 || ch==9 || ch==0x0d || ch==0x0a) continue;
			if(ch==40) { // (
				start=sme;
				while(sme<srclen) {
					ch=src.charCodeAt(sme);
					sme++;
					if(ch==41) break; // )
				}
				name=src.substring(start,sme-1);
				
				if(BaseStr.IsTagEq(name,0,name.length,"ai0","AI0")) {
					user = UserList.Self.GetUser(Common.OwnerAI0);
					if (user == null) throw Error("ai0");
					cu = new Object();
					cu.Id = user.m_Id;
					userlist.push(cu);
				} else if(BaseStr.IsTagEq(name,0,name.length,"ai1","AI1")) {
					user = UserList.Self.GetUser(Common.OwnerAI1);
					if (user == null) throw Error("ai1");
					cu = new Object();
					cu.Id = user.m_Id;
					userlist.push(cu);
				} else if(BaseStr.IsTagEq(name,0,name.length,"ai2","AI2")) {
					user = UserList.Self.GetUser(Common.OwnerAI2);
					if (user == null) throw Error("ai2");
					cu = new Object();
					cu.Id = user.m_Id;
					userlist.push(cu);
				} else if(BaseStr.IsTagEq(name,0,name.length,"ai3","AI3")) {
					user = UserList.Self.GetUser(Common.OwnerAI3);
					if (user == null) throw Error("ai3");
					cu = new Object();
					cu.Id = user.m_Id;
					userlist.push(cu);
				}
//trace("user:",user.m_Id.toString(16));

				continue;
			}
			
			start=sme-1;
			while(sme<srclen) {
				ch=src.charCodeAt(sme);
				if(ch==61) break; // =
				sme++;
			}
			if(sme>=srclen) break;
			
			name=src.substring(start,sme);
			sme++;

			start=sme;
			while(sme<srclen) {
				ch=src.charCodeAt(sme);
				if(ch==0x0d || ch==0x0a) break; // \n
				sme++;
			}
			
			val=src.substring(start,sme);
//trace(name+"="+val+"  "+name.length.toString()+"   "+val.length.toString());
			
			if (BaseStr.IsTagEq(name, 0, name.length, "entership", "ENTERSHIP")) { if (StrToBool(val)) flag |= Common.OpsFlagEnterShip; flagset |= Common.OpsFlagEnterShip; }
			if (BaseStr.IsTagEq(name, 0, name.length, "enterflagship", "ENTERFLAGSHIP")) { if (StrToBool(val)) flag |= Common.OpsFlagEnterFlagship; flagset |= Common.OpsFlagEnterFlagship; }
			if (BaseStr.IsTagEq(name, 0, name.length, "entertransport", "ENTERTRANSPORT")) { if (StrToBool(val)) flag |= Common.OpsFlagEnterTransport; flagset |= Common.OpsFlagEnterTransport; }
			if (BaseStr.IsTagEq(name, 0, name.length, "entersingleinvader", "ENTERSINGLEINVADER")) { if (StrToBool(val)) flag |= Common.OpsFlagEnterSingleInvader; flagset |= Common.OpsFlagEnterSingleInvader; }
			if (BaseStr.IsTagEq(name, 0, name.length, "leaveship", "LEAVESHIP")) { if (StrToBool(val)) flag |= Common.OpsFlagLeaveShip; flagset |= Common.OpsFlagLeaveShip; }
			if (BaseStr.IsTagEq(name, 0, name.length, "leaveflagship", "LEAVEFLAGSHIP")) { if (StrToBool(val)) flag |= Common.OpsFlagLeaveFlagship; flagset |= Common.OpsFlagLeaveFlagship; }
			if (BaseStr.IsTagEq(name, 0, name.length, "leavetransport", "LEAVETRANSPORT")) { if (StrToBool(val)) flag |= Common.OpsFlagLeaveTransport; flagset |= Common.OpsFlagLeaveTransport; }
			
			if (BaseStr.IsTagEq(name, 0, name.length, "buildship", "BUILDSHIP")) { if (StrToBool(val)) flag |= Common.OpsFlagBuildShip; flagset |= Common.OpsFlagBuildShip; }
			if (BaseStr.IsTagEq(name, 0, name.length, "buildwarbase", "BUILDWARBASE")) { if (StrToBool(val)) flag |= Common.OpsFlagBuildWarBase; flagset |= Common.OpsFlagBuildWarBase; }
			if (BaseStr.IsTagEq(name, 0, name.length, "buildscibase", "BUILDSCIBASE")) { if (StrToBool(val)) flag |= Common.OpsFlagBuildSciBase; flagset |= Common.OpsFlagBuildSciBase; }
			if (BaseStr.IsTagEq(name, 0, name.length, "buildshipyard", "BUILDSHIPYARD")) { if (StrToBool(val)) flag |= Common.OpsFlagBuildShipyard; flagset |= Common.OpsFlagBuildShipyard; }

			if (BaseStr.IsTagEq(name, 0, name.length, "itemtohyperspace", "ITEMTOHYPERSPACE")) { if (StrToBool(val)) flag |= Common.OpsFlagItemToHyperspace; flagset |= Common.OpsFlagItemToHyperspace; }
			if (BaseStr.IsTagEq(name, 0, name.length, "building", "BUILDING")) { if (StrToBool(val)) flag |= Common.OpsFlagBuilding; flagset |= Common.OpsFlagBuilding; }
			if (BaseStr.IsTagEq(name, 0, name.length, "viewall", "VIEWALL")) { if (StrToBool(val)) flag |= Common.OpsFlagViewAll; flagset |= Common.OpsFlagViewAll; }
			if (BaseStr.IsTagEq(name, 0, name.length, "jumpradius", "JumpRadius")) { jr = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "modulemul", "MODULEMUL")) { modulemul = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "costbuildlvl", "COSTBUILDLVL")) { costbuildlvl = Math.floor((int(val)*256)/100); }
			if (BaseStr.IsTagEq(name, 0, name.length, "speedcapture", "SPEEDCAPTURE")) { speedcapture = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "speedbuild", "SPEEDBUILD")) { speedbuild = Math.floor((int(val)*256)/100); }

			if (BaseStr.IsTagEq(name, 0, name.length, "restartcooldown", "RESTARTCOOLDOWN")) { restartcooldown = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "starttime", "STARTTIME")) { starttime = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "pulsaractive", "PULSARACTIVE")) { pulsaractive = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "pulsarpassive", "PULSARPASSIVE")) { pulsarpassive = int(val); }

			if (BaseStr.IsTagEq(name, 0, name.length, "relglobaloff", "RELGLOBALOFF")) { if (StrToBool(val)) flag |= Common.OpsFlagRelGlobalOff; flagset |= Common.OpsFlagRelGlobalOff; }
			if (BaseStr.IsTagEq(name, 0, name.length, "pulsarenteractive", "PULSARENTERACTIVE")) { if (StrToBool(val)) flag |= Common.OpsFlagPulsarEnterActive; flagset |= Common.OpsFlagPulsarEnterActive; }
			if (BaseStr.IsTagEq(name, 0, name.length, "neutralbuild", "NEUTRALBUILD")) { if (StrToBool(val)) flag |= Common.OpsFlagNeutralBuild; flagset |= Common.OpsFlagNeutralBuild; }
			if (BaseStr.IsTagEq(name, 0, name.length, "klingbuild", "KLINGBUILD")) { if (StrToBool(val)) flag |= Common.OpsFlagKlingBuild; flagset |= Common.OpsFlagKlingBuild; }
			if (BaseStr.IsTagEq(name, 0, name.length, "wormholelong", "WORMHOLELONG")) { if (StrToBool(val)) flag |= Common.OpsFlagWormholeLong; flagset |= Common.OpsFlagWormholeLong; }
			if (BaseStr.IsTagEq(name, 0, name.length, "wormholefast", "WORMHOLEFAST")) { if (StrToBool(val)) flag |= Common.OpsFlagWormholeFast; flagset |= Common.OpsFlagWormholeFast; }
			if (BaseStr.IsTagEq(name, 0, name.length, "wormholeroam", "WORMHOLEROAM")) { if (StrToBool(val)) flag |= Common.OpsFlagWormholeRoam; flagset |= Common.OpsFlagWormholeRoam; }
			if (BaseStr.IsTagEq(name, 0, name.length, "enclave", "ENCLAVE")) { if (StrToBool(val)) flag |= Common.OpsFlagEnclave; flagset |= Common.OpsFlagEnclave; }
			if (BaseStr.IsTagEq(name, 0, name.length, "planetshield", "PLANETSHIELD")) { if (StrToBool(val)) flag |= Common.OpsFlagPlanetShield; flagset |= Common.OpsFlagPlanetShield; }

			if (BaseStr.IsTagEq(name, 0, name.length, "teamowner", "TEAMOWNER")) { teamowner = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "teamenemy", "TEAMENEMY")) { teamenemy = int(val); }

			if (BaseStr.IsTagEq(name, 0, name.length, "wintype", "WINTYPE")) {
				if (BaseStr.IsTagEq(val, 0, val.length, "occupyhomeworld", "OCCUPYHOMEWORLD")) { flag |= Common.OpsFlagWinOccupyHomeworld; flagset |= Common.OpsFlagWinMask; }
				else if (BaseStr.IsTagEq(val, 0, val.length, "maxplanet", "MAXPLANET")) { flag |= Common.OpsFlagWinMaxPlanet; flagset |= Common.OpsFlagWinMask; }
//					else if (BaseStr.IsTagEq(val, 0, val.length, "score", "SCORE")) { flag |= Common.OpsFlagWinScore; flagset |= Common.OpsFlagWinMask; }
				else if (BaseStr.IsTagEq(val, 0, val.length, "ctrlcitadel", "CTRLCITADEL")) { flag |= Common.OpsFlagWinCtrlCitadel; flagset |= Common.OpsFlagWinMask; }
				else if (BaseStr.IsTagEq(val, 0, val.length, "maxenclave", "MAXENCLAVE")) { flag |= Common.OpsFlagWinMaxEnclave; flagset |= Common.OpsFlagWinMask; }
				else if(BaseStr.IsTagEq(val, 0, val.length, "none", "NONE")) { flagset |= Common.OpsFlagWinOccupyHomeworld|Common.OpsFlagWinMaxPlanet|Common.OpsFlagWinMask; }
			}

			if (BaseStr.IsTagEq(name, 0, name.length, "playerexp", "PLAYEREXP")) { if (StrToBool(val)) flag |= Common.OpsFlagPlayerExp; flagset |= Common.OpsFlagPlayerExp; }
			if (BaseStr.IsTagEq(name, 0, name.length, "winscore", "WINSCORE")) { winscore = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "protectcooldown", "PROTECTCOOLDOWN")) { protectcooldown = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "rewardexp", "REWARDEXP")) { rewardexp = int(val); }
			if (BaseStr.IsTagEq(name, 0, name.length, "maxrating", "MAXRATING")) { maxrating = int(val); }

			if (BaseStr.IsTagEq(name, 0, name.length, "priceenter", "PRICEENTER")) { 
				off = val.indexOf(",");
				if (off > 0) {
					for (i = 0; i < Common.OpsPriceTypeName.length; i++) {
						if (BaseStr.IsTagEqNCEng(val, 0, off, Common.OpsPriceTypeNameSys[i])) { priceentertype = i; break; }
					}
					priceenter = int(val.substring(off + 1));
				}
			}

			if (BaseStr.IsTagEq(name, 0, name.length, "pricecapture", "PRICECAPTURE")) { 
				off = val.indexOf(",");
				if (off > 0) {
					for (i = 0; i < Common.OpsPriceTypeName.length; i++) {
						if (BaseStr.IsTagEqNCEng(val, 0, off, Common.OpsPriceTypeNameSys[i])) { pricecapturetype = i; break; }
					}
					pricecapture = int(val.substring(off + 1));
				}
			}

			if (BaseStr.IsTagEqNCEng(name, 0, name.length, "PriceCaptureEgm")) { pricecapture_egm = int(val); }
			
			for (i = 0; i < teamcnt; i++) {
				if (BaseStr.IsTagEqNCEng(name, 0, name.length, "TeamRel" + String.fromCharCode(65 + i))) {
					for (u = 0; u < Math.min(teamcnt, val.length); u++) {
						k = val.charCodeAt(u);
						if (k == 48) teamrel[i * teamcnt + u] = 0;
						else if (k == 49) teamrel[i * teamcnt + u] = 1;
						else if (k == 50) teamrel[i * teamcnt + u] = 2;
					}
					teamrelset = true;
					break;
				}
			}
			
			if (user != null && BaseStr.IsTagEqNCEng(name, 0, name.length, "Name")) cu.Name = val;
			if (user != null && BaseStr.IsTagEqNCEng(name, 0, name.length, "Team")) cu.Team = int(val);
			if (user != null && BaseStr.IsTagEqNCEng(name, 0, name.length, "PowerMul")) cu.PowerMul = Math.round(int(val) * 256 / 100);
			if (user != null && BaseStr.IsTagEqNCEng(name, 0, name.length, "ManufMul")) cu.ManufMul = int(val);
			if (user != null && BaseStr.IsTagEqNCEng(name, 0, name.length, "Race")) {
				for (i = 0; i < Common.RaceSysName.length; i++) {
					if (BaseStr.IsTagEqNCEng(val, 0, val.length, Common.RaceSysName[i])) { cu.Race = i; break; }
				}
			}
			if (user != null && BaseStr.IsTagEqNCEng(name, 0, name.length, "AutoProgress")) cu.AutoProgress = StrToBool(val);
			if (user != null && BaseStr.IsTagEqNCEng(name, 0, name.length, "PlayerControl")) cu.PlayerControl = StrToBool(val);
			if (user != null && BaseStr.IsTagEqNCEng(name, 0, name.length, "VisAll")) cu.VisAll = StrToBool(val);

			if (user != null) {
				for (i = 0; i < Common.TechCnt; i++) {
					if (i == Common.TechProgress && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechProgress")) {}
					else if (i == Common.TechEconomy && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechEconomy")) {}
					else if (i == Common.TechTransport && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechTransport")) {}
					else if (i == Common.TechCorvette && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechCorvette")) {}
					else if (i == Common.TechCruiser && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechCruiser")) {}
					else if (i == Common.TechDreadnought && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechDreadnought")) {}
					else if (i == Common.TechInvader && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechInvader")) {}
					else if (i == Common.TechDevastator && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechDevastator")) {}
					else if (i == Common.TechWarBase && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechWarBase")) {}
					else if (i == Common.TechShipyard && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechShipyard")) {}
					else if (i == Common.TechSciBase && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechSciBase")) { }
					else if (i == Common.TechQuarkBase && BaseStr.IsTagEqNCEng(name, 0, name.length, "TechQuarkBase")) { }
					else continue;

					var tech:uint = 0;
					for (u = 0; u < Math.min(32, val.length); u++) {
						if (val.charCodeAt(u) == 49) tech |= 1 << u;
					}
					
					if (i == Common.TechProgress) cu.TechProgress = tech;
					else if (i == Common.TechEconomy) cu.TechEconomy = tech;
					else if (i == Common.TechTransport) cu.TechTransport = tech;
					else if (i == Common.TechCorvette) cu.TechCorvette = tech;
					else if (i == Common.TechCruiser) cu.TechCruiser = tech;
					else if (i == Common.TechDreadnought) cu.TechDreadnought = tech;
					else if (i == Common.TechInvader) cu.TechInvader = tech;
					else if (i == Common.TechDevastator) cu.TechDevastator = tech;
					else if (i == Common.TechWarBase) cu.TechWarBase = tech;
					else if (i == Common.TechShipyard) cu.TechShipyard = tech;
					else if (i == Common.TechSciBase) cu.TechSciBase = tech;
					else if (i == Common.TechQuarkBase) cu.TechQuarkBase = tech;
				}
			}
		}
		
		Server.Self.Query("emedcotlspecial", "&type=13&val=" + flag.toString(16) +"_" + flagset.toString(16)
			+"_" + jr.toString()
			+"_" + modulemul.toString()
			+"_" + costbuildlvl.toString()
			+"_" + speedcapture.toString()
			+"_" + speedbuild.toString()
			+"_" + restartcooldown.toString()
			+"_" + starttime.toString()
			+"_" + pulsaractive.toString()
			+"_" + pulsarpassive.toString()
			+"_" + rewardexp.toString()
			+"_" + maxrating.toString()
			+"_" + priceentertype.toString()
			+"_" + priceenter.toString()
			+"_" + pricecapturetype.toString()
			+"_" + pricecapture.toString()
			+"_" + pricecapture_egm.toString()
			+"_" + teamowner.toString()
			+"_" + teamenemy.toString()
			+"_" + winscore.toString()
			+"_" + protectcooldown.toString()
			,EditMapChangeSizeRecv, false);
			
		if (teamrelset) {
			val = "";
			for(i=0;i<teamcnt*teamcnt;i++) {
				m_TeamRel[i]=teamrel[i];
				val+=teamrel[i].toString();
			}
			Server.Self.Query("emedcotlspecial", "&type=16&val=" + val, EditMapChangeSizeRecv, false);
		}
		
		for (i = 0; i < userlist.length; i++) {
			cu = userlist[i];
			
			var tstr:String;
			var boundary:String=Server.Self.CreateBoundary();

			user=UserList.Self.GetUser(cu.Id);
			if (user == null) continue;

			if (cu.Team != undefined) user.m_Team = cu.Team;
			if (cu.Race != undefined) user.m_Race = cu.Race;
			if (cu.PowerMul != undefined) user.m_PowerMul = cu.PowerMul;
			if (cu.ManufMul != undefined) user.m_ManufMul = cu.ManufMul;
			if(cu.AutoProgress!=undefined) {
				user.m_Flag &= ~(Common.UserFlagAutoProgress);
				if (cu.AutoProgress) user.m_Flag |= Common.UserFlagAutoProgress;
			}
			if(cu.PlayerControl!=undefined) {
				user.m_Flag &= ~(Common.UserFlagPlayerControl);
				if (cu.PlayerControl) user.m_Flag |= Common.UserFlagPlayerControl;
			}
			if (cu.VisAll != undefined) {
				user.m_Flag &= ~(Common.UserFlagVisAll);
				if (cu.VisAll) user.m_Flag |= Common.UserFlagVisAll;
			}
			if (cu.ImportIfEnemy != undefined) {
				user.m_Flag &= ~(Common.UserFlagImportIfEnemy);
				if (cu.ImportIfEnemy) user.m_Flag |= Common.UserFlagImportIfEnemy;
			}

			var d:String="";

			if(cu.Name!=undefined) {
				d+="--"+boundary+"\r\n";
				d+="Content-Disposition: form-data; name=\"name\"\r\n\r\n";
				d+=cu.Name+"\r\n"
			}

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"team\"\r\n\r\n";
			d+=user.m_Team.toString()+"\r\n"

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"race\"\r\n\r\n";
			d += user.m_Race.toString() + "\r\n"

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"pmul\"\r\n\r\n";
			d += user.m_PowerMul.toString() + "\r\n"

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"mmul\"\r\n\r\n";
			d += user.m_ManufMul.toString() + "\r\n"

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"flag\"\r\n\r\n";
			d += (user.m_Flag & (Common.UserFlagAutoProgress | Common.UserFlagPlayerControl | Common.UserFlagVisAll | Common.UserFlagImportIfEnemy)).toString(16) + "\r\n"

			if (cu.TechProgress != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechProgress\"\r\n\r\n";
				d += cu.TechProgress.toString(16) + "\r\n"
//trace("TechProgress",cu.TechProgress.toString(16));
			}

			if (cu.TechEconomy != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechEconomy\"\r\n\r\n";
				d += cu.TechEconomy.toString(16) + "\r\n"
//trace("TechEconomy",cu.TechEconomy.toString(16));
			}

			if (cu.TechTransport != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechTransport\"\r\n\r\n";
				d += cu.TechTransport.toString(16) + "\r\n"
//trace("TechTransport",cu.TechTransport.toString(16));
			}

			if (cu.TechCorvette != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechCorvette\"\r\n\r\n";
				d += cu.TechCorvette.toString(16) + "\r\n"
			}

			if (cu.TechCruiser != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechCruiser\"\r\n\r\n";
				d += cu.TechCruiser.toString(16) + "\r\n"
			}

			if (cu.TechDreadnought != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechDreadnought\"\r\n\r\n";
				d += cu.TechDreadnought.toString(16) + "\r\n"
			}

			if (cu.TechInvader != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechInvader\"\r\n\r\n";
				d += cu.TechInvader.toString(16) + "\r\n"
			}

			if (cu.TechDevastator != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechDevastator\"\r\n\r\n";
				d += cu.TechDevastator.toString(16) + "\r\n"
			}

			if (cu.TechWarBase != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechWarBase\"\r\n\r\n";
				d += cu.TechWarBase.toString(16) + "\r\n"
			}

			if (cu.TechShipyard != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechShipyard\"\r\n\r\n";
				d += cu.TechShipyard.toString(16) + "\r\n"
			}

			if (cu.TechSciBase != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechSciBase\"\r\n\r\n";
				d += cu.TechSciBase.toString(16) + "\r\n"
			}

			if (cu.TechQuarkBase != undefined) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"TechQuarkBase\"\r\n\r\n";
				d += cu.TechQuarkBase.toString(16) + "\r\n"
			}

			d += "--" + boundary + "--\r\n";

			Server.Self.QueryPost("emedcotlspecial", "&type=12&id=" + cu.Id.toString(), d, boundary, EditMapChangePlanetNameAnswer, false);
		}
//			trace("flag:" + flag.toString(16));
//			trace("flagset:"+flagset.toString(16));
	}

	public function ConsumptionEditMap(...args):void
	{
		var i:int;
		var cb:CtrlComboBox;

		FI.Init(380, 300);
		FI.caption = Common.TxtEdit.ConsumptionCaption;

		cb = FI.AddComboBox(); cb.widthMin = 200; cb.current = Common.FillMenuItem(cb.menu, m_ConsumptionType[0]);
		FI.Col();
		FI.AddInput(m_ConsumptionCnt[0].toString(), 8, true, 0, false);

		cb = FI.AddComboBox(); cb.current = Common.FillMenuItem(cb.menu, m_ConsumptionType[1]);
		FI.Col();
		FI.AddInput(m_ConsumptionCnt[1].toString(), 8, true, 0, false);

		cb = FI.AddComboBox(); cb.current = Common.FillMenuItem(cb.menu, m_ConsumptionType[2]);
		FI.Col();
		FI.AddInput(m_ConsumptionCnt[2].toString(), 8, true, 0, false);

		cb = FI.AddComboBox(); cb.current = Common.FillMenuItem(cb.menu, m_ConsumptionType[3]);
		FI.Col();
		FI.AddInput(m_ConsumptionCnt[3].toString(), 8, true, 0, false);

		FI.Run(ConsumptionSend, StdMap.Txt.ButSave, StdMap.Txt.ButClose);
	}

	public function ConsumptionSend():void
	{
		var it0:uint = FI.GetInt(0);
		var ic0:int = FI.GetInt(1);
		var it1:uint = FI.GetInt(2);
		var ic1:int = FI.GetInt(3);
		var it2:uint = FI.GetInt(4);
		var ic2:int = FI.GetInt(5);
		var it3:uint = FI.GetInt(6);
		var ic3:int = FI.GetInt(7);
		
		m_ConsumptionType[0] = it0;
		m_ConsumptionCnt[0] = ic0;
		m_ConsumptionType[1] = it1;
		m_ConsumptionCnt[1] = ic1;
		m_ConsumptionType[2] = it2;
		m_ConsumptionCnt[2] = ic2;
		m_ConsumptionType[3] = it3;
		m_ConsumptionCnt[3] = ic3;

		SendAction("emconsumption", 
			"" + it0.toString(16) + "_" + ic0.toString()
			+ "_" + it1.toString(16) + "_" + ic1.toString()
			+ "_" + it2.toString(16) + "_" + ic2.toString()
			+ "_" + it3.toString(16) + "_" + ic3.toString()
		);
	}

	public function EditMapChangeCode(...args):void
	{
		Server.Self.Query("emedcotlspecial", "&type=20", EditMapGetCodeAnswer, false);
	}
	
	private var m_CodeEdit:CtrlInput = null;
	private var m_CodeLine:CtrlInput = null;

	public function EditMapGetCodeAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray = loader.data;
		if (buf == null) return;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int=buf.readUnsignedByte();
		if (err != Server.ErrorNone) { ErrorFromServer(err); return; }
		
		var len:int = buf.readUnsignedInt();
		var str:String = buf.readUTFBytes(len);
		
		SpawnListBuild(str);
		
		FI.Init(750, 600);
		FI.caption = Common.TxtEdit.MapChangeCode;

		m_CodeEdit = FI.AddCode("", 65536 * 3, true, Server.LANG_ENG, true);
		m_CodeEdit.restrict = null;
		m_CodeEdit.input.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, EditMapChangeCodeKeyFocusChange);
		m_CodeEdit.input.addEventListener(Event.CHANGE, EditMapGetCodeAnswer_EditChange);
		m_CodeEdit.input.addEventListener(MouseEvent.CLICK, EditMapGetCodeAnswer_EditChange);
		m_CodeEdit.input.addEventListener(KeyboardEvent.KEY_DOWN, EditMapGetCodeAnswer_EditChange);
		m_CodeEdit.input.addEventListener(KeyboardEvent.KEY_UP, EditMapGetCodeAnswer_EditChange);
		m_CodeEdit.text = str;
		FI.SetRowSize(0, 0, FI.contentHeight - FI.m_ButCancel.height - 10);
		
		m_CodeLine = new CtrlInput(FI);
		FI.CtrlAdd(m_CodeLine);
		m_CodeLine.setRestrict(6, true, 0, false);
		//FI.AddInput("0", 6, true, 0, false);
		m_CodeLine.input.addEventListener(Event.CHANGE, EditMapGetCodeAnswer_LineChange);

		if (CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditCode) {
			FI.Run(EditMapChangeCodeSend, null, StdMap.Txt.ButClose);
		} else {
			FI.Run(null, null, StdMap.Txt.ButClose);
		}
		
		m_CodeLine.width = 100;
		m_CodeLine.x = FI.contentX;
		m_CodeLine.y = FI.m_ButCancel.y + (FI.m_ButCancel.height >> 1) - (m_CodeLine.height >> 1);
	}
	
	public function EditMapGetCodeAnswer_EditChange(event:Event):void
	{
		var str:String = m_CodeEdit.text;

		var cnt:int = 0;
		var len:int = str.length;
		var off:int = m_CodeEdit.selectionEndIndex - 1;
		var ch:int;

		while (off > 0) {
			ch = str.charCodeAt(off);
			if (ch == 10) {
				cnt++;
				if (off > 0 && str.charCodeAt(off - 1) == 13) off--;
			}
			else if (ch == 13) cnt++;
			off--;
		}

		m_CodeLine.text = (cnt + 1).toString();
	}
	
	public function EditMapGetCodeAnswer_LineChange(event:Event):void
	{
		var line:int = int(m_CodeLine.text);

		var str:String = m_CodeEdit.text;

		var cnt:int = 0;
		var len:int = str.length;
		var off:int = 0;
		var ch:int;
		var linebegin:int = 0;

		while (off < len) {
			ch = str.charCodeAt(off);
			if (ch == 10) {
				line--;
				if (line <= 0) {
					m_CodeEdit.setSelection(linebegin, off);
					break;
				}
				off++;
				linebegin = off;
			}
			else if (ch == 13) {
				line--;
				if (line <= 0) {
					m_CodeEdit.setSelection(linebegin, off);
					break;
				}
				off++;
				if (off + 1 < len && str.charCodeAt(off + 1) == 10) off++;
				linebegin = off;
			} else {
				off++;
			}
		}
	}

	public function EditMapChangeCodeKeyFocusChange(event:FocusEvent):void
	{
		event.preventDefault();
		var txt:TextField = TextField(event.currentTarget);
		txt.replaceSelectedText("\t");
	}

	public function EditMapChangeCodeSend():void
	{
		CodeSend(FI.GetStr(0));
	}
	
	private var m_CodeQueryFun:Function = null;
	public function CodeQuery(fun:Function):void
	{
		m_CodeQueryFun = fun;
		Server.Self.Query("emedcotlspecial", "&type=20", CodeQueryAnswer, false);
	}

	public function CodeQueryAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray = loader.data;
		if (buf == null) return;
		buf.endian = Endian.LITTLE_ENDIAN;

		var err:int = buf.readUnsignedByte();
		if (err != Server.ErrorNone) { ErrorFromServer(err); return; }

		var len:int = buf.readUnsignedInt();
		var str:String = buf.readUTFBytes(len);

		SpawnListBuild(str);
		if (m_CodeQueryFun != null) m_CodeQueryFun(str);
	}

	public function CodeSend(src:String):void
	{
		src = BaseStr.Replace(BaseStr.Replace(src, "\r\n", "\n"), "\r", "\n");
		if (src == null) src = "";

		var env:CodeCompiler = new CodeCompiler();
		var cc:CodeCompiler = new CodeCompiler(new CodeSrc(src));
		var ba:ByteArray = new ByteArray();
		ba.endian = Endian.LITTLE_ENDIAN;

		var ef:Dictionary = new Dictionary();
		ef["MakePtr"] = 0;
		ef["Log"] = 1;
		ef["LogFormat"] = 2;
		ef["GroupChangeVis"] = 3;
		ef["GroupChangeMove"] = 4;
		ef["GroupChangeCapture"] = 5;
		ef["AddOrbitItem"] = 6;
		ef["NewGroup"] = 7;
		ef["FindEmptyPlace"] = 8;
		ef["AddShip"] = 9;
		ef["NewRect"] = 10;
		ef["FindShipByKey"] = 11;
		ef["SetLink"] = 12;
		ef["Rnd"] = 13;
		ef["Time"] = 14;
		ef["IsTraining"] = 15;
		ef["HomeUserId"] = 16;
		ef["CanCapture"] = 17;
		ef["CanMove"] = 18;
		ef["IsBattle"] = 19;
		ef["GetTeam"] = 20;
		ef["SetTeam"] = 21;
		ef["GetTeamRel"] = 22;
		ef["SetTeamRel"] = 23;
		ef["SpawnInit"] = 24;
		ef["SpawnTgt"] = 25;
		ef["SpawnSearch"] = 26;
		ef["SpawnDestroy"] = 27;
		ef["SpawnShip"] = 28;
		ef["Spawn"] = 29;

/*
var pl:uint;
pl=MakePtr(15,-8,1);
LogFormat(16); Log("pl: 0x",pl);

LogFormat();

var i:int, a:int, k:int;
a=0;
for(k=0;k<10000;k+=1) {
for(i=0;i<1000;i+=1) {
	a+=1;
}
Log("a:",a);
}
*/

		try {
			if(BaseStr.Trim(src).length>0) {
				cc.parseFun();
				cc.prepare(QEManager.m_Env);
//var i:int = cc.findDeclByName("OpenSklad");
//if(i >= 0) {
//var cc2:CodeCompiler = cc.m_Decl[i];
//cc2.m_Block.decode(cc2.m_Block.m_Code);
//trace(cc2.m_Block.print());
//}
				if (cc.m_Src.err) {
					FormMessageBox.RunErr("Compiler error: " + cc.m_Src.err.toString() + " line: " + (cc.m_Src.m_Line + 1).toString() + " char: " + (cc.m_Src.m_Char + 1).toString());
					FI.Show();
					return;
				}
				cc.save(ba, ef);
				if (cc.m_Src.err) {
					FormMessageBox.RunErr("Save bin-code error: " + cc.m_Src.err.toString() +(cc.m_Src.errName != null?('"' + cc.m_Src.errName + '"'):"") + " line: " + (cc.m_Src.m_Line + 1).toString() + " char: " + (cc.m_Src.m_Char + 1).toString());
					FI.Show();
					return;
				}
			}

		} catch (err:*) {
			FormMessageBox.RunErr("Compiler exception: " + err.message);
			FI.Show();
			return;
		}
		
		SpawnListBuild(src);

		var boundary:String = Server.Self.CreateBoundary();
		var d:String = "";

		d+="--"+boundary+"\r\n";
		d+="Content-Disposition: form-data; name=\"codesrc\"\r\n\r\n";
		d += src + "\r\n";

		if(ba.length>0) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"coderaw\"\r\n\r\n";
			d += Base64.encodeByteArray(ba) + "\r\n";
		}

		d+="--"+boundary+"--\r\n";

		Server.Self.QueryPost("emedcotlspecial", "&type=19", d, boundary, EditMapChangeCodeAnswer, false);
	}

	public function EditMapChangeCodeAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray = loader.data;
		if (buf == null) return;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int=buf.readUnsignedByte();
		if (err != Server.ErrorNone) { ErrorFromServer(err); return; }
	}
	
	public function EditMapViewStat(...args):void
	{
		m_LoadSectorAll = true;
	}
	
	public function StatUserGet(ul:Array, owner:uint):Object
	{
		var u:* = ul[owner];
		if (u != undefined) return u as Object;
		
		u = new Object();
		u.GoodsPlanet = new Array();
		u.GoodsShip = new Array();
		u.Ships = new Array();
		u.Keys = new Array();
		ul[owner] = u;
		u.Id = owner;
		u.RichCnt = 0;
		u.LiveCnt = 0;
		u.SmallCnt = 0;
		
		return u;
	}
	
	public function EditMapShowStat():void
	{
		var x:int, y:int, i:int, k:int, j:int;
		var sec:Sector;
		var planet:Planet;
		var pi:PlanetItem;
		var ship:Ship;
		var it:*;
		var key:uint;
		var s:String = "";
		var str:String;
		
		var ul:Array = new Array();
		var u:Object;
		
		var keysp:Vector.<int> = null;
		
		var secemptycnt:int = 0;
		var planetcnt:int = 0;
		var pulsarcnt:int = 0;
		var suncnt:int = 0;
		var womholecnt:int = 0;
		var roamwomholecnt:int = 0;
		var gigantcnt:int = 0;
		var tinicnt:int = 0;
		var richcnt:int = 0;
		var livecnt:int = 0;
		var smallcnt:int = 0;

		s += Common.TxtEdit.StatMaxSize + ": " + m_SectorCntX.toString() + "," + m_SectorCntY.toString() + "\n";

		for (y = m_SectorMinY; y < m_SectorMinY + m_SectorCntY; y++) {
			for (x = m_SectorMinX; x < m_SectorMinX + m_SectorCntX; x++) {
				sec = GetSector(x, y);
				if (sec == null) continue;
				if (sec.m_Planet.length <= 0) {
					secemptycnt++;
					continue;
				}
				for (i = 0; i < sec.m_Planet.length; i++) {
					planet = sec.m_Planet[i];
					planetcnt++;

					if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) pulsarcnt++;
					else if ((planet.m_Flag & (Planet.PlanetFlagSun)) == (Planet.PlanetFlagSun)) suncnt++;
					else if ((planet.m_Flag & (Planet.PlanetFlagWormhole)) == (Planet.PlanetFlagWormhole)) womholecnt++;
					else if ((planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) gigantcnt++;
					else if ((planet.m_Flag & (Planet.PlanetFlagGigant)) == (Planet.PlanetFlagGigant)) tinicnt++;
					else if ((planet.m_Flag & (Planet.PlanetFlagRich)) == (Planet.PlanetFlagRich)) richcnt++;
					else if ((planet.m_Flag & (Planet.PlanetFlagLarge)) == (Planet.PlanetFlagLarge)) livecnt++;
					else smallcnt++;

					if ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagWormhole | Planet.PlanetFlagGigant)) == 0) {
						u = StatUserGet(ul, planet.m_Owner);

						if (planet.m_Flag & Planet.PlanetFlagRich) u.RichCnt++;
						else if (planet.m_Flag & Planet.PlanetFlagLarge) u.LiveCnt++;
						else u.SmallCnt++;
					}

					if(planet.m_Item)
					for (k = 0; k < planet.m_Item.length; k++) {
						pi = planet.m_Item[k];
						if (!pi.m_Type) continue;
						
						u = StatUserGet(ul, planet.m_Owner);
						if (u.GoodsPlanet[pi.m_Type] == undefined) u.GoodsPlanet[pi.m_Type] = 0;
						u.GoodsPlanet[pi.m_Type] += pi.m_Cnt;
					}
					
					for (j = 0; j < planet.m_Ship.length; j++) {
						ship = planet.m_Ship[j];
						if (ship.m_Type) {
							u = StatUserGet(ul, ship.m_Owner);
							if (u.Ships[ship.m_Type] == undefined) u.Ships[ship.m_Type] = 0;
							u.Ships[ship.m_Type] += ship.m_Cnt++;

							if (ship.m_ItemType) {
								if (u.GoodsShip[ship.m_ItemType] == undefined) u.GoodsShip[ship.m_ItemType] = 0;
								u.GoodsShip[ship.m_ItemType] += ship.m_ItemCnt;
							}
							if (ship.m_CargoType) {
								if (u.GoodsShip[ship.m_CargoType] == undefined) u.GoodsShip[ship.m_CargoType] = 0;
								u.GoodsShip[ship.m_CargoType] += ship.m_CargoCnt;
							}

							if ((ship.m_Owner & Common.OwnerAI) || (ship.m_Owner == 0)) {
								key = (ship.m_Group >>> 8);
								if (key != 0) {
									if (u.Keys[key] == undefined) u.Keys[key] = new Vector.<int>();
									keysp = u.Keys[key];
									for (k = 0; k < keysp.length; k += 4) {
										if (keysp[k + 0] != planet.m_Sector.m_SectorX) continue;
										if (keysp[k + 1] != planet.m_Sector.m_SectorY) continue;
										if (keysp[k + 2] != planet.m_PlanetNum) continue;
										break;
									}
									if (k < keysp.length) {
										keysp[k + 3] = keysp[k + 3] + 1;
									} else {
										keysp.push(planet.m_Sector.m_SectorX);
										keysp.push(planet.m_Sector.m_SectorY);
										keysp.push(planet.m_PlanetNum);
										keysp.push(1);
									}
								}
							}
						}

						if (ship.m_OrbitItemType) {
							u = StatUserGet(ul, ship.m_OrbitItemOwner);
							if (u.GoodsShip[ship.m_OrbitItemType] == undefined) u.GoodsShip[ship.m_OrbitItemType] = 0;
							u.GoodsShip[ship.m_OrbitItemType] += ship.m_OrbitItemCnt;
						}
					}
				}
			}
		}

		s += Common.TxtEdit.StatSecEmptyCnt + ": " + secemptycnt.toString() + "\n";
		s += Common.TxtEdit.StatPlanetCnt + ": " + planetcnt.toString() + "\n";
		s += Common.TxtEdit.StatWormholeCnt + ": " + womholecnt.toString() + "\n";
		s += Common.TxtEdit.StatPulsarCnt + ": " + pulsarcnt.toString() + "\n";
		s += Common.TxtEdit.StatSunCnt + ": " + suncnt.toString() + "\n";
		s += Common.TxtEdit.StatGigantCnt + ": " + gigantcnt.toString() + "\n";
		s += Common.TxtEdit.StatTiniCnt + ": " + tinicnt.toString() + "\n";
		s += Common.TxtEdit.StatRichCnt + ": " + richcnt.toString() + "\n";
		s += Common.TxtEdit.StatLiveCnt + ": " + livecnt.toString() + "\n";
		s += Common.TxtEdit.StatSmallCnt + ": " + smallcnt.toString() + "\n";

		for each (u in ul) {
			s += "\n";
			if (u.Id == 0) s += Common.TxtEdit.StatOwner + ": " + Common.TxtEdit.StatOwnerNeutral + "\n";
			else s += Common.TxtEdit.StatOwner + ": " + Txt_CotlOwnerName(Server.Self.m_CotlId, u.Id, true) + "\n";
			s += Common.TxtEdit.StatRichCnt + ": " + u.RichCnt.toString() + "\n";
			s += Common.TxtEdit.StatLiveCnt + ": " + u.LiveCnt.toString() + "\n";
			s += Common.TxtEdit.StatSmallCnt + ": " + u.SmallCnt.toString() + "\n";
			if (u.GoodsPlanet.length > 0) {
				s += Common.TxtEdit.StatGoodsPlanet + ":\n";
				for (it in u.GoodsPlanet) {
					s += "    " + ItemName(it) + ": " + BaseStr.FormatBigInt(u.GoodsPlanet[it]) + "\n";
				}
			}
			if (u.GoodsShip.length > 0) {
				s += Common.TxtEdit.StatGoodsShip + ":\n";
				for (it in u.GoodsShip) {
					s += "    " + ItemName(it) + ": " + BaseStr.FormatBigInt(u.GoodsShip[it]) + "\n";
				}
			}
			if (u.Ships.length > 0) {
				s += Common.TxtEdit.StatShips + ":\n";
				for (it in u.Ships) {
					s += "    " + Common.ShipNameForCnt[it] + ": " + BaseStr.FormatBigInt(u.Ships[it]) + "\n";
				}
			}
			if (u.Keys.length > 0) {
				s += Common.TxtEdit.StatShipKeys + ":\n";
				for (str in u.Keys) {
					key = int(str);
					keysp = u.Keys[str];
					s += "    " + key.toString(16) + ":";
					for (k = 0; k < keysp.length; k += 4) {
						s += " "+keysp[k + 3].toString() + "=" + (keysp[k + 0] - m_SectorMinX + 1).toString() + "," + (keysp[k + 1] - m_SectorMinY + 1).toString() + "," + keysp[k + 2].toString();
					}
					s += "\n";
				}
			}
		}

		FI.Init(480, 500);
		FI.caption = Common.TxtEdit.StatCaption;

		FI.AddCode(s, 1024 * 1024, true, Server.Self.m_Lang, true).heightMin = 360;

		FI.Run(null, null, StdMap.Txt.ButClose);
	}

	public function EditMapTeamRel(...args):void
	{
		FormHideAll();
		m_FormTeamRel.Show();
	}

	public function EditMapChangeSize(...args):void
	{
		FI.Init(400, 300);
		FI.caption = Common.TxtEdit.MapChangeSize;
		
		FI.AddLabel(Common.TxtEdit.MapChangeSizeLeft+":");
		FI.Col();
		FI.AddInput("0",5,true,0);
		
		FI.AddLabel(Common.TxtEdit.MapChangeSizeTop+":");
		FI.Col();
		FI.AddInput("0",5,true,0);
		
		FI.AddLabel(Common.TxtEdit.MapChangeSizeRight+":");
		FI.Col();
		FI.AddInput("0",5,true,0);
		
		FI.AddLabel(Common.TxtEdit.MapChangeSizeBottom+":");
		FI.Col();
		FI.AddInput("0",5,true,0);

		FI.Run(EditMapChangeSizeSend, Common.TxtEdit.ButEdit, StdMap.Txt.ButCancel);
	}

	public function EditMapChangeSizeSend():void
	{
		var left:int=FI.GetInt(0);
		var top:int=FI.GetInt(1);
		var right:int=FI.GetInt(2);
		var bottom:int=FI.GetInt(3);
		Server.Self.Query("emedcotlspecial", "&type=5&left=" + left.toString() + "&top=" + top.toString() + "&right=" + right.toString() + "&bottom=" + bottom.toString(), EditMapChangeSizeRecv, false);
	}

	public function EditMapChangeSizeRecv(e:Event):void
	{
	}
	
	public function EditMapChangeRandomizeNeutral(...args):void
	{
		FormMessageBox.Run(Common.TxtEdit.MapChangeRandomizeNeutralQuery, StdMap.Txt.BuyNo, StdMap.Txt.BuyYes, EditMapChangeRandomizeNeutralSend);
	}
	
	public function EditMapChangeRandomizeNeutralSend():void
	{
		var ac:Action = new Action(this);
		ac.ActionSpecial(35, 0, 0, 0, -1);
		m_LogicAction.push(ac);
	}
	
	public function EditMapChangeRandomizeElement(...args):void
	{
		FormMessageBox.Run(Common.TxtEdit.MapChangeRandomizeElementQuery, StdMap.Txt.BuyNo, StdMap.Txt.BuyYes, EditMapChangeRandomizeElementSend);
	}
	
	public function EditMapChangeRandomizeElementSend():void
	{
		var ac:Action = new Action(this);
		ac.ActionSpecial(37, 0, 0, 0, -1);
		m_LogicAction.push(ac);
	}

	public function EditMapAddPlanet(...args):void
	{
		FI.Init(400, 200);
		FI.caption = Common.TxtEdit.AddPlanet;

		FI.AddLabel(Common.TxtEdit.PlanetType+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.PlanetSun, Planet.PlanetFlagSun);
		FI.AddItem(Common.TxtEdit.PlanetPulsar, Planet.PlanetFlagSun | Planet.PlanetFlagLarge);
		FI.AddItem(Common.TxtEdit.PlanetWormhole, Planet.PlanetFlagWormhole);
		FI.AddItem(Common.TxtEdit.PlanetAsteroid, Planet.PlanetFlagGigant);
		FI.AddItem(Common.TxtEdit.PlanetGigant, Planet.PlanetFlagGigant|Planet.PlanetFlagLarge);
		FI.AddItem(Common.TxtEdit.PlanetSmall, 0,true);
		FI.AddItem(Common.TxtEdit.PlanetLarge, Planet.PlanetFlagLarge);
		FI.AddItem(Common.TxtEdit.PlanetRich, Planet.PlanetFlagRich | Planet.PlanetFlagLarge);

/*		FI.AddLabel(Common.TxtEdit.Owner+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.OwnerNone,0,true);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI0),Common.OwnerAI0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI1),Common.OwnerAI1);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI2),Common.OwnerAI2);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId,Common.OwnerAI3),Common.OwnerAI3);

		FI.AddLabel(Common.TxtEdit.Level+":");
		FI.Col();
		FI.AddInput("5",3,true);

		FI.AddLabel(Common.TxtEdit.Race+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.RaceName[Common.RaceNone],Common.RaceNone,true);
		FI.AddItem(Common.RaceName[Common.RaceGrantar],Common.RaceGrantar);
		FI.AddItem(Common.RaceName[Common.RacePeleng],Common.RacePeleng);
		FI.AddItem(Common.RaceName[Common.RacePeople],Common.RacePeople);
		FI.AddItem(Common.RaceName[Common.RaceTechnol],Common.RaceTechnol);
		FI.AddItem(Common.RaceName[Common.RaceGaal],Common.RaceGaal);
		FI.AddItem(Common.RaceName[Common.RaceKling],Common.RaceKling);

		FI.AddLabel(ItemName(Common.ItemTypeMachinery)+":");
		FI.Col();
		FI.AddInput("0",7,true);

		FI.AddLabel(ItemName(Common.ItemTypeEngineer)+":");
		FI.Col();
		FI.AddInput("0", 7, true);

		FI.AddLabel(Common.TxtEdit.BuildItem+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.BuildItemNone,Common.ItemTypeNone,true);
		FI.AddItem(ItemName(Common.ItemTypeCrystal),Common.ItemTypeCrystal);
		FI.AddItem(ItemName(Common.ItemTypeTitan),Common.ItemTypeTitan);
		FI.AddItem(ItemName(Common.ItemTypeSilicon),Common.ItemTypeSilicon);

		FI.AddCheck(false,Common.TxtEdit.ArrivalDef);
		FI.AddCheck(false,Common.TxtEdit.ArrivalAtk);

		FI.AddCheck(false,Common.TxtEdit.Capture);

		FI.AddLabel(Common.TxtEdit.AutoRefuel+":");
		FI.Col();
		FI.AddInput("0",4,true);*/

		FI.Run(EditMapAddPlanetSend, Common.TxtEdit.ButAdd, StdMap.Txt.ButCancel);
	}

	public function EditMapAddPlanetSend():void
	{
/*
		var flag:uint = FI.GetInt(0);
		var plowner:uint = 0;// FI.GetInt(1);
		var lvl:uint = 0;// FI.GetInt(2);
		if (flag & Planet.PlanetFlagSun) {}
		else if (flag & Planet.PlanetFlagWormhole) {}
		else if (flag & Planet.PlanetFlagGigant) {}
		else lvl = 10;
		var race:uint = Common.RaceNone;// FI.GetInt(3);
		var machinery:uint = 0;// FI.GetInt(4);
		var enginer:uint = 0;// FI.GetInt(5);
		var builditem:uint = 0;// FI.GetInt(6);
		var def:int = 0;// FI.GetInt(7);
		var atk:int = 0;// FI.GetInt(8);
		var nocapture:int = 0;// FI.GetInt(9);
		var refuel:int = 0;// FI.GetInt(10);
		var findid:uint = 0;
		if (def != 0) flag |= Planet.PlanetFlagArrivalDef;
		if (atk != 0) flag |= Planet.PlanetFlagArrivalAtk;
		if (nocapture != 0) flag |= Planet.PlanetFlagNoCapture;

		Server.Self.Query("emedcotlspecial",
			"&type=7&val="+
			m_EditX.toString()+"_"+
			m_EditY.toString()+"_"+
			flag.toString()+"_"+
			plowner.toString()+"_"+
			lvl.toString()+"_"+
			race.toString()+"_"+
			machinery.toString() + "_" +
			enginer.toString()+"_"+
			builditem.toString()+"_"+
			refuel.toString()+"_"+
			findid.toString(16),
			EditMapChangeSizeRecv,false);
		*/

		var flag:uint = FI.GetInt(0);

		Server.Self.Query("emedcotlspecial",
			"&type=7&val=" +
			m_EditX.toString() + "_" +
			m_EditY.toString() + "_" +
			flag.toString() + "_" +
			"0_0_-1",
			EditMapChangeSizeRecv,false);
	}

	public function EditMapChangePlanet(...args):void
	{
		var i:int;
		
		m_MoveSectorX = m_CurSectorX;
		m_MoveSectorY = m_CurSectorY;
		m_MovePlanetNum = m_CurPlanetNum;

		var planet:Planet=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
		if(planet==null) return;

		FI.Init(480,480);
		FI.caption = Common.TxtEdit.EditPlanet;
		FI.softLock = true;
		
		FI.TabAdd(Common.TxtEdit.PlanetPageMain);
		FI.tab = 0;

		var t:int=0;
		if((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge))==(Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) t=1;
		else if (planet.m_Flag & Planet.PlanetFlagSun) t = 2;
		else if((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge))==(Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge)) t=9;
		else if(planet.m_Flag & Planet.PlanetFlagWormhole) t=3;
		else if((planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge))==(Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) t=4;
		else if(planet.m_Flag & Planet.PlanetFlagGigant) t=5;
		else if(planet.m_Flag & Planet.PlanetFlagRich) t=8;
		else if(planet.m_Flag & Planet.PlanetFlagLarge) t=7;
		else t=6;

		FI.AddLabel(Common.TxtEdit.PlanetType+":");
		FI.Col();
		FI.AddComboBox().widthMin = 120;
		FI.AddItem(Common.TxtEdit.PlanetSun, Planet.PlanetFlagSun, 								t==2);
		FI.AddItem(Common.TxtEdit.PlanetPulsar, Planet.PlanetFlagSun | Planet.PlanetFlagLarge,	t==1);
		FI.AddItem(Common.TxtEdit.PlanetWormhole, Planet.PlanetFlagWormhole, 					t==3);
		FI.AddItem(Common.TxtEdit.PlanetWormholeRoam, Planet.PlanetFlagWormhole | Planet.PlanetFlagLarge, t==9);
		FI.AddItem(Common.TxtEdit.PlanetAsteroid, Planet.PlanetFlagGigant, 						t==5);
		FI.AddItem(Common.TxtEdit.PlanetGigant, Planet.PlanetFlagGigant|Planet.PlanetFlagLarge,	t==4);
		FI.AddItem(Common.TxtEdit.PlanetSmall, 0,												t==6);
		FI.AddItem(Common.TxtEdit.PlanetLarge, Planet.PlanetFlagLarge,							t==7);
		FI.AddItem(Common.TxtEdit.PlanetRich, Planet.PlanetFlagRich|Planet.PlanetFlagLarge,		t==8);

		FI.Col();
		FI.AddLabel(Common.TxtEdit.Owner+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.OwnerNone,0,planet.m_Owner==0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI0), Common.OwnerAI0, planet.m_Owner == Common.OwnerAI0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI1), Common.OwnerAI1, planet.m_Owner == Common.OwnerAI1);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI2), Common.OwnerAI2, planet.m_Owner == Common.OwnerAI2);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI3), Common.OwnerAI3, planet.m_Owner == Common.OwnerAI3);
		if (planet.m_Owner != 0 && (planet.m_Owner & Common.OwnerAI) == 0) FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, planet.m_Owner), planet.m_Owner, true);

		FI.AddLabel(Common.TxtEdit.Level+":");
		FI.Col();
		FI.AddInput(planet.m_Level.toString(),3,true);

		FI.Col();
		FI.AddLabel(Common.TxtEdit.Race+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.RaceName[Common.RaceNone], Common.RaceNone, planet.m_Race == Common.RaceNone);
		FI.AddItem(Common.RaceName[Common.RaceGrantar], Common.RaceGrantar, planet.m_Race == Common.RaceGrantar);
		FI.AddItem(Common.RaceName[Common.RacePeleng], Common.RacePeleng, planet.m_Race == Common.RacePeleng);
		FI.AddItem(Common.RaceName[Common.RacePeople], Common.RacePeople, planet.m_Race == Common.RacePeople);
		FI.AddItem(Common.RaceName[Common.RaceTechnol], Common.RaceTechnol, planet.m_Race == Common.RaceTechnol);
		FI.AddItem(Common.RaceName[Common.RaceGaal], Common.RaceGaal, planet.m_Race == Common.RaceGaal);
//		FI.AddItem(Common.RaceName[Common.RaceKling],Common.RaceKling,planet.m_Race==Common.RaceKling);

		FI.AddLabel(ItemName(Common.ItemTypeMachinery) + ":");
		FI.Col();
		FI.AddInput(planet.m_Machinery.toString(), 7, true);

		FI.Col();
		FI.AddLabel(ItemName(Common.ItemTypeEngineer) + ":");
		FI.Col();
		FI.AddInput(planet.m_Engineer.toString(), 7, true);

		FI.AddLabel(Common.TxtEdit.BuildItem+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.BuildItemNone, Common.ItemTypeNone, planet.m_OreItem == Common.ItemTypeNone);
		FI.AddItem(ItemName(Common.ItemTypeCrystal), Common.ItemTypeCrystal, planet.m_OreItem == Common.ItemTypeCrystal);
		FI.AddItem(ItemName(Common.ItemTypeTitan), Common.ItemTypeTitan, planet.m_OreItem == Common.ItemTypeTitan);
		FI.AddItem(ItemName(Common.ItemTypeSilicon), Common.ItemTypeSilicon, planet.m_OreItem == Common.ItemTypeSilicon);

		FI.AddCheckBox((planet.m_Flag & Planet.PlanetFlagArrivalDef)!=0,Common.TxtEdit.ArrivalDef);
		FI.AddCheckBox((planet.m_Flag & Planet.PlanetFlagArrivalAtk)!=0,Common.TxtEdit.ArrivalAtk);

		FI.AddCheckBox((planet.m_Flag & Planet.PlanetFlagNoCapture) != 0, Common.TxtEdit.NoCapture);
		FI.AddCheckBox((planet.m_Flag & Planet.PlanetFlagNoMove) != 0, Common.TxtEdit.NoMove);

		FI.AddLabel(Common.TxtEdit.Team+":");
		FI.Col();
		FI.AddComboBox();
		for(i=0;i<(1<<Common.TeamMaxShift);i++) {
			FI.AddItem(String.fromCharCode(65+i),i,i==planet.m_Team);
		}

		FI.Col();
		FI.AddLabel(Common.TxtEdit.PlanetFindMask + ":");
		FI.Col();
		FI.AddInput(planet.m_FindMask.toString(16), 32, true, 0, false, "ABCDEFabcdef");

		FI.TabAdd(Common.TxtEdit.PlanetPageAdd);

		FI.AddLabel(Common.TxtEdit.PlanetTimer + ":");
		FI.Col();
		FI.AddInput(Math.max(0, Math.floor((planet.m_NeutralCooldown - m_ServerCalcTime) / 1000)).toString(), 10, true, 0, false);

		FI.AddCheckBox((planet.m_Flag & Planet.PlanetFlagStabilizer) != 0, Common.TxtEdit.PlanetStabilizer);
		
		FI.AddLabel(Common.TxtEdit.AutoRefuel+":");
		FI.Col();
		FI.AddInput(planet.m_Refuel.toString(), 4, true);

		FI.AddCheckBox((planet.m_Flag & Planet.PlanetFlagHomeworld) != 0, Common.Txt.Homeworld);
		FI.Col();
		FI.AddCheckBox((planet.m_Flag & Planet.PlanetFlagCitadel) != 0, Common.Txt.Citadel);

		if (IsEditMap()) FI.Run(EditMapChangePlanetSend, Common.TxtEdit.ButEdit, StdMap.Txt.ButCancel);
		else FI.Run(null, null, StdMap.Txt.ButCancel);
	}

	public function EditMapChangePlanetSend():void
	{
		var kk:int = 0;
		var flag:uint=FI.GetInt(kk++);
		var plowner:uint=FI.GetInt(kk++);
		var lvl:uint = FI.GetInt(kk++);
		var race:uint=FI.GetInt(kk++);
		var machinery:uint = FI.GetInt(kk++);
		var engineer:uint=FI.GetInt(kk++);
		var oreitem:uint=FI.GetInt(kk++);
		var def:int=FI.GetInt(kk++);
		var atk:int=FI.GetInt(kk++);
		var nocapture:int = FI.GetInt(kk++);
		var nomove:int=FI.GetInt(kk++);
		var team:int = FI.GetInt(kk++);
		var findid:uint = BaseStr.ParseUint(FI.GetStr(kk++), 16);
		var timer:int = FI.GetInt(kk++);
		var stabil:int = FI.GetInt(kk++);
		var refuel:int=FI.GetInt(kk++);
		var homeworld:int=FI.GetInt(kk++);
		var citadel:int=FI.GetInt(kk++);
		
		if (def != 0) flag |= Planet.PlanetFlagArrivalDef;
		if (atk != 0) flag |= Planet.PlanetFlagArrivalAtk;
		if (nocapture != 0) flag |= Planet.PlanetFlagNoCapture;
		if (nomove != 0) flag |= Planet.PlanetFlagNoMove;
		if (homeworld != 0) flag |= Planet.PlanetFlagHomeworld;
		if (citadel != 0) flag |= Planet.PlanetFlagCitadel;
		if (stabil != 0) flag |= Planet.PlanetFlagStabilizer;

		if (flag & (Planet.PlanetFlagSun | Planet.PlanetFlagWormhole | Planet.PlanetFlagGigant)) {
			lvl = 0;
			plowner = 0;
			race = Common.RaceNone;
			machinery = 0;
			engineer = 0;
			oreitem = 0;
			flag &= ~(Planet.PlanetFlagHomeworld | Planet.PlanetFlagCitadel);
		}
		if (lvl < 0) lvl = 0;

		var pl:Planet = GetPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);

		EditMapChangePlanetSet(pl, m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum, flag, plowner, lvl, race, machinery, engineer, oreitem, refuel, team, findid, timer);
	}
	
	public function EditMapChangePlanetSet(des:Planet, secx:int, secy:int, planetnum:int, flag:uint, plowner:uint, lvl:int, race:int, machinery:int, engineer:int, oreitem:int, refuel:int, team:int, findid:uint, timer:int):void
	{
		var i:int;
		
		if(des!=null) {
			var changetype:Boolean = 
				(des.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge | Planet.PlanetFlagWormhole | Planet.PlanetFlagGigant | Planet.PlanetFlagRich)) 
				!= 
				(flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge | Planet.PlanetFlagWormhole | Planet.PlanetFlagGigant | Planet.PlanetFlagRich));

			if(changetype
				&& (des.m_Flag & (Planet.PlanetFlagSun|Planet.PlanetFlagWormhole|Planet.PlanetFlagGigant|Planet.PlanetFlagLarge|Planet.PlanetFlagRich))==(Planet.PlanetFlagLarge)
				&& (flag & (Planet.PlanetFlagSun|Planet.PlanetFlagWormhole|Planet.PlanetFlagGigant|Planet.PlanetFlagLarge|Planet.PlanetFlagRich))==(Planet.PlanetFlagLarge|Planet.PlanetFlagRich)) changetype=false;
			else if(changetype
				&& (des.m_Flag & (Planet.PlanetFlagSun|Planet.PlanetFlagWormhole|Planet.PlanetFlagGigant|Planet.PlanetFlagLarge|Planet.PlanetFlagRich))==(Planet.PlanetFlagLarge|Planet.PlanetFlagRich)
				&& (flag & (Planet.PlanetFlagSun|Planet.PlanetFlagWormhole|Planet.PlanetFlagGigant|Planet.PlanetFlagLarge|Planet.PlanetFlagRich))==(Planet.PlanetFlagLarge)) changetype=false;

			des.m_Flag=flag;
			des.m_Owner=plowner;
			des.m_Level=lvl;
			des.m_Race=race;
			des.m_Machinery = machinery;
			des.m_Engineer = engineer;
			des.m_OreItem=oreitem;
			des.m_Refuel=refuel;
			des.m_Team = team;
			des.m_FindMask = findid;
			if (timer <= 0) des.m_NeutralCooldown = 0;
			else des.m_NeutralCooldown = m_ServerCalcTime + timer * 1000;

			if (changetype) {
				for (i = 0; i < Planet.PlanetCellCnt; i++) des.m_Cell[i] = 0;
			}
		}
		Server.Self.Query("emedcotlspecial","&type=8&val="+
			secx.toString() + "_" +
			secy.toString() + "_" +
			planetnum.toString() + "_" +
			flag.toString() + "_" +
			plowner.toString() + "_" +
			lvl.toString() + "_" +
			race.toString() + "_" +
			machinery.toString() + "_" +
			engineer.toString() + "_" +
			oreitem.toString() + "_" +
			refuel.toString() + "_" +
			team.toString() + "_" +
			findid.toString(16) + "_" +
			timer.toString(),
			EditMapChangeSizeRecv,false);
	}
	
	public function EditMapCopyPlanet(des:Planet, src:Planet):void
	{
		var i:int;
		
		des.m_Flag = src.m_Flag;
		des.m_Owner = src.m_Owner;
		des.m_Level = src.m_Level;
		des.m_Race = src.m_Race;
		des.m_Machinery = src.m_Machinery;
		des.m_Engineer = src.m_Engineer;
		des.m_OreItem=src.m_OreItem;
		des.m_Refuel=src.m_Refuel;
		des.m_Team = src.m_Team;
		des.m_FindMask = src.m_FindMask;
		des.m_NeutralCooldown = src.m_NeutralCooldown;

		for (i = 0; i < Planet.PlanetCellCnt; i++) des.m_Cell[i] = src.m_Cell[i];

		for (i = 0; i < Planet.PlanetItemCnt; i++) {
			des.m_Item[i].m_Type = src.m_Item[i].m_Type;
			des.m_Item[i].m_Flag = src.m_Item[i].m_Flag;
			des.m_Item[i].m_Cnt = src.m_Item[i].m_Cnt;
			des.m_Item[i].m_Complete = src.m_Item[i].m_Complete;
			des.m_Item[i].m_Broken = src.m_Item[i].m_Broken;
		}

		des.m_Flag &= ~Planet.PlanetFlagHomeworld;

		Server.Self.Query("emedcotlspecial", "&type=18&val=" +
			des.m_Sector.m_SectorX.toString() + "_" +
			des.m_Sector.m_SectorY.toString() + "_" +
			des.m_PlanetNum.toString() + "_" +
			src.m_Sector.m_SectorX.toString() + "_" +
			src.m_Sector.m_SectorY.toString() + "_" +
			src.m_PlanetNum.toString(),
			EditMapChangeSizeRecv, false);
	}

	public function EditMapDeletePlanet(...args):void
	{
		FormHideAll();
		FormMessageBox.Run(Common.TxtEdit.DeletePlanetQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,EditMapDeletePlanetSend);
	}

	public function EditMapDeletePlanetSend(...args):void
	{
		Server.Self.Query("emedcotlspecial", "&type=9&val=" + m_CurSectorX.toString() + "_" + m_CurSectorY.toString() + "_" + m_CurPlanetNum.toString(), EditMapChangeSizeRecv, false);
	}
	
	public function EditMapChangePlanetName(...args):void
	{
		m_MoveSectorX = m_CurSectorX;
		m_MoveSectorY = m_CurSectorY;
		m_MovePlanetNum = m_CurPlanetNum;

		var planet:Planet=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
		if(planet==null) return;
		
		FI.Init(480, 300);
		FI.caption = Common.TxtEdit.EditPlanetName;
		FI.softLock = true;

		FI.AddLabel(Common.TxtEdit.Name+":");
		FI.Col();
		FI.AddInput(TxtCotl_PlanetName(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum),31,true,Server.Self.m_Lang,false);

		FI.AddLabel(Common.TxtEdit.Desc+":");
		FI.AddCode(TxtCotl_PlanetDesc(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum), 511, true, Server.Self.m_Lang, true).heightMin = 100;

		if (IsEditMap()) FI.Run(EditMapChangePlanetNameSend, Common.TxtEdit.ButEdit, StdMap.Txt.ButCancel);
		else FI.Run(null, null, StdMap.Txt.ButCancel);
	}
	
	public function EditMapChangePlanetNameSend():void
	{
		var planet:Planet=GetPlanet(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum);
		if(planet==null) return;

		var tstr:String;
		var boundary:String=Server.Self.CreateBoundary();

		var d:String="";
		
		var id:uint = ((8192 + m_MoveSectorX) << (14 + 2)) + ((8192 + m_MoveSectorY) << (2)) + m_MovePlanetNum;
		
		tstr=FI.GetStr(0);
		if(tstr!=TxtCotl_PlanetName(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum)) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"name\"\r\n\r\n";
			d+=tstr+"\r\n"
		}

		tstr=FI.GetStr(1);
		if(tstr!=TxtCotl_PlanetDesc(m_MoveSectorX,m_MoveSectorY,m_MovePlanetNum)) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"desc\"\r\n\r\n";
			d+=tstr+"\r\n"
		}

		d+="--"+boundary+"--\r\n";

		Server.Self.QueryPost("emedcotlspecial","&type=11&id="+id.toString(),d,boundary,EditMapChangePlanetNameAnswer,false);
	}
	
	public function EditMapChangePlanetNameAnswer(e:Event):void
	{
		m_TxtTime=Common.GetTime()-8000;
	}
	
	private static var m_SpawnObj:Object = null;
	
	private static function stubSpawnInit(ptr:String, race:uint, owner:uint, key:uint, period:int, periodempty:int, periodrnd:int):void
	{
		m_SpawnObj.Ptr = ptr;
		m_SpawnObj.Race = race;
		m_SpawnObj.Owner = owner;
		m_SpawnObj.Key = key;
		m_SpawnObj.Period = period;
		m_SpawnObj.PeriodEnemy = periodempty;
		m_SpawnObj.PeriodRnd = periodrnd;
	}
	private static function stubSpawnTgt(tgt:String):void
	{
		m_SpawnObj.Tgt = tgt;
	}
	private static function stubSpawnSearch(keymask:uint, keyeq:uint, findradius:int):void
	{
		m_SpawnObj.KeyMask = keymask;
		m_SpawnObj.KeyEq = keyeq;
		m_SpawnObj.FindRadius = findradius;
	}
	private static function stubSpawnDestroy(del:Boolean, damageproc:uint, groupmin:int, delnoflagship:Boolean):void
	{
		m_SpawnObj.Del = del;
		m_SpawnObj.DamageProc = damageproc;
		m_SpawnObj.GroupMin = groupmin;
		m_SpawnObj.DelNoFlagship = delnoflagship;
	}
	private static function stubSpawnShip(skip:int, nobattle:Boolean, type:uint, cnt:int, atk:Boolean, route:Boolean, linkself:Boolean, linktgt:Boolean, itype:uint = 0, icnt:int = 0, ctype:uint = 0, ccnt:int = 0):void
	{
		var s:Object = new Object();
		s.Skip = skip;
		s.NoToBattle = nobattle;
		s.Type = type;
		s.Cnt = cnt;
		s.Atk = atk;
		s.Route = route;
		s.LinkSelf = linkself;
		s.LinkTgt = linktgt;
		s.ItemType = itype;
		s.ItemCnt = icnt;
		s.CargoType = ctype;
		s.CargoCnt = ccnt;
		m_SpawnObj.Ship.push(s);
	}
	private static function stubSpawn():void
	{
		throw "Spawn";
	}
	private static function stubMakePtr(secx:int, secy:int, planet:int, ship:int = -1):String
	{
		var s:String = secx.toString() + "," + secy.toString() + "," + planet.toString();
		if (ship >= 0) s += "," + ship.toString();
		return s;
	}
	
	public function SpawnListBuild(src:String):void
	{
		var begin:int, linebegin:int, lineend:int;
		var off:int = 0;
		var srcline:String;
		var ar:Array;
		var secx:int, secy:int, pnum:int;
		var k:uint;
		
		m_SpawnList.length = 0;

		if (m_SpawnObj == null) {
			m_SpawnObj = new Object();
			m_SpawnObj.Ship = new Array();
		}
		m_SpawnObj.Ship.length = 0;

		while(true) {
			begin = src.indexOf("SpawnInit(", off);
			if (begin < 0) break;

			linebegin = BaseStr.CodeBeginLine(src, begin);
			if (linebegin < 0) break;
			lineend = BaseStr.CodeNextLine(src, begin);
			if (lineend < 0) break
			
			m_SpawnObj.Ptr = "";
			
			off = lineend;
			
			srcline = src.substring(linebegin, lineend);
			if (srcline == null || srcline.length <= 0) continue;
			
			var cc:CodeCompiler = new CodeCompiler(new CodeSrc(srcline));

			try {
				cc.parseFun();
				cc.prepare(QEManager.m_Env);

				if (cc.m_Src.err) {
					break;
				}
				var cr:Code = new Code();
				cr.m_Env = QEManager.m_Env;
				cr.importMethod("SpawnInit", stubSpawnInit);
				cr.importMethod("SpawnTgt", stubSpawnTgt);
				cr.importMethod("SpawnSearch", stubSpawnSearch);
				cr.importMethod("SpawnDestroy", stubSpawnDestroy);
				cr.importMethod("SpawnShip", stubSpawnShip);
				cr.importMethod("Spawn", stubSpawn);
				cr.importMethod("MakePtr", stubMakePtr);
				cr.runFun(cc);

			} catch (err:*) {
			}

			srcline = m_SpawnObj.Ptr;
			ar = srcline.split(",");
			if (ar.length < 3) continue;

			secx = int(ar[0]);
			secy = int(ar[1]);
			pnum = int(ar[2]);

			k = ((secx & 0xfff) << 2) | ((secy & 0xfff) << (12 + 2)) | pnum;
			m_SpawnList[k] = 1;
		}

	}
	
	public function EditMapChangeSpawn(...args):void
	{
		m_MoveSectorX = m_CurSectorX; m_MoveSectorY = m_CurSectorY; m_MovePlanetNum = m_CurPlanetNum;
		CodeQuery(EditMapChangeSpawn2);
	}
	
	public function EditMapChangeSpawn2(src:String):void
	{
		var i:int, u:int, begin:int, linebegin:int, lineend:int;
		var skip:int;
		var shiptype:uint;
		var obj:Object;
		var ship:Ship;
		var ar:Array = new Array();
		var route:Boolean;

		//m_MoveSectorX = m_CurSectorX; m_MoveSectorY = m_CurSectorY; m_MovePlanetNum = m_CurPlanetNum;
		
		if (m_SpawnObj == null) {
			m_SpawnObj = new Object();
			m_SpawnObj.Ship = new Array();
		}
		m_SpawnObj.Ship.length = 0;
		m_SpawnObj.Ptr = "";
		m_SpawnObj.Race = Common.RaceNone;
		m_SpawnObj.Owner = 0;
		m_SpawnObj.Key = 1;
		m_SpawnObj.Period = 60;
		m_SpawnObj.PeriodEnemy = 120;
		m_SpawnObj.PeriodRnd = 0;
		m_SpawnObj.Tgt = "";
		m_SpawnObj.KeyMask = 0xffffff;
		m_SpawnObj.KeyEq = 1;
		m_SpawnObj.FindRadius = 9;
		m_SpawnObj.Del = true;
		m_SpawnObj.DamageProc = 70;
		m_SpawnObj.GroupMin = 1;
		m_SpawnObj.DelNoFlagship = true;

		begin = src.indexOf("// AutoSpawn " + m_MoveSectorX.toString() + "," + m_MoveSectorY.toString() + "," + m_MovePlanetNum.toString() + "\n");
		if (begin > 0) {
			linebegin = BaseStr.CodeNextLine(src, begin);
			lineend = BaseStr.CodeNextLine(src, linebegin);
			i = src.indexOf("Spawn(", linebegin);
			if (i < 0 || i >= lineend) src = "";
			else src = src.substring(linebegin, lineend);
		} else src = "";

		while (src.length > 0) {
			var cc:CodeCompiler = new CodeCompiler(new CodeSrc(src));
			//var env:CodeCompiler = new CodeCompiler();
			//env.setEnv("std", QEManager.m_Env);

			try {
				cc.parseFun();
				cc.prepare(QEManager.m_Env);

				if (cc.m_Src.err) {
//					FormMessageBox.RunErr("Compiler error: " + cc.m_Src.err.toString() + " line: " + (cc.m_Src.m_Line + 1).toString() + " char: " + (cc.m_Src.m_Char + 1).toString());
//					return;
					break;
				}
				var cr:Code = new Code();
				cr.m_Env = QEManager.m_Env;
				cr.importMethod("SpawnInit", stubSpawnInit);
				cr.importMethod("SpawnTgt", stubSpawnTgt);
				cr.importMethod("SpawnSearch", stubSpawnSearch);
				cr.importMethod("SpawnDestroy", stubSpawnDestroy);
				cr.importMethod("SpawnShip", stubSpawnShip);
				cr.importMethod("Spawn", stubSpawn);
				cr.importMethod("MakePtr", stubMakePtr);
				cr.runFun(cc);

			} catch (err:*) {
//				FormMessageBox.RunErr("Compiler exception: " + err.message);
//				return;
				break;
			}			

			break;
		} 
		while (src.length <= 0) {
			var planet:Planet = GetPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);
			if (!planet) break;

			var sl:Vector.<Ship> = new Vector.<Ship>();
			var sln:Vector.<int> = new Vector.<int>();

			route = false;
			atk = false;
			for (i = 0; i < planet.ShipOnPlanetLow; i++) {
				ship = planet.m_Ship[i];
				if (!ship.m_Type) continue;
				if (Common.IsBase(ship.m_Type)) continue;
				if (ship.m_Owner != 0 && !(ship.m_Owner & Common.OwnerAI)) continue;
				
				if (ship.m_Flag & Common.ShipFlagAIRoute) { route = true; }
				if (ship.m_Flag & Common.ShipFlagAIAttack) { atk = true; }
			}
			
			if(!route && atk) m_SpawnObj.FindRadius = 1;
			else if (!route) m_SpawnObj.FindRadius = 1;
			
			for (i = 0; i < planet.ShipOnPlanetLow; i++) {
				ship = planet.m_Ship[i];
				if (!ship.m_Type) continue;
				if ((route || (ship.m_Type != Common.ShipTypeWarBase && ship.m_Type != Common.ShipTypeQuarkBase)) && Common.IsBase(ship.m_Type)) continue;
				if (ship.m_Owner != 0 && !(ship.m_Owner & Common.OwnerAI)) continue;

				if (m_SpawnObj.Owner == 0) { m_SpawnObj.Owner = ship.m_Owner; sl.length = 0; }
				else if (m_SpawnObj.Owner != ship.m_Owner) continue;
				if (m_SpawnObj.Race == Common.RaceNone) m_SpawnObj.Race = ship.m_Race;
				if (m_SpawnObj.Key == 1) { m_SpawnObj.Key = ship.m_Group >>> 8; m_SpawnObj.KeyEq = m_SpawnObj.Key; }
				if (m_SpawnObj.Tgt.length <= 0 && ship.m_Link) {
					var planet2:Planet = Link(planet, ship);
					if (planet != null && planet2 != planet) m_SpawnObj.Tgt = planet2.m_Sector.m_SectorX.toString() + "," + planet2.m_Sector.m_SectorY.toString() + "," + planet2.m_PlanetNum.toString();
				}

				sl.push(ship);
				sln.push(i);

				if (sl.length >= Common.GroupInPlanetMax) break;
			}
			if (sl.length <= 0) break;
			
			m_SpawnObj.GroupMin = sl.length;

			var score:int, bscore:int;
			var sopl:int = planet.ShipOnPlanetLow;
			var k:int = 0;
			if(sl.length>1) {
				bscore = sopl - sln[sl.length - 1] + sln[0];
				for (i = 1; i < sl.length; i++) {
					score = sln[i] - sln[i - 1];

					if (score > bscore) {
						bscore = score;
						k = i;
					}
				}
			}
			
			var lastp:int = sln[k];
			for (i = 0; i < sl.length; i++, k++) {
				if (k >= sl.length) k = 0;
				ship = sl[k];
				
				shiptype = ship.m_Type;
				if (shiptype == Common.ShipTypeFlagship) {
					var user:User = UserList.Self.GetUser(ship.m_Owner);
					if (user) {
						var num:int = user.GetCptNum(ship.m_Id);
						if (num > 0) shiptype |= num << 16;
					}
				}

				if (sln[k] == lastp) skip = 0;
				else if (sln[k] > lastp) skip = (sln[k] - lastp) - 1;
				else skip = (sopl - lastp) + sln[k] - 1;

				stubSpawnShip(skip, (ship.m_Flag & Common.ShipFlagNoToBattle) != 0, shiptype, ship.m_Cnt, 
					(ship.m_Flag & Common.ShipFlagAIAttack) != 0,
					(ship.m_Flag & Common.ShipFlagAIRoute) != 0,
					Link(planet, ship) == planet,
					ship.m_Link != 0 && Link(planet, ship) != planet,
					ship.m_ItemType,
					ship.m_ItemCnt,
					ship.m_CargoType,
					ship.m_CargoCnt);

				lastp = sln[k];
			}

			break;
		}

		FI.Init(480, 420);
		FI.softLock = true;
		FI.caption = Common.TxtEdit.EditPlanetSpawn;

		FI.TabAdd(Common.TxtEdit.SpawnPageBase.toLowerCase());

		FI.AddLabel(Common.TxtEdit.Race+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.RaceName[Common.RaceNone], Common.RaceNone, m_SpawnObj.Race == Common.RaceNone);
		FI.AddItem(Common.RaceName[Common.RaceGrantar], Common.RaceGrantar, m_SpawnObj.Race == Common.RaceGrantar);
		FI.AddItem(Common.RaceName[Common.RacePeleng], Common.RacePeleng, m_SpawnObj.Race == Common.RacePeleng);
		FI.AddItem(Common.RaceName[Common.RacePeople], Common.RacePeople, m_SpawnObj.Race == Common.RacePeople);
		FI.AddItem(Common.RaceName[Common.RaceTechnol], Common.RaceTechnol, m_SpawnObj.Race == Common.RaceTechnol);
		FI.AddItem(Common.RaceName[Common.RaceGaal], Common.RaceGaal, m_SpawnObj.Race == Common.RaceGaal);
		FI.AddItem(Common.RaceName[Common.RaceKling], Common.RaceKling, m_SpawnObj.Race == Common.RaceKling);

		FI.AddLabel(Common.TxtEdit.Owner+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.OwnerNone, 0, 0 == 0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI0), Common.OwnerAI0, m_SpawnObj.Owner == Common.OwnerAI0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI1), Common.OwnerAI1, m_SpawnObj.Owner == Common.OwnerAI1);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI2), Common.OwnerAI2, m_SpawnObj.Owner == Common.OwnerAI2);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI3), Common.OwnerAI3, m_SpawnObj.Owner == Common.OwnerAI3);

		FI.AddLabel(Common.TxtEdit.SpawnKey+":");
		FI.Col();
		FI.AddInput(m_SpawnObj.Key.toString(16), 6, true, 0, false, "ABCDEFabcdef");

		FI.AddLabel(Common.TxtEdit.SpawnPeriod + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.Period.toString(), 8, true, 0, false);

		FI.AddLabel(Common.TxtEdit.SpawnPeriodIfEnemy + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.PeriodEnemy.toString(), 8, true, 0, false);

		FI.AddLabel(Common.TxtEdit.SpawnPeriodRnd + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.PeriodRnd.toString(), 8, true, 0, false);

		FI.AddLabel(Common.TxtEdit.SpawnTarget + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.Tgt, 16, true, 0, true, ",");

		FI.TabAdd(Common.TxtEdit.SpawnPageGroup.toLowerCase());

		FI.AddLabel(Common.TxtEdit.SpawnEmpty + ":");
		FI.Col();
		FI.AddLabel(Common.TxtEdit.SpawnNoToBattle + ":");
		FI.Col();
		FI.AddLabel(Common.TxtEdit.ShipType + ":");
		FI.Col();
		FI.AddLabel(Common.TxtEdit.SpawnCnt + ":");
		FI.Col();
		FI.AddLabel(Common.TxtEdit.SpawnTarget + ":");
		FI.Col();
		FI.AddLabel(Common.TxtEdit.SpawnAtk + ":");
		FI.Col();
		FI.AddLabel(Common.TxtEdit.SpawnRoute + ":");
			
		for (i = 0; i < 6; i++) {
			skip = 0;
			shiptype = 0;
			var notobattle:Boolean = false;
			var cnt:int = 0;
			var link:int = 0;
			var atk:Boolean = false;
			route = false;

			if (i < m_SpawnObj.Ship.length) {
				var s:Object = m_SpawnObj.Ship[i];
				skip = s.Skip;
				notobattle = s.NoToBattle;
				shiptype = s.Type;
				cnt = s.Cnt;
				atk = s.Atk;
				route = s.Route;
				if (s.LinkTgt) link = 2;
				else if (s.LinkSelf) link = 1;
			}

			FI.AddInput(skip.toString(), 1, true, 0, false);

			FI.Col();
			FI.AddCheckBox(notobattle, "");

			FI.Col();
			FI.AddComboBox().widthMin = 130;
			FI.AddItem(Common.ShipName[Common.ShipTypeNone], Common.ShipTypeNone, shiptype == Common.ShipTypeNone);
			FI.AddItem(Common.ShipName[Common.ShipTypeTransport], Common.ShipTypeTransport, shiptype == Common.ShipTypeTransport);
			FI.AddItem(Common.ShipName[Common.ShipTypeCorvette], Common.ShipTypeCorvette, shiptype == Common.ShipTypeCorvette);
			FI.AddItem(Common.ShipName[Common.ShipTypeCruiser], Common.ShipTypeCruiser, shiptype == Common.ShipTypeCruiser);
			FI.AddItem(Common.ShipName[Common.ShipTypeDreadnought], Common.ShipTypeDreadnought, shiptype == Common.ShipTypeDreadnought);
			FI.AddItem(Common.ShipName[Common.ShipTypeInvader], Common.ShipTypeInvader, shiptype == Common.ShipTypeInvader);
			FI.AddItem(Common.ShipName[Common.ShipTypeDevastator], Common.ShipTypeDevastator, shiptype == Common.ShipTypeDevastator);
			FI.AddItem(Common.ShipName[Common.ShipTypeWarBase], Common.ShipTypeWarBase, shiptype == Common.ShipTypeWarBase);
			FI.AddItem(Common.ShipName[Common.ShipTypeShipyard], Common.ShipTypeShipyard, shiptype == Common.ShipTypeShipyard);
			FI.AddItem(Common.ShipName[Common.ShipTypeSciBase], Common.ShipTypeSciBase, shiptype == Common.ShipTypeSciBase);
			FI.AddItem(Common.ShipName[Common.ShipTypeServiceBase], Common.ShipTypeServiceBase, shiptype == Common.ShipTypeServiceBase);
			FI.AddItem(Common.ShipName[Common.ShipTypeQuarkBase], Common.ShipTypeQuarkBase, shiptype == Common.ShipTypeQuarkBase);
			var sn:int = -1;
			if ((shiptype & 0xffff) == Common.ShipTypeFlagship) sn = shiptype >> 16;
			FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 1", Common.ShipTypeFlagship | (0 << 16), sn == 0);
			FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 2", Common.ShipTypeFlagship | (1 << 16), sn == 1);
			FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 3", Common.ShipTypeFlagship | (2 << 16), sn == 2);
			FI.AddItem(Common.ShipName[Common.ShipTypeKling0], Common.ShipTypeKling0, shiptype == Common.ShipTypeKling0);
			FI.AddItem(Common.ShipName[Common.ShipTypeKling1], Common.ShipTypeKling1, shiptype == Common.ShipTypeKling1);

			FI.Col();
			FI.AddInput(cnt.toString(), 6, true, 0, false).widthMin = 60;

			FI.Col();
			FI.AddComboBox().widthMin = 60;
			FI.AddItem(Common.TxtEdit.SpawnTargetNone, 0, link == 0);
			FI.AddItem(Common.TxtEdit.SpawnTargetSelf, 1, link == 1);
			FI.AddItem(Common.TxtEdit.SpawnTargetTgt, 2, link == 2);

			FI.Col();
			FI.AddCheckBox(atk, "");

			FI.Col();
			FI.AddCheckBox(route, "");
		}

		FI.TabAdd(Common.TxtEdit.SpawnPageEq.toLowerCase());

		FI.AddLabel("");
		FI.Col();
		FI.AddLabel(Common.TxtEdit.SpawnEq + ":");
		FI.Col();
		FI.AddLabel("");
		FI.Col();
		FI.AddLabel(Common.TxtEdit.SpawnCargo + ":");
		FI.Col();
		FI.AddLabel("");
		
		for (i = 0; i < 6; i++) {
			var itype:uint = 0;
			var icnt:int = 0;
			var ctype:uint = 0;
			var ccnt:int = 0;

			if (i < m_SpawnObj.Ship.length) {
				obj = m_SpawnObj.Ship[i];
				itype = obj.ItemType;
				icnt = obj.ItemCnt;
				ctype = obj.CargoType;
				ccnt = obj.CargoCnt;
			}

			FI.AddLabel("");

			FI.Col();
			FI.AddComboBox().widthMin = 130;
			FI.AddItem(Common.TxtEdit.BuildItemNone, Common.ItemTypeNone, itype == Common.ItemTypeNone);
			FI.AddItem(Common.ItemName[Common.ItemTypeArmour], Common.ItemTypeArmour, itype == Common.ItemTypeArmour);
			FI.AddItem(Common.ItemName[Common.ItemTypeArmour2], Common.ItemTypeArmour2, itype == Common.ItemTypeArmour2);
			FI.AddItem(Common.ItemName[Common.ItemTypePower], Common.ItemTypePower, itype == Common.ItemTypePower);
			FI.AddItem(Common.ItemName[Common.ItemTypePower2], Common.ItemTypePower2, itype == Common.ItemTypePower2);
			FI.AddItem(Common.ItemName[Common.ItemTypeRepair], Common.ItemTypeRepair, itype == Common.ItemTypeRepair);
			FI.AddItem(Common.ItemName[Common.ItemTypeRepair2], Common.ItemTypeRepair2, itype == Common.ItemTypeRepair2);
			FI.AddItem(Common.ItemName[Common.ItemTypeMonuk], Common.ItemTypeMonuk, itype == Common.ItemTypeMonuk);

			FI.Col();
			FI.AddInput(icnt.toString(), 6, true, 0, false).widthMin = 60;

			FI.Col();
			FI.AddComboBox().widthMin = 130;
			FI.AddItem(Common.TxtEdit.BuildItemNone, Common.ItemTypeNone, ctype == Common.ItemTypeNone);
			ar.length = 0;
			for (u = 0; u < Common.BuildingItem.length; u++) {
				obj = Common.BuildingItem[u];
				if (ar.indexOf(obj.ItemType) >= 0) continue;
				ar.push(obj.ItemType);
				FI.AddItem(Txt_ItemName(obj.ItemType), obj.ItemType, ctype == obj.ItemType);
			}

			FI.Col();
			FI.AddInput(ccnt.toString(), 6, true, 0, false).widthMin = 60;
		}

		FI.TabAdd(Common.TxtEdit.SpawnPageFind.toLowerCase());
		
		FI.AddLabel(Common.TxtEdit.SpawnKeyAnd + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.KeyMask.toString(16), 6, true, 0, false, "ABCDEFabcdef");
		
		FI.AddLabel(Common.TxtEdit.SpawnKeyEq + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.KeyEq.toString(16), 6, true, 0, false, "ABCDEFabcdef");

		FI.AddLabel(Common.TxtEdit.SpawnFindRadius + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.FindRadius.toString(), 2, true, 0, false);

		FI.TabAdd(Common.TxtEdit.SpawnPageDelete.toLowerCase());

		FI.AddCheckBox(m_SpawnObj.Del, Common.TxtEdit.SpawnDeleteOn);

		FI.AddLabel(Common.TxtEdit.SpawnDeleteProc + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.DamageProc.toString(), 3, true, 0, false);

		FI.AddLabel(Common.TxtEdit.SpawnDeleteGroup + ":");
		FI.Col();
		FI.AddInput(m_SpawnObj.GroupMin.toString(), 1, true, 0, false);

		FI.AddCheckBox(m_SpawnObj.DelNoFlagship, Common.TxtEdit.SpawnDeleteNoFlagship);

		if(IsEditCode()) {
			var but:CtrlBut = new CtrlBut();
			but.caption = Common.TxtEdit.SpawnDelete.toUpperCase();
			but.addEventListener(MouseEvent.CLICK, EditMapChangeSpawnDel);
			but.x = FI.innerLeft;
			but.y = FI.height - FI.innerBottom - but.height;
			FI.CtrlAdd(but);
		}

		FI.tab = 0;
		if (IsEditCode()) FI.Run(EditMapChangeSpawnSend, Common.TxtEdit.SpawnSave, StdMap.Txt.ButCancel);
		else FI.Run(null, null, StdMap.Txt.ButCancel);
	}

	public function EditMapChangeSpawnSend():void
	{
		CodeQuery(EditMapChangeSpawnSend2);
	}

	public function EditMapChangeSpawnSend2(src:String):void
	{
		var tab:int, begin:int, linebegin:int, lineend:int, i:int;
		var str:String;

		var newcode:String = "";
		
		var no:int = 0;
		var race:int = FI.GetInt(no++);
		var owner:uint = FI.GetInt(no++);
		var key:uint = BaseStr.ParseUint(FI.GetStr(no++), 16);
		var period:uint = FI.GetInt(no++);
		var periodenemy:uint = FI.GetInt(no++);
		var periodrnd:uint = FI.GetInt(no++);

		newcode += "SpawnInit(MakePtr(" + m_MoveSectorX.toString() + "," + m_MoveSectorY.toString() + "," + m_MovePlanetNum.toString() + ")";
		newcode += ",";
		if (race == Common.RaceGrantar) newcode += "RaceGrantar";
		else if (race == Common.RacePeleng) newcode += "RacePeleng";
		else if (race == Common.RacePeople) newcode += "RacePeople";
		else if (race == Common.RaceTechnol) newcode += "RaceTechnol";
		else if (race == Common.RaceGaal) newcode += "RaceGaal";
		else if (race == Common.RaceKling) newcode += "RaceKling";
		else newcode += "RaceNone";
		newcode += ",";
		if (owner == Common.OwnerAI0) newcode += "OwnerAI0";
		else if (owner == Common.OwnerAI1) newcode += "OwnerAI1";
		else if (owner == Common.OwnerAI2) newcode += "OwnerAI2";
		else if (owner == Common.OwnerAI3) newcode += "OwnerAI3";
		else newcode += "OwnerAI0";
		newcode += ",";
		newcode += "0x" + key.toString(16);
		newcode += ",";
		newcode += period.toString();
		newcode += ",";
		newcode += periodenemy.toString();
		newcode += ",";
		newcode += periodrnd.toString();
		newcode += ");";

		str = FI.GetStr(no++);
		if (str.split(",").length == 3) newcode += " SpawnTgt(MakePtr(" + str + "));";

		var offi:int = no + 7 * 6;
		for (i = 0; i < 6; i++) {
			var skip:int = FI.GetInt(no++);
			var notobattle:Boolean = FI.GetInt(no++) != 0;
			var shiptype:uint = FI.GetInt(no++);
			var cnt:int = FI.GetInt(no++);
			var st:int = FI.GetInt(no++);
			var atk:Boolean = FI.GetInt(no++) != 0;
			var route:Boolean = FI.GetInt(no++) != 0;
			
			var itype:uint = FI.GetInt(offi + 4 * i + 0);
			var icnt:uint = FI.GetInt(offi + 4 * i + 1);
			var ctype:uint = FI.GetInt(offi + 4 * i + 2);
			var ccnt:uint = FI.GetInt(offi + 4 * i + 3);
			
			if (skip == 0 && notobattle == false && shiptype == Common.ShipTypeNone && cnt == 0 && st == 0 && atk == false && route == false) continue;
			
			newcode += " SpawnShip(";
			newcode += skip.toString();
			newcode += ",";
			newcode += notobattle?"true":"false";
			newcode += ",";
			if (shiptype == Common.ShipTypeTransport) newcode += "ShipTypeTransport";
			else if (shiptype == Common.ShipTypeCorvette) newcode += "ShipTypeCorvette";
			else if (shiptype == Common.ShipTypeCruiser) newcode += "ShipTypeCruiser";
			else if (shiptype == Common.ShipTypeDreadnought) newcode += "ShipTypeDreadnought";
			else if (shiptype == Common.ShipTypeInvader) newcode += "ShipTypeInvader";
			else if (shiptype == Common.ShipTypeDevastator) newcode += "ShipTypeDevastator";
			else if (shiptype == Common.ShipTypeWarBase) newcode += "ShipTypeWarBase";
			else if (shiptype == Common.ShipTypeShipyard) newcode += "ShipTypeShipyard";
			else if (shiptype == Common.ShipTypeKling0) newcode += "ShipTypeKling0";
			else if (shiptype == Common.ShipTypeKling1) newcode += "ShipTypeKling1";
			else if (shiptype == Common.ShipTypeSciBase) newcode += "ShipTypeSciBase";
			else if ((shiptype | (0 << 16)) == (Common.ShipTypeFlagship | (0 << 16))) newcode += "ShipTypeFlagship | (0<<16)";
			else if ((shiptype | (1 << 16)) == (Common.ShipTypeFlagship | (1 << 16))) newcode += "ShipTypeFlagship | (1<<16)";
			else if ((shiptype | (2 << 16)) == (Common.ShipTypeFlagship | (2 << 16))) newcode += "ShipTypeFlagship | (2<<16)";
			else if (shiptype == Common.ShipTypeServiceBase) newcode += "ShipTypeServiceBase";
			else if (shiptype == Common.ShipTypeQuarkBase) newcode += "ShipTypeQuarkBase";
			else if (shiptype == Common.ShipTypeNone) newcode += "ShipTypeNone";
			newcode += ",";
			newcode += cnt.toString();
			newcode += ",";
			newcode += atk.toString();
			newcode += ",";
			newcode += route.toString();
			newcode += ",";
			if (st == 0) newcode += "false,false";
			else if (st == 1) newcode += "true,false";
			else newcode += "true,true";
			if(itype!=0 || icnt!=0 || ctype!=0 || ccnt!=0) {
				newcode += ",";
				if (itype < Common.ItemTypeCnt) newcode += Common.ItemTypeSysName[itype];
				else newcode += "0x" + itype.toString(16);
				newcode += ",";
				newcode += icnt.toString();
				newcode += ",";
				if (ctype < Common.ItemTypeCnt) newcode += Common.ItemTypeSysName[ctype];
				else newcode += "0x" + ctype.toString(16);
				newcode += ",";
				newcode += ccnt.toString();
			}
			newcode += ");"
		}
		no += 4 * 6;

		var keyand:uint = BaseStr.ParseUint(FI.GetStr(no++), 16);
		var keyeq:uint = BaseStr.ParseUint(FI.GetStr(no++), 16);
		var radius:int = FI.GetInt(no++);
		
		newcode += " SpawnSearch(";
		newcode += "0x" + keyand.toString(16);
		newcode += ",";
		newcode += "0x" + keyeq.toString(16);
		newcode += ",";
		newcode += radius.toString();
		newcode += ");";

		var del:Boolean = FI.GetInt(no++) != 0;
		var delproc:int = FI.GetInt(no++);
		var delgroup:int = FI.GetInt(no++);
		var delnoflagship:Boolean = FI.GetInt(no++) != 0;

		newcode += " SpawnDestroy(";
		newcode += del?"true":"false";
		newcode += ",";
		newcode += delproc.toString();
		newcode += ",";
		newcode += delgroup.toString();
		newcode += ",";
		newcode += delnoflagship?"true":"false";
		newcode += ");";

		newcode += " Spawn();\n";

		if (BaseStr.Trim(src).length <= 0) {
			src = "while(true) {\n";
			src += "\twait;\n";
			src += "\t// AutoSpawnNew\n";
			src += "}\n";
		}

		var space:String = "";
		begin = src.indexOf("// AutoSpawn " + m_MoveSectorX.toString() + "," + m_MoveSectorY.toString() + "," + m_MovePlanetNum.toString() + "\n");
		if (begin > 0) {
			linebegin = BaseStr.CodeNextLine(src, begin);
			lineend = BaseStr.CodeNextLine(src, linebegin);
			i = src.indexOf("Spawn(", linebegin);
			if (i < 0 || i >= lineend) { FI.Show(); FormMessageBox.RunErr(Common.Txt.SpawnCodeError); return; }
			space = BaseStr.CodeExtractSpace(src, begin);
			src = src.substr(0, linebegin) + space + newcode + src.substr(lineend);
		} else {
			begin = src.indexOf("// AutoSpawnNew\n");
			if (i < 0) { FI.Show(); FI.Show(); FormMessageBox.RunErr(Common.Txt.SpawnCodeErrorNotNew); return; }
			space = BaseStr.CodeExtractSpace(src, begin);
			
			newcode = "// AutoSpawn " + m_MoveSectorX.toString() + "," + m_MoveSectorY.toString() + "," + m_MovePlanetNum.toString() +"\n" + space + newcode;

			src = src.substr(0, begin) + newcode + space + src.substr(begin);
		}

		CodeSend(src);
	}

	public function EditMapChangeSpawnDel(event:Event):void
	{
		FI.Hide();
		CodeQuery(EditMapChangeSpawnDel2);
	}

	public function EditMapChangeSpawnDel2(src:String):void
	{
		if (BaseStr.Trim(src).length <= 0) return;

		var space:String = "";
		var begin:int = src.indexOf("// AutoSpawn " + m_MoveSectorX.toString() + "," + m_MoveSectorY.toString() + "," + m_MovePlanetNum.toString() + "\n");
		if (begin <= 0) return;

		var linebegin:int = BaseStr.CodeNextLine(src, begin);
		var lineend:int = BaseStr.CodeNextLine(src, linebegin);
		var i:int = src.indexOf("Spawn(", linebegin);
		if (i < 0 || i >= lineend) return;
		linebegin = BaseStr.CodeBeginLine(src, begin);
		src = src.substr(0, linebegin) + src.substr(lineend);

		CodeSend(src);
	}

	public function EditMapOpenPlanet(...args):void
	{
		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if (planet == null) return;

		if ((planet.m_Flag & Planet.PlanetFlagWormhole)!=0) return;
		m_FormPlanet.Show(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
	}
	
	public function EditMapCloseWormhole(...args):void
	{
		SendAction("emportal", "" + m_CurSectorX + "_" + m_CurSectorY + "_" + m_CurPlanetNum + "_" + (-1).toString() + "_" + m_CurSectorX + "_" + m_CurSectorY + "_" + m_CurPlanetNum);
	}
	
	public function EditMapOpenWormhole(...args):void
	{
		var planet:Planet=GetPlanet(m_CurSectorX,m_CurSectorY,m_CurPlanetNum);
		if (planet == null) return;

		if ((planet.m_Flag & Planet.PlanetFlagWormhole) == 0) return;
		
		m_MoveSectorX=m_CurSectorX;
		m_MoveSectorY=m_CurSectorY;
		m_MovePlanetNum=m_CurPlanetNum;
		m_MoveShipNum=-1;
		m_MoveOwner=0;
		m_MoveListNum.length=0;
		m_MovePath.length=0;

		m_Action=ActionPortal;
		CalcPick(mouseX,mouseY);
		InfoUpdate(mouseX,mouseY);
	}

	public function EditMapAddShip(...args):void
	{
		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;
		
		FI.Init(400, 300);
		FI.caption = Common.TxtEdit.AddShip;
		FI.softLock = true;

		FI.AddLabel(Common.TxtEdit.ShipType+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.ShipName[Common.ShipTypeTransport], Common.ShipTypeTransport);
		FI.AddItem(Common.ShipName[Common.ShipTypeCorvette], Common.ShipTypeCorvette, true);
		FI.AddItem(Common.ShipName[Common.ShipTypeCruiser], Common.ShipTypeCruiser);
		FI.AddItem(Common.ShipName[Common.ShipTypeDreadnought], Common.ShipTypeDreadnought);
		FI.AddItem(Common.ShipName[Common.ShipTypeInvader], Common.ShipTypeInvader);
		FI.AddItem(Common.ShipName[Common.ShipTypeDevastator], Common.ShipTypeDevastator);
		FI.AddItem(Common.ShipName[Common.ShipTypeWarBase], Common.ShipTypeWarBase);
		FI.AddItem(Common.ShipName[Common.ShipTypeShipyard], Common.ShipTypeShipyard);
		FI.AddItem(Common.ShipName[Common.ShipTypeSciBase], Common.ShipTypeSciBase);
		FI.AddItem(Common.ShipName[Common.ShipTypeServiceBase], Common.ShipTypeServiceBase);
		FI.AddItem(Common.ShipName[Common.ShipTypeQuarkBase], Common.ShipTypeQuarkBase);
		FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 1", Common.ShipTypeFlagship | (0 << 16));
		FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 2", Common.ShipTypeFlagship | (1 << 16));
		FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 3", Common.ShipTypeFlagship | (2 << 16));
		FI.AddItem(Common.ShipName[Common.ShipTypeKling0], Common.ShipTypeKling0);
		FI.AddItem(Common.ShipName[Common.ShipTypeKling1], Common.ShipTypeKling1);

		FI.AddLabel(Common.TxtEdit.Race+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.RaceName[Common.RaceNone], Common.RaceNone, planet.m_Race == Common.RaceNone);
		FI.AddItem(Common.RaceName[Common.RaceGrantar], Common.RaceGrantar, planet.m_Race == Common.RaceGrantar);
		FI.AddItem(Common.RaceName[Common.RacePeleng], Common.RacePeleng, planet.m_Race == Common.RacePeleng);
		FI.AddItem(Common.RaceName[Common.RacePeople], Common.RacePeople, planet.m_Race == Common.RacePeople);
		FI.AddItem(Common.RaceName[Common.RaceTechnol], Common.RaceTechnol, planet.m_Race == Common.RaceTechnol);
		FI.AddItem(Common.RaceName[Common.RaceGaal], Common.RaceGaal, planet.m_Race == Common.RaceGaal);
		FI.AddItem(Common.RaceName[Common.RaceKling], Common.RaceKling, planet.m_Race == Common.RaceKling);

		FI.AddLabel(Common.TxtEdit.Owner+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.OwnerNone,0,planet.m_Owner==0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI0), Common.OwnerAI0, planet.m_Owner == Common.OwnerAI0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI1), Common.OwnerAI1, planet.m_Owner == Common.OwnerAI1);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI2), Common.OwnerAI2, planet.m_Owner == Common.OwnerAI2);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI3), Common.OwnerAI3, planet.m_Owner == Common.OwnerAI3);

		FI.AddLabel(Common.TxtEdit.Cnt + ":");
		FI.Col();
		FI.AddInput("1", 7, true);

		FI.Run(EditMapAddShipSend, Common.TxtEdit.ButAdd, StdMap.Txt.ButCancel);
	}

	public function EditMapAddShipSend():void
	{
		var planet:Planet = GetPlanet(m_CurSectorX, m_CurSectorY, m_CurPlanetNum);
		if (planet == null) return;

		var kk:int = 0;
		var type:int = FI.GetInt(kk++);
		var race:int = FI.GetInt(kk++);
		var owner:uint = FI.GetInt(kk++);
		var cnt:int = FI.GetInt(kk++);

		var id:uint = 0;
		if ((type & 0xffff) == Common.ShipTypeFlagship) {
			if (!(owner & Common.OwnerAI)) return;
			id = 0xffffff00 | ((owner & 15) << 4) | (type >> 16);
			type &= 0xffff;
		} else {
			id = NewShipId(Server.Self.m_UserId);
			if (id == 0) return;
		}

		Server.Self.Query("emedcotlspecial", "&type=10&val=" + m_CurSectorX.toString() + "_" + m_CurSectorY.toString() + "_" + m_CurPlanetNum.toString() + "_-1"
			+"_" + id.toString()
			+"_" + type.toString()
			+"_" + race.toString()
			+"_" + owner.toString()
			+"_" + cnt.toString()
			+"_" + (0).toString()
			+"_" + (0).toString()
			+"_" + (0).toString()
			+"_" + (0).toString()
			+"_" + (0).toString()
			,EditMapChangeSizeRecv, false);
	}

	public function EditMapChangeShip(...args):void
	{
		var i:int;
		var obj:Object;
		var ar:Array = new Array();
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if(ship==null) return;

		FI.Init(400, 450);
		FI.caption = Common.TxtEdit.EditShip;
		FI.softLock = true;

		FI.AddLabel(Common.TxtEdit.ShipType + ":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.ShipName[Common.ShipTypeNone], Common.ShipTypeNone, ship.m_Type == Common.ShipTypeNone);
		FI.AddItem(Common.ShipName[Common.ShipTypeTransport], Common.ShipTypeTransport, ship.m_Type == Common.ShipTypeTransport);
		FI.AddItem(Common.ShipName[Common.ShipTypeCorvette], Common.ShipTypeCorvette, ship.m_Type == Common.ShipTypeCorvette);
		FI.AddItem(Common.ShipName[Common.ShipTypeCruiser], Common.ShipTypeCruiser, ship.m_Type == Common.ShipTypeCruiser);
		FI.AddItem(Common.ShipName[Common.ShipTypeDreadnought], Common.ShipTypeDreadnought, ship.m_Type == Common.ShipTypeDreadnought);
		FI.AddItem(Common.ShipName[Common.ShipTypeInvader], Common.ShipTypeInvader, ship.m_Type == Common.ShipTypeInvader);
		FI.AddItem(Common.ShipName[Common.ShipTypeDevastator], Common.ShipTypeDevastator, ship.m_Type == Common.ShipTypeDevastator);
		FI.AddItem(Common.ShipName[Common.ShipTypeWarBase], Common.ShipTypeWarBase, ship.m_Type == Common.ShipTypeWarBase);
		FI.AddItem(Common.ShipName[Common.ShipTypeShipyard], Common.ShipTypeShipyard, ship.m_Type == Common.ShipTypeShipyard);
		FI.AddItem(Common.ShipName[Common.ShipTypeSciBase], Common.ShipTypeSciBase, ship.m_Type == Common.ShipTypeSciBase);
		FI.AddItem(Common.ShipName[Common.ShipTypeServiceBase], Common.ShipTypeServiceBase, ship.m_Type == Common.ShipTypeServiceBase);
		FI.AddItem(Common.ShipName[Common.ShipTypeQuarkBase], Common.ShipTypeQuarkBase, ship.m_Type == Common.ShipTypeQuarkBase);
		var sn:int = -1;
		if (ship.m_Type == Common.ShipTypeFlagship) {
			var user:User = UserList.Self.GetUser(ship.m_Owner);
			if (user != null) sn = user.GetCptNum(ship.m_Id);
		}
		FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 1", Common.ShipTypeFlagship | (0 << 16), sn == 0);
		FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 2", Common.ShipTypeFlagship | (1 << 16), sn == 1);
		FI.AddItem(Common.ShipName[Common.ShipTypeFlagship] + " 3", Common.ShipTypeFlagship | (2 << 16), sn == 2);
		FI.AddItem(Common.ShipName[Common.ShipTypeKling0], Common.ShipTypeKling0, ship.m_Type == Common.ShipTypeKling0);
		FI.AddItem(Common.ShipName[Common.ShipTypeKling1], Common.ShipTypeKling1, ship.m_Type == Common.ShipTypeKling1);

		FI.AddLabel(Common.TxtEdit.Race+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.RaceName[Common.RaceNone],Common.RaceNone,ship.m_Race==Common.RaceNone);
		FI.AddItem(Common.RaceName[Common.RaceGrantar],Common.RaceGrantar,ship.m_Race==Common.RaceGrantar);
		FI.AddItem(Common.RaceName[Common.RacePeleng],Common.RacePeleng,ship.m_Race==Common.RacePeleng);
		FI.AddItem(Common.RaceName[Common.RacePeople],Common.RacePeople,ship.m_Race==Common.RacePeople);
		FI.AddItem(Common.RaceName[Common.RaceTechnol],Common.RaceTechnol,ship.m_Race==Common.RaceTechnol);
		FI.AddItem(Common.RaceName[Common.RaceGaal],Common.RaceGaal,ship.m_Race==Common.RaceGaal);
		FI.AddItem(Common.RaceName[Common.RaceKling],Common.RaceKling,ship.m_Race==Common.RaceKling);

		FI.AddLabel(Common.TxtEdit.Owner+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.OwnerNone, 0, ship.m_Owner == 0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI0), Common.OwnerAI0, ship.m_Owner == Common.OwnerAI0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI1), Common.OwnerAI1, ship.m_Owner == Common.OwnerAI1);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI2), Common.OwnerAI2, ship.m_Owner == Common.OwnerAI2);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI3), Common.OwnerAI3, ship.m_Owner == Common.OwnerAI3);
		if (ship.m_Owner != 0 && (ship.m_Owner & Common.OwnerAI) == 0) FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, ship.m_Owner), ship.m_Owner, true);

		FI.AddLabel(Common.TxtEdit.Cnt + ":");
		FI.Col();
		FI.AddInput(ship.m_Cnt.toString(), 7, true);

		FI.AddLabel(Common.TxtEdit.Eq + ":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.BuildItemNone, Common.ItemTypeNone, ship.m_ItemType == Common.ItemTypeNone);
		FI.AddItem(Common.ItemName[Common.ItemTypeArmour], Common.ItemTypeArmour, ship.m_ItemType == Common.ItemTypeArmour);
		FI.AddItem(Common.ItemName[Common.ItemTypeArmour2], Common.ItemTypeArmour2, ship.m_ItemType == Common.ItemTypeArmour2);
		FI.AddItem(Common.ItemName[Common.ItemTypePower], Common.ItemTypePower, ship.m_ItemType == Common.ItemTypePower);
		FI.AddItem(Common.ItemName[Common.ItemTypePower2], Common.ItemTypePower2, ship.m_ItemType == Common.ItemTypePower2);
		FI.AddItem(Common.ItemName[Common.ItemTypeRepair], Common.ItemTypeRepair, ship.m_ItemType == Common.ItemTypeRepair);
		FI.AddItem(Common.ItemName[Common.ItemTypeRepair2], Common.ItemTypeRepair2, ship.m_ItemType == Common.ItemTypeRepair2);
		FI.AddItem(Common.ItemName[Common.ItemTypeMonuk], Common.ItemTypeMonuk, ship.m_ItemType == Common.ItemTypeMonuk);

		FI.AddLabel(Common.TxtEdit.EqCnt+":");
		FI.Col();
		FI.AddInput(ship.m_ItemCnt.toString(), 7, true);

		FI.AddLabel(Common.TxtEdit.Cargo + ":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.BuildItemNone, Common.ItemTypeNone, ship.m_CargoType == Common.ItemTypeNone);
		for (i = 0; i < Common.BuildingItem.length; i++) {
			obj = Common.BuildingItem[i];
			if (ar.indexOf(obj.ItemType) >= 0) continue;
			ar.push(obj.ItemType);
			FI.AddItem(Txt_ItemName(obj.ItemType), obj.ItemType, ship.m_CargoType == obj.ItemType);
		}

		FI.AddLabel(Common.TxtEdit.CargoCnt+":");
		FI.Col();
		FI.AddInput(ship.m_CargoCnt.toString(), 7, true);

		FI.AddLabel(Common.TxtEdit.SpawnKey+":");
		FI.Col();
		FI.AddInput(((ship.m_Group >>> 8)).toString(16), 6, true, 0, false, "ABCDEFabcdef");

		if (IsEditMap()) FI.Run(EditMapEditShipSend, Common.TxtEdit.ButEdit, StdMap.Txt.ButCancel);
		else FI.Run(null, null, StdMap.Txt.ButCancel);
	}

	public function EditMapEditShipSend():void
	{
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if(ship==null) return;

		var kk:int = 0;
		var type:int = FI.GetInt(kk++);
		var race:int = FI.GetInt(kk++);
		var owner:uint = FI.GetInt(kk++);
		var cnt:int = FI.GetInt(kk++);
		var eq:int = FI.GetInt(kk++);
		var eqcnt:int = FI.GetInt(kk++);
		var cargotype:int = FI.GetInt(kk++);
		var cargocnt:int = FI.GetInt(kk++);
		var key:uint = BaseStr.ParseUint(FI.GetStr(kk++), 16);

		var id:uint = 0;
		if ((type & 0xffff) == Common.ShipTypeFlagship) {
			if (!(owner & Common.OwnerAI)) {
				var user:User = UserList.Self.GetUser(owner);
				if (!user) return;
				id = user.m_Cpt[type >> 16].m_Id;
			} else {
				id = 0xffffff00 | ((owner & 15) << 4) | (type >> 16);
			}
			type &= 0xffff;
		} else {
			id = NewShipId(Server.Self.m_UserId);
			if (id == 0) return;
		}

		Server.Self.Query("emedcotlspecial", "&type=10&val=" + m_CurSectorX.toString() + "_" + m_CurSectorY.toString() + "_" + m_CurPlanetNum.toString() + "_" + m_CurShipNum.toString()
			+"_" + id.toString()
			+"_" + type.toString()
			+"_" + race.toString()
			+"_" + owner.toString()
			+"_" + cnt.toString()
			+"_" + eq.toString()
			+"_" + eqcnt.toString()
			+"_" + cargotype.toString()
			+"_" + cargocnt.toString()
			+"_" + key.toString(16)
			,EditMapChangeSizeRecv,false);
	}
	
	public function EditMapDeleteShip(...args):void
	{
		FormHideAll();
		FormMessageBox.Run(Common.TxtEdit.DeleteShipQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,EditMapDeleteShipSend);
	}
	
	public function EditMapDeleteShipSend():void
	{
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if(ship==null) return;

		Server.Self.Query("emedcotlspecial", "&type=10&val=" + m_CurSectorX.toString() + "_" + m_CurSectorY.toString() + "_" + m_CurPlanetNum.toString() + "_" + m_CurShipNum.toString()
			+"_0_0_0_0_0_0_0_0_0_0"
			,EditMapChangeSizeRecv, false);
	}

	public function EditMapChangeOrbitItem(...args):void
	{
		var i:int;
		var obj:Object;
		var ar:Array = new Array();

		var ship:Ship = GetShip(m_CurSectorX, m_CurSectorY, m_CurPlanetNum, m_CurShipNum);
		if (ship == null) return;

		FI.Init(400, 250);
		FI.caption = Common.TxtEdit.EditOrbitItem;
		FI.softLock = true;

		FI.AddLabel(Common.TxtEdit.ItemType + ":");
		FI.Col();
		FI.AddComboBox();
		for (i = 0; i < Common.BuildingItem.length; i++) {
			obj = Common.BuildingItem[i];
			if (ar.indexOf(obj.ItemType) >= 0) continue;
			ar.push(obj.ItemType);
			FI.AddItem(Txt_ItemName(obj.ItemType), obj.ItemType, ship.m_OrbitItemType == obj.ItemType);
		}

		FI.AddLabel(Common.TxtEdit.Owner + ":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.TxtEdit.OwnerNone,0,ship.m_OrbitItemOwner==0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI0), Common.OwnerAI0, ship.m_OrbitItemOwner == Common.OwnerAI0);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI1), Common.OwnerAI1, ship.m_OrbitItemOwner == Common.OwnerAI1);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI2), Common.OwnerAI2, ship.m_OrbitItemOwner == Common.OwnerAI2);
		FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, Common.OwnerAI3), Common.OwnerAI3, ship.m_OrbitItemOwner == Common.OwnerAI3);
		if (ship.m_OrbitItemOwner != 0 && (ship.m_OrbitItemOwner & Common.OwnerAI) == 0) FI.AddItem(Txt_CotlOwnerName(Server.Self.m_CotlId, ship.m_OrbitItemOwner), ship.m_OrbitItemOwner, true);

		FI.AddLabel(Common.TxtEdit.Cnt+":");
		FI.Col();
		FI.AddInput(ship.m_OrbitItemCnt.toString(),7,true);

		if (IsEditMap()) FI.Run(EditMapEditOrbitItemSend, Common.TxtEdit.ButEdit, StdMap.Txt.ButCancel);
		else FI.Run(null, null, StdMap.Txt.ButCancel);
	}
	
	public function EditMapEditOrbitItemSend():void
	{
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if(ship==null) return;

		var type:int = FI.GetInt(0);
		var owner:uint = FI.GetInt(1);
		var cnt:int = FI.GetInt(2);

		var id:uint = NewShipId(Server.Self.m_UserId);
		if (id == 0) return;

		Server.Self.Query("emedcotlspecial","&type=15&val="+m_CurSectorX.toString()+"_"+m_CurSectorY.toString()+"_"+m_CurPlanetNum.toString()+"_"+m_CurShipNum.toString()
			+"_"+type.toString()
			+"_"+owner.toString()
			+"_"+cnt.toString()
			,EditMapChangeSizeRecv,false);
	}

	public function EditMapDeleteOrbitItem(...args):void
	{
		FormHideAll();
		FormMessageBox.Run(Common.TxtEdit.DeleteOrbitItemQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,EditMapDeleteOrbitItemSend);
	}
	
	public function EditMapDeleteOrbitItemSend():void
	{
		var ship:Ship=GetShip(m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
		if(ship==null) return;
		
		Server.Self.Query("emedcotlspecial","&type=15&val="+m_CurSectorX.toString()+"_"+m_CurSectorY.toString()+"_"+m_CurPlanetNum.toString()+"_"+m_CurShipNum.toString()
			+"_0_0_0"
			,EditMapChangeSizeRecv,false);
	}

	private var m_EditMapOptionsAI:uint=0; 		
	public function EditMapOptionsAI(obj:Object, owner:uint):void
	{
		var i:int;
		
		var user:User=UserList.Self.GetUser(owner);
		if(user==null) return;

		m_EditMapOptionsAI=owner;

		FI.Init(400, 500);// 3);
		FI.caption = Common.TxtEdit.OwnerOptions + " (" + (owner & 15).toString() + ")";
		//FI.SetColSize(0, 0, 100);
		//FI.SetColSize(0, 2, 80);

		FI.AddLabel(Common.TxtEdit.Name + ":");
		FI.Col();
		FI.AddInput(Txt_CotlOwnerName(Server.Self.m_CotlId,m_EditMapOptionsAI),31,true,Server.Self.m_Lang,false);

		FI.AddLabel(Common.TxtEdit.Team+":");
		FI.Col();
		FI.AddComboBox();
		for(i=0;i<(1<<Common.TeamMaxShift);i++) {
			FI.AddItem(String.fromCharCode(65 + i), i, i == user.m_Team);
		}

		FI.AddLabel(Common.TxtEdit.Race+":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem(Common.RaceName[Common.RaceNone],Common.RaceNone,user.m_Race==Common.RaceNone);
		FI.AddItem(Common.RaceName[Common.RaceGrantar],Common.RaceGrantar,user.m_Race==Common.RaceGrantar);
		FI.AddItem(Common.RaceName[Common.RacePeleng],Common.RacePeleng,user.m_Race==Common.RacePeleng);
		FI.AddItem(Common.RaceName[Common.RacePeople],Common.RacePeople,user.m_Race==Common.RacePeople);
		FI.AddItem(Common.RaceName[Common.RaceTechnol],Common.RaceTechnol,user.m_Race==Common.RaceTechnol);
		FI.AddItem(Common.RaceName[Common.RaceGaal],Common.RaceGaal,user.m_Race==Common.RaceGaal);
		FI.AddItem(Common.RaceName[Common.RaceKling],Common.RaceKling,user.m_Race==Common.RaceKling);

		FI.AddLabel(Common.TxtEdit.PowerMul + ":");
		FI.Col();
		FI.AddInput(Math.round(user.m_PowerMul * 100 / 256).toString(), 6, true, 0, false);

		FI.AddLabel(Common.TxtEdit.ManufMul + ":");
		FI.Col();
		FI.AddInput((user.m_ManufMul).toString(), 6, true, 0, false);

		FI.AddCheckBox((user.m_Flag & Common.UserFlagVisAll) != 0, Common.TxtEdit.VisAll);
//		FI.AddCheckBox((user.m_Flag & Common.UserFlagAutoProgress) != 0, Common.TxtEdit.AutoProgress);
		FI.AddCheckBox((user.m_Flag & Common.UserFlagPlayerControl) != 0, Common.TxtEdit.PlayerControl);
		FI.AddCheckBox((user.m_Flag & Common.UserFlagImportIfEnemy) != 0, Common.TxtEdit.ImportIfEnemy);

		FI.AddLabel(Common.TxtEdit.CptAI0 + ":");
		FI.Col();
		var cpt0i:CtrlInput = FI.AddInput(Txt_CptName(Server.Self.m_CotlId, owner, 0xffffff00 | ((owner & 15) << 4) | (0)), 15, true, Server.Self.m_Lang, false);

		FI.AddLabel(Common.TxtEdit.CptAI1 + ":");
		FI.Col();
		var cpt1i:CtrlInput = FI.AddInput(Txt_CptName(Server.Self.m_CotlId, owner, 0xffffff00 | ((owner & 15) << 4) | (1)), 15, true, Server.Self.m_Lang, false);

		FI.AddLabel(Common.TxtEdit.CptAI2 + ":");
		FI.Col();
		var cpt2i:CtrlInput = FI.AddInput(Txt_CptName(Server.Self.m_CotlId, owner, 0xffffff00 | ((owner & 15) << 4) | (2)), 15, true, Server.Self.m_Lang, false);
		
		var btn0:CtrlBut = new CtrlBut();
		btn0.caption = "TECH";
		btn0.addEventListener(MouseEvent.CLICK, EditMapOptionsAICpt0);
		FI.CtrlAdd(btn0);

		var btn1:CtrlBut = new CtrlBut();
		btn1.caption = "TECH";
		btn1.addEventListener(MouseEvent.CLICK, EditMapOptionsAICpt1);
		FI.CtrlAdd(btn1);

		var btn2:CtrlBut = new CtrlBut();
		btn2.caption = "TECH";
		btn2.addEventListener(MouseEvent.CLICK, EditMapOptionsAICpt2);
		FI.CtrlAdd(btn2);

		FI.Run(EditMapOptionsAISend,Common.TxtEdit.ButEdit,StdMap.Txt.ButCancel);

		cpt0i.width = cpt0i.width - btn0.width - 10;
		btn0.x = FI.contentX + cpt0i.x + cpt0i.width + 10;
		btn0.y = FI.contentY + cpt0i.y;

		cpt1i.width = cpt1i.width - btn1.width - 10;
		btn1.x = FI.contentX + cpt1i.x + cpt1i.width + 10;
		btn1.y = FI.contentY + cpt1i.y;

		cpt2i.width = cpt2i.width - btn2.width - 10;
		btn2.x = FI.contentX + cpt2i.x + cpt2i.width + 10;
		btn2.y = FI.contentY + cpt2i.y;
	}
	
	public function EditMapOptionsAICpt0(e:Event):void
	{
		FI.Hide();
		m_FormTalent.m_Owner = m_EditMapOptionsAI;
		m_FormTalent.m_CptId = 0xffffff00 | ((m_EditMapOptionsAI & 15) << 4) | 0;
		m_FormTalent.Show();
	}

	public function EditMapOptionsAICpt1(e:Event):void
	{
		FI.Hide();
		m_FormTalent.m_Owner = m_EditMapOptionsAI;
		m_FormTalent.m_CptId = 0xffffff00 | ((m_EditMapOptionsAI & 15) << 4) | 1;
		m_FormTalent.Show();
	}

	public function EditMapOptionsAICpt2(e:Event):void
	{
		FI.Hide();
		m_FormTalent.m_Owner = m_EditMapOptionsAI;
		m_FormTalent.m_CptId = 0xffffff00 | ((m_EditMapOptionsAI & 15) << 4) | 2;
		m_FormTalent.Show();
	}

	public function EditMapOptionsAISend():void
	{
		var tstr:String;
		var boundary:String=Server.Self.CreateBoundary();

		var user:User=UserList.Self.GetUser(m_EditMapOptionsAI);
		if(user==null) return;

		var no:int = 0;
		var name:String = BaseStr.TrimRepeat(BaseStr.Trim(FI.GetStr(no++)));
		user.m_Team = FI.GetInt(no++);
		user.m_Race = FI.GetInt(no++);
		user.m_PowerMul = Math.round(FI.GetInt(no++) * 256 / 100);
		user.m_ManufMul = FI.GetInt(no++);
		user.m_Flag &= ~(Common.UserFlagAutoProgress | Common.UserFlagPlayerControl | Common.UserFlagVisAll | Common.UserFlagImportIfEnemy);
		if (FI.GetInt(no++) != 0) user.m_Flag |= Common.UserFlagVisAll;
//		if (FI.GetInt(no++) != 0) user.m_Flag |= Common.UserFlagAutoProgress;
		if (FI.GetInt(no++) != 0) user.m_Flag |= Common.UserFlagPlayerControl;
		if (FI.GetInt(no++) != 0) user.m_Flag |= Common.UserFlagImportIfEnemy;
		var cpt0name:String = FI.GetStr(no++);
		var cpt1name:String = FI.GetStr(no++);
		var cpt2name:String = FI.GetStr(no++);

		var d:String="";

		if (name != Txt_CotlOwnerName(Server.Self.m_CotlId, m_EditMapOptionsAI)) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"name\"\r\n\r\n";
			d+=name+"\r\n"
		}

		d+="--"+boundary+"\r\n";
		d+="Content-Disposition: form-data; name=\"team\"\r\n\r\n";
		d+=user.m_Team.toString()+"\r\n"

		d+="--"+boundary+"\r\n";
		d+="Content-Disposition: form-data; name=\"race\"\r\n\r\n";
		d += user.m_Race.toString() + "\r\n"

		d+="--"+boundary+"\r\n";
		d+="Content-Disposition: form-data; name=\"pmul\"\r\n\r\n";
		d += user.m_PowerMul.toString() + "\r\n"

		d+="--"+boundary+"\r\n";
		d+="Content-Disposition: form-data; name=\"mmul\"\r\n\r\n";
		d += user.m_ManufMul.toString() + "\r\n"

		d+="--"+boundary+"\r\n";
		d+="Content-Disposition: form-data; name=\"flag\"\r\n\r\n";
		d += (user.m_Flag & (Common.UserFlagAutoProgress | Common.UserFlagPlayerControl | Common.UserFlagVisAll | Common.UserFlagImportIfEnemy)).toString(16) + "\r\n";

		if (cpt0name != Txt_CptName(Server.Self.m_CotlId, user.m_Id, 0xffffff00 | ((user.m_Id & 15) << 4) | (0))) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"cpt0name\"\r\n\r\n";
			d+=cpt0name+"\r\n"
		}

		if (cpt1name != Txt_CptName(Server.Self.m_CotlId, user.m_Id, 0xffffff00 | ((user.m_Id & 15) << 4) | (1))) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"cpt1name\"\r\n\r\n";
			d+=cpt1name+"\r\n"
		}

		if (cpt2name != Txt_CptName(Server.Self.m_CotlId, user.m_Id, 0xffffff00 | ((user.m_Id & 15) << 4) | (2))) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"cpt2name\"\r\n\r\n";
			d+=cpt2name+"\r\n"
		}

		d+="--"+boundary+"--\r\n";

		Server.Self.QueryPost("emedcotlspecial","&type=12&id="+m_EditMapOptionsAI.toString(),d,boundary,EditMapChangePlanetNameAnswer,false);
	}

	public function EditMapTechAI(obj:Object, owner:uint):void
	{
		if(m_FormTech.visible) m_FormTech.Hide();
		FormHideAll();
		m_FormTech.m_Owner=owner;
		m_FormTech.Show();
	}
	
	public function CalcPulsarStateProtect(ctt:Number):Boolean
	{
		var ct:uint=Math.floor(ctt/1000);

		var at:int = Math.min(Math.max(1, m_OpsPulsarActive), 24 * 60) * 60;
		var pt:int = Math.min(Math.max(1, m_OpsPulsarPassive), 24 * 60) * 60;

		var begintime:int=m_ReadyTime;

		if (m_OpsStartTime > 0) {
			begintime=m_GameTime-m_OpsRestartCooldown*60;
		}

		var newt:uint = begintime + ((ct - begintime) / (at + pt)) * (at + pt);
		var tt:int = (ct - begintime) % (at + pt);

		var active:Boolean=false;

		if((m_OpsFlag & Common.OpsFlagPulsarEnterActive)!=0) {
			if(tt<at) { active=true; newt+=at; }
			else { newt+=at+pt; }
		} else {
			if(tt<pt) { newt+=pt+at; }
			else { active=true; newt+=pt; }
		}

		//if(nexttime) *nexttime=newt;
		return active;
	}

	public function PlanetOwnerReal(planet:Planet):uint
	{
		var x:int,y:int,i:int,p:int,r:int;
		var sec:Sector;
		var planet2:Planet;

		if(planet.m_Owner) return planet.m_Owner;

		if (m_CotlType == Common.CotlTypeUser) return m_CotlOwnerId;

		var sx:int=Math.max(m_SectorMinX,planet.m_Sector.m_SectorX-2);
		var sy:int=Math.max(m_SectorMinY,planet.m_Sector.m_SectorY-2);
		var ex:int=Math.min(m_SectorMinX+m_SectorCntX,planet.m_Sector.m_SectorX+3);
		var ey:int=Math.min(m_SectorMinY+m_SectorCntY,planet.m_Sector.m_SectorY+3);
		
		var ownernear:uint=0;
		var mr:int;
		
		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
				if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
				if(!(m_Sector[i] is Sector)) continue;
				sec=m_Sector[i];

				for(p=0;p<sec.m_Planet.length;p++) {
					planet2=sec.m_Planet[p];
					
					if(planet2.m_Owner==0) continue;
					
					r=(planet2.m_PosX-planet.m_PosX)*(planet2.m_PosX-planet.m_PosX)+(planet2.m_PosY-planet.m_PosY)*(planet2.m_PosY-planet.m_PosY);
					if(ownernear==0 || r<mr) {
						ownernear=planet2.m_Owner;
						mr=r;
					}
				}
			}
		}
		
		return ownernear;
	}

	public function RouteAccess(planet:Planet, owner:uint):Boolean
	{
		var x:int,y:int,i:int,p:int,r:int;
		var sec:Sector;
		var planet2:Planet;

		if (IsEdit()) return true;

//			if(planet.m_Owner==owner) return true;
//			if (m_CotlType == Common.CotlTypeUser) {
//				if (!AccessBuild(m_CotlOwnerId)) return false;
//				return true;
//			}
//			if (planet.m_Owner != 0) {
//				if ((GetRel(planet.m_Owner, owner) & Common.PactBuild) != 0) return true;
//				else return false;
//			}

		var ownernear:uint = 0;
		
		if (planet.m_Owner != 0) ownernear = planet.m_Owner;
		else {
			var sx:int=Math.max(m_SectorMinX,planet.m_Sector.m_SectorX-2);
			var sy:int=Math.max(m_SectorMinY,planet.m_Sector.m_SectorY-2);
			var ex:int=Math.min(m_SectorMinX+m_SectorCntX,planet.m_Sector.m_SectorX+3);
			var ey:int=Math.min(m_SectorMinY+m_SectorCntY,planet.m_Sector.m_SectorY+3);
		
			var mr:int;
			
			for(y=sy;y<ey;y++) {
				for(x=sx;x<ex;x++) {
					i=(x-m_SectorMinX)+(y-m_SectorMinY)*m_SectorCntX;
					if(i<0 || i>=m_SectorCntX*m_SectorCntY) throw Error("");
					if(!(m_Sector[i] is Sector)) continue;
					sec=m_Sector[i];

					for(p=0;p<sec.m_Planet.length;p++) {
						planet2=sec.m_Planet[p];
						
						if(planet2.m_Owner==0) continue;
						
						r=(planet2.m_PosX-planet.m_PosX)*(planet2.m_PosX-planet.m_PosX)+(planet2.m_PosY-planet.m_PosY)*(planet2.m_PosY-planet.m_PosY);
						if(ownernear==0 || r<mr) {
							ownernear=planet2.m_Owner;
							mr=r;
						}
					}
				}
			}
		}

		if (!(ownernear != 0 && (ownernear & Common.OwnerAI) != 0))  {
			if (m_CotlType == Common.CotlTypeUser) {
				ownernear = m_CotlOwnerId;
			}
		}

		if (ownernear == owner) return true;
		if(ownernear!=0) {
			if((GetRel(ownernear,owner) & Common.PactBuild)!=0) return true;
			else return false;
		}
		return false;
	}

	public function IsFlyOtherPlanet(ship:Ship, planet:Planet):Boolean
	{
		return (ship.m_ArrivalTime > m_ServerCalcTime) && ((ship.m_FromSectorX != planet.m_Sector.m_SectorX) || (ship.m_FromSectorY != planet.m_Sector.m_SectorY) || (ship.m_FromPlanet != planet.m_PlanetNum));
	}
	
	public function CanTransfer(own_to:uint, own_from:uint):Boolean
	{
		if(own_to==own_from) return true;
		if(own_from==0 || (own_from & Common.OwnerAI)) return true;
		if(own_to==0 || (own_to & Common.OwnerAI)) return true;

		var user_from:User = null;
		if(!user_from) {
			user_from = UserList.Self.GetUser(own_from);
			if(!user_from) return false;
		}
		var fromrank:int = (user_from.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift;
		if (fromrank <= Common.UserRankNovice) return false;

		var user_to:User = null;
		if(!user_to) {
			user_to = UserList.Self.GetUser(own_to);
			if(!user_to) return false;
		}
		var torank:int = (user_to.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift;

		if (torank >= Common.UserRankPilot && fromrank <= Common.UserRankCadet) return false;

		return true;
	}
	
	public function PlanetItemGet_Sub(owner:uint,planet:Planet,it:uint,transport:Boolean=false):int
	{
		var i:int;
		var pi:PlanetItem;
		var ship:Ship;

		var cnt:int=0;

		if(planet.m_Owner==owner || (GetRel(owner,planet.m_Owner) & Common.PactBuild)!=0) {
			for(i=0;i<Planet.PlanetItemCnt;i++) {
				pi=planet.m_Item[i];
				if (pi.m_Type != it) continue;
				if (!CanTransfer(owner, pi.m_Owner)) continue;

				cnt+=pi.m_Cnt;
			}
		}

		if(transport) {
			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship = planet.m_Ship[i];
				
				if(ship.m_Type!=Common.ShipTypeTransport) continue;
				if(ship.m_CargoType!=it) continue;
				if(IsFlyOtherPlanet(ship,planet)) continue;
				if(ship.m_Owner!=owner && (GetRel(owner,ship.m_Owner) & Common.PactBuild)==0) continue;
				if (!CanTransfer(owner, ship.m_Owner)) continue;

				cnt+=ship.m_CargoCnt;
			}
		}

		return cnt;
	}

	public function PlanetItemGet_Add(owner:uint, planet:Planet, it:uint, transport:Boolean = false):int
	{
		var i:int;
		var pi:PlanetItem;
		var ship:Ship;

		var cnt:int=0;

		if(planet.m_Owner==owner || (GetRel(owner,planet.m_Owner) & Common.PactBuild)!=0) {
			for(i=0;i<Planet.PlanetItemCnt;i++) {
				pi=planet.m_Item[i];
				if (pi.m_Type != it) continue;
				if (!CanTransfer(pi.m_Owner, owner)) continue;

				cnt+=pi.m_Cnt;
			}
		}

		if(transport) {
			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship = planet.m_Ship[i];
				
				if(ship.m_Type!=Common.ShipTypeTransport) continue;
				if(ship.m_CargoType!=it) continue;
				if(IsFlyOtherPlanet(ship,planet)) continue;
				if(ship.m_Owner!=owner && (GetRel(owner,ship.m_Owner) & Common.PactBuild)==0) continue;
				if (!CanTransfer(ship.m_Owner, owner)) continue;

				cnt+=ship.m_CargoCnt;
			}
		}

		return cnt;
	}

	public function IsNeedItemForWork(planet:Planet, item_type:uint, testbuild:Boolean = false):Boolean
	{
		var i:int, k:int, s:int;
		var obj:Object, obj2:Object;
		var pi:PlanetItem;

		if ((!testbuild) && (item_type & 0xffff0000) != 0) return false;
		item_type &= 0xffff;
		
		for (i = 0; i < Planet.PlanetItemCnt; i++) {
			pi = planet.m_Item[i];
			if(pi.m_Type==0) continue;
			if ((pi.m_Flag & PlanetItem.PlanetItemFlagBuild) == 0) continue;
			
			if (testbuild && item_type == pi.m_Type) return true;
			
			var pit:uint = pi.m_Type & 0xffff;
			if (pit<=0 || pit>=Common.ItemTypeCnt) continue;
			
			for (k = 0; k < Common.BuildingItem.length; k++) {
				obj = Common.BuildingItem[k];
				if (obj.Build == 0) continue;
				if (obj.ItemType != pit) continue;
				if (obj.BuildingType == 0) continue;
				
				for (s = k + 1; s < Common.BuildingItem.length; s++) {
					obj2 = Common.BuildingItem[s];
					if (obj2.Build != 0) break;
					if (obj2.BuildingType != obj.BuildingType) break;
					
					if (obj2.ItemType == item_type) {
						if (planet.ConstructionLvl(obj.BuildingType) <= 0) break;
						return true;
					}
				}
			}
		}

		return false;
	}
	
	public function PlanetItemExtract(owner:uint, planet:Planet, it:uint, cnt:int, transport:Boolean = false):int
	{
		var i:int,subcnt:int;
		var pi:PlanetItem;
		var ship:Ship;
		var ret:int=0;

		if(cnt<=0) return 0;

		if (owner == 0xffffffff || planet.m_Owner == owner || (GetRel(owner, planet.m_Owner) & Common.PactBuild) != 0) {
			var m:int = planet.PlanetItemMax();
			
			for (i = Planet.PlanetItemCnt - 1; (i >= 0) && (cnt>0); i--) {
				pi=planet.m_Item[i];
				if (pi.m_Type != it) continue;

				if(!CanTransfer(owner,pi.m_Owner)) continue;

				subcnt=cnt;
				if(subcnt>pi.m_Cnt) subcnt=pi.m_Cnt;
				if(subcnt<=0) continue;

				ret += subcnt;
				pi.m_Cnt -= subcnt;
				cnt -= subcnt;

				if(pi.m_Cnt>0) continue;
//					if((pi.m_Flag & (PlanetItem.PlanetItemFlagBuild|PlanetItem.PlanetItemFlagShowCnt))!=0) continue;

				while (true) {
					if (i >= m) {}
					else if(pi.m_Type==Common.ItemTypeModule && ((pi.m_Flag & (PlanetItem.PlanetItemFlagBuild|PlanetItem.PlanetItemFlagShowCnt|PlanetItem.PlanetItemFlagToPortal))!=0)) break;
					else if(pi.m_Type!=Common.ItemTypeModule && ((pi.m_Flag & (PlanetItem.PlanetItemFlagBuild|PlanetItem.PlanetItemFlagShowCnt|PlanetItem.PlanetItemFlagNoMove|PlanetItem.PlanetItemFlagToPortal))!=0)) break;
					else if(pi.m_Complete>0 || pi.m_Broken>0) break;
					else if(PlanetItemGet_Sub(owner,planet,it,false)>0) {}
					else if(IsNeedItemForWork(planet,it,true)) break;

					pi.m_Type=0;
					pi.m_Cnt=0;
					pi.m_Broken=0;
					pi.m_Complete=0;
					pi.m_Flag = 0;
					
					break;
				}
			}
		}

		if(transport) {
			for (i = 0; (i < Common.ShipOnPlanetMax) && (cnt>0); i++) {
				ship = planet.m_Ship[i];
				if (ship.m_Type != Common.ShipTypeTransport) continue;
				if (ship.m_CargoType != it) continue;
				if (IsFlyOtherPlanet(ship, planet)) continue;
				if (ship.m_Owner != owner && (GetRel(owner, ship.m_Owner) & Common.PactBuild) == 0) continue;

				if(!CanTransfer(owner,ship.m_Owner)) continue;

				subcnt=cnt;
				if(subcnt>=ship.m_CargoCnt) subcnt=ship.m_CargoCnt;
				if(subcnt<=0) continue;

				ret+=subcnt;
				ship.m_CargoCnt-=subcnt;
				cnt -= subcnt;

				if(ship.m_CargoCnt>0) continue;
				ship.m_CargoType=0;
				ship.m_CargoCnt=0;
			}
		}

		return ret;
	}
	
	public function PlanetItemAdd(owner:uint, planet:Planet, it:uint, cnt:int, full:Boolean = false, transport:Boolean = false, toland:Boolean = false, flagfornewslot:uint = 0):int
	{
		var i:int,k:int,msc:int;
		var pi:PlanetItem;
		var ship:Ship;

		if(cnt<=0) return 0;

		var itdesc:Item=UserList.Self.GetItem(it&0xffff);
		if(itdesc==null) return 0;
		var m:int=itdesc.m_StackMax;

		var storage:int = planet.PlanetItemMax();;
		var picnt:int = Math.min(Planet.PlanetItemCnt, storage);
//trace("!!!PIA picnt:",picnt);

		if(full) {
			var h:int=0;
			if(owner==0xffffffff || planet.m_Owner==owner || (GetRel(owner,planet.m_Owner) & Common.PactBuild)!=0) {
				for (i = 0; i < picnt; i++) {
					pi = planet.m_Item[i];
					k=0;
					if (pi.m_Type == 0) k = Common.StackMax(i, storage, m);
					else if(pi.m_Type!=it) continue;
					else {
						if(!CanTransfer(pi.m_Owner,owner)) continue;
						k=Common.StackMax(i, storage, m)-pi.m_Cnt;
					}
					if(k<=0) continue;
					h+=k;
				}
				
				if(toland) {
					for (; i < Planet.PlanetItemCnt; i++) {
						pi = planet.m_Item[i];
						k=0;
						if(pi.m_Type==0) k=Common.StackMax(i, storage, m);
						else if(pi.m_Type!=it) continue;
						else {
							if(!CanTransfer(pi.m_Owner,owner)) continue;
							k=Common.StackMax(i, storage, m)-pi.m_Cnt;
						}
						if(k<=0) continue;
						h+=k;
					}
				}
			}

			if(transport && h<cnt) {
				for (i = 0; i < Common.ShipOnPlanetMax; i++) {
					ship = planet.m_Ship[i];
					if(ship.m_Type!=Common.ShipTypeTransport) continue;
					if(IsFlyOtherPlanet(ship,planet)) continue;
					if(ship.m_Owner!=owner && (GetRel(owner,ship.m_Owner) & Common.PactBuild)==0) continue;

					if(!CanTransfer(ship.m_Owner,owner)) continue;

					msc = CargoMax(ship.m_Type, ship.m_Cnt + ship.m_CntDestroy);
//					msc = 1000000000;
//					if (full && ship.m_Owner) {
//						msc=DirValE(ship.m_Owner,Common.DirTransportCargo)*ship.m_Cnt;
//					}

					k=0;
					if(!ship.m_CargoType) k=msc;
					else if(ship.m_CargoType!=it) continue;
					else k=msc-ship.m_CargoCnt;
					if(k<=0) continue;
					h+=k;
				}
			}

			if(h<cnt) return 0;
		}
		
		var addcnt:int=0;

		var accessplanet:Boolean=false;
		if (owner == 0xffffffff || planet.m_Owner == owner || (GetRel(owner, planet.m_Owner) & Common.PactBuild) != 0) {
			accessplanet = true;
			
			for (i = 0; (cnt > 0) && (i < picnt); i++) {
				pi = planet.m_Item[i];
				if (pi.m_Type != it) continue;

				k=Common.StackMax(i, storage, m)-pi.m_Cnt;
				if(k<=0) continue;

				if(k>cnt) k=cnt;
				if(k<=0) continue;

				if(!CanTransfer(pi.m_Owner,owner)) continue;

				pi.m_Cnt += k;
				if (owner != 0xffffffff && (pi.m_Owner == 0 || (pi.m_Owner & Common.OwnerAI) != 0)) pi.m_Owner = owner;

				cnt-=k;
				addcnt+=k;
			}

			for(i=0;(cnt>0) && (i<picnt);i++) {
				pi = planet.m_Item[i];
				if(pi.m_Type!=0) continue;

				k=Common.StackMax(i, storage, m);
				if(k>cnt) k=cnt;
				if(k<=0) continue;

				pi.m_Type=it;
				pi.m_Cnt = k;
				if(owner!=0xffffffff) pi.m_Owner=owner;
				else pi.m_Owner=0;
				pi.m_Complete=0;
				pi.m_Broken=0;
				pi.m_Flag=flagfornewslot;

				cnt-=k;
				addcnt+=k;
			}
		}

		if(cnt>0 && transport) {
			for (i = 0; (cnt > 0) && (i < Common.ShipOnPlanetMax); i++) {
				ship = planet.m_Ship[i];
				if(ship.m_Type!=Common.ShipTypeTransport) continue;
				if(IsFlyOtherPlanet(ship,planet)) continue;
				if(ship.m_Owner!=owner && (GetRel(owner,ship.m_Owner) & Common.PactBuild)==0) continue;

//				msc=1000000000;
//				if (full && ship.m_Owner) {
//					msc=DirValE(ship.m_Owner,Common.DirTransportCargo)*ship.m_Cnt;
//				}
				msc = CargoMax(ship.m_Type, ship.m_Cnt + ship.m_CntDestroy);

				k=0;
				if(!ship.m_CargoType) k=msc;
				else if(ship.m_CargoType!=it) continue;
				else k=msc-ship.m_CargoCnt;
				if(k<=0) continue;

				if(k>cnt) k=cnt;
				if(k<=0) continue;

				if(!CanTransfer(ship.m_Owner,owner)) continue;

				ship.m_CargoType=Common.ItemTypeModule;
				ship.m_CargoCnt+=k;

				cnt-=k;
				addcnt+=k;
			}
		}
		
		if(toland && cnt>0 && accessplanet) {
			for (i = picnt; (cnt > 0) && (i < Planet.PlanetItemCnt); i++) {
				pi=planet.m_Item[i];
				if(pi.m_Type!=it) continue;

				k=Common.StackMax(i, storage, m)-pi.m_Cnt;
				if(k<=0) continue;

				if(k>cnt) k=cnt;
				if(k<=0) continue;

				if (!CanTransfer(pi.m_Owner, owner)) continue;

				pi.m_Cnt += k;
				if (owner != 0xffffffff && (pi.m_Owner == 0 || (pi.m_Owner & Common.OwnerAI) != 0)) pi.m_Owner = owner;

				cnt-=k;
				addcnt+=k;
			}

			for (i = picnt; (cnt > 0) && (i < Planet.PlanetItemCnt); i++) {
				pi=planet.m_Item[i];
				if (pi.m_Type != 0) continue;
				
				k=Common.StackMax(i, storage, m);
				if(k>cnt) k=cnt;
				if(k<=0) continue;

				pi.m_Type=it;
				pi.m_Cnt = k;
				if(owner!=0xffffffff) pi.m_Owner=owner;
				else pi.m_Owner=0;
				pi.m_Complete=0;
				pi.m_Broken=0;
				pi.m_Flag=flagfornewslot;

				cnt-=k;
				addcnt+=k;
			}
		}

		return addcnt;
	}
	
	public function CalcMassAllShip(atk:Boolean):int
	{
		var i:int;
		var m:int=0;

		if (atk) {
			if (m_UserStatShipCnt[Common.ShipTypeCorvette] > 0) m += m_UserStatShipCnt[Common.ShipTypeCorvette] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeCorvette);
			if (m_UserStatShipCnt[Common.ShipTypeCruiser] > 0) m += m_UserStatShipCnt[Common.ShipTypeCruiser] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeCruiser);
			if (m_UserStatShipCnt[Common.ShipTypeDreadnought] > 0) m += m_UserStatShipCnt[Common.ShipTypeDreadnought] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeDreadnought);
			if (m_UserStatShipCnt[Common.ShipTypeInvader] > 0) m += m_UserStatShipCnt[Common.ShipTypeInvader] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeInvader);
			if (m_UserStatShipCnt[Common.ShipTypeDevastator] > 0) m += m_UserStatShipCnt[Common.ShipTypeDevastator] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeDevastator);
			if (m_UserStatShipCnt[Common.ShipTypeQuarkBase] > 0) m += m_UserStatShipCnt[Common.ShipTypeQuarkBase] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeQuarkBase);

			var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
			if (user != null && user.m_Cpt != null) {
				for (i = 0; i < user.m_Cpt.length; i++) {
					var cpt:Cpt = user.m_Cpt[i];
					if (cpt.m_Id == 0) continue;
					if (cpt.m_PlanetNum < 0) continue;
					
					m += ShipMass(user.m_Id, cpt.m_Id, Common.ShipTypeFlagship);
				}
			}
		} else {
			if (m_UserStatShipCnt[Common.ShipTypeTransport] > 0) m += m_UserStatShipCnt[Common.ShipTypeTransport] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeTransport);
			if (m_UserStatShipCnt[Common.ShipTypeWarBase] > 0) m += m_UserStatShipCnt[Common.ShipTypeWarBase] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeWarBase);
			if (m_UserStatShipCnt[Common.ShipTypeShipyard] > 0) m += m_UserStatShipCnt[Common.ShipTypeShipyard] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeShipyard);
			if (m_UserStatShipCnt[Common.ShipTypeSciBase] > 0) m += m_UserStatShipCnt[Common.ShipTypeSciBase] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeSciBase);
			if (m_UserStatShipCnt[Common.ShipTypeServiceBase] > 0) m += m_UserStatShipCnt[Common.ShipTypeServiceBase] * ShipMass(Server.Self.m_UserId, 0, Common.ShipTypeServiceBase);
			if (m_UserGravitorSciCnt > 0) m += m_UserGravitorSciCnt * 50000;
			if (m_UserStatMineCnt > 0) m += m_UserStatMineCnt * 500;
		}
//			for(i=0;i<Common.ShipTypeCnt;i++) {
//				if (m_UserStatShipCnt[i] <= 0) continue;
//				m += ShipMass(Server.Self.m_UserId, 0, i) * m_UserStatShipCnt[i];
//			}
		
		return m;
	}

	public function CalcMaxMassAllShip(owner:uint, atk:Boolean):int
	{
		if (atk) return 50000 + m_UserEmpirePlanetCnt * Common.DirShipMassMaxLvlEmp[DirValLvl(owner, Common.DirShipMassMax)] + m_UserEnclavePlanetCnt * Common.DirShipMassMaxLvlEnc[DirValLvl(owner, Common.DirShipMassMax)];
		else return 20000 + (m_UserEmpirePlanetCnt + m_UserEnclavePlanetCnt) * Common.DirShipMassMaxLvlDef[DirValLvl(owner, Common.DirShipMassMax)];
	}

	public function SpaceStyle():void
	{
		var i:int, layer:int;

		FormHideAll();
		m_FormInput.Init();

		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleCaption, 18);

		m_FormInput.PageAdd(Common.TxtEdit.SpaceStyleMain);

		// Size
		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleSize+":");
		m_FormInput.Col();
		m_FormInput.AddInput(m_BG.m_Cfg.Size.toString(),6,true).addEventListener(Event.CHANGE,SpaceStyleChange);

		// Offset
		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleOff+":");
		m_FormInput.Col();
		m_FormInput.AddInput(m_BG.m_Cfg.OffX.toString()+","+m_BG.m_Cfg.OffY.toString(),50,true,0,true).addEventListener(Event.CHANGE,SpaceStyleChangeFast);

		// FillColor
		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleFillColor+":");
		m_FormInput.Col();
		//m_FormInput.AddInput(m_BG.m_Cfg.FillColor.toString(16), 8, true, Server.LANG_ENG, false).addEventListener(Event.CHANGE, SpaceStyleChange);
		m_FormInput.AddColorPicker(m_BG.m_Cfg.FillColor).addEventListener(Event.CHANGE, SpaceStyleChange);

		// FillImg
		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleFillImg+":");
		m_FormInput.Col();
		m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
		m_FormInput.AddItem("", 0, 0==m_BG.m_Cfg.FillImg);
		for (i = 1; i <= 3;i++) {
			m_FormInput.AddItem("Stars"+i.toString(), i, i==m_BG.m_Cfg.FillImg);
		}
		
		// ColorGrid
		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleColorGrid+":");
		m_FormInput.Col();
		//m_FormInput.AddInput(m_BG.m_Cfg.ColorGrid.toString(16), 8, true, Server.LANG_ENG, false).addEventListener(Event.CHANGE, SpaceStyleChangeFast);
		m_FormInput.AddColorPicker(m_BG.m_Cfg.ColorGrid).addEventListener(Event.CHANGE, SpaceStyleChangeFast);

		// ColorCoord
		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleColorCoord+":");
		m_FormInput.Col();
		//m_FormInput.AddInput(m_BG.m_Cfg.ColorCoord.toString(16), 8, true, Server.LANG_ENG, false).addEventListener(Event.CHANGE, SpaceStyleChangeFast);
		m_FormInput.AddColorPicker(m_BG.m_Cfg.ColorCoord).addEventListener(Event.CHANGE, SpaceStyleChangeFast);
		
		// ColorTrade
		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleColorTrade+":");
		m_FormInput.Col();
		//m_FormInput.AddInput(m_BG.m_Cfg.ColorTrade.toString(16), 8, true, Server.LANG_ENG, false).addEventListener(Event.CHANGE, SpaceStyleChangeFast);
		m_FormInput.AddColorPicker(m_BG.m_Cfg.ColorTrade).addEventListener(Event.CHANGE, SpaceStyleChangeFast);

		// ColorRoute
		m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleColorRoute+":");
		m_FormInput.Col();
		//m_FormInput.AddInput(m_BG.m_Cfg.ColorRoute.toString(16), 8, true, Server.LANG_ENG, false).addEventListener(Event.CHANGE, SpaceStyleChangeFast);
		m_FormInput.AddColorPicker(m_BG.m_Cfg.ColorRoute).addEventListener(Event.CHANGE, SpaceStyleChangeFast);

		// Layer
		for (layer = 0; layer < 4; layer++) {
			if (layer == 0) m_FormInput.PageAdd(Common.TxtEdit.SpaceStyleBGLayer1);
			else if (layer == 1) m_FormInput.PageAdd(Common.TxtEdit.SpaceStyleBGLayer2);
			else if (layer == 2) m_FormInput.PageAdd(Common.TxtEdit.SpaceStyleBGLayer3);
			else m_FormInput.PageAdd(Common.TxtEdit.SpaceStyleBGLayer4);

			// Z
			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleZ+":");
			m_FormInput.Col();
			m_FormInput.AddInput(m_BG.m_Cfg.BGLayer[layer].Z.toString(), 2, true, 0, false).addEventListener(Event.CHANGE, SpaceStyleChangeFast);

			// Begin
			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBeginLayer+":");
			m_FormInput.Col();
			m_FormInput.AddInput(m_BG.m_Cfg.BGLayer[layer].BeginX.toString()+","+m_BG.m_Cfg.BGLayer[layer].BeginY.toString(),50,true,0,true).addEventListener(Event.CHANGE,SpaceStyleChange);

			// Img1
//				m_FormInput.PageAdd("    "+Common.TxtEdit.SpaceStyleBGImg1);

			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBGImg1+":");
			m_FormInput.Col();
			m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.AddItem("", 0, 0==m_BG.m_Cfg.BGLayer[layer].Img1);
			for (i = 0; i < GraphBG.FonImages.length;i++) {
				m_FormInput.AddItem(GraphBG.FonImages[i].Name, GraphBG.FonImages[i].Id, GraphBG.FonImages[i].Id==m_BG.m_Cfg.BGLayer[layer].Img1);
			}
			
			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBGClr1+":");
			m_FormInput.Col();
			m_FormInput.AddColorPicker(m_BG.m_Cfg.BGLayer[layer].Clr1).addEventListener(Event.CHANGE, SpaceStyleChangeFast);
			
			m_FormInput.AddLabel("H,B,C,S:");
			m_FormInput.Col();
			m_FormInput.AddInput(
				m_BG.m_Cfg.BGLayer[layer].Hue1.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Brightness1.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Contrast1.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Saturation1.toString()
				, 50, true, 0, true).addEventListener(Event.CHANGE, SpaceStyleChange);

			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleRotate+":");
			m_FormInput.Col();
			m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.AddItem("0", 0, 0==m_BG.m_Cfg.BGLayer[layer].Rotate1);
			m_FormInput.AddItem("90", 90, 90==m_BG.m_Cfg.BGLayer[layer].Rotate1);
			m_FormInput.AddItem("180", 180, 180==m_BG.m_Cfg.BGLayer[layer].Rotate1);
			m_FormInput.AddItem("270", 270, 270==m_BG.m_Cfg.BGLayer[layer].Rotate1);

			m_FormInput.AddCheck(Common.TxtEdit.FlipX1, Common.TxtEdit.SpaceStyleFlipX).addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.Col();
			m_FormInput.AddCheck(Common.TxtEdit.FlipY1, Common.TxtEdit.SpaceStyleFlipY).addEventListener(Event.CHANGE,SpaceStyleChange);

/*			m_FormInput.AddLabel("Hue:");
			m_FormInput.Col();
			m_FormInput.AddInput(m_BG.m_Cfg.BGLayer[layer].Hue1.toString(), 6, true).addEventListener(Event.CHANGE,SpaceStyleChange);

			m_FormInput.AddLabel("Contrast:");
			m_FormInput.Col();
			m_FormInput.AddInput(m_BG.m_Cfg.BGLayer[layer].Contrast1.toString(), 6, true).addEventListener(Event.CHANGE,SpaceStyleChange);

			m_FormInput.AddLabel("Brightness:");
			m_FormInput.Col();
			m_FormInput.AddInput(m_BG.m_Cfg.BGLayer[layer].Brightness1.toString(), 6, true).addEventListener(Event.CHANGE,SpaceStyleChange);

			m_FormInput.AddLabel("Saturation:");
			m_FormInput.Col();
			m_FormInput.AddInput(m_BG.m_Cfg.BGLayer[layer].Saturation1.toString(), 6, true).addEventListener(Event.CHANGE,SpaceStyleChange);*/

			// Img2
//				m_FormInput.PageAdd("    " + Common.TxtEdit.SpaceStyleBGImg2);
			
			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBGImg2+":");
			m_FormInput.Col();
			m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.AddItem("", 0, 0==m_BG.m_Cfg.BGLayer[layer].Img2);
			for (i = 0; i < GraphBG.FonImages.length;i++) {
				m_FormInput.AddItem(GraphBG.FonImages[i].Name, GraphBG.FonImages[i].Id, GraphBG.FonImages[i].Id==m_BG.m_Cfg.BGLayer[layer].Img2);
			}

			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBGClr2+":");
			m_FormInput.Col();
			m_FormInput.AddColorPicker(m_BG.m_Cfg.BGLayer[layer].Clr2).addEventListener(Event.CHANGE, SpaceStyleChangeFast);

			m_FormInput.AddLabel("H,B,C,S:");
			m_FormInput.Col();
			m_FormInput.AddInput(
				m_BG.m_Cfg.BGLayer[layer].Hue2.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Brightness2.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Contrast2.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Saturation2.toString()
				, 50, true, 0, true).addEventListener(Event.CHANGE, SpaceStyleChange);

			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleRotate+":");
			m_FormInput.Col();
			m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.AddItem("0", 0, 0==m_BG.m_Cfg.BGLayer[layer].Rotate2);
			m_FormInput.AddItem("90", 90, 90==m_BG.m_Cfg.BGLayer[layer].Rotate2);
			m_FormInput.AddItem("180", 180, 180==m_BG.m_Cfg.BGLayer[layer].Rotate2);
			m_FormInput.AddItem("270", 270, 270==m_BG.m_Cfg.BGLayer[layer].Rotate2);

			m_FormInput.AddCheck(Common.TxtEdit.FlipX2, Common.TxtEdit.SpaceStyleFlipX).addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.Col();
			m_FormInput.AddCheck(Common.TxtEdit.FlipY2, Common.TxtEdit.SpaceStyleFlipY).addEventListener(Event.CHANGE, SpaceStyleChange);

			// Img3
//				m_FormInput.PageAdd("    " + Common.TxtEdit.SpaceStyleBGImg3);
			
			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBGImg3+":");
			m_FormInput.Col();
			m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.AddItem("", 0, 0==m_BG.m_Cfg.BGLayer[layer].Img3);
			for (i = 0; i < GraphBG.FonImages.length;i++) {
				m_FormInput.AddItem(GraphBG.FonImages[i].Name, GraphBG.FonImages[i].Id, GraphBG.FonImages[i].Id==m_BG.m_Cfg.BGLayer[layer].Img3);
			}
			
			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBGClr3+":");
			m_FormInput.Col();
			m_FormInput.AddColorPicker(m_BG.m_Cfg.BGLayer[layer].Clr3).addEventListener(Event.CHANGE, SpaceStyleChangeFast);

			m_FormInput.AddLabel("H,B,C,S:");
			m_FormInput.Col();
			m_FormInput.AddInput(
				m_BG.m_Cfg.BGLayer[layer].Hue3.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Brightness3.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Contrast3.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Saturation3.toString()
				, 50, true, 0, true).addEventListener(Event.CHANGE, SpaceStyleChange);

			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleRotate+":");
			m_FormInput.Col();
			m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.AddItem("0", 0, 0==m_BG.m_Cfg.BGLayer[layer].Rotate3);
			m_FormInput.AddItem("90", 90, 90==m_BG.m_Cfg.BGLayer[layer].Rotate3);
			m_FormInput.AddItem("180", 180, 180==m_BG.m_Cfg.BGLayer[layer].Rotate3);
			m_FormInput.AddItem("270", 270, 270==m_BG.m_Cfg.BGLayer[layer].Rotate3);

			m_FormInput.AddCheck(Common.TxtEdit.FlipX3, Common.TxtEdit.SpaceStyleFlipX).addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.Col();
			m_FormInput.AddCheck(Common.TxtEdit.FlipY3, Common.TxtEdit.SpaceStyleFlipY).addEventListener(Event.CHANGE, SpaceStyleChange);

			// Img4
//				m_FormInput.PageAdd("    "+Common.TxtEdit.SpaceStyleBGImg4);
			
			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBGImg4+":");
			m_FormInput.Col();
			m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.AddItem("", 0, 0==m_BG.m_Cfg.BGLayer[layer].Img4);
			for (i = 0; i < GraphBG.FonImages.length;i++) {
				m_FormInput.AddItem(GraphBG.FonImages[i].Name, GraphBG.FonImages[i].Id, GraphBG.FonImages[i].Id==m_BG.m_Cfg.BGLayer[layer].Img4);
			}

			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleBGClr4+":");
			m_FormInput.Col();
			m_FormInput.AddColorPicker(m_BG.m_Cfg.BGLayer[layer].Clr4).addEventListener(Event.CHANGE, SpaceStyleChangeFast);

			m_FormInput.AddLabel("H,B,C,S:");
			m_FormInput.Col();
			m_FormInput.AddInput(
				m_BG.m_Cfg.BGLayer[layer].Hue4.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Brightness4.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Contrast4.toString()
				+"," + m_BG.m_Cfg.BGLayer[layer].Saturation4.toString()
				, 50, true, 0, true).addEventListener(Event.CHANGE, SpaceStyleChange);

			m_FormInput.AddLabel(Common.TxtEdit.SpaceStyleRotate+":");
			m_FormInput.Col();
			m_FormInput.AddComboBox().addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.AddItem("0", 0, 0==m_BG.m_Cfg.BGLayer[layer].Rotate4);
			m_FormInput.AddItem("90", 90, 90==m_BG.m_Cfg.BGLayer[layer].Rotate4);
			m_FormInput.AddItem("180", 180, 180==m_BG.m_Cfg.BGLayer[layer].Rotate4);
			m_FormInput.AddItem("270", 270, 270==m_BG.m_Cfg.BGLayer[layer].Rotate4);

			m_FormInput.AddCheck(Common.TxtEdit.FlipX4, Common.TxtEdit.SpaceStyleFlipX).addEventListener(Event.CHANGE,SpaceStyleChange);
			m_FormInput.Col();
			m_FormInput.AddCheck(Common.TxtEdit.FlipY4, Common.TxtEdit.SpaceStyleFlipY).addEventListener(Event.CHANGE, SpaceStyleChange);
		}

		m_FormInput.ColAlign();
		m_FormInput.Run(SpaceStyleSave, Common.Txt.ButSave, Common.Txt.ButClose, false);

		var but:Button = new Button();
		m_FormInput.addChild(but);
		but.width=100;
		but.emphasized=false;
		but.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		but.setStyle("embedFonts", true);
		but.textField.antiAliasType=AntiAliasType.ADVANCED;
		but.textField.gridFitType=GridFitType.PIXEL;
		but.addEventListener(MouseEvent.CLICK, SpaceStyleRandom);
		but.label = Common.Txt.RandomFon;
		but.x = m_FormInput.m_ButOk.x-20-but.width;
		but.y = m_FormInput.m_ButOk.y;
	}

	public function SpaceStyleRandom(e:Event):void
	{
		m_BG.Clear();
		m_BG.CfgRandom(Common.GetTime() & 0xffffff);
		//m_BG.onLoadComplate(null);
		m_FormInput.Hide();
		SpaceStyle();
	}

	public function SpaceStyleFromForm():void
	{
		var layer:int;
		var ar:Array;
		
		var no:int = 0;
		
		m_BG.m_Cfg.Size = m_FormInput.GetInt(no++);
		
		ar = m_FormInput.GetStr(no++).split(",");
		if (ar.length >= 1) m_BG.m_Cfg.OffX = int(ar[0]);
		if (ar.length >= 2) m_BG.m_Cfg.OffY = int(ar[1]);
		
		if (m_BG.m_Cfg.OffX < -10000) m_BG.m_Cfg.OffX = -10000;
		else if(m_BG.m_Cfg.OffX > 10000) m_BG.m_Cfg.OffX = 10000;
		if (m_BG.m_Cfg.OffY < -10000) m_BG.m_Cfg.OffY = -10000;
		else if (m_BG.m_Cfg.OffY > 10000) m_BG.m_Cfg.OffY = 10000;
		
//			m_BG.m_Cfg.Z = m_FormInput.GetInt(no++);
//			if (m_BG.m_Cfg.Z < 0) m_BG.m_Cfg.Z = 0;
//			else if (m_BG.m_Cfg.Z > 100) m_BG.m_Cfg.Z = 100;
		
		m_BG.m_Cfg.FillColor = uint("0x" + m_FormInput.GetStr(no++));
		m_BG.m_Cfg.FillImg=m_FormInput.GetInt(no++);
		
		m_BG.m_Cfg.ColorGrid = uint("0x" + m_FormInput.GetStr(no++));
		m_BG.m_Cfg.ColorCoord = uint("0x" + m_FormInput.GetStr(no++));
		m_BG.m_Cfg.ColorTrade = uint("0x" + m_FormInput.GetStr(no++));
		m_BG.m_Cfg.ColorRoute = uint("0x" + m_FormInput.GetStr(no++));

		for (layer = 0; layer < 4; layer++) {
			m_BG.m_Cfg.BGLayer[layer].Z = m_FormInput.GetInt(no++);
			if (m_BG.m_Cfg.BGLayer[layer].Z < 0) m_BG.m_Cfg.BGLayer[layer].Z = 0;
			else if (m_BG.m_Cfg.BGLayer[layer].Z > 100) m_BG.m_Cfg.BGLayer[layer].Z = 100;

			ar = m_FormInput.GetStr(no++).split(",");
			if (ar.length >= 1) m_BG.m_Cfg.BGLayer[layer].BeginX = int(ar[0]);
			if (ar.length >= 2) m_BG.m_Cfg.BGLayer[layer].BeginY = int(ar[1]);

			m_BG.m_Cfg.BGLayer[layer].Img1 = m_FormInput.GetInt(no++);
			m_BG.m_Cfg.BGLayer[layer].Clr1 = uint("0x" + m_FormInput.GetStr(no++));
			
			ar = m_FormInput.GetStr(no++).split(",");
			if(ar.length>=1) m_BG.m_Cfg.BGLayer[layer].Hue1 = int(ar[0]);
			if(ar.length>=2) m_BG.m_Cfg.BGLayer[layer].Brightness1 = int(ar[1]);
			if(ar.length>=3) m_BG.m_Cfg.BGLayer[layer].Contrast1 = int(ar[2]);
			if(ar.length>=4) m_BG.m_Cfg.BGLayer[layer].Saturation1 = int(ar[3]);

			m_BG.m_Cfg.BGLayer[layer].Rotate1 = m_FormInput.GetInt(no++);
			m_BG.m_Cfg.BGLayer[layer].FlipX1 = m_FormInput.GetInt(no++) != 0;
			m_BG.m_Cfg.BGLayer[layer].FlipY1 = m_FormInput.GetInt(no++) != 0;

			m_BG.m_Cfg.BGLayer[layer].Img2 = m_FormInput.GetInt(no++);
			m_BG.m_Cfg.BGLayer[layer].Clr2 = uint("0x" + m_FormInput.GetStr(no++));

			ar = m_FormInput.GetStr(no++).split(",");
			if(ar.length>=1) m_BG.m_Cfg.BGLayer[layer].Hue2 = int(ar[0]);
			if(ar.length>=2) m_BG.m_Cfg.BGLayer[layer].Brightness2 = int(ar[1]);
			if(ar.length>=3) m_BG.m_Cfg.BGLayer[layer].Contrast2 = int(ar[2]);
			if (ar.length >= 4) m_BG.m_Cfg.BGLayer[layer].Saturation2 = int(ar[3]);

			m_BG.m_Cfg.BGLayer[layer].Rotate2 = m_FormInput.GetInt(no++);
			m_BG.m_Cfg.BGLayer[layer].FlipX2 = m_FormInput.GetInt(no++) != 0;
			m_BG.m_Cfg.BGLayer[layer].FlipY2 = m_FormInput.GetInt(no++) != 0;

			m_BG.m_Cfg.BGLayer[layer].Img3 = m_FormInput.GetInt(no++);
			m_BG.m_Cfg.BGLayer[layer].Clr3 = uint("0x" + m_FormInput.GetStr(no++));
			
			ar = m_FormInput.GetStr(no++).split(",");
			if(ar.length>=1) m_BG.m_Cfg.BGLayer[layer].Hue3 = int(ar[0]);
			if(ar.length>=2) m_BG.m_Cfg.BGLayer[layer].Brightness3 = int(ar[1]);
			if(ar.length>=3) m_BG.m_Cfg.BGLayer[layer].Contrast3 = int(ar[2]);
			if (ar.length >= 4) m_BG.m_Cfg.BGLayer[layer].Saturation3 = int(ar[3]);
			
			m_BG.m_Cfg.BGLayer[layer].Rotate3 = m_FormInput.GetInt(no++);
			m_BG.m_Cfg.BGLayer[layer].FlipX3 = m_FormInput.GetInt(no++) != 0;
			m_BG.m_Cfg.BGLayer[layer].FlipY3 = m_FormInput.GetInt(no++) != 0;
			
			m_BG.m_Cfg.BGLayer[layer].Img4 = m_FormInput.GetInt(no++);
			m_BG.m_Cfg.BGLayer[layer].Clr4 = uint("0x" + m_FormInput.GetStr(no++));

			ar = m_FormInput.GetStr(no++).split(",");
			if(ar.length>=1) m_BG.m_Cfg.BGLayer[layer].Hue4 = int(ar[0]);
			if(ar.length>=2) m_BG.m_Cfg.BGLayer[layer].Brightness4 = int(ar[1]);
			if(ar.length>=3) m_BG.m_Cfg.BGLayer[layer].Contrast4 = int(ar[2]);
			if (ar.length >= 4) m_BG.m_Cfg.BGLayer[layer].Saturation4 = int(ar[3]);

			m_BG.m_Cfg.BGLayer[layer].Rotate4 = m_FormInput.GetInt(no++);
			m_BG.m_Cfg.BGLayer[layer].FlipX4 = m_FormInput.GetInt(no++) != 0;
			m_BG.m_Cfg.BGLayer[layer].FlipY4 = m_FormInput.GetInt(no++) != 0;
		}
	}

	public function SpaceStyleChange(e:Event):void
	{
		SpaceStyleFromForm();
		m_BG.Clear();
//			m_BG.onLoadComplate(null);
	}

	public function SpaceStyleChangeFast(e:Event):void
	{
		SpaceStyleFromForm();
//			m_BG.DrawContent();
	}

	public function SpaceStyleSave():void
	{
		if ((m_CotlType == Common.CotlTypeUser && m_CotlOwnerId == Server.Self.m_UserId) || (CotlDevAccess(Server.Self.m_CotlId) & SpaceCotl.DevAccessEditOps)) {
			//Server.Self.Query("emedcotlspecial", "&type=17&val=" + m_BG.CfgSave(), EditMapChangeSizeRecv, false);
			
			var boundary:String=Server.Self.CreateBoundary();
	
			var d:String="";
			
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"val\"\r\n\r\n";
			d+=m_BG.CfgSave()+"\r\n"
	
			d+="--"+boundary+"--\r\n";
	
			Server.Self.QueryPost("emedcotlspecial","&type=17",d,boundary,EditMapChangePlanetNameAnswer,false);
			
		} else {
			m_BG.m_SaveList[Server.Self.m_CotlId] = m_BG.CfgSave();
		}
	}

	public function CalcItemDifficult(planet:Planet, it:uint):int
	{
		var i:int, u:int, k:int, t:int;
		var d:int = 0;

		if (planet != null) {
			d = -1;
			for (i = 0; i < Common.BuildingItem.length; i++) {
				var obj:Object = Common.BuildingItem[i];
				if (obj.Build == 0) continue;
				if (obj.ItemType != (it & 0xffff)) continue;
				if (planet.ConstructionLvl(obj.BuildingType) <= 0) continue;
				
				d = Math.max(d,obj.Build);
			}
			if (d >= 0) return d;
			d = 0;
		}
		
		var idesc:Item = UserList.Self.GetItem(it & 0xffff);
		if (idesc == null) return 0;

		for (i = 0; i < 4; i++) {
			d += idesc.m_BonusDif[i];
		}

		var bl:Vector.<int> = new Vector.<int>(4, true);
		var blcnt:int = 0;

		for (i = 0; i < 4;i++) {
			k = ((it >> (16 + i * 4)) & 15);
			if (k == 0) continue;
			k = idesc.m_BonusDif[k];

			for (u = 0; u < blcnt; u++) if (k < bl[u]) break;
			for (t = blcnt - 1; t >= u; t--) bl[t + 1] = bl[t];
			bl[u] = k;
			blcnt++;
		}

		for (i = 0; i < blcnt; i++) {
			d += (d >> 1)+bl[i];
		}

		return d;
	}
	
	public function ItemName(ti:uint):String
	{
		var i:int;
		var str:String = Txt_ItemName(ti & 0xffff);
		var h:Boolean = true;
		
		if ((ti & 0xffff0000) != 0) {
			for (i = 0; i < 4; i++) {
				var no:int = (ti >> (16 + i * 4)) & 15;
				if (no <= 3) continue;
				if (h) { h = false; str += " "; }
				str += String.fromCharCode(65 + no - 4);
			}
		}
		
		return str;
	}
	
	public function IsEmpirePlanet(planet:Planet):Boolean
	{
		var i:int;

		if(m_CotlType!=Common.CotlTypeUser) return false;

		for (i = 0; i < Planet.PlanetItemCnt; i++) {
			var pi:PlanetItem = planet.m_Item[i];
			if (pi.m_Type == 0) continue;
			if ((pi.m_Flag & PlanetItem.PlanetItemFlagBuild) != 0) return true;
		}

		return false;
	}
	
	public function OutBattleRearShip(shipinbattle:Ship, num:int, planet:Planet):void
	{
		var ship:Ship;
		var sn:int;
		if (planet.m_Flag & Planet.PlanetFlagWormhole) return;

		var sopl:int = planet.ShipOnPlanetLow;
		if(num>=sopl) return;

		if (num + 1 >= sopl) sn = 0;
		else sn = num + 1;
		ship=planet.m_Ship[sn];

		if (ship.m_Type != Common.ShipTypeNone && (ship.m_Type == Common.ShipTypeCruiser || ship.m_Type == Common.ShipTypeWarBase) && (ship.m_Flag & Common.ShipFlagBattle) && !(ship.m_Owner == shipinbattle.m_Owner && ship.m_Race == shipinbattle.m_Race)) {
			if (IsRear(planet, sn, ship.m_Owner, ship.m_Race, true, true)) {
				ship.m_Flag &= ~Common.ShipFlagBattle;
			}
		}

		if(num-1<0) sn=sopl-1;
		else sn = num - 1;
		ship = planet.m_Ship[sn];

		if (ship.m_Type != Common.ShipTypeNone && (ship.m_Type == Common.ShipTypeCruiser || ship.m_Type == Common.ShipTypeWarBase) && (ship.m_Flag & Common.ShipFlagBattle) && !(ship.m_Owner == shipinbattle.m_Owner && ship.m_Race == shipinbattle.m_Race)) {
			if (IsRear(planet, sn, ship.m_Owner, ship.m_Race, true, true)) {
				ship.m_Flag &= ~Common.ShipFlagBattle;
			}
		}
	}

	public function FindOutBattleShip(planet:Planet, shipnb:Ship):Ship
	{
		var i:int, u:int, b:int, s:int, p:int, n:int, d:int, dn:int;
		var enemy:Boolean;
		var ship:Ship,ship2:Ship;
		var best:Ship = null;
		for (i = 0; i < Common.ShipOnPlanetMax; i++) {
			ship = planet.m_Ship[i];
			if (ship == shipnb) continue;
			if (ship.m_Type == Common.ShipTypeNone) continue;
			if (ship.m_Type == Common.ShipTypeQuarkBase) continue;
			if ((ship.m_Flag & Common.ShipFlagBattle) == 0) continue;
			if ((ship.m_Flag & (Common.ShipFlagBuild | Common.ShipFlagBomb | Common.ShipFlagPortal | Common.ShipFlagEject | Common.ShipFlagPhantom)) != 0) continue;
			if (ship.m_Owner != shipnb.m_Owner && !IsFriendEx(planet, ship.m_Owner, ship.m_Race, shipnb.m_Owner, shipnb.m_Race)) continue;
			if (ship.m_Owner != shipnb.m_Owner && !AccessControl(ship.m_Owner)) continue;

			s = 255 - Common.ShipToBattle[ship.m_Type];
			
			p = i - 1; if (p < 0) p = Common.ShipOnPlanetMax - 1;
			n = i + 1; if (n >= Common.ShipOnPlanetMax) n = 0;
			if (planet.m_Ship[p].m_Type != Common.ShipTypeNone && planet.m_Ship[n].m_Type != Common.ShipTypeNone) {
				s |= 0x40000000;
			}
			
			// Рассчитываем дальность до врага
			dn = -1;
			d = 0;
			enemy = false;
			n = i + 1; if (n >= Common.ShipOnPlanetMax) n = 0;
			for (u = 0; u < Common.ShipOnPlanetMax-1; u++) {
				while (true) {
					ship2 = planet.m_Ship[n];
					if (ship2.m_Type == Common.ShipTypeNone) break;
					if ((ship2.m_Flag & Common.ShipFlagBattle) == 0 && ship2 != shipnb) break;
					
					if (ship2.m_Owner == shipnb.m_Owner || IsFriendEx(planet, ship2.m_Owner, ship2.m_Race, shipnb.m_Owner, shipnb.m_Race)) {
						d++;
					} else {
						enemy = true;
					}
					
					break;
				}
				if (enemy) break;
				n = n + 1; if (n >= Common.ShipOnPlanetMax) n = 0;
			}
			if (enemy) dn = d;

			d = 0;
			enemy = false;
			p = i - 1; if (p < 0) p = Common.ShipOnPlanetMax - 1;
			for (u = 0; u < Common.ShipOnPlanetMax-1; u++) {
				while (true) {
					ship2 = planet.m_Ship[p];
					if (ship2.m_Type == Common.ShipTypeNone) break;
					if ((ship2.m_Flag & Common.ShipFlagBattle) == 0 && ship2 != shipnb) break;
					
					if (ship2.m_Owner == shipnb.m_Owner || IsFriendEx(planet, ship2.m_Owner, ship2.m_Race, shipnb.m_Owner, shipnb.m_Race)) {
						d++;
					} else {
						enemy = true;
					}
					
					break;
				}
				if (enemy) break;
				p = p - 1; if (p < 0) p = Common.ShipOnPlanetMax - 1;
			}
			if (enemy && ((dn < 0) || (d < dn))) dn = d;

			if (d >= 2) s |= 0x20000000;
			else if (d >= 1) s |= 0x10000000;

			if (best == null || s > b) {
				best = ship;
				b = s;
			}
		}
		return best;
	}

	public function CotlDevAccess(cotl_id:uint):uint
	{
		var fl:uint = 0;

		var cotl:SpaceCotl = HS.GetCotl(cotl_id);
		if (cotl == null) return 0

		if (cotl.m_DevTime > GetServerGlobalTime()) {
			if (cotl.m_Dev0 == Server.Self.m_UserId) fl = (cotl.m_DevAccess >> 0) & 0xff;
			else if (cotl.m_Dev1 == Server.Self.m_UserId) fl = (cotl.m_DevAccess >> 8) & 0xff;
			else if (cotl.m_Dev2 == Server.Self.m_UserId) fl = (cotl.m_DevAccess >> 16) & 0xff;
			else if (cotl.m_Dev3 == Server.Self.m_UserId) fl = (cotl.m_DevAccess >> 24) & 0xff;
		}

		if (m_UserAccess & User.AccessDevAssignRights) fl |= SpaceCotl.DevAccessAssignRights;
		if (m_UserAccess & User.AccessDevView) fl |= SpaceCotl.DevAccessView;
		if (m_UserAccess & User.AccessDevEditMap) fl |= SpaceCotl.DevAccessEditMap;
		if (m_UserAccess & User.AccessDevEditCode) fl |= SpaceCotl.DevAccessEditCode;
		if (m_UserAccess & User.AccessDevEditOps) fl |= SpaceCotl.DevAccessEditOps;

		return fl;
	}

	public function PlusarManuf():Boolean
	{
		return (m_GameState & Common.GameStateTraining) || (m_UserAddModuleEnd > GetServerGlobalTime()) || (m_UserControlEnd > GetServerGlobalTime());
	}

	public function PlusarTech():Boolean
	{
		return (m_GameState & Common.GameStateTraining) || (m_UserTechEnd > GetServerGlobalTime()) || (m_UserControlEnd > GetServerGlobalTime());
	}

	public function MB_Clear():void
	{
		m_MB_ItemType = 0;
		m_MB_SectorX = 0;
		m_MB_SectorY = 0;
		m_MB_PlanetNum = 0;
		m_MB_LoadSector.length = 0;
		m_MB_Send = false;
		m_MB_Hist.length = 0;
	}

	public function MB_Calc():void
	{
		var i:int, u:int, k:int, t:int, p:int, cnt:int, x:int, y:int, tsecx:int, tsecy:int, tplanet:int, bt:int, lvl:int;
		var sec:Sector;
		var ship:Ship;
		var planet:Planet;
		var planet2:Planet;
		var obj:Object;
		var obj2:Object;
		var userm:User;

		m_MB_LoadSector.length = 0;

		if (m_MB_ItemType == 0) return;

		sec = GetSectorEx(m_MB_SectorX, m_MB_SectorY);
		if (sec == null) return;
		if (m_MB_PlanetNum<0 || m_MB_PlanetNum>=sec.m_Planet.length) return;
		sec.m_NeedLoad = true;
		m_MB_LoadSector.push(sec);
		planet = sec.m_Planet[m_MB_PlanetNum];

		var pl:Vector.<Planet> = new Vector.<Planet>();
		pl.push(planet);

		var itemtype:uint = m_MB_ItemType;
		var g_cnt:int = 0;
		var g_need:Number = 0;
		var g_prod:Number = 0;
		var g_dif:int = 0;
		
//trace("=========================");

		i=m_Sector.length-1;
		while (i >= 0) {
			if(m_Sector[i] is Sector) {
				sec = m_Sector[i];
				for (u = 0; u < sec.m_Planet.length; u++) {
					planet = sec.m_Planet[u];
					planet.m_Manuf = 0;
				}
			}
			i--;
		}

		var serverglobaltime:Number = GetServerGlobalTime();

		var sme:int = 0;
		while (sme < pl.length) {
			planet = pl[sme];
			sme++;

			var ownerid:uint = 0;
			if(planet.m_Owner==0) {
				for(u=0;u<Common.ShipOnPlanetMax;u++) {
					ship = planet.m_Ship[u];
					if(ship.m_Type!=Common.ShipTypeServiceBase) continue;
					if((ship.m_Flag & Common.ShipFlagBuild)!=0) continue;
					if(ship.m_Owner==0) continue;
					ownerid = ship.m_Owner;
					break;
				}
			} else ownerid = planet.m_Owner;

			// Производство
			if (ownerid != 0) {
				while (itemtype == Common.ItemTypeModule) {
					if ((planet.m_Flag & Planet.PlanetFlagHomeworld) != 0) { }
					else if ((planet.m_Flag & Planet.PlanetFlagCitadel) != 0 && IsWinMaxEnclave()) { }
					else break;

					cnt = Common.HomeworldModuleInc;

					if(m_CotlType==Common.CotlTypeUser) {
						if((m_CotlZoneLvl & 3)==3) {}
						else if((m_CotlZoneLvl & 3)==2) cnt+=cnt>>1;
						else if((m_CotlZoneLvl & 3)==1) cnt+=cnt;
						else  cnt+=cnt+(cnt>>1);
					} else if (m_CotlType == Common.CotlTypeRich) {
						cnt = Common.BaseModuleInc;
						cnt *= m_OpsModuleMul;
					}

					if (Common.ItemIsFinalLoop(itemtype)) {
						if ((m_Access & Common.AccessPlusarModule) && (ownerid == Server.Self.m_UserId && PlusarManuf())) {
							cnt += (cnt >> 1);
						}
					}
					if (m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && m_UserMulTime > 0) cnt *= Common.MulFactor;
					g_prod += cnt;
					planet.m_Manuf |= 1;
					break;
				}
				
				cnt = 0;
				var range:int = 1;

				if (itemtype == Common.ItemTypeHydrogen) {
					if ((planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) {
						for (i = 0; i < Common.ShipOnPlanetMax; i++) {
							ship = planet.m_Ship[i];
							if (ship.m_Type != Common.ShipTypeServiceBase) continue;
							if ((ship.m_Flag & Common.ShipFlagBuild) != 0) continue;
							cnt+=ship.m_Cnt;
						}
						if (cnt < 0) cnt = 0;
						else if (cnt > 4) cnt = 4;

						cnt = cnt * 13;
						range = 1;
					}

				} else if((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))==0) {
					for (i = 0; i < Common.BuildingItem.length; i++) {
						obj = Common.BuildingItem[i];
						if (obj.Build==0) continue;
						if (obj.ItemType != (itemtype & 0xffff)) continue;

						for (u = 0; u < Planet.PlanetCellCnt; u++) {
							bt = planet.m_Cell[u] >> 3;
							lvl = planet.m_Cell[u] & 7;
							if (bt != obj.BuildingType) continue;
							if (planet.m_CellBuildFlag & (1 << u)) lvl--;
							if (lvl <= 0) continue;

							cnt += obj.Cnt[lvl];
							range = Math.max(range, obj.Build);
						}
					}
				}

				var dif:int = 1;
				while (true) {
					if (cnt > 0) { }
					else if (itemtype == Common.ItemTypeMoney && planet.ConstructionLvl(Common.BuildingTypeCity) > 0) { }
					else break;

					dif = CalcItemDifficult(planet, itemtype);
					if (dif < 1) dif = 1;
					g_dif = Math.max(dif);
					break;
				}
				

				if ((itemtype == Common.ItemTypeMoney) && (planet.ConstructionLvl(Common.BuildingTypeCity) > 0)) {
					u = Common.BuildingCityNalog * planet.ConstructionLvl(Common.BuildingTypeCity);
					if ((m_Access & Common.AccessPlusarModule) && (ownerid == Server.Self.m_UserId && PlusarManuf())) {
						u += (u >> 1);
					}
					if (m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && m_UserMulTime > 0) u *= Common.MulFactor;
					
					g_prod += Number(u) / Number(dif);
					planet.m_Manuf |= 1;
				}

				if (cnt > 0) {
					if (IsWinMaxEnclave()) {
						if (Common.ItemIsFinalLoop(itemtype)) cnt *= m_OpsModuleMul;
					} else {
						if((itemtype==Common.ItemTypeModule) && (m_CotlType==Common.CotlTypeUser)) {
							if((m_CotlZoneLvl & 3)==3) {}
							else if((m_CotlZoneLvl & 3)==2) cnt+=cnt>>1;
							else if((m_CotlZoneLvl & 3)==1) cnt+=cnt;
							else  cnt+=cnt+(cnt>>1);
						}

						if (Common.ItemIsFinalLoop(itemtype)) {
							if (m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeCombat) cnt *= m_OpsModuleMul;
						}
					}

					if ((planet.m_Flag & Planet.PlanetFlagRich) != 0) cnt *= 3;

					if(Common.ItemIsFinalLoop(itemtype)) {
						if ((m_Access & Common.AccessPlusarModule) && (ownerid == Server.Self.m_UserId && PlusarManuf())) {
							cnt+=(cnt >> 1);
						}
					}

					if (m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && m_UserMulTime > 0) cnt *= Common.MulFactor;
					if (ownerid & Common.OwnerAI) {
						userm = UserList.Self.GetUser(ownerid);
						if (userm != null && userm.m_ManufMul > 1) cnt *= userm.m_ManufMul;
					}

					g_prod += Number(cnt) / Number(dif);
					planet.m_Manuf |= 1;
				}
			}

			// Потребление
			if (ownerid != 0) {
				cnt = 0;

				if ((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))==0) {
					for (i = 0; i < Common.BuildingItem.length; i++) {
						obj = Common.BuildingItem[i];
						if (obj.Build == 0) continue;

						for (k = 0; k < Planet.PlanetItemCnt; k++) {
							if ((planet.m_Item[k].m_Type & 0xffff) != obj.ItemType) continue;
							if ((planet.m_Item[k].m_Flag & PlanetItem.PlanetItemFlagBuild) == 0) continue;
							break;
						}
						if (k >= Planet.PlanetItemCnt) continue;

						for (k = i + 1; k < Common.BuildingItem.length; k++) {
							obj2=Common.BuildingItem[k];
							if (obj.BuildingType != obj2.BuildingType) break;
							if (obj2.Build != 0) break;

							if (obj2.ItemType != itemtype) continue;

							for (u = 0; u < Planet.PlanetCellCnt; u++) {
								bt = planet.m_Cell[u] >> 3;
								lvl = planet.m_Cell[u] & 7;
								if (bt != obj2.BuildingType) continue;
								if (planet.m_CellBuildFlag & (1 << u)) lvl--;
								if (lvl <= 0) continue;

								cnt += obj2.Cnt[lvl];
							}
						}
					}
				}

				if (cnt > 0) {
					if (m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && m_UserMulTime > 0) cnt *= Common.MulFactor;
					if (ownerid & Common.OwnerAI) {
						userm = UserList.Self.GetUser(ownerid);
						if (userm != null && userm.m_ManufMul > 1) cnt *= userm.m_ManufMul;
					}
					g_need += cnt;
					planet.m_Manuf |= 2;
				}
			}
			if (planet.m_Owner == ownerid && ownerid != 0 && (itemtype==Common.ItemTypeEngineer || itemtype==Common.ItemTypeMachinery)) {
				cnt = planet.PlanetNeedSupplyLvl();// PlanetNeedSupplyMax();
				if(cnt>0) {
					cnt = (cnt * (63 + cnt)) >> 5;
					if (m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && m_UserMulTime > 0) cnt *= Common.MulFactor;
					if (ownerid & Common.OwnerAI) {
						userm = UserList.Self.GetUser(ownerid);
						if (userm != null && userm.m_ManufMul > 1) cnt *= userm.m_ManufMul;
					}
					g_need += Number(cnt) / Number(3 * 60 * 24);
				}
			}

			// Cnt
			for (i = 0; i < planet.m_Item.length; i++) {
				if (planet.m_Item[i].m_Type != m_MB_ItemType) continue;
				g_cnt += planet.m_Item[i].m_Cnt;
			}
			for (i = 0; i < Common.ShipOnPlanetMax; i++) {
				ship = planet.m_Ship[i]
				if (ship == null) continue;
				if (ship.m_CargoType != itemtype) continue;
				g_cnt |= ship.m_CargoCnt;
			}

			while (planet.m_Path!=0) {
				tsecx=planet.m_Sector.m_SectorX;
				tsecy=planet.m_Sector.m_SectorY;
				tplanet = (planet.m_Path >> 4) & 7;
				if (planet.m_Path & 1) tsecx += 1; else if (planet.m_Path & 2) tsecx -= 1;
				if (planet.m_Path & 4) tsecy += 1; else if (planet.m_Path & 8) tsecy -= 1;
				if (planet.m_Sector.m_SectorX == tsecx && planet.m_Sector.m_SectorY == tsecy && planet.m_PlanetNum == tplanet) break;

				sec = GetSectorEx(tsecx, tsecy);
				if (sec == null) break;
				sec.m_NeedLoad = true;
				if (m_MB_LoadSector.indexOf(sec) < 0) m_MB_LoadSector.push(sec);

				if (tplanet<0 || tplanet>=sec.m_Planet.length) break;
				planet2 = sec.m_Planet[tplanet];

				if (pl.indexOf(planet2) >= 0) break;
				pl.push(planet2);
				break;
			}

			while(planet.m_PortalPlanet>0) {
				if (planet.m_PortalCotlId != 0) break;

				tplanet = planet.m_PortalPlanet - 1;
				if (tplanet >= 4) break;

				sec = GetSectorEx(planet.m_PortalSectorX, planet.m_PortalSectorY);
				if (sec == null) break;
				sec.m_NeedLoad = true;
				if (m_MB_LoadSector.indexOf(sec) < 0) m_MB_LoadSector.push(sec);

				if (tplanet<0 || tplanet>=sec.m_Planet.length) break;
				planet2 = sec.m_Planet[tplanet];
//trace("PortalTo",planet2.m_Sector.m_SectorX,planet2.m_Sector.m_SectorY,planet2.m_PlanetNum);

				if (pl.indexOf(planet2) >= 0) break;
				pl.push(planet2);
				break;
			}

			for (y = planet.m_Sector.m_SectorY - 1; y <= planet.m_Sector.m_SectorY + 1; y++) {
				for (x = planet.m_Sector.m_SectorX - 1; x <= planet.m_Sector.m_SectorX + 1; x++) {
					sec = GetSectorEx(x, y);
					if (sec == null) continue;
					sec.m_NeedLoad = true;
					if (m_MB_LoadSector.indexOf(sec) < 0) m_MB_LoadSector.push(sec);

					for (i = 0; i < sec.m_Planet.length; i++) {
						planet2 = sec.m_Planet[i];
						if (planet2.m_Path == 0) continue;

						tsecx=x;
						tsecy=y;
						tplanet=(planet2.m_Path>>4)&7;
						if(planet2.m_Path & 1) tsecx+=1; else if(planet2.m_Path & 2) tsecx-=1;
						if(planet2.m_Path & 4) tsecy+=1; else if(planet2.m_Path & 8) tsecy-=1;
						if (x == tsecx && y == tsecy && i == tplanet) continue;

//trace(planet.m_Sector.m_SectorX, planet.m_Sector.m_SectorY, planet.m_PlanetNum, "====", planet2.m_Sector.m_SectorX, planet2.m_Sector.m_SectorY, planet2.m_PlanetNum, "====", tsecx, tsecy, tplanet);
						if (tsecx != planet.m_Sector.m_SectorX || tsecy != planet.m_Sector.m_SectorY || planet.m_PlanetNum != tplanet) continue;

						if (pl.indexOf(planet2) >= 0) continue;
						pl.push(planet2);
					}
				}
			}
		}

		if (!m_MB_Send) {
			for (i = 0; i < m_MB_LoadSector.length; i++) {
				sec = m_MB_LoadSector[i];
				if (sec.m_UpdateTime == 0) break;
				if (sec.m_UpdateTime + 5000 < m_CurTime) break;
			}
			while(i>=m_MB_LoadSector.length) {
				m_MB_Send = true;

				sec = GetSectorEx(m_MB_SectorX, m_MB_SectorY);
				if (sec == null) break;
				if (m_MB_PlanetNum<0 || m_MB_PlanetNum>=sec.m_Planet.length) break;
				planet = sec.m_Planet[m_MB_PlanetNum];

				var fbuild:int = 0;
				for (i = 0; i < planet.m_Item.length; i++) {
					if (planet.m_Item[i].m_Type != itemtype) continue;
					if ((planet.m_Item[i].m_Flag & PlanetItem.PlanetItemFlagBuild) == 0) continue;
					fbuild = 1;
					break;
				}

				var ni0:uint = 0;
				var ni1:uint = 0;
				var ni2:uint = 0;
				if (fbuild == 1) {
					for (i = 0; i < Common.BuildingItem.length; i++) {
						obj = Common.BuildingItem[i];
						if (obj.Build == 0) continue;
						if (obj.ItemType != (itemtype & 0xffff)) continue;

						for (u = 0; u < Planet.PlanetCellCnt; u++) {
							bt = planet.m_Cell[u] >> 3;
							lvl = planet.m_Cell[u] & 7;
							if (bt != obj.BuildingType) continue;
							if (planet.m_CellBuildFlag & (1 << u)) lvl--;
							if (lvl <= 0) continue;

							break;
						}
						if (u >= Planet.PlanetCellCnt) continue;
						
						fbuild = 2;
						for (k = i + 1; k < Common.BuildingItem.length; k++) {
							obj2=Common.BuildingItem[k];
							if (obj.BuildingType != obj2.BuildingType) break;
							if (obj2.Build != 0) break;
							
							if (ni0 == 0) ni0 = obj2.ItemType;
							else if (ni1 == 0) ni1 = obj2.ItemType;
							else if (ni2 == 0) ni2 = obj2.ItemType;
						}
						
						break;
					}
				}

				for (i = 0; i < m_MB_Hist.length; i += 7) {
					if (m_MB_Hist[i + 0] == itemtype) break;
				}
				if (i < m_MB_Hist.length) {
					m_MB_Hist[i + 1] = g_prod - g_need;
					m_MB_Hist[i + 2] = g_dif;
					m_MB_Hist[i + 3] = (fbuild >= 2)?1:0
					m_MB_Hist[i + 4] = ni0;
					m_MB_Hist[i + 5] = ni1;
					m_MB_Hist[i + 6] = ni2;
				} else {
					i = m_MB_Hist.length;
					m_MB_Hist.push(itemtype);
					m_MB_Hist.push(g_prod - g_need);
					m_MB_Hist.push(g_dif);
					m_MB_Hist.push((fbuild >= 2)?1:0);
					m_MB_Hist.push(ni0);
					m_MB_Hist.push(ni1);
					m_MB_Hist.push(ni2);
				}

				for (t = 0; t < m_MB_Hist.length; t += 7) {
					if (m_MB_Hist[t + 3] & 1) {
						k = 0;
						if (m_MB_Hist[t + 4] != 0) k++;
						if (m_MB_Hist[t + 5] != 0) k++;
						if (m_MB_Hist[t + 6] != 0) k++;
						p = k;
						for (u = 0; u < m_MB_Hist.length; u += 7) {
							if (m_MB_Hist[u + 0] == m_MB_Hist[t + 4] || m_MB_Hist[u + 0] == m_MB_Hist[t + 5] || m_MB_Hist[u + 0] == m_MB_Hist[t + 6]) {
								if (m_MB_Hist[u + 1] >= 0) p--;
								k--;
							}
						}
						if (k <= 0) m_MB_Hist[t + 3] |= 4;
						else m_MB_Hist[t + 3] &= ~4;
						if (k <= 0 && p <= 0) m_MB_Hist[t + 3] |= 2;
						else m_MB_Hist[t + 3] &= ~2;
					}
				}
				
				if ((m_MB_Hist[i + 3] & 1) != 0 && (m_MB_Hist[i + 3] & 4) == 0) { }
				else {
					SendAction("empibal", "" + m_MB_SectorX.toString() + "_" + m_MB_SectorY.toString() + "_" + m_MB_PlanetNum.toString() 
							+ "_" + m_MB_Hist[i + 0].toString() 
							+ "_" + m_MB_Hist[i + 1].toString() 
							+ "_" + m_MB_Hist[i + 2].toString()
							+ "_" + (m_MB_Hist[i + 3] & 3).toString());
				}

				for (i = 0; i < m_MB_Hist.length; i += 7) {
					if ((m_MB_Hist[i + 3] & (1 | 4)) != (1 | 4)) continue;

					if (m_MB_Hist[i + 4] == itemtype || m_MB_Hist[i + 5] == itemtype || m_MB_Hist[i + 6] == itemtype) { }
					else continue;

					SendAction("empibal", "" + m_MB_SectorX.toString() + "_" + m_MB_SectorY.toString() + "_" + m_MB_PlanetNum.toString() 
							+ "_" + m_MB_Hist[i + 0].toString()
							+ "_" + m_MB_Hist[i + 1].toString()
							+ "_" + m_MB_Hist[i + 2].toString()
							+ "_" + (m_MB_Hist[i + 3] & 3).toString());
				}

				break;
			}
		}
		
		if(m_FormItemBalans.SetVal(g_cnt, g_need, g_prod, g_dif)) {
			m_FormMiniMap.Update();
		}
	}

	public function CalcPickDir(mpx:int, mpy:int, vpos:Vector3D, vdir:Vector3D):void
	{
		var wrleft:int = 0;
		var wrtop:int = 0;
		var wrright:int = C3D.m_SizeX;// m_Map.m_StageSizeX;
		var wrbottom:int = C3D.m_SizeY;// m_Map.m_StageSizeY;

		var vx:Number =  ( ( ( 2.0 * Number(mpx - wrleft) ) / Number(wrright - wrleft) ) - 1 ) / m_MatPer.rawData[0 * 4 + 0];
		var vy:Number = -( ( ( 2.0 * Number(mpy - wrtop) ) / Number(wrbottom - wrtop) ) - 1 ) / m_MatPer.rawData[1 * 4 + 1];
		var vz:Number =  -1.0;

		vdir.x = vx * m_MatViewInv.rawData[0 * 4 + 0] + vy * m_MatViewInv.rawData[1 * 4 + 0] + vz * m_MatViewInv.rawData[2 * 4 + 0];
		vdir.y = vx * m_MatViewInv.rawData[0 * 4 + 1] + vy * m_MatViewInv.rawData[1 * 4 + 1] + vz * m_MatViewInv.rawData[2 * 4 + 1];
		vdir.z = vx * m_MatViewInv.rawData[0 * 4 + 2] + vy * m_MatViewInv.rawData[1 * 4 + 2] + vz * m_MatViewInv.rawData[2 * 4 + 2];
		vdir.normalize();

		vpos.x = m_MatViewInv.rawData[3 * 4 + 0];
		vpos.y = m_MatViewInv.rawData[3 * 4 + 1];
		vpos.z = m_MatViewInv.rawData[3 * 4 + 2];
	}

	static public var m_TPickPos:Vector3D = new Vector3D();
	static public var m_TPickDir:Vector3D = new Vector3D();
	static public var m_TPickPlane:Vector3D = new Vector3D();

	public function PickWorldCoord(mpx:int, mpy:int, out:Vector3D):Boolean
	{
		var z:Number = 0;

		CalcPickDir(mpx, mpy, m_TPickPos, m_TPickDir);
		m_TPickPos.x += m_CamSectorX * m_SectorSize + m_CamPos.x;
		m_TPickPos.y += m_CamSectorY * m_SectorSize + m_CamPos.y;
		m_TPickPos.z += m_CamPos.z;

		//var pl:Vector3D = new Vector3D();
		Math3D.PlaneFromPointNormal(0, 0, -z, 0, 0, 1, m_TPickPlane);
		//Hyperspace.PlaneFromPointNormal(new Vector3D(0, 0, -z), new Vector3D(0, 0, 1), m_TPickPlane);

		m_TPickDir.x = m_TPickPos.x + m_TPickDir.x;
		m_TPickDir.y = m_TPickPos.y + m_TPickDir.y;
		m_TPickDir.z = m_TPickPos.z + m_TPickDir.z;

		if (!HyperspaceBase.PlaneIntersectionLine(m_TPickPlane, m_TPickPos, m_TPickDir, out)) return false;
		
		return true;
	}

	public function FactorScr2WorldDist(x:Number, y:Number, z:Number):Number // Преобразуем кол-во пикселей на экране в длину (по расстоянию от камеры до центра)
	{
		x = -m_MatView.rawData[3 * 4 + 0] - x;
		y = -m_MatView.rawData[3 * 4 + 1] - y;
		z = -m_MatView.rawData[3 * 4 + 2] - z;
		var dist:Number = Math.sqrt(x * x + y * y + z * z);
		return  dist * m_FactorScr2WorldDist;
	}

	public function WorldToScreen(v:Vector3D):void
	{
		var v2:Vector3D = m_MatViewPer.transformVector(v);
		v.x = (v2.x / v2.w) * C3D.m_SizeX * 0.5 + (C3D.m_SizeX * 0.5);
		v.y = -(v2.y / v2.w) * C3D.m_SizeY * 0.5 + (C3D.m_SizeY * 0.5);
		v.z = 0.0;
		v.w = 0.0;
	}

	public function CamDistMove():void
	{
		var ct:Number=m_CurTime;

		if (m_CamDistTime == 0) m_CamDistTime = ct;
		if(ct<m_CamDistTime+10) return;

		var cd:Number = m_CamDist;

		var dir:Number=m_CamDistTo-cd;

		var speed:Number=8.0*Number(ct-m_CamDistTime);

		if (Math.abs(dir) <= speed) cd = m_CamDistTo;
		else if (dir < 0.0) cd -= speed;
		else cd += speed;

		//ChangeCamDist(cd,ct,false);
		m_CamDist = cd;

		m_CamDistTime=ct;
	}

	public function CamDistChange():void
	{
		if(m_CamDistChangeTime>m_CurTime) return;
		m_CamDistChangeTime = m_CurTime + 500;
		
		var i:int;
		
		for (i = 0; i < CamDistArray.length; i++) if (CamDistArray[i] == m_CamDistTo) break;
		if (i >= CamDistArray.length) i = -1;

		var speed:Number = 0.4;

		if (m_CamDistDir < 0) {
			if (i < 0) {
				m_CamDistTo = CamDistMin;
			} else {
				if (i > 0) { i--; m_CamDistTo = CamDistArray[i]; }
				else m_CamDistTo = CamDistMin;
			}
	//			m_CamDistTo = Math.max(CamDistMin, m_CamDistTo * (1.0 - speed));
	//			if ((m_CamDistTo - CamDistMin) < CamDistMin * speed * 0.5) m_CamDistTo = CamDistMin;
		} else {
			if (i < 0) {
				m_CamDistTo = CamDistMax;
			} else {
				if (i < (CamDistArray.length - 1)) { i++; m_CamDistTo = CamDistArray[i]; }
				else m_CamDistTo = CamDistMax;
			}
	//			m_CamDistTo = Math.min(CamDistMax, m_CamDistTo * (1.0 + speed));
	//			if (CamDistMax - m_CamDistTo < CamDistMax * speed * 0.5) m_CamDistTo = CamDistMax;
		}
	}

	private var m_ConstViewZone:Vector.<Number> = new Vector.<Number>(256/*24 * 2*/ * 2, true);

	public function BuildViewZone(cntmax:int):int
	{
		var i:int,u:int,k:int,x:int,y:int;
		var sec:Sector;
		var planet:Planet;
		var ship2:Ship;
		
		var off:int = 0;

	//		if(m_GraphJumpRadius.m_PlanetNum>=0 || !m_Set_Vis) {
	//			return 0;
	//		}
	//		if(m_CotlType==Common.CotlTypeUser && m_CotlOwnerId==Server.Self.m_UserId && m_HomeworldPlanetNum<0) {
	//			return 0;
	//		}
	//		if ((m_CotlType == Common.CotlTypeCombat || m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeRich) && (m_OpsFlag & Common.OpsFlagViewAll) != 0) {
	//			return 0;
	//		}
	//		if(IsEdit()) {
	//			return 0;
	//		}
		
		var ac:int = 0;
		
		if(!IsSpaceOff()) {
			if (!PickWorldCoord(0, 0, m_TV0)) return 0;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) return 0;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) return 0;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) return 0;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

			for (y = sy; y < ey; y++) {
				for (x = sx; x < ex; x++) {
					i = (x - m_SectorMinX) + (y - m_SectorMinY) * m_SectorCntX;
					if (i < 0 || i >= m_SectorCntX * m_SectorCntY) throw Error("");
					if (!(m_Sector[i] is Sector)) continue;
					sec = m_Sector[i];

					for(i=0;i<sec.m_Planet.length;i++) {
						planet = sec.m_Planet[i];

						if (m_Action == ActionPlanetMove && m_MoveSectorX == x && m_MoveSectorY == y && m_MovePlanetNum == i) continue;

						if (IsVisCalc(planet, false)) {
							ac++;
							if (off <= ((cntmax << 1) - 2)) {
								m_ConstViewZone[off++] = planet.m_PosX - m_CamPos.x - m_CamSectorX * m_SectorSize;
								m_ConstViewZone[off++] = planet.m_PosY - m_CamPos.y - m_CamSectorY * m_SectorSize;
							} //else trace("No empty space for view circle",ac);
						}
					}
				}
			}
		}

		return off;
	}

	public var m_DrawLast:Number = 0;

	public function Draw():void
	{
		var i:int,x:int,y:int;

		if (!C3D.IsReady()) return;
		
	//trace(getSampleCount());
		
var t00:int = getTimer();

		var ct:Number=Common.GetTime();
		var dt:Number = ct - m_DrawLast;
		if (dt < 5) return;
		if (dt > 1000) dt = 1000;
		m_DrawLast = ct;

		m_LightPlanet.x = Math.sin(m_LightPlanetRotate);
		m_LightPlanet.y = Math.sin(m_LightPlanetAngle) * Math.cos(m_LightPlanetRotate);
		m_LightPlanet.z = Math.cos(m_LightPlanetAngle);
		m_LightPlanet.normalize();

		if (m_CamDistDir != 0) CamDistChange();
		if (m_CamDistTo != m_CamDist) CamDistMove();
		else {
			m_CamDistTime=0;
			//if (m_CamDistDir != 0) m_CamDistDir = 0;
		}

		m_MatView.identity();
		m_MatView.appendRotation(m_CamRotate * Space.ToGrad, Vector3D.Z_AXIS);
		m_MatView.appendRotation(-m_CamAngle * Space.ToGrad, Vector3D.X_AXIS);
		m_MatView.appendTranslation(0.0, 0.0, -m_CamDist);
		m_MatViewInv.copyFrom(m_MatView);
		m_MatViewInv.invert();

		m_View = m_MatViewInv.transformVector(new Vector3D(0.0, 0.0, 0.0, 1.0));

		m_Frustum.Clac(m_MatViewInv, m_MatPer);

		var minz:Number = CamDistMin - 500;
		var maxz:Number = CamDistMax + 500;

		m_MatPer.perspectiveFieldOfViewRH(m_Fov, Number(C3D.m_SizeX) / C3D.m_SizeY, minz, maxz);
		m_MatViewPer.copyFrom(m_MatView);
		m_MatViewPer.append(m_MatPer);
		m_FactorScr2WorldDist = m_FovHalfTan / Number(C3D.m_SizeY >> 1);

		// Prepare
var t01:int = getTimer();
		var gs:GraphShip;
		var gp:GraphPlanet;
		var gi:GraphItem;
		var ge:GraphExplosion;
		GraphPlanet.PBuild();

		GraphShip.PrepareTextBegin();
		GraphItem.PrepareTextBegin();
		for (i = 0; i < m_ShipList.length; i++) {
			gs = m_ShipList[i];
			if (m_Frustum.IsIn(gs.m_PosX - m_CamPos.x - m_SectorSize * m_CamSectorX, gs.m_PosY - m_CamPos.y - m_SectorSize * m_CamSectorY, 0.0, 30.0)) gs.PrepareText();
		}
		for (i = 0; i < m_ItemList.length; i++) {
			gi = m_ItemList[i];
			if (m_Frustum.IsIn(gi.m_PosX - m_CamPos.x - m_SectorSize * m_CamSectorX, gi.m_PosY - m_CamPos.y - m_SectorSize * m_CamSectorY, 0.0, 20.0)) gi.PrepareText();
		}
		GraphItem.PrepareTextEnd();
		GraphShip.PrepareTextEnd();

		GraphBullet.PClear();
		for (i = 0; i < m_BulletList.length; i++) {
			m_BulletList[i].PPrepare();
		}
		GraphBullet.PApply();

		for (i = 0; i < m_ExplosionList.length; i++) {
			ge = m_ExplosionList[i];
			ge.DrawPrepare(dt);
		}

		// Begin
var t02:int = getTimer();
		//C3D.FrameBegin(false);
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE );
		C3D.Context.setDepthTest(false, Context3DCompareMode.ALWAYS);
		C3D.Context.setStencilActions();
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.NONE);

		// BG
		var clr:uint = m_BG.m_Cfg.FillColor;
		C3D.Context.clear(C3D.ClrToFloat * ((clr >> 16) & 255), C3D.ClrToFloat * ((clr >> 8) & 255), C3D.ClrToFloat * ((clr) & 255), 0, 1.0, 0);

		if (m_BG.Prepare()) {
			for (i = -1; i < 4; i++) m_BG.Draw(OffsetX, OffsetY, i);
		}

		// Grid
var t03:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		m_BG.DrawGrid();

		// path
var t04:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		C3D.Context.setCulling(Context3DTriangleFace.NONE);
		GraphPlanet.PDraw(0);

		// Planet
var t05:int = getTimer();
		C3D.m_Pass = C3D.PassDif;

//var planet_list:int = 0, planet_draw:int = 0, planet_text:int = 0;
		for (i = 0; i < m_PlanetList.length; i++) {
			gp = m_PlanetList[i];
//planet_list++;
			if (m_Frustum.IsIn(gp.m_PosX - m_CamPos.x - m_SectorSize * m_CamSectorX, gp.m_PosY - m_CamPos.y - m_SectorSize * m_CamSectorY, 0.0, gp.Radius() + 10.0)) {
//planet_draw++;
				gp.Draw();
			}
		}
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		C3D.Context.setCulling(Context3DTriangleFace.NONE);

		// View zone
		while (m_Action == ActionPlanetMove && IsEdit()) {
			if (!PickWorldCoord(0, 0, m_TV0)) break;
			if (!PickWorldCoord(C3D.m_SizeX, 0, m_TV1)) break;
			if (!PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, m_TV2)) break;
			if (!PickWorldCoord(0, C3D.m_SizeY, m_TV3)) break;
			var sx:int = Math.max(m_SectorMinX, Math.floor(Math.min(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) - 1);
			var sy:int = Math.max(m_SectorMinY, Math.floor(Math.min(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) - 1);
			var ex:int = Math.min(m_SectorMinX + m_SectorCntX, Math.floor(Math.max(m_TV0.x, m_TV1.x, m_TV2.x, m_TV3.x) / m_SectorSize) + 2);
			var ey:int = Math.min(m_SectorMinY + m_SectorCntY, Math.floor(Math.max(m_TV0.y, m_TV1.y, m_TV2.y, m_TV3.y) / m_SectorSize) + 2);

			for (y = sy; y < ey; y++) {
				var rbx:Number = WorldToScreenX(sx * m_SectorSize, y * m_SectorSize - (Common.PlanetMinDist >> 2));
				var rby:Number = m_TWSPos.y;
				var rex:Number = WorldToScreenX(ex * m_SectorSize, y * m_SectorSize + (Common.PlanetMinDist >> 2));
				var rey:Number = m_TWSPos.y;

				C3D.DrawImg(GraphPlanet.m_TexIntf, 0x88ff0000, rbx, rby, rex - rbx, rey - rby, 2, 2, 1, 1);
			}
			for (x = sx; x < ex; x++) {
				rbx = WorldToScreenX(x * m_SectorSize - (Common.PlanetMinDist >> 2), sy * m_SectorSize);
				rby = m_TWSPos.y;
				rex = WorldToScreenX(x * m_SectorSize + (Common.PlanetMinDist >> 2), ey * m_SectorSize);
				rey = m_TWSPos.y;

				C3D.DrawImg(GraphPlanet.m_TexIntf, 0x88ff0000, rbx, rby, rex - rbx, rey - rby, 2, 2, 1, 1);
			}
			break;
		}
		
var t06:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		while (ScopeVis) {
			if ((m_CotlType == Common.CotlTypeUser) && (m_CotlOwnerId == Server.Self.m_UserId) && (m_HomeworldPlanetNum < 0) && (m_GameState & Common.GameStateTraining) == 0) {
				break;
			}
			if ((m_CotlType == Common.CotlTypeCombat || m_CotlType == Common.CotlTypeProtect || m_CotlType == Common.CotlTypeRich) && (m_OpsFlag & Common.OpsFlagViewAll) != 0) {
				break;
			}
			if(IsEdit()) {
				break;
			}
			
			C3D.SetVConstMatrix(0, m_MatViewPer);
			C3D.SetVConst_n(4, 0.0, 0.5, 1.0, 2.0);

			PickWorldCoord(-1, -1, m_TV0);
			PickWorldCoord(C3D.m_SizeX + 1, -1, m_TV1);
			PickWorldCoord(C3D.m_SizeX + 1, C3D.m_SizeY + 1, m_TV2);
			PickWorldCoord( -1, C3D.m_SizeY + 1, m_TV3);
			C3D.SetVConst_n(5, m_TV0.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV0.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(6, m_TV1.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV1.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(7, m_TV2.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV2.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(8, m_TV3.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV3.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);

			C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
			C3D.SetFConst_n(1, m_OpsJumpRadius - 20, 1.0 / 40.0, 0.0, 0.0);
			C3D.SetFConst_Color(2, 0xcc000000);

			var off:int = 0;
			off = BuildViewZone(24*2);
			if (off <= 0) {
				m_ConstViewZone[off++] = 1000000;
				m_ConstViewZone[off++] = 1000000;
			}
			if (off <= 0) break;
			
			for (i = off; i < (24 * 2 * 2); i += 2) { m_ConstViewZone[i] = m_ConstViewZone[off - 2]; m_ConstViewZone[i + 1] = m_ConstViewZone[off - 1]; }

			C3D.Context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, m_ConstViewZone, 24);

			if (m_Action == ActionPlanetMove) {
				C3D.ShaderRedZone();
			} else {
				C3D.ShaderCircle(false);
			}
			C3D.VBImg();
			C3D.DrawQuad();
			break;
		}
		
		// RedZone
		while (m_Action == ActionPlanetMove && IsEdit()) {
			C3D.SetVConstMatrix(0, m_MatViewPer);
			C3D.SetVConst_n(4, 0.0, 0.5, 1.0, 2.0);

			PickWorldCoord(-1, -1, m_TV0);
			PickWorldCoord(C3D.m_SizeX + 1, -1, m_TV1);
			PickWorldCoord(C3D.m_SizeX + 1, C3D.m_SizeY + 1, m_TV2);
			PickWorldCoord( -1, C3D.m_SizeY + 1, m_TV3);
			C3D.SetVConst_n(5, m_TV0.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV0.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(6, m_TV1.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV1.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(7, m_TV2.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV2.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(8, m_TV3.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV3.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);

			C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
			C3D.SetFConst_n(1, Common.PlanetMinDist * Common.PlanetMinDist, (m_OpsJumpRadius - 50) * (m_OpsJumpRadius - 50), (m_OpsJumpRadius + 50) * (m_OpsJumpRadius + 50), 0.0);
			C3D.SetFConst_Color(2, 0x88ff0000);

			off = BuildViewZone(64 * 2);
			if (off <= 0) break;

			C3D.ShaderRedZone();
			C3D.VBImg();

			for (i = 0; i < off; i += 2) {
				C3D.SetFConst_n(4, m_ConstViewZone[i], m_ConstViewZone[i + 1], 0, 0);
				C3D.DrawQuad();
			}
			break;
		}
		
		// Jump radius
var t07:int = getTimer();
		while (m_JumpRadiusShow) {
			gp = GetGraphPlanet(m_MoveSectorX, m_MoveSectorY, m_MovePlanetNum);
			if (gp == null) break;
			//off = 0;
			//m_ConstViewZone[off++] = gp.m_PosX - m_CamPos.x - m_CamSectorX * m_SectorSize;
			//m_ConstViewZone[off++] = gp.m_PosY - m_CamPos.y - m_CamSectorY * m_SectorSize;
			//for (i = off; i < m_ConstViewZone.length; i += 2) { m_ConstViewZone[i] = m_ConstViewZone[off - 2]; m_ConstViewZone[i + 1] = m_ConstViewZone[off - 1]; }
			
			C3D.SetVConstMatrix(0, m_MatViewPer);
			C3D.SetVConst_n(4, 0.0, 0.5, 1.0, 2.0);

			PickWorldCoord(-1, -1, m_TV0);
			PickWorldCoord(C3D.m_SizeX + 1, -1, m_TV1);
			PickWorldCoord(C3D.m_SizeX + 1, C3D.m_SizeY + 1, m_TV2);
			PickWorldCoord( -1, C3D.m_SizeY + 1, m_TV3);
			C3D.SetVConst_n(5, m_TV0.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV0.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(6, m_TV1.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV1.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(7, m_TV2.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV2.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);
			C3D.SetVConst_n(8, m_TV3.x - m_CamPos.x - m_CamSectorX * m_SectorSize, m_TV3.y - m_CamPos.y - m_CamSectorY * m_SectorSize, 0.0, 0.0);

			C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
			C3D.SetFConst_n(1, m_OpsJumpRadius, 1.0 / (m_FactorScr2WorldDist * m_CamDist * 1.5), m_OpsJumpRadius + (m_FactorScr2WorldDist * m_CamDist * 4.0), 1.0 / (m_FactorScr2WorldDist * m_CamDist * 1.5));
			C3D.SetFConst_Color(2, 0xa0000000);
			C3D.SetFConst_Color(3, 0xffffffff);

			//C3D.Context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, m_ConstViewZone, m_ConstViewZone.length >> 2);
			C3D.SetFConst_n(4, gp.m_PosX - m_CamPos.x - m_CamSectorX * m_SectorSize, gp.m_PosY - m_CamPos.y - m_CamSectorY * m_SectorSize, 0, 0);

			C3D.ShaderCircleContour();
			C3D.VBImg();
			C3D.DrawQuad();
			break;
		}

		// ShipPlace
var t08:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		for (i = 0; i < m_ShipPlaceList.length; i++) {
			m_ShipPlaceList[i].Draw();
		}
		
		// Item text
var t09:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ); // так как ресуется через текстуру. а там цвет уже умножен на альфу
		GraphItem.DrawText();

		// Ship
var t10:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		for (i = 0; i < m_ShipList.length; i++) {
			gs = m_ShipList[i];
			if (m_Frustum.IsIn(gs.m_PosX - m_CamPos.x - m_SectorSize * m_CamSectorX, gs.m_PosY - m_CamPos.y - m_SectorSize * m_CamSectorY, 0.0, 30.0)) gs.DrawShip();
		}

		// Bullet
var t11:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
	//		C3D.Context.setCulling(Context3DTriangleFace.NONE);
		GraphBullet.PDraw();
		
		// Explosion
var t12:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		for (i = 0; i < m_ExplosionList.length; i++) {
			ge = m_ExplosionList[i];
			ge.Draw();
		}

		// Planet Text
var t13:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
	//		C3D.Context.setCulling(Context3DTriangleFace.NONE);

		for (i = 0; i < m_PlanetList.length; i++) {
			gp = m_PlanetList[i];
			if (m_Frustum.IsIn(gp.m_PosX - m_CamPos.x - m_SectorSize * m_CamSectorX, gp.m_PosY - m_CamPos.y - m_SectorSize * m_CamSectorY, 0.0, gp.Radius() + 10.0)) {
	//planet_text++;
				gp.DrawText();
			}
		}
	//trace("Planet", "List:", planet_list, "Draw:", planet_draw, "Text:", planet_text);
	//trace("C3DQuadBatch::Alloc:", C3DQuadBatch.m_IBAlloc, C3DQuadBatch.m_VBAlloc);

		// Ship text
var t14:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ); // так как ресуется через текстуру. а там цвет уже умножен на альфу
		for (i = 0; i < m_ShipList.length; i++) {
			gs = m_ShipList[i];
			if (m_Frustum.IsIn(gs.m_PosX - m_CamPos.x - m_SectorSize * m_CamSectorX, gs.m_PosY - m_CamPos.y - m_SectorSize * m_CamSectorY, 0.0, 30.0)) gs.DrawName();
		}

		GraphShip.DrawText();

		// Select & Path
var t15:int = getTimer();
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		m_GraphSelect.Draw();
		m_GraphMovePath.Draw();

var t16:int = getTimer();
if((t16 - t00) > 50 && EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("!SLOW.EMD " + 
(t01 - t00).toString() 
+ " " + (t02 - t01).toString() 
+ " " + (t03 - t02).toString() 
+ " " + (t04 - t03).toString() 
+ " " + (t05 - t04).toString()
+ " " + (t06 - t05).toString()
+ " " + (t07 - t06).toString()
+ " " + (t08 - t07).toString()
+ " " + (t09 - t08).toString()
+ " " + (t10 - t09).toString()
+ " " + (t11 - t10).toString()
+ " " + (t12 - t11).toString()
+ " " + (t13 - t12).toString()
+ " " + (t14 - t13).toString()
+ " " + (t15 - t14).toString()
+ " " + (t16 - t15).toString()
);

	}
}

}
