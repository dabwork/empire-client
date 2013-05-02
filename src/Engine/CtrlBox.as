package Engine
{
import flash.display.*;
import flash.events.*;

public class CtrlBox extends CtrlStd
{
	private var m_WidthMin:int = 20;
	private var m_WidthWish:int = 0;
	private var m_Width:int = 0;
	private var m_HeightMin:int = 20;
	private var m_HeightWish:int = 0;
	private var m_Height:int = 0;

//	private var m_Hit
	private var m_DNormal:Sprite = new Sprite();
	private var m_DOnmouse:Sprite = new Sprite();
	private var m_DSelect:Sprite = new Sprite();

	private var m_NeedBuild:Boolean = true;
	private var m_NeedUpdate:Boolean = true;

	private var m_MouseIn:Boolean = false;
//	private var m_Down:Boolean = false;
	private var m_Select:Boolean = false;

	private var m_Top:int = 0;
	private var m_Bottom:int = 0;
	private var m_Left:int = 0;
	private var m_Right:int = 0;
	
	private var m_PartLeft:Boolean = true;
	private var m_PartCenter:Boolean = true;
	private var m_PartRight:Boolean = true;
	
	private var m_PassLeft:int = 0;
	private var m_PassRight:int = 0;
	
	public function set partLeft(v:Boolean):void { if (m_PartLeft == v) return; m_PartLeft = v; m_NeedBuild = true; }
	public function set partCenter(v:Boolean):void { if (m_PartCenter == v) return; m_PartCenter = v; m_NeedBuild = true; }
	public function set partRight(v:Boolean):void { if (m_PartRight == v) return; m_PartRight = v; m_NeedBuild = true; }
	
	public function set passLeft(v:int):void { if (v <= 0) v = 0; if (m_PassLeft == v) return; m_PassLeft = v; m_NeedBuild = true; }
	public function set passRight(v:int):void { if (v <= 0) v = 0; if (m_PassRight == v) return; m_PassRight = v; m_NeedBuild = true; }

	public function set widthMin(v:Number):void { if (v < 20) v = 20; if (m_WidthMin == v) return; m_WidthMin = v; m_NeedBuild = true; }
	public function get widthMin():Number { return m_WidthMin; }
	public function set heightMin(v:Number):void { if (v < 20) v = 20; if (m_HeightMin == v) return; m_HeightMin = v; m_NeedBuild = true; }
	public function get heightMin():Number { return m_HeightMin; }

	override public function set width(v:Number):void { if (m_WidthWish == v) return; m_WidthWish = v; m_NeedBuild = true; }
	override public function get width():Number	{ if (m_NeedBuild) Build(); return m_Width; }
	override public function set height(v:Number):void { if (m_HeightWish == v) return; m_HeightWish = v; m_NeedBuild = true; }
	override public function get height():Number { if (m_NeedBuild) Build(); return m_Height; }
	
	public function get select():Boolean { return m_Select; }
	public function set select(v:Boolean):void { if (v == m_Select) return; m_Select = v; m_NeedUpdate = true; }

	public function CtrlBox():void
	{
		addChild(m_DNormal);
		addChild(m_DOnmouse);
		addChild(m_DSelect);

        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(Event.DEACTIVATE, onDeactivate);
		addEventListener(Event.RENDER, onRender);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		hitArea = new Sprite();
		addChild(hitArea);
		hitArea.visible = false;

		m_DNormal.mouseEnabled = false;
		m_DOnmouse.mouseEnabled = false;
		m_DSelect.mouseEnabled = false;

		mouseEnabled = true;
	}

	public function IsHit(e:MouseEvent):Boolean
	{
/*		var o:DisplayObject = null;
		if ((e.target != null) && (e.target is DisplayObject)) {
			o = e.target as DisplayObject;
			while (o != null) {
				if (o == this) break;
				o = o.parent;
			}
		}
		if (o == null) return false;*/

		return (mouseX >= m_Left && mouseX < m_Right && mouseY >= m_Top && mouseY < m_Bottom);
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
		
		if(IsHit(event)) {
			m_MouseIn = true;
			//m_Down = true;
			m_Select = true;
			m_NeedUpdate = true;
			//MouseLock();
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
	
    protected function onMouseUp(event:MouseEvent):void
    {
		event.stopImmediatePropagation();

		MouseUnlock();

//		if (m_Down) {
//			m_Down = false;
//			m_Select = true;
//			m_NeedUpdate = true;
//			
//			dispatchEvent(new Event(Event.CHANGE));
//		}
	}
	
	protected function onMouseMove(event:MouseEvent):void
	{
		if(!m_MouseLock) event.stopImmediatePropagation();

		if (mouseX >= m_Left && mouseX < m_Right && mouseY >= m_Top && mouseY < m_Bottom) {
			if(!m_MouseIn) {
				m_MouseIn = true;
				m_NeedUpdate = true;
			}
		} else {
			if(m_MouseIn) {
				m_MouseIn = false;
				m_NeedUpdate = true;
			}
		}
	}

	protected function onMouseOut(event:MouseEvent):void
	{
		if (m_MouseIn) {
			m_MouseIn = false;
			m_NeedUpdate = true;
		}
	}
	
	private function onDeactivate(event:Event):void
	{
		MouseUnlock();
		if (m_MouseIn/* || m_Down*/) {
			m_MouseIn = false;
//			m_Down = false;
			m_NeedUpdate = true;
		}
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
	
	private function BuildLayer(s:Sprite, clr:uint, alpha:Number):void
	{
		var sx:int = m_Width;
		var sy:int = m_Height;
		
		hitArea.graphics.clear();
		hitArea.graphics.beginFill(0, 1);
		hitArea.graphics.drawRect(0, 0, sx, sy);
		hitArea.graphics.endFill();

		var dc:Vector.<int> = new Vector.<int>();
		var dv:Vector.<Number> = new Vector.<Number>();

		dc.push(GraphicsPathCommand.MOVE_TO); dv.push(10, 0);

		dc.push(GraphicsPathCommand.LINE_TO); dv.push(sx - 10, 0);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(sx, 0); dv.push(sx, 10); // Правый верхний угол

		dc.push(GraphicsPathCommand.LINE_TO); dv.push(sx, sy - 10);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(sx, sy); dv.push(sx - 10, sy); // Правый нижний угол

		dc.push(GraphicsPathCommand.LINE_TO); dv.push(10, sy);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(0, sy); dv.push(0, sy - 10); // Левый нижний угол

		dc.push(GraphicsPathCommand.LINE_TO); dv.push(0, 10);  // Правый левый угол
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(0, 0); dv.push(10, 0);

		s.graphics.clear();
		s.graphics.lineStyle(0, 0, 0);
		s.graphics.beginFill(clr, alpha);
		
		if(m_PartCenter) {
			s.graphics.drawRect(m_PartLeft?(18 + m_PassLeft):m_PassLeft, 0, sx - (m_PartLeft?(18 + m_PassLeft):m_PassLeft) - (m_PartRight?(7 + m_PassRight):m_PassRight), sy);
		}
		
		if (m_PartLeft) {
			dc.length = 0;
			dv.length = 0;

			dc.push(GraphicsPathCommand.MOVE_TO); dv.push(6, 0);

			dc.push(GraphicsPathCommand.LINE_TO); dv.push(18, 0);

			dc.push(GraphicsPathCommand.LINE_TO); dv.push(18, sy);

			dc.push(GraphicsPathCommand.LINE_TO); dv.push(6, sy);
			dc.push(GraphicsPathCommand.CURVE_TO); dv.push(0, sy); dv.push(0, sy - 6); // Левый нижний угол

			dc.push(GraphicsPathCommand.LINE_TO); dv.push(0, 6);  // Правый левый угол
			dc.push(GraphicsPathCommand.CURVE_TO); dv.push(0, 0); dv.push(6, 0);

			s.graphics.drawPath(dc, dv);
		}
		if (m_PartRight) {
			dc.length = 0;
			dv.length = 0;
			
			dc.push(GraphicsPathCommand.MOVE_TO); dv.push(sx - 7, 0);

			dc.push(GraphicsPathCommand.LINE_TO); dv.push(sx - 6, 0);
			dc.push(GraphicsPathCommand.CURVE_TO); dv.push(sx, 0); dv.push(sx, 6); // Правый верхний угол

			dc.push(GraphicsPathCommand.LINE_TO); dv.push(sx, sy - 6);
			dc.push(GraphicsPathCommand.CURVE_TO); dv.push(sx, sy); dv.push(sx - 6, sy); // Правый нижний угол

			dc.push(GraphicsPathCommand.LINE_TO); dv.push(sx - 7, sy);

			s.graphics.drawPath(dc, dv);
		}
		
		s.graphics.endFill();
	}

	private function Build():void
	{
		m_Width = m_WidthWish;
		if (m_Width < m_WidthMin) m_Width = m_WidthMin;
		m_Height = m_HeightWish;
		if (m_Height < m_HeightMin) m_Height = m_HeightMin;

		m_Top = 0;
		m_Bottom = m_Height;
		m_Left = 0;
		m_Right = m_Width;

		m_NeedBuild = false;
		m_NeedUpdate = true;
		
		BuildLayer(m_DNormal, 0x727057, 0.3);
		BuildLayer(m_DOnmouse, 0xfff8d9, 0.8);
		BuildLayer(m_DSelect, 0xfff8d9, 0.8);
	}

	private function Update():void
	{
		m_DNormal.visible = !m_Select && !m_MouseIn;
		m_DOnmouse.visible = !m_Select && m_MouseIn;
		m_DSelect.visible = m_Select;
	}
}

}