// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import fl.controls.dataGridClasses.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormUnion extends FormUnionClass
{
	private var m_Map:EmpireMap;
	
	public var m_UnionId:uint=0;
	
	public var m_Name:TextField=null;
	public var m_Desc:TextField=null;

	public var m_SiteLabel:TextField=null;
	public var m_SiteVal:TextField=null;

	public var m_EmblemSmallImg:Bitmap=null;
	public var m_EmblemLargeImg:Bitmap=null;

	public var m_HelloLabel:TextField=null;
	public var m_HelloVal:TextField=null;

	public var m_InfoLabel:TextField=null;
	public var m_InfoVal:TextField=null;
	public var m_InfoSB:UIScrollBar=null;
	
	public var m_BonusVal:TextField=null;
	
	public var m_PageMember:TextField=null;
	public var m_PageInfo:TextField=null;
	public var m_PageNames:TextField=null;
	public var m_PageBonus:TextField=null;
	
	public var m_MemberList:DataGrid=null;
	
	public var m_UserOptions:SimpleButton=null;
	public var m_UserInfo:TextField=null;
	
	public var m_AccessTitle:TextField=null;
	public var m_AccessHedaerLabel:TextField=null;
	public var m_AccessInfoLabel:TextField=null;
	public var m_AccessInviteLabel:TextField=null;
	public var m_AccessExclusionLabel:TextField=null;
	public var m_AccessRankLabel:TextField=null;
	public var m_AccessAccessLabel:TextField=null;
	public var m_AccessChatEditLabel:TextField=null;

	public var m_AccessHedaerCheck:CheckBox=null;
	public var m_AccessInfoCheck:CheckBox=null;
	public var m_AccessInviteCheck:CheckBox=null;
	public var m_AccessExclusionCheck:CheckBox=null;
	public var m_AccessRankCheck:CheckBox=null;
	public var m_AccessAccessCheck:CheckBox=null;
	public var m_AccessChatEditCheck:CheckBox=null;

	public var m_AccessSave:Button=null;

	public var m_NamesLang:TextField=null;
	public var m_NamesEng:TextField=null;
	public var m_NamesSave:Button=null;
	public var m_NamesList:Array=new Array();

	static public const PageMember:int=1;
	static public const PageInfo:int=2;
	static public const PageNames:int=3;
	static public const PageBonus:int=4;

	public var m_PageCur:int=PageMember;
	public var m_PageMouse:int=-1;
	public var m_PageList:Array=new Array();
	
	public var m_ShowUserId:uint=0;

	public function FormUnion(map:EmpireMap)
	{
		m_Map=map;

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);


		ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		ButLeave.addEventListener(MouseEvent.CLICK, clickLeave);
		
		UserList.Self.addEventListener("RecvUser", RecvUser);
	}

	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) Show();
		x = Math.ceil(parent.stage.stageWidth / 2 - width / 2);
		y = Math.ceil(parent.stage.stageHeight / 2 - height / 2);
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		var i:int; 

		e.stopImmediatePropagation();

		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		if(ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(ButLeave.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_MemberList!=null && m_MemberList.hitTestPoint(e.stageX,e.stageY)) { return; }

		if(m_Name!=null && m_Name.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_Desc!=null && m_Desc.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_SiteLabel!=null && m_SiteLabel.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_SiteVal!=null && m_SiteVal.hitTestPoint(e.stageX,e.stageY)) { return; }
		
		if(m_HelloLabel!=null && m_HelloLabel.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_HelloVal!=null && m_HelloVal.hitTestPoint(e.stageX,e.stageY)) { return; }
		
		if(m_InfoLabel!=null && m_InfoLabel.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_InfoVal!=null && m_InfoVal.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_InfoSB!=null && m_InfoSB.hitTestPoint(e.stageX,e.stageY)) { return; }
		
		if(m_AccessHedaerCheck!=null && m_AccessHedaerCheck.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_AccessInfoCheck!=null && m_AccessInfoCheck.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_AccessInviteCheck!=null && m_AccessInviteCheck.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_AccessExclusionCheck!=null && m_AccessExclusionCheck.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_AccessRankCheck!=null && m_AccessRankCheck.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_AccessAccessCheck!=null && m_AccessAccessCheck.hitTestPoint(e.stageX,e.stageY)) { return; }
		if(m_AccessChatEditCheck!=null && m_AccessChatEditCheck.hitTestPoint(e.stageX,e.stageY)) { return; }
		
		if(m_AccessSave!=null && m_AccessSave.hitTestPoint(e.stageX,e.stageY)) { return; }
		
		if(m_UserOptions!=null && m_UserOptions.hitTestPoint(e.stageX,e.stageY)) { return; }
		
		if(m_NamesSave!=null && m_NamesSave.hitTestPoint(e.stageX,e.stageY)) { return; }
		
		for(i=0;i<m_NamesList.length;i++) {
			var d:DisplayObject=m_NamesList[i];
			if(d.hitTestPoint(e.stageX,e.stageY)) { return; }
		}

		if(m_EmblemSmallImg!=null && m_EmblemSmallImg.hitTestPoint(e.stageX,e.stageY)) { EmblemSmallChange(null); return; }
		if(m_EmblemLargeImg!=null && m_EmblemLargeImg.hitTestPoint(e.stageX,e.stageY)) { EmblemLargeChange(null); return; }
		
		if(m_PageMouse>=0) {
			if(m_PageCur!=m_PageMouse) {
				PageHide();
				m_PageCur=m_PageMouse;
				PageUpdate();
			}
			return;
		}
		
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		parent.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}
	
	protected function onMouseWheel(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	protected function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		var i:int=PickPage()
		if(i!=m_PageMouse) {
			m_PageMouse=i;
			PageUpdateRazdel();
		}
		
		m_Map.m_Info.Hide();
	}
	
	public function Hide():void
	{
		visible=false;
		//PageInfoHide();
		PageHide();
	}

	public function Show():void
	{
//		Common.UIStdLabel(LabelCaption,18,0xffffff);
		Common.UIStdBut(ButClose);
		Common.UIStdBut(ButLeave);

//		LabelCaption.text=Common.Txt.UnionCaption;
		ButClose.label=Common.Txt.ButClose;
		ButLeave.label=Common.Txt.FormUnionLeave;
		
		m_PageCur=PageMember;
		m_PageMouse=-1;

		visible=true;

		StageResize();
		
		PageHide();
		PageUpdate();
	}

	private function clickClose(event:MouseEvent):void
	{
		Hide();
	}

	public function PageUpdate():void
	{
		var i:int;
		var obj:Object;
		
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		
		//PageHide();

		if(m_EmblemLargeImg==null) {
			m_EmblemLargeImg=new Bitmap();
			addChild(m_EmblemLargeImg);
		}
		m_EmblemLargeImg.x=5;
		m_EmblemLargeImg.y=5;
		if(union.m_Emblem!=null) m_EmblemLargeImg.bitmapData=union.m_Emblem;
		else m_EmblemLargeImg.bitmapData=m_Map.m_ImgStdUnionLarge;
		
		if(m_EmblemSmallImg==null) {
			m_EmblemSmallImg=new Bitmap();
			addChild(m_EmblemSmallImg);
		}
		m_EmblemSmallImg.x=110;
		m_EmblemSmallImg.y=10;
		if(union.m_EmblemSmall!=null) m_EmblemSmallImg.bitmapData=union.m_EmblemSmall;
		else m_EmblemSmallImg.bitmapData=m_Map.m_ImgStdUnionSmall;
		
		if(m_Name==null) {
			m_Name=new TextField();
			addChild(m_Name);
		}
		m_Name.x=137;
		m_Name.y=11;
		m_Name.width=1;
		m_Name.height=1;
		m_Name.type=TextFieldType.DYNAMIC;
		m_Name.selectable=false;
		m_Name.border=false;
		m_Name.background=false;
		m_Name.multiline=false;
		m_Name.autoSize=TextFieldAutoSize.LEFT;
		m_Name.antiAliasType=AntiAliasType.ADVANCED;
		m_Name.gridFitType=GridFitType.PIXEL;
		m_Name.defaultTextFormat=new TextFormat("Calibri",18,0xffffff);
		m_Name.embedFonts=true;
		m_Name.addEventListener(MouseEvent.CLICK,NameChange);
		m_Name.htmlText=union.NameUnion()+"  <font color='#ffff00'>\""+union.m_Name+"\"</font>";

		if(m_Desc==null) {
			m_Desc=new TextField();
			addChild(m_Desc);
		}
		m_Desc.x=120;
		m_Desc.y=35;
		m_Desc.width=1;
		m_Desc.height=1;
		m_Desc.type=TextFieldType.DYNAMIC;
		m_Desc.selectable=false;
		m_Desc.border=false;
		m_Desc.background=false;
		m_Desc.multiline=true;
		m_Desc.autoSize=TextFieldAutoSize.LEFT;
		m_Desc.antiAliasType=AntiAliasType.ADVANCED;
		m_Desc.gridFitType=GridFitType.PIXEL;
		m_Desc.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_Desc.embedFonts=true;
		m_Desc.addEventListener(MouseEvent.CLICK,DescChange);
		if(union.m_Desc.length<=0) m_Desc.text="------------------------"; 
		else m_Desc.text=union.m_Desc;

		if(m_SiteLabel==null) {
			m_SiteLabel=new TextField();
			addChild(m_SiteLabel);
		}	
		m_SiteLabel.x=120;
		m_SiteLabel.y=m_Desc.y+m_Desc.height+2;
		m_SiteLabel.width=1;
		m_SiteLabel.height=1;
		m_SiteLabel.type=TextFieldType.DYNAMIC;
		m_SiteLabel.selectable=false;
		m_SiteLabel.border=false;
		m_SiteLabel.background=false;
		m_SiteLabel.multiline=false;
		m_SiteLabel.autoSize=TextFieldAutoSize.LEFT;
		m_SiteLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_SiteLabel.gridFitType=GridFitType.PIXEL;
		m_SiteLabel.defaultTextFormat=new TextFormat("Calibri",13,0xc4fff2);
		m_SiteLabel.embedFonts=true;
		m_SiteLabel.addEventListener(MouseEvent.CLICK,SiteChange);
		m_SiteLabel.text=Common.Txt.FormUnionSite+":";

		if(m_SiteVal==null) {
			m_SiteVal=new TextField();
			addChild(m_SiteVal);
		}
		m_SiteVal.x=m_SiteLabel.x+m_SiteLabel.width+5;
		m_SiteVal.y=m_SiteLabel.y;
		m_SiteVal.width=1;
		m_SiteVal.height=1;
		m_SiteVal.type=TextFieldType.DYNAMIC;
		m_SiteVal.selectable=false;
		m_SiteVal.border=false;
		m_SiteVal.background=false;
		m_SiteVal.multiline=false;
		m_SiteVal.autoSize=TextFieldAutoSize.LEFT;
		m_SiteVal.antiAliasType=AntiAliasType.ADVANCED;
		m_SiteVal.gridFitType=GridFitType.PIXEL;
		m_SiteVal.defaultTextFormat=new TextFormat("Calibri",13,0xffff00);
		m_SiteVal.embedFonts=true;
		if(union.m_Site.length>0) m_SiteVal.addEventListener(MouseEvent.CLICK,SiteGo);
		var str:String=union.m_Site;
		i=str.indexOf("/",0); if(i>0) str=str.substring(0,i)+" ...";
		i=str.indexOf(":",0); if(i>0) str=str.substring(0,i)+" ...";
		m_SiteVal.text=str;

		var my:int=130;

		if(m_PageMember==null) {
			m_PageMember=new TextField();
			addChild(m_PageMember);

			obj=new Object(); obj.Name=m_PageMember; obj.Type=PageMember; m_PageList.push(obj);
		}
		m_PageMember.x=30;
		m_PageMember.y=my;
		m_PageMember.width=100;
		m_PageMember.height=22;
		m_PageMember.type=TextFieldType.DYNAMIC;
		m_PageMember.selectable=false;
		m_PageMember.border=false;
		m_PageMember.background=false;
		m_PageMember.backgroundColor=0x0000ff;
		m_PageMember.multiline=false;
		m_PageMember.autoSize=TextFieldAutoSize.NONE;
		m_PageMember.antiAliasType=AntiAliasType.ADVANCED;
		m_PageMember.gridFitType=GridFitType.PIXEL;
		m_PageMember.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_PageMember.embedFonts=true;
		m_PageMember.text=Common.Txt.FormUnionPageMember;
		my+=m_PageMember.height;

		if(m_Map.m_UnionId==m_UnionId) { 
			if(m_PageInfo==null) {
				m_PageInfo=new TextField();
				addChild(m_PageInfo);
				obj=new Object(); obj.Name=m_PageInfo; obj.Type=PageInfo; m_PageList.push(obj);
			}
			m_PageInfo.x=30;
			m_PageInfo.y=my;
			m_PageInfo.width=100;
			m_PageInfo.height=22;
			m_PageInfo.type=TextFieldType.DYNAMIC;
			m_PageInfo.selectable=false;
			m_PageInfo.border=false;
			m_PageInfo.background=false;
			m_PageInfo.backgroundColor=0x0000ff;
			m_PageInfo.multiline=false;
			m_PageInfo.autoSize=TextFieldAutoSize.NONE;
			m_PageInfo.antiAliasType=AntiAliasType.ADVANCED;
			m_PageInfo.gridFitType=GridFitType.PIXEL;
			m_PageInfo.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
			m_PageInfo.embedFonts=true;
			m_PageInfo.text=Common.Txt.FormUnionPageInfo;
			my+=m_PageInfo.height;
		} else {
			if(m_PageInfo!=null) {
				i=m_PageList.indexOf(m_PageInfo);
				if(i>=0) m_PageList.splice(i,1);
				removeChild(m_PageInfo);
				m_PageInfo=null;
			}
			
			if(m_PageCur==PageInfo) {
				PageHide();
				m_PageCur=PageMember;
				PageUpdate();
			}
		}

		if(((m_Map.m_UnionAccess & Union.AccessHeader) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId)) {
			if(m_PageNames==null) {
				m_PageNames=new TextField();
				addChild(m_PageNames);
				obj=new Object(); obj.Name=m_PageNames; obj.Type=PageNames; m_PageList.push(obj);
			}
			m_PageNames.x=30;
			m_PageNames.y=my;
			m_PageNames.width=100;
			m_PageNames.height=22;
			m_PageNames.type=TextFieldType.DYNAMIC;
			m_PageNames.selectable=false;
			m_PageNames.border=false;
			m_PageNames.background=false;
			m_PageNames.backgroundColor=0x0000ff;
			m_PageNames.multiline=false;
			m_PageNames.autoSize=TextFieldAutoSize.NONE;
			m_PageNames.antiAliasType=AntiAliasType.ADVANCED;
			m_PageNames.gridFitType=GridFitType.PIXEL;
			m_PageNames.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
			m_PageNames.embedFonts=true;
			m_PageNames.text=Common.Txt.FormUnionPageNames;
			my+=m_PageNames.height;
		} else {
			if(m_PageNames!=null) {
				i=m_PageList.indexOf(m_PageNames);
				if(i>=0) m_PageList.splice(i,1);
				removeChild(m_PageNames);
				m_PageNames=null;
			}
			
			if(m_PageCur==PageNames) {
				PageHide();
				m_PageCur=PageMember;
				PageUpdate();
			}
		}

		for(i=0;i<Common.CotlBonusCnt;i++) {
			if(union.m_Bonus[i]!=0) break;
		}
		if(i<Common.CotlBonusCnt) {
			if(m_PageBonus==null) {
				m_PageBonus=new TextField();
				addChild(m_PageBonus);
				obj=new Object(); obj.Name=m_PageBonus; obj.Type=PageBonus; m_PageList.push(obj);
			}
			m_PageBonus.x=30;
			m_PageBonus.y=my;
			m_PageBonus.width=100;
			m_PageBonus.height=22;
			m_PageBonus.type=TextFieldType.DYNAMIC;
			m_PageBonus.selectable=false;
			m_PageBonus.border=false;
			m_PageBonus.background=false;
			m_PageBonus.backgroundColor=0x0000ff;
			m_PageBonus.multiline=false;
			m_PageBonus.autoSize=TextFieldAutoSize.NONE;
			m_PageBonus.antiAliasType=AntiAliasType.ADVANCED;
			m_PageBonus.gridFitType=GridFitType.PIXEL;
			m_PageBonus.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
			m_PageBonus.embedFonts=true;
			m_PageBonus.text=Common.Txt.FormUnionPageBonus;
			my+=m_PageBonus.height;
		} else {
			if(m_PageBonus!=null) {
				i=m_PageList.indexOf(m_PageBonus);
				if(i>=0) m_PageList.splice(i,1);
				removeChild(m_PageBonus);
				m_PageBonus=null;
			}
			
			if(m_PageCur==PageBonus) {
				PageHide();
				m_PageCur=PageMember;
				PageUpdate();
			}
		}

		PageUpdateRazdel();

		if(m_PageCur==PageMember) PageMemberUpdate();
		else if(m_PageCur==PageInfo) PageInfoUpdate();
		else if(m_PageCur==PageNames) PageNamesUpdate();
		else if(m_PageCur==PageBonus) PageBonusUpdate();
	}

	public function PageUpdateRazdel():void
	{
		var t:int;
		var i:int;
		var l:TextField;

		for(i=0;i<m_PageList.length;i++) {
			t=m_PageList[i].Type;
			l=m_PageList[i].Name;
			
			if(t==m_PageCur) {
				l.background=true;
				l.backgroundColor=0x0000ff;
			} else if(t==m_PageMouse) {
				l.background=true;
				l.backgroundColor=0x000080;
			} else {
				l.background=false;
				l.backgroundColor=0x00008f;
			}
		}
	}
	
	public function PickPage():int
	{
		var i:int;
		var l:TextField;

		for(i=0;i<m_PageList.length;i++) {
			l=m_PageList[i].Name;

			if(l.mouseX>0 && l.mouseY>0 && l.mouseX<l.width && l.mouseY<l.height) return m_PageList[i].Type;
		}
		return -1;
	}

	public function PageHide():void
	{
		var i:int;
		var obj:Object;

		if(m_EmblemLargeImg!=null) { removeChild(m_EmblemLargeImg); m_EmblemLargeImg=null; }
		if(m_EmblemSmallImg!=null) { removeChild(m_EmblemSmallImg); m_EmblemSmallImg=null; }
		if(m_Name!=null) { removeChild(m_Name); m_Name=null; }
		if(m_Desc!=null) { removeChild(m_Desc); m_Desc=null; }

		if(m_SiteLabel!=null) { removeChild(m_SiteLabel); m_SiteLabel=null; }
		if(m_SiteVal!=null) { removeChild(m_SiteVal); m_SiteVal=null; }
		
		if(m_PageMember!=null) { removeChild(m_PageMember); m_PageMember=null; }
		if(m_PageInfo!=null) { removeChild(m_PageInfo); m_PageInfo=null; }
		if(m_PageNames!=null) { removeChild(m_PageNames); m_PageNames=null; }
		if(m_PageBonus!=null) { removeChild(m_PageBonus); m_PageBonus=null; }
		
		for(i=0;i<m_PageList.length;i++) {
			obj=m_PageList[i];
			if(obj!=null) {
				obj.Name=null;
			}
		}
		m_PageList.length=0;
		
		PageMemberHide();
		PageInfoHide();
		PageNamesHide();
		PageBonusHide();
	}
	
	public function PageInfoHide():void
	{
		if(m_HelloLabel!=null) { removeChild(m_HelloLabel); m_HelloLabel=null; }
		if(m_HelloVal!=null) { removeChild(m_HelloVal); m_HelloVal=null; }

		if(m_InfoLabel!=null) { removeChild(m_InfoLabel); m_InfoLabel=null; }
		if(m_InfoVal!=null) { removeChild(m_InfoVal); m_InfoVal=null; }
		if(m_InfoSB!=null) { removeChild(m_InfoSB); m_InfoSB=null; }
	}

	public function PageInfoUpdate():void
	{
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;

		var sx:int=200;
		var sy:int=120;
		var wx:int=width-sx-20;

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);
		var tfv:TextFormat = new TextFormat("Calibri",13,0xffff00);

		if(m_HelloLabel==null) {
			m_HelloLabel=new TextField();
			addChild(m_HelloLabel);
		}
		m_HelloLabel.x=sx;
		m_HelloLabel.y=sy;
		m_HelloLabel.width=wx;
		m_HelloLabel.height=1;
		m_HelloLabel.type=TextFieldType.DYNAMIC;
		m_HelloLabel.selectable=false;
		m_HelloLabel.border=false;
		m_HelloLabel.background=false;
		m_HelloLabel.multiline=false;
		m_HelloLabel.autoSize=TextFieldAutoSize.LEFT;
		m_HelloLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_HelloLabel.gridFitType=GridFitType.PIXEL;
		m_HelloLabel.defaultTextFormat=tf;
		m_HelloLabel.embedFonts=true;
		m_HelloLabel.addEventListener(MouseEvent.CLICK,HelloChange);
		m_HelloLabel.text=Common.Txt.FormUnionHello+":";
		sy+=m_HelloLabel.height;

		if(m_HelloVal==null) {
			m_HelloVal=new TextField();
			addChild(m_HelloVal);
		}
		m_HelloVal.x=sx;
		m_HelloVal.y=sy;
		m_HelloVal.width=wx;
		m_HelloVal.height=100;
		m_HelloVal.type=TextFieldType.DYNAMIC;
		m_HelloVal.selectable=false;
		m_HelloVal.border=false;
		m_HelloVal.background=false;
		m_HelloVal.multiline=true;
		m_HelloVal.wordWrap=true; 
		m_HelloVal.autoSize=TextFieldAutoSize.NONE;
		m_HelloVal.antiAliasType=AntiAliasType.ADVANCED;
		m_HelloVal.gridFitType=GridFitType.PIXEL;
		m_HelloVal.defaultTextFormat=tfv;
		m_HelloVal.embedFonts=true;
		m_HelloVal.addEventListener(MouseEvent.CLICK,HelloChange);
		m_HelloVal.text=union.m_Hello;
		sy+=Math.max(20,m_HelloVal.height)+5;

		if(m_InfoLabel==null) {
			m_InfoLabel=new TextField();
			addChild(m_InfoLabel);
		}
		m_InfoLabel.x=sx;
		m_InfoLabel.y=sy;
		m_InfoLabel.width=wx;
		m_InfoLabel.height=1;
		m_InfoLabel.type=TextFieldType.DYNAMIC;
		m_InfoLabel.selectable=false;
		m_InfoLabel.border=false;
		m_InfoLabel.background=false;
		m_InfoLabel.multiline=false;
		m_InfoLabel.autoSize=TextFieldAutoSize.LEFT;
		m_InfoLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_InfoLabel.gridFitType=GridFitType.PIXEL;
		m_InfoLabel.defaultTextFormat=tf;
		m_InfoLabel.embedFonts=true;
		m_InfoLabel.addEventListener(MouseEvent.CLICK,InfoChange);
		m_InfoLabel.text=Common.Txt.FormUnionInfo+":";
		sy+=m_InfoLabel.height;

		if(m_InfoSB==null) {
			m_InfoSB=new UIScrollBar();
			addChild(m_InfoSB);
			
			Common.UIChatBar(m_InfoSB);
		}

		if(m_InfoVal==null) {
			m_InfoVal=new TextField();
			addChild(m_InfoVal);
		}
		m_InfoVal.x=sx;
		m_InfoVal.y=sy;
		m_InfoVal.width=wx-10;
		m_InfoVal.height=height-sy-50;
		m_InfoVal.type=TextFieldType.DYNAMIC;
		m_InfoVal.selectable=false;
		m_InfoVal.border=false;
		m_InfoVal.background=false;
		m_InfoVal.multiline=true;
		m_InfoVal.wordWrap=true; 
		m_InfoVal.autoSize=TextFieldAutoSize.NONE;
		m_InfoVal.antiAliasType=AntiAliasType.ADVANCED;
		m_InfoVal.gridFitType=GridFitType.PIXEL;
		m_InfoVal.defaultTextFormat=tfv;
		m_InfoVal.embedFonts=true;
		m_InfoVal.addEventListener(MouseEvent.CLICK,InfoChange);
		m_InfoVal.text=union.m_Info;
		sy+=Math.max(20,m_InfoVal.height)+5;
		
		m_InfoSB.scrollTarget=m_InfoVal;
		addChild(m_InfoSB);
		
		m_InfoSB.move(m_InfoVal.x + m_InfoVal.width, m_InfoVal.y);
		m_InfoSB.setSize(m_InfoSB.width, m_InfoVal.height);
		m_InfoSB.update();
		m_InfoSB.visible=m_InfoSB.maxScrollPosition>1;
	}

	public function EmblemSmallChange(e:MouseEvent):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		if(!(((m_Map.m_UnionAccess & Union.AccessHeader) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId))) return;

		var fr:FileReference=new FileReference();
		fr.browse(new Array(new FileFilter("png (*.png)", "*.png")));
		fr.addEventListener(Event.SELECT, EmblemSmallChangeSend);
		fr.addEventListener(IOErrorEvent.IO_ERROR, Server.Self.QueryError);
		fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,EmblemSmallAnswer);
	}

	public function EmblemSmallChangeSend(event:Event):void
	{
		var fr:FileReference = FileReference(event.target);
		fr.upload(Server.Self.QueryRequest("emunionchange", "&val=1"));		
	}

	public function EmblemSmallAnswer(event:DataEvent):void
	{
//trace(event.data,int(event.data));
		var err:int=int(event.data);
		if(!err) UserList.Self.ReloadUnion(m_UnionId);
		else if(err==Server.ErrorImgFormat) FormMessageBox.Run(Common.Txt.FormUnionErrImgFormat,Common.Txt.ButClose);
		else if(err==Server.ErrorImgSize) FormMessageBox.Run(Common.Txt.FormUnionErrImgSmallSize,Common.Txt.ButClose);
		else m_Map.ErrorFromServer(err)
	}

	public function EmblemLargeChange(e:MouseEvent):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		if(!(((m_Map.m_UnionAccess & Union.AccessHeader) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId))) return;

		var fr:FileReference=new FileReference();
		fr.browse(new Array(new FileFilter("png (*.png)", "*.png")));
		fr.addEventListener(Event.SELECT, EmblemLargeChangeSend);
		fr.addEventListener(IOErrorEvent.IO_ERROR, Server.Self.QueryError);
		fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,EmblemLargeAnswer);
	}

	public function EmblemLargeChangeSend(event:Event):void
	{
		var fr:FileReference = FileReference(event.target);
		fr.upload(Server.Self.QueryRequest("emunionchange", "&val=2"));		
	}

	public function EmblemLargeAnswer(event:DataEvent):void
	{
		var err:int=int(event.data);
		if(!err) UserList.Self.ReloadUnion(m_UnionId);
		else if(err==Server.ErrorImgFormat) FormMessageBox.Run(Common.Txt.FormUnionErrImgFormat,Common.Txt.ButClose);
		else if(err==Server.ErrorImgSize) FormMessageBox.Run(Common.Txt.FormUnionErrImgLargeSize,Common.Txt.ButClose);
		else m_Map.ErrorFromServer(err)
	}
	
/*	public function AnswerChange(event:Event):void
	{
		var loader:FileReference = FileReference(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int=buf.readUnsignedByte();
		trace(err);
		//if(ErrorFromServer(err)) return;
	}*/

	public function DescChange(e:MouseEvent):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		if(!(((m_Map.m_UnionAccess & Union.AccessHeader) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId))) return;

		m_Map.m_FormInput.Init();
		m_Map.m_FormInput.AddLabel(Common.Txt.FormUnionDesc+":");
		m_Map.m_FormInput.AddArea(80,true,union.m_Desc,511,true,Server.LANG_RUS);
		m_Map.m_FormInput.AddLabel(Common.Txt.FormUnionDescEng+":");
		m_Map.m_FormInput.AddArea(80,true,union.m_DescEng,511,true,Server.LANG_ENG);
		m_Map.m_FormInput.Run(DescSend);
	}
	
	public function DescSend():void
	{
		var i:int,v:int,cnt:int,cnt2:int;
		
		var txt:String=(m_Map.m_FormInput.Get(2) as TextArea).text;
		cnt=0; cnt2=0;
		for(i=0;i<txt.length;i++) {
			v=txt.charCodeAt(i);
			if(v==10) cnt++;
			else if(v==13) cnt2++;
		}
		if(cnt>2 || cnt2>2) { FormMessageBox.Run(Common.Txt.FormUnionErrDescLine,Common.Txt.ButClose); return; }

		var txt2:String=(m_Map.m_FormInput.Get(4) as TextArea).text;
		cnt=0; cnt2=0;
		for(i=0;i<txt2.length;i++) {
			v=txt2.charCodeAt(i);
			if(v==10) cnt++;
			else if(v==13) cnt2++;
		}
		if(cnt>2 || cnt2>2) { FormMessageBox.Run(Common.Txt.FormUnionErrDescLine,Common.Txt.ButClose); return; }

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"desc\"\r\n\r\n";
        d+=txt+"\r\n"
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"desceng\"\r\n\r\n";
        d+=txt2+"\r\n";
        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emunionchange","&val=3",d,boundary,DescRecv);
	}

	public function DescRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var err:int=int(loader.data);
		if(!err) UserList.Self.ReloadUnion(m_UnionId);
		else if(err==Server.ErrorText) { m_Map.m_FormInput.visible=true; FormMessageBox.Run(Common.Txt.FormUnionErrText,Common.Txt.ButClose); }
		else if(err==Server.ErrorExistName) { m_Map.m_FormInput.visible=true; FormMessageBox.Run(Common.Txt.UnionErrExistName,Common.Txt.ButClose); }
		else if(err==Server.ErrorExistNameEng) { m_Map.m_FormInput.visible=true; FormMessageBox.Run(Common.Txt.UnionErrExistNameEng,Common.Txt.ButClose); }
		else if(err==Server.ErrorNoEnoughEGM) { m_Map.m_FormInput.visible=true; FormMessageBox.Run(Common.Txt.NoEnoughEGM2,Common.Txt.ButClose); }
		else if(err==Server.ErrorNoAccess) { FormMessageBox.Run(Common.Txt.FormUnionErrAccess,Common.Txt.ButClose); }
		else m_Map.ErrorFromServer(err)
	}

	public function SiteChange(e:MouseEvent):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		if(!(((m_Map.m_UnionAccess & Union.AccessHeader) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId))) return;

		m_Map.m_FormInput.Init();
		m_Map.m_FormInput.AddLabel(Common.Txt.FormUnionSite+":");
		m_Map.m_FormInput.AddInput(union.m_Site,127,true,Server.LANG_ENG);
		m_Map.m_FormInput.Run(SiteSend);
	}

	public function SiteSend():void
	{
		var i:int,v:int,cnt:int,cnt2:int;

		var txt:String=(m_Map.m_FormInput.Get(2) as TextInput).text;

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"data\"\r\n\r\n";
        d+=txt+"\r\n"
        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emunionchange","&val=4",d,boundary,DescRecv);
	}

	public function SiteGo(e:MouseEvent):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;

		try {
			var str:String=union.m_Site;
			if(str.substring(0,7)!="http://") str="http://"+str; 
			var request:URLRequest = new URLRequest(str);
			navigateToURL(request,"_blank");
		}
		catch (e:Error) {
		}
	}

	public function NameChange(e:MouseEvent):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;

		var str:String;

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		if(!(((m_Map.m_UnionAccess & Union.AccessHeader) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId))) return;

		m_Map.m_FormInput.Init();
		m_Map.m_FormInput.AddLabel(Common.Txt.UnionNewCptName+":");
		m_Map.m_FormInput.AddInput(union.m_Name,31,true,Server.LANG_RUS,false);
		m_Map.m_FormInput.AddLabel(Common.Txt.UnionNewCptNameEng+":");
		m_Map.m_FormInput.AddInput(union.m_NameEng,31,true,Server.LANG_ENG,false);

		str=Common.Txt.FormUnionRenameCost;
		m_Map.m_FormInput.AddLabel(BaseStr.Replace(str,"<Val>",BaseStr.FormatBigInt(Common.CostRenameUnion)));

		m_Map.m_FormInput.Run(NameSend);
	}

	public function NameSend():void
	{
		var i:int,v:int,cnt:int,cnt2:int;

		var txt:String=(m_Map.m_FormInput.Get(2) as TextInput).text;
		var txt2:String=(m_Map.m_FormInput.Get(4) as TextInput).text;

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"data\"\r\n\r\n";
        d+=txt+"\r\n"
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"dataeng\"\r\n\r\n";
        d+=txt2+"\r\n"
        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emunionchange","&val=5",d,boundary,DescRecv);
	}

	public function HelloChange(e:MouseEvent):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		if(!(((m_Map.m_UnionAccess & Union.AccessInfo) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId))) return;

		m_Map.m_FormInput.Init();
		m_Map.m_FormInput.AddLabel(Common.Txt.FormUnionHello+":");
		m_Map.m_FormInput.AddArea(120,true,union.m_Hello,127,true,Server.LANG_RUS);
		m_Map.m_FormInput.Run(HelloSend);
	}
	
	public function HelloSend():void
	{
		var i:int,v:int,cnt:int,cnt2:int;
		
		var txt:String=(m_Map.m_FormInput.Get(2) as TextArea).text;
		cnt=0; cnt2=0;
		for(i=0;i<txt.length;i++) {
			v=txt.charCodeAt(i);
			if(v==10) cnt++;
			else if(v==13) cnt2++;
		}
		if(cnt>5 || cnt2>5) { FormMessageBox.Run(Common.Txt.FormUnionErrHelloLine,Common.Txt.ButClose); return; }

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"data\"\r\n\r\n";
        d+=txt+"\r\n"
        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emunionchange","&val=6",d,boundary,DescRecv);
	}

	public function InfoChange(e:MouseEvent):void
	{
		if(m_Map.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;
		
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		if(!(((m_Map.m_UnionAccess & Union.AccessInfo) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId))) return;

		m_Map.m_FormInput.Init();
		m_Map.m_FormInput.AddLabel(Common.Txt.FormUnionInfo+":");
		m_Map.m_FormInput.AddArea(240,true,union.m_Info,((1024*16)>>1)-1,true,Server.LANG_RUS);
		m_Map.m_FormInput.Run(InfoSend);
	}

	public function InfoSend():void
	{
		var i:int,v:int,cnt:int,cnt2:int;

		var txt:String=(m_Map.m_FormInput.Get(2) as TextArea).text;
		cnt=0; cnt2=0;
		for(i=0;i<txt.length;i++) {
			v=txt.charCodeAt(i);
			if(v==10) cnt++;
			else if(v==13) cnt2++;
		}
		if(cnt>(50-1) || cnt2>(50-1)) { FormMessageBox.Run(Common.Txt.FormUnionErrInfoLine,Common.Txt.ButClose); return; }

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"data\"\r\n\r\n";
        d+=txt+"\r\n"
        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emunionchange","&val=7",d,boundary,DescRecv);
	}

	public function PageMemberHide():void
	{
		if(m_MemberList!=null) {
			removeChild(m_MemberList);
			m_MemberList=null;
		}
		UserHide();
	}

	public function PageMemberUpdate():void
	{
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;

		if(m_MemberList==null) {
			m_MemberList=new DataGrid(); 
			addChild(m_MemberList);
		
			m_MemberList.addEventListener(Event.CHANGE,onMemberListChange);
	
			m_MemberList.setStyle("skin",ListOnlineUser_skin);
			m_MemberList.setStyle("cellRenderer",MemberListRenderer);
	
			m_MemberList.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
			m_MemberList.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
			m_MemberList.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
			m_MemberList.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);
	
			m_MemberList.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
			m_MemberList.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
			m_MemberList.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
			m_MemberList.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
			m_MemberList.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);
	
			m_MemberList.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
			m_MemberList.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
			m_MemberList.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
			m_MemberList.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);
	
			m_MemberList.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
			m_MemberList.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
			m_MemberList.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
			m_MemberList.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);
	
			m_MemberList.setStyle("headerTextFormat",new TextFormat("Calibri",14,0xffffff));
			m_MemberList.setStyle("headerУmbedFonts", true);
			m_MemberList.setStyle("headerTextPadding",5);
	
			m_MemberList.rowHeight=22;

			var col:DataGridColumn;
			col=new DataGridColumn("Name"); col.headerText=Common.Txt.FormUnionUser; m_MemberList.addColumn(col);
			col=new DataGridColumn("RankTxt"); /*col.headerText=Common.Txt.FormUnionRank;*/ col.width=80; m_MemberList.addColumn(col);
			m_MemberList.minColumnWidth=30;
		}

		m_MemberList.getColumnAt(1).headerText=union.NameRank();

		m_MemberList.x=200;
		m_MemberList.y=120;
		m_MemberList.width=width-200-20;
		m_MemberList.height=height-120-50;

		UpdateMemberList();
	}
	
	public function UpdateMemberList():void
	{
		var user:User;
		
		if(m_MemberList==null) return;

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		
		var selectid:uint=0;
		if(m_MemberList!=null && m_MemberList.selectedItem!=null) selectid=m_MemberList.selectedItem.User;

		m_MemberList.removeAll();

		var da:ByteArray=UserList.Self.GetUnionMember(m_UnionId);
		if(da==null) {
		} else {
			var sl:SaveLoad=new SaveLoad();
			da.position=0;
			sl.LoadBegin(da);
			while(true) {
				var id:uint=sl.LoadDword();
				if(id==0) break;
				var rank:int=sl.LoadInt();
				var access:uint=sl.LoadDword();

				user=UserList.Self.GetUser(id,true,false);
				if(user==null) return;

				var obj:Object={ Name:EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id), Rank:rank, User:id, Access:access };
				if(id==union.m_RootAdmin) obj.RankTxt=union.NameAdmin();
				else obj.RankTxt=union.ValRank(rank);
				m_MemberList.addItem(obj);
				
				if(id==selectid) m_MemberList.selectedItem=obj 
			}
			sl.LoadEnd();
		}
	}
	
	private function onMemberListChange(e:Event):void
	{
		if(m_MemberList==null) return; 		
		//if(m_MemberList.selectedItem==undefined) return;
		if(m_MemberList.selectedItem==null) return;
		
		UserShow(m_MemberList.selectedItem.User);
	}

	public function RecvUser(e:Event):void
	{
		UpdateMemberList();
	}

	public function JoinQuery(userid:uint):void
	{
		Server.Self.Query("emunionjoin","&type=1&id="+userid.toString(),StdRecv,false);
	}

	public function JoinAcceptQuery(userid:uint):void
	{
		Server.Self.Query("emunionjoin","&type=2&id="+userid.toString(),StdRecv,false);
	}

	public function JoinCancelQuery(userid:uint):void
	{
		Server.Self.Query("emunionjoin","&type=3&id="+userid.toString(),StdRecv,false);
	}

	public function StdRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint=buf.readUnsignedByte();
		if(err==0) {}
		else if(err==Server.ErrorExist) FormMessageBox.Run(Common.Txt.FormUnionErrAlreadyJoin,Common.Txt.ButClose);
		else if(err==Server.ErrorNoAccess) FormMessageBox.Run(Common.Txt.FormUnionErrAccess,Common.Txt.ButClose);
		else m_Map.ErrorFromServer(err);
	}
	
	public function UserInfoById(id:uint):Object
	{
		var i:int;
		if(m_MemberList==null) return null;
		for(i=0;i<m_MemberList.length;i++) {
			var ui:Object=m_MemberList.getItemAt(i);
			if(ui.User==id) return ui;
		}
		return null;
	}

	public function UserHide():void
	{
		AccessHide();

		if(m_UserInfo!=null) { removeChild(m_UserInfo); m_UserInfo=null; }
		if(m_UserOptions!=null) { removeChild(m_UserOptions); m_UserOptions=null; }

		m_ShowUserId=0;
	}
	
	public function UserShow(id:uint):void
	{
		UserHide();
		
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;

		var ui:Object=UserInfoById(id);
		if(ui==null) return;
		
		var user:User=UserList.Self.GetUser(id);
		if(user==null) return;

		m_ShowUserId=id;
		
		var str:String=Common.Txt.User+": <font color='#ffff00'>"+EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id)+"</font>\n";
		if(id==union.m_RootAdmin) str+=union.NameRank()+": <font color='#ffff00'>"+union.NameAdmin()+"</font>\n";
		else str+=union.NameRank()+": <font color='#ffff00'>"+union.ValRank(ui.Rank)+"</font>\n"
		
		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);
		
		if(m_UserOptions==null) {
			m_UserOptions=new MMButOptions();
			addChild(m_UserOptions);
			m_UserOptions.addEventListener(MouseEvent.CLICK,UserOptions);
		}
		m_UserOptions.x=10-1;
		m_UserOptions.y=230+2;
		
		if(m_UserInfo==null) {
			m_UserInfo=new TextField();
			addChild(m_UserInfo);
		}
		m_UserInfo.x=35;
		m_UserInfo.y=230;
		m_UserInfo.width=1;
		m_UserInfo.height=1;
		m_UserInfo.type=TextFieldType.DYNAMIC;
		m_UserInfo.selectable=false;
		m_UserInfo.border=false;
		m_UserInfo.background=false;
		m_UserInfo.multiline=false;
		m_UserInfo.autoSize=TextFieldAutoSize.LEFT;
		m_UserInfo.antiAliasType=AntiAliasType.ADVANCED;
		m_UserInfo.gridFitType=GridFitType.PIXEL;
		m_UserInfo.defaultTextFormat=tf;
		m_UserInfo.embedFonts=true;
		m_UserInfo.htmlText=str;
		
		AccessShow();
	}
	
	public function AccessHide():void
	{
		if(m_AccessTitle!=null) { removeChild(m_AccessTitle); m_AccessTitle=null; }
		if(m_AccessHedaerLabel!=null) { removeChild(m_AccessHedaerLabel); m_AccessHedaerLabel=null; }
		if(m_AccessInfoLabel!=null) { removeChild(m_AccessInfoLabel); m_AccessInfoLabel=null; }
		if(m_AccessInviteLabel!=null) { removeChild(m_AccessInviteLabel); m_AccessInviteLabel=null; }
		if(m_AccessExclusionLabel!=null) { removeChild(m_AccessExclusionLabel); m_AccessExclusionLabel=null; }
		if(m_AccessRankLabel!=null) { removeChild(m_AccessRankLabel); m_AccessRankLabel=null; }
		if(m_AccessAccessLabel!=null) { removeChild(m_AccessAccessLabel); m_AccessAccessLabel=null; }
		if(m_AccessChatEditLabel!=null) { removeChild(m_AccessChatEditLabel); m_AccessChatEditLabel=null; }

		if(m_AccessHedaerCheck!=null) { removeChild(m_AccessHedaerCheck); m_AccessHedaerCheck=null; }
		if(m_AccessInfoCheck!=null) { removeChild(m_AccessInfoCheck); m_AccessInfoCheck=null; }
		if(m_AccessInviteCheck!=null) { removeChild(m_AccessInviteCheck); m_AccessInviteCheck=null; }
		if(m_AccessExclusionCheck!=null) { removeChild(m_AccessExclusionCheck); m_AccessExclusionCheck=null; }
		if(m_AccessRankCheck!=null) { removeChild(m_AccessRankCheck); m_AccessRankCheck=null; }
		if(m_AccessAccessCheck!=null) { removeChild(m_AccessAccessCheck); m_AccessAccessCheck=null; }
		if(m_AccessChatEditCheck!=null) { removeChild(m_AccessChatEditCheck); m_AccessChatEditCheck=null; }
		
		if(m_AccessSave!=null) { removeChild(m_AccessSave); m_AccessSave=null; }
	}
	
	public function AccessShow():void
	{
		var ui:Object=UserInfoById(m_ShowUserId);
		if(ui==null) return;

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
		
		var ac:uint=ui.Access;
		if(union.m_RootAdmin==m_ShowUserId) ac=0xffffffff;
		
		var issave:Boolean=false;
		if(((m_Map.m_UnionAccess & Union.AccessAccess) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId)) issave=true;
		if(union.m_RootAdmin==m_ShowUserId) issave=false;

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);
		
		var sx:int=10;
		var sy:int=280;

		if(m_AccessTitle==null) {
			m_AccessTitle=new TextField();
			addChild(m_AccessTitle);
		}
		m_AccessTitle.x=sx;
		m_AccessTitle.y=sy;
		m_AccessTitle.width=1;
		m_AccessTitle.height=1;
		m_AccessTitle.type=TextFieldType.DYNAMIC;
		m_AccessTitle.selectable=false;
		m_AccessTitle.border=false;
		m_AccessTitle.background=false;
		m_AccessTitle.multiline=false;
		m_AccessTitle.autoSize=TextFieldAutoSize.LEFT;
		m_AccessTitle.antiAliasType=AntiAliasType.ADVANCED;
		m_AccessTitle.gridFitType=GridFitType.PIXEL;
		m_AccessTitle.defaultTextFormat=tf;
		m_AccessTitle.embedFonts=true;
		m_AccessTitle.text=Common.Txt.FormUnionAccessTitle;

		sy+=22;

		if(m_AccessHedaerCheck==null) {
			m_AccessHedaerCheck=new CheckBox();
			CheckStyle(m_AccessHedaerCheck);
			addChild(m_AccessHedaerCheck);
		}
		m_AccessHedaerCheck.x=sx;
		m_AccessHedaerCheck.y=sy;
		m_AccessHedaerCheck.selected=(ac & Union.AccessHeader)!=0;
		m_AccessHedaerCheck.enabled=issave;
		m_AccessHedaerCheck.label=""; 
		
		if(m_AccessHedaerLabel==null) {
			m_AccessHedaerLabel=new TextField();
			addChild(m_AccessHedaerLabel);
		}
		m_AccessHedaerLabel.x=sx+20;
		m_AccessHedaerLabel.y=sy;
		m_AccessHedaerLabel.width=1;
		m_AccessHedaerLabel.height=1;
		m_AccessHedaerLabel.type=TextFieldType.DYNAMIC;
		m_AccessHedaerLabel.selectable=false;
		m_AccessHedaerLabel.border=false;
		m_AccessHedaerLabel.background=false;
		m_AccessHedaerLabel.multiline=false;
		m_AccessHedaerLabel.autoSize=TextFieldAutoSize.LEFT;
		m_AccessHedaerLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_AccessHedaerLabel.gridFitType=GridFitType.PIXEL;
		m_AccessHedaerLabel.defaultTextFormat=tf;
		m_AccessHedaerLabel.embedFonts=true;
		m_AccessHedaerLabel.text=Common.Txt.FormUnionAccessHeader;
		
		sy+=22;

		if(m_AccessInfoCheck==null) {
			m_AccessInfoCheck=new CheckBox();
			CheckStyle(m_AccessInfoCheck);
			addChild(m_AccessInfoCheck);
		}
		m_AccessInfoCheck.x=sx;
		m_AccessInfoCheck.y=sy;
		m_AccessInfoCheck.selected=(ac & Union.AccessInfo)!=0;
		m_AccessInfoCheck.enabled=issave;
		m_AccessInfoCheck.label=""; 
		
		if(m_AccessInfoLabel==null) {
			m_AccessInfoLabel=new TextField();
			addChild(m_AccessInfoLabel);
		}
		m_AccessInfoLabel.x=sx+20;
		m_AccessInfoLabel.y=sy;
		m_AccessInfoLabel.width=1;
		m_AccessInfoLabel.height=1;
		m_AccessInfoLabel.type=TextFieldType.DYNAMIC;
		m_AccessInfoLabel.selectable=false;
		m_AccessInfoLabel.border=false;
		m_AccessInfoLabel.background=false;
		m_AccessInfoLabel.multiline=false;
		m_AccessInfoLabel.autoSize=TextFieldAutoSize.LEFT;
		m_AccessInfoLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_AccessInfoLabel.gridFitType=GridFitType.PIXEL;
		m_AccessInfoLabel.defaultTextFormat=tf;
		m_AccessInfoLabel.embedFonts=true;
		m_AccessInfoLabel.text=Common.Txt.FormUnionAccessInfo;

		sy+=22;

		if(m_AccessInviteCheck==null) {
			m_AccessInviteCheck=new CheckBox();
			CheckStyle(m_AccessInviteCheck);
			addChild(m_AccessInviteCheck);
		}
		m_AccessInviteCheck.x=sx;
		m_AccessInviteCheck.y=sy;
		m_AccessInviteCheck.selected=(ac & Union.AccessInvite)!=0;
		m_AccessInviteCheck.enabled=issave;
		m_AccessInviteCheck.label=""; 
		
		if(m_AccessInviteLabel==null) {
			m_AccessInviteLabel=new TextField();
			addChild(m_AccessInviteLabel);
		}
		m_AccessInviteLabel.x=sx+20;
		m_AccessInviteLabel.y=sy;
		m_AccessInviteLabel.width=1;
		m_AccessInviteLabel.height=1;
		m_AccessInviteLabel.type=TextFieldType.DYNAMIC;
		m_AccessInviteLabel.selectable=false;
		m_AccessInviteLabel.border=false;
		m_AccessInviteLabel.background=false;
		m_AccessInviteLabel.multiline=false;
		m_AccessInviteLabel.autoSize=TextFieldAutoSize.LEFT;
		m_AccessInviteLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_AccessInviteLabel.gridFitType=GridFitType.PIXEL;
		m_AccessInviteLabel.defaultTextFormat=tf;
		m_AccessInviteLabel.embedFonts=true;
		m_AccessInviteLabel.text=Common.Txt.FormUnionAccessInvite;

		sy+=22;

		if(m_AccessExclusionCheck==null) {
			m_AccessExclusionCheck=new CheckBox();
			CheckStyle(m_AccessExclusionCheck);
			addChild(m_AccessExclusionCheck);
		}
		m_AccessExclusionCheck.x=sx;
		m_AccessExclusionCheck.y=sy;
		m_AccessExclusionCheck.selected=(ac & Union.AccessExclusion)!=0;
		m_AccessExclusionCheck.enabled=issave;
		m_AccessExclusionCheck.label=""; 
		
		if(m_AccessExclusionLabel==null) {
			m_AccessExclusionLabel=new TextField();
			addChild(m_AccessExclusionLabel);
		}
		m_AccessExclusionLabel.x=sx+20;
		m_AccessExclusionLabel.y=sy;
		m_AccessExclusionLabel.width=1;
		m_AccessExclusionLabel.height=1;
		m_AccessExclusionLabel.type=TextFieldType.DYNAMIC;
		m_AccessExclusionLabel.selectable=false;
		m_AccessExclusionLabel.border=false;
		m_AccessExclusionLabel.background=false;
		m_AccessExclusionLabel.multiline=false;
		m_AccessExclusionLabel.autoSize=TextFieldAutoSize.LEFT;
		m_AccessExclusionLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_AccessExclusionLabel.gridFitType=GridFitType.PIXEL;
		m_AccessExclusionLabel.defaultTextFormat=tf;
		m_AccessExclusionLabel.embedFonts=true;
		m_AccessExclusionLabel.text=Common.Txt.FormUnionAccessExclusion;

		sy+=22;

		if(m_AccessRankCheck==null) {
			m_AccessRankCheck=new CheckBox();
			CheckStyle(m_AccessRankCheck);
			addChild(m_AccessRankCheck);
		}
		m_AccessRankCheck.x=sx;
		m_AccessRankCheck.y=sy;
		m_AccessRankCheck.selected=(ac & Union.AccessRank)!=0;
		m_AccessRankCheck.enabled=issave;
		m_AccessRankCheck.label=""; 
		
		if(m_AccessRankLabel==null) {
			m_AccessRankLabel=new TextField();
			addChild(m_AccessRankLabel);
		}
		m_AccessRankLabel.x=sx+20;
		m_AccessRankLabel.y=sy;
		m_AccessRankLabel.width=1;
		m_AccessRankLabel.height=1;
		m_AccessRankLabel.type=TextFieldType.DYNAMIC;
		m_AccessRankLabel.selectable=false;
		m_AccessRankLabel.border=false;
		m_AccessRankLabel.background=false;
		m_AccessRankLabel.multiline=false;
		m_AccessRankLabel.autoSize=TextFieldAutoSize.LEFT;
		m_AccessRankLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_AccessRankLabel.gridFitType=GridFitType.PIXEL;
		m_AccessRankLabel.defaultTextFormat=tf;
		m_AccessRankLabel.embedFonts=true;
		m_AccessRankLabel.text=Common.Txt.FormUnionAccessRank;

		sy+=22;

		if(m_AccessAccessCheck==null) {
			m_AccessAccessCheck=new CheckBox();
			CheckStyle(m_AccessAccessCheck);
			addChild(m_AccessAccessCheck);
		}
		m_AccessAccessCheck.x=sx;
		m_AccessAccessCheck.y=sy;
		m_AccessAccessCheck.selected=(ac & Union.AccessAccess)!=0;
		m_AccessAccessCheck.enabled=issave;
		m_AccessAccessCheck.label=""; 

		if(m_AccessAccessLabel==null) {
			m_AccessAccessLabel=new TextField();
			addChild(m_AccessAccessLabel);
		}
		m_AccessAccessLabel.x=sx+20;
		m_AccessAccessLabel.y=sy;
		m_AccessAccessLabel.width=1;
		m_AccessAccessLabel.height=1;
		m_AccessAccessLabel.type=TextFieldType.DYNAMIC;
		m_AccessAccessLabel.selectable=false;
		m_AccessAccessLabel.border=false;
		m_AccessAccessLabel.background=false;
		m_AccessAccessLabel.multiline=false;
		m_AccessAccessLabel.autoSize=TextFieldAutoSize.LEFT;
		m_AccessAccessLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_AccessAccessLabel.gridFitType=GridFitType.PIXEL;
		m_AccessAccessLabel.defaultTextFormat=tf;
		m_AccessAccessLabel.embedFonts=true;
		m_AccessAccessLabel.text=Common.Txt.FormUnionAccessAccess;

		sy+=22;

		if(m_AccessChatEditCheck==null) {
			m_AccessChatEditCheck=new CheckBox();
			CheckStyle(m_AccessChatEditCheck);
			addChild(m_AccessChatEditCheck);
		}
		m_AccessChatEditCheck.x=sx;
		m_AccessChatEditCheck.y=sy;
		m_AccessChatEditCheck.selected=(ac & Union.AccessChatEdit)!=0;
		m_AccessChatEditCheck.enabled=issave;
		m_AccessChatEditCheck.label=""; 
		
		if(m_AccessChatEditLabel==null) {
			m_AccessChatEditLabel=new TextField();
			addChild(m_AccessChatEditLabel);
		}
		m_AccessChatEditLabel.x=sx+20;
		m_AccessChatEditLabel.y=sy;
		m_AccessChatEditLabel.width=1;
		m_AccessChatEditLabel.height=1;
		m_AccessChatEditLabel.type=TextFieldType.DYNAMIC;
		m_AccessChatEditLabel.selectable=false;
		m_AccessChatEditLabel.border=false;
		m_AccessChatEditLabel.background=false;
		m_AccessChatEditLabel.multiline=false;
		m_AccessChatEditLabel.autoSize=TextFieldAutoSize.LEFT;
		m_AccessChatEditLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_AccessChatEditLabel.gridFitType=GridFitType.PIXEL;
		m_AccessChatEditLabel.defaultTextFormat=tf;
		m_AccessChatEditLabel.embedFonts=true;
		m_AccessChatEditLabel.text=Common.Txt.FormUnionAccessChatEdit;
		
		sy+=32;
		
		if(issave) {
			if(m_AccessSave==null) {
				m_AccessSave=new Button();
				addChild(m_AccessSave);
			}
			m_AccessSave.label = Common.Txt.ButSave;
			m_AccessSave.width=100;
			m_AccessSave.x=sx+70;
			m_AccessSave.y=sy;
			Common.UIStdBut(m_AccessSave);
			m_AccessSave.addEventListener(MouseEvent.CLICK, clickAccessSave);
		} else {
			if(m_AccessSave!=null) { removeChild(m_AccessSave); m_AccessSave=null; }
		}
	}
	
	public function CheckStyle(cb:CheckBox):void
	{
		cb.setStyle("disabledIcon",CheckBox_P_disabledIcon);
		cb.setStyle("disabledSkin",CheckBox_P_disabledIcon);
		cb.setStyle("selectedDisabledIcon",CheckBox_P_selectedDisabledIcon);
		cb.setStyle("selectedDisabledSkin",CheckBox_P_selectedDisabledIcon);

		cb.setStyle("downIcon",CheckBox_P_disabledIcon);
		cb.setStyle("downSkin",CheckBox_P_disabledIcon);
		cb.setStyle("selectedDownIcon",CheckBox_P_selectedDisabledIcon);
		cb.setStyle("selectedDownSkin",CheckBox_P_selectedDisabledIcon);

		cb.setStyle("overIcon",CheckBox_P_disabledIcon);
		cb.setStyle("overSkin",CheckBox_P_disabledIcon);
		cb.setStyle("selectedOverIcon",CheckBox_P_selectedDisabledIcon);
		cb.setStyle("selectedOverSkin",CheckBox_P_selectedDisabledIcon);

		cb.setStyle("upIcon",CheckBox_P_disabledIcon);
		cb.setStyle("upSkin",CheckBox_P_disabledIcon);
		cb.setStyle("selectedUpIcon",CheckBox_P_selectedDisabledIcon);
		cb.setStyle("selectedUpSkin",CheckBox_P_selectedDisabledIcon);
	}

	private function clickAccessSave(e:Event):void
	{
		var ac:uint=0;

		if(m_AccessHedaerCheck.selected) ac|=Union.AccessHeader;
		if(m_AccessInfoCheck.selected) ac|=Union.AccessInfo;
		if(m_AccessInviteCheck.selected) ac|=Union.AccessInvite;
		if(m_AccessExclusionCheck.selected) ac|=Union.AccessExclusion;
		if(m_AccessRankCheck.selected) ac|=Union.AccessRank;
		if(m_AccessAccessCheck.selected) ac|=Union.AccessAccess;
		if(m_AccessChatEditCheck.selected) ac|=Union.AccessChatEdit;

		Server.Self.Query("emunionaccess","&val="+ac.toString()+"&id="+m_ShowUserId.toString(),AccessRecv,false);

		AccessHide();
	}

	public function AccessRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint=buf.readUnsignedByte();
		if(err==0) { UserList.Self.ReloadUnion(m_UnionId); }
		else if(err==Server.ErrorNoAccess) FormMessageBox.Run(Common.Txt.FormUnionErrAccess,Common.Txt.ButClose);
		else m_Map.ErrorFromServer(err);
	}

	public function UserOptions(event:Event):void
	{
		var i:int;
		var obj:Object;

		if(m_Map.m_FormMenu.visible) {
			m_Map.m_FormMenu.Clear();
			return;	
		}
		FormMessageBox.Self.visible=false;
		m_Map.m_FormInput.Hide();
		m_Map.m_Info.Hide();
		m_Map.m_FormMenu.Clear();

		if(m_UserOptions==null) return;

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;

		var ui:Object=UserInfoById(m_ShowUserId);
		if(ui==null) return;

		while(((m_Map.m_UnionAccess & Union.AccessRank) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId)) {
			if(m_ShowUserId==union.m_RootAdmin) break;
			m_Map.m_FormMenu.Add(union.NameRank()+":");
			for(i=0;i<5;i++) {
				obj=m_Map.m_FormMenu.Add("    "+union.ValRank(i),ChangeRank,i);
				if(i==ui.Rank) obj.Check=true;
			}
			break;
		}
		
		m_Map.m_FormMenu.Add();

		if((Server.Self.m_UserId==union.m_RootAdmin) && (m_UnionId==m_Map.m_UnionId) && (m_ShowUserId!=union.m_RootAdmin)) {
			m_Map.m_FormMenu.Add(Common.Txt.FormUnionChangeAdmin,ChangeAdmin);
		} 

		while(((m_Map.m_UnionAccess & Union.AccessExclusion) || (union.m_RootAdmin==Server.Self.m_UserId)) && (m_UnionId==m_Map.m_UnionId)) {
			if(m_ShowUserId==union.m_RootAdmin) break;
			m_Map.m_FormMenu.Add(Common.Txt.FormUnionExclusion,ActionExclusion);
			break;
		}

		var cx:int=m_UserOptions.x+x;
		var cy:int=m_UserOptions.y+y;

		m_Map.m_FormMenu.Show(cx,cy,cx+1,cy+m_UserOptions.height);
	}
	
	private function ChangeRank(obj:Object, d:int):void
	{
		Server.Self.Query("emunionrank","&val="+d.toString()+"&id="+m_ShowUserId.toString(),AccessRecv,false);
	}

	private function ChangeAdmin(obj:Object, d:int):void
	{
		FormMessageBox.Run(Common.Txt.FormUnionChangeAdminQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ChangeAdminOk);
	}
	
	private function ChangeAdminOk():void
	{
		if (m_ShowUserId == 0) return;
		Server.Self.Query("emunionrank","&val=-1&id="+m_ShowUserId.toString(),AccessRecv,false);
	}

	public function ActionExclusion(...args):void
	{
		Server.Self.Query("emunionleave","&id="+m_ShowUserId.toString(),StdRecv,false);
		UserHide();
	}

	public function PageNamesHide():void
	{
		var i:int;

		for(i=0;i<m_NamesList.length;i++) {
			var obj:DisplayObject=m_NamesList[i];
			removeChild(obj);
		}
		m_NamesList.length=0;

		if(m_NamesLang!=null) { removeChild(m_NamesLang); m_NamesLang=null; }		
		if(m_NamesEng!=null) { removeChild(m_NamesEng); m_NamesEng=null; }
		if(m_NamesSave!=null) { removeChild(m_NamesSave); m_NamesSave=null; }
	}

	public function PageNamesUpdate():void
	{
		var i:int;
		var lb:TextField;
		var ti:TextInput;
		
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);
		
		if(m_NamesLang==null) {
			m_NamesLang=new TextField();
			addChild(m_NamesLang);

			m_NamesLang.x=295;
			m_NamesLang.y=120;
			m_NamesLang.width=1;
			m_NamesLang.height=1;
			m_NamesLang.type=TextFieldType.DYNAMIC;
			m_NamesLang.selectable=false;
			m_NamesLang.border=false;
			m_NamesLang.background=false;
			m_NamesLang.multiline=false;
			m_NamesLang.autoSize=TextFieldAutoSize.LEFT;
			m_NamesLang.antiAliasType=AntiAliasType.ADVANCED;
			m_NamesLang.gridFitType=GridFitType.PIXEL;
			m_NamesLang.defaultTextFormat=tf;
			m_NamesLang.embedFonts=true;
			m_NamesLang.text=Common.Txt.FormUnionNameCapLang+":";
		}

		if(m_NamesEng==null) {
			m_NamesEng=new TextField();
			addChild(m_NamesEng);

			m_NamesEng.x=390;
			m_NamesEng.y=120;
			m_NamesEng.width=1;
			m_NamesEng.height=1;
			m_NamesEng.type=TextFieldType.DYNAMIC;
			m_NamesEng.selectable=false;
			m_NamesEng.border=false;
			m_NamesEng.background=false;
			m_NamesEng.multiline=false;
			m_NamesEng.autoSize=TextFieldAutoSize.LEFT;
			m_NamesEng.antiAliasType=AntiAliasType.ADVANCED;
			m_NamesEng.gridFitType=GridFitType.PIXEL;
			m_NamesEng.defaultTextFormat=tf;
			m_NamesEng.embedFonts=true;
			m_NamesEng.text=Common.Txt.FormUnionNameCapEng+":";
		}
		
		if(m_NamesSave==null) {
			if(m_NamesSave==null) {
				m_NamesSave=new Button();
				addChild(m_NamesSave);
			}
			m_NamesSave.label = Common.Txt.ButSave;
			m_NamesSave.width=100;
			m_NamesSave.x=380;
			m_NamesSave.y=145+8*25+5;
			Common.UIStdBut(m_NamesSave);
			m_NamesSave.addEventListener(MouseEvent.CLICK, clickNamesSave);
		}

		if(m_NamesList.length<=0) {
			for(i=0;i<8;i++) {
				lb=new TextField();
				addChild(lb);
				lb.x=200;
				lb.y=145+i*25;
				lb.type=TextFieldType.DYNAMIC;
				lb.selectable=false;
				lb.border=false;
				lb.background=false;
				lb.multiline=false;
				lb.autoSize=TextFieldAutoSize.LEFT;
				lb.antiAliasType=AntiAliasType.ADVANCED;
				lb.gridFitType=GridFitType.PIXEL;
				lb.defaultTextFormat=tf;
				lb.embedFonts=true;
				if(i==0) lb.text=Common.Txt.FormUnionNameUnion+":";
				else if(i==1) lb.text=Common.Txt.FormUnionNameRank+":";
				else if(i==2) lb.text=Common.Txt.FormUnionNameAdmin+":";
				else if(i==3) lb.text=Common.Txt.FormUnionNameRank0+":";
				else if(i==4) lb.text=Common.Txt.FormUnionNameRank1+":";
				else if(i==5) lb.text=Common.Txt.FormUnionNameRank2+":";
				else if(i==6) lb.text=Common.Txt.FormUnionNameRank3+":";
				else if(i==7) lb.text=Common.Txt.FormUnionNameRank4+":";
				m_NamesList.push(lb);

				ti=new TextInput();
				addChild(ti);
				Common.UIStdInput(ti);
				ti.x=295;
				ti.y=145+i*25;
				ti.width=90;
				ti.textField.maxChars = 14;
				ti.textField.restrict = "0-9 A-Za-zА-Яа-яЁё";
				ti.text=union.GetDesc(0+i*2);
				m_NamesList.push(ti);

				ti=new TextInput();
				addChild(ti);
				Common.UIStdInput(ti);
				ti.x=390;
				ti.y=145+i*25;
				ti.width=90;
				ti.textField.maxChars=14;
				ti.textField.restrict = "0-9 A-Za-z";
				ti.text=union.GetDesc(1+i*2);
				m_NamesList.push(ti);
			}
		}
	}

	private function clickNamesSave(e:Event):void
	{
		var i:int;
		var str:String="";

		for(i=0;i<8;i++) {
			if(i!=0) str+="~";
			str+=m_NamesList[i*3+1].text+"~"+m_NamesList[i*3+2].text;
		}

		//trace(str);

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;
//		union.m_RankDesc=str;

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"data\"\r\n\r\n";
        d+=str+"\r\n"
        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emunionchange","&val=8",d,boundary,DescRecv);

		//PageNamesUpdate();
	}

	private function clickLeave(event:MouseEvent):void
	{
		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if (union == null) return;
		
		var leaveaccess:Boolean = true;
		while (union.m_RootAdmin == Server.Self.m_UserId && m_Map.m_UnionId == m_UnionId) {
			var da:ByteArray=UserList.Self.GetUnionMember(m_UnionId);
			if (da == null) { leaveaccess = false; break; }
			var sl:SaveLoad=new SaveLoad();
			da.position=0;
			sl.LoadBegin(da);
			while(true) {
				var id:uint=sl.LoadDword();
				if(id==0) break;
				var rank:int=sl.LoadInt();
				var access:uint = sl.LoadDword();
				
				if (Server.Self.m_UserId != id) { leaveaccess = false; break; }
			}
			sl.LoadEnd();
			break;
		}
		
		if (!leaveaccess) {
			FormMessageBox.Run(Common.Txt.FormUnionLeaveNoAdmin,Common.Txt.ButClose);
		} else {
			FormMessageBox.Run(Common.Txt.FormUnionLeaveQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,ActionLeave);
		}
	}

	private function ActionLeave():void
	{
		Server.Self.Query("emunionleave","&id="+Server.Self.m_UserId.toString(),StdRecv,false);
		Hide();
	}

	public function PageBonusHide():void
	{
		if(m_BonusVal!=null) { removeChild(m_BonusVal); m_BonusVal=null; }
	}

	public function PageBonusUpdate():void
	{
		var i:int;

		//var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);
		var tfv:TextFormat = new TextFormat("Calibri",13,0xffffff);

		var union:Union=UserList.Self.GetUnion(m_UnionId);
		if(union==null) return;

		var txt:String = "";

		var pcg:int = Math.floor(union.m_BonusCotlCnt / m_Map.m_GalaxyAllCotlCnt * 100);

		txt = Common.Txt.FormUnionCotlCnt;
		txt = BaseStr.Replace(txt, "<Val>", union.m_BonusCotlCnt.toString());
		txt = BaseStr.Replace(txt, "<Proc>", Math.floor(pcg).toString());
		txt += "[br][br]";

		if (pcg > 40) {
			var fsp:int = (pcg - 40) * 2;
			if (fsp > 90) fsp = 90;
			txt += Common.Txt.FlagshipPowerDec + ": [crt]-" + fsp.toString() + "%[/crt][br][br]";
		}

		for(i=0;i<Common.CotlBonusCnt;i++) {
			if (union.m_Bonus[i] == 0) continue;
			var v:int = Common.CotlBonusValEx(i,union.m_Bonus[i]);
			if (v == 0) return;

			txt += Common.CotlBonusName[i];
			if (i == Common.CotlBonusShipyardSupply || i == Common.CotlBonusSciBaseSupply) txt += ": -";
			else txt += ": +";

			if(Common.CotlBonusProc[i]) txt+="[clr]"+Math.round(v*100/256).toString()+"%[/clr]\n";
			else txt+="[clr]"+v.toString()+"[/clr]\n";
		}
		
		var sx:int=200;
		var sy:int=120;
		var wx:int=width-sx-20;

		if(m_BonusVal==null) {
			m_BonusVal=new TextField();
			addChild(m_BonusVal);
		}
		m_BonusVal.x=sx;
		m_BonusVal.y=sy;
		m_BonusVal.width=wx;
		m_BonusVal.height=height-sy-50;
		m_BonusVal.type=TextFieldType.DYNAMIC;
		m_BonusVal.selectable=false;
		m_BonusVal.border=false;
		m_BonusVal.background=false;
		m_BonusVal.multiline=true;
		m_BonusVal.wordWrap=true; 
		m_BonusVal.autoSize=TextFieldAutoSize.NONE;
		m_BonusVal.antiAliasType=AntiAliasType.ADVANCED;
		m_BonusVal.gridFitType=GridFitType.PIXEL;
		m_BonusVal.defaultTextFormat=tfv;
		m_BonusVal.embedFonts=true;
		m_BonusVal.htmlText=BaseStr.FormatTag(txt);
		sy+=Math.max(20,m_BonusVal.height)+5;
	}
}

}

import Empire.*;
import fl.controls.listClasses.CellRenderer;
import fl.events.ComponentEvent;
import flash.text.*;

class MemberListRenderer extends CellRenderer
{
    public function MemberListRenderer() {
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
		
		addEventListener(ComponentEvent.LABEL_CHANGE, labelChangeHandler);
    }
		
	private function labelChangeHandler(event:ComponentEvent):void
	{
		if(FormChat.Self.UserIsOnline(data.User)) {
			setStyle("textFormat",new TextFormat("Calibri",14,0xffffff));
		} else {
			setStyle("textFormat",new TextFormat("Calibri",14,0x808080));
		}
//trace(data);
//trace(textField.text);
//		textField.htmlText="<font color='#ff0000'>"+textField.text+"</font>";
	}
}
