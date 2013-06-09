// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import flash.display.*;
import flash.text.TextField;

public class FleetItem
{
	public var m_Type:uint=0;
	public var m_Cnt:int=0;
	public var m_Broken:int=0;

	public var m_SlotH:Sprite = null;
	public var m_SlotN:Sprite = null;
	public var m_SlotC:Sprite = null;
	public var m_SlotA:Sprite = null;
	public var m_Img:DisplayObject=null;
	public var m_Txt:TextField = null;
	public var m_ShowRow:int = -1;
	
	public var m_GraphType:int = -1;
	public var m_ImgNo:int = -1;

	public function FleetItem()
	{
	}

	public function Copy(src:FleetItem):void
	{
		m_Type=src.m_Type;
		m_Cnt = src.m_Cnt;
		m_Broken=src.m_Broken;
	}

	public function Clear():void
	{
		m_Type=0;
		m_Cnt=0;
		m_Broken=0;
	}
}

}
