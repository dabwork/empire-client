package Engine
{
import flash.display.*;
import flash.events.*;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.*;
import flash.text.engine.*;

public class CtrlInput extends Sprite
{
	private var m_Frame:CtrlFrame = null;
	
	CONFIG::mobil {
		private var m_Input:StageText = null;
	}
	CONFIG::mobiloff {
		private var m_Input:TextField = null;
	}
	
	private var m_WidthMin:int = 50;
	private var m_WidthWish:int = 0;
	private var m_Width:int = 0;
	private var m_HeightMin:int = 1;
	private var m_HeightWish:int = 0;
	private var m_Height:int = 0;
	
	private var m_Multiline:Boolean = false;
	
	private var m_LineMetric:TextLineMetrics = null;

	private var m_NeedBuild:Boolean = true;
	private var m_FontFix:Boolean = false;

	private var m_Form:DisplayObject = null;

	public function set widthMin(v:Number):void { if (v < 50) v = 50; if (m_WidthMin == v) return; m_WidthMin = v; m_NeedBuild = true; }
	public function get widthMin():Number { return m_WidthMin; }
	public function set heightMin(v:Number):void { if (v < 1) v = 1; if (m_HeightMin == v) return; m_HeightMin = v; m_NeedBuild = true; }
	public function get heightMin():Number { return m_HeightMin; }

	override public function set width(v:Number):void { if (m_WidthWish == v) return; m_WidthWish = v; m_NeedBuild = true; }
	override public function get width():Number	{ if (m_NeedBuild) Build(); return m_Width; }
	override public function set height(v:Number):void { if (m_HeightWish == v) return; m_HeightWish = v; m_NeedBuild = true; }
	override public function get height():Number { if (m_NeedBuild) Build(); return m_Height; }

	public function CtrlInput(form:DisplayObject, fontfix:Boolean = false, multiline:Boolean = false):void
	{
		m_Form = form;
		m_Multiline = multiline;
		m_FontFix = fontfix;

		m_Frame = new CtrlFrame();
		addChild(m_Frame);
		
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);

		addEventListener(Event.RENDER, onRender);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		createInput();
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

	private function createInput():void
	{
		m_LineMetric = null;
		CONFIG::mobil {
			if (m_Input) {
				m_Input.dispose();
				m_Input = null;
			}
			m_Input = new StageText(new StageTextInitOptions(m_Multiline));
			if (m_FontFix) {
				m_Input.fontFamily = "Courier New";
			} else {
				m_Input.fontFamily = "Calibri";
				m_Input.fontSize = Math.floor(m_Form.scaleX * 14);
			}
			m_Input.color = 0x000000;
//			m_Input.addEvent
		}
		CONFIG::mobiloff {
			if (m_Input == null) {
				m_Input = new TextField();
				addChild(m_Input);
			}

			m_Input.width=1;
			m_Input.height=1;
			m_Input.type=TextFieldType.INPUT;
			//m_Input.selectable=false;
			m_Input.textColor = 0x000000;
			m_Input.background=false;
			m_Input.backgroundColor = 0x80000000;
			m_Input.alpha=1.0;
			m_Input.multiline = m_Multiline;
			if (m_FontFix) {
				var tf:TextFormat = new TextFormat("Courier New", 14, 0x000000);
				var a:Array = new Array(); for (var i:int = 1; i < 100; i++) a.push(i * 32);
				tf.tabStops = a;
				
				m_Input.embedFonts = false;
				m_Input.antiAliasType = AntiAliasType.ADVANCED;
				m_Input.gridFitType = GridFitType.SUBPIXEL;
				m_Input.alwaysShowSelection = true;
				m_Input.defaultTextFormat = tf;
			} else {
				m_Input.embedFonts = true;
				m_Input.antiAliasType = AntiAliasType.ADVANCED;
				m_Input.gridFitType=GridFitType.PIXEL;
				m_Input.defaultTextFormat=new TextFormat("Calibri",14,0x000000);
			}
			m_Input.autoSize=TextFieldAutoSize.NONE;
			m_Input.visible = true;
			m_Input.text = "";
		}
		m_NeedBuild = true;
	}
	
	private function FindForm():DisplayObject
	{
		var p:DisplayObject;
		p = parent;
		while (p != null) {
			if (p is FormStd) return p;
			p = p.parent;
		}
		return null;
	}
	
	private function onAddedToStage(e:Event):void
	{
		CONFIG::mobil {
			m_Input.stage = stage;
		}
//trace("form:", FindForm());

//		FindForm().addEventListener("change_pos", onChangePosForm);
		
		m_NeedBuild = true;
		
	}

	private function onRemoveFromStage(e:Event):void
	{
		CONFIG::mobil {
			m_Input.stage = null;
//			m_Input.dispose();
		}
//trace("form:", FindForm());

//		FindForm().removeEventListener("change_pos", onChangePosForm);
	}

	private function onChangePosForm(e:Event):void
	{
		CONFIG::mobil {
			if(visible) Build();
		}
	}

	private function onRender(event:Event):void
	{
		CONFIG::mobil {
			Build();
		}
		CONFIG::mobiloff {
			if (m_NeedBuild) Build();
		}
	}
	
	private function onEnterFrame(event:Event):void
	{
		CONFIG::mobil {
			Build();
		}
		CONFIG::mobiloff {
			if (m_NeedBuild) Build();
		}
	}
	
	private function Build():void
	{
		m_Width = m_WidthWish;
		if (m_Width < m_WidthMin) m_Width = m_WidthMin;
		m_Height = m_HeightWish;
		var minh:int = 8 + getTotalFontHeight() + 10;
		if (m_Height < minh) m_Height = minh;
		if (m_Height < m_HeightMin) m_Height = m_HeightMin;
		//if (m_Height < 34) m_Height = 34;

		m_Frame.width = m_Width;
		m_Frame.height = m_Height;

		CONFIG::mobil {
			var tp:Point = new Point(12, 8 + 2);
			tp = localToGlobal(tp);
			
			var r:Rectangle = new Rectangle(tp.x, tp.y, Math.ceil(m_Form.scaleX * (m_Width - 12 - 12)), Math.ceil(m_Form.scaleX * (m_Height - 8 - 10)));
			m_Input.viewPort = r;
		}
		CONFIG::mobiloff {
			m_Input.x = 12;
			m_Input.y = 8;
			m_Input.width = m_Width - 12 - 12;
			m_Input.height = m_Height - 8 - 7;
		}
		
		m_NeedBuild = false;
	}

	public override function set visible(v:Boolean):void
	{
		if (visible == v) return;
		super.visible = v;
		CONFIG::mobil {
			m_Input.visible = v;
			if (!v) {
//				m_Input.dispose();
			}
		}
	}

	public function set restrict(v:*):void
	{
		m_Input.restrict = v;
	}
	
	public function set displayAsPassword(v:Boolean):void
	{
		m_Input.displayAsPassword = v;
	}
	
	public function get selectionEndIndex():int
	{
		CONFIG::mobil {
			return m_Input.selectionAnchorIndex;
		}
		CONFIG::mobiloff {
			return m_Input.selectionEndIndex;
		}
	}
	
	public function setSelection(begin:int, end:int):void
	{
		CONFIG::mobil {
			m_Input.selectRange(begin,end);
		}
		CONFIG::mobiloff {
			m_Input.setSelection(begin,end);
		}
	}
	
	public function assignFocus():void
	{
		CONFIG::mobil {
			m_Input.assignFocus();
		}
		CONFIG::mobiloff {
			StdMap.Main.stage.focus = m_Input;
			//EmpireMap.Self.stage.focus = m_Input;
		}
	}

	public function setRestrict(maxlen:int, digit:Boolean = true, lang:int = 0, pun:Boolean = true, addchar:String = null):void
	{
		var re:String = "";
		if (digit) re += "0-9"; 
		if (pun) re += "_\.,;:!?()[]/#$%&*=\\+\\-\"";
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
	
	public function get input():EventDispatcher
	{
		return m_Input;
	}
	
	public function set wordWrap(v:Boolean):void
	{
		m_Input.wordWrap = v;
	}
}

}