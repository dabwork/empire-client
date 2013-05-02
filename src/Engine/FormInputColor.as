// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import Base.*;
import Engine.*;
import B3DEffect.Style;
import fl.containers.*;
import fl.controls.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

import utils.eg.HSVRGB;

public class FormInputColor extends FormStd
{
	public static const SizeX:int = 310;
	public static const SizeY:int = 445;
	
	public var m_ColorGBG:Bitmap = null;
	public var m_ColorG:Bitmap = null;
	public var m_ColorK:Sprite = null;
	public var m_ColorXY:Bitmap = null;
	public var m_ColorZ:Bitmap = null;
	public var m_ColorW:Bitmap = null;
	public var m_ColorBG:Bitmap = null;
	public var m_Color:Sprite = null;
	public var m_MarkerXY:Sprite = null;
	public var m_MarkerXY2:Sprite = null;
	public var m_MarkerZ:Sprite = null;
	public var m_MarkerW:Sprite = null;
	
	public var m_Text:TextArea = null;
	
	public var m_R:int = 0, m_G:int = 0, m_B:int = 0, m_A:int = 0;
	public var m_H:int = 0, m_S:int = 0, m_V:int = 0;

	public var m_Grid:Vector.<uint> = null;
	public var m_GridId:Vector.<int> = new Vector.<int>();
	public var m_GridCur:int = -1;
	public var m_GridMouse:int = -1;
	
	public var m_Action:int = 0; // 1-XY 2-Z 3-W 4-G
	
	public var m_Timer:Timer = new Timer(50);
	public var m_BuildXY:Number = 0;
	public var m_BuildW:Number = 0;
	public var m_BuildZ:Number = 0;
	public var m_BuildG:Number = 0;
	
	public var m_Change:Function = null;
	
	public function FormInputColor()
	{
		var x:int, y:int;
		var clr:uint;
		
		super(true, false);
		setPos(0, 0, 1, -1);
		caption = "COLOR";
		
		var _left:int = innerLeft - 20;
		var _top:int = innerTop - 10;
		
		width = 310 + 30;
		height = 445 + 30;

		m_Timer.addEventListener(TimerEvent.TIMER, Takt);

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);

		m_ColorGBG = new Bitmap();
		m_ColorGBG.bitmapData = new BitmapData(256, 20, true, 0);
		m_ColorGBG.x = _left;
		m_ColorGBG.y = _top;
		for (y = 0; y < 20; y++) {
			for (x = 0; x < 256; x++) {
				if (((x >> 3) + (y >> 3)) & 1) clr = 0xffffffff;
				else clr = 0xffcccccc;
				
				m_ColorGBG.bitmapData.setPixel32(x, y, clr);
			}
		}
		addChild(m_ColorGBG);
		
		m_ColorG = new Bitmap();
		m_ColorG.bitmapData = new BitmapData(256, 20, true, 0);
		m_ColorG.x = _left;
		m_ColorG.y = _top;
		addChild(m_ColorG);

		m_ColorK = new Sprite();
		m_ColorK.x = m_ColorG.x;
		m_ColorK.y = m_ColorG.y + 20;
		addChild(m_ColorK);

		m_ColorXY = new Bitmap();
		m_ColorXY.bitmapData = new BitmapData(256, 256, true, 0);
		m_ColorXY.x = _left;
		m_ColorXY.y = _top + 40;
		addChild(m_ColorXY);

		m_ColorZ = new Bitmap();
		m_ColorZ.bitmapData = new BitmapData(20, 256, true, 0);
		m_ColorZ.x = _left + 256 + 10;
		m_ColorZ.y = _top + 40;
		addChild(m_ColorZ);
		
		m_ColorW = new Bitmap();
		m_ColorW.bitmapData = new BitmapData(256, 20, true, 0);
		m_ColorW.x = _left;
		m_ColorW.y = _top + 40 + 256 + 10;
		addChild(m_ColorW);
		
		m_ColorBG = new Bitmap();
		m_ColorBG.bitmapData = new BitmapData(128, 50, true, 0);
		m_ColorBG.x = _left;
		m_ColorBG.y = _top + 40 + 256 + 10 + 20 + 10;
		for (y = 0; y < 50; y++) {
			for (x = 0; x < 128; x++) {
				if (((x >> 3) + (y >> 3)) & 1) clr = 0xffffffff;
				else clr = 0xffcccccc;
				
				m_ColorBG.bitmapData.setPixel32(x, y, clr);
			}
		}
		addChild(m_ColorBG);

		m_Color = new Sprite();
		m_Color.x = m_ColorBG.x;
		m_Color.y = m_ColorBG.y;
		addChild(m_Color);

		m_MarkerXY = new Sprite();
		m_MarkerXY.graphics.clear();
		m_MarkerXY.graphics.lineStyle(1.5, 0xffffffff);
		var ox:Number = 0;
		var oy:Number = 0;
		var s:Number = 5;
		var l:Number = 10;
		m_MarkerXY.graphics.drawPath(Vector.<int>([1, 2, 1, 2, 1, 2, 1, 2]), Vector.<Number>([
			ox, oy - s,
			ox, oy - l,
			ox, oy + s,
			ox, oy + l,
			ox - s, oy,
			ox - l, oy,
			ox + s, oy,
			ox + l, oy
			]));
		addChild(m_MarkerXY);

		m_MarkerXY2 = new Sprite();
		m_MarkerXY2.graphics.clear();
		m_MarkerXY2.graphics.lineStyle(1.5, 0xff202020);
		m_MarkerXY2.graphics.drawPath(Vector.<int>([1, 2, 1, 2, 1, 2, 1, 2]), Vector.<Number>([
			ox, oy - s,
			ox, oy - l,
			ox, oy + s,
			ox, oy + l,
			ox - s, oy,
			ox - l, oy,
			ox + s, oy,
			ox + l, oy
			]));
		addChild(m_MarkerXY2);

		m_MarkerZ = new Sprite();
		m_MarkerZ.graphics.clear();
		m_MarkerZ.graphics.lineStyle(1.0, 0xffffffff);
		ox = -1;
		oy = 0;
		var sx:Number = 6;
		var sy:Number = 6;
		m_MarkerZ.graphics.drawPath(Vector.<int>([1, 2, 2, 2]), Vector.<Number>([
			ox, oy,  
			ox - sx, oy + sy,
			ox - sx, oy - sy,
			ox, oy]));
		ox = 21.0;
		m_MarkerZ.graphics.drawPath(Vector.<int>([1, 2, 2, 2]), Vector.<Number>([
			ox, oy,  
			ox + sx, oy + sy,
			ox + sx, oy - sy,
			ox, oy]));
		addChild(m_MarkerZ);

		m_MarkerW = new Sprite();
		m_MarkerW.graphics.clear();
		m_MarkerW.graphics.lineStyle(1.0, 0xffffffff);
		ox = 0;
		oy = -1;
		sx = 6;
		sy = 6;
		m_MarkerW.graphics.drawPath(Vector.<int>([1, 2, 2, 2]), Vector.<Number>([
			ox, oy,  
			ox - sx, oy - sy,
			ox + sx, oy - sy,
			ox, oy]));
		oy = 21.0;
		m_MarkerW.graphics.drawPath(Vector.<int>([1, 2, 2, 2]), Vector.<Number>([
			ox, oy,  
			ox - sx, oy + sy,
			ox + sx, oy + sy,
			ox, oy]));
		addChild(m_MarkerW);
		
		m_Text=new TextArea();
		m_Text.x = m_ColorBG.x + m_ColorBG.width + 10;
		m_Text.y = m_ColorBG.y;
		m_Text.width = SizeX - m_Text.x - 10;
		m_Text.height = height - m_Text.y - 10;
		m_Text.setStyle("upSkin", TextArea_Chat);
		m_Text.setStyle("focusRectSkin", focusRectSkinNone);
		m_Text.setStyle("textFormat", new TextFormat("Calibri",14,0xffffff));
		m_Text.setStyle("embedFonts", true);
		m_Text.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_Text.textField.gridFitType=GridFitType.PIXEL;
		//Common.UIChatBar(m_Text);
		m_Text.horizontalScrollPolicy = ScrollPolicy.OFF;
		m_Text.verticalScrollPolicy = ScrollPolicy.OFF;
		addChild(m_Text);
	}
	
	public override function BGFill(layer:Sprite, x:int, y:int, w:int, h:int):void
	{
		layer.graphics.beginFill(0x000000, 0.95);
		layer.graphics.drawRect( x, y, w, h);
		layer.graphics.endFill();
	}

	public function clickClose(e:Event):void
	{
		Hide();
	}

	public override function Hide():void // clearref:Boolean=true
	{
		if (!visible) return;
		
		m_Action = 0;
		
		m_GridCur = -1;
		m_GridMouse = -1;
		
//		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//		removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
//		removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
		
		m_Timer.stop();
		
		//if(clearref)
		StdMap.Main.m_FormInputEx.m_ColorPickerInput = null;

		super.Hide();
	}	
	
	public function Run(clr:uint = 0xffffffff, change:Function = null):void
	{
		if (visible) {
			var ci:CtrlInput = StdMap.Main.m_FormInputEx.m_ColorPickerInput;
			Hide();
			StdMap.Main.m_FormInputEx.m_ColorPickerInput = ci;
		}
		Show();
//		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
//		addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);

		m_Change = change;

		m_Timer.start();

		SetColor(clr);

		BuildZ();
		BuildXY();
		BuildW();
	}
	
	public function SetGrid(g:Vector.<uint>):void
	{
		m_Grid = g;
		if (g == null) {
			m_GridCur = -1;
			m_GridId.length = 0;
			return;
		}
		if ((m_Grid.length & 1) != 0) m_Grid.push(100);

		m_GridId.length = m_Grid.length >> 1;
		var i:int;
		for (i = 0; i < m_GridId.length; i++) m_GridId[i] = i;
		GridSort();
	}

	public function GridMaxId():int
	{
		var i:int;
		var m:int = 0;
		for (i = 0; i < m_GridId.length; i++) {
			if (m_GridId[i] > m) m = m_GridId[i];
		}
		return m;
	}

	public function GridSort():void
	{
		var i:int, u:int, t:int;
		var v:uint;
		var cnt:int = m_Grid.length >> 1;
		for (i = 0; i < cnt - 1; i++) {
			for (u = i + 1; u < cnt; u++) {
				if (m_Grid[(i << 1) + 1] > m_Grid[(u << 1) + 1]) {
					v = m_Grid[(i << 1) + 1];
					m_Grid[(i << 1) + 1] = m_Grid[(u << 1) + 1];
					m_Grid[(u << 1) + 1] = v;

					v = m_Grid[(i << 1) + 0];
					m_Grid[(i << 1) + 0] = m_Grid[(u << 1) + 0];
					m_Grid[(u << 1) + 0] = v;

					t = m_GridId[i];
					m_GridId[i] = m_GridId[u];
					m_GridId[u] = t;
				}
			}
		}
	}

	public function SetColor(clr:uint):void
	{
		var ct:HSVRGB = new HSVRGB();
		m_R = (clr >> 16) & 255;
		m_G = (clr >> 8) & 255;
		m_B = (clr) & 255;
		m_A = (clr >> 24) & 255;
		ct.r = m_R;
		ct.g = m_G;
		ct.b = m_B;
		ct.ToHSV();
		m_S = ct.s;
		m_V = ct.v;
		m_H = ct.h;

		if (m_BuildXY == 0) m_BuildXY = StdMap.Main.m_CurTime;
		if (m_BuildW == 0) m_BuildW = StdMap.Main.m_CurTime;
		if (m_BuildZ == 0) m_BuildZ = StdMap.Main.m_CurTime;
		if (m_BuildG == 0) m_BuildG = StdMap.Main.m_CurTime;
		BuildColor();
		UpdatePos();
	}
	
	public function SetColorToGrid(clr:uint):void
	{
		if (m_Grid == null) return;
		if (m_GridCur < 0) return;
		
		for (var i:int = 0; i < m_GridId.length; i++) {
			if (m_GridId[i] == m_GridCur) {
				m_Grid[i << 1] = clr;
			}
		}
		if (m_BuildG == 0) m_BuildG = StdMap.Main.m_CurTime;
	}
	
	public function GetColor():uint
	{
		return (uint(m_R) << 16) | (uint(m_G) << 8) | (uint(m_B)) | (uint(m_A) << 24);
	}

	private function Takt(e:TimerEvent):void
	{
		if ((m_BuildXY != 0) && ((m_BuildXY + 100) < StdMap.Main.m_CurTime)) {
			BuildXY();
		}
		if ((m_BuildW != 0) && ((m_BuildW + 50) < StdMap.Main.m_CurTime)) {
			BuildW();
		}
		if ((m_BuildZ != 0) && ((m_BuildZ + 50) < StdMap.Main.m_CurTime)) {
			BuildZ();
		}
		if ((m_BuildG != 0) && ((m_BuildG + 50) < StdMap.Main.m_CurTime)) {
			BuildG();
		}
	}

	public override function onMouseMove(e:MouseEvent):void
	{
		super.onMouseMove(e);

		var i:int, k:int;

		if (m_Action == 1) {
			m_S = Math.round((Number(mouseX - m_ColorXY.x) / (m_ColorXY.width - 1)) * 255.0);
			m_V = Math.round((1.0 - Number(mouseY - m_ColorXY.y) / (m_ColorXY.height - 1)) * 255.0);
			if (m_S < 0) m_S = 0;
			else if (m_S > 255) m_S = 255;
			if (m_V < 0) m_V = 0;
			else if (m_V > 255) m_V = 255;
			if (m_BuildW == 0) m_BuildW = StdMap.Main.m_CurTime;
			BuildColor();
			UpdatePos();
			SetColorToGrid(GetColor());
			
//			if (m_Change != null) m_Change();
		}
		else if (m_Action == 2) {
			m_H = Math.round((Number(mouseY - m_ColorZ.y) / m_ColorZ.height) * 360.0);
			if (m_H < 0) m_H = 0;
			else if (m_H > 360) m_H = 360;
			if (m_BuildXY == 0) m_BuildXY = StdMap.Main.m_CurTime;
			if (m_BuildW == 0) m_BuildW = StdMap.Main.m_CurTime;
			BuildColor();
			UpdatePos();
			SetColorToGrid(GetColor());
			
//			if (m_Change != null) m_Change();
		}
		else if (m_Action == 3) {
			m_A = Math.round((Number(mouseX - m_ColorW.x) / m_ColorW.width) * 255.0);
			if (m_A < 0) m_A = 0;
			else if (m_A > 255) m_A = 255;
			BuildColor();
			UpdatePos();
			SetColorToGrid(GetColor());

//			if (m_Change != null) m_Change();

		} else if (m_Action == 4) {
			k = Math.round(100 * (mouseX - m_ColorG.x) / m_ColorG.width);
			if (k < 0) k = 0;
			else if (k >= 100) k = 100;
			
			for (i = 0; i < m_GridId.length; i++) {
				if (m_GridId[i] == m_GridCur) m_Grid[(i << 1) + 1] = k;
			}
			GridSort();

			BuildG();

//			if (m_Change != null) m_Change();
		}
//		else if (m_ColorG.hitTestPoint(e.stageX, e.stageY) && m_Grid != null) {
		else if (m_Grid != null && mouseX > (m_ColorG.x - 5) && mouseX < (m_ColorG.x + m_ColorG.bitmapData.width + 5) && mouseY > (m_ColorG.y - 5) && mouseY < (m_ColorG.y + m_ColorG.bitmapData.height + 10)) {
			k = Math.round(100 * (mouseX - m_ColorG.x) / m_ColorG.width);
			if (k < 0) k = 0;
			else if (k >= 100) k = 100;
			
			for (i = 0; i < m_GridId.length; i++) {
				if (Math.abs(m_Grid[(i << 1) + 1] - k) <= 2) break;
			}
			if (i >= m_GridId.length) i = -1;
			else i = m_GridId[i];
			
			if (i != m_GridMouse) {
				m_GridMouse = i;
				BuildG();
			}
		} else {
			if (-1 != m_GridMouse) {
				m_GridMouse = -1;
				BuildG();
			}
		}
	}

	public override function onRightMouseDown(e:MouseEvent):void
	{
		super.onRightMouseDown(e);
		
		if (m_Action == 0 && m_GridMouse >= 0) {
			var i:int;
			for (i = 0; i < m_GridId.length; i++) {
				if (m_GridId[i] != m_GridMouse) continue;
				m_GridId.splice(i, 1);
				m_Grid.splice(i << 1, 2);
				break;
			}
			if (m_GridMouse == m_GridCur) m_GridCur = -1;
			m_GridMouse = -1;
			GridSort();
			BuildG();
			
			if (m_Change != null) m_Change();
			return;
		}
	}
	
	public override function onMouseDown(e:MouseEvent):void
	{
		super.onMouseDown(e);
		
		var i:int;

		if (FormMessageBox.Self.visible) return;
		
		if (m_ColorXY.hitTestPoint(e.stageX, e.stageY)) {
			m_Action = 1;
			MouseLock();
			m_S = Math.round((Number(mouseX - m_ColorXY.x) / (m_ColorXY.width - 1)) * 255.0);
			m_V = Math.round((1.0 - Number(mouseY - m_ColorXY.y) / (m_ColorXY.height - 1)) * 255.0);
			if (m_S < 0) m_S = 0;
			else if (m_S > 255) m_S = 255;
			if (m_V < 0) m_V = 0;
			else if (m_V > 255) m_V = 255;
			BuildW();
			BuildColor();
			UpdatePos();
			SetColorToGrid(GetColor());
			
			if (m_Change != null) m_Change();
			return;
		}
		else if (m_ColorZ.hitTestPoint(e.stageX, e.stageY)) {
			m_Action = 2;
			MouseLock();
			m_H = Math.round((Number(mouseY - m_ColorZ.y) / m_ColorZ.height) * 360.0);
			if (m_H < 0) m_H = 0;
			else if (m_H > 360) m_H = 360;
			BuildXY();
			BuildW();
			BuildColor();
			UpdatePos();
			SetColorToGrid(GetColor());
			
			if (m_Change != null) m_Change();
			return;
		}
		else if (m_ColorW.hitTestPoint(e.stageX, e.stageY)) {
			m_Action = 3;
			MouseLock();
			m_A = Math.round((Number(mouseX - m_ColorW.x) / m_ColorW.width) * 255.0);
			if (m_A < 0) m_A = 0;
			else if (m_A > 255) m_A = 255;
			BuildColor();
			UpdatePos();
			SetColorToGrid(GetColor());
			
			if (m_Change != null) m_Change();
			return;
		}
		//else if (m_ColorG.hitTestPoint(e.stageX, e.stageY)) {
		else if (mouseX > (m_ColorG.x - 5) && mouseX < (m_ColorG.x + m_ColorG.bitmapData.width + 5) && mouseY > (m_ColorG.y - 5) && mouseY < (m_ColorG.y + m_ColorG.bitmapData.height + 10)) {
			if (m_Grid == null) {
				m_Grid = new Vector.<uint>();
				m_GridId.length = 0;
			}
			
			if (m_GridMouse >= 0) {
				m_GridCur = m_GridMouse;
				
				for (i = 0; i < m_GridId.length; i++) {
					if (m_GridId[i] == m_GridCur) {
						SetColor(m_Grid[i << 1]);
					}
				}
			} else {
				var k:int = Math.round(100 * (mouseX - m_ColorG.x) / m_ColorG.width);
				if (k < 0) k = 0;
				else if (k >= 100) k = 100;
				
				if (m_Grid.length > 0) {
					SetColor(Style.IC(m_Grid, 0.01 * k));
				}
				m_Grid.push(GetColor());
				m_Grid.push(k);
				m_GridCur = GridMaxId() + 1;
				m_GridMouse = m_GridCur;
				m_GridId.push(m_GridCur);
				GridSort();
			}

			m_Action = 4;
			MouseLock();

			BuildG();
			if (m_Change != null) m_Change();
			return;
		}
		else if (m_Text.hitTestPoint(e.stageX, e.stageY)) return;
	}
	
	public override function onMouseUp(e:MouseEvent):void
	{
		super.onMouseUp(e);
		
		if (m_Action != 0) {
			m_Action = 0;
			MouseUnlock();
			if (m_Change != null) m_Change();
		}
	}

	public function BuildXY():void
	{
		m_BuildXY = 0;
		
		var bm:BitmapData = m_ColorXY.bitmapData;

		var x:int,y:int;

		var ct:HSVRGB = new HSVRGB();
		ct.h = m_H;
		
		var sx:int = bm.width;
		var sy:int = bm.height;

		bm.lock();
	    for (y = 0; y < sy; y++) {
			ct.v = Math.round((y / (sy - 1)) * 255.0);
    	    for (x = 0; x < sx; x++) {
				ct.s = Math.round((x / (sx - 1)) * 255.0);
				ct.ToRGB();

				bm.setPixel32(x, sy - 1 - y, 0xff000000 | (ct.r << 16) | (ct.g << 8) | (ct.b));
			}
		}
		bm.unlock();
	}
	
	public function BuildZ():void
	{
		m_BuildZ = 0;

		var bm:BitmapData = m_ColorZ.bitmapData;
		
		var ct:HSVRGB = new HSVRGB();
		ct.s = 255;
		ct.v = 255;
		
		var x:int,y:int;
		var clr:uint;

		var sx:int = bm.width;
		var sy:int = bm.height;
		
		bm.lock();
		for (y = 0; y < sy; y++) {
			ct.h = Math.round((Number(y) / (sy - 1)) * 360.0);
			ct.ToRGB();
			clr = 0xff000000 | (ct.r << 16) | (ct.g << 8) | (ct.b);
		
			for (x = 0; x < sx; x++) {
				bm.setPixel32(x, y, clr);
			}
		}
		bm.unlock();
	}
	
	public function BuildW():void
	{
		m_BuildW = 0;
		
		var ct:HSVRGB = new HSVRGB();
		ct.s = m_S;
		ct.v = m_V;
		ct.h = m_H;
		ct.ToRGB();
		m_R = ct.r;
		m_G = ct.g;
		m_B = ct.b;
	
		var bm:BitmapData = m_ColorW.bitmapData;
		
		var x:int, y:int;
		var clr:uint;
		
		bm.lock();
		for (x = 0; x < bm.width; x++) {
			 clr = (m_R << 16) | (m_G << 8) | m_B | (Math.round((x / (bm.width - 1)) * 255) << 24);
			 for (y = 0; y < bm.height; y++) {
				 bm.setPixel32(x, y, clr);
			 }
		}
		bm.unlock();
	}
	
	public function BuildColor():void
	{
		var ct:HSVRGB = new HSVRGB();
		ct.s = m_S;
		ct.v = m_V;
		ct.h = m_H;
		ct.ToRGB();
		m_R = ct.r;
		m_G = ct.g;
		m_B = ct.b;

		m_Color.graphics.clear();
		m_Color.graphics.lineStyle(0.0, 0, 0);
		m_Color.graphics.beginFill((m_R << 16) | (m_G << 8) | m_B, Number(m_A) / 255);
		m_Color.graphics.drawRect(0, 0, 128, 50);
		m_Color.graphics.endFill();

		BuildG();
	}

	public function BuildG():void
	{
		m_BuildG = 0;

		var bm:BitmapData = m_ColorG.bitmapData;

		var x:int, y:int;
		var clr:uint = (m_R << 16) | (m_G << 8) | m_B | (m_A << 24);

		bm.lock();
		for (x = 0; x < bm.width; x++) {
			if (m_Grid != null) clr = Style.IC(m_Grid, x / (bm.width - 1));

			 for (y = 0; y < bm.height; y++) {
				 bm.setPixel32(x, y, clr);
			 }
		}
		bm.unlock();
		
		var i:int;
		var ox:int, oy:int, sx:int, sy:int;

		m_ColorK.graphics.clear();
		if (m_Grid != null) {
			for (i = 0; i < (m_Grid.length >> 1); i++) {
				if (m_GridId[i] == m_GridMouse) m_ColorK.graphics.lineStyle(1.0, 0xffff0000);
				else m_ColorK.graphics.lineStyle(1.0, 0xffffffff);
				if (m_GridId[i] == m_GridCur) m_ColorK.graphics.beginFill(0xffffff00);
				ox = Math.round(bm.width * 0.01 * m_Grid[(i << 1) + 1]);
				oy = 1;
				sx = 6;
				sy = 6;
				m_ColorK.graphics.drawPath(Vector.<int>([1, 2, 2, 2]), Vector.<Number>([
					ox, oy,  
					ox - sx, oy + sy,
					ox + sx, oy + sy,
					ox, oy]));
				if (m_GridId[i] == m_GridCur) m_ColorK.graphics.endFill();
			}
		}
	}

	public function UpdatePos():void
	{
		m_MarkerW.x = m_ColorW.x + Math.round((Number(m_A) / 255.0) * m_ColorW.width);
		m_MarkerW.y = m_ColorW.y;

		m_MarkerZ.x = m_ColorZ.x;
		m_MarkerZ.y = m_ColorZ.y + Math.round((Number(m_H) / 360.0) * m_ColorZ.height);

		m_MarkerXY.x = m_ColorXY.x + Math.round((Number(m_S) / 255.0) * (m_ColorXY.width - 1));
		m_MarkerXY.y = m_ColorXY.y + Math.round((1.0 - Number(m_V) / 255.0) * (m_ColorXY.height - 1));
		m_MarkerXY2.x = m_MarkerXY.x;
		m_MarkerXY2.y = m_MarkerXY.y;
		m_MarkerXY.visible = m_V < 128;
		m_MarkerXY2.visible = !m_MarkerXY.visible;

		var str:String = "";
		str += "ARGB: 0x" + BaseStr.FormatColor(GetColor());
		str += "\nRGB: " + m_R.toString() +" " + m_G.toString() + " " + m_B.toString();
		str += "\nHSV: " + m_H.toString() +" " + m_S.toString() + " " + m_V.toString();

		m_Text.text = str;
	}
}
	
}