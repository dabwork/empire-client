package Empire
{

import fl.controls.*;
import fl.events.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormResChange extends FormResChangeClass
{
	private var m_Map:EmpireMap;

	public function FormResChange(map:EmpireMap)
	{
		m_Map=map;

		Common.UIStdBut(ButChange);
		Common.UIStdBut(ButCancel);

		Common.UIStdLabel(LabelFrom);
		Common.UIStdLabel(LabelTo);

		Common.UIStdComboBox(FromType as ComboBox);
		Common.UIStdComboBox(ToType as ComboBox);

		Common.UIStdInput(FromCnt);
		Common.UIStdInput(ToCnt);

		//Common.UIChatBar(BarCnt);

		FromType.addEventListener(Event.CHANGE,TypeChange);
		ToType.addEventListener(Event.CHANGE,TypeChange);
		FromCnt.addEventListener(Event.CHANGE,FromCntChange);
		ToCnt.addEventListener(Event.CHANGE,ToCntChange);
		BarCnt.addEventListener(Event.CHANGE,BarChange);
		//BarCnt.addEventListener(SliderEvent.THUMB_DRAG,BarDrag);
		
//		var square:Sprite = new Sprite();
//		square.graphics.beginFill(0xCCFF00);
//		square.graphics.drawRect(0, -20, 200, 20);
//		BarCnt.hitArea = square;
//		square.mouseEnabled = false;
//		BarCnt.setStyle("focusRectPadding",10);

		FromType.rowCount=3;
		FromType.removeAll();
		FromType.addItem( { label:Common.ItemName[Common.ItemTypeAntimatter], data:Common.ItemTypeAntimatter } );
		FromType.addItem( { label:Common.ItemName[Common.ItemTypeMetal], data:Common.ItemTypeMetal } );
		FromType.addItem( { label:Common.ItemName[Common.ItemTypeElectronics], data:Common.ItemTypeElectronics } );
		FromType.selectedIndex=0;

		ToType.rowCount=3;
		ToType.removeAll();
		ToType.addItem( { label:Common.ItemName[Common.ItemTypeAntimatter], data:Common.ItemTypeAntimatter } );
		ToType.addItem( { label:Common.ItemName[Common.ItemTypeMetal], data:Common.ItemTypeMetal } );
		ToType.addItem( { label:Common.ItemName[Common.ItemTypeElectronics], data:Common.ItemTypeElectronics } );
		ToType.selectedIndex=1;

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		ButChange.addEventListener(MouseEvent.CLICK, clickChange);
		ButCancel.addEventListener(MouseEvent.CLICK, clickCancel);

		FromCnt.addEventListener(ComponentEvent.ENTER, clickChange);
		ToCnt.addEventListener(ComponentEvent.ENTER, clickChange);
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		if(ButChange.hitTestPoint(e.stageX,e.stageY)) return;
		if(ButCancel.hitTestPoint(e.stageX,e.stageY)) return;
		if(FromCnt.hitTestPoint(e.stageX,e.stageY)) return;
		if(ToCnt.hitTestPoint(e.stageX,e.stageY)) return;
		if(BarCnt.hitTestPoint(e.stageX,e.stageY)) return;
		if(FromType.hitTestPoint(e.stageX,e.stageY)) return;
		if(ToType.hitTestPoint(e.stageX,e.stageY)) return;
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
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

		ButCancel.label=Common.Txt.ButCancel;
		ButChange.label=Common.Txt.ButChange;
		LabelFrom.text=Common.Txt.ChangeFrom+":";
		LabelTo.text=Common.Txt.ChangeTo+":";
		
		FromCnt.restrict = "0-9";
		FromCnt.textField.maxChars = 8;
		FromCnt.text="0";

		ToCnt.restrict = "0-9";
		ToCnt.textField.maxChars = 8;
		ToCnt.text="0";
		ToCnt.setFocus();
		ToCnt.setSelection(0,ToCnt.text.length);
		
		UpdateBar();

//		Update();
	}
	
	public function SetType(fromtype:int, totype:int):void
	{
		if(fromtype==Common.ItemTypeAntimatter) FromType.selectedIndex=0;
		else if(fromtype==Common.ItemTypeMetal) FromType.selectedIndex=1;
		else if(fromtype==Common.ItemTypeElectronics) FromType.selectedIndex=2;

		if(totype==Common.ItemTypeAntimatter) ToType.selectedIndex=0;
		else if(totype==Common.ItemTypeMetal) ToType.selectedIndex=1;
		else if(totype==Common.ItemTypeElectronics) ToType.selectedIndex=2;
	}

	private function clickCancel(event:MouseEvent):void
	{
		Hide();
	}

	private function clickChange(event:Event):void
	{
		var cnt:int=int(ToCnt.text);
		if(cnt<0 || cnt>CalcCntMax()) return;

		var fromtype:int=FromType.selectedItem.data;
		var totype:int=ToType.selectedItem.data;

		var ac:Action=new Action(m_Map);
		ac.ActionResChange(fromtype,totype,cnt);
		m_Map.m_LogicAction.push(ac);

		Hide();
	}

	public function UpdateFromCnt():void
	{
		var cnt:int=int(ToCnt.text);
		FromCnt.text=(cnt*Common.ResChangeFactor).toString();
	}

	public function UpdateToCnt():void
	{
		var cnt:int=int(FromCnt.text);
		ToCnt.text=(Math.floor(cnt/Common.ResChangeFactor)).toString();
	}

	public function CalcCntMax():int
	{
		var fromtype:int=FromType.selectedItem.data;
		var totype:int=ToType.selectedItem.data;
		
		var m:int=Math.floor(m_Map.m_UserRes[fromtype]/Common.ResChangeFactor);
		if(m+m_Map.m_UserRes[totype]>Common.ResMax) m=Common.ResMax-m_Map.m_UserRes[totype];
		if(m<0) m=0;
		
		return m;
	}

	public function UpdateBar():void
	{
		BarCnt.minimum=0;
		BarCnt.maximum=CalcCntMax();
		BarCnt.value=int(ToCnt.text);
	}

	public function UpdateBut():void
	{
		var cnt:int=int(ToCnt.text);

		var fromtype:int=FromType.selectedItem.data;
		var totype:int=ToType.selectedItem.data;

		ButChange.enabled=(cnt>0) && (cnt<=CalcCntMax()) && (fromtype!=totype);
	}

	protected function FromCntChange(e:Event):void { UpdateToCnt(); UpdateBar(); UpdateBut(); }
	protected function ToCntChange(e:Event):void { UpdateFromCnt(); UpdateBar(); UpdateBut(); }
	protected function BarChange(e:Event):void { ToCnt.text=BarCnt.value.toString(); UpdateFromCnt(); UpdateBut(); }
	//protected function BarDrag(e:SliderEvent):void { ToCnt.text=e.value.toString(); UpdateFromCnt(); UpdateBut(); }
	protected function TypeChange(e:Event):void { ToCnt.text='0'; UpdateFromCnt(); UpdateBar(); UpdateBut(); }
}

}
