package Engine
{
import flash.display.*;
import flash.events.*;

public class CtrlFrame extends Sprite
{
	[Embed(source = '/assets/stdwin/frame_top_left.png')] public var bmTopLeft:Class;
	[Embed(source = '/assets/stdwin/frame_top_right.png')] public var bmTopRight:Class;
	[Embed(source = '/assets/stdwin/frame_bottom_left.png')] public var bmBottomLeft:Class;
	[Embed(source = '/assets/stdwin/frame_bottom_right.png')] public var bmBottomRight:Class;
	[Embed(source = '/assets/stdwin/frame_left.png')] public var bmLeft:Class;
	[Embed(source = '/assets/stdwin/frame_right.png')] public var bmRight:Class;
	[Embed(source = '/assets/stdwin/frame_top.png')] public var bmTop:Class;
	[Embed(source = '/assets/stdwin/frame_bottom.png')] public var bmBottom:Class;
	
	[Embed(source = '/assets/stdwin/dots.png')] public static var bmDots:Class;
	
	private static var m_ImgDots:BitmapData = null;// new bmDots() as Bitmap;

	private var m_WidthWish:int = 0;
	private var m_Width:int = 0;
	private var m_HeightWish:int = 0;
	private var m_Height:int = 0;
	
	private var m_NeedBuild:Boolean = true;
	
	override public function set width(v:Number):void { if (m_WidthWish == v) return; m_WidthWish = v; m_NeedBuild = true; }
	override public function get width():Number	{ if (m_NeedBuild) Build(); return m_Width; }
	override public function set height(v:Number):void { if (m_HeightWish == v) return; m_HeightWish = v; m_NeedBuild = true; }
	override public function get height():Number { if (m_NeedBuild) Build(); return m_Height; }
	
	public static function get ImgDots():BitmapData
	{
		if (m_ImgDots == null) m_ImgDots = (new bmDots() as Bitmap).bitmapData;
		return m_ImgDots;
	}
	
	public function CtrlFrame():void
	{
		addEventListener(Event.RENDER, onRender);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onRender(event:Event):void
	{
		if (m_NeedBuild) Build();
	}
	
	private function onEnterFrame(event:Event):void
	{
		if (m_NeedBuild) Build();
	}
	
	private function Build():void
	{
		m_Width = m_WidthWish;
		if (m_Width < 32) m_Width = 32;
		m_Height = m_HeightWish;
		if (m_Height < 32) m_Height = 32;
		
		var i:int;
		var s:DisplayObject;
		var m:Sprite;

		removeChildren();

		var tl:DisplayObject = new bmTopLeft() as DisplayObject; addChild(tl);
		(tl as Bitmap).smoothing = true;
		tl.x = 0;
		tl.y = 0;

		var tr:DisplayObject = new bmTopRight() as DisplayObject; addChild(tr);
		(tr as Bitmap).smoothing = true;
		tr.x = m_Width - tr.width;
		tr.y = 0;
		var bendx:int = tr.x;

		var bl:DisplayObject = new bmBottomLeft() as DisplayObject; addChild(bl);
		(bl as Bitmap).smoothing = true;
		bl.x = 0;
		bl.y = m_Height - bl.height;
		
		var br:DisplayObject=null;
		br = new bmBottomRight() as DisplayObject; addChild(br);
		(br as Bitmap).smoothing = true;
		br.x = m_Width - br.width;
		br.y = m_Height - br.height;

		for (i = tl.y + tl.height; i < bl.y; ) {
			s = new bmLeft() as DisplayObject; addChild(s);
			(s as Bitmap).smoothing = true;
			s.x = 0;
			s.y = i;
			if (s.height > (bl.y - i)) {
				m = new Sprite(); addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, s.width, bl.y - i);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.height;			
		}

		for (i = tr.y + tr.height; i < br.y; ) {
			s = new bmRight() as DisplayObject; addChild(s);
			(s as Bitmap).smoothing = true;
			s.x = m_Width - s.width;
			s.y = i;
			if (s.height > (br.y - i)) {
				m = new Sprite(); addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, s.width, br.y - i);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.height;			
		}

		for (i = tl.x + tl.width; i < tr.x; ) {
			s = new bmTop() as DisplayObject; addChild(s);
			(s as Bitmap).smoothing = true;
			s.x = i;
			s.y = 0;
			if (s.width > (tr.x - i)) {
				m = new Sprite(); addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, tr.x - i, tr.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		for (i = bl.x + bl.width; i < br.x; ) {
			s = new bmBottom() as DisplayObject; addChild(s);
			(s as Bitmap).smoothing = true;
			s.x = i;
			s.y = m_Height - s.height;
			if (s.width > (br.x - i)) {
				m = new Sprite(); addChild(m);
				m.graphics.beginFill(0xfffffff,1);
				m.graphics.drawRect(s.x, s.y, br.x - i, br.height);
				m.graphics.endFill();
				s.mask = m;
			}
			i += s.width;
		}

		graphics.clear();
		graphics.beginFill(0xebeab7, 1);
		graphics.drawRect(16, 16, m_Width - 32, m_Height - 32);
		graphics.endFill();
		
		m_NeedBuild = false;
	}	
}
	
}