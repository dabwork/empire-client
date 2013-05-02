package Engine
{

public class HyperspaceEntity
{
	public var HS:HyperspaceBase = null;
	
	public var m_ZoneX:Number = 0;
	public var m_ZoneY:Number = 0;
	public var m_PosX:Number = 0;
	public var m_PosY:Number = 0;
	public var m_PosZ:Number = 0;

	public var m_EntityType:uint = 0;
	public var m_Id:uint = 0;
	
	public function HyperspaceEntity(hs:HyperspaceBase):void
	{
		HS = hs;
	}
}
	
}