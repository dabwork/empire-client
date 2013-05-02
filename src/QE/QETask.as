package QE
{
import Empire.*;

public class QETask
{
	// CotlPlaceId=номер созвездия, или специальное место. Any cotl=(CotlHome | CotlEnclave | CotlMy | CotlOther)==0
    static public const CotlSpecialMask:uint = 0xffffff00;
    static public const CotlNeutral:uint = 1; // Нейтральные планеты
    static public const CotlPlayer:uint = 2; // Планеты игрока
    static public const CotlFriend:uint = 4; // Дружественные планеты
    static public const CotlEnemy:uint = 8; // Вражеские планеты
    static public const CotlHome:uint = 16; // В личном созвездии
    static public const CotlEnclave:uint = 32; // В созвездии с анклавом
    static public const CotlMy:uint = 64; // Относительно себя
    static public const CotlOther:uint = 128; // Относительно игрока по заданию
	static public const CotlDefault:uint = uint(CotlSpecialMask | CotlNeutral | CotlPlayer | CotlFriend | CotlEnemy);

	// UserId=номер игрока
    static public const UserSpecialMask:uint = 0xffff0000;
    static public const UserAI0:uint = 1; // компьютерный владелец
    static public const UserAI1:uint = 2; // компьютерный владелец
    static public const UserAI2:uint = 4; // компьютерный владелец
    static public const UserAI3:uint = 8; // компьютерный владелец
    static public const UserQuestAI:uint = 16; // компьютерный владелец назначенный для квеста
    static public const UserPlayer:uint = 32; // игрок
    static public const UserFriend:uint = 64; // дружеский игрок
    static public const UserEnemy:uint = 128; // вражеский игрок
    static public const UserNeutral:uint = 256; // нейтральный владелец
//    static public const UserOnline:uint = 256; // из онлайна с приблизительно равным рейтингом развития
    static public const UserEvent:uint = 512; // из сообщений с приблизительно равным рейтингом развития
    static public const UserHist:uint = 1024; // из истории созвездия с приблизительно равным рейтингом развития
    static public const UserNews:uint = 2048; // из новостей с приблизительно равным рейтингом развития
    static public const UserBattle:uint = 4096; // связано с военным контекстом
    static public const UserPeace:uint = 8192; // связано с мирным контекстом

    // PlanetType; 0-any
    static public const PlanetSmall:uint = 1; // Малая планета
    static public const PlanetLarge:uint = 2; // Обитаемая планета
    static public const PlanetTini:uint = 4; // Карликовая планета
    static public const PlanetGas:uint = 8; // Газовый гигант
    static public const PlanetSun:uint = 16; // Звезда
    static public const PlanetPulsar:uint = 32; // Пульсар
    static public const PlanetWormhole:uint = 64; // Червоточина
    static public const PlanetCrystal:uint = 128; // Кристаллический разлом
    static public const PlanetTitan:uint = 256; // Ильменитовое месторождение
    static public const PlanetSilicon:uint = 512; // Кварцитное месторождение
	static public const PlanetEmpty:uint = 1024; // Нет месторождений
	//static public const PlanetDefault:uint = PlanetSmall | PlanetLarge | PlanetTini | PlanetGas | PlanetSun | PlanetPulsar | PlanetWormhole | PlanetCrystal | PlanetTitan | PlanetSilicon | PlanetEmpty;

	static public const FlagPlanetFindMask:uint = 1 << 8; // PlanetType как FindMask. 0xffff0000-сравнение 0xfffff-маска
	static public const Flag_PlaceShip_NoEnemy:uint = 1 << 9; // Для TypePlaceShip на орбите не должно быть врага
	static public const Flag_PlaceShip_Protect:uint = 1 << 10; // Для TypePlaceShip на орбите корабли должны быть под защитой более живучих кораблей
	static public const Flag_PlaceShip_InMobil:uint = 1 << 11; // Для TypePlaceShip на орбите корабли должны быть в походном режиме
    static public const Flag_PlaceItem_InShip:uint = 1 << 9; // Для TypePlaceItem разместить на корабле
    static public const Flag_PlaceItem_InPlanet:uint = 1 << 10; // Для TypePlaceItem разместить на планете в ячейках склада
    static public const Flag_PlaceItem_InOrbit:uint = 1<<11; // Для TypePlaceItem разместить на орбите планеты
    static public const Flag_PlaceItem_InHold:uint = 1 << 12; // Для TypePlaceItem разместить в трюме
	static public const Flag_BuildItem_NoDefect:uint = 1 << 9; // Для BuildItem произвести товар когда нет брака.

	// ActionType
	static public const ActionNewHomeworld:uint = 1; // Основать столицу

    static public const TypeMask:uint = 0xff;
    static public const TypeAction:uint = 1;
    // Действие
	// Par2=ActionType
    static public const TypeDestroyShip:uint = 2;
    // Уничтожить корабли
    // Par0=CotlPlaceId
    // Par1=UserId
    // Par2=ShipType 0-any
    // Par3=PlanetType
    static public const TypeBuildShip:uint = 3;
    // Построить корабли
    // Par0=CotlPlaceId
    // Par1=ShipType 0-any
    // Par2=PlanetType
    static public const TypeCapture:uint = 4;
    // Захват планет
    // Par0=CotlPlaceId
    // Par1=UserId
    // Par2=PlanetType
	static public const TypePlaceShip:uint = 5;
	// Разместить корабли в боевом режиме на орбите планеты
    // Par0=CotlPlaceId
    // Par1=ShipType 0-any
    // Par2=PlanetType
	// Par3=нужное кол-во звеньев
	static public const TypeResearch:uint = 6;
	// Исследовать технологию империи
	// Par0-tech (1...TechCnt)
	// Par1-dir1 (1...32)
	// Par2-dir2 (1...32)
	// Par3-dir3 (1...32)
	static public const TypeConstruction:uint = 7;
	// Построить постройку
	// Par0=CotlPlaceId
	// Par1=Building
	// Par2=PlanetType
    static public const TypeTradePath:uint = 8;
	// Проложить маршрут
    // Par0=CotlPlaceId
    // Par1=x,y (low,hi word) координаты сектора
    // Par2=PlanetType
    // Par3=номер поланеты
    static public const TypeLinkage:uint = 9;
    // Прявазать корабль к планет
    // Par0=CotlPlaceId
    // Par1=ShipType 0-any
    // Par2=PlanetType
	// Par3=нужное кол-во звеньев
    static public const TypeTakeItem:uint = 10;
    // Подобрать новый итем игроком
    // Par0=CotlPlaceId
    // Par1=ShipType 0-any
    // Par2=PlanetType
    // Par3=ItemNum
    static public const TypePlaceItem:uint = 11;
    // Разместить итем
    // Par0=CotlPlaceId
    // Par1=ShipType 0-any
    // Par2=PlanetType
    // Par3=ItemNum
    static public const TypeRepair:uint = 12;
    // Отремонтировать корабль(и)
    // Par0=CotlPlaceId
    // Par1=ShipType 0-any
    // Par2=PlanetType
    static public const TypeBalance:uint = 13;
    // Баланс товара
    // Par0=CotlPlaceId
    // Par2=PlanetType
    // Par3=ItemNum
    static public const TypeBuildItem:uint = 14;
    // Произвести товар
    // Par0=CotlPlaceId
    // Par2=PlanetType
    // Par3=ItemNum
    static public const TypePortal:uint = 15;
	// Проложить маршрут
    // Par0=CotlPlaceId
    // Par1=x,y (low,hi word) координаты сектора
    // Par2=PlanetType
    // Par3=номер поланеты
	static public const TypeTalent:uint = 16;
	// Конфигурация талантов для флагмана
	// Par0-vec0
	// Par1-vec1
	// Par2-vec2
	// Par3-vec3

	public var m_Flag:uint = 0;
	public var m_Cnt:int = 0;
	public var m_Val:int = 0;
	public var m_Par0:uint = 0;
	public var m_Par1:uint = 0;
	public var m_Par2:uint = 0;
	public var m_Par3:uint = 0;
	
	public var m_Desc:String = null;
	
	public var m_Tmp:int = 0;
	
	public function QETask():void
	{
	}

	public function Clear():void
	{
		m_Flag = 0;
		m_Cnt = 0;
		m_Val = 0;
		m_Par0 = 0;
		m_Par1 = 0;
		m_Par2 = 0;
		m_Par3 = 0;
		
		m_Desc = null;
		
		m_Tmp = 0;
	}
	
	public function IsEmpty():Boolean
	{
		if (m_Flag == 0) return true;
		return false;
	}
	
	public function UserId():uint
	{
		var id:int = 0;
		if ((m_Flag & TypeMask) == TypeDestroyShip) id = m_Par1;
		else if ((m_Flag & TypeMask) == TypeCapture) id = m_Par1;

		if (id == 0) return 0;
		if ((id & UserSpecialMask) == UserSpecialMask) return 0;

		return id;
	}
	
	public function CotlPlaceId():uint
	{
		var id:uint = 0;
		if ((m_Flag & TypeMask) == TypeDestroyShip) id = m_Par0;
		else if ((m_Flag & TypeMask) == TypeBuildShip) id = m_Par0;
		else if ((m_Flag & TypeMask) == TypeCapture) id = m_Par0;
		
		return id;
	}
	
	public function CotlIdOtherUser():uint
	{
		var id:uint = CotlPlaceId();
		var tid:uint = id & CotlSpecialMask;
		if (tid != CotlSpecialMask) {
			return id;
		}
		if (!(id & CotlOther)) return 0;
		if (id & (CotlHome | CotlEnclave)) return 0;

		var userid:uint = UserId();
		if (userid == 0) return 0;
		var user:User = UserList.Self.GetUser(userid);
		if (user == null) return 0;

		if (id & CotlHome) return user.m_HomeworldCotlId;
//		else if (id & CotlEnclave) return user.m_CitadelCotlId;
		return 0;
	}
}
	
}