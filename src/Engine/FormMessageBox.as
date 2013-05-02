// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine 
{
import Base.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

public class FormMessageBox extends FormStd
{
	[Embed(source = '/assets/stdwin/mb_err.png')] public var bmErr:Class;
	[Embed(source = '/assets/stdwin/mb_msg.png')] public var bmMsg:Class;
	[Embed(source = '/assets/stdwin/mb_qut.png')] public var bmQut:Class;

	public static var Self:FormMessageBox = null;

	public static const TypeMsg:int = 1;
	public static const TypeQuery:int = 2;
	public static const TypeErr:int = 3;

	public var m_Text:String = "";
	public var m_Fun:Function = null;
	public var m_FunCancel:Function = null;

//	public var m_Intercept:Boolean = true;
	
	public var m_LabelText:TextField = null;
	public var m_ButOk:CtrlBut = null;
	public var m_ButCancel:CtrlBut = null;
	
	public var m_IconErr:Bitmap = null;
	public var m_IconMsg:Bitmap = null;
	public var m_IconQut:Bitmap = null;

	public function FormMessageBox()
	{
		super(false, true);

		scale = StdMap.Main.m_Scale;
		width = 400;
		height = 300;

		m_LabelText = new TextField();

		m_IconErr = new bmErr() as Bitmap;
		addChild(m_IconErr);
		m_IconMsg = new bmMsg() as Bitmap;
		addChild(m_IconMsg);
		m_IconQut = new bmQut() as Bitmap;
		addChild(m_IconQut);

		m_LabelText.x=0;
		m_LabelText.y=0;
		m_LabelText.width=1;
		m_LabelText.height=1;
		m_LabelText.type=TextFieldType.DYNAMIC;
		m_LabelText.selectable=false;
		m_LabelText.border=false;
		m_LabelText.background = false;
		m_LabelText.multiline = true;
		m_LabelText.wordWrap = true;
		m_LabelText.autoSize=TextFieldAutoSize.LEFT;
		m_LabelText.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelText.gridFitType=GridFitType.PIXEL;
		m_LabelText.defaultTextFormat = new TextFormat("Calibri", 14, 0x000000);
		m_LabelText.embedFonts = true;
		addChild(m_LabelText);

		m_ButOk = new CtrlBut();
		m_ButOk.addEventListener(MouseEvent.CLICK, clickOk);
		addChild(m_ButOk);

		m_ButCancel = new CtrlBut();
		m_ButCancel.addEventListener(MouseEvent.CLICK, clickCancel);
		addChild(m_ButCancel);
		
		addEventListener("close", clickCancel);
	}

/*	protected function onMouseDownStage(e:MouseEvent):void
	{
		//if (!m_Intercept) Hide();
		//else e.stopImmediatePropagation(); 

		var o:DisplayObject = null;
		if (e.target is DisplayObject) {
			o = e.target as DisplayObject;
			while (o != null) {
				if (o == this) break;
				o = o.parent;
			}
		}

		if (m_Intercept) {
			if (o == null) e.stopImmediatePropagation();
		} else {
			if (o == null) Hide();
		}
	}

	protected function onMouseMoveStage(e:MouseEvent):void
	{
		if (m_Intercept) {
			if (e.target is DisplayObject) {
				var o:DisplayObject = e.target as DisplayObject;
				while (o != null) {
					if (o == this) break;
					o = o.parent;
				}
				if(o==null) e.stopImmediatePropagation();
			}
		}
		
//		if (Frame.hitTestPoint(e.stageX, e.stageY)) {
//			EmpireMap.Self.m_Info.Hide();
//		}
	}*/
	
	override protected function onKeyDownModal(e:KeyboardEvent):void
	{
		super.onKeyDownModal(e);

		if ((e.keyCode == 27 || e.keyCode == 192)) { // ESC `
			Hide();
		} else if (e.keyCode == 13) {
			if (m_Fun != null) clickOk(null);
			else if (m_FunCancel != null) clickCancel(null);
			else Hide();
		}
	}

	override public function Hide():void
	{
		if (visible) {
			if (!modal) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, false);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, true);
			}
		}
		super.Hide();
	}

	override public function Show():void
	{
		m_IconErr.x = 30;
		m_IconErr.y = 50;
		m_IconMsg.x = 30;
		m_IconMsg.y = 50;
		m_IconQut.x = 30;
		m_IconQut.y = 50;

		m_LabelText.htmlText = BaseStr.FormatTag(m_Text, true, true);
		
		var len:int = BaseStr.FormatTag(m_Text, false).length;
		if (len < 400) m_LabelText.width = 250;
		else if (len < 2000) m_LabelText.width = 350;
		else m_LabelText.width = 450;
		
		m_LabelText.width;
		m_LabelText.height;
		
		width = m_LabelText.width + 90 + 40;
		height = m_LabelText.height + 80 + 50;

		m_LabelText.width = width - 90 - 40;
		m_LabelText.width;
		m_LabelText.height;
		
		m_LabelText.x = 90;// (SizeX >> 1) - (m_LabelText.width >> 1);
		m_LabelText.y = ((height - 50) >> 1) - (m_LabelText.height >> 1);
		
		m_ButCancel.x = width - 25 - m_ButCancel.width;
		m_ButCancel.y = height - 35 - m_ButCancel.height;

		m_ButOk.x = m_ButCancel.x - 5 - m_ButOk.width;
		m_ButOk.y = height - 35 - m_ButOk.height;

		super.Show();
		
		if (!modal) {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, false);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownModal, true);
		}
	}

	public static function Run(str:String, cancelstr:String = null, okstr:String = null, fun:Function = null, funcancel:Function = null, modal:Boolean = true, type:int = TypeMsg):void
	{
		Self.Hide();
		Self.m_Text = str;
		Self.modal = modal;
		Self.m_Fun=fun;
		Self.m_FunCancel = funcancel;
		
		if (cancelstr == null && fun == null) Self.m_ButCancel.caption = StdMap.Txt.ButClose;
		else if (cancelstr == null && fun != null) Self.m_ButCancel.caption = StdMap.Txt.ButNo;
		else if (cancelstr == null) Self.m_ButCancel.caption = "";
		else Self.m_ButCancel.caption = cancelstr.toUpperCase();

		if (okstr == null && fun != null) Self.m_ButOk.caption = StdMap.Txt.ButYes;
		else if (okstr == null) Self.m_ButOk.caption = "";
		else Self.m_ButOk.caption = okstr.toUpperCase();
		Self.m_ButOk.visible = fun != null;//(okstr != null) && (okstr.length > 0);
		
		if (Self.m_ButOk.visible) Self.caption = StdMap.Txt.FormMessageBoxQuery;
		else Self.caption = StdMap.Txt.FormMessageBoxMsg;
		Self.m_IconErr.visible = false;
		Self.m_IconMsg.visible = !Self.m_ButOk.visible;
		Self.m_IconQut.visible = Self.m_ButOk.visible;
		if (Self.m_ButOk.visible) Self.headerType = FormStd.HeaderBlue;
		else Self.headerType = FormStd.HeaderGrey;
		Self.Show();
	}

	public static function RunErr(str:String, cancelstr:String = null, funcancel:Function = null, modal:Boolean = true):void
	{
		Self.Hide();
		Self.caption = StdMap.Txt.FormMessageBoxErr;
		Self.m_Text = str;
		Self.modal = modal;
		Self.m_Fun = null;
		Self.m_FunCancel = funcancel;
		if (cancelstr == null) Self.m_ButCancel.caption = StdMap.Txt.ButClose;
		else Self.m_ButCancel.caption = cancelstr;
		Self.m_ButOk.caption = "";
		Self.m_ButOk.visible = false;
		Self.m_IconErr.visible = true;
		Self.m_IconMsg.visible = false;
		Self.m_IconQut.visible = false;
		Self.headerType = FormStd.HeaderRed;
		Self.Show();
	}

	private function clickCancel(event:Event):void
	{
		Hide();
		if(m_FunCancel!=null) m_FunCancel(); 
	}

	private function clickOk(event:MouseEvent):void
	{
		Hide();
		m_Fun();
	}
}

}
