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

public class Hangar extends Sprite
{
	static public var Self:Hangar = null;

	public var EM:EmpireMap = null;

	[Embed(source = '/assets/ship/slotCore.png')] public var bmSlotCore:Class;
	[Embed(source = '/assets/ship/slotCoreA.png')] public var bmSlotCoreA:Class;
	[Embed(source = '/assets/ship/slotCoreRed.png')] public var bmSlotCoreRed:Class;
	[Embed(source = '/assets/ship/slotCoreRedA.png')] public var bmSlotCoreRedA:Class;
	[Embed(source = '/assets/ship/slotEne.png')] public var bmSlotEne:Class;
	[Embed(source = '/assets/ship/slotEneA.png')] public var bmSlotEneA:Class;
	[Embed(source = '/assets/ship/slotEneRed.png')] public var bmSlotEneRed:Class;
	[Embed(source = '/assets/ship/slotEneRedA.png')] public var bmSlotEneRedA:Class;
	[Embed(source = '/assets/ship/slotSup.png')] public var bmSlotSup:Class;
	[Embed(source = '/assets/ship/slotSupA.png')] public var bmSlotSupA:Class;
	[Embed(source = '/assets/ship/slotZar.png')] public var bmSlotZar:Class;
	[Embed(source = '/assets/ship/slotZarA.png')] public var bmSlotZarA:Class;
	[Embed(source = '/assets/ship/slotZarRed.png')] public var bmSlotZarRed:Class;
	[Embed(source = '/assets/ship/slotZarRedA.png')] public var bmSlotZarRedA:Class;
	
	[Embed(source = '/assets/ship/need_energy.png')] public var bmNeedEnergy:Class;

	static public const TableWidth:int = 1500;
	static public const TableHeight:int = 1000;
	
	static public const HangarMax:int = 8;

	static public const stNone:int = 0;
	static public const stEnergy:int = 1;
	static public const stCharge:int = 2;
	static public const stCore:int = 3;
	static public const stSupply:int = 4;

	static public const slotRadius:Vector.<int> = new <int>[0,34+3,34+3,51+3,26+3];
	static public const slotCanConnect:Vector.<int> = new <int>[
		// Energe Charge Core Supplay
		1, 0, 1, 0, // Energe
		0, 1, 1, 0, // Charge
		1, 1, 0, 0, // Core
		0, 0, 0, 0  // Supplay
	];

	public var m_Slot:Vector.<Slot> = new Vector.<Slot>();

	public var m_CenterX:int = (TableWidth >> 1);
	public var m_CenterY:int = (TableHeight >> 1);
	
	public var m_LayerSlot:Sprite = new Sprite();
	public var m_LayerItem:Sprite = new Sprite();
	public var m_LayerIcon:Sprite = new Sprite();

	public var m_SlotMouse:int = -1;

	static public const ActionNone:int = 0;
	static public const ActionCamPrepare:int = 1;
	static public const ActionCam:int = 2;
	static public const ActionSlotPrepare:int = 3;
	static public const ActionSlotMove:int = 4;

	public var m_Action:int = 0;
	public var m_ActionOldX:int = 0;
	public var m_ActionOldY:int = 0;

	public var m_HangarCurId:uint = 0;
	public var m_HangarUnit:Vector.<HangarUnit> = new Vector.<HangarUnit>();

	private const HangarUpdatePeriod:int = 1000;
	public var m_HangarWaitAnswer:Number = 0;

	public function get FI():FormInputEx { return EM.m_FormInputEx; }

	public function Hangar(em:EmpireMap)
	{
		Self = this;
		EM = em;

		addChild(m_LayerSlot);
		addChild(m_LayerItem);
		addChild(m_LayerIcon);
		
		EM.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
	}

	public function ClearForNewConn():void
	{
		m_HangarUnit.length = 0;
		SlotClear();
	}

	public function Show():void
	{
		visible = true;
		
		if (HangarCur() == null && m_HangarUnit.length > 0) {
			m_HangarCurId = m_HangarUnit[0].m_HangarId;
		}
		
		m_SlotMouse = -1;
		
		m_CenterX = (TableWidth >> 1);
		m_CenterY = (TableHeight >> 1);

		StageResize();
	}

	public function Hide():void
	{
		m_Action = ActionNone;
		EM.MouseUnlock();
		
		visible = false;
		
		SlotClear();
	}
	
	public function StageResize():void
	{
		if (!visible) return;
		
		Update();
	}
	
	public function onDeactivate(e:Event):void
	{
		m_Action = ActionNone;
		EM.MouseUnlock();
	}
	
	public function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;
		
		if (m_Action == ActionSlotMove) {
			EM.MouseUnlock();
			m_Action = ActionNone;
			SlotMoveComplate();
			Update();
		} else {
			onMouseMove(e);
		
			if (m_SlotMouse < 0)  {
				m_Action = ActionCamPrepare;
				m_ActionOldX = stage.mouseX;
				m_ActionOldY = stage.mouseY;
				EM.MouseLock();
			} else {
				m_Action = ActionSlotPrepare;
				m_ActionOldX = stage.mouseX;
				m_ActionOldY = stage.mouseY;
				EM.MouseLock();
			}
		}
	}

	public function onMouseUp(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;
		
		if (m_Action == ActionCamPrepare) {
			EM.MouseUnlock();
			m_Action = ActionNone;
			MenuGlobal();

		} else if (m_Action == ActionCam) {
			EM.MouseUnlock();
			m_Action = ActionNone;

		} else if (m_Action == ActionSlotPrepare) {
			EM.MouseUnlock();
			m_Action = ActionNone;
			MenuSlot();

		} else if (m_Action == ActionSlotMove) {
//			EM.MouseUnlock();
//			m_Action = ActionNone;
		}
	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var infohide:Boolean = true;
		var upd:Boolean = false;

		if (m_Action == ActionCamPrepare) {
			m_Action = ActionCam;
			m_CenterX -= stage.mouseX - m_ActionOldX;
			m_CenterY -= stage.mouseY - m_ActionOldY;
			if (m_CenterX < 100) m_CenterX = 100; else if (m_CenterX >= TableWidth-100) m_CenterX = TableWidth - 100;
			if (m_CenterY < 100) m_CenterY = 100; else if (m_CenterY >= TableHeight-100) m_CenterY = TableHeight - 100;
			m_ActionOldX = stage.mouseX;
			m_ActionOldY = stage.mouseY;
			upd = true;

		} else if (m_Action == ActionCam) {
			m_CenterX -= stage.mouseX - m_ActionOldX;
			m_CenterY -= stage.mouseY - m_ActionOldY;
			if (m_CenterX < 100) m_CenterX = 100; else if (m_CenterX >= TableWidth-100) m_CenterX = TableWidth - 100;
			if (m_CenterY < 100) m_CenterY = 100; else if (m_CenterY >= TableHeight-100) m_CenterY = TableHeight - 100;
			m_ActionOldX = stage.mouseX;
			m_ActionOldY = stage.mouseY;
			upd = true;

		} else if (m_Action == ActionSlotPrepare) {
			m_Action = ActionNone;
			EM.MouseUnlock();

			while(true) {
				var hu:HangarUnit = HangarCur();
				if (!hu) break;
				if (!hu.m_Slot[m_SlotMouse].m_Type) break;
				if (!hu.m_Slot[m_SlotMouse].m_ItemType) break;

				var idesc:Item = UserList.Self.GetItem(hu.m_Slot[m_SlotMouse].m_ItemType);

				EM.m_Info.Hide();
				EM.m_MoveItem.Begin(16 + HangarCurNum(), m_SlotMouse, idesc && !idesc.IsEq());
				m_SlotMouse = -1;
				upd = true;
				break;
			}

		} else if (m_Action == ActionSlotMove) {
			var slot:Slot = SlotByNum(m_SlotMouse);
			if (slot != null) {
				SlotFindPlace(ScreentToWorldX(stage.mouseX), ScreentToWorldY(stage.mouseY), slot);
			}

			m_ActionOldX = stage.mouseX;
			m_ActionOldY = stage.mouseY;
			upd = true;
			
		} else if (EM.PopupMenu == null) {
			var s:int = Pick();
			if (s != m_SlotMouse) {
				m_SlotMouse = s;
				upd = true;
			}
		}
		
		while (m_SlotMouse >= 0 && m_Action != ActionSlotMove) {
			hu = HangarCur();
			if (!hu) break;
			if (!hu.m_Slot[m_SlotMouse].m_Type) break;
			if (!hu.m_Slot[m_SlotMouse].m_ItemType) break;

			EM.m_Info.ShowItemEx(
				hu.m_Slot[m_SlotMouse],
				hu.m_Slot[m_SlotMouse].m_ItemType,
				hu.m_Slot[m_SlotMouse].m_ItemCnt,
				Server.Self.m_UserId,
				0,
				hu.m_Slot[m_SlotMouse].m_ItemBroken,
				GetItemSlotX(m_SlotMouse) - 25, GetItemSlotY(m_SlotMouse) - 25, 50, 50);
			infohide = false;
			break;
		}

		if (upd) Update();
		if(infohide) EM.m_Info.Hide();
	}

	public function onMouseWheelHandler(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	public function onKeyDownHandler(e:KeyboardEvent):void
	{
		var addkey:Boolean = e.altKey || e.ctrlKey || e.shiftKey;

		if (e.keyCode == 72 && !EM.IsFocusInput()) { // H
			Hangar.Self.Hide();
			EM.ItfUpdate();
		}
	}
	
	public function SlotGraphClear(slot:Slot):void
	{
		if (slot.m_ImgN) {
			m_LayerSlot.removeChild(slot.m_ImgN);
			slot.m_ImgN = null;
		}
		if (slot.m_ImgA) {
			m_LayerSlot.removeChild(slot.m_ImgA);
			slot.m_ImgA = null;
		}
		if (slot.m_ImgItem) {
			m_LayerItem.removeChild(slot.m_ImgItem);
			slot.m_ImgItem = null;
		}
		if (slot.m_ImgNeedEnergy) {
			m_LayerIcon.removeChild(slot.m_ImgNeedEnergy);
			slot.m_ImgNeedEnergy = null;
		}
	}
	
	public function SlotDelete(i:int):void
	{
		var slot:Slot = m_Slot[i];
		SlotGraphClear(slot);
		m_Slot.splice(i, 1);
	}

	public function SlotClear():void
	{
		var i:int;
		for (i = m_Slot.length - 1; i >= 0 ; i--) SlotDelete(i);
	}
	
	public function SlotByNum(num:int):Slot
	{
		var i:int;
		for (i = 0; i < m_Slot.length; i++) if (m_Slot[i].m_SlotNum == num) return m_Slot[i];
		return null;
	}
	
	[Inline] public final function SlotIsEmptyPlace(x:int, y:int, type:int, skip:Slot):Boolean
	{
		var i:int, r:int, d:int;
		var slot:Slot;

		if (type == stNone) return false;
		
		if (x<0 || x>=TableWidth) return false;
		if (y<0 || y>=TableHeight) return false;

		for (i = 0; i < m_Slot.length; i++) {
			slot = m_Slot[i];
			if (!slot.m_Type) continue;
			if (slot == skip) continue;

			d = (slot.m_X - x) * (slot.m_X - x) + (slot.m_Y - y) * (slot.m_Y - y);
			r = slotRadius[type] + slotRadius[slot.m_Type];
			if (slot.m_Type == stNone) continue;
			if (slotCanConnect[((type-1) << 2) + (slot.m_Type-1)] == 0) r += 8;

			if (d < r * r) return false;
		}
		return true;
	}
	
	public function SlotFindPlace(wishx:int, wishy:int, forslot:Slot):void
	{
		var i:int, u:int, lvl:int, d:int, dd:int, tx:int, ty:int, bx:int, by:int;
		var find:Boolean = false;
		
		if (SlotIsEmptyPlace(wishx, wishy, forslot.m_Type, forslot)) {
			forslot.m_X = wishx;
			forslot.m_Y = wishy;
			return;
		}
		lvl = 1;
		bx = wishx; by = wishy;
		while (true) {
			for (u = -lvl; u <= lvl; u++) {
				tx = wishx + u; ty = wishy - lvl;
				if (!SlotIsEmptyPlace(tx, ty, forslot.m_Type, forslot)) continue;
				d = (tx - wishx) * (tx - wishx) + (ty - wishy) * (ty - wishy);
				if (find && d > dd) continue;
				dd = d; bx = tx; by = ty;
				find = true;
			}
			for (u = -lvl; u <= lvl; u++) {
				tx = wishx + u; ty = wishy + lvl;
				if (!SlotIsEmptyPlace(tx, ty, forslot.m_Type, forslot)) continue;
				d = (tx - wishx) * (tx - wishx) + (ty - wishy) * (ty - wishy);
				if (find && d > dd) continue;
				dd = d; bx = tx; by = ty;
				find = true;
			}
			for (u = -lvl + 1; u <= lvl - 1; u++) {
				tx = wishx - lvl; ty = wishy + u;
				if (!SlotIsEmptyPlace(tx, ty, forslot.m_Type, forslot)) continue;
				d = (tx - wishx) * (tx - wishx) + (ty - wishy) * (ty - wishy);
				if (find && d > dd) continue;
				dd = d; bx = tx; by = ty;
				find = true;
			}
			for (u = -lvl + 1; u <= lvl - 1; u++) {
				tx = wishx + lvl; ty = wishy + u;
				if (!SlotIsEmptyPlace(tx, ty, forslot.m_Type, forslot)) continue;
				d = (tx - wishx) * (tx - wishx) + (ty - wishy) * (ty - wishy);
				if (find && d > dd) continue;
				dd = d; bx = tx; by = ty;
				find = true;
			}
			if (find && dd < lvl * lvl) break;
			lvl++;
		}
		forslot.m_X = bx;
		forslot.m_Y = by;
	}
	
	public function WorldToScreentX(v:int):int
	{
		return v - m_CenterX + (C3D.m_SizeX >> 1);
	}

	public function WorldToScreentY(v:int):int
	{
		return v - m_CenterY + (C3D.m_SizeY >> 1);
	}
	
	public function ScreentToWorldX(v:int):int
	{
		return v + m_CenterX - (C3D.m_SizeX >> 1);
	}

	public function ScreentToWorldY(v:int):int
	{
		return v + m_CenterY - (C3D.m_SizeY >> 1);
	}
	
	public function HangarCur():HangarUnit
	{
		var i:int;
		for (i = 0; i < m_HangarUnit.length; i++) {
			if (m_HangarUnit[i].m_HangarId == m_HangarCurId) return m_HangarUnit[i];
		}
		return null;
	}

	public function HangarCurNum():int
	{
		var i:int;
		for (i = 0; i < m_HangarUnit.length; i++) {
			if (m_HangarUnit[i].m_HangarId == m_HangarCurId) return i;
		}
		return -1;
	}
	
	public function GetItemSlotX(slot:int):int
	{
		var i:int;
		for (i = 0; i < m_Slot.length; i++) {
			var p:Slot = m_Slot[i];
			if(p.m_SlotNum==slot) return WorldToScreentX(p.m_X);
		}
		return 0;
	}

	public function GetItemSlotY(slot:int):int
	{
		var i:int;
		for (i = 0; i < m_Slot.length; i++) {
			var p:Slot = m_Slot[i];
			if(p.m_SlotNum==slot) return WorldToScreentY(p.m_Y);
		}
		return 0;
	}

	public function Update():void
	{
		var i:int, px:int, py:int, u:int;
		var slot:Slot;
		var idesc:Item;

		if (!visible) return;

		graphics.clear();
		graphics.beginFill(0x000000, 1.0);
		graphics.drawRect(0, 0, C3D.m_SizeX, C3D.m_SizeY);
		graphics.endFill();

		for (i = 0; i < m_Slot.length; i++) {
			slot = m_Slot[i];
			slot.m_Tmp = 0;
		}
		var h:HangarUnit = HangarCur();
		if (h) {
			h.CalcPar();

			for (i = 0; i < h.m_Slot.length; i++) {
				var hs:HangarSlot = h.m_Slot[i];
				if (hs.m_Type == stNone) continue;
				for (u = 0; u < m_Slot.length; u++) {
					slot = m_Slot[u];
					if (slot.m_SlotNum == i && slot.m_Type == hs.m_Type) break;
				}
				if (u >= m_Slot.length) {
					slot = new Slot();
					slot.m_SlotNum = i;
					slot.m_Type = hs.m_Type;
					m_Slot.push(slot);
				}
				slot.m_Tmp = 1;
				if (m_Action != ActionSlotMove) {
					slot.m_X = hs.m_X;
					slot.m_Y = hs.m_Y;
				}

				if (slot.m_ImgN == null) {
					if (slot.m_Type == stEnergy) {
						slot.m_ImgN = new bmSlotEne();
						slot.m_ImgA = new bmSlotEneA();

					} else if (slot.m_Type == stCharge) {
						slot.m_ImgN = new bmSlotZar();
						slot.m_ImgA = new bmSlotZarA();

					} else if (slot.m_Type == stCore) {
						slot.m_ImgN = new bmSlotCore();
						slot.m_ImgA = new bmSlotCoreA();

					} else if (slot.m_Type == stSupply) {
						slot.m_ImgN = new bmSlotSup();
						slot.m_ImgA = new bmSlotSupA();

					} else throw Error("");

					m_LayerSlot.addChild(slot.m_ImgN);
					m_LayerSlot.addChild(slot.m_ImgA);
				}

				if (slot.m_ItemType != hs.m_ItemType && slot.m_ImgItem) {
					m_LayerItem.removeChild(slot.m_ImgItem);
					slot.m_ImgItem = null;
				}
				
				if (hs.m_ItemType && slot.m_ImgItem == null) {
					slot.m_ItemType = hs.m_ItemType;

					idesc = UserList.Self.GetItem(slot.m_ItemType);
					if (idesc && idesc.IsEq()) {
						var bm:Bitmap = new Bitmap();
						bm.bitmapData = Common.ItemEqImg(idesc.m_Img, false);
						var sp:Sprite = new Sprite();
						sp.addChild(bm);
						bm.x = -(bm.width >> 1);
						bm.y = -(bm.height >> 1);
						slot.m_ImgItem = sp;
						m_LayerItem.addChild(slot.m_ImgItem);
					}
				}
				
				if (hs.m_Energy < 0) {
					if (!slot.m_ImgNeedEnergy) {
						slot.m_ImgNeedEnergy = new bmNeedEnergy();
						m_LayerIcon.addChild(slot.m_ImgNeedEnergy);
					}
					slot.m_ImgNeedEnergy.visible = true;
				} else {
					if (slot.m_ImgNeedEnergy) slot.m_ImgNeedEnergy.visible = false;
				}
			}
		}
		for (i = m_Slot.length - 1; i >= 0; i--) {
			slot = m_Slot[i];
			if (slot.m_Tmp != 0) continue;
			SlotDelete(i);
		}

		for (i = 0; i < m_Slot.length; i++) {
			slot = m_Slot[i];

			px = WorldToScreentX(slot.m_X);
			py = WorldToScreentY(slot.m_Y);

			slot.m_ImgN.x = px - (slot.m_ImgN.width >> 1);
			slot.m_ImgN.y = py - (slot.m_ImgN.height >> 1);
			slot.m_ImgA.x = px - (slot.m_ImgA.width >> 1);
			slot.m_ImgA.y = py - (slot.m_ImgA.height >> 1);

			if (slot.m_ImgItem) {
				slot.m_ImgItem.x = px;
				slot.m_ImgItem.y = py;
			}

			if (slot.m_ImgNeedEnergy) {
				slot.m_ImgNeedEnergy.x = px - (slot.m_ImgNeedEnergy.width >> 1) + 2;
				slot.m_ImgNeedEnergy.y = py - (slot.m_ImgNeedEnergy.height >> 1) + 2 + Math.floor(0.35 * slot.m_ImgA.height);
			}

			slot.m_ImgA.visible = (slot.m_SlotNum == m_SlotMouse) || 
				(EM.m_MoveItem.visible && EM.m_MoveItem.m_ToType >= 16 && EM.m_MoveItem.m_ToType < (16 + Hangar.HangarMax) && EM.m_MoveItem.m_ToSlot == slot.m_SlotNum) || 
				(EM.m_MoveItem.visible && EM.m_MoveItem.m_FromType >= 16 && EM.m_MoveItem.m_FromType < (16 + Hangar.HangarMax) && EM.m_MoveItem.m_FromSlot == slot.m_SlotNum) || 
				(EM.m_FormFleetBar.m_SlotMove >= 0 && EM.m_FormFleetBar.m_SlotMoveBegin && EM.m_MoveItem.m_ToType >= 16 && EM.m_MoveItem.m_ToType < (16 + Hangar.HangarMax) && EM.m_MoveItem.m_ToSlot == slot.m_SlotNum);
			slot.m_ImgN.visible = !slot.m_ImgA.visible;
		}
	}
	
	public function Pick():int
	{
		var i:int, px:int, py:int, d:int, r:int;
		var slot:Slot;

		px = ScreentToWorldX(stage.mouseX);
		py = ScreentToWorldY(stage.mouseY);

		for (i = 0; i < m_Slot.length; i++) {
			slot = m_Slot[i];
			
			d = (slot.m_X - px) * (slot.m_X - px) + (slot.m_Y - py) * (slot.m_Y - py);
			r = slotRadius[slot.m_Type];
			if (d < r * r) return slot.m_SlotNum;
		}
		return -1;
	}
	
	public function MenuGlobal():void
	{
		var i:int;
		
		var pm:CtrlPopupMenu = new CtrlPopupMenu();
		pm.Place(stage.mouseX, stage.mouseY);

//		pm.ItemAdd("Add:                        ");
//		pm.ItemAdd("    Energy", stEnergy, 0, onAddType);
//		pm.ItemAdd("    Charge", stCharge, 0, onAddType);
//		pm.ItemAdd("    Core", stCore, 0, onAddType);
//		pm.ItemAdd("    Supply", stSupply, 0, onAddType);

		i = pm.ItemAdd(Common.Txt.HangarAddSlot, undefined, 0, onSlotAdd);

		pm.Show();
	}
	
	public function MenuSlot():void
	{
		var i:int;
		
		var slot:Slot = SlotByNum(m_SlotMouse);
		if (!slot) return;

		var pm:CtrlPopupMenu = new CtrlPopupMenu();
		pm.Place(stage.mouseX, stage.mouseY);
		
		i = pm.ItemAdd(Common.Txt.HangarMoveSlot, undefined, 0, onSlotMove);
		i = pm.ItemAdd(Common.Txt.HangarDelSlot, undefined, 0, onSlotDel);

//		pm.ItemAdd("Type:                        ");
//		i = pm.ItemAdd("    Energy", stEnergy, 0, onChangeType); pm.itemCheckSet(i, slot.m_Type == stEnergy);
//		i = pm.ItemAdd("    Charge", stCharge, 0, onChangeType); pm.itemCheckSet(i, slot.m_Type == stCharge);
//		i = pm.ItemAdd("    Core", stCore, 0, onChangeType); pm.itemCheckSet(i, slot.m_Type == stCore);
//		i = pm.ItemAdd("    Supply", stSupply, 0, onChangeType); pm.itemCheckSet(i, slot.m_Type == stSupply);
//		pm.ItemAdd();
//		pm.ItemAdd("Delete", 0, 0, onSlotDelete);

		pm.Show();
	}
	
	private var m_LabelDesc:TextField = null;
	
	public function onSlotAdd(v:*):void
	{
		m_ActionOldX = stage.mouseX;
		m_ActionOldY = stage.mouseY;
		
		FI.Init(370, 300);
		FI.caption = Common.Txt.HangarAddSlotCaption.toUpperCase();

		var price:int = m_Slot.length * m_Slot.length * m_Slot.length * m_Slot.length * 2;
		FI.AddLabel(BaseStr.Replace("[justify]" + Common.Txt.HangarAddSlotText + "[/justify]", "<Price>", "[clr]" + BaseStr.FormatBigInt(price) + "[/clr]"), true);

		FI.AddLabel(Common.Txt.HangarAddSlotType + ":");
		FI.Col();
		FI.AddComboBox().addEventListener(Event.CHANGE, changeSlotType);
		FI.AddItem(Common.Txt.HangarSlotEnergy, stEnergy, true);
		FI.AddItem(Common.Txt.HangarSlotCharge, stCharge);
		FI.AddItem(Common.Txt.HangarSlotCore, stCore);
		FI.AddItem(Common.Txt.HangarSlotSupply, stSupply);

		m_LabelDesc = FI.AddLabel(Common.Txt.HangarSlotChargeDesc, true);

		FI.Run(sendSlotAdd, Common.Txt.HangarAddSlotBuy.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());

		changeSlotType(null);
	}
	
	private function changeSlotType(e:Event):void
	{
		switch(FI.GetInt(0)) {
			case stEnergy: m_LabelDesc.htmlText = BaseStr.FormatTag("[justify]" + Common.Txt.HangarSlotEnergyDesc + "[/justify]"); break;
			case stCharge: m_LabelDesc.htmlText = BaseStr.FormatTag("[justify]" + Common.Txt.HangarSlotChargeDesc + "[/justify]"); break;
			case stCore: m_LabelDesc.htmlText = BaseStr.FormatTag("[justify]" + Common.Txt.HangarSlotCoreDesc + "[/justify]"); break;
			case stSupply: m_LabelDesc.htmlText = BaseStr.FormatTag("[justify]" + Common.Txt.HangarSlotSupplyDesc + "[/justify]"); break;
		}
	}

	private function sendSlotAdd():void
	{
		var h:HangarUnit = HangarCur();
		if (!h) return;
		
		if (m_Slot.length >= 32) {
			FormMessageBox.Run(Common.Txt.HangarAddSlotErrMax, Common.Txt.ButClose);
		}
		var price:int = m_Slot.length * m_Slot.length * m_Slot.length * m_Slot.length * 2;
		if (EM.m_FormFleetBar.m_FleetMoney < price) {
			FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose);
			return;
		}

		var slot:Slot = new Slot();
		slot.m_Type = FI.GetInt(0);
		SlotFindPlace(ScreentToWorldX(m_ActionOldX), ScreentToWorldY(m_ActionOldY), slot);

		var i:int;
		for (i = 0; i < h.m_Slot.length; i++) {
			if (h.m_Slot[i].m_Type == stNone) break;
		}
		if (i >= h.m_Slot.length) return;
		
		h.m_Slot[i].m_Type = slot.m_Type;
		h.m_Slot[i].m_X = slot.m_X;
		h.m_Slot[i].m_Y = slot.m_Y;
		h.m_Slot[i].m_ItemType = 0;
		h.m_Slot[i].m_ItemCnt = 0;
		h.m_Slot[i].m_ItemBroken = 0;

		h.m_Anm = h.m_Anm + 256;
		h.m_LoadAfterAnm = h.m_Anm;
		h.m_LoadAfterAnm_Time = Common.GetTime();

		Server.Self.QueryHS("emhop", "&t=2&val=" + h.m_HangarId.toString() + "_" + i.toString() +"_" + slot.m_Type.toString() + "_" + slot.m_X.toString() + "_" + slot.m_Y.toString() + "_" + h.m_Anm.toString(), AnswerHop, false);
		
		Update();
	}

	public function onSlotMove(v:*):void
	{
		if (!SlotByNum(m_SlotMouse)) return;
		EM.m_Info.Hide();
		m_Action = ActionSlotMove;
		EM.MouseLock();
	}

	public function onSlotDel(v:*):void
	{
		FormMessageBox.Run(Common.Txt.HangarDelSlotQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, sendSlotDel);
	}
	
	public function sendSlotDel():void
	{
		if (!SlotByNum(m_SlotMouse)) return;
		
		var i:int = m_SlotMouse;

		var h:HangarUnit = HangarCur();
		if (!h) return;

		h.m_Slot[i].m_Type = 0;
		h.m_Slot[i].m_X = 0;
		h.m_Slot[i].m_Y = 0;
		h.m_Slot[i].m_ItemType = 0;
		h.m_Slot[i].m_ItemCnt = 0;
		h.m_Slot[i].m_ItemBroken = 0;

		h.m_Anm = h.m_Anm + 256;
		h.m_LoadAfterAnm = h.m_Anm;
		h.m_LoadAfterAnm_Time = Common.GetTime();

		Server.Self.QueryHS("emhop", "&t=3&val=" + h.m_HangarId.toString() + "_" + i.toString() + "_" + h.m_Anm.toString(), AnswerHop, false);
	}

	public function AnswerHop(event:Event):void
	{
		var i:int;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian = Endian.LITTLE_ENDIAN;
//trace(buf.readUTFBytes(buf.length));
		var err:uint = buf.readUnsignedByte();
		if (err == Server.ErrorNoEnoughMoney) { FormMessageBox.RunErr(Common.Txt.NoEnoughMoney); return; }
		else if (err == Server.ErrorNoEnoughEGM) { FormMessageBox.RunErr(Common.Txt.NoEnoughEGM2); return; }
		else if (EM.ErrorFromServer(err)) return;
	}

	public function SlotMoveComplate():void
	{
		var slot:Slot = SlotByNum(m_SlotMouse);
		if (!slot) return;
		if (m_SlotMouse < 0 || m_SlotMouse >= HangarUnit.SlotMax) return;

		var h:HangarUnit = HangarCur();
		h.m_Slot[m_SlotMouse].m_X = slot.m_X;
		h.m_Slot[m_SlotMouse].m_Y = slot.m_Y;

		h.m_Anm = h.m_Anm + 256;
		h.m_LoadAfterAnm = h.m_Anm;
		h.m_LoadAfterAnm_Time = Common.GetTime();

		Server.Self.QueryHS("emhop", "&t=1&val=" + h.m_HangarId.toString() + "_" + m_SlotMouse.toString() + "_" + slot.m_X.toString() + "_" + slot.m_Y.toString() + "_" + h.m_Anm.toString(), AnswerHop, false);
	}

//	public function onSlotDelete(v:*):void
//	{
//		if (m_SlotMouse < 0 || m_SlotMouse >= m_Slot.length) return;
//		SlotDelete(m_SlotMouse);
//		Update();
//	}
	
//	public function onChangeType(v:int):void
//	{
//		if (m_SlotMouse < 0 || m_SlotMouse >= m_Slot.length) return;
//		var slot:Slot = m_Slot[m_SlotMouse];
//		SlotGraphClear(slot);
//		slot.m_Type = v;
//		Update();
//	}

//	public function onAddType(v:int):void
//	{
//		var slot:Slot = new Slot();
//		slot.m_Type = v;
//		slot.m_X = ScreentToWorldX(m_ActionOldX);
//		slot.m_Y = ScreentToWorldY(m_ActionOldY);
//		m_Slot.push(slot);
//
//		Update();
//	}

	public function HangarQuery():void
	{
		var i:int, u:int;
		
		if (m_Action == ActionSlotMove) return;

		var ct:Number = Common.GetTime();
		if (ct < m_HangarWaitAnswer) return;

		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;
		var sl:SaveLoad=new SaveLoad();
		sl.SaveBegin(ba);

		for (i = 0; i < EM.m_FormFleetBar.m_HangarListId.length; i++) {
			var hid:uint = EM.m_FormFleetBar.m_HangarListId[i];
			sl.SaveDword(hid);
			for (u = 0; u < m_HangarUnit.length; u++) if (m_HangarUnit[u].m_HangarId == hid) break;
			if (u < m_HangarUnit.length) {
				sl.SaveDword(m_HangarUnit[u].m_Anm);
			} else {
				sl.SaveDword(0);
			}
		}
		sl.SaveDword(0);

		sl.SaveEnd();

		m_HangarWaitAnswer = Common.GetTime() + HangarUpdatePeriod * 5;

		Server.Self.QuerySmallHS("emhangar", true, Server.sqHangar, ba, HangarRecv);
	}

	public function HangarRecv(errcode:uint, buf:ByteArray):void
	{
		var i:int, u:int;
		var h:HangarUnit;
		var s:HangarSlot;

		if (m_Action == ActionSlotMove) { m_HangarWaitAnswer = Common.GetTime(); return; }

		var ct:Number = Common.GetTime();

		var sl:SaveLoad = new SaveLoad();

		if(EM.ErrorFromServer(errcode)) return;
		if (buf == null || buf.length <= 0) throw Error("HangarRecv");

		sl.LoadBegin(buf);

		for (i = 0; i < m_HangarUnit.length; i++) {
			m_HangarUnit[i].m_Tmp = 0;
		}
		
		while (true) {
			var hid:uint = sl.LoadDword();
			if (!hid) break;

			for (u = 0; u < m_HangarUnit.length; u++) {
				h = m_HangarUnit[u];
				if (h.m_HangarId == hid) break;
			}
			if (u >= m_HangarUnit.length) {
				h = new HangarUnit();
				h.m_HangarId = hid;
				m_HangarUnit.push(h);
			}
			h.m_Tmp = 1;

			var anm:uint = sl.LoadDword();
//trace("recv", hid, anm);
			if (anm == 0) continue;
			
			if ((anm >= h.m_LoadAfterAnm) || (ct > (h.m_LoadAfterAnm_Time + 5000))) { }
			else {
				h = new HangarUnit();
			}

			h.m_Anm = anm;
			h.m_Hull = sl.LoadDword();
			h.m_Sort = sl.LoadDword();

			h.SlotClear();

			for (u = 0; u < HangarUnit.SlotMax; u++) {
				s = h.m_Slot[u];
				s.m_Type = sl.LoadDword();
				if (s.m_Type == stNone) continue;
				s.m_X = sl.LoadInt();
				s.m_Y = sl.LoadInt();
				s.m_ItemType = sl.LoadDword();
//trace("slot", s.m_Type, s.m_X, s.m_Y, s.m_ItemType);
				if (!s.m_ItemType) continue;
				s.m_ItemCnt = sl.LoadInt();
				s.m_ItemBroken = sl.LoadInt();
			}
		}

		for (i = m_HangarUnit.length - 1; i >= 0; i--) {
			if (m_HangarUnit[i].m_Tmp != 0) continue;
			m_HangarUnit.splice(i, 1);
		}
		
		sl.LoadEnd();

		m_HangarWaitAnswer = Common.GetTime() + HangarUpdatePeriod;

		if (HangarCur() == null && m_HangarUnit.length > 0) {
			m_HangarCurId = m_HangarUnit[0].m_HangarId;
		}
		Update();
	}
	
	public function Takt():void
	{
		if (!visible) return;
		HangarQuery();
	}
}

}

{
import flash.display.*;

class Slot {
	public var m_SlotNum:int = 0;
	public var m_Type:uint = 0;
	public var m_X:int = 0;
	public var m_Y:int = 0;
	
	public var m_ItemType:uint = 0;
	
	public var m_ImgN:Bitmap = null;
	public var m_ImgA:Bitmap = null;
	public var m_ImgItem:DisplayObject = null;
	public var m_ImgNeedEnergy:Bitmap = null;
	
	public var m_Tmp:uint = 0;

	public function Slot():void
	{
	}
}

}
