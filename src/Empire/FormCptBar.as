// Copyright (C) 2013 Elemental Games. All rights reserved.

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

public class FormCptBar extends Sprite
{
	private var m_Map:EmpireMap;

	//static public const SizeX:int=(93+5)*3;
	//static public const SizeY:int=124;

	static public const FaceSizeX:int=Math.floor(93*0.6);//46;
	static public const FaceSizeY:int=Math.floor(104*0.6);

	public var m_SizeX:int=0;
	public var m_SizeY:int=0;

	public var m_CptVersion:uint=0;

	public var m_CptDsc:Array=new Array();
	public var m_QueryCptDscTimer:Number=0;

	public var m_Gr:Array = new Array();
	
	public var m_QBFrame:Sprite = null;
	public var m_QBImg:Sprite = null;

	public var m_ActionCptId:uint=0;

	public var m_ShowNewCpt:Boolean=true;

	public var m_ShowItem:Boolean=false;
	public var m_CptIdCur:uint=0;

	static public const SlotPos:Array =new Array(
		15,  115,  15, 195,  15, 275,  15, 355,
		255, 115, 255, 195, 255, 275, 255, 355,
		95,  315, 175, 315,  95, 395, 175, 395,
		55,   35, 135,  15, 215,  35,
		135, 235);
	static public const SlotSize:int=70;
	
	public var m_LayerItemBG:Sprite=null;
	public var m_LayerItem:Sprite=null;
	
	public var m_Slot:Array=new Array();

	public function FormCptBar(map:EmpireMap)
	{
		m_Map=map;
		
		var i:int;
		var clr:uint;
		var sp:Sprite;

		x=3;
		y=120;

		m_LayerItemBG=new Sprite();
		addChild(m_LayerItemBG);
		m_LayerItemBG.x=73-3;
		m_LayerItemBG.y=30-50;

		m_LayerItem=new Sprite();
		addChild(m_LayerItem);
		m_LayerItem.x=73-3;
		m_LayerItem.y=30-50;

		for(i=0;i<Common.CptMax;i++) {
//			m_Cpt.push(new Cpt());

			var gr:Object=new Object();
			m_Gr.push(gr);
			gr.Race=Common.RaceNone;
			gr.Face=0;

			var fr:GrFrame=new GrFrame();
			addChild(fr);
			//fr.x=i*(93+5)-2;
			//fr.y=-2;
			fr.width=FaceSizeX+4;//93+4;
			fr.height=FaceSizeY+4;//124+4;
			gr.Frame=fr;

			var bm:Bitmap=new Bitmap();
			addChild(bm);
			//bm.x=i*(93+5);
			bm.y=0;
//			bm.smoothing=true;
//			bm.pixelSnapping=PixelSnapping.NEVER;
			gr.FaceBM=bm;

			/*var txt:TextField=new TextField();
			txt.x=0;//i*(93+5);
			txt.y=104-1;
			txt.width=93;
			txt.height=20+2;
			txt.type=TextFieldType.DYNAMIC;
			txt.selectable=false;
			txt.border=false;
			txt.background=false;
			txt.multiline=false;
			txt.autoSize=TextFieldAutoSize.CENTER;
			txt.antiAliasType=AntiAliasType.ADVANCED;
			txt.gridFitType=GridFitType.PIXEL;
			txt.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
			txt.embedFonts=true;
			addChild(txt);
			gr.NameTxt=txt;*/

			gr.Menu=new MMButOptions();
			addChild(gr.Menu);
			gr.Menu.y=124-gr.Menu.height-10;
		}

		m_QBFrame = new GrFrame();
		m_QBFrame.visible = false;
		addChild(m_QBFrame);
		
		for(i=0;i<Common.CptHoldSlotMax;i++) {
			var obj:Object=new Object();
			m_Slot.push(obj);

			sp=new Sprite();
			obj.FrameN=sp;
			m_LayerItem.addChild(sp);
			sp.graphics.lineStyle(1.0,0x069ee5,0.9,true);
			clr=0;
			if(Common.CptHoldSlotType[i]==Common.HoldSlotTypeBlue) clr=0x132633;
			else if(Common.CptHoldSlotType[i]==Common.HoldSlotTypeGreen) clr=0x0c4610;
			else if(Common.CptHoldSlotType[i]==Common.HoldSlotTypeRed) clr=0x460c0c;
			else if(Common.CptHoldSlotType[i]==Common.HoldSlotTypeYellow) clr=0x2f2f06;
			sp.graphics.beginFill(clr,0.90);
			sp.graphics.drawRoundRect(SlotPos[i*2+0],SlotPos[i*2+1],SlotSize,SlotSize,20,20);
			sp.graphics.endFill();
		}

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	public function Clear():void
	{
		var i:int;

		m_CptVersion=0;

		m_QueryCptDscTimer=0;
		//for(i=0;i<Common.CptMax;i++) m_Cpt[i].m_Id=0;

		m_ShowNewCpt=true;
	}

	public function StageResize():void
	{
		if (!visible) return;
		//&& EmpireMap.Self.IsResize()) Show();
		Update();
		ItemUpdate();
	}

	public function Show():void
	{
		m_Map.FloatTop(this);
		visible=true;

		//x=((m_Map.m_FormChat.width+m_Map.m_FormInfoBar.m_MBBG.x)>>1)-(SizeX>>1);
		//y=m_Map.stage.stageHeight-FormInfoBar.BarHeight-SizeY;

		Update();
		ItemUpdate();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<(m_SizeX+5) && mouseY>=0 && mouseY<(m_SizeY+5)) return true;
		if (m_LayerItemBG.visible && m_LayerItemBG.hitTestPoint(x + mouseX, y + mouseY)) return true;
		if (m_QBFrame.visible && m_QBFrame.hitTestPoint(x + mouseX, y + mouseY)) return true;
		return false;
	}

	public function IsMouseShipIn():Boolean
	{
		return false;
	}

	public function Update():void
	{
		if(!visible) return;

		var i:int;
		var gr:Object;

		m_SizeX=FaceSizeX+4;
		m_SizeY=0;

		var user:User=null;
		while(true) {
			user=UserList.Self.GetUser(Server.Self.m_UserId);
			if(user==null) break;

			if(user.m_Cpt==null) { user=null; break; }
			if(user.m_Cpt.length!=Common.CptMax) { user=null; break;}
			break;
		}

		if(user==null) {
			for(i=0;i<Common.CptMax;i++) {
				gr=m_Gr[i];

				if(dsc==null) {
					//gr.NameTxt.visible=false;
					gr.Frame.visible=false;
					gr.Menu.visible=false;
					gr.FaceBM.bitmapData=null;
					gr.Race=Common.RaceNone;
					gr.Face=0;
				}
			}
			return;
		}

		for(i=0;i<Common.CptMax;i++) {
			var cpt:Cpt=user.m_Cpt[i];
			var dsc:Object=CptDsc(cpt.m_Id);
			gr=m_Gr[i];

			if(dsc==null) {
				//gr.NameTxt.visible=false;
				gr.Frame.visible=false;
				gr.Menu.visible=false;
				gr.FaceBM.bitmapData=null;
				gr.Race=Common.RaceNone;
				gr.Face=0;
			} else {
				if(m_ShowItem && cpt.m_Id==m_CptIdCur) gr.Frame.visible=false;
				else gr.Frame.visible=true;
				//gr.NameTxt.visible=true;
				gr.Menu.visible=true;

				//if(gr.NameTxt.text!=dsc.Name) gr.NameTxt.text=dsc.Name;

				if(gr.Race!=dsc.Race || gr.Face!=dsc.Face) {
					gr.Race=dsc.Race;
					gr.Face=dsc.Face;
					gr.FaceBM.bitmapData=null;
				}

				if(gr.FaceBM.bitmapData==null) {
					var clname:String=(dsc.Face % Common.RaceFaceCnt[dsc.Race]).toString();
					if(clname.length==1) clname="0"+clname;
					clname="Face"+Common.RaceSysName[dsc.Race]+clname;

					var cl:Class=ApplicationDomain.currentDomain.getDefinition(clname) as Class;
					gr.FaceBM.bitmapData=new cl(93,104);
					gr.FaceBM.width=FaceSizeX;
					gr.FaceBM.height=FaceSizeY;
				}

				gr.Frame.x=0;
				gr.Frame.y=m_SizeY;
				gr.FaceBM.x=2;
				gr.FaceBM.y=m_SizeY+2;
				//gr.NameTxt.x=m_SizeX+(93>>1)-(gr.NameTxt.width>>1);
				//gr.Menu.x=m_SizeX+92+2-gr.Menu.width;
				gr.Menu.x=m_SizeX-16;
				gr.Menu.y=m_SizeY+FaceSizeY+4-18;
				gr.Menu.width=20;
				gr.Menu.height=20;

				//m_SizeX+=93+5;
				m_SizeY+=FaceSizeY+6;
			}
		}

		if (m_Map.m_FormFleetBar.m_QuarkBaseType != 0) {
			m_QBFrame.x = 0;
			m_QBFrame.y = m_SizeY;
			m_QBFrame.width = 40;
			m_QBFrame.height = 40;
			m_QBFrame.visible = true;

			if(m_QBImg==null) {
				m_QBImg = GraphShip.GetImageByType(Common.ShipTypeQuarkBase, Common.RaceNone);
				m_QBImg.scaleX = 0.5;
				m_QBImg.scaleY = 0.5;
				addChild(m_QBImg);
			}
			if (m_QBImg!=null) {
				m_QBImg.x = 20;
				m_QBImg.y = m_SizeY + 20;
				m_QBImg.visible = true;
			}
			
		} else {
			m_QBFrame.visible = false;
			if (m_QBImg != null) m_QBImg.visible = false;
		}

//		x=((m_Map.m_FormChat.width+m_Map.m_FormInfoBar.m_MBBG.x)>>1)-(m_SizeX>>1);
//		y=m_Map.stage.stageHeight-FormInfoBar.BarHeight-SizeY;

		//x=m_Map.stage.stageWidth-m_SizeX-10;
		//y=m_Map.stage.stageHeight-FormInfoBar.BarHeight-FormFleetBar.SizeY-SizeY-56-2;
	}

	public function QueryCpt():void
	{
		if (Server.Self.IsSendCommand("emcpt")) return;

		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;
		var sl:SaveLoad=new SaveLoad();
		sl.SaveBegin(ba);

		sl.SaveDword(Server.Self.m_ServerNum);
//		sl.SaveDword(Server.Self.m_ConnNo);

		sl.SaveEnd();

		Server.Self.QuerySmall("emcpt",true,Server.sqCpt,ba,AnswerCpt);

//		Server.Self.Query("emcpt",'',AnswerCpt,false);
	}

	public function AnswerCpt(errcode:uint, buf:ByteArray):void
	{
		var i:int,u:int;

		if (EmpireMap.Self.ErrorFromServer(errcode)) return;
		if (buf == null || buf.length <= 0) throw Error("AnswerCpt");

		if (!(m_Map.m_ActionNoComplate >= m_Map.m_LoadUserAfterActionNo || (m_Map.m_LoadUserAfterActionNo_Time + 5000) < Common.GetTime())) {
//trace("skip session user");
			return;
		}

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		var ver:uint=sl.LoadDword();
		if(ver<m_CptVersion) return;

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;

		if(user.m_Cpt==null) user.m_Cpt=new Array();
		if(user.m_Cpt.length!=Common.CptMax) {
			user.m_Cpt.length=0;
			for(i=0;i<Common.CptMax;i++) user.m_Cpt.push(new Cpt());
		}

		var cptlistempty:Boolean=true;

		for(i=0;i<Common.CptMax;i++) {
			var cpt:Cpt=user.m_Cpt[i];
			cpt.m_Id=sl.LoadDword();
			if(cpt.m_Id==0) continue;
			
			cptlistempty=false;

			cpt.m_CotlId=sl.LoadInt();
			cpt.m_SectorX=sl.LoadInt();
			cpt.m_SectorY=sl.LoadInt();
//			cpt.m_ArrivalTime=1000*sl.LoadDword();
			cpt.m_PlanetNum=sl.LoadInt();
//trace("AnswerCpt","Pos:",cpt.m_CotlId,cpt.m_SectorX,cpt.m_SectorY,cpt.m_PlanetNum);

//			cpt.m_StatTransportCnt=sl.LoadInt();
//			cpt.m_StatCorvetteCnt=sl.LoadInt();
//			cpt.m_StatCruiserCnt=sl.LoadInt();
//			cpt.m_StatDreadnoughtCnt=sl.LoadInt();
//			cpt.m_StatInvaderCnt=sl.LoadInt();
//			cpt.m_StatDevastatorCnt=sl.LoadInt();
//			cpt.m_StatGroupCnt=sl.LoadInt();
//trace(cpt.m_StatTransportCnt,cpt.m_StatCorvetteCnt,cpt.m_StatCruiserCnt,cpt.m_StatDreadnoughtCnt,cpt.m_StatInvaderCnt,cpt.m_StatDevastatorCnt,cpt.m_StatGroupCnt);

			for(u=0;u<Common.TalentCnt;u++) {
				cpt.m_Talent[u]=sl.LoadDword();
//trace("cpt",cpt.m_Id,"i",i,"v",cpt.m_Talent[u].toString(16));
			}

			if(m_QueryCptDscTimer==0 && CptDsc(cpt.m_Id)==null) m_QueryCptDscTimer=Common.GetTime()+500;
		}

		sl.LoadEnd();
		
		m_CptVersion=ver;
		EmpireMap.Self.m_StateCpt = true;
//trace("StateCpt");

		Update();
		if (m_Map.m_FormTalent.visible) m_Map.m_FormTalent.Update();
		if (m_Map.m_FormPlanet.visible) m_Map.m_FormPlanet.Update();
		if (m_Map.m_FormFleetBar.visible) m_Map.m_FormFleetBar.Update();

		if(cptlistempty && m_ShowNewCpt) {
			m_ShowNewCpt=false;
			m_Map.FormHideAll();
			m_Map.m_FormNewCpt.Show();
		}
	}

	public function CptDsc(id:uint):Object
	{
		id&=~Common.FlagshipIdFlag;
		var i:int;
		for(i=0;i<m_CptDsc.length;i++) {
			var obj:Object=m_CptDsc[i];
			if(obj.Id==id) return obj;
		}
		return null;
	}

	public function QueryCptDsc():void
	{
		Server.Self.Query("emcptdsc",'',AnswerCptDsc,false);
	}

	public function QueryCptDscSoft():void
	{
		if(m_QueryCptDscTimer==0) m_QueryCptDscTimer=Common.GetTime()+500;
	}

	public function AnswerCptDsc(event:Event):void
	{
		var len:int;

		m_QueryCptDscTimer=0;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(m_Map.ErrorFromServer(buf.readUnsignedByte())) return;

		m_CptDsc.length = 0;
//trace("!!!AnswerCptDsc00");

		while(true) {
			var id:uint=buf.readUnsignedInt();
			if(id==0) break;
			
			var obj:Object=new Object();
			m_CptDsc.push(obj);

			obj.Id=id;

			len=buf.readUnsignedByte();
			obj.Name=buf.readUTFBytes(len);

			len=buf.readUnsignedByte();
			obj.NameEng=buf.readUTFBytes(len);

			obj.Race=buf.readUnsignedByte();
			obj.Face = buf.readUnsignedByte();

//trace("!!!AnswerCptDsc01", m_CptDsc.length - 1, id, obj.Name, obj.NameEng, obj.Race, obj.Face);
			
/*			var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
			if(user!=null) {
				var cpt:Cpt=user.GetCpt(id);
				if(cpt!=null) {
					cpt.m_Name=obj.Name;
trace("CptName",cpt.m_Name);
				}
			}*/

//trace("CptDsc",obj.Id,obj.Name,obj.NameEng,obj.Race,obj.Face);
		}

		Update();
	}

	public var m_PickCpt_Obj:Object = null;
	
	public function PickCpt():uint
	{
		var i:int;

		m_PickCpt_Obj = null;

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return 0;

		if(user.m_Cpt==null) return 0;
		if(user.m_Cpt.length!=Common.CptMax) return 0;

		for(i=0;i<Common.CptMax;i++) {
			var cpt:Cpt=user.m_Cpt[i];
			var dsc:Object = CptDsc(cpt.m_Id);
			if (dsc == null) continue;
			var gr:Object=m_Gr[i];

			if(dsc==null) continue;
			if (gr.Frame.hitTestPoint(stage.mouseX, stage.mouseY)) { m_PickCpt_Obj = gr; return cpt.m_Id; }
		}
		return 0;
	}

	public function PickMenuCpt():uint
	{
		var i:int;

		m_PickCpt_Obj = null;

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return 0;

		if(user.m_Cpt==null) return 0;
		if(user.m_Cpt.length!=Common.CptMax) return 0;

		for(i=0;i<Common.CptMax;i++) {
			var cpt:Cpt=user.m_Cpt[i];
			var dsc:Object=CptDsc(cpt.m_Id);
			var gr:Object=m_Gr[i];

			if(dsc==null) continue;
			if(!gr.Menu.visible) continue;
			if (gr.Menu.hitTestPoint(stage.mouseX, stage.mouseY)) { m_PickCpt_Obj = gr; return cpt.m_Id; }
		}
		return 0;
	}

	public function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		m_Map.FloatTop(this);
		
		//if(m_Map.m_Action!=EmpireMap.ActionNone) return;
		if (m_Map.m_MoveMap) return;

		if (m_QBFrame.visible && m_QBFrame.hitTestPoint(stage.mouseX, stage.mouseY) && m_Map.m_FormFleetBar.m_QuarkBaseType != 0) {
			m_Map.GoTo(true, m_Map.m_FormFleetBar.m_QuarkBaseCotlId, m_Map.m_FormFleetBar.m_QuarkBaseSectorX, m_Map.m_FormFleetBar.m_QuarkBaseSectorY, m_Map.m_FormFleetBar.m_QuarkBasePlanet, -2);
			return;
		}

		var id:uint = 0;
		if(m_Map.m_Action==0) id=PickMenuCpt();
		if(id!=0) MenuCpt(id);
		else {
			var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
			if(user!=null) {
				var cpt:Cpt=user.GetCpt(PickCpt());
//trace("CptId:",cpt.m_Id,"Pos:",cpt.m_CotlId,cpt.m_SectorX,cpt.m_SectorY,cpt.m_PlanetNum);

				if(m_ShowItem && cpt!=null) {
					m_CptIdCur=cpt.m_Id;
					Update();
					ItemUpdate();
				}
				
				if(cpt!=null && m_Map.m_FormTalent.visible && m_Map.m_Action==0) {
					m_Map.FormHideAll();
					m_Map.m_FormTalent.m_Owner = Server.Self.m_UserId;
					m_Map.m_FormTalent.m_CptId=cpt.m_Id & (~Common.FlagshipIdFlag);
					m_Map.m_FormTalent.Show();
					
				//} else if(cpt!=null && m_Map.m_FormGalaxy.visible) {
				//	if(!m_Map.m_FormGalaxy.m_Float) m_Map.m_FormGalaxy.GoTo(cpt.m_CotlId);
					
				} else if (cpt != null && cpt.m_PlanetNum >= 0 && !m_ShowItem) {
					if (m_Map.m_Action != 0 && cpt.m_CotlId != Server.Self.m_CotlId) { }
					else m_Map.GoTo(true,cpt.m_CotlId,cpt.m_SectorX,cpt.m_SectorY,cpt.m_PlanetNum,-1,cpt.m_Id | Common.FlagshipIdFlag);
				}
			}
		}
	}

	protected function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		m_Map.m_Info.Hide();
	}

	public function MenuCpt(id:uint):void
	{
		var i:int;
		
		//m_Map.CloseForModal();
		m_ActionCptId=id;
		if (m_ActionCptId == 0) return;
		
		m_Map.m_FormMenu.Clear();

//		m_Map.m_FormMenu.Add(Common.Txt.CptEq,MsgEq).Check=m_ShowItem && m_CptIdCur==m_ActionCptId;
		m_Map.m_FormMenu.Add(Common.Txt.CptTalent,MsgTalent);

		m_Map.m_FormMenu.Add();
		if (!EmpireMap.Self.IsAccountTmp()) {
			m_Map.m_FormMenu.Add(Common.Txt.CptAll+":");

			for(i=0;i<m_CptDsc.length;i++) {
				var cd:Object=m_CptDsc[i];

				var obj:Object=m_Map.m_FormMenu.Add("        "+cd.Name,MsgChangeCpt,cd.Id);
				if(cd.Id==id) obj.Check=true;
			}

			m_Map.m_FormMenu.Add();

			m_Map.m_FormMenu.Add(Common.Txt.CptNew, MsgCptNew);
			m_Map.m_FormMenu.Add(Common.Txt.CptReplace, MsgCptReplace);
			m_Map.m_FormMenu.Add(Common.Txt.CptDelete, MsgCptDelete);
		}

//trace(stage.mouseX,stage.mouseY);
		m_Map.m_FormMenu.SetButOpen(m_PickCpt_Obj.Menu);
		//m_Map.m_FormMenu.Show(stage.mouseX-5,stage.mouseY-5,stage.mouseX+5,stage.mouseY+5);
		m_Map.m_FormMenu.Show(x + m_PickCpt_Obj.Menu.x, y + m_PickCpt_Obj.Menu.y, x + m_PickCpt_Obj.Menu.x + m_PickCpt_Obj.Menu.width, y + m_PickCpt_Obj.Menu.y + m_PickCpt_Obj.Menu.height);
	}

	private function MsgTalent(...args):void
	{
		m_Map.FormHideAll();
		m_Map.m_FormTalent.m_Owner = Server.Self.m_UserId;
		m_Map.m_FormTalent.m_CptId=m_ActionCptId & (~Common.FlagshipIdFlag);
		m_Map.m_FormTalent.Show();
	}

	private function MsgEq(...args):void
	{
		if(m_ShowItem && m_CptIdCur==m_ActionCptId) {
			m_ShowItem=false;
			Update();
			ItemUpdate();
		} else {
			m_ShowItem=true;
			m_CptIdCur=m_ActionCptId;
			Update();
			ItemUpdate();
		}
	}

	private function MsgChangeCpt(e:Object,data:uint):void
	{
		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		
		var cpt:Cpt=user.GetCpt(m_ActionCptId);
		if(cpt==null) return;
		
		if(cpt.m_PlanetNum>=0) {
			FormMessageBox.Run(Common.Txt.CptNoChangeExistFlagship,Common.Txt.ButClose);
			return;
		}

		Server.Self.Query("emcptchange",'&val='+m_ActionCptId.toString()+"_"+data.toString(),AnswerCptDel,false);
	}

	private function MsgCptNew(...args):void
	{
		if(m_Map.m_FormNewCpt.visible) m_Map.m_FormNewCpt.Hide();
		else {
			m_Map.FormHideAll();
			
			if(m_CptDsc.length>=Common.CptSlotMax) {
				FormMessageBox.Run(Common.Txt.CptNoMore,Common.Txt.ButClose);
				return;
			}
			
			m_Map.m_FormNewCpt.m_ReplaceId = 0;
			m_Map.m_FormNewCpt.Show();
		}
	}

	private function MsgCptReplace(...args):void
	{
		if(m_Map.m_FormNewCpt.visible) m_Map.m_FormNewCpt.Hide();
		else {
			m_Map.FormHideAll();
			
			m_Map.m_FormNewCpt.m_ReplaceId = m_ActionCptId;
			m_Map.m_FormNewCpt.Show();
		}
	}

	private function MsgCptDelete(...args):void
	{
		m_Map.FormHideAll();

		var dsc:Object=CptDsc(m_ActionCptId);
		if(dsc==null) return;

		var str:String=Common.Txt.CptDeleteQuery;
		str = BaseStr.Replace(str, "<Name>", "[clr]" + dsc.Name + "[/clr]");
		//FormMessageBox.Run(str,StdMap.Txt.ButNo,StdMap.Txt.ButYes,SendCptDel);

		m_Map.m_FormInputEx.Init(460, 280);
		m_Map.m_FormInputEx.caption = Common.Txt.FormNewCptDeleteCaption;

		m_Map.m_FormInputEx.AddLabel(str,true);

		m_Map.m_FormInputEx.AddInput("", 9, false, Server.LANG_ENG).addEventListener(Event.CHANGE, MsgCptDeleteChange);
		
		m_Map.m_FormInputEx.AddLabel(Common.Txt.CptDeleteWarning, true);

		//m_Map.m_FormInputEx.ColAlign();
		m_Map.m_FormInputEx.Run(SendCptDel, Common.Txt.CptDeleteBut, Common.Txt.FormNewCptButCancel);
		MsgCptDeleteChange(null);
	}

	private function MsgCptDeleteChange(e:Event):void
	{
		m_Map.m_FormInputEx.m_ButOk.disable = m_Map.m_FormInputEx.GetStr(0) != 'DELETE';
	}

	private function SendCptDel():void
	{
		Server.Self.Query("emcptdel",'&val='+m_ActionCptId.toString(),AnswerCptDel,false);
	}

	public function AnswerCptDel(event:Event):void
	{
		QueryCptDscSoft();
	}

	public function ItemUpdate():void
	{
		var i:int;

		m_LayerItemBG.visible=m_ShowItem;
		m_LayerItem.visible=m_ShowItem;
		if(!m_ShowItem) return;

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId);
		if(user==null) return;
		
		var no:int=0;
		for(i=0;i<Common.CptMax;i++) {
			if(user.m_Cpt==null) continue;
			if(user.m_Cpt.length!=Common.CptMax) continue;
			var cpt:Cpt=user.m_Cpt[i];
			if(cpt.m_Id==m_CptIdCur) no=i;
		}

		var sx:int=340;
		var sy:int=485;
		var page1:int=20+no*(FaceSizeY+6);
		var page2:int=page1+FaceSizeY+4-1;
		var pagew:int=73-1;
		var pr:int=5;
		
		var dc:Vector.<int>=new Vector.<int>();
		var dv:Vector.<Number>=new Vector.<Number>();
		dc.push(GraphicsPathCommand.MOVE_TO); dv.push(10,0);
		
		dc.push(GraphicsPathCommand.LINE_TO); dv.push(sx-10,0);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(sx,0); dv.push(sx,10); // Правый верхний угол
		
		dc.push(GraphicsPathCommand.LINE_TO); dv.push(sx,sy-10);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(sx,sy); dv.push(sx-10,sy); // Правый нижний угол
		
		dc.push(GraphicsPathCommand.LINE_TO); dv.push(10,sy);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(0,sy); dv.push(0,sy-10); // Левый нижний угол
		
		dc.push(GraphicsPathCommand.LINE_TO); dv.push(0,page2+pr);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(0,page2); dv.push(-pr,page2); // Строничка нижний правый угол
		
		dc.push(GraphicsPathCommand.LINE_TO); dv.push(-pagew+pr,page2);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(-pagew,page2); dv.push(-pagew,page2-pr); // Строничка нижний левый угол
		
		dc.push(GraphicsPathCommand.LINE_TO); dv.push(-pagew,page1+pr);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(-pagew,page1); dv.push(-pagew+pr,page1); // Строничка верхний левый угол
		
		dc.push(GraphicsPathCommand.LINE_TO); dv.push(-pr,page1);
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(0,page1); dv.push(0,page1-pr); // Строничка верхний правый угол

		dc.push(GraphicsPathCommand.LINE_TO); dv.push(0,10);  // Правый левый угол
		dc.push(GraphicsPathCommand.CURVE_TO); dv.push(0,0); dv.push(10,0);

		m_LayerItemBG.graphics.clear();
		m_LayerItemBG.graphics.lineStyle(1.0,0xffff00,0.9,true);
		m_LayerItemBG.graphics.beginFill(0x00000000,0.90);
		m_LayerItemBG.graphics.drawPath(dc,dv);
		m_LayerItemBG.graphics.endFill();
	}
}

}
