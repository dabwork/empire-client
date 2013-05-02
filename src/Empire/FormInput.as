// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import fl.containers.*;
import fl.controls.*;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormInput extends Sprite
{
	private var m_Map:EmpireMap;
	
	public var m_ButOk:Button=null;
	
	public var m_SizeX:int=0;
	public var m_SizeY:int=0;
	public var m_SizeYMax:int=0;

	public var m_Fun:Function = null;
	
	public var m_LastObj:DisplayObject=null;
	
	public var m_Col:Boolean=false;

	public var m_ColList:Array=new Array();

	public var m_PageList:Array= new Array();
	public var m_PageMouse:int=-1;
	public var m_PageCur:int=-1;
	
	public var m_PageStartY:int = -1;
	
	public var m_CaptureMause:Boolean = false;
	
	public var m_SpecialButtonOffset:int = 0;
	
	public var m_List:Vector.<InputUnit> = new Vector.<InputUnit>();

	public function FormInput(map:EmpireMap)
	{
		m_Map=map;

//		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
//		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

//		ButClose.addEventListener(MouseEvent.CLICK, clickClose);

	}

	public function StageResize():void
	{
		if (!visible) return; //&& EmpireMap.Self.IsResize()) {
		x = Math.ceil(parent.stage.stageWidth / 2 - m_SizeX / 2);
		y = Math.ceil(parent.stage.stageHeight / 2 - m_SizeY / 2);
	}
	
	protected function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		var i:int,u:int=-1;

		for(i=0;i<m_PageList.length;i++) {
			var obj:Object=m_PageList[i];
			var txtf:TextField=obj.TF;
			if(txtf.hitTestPoint(e.stageX,e.stageY)) {
				u=i;
				break;
			}
		}

		if(m_PageMouse!=u) {
			m_PageMouse=u;
			PageUpdate();
		}
		
		EmpireMap.Self.m_Info.Hide();
	}
	
	protected function PageUpdate():void
	{
		var i:int;

		for(i=0;i<m_PageList.length;i++) {
			var obj:Object=m_PageList[i];
			var txtf:TextField=obj.TF;

			if(i==m_PageMouse || i==m_PageCur) {
				txtf.background=true;
				txtf.backgroundColor=0x0000ff;
			} else {
				txtf.background=false;
			}
		}
	}

	public function PageChange(np:int):void
	{
		var i:int,u:int;
		var obj:Object;
		
		if(np==m_PageCur) return;
		m_PageCur=np;

		PageUpdate();

		if (m_ColorPickerInput != null) {
			m_ColorPickerInput = null;
			EmpireMap.Self.m_FormInputColor.Hide();
		}
		
//trace("PageChange");
		for(u=0;u<m_PageList.length;u++) {
			obj=m_PageList[u];
			for(i=obj.Start;i<obj.End;i++) {
//trace(i+":off");
				getChildAt(i).visible=false;
			}
		}
		
		obj=m_PageList[m_PageCur];
		for(i=obj.Start;i<obj.End;i++) {
			getChildAt(i).visible=true;
//trace(i+":on");				
		}
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		if(FormMessageBox.Self.visible) return;
		var i:int;
		for(i=0;i<numChildren;i++) {
			var obj:DisplayObject=getChildAt(i);
			if(!obj.hitTestPoint(e.stageX,e.stageY)) continue;
			if(obj is Button) return;
			else if(obj is TextInput) return;
			else if(obj is TextArea) return;
			else if(obj is ComboBox) return;
			else if(obj is CheckBox) return;
			else if(obj is Slider) return;
		}
		if(m_PageMouse>=0) {
			PageChange(m_PageMouse);
			dispatchEvent(new Event("PageChange"));
			return;
		}
		if(mouseX>=0 && mouseY>=0 && mouseX<m_SizeX && mouseY<m_SizeY) {
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true, 1000);
		}
	}
	
	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	protected function onMouseUp(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	public function onKeyDownHandler(e:KeyboardEvent):void
	{
		e.stopImmediatePropagation();
	}
	
	public function onIntercept(e:MouseEvent):void
	{
		if (FormStd.m_ModalList.length <= 0) return;
		if (FormStd.m_ModalList[FormStd.m_ModalList.length - 1] != this) return;
		
//trace(e.currentTarget, e.target);
		var i:int;
		var o:DisplayObject = null;
		if ((e.target != null) && (e.target is DisplayObject)) {
			o = e.target as DisplayObject;
			while (o != null) {
				if (o == this) break;
				
				if (o is List) {
					for(i=0;i<numChildren;i++) {
						var obj:DisplayObject=getChildAt(i);
						if (obj is ComboBox) {
							if ((obj as ComboBox).dropdown == o) return;
						}
					}
				}
				o = o.parent;
			}
		}
		if (o == null) e.stopPropagation();

/*		var i:int;
		var po:DisplayObject = e.target as DisplayObject;
		while (po != null) {
//trace("    ", po);
			if (po == this) return;
			if (po is List) {
				for(i=0;i<numChildren;i++) {
					var obj:DisplayObject=getChildAt(i);
					if (obj is ComboBox) {
						if ((obj as ComboBox).dropdown == po) return;
					}
				}
			}
			po = po.parent;
		}
//trace("not found");
		e.stopImmediatePropagation();*/

//		if (e.stageX >= 0 && e.stageX < m_SizeX && e.stageY >= 0 && e.stageY < m_SizeY) { }
//		else e.stopPropagation();
	}
	
	public function Hide():void
	{
		if (!visible) return;
//trace("Input Hide");
		visible = false;
		
		var i:int = FormStd.m_ModalList.indexOf(this);
		FormStd.m_ModalList.splice(i, 1);

		if (m_ColorPickerInput != null) {
			m_ColorPickerInput = null;
			EmpireMap.Self.m_FormInputColor.Hide();
		}

		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		
		if (m_CaptureMause) {
//trace("Input cap out");
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onIntercept, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onIntercept, false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onIntercept, false);
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onIntercept,true);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onIntercept,true);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onIntercept, true);
		}
		m_CaptureMause = false;

		for(i=0;i<numChildren;i++) {
			var obj:DisplayObject = getChildAt(i);
			
//			obj.visible = false;
			
			if (obj is Button) {}
			else if (obj is TextInput) {}
			else if (obj is TextArea) {}
			else if (obj is ComboBox) {
				(obj as ComboBox).close();
			}
			else if (obj is CheckBox) {}
			else if (obj is Slider) {}
		}
	}
	
	public var m_CaptureMouseNeed:Boolean = false;
	
	public function Show():void
	{
		if (visible) return;
		visible = true;

		FormStd.m_ModalList.push(this);

//trace("Input Show");
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		
		if (m_CaptureMouseNeed) {
//trace("Input cap in");
			m_CaptureMause = true;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onIntercept, false);// , -999);
			stage.addEventListener(MouseEvent.MOUSE_UP, onIntercept, false);// , -999);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onIntercept, false);// , -999);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onIntercept, true);// , -999);
			stage.addEventListener(MouseEvent.MOUSE_UP, onIntercept, true);// , -999);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onIntercept, true);// , -999);
		} else {
			m_CaptureMause = false;
		}
	}

	public function Run(fun:Function=null, txtok:String=null, txtcancel:String=null, capturemouse:Boolean=true):void
	{
		var i:int;
		var obj:Object;
		
		m_CaptureMouseNeed = capturemouse;
		Show();

		if(m_PageList.length>0) {
			obj=m_PageList[m_PageList.length-1];
			obj.End=numChildren+1;
		}

		m_Fun=fun;

		m_SizeY=Math.max(m_SizeYMax,m_SizeY);
		m_SizeY+=10;

		var but:Button;

		var tf:TextFormat = new TextFormat("Calibri",13,0xc4fff2);

		but=new Button();
		if(txtcancel==null)	but.label = Common.Txt.ButClose;
		else but.label = txtcancel;
		but.width=100;
		but.emphasized=false;
		but.setStyle("textFormat", tf);
		but.setStyle("embedFonts", true);
		but.textField.antiAliasType=AntiAliasType.ADVANCED;
		but.textField.gridFitType=GridFitType.PIXEL;
		but.addEventListener(MouseEvent.CLICK, clickClose);
		but.x=m_SizeX-10-but.width;
		but.y=m_SizeY;
		addChild(but);
		
		if (txtok == null && fun == null) { }
		else {
			but=new Button();
			if(txtok==null) but.label = Common.Txt.ButSave;
			else but.label = txtok;
			but.width=100;
			but.emphasized=false;
			but.setStyle("textFormat", tf);
			but.setStyle("embedFonts", true);
			but.textField.antiAliasType=AntiAliasType.ADVANCED;
			but.textField.gridFitType=GridFitType.PIXEL;
			but.addEventListener(MouseEvent.CLICK, clickSave);
			but.x=m_SizeX-10-but.width-110;
			but.y=m_SizeY;
			addChild(but);
			m_ButOk = but;
		}

		m_SizeY+=but.height+10;

		var fr:GrFrame=new GrFrame();
		addChildAt(fr,0);
		if(m_PageList.length>0) {
			fr.x=-100;
			fr.width=m_SizeX+100;
		} else fr.width=m_SizeX;
		fr.height=m_SizeY;

		if(m_PageList.length>0) {
			for(i=0;i<m_PageList.length;i++) {
				obj=m_PageList[i];
				var txtf:TextField=obj.TF;
				txtf.x=-90;
				txtf.y=100+i*20;
			}

			PageChange(0);
		}

		x=Math.ceil(parent.stage.stageWidth/2-m_SizeX/2);
		y=Math.ceil(parent.stage.stageHeight/2-m_SizeY/2);
	}
	
	public function SpecialButtonAdd(txt:String, bwidth:int=100, fun:Function=null):Button
	{
		var but:Button;
		var tf:TextFormat = new TextFormat("Calibri", 13, 0xc4fff2);
		
		but=new Button();
		but.label = txt;
		but.width=bwidth;
		but.emphasized=false;
		but.setStyle("textFormat", tf);
		but.setStyle("embedFonts", true);
		but.textField.antiAliasType=AntiAliasType.ADVANCED;
		but.textField.gridFitType = GridFitType.PIXEL;
		if (fun != null) but.addEventListener(MouseEvent.CLICK, fun);
		if (m_PageList.length > 0) but.x = -100 + m_SpecialButtonOffset;
		else but.x = m_SpecialButtonOffset;
		but.y = m_SizeY - but.height - 10;
		addChild(but);
		
		m_SpecialButtonOffset += bwidth + 5;
		return but;
	}
	
	public function FindInputUnit(dobj:DisplayObject):InputUnit
	{
		var i:int;
		var iu:InputUnit;
		for (i = 0; i < m_List.length; i++) {
			iu = m_List[i];
			if (iu.m_DO == dobj) return iu;
		}
		return null;
	}
	
	public function SetUserData(dobj:DisplayObject, data:Object):void
	{
		var iu:InputUnit = FindInputUnit(dobj);
		if (iu == null) return;
		iu.m_Data = data;
	}
	
	public function GetUserData(dobj:DisplayObject):Object
	{
		var iu:InputUnit = FindInputUnit(dobj);
		if (iu == null) return null;
		return iu.m_Data;
	}

	public function Init(sx:int=300):void
	{
		Hide();
		while (numChildren > 0) removeChildAt(numChildren - 1);
		
		var i:int;
		for (i = 0; i < m_List.length; i++) {
			var o:InputUnit = m_List[i];
			o.Clear();
		}
		m_List.length = 0;

		m_ButOk=null;
		m_LastObj=null;
		m_PageList.length=0;
		m_SizeX=sx;
		m_SizeY=10;
		m_SizeYMax=0;
		m_ColList.length=0;
		m_PageStartY=-1;
		m_PageCur=-1;
		m_PageMouse = -1;
		
		m_SpecialButtonOffset = 10;
	}
	
	public function PageAdd(name:String):void
	{
		var i:int;
		var obj:Object;
		
		m_Col=false;
		
		if(m_PageList.length>0) {
			obj=m_PageList[m_PageList.length-1];
			obj.End=numChildren+1;
		}
			
		obj=new Object();
		m_PageList.push(obj);
		
		if(m_PageStartY<=0) {
			m_PageStartY=m_SizeY;
		} else {
			m_SizeYMax=Math.max(m_SizeYMax,m_SizeY);
			m_SizeY=m_PageStartY;
		}

		var l:TextField;
		l=new TextField();
		l.x=10;
		l.y=10;
		l.width=100;
		l.height=20;
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background=false;
		l.multiline=false;
		l.autoSize=TextFieldAutoSize.NONE;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.PIXEL;
		l.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		l.embedFonts=true;
		l.htmlText=name;
		addChild(l);
		
		obj.Start=numChildren+1;

		obj.TF=l;
	}

	public function AddLabel(txt:String, fsize:int=13, clr:uint=0xffffff, wordwrap:Boolean=false):TextField
	{
		var l:TextField;
		l=new TextField();
		l.x=10;
		l.y=m_SizeY;
		l.width=m_SizeX-20;
		l.height=0;
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background = false;
		if (wordwrap) {
			l.multiline = true;
			l.wordWrap = true;
		} else {
			l.multiline = false;
		}
		l.autoSize=TextFieldAutoSize.LEFT;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.PIXEL;
		l.defaultTextFormat=new TextFormat("Calibri",fsize,clr);
		l.embedFonts=true;
		l.htmlText=BaseStr.FormatTag(txt);
		addChild(l);
		//m_SizeY+=l.height+10;
//trace("height:",l.height,txt);
		//var h:int = l.height;
		l.height; // праильная высота возращается только после второго вызова
		m_SizeY += l.height+10;

		var iu:InputUnit = new InputUnit();
		m_List.push(iu);
		iu.m_DO = l;

		return l;
	}
	
	public function Col():void
	{
		m_Col=true;
	}
	
	public function ColAlign():void
	{
		var i:int;
		var d:DisplayObject;
		
		var m:int=0;
		for(i=0;i<m_ColList.length;i++) {
			d=m_ColList[i];
			m=Math.max(m,d.x);
		}

		for(i=0;i<m_ColList.length;i++) {
			d=m_ColList[i];
			if(d is CheckBox) {
				var t:int=getChildIndex(d);
				if(t>=0) {
					var d2:DisplayObject=getChildAt(t+1);
					d2.x=m+20;
				}
			} else {
				d.width=d.x+d.width-m;
			}
			d.x=m;
		}
	}
	
	public function AddCheck(val:Boolean, txt:String, fsize:int=13, clr:uint=0xffffff):CheckBox
	{
		var po:DisplayObject=null;
		if(m_Col && numChildren>0) po=getChildAt(numChildren-1); 
		
		var i:CheckBox;
		i=new CheckBox();
		if(po!=null) {
			m_ColList.push(i);
			i.x=po.x+po.width+5;
			i.y=po.y;
			//i.width=m_SizeX-i.x-20;
		} else {
			i.x=20;
			i.y=m_SizeY;
			//i.width=m_SizeX-40;
		}
		m_Map.m_FormPact.CheckStyle(i);
		//i.setStyle("textFormat",new TextFormat("Calibri",fsize,clr));
		//i.label=txt;
		i.selected=val;
		addChild(i);
		
		var l:TextField;
		l=new TextField();
		l.x=i.x+20;
		l.y=i.y;
		l.width=1;
		l.height=1;
		l.type=TextFieldType.DYNAMIC;
		l.selectable=false;
		l.border=false;
		l.background=false;
		l.multiline=false;
		l.autoSize=TextFieldAutoSize.LEFT;
		l.antiAliasType=AntiAliasType.ADVANCED;
		l.gridFitType=GridFitType.PIXEL;
		l.defaultTextFormat=new TextFormat("Calibri",fsize,clr);
		l.embedFonts=true;
		l.htmlText=txt;
		addChild(l);
		
		if(po!=null) m_SizeY=Math.max(po.y+po.height+10,i.y+i.height+10); 
		else m_SizeY+=i.height+10;
		
		if(m_Col) m_Col=false;

		var iu:InputUnit = new InputUnit();
		m_List.push(iu);
		iu.m_DO = l;
		
		return i;
	}
	
	public var m_ColorPickerInput:TextInput = null;
	
	public function AddColorPicker(clr:uint):TextInput
	{
		var po:DisplayObject=null;
		if (m_Col && numChildren > 0) po = getChildAt(numChildren - 1); 

		var i:TextInput = new TextInput();
		if(po!=null) {
			m_ColList.push(i);
			i.x = po.x + po.width + 5;
			i.y = po.y;
			i.width = m_SizeX - i.x - 20;
		} else {
			i.x=20;
			i.y=m_SizeY;
			i.width=m_SizeX-40;
		}
		i.setStyle("focusRectSkin", focusRectSkinNone);
		i.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		i.setStyle("embedFonts", true);
		i.textField.antiAliasType=AntiAliasType.ADVANCED;
		i.textField.gridFitType=GridFitType.PIXEL;
		i.textField.restrict = "0-9A-Fa-f";
		i.textField.maxChars = 8;
		i.text = BaseStr.FormatColor(clr);
		addChild(i);
		if (po != null) m_SizeY = Math.max(po.y + po.height + 10, i.y + i.height + 10);
		else m_SizeY += i.height + 10;
		
		i.addEventListener(Event.CHANGE, ChangeColorPicker);
		i.addEventListener(FocusEvent.FOCUS_IN, RunColorPicker);
		i.addEventListener(MouseEvent.CLICK, RunColorPicker);
		//i.addEventListener(FocusEvent.FOCUS_OUT, CloseColorPicker);

		var iu:InputUnit = new InputUnit();
		m_List.push(iu);
		iu.m_DO = i;

		m_Col=false;
		return i;
	}

	public function CloseColorPicker(e:Event):void
	{
		if (e.currentTarget != m_ColorPickerInput) return;
		EmpireMap.Self.m_FormInputColor.Hide();
		m_ColorPickerInput = null;
	}

	public function RunColorPicker(e:Event):void
	{
		if (m_ColorPickerInput == e.currentTarget) return;
		m_ColorPickerInput = e.currentTarget as TextInput;
		EmpireMap.Self.m_FormInputColor.Run(uint("0x" + m_ColorPickerInput.text), BackColorPicker);
	}

	public function ChangeColorPicker(e:Event):void
	{
		if (e.currentTarget != m_ColorPickerInput) return;
		if (e.currentTarget is TextInput) return;
		EmpireMap.Self.m_FormInputColor.SetColor(uint("0x" + m_ColorPickerInput.text));
	}

	public function BackColorPicker():void
	{
		if (m_ColorPickerInput == null) return;
		m_ColorPickerInput.text = BaseStr.FormatColor(EmpireMap.Self.m_FormInputColor.GetColor());
		m_ColorPickerInput.dispatchEvent(new Event(Event.CHANGE));
	}

	public function AddInput(val:String, maxlen:int, digit:Boolean=true, lang:int=0, pun:Boolean=true):TextInput
	{
		var re:String="";
		if(digit) re+="0-9"; 
		if(pun) re+=".,;:!?()[]/#$%&*=\\+\\-\"";
		if(lang==Server.LANG_RUS) re+=" 'A-Za-zА-Яа-яЁё";
		else if(lang==Server.LANG_ENG) re+=" 'A-Za-z";
		
		var po:DisplayObject=null;
		if(m_Col && numChildren>0) po=getChildAt(numChildren-1); 
		
		var i:TextInput;
		i=new TextInput();
		if(po!=null) {
			m_ColList.push(i);
			i.x=po.x+po.width+5;
			i.y=po.y;
			i.width=m_SizeX-i.x-20;
		} else {
			i.x=20;
			i.y=m_SizeY;
			i.width=m_SizeX-40;
		}
		i.setStyle("focusRectSkin", focusRectSkinNone);
		i.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		i.setStyle("embedFonts", true);
		i.textField.antiAliasType=AntiAliasType.ADVANCED;
		i.textField.gridFitType=GridFitType.PIXEL;
		i.textField.restrict = re;
		i.textField.maxChars = maxlen;
		i.text=val;
		addChild(i);
		if(po!=null) m_SizeY=Math.max(po.y+po.height+10,i.y+i.height+10); 
		else m_SizeY += i.height + 10;
		
		var iu:InputUnit = new InputUnit();
		m_List.push(iu);
		iu.m_DO = i;
		
		m_Col=false;
		return i;
	}

	public function AddSlider(val:int, valmin:int, valmax:int):Slider
	{
		var po:DisplayObject=null;
		if(m_Col && numChildren>0) po=getChildAt(numChildren-1); 
		
		var i:Slider;
		i=new Slider();
		if(po!=null) {
			m_ColList.push(i);
			i.x=po.x+po.width+5;
			i.y=po.y+10;
			i.width=m_SizeX-i.x-20;
		} else {
			i.x=20;
			i.y=m_SizeY+10;
			i.width=m_SizeX-40;
		}
		i.minimum=valmin;
		i.maximum=valmax;
		i.value=val;
		addChild(i);
		if(po!=null) m_SizeY=Math.max(po.y+po.height+10,i.y+i.height+10); 
		else m_SizeY+=10+i.height+10;

		var iu:InputUnit = new InputUnit();
		m_List.push(iu);
		iu.m_DO = i;
		
		m_Col=false;
		return i;
	}

	public function AddArea(h:int, ww:Boolean, val:String, maxlen:int, digit:Boolean=true, lang:int=0, pun:Boolean=true):TextArea
	{
		var re:String="";
		if(digit) re+="0-9"; 
		if(pun) re+="\t.,;:!?()[]{}_/#$%&*=\\+\\-\"";
		if(lang==Server.LANG_RUS) re+=" 'A-Za-zА-Яа-яЁё";
		else if(lang==Server.LANG_ENG) re+=" 'A-Za-z";

		var a:TextArea;
		a=new TextArea();
		a.x=20;
		a.y=m_SizeY;
		a.width=m_SizeX-40;
		a.height=h;

		a.setStyle("upSkin", TextInput_upSkin);
		a.setStyle("focusRectSkin", focusRectSkinNone);
		a.setStyle("textFormat", new TextFormat("Calibri",14,0xffffff));
		a.setStyle("embedFonts", true);
		a.textField.antiAliasType=AntiAliasType.ADVANCED;
		a.textField.gridFitType=GridFitType.PIXEL;
		Common.UIEditBar(a);

		a.restrict = re;
		a.maxChars = maxlen;
		a.wordWrap=ww;
		a.text=val;
		addChild(a);
		m_SizeY+=a.height+10;

		var iu:InputUnit = new InputUnit();
		m_List.push(iu);
		iu.m_DO = a;

		m_Col=false;
		return a;
	}

	public function AddComboBox(w:int=0):ComboBox
	{
		var po:DisplayObject=null;
		if(m_Col && numChildren>0) po=getChildAt(numChildren-1); 
		
		var b:ComboBox;
		b=new ComboBox();
		if(po!=null) {
			m_ColList.push(b);
			b.x=po.x+po.width+5;
			b.y=po.y;
			b.width=m_SizeX-b.x-20;
		} else {
			b.x=20;
			b.y=m_SizeY;
			if(w<=0) b.width=m_SizeX-40;
			else b.width=w;
		}
		Common.UIStdComboBox(b);
		b.rowCount=10;
		addChild(b);
		if(po!=null) m_SizeY=Math.max(po.y+po.height+10,b.y+b.height+10);
		else m_SizeY+=b.height+10;
		m_LastObj = b;
		
		var iu:InputUnit = new InputUnit();
		m_List.push(iu);
		iu.m_DO = b;

		m_Col=false;
		return b;
	}
	
	public function AddItem(txt:String, val:Object, sel:Boolean=false):void
	{
		if(m_LastObj==null) return;
		
		if(m_LastObj is ComboBox) {
			(m_LastObj as ComboBox).addItem( { label:txt, data:val } );
			if(sel) (m_LastObj as ComboBox).selectedIndex=(m_LastObj as ComboBox).length-1; 
		}
	}
	
	public function Get(no:int):DisplayObject
	{
		if(no<0 || no>=numChildren) return null;
		return getChildAt(no);
	}

	public function clickClose(event:Event):void
	{
		if(FormMessageBox.Self.visible) return;
		Hide();
	}

	public function clickSave(event:Event):void
	{
		if(FormMessageBox.Self.visible) return;
		Hide();
		if(m_Fun!=null) m_Fun();
	}

	public function GetInput(no:int):DisplayObject
	{
		var i:int;
		//var str:String="";
		for(i=0;i<numChildren;i++) {
			var obj:DisplayObject=getChildAt(i);
			if((obj is TextInput) || (obj is TextArea) || (obj is ComboBox) || (obj is CheckBox) || (obj is Slider)) {
				no--;
				if(no>=0) continue;

				return obj;				
				break; 
			}
		}	
		return null;	
	}

	public function GetStr(no:int):String
	{
		var obj:DisplayObject=GetInput(no);
		if(obj==null) return "";

		if(obj is TextInput) return (obj as TextInput).text;
		else if(obj is TextArea) return (obj as TextArea).text;
		else if (obj is ComboBox) {
			var cb:ComboBox = (obj as ComboBox);
			if (cb.selectedItem != null) return cb.selectedItem.data;
			else if (cb.editable) return cb.text;
			else return "";
		}
		else if(obj is CheckBox) {
			if((obj as CheckBox).selected) return "1";
			else return "0";
		}
		else if(obj is Slider) return (obj as Slider).value.toString();
		return "";
	}

	public function GetInt(no:int):int
	{
		return int(GetStr(no));
	}
}

}

import flash.display.DisplayObject;

class InputUnit
{
	public var m_DO:DisplayObject = null;
	public var m_Data:Object = null;
	
	public function InputUnit():void
	{
	}

	public function Clear():void
	{
		m_DO = null;
		m_Data = null;
	}
}
