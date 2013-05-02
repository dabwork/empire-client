package Engine
{
import Base.*;
import flash.display.*;
import flash.events.*;
import flash.geom.Point;
import flash.text.*;

public class CtrlPopupMenu extends Sprite
{
	[Embed(source = '/assets/stdwin/menu_right.png')] public var bmRight:Class;
	[Embed(source = '/assets/stdwin/menu_down.png')] public var bmDown:Class;
	[Embed(source = '/assets/stdwin/menu_check.png')] public var bmCheck:Class;

	private var m_Frame:CtrlFrame = new CtrlFrame();
	private var m_Scroll:CtrlScrollBar = new CtrlScrollBar();
	private var m_CurrentItem:Sprite = new Sprite();
	private var m_LayerItem:Sprite = new Sprite();
	private var m_MaskItem:Sprite = new Sprite();

	private var m_WidthMin:int = 32;
	private var m_WidthWish:int = 0;
	private var m_Width:int = 0;
	private var m_HeightWish:int = 250;
	private var m_Height:int = 0;
	
	private var m_NeedBuild:Boolean = true;
	private var m_NeedUpdate:Boolean = true;
	
	private var m_ParentCtrl:DisplayObject = null;
	private var m_PlaceX:int = 0;
	private var m_PlaceY:int = 0;
	private var m_PlaceWidth:int = 0;
	private var m_PlaceHeight:int = 0;

	private var m_List:Vector.<CtrlPopupMenuItem> = new Vector.<CtrlPopupMenuItem>();
	private var m_Current:int = -1;
	
	private var m_ShowCnt:int = 0;
	private var m_ViewItemCnt:int = 0;
	private var m_CellSize:int = 0;
	private var m_CellWidth:int = 0;
	private var m_Bar:Boolean = false;
	
	private var m_MouseDown:int = 0;
	
	private var m_ScrollToCurrent:int = 0; // 0-off 1-center

	public function set widthMin(v:Number):void { if (v < 32) v = 32; if (m_WidthMin == v) return; m_WidthMin = v; m_NeedBuild = true; }
	override public function set width(v:Number):void { if (m_WidthWish == v) return; m_WidthWish = v; m_NeedBuild = true; }
	override public function get width():Number	{ if (m_NeedBuild) Build(); return m_Width; }
	override public function set height(v:Number):void { if (m_HeightWish == v) return; m_HeightWish = v; m_NeedBuild = true; }
	override public function get height():Number { if (m_NeedBuild) Build(); return m_Height; }

	public function set parentCtrl(v:DisplayObject):void { if (m_ParentCtrl == v) return; m_ParentCtrl = v; m_NeedUpdate = true; }
	
	public function get current():int { return m_Current; }
	public function set current(v:int):void {
		if (v < 0) v = -1;
		else if (v >= m_List.length) v = m_List.length - 1;
		if (v >= 0) {
			m_ScrollToCurrent = 1;
			m_NeedUpdate = true;
		}
		//if (m_Current == v) return;
		m_Current = v;
	}

	public function CtrlPopupMenu():void
	{
		visible = false;

		addChild(m_Frame);
		
		m_Scroll.style = CtrlScrollBar.StylePopupMenu;
		m_Scroll.addEventListener(Event.CHANGE, ScrollChange);
		addChild(m_Scroll);

		addChild(m_LayerItem);
		m_LayerItem.addChild(m_CurrentItem);
		addChild(m_MaskItem);
		
		m_LayerItem.mask = m_MaskItem;

		addEventListener(Event.RENDER, onRender);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		removeEventListener(Event.DEACTIVATE, onDeactivate);
	}

	public function Show():void
	{
		if (visible) return;
		visible = true;
		m_NeedBuild = true;
		m_NeedUpdate = true;
		StdMap.Main.addChild(this);
		StdMap.Main.m_PopupMenu = this;

		m_MouseDown = 0;

//		FormStd.m_ModalList.push(this);

//		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
//		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
//		addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);

//		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseModal, false,888);
//		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseModal, true,888);
//		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseModal, false,888);
//		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseModal, true,888);
//		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseModal, false,888);
//		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseModal, true,888);
//		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, false,888);
//		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, true, 888);
//		stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp,false,888);
//		stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp,true,888);
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 8888);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 8888);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 8888);
		stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 8888);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 8888);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, false, 8888);

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true, 8888);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true, 8888);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 8888);
		stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, true, 8888);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, true, 8888);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, true, 8888);

		stage.focus = null;
	}

	public function beforeHide(list:DisplayObjectContainer):void
	{
		var i:int;
		var d:DisplayObject;
		for (i = list.numChildren - 1; i >= 0; i--) {
			d = list.getChildAt(i);
			if (d is CtrlStd) CtrlStd(d).beforeHide();
			else if (d is DisplayObjectContainer) beforeHide(DisplayObjectContainer(d));
		}
	}

	public function Hide():void
	{
		if (!visible) return;
		
		beforeHide(this);
//		dispatchEvent(new Event("beforeHide"));

		MouseUnlock();
		visible = false;
		
		//var i:int = FormStd.m_ModalList.indexOf(this);
		//if (i >= 0) FormStd.m_ModalList.splice(i, 1);

//		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//		removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
//		removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
//		removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);

//		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseModal, false);
//		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseModal, true);
//		stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseModal, false);
//		stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseModal, true);
//		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseModal, false);
//		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseModal, true);
//		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, false);
//		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, true);

		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		stage.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false);
		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false);
		stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, false);

		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
		stage.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, true);
		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, true);
		stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, true);
		
		StdMap.Main.removeChild(this);
		StdMap.Main.m_PopupMenu = null;
	}
	
	private var m_MouseLock:Boolean = false;

	public function MouseLock():void
	{
		if (m_MouseLock) return;
		m_MouseLock = true;
//		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,999);
//		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 999);
//		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);

//		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,999);
//		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true,999);
//		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 999);
	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		m_MouseLock = false;
//		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
//		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
//		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);

//		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
//		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
//		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
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
		var i:int, u:int, lvl:int;
		var itm:CtrlPopupMenuItem, itm2:CtrlPopupMenuItem;
		var sw:CtrlPopupMenuSwitch;
		var s:DisplayObject;
		var st:DisplayObject, sb:DisplayObject;
		var m:Sprite;

		if(m_ScrollToCurrent) OpenForView(m_Current);

		var sizex:int = 0;
		var sizey:int = 0;
		m_CellSize = 1;
		m_ShowCnt = 0;
		var spacechild:Boolean = false;
		var cheak:Boolean = false;
		for (i = 0; i < m_List.length; i++) {
			itm = m_List[i];
			
			if (itm.m_Text == "-") {
				itm.m_Show = false; continue;
			}
			
			if (itm.m_TF == null) {
				itm.m_TF = new flash.text.TextField();
				itm.m_TF.width = 1;
				itm.m_TF.height = 1;
				itm.m_TF.type = TextFieldType.DYNAMIC;
				itm.m_TF.textColor = 0x000000;
				itm.m_TF.background = false;
				itm.m_TF.multiline = false;
				itm.m_TF.antiAliasType = AntiAliasType.ADVANCED;
				itm.m_TF.autoSize = TextFieldAutoSize.LEFT;
				itm.m_TF.gridFitType = GridFitType.PIXEL;
				itm.m_TF.defaultTextFormat = new TextFormat("Calibri", 13, 0x000000);
				itm.m_TF.embedFonts = true;
				itm.m_TF.selectable = false;
				itm.m_TF.visible = true;
				m_LayerItem.addChild(itm.m_TF);
			}
			
			if (IsExistChild(i)) {
				if (itm.m_Lvl == 0) spacechild = true;
				if (!itm.m_IconOpen) {
					itm.m_IconOpen = new bmDown() as DisplayObject;
					itm.m_IconOpen.alpha = 0.8;
					m_LayerItem.addChild(itm.m_IconOpen);
				}
				if (!itm.m_IconClose) {
					itm.m_IconClose = new bmRight() as DisplayObject;
					itm.m_IconClose.alpha = 0.8;
					m_LayerItem.addChild(itm.m_IconClose);
				}
			} else {
				if (itm.m_IconOpen) {
					m_LayerItem.removeChild(itm.m_IconOpen);
					itm.m_IconOpen = null;
				}
				if (itm.m_IconClose) {
					m_LayerItem.removeChild(itm.m_IconClose);
					itm.m_IconClose = null;
				}
			}
			
			if (itm.m_Check != undefined) {
				cheak = true;
			}
			if (itm.m_Check) {
				if (!itm.m_IconCheck) {
					itm.m_IconCheck = new bmCheck() as DisplayObject;
					itm.m_IconCheck.alpha = 0.8;
					m_LayerItem.addChild(itm.m_IconCheck);
				}
			} else {
				if (itm.m_IconCheck) {
					m_LayerItem.removeChild(itm.m_IconCheck);
					itm.m_IconCheck = null;
				}
			}

			lvl = itm.m_Lvl;
			itm.m_Show = true;
			for (u = i - 1; u >= 0; u--) {
				itm2 = m_List[u];
				if (itm2.m_Lvl >= lvl) continue;
				lvl = itm2.m_Lvl;
				//if (itm2.m_Vis) continue;
				if (itm2.m_Open) continue;
				itm.m_Show = false;
				break;
			}
			
			if (itm.m_Show) m_ShowCnt++;
			
			var ttx:int = itm.m_Lvl * 20;
			
			if(itm.m_Switch) {
				for (u = 0; u < itm.m_Switch.length; u++) {
					sw = itm.m_Switch[u];
					if (sw.m_TF == null) {
						sw.m_TF = new flash.text.TextField();
						sw.m_TF.width = 1;
						sw.m_TF.height = 1;
						sw.m_TF.type = TextFieldType.DYNAMIC;
						sw.m_TF.textColor = 0xb1b076;// 0xe58e47;
						sw.m_TF.background = true;
						sw.m_TF.multiline = false;
						sw.m_TF.antiAliasType = AntiAliasType.ADVANCED;
						sw.m_TF.autoSize = TextFieldAutoSize.LEFT;
						sw.m_TF.gridFitType = GridFitType.PIXEL;
						sw.m_TF.defaultTextFormat = new TextFormat("Calibri", 12, 0x000000);
						sw.m_TF.embedFonts = true;
						sw.m_TF.selectable = false;
						sw.m_TF.visible = true;
						m_LayerItem.addChild(sw.m_TF);
					}
					sw.m_TF.htmlText = BaseStr.FormatTag(sw.m_Text);
					sw.m_TF.width;
					sw.m_TF.height;
					m_CellSize = Math.max(m_CellSize, sw.m_TF.height);
					ttx += sw.m_TF.width + 2;
				}
				ttx += 5;
			}

			itm.m_TF.htmlText = BaseStr.FormatTag(itm.m_Text);
			itm.m_TF.width;
			itm.m_TF.height;
			itm.m_TF.x = 0;
			m_CellSize = Math.max(m_CellSize, itm.m_TF.height + 4);
			itm.m_TF.y = sizey + 2;
			ttx += itm.m_TF.width;
			sizex = Math.max(sizex, ttx);
		}
		if (spacechild) sizex += 20;
		if (cheak) sizex += 20;

		sizey = 0;
		for (i = 0; i < m_List.length; i++) {
			itm = m_List[i];
			if (itm.m_Show) {
				itm.m_TF.visible = true;
				itm.m_Y = sizey;
				
				ttx = 0;
				if (cheak) {
					if (itm.m_IconCheck) {
						itm.m_IconCheck.visible = itm.m_Check;
						itm.m_IconCheck.x = ttx + 10 - (itm.m_IconCheck.width >> 1);
						itm.m_IconCheck.y = sizey + (m_CellSize >> 1) - (itm.m_IconCheck.height >> 1);
					}
					ttx += 20;
				}
				
				ttx += itm.m_Lvl * 20;
				if (itm.m_IconOpen && itm.m_IconClose) {
					itm.m_IconOpen.visible = itm.m_Open;
					itm.m_IconOpen.x = ttx + 10 - (itm.m_IconOpen.width >> 1);
					itm.m_IconOpen.y = sizey + (m_CellSize >> 1) - (itm.m_IconOpen.height >> 1);
					itm.m_IconClose.visible = !itm.m_Open;
					itm.m_IconClose.x = ttx + 10 - (itm.m_IconClose.width >> 1);
					itm.m_IconClose.y = sizey + (m_CellSize >> 1) - (itm.m_IconClose.height >> 1);
				}
				ttx += (spacechild?20:0);
				
				itm.m_X = ttx;

				if (itm.m_Switch) {
					for (u = 0; u < itm.m_Switch.length; u++) {
						sw = itm.m_Switch[u];
						if (sw.m_TF == null) continue;
						sw.m_TF.visible = true;
						sw.m_TF.x = ttx;
						sw.m_TF.y = sizey + (m_CellSize >> 1) - (sw.m_TF.height >> 1)+1;
						ttx += sw.m_TF.width + 2;

						if (sw.m_On) sw.m_TF.backgroundColor = 0xe58e47;
						else sw.m_TF.backgroundColor = 0xb1b076;
					}
				}

				itm.m_TF.x = ttx;
				itm.m_TF.y = sizey + 2;

				sizey += m_CellSize;
			} else {
				if (itm.m_TF) itm.m_TF.visible = false;
				if (itm.m_IconOpen) itm.m_IconOpen.visible = false;
				if (itm.m_IconClose) itm.m_IconClose.visible = false;
				if (itm.m_IconCheck) itm.m_IconCheck.visible = false;
				if (itm.m_Switch)
				for (u = 0; u < itm.m_Switch.length; u++) {
					sw = itm.m_Switch[u];
					if (sw.m_TF) sw.m_TF.visible = false;
				}
			}
		}

		var captop:int = 10;
		var capbottom:int = 10;
		var capleft:int = 10;

		m_LayerItem.x = 10;
		m_LayerItem.y = captop;

		sizey += captop + capbottom;

		m_Height = m_HeightWish;
		if (m_Height > sizey) m_Height = sizey;
		if (m_Height < 50) m_Height = 50;
		m_ViewItemCnt = Math.floor((m_Height - captop - capbottom) / m_CellSize);
		if (m_ViewItemCnt < 0) m_ViewItemCnt = 1;
		m_Height = m_ViewItemCnt * m_CellSize + captop + capbottom;

		var capright:int = 10;
		m_Bar = false;
		if (m_ViewItemCnt < m_ShowCnt) {
			capright = 31;
			m_Bar = true;
		}

		sizex += capleft + capright;

		m_Width = m_WidthWish;
		if (m_Width < m_WidthMin) m_Width = m_WidthMin;
		if (m_Width < sizex) m_Width = sizex;

		m_Frame.width = m_Width;
		m_Frame.height = m_Height;

		if (m_Bar) {
			m_Scroll.x = m_Width - m_Scroll.width - 6;
			m_Scroll.y = 6;
			m_Scroll.height = m_Height - 6 - 6;
			m_Scroll.setRange(0, m_ShowCnt, 1, m_ViewItemCnt);
			m_Scroll.position = m_Scroll.position;
			m_Scroll.Show();
		} else {
			m_Scroll.Hide();
			m_Scroll.position = 0;
		}

		m_CellWidth = m_Width - capleft - capright + 2;
		if (m_Bar) m_CellWidth += 2;

		for (i = 0; i < m_List.length; i++) {
			itm = m_List[i];
			if (!itm.m_Show) continue;

			if (itm.m_Line == null) {
				itm.m_Line = new Sprite();
				m_LayerItem.addChild(itm.m_Line);
			}
			var fl:Boolean = false;
			for (u = i + 1; u < m_List.length; u++) {
				itm2 = m_List[u];
				if (itm2.m_Show) break;
				if (itm2.m_Text == "-") { fl = true; break; }
			}
			itm.m_Line.graphics.clear();
			if (fl) itm.m_Line.graphics.beginFill(0, 1);
			else itm.m_Line.graphics.beginBitmapFill(CtrlFrame.ImgDots, null, true, false);
			itm.m_Line.graphics.drawRect(0, 0, m_CellWidth, 1);
			itm.m_Line.graphics.endFill();
			itm.m_Line.x = 0;
			itm.m_Line.y = itm.m_Y + m_CellSize;
		}

		m_MaskItem.graphics.clear();
		m_MaskItem.graphics.beginFill(0xffffff);
		m_MaskItem.graphics.drawRect(capleft, captop, m_CellWidth, m_Height - captop - capbottom);
		m_MaskItem.graphics.endFill();

		m_CurrentItem.graphics.clear();
		m_CurrentItem.graphics.beginFill(0xbcbb87, 0.7);
		m_CurrentItem.graphics.drawRect(0, 0, m_CellWidth, m_CellSize);
		m_CurrentItem.graphics.endFill();

		m_NeedBuild = false;
		m_NeedUpdate = true;
	}
	
	public function Place(x:int, y:int, w:int = 0, h:int = 0):void
	{
		m_PlaceX = x;
		m_PlaceY = y;
		m_PlaceWidth = w;
		m_PlaceHeight = h;
	}

	private function Update():void
	{
		m_NeedUpdate = false;
		
		var p:Point;

		if (m_ParentCtrl != null && (m_ParentCtrl is CtrlComboBox)) {
			var cb:CtrlComboBox = m_ParentCtrl as CtrlComboBox;
			p = cb.localToGlobal(new Point(0, 0));
			x = p.x + cb.width - width;
			y = p.y + cb.height - 7;
			if (y + height > StdMap.Main.stage.stageHeight) {
				y = p.y - height + 7;
			}
//if(cb.stage != null) trace("CtrlPopupMenu.Update", cb.stage.x, cb.stage.y);
		} else if (m_ParentCtrl != null && (m_ParentCtrl is CtrlBut)) {
			var cbut:CtrlBut = m_ParentCtrl as CtrlBut;
			p = cbut.localToGlobal(new Point(0, 0));
			x = p.x + cbut.width - width;
			y = p.y + cbut.height - 7;
			if (y + height > StdMap.Main.stage.stageHeight) {
				y = p.y - height + 7;
			}
		} else if (m_ParentCtrl == null) {
			x = m_PlaceX;
			y = m_PlaceY;
		}
		if (x + width > StdMap.Main.stage.stageWidth) x = StdMap.Main.stage.stageWidth - width;
		if (x < 0) x = 0;
		if (y + height > StdMap.Main.stage.stageHeight) y = StdMap.Main.stage.stageHeight - height;
		if (y < 0) y = 0;

		while (m_ScrollToCurrent) {
			m_ScrollToCurrent = 0;

			if (m_ViewItemCnt > m_ShowCnt) break;
			if (m_Current < 0 || m_Current>=m_List.length) break;

			var cnt:int = (m_ViewItemCnt >> 1);
			var v:int = m_Current;
			while (v > 0 && cnt>0) {
				v--;
				if (!m_List[v].m_Show) continue;
				cnt--;
			}
//			var v:int = m_Current - (m_ViewItemCnt >> 1);
//			if (v + m_ViewItemCnt > m_List.length) v = m_List.length - m_ViewItemCnt;
//			if (v < 0) v = 0;
			m_Scroll.position = v;

			break;
		}

		if ((m_Current >= 0) && (m_Current < m_List.length)) {
			var itm:CtrlPopupMenuItem = m_List[m_Current];
			m_CurrentItem.visible = true;
			m_CurrentItem.y = itm.m_Y;
		} else {
			m_CurrentItem.visible = false;
		}

		var captop:int = 10;
		if (m_Scroll.visible) m_LayerItem.y = captop - m_Scroll.position * m_CellSize;
		else m_LayerItem.y = captop;
	}

	public function get ItemCnt():int { return m_List.length; }
	public function ItemText(no:int):String { if (no<0 || no>=m_List.length) return null; return m_List[no].m_Text; }
	public function ItemSelect(no:int):* { if (no<0 || no>=m_List.length) return undefined; return m_List[no].m_Select; }
	public function ItemData(no:int):* { if (no<0 || no>=m_List.length) return undefined; return m_List[no].m_Data; }

	public function ItemDelete(i:int):void
	{
		if (i<0 || i>=m_List.length) return;
		var itm:CtrlPopupMenuItem = m_List[i];
		m_List.splice(i, 1);

		if (itm.m_TF != null) {
			m_LayerItem.removeChild(itm.m_TF);
			itm.m_TF = null;
		}
		if (itm.m_IconOpen) {
			m_LayerItem.removeChild(itm.m_IconOpen);
			itm.m_IconOpen = null;
		}
		if (itm.m_IconClose) {
			m_LayerItem.removeChild(itm.m_IconClose);
			itm.m_IconClose = null;
		}
		if (itm.m_IconCheck) {
			m_LayerItem.removeChild(itm.m_IconCheck);
			itm.m_IconCheck = null;
		}
		if (itm.m_Switch) {
			for (i = 0; i < itm.m_Switch.length; i++) {
				var sw:CtrlPopupMenuSwitch = itm.m_Switch[i];
				if (sw.m_TF != null) {
					m_LayerItem.removeChild(sw.m_TF);
					sw.m_TF = null;
				}
			}
			itm.m_Switch.length = 0;
			itm.m_Switch = null;
		}
		m_NeedBuild = true;
	}
	
	public function ItemClear():void
	{
		while (m_List.length > 0) ItemDelete(m_List.length - 1);
	}
	
	public function ItemAdd(tstr:String = "-", data:* = undefined, lvl:int = 0, fun:Function = null, select:* = true):int
	{
		var itm:CtrlPopupMenuItem = new CtrlPopupMenuItem();
		itm.m_Text = tstr;
		itm.m_Data = data;
		itm.m_Lvl = lvl;
		itm.m_Fun = fun;
		itm.m_Select = select;
		m_List.push(itm);
		m_NeedBuild = true;
		return m_List.length - 1;
	}
	
	public function itemTextSet(i:int, tstr:String):void
	{
		if (i<0 || i>=m_List.length) return;
		m_List[i].m_Text = tstr;
		m_NeedBuild = true;
	}
	
	public function itemDataSet(i:int, d:*):void
	{
		if (i<0 || i>=m_List.length) return;
		m_List[i].m_Data = d;
	}

	public function itemParent(i:int):int
	{
		if (i<0 || i>=m_List.length) return -1;
		var lvl:int = m_List[i].m_Lvl;
		for (; i >= 0; i--) {
			if (m_List[i].m_Lvl >= lvl) continue;
			return i;
		}
		return -1;
	}

	public function itemChild(i:int, no:int):int
	{
		var itm:CtrlPopupMenuItem;
		if (i<0 || i>=(m_List.length-1)) return -1;
		var lvl:int = m_List[i + 1].m_Lvl;
		if (lvl <= m_List[i].m_Lvl) return -1;
		i++;
		for (; i < m_List.length; i++) {
			itm = m_List[i];
			if (itm.m_Lvl > lvl) continue;
			if (itm.m_Lvl < lvl) return -1;
			no--;
			if (no < 0) return i;
		}
		return -1;
	}

	public function itemCheckSet(i:int, v:*):void
	{
		if (i<0 || i>=m_List.length) return;
		if (m_List[i].m_Check == v) return;
		m_List[i].m_Check = v;
		m_NeedBuild = true;
	}
	
	public function switchCnt(i:int):int
	{
		if (i<0 || i>=m_List.length) return 0;
		if (m_List[i].m_Switch == null) return 0;
		return m_List[i].m_Switch.length;
	}
	
	public function switchOn(i:int, sw:int, on:*=undefined):Boolean
	{
		if (i<0 || i>=m_List.length) return false;
		if (m_List[i].m_Switch == null) return false;
		if (sw<0 || sw>=m_List[i].m_Switch.length) return false;
		if (on != undefined) {
			m_List[i].m_Switch[sw].m_On = on;
			m_NeedBuild = true;
		}
		return m_List[i].m_Switch[sw].m_On;
	}
	
	public function switchTextSet(i:int, sw:int, tstr:String):void
	{
		if (i<0 || i>=m_List.length) return;
		if (m_List[i].m_Switch == null) return;
		if (sw<0 || sw>=m_List[i].m_Switch.length) return;
		m_List[i].m_Switch[sw].m_Text = tstr;
		m_NeedBuild = true;
	}
	
	public function switchData(i:int, sw:int):*
	{
		if (i<0 || i>=m_List.length) return false;
		if (m_List[i].m_Switch == null) return false;
		if (sw<0 || sw>=m_List[i].m_Switch.length) return false;
		return m_List[i].m_Switch[sw].m_Data;
	}

	public function SwitchAdd(i:int, tstr:String, data:*, on:Boolean = false, fun:Function = null):int
	{
		if (i<0 || i>=m_List.length) return -1;

		var sw:CtrlPopupMenuSwitch = new CtrlPopupMenuSwitch();
		sw.m_Text = tstr;
		sw.m_Data = data;
		sw.m_On = on;
		sw.m_Fun = fun;
		if (!m_List[i].m_Switch) m_List[i].m_Switch = new Vector.<CtrlPopupMenuSwitch>();
		m_List[i].m_Switch.push(sw);
		m_NeedBuild = true;
		return m_List[i].m_Switch.length - 1;
	}

	public function CloseAll():void
	{
		var i:int;
		for (i = 0; i < m_List.length; i++) {
			if (!m_List[i].m_Open) continue;
			m_List[i].m_Open = false;
			m_NeedBuild = true;
			m_NeedUpdate = true;
		}
	}
	
	public function OpenForView(i:int):void
	{
		if (i<0 || i>=m_List.length) return;

		var lvl:int = m_List[i].m_Lvl;
		for (; i >= 0; i--) {
			if (m_List[i].m_Lvl >= lvl) continue;
			lvl = m_List[i].m_Lvl;
			m_List[i].m_Open = true;
		}
	}
	
	public function ItemPick(x:Number, y:Number):int
	{
		var i:int, u:int;
		var itm:CtrlPopupMenuItem;
		if (x<m_LayerItem.x || x>=m_LayerItem.x+m_CellWidth) return -1;
		for (i = 0; i < m_List.length; i++) {
			itm = m_List[i];
			if (!itm.m_Show) continue;
			u = y - itm.m_Y - m_LayerItem.y;
			//if (m_Scroll.visible) u += m_Scroll.position * m_CellSize;
			if (u >= 0 && u < m_CellSize) return i;
		}
		return -1;
	}
	
	public function IsExistChild(i:int):Boolean
	{
		if (i<0 || i>=(m_List.length-1)) return false;
		return m_List[i].m_Lvl < m_List[i + 1].m_Lvl;
	}

/*	protected function onMouseModal(e:MouseEvent):void
	{
		if (FormStd.m_ModalList.length <= 0) return;
		if (FormStd.m_ModalList[FormStd.m_ModalList.length - 1] != this) return;

		var o:DisplayObject = null;
		if ((e.target != null) && (e.target is DisplayObject)) {
			o = e.target as DisplayObject;
			while (o != null) {
				if (o == this) break;
				o = o.parent;
			}
		}
		if (o == null) {
			if (e.type == MouseEvent.MOUSE_DOWN) Hide();
			else e.stopPropagation();
		}
	}*/
	
	private function IsIn(e:MouseEvent):Boolean
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
		return true;
	}

	private function IsInSkipScroll(e:MouseEvent):Boolean
	{
		var o:DisplayObject = null;
		if ((e.target != null) && (e.target is DisplayObject)) {
			o = e.target as DisplayObject;
			while (o != null) {
				if (o is CtrlScrollBar) return false;
				if (o == this) break;
				o = o.parent;
			}
		}
		if (o == null) return false;
		return true;
	}
	
	private function IsInForm(e:MouseEvent):Boolean
	{
		var o:DisplayObject = null;
		if ((e.target != null) && (e.target is DisplayObject)) {
			o = e.target as DisplayObject;
			while (o != null) {
				if (o == this) break;
				if (o is FormStd) break;
				o = o.parent;
			}
		}
		if (o == null) return false;
		return true;
	}

	private function onDeactivate(e:Event):void
	{
		m_MouseDown = 0;
		MouseUnlock();
		
		Hide();
	}

	private function onMouseWheel(e:MouseEvent):void
	{
		e.stopPropagation();

		if (m_Scroll.visible && IsInForm(e)) {
			if (e.delta < 0) {
				m_Scroll.position = m_Scroll.position + 1;
				m_NeedUpdate = true;
			} else {
				m_Scroll.position = m_Scroll.position - 1;
				m_NeedUpdate = true;
			}
		}
	}

	protected function onRightMouseDown(e:MouseEvent):void
	{
		if (!IsIn(e)) { Hide(); return; }
		e.stopPropagation();
	}

//	protected function onRightMouseUp(e:MouseEvent):void
//	{
//		e.stopImmediatePropagation();
//		Hide();
//	}

	protected function onMouseDown(e:MouseEvent):void
	{
		if (!IsIn(e) && !m_MouseLock) {
			Hide();
			if (m_ParentCtrl is CtrlComboBox) {
				if ((m_ParentCtrl as CtrlComboBox).IsHitBut(e)) (m_ParentCtrl as CtrlComboBox).m_SkipMenu = true;
			} else if (m_ParentCtrl is CtrlBut) {
				if ((m_ParentCtrl as CtrlBut).IsHit(e)) (m_ParentCtrl as CtrlBut).m_SkipMenu = true;
			}
			return;
		}

		var ci:int = ItemPick(mouseX, mouseY);
		if (ci != m_Current) {
			m_Current = ci;
			m_NeedUpdate = true;
		}
		if (m_Current != -1) {
			m_MouseDown = 1;
			MouseLock();
		}
		
		if (IsInSkipScroll(e)) {			
			e.stopPropagation();
		}
	}

	protected function onMouseUp(e:MouseEvent):void
	{
		if (!IsIn(e) && !m_MouseLock) {
			Hide();
			return;
		}
		
		e.stopPropagation();

		if (m_MouseDown == 1 && m_Current == ItemPick(mouseX, mouseY)) {
			m_MouseDown = 0;
			MouseUnlock();
			
			var i:int;
			var itm:CtrlPopupMenuItem = m_List[m_Current];
			var sw:CtrlPopupMenuSwitch;
			
			if (itm.m_Switch) {
				for (i = 0; i < itm.m_Switch.length; i++) {
					sw = itm.m_Switch[i];
					if (!sw.m_TF) continue;
					if (sw.m_TF.hitTestPoint(stage.mouseX, stage.mouseY)) {
						sw.m_On = !sw.m_On;
						m_NeedBuild = true;
						
						if (sw.m_Fun!=null) sw.m_Fun(this, m_Current, i);
						return;
					}
				}
			}

			if (IsExistChild(m_Current)) {
			//if (m_LayerItem.mouseX < itm.m_X) {
				if (IsExistChild(m_Current)) {
					m_List[m_Current].m_Open = !m_List[m_Current].m_Open;
					m_NeedBuild = true;
					m_NeedUpdate = true;
				}
				return;
			}

			while (itm.m_Select != undefined) {
				if (itm.m_Switch && m_LayerItem.mouseX < itm.m_TF.x) {
					break;
				}
				if (itm.m_Select is Boolean) {
					if (!itm.m_Select) break;

				} else if (itm.m_Select is int) {
					if (itm.m_Select<0 || itm.m_Select>=m_List.length) break;
					itm = m_List[itm.m_Select];
					
				} else if (itm.m_Select is CtrlPopupMenuItem) {
					itm = itm.m_Select;
					
				} else break;
				
				i = m_List.indexOf(itm);
				if (i >= 0 && i != m_Current) {
					m_Current = i;
				}

				Hide();
				if (itm.m_Fun != null) itm.m_Fun(itm.m_Data);

				dispatchEvent(new Event(Event.SELECT));
				return;
			}
		} else {
			m_MouseDown = 0;
			MouseUnlock();
		}
	}

	private function onMouseMove(e:MouseEvent):void
	{
		if (!IsIn(e) && !m_MouseLock) return;
		e.stopPropagation(); // почему было закомментировано?
		
		if(m_MouseDown==0) {
			var ci:int = ItemPick(mouseX, mouseY);
			if (ci != m_Current) {
				m_Current = ci;
				m_NeedUpdate = true;
			}
		}
	}

	private function onMouseOut(e:MouseEvent):void
	{
	}
	
	protected function onKeyDownModal(e:KeyboardEvent):void
	{
		if (FormStd.m_ModalList.length <= 0) return;
		if (FormStd.m_ModalList[FormStd.m_ModalList.length - 1] != this) return;
		
		e.stopPropagation();
		if (visible && (e.keyCode == 27 || e.keyCode == 192)) { // ESC `
			Hide();
			dispatchEvent(new Event("close"));
		}
	}

	protected function ScrollChange(e:Event):void
	{
		m_NeedUpdate = true;
	}
	
	public function ScrollToCurrentCenter():void
	{
		m_ScrollToCurrent = 1;
		m_NeedUpdate = true;
	}
}

}
import flash.text.*;
import flash.display.*;

class CtrlPopupMenuSwitch
{
	public var m_Text:String = null;
	public var m_Data:*= undefined;
	public var m_TF:TextField = null;
	public var m_On:Boolean = false;
	public var m_Fun:Function = null;
}

class CtrlPopupMenuItem
{
	public var m_Text:String = null;
	public var m_Data:*= undefined;
	public var m_Lvl:int = 0;
	public var m_Fun:Function = null;
	public var m_Select:* = undefined;
	public var m_Check:*= undefined;

	public var m_X:int = 0;
	public var m_Y:int = 0;

	public var m_TF:TextField = null;
	public var m_Line:Sprite = null;
	public var m_IconOpen:DisplayObject = null;
	public var m_IconClose:DisplayObject = null;
	public var m_IconCheck:DisplayObject = null;
	
	public var m_Show:Boolean = false;
	public var m_Open:Boolean = false;
	
	public var m_Switch:Vector.<CtrlPopupMenuSwitch> = null;
	
	public function CtrlPopupMenuItem():void
	{
	}
}
