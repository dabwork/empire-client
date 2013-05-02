package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;

public class FormFleetType extends Sprite
{
/*	private var m_Map:EmpireMap;

	public static const SizeX:int = 500;
	public static const SizeY:int = 480;

	public var m_Frame:Sprite=new GrFrame();
	public var m_Title:TextField=new TextField();
	public var m_ButClose:Button = new Button();
	public var m_ButChange:Button = new Button();
	
	public var m_List:Array = new Array();
	
	public var m_Cur:int = -1;

	public function FormFleetType(map:EmpireMap)
	{
		var i:int;
		m_Map = map;

		m_Frame.width = SizeX;
		m_Frame.height = SizeY;
		addChild(m_Frame);

		m_Title.x = 10;
		m_Title.y = 5;
		m_Title.width = 1;
		m_Title.height = 1;
		m_Title.type = TextFieldType.DYNAMIC;
		m_Title.selectable = false;
		m_Title.border = false;
		m_Title.background = false;
		m_Title.multiline = false;
		m_Title.autoSize = TextFieldAutoSize.LEFT;
		m_Title.antiAliasType = AntiAliasType.ADVANCED;
		m_Title.gridFitType = GridFitType.PIXEL;
		m_Title.defaultTextFormat = new TextFormat("Calibri", 18, 16776960);
		m_Title.embedFonts = true;
		m_Title.text = Common.Txt.FormFleetTypeCaption;
		addChild(m_Title);		

		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width = 90;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		addChild(m_ButClose);
		
		EmpireMap.Self.stage.addEventListener(Event.RESIZE, onStageResize);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
	}
	
	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<SizeX && mouseY>=0 && mouseY<SizeY) return true;
		return false;
	}

	public function onStageResize(e:Event):void
	{
		if (visible && EmpireMap.Self.IsResize()) {
			x=Math.ceil(parent.stage.stageWidth/2-width/2);
			y=Math.ceil(parent.stage.stageHeight/2-height/2);
		}
	}

	public function Hide():void
	{
		visible = false;
	}
	
	public function clickClose(...args):void
	{
		Hide();
	}

	public function onMouseDown(e:MouseEvent) : void
	{
		m_Map.FloatTop(this);
		e.stopImmediatePropagation();

		var i:int = Pick();
		if (i >= 0) {
			if (m_Cur != 0 && (m_Map.m_FormFleetBar.m_Formation & (1 << (3 + m_Cur - 1))) == 0) {
				FleetTypeOpen();
			} else {
				FleetTypeActivate();
			}
			
			return;
		}
		
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true, 999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	public function onMouseUp(event:MouseEvent) : void
	{
		event.stopImmediatePropagation();
	}

	public function onMouseMove(e:MouseEvent) : void
	{
		e.stopImmediatePropagation();
		
		var i:int = Pick();
		if (i != m_Cur) {
			m_Cur = i;
			Update();
		}
		
		m_Map.m_Info.Hide();
	}
	
	protected function onMouseOutHandler(event:MouseEvent) : void
	{
		if (FormMessageBox.Self.visible) return;
		
		if(m_Cur!=-1) {
			m_Cur = -1;
			Update();
		}

		return;
	}

	public function Show():void
	{
		m_Map.FloatTop(this);

		visible = true;
		
		if (m_List.length <= 0) {
			TypeAdd(100, 100, "Fleet0p", Common.Txt.FormFleetType0Caption+" (6)", Common.Txt.FormFleetType0Txt);
			TypeAdd(250, 100, "Fleet1p", Common.Txt.FormFleetType1Caption+" (7)", Common.Txt.FormFleetType1Txt);
			TypeAdd(400, 100, "Fleet2p", Common.Txt.FormFleetType2Caption+" (7)", Common.Txt.FormFleetType2Txt);
			TypeAdd(100, 300, "Fleet3p", Common.Txt.FormFleetType3Caption+" (6)", Common.Txt.FormFleetType3Txt);
			TypeAdd(250, 300, "Fleet4p", Common.Txt.FormFleetType4Caption+" (7)", Common.Txt.FormFleetType4Txt);
		}

		m_Cur = -1;
		Update();

		x=Math.ceil(parent.stage.stageWidth/2-width/2);
		y=Math.ceil(parent.stage.stageHeight/2-height/2);
	}

	public function Update():void
	{
		var i:int;
		var obj:Object;

		if (!visible) return;

		for (i = 0; i < m_List.length; i++) {
			obj = m_List[i];

			if ((m_Map.m_FormFleetBar.m_Formation & 7) == i) {
				obj.But.visible = false;

			} else if(i!=0 && (m_Map.m_FormFleetBar.m_Formation & (1<<(3+i-1)))==0) {
				obj.But.visible = true;
				obj.But.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormFleetTypeOpen,"<Val>",BaseStr.FormatBigInt(Common.FleetFormationCost[i])));
				obj.But.x = obj.Img.x - (obj.But.width >> 1);
				obj.But.y = obj.Img.y + 30;

			} else {
				obj.But.visible = true;
				obj.But.text = Common.Txt.FormFleetTypeActivate;
				obj.But.x = obj.Img.x - (obj.But.width >> 1);
				obj.But.y = obj.Img.y + 30;
			}

			if (i == m_Cur) {
				obj.But.backgroundColor = 0x00000ff;
			} else {
				obj.But.backgroundColor = 0x0000000;
			}
		}

		m_ButClose.x = SizeX - 15 - m_ButClose.width;
		m_ButClose.y = SizeY - m_ButClose.height - 15;
	}
	
	public function TypeAdd(px:int, py:int, imgname:String, cap:String, txt:String):void
	{
		var obj:Object=new Object();
		m_List.push(obj);
		
		var cl:Class=ApplicationDomain.currentDomain.getDefinition(imgname) as Class;
		obj.Img = new cl();
		obj.Img.x = px;
		obj.Img.y = py;
		addChild(obj.Img);

		obj.Name = new TextField();
		obj.Name.width = 1;
		obj.Name.height = 1;
		obj.Name.type = TextFieldType.DYNAMIC;
		obj.Name.selectable = false;
		obj.Name.border = false;
		obj.Name.background = false;
		obj.Name.multiline = false;
		obj.Name.autoSize = TextFieldAutoSize.LEFT;
		obj.Name.antiAliasType = AntiAliasType.ADVANCED;
		obj.Name.gridFitType = GridFitType.PIXEL;
		obj.Name.defaultTextFormat = new TextFormat("Calibri", 15, 0x00f6ff);
		obj.Name.embedFonts = true;
		obj.Name.htmlText = cap;
		obj.Name.x = px - (obj.Name.width >> 1);
		obj.Name.y = py + 60;
		addChild(obj.Name);

		obj.Txt = new TextField();
		obj.Txt.width = 1;
		obj.Txt.height = 1;
		obj.Txt.type = TextFieldType.DYNAMIC;
		obj.Txt.selectable = false;
		obj.Txt.border = false;
		obj.Txt.background = false;
		obj.Txt.multiline = true;
		obj.Txt.autoSize = TextFieldAutoSize.LEFT;
		obj.Txt.antiAliasType = AntiAliasType.ADVANCED;
		obj.Txt.gridFitType = GridFitType.PIXEL;
		obj.Txt.defaultTextFormat = new TextFormat("Calibri", 13, 0xffffff);
		obj.Txt.embedFonts = true;
		obj.Txt.htmlText = BaseStr.FormatTag(txt);
		obj.Txt.x = px - (obj.Txt.width >> 1);
		obj.Txt.y = obj.Name.y+obj.Name.height;
		addChild(obj.Txt);

		obj.But = new TextField();
		obj.But.width = 1;
		obj.But.height = 1;
		obj.But.type = TextFieldType.DYNAMIC;
		obj.But.selectable = false;
		obj.But.border = false;
		obj.But.background=true;
		obj.But.backgroundColor = 0x0000000;
		obj.But.alpha = 0.8;
		obj.But.multiline = false;
		obj.But.autoSize = TextFieldAutoSize.LEFT;
		obj.But.antiAliasType = AntiAliasType.ADVANCED;
		obj.But.gridFitType = GridFitType.PIXEL;
		obj.But.defaultTextFormat = new TextFormat("Calibri", 13, 0xffffff);
		obj.But.embedFonts = true;
		addChild(obj.But);
	}
	
	public function Pick():int
	{
		var i:int;
		var obj:Object;

		for (i = 0; i < m_List.length; i++) {
			obj = m_List[i];

			if (!obj.But.visible) continue;

			if (obj.But.hitTestPoint(stage.mouseX, stage.mouseY)) return i;
		}
		
		return -1;
	}

	public function FleetTypeOpen():void
	{
		if (m_Cur <= 0) return;
		else if (m_Cur >= 5) return;

		if (m_Map.m_FormFleetBar.m_FleetMoney < Common.FleetFormationCost[m_Cur]) {
			FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose);
			return;
		}
		
		FormMessageBox.Run(BaseStr.FormatTag(BaseStr.Replace(Common.Txt.FormFleetTypeOpenQuery, "<Val>", BaseStr.FormatBigInt(Common.FleetFormationCost[m_Cur]))), StdMap.Txt.ButNo, StdMap.Txt.ButYes, FleetTypeOpenProcess);
	}

	public function FleetTypeOpenProcess():void
	{
		//var ordenum:uint =
		Server.Self.Query("emfleetspecial", "&type=6&t=" + m_Cur.toString(), AnswerSpecial, false);
		//m_Map.m_FormFleetBar.m_OrderWaitEnd.push(ordenum);

		//m_Map.m_FormFleetBar.m_Formation |= (1 << (3 + m_Cur - 1));
		
		Update();
	}
	
	public function FleetTypeActivate():void
	{
		var i:int;

		if (m_Cur < 0) return;
		else if (m_Cur >= 5) return;
		
		while(true) {
			//var cotl:SpaceCotl = Hyperspace.Self.GetCotl(m_Map.m_RootCotlId);
			//if (cotl != null && m_Map.OnOrbitCotl(cotl, m_Map.m_FleetPosX, m_Map.m_FleetPosY)) break;
			if (m_Map.OnOrbitCotl(m_Map.m_RootCotlId)) break;
			
			var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
			if (user != null) {
				//cotl = Hyperspace.Self.GetCotl(user.m_CitadelCotlId);
				//if (cotl != null && m_Map.OnOrbitCotl(cotl, m_Map.m_FleetPosX, m_Map.m_FleetPosY)) break;
				for (i = 0; i < Common.CitadelMax; i++) {
					if (m_Map.m_CitadelNum[i] < 0) continue;
					if (m_Map.OnOrbitCotl(m_Map.m_CitadelCotlId[i])) break;
				}
				if (i < Common.CitadelMax) break;
				//if (m_Map.OnOrbitCotl(user.m_CitadelCotlId)) break;
			}

			FormMessageBox.Run(Common.Txt.FormFleetTypeNoHomeOrbit, Common.Txt.ButClose);
			return;
		}
		
		var mul:int = Common.FleetFormationCargoMul[m_Cur];
		if (mul <= 1) {
			for (i = 0; i < 8; i++) if (m_Map.m_FormFleetItem.m_FleetItem[i].m_Type != 0) break;
			if (i < 8) {
				FormMessageBox.Run(Common.Txt.FormFleetTypeNoChangeEmptyTransportCargo, Common.Txt.ButClose);
				return;
			}
		} else {
			for (i = 0; i < 8; i++) {
				if (m_Map.m_FormFleetItem.m_FleetItem[i].m_Type == 0) continue;
				var item:Item = UserList.Self.GetItem(m_Map.m_FormFleetItem.m_FleetItem[i].m_Type & 0xffff);
				if (item == null) break;
				if (m_Map.m_FormFleetItem.m_FleetItem[i].m_Cnt > item.m_StackMax * mul) break;
			}
			if (i < 8) {
				FormMessageBox.Run(Common.Txt.FormFleetTypeNoChangeLimitTransportCargo, Common.Txt.ButClose);
				return;
			}
		}

		if (m_Map.m_FormFleetBar.EmpireFleetCalcMass() > Common.FleetMassMax[m_Cur & 7]) {
			FormMessageBox.Run(Common.Txt.FormFleetTypeNoChangeLimitMass, Common.Txt.ButClose);
			return;
		}
		
		var nscnt:int = m_Cur & 7;
		if (nscnt == 1 || nscnt == 2 || nscnt == 4) nscnt = Common.FleetSlotMax;
		else nscnt = Common.FleetSlotMax - 1;

		if (m_Map.m_FormFleetBar.SlotCnt() > nscnt) {
			for (i = nscnt; i < m_Map.m_FormFleetBar.SlotCnt(); i++) {
				if (m_Map.m_FormFleetBar.m_FleetSlot[i].m_Type != 0) {
					FormMessageBox.Run(Common.Txt.FormFleetTypeNoChangeLimitSlot, Common.Txt.ButClose);
					return;
				}
			}
		}

		Server.Self.Query("emfleetspecial", "&type=7&t=" + m_Cur.toString(), AnswerSpecial, false);

		//m_Map.m_FormFleetBar.m_Formation = (m_Map.m_FormFleetBar.m_Formation & (~7)) | m_Cur;

		Update();
	}
	
	public function AnswerSpecial(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;
		
		var err:uint = buf.readUnsignedByte();
//		var ordernum:uint = buf.readUnsignedInt();
		
//		var i:int = m_Map.m_FormFleetBar.m_OrderWaitEnd.indexOf(ordernum);
//		if (i >= 0) m_Map.m_FormFleetBar.m_OrderWaitEnd.splice(i, 1);

		if(!err) m_Map.m_UserVersion=0;
		else if (err == Server.ErrorNoEnoughMoney) { FormMessageBox.Run(Common.Txt.NoEnoughMoney, Common.Txt.ButClose); }
		else if (err == Server.ErrorOverload) { FormMessageBox.Run(Common.Txt.ErrOverload, Common.Txt.ButClose); }
		else m_Map.ErrorFromServer(err);

//		m_Map.m_FormFleetBar.QueryFleet();
	}*/
}

}
