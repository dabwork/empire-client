package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormPlusar extends FormStd
{
	public var EM:EmpireMap = null;
	
	public var m_Timer:Timer = new Timer(250);
	
	public var m_Pulsar1Cost:TextField = null;
	public var m_Pulsar2Cost:TextField = null;
	public var m_Pulsar3Cost:TextField = null;
	public var m_Pulsar4Cost:TextField = null;

	public var m_Pulsar1Active:TextField = null;
	public var m_Pulsar2Active:TextField = null;
	public var m_Pulsar3Active:TextField = null;
	public var m_Pulsar4Active:TextField = null;
	
	public var m_LabelEGM:TextField = null;
	public var m_ButActivate:CtrlBut = null;
	public var m_ButReplenish:CtrlBut = null;

	public var m_Cost:int = 0;

//	public var Plusar1Text:TextField=new TextField(); 
//	public var Plusar2Text:TextField=new TextField();
//	public var Plusar3Text:TextField=new TextField();
//	public var Plusar4Text:TextField=new TextField();

//	public var tf_caption:TextFormat = new TextFormat("Calibri", 15, 0xffff00, false);
//	public var tf_text:TextFormat = new TextFormat("Calibri", 14, 0xc4fff2, false);
//	public var tf_acttime:TextFormat = new TextFormat("Calibri", 14, 0xc4fff2, false, null, null, null, null, TextFormatAlign.RIGHT);

	public function FormPlusar(em:EmpireMap)
	{
		EM = em;
		var i:int;
		
		super(true, false);
		
		width = 480;// 500;
		height = 370;
		scale = StdMap.Main.m_Scale;
		caption = Common.Txt.FormPlusarCaption;
		
		TabAdd(Common.Txt.FormPlusarModulePage);
		
		ItemLabel(Common.Txt.FormPlusarModuleCaption, false, 18);
		LocNextRow();
		ItemLabel(Common.Txt.FormPlusarModuleText, true);
		LocNextRow();
		i = ItemLabel("-"); m_Pulsar1Cost = ItemObj(i) as TextField;
		LocNextRow();
		i = ItemLabel("-"); ItemSpace(i, 0, 20); m_Pulsar1Active = ItemObj(i) as TextField;


		TabAdd(Common.Txt.FormPlusarCaptainPage);
		
		ItemLabel(Common.Txt.FormPlusarCaptainCaption, false, 18);
		LocNextRow();
		ItemLabel(Common.Txt.FormPlusarCaptainText, true);
		LocNextRow();
		i = ItemLabel("-"); m_Pulsar2Cost = ItemObj(i) as TextField;
		LocNextRow();
		i = ItemLabel("-"); ItemSpace(i, 0, 20); m_Pulsar2Active = ItemObj(i) as TextField;
		

		TabAdd(Common.Txt.FormPlusarTechPage);
		
		ItemLabel(Common.Txt.FormPlusarTechCaption, false, 18);
		LocNextRow();
		ItemLabel(Common.Txt.FormPlusarTechText, true);
		LocNextRow();
		i = ItemLabel("-"); m_Pulsar3Cost = ItemObj(i) as TextField;
		LocNextRow();
		i = ItemLabel("-"); ItemSpace(i, 0, 20); m_Pulsar3Active = ItemObj(i) as TextField;

		
		TabAdd(Common.Txt.FormPlusarControlPage);
		
		ItemLabel(Common.Txt.FormPlusarControlCaption, false, 18);
		LocNextRow();
		var v:Number = Common.PlusarModuleCost + Common.PlusarCaptainCost + Common.PlusarTechCost;
		v = (v / 7.0) * 30.0;
		v = Number(Common.PlusarControlCost) / v;
		ItemLabel(BaseStr.Replace(Common.Txt.FormPlusarControlText, "<Val>", Math.round(100.0 * (1.0 - v)).toString()), true);
		LocNextRow();
		i = ItemLabel("-"); m_Pulsar4Cost = ItemObj(i) as TextField;
		LocNextRow();
		i = ItemLabel("-"); ItemSpace(i, 0, 20); m_Pulsar4Active = ItemObj(i) as TextField;

		tab = 0;

		m_ButActivate = new CtrlBut();
		m_ButActivate.addEventListener(MouseEvent.CLICK, clickPlusar);
		addChild(m_ButActivate);

		m_ButReplenish = new CtrlBut();
		m_ButReplenish.caption = Common.Txt.FormPlusarButReplenish;
		m_ButReplenish.addEventListener(MouseEvent.CLICK, clickReplenish);
		addChild(m_ButReplenish);

		m_LabelEGM = SimpleLabel("-");

		m_Timer.addEventListener("timer", UpdateTimer);
		
		addEventListener("page", onChangePage);
		
/*
		ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		Plusar1On.addEventListener(MouseEvent.CLICK, clickPlusar1);
		Plusar2On.addEventListener(MouseEvent.CLICK, clickPlusar2);
		Plusar3On.addEventListener(MouseEvent.CLICK, clickPlusar3);
		Plusar4On.addEventListener(MouseEvent.CLICK, clickPlusar4);
*/
	}

	override public function Hide():void
	{
		m_Timer.stop();
		super.Hide();
	}

	override public function Show():void
	{
		super.Show();

		m_Timer.start();
		Update();
	}

	private function clickClose(event:MouseEvent):void
	{
		Hide();
	}

	public function UpdateTimer(event:TimerEvent=null):void
	{
		Update();
	}

	public function onChangePage(e:Event):void
	{
		Update();
	}

	public function Update():void
	{
		var v:Number;
		var str:String;

		var st:Number = EM.GetServerGlobalTime();

		if (EM.m_UserAddModuleEnd > st) {
			v = Math.floor((EM.m_UserAddModuleEnd - st) / 1000);
			m_Pulsar1Active.htmlText=BaseStr.FormatTag(Common.Txt.FormPulsarPlusarOn + ": [clr]" + Common.FormatPeriodLong(v, true, 3) + "[/clr]", true, true);

			str = Common.Txt.FormPlusarCost2;
			if (EM.m_UserControlEnd > st) v = Math.max(0, v - Math.floor((EM.m_UserControlEnd - st) / 1000));
			v = Math.min(30, 20 + 5 * Math.floor(v / (60 * 60 * 24 * 7)));
			str = BaseStr.Replace(str, "<Discount>", BaseStr.FormatBigInt(v));
			v = Math.floor(Common.PlusarModuleCost * (1.0 - 0.01 * v));
			str = BaseStr.Replace(str, "<Val>", BaseStr.FormatBigInt(v));
			m_Pulsar1Cost.htmlText = BaseStr.FormatTag(str, true, true);
		} else {
			m_Pulsar1Active.htmlText = "";
			v = Common.PlusarModuleCost;
			m_Pulsar1Cost.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormPlusarCost, "<Val>", BaseStr.FormatBigInt(v)), true, true);
		}
		if (tab == 0) m_Cost = v;

		if (EM.m_UserCaptainEnd > st) {
			v = Math.floor((EM.m_UserCaptainEnd - st) / 1000);
			m_Pulsar2Active.htmlText=BaseStr.FormatTag(Common.Txt.FormPulsarPlusarOn + ": [clr]" + Common.FormatPeriodLong(v, true, 3) + "[/clr]", true, true);

			str = Common.Txt.FormPlusarCost2;
			if (EM.m_UserControlEnd > st) v = Math.max(0, v - Math.floor((EM.m_UserControlEnd - st) / 1000));
			v = Math.min(30, 20 + 5 * Math.floor(v / (60 * 60 * 24 * 7)));
			str = BaseStr.Replace(str, "<Discount>", BaseStr.FormatBigInt(v));
			v = Math.floor(Common.PlusarCaptainCost * (1.0 - 0.01 * v));
			str = BaseStr.Replace(str, "<Val>", BaseStr.FormatBigInt(v));
			m_Pulsar2Cost.htmlText = BaseStr.FormatTag(str, true, true);
		} else {
			m_Pulsar2Active.htmlText = "";
			v = Common.PlusarCaptainCost;
			m_Pulsar2Cost.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormPlusarCost, "<Val>", BaseStr.FormatBigInt(v)), true, true);
		}
		if (tab == 1) m_Cost = v;

		if (EM.m_UserTechEnd > st) {
			v = Math.floor((EM.m_UserTechEnd - st) / 1000);
			m_Pulsar3Active.htmlText = BaseStr.FormatTag(Common.Txt.FormPulsarPlusarOn + ": [clr]" + Common.FormatPeriodLong(v, true, 3) + "[/clr]", true, true);

			str = Common.Txt.FormPlusarCost2;
			if (EM.m_UserControlEnd > st) v = Math.max(0, v - Math.floor((EM.m_UserControlEnd - st) / 1000));
			v = Math.min(30, 20 + 5 * Math.floor(v / (60 * 60 * 24 * 7)));
			str = BaseStr.Replace(str, "<Discount>", BaseStr.FormatBigInt(v));
			v = Math.floor(Common.PlusarTechCost * (1.0 - 0.01 * v));
			str = BaseStr.Replace(str, "<Val>", BaseStr.FormatBigInt(v));
			m_Pulsar3Cost.htmlText = BaseStr.FormatTag(str, true, true);
		} else {
			m_Pulsar3Active.htmlText = "";
			v = Common.PlusarTechCost;
			m_Pulsar3Cost.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormPlusarCost, "<Val>", BaseStr.FormatBigInt(v)), true, true);
		}
		if (tab == 2) m_Cost = v;

		if (EM.m_UserControlEnd > st) {
			v = Math.floor((EM.m_UserControlEnd - st) / 1000);
			m_Pulsar4Active.htmlText = BaseStr.FormatTag(Common.Txt.FormPulsarPlusarOn + ": [clr]" + Common.FormatPeriodLong(v, true, 3) + "[/clr]", true, true);

			str = Common.Txt.FormPlusarCost2;
			v = Math.min(30, 20 + 5 * Math.floor(v / (60 * 60 * 24 * 30)));
			str = BaseStr.Replace(str, "<Discount>", BaseStr.FormatBigInt(v));
			v = Math.floor(Common.PlusarControlCost * (1.0 - 0.01 * v));
			str = BaseStr.Replace(str, "<Val>", BaseStr.FormatBigInt(v));
			m_Pulsar4Cost.htmlText = BaseStr.FormatTag(str, true, true);
		} else {
			m_Pulsar4Active.htmlText = "";
			v = Common.PlusarControlCost;
			m_Pulsar4Cost.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormPlusarCost, "<Val>", BaseStr.FormatBigInt(v)), true, true);
		}
		if (tab == 3) m_Cost = v;

		if (tab == 0 && (EM.m_UserAddModuleEnd > st)) m_ButActivate.caption = Common.Txt.FormPlusarButProlong;
		else if (tab == 1 && (EM.m_UserCaptainEnd > st)) m_ButActivate.caption = Common.Txt.FormPlusarButProlong;
		else if (tab == 2 && (EM.m_UserTechEnd > st)) m_ButActivate.caption = Common.Txt.FormPlusarButProlong;
		else if (tab == 3 && (EM.m_UserControlEnd > st)) m_ButActivate.caption = Common.Txt.FormPlusarButProlong;
		else m_ButActivate.caption = Common.Txt.FormPlusarButOn;
		if (tab == 0 && (EM.m_UserAddModuleEnd > (st + 1000 * 60 * 60 * 24 * 360))) m_ButActivate.disable = true;
		else if (tab == 1 && (EM.m_UserCaptainEnd > (st + 1000 * 60 * 60 * 24 * 360))) m_ButActivate.disable = true;
		else if (tab == 2 && (EM.m_UserTechEnd > (st + 1000 * 60 * 60 * 24 * 360))) m_ButActivate.disable = true;
		else if (tab == 3 && (EM.m_UserControlEnd > (st + 1000 * 60 * 60 * 24 * 360))) m_ButActivate.disable = true;
		else m_ButActivate.disable = false;
		m_ButActivate.x = width - m_ButActivate.width - 25;
		m_ButActivate.y = height - m_ButActivate.height - 35;
		
		m_ButReplenish.x = m_ButActivate.x - 1 - m_ButReplenish.width;
		m_ButReplenish.y = height - m_ButActivate.height - 35;

		m_LabelEGM.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormPlusarEGM, "<Val>", BaseStr.FormatBigInt(EM.m_UserEGM)), true, true);
		m_LabelEGM.width; m_LabelEGM.height;
		m_LabelEGM.x = 35;
		m_LabelEGM.y = m_ButActivate.y + (m_ButActivate.height >> 1) - (m_LabelEGM.height >> 1);
		
/*
		var v:int, i:int;
		LabelEGM.htmlText=Common.Txt.PlusarEGM+" <font color='#ffff00'>"+BaseStr.FormatBigInt(EM.m_UserEGM)+"</font> egm";
		
		Plusar1On.visible=(EM.m_UserAddModuleEnd<=EM.GetServerTime()) && (EM.m_UserControlEnd<=EM.GetServerTime());
		Plusar2On.visible=(EM.m_UserCaptainEnd<=EM.GetServerTime()) && (m_Map.m_UserControlEnd<=m_Map.GetServerTime());
		Plusar3On.visible=(m_Map.m_UserTechEnd<=m_Map.GetServerTime()) && (m_Map.m_UserControlEnd<=m_Map.GetServerTime());
		Plusar4On.visible=(m_Map.m_UserControlEnd<=m_Map.GetServerTime());

		var str:String;
		
		if(m_Map.m_UserAddModuleEnd>m_Map.GetServerTime()) {
			str="<font color='#00ff00'>("+Common.Txt.PlusarOn+": ";
			v=Math.floor((m_Map.m_UserAddModuleEnd-m_Map.GetServerTime())/1000);

			i=Math.floor(v/(24*60*60)); str+=i.toString();
			str+=" ";
			i=Math.floor((v % (24*60*60))/(60*60)); str+=i.toString();
			str+=":";
			i=Math.floor((v % (60*60))/60); str+=i.toString();
			str+=":";
			i=Math.floor((v % (60))); str+=i.toString();

			str+=")</font>";

			Plusar1ActTime.htmlText=str;
			Plusar1ActTime.visible=true;
		} else Plusar1ActTime.visible=false;
		Plusar1Caption.htmlText=Common.Txt.PlusarModuleCaption;
		Plusar1Text.htmlText=Common.Txt.PlusarModuleText+"\n"+Common.Txt.PlusarCost+": <font color='#ffff00'>"+BaseStr.FormatBigInt(Common.PlusarModuleCost)+"</font> egm";

		if(m_Map.m_UserCaptainEnd>m_Map.GetServerTime()) {
			str="<font color='#00ff00'>("+Common.Txt.PlusarOn+": ";
			v=Math.floor((m_Map.m_UserCaptainEnd-m_Map.GetServerTime())/1000);

			i=Math.floor(v/(24*60*60)); str+=i.toString();
			str+=" ";
			i=Math.floor((v % (24*60*60))/(60*60)); str+=i.toString();
			str+=":";
			i=Math.floor((v % (60*60))/60); str+=i.toString();
			str+=":";
			i=Math.floor((v % (60))); str+=i.toString();

			str+=")</font>";
			
			Plusar2ActTime.htmlText=str;
			Plusar2ActTime.visible=true;
		} else Plusar2ActTime.visible=false;
		Plusar2Caption.htmlText=Common.Txt.PlusarCaptainCaption;
		Plusar2Text.htmlText=Common.Txt.PlusarCaptainText+"\n"+Common.Txt.PlusarCost+": <font color='#ffff00'>"+BaseStr.FormatBigInt(Common.PlusarCaptainCost)+"</font> egm";

		if(m_Map.m_UserTechEnd>m_Map.GetServerTime()) {
			str="<font color='#00ff00'>("+Common.Txt.PlusarOn+": ";
			v=Math.floor((m_Map.m_UserTechEnd-m_Map.GetServerTime())/1000);

			i=Math.floor(v/(24*60*60)); str+=i.toString();
			str+=" ";
			i=Math.floor((v % (24*60*60))/(60*60)); str+=i.toString();
			str+=":";
			i=Math.floor((v % (60*60))/60); str+=i.toString();
			str+=":";
			i=Math.floor((v % (60))); str+=i.toString();

			str+=")</font>";
			
			Plusar3ActTime.htmlText=str;
			Plusar3ActTime.visible=true;
		} else Plusar3ActTime.visible=false;
		Plusar3Caption.htmlText=Common.Txt.PlusarTechCaption;
		Plusar3Text.htmlText=Common.Txt.PlusarTechText+"\n"+Common.Txt.PlusarCost+": <font color='#ffff00'>"+BaseStr.FormatBigInt(Common.PlusarTechCost)+"</font> egm";

		if(m_Map.m_UserControlEnd>m_Map.GetServerTime()) {
			str="<font color='#00ff00'>("+Common.Txt.PlusarOn+": ";
			v=Math.floor((m_Map.m_UserControlEnd-m_Map.GetServerTime())/1000);

			i=Math.floor(v/(24*60*60)); str+=i.toString();
			str+=" ";
			i=Math.floor((v % (24*60*60))/(60*60)); str+=i.toString();
			str+=":";
			i=Math.floor((v % (60*60))/60); str+=i.toString();
			str+=":";
			i=Math.floor((v % (60))); str+=i.toString();

			str+=")</font>";
			
			Plusar4ActTime.htmlText=str;
			Plusar4ActTime.visible=true;
		} else Plusar4ActTime.visible=false;
		Plusar4Caption.htmlText=Common.Txt.PlusarControlCaption;
		Plusar4Text.htmlText=Common.Txt.PlusarControlText+"\n"+Common.Txt.PlusarCost+": <font color='#ffff00'>"+BaseStr.FormatBigInt(Common.PlusarControlCost)+"</font> egm";
		
		var yy:int=15;

		Plusar1Caption.y=yy;
		Plusar1ActTime.y=yy+2;
		Plusar1On.y=yy;
		Plusar1Text.y=yy+25;
		Plusar1Text.wordWrap=true;
		Plusar1Text.autoSize=TextFieldAutoSize.LEFT;
		//Plusar1Text.textField.border=true; Plusar1Text.textField.borderColor=0xffffff;
		yy+=25+Plusar1Text.height+10;

		Plusar2Caption.y=yy;
		Plusar2ActTime.y=yy+2;
		Plusar2On.y=yy;
		Plusar2Text.y=yy+25;
		Plusar2Text.wordWrap=true;
		Plusar2Text.autoSize=TextFieldAutoSize.LEFT;
		//Plusar2Text.textField.border=true; Plusar2Text.textField.borderColor=0xffffff;
		yy+=25+Plusar2Text.height+10;

		Plusar3Caption.y=yy;
		Plusar3ActTime.y=yy+2;
		Plusar3On.y=yy;
		Plusar3Text.y=yy+25;
		Plusar3Text.wordWrap=true;
		Plusar3Text.autoSize=TextFieldAutoSize.LEFT;
		//Plusar3Text.textField.border=true; Plusar3Text.textField.borderColor=0xffffff;
		yy+=25+Plusar3Text.height+10;

		Plusar4Caption.y=yy;
		Plusar4ActTime.y=yy+2;
		Plusar4On.y=yy;
		Plusar4Text.y=yy+25;
		Plusar4Text.wordWrap=true;
		Plusar4Text.autoSize=TextFieldAutoSize.LEFT;
		//Plusar4Text.textField.border=true; Plusar4Text.textField.borderColor=0xffffff;
		yy+=25+Plusar4Text.height+10;

		yy+=10;
		LabelEGM.y=yy;
		ButReplenish.y=yy;
		ButClose.y=yy;
		yy+=22;

		Frame.height=yy+20;*/
	}
	
	private function clickPlusar(event:Event):void
	{
		if (EM.m_UserEGM < m_Cost) {
			FormMessageBox.RunErr(Common.Txt.NoEnoughEGM);
			return;
		}

		var st:Number = EmpireMap.Self.GetServerGlobalTime();

		if (tab == 0) FormMessageBox.Run((EM.m_UserAddModuleEnd > st)?Common.Txt.FormPlusarModuleQuery2:Common.Txt.FormPlusarModuleQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, Plusar1Activate);
		else if (tab == 1) FormMessageBox.Run((EM.m_UserCaptainEnd > st)?Common.Txt.FormPlusarCaptainQuery2:Common.Txt.FormPlusarCaptainQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, Plusar2Activate);
		else if (tab == 2) FormMessageBox.Run((EM.m_UserTechEnd > st)?Common.Txt.FormPlusarTechQuery2:Common.Txt.FormPlusarTechQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, Plusar3Activate);
		else if (tab == 3) FormMessageBox.Run((EM.m_UserControlEnd > st)?Common.Txt.FormPlusarControlQuery2:Common.Txt.FormPlusarControlQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, Plusar4Activate);
	}

	private function Plusar1Activate():void
	{
		EM.SendAction("emplusar", "1_0_0_-1_" + m_Cost.toString());
	}

	private function Plusar2Activate():void
	{
		EM.SendAction("emplusar","2_0_0_-1_" + m_Cost.toString());
	}

	private function Plusar3Activate():void
	{
		EM.SendAction("emplusar", "5_0_0_-1_" + m_Cost.toString());
	}

	private function Plusar4Activate():void
	{
		EM.SendAction("emplusar", "6_0_0_-1_" + m_Cost.toString());
	}

	private function clickReplenish(e:Event=null):void
	{
		try {
			var request:URLRequest = new URLRequest("http://www.elementalgames.com/money_buy");
			navigateToURL(request,"_blank");
		}
		catch (e:Error) {
		}
	}
}

}
