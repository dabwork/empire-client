// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;

public class FormFleetItem extends Sprite
{
	static public const ItemSlotSize:int = 44;
	static public const SizeX:int = 5 + ItemSlotSize * 8 + 5;
	static public const OffX:int = 0;
	static public const OffY:int = 0;
	public var m_SizeY:int = 0;

	private var m_Map:EmpireMap;
	
	public var m_SlotLayer:Sprite=new Sprite();
	public var m_ItemLayer:Sprite=new Sprite();
	public var m_TxtLayer:Sprite=new Sprite();

	public var m_FleetItem:Array = new Array();

	public var m_ItemRowCnt:int = 0;

	public var m_ItemMouse:int = -1;
	public var m_ItemPrepare:int = -1;

	public var m_ShowTransportRow:Boolean = true;

	public function FormFleetItem(map:EmpireMap)
	{
		var i:int;
		m_Map = map;

		for (i = 0; i < Common.FleetItemCnt; i++) m_FleetItem.push(new FleetItem());
		
		addChild(m_SlotLayer);
		addChild(m_ItemLayer);
		addChild(m_TxtLayer);

		m_SlotLayer.mouseChildren=false;
		m_ItemLayer.mouseChildren=false;
		m_TxtLayer.mouseChildren=false;
		
		m_SlotLayer.mouseEnabled=false;
		m_ItemLayer.mouseEnabled=false;
		m_TxtLayer.mouseEnabled=false;

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
		m_Map.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler,false,1);
	}

	public function Clear():void
	{
	}

	public function ClearForNewConn():void
	{
	}

	public function StageResize():void
	{
		if (!visible) return;
		//&& EmpireMap.Self.IsResize()) Update();
		Update();
	}

	public function Show():void
	{
		m_Map.FloatTop(this);
		visible=true;
		Update();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function IsMouseIn():Boolean
	{
		if (!visible) return false;
		
		return mouseX>=0 && mouseX<SizeX && mouseY>=0 && mouseY<m_SizeY;
	}
	
	public function IsMouseInTop():Boolean
	{
		if (!IsMouseIn()) return false;

		var pt:Point = new Point(stage.mouseX, stage.mouseY);
		var ar:Array = stage.getObjectsUnderPoint(pt);

		if (ar.length <= 0) return false;

		var obj:DisplayObject = ar[ar.length - 1];
		if (obj == m_Map.m_MoveItem) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		else if (obj == m_Map.m_FormFleetBar.m_MoveLayer) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		while (obj!=null) {
			if (obj == this) return true;
			obj = obj.parent;
		}
		return false;
	}

	public function Update():void
	{
		var i:int, px:int, py:int, row:int, col:int;
		var fi:FleetItem;
		
		if (!visible) return;
		
		if (Common.FleetItemCnt != 8 * 8) throw Error("");
		
		//var transport:Boolean = ((m_Map.m_FormFleetBar.m_Formation & 7) == 3) || ((m_Map.m_FormFleetBar.m_Formation & 7) == 4);
		var transport:Boolean = (m_Map.m_FormFleetBar.m_HoldLvl & 0xf0) != 0;
		var rowcnt:int = Common.FleetHoldRowByLvl[m_Map.m_FormFleetBar.m_HoldLvl & 0x0f];
		m_ShowTransportRow = transport;

		m_ItemRowCnt = 0;

//		for (i = 0; i < Common.FleetItemCnt; i++) {
		for (row = 0; row < 8; row++) {
			var rowok:Boolean = false;
			var rowhiden:Boolean = false;

			if (row == 0 && transport) rowok = true;
			if (row >= 1 && row < rowcnt) rowok = true;
			if(!rowok) {
				for (col = 0; col < 8; col++) {
					i = row * 8 + col;
					fi = m_FleetItem[i];
					if (fi.m_Type!=0) { rowok = true; rowhiden = true; break; }
				}
			}
			if (row == 0 && !transport && rowok) m_ShowTransportRow = true;

			for (col = 0; col < 8; col++) {
				i = row * 8 + col;
				fi = m_FleetItem[i];
				
				px = OffX + col * ItemSlotSize;
				py = OffY + m_ItemRowCnt * ItemSlotSize;

				if(fi.m_SlotH==null) {
					fi.m_SlotH=new MBSlotN();
					m_SlotLayer.addChild(fi.m_SlotH);
					fi.m_SlotH.width=ItemSlotSize;
					fi.m_SlotH.height=ItemSlotSize;
				}
				if(fi.m_SlotN==null) {
					fi.m_SlotN=new MBSlotG();
					m_SlotLayer.addChild(fi.m_SlotN);
					fi.m_SlotN.width=ItemSlotSize;
					fi.m_SlotN.height=ItemSlotSize;
				}
				if(fi.m_SlotC==null) {
					fi.m_SlotC=new MBSlotC();
					m_SlotLayer.addChild(fi.m_SlotC);
					fi.m_SlotC.width=ItemSlotSize;
					fi.m_SlotC.height=ItemSlotSize;
				}
				if(fi.m_SlotA==null) {
					fi.m_SlotA=new MBSlotA();
					m_SlotLayer.addChild(fi.m_SlotA);
					fi.m_SlotA.width=ItemSlotSize;
					fi.m_SlotA.height=ItemSlotSize;
				}
				
				fi.m_SlotH.x=px;
				fi.m_SlotH.y=py;
				fi.m_SlotN.x=px;
				fi.m_SlotN.y=py;
				fi.m_SlotC.x=px;
				fi.m_SlotC.y=py;
				fi.m_SlotA.x=px;
				fi.m_SlotA.y=py;

				if (rowok && rowhiden && (fi.m_Type == 0)) {
					fi.m_SlotA.visible = false;
					fi.m_SlotH.visible = true;
					fi.m_SlotC.visible = false;
					fi.m_SlotN.visible = false;
					fi.m_ShowRow = -1;

				} else if (rowok && rowhiden) {
					fi.m_SlotA.visible = (i == m_ItemMouse) || (m_Map.m_MoveItem.visible && m_Map.m_MoveItem.m_ToType == 2 && m_Map.m_MoveItem.m_ToSlot == i) || (m_Map.m_MoveItem.visible && m_Map.m_MoveItem.m_FromType == 2 && m_Map.m_MoveItem.m_FromSlot == i) || (m_Map.m_FormFleetBar.m_SlotMove>=0 && m_Map.m_FormFleetBar.m_SlotMoveBegin && m_Map.m_MoveItem.m_ToType == 2 && m_Map.m_MoveItem.m_ToSlot == i);
					fi.m_SlotN.visible = (row != 0) && (!fi.m_SlotA.visible);
					fi.m_SlotC.visible = (row == 0) && (!fi.m_SlotA.visible);
					fi.m_SlotH.visible = false;
					fi.m_ShowRow = m_ItemRowCnt;

				} else if (rowok) {
					fi.m_SlotA.visible = (i == m_ItemMouse) || (m_Map.m_MoveItem.visible && m_Map.m_MoveItem.m_ToType == 2 && m_Map.m_MoveItem.m_ToSlot == i) || (m_Map.m_MoveItem.visible && m_Map.m_MoveItem.m_FromType == 2 && m_Map.m_MoveItem.m_FromSlot == i) || (m_Map.m_FormFleetBar.m_SlotMove>=0 && m_Map.m_FormFleetBar.m_SlotMoveBegin && m_Map.m_MoveItem.m_ToType == 2 && m_Map.m_MoveItem.m_ToSlot == i);
					fi.m_SlotN.visible = (row != 0) && (!fi.m_SlotA.visible);
					fi.m_SlotC.visible = (row == 0) && (!fi.m_SlotA.visible);
					fi.m_SlotH.visible = false;
					fi.m_ShowRow = m_ItemRowCnt;

				} else {
					fi.m_SlotA.visible = false;
					fi.m_SlotN.visible = false;
					fi.m_SlotC.visible = false;
					fi.m_SlotH.visible = false;
					fi.m_ShowRow = -1;
				}

				if(fi.m_Txt==null) {
					fi.m_Txt=new TextField();
					m_TxtLayer.addChild(fi.m_Txt);
					fi.m_Txt.x = px + i * ItemSlotSize + 1;
					fi.m_Txt.y = py + ItemSlotSize-17;
					fi.m_Txt.width = ItemSlotSize-2;
					fi.m_Txt.height=17;
					fi.m_Txt.type=TextFieldType.DYNAMIC;
					fi.m_Txt.selectable=false;
					fi.m_Txt.border=false;
					fi.m_Txt.background=true;
					fi.m_Txt.backgroundColor=0x000000;
					fi.m_Txt.multiline=false;
					fi.m_Txt.autoSize=TextFieldAutoSize.NONE;
					fi.m_Txt.antiAliasType=AntiAliasType.ADVANCED;
					fi.m_Txt.gridFitType=GridFitType.PIXEL;
					fi.m_Txt.defaultTextFormat=new TextFormat("Calibri",11,0xffffff);
					fi.m_Txt.embedFonts=true;
					fi.m_Txt.alpha=0.8;
				}
				
				var item:Item = null;
				if (fi.m_Type!=0) item = UserList.Self.GetItem(fi.m_Type & 0xffff);
				
				if (!rowok || item==null || item.m_Img != fi.m_ImgNo) {
					if (fi.m_Img != null) {
						m_ItemLayer.removeChild(fi.m_Img);
						fi.m_Img = null;
					}
					fi.m_ImgNo = 0;
				}
				
				if (rowok && fi.m_Type != 0 && (fi.m_Img == null) && item!=null) {
					fi.m_ImgNo = item.m_Img;
					fi.m_Img = Common.ItemImg(fi.m_ImgNo);
					if (fi.m_Img != null) {
						m_ItemLayer.addChild(fi.m_Img);
					}
				}
				
				if (fi.m_Img != null) {
					fi.m_Img.x = px + (ItemSlotSize >> 1);
					fi.m_Img.y = py + (ItemSlotSize >> 1);
				}

				if(rowok && fi.m_Type != 0) {
					fi.m_Txt.height = 17;
					fi.m_Txt.x = px + 1;
					fi.m_Txt.y = py + ItemSlotSize-fi.m_Txt.height;
					if (fi.m_Cnt >= 500000) fi.m_Txt.text = BaseStr.FormatBigInt(Math.floor(fi.m_Cnt/1000))/*+"."+Math.floor((fi.m_Cnt%1000)/100).toString()*/+"k";
					else fi.m_Txt.text = BaseStr.FormatBigInt(fi.m_Cnt);
					fi.m_Txt.visible = true;
				} else {
					fi.m_Txt.visible = false;
				}
			}
			
			if (rowok) m_ItemRowCnt++;
		}
		
		m_SizeY = m_ItemRowCnt * ItemSlotSize;
		
		x = m_Map.m_FormFleetBar.x + m_Map.m_FormFleetBar.m_SizeX -SizeX + 10;
		y = m_Map.m_FormFleetBar.y - m_SizeY - 5;
	}

	public function GetItemSlotX(slot:int):int
	{
		if (slot<0 || slot>=m_FleetItem.length) return 0;
		var fi:FleetItem = m_FleetItem[slot];
		
		return x + fi.m_SlotN.x + (ItemSlotSize >> 1);
	}

	public function GetItemSlotY(slot:int):int
	{
		if (slot<0 || slot>=m_FleetItem.length) return 0;
		var fi:FleetItem = m_FleetItem[slot];
		
		return y + fi.m_SlotN.y + (ItemSlotSize >> 1);
	}

	public function PickItem():int
	{
		if (!visible) return -1;

		var x:int = Math.floor((mouseX - OffX) / ItemSlotSize);
		var y:int = Math.floor((mouseY - OffY) / ItemSlotSize);
		if (x<0 || x>=8) return -1;		
		if (y<0 || y>=m_ItemRowCnt) return -1;
		
		var row:int;
		
		for (row = 0; row < 8; row++) {
			var fi:FleetItem = m_FleetItem[x + row * 8];
			if (fi.m_ShowRow == y) return x + row * 8;
		}
		
		return -1;
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		var i:int;
		
		m_Map.FloatTop(this);
		e.stopImmediatePropagation();

		if(FormMessageBox.Self.visible) return;
		if (m_Map.m_FormInput.visible) return;

		m_Map.m_FormMenu.Clear();

		i = PickItem();
		if (i != m_ItemMouse) {
			m_ItemMouse = i;
			Update();
		}

		m_ItemPrepare = -1;
		if (m_ItemMouse >= 0) {
			m_ItemPrepare = m_ItemMouse;
		}
	}
	
	public function onMouseUp(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		if(FormMessageBox.Self.visible) return;
		if (m_Map.m_FormInput.visible) return;
		
		if (m_ItemPrepare >= 0 && m_ItemMouse==m_ItemPrepare) {
			MenuItem();
		}

		m_ItemPrepare = -1;
	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var i:int;

		if (FormMessageBox.Self.visible) return;
		if (m_Map.m_FormInput.visible) return;

		var hideinfo:Boolean = true;

		i = PickItem();
		if (i != m_ItemMouse) {
			if (m_ItemPrepare >= 0) {
				m_Map.m_Info.Hide();
				m_Map.m_MoveItem.Begin(2, m_ItemPrepare);
				m_ItemPrepare = -1;
				m_ItemMouse = -1;
				Update();
				return;
			}
			
			m_ItemMouse = i;
			Update();
		}

		if (hideinfo && m_ItemMouse >= 0) {
			var fi:FleetItem = m_FleetItem[m_ItemMouse];
			if(fi.m_Type!=0) {
				m_Map.m_Info.ShowItemEx(fi, fi.m_Type, fi.m_Cnt, 0, 0, fi.m_Broken, GetItemSlotX(m_ItemMouse) - (ItemSlotSize >> 1), GetItemSlotY(m_ItemMouse) - (ItemSlotSize >> 1), ItemSlotSize, ItemSlotSize);
				hideinfo = false;
			}
		}

		if(hideinfo) m_Map.m_Info.Hide();
	}

	protected function onMouseOutHandler(e:MouseEvent):void
	{
		if(FormMessageBox.Self.visible) return;
		if (m_Map.m_FormInput.visible) return;
		if (m_Map.m_FormMenu.visible) return;
		
		if (-1 != m_ItemMouse && m_ItemPrepare >= 0) {
			m_Map.m_Info.Hide();
			m_Map.m_MoveItem.Begin(2, m_ItemPrepare);
			m_ItemPrepare = -1;
			m_ItemMouse = -1;
			Update();
			return;
		}
		
		m_ItemPrepare = -1;

		if(m_ItemMouse!=-1) {
			m_ItemMouse = -1;
			Update();
		}
	}
	
	public function onKeyDownHandler(e:KeyboardEvent):void
	{
		while (e.keyCode == 32 && IsMouseInTop()) { // space
			e.stopImmediatePropagation();
			if (m_ItemMouse < 0) break;

			var fi:FleetItem = m_FleetItem[m_ItemMouse];
			if (fi.m_Type == 0) break;

			if (!m_Map.m_FormPlanet.visible) break;

			var ac:Action = new Action(m_Map);
			ac.ActionItemMove(m_Map.m_FormPlanet.m_SectorX, m_Map.m_FormPlanet.m_SectorY, m_Map.m_FormPlanet.m_PlanetNum, 2, m_ItemMouse, 1, -1, 0);
			m_Map.m_LogicAction.push(ac);

			break;
		}
	}

	public function MenuItem():void
	{
		var obj:Object;
		var slot:int = m_ItemMouse;
		
		m_Map.m_Info.Hide();

		m_Map.m_FormMenu.Clear();

		var fi:FleetItem = m_FleetItem[slot];
		if (fi.m_Type == 0) return;

		if((fi.m_Type & 0xffff)==Common.ItemTypeTechnician || (fi.m_Type & 0xffff)==Common.ItemTypeNavigator) {
			obj = m_Map.m_FormMenu.Add(Common.Txt.FormFleetItemUse);
			if (fi.m_Cnt <= 0) obj.Disable = true;
			else obj.Fun = MsgItemUse;
		}
		
		m_Map.m_FormMenu.Add(Common.Txt.FormFleetItemDestroy,MsgItemDestroy);

		var tx:int = GetItemSlotX(slot) - (ItemSlotSize >> 1);
		var ty:int = GetItemSlotY(slot) - (ItemSlotSize >> 1);
		m_Map.m_FormMenu.SetCaptureMouseMove(true);
		m_Map.m_FormMenu.Show(tx, ty, tx + ItemSlotSize, ty + ItemSlotSize);
	}

	public function MsgItemUse(...args):void
	{
		var ac:Action = new Action(m_Map);
		ac.ActionFleetSpecial(9,m_ItemMouse);
		m_Map.m_LogicAction.push(ac);
	}
	
	public function MsgItemDestroy(...args):void
	{
		FormMessageBox.Run(Common.Txt.FormFleetItemDestroyQuery, null, null, ActionItemDestroy);
	}
	
	public function ActionItemDestroy():void
	{
		if (!EmpireMap.Self.m_FormFleetBar.FleetSysItemDestroy(m_ItemMouse)) return;

		Update();

		Server.Self.m_Anm += 256;
		Server.Self.QuerySS("emfleetspecial", "&type=13&islot=" + m_ItemMouse.toString() + "&fanm=" + Server.Self.m_Anm.toString(), EmpireMap.Self.m_FormFleetBar.AnswerSpecial, false);
		EmpireMap.Self.m_FormFleetBar.m_RecvFleetAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_FormFleetBar.m_RecvFleetAfterAnm_Time = EmpireMap.Self.m_CurTime;
	}
}

}
