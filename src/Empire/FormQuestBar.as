package Empire
{

import fl.controls.*;
import QE.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;

public class FormQuestBar extends Sprite
{
	private var m_Map:EmpireMap;

	static public const FaceSizeX:int = Math.floor(93 * 0.6);//46;
	static public const FaceSizeY:int = Math.floor(104 * 0.6);

	public var m_ContentTF:TextFormat = null; 

	public var m_QuestList:Vector.<QuestUnit> = new Vector.<QuestUnit>();
	public var m_DialogList:Vector.<QuestUnit> = new Vector.<QuestUnit>();

	public var m_NewsFrame:Sprite = new NewsFrame();
	public var m_NewsFace:Bitmap = new Bitmap();
	public var m_NewsDictor:int = 0;
	public var m_NewsId:Number = 0;

	public var m_NTFrame:Sprite = new NewsFrame();
	public var m_NTContent:Sprite = new Sprite();
	public var m_NTMask:Sprite = new Sprite();
//	public var m_NTText:TextField = new TextField();
//	public var m_NTDate:TextField = new TextField();
//	public var m_NTLink:TextField = new TextField();
	public var m_NTSizeX:int = 0;
	public var m_NTSizeY:int = 0;
	public var m_NTContentSizeY:int = 0;
	public var m_NTIn:Boolean = false;
	public var m_NTScroll:Number = 0;
	public var m_NTHideTime:Number = 0;
	
	public var m_NTLineSize:int = 17;

	public var m_NewsList:Array = new Array();
	public var m_NewsShow:Boolean = true;

	public var m_UpdateTimer:Timer = new Timer(1000);

	public var m_ScrollTimer:Timer = new Timer(20);

	public var m_SelectSprite:Sprite = null;
	
	public var m_NewsCur:Number = 0;
	
	public function FormQuestBar(map:EmpireMap)
	{
		m_Map = map;

		m_ContentTF=new TextFormat("Calibri",14,0xffffff,null,null,null,null,null,TextFormatAlign.JUSTIFY,null,null,20);
		m_ContentTF.rightMargin=0;
		m_ContentTF.leftMargin = 0;

		//x = 150;
		//y = 10;
		x = 5;
		y = 35;

		m_NewsFrame.width=FaceSizeX+4;
		m_NewsFrame.height=FaceSizeY+4;
		m_NewsFrame.x = -2;
		m_NewsFrame.y = -2;
		m_NewsFrame.visible = false;
		addChild(m_NewsFrame);

		m_NewsFace.visible = false;
		addChild(m_NewsFace);

		m_NTFrame.visible = false;
		addChild(m_NTFrame);
		
		m_NTContent.visible = false;
		m_NTContent.mouseChildren = false;
		m_NTContent.mouseEnabled = false;
		addChild(m_NTContent);

		m_NTMask.visible = false;
		m_NTContent.mask = m_NTMask;
		addChild(m_NTMask);

/*		m_NTText.visible = false;
		m_NTText.x = 0;
		m_NTText.width = 100;
		m_NTText.height = 1;
		m_NTText.type = TextFieldType.DYNAMIC;
		m_NTText.selectable = false;
		m_NTText.border = false;
		m_NTText.background = false;
		m_NTText.multiline = true;
		m_NTText.wordWrap = true;
		m_NTText.condenseWhite=true;
		m_NTText.alwaysShowSelection=true;
		m_NTText.autoSize = TextFieldAutoSize.LEFT;
		m_NTText.antiAliasType = AntiAliasType.NORMAL;
		m_NTText.gridFitType = GridFitType.SUBPIXEL;
		m_NTText.defaultTextFormat = m_ContentTF;
		m_NTText.embedFonts = true;
		m_NTContent.addChild(m_NTText);

		m_NTDate.visible = false;
		m_NTDate.x = 0;
		m_NTDate.width = 1;
		m_NTDate.height = 1;
		m_NTDate.type = TextFieldType.DYNAMIC;
		m_NTDate.selectable = false;
		m_NTDate.border = false;
		m_NTDate.background = false;
		m_NTDate.multiline = false;
		m_NTDate.wordWrap = false;
		m_NTDate.condenseWhite=true;
		m_NTDate.autoSize = TextFieldAutoSize.LEFT;
		m_NTDate.antiAliasType = AntiAliasType.NORMAL;
		m_NTDate.gridFitType = GridFitType.SUBPIXEL;
		m_NTDate.defaultTextFormat = new TextFormat("Calibri", m_ContentTF.size, 0x808080);
		m_NTDate.embedFonts = true;
		m_NTContent.addChild(m_NTDate);

		m_NTLink.visible = false;
		m_NTLink.x = 0;
		m_NTLink.width = 1;
		m_NTLink.height = 1;
		m_NTLink.type = TextFieldType.DYNAMIC;
		m_NTLink.selectable = false;
		m_NTLink.border = false;
		m_NTLink.background = false;
		m_NTLink.multiline = false;
		m_NTLink.wordWrap = false;
		m_NTLink.condenseWhite=true;
		m_NTLink.autoSize = TextFieldAutoSize.LEFT;
		m_NTLink.antiAliasType = AntiAliasType.NORMAL;
		m_NTLink.gridFitType = GridFitType.SUBPIXEL;
		m_NTLink.defaultTextFormat = new TextFormat("Calibri", m_ContentTF.size, 0x00ff00);
		m_NTLink.embedFonts = true;
		m_NTContent.addChild(m_NTLink);*/

		m_ScrollTimer.addEventListener("timer", ScrollTimer);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_WHEEL, onContentMouseWell);

		m_UpdateTimer.addEventListener("timer", UpdateTimer);
	}

	public function Clear():void
	{
	}

	public function ClearForNewConn():void
	{
		m_NewsDictor = 0;
		m_NewsId = 0;
	}

	public function StageResize():void
	{
		if (!visible) return;//&& EmpireMap.Self.IsResize()) Show();
		Update();
	}

	public function Show():void
	{
//m_Map.m_FormHint.Show("###FormQuestBar00");
		m_Map.FloatTop(this);
		visible = true;
		
//m_Map.m_FormHint.Show("###FormQuestBar01");
		m_UpdateTimer.start();

		//x=((m_Map.m_FormChat.width+m_Map.m_FormInfoBar.m_MBBG.x)>>1)-(SizeX>>1);
		//y=m_Map.stage.stageHeight-FormInfoBar.BarHeight-SizeY;
		
//		x = 3;
//		if(m_Map.m_FormChat.visible) {
//			y = m_Map.m_FormChat.y - 100;
//		} else {
//			y = m_Map.m_FormInfoBar.y - 100;
//		}

//m_Map.m_FormHint.Show("###FormQuestBar02");
		Update();
//m_Map.m_FormHint.Show("###FormQuestBar03");
	}

	public function Hide():void
	{
		m_UpdateTimer.stop();
		m_ScrollTimer.stop();
		visible=false;
	}
	
	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
//		if(mouseX>=0 && mouseX<(m_SizeX+5) && mouseY>=0 && mouseY<(m_SizeY+5)) return true;
//		if(m_LayerItemBG.visible && m_LayerItemBG.hitTestPoint(x+mouseX,y+mouseY)) return true;
		return false;
	}
	
	public function UpdateTimer(e:TimerEvent):void
	{
		if (m_NTHideTime != 0 && m_NTHideTime < Common.GetTime()) {
			NTHide();
		}
		Update();
	}
	
	public function Update():void
	{
		var i:int, u:int, a:int, offx:int;
		var n:Object, d:Object, obj:Object;
		var str:String;
		var qu:QuestUnit;
		var qe:QEEngine;

//if(test) m_Map.m_FormHint.Show("###FormQuestBar10");
		if (!visible) return;
		
		for (i = m_DialogList.length - 1; i >= 0; i--) {
			qu = m_DialogList[i];
			if (qu.m_Tmp == 0) {
				qu.Clear();
				m_DialogList.splice(i, 1);
				continue;
			}
			
			if (qu.m_Frame == null) {
				qu.m_Frame = new NewsFrame();
				qu.m_Frame.width=FaceSizeX+4;
				qu.m_Frame.height=FaceSizeY+4;
				qu.m_Frame.x = -2;
				qu.m_Frame.y = -2;
				addChild(qu.m_Frame);
			}

			if (qu.m_Face == null) {
				qu.m_Face = new Bitmap()
//				qu.m_Face.bitmapData = new Face(93, 104);//Common.CreateByName("Face" + Common.RaceSysName[m_NewsDictor] + "News") as BitmapData;
				addChild(qu.m_Face);
			}
			if (qu.m_Face.bitmapData == null) {
				qu.m_Face.bitmapData = FormDialog.BitmapFace(qu.m_Race, qu.m_FaceNum);
				qu.m_Face.width = FaceSizeX;
				qu.m_Face.height = FaceSizeY;
			}
		}

		offx = 0;
		for (i = 0; i < m_DialogList.length; i++) {
			qu = m_DialogList[i];
			qu.m_Face.x = offx;
			qu.m_Face.y = 0;
			qu.m_Frame.x = qu.m_Face.x - 2;
			qu.m_Frame.y = qu.m_Face.y - 2;
			offx += FaceSizeX + 5;
		}
		if (m_DialogList.length > 0) offx += 10;

		for (i = 0; i < m_QuestList.length; i++) {
			qu = m_QuestList[i];
			qu.m_Tmp = 0;
		}
		
		for (i = QEManager.QuestMax - 1; i >= 0; i--) {
			if (EmpireMap.Self.m_UserQuestId[i] == 0) continue;

			qe = QEManager.FindById(EmpireMap.Self.m_UserQuestId[i]);
			if (qe == null) continue;
			if (!qe.m_StateReady) continue;

			for (u = 0; u < m_QuestList.length; u++) {
				qu = m_QuestList[u];
				if (qu.m_Id == qe.m_Id) break;
			}
			if (u >= m_QuestList.length) {
				qu = new QuestUnit();
				qu.m_Id = qe.m_Id;
				m_QuestList.push(qu);
			}
			qu.m_Tmp = 1;

			if (qu.m_Frame == null) {
				qu.m_Frame = new NewsFrame();
				qu.m_Frame.width=FaceSizeX+4;
				qu.m_Frame.height=FaceSizeY+4;
				qu.m_Frame.x = -2;
				qu.m_Frame.y = -2;
				addChild(qu.m_Frame);
			}

			if (qu.m_Face == null) {
				qu.m_Face = new Bitmap()
				//qu.m_Face.bitmapData = new Face(93, 104);//Common.CreateByName("Face" + Common.RaceSysName[m_NewsDictor] + "News") as BitmapData;
				addChild(qu.m_Face);
			}
			if (qu.m_Face.bitmapData == null) {
				qu.m_Face.bitmapData = FormDialog.BitmapFace(qe.m_FaceRace, qe.m_FaceNum);
				qu.m_Face.width = FaceSizeX;
				qu.m_Face.height = FaceSizeY;
			}
		}
		
		for (i = m_QuestList.length - 1; i >= 0 ; i--) {
			qu = m_QuestList[i];
			if (qu.m_Tmp != 0)  continue;
			qu.Clear();
			m_QuestList[i] = null;
			m_QuestList.splice(i, 1);
		}
		
//		offx = 0;
		for (i = 0; i < m_QuestList.length; i++) {
			qu = m_QuestList[i];
			qu.m_Frame.x = offx - 2;
			qu.m_Frame.y = -2;
			qu.m_Face.x = offx;
			qu.m_Face.y = 0;
			offx += FaceSizeX + 5;
		}
		
//if(test) m_Map.m_FormHint.Show("###FormQuestBar11");
		m_Map.m_FormNews.Prepare();

//if(test) m_Map.m_FormHint.Show("###FormQuestBar12");
		var inbegin:Boolean = m_NTScroll == 0;
		var havenew:Boolean = false;
		
//if(test) m_Map.m_FormHint.Show("###FormQuestBar13");
		if(m_SelectSprite==null) {
			m_SelectSprite = new Sprite();
			m_NTContent.addChild(m_SelectSprite);
			m_SelectSprite.graphics.lineStyle(0.0, 0, 0.0);
			m_SelectSprite.graphics.beginFill(0x0f2738, 1.0);
			m_SelectSprite.graphics.drawRect(0, 0, 10, 10);
			m_SelectSprite.graphics.endFill();
		}

		for (i = 0; i < m_NewsList.length; i++) {
			obj = m_NewsList[u];
			if (obj == null) continue;
			obj.Tmp = 0;
		}

		for (i = 0; i < Math.min(10, m_Map.m_FormNews.m_List.length); i++) {
			n = m_Map.m_FormNews.m_List[i];

			for (u = 0; u < m_NewsList.length; u++) {
				obj = m_NewsList[u];
				if (obj.m_ChangeDate == n.m_ChangeDate) break;
			}
			if (u >= m_NewsList.length) {
				str = m_Map.m_FormNews.FormatNews(n, null);
				if (str == null) continue;

				obj = new Object();
				obj.m_ChangeDate = n.m_ChangeDate;
				m_NewsList.push(obj);

				obj.Text = new TextField();
				obj.Text.x = 100;
				obj.Text.width = 1;
				obj.Text.height = 1;
				obj.Text.type = TextFieldType.DYNAMIC;
				obj.Text.selectable = false;
				obj.Text.border = false;
				obj.Text.background = false;
				obj.Text.multiline = true;
				obj.Text.wordWrap = true;
				obj.Text.condenseWhite=true;
				obj.Text.alwaysShowSelection=true;
				obj.Text.autoSize = TextFieldAutoSize.LEFT;
				obj.Text.antiAliasType = AntiAliasType.ADVANCED;
				obj.Text.gridFitType = GridFitType.PIXEL;
				obj.Text.defaultTextFormat = m_ContentTF;
				obj.Text.embedFonts = true;
				obj.Text.htmlText = str;
				m_NTContent.addChild(obj.Text);
				
				havenew = true;
			}
			obj.Tmp = 1;
		}

		for (i = m_NewsList.length - 1; i >= 0; i--) {
			obj = m_NewsList[i];
			if (obj == null) continue;
			if (obj.Tmp == 1) continue;

			if (obj.Text != undefined || obj.Text != null) {
				m_NTContent.removeChild(obj.Text);
				obj.Text = null;
			}
			m_NewsList.splice(i, 1);
		}
		
		m_NewsList.sort(m_Map.m_FormNews.sortList);
//if(test) m_Map.m_FormHint.Show("###FormQuestBar14");
		
		var lasty:int = 0;
		var newy:int = 0;
		var lastview:Object = null;
		for (i = 0; i < m_NewsList.length; i++) {
			obj = m_NewsList[i];
			if (obj.LastY == undefined) continue;
			lasty = obj.LastY;
			lastview = obj;
			break;
		}

		if ((m_NewsList.length <= 0) || (!EmpireMap.Self.m_ItfNews)) {
			m_NewsDictor = 0;
			m_NewsId = 0;
			m_NewsFrame.visible = false;
			m_NewsFace.visible = false;
			
			m_NTContent.visible = false;
			m_NTMask.visible = false;
			m_NTFrame.visible = false;

		} else {
			n = m_Map.m_FormNews.m_List[0];

			if (m_NewsDictor != n.m_Dictor || m_NewsDictor<=0) {
				m_NewsDictor = n.m_Dictor;
				m_NewsFace.bitmapData = Common.CreateByName("Face" + Common.RaceSysName[m_NewsDictor] + "News") as BitmapData;
				m_NewsFace.width=FaceSizeX;
				m_NewsFace.height=FaceSizeY;
			}

			m_NewsFrame.visible = true;
			m_NewsFace.visible = true;
			
			m_NewsFrame.x = offx - 2;
			m_NewsFace.x = offx;
			
			if (!m_NewsShow) {
				m_NTContent.visible = false;
				m_NTMask.visible = false;
				m_NTFrame.visible = false;
			} else {
				var nw:int = Math.min(550, m_Map.stage.stageWidth - (x + m_NewsFrame.x + m_NewsFrame.width) - 10);
				m_NTFrame.x = m_NewsFrame.x + m_NewsFrame.width + 2;
				m_NTFrame.y = m_NewsFrame.y;
				m_NTFrame.alpha = 0.5;
				m_NTFrame.width = nw;
				m_NTFrame.height = m_NewsFrame.height-2;
				m_NTFrame.visible = true;

				m_NTSizeX = m_NTFrame.width - 15;
				m_NTSizeY = m_NTFrame.height - 10;

				m_NTContent.x = m_NTFrame.x + 5;
				m_NTContent.y = m_NTFrame.y + 5;
				m_NTContent.visible = true;

				m_NTMask.graphics.clear();
				m_NTMask.graphics.beginFill(0xFF0000);
				m_NTMask.graphics.drawRect(m_NTContent.x, m_NTContent.y, m_NTSizeX, m_NTSizeY);
				m_NTMask.graphics.endFill();
				m_NTMask.visible = true;

				m_SelectSprite.visible = false;

				var sy:int = 0;

				for (i = 0; i < m_NewsList.length; i++) {
					obj = m_NewsList[i];
					obj.Text.x = 0;
					obj.Text.y = sy - 2;
					obj.Text.width = m_NTSizeX;
					obj.Text.height;
					
					obj.LastY = sy;
					if (obj == lastview) newy = sy;

					a = obj.Text.y + obj.Text.height - sy - 2;
					a = Math.ceil(a / m_NTLineSize) * m_NTLineSize;
					sy += a;
					
					if (m_NewsCur == obj.m_ChangeDate) {
						m_SelectSprite.visible = true;
						m_SelectSprite.x = obj.Text.x - 2;
						m_SelectSprite.y = obj.Text.y - 2;
						m_SelectSprite.width = obj.Text.width + 4;
						m_SelectSprite.height = obj.Text.height + 4;
					}
				}

				m_NTContentSizeY = sy;

				if (inbegin) {
					if ((newy - lasty) != 0) {
						m_NTScroll += newy - lasty;
						m_ScrollTimer.start();
					}
				} else {
					m_NTScroll += newy - lasty;
				}

				if (m_NTScroll > (m_NTContentSizeY - m_NTLineSize * 3)) m_NTScroll = m_NTContentSizeY - m_NTLineSize * 3;
				if (m_NTScroll < 0) m_NTScroll = 0;

				m_NTContent.y = Number(m_NTFrame.y + 5) - m_NTScroll;
			}
		}
//if(test) m_Map.m_FormHint.Show("###FormQuestBar15");
	}

	public function ScrollTimer(e:TimerEvent):void
	{
		m_NTScroll -= 1.0;
		if (m_NTScroll <= 0) {
			m_NTScroll = 0.0
			m_ScrollTimer.stop();
		}
		Update();
		
//		m_ScrollTimer.delay = 20;
//		if (m_NTScroll > (m_NTContentSizeY - m_NTSizeY)) {
//			m_NTScroll = m_NTContentSizeY - m_NTSizeY;
//			m_ScrollTimer.stop();
//			m_NTHideTime = Common.GetTime()+5000;
//		}
//		m_NTContent.y = Number(m_NTFrame.y + 5) - m_NTScroll;
	}

	public function NTHide():void
	{
		m_NTFrame.visible = false;
		m_NTContent.visible = false;
		m_NTMask.visible = false;
//		m_NTDate.visible = false;
//		m_NTLink.visible = false;
//		m_NTText.visible = false;
		m_ScrollTimer.stop();
	}

	public function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		m_Map.FloatTop(this);

		if (m_Map.m_MoveMap) return;

		var i:int;
		var qu:QuestUnit;

		for (i = 0; i < m_DialogList.length; i++) {
			qu = m_DialogList[i];
			if (qu.m_Face != null && qu.m_Face.hitTestPoint(e.stageX, e.stageY)) {
				QEManager.RunByName(qu.m_FileName, qu.m_QuestName, true);
			}
		}

		for (i = 0; i < m_QuestList.length; i++) {
			qu = m_QuestList[i];
			if (qu.m_Face != null && qu.m_Face.hitTestPoint(e.stageX, e.stageY)) {
				var qe:QEEngine = QEManager.FindById(qu.m_Id);
				if(qe!=null) {
					if (EmpireMap.Self.m_FormDialog.visible && EmpireMap.Self.m_FormDialog.m_QuestId == qu.m_Id) {
						EmpireMap.Self.m_FormDialog.Hide();
					} else {
						if (EmpireMap.Self.m_FormDialog.visible) EmpireMap.Self.m_FormDialog.Hide();
						EmpireMap.Self.m_FormDialog.ShowEx(qu.m_Id);
					}
				
					return;
				}
			}
		}

		if (m_NewsFace.visible && m_NewsFace.hitTestPoint(e.stageX, e.stageY)) {
			if (m_Map.m_FormNews.visible) m_Map.m_FormNews.Hide();
			else if (m_NewsShow) { m_NewsShow = false; Update(); m_Map.FormHideAll(); m_Map.m_FormNews.Show(); }
			else { m_NewsShow = true; Update(); }
			
//			NTHide();
//			if(m_Map.m_FormNews.visible) m_Map.m_FormNews.Hide();
//			else {
//				m_Map.CloseForModal();
//				m_Map.m_FormNews.Show();
//			}
		}
		if (m_NTFrame.visible && m_NTFrame.hitTestPoint(e.stageX, e.stageY)) {
			onMouseMove(null);
			if (m_NewsCur != 0) {
				m_Map.m_FormNews.m_NewsCur = m_NewsCur;
				m_Map.m_FormNews.onLinkClick();
			}
			//NTHide();
		}
	}

	public function onContentMouseWell(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		if (e.delta < 0) m_NTScroll += m_NTLineSize;
		else if(e.delta > 0) m_NTScroll -= m_NTLineSize;
		
		Update();
		
		onMouseMove(null);
	}

	protected function onMouseMove(e:MouseEvent):void
	{
		if(e!=null) e.stopImmediatePropagation();
		
		var cn:Number = PickNews();
		if (cn != m_NewsCur) {
			m_NewsCur = cn;
			if (m_NewsCur == 0) Mouse.cursor = MouseCursor.AUTO;
			else Mouse.cursor = MouseCursor.BUTTON;
			Update();
		}
		
		m_Map.m_Info.Hide();
	}
	
	protected function onMouseOut(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		if (m_NewsCur != 0) {
			Mouse.cursor = MouseCursor.AUTO;
			m_NewsCur = 0;
			Update();
		}
	}
	
	public function PickNews():Number
	{
		var i:int;
		var obj:Object;
		
		if (!m_NewsShow) return 0;
		if (!m_NTFrame.visible) return 0;
		if (!m_NTFrame.hitTestPoint(stage.mouseX, stage.mouseY)) return 0;

		for (i = 0; i < m_NewsList.length; i++) {
			obj = m_NewsList[i];
			if (obj.Text == undefined) continue;

			if (obj.Text.hitTestPoint(stage.mouseX, stage.mouseY)) return obj.m_ChangeDate;
		}

		return 0;
	}
	
	public function BeginDialogBar():void
	{
		var i:int;
		var qu:QuestUnit;
		for (i = 0; i < m_DialogList.length; i++) {
			qu = m_DialogList[i];
			qu.m_Tmp = 0;
		}
	}
	
	public function EndDialogBar():void
	{
/*		var i:int;
		var qu:QuestUnit;
		for (i = m_DialogList.length - 1; i >= 0 ; i--) {
			qu = m_DialogList[i];
			if (qu.m_Tmp != 0) continue;
			
			qu.Clear();
			m_DialogList.splice(i, 1);
		}*/
	}
	
	public function UpdateFace(questid:uint):void
	{
		var i:int;
		var qu:QuestUnit;
		for (i = 0; i < m_QuestList.length; i++) {
			qu = m_QuestList[i];
			if (qu.m_Id == questid && qu.m_Face != null) qu.m_Face.bitmapData = null;
		}
		Update();
	}

	public function AddDialog(filename:String, questname:String, race:int = 0, facenum:int = 0, cptname:String = null):void
	{
		var i:int;
		var qu:QuestUnit;
		for (i = 0; i < m_DialogList.length; i++) {
			qu = m_DialogList[i];
			if (qu.m_FileName == filename && qu.m_QuestName == questname) break;
		}
		if (i >= m_DialogList.length) {
			qu = new QuestUnit();
			qu.m_FileName = filename;
			qu.m_QuestName = questname;
			m_DialogList.push(qu);
		}
		qu.m_Tmp = 1;
		if (qu.m_CptName != cptname || qu.m_FaceNum != facenum || qu.m_Race != race) {
			qu.m_CptName = cptname;
			qu.m_FaceNum = facenum;
			qu.m_Race = race;
			if (qu.m_Face != null) {
				qu.m_Face.bitmapData = null;
			}
		}
	}
}

}

{
import Empire.*;
import flash.display.*;

class QuestUnit
{		
	public var m_Tmp:int = 0;
	public var m_Id:uint = 0;
	
	public var m_FileName:String = null;
	public var m_QuestName:String = null;
	public var m_Race:int = 0;
	public var m_FaceNum:int = 0;
	public var m_CptName:String = null;
	
	public var m_Frame:Sprite = null;
	public var m_Face:Bitmap = null;

	public function QuestUnit():void
	{
	}
	
	public function Clear():void
	{
		m_Tmp = 0;
		m_Id = 0;
		
		if (m_Frame != null) {
			EmpireMap.Self.m_FormQuestBar.removeChild(m_Frame);
			m_Frame = null;
		}
		if (m_Face != null) {
			EmpireMap.Self.m_FormQuestBar.removeChild(m_Face);
			m_Face = null;
		}
	}
}
}
