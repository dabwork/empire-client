// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{

public class HyperspaceWeapon
{
	public var m_PosX:Number = 0;
	public var m_PosY:Number = 0;
	public var m_PosZ:Number = 0;

	public var m_BarrelPosX:Number = 0;
	public var m_BarrelPosY:Number = 0;
	public var m_BarrelPosZ:Number = 0;

	public var m_BarrelDirX:Number = 0;
	public var m_BarrelDirY:Number = 0;
	public var m_BarrelDirZ:Number = 0;

	public var m_BarrelLen:Number = 0;

	public var m_Index:uint = 0;

	public var m_DeafultAngle:Number = 0;

	public var m_Type:int = 0;

	public var m_Angle:Number = 0;
	public var m_Angle2:Number = 0;
	public var m_Timer:Number = 0;
	public var m_LastId:uint = 0;

	public var m_LastFireTakt0:Number = 0;
	public var m_LastFireTakt1:Number = 0;
	public var m_LastFireTakt2:Number = 0;
	public var m_LastFireTakt3:Number = 0;

	public var m_ConnectId:uint = 0;
	public var m_Model:C3DModel = null;

	public var m_InitBarel:Boolean = false;

	public var m_AimTargetType:int = 0;
	public var m_AimTargetId:int = 0;
	public var m_AimPosX:Number = 0;
	public var m_AimPosY:Number = 0;
	public var m_AimPosZ:Number = 0;
	public var m_AimToX:Number = 0;
	public var m_AimToY:Number = 0;
	public var m_AimToZ:Number = 0;

	public var m_Bullet:HyperspaceBullet = null;
	
	public function HyperspaceWeapon():void
	{
	}
}

}
