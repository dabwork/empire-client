// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
	import Base.BaseMath;

public class SpaceContainer extends SpaceEntity
{
    static public const FlagDestroy:uint = 1;
    static public const FlagNoMove:uint = 2;
    static public const FlagAsteroid:uint = 4;

	public var m_ItemType:uint = 0;
	public var m_ItemCnt:uint = 0;
	public var m_Owner:uint = 0;
	public var m_Broken:int = 0;
	public var m_Time:uint = 0;
	public var m_SpeedX:Number = 0;
	public var m_SpeedY:Number = 0;
	public var m_PlanetId:uint = 0;

	public var m_ServerZoneX:int = 0;
	public var m_ServerZoneY:int = 0;
	public var m_ServerPosX:Number = 0;
	public var m_ServerPosY:Number = 0;
	public var m_ServerPosZ:Number = 0;
	public var m_ServerSpeedX:Number = 0;
	public var m_ServerSpeedY:Number = 0;
	
	public var m_Flag:uint = 0;

    public var m_DropNextContainerId:uint = 0;
    public var m_DropEntityId:uint = 0;
    public var m_DropEntityType:uint = 0;
	
	static public const TakeDist:Number = 10000.0;
	
	static public const TakeMax:uint = 8;
	public var m_Take:Vector.<uint> = null; // 0-type 1-id 2-next

	public var m_Vis:Boolean = false;

	public function SpaceContainer(sp:Space, hs:HyperspaceBase):void
	{
		super(sp, hs);
	}

	public function TakePrepare():void
	{
		if (m_Take != null) return;
		var i:int;
		m_Take = new Vector.<uint>(TakeMax * 3);
		for (i = 0; i < TakeMax * 3; i++) m_Take[i] = 0;
	}

	public function ProcessMove(cnttakt:Number):void
	{
		var dx:Number, dy:Number, dz:Number, d:Number, k:Number;

		if (m_Flag & FlagNoMove) return;
//		return;
		
		var t:Number = Math.floor(HS.m_ServerTime / 1000) - m_Time;
		var mass:Number = BaseMath.C2Rn(t, 0.0, 500.0, 30.0, 150.0);
		var maxs:Number = BaseMath.C2Rn(t, 0.0, 100.0, 0.4, 0.2);
		//var maxs:Number = 0.2 * cnttakt;
		d = m_SpeedX * m_SpeedX + m_SpeedY * m_SpeedY;
		if (d > maxs * maxs) {
			k = maxs / Math.sqrt(d);
			m_SpeedX *= k;
			m_SpeedY *= k;
		}

		k = 1.0 - 0.0003;
		for (var i:int = Space.TaktStep; i < cnttakt; i += Space.TaktStep) k *= 1.0 - 0.0003;
		m_SpeedX *= k;
		m_SpeedY *= k;

		m_PosX += m_SpeedX * cnttakt;
		m_PosY += m_SpeedY * cnttakt;
		
		var planet:SpacePlanet = SP.FindNearPlanet(m_ZoneX, m_ZoneY, m_PosX, m_PosY);
		if (planet) {
			dx = (planet.m_PosX - m_PosX) + (planet.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
			dy = (planet.m_PosY - m_PosY) + (planet.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
			dz = planet.m_PosZ - m_PosZ;

			d = dx * dx + dy * dy;
//if(d > 1000 * 1000) {
//	trace(d);
//}
//			if ((m_Flag & SpaceContainer.FlagDestroy) && (d + dz * dz) < (planet.m_Radius * planet.m_Radius)) {
//				m_Flag |= SpaceContainer.FlagDestroy;
//				m_ChangeState = true;
//			}

			if (d > 0.1) {
				k = (mass * cnttakt) / (Math.sqrt(d) * d);
				m_SpeedX += dx * k;
				m_SpeedY += dy * k;
			}
		}
		
		if (m_PlanetId && (planet == null || planet.m_Id != m_PlanetId)) {
			planet = SP.EntityFind(SpaceEntity.TypePlanet, m_PlanetId) as SpacePlanet;
			if (!planet || planet.m_EntityType != SpaceEntity.TypePlanet);
			else {
				dx = (planet.m_PosX - m_PosX) + (planet.m_ZoneX - m_ZoneX) * SP.m_ZoneSize;
				dy = (planet.m_PosY - m_PosY) + (planet.m_ZoneY - m_ZoneY) * SP.m_ZoneSize;
				dz = planet.m_PosZ - m_PosZ;

				if(d>0.1) {
					k = (mass * cnttakt) / (Math.sqrt(d) * d);
					m_SpeedX += dx * k;
					m_SpeedY += dy * k;
				}
			}
		}
//trace(m_SpeedX, m_SpeedY);

/*		if (m_CenterId == 0) return;

		var center:SpacePlanet = SP.EntityFind(SpaceEntity.TypePlanet, m_CenterId) as SpacePlanet;
		if (center == null) return;

		var a:Number = m_OrbitAngle + (HS.m_ServerTime % (m_OrbitTime * 1000)) / (m_OrbitTime * 1000) * 2.0 * Space.pi;
		var tx:Number = center.m_PosX + m_OrbitRadius * Math.sin(a) + SP.m_ZoneSize * (center.m_ZoneX - m_ZoneX);
		var ty:Number = center.m_PosY + m_OrbitRadius * Math.cos(a) + SP.m_ZoneSize * (center.m_ZoneY - m_ZoneY);
		
		m_PosX = tx;
		m_PosY = ty;*/
	}
}
	
}