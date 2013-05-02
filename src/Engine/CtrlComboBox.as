package Engine
{
import Base.*;
import flash.display.*;
import flash.events.*;
import flash.text.*;

public class CtrlComboBox extends Sprite
{
	[Embed(source = '/assets/stdwin/editbox_center_disable.png')] public var bmCenterDisable:Class;
	[Embed(source = '/assets/stdwin/editbox_center_normal.png')] public var bmCenterNormal:Class;
	[Embed(source = '/assets/stdwin/editbox_center_onmouse.png')] public var bmCenterOnmouse:Class;
	[Embed(source = '/assets/stdwin/editbox_center_onpress.png')] public var bmCenterOnpress:Class;
	[Embed(source = '/assets/stdwin/editbox_left_disable.png')] public var bmLeftDisable:Class;
	[Embed(source = '/assets/stdwin/editbox_left_normal.png')] public var bmLeftNormal:Class;
	[Embed(source = '/assets/stdwin/editbox_left_onmouse.png')] public var bmLeftOnmouse:Class;
	[Embed(source = '/assets/stdwin/editbox_left_onpress.png')] public var bmLeftOnpress:Class;
	[Embed(source = '/assets/stdwin/editbox_right_disable.png')] public var bmRightDisable:Class;
	[Embed(source = '/assets/stdwin/editbox_right_disable_but.png')] public var bmRightDisableBut:Class;
	[Embed(source = '/assets/stdwin/editbox_right_normal.png')] public var bmRightNormal:Class;
	[Embed(source = '/assets/stdwin/editbox_right_normal_but.png')] public var bmRightNormalBut:Class;
	[Embed(source = '/assets/stdwin/editbox_right_onmouse.png')] public var bmRightOnmouse:Class;
	[Embed(source = '/assets/stdwin/editbox_right_onmouse_but.png')] public var bmRightOnmouseBut:Class;
	[Embed(source = '/assets/stdwin/editbox_right_onpress.png')] public var bmRightOnpress:Class;
	[Embed(source = '/assets/stdwin/editbox_right_onpress_but.png')] public var bmRightOnpressBut:Class;

	private var m_LeftNormal:Sprite = new Sprite();
	private var m_CenterNormal:Sprite = new Sprite();
	private var m_RightNormal:Sprite = new Sprite();
	private var m_LeftOnmouse:Sprite = new Sprite();
	private var m_CenterOnmouse:Sprite = new Sprite();
	private var m_RightOnmouse:Sprite = new Sprite();
	private var m_LeftOnpress:Sprite = new Sprite();
	private var m_CenterOnpress:Sprite = new Sprite();
	private var m_RightOnpress:Sprite = new Sprite();
	private var m_LeftDisable:Sprite = new Sprite();
	private var m_CenterDisable:Sprite = new Sprite();
	private var m_RightDisable:Sprite = new Sprite();

	private var m_Input:TextField = null;

	private var m_LineMetric:TextLineMetrics = null;

	private var m_WidthMin:int = 50;
	private var m_WidthWish:int = 0;
	private var m_Width:int = 0;
	private var m_HeightMin:int = 34;// 1;
	private var m_HeightWish:int = 0;
	private var m_Height:int = 0;

	private var m_Disable:Boolean = false;
	private var m_MouseIn:Boolean = false;
	private var m_Down:Boolean = false;

	public var m_SkipMenu:Boolean = false;

	private var m_Top:int = 0;
	private var m_Bottom:int = 0;
	private var m_Left:int = 0;
	private var m_Right:int = 0;

	private var m_NeedBuild:Boolean = true;
	private var m_NeedUpdate:Boolean = true;
	
//	private var m_List:Vector.<CtrlComboBoxItem> = new Vector.<CtrlComboBoxItem>();
	private var m_Current:int = -1;
	
	private var m_PopupMenu:CtrlPopupMenu = null;
	
	private var m_Editable:Boolean = false;

	public function set widthMin(v:Number):void { if (v < 50) v = 50; if (m_WidthMin == v) return; m_WidthMin = v; m_NeedBuild = true; }
	public function get widthMin():Number { return m_WidthMin; }
	public function set heightMin(v:Number):void { if (v < 1) v = 1; if (m_HeightMin == v) return; m_HeightMin = v; m_NeedBuild = true; }
	public function get heightMin():Number { return m_HeightMin; }

	override public function set width(v:Number):void { if (m_WidthWish == v) return; m_WidthWish = v; m_NeedBuild = true; }
	override public function get width():Number	{ if (m_NeedBuild) Build(); return m_Width; }
	override public function set height(v:Number):void { if (m_HeightWish == v) return; m_HeightWish = v; m_NeedBuild = true; }
	override public function get height():Number { if (m_NeedBuild) Build(); return m_Height; }
	
	public function get menu():CtrlPopupMenu { return m_PopupMenu; }
	
	public function set editable(v:Boolean):void
	{
		if (m_Editable == v) return;
		m_Editable = v;
		
		if (m_Editable) {
			m_Input.type = TextFieldType.INPUT;
			m_Input.selectable = true;
		} else {
			m_Input.type = TextFieldType.DYNAMIC;
			m_Input.selectable = false;
		}
	}

	public function CtrlComboBox():void
	{
		m_PopupMenu = new CtrlPopupMenu();
		m_PopupMenu.parentCtrl = this;
		m_PopupMenu.addEventListener(Event.SELECT, PopuMmenuSelect);

		m_LeftNormal.mouseEnabled = false; addChild(m_LeftNormal);
		m_CenterNormal.mouseEnabled = false; addChild(m_CenterNormal);
		m_RightNormal.mouseEnabled = false; addChild(m_RightNormal);
		m_LeftOnmouse.mouseEnabled = false; addChild(m_LeftOnmouse);
		m_CenterOnmouse.mouseEnabled = false; addChild(m_CenterOnmouse);
		m_RightOnmouse.mouseEnabled = false; addChild(m_RightOnmouse);
		m_LeftOnpress.mouseEnabled = false; addChild(m_LeftOnpress);
		m_CenterOnpress.mouseEnabled = false; addChild(m_CenterOnpress);
		m_RightOnpress.mouseEnabled = false; addChild(m_RightOnpress);
		m_LeftDisable.mouseEnabled = false; addChild(m_LeftDisable);
		m_CenterDisable.mouseEnabled = false; addChild(m_CenterDisable);
		m_RightDisable.mouseEnabled = false; addChild(m_RightDisable);

		m_Input = new TextField();
		m_Input.width=1;
		m_Input.height=1;
		m_Input.type=TextFieldType.DYNAMIC;
		m_Input.selectable=false;
		m_Input.textColor = 0x000000;
		m_Input.background=false;
		m_Input.backgroundColor=0x80000000;
		m_Input.alpha=1.0;
		m_Input.multiline = false;
		m_Input.antiAliasType = AntiAliasType.ADVANCED;
		m_Input.autoSize=TextFieldAutoSize.NONE;
		m_Input.gridFitType=GridFitType.PIXEL;
		m_Input.defaultTextFormat=new TextFormat("Calibri",13,0x000000);
		m_Input.embedFonts = true;
		m_Input.visible = true;
		m_Input.text = "";
		addChild(m_Input);

        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(Event.DEACTIVATE, onDeactivate);
		addEventListener(Event.RENDER, onRender);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function getTotalFontHeight():Number
	{
		if (m_LineMetric != null) return (m_LineMetric.ascent + m_LineMetric.descent);
		var textField:TextField = new TextField();
		var textFormat:TextFormat;
		CONFIG::mobil {
			textFormat = new TextFormat(m_Input.fontFamily, m_Input.fontSize, null, (m_Input.fontWeight == FontWeight.BOLD), (m_Input.fontPosture == FontPosture.ITALIC));
		}
		CONFIG::mobiloff {
			textFormat = m_Input.defaultTextFormat;
		}
		textField.defaultTextFormat = textFormat;
		textField.text = "QQQjЁу";
		m_LineMetric = textField.getLineMetrics(0);
		return (m_LineMetric.ascent + m_LineMetric.descent);
	}
	
	private function onRender(event:Event):void
	{
		if (m_NeedBuild) Build();
		if (m_NeedUpdate) Update();
	}
	
	private function onEnterFrame(event:Event):void
	{
		if (m_NeedBuild) Build();
		if (m_NeedUpdate) Update();
	}
	
	private function Build():void
	{
		var i:int;
		var s:DisplayObject;
		var m:Sprite;

		m_Width = m_WidthWish;
		if (m_Width < m_WidthMin) m_Width = m_WidthMin;
		m_Height = m_HeightWish;
		//var minh:int = 8 + getTotalFontHeight() + 10;
		//if (m_Height < minh) m_Height = minh;
		if (m_Height < m_HeightMin) m_Height = m_HeightMin;
		//if (m_Height < 34) m_Height = 34;

		var but:Boolean = true;

		m_Top = (m_Height >> 1) - (34 >> 1);
		m_Bottom = m_Top + 34;
		m_Left = 0;
		m_Right = m_Width;

		// left_normal
		m_LeftNormal.removeChildren();
		s = new bmLeftNormal() as DisplayObject; 
		(s as Bitmap).smoothing = true;
		s.x = 0; s.y = m_Top;
		m_LeftNormal.addChild(s);

		// right_normal
		m_RightNormal.removeChildren();
		if(but) s = new bmRightNormalBut() as DisplayObject; 
		else s = new bmRightNormal() as DisplayObject; 
		(s as Bitmap).smoothing = true;
		s.x = m_Width-31; s.y = m_Top;
		m_RightNormal.addChild(s);

		// center_normal
		m_CenterNormal.removeChildren();
		for (i = 16; i < m_Width - 31; ) {
			s = new bmCenterNormal() as DisplayObject; (s as Bitmap).smoothing = true; m_CenterNormal.addChild(s);
			s.x = i;
			s.y = 0;
			if (s.width > ((m_Width - 31) - i)) {
				m = new Sprite(); m_CenterNormal.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, (m_Width - 31) - i, s.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		// left_onmouse
		m_LeftOnmouse.removeChildren();
		s = new bmLeftOnmouse() as DisplayObject; 
		(s as Bitmap).smoothing = true;
		s.x = 0; s.y = m_Top;
		m_LeftOnmouse.addChild(s);

		// right_onmouse
		m_RightOnmouse.removeChildren();
		if(but) s = new bmRightOnmouseBut() as DisplayObject; 
		else s = new bmRightOnmouse() as DisplayObject; 
		(s as Bitmap).smoothing = true;
		s.x = m_Width-31; s.y = m_Top;
		m_RightOnmouse.addChild(s);

		// center_onmouse
		m_CenterOnmouse.removeChildren();
		for (i = 16; i < m_Width - 31; ) {
			s = new bmCenterOnmouse() as DisplayObject; m_CenterOnmouse.addChild(s);
			(s as Bitmap).smoothing = true;
			s.x = i;
			s.y = 0;
			if (s.width > ((m_Width - 31) - i)) {
				m = new Sprite(); m_CenterOnmouse.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, (m_Width - 31) - i, s.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		// left_onpress
		m_LeftOnpress.removeChildren();
		s = new bmLeftOnpress() as DisplayObject; 
		(s as Bitmap).smoothing = true;
		s.x = 0; s.y = m_Top;
		m_LeftOnpress.addChild(s);

		// right_onpress
		m_RightOnpress.removeChildren();
		if(but) s = new bmRightOnpressBut() as DisplayObject; 
		else s = new bmRightOnpress() as DisplayObject; 
		(s as Bitmap).smoothing = true;
		s.x = m_Width-31; s.y = m_Top;
		m_RightOnpress.addChild(s);

		// center_onpress
		m_CenterOnpress.removeChildren();
		for (i = 16; i < m_Width - 31; ) {
			s = new bmCenterOnpress() as DisplayObject; m_CenterOnpress.addChild(s);
			(s as Bitmap).smoothing = true;
			s.x = i;
			s.y = 0;
			if (s.width > ((m_Width - 31) - i)) {
				m = new Sprite(); m_CenterOnpress.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, (m_Width - 31) - i, s.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		// left_disable
		m_LeftDisable.removeChildren();
		s = new bmLeftDisable() as DisplayObject; 
		(s as Bitmap).smoothing = true;
		s.x = 0; s.y = m_Top;
		m_LeftDisable.addChild(s);

		// right_disable
		m_RightDisable.removeChildren();
		if(but) s = new bmRightDisableBut() as DisplayObject; 
		else s = new bmRightDisable() as DisplayObject; 
		(s as Bitmap).smoothing = true;
		s.x = m_Width-31; s.y = m_Top;
		m_RightDisable.addChild(s);

		// center_disable
		m_CenterDisable.removeChildren();
		for (i = 16; i < m_Width - 31; ) {
			s = new bmCenterDisable() as DisplayObject; (s as Bitmap).smoothing = true; m_CenterDisable.addChild(s);
			s.x = i;
			s.y = 0;
			if (s.width > ((m_Width - 31) - i)) {
				m = new Sprite(); m_CenterDisable.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, (m_Width - 31) - i, s.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		m_Input.x = 12;
		m_Input.y = m_Top + 8;
		m_Input.width = m_Width - 12 - ((but)?32:12);
		m_Input.height = 34 - 8 - 7;
		
		PopupMenuBuild();

		m_NeedBuild = false;
		m_NeedUpdate = true;
	}

	private function Update():void
	{
		m_LeftDisable.visible = m_Disable;
		m_LeftNormal.visible = (!m_Disable) && (!m_MouseIn);
		m_LeftOnmouse.visible = (!m_Disable) && (m_MouseIn) && (!m_Down);
		m_LeftOnpress.visible = (!m_Disable) && (m_MouseIn) && (m_Down);
		
		m_CenterDisable.visible = m_LeftDisable.visible;
		m_CenterNormal.visible = m_LeftNormal.visible;
		m_CenterOnmouse.visible = m_LeftOnmouse.visible;
		m_CenterOnpress.visible = m_LeftOnpress.visible;
		
		m_RightDisable.visible = m_LeftDisable.visible;
		m_RightNormal.visible = m_LeftNormal.visible;
		m_RightOnmouse.visible = m_LeftOnmouse.visible;
		m_RightOnpress.visible = m_LeftOnpress.visible;

		m_NeedUpdate = false;
	}

	public function Restrict(maxlen:int, digit:Boolean = true, lang:int = 0, pun:Boolean = true, addchar:String = null):void
	{
		var re:String = "";
		if (digit) re += "0-9"; 
		if (pun) re += ".,;:!?()[]/#$%&*=\\+\\-\"";
		if (addchar != null) re += addchar;
		if (lang == Server.LANG_RUS) re += " 'A-Za-zА-Яа-яЁё";
		else if (lang == Server.LANG_ENG) re += " 'A-Za-z";

		m_Input.maxChars = maxlen;
		m_Input.restrict = re;
	}
	
	public function get text():String
	{
		return m_Input.text;
	}
	
	public function set text(v:String):void
	{
		if (v == null) m_Input.text = "";
		else m_Input.text = v;
	}
	
	public function get input():TextField
	{
		return m_Input;
	}

	private var m_MouseLock:Boolean = false;

	public function MouseLock():void
	{
		if (m_MouseLock) return;
		m_MouseLock = true;
		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,999);
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);

		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,999);
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 999);
	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		m_MouseLock = false;
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
	}

    protected function onMouseDown(event:MouseEvent):void
    {
		event.stopImmediatePropagation();

		if (m_Disable) { }
		//else if (mouseX >= (m_Right - 28) && mouseX < m_Right && mouseY >= m_Top && mouseY < m_Bottom) {
		else if(IsHitBut(event)) {
			if (stage.focus != m_Input) stage.focus = m_Input;

			m_MouseIn = true;
			m_Down = true;
			m_NeedUpdate = true;
			stage.invalidate();
			MouseLock();
			//Update();
		}
	}

    protected function onMouseUp(event:MouseEvent):void
    {
		event.stopImmediatePropagation();

		MouseUnlock();

		if (m_Down) {
			var skipm:Boolean = m_SkipMenu;

			m_Down = false;
			m_NeedUpdate = true;
			m_SkipMenu = false;
			stage.invalidate();
			//Update();

			if ((!m_Disable) && m_MouseIn && !skipm) {
//				if (m_PopupMenu != null) {
					if(m_PopupMenu.visible) m_PopupMenu.Hide();
					else {
						m_PopupMenu.CloseAll();
						m_PopupMenu.Show();
						if (m_Current >= 0) m_PopupMenu.current = m_Current;
					}
//				}
//				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
	}
	
	protected function onMouseMove(event:MouseEvent):void
	{
		if(!m_MouseLock) event.stopImmediatePropagation();
		
		if(m_Disable) {}
		else if (mouseX >= m_Left && mouseX < m_Right && mouseY >= m_Top && mouseY < m_Bottom) {
			if(!m_MouseIn) {
				m_MouseIn = true;
				m_NeedUpdate = true;
				stage.invalidate();
				//Update();
			}
		} else {
			if(m_MouseIn) {
				m_MouseIn = false;
				m_NeedUpdate = true;
				stage.invalidate();
				//Update();
			}
		}
	}
	
	protected function onMouseOut(event:MouseEvent):void
	{
//trace(event.target, event.currentTarget, event.relatedObject);
		if (event.target == m_Input && event.relatedObject == this) return;
		if (event.target == this && event.relatedObject == m_Input) return;
		if (!m_Disable && m_MouseIn) {
			m_MouseIn = false;
			m_NeedUpdate = true;
			stage.invalidate();
			//Update();
		}
	}
	
	private function onDeactivate(event:Event):void
	{
		MouseUnlock();
		if (m_MouseIn || m_Down) {
			m_MouseIn = false;
			m_Down = false;
			m_SkipMenu = false;
			m_NeedUpdate = true;
			stage.invalidate();
			//Update();
		}
	}
	
	public function get ItemCnt():int { return m_PopupMenu.ItemCnt; }
	
	public function ItemText(i:int):String { return m_PopupMenu.ItemText(i); }
//	{
//		if (i<0 || i>=m_List.length) return null;
//		return m_List[i].m_Text;
//	}
	
	public function ItemData(i:int):* { return m_PopupMenu.ItemData(i); }
//	{
//		if (i<0 || i>=m_List.length) return null;
//		return m_List[i].m_Data;
	//}

	public function ItemClear():void
	{
		//m_List.length = 0;
		m_PopupMenu.ItemClear();
		m_Current = -1;

		m_NeedBuild = true;
	}

	public function ItemDelete(i:int):void
	{
		m_PopupMenu.ItemDelete(i);
//		if (i<0 || i>=m_List.length) return;
//		m_List.splice(i, 1);
		
		if (m_Current > i) m_Current--;
		if (m_Current >= ItemCnt) m_Current = ItemCnt - 1;
		if (m_Current < -1) m_Current = -1;

		m_NeedBuild = true;
	}

	public function ItemAdd(text:String, data:Object = null, lvl:int = 0):void
	{
		m_PopupMenu.ItemAdd(text, data, lvl);
//		var itm:CtrlComboBoxItem = new CtrlComboBoxItem();
//		itm.m_Text = text;
//		itm.m_Data = data;
//		itm.m_Lvl = lvl;
//		m_List.push(itm);

		m_NeedBuild = true;
	}
	
	public function IsHitBut(e:MouseEvent):Boolean
	{
		var o:DisplayObject = null;
		if ((e.target != null) && (e.target is DisplayObject)) {
			o = e.target as DisplayObject;
			while (o != null) {
				if (o == this) break;
				o = o.parent;
			}
		}
		if (o == null) return false;
		
		if(m_Editable) {
			return (mouseX >= (m_Right - 28) && mouseX < m_Right && mouseY >= m_Top && mouseY < m_Bottom);
		} else {
			return (mouseX >= m_Left && mouseX < m_Right && mouseY >= m_Top && mouseY < m_Bottom);
		}
	}

	private function PopupMenuBuild():void
	{
		m_PopupMenu.width = m_Width;

/*		if (m_List.length <= 0) {
			if (m_PopupMenu != null) {
				m_PopupMenu.Hide();
				m_PopupMenu.ItemClear();
				m_PopupMenu = null;
			}
			return;
		}

		if (m_PopupMenu == null) {
			m_PopupMenu = new CtrlPopupMenu();
			//m_PopupMenu.height = 250;
			m_PopupMenu.parentCtrl = this;
			m_PopupMenu.addEventListener(Event.SELECT, PopuMmenuSelect);
		}
		m_PopupMenu.width = m_Width;
		m_PopupMenu.ItemClear();
		var i:int;
		for (i = 0; i < m_List.length; i++) {
			m_PopupMenu.ItemAdd(m_List[i].m_Text, m_List[i], m_List[i].m_Lvl);
		}*/
	}
	
	private function PopuMmenuSelect(event:Event):void
	{
		if (m_PopupMenu == null) return;
		//if (current == m_PopupMenu.current) return;
		current = m_PopupMenu.current;
		dispatchEvent(new Event(Event.CHANGE));
	}

	public function get current():int { if (m_Current<0 || m_Current>=m_PopupMenu.ItemCnt) return -1; return m_Current; }
	public function set current(v:int):void
	{
		//if (current == v) return;
		if (v<0 || v>=m_PopupMenu.ItemCnt) m_Current=-1;
		else m_Current = v;

		m_Input.htmlText = BaseStr.FormatTag(ItemText(m_Current),true,true);
	}

/*	public function get current():int { if (m_Current<0 || m_Current>=m_List.length) return -1; return m_Current; }
	public function set current(v:int):void
	{
		if (current == v) return;
		if (v<0 || v>=m_List.length) m_Current=-1;
		else m_Current = v;
		
		var itm:CtrlComboBoxItem = m_List[m_Current];

		m_Input.htmlText = BaseStr.FormatTag(itm.m_Text, true, true);
	}*/
 

}

}

//class CtrlComboBoxItem
//{
//	public var m_Text:String;
//	public var m_Data:Object;
//	public var m_Lvl:int = 0;
//	
//	public function CtrlComboBoxItem():void
//	{
//	}
//}
