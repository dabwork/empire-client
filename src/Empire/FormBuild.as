package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

public class FormBuild extends FormBuildClass
{
	private var m_Map:EmpireMap;

	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_ShipNum:int;

	public function FormBuild(map:EmpireMap)
	{
		m_Map=map;

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);

		ButCancel.addEventListener(MouseEvent.CLICK, clickCancel);
		ButMax.addEventListener(MouseEvent.CLICK, clickMax);
		ButBuild.addEventListener(MouseEvent.CLICK, clickBuild);

		EditCnt.addEventListener(ComponentEvent.ENTER, clickBuild);
		EditCnt.addEventListener(Event.CHANGE,UpdatePrice);

		SelectType.addEventListener(Event.CHANGE,UpdatePrice);
		SelectCurrency.addEventListener(Event.CHANGE,UpdatePrice);
	}

	protected function onMouseDownHandler(e:MouseEvent):void
	{
		if(ButBuild.hitTestPoint(e.stageX,e.stageY)) return;
		if(ButCancel.hitTestPoint(e.stageX,e.stageY)) return;
		if(ButMax.hitTestPoint(e.stageX,e.stageY)) return;
		if(EditCnt.hitTestPoint(e.stageX,e.stageY)) return;
		if(SelectType.hitTestPoint(e.stageX,e.stageY)) return;
		startDrag();
		m_Map.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
	}

	protected function onMouseUpHandler(e:MouseEvent):void
	{
		m_Map.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
		stopDrag();
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<width && mouseY>=0 && mouseY<height) return true;
		return false;
	}

	public function Run(secx:int,secy:int,planetnum:int,shipnum:int, type:int,cnt:int):void
	{
		var i:int;

		m_SectorX=secx;
		m_SectorY=secy;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;

		//m_Map.m_Info.Hide();

		visible=true;

		x=Math.ceil(m_Map.stage.stageWidth/2-width/2);
		y=Math.ceil(m_Map.stage.stageHeight/2-height/2);

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);
		
		Common.UIStdLabel(LabelBuild);
		Common.UIStdLabel(LabelCnt);
		Common.UIStdLabel(LabelPrice);
		Common.UIStdLabel(LabelSum);
		Common.UIStdLabel(ValPrice);
		Common.UIStdLabel(ValSum);
		
//		LabelPrice.textField.
		
/*		LabelBuild.setStyle("textFormat", tf);
		LabelBuild.setStyle("embedFonts", true);
		LabelBuild.textField.antiAliasType=AntiAliasType.ADVANCED;
		LabelBuild.textField.gridFitType=GridFitType.PIXEL;

		LabelCnt.setStyle("textFormat", tf);
		LabelCnt.setStyle("embedFonts", true);
		LabelCnt.textField.antiAliasType=AntiAliasType.ADVANCED;
		LabelCnt.textField.gridFitType=GridFitType.PIXEL;*/
		
		ButBuild.setStyle("textFormat", tf);
		ButBuild.setStyle("embedFonts", true);
		ButBuild.textField.antiAliasType=AntiAliasType.ADVANCED;
		ButBuild.textField.gridFitType=GridFitType.PIXEL;

		ButCancel.setStyle("textFormat", tf);
		ButCancel.setStyle("embedFonts", true);
		ButCancel.textField.antiAliasType=AntiAliasType.ADVANCED;
		ButCancel.textField.gridFitType=GridFitType.PIXEL;
		
		ButMax.setStyle("textFormat", tf);
		ButMax.setStyle("embedFonts", true);
		ButMax.textField.antiAliasType=AntiAliasType.ADVANCED;
		ButMax.textField.gridFitType=GridFitType.PIXEL;
		
		EditCnt.setStyle("textFormat", tf);
		EditCnt.setStyle("embedFonts", true);
		EditCnt.textField.antiAliasType=AntiAliasType.ADVANCED;
		EditCnt.textField.gridFitType=GridFitType.PIXEL;

		Common.UIStdComboBox(SelectType as ComboBox);
		Common.UIStdComboBox(SelectCurrency as ComboBox);
		
/*		SelectType.setStyle("textFormat", tf);
		SelectType.setStyle("embedFonts", true);
		SelectType.textField.setStyle("textFormat", tf);
		SelectType.textField.setStyle("embedFonts", true);
		SelectType.textField.textField.antiAliasType=AntiAliasType.ADVANCED;
		SelectType.textField.textField.gridFitType=GridFitType.PIXEL;
		SelectType.dropdown.setRendererStyle("textFormat", tf);
		SelectType.dropdown.setRendererStyle("embedFonts", true);*/

		LabelBuild.text=Common.Txt.Build+":";
		LabelCnt.text=Common.Txt.Count+":";

		LabelPrice.htmlText="<p align='right'>"+Common.Txt.Price+":</p>";
		LabelSum.htmlText="<p align='right'>"+Common.Txt.Sum+":</p>";

		ButBuild.label=Common.Txt.Build;
		ButCancel.label=Common.Txt.Cancel;
		ButMax.label=Common.Txt.Max;

		SelectType.rowCount=20;
		SelectType.removeAll();

		var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if(planet==null) { visible=false; return; }

		if((m_Map.m_CotlType==Common.CotlTypeProtect || m_Map.m_CotlType==Common.CotlTypeCombat || m_Map.m_CotlType==Common.CotlTypeRich) && m_Map.m_OpsCostBuildLvl==0) {}
		else {
			SelectType.addItem( { label:Common.Txt.Level, data:0 } );
			if(type==Common.ShipTypeNone) SelectType.selectedIndex=0;
		}

		for(i=0;i<m_Map.m_CMShipBuildType.length;i++) {
			var st:int=m_Map.m_CMShipBuildType[i];
			if(!m_Map.ShipAccess(planet.m_Owner,st)) continue;
			if(!m_Map.BuildAccess(planet.m_Owner,st)) continue;
			
			SelectType.addItem( { label:Common.ShipName[st], data:st } );
			if(st==type) {
				SelectType.selectedIndex=SelectType.length-1;// i+1;
			} 
		}

		SelectCurrency.rowCount=2;
		SelectCurrency.removeAll();
		SelectCurrency.addItem( { label:Common.Txt.CurrencyModule, data:0 } );
		if(planet.m_Owner==Server.Self.m_UserId && m_Map.m_CotlType!=Common.CotlTypeProtect && m_Map.m_CotlType!=Common.CotlTypeCombat) SelectCurrency.addItem( { label:Common.Txt.CurrencySDM, data:1 } );
		SelectCurrency.selectedIndex=0;
		SelectCurrency.visible=(planet.m_Owner==Server.Self.m_UserId);

		EditCnt.restrict = "0-9";
		EditCnt.textField.maxChars = 6;
		if(cnt<0) cnt=CalcMaxCnt();
		if(type==Common.ShipTypeShipyard || type==Common.ShipTypeSciBase || type==Common.ShipTypeServiceBase) cnt=1;
		EditCnt.text=cnt.toString();
		EditCnt.setFocus();
		EditCnt.setSelection(0,EditCnt.text.length);
		
		UpdatePrice();
	}

	private function clickCancel(event:MouseEvent):void
	{
		visible=false;
	}

	public function CalcMaxCnt(updateshipnum:Boolean=false):int
	{
		if(SelectType.selectedIndex<0 || SelectType.selectedIndex>=SelectType.length) return 0; 
		var type:int=SelectType.selectedItem.data;
		var cnt:int=int(EditCnt.text);

/*		var mv:int=Common.ShipMaxCnt;
		if(type==Common.ShipTypeNone) mv=m_Map.DirVal(Common.DirPlanetLevelMax);
		if(cnt>mv) cnt=mv;
		if(cnt<1) cnt=1;

		var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if(planet==null) return 0;*/

		//var shipnum:int=m_ShipNum;
		//if(type!=Common.ShipTypeNone) {
		//	if(shipnum<0) shipnum=planet.FindBuildPlace(m_Map,m_Map.m_UserId,type,cnt);
		//	if(shipnum<0) shipnum=planet.FindBuildPlace(m_Map,m_Map.m_UserId,type,1);
		//}

		//if(updateshipnum) m_ShipNum=shipnum;

		//if(type!=Common.ShipTypeNone) cnt=0;
		//else 
//		if(SelectCurrency.selectedItem.data==0) cnt=m_Map.CalcBuildMaxCnt(0,type,m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
//		else cnt=m_Map.CalcBuildMaxCntSDM(0,type,m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
		
		return cnt;
	}

	private function clickMax(event:MouseEvent):void
	{
		EditCnt.text=CalcMaxCnt().toString();
		EditCnt.setFocus();
		EditCnt.setSelection(0,EditCnt.text.length);
		UpdatePrice();
	}
	
	public function UpdatePrice(event:Event=null):void
	{
		var cnt:int=int(EditCnt.text);
		var price:int=0;
		var type:int=SelectType.selectedItem.data;
		var maxsum:int=0;

		if(SelectCurrency.selectedItem.data==0) {
			var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
			if (planet != null && m_Map.AccessBuild(planet.m_Owner) /*planet.m_Owner==Server.Self.m_UserId*/) maxsum = m_Map.PlanetItemGet_Sub(planet.m_Owner, planet, Common.ItemTypeModule);// planet.m_ConstructionPoint;
			
			/*if(planet.m_Owner!=Server.Self.m_UserId) price=-1;
			else*/
			if(type==Common.ShipTypeNone) {
				price = Common.PlanetLevelCost;// m_Map.DirValE(planet.m_Owner, Common.DirPlanetLavelCost);

				if(m_Map.m_CotlType==Common.CotlTypeProtect || m_Map.m_CotlType==Common.CotlTypeCombat || m_Map.m_CotlType==Common.CotlTypeProtect) price=(price*m_Map.m_OpsCostBuildLvl)>>8;
				else price=(price*m_Map.m_InfrCostMul)>>8;
			}
			else price=m_Map.ShipCost(planet.m_Owner,0,type);
		} else {
			maxsum=m_Map.m_UserSDM;
			if(type==Common.ShipTypeNone) price=Common.PlanetLevelSDM;
			else price=Common.ShipCostSDM[type];
		}

		if(price<0) ValPrice.text="-";
		else ValPrice.text=price.toString();
		
		var str:String='';
		
		if(price<0) str+="-";
		else {
			if(price*cnt>maxsum) str+="<font color='#ff0000'>"+BaseStr.FormatBigInt(price*cnt)+"</font>";
			else str+=BaseStr.FormatBigInt(price*cnt);
		
			if(SelectCurrency.selectedItem.data==0) str+=" "+Common.Txt.CurrencyModule;
			else str+=" "+Common.Txt.CurrencySDM;
		}
		
		ValSum.htmlText=str;
	}

	private function clickBuild(event:Event):void
	{
		var type:int=SelectType.selectedItem.data;
		var cnt:int=int(EditCnt.text);
		var maxcnt:int=CalcMaxCnt(false);
		if(cnt>maxcnt) cnt=maxcnt;

		var id:uint=0;

		while(cnt>0) {
			var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
			if(planet==null) break;

			if(m_ShipNum<0) {
				// if(m_Map.CntFriendGroup(planet,Server.Self.m_UserId,Common.RaceNone)>=Common.GroupInPlanetMax) { m_Map.m_FormHint.Show(Common.Txt.WarningMaxGroup,Common.WarningHideTime); break; }

				m_ShipNum=m_Map.CalcBuildPlace(planet,planet.m_Owner/* Server.Self.m_UserId*/);
				if(m_ShipNum<0) break;

				id=m_Map.NewShipId(planet.m_Owner);
				if(id==0) return;
				//id=m_Map.m_UserNewShipId;
				//m_Map.m_UserNewShipId++;

			} else {
				var ship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
				if(ship==null) break;
				
				if(ship.m_Type==Common.ShipTypeNone) {
					if(m_Map.CntFriendGroup(planet,planet.m_Owner /*Server.Self.m_UserId*/,Common.RaceNone)>=Common.GroupInPlanetMax) { m_Map.m_FormHint.Show(Common.Txt.WarningMaxGroup,Common.WarningHideTime); break; }
					if(m_Map.IsRear(planet,m_ShipNum,planet.m_Owner /*Server.Self.m_UserId*/,Common.RaceNone,true)) { m_Map.m_FormHint.Show(Common.Txt.WarningRear,Common.WarningHideTime); break; }
	
					id=m_Map.NewShipId(planet.m_Owner);
					if(id==0) return;
					//id=m_Map.m_UserNewShipId;
					//m_Map.m_UserNewShipId++;
				}
			}

			var ac:Action=new Action(m_Map);
			ac.ActionBuild(id,m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,type,cnt,SelectCurrency.selectedItem.data,planet.m_Owner);
			m_Map.m_LogicAction.push(ac);
	
			break;
		}
		
		visible=false;
	}
}

}
