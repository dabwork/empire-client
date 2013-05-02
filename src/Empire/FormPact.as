// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

public class FormPact extends FormPactClass
{
	private var m_Map:EmpireMap;

	static public const ModePreset:int=0;
	static public const ModeView:int=1;
	static public const ModeQuery:int=2;

	public var m_Mode:int=ModePreset;

	public var m_UserId:uint=0;
	
	public function FormPact(map:EmpireMap)
	{
		m_Map=map;

		Common.UIStdBut(ButYes);
		Common.UIStdBut(ButClose);
		Common.UIStdBut(ButBreak);

		Common.UIStdLabel(Caption,18);
		Common.UIStdLabel(YouCaption);
		Common.UIStdLabel(OtherCaption);

		Common.UIStdLabel(YouPassText);
		Common.UIStdLabel(OtherPassText);
		Common.UIStdLabel(YouNoFlyText);
		Common.UIStdLabel(OtherNoFlyText);
		Common.UIStdLabel(YouNoBattleText);
		Common.UIStdLabel(OtherNoBattleText);
		//Common.UIStdLabel(YouPayText);
		//Common.UIStdLabel(OtherPayText);
		//Common.UIStdLabel(YouPayAntimatterText);
		//Common.UIStdLabel(YouPayMetalText);
		//Common.UIStdLabel(YouPayElectronicsText);
		//Common.UIStdLabel(YouPayProtoplasmText);
		//Common.UIStdLabel(YouPayNodesText);
		//Common.UIStdLabel(OtherPayAntimatterText);
		//Common.UIStdLabel(OtherPayMetalText);
		//Common.UIStdLabel(OtherPayElectronicsText);
		//Common.UIStdLabel(OtherPayProtoplasmText);
		//Common.UIStdLabel(OtherPayNodesText);
		Common.UIStdLabel(YouProtectText);
		Common.UIStdLabel(OtherProtectText);
		Common.UIStdLabel(YouControlText);
		Common.UIStdLabel(OtherControlText);
		Common.UIStdLabel(YouBuildText);
		Common.UIStdLabel(OtherBuildText);
		Common.UIStdLabel(LabelPeriod);
		Common.UIStdLabel(LabelHour);

		Common.UIStdLabel(EditPeriodVal);

		//Common.UIStdLabel(YouPayAntimatterVal,13,0xffff00);
		//Common.UIStdLabel(YouPayMetalVal,13,0xffff00);
		//Common.UIStdLabel(YouPayElectronicsVal,13,0xffff00);
		//Common.UIStdLabel(YouPayProtoplasmVal,13,0xffff00);
		//Common.UIStdLabel(YouPayNodesVal,13,0xffff00);

		//Common.UIStdLabel(OtherPayAntimatterVal,13,0xffff00);
		//Common.UIStdLabel(OtherPayMetalVal,13,0xffff00);
		//Common.UIStdLabel(OtherPayElectronicsVal,13,0xffff00);
		//Common.UIStdLabel(OtherPayProtoplasmVal,13,0xffff00);
		//Common.UIStdLabel(OtherPayNodesVal,13,0xffff00);

		//Common.UIStdComboBox(YouPayAntimatterList);
		//Common.UIStdComboBox(YouPayMetalList);
		//Common.UIStdComboBox(YouPayElectronicsList);
		//Common.UIStdComboBox(YouPayProtoplasmList);
		//Common.UIStdComboBox(YouPayNodesList);

		//Common.UIStdComboBox(OtherPayAntimatterList);
		//Common.UIStdComboBox(OtherPayMetalList);
		//Common.UIStdComboBox(OtherPayElectronicsList);
		//Common.UIStdComboBox(OtherPayProtoplasmList);
		//Common.UIStdComboBox(OtherPayNodesList);
		
		CheckStyle(YouPassCheck);
		CheckStyle(OtherPassCheck);
		CheckStyle(YouNoFlyCheck);
		CheckStyle(OtherNoFlyCheck);
		CheckStyle(YouNoBattleCheck);
		CheckStyle(OtherNoBattleCheck);

		CheckStyle(YouProtectCheck);
		CheckStyle(OtherProtectCheck);
		CheckStyle(YouControlCheck);
		CheckStyle(OtherControlCheck);
		CheckStyle(YouBuildCheck);
		CheckStyle(OtherBuildCheck);

		Common.UIStdInput(EditPeriod);

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

		ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		ButYes.addEventListener(MouseEvent.CLICK, clickYes);
		ButBreak.addEventListener(MouseEvent.CLICK, clickBreak);
		
		YouNoBattleCheck.addEventListener(Event.CHANGE, onYouNoBattleClick);
		OtherNoBattleCheck.addEventListener(Event.CHANGE, onOtherNoBattleClick);
	}

	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) Show(m_Mode);
		x = Math.ceil(m_Map.stage.stageWidth / 2 - width / 2);
		y = Math.ceil(m_Map.stage.stageHeight / 2 - height / 2);
	}

	public function onYouNoBattleClick(e:Event):void { OtherNoBattleCheck.selected = YouNoBattleCheck.selected; }
	public function onOtherNoBattleClick(e:Event):void { YouNoBattleCheck.selected = OtherNoBattleCheck.selected; }

	public function CBP(cb:ComboBox):void
	{
		cb.removeAll();
		cb.rowCount=20;
		cb.addItem( { label:"0%", data:0 } );
		cb.addItem( { label:"5%", data:1 } );
		cb.addItem( { label:"10%", data:2 } );
		cb.addItem( { label:"15%", data:3 } );
		cb.addItem( { label:"20%", data:4 } );
		cb.addItem( { label:"25%", data:5 } );
		cb.addItem( { label:"30%", data:6 } );
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

	protected function onMouseWheel(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	protected function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		m_Map.m_Info.Hide();
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		if(ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(ButYes.hitTestPoint(e.stageX,e.stageY)) return;
		if(EditPeriod.hitTestPoint(e.stageX,e.stageY)) return;
		
		//if(YouPayAntimatterList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(YouPayMetalList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(YouPayElectronicsList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(YouPayProtoplasmList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(YouPayNodesList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(OtherPayAntimatterList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(OtherPayMetalList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(OtherPayElectronicsList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(OtherPayProtoplasmList.hitTestPoint(e.stageX,e.stageY)) return;
		//if(OtherPayNodesList.hitTestPoint(e.stageX,e.stageY)) return;

		startDrag();
		m_Map.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		m_Map.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	private function clickClose(event:MouseEvent):void
	{
		Hide();
		
//		m_Map.m_FormPactList.DeleteQuery(m_UserId);
//		m_Map.SendAction("empact","3_"+m_UserId.toString()+"_0_0_0");
		
		//m_Map.m_FormPactList.CallPactQuery();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		return mouseX>=0 && mouseX<width && mouseY>=0 && mouseY<height;
	}

	public function Show(mode:int):void
	{
		var i:int;
		var str:String;
		var obj:Object;
		visible=true;

		StageResize();

		m_Mode=mode;
		
		//CBP(YouPayAntimatterList);
		//CBP(YouPayMetalList);
		//CBP(YouPayElectronicsList);
		//CBP(YouPayProtoplasmList);
		//CBP(YouPayNodesList);

		//CBP(OtherPayAntimatterList);
		//CBP(OtherPayMetalList);
		//CBP(OtherPayElectronicsList);
		//CBP(OtherPayProtoplasmList);
		//CBP(OtherPayNodesList);

		if(m_Mode==ModeQuery) str=Common.Txt.PactCaptionQuery;
		else str=Common.Txt.PactCaption;
		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		//if (user != null) str = str.replace(/<You>/g, user.m_Name);
		str = BaseStr.Replace(str, "<You>", EmpireMap.Self.Txt_CotlOwnerName(0, Server.Self.m_UserId));
		user=UserList.Self.GetUser(m_UserId);
		//if(user!=null) str=str.replace(/<User>/g,user.m_Name);
		str = BaseStr.Replace(str, "<User>", EmpireMap.Self.Txt_CotlOwnerName(0, m_UserId));

		Caption.htmlText=str;
		YouCaption.text=Common.Txt.PactYouCaption+":";
		OtherCaption.text=Common.Txt.PactOtherCaption+":";

		YouPassText.text=Common.Txt.PactYouPass;
		OtherPassText.text=Common.Txt.PactOtherPass;
		YouNoFlyText.text=Common.Txt.PactYouNoFly;
		OtherNoFlyText.text=Common.Txt.PactOtherNoFly;
		YouNoBattleText.text=Common.Txt.PactYouNoBattle;
		OtherNoBattleText.text=Common.Txt.PactOtherNoBattle;
		//YouPayText.text=Common.Txt.PactYouPay+":";
		//OtherPayText.text=Common.Txt.PactOtherPay+":";

		//YouPayAntimatterText.htmlText="<p align='right'>"+Common.Txt.PactAntimatter+":</p>";
		//YouPayMetalText.htmlText="<p align='right'>"+Common.Txt.PactMetal+":</p>";
		//YouPayElectronicsText.htmlText="<p align='right'>"+Common.Txt.PactElectronics+":</p>";
		//YouPayProtoplasmText.htmlText="<p align='right'>"+Common.Txt.PactProtoplasm+":</p>";
		//YouPayNodesText.htmlText="<p align='right'>"+Common.Txt.PactNodes+":</p>";

		//OtherPayAntimatterText.htmlText="<p align='right'>"+Common.Txt.PactAntimatter+":</p>";
		//OtherPayMetalText.htmlText="<p align='right'>"+Common.Txt.PactMetal+":</p>";
		//OtherPayElectronicsText.htmlText="<p align='right'>"+Common.Txt.PactElectronics+":</p>";
		//OtherPayProtoplasmText.htmlText="<p align='right'>"+Common.Txt.PactProtoplasm+":</p>";
		//OtherPayNodesText.htmlText="<p align='right'>"+Common.Txt.PactNodes+":</p>";

		YouProtectText.text=Common.Txt.PactYouProtect;
		OtherProtectText.text=Common.Txt.PactOtherProtect;
		YouControlText.text=Common.Txt.PactYouControl;
		OtherControlText.text=Common.Txt.PactOtherControl;
		YouBuildText.text=Common.Txt.PactYouBuild;
		OtherBuildText.text=Common.Txt.PactOtherBuild;

		LabelPeriod.htmlText="<p align='right'>"+Common.Txt.PactPeriod+":</p>";
		LabelHour.text=Common.Txt.PactHour;

		if(m_Mode==ModeQuery) {
//			ButClose.label=Common.Txt.PactReject;
			ButBreak.label=Common.Txt.PactReject;
			ButYes.label=Common.Txt.PactAccept;
		} else {
			ButBreak.label=Common.Txt.PactBreak;
			ButYes.label=Common.Txt.PactOffer;
		}
		ButClose.label=Common.Txt.ButClose;
		
		EditPeriod.restrict = "0-9";
		EditPeriod.textField.maxChars = 3;
		EditPeriod.text="10";

		ButBreak.visible=(m_Mode==ModeView) || (m_Mode==ModeQuery);

		YouPassCheck.enabled=m_Mode!=ModeQuery;
		OtherPassCheck.enabled=m_Mode!=ModeQuery;
		YouNoFlyCheck.enabled=m_Mode!=ModeQuery;
		OtherNoFlyCheck.enabled=m_Mode!=ModeQuery;
		YouNoBattleCheck.enabled=m_Mode!=ModeQuery;
		OtherNoBattleCheck.enabled=m_Mode!=ModeQuery;

		//YouPayAntimatterList.visible=m_Mode!=ModeQuery; YouPayAntimatterVal.visible=m_Mode==ModeQuery;
		//YouPayMetalList.visible=m_Mode!=ModeQuery; YouPayMetalVal.visible=m_Mode==ModeQuery;
		//YouPayElectronicsList.visible=m_Mode!=ModeQuery; YouPayElectronicsVal.visible=m_Mode==ModeQuery;
		//YouPayProtoplasmList.visible=m_Mode!=ModeQuery; YouPayProtoplasmVal.visible=m_Mode==ModeQuery;
		//YouPayNodesList.visible=m_Mode!=ModeQuery; YouPayNodesVal.visible=m_Mode==ModeQuery;

		//OtherPayAntimatterList.visible=m_Mode!=ModeQuery; OtherPayAntimatterVal.visible=m_Mode==ModeQuery;
		//OtherPayMetalList.visible=m_Mode!=ModeQuery; OtherPayMetalVal.visible=m_Mode==ModeQuery;
		//OtherPayElectronicsList.visible=m_Mode!=ModeQuery; OtherPayElectronicsVal.visible=m_Mode==ModeQuery;
		//OtherPayProtoplasmList.visible=m_Mode!=ModeQuery; OtherPayProtoplasmVal.visible=m_Mode==ModeQuery;
		//OtherPayNodesList.visible=m_Mode!=ModeQuery; OtherPayNodesVal.visible=m_Mode==ModeQuery;

		YouProtectCheck.enabled=m_Mode!=ModeQuery;
		OtherProtectCheck.enabled=m_Mode!=ModeQuery;
		YouControlCheck.enabled=m_Mode!=ModeQuery;
		OtherControlCheck.enabled=m_Mode!=ModeQuery;
		YouBuildCheck.enabled=m_Mode!=ModeQuery;
		OtherBuildCheck.enabled=m_Mode!=ModeQuery;

		EditPeriod.visible=m_Mode!=ModeQuery; EditPeriodVal.visible=m_Mode==ModeQuery;
		LabelHour.visible=m_Mode!=ModeQuery;

		YouPassCheck.selected=false;
		OtherPassCheck.selected=false;
		YouNoFlyCheck.selected=false;
		OtherNoFlyCheck.selected=false;
		YouNoBattleCheck.selected=false;
		OtherNoBattleCheck.selected=false;

		//YouPayAntimatterList.selectedIndex=0;
		//OtherPayAntimatterList.selectedIndex=0;

		//YouPayMetalList.selectedIndex=0;
		//OtherPayMetalList.selectedIndex=0;

		//YouPayElectronicsList.selectedIndex=0;
		//OtherPayElectronicsList.selectedIndex=0;

		//YouPayProtoplasmList.selectedIndex=0;
		//OtherPayProtoplasmList.selectedIndex=0;

		//YouPayNodesList.selectedIndex=0;
		//OtherPayNodesList.selectedIndex=0;

		YouProtectCheck.selected=false;
		OtherProtectCheck.selected=false;
		YouControlCheck.selected=false;
		OtherControlCheck.selected=false;
		YouBuildCheck.selected=false;
		OtherBuildCheck.selected=false;
		
		i=m_Map.m_FormPactList.PactFindByMode(m_UserId,m_Mode);

/*		for(i=0;i<m_Map.m_FormPactList.m_List.length;i++) {
			obj=m_Map.m_FormPactList.m_List[i];
			if((obj.User1==Server.Self.m_UserId && obj.User2==m_UserId) ||
				(obj.User2==Server.Self.m_UserId && obj.User1==m_UserId)) 
			{
				if(m_Mode==ModeQuery && (obj.Period<=0 || obj.User2!=Server.Self.m_UserId)) continue;
				if(m_Mode!=ModeQuery && obj.Period>0) continue;*/
		while(i>=0) {
				obj=m_Map.m_FormPactList.m_List[i];

				var flag1:uint=obj.Flag1;
				var flag2:uint=obj.Flag2;

				if(obj.User2==Server.Self.m_UserId) {
					flag1=obj.Flag2;
					flag2=obj.Flag1;
				}

				if(flag1 & Common.PactPass) YouPassCheck.selected=true;
				if(flag2 & Common.PactPass) OtherPassCheck.selected=true;
				if(flag1 & Common.PactNoFly) YouNoFlyCheck.selected=true;
				if(flag2 & Common.PactNoFly) OtherNoFlyCheck.selected=true;
				if(flag1 & Common.PactNoBattle) YouNoBattleCheck.selected=true;
				if(flag2 & Common.PactNoBattle) OtherNoBattleCheck.selected=true;
				
				//YouPayAntimatterVal.text=((Common.PactPercent[(flag1>>(16))&7]*100)>>8).toString()+"%";
				//YouPayMetalVal.text=((Common.PactPercent[(flag1>>(16+3))&7]*100)>>8).toString()+"%";
				//YouPayElectronicsVal.text=((Common.PactPercent[(flag1>>(16+6))&7]*100)>>8).toString()+"%";
				//YouPayProtoplasmVal.text=((Common.PactPercent[(flag1>>(16+9))&7]*100)>>8).toString()+"%";
				//YouPayNodesVal.text=((Common.PactPercent[(flag1>>(16+12))&7]*100)>>8).toString()+"%";

				//OtherPayAntimatterVal.text=((Common.PactPercent[(flag2>>(16))&7]*100)>>8).toString()+"%";
				//OtherPayMetalVal.text=((Common.PactPercent[(flag2>>(16+3))&7]*100)>>8).toString()+"%";
				//OtherPayElectronicsVal.text=((Common.PactPercent[(flag2>>(16+6))&7]*100)>>8).toString()+"%";
				//OtherPayProtoplasmVal.text=((Common.PactPercent[(flag2>>(16+9))&7]*100)>>8).toString()+"%";
				//OtherPayNodesVal.text=((Common.PactPercent[(flag2>>(16+12))&7]*100)>>8).toString()+"%";

				//YouPayAntimatterList.selectedIndex=(flag1>>(16))&7;
				//OtherPayAntimatterList.selectedIndex=(flag2>>(16))&7;

				//YouPayMetalList.selectedIndex=(flag1>>(16+3))&7;
				//OtherPayMetalList.selectedIndex=(flag2>>(16+3))&7;

				//YouPayElectronicsList.selectedIndex=(flag1>>(16+6))&7;
				//OtherPayElectronicsList.selectedIndex=(flag2>>(16+6))&7;

				//YouPayProtoplasmList.selectedIndex=(flag1>>(16+9))&7;
				//OtherPayProtoplasmList.selectedIndex=(flag2>>(16+9))&7;

				//YouPayNodesList.selectedIndex=(flag1>>(16+12))&7;
				//OtherPayNodesList.selectedIndex=(flag2>>(16+12))&7;
				
				if(flag1 & Common.PactProtect) YouProtectCheck.selected=true;
				if(flag2 & Common.PactProtect) OtherProtectCheck.selected=true;

				if(flag1 & Common.PactControl) YouControlCheck.selected=true;
				if(flag2 & Common.PactControl) OtherControlCheck.selected=true;
		
				if(flag1 & Common.PactBuild) YouBuildCheck.selected=true;
				if(flag2 & Common.PactBuild) OtherBuildCheck.selected=true;

				if(obj.Period>0) {
					EditPeriod.text=obj.Period.toString();
					EditPeriodVal.htmlText="<font color='#ffff00'>"+obj.Period.toString()+"</font> "+Common.Txt.PactHour;
				} else {
					var p:int = Math.ceil((obj.DateEnd - m_Map.GetServerGlobalTime()) / (24 * 60 * 60 * 1000));
					if(p<1) p=1; 

					EditPeriod.text=p.toString();
					EditPeriodVal.htmlText="<font color='#ffff00'>"+p.toString()+"</font> "+Common.Txt.PactHour;
				}

				break;
//			}
		}

		Update();
	}
	
	public function Update():void
	{
	}
	
	private function clickYes(event:MouseEvent):void
	{
		var flag1:uint=0;
		var flag2:uint=0;
		
		if(YouPassCheck.selected) flag1|=Common.PactPass;
		if(OtherPassCheck.selected) flag2|=Common.PactPass;
		if(YouNoFlyCheck.selected) flag1|=Common.PactNoFly;
		if(OtherNoFlyCheck.selected) flag2|=Common.PactNoFly;
		if(YouNoBattleCheck.selected) flag1|=Common.PactNoBattle;
		if(OtherNoBattleCheck.selected) flag2|=Common.PactNoBattle;

		//if(YouPayAntimatterList.selectedItem.data!=0) flag1|=YouPayAntimatterList.selectedItem.data<<16;
		//if(OtherPayAntimatterList.selectedItem.data!=0) flag2|=OtherPayAntimatterList.selectedItem.data<<16;

		//if(YouPayMetalList.selectedItem.data!=0) flag1|=YouPayMetalList.selectedItem.data<<(16+3);
		//if(OtherPayMetalList.selectedItem.data!=0) flag2|=OtherPayMetalList.selectedItem.data<<(16+3);

		//if(YouPayElectronicsList.selectedItem.data!=0) flag1|=YouPayElectronicsList.selectedItem.data<<(16+6);
		//if(OtherPayElectronicsList.selectedItem.data!=0) flag2|=OtherPayElectronicsList.selectedItem.data<<(16+6);

		//if(YouPayProtoplasmList.selectedItem.data!=0) flag1|=YouPayProtoplasmList.selectedItem.data<<(16+9);
		//if(OtherPayProtoplasmList.selectedItem.data!=0) flag2|=OtherPayProtoplasmList.selectedItem.data<<(16+9);

		//if(YouPayNodesList.selectedItem.data!=0) flag1|=YouPayNodesList.selectedItem.data<<(16+12);
		//if(OtherPayNodesList.selectedItem.data!=0) flag2|=OtherPayNodesList.selectedItem.data<<(16+12);
		
		if(YouProtectCheck.selected) flag1|=Common.PactProtect;
		if(OtherProtectCheck.selected) flag2|=Common.PactProtect;

		if(YouControlCheck.selected) flag1|=Common.PactControl;
		if(OtherControlCheck.selected) flag2|=Common.PactControl;
		
		if(YouBuildCheck.selected) flag1|=Common.PactBuild;
		if(OtherBuildCheck.selected) flag2|=Common.PactBuild;

		if(m_Mode==ModeQuery) {
			m_Map.m_FormPactList.DeleteQuery(m_UserId);
			m_Map.SendAction("empact","2_"+m_UserId.toString()+"_"+flag2.toString(16)+"_"+flag1.toString(16)+"_"+int(EditPeriod.text).toString());
		} else {
			m_Map.SendAction("empact","1_"+m_UserId.toString()+"_"+flag1.toString(16)+"_"+flag2.toString(16)+"_"+int(EditPeriod.text).toString());
		}

		Hide();
		//m_Map.m_FormPactList.CallPactQuery();
	}

	private function clickBreak(event:MouseEvent):void
	{
		if(m_Mode==ModeQuery) {
			m_Map.m_FormPactList.DeleteQuery(m_UserId);
			m_Map.SendAction("empact", "3_" + m_UserId.toString() + "_0_0_0");

		} else {
			m_Map.SendAction("empact", "4_" + m_UserId.toString() + "_0_0_0");
		}
		
		Hide();
		//m_Map.m_FormPactList.CallPactQuery();
	}

	public function HideIfCancelQuery():void
	{
		if(!visible) return;
		if(m_Mode!=ModeQuery) return;
		
		var i:int;
		var obj:Object;

		for(i=0;i<m_Map.m_FormPactList.m_List.length;i++) {
			obj=m_Map.m_FormPactList.m_List[i];
			if((obj.User2==Server.Self.m_UserId && obj.User1==m_UserId && obj.Period>0)) {
				break;
			}
		}
		if(i>=m_Map.m_FormPactList.m_List.length) Hide();
	}
}

}
