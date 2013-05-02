// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{

public class SpacePlanet extends SpaceEntity
{
	static public const DefaultZ:Number = -400.0;

    static public const FlagTypeMask:uint = 0xf;
    static public const FlagTypeCenter:uint = 1;
    static public const FlagTypeSun:uint = 2;
    static public const FlagTypePlanet:uint = 3;
    static public const FlagTypeSputnik:uint = 4;

	public var m_PlanetFlag:uint = 0;
	public var m_Style:uint = 0;
	public var m_CenterId:uint = 0;
	public var m_OrbitAngle:Number = 0.0;
	public var m_OrbitRadius:Number = 0.0;
	public var m_OrbitTime:Number = 0;
	public var m_Radius:Number = 0;
	public var m_CotlId:uint = 0;
	public var m_PlanetNum:int = -1;

	public var m_ServerZoneX:int = 0;
	public var m_ServerZoneY:int = 0;
	public var m_ServerPosX:Number = 0;
	public var m_ServerPosY:Number = 0;
	public var m_ServerPosZ:Number = 0;

	public function SpacePlanet(sp:Space, hs:HyperspaceBase):void
	{
		super(sp, hs);
	}

	public function ProcessMove(cnttakt:Number):void
	{
		if (m_CenterId == 0) return;

		var center:SpacePlanet = SP.EntityFind(SpaceEntity.TypePlanet, m_CenterId) as SpacePlanet;
		if (center == null) return;

		var a:Number = m_OrbitAngle + (HS.m_ServerTime % (m_OrbitTime * 1000)) / (m_OrbitTime * 1000) * 2.0 * Space.pi;
		var tx:Number = center.m_PosX + m_OrbitRadius * Math.sin(a) + SP.m_ZoneSize * (center.m_ZoneX - m_ZoneX);
		var ty:Number = center.m_PosY + m_OrbitRadius * Math.cos(a) + SP.m_ZoneSize * (center.m_ZoneY - m_ZoneY);

		m_PosX = tx;
		m_PosY = ty;
//if(m_Id==12) trace((EmpireMap.Self.m_CurTime).toString() + "\t" + m_PosX.toString() + "\t" + m_PosY.toString() + "\t" + tx.toString() + "\t" + ty.toString() + "\t" + (0).toString() + "\t" + (0).toString() + "\t" + a.toString() + "\t" + m_OrbitRadius.toString());
	}
}
	
}