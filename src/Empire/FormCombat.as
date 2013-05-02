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
import flash.system.*;

public class FormCombat extends Sprite
{
	private var EM:EmpireMap = null;

	static public const SizeX:int = 500;
	static public const SizeYMax:int=540;
	public var m_SizeY:int = SizeYMax;
	
	public var m_ModeCombat:int=-1;
	public var m_ModeStat:int=-1;
	public var m_ModeRes:int=-1;

	public var m_ModeCur:int = 0;
	public var m_ModeMouse:int=-1;

	public var m_Modes:Array=new Array();

	public static const ItemSlotSize:int = 44;

	public var m_Frame:Sprite=new GrFrame();
	public var m_Title:TextField = new TextField();
	public var m_Features:TextField = new TextField();
	public var m_ButClose:Button = new Button();
	public var m_ButLeave:Button = new Button();
	public var m_ButReady:Button = new Button();
	public var m_ButEnter:Button = new Button();
	public var m_Status:TextField = new TextField();
	
	public var m_AtkCaption:TextField = new TextField();
	public var m_AtkFrame:Sprite = new GrGridRowHeader();
	public var m_AtkUser:TextField = new TextField();
	public var m_AtkRating:TextField = new TextField();
	public var m_AtkMass:TextField = new TextField();
	public var m_AtkLost:TextField = new TextField();
	public var m_AtkDestroy:TextField = new TextField();
	public var m_AtkDamage:TextField = new TextField();
	public var m_AtkModule:TextField = new TextField();
	public var m_AtkExp:TextField = new TextField();
	public var m_DefCaption:TextField = new TextField();
	public var m_DefFrame:Sprite = new GrGridRowHeader();
	public var m_DefUser:TextField = new TextField();
	public var m_DefRating:TextField = new TextField();
	public var m_DefMass:TextField = new TextField();
	public var m_DefLost:TextField = new TextField();
	public var m_DefDestroy:TextField = new TextField();
	public var m_DefDamage:TextField = new TextField();
	public var m_DefModule:TextField = new TextField();
	public var m_DefExp:TextField = new TextField();

	public var m_ItemCaption:TextField = new TextField();
	public var m_TakeCaption:TextField = new TextField();

	public var m_Layer:Sprite = new Sprite();

    static public const ReadyCapTime:int = 5;
	static public const ForcedStartTime:int = 120;

	static public const FlagReady:int = 1;
	static public const FlagPrepare:int = 2;
	static public const FlagAtkReady:int = 4;
	static public const FlagDefReady:int = 8;
	static public const FlagAtkWin:int = 16;
	static public const FlagDefWin:int = 32;
	static public const FlagDuel:int = 64;
	static public const FlagRandom:int = 128; // Сражение. Рандомнаня битва игроков. Без потери лута.
	static public const FlagFlagship:int = 256; // В битву допускаются флагманы.

	static public const FlagLootTake:uint = 1;
	static public const FlagLootTakeQuery:uint = 0x40000000;

	static public const ExpCombatMul:uint = 256;
	static public const ExpDuelMul:uint = 26;
	static public const ExpRandomMul:uint = 128;

	static public const ModuleCombatMul:uint = 128;
	static public const ModuleDuelMul:uint = 230;
	static public const ModuleRandomMul:uint = 205;

	public var m_CombatId:uint = 0;
	public var m_CombatVer:uint = 0;
	public var m_CombatCreateTime:Number = 0;
	public var m_CombatFlag:uint = 0;
	public var m_CombatCotlId:uint = 0;
	public var m_CombatStateTime:Number = 0;
	public var m_CombatAtkUser:Vector.<CombatUser> = new Vector.<CombatUser>(CombatUser.UserMax, true);
	public var m_CombatDefUser:Vector.<CombatUser> = new Vector.<CombatUser>(CombatUser.UserMax, true);
	
	public var m_CombatLoot:Vector.<Object> = new Vector.<Object>(CombatUser.UserMax*CombatUser.LootPerUser, true);

	public var m_CombatStat:Array = new Array();
	
	public var m_SendStart:Boolean = false;

	public var m_LoadCombatAfterAnm:uint=0;
	public var m_LoadCombatAfterAnm_Time:Number = 0;

	public var m_UserList:Array = new Array();
	
	public var m_CurUser:uint = 0;
	
	public var m_UpdateTimer:Timer = new Timer(500);
	
	public var m_ShowAfterEnd:Boolean = true;
	
	public var m_ItemList:Array = new Array();

	public var m_TakeList:Array = new Array();

	//public var m_LastUpdateCombatId:uint = 0;

	//public var m_ItemCur:int = -1;
	public var m_ItemMouse:int = -1;
	public var m_TakeMouse:int = -1;
	
	public function FormCombat(map:EmpireMap)
	{
		var i:int;
		
		for (i = 0; i < CombatUser.UserMax; i++) {
			m_CombatAtkUser[i] = new CombatUser(); 
			m_CombatDefUser[i] = new CombatUser(); 
		}
		
		for (i = 0; i < CombatUser.UserMax * CombatUser.LootPerUser; i++) {
			m_CombatLoot[i] = new Object();
			m_CombatLoot[i].m_Type = uint(0);
			m_CombatLoot[i].m_Cnt = 0;
			m_CombatLoot[i].m_OwnerId = uint(0);
			m_CombatLoot[i].m_Broken = 0;
			m_CombatLoot[i].m_Flag = uint(0);
		}
		
		EM = map;
		
		m_Frame.width=SizeX;
		m_Frame.height=SizeYMax;
		addChild(m_Frame);

		m_Layer.mouseChildren = false;
		m_Layer.mouseEnabled = false;
		addChild(m_Layer);

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
		
		m_Features.x=10;
		m_Features.y=27;
		m_Features.width=1;
		m_Features.height=1;
		m_Features.type=TextFieldType.DYNAMIC;
		m_Features.selectable=false;
		m_Features.border=false;
		m_Features.background=false;
		m_Features.multiline=false;
		m_Features.autoSize=TextFieldAutoSize.LEFT;
		m_Features.antiAliasType=AntiAliasType.ADVANCED;
		m_Features.gridFitType=GridFitType.PIXEL;
		m_Features.defaultTextFormat=new TextFormat("Calibri",14,0xaaf4ff);
		m_Features.embedFonts=true;
		addChild(m_Features);

		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width = 90;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		addChild(m_ButClose);

		m_ButReady.label = Common.Txt.FormCombatReady;
		m_ButReady.width = 120;
		Common.UIStdBut(m_ButReady);
		m_ButReady.addEventListener(MouseEvent.CLICK, clickReady);
		addChild(m_ButReady);

		m_ButEnter.label = Common.Txt.FormCombatEnter;
		m_ButEnter.width = 120;
		Common.UIStdBut(m_ButEnter);
		m_ButEnter.addEventListener(MouseEvent.CLICK, clickEnter);
		addChild(m_ButEnter);
		
		m_ButLeave.label = Common.Txt.FormCombatLeave;
		m_ButLeave.width = 120;
		Common.UIStdBut(m_ButLeave);
		m_ButLeave.addEventListener(MouseEvent.CLICK, clickLeave);
		addChild(m_ButLeave);
		
		m_Status.width=1;
		m_Status.height=1;
		m_Status.type=TextFieldType.DYNAMIC;
		m_Status.selectable=false;
		m_Status.border=false;
		m_Status.background=false;
		m_Status.multiline=false;
		m_Status.autoSize=TextFieldAutoSize.LEFT;
		m_Status.antiAliasType=AntiAliasType.ADVANCED;
		m_Status.gridFitType=GridFitType.PIXEL;
		m_Status.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_Status.embedFonts=true;
		addChild(m_Status);

		addChild(m_AtkFrame);

		m_AtkCaption.width=1;
		m_AtkCaption.height=1;
		m_AtkCaption.type=TextFieldType.DYNAMIC;
		m_AtkCaption.selectable=false;
		m_AtkCaption.border=false;
		m_AtkCaption.background=false;
		m_AtkCaption.multiline=false;
		m_AtkCaption.autoSize=TextFieldAutoSize.LEFT;
		m_AtkCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_AtkCaption.gridFitType=GridFitType.PIXEL;
		m_AtkCaption.defaultTextFormat=new TextFormat("Calibri",17,0xaaf4ff);
		m_AtkCaption.embedFonts=true;
		m_AtkCaption.text = Common.Txt.FormCombatAtkCaption;
		addChild(m_AtkCaption);

		m_AtkUser.width=1;
		m_AtkUser.height=1;
		m_AtkUser.type=TextFieldType.DYNAMIC;
		m_AtkUser.selectable=false;
		m_AtkUser.border=false;
		m_AtkUser.background=false;
		m_AtkUser.multiline=false;
		m_AtkUser.autoSize=TextFieldAutoSize.LEFT;
		m_AtkUser.antiAliasType=AntiAliasType.ADVANCED;
		m_AtkUser.gridFitType=GridFitType.PIXEL;
		m_AtkUser.defaultTextFormat=new TextFormat("Calibri",15,0xaaf4ff);
		m_AtkUser.embedFonts=true;
		m_AtkUser.text = Common.Txt.FormCombatUser;
		addChild(m_AtkUser);
		
		m_AtkRating.width=1;
		m_AtkRating.height=1;
		m_AtkRating.type=TextFieldType.DYNAMIC;
		m_AtkRating.selectable=false;
		m_AtkRating.border=false;
		m_AtkRating.background=false;
		m_AtkRating.multiline=false;
		m_AtkRating.autoSize=TextFieldAutoSize.LEFT;
		m_AtkRating.antiAliasType=AntiAliasType.ADVANCED;
		m_AtkRating.gridFitType=GridFitType.PIXEL;
		m_AtkRating.defaultTextFormat=new TextFormat("Calibri",15,0xaaf4ff);
		m_AtkRating.embedFonts=true;
		m_AtkRating.text = Common.Txt.FormCombatRating;
		addChild(m_AtkRating);

		m_AtkMass.width=1;
		m_AtkMass.height=1;
		m_AtkMass.type=TextFieldType.DYNAMIC;
		m_AtkMass.selectable=false;
		m_AtkMass.border=false;
		m_AtkMass.background=false;
		m_AtkMass.multiline=false;
		m_AtkMass.autoSize=TextFieldAutoSize.LEFT;
		m_AtkMass.antiAliasType=AntiAliasType.ADVANCED;
		m_AtkMass.gridFitType=GridFitType.PIXEL;
		m_AtkMass.defaultTextFormat=new TextFormat("Calibri",15,0xaaf4ff);
		m_AtkMass.embedFonts=true;
		m_AtkMass.text = Common.Txt.FormCombatMass;
		addChild(m_AtkMass);

		addChild(m_AtkLost); StyleLabelTableHeader(m_AtkLost, Common.Txt.FormCombatLost);
		addChild(m_AtkDestroy); StyleLabelTableHeader(m_AtkDestroy, Common.Txt.FormCombatDestroy);
		addChild(m_AtkDamage); StyleLabelTableHeader(m_AtkDamage, Common.Txt.FormCombatDamage);
		addChild(m_AtkModule); StyleLabelTableHeader(m_AtkModule, Common.Txt.FormCombatModule);
		addChild(m_AtkExp); StyleLabelTableHeader(m_AtkExp, Common.Txt.FormCombatExp);

		addChild(m_DefFrame);

		m_DefCaption.width=1;
		m_DefCaption.height=1;
		m_DefCaption.type=TextFieldType.DYNAMIC;
		m_DefCaption.selectable=false;
		m_DefCaption.border=false;
		m_DefCaption.background=false;
		m_DefCaption.multiline=false;
		m_DefCaption.autoSize=TextFieldAutoSize.LEFT;
		m_DefCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_DefCaption.gridFitType=GridFitType.PIXEL;
		m_DefCaption.defaultTextFormat=new TextFormat("Calibri",17,0xaaf4ff);
		m_DefCaption.embedFonts = true;
		m_DefCaption.text = Common.Txt.FormCombatDefCaption;
		addChild(m_DefCaption);
		
		m_DefUser.width=1;
		m_DefUser.height=1;
		m_DefUser.type=TextFieldType.DYNAMIC;
		m_DefUser.selectable=false;
		m_DefUser.border=false;
		m_DefUser.background=false;
		m_DefUser.multiline=false;
		m_DefUser.autoSize=TextFieldAutoSize.LEFT;
		m_DefUser.antiAliasType=AntiAliasType.ADVANCED;
		m_DefUser.gridFitType=GridFitType.PIXEL;
		m_DefUser.defaultTextFormat=new TextFormat("Calibri",15,0xaaf4ff);
		m_DefUser.embedFonts = true;
		m_DefUser.text = Common.Txt.FormCombatUser;
		addChild(m_DefUser);

		m_DefRating.width=1;
		m_DefRating.height=1;
		m_DefRating.type=TextFieldType.DYNAMIC;
		m_DefRating.selectable=false;
		m_DefRating.border=false;
		m_DefRating.background=false;
		m_DefRating.multiline=false;
		m_DefRating.autoSize=TextFieldAutoSize.LEFT;
		m_DefRating.antiAliasType=AntiAliasType.ADVANCED;
		m_DefRating.gridFitType=GridFitType.PIXEL;
		m_DefRating.defaultTextFormat=new TextFormat("Calibri",15,0xaaf4ff);
		m_DefRating.embedFonts=true;
		m_DefRating.text = Common.Txt.FormCombatRating;
		addChild(m_DefRating);

		m_DefMass.width=1;
		m_DefMass.height=1;
		m_DefMass.type=TextFieldType.DYNAMIC;
		m_DefMass.selectable=false;
		m_DefMass.border=false;
		m_DefMass.background=false;
		m_DefMass.multiline=false;
		m_DefMass.autoSize=TextFieldAutoSize.LEFT;
		m_DefMass.antiAliasType=AntiAliasType.ADVANCED;
		m_DefMass.gridFitType=GridFitType.PIXEL;
		m_DefMass.defaultTextFormat=new TextFormat("Calibri",15,0xaaf4ff);
		m_DefMass.embedFonts=true;
		m_DefMass.text = Common.Txt.FormCombatMass;
		addChild(m_DefMass);

		addChild(m_DefLost); StyleLabelTableHeader(m_DefLost, Common.Txt.FormCombatLost);
		addChild(m_DefDestroy); StyleLabelTableHeader(m_DefDestroy, Common.Txt.FormCombatDestroy);
		addChild(m_DefDamage); StyleLabelTableHeader(m_DefDamage, Common.Txt.FormCombatDamage);
		addChild(m_DefModule); StyleLabelTableHeader(m_DefModule, Common.Txt.FormCombatModule);
		addChild(m_DefExp); StyleLabelTableHeader(m_DefExp, Common.Txt.FormCombatExp);

		m_ItemCaption.width=1;
		m_ItemCaption.height=1;
		m_ItemCaption.type=TextFieldType.DYNAMIC;
		m_ItemCaption.selectable=false;
		m_ItemCaption.border=false;
		m_ItemCaption.background=false;
		m_ItemCaption.multiline=false;
		m_ItemCaption.autoSize=TextFieldAutoSize.LEFT;
		m_ItemCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_ItemCaption.gridFitType=GridFitType.PIXEL;
		m_ItemCaption.defaultTextFormat=new TextFormat("Calibri",17,0xaaf4ff);
		m_ItemCaption.embedFonts=true;
		addChild(m_ItemCaption);

		m_TakeCaption.width=1;
		m_TakeCaption.height=1;
		m_TakeCaption.type=TextFieldType.DYNAMIC;
		m_TakeCaption.selectable=false;
		m_TakeCaption.border=false;
		m_TakeCaption.background=false;
		m_TakeCaption.multiline=false;
		m_TakeCaption.autoSize=TextFieldAutoSize.LEFT;
		m_TakeCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_TakeCaption.gridFitType=GridFitType.PIXEL;
		m_TakeCaption.defaultTextFormat=new TextFormat("Calibri",17,0xaaf4ff);
		m_TakeCaption.embedFonts=true;
		addChild(m_TakeCaption);
		
		ModeClear();
		m_ModeCombat = ModeAdd(Common.Txt.FormCombatModeCombat);
		m_ModeStat = ModeAdd(Common.Txt.FormCombatModeStat);
		m_ModeRes = ModeAdd(Common.Txt.FormCombatModeRes);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
		
		m_UpdateTimer.addEventListener("timer",UpdateTimer);
	}

	public function StyleLabelTableHeader(t:TextField, str:String):void
	{
		t.width=1;
		t.height=1;
		t.type=TextFieldType.DYNAMIC;
		t.selectable=false;
		t.border=false;
		t.background=false;
		t.multiline=false;
		t.autoSize=TextFieldAutoSize.LEFT;
		t.antiAliasType=AntiAliasType.ADVANCED;
		t.gridFitType=GridFitType.PIXEL;
		t.defaultTextFormat=new TextFormat("Calibri",15,0xaaf4ff);
		t.embedFonts=true;
		t.text = str;
	}
	
	public function StyleLabelTable(t:TextField):void
	{
		t.width=1;
		t.height=1;
		t.type=TextFieldType.DYNAMIC;
		t.selectable=false;
		t.border=false;
		t.background=false;
		t.multiline=false;
		t.autoSize=TextFieldAutoSize.LEFT;
		t.antiAliasType=AntiAliasType.ADVANCED;
		t.gridFitType=GridFitType.PIXEL;
		t.defaultTextFormat=new TextFormat("Calibri",13,0xaaf4ff);
		t.embedFonts = true;
		t.mouseEnabled = false;
	}
		
	public function ClearForNewConn():void
	{
		var i:int;
		m_CombatVer = 0;
		m_CombatFlag = 0;
		m_CombatCotlId = 0;
		m_CombatStateTime = 0;
		for (i = 0; i < CombatUser.UserMax; i++) {
			m_CombatAtkUser[i].Clear();
			m_CombatDefUser[i].Clear();
		}
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
		var p:Object;
		var sx:int=SizeX-50;
		var sy:int=-25;
		
		var find:Boolean = false;
		var fv:int = -1;
		for (i = 0; i < m_Modes.length; i++) {
			p=m_Modes[i];

			p.Visible = false;
			if (i == m_ModeCombat) p.Visible = true;
			else if (i == m_ModeStat && m_CombatStat.length > 0) p.Visible = true;
			else if (i == m_ModeRes && m_CombatStat.length > 0) p.Visible = true;
			
			if (p.Visible && m_ModeCur == i) find = true;
			if (p.Visible && (fv < 0)) fv = i;
		}

		if (!find) m_ModeCur = fv;

		for (i = m_Modes.length - 1; i >= 0; i--) {
			p=m_Modes[i];

			var b:FormWinPage=p.BG;
			var l:TextField = p.Label;
			
			b.visible = p.Visible;
			l.visible = p.Visible;
			
			if (!p.Visible) continue;
			
			if(i==m_ModeMouse && i==m_ModeCur) b.gotoAndStop(4);
			else if(i==m_ModeCur) b.gotoAndStop(2);
			else if(i==m_ModeMouse) b.gotoAndStop(3);
			else b.gotoAndStop(1);

			sx -= b.width + 1;

			b.x=sx;
			b.y=sy;

			l.x=sx+5;
			l.y=sy+5;

		}
	}

	public function ModePick():int
	{
		var i:int;
		var p:Object;
		for(i=0;i<m_Modes.length;i++) {
			p = m_Modes[i];
			
			if (!p.Visible) continue;
			
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
		var i:int=ModePick();
		if(i>=0) {
			if(i!=m_ModeCur) {
				ChangeMode(i);
			}
		}
	}
	
	public function ChangeMode(m:int):void
	{
		m_ModeCur = m;
		Update();
	}
	
	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		EM.FloatTop(this);

		if (FormMessageBox.Self.visible) return;

		if (m_ButClose.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_ButLeave.visible && m_ButLeave.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_ButReady.visible && m_ButReady.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_ButEnter.visible && m_ButEnter.hitTestPoint(e.stageX, e.stageY)) return;
		if(ModePick()>=0) return;
		
		var id:uint = PickUser();
		if (id != m_CurUser) {
			m_CurUser = id;
			Update();
		}
		if (id != 0) {
			MenuUser();
			return;
		}
		
		var no:int = PickItem();
		if (m_ItemMouse != no) {
			m_ItemMouse = no;
			Update();
		}
		if (m_ItemMouse >= 0) {
			var obj:Object = GetGraphByItem(m_ItemMouse);
			if (obj != null) MenuItem();
			return;
		}
		if (no >= 0) return;
		
		if (PickTake()>=0) return;

		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}
	
	public function onMouseMove(e:MouseEvent) : void
	{
		var obj:Object;
		
		e.stopImmediatePropagation();

		if (EM.m_FormMenu.visible) return;

		var hideinfo:Boolean = true;
		
		var id:uint = PickUser();
		if (id != m_CurUser) {
			m_CurUser = id;
			Update();
		}
		
		var no:int = PickItem();
		if (m_ItemMouse != no) {
			m_ItemMouse = no;
			Update();
		}
		
		if (m_ItemMouse >= 0) {
			obj = GetGraphByItem(m_ItemMouse);
			if(obj!=null) {
				EM.m_Info.ShowItemEx(obj, m_CombatLoot[no].m_Type, m_CombatLoot[no].m_Cnt, obj.ItemOwner, 0, 0, x+obj.SlotN.x, y+obj.SlotN.y, ItemSlotSize, ItemSlotSize);
				hideinfo = false;
			}
		}

		no = PickTake();
		if (m_TakeMouse != no) {
			m_TakeMouse = no;
			Update();
		}

		if (m_TakeMouse >= 0) {
			obj = GetGraphByTake(m_TakeMouse);
			if(obj!=null) {
				EM.m_Info.ShowItemEx(obj, m_CombatLoot[no].m_Type, m_CombatLoot[no].m_Cnt, obj.ItemOwner, 0, 0, x+obj.SlotN.x, y+obj.SlotN.y, ItemSlotSize, ItemSlotSize);
				hideinfo = false;
			}
		}

		if (hideinfo) EM.m_Info.Hide();
	}

	protected function onMouseOutHandler(event:MouseEvent) : void
	{
		if (FormMessageBox.Self.visible) return;
		if (EM.m_FormInput.visible) return;
		if (EM.m_FormMenu.visible) return;
		
		if (m_CurUser != 0 || m_ItemMouse>=0 || m_TakeMouse>=0) {
			m_CurUser = 0;
			m_ItemMouse = -1;
			m_TakeMouse = -1;
			Update();
		}
	}

	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) {
		
		x = (stage.stageWidth >> 1) - (SizeX >> 1);
		y = (stage.stageHeight >> 1) - (SizeYMax >> 1);
	}
	
	public function clickClose(...args):void
	{
		if(EM.m_FormInput.visible) return;
		if (FormMessageBox.Self.visible) return;
		
		Hide();
	}
	
	public function ShowEx(combatid:uint):void
	{
		if (combatid == 0) {
			if (visible) Hide();
		} else if (combatid == m_CombatId) {
			if (!visible) ShowSys();
		} else {
			if (visible) Hide();
			m_CombatId = combatid;
			ShowSys();
		}
	}
	
	public function ShowSys():void
	{
		var i:int;
		
		m_SendStart = false;

		EM.FloatTop(this);

		visible = true;
		m_UpdateTimer.start();
		
		StageResize();
		
		m_CurUser = 0;

		QueryCombat();
		Update();
	}

	public function Hide():void
	{
		var i:int;
		
		visible = false;
		//m_LastUpdateCombatId = 0;
		m_LoadCombatAfterAnm=0;
		m_LoadCombatAfterAnm_Time=0;
		
		m_CombatVer = 0;
		m_CombatCreateTime = 0;
		m_CombatFlag = 0;
		m_CombatCotlId = 0;
		m_CombatStateTime = 0;
		for (i = 0; i < CombatUser.UserMax; i++) {
			m_CombatAtkUser[i].Clear();
			m_CombatDefUser[i].Clear();
		}

		for (i = 0; i < CombatUser.UserMax * CombatUser.LootPerUser; i++) {
			m_CombatLoot[i].m_Type = uint(0);
			m_CombatLoot[i].m_Cnt = 0;
			m_CombatLoot[i].m_OwnerId = uint(0);
			m_CombatLoot[i].m_Broken = 0;
			m_CombatLoot[i].m_Flag = uint(0);
		}
		
		m_CombatStat.length = 0;
		
		m_UpdateTimer.stop();
		Clear();
	}
	
	private function sortUserListCB(a:Object, b:Object):int
	{
		if (a.Type < b.Type) return -1;
		else if (a.Type > b.Type) return 1;
		else if (a.Num < b.Num) return -1;
		else if (a.Num > b.Num) return 1;
		return 0;
	}
	
	public function UpdateTimer(event:TimerEvent = null):void
	{
		QueryCombat();
		Update();
	}
	
	public function Clear():void
	{
		var i:int;
		var obj:Object;

		//m_ItemCur = -1;
		m_ItemMouse = -1;
		m_TakeMouse = -1;
		
		for (i = m_ItemList.length - 1; i >= 0; i--) {
			obj = m_ItemList[i];
			m_ItemList.splice(i, 1);

			if (obj.SlotN != null) { m_Layer.removeChild(obj.SlotN); obj.SlotN = null; }
			if (obj.SlotE != null) { m_Layer.removeChild(obj.SlotE); obj.SlotE = null; }
			if (obj.SlotA != null) { m_Layer.removeChild(obj.SlotA); obj.SlotA = null; }
			if (obj.Img != null) { m_Layer.removeChild(obj.Img); obj.Img = null; }
			if (obj.Txt != null) { m_Layer.removeChild(obj.Txt); obj.Txt = null; }
		}

		for (i = m_TakeList.length - 1; i >= 0; i--) {
			obj = m_TakeList[i];
			m_TakeList.splice(i, 1);

			if (obj.SlotN != null) { m_Layer.removeChild(obj.SlotN); obj.SlotN = null; }
			if (obj.SlotE != null) { m_Layer.removeChild(obj.SlotE); obj.SlotE = null; }
			if (obj.SlotA != null) { m_Layer.removeChild(obj.SlotA); obj.SlotA = null; }
			if (obj.Img != null) { m_Layer.removeChild(obj.Img); obj.Img = null; }
			if (obj.Txt != null) { m_Layer.removeChild(obj.Txt); obj.Txt = null; }
		}
	}

	public function Update():void
	{
		var i:int, u:int, t:int, k:int;
		var obj:Object;
		var cb:CombatUser;
		var user:User;
		var str:String;
		var item:Item;
		var cs:Object;

		if (!visible) return;

		if (m_CombatId == 0) { Hide(); return; }

		//if (m_LastUpdateCombatId != EM.m_CombatId) {
		//	m_LastUpdateCombatId = EM.m_CombatId;
		//	Clear();
		//}

		ModeUpdate();

		if (m_CombatFlag & FlagRandom) str = Common.Txt.FormCombatCaptionBattle;
		else if(m_CombatFlag & FlagDuel) str = Common.Txt.FormCombatCaptionDuel;
		else str = Common.Txt.FormCombatCaptionCombat;

		if (m_CombatFlag & FlagFlagship) str += " [clr]" +Common.Txt.FormCombatCaptionFlagship + "[/clr]";

		m_Title.htmlText = BaseStr.FormatTag(str);

		if (m_CombatAtkUser[0].m_Id == 0 && m_CombatDefUser[0].m_Id == 0) m_Features.htmlText = "";
		else if (m_CombatFlag & FlagRandom) m_Features.htmlText = BaseStr.FormatTag(Common.Txt.FormCombatFeaturesBattle);
		else if (m_CombatFlag & FlagDuel) m_Features.htmlText = BaseStr.FormatTag(Common.Txt.FormCombatFeaturesDuel);
		else m_Features.htmlText = BaseStr.FormatTag(Common.Txt.FormCombatFeaturesCombat);

		var showstat:Boolean = m_CombatStat.length > 0;

		var inwin:Boolean = false;
		var inloss:Boolean = false;
		if ((m_CombatFlag & FlagAtkWin) != 0 && (m_CombatFlag & FlagDefWin) == 0) {
			for (i = 0; i < CombatUser.UserMax;i++) {
				if (m_CombatAtkUser[i].m_Id == Server.Self.m_UserId) { inwin = true; }
				if (m_CombatDefUser[i].m_Id == Server.Self.m_UserId) { inloss = true; }
			}
		} else if ((m_CombatFlag & FlagDefWin) != 0 && (m_CombatFlag & FlagAtkWin) == 0) {
			for (i = 0; i < CombatUser.UserMax; i++) {
				if (m_CombatDefUser[i].m_Id == Server.Self.m_UserId) { inwin = true; }
				if (m_CombatAtkUser[i].m_Id == Server.Self.m_UserId) { inloss = true; }
			}
		}

		// User
		for (i = 0; i < m_UserList.length; i++) {
			obj = m_UserList[i];
			obj.Tmp = 0;
		}

		var dsum:int = 0;
		for (u = 0; u < m_CombatStat.length; u++) {
			cs = m_CombatStat[u];
			dsum += cs.m_DamageCorvette + cs.m_DamageCruiser + cs.m_DamageDreadnought + cs.m_DamageDevastator + cs.m_DamageFlagship;
		}
		if (dsum <= 0) dsum = 1;

		for (t = 0; t <= 1; t++) {
			for (i = 0; i < CombatUser.UserMax; i++) {
				if (t==0) cb = m_CombatAtkUser[i];
				else cb = m_CombatDefUser[i];
				
				if (cb.m_Id == 0) continue;

				for (u = 0; u < m_UserList.length; u++) {
					obj = m_UserList[u];
					if (obj.Type == t && obj.Num == i) break;
				}
				if (u >= m_UserList.length) {
					obj = new Object();
					obj.Type = t;
					obj.Num = i;
					m_UserList.push(obj);
					
					obj.FrameN = new GrGridRowNormal();
					obj.FrameN.mouseEnabled = false;
					addChild(obj.FrameN);

					obj.FrameA = new GrGridRowMark();
					obj.FrameA.mouseEnabled = false;
					addChild(obj.FrameA);
					
					obj.Access = new BOK_upSkin();
					addChild(obj.Access);

					obj.Name = new TextField();
					StyleLabelTable(obj.Name);
					addChild(obj.Name);

					obj.Rating = new TextField();
					StyleLabelTable(obj.Rating);
					addChild(obj.Rating);

					obj.Mass = new TextField();
					StyleLabelTable(obj.Mass);
					addChild(obj.Mass);

					obj.Lost = new TextField();
					StyleLabelTable(obj.Lost);
					addChild(obj.Lost);

					obj.Destroy = new TextField();
					StyleLabelTable(obj.Destroy);
					addChild(obj.Destroy);

					obj.Damage = new TextField();
					StyleLabelTable(obj.Damage);
					addChild(obj.Damage);

					obj.Module = new TextField();
					StyleLabelTable(obj.Module);
					addChild(obj.Module);

					obj.Exp = new TextField();
					StyleLabelTable(obj.Exp);
					addChild(obj.Exp);
				}

				obj.Tmp = 1;
				obj.Id = cb.m_Id;

				user = UserList.Self.GetUser(cb.m_Id);
				str = EmpireMap.Self.Txt_CotlOwnerName(0, cb.m_Id);
				//if (user == null) str = "-";
				//else str = user.m_Name;
				//if (cb.m_Flag & CombatUser.FlagUserHomeJump) str += " [crt]" + Common.Txt.FormCombatReturn + "[/crt]";
				obj.Name.htmlText = BaseStr.FormatTag(str);

				str = cb.m_CombatRating.toString();
				if (cb.m_ChangeRating < 0) str += "<font color='#ff0000'> - " + ( -cb.m_ChangeRating).toString() + "</font>";
				else if (cb.m_ChangeRating > 0) str += "<font color='#00ff00'> + " + ( cb.m_ChangeRating).toString() + "</font>";
				obj.Rating.htmlText = str;

				if ((cb.m_Flag & CombatUser.FlagUserAccess) == 0) obj.Mass.text = "-";
				else obj.Mass.text = BaseStr.FormatBigInt(cb.m_Mass);

				for (u = 0; u < m_CombatStat.length; u++) {
					cs = m_CombatStat[u];
					if (cs.m_AccountId == cb.m_Id) break;
				}

				if (u >= m_CombatStat.length) {
					obj.Lost.text = "-";
					obj.Destroy.text = "-";
					obj.Damage.text = "-";
					obj.Module.text = "-";
					obj.Exp.text = "-";
				} else {
					obj.Lost.text = BaseStr.FormatBigInt(cs.m_MassLost);
					obj.Destroy.text = BaseStr.FormatBigInt(cs.m_MassDestroy);

					obj.Damage.text = 
						(Math.round(100 * cs.m_DamageCorvette / dsum) ).toString()
						+"/" + (Math.round(100 * cs.m_DamageCruiser / dsum) ).toString()
						+"/" + (Math.round(100 * cs.m_DamageDreadnought / dsum) ).toString()
						+"/" + (Math.round(100 * cs.m_DamageDevastator / dsum) ).toString()
						+"/" + (Math.round(100 * cs.m_DamageFlagship / dsum) ).toString();

					obj.Module.text = BaseStr.FormatBigInt(cs.m_Module);

					str = BaseStr.FormatBigInt(cs.m_ExpReceive);
					if (cb.m_Id == Server.Self.m_UserId && (EM.m_Access & Common.AccessPlusarCaptain) != 0 && ((EM.m_UserCaptainEnd > EM.GetServerGlobalTime()) || (EM.m_UserControlEnd > EM.GetServerGlobalTime()))) str += " + " + BaseStr.FormatBigInt(cs.m_ExpReceive);
					obj.Exp.text = str;
				}

				obj.Access.visible = (cb.m_Flag & CombatUser.FlagUserAccess) != 0;
			}
		}

		for (i = m_UserList.length - 1; i >= 0; i--) {
			obj = m_UserList[i];
			if (obj.Tmp != 0) continue;
			m_UserList.splice(i, 1);

			removeChild(obj.Access); obj.Access = null;
			removeChild(obj.Name); obj.Name = null;
			removeChild(obj.FrameN); obj.FrameN = null;
			removeChild(obj.FrameA); obj.FrameA = null;
			removeChild(obj.Rating); obj.Rating = null;
			removeChild(obj.Mass); obj.Mass = null;
			removeChild(obj.Lost); obj.Lost = null;
			removeChild(obj.Destroy); obj.Destroy = null;
			removeChild(obj.Damage); obj.Damage = null;
			removeChild(obj.Module); obj.Module = null;
			removeChild(obj.Exp); obj.Exp = null;
		}

		var sizey:int = 70 - 25;

		m_AtkCaption.visible = false;
		m_AtkFrame.visible = false;
		m_AtkUser.visible = false;
		m_AtkRating.visible = false;
		m_AtkMass.visible = false;
		m_AtkLost.visible = false;
		m_AtkDestroy.visible = false;
		m_AtkDamage.visible = false;
		m_AtkModule.visible = false;
		m_AtkExp.visible = false;

		m_DefCaption.visible = false;
		m_DefFrame.visible = false;
		m_DefUser.visible = false;
		m_DefRating.visible = false;
		m_DefMass.visible = false;
		m_DefLost.visible = false;
		m_DefDestroy.visible = false;
		m_DefDamage.visible = false;
		m_DefModule.visible = false;
		m_DefExp.visible = false;

		t = -1;
		m_UserList.sort(sortUserListCB);
		for (i = 0; i < m_UserList.length; i++) {
			obj = m_UserList[i];

			if (t != obj.Type) {
				t = obj.Type;

				sizey += 25;

				if (t == 0) {
					m_AtkCaption.visible = true;
					m_AtkCaption.x = 20;
					m_AtkCaption.y = sizey;
					str = Common.Txt.FormCombatAtkCaption;
					if (m_CombatFlag & FlagAtkWin) str += " (<font color='#00ff00'>" + Common.Txt.FormCombatWin + "</font>)";
					else if(m_CombatFlag & FlagDefWin) str += " (<font color='#ff0000'>" + Common.Txt.FormCombatLoss + "</font>)";
					else if ((m_CombatFlag & FlagAtkReady) && (m_CombatFlag & FlagReady)==0) str += " ([clr]" + Common.Txt.FormCombatReadyShow + "[/clr])";
					m_AtkCaption.htmlText = BaseStr.FormatTag(str);
					sizey += 25;

					m_AtkFrame.visible = true;
					m_AtkFrame.x = 20;
					m_AtkFrame.y = sizey;
					m_AtkFrame.width = SizeX - 40;
					m_AtkFrame.height = 30;

					m_AtkUser.visible = true;
					m_AtkUser.x = 30;
					m_AtkUser.y = sizey + 5;
					
					m_AtkRating.visible = m_ModeCur == m_ModeCombat;
					m_AtkRating.x = 260;
					m_AtkRating.y = sizey + 5;
				
					m_AtkMass.visible = m_ModeCur == m_ModeCombat;
					m_AtkMass.x = 360;
					m_AtkMass.y = sizey + 5;
					
					m_AtkLost.visible = m_ModeCur == m_ModeStat;
					m_AtkLost.x = 180;
					m_AtkLost.y = sizey + 5;
					
					m_AtkDestroy.visible = m_ModeCur == m_ModeStat;
					m_AtkDestroy.x = 260;
					m_AtkDestroy.y = sizey + 5;

					m_AtkDamage.visible = m_ModeCur == m_ModeStat;
					m_AtkDamage.x = 370;
					m_AtkDamage.y = sizey + 5;

					m_AtkModule.visible = m_ModeCur == m_ModeRes;
					m_AtkModule.x = 260;
					m_AtkModule.y = sizey + 5;

					m_AtkExp.visible = m_ModeCur == m_ModeRes;
					m_AtkExp.x = 360;
					m_AtkExp.y = sizey + 5;
				} else {
					m_DefCaption.visible = true;
					m_DefCaption.x = 20;
					m_DefCaption.y = sizey;
					str = Common.Txt.FormCombatDefCaption;
					if (m_CombatFlag & FlagDefWin) str += " (<font color='#00ff00'>" + Common.Txt.FormCombatWin + "</font>)";
					else if (m_CombatFlag & FlagAtkWin) str += " (<font color='#ff0000'>" + Common.Txt.FormCombatLoss + "</font>)";
					else if ((m_CombatFlag & FlagDefReady) && (m_CombatFlag & FlagReady)==0) str += " ([clr]" + Common.Txt.FormCombatReadyShow + "[/clr])";
					m_DefCaption.htmlText = BaseStr.FormatTag(str);
					sizey += 25;

					m_DefFrame.visible = true;
					m_DefFrame.x = 20;
					m_DefFrame.y = sizey;
					m_DefFrame.width = SizeX - 40;
					m_DefFrame.height = 30;
					
					m_DefUser.visible = true;
					m_DefUser.x = 30;
					m_DefUser.y = sizey+5;

					m_DefRating.visible = m_ModeCur == m_ModeCombat;
					m_DefRating.x = 260;
					m_DefRating.y = sizey + 5;
					
					m_DefMass.visible = m_ModeCur == m_ModeCombat;
					m_DefMass.x = 360;
					m_DefMass.y = sizey+5;

					m_DefLost.visible = m_ModeCur == m_ModeStat;
					m_DefLost.x = 180;
					m_DefLost.y = sizey + 5;
					
					m_DefDestroy.visible = m_ModeCur == m_ModeStat;
					m_DefDestroy.x = 260;
					m_DefDestroy.y = sizey + 5;
					
					m_DefDamage.visible = m_ModeCur == m_ModeStat;
					m_DefDamage.x = 370;
					m_DefDamage.y = sizey + 5;

					m_DefModule.visible = m_ModeCur == m_ModeRes;
					m_DefModule.x = 260;
					m_DefModule.y = sizey + 5;

					m_DefExp.visible = m_ModeCur == m_ModeRes;
					m_DefExp.x = 360;
					m_DefExp.y = sizey + 5;
				}
				sizey += 30;
			}

			obj.FrameN.x = 20;
			obj.FrameN.y = sizey;
			obj.FrameN.width = SizeX - 40;
			obj.FrameN.height = 30;
			obj.FrameA.x = 20;
			obj.FrameA.y = sizey;
			obj.FrameA.width = SizeX - 40;
			obj.FrameA.height = 30;

			obj.Access.x = 30;
			obj.Access.y = sizey + 5+2;

			obj.Name.x = 50;
			obj.Name.y = sizey + 5;

			obj.Rating.visible = m_ModeCur == m_ModeCombat;
			obj.Rating.x = 260;
			obj.Rating.y = sizey + 5;

			obj.Mass.visible = m_ModeCur == m_ModeCombat;
			obj.Mass.x = 360;
			obj.Mass.y = sizey + 5;

			obj.Lost.visible = m_ModeCur == m_ModeStat;
			obj.Lost.x = 180;
			obj.Lost.y = sizey + 5;

			obj.Destroy.visible = m_ModeCur == m_ModeStat;
			obj.Destroy.x = 260;
			obj.Destroy.y = sizey + 5;

			obj.Damage.visible = m_ModeCur == m_ModeStat;
			obj.Damage.x = 370;
			obj.Damage.y = sizey + 5;

			obj.Module.visible = m_ModeCur == m_ModeRes;
			obj.Module.x = 260;
			obj.Module.y = sizey + 5;

			obj.Exp.visible = m_ModeCur == m_ModeRes;
			obj.Exp.x = 360;
			obj.Exp.y = sizey + 5;

			if (m_CurUser == obj.Id) {
				obj.FrameN.visible = false;
				obj.FrameA.visible = true;
			} else {
				obj.FrameN.visible = true;
				obj.FrameA.visible = false;
			}

			sizey += 30;
		}

		// Item
		var cantake:Boolean = inwin;
		if (cantake) {
			for (i = 0; i < CombatUser.UserMax * CombatUser.LootPerUser; i++) {
				if (!m_CombatLoot[i].m_Type) continue;
				if ((m_CombatLoot[i].m_Flag & (FlagLootTake | FlagLootTakeQuery)) == 0) continue;
				if (m_CombatLoot[i].m_OwnerId != Server.Self.m_UserId) continue;
				cantake = false;
				break;
			}
		}
		for (i = 0; i < m_ItemList.length; i++) {
			obj = m_ItemList[i];
			obj.Tmp = 0;
		}

		m_ItemCaption.visible = false;

		k = 0;
		for (i = 0; i < CombatUser.UserMax * CombatUser.LootPerUser; i++) {
			if (!m_CombatLoot[i].m_Type) continue;
			
			item = UserList.Self.GetItem(m_CombatLoot[i].m_Type & 0xffff);
			if (item == null) continue;
				
			if (k == 0) {
				sizey += 30;
				m_ItemCaption.visible = true;
				m_ItemCaption.x = 20;
				m_ItemCaption.y = sizey;
				if (inwin) m_ItemCaption.text = Common.Txt.FormCombatItemWin + ":";
				else m_ItemCaption.text = Common.Txt.FormCombatItemLoss + ":";
				sizey += 25;
			}

			for (u = 0; u < m_ItemList.length; u++) {
				obj = m_ItemList[u];
				if (obj.Num == i) break;
			}
			if (u >= m_ItemList.length) {
				obj = new Object();
				obj.Num = i;
				m_ItemList.push(obj);

				obj.SlotN = new MBSlotG();
				m_Layer.addChild(obj.SlotN);
				obj.SlotN.width = ItemSlotSize;
				obj.SlotN.height = ItemSlotSize;

				obj.SlotE = new MBSlotC();
				m_Layer.addChild(obj.SlotE);
				obj.SlotE.width = ItemSlotSize;
				obj.SlotE.height = ItemSlotSize;

				obj.SlotA = new MBSlotA();
				m_Layer.addChild(obj.SlotA);
				obj.SlotA.width = ItemSlotSize;
				obj.SlotA.height = ItemSlotSize;

				obj.Img = Common.ItemImg(item.m_Img);
				if (obj.Img != null) {
					m_Layer.addChild(obj.Img);
				}
				
				obj.Txt=new TextField();
				m_Layer.addChild(obj.Txt);
				obj.Txt.width=ItemSlotSize-2;
				obj.Txt.type=TextFieldType.DYNAMIC;
				obj.Txt.selectable=false;
				obj.Txt.border=false;
				obj.Txt.background=true;
				obj.Txt.backgroundColor=0x000000;
				obj.Txt.multiline=false;
				obj.Txt.autoSize=TextFieldAutoSize.NONE;
				obj.Txt.antiAliasType=AntiAliasType.ADVANCED;
				obj.Txt.gridFitType=GridFitType.PIXEL;
				obj.Txt.defaultTextFormat=new TextFormat("Calibri",11,0xffffff);
				obj.Txt.embedFonts=true;
				obj.Txt.alpha=0.8;
			}
			obj.Tmp = 1;

			var iat:Boolean = inwin && ((m_CombatLoot[i].m_Flag & (FlagLootTake | FlagLootTakeQuery)) != 0) && (m_CombatLoot[i].m_OwnerId == Server.Self.m_UserId);

			obj.ItemOwner = 0;
			if ((m_CombatFlag & FlagAtkWin) != 0 && (m_CombatFlag & FlagDefWin) == 0) obj.ItemOwner = m_CombatDefUser[Math.floor(i / CombatUser.LootPerUser)].m_Id;
			else if ((m_CombatFlag & FlagDefWin) != 0 && (m_CombatFlag & FlagAtkWin) == 0) obj.ItemOwner = m_CombatAtkUser[Math.floor(i / CombatUser.LootPerUser)].m_Id;

			obj.CanTake = inwin && cantake && ((m_CombatLoot[i].m_Flag & (FlagLootTake | FlagLootTakeQuery)) == 0);
			obj.NewOwnerId = m_CombatLoot[i].m_OwnerId;

			//if (!obj.CanSelect && m_ItemCur == i) m_ItemCur = -1;

			obj.SlotA.x = 20 + (k % 8) * ItemSlotSize;
			obj.SlotA.y = sizey + Math.floor(k / 8) * ItemSlotSize;
			obj.SlotA.visible = (m_ItemMouse == i);// || (m_ItemCur == i);

			obj.SlotN.x = obj.SlotA.x;
			obj.SlotN.y = obj.SlotA.y;
			obj.SlotN.visible = (!obj.SlotA.visible) && (!iat);

			obj.SlotE.x = obj.SlotA.x;
			obj.SlotE.y = obj.SlotA.y;
			obj.SlotE.visible = (!obj.SlotA.visible) && (iat);

			obj.Img.x = obj.SlotA.x + (ItemSlotSize >> 1);
			obj.Img.y = obj.SlotA.y + (ItemSlotSize >> 1);

			obj.Txt.height = 17;
			obj.Txt.x = obj.SlotA.x + 1;
			obj.Txt.y = obj.SlotA.y + ItemSlotSize-obj.Txt.height;
			if (m_CombatLoot[i].m_Cnt >= 500000) str = BaseStr.FormatBigInt(Math.floor(m_CombatLoot[i].m_Cnt/1000))+"k";
			else str = BaseStr.FormatBigInt(m_CombatLoot[i].m_Cnt);
			obj.Txt.htmlText = str;
			obj.Txt.visible = true;

			if ((inloss && (obj.ItemOwner != Server.Self.m_UserId)) || (inwin && !cantake && !iat)) {
				obj.SlotN.alpha = 0.6;
				obj.SlotA.alpha = 0.6;
				obj.Img.alpha = 0.6;
				obj.Txt.alpha = 0.6;
			} else {
				obj.SlotN.alpha = 1.0;
				obj.SlotA.alpha = 1.0;
				obj.Img.alpha = 1.0;
				obj.Txt.alpha = 0.8;
			}

			k++;
		}

		sizey += Math.ceil(k / 8) * ItemSlotSize;

		for (i = m_ItemList.length - 1; i >= 0; i--) {
			obj = m_ItemList[i];
			if (obj.Tmp != 0) continue;
			m_ItemList.splice(i, 1);

			if (obj.SlotN != null) { m_Layer.removeChild(obj.SlotN); obj.SlotN = null; }
			if (obj.SlotE != null) { m_Layer.removeChild(obj.SlotE); obj.SlotE = null; }
			if (obj.SlotA != null) { m_Layer.removeChild(obj.SlotA); obj.SlotA = null; }
			if (obj.Img != null) { m_Layer.removeChild(obj.Img); obj.Img = null; }
			if (obj.Txt != null) { m_Layer.removeChild(obj.Txt); obj.Txt = null; }
		}

//		if (k > 0) {
//			sizey += 5;
//			m_ButTake.visible = inwin && cantake && (m_ItemCur >= 0);
//			m_ButTake.x = 20;
//			m_ButTake.y = sizey;
//			sizey += 30;
//		} else {
//			m_ButTake.visible = false;
//		}

		// TakeItem
		for (i = 0; i < m_TakeList.length; i++) {
			obj = m_TakeList[i];
			obj.Tmp = 0;
		}
		
		m_TakeCaption.visible = false;

		k = 0;
		for (i = 0; i < CombatUser.UserMax * CombatUser.LootPerUser; i++) {
			if (!m_CombatLoot[i].m_Type) continue;
			
			if ((m_CombatLoot[i].m_Flag & FlagLootTake) == 0) continue;
			if (m_CombatLoot[i].m_OwnerId != Server.Self.m_UserId) continue;
			
			item = UserList.Self.GetItem(m_CombatLoot[i].m_Type & 0xffff);
			if (item == null) continue;
				
			if (k == 0) {
				sizey += 10;
				m_TakeCaption.visible = true;
				m_TakeCaption.x = 20;
				m_TakeCaption.y = sizey;
				m_TakeCaption.text = Common.Txt.FormCombatItemTake + ":";
				sizey += 25;
			}

			for (u = 0; u < m_TakeList.length; u++) {
				obj = m_TakeList[u];
				if (obj.Num == i) break;
			}
			if (u >= m_TakeList.length) {
				obj = new Object();
				obj.Num = i;
				m_TakeList.push(obj);

				obj.SlotN = new MBSlotG();
				m_Layer.addChild(obj.SlotN);
				obj.SlotN.width = ItemSlotSize;
				obj.SlotN.height = ItemSlotSize;

				obj.SlotE = new MBSlotC();
				m_Layer.addChild(obj.SlotE);
				obj.SlotE.width = ItemSlotSize;
				obj.SlotE.height = ItemSlotSize;

				obj.SlotA = new MBSlotA();
				m_Layer.addChild(obj.SlotA);
				obj.SlotA.width = ItemSlotSize;
				obj.SlotA.height = ItemSlotSize;
				
				obj.Img = Common.ItemImg(item.m_Img);
				if (obj.Img != null) {
					m_Layer.addChild(obj.Img);
				}

				obj.Txt=new TextField();
				m_Layer.addChild(obj.Txt);
				obj.Txt.width=ItemSlotSize-2;
				obj.Txt.type=TextFieldType.DYNAMIC;
				obj.Txt.selectable=false;
				obj.Txt.border=false;
				obj.Txt.background=true;
				obj.Txt.backgroundColor=0x000000;
				obj.Txt.multiline=false;
				obj.Txt.autoSize=TextFieldAutoSize.NONE;
				obj.Txt.antiAliasType=AntiAliasType.ADVANCED;
				obj.Txt.gridFitType=GridFitType.PIXEL;
				obj.Txt.defaultTextFormat=new TextFormat("Calibri",11,0xffffff);
				obj.Txt.embedFonts=true;
				obj.Txt.alpha=0.8;
			}
			obj.Tmp = 1;

			obj.ItemOwner = 0;
			if ((m_CombatFlag & FlagAtkWin) != 0 && (m_CombatFlag & FlagDefWin) == 0) obj.ItemOwner = m_CombatDefUser[Math.floor(i / CombatUser.LootPerUser)].m_Id;
			else if ((m_CombatFlag & FlagDefWin) != 0 && (m_CombatFlag & FlagAtkWin) == 0) obj.ItemOwner = m_CombatAtkUser[Math.floor(i / CombatUser.LootPerUser)].m_Id;

			obj.NewOwnerId = m_CombatLoot[i].m_OwnerId;

			obj.SlotA.x = 20 + (k % 8) * ItemSlotSize;
			obj.SlotA.y = sizey + Math.floor(k / 8) * ItemSlotSize;
			obj.SlotA.visible = (m_TakeMouse == i);

			obj.SlotN.x = obj.SlotA.x;
			obj.SlotN.y = obj.SlotA.y;
			obj.SlotN.visible = false;// (!obj.SlotA.visible) && (!iat);

			obj.SlotE.x = obj.SlotA.x;
			obj.SlotE.y = obj.SlotA.y;
			obj.SlotE.visible = (!obj.SlotA.visible);// && (iat);

			obj.Txt.height = 17;
			obj.Txt.x = obj.SlotA.x + 1;
			obj.Txt.y = obj.SlotA.y + ItemSlotSize-obj.Txt.height;
			if (m_CombatLoot[i].m_Cnt >= 500000) str = BaseStr.FormatBigInt(Math.floor(m_CombatLoot[i].m_Cnt/1000))+"k";
			else str = BaseStr.FormatBigInt(m_CombatLoot[i].m_Cnt);
			obj.Txt.htmlText = str;
			obj.Txt.visible = true;

			obj.Img.x = obj.SlotA.x + (ItemSlotSize >> 1);
			obj.Img.y = obj.SlotA.y + (ItemSlotSize >> 1);

			k++;
		}
		
		sizey += Math.ceil(k / 8) * ItemSlotSize;
		
		for (i = m_TakeList.length - 1; i >= 0; i--) {
			obj = m_TakeList[i];
			if (obj.Tmp != 0) continue;
			m_TakeList.splice(i, 1);

			if (obj.SlotN != null) { m_Layer.removeChild(obj.SlotN); obj.SlotN = null; }
			if (obj.SlotE != null) { m_Layer.removeChild(obj.SlotE); obj.SlotE = null; }
			if (obj.SlotA != null) { m_Layer.removeChild(obj.SlotA); obj.SlotA = null; }
			if (obj.Img != null) { m_Layer.removeChild(obj.Img); obj.Img = null; }
			if (obj.Txt != null) { m_Layer.removeChild(obj.Txt); obj.Txt = null; }
		}
		

		// Fin
		sizey += 20;

		m_ButLeave.visible = false;
		
		while (true) {
			for (i = 0; i < CombatUser.UserMax; i++) {
				if (m_CombatAtkUser[i].m_Id == Server.Self.m_UserId) break;
				if (m_CombatDefUser[i].m_Id == Server.Self.m_UserId) break;
			}
			if (i >= CombatUser.UserMax) break;
			
			if ((m_CombatFlag & (FlagAtkWin | FlagDefWin)) != 0) { }
//			else if ((m_CombatFlag & (FlagPrepare)) != 0) {
//				for (i = 0; i < CombatUser.UserMax; i++) {
//					if ((m_CombatAtkUser[i].m_Id == Server.Self.m_UserId)) break;
//					if ((m_CombatDefUser[i].m_Id == Server.Self.m_UserId)) break;
//				}
//				if (i < CombatUser.UserMax) break;
//			}
			else if ((m_CombatFlag & (FlagReady)) != 0) {
				for (i = 0; i < CombatUser.UserMax; i++) {
					if ((m_CombatAtkUser[i].m_Id == Server.Self.m_UserId) && (m_CombatAtkUser[i].m_Flag & CombatUser.FlagUserAccess)!=0) break;
					if ((m_CombatDefUser[i].m_Id == Server.Self.m_UserId) && (m_CombatDefUser[i].m_Flag & CombatUser.FlagUserAccess)!=0) break;
				}
				if (i < CombatUser.UserMax) break;
			}
			else if ((m_CombatFlag & FlagDuel) != 0) { }
			else if ((Server.Self.m_UserId != m_CombatAtkUser[0].m_Id) && (Server.Self.m_UserId != m_CombatDefUser[0].m_Id)) { }
			else break;

			for (i = 0; i < CombatUser.UserMax; i++) {
				if ((m_CombatAtkUser[i].m_Id == Server.Self.m_UserId) && (m_CombatAtkUser[i].m_Flag & CombatUser.FlagUserHomeJump)!=0) break;
				if ((m_CombatDefUser[i].m_Id == Server.Self.m_UserId) && (m_CombatDefUser[i].m_Flag & CombatUser.FlagUserHomeJump)!=0) break;
			}
			//if (i >= CombatUser.UserMax) {
				m_ButLeave.label = Common.Txt.FormCombatLeave;
				m_ButLeave.width = 120;
			//} else {
			//	m_ButLeave.label = Common.Txt.FormCombatLeaveAndJump;
			//	m_ButLeave.width = 150;
			//}
			m_ButLeave.visible = true;
			break;
		}
		//m_ButLeave.visible = true;
		//m_ButLeave.visible = (Server.Self.m_UserId != m_CombatAtkUser[0].m_Id) && (Server.Self.m_UserId != m_CombatDefUser[0].m_Id);

		m_ButReady.visible = false;
		m_ButEnter.visible = false;
		m_Status.visible = false;

		if (m_CombatCreateTime == 0) {
		} else if (m_CombatFlag & (FlagAtkWin | FlagDefWin)) {
		} else if ((m_CombatFlag & FlagReady) != 0 && (m_CombatStateTime <= EM.GetServerGlobalTime())) {
			m_ButEnter.visible = m_CombatCotlId != 0;
			m_ButEnter.x = 20;
			m_ButEnter.y = sizey;

			if ((m_SendStart == false) && (m_CombatCotlId == 0)) SendStart();

		} else if ((m_CombatFlag & FlagReady) != 0) {
			m_Status.visible = true;
			m_Status.x = 20;
			m_Status.y = sizey;
			m_Status.htmlText = Common.Txt.FormCombatReadyTime + ": " + Common.FormatPeriodLong((m_CombatStateTime-EM.GetServerGlobalTime()) / 1000, true);

		} else if ((m_CombatFlag & FlagDuel) == 0) {
			m_Status.visible = true;
			m_Status.x = 20;
			m_Status.y = sizey;
			var et:Number = m_CombatCreateTime + ForcedStartTime * 1000;
			if ((m_CombatFlag & FlagPrepare) != 0) et = Math.min(et, m_CombatStateTime);
			m_Status.htmlText = Common.Txt.FormCombatReadyTime + ": " + Common.FormatPeriodLong(ReadyCapTime + (et - EM.GetServerGlobalTime()) / 1000, true);
			
			sizey += 25;

			if(((m_CombatFlag & FlagReady) == 0) && (Server.Self.m_UserId==m_CombatAtkUser[0].m_Id) && ((m_CombatFlag & FlagAtkReady)==0)) {
				m_ButReady.visible = true;
				m_ButReady.x = 20;
				m_ButReady.y = sizey;

			} else if(((m_CombatFlag & FlagReady) == 0) && (Server.Self.m_UserId==m_CombatDefUser[0].m_Id) && ((m_CombatFlag & FlagDefReady)==0)) {
				m_ButReady.visible = true;
				m_ButReady.x = 20;
				m_ButReady.y = sizey;
			}

			if ((m_SendStart == false) && (EM.GetServerGlobalTime() >= (m_CombatCreateTime + ForcedStartTime * 1000))) SendStart();
			else if ((m_SendStart == false) && (m_CombatFlag & FlagPrepare) && (EM.GetServerGlobalTime() >= m_CombatStateTime)) SendStart();

		} else if((Server.Self.m_UserId==m_CombatAtkUser[0].m_Id) && ((m_CombatFlag & FlagAtkReady)==0)) {
			m_ButReady.visible = true;
			m_ButReady.x = 20;
			m_ButReady.y = sizey;

		} else if((Server.Self.m_UserId==m_CombatDefUser[0].m_Id) && ((m_CombatFlag & FlagDefReady)==0)) {
			m_ButReady.visible = true;
			m_ButReady.x = 20;
			m_ButReady.y = sizey;

		} else if (m_CombatFlag & FlagPrepare) {
			m_Status.visible = true;
			m_Status.x = 20;
			m_Status.y = sizey;
			m_Status.htmlText = BaseStr.FormatTag(Common.Txt.FormCombatReadyTime + ": " + Common.FormatPeriodLong(ReadyCapTime + (m_CombatStateTime-EM.GetServerGlobalTime()) / 1000, true));
			
			if ((m_SendStart == false) && (EM.GetServerGlobalTime() >= m_CombatStateTime)) SendStart();
		}

		m_ButClose.x = SizeX - 15 - m_ButClose.width;
		m_ButClose.y = sizey;

		m_ButLeave.y = m_ButClose.y;
		m_ButLeave.x = m_ButClose.x - m_ButLeave.width - 10;

		sizey += 40;
		m_SizeY = sizey;
		
		m_Frame.width=SizeX;
		m_Frame.height=m_SizeY;
	}
	
	public function MenuItem():void
	{
		EM.m_Info.Hide();

		EM.m_FormMenu.Clear();
		
		var obj:Object = GetGraphByItem(m_ItemMouse);
		if (obj == null) return;
		if (!obj.CanTake) return;

		if (obj.CanTake) {
			EM.m_FormMenu.Add(Common.Txt.FormCombatTake,clickTake); 
		}

		var tx:int = x + obj.SlotN.x;
		var ty:int = y + obj.SlotN.y;
		EM.m_FormMenu.Show(tx, ty, tx + ItemSlotSize, ty + ItemSlotSize);
	}
	
	public function PickUser():uint
	{
		var i:int;
		var obj:Object;
		
		for (i = 0; i < m_UserList.length; i++) {
			obj = m_UserList[i];
			if (obj.FrameN.visible && obj.FrameN.hitTestPoint(stage.mouseX, stage.mouseY)) return obj.Id;
			if (obj.FrameA.visible && obj.FrameA.hitTestPoint(stage.mouseX, stage.mouseY)) return obj.Id;
		}
		return 0;
	}
	
	public function PickItem():int
	{
		var i:int;
		var obj:Object;
		
		for (i = 0; i < m_ItemList.length; i++) {
			obj = m_ItemList[i];
			if (obj.SlotN != null && obj.SlotN.visible && obj.SlotN.hitTestPoint(stage.mouseX, stage.mouseY)) { }
			else if (obj.SlotE != null && obj.SlotE.visible && obj.SlotE.hitTestPoint(stage.mouseX, stage.mouseY)) {}
			else if (obj.SlotA != null && obj.SlotA.visible && obj.SlotA.hitTestPoint(stage.mouseX, stage.mouseY)) {}
			else continue;
			
			return obj.Num;
		}

		return -1;
	}
	
	public function PickTake():int
	{
		var i:int;
		var obj:Object;
		
		for (i = 0; i < m_TakeList.length; i++) {
			obj = m_TakeList[i];
			if (obj.SlotN != null && obj.SlotN.visible && obj.SlotN.hitTestPoint(stage.mouseX, stage.mouseY)) { }
			else if (obj.SlotE != null && obj.SlotE.visible && obj.SlotE.hitTestPoint(stage.mouseX, stage.mouseY)) {}
			else if (obj.SlotA != null && obj.SlotA.visible && obj.SlotA.hitTestPoint(stage.mouseX, stage.mouseY)) {}
			else continue;
			
			return obj.Num;
		}

		return -1;
	}

	public function GetGraphByItem(no:int):Object
	{
		var i:int;
		var obj:Object;
		
		for (i = 0; i < m_ItemList.length; i++) {
			obj = m_ItemList[i];
			if (obj.Num == no) return obj;
		}
		return null;
	}

	public function GetGraphByTake(no:int):Object
	{
		var i:int;
		var obj:Object;
		
		for (i = 0; i < m_TakeList.length; i++) {
			obj = m_TakeList[i];
			if (obj.Num == no) return obj;
		}
		return null;
	}

	public function QueryCombat():void
	{
		if (Server.Self.IsSendCommand("emcombat")) return;
		Server.Self.QueryHS("emcombat",'&id='+m_CombatId.toString()+"&v="+m_CombatVer.toString(),AnswerCombat,false);
	}

	public function AnswerCombat(event:Event):void
	{
		var i:int;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if (EM.ErrorFromServer(buf.readUnsignedByte())) return;

		if (!(EM.HS.m_Anm >= m_LoadCombatAfterAnm || (m_LoadCombatAfterAnm_Time + 3000) < Common.GetTime())) return;

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		var cid:uint = sl.LoadDword();
		if (cid != m_CombatId) return;
		if (cid == 0) { Hide(); return; }

		var cv:uint = sl.LoadDword();;
		if (cv == 0) return;
		m_CombatVer = cv;

		for (i = 0; i < CombatUser.UserMax * CombatUser.LootPerUser; i++) {
			m_CombatLoot[i].m_Type = 0;
			m_CombatLoot[i].m_Cnt = 0;
			m_CombatLoot[i].m_Broken = 0;
			m_CombatLoot[i].m_OwnerId = 0;
			m_CombatLoot[i].m_Flag = 0;
		}
		
		var statlen:int = 0;

		if (false) {
			m_CombatVer = 0;
			m_CombatCreateTime = 0;
			m_CombatFlag = 0;
			m_CombatCotlId = 0;
			m_CombatStateTime = 0;
			for (i = 0; i < CombatUser.UserMax; i++) {
				m_CombatAtkUser[i].Clear();
				m_CombatDefUser[i].Clear();
			}
		} else {
			m_CombatCreateTime = 1000 * sl.LoadDword();
			m_CombatFlag = sl.LoadDword();
			m_CombatCotlId = sl.LoadDword();
			m_CombatStateTime = 1000 * sl.LoadDword();
			for (i = 0; i < CombatUser.UserMax; i++) {
				m_CombatAtkUser[i].m_Id = sl.LoadDword();
				m_CombatAtkUser[i].m_Flag= sl.LoadDword();
				m_CombatAtkUser[i].m_CombatRating = sl.LoadInt();
				m_CombatAtkUser[i].m_ChangeRating = sl.LoadInt();
				m_CombatAtkUser[i].m_Mass = sl.LoadInt();
				m_CombatDefUser[i].m_Id = sl.LoadDword();
				m_CombatDefUser[i].m_Flag= sl.LoadDword();
				m_CombatDefUser[i].m_CombatRating = sl.LoadInt();
				m_CombatDefUser[i].m_ChangeRating = sl.LoadInt();
				m_CombatDefUser[i].m_Mass = sl.LoadInt();
			}
			while (true) {
				var it:uint = sl.LoadDword();
				if (it == 0) break;
				var no:int = sl.LoadInt();
				m_CombatLoot[no].m_Type = it;
				m_CombatLoot[no].m_Cnt = sl.LoadInt();
				m_CombatLoot[no].m_Broken = sl.LoadInt();
				m_CombatLoot[no].m_OwnerId = sl.LoadDword();
				m_CombatLoot[no].m_Flag = sl.LoadDword();
			}
			
			statlen=sl.LoadDword();
		}
		sl.LoadEnd();
		
		var cs:Object;
		for (i = 0; i < m_CombatStat.length; i++) {
			cs = m_CombatStat[i];
			cs.m_Tmp = 0;
		}
		if (statlen > 0) {
			var stattype:uint = buf.readUnsignedByte();
			var statver:uint = 0;
			if(stattype==1) {
				sl.LoadBegin(buf);
				statver = sl.LoadDword();
				
				while (true) {
					var acid:uint = sl.LoadDword();
					if (acid == 0) break;

					for (i = 0; i < m_CombatStat.length; i++) {
						cs = m_CombatStat[i];
						if (cs.m_AccountId == acid) break;
					}
					if (i >= m_CombatStat.length) {
						cs = new Object();
						cs.m_AccountId = acid;
						m_CombatStat.push(cs);
					}
					cs.m_Tmp = 1;

					cs.m_Module = sl.LoadInt();
					cs.m_MassRemain = sl.LoadInt();
					cs.m_MassLost = sl.LoadInt();
					cs.m_MassDestroy = sl.LoadInt();
					cs.m_ExpReceive = sl.LoadInt();

					if (statver >= 2) {
						cs.m_DamageCorvette = sl.LoadInt();
						cs.m_DamageCruiser = sl.LoadInt();
						cs.m_DamageDreadnought = sl.LoadInt();
						cs.m_DamageDevastator = sl.LoadInt();
						cs.m_DamageFlagship = sl.LoadInt();
					} else {
						cs.m_DamageCorvette = 0;
						cs.m_DamageCruiser = 0;
						cs.m_DamageDreadnought = 0;
						cs.m_DamageDevastator = 0;
						cs.m_DamageFlagship = 0;
					}
				}
				
				sl.LoadEnd();
			}
		}
		for (i = m_CombatStat.length - 1; i >= 0 ; i--) {
			cs = m_CombatStat[i];
			if (cs.m_Tmp == 1) continue;
			m_CombatStat.splice(i, 1);
		}
		
		Update();
		if (EM.m_FormMiniMap.visible) EM.m_FormMiniMap.Update();
	}
	
	public function AnswerCombatAction(event:Event):void
	{
		var i:int;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian = Endian.LITTLE_ENDIAN;
		
		var err:uint = buf.readUnsignedByte();
		if (err == Server.ErrorExist) { FormMessageBox.Run(Common.Txt.FormCombatErrInBattle, Common.Txt.ButClose); return; }
		else if (err == Server.ErrorNoReady) { FormMessageBox.Run(Common.Txt.FormCombatErrNoReady, Common.Txt.ButClose); return; }

		if (EM.ErrorFromServer(err)) return;
	}

	public function CombatOffer(uid:uint):void
	{
//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(7,uid);
//		EM.m_LogicAction.push(ac);

		Server.Self.QueryHS("emcombata", "&val=7_" + uid.toString(), AnswerCombatAction, false);
	}
	
	public function JoinToBattle(uid:uint):void
	{
//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(1,uid);
//		EM.m_LogicAction.push(ac);

		Server.Self.QueryHS("emcombata", "&val=1_" + uid.toString(), AnswerCombatAction, false);
	}

	public function CancelToBattle(uid:uint):void
	{
//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(8,uid);
//		EM.m_LogicAction.push(ac);

		Server.Self.QueryHS("emcombata", "&val=8_" + uid.toString(), AnswerCombatAction, false);
	}

	public function NoAnswerToBattle(uid:uint):void
	{
//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(9,uid);
//		EM.m_LogicAction.push(ac);

		Server.Self.QueryHS("emcombata", "&val=9_" + uid.toString(), AnswerCombatAction, false);
	}

	public function CombatInvite(uid:uint):void
	{
//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(10,uid);
//		EM.m_LogicAction.push(ac);

		Server.Self.QueryHS("emcombata", "&val=10_" + uid.toString(), AnswerCombatAction, false);
	}

	public function InviteToBattle(uid:uint):void
	{
//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(2,uid);
//		EM.m_LogicAction.push(ac);

		Server.Self.QueryHS("emcombata", "&val=2_" + uid.toString(), AnswerCombatAction, false);
	}
	
	public function SendStart():void
	{
		m_SendStart = true;

//trace("SendStart");
//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(5,Server.Self.m_UserId);
//		EM.m_LogicAction.push(ac);

		Server.Self.QueryHS("emcombata", "&val=5", AnswerCombatAction, false);
	}

	public function clickLeave(...args):void
	{
//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(3,Server.Self.m_UserId);
//		EM.m_LogicAction.push(ac);

		Server.Self.m_Anm += 256;
		Server.Self.QueryHS("emcombata", "&val=3_" + Server.Self.m_UserId.toString() + "&uanm=" + Server.Self.m_Anm.toString(), AnswerCombatAction, false);
		EmpireMap.Self.m_RecvUserAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_RecvUserAfterAnm_Time = EmpireMap.Self.m_CurTime;
		
		EmpireMap.Self.m_UserCombatId = 0;
		EmpireMap.Self.m_FormBattleBar.Update();

		Hide();
//		EM.m_CombatId = 0;
//		if (EM.m_FormMiniMap.visible) EM.m_FormMiniMap.Update();
	}

	public function clickReady(...args):void
	{
		if(m_CombatAtkUser[0].m_Id==Server.Self.m_UserId) {
			m_CombatFlag |= FormCombat.FlagAtkReady;

		} else if(m_CombatDefUser[0].m_Id==Server.Self.m_UserId) {
			m_CombatFlag |= FormCombat.FlagDefReady;

		} else return;

		Update();

		m_LoadCombatAfterAnm = Math.max(m_LoadCombatAfterAnm, EM.HS.m_Anm) + 1;
		m_LoadCombatAfterAnm_Time=Common.GetTime();
		Server.Self.QueryHS("emcombata", "&anm="+m_LoadCombatAfterAnm.toString()+"&val=4", AnswerCombatAction, false);

//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(4,Server.Self.m_UserId);
//		EM.m_LogicAction.push(ac);
	}

	public function clickEnter(...args):void
	{
		if (m_CombatCotlId == 0) return;
		EM.GoTo(false, m_CombatCotlId, 0, 0, 0);
		Hide();
	}

	public function clickTake(...args):void
	{
		if (m_ItemMouse < 0) return;
		
		var obj:Object = GetGraphByItem(m_ItemMouse);
		if (obj == null) return;
		if (!obj.CanTake) return;

		m_CombatLoot[m_ItemMouse].m_Flag |= FlagLootTakeQuery;
		m_CombatLoot[m_ItemMouse].m_Owner = Server.Self.m_UserId;
		Update();

		m_LoadCombatAfterAnm = Math.max(m_LoadCombatAfterAnm, EM.HS.m_Anm) + 1;
		m_LoadCombatAfterAnm_Time=Common.GetTime();
		Server.Self.QueryHS("emcombata", "&anm=" + m_LoadCombatAfterAnm.toString() + "&val=6_0_" + m_ItemMouse.toString(), AnswerCombatAction, false);

//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(6,0,m_ItemMouse);
//		EM.m_LogicAction.push(ac);
	}
	
	public function MenuUser():void
	{
		var i:int;
		
		EM.m_Info.Hide();

		EM.m_FormMenu.Clear();

		if (!m_CurUser) return;

		while (true) {
			if ((m_CombatFlag & (FlagReady | FlagAtkWin | FlagDefWin)) != 0) break;
			if (m_CombatAtkUser[0].m_Id == m_CurUser) break;
			if (m_CombatDefUser[0].m_Id == m_CurUser) break;
			
			//if (m_CurUser == Server.Self.m_UserId) { }
			//else
			if (m_CombatAtkUser[0].m_Id == Server.Self.m_UserId) {
				for (i = 0; i < CombatUser.UserMax; i++) {
					if (m_CombatAtkUser[i].m_Id == m_CurUser) break;
				}
				if (i >= CombatUser.UserMax) break;
			}
			else if (m_CombatDefUser[0].m_Id == Server.Self.m_UserId) {
				for (i = 0; i < CombatUser.UserMax; i++) {
					if (m_CombatDefUser[i].m_Id == m_CurUser) break;
				}
				if (i >= CombatUser.UserMax) break;
			}

			EM.m_FormMenu.Add(Common.Txt.FormCombatExclude, UserLeave); 
			break;
		}

		while (true) {
			if ((m_CombatFlag & (FlagReady | FlagAtkWin | FlagDefWin)) != 0) break;
			if ((m_CombatFlag & FlagRandom) != 0) break;

			var ul:Vector.<CombatUser> = null;
			for (i = 0; i < CombatUser.UserMax; i++) {
				if (m_CombatAtkUser[i].m_Id == m_CurUser) { ul = m_CombatAtkUser; break; }
				if (m_CombatDefUser[i].m_Id == m_CurUser) { ul = m_CombatDefUser; break; }
			}
			if (ul == null) break;
			
			if (ul[0].m_Id != Server.Self.m_UserId) break;
			
			EM.m_FormMenu.Add();
			
			while (true) {
				if (i <= 0) break;
				if ((m_CombatFlag & FlagDuel) == 0 && i <= 1) break;
				if (ul[i - 1].m_Id == 0) break;
				
				EM.m_FormMenu.Add(Common.Txt.FormCombatUp, UserMove,-1); 
				break;
			}
			
			while (true) {
				if (((m_CombatFlag & FlagDuel) == 0) && (i == 0)) break;
				if (i >= (CombatUser.UserMax - 1)) break;
				if (ul[i + 1].m_Id == 0) break;

				EM.m_FormMenu.Add(Common.Txt.FormCombatDown, UserMove, 1); 
				break;
			}

			break;
		}

		EM.m_FormMenu.Show(stage.mouseX, stage.mouseY, stage.mouseX+1, stage.mouseY+1);
	}
	
	public function UserMove(obj:Object, dir:int):void
	{
		var i:int;
		if (dir != 1 && dir != -1) return;
		
		if ((m_CombatFlag & (FlagReady | FlagAtkWin | FlagDefWin)) != 0) return;
		if ((m_CombatFlag & FlagRandom) != 0) return;
		
		var atk:Boolean=false;
		var ul:Vector.<CombatUser> = null;
		for (i = 0; i < CombatUser.UserMax; i++) {
			if (m_CombatAtkUser[i].m_Id == m_CurUser) { ul = m_CombatAtkUser; atk = true; break; }
			if (m_CombatDefUser[i].m_Id == m_CurUser) { ul = m_CombatDefUser; break; }
		}
		if (ul == null) return;
		
		if (ul[0].m_Id != Server.Self.m_UserId) return;
        if ((i <= 0) && (dir < 0)) return;
        if ((m_CombatFlag & FlagDuel) == 0 && (i <= 1) && (dir < 0)) return;
        if (i >= (CombatUser.UserMax - 1) && (dir > 0)) return;
        if ((m_CombatFlag & FlagDuel) == 0 && (i == 0) && (dir > 0)) return;

        if (!ul[i + dir].m_Id) return;

		var tu:CombatUser = new CombatUser;
		tu.CopyFrom(ul[i + dir]);
		ul[i + dir].CopyFrom(ul[i]);
		ul[i].CopyFrom(tu);

        if ((m_CombatFlag & (FlagAtkWin | FlagDefWin | FlagReady)) == 0) {
            if (atk) m_CombatFlag &= ~(FlagPrepare | FlagAtkReady);
            else m_CombatFlag &= ~(FlagPrepare | FlagDefReady);
        }

		if (dir < 0) dir = 0;
		else dir = 1;

		m_LoadCombatAfterAnm = Math.max(m_LoadCombatAfterAnm, EM.HS.m_Anm) + 1;
		m_LoadCombatAfterAnm_Time=Common.GetTime();
		Server.Self.QueryHS("emcombata", "&anm=" + m_LoadCombatAfterAnm.toString() + "&val=11_" + m_CurUser.toString() + "_" + dir.toString(), AnswerCombatAction, false);

		Update();
	}

	public function UserLeave(...args):void
	{
		var i:int;

		var accountid:uint = Server.Self.m_UserId;
		var del_accountid:uint = m_CurUser;

        var delfromlist:Boolean=true;
        var calcmass:Boolean=false;
        if ((m_CombatFlag & (FlagAtkWin | FlagDefWin)) != 0) delfromlist=false;
        else if ((m_CombatFlag & (FlagReady)) != 0) {
            for(i=0;i<CombatUser.UserMax;i++) {
                if ((m_CombatAtkUser[i].m_Id == del_accountid) && (m_CombatAtkUser[i].m_Flag & CombatUser.FlagUserAccess) != 0) break;
                if ((m_CombatDefUser[i].m_Id == del_accountid) && (m_CombatDefUser[i].m_Flag & CombatUser.FlagUserAccess) != 0) break;
            }
            if(i<CombatUser.UserMax) return;
        }
        else if ((del_accountid != m_CombatAtkUser[0].m_Id) && (del_accountid != m_CombatDefUser[0].m_Id)) calcmass = true;
		else if ((m_CombatFlag & FlagDuel) != 0) calcmass = true;
        else return;
		
		var f:uint = 0;
        if(delfromlist) {
            // Atk
            var find:Boolean=false;
            for(i=0;i<CombatUser.UserMax;i++) {
                if (m_CombatAtkUser[i].m_Id == del_accountid) break;
            }
            if (i < CombatUser.UserMax && (m_CombatAtkUser[0].m_Id == accountid || m_CombatAtkUser[i].m_Id == accountid)) {
                find=true;
                for (; i < CombatUser.UserMax - 1; i++) {
                    if (m_CombatAtkUser[i + 1].m_Id == 0) break;
                    m_CombatAtkUser[i].CopyFrom(m_CombatAtkUser[i + 1]);
					f = 1;
                }
                if (i < CombatUser.UserMax) {
					m_CombatAtkUser[i].Clear();
					f = 1;
                }

                if ((m_CombatFlag & (FlagAtkWin | FlagDefWin | FlagReady)) == 0) {
					m_CombatFlag &= ~(FlagPrepare | FlagAtkReady);
					f = 1;
                }
            }
			
            // Def
            for (i = 0; i < CombatUser.UserMax; i++) {
                if (m_CombatDefUser[i].m_Id == del_accountid) break;
            }
            if (i < CombatUser.UserMax && (m_CombatDefUser[0].m_Id == accountid || m_CombatDefUser[i].m_Id == accountid)) {
                find=true;
                for (; i < CombatUser.UserMax - 1; i++) {
                    if (m_CombatDefUser[i + 1].m_Id == 0) break;
                    m_CombatDefUser[i].CopyFrom(m_CombatDefUser[i + 1]);
					f = 1;
                }
                if(i<CombatUser.UserMax) {
					m_CombatDefUser[i].Clear();
					f = 1;
                }

                if((m_CombatFlag & (FlagAtkWin|FlagDefWin|FlagReady))==0) {
                    m_CombatFlag &= ~(FlagPrepare | FlagDefReady);
					f = 1;
                }
            }
		}

		if(f!=0 && calcmass) {}

		m_LoadCombatAfterAnm = Math.max(m_LoadCombatAfterAnm, EM.HS.m_Anm) + 1;
		m_LoadCombatAfterAnm_Time=Common.GetTime();
		Server.Self.QueryHS("emcombata", "&anm=" + m_LoadCombatAfterAnm.toString() + "&val=3_" + del_accountid.toString(), AnswerCombatAction, false);

//		var ac:Action=new Action(m_Map);
//		ac.ActionCombat(3,m_CurUser);
//		EM.m_LogicAction.push(ac);
	}
}

}
