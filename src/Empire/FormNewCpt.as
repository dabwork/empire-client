package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;

public class FormNewCpt extends FormStd
{
	private var EM:EmpireMap;

	public var m_ButOk:CtrlBut = null;
	public var m_ButCancel:CtrlBut = null;
	public var m_NameInput:CtrlInput = null;
	public var m_RaceCombo:CtrlComboBox = null;

	public var m_ReplaceId:uint = 0;

	public var m_Face:int=0;

	public var m_FaceBM:Bitmap = null;

	public function FormNewCpt(map:EmpireMap)
	{
		var i:int;

		super(true, false);
		
		EM = map;

		width = 380;
		height = 300;
		scale = StdMap.Main.m_Scale;
		contentSpaceLeft = 140;
		contentSpaceTop = 20;
		
		m_ButOk = new CtrlBut();
		m_ButOk.addEventListener(MouseEvent.CLICK, clickOk);
		addChild(m_ButOk);

		m_ButCancel = new CtrlBut();
		m_ButCancel.addEventListener(MouseEvent.CLICK, clickCancel);
		addChild(m_ButCancel);
		
		var d:DisplayObject;
		
		d = new bmFaceFrameBg();
		d.x = contentX - d.width - 20;
		d.y = contentY - 10;
		addChild(d);

		m_FaceBM=new Bitmap();
		//m_Face.bitmapData = new Face(93, 104);
		m_FaceBM.x = d.x + 10;
		m_FaceBM.y = d.y + 7;
		addChild(m_FaceBM);

		var d2:DisplayObject = new bmFaceFrameTop();
		d2.x = d.x;
		d2.y = d.y;
		addChild(d2);
		
		i = ItemLabel(Common.Txt.FormNewCptName+":"); //ItemAlign(i, -1, 0);
		LocNextRow();
		i = ItemInput("", 15, true, Server.Self.m_Lang, false); m_NameInput = ItemObj(i) as CtrlInput;
		m_NameInput.addEventListener(Event.CHANGE, Update);
		LocNextRow();

		i = ItemLabel(Common.Txt.FormNewCptRace+":");
		LocNextRow();
		i = ItemComboBox(); m_RaceCombo = ItemObj(i) as CtrlComboBox;
		m_RaceCombo.ItemAdd(Common.RaceName[Common.RaceGrantar], Common.RaceGrantar);
		m_RaceCombo.ItemAdd(Common.RaceName[Common.RacePeleng], Common.RacePeleng);
		m_RaceCombo.ItemAdd(Common.RaceName[Common.RacePeople], Common.RacePeople);
		m_RaceCombo.ItemAdd(Common.RaceName[Common.RaceTechnol], Common.RaceTechnol);
		m_RaceCombo.ItemAdd(Common.RaceName[Common.RaceGaal], Common.RaceGaal);
		m_RaceCombo.addEventListener(Event.CHANGE, Update);
		LocNextRow();
	}
	
	override public function Show():void
	{
		if (visible) Hide();

		super.Show();

		if (m_ReplaceId) caption = Common.Txt.FormNewCptReplaceCaption;
		else caption = Common.Txt.FormNewCptCaption;

		if (m_ReplaceId) m_ButOk.caption = Common.Txt.FormNewCptButReplace;
		else m_ButOk.caption = Common.Txt.FormNewCptButOk;
		m_ButCancel.caption = Common.Txt.FormNewCptButCancel;

		var tx:int = contentX + contentWidth;
		if(m_ButCancel.visible) {
			tx -= m_ButCancel.width;
			m_ButCancel.x = tx;
			m_ButCancel.y = contentY + contentHeight - m_ButCancel.height;
		}

		if (m_ButOk.visible) {
			tx -= m_ButOk.width;
			m_ButOk.x = tx;
			m_ButOk.y = contentY + contentHeight - m_ButCancel.height;
		}
		
		m_NameInput.text = "";
		m_RaceCombo.current = Math.floor(Math.random() * 5);
		m_Face = Math.floor(Math.random() * 1000);
		
		Update();
	}
	
	public override function onMouseDown(e:MouseEvent):void
	{
		super.onMouseDown(e);
		if (m_FaceBM.hitTestPoint(stage.mouseX, stage.mouseY)) {
			m_Face++;
			Update();
		}
	}
	
	public function Update(e:Event = null):void
	{
		var r:int = m_RaceCombo.ItemData(m_RaceCombo.current) as int;
		m_FaceBM.bitmapData = FormDialog.BitmapFace(r, m_Face);
		
		m_ButOk.disable = true;
		
		var n:String = BaseStr.TrimRepeat(BaseStr.Trim(m_NameInput.text));

		var ch:int;
		if (n.length < 2 || n.length > 16) {
			//m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrLen + "[/crt]", true, true);
			return;
		}

		var i:int;
		var lang:int = 0;

		for (i = 0; i < n.length; i++) {
			ch = n.charCodeAt(i);
			if (ch == 32) { }
			else if (ch >= 48 && ch <= 57) { }
			else if (lang == 0) {
				if (FormEnter.CharInAlphabet(ch, Server.LANG_ENG)) lang = Server.LANG_ENG;
				else if (FormEnter.CharInAlphabet(ch, Server.LANG_RUS)) lang = Server.LANG_RUS;
				else { lang = 0; break; }
			} else {
				if (!FormEnter.CharInAlphabet(ch, lang)) {
					//m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrChar + "[/crt]", true, true);
					return;
				}
			}
		}
		
		if (FormChat.ReplaceBadWord(n, Common.TxtChat.LikeLetter, Common.TxtChat.GoodWord, Common.TxtChat.BadWord) != n) {
			//m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrBadWord + "[/crt]", true, true);
			return;
		}
		m_ButOk.disable = false;
	}

	public function clickCancel(event:Event):void
	{
		Hide();
	}

	public function clickOk(event:Event):void
	{
		var n:String = BaseStr.TrimRepeat(BaseStr.Trim(m_NameInput.text));
		var r:int = m_RaceCombo.ItemData(m_RaceCombo.current) as int;
		var f:int = m_Face % Common.RaceFaceCnt[r];

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"name\"\r\n\r\n";
        d+=n+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"race\"\r\n\r\n";
        d+=r.toString()+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"face\"\r\n\r\n";
        d += f.toString() + "\r\n"
		
		if (m_ReplaceId) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"cptid\"\r\n\r\n";
			d += m_ReplaceId.toString() + "\r\n"
		}

        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emcptnew","",d,boundary,RecvCptNew);

        Hide();
	}
	
	public function RecvCptNew(event:Event):void
	{
		EM.m_FormCptBar.QueryCptDscSoft();
	}
}

}
