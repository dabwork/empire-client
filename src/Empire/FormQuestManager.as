package Empire
{
import Base.*;
import Engine.*;
import fl.containers.*;
import fl.controls.*;
import fl.controls.dataGridClasses.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormQuestManager extends Sprite
{
	private var m_Map:EmpireMap;

	static public const SizeX:int = 650;
	static public const SizeY:int = 500;

	public var m_LabelCaption:TextField = null;
	public var m_ButClose:Button = null;
	public var m_List:DataGrid = null;

	public var m_QuestList:Dictionary = new Dictionary();
	public var m_QuestArray:Array = new Array();

	public var m_TimerQuest:Timer = new Timer(500);

	public function FormQuestManager(map:EmpireMap)
	{
		m_Map = map;

		var fr:GrFrame=new GrFrame();
		fr.width=SizeX;
		fr.height=SizeY;
		addChild(fr);

		m_LabelCaption=new TextField();
		m_LabelCaption.x=10;
		m_LabelCaption.y=5;
		m_LabelCaption.width=1;
		m_LabelCaption.height=1;
		m_LabelCaption.type=TextFieldType.DYNAMIC;
		m_LabelCaption.selectable=false;
		m_LabelCaption.border=false;
		m_LabelCaption.background=false;
		m_LabelCaption.multiline=false;
		m_LabelCaption.autoSize=TextFieldAutoSize.LEFT;
		m_LabelCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelCaption.gridFitType=GridFitType.PIXEL;
		m_LabelCaption.defaultTextFormat=new TextFormat("Calibri",18,0xffffff);
		m_LabelCaption.embedFonts=true;
		m_LabelCaption.text=Common.TxtEdit.FormQuestManagerCpation;
		addChild(m_LabelCaption);

		m_ButClose=new Button();
		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width=100;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x=SizeX-10-m_ButClose.width;
		m_ButClose.y=SizeY-10-m_ButClose.height;
		addChild(m_ButClose);

		m_List=new DataGrid();
		m_List.x=10;
		m_List.y=70;
		m_List.width=SizeX-20;
		m_List.height=m_ButClose.y-10-m_List.y;
		addChild(m_List);

		m_List.setStyle("skin",ListOnlineUser_skin);
		m_List.setStyle("cellRenderer",ItemListRenderer);

		m_List.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
		m_List.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
		m_List.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
		m_List.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);

		m_List.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
		m_List.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
		m_List.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
		m_List.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
		m_List.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);

		m_List.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
		m_List.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
		m_List.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
		m_List.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);

		m_List.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
		m_List.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
		m_List.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
		m_List.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);

		m_List.setStyle("headerTextFormat",new TextFormat("Calibri",14,0xffffff));
		m_List.setStyle("headerУmbedFonts", true);
		m_List.setStyle("headerTextPadding", 5);

		m_List.rowHeight=22;

		var col:DataGridColumn;
		col=new DataGridColumn("Id"); col.headerText="Id"; col.width=80; m_List.addColumn(col);
		col=new DataGridColumn("Name"); col.headerText="Name"; m_List.addColumn(col);
		col=new DataGridColumn("Owner"); col.headerText="Owner"; col.width=160; m_List.addColumn(col);
		m_List.minColumnWidth=30;

		m_List.doubleClickEnabled=true; 
		//m_ItemList.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClickItemList);

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

		m_TimerQuest.addEventListener(TimerEvent.TIMER, TimerQuest);
		m_TimerQuest.start();
	}

	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) Show();
		x = (m_Map.stage.stageWidth >> 1) - (SizeX >> 1);
		y = (m_Map.stage.stageHeight >> 1) - (SizeY >> 1);
	}
	
	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		if(FormMessageBox.Self.visible) return;
		if(m_ButClose.hitTestPoint(e.stageX,e.stageY)) return;

		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true, 999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true);
		stopDrag();
	}

	public function onMouseMove(e:MouseEvent) : void
	{
		e.stopImmediatePropagation();
		
		m_Map.m_Info.Hide();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function clickClose(event:MouseEvent):void
	{
		Hide();
	}

	public function Show():void
	{
		visible=true;

		StageResize();
	}

	public function GetQuest(id:uint, testload:Boolean=true, requery:Boolean=false):Quest
	{
		if(id==0) return null;

		var qu:Quest=null;

		if(m_QuestList[id]==undefined) {
			qu=new Quest();
			qu.m_Id=id;
			m_QuestArray.push(qu);
			m_QuestList[id]=qu;
			qu.m_GetTime = Common.GetTime();
			TimerQuest();
		} else {
			qu=m_QuestList[id];

			if (requery) {
				qu.m_GetTime = Common.GetTime();
				TimerQuest();
			}
		}

		if(testload && qu.m_LoadDate==0) return null;

		return qu;
	}

	public function TimerQuest(e:TimerEvent=null):void
	{
/*		var i:int;
		var qu:Quest;

		if(!Server.Self.IsConnect()) return;
		if (!EmpireMap.Self.IsConnect()) return;
		if (Server.Self.IsSendCommand("emquest")) return;

		var val:String = "";

		for (i = 0; i < m_QuestArray.length; i++) {
			qu = m_QuestArray[i];
			if (qu.m_GetTime == 0) continue;
			
			if (val.length > 0) val += "_";
			val += qu.m_Id.toString() + "_" + qu.m_Anm.toString();
		}
		
		if (val.length <= 0) return;
		
		Server.Self.Query("emquest", "&val=" + val,AnswerQuest);*/
	}

/*	public function AnswerQuest(event:Event):void
	{
		var len:int;
		
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray = loader.data;
		buf.endian = Endian.LITTLE_ENDIAN;

		if (m_Map.ErrorFromServer(buf.readUnsignedByte())) return;

		while(true) {
			var id:uint = buf.readUnsignedInt();
			if (id == 0) break;

			var qu:Quest = GetQuest(id, false);
			if (qu == null) return;
			
			var anm:uint = buf.readUnsignedInt();
			if (anm == 0) {
				qu.m_GetTime = 0;
				continue;
			}
		
			if (!(anm >= qu.m_LoadAfterAnm || (qu.m_LoadAfterAnm_Time + 3000) < Common.GetTime())) continue;

			qu.m_GetTime = 0;
			qu.m_LoadDate = Common.GetTime();
			qu.m_Anm = anm;
			
			qu.m_Owner = buf.readUnsignedInt();
			qu.m_TaskFlag = buf.readUnsignedInt();
			qu.m_TaskPar0 = buf.readUnsignedInt();
			qu.m_TaskPar4 = buf.readUnsignedInt();
			qu.m_RewardExp = buf.readInt();
			
			len = buf.readShort();
			if (len > 0) qu.m_Name = buf.readUTFBytes(len);

			len = buf.readInt();
			if (len > 0) qu.m_Txt = buf.readUTFBytes(len);
		}
	}*/
}

}

import fl.controls.listClasses.CellRenderer;
import fl.events.ComponentEvent;
import flash.text.*;

class ItemListRenderer extends CellRenderer
{
	public function ItemListRenderer() {
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
	}
}
