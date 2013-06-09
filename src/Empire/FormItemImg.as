// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import fl.containers.*;
import fl.controls.*;
import fl.controls.dataGridClasses.*;
import fl.events.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormItemImg extends FormStd
{
	private var EM:EmpireMap = null;

	public var gridItems:int = -1;
		
	private var m_IIList:Vector.<ItemImg> = new Vector.<ItemImg>();
	
	public function FormItemImg(em:EmpireMap)
	{
		EM = em;

		super(true, false);

		width = 480;
		height = 480;
		scale = StdMap.Main.m_Scale;
		caption = Common.TxtEdit.FormItemImgCpation;

		gridItems = GridAdd();
		GridSizeX(gridItems, 70, 70, 70, 70, 70, 70, 70, 70);
	}

	override public function Hide():void
	{
		super.Hide();
		ClearItemImg();
	}
	
	public function clickClose(event:MouseEvent):void
	{
		ClearItemImg();
		Hide();
	}

	override public function Show():void
	{
		super.Show();
		
		ClearItemImg();
		UpdateItem();
	}

	public function ClearItemImg():void
	{
		var i:int;
		var s:ItemImg;

		for (i = m_IIList.length - 1; i >= 0; i--) {
			ItemImgDelete(i);
		}
	}
	
	public function ItemImgDelete(i:int):void
	{
		if (i<0 || i>=m_IIList.length) return;

		var s:ItemImg = m_IIList[i];

		s.m_IIcon = null;
		if (s.m_IBox != null) { ItemDelete(ItemByObj(s.m_IBox)); s.m_IBox = null; }

		m_IIList.splice(i, 1);
	}

	public function UpdateItem():void
	{
		var i:int, u:int, n:int;
		var ss:ItemImg;
		var ino:int;

		var col:int = 0;
		var row:int = 0;

		Loc( -1, -1, gridItems, 0, 0, 1, 1);

		for (i = -1; i < Common.ItemImgArray.length; i++) {
			//if (i != 0 && Common.ItemImgArray[i] == undefined) continue;
			if (i >= 0) ino = Common.ItemImgArray[i].No;
			else ino = 0;

			for (u = 0; u < m_IIList.length; u++) {
				ss = m_IIList[u];
				if (ss.m_No == ino) break;
			}
			if (u >= m_IIList.length) {
				ss = new ItemImg();
				ss.m_No = ino;
				m_IIList.push(ss);
			}

			if (ss.m_IBox == null) {
				ss.m_IBox = ItemObj(ItemBox()) as CtrlBox;
				ss.m_IBox.heightMin = 50;
				ss.m_IBox.widthMin = 50;
				ss.m_IBox.addEventListener(Event.CHANGE, SelectChange);
				ss.m_IBox.doubleClickEnabled = true;
			}
			n = ItemByObj(ss.m_IBox); ItemCell(n, col, row); ItemSpace(n, 2, 2, 2, 2); ItemCellCnt(n, 1, 1);
			ss.m_IBox.visible = true;

			if (ss.m_IIcon == null) {
				ss.m_IIcon = Common.ItemImg(ss.m_No, false);
				if (ss.m_IIcon != null) {
					ss.m_IBox.addChild(ss.m_IIcon);
//					ss.m_IIcon.mouseEnabled = false;
					ss.m_IIcon.x = 50 >> 1;
					ss.m_IIcon.y = 50 >> 1;
				}
			}

			col++;
			if (col >= 5) { col = 0; row++; }
		}

		SelectChange();

		ContentBuild();
	}
		
	private function SelectChange(e:Event = null):void
	{
		var i:int;
		var ss:ItemImg;

		if(e!=null)
		for (i = 0; i < m_IIList.length; i++) {
			ss = m_IIList[i];
			if (!ss.m_IBox) continue;
			if (ss.m_IBox == e.target) {
				clickChange(ss.m_No);
				continue;
			}
			ss.m_IBox.select = false;
		}
	}

	public function ChangeCur(no:int):void
	{
		var i:int;
		var ss:ItemImg;

		for (i = 0; i < m_IIList.length; i++) {
			ss = m_IIList[i];
			if (!ss.m_IBox) continue;

			ss.m_IBox.select = no == ss.m_No;
		}
	}

	public function clickChange(no:int):void
	{
		var it:Item = UserList.Self.GetItem(EM.m_FormItemManager.SearchCurItemType());
		if (it == null) return;

		var boundary:String = Server.Self.CreateBoundary();

		var d:String = "";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"img\"\r\n\r\n";
		d += no.toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"itemid\"\r\n\r\n";
		d += it.m_Id.toString() + "\r\n";

		d += "--" + boundary + "--\r\n";

		Server.Self.QueryPost("emitemop", "&op=3", d, boundary, OpAnswer, false);
	}

	public function OpAnswer(e:Event):void
	{
		var loader:URLLoader = URLLoader(e.target);
		
		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;
		
		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;
	}
}

}

import Engine.*;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.*;

class ItemImg
{
	public var m_No:uint = 0;

	public var m_IIcon:DisplayObject;
	public var m_IBox:CtrlBox;
}
