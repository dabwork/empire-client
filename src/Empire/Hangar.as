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

	static public const SlotMax:int = 32;

	static public const stNone:int = 0;
	static public const stEnergy:int = 1;
	static public const stCharge:int = 2;
	static public const stCore:int = 3;
	static public const stSupply:int = 4;

	static public const slotDescBattleship:Vector.<int> = new <int>[
		// type,x,y,link
		stEnergy, 0, 0, -1, // 00
		stEnergy, 100, 100, -1 // 01
	];
	
	static public const slotRadius:Vector.<int> = new <int>[0,34+3,34+3,51+3,26+3];
	static public const slotCanConnect:Vector.<int> = new <int>[
		// Energe Charge Core Supplay
		1, 0, 1, 0, // Energe
		0, 1, 1, 0, // Charge
		1, 1, 0, 0, // Core
		0, 0, 0, 0  // Supplay
	];

	public var m_Slot:Vector.<Slot> = new Vector.<Slot>();

	public var m_CenterX:int = 0;
	public var m_CenterY:int = 0;

	public var m_SlotMouse:int = -1;

	static public const ActionNone:int = 0;
	static public const ActionCamPrepare:int = 1;
	static public const ActionCam:int = 2;
	static public const ActionSlotPrepare:int = 3;
	static public const ActionSlotMove:int = 4;

	public var m_Action:int = 0;
	public var m_ActionOldX:int = 0;
	public var m_ActionOldY:int = 0;

	public var m_HangarUnit:Vector.<HangarUnit> = new Vector.<HangarUnit>();

	public function Hangar(em:EmpireMap)
	{
		Self = this;
		EM = em;
		
		EM.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
	}

	public function ClearForNewConn():void
	{
	}

	public function Show():void
	{
		visible = true;
		
		m_SlotMouse = -1;
		
		m_CenterX = 0;
		m_CenterY = 0;
		SlotLoad(slotDescBattleship);
		
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
			EM.MouseUnlock();
			m_Action = ActionNone;
		}
	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var infohide:Boolean = true;
		var upd:Boolean = false;

		if (m_Action == ActionCamPrepare) {
			m_Action = ActionCam;
			m_CenterX += stage.mouseX - m_ActionOldX;
			m_CenterY += stage.mouseY - m_ActionOldY;
			m_ActionOldX = stage.mouseX;
			m_ActionOldY = stage.mouseY;
			upd = true;

		} else if (m_Action == ActionCam) {
			m_CenterX += stage.mouseX - m_ActionOldX;
			m_CenterY += stage.mouseY - m_ActionOldY;
			m_ActionOldX = stage.mouseX;
			m_ActionOldY = stage.mouseY;
			upd = true;

		} else if (m_Action == ActionSlotPrepare) {
			m_Action = ActionSlotMove;

		} else if (m_Action == ActionSlotMove) {
			SlotFindPlace(ScreentToWorldX(stage.mouseX), ScreentToWorldY(stage.mouseY), m_Slot[m_SlotMouse]);
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
			removeChild(slot.m_ImgN);
			slot.m_ImgN = null;
		}

		if (slot.m_ImgA) {
			removeChild(slot.m_ImgA);
			slot.m_ImgA = null;
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
	
	[Inline] public final function SlotIsEmptyPlace(x:int, y:int, type:int, skip:Slot):Boolean
	{
		var i:int, r:int, d:int;
		var slot:Slot;

		if (type == stNone) return false;

		for (i = 0; i < m_Slot.length; i++) {
			slot = m_Slot[i];
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
	
	public function SlotLoad(desc:Vector.<int>):void
	{
		var i:int;
		var slot:Slot;

		SlotClear();

		for (i = 0; i < desc.length; i += 4) {
			slot = new Slot();
			slot.m_Type = desc[i + 0];
			slot.m_X = desc[i + 1];
			slot.m_Y = desc[i + 2];
			m_Slot.push(slot);
		}
	}
	
	public function WorldToScreentX(v:int):int
	{
		return v + m_CenterX + (C3D.m_SizeX >> 1);
	}

	public function WorldToScreentY(v:int):int
	{
		return v + m_CenterY + (C3D.m_SizeY >> 1);
	}
	
	public function ScreentToWorldX(v:int):int
	{
		return v - m_CenterX - (C3D.m_SizeX >> 1);
	}

	public function ScreentToWorldY(v:int):int
	{
		return v - m_CenterY - (C3D.m_SizeY >> 1);
	}

	public function Update():void
	{
		var i:int, px:int, py:int;
		var slot:Slot;
		
		graphics.clear();
		graphics.beginFill(0x000000, 1.0);
		graphics.drawRect(0, 0, C3D.m_SizeX, C3D.m_SizeY);
		graphics.endFill();
		
		for (i = 0; i < m_Slot.length; i++) {
			slot = m_Slot[i];

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
				
				addChild(slot.m_ImgN);
				addChild(slot.m_ImgA);
			}

			px = WorldToScreentX(slot.m_X);
			py = WorldToScreentY(slot.m_Y);

			slot.m_ImgN.x = px - (slot.m_ImgN.width >> 1);
			slot.m_ImgN.y = py - (slot.m_ImgN.height >> 1);
			slot.m_ImgA.x = px - (slot.m_ImgA.width >> 1);
			slot.m_ImgA.y = py - (slot.m_ImgA.height >> 1);
			
			slot.m_ImgN.visible = i != m_SlotMouse;
			slot.m_ImgA.visible = i == m_SlotMouse;
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
			if (d < r * r) return i;
		}
		return -1;
	}
	
	public function MenuGlobal():void
	{
		var pm:CtrlPopupMenu = new CtrlPopupMenu();
		pm.Place(stage.mouseX, stage.mouseY);

		pm.ItemAdd("Add:                        ");
		pm.ItemAdd("    Energy", stEnergy, 0, onAddType);
		pm.ItemAdd("    Charge", stCharge, 0, onAddType);
		pm.ItemAdd("    Core", stCore, 0, onAddType);
		pm.ItemAdd("    Supply", stSupply, 0, onAddType);

		pm.Show();
	}
	
	public function MenuSlot():void
	{
		var i:int;
		
		if (m_SlotMouse < 0 || m_SlotMouse >= m_Slot.length) return;
		var slot:Slot = m_Slot[m_SlotMouse];

		var pm:CtrlPopupMenu = new CtrlPopupMenu();
		pm.Place(stage.mouseX, stage.mouseY);

		pm.ItemAdd("Type:                        ");
		i = pm.ItemAdd("    Energy", stEnergy, 0, onChangeType); pm.itemCheckSet(i, slot.m_Type == stEnergy);
		i = pm.ItemAdd("    Charge", stCharge, 0, onChangeType); pm.itemCheckSet(i, slot.m_Type == stCharge);
		i = pm.ItemAdd("    Core", stCore, 0, onChangeType); pm.itemCheckSet(i, slot.m_Type == stCore);
		i = pm.ItemAdd("    Supply", stSupply, 0, onChangeType); pm.itemCheckSet(i, slot.m_Type == stSupply);
		pm.ItemAdd();
		pm.ItemAdd("Delete", 0, 0, onSlotDelete);

		pm.Show();
	}
	
	public function onSlotDelete(v:*):void
	{
		if (m_SlotMouse < 0 || m_SlotMouse >= m_Slot.length) return;
		SlotDelete(m_SlotMouse);
		Update();
	}
	
	public function onChangeType(v:int):void
	{
		if (m_SlotMouse < 0 || m_SlotMouse >= m_Slot.length) return;
		var slot:Slot = m_Slot[m_SlotMouse];
		SlotGraphClear(slot);
		slot.m_Type = v;
		Update();
	}

	public function onAddType(v:int):void
	{
		var slot:Slot = new Slot();
		slot.m_Type = v;
		slot.m_X = ScreentToWorldX(m_ActionOldX);
		slot.m_Y = ScreentToWorldY(m_ActionOldY);
		m_Slot.push(slot);

		Update();
	}
}

}

{
import flash.display.*;

class Slot {
	public var m_Type:uint = 0;
	public var m_X:int = 0;
	public var m_Y:int = 0;
	
	public var m_ImgN:Bitmap = null;
	public var m_ImgA:Bitmap = null;

	public function Slot():void
	{
	}
}

}
