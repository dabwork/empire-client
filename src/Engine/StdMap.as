// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import Base.*;
import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;
import flash.system.*;

public class StdMap extends Sprite
{
	static public const DblClickTime:int = 350;

	public static var Main:StdMap = null;
	
	static public const Txt:Object = {
		ButYes:"ДА",
		ButNo:"НЕТ",
		ButClose:"ЗАКРЫТЬ",
		ButSave:"СОХРАНИТЬ",
		ButCancel:"ОТМЕНИТЬ",

		LostQuery:"Сервер не ответил на запрос",
		NoServer:"Связь с сервером прервана.",

		FormMessageBoxMsg:"СООБЩЕНИЕ",
		FormMessageBoxQuery:"ВОПРОС",
		FormMessageBoxErr:"ОШИБКА"
	}

	public var m_Debug:Boolean = false;
	public var m_DebugFlag:uint = 0;

	public var m_CurTime:Number = 0;
	public var m_ServerCalcTime:Number = 0;
	
	private var m_IsResize:Boolean = false;
	public var m_StageSizeX:int = 0;
	public var m_StageSizeY:int = 0;
	public var m_Scale:Number = 1.0;

	public var test_text:TextField = null;
	public var test_text_cnt:int = 0;

	public var m_FloatLayer:Sprite;

	public var m_FormInputEx:FormInputEx;
	public var m_FormInputColor:FormInputColor;
	public var m_FormInputTimeline:FormInputTimeline;
	public var m_FormHint:FormHint;
	
	public var m_PopupMenu:CtrlPopupMenu = null;

	public function get FI():FormInputEx { return m_FormInputEx; }
	
	public function get PopupMenu():CtrlPopupMenu { return m_PopupMenu; }

	public function StdMap()
	{
		if (Main == null) Main = this;

		addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
	}
	
	public function onAddToStage(e:Event):void
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		C3D.stage = stage;

		init();
	}

	public function init():void
	{
		m_CurTime = GetTime();
		m_ServerCalcTime = m_CurTime;

		m_IsResize = false;
		m_StageSizeX = stage.stageWidth;
		m_StageSizeY = stage.stageHeight;

		if (Capabilities.screenDPI > 200 && Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY) >= 720) {
			m_Scale = 1.5;
		}

		m_FloatLayer = new Sprite();
		addChild(m_FloatLayer);

		m_FormInputEx=new FormInputEx();
		addIntoFloat(m_FormInputEx);
		
		m_FormInputColor=new FormInputColor();
		addIntoFloat(m_FormInputColor);
		
		m_FormInputTimeline=new FormInputTimeline();
		addIntoFloat(m_FormInputTimeline);

		FormMessageBox.Self=new FormMessageBox();
		FormMessageBox.Self.visible=false;
		addChild(FormMessageBox.Self);

		m_FormHint=new FormHint(this);
		addChild(m_FormHint);
//			m_FormHint.Show(Common.Hint.Load);

		if(false) {
			test_text = new TextField();
			test_text.autoSize = TextFieldAutoSize.LEFT;
			test_text.text = "TestText ";
			test_text.textColor = 0xff0000;
			test_text.backgroundColor = 0xffffff;
			addChild(test_text);
		}

		var cm:ContextMenu;
		cm=new ContextMenu();
		cm.hideBuiltInItems();
		cm.builtInItems.quality=true;
		cm.addEventListener(ContextMenuEvent.MENU_SELECT, onContextMenuSelectHandler);
		//m_ContextMenu.addEventListener(Event.ACTIVATE, ContextMenuActivate);
		//m_ContextMenu.addEventListener(Event.DEACTIVATE, ContextMenuDeactivate);
		contextMenu=cm;

		stage.addEventListener(Event.RESIZE, onStageResize,false,999);// , true, 999);
		stage.addEventListener(Event.MOUSE_LEAVE,onStageMouseLeave);
		stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler,false);
		//stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler,false,-1000000000);
		stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler,false);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheelHandler);
		stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);//,true);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);//,true);
		stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDownHandler);
		stage.addEventListener(Event.DEACTIVATE,onDeactivate);
		stage.addEventListener(Event.ACTIVATE,onActivate);
		stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMoveHandler, false);
	}
	
	public function InitializeC3D():void
	{
	}
	
	public function addBeforeFloat(d:DisplayObject):void
	{
		var i:int = getChildIndex(m_FloatLayer);
		addChildAt(d,i);
	}
	
	public function addIntoFloat(d:DisplayObject):void
	{
		m_FloatLayer.addChild(d);
	}
	
	public function addAfterFloat(d:DisplayObject):void
	{
		var i:int = getChildIndex(FormMessageBox.Self);
		addChildAt(d,i);
	}

	public function FloatTop(e:DisplayObject):void
	{
//		if (m_FloatLayer.getChildIndex(e) < 0) return;
		m_FloatLayer.setChildIndex(e, m_FloatLayer.numChildren - 1);
	}

	public static function GetTime():Number
	{
		return (new Date()).getTime();
	}
	
	public function IsResize():Boolean { return m_IsResize; }
	
	private var m_MouseLock:Boolean = false;
		
	public function MouseLock():void
	{
		if (m_MouseLock) return;
		m_MouseLock = true;

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler, false, 999);

		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, true, 999);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, true, 999);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler, true, 999);
	}

	public function MouseUnlock():void
	{
		if (!m_MouseLock) return;
		m_MouseLock = false;

		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, false);

		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, true);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler, true);
	}

	public function AddDebugMsg(str:String):void
	{
	}
	
	public function Hint(str:String):void
	{
		m_FormHint.Show(str);
	}
	
	public function ErrorFromServer(err:uint, errstr:String = ''):Boolean
	{
		Server.Self.ConnectClose();
		return true;
	}

	public function onContextMenuSelectHandler(event:ContextMenuEvent):void
	{
		MouseUnlock();
	}

	public function onActivate(e:Event):void
	{
	}

	public function onDeactivate(e:Event):void
	{
		MouseUnlock();
	}
	
	public function onStageResize(e:Event):void 
	{
		m_IsResize = (m_StageSizeX != stage.stageWidth) || (m_StageSizeY != stage.stageHeight);
		m_StageSizeX = stage.stageWidth;
		m_StageSizeY = stage.stageHeight;
		
		C3D.Resize();
		m_FormHint.Update();
	}
	
	public function onStageMouseLeave(e:Event):void
	{
	}
	
	public function onMouseDownHandler(e:MouseEvent):void
	{
	}

	public function onMouseUpHandler(e:MouseEvent):void
	{
	}
	
	public function onMouseMoveHandler(e:MouseEvent):void
	{
	}

	public function onMouseWheelHandler(e:MouseEvent):void
	{
	}

	public function onRightMouseDownHandler(e:MouseEvent):void
	{
	}

	public function onKeyUpHandler(e:KeyboardEvent):void
	{
	}

	public function onKeyDownHandler(e:KeyboardEvent):void
	{
	}

	public function onTouchMoveHandler(e:TouchEvent):void
	{
	}

	public function InfoHide():void
	{
	}
	
	public function FormHideAll():void
	{
		FormMessageBox.Self.Hide();

		m_FormInputEx.Hide();
		m_FormInputColor.Hide();
		m_FormInputTimeline.Hide();
		
		FI.Hide();
	}
	
	public function IsFocusInput():Boolean
	{
		if ((stage.focus is TextField) && ((stage.focus as TextField).type == TextFieldType.INPUT)) return true;
		return false;
	}

	public function IsFocusInputAndMouse():Boolean
	{
		if ((stage.focus is TextField) && ((stage.focus as TextField).type == TextFieldType.INPUT)) {
			var tf:TextField = stage.focus as TextField;
			if (tf.hitTestPoint(stage.mouseX, stage.mouseY)) return true;
		}
		return false;
	}
}
	
}