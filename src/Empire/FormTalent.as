package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;

import flash.display.*;
import flash.events.*;
import flash.filters.ColorMatrixFilter;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class FormTalent extends Sprite
{
	private var m_Map:EmpireMap;

	static public const SizeX:int=455;
	static public const SizeY:int=520;

	public var m_Owner:uint = 0;
	public var m_CptId:uint = 0;

	public var m_Talent:Array=new Array();
	public var m_Vec:Array=new Array();

	public var m_VecImg:Array=new Array();
	public var m_VecImg2:Array=new Array();

	public var m_TalentMouse:int=-1;
	public var m_TalentCur:int=0;
	public var m_VecMouse:int=-1;
	public var m_ShowFull:Boolean=false;

	public var m_VecCur:int=-1;

	public var m_Timer:Timer=new Timer(200);

	public var m_LabelCaption:TextField=null;
	public var m_LabelCpt:TextField=null;
	public var m_LabelCost:TextField=null;
	public var m_ButClose:Button=null;
	public var m_FaceBM:Bitmap=null;
	public var m_Convert:TextField=null;
	public var m_ButRelocate:Button=null;
	public var m_LabelRelocate:TextField=null;

	public function FormTalent(map:EmpireMap)
	{
		m_Map=map;
		
		var txt:TextField;
		var obj:Object;
		var s:Sprite;
		var bm:Bitmap;
		var i:int;

		m_Timer.addEventListener("timer",UpdateTimer);

		m_LabelCaption=new TextField();
		m_LabelCaption.x=10;
		m_LabelCaption.y=5;
		m_LabelCaption.width=1;
		m_LabelCaption.height=1;
		m_LabelCaption.type=TextFieldType.DYNAMIC;
		m_LabelCaption.selectable=false;
		m_LabelCaption.border=false;
		m_LabelCaption.background=false;
		m_LabelCaption.multiline=false;
		m_LabelCaption.autoSize=TextFieldAutoSize.LEFT;
		m_LabelCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelCaption.gridFitType=GridFitType.PIXEL;
		m_LabelCaption.defaultTextFormat=new TextFormat("Calibri",18,0xffffff);
		m_LabelCaption.embedFonts=true;
		addChild(m_LabelCaption);

		m_LabelCpt=new TextField();
		m_LabelCpt.x=80;
		m_LabelCpt.y=60;
		m_LabelCpt.width=1;
		m_LabelCpt.height=1;
		m_LabelCpt.type=TextFieldType.DYNAMIC;
		m_LabelCpt.selectable=false;
		m_LabelCpt.border=false;
		m_LabelCpt.background=false;
		m_LabelCpt.multiline=false;
		m_LabelCpt.autoSize=TextFieldAutoSize.LEFT;
		m_LabelCpt.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelCpt.gridFitType=GridFitType.PIXEL;
		m_LabelCpt.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_LabelCpt.embedFonts=true;
		addChild(m_LabelCpt);

		m_LabelCost=new TextField();
		m_LabelCost.x=10;
		m_LabelCost.y=SizeY-75;
		m_LabelCost.width=1;
		m_LabelCost.height=1;
		m_LabelCost.type=TextFieldType.DYNAMIC;
		m_LabelCost.selectable=false;
		m_LabelCost.border=false;
		m_LabelCost.background=false;
		m_LabelCost.multiline=false;
		m_LabelCost.autoSize=TextFieldAutoSize.LEFT;
		m_LabelCost.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelCost.gridFitType=GridFitType.PIXEL;
		m_LabelCost.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_LabelCost.embedFonts=true;
		addChild(m_LabelCost);

		m_ButClose=new Button();
		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width=100;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x=SizeX-10-m_ButClose.width;
		m_ButClose.y=SizeY-10-m_ButClose.height;
		addChild(m_ButClose);
		
		m_ButRelocate=new Button();
		m_ButRelocate.label = Common.Txt.FormTalentButRelocate;
		m_ButRelocate.width=150;
		Common.UIStdBut(m_ButRelocate);
		m_ButRelocate.addEventListener(MouseEvent.CLICK, clickRelocate);
		m_ButRelocate.x=10;
		m_ButRelocate.y=SizeY-10-m_ButRelocate.height;
		addChild(m_ButRelocate);

		m_LabelRelocate=new TextField();
		m_LabelRelocate.x=10;
		m_LabelRelocate.y=SizeY-10-m_ButRelocate.height-5;
		m_LabelRelocate.width=1;
		m_LabelRelocate.height=1;
		m_LabelRelocate.type=TextFieldType.DYNAMIC;
		m_LabelRelocate.selectable=false;
		m_LabelRelocate.border=false;
		m_LabelRelocate.background=false;
		m_LabelRelocate.multiline=false;
		m_LabelRelocate.autoSize=TextFieldAutoSize.LEFT;
		m_LabelRelocate.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelRelocate.gridFitType=GridFitType.PIXEL;
		m_LabelRelocate.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_LabelRelocate.embedFonts=true;
		addChild(m_LabelRelocate);

		m_FaceBM=new Bitmap();
		m_FaceBM.x=-31;
		m_FaceBM.y=53;
		addChild(m_FaceBM);

		var arr:Array = [
		0.3, 0.6, 0.1, 0.0, 0.0,
		0.3, 0.6, 0.1, 0.0, 0.0,
		0.3, 0.6, 0.1, 0.0, 0.0,
		0.0, 0.0, 0.0, 1.0, 0.0
		];
		var cmf:ColorMatrixFilter = new ColorMatrixFilter(arr);

		for(i=0;i<Common.VecImg.length;i++) {
			if(Common.VecImg[i].length<=0) {
				m_VecImg.push(null);
				m_VecImg2.push(null);
			} else {
				var cl:Class=ApplicationDomain.currentDomain.getDefinition(Common.VecImg[i]) as Class;
				m_VecImg.push(new cl(42,42));

				var ni:BitmapData=new BitmapData(m_VecImg[i].width,m_VecImg[i].height);
				ni.applyFilter(m_VecImg[i],new Rectangle(0,0,ni.width,ni.height),new Point(0,0),cmf);
				m_VecImg2.push(ni);
			}
		}

		for(i=0;i<Common.TalentCnt;i++) {
			m_Talent[i]=obj=new Object();
			obj.Type=i;

			txt=new TextField();
			txt.x=40;
			txt.y=190+i*25;
			txt.width=150;
			txt.height=22;
			txt.type=TextFieldType.DYNAMIC;
			txt.selectable=false;
			txt.border=false;
			txt.background=false;
			txt.multiline=false;
			txt.autoSize=TextFieldAutoSize.NONE;
			txt.antiAliasType=AntiAliasType.ADVANCED;
			txt.gridFitType=GridFitType.PIXEL;
			txt.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
			txt.embedFonts=true;
			txt.text=Common.TalentName[i];
			addChild(txt);

			obj.Name=txt;
		}

		for(i=0;i<4*8;i++) {
			m_Vec[i]=obj=new Object();

			var sx:int=220+(i % 4)*50;
			var sy:int=40+Math.floor(i / 4)*50;

			s=new ABFill();
			s.x=sx;
			s.y=sy;
			obj.BG=s;
			addChild(s);

			bm=new Bitmap();
			bm.x=sx+5;
			bm.y=sy+5;
			obj.Icon=bm;
			addChild(bm);

			s=new ABNormal();
			s.x=sx+1;
			s.y=sy+1;
			obj.FrameNormal=s;
			addChild(s);

			s=new ABOver();
			s.x=sx+1;
			s.y=sy+1;
			obj.FrameOver=s;
			addChild(s);

			s=new ABProgress();
			s.x=sx+1;
			s.y=sy+1;
			obj.FrameProgress=s;
			addChild(s);
		}

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		//addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
		addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}

	public function Show():void
	{
		var i:int;

		visible=true;

		x = Math.ceil(m_Map.stage.stageWidth / 2 - SizeX / 2);
		y = Math.ceil(m_Map.stage.stageHeight / 2 - SizeY / 2);

		m_TalentMouse=-1;
		m_VecMouse=-1;
		
		m_Timer.start();

		Update();
	}

	public function Hide():void
	{
		m_Timer.stop();
		visible=false;
	}

	public function UpdateTimer(event:TimerEvent=null):void
	{
		Update();
	}

	public function clickClose(event:MouseEvent):void
	{
		Hide();
	}

	public function clickRelocate(event:MouseEvent):void
	{
		FormMessageBox.Run(Common.Txt.FormTalentQueryRelocate, StdMap.Txt.ButNo, StdMap.Txt.ButYes, ActionRelocate);
	}

	private function ActionRelocate():void
	{
		if (m_Map.m_UserRelocate != 0) return;

		if (m_Map.m_UserEGM < Common.RelocateCost) {
			FormMessageBox.Run(Common.Txt.NoEnoughEGM2, Common.Txt.ButClose);
		} else {
			m_ButRelocate.visible = false;
			m_Map.m_UserRelocate = 60 * 60;
			m_Map.SendAction("emplusar", "7");

			Update();
		}
	}

	public function PickTalent():int
	{
		var i:int;
		var l:TextField;

		for(i=0;i<Common.TalentCnt;i++) {
			l=m_Talent[i].Name;

			if(l.mouseX>0 && l.mouseY>0 && l.mouseX<l.width && l.mouseY<l.height) return i;
		}
		return -1;
	}
	
	public function PickVec():int
	{
		var i:int;
		var bm:Bitmap;
		
		for(i=0;i<m_Vec.length;i++) {
			bm=m_Vec[i].Icon;
			if(bm.mouseX>=0 && bm.mouseX<bm.width && bm.mouseY>=0 && bm.mouseY<bm.height) {
				return i;
			}
		}
		return -1;
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		var i:int;
		
		e.stopImmediatePropagation();

		if(FormMessageBox.Self.visible) return;

		var user:User = UserList.Self.GetUser(m_Owner, false);
		var cpt:Cpt = null;
		if (user) cpt = user.GetCpt(m_CptId);

		i=PickTalent();
		if(i>=0) {
			m_TalentCur=i;
			Update();

			return;
		} else {
			i=PickVec();
			if (i >= 0 && cpt != null) {
				if(cpt.m_Talent[m_TalentCur] & (1<<i)) {
					if(!CanOff(i)) return;

					m_VecCur=i;
					m_Map.m_Info.Hide();
					if ((m_Map.m_GameState & Common.GameStateTraining) == 0 && m_Map.m_UserRelocate <= 0 && m_Owner == Server.Self.m_UserId) {
						FormMessageBox.Run(Common.Txt.FormTalentNoUnresech, Common.Txt.ButClose);
					} else {
						UnResearch();
						//FormMessageBox.Run(Common.Txt.TechUnResearchQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,UnResearch);
					}
				} else {
					if(!CanOn(i)) {
						m_Map.m_Info.Hide();
						
						if (Common.TalentVec[m_TalentCur * 32 + i] == Common.VecProtectAntiExchange) {
							FormMessageBox.Run(Common.Txt.TechAntiExchangeNeed, Common.Txt.ButClose);
						} else {
							FormMessageBox.Run(Common.Txt.TechNeedPrev, Common.Txt.ButClose);
						}
						return;
					}
					if(m_Owner == Server.Self.m_UserId) {
						if (m_Map.PlusarTech()) { }
						else if(IsNeedPlusar(i)) {
							m_Map.m_Info.Hide();
							FormMessageBox.Run(Common.Txt.TechNeedPlusar,Common.Txt.ButClose);
							return;
						}
					}
					BeginResearch(i); 
					//m_Map.m_UserTech[m_TechCur] |=(1<<i);
				}
				UpdateVec();
				UpdateCost();
				return;
			}
		}

		if(m_ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButRelocate.hitTestPoint(e.stageX,e.stageY)) return;
//		if(m_ButResearchCancel.hitTestPoint(e.stageX,e.stageY)) return;

		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpHandler(e:MouseEvent):void
	{
	}

	protected function onMouseWheel(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	public function onMouseMoveHandler(e:MouseEvent):void
	{
		var i:int;

		e.stopImmediatePropagation();

		if(FormMessageBox.Self.visible) return;

		i=PickTalent(); if(m_TalentMouse!=i) { m_TalentMouse=i; UpdateTalent(); }
		
		i=PickVec();
		if(m_VecMouse!=i || m_ShowFull!=(e.ctrlKey || e.shiftKey || e.altKey)) {
			m_VecMouse=i;
			m_ShowFull=e.ctrlKey || e.shiftKey || e.altKey;
			UpdateVec();
			
			var vec:int=Common.TalentVec[32*m_TalentCur+i];
			if(m_VecMouse<0 || vec==0) m_Map.m_Info.Hide();
			else {
				var tp:Point=localToGlobal(new Point(m_Vec[i].Icon.x,m_Vec[i].Icon.y));

				m_Map.m_Info.ShowTalentVec(m_CptId,vec,CalcVecLvl(vec),tp.x,tp.y,m_ShowFull);
			}
		}
	}

	public function UpdateTalent():void
	{
		var i:int;
		var l:TextField;

		for(i=0;i<Common.TalentCnt;i++) {
			l=m_Talent[i].Name;
			
			if(i==m_TalentCur) {
				l.background=true;
				l.backgroundColor=0x0000ff;
			} else if(i==m_TalentMouse) {
				l.background=true;
				l.backgroundColor=0x000080;
			} else {
				l.background=false;
				l.backgroundColor=0x00008f;
			}
		}
		
	}

	public function UpdateVec():void
	{
		var i:int;
		var icon:Bitmap;
		var fbg:Sprite;
		var fover:Sprite;
		var fnormal:Sprite;
		var fprogress:Sprite;
		var str:String;

		var user:User = UserList.Self.GetUser(m_Owner, false);
		var cpt:Cpt = null;
		if (user) cpt = user.GetCpt(m_CptId);

		if (m_Owner != Server.Self.m_UserId) {
			m_ButRelocate.visible = false;
			m_LabelRelocate.visible = false;

		} else if (m_Map.m_GameState & Common.GameStateTraining) {
			m_ButRelocate.visible = false;
			m_LabelRelocate.visible = false;
			
		} else if(m_Map.m_UserRelocate>0) {
			m_ButRelocate.visible=false;			
			m_LabelRelocate.visible=true;
			
			str=Common.Txt.FormTalentTimeRelocate;
			str=BaseStr.Replace(str,"<Val>",Math.floor(m_Map.m_UserRelocate/60).toString());
			
			m_LabelRelocate.htmlText=str;
		} else {
			m_ButRelocate.visible=m_Map.m_UserRelocate==0;
			m_LabelRelocate.visible=false;
		}

		var val:uint = 0;
		if (cpt != null) val = cpt.m_Talent[m_TalentCur];

		for(i=0;i<4*8;i++) {
			fbg=m_Vec[i].BG;
			icon=m_Vec[i].Icon;
			fnormal=m_Vec[i].FrameNormal;
			fprogress=m_Vec[i].FrameProgress;
			fover=m_Vec[i].FrameOver;

			if(Common.TalentVec[32*m_TalentCur+i]==0) {
				fbg.visible=true;
				icon.visible=false;
				fnormal.visible=false;
				fprogress.visible=false;
				fover.visible=false;
			} else {
				fbg.visible=true;
				if(val & (1<<i)) {
					icon.bitmapData=m_VecImg[Common.TalentVec[32*m_TalentCur+i]];
					icon.alpha=1.0;
				} else {
					icon.bitmapData=m_VecImg2[Common.TalentVec[32*m_TalentCur+i]];
					if(CanOn(i)) icon.alpha=0.9;
					//else if((m_Map.m_UserResearchLeft>0) && (m_Map.m_UserResearchTalent==m_TalentCur) && (m_Map.m_UserResearchVec==i)) icon.alpha=0.9;
					else icon.alpha=0.4;
				}
				icon.visible=true;
				fnormal.visible=(m_VecMouse!=i);
				fprogress.visible=false;//(m_Map.m_UserResearchLeft>0) && (m_Map.m_UserResearchTalent==m_TalentCur) && (m_Map.m_UserResearchVec==i);
				//if(!fprogress.visible && (m_Map.m_UserFlag & Common.UserFlagTalentNext) && (m_Map.m_UserResearchTalentNext==m_TalentCur) && (m_Map.m_UserResearchVecNext==i)) fprogress.visible=true; 
				fover.visible=(m_VecMouse==i);
			}
		}
	}

	public function CanOn(ii:int):Boolean
	{
		var no:int = ii;
		if(ii<0 || ii>=32) return false;
		var i:int,u:int,cnt:int;
		var user:User = UserList.Self.GetUser(m_Owner, false);
		if (!user) return false;
		var cpt:Cpt = user.GetCpt(m_CptId);
		if (!cpt) return false;
		var val:uint=cpt.m_Talent[m_TalentCur];

//		if(m_Map.m_UserResearchLeft>0 && m_Map.m_UserResearchTalent==m_TalentCur) val|=1<<m_Map.m_UserResearchVec;

		if (val & (1 << ii)) return false;
		var row:int = Math.floor(ii / 4);
		for(i=row-1;i>=0;i--) {
			cnt=0;
			for(u=0;u<4;u++) {
				if(val&(1<<(i*4+u))) cnt++;
			}
			if(cnt<2) return false;
		}

		if (Common.TalentVec[m_TalentCur * 32 + no] == Common.VecProtectAntiExchange) {
			u = 0;
			val = cpt.m_Talent[m_TalentCur];
			for (i = 0; i < 32; i++, val >>= 1) {
				if (val & 1) u++;
			}
			if (u < Common.VecProtectAntiExchange_NeedTalent) return false;
		}

		return true;
	}

	public function IsNeedPlusar(i:int):Boolean
	{
		if (m_Owner) return false;
		if(i<0 || i>=32) return false;

		var vec:int=Common.TalentVec[32*m_TalentCur+i];
		if(vec==0) return false;

		return CalcVecLvl(vec)>=3; 
	}

	public function CanOff(ii:int):Boolean
	{
		if (ii<0 || ii>=32) return false;
		var no:int=ii;
		var i:int,cnt:int,u:int;
		var user:User = UserList.Self.GetUser(m_Owner, false);
		if (!user) return false;
		var cpt:Cpt = user.GetCpt(m_CptId);
		if (!cpt) return false;
		var val:uint=cpt.m_Talent[m_TalentCur];

		var val2:uint=0;
		//if(m_Map.m_UserResearchLeft>0 && m_Map.m_UserResearchTalent==m_TalentCur) val2|=1<<m_Map.m_UserResearchVec;
		//if((m_Map.m_UserFlag & Common.UserFlagTalentNext) && m_Map.m_UserResearchTalentNext==m_TalentCur) val2|=1<<m_Map.m_UserResearchVecNext;
		val|=val2;

		if (!(val & (1 << ii))) return false;

		if (Common.TalentVec[m_TalentCur * 32 +no]!=Common.VecProtectAntiExchange) {
			var rae:Boolean = false;
			u = 0;
			var valtest:uint = cpt.m_Talent[m_TalentCur];
			for (i = 0; i < 32; i++, valtest >>= 1) {
				if (valtest & 1) {
					if (Common.TalentVec[m_TalentCur * 32 +i] == Common.VecProtectAntiExchange) rae = true;
					else u++;
				}
			}
			if (rae && u <= Common.VecProtectAntiExchange_NeedTalent) return false;
		}

		var row:int=Math.floor(i/4);
		for(i=(row+1)*4;i<32;i++) {
			if(val & (1<<i)) break;
		}
		if(i>=32) return true;
		cnt=0;
		for(i=0;i<4;i++) {
			if(val2 & (1<<(row*4+i))) {}
			else {
				if(val & (1<<(row*4+i))) cnt++;
			}		
		}

		return cnt>=3;
	}

	public function CalcVecLvl(vec:int):int
	{
		var i:int,u:int;
		var lvl:int=0;
		var user:User = UserList.Self.GetUser(m_Owner, false);
		if (!user) return 0;
		var cpt:Cpt = user.GetCpt(m_CptId);
		if (!cpt) return 0;
		for(i=0;i<Common.TalentCnt;i++) {
			var val:uint=cpt.m_Talent[i];
			for(u=0;u<32;u++) {
				if(Common.TalentVec[32*i+u]!=vec) continue;
				if(val & (1<<u)) lvl++;
			}
		}
		return lvl;
	}

	public function CalcAllLvl():int
	{
		var i:int,u:int;
		var lvl:int=0;
		var user:User = UserList.Self.GetUser(m_Owner, false);
		if (!user) return 0;
		var cpt:Cpt = user.GetCpt(m_CptId);
		if (!cpt) return 0;
		for(i=0;i<Common.TalentCnt;i++) {
			var val:uint=cpt.m_Talent[i];
			for(u=0;u<32;u++) {
				if(val & (1<<u)) lvl++;
			}
		}
		return lvl;
	}

	public function Update():void
	{
		graphics.clear();

		graphics.lineStyle(1.0,0x069ee5,0.8,true);
		graphics.beginFill(0x000000,0.95);
		graphics.drawRoundRect(0,0,SizeX,SizeY,10,10);
		graphics.endFill();

		graphics.lineStyle(1.0,0x069ee5,0.8,true);
		graphics.beginFill(0x000000,0.8);
		graphics.drawRoundRect(-40,45,110,120,10,10);
		graphics.endFill();

		UpdateTalent();
		UpdateVec();
		UpdateCost();
	}
	
	public function UpdateCost():void
	{
		var str:String;

		str = Common.Txt.TalentCaption;
		if (m_Owner != Server.Self.m_UserId) str += " (" + m_Map.Txt_CotlOwnerName(Server.Self.m_CotlId, m_Owner) + ")";
		m_LabelCaption.htmlText = str;

		str = Common.Txt.TalentCpt + ":\n<font color='#ffff00'>" + m_Map.Txt_CptName(Server.Self.m_CotlId, m_Owner, m_CptId) + "</font>\n";
		str+="\n";
		str+=Common.Txt.CptLvl+": <font color='#ffff00'>"+(CalcAllLvl()+1).toString()+"</font>\n";
		m_LabelCpt.htmlText = str;
		
		m_LabelCost.htmlText = "";

		var user:User=UserList.Self.GetUser(m_Owner);
		if(user==null) return;
		var cpt:Cpt=user.GetCpt(m_CptId);
		if(cpt==null) return;

		if(m_Owner==Server.Self.m_UserId) {
			while(true) {
				var obj:Object=m_Map.m_FormCptBar.CptDsc(m_CptId);
				if(obj==null) break; 

//				str=Common.Txt.TalentCpt+":\n<font color='#ffff00'>"+obj.Name+"</font>\n";
//				str+="\n";
//				str+=Common.Txt.CptLvl+": <font color='#ffff00'>"+(CalcAllLvl()+1).toString()+"</font>\n";
////			str+=Common.Txt.Exp+": <font color='#ffff00'>"+BaseStr.FormatBigInt(cpt.m_Exp)+"</font>\n";
//				m_LabelCpt.htmlText=str;

				var no:String=(obj.Face % Common.RaceFaceCnt[obj.Race]).toString();
				if(no.length==1) no="0"+no;
				var cl:Class=ApplicationDomain.currentDomain.getDefinition("Face"+Common.RaceSysName[obj.Race]+no) as Class;
				m_FaceBM.bitmapData=new cl(93,104);

				break;
			}

			var lvl:int=1+cpt.CalcAllLvl();
			var cost:int=lvl*lvl*Common.CptCostTech;

			str = Common.Txt.CostExp;
			str = str.replace(/<Cost>/g, BaseStr.FormatBigInt(cost));
			str = str.replace(/<Exp>/g, BaseStr.FormatBigInt(user.m_Exp));

			m_LabelCost.htmlText = str;
		} else {
			m_FaceBM.bitmapData = null;
		}
	}

	public function BeginResearch(vec:int):void
	{
		var str:String;

		m_Map.m_Info.Hide();

		var user:User=UserList.Self.GetUser(m_Owner);
		if(user==null) return;
		var cpt:Cpt=user.GetCpt(m_CptId);
		if(cpt==null) return;

		var lvl:int=1+cpt.CalcAllLvl();

		if(lvl>=Common.CptMaxLvl) {
			str=Common.Txt.CptMaxLvl;
			str=str.replace(/<Val>/g,Common.CptMaxLvl);
			FormMessageBox.RunErr(str);
			return;
		}

		if (m_Owner == Server.Self.m_UserId) {
			var cost:int = lvl * lvl * Common.CptCostTech;
			if (cost > user.m_Exp) {
				str = Common.Txt.CptNoExpForTech;
				str = str.replace(/<Val>/g, BaseStr.FormatBigInt(cost - user.m_Exp));
				FormMessageBox.RunErr(str);
				return;
			}
		}

//		m_Map.SendAction("emtalent",""+m_CptId.toString()+"_"+m_TalentCur.toString()+"_"+vec.toString());
		var ac:Action=new Action(m_Map);
		ac.ActionTalent(m_Owner, m_CptId, m_TalentCur, vec);
		m_Map.m_LogicAction.push(ac);
	}

	private function UnResearch():void
	{
//		m_Map.SendAction("emtalent",""+m_CptId.toString()+"_"+m_TalentCur.toString()+"_"+m_VecCur.toString());
		var ac:Action=new Action(m_Map);
		ac.ActionTalent(m_Owner, m_CptId, m_TalentCur, m_VecCur);
		m_Map.m_LogicAction.push(ac);
	}
}

}
