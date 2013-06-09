// Copyright (C) 2013 Elemental Games. All rights reserved.

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

public class FormTech extends Sprite
{
	private var m_Map:EmpireMap;

	static public const SizeX:int=455;
	static public const SizeY:int=540;

	public var m_ButClose:Button=null;
	public var m_ButResearchCancel:Button=null;
	public var m_LabelCaption:TextField=null;
	public var m_LabelCost:TextField=null;
	public var m_LabelResearch:TextField=null;
	public var m_LabelResearchNext:TextField=null;

	public var m_Tech:Array=new Array();
	public var m_Dir:Array=new Array();

	public var m_DirImg:Array=new Array();
	public var m_DirImg2:Array=new Array();

	public var m_TechMouse:int=-1;
	public var m_TechCur:int=0;
	public var m_DirMouse:int=-1;
	public var m_ShowFull:Boolean=false;
	
	public var m_DirCur:int=-1;

	public var m_Timer:Timer=new Timer(200);
	
	public var m_Owner:uint = 0;

	public function FormTech(map:EmpireMap)
	{
		m_Map=map;

		var txt:TextField;
		var obj:Object;
		var s:Sprite;
		var bm:Bitmap;
		var i:int,u:int;

		m_Timer.addEventListener("timer",UpdateTimer);

		m_LabelCaption = new TextField();
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
		m_LabelCaption.text=Common.Txt.FormTechCaption;
		addChild(m_LabelCaption);

		m_LabelCost=new TextField();
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
		
		m_LabelResearch = new TextField();
		m_LabelResearch.width=1;
		m_LabelResearch.height=1;
		m_LabelResearch.type=TextFieldType.DYNAMIC;
		m_LabelResearch.selectable=false;
		m_LabelResearch.border=false;
		m_LabelResearch.background=false;
		m_LabelResearch.multiline=false;
		m_LabelResearch.autoSize=TextFieldAutoSize.LEFT;
		m_LabelResearch.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelResearch.gridFitType=GridFitType.PIXEL;
		m_LabelResearch.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_LabelResearch.embedFonts=true;
		addChild(m_LabelResearch);

		m_LabelResearchNext = new TextField();
		m_LabelResearchNext.width=1;
		m_LabelResearchNext.height=1;
		m_LabelResearchNext.type=TextFieldType.DYNAMIC;
		m_LabelResearchNext.selectable=false;
		m_LabelResearchNext.border=false;
		m_LabelResearchNext.background=false;
		m_LabelResearchNext.multiline=false;
		m_LabelResearchNext.autoSize=TextFieldAutoSize.LEFT;
		m_LabelResearchNext.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelResearchNext.gridFitType=GridFitType.PIXEL;
		m_LabelResearchNext.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
		m_LabelResearchNext.embedFonts=true;
		addChild(m_LabelResearchNext);

		m_ButClose=new Button();
		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width=100;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x=SizeX-10-m_ButClose.width;
		m_ButClose.y=SizeY-10-m_ButClose.height;
		addChild(m_ButClose);

		m_ButResearchCancel=new Button();
		m_ButResearchCancel.label = Common.Txt.ButCancel;
		m_ButResearchCancel.width = 70;
		Common.UIStdBut(m_ButResearchCancel);
		m_ButResearchCancel.addEventListener(MouseEvent.CLICK, clickResearchCancel);
		addChild(m_ButResearchCancel);

		var arr:Array = [
		0.3, 0.6, 0.1, 0.0, 0.0,
		0.3, 0.6, 0.1, 0.0, 0.0,
		0.3, 0.6, 0.1, 0.0, 0.0,
		0.0, 0.0, 0.0, 1.0, 0.0
		];
		var cmf:ColorMatrixFilter = new ColorMatrixFilter(arr);
		
		//var dem:DirEmpireMax=new DirEmpireMax();

//trace("DirImg.Length=",Common.DirImg.length);
		for(i=0;i<Common.DirImg.length;i++) {
			if(Common.DirImg[i].length<=0) {
				m_DirImg.push(null);
				m_DirImg2.push(null);
			} else {
				var cl:Class = ApplicationDomain.currentDomain.getDefinition(Common.DirImg[i]) as Class;
				//var tbm:Bitmap = (new cl(42, 42)) as Bitmap;
				var tbm:BitmapData = (new cl(42, 42)) as BitmapData;
				m_DirImg.push(tbm);
				
				//var ni:BitmapData=new BitmapData(m_DirImg[i].width,m_DirImg[i].height);
				var ni:BitmapData = new BitmapData(tbm.width, tbm.height);
				ni.applyFilter(m_DirImg[i],new Rectangle(0,0,ni.width,ni.height),new Point(0,0),cmf);
				m_DirImg2.push(ni);
			}
		}

		u = 0;
		for (i = 0; i < Common.TechCnt; i++) {
			if (Common.IsTechOff(i)) { m_Tech[i] = null; continue; }
			m_Tech[i]=obj=new Object();
			obj.Type=i;

			txt=new TextField();
			txt.x=40;
			txt.y=40+u*25;
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
			txt.text=Common.TechName[i];
			addChild(txt);

			obj.Name = txt;
			
			u++;
		}

		for(i=0;i<4*8;i++) {
			m_Dir[i]=obj=new Object();

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
		addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
		addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}

	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) Show();
		x = Math.ceil(m_Map.stage.stageWidth / 2 - SizeX / 2);
		y = Math.ceil(m_Map.stage.stageHeight / 2 - SizeY / 2);
	}

	public function Show():void
	{
		var i:int;

		visible=true;

		StageResize();

		m_TechMouse=-1;
		m_DirMouse=-1;
		
		m_Timer.start();

		if (m_Owner == Server.Self.m_UserId) {
			m_LabelCaption.text = Common.Txt.FormTechCaption;
		} else {
			m_LabelCaption.text = Common.Txt.FormTechCaption + " (" + m_Map.Txt_CotlOwnerName(Server.Self.m_CotlId, m_Owner) + ")";
		}
		
		if (UserList.Self.GetUser(m_Owner) == null) return;

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

	public function PickTech():int
	{
		var i:int;
		var l:TextField;

		for (i = 0; i < Common.TechCnt; i++) {
			if (m_Tech[i] == null) continue;
			
			l=m_Tech[i].Name;

			if(l.mouseX>0 && l.mouseY>0 && l.mouseX<l.width && l.mouseY<l.height) return i;
		}
		return -1;
	}
	
	public function PickDir():int
	{
		var i:int;
		var bm:Bitmap;

		for (i = 0; i < m_Dir.length; i++) {
			bm = m_Dir[i].Icon;
			if (bm.mouseX >= 0 && bm.mouseX < bm.width && bm.mouseY >= 0 && bm.mouseY < bm.height) {
				if (Common.TechDir[32 * m_TechCur + i] == 0) return -1;

				if (Common.TechDir[32 * m_TechCur + i] == Common.DirQuarkBaseBlackHole && (m_Owner & Common.OwnerAI) == 0) return -1;
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

		var user:User=UserList.Self.GetUser(m_Owner,false);

		i=PickTech();
		if(i>=0) {
			m_TechCur=i;
			Update();

			return;
		} else {
			i=PickDir();
			if(i>=0) {
				if(user.m_Tech[m_TechCur] & (1<<i)) {
					if(!CanOff(i)) return;

					m_DirCur=i;
					m_Map.m_Info.Hide();
					if (m_Owner & Common.OwnerAI) UnResearch();
					else FormMessageBox.Run(Common.Txt.TechUnResearchQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,UnResearch);
					
				} else if(m_Owner & Common.OwnerAI) {
					if(!CanOn(i)) {
						m_Map.m_Info.Hide();
						FormMessageBox.Run(Common.Txt.TechNeedPrev,Common.Txt.ButClose);
						return;
					}
					BeginResearch(i); 

				} else if((m_Owner==Server.Self.m_UserId) && !(m_Map.m_UserResearchLeft>0 && m_Map.m_UserResearchTech==m_TechCur && m_Map.m_UserResearchDir==i)) {
					if(!CanOn(i)) {
						m_Map.m_Info.Hide();
						FormMessageBox.Run(Common.Txt.TechNeedPrev,Common.Txt.ButClose);
						return;
					}
					if (IsNeedCadet(i)) {
						m_Map.m_Info.Hide();
						FormMessageBox.Run(Common.Txt.TechNeedCadet,Common.Txt.ButClose);
						return;
					}
					else if (m_Map.PlusarTech()) { }
					else if(IsNeedPlusar(i)) {
						m_Map.m_Info.Hide();
						FormMessageBox.Run(Common.Txt.TechNeedPlusar,Common.Txt.ButClose);
						return;
					}
					BeginResearch(i); 
					//m_Map.m_UserTech[m_TechCur] |=(1<<i);
				}
				UpdateDir();
				UpdateCost();
				return;
			}
		}

		if(m_ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButResearchCancel.hitTestPoint(e.stageX,e.stageY)) return;

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
		
		if (FormMessageBox.Self.visible) return;
		
		var hideinfo:Boolean = true;

		i=PickTech(); if(m_TechMouse!=i) { m_TechMouse=i; UpdateTech(); }
		
		i=PickDir();
		if(m_DirMouse!=i || m_ShowFull!=(e.ctrlKey || e.shiftKey || e.altKey)) {
			m_DirMouse=i;
			m_ShowFull=e.ctrlKey || e.shiftKey || e.altKey;
			UpdateDir();
			
			var dir:int=Common.TechDir[32*m_TechCur+i];
			if (m_DirMouse < 0 || dir == 0) {}// m_Map.m_Info.Hide();
			else {
				var tp:Point=localToGlobal(new Point(m_Dir[i].Icon.x,m_Dir[i].Icon.y));
//trace(CalcDirLvl(dir));

				m_Map.m_Info.ShowTechDir(dir, CalcDirLvl(dir), tp.x, tp.y, m_ShowFull);
				hideinfo = false;
			}
		} else if (i >= 0) {
			hideinfo = false;
		}
		
		if (hideinfo) m_Map.m_Info.Hide();
	}

	public function UpdateTech():void
	{
		var i:int;
		var l:TextField;

		for (i = 0; i < Common.TechCnt; i++) {
			if (m_Tech[i] == null) continue;
			l=m_Tech[i].Name;
			
			if(i==m_TechCur) {
				l.background=true;
				l.backgroundColor=0x0000ff;
			} else if(i==m_TechMouse) {
				l.background=true;
				l.backgroundColor=0x000080;
			} else {
				l.background=false;
				l.backgroundColor=0x00008f;
			}
		}
		
	}
	
	public function UpdateDir():void
	{
		var i:int;
		var icon:Bitmap;
		var fbg:Sprite;
		var fover:Sprite;
		var fnormal:Sprite;
		var fprogress:Sprite;

		var user:User=UserList.Self.GetUser(m_Owner,false);

		var val:uint=user.m_Tech[m_TechCur];

		for (i = 0; i < 4 * 8; i++) {
			fbg = m_Dir[i].BG;
			icon = m_Dir[i].Icon;
			fnormal = m_Dir[i].FrameNormal;
			fprogress = m_Dir[i].FrameProgress;
			fover = m_Dir[i].FrameOver;

			if (Common.TechDir[32 * m_TechCur + i] == 0 || (Common.TechDir[32 * m_TechCur + i] == Common.DirQuarkBaseBlackHole && (m_Owner & Common.OwnerAI) == 0)) {
				fbg.visible = true;
				icon.visible = false;
				fnormal.visible = false;
				fprogress.visible = false;
				fover.visible = false;
			} else {
//if(m_TechCur==3) trace(i,"Tech=",m_TechCur,"Length=",Common.TechDir.length,"Tech=",Common.TechDir[32*m_TechCur+i],"BM=",m_DirImg2[Common.TechDir[32*m_TechCur+i]]);
				fbg.visible = true;
				if(val & (1<<i)) {
					icon.bitmapData = m_DirImg[Common.TechDir[32 * m_TechCur + i]];
					icon.alpha = 1.0;
				} else {
					icon.bitmapData = m_DirImg2[Common.TechDir[32 * m_TechCur + i]];
					if (CanOn(i)) icon.alpha = 0.9;
					else if ((m_Owner == Server.Self.m_UserId) && (m_Map.m_UserResearchLeft > 0) && (m_Map.m_UserResearchTech == m_TechCur) && (m_Map.m_UserResearchDir == i)) icon.alpha = 0.9;
					else icon.alpha = 0.4;
				}
				icon.visible = true;
				fnormal.visible = (m_DirMouse != i);
				if (m_Owner == Server.Self.m_UserId) {
					fprogress.visible = (m_Map.m_UserResearchLeft > 0) && (m_Map.m_UserResearchTech == m_TechCur) && (m_Map.m_UserResearchDir == i);
					if (!fprogress.visible && (m_Map.m_UserFlag & Common.UserFlagTechNext) && (m_Map.m_UserResearchTechNext == m_TechCur) && (m_Map.m_UserResearchDirNext == i)) fprogress.visible = true;
				} else {
					fprogress.visible = false;
				} 
				//fprogress.visible=(m_Map.m_UserResearchLeft>0) && (Common.TechDir[m_Map.m_UserResearchTech*32+m_Map.m_UserResearchDir]==Common.TechDir[32*m_TechCur+i]);
				fover.visible = (m_DirMouse == i);
			}
		}
	}

	public function CanOn(ii:int):Boolean
	{
		if(ii<0 || ii>=32) return false;
		var i:int, u:int, cnt:int;
		var user:User = UserList.Self.GetUser(m_Owner, false);
		var val:uint = user.m_Tech[m_TechCur];

		if ((m_Owner == Server.Self.m_UserId) && m_Map.m_UserResearchLeft > 0 && m_Map.m_UserResearchTech == m_TechCur) val |= 1 << m_Map.m_UserResearchDir;

		if (val & (1 << ii)) return false;
		var row:int = Math.floor(i / 4);
		for (i = row - 1; i >= 0; i--) {
			cnt = 0;
			for (u = 0; u < 4; u++) {
				if (val & (1 << (i * 4 + u))) cnt++;
			}
			if (cnt < 2) return false;
		}
		
		//if ((Common.TechDir[32 * m_TechCur + ii] == Common.DirQuarkBaseBlackHole && (m_Owner & Common.OwnerAI) == 0)) return false;
		
		return true;
	}
	
	public function IsNeedCadet(i:int):Boolean
	{
		if(i<0 || i>=32) return false;

		var dir:int = Common.TechDir[32 * m_TechCur + i];
		if (dir == 0) return false;

		var lvl:int = CalcDirLvl(dir);

		if (lvl < 2) return false;
		
		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return true;
		var r:int = (user.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift;
		if (r < Common.UserRankCadet) return true;
		return false;
	}

	public function IsNeedPlusar(i:int):Boolean
	{
		if(i<0 || i>=32) return false;

		var dir:int=Common.TechDir[32*m_TechCur+i];
		if(dir==0) return false;
		
		var lvl:int=CalcDirLvl(dir);
//		if(m_Map.m_UserResearchLeft>0 && m_Map.m_UserResearchTech==m_TechCur && Common.TechDir[32*m_Map.m_UserResearchTech+m_Map.m_UserResearchDir]==dir) lvl++;

		return lvl>=3; 
	}

	public function CanOff(ii:int):Boolean
	{
		if(ii<0 || ii>=32) return false;
		var i:int,cnt:int;
		var user:User=UserList.Self.GetUser(m_Owner,false);
		var val:uint=user.m_Tech[m_TechCur];

		if(m_Owner==Server.Self.m_UserId) {
			var val2:uint=0;
			if(m_Map.m_UserResearchLeft>0 && m_Map.m_UserResearchTech==m_TechCur) val2|=1<<m_Map.m_UserResearchDir;
			if((m_Map.m_UserFlag & Common.UserFlagTechNext) && m_Map.m_UserResearchTechNext==m_TechCur) val2|=1<<m_Map.m_UserResearchDirNext;
			val|=val2;
		}

		if (!(val & (1 << ii))) return false;
		var row:int = Math.floor(ii / 4);
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

	public function CalcDirLvl(dir:int):int
	{
		var i:int,u:int;
		var lvl:int=0;
		var user:User=UserList.Self.GetUser(m_Owner,false);
		for (i = 0; i < Common.TechCnt; i++) {
//			if (m_Tech[i] == null) continue;

			var val:uint=user.m_Tech[i];
			for(u=0;u<32;u++) {
				if(Common.TechDir[32*i+u]!=dir) continue;
				if(val & (1<<u)) lvl++;
			}
		}
		return lvl;
	}

	public function CalcAllLvl():int
	{
		var i:int,u:int;
		var lvl:int=0;
		var user:User=UserList.Self.GetUser(m_Owner,false);
		for(i=0;i<Common.TechCnt;i++) {
			var val:uint = user.m_Tech[i];
			//if (m_Tech[i] == null) continue;

			for(u=0;u<32;u++) {
				if ((val & (uint(1) << u)) != 0) lvl++;
			}
		}
		return lvl;
	}
	
	public function UpdateCost():void
	{
		var i:int;
		var hc:int;

		var str:String="";
		var clr:String="";

/*		var ar:Array=null;
		if(m_TechCur==Common.TechProgress) ar=Common.TechProgressCost;
		else if(m_TechCur==Common.TechEconomy) ar=Common.TechEconomyCost;
		else if(m_TechCur==Common.TechTransport) ar=Common.TechTransportCost;
		else if(m_TechCur==Common.TechCorvette) ar=Common.TechCorvetteCost;
		else if(m_TechCur==Common.TechCruiser) ar=Common.TechCruiserCost;
		else if(m_TechCur==Common.TechDreadnought) ar=Common.TechDreadnoughtCost;
		else if(m_TechCur==Common.TechInvader) ar=Common.TechInvaderCost;
		else if(m_TechCur==Common.TechDevastator) ar=Common.TechDevastatorCost;
		else if(m_TechCur==Common.TechWarBase) ar=Common.TechWarBaseCost;
		else if(m_TechCur==Common.TechShipyard) ar=Common.TechShipyardCost;
		else if(m_TechCur==Common.TechSciBase) ar=Common.TechSciBaseCost;
*/

		if(m_Owner & Common.OwnerAI) {
			m_LabelCost.visible=false;
			return;
		}

		var ar:Array=m_Map.CalcTechCost(m_Owner, m_TechCur);

		if(ar!=null && (ar[0]!=0 || ar[1]!=0 || ar[2]!=0 || ar[3]!=0 || ar[4]!=0 || ar[5]!=0)) {
			//var kof:int=CalcAllLvl();
			//if(m_Map.m_UserResearchLeft>0) {
			//	kof++;
			//}
			//kof=Math.min(500000,(1+kof)*(1+kof)*(1+(kof>>2)));

			str+=Common.Txt.TechCostLvl+":\n";
			if(ar[0]!=0) {
				hc = m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeAntimatter);
				if(ar[0]>hc) clr="#FF0000"; else clr="#FFFF00";
				str+="<p align='right'>"+m_Map.ItemName(Common.ItemTypeAntimatter)+": <font color='"+clr+"'>"+BaseStr.FormatBigInt(ar[0])+"</font></p>\n";
			}
			if(ar[1]!=0) {
				hc = m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeMetal);
				if(ar[1]>hc) clr="#FF0000"; else clr="#FFFF00";
				str+="<p align='right'>"+m_Map.ItemName(Common.ItemTypeMetal)+": <font color='"+clr+"'>"+BaseStr.FormatBigInt(ar[1])+"</font></p>\n";
			}
			if(ar[2]!=0) {
				hc = m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeElectronics);
				if(ar[2]>hc) clr="#FF0000"; else clr="#FFFF00";
				str+="<p align='right'>"+m_Map.ItemName(Common.ItemTypeElectronics)+": <font color='"+clr+"'>"+BaseStr.FormatBigInt(ar[2])+"</font></p>\n";
			}
			if(ar[3]!=0) {
				hc = m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeProtoplasm);
				if(ar[3]>hc) clr="#FF0000"; else clr="#FFFF00";
				str+="<p align='right'>"+m_Map.ItemName(Common.ItemTypeProtoplasm)+": <font color='"+clr+"'>"+BaseStr.FormatBigInt(ar[3])+"</font></p>\n";
			}
			if(ar[4]!=0) {
				hc = m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeNodes);
				if(ar[4]>hc) clr="#FF0000"; else clr="#FFFF00";
				str+="<p align='right'>"+m_Map.ItemName(Common.ItemTypeNodes)+": <font color='"+clr+"'>"+BaseStr.FormatBigInt(ar[4])+"</font></p>\n";
			}
			if (ar[5] != 0) {
				hc = m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeQuarkCore);
				if(ar[5]>hc) clr="#FF0000"; else clr="#FFFF00";
				str += "<p align='right'>" + m_Map.ItemName(Common.ItemTypeQuarkCore) + ": <font color='" + clr + "'>" + BaseStr.FormatBigInt(ar[5]) + "</font></p>\n";
			}
		}

		m_LabelCost.visible=true;
		m_LabelCost.text='';
		m_LabelCost.height=1;
		m_LabelCost.width=1;
		m_LabelCost.htmlText=str;
		m_LabelCost.x=200-m_LabelCost.width;
		m_LabelCost.y=SizeY-100-m_LabelCost.height;
	}
	
	public function UpdateResearch():void
	{
		var dir:int;
		var kof:int;
		var offval:Boolean;
		var str:String='';

		while((m_Map.m_UserResearchLeft>0) && (m_Owner==Server.Self.m_UserId)) {
			dir=Common.TechDir[m_Map.m_UserResearchTech*32+m_Map.m_UserResearchDir];

			kof=CalcAllLvl();
			if(kof<Common.ResearchPeriod.length) kof=Common.ResearchPeriod[kof];
			else kof=400+kof*400;

			kof=(kof*m_Map.m_TechSpeed)>>8;
			if(kof<1) kof=1;

			offval=(dir==Common.DirCorvetteStealth) || (dir==Common.DirCruiserAccess) || (dir==Common.DirDreadnoughtAccess) || (dir==Common.DirWarBaseAccess) || (dir==Common.DirShipyardAccess) || (dir==Common.DirSciBaseAccess);

			str=Common.Txt.TechResearch+": "+Common.TechName[m_Map.m_UserResearchTech]+" - "+Common.DirName[dir];
			if(!offval) str+=" "+(CalcDirLvl(dir)+1).toString();

			var str2:String=Common.Txt.TechProgress;
			str2=str2.replace(/<Val>/g,(kof-m_Map.m_UserResearchLeft).toString());
			str2=str2.replace(/<Max>/g,kof.toString());
			var speed:Number=m_Map.m_UserResearchSpeed;
			var ss:String=speed.toString();
			if ((m_Map.m_Access & Common.AccessPlusarTech) && m_Map.PlusarTech()) { ss += "<font color='#FFFF00'>*" + Common.ResearchBonusPlusar.toString() + "</font>"; speed *= Common.ResearchBonusPlusar; } 
			if (m_Map.m_UserMulTime > 0) { ss += "<font color='#FFFF00'>*" + Common.MulFactor.toString() + "</font>";  speed *= Common.MulFactor; }
			str2=str2.replace(/<Speed>/g,ss);

			var em:int=Math.ceil((m_Map.m_UserResearchLeft/speed)*60);
			if(em<0) em=1;
			str2=str2.replace(/<Time>/g,em);
			str+=str2;

			//str+="\n        "+Common.Txt.TechProgress+" "+(kof-m_Map.m_UserResearchLeft).toString()+" "+Common.Txt.TechProgress2+" "+kof.toString();
			//str+="";

			break;
		}

		m_LabelResearch.htmlText=str;
		m_LabelResearch.x=10;
		m_LabelResearch.y=SizeY-60-(m_LabelResearch.height>>1);
		m_LabelResearch.visible=str.length>0; 

		m_ButResearchCancel.x=m_LabelResearch.x+m_LabelResearch.width+10;
		m_ButResearchCancel.y=SizeY-60-(m_ButResearchCancel.height>>1);
		m_ButResearchCancel.visible=m_LabelResearch.visible;

		str='';
		while((m_Map.m_UserFlag & Common.UserFlagTechNext) && (m_Owner==Server.Self.m_UserId)) {
			dir=Common.TechDir[m_Map.m_UserResearchTechNext*32+m_Map.m_UserResearchDirNext];
			var lvl:int=CalcDirLvl(dir);
			if(m_Map.m_UserResearchLeft>0) {
				if(Common.TechDir[m_Map.m_UserResearchTech*32+m_Map.m_UserResearchDir]==dir) lvl++;
			}

			offval=(dir==Common.DirCorvetteStealth) || (dir==Common.DirCruiserAccess) || (dir==Common.DirDreadnoughtAccess) || (dir==Common.DirWarBaseAccess) || (dir==Common.DirShipyardAccess) || (dir==Common.DirSciBaseAccess);

			str=Common.Txt.TechResearchNext+": "+Common.TechName[m_Map.m_UserResearchTechNext]+" - "+Common.DirName[dir];
			if(!offval) str+=" "+(lvl+1).toString();

			break;
		}

		m_LabelResearchNext.htmlText=str;
		m_LabelResearchNext.x=10;
		m_LabelResearchNext.y=m_LabelResearch.y+52;
		m_LabelResearchNext.visible=str.length>0; 
	}

	public function Update():void
	{
		graphics.clear();

		graphics.lineStyle(1.0,0x069ee5,0.8,true);
		graphics.beginFill(0x000000,0.95);
		graphics.drawRoundRect(0,0,SizeX,SizeY,10,10);
		graphics.endFill();

		UpdateTech();
		UpdateDir();
		UpdateCost();
		UpdateResearch();
	}

	public function BeginResearch(dir:int):void
	{
		m_Map.m_Info.Hide();

		var ar:Array=m_Map.CalcTechCost(m_Owner, m_TechCur);

		if((m_Owner==Server.Self.m_UserId) && (m_Map.m_UserResearchLeft>0)) {
			if ((m_Map.m_Access & Common.AccessPlusarTech) && m_Map.PlusarTech()) { }
			else {
				FormMessageBox.RunErr(Common.Txt.TechResearchNoMore);
				return;
			}
		}

		while(!(m_Owner & Common.OwnerAI)) {
			if(m_Map.m_UserFlag & Common.UserFlagTechNext) {
				if(m_Map.m_UserResearchTechNext==m_TechCur && m_Map.m_UserResearchDirNext==dir) break;
			}
			
		
/*			if (ar[0] > m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeAntimatter)) { }
			else if (ar[1] > m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeMetal)) { }
			else if (ar[2] > m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeElectronics)) { }
			else if (ar[3] > m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeProtoplasm)) { }
			else if (ar[4] > m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeNodes)) { }
			else if (ar[5] > m_Map.m_FormFleetBar.FleetSysItemGet(Common.ItemTypeQuarkCore)) { }
			else break;*/
			break;

			FormMessageBox.Run(Common.Txt.TechNoRes,Common.Txt.Cancel);

			return;
		}

		if((m_Map.m_GameState & Common.GameStateWait)==0) {		
//			m_Map.SendAction("emresearch",""+m_TechCur.toString()+"_"+dir.toString());
			var ac:Action=new Action(m_Map);
			ac.ActionResearch(m_TechCur,dir,m_Owner);
			m_Map.m_LogicAction.push(ac);
		}
	}

	public function clickResearchCancel(event:MouseEvent):void
	{
		if((m_Map.m_GameState & Common.GameStateWait)==0) {		
//			m_Map.SendAction("emresearch","-1_0");

			var ac:Action=new Action(m_Map);
			ac.ActionResearch(-1,0,m_Owner);
			m_Map.m_LogicAction.push(ac);
		}
	}

	private function UnResearch():void
	{
		if((m_Map.m_GameState & Common.GameStateWait)==0) {		
//			m_Map.SendAction("emresearch",""+m_TechCur.toString()+"_"+m_DirCur.toString());

			var ac:Action=new Action(m_Map);
			ac.ActionResearch(m_TechCur,m_DirCur,m_Owner);
			m_Map.m_LogicAction.push(ac);
		}
	}
}

}
