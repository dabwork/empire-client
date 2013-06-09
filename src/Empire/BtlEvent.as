// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

public class  BtlEvent
{
	static public const TypeExplosion:uint = 1;
	static public const TypeBlackHole:uint = 2;
	static public const TypeExplosionBig:uint = 3;

	public var m_Type:uint = 0;
	public var m_Slot:uint = 0;
	public var m_Id:uint = 0;
	public var m_Time:Number = 0;
	
	public function BtlEvent():void
	{
	}
}
	
}
