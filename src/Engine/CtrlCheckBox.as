package Engine
{
import Base.*;
import flash.display.*;
import flash.events.*;
import flash.text.*;

public class CtrlCheckBox extends CtrlStd
{
	[Embed(source = '/assets/stdwin/check_off_disable.png')] public var bmOffDisable:Class;
	[Embed(source = '/assets/stdwin/check_off_normal.png')] public var bmOffNormal:Class;
	[Embed(source = '/assets/stdwin/check_off_onmouse.png')] public var bmOffOnmouse:Class;
	[Embed(source = '/assets/stdwin/check_off_onpress.png')] public var bmOffOnpress:Class;
	[Embed(source = '/assets/stdwin/check_on_disable.png')] public var bmOnDisable:Class;
	[Embed(source = '/assets/stdwin/check_on_normal.png')] public var bmOnNormal:Class;
	[Embed(source = '/assets/stdwin/check_on_onmouse.png')] public var bmOnOnmouse:Class;
	[Embed(source = '/assets/stdwin/check_on_onpress.png')] public var bmOnOnpress:Class;
	
	[Embed(source = '/assets/stdwin/minus_disable.png')] public var bmMinusDisable:Class;
	[Embed(source = '/assets/stdwin/minus_normal.png')] public var bmMinusNormal:Class;
	[Embed(source = '/assets/stdwin/minus_onmouse.png')] public var bmMinusOnmouse:Class;
	[Embed(source = '/assets/stdwin/minus_onpress.png')] public var bmMinusOnpress:Class;
	[Embed(source = '/assets/stdwin/plus_disable.png')] public var bmPlusDisable:Class;
	[Embed(source = '/assets/stdwin/plus_normal.png')] public var bmPlusNormal:Class;
	[Embed(source = '/assets/stdwin/plus_onmouse.png')] public var bmPlusOnmouse:Class;
	[Embed(source = '/assets/stdwin/plus_onpress.png')] public var bmPlusOnpress:Class;

	private static var m_OffDisable:Bitmap = null;
	private static var m_OffNormal:Bitmap = null;
	private static var m_OffOnmouse:Bitmap = null;
	private static var m_OffOnpress:Bitmap = null;
	private static var m_OnDisable:Bitmap = null;
	private static var m_OnNormal:Bitmap = null;
	private static var m_OnOnmouse:Bitmap = null;
	private static var m_OnOnpress:Bitmap = null;

	private static var m_OffDisable2:Bitmap = null;
	private static var m_OffNormal2:Bitmap = null;
	private static var m_OffOnmouse2:Bitmap = null;
	private static var m_OffOnpress2:Bitmap = null;
	private static var m_OnDisable2:Bitmap = null;
	private static var m_OnNormal2:Bitmap = null;
	private static var m_OnOnmouse2:Bitmap = null;
	private static var m_OnOnpress2:Bitmap = null;

	private var m_BM:Bitmap = null;
	private var m_Caption:TextField = null;
	
	private var m_Section:Boolean = false;
	private var m_Check:Boolean = false;

	private var m_WidthWish:int = 0;
	private var m_Width:int = 0;
	private var m_HeightWish:int = 0;
	private var m_Height:int = 0;
	private var m_Disable:Boolean = false;
	private var m_MouseIn:Boolean = false;
	private var m_Down:Boolean = false;
	
	private var m_NeedBuild:Boolean = true;
	private var m_NeedUpdate:Boolean = true;
	
	private var m_Left:int = 0;
	private var m_Top:int = 0;
	private var m_Right:int = 0;
	private var m_Bottom:int = 0;
	
	public function set Caption(v:String):void
	{
		if (v == null || v.length <= 0) {
			if (!m_Caption.visible) return;
			m_Caption.visible = false;
		} else {
			m_Caption.visible = true;
			m_Caption.htmlText = BaseStr.FormatTag(v);
		}
		m_NeedBuild = true;
	}

	override public function set width(v:Number):void { if (m_WidthWish == v) return; m_WidthWish = v; m_NeedBuild = true; m_NeedUpdate = true; }
	
	public function get check():Boolean { return m_Check; }
	public function set check(v:Boolean):void { if (m_Check == v) return; m_Check = v; m_NeedUpdate = true; }
	public function get disable():Boolean { return m_Disable; }
	public function set disable(v:Boolean):void { if (m_Disable == v) return; m_Disable = v; m_Down = false; m_MouseIn = false; m_NeedUpdate = true; }
	public function set section(v:Boolean):void { if (m_Section == v) return; m_Section = v; m_NeedUpdate = true; }
	override public function get width():Number	{ if (m_NeedBuild) Build(); return m_Width; }
	override public function set height(v:Number):void { if (m_HeightWish == v) return; m_HeightWish = v; m_NeedBuild = true; m_NeedUpdate = true; }
	override public function get height():Number { if (m_NeedBuild) Build(); return m_Height; }

	public function CtrlCheckBox():void
	{
		if (m_OffDisable == null) m_OffDisable = new bmOffDisable() as Bitmap;
		if (m_OffNormal == null) m_OffNormal = new bmOffNormal() as Bitmap;
		if (m_OffOnmouse == null) m_OffOnmouse = new bmOffOnmouse() as Bitmap;
		if (m_OffOnpress == null) m_OffOnpress = new bmOffOnpress() as Bitmap;
		if (m_OnDisable == null) m_OnDisable = new bmOnDisable() as Bitmap;
		if (m_OnNormal == null) m_OnNormal = new bmOnNormal() as Bitmap;
		if (m_OnOnmouse == null) m_OnOnmouse = new bmOnOnmouse() as Bitmap;
		if (m_OnOnpress == null) m_OnOnpress = new bmOnOnpress() as Bitmap;

		if (m_OnDisable2 == null) m_OnDisable2 = new bmMinusDisable() as Bitmap;
		if (m_OnNormal2 == null) m_OnNormal2 = new bmMinusNormal() as Bitmap;
		if (m_OnOnmouse2 == null) m_OnOnmouse2 = new bmMinusOnmouse() as Bitmap;
		if (m_OnOnpress2 == null) m_OnOnpress2 = new bmMinusOnpress() as Bitmap;
		if (m_OffDisable2 == null) m_OffDisable2 = new bmPlusDisable() as Bitmap;
		if (m_OffNormal2 == null) m_OffNormal2 = new bmPlusNormal() as Bitmap;
		if (m_OffOnmouse2 == null) m_OffOnmouse2 = new bmPlusOnmouse() as Bitmap;
		if (m_OffOnpress2 == null) m_OffOnpress2 = new bmPlusOnpress() as Bitmap;

		(m_OffDisable as Bitmap).smoothing = true;
		(m_OffNormal as Bitmap).smoothing = true;
		(m_OffOnmouse as Bitmap).smoothing = true;
		(m_OffOnpress as Bitmap).smoothing = true;
		(m_OnDisable as Bitmap).smoothing = true;
		(m_OnNormal as Bitmap).smoothing = true;
		(m_OnOnmouse as Bitmap).smoothing = true;
		(m_OnOnpress as Bitmap).smoothing = true;

		(m_OffDisable2 as Bitmap).smoothing = true;
		(m_OffNormal2 as Bitmap).smoothing = true;
		(m_OffOnmouse2 as Bitmap).smoothing = true;
		(m_OffOnpress2 as Bitmap).smoothing = true;
		(m_OnDisable2 as Bitmap).smoothing = true;
		(m_OnNormal2 as Bitmap).smoothing = true;
		(m_OnOnmouse2 as Bitmap).smoothing = true;
		(m_OnOnpress2 as Bitmap).smoothing = true;

		m_BM = new Bitmap();
		addChild(m_BM);

		m_Caption = new TextField();
		m_Caption.width=1;
		m_Caption.height=1;
		m_Caption.type=TextFieldType.DYNAMIC;
		m_Caption.selectable=false;
		m_Caption.textColor=0xffffff;
		m_Caption.background=false;
		m_Caption.backgroundColor=0x80000000;
		m_Caption.alpha=1.0;
		m_Caption.multiline = false;
		m_Caption.antiAliasType = AntiAliasType.ADVANCED;
		m_Caption.autoSize=TextFieldAutoSize.LEFT;
		m_Caption.gridFitType=GridFitType.PIXEL;
		m_Caption.defaultTextFormat=new TextFormat("Calibri",14,0x000000);
		m_Caption.embedFonts = true;
		m_Caption.mouseEnabled = false;
		m_Caption.visible = false;
		addChild(m_Caption);

		hitArea = new Sprite();
		addChild(hitArea);
		hitArea.visible = false;
		hitArea.mouseEnabled = false;

        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(Event.DEACTIVATE, onDeactivate);
		addEventListener(Event.RENDER, onRender);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		addEventListener(MouseEvent.CLICK, onClick);
        //addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

		CONFIG::mobil {
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}

		m_NeedBuild = true;
	}

	public override function beforeHide():void
	{
		super.beforeHide();
		
		MouseUnlock();
		m_NeedBuild = true;
		m_NeedUpdate = true;
	}

	private function Build():void
	{
		if(m_Caption.visible) {
			m_Caption.width;
			m_Caption.height;
		}

		m_Width = m_WidthWish;
		if (m_Width < 27) m_Width = 27;
		if(m_Caption.visible) {
			var cw:int = 27 + 5 + m_Caption.width;
			if (m_Width < cw) m_Width = cw;
		}

		m_Height = m_HeightWish;
		if (m_Height < 27) m_Height = 27;

		m_Left = 0;
		m_Right = m_Width;
		m_Top = (m_Height >> 1) - (27 >> 1);
		m_Bottom = m_Top + 27;
		
		hitArea.graphics.clear();
		hitArea.graphics.beginFill(0, 1);
		hitArea.graphics.drawRect(0, 0, m_Width, m_Height);
		hitArea.graphics.endFill();

		m_NeedBuild = false;
		m_NeedUpdate = true;
	}
	
	private function onRender(event:Event):void
	{
		//trace("rander");
		if (m_NeedBuild) Build();
		if (m_NeedUpdate) Update();
	}
	
	private function onEnterFrame(event:Event):void
	{
		//trace("EnterFrame");
		if (m_NeedBuild) Build();
		if (m_NeedUpdate) Update();
	}

	private function Update():void
	{
		if (m_Check) {
			if (m_Disable) m_BM.bitmapData = m_Section?m_OnDisable2.bitmapData:m_OnDisable.bitmapData;
			else if ((!m_Disable) && (!m_MouseIn)) m_BM.bitmapData = m_Section?m_OnNormal2.bitmapData:m_OnNormal.bitmapData;
			else if ((!m_Disable) && (m_MouseIn) && (!m_Down)) m_BM.bitmapData = m_Section?m_OnOnmouse2.bitmapData:m_OnOnmouse.bitmapData;
			else if ((!m_Disable) && (m_MouseIn) && (m_Down)) m_BM.bitmapData = m_Section?m_OnOnpress2.bitmapData:m_OnOnpress.bitmapData;
		} else {
			if (m_Disable) m_BM.bitmapData = m_Section?m_OffDisable2.bitmapData:m_OffDisable.bitmapData;
			else if ((!m_Disable) && (!m_MouseIn)) m_BM.bitmapData = m_Section?m_OffNormal2.bitmapData:m_OffNormal.bitmapData;
			else if ((!m_Disable) && (m_MouseIn) && (!m_Down)) m_BM.bitmapData = m_Section?m_OffOnmouse2.bitmapData:m_OffOnmouse.bitmapData;
			else if ((!m_Disable) && (m_MouseIn) && (m_Down)) m_BM.bitmapData = m_Section?m_OffOnpress2.bitmapData:m_OffOnpress.bitmapData;
		}
		m_BM.smoothing = true;

		m_BM.x = m_Left;
		m_BM.y = m_Top;

		m_Caption.x = m_BM.x + m_BM.bitmapData.width + 5;
		m_Caption.y = (m_Height >> 1) - (m_Caption.height >> 1);// + ((m_Down && m_MouseIn)?1:0);

		graphics.clear();
		if(m_Section) {
			graphics.beginBitmapFill(CtrlFrame.ImgDots, null, true, false);
			graphics.drawRect(m_Caption.x, m_Caption.y + m_Caption.height, width, 1);
			graphics.endFill();
		}

		m_NeedUpdate = false;
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
		
		CONFIG::mobil {
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, false, 999);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd, false, 999);

			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, true, 999);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd, true, 999);
		}
	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		m_MouseLock = false;
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
//		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,false);
		
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
//		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,true);

		CONFIG::mobil {
			stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, false);
			stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd, false);

			stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, true);
			stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd, true);
		}
	}
	
    protected function onMouseDown(event:MouseEvent):void
    {
		event.stopImmediatePropagation();
		
		if(!m_Disable) {
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

		//stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);

		MouseUnlock();

		if (m_Down) {
			m_Down = false;
			m_NeedUpdate = true;
			stage.invalidate();
			//Update();

//			if ((!m_Disable) && m_MouseIn) {
//				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//			}
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
		if (!m_Disable && m_MouseIn) {
			m_MouseIn = false;
			m_NeedUpdate = true;
			if (stage != null) stage.invalidate();
			//Update();
		}
	}
	
CONFIG::mobil {
	protected function onTouchBegin(event:TouchEvent):void
	{
trace("CtrlCheckBock.onTouchBegin");
		event.stopImmediatePropagation();
		
		if(!m_Disable) {
			m_MouseIn = true;
			m_Down = true;
			m_NeedUpdate = true;
			stage.invalidate();
			MouseLock();
Update();
		}
	}

    protected function onTouchEnd(event:TouchEvent):void
    {
trace("CtrlCheckBock.onTouchEnd");
		event.stopImmediatePropagation();

		MouseUnlock();

		if (m_Down) {
			m_Down = false;
			m_NeedUpdate = true;
			stage.invalidate();
Update();
			
			if ((!m_Disable) && m_MouseIn) {
				m_Check = !m_Check;
				m_NeedBuild = true;
				stage.invalidate();
Update();

				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}

		}
	}
}

	private function onDeactivate(event:Event):void
	{
		MouseUnlock();
		if (m_MouseIn || m_Down) {
			m_MouseIn = false;
			m_Down = false;
			m_NeedUpdate = true;
			stage.invalidate();
			//Update();
		}
	}
	
	private function onClick(event:MouseEvent):void
	{
		if (m_Disable || !m_MouseIn) {
			event.stopImmediatePropagation();
			return;
		}
		m_Check = !m_Check;
		m_NeedBuild = true;
		
		dispatchEvent(new Event(Event.CHANGE));
	}
}
	
}