// Copyright (C) 2013 Elemental Games. All rights reserved.

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

public class FormSplit extends FormSplitClass
{
	private var m_Map:EmpireMap;

	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_ShipNum:int;
	public var m_ToNum:int;

	public var m_CntFrom:int;
	public var m_CntTo:int;
	
	public var m_FromSlot:int=-1;
	public var m_ToSlot:int=-1;
	
	public function FormSplit(map:EmpireMap)
	{
		m_Map=map;

		ButCancel.addEventListener(MouseEvent.CLICK, clickCancel);
		ButSplit.addEventListener(MouseEvent.CLICK, clickSplit);
		
		EditCnt.addEventListener(ComponentEvent.ENTER, clickSplit);
		EditCnt.addEventListener(Event.CHANGE,CntChange);
		
		ItemCnt.addEventListener(ComponentEvent.ENTER, clickSplit);
		
		BarCnt.addEventListener(Event.CHANGE,BarChange);
	}

	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) {
		x = Math.ceil(m_Map.stage.stageWidth / 2 - width / 2);
		y = Math.ceil(m_Map.stage.stageHeight / 2 - height / 2);
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		if(ButSplit.hitTestPoint(e.stageX,e.stageY)) return;
		if(ButCancel.hitTestPoint(e.stageX,e.stageY)) return;
		if(EditCnt.hitTestPoint(e.stageX,e.stageY)) return;
		if(BarCnt.hitTestPoint(e.stageX,e.stageY)) return;
		if(ItemCnt.visible && ItemCnt.hitTestPoint(e.stageX,e.stageY)) return;
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	protected function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}
	
	public function ItfInit():void
	{
		if (visible) return;

		visible=true;

		x=Math.ceil(m_Map.stage.stageWidth/2-width/2);
		y=Math.ceil(m_Map.stage.stageHeight/2-height/2);

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);
		
		LabelCaption.setStyle("textFormat", tf);
		LabelCaption.setStyle("embedFonts", true);
		LabelCaption.textField.antiAliasType=AntiAliasType.ADVANCED;
		LabelCaption.textField.gridFitType=GridFitType.PIXEL;

		LabelCnt.setStyle("textFormat", tf);
		LabelCnt.setStyle("embedFonts", true);
		LabelCnt.textField.antiAliasType=AntiAliasType.ADVANCED;
		LabelCnt.textField.gridFitType=GridFitType.PIXEL;
		
		ButSplit.setStyle("textFormat", tf);
		ButSplit.setStyle("embedFonts", true);
		ButSplit.textField.antiAliasType=AntiAliasType.ADVANCED;
		ButSplit.textField.gridFitType=GridFitType.PIXEL;

		ButCancel.setStyle("textFormat", tf);
		ButCancel.setStyle("embedFonts", true);
		ButCancel.textField.antiAliasType=AntiAliasType.ADVANCED;
		ButCancel.textField.gridFitType=GridFitType.PIXEL;

		EditCnt.setStyle("textFormat", tf);
		EditCnt.setStyle("embedFonts", true);
		EditCnt.textField.antiAliasType=AntiAliasType.ADVANCED;
		EditCnt.textField.gridFitType=GridFitType.PIXEL;
		
		Common.UIStdLabel(LabelItem);
		Common.UIStdInput(ItemCnt);
		
		Common.UICheck(CheckModule);
		CheckModule.label=Common.Txt.Module;

		LabelCnt.text=Common.Txt.Count+":";

		ButSplit.label=Common.Txt.Split;
		ButCancel.label=Common.Txt.Cancel;

		ItemCnt.restrict = "0-9";
		ItemCnt.textField.maxChars = 8;

		EditCnt.restrict = "0-9";
		EditCnt.textField.maxChars = 8;

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown,true,999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove,true,999);
	}

	public function Run(secx:int,secy:int,planetnum:int,shipnum:int,tonum:int):void
	{
		var i:int;
		var idesc:Item;

		m_SectorX=secx;
		m_SectorY=secy;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_ToNum=tonum;
		
		m_FromSlot=-1;
		m_ToSlot=-1;

		if(shipnum==tonum) return;

		var fromship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
		if(!fromship) return;
		if(fromship.m_Type==Common.ShipTypeNone) return;

		var toship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ToNum);
		if (!toship) return;
		
		var onitem:Boolean = true;
		if (fromship.m_ItemType) {
			idesc = UserList.Self.GetItem(fromship.m_ItemType);
			if (!idesc || idesc.IsEq()) onitem = false;
		}
		if (toship.m_ItemType) {
			idesc = UserList.Self.GetItem(toship.m_ItemType);
			if (!idesc || idesc.IsEq()) onitem = false;
		}
		
		ItfInit();
		
		var cnt:int=0;
		var itcnt:int=0;
		
		if(toship.m_Type!=Common.ShipTypeNone) cnt=toship.m_Cnt;
		else {
			cnt=fromship.m_Cnt>>1;
			if(fromship.m_ItemType!=Common.ItemTypeNone) itcnt=fromship.m_ItemCnt>>1;
		}
		
		m_CntFrom=0;
		m_CntTo=0;

		LabelCaption.text=Common.Txt.Split+": "+Common.ShipName[fromship.m_Type];

		if(toship.m_Type!=Common.ShipTypeNone && toship.m_ItemType!=Common.ItemTypeNone && fromship.m_ItemType==toship.m_ItemType) {
			itcnt=toship.m_ItemCnt;
		}

		ItemCnt.text=itcnt.toString();
		EditCnt.text=cnt.toString();
		EditCnt.setFocus();
		EditCnt.setSelection(0,EditCnt.text.length);

		if (!onitem || fromship.m_ItemType == Common.ItemTypeNone) {
			LabelItem.visible = false;
			ItemCnt.visible = false;

			ButSplit.y = 91;
			ButCancel.y = 91;
			FrameBG.height = 120;
		} else {
			LabelItem.visible = true;
			ItemCnt.visible = true;

			LabelItem.text = m_Map.ItemName(fromship.m_ItemType) + ":";

			ButSplit.y = 121;
			ButCancel.y = 121;
			FrameBG.height = 150;
		}
		CheckModule.visible = false;
		
		UpdateBar();
	}
	
	public function Hide():void
	{
		if (!visible) return;
		visible=false;
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown,true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove,true);
	}

	private function clickCancel(event:MouseEvent):void
	{
		Hide();
	}

	protected function CntChange(e:Event):void
	{
		if(e!=null) UpdateBar(); 
		
		if(!ItemCnt.visible) return;

		if(m_FromSlot>=0 && m_ToSlot<0) return FleetFromHyperspace_CntChange(e);
		if(m_FromSlot>=0) return Fleet_CntChange(e);

		var itcnt:int=0;
		while(true) {
			var fromship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
			if(!fromship) break;
			if(fromship.m_Type==Common.ShipTypeNone) break;

			var toship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ToNum);
			if(!toship) break;

			if(fromship.m_ItemType==Common.ItemTypeNone) break;
			var shipallcnt:int=fromship.m_Cnt;

			var itemallcnt:int=fromship.m_ItemCnt;
			if(toship.m_Type!=Common.ShipTypeNone) {
				shipallcnt+=toship.m_Cnt;
				if(toship.m_ItemType!=Common.ItemTypeNone && fromship.m_ItemType==toship.m_ItemType) {
					itemallcnt+=toship.m_ItemCnt;
				} else if(toship.m_ItemType!=Common.ItemTypeNone) break;
			}

			var cnt:int=int(EditCnt.text);
			if(cnt<=0) itcnt=0;
			else if(cnt>=shipallcnt) itcnt=itemallcnt;
			else itcnt=Math.round((cnt/shipallcnt)*itemallcnt);

			if(itcnt<0) itcnt=0;
			else if(itcnt>itemallcnt) itcnt=itemallcnt;

			break;
		}

		ItemCnt.text=itcnt.toString();
	} 

	public function clickSplit(event:Event=null):void
	{
		var cnt:int=int(EditCnt.text);
		var itcnt:int=int(ItemCnt.text);

		if(m_FromSlot>=0 && m_ToSlot<0) { FleetFromHyperspace_Split(cnt,itcnt,event!=null); Hide(); return; }
		if(m_FromSlot>=0) { Fleet_Split(cnt,itcnt); Hide(); return; }

		if(cnt>0) {
			var ac:Action=new Action(m_Map);
			ac.ActionSplit(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,m_ToNum,cnt,itcnt);
			m_Map.m_LogicAction.push(ac);
		}

		Hide();
	}

	public function CalcCntMax():int
	{
		if(m_FromSlot>=0 && m_ToSlot<0) return FleetFromHyperspace_CalcCntMax();
		if(m_FromSlot>=0) return Fleet_CalcCntMax(); 
		
		var fromship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
		if(!fromship) return 0;
		if(fromship.m_Type==Common.ShipTypeNone) return 0;

		var toship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ToNum);
		if(!toship) return 0;

		var shipallcnt:int=fromship.m_Cnt;
		if(toship.m_Type!=Common.ShipTypeNone) {
			shipallcnt+=toship.m_Cnt;
		}
		
		shipallcnt--;
		if(shipallcnt<0) shipallcnt=0;
		
		return shipallcnt;
	}

	public function UpdateBar():void
	{
		BarCnt.minimum=0;
		BarCnt.maximum=CalcCntMax();
		BarCnt.value=int(EditCnt.text);
	}

	protected function BarChange(e:Event):void { EditCnt.text=BarCnt.value.toString(); CntChange(null); }

	// -------------------------------------------------------------------------	
	public function Fleet_Run(fromslot:int,toslot:int):void
	{
		m_SectorX=0;
		m_SectorY=0;
		m_PlanetNum=-1;
		m_ShipNum=-1;
		m_ToNum=-1;
		
		m_FromSlot=fromslot;
		m_ToSlot=toslot;
		
		if(m_FromSlot==m_ToSlot) return;

		var src:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot];
		var des:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_ToSlot];
		
		ItfInit();

		LabelCaption.text=Common.Txt.Split+": "+Common.ShipName[src.m_Type];

		var cnt:int=src.m_Cnt;
		var itcnt:int=0;
		if(des.m_Type==src.m_Type) {
			cnt=des.m_Cnt;
			if(des.m_ItemType!=Common.ItemTypeNone && src.m_ItemType==des.m_ItemType) itcnt=des.m_ItemCnt;
		}

		ItemCnt.text=itcnt.toString();
		EditCnt.text=cnt.toString();
		EditCnt.setFocus();
		EditCnt.setSelection(0,EditCnt.text.length);

		if(src.m_ItemType==Common.ItemTypeNone) {
			LabelItem.visible=false;
			ItemCnt.visible=false;

			ButSplit.y=91;
			ButCancel.y=91;
			FrameBG.height=120;
		} else {
			LabelItem.visible=true;
			ItemCnt.visible=true;

			LabelItem.text=Common.ItemName[src.m_ItemType]+":";

			ButSplit.y=121;
			ButCancel.y=121;
			FrameBG.height=150;
		}
		CheckModule.visible=false;

		UpdateBar();
	}

	public function Fleet_CalcCntMax():int
	{
		var src:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot];
		var des:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_ToSlot];

		if(src.m_Type==Common.ShipTypeNone) return 0;

		var shipallcnt:int=src.m_Cnt;
		if(des.m_Type==src.m_Type) {
			shipallcnt+=des.m_Cnt;
		}
		
		if(shipallcnt<0) shipallcnt=0;
		
		return shipallcnt;
	}

	public function Fleet_CntChange(e:Event):void
	{
		var itcnt:int=0;
		while(true) {
			var src:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot];
			var des:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_ToSlot];
			if(src.m_Type==Common.ShipTypeNone) break;

			if(src.m_ItemType==Common.ItemTypeNone) break;
			var shipallcnt:int=src.m_Cnt;

			var itemallcnt:int=src.m_ItemCnt;
			if(des.m_Type==src.m_Type) {
				shipallcnt+=des.m_Cnt;
				if(des.m_ItemType!=Common.ItemTypeNone && src.m_ItemType==des.m_ItemType) {
					itemallcnt+=des.m_ItemCnt;
				} else if(des.m_ItemType!=Common.ItemTypeNone) break;
			}

			var cnt:int=int(EditCnt.text);
			if(cnt<=0) itcnt=0;
			else if(cnt>=shipallcnt) itcnt=itemallcnt;
			else itcnt=Math.round((cnt/shipallcnt)*itemallcnt);

			if(itcnt<0) itcnt=0;
			else if(itcnt>itemallcnt) itcnt=itemallcnt;

			break;
		}

		ItemCnt.text=itcnt.toString();
	}
	
	public function Fleet_Split(cnt:int, itcnt:int):void
	{
		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return;
		m_Map.m_FormFleetBar.FleetSplit(m_FromSlot,m_ToSlot,cnt,itcnt,user.m_Race);
	}

	// -------------------------------------------------------------------------
	public function FleetFromHyperspace_LoadCnt(type:int, def:int):int
	{
		var so:SharedObject=SharedObject.getLocal("EGEmpireOutFleetCnt"+m_Map.m_FormFleetBar.m_SlotMoveType.toString());
		//var so:SharedObject = SharedObject.getLocal("EGEmpireOutFleetCnt");

		if(so.size==0) return def;
		
		if(type==Common.ShipTypeTransport) {
			if(so.data.transport==undefined) return def; return so.data.transport;
		} else if(type==Common.ShipTypeCorvette) {
			if(so.data.corvette==undefined) return def; return so.data.corvette;
		} else if(type==Common.ShipTypeCruiser) {
			if(so.data.cruiser==undefined) return def; return so.data.cruiser;
		} else if(type==Common.ShipTypeDreadnought) {
			if(so.data.dreadnought==undefined) return def; return so.data.dreadnought;
		} else if(type==Common.ShipTypeInvader) {
			if(so.data.invader==undefined) return def; return so.data.invader;
		} else if(type==Common.ShipTypeDevastator) {
			if(so.data.devastator==undefined) return def; return so.data.devastator;
		}

		return def;
	}

	public function FleetFromHyperspace_SaveCnt(type:int, cnt:int):void
	{
		//var so:SharedObject = SharedObject.getLocal("EGEmpireOutFleetCnt");
		var so:SharedObject=SharedObject.getLocal("EGEmpireOutFleetCnt"+m_Map.m_FormFleetBar.m_SlotMoveType.toString());

		if(type==Common.ShipTypeTransport) so.data.transport=cnt;
		else if(type==Common.ShipTypeCorvette) so.data.corvette=cnt;
		else if(type==Common.ShipTypeCruiser) so.data.cruiser=cnt;
		else if(type==Common.ShipTypeDreadnought) so.data.dreadnought=cnt;
		else if(type==Common.ShipTypeInvader) so.data.invader=cnt;
		else if(type==Common.ShipTypeDevastator) so.data.devastator=cnt;
	}

	public function FleetFromHyperspace_LoadModule(def:Boolean):Boolean
	{
		var so:SharedObject=SharedObject.getLocal("EGEmpireOutFleetCnt"+m_Map.m_FormFleetBar.m_SlotMoveType.toString());

		if(so.size==0) return def;
		
		if(so.data.module==undefined) return def; return so.data.module;
		
		return def;
	}
	
	public function FleetFromHyperspace_SaveModule(v:Boolean):void
	{
		var so:SharedObject=SharedObject.getLocal("EGEmpireOutFleetCnt"+m_Map.m_FormFleetBar.m_SlotMoveType.toString());

		so.data.module=v;
	}

	public function FleetFromHyperspace_Run(fromslot:int,secx:int,secy:int,planetnum:int,shipnum:int):void
	{
		m_SectorX=secx;
		m_SectorY=secy;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;
		m_ToNum=-1;
		
		m_FromSlot=fromslot;
		m_ToSlot=-1;
		
		var src:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot];
		
		ItfInit();

		LabelCaption.text=Common.Txt.Split+": "+Common.ShipName[src.m_Type];

		var cnt:int=FleetFromHyperspace_LoadCnt(src.m_Type,999);
		if(cnt>src.m_Cnt) cnt=src.m_Cnt;
		var cntmax:int=m_Map.ShipMaxCnt(Server.Self.m_UserId,src.m_Type);
		if(cnt>cntmax) cnt=cntmax;

		EditCnt.text=cnt.toString();
		EditCnt.setFocus();
		EditCnt.setSelection(0,EditCnt.text.length);
		
		var sizey:int=91;

		if(src.m_ItemType!=Common.ItemTypeNone) {
			ItemCnt.text=Math.min(1,src.m_ItemCnt).toString();

			LabelItem.visible=true;
			ItemCnt.visible=true;
			
			LabelItem.y=sizey;
			ItemCnt.y=sizey;

			sizey+=ItemCnt.height+10;
//trace("Itm",sizey,ItemCnt.height);

			LabelItem.text=Common.ItemName[src.m_ItemType]+":";
			
			FleetFromHyperspace_CntChange(null);

		} else {
			LabelItem.visible=false;
			ItemCnt.visible=false;
		}
		
		if(src.m_Type==Common.ShipTypeTransport) {
			CheckModule.visible=true;
			CheckModule.y=sizey;
			CheckModule.selected=FleetFromHyperspace_LoadModule(false);
			
			sizey+=CheckModule.height+10;
//trace("Tra",sizey,CheckModule.height);
		} else {
			CheckModule.visible=false;
		}

		ButSplit.y=sizey;
		ButCancel.y=sizey;
		sizey+=ButCancel.height+10;
//trace("But",sizey,ButCancel.height);
		FrameBG.height=sizey;

		UpdateBar();
	}

	public function FleetFromHyperspace_CalcCntMax():int
	{
		var src:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot];

		if(src.m_Type==Common.ShipTypeNone) return 0;

		var shipallcnt:int=src.m_Cnt;
		var cntmax:int=m_Map.ShipMaxCnt(Server.Self.m_UserId,src.m_Type);
		if(shipallcnt>cntmax) shipallcnt=cntmax;

		if(shipallcnt<0) shipallcnt=0;
		
		return shipallcnt;
	}

	public function FleetFromHyperspace_CntChange(e:Event):void
	{
		var itcnt:int=0;
		while(true) {
			var src:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot];
			if(src.m_Type==Common.ShipTypeNone) break;

			if(src.m_ItemType==Common.ItemTypeNone) break;
			var shipallcnt:int=src.m_Cnt;

			var itemallcnt:int=src.m_ItemCnt;

			var cnt:int=int(EditCnt.text);
			if(cnt<=0) itcnt=0;
			else if(cnt>=shipallcnt) itcnt=itemallcnt;
			else itcnt=Math.round((cnt/shipallcnt)*itemallcnt);

			if(itcnt<1) itcnt=1;
			else if(itcnt>itemallcnt) itcnt=itemallcnt;

			break;
		}

		ItemCnt.text=itcnt.toString();
	}

	public function FleetFromHyperspace_Split(cnt:int, itcnt:int, savecnt:Boolean):void
	{
		if(cnt<0) return;
		
		var src:FleetSlot=m_Map.m_FormFleetBar.m_FleetSlot[m_FromSlot];
		if(src.m_Type==Common.ShipTypeNone) return;

		var module:int=0;
		if(src.m_Type==Common.ShipTypeTransport && CheckModule.selected) module=1;
		
		if(savecnt) {
			FleetFromHyperspace_SaveCnt(src.m_Type,cnt);
			if(src.m_Type==Common.ShipTypeTransport) FleetFromHyperspace_SaveModule(module!=0);
		}

		if(cnt>FleetFromHyperspace_CalcCntMax()) cnt=FleetFromHyperspace_CalcCntMax();

		var id:uint = 0;
		if (src.m_Type == Common.ShipTypeFlagship) id = src.m_Id;
		else id=m_Map.NewShipId(Server.Self.m_UserId);
		if(id!=0) {
			var ac:Action=new Action(m_Map);
			ac.ActionFromHyperspace(id,src.m_Type,m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,m_FromSlot,cnt,itcnt,module);
			m_Map.m_LogicAction.push(ac);
		}

//		m_Map.m_FormFleetBar.FleetSplit(m_FromSlot,m_ToSlot,cnt,itcnt);
	}
}

}
