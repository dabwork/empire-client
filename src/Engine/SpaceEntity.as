package Engine
{

public class SpaceEntity
{
	static public const TypeFleet:uint = 1;
	static public const TypeCotl:uint = 2;
	static public const TypePlanet:uint = 3;
	static public const TypeShuttle:uint = 4;
	static public const TypeContainer:uint = 5;
	static public const TypeBullet:uint = 256;

	public var HS:HyperspaceBase = null;
	public var SP:Space = null;
	
	public var m_ZoneX:Number = 0;
	public var m_ZoneY:Number = 0;
	public var m_PosX:Number = 0;
	public var m_PosY:Number = 0;
	public var m_PosZ:Number = 0;

	public var m_Anm:uint = 0;
	public var m_EntityType:uint = 0;
	public var m_Id:uint = 0;

	public var m_VerOrder:uint = 0;
	public var m_VerState:uint = 0;
	public var m_VerSet:uint = 0;
	
	public var m_RecvFull:Boolean = false;

	public var m_Tmp:uint = 0;
	
	public var m_LoadAfterAnm:uint = 0;
	public var m_LoadAfterAnm_Timer:Number = 0;
	
	public function SpaceEntity(sp:Space, hs:HyperspaceBase):void
	{
		SP = sp;
		HS = hs;
	}
	
	public function IsShip():Boolean { return m_EntityType == TypeFleet || m_EntityType == TypeShuttle; }
	
	public function Dist2(ent:SpaceEntity):Number
	{
        var dx:Number = ent.m_PosX - m_PosX + (ent.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
        var dy:Number = ent.m_PosY - m_PosY + (ent.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
        return dx * dx + dy * dy;
	}
}

}
