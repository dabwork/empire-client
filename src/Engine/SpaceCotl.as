package Engine
{

public class SpaceCotl extends SpaceEntity
{
    static public const DevAccessAssignRights:uint=1; // Право назначать права
    static public const DevAccessView:uint=2; // Право на просмотр редактируемых данных
    static public const DevAccessEditMap:uint=4; // Право на редактирование карты
    static public const DevAccessEditCode:uint=8; // Право на редактирование кода
    static public const DevAccessEditOps:uint=16; // Право на изменение настроек

	static public const DefaultZ:Number = -700.0;
	
	static public const fPlanetShield:int = 1;
	static public const fPlanetShieldOn:int = 2;
	static public const fDevelopment:int = 4;
    static public const fTemplate:int = 8; // Шаблонное созвездие. Можно только редактировать.
    static public const fCombatInMap:int = 16;
    static public const fPortalEnterShip:int=32;
    static public const fPortalEnterFlagship:int = 64;
	static public const fPortalEnterAllItem:int = 128;
	static public const fBeacon:int = 256;

	public var m_CotlType:int=0;
	public var m_CotlFlag:uint=0;
	public var m_CotlSize:int=0;
	public var m_AccountId:uint=0;
	public var m_UnionId:uint=0;

	public var m_RestartTime:uint=0;
	public var m_TimeData:uint = 0;
	public var m_RewardExp:int = 0;

	public var m_ServerAdr:uint=0;
	public var m_ServerPort:uint=0;
	public var m_ServerNum:uint=0;
	public var m_ServerMode:uint=0;

	public var m_BonusType0:int=0;
	public var m_BonusVal0:int=0;
	public var m_BonusType1:int=0;
	public var m_BonusVal1:int=0;
	public var m_BonusType2:int=0;
	public var m_BonusVal2:int=0;
	public var m_BonusType3:int=0;
	public var m_BonusVal3:int=0;
	public var m_PriceEnterType:int=0;
	public var m_PriceEnter:int=0;
	public var m_PriceCaptureType:int=0;
	public var m_PriceCapture:int=0;
	public var m_PriceCaptureEgm:int = 0;

	public var m_ProtectTime:Number = 0;
	
	public var m_ExitTime:uint = 0;
	public var m_PlanetShieldHour:int = 0;
	public var m_PlanetShieldEnd:uint = 0;
	public var m_PlanetShieldCooldown:uint = 0;

	public var m_DefCnt:int = 0;
	public var m_DefScoreAll:int = 0;
	public var m_DefOwner0:uint = 0;
	public var m_DefScore0:int = 0;
	public var m_DefOwner1:uint = 0;
	public var m_DefScore1:int = 0;
	public var m_DefOwner2:uint = 0;
	public var m_DefScore2:int = 0;

	public var m_AtkCnt:int = 0;
	public var m_AtkScoreAll:int = 0;
	public var m_AtkOwner0:uint = 0;
	public var m_AtkScore0:int = 0;
	public var m_AtkOwner1:uint = 0;
	public var m_AtkScore1:int = 0;
	public var m_AtkOwner2:uint = 0;
	public var m_AtkScore2:int = 0;
	
	public var m_Dev0:uint = 0;
	public var m_Dev1:uint = 0;
	public var m_Dev2:uint = 0;
	public var m_Dev3:uint = 0;
	public var m_DevAccess:uint = 0;
	public var m_DevFlag:uint = 0;
	public var m_DevTime:Number = 0;

	public var m_LoadTime:Number = 0; // Время загрузки срзвездия (не учитываются: координаты, версии). SpaceEntity.m_RecvFull - загруженно созвездие вместе с координатами и версиями.
	public var m_Reload:Boolean = true;

	public var m_OldOffsetSet:Boolean=false;
	public var m_OldOffsetX:Number=0;
	public var m_OldOffsetY:Number=0;

	public var m_NewId:uint=0;
	public var m_NewId2:uint=0;
	public var m_NewIdServerKey:int=-1;
	public var m_NewIdClearCnt:int = -1;
	
	public var m_RecvInfo:Boolean = false;

	public function SpaceCotl(sp:Space, hs:HyperspaceBase):void
	{
		super(sp, hs);
	}
	
	public function Clear():void
	{
		m_EntityType = 0;
		m_Id = 0;

		m_CotlType=0;
		m_CotlFlag=0;
		m_CotlSize=0;
		m_AccountId=0;
		m_UnionId=0;

		m_RestartTime=0;
		m_TimeData = 0;
		m_RewardExp = 0;

		m_ServerAdr=0;
		m_ServerPort=0;
		m_ServerNum=0;
		m_ServerMode=0;

		m_BonusType0=0;
		m_BonusVal0=0;
		m_BonusType1=0;
		m_BonusVal1=0;
		m_BonusType2=0;
		m_BonusVal2=0;
		m_BonusType3=0;
		m_BonusVal3=0;
		m_PriceEnterType=0;
		m_PriceEnter=0;
		m_PriceCaptureType=0;
		m_PriceCapture=0;
		m_PriceCaptureEgm = 0;

		m_ProtectTime = 0;
	
		m_ExitTime = 0;
		m_PlanetShieldHour = 0;
		m_PlanetShieldEnd = 0;
		m_PlanetShieldCooldown = 0;

		m_DefCnt = 0;
		m_DefScoreAll = 0;
		m_DefOwner0 = 0;
		m_DefScore0 = 0;
		m_DefOwner1 = 0;
		m_DefScore1 = 0;
		m_DefOwner2 = 0;
		m_DefScore2 = 0;

		m_AtkCnt = 0;
		m_AtkScoreAll = 0;
		m_AtkOwner0 = 0;
		m_AtkScore0 = 0;
		m_AtkOwner1 = 0;
		m_AtkScore1 = 0;
		m_AtkOwner2 = 0;
		m_AtkScore2 = 0;
		
		m_Dev0 = 0;
		m_Dev1 = 0;
		m_Dev2 = 0;
		m_Dev3 = 0;
		m_DevAccess = 0;
		m_DevFlag = 0;
		m_DevTime = 0;
	}
	
	public function CopyFrom(s:SpaceCotl):void
	{
		m_EntityType = s.m_EntityType;
		m_Id = s.m_Id;

		m_CotlType=s.m_CotlType;
		m_CotlFlag=s.m_CotlFlag;
		m_CotlSize=s.m_CotlSize;
		m_AccountId=s.m_AccountId;
		m_UnionId=s.m_UnionId;

		m_RestartTime=s.m_RestartTime;
		m_TimeData = s.m_TimeData;
		m_RewardExp = s.m_RewardExp;

		m_ServerAdr=s.m_ServerAdr;
		m_ServerPort=s.m_ServerPort;
		m_ServerNum=s.m_ServerNum;
		m_ServerMode=s.m_ServerMode;

		m_BonusType0=s.m_BonusType0;
		m_BonusVal0=s.m_BonusVal0;
		m_BonusType1=s.m_BonusType1;
		m_BonusVal1=s.m_BonusVal1;
		m_BonusType2=s.m_BonusType2;
		m_BonusVal2=s.m_BonusVal2;
		m_BonusType3=s.m_BonusType3;
		m_BonusVal3=s.m_BonusVal3;
		m_PriceEnterType=s.m_PriceEnterType;
		m_PriceEnter=s.m_PriceEnter;
		m_PriceCaptureType=s.m_PriceCaptureType;
		m_PriceCapture=s.m_PriceCapture;
		m_PriceCaptureEgm = s.m_PriceCaptureEgm;

		m_ProtectTime = s.m_ProtectTime;
	
		m_ExitTime = s.m_ExitTime;
		m_PlanetShieldHour = s.m_PlanetShieldHour;
		m_PlanetShieldEnd = s.m_PlanetShieldEnd;
		m_PlanetShieldCooldown = s.m_PlanetShieldCooldown;

		m_DefCnt = s.m_DefCnt;
		m_DefScoreAll = s.m_DefScoreAll;
		m_DefOwner0 = s.m_DefOwner0;
		m_DefScore0 = s.m_DefScore0;
		m_DefOwner1 = s.m_DefOwner1;
		m_DefScore1 = s.m_DefScore1;
		m_DefOwner2 = s.m_DefOwner2;
		m_DefScore2 = s.m_DefScore2;

		m_AtkCnt = s.m_AtkCnt;
		m_AtkScoreAll = s.m_AtkScoreAll;
		m_AtkOwner0 = s.m_AtkOwner0;
		m_AtkScore0 = s.m_AtkScore0;
		m_AtkOwner1 = s.m_AtkOwner1;
		m_AtkScore1 = s.m_AtkScore1;
		m_AtkOwner2 = s.m_AtkOwner2;
		m_AtkScore2 = s.m_AtkScore2;

		m_Dev0 = s.m_Dev0;
		m_Dev1 = s.m_Dev1;
		m_Dev2 = s.m_Dev2;
		m_Dev3 = s.m_Dev3;
		m_DevAccess = s.m_DevAccess;
		m_DevFlag = s.m_DevFlag;
		m_DevTime = s.m_DevTime;
	}
}

}