package Empire
{
	
import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class FormTeamRel extends Sprite
{
	private var m_Map:EmpireMap;

	static public const SizeX:int=380;
	static public const SizeY:int=430;
	static public const GridOffX:int=35;
	static public const GridOffY:int=60;
	static public const CellSize:int=40;

	public var m_LabelCaption:TextField=null;
	public var m_ButSave:Button=null;
	public var m_ButClose:Button=null;
	
	public var m_Cels:Array=new Array((1<<Common.TeamMaxShift)*(1<<Common.TeamMaxShift));
	
	public var m_ImgPigeon:BitmapData=new RelPigeon(0,0);
	public var m_ImgSword:BitmapData=new RelSword(0,0);
	
	public var m_Cur:int=-1;
	
	public function FormTeamRel(map:EmpireMap)
	{
		var i:int;
		var l:TextField;
		m_Map=map;
		
		for(i=0;i<(1<<Common.TeamMaxShift)*(1<<Common.TeamMaxShift);i++) m_Cels[i]=new Object();

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
		m_LabelCaption.htmlText=Common.TxtEdit.FormTeamRelCaption;
		addChild(m_LabelCaption);
		
		var tf:TextFormat=new TextFormat("Calibri",13,0xffffff);
		
		for(i=0;i<(1<<Common.TeamMaxShift);i++) {
			l=new TextField();
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
			l.defaultTextFormat=tf;
			l.embedFonts=true;
			l.text=String.fromCharCode(65+i);
			l.x=GridOffX+i*CellSize+(CellSize>>1)-(l.width>>1);
			l.y=GridOffY-20;
			addChild(l);

			l=new TextField();
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
			l.defaultTextFormat=tf;
			l.embedFonts=true;
			l.text=String.fromCharCode(65+i);
			l.x=GridOffX-20;
			l.y=GridOffY+i*CellSize+(CellSize>>1)-(l.height>>1);
			addChild(l);
		}

		m_ButClose=new Button();
		m_ButClose.label = Common.Txt.ButCancel;
		m_ButClose.width=100;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x=SizeX-10-m_ButClose.width;
		m_ButClose.y=SizeY-10-m_ButClose.height;
		addChild(m_ButClose);

		m_ButSave=new Button();
		m_ButSave.label = Common.Txt.ButSave;
		m_ButSave.width=100;
		Common.UIStdBut(m_ButSave);
		m_ButSave.addEventListener(MouseEvent.CLICK, clickSave);
		m_ButSave.x=m_ButClose.x-10-m_ButSave.width;
		m_ButSave.y=m_ButClose.y;
		addChild(m_ButSave);

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
		addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
	}

	public function Show():void
	{
		var i:int,px:int,py:int;
		var obj:Object;

		var cntcell:int=1<<Common.TeamMaxShift;
		for(py=0;py<cntcell;py++) {
			for(px=0;px<cntcell;px++) {
				obj=m_Cels[px+py*cntcell];
				obj.Val=m_Map.m_TeamRel[px+py*cntcell];

//				obj.Val=Common.TeamRelWar;
//				if(px==py) obj.Val=Common.TeamRelPeace;
			}
		}
		
		m_Cur=-1;
		

		visible=true;

		x=Math.ceil(m_Map.stage.stageWidth/2-SizeX/2);
		y=Math.ceil(m_Map.stage.stageHeight/2-SizeY/2);
		
		Update();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function clickClose(event:MouseEvent):void
	{
		Hide();
	}
	
	public function clickSave(event:MouseEvent):void
	{
		var i:int,val:int;
		var str:String='';
		
		var cntcell:int=1<<Common.TeamMaxShift;
		
		for(i=0;i<cntcell*cntcell;i++) {
			val=m_Cels[i].Val;
			m_Map.m_TeamRel[i]=val;
			str+=val.toString();
		}
		
		Server.Self.Query("emedcotlspecial","&type=16&val="+str,m_Map.EditMapChangeSizeRecv,false);

		Hide();
	}

	public function Update():void
	{
		var i:int,x:int,y:int;
		var obj:Object;
		var bm:Bitmap;

		graphics.clear();
		
		graphics.lineStyle(1.0,0x069ee5,0.8,true);
		graphics.beginFill(0x000000,0.95);
		graphics.drawRoundRect(0,0,SizeX,SizeY,10,10);
		graphics.endFill();
		
		graphics.lineStyle(1.0,0xffffff,0.4,true);
		var cntcell:int=1<<Common.TeamMaxShift;
		for(i=0;i<=cntcell;i++) {
			graphics.moveTo(GridOffX+i*CellSize,GridOffY);
			graphics.lineTo(GridOffX+i*CellSize,GridOffY+cntcell*CellSize);

			graphics.moveTo(GridOffX,GridOffY+i*CellSize);
			graphics.lineTo(GridOffX+cntcell*CellSize,GridOffY+i*CellSize);
		}
		
		var curx:int=-1;
		var cury:int=-1;
		if(m_Cur>=0) {
			curx=m_Cur & ((1<<Common.TeamMaxShift)-1);
			cury=m_Cur >> Common.TeamMaxShift;
		}
		
		for(y=0;y<cntcell;y++) {
			for(x=0;x<cntcell;x++) {
				obj=m_Cels[x+y*cntcell];
				
				while(m_Cur>=0) {
					if(y==cury && x<=curx) {}
					else if(x==curx && y<=cury) {}
					else break;
					
					graphics.lineStyle(1.0,0x00008f,0.5,true);
					graphics.beginFill(0x00008f,0.5);
					graphics.drawRect(GridOffX+x*CellSize+1,GridOffY+y*CellSize+1,CellSize-2,CellSize-2);
					graphics.endFill();
					break;
				}
					
				if(obj.Val==Common.TeamRelDefault) {
					if(obj.Img!=undefined && obj.Img!=null) obj.Img.visible=false;  
				} else {
					if(obj.Img==undefined || obj.Img==null) {
						obj.Img=new Bitmap();
						addChild(obj.Img);
					} 
					bm=obj.Img;
					bm.visible=true;
					if(obj.Val==Common.TeamRelWar) bm.bitmapData=m_ImgSword;
					else bm.bitmapData=m_ImgPigeon;
					bm.x=GridOffX+x*CellSize+(CellSize>>1)-(bm.width>>1);
					bm.y=GridOffY+y*CellSize+(CellSize>>1)-(bm.height>>1);
				}
			}
		}
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		var i:int,curx:int,cury:int,val:int;

		if(m_Cur>=0) {
			curx=m_Cur & ((1<<Common.TeamMaxShift)-1);
			cury=m_Cur >> Common.TeamMaxShift;
			
			val=m_Cels[curx+(cury<<Common.TeamMaxShift)].Val;
			if(val==Common.TeamRelDefault) val=Common.TeamRelWar;
			else if(val==Common.TeamRelWar) val=Common.TeamRelPeace;
			else val=Common.TeamRelDefault;
			
			m_Cels[curx+(cury<<Common.TeamMaxShift)].Val=val;
			m_Cels[cury+(curx<<Common.TeamMaxShift)].Val=val;
			
			Update();
			return;
		}

		if(FormMessageBox.Self.visible) return;
		if(m_ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButSave.hitTestPoint(e.stageX,e.stageY)) return;
		
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpHandler(e:MouseEvent):void
	{
	}

	public function onMouseMoveHandler(e:MouseEvent):void
	{
		var i:int;

		if(FormMessageBox.Self.visible) return;

		i=Pick();
		if(i!=m_Cur) {
			m_Cur=i;
			Update();
		}
	}

	public function Pick():int
	{
		var tx:int=mouseX;
		var ty:int=mouseY;
		if(tx<GridOffX) return -1;
		if(ty<GridOffY) return -1;

		var cntcell:int=1<<Common.TeamMaxShift;

		tx=Math.floor((tx-GridOffX)/CellSize);
		ty=Math.floor((ty-GridOffY)/CellSize);
		if(tx<0 || tx>=cntcell) return -1;
		if(ty<0 || ty>=cntcell) return -1;

		return tx+(ty<<Common.TeamMaxShift);
	}
}

}
