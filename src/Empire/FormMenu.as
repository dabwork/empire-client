package Empire
{

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class FormMenu extends Sprite
{
	public var m_List:Array=new Array();
	
	public var m_CurGr:Shape=new Shape();
	
	public var m_Cur:int=-1;
	
	public var m_SizeX:int=0;
	public var m_SizeY:int = 0;
	
	public var m_ButOpen:DisplayObject = null;
	private var m_CaptureMouseMoveSet:Boolean = false;
	public var m_CaptureMouseMove:Boolean = false;

	public function FormMenu()
	{
		addChild(m_CurGr);
		
		mouseChildren = false;
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		return mouseX>=0 && mouseX<m_SizeX && mouseY>=0 && mouseY<m_SizeY;
	}
	
	public function SetButOpen(o:DisplayObject):void
	{
		m_ButOpen = o;
	}
	
	public function SetCaptureMouseMove(cmm:Boolean):void
	{
		m_CaptureMouseMove = cmm;
	}

	public function Clear():void
	{
//trace("FormMenu.Clear");
		var i:int;
		var obj:Object;
		for(i=0;i<m_List.length;i++) {
			obj=m_List[i];
			if(obj.TxtObj!=undefined && obj.TxtObj!=null) {
				removeChild(obj.TxtObj);
				obj.TxtObj=null;
			}
			if(obj.CheckObj!=undefined && obj.CheckObj!=null) {
				removeChild(obj.CheckObj);
				obj.CeckObj=null;
			}
		}
		m_List.length=0;
		if (visible) EmpireMap.Self.stage.focus = EmpireMap.Self;
		
		m_ButOpen = null;
		m_CaptureMouseMove = false;

		if (!visible) return;
		visible = false;
		
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
		if (m_CaptureMouseMoveSet) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
		}
		else removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false);
		
		m_CaptureMouseMoveSet = false;
	}

	public function Add(txt:String="", fun:Function=null, data:Object=undefined):Object
	{
//		trace(fun.prototype);
		var obj:Object=new Object();
		obj.Txt=txt;
		obj.Fun=fun;
		obj.Data=data;
		obj.Disable=false;
		m_List.push(obj);
		return obj;
	}

	public function Show(b_left:int,b_top:int,b_right:int,b_bottom:int,ax:int=1,ay:int=1):void
	{
		var i:int,u:int,score:int,bscore:int,tpx:int,tpy:int;
		var obj:Object;
		var txt:TextField;
		var mc:Sprite;

		if (m_List.length <= 0) { visible = false; return; }

		for(i=m_List.length-1;i>=0;i--) {
			if (m_List[i].Txt == undefined) continue;
			if (m_List[i].Txt == null) continue;
			if (m_List[i].Txt.length > 0) continue;

			if(i>=m_List.length-1) {}
			else if (i <= 0) { }
			else if (m_List[i - 1].Txt == undefined) break;
			else if (m_List[i - 1].Txt == null) break;
			else if (m_List[i - 1].Txt.length <= 0) { }
			else continue;

			m_List.splice(i,1);
		}

		if(m_List.length<=0) { visible=false; return; }
		
		m_Cur=-1;

		var sy:int=5;
		var sx:int=0;

		for(i=0;i<m_List.length;i++) {
			obj=m_List[i];

			obj.y=sy;

			if (obj.Txt == undefined || obj.Txt == null || obj.Txt.length > 0) {
				txt=new TextField();
				obj.TxtObj=txt;
				txt.x=15;
				txt.y=sy;
				txt.width=1;
				txt.height=22;
				txt.type=TextFieldType.DYNAMIC;
				txt.selectable=false;
				txt.border=false;
				txt.background=false;
				txt.multiline=false;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.gridFitType=GridFitType.PIXEL;
				if(obj.Disable) txt.defaultTextFormat=new TextFormat("Calibri",14,0x8f8f8f);
				else txt.defaultTextFormat=new TextFormat("Calibri",14,0xffffff);
				txt.embedFonts = true;
				if (obj.Txt == undefined || obj.Txt == null) txt.text = "-";
				else txt.htmlText = obj.Txt;
				addChild(txt);

				sx=Math.max(sx,txt.width);

				if(obj.Check!=undefined && obj.Check==true) {
					mc=new MenuCheck();
					obj.CheckObj=mc;
					mc.mouseEnabled=false;
					mc.x=5;
					mc.y=sy+7;
					addChild(mc);
				}

				sy+=22;
			} else {
				sy+=5;
			}
		}

		sy+=5;
		sx=15+sx+10;

		graphics.clear();
		graphics.lineStyle(1.0,0x069ee5,0.95,true);
		graphics.beginFill(0x000000,0.95);
		graphics.drawRoundRect(0,0,sx,sy,10,10);
		graphics.endFill();

		for(i=0;i<m_List.length;i++) {
			obj=m_List[i];

			if (obj.Txt == undefined || obj.Txt == null) {}
			else if(obj.Txt.length<=0) {
				graphics.lineStyle(1.0,0x069ee5,0.95,true);
				graphics.moveTo(2,obj.y+2);
				graphics.lineTo(sx-2,obj.y+2);
			}
		}

		m_CurGr.visible=false;
		m_CurGr.graphics.clear();
		m_CurGr.graphics.lineStyle(0.0,0,0.0);
		m_CurGr.graphics.beginFill(0x067ec5,0.80);
		m_CurGr.graphics.drawRect(2,0,sx-4,22);
		m_CurGr.graphics.endFill();

		visible=true;

		var pax:int=ax;//1;
		var pay:int=ay;//1;
		var aax:Array=[pax,-pax,pax,-pax];
		var aay:Array=[pay,pay,-pay,-pay];

		var w_left:int=0;
		var w_top:int=0;
		var w_right:int=parent.stage.stageWidth;
		var w_bottom:int=parent.stage.stageHeight;
//trace("w",w_left,w_top,w_right,w_bottom,"s",sx,sy);

		u=-1;
		for(i=0;i<aax.length;i++) {
			if(aax[i]<0) tpx=b_left-sx;
			else if(aax[i]>0) tpx=b_right;
			else tpx=((b_left+b_right)>>1)-(sx>>1);

			if(aay[i]<0) tpy=b_top-sy;
			else if(aay[i]>0) tpy=b_bottom;
			else tpy=((b_top+b_bottom)>>1)-(sy>>1);

			score=sx*sy;
			var r:Rectangle=(new Rectangle(tpx,tpy,sx,sy)).intersection(new Rectangle(w_left,w_top,w_right-w_left,w_bottom-w_top));
			score-=(r.right-r.left)*(r.bottom-r.top);

//trace(aax[i],aay[i],score);

			if(score<=0) { u=i; break; }
			if(u<0 || score<bscore) { u=i; bscore=score; }
		}
		if(u<0) throw Error("Error");

		if(aax[u]<0) tpx=b_left-sx;
		else if(aax[u]>0) tpx=b_right;
		else tpx=((b_left+b_right)>>1)-(sx>>1);

		if(aay[u]<0) tpy=b_top-sy;
		else if(aay[u]>0) tpy=b_bottom;
		else tpy=((b_top+b_bottom)>>1)-(sy>>1);

		var t_left:int=tpx;
		var t_top:int=tpy;
		var t_right:int=tpx+sx;
		var t_bottom:int=tpy+sy;

		if(t_right>w_right) { t_left-=t_right-w_right; t_right-=t_right-w_right; }
		if(t_left<w_left) { t_right+=w_left-t_left; t_left+=w_left-t_left; }

		if(t_bottom>w_bottom) { t_top-=t_bottom-w_bottom; t_bottom-=t_bottom-w_bottom; }
		if(t_top<w_top) { t_bottom+=w_top-t_top; t_top+=w_top-t_top; }

		x=t_left;
		y=t_top;

//trace("d",aax[u],aay[u],tpx,tpy,x,y);

		m_SizeX=sx;
		m_SizeY = sy;
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 999);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true,999);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true, 999);
		if (m_CaptureMouseMove) {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 999);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true, 999);
			m_CaptureMouseMoveSet = true;
		} else {
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
			m_CaptureMouseMoveSet = false;
		}
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false);
	}
	
	public function onMouseDown(e:MouseEvent):void
	{
		if (IsMouseIn()) e.stopImmediatePropagation();
		else {
			if (m_ButOpen != null) {
				if(m_ButOpen.hitTestPoint(stage.mouseX, stage.mouseY)) e.stopImmediatePropagation();
			}
			Clear();
		}
	}
	
	public function onMouseUp(e:MouseEvent):void
	{
		if (IsMouseIn()) {
			e.stopImmediatePropagation();
			ClickInner();
		}
//		else Clear();
	}

	public function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		
		var i:int;
		var obj:Object;
		//var txt:TextField=e.target as TextField;
		var newcur:int=-1;
		var mx:int=mouseX;
		var my:int=mouseY;
		if(mx>=0 && mx<m_SizeX && my>=0 && my<m_SizeY) {
//trace(mx,my);
			for(i=0;i<m_List.length;i++) {
				obj=m_List[i];
				if(obj.TxtObj!=undefined && obj.TxtObj!=null && obj.Fun!=null) {
					if(my>=obj.TxtObj.y && my<obj.TxtObj.y+obj.TxtObj.height) { newcur=i; break; } 
				}
			}
		}

		if(newcur!=m_Cur) {
			m_Cur=newcur;
			if(m_Cur>=0) {
				obj=m_List[m_Cur];
				m_CurGr.y=obj.TxtObj.y;
				m_CurGr.visible=true;
			} else {
				m_CurGr.visible=false;
			}
		}
		
		EmpireMap.Self.m_Info.Hide();

/*		for(i=0;i<m_List.length;i++) {
			var obj:Object=m_List[i];
			if(obj.TxtObj!=undefined && obj.TxtObj!=null) {
				if(obj.TxtObj==txt) {
					m_CurGr.y=txt.y;
					m_CurGr.visible=true;
					break;
				}
			}
		}*/
	}

	public function onMouseOut(e:MouseEvent):void
	{
		m_Cur=-1;
		m_CurGr.visible=false;
	}

	public function ClickInner():void
	{
		if(m_Cur<0) return;
		
		var obj:Object=null;
		if(m_Cur>=0) obj=m_List[m_Cur];
		if(obj!=null && obj.Fun==null) return;
		Clear();

		if(obj!=null && obj.Fun!=null) {
			obj.Fun(null,obj.Data);
		}
	}
}

}
