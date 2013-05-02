package Empire
{
	
public class Item
{
	static public const BonusCnt:int = 16;
	
	static public const stNone:int=0;
	static public const stBlue:int=1;
	static public const stGreen:int=2;
	static public const stRed:int=3;
	static public const stYellow:int=4;
	
	static public const btArmour:int=1;
	static public const btPower:int=2;
	static public const btRepair:int=3;
	static public const btArmourAll:int=4;
	static public const btMinePower:int=5;

	public var m_Id:uint=0;
	public var m_SlotType:int=0;
	public var m_Lvl:int=0;
	public var m_StackMax:int=0;
	public var m_Img:uint = 0;
	public var m_Step:int=0;
	public var m_OwnerId:uint=0;

	public var m_BonusType:Vector.<uint> = new Vector.<uint>(BonusCnt, true);
	public var m_BonusVal:Vector.<int> = new Vector.<int>(BonusCnt, true);
	public var m_BonusDif:Vector.<int> = new Vector.<int>(BonusCnt, true);

	public var m_LoadDate:Number=0;
	public var m_GetTime:Number=0;

	public function Item()
	{
		var i:int;
		for(i=0;i<BonusCnt;i++) {
			m_BonusType[i]=0;
			m_BonusVal[i]=0;
		}
	}
}

}
