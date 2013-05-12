// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import Base.*;
import flash.display.DisplayObject;
import flash.events.*;
import flash.text.TextField;

public class FormInputEx extends FormStd
{
	public var m_SoftLock:Boolean = false;
	public var m_ColCnt:int = 100; // Максимальное кол-во колонок
	public var m_ColX:int = 0;
	public var m_LastItem:int = -1;
	
	public var m_ButOk:CtrlBut = null;
	public var m_ButCancel:CtrlBut = null;
	
	public var m_Fun:Function = null;
	public var m_FunCancel:Function = null;
	
	public function set softLock(v:Boolean):void { m_SoftLock = v; }
	
	public function FormInputEx()
	{
		super(true, false);

		scale = StdMap.Main.m_Scale;

		m_ButOk = new CtrlBut();
		m_ButOk.addEventListener(MouseEvent.CLICK, clickOk);

		m_ButCancel = new CtrlBut();
		m_ButCancel.addEventListener(MouseEvent.CLICK, clickCancel);

		addEventListener("close", eClose);
		addEventListener("page", onPageChange);
	}
	
	public override function Hide():void
	{
		if (m_ColorPickerInput != null) {
			m_ColorPickerInput = null;
			StdMap.Main.m_FormInputColor.Hide();
		}
		super.Hide();
	}
	
	public function onPageChange(e:Event):void
	{
		if (m_ColorPickerInput != null) {
			m_ColorPickerInput = null;
			StdMap.Main.m_FormInputColor.Hide();
		}
	}
	
	public function Init(w:int = 480/*360*/, h:int = 300, colcnt:int = 100):void
	{
		var i:int;

		Hide();

		m_SoftLock = false;

		m_ButOk.visible = true;
		m_ButCancel.visible = true;
		m_ButCancel.disable = false;
		m_ButOk.disable = false;
		pageWidthMin = 50;
		contentSpaceLeft = 0;
		contentSpaceTop = 0;
		contentSpaceRight = 0;
		contentSpaceBottom = 0;

		CtrlClear();
		ItemClear();
		GridClear();
		PageClear();
		TabClear();
		m_LastItem = -1;
		m_ColCnt = colcnt; if (m_ColCnt < 1) m_ColCnt = 1;
		
		CtrlAdd(m_ButOk);
		CtrlAdd(m_ButCancel);

		width = w;
		height = h;

		//var colw:int = contentWidth / m_ColCnt;

		GridAdd();
		//for (i = 0; i < m_ColCnt; i++) SetColSize(0, i, colw);
	}
	
	public function FinItem(colcnt:int = 0):void
	{
		if (m_LastItem < 0) return;

		if (colcnt <= 0) {
			if (m_ColCnt - m_ColX > 1) {
				ItemCellCnt(m_LastItem, m_ColCnt - m_ColX);
			}
			LocNextRow();
		} else {
			ItemCellCnt(m_LastItem, colcnt);
			LocNextCol(m_ColX + colcnt);
		}

		m_LastItem = -1;
	}
	
	public function Col(no:int = 1):void
	{
		FinItem(no);
	}
	
	public function SetUserData(v:*):void
	{
		ItemUserDataSet(m_LastItem, v);
	}
	
	public function AddLabel(txt:String, wordwrap:Boolean = false, fsize:int = 13, clr:uint = 0x000000):TextField
	{
		FinItem();
		m_ColX = LocCallX;
		m_LastItem = ItemLabel(txt, wordwrap, fsize, clr);
		ItemAlign(m_LastItem, 100, 0);
		return ItemObj(m_LastItem) as TextField;
	}
	
	public function AddLabelIdent(txt:String, wordwrap:Boolean = false, fsize:int = 13, clr:uint = 0x000000):TextField
	{
		FinItem();
		m_ColX = LocCallX;
		m_LastItem = ItemLabelIndent(txt, wordwrap, fsize, clr);
		ItemAlign(m_LastItem, 100, 0);
		return ItemObj(m_LastItem) as TextField;
	}

	public function AddCheckBox(v:Boolean, txt:String):CtrlCheckBox
	{
		FinItem();
		m_ColX = LocCallX;
		m_LastItem = ItemCheckBox(txt);
		ItemAlign(m_LastItem, 100, 0);
		var ccb:CtrlCheckBox = ItemObj(m_LastItem) as CtrlCheckBox;
		ccb.check = v;
		return ccb;
	}

	public function AddCode(txt:String, maxlen:int, digit:Boolean = true, lang:int = 0, pun:Boolean = true, addchar:String = null):CtrlInput
	{
		FinItem();
		m_ColX = LocCallX;
		m_LastItem = ItemCode(txt, maxlen, digit, lang, pun, addchar);
		return ItemObj(m_LastItem) as CtrlInput;
	}

	public function AddInput(txt:String, maxlen:int, digit:Boolean = true, lang:int = 0, pun:Boolean = true, addchar:String = null):CtrlInput
	{
		FinItem();
		m_ColX = LocCallX;
		m_LastItem = ItemInput(txt, maxlen, digit, lang, pun, addchar);
		return ItemObj(m_LastItem) as CtrlInput;
	}
	
	public function AddBut(txt:String):CtrlBut
	{
		FinItem();
		m_ColX = LocCallX;
		m_LastItem = ItemBut(txt);
		return ItemObj(m_LastItem) as CtrlBut;
	}

	public var m_ColorPickerInput:CtrlInput = null;
	
	public function AddColorPicker(clr:uint):CtrlInput
	{
		FinItem();
		m_ColX = LocCallX;
		m_LastItem = ItemInput(BaseStr.FormatColor(clr), 8, true, 0, false, "A-Fa-f");
		
		var cp:CtrlInput = ItemObj(m_LastItem) as CtrlInput;
		
		cp.addEventListener(Event.CHANGE, ChangeColorPicker);
		cp.addEventListener(FocusEvent.FOCUS_IN, RunColorPicker);
		cp.addEventListener(MouseEvent.CLICK, RunColorPicker);
		//сз.addEventListener(FocusEvent.FOCUS_OUT, CloseColorPicker);

		return cp;
	}
	
	public function CloseColorPicker(e:Event):void
	{
		if (e.currentTarget != m_ColorPickerInput) return;
		StdMap.Main.m_FormInputColor.Hide();
		m_ColorPickerInput = null;
	}

	public function RunColorPicker(e:Event):void
	{
		if (m_ColorPickerInput == e.currentTarget) return;
		m_ColorPickerInput = e.currentTarget as CtrlInput;
		StdMap.Main.m_FormInputColor.Run(uint("0x" + m_ColorPickerInput.text), BackColorPicker);
	}

	public function ChangeColorPicker(e:Event):void
	{
		if (e.currentTarget != m_ColorPickerInput) return;
//		if (e.currentTarget is CtrlInput) return;
		StdMap.Main.m_FormInputColor.SetColor(uint("0x" + m_ColorPickerInput.text));
	}

	public function BackColorPicker():void
	{
		if (m_ColorPickerInput == null) return;
		m_ColorPickerInput.text = BaseStr.FormatColor(StdMap.Main.m_FormInputColor.GetColor());
		m_ColorPickerInput.dispatchEvent(new Event(Event.CHANGE));
	}
	
	public function AddComboBox():CtrlComboBox
	{
		FinItem();
		m_ColX = LocCallX;
		m_LastItem = ItemComboBox();
		return ItemObj(m_LastItem) as CtrlComboBox;
	}

	public function AddItem(txt:String, val:Object, sel:Boolean = false):void
	{
		var obj:DisplayObject = ItemObj(m_LastItem);
		if (obj is CtrlComboBox) {
			var cb:CtrlComboBox = obj as CtrlComboBox;
			cb.ItemAdd(txt, val);
			if (sel) cb.current = cb.ItemCnt - 1;
		} else throw Error("");
	}

	public function AddItemEx(txt:String, val:Object, lvl:int, sel:Boolean = false):void
	{
		var obj:DisplayObject = ItemObj(m_LastItem);
		if (obj is CtrlComboBox) {
			var cb:CtrlComboBox = obj as CtrlComboBox;
			cb.ItemAdd(txt, val, lvl);
			if (sel) cb.current = cb.ItemCnt - 1;
		} else throw Error("");
	}

	public function GetInput(no:int):DisplayObject
	{
		var obj:DisplayObject;
		var i:int;
		for (i = 0; i < ItemCnt; i++) {
			obj = ItemObj(i);
			if (obj == null) continue;

			if ((obj is CtrlComboBox) || (obj is CtrlInput) || (obj is CtrlCheckBox)) {
				no--;
				if (no == -1) return obj;
			}
		}
		return null;
	}
	
	public function GetStr(no:int):String
	{
		var obj:DisplayObject = GetInput(no);
		if (obj == null) return "";

		if (obj is CtrlComboBox) {
			var cb:CtrlComboBox = obj as CtrlComboBox;
			if (cb.current < 0) return "";
			return cb.ItemData(cb.current).toString();
		} else if (obj is CtrlInput) {
			var ci:CtrlInput = obj as CtrlInput;
			return ci.text;
		} else if (obj is CtrlCheckBox) {
			var ccb:CtrlCheckBox = obj as CtrlCheckBox;
			return ccb.check?"1":"0";
		}
		
		return "";
	}
	
	public function GetInt(no:int):int
	{
		return int(GetStr(no));
	}
	
	public function Run(fun:Function = null, txtok:String = null, txtcancel:String = null, funcancel:Function = null):void
	{
		FinItem();

		if (txtcancel == null) m_ButCancel.caption = StdMap.Txt.ButClose.toUpperCase();
		else m_ButCancel.caption = txtcancel.toUpperCase();
		
		if (txtcancel == null && funcancel == null) {
			closeDisable = true;
			m_ButCancel.visible = false;
		} else {
			closeDisable = false;
			m_ButCancel.visible = true;
			if (txtcancel == null) m_ButCancel.caption = StdMap.Txt.ButCancel.toUpperCase();
			else m_ButCancel.caption = txtcancel.toUpperCase();
		}

		if (txtok == null && fun == null) {
			m_ButOk.visible = false;
		} else {
			m_ButOk.visible = true;
			if (txtok == null) m_ButOk.caption = StdMap.Txt.ButSave.toUpperCase();
			else m_ButOk.caption = txtok.toUpperCase();
		}
		
		var csp:int = 0;
		var tx:int = contentX + contentWidth;
		if(m_ButCancel.visible) {
			tx -= m_ButCancel.width;
			m_ButCancel.x = tx;
			m_ButCancel.y = height - innerBottom - m_ButCancel.height;
			if (m_ButCancel.height > csp) csp = m_ButCancel.height;
		}

		if (m_ButOk.visible) {
			tx -= m_ButOk.width;
			m_ButOk.x = tx;
			m_ButOk.y = height - innerBottom - m_ButOk.height;
			if (m_ButOk.height > csp) csp = m_ButOk.height;
		}

		if (csp) {
			contentSpaceBottom = csp + 10;
		}

		m_Fun = fun;
		m_FunCancel = funcancel;

		Show();
	}
	
	public function clickCancel(event:Event):void
	{
		Hide();
		if (m_FunCancel != null) m_FunCancel();
	}
	
	public function eClose(event:Event):void
	{
		if (m_FunCancel != null) m_FunCancel();
	}

	public function clickOk(event:Event):void
	{
		if (FormMessageBox.Self.visible) return;
		Hide();
		if (m_Fun != null) m_Fun();
	}
}

}