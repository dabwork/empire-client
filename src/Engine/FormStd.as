package Engine
{
import Base.*;
import flash.display.*;
import flash.events.*;
import flash.geom.Matrix;
import flash.text.*;

public class FormStd extends Sprite
{
	public static const HeaderRed:int = 1;
	public static const HeaderGreen:int = 2;
	public static const HeaderBlue:int = 3;
	public static const HeaderGrey:int = 4;

	[Embed(source = '/assets/stdwin/bg_fill.png')] public static var bmBGFill:Class;

	[Embed(source = '/assets/stdwin/border_top_left.png')] public var bmTopLeft:Class;
	[Embed(source = '/assets/stdwin/border_top_right.png')] public var bmTopRight:Class;
	[Embed(source = '/assets/stdwin/border_bottom_left.png')] public var bmBottomLeft:Class;
	[Embed(source = '/assets/stdwin/border_bottom_right.png')] public var bmBottomRight:Class;
	[Embed(source = '/assets/stdwin/border_bottom_right_fix.png')] public var bmBottomRightFix:Class;
	[Embed(source = '/assets/stdwin/border_left.png')] public var bmLeft:Class;
	[Embed(source = '/assets/stdwin/border_right.png')] public var bmRight:Class;
	[Embed(source = '/assets/stdwin/border_top.png')] public var bmTop:Class;
	[Embed(source = '/assets/stdwin/border_bottom.png')] public var bmBottom:Class;

	[Embed(source = '/assets/stdwin/header_red_center.png')] public var bmHeaderRedCenter:Class;
	[Embed(source = '/assets/stdwin/header_red_left.png')] public var bmHeaderRedLeft:Class;
	[Embed(source = '/assets/stdwin/header_red_right.png')] public var bmHeaderRedRight:Class;

	[Embed(source = '/assets/stdwin/header_green_center.png')] public var bmHeaderGreenCenter:Class;
	[Embed(source = '/assets/stdwin/header_green_left.png')] public var bmHeaderGreenLeft:Class;
	[Embed(source = '/assets/stdwin/header_green_right.png')] public var bmHeaderGreenRight:Class;

	[Embed(source = '/assets/stdwin/header_blue_center.png')] public var bmHeaderBlueCenter:Class;
	[Embed(source = '/assets/stdwin/header_blue_left.png')] public var bmHeaderBlueLeft:Class;
	[Embed(source = '/assets/stdwin/header_blue_right.png')] public var bmHeaderBlueRight:Class;

	[Embed(source = '/assets/stdwin/header_grey_center.png')] public var bmHeaderGreyCenter:Class;
	[Embed(source = '/assets/stdwin/header_grey_left.png')] public var bmHeaderGreyLeft:Class;
	[Embed(source = '/assets/stdwin/header_grey_right.png')] public var bmHeaderGreyRight:Class;

	[Embed(source = '/assets/stdwin/close_normal.png')] public var bmCloseNormal:Class;
	[Embed(source = '/assets/stdwin/close_onmouse.png')] public var bmCloseOnMouse:Class;
	[Embed(source = '/assets/stdwin/close_onpress.png')] public var bmCloseOnPress:Class;
	[Embed(source = '/assets/stdwin/close_disabled.png')] public var bmCloseDisable:Class;

	[Embed(source = '/assets/stdwin/tab_stub_left.png')] public var bmTabStubLeft:Class;
	[Embed(source = '/assets/stdwin/tab_stub_right.png')] public var bmTabStubRight:Class;
	[Embed(source = '/assets/stdwin/tab_stub_center.png')] public var bmTabStubCenter:Class;

	[Embed(source = '/assets/stdwin/tab_normal_left.png')] public var bmTabNormalLeft:Class;
	[Embed(source = '/assets/stdwin/tab_normal_right.png')] public var bmTabNormalRight:Class;
	[Embed(source = '/assets/stdwin/tab_normal_center.png')] public var bmTabNormalCenter:Class;
	
	[Embed(source = '/assets/stdwin/tab_active_left.png')] public var bmTabActiveLeft:Class;
	[Embed(source = '/assets/stdwin/tab_active_right.png')] public var bmTabActiveRight:Class;
	[Embed(source = '/assets/stdwin/tab_active_center.png')] public var bmTabActiveCenter:Class;

	[Embed(source = '/assets/stdwin/tab_onmouse_left.png')] public var bmTabOnmouseLeft:Class;
	[Embed(source = '/assets/stdwin/tab_onmouse_right.png')] public var bmTabOnmouseRight:Class;
	[Embed(source = '/assets/stdwin/tab_onmouse_center.png')] public var bmTabOnmouseCenter:Class;

	[Embed(source = '/assets/stdwin/tab_onpress_left.png')] public var bmTabOnpressLeft:Class;
	[Embed(source = '/assets/stdwin/tab_onpress_right.png')] public var bmTabOnpressRight:Class;
	[Embed(source = '/assets/stdwin/tab_onpress_center.png')] public var bmTabOnpressCenter:Class;
	
	[Embed(source = '/assets/stdwin/face_frame_bg.png')] public var bmFaceFrameBg:Class;
	[Embed(source = '/assets/stdwin/face_frame_top.png')] public var bmFaceFrameTop:Class;
	[Embed(source = '/assets/stdwin/face_frame_decor.png')] public var bmFaceFrameDecor:Class;

	[Embed(source = '/assets/stdwin/split_left.png')] public var bmSplitLeft:Class;
	[Embed(source = '/assets/stdwin/split_center.png')] public var bmSplitCenter:Class;
	[Embed(source = '/assets/stdwin/split_right.png')] public var bmSplitRight:Class;
	
	private var m_FormFloat:Boolean = false;
	private var m_FormModal:Boolean = false;
	
	private var m_HeaderType:int = HeaderGreen;
	
	private var m_PosX:Number = 0;
	private var m_PosY:Number = 0;
	private var m_PosAlignX:int = 0; // -1=left 0=center 1-right
	private var m_PosAlignY:int = 0; // -1=top 0=center 1-bottom
	
	private var m_Scale:Number = 1.0;
	
	private var m_SplitPos:int = 0;

	private var m_LayerBG:Sprite = null;
	private var m_LayerTab:Sprite = null;
	private var m_LayerBorder:Sprite = null;
	private var m_LayerPage:Sprite = null;
	private var m_LayerItem:Sprite = null;
	private var m_LayerItemMask:Sprite = null;
	private var m_LayerCtrl:Sprite = null;
	
	private var m_ScrollItem:CtrlScrollBar = null;
	private var m_ScrollVis:Boolean = false;
	private var m_ScrollLine:int = 34;

	private var m_SizeX:int = 300;
	private var m_SizeY:int = 200;

	private var m_CloseNormal:DisplayObject = null;
	private var m_CloseOnMouse:DisplayObject = null;
	private var m_CloseOnPress:DisplayObject = null;
	private var m_CloseDisable:DisplayObject = null;
	private var m_CloseState:int = 0; // 0-normal 1-onmouse 2-onpress 3-onpress & outmouse -1-disable

	private var m_Caption:TextField = null;
	private var m_HeaderLeft:Bitmap = null;
	private var m_HeaderRight:Bitmap = null;

	private var m_TabArray:Vector.<FormStdTab> = new Vector.<FormStdTab>();
	private var m_TabActive:int = -1;
	private var m_TabMouse:int = -1;
	private var m_TabDown:int = 0; // 0-no 1-down in 2-down out

	private var m_PageArray:Vector.<FormStdPage> = new Vector.<FormStdPage>();
	private var m_PageShow:Boolean = false;
	private var m_PageWidth:int = 0;
	private var m_PageWidthMin:int = 50;
	private var m_PageActive:int = -1;
	private var m_PageMouse:int = -1;
	private var m_PageDown:int = 0; // 0-no 1-down in 2-down out

	private var m_GridArray:Vector.<FormStdGrid> = new Vector.<FormStdGrid>();

	private var m_ItemArray:Vector.<FormStdItem> = new Vector.<FormStdItem>();
	
	private var m_CtrlArray:Vector.<FormStdCtrl> = new Vector.<FormStdCtrl>();
	
	private var m_WinItemWidth:int = 0;
	private var m_WinItemHeight:int = 0;
	
	public static var m_ModalList:Array = new Array();

	public function get FI():FormInputEx { return StdMap.Main.m_FormInputEx; }
	
	public function setPos(px:Number = 0, py:Number = 0, ax:int = 0, ay:int = 0):void { m_PosX = px; m_PosY = py; m_PosAlignX = ax; m_PosAlignY = ay; }
	
	public function set scrollLine(v:int):void { if (v < 0) v = 0; m_ScrollLine = v; }

	override public function get width():Number { return m_SizeX; }
	override public function set width(v:Number):void { if (v < 300) v = 300; if (m_SizeX == v) return; m_SizeX = v; if (!visible) return; SavePos(); LayerBorderBuild(); }
	override public function get height():Number { return m_SizeY; }
	override public function set height(v:Number):void { if (v < 200) v = 200; if (m_SizeY == v) return; m_SizeY = v; if (!visible) return; SavePos(); LayerBorderBuild(); }
	public function set splitPos(v:int):void { if (m_SplitPos == v) return; m_SplitPos = v; if (!visible) return; LayerBorderBuild(); }
	public function set caption(str:String):void { m_Caption.htmlText = BaseStr.FormatTag(str == null?"":str.toUpperCase()); if (visible) UpdateCaption(); }
	public function set captionEx(str:String):void { m_Caption.htmlText = BaseStr.FormatTag(str == null?"":str); if (visible) UpdateCaption(); }
	public function set closeDisable(v:Boolean):void { if (v) { if (m_CloseState == -1) return; m_CloseState = -1; } else { if (m_CloseState != -1) return; m_CloseState = 0; } ButCloseUpdate(); }
	public function get closeDisable():Boolean { return m_CloseState == -1; }
	public function get tab():int { return m_TabActive; }
	public function set tab(v:int):void { if (v<-1 || v>=m_TabArray.length || v==m_TabActive) return; m_TabActive=v; if(!visible) return; UpdateTab(); LayerPageBuild(); UpdatePage(); LayerItemBuild(); LayerCtrlBuild(); }
	public function get page():int { return m_PageActive; }
	public function set page(v:int):void { if (v<-1 || v>=m_PageArray.length || v==m_PageActive) return; m_PageActive=v; if(!visible) return; UpdatePage(); LayerItemBuild(); LayerCtrlBuild(); }
	public function set modal(v:Boolean):void { if (m_FormModal == v) return; if (visible) Hide(); m_FormModal = v; }
	public function get modal():Boolean { return m_FormModal; }
	public function set headerType(v:int):void { if (m_HeaderType == v) return; m_HeaderType = v; if (visible) LayerBorderBuild(); }
	
	public function ContentBuild():void { LayerItemBuild(); LayerCtrlBuild(); }

	public function set scale(v:Number):void { if (v < 1.0) v = 1.0; else if(v>=2.0) v=2.0; if (m_Scale == v) return; m_Scale=v; scaleX=m_Scale; scaleY=m_Scale; }
	public function get scale():Number { return m_Scale; }
	
	public function get ItemCnt():int { return m_ItemArray.length; }
	public function get CtrlCnt():int { return m_CtrlArray.length; }

	private var m_ContentSpaceLeft:int = 0;
	private var m_ContentSpaceTop:int = 0;
	private var m_ContentSpaceRight:int = 0;
	private var m_ContentSpaceBottom:int = 0;

	public function set pageWidthMin(v:int):void { if (v < 0) v = 0; else if(v>=1000) v=1000; if(m_PageWidthMin==v) return; m_PageWidthMin=v; if(!visible) return; UpdateTab(); LayerPageBuild(); UpdatePage(); LayerItemBuild(); LayerCtrlBuild(); }

	public function get contentSpaceLeft():int { return m_ContentSpaceLeft; }
	public function set contentSpaceLeft(v:int):void { if (m_ContentSpaceLeft == v) return; m_ContentSpaceLeft = v; }
	public function get contentSpaceTop():int { return m_ContentSpaceTop; }
	public function set contentSpaceTop(v:int):void { if (m_ContentSpaceTop == v) return; m_ContentSpaceTop = v; }
	public function get contentSpaceRight():int { return m_ContentSpaceRight; }
	public function set contentSpaceRight(v:int):void { if (m_ContentSpaceRight == v) return; m_ContentSpaceRight = v; }
	public function get contentSpaceBottom():int { return m_ContentSpaceBottom; }
	public function set contentSpaceBottom(v:int):void { if (m_ContentSpaceBottom == v) return; m_ContentSpaceBottom = v; }

	public function get innerLeft():int { return 45; }
	public function get innerTop():int { return (IsViewTabBar()?(80):(50)); }
	public function get innerRight():int { return 30; }
	public function get innerBottom():int { return 35; }

	public function get contentX():int { return  innerLeft + m_PageWidth + m_ContentSpaceLeft; }
	public function get contentY():int { return innerTop + m_ContentSpaceTop; }
	public function get contentWidth():int { return m_SizeX - contentX - innerRight - m_ContentSpaceRight - (m_ScrollVis?(m_ScrollItem.width - 5):0); }
	public function get contentHeight():int { return m_SizeY - contentY - innerBottom - m_ContentSpaceBottom; }

	private static var m_BGFillImg:BitmapData = null;
	
	private static var m_Drag:Boolean = false;

	public static function get BGFillImg():BitmapData
	{
		if (m_BGFillImg == null) {
			m_BGFillImg = (new bmBGFill() as Bitmap).bitmapData;
//			(m_BGFill as Bitmap).smoothing = true;
		}
		return m_BGFillImg;
	}

	public function FormStd(float:Boolean, modal:Boolean):void
	{
		visible = false;
		
		m_FormFloat = float;
		m_FormModal = modal;
		
		m_LayerBG = new Sprite();
		m_LayerBG.mouseEnabled = false;
		addChild(m_LayerBG);

		m_LayerTab = new Sprite();
		m_LayerTab.mouseEnabled = false;
		addChild(m_LayerTab);

		m_LayerBorder = new Sprite();
		m_LayerBorder.mouseEnabled = false;
		addChild(m_LayerBorder);

		m_LayerPage = new Sprite();
		m_LayerPage.mouseEnabled = false;
		addChild(m_LayerPage);

		m_LayerItem = new Sprite();
		m_LayerItem.mouseEnabled = false;
		addChild(m_LayerItem);
		
		m_LayerItemMask = new Sprite();
		addChild(m_LayerItemMask);
		m_LayerItem.mask = m_LayerItemMask;
		
		m_ScrollItem = new CtrlScrollBar();
		m_ScrollItem.style = CtrlScrollBar.StyleVertical;
		m_ScrollItem.visible = false;
		m_ScrollItem.addEventListener(Event.CHANGE, ScrollItemChange);
		m_ScrollItem.setRange(0, 10, 10, 1);
		addChild(m_ScrollItem);

		m_LayerCtrl = new Sprite();
		m_LayerCtrl.mouseEnabled = false;
		addChild(m_LayerCtrl);

		m_Caption = new TextField();
		m_Caption.width=1;
		m_Caption.height=1;
		m_Caption.type=TextFieldType.DYNAMIC;
		m_Caption.selectable=false;
		m_Caption.textColor=0xffffff;
		m_Caption.background=false;
		m_Caption.backgroundColor=0x80000000;
		m_Caption.alpha=1.0;
		m_Caption.multiline=false;
		m_Caption.autoSize=TextFieldAutoSize.LEFT;
		m_Caption.gridFitType=GridFitType.PIXEL;
		m_Caption.defaultTextFormat=new TextFormat("Calibri",16,0x000000);
		m_Caption.embedFonts = true;
		m_Caption.mouseEnabled = false;
		addChild(m_Caption);

		m_CloseNormal = new bmCloseNormal() as DisplayObject;
		(m_CloseNormal as Bitmap).smoothing = true;
		addChild(m_CloseNormal);
		m_CloseOnMouse = new bmCloseOnMouse() as DisplayObject;
		(m_CloseOnMouse as Bitmap).smoothing = true;
		addChild(m_CloseOnMouse);
		m_CloseOnPress = new bmCloseOnPress() as DisplayObject;
		(m_CloseOnPress as Bitmap).smoothing = true;
		addChild(m_CloseOnPress);
		m_CloseDisable = new bmCloseDisable() as DisplayObject;
		(m_CloseDisable as Bitmap).smoothing = true;
		addChild(m_CloseDisable);
	}
	
	public function Reposition():void
	{
		var tx:int = Math.round(m_PosX * stage.stageWidth)
		var ty:int = Math.round(m_PosY * stage.stageHeight);
		
		var sx:int = Math.floor(scale * m_SizeX);
		var sy:int = Math.floor(scale * m_SizeY);

		if (m_PosAlignX > 0) tx += stage.stageWidth - sx;
		else if (m_PosAlignX == 0) tx += (stage.stageWidth >> 1) - (sx >> 1);

		if (m_PosAlignY > 0) ty += stage.stageHeight - sy;
		else if (m_PosAlignY == 0) ty += (stage.stageHeight >> 1) - (sy >> 1);

		if (tx + sx > stage.stageWidth) tx = stage.stageWidth - sx;
		if (ty + sy > stage.stageHeight) ty = stage.stageHeight - sy;
		if (tx < 0) tx = 0;
		if (ty < 0) ty = 0;

		x = tx;
		y = ty;
	}
	
	public function SavePos():void
	{
		var d:int;
		
		var ax:int = -1;
		var px:int = x;
		var ay:int = -1;
		var py:int = y;

		var sx:int = Math.floor(scale * m_SizeX);
		var sy:int = Math.floor(scale * m_SizeY);
		
		d = x + sx - stage.stageWidth; if (Math.abs(d) < Math.abs(px)) { ax = 1; px = d; }
		d = x + (sx >> 1) - (stage.stageWidth >> 1); if (Math.abs(d) < Math.abs(px)) { ax = 0; px = d; }

		d = y + sy - stage.stageHeight; if (Math.abs(d) < Math.abs(py)) { ay = 1; py = d; }
		d = y + (sy >> 1) - (stage.stageHeight >> 1); if (Math.abs(d) < Math.abs(py)) { ay = 0; py = d; }
		
		m_PosAlignX = ax;
		m_PosAlignY = ay;
		m_PosX = Number(px) / stage.stageWidth;
		m_PosY = Number(py) / stage.stageHeight;
	}

	public function onStageResize(e:Event):void
	{
		if (visible && StdMap.Main.IsResize()) {
			Reposition();

			dispatchEvent(new Event("change_pos"));
		}
	}

	public function Show():void
	{
		if (visible) return;

		visible = true;
		if (m_FormFloat && StdMap.Main) StdMap.Main.FloatTop(this);

		m_ModalList.push(this);

		if(m_CloseState!=-1) m_CloseState = 0;

		LayerBorderBuild();
		ButCloseUpdate();
		UpdateCaption();
		LayerTabBuild();
		UpdateTab();
		LayerPageBuild();
		UpdatePage();
		LayerItemBuild();
		LayerCtrlBuild();

		Reposition();
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownTop,true);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);

		if (m_FormModal) {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseModal, false);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseModal, true);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseModal, false);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseModal, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseModal, false);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseModal, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, false);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, true);
		}

		stage.addEventListener(Event.DEACTIVATE, onDeactivate);

		StdMap.Main.stage.addEventListener(Event.RESIZE, onStageResize);

		dispatchEvent(new Event("change_pos"));
	}
	
	private function onMouseDownTop(e:MouseEvent):void
	{
		if (m_FormFloat && StdMap.Main) StdMap.Main.FloatTop(this);
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
		//dispatchEvent(new Event("beforeHide"));

		MouseUnlock();
		if(m_CloseState>=0) m_CloseState = 0;
		if (visible) {
			
			var i:int = m_ModalList.indexOf(this);
			m_ModalList.splice(i, 1);
			
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRightMouseDown);

			if (m_FormModal) {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseModal, false);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseModal, true);
				stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseModal, false);
				stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseModal, true);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseModal, false);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseModal, true);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, false);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, true);
			}

			stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
			
			StdMap.Main.stage.removeEventListener(Event.RESIZE, onStageResize);
		}
		m_LayerItem.removeChildren();
		m_LayerCtrl.removeChildren();
		visible = false;
	}
	
	public function BGFill(layer:Sprite, x:int, y:int, w:int, h:int):void
	{
		layer.graphics.beginBitmapFill(BGFillImg, null, true, false);
		layer.graphics.drawRect( x, y, w, h);
		layer.graphics.endFill();
	}
	
	public function LayerBorderBuild():void
	{
		var i:int;
		var s:DisplayObject;
		var m:Sprite;

		m_LayerBorder.removeChildren();

		var tl:DisplayObject = new bmTopLeft() as DisplayObject; (tl as Bitmap).smoothing = true; m_LayerBorder.addChild(tl);
		tl.x = 0;
		tl.y = 0;

		var tr:DisplayObject = new bmTopRight() as DisplayObject; (tr as Bitmap).smoothing = true; m_LayerBorder.addChild(tr);
		tr.x = m_SizeX - tr.width;
		tr.y = 0;
		var bendx:int = tr.x;

		var bl:DisplayObject = new bmBottomLeft() as DisplayObject; (bl as Bitmap).smoothing = true; m_LayerBorder.addChild(bl);
		bl.x = 0;
		bl.y = m_SizeY - bl.height;
		
		var br:DisplayObject=null;
		if (1) {
			br = new bmBottomRightFix() as DisplayObject; (br as Bitmap).smoothing = true; m_LayerBorder.addChild(br);
			br.x = m_SizeX - br.width;
			br.y = m_SizeY - br.height - 3;
		} else {
			br = new bmBottomRight() as DisplayObject; (br as Bitmap).smoothing = true; m_LayerBorder.addChild(br);
			br.x = m_SizeX - br.width - 1;
			br.y = m_SizeY - br.height - 3;
		}

		for (i = tl.y + tl.height; i < bl.y; ) {
			s = new bmLeft() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerBorder.addChild(s);
			s.x = 2;
			s.y = i;
			if (s.height > (bl.y - i)) {
				m = new Sprite(); m_LayerBorder.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, s.width, bl.y - i);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.height;			
		}

		for (i = tr.y + tr.height; i < br.y; ) {
			s = new bmRight() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerBorder.addChild(s);
			s.x = m_SizeX - s.width - 2;
			s.y = i;
			if (s.height > (br.y - i)) {
				m = new Sprite(); m_LayerBorder.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, s.width, br.y - i);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.height;			
		}

		for (i = tl.x + tl.width; i < tr.x; ) {
			s = new bmTop() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerBorder.addChild(s);
			s.x = i;
			s.y = 0;
			if (s.width > (tr.x - i)) {
				m = new Sprite(); m_LayerBorder.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, tr.x - i, tr.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		for (i = bl.x + bl.width; i < br.x; ) {
			s = new bmBottom() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerBorder.addChild(s);
			s.x = i;
			s.y = m_SizeY - s.height - 4;
			if (s.width > (br.x - i)) {
				m = new Sprite(); m_LayerBorder.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, br.x - i, br.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		var hl:DisplayObject = null;
		if (m_HeaderType == HeaderRed) hl = new bmHeaderRedLeft() as DisplayObject;
		else if (m_HeaderType == HeaderGreen) hl = new bmHeaderGreenLeft() as DisplayObject;
		else if (m_HeaderType == HeaderBlue) hl = new bmHeaderBlueLeft() as DisplayObject;
		else hl = new bmHeaderGreyLeft() as DisplayObject;
		(hl as Bitmap).smoothing = true;
		hl.x = 90;
		hl.y = 3;
		m_HeaderLeft = hl as Bitmap;

		var hr:DisplayObject = null;
		if (m_HeaderType == HeaderRed) hr = new bmHeaderRedRight() as DisplayObject;
		else if (m_HeaderType == HeaderGreen) hr = new bmHeaderGreenRight() as DisplayObject;
		else if (m_HeaderType == HeaderBlue) hr = new bmHeaderBlueRight() as DisplayObject;
		else hr = new bmHeaderGreyRight() as DisplayObject;
		(hr as Bitmap).smoothing = true;
		hr.x = m_SizeX - hr.width - 90;
		hr.y = 3;
		m_HeaderRight = hr as Bitmap;

		for (i = hl.x + 20; i < hr.x + hr.width - 20; ) {
			if (m_HeaderType == HeaderRed) s = new bmHeaderRedCenter() as DisplayObject;
			else if (m_HeaderType == HeaderGreen) s = new bmHeaderGreenCenter() as DisplayObject;
			else if (m_HeaderType == HeaderBlue) s = new bmHeaderBlueCenter() as DisplayObject;
			else s = new bmHeaderGreyCenter() as DisplayObject;
			(s as Bitmap).smoothing = true;
			m_LayerBorder.addChild(s);
			s.x = i;
			s.y = 3;
			if (s.width > (hr.x + hr.width - 20 - i)) {
				m = new Sprite(); m_LayerBorder.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, hr.x + hr.width - 20 - i, tr.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}
		m_LayerBorder.addChild(hl);
		m_LayerBorder.addChild(hr);
		
		if (m_SplitPos > 0 && m_SplitPos < m_SizeY) {
			var sl:DisplayObject = new bmSplitLeft() as DisplayObject; (sl as Bitmap).smoothing = true; m_LayerBorder.addChild(sl);
			sl.x = 13;
			sl.y = m_SplitPos-(sl.height>>1);
		
			var sr:DisplayObject = new bmSplitRight() as DisplayObject; (sl as Bitmap).smoothing = true; m_LayerBorder.addChild(sr);
			sr.x = m_SizeX - sr.width - 13;
			sr.y = sl.y;

			for (i = sl.x + sl.width; i < sr.x; ) {
				s = new bmSplitCenter() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerBorder.addChild(s);
				s.x = i;
				s.y = sl.y;
				if (s.width > (sr.x - i)) {
					m = new Sprite(); m_LayerBorder.addChild(m);
					m.graphics.beginFill(0xfffffff,1);
					m.graphics.drawRect(s.x, s.y, sr.x - i, sr.height);
					m.graphics.endFill();
					s.mask = m;
				}
				i += s.width;
			}
		}
		
		m_LayerBG.graphics.clear();
//		m_LayerBG.graphics.beginFill(0xdddbc6, 1.0);// 0.94);
//		m_LayerBG.graphics.drawRect(14, 27, m_SizeX - 14 - 13, m_SizeY - 27 - 20);
//		m_LayerBG.graphics.endFill();

		BGFill(m_LayerBG, 14, 27, m_SizeX - 14 - 13, m_SizeY - 27 - 20);

		var gstart:int, gheight:int;
		var matr:Matrix = new Matrix();
		
		if (m_SplitPos > 0) {
			gstart = (27 + (IsViewTabBar()?30:0));
			gstart += (m_SplitPos - gstart) >> 1;
			gheight = m_SplitPos - gstart;
			if (gheight > 165) gheight = 165;

			if(gheight>0) {
				gstart = m_SplitPos - gheight;
			
				matr.createGradientBox(m_SizeX - 14 - 13, gheight, 0.5 * Math.PI, 14, gstart);
				m_LayerBG.graphics.beginGradientFill(GradientType.LINEAR, [0x362e00, 0x362e00], [0.0, 0.2], [0, 255], matr, SpreadMethod.PAD);
				m_LayerBG.graphics.drawRect(14, gstart, m_SizeX - 14 - 13, gheight);
				m_LayerBG.graphics.endFill();
			}
		}

		gstart = (20 + 27 + (IsViewTabBar()?30:0));
		if (m_SplitPos + 20 > gstart) gstart = m_SplitPos + 20;
		gstart += (m_SizeY - 20 - gstart) >> 1;
		gheight = m_SizeY - 20 - gstart;
		if (gheight > 165) gheight = 165;

		if(gheight>0) {
			gstart = m_SizeY - 20 - gheight;
		
			matr.createGradientBox(m_SizeX - 14 - 13, gheight, 0.5 * Math.PI, 14, gstart);
			m_LayerBG.graphics.beginGradientFill(GradientType.LINEAR, [0x362e00, 0x362e00], [0.0, 0.2], [0, 255], matr, SpreadMethod.PAD);
			m_LayerBG.graphics.drawRect(14, gstart, m_SizeX - 14 - 13, gheight);
			m_LayerBG.graphics.endFill();
		}

		m_CloseNormal.x = m_SizeX - m_CloseNormal.width+2;
		m_CloseNormal.y = 9;
		m_CloseOnMouse.x = m_CloseNormal.x;
		m_CloseOnMouse.y = m_CloseNormal.y;
		m_CloseOnPress.x = m_CloseNormal.x;
		m_CloseOnPress.y = m_CloseNormal.y;
		m_CloseDisable.x = m_CloseNormal.x;
		m_CloseDisable.y = m_CloseNormal.y;
	}
	
	private function ButCloseUpdate():void
	{
		m_CloseNormal.visible = m_CloseState == 0 || m_CloseState == 3;
		m_CloseOnMouse.visible = m_CloseState == 1;
		m_CloseOnPress.visible = m_CloseState == 2;
		m_CloseDisable.visible = m_CloseState < 0;
	}
	
	private function UpdateCaption():void
	{
		m_Caption.width;
		m_Caption.height;
		m_Caption.x = ((m_HeaderLeft.x + m_HeaderRight.x + m_HeaderRight.width) >> 1) - (m_Caption.width >> 1);
		m_Caption.y = (m_HeaderLeft.y + (m_HeaderLeft.height >> 1)) - (m_Caption.height >> 1);
	}
	
	public function get CloseBut():DisplayObject { return m_CloseNormal; }
	
	public function CanClose():Boolean
	{
		return true;
	}
	
	private function IsHitClose(x:int, y:int):Boolean
	{
		if (x<m_CloseNormal.x || x>=m_CloseNormal.x+m_CloseNormal.width) return false;
		if (y<m_CloseNormal.y || y>=m_CloseNormal.y+m_CloseNormal.height) return false;

		var clr:uint = (m_CloseNormal as Bitmap).bitmapData.getPixel32(x - m_CloseNormal.x, y - m_CloseNormal.y);
		return (clr & 0xff000000) != 0;
	}
	
	private function IsHitCaption(x:int, y:int):Boolean
	{
		if (x < m_HeaderLeft.x || x>=m_HeaderRight.x+m_HeaderRight.width) return false;
		if (y < m_HeaderLeft.y || y>=m_HeaderRight.y+m_HeaderRight.height) return false;
		return true;
	}

	private var m_MouseLock:Boolean = false;

	public function MouseLock():void
	{
		if (m_MouseLock) return;
		m_MouseLock = true;
		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,999);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,false,999);

		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,999);
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 999);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, true, 999);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,true,999);
	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		m_MouseLock = false;
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,false);

		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
		stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,true);
	}

	public function onRightMouseDown(e:MouseEvent):void
	{
		e.stopPropagation();
		if (m_FormFloat && StdMap.Main) StdMap.Main.FloatTop(this);
	}

	protected function onKeyDownModal(e:KeyboardEvent):void
	{
		if (FormStd.m_ModalList.length <= 0) return;
		if (FormStd.m_ModalList[FormStd.m_ModalList.length - 1] != this) return;
		
		e.stopPropagation();
		if (visible && m_FormModal && (e.keyCode == 27 || e.keyCode == 192) && !closeDisable) { // ESC `
			Hide();
			dispatchEvent(new Event("close"));
		}
	}
	
	protected function onMouseModal(e:MouseEvent):void
	{
		if (m_ModalList.length <= 0) return;
		if (m_ModalList[m_ModalList.length - 1] != this) return;
		
		var o:DisplayObject = null;
		if ((e.target != null) && (e.target is DisplayObject)) {
			o = e.target as DisplayObject;
			while (o != null) {
				if (o == this) break;
				if (o is CtrlPopupMenu) return;
				o = o.parent;
			}
		}
		if (o == null) e.stopPropagation();
	}
	
	public function onMouseDown(e:MouseEvent):void
	{
		e.stopPropagation();
		if (m_FormFloat && StdMap.Main) StdMap.Main.FloatTop(this);
		
//		if(ButCancel.hitTestPoint(e.stageX,e.stageY)) return;
		if (IsHitClose(mouseX, mouseY)) {
			if (m_CloseState >= 0) {
				if(CanClose()) {
					m_CloseState = 2;
					MouseLock();
					ButCloseUpdate();
				}
			}
			return;
		}

		var tabdown:int = PickTab(mouseX, mouseY);
		if (tabdown >= 0) {
			m_TabMouse = tabdown;
			m_TabDown = 1;
			MouseLock();
			UpdateTab();
		}

		var pagedown:int = PickPage(mouseX, mouseY);
		if (pagedown >= 0) {
			m_PageMouse = pagedown;
			m_PageDown = 1;
			MouseLock();
			UpdatePage();
		}

		if (IsHitCaption(mouseX, mouseY)) {
			m_Drag = true;
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true, 999);
//			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveDrag, false, -999);
		}
	}
	
	public function onMouseUp(e:MouseEvent):void
	{
		e.stopPropagation();
		
		var ef:Boolean;
		var ncs:int = m_CloseState;

		if(m_CloseState<0) {}
		else if (m_CloseState == 2 || m_CloseState == 3) {
			if (IsHitClose(mouseX, mouseY)) {
				ncs = 1;
				Hide();
				dispatchEvent(new Event("close"));
				return;
			}
			else ncs = 0;
			MouseUnlock();
		} else if (IsHitClose(mouseX, mouseY)) {
			m_CloseState = 1;
			ButCloseUpdate();
		}

		if (ncs != m_CloseState) { m_CloseState = ncs; ButCloseUpdate(); }

		if (m_TabDown != 0) {
			ef = false;
			if (m_TabDown == 2) m_TabMouse = -1;
			else {
				if (m_TabActive != m_TabMouse) {
					tab = m_TabMouse;
					ef = true;
				}
			}
			m_TabDown = 0;
			MouseUnlock();
			UpdateTab();
			if (ef) dispatchEvent(new Event("page"));
			return;
		}

		if (m_PageDown != 0) {
			ef = false;
			if (m_PageDown == 2) m_PageMouse = -1;
			else {
				if (m_PageActive != m_PageMouse) {
					page = m_PageMouse;
					ef = true;
				}
			}
			m_PageDown = 0;
			MouseUnlock();
			UpdatePage();
			if (ef) dispatchEvent(new Event("page"));
			return;
		}
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		if (m_Drag) {
			m_Drag = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true);
//			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveDrag);
			stopDrag();
			SavePos();
		}
	}

//	private function onMouseMoveDrag(e:Event):void
//	{
//		dispatchEvent(new Event("change_pos"));
//	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopPropagation();

		var ncs:int = m_CloseState;

		if (IsHitClose(mouseX, mouseY)) {
			if(ncs<0) {}
			else if (ncs == 3 || ncs == 2) ncs = 2;
			else ncs = 1;
		} else {
			if(ncs<0) {}
			else if (ncs == 3 || ncs == 2) ncs = 3;
			else ncs = 0;
		}

		var tabupdate:Boolean = false;
		var tabmouse:int = PickTab(mouseX, mouseY);
		if (m_TabDown != 0) {
			if (tabmouse == m_TabMouse && m_TabDown != 1) { m_TabDown = 1; tabupdate = true; }
			else if(tabmouse != m_TabMouse && m_TabDown != 2) { m_TabDown = 2; tabupdate = true; }
		} else if (tabmouse != m_TabMouse) { m_TabMouse = tabmouse; tabupdate = true; }

		var pageupdate:Boolean = false;
		var pagemouse:int = PickPage(mouseX, mouseY);
		if (m_PageDown != 0) {
			if (pagemouse == m_PageMouse && m_PageDown != 1) { m_PageDown = 1; pageupdate = true; }
			else if(pagemouse != m_PageMouse && m_PageDown != 2) { m_PageDown = 2; pageupdate = true; }
		} else if (pagemouse != m_PageMouse) { m_PageMouse = pagemouse; pageupdate = true; }

		if (ncs != m_CloseState) { m_CloseState = ncs; ButCloseUpdate(); }
		
		if (tabupdate) UpdateTab();
		if (pageupdate) UpdatePage();
		StdMap.Main.InfoHide();
	}

	private function onMouseOut(e:MouseEvent):void
	{
		var ncs:int = m_CloseState;

		if(ncs<0) {}
		else if (ncs == 3 || ncs == 2) ncs = 3;
		else ncs = 0;
		
		var tabupdate:Boolean = false;
		if (m_TabDown != 0) {
			if (m_TabDown != 2) { m_TabDown = 2; tabupdate = true; }
		} else if (m_TabMouse != -1) { m_TabMouse = -1; tabupdate = true; }

		var pageupdate:Boolean = false;
		if (m_PageDown != 0) {
			if (m_PageDown != 2) { m_PageDown = 2; pageupdate = true; }
		} else if (m_PageMouse != -1) { m_PageMouse = -1; pageupdate = true; }

		if (tabupdate) UpdateTab();
		if (pageupdate) UpdatePage();
		if (ncs != m_CloseState) { m_CloseState = ncs; ButCloseUpdate(); }
	}
	
	public function onMouseWheel(e:MouseEvent):void
	{
		e.stopPropagation();

		if(m_ScrollVis) {
			if (e.delta < 0) {
				m_ScrollItem.position += m_ScrollItem.line;
				m_ScrollItem.sendChange();
			} else if (e.delta > 0) {
				m_ScrollItem.position -= m_ScrollItem.line;
				m_ScrollItem.sendChange();
			}
		}
	}
	
	private function onDeactivate(e:Event):void
	{
		if (m_Drag) {
			onMouseUpDrag(null);
		}

		MouseUnlock();
		
		var tabupdate:Boolean = false;
		if (m_TabMouse != -1) { m_TabMouse = -1; tabupdate = true; }
		if (m_TabDown != 0) { m_TabDown = 0; tabupdate = true; }
		if (tabupdate) UpdateTab();

		var pageupdate:Boolean = false;
		if (m_PageMouse != -1) { m_PageMouse = -1; pageupdate = true; }
		if (m_PageDown != 0) { m_PageDown = 0; pageupdate = true; }
		if (pageupdate) UpdatePage();

		if (m_CloseState > 0) { m_CloseState = 0; ButCloseUpdate(); }
	}

	public function IsViewTabBar():Boolean
	{
		var i:int;
		for (i = 0; i < m_TabArray.length; i++) {
			if (m_TabArray[i].m_Visible) return true;
		}
		return false;
	}

	public function TabSetVisible(i:int, v:Boolean):void
	{
		if (i<0 || i>=m_TabArray.length) return;
		if (m_TabArray[i].m_Visible == v) return;
		m_TabArray[i].m_Visible = v;
		if (visible) { LayerBorderBuild(); LayerTabBuild(); UpdateTab(); LayerPageBuild(); UpdatePage(); LayerItemBuild(); LayerCtrlBuild(); }
	}

	public function TabClear():void
	{
		var i:int;

		m_LayerTab.removeChildren();

		for (i = 0; i < m_TabArray.length; i++) {
			m_TabArray[i].Clear();
		}
		m_TabArray.length = 0;
		
		m_TabActive = -1;
		m_LocTab = -1;
	}
	
	public function TabAdd(str:String):int
	{
		var tab:FormStdTab = new FormStdTab();
		m_TabArray.push(tab);

		tab.m_Caption = new TextField();
		tab.m_Caption.width=1;
		tab.m_Caption.height=1;
		tab.m_Caption.type=TextFieldType.DYNAMIC;
		tab.m_Caption.selectable=false;
		tab.m_Caption.textColor=0xffffff;
		tab.m_Caption.background=false;
		tab.m_Caption.backgroundColor=0x80000000;
		tab.m_Caption.alpha=1.0;
		tab.m_Caption.multiline=false;
		tab.m_Caption.autoSize=TextFieldAutoSize.LEFT;
		tab.m_Caption.gridFitType=GridFitType.PIXEL;
		tab.m_Caption.defaultTextFormat=new TextFormat("Calibri",16,0x000000);
		tab.m_Caption.embedFonts = true;
		tab.m_Caption.mouseEnabled = false;
		tab.m_Caption.htmlText = BaseStr.FormatTag(str == null?"":str.toLowerCase());

		tab.m_Caption.width;

		m_LocTab = m_TabArray.length - 1;
		m_LocPage = -1;
		m_LocCellX = 0;
		m_LocCellY = 0;

		return m_TabArray.length - 1;
	}

	public function LayerTabBuild():void
	{
		var i:int, u:int;
		var s:DisplayObject;
		var s1:DisplayObject, s2:DisplayObject;
		var m:Sprite;
		var tab:FormStdTab;
		var mx:int;

		m_LayerTab.removeChildren();

		if (m_TabArray.length <= 0) return;

		var x:int = 11;
		var y:int = 30;

		s = new bmTabStubLeft() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerTab.addChild(s);
		s.x = x;
		s.y = y;
		x += s.width;

		for (u = 0; u < m_TabArray.length; u++) {
			tab = m_TabArray[u];
			tab.m_Active.length = 0;
			tab.m_Normal.length = 0;
			tab.m_Onmouse.length = 0;
			tab.m_Onpress.length = 0;

			if (!tab.m_Visible) {
				for (i = 0; i < tab.m_Active.length; i++) tab.m_Active[i].visible = false;
				for (i = 0; i < tab.m_Normal.length; i++) tab.m_Normal[i].visible = false;
				for (i = 0; i < tab.m_Onmouse.length; i++) tab.m_Onmouse[i].visible = false;
				for (i = 0; i < tab.m_Onpress.length; i++) tab.m_Onpress[i].visible = false;
				continue;
			}

			mx = 10 + tab.m_Caption.width + 10;
			if (mx < 60) mx = 60;
			
			tab.m_Left = x;
			tab.m_Right = x + mx - 8;
			
			x -= 4;
			
			// active
			s1 = new bmTabActiveLeft() as DisplayObject; (s1 as Bitmap).smoothing = true; m_LayerTab.addChild(s1); tab.m_Active.push(s1);
			s1.x = x;
			s1.y = y - 3;

			tab.m_Up = y - 3;
			tab.m_Down = y + s1.height;

			s2 = new bmTabActiveRight() as DisplayObject; (s2 as Bitmap).smoothing = true; m_LayerTab.addChild(s2); tab.m_Active.push(s2);
			s2.x = x + mx - s2.width;
			s2.y = y - 3;
			
			for (i = s1.x + s1.width; i < s2.x; ) {
				s = new bmTabActiveCenter() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerTab.addChild(s); tab.m_Active.push(s);
				s.x = i;
				s.y = y - 3;
				if (s.width > (s1.x + mx - s2.width - i)) {
					m = new Sprite(); m_LayerTab.addChild(m); tab.m_Active.push(s);
					m.graphics.beginFill(0xfffffff,1);
					m.graphics.drawRect(s.x, s.y, s1.x + mx - s2.width - i, s.height);
					m.graphics.endFill();
					s.mask = m;
				}
				i += s.width;
			}

			// normal
			s1 = new bmTabNormalLeft() as DisplayObject; (s1 as Bitmap).smoothing = true; m_LayerTab.addChild(s1); tab.m_Normal.push(s1);
			s1.x = x;
			s1.y = y - 3;
			
			s2 = new bmTabNormalRight() as DisplayObject; (s2 as Bitmap).smoothing = true; m_LayerTab.addChild(s2); tab.m_Normal.push(s2);
			s2.x = x + mx - s2.width;
			s2.y = y - 3;
			
			for (i = s1.x + s1.width; i < s2.x; ) {
				s = new bmTabNormalCenter() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerTab.addChild(s); tab.m_Normal.push(s);
				s.x = i;
				s.y = y - 3;
				if (s.width > (s1.x + mx - s2.width - i)) {
					m = new Sprite(); m_LayerTab.addChild(m); tab.m_Normal.push(s);
					m.graphics.beginFill(0xfffffff,1);
					m.graphics.drawRect(s.x, s.y, s1.x + mx - s2.width - i, s.height);
					m.graphics.endFill();
					s.mask = m;
				}
				i += s.width;
			}
			
			// onmouse
			s1 = new bmTabOnmouseLeft() as DisplayObject; (s1 as Bitmap).smoothing = true; m_LayerTab.addChild(s1); tab.m_Onmouse.push(s1);
			s1.x = x;
			s1.y = y - 3;
			
			s2 = new bmTabOnmouseRight() as DisplayObject; (s2 as Bitmap).smoothing = true; m_LayerTab.addChild(s2); tab.m_Onmouse.push(s2);
			s2.x = x + mx - s2.width;
			s2.y = y - 3;
			
			for (i = s1.x + s1.width; i < s2.x; ) {
				s = new bmTabOnmouseCenter() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerTab.addChild(s); tab.m_Onmouse.push(s);
				s.x = i;
				s.y = y - 3;
				if (s.width > (s1.x + mx - s2.width - i)) {
					m = new Sprite(); m_LayerTab.addChild(m); tab.m_Onmouse.push(s);
					m.graphics.beginFill(0xfffffff,1);
					m.graphics.drawRect(s.x, s.y, s1.x + mx - s2.width - i, s.height);
					m.graphics.endFill();
					s.mask = m;
				}
				i += s.width;
			}

			// onpress
			s1 = new bmTabOnpressLeft() as DisplayObject; (s1 as Bitmap).smoothing = true; m_LayerTab.addChild(s1); tab.m_Onpress.push(s1);
			s1.x = x;
			s1.y = y - 3;

			s2 = new bmTabOnpressRight() as DisplayObject; (s2 as Bitmap).smoothing = true; m_LayerTab.addChild(s2); tab.m_Onpress.push(s2);
			s2.x = x + mx - s2.width;
			s2.y = y - 3;

			for (i = s1.x + s1.width; i < s2.x; ) {
				s = new bmTabOnpressCenter() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerTab.addChild(s); tab.m_Onpress.push(s);
				s.x = i;
				s.y = y - 3;
				if (s.width > (s1.x + mx - s2.width - i)) {
					m = new Sprite(); m_LayerTab.addChild(m); tab.m_Onpress.push(s);
					m.graphics.beginFill(0xfffffff,1);
					m.graphics.drawRect(s.x, s.y, s1.x + mx - s2.width - i, s.height);
					m.graphics.endFill();
					s.mask = m;
				}
				i += s.width;
			}

			// caption
			m_LayerTab.addChild(tab.m_Caption);

			mx -= 4;
			x += mx;
		}

		mx = m_SizeX - 41;
		for (i = x; i < mx;) {
			s = new bmTabStubCenter() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerTab.addChild(s);
			s.x = i;
			s.y = y - 3;
			if (s.width > (mx - i)) {
				m = new Sprite(); m_LayerTab.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, mx - i, s.height);
				m.graphics.endFill();
				s.mask = m;
				i += mx - i;
			} else {
				i += s.width;
			}
			x = i;
		}

		s = new bmTabStubRight() as DisplayObject; (s as Bitmap).smoothing = true; m_LayerTab.addChild(s);
		s.x = x;
		s.y = y-2;
		x += s.width;
	}

	public function UpdateTab():void
	{
		var i:int, u:int;
		var tab:FormStdTab;
		var d:DisplayObject;

		for (i = 0; i < m_TabArray.length; i++) {
			tab = m_TabArray[i];
			
			for (u = 0; u < tab.m_Active.length; u++) {
				d = tab.m_Active[u];
				d.visible = tab.m_Visible && (m_TabActive == i);
			}

			for (u = 0; u < tab.m_Normal.length; u++) {
				d = tab.m_Normal[u];
				d.visible = tab.m_Visible && (m_TabActive != i) && ((m_TabMouse != i) || m_TabDown == 2);
			}

			for (u = 0; u < tab.m_Onmouse.length; u++) {
				d = tab.m_Onmouse[u];
				d.visible = tab.m_Visible && (m_TabActive != i) && (m_TabMouse == i) && (m_TabDown == 0);
			}

			for (u = 0; u < tab.m_Onpress.length; u++) {
				d = tab.m_Onpress[u];
				d.visible = tab.m_Visible && (m_TabActive != i) && (m_TabMouse == i) && (m_TabDown == 1);
			}
			
			if (m_TabActive == i) tab.m_Caption.textColor = 0x000000;
			else tab.m_Caption.textColor = 0xd5ff66;
			tab.m_Caption.visible = tab.m_Visible;

			tab.m_Caption.x = ((tab.m_Left + tab.m_Right) >> 1) - (tab.m_Caption.width >> 1);
			tab.m_Caption.y = ((tab.m_Up + tab.m_Down) >> 1) - (tab.m_Caption.height >> 1);
		}
	}

	public function PickTab(x:int, y:int):int
	{
		var i:int;
		var tab:FormStdTab;

		for (i = 0; i < m_TabArray.length; i++) {
			tab = m_TabArray[i];
			if (!tab.m_Visible) continue;

			if (x<tab.m_Left || x>=tab.m_Right) continue;
			if (y<tab.m_Up || y>=tab.m_Down) continue;
			return i;
		}
		return -1;
	}

	public function PageClear():void
	{
		var i:int;

		m_LayerPage.removeChildren();

		for (i = 0; i < m_PageArray.length; i++) {
			m_PageArray[i].Clear();
		}
		m_PageArray.length = 0;
		
		m_PageActive = -1;
		m_LocPage = -1;
	}

	public function PageAdd(str:String, tab:int = -1):int
	{
		var p:FormStdPage = new FormStdPage();
		p.m_Tab = tab;
		m_PageArray.push(p);

		p.m_Caption = new TextField();
		p.m_Caption.width=1;
		p.m_Caption.height=1;
		p.m_Caption.type=TextFieldType.DYNAMIC;
		p.m_Caption.selectable=false;
		p.m_Caption.textColor=0xffffff;
		p.m_Caption.background=false;
		p.m_Caption.backgroundColor=0x80000000;
		p.m_Caption.alpha=1.0;
		p.m_Caption.multiline=false;
		p.m_Caption.autoSize=TextFieldAutoSize.LEFT;
		p.m_Caption.gridFitType=GridFitType.PIXEL;
		p.m_Caption.defaultTextFormat=new TextFormat("Calibri",14,0x000000);
		p.m_Caption.embedFonts = true;
		p.m_Caption.mouseEnabled = false;
		p.m_Caption.htmlText = BaseStr.FormatTag(str);

		p.m_Caption.width;
		p.m_Caption.height;
		
		m_LocPage = m_PageArray.length - 1;
		m_LocCellX = 0;
		m_LocCellY = 0;

		return m_PageArray.length - 1;
	}
	
	public function LayerPageBuild():void
	{
		var i:int;
		var p:FormStdPage;

		m_PageWidth = 0;
		m_LayerPage.removeChildren();

		if (m_PageArray.length <= 0) return;

		for (i = 0; i < m_PageArray.length; i++) {
			p = m_PageArray[i];
			p.m_Show = false;
			if (p.m_Tab >= 0 && p.m_Tab != m_TabActive) continue;

			p.m_Show = true;
			m_PageWidth = 1;

			m_LayerPage.addChild(p.m_Caption);
		}
	}
	
	public function UpdatePage():void
	{
		var i:int;
		var p:FormStdPage;

		if (m_PageWidth <= 0) {
			m_LayerPage.graphics.clear();
			return;
		}
		
		m_PageWidth = 1;

		var minx:int = innerLeft;
		var miny:int = innerTop + 20;// IsViewTabBar()?(100):(70);

		var y:int = miny;

		for (i = 0; i < m_PageArray.length; i++) {
			p = m_PageArray[i];
			if (!p.m_Show) continue;
			
			p.m_Left = minx - 10;
			p.m_Up = y;
			p.m_Down = y + p.m_Caption.height;
			
			p.m_Caption.x = minx;
			p.m_Caption.y = y;
			y += p.m_Caption.height;
			if (p.m_Caption.width > m_PageWidth) m_PageWidth = p.m_Caption.width;
		}
		
		if (m_PageWidth < m_PageWidthMin) m_PageWidth = m_PageWidthMin;

		var splitbegin:int = -1;
		var splitend:int = -1;
		for (i = 0; i < m_PageArray.length; i++) {
			p = m_PageArray[i];
			if (!p.m_Show) continue;
			p.m_Right = minx + m_PageWidth + 10;

			if (i == m_PageActive || i != m_PageMouse || m_PageDown == 2) p.m_Caption.textColor = 0x000000;
			else p.m_Caption.textColor = 0x0000ff;

			if (i == m_PageActive) {
				splitbegin = p.m_Up;
				splitend = p.m_Down;
			}
		}

		m_LayerPage.graphics.clear();
		m_LayerPage.graphics.beginFill(0xadab96, 0.5); // 0xbdbba6
		if(splitbegin<0) {
			m_LayerPage.graphics.drawRoundRectComplex(minx - 10, miny - 30, 10 + m_PageWidth + 10, m_SizeY - 30 - (miny - 30), 10, 10, 5, 5);
		} else {
			m_LayerPage.graphics.drawRoundRectComplex(minx - 10, miny - 30, 10 + m_PageWidth + 10, splitbegin - (miny - 30), 10, 10, 0, 0);
			m_LayerPage.graphics.drawRoundRectComplex(minx - 10, splitend, 10 + m_PageWidth + 10, m_SizeY - 30 - splitend, 0, 0, 5, 5);
		}
		m_LayerPage.graphics.endFill();

		m_PageWidth += 20;
	}

	public function PickPage(x:int, y:int):int
	{
		var i:int;
		var p:FormStdPage;

		if (m_PageWidth <= 0) return -1;

		for (i = 0; i < m_PageArray.length; i++) {
			p = m_PageArray[i];
			if (!p.m_Show) continue;

			if (x<p.m_Left || x>=p.m_Right) continue;
			if (y<p.m_Up || y>=p.m_Down) continue;
			return i;
		}
		return -1;
	}
	
	public function GridClear():void
	{
		var i:int;
		var g:FormStdGrid;
		for (i = 0; i < m_GridArray.length; i++) {
			g = m_GridArray[i];
			g.Clear();
		}
		m_GridArray.length = 0;
	}

	public function GridAdd():int
	{
		var g:FormStdGrid = new FormStdGrid();
		m_GridArray.push(g);
		
		m_LocGrid = m_GridArray.length - 1;
		return m_GridArray.length - 1;
	}
	
	public function SetColSize(grid:int, col:int, val:int):void
	{
		if (grid<0 || grid>=m_GridArray.length) return;
		var g:FormStdGrid = m_GridArray[grid];
		
		while (g.m_SizeX.length <= col) g.m_SizeX.push(0);
		g.m_SizeX[col] = val;
	}

	public function SetRowSize(grid:int, row:int, val:int):void
	{
		if (grid<0 || grid>=m_GridArray.length) return;
		var g:FormStdGrid = m_GridArray[grid];
		
		while (g.m_SizeY.length <= row) g.m_SizeY.push(0);
		g.m_SizeY[row] = val;
	}

	public function GridSizeX(grid:int, v0:int, v1:int = -1, v2:int = -1, v3:int = -1, v4:int = -1, v5:int = -1, v6:int = -1, v7:int = -1, clear:Boolean = false):void
	{
		if (grid<0 || grid>=m_GridArray.length) return;
		var g:FormStdGrid = m_GridArray[grid];

		if (clear) g.m_SizeX.length = 0;

		if (v0 >= 0) g.m_SizeX.push(v0);
		if (v1 >= 0) g.m_SizeX.push(v1);
		if (v2 >= 0) g.m_SizeX.push(v2);
		if (v3 >= 0) g.m_SizeX.push(v3);
		if (v4 >= 0) g.m_SizeX.push(v4);
		if (v5 >= 0) g.m_SizeX.push(v5);
		if (v6 >= 0) g.m_SizeX.push(v6);
		if (v7 >= 0) g.m_SizeX.push(v7);
	}

	public function GridSizeY(grid:int, v0:int, v1:int = -1, v2:int = -1, v3:int = -1, v4:int = -1, v5:int = -1, v6:int = -1, v7:int = -1, clear:Boolean = false):void
	{
		if (grid<0 || grid>=m_GridArray.length) return;
		var g:FormStdGrid = m_GridArray[grid];

		if (clear) g.m_SizeY.length = 0;

		if (v0 >= 0) g.m_SizeY.push(v0);
		if (v1 >= 0) g.m_SizeY.push(v1);
		if (v2 >= 0) g.m_SizeY.push(v2);
		if (v3 >= 0) g.m_SizeY.push(v3);
		if (v4 >= 0) g.m_SizeY.push(v4);
		if (v5 >= 0) g.m_SizeY.push(v5);
		if (v6 >= 0) g.m_SizeY.push(v6);
		if (v7 >= 0) g.m_SizeY.push(v7);
	}
	
	public function CtrlClear():void
	{
		var i:int;
		var ctrl:FormStdCtrl;
		
		m_LayerCtrl.removeChildren();
		
		for (i = m_CtrlArray.length - 1; i >= 0; i--) {
			ctrl = m_CtrlArray[i];
			ctrl.Clear();
		}
		m_CtrlArray.length = 0;
	}
	
	public function CtrlAdd(dobj:DisplayObject):int
	{
		var item:FormStdCtrl = new FormStdCtrl();
		item.m_Tab = -1;
		item.m_Page = -1;
		
		item.m_Obj = dobj;
		
		m_CtrlArray.push(item);
		return m_CtrlArray.length - 1;
	}	

	public function CtrlAddPage(dobj:DisplayObject, t:int = -2, p:int = -2):int
	{
		var item:FormStdCtrl = new FormStdCtrl();
		if (t <= -2) item.m_Tab = m_LocTab;
		else item.m_Tab = t;
		if (p <= -2) item.m_Page = m_LocPage;
		else item.m_Page = p;
		
		item.m_Obj = dobj;
		
		m_CtrlArray.push(item);
		return m_CtrlArray.length - 1;
	}	

	public function LayerCtrlBuild():void
	{
		var i:int;
		var ctrl:FormStdCtrl;

		m_LayerCtrl.removeChildren();

		for (i = 0; i < m_CtrlArray.length; i++) {
			ctrl = m_CtrlArray[i];
			ctrl.m_Show = false;
			if (ctrl.m_Obj == null) continue;
			if (ctrl.m_Tab >= 0 && ctrl.m_Tab != m_TabActive) continue;
			if (ctrl.m_Page >= 0 && ctrl.m_Page != m_PageActive) continue;

			m_LayerCtrl.addChild(ctrl.m_Obj);
			ctrl.m_Show = true;
		}
	}
	
	public function ItemClear():void
	{
		var i:int;
		var item:FormStdItem;
		
		m_ScrollVis = false;
		m_ScrollItem.Hide();

		m_LayerItem.removeChildren();

		for (i = 0; i < m_ItemArray.length; i++) {
			item = m_ItemArray[i];
			item.Clear();
		}
		m_ItemArray.length = 0;

		m_LocTab = (m_TabArray.length <= 0)?( -1):(0);
		m_LocPage = (m_PageArray.length <= 0)?( -1):(0);
		m_LocGrid = (m_GridArray.length <= 0)?( -1):(0);
		m_LocCellX = 0;
		m_LocCellY = 0;
		m_LocCntX = 1;
		m_LocCntY = 1;
	}
	
	public function ItemDelete(i:int):void
	{
		if (i<0 || i>=m_ItemArray.length) return;

		var item:FormStdItem = m_ItemArray[i];
		
		if (item.m_Obj != null && m_LayerItem.contains(item.m_Obj)) {
			m_LayerItem.removeChild(item.m_Obj);
//			var u:int = m_LayerItem.getChildIndex(item.m_Obj);
//			if (u >= 0) {
//				m_LayerItem.removeChildAt(u);
//			}
		}
		
		item.Clear();

		m_ItemArray.splice(i, 1);
	}

	private var m_LocTab:int = -1;
	private var m_LocPage:int = -1;
	private var m_LocGrid:int = -1;
	private var m_LocCellX:int = 0;
	private var m_LocCellY:int = 0;
	private var m_LocCntX:int = 1;
	private var m_LocCntY:int = 1;
	
	public function get LocCallX():int { return m_LocCellX; }
	public function get LocCallY():int { return m_LocCellY; }
	
	public function LocCnt(cntx:int, cnty:int = 1):void
	{
		m_LocCntX = (cntx <= 0)?1:cntx;
		m_LocCntY = (cnty <= 0)?1:cnty;
	}

	public function Loc(tab:int, page:int, grid:int, cellx:int, celly:int, cntx:int = 1, cnty:int = 1):void
	{
		m_LocTab = tab;
		m_LocPage = page;
		m_LocGrid = grid;
		m_LocCellX = cellx;
		m_LocCellY = celly;
		m_LocCntX = cntx;
		m_LocCntY = cnty;
	}

	public function LocNextRow(v:int = 1):void
	{
		m_LocCellX = 0;
		m_LocCellY += v;
		if (m_LocCellY < 0) m_LocCellY = 0;
	}

	public function LocNextCol(v:int = 1):void
	{
		m_LocCellX = v;
		if (m_LocCellX < 0) m_LocCellX = 0;
	}

	public function ItemAlign(item:int, alignx:int = 100, aligny:int = 100):void
	{
		if (item<0 || item>=m_ItemArray.length) return;
		m_ItemArray[item].m_AlignX = alignx;
		m_ItemArray[item].m_AlignY = aligny;
	}
	
	public function ItemSpace(item:int, left:int = 0, top:int = 0, right:int = 0, bottom:int = 0):void
	{
		if (item<0 || item>=m_ItemArray.length) return;
		m_ItemArray[item].m_SpaceLeft = left;
		m_ItemArray[item].m_SpaceTop = top;
		m_ItemArray[item].m_SpaceRight = right;
		m_ItemArray[item].m_SpaceBottom = bottom;
	}
	
	public function ItemCell(item:int, cellx:int, celly:int):void
	{
		if (item<0 || item>=m_ItemArray.length) return;
		m_ItemArray[item].m_CellX = cellx;
		m_ItemArray[item].m_CellY = celly;
	}

	public function ItemCellCnt(item:int, cntx:int = 1, cnty:int = 1):void
	{
		if (item<0 || item>=m_ItemArray.length) return;
		m_ItemArray[item].m_CntX = cntx;
		m_ItemArray[item].m_CntY = cnty;
	}

	public function ItemObj(item:int):DisplayObject
	{
		if (item<0 || item>=m_ItemArray.length) return null;
		return m_ItemArray[item].m_Obj;
	}
	
	public function ItemByObj(obj:DisplayObject):int
	{
		var i:int;
		for (i = 0; i < m_ItemArray.length; i++) {
			if (m_ItemArray[i].m_Obj == obj) return i;
		}
		return -1;
	}

	public function ItemUserData(item:int):*
	{
		if (item<0 || item>=m_ItemArray.length) return null;
		return m_ItemArray[item].m_UserData;
	}

	public function ItemUserDataSet(item:int, v:*):void
	{
		if (item<0 || item>=m_ItemArray.length) return;
		m_ItemArray[item].m_UserData = v;
	}

	public function ItemLabel(txt:String, wordwrap:Boolean = false, fsize:int = 13, clr:uint = 0x000000):int
	{
		var item:FormStdItem = new FormStdItem();
		item.m_Tab = m_LocTab;
		item.m_Page = m_LocPage;
		item.m_Grid = m_LocGrid;
		item.m_CellX = m_LocCellX;
		item.m_CellY = m_LocCellY;
		item.m_CntX = m_LocCntX;
		item.m_CntY = m_LocCntY;
		item.m_Type = FormStdItem.TypeLabel;

		var l:TextField = new TextField();
		l.x=0;
		l.y=0;
		l.width=1;
		l.height=1;
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background = false;
		l.multiline = true;
		if (wordwrap) {
			l.wordWrap = true;
		} else {
//			l.multiline = false;
		}
		l.autoSize=TextFieldAutoSize.LEFT;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.SUBPIXEL;
		l.defaultTextFormat = new TextFormat("Calibri", fsize, clr);
		l.embedFonts=true;
		l.htmlText = BaseStr.FormatTag(txt, true, true);

		l.height;
		l.width;

		item.m_Obj = l;
		
		m_LocCellX += 1;// m_LocCntX;

		m_ItemArray.push(item);
		return m_ItemArray.length - 1;
	}

	public function ItemLabelIndent(txt:String, wordwrap:Boolean = false, fsize:int = 13, clr:uint = 0x000000):int
	{
		var item:FormStdItem = new FormStdItem();
		item.m_Tab = m_LocTab;
		item.m_Page = m_LocPage;
		item.m_Grid = m_LocGrid;
		item.m_CellX = m_LocCellX;
		item.m_CellY = m_LocCellY;
		item.m_CntX = m_LocCntX;
		item.m_CntY = m_LocCntY;
		item.m_Type = FormStdItem.TypeLabel;

		var l:TextField = new TextField();
		l.x=0;
		l.y=0;
		l.width=1;
		l.height=1;
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background = false;
		l.multiline = true;
		if (wordwrap) {
			l.wordWrap = true;
		} else {
//			l.multiline = false;
		}
		l.autoSize=TextFieldAutoSize.LEFT;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.SUBPIXEL;
		l.defaultTextFormat = new TextFormat("Calibri", fsize, clr, null, null, null, null, null, null, null, null, 20);
		l.embedFonts=true;
		l.htmlText = BaseStr.FormatTag(txt, true, true);

		l.height;
		l.width;

		item.m_Obj = l;
		
		m_LocCellX += 1;// m_LocCntX;

		m_ItemArray.push(item);
		return m_ItemArray.length - 1;
	}

	public function SimpleLabel(txt:String, wordwrap:Boolean = false, fsize:int = 13, clr:uint = 0x000000):TextField
	{
		var l:TextField = new TextField();
		l.x=0;
		l.y=0;
		l.width=1;
		l.height=1;
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background = false;
		l.multiline = true;
		if (wordwrap) {
			l.wordWrap = true;
		} else {
//			l.multiline = false;
		}
		l.autoSize=TextFieldAutoSize.LEFT;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.SUBPIXEL;
		l.defaultTextFormat = new TextFormat("Calibri", fsize, clr);
		l.embedFonts=true;
		l.htmlText = BaseStr.FormatTag(txt, true, true);

		l.height;
		l.width;
		
		addChild(l);
		
		return l;
	}

	public function ItemCode(txt:String, maxlen:int, digit:Boolean = true, lang:int = 0, pun:Boolean = true, addchar:String = null):int
	{
		var item:FormStdItem = new FormStdItem();
		item.m_Tab = m_LocTab;
		item.m_Page = m_LocPage;
		item.m_Grid = m_LocGrid;
		item.m_CellX = m_LocCellX;
		item.m_CellY = m_LocCellY;
		item.m_CntX = m_LocCntX;
		item.m_CntY = m_LocCntY;
		item.m_Type = FormStdItem.TypeInput;

		var inp:CtrlInput = new CtrlInput(this, true, true);
		inp.setRestrict(maxlen, digit, lang, pun, addchar);
		inp.text = txt;

		inp.height;
		inp.width;

		item.m_Obj = inp;
		
		m_LocCellX += 1;// m_LocCntX;

		m_ItemArray.push(item);
		return m_ItemArray.length - 1;
	}

	public function ItemInput(txt:String, maxlen:int, digit:Boolean = true, lang:int = 0, pun:Boolean = true, addchar:String = null):int
	{
		var item:FormStdItem = new FormStdItem();
		item.m_Tab = m_LocTab;
		item.m_Page = m_LocPage;
		item.m_Grid = m_LocGrid;
		item.m_CellX = m_LocCellX;
		item.m_CellY = m_LocCellY;
		item.m_CntX = m_LocCntX;
		item.m_CntY = m_LocCntY;
		item.m_Type = FormStdItem.TypeInput;

		var inp:CtrlInput = new CtrlInput(this);
		inp.setRestrict(maxlen, digit, lang, pun, addchar);
		inp.text = txt;

		inp.height;
		inp.width;

		item.m_Obj = inp;
		
		m_LocCellX += 1;// m_LocCntX;

		m_ItemArray.push(item);
		return m_ItemArray.length - 1;
	}

	public function ItemBut(txt:String):int
	{
		var item:FormStdItem = new FormStdItem();
		item.m_Tab = m_LocTab;
		item.m_Page = m_LocPage;
		item.m_Grid = m_LocGrid;
		item.m_CellX = m_LocCellX;
		item.m_CellY = m_LocCellY;
		item.m_CntX = m_LocCntX;
		item.m_CntY = m_LocCntY;
		item.m_Type = FormStdItem.TypeBut;

		var b:CtrlBut = new CtrlBut();
		b.caption = txt;

		item.m_Obj = b;

		m_LocCellX += 1;// m_LocCntX;

		m_ItemArray.push(item);
		return m_ItemArray.length - 1;
	}

	public function ItemCheckBox(txt:String):int
	{
		var item:FormStdItem = new FormStdItem();
		item.m_Tab = m_LocTab;
		item.m_Page = m_LocPage;
		item.m_Grid = m_LocGrid;
		item.m_CellX = m_LocCellX;
		item.m_CellY = m_LocCellY;
		item.m_CntX = m_LocCntX;
		item.m_CntY = m_LocCntY;
		item.m_Type = FormStdItem.TypeCheckBox;

		var b:CtrlCheckBox = new CtrlCheckBox();
		b.Caption = txt;

		item.m_Obj = b;

		m_LocCellX += 1;// m_LocCntX;

		m_ItemArray.push(item);
		return m_ItemArray.length - 1;
	}

	public function ItemBox():int
	{
		var item:FormStdItem = new FormStdItem();
		item.m_Tab = m_LocTab;
		item.m_Page = m_LocPage;
		item.m_Grid = m_LocGrid;
		item.m_CellX = m_LocCellX;
		item.m_CellY = m_LocCellY;
		item.m_CntX = m_LocCntX;
		item.m_CntY = m_LocCntY;
		item.m_Type = FormStdItem.TypeCheckBox;

		var b:CtrlBox = new CtrlBox();

		item.m_Obj = b;

		m_LocCellX += 1;// m_LocCntX;

		m_ItemArray.push(item);
		return m_ItemArray.length - 1;
	}

	public function ItemComboBox():int
	{
		var item:FormStdItem = new FormStdItem();
		item.m_Tab = m_LocTab;
		item.m_Page = m_LocPage;
		item.m_Grid = m_LocGrid;
		item.m_CellX = m_LocCellX;
		item.m_CellY = m_LocCellY;
		item.m_CntX = m_LocCntX;
		item.m_CntY = m_LocCntY;
		item.m_Type = FormStdItem.TypeComboBox;

		var cb:CtrlComboBox = new CtrlComboBox();

		cb.height;
		cb.width;

		item.m_Obj = cb;
		
		m_LocCellX += 1;// m_LocCntX;

		m_ItemArray.push(item);
		return m_ItemArray.length - 1;
	}

	static private var m_GIBx:Vector.<int> = new Vector.<int>();
	static private var m_GIBy:Vector.<int> = new Vector.<int>();
	static private var m_WIBx:Vector.<int> = new Vector.<int>();
	static private var m_WIBy:Vector.<int> = new Vector.<int>();
	
	public function LayerItemBuild():void
	{
		LayerItemBuildSys(false);
		
		if (m_ScrollVis) m_ScrollItem.Show();
		else m_ScrollItem.Hide();
	}

	public function LayerItemBuildSys(scroll:Boolean):void
	{
		var i:int, u:int, k:int, v:int, p:int, l:int, sx:int, sy:int, sx_empty:int, sy_empty:int;
		var item:FormStdItem;
		var grid:FormStdGrid;

		m_GIBx.length = 0;
		m_GIBy.length = 0;

		m_LayerItem.removeChildren();

		m_ScrollVis = scroll;

		m_LayerItemMask.x = contentX;// 45 + m_PageWidth;
		m_LayerItemMask.y = contentY;// IsViewTabBar()?(80):(50);
		
		m_WinItemWidth = contentWidth;// m_SizeX - m_LayerItemMask.x - 30;
		m_WinItemHeight = contentHeight;// m_SizeY - m_LayerItemMask.y - 30;
		
		m_LayerItemMask.graphics.clear();
		m_LayerItemMask.graphics.beginFill(0xffffff);
		m_LayerItemMask.graphics.drawRect(0, 0, m_WinItemWidth, m_WinItemHeight);
		m_LayerItemMask.graphics.endFill();

		m_LayerItem.x = m_LayerItemMask.x;
		m_LayerItem.y = m_LayerItemMask.y;

		// Заполняем решётку минимальным размером
		for (i = 0; i < m_ItemArray.length; i++) {
			item = m_ItemArray[i];
			item.m_Show = false;
			if (item.m_Obj == null) continue;
			if (!item.m_Obj.visible) continue;
			if (item.m_CellX < 0 || item.m_CellY < 0) continue;
			if (item.m_CntX <= 0 || item.m_CntY <= 0) continue;
			if (item.m_Tab >= 0 && item.m_Tab != m_TabActive) continue;
			if (item.m_Page >= 0 && item.m_Page != m_PageActive) continue;

			m_LayerItem.addChild(item.m_Obj);
			item.m_Show = true;
			item.m_Obj.width = 0;
			item.m_Obj.height = 0;

			for (u = m_GIBx.length; u < item.m_CellX + item.m_CntX; u++) m_GIBx.push(0);
			for (u = m_GIBy.length; u < item.m_CellY + item.m_CntY; u++) m_GIBy.push(0);

			if (item.m_Grid >= 0 && item.m_Grid < m_GridArray.length) {
				grid = m_GridArray[item.m_Grid];
				for (u = 0; u < item.m_CntX; u++) m_GIBx[item.m_CellX + u] = Math.max(m_GIBx[item.m_CellX + u], ((item.m_CellX + u) < grid.m_SizeX.length)?(grid.m_SizeX[item.m_CellX + u]):(0));
				for (u = 0; u < item.m_CntY; u++) m_GIBy[item.m_CellY + u] = Math.max(m_GIBy[item.m_CellY + u], ((item.m_CellY + u) < grid.m_SizeY.length)?(grid.m_SizeY[item.m_CellY + u]):(0));
			}
		}

		m_WIBx.length = m_GIBx.length;
		m_WIBy.length = m_GIBy.length;
		for (i = 0; i < m_WIBx.length; i++) m_WIBx[i] = m_GIBx[i];
		for (i = 0; i < m_WIBy.length; i++) m_WIBy[i] = m_GIBy[i];

		// сначало все по X
		for (i = 0; i < m_ItemArray.length; i++) {
			item = m_ItemArray[i];
			if (!item.m_Show) continue;

			sx = 0;
			sx_empty = 0;
			for (u = 0; u < item.m_CntX; u++) {
				sx += m_WIBx[item.m_CellX + u];
				if (m_GIBx[item.m_CellX + u] == 0) sx_empty++;
			}

			if ((sx_empty > 0) && ((item.m_Obj.width + item.m_SpaceLeft + item.m_SpaceRight) > sx)) {
				v = item.m_Obj.width + item.m_SpaceLeft + item.m_SpaceRight - sx;
				p = v % sx_empty;
				v = Math.floor(v / sx_empty);

				for (u = 0; u < item.m_CntX; u++) {
					if (m_GIBx[item.m_CellX + u] != 0) continue;
					//m_WIBx[item.m_CellX + u] = Math.max(m_WIBx[item.m_CellX + u], v + ((k < p)?(1):(0)));
					m_WIBx[item.m_CellX + u] += v + ((k < p)?(1):(0));
					k++;
				}
			} else {
				if (item.m_AlignX == 100) {
					item.m_Obj.width = sx - item.m_SpaceLeft - item.m_SpaceRight;
					item.m_Obj.width;
					item.m_Obj.height;
				}
			}
		}
		
		// Последнюю колонку расширяем на всю ширину
		if(m_WIBx.length>0) {
			k = 0;
			for (i = 0; i < m_WIBx.length; i++) k += m_WIBx[i];
			if (k < m_WinItemWidth) m_WIBx[m_WIBx.length - 1] += m_WinItemWidth - k;
		}
		
		// Позиционируем по X
		for (i = 0; i < m_ItemArray.length; i++) {
			item = m_ItemArray[i];
			if (!item.m_Show) continue;

			k = 0;
			l = 0;
			for (u = 0; u < item.m_CellX; u++) k += m_WIBx[u];
			for (; u < item.m_CellX + item.m_CntX; u++) l += m_WIBx[u];

			if (item.m_AlignX == 100) { item.m_Obj.x = k + item.m_SpaceLeft; item.m_Obj.width = l - item.m_SpaceLeft - item.m_SpaceRight; item.m_Obj.width; }
			else if (item.m_AlignX < 0) item.m_Obj.x = k + item.m_SpaceLeft;
			else if (item.m_AlignX == 0) item.m_Obj.x = k +item.m_SpaceLeft + ((l - item.m_SpaceLeft - item.m_SpaceRight) >> 1) - (item.m_Obj.width >> 1);
			else item.m_Obj.x = k + l - item.m_SpaceRight - item.m_Obj.width;
		}

		// затем по Y		
		for (i = 0; i < m_ItemArray.length; i++) {
			item = m_ItemArray[i];
			if (!item.m_Show) continue;
		
			sy = 0;
			sy_empty = 0;
			for (u = 0; u < item.m_CntY; u++) {
				sy += m_WIBy[item.m_CellY + u];
				if (m_GIBy[item.m_CellY + u] == 0) sy_empty++;
			}

			if ((sy_empty > 0) && ((item.m_Obj.height + item.m_SpaceTop + item.m_SpaceBottom) > sy)) {
				v = item.m_Obj.height + item.m_SpaceTop + item.m_SpaceBottom - sy;
				p = v % sy_empty;
				v = Math.floor(v / sy_empty);

				for (u = 0; u < item.m_CntY; u++) {
					if (m_GIBy[item.m_CellY + u] != 0) continue;
					//m_WIBy[item.m_CellY + u] = Math.max(m_WIBy[item.m_CellY + u], v + ((k < p)?(1):(0)));
					m_WIBy[item.m_CellY + u] += v + ((k < p)?(1):(0));
					k++;
				}
			} else {
				if (item.m_AlignY == 100) {
					item.m_Obj.height = sy - item.m_SpaceTop - item.m_SpaceBottom;
					item.m_Obj.width;
					item.m_Obj.height;
				}
			}
		}

		// позиционируем по Y
		for (i = 0; i < m_ItemArray.length; i++) {
			item = m_ItemArray[i];
			if (!item.m_Show) continue;

			k = 0;
			l = 0;
			for (u = 0; u < item.m_CellY; u++) k += m_WIBy[u];
			for (; u < item.m_CellY + item.m_CntY; u++) l += m_WIBy[u];

			if (item.m_AlignY == 100) { item.m_Obj.y = k + item.m_SpaceTop; item.m_Obj.height = l - item.m_SpaceTop - item.m_SpaceBottom; item.m_Obj.height; }
			else if (item.m_AlignY < 0) item.m_Obj.y = k + item.m_SpaceTop;
			else if (item.m_AlignY == 0) item.m_Obj.y = k + item.m_SpaceTop + ((l - item.m_SpaceTop - item.m_SpaceBottom) >> 1) - (item.m_Obj.height >> 1);
			else item.m_Obj.y = k + l - item.m_SpaceBottom - item.m_Obj.height;
			
//trace(item.m_Type, item.m_Obj.x, item.m_Obj.y, item.m_Obj.width, item.m_Obj.height);
		}
		
		l = 0;
		for (u = 0; u < m_WIBy.length; u++) l += m_WIBy[u];

		if (!scroll) {
			if (l > m_WinItemHeight) {
				LayerItemBuildSys(true);
			} else {
				m_ScrollItem.position = 0;
				m_LayerItem.y = m_LayerItemMask.y - m_ScrollItem.position;
			}
		} else {
			m_ScrollItem.x = m_LayerItem.x + m_WinItemWidth + 5;
			m_ScrollItem.y = m_LayerItem.y-2;
			m_ScrollItem.height = m_WinItemHeight + 4;
			m_ScrollItem.setRange(0, l, m_ScrollLine, m_WinItemHeight);
			m_LayerItem.y = m_LayerItemMask.y - m_ScrollItem.position;
		}
	}

	protected function ScrollItemChange(e:Event):void
	{
		m_LayerItem.y = m_LayerItemMask.y - m_ScrollItem.position;
	}
}

}

import flash.display.*;
import flash.text.*;

class FormStdTab
{
	public var m_Caption:TextField = null;
	public var m_Visible:Boolean = true;

	public var m_Left:int = 0;
	public var m_Right:int = 0;
	public var m_Up:int = 0;
	public var m_Down:int = 0;
	public var m_Active:Vector.<DisplayObject> = new Vector.<DisplayObject>();
	public var m_Normal:Vector.<DisplayObject> = new Vector.<DisplayObject>();
	public var m_Onmouse:Vector.<DisplayObject> = new Vector.<DisplayObject>();
	public var m_Onpress:Vector.<DisplayObject> = new Vector.<DisplayObject>();

	public function FormStdTab():void
	{
	}

	public function Clear():void
	{
		m_Caption = null;
		m_Active.length = 0;
		m_Normal.length = 0;
		m_Onmouse.length = 0;
		m_Onpress.length = 0;
	}
}

class FormStdPage
{
	public var m_Tab:int = -1;
	public var m_Caption:TextField = null;

	public var m_Show:Boolean = false;
	public var m_Left:int = 0;
	public var m_Right:int = 0;
	public var m_Up:int = 0;
	public var m_Down:int = 0;

	public function FormStdPage():void
	{
	}

	public function Clear():void
	{
		m_Caption = null;
	}
}

class FormStdGrid
{
	public var m_SizeX:Vector.<int> = new Vector.<int>();
//	public var m_MaxX:Vector.<int> = new Vector.<int>(); // -1 = не увеличивать размер; 0-увиличивать размер если требуется; >0-увиличивать размер если требуется но не больше этого кол-во пикселей
	public var m_SizeY:Vector.<int> = new Vector.<int>();

	public function FormStdGrid():void
	{
	}

	public function Clear():void
	{
	}
}

class FormStdItem
{
	static public const TypeLabel:int = 1;
	static public const TypeBut:int = 2;
	static public const TypeInput:int = 3;
	static public const TypeCheckBox:int = 4;
	static public const TypeComboBox:int = 5;

	public var m_Tab:int = -1;
	public var m_Page:int = -1;
	public var m_Grid:int = -1;
	public var m_CellX:int = 0;
	public var m_CellY:int = 0;
	public var m_CntX:int = 0;
	public var m_CntY:int = 0;

	public var m_SpaceLeft:int = 0;
	public var m_SpaceTop:int = 0;
	public var m_SpaceRight:int = 0;
	public var m_SpaceBottom:int = 0;
	
	public var m_AlignX:int = 100; // -1=left 0=center 1=right 100=stretch
	public var m_AlignY:int = 100; // -1=top 0=center 1=bottom 100=stretch

	public var m_Type:int = 0;
	
	public var m_Show:Boolean = false;

	public var m_Obj:DisplayObject = null;
	
	public var m_UserData:*;

	public function FormStdItem():void
	{
	}

	public function Clear():void
	{
		m_Obj = null;
	}
}

class FormStdCtrl
{
	public var m_Tab:int = -1;
	public var m_Page:int = -1;

	public var m_Show:Boolean = false;

	public var m_Obj:DisplayObject = null;

	public function FormStdItem():void
	{
	}

	public function Clear():void
	{
		m_Obj = null;
	}
}
