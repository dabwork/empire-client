package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import QE.QEManager;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;


public class FormInfoBar extends Sprite
{
	private var EM:EmpireMap = null;

	static public const BarHeight:int = 30;

	public var m_ChatOpen:Boolean=true;

	public var m_Txt:TextField;
	public var m_TxtScore:TextField;
	public var m_IconMoney:IconMoney=new IconMoney();
	
	public var m_ButChatOpen:SimpleButton=null;
	public var m_ButChatClose:SimpleButton=null;
	
	public var m_ButTech:SimpleButton;
	public var m_ButRes:SimpleButton;
	public var m_ButPlusar:SimpleButton;
//	public var m_ButPactList:SimpleButton;
	public var m_ButSet:SimpleButton;
//	public var m_ButAdviser:SimpleButton;
	public var m_ButGalaxy:SimpleButton;
	public var m_ButUnion:SimpleButton;
//	public var m_ButExit:SimpleButton;

	public var m_TicketAttackN:BitmapData=null;
	public var m_TicketAttackA:BitmapData=null;
	public var m_TicketAttackD:BitmapData=null;
	public var m_TicketAttackEndN:BitmapData=null;
	public var m_TicketAttackEndA:BitmapData=null;
	public var m_TicketAttackEndD:BitmapData=null;
	public var m_TicketPactN:BitmapData=null;
	public var m_TicketPactA:BitmapData=null;
	public var m_TicketPactD:BitmapData=null;
	public var m_TicketPactOkN:BitmapData=null;
	public var m_TicketPactOkA:BitmapData=null;
	public var m_TicketPactOkD:BitmapData=null;
	public var m_TicketPactCancelN:BitmapData=null;
	public var m_TicketPactCancelA:BitmapData=null;
	public var m_TicketPactCancelD:BitmapData=null;
	public var m_TicketPlanetN:BitmapData=null;
	public var m_TicketPlanetA:BitmapData=null;
	public var m_TicketPlanetD:BitmapData=null;
	public var m_TicketUnionN:BitmapData=null;
	public var m_TicketUnionA:BitmapData=null;
	public var m_TicketUnionD:BitmapData=null;
	public var m_TicketOk:BitmapData=null;
	public var m_TicketCancel:BitmapData=null;
	public var m_TicketQuestion:BitmapData=null;
	public var m_TicketRedN:BitmapData=null;
	public var m_TicketRedA:BitmapData=null;
	public var m_TicketRedD:BitmapData=null;
	public var m_TicketCombatN:BitmapData=null;
	public var m_TicketCombatA:BitmapData=null;
	public var m_TicketCombatD:BitmapData=null;

	public var m_TicketList:Array=new Array();
	public var m_TicketOffset:int=0;
	public var m_TicketCur:int=0;
	public var m_TicketCur2:int=0;
	public var m_TicketDown:int = 0;
	
	public var m_TicketLastClick:int = 0;

	public var m_Timer:Timer=new Timer(50);

	public var m_MBBG:Sprite=null;
	
	public var m_TicketIgnore:Array=new Array();

	public var m_TicketData:uint=0;

	public var m_SoundRadio:Sound=null;
	public var m_SoundRadioChannelCtrl:SoundChannel=null;
	public var m_SoundRadioAdr:Array=null;
	public var m_SoundRadioLine:int=0;
	public var m_SoundRadioTry:int=0;
	public var m_SoundRadioTimer:Timer=new Timer(1000,1);
	public var m_SoundRadioTimer2:Timer=new Timer(5000);
	public var m_SoundRadioOn:Boolean=true;
	public var m_SoundRadioVol:Number=1.0;
	public var m_SoundRadioUIOn:SimpleButton=null;
	public var m_SoundRadioUIOff:SimpleButton=null;

	public var m_SoundRadioChannel:int=0;
	public var m_SoundRadioChannelName:Array=new Array();
	public var m_SoundRadioChannelAdr:Array=new Array();
	public var m_SoundRadioChannelDefCnt:int=0;

	public function FormInfoBar(map:EmpireMap)
	{
		EM=map;

		m_TicketAttackN=new TicketAttackN(20,20);
		m_TicketAttackA=new TicketAttackA(20,20);
		m_TicketAttackD=new TicketAttackD(20,20);
		m_TicketAttackEndN=new TicketAttackEndN(20,20);
		m_TicketAttackEndA=new TicketAttackEndA(20,20);
		m_TicketAttackEndD=new TicketAttackEndD(20,20);
		m_TicketPactN=new TicketPactN(20,20);
		m_TicketPactA=new TicketPactA(20,20);
		m_TicketPactD=new TicketPactD(20,20);
		m_TicketPactOkN=new TicketPactOkN(20,20);
		m_TicketPactOkA=new TicketPactOkA(20,20);
		m_TicketPactOkD=new TicketPactOkD(20,20);
		m_TicketPactCancelN=new TicketPactCancelN(20,20);
		m_TicketPactCancelA=new TicketPactCancelA(20,20);
		m_TicketPactCancelD=new TicketPactCancelD(20,20);
		m_TicketPlanetN=new TicketPlanetN(20,20);
		m_TicketPlanetA=new TicketPlanetA(20,20);
		m_TicketPlanetD=new TicketPlanetD(20,20);
		m_TicketUnionN=new TicketUnionN(20,20);
		m_TicketUnionA=new TicketUnionA(20,20);
		m_TicketUnionD=new TicketUnionD(20,20);
		m_TicketRedN=new TicketRedN(20,20);
		m_TicketRedA=new TicketRedA(20,20);
		m_TicketRedD=new TicketRedD(20,20);
		m_TicketCombatN=new TicketCombatN(20,20);
		m_TicketCombatA=new TicketCombatA(20,20);
		m_TicketCombatD=new TicketCombatD(20,20);

		m_TicketOk=new TicketOk(20,20);
		m_TicketCancel = new TicketCancel(20, 20);
		m_TicketQuestion = new TicketQuestion(20, 20);

		m_TxtScore=new TextField();
		m_TxtScore.type=TextFieldType.DYNAMIC;
		m_TxtScore.selectable=false;
		m_TxtScore.textColor=0xffffff;
		m_TxtScore.autoSize=TextFieldAutoSize.LEFT;
		m_TxtScore.antiAliasType=AntiAliasType.ADVANCED;
		m_TxtScore.gridFitType=GridFitType.PIXEL;
		m_TxtScore.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_TxtScore.embedFonts=true;
		addChild(m_TxtScore);
		//m_TxtScore.addEventListener(MouseEvent.MOUSE_OVER,ScoreOver);
		//m_TxtScore.addEventListener(MouseEvent.MOUSE_OUT,ScoreOut);
		
		addChild(m_IconMoney);

		m_Txt=new TextField();
		m_Txt.type=TextFieldType.DYNAMIC;
		m_Txt.selectable=false;
		m_Txt.textColor=0xffffff;
		m_Txt.autoSize=TextFieldAutoSize.LEFT;
		m_Txt.antiAliasType=AntiAliasType.ADVANCED;
		m_Txt.gridFitType=GridFitType.PIXEL;
		m_Txt.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_Txt.embedFonts=true;
		addChild(m_Txt);

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);

		m_MBBG=new MBBG();
		m_MBBG.mouseEnabled=false;
		addChild(m_MBBG);

		m_ButChatOpen=new MMButRight();
		m_ButChatOpen.addEventListener(MouseEvent.CLICK, clickOpenCloseChat);
		addChild(m_ButChatOpen);
		
		m_ButChatClose=new MMButLeft();
		m_ButChatClose.addEventListener(MouseEvent.CLICK, clickOpenCloseChat);
		addChild(m_ButChatClose);

		m_ButTech=new MBButTech();
		addChild(m_ButTech);
		m_ButTech.addEventListener(MouseEvent.CLICK, clickTech);

		m_ButRes=new MBButRes();
		addChild(m_ButRes);
		m_ButRes.addEventListener(MouseEvent.CLICK, clickRes);

		m_ButPlusar=new MBButPlusar();
		addChild(m_ButPlusar);
		m_ButPlusar.addEventListener(MouseEvent.CLICK, clickPlusar);

//		m_ButPactList=new MBButPact();
//		addChild(m_ButPactList);
//		m_ButPactList.addEventListener(MouseEvent.CLICK, clickPactList);

		m_ButSet=new MBButSet();
		addChild(m_ButSet);
		m_ButSet.addEventListener(MouseEvent.MOUSE_DOWN, MenuOpen);

//		m_ButAdviser=new MBButAdviser();
//		addChild(m_ButAdviser);
//		m_ButAdviser.addEventListener(MouseEvent.CLICK, clickAdviser);

		m_ButGalaxy=new MBButGalaxy();
		addChild(m_ButGalaxy);
		m_ButGalaxy.addEventListener(MouseEvent.CLICK, clickGalaxy);

		m_ButUnion=new MBButUnion();
		addChild(m_ButUnion);
		m_ButUnion.addEventListener(MouseEvent.CLICK, clickUnion);

//		m_ButExit=new MBButExit();
//		addChild(m_ButExit);
//		m_ButExit.addEventListener(MouseEvent.CLICK, clickExit);

		//addEventListener(MouseEvent.DOUBLE_CLICK,onMouseDblClickHandler);
		addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheelHandler);
		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
		addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
		addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
		addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandle);

		m_Timer.addEventListener("timer",Takt);

		//LoadChannelList();
		//LoadMsg();
		
		// Empire Radio
		// http://178.74.244.240:8000/
		
		// Drop Zone
		// File1=http://streamer-dtc-aa01.somafm.com:80/stream/1032
		// File2=http://streamer-ntc-aa06.somafm.com:80/stream/1032
		// File3=http://streamer-ntc-aa04.somafm.com:80/stream/1032

		m_SoundRadioUIOn=new MMButSoundRadio();
		m_SoundRadioUIOn.addEventListener(MouseEvent.CLICK, SoundRadio_Click);
		//m_SoundRadioUIOn.addEventListener(MouseEvent.MOUSE_OVER, SoundRadio_MouseOver);
		addChild(m_SoundRadioUIOn);
		m_SoundRadioUIOff=new MMButSoundRadioOff();
		m_SoundRadioUIOff.addEventListener(MouseEvent.CLICK, SoundRadio_Click);
		addChild(m_SoundRadioUIOff);
		
		m_SoundRadioUIOn.visible=m_SoundRadioOn;
		m_SoundRadioUIOff.visible=!m_SoundRadioOn;
		
		m_SoundRadioTimer.addEventListener("timer",SoundRadio_Takt);
		m_SoundRadioTimer2.addEventListener("timer",SoundRadio_Takt2);
		
		//SoundRadio_ParseChannelList("");
		SoundRadio_Load();
		SoundRadion_ChannelChange(null,m_SoundRadioChannel);
//		SoundRadion_Set("http://streamer-dtc-aa01.somafm.com:80/stream/1032\nhttp://streamer-ntc-aa06.somafm.com:80/stream/1032\nhttp://streamer-ntc-aa04.somafm.com:80/stream/1032");
	}

	public function StageResize():void
	{
		if (!visible) return;
		//&& EmpireMap.Self.IsResize()) Show();
		
		var sme:int;

		x = 0;
		y = EM.stage.stageHeight - BarHeight;
		
		graphics.clear();

		sme = 0;
		if (m_ChatOpen) sme = EM.m_FormChat.m_SizeX;

		graphics.beginFill(0x000000, 0.8);
		graphics.drawRect(sme, 0, EM.stage.stageWidth - sme, BarHeight);
		graphics.endFill();
		
		m_ButChatClose.x = EM.m_FormChat.m_SizeX;
		m_ButChatClose.y = 1;
		m_ButChatOpen.x = 5;
		m_ButChatOpen.y = 1;

		m_ButChatOpen.visible = (!m_ChatOpen) && EmpireMap.Self.m_ItfChat;
		m_ButChatClose.visible = (m_ChatOpen) && EmpireMap.Self.m_ItfChat;

		if (m_ChatOpen) sme = m_ButChatClose.x + m_ButChatClose.width;
		else sme = m_ButChatOpen.x + m_ButChatOpen.width;
		
		m_SoundRadioUIOn.x = sme;
		m_SoundRadioUIOn.y = 1;
		m_SoundRadioUIOff.x = sme;
		m_SoundRadioUIOff.y = 1;

		Update();
		TicketUpdate();
	}
	
	public function Show():void
	{
		var sme:int;
		visible=true;

		if(m_ChatOpen && EmpireMap.Self.m_ItfChat) EM.m_FormChat.Show();
		else EM.m_FormChat.Hide();

		if(EmpireMap.Self.m_ItfFleet) EM.m_FormFleetBar.Show();

		m_Timer.start();

		m_SoundRadioUIOn.visible=m_SoundRadioOn;
		m_SoundRadioUIOff.visible=!m_SoundRadioOn;

		StageResize();
	}

	public function Hide():void
	{
		visible=false;
		m_Timer.stop();
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(m_MBBG.hitTestPoint(stage.mouseX,stage.mouseY)) return true;
		if(m_ChatOpen) return mouseX>=EM.m_FormChat.m_SizeX && mouseX<EM.stage.stageWidth && mouseY>=0 && mouseY<BarHeight;
		else return mouseX>=0 && mouseX<EM.stage.stageWidth && mouseY>=0 && mouseY<BarHeight;
	}

/*	public function ScoreOver(e:MouseEvent):void
	{
		EM.m_Info.ShowScore();
	}

	public function ScoreOut(e:MouseEvent):void
	{
		EM.m_Info.Hide();
	}*/

	public function Update():void
	{
		if(!visible) return;

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);

		var str:String='';

		//if(user!=null) {
			//str+=Common.Txt.UserScore+": "+user.m_Score;
		//}
		str += BaseStr.FormatBigInt(EM.m_FormFleetBar.m_FleetMoney) + " cr";

		m_TxtScore.htmlText = str;
		m_TxtScore.x = EM.stage.stageWidth - m_TxtScore.width - 20;
		m_TxtScore.y = 4;//Math.round(BarHeight/2-m_Txt.height/2);

		m_IconMoney.x=m_TxtScore.x-20;
		m_IconMoney.y=BarHeight>>1;

		str='';
		//str+=EM.m_UserEGM.toString()+"egm [Купить]    "
		
		//var user:User=EM.GetUser(Server.Self.m_UserId);
		if (user != null) {
			str += "    " + Common.Txt.User + ": " + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
		}
		//str+="    "+Common.Txt.UserPlanetCnt+": "+EM.m_UserPlanetCnt;

		m_Txt.htmlText=str;
		m_Txt.x=m_IconMoney.x-10-m_Txt.width-20;
		m_Txt.y=4;//Math.round(BarHeight/2-m_Txt.height/2);

/*		m_ButPlusar.x=m_Txt.x-m_ButPlusar.width-20;
		m_ButPlusar.y=4;

		m_ButRes.x=m_ButPlusar.x-m_ButRes.width-5;
		m_ButRes.y=4;

		m_ButTech.x=m_ButRes.x-m_ButTech.width-5;
		m_ButTech.y=4;

		m_ButPactList.x=m_ButTech.x-m_ButPactList.width-5;
		m_ButPactList.y=4;*/
		
		
		var x:int,y:int;

//		var ex:int = EM.stage.stageWidth - 12;
//		x=ex;
//		y = -50;

		var ey:int = -5;// BarHeight - 5;// -100;
		//if (EM.m_FormFleetItem.visible) ey = (EM.m_FormFleetItem.y - 10) - this.y;
		//else ey = (EM.m_FormFleetBar.y - 10) - this.y;

		x=EM.stage.stageWidth-50;
		y=ey;

//		x-=46;
//		m_ButExit.x=x;
//		m_ButExit.y=y;

		y -= 46; //x-=46;
		m_ButSet.x=x;
		m_ButSet.y=y;

		if (EmpireMap.Self.IsAccountTmp()) {
			m_ButPlusar.visible = false;
		} else {
			y-=46;
			m_ButPlusar.x = x;
			m_ButPlusar.y = y;
		}

		if (EmpireMap.Self.IsAccountTmp()) {
			m_ButUnion.visible = false;
		} else {
			y -= 46; //x -= 46;
			m_ButUnion.x=x;
			m_ButUnion.y = y;
			m_ButUnion.visible = true;
		}

		if (EmpireMap.Self.IsAccountTmp()) {
			m_ButRes.visible = false;
		} else {
			y -= 46;
			m_ButRes.x=x;
			m_ButRes.y = y;
			m_ButRes.visible = true;
		}

		y -= 46; //x-=46;
		m_ButTech.x=x;
		m_ButTech.y=y;

//		x-=46;
//		m_ButPactList.x=x;
//		m_ButPactList.y=y;

//		x-=46;
//		m_ButAdviser.x=x;
//		m_ButAdviser.y=y;

		y -= 46; //x-=46;
		m_ButGalaxy.x=x;
		m_ButGalaxy.y=y;
		
//		m_MBBG.x=x-8;
//		m_MBBG.y=y-5;
//		m_MBBG.width = 8 + (ex - x) + 8;
		
		m_MBBG.x=x-6;
		m_MBBG.y=y-5;
		m_MBBG.height=5+(ey-y)+5;
		m_MBBG.width=58;
		

/*
		var ey:int=-10;
		x=EM.stage.stageWidth-55;
		y=ey;

		y-=46;
		m_ButSet.x=x;
		m_ButSet.y=y;

		y-=46;
		m_ButPlusar.x=x;
		m_ButPlusar.y=y;

		y-=46;
		m_ButRes.x=x;
		m_ButRes.y=y;

		y-=46;
		m_ButTech.x=x;
		m_ButTech.y=y;

		y-=46;
		m_ButPactList.x=x;
		m_ButPactList.y=y;

		y-=46;
		m_ButAdviser.x=x;
		m_ButAdviser.y=y;

		y-=46;
		m_ButGalaxy.x=x;
		m_ButGalaxy.y=y;

		m_MBBG.x=x-6;
		m_MBBG.y=y-5;
		m_MBBG.height=5+(ey-y)+5;
		m_MBBG.width=58;*/
	}

	private function clickRes(event:MouseEvent):void
	{
		if (EM.m_FormStorage.visible && EM.m_FormStorage.m_CotlId == EM.m_RootCotlId && EM.m_FormStorage.tab == EM.m_FormStorage.tabStorage) EM.m_FormStorage.Hide();
		else {
			if (EM.m_FormStorage.visible) EM.m_FormStorage.Hide();
			EM.FormHideAll();
			EM.m_FormStorage.m_CotlId = EM.m_RootCotlId;
			EM.m_FormStorage.tab = EM.m_FormStorage.tabStorage;
			EM.m_FormStorage.Show();
		}
	}

	private function clickPlusar(...args):void
	{
		if (EM.m_Action != 0) return;
		
		if(EM.m_FormPlusar.visible) EM.m_FormPlusar.Hide();
		else {
			EM.FormHideAll();
			EM.m_FormPlusar.Show();
		}
	}
	
	private function clickSet(...args):void
	{
		if (EM.m_Action != 0) return;
		
//		if(event.ctrlKey || event.altKey || event.shiftKey) {
//			EM.stage.displayState = StageDisplayState.FULL_SCREEN;//_INTERACTIVE;
//			return;
//		} 

		if(EM.m_FormSet.visible) EM.m_FormSet.Hide();
		else {
			EM.FormHideAll();
			EM.m_FormSet.Show();
		}
	}

	private function clickPactList(...args):void
	{
		if (EM.m_Action != 0) return;
		
		if(EM.m_FormPactList.visible) EM.m_FormPactList.Hide();
		else {
			EM.FormHideAll();
			EM.m_FormPactList.Show();
		}
	}

	private function clickTech(...args):void
	{
		if (EM.m_Action != 0) return;
		
		if(EM.m_FormTech.visible) EM.m_FormTech.Hide();
		else {
			EM.FormHideAll();
			EM.m_FormTech.m_Owner=Server.Self.m_UserId;
			EM.m_FormTech.Show();
		}
	}
	
/*	private function clickAdviser(...args):void
	{
		if (EM.m_Action != 0) return;
		
		if(EM.m_FormDialog.visible) EM.m_FormDialog.Hide();
		else {
			EM.FormHideAll();
			EM.m_FormDialog.Hide();
			EM.m_FormDialog.m_QuestName = "training";
			EM.m_FormDialog.m_QuestPage = -1;
			EM.m_FormDialog.Show();
		}
	}*/
	
//	private function clickTraining(...args):void
//	{
//		QEManager.RunByName("training", true);
//	}
	
	private function clickUnion(...args):void
	{
		if (EM.m_Action != 0) return;
		if (EmpireMap.Self.IsAccountTmp()) return;
		
		if(EM.m_FormUnionNew.visible) EM.m_FormUnionNew.Hide();
		else if(EM.m_FormUnion.visible) EM.m_FormUnion.Hide();
		else {
			EM.FormHideAll();
			EM.m_FormUnion.m_UnionId=EM.m_UnionId;
			if(EM.m_UnionId) EM.m_FormUnion.Show();
			else EM.m_FormUnionNew.Show();
		}
	}

	public function clickGalaxy(event:MouseEvent):void
	{
		if (EM.m_Action != 0) return;
		
		if (EM.m_Hangar.visible) {
			EM.m_Hangar.Hide();

		} else if (EM.HS.visible) {
			if (Server.Self.m_CotlId) {
				EM.HS.Hide();
				EM.ItfUpdate();
			}
		} else {
			EM.FormHideAll();
			EM.m_FormPlanet.Hide();
			EM.m_FormItemBalans.Hide();
			EM.HS.Show();
			EM.ItfUpdate();
			
			QEManager.Process(QEManager.FromEnterHyperspace);
			EmpireMap.Self.m_FormQuestBar.Update();
		}
/*		if(EM.m_FormGalaxy.visible) EM.m_FormGalaxy.Hide();
		else {
			EM.CloseForModal();
			EM.m_FormGalaxy.Show();
		}*/
	}
	
	private function clickCotlNew(...args):void
	{
		if (EM.m_Action != 0) return;

		//if(EM.m_FormExit.visible) { EM.m_FormExit.Hide(); return; }

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		if(user.m_ExitDate) {
			FormMessageBox.Run(Common.Txt.ExitNoAgain,Common.Txt.ButClose);
			return;
		}

		EM.m_FormExit.ShowEx(3);
	}

	private function clickCotlJump(...args):void
	{
		if (EM.m_Action != 0) return;

		//if(EM.m_FormExit.visible) { EM.m_FormExit.Hide(); return; }

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		if(user.m_ExitDate) {
			FormMessageBox.Run(Common.Txt.ExitNoAgain,Common.Txt.ButClose);
			return;
		}

		EM.m_FormExit.ShowEx(2);
	}

	private function clickExit(...args):void
	{
		if (EM.m_Action != 0) return;

		//if(EM.m_FormExit.visible) { EM.m_FormExit.Hide(); return; }

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		if(user.m_ExitDate) {
			FormMessageBox.Run(Common.Txt.ExitNoAgain,Common.Txt.ButClose);
			return;
		}

		EM.m_FormExit.ShowEx(1);
	}
	
	private function clickOpenCloseChat(event:MouseEvent):void
	{
		m_ChatOpen=!m_ChatOpen;
		Show();
	}

	public function TicketClear():void
	{
		var i:int;
		var obj:Object;

		for(i=0;i<m_TicketList.length;i++) {
			obj=m_TicketList[i];
			if(obj.Img!=null) {
				removeChild(obj.Img);
				obj.Img=null;
			}
			if(obj.Img2!=null) {
				removeChild(obj.Img2);
				obj.Img2=null;
			}
			if(obj.Txt!=null) {
				removeChild(obj.Txt);
				obj.Txt=null;
			}
		}
		m_TicketList.length=0;
	}

	public function AnswerTicketList(event:Event):void
	{
		var i:int;
		var obj:Object;
		
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;
//trace("AnswerTicketList",buf.length);

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		var ver:uint=sl.LoadDword();
//trace("AnswerTicketList ver="+ver.toString());
		if(ver<EM.m_TicketVer) return;
		EM.m_TicketVer=ver;

		for(i=0;i<m_TicketList.length;i++) {
			obj=m_TicketList[i];
			obj.del=true;
		}

		while(true) {
			var type:uint=sl.LoadDword();
			if(type==0) break;
			var utime:Number=1000*sl.LoadDword();
			var tid:uint=sl.LoadDword();
			var state:uint=sl.LoadDword();
			var cotlid:uint=sl.LoadDword();
			var sectorx:int=sl.LoadInt();
			var sectory:int=sl.LoadInt();
			var sectorminx:int=sl.LoadInt();
			var sectorminy:int=sl.LoadInt();
			var target:int=sl.LoadInt();
			var targetuserid:uint=sl.LoadDword();
			var flag:uint=sl.LoadDword();
			var val:uint=sl.LoadDword();

			if(type==Common.TicketTypeFleetMoveError) {
				if(m_TicketIgnore.indexOf(tid)<0) {
					m_TicketIgnore.push(tid);
					
					//EM.m_FormGalaxy.FleetMoveError(val);
				}
				continue;
			}

//trace("Ticket",type,time,num,state,sectorx,sectory,target,userid,flag);
			obj=null;
			for(i=0;i<m_TicketList.length;i++) {
				obj=m_TicketList[i];
				if(obj.TicketId==tid) break;
				obj=null;
			}
			if(obj==null) {
				obj=new Object();
				obj.TicketId=tid;
				m_TicketList.push(obj);
				obj.Img = null;
				obj.Img2 = null;
				obj.Txt = null;
			}

			obj.Type=type;
			obj.UTime=utime;
			obj.State=state;
			obj.CotlId=cotlid;
			obj.SectorX=sectorx;
			obj.SectorY=sectory;
			obj.SectorMinX=sectorminx;
			obj.SectorMinY=sectorminy;
			obj.Target=target;
			obj.TargetUserId=targetuserid;
			if(obj.Flag & 0x80000000) {
				obj.Flag=flag|0x80000000;
			} else {
				obj.Flag=flag;
			}
			obj.Val=val;
			obj.del=false;

			UserList.Self.GetUser(obj.TargetUserId);
			
			if(type==Common.TicketTypeUnionJoin) UserList.Self.GetUnion(obj.Val);
		}

		for(i=m_TicketList.length-1;i>=0;i--) {
			obj=m_TicketList[i];
			if(obj.del) {
				if(obj.Img!=null) {
					removeChild(obj.Img);
					obj.Img=null;
				}
				if(obj.Img2!=null) {
					removeChild(obj.Img2);
					obj.Img2=null;
				}
				if(obj.Txt!=null) {
					removeChild(obj.Txt);
					obj.Txt=null;
				}
				m_TicketList.splice(i,1);
			}
		}

		sl.LoadEnd();
		
		TicketGroup();
		TicketGraphPrepare();
		TicketUpdate();
	}
	
	public function TicketGroup():void
	{
		var i:int,u:int,k:int,g:int;
		var obj:Object,obj2:Object,obj3:Object;

		for (i = 0; i < m_TicketList.length; i++) {
			obj = m_TicketList[i];
			obj.Parent = -1;
			obj.Duplicate = -1;
		}

		for (i = 0; i < m_TicketList.length; i++) {
			obj = m_TicketList[i];
			if (obj.Flag & 0x80000000) continue;
			if (obj.Parent >= 0) continue;

			if (obj.Type == Common.TicketTypeAttack && obj.State == 0) g = 1;
			else if (obj.Type == Common.TicketTypeAttack && obj.State != 0) g = 2;
			else if (obj.Type == Common.TicketTypeCapture && (obj.State & 0x10000) != 0) g = 3;
			else if (obj.Type == Common.TicketTypeCapture && (obj.State & 0x10000) == 0) g = 4;
			else if (obj.Type == Common.TicketTypeSack) g = 5;

			if (g <= 0) continue;

			for (u = i + 1; u < m_TicketList.length; u++) {
				obj2 = m_TicketList[u];
				if (obj2.Flag & 0x80000000) continue;
				if (obj2.Parent >= 0) continue;
				if (obj.CotlId != obj2.CotlId) continue;

				if (obj2.Type == Common.TicketTypeAttack && obj2.State == 0 && g == 1) { }
				else if (obj2.Type == Common.TicketTypeAttack && obj2.State != 0 && g == 2) { }
				else if (obj2.Type == Common.TicketTypeCapture && (obj2.State & 0x10000) != 0 && g == 3) { }
				else if (obj2.Type == Common.TicketTypeCapture && (obj2.State & 0x10000) == 0 && g == 4) { }
				else if (obj2.Type == Common.TicketTypeSack && obj2.TargetUserId == obj.TargetUserId && g == 5) { }
				else continue;

				obj2.Parent = i;

				for (k = u - 1; k >= 0; k--) {
					obj3 = m_TicketList[k];
					if (obj3.Flag & 0x80000000) continue;
					if (obj3.Duplicate >= 0) continue;
					if (!(k == i || obj3.Parent == i)) continue;
					
					if (obj3.SectorX == obj2.SectorX && obj3.SectorY == obj2.SectorY && obj3.Target == obj2.Target) {
						obj2.Duplicate = k;
						break;
					}
				}
			}
		}
	}
	
	public function TicketShowCnt():int
	{
		var i:int;
		var obj:Object;
		var cnt:int = 0;
		
		for (i = 0; i < m_TicketList.length; i++) {
			obj = m_TicketList[i];
			if (obj.Parent < 0) cnt++;
		}
		return cnt;
	}

	public function TicketGraphPrepare():void
	{
		var i:int;
		var obj:Object;
		
		for (i = 0; i < m_TicketList.length; i++) {
			obj = m_TicketList[i];

			if (obj.Parent >= 0) {
				if(obj.Img!=null) {
					removeChild(obj.Img);
					obj.Img=null;
				}
				if(obj.Img2!=null) {
					removeChild(obj.Img2);
					obj.Img2=null;
				}
				if(obj.Txt!=null) {
					removeChild(obj.Txt);
					obj.Txt=null;
				}
			} else {
				if(obj.Img==null) {
					obj.Img=new Bitmap();
					addChild(obj.Img);
				}
				if(obj.Img2==null) {
					obj.Img2=new Bitmap();
					addChild(obj.Img2);
				}
				if(obj.Txt==null) {
					obj.Txt=new TextField();
					addChild(obj.Txt);
					obj.Txt.type=TextFieldType.DYNAMIC;
					obj.Txt.selectable=false;
					obj.Txt.background=false;
					obj.Txt.multiline=false;
					obj.Txt.autoSize=TextFieldAutoSize.NONE;
					obj.Txt.antiAliasType=AntiAliasType.ADVANCED;
					obj.Txt.gridFitType=GridFitType.PIXEL;// NONE;
					obj.Txt.defaultTextFormat=new TextFormat("Calibri",10,0x1d0000,true);
					obj.Txt.embedFonts = true;
				}
			}
		}
	}

	public function Takt(event:TimerEvent=null):void
	{
		var i:int;
		var obj:Object;

		for(i=0;i<m_TicketList.length;i++) {
			obj = m_TicketList[i];

			if (obj.Type == Common.TicketTypeCombatInvite && (obj.State & Common.ttciQuery) != 0) {
				if ((obj.UTime + 5 * 60 * 1000) < EM.GetServerGlobalTime()) {
					if(obj.NoAnswer==undefined || obj.NoAnswer==false) {
						obj.NoAnswer = true;
						EM.m_FormCombat.NoAnswerToBattle(obj.TargetUserId);
					}
				}
			}
		}

		TicketUpdate();
	}

	public function TicketUpdate():void
	{
		var i:int,u:int,x:int;
		var obj:Object,obj2:Object;

		var smex:int=30+5+30;
		if(m_ChatOpen) smex+=FormChat.Self.width-5;

		var sizex:int=m_Txt.x-smex-20;
		if(sizex<22) sizex=22;

		if(m_TicketOffset>=TicketShowCnt()-1) m_TicketOffset=TicketShowCnt()-1;
		if(m_TicketOffset<0) m_TicketOffset=0;

		x=-m_TicketOffset*22;
//trace(m_TicketOffset);
		for(i=0;i<m_TicketList.length;i++) {
			obj = m_TicketList[i];
			if(obj.Flag & 0x80000000) continue;
			if (obj.Parent >= 0) continue;
			var bm:Bitmap=obj.Img;
			var bm2:Bitmap=obj.Img2;
			var txt:TextField=obj.Txt;
			var txtvis:Boolean=false;

			if(obj.Type==Common.TicketTypeAttack) {
				if(obj.State==0) {
					if(m_TicketDown==obj.TicketId) bm.bitmapData=m_TicketAttackD;
					else if(m_TicketCur==obj.TicketId) bm.bitmapData=m_TicketAttackA;
					else bm.bitmapData=m_TicketAttackN;
				} else {
					if(m_TicketDown==obj.TicketId) bm.bitmapData=m_TicketAttackEndD;
					else if(m_TicketCur==obj.TicketId) bm.bitmapData=m_TicketAttackEndA;
					else bm.bitmapData=m_TicketAttackEndN;
				}

			} else if(obj.Type==Common.TicketTypePact) {
				if(obj.State==0 || obj.State==1) {
					if (m_TicketDown == obj.TicketId) bm.bitmapData = m_TicketPactD;
					else if (m_TicketCur == obj.TicketId) bm.bitmapData = m_TicketPactA;
					else bm.bitmapData = m_TicketPactN;
				} else if(obj.State==2) {
					if (m_TicketDown == obj.TicketId) bm.bitmapData = m_TicketPactOkD;
					else if (m_TicketCur == obj.TicketId) bm.bitmapData = m_TicketPactOkA;
					else bm.bitmapData = m_TicketPactOkN;
				} else {
					if (m_TicketDown == obj.TicketId) bm.bitmapData = m_TicketPactCancelD;
					else if (m_TicketCur == obj.TicketId) bm.bitmapData = m_TicketPactCancelA;
					else bm.bitmapData = m_TicketPactCancelN;
				}
				
			} else if (obj.Type == Common.TicketTypeCapture || obj.Type == Common.TicketTypeSack) {
				if (m_TicketDown == obj.TicketId) bm.bitmapData = m_TicketPlanetD;
				else if (m_TicketCur == obj.TicketId) bm.bitmapData = m_TicketPlanetA;
				else bm.bitmapData = m_TicketPlanetN;

			} else if (obj.Type == Common.TicketTypeUnionJoin) {
				if (EmpireMap.Self.IsAccountTmp()) { bm.visible = false; bm2.visible = false; txt.visible = false; continue; }
				if(m_TicketDown==obj.TicketId) bm.bitmapData=m_TicketUnionD;
				else if(m_TicketCur==obj.TicketId) bm.bitmapData=m_TicketUnionA;
				else bm.bitmapData=m_TicketUnionN;
				if(obj.State==1 || obj.State==4) bm2.bitmapData=m_TicketOk;
				else if(obj.State==2 || obj.State==5 || obj.State==6 || obj.State==7) bm2.bitmapData=m_TicketCancel;
				else bm2.bitmapData=null;

			} else if(obj.Type==Common.TicketTypeAnnihilation) {
				if(m_TicketDown==obj.TicketId) bm.bitmapData=m_TicketRedD;
				else if(m_TicketCur==obj.TicketId) bm.bitmapData=m_TicketRedA;
				else bm.bitmapData=m_TicketRedN;

				txt.text = Math.max(0, Math.floor((1000 * obj.Val - EM.GetServerGlobalTime()) / 1000)).toString();

				txtvis=true;

			} else if(obj.Type==Common.TicketTypeCombatInvite) {
				if(m_TicketDown==obj.TicketId) bm.bitmapData=m_TicketCombatD;
				else if(m_TicketCur==obj.TicketId) bm.bitmapData=m_TicketCombatA;
				else bm.bitmapData = m_TicketCombatN;

				if ((obj.State & (Common.ttciQuery | Common.ttciTo)) == (Common.ttciQuery | Common.ttciTo)) bm2.bitmapData = m_TicketQuestion;
				else if ((obj.State & Common.ttciOk) != 0) bm2.bitmapData = m_TicketOk;
				else if ((obj.State & (Common.ttciCancel | Common.ttciNoAnser)) != 0) bm2.bitmapData = m_TicketCancel;
				else bm2.bitmapData = null;

			} else { bm.visible = false; bm2.visible = false; txt.visible = false; continue; }
			
			var fnew:Boolean = (obj.Flag & 1) == 0;
			if(!fnew) {
				for (u = 0; u < m_TicketList.length; u++) {
					obj2 = m_TicketList[u];
					if (obj2.Parent != i) continue;
					if ((obj2.Flag & 1) != 0) continue;
					
					fnew = true;
					break;
				}
			}

			bm.x=smex+x;
			bm.y=(BarHeight>>1)-(bm.bitmapData.height>>1);
			bm.visible=(bm.x>=smex) && (bm.x<=(smex+sizex-22));
			if(!fnew) bm.alpha=1.0;
			else {
				var a:Number=((Common.GetTime()) % 1000)/1000;

				if(a<=0.5) a=a*2.0;
				else a=(1.0-a)*2.0;

				bm.alpha=0.4+a*0.8;
			}

			if(m_TicketDown==obj.TicketId) {
				bm.x=bm.x+1;
				bm.y=bm.y+1;
				bm2.x=bm.x;
				bm2.y=bm.y;
			} else {
				bm2.x=bm.x;
				bm2.y=bm.y;
			}
			bm2.alpha=bm.alpha;
			bm2.visible=bm.visible;

			if(!txtvis) {
				txt.visible=false;
			} else {
				txt.visible=bm.visible;
				txt.alpha=bm.alpha;
				txt.x=bm.x+(bm.width>>1)-(txt.textWidth>>1)-3;
				txt.y=bm.y+(bm.height>>1)-(txt.textHeight>>1)-3;
				txt.width=txt.textWidth+10;
				txt.height=txt.textHeight+10;
			}

			x+=22;
		}
	}

	public function GetTicket(tid:uint):Object
	{
		var i:int;
		var obj:Object;

		for(i=0;i<m_TicketList.length;i++) {
			obj=m_TicketList[i];
			if(obj.TicketId==tid) return obj;
		}

		return null;
	}

	public function PickTicket():int
	{
		var i:int;
		var obj:Object;

		for(i=0;i<m_TicketList.length;i++) {
			obj=m_TicketList[i];
			if(obj.Img==undefined || obj.Img==null) continue;
			if(!obj.Img.visible) continue;

			if(obj.Img.hitTestPoint(stage.mouseX,stage.mouseY)) return obj.TicketId;
		}
		return 0;
	}

	protected function onMouseWheelHandler(e:MouseEvent):void
	{
		var i:int=m_TicketOffset-Math.round(e.delta/3);
		if(i>=TicketShowCnt()-1) i=TicketShowCnt()-1;
		if(i<0) i=0;
//trace(i,m_TicketList.length);

		if(i!=m_TicketOffset) { m_TicketOffset=i; TicketUpdate(); }
	}

/*	protected function onMouseDblClickHandler(e:MouseEvent):void
	{
		var i:int=PickTicket();
		if(i!=0) {
			var ticket:Object=GetTicket(i);
			if(ticket) {
				if(!(ticket.Flag & 0x80000000)) {
					ticket.Flag |= 0x80000000;
					EM.SendAction("emticket","1_"+ticket.Num.toString());
				}
			}
		}
	}*/

	protected function onMouseDownHandler(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var i:int=PickTicket();
		if(i!=m_TicketDown) {
			m_TicketDown=i;
			TicketUpdate();
		}
	}

	protected function onMouseUpHandler(e:MouseEvent):void
	{
		var i:int;
		var str:String;
		var tp:Point;

		if(m_TicketDown!=0) {
			if (PickTicket() == m_TicketDown) {
				//m_TicketLastClick
				var ticket:Object=GetTicket(m_TicketDown);
				if (ticket != null) {
					var tg:Object = ticket;
					
					for (i = m_TicketList.length - 1; i >= 0 ; i--) {
						obj = m_TicketList[i];
						if (obj.Flag & 0x80000000) continue;
						if (obj.Duplicate >= 0) continue;
						if (!(ticket == obj || (obj.Parent >= 0 && m_TicketList[obj.Parent] == ticket))) continue;
						if (obj.TicketId == m_TicketLastClick) break;
					}
					if (i < 0) i = m_TicketList.length;

					for (i = i - 1; i >= 0; i--) {
						obj = m_TicketList[i];
						if (obj.Flag & 0x80000000) continue;
						if (obj.Duplicate >= 0) continue;
						if (!(ticket == obj || (obj.Parent >= 0 && m_TicketList[obj.Parent] == ticket))) continue;
						break;
					}
					if (i < 0) {
						for (i = m_TicketList.length - 1; i >= 0; i--) {
							obj = m_TicketList[i];
							if (obj.Flag & 0x80000000) continue;
							if (obj.Duplicate >= 0) continue;
							if (!(ticket == obj || (obj.Parent >= 0 && m_TicketList[obj.Parent] == ticket))) continue;
							break;
						}
					}
					if (i >= 0) {
						ticket = obj;
					}

					if((ticket.Flag & 1)==0) {
						ticket.Flag |= 1;
						EM.SendAction("emticket","0_"+ticket.TicketId.toString());
					}
					for (i = 0; i < m_TicketList.length; i++) {
						obj = m_TicketList[i];
						if (obj.Duplicate < 0) continue;
						if (m_TicketList[obj.Duplicate] != ticket) continue;

						if ((obj.Flag & 1)==0) {
							obj.Flag |= 1;
							EM.SendAction("emticket", "0_" + obj.TicketId.toString());
						}
					}

					m_TicketLastClick = ticket.TicketId;

//trace(ticket.SectorX,ticket.SectorY,ticket.Target);
					if(ticket.Type==Common.TicketTypeAttack || ticket.Type==Common.TicketTypeCapture || ticket.Type==Common.TicketTypeSack || ticket.Type==Common.TicketTypeAnnihilation) {
						EM.GoTo(true, ticket.CotlId, ticket.SectorX, ticket.SectorY, ticket.Target);

					} else if(ticket.Type==Common.TicketTypePact && ticket.State==0) {
						if(!EmpireMap.Self.IsAccountTmp()) {
							//0-Send 1-Query 2-Accept 3-Reject 4-Complate 5-NoRes 6-TimeOut 7-change 8-break
							EM.m_FormPactList.CallPact(ticket.TargetUserId, FormPact.ModePreset);
						}

					} else if(ticket.Type==Common.TicketTypePact && ticket.State==1) {
						if(!EmpireMap.Self.IsAccountTmp()) {
							EM.m_FormPactList.CallPact(ticket.TargetUserId, FormPact.ModeQuery);
						}

					} else if(ticket.Type==Common.TicketTypePact && ticket.State==2) {
						if(!EmpireMap.Self.IsAccountTmp()) {
							EM.m_FormPactList.CallPact(ticket.TargetUserId, FormPact.ModeView);
						}

					} else if (ticket.Type == Common.TicketTypeUnionJoin && ticket.State == 0) {
						if(!EmpireMap.Self.IsAccountTmp()) {
							m_TicketData=ticket.TargetUserId;
							FormMessageBox.Run(Common.Txt.FormUnionCancelQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, ActionUnionJoinCancel, null, false);
						}

					} else if(ticket.Type==Common.TicketTypeUnionJoin && ticket.State==3) {
						if(!EmpireMap.Self.IsAccountTmp()) {
							m_TicketData=ticket.TargetUserId;
							FormMessageBox.Run(Common.Txt.FormUnionJoinQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, ActionUnionJoinAccept, ActionUnionJoinCancel, false);
						}

					} else if (ticket.Type == Common.TicketTypeCombatInvite) {
						if(!EmpireMap.Self.IsAccountTmp()) {
							if((ticket.State & (Common.ttciQuery | Common.ttciTo))==(Common.ttciQuery | Common.ttciTo)) {
								m_TicketData = ticket.TargetUserId;

								str = EM.m_Info.TextTicket(m_TicketDown);
								if(str!=null) {
									str += " " + Common.Txt.FormCombatJoinQuery;
									if(ticket.State & Common.ttciJoin) FormMessageBox.Run(str, StdMap.Txt.ButNo, StdMap.Txt.ButYes, ActionCombatInviteAccept, ActionCombatJoinCancel, false);
									else FormMessageBox.Run(str, StdMap.Txt.ButNo, StdMap.Txt.ButYes, ActionCombatDuelAccept, ActionCombatJoinCancel, false);
								}
							}
						}
					}

					tp=EM.m_FormInfoBar.localToGlobal(new Point(tg.Img.x,tg.Img.y));
					if (tg != null && (tg.Type == Common.TicketTypeAttack || tg.Type == Common.TicketTypeCapture || tg.Type == Common.TicketTypeSack)) {
						EM.m_Info.ShowTicketEx(tg.TicketId, tp.x, tp.y - 5);
						
					} else if (tg != null) {
						EM.m_Info.ShowTicket(tg.TicketId,tp.x,tp.y-5);
					}

					var obj:Object;

					EM.m_FormMenu.Clear();

					obj=EM.m_FormMenu.Add(Common.Txt.TicketDelete,null,m_TicketDown);
					if((ticket.Type!=Common.TicketTypeAttack) || (ticket.State!=0)) obj.Fun=TicketDelete2;
					else obj.Disable=true;

					var cx:int=tg.Img.x;
					var cy:int=y;

					EM.m_FormMenu.Show(cx,cy,cx+1,cy+30);
					
				}
			}
			m_TicketDown=0;
			TicketUpdate();
		}
	}

	protected function onMouseMoveHandler(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		var tp:Point;
		var i:int=PickTicket();
		if(i!=m_TicketCur) {
			m_TicketCur=i;
			TicketUpdate();

			if(m_TicketCur>0) {
				var ticket:Object = GetTicket(m_TicketCur);
				if (ticket != null && (ticket.Type == Common.TicketTypeAttack || ticket.Type == Common.TicketTypeCapture || ticket.Type == Common.TicketTypeSack)) {
					tp=EM.m_FormInfoBar.localToGlobal(new Point(ticket.Img.x,ticket.Img.y));
					EM.m_Info.ShowTicketEx(m_TicketCur, tp.x, tp.y - 5);
					
				} else if (ticket != null) {
					if(!(ticket.Flag & 1)) {
						ticket.Flag |= 1;
						EM.SendAction("emticket","0_"+ticket.TicketId.toString());
					}

					tp=EM.m_FormInfoBar.localToGlobal(new Point(ticket.Img.x,ticket.Img.y));
					EM.m_Info.ShowTicket(m_TicketCur,tp.x,tp.y-5);
				}
			}
		}
		m_TicketCur2=m_TicketCur;

		if(m_TicketCur==0) {
			//if(m_TxtScore.hitTestPoint(stage.mouseX,stage.mouseY)) {
			if(mouseX>=m_Txt.x && mouseY>=0 && mouseY<BarHeight) {
				EM.m_Info.ShowScore();
			} else {
				EM.m_Info.Hide();
			}
		}
	}

	protected function onMouseOutHandle(e:MouseEvent):void
	{
		if(m_TicketCur!=0) {
			m_TicketCur=0;
			TicketUpdate();
			EM.m_Info.Hide();
		}
	}

/*	public function ContextMenuOpen(cm:ContextMenu):void
	{
		var i:int;
		var item:ContextMenuItem;
		if(m_TicketCur2!=0) {
			var ticket:Object=GetTicket(m_TicketCur2);
			if(ticket!=null) {
				item=new ContextMenuItem(Common.Txt.TicketDelete);
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,TicketDelete);
				item.enabled=(ticket.Type!=Common.TicketTypeAttack) || (ticket.State!=0);
				cm.customItems.push(item);
			}
		}
	}

	public function TicketDelete(...args):void
	{
		EM.m_ContentMenuShow=false;
		var ticket:Object=GetTicket(m_TicketCur2);

		if(!(ticket.Flag & 0x80000000)) {
			ticket.Flag |= 0x80000000;
			EM.SendAction("emticket","1_"+ticket.TicketId.toString());
		}
	}*/

	public function TicketDelete2(objfrom:Object, data:int):void
	{
		var i:int;
		var obj:Object;

		EM.FormHideAll();

		var ticket:Object=GetTicket(data);
		if (ticket == null) return;
		if (ticket.Parent >= 0) ticket = m_TicketList[ticket.Parent];

		for (i = 0; i < m_TicketList.length; i++) {
			obj = m_TicketList[i];
			if ((obj.Flag & 0x80000000) != 0) continue;
			if (!(obj == ticket || (obj.Parent >= 0 && m_TicketList[obj.Parent] == ticket))) continue;

			obj.Flag |= 0x80000000;
			EM.SendAction("emticket","1_"+obj.TicketId.toString());

			if(obj.Img!=null) {
				removeChild(obj.Img);
				obj.Img=null;
			}
			if(obj.Img2!=null) {
				removeChild(obj.Img2);
				obj.Img2=null;
			}
			if(obj.Txt!=null) {
				removeChild(obj.Txt);
				obj.Txt = null;
			}
		}
		TicketGroup();
		TicketGraphPrepare();
		TicketUpdate();
	}

	private function ActionCombatDuelAccept():void
	{
		EM.m_FormCombat.JoinToBattle(m_TicketData);
	}

	private function ActionCombatInviteAccept():void
	{
		EM.m_FormCombat.InviteToBattle(m_TicketData);
	}

	private function ActionCombatJoinCancel():void
	{
		EM.m_FormCombat.CancelToBattle(m_TicketData);
	}

	private function ActionUnionJoinAccept():void
	{
		EM.m_FormUnion.JoinAcceptQuery(m_TicketData);
	}
	
	private function ActionUnionJoinCancel():void
	{
		EM.m_FormUnion.JoinCancelQuery(m_TicketData);
	}

	private function SoundRadio_Error(event:Event):void
	{
//trace("SoundRadio.Error: " + event);
//if(EM.m_FormChat!=null) EM.m_FormChat.AddDebugMsg("SoundRadio.Error: " + event);

		m_SoundRadioTry++;
		if(m_SoundRadioTry>=m_SoundRadioAdr.length) { m_SoundRadioTry=0; }
		m_SoundRadioTimer.stop();
		m_SoundRadioTimer2.stop();
		if(m_SoundRadioTry==0) m_SoundRadioTimer.delay=5000;
		else m_SoundRadioTimer.delay=1000;
		m_SoundRadioTimer.repeatCount=1;
		m_SoundRadioTimer.start();
	}
	
	public function SoundRadio_Takt(event:TimerEvent):void
	{
		SoundRadion_Play();
	}

	public function SoundRadio_Takt2(event:TimerEvent):void
	{
		m_SoundRadioTimer2.stop();
		
		if(m_SoundRadioChannelCtrl==null || m_SoundRadioChannelCtrl.position<=0) SoundRadio_Error(event);
//if(EM.m_FormChat!=null && m_SoundRadioChannelCtrl!=null) EM.m_FormChat.AddDebugMsg(m_SoundRadioChannelCtrl.position.toString());
	}
	
	public function SoundRadion_Set(adr:String):void
	{
		SoundRadion_Stop();

		m_SoundRadioAdr=adr.split("\n");
		m_SoundRadioLine=Math.round(Math.random()*(m_SoundRadioAdr.length-1));
		m_SoundRadioTry=0;
		
		if(m_SoundRadioOn) SoundRadion_Play();
	}
	
	public function SoundRadion_Play():void
	{
		if(m_SoundRadioAdr.length<=0) return;
		
		SoundRadion_Stop();
		
		m_SoundRadioLine++;
		m_SoundRadioLine=m_SoundRadioLine % m_SoundRadioAdr.length;
		//trace("line:",m_SoundRadioLine);		
		
		var s:String=m_SoundRadioAdr[m_SoundRadioLine];
		if(s.length<=0) { SoundRadio_Error(null); return; }
		
		try {
			var request:URLRequest = new URLRequest(s);
		
			m_SoundRadio=new Sound();
			m_SoundRadio.addEventListener(IOErrorEvent.IO_ERROR, SoundRadio_Error);
		
if(EM.m_FormChat!=null && EM.m_Debug) EM.m_FormChat.AddDebugMsg("Sound: "+s);
			m_SoundRadio.load(request);
			m_SoundRadioChannelCtrl=m_SoundRadio.play();
			m_SoundRadioChannelCtrl.soundTransform=new SoundTransform(m_SoundRadioVol);
			m_SoundRadioTimer2.start();
		 } catch (e:*) {
			SoundRadion_Stop();
		 }
	}
	
	public function SoundRadion_Stop():void
	{
		m_SoundRadioTimer.stop();
		m_SoundRadioTimer2.stop();

		if(m_SoundRadioChannelCtrl!=null) {
			try {
				m_SoundRadioChannelCtrl.stop();
			}
			catch (e:*) {
			}
			m_SoundRadioChannelCtrl=null;
		}
		if(m_SoundRadio!=null) {
			try {
				m_SoundRadio.close();
			}
			catch (e:*) {
			}
			m_SoundRadio=null;
		}
	}

	public function SoundRadio_Click(e:Event):void
	{
		var i:int;
		
		EM.m_FormMenu.Clear();

		EM.m_FormMenu.Add(Common.Txt.SoundChannel+":");
		for(i=0;i<m_SoundRadioChannelName.length;i++) {
			EM.m_FormMenu.Add("    "+m_SoundRadioChannelName[i],SoundRadion_ChannelChange,i).Check=m_SoundRadioChannel==i;
		}
		//EM.m_FormMenu.Add("    Drone Zone",SoundRadion_Type,1).Check=m_SoundRadioType==1;
		//EM.m_FormMenu.Add("    User",SoundRadion_Type,0).Check=m_SoundRadioType==0;

		EM.m_FormMenu.Add();
		
		EM.m_FormMenu.Add(Common.Txt.SoundVol+":");
		for(i=10;i<=100;i+=10) {
			EM.m_FormMenu.Add("    "+i.toString()+"%",SoundRadion_Vol,i).Check=Math.abs(m_SoundRadioVol*100-i)<4;
		}

		EM.m_FormMenu.Add();
		
		EM.m_FormMenu.Add(Common.Txt.SoundLoadPls,SoundRadion_LoadPls);

		EM.m_FormMenu.Add("Site SomaFM...",SoundRadion_somafm);
		EM.m_FormMenu.Add("Site SHOUTcast...",SoundRadion_shoutcast);

		if (m_SoundRadioOn) EM.m_FormMenu.Add(Common.Txt.SoundOff, SoundRadion_OnOff);
		else EM.m_FormMenu.Add(Common.Txt.SoundOn, SoundRadion_OnOff);

		var cx:int = x + m_SoundRadioUIOn.x;
		var cy:int = y;

		EM.m_FormMenu.Show(cx,cy,cx+1,cy+30);
	}

	private function SoundRadion_OnOff(obj:Object, data:int):void
	{
		m_SoundRadioOn=!m_SoundRadioOn;
		
		SoundRadio_Save();

		m_SoundRadioUIOn.visible=m_SoundRadioOn;
		m_SoundRadioUIOff.visible=!m_SoundRadioOn;

		if(m_SoundRadioOn) SoundRadion_Play();
		else SoundRadion_Stop();
	}

	private function SoundRadion_Vol(obj:Object, data:int):void
	{
		m_SoundRadioVol=data/100;
		
		SoundRadio_Save();

		if(m_SoundRadioChannelCtrl!=null) m_SoundRadioChannelCtrl.soundTransform=new SoundTransform(m_SoundRadioVol);
	}

	private function SoundRadion_ChannelChange(obj:Object, data:int):void
	{
		m_SoundRadioChannel=data;
		if(m_SoundRadioChannel>=m_SoundRadioChannelName.length) m_SoundRadioChannel=m_SoundRadioChannelName.length-1;
		if(m_SoundRadioChannel<0) m_SoundRadioChannel=0;
		
		SoundRadio_Save();

		SoundRadion_Set(m_SoundRadioChannelAdr[m_SoundRadioChannel]);

//		if(m_SoundRadioType==0) SoundRadion_Set(m_SoundRadioAdrUser);
//		else SoundRadion_Set("http://streamer-dtc-aa01.somafm.com:80/stream/1032\nhttp://streamer-ntc-aa06.somafm.com:80/stream/1032\nhttp://streamer-ntc-aa04.somafm.com:80/stream/1032");
	}
	
	private function SoundRadio_AddDefault():void
	{
		var ff:int=m_SoundRadioChannelName.length;
		m_SoundRadioChannelName.push("Drone Zone"); m_SoundRadioChannelAdr.push("http://streamer-dtc-aa01.somafm.com:80/stream/1032"+"\n"+"http://streamer-ntc-aa06.somafm.com:80/stream/1032"+"\n"+"http://streamer-ntc-aa04.somafm.com:80/stream/1032");
		m_SoundRadioChannelName.push("Space Station Soma"); m_SoundRadioChannelAdr.push("http://205.188.215.227:8014"+"\n"+"http://voxsc1.somafm.com:8000"+"\n"+"http://207.200.96.231:8012"+"\n"+"http://ice.somafm.com/spacestation");
		m_SoundRadioChannelName.push("Radio Empire"); m_SoundRadioChannelAdr.push("http://217.112.36.172:8123/empire");

		m_SoundRadioChannelDefCnt=m_SoundRadioChannelName.length-ff;
	}

	private function SoundRadio_ParseChannelList(src:String):void
	{
		m_SoundRadioChannelName.length=0;
		m_SoundRadioChannelAdr.length=0;
		
		SoundRadio_AddDefault();

		var start:int,num:int,i:int;
		var sme:int=0;
		var srclen:int=src.length;
		var ch:int;
		var name:String,val:String;
		
		var ladr:Array=new Array();
		var lname:Array=new Array();

		while(sme<srclen) {
			ch=src.charCodeAt(sme);
			sme++;

			if(ch==32 || ch==9 || ch==0x0d || ch==0x0a) continue;
			if(ch==91) { // [
				while(sme<srclen) {
					ch=src.charCodeAt(sme);
					sme++;
					if(ch==93) break; // ]
				}
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
			
//trace(name,"==",val);
			
			if(name.length>4 && BaseStr.IsTagEq(name,0,4,"file","FILE")) {
				num=int(name.substring(4,name.length));

				if(num>=ladr.length) { ladr.length=num+1; lname.length=num+1; }

				if(ladr[num]==undefined || ladr[num]==null) {
					ladr[num]=val;
				} else {
					ladr[num]+="\n"+val;
				}
			}
			if(name.length>5 && BaseStr.IsTagEq(name,0,5,"title","TITLE")) {
				num=int(name.substring(5,name.length));

				if(num>=ladr.length) { ladr.length=num+1; lname.length=num+1; }

				lname[num]=val;
			}
		}
		
		for(i=0;i<ladr.length;i++) {
			if(ladr[i]==undefined || ladr[i]==null) continue;
			
			m_SoundRadioChannelAdr.push(ladr[i]);
			
			if(lname[i]==undefined || lname[i]==null) {
				m_SoundRadioChannelName.push("unknown");
			} else {
				if(lname[i].length>32) m_SoundRadioChannelName.push(lname[i].substr(0,32-3)+"...");
				else m_SoundRadioChannelName.push(lname[i]);
			}
//trace(m_SoundRadioChannelAdr[m_SoundRadioChannelAdr.length-1]);
//trace(m_SoundRadioChannelName[m_SoundRadioChannelName.length-1]);
		}
	}
	
	private var fr:FileReference=null; 
	
	private function SoundRadion_LoadPls(obj:Object, data:int):void
	{
		fr=new FileReference();
		fr.browse(new Array(new FileFilter("pls (*.pls)", "*.pls")));
		fr.addEventListener(Event.SELECT, SoundRadion_PlsSelect);
	}
	
	public function SoundRadion_PlsSelect(event:Event):void
	{
		fr.addEventListener(Event.COMPLETE, SoundRadion_PlsComplate); 
		fr.load();
	}

	public function SoundRadion_PlsComplate(event:Event):void
	{
		var str:String="";
		if(fr.data!=null && fr.data.length>0) str=fr.data.readUTFBytes(fr.data.length);
		SoundRadio_ParseChannelList(str);
		SoundRadio_Save();
		SoundRadion_ChannelChange(null,m_SoundRadioChannel);
	}
	
	public function SoundRadion_somafm(obj:Object, data:int):void
	{
		try {
			var request:URLRequest = new URLRequest("http://somafm.com/");
			navigateToURL(request,"_blank");
		}
		catch (e:*) {
		}
	}

	public function SoundRadion_shoutcast(obj:Object, data:int):void
	{
		try {
			var request:URLRequest = new URLRequest("http://www.shoutcast.com/");
			navigateToURL(request,"_blank");
		}
		catch (e:*) {
		}
	}
	
	public function SoundRadio_Save():void
	{
		var i:int;
		
		var so:SharedObject = SharedObject.getLocal("EGSoundRadio");
		so.data.channel=m_SoundRadioChannel;
		so.data.on=m_SoundRadioOn;
		so.data.vol=m_SoundRadioVol;
		
		var lname:Array=new Array();
		var ladr:Array=new Array();
		
		for(i=m_SoundRadioChannelDefCnt;i<m_SoundRadioChannelName.length;i++) {
			lname.push(m_SoundRadioChannelName[i]);
			ladr.push(m_SoundRadioChannelAdr[i]);
		}
		
		so.data.lname=lname;
		so.data.ladr=ladr;
	}

	public function SoundRadio_Load():void
	{
		var i:int;

		var so:SharedObject = SharedObject.getLocal("EGSoundRadio");
		
		m_SoundRadioChannelName.length=0;
		m_SoundRadioChannelAdr.length=0;
		SoundRadio_AddDefault();

		if(so.size==0) {
			m_SoundRadioChannel=0;
			m_SoundRadioOn=true;
			m_SoundRadioVol=0.5;
			return;
		}
		
		if(so.data.channel==undefined) m_SoundRadioChannel=0;
		else m_SoundRadioChannel=so.data.channel;
		if(so.data.on==undefined) m_SoundRadioOn=true;
		else m_SoundRadioOn=so.data.on;
		if(so.data.vol==undefined) m_SoundRadioVol=0.5;
		else m_SoundRadioVol=so.data.vol;
		
		if(m_SoundRadioVol<0) m_SoundRadioVol=0;
		if(m_SoundRadioVol>1.0) m_SoundRadioVol=1.0;
		
		if(so.data.lname!=undefined && so.data.ladr!=undefined) {
			var lname:Array=so.data.lname;
			var ladr:Array=so.data.ladr;
			if(lname.length==ladr.length) {
				for(i=0;i<ladr.length;i++) {
					m_SoundRadioChannelName.push(lname[i]);
					m_SoundRadioChannelAdr.push(ladr[i]);
				}
			}
		} 		
	}

	public function MenuOpen(...args):void
	{
		EM.m_FormMenu.Clear();

		EM.m_FormMenu.Add(Common.Txt.FormMenuTech, clickTech);
		if (!EmpireMap.Self.IsAccountTmp()) EM.m_FormMenu.Add(Common.Txt.FormMenuPactList, clickPactList);
		if (!EmpireMap.Self.IsAccountTmp()) EM.m_FormMenu.Add(Common.Txt.FormMenuUnion, clickUnion);
		if (!EmpireMap.Self.IsAccountTmp()) EM.m_FormMenu.Add(Common.Txt.FormMenuPlusar, clickPlusar);
		
		EM.m_FormMenu.Add();
		
//		EM.m_FormMenu.Add(Common.Txt.FormMenuTraining, clickTraining);
//		EM.m_FormMenu.Add(Common.Txt.FormMenuAdviser, clickAdviser);
		
		EM.m_FormMenu.Add();
		
		CONFIG::player {
			if (EM.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE || EM.stage.displayState == StageDisplayState.FULL_SCREEN) EM.m_FormMenu.Add(Common.Txt.FormMenuNormalScreen, FullScreen);
			else EM.m_FormMenu.Add(Common.Txt.FormMenuFullScreen, FullScreen);
		}
		CONFIG::air {
			if (EM.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE || EM.stage.displayState == StageDisplayState.FULL_SCREEN) EM.m_FormMenu.Add(Common.Txt.FormMenuNormalScreen, FullScreen);
			else EM.m_FormMenu.Add(Common.Txt.FormMenuFullScreen, FullScreen);
		}

		EM.m_FormMenu.Add(Common.Txt.FormMenuSet, clickSet);
		EM.m_FormMenu.Add(Common.Txt.FormMenuCotlJump, clickCotlJump);
		EM.m_FormMenu.Add(Common.Txt.FormMenuCotlNew, clickCotlNew);

		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);

		if (user != null && user.m_Rating >= 5500 && (EmpireMap.Self.m_UserFlag & Common.UserFlagAccountTmp)) EM.m_FormMenu.Add(Common.Txt.FormRegMenu, clickReg);
		if (!(EmpireMap.Self.m_UserFlag & Common.UserFlagAccountTmp)) EM.m_FormMenu.Add(Common.Txt.FormBuyNameMenu, clickBuyName);
		if (!(EmpireMap.Self.m_UserFlag & Common.UserFlagAccountTmp) && !EmpireMap.Self.m_UserExistClone) EM.m_FormMenu.Add(Common.Txt.FormRegCloneMenu, clickRegClone);

		EM.m_FormMenu.Add(Common.Txt.FormMenuExit, clickExit);

		EM.m_FormMenu.SetButOpen(m_ButSet);
		EM.m_FormMenu.Show(x + m_ButSet.x + m_ButSet.width, y + m_ButSet.y, x + m_ButSet.x + m_ButSet.width, y + m_ButSet.y + m_ButSet.height);
	}
	
	public function clickBuyName(...args):void
	{
		EmpireMap.Self.m_FormEnter.BuyNameRun();
	}
	
	public function clickRegClone(...args):void
	{
		EmpireMap.Self.m_FormEnter.RegCloneRun();
	}
	
	public function clickReg(...args):void
	{
		EmpireMap.Self.m_FormEnter.RegEmailRun();
	}
	
	public function FullScreen(...args):void
	{
		CONFIG::player {
			if (EM.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE || EM.stage.displayState == StageDisplayState.FULL_SCREEN) EM.stage.displayState = StageDisplayState.NORMAL;
			else EM.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		CONFIG::air {
			if (EM.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE || EM.stage.displayState == StageDisplayState.FULL_SCREEN) EM.stage.displayState = StageDisplayState.NORMAL;
			else EM.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
	}
}

}