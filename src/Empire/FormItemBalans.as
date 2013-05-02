package Empire
{
import Base.*;
import fl.controls.*;
import fl.events.*;
import flash.display.*;
import flash.events.*;
import flash.filters.*;
import flash.text.*;
import flash.utils.*;

import flash.geom.Point;

public class FormItemBalans extends Sprite
{
	private var m_Map:EmpireMap;

	//public static const SizeX:int = 150;
	public var m_SizeX:int = 150;
	public var m_SizeY:int = 0;
	
	public var m_Str:String;

	public var m_ShowFirst:Boolean = true;
	
	public var m_Frame:Sprite = new GrFrame();
	public var m_Title:TextField = new TextField();
	public var m_Txt:TextField = new TextField();

	public function FormItemBalans(map:EmpireMap)
	{
		m_Map = map;

		m_Frame.width = 10;
		m_Frame.height = 10;
		addChild(m_Frame);
		
		m_Title.x = 10;
		m_Title.y = 5;
		m_Title.width = 1;
		m_Title.height = 1;
		m_Title.type = TextFieldType.DYNAMIC;
		m_Title.selectable = false;
		m_Title.border = false;
		m_Title.background = false;
		m_Title.multiline = false;
		m_Title.autoSize = TextFieldAutoSize.LEFT;
		m_Title.antiAliasType = AntiAliasType.ADVANCED;
		m_Title.gridFitType = GridFitType.PIXEL;
		m_Title.defaultTextFormat = new TextFormat("Calibri", 16, 16776960);
		m_Title.embedFonts = true;
		addChild(m_Title);
		
		m_Txt.x = 10;
		m_Txt.y = 25;
		m_Txt.width = m_SizeX-20;
		m_Txt.height = 1;
		m_Txt.type = TextFieldType.DYNAMIC;
		m_Txt.selectable = false;
		m_Txt.border = false;
		m_Txt.background = false;
		m_Txt.multiline = true;
		m_Txt.autoSize = TextFieldAutoSize.LEFT;
		m_Txt.antiAliasType = AntiAliasType.ADVANCED;
		m_Txt.gridFitType = GridFitType.PIXEL;
		m_Txt.defaultTextFormat = new TextFormat("Calibri", 13, 0xffffff);
		m_Txt.embedFonts = true;
		addChild(m_Txt);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		m_Frame.mouseEnabled = false;
		m_Frame.mouseChildren = false;
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<m_SizeX && mouseY>=0 && mouseY<m_SizeY) return true;
		return false;
	}

	public function IsMouseInTop():Boolean
	{
		if (!IsMouseIn()) return false;

		var pt:Point = new Point(stage.mouseX, stage.mouseY);
		var ar:Array = stage.getObjectsUnderPoint(pt);

		if (ar.length <= 0) return false;

		var obj:DisplayObject = ar[ar.length - 1];
		if (obj == m_Map.m_MoveItem) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		else if (obj == m_Map.m_FormFleetBar.m_MoveLayer) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		while (obj!=null) {
			if (obj == this) return true;
			obj = obj.parent;
		}
		return false;
	}
	
	public function onStageResize(e:Event):void
	{
		if (!m_ShowFirst && EmpireMap.Self.IsResize()) {
			Show();
		}
	}

	public function Show() : void
	{
		var i:int;
		
		m_Map.FloatTop(this);

		visible = true;
		Update();

		if (m_ShowFirst) {
			m_ShowFirst = false;
			
			//x = Math.max(0, m_Map.m_FormMiniMap.x - Math.max(m_SizeX, 200));
			//y = 5;
			x = m_Map.m_FormPlanet.x + FormPlanet.SizeX + 10;
			y = m_Map.m_FormPlanet.y;
		}
	}

	public function Hide() : void
	{
		m_Str = "";
		if (visible) {
			visible = false;
			m_Map.MB_Clear();
			m_Map.m_FormMiniMap.Update();
		}
		visible = false;
		m_Map.MB_Clear();
	}

	public function onMouseDown(e:MouseEvent) : void
	{
		var planet:Planet;

		e.stopImmediatePropagation();
		m_Map.FloatTop(this);

		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true, 999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}
	
	public var m_Cnt:int = 0;
	public var m_Need:Number = 0;
	public var m_Prod:Number = 0;
	public var m_Dif:int = 0;
	
	public function SetVal(cnt:int, need:Number, prod:Number, dif:int):Boolean
	{
		var i:int;
		
		if (m_Cnt == cnt && m_Need == need && m_Prod == prod && m_Dif==dif && m_Str.length != 0) return false;
		m_Cnt = cnt;
//prod = 8.9999999;
//need = 8.75231;
		m_Prod = prod;
		m_Need = need;
		m_Dif = dif;
		
		var ts:String;

		m_Str = "";
		
		m_Str += Common.Txt.FormItemBalansCnt + ": [clr]" + BaseStr.FormatBigInt(cnt) + "[/clr][br]";

		// Производство
		m_Str += Common.Txt.FormItemBalansProd + ": [clr]" + BaseStr.FormatFloat(prod,6)+"[/clr][br]";
		
/*		m_Str += Common.Txt.FormItemBalansProd+": [clr]" + BaseStr.FormatBigInt(Math.floor(prod));
		if (((prod - Math.floor(prod)) > 0) && dif > 1) {
			ts = Math.round((prod - Math.floor(prod)) * 1000000).toString();
			m_Str += "." + ts;
			
//			var ts:String = (prod - Math.floor(prod)).toString();
//			i = ts.indexOf(".");
//			if (i >= 0) m_Str += ts.substr(i, 2 + 6);
			
			while (m_Str.length > 0) {
				i = m_Str.charCodeAt(m_Str.length - 1);
				if (i == 48) m_Str=m_Str.substr(0, m_Str.length - 1);
				else if (i == 46) { m_Str = m_Str.substr(0, m_Str.length - 1); break; }
				else break;
			}
		}
		m_Str += "[/clr][br]";*/
		
		// Потребление
		m_Str += Common.Txt.FormItemBalansNeed + ": [clr]" + BaseStr.FormatFloat(-need,6) + "[/clr][br]";
/*		m_Str += Common.Txt.FormItemBalansNeed + ": [clr]";
		if (need > 0) {
			m_Str += "-" + BaseStr.FormatBigInt(Math.floor(need));
			
			if (((need - Math.floor(need)) > 0)) {
				ts = Math.round((need - Math.floor(need)) * 1000000).toString();
				m_Str += "." + ts;

				while (m_Str.length > 0) {
					i = m_Str.charCodeAt(m_Str.length - 1);
					if (i == 48) m_Str=m_Str.substr(0, m_Str.length - 1);
					else if (i == 46) { m_Str = m_Str.substr(0, m_Str.length - 1); break; }
					else break;
				}
			}
		} else m_Str += "0";
		m_Str +=  "[/clr][br]";*/
		
		// Баланс
		m_Str += Common.Txt.FormItemBalansBalans + ": [clr]" + BaseStr.FormatFloat(prod - need,6) + "[/clr][br]";
		
/*		var bal:Number = prod - need;
		if (bal >= 0) {
			m_Str += Common.Txt.FormItemBalansBalans+": [clr]" + BaseStr.FormatBigInt(Math.floor(bal));
			if (((bal - Math.floor(bal)) > 0)) {
				ts = Math.round((bal - Math.floor(bal)) * 1000000).toString();
				m_Str += "." + ts;
				
				while (m_Str.length > 0) {
					i = m_Str.charCodeAt(m_Str.length - 1);
					if (i == 48) m_Str=m_Str.substr(0, m_Str.length - 1);
					else if (i == 46) { m_Str = m_Str.substr(0, m_Str.length - 1); break; }
					else break;
				}
			}
			m_Str += "[/clr][br]";
		} else {
			bal = -bal;
			m_Str += Common.Txt.FormItemBalansBalans+": [crt]-" + BaseStr.FormatBigInt(Math.floor(bal));
			if (((bal - Math.floor(bal)) > 0)) {
				ts = Math.round((bal - Math.floor(bal)) * 1000000).toString();
				m_Str += "." + ts;
				
				while (m_Str.length > 0) {
					i = m_Str.charCodeAt(m_Str.length - 1);
					if (i == 48) m_Str=m_Str.substr(0, m_Str.length - 1);
					else if (i == 46) { m_Str = m_Str.substr(0, m_Str.length - 1); break; }
					else break;
				}
			}
			m_Str += "[/crt][br]";
		}
		//if (Math.floor(prod) >= need) m_Str += Common.Txt.FormItemBalansBalans + ": [clr]" + BaseStr.FormatBigInt(Math.floor(prod) - need) + "[/clr][br]";
		//else m_Str += Common.Txt.FormItemBalansBalans + ": [crt]" + BaseStr.FormatBigInt(Math.floor(prod) - need) + "[/crt][br]";
*/

		Update();
		
		return true;
	}

	public function Update():void
	{
		if (!visible) return;

		m_Title.htmlText = Common.Txt.FormItemBalansCaption + ": " + m_Map.ItemName(m_Map.m_MB_ItemType);
		m_Txt.htmlText = BaseStr.FormatTag(m_Str);

		var sizey:int = m_Txt.y+m_Txt.height+10;

		m_SizeX = Math.max(10 + m_Txt.width + 10,10+m_Title.width+10);
		m_SizeY = sizey;

		m_Frame.width = m_SizeX;
		m_Frame.height = m_SizeY;
	}
}

}
