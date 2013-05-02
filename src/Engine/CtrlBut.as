// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import Base.*;
import flash.display.*;
import flash.events.*;
import flash.text.*;

public class CtrlBut extends CtrlStd
{
	[Embed(source = '/assets/stdwin/but_normal_center.png')] public var bmNormalCenter:Class;
	[Embed(source = '/assets/stdwin/but_normal_left.png')] public var bmNormalLeft:Class;
	[Embed(source = '/assets/stdwin/but_normal_right.png')] public var bmNormalRight:Class;
	[Embed(source = '/assets/stdwin/but_onmouse_center.png')] public var bmOnmouseCenter:Class;
	[Embed(source = '/assets/stdwin/but_onmouse_left.png')] public var bmOnmouseLeft:Class;
	[Embed(source = '/assets/stdwin/but_onmouse_right.png')] public var bmOnmouseRight:Class;
	[Embed(source = '/assets/stdwin/but_onpress_center.png')] public var bmOnpressCenter:Class;
	[Embed(source = '/assets/stdwin/but_onpress_left.png')] public var bmOnpressLeft:Class;
	[Embed(source = '/assets/stdwin/but_onpress_right.png')] public var bmOnpressRight:Class;
	[Embed(source = '/assets/stdwin/but_disable_center.png')] public var bmDisableCenter:Class;
	[Embed(source = '/assets/stdwin/but_disable_left.png')] public var bmDisableLeft:Class;
	[Embed(source = '/assets/stdwin/but_disable_right.png')] public var bmDisableRight:Class;
	
	[Embed(source = '/assets/stdwin/sb_blue_disable.png')] public var bmBlueDisable:Class;
	[Embed(source = '/assets/stdwin/sb_blue_normal.png')] public var bmBlueNormal:Class;
	[Embed(source = '/assets/stdwin/sb_blue_onmouse.png')] public var bmBlueOnmouse:Class;
	[Embed(source = '/assets/stdwin/sb_blue_onpress.png')] public var bmBlueOnpress:Class;
	[Embed(source = '/assets/stdwin/sb_brown_disable.png')] public var bmBrownDisable:Class;
	[Embed(source = '/assets/stdwin/sb_brown_normal.png')] public var bmBrownNormal:Class;
	[Embed(source = '/assets/stdwin/sb_brown_onmouse.png')] public var bmBrownOnmouse:Class;
	[Embed(source = '/assets/stdwin/sb_brown_onpress.png')] public var bmBrownOnpress:Class;
	[Embed(source = '/assets/stdwin/sb_green_disable.png')] public var bmGreenDisable:Class;
	[Embed(source = '/assets/stdwin/sb_green_normal.png')] public var bmGreenNormal:Class;
	[Embed(source = '/assets/stdwin/sb_green_onmouse.png')] public var bmGreenOnmouse:Class;
	[Embed(source = '/assets/stdwin/sb_green_onpress.png')] public var bmGreenOnpress:Class;
	[Embed(source = '/assets/stdwin/sb_yellow_disable.png')] public var bmYellowDisable:Class;
	[Embed(source = '/assets/stdwin/sb_yellow_normal.png')] public var bmYellowNormal:Class;
	[Embed(source = '/assets/stdwin/sb_yellow_onmouse.png')] public var bmYellowOnmouse:Class;
	[Embed(source = '/assets/stdwin/sb_yellow_onpress.png')] public var bmYellowOnpress:Class;

	[Embed(source = '/assets/stdwin/sb_dots.png')] public var bmDots:Class;
	[Embed(source = '/assets/stdwin/sb_left.png')] public var bmLeft:Class;
	[Embed(source = '/assets/stdwin/sb_right.png')] public var bmRight:Class;
	[Embed(source = '/assets/stdwin/sb_up.png')] public var bmUp:Class;
	[Embed(source = '/assets/stdwin/sb_down.png')] public var bmDown:Class;
	[Embed(source = '/assets/stdwin/sb_minus.png')] public var bmMinus:Class;
	[Embed(source = '/assets/stdwin/sb_plus.png')] public var bmPlus:Class;

	private var m_LayerDisable:Sprite = null;
	private var m_LayerNormal:Sprite = null;
	private var m_LayerOnmouse:Sprite = null;
	private var m_LayerOnpress:Sprite = null;
	private var m_LayerIcon:Sprite = null;
	private var m_Caption:TextField = null;

	private var m_CaptionOffsetY:int = 0;

	private var m_WidthWish:int = 0;
	private var m_Width:int = 0;
	private var m_HeightWish:int = 0;
	private var m_Height:int = 0;
	private var m_Disable:Boolean = false;
	private var m_MouseIn:Boolean = false;
	private var m_Down:Boolean = false;

	private var m_NeedBuild:Boolean = true;
	private var m_NeedUpdate:Boolean = true;
	
	public var m_SkipMenu:Boolean = false;

	private var m_Left:int = 0;
	private var m_Top:int = 0;
	private var m_Right:int = 0;
	private var m_Bottom:int = 0;
	
	public static const IconNone:int = 0;
	public static const IconDots:int = 1;
	public static const IconLeft:int = 2;
	public static const IconRight:int = 3;
	public static const IconUp:int = 4;
	public static const IconDown:int = 5;
	public static const IconMinus:int = 6;
	public static const IconPlus:int = 7;
	
	private var m_Icon:int = 0;
	
	public static const StyleBlue:int = 0;
	public static const StyleBrown:int = 1;
	public static const StyleGreen:int = 2;
	public static const StyleYellow:int = 3;
	
	private var m_Style:int = 0;
	
	public function set captionOffsetY(v:int):void { m_CaptionOffsetY = v; }
	
	public function get captionTF():TextField { return m_Caption; }

	public function set caption(v:String):void
	{
		m_Icon = IconNone;
		
		if (v == null || v.length <= 0) {
			if (!m_Caption.visible) return;
			m_Caption.visible = false;
		} else {
			m_Caption.visible = true;
			m_Caption.htmlText = BaseStr.FormatTag(v);
		}
		m_NeedBuild = true;
	}
	
	public function get icon():int { return m_Icon; }
	
	public function set icon(v:int):void
	{
		if (m_Icon == v) return;
		m_Icon = v;
		m_Caption.visible = false;
		m_NeedBuild = true;
	}

	public function get style():int { return m_Style; }
	
	public function set style(v:int):void
	{
		if (m_Style == v) return;
		m_Style = v;
		m_NeedBuild = true;
	}

	override public function set width(v:Number):void { if (m_WidthWish == v) return; m_WidthWish = v; m_NeedBuild = true; m_NeedUpdate = true; }
	
	public function get disable():Boolean { return m_Disable; }
	public function set disable(v:Boolean):void { if (m_Disable == v) return; m_Disable = v; m_Down = false; m_MouseIn = false; m_NeedUpdate = true; }
	override public function get width():Number	{ if (m_NeedBuild) Build(); return m_Width; }
	override public function set height(v:Number):void { if (m_HeightWish == v) return; m_HeightWish = v; m_NeedBuild = true; m_NeedUpdate = true; }
	override public function get height():Number { if (m_NeedBuild) Build(); return m_Height; }

	public function CtrlBut():void
	{
		m_LayerDisable = new Sprite();
		m_LayerDisable.mouseEnabled = false;
		addChild(m_LayerDisable);

		m_LayerNormal = new Sprite();
		m_LayerNormal.mouseEnabled = false;
		addChild(m_LayerNormal);

		m_LayerOnmouse = new Sprite();
		m_LayerOnmouse.mouseEnabled = false;
		addChild(m_LayerOnmouse);

		m_LayerOnpress = new Sprite();
		m_LayerOnpress.mouseEnabled = false;
		addChild(m_LayerOnpress);

		m_LayerIcon = new Sprite();
		m_LayerIcon.mouseEnabled = false;
		addChild(m_LayerIcon);

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
		m_Caption.defaultTextFormat=new TextFormat("Calibri",14,0xfff9b7);
		m_Caption.embedFonts = true;
		m_Caption.mouseEnabled = false;
		m_Caption.visible = false;
		addChild(m_Caption);

        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(Event.DEACTIVATE, onDeactivate);
		addEventListener(Event.RENDER, onRender);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		addEventListener(MouseEvent.CLICK, onClick);
        //addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

//		CONFIG::mobil {
//			addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
//			addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
//		}

		m_NeedBuild = true;
	}

	public override function beforeHide():void
	{
		super.beforeHide();
		
		MouseUnlock();
		m_NeedBuild = true;
		m_NeedUpdate = true;
	}
	
	private function BuildLayerSliding(layer:Sprite, bmcenter:Class, bmleft:Class, bmright:Class):void
	{
		var i:int;
		var s:DisplayObject;
		var m:Sprite;
		layer.removeChildren();

		var start:int = m_Left + 8;
		var end:int = m_Right - 8;
		for (i = start; i < end; ) {
			s = new bmcenter() as DisplayObject; (s as Bitmap).smoothing = true; layer.addChild(s);
			s.x = i;
			s.y = m_Top;
			if (s.width > (end - i)) {
				m = new Sprite(); layer.addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, end - i, s.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		s = new bmleft() as DisplayObject;
		(s as Bitmap).smoothing = true;
		s.x = m_Left;
		s.y = m_Top;
		layer.addChild(s);

		s = new bmright() as DisplayObject;
		(s as Bitmap).smoothing = true;
		s.x = m_Right - s.width;
		s.y = m_Top;
		layer.addChild(s);
	}
	
	private function BuildLayerImg(layer:Sprite, bmimg:Class, cenetr:Boolean=false):void
	{
		var s:DisplayObject;

		layer.removeChildren();
		
		s = new bmimg() as DisplayObject;
		(s as Bitmap).smoothing = true;
		if (cenetr) {
			s.x = -(s.width >> 1);
			s.y = -(s.height >> 1);
		} else {
			s.x = 0;
			s.y = 0;
		}
		layer.addChild(s);
	}

	private function Build():void
	{
		if (m_Icon) {
			m_Width = m_WidthWish;
			if (m_Width < 27) m_Width = 27;

			m_Height = m_HeightWish;
			if (m_Height < 27) m_Height = 27;

			m_Left = (m_Width >> 1) - (27 >> 1);
			m_Right = m_Left+27;
			m_Top = (m_Height >> 1) - (27 >> 1);
			m_Bottom = m_Top + 27;

			if (m_Style == StyleBlue) {
				BuildLayerImg(m_LayerDisable, bmBlueDisable);
				BuildLayerImg(m_LayerNormal, bmBlueNormal);
				BuildLayerImg(m_LayerOnmouse, bmBlueOnmouse);
				BuildLayerImg(m_LayerOnpress, bmBlueOnpress);
			} else if (m_Style == StyleBrown) {
				BuildLayerImg(m_LayerDisable, bmBrownDisable);
				BuildLayerImg(m_LayerNormal, bmBrownNormal);
				BuildLayerImg(m_LayerOnmouse, bmBrownOnmouse);
				BuildLayerImg(m_LayerOnpress, bmBrownOnpress);
			} else if (m_Style == StyleGreen) {
				BuildLayerImg(m_LayerDisable, bmGreenDisable);
				BuildLayerImg(m_LayerNormal, bmGreenNormal);
				BuildLayerImg(m_LayerOnmouse, bmGreenOnmouse);
				BuildLayerImg(m_LayerOnpress, bmGreenOnpress);
			} else if (m_Style == StyleYellow) {
				BuildLayerImg(m_LayerDisable, bmYellowDisable);
				BuildLayerImg(m_LayerNormal, bmYellowNormal);
				BuildLayerImg(m_LayerOnmouse, bmYellowOnmouse);
				BuildLayerImg(m_LayerOnpress, bmYellowOnpress);
			} else {
				m_LayerDisable.removeChildren();
				m_LayerNormal.removeChildren();
				m_LayerOnmouse.removeChildren();
				m_LayerOnpress.removeChildren();
			}
			
			if (m_Icon == IconDots) BuildLayerImg(m_LayerIcon, bmDots, true);
			else if (m_Icon == IconLeft) BuildLayerImg(m_LayerIcon, bmLeft, true);
			else if (m_Icon == IconRight) BuildLayerImg(m_LayerIcon, bmRight, true);
			else if (m_Icon == IconUp) BuildLayerImg(m_LayerIcon, bmUp, true);
			else if (m_Icon == IconDown) BuildLayerImg(m_LayerIcon, bmDown, true);
			else if (m_Icon == IconMinus) BuildLayerImg(m_LayerIcon, bmMinus, true);
			else if (m_Icon == IconPlus) BuildLayerImg(m_LayerIcon, bmPlus, true);
			else m_LayerIcon.removeChildren();

		} else {
			if(m_Caption.visible) {
				m_Caption.width;
				m_Caption.height;
			}

			m_Width = m_WidthWish;
			if (m_Width < 70) m_Width = 70;
			if(m_Caption.visible) {
				var cw:int = 20 + m_Caption.width + 20;
				if (m_Width < cw) m_Width = cw;
			}

			m_Height = m_HeightWish;
			if (m_Height < 37) m_Height = 37;

			m_Left = 0;
			m_Right = m_Width;
			m_Top = (m_Height >> 1) - (37 >> 1);
			m_Bottom = m_Top + 37;

			BuildLayerSliding(m_LayerDisable, bmDisableCenter, bmDisableLeft, bmDisableRight);
			BuildLayerSliding(m_LayerNormal, bmNormalCenter, bmNormalLeft, bmNormalRight);
			BuildLayerSliding(m_LayerOnmouse, bmOnmouseCenter, bmOnmouseLeft, bmOnmouseRight);
			BuildLayerSliding(m_LayerOnpress, bmOnpressCenter, bmOnpressLeft, bmOnpressRight);
		}
		
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
		m_LayerDisable.visible = m_Disable;
		m_LayerNormal.visible = (!m_Disable) && (!m_MouseIn);
		m_LayerOnmouse.visible = (!m_Disable) && (m_MouseIn) && (!m_Down);
		m_LayerOnpress.visible = (!m_Disable) && (m_MouseIn) && (m_Down);
		
		if(m_Caption.visible) {
			m_Caption.x = (m_Width >> 1) - (m_Caption.width >> 1) + ((m_Down && m_MouseIn)?1:0);
			m_Caption.y = (m_Height >> 1) - (m_Caption.height >> 1) + ((m_Down && m_MouseIn)?1:0) + m_CaptionOffsetY;
		}
		
		m_LayerIcon.x = ((m_Right + m_Left) >> 1) + ((m_Down && m_MouseIn)?1:0);
		m_LayerIcon.y = ((m_Bottom + m_Top) >> 1) + ((m_Down && m_MouseIn)?1:0);
		
		if (m_Disable) { m_Caption.alpha = 0.7; m_LayerIcon.alpha = 0.7; }
		else { m_Caption.alpha = 1.0; m_LayerIcon.alpha = 1.0; }
		
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

//		CONFIG::mobil {
//			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, false, 999);
//			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd, false, 999);

//			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, true, 999);
//			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd, true, 999);
//		}
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

//		CONFIG::mobil {
//			stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, false);
//			stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd, false);
//
//			stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, true);
//			stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd, true);
//		}
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
			if(stage) stage.invalidate();
			//Update();
		}
	}

/*CONFIG::mobil {
	protected function onTouchBegin(event:TouchEvent):void
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

    protected function onTouchEnd(event:TouchEvent):void
    {
		event.stopImmediatePropagation();

		MouseUnlock();

		if (m_Down) {
			m_Down = false;
			m_NeedUpdate = true;
			stage.invalidate();
		}
	}
}*/
	
	private function onDeactivate(event:Event):void
	{
		MouseUnlock();
		if (m_MouseIn || m_Down) {
			m_MouseIn = false;
			m_Down = false;
			m_SkipMenu = false;
			m_NeedUpdate = true;
			if (stage) stage.invalidate();
			//Update();
		}
	}
	
	private function onClick(event:MouseEvent):void
	{
		var skipm:Boolean = m_SkipMenu;
		m_SkipMenu = false;
		if (m_Disable || !m_MouseIn || skipm) {
			event.stopImmediatePropagation();
			return;
		}
	}
	
	public function IsHit(e:MouseEvent):Boolean
	{
		return (mouseX >= m_Left && mouseX < m_Right && mouseY >= m_Top && mouseY < m_Bottom);
	}
}

}