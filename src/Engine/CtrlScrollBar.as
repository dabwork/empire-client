// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import fl.events.InteractionInputType;
import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.utils.Timer;

public class CtrlScrollBar extends CtrlStd
{
	public static const StyleNone:int = 0;
	public static const StylePopupMenu:int = 1;
	public static const StyleVertical:int = 2;

	private var m_Style:int = StyleNone; // 0-for popup
	private var m_St:CtrlScrollBarStyle = new CtrlScrollBarStyle();

	private var m_WidthWish:int = 0;
	private var m_Width:int = 0;
	private var m_HeightWish:int = 0;
	private var m_Height:int = 0;
	
	private var m_Disable:Boolean = false;
	
	private var m_Min:int = 0;
	private var m_Max:int = 100;
	private var m_Line:int = 1;
	private var m_Page:int = 50;
	private var m_Position:int = 0;

	private var m_CtrlMouse:int = -1; // 0-up 1-down 2-bar 3-pageup 4-pagedown
	private var m_CtrlDown:int = 0; // 0-no 1-down in 2-down out
	
	private var m_BarBegin:int = 0;
	private var m_BarLength:int = 0;

	private var m_Offset:int = 0;
	private var m_Timer:Timer = new Timer(300);

	private var m_NeedBuild:Boolean = true;
	private var m_NeedUpdate:Boolean = true;
	
	private var m_LayerBG:Sprite = new Sprite();
	private var m_LayerBarNormal:Sprite = new Sprite();
	private var m_LayerBarOnmouse:Sprite = new Sprite();
	private var m_LayerBarOnpress:Sprite = new Sprite();
	private var m_LayerBarDisable:Sprite = new Sprite();
	private var m_LayerArrowNormal:Sprite = new Sprite();
	private var m_LayerArrowOnmouse:Sprite = new Sprite();
	private var m_LayerArrowOnpress:Sprite = new Sprite();
	private var m_LayerArrowDisable:Sprite = new Sprite();
	private var m_LayerUpNormal:Sprite = new Sprite();
	private var m_LayerUpOnmouse:Sprite = new Sprite();
	private var m_LayerUpOnpress:Sprite = new Sprite();
	private var m_LayerUpDisable:Sprite = new Sprite();
	private var m_LayerDownNormal:Sprite = new Sprite();
	private var m_LayerDownOnmouse:Sprite = new Sprite();
	private var m_LayerDownOnpress:Sprite = new Sprite();
	private var m_LayerDownDisable:Sprite = new Sprite();

	override public function set width(v:Number):void { if (m_WidthWish == v) return; m_WidthWish = v; m_NeedBuild = true; }
	override public function get width():Number	{ if (m_NeedBuild) Build(); return m_Width; }
	override public function set height(v:Number):void { if (m_HeightWish == v) return; m_HeightWish = v; m_NeedBuild = true; }
	override public function get height():Number { if (m_NeedBuild) Build(); return m_Height; }

	public function set style(v:int):void
	{
		if (m_Style == v) return;
		m_Style = v;
		if (m_Style == StyleNone) m_St = CtrlScrollBarStyle.defStyleNone;
		else if (m_Style == StylePopupMenu) m_St = CtrlScrollBarStyle.defStylePopupMenu;
		else if (m_Style == StyleVertical) m_St = CtrlScrollBarStyle.defStyleVertical;
		else throw("CtrlScrollBar.Style");
		m_NeedBuild = true;
	}

	public function get line():int { return m_Line; }
	public function setRange(min:int, max:int, line:int, page:int):void { if (m_Min == min && m_Max == max && m_Line == line && m_Page == page) return; m_Min = Math.min(min, max); m_Max = Math.max(min, max); m_Page = Math.max(0, Math.min(m_Max - m_Min, page)); m_Line = Math.min(line, m_Max - m_Min); m_NeedBuild = true; }

	public function set position(v:int):void { if (m_Position == v) return; m_Position = v; m_NeedUpdate = true; }
	public function get position():int { if (m_Position < m_Min) return m_Min; if(m_Position+m_Page>m_Max) return m_Max-m_Page; return m_Position; }

	public function CtrlScrollBar():void
	{
		visible = false;

		m_LayerBG.mouseEnabled = false; addChild(m_LayerBG);
		m_LayerBarNormal.mouseEnabled = false; addChild(m_LayerBarNormal);
		m_LayerBarOnmouse.mouseEnabled = false; addChild(m_LayerBarOnmouse);
		m_LayerBarOnpress.mouseEnabled = false; addChild(m_LayerBarOnpress);
		m_LayerBarDisable.mouseEnabled = false; addChild(m_LayerBarDisable);
		m_LayerArrowNormal.mouseEnabled = false; addChild(m_LayerArrowNormal);
		m_LayerArrowOnmouse.mouseEnabled = false; addChild(m_LayerArrowOnmouse);
		m_LayerArrowOnpress.mouseEnabled = false; addChild(m_LayerArrowOnpress);
		m_LayerArrowDisable.mouseEnabled = false; addChild(m_LayerArrowDisable);
		m_LayerUpNormal.mouseEnabled = false; addChild(m_LayerUpNormal);
		m_LayerUpOnmouse.mouseEnabled = false; addChild(m_LayerUpOnmouse);
		m_LayerUpOnpress.mouseEnabled = false; addChild(m_LayerUpOnpress);
		m_LayerUpDisable.mouseEnabled = false; addChild(m_LayerUpDisable);
		m_LayerDownNormal.mouseEnabled = false; addChild(m_LayerDownNormal);
		m_LayerDownOnmouse.mouseEnabled = false; addChild(m_LayerDownOnmouse);
		m_LayerDownOnpress.mouseEnabled = false; addChild(m_LayerDownOnpress);
		m_LayerDownDisable.mouseEnabled = false; addChild(m_LayerDownDisable);

		addEventListener(Event.RENDER, onRender);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		m_Timer.addEventListener(TimerEvent.TIMER, onTimer);
	}
	
	public override function beforeHide():void
	{
		super.beforeHide();
		m_Timer.stop();

		m_NeedBuild = true;
		m_NeedUpdate = true;

		m_CtrlDown = 0;
		m_CtrlMouse = -1;
		MouseUnlock();
	}

	public function Show():void
	{
		if (visible) return;

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

		StdMap.Main.stage.addEventListener(Event.DEACTIVATE, onDeactivate);

		visible = true;
		m_NeedBuild = true;
		m_NeedUpdate = true;
	}

	public function Hide():void
	{
		if (!visible) return;
		visible = false;

		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

		StdMap.Main.stage.removeEventListener(Event.DEACTIVATE, onDeactivate);

		m_Timer.stop();

		m_CtrlDown = 0;
		m_CtrlMouse = -1;
		MouseUnlock();
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
	
	public static function BuildSliding(layer:Sprite, width:int, height:int, left:int, top:int, right:int, bottom:int, horizontal:Boolean, img_begin:BitmapData, img_center:BitmapData, img_end:BitmapData):void
	{
		var i:int, vbegin:int, vend:int;
		var bm:Bitmap;
		var m:Sprite;

		layer.removeChildren();
		
		if(img_begin!=null) {
			bm = new Bitmap();
			bm.bitmapData = img_begin;
			bm.x = left;
			bm.y = top;
			layer.addChild(bm);
		}

		if(img_end!=null) {
			bm = new Bitmap();
			bm.bitmapData = img_end;
			bm.x = width - right - bm.width;
			bm.y = height - bottom - bm.height;
			layer.addChild(bm);
		}
		
		if (img_center != null) {
			if(horizontal) {
				vbegin = left + ((img_begin != null)?img_begin.width:0);
				vend = width - right - ((img_end != null)?img_end.width:0);

				for (i = vbegin; i < vend; ) {
					bm = new Bitmap();
					bm.bitmapData = img_center;
					bm.x = i;
					bm.y = top;
					layer.addChild(bm);

					if (bm.width > (vend - i)) {
						m = new Sprite(); layer.addChild(m);
						m.graphics.beginFill(0xfffffff,1);
						m.graphics.drawRect(bm.x, bm.y, vend - i, bm.height);
						m.graphics.endFill();
						bm.mask = m;
					}

					i += (horizontal)?bm.width:bm.height;
				}
			} else {
				vbegin = top + ((img_begin != null)?img_begin.height:0);
				vend = height - bottom - ((img_end != null)?img_end.height:0);

				for (i = vbegin; i < vend; ) {
					bm = new Bitmap();
					bm.bitmapData = img_center;
					bm.x = left;
					bm.y = i;
					layer.addChild(bm);

					if (bm.height > (vend - i)) {
						m = new Sprite(); layer.addChild(m);
						m.graphics.beginFill(0xfffffff,1);
						m.graphics.drawRect(bm.x, bm.y, bm.width, vend - i);
						m.graphics.endFill();
						bm.mask = m;
					}

					i += (horizontal)?bm.width:bm.height;
				}
			}
		}
	}

	private function Build():void
	{
		var i:int, vbegin:int, vend:int;
		var s:DisplayObject, st:DisplayObject, sb:DisplayObject;
		var bm:Bitmap;
		var m:Sprite;

		if (m_Style == StyleNone) return;

		m_Width = m_WidthWish;
		if (m_Width < m_St.m_WidthMin) m_Width = m_St.m_WidthMin;
		m_Height = m_HeightWish;
		if (m_Height < m_St.m_HeightMin) m_Height = m_St.m_HeightMin;
		
		// Bar
		var size:int = m_Height - m_St.m_Bar_Top - m_St.m_Bar_Bottom;
		if (m_St.m_Horizontal) size = m_Width - m_St.m_Bar_Left - m_St.m_Bar_Right;
		
		if (m_Max <= m_Min || m_Page >= (m_Max - m_Min)) {
			m_BarLength = size;
//			m_BarBegin = 0;
		} else if (m_Page <= 0) {
			m_BarLength = m_St.m_BarMin;
//			m_BarBegin = Math.round(Number(size) * Number(position) / (m_Max - m_Min));
		} else {
			m_BarLength = Math.round(Number(size) * Number(m_Page) / (m_Max - m_Min));
			if (m_BarLength < m_St.m_BarMin) m_BarLength = m_St.m_BarMin;

//			m_BarBegin = Math.round(Number(size) * Number(position) / (m_Max - m_Min - m_Page));
		}

		if (m_BarLength > size) m_BarLength = size;
//		if ((m_BarBegin + m_BarLength) > size) m_BarBegin = size - m_BarLength;

		// BG
		BuildSliding(m_LayerBG, m_Width, m_Height, m_St.m_BG_Left, m_St.m_BG_Top, m_St.m_BG_Right, m_St.m_BG_Bottom, m_St.m_Horizontal, m_St.m_BG_ImgBegin, m_St.m_BG_ImgCenter, m_St.m_BG_ImgEnd);

		// Normal
		//BuildSliding(m_LayerBarNormal, m_Width, m_Height, m_St.m_Bar_Left, m_St.m_Bar_Top, m_St.m_Bar_Right, m_St.m_Bar_Bottom, m_St.m_Horizontal, m_St.m_Normal_ImgTop, m_St.m_Normal_ImgCenter, m_St.m_Normal_ImgBottom);
		if (m_St.m_Horizontal) BuildSliding(m_LayerBarNormal, m_BarLength, m_Height, 0, m_St.m_Bar_Top, 0, m_St.m_Bar_Bottom, m_St.m_Horizontal, m_St.m_Normal_ImgTop, m_St.m_Normal_ImgCenter, m_St.m_Normal_ImgBottom);
		else BuildSliding(m_LayerBarNormal, m_Width, m_BarLength, m_St.m_Bar_Left, 0, m_St.m_Bar_Right, 0, m_St.m_Horizontal, m_St.m_Normal_ImgTop, m_St.m_Normal_ImgCenter, m_St.m_Normal_ImgBottom);

		m_LayerArrowNormal.removeChildren();
		if (m_St.m_Normal_ImgArrow != null) {
			bm = new Bitmap(); m_LayerArrowNormal.addChild(bm); bm.bitmapData = m_St.m_Normal_ImgArrow;
			if (m_St.m_Horizontal) {
				bm.x = ((m_BarLength) >> 1) - (bm.width >> 1) + m_St.m_Arrow_X;
				bm.y = ((m_St.m_Bar_Top + m_Height - m_St.m_Bar_Bottom) >> 1) - (bm.height >> 1) + m_St.m_Arrow_Y;
			} else {
				bm.x = ((m_St.m_Bar_Left + m_Width - m_St.m_Bar_Right) >> 1) - (bm.width >> 1) + m_St.m_Arrow_X;
				bm.y = ((m_BarLength) >> 1) - (bm.height >> 1) + m_St.m_Arrow_Y;
			}
		}

		m_LayerUpNormal.removeChildren();
		if (m_St.m_Normal_ImgUp != null) {
			bm = new Bitmap(); m_LayerUpNormal.addChild(bm); bm.bitmapData = m_St.m_Normal_ImgUp;
			bm.x = m_St.m_Up_Left;
			bm.y = m_St.m_Up_Top;
		}

		m_LayerDownNormal.removeChildren();
		if (m_St.m_Normal_ImgDown != null) {
			bm = new Bitmap(); m_LayerDownNormal.addChild(bm); bm.bitmapData = m_St.m_Normal_ImgDown;
			bm.x = m_Width - m_St.m_Down_Right - bm.width;
			bm.y = m_Height - m_St.m_Down_Bottom - bm.height;
		}
		
		// Onmouse
		//BuildSliding(m_LayerBarOnmouse, m_Width, m_Height, m_St.m_Bar_Left, m_St.m_Bar_Top, m_St.m_Bar_Right, m_St.m_Bar_Bottom, m_St.m_Horizontal, m_St.m_Onmouse_ImgTop, m_St.m_Onmouse_ImgCenter, m_St.m_Onmouse_ImgBottom);
		if (m_St.m_Horizontal) BuildSliding(m_LayerBarOnmouse, m_BarLength, m_Height, 0, m_St.m_Bar_Top, 0, m_St.m_Bar_Bottom, m_St.m_Horizontal, m_St.m_Onmouse_ImgTop, m_St.m_Onmouse_ImgCenter, m_St.m_Onmouse_ImgBottom);
		else BuildSliding(m_LayerBarOnmouse, m_Width, m_BarLength, m_St.m_Bar_Left, 0, m_St.m_Bar_Right, 0, m_St.m_Horizontal, m_St.m_Onmouse_ImgTop, m_St.m_Onmouse_ImgCenter, m_St.m_Onmouse_ImgBottom);

		m_LayerArrowOnmouse.removeChildren();
		if (m_St.m_Onmouse_ImgArrow != null) {
			bm = new Bitmap(); m_LayerArrowOnmouse.addChild(bm); bm.bitmapData = m_St.m_Onmouse_ImgArrow;
			if (m_St.m_Horizontal) {
				bm.x = ((m_BarLength) >> 1) - (bm.width >> 1) + m_St.m_Arrow_X;
				bm.y = ((m_St.m_Bar_Top + m_Height - m_St.m_Bar_Bottom) >> 1) - (bm.height >> 1) + m_St.m_Arrow_Y;
			} else {
				bm.x = ((m_St.m_Bar_Left + m_Width - m_St.m_Bar_Right) >> 1) - (bm.width >> 1) + m_St.m_Arrow_X;
				bm.y = ((m_BarLength) >> 1) - (bm.height >> 1) + m_St.m_Arrow_Y;
			}
		}

		m_LayerUpOnmouse.removeChildren();
		if (m_St.m_Onmouse_ImgUp != null) {
			bm = new Bitmap(); m_LayerUpOnmouse.addChild(bm); bm.bitmapData = m_St.m_Onmouse_ImgUp;
			bm.x = m_St.m_Up_Left;
			bm.y = m_St.m_Up_Top;
		}

		m_LayerDownOnmouse.removeChildren();
		if (m_St.m_Onmouse_ImgDown != null) {
			bm = new Bitmap(); m_LayerDownOnmouse.addChild(bm); bm.bitmapData = m_St.m_Onmouse_ImgDown;
			bm.x = m_Width - m_St.m_Down_Right - bm.width;
			bm.y = m_Height - m_St.m_Down_Bottom - bm.height;
		}

		// Onpress
		//BuildSliding(m_LayerBarOnpress, m_Width, m_Height, m_St.m_Bar_Left, m_St.m_Bar_Top, m_St.m_Bar_Right, m_St.m_Bar_Bottom, m_St.m_Horizontal, m_St.m_Onpress_ImgTop, m_St.m_Onpress_ImgCenter, m_St.m_Onpress_ImgBottom);
		if (m_St.m_Horizontal) BuildSliding(m_LayerBarOnpress, m_BarLength, m_Height, 0, m_St.m_Bar_Top, 0, m_St.m_Bar_Bottom, m_St.m_Horizontal, m_St.m_Onpress_ImgTop, m_St.m_Onpress_ImgCenter, m_St.m_Onpress_ImgBottom);
		else BuildSliding(m_LayerBarOnpress, m_Width, m_BarLength, m_St.m_Bar_Left, 0, m_St.m_Bar_Right, 0, m_St.m_Horizontal, m_St.m_Onpress_ImgTop, m_St.m_Onpress_ImgCenter, m_St.m_Onpress_ImgBottom);

		m_LayerArrowOnpress.removeChildren();
		if (m_St.m_Onpress_ImgArrow != null) {
			bm = new Bitmap(); m_LayerArrowOnpress.addChild(bm); bm.bitmapData = m_St.m_Onpress_ImgArrow;
			if (m_St.m_Horizontal) {
				bm.x = ((m_BarLength) >> 1) - (bm.width >> 1) + m_St.m_Arrow_X;
				bm.y = ((m_St.m_Bar_Top + m_Height - m_St.m_Bar_Bottom) >> 1) - (bm.height >> 1) + m_St.m_Arrow_Y;
			} else {
				bm.x = ((m_St.m_Bar_Left + m_Width - m_St.m_Bar_Right) >> 1) - (bm.width >> 1) + m_St.m_Arrow_X;
				bm.y = ((m_BarLength) >> 1) - (bm.height >> 1) + m_St.m_Arrow_Y;
			}
		}

		m_LayerUpOnpress.removeChildren();
		if (m_St.m_Onpress_ImgUp != null) {
			bm = new Bitmap(); m_LayerUpOnpress.addChild(bm); bm.bitmapData = m_St.m_Onpress_ImgUp;
			bm.x = m_St.m_Up_Left;
			bm.y = m_St.m_Up_Top;
		}

		m_LayerDownOnpress.removeChildren();
		if (m_St.m_Onpress_ImgDown != null) {
			bm = new Bitmap(); m_LayerDownOnpress.addChild(bm); bm.bitmapData = m_St.m_Onpress_ImgDown;
			bm.x = m_Width - m_St.m_Down_Right - bm.width;
			bm.y = m_Height - m_St.m_Down_Bottom - bm.height;
		}

		// Disable
		//BuildSliding(m_LayerBarDisable, m_Width, m_Height, m_St.m_Bar_Left, m_St.m_Bar_Top, m_St.m_Bar_Right, m_St.m_Bar_Bottom, m_St.m_Horizontal, m_St.m_Disable_ImgTop, m_St.m_Disable_ImgCenter, m_St.m_Disable_ImgBottom);
		if (m_St.m_Horizontal) BuildSliding(m_LayerBarDisable, m_BarLength, m_Height, 0, m_St.m_Bar_Top, 0, m_St.m_Bar_Bottom, m_St.m_Horizontal, m_St.m_Disable_ImgTop, m_St.m_Disable_ImgCenter, m_St.m_Disable_ImgBottom);
		else BuildSliding(m_LayerBarDisable, m_Width, m_BarLength, m_St.m_Bar_Left, 0, m_St.m_Bar_Right, 0, m_St.m_Horizontal, m_St.m_Disable_ImgTop, m_St.m_Disable_ImgCenter, m_St.m_Disable_ImgBottom);

		m_LayerArrowDisable.removeChildren();
		if (m_St.m_Disable_ImgArrow != null) {
			bm = new Bitmap(); m_LayerArrowDisable.addChild(bm); bm.bitmapData = m_St.m_Disable_ImgArrow;
			if (m_St.m_Horizontal) {
				bm.x = ((m_BarLength) >> 1) - (bm.width >> 1) + m_St.m_Arrow_X;
				bm.y = ((m_St.m_Bar_Top + m_Height - m_St.m_Bar_Bottom) >> 1) - (bm.height >> 1) + m_St.m_Arrow_Y;
			} else {
				bm.x = ((m_St.m_Bar_Left + m_Width - m_St.m_Bar_Right) >> 1) - (bm.width >> 1) + m_St.m_Arrow_X;
				bm.y = ((m_BarLength) >> 1) - (bm.height >> 1) + m_St.m_Arrow_Y;
			}
		}

		m_LayerUpDisable.removeChildren();
		if (m_St.m_Disable_ImgUp != null) {
			bm = new Bitmap(); m_LayerUpDisable.addChild(bm); bm.bitmapData = m_St.m_Disable_ImgUp;
			bm.x = m_St.m_Up_Left;
			bm.y = m_St.m_Up_Top;
		}

		m_LayerDownDisable.removeChildren();
		if (m_St.m_Disable_ImgDown != null) {
			bm = new Bitmap(); m_LayerDownDisable.addChild(bm); bm.bitmapData = m_St.m_Disable_ImgDown;
			bm.x = m_Width - m_St.m_Down_Right - bm.width;
			bm.y = m_Height - m_St.m_Down_Bottom - bm.height;
		}

		m_NeedBuild = false;
		m_NeedUpdate = true;
	}

	public function styleWidthMin():int { if (m_Style == StylePopupMenu ) return 25; return 0; }
	public function styleHeightMin():int { if (m_Style == StylePopupMenu) return 100; return 0; }

	private function Update():void
	{
		var size:int = m_Height - m_St.m_Bar_Top - m_St.m_Bar_Bottom;
		if (m_St.m_Horizontal) size = m_Width - m_St.m_Bar_Left - m_St.m_Bar_Right;

		if (m_Max <= m_Min || m_Page >= (m_Max - m_Min)) {
			m_BarLength = size;
			m_BarBegin = 0;
		} else if (m_Page <= 0) {
			m_BarBegin = Math.round(Number(size - m_BarLength) * Number(position) / (m_Max - m_Min));
		} else {
			m_BarBegin = Math.round(Number(size - m_BarLength) * Number(position) / (m_Max - m_Min - m_Page));
		}

		if ((m_BarBegin + m_BarLength) > size) m_BarBegin = size - m_BarLength;

		if (m_St.m_Horizontal) {
			m_LayerBarNormal.x = m_St.m_Bar_Left + m_BarBegin;
			m_LayerBarOnmouse.x = m_LayerBarNormal.x;
			m_LayerBarOnpress.x = m_LayerBarNormal.x;
			m_LayerBarDisable.x = m_LayerBarNormal.x;

			m_LayerArrowNormal.x = m_LayerBarNormal.x;
			m_LayerArrowOnmouse.x = m_LayerBarOnmouse.x;
			m_LayerArrowOnpress.x = m_LayerBarOnpress.x;
			m_LayerArrowDisable.x = m_LayerBarDisable.x;
		} else {
			m_LayerBarNormal.y = m_St.m_Bar_Top + m_BarBegin;
			m_LayerBarOnmouse.y = m_LayerBarNormal.y;
			m_LayerBarOnpress.y = m_LayerBarNormal.y;
			m_LayerBarDisable.y = m_LayerBarNormal.y;

			m_LayerArrowNormal.y = m_LayerBarNormal.y;
			m_LayerArrowOnmouse.y = m_LayerBarOnmouse.y;
			m_LayerArrowOnpress.y = m_LayerBarOnpress.y;
			m_LayerArrowDisable.y = m_LayerBarDisable.y;
		}

		m_LayerBarNormal.visible = (!m_Disable) && ((m_CtrlMouse != 2) || (m_CtrlDown == 2));
		m_LayerBarOnmouse.visible = (!m_Disable) && (m_CtrlMouse == 2) && (m_CtrlDown == 0);
		m_LayerBarOnpress.visible = (!m_Disable) && (m_CtrlMouse == 2) && (m_CtrlDown == 1);
		m_LayerBarDisable.visible = m_Disable;

		m_LayerUpNormal.visible = (!m_Disable) && ((m_CtrlMouse != 0) || (m_CtrlDown == 2));
		m_LayerUpOnmouse.visible = (!m_Disable) && (m_CtrlMouse == 0) && (m_CtrlDown == 0);
		m_LayerUpOnpress.visible = (!m_Disable) && (m_CtrlMouse == 0) && (m_CtrlDown == 1);
		m_LayerUpDisable.visible = m_Disable;

		m_LayerDownNormal.visible = (!m_Disable) && ((m_CtrlMouse != 1) || (m_CtrlDown == 2));
		m_LayerDownOnmouse.visible = (!m_Disable) && (m_CtrlMouse == 1) && (m_CtrlDown == 0);
		m_LayerDownOnpress.visible = (!m_Disable) && (m_CtrlMouse == 1) && (m_CtrlDown == 1);
		m_LayerDownDisable.visible = m_Disable;
		
		m_LayerArrowNormal.visible = m_LayerBarNormal.visible;
		m_LayerArrowOnmouse.visible = m_LayerBarOnmouse.visible;
		m_LayerArrowOnpress.visible = m_LayerBarOnpress.visible;
		m_LayerArrowDisable.visible = m_LayerBarDisable.visible;

		m_NeedUpdate = false;
	}

	private var m_MouseLock:Boolean = false;

	public function MouseLock():void
	{
		if (m_MouseLock) return;
		if (stage == null) return;
		m_MouseLock = true;
		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,999);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, false, 999);
		//stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,false,999);

		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,true,999);
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,true,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 999);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, true, 999);
		//stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,true,999);
	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		if (stage == null) return;
		m_MouseLock = false;
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, false);
		//stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,false);

		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
		stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown, true);
		//stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,true);
	}

	public function PickCtrl(x:int, y:int):int
	{
		if (x >= m_St.m_Up_Left && 
			x < (m_St.m_Up_Left + m_St.m_Up_Width) && 
			y >= m_St.m_Up_Top && 
			y < (m_St.m_Up_Top + m_St.m_Up_Height)) return 0;

		if (x >= (m_Width - m_St.m_Down_Right - m_St.m_Down_Width) && 
			x < (m_Width - m_St.m_Down_Right) &&
			y >= (m_Height - m_St.m_Down_Bottom - m_St.m_Down_Height) && 
			y < (m_Height - m_St.m_Down_Bottom)) return 1;

		if (m_St.m_Horizontal) {
			if (x >= (m_St.m_Bar_Left + m_BarBegin) &&
				x < (m_St.m_Bar_Left + m_BarBegin + m_BarLength) &&
				y >= m_St.m_Bar_Top &&
				y < (m_Height - m_St.m_Bar_Bottom)) return 2;
		} else {
			if (x >= m_St.m_Bar_Left &&
				x < (m_Width - m_St.m_Bar_Right) &&
				y >= (m_St.m_Bar_Top + m_BarBegin) &&
				y < (m_St.m_Bar_Top + m_BarBegin + m_BarLength)) return 2;
		}

		return -1;
	}

	protected function onRightMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		Hide();
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopPropagation();
		
		var ctrl:int = PickCtrl(mouseX, mouseY);
		if (ctrl >= 0) {
			m_CtrlMouse = ctrl;
			m_CtrlDown = 1;
			m_NeedUpdate = true;
			if(m_CtrlMouse==0 || m_CtrlMouse==1) {
				onTimer();
				m_Timer.delay = 300;
				m_Timer.start();
			} else if (m_CtrlMouse == 2) {
				if(m_St.m_Horizontal) m_Offset = (m_St.m_Bar_Left + m_BarBegin) - mouseX;
				else m_Offset = (m_St.m_Bar_Top + m_BarBegin) - mouseY;
			}
			MouseLock();
		}
	}

	protected function onMouseUp(e:MouseEvent):void
	{
		var ef:Boolean;

		e.stopPropagation();

		if (m_CtrlDown != 0) {
			ef = false;
			if (m_CtrlDown == 2) m_CtrlMouse = -1;
			else {
				ef = true;
			}
			m_CtrlDown = 0;
			m_NeedUpdate = true;
			m_Timer.stop();
			MouseUnlock();
			//if (ef) dispatchEvent(new Event("page"));
			return;
		}
	}

	private function onMouseMove(e:MouseEvent):void
	{
		e.stopPropagation();

		if (m_CtrlMouse == 2 && m_CtrlDown == 1) {
			var p:int = m_Position;
			if (m_St.m_Horizontal) p = Math.round(Number(m_Max - m_Min - m_Page) * Number(mouseY + m_Offset - m_St.m_Bar_Left) / (m_Width - m_St.m_Bar_Left - m_St.m_Bar_Right - m_BarLength));
			else p = Math.round(Number(m_Max - m_Min - m_Page) * Number(mouseY + m_Offset - m_St.m_Bar_Top) / (m_Height - m_St.m_Bar_Top - m_St.m_Bar_Bottom - m_BarLength));

			if (p < m_Min) p = m_Min;
			else if (p > m_Max - m_Page) p = m_Max - m_Page;
			
			if (p != m_Position) {
				m_Position = p;
				m_NeedUpdate = true;
				
				sendChange();
			}
			return;
		}

		var ctrlmouse:int = PickCtrl(mouseX, mouseY);
		if (m_CtrlDown != 0) {
			if (ctrlmouse == m_CtrlMouse && m_CtrlDown != 1) { m_CtrlDown = 1; m_NeedUpdate = true; }
			else if(ctrlmouse != m_CtrlMouse && m_CtrlDown != 2) { m_CtrlDown = 2; m_NeedUpdate = true; }
		} else if (ctrlmouse != m_CtrlMouse) { m_CtrlMouse = ctrlmouse; m_NeedUpdate = true; }
	}

	private function onMouseOut(e:MouseEvent):void
	{
		if (m_CtrlMouse == 2 && m_CtrlDown == 1) return;
		
		if (m_CtrlDown != 0) {
			if (m_CtrlDown != 2) { m_CtrlDown = 2; m_NeedUpdate = true; }
		} else if (m_CtrlMouse != -1) { m_CtrlMouse = -1; m_NeedUpdate = true; }
	}
	
	private function onDeactivate(e:Event):void
	{
		m_Timer.stop();
		MouseUnlock();
		if (m_CtrlMouse != -1 || m_CtrlDown != 0) {
			m_CtrlMouse = -1;
			m_CtrlDown = 0;
			m_NeedUpdate = true;
		}
	}
	
	private function onTimer(event:TimerEvent = null):void
	{
		m_Timer.delay = 50;
		if (m_CtrlMouse == 0 && m_CtrlDown == 1) {
			if(m_Position>m_Min) {
				m_Position = position - m_Line;
				if (m_Position < m_Min) m_Position = m_Min;
				m_NeedUpdate = true;

				sendChange();
			}

		} else if (m_CtrlMouse == 1 && m_CtrlDown == 1) {
			if (m_Position < m_Max + m_Page) {
				m_Position = position + m_Line;
				if (m_Position > m_Max + m_Page) m_Position = m_Max - m_Page;
				m_NeedUpdate = true;

				sendChange();
			}
		}
	}
	
	public function sendChange():void
	{
		dispatchEvent(new Event(Event.CHANGE));
	}
}

}
	
import Engine.*;
import com.adobe.utils.IntUtil;
import flash.display.*;
import flash.events.*;
import flash.text.*;

class CtrlScrollBarStyle
{
	////
	[Embed(source = '/assets/stdwin/popup_scroll_bg_top.png')] public var bmPopupScrollBgTop:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_bg_center.png')] public var bmPopupScrollBgCenter:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_bg_bottom.png')] public var bmPopupScrollBgBottom:Class;
	
	[Embed(source = '/assets/stdwin/popup_scroll_normal_up.png')] public var bmPopupScrollNormalUp:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_normal_down.png')] public var bmPopupScrollNormalDown:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_normal_arrow.png')] public var bmPopupScrollNormalArrow:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_normal_top.png')] public var bmPopupScrollNormalTop:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_normal_center.png')] public var bmPopupScrollNormalCenter:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_normal_bottom.png')] public var bmPopupScrollNormalBottom:Class;

	[Embed(source = '/assets/stdwin/popup_scroll_onmouse_up.png')] public var bmPopupScrollOnmouseUp:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onmouse_down.png')] public var bmPopupScrollOnmouseDown:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onmouse_arrow.png')] public var bmPopupScrollOnmouseArrow:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onmouse_top.png')] public var bmPopupScrollOnmouseTop:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onmouse_center.png')] public var bmPopupScrollOnmouseCenter:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onmouse_bottom.png')] public var bmPopupScrollOnmouseBottom:Class;

	[Embed(source = '/assets/stdwin/popup_scroll_onpress_up.png')] public var bmPopupScrollOnpressUp:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onpress_down.png')] public var bmPopupScrollOnpressDown:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onpress_arrow.png')] public var bmPopupScrollOnpressArrow:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onpress_top.png')] public var bmPopupScrollOnpressTop:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onpress_center.png')] public var bmPopupScrollOnpressCenter:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_onpress_bottom.png')] public var bmPopupScrollOnpressBottom:Class;

	[Embed(source = '/assets/stdwin/popup_scroll_disable_up.png')] public var bmPopupScrollDisableUp:Class;
	[Embed(source = '/assets/stdwin/popup_scroll_disable_down.png')] public var bmPopupScrollDisableDown:Class;

	////
	[Embed(source = '/assets/stdwin/v_scroll_bg_top.png')] public var bmVeScrollBgTop:Class;
	[Embed(source = '/assets/stdwin/v_scroll_bg_center.png')] public var bmVeScrollBgCenter:Class;
	[Embed(source = '/assets/stdwin/v_scroll_bg_bottom.png')] public var bmVeScrollBgBottom:Class;
	
	[Embed(source = '/assets/stdwin/v_scroll_normal_up.png')] public var bmVeScrollNormalUp:Class;
	[Embed(source = '/assets/stdwin/v_scroll_normal_down.png')] public var bmVeScrollNormalDown:Class;
	[Embed(source = '/assets/stdwin/v_scroll_normal_arrow.png')] public var bmVeScrollNormalArrow:Class;
	[Embed(source = '/assets/stdwin/v_scroll_normal_top.png')] public var bmVeScrollNormalTop:Class;
	[Embed(source = '/assets/stdwin/v_scroll_normal_center.png')] public var bmVeScrollNormalCenter:Class;
	[Embed(source = '/assets/stdwin/v_scroll_normal_bottom.png')] public var bmVeScrollNormalBottom:Class;

	[Embed(source = '/assets/stdwin/v_scroll_onmouse_up.png')] public var bmVeScrollOnmouseUp:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onmouse_down.png')] public var bmVeScrollOnmouseDown:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onmouse_arrow.png')] public var bmVeScrollOnmouseArrow:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onmouse_top.png')] public var bmVeScrollOnmouseTop:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onmouse_center.png')] public var bmVeScrollOnmouseCenter:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onmouse_bottom.png')] public var bmVeScrollOnmouseBottom:Class;

	[Embed(source = '/assets/stdwin/v_scroll_onpress_up.png')] public var bmVeScrollOnpressUp:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onpress_down.png')] public var bmVeScrollOnpressDown:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onpress_arrow.png')] public var bmVeScrollOnpressArrow:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onpress_top.png')] public var bmVeScrollOnpressTop:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onpress_center.png')] public var bmVeScrollOnpressCenter:Class;
	[Embed(source = '/assets/stdwin/v_scroll_onpress_bottom.png')] public var bmVeScrollOnpressBottom:Class;

	[Embed(source = '/assets/stdwin/v_scroll_disable_up.png')] public var bmVeScrollDisableUp:Class;
	[Embed(source = '/assets/stdwin/v_scroll_disable_down.png')] public var bmVeScrollDisableDown:Class;

	public var m_Horizontal:Boolean = false;
	public var m_WidthMin:int = 10;
	public var m_HeightMin:int = 10;
	public var m_BarMin:int = 1;
	
	public var m_BG_Left:int = 0;
	public var m_BG_Top:int = 0;
	public var m_BG_Right:int = 0;
	public var m_BG_Bottom:int = 0;
	
	public var m_Arrow_X:int = 0;
	public var m_Arrow_Y:int = 0;
	
	public var m_Up_Left:int = 0;
	public var m_Up_Top:int = 0;
	public var m_Up_Width:int = 0;
	public var m_Up_Height:int = 0;
	
	public var m_Down_Right:int = 0;
	public var m_Down_Bottom:int = 0;
	public var m_Down_Width:int = 0;
	public var m_Down_Height:int = 0;
	
	public var m_Bar_Left:int = 0;
	public var m_Bar_Top:int = 0;
	public var m_Bar_Right:int = 0;
	public var m_Bar_Bottom:int = 0;

	public var m_BG_ImgBegin:BitmapData = null;
	public var m_BG_ImgCenter:BitmapData = null;
	public var m_BG_ImgEnd:BitmapData = null;
	
	public var m_Normal_ImgUp:BitmapData = null;
	public var m_Normal_ImgDown:BitmapData = null;
	public var m_Normal_ImgArrow:BitmapData = null;
	public var m_Normal_ImgTop:BitmapData = null;
	public var m_Normal_ImgCenter:BitmapData = null;
	public var m_Normal_ImgBottom:BitmapData = null;

	public var m_Onmouse_ImgUp:BitmapData = null;
	public var m_Onmouse_ImgDown:BitmapData = null;
	public var m_Onmouse_ImgArrow:BitmapData = null;
	public var m_Onmouse_ImgTop:BitmapData = null;
	public var m_Onmouse_ImgCenter:BitmapData = null;
	public var m_Onmouse_ImgBottom:BitmapData = null;
	
	public var m_Onpress_ImgUp:BitmapData = null;
	public var m_Onpress_ImgDown:BitmapData = null;
	public var m_Onpress_ImgArrow:BitmapData = null;
	public var m_Onpress_ImgTop:BitmapData = null;
	public var m_Onpress_ImgCenter:BitmapData = null;
	public var m_Onpress_ImgBottom:BitmapData = null;

	public var m_Disable_ImgUp:BitmapData = null;
	public var m_Disable_ImgDown:BitmapData = null;
	public var m_Disable_ImgArrow:BitmapData = null;
	public var m_Disable_ImgTop:BitmapData = null;
	public var m_Disable_ImgCenter:BitmapData = null;
	public var m_Disable_ImgBottom:BitmapData = null;

	public static const defStyleNone:CtrlScrollBarStyle = new CtrlScrollBarStyle(CtrlScrollBar.StyleNone);
	public static const defStylePopupMenu:CtrlScrollBarStyle = new CtrlScrollBarStyle(CtrlScrollBar.StylePopupMenu);
	public static const defStyleVertical:CtrlScrollBarStyle = new CtrlScrollBarStyle(CtrlScrollBar.StyleVertical);

	public function CtrlScrollBarStyle(s:int=CtrlScrollBar.StyleNone):void
	{
		Init(s);
	}

	public function Clear():void
	{
		m_Horizontal = false;
		m_WidthMin = 10;
		m_HeightMin = 10;
		m_BarMin = 1;

		m_BG_Left = 0;
		m_BG_Top = 0;
		m_BG_Right = 0;
		m_BG_Bottom = 0;
		
		m_Arrow_X = 0;
		m_Arrow_Y = 0;
		
		m_Up_Left = 0;
		m_Up_Top = 0;
		m_Up_Width = 0;
		m_Up_Height = 0;
	
		m_Down_Right = 0;
		m_Down_Bottom = 0;
		m_Down_Width = 0;
		m_Down_Height = 0;

		m_Bar_Left = 0;
		m_Bar_Top = 0;
		m_Bar_Right = 0;
		m_Bar_Bottom = 0;

		m_BG_ImgBegin = null;
		m_BG_ImgCenter = null;
		m_BG_ImgEnd = null;
	
		m_Normal_ImgUp = null;
		m_Normal_ImgDown = null;
		m_Normal_ImgArrow = null;
		m_Normal_ImgTop = null;
		m_Normal_ImgCenter = null;
		m_Normal_ImgBottom = null;

		m_Onmouse_ImgUp = null;
		m_Onmouse_ImgDown = null;
		m_Onmouse_ImgArrow = null;
		m_Onmouse_ImgTop = null;
		m_Onmouse_ImgCenter = null;
		m_Onmouse_ImgBottom = null;
	
		m_Onpress_ImgUp = null;
		m_Onpress_ImgDown = null;
		m_Onpress_ImgArrow = null;
		m_Onpress_ImgTop = null;
		m_Onpress_ImgCenter = null;
		m_Onpress_ImgBottom = null;

		m_Disable_ImgUp = null;
		m_Disable_ImgDown = null;
		m_Disable_ImgArrow = null;
		m_Disable_ImgTop = null;
		m_Disable_ImgCenter = null;
		m_Disable_ImgBottom = null;
	}

	public function Init(s:int):void
	{
		Clear();

		if (s == CtrlScrollBar.StylePopupMenu) {
			m_WidthMin = 25;
			m_HeightMin = 100;

			m_BarMin = 25;

			m_Arrow_Y = -0;

			m_Up_Left = 8;
			m_Up_Width = 17;
			m_Up_Height = 21;

			m_Down_Width = 17;
			m_Down_Height = 21;

			m_Bar_Left = 8;
			m_Bar_Top = 23;
			m_Bar_Bottom = 20;

			m_BG_ImgBegin = (new bmPopupScrollBgTop() as Bitmap).bitmapData;
			m_BG_ImgCenter = (new bmPopupScrollBgCenter() as Bitmap).bitmapData;
			m_BG_ImgEnd = (new bmPopupScrollBgBottom() as Bitmap).bitmapData;

			m_Normal_ImgUp = (new bmPopupScrollNormalUp() as Bitmap).bitmapData;
			m_Normal_ImgDown = (new bmPopupScrollNormalDown() as Bitmap).bitmapData;
			m_Normal_ImgArrow = (new bmPopupScrollNormalArrow() as Bitmap).bitmapData;
			m_Normal_ImgTop = (new bmPopupScrollNormalTop() as Bitmap).bitmapData;
			m_Normal_ImgCenter = (new bmPopupScrollNormalCenter() as Bitmap).bitmapData;
			m_Normal_ImgBottom = (new bmPopupScrollNormalBottom() as Bitmap).bitmapData;

			m_Onmouse_ImgUp = (new bmPopupScrollOnmouseUp() as Bitmap).bitmapData;
			m_Onmouse_ImgDown = (new bmPopupScrollOnmouseDown() as Bitmap).bitmapData;
			m_Onmouse_ImgArrow = (new bmPopupScrollOnmouseArrow() as Bitmap).bitmapData;
			m_Onmouse_ImgTop = (new bmPopupScrollOnmouseTop() as Bitmap).bitmapData;
			m_Onmouse_ImgCenter = (new bmPopupScrollOnmouseCenter() as Bitmap).bitmapData;
			m_Onmouse_ImgBottom = (new bmPopupScrollOnmouseBottom() as Bitmap).bitmapData;

			m_Onpress_ImgUp = (new bmPopupScrollOnpressUp() as Bitmap).bitmapData;
			m_Onpress_ImgDown = (new bmPopupScrollOnpressDown() as Bitmap).bitmapData;
			m_Onpress_ImgArrow = (new bmPopupScrollOnpressArrow() as Bitmap).bitmapData;
			m_Onpress_ImgTop = (new bmPopupScrollOnpressTop() as Bitmap).bitmapData;
			m_Onpress_ImgCenter = (new bmPopupScrollOnpressCenter() as Bitmap).bitmapData;
			m_Onpress_ImgBottom = (new bmPopupScrollOnpressBottom() as Bitmap).bitmapData;
			
			m_Disable_ImgUp = (new bmPopupScrollDisableUp() as Bitmap).bitmapData;
			m_Disable_ImgDown = (new bmPopupScrollDisableDown() as Bitmap).bitmapData;

		} else if (s == CtrlScrollBar.StyleVertical) {
			m_WidthMin = 27;
			m_HeightMin = 100;

			m_BarMin = 25;

			m_Arrow_Y = -0;
			
			m_BG_Top = 27-2;
			m_BG_Bottom = 27-2;

			m_Up_Left = 0;
			m_Up_Width = 27;
			m_Up_Height = 27;

			m_Down_Width = 27;
			m_Down_Height = 27;

			m_Bar_Left = 6;
			m_Bar_Right = 6;
			m_Bar_Top = 33-2;
			m_Bar_Bottom = 30-2;

			m_BG_ImgBegin = (new bmVeScrollBgTop() as Bitmap).bitmapData;
			m_BG_ImgCenter = (new bmVeScrollBgCenter() as Bitmap).bitmapData;
			m_BG_ImgEnd = (new bmVeScrollBgBottom() as Bitmap).bitmapData;

			m_Normal_ImgUp = (new bmVeScrollNormalUp() as Bitmap).bitmapData;
			m_Normal_ImgDown = (new bmVeScrollNormalDown() as Bitmap).bitmapData;
			m_Normal_ImgArrow = (new bmVeScrollNormalArrow() as Bitmap).bitmapData;
			m_Normal_ImgTop = (new bmVeScrollNormalTop() as Bitmap).bitmapData;
			m_Normal_ImgCenter = (new bmVeScrollNormalCenter() as Bitmap).bitmapData;
			m_Normal_ImgBottom = (new bmVeScrollNormalBottom() as Bitmap).bitmapData;

			m_Onmouse_ImgUp = (new bmVeScrollOnmouseUp() as Bitmap).bitmapData;
			m_Onmouse_ImgDown = (new bmVeScrollOnmouseDown() as Bitmap).bitmapData;
			m_Onmouse_ImgArrow = (new bmVeScrollOnmouseArrow() as Bitmap).bitmapData;
			m_Onmouse_ImgTop = (new bmVeScrollOnmouseTop() as Bitmap).bitmapData;
			m_Onmouse_ImgCenter = (new bmVeScrollOnmouseCenter() as Bitmap).bitmapData;
			m_Onmouse_ImgBottom = (new bmVeScrollOnmouseBottom() as Bitmap).bitmapData;

			m_Onpress_ImgUp = (new bmVeScrollOnpressUp() as Bitmap).bitmapData;
			m_Onpress_ImgDown = (new bmVeScrollOnpressDown() as Bitmap).bitmapData;
			m_Onpress_ImgArrow = (new bmVeScrollOnpressArrow() as Bitmap).bitmapData;
			m_Onpress_ImgTop = (new bmVeScrollOnpressTop() as Bitmap).bitmapData;
			m_Onpress_ImgCenter = (new bmVeScrollOnpressCenter() as Bitmap).bitmapData;
			m_Onpress_ImgBottom = (new bmVeScrollOnpressBottom() as Bitmap).bitmapData;

			m_Disable_ImgUp = (new bmVeScrollDisableUp() as Bitmap).bitmapData;
			m_Disable_ImgDown = (new bmVeScrollDisableDown() as Bitmap).bitmapData;
		}
	}
}
