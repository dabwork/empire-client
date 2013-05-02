// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import flash.display.*;
import flash.geom.*;
import flash.system.*;
import flash.utils.*;
		
public class Quest
{
	public var m_Id:uint = 0;
	public var m_Anm:uint = 0;
	public var m_Owner:uint = 0;
	public var m_TaskFlag:uint = 0;
	public var m_TaskPar0:uint = 0;
	public var m_TaskPar4:uint = 0;
	public var m_RewardExp:int = 0;
	public var m_Name:String = null;
	public var m_Txt:String = null;

	public var m_LoadDate:Number = 0;
	public var m_GetTime:Number = 0;
	public var m_LoadAfterAnm:uint = 0;
	public var m_LoadAfterAnm_Time:Number = 0;

	public function Quest()
	{
	}
}

}
