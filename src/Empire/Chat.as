// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.ui.*;
import flash.utils.*;

public class Chat extends MovieClip
{
	public var m_FormChat:FormChat;

	public var m_ContextMenu:ContextMenu;

	public function Chat()
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		m_ContextMenu=new ContextMenu();
		m_ContextMenu.hideBuiltInItems();
		m_ContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, ContextMenuSelectHandler);
		contextMenu=m_ContextMenu;

		Server.Self=new Server();
		Server.Self.addEventListener("ConnectClose",RecvConnectClose);

		UserList.Self=new UserList();

		m_FormChat=new FormChat();
		m_FormChat.m_Align=0;
		m_FormChat.Hide()
		addChild(m_FormChat);

		if(loaderInfo.parameters["ServerAdr"]!=undefined) {
			Server.Self.m_ServerAdr=loaderInfo.parameters["ServerAdr"];
		}

		if(loaderInfo.parameters["LocalChat"]!=undefined) {
			Server.Self.m_LocalChatName=loaderInfo.parameters["LocalChat"];
		}

		while(true) {
			if(loaderInfo.parameters["SessionUserId"]==undefined) break;
			if(loaderInfo.parameters["SessionIPKey"]==undefined) break;

			var userid:uint=uint(loaderInfo.parameters["SessionUserId"]);
			if(!userid) break;

			var session:String=loaderInfo.parameters["SessionIPKey"];
			if(session.length<=0) break;

			Server.Self.ConnectAccept(userid,session);
			break;
		}
		if(!Server.Self.IsConnect()) {
			Server.Self.ConnectAccept(0,"");
			//Server.Self.ConnectAccept(1,"4B94D89D6");
		}

		m_FormChat.Show()
		m_FormChat.QueryChList();
	}

	public function RecvConnectClose(e:Event):void
	{
	}

	public function onStageResize(e:Event):void
	{
		if(m_FormChat.visible) m_FormChat.Show();
	}

	private function ContextMenuSelectHandler(event:ContextMenuEvent):void
	{
		var item:ContextMenuItem;
		
		m_ContextMenu.customItems.length=0;

		if(m_FormChat.IsMouseIn()) {
			m_FormChat.ContextMenuOpen(m_ContextMenu);
			return;
		}
	}
}

}
