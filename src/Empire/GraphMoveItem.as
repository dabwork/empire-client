// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import fl.controls.*;
import fl.events.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class GraphMoveItem extends Shape
{
	private var m_Map:EmpireMap;

	public var m_FromType:int = 0; // 1-Planet 2-FleetItem 3,4,5-Flagship 9-FleetShip 99-ToTrade
	public var m_FromSlot:int = -1;
	public var m_ToType:int = 0;
	public var m_ToSlot:int = -1;

	public function GraphMoveItem(map:EmpireMap)
	{
		m_Map=map;
	}

	public function Begin(fromtype:int, fromslot:int):void
	{
		visible = true;
		
		m_FromType = fromtype;
		m_FromSlot = fromslot;
		m_ToType = 0;
		m_ToSlot = -1;
		
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 999);

		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 999);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true, 999);
		stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, true, 999);
		
		Update();
	}
	
	public function onMouseMove(e:MouseEvent):void
	{
		var type:int, slot:int;

		type = 0;

		if (m_Map.m_FormPlanet.IsMouseInTop()) {
			m_Map.FloatTop(m_Map.m_FormPlanet);

			slot = m_Map.m_FormPlanet.PickItem();
			if (slot >= 0) type = 1;
		}

		if (type == 0 && m_Map.m_FormFleetItem.IsMouseInTop()) {
			m_Map.FloatTop(m_Map.m_FormFleetItem);

			slot = m_Map.m_FormFleetItem.PickItem();
			if (slot >= 0) type = 2;
		}

		if (type == 0 && m_Map.m_FormFleetBar.IsMouseInTop()) {
			m_Map.FloatTop(m_Map.m_FormFleetBar);

			slot = m_Map.m_FormFleetBar.PickSlot();
			if (slot >= 0) type = 9;
		}

//		if (type == 0 && m_Map.m_FormHist.IsMouseInTop()) {
//			m_Map.FloatTop(m_Map.m_FormHist);
//			type = 99;
//			slot = 0;
//		}
	
		if (type == 0 && m_Map.m_FormStorage.IsMouseInTop()) {
			m_Map.FloatTop(m_Map.m_FormStorage);

			type = 99;
			slot = 0;
		}
	
		if ((m_ToType != type) || (m_ToSlot != slot)) {
			m_ToType = type;
			m_ToSlot = slot;
			m_Map.m_FormPlanet.Update();
			m_Map.m_FormFleetItem.Update();
			m_Map.m_FormFleetBar.Update();
		}

		Update();
		e.stopImmediatePropagation();
	}

	public function onMouseUp(e:MouseEvent):void
	{
		graphics.clear();
		visible = false;
		
		if (m_ToType == 99) {
			while (true) {
				if (m_FromType != 2) break;
				var t:uint = m_Map.m_FormFleetItem.m_FleetItem[m_FromSlot].m_Type;
				if (t == 0) break;
				
				if (m_Map.m_FormStorage.tab == m_Map.m_FormStorage.tabStorage) {
					m_Map.m_FormStorage.storageChange(t, m_Map.m_FormFleetItem.m_FleetItem[m_FromSlot].m_Cnt, false);

				} else if (m_Map.m_FormStorage.tab == m_Map.m_FormStorage.tabImport) {
					m_Map.m_FormStorage.importChange(t);

				} else if (m_Map.m_FormStorage.tab == m_Map.m_FormStorage.tabExport) {
					m_Map.m_FormStorage.exportChange(t);
				}

//				if (m_Map.m_FormHist.m_ModeCur == m_Map.m_FormHist.m_ModeExport) {
//					m_Map.m_FormHist.clickTradeExportAdd(t);
//				} else if (m_Map.m_FormHist.m_ModeCur == m_Map.m_FormHist.m_ModeImport) {
//					m_Map.m_FormHist.clickTradeImportAdd(t);
//				}
				break;
			}
		} else {
			FinMove(e.altKey || e.ctrlKey || e.shiftKey);
		}

		m_Map.m_FormPlanet.Update();
		m_Map.m_FormFleetItem.Update();

		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		stage.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false);

		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, true);
		e.stopImmediatePropagation();

		//stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, true, false, stage.mouseX, stage.mouseY));
	}

	public function FinMove(addkey:Boolean=false, cnt:int=0):void
	{
		if (m_ToType == 0 && m_FromType == 2 && m_Map.HS.visible) {
			if (addkey) {
				SplitOpen();
				return;
			}
			
			var t:uint = m_Map.m_FormFleetItem.m_FleetItem[m_FromSlot].m_Type;
			if (t == 0) return;
			if (cnt <= 0) cnt = m_Map.m_FormFleetItem.m_FleetItem[m_FromSlot].m_Cnt;
			
			m_Map.HS.Drop(t, cnt, m_FromSlot);
				
			return;
		}
		
		if (m_ToType == 0) return;

		if (addkey) {
			SplitOpen();
			return;
		}

		var toslot:int = m_ToSlot;
		if (m_FromType == 1 && m_ToType == 2) {
			var planet:Planet = m_Map.GetPlanet(m_Map.m_FormPlanet.m_SectorX, m_Map.m_FormPlanet.m_SectorY, m_Map.m_FormPlanet.m_PlanetNum);
			if (planet != null) {
				if (planet.m_Item[m_FromSlot].m_Type == Common.ItemTypeMoney) toslot = -1;
			}
		}
		
		var ac:Action = new Action(m_Map);
		if (m_FromType == 1 || m_ToType == 1) ac.ActionItemMove(m_Map.m_FormPlanet.m_SectorX, m_Map.m_FormPlanet.m_SectorY, m_Map.m_FormPlanet.m_PlanetNum, m_FromType, m_FromSlot, m_ToType, toslot, cnt);
		else ac.ActionItemMove(0, 0, -1, m_FromType, m_FromSlot, m_ToType, toslot, cnt);
		m_Map.m_LogicAction.push(ac);
	}

	public function onMouseOut(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	public function Update():void
	{
		var tx:int, ty:int;
		graphics.clear();
		graphics.lineStyle(1.5, 0xffffff, 1.0, true);
		
		tx = stage.mouseX;
		ty = stage.mouseY;
		if (m_FromType == 1) {
			tx = m_Map.m_FormPlanet.GetItemSlotX(m_FromSlot);
			ty = m_Map.m_FormPlanet.GetItemSlotY(m_FromSlot);
		} else if(m_FromType == 2) {
			tx = m_Map.m_FormFleetItem.GetItemSlotX(m_FromSlot);
			ty = m_Map.m_FormFleetItem.GetItemSlotY(m_FromSlot);
		}
		graphics.moveTo(tx, ty);

		tx = stage.mouseX;
		ty = stage.mouseY;
		if (m_ToType == 1) {
			tx = m_Map.m_FormPlanet.GetItemSlotX(m_ToSlot);
			ty = m_Map.m_FormPlanet.GetItemSlotY(m_ToSlot);
		} else if(m_ToType == 2) {
			tx = m_Map.m_FormFleetItem.GetItemSlotX(m_ToSlot);
			ty = m_Map.m_FormFleetItem.GetItemSlotY(m_ToSlot);
		}
		graphics.lineTo(tx, ty);
	}

	public function SplitOpen():void
	{
		var it:uint = 0;
		var cnt:int = 0;
		if (m_FromType == 1) {
			var planet:Planet = m_Map.GetPlanet(m_Map.m_FormPlanet.m_SectorX, m_Map.m_FormPlanet.m_SectorY, m_Map.m_FormPlanet.m_PlanetNum);
			if (planet == null) return;
			it = planet.m_Item[m_FromSlot].m_Type;
			cnt = planet.m_Item[m_FromSlot].m_Cnt;
		} else if (m_FromType == 2) {
			it = m_Map.m_FormFleetItem.m_FleetItem[m_FromSlot].m_Type;
			cnt = m_Map.m_FormFleetItem.m_FleetItem[m_FromSlot].m_Cnt;
		} else if (m_FromType == 9) {
			it = m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot].m_Type;
			cnt = m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot].m_Cnt;
		} else return;
		
		if (cnt <= 0) return;
		if (it == 0) return;
		
		//m_Map.FormHideAll();

		m_Map.m_FormInput.Init();
		m_Map.m_FormInput.AddLabel(Common.Txt.FormSplitItemCaption + ": [clr]" + m_Map.Txt_ItemName(it & 0xffff)+"[/clr]",18);

		m_Map.m_FormInput.AddLabel(Common.Txt.Count+":");
		m_Map.m_FormInput.Col();
		var ti:TextInput = m_Map.m_FormInput.AddInput(cnt.toString(), 9, true);// .addEventListener(Event.CHANGE, DestroyEmpireChange);
		//ti.addEventListener(ComponentEvent.ENTER, SplitProcessEnter);
		ti.addEventListener(KeyboardEvent.KEY_DOWN, SplitProcessEnter);

		m_Map.m_FormInput.ColAlign();
		m_Map.m_FormInput.Run(SplitProcess, Common.Txt.FormSplitItemOk, Common.Txt.Cancel);

		ti.setFocus();
		ti.setSelection(0, ti.text.length);
	}
	
	public function SplitProcessEnter(e:KeyboardEvent):void
	{
		if (e.keyCode == 13) {
			e.stopImmediatePropagation();
			m_Map.m_FormInput.Hide();
			SplitProcess();
		}
	}

	public function SplitProcess():void
	{
		var cnt:int = m_Map.m_FormInput.GetInt(0);
		
		FinMove(false, cnt);

//		var ac:Action = new Action(m_Map);
//		if (m_FromType == 1 || m_ToType == 1) ac.ActionItemMove(m_Map.m_FormPlanet.m_SectorX, m_Map.m_FormPlanet.m_SectorY, m_Map.m_FormPlanet.m_PlanetNum, m_FromType, m_FromSlot, m_ToType, m_ToSlot, cnt);
//		else ac.ActionItemMove(0, 0, -1, m_FromType, m_FromSlot, m_ToType, m_ToSlot, cnt);
//		m_Map.m_LogicAction.push(ac);
	}
}

}
