// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import fl.controls.dataGridClasses.*;
import fl.events.*;
import fl.data.DataProvider;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormHist extends Sprite
{
	private var EM:EmpireMap = null;
	
	static public const TradeStorageMul:int = 100;

	static public const SizeX:int=500;
	static public const SizeY:int=540;

	public var m_ModeDesc:int=-1;
	public var m_ModeJournal:int=-1;
	public var m_ModeImport:int=-1;
	public var m_ModeExport:int=-1;
	public var m_ModeFind:int=-1;

	public var m_ModeCur:int=0;
	public var m_ModeMouse:int=-1;

	public var m_Modes:Array=new Array();

	public var m_Frame:Sprite=new GrFrame();
	public var m_Title:TextField=new TextField();
	//public var m_Text:TextArea=new TextArea();  
	public var m_Text:TextField=new TextField();
	public var m_TextSB:UIScrollBar = new UIScrollBar();
	
	public var m_ButClose:Button=new Button();
	public var m_ButEnter:Button=new Button();
	public var m_ButAction:Button=new Button();
	
	public var m_ButLeft:SimpleButton=new MMButLeft();
	public var m_ButLeftLeft:SimpleButton=new MMButLeftLeft();
	public var m_ButRight:SimpleButton=new MMButRight();
	public var m_ButRightRight:SimpleButton=new MMButRightRight();
	public var m_LabelPage:TextField=new TextField();
	public var m_LabelPageCaption:TextField=new TextField();
	public var m_ButMenu:SimpleButton=new MMButOptions();
	
	public var m_TradeGrid:DataGrid = null;

	public var m_FindQuery:TextInput = new TextInput();
	public var m_FindOk:Button = new Button();
	public var m_FindLabel:TextField = new TextField();
	public var m_FindGrid:DataGrid = null;

//	public var m_JournalCheck:CheckBox=new CheckBox();

	public var m_CotlId:uint=0;

	public var m_List:Array = new Array();
	public var m_Page:int=0;
	public var m_GoToPage:int=0;
	
	public var m_ChangeImageQuality:Boolean=false;
	
	public var m_TradeList:Array=new Array();

	public var m_EditActionTimer:Timer = new Timer(1000, 1);

	public var m_FindCotlId:uint = 0;
	
	public var m_ErrOpenInput:Boolean = false;
	
	public function get FI():FormInputEx { return StdMap.Main.m_FormInputEx; }

	public function FormHist(map:EmpireMap)
	{
		EM = map;
		
		m_EditActionTimer.addEventListener("timer",actionEditChangeTakt);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		UserList.Self.addEventListener("RecvUser", RecvUser);

		m_Frame.width=SizeX;
		m_Frame.height=SizeY;
		addChild(m_Frame);

		m_Title.x=10;
		m_Title.y=5;
		m_Title.width=1;
		m_Title.height=1;
		m_Title.type=TextFieldType.DYNAMIC;
		m_Title.selectable=false;
		m_Title.border=false;
		m_Title.background=false;
		m_Title.multiline=false;
		m_Title.autoSize=TextFieldAutoSize.LEFT;
		m_Title.antiAliasType=AntiAliasType.ADVANCED;
		m_Title.gridFitType=GridFitType.PIXEL;
		m_Title.defaultTextFormat=new TextFormat("Calibri",18,0xffff00);
		m_Title.embedFonts=true;
		addChild(m_Title);

		var tf:TextFormat=new TextFormat("Calibri",14,0xffffff,null,null,null,null,null,TextFormatAlign.JUSTIFY,null,null,20);
		tf.rightMargin=5;
		tf.leftMargin=10;
		//tf.leftMargin=10;
		//tf.indent=20;
		
		Common.UIChatBar(m_TextSB);

		m_Text.x=5;
		m_Text.y=33;
		m_Text.width=SizeX-5-10-m_TextSB.width;
		m_Text.height=SizeY-m_Text.y-50;
		m_Text.wordWrap=true;
		//m_Text.editable=false;
		m_Text.condenseWhite=true;
		m_Text.alwaysShowSelection=true;
		//m_Text.setStyle("upSkin", TextArea_Chat);
		//m_Text.setStyle("focusRectSkin", focusRectSkinNone);
		//m_Text.setStyle("textFormat", tf);
		//m_Text.setStyle("embedFonts", true);
		//m_Text.textField.antiAliasType=AntiAliasType.ADVANCED;
		//m_Text.textField.gridFitType=GridFitType.PIXEL;
		//Common.UIChatBar(m_Text);
			m_Text.type=TextFieldType.DYNAMIC;
			m_Text.selectable=false;
			m_Text.border=false;
			m_Text.background=false;
			m_Text.multiline=true;
			m_Text.autoSize=TextFieldAutoSize.NONE;
			m_Text.antiAliasType=AntiAliasType.ADVANCED;
			m_Text.gridFitType=GridFitType.PIXEL;
			m_Text.defaultTextFormat=tf;
			m_Text.embedFonts=true;

			m_TextSB.scrollTarget=m_Text;
			addChild(m_TextSB);
			
			m_Text.addEventListener(Event.FRAME_CONSTRUCTED,frConst);
		
		addChild(m_Text);
		
//		EM.m_FormPact.CheckStyle(m_JournalCheck);
//		m_JournalCheck.setStyle("textFormat",new TextFormat("Calibri",14,0xffffff));
//		m_JournalCheck.addEventListener(Event.CHANGE,changeJournal);
//		addChild(m_JournalCheck);

		addChild(m_ButLeft);
		addChild(m_ButLeftLeft);
		addChild(m_ButRight);
		addChild(m_ButRightRight);
		addChild(m_LabelPage);
		addChild(m_LabelPageCaption);
		addChild(m_ButMenu);

		m_ButLeft.addEventListener(MouseEvent.CLICK,clickLeft);
		m_ButLeftLeft.addEventListener(MouseEvent.CLICK,clickLeftLeft);
		m_ButRight.addEventListener(MouseEvent.CLICK,clickRight);
		m_ButRightRight.addEventListener(MouseEvent.CLICK,clickRightRight);

		m_LabelPage.x=10;
		m_LabelPage.y=5;
		m_LabelPage.width=1;
		m_LabelPage.height=1;
		m_LabelPage.type=TextFieldType.DYNAMIC;
		m_LabelPage.selectable=false;
		m_LabelPage.border=false;
		m_LabelPage.background=false;
		m_LabelPage.multiline=false;
		m_LabelPage.autoSize=TextFieldAutoSize.LEFT;
		m_LabelPage.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelPage.gridFitType=GridFitType.PIXEL;
		m_LabelPage.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_LabelPage.embedFonts=true;

		m_LabelPageCaption.x=10;
		m_LabelPageCaption.y=5;
		m_LabelPageCaption.width=1;
		m_LabelPageCaption.height=1;
		m_LabelPageCaption.type=TextFieldType.DYNAMIC;
		m_LabelPageCaption.selectable=false;
		m_LabelPageCaption.border=false;
		m_LabelPageCaption.background=false;
		m_LabelPageCaption.multiline=false;
		m_LabelPageCaption.autoSize=TextFieldAutoSize.LEFT;
		m_LabelPageCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelPageCaption.gridFitType=GridFitType.PIXEL;
		m_LabelPageCaption.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_LabelPageCaption.embedFonts=true;

		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width=100;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x=SizeX-15-m_ButClose.width;
		m_ButClose.y=SizeY-15-m_ButClose.height;
		addChild(m_ButClose);

		m_ButEnter.label = Common.Txt.FormHistEnter;
		m_ButEnter.width=100;
		Common.UIStdBut(m_ButEnter);
		m_ButEnter.addEventListener(MouseEvent.CLICK, clickEnter);
		m_ButEnter.x=m_ButClose.x-10-m_ButEnter.width;
		m_ButEnter.y=SizeY-15-m_ButEnter.height;
		addChild(m_ButEnter);

		m_ButAction.width=100;
		Common.UIStdBut(m_ButAction);
		m_ButAction.addEventListener(MouseEvent.CLICK, clickAction);
		m_ButAction.x=10;
		m_ButAction.y=m_ButClose.y;
		addChild(m_ButAction);
		
		m_TradeGrid=new DataGrid(); 
		addChild(m_TradeGrid);
		
		m_TradeGrid.addEventListener(Event.CHANGE,TradeActionUpdate);
		m_TradeGrid.doubleClickEnabled=true; 
		m_TradeGrid.addEventListener(MouseEvent.DOUBLE_CLICK,clickAction);
		
		m_TradeGrid.setStyle("skin",ListOnlineUser_skin);
		m_TradeGrid.setStyle("cellRenderer",TradeRenderer);
		
		m_TradeGrid.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
		m_TradeGrid.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
		m_TradeGrid.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
		m_TradeGrid.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);
		
		m_TradeGrid.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
		m_TradeGrid.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
		m_TradeGrid.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
		m_TradeGrid.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
		m_TradeGrid.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);
		
		m_TradeGrid.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
		m_TradeGrid.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
		m_TradeGrid.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
		m_TradeGrid.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);
		
		m_TradeGrid.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
		m_TradeGrid.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
		m_TradeGrid.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
		m_TradeGrid.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);
		
		m_TradeGrid.setStyle("headerTextFormat",new TextFormat("Calibri",14,0xffffff));
		m_TradeGrid.setStyle("headerУmbedFonts", true);
		m_TradeGrid.setStyle("headerTextPadding",5);

		m_TradeGrid.x=10;
		m_TradeGrid.y=38;
		m_TradeGrid.width=SizeX-10-10;
		m_TradeGrid.height=SizeY-m_TradeGrid.y-50;

		m_TradeGrid.rowHeight=30;

		var col:DataGridColumn;
		col = new DataGridColumn("Name"); col.headerText = Common.Txt.FormHistGoodsType; m_TradeGrid.addColumn(col);
		col=new DataGridColumn("SM"); col.headerText=Common.Txt.FormHistGoodsStorage; col.width=120; m_TradeGrid.addColumn(col);
		col=new DataGridColumn("Cnt"); col.headerText=Common.Txt.FormHistGoodsCntImport; col.width=100; m_TradeGrid.addColumn(col);
		col=new DataGridColumn("StepTxt"); col.headerText=Common.Txt.FormHistGoodsStep; col.width=50; m_TradeGrid.addColumn(col);
		col=new DataGridColumn("Price"); col.headerText=Common.Txt.FormHistGoodsPrice; col.width=70; m_TradeGrid.addColumn(col);
		m_TradeGrid.minColumnWidth = 30;

		Common.UIStdInput(m_FindQuery);
		m_FindQuery.x = 40;
		m_FindQuery.y = 50;
		m_FindQuery.width = SizeX - 40 - 40 - 100;
		addChild(m_FindQuery);

		m_FindOk.width=80;
		Common.UIStdBut(m_FindOk);
		m_FindOk.addEventListener(MouseEvent.CLICK, clickFind);
		m_FindOk.x=SizeX-40-m_FindOk.width;
		m_FindOk.y = m_FindQuery.y;
		m_FindOk.label = Common.Txt.ButFind;
		addChild(m_FindOk);

		Common.UIStdTextField(m_FindLabel);
		m_FindLabel.multiline = true;
		m_FindLabel.autoSize = TextFieldAutoSize.NONE;
		m_FindLabel.x = 40;
		m_FindLabel.y = 90;
		m_FindLabel.width = SizeX - 40 - 40;
		m_FindLabel.height = SizeY - m_FindLabel.y - 50;
		m_FindLabel.htmlText = Common.Txt.FindHelp;
		addChild(m_FindLabel);

		m_FindGrid=new DataGrid(); 
		addChild(m_FindGrid);
		
		m_FindGrid.addEventListener(ListEvent.ITEM_ROLL_OVER, onFindGridItemOver);
		m_FindGrid.addEventListener(ListEvent.ITEM_ROLL_OUT, onFindGridItemOut);
		
		m_FindGrid.setStyle("skin",ListOnlineUser_skin);
		m_FindGrid.setStyle("cellRenderer",TradeRenderer);
		
		m_FindGrid.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
		m_FindGrid.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
		m_FindGrid.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
		m_FindGrid.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);
		
		m_FindGrid.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
		m_FindGrid.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
		m_FindGrid.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
		m_FindGrid.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
		m_FindGrid.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);
		
		m_FindGrid.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
		m_FindGrid.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
		m_FindGrid.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
		m_FindGrid.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);
		
		m_FindGrid.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
		m_FindGrid.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
		m_FindGrid.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
		m_FindGrid.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);
		
		m_FindGrid.setStyle("headerTextFormat",new TextFormat("Calibri",13,0xffffff));
		m_FindGrid.setStyle("headerУmbedFonts", true);
		m_FindGrid.setStyle("headerTextPadding",5);

		m_FindGrid.x=10;
		m_FindGrid.y=m_FindLabel.y;
		m_FindGrid.width=SizeX-10-10;
		m_FindGrid.height=SizeY-m_FindGrid.y-50;

		m_FindGrid.rowHeight=30;

		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}

	protected function onMouseWheel(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		EmpireMap.Self.m_Info.Hide();
	}
	
	public function ModeClear():void
	{
		var i:int;
		
		for(i=0;i<m_Modes.length;i++) {
			var p:Object=m_Modes[i];
			if(p.BG!=null) {
				removeChild(p.BG);
				p.BG=null;
			}
			if(p.Label!=null) {
				removeChild(p.Label);
				p.Label=null;
			}
		}
		m_Modes.length=0;
	}

	public function ModeAdd(txt:String):int
	{
		var b:FormWinPage;
		var l:TextField;

		var p:Object=new Object();
		m_Modes.push(p);

		b=new FormWinPage();
		addChild(b);
		b.addEventListener(MouseEvent.MOUSE_MOVE, ModeMouseMove);
		b.addEventListener(MouseEvent.MOUSE_OUT, ModeMouseMove);
		b.addEventListener(MouseEvent.CLICK, ModeMouseClick);
		p.BG=b;

		l=new TextField();
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background=false;
		l.multiline=false;
		l.autoSize=TextFieldAutoSize.LEFT;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.PIXEL;
		l.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		l.embedFonts=true;
		l.mouseEnabled=false;
		addChild(l);
		p.Label=l;

		l.text="";
		l.width=1;
		l.height=1;
		l.htmlText=txt;

		b.width=5+Math.max(30,l.width)+5;

		return m_Modes.length-1;
	}
	
	public function ModeUpdate():void
	{
		var i:int;
		var sx:int=150;
		var sy:int=-25;
		
		for(i=0;i<m_Modes.length;i++) {
			var p:Object=m_Modes[i];

			var b:FormWinPage=p.BG;
			var l:TextField=p.Label;

			if(i==m_ModeMouse && i==m_ModeCur) b.gotoAndStop(4);
			else if(i==m_ModeCur) b.gotoAndStop(2);
			else if(i==m_ModeMouse) b.gotoAndStop(3);
			else b.gotoAndStop(1);

			b.x=sx;
			b.y=sy;

			l.x=sx+5;
			l.y=sy+5;

			sx+=b.width+1;
		}
	}

	public function ModePick():int
	{
		var i:int;
		var p:Object;
		for(i=0;i<m_Modes.length;i++) {
			p=m_Modes[i];
			
			if(p.BG!=undefined && p.BG!=null) {
				if(p.BG.hitTestPoint(stage.mouseX,stage.mouseY)) return i;
			}
		}
		return -1;
	}
	
	public function ModeMouseMove(e:MouseEvent):void
	{
		var i:int=ModePick();
		if(i!=m_ModeMouse) {
			m_ModeMouse=i;
			ModeUpdate();
		}		
	}

	public function ModeMouseClick(e:MouseEvent):void
	{
		//if(EM.m_FormInput.visible) return;
		//if(FormMessageBox.Self.visible) return;
		
		var i:int=ModePick();
		if(i>=0) {
			if(i!=m_ModeCur) {
				ChangeMode(i);

			} else {
//				PageMenu();
			}
		}
	}
	
	public function ChangeMode(m:int):void
	{
		EM.m_FormInput.Hide();
		FormMessageBox.Self.visible=false;

		m_ModeCur=m;

		m_Text.visible=(m_ModeCur==m_ModeDesc) || (m_ModeCur==m_ModeJournal);
		m_TextSB.visible=(m_ModeCur==m_ModeDesc) || (m_ModeCur==m_ModeJournal);
		m_ButLeft.visible=(m_ModeCur==m_ModeDesc) || (m_ModeCur==m_ModeJournal);
		m_ButLeftLeft.visible=(m_ModeCur==m_ModeDesc) || (m_ModeCur==m_ModeJournal);
		m_ButRight.visible=(m_ModeCur==m_ModeDesc) || (m_ModeCur==m_ModeJournal);
		m_ButRightRight.visible=(m_ModeCur==m_ModeDesc) || (m_ModeCur==m_ModeJournal);
		m_LabelPage.visible=(m_ModeCur==m_ModeDesc) || (m_ModeCur==m_ModeJournal);
		m_LabelPageCaption.visible=(m_ModeCur==m_ModeDesc) || (m_ModeCur==m_ModeJournal);
		
		m_TradeGrid.visible=(m_ModeCur==m_ModeImport) || (m_ModeCur==m_ModeExport);

		m_FindQuery.visible = (m_ModeCur == m_ModeFind);
		m_FindOk.visible = (m_ModeCur == m_ModeFind);
		if (m_FindCotlId != 0 && m_FindCotlId == m_CotlId) {
			m_FindLabel.visible = false;
			m_FindGrid.visible = (m_ModeCur == m_ModeFind);
		} else {
			m_FindLabel.visible = (m_ModeCur == m_ModeFind);
			m_FindLabel.htmlText = Common.Txt.FindHelp;
			m_FindGrid.visible = false;
		}

		if(m_ModeCur==m_ModeImport || m_ModeCur==m_ModeExport) {
			if(m_ModeCur==m_ModeImport) m_TradeGrid.getColumnAt(1).headerText=Common.Txt.FormHistGoodsStorage;
			else m_TradeGrid.getColumnAt(1).headerText = Common.Txt.FormHistGoodsMoney;

			if(m_ModeCur==m_ModeImport) m_TradeGrid.getColumnAt(2).headerText=Common.Txt.FormHistGoodsCntImport;
			else m_TradeGrid.getColumnAt(2).headerText=Common.Txt.FormHistGoodsCntExport;

			if(m_ModeCur==m_ModeImport) m_ButAction.label = Common.Txt.FormHistSell;
			else m_ButAction.label = Common.Txt.FormHistBuy;		

			TradeQuery();
			TradeUpdate();
			TradeActionUpdate();
			
		} else if(m_ModeCur==m_ModeDesc || m_ModeCur==m_ModeJournal) {
			m_ButAction.visible=false;
			
			if(m_ModeCur==m_ModeJournal) m_GoToPage=1;
			else m_GoToPage=-1;
			ListQuery();
			UpdateText();

		} else if(m_ModeCur==m_ModeFind) {
			m_ButAction.visible=false;
		}
		
		ModeUpdate();
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		EM.FloatTop(this);

		if(FormMessageBox.Self.visible) return;
		if(m_ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButLeft.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButLeftLeft.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButRight.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButRightRight.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButMenu.hitTestPoint(e.stageX,e.stageY)) { MenuOpen(); return; }
		if(m_Text.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_TextSB.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButAction.visible && m_ButAction.hitTestPoint(e.stageX,e.stageY)) return;
		if(ModePick()>=0) return;
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}
	
	public function Show():void
	{
		var i:int;

		EM.FloatTop(this);

		visible=true;

		x=Math.max(30,Math.ceil(EM.stage.stageWidth/4-SizeX/2));
		y=Math.ceil(EM.stage.stageHeight/2-SizeY/2);
		
		m_List.length=0;
		m_Page=0;
		
		UpdateTitle();
		
		ModeClear();
		m_ModeDesc=ModeAdd(Common.Txt.FormHistModeDesc);
		m_ModeJournal=ModeAdd(Common.Txt.FormHistModeJournal);
		m_ModeImport=ModeAdd(Common.Txt.FormHistModeImport);
		m_ModeExport=ModeAdd(Common.Txt.FormHistModeExport);
		m_ModeFind=ModeAdd(Common.Txt.FormHistModeFind);

		if(m_ModeCur<0 || m_ModeCur>=m_Modes.length) m_ModeCur=m_ModeDesc;

		ChangeMode(m_ModeCur);

//		Update();
	}

	public function Hide():void
	{
		visible=false;
	}

/*	public function changeJournal(e:Event):void
	{
		m_List.length=0;

		if(m_JournalCheck.selected)	m_GoToPage=1;
		else m_GoToPage=-1;

		ListQuery();

		Update();
	}*/

	public function clickClose(...args):void
	{
		if(EM.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		
		Hide();
	}

	public function clickEnter(...args):void
	{
		if(EM.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		
		Hide();

		if (m_CotlId && (EM.IsEdit() || m_CotlId != Server.Self.m_CotlId) && EM.HS.GetCotl(m_CotlId) != null) {
			EM.GoTo(false, m_CotlId);
			//EM.ChangeCotlServerSimple(m_CotlId);
			//if(EM.ChangeCotlServer(m_CotlId)) {
			//	EM.m_Hyperspace.Hide();
			//}
		} else if(m_CotlId && m_CotlId==Server.Self.m_CotlId) {
			EM.HS.Hide();
		}

		//Server.Self.Query("emedcotlspecial","&type=1&id="+cotl.m_Id.toString(),EditCotlMapEditRecv,false);
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<width && mouseY>=0 && mouseY<height) return true;
		if(ModePick()>=0) return true;
		return false;
	}
	
	public function IsMouseInTop():Boolean
	{
		if (!IsMouseIn()) return false;

		var pt:Point = new Point(stage.mouseX, stage.mouseY);
		var ar:Array = stage.getObjectsUnderPoint(pt);

		if (ar.length <= 0) return false;

		var obj:DisplayObject = ar[ar.length - 1];
		if (obj == EM.m_MoveItem) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		else if (obj == EM.m_FormFleetBar.m_MoveLayer) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		while (obj!=null) {
			if (obj == this) return true;
			obj = obj.parent;
		}
		return false;
	}
	
	public function clickLeft(e:Event):void
	{
		if(m_Page<=0) return;
		m_Page--;
		UpdateText();
	}

	public function clickLeftLeft(e:Event):void
	{
		if(m_Page==0) return;
		m_Page=0;
		UpdateText();
	}

	public function clickRight(e:Event):void
	{
		if(m_Page>=m_List.length-1) return;
		m_Page++;
		UpdateText();
	}

	public function clickRightRight(e:Event):void
	{
		if(m_Page==m_List.length-1) return;
		m_Page=m_List.length-1;
		if(m_Page<0) m_Page=0;
		UpdateText();
	}
	
	public function UpdateTitle():void
	{
		m_Title.text = EM.CotlName(m_CotlId,true);
		
/*		var str:String;
		var user:User;
		
		var cotl:Cotl=EM.m_FormGalaxy.GetCotl(m_CotlId);
		if(cotl==null) { Hide(); return; }
		
		//		str=EM.Txt_CotlName(cotl.m_Id);
		//		if(str.length<=0 && cotl.m_Type==Common.CotlTypeUser) {
		//			user=UserList.Self.GetUser(cotl.m_AccountId);
		//			if(user!=null) str=user.m_Name;
		//		}
		//		m_Title.text=str;
		
		user=null;
		if(cotl.m_Type==Common.CotlTypeUser) user=UserList.Self.GetUser(cotl.m_AccountId);
		
		str=EM.Txt_CotlName(cotl.m_Id);
		if(cotl.m_Type==Common.CotlTypeRich) {
			str=Common.Txt.CotlRich+" "+str;
		}
		if(str=='' && cotl.m_Type==Common.CotlTypeUser) {
			str=Common.Txt.CotlUser;
			if(user!=null) str+=" "+user.m_Name;
		}
		if(str=='') str='-';
		m_Title.text=str;*/
	}
	
	public function UpdateText():void
	{
		var str:String;
		var user:User;
		
		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);
		if(cotl==null) { Hide(); return; }
		
//		str=EM.Txt_CotlName(cotl.m_Id);
//		if(str.length<=0 && cotl.m_Type==Common.CotlTypeUser) {
//			user=UserList.Self.GetUser(cotl.m_AccountId);
//			if(user!=null) str=user.m_Name;
//		}
//		m_Title.text=str;

/*		user=null;
		if(cotl.m_Type==Common.CotlTypeUser) user=UserList.Self.GetUser(cotl.m_AccountId);

		str=EM.Txt_CotlName(cotl.m_Id);
		if(cotl.m_Type==Common.CotlTypeRich) {
			str=Common.Txt.CotlRich+" "+str;
		}
		if(str=='' && cotl.m_Type==Common.CotlTypeUser) {
			str=Common.Txt.CotlUser;
			if(user!=null) str+=" "+user.m_Name;
		}
		if(str=='') str='-';
		m_Title.text=str;*/
		
		if(m_List.length>=2) {
			var y:int=SizeY-70;
			
			m_ButRightRight.visible=true;
			m_ButRight.visible=true;
			m_LabelPage.visible=true;
			m_ButLeft.visible=true;
			m_ButLeftLeft.visible=true;
			m_LabelPageCaption.visible=true;

			m_ButRightRight.x=SizeX-10-m_ButRightRight.width;
			m_ButRightRight.y=y;
	
			m_ButRight.x=m_ButRightRight.x-0-m_ButRight.width;
			m_ButRight.y=y;
			
			m_LabelPage.text=(m_Page+1).toString()+"/"+(m_List.length).toString();
			m_LabelPage.x=m_ButRight.x-5-m_LabelPage.width;
			m_LabelPage.y=y+2;
	
			m_ButLeft.x=m_LabelPage.x-5-m_ButLeft.width;
			m_ButLeft.y=y;
			
			m_ButLeftLeft.x=m_ButLeft.x-0-m_ButLeftLeft.width;
			m_ButLeftLeft.y=y;
	
			m_LabelPageCaption.text=Common.Txt.FormHistPages+":";
			m_LabelPageCaption.x=m_ButLeftLeft.x-10-m_LabelPageCaption.width;
			m_LabelPageCaption.y=y+2;
			
			m_Text.height=m_ButRightRight.y-5-m_Text.y;
		} else {
			m_ButRightRight.visible=false;
			m_ButRight.visible=false;
			m_LabelPage.visible=false;
			m_ButLeft.visible=false;
			m_ButLeftLeft.visible=false;
			m_LabelPageCaption.visible=false;
			
			m_Text.height=SizeY-50-m_Text.y;
		}
		m_TextSB.move(m_Text.x + m_Text.width, m_Text.y);
		m_TextSB.setSize(m_TextSB.width, m_Text.height);

		m_ButMenu.x=SizeX-m_ButMenu.width-5;
		m_ButMenu.y=3;

//		m_JournalCheck.x=10;
//		m_JournalCheck.y=m_ButClose.y;
//		m_JournalCheck.label=Common.Txt.FormHistJournal;

		var addtolocal:Number=(new Date()).getTime()-EM.m_ConnectDate.getTime();

		m_ChangeImageQuality=true;
		str="";//"<img src='empire/quest/amnesia_01.jpg' width='171' height='196'>";
		if(m_Page>=0 && m_Page<m_List.length) {
			//str+="<img src='empire/quest/amnesia_01.jpg' width='171' height='196' id='img01'>";
			//str+="<img src='empire/quest/amnesia_01.jpg' width='240' height='274' hspace='0' id='_sys_img0'>";

			var head:Boolean=false;
			if(m_ModeCur==m_ModeJournal) {
				var md:Date=EM.GetServerDate();
				md.setTime(md.getTime() + (m_List[m_Page].Prior * 1000 - EM.GetServerGlobalTime()) + addtolocal);
				
				str+=Common.Hist.Date+": <font color='#ffff00'>"+Common.DateToStr(md,false)+"</font><br>";
				head=true;
			}
			if(m_ModeCur==m_ModeJournal && m_List[m_Page].Author!=0) {
				user=UserList.Self.GetUser(m_List[m_Page].Author);
				if(user!=null) {
					str += Common.Hist.Author + " <font color='#ffff00'>" + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id) + "</font>:<br>";
					head=true;
				}
			}
			if(head) str+="<br>";

			if (m_List[m_Page].Type == 2) { if(FormatSpecial(m_CotlId, m_List[m_Page])) str += m_List[m_Page].Final; }
			else if (m_List[m_Page].Type == 3) str += BaseStr.Replace(BaseStr.Replace(BaseStr.Replace(m_List[m_Page].Text, "\r\n", "<br>"), "\n", "<br>"), "\r", "<br>");
			else str+=m_List[m_Page].Text;
		}
		m_Text.htmlText=BaseStr.FormatTag(str);
		m_TextSB.update();
		m_TextSB.visible=m_TextSB.maxScrollPosition>1;
		
		//trace("MSP:"+m_TextSB.maxScrollPosition);

//var loadedObject:DisplayObject = m_Text.getImageReference('img01');
//if(loadedObject!=null) {
//loadedObject.loaderInfo.addEventListener(Event.COMPLETE,imgLoadComplate);
//	trace(loadedObject,loadedObject.loaderInfo,(loadedObject as Loader).content);
//}
	}

	public function frConst(e:Event):void
	{
		//if(!m_ChangeImageQuality) return;
		if(!visible) return;
		var i:int=0;
		var cc:Boolean=false;
		while(true) {
			var lod:DisplayObject = m_Text.getImageReference('_sys_img'+i.toString());
			if(lod==null) { if(cc) m_ChangeImageQuality=false; break; }
			i++;
			if(!(lod is Loader)) continue;
			var lo:Loader=lod as Loader;
			if(lo.content==null) continue;
			if(lo.content is Bitmap) {
				lo.x=5;
				(lo.content as Bitmap).smoothing=true;
				(lo.content as Bitmap).pixelSnapping=PixelSnapping.NEVER;
				cc=true;
			}
		}
			
//loadedObject.loaderInfo.addEventListener(Event.COMPLETE,imgLoadComplate);
//trace("frConst",loadedObject,loadedObject.loaderInfo,(loadedObject as Loader).content);
//var bm:Bitmap=(loadedObject as Loader).content as Bitmap;
//bm.smoothing=true;
//bm.pixelSnapping=PixelSnapping.NEVER;
	}

//	public function imgLoadComplate(e:Event):void
//	{
//trace("imgLoadComplate:",e.target);
//	}

	public function IsDev():Boolean // Созвездие в режиме разработки
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return true; // так как созвездие в режиме разработки не доступны игровые фичи.
		return (cotl.m_CotlFlag & SpaceCotl.fDevelopment) != 0;
	}
	
//	public function IsEditCotl():int // Созвездие редактирует разработчик созвездия 0-off 1-mapeditor 2-dev0 3-dev1 4-dev2
//	{
//		return EM.HS.IsEditCotlId(m_CotlId);
//	}

	public function MenuOpen():void
	{
		var obj:Object;
		var str:String;
		
		EM.m_FormMenu.Clear();

		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);

		if(m_ModeCur==m_ModeDesc || m_ModeCur==m_ModeJournal) {
			EM.m_FormMenu.Add(Common.Txt.FormHistAddCaption,clickAdd);
			while(cotl!=null) {
				if(m_Page<0 || m_Page>=m_List.length) break;
				
				if(EM.m_UserAccess & User.AccessGalaxyText) {}
				else {
					if(m_List[m_Page].Author!=Server.Self.m_UserId) break;
					if(cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
					else if ((m_List[m_Page].Prior + 15 * 60) * 1000 < EM.GetServerGlobalTime()) break;
					
				}
				EM.m_FormMenu.Add(Common.Txt.FormHistEditCaption,clickEdit);
				
				break;
			}
			while(cotl!=null) {
				if(m_Page<0 || m_Page>=m_List.length) break;
				
				if(EM.m_UserAccess & User.AccessGalaxyText) {}
				else {
					if(m_List[m_Page].Author==0) break;
					if(cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
					else if ((m_List[m_Page].Prior + 15 * 60) * 1000 < EM.GetServerGlobalTime()) break;
					else if(m_List[m_Page].Author!=Server.Self.m_UserId) break;
				}
				
				EM.m_FormMenu.Add(Common.Txt.FormHistDeleteCaption,clickDelete);
				
				break;
			}
		}
		while (m_ModeCur == m_ModeImport || m_ModeCur == m_ModeExport) {
			if (cotl.m_CotlType == Common.CotlTypeCombat) break;
//			if(cotl.m_Type==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
//			else if(cotl.m_Type==Common.CotlTypeRich && EM.m_MapEditor) {}
//			else if((cotl.m_Type==Common.CotlTypeProtect || cotl.m_Type==Common.CotlTypeCombat) && EM.m_MapEditor) {}
//			else break;

			str = "";
			if (IsDev()) str = " (dev)";

			// Import
			if (m_ModeCur == m_ModeImport) {
				obj = EM.m_FormMenu.Add(Common.Txt.FormHistGoodsAdd + str);
				if (IsDev()) {
					if(EM.m_UserAccess & User.AccessGalaxyOps) obj.Fun = clickTradeImportAdd;
					else obj.Disable=true;
				} else {
					if (cotl.m_CotlType == Common.CotlTypeUser && cotl.m_AccountId == Server.Self.m_UserId) obj.Fun = clickTradeImportAdd;
					else if ((cotl.m_CotlType == Common.CotlTypeProtect || cotl.m_CotlType == Common.CotlTypeRich) && EM.m_UnionId != 0 && cotl.m_UnionId == EM.m_UnionId) obj.Fun = clickTradeImportAdd;
					else obj.Disable = true;
				}
			}
			if(m_ModeCur==m_ModeImport) {
				obj = EM.m_FormMenu.Add(Common.Txt.FormHistGoodsEdit + str);
				if (m_TradeGrid.length <= 0 || m_TradeGrid.selectedItem == null) obj.Disable = true;
				else if (IsDev()) {
					if (m_TradeGrid.selectedItem.Owner != 0) obj.Disable = true;
					else if (EM.m_UserAccess & User.AccessGalaxyOps) obj.Fun = clickTradeImportChange;
					else obj.Disable = true;
				} else {
					if (m_TradeGrid.selectedItem.Owner != Server.Self.m_UserId) obj.Disable = true;
					else obj.Fun = clickTradeImportChange;
				}
			}
			if(m_ModeCur==m_ModeImport) {
				obj = EM.m_FormMenu.Add(Common.Txt.FormHistGoodsDelete + str);
				if (m_TradeGrid.length <= 0 || m_TradeGrid.selectedItem == null) obj.Disable = true;
				else if (IsDev()) {
					if (m_TradeGrid.selectedItem.Owner != 0) obj.Disable = true;
					else if (EM.m_UserAccess & User.AccessGalaxyOps) obj.Fun = clickTradeImportDel;
					else obj.Disable = true;
				} else {
					if (m_TradeGrid.selectedItem.Owner != Server.Self.m_UserId) obj.Disable = true;
					else obj.Fun = clickTradeImportDel;
				}
			}

			// Export
			if (m_ModeCur == m_ModeExport) {
				obj = EM.m_FormMenu.Add(Common.Txt.FormHistGoodsAdd + str);
				if (IsDev()) {
					if(EM.m_UserAccess & User.AccessGalaxyOps) obj.Fun = clickTradeExportAdd;
					else obj.Disable=true;
				} else {
					if (cotl.m_CotlType == Common.CotlTypeUser && cotl.m_AccountId == Server.Self.m_UserId) obj.Fun = clickTradeExportAdd;
					else if ((cotl.m_CotlType == Common.CotlTypeProtect || cotl.m_CotlType == Common.CotlTypeRich) && EM.m_UnionId != 0 && cotl.m_UnionId == EM.m_UnionId) obj.Fun = clickTradeExportAdd;
					else obj.Disable = true;
				}
			}
			if(m_ModeCur==m_ModeExport) {
				obj = EM.m_FormMenu.Add(Common.Txt.FormHistGoodsEdit + str);
				if (m_TradeGrid.length <= 0 || m_TradeGrid.selectedItem == null) obj.Disable = true;
				else if (IsDev()) {
					if (m_TradeGrid.selectedItem.Owner != 0) obj.Disable = true;
					else if (EM.m_UserAccess & User.AccessGalaxyOps) obj.Fun = clickTradeExportChange;
					else obj.Disable = true;
				} else {
					if (m_TradeGrid.selectedItem.Owner != Server.Self.m_UserId) obj.Disable = true;
					else obj.Fun = clickTradeExportChange;
				}
			}
			if(m_ModeCur==m_ModeExport) {
				obj = EM.m_FormMenu.Add(Common.Txt.FormHistGoodsDelete + str);
				if (m_TradeGrid.length <= 0 || m_TradeGrid.selectedItem == null) obj.Disable = true;
				else if (IsDev()) {
					if (m_TradeGrid.selectedItem.Owner != 0) obj.Disable = true;
					else if (EM.m_UserAccess & User.AccessGalaxyOps) obj.Fun = clickTradeExportDel;
					else obj.Disable = true;
				} else {
					if (m_TradeGrid.selectedItem.Owner != Server.Self.m_UserId) obj.Disable = true;
					else obj.Fun = clickTradeExportDel;
				}
			}
				
			break;
		}

		EM.m_FormMenu.Add();
		if (EM.m_UserAccess & User.AccessGalaxyOps) {
			EM.m_FormMenu.Add(Common.TxtEdit.ChangeCotlPos, clickChangeCotlPos);
		}
		if (EM.CotlDevAccess(cotl.m_Id) & (SpaceCotl.DevAccessAssignRights | SpaceCotl.DevAccessEditCode | SpaceCotl.DevAccessEditMap | SpaceCotl.DevAccessEditOps)) {
			EM.m_FormMenu.Add(Common.TxtEdit.CotlSet, EditCotlBegin);
		}
		if (EM.CotlDevAccess(cotl.m_Id) & (SpaceCotl.DevAccessView)) {
			EM.m_FormMenu.Add(Common.TxtEdit.MapEdit, EditCotlMapEdit);
		}
		if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) {
			if (cotl.m_DevTime <= EM.GetServerGlobalTime()) {
				EM.m_FormMenu.Add(Common.Txt.HyperspaceCotlDevBuy, EditCotlDevBuy);

			} else if (EM.CotlDevAccess(cotl.m_Id) & (SpaceCotl.DevAccessAssignRights | SpaceCotl.DevAccessEditMap | SpaceCotl.DevAccessEditOps | SpaceCotl.DevAccessEditCode)) {
				EM.m_FormMenu.Add(Common.Txt.HyperspaceCotlDevBuyContinue, EditCotlDevBuyContinue);
			}
		}

		EM.m_FormMenu.Add();

		while (cotl != null) {
			if (cotl.m_CotlType != Common.CotlTypeUser) break;
			if (cotl.m_AccountId != Server.Self.m_UserId) break;
			EM.m_FormMenu.Add(Common.Txt.FormHistBeacon, clickBeacon).Check = (cotl.m_CotlFlag & SpaceCotl.fBeacon) != 0;
			break;
		}

		EM.m_FormMenu.Add(Common.Txt.ButClose,clickClose);

		EM.m_FormMenu.SetButOpen(m_ButMenu);
		EM.m_FormMenu.Show(x+m_ButMenu.x,y+m_ButMenu.y,x+m_ButMenu.x+m_ButMenu.width,y+m_ButMenu.y+m_ButMenu.height);
	}
	
	public function clickBeacon(...args):void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;

		if ((cotl.m_CotlFlag & SpaceCotl.fBeacon) == 0) {
			if (args.length > 0) {
				FormMessageBox.Run(Common.Txt.FormHistBeaconQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, clickBeacon);
			} else {
				cotl.m_CotlFlag |= SpaceCotl.fBeacon;
		        Server.Self.QueryHS("emedcotlbeacon","&val=1",EditCotlRecv,false);
			}
		} else {
			cotl.m_CotlFlag &= ~SpaceCotl.fBeacon;
			Server.Self.QueryHS("emedcotlbeacon","&val=0",EditCotlRecv,false);
		}
	}
	
	public function clickAdd(...args):void
	{
		var cb:ComboBox;

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);

        var sp:String="";
		var i:int;
		if(m_ModeCur==m_ModeJournal) sp=Common.DateToSysStr(EM.GetServerDate());
		else { 
	        var p:int=0;
    	    for(i=0;i<m_List.length;i++) {
        		p=Math.max(m_List[i].Prior+1,p);
        	}
        	sp=p.toString();
		}

		EM.m_FormInput.Init(500);

		EM.m_FormInput.AddLabel(Common.Txt.FormHistAddCaption,18);

		while(true) {
			if(EM.m_UserAccess & User.AccessGalaxyText) {}
			else if(cotl!=null && cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
			else break;
				
			EM.m_FormInput.AddLabel(Common.Txt.FormHistDate+":");
			EM.m_FormInput.Col();
			EM.m_FormInput.AddInput(sp,19,true,Server.Self.m_Lang);
			break;
		}

		if(EM.m_UserAccess & User.AccessGalaxyText) {
			EM.m_FormInput.AddLabel(Common.Txt.FormHistType+":");
			EM.m_FormInput.Col();
			cb=EM.m_FormInput.AddComboBox();
			cb.addItem( { label:Common.Txt.FormHistTypeText, data:1 } );
			cb.addItem( { label:Common.Txt.FormHistTypeExt, data:2 } );
			cb.addItem( { label:Common.Txt.FormHistTypeLog, data:3 } );
		}

		EM.m_FormInput.AddLabel(Common.Txt.FormHistText+":");
		EM.m_FormInput.AddArea(400,true,"",16384,true,Server.Self.m_Lang).textField.restrict = null;

		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(AddSend,Common.Txt.FormHistAdd);
	}

	private function AddSend():void
	{
        var boundary:String=Server.Self.CreateBoundary();

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);

		var i:int=0;

        var d:String="";
		
		while(true) {
			if(EM.m_UserAccess & User.AccessGalaxyText) {}
			else if(cotl!=null && cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
			else break;
		
	        d+="--"+boundary+"\r\n";
    	    d+="Content-Disposition: form-data; name=\"date\"\r\n\r\n";
        	d+=EM.m_FormInput.GetStr(i)+"\r\n";
			i++;
			
			break;
		}

		var tt:int=1;
		if(EM.m_UserAccess & User.AccessGalaxyText) {
			tt=EM.m_FormInput.GetInt(i);
			i++;
		}

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"txt\"\r\n\r\n";
        d+=EM.m_FormInput.GetStr(i)+"\r\n";
		i++;

        d+="--"+boundary+"--\r\n";


        Server.Self.QueryPost("emhistchange","&op=1&type=1&id="+m_CotlId.toString()+"&tt="+tt.toString(),d,boundary,AddRecv,false);
	}

	private var m_InputScrollOff:int=0;
	private var m_InputScrollLen:int=0;
	private function AddRecv(event:Event):void
	{
		var str:String;
		var off:int;
		
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int=buf.readUnsignedByte();
		if(err==Server.ErrorText) {
			EM.m_Info.Hide(); 
			EM.m_FormInput.Show();// .visible = true;
			
			if((buf.length-buf.position)<=0) { FormMessageBox.Run(Common.Txt.FormHistErrTextLen,Common.Txt.ButClose); return; }
			off=buf.readInt();
			var ck:int=buf.readInt();
			m_InputScrollOff=off;
			m_InputScrollLen=1;

			str=BaseStr.Replace(Common.Txt.FormHistErrText,"<Offset>",off.toString());
			(EM.m_FormInput.GetInput(2) as TextArea).setFocus();
			(EM.m_FormInput.GetInput(2) as TextArea).setSelection(off,off+1);

			if((buf.length-buf.position)<=0) {
				str=BaseStr.Replace(str,"<CharCode>","("+ck.toString()+")");
			} else {
				str=BaseStr.Replace(str,"<CharCode>","\""+buf.readUTFBytes(buf.length-buf.position)+"\""+" ("+ck.toString()+")");
			}

			FormMessageBox.Run(str,Common.Txt.ButClose,"",null,InputScrollTo);

			return;
		}
		else if(err==Server.ErrorTag) {
			EM.m_Info.Hide(); 
			EM.m_FormInput.Show();// .visible = true;
			
			off=buf.readInt();
			var et:int=buf.readInt();
			m_InputScrollOff=off;
			m_InputScrollLen=0;
			
			str="Unknow";
			if(et==1) str=Common.Txt.FormHistErrTagUnknown;
			else if(et==2) str=Common.Txt.FormHistErrStackEmpty;
			else if(et==3) str=Common.Txt.FormHistErrStackFill;
			else if(et==4) str=Common.Txt.FormHistErrStackRemove;
			else if(et==5) str=Common.Txt.FormHistErrStackSmall;
			else if(et==6) str=Common.Txt.FormHistErrURL;
			else if(et==7) str=Common.Txt.FormHistErrText;

			str=BaseStr.Replace(str,"<Offset>",off.toString());
			(EM.m_FormInput.GetInput(2) as TextArea).setFocus();
			(EM.m_FormInput.GetInput(2) as TextArea).setSelection(off,off+1);

			if((buf.length-buf.position)<=0) {
			} else {
				str=BaseStr.Replace(str,"<Tag>",buf.readUTFBytes(buf.length-buf.position));
			}

			FormMessageBox.Run(str,Common.Txt.ButClose,"",null,InputScrollTo);

			return;
		} 
		else if(EM.ErrorFromServer(err)) return;

		m_GoToPage=1;

//trace("ListQueryAfterAdd");
		ListQuery();
	}
	
	public function InputScrollTo():void
	{
		(EM.m_FormInput.GetInput(2) as TextArea).setFocus();
		(EM.m_FormInput.GetInput(2) as TextArea).setSelection(m_InputScrollOff,m_InputScrollOff+m_InputScrollLen);
	}
	
	public function clickEdit(...args):void
	{
		var str:String;
		if(m_Page<0 || m_Page>=m_List.length) return;

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);
		
		EM.m_FormInput.Init(500);

		EM.m_FormInput.AddLabel(Common.Txt.FormHistEditCaption,18);

		while(true) {
			if(EM.m_UserAccess & User.AccessGalaxyText) {}
			else if(cotl!=null && cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
			else break;

			EM.m_FormInput.AddLabel(Common.Txt.FormHistDate+":");
			EM.m_FormInput.Col();
			if(m_ModeCur==m_ModeJournal) {
				var md:Date=EM.GetServerDate();
				md.setTime(md.getTime() + (m_List[m_Page].Prior * 1000 - EM.GetServerGlobalTime()));
				str=Common.DateToSysStr(md);
			}
			else str=m_List[m_Page].Prior.toString();
			EM.m_FormInput.AddInput(str,19,true,Server.Self.m_Lang);
			
			break;
		}

		if(EM.m_UserAccess & User.AccessGalaxyText) {
			EM.m_FormInput.AddLabel(Common.Txt.FormHistType+":");
			EM.m_FormInput.Col();
			EM.m_FormInput.AddComboBox();
			EM.m_FormInput.AddItem(Common.Txt.FormHistTypeText, 1, m_List[m_Page].Type == 1);
			EM.m_FormInput.AddItem(Common.Txt.FormHistTypeExt, 2, m_List[m_Page].Type == 2);
			EM.m_FormInput.AddItem(Common.Txt.FormHistTypeLog, 3, m_List[m_Page].Type == 3);
		}

		EM.m_FormInput.AddLabel(Common.Txt.FormHistText+":");
		EM.m_FormInput.AddArea(400,true,m_List[m_Page].Text,16384,true,Server.Self.m_Lang).textField.restrict = null;
		
		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(EditSend,Common.Txt.FormHistEdit);
	}

	private function EditSend():void
	{
        var boundary:String=Server.Self.CreateBoundary();

		var i:int=0;

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);

        var d:String="";

		while(true) {
			if(EM.m_UserAccess & User.AccessGalaxyText) {}
			else if(cotl!=null && cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
			else break;

	        d+="--"+boundary+"\r\n";
    	    d+="Content-Disposition: form-data; name=\"date\"\r\n\r\n";
        	d+=EM.m_FormInput.GetStr(i)+"\r\n";
			i++;

			break;
		}

		var tt:int=1;
		if(EM.m_UserAccess & User.AccessGalaxyText) {
			tt=EM.m_FormInput.GetInt(i);
			i++;
		}

        d+="--"+boundary+"\r\n";
   	    d+="Content-Disposition: form-data; name=\"txt\"\r\n\r\n";
       	d+=EM.m_FormInput.GetStr(i)+"\r\n";
		i++;

        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emhistchange","&op=2&type=1&id="+m_CotlId.toString()+"&tt="+tt.toString()+"&hid="+m_List[m_Page].Id.toString(),d,boundary,AddRecv,false);
	}

	public function clickDelete(...args):void
	{
		FormMessageBox.Run(Common.Txt.FormHistDeleteQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,SendDelete);
	}

	public function SendDelete():void
	{
		Server.Self.Query("emhistchange","&op=3&type=1&id="+m_CotlId.toString()+"&hid="+m_List[m_Page].Id.toString(),AddRecv,false);
	}

	public function ListQuery():void
	{
		var str:String = "&type=1&id=" + m_CotlId.toString();
		if (m_ModeCur == m_ModeJournal) str += "&period=" + ( -30 * 24 * 60 * 60).toString(); 
		else str += "&period=10000";
		Server.Self.Query("emhist", str, ListAnswer, false);
	}

	public function ListAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		buf.readUnsignedInt();
		buf.readUnsignedInt();

		m_List.length=0;

		while(true) {
			var rid:uint=buf.readUnsignedInt();
			if(rid==0) break;
			var dt:uint=buf.readUnsignedInt();
			var author:uint=buf.readUnsignedInt();
			var tt:int=buf.readUnsignedByte();
			var len:int=buf.readUnsignedShort();
			var str:String=buf.readUTFBytes(len);

			var obj:Object=new Object();
			obj.Id=rid;
			obj.Prior=dt;
			obj.Author=author;
			obj.Type=tt;
			obj.Text=str;

			m_List.push(obj);
		}

		if(m_GoToPage<0) m_Page=0;
		else if(m_GoToPage>0) m_Page=m_List.length-1;
		m_GoToPage=0;

		if(m_Page<0) m_Page=0;
		else if(m_Page>=m_List.length) m_Page=m_List.length-1;

		if(m_ModeCur==m_ModeDesc || m_ModeCur==m_ModeJournal) UpdateText();
	}

	public static function FormatSpecial(cotlid:uint, obj:Object):Boolean
	{
		var start:int,num:int,i:int,ots:int;
		var sme:int=0;
		var ch:int;
		var name:String,val:String;
		var out:String="";
		var user1:User;
		var user2:User;
		
		var ret:Boolean = true;

		var src:String = obj.Text;
		var srclen:int=src.length;

		var rfinal:int=0;
		var rtype:int=0; // 1-battle 2-defence 3-sell 4-buy 5-sack

		var userid:int=0;
		var owner1:uint=0;
		var owner2:uint=0;
		var period:int=0;
		var flagship1:int=0,cruiser1:int=0,dreadnought1:int=0,devastator1:int=0,corvette1:int=0,warbase1:int=0,shipyard1:int=0,scibase1:int=0,transport1:int=0,invader1:int=0;
		var flagship2:int=0,cruiser2:int=0,dreadnought2:int=0,devastator2:int=0,corvette2:int=0,warbase2:int=0,shipyard2:int=0,scibase2:int=0,transport2:int=0,invader2:int=0;
		var scorereceive1:int=0,expreceive1:int=0;
		var scorereceive2:int=0,expreceive2:int=0;
		var antimatterlost1:int=0,metallost1:int=0,electronicslost1:int=0,protoplasmlost1:int=0,nodeslost1:int=0,planetlost1:int=0;
		var lostfrommine1:int=0,lostfromhack1:int=0,lostshipfromannihilation1:int=0,lostbasefromannihilation1:int=0;
		var antimatterlost2:int=0,metallost2:int=0,electronicslost2:int=0,protoplasmlost2:int=0,nodeslost2:int=0,planetlost2:int=0;
		var lostfrommine2:int=0,lostfromhack2:int=0,lostshipfromannihilation2:int=0,lostbasefromannihilation2:int=0;
		
		var goods_type:int=0;
		var goods_cnt:int=0;
		var goods_step:int=0;
		var goods_price:int=0;

		while(true) {
			if(rfinal==1 || rfinal==2) {
				// Caption
				if(rfinal==2) val=Common.Hist.Defence;
				else val=Common.Hist.Battle;

				user1 = UserList.Self.GetUser(owner1);
				if (owner1 != 0 && user1 == null) ret = false;
				if(user1!=null) val=BaseStr.Replace(val,"<Owner1>",EmpireMap.Self.Txt_CotlOwnerName(cotlid, user1.m_Id));
				user2 = UserList.Self.GetUser(owner2);
				if (owner2 != 0 && user2 == null) ret = false;
				if(user2!=null) val=BaseStr.Replace(val,"<Owner2>",EmpireMap.Self.Txt_CotlOwnerName(cotlid, user2.m_Id));

				out+=val+"<br>";

				if(period!=0) {
					out+=Common.Hist.Period+": [clr]"+Common.FormatPeriod(period)+"[/clr]<br>";
				}
				
				// Recv1
				if(scorereceive1!=0 || expreceive1!=0) {
					val=Common.Hist.UserRecv;
					if(user1!=null) val=BaseStr.Replace(val,"<Owner>",EmpireMap.Self.Txt_CotlOwnerName(cotlid, user1.m_Id));
					val=BaseStr.Replace(val,"<Score>",scorereceive1.toString());
					val=BaseStr.Replace(val,"<Exp>",expreceive1.toString());
					out+=val+"<br>";
				}

				// Recv2
				if(scorereceive2!=0 || expreceive2!=0) {
					val=Common.Hist.UserRecv;
					if(user2!=null) val=BaseStr.Replace(val,"<Owner>",EmpireMap.Self.Txt_CotlOwnerName(cotlid, user2.m_Id));
					val=BaseStr.Replace(val,"<Score>",scorereceive2.toString());
					val=BaseStr.Replace(val,"<Exp>",expreceive2.toString());
					out+=val+"<br>";
				}

				// Lost1
				start=out.length;
				val=Common.Hist.UserLost;
				if(user1!=null) val=BaseStr.Replace(val,"<Owner>",EmpireMap.Self.Txt_CotlOwnerName(cotlid, user1.m_Id));
				out+="<br>"+val+":<br>";
				ots=out.length;

				if(flagship1!=0) out+=Common.Hist.FlagshipLost+": [clr]"+BaseStr.FormatBigInt(flagship1)+"[/clr]<br>";
				if(cruiser1!=0) out+=Common.Hist.CruiserLost+": [clr]"+BaseStr.FormatBigInt(cruiser1)+"[/clr]<br>";
				if(dreadnought1!=0) out+=Common.Hist.DreadnoughtLost+": [clr]"+BaseStr.FormatBigInt(dreadnought1)+"[/clr]<br>";
				if(devastator1!=0) out+=Common.Hist.DevastatorLost+": [clr]"+BaseStr.FormatBigInt(devastator1)+"[/clr]<br>";
				if(corvette1!=0) out+=Common.Hist.CorvetteLost+": [clr]"+BaseStr.FormatBigInt(corvette1)+"[/clr]<br>";
				if(warbase1!=0) out+=Common.Hist.WarBaseLost+": [clr]"+BaseStr.FormatBigInt(warbase1)+"[/clr]<br>";
				if(shipyard1!=0) out+=Common.Hist.ShipyardLost+": [clr]"+BaseStr.FormatBigInt(shipyard1)+"[/clr]<br>";
				if(scibase1!=0) out+=Common.Hist.SciBaseLost+": [clr]"+BaseStr.FormatBigInt(scibase1)+"[/clr]<br>";
				if(transport1!=0) out+=Common.Hist.TransportLost+": [clr]"+BaseStr.FormatBigInt(transport1)+"[/clr]<br>";
				if(invader1!=0) out+=Common.Hist.InvaderLost+": [clr]"+BaseStr.FormatBigInt(invader1)+"[/clr]<br>";
				
				if(lostfrommine1!=0) out+=Common.Hist.LostFromMine+": [clr]"+BaseStr.FormatBigInt(lostfrommine1)+"[/clr]<br>";
				if(lostfromhack1!=0) out+=Common.Hist.LostFromHack+": [clr]"+BaseStr.FormatBigInt(lostfromhack1)+"[/clr]<br>";
				if(lostshipfromannihilation1!=0) out+=Common.Hist.LostShipFromAnnihilation+": [clr]"+BaseStr.FormatBigInt(lostshipfromannihilation1)+"[/clr]<br>";
				if(lostbasefromannihilation1!=0) out+=Common.Hist.LostBaseFromAnnihilation+": [clr]"+BaseStr.FormatBigInt(lostbasefromannihilation1)+"[/clr]<br>";

				if(planetlost1!=0) out+=Common.Hist.PlanetLost+": [clr]"+BaseStr.FormatBigInt(planetlost1)+"[/clr]<br>";
				if(antimatterlost1!=0) out+=Common.Hist.AntimatterLost+": [clr]"+BaseStr.FormatBigInt(antimatterlost1)+"[/clr]<br>";
				if(metallost1!=0) out+=Common.Hist.MetalLost+": [clr]"+BaseStr.FormatBigInt(metallost1)+"[/clr]<br>";
				if(electronicslost1!=0) out+=Common.Hist.ElectronicsLost+": [clr]"+BaseStr.FormatBigInt(electronicslost1)+"[/clr]<br>";
				if(protoplasmlost1!=0) out+=Common.Hist.ProtoplasmLost+": [clr]"+BaseStr.FormatBigInt(protoplasmlost1)+"[/clr]<br>";
				if(nodeslost1!=0) out+=Common.Hist.NodesLost+": [clr]"+BaseStr.FormatBigInt(nodeslost1)+"[/clr]<br>";

				if(out.length==ots) out=out.substr(0,start);

				// Lost2
				start=out.length;
				val=Common.Hist.UserLost;
				if(user2!=null) val=BaseStr.Replace(val,"<Owner>",EmpireMap.Self.Txt_CotlOwnerName(cotlid, user2.m_Id));
				out+="<br>"+val+":<br>";
				ots=out.length;

				if(flagship2!=0) out+=Common.Hist.FlagshipLost+": [clr]"+BaseStr.FormatBigInt(flagship2)+"[/clr]<br>";
				if(cruiser2!=0) out+=Common.Hist.CruiserLost+": [clr]"+BaseStr.FormatBigInt(cruiser2)+"[/clr]<br>";
				if(dreadnought2!=0) out+=Common.Hist.DreadnoughtLost+": [clr]"+BaseStr.FormatBigInt(dreadnought2)+"[/clr]<br>";
				if(devastator2!=0) out+=Common.Hist.DevastatorLost+": [clr]"+BaseStr.FormatBigInt(devastator2)+"[/clr]<br>";
				if(corvette2!=0) out+=Common.Hist.CorvetteLost+": [clr]"+BaseStr.FormatBigInt(corvette2)+"[/clr]<br>";
				if(warbase2!=0) out+=Common.Hist.WarBaseLost+": [clr]"+BaseStr.FormatBigInt(warbase2)+"[/clr]<br>";
				if(shipyard2!=0) out+=Common.Hist.ShipyardLost+": [clr]"+BaseStr.FormatBigInt(shipyard2)+"[/clr]<br>";
				if(scibase2!=0) out+=Common.Hist.SciBaseLost+": [clr]"+BaseStr.FormatBigInt(scibase2)+"[/clr]<br>";
				if(transport2!=0) out+=Common.Hist.TransportLost+": [clr]"+BaseStr.FormatBigInt(transport2)+"[/clr]<br>";
				if(invader2!=0) out+=Common.Hist.InvaderLost+": [clr]"+BaseStr.FormatBigInt(invader2)+"[/clr]<br>";
				
				if(lostfrommine2!=0) out+=Common.Hist.LostFromMine+": [clr]"+BaseStr.FormatBigInt(lostfrommine2)+"[/clr]<br>";
				if(lostfromhack2!=0) out+=Common.Hist.LostFromHack+": [clr]"+BaseStr.FormatBigInt(lostfromhack2)+"[/clr]<br>";
				if(lostshipfromannihilation2!=0) out+=Common.Hist.LostShipFromAnnihilation+": [clr]"+BaseStr.FormatBigInt(lostshipfromannihilation2)+"[/clr]<br>";
				if(lostbasefromannihilation2!=0) out+=Common.Hist.LostBaseFromAnnihilation+": [clr]"+BaseStr.FormatBigInt(lostbasefromannihilation2)+"[/clr]<br>";
				
				if(planetlost2!=0) out+=Common.Hist.PlanetLost+": [clr]"+BaseStr.FormatBigInt(planetlost2)+"[/clr]<br>";
				if(antimatterlost2!=0) out+=Common.Hist.AntimatterLost+": [clr]"+BaseStr.FormatBigInt(antimatterlost2)+"[/clr]<br>";
				if(metallost2!=0) out+=Common.Hist.MetalLost+": [clr]"+BaseStr.FormatBigInt(metallost2)+"[/clr]<br>";
				if(electronicslost2!=0) out+=Common.Hist.ElectronicsLost+": [clr]"+BaseStr.FormatBigInt(electronicslost2)+"[/clr]<br>";
				if(protoplasmlost2!=0) out+=Common.Hist.ProtoplasmLost+": [clr]"+BaseStr.FormatBigInt(protoplasmlost2)+"[/clr]<br>";
				if(nodeslost2!=0) out+=Common.Hist.NodesLost+": [clr]"+BaseStr.FormatBigInt(nodeslost2)+"[/clr]<br>";

				if(out.length==ots) out=out.substr(0,start);

				out+="<br>";

				owner1=0;
				owner2=0;
				period=0;
				flagship1=cruiser1=dreadnought1=devastator1=corvette1=warbase1=shipyard1=scibase1=transport1=invader1=0;
				flagship2=cruiser2=dreadnought2=devastator2=corvette2=warbase2=shipyard2=scibase2=transport2=invader2=0;
				scorereceive1=expreceive1=0;
				scorereceive2=expreceive2=0;
				antimatterlost1=metallost1=electronicslost1=protoplasmlost1=nodeslost1=planetlost1=0;
				lostfrommine1=lostfromhack1=lostshipfromannihilation1=lostbasefromannihilation1=0
				antimatterlost2=metallost2=electronicslost2=protoplasmlost2=nodeslost2=planetlost2=0;
				lostfrommine2=lostfromhack2=lostshipfromannihilation2=lostbasefromannihilation2=0

			} else if(rfinal==3 || rfinal==4) {
				if(rfinal==3) val=Common.Hist.Sell;
				else val=Common.Hist.Buy;

				user1 = UserList.Self.GetUser(userid);
				if (userid != 0 && user1 == null) ret = false;
				if (user1 != null) val = BaseStr.Replace(val, "<User>", "[clr]" + EmpireMap.Self.Txt_CotlOwnerName(cotlid, user1.m_Id) + "[/clr]");

				out+=val+"<br>";

				out += Common.Hist.Goods + ": [clr]" + EmpireMap.Self.ItemName(goods_type) + "[/clr]<br>";
				out += Common.Hist.GoodsCnt + ": [clr]" + BaseStr.FormatBigInt(goods_cnt) + "[/clr]<br>";
				out += Common.Hist.GoodsSum + ": [clr]" + BaseStr.FormatBigInt(Math.ceil(goods_cnt / goods_step) * goods_price) + "[/clr] cr.<br>";

				out+="<br>";

				userid=0;
				goods_type=0;
				goods_cnt=0;
				goods_step=0;
				goods_price=0;
			} else if(rfinal==5) {
				val=Common.Hist.Sack;

				user1 = UserList.Self.GetUser(userid);
				if (userid != 0 && user1 == null) ret = false;
				if (user1 != null) val = BaseStr.Replace(val, "<User>", "[clr]" + EmpireMap.Self.Txt_CotlOwnerName(cotlid, user1.m_Id) + "[/clr]");

				out+=val+"<br>";

				out += Common.Hist.Goods + ": [clr]" + EmpireMap.Self.ItemName(goods_type) + "[/clr]<br>";
				out += Common.Hist.GoodsCnt + ": [clr]" + BaseStr.FormatBigInt(goods_cnt) + "[/clr]<br>";

				out+="<br>";

				userid=0;
				goods_type=0;
				goods_cnt=0;
				goods_step=0;
				goods_price=0;
			}

			rfinal=0;
			
			if(sme>=srclen) {
				if(rtype!=0) { rfinal=rtype; rtype=0; continue; }
				break;
			}
			ch=src.charCodeAt(sme);
			sme++;

			if(ch==32 || ch==9 || ch==0x0d || ch==0x0a) continue;
			if(ch==40) { // (
				start=sme;
				while(sme<srclen) {
					ch=src.charCodeAt(sme);
					sme++;
					if(ch==41) break; // )
				}
				name=src.substring(start,sme-1);
				
				rfinal=rtype;
				rtype=0;
				
				if(BaseStr.IsTagEq(name,0,name.length,"battle","BATTLE")) {
					rtype=1;
				} else if(BaseStr.IsTagEq(name,0,name.length,"defence","DEFENCE")) {
					rtype=2;
				} else if(BaseStr.IsTagEq(name,0,name.length,"sell","SELL")) {
					rtype=3;
				} else if(BaseStr.IsTagEq(name,0,name.length,"buy","BUY")) {
					rtype=4;
				} else if(BaseStr.IsTagEq(name,0,name.length,"sack","SACK")) {
					rtype=5;
				}

//trace("("+name+")");
				continue;
			}
			
			start=sme-1;
			while(sme<srclen) {
				ch=src.charCodeAt(sme);
				if(ch==61) break; // =
				sme++;
			}
			if(sme>=srclen) break;
			
			name=src.substring(start,sme);
			sme++;
			
			start=sme;
			while(sme<srclen) {
				ch=src.charCodeAt(sme);
				if(ch==0x0d || ch==0x0a) break; // \n
				sme++;
			}
			
			val=src.substring(start,sme);
//trace(name+"="+val+"  "+name.length.toString()+"   "+val.length.toString());
			
			if(BaseStr.IsTagEq(name,0,name.length,"owner1","OWNER1")) owner1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"owner2","OWNER2")) owner2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"user","USER")) userid=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"period","PERIOD")) period=int(val);
			
			else if(BaseStr.IsTagEq(name,0,name.length,"transport1","TRANSPORT1")) transport1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"corvette1","CORVETTE1")) corvette1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"cruiser1","CRUISER1")) cruiser1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"dreadnought1","DREADNOUGHT1")) dreadnought1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"invader1","INVADER1")) invader1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"devastator1","DEVASTATOR1")) devastator1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"warbase1","WARBASE1")) warbase1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"shipyard1","SHIPYARD1")) shipyard1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"scibase1","SCIBASE1")) scibase1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"flagship1","FLAGSHIP1")) flagship1=int(val);

			else if(BaseStr.IsTagEq(name,0,name.length,"transport2","TRANSPORT2")) transport2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"corvette2","CORVETTE2")) corvette2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"cruiser2","CRUISER2")) cruiser2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"dreadnought2","DREADNOUGHT2")) dreadnought2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"invader2","INVADER2")) invader2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"devastator2","DEVASTATOR2")) devastator2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"warbase2","WARBASE2")) warbase2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"shipyard2","SHIPYARD2")) shipyard2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"scibase2","SCIBASE2")) scibase2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"flagship2","FLAGSHIP2")) flagship2=int(val);

			else if(BaseStr.IsTagEq(name,0,name.length,"scorereceive1","SCORERECEIVE1")) scorereceive1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"expreceive1","EXPRECEIVE1")) expreceive1=int(val);

			else if(BaseStr.IsTagEq(name,0,name.length,"scorereceive2","SCORERECEIVE2")) scorereceive2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"expreceive2","EXPRECEIVE2")) expreceive2=int(val);
			
			else if(BaseStr.IsTagEq(name,0,name.length,"antimatterlost1","ANTIMATTERLOST1")) antimatterlost1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"metallost1","METALLOST1")) metallost1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"electronicslost1","ELECTRONICSLOST1")) electronicslost1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"protoplasmlost1","PROTOPLASMLOST1")) protoplasmlost1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"nodeslost1","NODESLOST1")) nodeslost1=int(val);

			else if(BaseStr.IsTagEq(name,0,name.length,"planetlost1","PLANETLOST1")) planetlost1=int(val);
			
			else if(BaseStr.IsTagEq(name,0,name.length,"lostfrommine1","LOSTFROMMINE1")) lostfrommine1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"lostfromhack1","LOSTFROMHACK1")) lostfromhack1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"lostshipfromannihilation1","LOSTSHIPFROMANNIHILATION1")) lostshipfromannihilation1=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"lostbasefromannihilation1","LOSTBASEFROMANNIHILATION1")) lostbasefromannihilation1=int(val);

			else if(BaseStr.IsTagEq(name,0,name.length,"antimatterlost2","ANTIMATTERLOST2")) antimatterlost2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"metallost2","METALLOST2")) metallost2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"electronicslost2","ELECTRONICSLOST2")) electronicslost2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"protoplasmlost2","PROTOPLASMLOST2")) protoplasmlost2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"nodeslost2","NODESLOST2")) nodeslost1=int(val);

			else if(BaseStr.IsTagEq(name,0,name.length,"planetlost2","PLANETLOST2")) planetlost2=int(val);

			else if(BaseStr.IsTagEq(name,0,name.length,"lostfrommine2","LOSTFROMMINE2")) lostfrommine2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"lostfromhack2","LOSTFROMHACK2")) lostfromhack2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"lostshipfromannihilation2","LOSTSHIPFROMANNIHILATION2")) lostshipfromannihilation2=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"lostbasefromannihilation2","LOSTBASEFROMANNIHILATION2")) lostbasefromannihilation2=int(val);

			else if(BaseStr.IsTagEq(name,0,name.length,"goodstype","GOODSTYPE")) goods_type=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"goodscnt","GOODSCNT")) goods_cnt=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"goodsstep","GOODSSTEP")) goods_step=int(val);
			else if(BaseStr.IsTagEq(name,0,name.length,"goodsprice","GOODSPRICE")) goods_price=int(val);
//trace(val,owner1,owner2,period);
		}

		obj.Final = out;
		return ret;
	}
	
	public function clickChangeCotlPos(...args):void
	{
		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);

		EM.m_FormInput.Init();
		
		EM.m_FormInput.AddLabel(Common.TxtEdit.ChangeCotlPos+":");
		
		EM.m_FormInput.AddLabel("X:");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddInput(Math.ceil(cotl.m_ZoneX * EM.HS.SP.m_ZoneSize + cotl.m_PosX).toString(), 11, true);
		
		EM.m_FormInput.AddLabel("Y:");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddInput(Math.ceil(cotl.m_ZoneY * EM.HS.SP.m_ZoneSize + cotl.m_PosY).toString(), 11, true);

		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(clickChangeCotlPosSend);
	}
	
	public function clickChangeCotlPosSend():void
	{
		var newx:int=EM.m_FormInput.GetInt(0);
		var newy:int=EM.m_FormInput.GetInt(1);
		Server.Self.Query("emedcotlmove",'&val='+m_CotlId.toString()+'_'+newx.toString()+'_'+newy.toString(),SimpleRecv,false);
	}

	private function SimpleRecv(event:Event):void
	{
	}

	public function TradeQuery():void
	{
		var str:String="&id="+m_CotlId.toString();
		Server.Self.QueryHS("emtrade",str,TradeAnswer,false);
	}

	public function TradeAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		m_TradeList.length=0;

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		while(true) {
			var recordid:uint=sl.LoadDword();
			if(recordid==0) break;

			var obj:Object=new Object();
			obj.RecordId = recordid;
			obj.RDate = sl.LoadDword();
			obj.Dir = sl.LoadInt();
			obj.Owner = sl.LoadDword();
			obj.Money = sl.LoadInt();
			obj.Storage = sl.LoadInt();
			obj.ItemType=sl.LoadDword();
			obj.ItemCnt=sl.LoadInt();
			obj.ItemStep=sl.LoadInt();
			obj.ItemPrice = sl.LoadInt();
			obj.MinPrice = sl.LoadInt();
			obj.MaxPrice = sl.LoadInt();
			obj.Range = sl.LoadInt();
//trace(obj.RecordId,obj.Dir,obj.ItemType,obj.ItemCnt,obj.ItemStep,obj.ItemPrice);

//			UserList.Self.GetItem(obj.ItemType);

			m_TradeList.push(obj);
		}

		sl.LoadEnd();

		if(m_ModeCur==m_ModeImport || m_ModeExport) TradeUpdate();
	}
	
	public function TradeUpdate():void
	{
		var i:int,u:int;
		var obj:Object;
		var str:String;
		var user:User;

		for(i=0;i<m_TradeGrid.length;i++) {
			obj=m_TradeGrid.getItemAt(i);
			obj.Tmp=0;
		}

		for(i=0;i<m_TradeList.length;i++) {
			var tg:Object=m_TradeList[i];

			if(tg.Dir==0 && m_ModeCur==m_ModeImport) {}
			else if(tg.Dir==1 && m_ModeCur==m_ModeExport) {}
			else continue;

			for(u=0;u<m_TradeGrid.length;u++) {
				obj=m_TradeGrid.getItemAt(u);
				if(obj.RecordId==tg.RecordId) break;
			}
			if(u>=m_TradeGrid.length) {
				obj=new Object();
				obj.RecordId=tg.RecordId;
				m_TradeGrid.addItem(obj);
			} else {
				m_TradeGrid.invalidateItem(obj);
			}

			//var item:Item=UserList.Self.GetItem(tg.ItemType);

			obj.Name = EM.ItemName(tg.ItemType);
			obj.ItemType = tg.ItemType;
			obj.ItemCnt = tg.ItemCnt;
			obj.ItemPrice = tg.ItemPrice;
			obj.MinPrice = tg.MinPrice;
			obj.MaxPrice = tg.MaxPrice;
			obj.Range = tg.Range;
			obj.Storage = tg.Storage;
			obj.Money = tg.Money;
			obj.Owner = tg.Owner;

			str = "";
			if (obj.Owner != Server.Self.m_UserId) {}
			else if (m_ModeCur == m_ModeImport && tg.Storage != 0) str += "" + BaseStr.FormatBigInt(tg.Storage);// + ": " + BaseStr.FormatBigInt(tg.Money);
			else if (m_ModeCur == m_ModeExport && tg.Money != 0) str += "" + BaseStr.FormatBigInt(tg.Money);// + ": " + BaseStr.FormatBigInt(tg.Storage);

			user = UserList.Self.GetUser(obj.Owner);
			if (user != null) {
				if (str.length > 0) str += ": ";
				str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
			}

			obj.SM = str;

			if(tg.ItemCnt<0) {
				obj.Cnt=Common.Txt.FormHistGoodsCntIndefinitely;
				
			} else {
				obj.Cnt=BaseStr.FormatBigInt(tg.ItemCnt);
				
				if(tg.ItemStep==10 && obj.Cnt.length>1) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-1)+"'"+obj.Cnt.substr(obj.Cnt.length-1,1);
				else if(tg.ItemStep==100 && obj.Cnt.length>2) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-2)+"'"+obj.Cnt.substr(obj.Cnt.length-2,2);
				else if(tg.ItemStep==1000 && obj.Cnt.length>3) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-3-1)+"'"+obj.Cnt.substr(obj.Cnt.length-3,3);
				else if(tg.ItemStep==10000 && obj.Cnt.length>5) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-5)+"'"+obj.Cnt.substr(obj.Cnt.length-5,5);
				else if(tg.ItemStep==100000 && obj.Cnt.length>6) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-6)+"'"+obj.Cnt.substr(obj.Cnt.length-6,6);
				else if(tg.ItemStep==1000000 && obj.Cnt.length>7) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-7-1)+"'"+obj.Cnt.substr(obj.Cnt.length-7,7);
			}
			
			if (tg.ItemStep == 1) obj.StepTxt = "1";
			else if (tg.ItemStep == 10) obj.StepTxt = "10";
			else if (tg.ItemStep == 100) obj.StepTxt = "100";
			else if (tg.ItemStep == 1000) obj.StepTxt = "1k";
			else if (tg.ItemStep == 10000) obj.StepTxt = "10k";
			else if (tg.ItemStep == 100000) obj.StepTxt = "100k";
			else if (tg.ItemStep == 1000000) obj.StepTxt = "1m";
			else obj.StepTxt = tg.ItemStep.toString();

			obj.Step=tg.ItemStep;
			obj.Price=BaseStr.FormatBigInt(tg.ItemPrice);
			obj.Tmp=1;
		}

		for(i=m_TradeGrid.length-1;i>=0;i--) {
			obj=m_TradeGrid.getItemAt(i);
			if(obj.Tmp!=0) continue;
			
			m_TradeGrid.removeItemAt(i);
		} 
	}
	
	private var m_EditCnt:TextInput=null;
	private var m_EditStep:ComboBox=null;
	private var m_EditPrice:TextInput = null;
	private var m_EditStorage:TextInput = null;
	private var m_EditMoney:TextInput = null;
	private var m_EditSum:TextField=null;
	private var m_EditSlider:Slider=null;
	private var m_EditSumAdd:int=0;
	
	private function EditStorage():int
	{
		if (m_EditStorage == null) return 0;
		//try { return D.evalToInt(m_EditStorage.text); } catch (e:*) { return int(m_EditStorage.text); }
		return Common.CalcExpInt(m_EditStorage.text, int(m_EditStorage.text));
		return 0;
	}

	private function EditMoney():int
	{
		if (m_EditMoney == null) return 0;
		//try { return D.evalToInt(m_EditMoney.text); } catch (e:*) { return int(m_EditMoney.text); }
		return Common.CalcExpInt(m_EditMoney.text, int(m_EditMoney.text));
		return 0;
	}

	private function EditPrice(no:int):int
	{
		if (m_EditPrice == null) return 0;
		var a:Array = m_EditPrice.text.split(";");
		if (a == null) return 0;
		if (a.length <= 0) return 0;
		
		var p1:int = 0;
		var p2:int = 0;
		var r:int = 0;
		//try { p1 = D.evalToInt(a[0]); } catch (e:*) { p1 = int(a[0]); }
		p1=Common.CalcExpInt(a[0], int(a[0]));
				
		if (a.length >= 2) {
			//try { p2 = D.evalToInt(a[1]); } catch (e:*) { p2 = int(a[1]); }
			p2 = Common.CalcExpInt(a[1], int(a[1]));
		} else {
			p2 = p1;
		}
		
		if (a.length >= 3) {
			//try { r = D.evalToInt(a[2]); } catch (e:*) { r = int(a[2]); }
			r = Common.CalcExpInt(a[2], int(a[2]));
		}
		
		if (p1 < 0) p1 = 0;
		else if (p1 > 1000000000) p1 = 1000000000;
		if (p2 < 0) p2 = 0;
		else if (p2 > 1000000000) p2 = 1000000000;
		if (r < 0) r = 0;
		else if (r > 1000000000) r = 1000000000;

		if (no == 0) return Math.min(p1, p2);
		else if (no == 1) return Math.max(p1, p2);
		else if (no == 2) return r;
		return 0;
	}
	
	public function TestIsExistItemInTrade(it:uint):Boolean
	{
		var i:int;
		var obj:Object;
		
		for (i = 0; i < m_TradeList.length; i++) {
			obj = m_TradeList[i];
			if(m_ModeCur==m_ModeImport) {
				if (obj.Dir != 0) continue;
			} else {
				if (obj.Dir != 1) continue;
			}
			if (obj.Owner != Server.Self.m_UserId) continue;
			if (obj.ItemType != it) continue;
			return true;
		}
		return false;
	}

	public function clickTradeImportAdd(...args):void
	{
		var i:int;

		EM.m_Info.Hide();

		m_EditCnt=null;
		m_EditStep=null;
		m_EditPrice = null;
		m_EditStorage = null;
		m_EditMoney = null;
		m_EditSum=null;
		m_EditSlider=null;
		m_EditSumAdd=0;

		EM.m_FormInput.Init();
		
		EM.m_FormInput.AddLabel(Common.Txt.FormHistImportCaption,18);
		
		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsType+":");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddComboBox();
		
		EM.m_FormInput.AddItem(EM.ItemName(Common.ItemTypeFuel), Common.ItemTypeFuel);
		EM.m_FormInput.AddItem(EM.ItemName(Common.ItemTypeModule), Common.ItemTypeModule, true);
		EM.m_FormInput.AddItem(EM.ItemName(Common.ItemTypeEGM), Common.ItemTypeEGM);
		for (i = 0; i < args.length; i++) {
			if (args[i] is int) {}
			else if (args[i] is uint) {}
			else break;
			
			if (TestIsExistItemInTrade(args[i])) {
				FormMessageBox.Run(Common.Txt.FormHistTradeItemNoMore,Common.Txt.ButClose);
				return;
			}
			
			EM.m_FormInput.AddItem(EM.ItemName(args[i]), args[i], i == 0);
		}
		
		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsCntImport2+":");
		EM.m_FormInput.Col();
		m_EditCnt=EM.m_FormInput.AddInput("0",128,true,Server.LANG_ENG,true);
		m_EditCnt.addEventListener(Event.CHANGE,EditTradeChange);

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsStep+":");
		EM.m_FormInput.Col();
		m_EditStep=EM.m_FormInput.AddComboBox();
		EM.m_FormInput.AddItem("1",1,true);
		EM.m_FormInput.AddItem("10",10);
		EM.m_FormInput.AddItem("100",100);
		EM.m_FormInput.AddItem("1k",1000);
		EM.m_FormInput.AddItem("10k",10000);
		EM.m_FormInput.AddItem("100k",100000);
		EM.m_FormInput.AddItem("1m",1000000);
		m_EditStep.addEventListener(Event.CHANGE,EditTradeStepChange);

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsPrice+":");
		EM.m_FormInput.Col();
		m_EditPrice=EM.m_FormInput.AddInput("1",128,true,Server.LANG_ENG,true);
		m_EditPrice.addEventListener(Event.CHANGE,EditTradeChange)

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsStorage2+":");
		EM.m_FormInput.Col();
		m_EditStorage=EM.m_FormInput.AddInput("0",128,true,Server.LANG_ENG,true);
		m_EditStorage.addEventListener(Event.CHANGE, EditTradeChange)

		m_EditSum=EM.m_FormInput.AddLabel(Common.Txt.FormHistTradeSum+": 0");
		
		EditTradeStepChange(null);
		
		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(sendTradeImportAdd,Common.Txt.FormHistAdd);
	}

	private function EditTradeStepChange(e:Event):void
	{
		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);

		//var v:int=int(m_EditCnt.text);
		var v:int = 0;
//		try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { v = int(m_EditCnt.text); }
		v = Common.CalcExpInt(m_EditCnt.text, int(m_EditCnt.text));

		if(v<0 && cotl.m_CotlType==Common.CotlTypeUser) v=0; 
		var s:int=m_EditStep.selectedItem.data;

		if (v >= 0) m_EditCnt.text = (Math.ceil(v / s) * s).toString();

		EditTradeChange(null);
	}
	
	private function EditTradeChange(e:Event):void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);

//		var t:uint = EM.m_FormInput.GetInt(0);
//		var item:Item = UserList.Self.GetItem(t & 0xfffff);
//		if (item == null) return;

//		var v:int=int(m_EditCnt.text);
		var v:int = 0;
//		try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { v = int(m_EditCnt.text); }
		v = Common.CalcExpInt(m_EditCnt.text, int(m_EditCnt.text));

		if (v < 0 && !IsDev()) v = 0; 
		var s:int = m_EditStep.selectedItem.data;

//		var p:int=int(m_EditPrice.text);
		var pmin:int = EditPrice(0);
		var pmax:int = EditPrice(1);
		var range:int = EditPrice(2);
		//try { p = D.evalToInt(m_EditPrice.text); } catch (e:*) { v = int(m_EditPrice.text); }

		var storage:int = EditStorage();

		var p:int = pmin;
		if (pmin != pmax && range > 0) {
			if (m_ModeCur == m_ModeImport) p = pmax - Math.floor(((storage) * (pmax - pmin)) / range);
			if (m_ModeCur == m_ModeExport) p = pmax - Math.floor(((v) * (pmax - pmin)) / range);
			if (p < pmin) p = pmin;
			else if (p > pmax) p = pmax;
		}

		var sum:int=0;
		if (m_ModeCur == m_ModeImport) sum = Math.ceil(v / s) * pmax + m_EditSumAdd;
		else if (m_ModeCur == m_ModeExport) sum = Math.ceil(v / s) * p + m_EditSumAdd;

		var str:String = "";

		if (pmin != pmax) {
			str += Common.Txt.FormHistTradePrice + ": [clr]" + BaseStr.FormatBigInt(p) + "[/clr] ";
		}

		if(v<0) str+=Common.Txt.FormHistTradeSum+": "+Common.Txt.FormHistGoodsCntIndefinitely;
		else if ((!IsDev()) && m_ModeCur == m_ModeImport && sum > EM.m_FormFleetBar.m_FleetMoney && cotl != null && cotl.m_CotlType == Common.CotlTypeUser) str += Common.Txt.FormHistTradeSum + ": <font color='#FF4040'>" + sum.toString() + "</font> cr";
		else str += Common.Txt.FormHistTradeSum + ": [clr]" + BaseStr.FormatBigInt(sum) + "[/clr] cr";

		m_EditSum.htmlText = BaseStr.FormatTag(str);
	}

	private function sendTradeImportAdd():void
	{
		var t:uint = EM.m_FormInput.GetInt(0);
		
		if (TestIsExistItemInTrade(t)) {
			EM.m_FormInput.Show();// .visible = true;
			FormMessageBox.Run(Common.Txt.FormHistTradeItemNoMore,Common.Txt.ButClose);
			return;
		}

//		var v:int=int(m_EditCnt.text);
		var v:int = 0;
//		try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { EM.m_FormInput.Show();/* .visible = true;*/ return; }
		v = Common.CalcExpInt(m_EditCnt.text, 0x7fffffff);
		if (v == 0x7fffffff) { EM.m_FormInput.Show(); return; }

		var s:int = m_EditStep.selectedItem.data;

//		var p:int = int(m_EditPrice.text);
		//try { p = D.evalToInt(m_EditPrice.text); } catch (e:*) { EM.m_FormInput.visible = true; return; }
		
		var pmin:int = EditPrice(0);
		var pmax:int = EditPrice(1);
		var range:int = EditPrice(2);
		var storage:int = EditStorage();
		
		m_ErrOpenInput = true;
		
		Server.Self.QueryHS("emtradeop", "&type=1&id=" + m_CotlId.toString() + "&t=" + t.toString() + "&v=" + v.toString() + "&s=" + s.toString() + "&p=" + pmin.toString() + "&p2=" + pmax.toString() + "&range=" + range.toString() + "&storage=" + storage.toString(), answerTradeOp, false);
	}

	public function answerTradeOp(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int=buf.readUnsignedByte();
		if(err==Server.ErrorNoEnoughMoney) { EM.m_Info.Hide(); if(m_ErrOpenInput) EM.m_FormInput.Show(); FormMessageBox.Run(Common.Txt.NoEnoughMoney,Common.Txt.ButClose);  }
		else if (err == Server.ErrorNoEnoughRes) { EM.m_Info.Hide(); if (m_ErrOpenInput) EM.m_FormInput.Show(); FormMessageBox.Run(Common.Txt.NoEnoughRes, Common.Txt.ButClose);  }
		else if(err==Server.ErrorNoEnoughEGM) { EM.m_Info.Hide(); if(m_ErrOpenInput) EM.m_FormInput.Show(); FormMessageBox.Run(Common.Txt.NoEnoughEGM2,Common.Txt.ButClose);  }
		else if (err == Server.ErrorOverload) { EM.m_Info.Hide(); if (m_ErrOpenInput) EM.m_FormInput.Show(); FormMessageBox.Run(Common.Txt.ErrOverload, Common.Txt.ButClose);  }
		else if(err==Server.ErrorData) { EM.m_Info.Hide(); if(m_ErrOpenInput) EM.m_FormInput.Show(); FormMessageBox.Run(Common.Txt.ErrData,Common.Txt.ButClose);  }
		else if (err == Server.ErrorNoHomeworld) { EM.m_Info.Hide(); FormMessageBox.Run(Common.Txt.ErrNoHomeworld, Common.Txt.ButClose);  }
		else if (EM.ErrorFromServer(err)) return;
		
		m_ErrOpenInput = false;

		TradeQuery();
	}

	public function clickTradeImportChange(...args):void
	{
		var i:int;
		
		EM.m_Info.Hide(); 
		
		m_EditCnt=null;
		m_EditStep=null;
		m_EditPrice = null;
		m_EditStorage = null;
		m_EditMoney = null;
		m_EditSum=null;
		m_EditSlider=null;

		var obj:Object=m_TradeGrid.selectedItem;

		var v:int=obj.ItemCnt;
		var s:int=obj.Step;
		var p:int=obj.ItemPrice;
		m_EditSumAdd = -obj.Money;// Math.ceil(v / s) * p;

		EM.m_FormInput.Init();

		EM.m_FormInput.AddLabel(Common.Txt.FormHistImportCaption,18);

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsType+": <font color='#ffff00'>"+EM.ItemName(obj.ItemType))+"</font>";

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsCntImport2+":");
		EM.m_FormInput.Col();
		m_EditCnt=EM.m_FormInput.AddInput(obj.ItemCnt.toString(),128,true,Server.LANG_ENG,true);
		m_EditCnt.addEventListener(Event.CHANGE,EditTradeChange);

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsStep+":");
		EM.m_FormInput.Col();
		m_EditStep=EM.m_FormInput.AddComboBox();
		EM.m_FormInput.AddItem("1",1,obj.Step==1);
		EM.m_FormInput.AddItem("10",10,obj.Step==10);
		EM.m_FormInput.AddItem("100",100,obj.Step==100);
		EM.m_FormInput.AddItem("1k",1000,obj.Step==1000);
		EM.m_FormInput.AddItem("10k",10000,obj.Step==10000);
		EM.m_FormInput.AddItem("100k",100000,obj.Step==100000);
		EM.m_FormInput.AddItem("1m",1000000,obj.Step==1000000);
		m_EditStep.addEventListener(Event.CHANGE, EditTradeStepChange);
		
		var str:String = obj.MinPrice.toString();
		if (obj.MinPrice != obj.MaxPrice) {
			str += "; " + obj.MaxPrice.toString();
			if (obj.Range != 0) {
				str += "; " + obj.Range.toString();
			}
		}

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsPrice+":");
		EM.m_FormInput.Col();
		m_EditPrice=EM.m_FormInput.AddInput(str,128,true,Server.LANG_ENG,true);
		m_EditPrice.addEventListener(Event.CHANGE,EditTradeChange)

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsStorage2+":");
		EM.m_FormInput.Col();
		m_EditStorage=EM.m_FormInput.AddInput(obj.Storage.toString(),128,true,Server.LANG_ENG,true);
		m_EditStorage.addEventListener(Event.CHANGE, EditTradeChange)

		m_EditSum=EM.m_FormInput.AddLabel(Common.Txt.FormHistTradeSum+": 0");

		EditTradeStepChange(null);

		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(sendTradeImportChange,Common.Txt.FormHistEdit);
	}
	
	private function sendTradeImportChange():void
	{
		var obj:Object=m_TradeGrid.selectedItem;
		
		var t:uint=obj.ItemType;
		//var v:int=int(m_EditCnt.text);

		var v:int = 0;
		//try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { EM.m_FormInput.Show(); return; }
		v = Common.CalcExpInt(m_EditCnt.text, 0x7fffffff);
		if (v == 0x7fffffff) { EM.m_FormInput.Show(); return; }

		var s:int=m_EditStep.selectedItem.data;

		//var p:int=int(m_EditPrice.text);
//		var p:int = 0;
//		try { p = D.evalToInt(m_EditPrice.text); } catch (e:*) { EM.m_FormInput.visible = true; return; }
		var pmin:int = EditPrice(0);
		var pmax:int = EditPrice(1);
		var range:int = EditPrice(2);
		var storage:int = EditStorage();

		m_ErrOpenInput = true;

		Server.Self.QueryHS("emtradeop", "&type=2&id=" + m_CotlId.toString() + "&rid=" + obj.RecordId.toString() + "&t=" + t.toString() + "&v=" + v.toString() + "&s=" + s.toString() + "&p=" + pmin.toString() + "&p2=" + pmax.toString() + "&range=" + range.toString() + "&storage=" + storage.toString(), answerTradeOp, false);
	}

	public function clickTradeImportDel(...args):void
	{
		var obj:Object = m_TradeGrid.selectedItem;

		m_ErrOpenInput = false;

		Server.Self.QueryHS("emtradeop","&type=3&id="+m_CotlId.toString()+"&rid="+obj.RecordId.toString(),answerTradeOp,false);
	}
	
	public function clickTradeExportAdd(...args):void
	{
		var i:int;
		
		EM.m_Info.Hide(); 
		
		m_EditCnt=null;
		m_EditStep=null;
		m_EditPrice = null;
		m_EditStorage = null;
		m_EditMoney = null;
		m_EditSum=null;
		m_EditSlider=null;
		m_EditSumAdd=0;
		
		EM.m_FormInput.Init();
		
		EM.m_FormInput.AddLabel(Common.Txt.FormHistExportCaption,18);
		
		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsType+":");
		EM.m_FormInput.Col();
		EM.m_FormInput.AddComboBox();
		
		EM.m_FormInput.AddItem(EM.ItemName(Common.ItemTypeFuel),Common.ItemTypeFuel);
		EM.m_FormInput.AddItem(EM.ItemName(Common.ItemTypeModule),Common.ItemTypeModule);
		EM.m_FormInput.AddItem(EM.ItemName(Common.ItemTypeEGM),Common.ItemTypeEGM);
		for (i = 0; i < args.length; i++) {
			if (args[i] is int) {}
			else if (args[i] is uint) {}
			else break;
			
			if (TestIsExistItemInTrade(args[i])) {
				FormMessageBox.Run(Common.Txt.FormHistTradeItemNoMore,Common.Txt.ButClose);
				return;
			}
			
			EM.m_FormInput.AddItem(EM.ItemName(args[i]), args[i], i == 0);
		}

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsCntExport2+":");
		EM.m_FormInput.Col();
		m_EditCnt=EM.m_FormInput.AddInput("0",128,true,Server.LANG_ENG,true);
		m_EditCnt.addEventListener(Event.CHANGE,EditTradeChange);
		
		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsStep+":");
		EM.m_FormInput.Col();
		m_EditStep=EM.m_FormInput.AddComboBox();
		EM.m_FormInput.AddItem("1",1,true);
		EM.m_FormInput.AddItem("10",10);
		EM.m_FormInput.AddItem("100",100);
		EM.m_FormInput.AddItem("1k",1000);
		EM.m_FormInput.AddItem("10k",10000);
		EM.m_FormInput.AddItem("100k",100000);
		EM.m_FormInput.AddItem("1m",1000000);
		m_EditStep.addEventListener(Event.CHANGE,EditTradeStepChange);
		
		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsPrice+":");
		EM.m_FormInput.Col();
		m_EditPrice=EM.m_FormInput.AddInput("1",128,true,Server.LANG_ENG,true);
		m_EditPrice.addEventListener(Event.CHANGE, EditTradeChange)

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsMoney2+":");
		EM.m_FormInput.Col();
		m_EditMoney=EM.m_FormInput.AddInput("0",128,true,Server.LANG_ENG,true);
		m_EditMoney.addEventListener(Event.CHANGE, EditTradeChange)

		m_EditSum=EM.m_FormInput.AddLabel(Common.Txt.FormHistTradeSum+": 0");
		
		EditTradeStepChange(null);
		
		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(sendTradeExportAdd,Common.Txt.FormHistAdd);
	}
	
	private function sendTradeExportAdd():void
	{
		var t:uint = EM.m_FormInput.GetInt(0);

		if (TestIsExistItemInTrade(t)) {
			EM.m_FormInput.Show();
			FormMessageBox.Run(Common.Txt.FormHistTradeItemNoMore,Common.Txt.ButClose);
			return;
		}

//		var v:int = int(m_EditCnt.text);
		var v:int = 0;
		//try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { EM.m_FormInput.Show(); return; }
		v = Common.CalcExpInt(m_EditCnt.text, 0x7fffffff);
		if (v == 0x7fffffff) { EM.m_FormInput.Show(); return; }

		var s:int = m_EditStep.selectedItem.data;

//		var p:int=int(m_EditPrice.text);
//		var p:int = 0;
//		try { p = D.evalToInt(m_EditPrice.text); } catch (e:*) { EM.m_FormInput.visible = true; return; }
		var pmin:int = EditPrice(0);
		var pmax:int = EditPrice(1);
		var range:int = EditPrice(2);
		var money:int = EditMoney();

		m_ErrOpenInput = true;

		Server.Self.QueryHS("emtradeop","&type=4&id="+m_CotlId.toString()+"&t="+t.toString()+"&v="+v.toString()+"&s="+s.toString()+"&p=" + pmin.toString() + "&p2=" + pmax.toString() + "&range=" + range.toString() + "&money=" + money.toString(),answerTradeOp,false);
	}
	
	public function clickTradeExportChange(...args):void
	{
		var i:int;
		
		EM.m_Info.Hide(); 
		
		m_EditCnt=null;
		m_EditStep=null;
		m_EditPrice = null;
		m_EditStorage = null;
		m_EditMoney = null;
		m_EditSum=null;
		m_EditSlider=null;

		var obj:Object=m_TradeGrid.selectedItem;

		m_EditSumAdd=0;

		EM.m_FormInput.Init();

		EM.m_FormInput.AddLabel(Common.Txt.FormHistExportCaption,18);

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsType+": <font color='#ffff00'>"+EM.ItemName(obj.ItemType))+"</font>";

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsCntExport+":");
		EM.m_FormInput.Col();
		m_EditCnt=EM.m_FormInput.AddInput(obj.ItemCnt.toString(),128,true,Server.LANG_ENG,true);
		m_EditCnt.addEventListener(Event.CHANGE,EditTradeChange);

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsStep+":");
		EM.m_FormInput.Col();
		m_EditStep=EM.m_FormInput.AddComboBox();
		EM.m_FormInput.AddItem("1",1,obj.Step==1);
		EM.m_FormInput.AddItem("10",10,obj.Step==10);
		EM.m_FormInput.AddItem("100",100,obj.Step==100);
		EM.m_FormInput.AddItem("1k",1000,obj.Step==1000);
		EM.m_FormInput.AddItem("10k",10000,obj.Step==10000);
		EM.m_FormInput.AddItem("100k",100000,obj.Step==100000);
		EM.m_FormInput.AddItem("1m",1000000,obj.Step==1000000);
		m_EditStep.addEventListener(Event.CHANGE,EditTradeStepChange);

		var str:String = obj.MinPrice.toString();
		if (obj.MinPrice != obj.MaxPrice) {
			str += "; " + obj.MaxPrice.toString();
			if (obj.Range != 0) {
				str += "; " + obj.Range.toString();
			}
		}

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsPrice + ":");
		EM.m_FormInput.Col();
		m_EditPrice = EM.m_FormInput.AddInput(str, 128, true, Server.LANG_ENG, true);
		m_EditPrice.addEventListener(Event.CHANGE, EditTradeChange)

		EM.m_FormInput.AddLabel(Common.Txt.FormHistGoodsMoney2 + ":");
		EM.m_FormInput.Col();
		m_EditMoney = EM.m_FormInput.AddInput(obj.Money.toString(), 128, true, Server.LANG_ENG, true);
		m_EditMoney.addEventListener(Event.CHANGE, EditTradeChange)

		m_EditSum=EM.m_FormInput.AddLabel(Common.Txt.FormHistTradeSum+": 0");

		EditTradeStepChange(null);

		EM.m_FormInput.ColAlign();
		EM.m_FormInput.Run(sendTradeExportChange,Common.Txt.FormHistEdit);
	}
	
	private function sendTradeExportChange():void
	{
		var obj:Object=m_TradeGrid.selectedItem;

		var t:uint = obj.ItemType;

//		var v:int=int(m_EditCnt.text);
		var v:int = 0;
		//try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { EM.m_FormInput.Show(); return; }
		v = Common.CalcExpInt(m_EditCnt.text, 0x7fffffff);
		if (v == 0x7fffffff) { EM.m_FormInput.Show(); return; }

		var s:int = m_EditStep.selectedItem.data;

//		var p:int=int(m_EditPrice.text);
//		var p:int = 0;
//		try { p = D.evalToInt(m_EditPrice.text); } catch (e:*) { EM.m_FormInput.visible = true; return; }
		var pmin:int = EditPrice(0);
		var pmax:int = EditPrice(1);
		var range:int = EditPrice(2);
		var money:int = EditMoney();

		m_ErrOpenInput = true;

		Server.Self.QueryHS("emtradeop", "&type=5&id=" + m_CotlId.toString() + "&rid=" + obj.RecordId.toString() + "&t=" + t.toString() + "&v=" + v.toString() + "&s=" + s.toString() + "&p=" + pmin.toString() + "&p2=" + pmax.toString() + "&range=" + range.toString() + "&money=" + money.toString(), answerTradeOp, false);
	}

	public function clickTradeExportDel(...args):void
	{
		var obj:Object = m_TradeGrid.selectedItem;

		m_ErrOpenInput = false;

		Server.Self.QueryHS("emtradeop","&type=6&id="+m_CotlId.toString()+"&rid="+obj.RecordId.toString(),answerTradeOp,false);
	}

	public function TradeActionUpdate(e:Event=null):void
	{
		EM.m_FormInput.Hide();
		FormMessageBox.Self.Hide();// visible = false;
		
		m_ButAction.visible=false;
		if(m_TradeGrid.length<=0) return;
		if(m_TradeGrid.selectedIndex<0 || m_TradeGrid.selectedIndex>=m_TradeGrid.length) return;
		var obj:Object=m_TradeGrid.selectedItem;
		if(obj==null) return;
		if(obj.ItemCnt==0) return;
		
		m_ButAction.visible=true;
	}

	public function clickAction(e:Event=null):void
	{
		m_EditCnt=null;
		m_EditSum = null;
		
		EM.m_Info.Hide(); 
		
//		if(IsDev()) { EM.m_FormHint.Show(Common.Txt.WarningCotlOpNoAccessIsDev,Common.WarningHideTime); return; }
		
		if(m_TradeGrid.length<=0) return;
		if(m_TradeGrid.selectedIndex<0 || m_TradeGrid.selectedIndex>=m_TradeGrid.length) return;
		var obj:Object=m_TradeGrid.selectedItem;
		if(obj==null) return;
		if (obj.ItemCnt == 0) return;

		var cant:Boolean = false;
		if (m_ModeCur == m_ModeImport) {
			//sell
            if (!EmpireMap.Self.CanTransfer(obj.Owner, Server.Self.m_UserId)) { }
            else if (obj.ItemPrice > 0 && !EmpireMap.Self.CanTransfer(Server.Self.m_UserId, obj.Owner)) { }
			else cant = true;
		} else {
			//buy
            if(!EmpireMap.Self.CanTransfer(Server.Self.m_UserId,obj.Owner)) { }
            else if (obj.ItemPrice > 0 && !EmpireMap.Self.CanTransfer(obj.Owner, Server.Self.m_UserId)) { }
			else cant = true;
		} 
		if (!cant) {
			FormMessageBox.RunErr(Common.Txt.WarningItemNoAccessOpByRank);
			return;
		}

		//var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);
		//if(cotl==null) return;
		if (!EM.OnOrbitCotl(m_CotlId)) { EM.m_FormHint.Show(Common.Txt.WarningFleetFarEx, Common.WarningHideTime); return; }
		
		EM.m_FormInput.Init();

		if(m_ModeCur==m_ModeImport)	EM.m_FormInput.AddLabel(Common.Txt.FormHistSell+": <font color='#ffff00'>"+EM.ItemName(obj.ItemType)+"</font>",18);
		else EM.m_FormInput.AddLabel(Common.Txt.FormHistBuy+": <font color='#ffff00'>"+EM.ItemName(obj.ItemType)+"</font>",18);

		EM.m_FormInput.AddLabel(Common.Txt.Count + ":");
		EM.m_FormInput.Col();
		m_EditCnt = EM.m_FormInput.AddInput("0", 128, true, Server.LANG_ENG, true);
		m_EditCnt.addEventListener(Event.CHANGE, actionEditChange);

		if (obj.ItemCnt < 0) m_EditSlider = EM.m_FormInput.AddSlider(0, 0, Math.min(1000000000, obj.Step * 10000));
		else m_EditSlider = EM.m_FormInput.AddSlider(0, 0, obj.ItemCnt);
		m_EditSlider.addEventListener(Event.CHANGE,actionSliderChange);
		m_EditSlider.addEventListener(SliderEvent.THUMB_DRAG,actionSliderChangeDrag);

		m_EditSum=EM.m_FormInput.AddLabel(Common.Txt.FormHistTradeSum+": 0");
		
		actionEditChangeTakt();
		actionChange();

		EM.m_FormInput.ColAlign();
		if(m_ModeCur==m_ModeImport) EM.m_FormInput.Run(sendAction,Common.Txt.FormHistSell);
		else EM.m_FormInput.Run(sendAction,Common.Txt.FormHistBuy);
	}
	
	public function actionEditChange(e:Event=null):void
	{
		m_EditActionTimer.stop();
		m_EditActionTimer.start();
		actionChange();
	}
	
	public function actionSliderChangeDrag(e:SliderEvent):void
	{
		m_EditCnt.text=e.value.toString();
		actionEditChangeTakt(null);
	}
	
	public function actionSliderChange(e:Event=null):void
	{
		m_EditCnt.text=m_EditSlider.value.toString();
		actionEditChangeTakt(null);
	}
	
	public function actionEditChangeTakt(event:Event=null):void
	{
		if(m_EditCnt==null) return;
		if(m_EditSum==null) return;
		if(m_EditSlider==null) return;

		var obj:Object=m_TradeGrid.selectedItem;
		if(obj==null) return;

		var sum:int;

//		var v:int=int(m_EditCnt.text);
		var v:int = 0;
		//try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { v = int(m_EditCnt.text); }
		v = Common.CalcExpInt(m_EditCnt.text, int(m_EditCnt.text));

		if(v<0) v=0;

		v=Math.ceil(v/obj.Step);
		
		while(obj.ItemPrice>0) {
			sum=v*obj.ItemPrice;
			if (m_ModeCur == m_ModeExport)	sum = sum + Math.ceil(sum / 100) * Common.TradeNalog;
			else sum = sum - Math.ceil(sum / 100) * Common.TradeNalog;
			if(sum<=0) { v=0; break; }
			if (m_ModeCur == m_ModeImport) break;
			if (sum <= EM.m_FormFleetBar.m_FleetMoney) break;

			if(sum>1000 && sum>(EM.m_FormFleetBar.m_FleetMoney*2)) v=v>>1;
			else v--;
		}

		v*=obj.Step;

		if(v<0) v=0;
		else if(obj.ItemCnt>=0 && v>obj.ItemCnt) v=obj.ItemCnt;
		
		if(m_ModeCur==m_ModeImport) {
			var maxv:int=0;
/*			if(obj.ItemType==Common.ItemTypeAntimatter ||
				obj.ItemType==Common.ItemTypeMetal ||
				obj.ItemType==Common.ItemTypeElectronics ||
				obj.ItemType==Common.ItemTypeProtoplasm ||
				obj.ItemType==Common.ItemTypeNodes ||
				obj.ItemType==Common.ItemTypeArmour ||
				obj.ItemType==Common.ItemTypeArmour2 ||
				obj.ItemType==Common.ItemTypePower ||
				obj.ItemType==Common.ItemTypePower2 ||
				obj.ItemType==Common.ItemTypeRepair ||
				obj.ItemType==Common.ItemTypeRepair2
			) maxv=EM.m_UserRes[obj.ItemType];*/
			//if (obj.ItemType == Common.ItemTypeFuel) maxv = 0;// EM.m_FormFleetBar.m_FleetFuel;
			//else if (obj.ItemType == Common.ItemTypeModule) maxv = 0;// EM.m_FormFleetBar.m_FleetModule;
			//else

			if (obj.ItemType == Common.ItemTypeEGM) maxv = EM.m_UserEGM;
			else maxv = EM.m_FormFleetBar.FleetSysItemGet(uint(obj.ItemType));
			
			var idesc:Item = UserList.Self.GetItem(uint(obj.ItemType) & 0xffff);
			if (idesc == null) maxv = 0;
			else if (maxv > (idesc.m_StackMax * TradeStorageMul - obj.Storage)) maxv = Math.max(idesc.m_StackMax * TradeStorageMul - obj.Storage, 0);

			if(v>maxv) {
				v=maxv;
				v=Math.ceil(v/obj.Step)*obj.Step;
				if(v>maxv) {
					v=(Math.ceil(v/obj.Step)-1)*obj.Step;
				}
				if(v<0) v=0;
			}
		}
		
		if(m_EditCnt.text!=v.toString()) {
			var sstart:Boolean=m_EditCnt.selectionBeginIndex==0;
			var send:Boolean=m_EditCnt.selectionEndIndex==m_EditCnt.text.length;
				
			m_EditCnt.text=v.toString();
			
			if(sstart && send) m_EditCnt.setSelection(0,m_EditCnt.text.length);
			else if(sstart) m_EditCnt.setSelection(0,0);
			else m_EditCnt.setSelection(m_EditCnt.text.length,m_EditCnt.text.length);
		}
		actionChange();
	}
	
	public function actionChange(e:Event=null):void
	{
		var obj:Object=m_TradeGrid.selectedItem;

		var sum:int;
		
//		var v:int=int(m_EditCnt.text);
		var v:int = 0;
		//try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { v = int(m_EditCnt.text); }
		v = Common.CalcExpInt(m_EditCnt.text, int(m_EditCnt.text));

		if(v<0) v=0;

		v=Math.ceil(v/obj.Step);
		sum=v*obj.ItemPrice;
		if(m_ModeCur==m_ModeExport)	sum=sum+Math.ceil(sum/100)*Common.TradeNalog;
		else sum=sum-Math.ceil(sum/100)*Common.TradeNalog;
		if(sum<0) sum=0;

		m_EditSlider.value=v*obj.Step;

		var str:String=BaseStr.FormatBigInt(sum);
		if(m_ModeCur==m_ModeExport && sum>EM.m_FormFleetBar.m_FleetMoney) str="<font color='#ff4040'>"+str+"</font>"
		m_EditSum.htmlText=Common.Txt.FormHistTradeSum+": "+str+" cr.";
	}
	
	public function sendAction():void
	{
		actionEditChangeTakt();

		var obj:Object=m_TradeGrid.selectedItem;

		//var v:int=int(m_EditCnt.text);
		var v:int = 0;
		//try { v = D.evalToInt(m_EditCnt.text); } catch (e:*) { EM.m_FormInput.Show(); return; }
		v = Common.CalcExpInt(m_EditCnt.text, 0x7fffffff);
		if (v == 0x7fffffff) { EM.m_FormInput.Show(); return; }

		var s:int=obj.Step;
		var t:uint=obj.ItemType;
		var p:int=obj.ItemPrice;

		if (v<=0 || v>1000000000) return;

		var str:String="";
		if(m_ModeCur==m_ModeImport) str+="&type=7";
		else str+="&type=8";

		m_ErrOpenInput = true;

		Server.Self.QueryHS("emtradeop",str+"&id="+m_CotlId.toString()+"&rid="+obj.RecordId.toString()+"&t="+t.toString()+"&v="+v.toString()+"&s="+s.toString()+"&p="+p.toString(),answerTradeOp,false);
	}
	
	public static function FindKeyWord(s:String):int
	{
		var i:int,u:int,score:int,bscore:int;
		var ts:String;

		var kw:int = 0;
		bscore = 0;

		for (i = 0; i < Common.FindKeyWord.length; i+=2) {
			ts = Common.FindKeyWord[i];
			
			score = 0;
			for (u = 0; u < Math.min(ts.length, s.length); u++) {
				if (s.charCodeAt(u) != ts.charCodeAt(u)) break;
				score++;
			}
			
			if (score <= 0) continue;
			
			if (s.length == ts.length) score++;
			
			if (kw == 0 || score > bscore) {
				bscore = score;
				kw=Common.FindKeyWord[i+1];
			}
		}

		return kw;
	}
	
	public static function StrToItemType(src:String):uint
	{
		if (src == null || src.length <= 0) return 0;
		
		var len:int = src.length;
		var off:int = 0;
		var begin:int, ch:int;
		var w:String;
		var kw:uint;
		
		var p_goodstype:uint = 0;
		var state:uint = 0;
		
		while (off < len) {
			// Space
			while(off<len) {
				ch = src.charCodeAt(off);
				if (ch == 32 || ch == 9) {}
				else break;
				off++;
			}
			if (off >= len) break;
			
			// Word
			begin = off;
			while (off < len) {
				ch = src.charCodeAt(off);
				if (ch != 32 && ch != 9) { }
				else break;
				off++;
			}

			if(begin<off) {
				w = src.substr(begin, off - begin);

				kw = FindKeyWord(w);

				if (kw == Common.kwModule) p_goodstype = Common.ItemTypeModule;
				else if (kw == Common.kwArmour) { p_goodstype = Common.ItemTypeArmour; state = kw; }
				else if (kw == Common.kwPower) { p_goodstype = Common.ItemTypePower; state = kw; }
				else if (kw == Common.kwRepair){  p_goodstype = Common.ItemTypeRepair; state = kw; }
				else if (kw == Common.kwFuel) p_goodstype = Common.ItemTypeFuel;
				else if (kw == Common.kwMonuk) p_goodstype = Common.ItemTypeMonuk;
				else if (kw == Common.kwAntimatter) p_goodstype = Common.ItemTypeAntimatter;
				else if (kw == Common.kwMetal) p_goodstype = Common.ItemTypeMetal;
				else if (kw == Common.kwElectronics) p_goodstype = Common.ItemTypeElectronics;
				else if (kw == Common.kwProtoplasm) p_goodstype = Common.ItemTypeProtoplasm;
				else if (kw == Common.kwNodes) p_goodstype = Common.ItemTypeNodes;
				else if (kw == Common.kwMine) p_goodstype = Common.ItemTypeMine;
				else if (kw == Common.kwEGM) p_goodstype = Common.ItemTypeEGM;

				else if (kw == Common.kwTitan) p_goodstype = Common.ItemTypeTitan;
				else if (kw == Common.kwSilicon) p_goodstype = Common.ItemTypeSilicon;
				else if (kw == Common.kwCrystal) p_goodstype = Common.ItemTypeCrystal;
				else if (kw == Common.kwXenon) p_goodstype = Common.ItemTypeXenon;
				else if (kw == Common.kwHydrogen) p_goodstype = Common.ItemTypeHydrogen;
				else if (kw == Common.kwFood) p_goodstype = Common.ItemTypeFood;
				else if (kw == Common.kwPlasma) p_goodstype = Common.ItemTypePlasma;
				else if (kw == Common.kwMachinery) p_goodstype = Common.ItemTypeMachinery;
				else if (kw == Common.kwEngineer) p_goodstype = Common.ItemTypeEngineer;
				else if (kw == Common.kwTechnician) p_goodstype = Common.ItemTypeTechnician;
				else if (kw == Common.kwNavigator) p_goodstype = Common.ItemTypeNavigator;
				else if (kw == Common.kwQuarkCore) p_goodstype = Common.ItemTypeQuarkCore;
				
				else if (kw == Common.kwTwo) {
					if (state == Common.kwArmour) p_goodstype = Common.ItemTypeArmour2;
					else if (state == Common.kwPower) p_goodstype = Common.ItemTypePower2;
					else if (state == Common.kwRepair) p_goodstype = Common.ItemTypeRepair2;
				}
			}
		}

		return p_goodstype;
	}
	
	public function FindCotlDefault(name:String):uint
	{
		return EM.TxtFind(EM.m_Txt, 1, name);
	}
	
	public function FindUser(name:String):uint
	{
		//return FormChat.Self.UserIdByName(name);
		var u:User = UserList.Self.FindUser(name);
		if (u == null) return 0;
		return u.m_Id;
	}
	
	public static function kwIsGoods(kw:int):Boolean
	{
		if (kw >= 100 && kw <= 124) return true;
		return false;
	}

	public function clickFind(e:Event):void
	{
		// созвездие СТАЛКЕР 159
		// созвездие 000 DIMAN 000
		// созвездие Рыжая Борода
		var dw:uint;
		var src:String = m_FindQuery.text;
		var off:int = 0;
		var len:int = src.length;
		var ch:int;
		var v:Number, vp:Number, m_ButAction:Number;
		var vok:Boolean, vok2:Boolean;
		var f:Boolean;
		var w:String;
		var begin:int;
		var kw:int;
		var findstr:String = "";
		
		//var p_w:String = "";
		var p_goodsdir:int = -1; // 0-import 1-export
		var p_goodstype:int = Common.ItemTypeNone;
		var p_goodsstepmin:int = -1;
		var p_goodsstepmax:int = -1;
		var p_pricemin:int = -1;
		var p_pricemax:int = -1;
		var p_spacemin:int = -1;
		var p_spacemax:int = -1;
		var p_cotlid:uint = 0;
		var p_userid:uint = 0;
		
		var state:int = 0;
		var state2:int = 0;
		var period:Boolean = false;

		while (off < len) {
			// Space
			while(off<len) {
				ch = src.charCodeAt(off);
				if (ch == 32 || ch == 9) {}
				else break;
				off++;
			}
			
			// Value
			v = 0;
			vp = 0;
			vok = false;
			while(state!=Common.kwCotl && !kwIsGoods(state)) {
				begin = off;
				vok2 = false;
				while(off<len) {
					ch = src.charCodeAt(off);
					if (ch >= 48 && ch <= 57) { vp = vp * 10 + (ch - 48); vok2 = true; }
					else break;
					off++;
				}
				// Space
				f = false;
				while(off<len) {
					ch = src.charCodeAt(off);
					if (ch == 32 || ch == 9) f = true;
					else break;
					off++;
				}
				
				if (off >= len) {
					if (vok2) { vok = true; v = vp; }
					break;
				}
				ch = src.charCodeAt(off);
				if ((ch >= 48 && ch <= 57) || f || ch==46) { // .=46
					if(vok2) {
						vok = true;
						v = vp;
					}
					//if (!f) break;
					if (ch >= 48 && ch <= 57) continue;
					break;
				}

				off = begin;
				break;
			}
			if (vok) {
				if (state == Common.kwPrice) {
					if (state2 == Common.kwAt && period) p_goodsstepmax = v;
					else if (state2 == Common.kwAt) p_goodsstepmin = v;
					else if (period) p_pricemax = v;
					else p_pricemin = v;

				} else if(state == Common.kwSpace) {
					if (period) p_spacemax = v;
					else p_spacemin = v;
				}
			}

			// Space
			while(off<len) {
				ch = src.charCodeAt(off);
				if (ch == 32 || ch == 9) {}
				else break;
				off++;
			}

			// Word
			w = "";
			begin = off;
			if (off < len && src.charCodeAt(off) == 46) { // .
				while(off<len) {
					ch = src.charCodeAt(off);
					if (ch == 46) {}
					else break;
					off++;
				}
			} else {
				while (off < len) {
					ch = src.charCodeAt(off);
					if (ch != 32 && ch != 9) { }
					else break;
					off++;
				}
			}

			if (state == Common.kwCotl && off > begin) {
				if (findstr.length > 0) findstr += " ";
				findstr += src.substr(begin, off - begin);

				var ff:Boolean = false;

				dw = FindCotlDefault(findstr);
				if (dw != 0) { p_cotlid = dw; ff = true; }
				dw = FindUser(findstr);
				if (dw != 0) { p_userid = dw; ff = true; }

				if (ff) continue;
				//else state = 0; нельяза так как имя может состоять из нескольких слов
			}
			if (off > begin) {
				w = src.substr(begin, off - begin);

				kw = FindKeyWord(w);

				if (kw == 0) { }
				else if (kw == Common.kwImport) p_goodsdir = 0;
				else if (kw == Common.kwExport) p_goodsdir = 1;
				else if (kw == Common.kwModule) p_goodstype = Common.ItemTypeModule;
				else if (kw == Common.kwArmour) { p_goodstype = Common.ItemTypeArmour; state = kw; }
				else if (kw == Common.kwPower) { p_goodstype = Common.ItemTypePower; state = kw; }
				else if (kw == Common.kwRepair){  p_goodstype = Common.ItemTypeRepair; state = kw; }
				else if (kw == Common.kwFuel) p_goodstype = Common.ItemTypeFuel;
				else if (kw == Common.kwMonuk) p_goodstype = Common.ItemTypeMonuk;
				else if (kw == Common.kwAntimatter) p_goodstype = Common.ItemTypeAntimatter;
				else if (kw == Common.kwMetal) p_goodstype = Common.ItemTypeMetal;
				else if (kw == Common.kwElectronics) p_goodstype = Common.ItemTypeElectronics;
				else if (kw == Common.kwProtoplasm) p_goodstype = Common.ItemTypeProtoplasm;
				else if (kw == Common.kwNodes) p_goodstype = Common.ItemTypeNodes;
				else if (kw == Common.kwMine) p_goodstype = Common.ItemTypeMine;
				else if (kw == Common.kwEGM) p_goodstype = Common.ItemTypeEGM;

				else if (kw == Common.kwTitan) p_goodstype = Common.ItemTypeTitan;
				else if (kw == Common.kwSilicon) p_goodstype = Common.ItemTypeSilicon;
				else if (kw == Common.kwCrystal) p_goodstype = Common.ItemTypeCrystal;
				else if (kw == Common.kwXenon) p_goodstype = Common.ItemTypeXenon;
				else if (kw == Common.kwHydrogen) p_goodstype = Common.ItemTypeHydrogen;
				else if (kw == Common.kwFood) p_goodstype = Common.ItemTypeFood;
				else if (kw == Common.kwPlasma) p_goodstype = Common.ItemTypePlasma;
				else if (kw == Common.kwMachinery) p_goodstype = Common.ItemTypeMachinery;
				else if (kw == Common.kwEngineer) p_goodstype = Common.ItemTypeEngineer;
				else if (kw == Common.kwTechnician) p_goodstype = Common.ItemTypeTechnician;
				else if (kw == Common.kwNavigator) p_goodstype = Common.ItemTypeNavigator;
				else if (kw == Common.kwQuarkCore) p_goodstype = Common.ItemTypeQuarkCore;
				
				else if (kw == Common.kwTwo) {
					if (state == Common.kwArmour) p_goodstype = Common.ItemTypeArmour2;
					else if (state == Common.kwPower) p_goodstype = Common.ItemTypePower2;
					else if (state == Common.kwRepair) p_goodstype = Common.ItemTypeRepair2;
				}
				
				else if (kw == Common.kwCotl) { state = kw; state2 = 0; period = false; findstr = ""; }

				else if (kw == Common.kwPrice) { state = kw; state2 = 0; period = false; }
				else if (kw == Common.kwSpace) { state = kw; state2 = 0; period = false; }
				else if (kw == Common.kwAt) { state2 = kw; period = false; }
				else if (kw == Common.kwPeriod) {
					period = true;
					if(state == Common.kwPrice && state2==Common.kwAt) p_goodsstepmax = -2;
					else if (state == Common.kwPrice) p_pricemax = -2;
					else if (state == Common.kwSpace) p_spacemax = -2;
				}
			}
		}

		if ((p_goodsdir >= 0) && (p_goodstype != Common.ItemTypeNone || p_cotlid != 0 || p_userid != 0)) {
			src = "&val=" + 
				p_goodsdir.toString() + "_" + 
				p_goodstype.toString() + "_" +
				p_spacemin.toString() + "_" +
				p_spacemax.toString() + "_" +
				p_goodsstepmin.toString() + "_" +
				p_goodsstepmax.toString() + "_" +
				p_pricemin.toString() + "_" +
				p_pricemax.toString();

			src += "_" + p_cotlid.toString();
			src += "_" + p_userid.toString();
//trace(src);

			Server.Self.Query("emfind", "&cotlid=" + m_CotlId.toString() + "&type=1" + src, FindRecv, false);
		} else if (p_cotlid != 0 || p_userid != 0) {
			src = "&val=" + 
				p_cotlid.toString() + "_" +
				p_userid.toString();

			Server.Self.Query("emfind", "&cotlid=" + m_CotlId.toString() + "&type=2" + src, FindRecv, false);
		} else {
			m_FindCotlId = 0;
			m_FindLabel.visible = true;
			m_FindLabel.htmlText = "<font color='#ffff00'>"+Common.Txt.FindError +"</font>\n\n" + Common.Txt.FindHelp;
			m_FindGrid.visible = false;
		}
	}
	
	private function FindRecv(event:Event):void
	{
		var col:DataGridColumn;
		var accountid:uint;
		var cx:int;
		var cy:int;
		var dist:int;
		var obj:Object;
		var inview:Boolean;
		var ax:Number, ay:Number;
		
		var loader:URLLoader = URLLoader(event.target);
		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint = buf.readUnsignedByte();
		if (err == Server.ErrorNotFound) {
			m_FindCotlId = 0;
			m_FindLabel.visible = true;
			m_FindLabel.htmlText = "<font color='#ffff00'>"+Common.Txt.FindNotFound +"</font>\n\n" + Common.Txt.FindHelp;
			m_FindGrid.visible = false;
			return;
		}
		else if (err == Server.ErrorNoEnoughMoney) {
			m_FindCotlId = 0;
			m_FindLabel.visible = true;
			m_FindLabel.htmlText = "<font color='#ffff00'>"+Common.Txt.NoEnoughMoney +"</font>\n\n" + Common.Txt.FindHelp;
			m_FindGrid.visible = false;
			return;
		}
		else if (EM.ErrorFromServer(err)) return;

		var cotl_from:SpaceCotl=EM.HS.GetCotl(m_CotlId);
		if (cotl_from == null) return;

		var type:int = buf.readUnsignedByte();
		var cotlid:uint = buf.readUnsignedInt();

		m_FindCotlId = cotlid;

		m_FindLabel.visible = false;
		m_FindGrid.visible = true;

		m_FindGrid.removeAll();
		m_FindGrid.removeAllColumns();
		//m_FindGrid.sortableColumns=false;

		if (type == 1) {
			var dir:int = buf.readUnsignedByte();
			var goodstype:int = buf.readUnsignedInt();
			
			col = new DataGridColumn("CotlName");
				col.headerText = Common.Txt.FormHistGoodsCotl;
				col.sortable = false;
				m_FindGrid.addColumn(col);
			col = new DataGridColumn("Dist");
				col.headerText = Common.Txt.FormHistGoodsDist;
				col.width = 50;
				col.sortable = false;
				m_FindGrid.addColumn(col);
				
			col = new DataGridColumn("ItemName");
				col.headerText = Common.Txt.FormHistGoodsName;
				col.width = 120;
				col.sortable = false;
				m_FindGrid.addColumn(col);
			//col = new DataGridColumn("Cnt"); if (dir == 0) col.headerText = Common.Txt.FormHistGoodsCntImport; else col.headerText = Common.Txt.FormHistGoodsCntExport; col.width = 140; m_FindGrid.addColumn(col);
			
			col = new DataGridColumn("Cnt");
				col.headerText = Common.Txt.FormHistGoodsCnt;
				col.width = 80;
				col.sortable = false;
				m_FindGrid.addColumn(col);
			col = new DataGridColumn("StepTxt");
				col.headerText = Common.Txt.FormHistGoodsStep;
				col.width = 40;
				col.sortable = false;
				m_FindGrid.addColumn(col);
			
			col = new DataGridColumn("Price");
				col.headerText = Common.Txt.FormHistGoodsPrice;
				col.width = 70;
				col.sortable = false;
				//col.sortCompareFunction = SortPrice;
				//if (dir == 0) col.sortOptions = Array.NUMERIC | Array.DESCENDING;
				//else col.sortOptions = Array.NUMERIC;
				//if (dir == 0) col.sortCompareFunction = SortImportPrice;
				//else col.sortCompareFunction = SortExportPrice;
				m_FindGrid.addColumn(col);
			m_FindGrid.minColumnWidth = 30;
			//m_FindGrid.sortableColumns=true;
			//m_FindGrid.sortIndex = 5;
			
			//var dp:DataProvider = new DataProvider();

			while (true) {
				cotlid = buf.readUnsignedInt();
				if (cotlid == 0) break;

				accountid = buf.readUnsignedInt();
				//var dist:int = Math.floor(buf.readUnsignedInt() * 100 / EM.m_Hyperspace.m_ZoneSize);
				inview = buf.readUnsignedByte() != 0;
				if(inview) {
					cx = buf.readInt();
					cy = buf.readInt();
				} else {
					cx = 0;
					cy = 0;
				}
				var goodstype2:uint = buf.readUnsignedInt();
				var cnt:int = buf.readInt();
				var step:int = buf.readInt();
				var price:int = buf.readInt();

				obj = new Object();
				m_FindGrid.addItem(obj);
				//dp.addItem(obj);

				obj.CotlName = "";
				obj.CotlId = cotlid;
				obj.AccountId = accountid;
				if (inview) {
					ax = cx - (cotl_from.m_ZoneX * EM.HS.SP.m_ZoneSize + cotl_from.m_PosX);
					ay = cy - (cotl_from.m_ZoneY * EM.HS.SP.m_ZoneSize + cotl_from.m_PosY);
					obj.Dist = Math.round(Math.sqrt(ax * ax + ay * ay) / EM.HS.SP.m_ZoneSize);
				} else {
					obj.Dist = "-";
				}
				obj.ItemName = EM.ItemName(goodstype2);
				obj.ItemCnt = cnt;
				obj.ItemPrice = price;
				obj.InView = inview;
				obj.CX = cx;
				obj.CY = cy;

				if(cnt<0) {
					obj.Cnt=Common.Txt.FormHistGoodsCntIndefinitely;

				} else {
					obj.Cnt=BaseStr.FormatBigInt(cnt);

					if(step==10 && obj.Cnt.length>1) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-1)+"'"+obj.Cnt.substr(obj.Cnt.length-1,1);
					else if(step==100 && obj.Cnt.length>2) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-2)+"'"+obj.Cnt.substr(obj.Cnt.length-2,2);
					else if(step==1000 && obj.Cnt.length>3) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-3-1)+"'"+obj.Cnt.substr(obj.Cnt.length-3,3);
					else if(step==10000 && obj.Cnt.length>5) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-5)+"'"+obj.Cnt.substr(obj.Cnt.length-5,5);
					else if(step==100000 && obj.Cnt.length>6) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-6)+"'"+obj.Cnt.substr(obj.Cnt.length-6,6);
					else if(step==1000000 && obj.Cnt.length>7) obj.Cnt=obj.Cnt.substr(0,obj.Cnt.length-7-1)+"'"+obj.Cnt.substr(obj.Cnt.length-7,7);
				}

				obj.Step = step;
				if (step == 1) obj.StepTxt = "1";
				else if (step == 10) obj.StepTxt = "10";
				else if (step == 100) obj.StepTxt = "100";
				else if (step == 1000) obj.StepTxt = "1k";
				else if (step == 10000) obj.StepTxt = "10k";
				else if (step == 100000) obj.StepTxt = "100k";
				else if (step == 1000000) obj.StepTxt = "1m";
				else obj.StepTxt = step.toString();

				obj.Price = BaseStr.FormatBigInt(price);
			}

			if ( dir == 0) m_FindGrid.sortItems(SortImportPrice, Array.NUMERIC);
			else m_FindGrid.sortItems(SortExportPrice, Array.NUMERIC);
			
			//if (dir == 0) m_FindGrid.sortItemsOn("Price",Array.NUMERIC);// , Array.NUMERIC | Array.DESCENDING)
			//else m_FindGrid.sortItemsOn("Price", Array.NUMERIC);// , Array.NUMERIC | Array.)

			//dp.sortOn("Price");
			//m_FindGrid.dataProvider = dp;
			
		} else if (type == 2) {

			col = new DataGridColumn("CotlName"); col.headerText = Common.Txt.FormHistGoodsCotl; m_FindGrid.addColumn(col);
			col = new DataGridColumn("Dist"); col.headerText = Common.Txt.FormHistGoodsDist; col.width = 100; m_FindGrid.addColumn(col);
			m_FindGrid.minColumnWidth = 30;

			while (true) {
				cotlid = buf.readUnsignedInt();
				if (cotlid == 0) break;

				accountid = buf.readUnsignedInt();
				inview = buf.readUnsignedByte() != 0;
				if(inview) {
					cx = buf.readInt();
					cy = buf.readInt();
				} else {
					cx = 0;
					cy = 0;
				}
				
				obj = new Object();
				m_FindGrid.addItem(obj);

				obj.CotlName = "";
				obj.CotlId = cotlid;
				obj.AccountId = accountid;
				if(inview) {
					ax = cx - (cotl_from.m_ZoneX * EM.HS.SP.m_ZoneSize + cotl_from.m_PosX);
					ay = cy - (cotl_from.m_ZoneY * EM.HS.SP.m_ZoneSize + cotl_from.m_PosY);
					obj.Dist = Math.round(Math.sqrt(ax * ax + ay * ay) / EM.HS.m_ZoneSize);
				} else {
					obj.Dist = "-";
				}
				obj.InView = inview;
				obj.CX = cx;
				obj.CY = cy;
			}
				
		}
		FindUpdate();
	}

	public function SortPrice(a:Object, b:Object):int
	{
		var ap:Number = Number(a.ItemPrice) / a.Step;
		var bp:Number = Number(b.ItemPrice) / b.Step;
		if (ap<bp) return -1;
		else if (ap > bp) return 1;
		return 0;
	}

	public function SortImportPrice(a:Object, b:Object):int
	{
		var ap:Number = Number(a.ItemPrice) / a.Step;
		var bp:Number = Number(b.ItemPrice) / b.Step;
		if (ap<bp) return 1;
		else if (ap > bp) return -1;
		return 0;
	}
	
	public function SortExportPrice(a:Object, b:Object):int
	{
		var ap:Number = Number(a.ItemPrice) / a.Step;
		var bp:Number = Number(b.ItemPrice) / b.Step;
		if (ap<bp) return -1;
		else if (ap > bp) return 1;
		return 0;
	}

	private function FindUpdate():void
	{
		var i:int;
		var obj:Object;
		var str:String;
		var cotl:SpaceCotl;
		var user:User;
		
		for (i = 0; i < m_FindGrid.length;i++) {
			obj = m_FindGrid.getItemAt(i);
			
			str = EM.Txt_CotlName(obj.CotlId);
			if (str == '' && obj.AccountId!=0) {
				user = UserList.Self.GetUser(obj.AccountId);
				if (user != null) str = EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
			}
			
			if (obj.CotlName != str) {
				obj.CotlName = str;
				m_FindGrid.invalidateItem(obj);
			}
		}
	}
	
	public function onFindGridItemOver(e:ListEvent):void
	{
		//trace("In:", e.rowIndex);
		var obj:Object;
		
		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;

		var i:int = e.rowIndex as int;
		if (i<0 || i>=m_FindGrid.length) return;

		obj = m_FindGrid.getItemAt(i);
		if (obj.InView) EM.m_FormRadar.ShowLine(obj.CX, obj.CY, cotl.m_ZoneX * EM.HS.SP.m_ZoneSize + cotl.m_PosX, cotl.m_ZoneY * EM.HS.SP.m_ZoneSize + cotl.m_PosY);
	}

	public function onFindGridItemOut(e:ListEvent):void
	{
		EM.m_FormRadar.HideLine();
	}

	private function RecvUser(e:Event):void
	{
		if(m_ModeCur==m_ModeFind) FindUpdate();
	}
	
	// EditCotl
	private function EditCotlBegin(...args):void
	{
		var i:int;
		var str:String;
		var user:User;
		var md:Date;

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);
		if(cotl==null) return;

		FI.Init(480, 520);
		FI.caption = Common.Txt.HyperspaceCotlEditCaption + " " + m_CotlId.toString();

		FI.TabAdd("main");

		if(EM.m_UserAccess & User.AccessGalaxyText) {
			FI.AddLabel(Common.Txt.HyperspaceCotlPfx + ":");
			FI.Col();
			FI.AddInput(EM.Txt_CotlPfx(cotl.m_Id), 32 - 1, true, Server.Self.m_Lang);

			FI.AddLabel(Common.Txt.HyperspaceCotlName + ":");
			FI.Col();
			FI.AddInput(EM.Txt_CotlName(cotl.m_Id), 32 - 1, true, Server.Self.m_Lang);

			FI.AddLabel(Common.Txt.HyperspaceCotlDesc + ":");
			FI.AddCode(EM.Txt_CotlDesc(cotl.m_Id), 512 - 1, true, Server.Self.m_Lang).heightMin = 100;
		}

		if(EM.CotlDevAccess(cotl.m_Id) & SpaceCotl.DevAccessEditMap) {
			FI.AddLabel(Common.Txt.HyperspaceCotlSize + ":");
			FI.Col();
			FI.AddInput(cotl.m_CotlSize.toString(), 5, true, 0);
		}

		FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fDevelopment) != 0, Common.Txt.HyperspaceCotlDevelopment);

		if(EM.m_UserAccess & User.AccessGalaxyOps) {
			FI.Col();
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fTemplate) != 0, Common.Txt.HyperspaceCotlTemplate);
			
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fPortalEnterShip) != 0, Common.Txt.HyperspaceCotlPortalEnterShip);
			FI.Col();
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fPortalEnterFlagship) != 0, Common.Txt.HyperspaceCotlPortalEnterFlagship);
			FI.Col();
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fPortalEnterAllItem) != 0, Common.Txt.HyperspaceCotlPortalEnterAllItem);
		}

		if(EM.m_UserAccess & User.AccessGalaxyAdmin) {
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fBeacon) != 0, Common.Txt.FormHistBeacon);
		}

		if(EM.m_UserAccess & User.AccessGalaxyAdmin) {
			FI.AddLabel(Common.Txt.HyperspaceCotlProtectDate + ":");
			FI.Col();
			if (cotl.m_ProtectTime <= 0) {
				FI.AddInput("0", 19, true, Server.Self.m_Lang);
			} else {
				md = EM.GetServerDate();
				md.setTime(md.getTime() + (cotl.m_ProtectTime-EM.GetServerGlobalTime()));
				FI.AddInput(Common.DateToSysStr(md), 19, true, Server.Self.m_Lang);
			}
		}

		if(EM.m_UserAccess & User.AccessGalaxyOps) {
			FI.TabAdd("bonus");

			// Bonus0
			FI.AddLabel(Common.Txt.HyperspaceCotlBonus+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(" ",0,cotl.m_BonusType0==0);
			for(i=1;i<Common.CotlBonusCnt;i++) {
				FI.AddItem(Common.CotlBonusName[i],i,cotl.m_BonusType0==i);
			}

			FI.AddLabel(" "/*Common.Txt.HyperspaceCotlBonusVal+":"*/);
			FI.Col();
			FI.AddInput(cotl.m_BonusVal0.toString(),5,true,0);

			// Bonus1
			FI.AddLabel(Common.Txt.HyperspaceCotlBonus+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(" ",0,cotl.m_BonusType1==0);
			for(i=1;i<Common.CotlBonusCnt;i++) {
				FI.AddItem(Common.CotlBonusName[i],i,cotl.m_BonusType1==i);
			}
			
			FI.AddLabel(" "/*Common.Txt.HyperspaceCotlBonusVal+":"*/);
			FI.Col();
			FI.AddInput(cotl.m_BonusVal1.toString(),5,true,0);

			// Bonus2
			FI.AddLabel(Common.Txt.HyperspaceCotlBonus+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(" ",0,cotl.m_BonusType2==0);
			for(i=1;i<Common.CotlBonusCnt;i++) {
				FI.AddItem(Common.CotlBonusName[i],i,cotl.m_BonusType2==i);
			}
			
			FI.AddLabel(" "/*Common.Txt.HyperspaceCotlBonusVal+":"*/);
			FI.Col();
			FI.AddInput(cotl.m_BonusVal2.toString(),5,true,0);

			// Bonus3
			FI.AddLabel(Common.Txt.HyperspaceCotlBonus+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(" ",0,cotl.m_BonusType3==0);
			for(i=1;i<Common.CotlBonusCnt;i++) {
				FI.AddItem(Common.CotlBonusName[i],i,cotl.m_BonusType3==i);
			}

			FI.AddLabel(" "/*Common.Txt.HyperspaceCotlBonusVal+":"*/);
			FI.Col();
			FI.AddInput(cotl.m_BonusVal3.toString(), 5, true, 0);
		}

		var da:uint;
		if (EM.CotlDevAccess(cotl.m_Id) & SpaceCotl.DevAccessAssignRights) {
			FI.TabAdd("dev");

			// Dev0
			FI.AddLabel(Common.Txt.HyperspaceCotlDev+" 1:");
			FI.Col();
			str = "";
			if (cotl.m_Dev0 != 0) {
				str += cotl.m_Dev0.toString() + ": ";
				user = UserList.Self.GetUser(cotl.m_Dev0);
				if (user != null) {
					str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				}
			}
			FI.AddInput(str, 128, true, Server.Self.m_Lang);

			da = (cotl.m_DevAccess >> 0) & 0xff;
			FI.AddCheckBox((da & SpaceCotl.DevAccessAssignRights) != 0, Common.Txt.HyperspaceCotlAccessAssignRights);
			FI.AddCheckBox((da & SpaceCotl.DevAccessView) != 0, Common.Txt.HyperspaceCotlAccessView);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditMap) != 0, Common.Txt.HyperspaceCotlAccessEditMap);
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditCode) != 0, Common.Txt.HyperspaceCotlAccessEditCode);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditOps) != 0, Common.Txt.HyperspaceCotlAccessEditOps);

			// Dev1
			FI.AddLabel(Common.Txt.HyperspaceCotlDev+" 2:");
			FI.Col();
			str = "";
			if (cotl.m_Dev1 != 0) {
				str += cotl.m_Dev1.toString() + ": ";
				user = UserList.Self.GetUser(cotl.m_Dev1);
				if (user != null) {
					str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				}
			}
			FI.AddInput(str, 128, true, Server.Self.m_Lang);
			
			da = (cotl.m_DevAccess >> 8) & 0xff;
			FI.AddCheckBox((da & SpaceCotl.DevAccessAssignRights) != 0, Common.Txt.HyperspaceCotlAccessAssignRights);
			FI.AddCheckBox((da & SpaceCotl.DevAccessView) != 0, Common.Txt.HyperspaceCotlAccessView);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditMap) != 0, Common.Txt.HyperspaceCotlAccessEditMap);
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditCode) != 0, Common.Txt.HyperspaceCotlAccessEditCode);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditOps) != 0, Common.Txt.HyperspaceCotlAccessEditOps);

			// Dev2
			FI.AddLabel(Common.Txt.HyperspaceCotlDev+" 3:");
			FI.Col();
			str = "";
			if (cotl.m_Dev2 != 0) {
				str += cotl.m_Dev2.toString() + ": ";
				user = UserList.Self.GetUser(cotl.m_Dev2);
				if (user != null) {
					str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				}
			}
			FI.AddInput(str, 128, true, Server.Self.m_Lang);

			da = (cotl.m_DevAccess >> 16) & 0xff;
			FI.AddCheckBox((da & SpaceCotl.DevAccessAssignRights) != 0, Common.Txt.HyperspaceCotlAccessAssignRights);
			FI.AddCheckBox((da & SpaceCotl.DevAccessView) != 0, Common.Txt.HyperspaceCotlAccessView);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditMap) != 0, Common.Txt.HyperspaceCotlAccessEditMap);
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditCode) != 0, Common.Txt.HyperspaceCotlAccessEditCode);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditOps) != 0, Common.Txt.HyperspaceCotlAccessEditOps);

			// Dev3
			FI.AddLabel(Common.Txt.HyperspaceCotlDev+" 4:");
			FI.Col();
			str = "";
			if (cotl.m_Dev3 != 0) {
				str += cotl.m_Dev3.toString() + ": ";
				user = UserList.Self.GetUser(cotl.m_Dev3);
				if (user != null) {
					str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				}
			}
			FI.AddInput(str, 128, true, Server.Self.m_Lang);

			da = (cotl.m_DevAccess >> 24) & 0xff;
			FI.AddCheckBox((da & SpaceCotl.DevAccessAssignRights) != 0, Common.Txt.HyperspaceCotlAccessAssignRights);
			FI.AddCheckBox((da & SpaceCotl.DevAccessView) != 0, Common.Txt.HyperspaceCotlAccessView);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditMap) != 0, Common.Txt.HyperspaceCotlAccessEditMap);
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditCode) != 0, Common.Txt.HyperspaceCotlAccessEditCode);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditOps) != 0, Common.Txt.HyperspaceCotlAccessEditOps);
		}

		if (EM.m_UserAccess & User.AccessGalaxyAdmin) {		
			FI.TabAdd("dev time");

			FI.AddLabel(Common.Txt.HyperspaceCotlDevTime + ":");
			FI.Col();
			if (cotl.m_DevTime <= 0) {
				FI.AddInput("0", 19, true, Server.Self.m_Lang);
			} else {
				md = EM.GetServerDate();
				md.setTime(md.getTime() + (cotl.m_DevTime-EM.GetServerGlobalTime()));
				FI.AddInput(Common.DateToSysStr(md), 19, true, Server.Self.m_Lang);
			}

			FI.AddLabel(Common.Txt.HyperspaceCotlDevDays + ":");
			FI.Col();
			FI.AddInput((cotl.m_DevFlag & 0xff).toString(), 3, true, 0);
		}

		FI.tab = 0;
		FI.Run(EditCotlSend,StdMap.Txt.ButSave,StdMap.Txt.ButCancel);
	}
	
	private function EditCotlSend():void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;

		var tstr:String;
        var boundary:String = Server.Self.CreateBoundary();

        var d:String = "";
		
		var e:int = 0;

		var flag:uint = 0;

		if(EM.m_UserAccess & User.AccessGalaxyText) {
			tstr=FI.GetStr(e);
			if (tstr != EM.Txt_CotlPfx(cotl.m_Id)) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"pfx\"\r\n\r\n";
				d += tstr + "\r\n";
			}
			e++;

			tstr=FI.GetStr(e);
			if (tstr != EM.Txt_CotlName(cotl.m_Id)) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"name\"\r\n\r\n";
				d += tstr + "\r\n";
			}
			e++;

			tstr=FI.GetStr(e);
			if (tstr != EM.Txt_CotlDesc(cotl.m_Id)) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"desc\"\r\n\r\n";
				d += tstr + "\r\n";
			}
			e++;
		}

		if(EM.CotlDevAccess(cotl.m_Id) & SpaceCotl.DevAccessEditMap) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"size\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
		}
		
		if (FI.GetInt(e) != 0) flag |= SpaceCotl.fDevelopment;
		e++;
		
		if(EM.m_UserAccess & User.AccessGalaxyOps) {
			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fTemplate;
			e++;

			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fPortalEnterShip;
			e++;
			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fPortalEnterFlagship;
			e++;
			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fPortalEnterAllItem;
			e++;
		}

		if(EM.m_UserAccess & User.AccessGalaxyAdmin) {
			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fBeacon;
			e++;
		}

		if(EM.m_UserAccess & User.AccessGalaxyAdmin) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"protectdate\"\r\n\r\n";
			d += FI.GetStr(e).toString() + "\r\n";
			e++;
		}

		if(EM.m_UserAccess & User.AccessGalaxyOps) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b0t\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b0v\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b1t\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b1v\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b2t\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
			
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b2v\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
				
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b3t\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
			
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b3v\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
		}
			
		d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"lang\"\r\n\r\n";
        d += Server.Self.m_Lang.toString() + "\r\n";

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"id\"\r\n\r\n";
        d += m_CotlId.toString() + "\r\n";

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"flag\"\r\n\r\n";
        d += flag.toString(16) + "\r\n";

		if (EM.CotlDevAccess(cotl.m_Id) & SpaceCotl.DevAccessAssignRights) {
			var devaccess:uint = 0;
			var da:uint;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"dev0\"\r\n\r\n";
			d += FI.GetStr(e) + "\r\n";
			e++;

			da = 0;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessAssignRights;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessView;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditMap;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditCode;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditOps;
			devaccess |= da << 0;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"dev1\"\r\n\r\n";
			d += FI.GetStr(e) + "\r\n";
			e++;
			
			da = 0;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessAssignRights;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessView;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditMap;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditCode;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditOps;
			devaccess |= da << 8;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"dev2\"\r\n\r\n";
			d += FI.GetStr(e) + "\r\n";
			e++;
			
			da = 0;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessAssignRights;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessView;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditMap;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditCode;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditOps;
			devaccess |= da << 16;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"dev3\"\r\n\r\n";
			d += FI.GetStr(e) + "\r\n";
			e++;

			da = 0;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessAssignRights;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessView;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditMap;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditCode;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditOps;
			devaccess |= da << 24;

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"devaccess\"\r\n\r\n";
			d += devaccess.toString(16) + "\r\n";
		}

		if (EM.m_UserAccess & User.AccessGalaxyAdmin) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"devtime\"\r\n\r\n";
			d += FI.GetStr(e).toString() + "\r\n";
			e++;

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"devdays\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
		}

        d += "--" + boundary + "--\r\n";

        Server.Self.QueryPost("emedcotladd", "", d, boundary, EditCotlRecv, false);
	}

	private function EditCotlRecv(event:Event):void
	{
        EM.m_TxtTime = Common.GetTime() - 8000;
	}
	
	private function EditCotlDevBuy(...args):void
	{
		var str:String = Common.Txt.HyperspaceCotlDevBuyQuery;
		str = BaseStr.Replace(str, "<Cost>", (Common.CotlDevCost).toString());
		FormMessageBox.Run(str, StdMap.Txt.ButCancel, Common.Txt.HyperspaceCotlDevBuy, EditCotlDevBuySend);
	}
	
	private function EditCotlDevBuySend():void
	{
		if (EM.m_FormFleetBar.m_FleetMoney < Common.CotlDevCost) { FormMessageBox.RunErr(Common.Txt.NoEnoughMoney); return; }
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;
		Server.Self.Query("emedcotlspecial", "&type=21&id=" + cotl.m_Id.toString(), EditCotlDevBuyRecv, false);
	}
	
	private function EditCotlDevBuyContinue(...args):void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;
		var cost:int = Common.CotlDevCost;
		var cnt:int = cotl.m_DevFlag & 0xff; if (cnt < 1) cnt = 1; else if(cnt>8) cnt=8;
		for (var i:int = 0; i < cnt; i++) cost *= 2;

		var str:String = Common.Txt.HyperspaceCotlDevBuyContinueQuery;
		str = BaseStr.Replace(str, "<Cost>", BaseStr.FormatBigInt(cost));
		FormMessageBox.Run(str, StdMap.Txt.ButCancel, Common.Txt.HyperspaceCotlDevBuyContinue, EditCotlDevBuyContinueSend);
	}

	private function EditCotlDevBuyContinueSend():void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;
		var cost:int = Common.CotlDevCost;
		var cnt:int = cotl.m_DevFlag & 0xff; if (cnt < 1) cnt = 1; else if(cnt>8) cnt=8;
		for (var i:int = 0; i < cnt; i++) cost *= 2;

		if (EM.m_FormFleetBar.m_FleetMoney < cost) { FormMessageBox.RunErr(Common.Txt.NoEnoughMoney); return; }

		Server.Self.Query("emedcotlspecial", "&type=22&id=" + cotl.m_Id.toString(), EditCotlDevBuyRecv, false);
	}

	private function EditCotlDevBuyRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);
		if (loader.data == null) return;
		var buf:ByteArray = loader.data;
		buf.endian = Endian.LITTLE_ENDIAN;
		
		var err:int = buf.readUnsignedByte();
		if (err == Server.ErrorNoEnoughMoney) { FormMessageBox.RunErr(Common.Txt.NoEnoughMoney); return; }
		else if(err) { EM.ErrorFromServer(err); return; }
		else FormMessageBox.Run(Common.Txt.OpComplate, StdMap.Txt.ButClose);
	}	

	private function EditCotlMapEdit(...args):void
	{
		var cb:ComboBox;

		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;

		Server.Self.Query("emedcotlspecial","&type=1&id="+cotl.m_Id.toString(),EditCotlMapEditRecv,false);
	}

	private function EditCotlMapEditRecv(event:Event):void
	{
		EM.ToOnlyHyperspace();

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int = buf.readUnsignedByte();
		if (err == Server.ErrorExist) { EM.m_FormHint.Show(Common.TxtEdit.ErrorCotlInGameMode,Common.WarningHideTime);  return; }
		if(err) { EM.ErrorFromServer(err); return; }
		
		var cotlid:uint=buf.readUnsignedInt();
		var adr:uint=buf.readUnsignedInt();
		var port:int=buf.readInt();
		var num:int=buf.readInt();

		EM.m_Edit = true;
		
		if (EM.HS.visible) EM.HS.Hide();
		EM.m_GoCotlId = 0; EM.m_GoSectorX = 0; EM.m_GoSectorY = 0; EM.m_GoPlanet = -1; EM.m_GoShipNum = -1; EM.m_GoShipId = 0;
		EM.ChangeCotlServerEx(cotlid,adr,port,num);
		
		EM.SetCenter(0,0);
		//EM.m_FormMiniMap.SetCenter(0,0);
		
	}
}

}

import fl.controls.listClasses.CellRenderer;
import fl.events.ComponentEvent;
import flash.text.*;

class TradeRenderer extends CellRenderer
{
	public function TradeRenderer() {
		var originalStyles:Object = CellRenderer.getStyleDefinition();
		setStyle("upSkin",CellRenderer_OU_upSkin);
		setStyle("downSkin",CellRendere_PL_selectedUpSkin);
		setStyle("overSkin",CellRendere_PL_selectedUpSkin);
		setStyle("selectedUpSkin",CellRendere_PL_selectedUpSkin);
		setStyle("selectedDownSkin",CellRendere_PL_selectedUpSkin);
		setStyle("selectedOverSkin",CellRendere_PL_selectedUpSkin);
		setStyle("textFormat",new TextFormat("Calibri",14,0xffffff));
		setStyle("embedFonts", true);
		setStyle("textPadding",5);
		
		//textField.alpha=0.2;
		//textField.htmlText="aaa";
		
//		addEventListener(ComponentEvent.LABEL_CHANGE, labelChangeHandler);
	}
	
//	function labelChangeHandler(event:ComponentEvent):void
//	{
		//trace(textField.text);
		//		textField.htmlText="<font color='#ff0000'>"+textField.text+"</font>";
//	}
}
