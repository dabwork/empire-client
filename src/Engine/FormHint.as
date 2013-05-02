package Engine
{
import Base.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

public class FormHint extends Sprite
{
	private var m_Map:StdMap;

	public var m_Txt:TextField;
	
	public var m_CurText:String="";
	
	public var m_Timer:Timer=new Timer(20);
	
	public var m_BeginTime:Number=0;
	public var m_AutoHideTime:Number=0;
	
	public function FormHint(map:StdMap)
	{
		m_Map=map;

		m_Txt = new TextField();
		m_Txt.width = 1;
		m_Txt.height = 1;
		m_Txt.type = TextFieldType.DYNAMIC;
		m_Txt.selectable = false;
		m_Txt.textColor = 0xffffff;
		//m_Txt.border=true;
		//m_Txt.borderColor=0x000000;
		//m_Txt.background=true;
		//m_Txt.backgroundColor=0xA0000000;
		m_Txt.multiline = true;
		m_Txt.autoSize = TextFieldAutoSize.LEFT;
		m_Txt.antiAliasType = AntiAliasType.ADVANCED;
		m_Txt.gridFitType = GridFitType.PIXEL;
		m_Txt.defaultTextFormat = new TextFormat("Calibri", 14, 0xffffff);
		m_Txt.embedFonts = true;
		addChild(m_Txt);

		m_Timer.addEventListener("timer", Takt);

		visible=false;
	}

	public function Takt(event:TimerEvent):void
	{
		if(m_AutoHideTime) {
			var a:Number = ((m_Map.m_CurTime-m_BeginTime) % 1000) / 1000;
			
			if(a<=0.5) a=a*2.0;
			else a=(1.0-a)*2.0;
			
			m_Txt.alpha=0.4+a*0.8;
		}
		if (m_AutoHideTime && m_Map.m_CurTime >= m_AutoHideTime) {
			Hide();
		}
	}

	public function Hide():void
	{
		m_Timer.stop();
		visible=false;
		m_CurText="";
	}

	public function Show(txt:String, autohidetime:int=0):void
	{
		if(txt.length<=0) { Hide(); return; }
		if(m_CurText==txt) return;

		visible=true;

		m_CurText=txt;
		m_Txt.htmlText = BaseStr.FormatTag(txt);

		m_BeginTime = m_Map.m_CurTime;// Common.GetTime();

		if(autohidetime<=0) {
			m_AutoHideTime=0;
			m_Txt.alpha=1.0;
		} else {
			m_AutoHideTime=m_BeginTime+autohidetime;
			m_Txt.alpha=0.0;
		}

		m_Timer.start();
		Update();
	}

	public function Update():void
	{
		if(!visible) return;

		//m_Txt.width=m_Map.stage.stageWidth>>1;
		//m_Txt.height=

		//m_Txt.autoSize=TextFieldAutoSize.LEFT;

		var tx:int = Math.round(((m_Map.stage.stageWidth * 0.8) >> 1) - (m_Txt.width >> 1));
		var ty:int = Math.round((m_Map.stage.stageHeight * 0.1) - (m_Txt.height >> 1));

		ty = Math.max(ty, 110);

		var sx:int=m_Txt.width;
		var sy:int=m_Txt.height;

		if(ty<0) ty=0;

		//m_Txt.autoSize=TextFieldAutoSize.NONE;
		m_Txt.x=tx;//-5;
		m_Txt.y=ty;//-5;
		//m_Txt.width=sx+10;
		//m_Txt.height=sy+5;

		graphics.clear();

		//graphics.lineStyle(1.0,0x069ee5,0.9,true);
		graphics.beginFill(0x000000,0.6);
		graphics.drawRoundRect(tx-5,ty-5,sx+10+5,sy+10,10,10);
		graphics.endFill();

		//m_Txt.htmlText="<p align=\"center\">"+m_Txt.htmlText+"</p>";
	}
	
	public function Text():String
	{
		if(!visible) return "";
		return m_CurText; 
	}
}

}
