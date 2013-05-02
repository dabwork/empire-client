package Engine
{
	
public class SpaceFleet extends SpaceShip
{
	public var m_Fuel:int = 0;

	public var m_ShuttleId:uint = 0;
	
	public function SpaceFleet(sp:Space, hs:HyperspaceBase):void
	{
		super(sp, hs);
	}
}

}