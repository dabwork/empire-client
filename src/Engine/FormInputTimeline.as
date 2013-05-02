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

public class FormInputTimeline extends FormStd
{
	public static const SizeX:int = 500;
	public static const SizeY:int = 200;
	
	public var BeginX:Number = 1;
	public var BeginY:Number = 100;
	public var LenX:Number = 100;
	public var LenY:Number = 100;

	public var m_Graph:Sprite = null;

	public var m_Action:int = 0;

	public var m_Change:Function = null;
	
	public var m_ValList:Vector.<Number> = null;
	public var m_IdList:Vector.<int> = new Vector.<int>();
	
	public var m_CurId:int = -1;
	
	public var m_Move:Boolean = false;

	public function FormInputTimeline()
	{
		super(true, false);
		setPos(0, 0, 1, 1);
		caption = "TIMELINE";
		
		width = 500 + 30;
		height = 200 + 30;
		
		BeginX = innerLeft - 20;
		BeginY = height - (innerBottom - 10);
		LenX = width - BeginX - (innerRight - 10);
		LenY = height - (innerTop) - (innerBottom - 10);

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);

		m_Graph = new Sprite();
		m_Graph.x = BeginX;
		m_Graph.y = BeginY;
		addChild(m_Graph);
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

	public override function Hide():void
	{
		if (!visible) return;
		
		m_Action = 0;
		
//		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//		removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
//		removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);

		super.Hide();
	}	

	public function Run(vl:Vector.<Number>, change:Function = null):void
	{
		if (visible) Hide();
		Show();
//		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
//		addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);

		m_CurId = -1;
		m_Move = false;

		var i:int;

		m_ValList = vl;
		if ((m_ValList.length & 1) != 0) throw Error("FormInputTimeline.00");
		m_IdList.length = m_ValList.length >> 1;
		for (i = 0; i < m_IdList.length; i++) m_IdList[i] = i;
		ValSort();

		m_Change = change;

		GraphUpdate();
	}

	public function ValSort():void
	{
		var i:int, u:int, t:int;
		var v:Number;
		var cnt:int = m_ValList.length >> 1;
		for (i = 0; i < cnt - 1; i++) {
			for (u = i + 1; u < cnt; u++) {
				if (m_ValList[(i << 1) + 1] > m_ValList[(u << 1) + 1]) {
					v = m_ValList[(i << 1) + 1];
					m_ValList[(i << 1) + 1] = m_ValList[(u << 1) + 1];
					m_ValList[(u << 1) + 1] = v;

					v = m_ValList[(i << 1) + 0];
					m_ValList[(i << 1) + 0] = m_ValList[(u << 1) + 0];
					m_ValList[(u << 1) + 0] = v;

					t = m_IdList[i];
					m_IdList[i] = m_IdList[u];
					m_IdList[u] = t;
				}
			}
		}
	}

	public function MaxId():int
	{
		var i:int;
		var m:int = 0;
		for (i = 0; i < m_IdList.length; i++) {
			if (m_IdList[i] > m) m = m_IdList[i];
		}
		return m;
	}

	public override function onMouseMove(e:MouseEvent):void
	{
		super.onMouseMove(e);
		
		var i:int;
		
		if (m_Move) {
			var wx:Number = ScreenToWorldX(mouseX);
			var wy:Number = ScreenToWorldY(mouseY);
			if (wx < 0.0) wx = 0.0;
			else if (wx > 1.0) wx = 1.0;
			if (wy < 0.0) wy = 0.0;
			else if (wy > 1.0) wy = 1.0;

			for (i = 0; i < m_IdList.length; i++) {
				if (m_IdList[i] != m_CurId) continue;
				m_ValList[(i << 1) + 1] = wx;
				m_ValList[(i << 1) + 0] = wy;
			}
			ValSort();
			GraphUpdate();
			return;
		}

		var id:int = PickId(mouseX, mouseY);
		if (id != m_CurId) {
			m_CurId = id;
			GraphUpdate();
		} else {
			GraphUpdate();
		}
	}
	
	public override function onRightMouseDown(e:MouseEvent):void
	{
		super.onRightMouseDown(e);
		
		if (!m_Move && m_CurId>=0) {
			var i:int;
			for (i = 0; i < m_IdList.length; i++) {
				if (m_IdList[i] != m_CurId) continue;
				m_IdList.splice(i, 1);
				m_ValList.splice(i << 1, 2);
				break;
			}
			ValSort();
			GraphUpdate();
			
			if (m_Change != null) m_Change();
			return;
		}
	}
	
	public override function onMouseDown(e:MouseEvent):void
	{
		super.onMouseDown(e);

		if (FormMessageBox.Self.visible) return;
		
		if (m_CurId >= 0) {
			m_Move = true;
			MouseLock();
			return;
		}
		var wx:Number = ScreenToWorldX(mouseX);
		var wy:Number = ScreenToWorldY(mouseY);
		if (wx >= 0.0 && wx <= 1.0 && wy >= 0.0 && wy <= 1.0) {
			m_ValList.push(wy);
			m_ValList.push(wx);
			m_CurId = MaxId() + 1;
			m_IdList.push(m_CurId);
			ValSort();
			GraphUpdate();
			
			m_Move = true;
			MouseLock();
			return;
		}
	}
	
	public override function onMouseUp(e:MouseEvent):void
	{
		super.onMouseUp(e);
		
		if (m_Move) {
			m_Move = false;
			MouseUnlock();
			
			if (m_Change != null) m_Change();
		}
	}	

	public function ScreenToWorldX(x:int):Number
	{
		return Number(x - BeginX) / LenX;
	}
	
	public function ScreenToWorldY(y:int):Number
	{
		return -(y - BeginY) / LenY;
	}
	
	public function WorldToScreenX(x:Number):int
	{
		return Math.round(BeginX + x * LenX);
	}
	
	public function WorldToScreenY(y:Number):int
	{
		return Math.round(BeginY - y * LenY);
	}
	
	public function PickId(x:int, y:int):int
	{
		var i:int, tx:int, ty:int;
		for (i = 0; i < (m_ValList.length >> 1); i++) {
			tx = WorldToScreenX(m_ValList[(i << 1) + 1]) - x;
			ty = WorldToScreenY(m_ValList[(i << 1) + 0]) - y;

			if (tx >= -3 && tx <= 3 && ty >= -3 && ty <= 3) return m_IdList[i];
		}
		return -1;
	}

	public function GraphUpdate():void
	{
		var i:int,u:int;
		var tx:Number;
		var ty:Number;

		var gr:Graphics = m_Graph.graphics;
		gr.clear();

		gr.lineStyle(1.0, 0xff404040);
		for (tx = 0.0; tx <= 1.0; tx += 0.1) {
			gr.moveTo(tx * LenX, 0.0);
			gr.lineTo(tx * LenX, -LenY);
		}
		for (ty = 0.0; ty <= 1.0; ty += 0.1) {
			gr.moveTo(0.0, -ty * LenY);
			gr.lineTo(LenX, -ty * LenY);
		}

		if (m_ValList.length > 0) {
			gr.lineStyle(1.0, 0xffffffff);

			gr.moveTo(0.0 * LenX, -m_ValList[0] * LenY);

			for (i = 0; i < (m_ValList.length >> 1); i++) {
				gr.lineTo(m_ValList[(i << 1) + 1] * LenX, -m_ValList[(i << 1) + 0] * LenY);
			}
			
			gr.lineTo(1.0 * LenX, -m_ValList[((i - 1) << 1) + 0] * LenY);

			gr.lineStyle(1.0, 0xffffff00);
			u = -1;
			for (i = 0; i < (m_ValList.length >> 1); i++) {
				if (m_IdList[i] == m_CurId) { u = i; continue; }
				gr.drawRect(m_ValList[(i << 1) + 1] * LenX - 2, -m_ValList[(i << 1) + 0] * LenY - 2, 5, 5);
			}
			if (u >= 0) {
				i = u;
				gr.lineStyle(1.0, 0xffff0000);
				gr.drawRect(m_ValList[(i << 1) + 1] * LenX - 2, -m_ValList[(i << 1) + 0] * LenY - 2, 5, 5);
			}
		}

		tx = ScreenToWorldX(mouseX);
		ty = Style.IG(m_ValList, tx);
		if (tx < 0.0) tx = 0.0;
		else if (tx > 1.0) tx = 1.0;
		
		gr.lineStyle(1.0, 0xff00ffff);
		gr.drawCircle(tx * LenX, -ty * LenY, 5);
	}
}
	
}