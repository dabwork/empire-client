// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
//import fl.controls.*;
//import fl.events.*;
import QE.*;

import flash.system.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormDialog extends FormStd
{
//http://sourceforge.net/projects/notepad-plus/files/
	public static var Self:FormDialog = null;
	
//	public var EM:EmpireMap = null;

	public var m_Content:Array = new Array();
	
	public var m_PanelText:Sprite = new Sprite();
	public var m_MaskText:Sprite = new Sprite();
	public var m_ScrollText:CtrlScrollBar = new CtrlScrollBar();
	
	public var m_TextHeight:int = 0;
	public var m_TextWinWidth:int = 0;
	public var m_TextWinHeight:int = 0;
	public var m_Text:TextField = null;
	
	public var m_AnswerHeight:int = 0;
	public var m_AnswerWinWidth:int = 0;
	public var m_AnswerWinHeight:int = 0;

	public var m_Face:Bitmap = null;
	
	public var m_PanelAnswer:Sprite = new Sprite();
	public var m_MaskAnswer:Sprite = new Sprite();
	public var m_ScrollAnswer:CtrlScrollBar = new CtrlScrollBar();
	
	public var m_Answer:Vector.<AnswerUnit> = new Vector.<AnswerUnit>();
//	public var m_AnswerGoTo:Vector.<QEAnswer> = new Vector.<QEAnswer>();

	static public const SizeX:int=500;
	static public const SizeYText:int=259;

	public var m_SizeY:int=0;

	public var m_CurGr:Object = null;
	
	//public var m_QuestName:String = null;
	public var m_QuestId:uint = 0;
	public var m_QuestPage:int = -1;
	
	public var m_RndVal:int = 0;
	
	public var m_TextVal:String = "";
	
	public var m_TimerUpdate:Timer = new Timer(1000);
	
	public var m_GoTo:String = null;
	
	public function get EM():EmpireMap { return EmpireMap.Self; }

	public function FormDialog()//em:EmpireMap)
	{
		super(true, false);

		//EM = em;
		
		width = 480;// 500;
		height = SizeYText;
		scale = StdMap.Main.m_Scale;
		//setPos(0.0171875, 0.0625, -1, -1);
		setPos(0.091, 0.15753424657534246, -1, -1);
		contentSpaceTop = 30;

		Self = this;
		
		addChild(m_PanelText);
		addChild(m_MaskText);
		m_PanelText.mask = m_MaskText;

		m_Text=new TextField();
		m_Text.width=SizeX;
		m_Text.height=SizeYText;
		m_Text.type=TextFieldType.DYNAMIC;
		m_Text.selectable=false;
		m_Text.textColor=0x000000;
		m_Text.background=false;
		m_Text.multiline = true;
		m_Text.wordWrap = true;
		m_Text.antiAliasType=AntiAliasType.ADVANCED;
		m_Text.autoSize=TextFieldAutoSize.LEFT;
		m_Text.gridFitType=GridFitType.PIXEL;
		m_Text.defaultTextFormat = new TextFormat("Calibri", 14, 0x000000, null, null, null, null, null, null, null, null, 20);
		m_Text.embedFonts = true;
		m_Text.mouseEnabled = false;
		m_PanelText.addChild(m_Text);

		m_ScrollText.style = CtrlScrollBar.StyleVertical;
		m_ScrollText.addEventListener(Event.CHANGE, ScrollTextChange);
		addChild(m_ScrollText);

		addChild(m_PanelAnswer);
		addChild(m_MaskAnswer);
		m_PanelAnswer.mask = m_MaskAnswer;

		m_ScrollAnswer.style = CtrlScrollBar.StyleVertical;
		m_ScrollAnswer.addEventListener(Event.CHANGE, ScrollTextChange);
		addChild(m_ScrollAnswer);

		var d:DisplayObject;
		
		d = new bmFaceFrameDecor();
		d.x = 122;
		d.y = -12;
		addChild(d);

		d = new bmFaceFrameBg();
		d.x = 25;
		d.y = -60;
		addChild(d);
		
		m_Face=new Bitmap();
		//m_Face.bitmapData = new Face(93, 104);
		m_Face.x = d.x + 10;
		m_Face.y = d.y + 7;
		addChild(m_Face);
		
		var d2:DisplayObject = new bmFaceFrameTop();
		d2.x = d.x;
		d2.y = d.y;
		addChild(d2);
		
//		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		m_TimerUpdate.addEventListener(TimerEvent.TIMER, onTimerUpdate);
	}

	public function ShowEx(questid:uint, sgoto:String = null):void
	{
		if (visible) Hide();
		m_QuestId = questid;
		m_QuestPage = -1;
		m_RndVal = getTimer();
		m_GoTo = sgoto;
		m_ScrollText.position = 0;
		m_ScrollAnswer.position = 0;
		
		Show();
	}

	override public function Show():void
	{
		if (visible) Hide();
		
		super.Show();
		
		m_TimerUpdate.start();

//		x = 60;//Math.ceil(parent.stage.stageWidth/2-SizeX/2);
//		y = Math.ceil(parent.stage.stageHeight / 2 - (SizeYText + 100) / 2);

		var qe:QEEngine = QEManager.FindById(m_QuestId);
		if (qe == null) { Hide(); return; }
		
		if (qe.m_StateSelection || qe.m_StateReward) { Hide(); return; }
		
		QEManager.GlobalVarSave();
		QEManager.GlobalVarToQuest(qe);
		m_QuestPage = qe.DialogBegin();
		QEManager.GlobalVarFromQuest(qe);
		QEManager.GloablVarSend();
		if (m_QuestPage < 0) { Hide(); return; }
		
		UpdateFace();
		
		PreparePage();
//		GoTo("Begin");
	}

	override public function Hide():void
	{
		if (!visible) return;
		
		m_TimerUpdate.stop();
		
		if(m_QuestId!=0) {
			var qe:QEEngine = QEManager.FindById(m_QuestId);
			if (qe != null) {
				qe.m_OpenAfterLoad = false;
				qe.m_StateSelectionFail = false;
			}
		}
		
		AnswerClear();
		super.Hide();
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(m_Face.hitTestPoint(stage.mouseX,stage.mouseY)) return true;
		return mouseX>=0 && mouseX<width && mouseY>=0 && mouseY<height;
	}

	public function AnswerClear():void
	{
		var i:int;
		for (i = 0; i < m_Answer.length; i++) {
			var a:AnswerUnit = m_Answer[i];
			if (a.m_Text != null) {
				m_PanelAnswer.removeChild(a.m_Text);
				a.m_Text = null;
			}
			a.m_QA = null;
		}
		m_Answer.length=0;
	}
	
	public function AnswerAdd(txt:String, qcur:int, answer:QEAnswer):void
	{
		var l:TextField;

		var a:AnswerUnit = new AnswerUnit();
		a.m_TextVal = txt;
		a.m_QuestId = m_QuestId;
		a.m_QuestCur = qcur;
		a.m_QuestPage = m_QuestPage;
		a.m_QA = answer;

		l=new TextField();
		l.y=0;
		l.x=0;
		l.width=1;
		l.height=1;
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background=false;
		l.multiline=true;
		l.wordWrap=true;
		l.autoSize=TextFieldAutoSize.LEFT;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.PIXEL;
		l.defaultTextFormat=new TextFormat("Calibri",14,0x000000);
		l.embedFonts = true;
		l.htmlText = "- " + BaseStr.FormatTag(txt, true, true);
		l.backgroundColor=0xedebe0;
		l.addEventListener(MouseEvent.MOUSE_OVER,aOver);
		l.addEventListener(MouseEvent.MOUSE_OUT,aOut);
		//l.addEventListener(MouseEvent.CLICK,aClick);
		l.addEventListener(MouseEvent.MOUSE_UP, aClick);
		m_PanelAnswer.addChild(l);
		a.m_Text = l;

		m_Answer.push(a);
	}
	
	public function SetText(str:String):void
	{
		if (str == null) str = "";
		if (m_TextVal == str) return;
		m_TextVal = str;
		
//		m_Text.width = SizeX - 80 - 10;
		m_Text.htmlText = "<p align='justify'>" + BaseStr.FormatTag(m_TextVal, true, true) + "</p>";
	}
	
	public function onTimerUpdate(event:TimerEvent):void
	{
		PreparePage();
	}
	
	public function PreparePage(lvl:int = 0):void
	{
		var i:int;

		var qe:QEEngine = QEManager.FindById(m_QuestId);
		if (qe == null) { Hide(); return; }
		
		if (m_GoTo != null) {
			m_RndVal = getTimer();
			var str:String = m_GoTo;
			m_GoTo = null;

			QEManager.GlobalVarSave();
			QEManager.GlobalVarToQuest(qe);
			var q:QEQuest = null;
			if (BaseStr.EqNCEng(str, "begin") && qe.m_Num >= 0 && qe.m_Num < qe.m_QuestList.length) q = qe.m_QuestList[qe.m_Num];
			m_QuestPage = qe.DialogGoTo(str,q);
			QEManager.GlobalVarFromQuest(qe);
			QEManager.GloablVarSend();
		}
		
		if (m_QuestPage < 0 || m_QuestPage >= qe.m_PageList.length) { Hide(); return; }

		var rnd:PRnd = new PRnd();
		rnd.Set(m_RndVal); rnd.RndEx();

		var nu:Boolean = false;
		
		QEManager.GlobalVarSave();
		QEManager.GlobalVarToQuest(qe);
		
		var newtext:String = qe.DialogText(m_QuestPage, rnd);
		if (newtext != m_TextVal) nu = true;
		
		var qnum:int = qe.NumShow();

		var al:Vector.<QEAnswer> = new Vector.<QEAnswer>();
		var tl:Vector.<String> = new Vector.<String>();
		qe.DialogAnswer(m_QuestPage, rnd, al);
		if (al.length != m_Answer.length) nu = true;
		for (i = 0; i < al.length; i++) {
			tl.push(qe.BuildText(m_QuestPage, rnd, al[i].m_TextList));

			if (nu) continue;
			else if (tl[i] != m_Answer[i].m_TextVal) nu = true;
			else if (al[i] != m_Answer[i].m_QA) nu = true;
			else if (m_QuestId != m_Answer[i].m_QuestId) nu = true;
			else if (qnum != m_Answer[i].m_QuestCur) nu = true;
			else if (m_QuestPage != m_Answer[i].m_QuestPage) nu = true;
		}

		QEManager.GlobalVarFromQuest(qe);
		QEManager.GloablVarSend();
		
		if (m_GoTo != null && lvl<10) {
			PreparePage(lvl + 1);
			return;
		}

		if (nu) {
			SetText(newtext);

			AnswerClear();
			for (i = 0; i < al.length;i++) {
				AnswerAdd(tl[i], qnum, al[i]);
			}

			UpdatePos();
		}
	}
	
	public static function BitmapFace(race:int, num:int):BitmapData
	{
		if (race == Common.RaceNone) return null;
		if (num == -2 && race == Common.RacePeople) {
			return new Face();

		} else if (num == -1 && (race >= Common.RaceGrantar || race >= Common.RaceGaal)) {
			return Common.CreateByName("Face" + Common.RaceSysName[race] + "News") as BitmapData;

		} else {
			var clname:String = (Math.abs(num ) % Common.RaceFaceCnt[race]).toString();
			if(clname.length==1) clname="0"+clname;
			clname="Face"+Common.RaceSysName[race]+clname;

			return Common.CreateByName(clname) as BitmapData;
		}
		return null;
	}
	
	public function UpdateFace():void
	{
		var qe:QEEngine = QEManager.FindById(m_QuestId);
		if (qe == null || Common.RaceFaceCnt[qe.m_FaceRace] <= 0) {
			m_Face.bitmapData = null;
			caption = "";
		} else {
			m_Face.bitmapData = BitmapFace(qe.m_FaceRace, qe.m_FaceNum);
			caption = qe.m_FaceName;
		}
	}
	
	public function UpdatePos(e:Event=null):void
	{
		var l:TextField;
		var i:int;
		var a:AnswerUnit;
		
		var sy:int;

//		if(sy==m_SizeY) return;
		
		// Text
		m_TextWinWidth = contentWidth-5;
		m_Text.width = m_TextWinWidth;
		m_Text.height;

		m_TextHeight = m_Text.height;
		m_TextWinHeight = m_TextHeight;
		//trace("SizeYText:", m_TextHeight);
		if (m_TextWinHeight < 100) m_TextWinHeight = 100;
		else if (m_TextWinHeight > SizeYText) m_TextWinHeight = SizeYText;

		if (m_TextHeight > m_TextWinHeight) {
			m_TextWinWidth = contentWidth - 5 - m_ScrollText.width;// - 10;
			m_Text.width = m_TextWinWidth;
			m_Text.height;

			m_TextHeight = m_Text.height;
			m_TextWinHeight = m_TextHeight;
			if (m_TextWinHeight < 100) m_TextWinHeight = 100;
			else if (m_TextWinHeight > 250) m_TextWinHeight = 250;

			m_ScrollText.x = contentX + m_TextWinWidth + 15;
			m_ScrollText.y = contentY - 5;
			m_ScrollText.height = m_TextWinHeight + 10;
			m_ScrollText.setRange(0, m_TextHeight, 17, m_TextWinHeight);
			m_ScrollText.Show();
		} else {
			m_ScrollText.Hide();
			m_ScrollText.position = 0;
		}

		m_MaskText.x = contentX;
		m_MaskText.y = contentY;
		m_PanelText.x = m_MaskText.x;
		m_PanelText.y = m_MaskText.y - m_ScrollText.position;
		m_MaskText.graphics.clear();
		m_MaskText.graphics.beginFill(0xffffff);
		m_MaskText.graphics.drawRect(0, 0, m_TextWinWidth, m_TextWinHeight);
		m_MaskText.graphics.endFill();

		splitPos = contentY + m_TextWinHeight + 15;
		sy = m_TextWinHeight + 30;
		
		// Answer
		m_AnswerWinWidth = contentWidth;
		
		m_AnswerHeight = 0;
		if(m_Answer.length>0) {
			for(i=0;i<m_Answer.length;i++) {
				a = m_Answer[i];
				a.m_Text.width = m_AnswerWinWidth;
				a.m_Text.y = m_AnswerHeight;
				a.m_Text.height;
				m_AnswerHeight += a.m_Text.height + 3;
			}
		}

		m_AnswerWinHeight = m_AnswerHeight;
		if (m_AnswerWinHeight < 25) m_AnswerWinHeight = 25;
		else if (m_AnswerWinHeight > 150) m_AnswerWinHeight = 150;

		if (m_AnswerHeight > m_AnswerWinHeight) {
			m_AnswerWinWidth = contentWidth - m_ScrollAnswer.width + 10;

			m_AnswerHeight = 0;
			if(m_Answer.length>0) {
				for(i=0;i<m_Answer.length;i++) {
					a = m_Answer[i];
					a.m_Text.width = m_AnswerWinWidth;
					a.m_Text.y = m_AnswerHeight;
					a.m_Text.height;
					m_AnswerHeight += a.m_Text.height + 3;
				}
			}

			m_AnswerWinHeight = m_AnswerHeight;
			if (m_AnswerWinHeight < 25) m_AnswerWinHeight = 25;
			else if (m_AnswerWinHeight > 150) m_AnswerWinHeight = 150;

			m_ScrollAnswer.x = contentX + m_AnswerWinWidth;
			m_ScrollAnswer.y = contentY + sy - 5;
			m_ScrollAnswer.height = m_AnswerWinHeight + 10;
			m_ScrollAnswer.setRange(0, m_AnswerHeight, 21 + 3, m_AnswerWinHeight);
			m_ScrollAnswer.Show();
		} else {
			m_ScrollAnswer.Hide();
			m_ScrollAnswer.position = 0;
		}

		m_PanelAnswer.graphics.clear();
		for (i = 1; i < m_Answer.length; i++) {
			a = m_Answer[i];
			m_PanelAnswer.graphics.beginBitmapFill(CtrlFrame.ImgDots, null, true, false);
			m_PanelAnswer.graphics.drawRect( 0, a.m_Text.y-2, m_AnswerWinWidth, 1);
			m_PanelAnswer.graphics.endFill();
		}		

		m_MaskAnswer.x = contentX - 10;
		m_MaskAnswer.y = contentY + sy;
		m_PanelAnswer.x = m_MaskAnswer.x;
		m_PanelAnswer.y = m_MaskAnswer.y - m_ScrollAnswer.position;
		m_MaskAnswer.graphics.clear();
		m_MaskAnswer.graphics.beginFill(0xffffff);
		m_MaskAnswer.graphics.drawRect(0, 0, m_AnswerWinWidth, m_AnswerWinHeight);
		m_MaskAnswer.graphics.endFill();

		sy += m_AnswerWinHeight;

		m_SizeY = sy + (height - contentHeight);

		height = m_SizeY;
	}

	protected function ScrollTextChange(e:Event):void
	{
		UpdatePos();
	}

	public override function onMouseWheel(e:MouseEvent):void
	{
		super.onMouseWheel(e);
		
		if (m_ScrollText.visible && mouseX > m_MaskText.x && mouseX < m_ScrollText.x + m_ScrollText.width && mouseY > m_MaskText.y && mouseY < m_MaskText.y + m_MaskText.height) {
			if (e.delta < 0) {
				m_ScrollText.position += m_ScrollText.line;
				UpdatePos();
			} else if (e.delta > 0) {
				m_ScrollText.position -= m_ScrollText.line;
				UpdatePos();
			}
		} else if (m_ScrollAnswer.visible && mouseX > m_MaskAnswer.x && mouseX < m_ScrollText.x + m_ScrollText.width && mouseY > m_MaskAnswer.y && mouseY < m_MaskAnswer.y + m_MaskAnswer.height) {
			if (e.delta < 0) {
				m_ScrollAnswer.position += m_ScrollAnswer.line;
				UpdatePos();
			} else if (e.delta > 0) {
				m_ScrollAnswer.position -= m_ScrollAnswer.line;
				UpdatePos();
			}
		}
	}

	private function aOver(e:MouseEvent):void
	{
		var l:TextField=e.target as TextField;
		l.background=true;
//trace(l.height);
	}

	private function aOut(e:MouseEvent):void
	{
		var l:TextField=e.target as TextField;
		l.background=false;
	}
	
	private function aClick(e:MouseEvent):void
	{
		var i:int, cnt:int, ch:int;
		var l:TextField;
		var a:AnswerUnit = null;
		
		if (FormMessageBox.Self.visible) return;
		
		m_ScrollText.position = 0;
		m_ScrollAnswer.position = 0;
		
		m_RndVal = getTimer();

		var qe:QEEngine = QEManager.FindById(m_QuestId);
		if (qe == null) { Hide(); return; }

		qe.m_StateSelectionFail = false;

		for(i=0;i<m_Answer.length;i++) {
			a = m_Answer[i];
			if(a.m_Text==e.target) break;
		}
		if (i >= m_Answer.length) return;

		if (a.m_QuestId != m_QuestId) { return; }
		if (a.m_QuestPage != m_QuestPage) { return; }
		if (a.m_QuestCur != qe.NumShow()) { return; }

		var src:String = a.m_QA.m_Page;
		var len:int = src.length;
		var off:int = 0;
		
		var page:String = null;
		var wl:Vector.<String> = null;
		
		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch == 32 || ch == 9) off++; else break; }
			if (off >= len) break;
			
			cnt=0;
			while (off + cnt < len) {
				ch = src.charCodeAt(off + cnt);
				if (ch == 32 || ch == 9) break;
				cnt++;
			}
			if (cnt < 0) continue;

			if(page==null) {
				page = src.substr(off, cnt);
			} else {
				if (wl == null) wl = new Vector.<String>();
				wl.push(src.substr(off, cnt));
			}
			off += cnt;
		}
		
		if (page == null) return;
		if (BaseStr.EqNCEng(page, "close")) Hide();
		else if (BaseStr.EqNCEng(page, "begin")) {
			m_QuestPage = qe.DialogBegin();
			PreparePage();
		}
		else if (BaseStr.EqNCEng(page, "Accept")) {
			QEManager.QuestAccept(m_QuestId);
			Hide();
		}
		else if (BaseStr.EqNCEng(page, "Break")) {
			FormMessageBox.Run(Common.TxtQuest.BreakQuestQuery, null, null, BreakQuest);
		}
		else if (BaseStr.EqNCEng(page, "BreakSilent")) {
			BreakQuest();
		}
		else if (BaseStr.EqNCEng(page, "Next")) {
			Hide();

			page = null;
			if (wl != null && wl.length > 0) {
				page = wl[Math.floor(Math.random() * wl.length)];
			}

			QEManager.QuestReward(m_QuestId, -1, page);
		}
		else if(BaseStr.EqNCEng(page, "Skip")) {
			Hide();

			page = null;
			if (wl != null && wl.length > 0) {
				page = wl[Math.floor(Math.random() * wl.length)];
			}

			QEManager.QuestNext(m_QuestId, -1, page);
		}
		else if (BaseStr.EqNCEng(page, "Finish")) {
			Hide();
			QEManager.QuestReward(m_QuestId, -1, null, true);
		}
		else if (BaseStr.EqNCEng(page, "Extern")) {
			Hide();

			page = null;
			if (wl != null && wl.length > 0) {
				page = wl[Math.floor(Math.random() * wl.length)];
			}

			QEManager.QuestNext(m_QuestId, -1, page);
		}
//		else if (BaseStr.EqNCEng(page, "Cancel")) {
//			Hide();
//			QEManager.QuestNext(m_QuestId);
//		}
		else {
			QEManager.GlobalVarSave();
			QEManager.GlobalVarToQuest(qe);
			m_QuestPage = qe.DialogGoTo(page);
			QEManager.GlobalVarFromQuest(qe);
			QEManager.GloablVarSend();
			PreparePage();
		}

		//if(m_AnswerGoTo[i]=="Close" || m_AnswerGoTo[i]=="close") { Hide(); return; } 
		//GoTo(m_AnswerGoTo[i]);
	}
	
	public function BreakQuest():void
	{
		Hide();
		QEManager.QuestBreak(m_QuestId);
	}
	
	public override function CanClose():Boolean
	{
		if (!EM.m_Debug) return true;

		EM.m_FormMenu.Clear();

		EM.m_FormMenu.Add("Break", MenuBreak);
		EM.m_FormMenu.Add("GoTo", MenuGoTo);
		EM.m_FormMenu.Add();
		EM.m_FormMenu.Add("Close", MenuClose);

		var cx:int = x + CloseBut.x;
		var cy:int = y + CloseBut.y;

		//EM.m_FormMenu.SetCaptureMouseMove(true);
		EM.m_FormMenu.Show(cx, cy, cx + 1, cy + CloseBut.height);

		return false;
	}
	
	public function MenuBreak(...args):void
	{
		BreakQuest();
	}
	
	public function MenuClose(...args):void
	{
		Hide();
	}
	
	public function MenuGoTo(...args):void
	{
		var i:int;

		var qe:QEEngine = QEManager.FindById(m_QuestId);
		if (qe == null) { Hide(); return; }

		FI.Init(300, 200, 1);
		FI.caption = "Select quest";
		FI.AddLabel("Quest:");
		FI.AddComboBox();
		for (i = 0; i < qe.m_QuestList.length; i++) {
			FI.AddItem(qe.m_QuestList[i].m_Name, qe.m_QuestList[i].m_Name, qe.m_Num == i);
		}
		FI.Run(MenuGoToProcess, "JUMP", StdMap.Txt.ButCancel);
	}
	
	public function MenuGoToProcess():void
	{
		var qe:QEEngine = QEManager.FindById(m_QuestId);
		if (qe == null) { Hide(); return; }

		var qn:String = FI.GetStr(0);
		
		Hide();
		QEManager.QuestNext(m_QuestId, -1, qn);
	}
}

}

{
import flash.text.*;
import QE.*;

class AnswerUnit {
	public var m_Text:TextField = null;
	public var m_TextVal:String = "";

	public var m_QA:QEAnswer = null;
	public var m_QuestId:uint = 0;
	public var m_QuestCur:int = -1;
	public var m_QuestPage:int = -1;

	public function AnswerUnit():void
	{
	}
}
}
