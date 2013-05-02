package Empire
{

import fl.controls.*;
import fl.events.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

public class FormPortal extends FormPortalClass
{
	private var m_Map:EmpireMap;
	
	public var m_SectorX:int=0;
	public var m_SectorY:int=0;
	public var m_PlanetNum:int=0;

	public function FormPortal(map:EmpireMap)
	{
		m_Map=map;

		Common.UIStdLabel(Caption,18);

		Common.UIStdBut(ButSet);
		Common.UIStdBut(ButClose);

		Common.UIStdInput(EditSector);
		Common.UIStdLabel(LabelSector);

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);

		ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		ButSet.addEventListener(MouseEvent.CLICK, clickSet);
		
		EditSector.addEventListener(ComponentEvent.ENTER, clickSet);
	}

	protected function onMouseDownHandler(e:MouseEvent):void
	{
		if(ButSet.hitTestPoint(e.stageX,e.stageY)) return;
		if(ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(EditSector.hitTestPoint(e.stageX,e.stageY)) return;

		startDrag();
		m_Map.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
	}

	protected function onMouseUpHandler(e:MouseEvent):void
	{
		m_Map.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
		stopDrag();
	}

	private function clickClose(event:MouseEvent):void
	{
		Hide();
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

	public function Show():void
	{
		visible=true;

		x=Math.ceil(m_Map.stage.stageWidth/2-width/2);
		y=Math.ceil(m_Map.stage.stageHeight/2-height/2);

		Caption.htmlText=Common.Txt.PortalCaption;
		LabelSector.text=Common.Txt.PortalSector+":";
		ButSet.label=Common.Txt.PortalSet;
		ButClose.label=Common.Txt.ButClose;
		
//		EditSector.textField.restrict = "0-9";
		EditSector.textField.maxChars = 10;
		
		var pl:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if(pl!=null) {
			EditSector.text=pl.m_PortalSectorX.toString()+" "+pl.m_PortalSectorY.toString();
		}

		EditSector.setFocus();
	}

	private function clickSet(event:Event):void
	{
		var msg:String=EditSector.text;
		
		var ch:int;
		var len:int=msg.length;
		if(len<=0) return;
		var sme:int=0;

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
		if(sme>=len) return;
		ch=msg.charCodeAt(sme);
		if(ch==0x2c) sme++;
		else if(ch==0x2e) sme++;
		else if(ch>=48 && ch<=57) {}
		else return;
		while((sme<len) && (msg.charCodeAt(sme)==32)) sme++;
		if(sme>=len) return;

//trace("01 ["+msg.substring(sme,len)+"]");
		while(sme<len) {
			ch=msg.charCodeAt(sme);
			if(ch>=48 && ch<=57) secy=secy*10+ch-48;
			else break;
			sme++;
		}

		while((sme<len) && (msg.charCodeAt(sme)==32)) sme++;
		if(sme<len) return;

//trace(secx,secy);
		secx=secx-1+EmpireMap.Self.m_SectorMinX;
		secy=secy-1+EmpireMap.Self.m_SectorMinY;

		if(secx<EmpireMap.Self.m_SectorMinX || secx>=EmpireMap.Self.m_SectorMinX+EmpireMap.Self.m_SectorCntX) return;
		if(secy<EmpireMap.Self.m_SectorMinY || secy>=EmpireMap.Self.m_SectorMinY+EmpireMap.Self.m_SectorCntY) return;

//		var ac:Action=new Action(this);
//		ac.ActionSpecial(5,m_CurSectorX,m_CurSectorY,m_CurPlanetNum,m_CurShipNum);
//		m_LogicAction.push(ac);

		m_Map.SendAction("emportal",""+m_SectorX+"_"+m_SectorY+"_"+m_PlanetNum+"_"+secx+"_"+secy);

//trace(secx,secy);
		Hide();
	}
}

}
