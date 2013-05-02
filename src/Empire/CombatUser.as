package Empire
{
	
public class CombatUser
{
	static public const UserMax:int = 8;
	static public const LootPerUser:int = 2;

	static public const FlagUserOffer:uint = 1;
	static public const FlagUserAccess:uint = 2;
	static public const FlagUserHomeJump:uint = 4;

	public var m_Id:uint;
	public var m_Flag:uint;
	public var m_CombatRating:int;
	public var m_ChangeRating:int;
	public var m_Mass:int;

	public function CombatUser():void
	{
	}
	
	public function Clear():void
	{
		m_Id = 0;
		m_Flag = 0;
		m_CombatRating = 0;
		m_ChangeRating = 0;
		m_Mass = 0;
	}
	
	public function CopyFrom(src:CombatUser):void
	{
		m_Id = src.m_Id;
		m_Flag = src.m_Flag;
		m_CombatRating = src.m_CombatRating;
		m_ChangeRating = src.m_ChangeRating;
		m_Mass = src.m_Mass;
	}
}

}
