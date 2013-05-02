package Engine
{
	
public class SpaceShuttle extends SpaceShip
{
	public var m_FleetId:uint = 0;
	
	public function SpaceShuttle(sp:Space, hs:HyperspaceBase):void
	{
		super(sp, hs);
		
		m_SpeedReal = 2500.0 * 0.1 * 0.01;
		m_SpeedRotate = 120.0 * 0.01 * Space.ToRad;
	}
}

}