// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import fl.controls.listClasses.*;
import fl.data.*;
import fl.events.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;

//import spark.components.*;

//import mx.controls.*;

public class FormChat extends FormChatClass
{
//	private var m_Map:EmpireMap;

	public static var Self:FormChat = null;
	
	public var m_Pages:Array=new Array();
	public var m_ChannelList:Array=new Array();
	public var m_MsgList:Array=new Array();
	
	public var m_PageCur:int=0;
	public var m_PageMouse:int=-1;

	public var m_QueryLockTime:Number=0;

	public var m_Timer:Timer=new Timer(500);

	public var m_SizeX:int;
	public var m_SizeY:int;

	public var m_Text:String = "";

//	public var m_ToUser:String = "";
	public var m_ToUserId:uint = 0;
	public var m_ToUserIdList:Vector.<uint> = new Vector.<uint>();

	public var m_RecvChannelOk:Boolean=false;

	public var m_Align:int=1; // 0-client 1-LeftBottom

	public var m_OnlineUserVersion:uint=0;
	public var m_OnlineUserList:Array=new Array();

	public var m_IgnoreUserList:Array=new Array();

	public var m_LineChannelId:Array=new Array();
//	public var m_LineNoUserId:Array = new Array();
	public var m_LineLeftUserId:Vector.<uint> = new Vector.<uint>();
	public var m_LineRightUserId:Vector.<uint> = new Vector.<uint>();

	//public var m_SortByName:Boolean=false;

	static public const UserListTypeOnlineName:int=1;
	static public const UserListTypeOnlineDate:int=2;
	static public const UserListTypeIgnore:int = 3;
	static public const UserListTypeUnion:int=4;
	public var m_UserListType:int = UserListTypeOnlineDate;
	
	public var m_UserListUnionId:uint = 0;

	static public const IgnoreFlagChatGeneral:int = 1;
	static public const IgnoreFlagChatClan:int = 2;
	static public const IgnoreFlagChatWhisper:int = 4;

	//public var m_GoSet:TextField=null;

	//public var Text:TextArea=new TextArea();

	//public var m_UIText:mx.controls.TextArea = null;
	
//	public var m_UIText:TextArea = null;

	public function FormChat() //map:EmpireMap
	{
		Self=this;
//		m_Map=map

//		m_UIText = new TextArea();
//		addChild(m_UIText);

/*		var css:StyleSheet = new StyleSheet( );
		css.parseCSS("a {color: #0000FF;} a:hover {text-decoration: underline;}");
		
		var sb:mx.controls.VScrollBar = new mx.controls.VScrollBar();
		sb.width = 100;
		sb.height = 100;
		addChild(sb);
		
		m_UIText = new mx.controls.TextArea();
		//m_UIText = UIObject.createClassObject(mx.controls.TextArea, "ta", 910);
		//m_UIText=createObject("TextArea", "ta", 1);
		m_UIText.styleSheet = css;
		m_UIText.percentWidth = 100;
		m_UIText.percentHeight = 100;
		addChild(m_UIText);*/

		//addChild(Text);
		
/*		m_GoSet=new TextField();
		m_GoSet.x=0;
		m_GoSet.y=0;
		m_GoSet.width=1;
		m_GoSet.height=1;
		m_GoSet.type=TextFieldType.DYNAMIC;
		m_GoSet.selectable=false;
		m_GoSet.border=true;
		m_GoSet.borderColor=0x069ee5;
		m_GoSet.background=true;
		m_GoSet.backgroundColor=0x000000;
		m_GoSet.multiline=false;
		m_GoSet.autoSize=TextFieldAutoSize.LEFT;
		m_GoSet.antiAliasType=AntiAliasType.ADVANCED;
		m_GoSet.gridFitType=GridFitType.PIXEL;
		m_GoSet.defaultTextFormat=new TextFormat("Calibri",12,0xffffff);
		m_GoSet.embedFonts=true;
		m_GoSet.text=' O ';
		m_GoSet.addEventListener(MouseEvent.MOUSE_OVER,fjOver);
		m_GoSet.addEventListener(MouseEvent.MOUSE_OUT,fjOut);
		m_GoSet.addEventListener(MouseEvent.CLICK,MenuOpen);
		addChild(m_GoSet);*/
		
		UserList.Self.addEventListener("RecvUser",RecvUser);

		m_UIText.addEventListener(MouseEvent.CLICK, TextClick);
//		m_UIText.textField.addEventListener(FocusEvent.FOCUS_IN, TextFocusIn,false,999);
		m_UIText.textField.addEventListener(FocusEvent.FOCUS_OUT, TextFocusOut,false,999);
//		m_UIText.textField.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, TextFocusKeyChange,false,999);
//		m_UIText.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, TextFocusMouseChange,false,999);
		
		Msg.addEventListener(ComponentEvent.ENTER, SendMsg);
		Msg.addEventListener(Event.CHANGE, MsgChange);
		MsgChannel.addEventListener(Event.CHANGE, MsgChannelChange);
		MsgToUser.addEventListener(Event.CHANGE, MsgToUserChange);
	
		//OUList.addEventListener(MouseEvent.MOUSE_UP, OUUserClick);
		addEventListener(MouseEvent.CLICK, OUUserClick);

		m_Timer.addEventListener("timer",QueryMsg);

		Msg.addEventListener(MouseEvent.MOUSE_DOWN, MsgSaveSel);
		Msg.addEventListener(MouseEvent.MOUSE_UP, MsgSaveSel);
		Msg.addEventListener(MouseEvent.MOUSE_MOVE, MsgSaveSel);
		Msg.addEventListener(MouseEvent.MOUSE_OUT, MsgSaveSel);
		Msg.addEventListener(KeyboardEvent.KEY_DOWN, MsgSaveSel);
		Msg.addEventListener(KeyboardEvent.KEY_UP, MsgSaveSel);
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}
	
	public function IsScroll():Boolean
	{
		return false;
		// Заглушка так как неправильно устанавливается обработчик а UIScrollBar
		if (!visible) return false;
		
		if (!m_UIText.verticalScrollBar.mouseChildren) return true;
		return false;
	}

	public function TextFocusIn(event:FocusEvent):void
	{
		//event.preventDefault();
//trace("FocusIn");
		event.stopImmediatePropagation();
//		m_UIText.textField.scrollV = m_UIText.textField.maxScrollV;
	}

	public function TextFocusOut(event:FocusEvent):void
	{
//trace("FocusOut");
		//event.preventDefault();
		event.stopImmediatePropagation();
		m_UIText.textField.scrollV = m_UIText.textField.maxScrollV;
	}
	
	public function TextFocusKeyChange(event:FocusEvent):void
	{
//trace("FocusKeyChange");
		event.stopImmediatePropagation();
//		m_UIText.textField.scrollV = m_UIText.textField.maxScrollV;
	}
	
	public function TextFocusMouseChange(event:FocusEvent):void
	{
//trace("FocusMouseChange");
		event.stopImmediatePropagation();
//		m_UIText.textField.scrollV = m_UIText.textField.maxScrollV;
//trace("target:", event.target, event.target == m_UIText.textField, "relatedObject:", event.relatedObject, event.relatedObject == m_UIText.textField);
		//if(event.target==m_UIText.textField) event.preventDefault();
		//event.stopImmediatePropagation();
		//m_UIText.textField.scrollH = m_UIText.textField.maxScrollH;
	}

	public function fjOver(e:MouseEvent):void
	{
		var l:TextField=e.target as TextField;
		l.backgroundColor=0x0000ff;
	}

	public function fjOut(e:MouseEvent):void
	{
		var l:TextField=e.target as TextField;
		l.backgroundColor=0x000000;
	}

	public function StageResize():void
	{
//		if (visible && EmpireMap.Self.IsResize()) Show();
		if (!visible) return;
		
		if (m_Align == 0) {
			x=0;
			y=0;
			
		} else {
			x = 0;
			y = parent.stage.stageHeight - m_SizeY;
		}
	}
	
	public function Show():void
	{
		EmpireMap.Self.FloatTop(this);
		
		visible=true;
		
		PagesLoad();
		IgnoreLoad();

		var tf:TextFormat = new TextFormat("Calibri",14,0xffffff);
		
		m_UIText.focusEnabled=false;
		m_UIText.mouseFocusEnabled=false;

		m_UIText.setStyle("upSkin", TextArea_Chat);
		m_UIText.setStyle("focusRectSkin", focusRectSkinNone);
		m_UIText.setStyle("textFormat", tf);
		m_UIText.setStyle("embedFonts", true);
		m_UIText.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_UIText.textField.gridFitType=GridFitType.PIXEL;
		
		//m_UIText.removeChild(m_UIText.verticalScrollBar);
		//m_UIText.verticalScrollBar = new UIScrollBarMy();
		//m_UIText.addChild(m_UIText.verticalScrollBar);
		
		Common.UIChatBar(m_UIText);
		//m_UIText.verticalScrollBar.addEventListener(MouseEvent.MOUSE_DOWN, vsb_MouseDown, true, 999);
		//m_UIText.verticalScrollBar.getChildAt(1).addEventListener(MouseEvent.MOUSE_DOWN, vsb_MouseDown, false, 999);
		

/*		Text.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
		Text.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
		Text.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
		Text.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);

		Text.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
		Text.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
		Text.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
		Text.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
		Text.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);

		Text.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
		Text.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
		Text.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
		Text.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);

		Text.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
		Text.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
		Text.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
		Text.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);*/

		Msg.setStyle("upSkin", TextInput_Chat);
		Msg.setStyle("focusRectSkin", focusRectSkinNone);
		Msg.setStyle("textFormat", tf);
		Msg.setStyle("embedFonts", true);
		Msg.textField.antiAliasType=AntiAliasType.ADVANCED;
		Msg.textField.gridFitType=GridFitType.PIXEL;

		Msg.textField.maxChars = (120-4) * 5;

		MsgChannel.setStyle("textFormat", tf);
		MsgChannel.setStyle("embedFonts", true);
		MsgChannel.textField.setStyle("textFormat", tf);
		MsgChannel.textField.setStyle("embedFonts", true);
		MsgChannel.textField.textField.antiAliasType=AntiAliasType.ADVANCED;
		MsgChannel.textField.textField.gridFitType=GridFitType.PIXEL;
		MsgChannel.dropdown.setRendererStyle("textFormat", tf);
		MsgChannel.dropdown.setRendererStyle("embedFonts", true);

		MsgChannel.dropdown.addEventListener(MouseEvent.MOUSE_DOWN, meStopPropagation);

		MsgChannel.setStyle("upSkin",Chat_ComboBox_upSkin);
		MsgChannel.setStyle("downSkin",Chat_ComboBox_upSkin);
		MsgChannel.setStyle("overSkin",Chat_ComboBox_upSkin);
		MsgChannel.setStyle("disabledSkin",Chat_ComboBox_upSkin);
		MsgChannel.setStyle("buttonWidth",10);
		MsgChannel.setStyle("focusRectSkin", focusRectSkinNone);

		MsgToUser.setStyle("textFormat", tf);
		MsgToUser.setStyle("embedFonts", true);
		MsgToUser.textField.setStyle("textFormat", tf);
		MsgToUser.textField.setStyle("embedFonts", true);
		MsgToUser.textField.textField.antiAliasType=AntiAliasType.ADVANCED;
		MsgToUser.textField.textField.gridFitType=GridFitType.PIXEL;
		MsgToUser.dropdown.setRendererStyle("textFormat", tf);
		MsgToUser.dropdown.setRendererStyle("embedFonts", true);

		MsgToUser.dropdown.addEventListener(MouseEvent.MOUSE_DOWN, meStopPropagation);

		MsgToUser.setStyle("upSkin",Chat_ComboBox_upSkin);
		MsgToUser.setStyle("downSkin",Chat_ComboBox_upSkin);
		MsgToUser.setStyle("overSkin",Chat_ComboBox_upSkin);
		MsgToUser.setStyle("disabledSkin",Chat_ComboBox_upSkin);
		MsgToUser.setStyle("buttonWidth",10);
		MsgToUser.setStyle("focusRectSkin", focusRectSkinNone);

		OUList.setStyle("skin",ListOnlineUser_skin);
		OUList.setStyle("cellRenderer",OnlineUserRenderer);

		OUList.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
		OUList.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
		OUList.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
		OUList.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);

		OUList.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
		OUList.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
		OUList.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
		OUList.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
		OUList.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);

		OUList.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
		OUList.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
		OUList.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
		OUList.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);

		OUList.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
		OUList.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
		OUList.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
		OUList.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);

		if (m_Align == 0) {
			m_SizeX = Math.round(parent.stage.stageWidth) + 100;
			m_SizeY = Math.round(parent.stage.stageHeight);
			
			ChatBG.width = m_SizeX;
			ChatBG.height = m_SizeY;
			
		} else {
			m_SizeX = Math.max(300, Math.round(Math.min(parent.stage.stageWidth, parent.stage.stageHeight) * 0.45)) + 100;
			m_SizeY = Math.max(200, Math.round(Math.min(parent.stage.stageWidth, parent.stage.stageHeight) * 0.25));

			ChatBG.width = m_SizeX + 1;
			ChatBG.height = m_SizeY + 1;
		}
		StageResize();

		OUList.width=100;
		OUList.height=m_SizeY-5-Msg.height-10;
		OUList.x=m_SizeX-OUList.width-5;
		OUList.y=5;
		
		m_UIText.x=5;
		m_UIText.y=5;
		m_UIText.width=m_SizeX-10-OUList.width-5;
		m_UIText.height=m_SizeY-5-Msg.height-10;
		

		m_Timer.start();

		UpdateMsgToUser();
		UpdateMsgChannel();
		Update();
		
		m_UIText.verticalScrollPosition=m_UIText.maxVerticalScrollPosition;
		MsgChannel.setFocus();
	}
	
	public function meStopPropagation(e:MouseEvent):void
	{
		e.stopPropagation();
	}
	
	public var vsb_inDrag:Boolean = false;
	public var vsb_thumbScrollOffset:int = 0;
	public var vsb_sb:UIScrollBar = null;
	public var vsb_track:BaseButton = null;
	public var vsb_tumb:LabelButton = null;
	
	public function vsb_MouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
//trace(vsb_MouseDown, e.currentTarget, e.target);

		vsb_sb = e.target.parent as UIScrollBar;
		vsb_track = vsb_sb.getChildAt(0) as BaseButton;
		vsb_tumb = vsb_sb.getChildAt(1) as LabelButton;

		vsb_inDrag = true;
		vsb_thumbScrollOffset = vsb_sb.mouseY - vsb_tumb.y;
		vsb_tumb.mouseStateLocked = true;
		vsb_sb.mouseChildren = false;

		stage.addEventListener(MouseEvent.MOUSE_MOVE, vsb_ThumbDrag, true, 1000);
        stage.addEventListener(MouseEvent.MOUSE_UP, vsb_ThumbRelease, true, 1000);
	}
	
	public function vsb_ThumbDrag(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var v:Number = Math.max(0, Math.min(vsb_track.height - vsb_tumb.height, vsb_sb.mouseY - vsb_track.y - vsb_thumbScrollOffset));
        vsb_sb.setScrollPosition(v / (vsb_track.height - vsb_tumb.height) * (vsb_sb.maxScrollPosition - vsb_sb.minScrollPosition) + vsb_sb.minScrollPosition);
	}

	public function vsb_ThumbRelease(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		vsb_inDrag = false;
		vsb_sb.mouseChildren = true;
		vsb_tumb.mouseStateLocked = false;
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, vsb_ThumbDrag, true);
        stage.removeEventListener(MouseEvent.MOUSE_UP, vsb_ThumbRelease, true);
	}

	public function Hide():void
	{
		visible=false;
		m_Timer.stop();
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<width && mouseY>=0 && mouseY<height) return true;
		if(PagePick()>=0) return true;
		return false;
	}
	
	public function onMouseDown(e:MouseEvent):void
	{
		e.stopPropagation();
		EmpireMap.Self.FloatTop(this);
		
//		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//trace("Chat.MouseDown");
	}

/*	public function onMouseUp(e:MouseEvent):void
	{
		e.stopPropagation();
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
trace("!!!Up");
		OUUserClick(e);
	}*/
	
	public function onMouseMove(e:MouseEvent):void
	{
		//if (!Text.verticalScrollBar.trackScrolling)
		
//		var str:String = "";
//		var obj:DisplayObject = this;
//		while (obj != null) {
//			str += " " + obj.toString();
//			obj = obj.parent;
//		}
//		trace(str);
		
		//trace(Text.verticalScrollBar.willTrigger(MouseEvent.MOUSE_MOVE),Text.verticalScrollBar.hasEventListener(MouseEvent.MOUSE_MOVE));
		
		if(!IsScroll()) e.stopPropagation();
		
		EmpireMap.Self.m_Info.Hide();
	}
	
	public function onMouseWheel(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	public function ColorByChannel(ch:Object, txt:Boolean=true, username:Boolean=false):Object
	{
		var clr:uint;
		if(username) {
/*			if(ch.Type=="GLOBAL") return "4f49c5";
			else if(ch.Type=="LOCAL") return "bf9196";
			else if(ch.Type=="CLAN") return "12cc1b";
			else if(ch.Type=="USER") return "cb54cf";
			else throw Error("");*/
			if(ch.Type=="GLOBAL") return "3f39b5";
			else if(ch.Type=="LOCAL") return "af8186";
			else if(ch.Type=="CLAN") return "02bc0b";
			else if(ch.Type=="USER") return "bb44bf";
			else throw Error("");
		} else if(txt) {
			if(ch.Type=="GLOBAL") return "7f79f5";
			else if(ch.Type=="LOCAL") return "efc1c6";
			else if(ch.Type=="CLAN") return "42fc4b";
			else if(ch.Type=="USER") return "fb84ff";
			else throw Error("");
		} else {
			if(ch.Type=="GLOBAL") return 0x7f79f5;
			else if(ch.Type=="LOCAL") return 0xefc1c6;
			else if(ch.Type=="CLAN") return 0x42fc4b;
			else if(ch.Type=="USER") return 0xfb84ff;
			else throw Error("");
		}
	}

	public function RecvUser(e:Event):void
	{
		if(visible) {
			Update();
			UpdateUserList();
		}
	}

	public function Update():void
	{
		var i:int;

//var t0:Number = Common.GetTime();
		var oldpos:int=m_UIText.verticalScrollPosition;
		var oldmax:int=m_UIText.maxVerticalScrollPosition;

		//if(m_Text.length>0) m_Text=m_Text+"<br>";
		//m_Text=m_Text+msg;
		//Text.htmlText=m_Text;
		
		var ch:Object;
		var user:User;
		var userto:User;
		var txt:String='';
		var offmsg:Boolean=false;
		
		m_LineChannelId.length=0;
//		m_LineNoUserId.length = 0;
		m_LineLeftUserId.length = 0;
		m_LineRightUserId.length = 0;
		
//		txt+="UserId:"+Server.Self.m_UserId+" Session:"+Server.Self.m_Session;
//		for (var pn:String in loaderInfo.parameters) {
//			txt+="<br>Par "+pn+":"+loaderInfo.parameters[pn];
//		}

//trace("Update MsgCnt="+m_MsgList.length);
		for(i=0;i<m_MsgList.length;i++) {
//trace("Update ChannelId="+m_MsgList[i].ChannelId);
			ch=GetChannel(m_MsgList[i].ChannelId);
			if(ch==null) continue;
			//if(!ch.On) continue;
			if(!PageChannelIsOn(m_PageCur,ch)) continue;

			ch.NumShow=ch.Num;

			user=null;
			if (m_MsgList[i].AuthorId) {
				var ignoreflag:uint = 0;
				
				if (ch.Type == "USER") ignoreflag |= IgnoreFlagChatWhisper;
				else if (ch.Type == "CLAN") ignoreflag |= IgnoreFlagChatClan;
				else ignoreflag |= IgnoreFlagChatGeneral;

				if(IsIgnore(m_MsgList[i].AuthorId,ignoreflag)) continue;
				user=UserList.Self.GetUser(m_MsgList[i].AuthorId,true,false);
				if(user==null) { offmsg=true; continue; }
			}

			userto=null;
			if(m_MsgList[i].ToId) {
				userto=UserList.Self.GetUser(m_MsgList[i].ToId,true,false);
				if(userto==null) { offmsg=true; continue; }
			}

			if(offmsg) continue;

			if(txt.length>0) txt+="<br>";
			//if(ch.Type=="GLOBAL") txt+="<font color='#00ffff'>"
			//else if(ch.Type=="USER") txt+="<font color='#fe81ff'>";
			//else txt+="<font color='#ffffff'>";
			txt+="<font color='#"+ColorByChannel(ch,true,true)+"'>"
			//if(user) txt+=user.m_Name;
			if (user) txt += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
			//if(userto) txt+=" -> "+userto.m_Name;
			if (userto) txt += " -> " + EmpireMap.Self.Txt_CotlOwnerName(0, userto.m_Id);

			txt+="</font><font color='#"+ColorByChannel(ch)+"'>"
			if(user || userto) txt+=": ";
			txt += BaseStr.FormatTag(m_MsgList[i].Msg);// ReplaceBadWord(m_MsgList[i].Msg, Common.TxtChat.LikeLetter, Common.TxtChat.GoodWord, Common.TxtChat.BadWord);
			txt+="</font>"

			m_LineChannelId.push(ch.Id);
			m_LineLeftUserId.push(user?user.m_Id:0);
			m_LineRightUserId.push(userto?userto.m_Id:0);
//			if(user || userto) m_LineNoUserId.push(false);
//			else m_LineNoUserId.push(true);
		}
		
		if(!Server.Self.IsConnect()) {
			txt+="<br><font color='#ffff00'>"+Common.TxtChat.LostConnection+"</font>";
		}
		
		if(txt!=m_Text) {
			m_Text=txt;
			m_UIText.htmlText = txt;
			m_UIText.drawNow();

//trace("OldPos=",oldpos,"OldMax=",oldmax," NewMax=",m_UIText.maxVerticalScrollPosition);

			if(oldpos==oldmax) {
				m_UIText.verticalScrollPosition=m_UIText.maxVerticalScrollPosition;
			} else {
				m_UIText.verticalScrollPosition=Math.min(m_UIText.maxVerticalScrollPosition,oldpos);
			}
		}

//var t1:Number = Common.GetTime();
		PagesUpdate();
//var t2:Number = Common.GetTime();
//trace("ChatUpdate:", t1 - t0, t2 - t1);
	}
	
	public function QueryOnlineUser():void
	{
		Server.Self.Query("emonlineuser","",RecvOnlineUser,false);
	}

	private function RecvOnlineUser(event:Event):void
	{
		var	i:int;
		var obj:Object;
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(buf.readUnsignedByte()!=0) return;

		var ver:uint=buf.readUnsignedInt();
		var ds:uint=buf.readUnsignedInt();

		if(m_OnlineUserVersion!=ver) return;

		//m_OnlineUserList.length=0;
		//var delu:Array=new Array(m_OnlineUserList.length);
		for(i=0;i<m_OnlineUserList.length;i++) m_OnlineUserList[i].del=true; 

		var sl:SaveLoad=new SaveLoad();
		
		if(ds>0) {
			sl.LoadBegin(buf);
			while(true) {
				var uid:uint=sl.LoadDword();
				if(uid==0) break;
				var vdate:uint=sl.LoadDword();

				for(i=0;i<m_OnlineUserList.length;i++) {
					if(m_OnlineUserList[i].Id==uid) break;
				}
				if(i<m_OnlineUserList.length) {
					m_OnlineUserList[i].del=false;
					m_OnlineUserList[i].VDate=vdate;
				} else { 
					obj=new Object();
					obj.Id=uid;
					obj.VDate=vdate;
					obj.del=false;
					m_OnlineUserList.push(obj);
				}
			}
			sl.LoadEnd();
		}

		for(i=m_OnlineUserList.length-1;i>=0;i--) {
			if(m_OnlineUserList[i].del) {
				m_OnlineUserList.splice(i,1);
			}
		}

		UpdateUserList();
	}
	
	public function UserIsOnline(id:uint):Boolean
	{
		var i:int;
		for(i=0;i<m_OnlineUserList.length;i++) {
			if(m_OnlineUserList[i].Id==id) return true;
		}
		return false;
	}
	
/*	public function UserIdByName(name:String):uint
	{
		name = name.toLocaleLowerCase();
		var i:int;
		for (i = 0; i < m_OnlineUserList.length; i++) {
			//var user:User = UserList.Self.GetUser(m_OnlineUserList[i].Id, true);
			//if (user == null) continue;
			
//trace(user.m_Name, name, user.m_Name.toLocaleLowerCase() == name);
			//if (user.m_SysName.toLocaleLowerCase() == name) return m_OnlineUserList[i].Id;
			if (EmpireMap.Self.Txt_CotlOwnerName(0,m_OnlineUserList[i].Id) == name) return m_OnlineUserList[i].Id;
		}
		return 0;
	}*/

	public function sortOnlineUserByUnion(a:Object, b:Object):Number
	{
		var a_:String=a.unionname.toLowerCase();
		var b_:String=b.unionname.toLowerCase();
		if(a_<b_) return -1;
		else if(a_>b_) return 1;
		
		a_=a.label.toLowerCase();
		b_=b.label.toLowerCase();
		if(a_<b_) return -1;
		else if(a_>b_) return 1;
		return 0;
	}
	
	public function sortOnlineUserByName(a:Object, b:Object):Number
	{
		var a_:String=a.label.toLowerCase();
		var b_:String=b.label.toLowerCase();
		if(a_<b_) return -1;
		else if(a_>b_) return 1;
		return 0;
	}

	public function sortOnlineUserByVDate(a:Object, b:Object):Number
	{
		if(a.vdate<b.vdate) return 1;
		else if(a.vdate>b.vdate) return -1;
		return 0;
	}
	
	public function UpdateUserList():void
	{
		var i:int;
		var user:User;
		var str:String;
		var str2:String;
		var uni:Union;

		var seluser:String="";
		if(OUList.selectedIndex>=0 && OUList.selectedIndex<OUList.dataProvider.length) {
			seluser=OUList.dataProvider.getItemAt(OUList.selectedIndex).label;
			//OUList.selectedItem.label;
//			OUList.
		}

		var dp:Array = new Array();

		if(m_UserListType==UserListTypeOnlineName || m_UserListType==UserListTypeOnlineDate || m_UserListType==UserListTypeUnion) {
			var dp2:Array = new Array();
			
			//if (EmpireMap.Self.m_UnionId != 0) {
				//var uni:Union = UserList.Self.GetUnion(EmpireMap.Self.m_UnionId);
				//if(uni!=null)
			//	dp.push( { label:":", id:0 } );
			//}
		
			for(i=0;i<m_OnlineUserList.length;i++) {
				user=UserList.Self.GetUser(m_OnlineUserList[i].Id,true,false);
				if (user == null) continue;

				if (m_UserListType == UserListTypeUnion && m_UserListUnionId != 0 && m_UserListUnionId != user.m_UnionId) continue;

				str2 = "";
				if (user.m_UnionId != 0) {
					uni = UserList.Self.GetUnion(user.m_UnionId);
					if (uni != null) str2 = uni.m_Name;
				}

				//str = user.m_Name;
				str = EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				if (m_UserListType == UserListTypeOnlineDate && EmpireMap.Self.m_Debug)  str += " (" + Math.floor((EmpireMap.Self.GetServerGlobalTime() - m_OnlineUserList[i].VDate * 1000) / (1000 * 60)).toString() + ")";; 

//for(var k:int=0;k<100;k++)
				if (m_UserListType != UserListTypeUnion && (EmpireMap.Self.m_UnionId == 0 || (EmpireMap.Self.m_UnionId != 0 && EmpireMap.Self.m_UnionId == user.m_UnionId))) dp.push( { label:str, vdate:m_OnlineUserList[i].VDate, id:user.m_Id, unionid:user.m_UnionId, unionname:str2 } );
				else dp2.push( { label:str, vdate:m_OnlineUserList[i].VDate, id:user.m_Id, unionid:user.m_UnionId, unionname:str2 } );

//				dp.push({label:"test line1 line2 line3 line4"});
			}
			if (m_UserListType == UserListTypeUnion) dp.sort(sortOnlineUserByUnion);
			else if (m_UserListType == UserListTypeOnlineName) dp.sort(sortOnlineUserByName);
			else dp.sort(sortOnlineUserByVDate);
			
			if (m_UserListType == UserListTypeUnion) dp2.sort(sortOnlineUserByUnion);
			else if(m_UserListType==UserListTypeOnlineName) dp2.sort(sortOnlineUserByName);
			else dp2.sort(sortOnlineUserByVDate);
			
			if (m_UserListType == UserListTypeUnion) {
				var curunionid:int = -1;
				for (i = 0; i < dp2.length; i++) {
					if (dp2[i].unionid != curunionid) {
						curunionid = dp2[i].unionid;
						if (curunionid==0) {
							dp.push( { label:Common.TxtChat.UserListOnlineNutral + ":", id:0 } );
						} else {
							uni = UserList.Self.GetUnion(curunionid);
							if (uni != null) dp.push( { label:uni.NameUnion() + " " + uni.m_Name + ":", id:0 } );
							else dp.push( { label:Common.TxtChat.UserListOnlineUnion + ":", id:0 } );
						}
					}
					dp.push(dp2[i]);
				}
			} else {
				if (dp2.length > 0) {
					dp.push( { label:"-----", id:0 } );
					for (i = 0; i < dp2.length; i++) dp.push(dp2[i]);
				}
			}
			
		} else if(m_UserListType==UserListTypeIgnore) {
			for(i=0;i<m_IgnoreUserList.length;i++) {
				user=UserList.Self.GetUser(m_IgnoreUserList[i].Id,true,false);
				if(user==null) continue;

				// dp.push( { label:user.m_Name, id:user.m_Id } );
				dp.push( { label:EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id), id:user.m_Id } );
			}
		}
		OUList.dataProvider = new DataProvider(dp);

		if(seluser.length>0) ScrollToUser(seluser,false);
	}

	public function ScrollToUser(name:String, scroll:Boolean=true):void
	{
		var i:int;
		for(i=0;i<OUList.dataProvider.length;i++) {
			var obj:Object=OUList.dataProvider.getItemAt(i);
			if(obj.label===name) break;
		}
		if(i>OUList.dataProvider.length) return;
		OUList.selectedIndex=i;
		if(scroll) OUList.scrollToSelected();
	}

	public function ScrollToUserId(id:uint, scroll:Boolean = true):void
	{
		var i:int;
		for (i = 0; i < OUList.dataProvider.length; i++) {
			var obj:Object = OUList.dataProvider.getItemAt(i);
			if (obj.id === id) break;
		}
		if (i > OUList.dataProvider.length) return;
		OUList.selectedIndex = i;
		if (scroll) OUList.scrollToSelected();
	}

	public function QueryChList():void
	{
		Server.Self.Query("chatchlist","&local="+Server.Self.m_LocalChatName,RecvChList);
	}

	private function RecvChList(event:Event):void
	{
		var i:int,u:int;
		var ch:Object;

		//m_ChannelList.length=0;

		var loader:URLLoader = URLLoader(event.target);
		if(loader.bytesTotal<1) return;
//trace(loader.data);

		m_RecvChannelOk=true;

		for(u=0;u<m_ChannelList.length;u++) {
			m_ChannelList[u].del=true;
		}

		var needupdate:Boolean=false;

		var al:Array=loader.data.split("\n");
		for(i=0;i<al.length;i++) {
			var ap:Array=al[i].split("~");

			if(ap[2]=="GLOBAL") {}
			else if(ap[2]=="LOCAL") {}
			else if(ap[2]=="CLAN") {}
			else if(ap[2]=="USER") {}
			else continue;

			if(ap[3]!=Server.LangSysName[Server.Self.m_Lang]) continue;

			for(u=0;u<m_ChannelList.length;u++) {
				ch=m_ChannelList[u];
				if(ch.Id==ap[0] && ch.Key==ap[1]) break;
			}
			if(u>=m_ChannelList.length) {
				ch=new Object();
				ch.Id=ap[0];
				ch.Key=ap[1];
				ch.Num=0;
				ch.NumShow=0;
				m_ChannelList.push(ch);

/*				for(u=0;u<m_ChannelList.length;u++) {
					if(m_ChannelList[u].Type==ap[2] && m_ChannelList[u].Name==ap[4]) break;
				}
				if(u<m_ChannelList.length) {
					ch.On=m_ChannelList[u].On;				
				} else {
					ch.On=false;
					if(!ch.On) ch.On=(ap[2]=="GLOBAL") && (ap[4]=="General");
					if(!ch.On) ch.On=(ap[2]=="LOCAL");
					if(!ch.On) ch.On=(ap[2]=="USER");
					if(!ch.On) ch.On=(ap[2]=="CLAN");
				}*/

				needupdate=true;
			}
			ch.Type=ap[2];
			ch.Lang=ap[3];
			ch.Name=ap[4];
			ch.Admin=ap[5]!=0;
			ch.del=false;
		}

		for(u=m_ChannelList.length-1;u>=0;u--) {
			if(!m_ChannelList[u].del) continue;

			for(i=m_MsgList.length-1;i>=0;i--) {
				if(m_MsgList[i].ChannelId!=m_ChannelList[u].Id) continue;

				m_MsgList.splice(i,1);
				needupdate=true;
			}

			m_ChannelList.splice(u,1);
		}

		//SaveChannelList();

		UpdateMsgChannel();
		if(needupdate) Update();
	}

	public function UpdateMsgChannel():void
	{
		var i:int,score:int,bscore:int;
		var ch:Object;
		var curchid:uint=0;

		if(MsgChannel.selectedIndex>=0 && MsgChannel.selectedItem!=null) {
			curchid=MsgChannel.selectedItem.Id;
		}
//trace("UpdateMsgChannel",MsgChannel.selectedItem,MsgChannel.selectedIndex,curchid);

		MsgChannel.rowCount=m_ChannelList.length;
		MsgChannel.removeAll();
		
		if(curchid) {
			for(i=0;i<m_ChannelList.length;i++) {
				if(!PageChannelIsOn(m_PageCur,m_ChannelList[i])) continue;
				if(m_ChannelList[i].Id==curchid) break;
			}
			if(i>=m_ChannelList.length) curchid=0;
		}

		if(!curchid) {
			for(i=0;i<m_ChannelList.length;i++) {
				//if(!m_ChannelList[i].On) continue;
				if(!PageChannelIsOn(m_PageCur,m_ChannelList[i])) continue;

				score=0;
				if(m_ChannelList[i].Type=="GLOBAL") score=3;
				if(m_ChannelList[i].Type=="LOCAL") score=5;
				if(m_ChannelList[i].Type=="CLAN") score=4;
				if(m_ChannelList[i].Type=="USER") score=2;

				if(curchid<=0 || score>bscore) {
					bscore=score;
					curchid=m_ChannelList[i].Id;
				} 
			}
		}

		for(i=0;i<m_ChannelList.length;i++) {
			//if(!m_ChannelList[i].On) continue;
			if(!PageChannelIsOn(m_PageCur,m_ChannelList[i])) continue;

			var str:String="";
			if(m_ChannelList[i].Type=="GLOBAL") str="-G "+m_ChannelList[i].Name;
			if(m_ChannelList[i].Type=="LOCAL") str="-L Local";
			if(m_ChannelList[i].Type=="USER") str="-W Whisper";
			if(m_ChannelList[i].Type=="CLAN") str="-A Alliance";

			if(str.length<=0) continue;

			var o:Object={ label:str, Id:m_ChannelList[i].Id };
			MsgChannel.addItem( o );

			if(m_ChannelList[i].Id==curchid) MsgChannel.selectedItem=o;
		}

//trace(curchid);
		if(curchid) {
			ch=GetChannel(curchid);
			if(ch) {
//trace(ch);
				var tf:TextFormat=new TextFormat("Calibri",14,ColorByChannel(ch,false));
				MsgChannel.textField.setStyle("textFormat", tf);
				MsgToUser.textField.setStyle("textFormat", tf);
				Msg.setStyle("textFormat", tf);
			}
		}
		
		UpdateMsgPos();
		QueryMsg();
	}
	
	public function UpdateMsgPos():void
	{
		var chsize:int=TextCalcSize(MsgChannel.selectedLabel);
		chsize=Math.max(40,chsize)+30;

		var usersize:int=TextCalcSize(MsgToUser.selectedLabel);
		usersize=Math.max(5,usersize)+20;
		
		//m_GoSet.x=5;
		//m_GoSet.y=m_SizeY-5-m_GoSet.height-(3);

		MsgChannel.x=5;//+m_GoSet.width+5;
		MsgChannel.y=m_SizeY-5-Msg.height-(3);
		MsgChannel.width=chsize;

		MsgToUser.x=MsgChannel.x+MsgChannel.width+5;
		MsgToUser.y=m_SizeY-5-Msg.height-(3);
		MsgToUser.width=usersize;		

		Msg.x=MsgToUser.x+MsgToUser.width+5;
		Msg.y=m_SizeY-5-Msg.height;
		Msg.width=m_SizeX-Msg.x;
		
		MsgToUser.drawNow();		
	}

	public function TextCalcSize(str:String):int
	{
		var t:TextField=new TextField();
		t.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		if(str==null) t.text="";
		else t.text=str;
		t.autoSize=TextFieldAutoSize.LEFT;
		
//trace("textsize",str,t.width);
		
		return t.width;
	}

	public function UpdateMsgToUser():void
	{
		var i:int;
		var o:Object;
		var user:User;

		MsgToUser.removeAll();
		MsgToUser.rowCount = m_ToUserIdList.length + 2;

		var find:Boolean=false;

		o = { label:"()", Id:0 };
		MsgToUser.addItem( o );
		if (m_ToUserId == 0) MsgToUser.selectedItem = o;

		for (i = 0; i < m_ToUserIdList.length; i++) {
			user = UserList.Self.GetUser(m_ToUserIdList[i], true, false);
			if (user == null) continue;

			//o={ label:"("+user.m_Name+")", Id:m_ToUserList[i].Id };
			o = { label:"(" + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id, true) + ")", Id:user.m_Id }; // EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id)

			MsgToUser.addItem( o );

			//if (m_ToUser.length >= 0 && user.m_Name.toLowerCase() == m_ToUser.toLowerCase()) {
			//if (m_ToUser.length >= 0 && EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id) == m_ToUser) {
			if (user.m_Id == m_ToUserId) {
				//m_ToUser=user.m_Name;
				//m_ToUser = EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id, true);
				MsgToUser.selectedItem = o;
				find = true;
			}
		}

		if (!find && m_ToUserId != 0) {
			o = { label:"(" + EmpireMap.Self.Txt_CotlOwnerName(0, m_ToUserId, true) + ")", Id:m_ToUserId };
			MsgToUser.addItem( o );
			MsgToUser.selectedItem = o;
		}
		//MsgToUser.drawNow();

		UpdateMsgPos();
	}
	
	public function SetMsgChannel(chid:uint):void
	{
		var ch:Object=GetChannel(chid);
		if(ch==null) return;

		var i:int;
		for(i=0;i<MsgChannel.length;i++) {
			var obj:Object=MsgChannel.getItemAt(i);
			if(obj.Id==chid) {
				MsgChannel.selectedItem=obj;
				UpdateMsgChannel();
				return;
			}
		}
		MsgChannel.selectedItem=null;
		UpdateMsgChannel();
	}
	
	public function SetToUserId(id:uint):void
	{
		m_ToUserId = id;
		UpdateMsgToUser();
		ScrollToUserId(id);
	}
	
	public function MsgChannelChange(event:Event):void
	{
		UpdateMsgChannel();
	}

	public function MsgToUserChange(event:Event):void
	{
		if(MsgToUser.selectedItem!=null) {
			var curid:uint=MsgToUser.selectedItem.Id;
			if(curid==0xffffffff) {}
			else if (curid == 0) m_ToUserId = 0;
			else {
				m_ToUserId = curid;
//				var user:User=UserList.Self.GetUser(curid,true,false);
//				if(user) {
//					//m_ToUser=user.m_Name;
//					m_ToUser = EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id, true);
//				}
			}
		}
		
		UpdateMsgToUser();
	}
	
	public function SendMsg(event:ComponentEvent):void
	{
		if(!Server.Self.IsConnect()) return;

		if(MsgChannel.selectedItem==null) return;

		var ch:int;
		for(ch=0;ch<m_ChannelList.length;ch++) {
			if(MsgChannel.selectedItem.Id==m_ChannelList[ch].Id) break;
		}
		if(ch>=m_ChannelList.length) return;

		var msg:String=Msg.text;
		Msg.text="";
		
//trace("Before ",Text.verticalScrollPosition,Text.maxVerticalScrollPosition);
		m_UIText.verticalScrollPosition=m_UIText.maxVerticalScrollPosition;
		MsgChannel.setFocus();
//trace("After ",Text.verticalScrollPosition,Text.maxVerticalScrollPosition);

		if(msg=='-debug') {
			EmpireMap.Self.m_Debug=!EmpireMap.Self.m_Debug;
			if(EmpireMap.Self.m_Debug) AddDebugMsg("-debug=on");
			else AddDebugMsg("-debug=off");
			EmpireMap.Self.ClearVerMap();
			return;
		} else if (msg == '-debug aiship') {
			if(EmpireMap.Self.m_DebugFlag & EmpireMap.DebugAIShip) EmpireMap.Self.m_DebugFlag &= ~EmpireMap.DebugAIShip;
			else EmpireMap.Self.m_DebugFlag |= EmpireMap.DebugAIShip;
			if(EmpireMap.Self.m_DebugFlag & EmpireMap.DebugAIShip) AddDebugMsg("-debug aiship=on");
			else AddDebugMsg("-debug aiship=off");
			EmpireMap.Self.ClearVerMap();
			return;
		} else if (msg == '-debug aispace') {
			if(EmpireMap.Self.m_DebugFlag & EmpireMap.DebugAISpace) EmpireMap.Self.m_DebugFlag &= ~EmpireMap.DebugAISpace;
			else EmpireMap.Self.m_DebugFlag |= EmpireMap.DebugAISpace;
			if(EmpireMap.Self.m_DebugFlag & EmpireMap.DebugAISpace) AddDebugMsg("-debug aispace=on");
			else AddDebugMsg("-debug aispace=off");
			EmpireMap.Self.ClearVerMap();
			return;
		} else if(msg=='-ship') {
			EmpireMap.Self.m_Set_Ship=!EmpireMap.Self.m_Set_Ship;
			if(EmpireMap.Self.m_Set_Ship) AddDebugMsg("-ship=on");
			else AddDebugMsg("-ship=off");
			EmpireMap.Self.GraphClear();
			return;
		} else if(msg=='-shipgraph') {
			EmpireMap.Self.m_Set_ShipGraph=!EmpireMap.Self.m_Set_ShipGraph;
			if(EmpireMap.Self.m_Set_ShipGraph) AddDebugMsg("-shipgraph=on");
			else AddDebugMsg("-shipgraph=off");
			EmpireMap.Self.GraphClear();
			return;
		} else if(msg=='-shiptext') {
			EmpireMap.Self.m_Set_ShipText=!EmpireMap.Self.m_Set_ShipText;
			if(EmpireMap.Self.m_Set_ShipText) AddDebugMsg("-shiptext=on");
			else AddDebugMsg("-shiptext=off");
			EmpireMap.Self.GraphClear();
			return;
		} else if(msg=='-planet') {
			EmpireMap.Self.m_Set_Planet=!EmpireMap.Self.m_Set_Planet;
			if(EmpireMap.Self.m_Set_Planet) AddDebugMsg("-planet=on");
			else AddDebugMsg("-planet=off");
			return;
		} else if(msg=='-item') {
			EmpireMap.Self.m_Set_Item=!EmpireMap.Self.m_Set_Item;
			if(EmpireMap.Self.m_Set_Item) AddDebugMsg("-item=on");
			else AddDebugMsg("-item=off");
			return;
		} else if(msg=='-bullet') {
			EmpireMap.Self.m_Set_Bullet=!EmpireMap.Self.m_Set_Bullet;
			if(EmpireMap.Self.m_Set_Bullet) AddDebugMsg("-bullet=on");
			else AddDebugMsg("-bullet=off");
			return;
		} else if(msg=='-explosion') {
			EmpireMap.Self.m_Set_Explosion=!EmpireMap.Self.m_Set_Explosion;
			if(EmpireMap.Self.m_Set_Explosion) AddDebugMsg("-explosion=on");
			else AddDebugMsg("-explosion=off");
			return;
//		} else if(msg=='-vison') {
//			EmpireMap.Self.m_Set_VisOn=!EmpireMap.Self.m_Set_VisOn;
//			if(EmpireMap.Self.m_Set_VisOn) AddDebugMsg("-vison=on");
//			else AddDebugMsg("-vison=off");
//			return;
		} else if(msg=='-netstat') {
			EmpireMap.Self.m_NetStatOn=!EmpireMap.Self.m_NetStatOn;
			if(EmpireMap.Self.m_NetStatOn) AddDebugMsg("-netstat=on");
			else AddDebugMsg("-netstat=off");
			return;
		} else if(MsgProcessSector(msg)) return;

		if(msg.length<=0) return;

		m_QueryLockTime=Common.GetTime()+5000;

        var boundary:String=Server.Self.CreateBoundary();
        //var d:ByteArray=new ByteArray();
        //d.writeMultiByte("--"+boundary+"\r\n","iso-8859-1");
        //d.writeMultiByte("Content-Disposition: form-data; name=\"msg\"\r\n\r\n","iso-8859-1");
        //d.writeMultiByte(msg,"utf-8");
        //d.writeMultiByte("\r\n","iso-8859-1");
        //d.writeMultiByte("--"+boundary+"--\r\n","iso-8859-1");

        var d:String;
        d = "--" + boundary + "\r\n";
        d += "Content-Disposition: form-data; name=\"msg\"\r\n\r\n";
        d += msg + "\r\n";
//        if (m_ToUser.length > 0) {
//	        d += "--" + boundary + "\r\n";
//	        d += "Content-Disposition: form-data; name=\"to\"\r\n\r\n";
//	        d += m_ToUser + "\r\n"
//        }
		if (m_ToUserId != 0) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"toid\"\r\n\r\n";
	        d += m_ToUserId.toString() + "\r\n"
		}
        d += "--" + boundary + "--\r\n";

        var dba:ByteArray=new ByteArray();
        dba.writeUTFBytes(d);

        Server.Self.QueryPost("chatmsgadd","&val="+m_ChannelList[ch].Id+"_"+m_ChannelList[ch].Key+"_"+m_ChannelList[ch].Num,d,boundary,RecvMsg);
	}

	public function GetChannel(id:uint):Object
	{
		var i:int;
		for(i=0;i<m_ChannelList.length;i++) {
			if(m_ChannelList[i].Id==id) return m_ChannelList[i]; 
		}
		return null;
	}

	public function QueryMsg(event:TimerEvent=null):void
	{
		PagesUpdate();

		if(!m_RecvChannelOk) return;
		if(!Server.Self.IsConnect()) return;
		if(m_ChannelList.length<0) return;

		if(Common.GetTime()<m_QueryLockTime) return;
		m_QueryLockTime=Common.GetTime()+5000;

/*		var i:int;
		var val:String="";

		for(i=0;i<m_ChannelList.length;i++) {
			//if(!m_ChannelList[i].On) continue;
			//if(!PageChannelIsOn(m_PageCur,m_ChannelList[i])) continue;
			if(!AllPageChannelIsOn(m_ChannelList[i])) continue;

			if(val.length>0) val+="_";
			val+=m_ChannelList[i].Id;
			val+="_"+m_ChannelList[i].Key;
			val+="_"+m_ChannelList[i].Num;
		}
		if(val.length<=0) return;
		
		Server.Self.Query("chatmsgget","&val="+val,RecvMsg);*/

		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;
		var sl:SaveLoad=new SaveLoad();
		sl.SaveBegin(ba);
		
		var i:int,cnt:int=0;

		for(i=0;i<m_ChannelList.length;i++) {
			if(!AllPageChannelIsOn(m_ChannelList[i])) continue;
			
//trace("QM", m_ChannelList[i].Id, m_ChannelList[i].Key, m_ChannelList[i].Num,m_ChannelList[i].Type,m_ChannelList[i].Lang,m_ChannelList[i].Name);

			sl.SaveDword(m_ChannelList[i].Id);
			sl.SaveDword(uint("0x"+m_ChannelList[i].Key));
			sl.SaveDword(int(m_ChannelList[i].Num));
			cnt++;
		}
		
		sl.SaveDword(0);
		
		if(cnt<=0) return;
		
		sl.SaveEnd();
		
		Server.Self.QuerySmall("chatmsgget",true,Server.sqChatMsgGet,ba,RecvMsg);
	}

	private function RecvMsg(...arguments):void
	{
		var i:int,u:int;
		var instr:String = "";

//var t0:Number = Common.GetTime();
		if(arguments.length==1) {
			var event:Event=arguments[0] as Event;
			var loader:URLLoader = URLLoader(event.target);
			if(loader.bytesTotal<1) return;
			
			instr=loader.data;

		} else if(arguments.length==2) {
			var errcode:uint=arguments[0];
			var buf:ByteArray=arguments[1] as ByteArray;
			
//trace("RecvMsg20",errcode,buf);

			if(EmpireMap.Self.ErrorFromServer(errcode)) return;
			if(buf==null || buf.length<=0) return;
			
			instr=buf.readUTFBytes(buf.length);
			
		} else throw Error("RecvMsg");
		
//trace(instr);

		var needupdate:Boolean=false;

		var al:Array=instr.split("\n");
		i=0;
		while(i<al.length) {
			if(al[i].length<=0) break;
			var ap:Array=al[i].split(",");
			i++;

			var err:int=int(ap[0]);
			var chid:int=int(ap[1]);
			var num:int = int(ap[2]);

			if (err == 7) {
				AddChanelMsg(UserChannelId(), Common.TxtChat.SilentAll);
				return;
			}
			if (err == 8) {
				instr = Common.TxtChat.SilentCommon;
				instr = BaseStr.Replace(instr, "<Val>", Common.FormatPeriodLong(chid));
				AddChanelMsg(UserChannelId(), instr);
				return;
			}
			
			var ch:Object=GetChannel(chid);

//if(chid==5) trace("Channel:",err,chid,num);
			
			while(i<al.length) {
				if(al[i].length<=0) { i++; break; }
				if(ch==null) { i++; continue; }
				
				if(al[i].length<=2) {
//					ch.Num=num+1;
				} else /*if(num>=ch.Num)*/ {
					var endauthorid:int=al[i].indexOf(",");
					if(endauthorid<0) { throw Error(""); }

					var endtoid:int=al[i].indexOf(",",endauthorid+1);
					if(endtoid<0) { throw Error(""); }

					var enddate:int=al[i].indexOf(",",endtoid+1);
					if(enddate<0) { throw Error(""); }

					var endnum:int=al[i].indexOf(",",enddate+1);
					if (endnum < 0) { throw Error(""); }

					var authorid:int=int(al[i].slice(0,endauthorid));
					var toid:int=int(al[i].slice(endauthorid+1,endtoid));
					var msgdate:String = al[i].slice(endtoid + 1, enddate);
					var mnum:int = uint("0x"+al[i].slice(enddate + 1, endnum));
					var msg:String=al[i].slice(endnum+1,al[i].length);

					for (u = 0; u < m_MsgList.length; u++) {
						if (m_MsgList[u].ChannelId == chid && m_MsgList[u].Num == mnum) break;
					}
					if(u>=m_MsgList.length) {
						var mo:Object=new Object();
						mo.ChannelId=chid;
						mo.AuthorId=authorid;
						mo.ToId=toid;
						mo.Date = msgdate;
						mo.Num = mnum;
						//mo.Msg = msg;
						//mo.MsgSrc = msg;
						if (EmpireMap.Self.m_Set_Unprintable) mo.Msg = ReplaceBadWord(msg, Common.TxtChat.LikeLetter, Common.TxtChat.GoodWord, Common.TxtChat.BadWord);
						else mo.Msg = msg;
	//if(chid==5) trace("msg:",authorid,toid,msgdate,mnum,msg);

						for(u=0;u<m_MsgList.length;u++) {
							if(msgdate<m_MsgList[u].Date) break;
						}

						if(u>=m_MsgList.length) m_MsgList.push(mo);
						else m_MsgList.splice(u,0,mo);

						ch.Num=mnum+1;

						needupdate = true;
					}
				}

				//num++;
				//ch.Num=num;

//trace("msg AuthorId="+authorid+" Date="+msgdate+" Msg="+msg);
				i++;
			}
		}

		m_QueryLockTime=Common.GetTime()+2000;

//trace(al);

//var t1:Number = Common.GetTime();
		if(needupdate) {
			//SaveChannelList();
			//SaveMsg();

			UpdateToUserList();
			Update();
		}
//var t2:Number = Common.GetTime();
//trace("ChatRecvMsg:", t1 - t0, t2 - t1);
	}

	public function ReloadMsg():void
	{
		var i:int;
		var ch:Object;
		
		m_MsgList.length = 0;
		
		for (i = 0; i < m_ChannelList.length; i++ ) {
			ch = m_ChannelList[i];
			ch.Num=0;
			ch.NumShow = 0;
		}
		
		m_QueryLockTime = 0;

		Update();
	}

	public function UpdateToUserList():void
	{
		var i:int,u:int;
		
		m_ToUserIdList.length = 0;
		
		for(i=m_MsgList.length-1;i>=0;i--) {
			if(m_MsgList[i].AuthorId!=Server.Self.m_UserId) continue;
			if(!m_MsgList[i].ToId) continue;

			var user:User=UserList.Self.GetUser(m_MsgList[i].ToId,true,false);
			if(!user) continue;

			for (u = 0; u < m_ToUserIdList.length; u++) {
				if (m_ToUserIdList[u] == m_MsgList[i].ToId) break;
			}
			if (u < m_ToUserIdList.length) continue;

			//m_ToUserList.push({Id:m_MsgList[i].ToId, Name:"("+user.m_Name+")"});
			//m_ToUserIdList.push( { Id:m_MsgList[i].ToId, Name:"(" + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id) + ")" } );
			m_ToUserIdList.push(m_MsgList[i].ToId);
		}

		UpdateMsgToUser();
	}

	public function BeginEditMsg():void
	{
		if(!visible) return;
		if(Msg.getFocus()==Msg.textField) return;
		//Msg.
		//if(Msg.focusManager.focus) return;
		Msg.setFocus();
	}
	
	private var m_MsgSelBegin:int=0;
	private var m_MsgSelEnd:int=0;
	
	public function MsgSaveSel(e:Event=null):void
	{
		if(Msg.getFocus()==Msg.textField) {
			m_MsgSelBegin=Msg.selectionBeginIndex;
			m_MsgSelEnd=Msg.selectionEndIndex;
		}
//trace("Save",m_MsgSelBegin,m_MsgSelEnd);
	}

	public function MsgAddText(str:String):void
	{
		if(str.length<=0) return;
		if(!visible) return;

		var s:String=Msg.text;
		
		var b:int=m_MsgSelBegin;
		var e:int=m_MsgSelEnd;
		
//		if(Msg.getFocus()==Msg.textField) {
//			b=Math.min(Msg.selectionBeginIndex,Msg.selectionEndIndex);
//			e=Math.max(Msg.selectionBeginIndex,Msg.selectionEndIndex);
//			b=Msg.selectionBeginIndex;
//			e=Msg.selectionEndIndex;
//		}
//trace(b,e);
		
		var r:String="";
		if(b>0) r+=s.substring(0,b);
		var s2:int=r.length;
		r+=str;
		var e2:int=r.length;
		if(e<s.length) r+=s.substring(e,s.length);
		
		Msg.text=r;

		BeginEditMsg();
		Msg.setSelection(s2,e2);
	}

/*	public function ContextMenuOpen(cm:ContextMenu):void
	{
		var i:int;
		var item:ContextMenuItem;

		for(i=0;i<m_ChannelList.length;i++) {
//			if(!m_ChannelList[i].On) continue;
//			if(m_ChannelList[i].Type=="USER") continue;

			var str:String="";
			if(m_ChannelList[i].Type=="GLOBAL") str="-G "+m_ChannelList[i].Name;
			if(m_ChannelList[i].Type=="LOCAL") str="-L Local";
			if(m_ChannelList[i].Type=="USER") str="-L Whisper";
			if(m_ChannelList[i].Type=="CLAN") str="-A Alliance";

			if(m_ChannelList[i].On) str="(On) "+str;
			else str="(Off) "+str;

			if(str.length<=0) continue;

			item=new ContextMenuItem(str);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,ChannelOnOff);
			//item.ChannelId=m_ChannelList[i].Id;
			cm.customItems.push(item);

			m_ChannelList[i].CMI=item;
		}

		if(m_SortByName) item=new ContextMenuItem("(On) "+Common.Txt.UserSortByName,true);
		else item=new ContextMenuItem("(Off) "+Common.Txt.UserSortByName,true);
		item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,SortChange);
		cm.customItems.push(item);
	}
	
	public function MenuOpen(...args)
	{
		EmpireMap.Self.CloseForModal();
		EmpireMap.Self.m_FormMenu.Clear();
		
		var i:int;
		for(i=0;i<m_ChannelList.length;i++) {
//			if(!m_ChannelList[i].On) continue;
//			if(m_ChannelList[i].Type=="USER") continue;

			var str:String="";
			if(m_ChannelList[i].Type=="GLOBAL") str="-G "+m_ChannelList[i].Name;
			if(m_ChannelList[i].Type=="LOCAL") str="-L Local";
			if(m_ChannelList[i].Type=="USER") str="-L Whisper";
			if(m_ChannelList[i].Type=="CLAN") str="-A Alliance";

			if(m_ChannelList[i].On) str="(On) "+str;
			else str="(Off) "+str;

			if(str.length<=0) continue;
			
			EmpireMap.Self.m_FormMenu.Add(str,ChannelOnOff2,i);
		}

		var cx:int=x+m_GoSet.x;
		var cy:int=y+m_GoSet.y;

		EmpireMap.Self.m_FormMenu.Show(cx,cy,cx+20,cy+20);
	}*/
	
	public function MenuUserOpen():void
	{
		var i:int;
		var obj:Object;

		EmpireMap.Self.FormHideAll();
		EmpireMap.Self.m_FormMenu.Clear();

		if(UserListGetCur()!=null) {
			var ouid:uint=UserListGetCur().id;
			var user:User=UserList.Self.GetUser(ouid,true,false);

/*			obj=EmpireMap.Self.m_FormMenu.Add(Common.Txt.Homeworld,null,ouid);
			if(user!=null && user.m_HomeworldPlanetNum>=0) obj.Fun=ToHomeworld;
			else obj.Disable=true;

			obj=EmpireMap.Self.m_FormMenu.Add(Common.Txt.Citadel,null,ouid);
			if(user!=null && user.m_CitadelPlanetNum>=0) obj.Fun=ToCitadel;
			else obj.Disable=true;*/

			//obj=EmpireMap.Self.m_FormMenu.Add(Common.Txt.ToCotlMenu,null,user.m_HomeworldCotlId);
			//if(user!=null && user.m_HomeworldPlanetNum>=0) obj.Fun=ToCotl;
			//else obj.Disable=true;

			EmpireMap.Self.m_FormMenu.Add(Common.Txt.FindUser, FindUser);

			if(EmpireMap.Self.m_UnionId && Server.Self.m_UserId!=ouid) {
				var union:Union=UserList.Self.GetUnion(EmpireMap.Self.m_UnionId);
				if(union!=null) {
					if(!((EmpireMap.Self.m_UnionAccess & Union.AccessInvite) || (union.m_RootAdmin==Server.Self.m_UserId))) {}
					else {
						EmpireMap.Self.m_FormMenu.Add(Common.Txt.FormUnionJoin,UnionJoin);
					}
				}
			}

			//
			if (Server.Self.m_UserId != ouid && user != null && user.m_CombatId != 0) {
				EmpireMap.Self.m_FormMenu.Add(Common.Txt.FormCombatView, CombatView);

			} else if (Server.Self.m_UserId != ouid && user != null) {
				obj = EmpireMap.Self.m_FormMenu.Add(Common.Txt.FormCombatOffer);
				if (EmpireMap.Self.m_UserCombatId == 0) obj.Fun = CombatOffer;
				else obj.Disable = true;

				if (EmpireMap.Self.m_UserCombatId != 0) {
					obj = EmpireMap.Self.m_FormMenu.Add(Common.Txt.FormCombatInvite);
					obj.Fun = CombatInvite;
					//if (EmpireMap.Self.m_FormCombat.m_CombatFlag & (FormCombat.FlagAtkWin | FormCombat.FlagDefWin | FormCombat.FlagPrepare | FormCombat.FlagReady)) obj.Disable = true;
					//else if (EmpireMap.Self.m_FormCombat.m_CombatCotlId == 0) obj.Fun = CombatInvite;
					//else obj.Disable = true;
				}
			}
			
			if(ouid!=Server.Self.m_UserId) {
				EmpireMap.Self.m_FormMenu.Add(Common.Txt.PactMenu,ToPact,ouid);
			}
		}

		// Admin
		if(UserListGetCur()) {
			EmpireMap.Self.m_FormMenu.Add();
		
			if(m_UserListType!=UserListTypeIgnore) {
				EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.Ignore,Ignore);
			} else {
				EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.IgnoreOut,IgnoreOut);
			}	
			
			var ch:int;
			for(ch=0;ch<m_ChannelList.length;ch++) {
				if(MsgChannel.selectedItem.Id==m_ChannelList[ch].Id) break;
			}
			if(ch>=m_ChannelList.length) ch=-1;
			if(ch>=0 && m_ChannelList[ch].Admin) {
				EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.Silent,Silent);
			}

			if (m_UserListType == UserListTypeIgnore) {
				for (i = 0; i < m_IgnoreUserList.length; i++) {
					if (m_IgnoreUserList[i].Id != UserListGetCur().id) continue;

					EmpireMap.Self.m_FormMenu.Add();
					EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.IgnoreGeneral, IgrnoreFlagChange, IgnoreFlagChatGeneral).Check=(m_IgnoreUserList[i].Flag & IgnoreFlagChatGeneral)!=0;
					EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.IgnoreClan, IgrnoreFlagChange, IgnoreFlagChatClan).Check=(m_IgnoreUserList[i].Flag & IgnoreFlagChatClan)!=0;
					EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.IgnoreWhisper, IgrnoreFlagChange, IgnoreFlagChatWhisper).Check=(m_IgnoreUserList[i].Flag & IgnoreFlagChatWhisper)!=0;

					break;
				}
			}
		}

		// UserList
		EmpireMap.Self.m_FormMenu.Add();
		EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.UserList + ":");
		EmpireMap.Self.m_FormMenu.Add("    " + Common.TxtChat.UserListOnlineName, UserListChange, UserListTypeOnlineName).Check = m_UserListType == UserListTypeOnlineName;
		EmpireMap.Self.m_FormMenu.Add("    " + Common.TxtChat.UserListOnlineDate, UserListChange, UserListTypeOnlineDate).Check = m_UserListType == UserListTypeOnlineDate;
		EmpireMap.Self.m_FormMenu.Add("    " + Common.TxtChat.UserListOnlineUnion, UserListChangeUnion, 0).Check = (m_UserListType == UserListTypeUnion) && (m_UserListUnionId == 0);
		obj = UserListGetCur();
		if (obj != null && obj.unionid) {
			var uni:Union = UserList.Self.GetUnion(obj.unionid);
			if (uni != null) {
				EmpireMap.Self.m_FormMenu.Add("    " + uni.NameUnion()+" "+uni.m_Name, UserListChangeUnion, uni.m_UnionId).Check = (m_UserListType == UserListTypeUnion) && (m_UserListUnionId == uni.m_UnionId);
			}
		}
		EmpireMap.Self.m_FormMenu.Add("    " + Common.TxtChat.UserListIgnore, UserListChange, UserListTypeIgnore).Check = m_UserListType == UserListTypeIgnore;

		//if(m_SortByName) EmpireMap.Self.m_FormMenu.Add(Common.Txt.UserSortByDate,SortChange);
		//else EmpireMap.Self.m_FormMenu.Add(Common.Txt.UserSortByName,SortChange);

		var cx:int=width-5;
		var cy:int=stage.mouseY;

		EmpireMap.Self.m_FormMenu.Show(cx,cy,cx+1,cy+1);
	}
	
	public function IgrnoreFlagChange(obj:Object, data:uint):void
	{
		var i:int;
		
		if(UserListGetCur()==null) return;
		var id:uint=UserListGetCur().id;

		for(i=0;i<m_IgnoreUserList.length;i++) {
			if (m_IgnoreUserList[i].Id != id) continue;

			if ((m_IgnoreUserList[i].Flag & data)!=0) m_IgnoreUserList[i].Flag &= ~data;
			else m_IgnoreUserList[i].Flag |= data;

			Update();

			IgnoreSave();
			break;
		}
	}

	public function Ignore(...args):void
	{
		var i:int;
		if(UserListGetCur()==null) return;
		var id:uint=UserListGetCur().id;

		for(i=0;i<m_IgnoreUserList.length;i++) {
			if(m_IgnoreUserList[i].Id==id) return;
		}
		
		var obj:Object = new Object();
		obj.Id = id;
		obj.Flag = 	IgnoreFlagChatGeneral|IgnoreFlagChatWhisper;

		m_IgnoreUserList.push(obj);
		UpdateUserList();
		Update();
		
		IgnoreSave();
	}
	
	public function IgnoreOut(...args):void
	{
		var i:int;
		if(UserListGetCur()==null) return;
		var id:uint=UserListGetCur().id;

		for(i=m_IgnoreUserList.length-1;i>=0;i--) {
			if (m_IgnoreUserList[i].Id==id) {
				m_IgnoreUserList.splice(i,1);
			}
		}

		UpdateUserList();
		Update();

		IgnoreSave();
	}

	public function Silent(...args):void
	{
		EmpireMap.Self.m_FormInput.Init();
		EmpireMap.Self.m_FormInput.AddLabel(Common.TxtChat.SilentCaption);
		EmpireMap.Self.m_FormInput.AddInput("5",5,true,0);
		EmpireMap.Self.m_FormInput.AddLabel(Common.TxtChat.SilentTail);
		EmpireMap.Self.m_FormInput.Run(SilentSend);
	}

	public function SilentSend():void
	{
		if(!Server.Self.IsConnect()) return;

		if(MsgChannel.selectedItem==null) return;

		var ch:int;
		for(ch=0;ch<m_ChannelList.length;ch++) {
			if(MsgChannel.selectedItem.Id==m_ChannelList[ch].Id) break;
		}
		if(ch>=m_ChannelList.length) return;

		if(UserListGetCur()==null) return;
		var ouid:uint=UserListGetCur().id;
		var user:User=UserList.Self.GetUser(ouid,true,false);
		if(user==null) return;
		
		//var z:int=int((EmpireMap.Self.m_FormInput.Get(2) as TextInput).text);
		var z:int = EmpireMap.Self.m_FormInput.GetInt(0);

		Server.Self.Query("chatsilent","&val="+m_ChannelList[ch].Id+"_"+m_ChannelList[ch].Key+"_"+ouid.toString()+"_"+z.toString(),RecvMsg);
	}

	private function SilentRcv(event:Event):void
	{
	}
	
	public function CombatView(...args):void
	{
		if(UserListGetCur()!=null) {
			var ouid:uint = UserListGetCur().id;
			var user:User = UserList.Self.GetUser(ouid);
			if (user != null && user.m_CombatId != 0) EmpireMap.Self.m_FormCombat.ShowEx(user.m_CombatId);
		}
	}
	
	public function CombatOffer(...args):void
	{
		if(UserListGetCur()!=null) {
			var ouid:uint = UserListGetCur().id;
			EmpireMap.Self.m_FormCombat.CombatOffer(ouid);
		}
	}
	
	public function CombatInvite(...args):void
	{
		if (UserListGetCur() != null) {
			var ouid:uint = UserListGetCur().id;
			EmpireMap.Self.m_FormCombat.CombatInvite(ouid);
		}
	}
	
	public function UnionJoin(...args):void
	{
		if(UserListGetCur()!=null) {
			var ouid:uint=UserListGetCur().id;
			var user:User=UserList.Self.GetUser(ouid,true,false);

			if(user!=null) {
				EmpireMap.Self.m_FormUnion.JoinQuery(ouid);
			}
		}
	}

/*	public function ToCotl(...args):void
	{
		if(UserListGetCur()!=null) {
			var ouid:uint=UserListGetCur().id;
			var user:User=UserList.Self.GetUser(ouid,true,false);
			
			if(user!=null && user.m_HomeworldPlanetNum>=0) {
				if(EmpireMap.Self.m_FormGalaxy.visible) {}
				else {
					EmpireMap.Self.CloseForModal();
					EmpireMap.Self.m_FormGalaxy.Show();
				}
				EmpireMap.Self.m_FormGalaxy.GoTo(user.m_HomeworldCotlId);
			}
		}
	}*/

	public function ToHomeworld(...args):void
	{
		EmpireMap.Self.m_ContentMenuShow=false;

		if(UserListGetCur()!=null) {
			var ouid:uint=UserListGetCur().id;
			var user:User=UserList.Self.GetUser(ouid,true,false);

			if(user!=null && user.m_HomeworldPlanetNum>=0) {
				var ra:Array=EmpireMap.Self.m_FormMiniMap.GetPlanetPos(user.m_HomeworldSectorX,user.m_HomeworldSectorY,user.m_HomeworldPlanetNum);
				if(ra!=null) {
					EmpireMap.Self.SetCenter(ra[0],ra[1]);
					EmpireMap.Self.m_FormMiniMap.SetCenter(EmpireMap.Self.OffsetX,EmpireMap.Self.OffsetY);
					
					EmpireMap.Self.AddGraphFind(0/*user.m_HomeworldCotlId*/,user.m_HomeworldSectorX,user.m_HomeworldSectorY,user.m_HomeworldPlanetNum);
				}
			}
		}
	}
	
/*	public function ToCitadel(...args):void
	{
		EmpireMap.Self.m_ContentMenuShow=false;

		if(UserListGetCur()!=null) {
			var ouid:uint=UserListGetCur().id;
			var user:User=UserList.Self.GetUser(ouid,true,false);

			if(user!=null && user.m_CitadelPlanetNum>=0) {
				var ra:Array=EmpireMap.Self.m_FormMiniMap.GetPlanetPos(user.m_CitadelSectorX,user.m_CitadelSectorY,user.m_CitadelPlanetNum);
				if(ra!=null) {
					EmpireMap.Self.SetCenter(ra[0],ra[1]);
					EmpireMap.Self.m_FormMiniMap.SetCenter(EmpireMap.Self.OffsetX,EmpireMap.Self.OffsetY);

					EmpireMap.Self.AddGraphFind(0,user.m_CitadelSectorX,user.m_CitadelSectorY,user.m_CitadelPlanetNum); // user.m_CitadelCotlId
				}
			}
		}
	}*/
	
	public function FindUser(...args):void
	{
		if(UserListGetCur()!=null) {
			var ouid:uint=UserListGetCur().id;
			var user:User=UserList.Self.GetUser(ouid,true,false);

			if (user != null && Server.Self.m_CotlId != 0) {
				if (!EmpireMap.Self.HS.visible) EmpireMap.Self.m_FormInfoBar.clickGalaxy(null);
				if (EmpireMap.Self.HS.visible) {
					if (EmpireMap.Self.m_FormStorage.m_CotlId == 0) EmpireMap.Self.m_FormStorage.m_CotlId = Server.Self.m_CotlId;
					EmpireMap.Self.m_FormStorage.SearchCotlUser(user.m_Id);

//					if (EmpireMap.Self.m_FormHist.visible) EmpireMap.Self.m_FormHist.Hide();
//					EmpireMap.Self.m_FormHist.m_CotlId=Server.Self.m_CotlId;
//					EmpireMap.Self.m_FormHist.Show();
//					EmpireMap.Self.m_FormHist.ChangeMode(EmpireMap.Self.m_FormHist.m_ModeFind);
//					//EmpireMap.Self.m_FormHist.m_FindQuery.text = Common.Txt.FindCotlKeyword + " " + user.m_Name;
//					EmpireMap.Self.m_FormHist.m_FindQuery.text = Common.Txt.FindCotlKeyword + " " + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id, true);
//					EmpireMap.Self.m_FormHist.clickFind(null);
				}
			}
		}
	}

	public function ToPact(...args):void
	{
		EmpireMap.Self.m_ContentMenuShow=false;

		if(UserListGetCur()!=null) {
			var ouid:uint=UserListGetCur().id;
			var user:User=UserList.Self.GetUser(ouid,true,false);

			if(user!=null) {
				EmpireMap.Self.FormHideAll();
				EmpireMap.Self.m_FormPact.m_UserId=ouid;
				EmpireMap.Self.m_FormPact.Show(FormPact.ModePreset);
			}
		}
	}

	public function UserListChange(e:Object, t:int):void
	{
		if(m_UserListType==t) return;
		m_UserListType=t;
		UpdateUserList();
	}

	public function UserListChangeUnion(e:Object, t:int):void
	{
		if(m_UserListType==UserListTypeUnion && m_UserListUnionId==t) return;
		m_UserListType = UserListTypeUnion;
		m_UserListUnionId = t;
		UpdateUserList();
	}

//	public function SortChange(...args):void
//	{
//		EmpireMap.Self.m_ContentMenuShow=false;
//
//		m_SortByName=!m_SortByName;
//		UpdateOnlineUser();
//	}

/*	public function ChannelOnOff(e:ContextMenuEvent):void
	{
		var i:int;

		EmpireMap.Self.m_ContentMenuShow=false;

		for(i=0;i<m_ChannelList.length;i++) {
			if(m_ChannelList[i].CMI==e.target) break;
		}
		if(i>=m_ChannelList.length) return;

		m_ChannelList[i].On=!m_ChannelList[i].On;

		UpdateMsgChannel();
		Update();

		SaveChannelList();

		m_QueryLockTime=0;
		QueryMsg();
	}

	public function ChannelOnOff2(e:Object, i:int):void
	{
		if(i>=m_ChannelList.length) return;

		m_ChannelList[i].On=!m_ChannelList[i].On;

		UpdateMsgChannel();
		Update();

		SaveChannelList();

		m_QueryLockTime=0;
		QueryMsg();
	}*/

	public function MsgChangeChannel():void
	{
		var i:int;
		var newchid:uint=0;
		
		var str:String=Msg.text;
		
		var sme:int=0;
		
		while(sme<str.length && (str.charCodeAt(sme)==32 || str.charCodeAt(sme)==9)) sme++;

		if(sme<str.length && str.charAt(sme)!="-") return;
		sme++;
		
		var type:String;
		if(str.charAt(sme)=="G" || str.charAt(sme)=="g" || str.charCodeAt(sme)==0x41F || str.charCodeAt(sme)==0x43f) type="GLOBAL"; 
		else if(str.charAt(sme)=="L" || str.charAt(sme)=="l" || str.charCodeAt(sme)==0x414 || str.charCodeAt(sme)==0x434) type="LOCAL";
		else if(str.charAt(sme)=="A" || str.charAt(sme)=="a" || str.charCodeAt(sme)==0x424 || str.charCodeAt(sme)==0x444) type="CLAN"; // с=0x421 0x441
		else if(str.charAt(sme)=="W" || str.charAt(sme)=="w" || str.charCodeAt(sme)==0x426 || str.charCodeAt(sme)==0x446) type="USER";
		else return;
		sme++;

		var smebegin:int=sme;
		while(sme<str.length && (str.charCodeAt(sme)==32 || str.charCodeAt(sme)==9)) sme++;
		if(smebegin==sme) return;

		for(i=0;i<m_ChannelList.length;i++) {
			//if(!m_ChannelList[i].On) continue;
			if(!PageChannelIsOn(m_PageCur,m_ChannelList[i])) continue;		
			if(m_ChannelList[i].Type!=type) continue;

			if(newchid) { newchid=0; break; }
			newchid=m_ChannelList[i].Id;
		}

		while(!newchid && (type=="GLOBAL")) {
			smebegin=sme;
			while(sme<str.length && (str.charCodeAt(sme)!=32 && str.charCodeAt(sme)!=9)) sme++;
			if(smebegin==sme) return;
			
			var name:String=str.slice(smebegin,sme).toLowerCase();

			smebegin=sme;
			while(sme<str.length && (str.charCodeAt(sme)==32 || str.charCodeAt(sme)==9)) sme++;
			if(smebegin==sme) return;

			for(i=0;i<m_ChannelList.length;i++) {
				//if(!m_ChannelList[i].On) continue;
				if(!PageChannelIsOn(m_PageCur,m_ChannelList[i])) continue;		
				if(m_ChannelList[i].Type!=type) continue;
				if(m_ChannelList[i].Name.toLowerCase()!=name) continue;

				if(newchid) { newchid=0; break; }
				newchid=m_ChannelList[i].Id;
			}

			break;
		}
			
		if(newchid) {
			var olds:int=Msg.selectionBeginIndex;

			Msg.text=str.slice(sme);
			if(olds<sme) Msg.setSelection(0,0);
			else Msg.setSelection(olds-sme,olds-sme);

			SetMsgChannel(newchid);
		}
	}

	public function MsgChangeUser():void
	{
		var i:int;

		var str:String=Msg.text;

		var sme:int=0;
		var smebegin:int=0;

		while(sme<str.length && (str.charCodeAt(sme)==32 || str.charCodeAt(sme)==9)) sme++;

		while(true) {
			if(sme<str.length && str.charAt(sme)=="(") {
				sme++;
				smebegin = sme;
				while (sme < str.length && str.charAt(sme) != ")") sme++;
				//if(smebegin==sme) return;
				if (sme >= str.length) return;

				//var id:uint = UserIdByName(str);
				//if (id == 0) return;
				//SetToUserId(id);
				var u:User = UserList.Self.FindUser(str.slice(smebegin,sme));
				if (u == null) return;
				SetToUserId(u.m_Id);

				//SetToUser(str.slice(smebegin,sme));
				sme++;

				var olds:int=Msg.selectionBeginIndex;

				Msg.text=str.slice(sme);
				if(olds<sme) Msg.setSelection(0,0);
				else Msg.setSelection(olds-sme,olds-sme);
			}
			break;
		}
	}

	public function MsgChange(e:Event):void
	{
		MsgChangeChannel();
		MsgChangeUser();
	}
	
/*	public function SaveChannelList()
	{
		var i:int;

		var so:SharedObject = SharedObject.getLocal("EGChatChannel");

		var dst:String="";

		for(i=0;i<m_ChannelList.length;i++) {
			var ch:Object=m_ChannelList[i];

			dst+=ch.Id;
			dst+="~"+ch.Key;
			dst+="~"+ch.Type;
			dst+="~"+ch.Lang;
			dst+="~"+ch.Name;
			dst+="~"+ch.Num;
			dst+="~"+ch.On;
			dst+="\n";
//trace("Save channel Id="+ch.Id+" Name="+ch.Name+" Num="+ch.Num);
		}
		
		so.data.channellist=dst;
	}

	public function LoadChannelList()
	{
		var i:int;

		var so:SharedObject = SharedObject.getLocal("EGChatChannel");
		if(so.size==0) return;
		if(!(so.data.channellist is String)) return;

		m_ChannelList.length=0;

		var al:Array=so.data.channellist.split("\n");
		for(i=0;i<al.length;i++) {
			if(al[i].length<=0) break;
			var ap:Array=al[i].split("~");

			if(ap[2]=="GLOBAL");
			else if(ap[2]=="LOCAL");
			else if(ap[2]=="CLAN");
			else if(ap[2]=="USER");
			else continue;

			if(ap[3]!=Common.LangSysName[Server.Self.m_Lang]) continue;

			var ch:Object=new Object();
			ch.Id=ap[0];
			ch.Key=ap[1];
			ch.Type=ap[2];
			ch.Lang=ap[3];
			ch.Name=ap[4];
			ch.Num=0;//int(ap[5]);
			ch.On=ap[6]=='true';
//trace("Load channel Id="+ch.Id+" Name="+ch.Name+" Num="+ch.Num);

			m_ChannelList.push(ch);
		}
	}*/

	public function SaveMsg():void
	{
		return;
/*		var i:int;

		var so:SharedObject = SharedObject.getLocal("EGChatMsg");

		var dst:String="";

		for(i=Math.max(0,m_MsgList.length-50);i<m_MsgList.length;i++) {
			var mo:Object=m_MsgList[i];

			dst+=mo.ChannelId;
			dst+=","+mo.AuthorId;
			dst+=","+mo.ToId;
			dst+=","+mo.Date;
			dst+=","+mo.Msg;
			dst+="\n";
		}

		so.data.msg=dst;*/
	}

	public function LoadMsg():void
	{
		return;
/*		var i:int;

		var so:SharedObject = SharedObject.getLocal("EGChatMsg");
		if(so.size==0) return;
		if(!(so.data.msg is String)) return;

		var al:Array=so.data.msg.split("\n");
		for(i=0;i<al.length;i++) {
			if(al[i].length<=0) break;
			
			var endchid:int=al[i].indexOf(",");
			if(endchid<0) { throw Error(""); }

			var endauthorid:int=al[i].indexOf(",",endchid+1);
			if(endauthorid<0) { throw Error(""); }

			var endtoid:int=al[i].indexOf(",",endauthorid+1);
			if(endtoid<0) { throw Error(""); }

			var enddate:int=al[i].indexOf(",",endtoid+1);
			if(enddate<0) { throw Error(""); }

			var chid:int=int(al[i].slice(0,endchid));
			var authorid:int=int(al[i].slice(endchid+1,endauthorid));
			var toid:int=int(al[i].slice(endauthorid+1,endtoid));
			var msgdate:String=al[i].slice(endtoid+1,enddate);
			var msg:String=al[i].slice(enddate+1,al[i].length);

			var ch:Object=GetChannel(chid);
			if(ch==null) continue;

			var mo:Object=new Object();
			mo.ChannelId=chid;
			mo.AuthorId=authorid;
			mo.ToId=toid;
			mo.Date=msgdate;
			mo.Msg=msg;
			m_MsgList.push(mo);
		}*/
	}
	
	public function UserChannelId():uint
	{
		for(var i:int=0;i<m_ChannelList.length;i++) {
			//if(!m_ChannelList[i].On) continue;		
			if(m_ChannelList[i].Type!="USER") continue;

			return m_ChannelList[i].Id;
		}
		return 0; 
	}

	public function ClanChannelId():uint
	{
		for(var i:int=0;i<m_ChannelList.length;i++) {
			//if(!m_ChannelList[i].On) continue;		
			if(m_ChannelList[i].Type!="CLAN") continue;

			return m_ChannelList[i].Id;
		}
		return 0; 
	}
	
	public function UserListGetCur():Object
	{
		if(OUList.length<=0) return null;
		if (OUList.selectedIndex<0 || OUList.selectedIndex>=OUList.length) return null;
		if (OUList.selectedItem.id == 0) return null;
		return OUList.selectedItem; 	
	}

	public function OUUserClick(event:MouseEvent):void
	{
		//var i:int;
		
		if(!OUList.hitTestPoint(event.stageX,event.stageY)) return;

		var obj:Object = UserListGetCur();
		if (obj != null) {
			//var chid:uint=UserChannelId();
			//if(chid==0) return; 

			//SetMsgChannel(chid);
			//m_ToUser=UserListGetCur().label;
			m_ToUserId = obj.id;
			UpdateMsgToUser();
		}
		
		MenuUserOpen();
	}

/*	public function ToUserSet(name:String):void
	{
		var chid:uint=UserChannelId();
		if(chid==0) return; 

		SetMsgChannel(chid);
		m_ToUser=name;
		UpdateMsgToUser();
	}*/
	
	public function MsgProcessSector(msg:String):Boolean
	{
		var ch:int;
		var len:int=msg.length;
		if(len<=0) return false;
		var sme:int=0;

		while((sme<len) && (msg.charCodeAt(sme)==32)) sme++;
		if(sme>=len) return false;

		if(msg.charCodeAt(sme)!=91) return false;
		sme++;

		while((sme<len) && (msg.charCodeAt(sme)==32)) sme++;

//trace("00 ["+msg.substring(sme,len)+"]");
		var secx:int=0;
		var secy:int=0;
		while(sme<len) {
			ch=msg.charCodeAt(sme);
			if(ch>=48 && ch<=57) secx=secx*10+ch-48;
			else break;
			sme++;
		}

		while((sme<len) && (msg.charCodeAt(sme)==32)) sme++;
		if(sme>=len) return false;
		ch=msg.charCodeAt(sme);
		if(ch==0x2c) sme++;
		else if(ch==0x2e) sme++;
		else if(ch>=48 && ch<=57) {}
		else return false;
		while((sme<len) && (msg.charCodeAt(sme)==32)) sme++;
		if(sme>=len) return false;

//trace("01 ["+msg.substring(sme,len)+"]");
		while(sme<len) {
			ch=msg.charCodeAt(sme);
			if(ch>=48 && ch<=57) secy=secy*10+ch-48;
			else break;
			sme++;
		}

		while((sme<len) && (msg.charCodeAt(sme)==32)) sme++;
		if(sme>=len) return false;
		if(msg.charCodeAt(sme)!=93) return false;
		sme++;

		while((sme<len) && (msg.charCodeAt(sme)==32)) sme++;
		if(sme<len) return false;
		
//trace(secx,secy);
		secx=secx-1+EmpireMap.Self.m_SectorMinX;
		secy=secy-1+EmpireMap.Self.m_SectorMinY;
		
		if(secx<EmpireMap.Self.m_SectorMinX || secx>=EmpireMap.Self.m_SectorMinX+EmpireMap.Self.m_SectorCntX) return false;
		if(secy<EmpireMap.Self.m_SectorMinY || secy>=EmpireMap.Self.m_SectorMinY+EmpireMap.Self.m_SectorCntY) return false;

		EmpireMap.Self.SetCenter(secx*EmpireMap.Self.m_SectorSize+(EmpireMap.Self.m_SectorSize>>1),secy*EmpireMap.Self.m_SectorSize+(EmpireMap.Self.m_SectorSize>>1));
		EmpireMap.Self.m_FormMiniMap.SetCenter(EmpireMap.Self.OffsetX,EmpireMap.Self.OffsetY);

		return true;
	}
	
	public function TextSectorClick():void
	{
		var ch:int;
		var t:String=m_UIText.text;

		var lnum:int=0;
		var sme:int=m_UIText.selectionEndIndex;
		while(sme>=0) {
			if(t.charCodeAt(sme)==13) lnum++; 
			sme--;
		}
//trace(lnum);
		if(lnum<0 || lnum>=m_LineChannelId.length) return;
		
		sme=m_UIText.selectionEndIndex;
		while(sme>0 && t.charCodeAt(sme-1)!=10 && t.charCodeAt(sme-1)!=13) { /*trace(t.charCodeAt(sme-1));*/ sme--; }
		
		var len:int=0; 
		while(sme+len<t.length && t.charCodeAt(sme+len)!=58) len++;
		if(len>=t.length) return;
		if(m_UIText.selectionEndIndex<=sme+len) return;

		sme+=len;
		len=0; 
		while(sme+len<t.length && t.charCodeAt(sme+len)!=13) len++;
		if(len>=t.length) return;
		if(m_UIText.selectionEndIndex>sme+len) return;
		
		var k:int=m_UIText.selectionEndIndex;
		while(k>sme) {
			ch=t.charCodeAt(k-1);
			if(ch>=48 && ch<=57) {}
			else if(ch==0x2c) {}
			else if(ch==0x2e) {}
			else if(ch==32) {}
			else break;
			k--;
		}

		while((k<sme+len) && (t.charCodeAt(k)==32)) k++;
//trace("begink=",k,"["+t.substring(k,k+len)+"]");

		var secx:int=0;
		var secy:int=0;
		while(k<sme+len) {
			ch=t.charCodeAt(k);
			if(ch>=48 && ch<=57) secx=secx*10+ch-48;
			else break;
			k++;
		}

		while((k<sme+len) && (t.charCodeAt(k)==32)) k++;
//trace("nextk=",k,"secx=",secx);
		if(k>=sme+len) return;
		ch=t.charCodeAt(k);
		if(ch==0x2c) k++;
		else if(ch==0x2e) k++;
		else if(ch>=48 && ch<=57) {}
		else return;
		while((k<sme+len) && (t.charCodeAt(k)==32)) k++;
		if(k>=sme+len) return;
//trace("begink=",k,"["+t.substring(k,k+len)+"]");

		while(k<sme+len) {
			ch=t.charCodeAt(k);
			if(ch>=48 && ch<=57) secy=secy*10+ch-48;
			else break;
			k++;
		}
		
//trace(secx,secy);
		secx=secx-1+EmpireMap.Self.m_SectorMinX;
		secy=secy-1+EmpireMap.Self.m_SectorMinY;
		
		if(secx<EmpireMap.Self.m_SectorMinX || secx>=EmpireMap.Self.m_SectorMinX+EmpireMap.Self.m_SectorCntX) return;
		if(secy<EmpireMap.Self.m_SectorMinY || secy>=EmpireMap.Self.m_SectorMinY+EmpireMap.Self.m_SectorCntY) return;

		EmpireMap.Self.SetCenter(secx*EmpireMap.Self.m_SectorSize+(EmpireMap.Self.m_SectorSize>>1),secy*EmpireMap.Self.m_SectorSize+(EmpireMap.Self.m_SectorSize>>1));
		EmpireMap.Self.m_FormMiniMap.SetCenter(EmpireMap.Self.OffsetX,EmpireMap.Self.OffsetY);
	}
	
	public function TextClick(event:MouseEvent):void
	{
		var t:String=m_UIText.text;

		var lnum:int=0;
		var sme:int=m_UIText.selectionEndIndex;
		while(sme>=0) {
			if(t.charCodeAt(sme)==13) lnum++; 
			sme--;
		}
//trace(lnum);
		if(lnum<0 || lnum>=m_LineChannelId.length) return;
		
		sme=m_UIText.selectionEndIndex;
		while(sme>0 && t.charCodeAt(sme-1)!=10 && t.charCodeAt(sme-1)!=13) { /*trace(t.charCodeAt(sme-1));*/ sme--; }
		
		var nouser:Boolean = m_LineLeftUserId[lnum] == 0 && m_LineRightUserId[lnum] == 0;// m_LineNoUserId[lnum];
		var len:int=0; 
		while(sme+len<t.length && t.charCodeAt(sme+len)!=58) {
			if(t.charCodeAt(sme+len)==10 || t.charCodeAt(sme+len)==13) { nouser=true; break; }
			len++;
		}
		if(sme+len>=t.length) nouser=true;
		if(m_UIText.selectionEndIndex>sme+len) { TextSectorClick(); return; }

		if (nouser) {
			SetMsgChannel(m_LineChannelId[lnum]);
			//m_ToUser = "";
			m_ToUserId = 0;
			UpdateMsgToUser();
			return;
		}

//trace(t.slice(sme,sme+len));

		var dirsme:int=0;
		while(dirsme<len-1 && !(t.charCodeAt(sme+dirsme)==45 && t.charCodeAt(sme+dirsme+1)==62)) dirsme++;
		if(dirsme>=len-1) dirsme=-1;

//trace(dirsme);
		var uid:uint = 0;

		//var un:String='';
		if (dirsme < 0) {
			uid = m_LineLeftUserId[lnum];
			//un=t.slice(sme,sme+len);
		} else {
			if (m_UIText.selectionEndIndex < sme + dirsme) {
				uid = m_LineLeftUserId[lnum];
				//un=t.slice(sme,sme+dirsme);
			} else {
				uid = m_LineRightUserId[lnum];
				//un=t.slice(sme+dirsme+2,sme+len);
			}
		}
//trace("t.charCodeAt(0)=",t.charCodeAt(0));
//		while (un.length > 0 && un.charCodeAt(0) == 32) un = un.slice(1, un.length);
//		while (un.length > 0 && un.charCodeAt(un.length - 1) == 32) un = un.slice(0, un.length - 1);
//trace("["+un+"]");

//trace(m_LineChannelId[lnum]);
		SetMsgChannel(m_LineChannelId[lnum]);
		//m_ToUser=un;
		//m_ToUserId = UserIdByName(un);
//		var u:User = UserList.Self.FindUser(un);
//		if (u == null) return;
		m_ToUserId = uid;// u.m_Id;
		UpdateMsgToUser();
		//ScrollToUser(m_ToUser);
		ScrollToUserId(m_ToUserId);
	}
	
	public function AddChanelMsg(chid:uint,str:String):void
	{
		if(chid==0) return;

		var md:Date = null;

		//md=new Date();
		md=EmpireMap.Self.GetServerDate();

		var sd:String=""+md.fullYear+":";
		if(md.month.toString().length<=1) sd+="0";
		sd+=(md.month+1)+":";
		if(md.date.toString().length<=1) sd+="0";
		sd+=md.date+" ";
		if(md.hours.toString().length<=1) sd+="0";
		sd+=md.hours+":";
		if(md.minutes.toString().length<=1) sd+="0";
		sd+=md.minutes+":";
		if(md.seconds.toString().length<=1) sd+="0";
		sd+=md.seconds;

		var mo:Object=new Object();
		mo.ChannelId=chid;
		mo.AuthorId=0;
		mo.ToId=0;
		mo.Date=sd;
		mo.Msg=str;
		m_MsgList.push(mo);

		Update();
	}
	
	public function AddDebugMsg(str:String):void
	{
		AddChanelMsg(UserChannelId(),str);
	}
	
	public function IsSpaceLock():Boolean
	{
		if(!visible) return false;
		
//trace("Chat.IsSpaceLock",MsgToUser.dropdown.visible,MsgChannel.dropdown.visible,MsgToUser.dropdown.enabled,MsgToUser.dropdown.parent);
		if(MsgToUser.dropdown.parent!=null && MsgToUser.dropdown.hitTestPoint(stage.mouseX,stage.mouseY)) return true;
		if(MsgChannel.dropdown.parent!=null && MsgChannel.dropdown.hitTestPoint(stage.mouseX,stage.mouseY)) return true;

		return false;
	}
	
	public function PageDelete(i:int):void
	{
		if(i<0 || i>=m_Pages.length) return;
		var p:Object;
		
		p=m_Pages[i];
		if(p.BG!=undefined && p.BG!=null) {
			removeChild(p.BG);
			p.BG=null;
		}
		if(p.Label!=undefined && p.Label!=null) {
			removeChild(p.Label);
			p.Label=null;
		}
		if(p.OffList!=undefined && p.OffList!=null) {
			p.OffList.lebgth=0;
			p.OffList=null;
		}
		
		m_Pages.splice(i,1);
	}

	public function PagesClear():void
	{
		while(m_Pages.length>0) PageDelete(m_Pages.length-1);
	}

	public function PagesLoad():void
	{
		var i:int,u:int;
		var p:Object;
		PagesClear();
		
		var so:SharedObject = SharedObject.getLocal("EGChatPages");
		//m_Pages=so.data.v;

		if(so.size!=0) {
			var ar:Array=null;
			if(so.data.names!=undefined) ar=so.data.names;
			var aro:Array=null;
			if(so.data.off!=undefined) aro=so.data.off;
	
			if(ar!=null) {
				for(i=0;i<ar.length;i++) {
					p=new Object();
					p.Name=ar[i];
					m_Pages.push(p);
					
					if(aro!=null && i>=0 && i<aro.length && (aro is Array)) {
						var lo:Array=aro[i];
						if(lo.length>0) {
							p.OffList=new Array();
							for(u=0;u<lo.length;u++) p.OffList.push(lo[u]); 
						}
					}
				}
			}
		}

//trace("PageCnt:",m_Pages.length);
		if(m_Pages.length<=0) {
			p=new Object();
			p.Name=Common.TxtChat.PageMain;
			m_Pages.push(p);
		}

		m_PageCur=so.data.page;
		if(m_PageCur<0) m_PageCur=0;
		if(m_PageCur>=m_Pages.length) m_PageCur=m_Pages.length-1; 
	}

	public function PagesSave():void
	{
		var i:int,u:int;
		var so:SharedObject = SharedObject.getLocal("EGChatPages");
		
		so.data.page=m_PageCur;

		var ar:Array=new Array();
		var aroff:Array=new Array();		
		for(i=0;i<m_Pages.length;i++) {
			ar.push(m_Pages[i].Name);
			
			var aol:Array=new Array();
			if(m_Pages[i].OffList!=undefined || m_Pages[i].OffList!=null) {
				var ol:Array=m_Pages[i].OffList;
				for(u=0;u<ol.length;u++) aol.push(ol[u]);
			}
			aroff.push(aol);
		
		}
//trace("SavePageCnt:",ar.length);
		delete so.data.names;
		delete so.data.off;
		so.data.names=ar;
		so.data.off=aroff;
	}
	
	public function PagesUpdate():void
	{
		var i:int,u:int;
		var p:Object;
		var b:MovieClip;
		var l:TextField;
		var ch:Object;
		
		var sx:int=10;
		var sy:int=-25;

		for(i=0;i<m_Pages.length;i++) {
			p=m_Pages[i];

			if(p.BG==undefined || p.BG==null) {
				b=new FormChatPage();
				addChild(b);
				b.addEventListener(MouseEvent.MOUSE_MOVE, PageMouseMove);
				b.addEventListener(MouseEvent.MOUSE_OUT, PageMouseMove);
				b.addEventListener(MouseEvent.MOUSE_DOWN, PageMouseDown);
				p.BG=b;
			} else {
				b=p.BG;
			}

			if(p.Label==undefined || p.Label==null) {
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
				//l.addEventListener(MouseEvent.CLICK,NameChange);
				addChild(l);
				p.Label=l;
			} else l=p.Label; 

			l.text="";
			l.width=1;
			l.height=1;
			l.htmlText=p.Name;
			l.x=sx+5;
			l.y=sy+5;
			
			var hnm:Boolean=false;
			for(u=0;u<m_ChannelList.length;u++) {
				ch=m_ChannelList[u];
				if(ch==null) continue;
				if(!PageChannelIsOn(i,ch)) continue;
				if(ch.Num==ch.NumShow) continue;
				hnm=true;
				break;
			}

			b.x=sx;
			b.y=sy;
			b.width=5+Math.max(30,l.width)+5;
			if(i==m_PageMouse) b.gotoAndStop(3);
			else if(i==m_PageCur) b.gotoAndStop(2);
			else if(hnm && ((Common.GetTime()>>9) & 1)!=0) b.gotoAndStop(4); 
			else b.gotoAndStop(1);

			sx+=b.width+1;
		}
	}
	
	public function PagePick():int
	{
		var i:int;
		var p:Object;
		for(i=0;i<m_Pages.length;i++) {
			p=m_Pages[i];
			
			if(p.BG!=undefined && p.BG!=null) {
				if(p.BG.hitTestPoint(stage.mouseX,stage.mouseY)) return i;
			}
		}
		return -1;
	}
	
	public function PageMouseMove(e:MouseEvent):void
	{
		var i:int=PagePick();
		if(i!=m_PageMouse) {
			m_PageMouse=i;
			PagesUpdate();
		}		
	}
	
	public function PageMouseDown(e:MouseEvent):void
	{
		var i:int=PagePick();
		if(i>=0) {
			if(i!=m_PageCur) {
				m_PageCur=i;
				PagesSave();

				UpdateMsgChannel();
				Update();

				m_QueryLockTime=0;
				QueryMsg();
			} else {
				PageMenu();
			}
		}
	}
	
	public function PageMenu():void
	{
		var i:int,u:int;
		var obj:Object;
		
		if(m_PageCur<0 || m_PageCur>=m_Pages.length) return;
		var p:Object=m_Pages[m_PageCur];
		
		var ar:Array=null;
		if(p.OffList!=undefined) ar=p.OffList;

		//EmpireMap.Self.CloseForModal();
		EmpireMap.Self.m_FormMenu.Clear();
		
		EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.Channels+":");
		
		for(i=0;i<m_ChannelList.length;i++) {
			var str:String="";
			if(m_ChannelList[i].Type=="GLOBAL") str="-G "+m_ChannelList[i].Name;
			if(m_ChannelList[i].Type=="LOCAL") str="-L Local";
			if(m_ChannelList[i].Type=="USER") str="-L Whisper";
			if(m_ChannelList[i].Type=="CLAN") str="-A Alliance";

			if(str.length<=0) continue;

			obj=EmpireMap.Self.m_FormMenu.Add("    "+str,PageChannelOnOff,i);

			if(ar==null) obj.Check=true;
			else {
				for(u=0;u<ar.length;u++) {
					if(ar[u]==(m_ChannelList[i].Type+"~"+m_ChannelList[i].Name)) break;
				}
				if(u>=ar.length) obj.Check=true;
			}
		}

		EmpireMap.Self.m_FormMenu.Add();

		EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.PageRename,PageRename);
		if(m_Pages.length<5) EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.PageAdd,PageAdd);
		if(m_Pages.length>1) EmpireMap.Self.m_FormMenu.Add(Common.TxtChat.PageDelete,PageDeleteComplate);

		EmpireMap.Self.m_FormMenu.SetButOpen(p.BG);
		EmpireMap.Self.m_FormMenu.Show(x+p.BG.x,y+p.BG.y,x+p.BG.x+p.BG.width,y+p.BG.y+p.BG.height);
	}
	
	public function AllPageChannelIsOn(channel:Object):Boolean
	{
		var i:int;
		for(i=0;i<m_Pages.length;i++) {
			if(PageChannelIsOn(i,channel)) return true;
		}
		return false;
	}
	
	public function PageChannelIsOn(page:int, channel:Object):Boolean
	{
		var i:int;
		
		if(page<0 || page>=m_Pages.length) return false;
		var p:Object=m_Pages[page];

		if(p.OffList==undefined || p.OffList==null) return true;
		var ar:Array=p.OffList;

		var str:String=channel.Type+"~"+channel.Name;

		for(i=0;i<ar.length;i++) {
			if(ar[i]==str) return false;
		}

		return true;
	}

	public function PageChannelOnOff(e:Object, i:int):void
	{
		if(i>=m_ChannelList.length) return;
		
		if(m_PageCur<0 || m_PageCur>=m_Pages.length) return;
		var p:Object=m_Pages[m_PageCur];
		
		if(p.OffList==undefined || p.OffList==null) {
			p.OffList=new Array();
		}
		var ar:Array=p.OffList;

		var str:String=m_ChannelList[i].Type+"~"+m_ChannelList[i].Name;

		for(i=0;i<ar.length;i++) {
			if(ar[i]==str) break;
		}
		if(i<ar.length) {
			ar.splice(i,1);
		} else {
			ar.push(str);
		}
		
		PagesSave();
		
		UpdateMsgChannel();
		Update();

		m_QueryLockTime=0;
		QueryMsg();
	}

	private function PageRename(...args):void
	{
		if(m_PageCur<0 || m_PageCur>=m_Pages.length) return;
		var p:Object=m_Pages[m_PageCur];

		EmpireMap.Self.m_FormInput.Init();
		EmpireMap.Self.m_FormInput.AddLabel(Common.TxtChat.RenameCaption+":");
		EmpireMap.Self.m_FormInput.AddInput(p.Name,15,true,Server.Self.m_Lang);
		EmpireMap.Self.m_FormInput.Run(PageRenameComplate);
	}

	public function PageRenameComplate():void
	{
		if(m_PageCur<0 || m_PageCur>=m_Pages.length) return;
		var p:Object=m_Pages[m_PageCur];

		//p.Name=(EmpireMap.Self.m_FormInput.Get(2) as TextInput).text;
		p.Name = EmpireMap.Self.m_FormInput.GetStr(0);

		PagesSave();

		PagesUpdate();
	}

	private function PageAdd(...args):void
	{
		EmpireMap.Self.m_FormInput.Init();
		EmpireMap.Self.m_FormInput.AddLabel(Common.TxtChat.AddCaption+":");
		EmpireMap.Self.m_FormInput.AddInput("",15,true,Server.Self.m_Lang);
		EmpireMap.Self.m_FormInput.Run(PageAddComplate);
	}

	public function PageAddComplate():void
	{
		var p:Object;

		p=new Object();
		//p.Name=(EmpireMap.Self.m_FormInput.Get(2) as TextInput).text;
		p.Name = EmpireMap.Self.m_FormInput.GetStr(0);
		m_Pages.push(p);

		m_PageCur=m_Pages.length-1;

		PagesSave();

		Update();
	}
	
	private function PageDeleteComplate(...args):void
	{
		PageDelete(m_PageCur);
		
		if(m_PageCur>=m_Pages.length) m_PageCur=m_Pages.length-1;
		m_PageMouse=-1;
		
		PagesSave();
		
		Update(); 
	}

	public function IgnoreSave():void
	{
		var i:int;
		var so:SharedObject = SharedObject.getLocal("EGChatIgnore2");
		
		var ar:Array=new Array();
		for (i = 0; i < m_IgnoreUserList.length; i++) {
			var obj:Object = new Object();
			obj.Id = m_IgnoreUserList[i].Id;
			obj.Flag = m_IgnoreUserList[i].Flag;
			ar.push(obj);
		}

		so.data.list=ar;
	}

	public function IgnoreLoad():void
	{
		var i:int;

		m_IgnoreUserList.length=0;

		var so:SharedObject = SharedObject.getLocal("EGChatIgnore2");

		if(so.size!=0) {
			var ar:Array=null;
			if(so.data.list!=undefined) ar=so.data.list;

			if(ar!=null) {
				for (i = 0; i < ar.length; i++) {
					var obj:Object = new Object();
					obj.Id = ar[i].Id;
					obj.Flag = ar[i].Flag;
					m_IgnoreUserList.push(obj);
				}
			}
		}
	}

	public function IsIgnore(id:uint, mask:uint=0xffffffff):Boolean
	{
		var i:int;
		for(i=0;i<m_IgnoreUserList.length;i++) {
			if(m_IgnoreUserList[i].Id==id && (m_IgnoreUserList[i].Flag & mask)!=0) return true;
		}
		return false;
	}
	
	public static var src:String = "";
//	public static var bw:String = "";
	public static var bwl:Vector.<int> = new Vector.<int>();
	public static var gwl:Vector.<int> = new Vector.<int>();
	public static var ll:Vector.<int> = new Vector.<int>();

	[Inline] static public function FindEndRazdelGW(/*src:String, */srclen:int, off:int):int
	{
		var ch:int;
		var len:int=0;
		var open:int=0;

		while(srclen>0) {
			ch = gwl[off];// .charCodeAt(off);

			if(ch==91 || ch==40 || ch==123) open++; // [ ( {
			else if(ch==93 || ch==41 || ch==125) { // ] ) }
				open--;
				if(open<0) break;
			}

			off++;
			srclen--;
			len++;
		}
		return len;
	}
	
	[Inline] static public function IsGoodWord(srclen:int, srcoff:int, gwlen:int, gwoff:int):int
	{
		var add:int,gwlen2:int;
		var ch:int,cc:int,i:int;
		var len:int=0;
		var find:Boolean;

		var srcoff_f:int = srcoff;
		var srclen_f:int = srclen;

		while (gwlen > 0) {
			cc = gwl[gwoff];// .charCodeAt(gwoff);
			gwoff+=1; gwlen-=1;

			if(cc==44) { // ,
				if(len>0) return len;
				srcoff=srcoff_f;
				srclen=srclen_f;
				len=0;
				continue;
			}

			if(cc==41) {} // )
			else if(cc==93) {} // ]
			else if(cc==125) {} // }
			else if (cc == 91 || cc == 40) { // [ (
				find=false;
				var need:Boolean=cc==40; // (
				for (i = 0; gwlen > 0; i++) {
					if(i!=0) {
						if (gwl[gwoff]/*.charCodeAt(gwoff)*/ != 123) break; // {
						gwoff++; gwlen--;
					}
					
					gwlen2 = FindEndRazdelGW(/*bw,*/ gwlen, gwoff);
					if (find) add = IsGoodWord(/*null,*/ 0, 0/*, bw*/, gwlen2, gwoff);
					else add = IsGoodWord(/*src,*/ srclen, srcoff/*, bw*/, gwlen2, gwoff);
					gwoff += gwlen2; gwlen -= gwlen2;
					if(i==0) {
						if(need) {
							if(gwlen<=0 || gwl[gwoff]/*.charCodeAt(gwoff)*/!=41) return 0; // )
						} else {
							if(gwlen<=0 || gwl[gwoff]/*.charCodeAt(gwoff)*/!=93) return 0; // ]
						}
					} else {
						if (gwlen <= 0 || gwl[gwoff]/*.charCodeAt(gwoff)*/ != 125) return 0; // }
					}
					gwoff++; gwlen--;

					if((add>0) && (!find)) {
						srcoff += add;
						srclen -= add;
						len += add;
						find = true;
					}
				}
				if(need) {
					if(!find) {}//return 0;
					else continue;
				} else {
					continue;
				}
			} else if (srclen > 0) {
				//if (srclen <= 0) return 0;
				ch = src.charCodeAt(srcoff);
				srcoff += 1; srclen -= 1; len += 1;
				//ch = utf_LowerCase(ch);

				if (cc == ch) {
/*					while (srclen > 0) {
						ch = src.charCodeAt(srcoff);
						if (cc == ch) { }
						else if (ch <= 47) { }
						else if (ch >= 91 && ch <= 96) { }
						else break;
						srcoff += 1; srclen -= 1; len += 1;
					}*/
					continue;
				}
			}

			srcoff = srcoff_f;
			srclen = srclen_f;
			len = 0;

			while(gwlen>0) {
				cc = gwl[gwoff];// .charCodeAt(gwoff);
				gwoff += 1; gwlen -= 1;

				if(cc==44) break; // ,
			}
		}

		return len;
	}

	[Inline] static public function FindEndRazdel(/*src:String, */srclen:int, off:int):int
	{
		var ch:int;
		var len:int=0;
		var open:int=0;

		while(srclen>0) {
			ch = bwl[off];// .charCodeAt(off);

			if(ch==91 || ch==40 || ch==123) open++; // [ ( {
			else if(ch==93 || ch==41 || ch==125) { // ] ) }
				open--;
				if(open<0) break;
			}

			off++;
			srclen--;
			len++;
		}
		return len;
	}

	[Inline] static public function LikeLetter(ch1:int, ch2:int):Boolean
	{
		if (ch1 == ch2) return true;
		if (ch1 == 44) return false; // ,
		
		var v:int, i:int;
		var len:int = ll.length;
		
		for (i = 0; i < len; i++) {
			if (ll[i] == ch1) break;
		}
		if (i >= len) return false;
		
		var u:int = i + 1;
		for (; u < len; u++) {
			v = ll[u];
			if (v == 44) break; // ,
			if (v == ch2) return true;
		}
		
		u = i - 1;
		for (; u >= 0; u--) {
			v = ll[u];
			if (v == 44) break;
			if (v == ch2) return true;
		}

		return false;
	}

	[Inline] static public function IsBadWord(/*src:String,*/srclen:int, srcoff:int/*, bw:String*/, bwlen:int, bwoff:int):int
	{
		var add:int,bwlen2:int;
		var ch:int,cc:int,i:int;
		var len:int=0;
		var find:Boolean;

		var srcoff_f:int = srcoff;
		var srclen_f:int = srclen;

		while (bwlen > 0) {
			cc = bwl[bwoff];// .charCodeAt(bwoff);
			bwoff+=1; bwlen-=1;

			if(cc==44) { // ,
				if(len>0) return len;
				srcoff=srcoff_f;
				srclen=srclen_f;
				len=0;
				continue;
			}
			
			if(cc==41) {} // )
			else if(cc==93) {} // ]
			else if(cc==125) {} // }
			else if (cc == 91 || cc == 40) { // [ (
				find=false;
				var need:Boolean=cc==40; // (
				for (i = 0; bwlen > 0; i++) {
					if(i!=0) {
						if (bwl[bwoff]/*.charCodeAt(bwoff)*/ != 123) break; // {
						bwoff++; bwlen--;
					}
					
					bwlen2 = FindEndRazdel(/*bw,*/ bwlen, bwoff);
					if (find) add = IsBadWord(/*null,*/ 0, 0/*, bw*/, bwlen2, bwoff);
					else add = IsBadWord(/*src,*/ srclen, srcoff/*, bw*/, bwlen2, bwoff);
					bwoff += bwlen2; bwlen -= bwlen2;
					if(i==0) {
						if(need) {
							if(bwlen<=0 || bwl[bwoff]/*.charCodeAt(bwoff)*/!=41) return 0; // )
						} else {
							if(bwlen<=0 || bwl[bwoff]/*.charCodeAt(bwoff)*/!=93) return 0; // ]
						}
					} else {
						if (bwlen <= 0 || bwl[bwoff]/*.charCodeAt(bwoff)*/ != 125) return 0; // }
					}
					bwoff++; bwlen--;

					if((add>0) && (!find)) {
						srcoff += add;
						srclen -= add;
						len += add;
						find = true;
					}
				}
				if(need) {
					if(!find) {}//return 0;
					else continue;
				} else {
					continue;
				}
			} else if (srclen > 0) {
				//if (srclen <= 0) return 0;
				ch = src.charCodeAt(srcoff);
				srcoff += 1; srclen -= 1; len += 1;
				//ch = utf_LowerCase(ch);

				if (LikeLetter(cc, ch)) {
					while (srclen > 0) {
						ch = src.charCodeAt(srcoff);
						if (LikeLetter(cc, ch)) { }
						else if (ch <= 47) { }
						else if (ch >= 91 && ch <= 96) { }
						else break;
						srcoff += 1; srclen -= 1; len += 1;
					}
					continue;
				}
			}

			srcoff = srcoff_f;
			srclen = srclen_f;
			len = 0;

			while(bwlen>0) {
				cc = bwl[bwoff];// .charCodeAt(bwoff);
				bwoff += 1; bwlen -= 1;

				if(cc==44) break; // ,
			}
		}

		return len;
	}
	
	[Inline] static public function IsCorrectTwoWord(srclen:int, bwoff:int, bwlen:int):Boolean
	{
		var i:int;
		var ch:int;
		
		// first begin
		var fbegin:int = bwoff;
		while (fbegin-1 >= 0) {
			ch = src.charCodeAt(fbegin - 1);
			if (ch == 32) break;
			fbegin--;
		}
		if (fbegin >= bwoff) return false; // у слова должно быть начало

		// first end
		for (i = 0; i < bwlen; i++) {
			ch = src.charCodeAt(bwoff + i);
			if (ch == 32) break;
		}
		if (i <= 0) return false;
		if (i >= bwlen) return false;
		
		if (!FormEnter.StrSingleAlphabet(src, fbegin, bwoff + i - fbegin)) return false;
		
		// space
		i++;
		if (i+1 >= bwlen) return false;

		// second begin
		var sbegin:int = bwoff + i;
		for (; i < bwlen; i++) {
			ch = src.charCodeAt(bwoff + i);
			if (ch == 32) break;
		}
		if (i < bwlen) return false;
		
		// second end
		var send:int = bwoff + bwlen;
		while (send < srclen) {
			ch = src.charCodeAt(send);
			send++;
			if (ch == 32) break;
		}
		if (send <= (bwoff + bwlen)) return false; // у слова должно быть окончание

		if (!FormEnter.StrSingleAlphabet(src, sbegin, send - sbegin)) return false;

		return true;
	}

	static public const BadWordRS:String = "***************************************************************************************************************************************************************************************************************************";

	static public function ReplaceBadWord(in_src:String, in_ll:String, in_gw:String, in_bw:String):String
	{
		// почемуто очень сильно тормозит если запускать в дебаг режиме. нужно найти где. если что попробовать вынести в библиотеку
		// http://alexsorokin.ru/2011/01/actionscript-conditional-compilation/
//		CONFIG::debug {
//			return in_src;
//		}
		//CONFIG::release {
		//}

		//return in_src;
		//src = in_src;
		//bw = in_bw;

		var ch:int, add:int, len:int, i:int;
		var ret:Boolean = false;

		if (bwl.length <= 0) {
			len = in_bw.length;
			bwl.length = len;
			for (i = 0; i < len; i++) {
				bwl[i] = in_bw.charCodeAt(i);
			}
		}

		if (gwl.length <= 0) {
			len = in_gw.length;
			gwl.length = len;
			for (i = 0; i < len; i++) {
				gwl[i] = in_gw.charCodeAt(i);
			}
		}

		if (ll.length <= 0) {
			len = in_ll.length;
			ll.length = len;
			for (i = 0; i < len; i++) {
				ll[i] = in_ll.charCodeAt(i);
			}
		}

		var srclen:int = in_src.length;
		if (srclen <= 0) return src;
		var bwlen:int = bwl.length;
		if (bwlen <= 0) return src;
		var gwlen:int = gwl.length;
		if (gwlen <= 0) return src;
		
		//var srclc:String = in_src.toLowerCase();
		src = in_src.toLowerCase();
		if (src.length != in_src.length) return src;

		var srcoff:int = 0;

		var out:String = "";
		var outoff:int = 0;
		var outadd:int = 0;

		while (srclen > 0) {
			ch = src.charCodeAt(srcoff);
			if (ch < 64) { srcoff += 1; srclen -= 1; outadd++; continue; }

			len = IsGoodWord(srclen, srcoff, gwlen, 0);
			if (len > 0) {
				if (outadd > 0) {
					out += in_src.substr(outoff, outadd);
					outoff += outadd;
					outadd = 0;
				}
				
				out += in_src.substr(srcoff, len);
				srcoff += len;
				srclen -= len;
				outoff += len;
				continue;
			}

			len = IsBadWord(/*srclc,*/ srclen, srcoff/*, bw*/, bwlen, 0);
			if (len <= 0) { srcoff += 1; srclen -= 1; outadd++; continue; }

			if (IsCorrectTwoWord(srcoff + srclen, srcoff, len)) { srcoff += 1; srclen -= 1; outadd++; continue; }

			if (outadd > 0) {
				out += in_src.substr(outoff, outadd);
				outoff += outadd;
				outadd = 0;
			}

			while (len > 0) {
				ch = src.charCodeAt(srcoff + len - 1);
				if (ch <= 47) len--;
				else if (ch >= 91 && ch <= 96) len--;
				else break;
			}

			out += BadWordRS.substr(0, len);

			ret = true;
			srcoff += len;
			srclen -= len;
			outoff += len;
		}
		if (outadd > 0) {
			out += in_src.substr(outoff, outadd);
			outoff += outadd;
			outadd = 0;
		}
		return out;
	}

}

}

import fl.controls.listClasses.CellRenderer;
import fl.events.ComponentEvent;
import flash.text.*;

class OnlineUserRenderer extends CellRenderer
{
	public static var tfUONormal:TextFormat=new TextFormat("Calibri",14,0xffffff);
	public static var tfUORazdel:TextFormat=new TextFormat("Calibri",14,0x808080);
	
    public function OnlineUserRenderer() {
        var originalStyles:Object = CellRenderer.getStyleDefinition();
        setStyle("upSkin",CellRenderer_OU_upSkin);
        setStyle("downSkin",CellRendere_OU_overSkin);
        setStyle("overSkin",CellRendere_OU_overSkin);
        setStyle("selectedUpSkin",CellRenderer_OU_selectedUpSkin);
        setStyle("selectedDownSkin",CellRenderer_OU_selectedUpSkin);
        setStyle("selectedOverSkin",CellRenderer_OU_selectedUpSkin);
		setStyle("textFormat",tfUONormal);
		setStyle("embedFonts", true);
		setStyle("textPadding", 5);

		addEventListener(ComponentEvent.LABEL_CHANGE, labelChangeHandler);
    }
		
	private function labelChangeHandler(event:ComponentEvent):void
	{
		if(data.id!=0) {
			setStyle("textFormat",tfUONormal);
		} else {
			setStyle("textFormat",tfUORazdel);
			setStyle("upSkin",CellRenderer_OU_upSkin);
			setStyle("downSkin",CellRenderer_OU_upSkin);
			setStyle("overSkin",CellRenderer_OU_upSkin);
			setStyle("selectedUpSkin",CellRenderer_OU_upSkin);
			setStyle("selectedDownSkin",CellRenderer_OU_upSkin);
			setStyle("selectedOverSkin",CellRenderer_OU_upSkin);
		}
//trace(data);
//trace(textField.text);
//		textField.htmlText="<font color='#ff0000'>"+textField.text+"</font>";
	}
}