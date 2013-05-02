// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;
import flash.events.*;

public class Info extends Sprite
{
	private var EM:EmpireMap;
	
	static public const TypeItemBonus:int = 1;
	static public const TypeShip:int = 2;
	static public const TypeCotl:int = 3;
	static public const TypePlanet:int = 4;
	static public const TypeSearchCombat:int = 5;
	
	public var m_ShowType:int = 0;
	

	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_ShipNum:int;
	public var m_ShipType:int;

	public var m_ItemKey:Object = null;

	private var m_GridSizeX:int;
	private var m_GridSizeY:int;
	
	public var m_HintLast:int = -1;
	public var m_HintType:int = -1;
	public var m_HintNew:Boolean = true;
	
	public var m_TimeLive:Timer = new Timer(500);

	private var m_CfgIB_No:uint=0;
	private var m_Cfg_PX:int=0;
	private var m_Cfg_PY:int=0;
	private var m_Cfg_SX:int=0;
	private var m_Cfg_SY:int=0;
	private var m_Cfg_SectorX:int=0;
	private var m_Cfg_SectorY:int=0;
	private var m_Cfg_PlanetNum:int=0;
	private var m_Cfg_ShipNum:int = 0;
	private var m_Cfg_Planet:SpacePlanet = null;
	private var m_Cfg_Cotl:SpaceCotl = null;
	private var m_Cfg_Tmp:int = 0;

	// =МИН(10;ОКРУГЛ(КОРЕНЬ(999/МАКС(1;A1));0))
	public static const CorvetteMulPower:Vector.<int>=new <int>[
//10,10,10,10,10,10,10,10,10,10,10,10,9,9,8,8,8,8,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];

	public function Info(map:EmpireMap)
	{
		EM=map;
		
		mouseEnabled = false;
		
		m_TimeLive.addEventListener("timer",LiveUpdate);
	}

	public function Hide(clearall:Boolean=true):void
	{
		if (!visible) return;
		
		ClearGrid();

		visible=false;
		m_SectorX=0;
		m_SectorY=0;
		m_PlanetNum=-1;
		m_ShipNum=-1;
		m_ShipType = Common.ShipTypeNone;
		m_ItemKey = null;
		
		if (clearall) {
			m_ShowType = 0;
			m_TimeLive.stop();

			m_CfgIB_No=0;
			m_Cfg_PX=0;
			m_Cfg_PY=0;
			m_Cfg_SX=0;
			m_Cfg_SY=0;
			m_Cfg_SectorX=0;
			m_Cfg_SectorY=0;
			m_Cfg_PlanetNum=0;
			m_Cfg_ShipNum = 0;
			m_Cfg_Cotl = null;
			m_Cfg_Tmp = 0;
		}
	}
	
	public function Prepare(b_left:int, b_top:int, b_right:int, b_bottom:int, pax:int=-1, pay:int=-1):void
	{
		//if(txt.length<=0) { Hide(); return; }
		//m_Txt.htmlText =txt;

		var sx:int=10+m_GridSizeX+10;
		var sy:int=10+m_GridSizeY+10;

//		var pax:int=-1;
//		var pay:int=-1;
		var aax:Array=[pax,-pax,pax,-pax];
		var aay:Array=[pay,pay,-pay,-pay];

		var i:int,u:int,score:int,bscore:int,tpx:int,tpy:int;

		var w_left:int=0;
		var w_top:int=0;
		var w_right:int=EM.stage.stageWidth;
		var w_bottom:int=EM.stage.stageHeight;

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

		graphics.clear();

		graphics.lineStyle(1.0,0x069ee5,0.9,true);
		graphics.beginFill(0x000000,0.95);
		graphics.drawRoundRect(0,0,sx,sy,10,10);
		graphics.endFill();

		visible=true;
	}
	
	public function ClearGrid():void
	{
		while(numChildren>0) removeChildAt(numChildren-1);
		m_GridSizeX=0;
		m_GridSizeY=0;
	}
	
	public function BuildGrid(ar:Array):void
	{
		ClearGrid();

		var i:int, u:int, s:int, curw:int;
		var obj:Object;
		var tf:TextField;

		var cntx:int=0;
		var cnty:int=0;

		for(i=0;i<ar.length;i++) {
			obj=ar[i];
			cntx=Math.max(cntx,obj.x+obj.sx);
			cnty=Math.max(cnty,obj.y+obj.sy);
		}
		if(cntx<=0) return;
		if(cnty<=0) return;

		var sx:Array=new Array(cntx);
		var sy:Array=new Array(cnty);

		for(i=0;i<cntx;i++) sx[i]=0;
		for(i=0;i<cnty;i++) sy[i]=0;

		for(i=0;i<ar.length;i++) {
			obj=ar[i];

			tf=new TextField();
			tf.width=0;
			tf.height=0;
			tf.type=TextFieldType.DYNAMIC;
			tf.selectable=false;
			tf.background=false;
			tf.multiline=true;
			tf.autoSize=TextFieldAutoSize.LEFT;
			tf.antiAliasType=AntiAliasType.ADVANCED;
			tf.gridFitType=GridFitType.PIXEL;// NONE;
			tf.defaultTextFormat=new TextFormat("Calibri",obj.fontsize,obj.clr);
			tf.embedFonts=true;
			tf.htmlText=BaseStr.FormatTag(obj.txt);
			addChild(tf);

			curw = tf.width;
			if (obj.auto_width != undefined) {
				curw = obj.auto_width;
			}

			s=Math.ceil((obj.cs_left+curw+obj.cs_right)/obj.sx);
			if(s<0) s=0;
			for(u=0;u<obj.sx;u++) {
				sx[obj.x+u]=Math.max(sx[obj.x+u],s);
			}

//trace(tf.width," ",tf.height);
		}

		for(i=0;i<ar.length;i++) {
			obj=ar[i];
			tf = getChildAt(i) as TextField;
			
			if (obj.auto_width != undefined) {
				curw = 0;
				for (u = 0; u < obj.sx; u++) {
					curw += sx[obj.x + u];
				}
				tf.width = curw-obj.cs_left-obj.cs_right;
				//tf.autoSize = TextFieldAutoSize.NONE;
				tf.wordWrap = true;
			}

			s=Math.ceil((obj.cs_top+tf.height+obj.cs_bottom)/obj.sy);
			if(s<0) s=0;
			for(u=0;u<obj.sy;u++) {
				sy[obj.y+u]=Math.max(sy[obj.y+u],s);
			}
		}

		var ox:Array=new Array(cntx);
		var oy:Array=new Array(cnty);
		m_GridSizeX=0;
		m_GridSizeY=0;
		for(i=0;i<cntx;i++) { ox[i]=m_GridSizeX; m_GridSizeX+=sx[i]; }
		for(i=0;i<cnty;i++) { oy[i]=m_GridSizeY; m_GridSizeY+=sy[i]; }

		for(i=0;i<ar.length;i++) {
			obj=ar[i];
			tf=getChildAt(i) as TextField;

			if(obj.ax<0) tf.x=10+obj.cs_left+ox[obj.x];
			else if(obj.ax>0) tf.x=10+ox[obj.x+obj.sx-1]+sx[obj.x+obj.sx-1]-obj.cs_right-Math.ceil(tf.width);
			else tf.x=10+((ox[obj.x]+ox[obj.x+obj.sx-1]+sx[obj.x+obj.sx-1])>>1)-(Math.ceil(tf.width)>>1);

			if(obj.ay<0) tf.y=10+obj.cs_top+oy[obj.y];
			else if(obj.ay>0) tf.y=10+oy[obj.y+obj.sy-1]+sy[obj.y+obj.sy-1]-obj.cs_bottom-Math.ceil(tf.height);
			else tf.y=10+((oy[obj.y]+oy[obj.y+obj.sy-1]+sy[obj.y+obj.sy-1])>>1)-(Math.ceil(tf.height)>>1);
		}

//		trace(cntx+" "+cnty);
	}

	public function CreateHint(t1:int, t2:int=0, t3:int=0):String
	{
		var i:int, v:int, bscore:int, bestno:int;

		if (!m_HintNew && (m_HintType == t1 || m_HintType == t2 || m_HintType == t3)) {
			if (m_HintLast < 0) return "";
			else return Common.HintList[m_HintLast + 1];
		}
		
		m_HintNew = false;
		
		if (t2 != 0 && t3 != 0) {
			v = Math.random() * 100;
			if (v < 33) v = t1;
			else if (v < 66) v = t2;
			else v = t3;
			
		} else if (t2 != 0) {
			v = Math.random() * 100;
			if (v < 50) v = t1;
			else v = t2;
			
		} else v = t1;

		bestno = -1;
		for (i = 0; i < Common.HintList.length; i += 3) {
			if (Common.HintList[i] != v) continue;
			var score:int = Common.HintList[i + 2];

			if (bestno < 0 || score < bscore) {
				bestno = i;
				bscore = score;
			}
		}
		
		m_HintType = v;
		m_HintLast = bestno;
		if (bestno < 0) return "";
		Common.HintList[bestno + 2]++;
		return Common.HintList[bestno + 1];
	}

	public function ShowShipType(owner:uint, race:uint, shiptype:int, shipid:uint, ax:int, ay:int, sx:int, sy:int):void
	{
		//secx:int, secy:int, planetnum:int, 
//		if(m_ShipType==shiptype) return;

		var i:int, u:int;
		var addval:int,bp:int,ac:int;
		var user:User=null;
		var cpt:Cpt=null;
		var str:String,addstr:String;

		var pnax:int=1;

//		var planet:Planet=EM.GetPlanet(secx,secy,planetnum);
//		if(planet==null) return;
//		var ra:Array=EM.CalcShipPlace(planet,shipnum);
//		var cx:int=EM.WorldToScreenX(ra[0]);
//		var cy:int=EM.WorldToScreenY(ra[1]);

		m_HintNew = !visible;
		Hide();

		m_ShipType=shiptype;

		var ar:Array=new Array();
		var y:int = 0;
		
		if (owner != 0) {
			user = UserList.Self.GetUser(owner, false);
			if(race==0) race = user.m_Race;
		}
		if (race == 0) return;
		if (user != null && shipid != 0) {
			cpt=user.GetCpt(shipid);
		}

		// Name - Desc
		if(shiptype==Common.ShipTypeFlagship) {
			str="";
			if(cpt!=null) str=" (<font color='#ffff00'>"+(cpt.CalcAllLvl()+1).toString()+"</font>)";
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipName[shiptype]+str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipDesc[shiptype], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6, auto_width:200 });
			y++;

			while (cpt != null) {
				str = EM.Txt_CptName(Server.Self.m_CotlId, owner, shipid);
/*				if(owner==Server.Self.m_UserId) {
					var obj:Object=EM.m_FormCptBar.CptDsc(shipid);
					if(obj==null) break;
					str=obj.Name;
				} else {
					if(cpt.m_Name==null || cpt.m_Name.length<=0) break;
					str=cpt.m_Name;
				}*/

				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Cpt+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;

				break;
			}

		} else if (shiptype == Common.ShipTypeQuarkBase) {
			str = Common.ShipName[shiptype];

			user = UserList.Self.GetUser(owner, false);
			if (user != null) {
				u = 0;
				var dw:uint = user.m_Tech[Common.TechQuarkBase];
				for (i = 0; i < 32; i++) {
					if ((dw & (uint(1) << i)) != 0) u++;
				}
				str += " (" + u.toString()+")";
			}

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipDesc[shiptype], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6, auto_width:200 });
			y++;

			var vag:int = EM.DirValE(owner, Common.DirQuarkBaseAntiGravitor);
			var vgw:int = EM.DirValE(owner, Common.DirQuarkBaseGravWell);
			var vbh:int = EM.DirValE(owner, Common.DirQuarkBaseBlackHole);

			if (vag != 0 || vgw != 0 || vbh != 0) {
				str = "";
				if (vag != 0) {
					if (str.length > 0) str += "[br]";
					str += Common.Txt.InfoAntiGravitor + " (" + vag.toString() + ")";
				}
				if (vgw != 0) {
					if (str.length > 0) str += "[br]";
					str += Common.Txt.InfoGravWell + " (" + vgw.toString() + ")";
				}
				if (vbh != 0) {
					if (str.length > 0) str += "[br]";
					str += Common.Txt.InfoBlackHole + " (" + vbh.toString() + ")";
				}

				ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0x25fa53, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:200 });
				y++;
			}
		} else {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipName[shiptype], clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipDesc[shiptype], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6, auto_width:200});
			y++;
		}

		// Mass
		while (true) {
			if (owner == 0) break;
			i = EM.ShipMass(owner, shipid, shiptype);
			if (i == 0) break;
			
			if(1) { // Space
				ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
				y++;
			}
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Mass+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(i), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
			break;
		}

		if(1) { // Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Power
		var power:int=EM.ShipPower(owner,shiptype);
		if (power > 0 && shiptype != Common.ShipTypeFlagship) {
			if(shiptype==Common.ShipTypeCruiser) power<<=1;
			else if(shiptype==Common.ShipTypeWarBase) power<<=1;

			if ((race == Common.RacePeople) && (shiptype != Common.ShipTypeFlagship) && (!Common.IsBase(shiptype))) power = (power * 333) >> 8;//130% power += power >> 2;

			bp = EM.ShipAccuracy(owner, shiptype);
			addval=Math.round((power*bp)/256);
//			bp=0;
//			if(ship.m_ItemType==Common.ItemTypePower) bp=Common.BonusPower;
//			else if(ship.m_ItemType==Common.ItemTypePower2) bp=Common.BonusPower2;
//			if(bp>0) addval+=Math.round(((power+addval)*bp)/256)

			addstr='';
			if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

			str=BaseStr.FormatBigInt(power)+addstr;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Power+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Dreadnought transiver
		if (shiptype == Common.ShipTypeDreadnought && race == Common.RaceTechnol) {
			power = EM.ShipPower(owner, shiptype);// << 1;

			addval=0;

			addstr='';
			if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerTransiver+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(power)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Devastator Accuracy
		while(shiptype==Common.ShipTypeDevastator && user!=null) {
			var lvl:int=user.CalcDirLvl(Common.DirDevastatorAccuracy);
			ac=Common.DirDevastatorAccuracyHitLvl[lvl];

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Accuracy+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Math.round(ac*100/256).toString()+"%", clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			break;
		}

		if (true) {
			// Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Flagship
		if(shiptype==Common.ShipTypeFlagship) {
			var cannon:int=EM.VecValE(owner, shipid, Common.VecAttackCannon);
			var laser:int=EM.VecValE(owner, shipid, Common.VecAttackLaser);
			var missile:int=EM.VecValE(owner, shipid, Common.VecAttackMissile);
			var transiver:int=EM.VecValE(owner, shipid, Common.VecAttackTransiver);
			if(cannon==0 && laser==0 && missile==0) cannon=Common.VecAttackCannonLvl[1]>>1;

			ac=EM.VecValE(owner, shipid, Common.VecAttackAccuracy);

			if(cannon) {
				addval=Math.round((cannon*ac)/256);
//				bp=0;
//				if(ship.m_ItemType==Common.ItemTypePower) bp=Common.BonusPower;
//				else if(ship.m_ItemType==Common.ItemTypePower2) bp=Common.BonusPower2;
//				if(bp>0) addval+=Math.round(((cannon+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerCannon+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cannon)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(laser) {
				addval=Math.round((laser*ac)/256);
//				bp=0;
//				if(ship.m_ItemType==Common.ItemTypePower) bp=Common.BonusPower;
//				else if(ship.m_ItemType==Common.ItemTypePower2) bp=Common.BonusPower2;
//				if(bp>0) addval+=Math.round(((laser+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerLaser+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(laser)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(missile) {
				addval=Math.round((missile*ac)/256);
//				bp=0;
//				if(ship.m_ItemType==Common.ItemTypePower) bp=Common.BonusPower;
//				else if(ship.m_ItemType==Common.ItemTypePower2) bp=Common.BonusPower2;
//				if(bp>0) addval+=Math.round(((missile+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerMissile+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(missile)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(transiver) {
				addval=0;//Math.round((transiver*ac)/256);
//				bp=0;
//				if(ship.m_ItemType==Common.ItemTypePower) bp=Common.BonusPower;
//				else if(ship.m_ItemType==Common.ItemTypePower2) bp=Common.BonusPower2;
//				if(bp>0) addval+=Math.round(((transiver+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerTransiver+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(transiver)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		if(shiptype==Common.ShipTypeFlagship) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Armour
		var armour:String="";
		var iarmour:int=/*planetarmour+*/EM.ShipArmour(owner,shipid,shiptype);
		if(iarmour>0) {
			if(iarmour>Common.MaxArmour) iarmour=Common.MaxArmour; 
			armour+="<font color='#00ff00'>+"+Math.round((iarmour * 100)/256).toString()+"%</font>";
		}
		if(armour!="") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Armour+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:armour, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// MaxHP
		var hp:int=EM.ShipMaxHP(owner,shipid,shiptype,race);
		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.MaxHP+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(hp), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Repair
		var repair:String="";
		if(EM.ShipRepair(owner,shipid,shiptype)!=0) {
			repair+=EM.ShipRepair(owner,shipid,shiptype).toString();
		}
		if(repair!="") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Repair+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:repair, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// ShieldReduce
		var sr:String = "";
		var ishieldreduce:int = EM.ShipShieldReduce(owner, shipid, shiptype, race);
//		if (shiptype == Common.ShipTypeFlagship && EM.VecValE(owner, shipid, Common.VecProtectShieldReduce) != 0) sr += "<font color='#00ff00'>+" + Math.round((EM.VecValE(owner, shipid, Common.VecProtectShieldReduce) * 100) / 256).toString() + "%</font>";
//		if (shiptype == Common.ShipTypeQuarkBase && EM.DirValE(owner, Common.DirQuarkBaseShieldReduce) != 0) sr += "<font color='#00ff00'>+" + Math.round((EM.DirValE(owner, Common.DirQuarkBaseShieldReduce) * 100) / 256).toString() + "%</font>";
//		if (race == Common.RaceTechnol && shiptype != Common.ShipTypeFlagship && !Common.IsBase(shiptype)) sr += "<font color='#00ff00'>+" + Math.round((77 * 100) / 256).toString() + "%</font>";
//		if(armoursub!=0) {
//			sr+="<font color='#ff0000'>-"+Math.round((armoursub * 100)/256).toString()+"%</font>";
//		}
		if(ishieldreduce>0) {
			sr+="<font color='#00ff00'>+"+Math.round((ishieldreduce * 100)/256).toString()+"%</font>";
		}
		if (sr != "") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ShieldReduce+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:sr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Shield
		var sh:int=0;
		//if (shiptype == Common.ShipTypeFlagship || shiptype == Common.ShipTypeQuarkBase)
		sh=EM.ShipMaxShield(owner,shipid,shiptype,race,1);
		if(sh!=0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.MaxShield+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(sh), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Shield inc
		sh=0;
		if(shiptype==Common.ShipTypeFlagship) {
			sh=EM.VecValE(owner,shipid,Common.VecProtectShieldInc);
//			if((ship.m_Flag & Common.ShipFlagPolar)!=0) sh=sh*3;
		}
		if(shiptype==Common.ShipTypeQuarkBase) {
			sh = EM.DirValE(owner, Common.DirQuarkBaseShieldInc);
//			if((ship.m_Flag & Common.ShipFlagPolar)!=0) sh=sh*3;
		}
		if(sh!=0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.IncShield+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(sh), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		BuildGrid(ar);

		Prepare(ax,ay,ax+sx,ay+sy);
	}

	public function ShowShip(secx:int,secy:int,planetnum:int,shipnum:int):void
	{
		var i:int, u:int, bp:int;
		var ac:int;
		var tgtship:Ship;
		var user:User=null;
		var cpt:Cpt=cpt;
		var val:Number;
		var addval:int;
		var addstr:String;
		var uni:Union=null;

//		if(m_SectorX==secx && m_SectorY==secy && m_PlanetNum==planetnum && m_ShipNum==shipnum) return;
//		m_HintNew = !visible;
//		Hide();
		
		var pnax:int=1;
		
		var planet:Planet=EM.GetPlanet(secx,secy,planetnum);
		if(planet==null) return;

		var ship:Ship=EM.GetShip(secx,secy,planetnum,shipnum);
		if(ship==null || ship.m_Type==Common.ShipTypeNone) return;

		var gs:GraphShip=EM.GetGraphShip(secx,secy,planetnum,shipnum);
		if(gs==null) return;

		var monuk:Boolean=false;
		var warbase_armourall:Boolean=false;
		var shipyard_repairall:int=0;
		var armoursub:int=0;

		for(i=0;i<Common.ShipOnPlanetMax;i++) {
			var curship:Ship=planet.m_Ship[i];
			if(curship.m_Type==Common.ShipTypeNone) continue;
			if (curship.m_ArrivalTime >= EM.m_ServerCalcTime) continue;
			if(curship.m_Flag & (Common.ShipFlagBuild)) continue;
			if(curship.m_Owner!=ship.m_Owner) {
				if(curship.m_Type!=Common.ShipTypeFlagship) continue;
				if(!(curship.m_Flag & Common.ShipFlagBattle)) continue;
				if(EM.IsFriendEx(planet,curship.m_Owner,curship.m_Race,ship.m_Owner,ship.m_Race)) continue;
				armoursub=Math.max(armoursub,EM.VecValE(curship.m_Owner, curship.m_Id, Common.VecSystemDisintegrator));
			} else {
				if ((curship.m_Flag & Common.ShipFlagBattle) != 0 && curship.m_ItemType == Common.ItemTypeMonuk && (curship.m_ItemCnt > 0)) monuk = true;
				if(curship.m_Type==Common.ShipTypeShipyard) shipyard_repairall+=curship.m_Cnt; 
				if ((curship.m_Flag & Common.ShipFlagBattle) != 0 && curship.m_Type == Common.ShipTypeWarBase) warbase_armourall = true;
			}
		}
		if(shipyard_repairall>4) shipyard_repairall=4;
		
		var planetarmour:int=0;
		if(ship.m_Owner==planet.m_Owner/* && ship.m_Owner==Server.Self.m_UserId*/) {
			planetarmour=EM.DirValE(ship.m_Owner,Common.DirPlanetProtect,true);
			//planetarmour=Common.DirPlanetProtectLvlRC[EM.m_FormTech.CalcDirLvl(Common.DirPlanetProtect)];		
		} 

		m_SectorX=secx;
		m_SectorY=secy;
		m_PlanetNum=planetnum;
		m_ShipNum=shipnum;

		var str:String;
		var ar:Array=new Array();
		var y:int=0;

		var showcnt:Boolean=true;
		if(ship.m_Owner==Server.Self.m_UserId) {}
		else if(EM.IsFriendEx(planet, ship.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone)) {}
		else if((EM.GetRel(ship.m_Owner,Server.Self.m_UserId) & (Common.PactControl | Common.PactBuild))!=0) {}
		else if(EM.CalcRadarPower(planet, Server.Self.m_UserId)>=0) {}
		else showcnt=false;

		// Name - Desc
		if (ship.m_Flag & Common.ShipFlagPhantom) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Phantom, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
		} else if(ship.m_Type==Common.ShipTypeFlagship) {
			user=UserList.Self.GetUser(ship.m_Owner,false);
			if(user!=null) {
				cpt=user.GetCpt(ship.m_Id);
			}

			str="";
			if(cpt!=null) str=" (<font color='#ffff00'>"+(cpt.CalcAllLvl()+1).toString()+"</font>)";
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipName[ship.m_Type]+str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipDesc[ship.m_Type], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6, auto_width:200 });
			y++;

			while(cpt!=null) {
				str = EM.Txt_CptName(Server.Self.m_CotlId, ship.m_Owner, ship.m_Id);
				if (BaseStr.Trim(str).length <= 0) break;
/*				if(ship.m_Owner==Server.Self.m_UserId) {
					var obj:Object=EM.m_FormCptBar.CptDsc(ship.m_Id);
					if(obj==null) break;
					str=obj.Name;
				} else {
					if(cpt.m_Name==null || cpt.m_Name.length<=0) break;
					str=cpt.m_Name;
				}*/
				
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Cpt+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;
				
				break;
			}
		} else if (ship.m_Type == Common.ShipTypeQuarkBase) {
			str = Common.ShipName[ship.m_Type];

			user = UserList.Self.GetUser(ship.m_Owner, false);
			if (user != null) {
				u = 0;
				var dw:uint = user.m_Tech[Common.TechQuarkBase];
				for (i = 0; i < 32; i++) {
					if ((dw & (uint(1) << i)) != 0) u++;
				}
				str += " (" + u.toString()+")";
			}

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipDesc[ship.m_Type], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6, auto_width:200 });
			y++;

			var vag:int = EM.DirValE(ship.m_Owner, Common.DirQuarkBaseAntiGravitor);
			var vgw:int = EM.DirValE(ship.m_Owner, Common.DirQuarkBaseGravWell);
			var vbh:int = EM.DirValE(ship.m_Owner, Common.DirQuarkBaseBlackHole);

			if (vag != 0 || vgw != 0 || vbh != 0) {
				str = "";
				if (vag != 0) {
					if (str.length > 0) str += "[br]";
					str += Common.Txt.InfoAntiGravitor + " (" + vag.toString() + ")";
				}
				if (vgw != 0) {
					if (str.length > 0) str += "[br]";
					str += Common.Txt.InfoGravWell + " (" + vgw.toString() + ")";
				}
				if (vbh != 0) {
					if (str.length > 0) str += "[br]";
					str += Common.Txt.InfoBlackHole + " (" + vbh.toString() + ")";
				}

				ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0x25fa53, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:200 });
				y++;
			}

		} else {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipName[ship.m_Type], clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipDesc[ship.m_Type], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6, auto_width:200 });
			y++;
		}

		// Owner
		if(ship.m_Owner!=0) {
			//str = Common.Txt.Load;
			user = UserList.Self.GetUser(ship.m_Owner);
			str = "";
			if (user && (ship.m_Owner & Common.OwnerAI) == 0) str += Common.UserRankName[(user.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift] + " ";
			//if(user) str=user.m_Name;
			str += EM.Txt_CotlOwnerName(Server.Self.m_CotlId, ship.m_Owner);

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Owner+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;

//			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Owner+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
		}
		
		// Union
		while(ship.m_Owner!=0) {
			user=UserList.Self.GetUser(ship.m_Owner);
			if(user==null) break;
			if(user.m_UnionId==0) break;
			uni=UserList.Self.GetUnion(user.m_UnionId);
			if(uni==null) break;
		
			ar.push({x:0, y:y, sx:3, sy:1, txt:uni.NameUnion()+" "+uni.m_Name, clr:0x00b7ff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;

			break;
		}
		
		if (ship.m_Flag & Common.ShipFlagPhantom) {
			BuildGrid(ar);
			Prepare(gs.x - 30, gs.y - 30, gs.x + 30, gs.y + 30);
			return;
		}

		// Fleet
/*		while((ship.m_FleetCptId) && (ship.m_Owner==Server.Self.m_UserId)) {
			user=UserList.Self.GetUser(ship.m_Owner);
			if(user==null) break;
			
			cpt=user.GetCpt(ship.m_FleetCptId);
			if(cpt==null) break;
			
			if(ship.m_Owner==Server.Self.m_UserId) {
				var cptdsc:Object=EM.m_FormCptBar.CptDsc(cpt.m_Id);
				if(cptdsc==null) break;
				str=cptdsc.Name;
			} else str=cpt.m_Name;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.FleetIn+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;
			
			break;
		}*/

		if(1) { // Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Count
		if(ship.m_Type!=Common.ShipTypeFlagship && ship.m_Type!=Common.ShipTypeQuarkBase) {
			str=ship.m_Cnt.toString();
			if(!showcnt) str="-";

//trace(EM.CalcRadarPower(planet, Server.Self.m_UserId));

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Count+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// CntDestroy
		if((ship.m_Type!=Common.ShipTypeFlagship) && (ship.m_CntDestroy!=0)) {
			str=ship.m_CntDestroy.toString();
			if(!showcnt) str="-";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.CntDestroy+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		// Mass
		if (ship.m_Owner==Server.Self.m_UserId) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Mass+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(EM.ShipMass(ship.m_Owner, ship.m_Id, ship.m_Type) * ship.m_Cnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		// Fuel
		if((EM.IsEdit() || EM.AccessControl(ship.m_Owner)) && !Common.IsBase(ship.m_Type)) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Fuel+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:Math.floor(ship.m_Fuel / Common.FuelFlyOne).toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;

		}
		
		if(1/*ship.m_Type==Common.ShipTypeFlagship*/) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Power
		var power:int=EM.ShipPower(ship.m_Owner,ship.m_Type);
		if(power>0 && ship.m_Type!=Common.ShipTypeFlagship) {
			power=power*ship.m_Cnt;

			if(ship.m_Type==Common.ShipTypeCruiser) power<<=1;
			else if(ship.m_Type==Common.ShipTypeWarBase) power<<=1;

			if (ship.m_Type == Common.ShipTypeKling0) { }
			else if (ship.m_Type == Common.ShipTypeQuarkBase) { }
			else if(power>=Common.FinalPower.length) power=Common.FinalPower[Common.FinalPower.length-1];
			else power = Common.FinalPower[power];

			if ((ship.m_Owner & Common.OwnerAI) != 0) power = (power * user.m_PowerMul) >> 8;

			if ((ship.m_Type != Common.ShipTypeFlagship) && (!Common.IsBase(ship.m_Type))) {
				if (ship.m_Race == Common.RacePeople) power = (power * 333) >> 8;//130% power += power >> 2;
				if ((ship.m_Race == Common.RacePeleng) && EM.IsInFrontLine(planet, shipnum)) power += power >> 1;
			}

//			if(EM.m_CotlType==Common.CotlTypeUser && EM.m_FormMiniMap.m_Occupancy>=95 && (ship.m_Type==Common.ShipTypeKling0 || ship.m_Type==Common.ShipTypeKling1)) power*=3;
//			if(EM.m_CotlType==Common.CotlTypeRich && EM.m_FormMiniMap.m_Occupancy>Common.OccupancyRichCritical && (ship.m_Type==Common.ShipTypeKling0 || ship.m_Type==Common.ShipTypeKling1)) power*=3;

			bp = EM.ShipAccuracy(ship.m_Owner, ship.m_Type);
			//if (bp > Common.MaxAccuracy) bp = Common.MaxAccuracy;
			addval=Math.round((power*bp)/256);
			bp=0;
			if ((ship.m_ItemType == Common.ItemTypePower) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower;
			else if ((ship.m_ItemType == Common.ItemTypePower2) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower2;
			if(bp>0) addval+=Math.round(((power+addval)*bp)/256)

			addstr='';
			if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

			//if(ship.m_ItemType==Common.ItemTypePower) addpower="<font color='#00ff00'>+"+(1+(power*Common.BonusPower)>>8).toString()+"</color>";
			//else if(ship.m_ItemType==Common.ItemTypePower2) addpower="<font color='#00ff00'>+"+(1+(power*Common.BonusPower2)>>8).toString()+"</color>";

			str = BaseStr.FormatBigInt(power) + addstr;

			if (ship.m_Type == Common.ShipTypeCorvette) {
				var ie:int = 0;
				if (ship.m_Owner == 0) ie = EM.FindNearEnemy(secx, secy, planetnum, shipnum, 0xffffffff, 1, true);
				else {
//					ie = EM.FindNearEnemy(secx, secy, planetnum, shipnum, 0xffffffff, 1, true);
					ie = EM.FindNearEnemy(secx, secy, planetnum, shipnum, ~((1 << Common.ShipTypeCruiser) | (1 << Common.ShipTypeCorvette)), 2, true);
					if (ie < 0) ie = EM.FindNearEnemy(secx, secy, planetnum, shipnum, 0xffffffff, 1, true);
				}
				if (ie < 0 && !EM.HaveEnemyInBattle(planet, ship.m_Owner, ship.m_Race)) ie = EM.FindNearEnemy(secx, secy, planetnum, shipnum, 0xffffffff, 1, false);
				if (ie >= 0) {
					var ship2:Ship = planet.m_Ship[ie];
					if (ship2.m_Type != Common.ShipTypeWarBase) {
						u = CorvetteMulPower[Math.max(0, Math.min(999, ship2.m_Cnt))];
						str += " [crt]x" + u.toString() + "[/crt]";
					}
				}
			}

			if(!showcnt) str="-";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Power+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		// Dreadnought transiver
		if (ship.m_Type == Common.ShipTypeDreadnought && ship.m_Race == Common.RaceTechnol) {
			power = EM.ShipPower(ship.m_Owner, ship.m_Type);
			power = power * ship.m_Cnt;

			if(power>=Common.FinalPower.length) power=Common.FinalPower[Common.FinalPower.length-1];
			else power = Common.FinalPower[power];
			//power <<= 1;

			addval=0;//Math.round((transiver*ac)/256);
			bp=0;
			if ((ship.m_ItemType == Common.ItemTypePower) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower;
			else if ((ship.m_ItemType == Common.ItemTypePower2) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower2;
			if(bp>0) addval+=Math.round(((power+addval)*bp)/256)

			addstr='';
			if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerTransiver+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(power)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		// Devastator Accuracy
		//ac=EM.DirValE(ship.m_Owner,Common.DirDevastatorAccuracy);
		while(ship.m_Type==Common.ShipTypeDevastator) {
			user=UserList.Self.GetUser(ship.m_Owner,false);
			if(user==null) break;
			var lvl:int=user.CalcDirLvl(Common.DirDevastatorAccuracy);
			ac=Common.DirDevastatorAccuracyHitLvl[lvl];

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Accuracy+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Math.round(ac*100/256).toString()+"%", clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			break;
		}
		
		//
		if (true) {//ship.m_Type == Common.ShipTypeQuarkBase) {
			// Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Flagship
		if(ship.m_Type==Common.ShipTypeFlagship) {
			var cannon:int=EM.VecValE(ship.m_Owner, ship.m_Id, Common.VecAttackCannon);
			var laser:int=EM.VecValE(ship.m_Owner, ship.m_Id, Common.VecAttackLaser);
			var missile:int=EM.VecValE(ship.m_Owner, ship.m_Id, Common.VecAttackMissile);
			var transiver:int=EM.VecValE(ship.m_Owner, ship.m_Id, Common.VecAttackTransiver);
			if (cannon == 0 && laser == 0 && missile == 0) cannon = Common.VecAttackCannonLvl[1] >> 1;

			if ((ship.m_Owner & Common.OwnerAI) != 0) {
				cannon = (cannon * user.m_PowerMul) >> 8;
				laser = (laser * user.m_PowerMul) >> 8;
				missile = (missile * user.m_PowerMul) >> 8;
			}

			ac=EM.VecValE(ship.m_Owner, ship.m_Id, Common.VecAttackAccuracy);

			if(cannon) {
				addval=Math.round((cannon*ac)/256);
				bp=0;
				if ((ship.m_ItemType == Common.ItemTypePower) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower;
				else if ((ship.m_ItemType == Common.ItemTypePower2) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower2;
				if(bp>0) addval+=Math.round(((cannon+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerCannon+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cannon)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(laser) {
				addval=Math.round((laser*ac)/256);
				bp=0;
				if ((ship.m_ItemType == Common.ItemTypePower) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower;
				else if ((ship.m_ItemType == Common.ItemTypePower2) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower2;
				if(bp>0) addval+=Math.round(((laser+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerLaser+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(laser)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(missile) {
				addval=Math.round((missile*ac)/256);
				bp=0;
				if ((ship.m_ItemType == Common.ItemTypePower) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower;
				else if ((ship.m_ItemType == Common.ItemTypePower2) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower2;
				if(bp>0) addval+=Math.round(((missile+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerMissile+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(missile)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(transiver) {
				addval=0;//Math.round((transiver*ac)/256);
				bp=0;
				if ((ship.m_ItemType == Common.ItemTypePower) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower;
				else if ((ship.m_ItemType == Common.ItemTypePower2) && (ship.m_ItemCnt > 0)) bp = Common.BonusPower2;
				if(bp>0) addval+=Math.round(((transiver+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerTransiver+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(transiver)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			
			if(uni!=null) {
				var pcg:int = Math.floor(uni.m_BonusCotlCnt / EM.m_GalaxyAllCotlCnt * 100);
				if (pcg > 40) {
					var fsp:int = (pcg - 40) * 2;
					if (fsp > 90) fsp = 90;

					ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FlagshipPowerDecShort+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
						ar.push({x:2, y:y, sx:1, sy:1, txt:"-" + fsp.toString() + "%", clr:0xff0000, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
			}
		}

		if(ship.m_Type==Common.ShipTypeFlagship) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Armour
		var armour:String="";
		var iarmour:int=planetarmour+EM.ShipArmour(ship.m_Owner,ship.m_Id,ship.m_Type);
//		if(ship.m_Type==Common.ShipTypeCorvette && (planet.m_Flag & (Planet.PlanetFlagGravitor | Planet.PlanetFlagGravitorSci))!=0) iarmour*=3; 
		if (warbase_armourall) {
			iarmour += EM.DirValE(ship.m_Owner, Common.DirWarBaseArmourAll);

			user=UserList.Self.GetUser(ship.m_Owner,false);
			if (user != null && user.m_UnionId != 0) {
				var union:Union = UserList.Self.GetUnion(user.m_UnionId);
				if (union != null) iarmour += Common.CotlBonusValEx(Common.CotlBonusWarBaseArmourAll, union.m_Bonus[Common.CotlBonusWarBaseArmourAll]);
			}
		}
		if(monuk) iarmour+=Common.BonusMonuk;
		if ((ship.m_ItemType == Common.ItemTypeArmour) && (ship.m_ItemCnt > 0)) iarmour += Common.BonusArmour;
		if ((ship.m_ItemType == Common.ItemTypeArmour2) && (ship.m_ItemCnt > 0)) iarmour += Common.BonusArmour2;
		if(iarmour>0) {
			if(iarmour>Common.MaxArmour) iarmour=Common.MaxArmour; 
		//if((ship.m_ItemType==Common.ItemTypeArmour) || monuk || planetarmour>0 || iarmour>0) {
//			if(monuk) iarmour+=Common.BonusMonuk;
//			if(ship.m_ItemType==Common.ItemTypeArmour) iarmour+=Common.BonusArmour;
//			if(ship.m_ItemType==Common.ItemTypeArmour2) iarmour+=Common.BonusArmour2;
//			iarmour+=planetarmour;
			armour+="<font color='#00ff00'>+"+Math.round((iarmour * 100)/256).toString()+"%</font>";
		}
		if(armoursub!=0) {
			armour+="<font color='#ff0000'>-"+Math.round((armoursub * 100)/256).toString()+"%</font>";
		}
		if(armour!="") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Armour+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:armour, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// MaxHP
		var hp:int=EM.ShipMaxHP(ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Race);
		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.MaxHP+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(hp), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Damage
		var damage:int=hp-ship.m_HP;
		if(damage>0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Damage+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(damage), clr:0xff4000, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Repair
		var repair:String="";
		if(EM.ShipRepair(ship.m_Owner,ship.m_Id,ship.m_Type)!=0) {
			repair+=EM.ShipRepair(ship.m_Owner,ship.m_Id,ship.m_Type).toString();
		}
		var addr:int=0;
		if (shipyard_repairall != 0) {
			var v:int = EM.DirValE(ship.m_Owner, Common.DirShipyardRepairAll);
			if (uni != null) v += Common.CotlBonusValEx(Common.CotlBonusShipyardRepairAll,uni.m_Bonus[Common.CotlBonusShipyardRepairAll]);
			//if (v > Common.MaxRepairAll) v = Common.MaxRepairAll;

			if(Common.IsBase(ship.m_Type)) addr+=(v>>4)*shipyard_repairall;
			else addr += v * shipyard_repairall;
		}
		if ((ship.m_ItemType == Common.ItemTypeRepair) && (ship.m_ItemCnt > 0)) addr += Common.BonusRepair;
		else if ((ship.m_ItemType == Common.ItemTypeRepair2) && (ship.m_ItemCnt > 0)) addr += Common.BonusRepair2;
		if(addr>0) repair+="<font color='#00ff00'>+"+addr.toString()+"</font>";
		if(repair!="") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Repair+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:repair, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// ShieldReduce
		var sr:String = "";
		var ishieldreduce:int = EM.ShipShieldReduce(ship.m_Owner, ship.m_Id, ship.m_Type, ship.m_Race);
//		if (ship.m_Type == Common.ShipTypeFlagship && EM.VecValE(ship.m_Owner, ship.m_Id, Common.VecProtectShieldReduce) != 0) sr += "<font color='#00ff00'>+" + Math.round((EM.VecValE(ship.m_Owner, ship.m_Id, Common.VecProtectShieldReduce) * 100) / 256).toString() + "%</font>";
//		if (ship.m_Type == Common.ShipTypeQuarkBase && EM.DirValE(ship.m_Owner, Common.DirQuarkBaseShieldReduce) != 0) sr += "<font color='#00ff00'>+" + Math.round((EM.DirValE(ship.m_Owner, Common.DirQuarkBaseShieldReduce) * 100) / 256).toString() + "%</font>";
//		if (ship.m_Race == Common.RaceTechnol && ship.m_Type != Common.ShipTypeFlagship && !Common.IsBase(ship.m_Type)) sr += "<font color='#00ff00'>+" + Math.round((128 * 100) / 256).toString() + "%</font>";
		if(ishieldreduce>0) {
			sr += "<font color='#00ff00'>" + Math.round((ishieldreduce * 100) / 256).toString() + "%</font>";
		}
		if(armoursub!=0) {
			sr += "<font color='#ff0000'>-" + Math.round((armoursub * 100) / 256).toString() + "%</font>";
		}
		if(sr!="") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ShieldReduce+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:sr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Shield
		var sh:int=0;
		//if(ship.m_Type==Common.ShipTypeFlagship || ship.m_Type==Common.ShipTypeQuarkBase)
		sh=EM.ShipMaxShield(ship.m_Owner,ship.m_Id,ship.m_Type,ship.m_Race,ship.m_Cnt);//EM.VecValE(ship.m_Owner,ship.m_Id,Common.VecProtectShield);
		if(sh!=0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.MaxShield+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(sh), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Shield damage
		if (ship.m_Shield != 0 && ship.m_Type != Common.ShipTypeFlagship && ship.m_Type != Common.ShipTypeQuarkBase && ship.m_Race == Common.RaceGaal) {
			ar.push( { x:1, y:y, sx:1, sy:1, txt:Common.Txt.ValBarrier + ":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				ar.push( { x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(ship.m_Shield), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;

		} else if ((ship.m_Shield != 0 || ship.m_Type == Common.ShipTypeFlagship || ship.m_Type == Common.ShipTypeQuarkBase) && ship.m_Race !== Common.RacePeople) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ValShield+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(ship.m_Shield)/*Math.round(ship.m_Shield/sh*100.0).toString()+"%"*/, clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Shield inc
		sh=0;
		if(ship.m_Type==Common.ShipTypeFlagship) {
			sh=EM.VecValE(ship.m_Owner,ship.m_Id,Common.VecProtectShieldInc);
			if((ship.m_Flag & Common.ShipFlagPolar)!=0) sh=sh*3;
		}
		if(ship.m_Type==Common.ShipTypeQuarkBase) {
			sh = EM.DirValE(ship.m_Owner, Common.DirQuarkBaseShieldInc);
			if((ship.m_Flag & Common.ShipFlagPolar)!=0) sh=sh*3;
		}
		if(sh!=0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.IncShield+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(sh), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(true/*ship.m_Type==Common.ShipTypeFlagship*/) { // space
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}
		
/*		// Fleet
		while((ship.m_Type==Common.ShipTypeFlagship) && (ship.m_Owner==Server.Self.m_UserId)) {
			user=UserList.Self.GetUser(Server.Self.m_UserId);
			if(user==null) break;
			
			cpt=user.GetCpt(ship.m_Id);
			if(cpt==null) break;
			
			if(cpt.m_StatTransportCnt!=0);
			else if(cpt.m_StatCorvetteCnt!=0);
			else if(cpt.m_StatCruiserCnt!=0);
			else if(cpt.m_StatDreadnoughtCnt!=0);
			else if(cpt.m_StatInvaderCnt!=0);
			else if(cpt.m_StatDevastatorCnt!=0);
			else if(cpt.m_StatGroupCnt!=0);
			else break;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FleetCaption+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			if(cpt.m_StatTransportCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeTransport]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatTransportCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatCorvetteCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeCorvette]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatCorvetteCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatCruiserCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeCruiser]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatCruiserCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatDreadnoughtCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeDreadnought]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatDreadnoughtCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatInvaderCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeInvader]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatInvaderCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatDevastatorCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeDevastator]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatDevastatorCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatGroupCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FleetGroupCnt+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatGroupCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(true) { // space
				ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
				y++;
			}

			break;
		}*/

		// Cost
//		if(ship.m_Type!=Common.ShipTypeFlagship && ship.m_Race!=Common.RaceKling) {
//			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Cost+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(EM.ShipCost(planet.m_Owner,ship.m_Type)), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
//		}

		// Build
		if(ship.m_Flag & Common.ShipFlagBuild) {
			str = Common.FormatPeriod((ship.m_BattleTimeLock - EM.m_ServerCalcTime) / 1000).toString();

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.BuildTime+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
//			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BuildTime+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
		}

		// Portal
		if(ship.m_Flag & Common.ShipFlagPortal) {
			str = Common.FormatPeriod((ship.m_BattleTimeLock - EM.m_ServerCalcTime) / 1000).toString();
			
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.PortalTime+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
//			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PortalTime+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
		}

		// Eject
		if(ship.m_Flag & Common.ShipFlagEject) {
			str = Common.FormatPeriod((ship.m_BattleTimeLock - EM.m_ServerCalcTime) / 1000).toString();
			
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.EjectTime+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Bomb
		if(ship.m_Flag & Common.ShipFlagBomb) {
			str = Common.FormatPeriod((ship.m_BattleTimeLock - EM.m_ServerCalcTime) / 1000).toString();

			ar.push( { x:0, y:y, sx:3, sy:1, txt:((ship.m_Type == Common.ShipTypeDevastator)?Common.Txt.BombTime:Common.Txt.BlastingTime) + ": <font color='#ffff00'>" + str + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;

//			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BombTime+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
		}
		
		// Invu
		if((ship.m_Flag & (Common.ShipFlagInvu | Common.ShipFlagInvu2))!=0) {
			val = 0;
			while ((ship.m_Flag & Common.ShipFlagInvu) != 0) {
				if(ship.m_Type!=Common.ShipTypeFlagship) break;

				user=UserList.Self.GetUser(ship.m_Owner,false);
				if(user==null) break;
				cpt=user.GetCpt(ship.m_Id);
				if (cpt == null) break;

				if (EM.VecValE(ship.m_Owner, ship.m_Id, Common.VecProtectInvulnerability) != 1) break;

				if (cpt.m_InvuCooldown > EM.m_ServerCalcTime) val = Math.max(val, cpt.m_InvuCooldown - EM.m_ServerCalcTime);

				break;
			}
			if((ship.m_Flag & Common.ShipFlagInvu2)!=0) {
				for(i=0;i<Common.ShipOnPlanetMax;i++) {
					tgtship=planet.m_Ship[i];
					if(tgtship.m_Type!=Common.ShipTypeFlagship) continue;
					if (tgtship.m_Owner != ship.m_Owner) continue;
					if ((tgtship.m_Flag & Common.ShipFlagInvu2) == 0) continue;

					user=UserList.Self.GetUser(tgtship.m_Owner,false);
					if(user==null) continue;
					cpt=user.GetCpt(tgtship.m_Id);
					if (cpt == null) continue;

					if (EM.VecValE(tgtship.m_Owner, tgtship.m_Id, Common.VecProtectInvulnerability) < 2) continue;

					if(cpt.m_InvuCooldown>EM.m_ServerCalcTime) val=Math.max(val,cpt.m_InvuCooldown-EM.m_ServerCalcTime);
				}
			}
			if(val>0) {
				str=Common.FormatPeriod(val/1000);
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.InvuOff+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		if (ship.m_Type == Common.ShipTypeQuarkBase) {
			if (ship.m_AbilityCooldown0 > EM.m_ServerCalcTime) {
				str=Common.FormatPeriod((ship.m_AbilityCooldown0-EM.m_ServerCalcTime)/1000);
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.CooldownAntiGravitor+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if (ship.m_AbilityCooldown1 > EM.m_ServerCalcTime) {
				str=Common.FormatPeriod((ship.m_AbilityCooldown1-EM.m_ServerCalcTime)/1000);
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.CooldownGravWell+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if (ship.m_AbilityCooldown2 > EM.m_ServerCalcTime) {
				str=Common.FormatPeriod((ship.m_AbilityCooldown2-EM.m_ServerCalcTime)/1000);
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.CooldownBlackHole+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if ((ship.m_BattleTimeLock > EM.m_ServerCalcTime) && ((ship.m_Flag & Common.ShipFlagBattle) != 0) && (ship.m_Flag & (Common.ShipFlagPortal | Common.ShipFlagBuild | Common.ShipFlagBomb)) == 0) {
				str = Common.FormatPeriod((ship.m_BattleTimeLock - EM.m_ServerCalcTime) / 1000);
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.ReloadReactor+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		if(ship.m_Type==Common.ShipTypeFlagship) {
			while(true) {
				user=UserList.Self.GetUser(ship.m_Owner,false);
				if(user==null) break;
				cpt=user.GetCpt(ship.m_Id);
				if(cpt==null) break;

				if(cpt.m_RechargeCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_RechargeCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.RechargeOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if(cpt.m_ConstructorCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_ConstructorCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.ConstructorOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if((ship.m_Flag & (Common.ShipFlagInvu | Common.ShipFlagInvu2))==0 && cpt.m_InvuCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_InvuCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.InvuOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;

//					ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.InvuOn+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//						ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod((cpt.m_InvuCooldown-EM.GetServerTime())/1000), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//					y++;
				}
				
				if(/*!(planet.m_Flag & Planet.PlanetFlagGravitor) &&*/ cpt.m_GravitorCooldown>EM.m_ServerCalcTime) {
					str = Common.FormatPeriod((cpt.m_GravitorCooldown - EM.m_ServerCalcTime) / 1000);

					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.GravitorOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;

//					ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.GravitorOn+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//						ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod((cpt.m_GravitorCooldown-EM.GetServerTime())/1000), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//					y++;
				}
				if(cpt.m_AcceleratorCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_AcceleratorCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.AcceleratorOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;

//					ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.AcceleratorOn+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//						ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod((cpt.m_AcceleratorCooldown-EM.GetServerTime())/1000), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//					y++;
				}
				if(cpt.m_CoverCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_CoverCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.CoverOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;

//					ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.CoverOn+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//						ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod((cpt.m_CoverCooldown-EM.GetServerTime())/1000), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//					y++;
				}
				if(cpt.m_ExchangeCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_ExchangeCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.ExchangeOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if(cpt.m_PortalCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_PortalCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.PortalOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}

				break;
			}
		}

		if(ship.m_Race==Common.RacePeleng && ship.m_Type!=Common.ShipTypeFlagship && !Common.IsBase(ship.m_Type) && ship.m_AbilityCooldown0>EM.m_ServerCalcTime) {
			str=Common.FormatPeriod((ship.m_AbilityCooldown0-EM.m_ServerCalcTime)/1000);
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.AcceleratorOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if (((ship.m_Race == Common.RaceGaal) && (ship.m_Type != Common.ShipTypeFlagship) && (!Common.IsBase(ship.m_Type)))) {
			if(ship.m_AbilityCooldown0>EM.m_ServerCalcTime) {
				str=Common.FormatPeriod((ship.m_AbilityCooldown0-EM.m_ServerCalcTime)/1000);
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.BarrierOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		if (EM.m_Debug) {
//var tgs:GraphShip = EmpireMap.Self.GetGraphShipById(ship.m_Id);
			ar.push( { x:0, y:y, sx:3, sy:1, txt:"Id: <font color='#ffff00'>0x" + ship.m_Id.toString(16)
//				+" nn:" + tgs.m_NewNum.toString()
				+"</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:"Owner: <font color='#ffff00'>0x"+ship.m_Owner.toString(16)+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:"ArrivalTime: <font color='#ffff00'>"+(ship.m_ArrivalTime-EM.m_ServerCalcTime).toString()+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:"Flag: <font color='#ffff00'>"+(ship.m_Flag).toString(16)+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push( { x:0, y:y, sx:3, sy:1, txt:"From: <font color='#ffff00'>" + ship.m_FromSectorX.toString() + "," + ship.m_FromSectorY.toString() + "," + ship.m_FromPlanet.toString() + "," + ship.m_FromPlace.toString() + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:"Cargo: <font color='#ffff00'>"+(ship.m_CargoType).toString(16)+" "+(ship.m_CargoCnt).toString()+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push( { x:0, y:y, sx:3, sy:1, txt:"Link: <font color='#ffff00'>" + (ship.m_Link).toString(16) + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		// exp Flagship
		while(ship.m_Owner!=Server.Self.m_UserId && ship.m_Owner!=0 && ship.m_Type==Common.ShipTypeFlagship) {
			if (ship.m_Flag & Common.ShipFlagBuild) break;
			if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && (EM.m_OpsFlag & Common.OpsFlagPlayerExp) == 0) break;

			user=UserList.Self.GetUser(ship.m_Owner);
			if(user==null) break;
			cpt=user.GetCpt(ship.m_Id);
			if(cpt==null) break;

			i=(1+cpt.CalcAllLvl())*250;

			if (EM.m_CotlType == Common.CotlTypeCombat && (EM.m_CombatFlag & FormCombat.FlagRandom) != 0) i = (i * FormCombat.ExpRandomMul) >> 8;
			else if (EM.m_CotlType == Common.CotlTypeCombat && (EM.m_CombatFlag & FormCombat.FlagDuel) != 0) i = (i * FormCombat.ExpDuelMul) >> 8;
			else if (EM.m_CotlType == Common.CotlTypeCombat) i = (i * FormCombat.ExpCombatMul) >> 8;

			str=Common.Txt.FlagshipExp;
			addstr=BaseStr.FormatBigInt(i);
			if ((EM.m_Access & Common.AccessPlusarCaptain) && ((EM.m_UserCaptainEnd > EM.GetServerGlobalTime()) || (EM.m_UserControlEnd > EM.GetServerGlobalTime()))) addstr += "+" + BaseStr.FormatBigInt(i);

			str=str.replace(/<Exp>/g,addstr);

			// space			
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xA0A0A0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2, auto_width:200 });
			y++;

			break;
		}
		
		// Exp Mob
		var vs:int;
		while(ship.m_Owner!=Server.Self.m_UserId && ship.m_Owner!=0 && (ship.m_Owner & Common.OwnerAI)!=0 && ship.m_Type!=Common.ShipTypeFlagship) {
			if (ship.m_Flag & Common.ShipFlagBuild) break;

			user=UserList.Self.GetUser(ship.m_Owner);
			if(user==null) break;

			str=Common.Txt.MobExp;
			vs = (Common.ShipScore[ship.m_Type] * ship.m_Cnt);// >> 1;
			if(ship.m_Type==Common.ShipTypeCorvette || ship.m_Type==Common.ShipTypeTransport || ship.m_Type==Common.ShipTypeInvader) { vs=vs>>2; if(vs<1) vs=1; }
			if(vs<1) vs=1;
			addstr=BaseStr.FormatBigInt(vs);
			if ((EM.m_Access & Common.AccessPlusarCaptain) && ((EM.m_UserCaptainEnd > EM.GetServerGlobalTime()) || (EM.m_UserControlEnd > EM.GetServerGlobalTime()))) addstr += "+" + BaseStr.FormatBigInt(vs);

			str=str.replace(/<Exp>/g,addstr);

			// space			
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xA0A0A0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2, auto_width:200 });
			y++;

			break;
		}

		// exp User
		while(ship.m_Owner!=Server.Self.m_UserId && ship.m_Owner!=0 && (ship.m_Owner & Common.OwnerAI)==0 && ship.m_Type!=Common.ShipTypeFlagship) {
			if(ship.m_Flag & Common.ShipFlagBuild) break;
			if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat || EM.m_CotlType == Common.CotlTypeRich) && (EM.m_OpsFlag & Common.OpsFlagPlayerExp) == 0) break;

			user=UserList.Self.GetUser(ship.m_Owner);
			if(user==null) break;

//			if(user.m_Rest<=0) {
//				ar.push({x:0, y:y, sx:3, sy:1, txt:StdMap.Txt.ButNoExp, clr:0xA0A0A0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
//				break;
//			}
			if(!showcnt) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.UnknowExp, clr:0xA0A0A0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2, auto_width:200 });
				break;
			}

			str=Common.Txt.ShipExp;
			//str=str.replace(/<Rest>/g,BaseStr.FormatBigInt(user.m_Rest));
			vs=Common.ShipScore[ship.m_Type]*ship.m_Cnt;
			if (ship.m_Type == Common.ShipTypeCorvette || ship.m_Type == Common.ShipTypeTransport || ship.m_Type == Common.ShipTypeInvader) vs = vs >> 2;
			
			if (EM.m_CotlType == Common.CotlTypeCombat && (EM.m_CombatFlag & FormCombat.FlagRandom) != 0) vs = (vs * FormCombat.ExpRandomMul) >> 8;
			else if (EM.m_CotlType == Common.CotlTypeCombat && (EM.m_CombatFlag & FormCombat.FlagDuel) != 0) vs = (vs * FormCombat.ExpDuelMul) >> 8;
			else if (EM.m_CotlType == Common.CotlTypeCombat) vs = (vs * FormCombat.ExpCombatMul) >> 8;
			
			//if(vs>user.m_Rest) vs=user.m_Rest;
			addstr=BaseStr.FormatBigInt(vs);
			if ((EM.m_Access & Common.AccessPlusarCaptain) && ((EM.m_UserCaptainEnd > EM.GetServerGlobalTime()) || (EM.m_UserControlEnd > EM.GetServerGlobalTime()))) addstr += "+" + BaseStr.FormatBigInt(vs);
			
			str=str.replace(/<Exp>/g,addstr);

			// space			
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xA0A0A0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2, auto_width:200 });
			y++;

			break;
		}

		// Hint
		if(EM.m_Set_Hint) {
			str = null;
			if (ship.m_Race == Common.RaceKling) str = CreateHint(Common.HintKling);
			else if (ship.m_Owner != Server.Self.m_UserId) {}
			else if (ship.m_Type == Common.ShipTypeTransport) str = CreateHint(Common.HintShip, Common.HintTransport);
			else str = CreateHint(Common.HintShip);
			if (str != null) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:/*"[justify]" +*/ Common.Txt.Hint + ": " + str /*+ "[/justify]"*/, clr:0x00ffa2, ax: -1, ay:1, fontsize:12,			cs_left:0, cs_right:0, cs_top: -3 + 5, cs_bottom: -3, auto_width:200 } );
				y++;
			}
		}

		BuildGrid(ar);

		Prepare(gs.x-30,gs.y-30,gs.x+30,gs.y+30);
	}

	public function ShowShipHyperspace(slotno:int):void
	{
		var i:int, bp:int;
		var ac:int;
		var user:User=null;
		var cpt:Cpt=cpt;
		var val:Number;
		var addval:int;
		var addstr:String;

		m_HintNew = !visible;
		Hide();
		
		var pnax:int=1;
		
		if(slotno<0 || slotno>=EM.m_FormFleetBar.m_FleetSlot.length) return;
		var slot:FleetSlot=EM.m_FormFleetBar.m_FleetSlot[slotno];
		if (slot.m_Type == Common.ShipTypeNone) return;
		
		// Union
		var uni:Union = null;
		while(true) {
			if(EM.m_UnionId==0) break;
			uni=UserList.Self.GetUnion(EM.m_UnionId);
			if(uni==null) break;
			break;
		}

		var monuk:Boolean=false;

		for(i=0;i<EM.m_FormFleetBar.m_FleetSlot.length;i++) {
			var curslot:FleetSlot=EM.m_FormFleetBar.m_FleetSlot[i];
			if(curslot.m_Type==Common.ShipTypeNone) continue;
			if ((curslot.m_ItemType == Common.ItemTypeMonuk) && (curslot.m_Cnt > 0)) monuk = true;
		}

		var str:String;
		var ar:Array=new Array();
		var y:int=0;

		user=UserList.Self.GetUser(Server.Self.m_UserId,false);

		// Name - Desc
		if(slot.m_Type==Common.ShipTypeFlagship) {
			if(user!=null) {
				cpt=user.GetCpt(slot.m_Id);
			}

			str="";
			if(cpt!=null) str=" (<font color='#ffff00'>"+(cpt.CalcAllLvl()+1).toString()+"</font>)";
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipName[slot.m_Type]+str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipDesc[slot.m_Type], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6, auto_width:200 });
			y++;

			while(cpt!=null) {
				var obj:Object=EM.m_FormCptBar.CptDsc(slot.m_Id);
				if(obj==null) break;
				str=obj.Name;

				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Cpt+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;
				
				break;
			}

		} else {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipName[slot.m_Type], clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ShipDesc[slot.m_Type], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6, auto_width:200 });
			y++;
		}

		// Owner
		if(1) {
			str=Common.Txt.Load;
			user=UserList.Self.GetUser(Server.Self.m_UserId);
			str = "";
			if (user) str += Common.UserRankName[(user.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift] + " ";
			str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Owner+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;
		}

		if(1) { // Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Count
		if(slot.m_Type!=Common.ShipTypeFlagship) {
			str=slot.m_Cnt.toString();

//trace(EM.CalcRadarPower(planet, Server.Self.m_UserId));

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Count+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// CntDestroy
		if((slot.m_Type!=Common.ShipTypeFlagship) && (slot.m_CntDestroy!=0)) {
			str=slot.m_CntDestroy.toString();

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.CntDestroy+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		// Mass
		if (1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Mass+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(EM.ShipMass(Server.Self.m_UserId, slot.m_Id, slot.m_Type) * slot.m_Cnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		if(1/*slot.m_Type==Common.ShipTypeFlagship*/) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Power
		var power:int=EM.ShipPower(Server.Self.m_UserId,slot.m_Type);
		if(power>0 && slot.m_Type!=Common.ShipTypeFlagship) {
			power=power*slot.m_Cnt;

			if(slot.m_Type==Common.ShipTypeCruiser) power<<=1;
			else if(slot.m_Type==Common.ShipTypeWarBase) power<<=1;

			if(slot.m_Type==Common.ShipTypeKling0) {}
			else if(power>=Common.FinalPower.length) power=Common.FinalPower[Common.FinalPower.length-1];
			else power = Common.FinalPower[power];

			if (user != null && (user.m_Race == Common.RacePeople) && (slot.m_Type != Common.ShipTypeFlagship) && (!Common.IsBase(slot.m_Type))) power = (power * 333) >> 8;//130% power += power >> 2;

			bp = EM.ShipAccuracy(Server.Self.m_UserId, slot.m_Type);
			//if (bp > Common.MaxAccuracy) bp = Common.MaxAccuracy;
			addval=Math.round((power*bp)/256);
			bp=0;
			if ((slot.m_ItemType == Common.ItemTypePower) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower;
			else if ((slot.m_ItemType == Common.ItemTypePower2) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower2;
			if(bp>0) addval+=Math.round(((power+addval)*bp)/256)

			addstr='';
			if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

			str=BaseStr.FormatBigInt(power)+addstr;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Power+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Dreadnought transiver
		if (slot.m_Type == Common.ShipTypeDreadnought && user!=null && user.m_Race == Common.RaceTechnol) {
			power = EM.ShipPower(Server.Self.m_UserId,slot.m_Type);
			power = power * slot.m_Cnt;

			if(power>=Common.FinalPower.length) power=Common.FinalPower[Common.FinalPower.length-1];
			else power = Common.FinalPower[power];
			//power <<= 1;

			addval=0;
			bp=0;
			if ((slot.m_ItemType == Common.ItemTypePower) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower;
			else if ((slot.m_ItemType == Common.ItemTypePower2) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower2;
			if(bp>0) addval+=Math.round(((power+addval)*bp)/256)

			addstr='';
			if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerTransiver+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(power)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Devastator Accuracy
		while(slot.m_Type==Common.ShipTypeDevastator) {
			user=UserList.Self.GetUser(Server.Self.m_UserId,false);
			if(user==null) break;
			var lvl:int=user.CalcDirLvl(Common.DirDevastatorAccuracy);
			ac=Common.DirDevastatorAccuracyHitLvl[lvl];

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Accuracy+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Math.round(ac*100/256).toString()+"%", clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			break;
		}

		if (true) {
			// Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Flagship
		if(slot.m_Type==Common.ShipTypeFlagship) {
			var cannon:int=EM.VecValE(Server.Self.m_UserId, slot.m_Id, Common.VecAttackCannon);
			var laser:int=EM.VecValE(Server.Self.m_UserId, slot.m_Id, Common.VecAttackLaser);
			var missile:int=EM.VecValE(Server.Self.m_UserId, slot.m_Id, Common.VecAttackMissile);
			var transiver:int=EM.VecValE(Server.Self.m_UserId, slot.m_Id, Common.VecAttackTransiver);
			if(cannon==0 && laser==0 && missile==0) cannon=Common.VecAttackCannonLvl[1]>>1;

			ac=EM.VecValE(Server.Self.m_UserId, slot.m_Id, Common.VecAttackAccuracy);

			if(cannon) {
				addval=Math.round((cannon*ac)/256);
				bp=0;
				if ((slot.m_ItemType == Common.ItemTypePower) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower;
				else if ((slot.m_ItemType == Common.ItemTypePower2) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower2;
				if(bp>0) addval+=Math.round(((cannon+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerCannon+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cannon)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(laser) {
				addval=Math.round((laser*ac)/256);
				bp=0;
				if ((slot.m_ItemType == Common.ItemTypePower) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower;
				else if ((slot.m_ItemType == Common.ItemTypePower2) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower2;
				if(bp>0) addval+=Math.round(((laser+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerLaser+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(laser)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(missile) {
				addval=Math.round((missile*ac)/256);
				bp=0;
				if ((slot.m_ItemType == Common.ItemTypePower) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower;
				else if ((slot.m_ItemType == Common.ItemTypePower2) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower2;
				if(bp>0) addval+=Math.round(((missile+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerMissile+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(missile)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(transiver) {
				addval=0;//Math.round((transiver*ac)/256);
				bp=0;
				if ((slot.m_ItemType == Common.ItemTypePower) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower;
				else if ((slot.m_ItemType == Common.ItemTypePower2) && (slot.m_ItemCnt > 0)) bp = Common.BonusPower2;
				if(bp>0) addval+=Math.round(((transiver+addval)*bp)/256)

				addstr='';
				if(addval>0) addstr="<font color='#00ff00'>+"+BaseStr.FormatBigInt(addval)+"</color>";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PowerTransiver+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(transiver)+addstr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(uni!=null) {
				var pcg:int = Math.floor(uni.m_BonusCotlCnt / EM.m_GalaxyAllCotlCnt * 100);
				if (pcg > 40) {
					var fsp:int = (pcg - 40) * 2;
					if (fsp > 90) fsp = 90;

					ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FlagshipPowerDecShort+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
						ar.push({x:2, y:y, sx:1, sy:1, txt:"-" + fsp.toString() + "%", clr:0xff0000, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
			}
		}

		if(slot.m_Type==Common.ShipTypeFlagship) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Armour
		var armour:String="";
		var iarmour:int=EM.ShipArmour(Server.Self.m_UserId,slot.m_Id,slot.m_Type);
		if(monuk) iarmour+=Common.BonusMonuk;
		if ((slot.m_ItemType == Common.ItemTypeArmour) && (slot.m_ItemCnt > 0)) iarmour += Common.BonusArmour;
		if ((slot.m_ItemType == Common.ItemTypeArmour2) && (slot.m_ItemCnt > 0)) iarmour += Common.BonusArmour2;
		if(iarmour>0) {
			if(iarmour>Common.MaxArmour) iarmour=Common.MaxArmour; 
			armour+="<font color='#00ff00'>+"+Math.round((iarmour * 100)/256).toString()+"%</font>";
		}
		if(armour!="") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Armour+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:armour, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// MaxHP
		var hp:int = EM.ShipMaxHP(Server.Self.m_UserId, slot.m_Id, slot.m_Type, user.m_Race);
		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.MaxHP+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(hp), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Damage
		var damage:int=hp-slot.m_HP;
		if(damage>0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Damage+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(damage), clr:0xff4000, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Repair
		var repair:String="";
		if(EM.ShipRepair(Server.Self.m_UserId,slot.m_Id,slot.m_Type)!=0) {
			repair+=EM.ShipRepair(Server.Self.m_UserId,slot.m_Id,slot.m_Type).toString();
		}
		var addr:int=0;
		if ((slot.m_ItemType == Common.ItemTypeRepair) && (slot.m_ItemCnt > 0)) addr += Common.BonusRepair;
		else if ((slot.m_ItemType == Common.ItemTypeRepair2) && (slot.m_ItemCnt > 0)) addr += Common.BonusRepair2;
		if(addr>0) repair+="<font color='#00ff00'>+"+addr.toString()+"</font>";
		if(repair!="") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Repair+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:repair, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// ShieldReduce
		var sr:String = "";
		var ishieldreduce:int = EM.ShipShieldReduce(Server.Self.m_UserId, slot.m_Id, slot.m_Type, user.m_Race);
//		if(slot.m_Type==Common.ShipTypeFlagship && EM.VecValE(Server.Self.m_UserId, slot.m_Id, Common.VecProtectShieldReduce)!=0) sr+="<font color='#00ff00'>+"+Math.round((EM.VecValE(Server.Self.m_UserId, slot.m_Id, Common.VecProtectShieldReduce) * 100)/256).toString()+"%</font>";
//		if (user != null && user.m_Race == Common.RaceTechnol && slot.m_Type != Common.ShipTypeFlagship && !Common.IsBase(slot.m_Type)) sr += "<font color='#00ff00'>+" + Math.round((128 * 100) / 256).toString() + "%</font>";
		if(ishieldreduce>0) {
			sr+="<font color='#00ff00'>+"+Math.round((ishieldreduce * 100)/256).toString()+"%</font>";
		}
		if(sr!="") {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ShieldReduce+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:sr, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Shield
		var sh:int=0;
		//if (slot.m_Type == Common.ShipTypeFlagship)
		sh=EM.ShipMaxShield(Server.Self.m_UserId,slot.m_Id,slot.m_Type,user.m_Race,slot.m_Cnt);//EM.VecValE(Server.Self.m_UserId,slot.m_Id,Common.VecProtectShield);
		if(sh!=0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.MaxShield+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(sh), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Shield damage
		if(slot.m_Shield!=0 || slot.m_Type==Common.ShipTypeFlagship) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ValShield+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(slot.m_Shield)/*Math.round(ship.m_Shield/sh*100.0).toString()+"%"*/, clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Shield inc
		sh=0;
		if(slot.m_Type==Common.ShipTypeFlagship) sh=EM.VecValE(Server.Self.m_UserId,slot.m_Id,Common.VecProtectShieldInc);
		if(sh!=0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.IncShield+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(sh), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Item		
		if(slot.m_ItemType!=Common.ItemTypeNone) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Eq+": <font color='#ffff00'>"+EM.ItemName(slot.m_ItemType)+" - "+slot.m_ItemCnt.toString()+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(true) { // space
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}
		
		if(slot.m_Type==Common.ShipTypeFlagship) {
			while(true) {
				user=UserList.Self.GetUser(Server.Self.m_UserId,false);
				if(user==null) break;
				cpt=user.GetCpt(slot.m_Id);
				if(cpt==null) break;

				if(cpt.m_RechargeCooldown>EM.m_ServerCalcTime) {
					str = Common.FormatPeriod((cpt.m_RechargeCooldown - EM.m_ServerCalcTime) / 1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.RechargeOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if(cpt.m_ConstructorCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_ConstructorCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.ConstructorOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if(cpt.m_InvuCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_InvuCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.InvuOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if(cpt.m_GravitorCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_GravitorCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.GravitorOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if (cpt.m_AcceleratorCooldown > EM.m_ServerCalcTime) {
					str = Common.FormatPeriod((cpt.m_AcceleratorCooldown - EM.m_ServerCalcTime) / 1000);
					ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.AcceleratorOn + ": <font color='#ffff00'>" + str + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
					y++;
				}
				if(cpt.m_CoverCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_CoverCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.CoverOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if(cpt.m_ExchangeCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_ExchangeCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.ExchangeOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}
				if(cpt.m_PortalCooldown>EM.m_ServerCalcTime) {
					str=Common.FormatPeriod((cpt.m_PortalCooldown-EM.m_ServerCalcTime)/1000);
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.PortalOn+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					y++;
				}

				break;
			}
		}

		// Hint
		if(EM.m_Set_Hint) {
			str = null;
			if (slot.m_Type == Common.ShipTypeTransport) str = CreateHint(Common.HintShip, Common.HintTransport);
			else str = CreateHint(Common.HintShip);
			if (str != null) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:/*"[justify]" +*/ Common.Txt.Hint + ": " + str /*+ "[/justify]"*/, clr:0x00ffa2, ax: -1, ay:0, fontsize:12,			cs_left:0, cs_right:0, cs_top: -3 + 5, cs_bottom: -3, auto_width:200 } );
				y++;
			}
		}

		BuildGrid(ar);

		var px:int=EM.m_FormFleetBar.x+FormFleetBar.SlotOffX+slotno*FormFleetBar.SlotSize;
		var py:int=EM.m_FormFleetBar.y+FormFleetBar.SlotOffY;

		Prepare(px,py,px+FormFleetBar.SlotSize,py+FormFleetBar.SlotSize);
	}

	public function ShowPlanet(secx:int, secy:int, planetnum:int):void
	{
//		if(m_SectorX==secx && m_SectorY==secy && m_PlanetNum==planetnum && m_ShipNum==-1) return;

		var planet:Planet = EM.GetPlanet(secx, secy, planetnum);
		if (planet == null) return;
		
//		trace(EM.IsFriendEx(planet, planet.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone));
//		trace(EM.IsFriendEx(planet, planet.m_Owner, Common.RaceNone, Server.Self.m_UserId, Common.RaceNone));

		var isvis:Boolean = planet.m_Vis;

//		m_HintNew = !visible;
		Hide();

		var t:Number;
		var i:int,v:int,k:int;
		var str:String;
		var user:User;
		var ar:Array=new Array();
		var y:int=0;
		var tgtship:Ship;
		var cpt:Cpt;
		var uni:Union=null;

		var ti:int=0; // 0-не игрока 1=столица 2-империя 3-цитадель 4-анклав 5-колония
		if(isvis && planet.m_Owner==Server.Self.m_UserId) {
			if(planet.m_Flag & Planet.PlanetFlagHomeworld) ti=1;
			else if (planet.m_Flag & Planet.PlanetFlagCitadel) ti = 3;
//			else if(!EM.m_EmpireColony && planet.m_Owner!=0 && planet.m_Owner==EM.m_CotlOwnerId) ti=2;
//			else if(EM.m_EmpireColony && planet.m_Island!=0 && planet.m_Island==EM.m_HomeworldIsland) ti=2;
			else if (planet.m_Owner != 0 && EM.m_CotlType == Common.CotlTypeUser && planet.m_Owner == EM.m_CotlOwnerId) {
				if(!EM.m_EmpireColony && EM.IsEmpirePlanet(planet)) ti=2;
				else if (EM.m_EmpireColony && planet.m_Island != 0 && planet.m_Island == EM.m_HomeworldIsland) ti = 2;
				else ti = 5;
			}
			//else if(planet.m_Island!=0 && planet.m_Island==EM.m_CitadelIsland) ti=4;
			else if (planet.m_Flag & Planet.PlanetFlagEnclave) ti = 4;
			else ti=5;
		}

		var occupy:Boolean=false;
		if (isvis) occupy = (EM.m_CotlType == Common.CotlTypeUser) && (planet.m_Owner != 0) && (EM.m_CotlOwnerId != planet.m_Owner);
		if (isvis && !occupy && !EM.IsWinMaxEnclave()) occupy = (EM.m_CotlType == Common.CotlTypeRich) && (planet.m_Owner != 0) && (planet.m_Owner & Common.OwnerAI) == 0 && (EM.m_OpsFlag & Common.OpsFlagEnclave) == 0;

		if(1) {
			str=EM.TxtCotl_PlanetName(secx,secy,planetnum);
			if (str.length > 0) { }
			else if((planet.m_Flag & Planet.PlanetFlagWormhole)!=0 && (planet.m_Flag & Planet.PlanetFlagLarge)!=0) str=Common.Txt.WormholeRoam;
			else if(planet.m_Flag & Planet.PlanetFlagWormhole) str=Common.Txt.Wormhole;
			else if(planet.m_Flag & Planet.PlanetFlagRich) str=Common.Txt.PlanetRich;
			else if((planet.m_Flag & Planet.PlanetFlagSun) && (planet.m_Flag & Planet.PlanetFlagLarge)) str=Common.Txt.Pulsar;
			else if(planet.m_Flag & Planet.PlanetFlagSun) str=Common.Txt.Sun;
			else if((planet.m_Flag & Planet.PlanetFlagGigant) && (planet.m_Flag & Planet.PlanetFlagLarge)) str=Common.Txt.Gigant;
			else if((planet.m_Flag & Planet.PlanetFlagGigant) && !(planet.m_Flag & Planet.PlanetFlagLarge)) str=Common.Txt.PlanetTini;
			else if(planet.m_Flag & Planet.PlanetFlagLarge) str=Common.Txt.PlanetLarge;
			else str=Common.Txt.Planet;

			if (EM.m_CotlType != Common.CotlTypeProtect && EM.m_CotlType != Common.CotlTypeCombat) {
//				if (EM.m_CotlType == Common.CotlTypeRich && (EM.m_OpsFlag & Common.OpsFlagEnclave) == 0) {
//					if(occupy) str+="<font color='#ff0000'>("+Common.Txt.Occupy+")</font>"; 
//				} else {
					if(ti==2 && EM.m_UserEmpirePlanetCnt>EM.PlanetEmpireMax(Server.Self.m_UserId)) str+="<font color='#ff0000'>("+Common.Txt.OutControl+")</font>";
					if(ti==4 && EM.m_UserEnclavePlanetCnt>EM.PlanetEnclaveMax(Server.Self.m_UserId)) str+="<font color='#ff0000'>("+Common.Txt.OutControl+")</font>";
					if(occupy) str+="<font color='#ff0000'>("+Common.Txt.Occupy+")</font>"; 
					else if(ti==5 && EM.m_UserColonyPlanetCnt>EM.PlanetColonyMax(Server.Self.m_UserId)) str+="<font color='#ff0000'>("+Common.Txt.OutControl+")</font>";
//				}
			}

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,												cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+5 });
			y++;
		}

		str=EM.TxtCotl_PlanetDesc(secx,secy,planetnum);
		if(str.length>0) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6 });
			y++;
		}
		
/*		if ((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun)) != 0) { }
		else if ((planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) { }
		else if (planet.m_Flag & Planet.PlanetFlagLarge) { }
		else {
			str = Common.Txt.Atm + ": [clr]" + Common.PlanetAtmName[(planet.m_ATT) & 7] + " " + Common.RomanNum[1 + ((planet.m_ATT >> 7) & 7)] + "[/clr]";
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:13,												cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			str = Common.Txt.Tmp + ": [clr]" + Common.PlanetTmpName[(planet.m_ATT>>3) & 3] + " " + Common.RomanNum[1 + ((planet.m_ATT >> 10) & 7)] + "[/clr]";
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:13,												cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			str = Common.Txt.Tec + ": [clr]" + Common.PlanetTecName[(planet.m_ATT>>5) & 3] + " " + Common.RomanNum[1 + ((planet.m_ATT >> 13) & 7)] + "[/clr]";
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:13,												cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}*/

		var needspace:Boolean = false;
		if(isvis && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))) {
			// Owner
			if(planet.m_Owner!=0) {
//				str=Common.Txt.Load;
				str = "";
				user = UserList.Self.GetUser(planet.m_Owner);
				if (user && (planet.m_Owner & Common.OwnerAI) == 0) str += Common.UserRankName[(user.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift] + " ";
				str += EM.Txt_CotlOwnerName(Server.Self.m_CotlId, planet.m_Owner);
				
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Owner+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;
			} else {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Owner+": <font color='#ffff00'>"+Common.Txt.Neutral+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;
			}
			
			// Union
			while(planet.m_Owner!=0) {
				user=UserList.Self.GetUser(planet.m_Owner);
				if(user==null) break;
				if(user.m_UnionId==0) break;
				uni=UserList.Self.GetUnion(user.m_UnionId);
				if(uni==null) break;

				ar.push({x:0, y:y, sx:3, sy:1, txt:uni.NameUnion()+" "+uni.m_Name, clr:0x00b7ff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;

				break;
			}
			
			needspace = true;
		}
		
		if (isvis) {
			!(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))
			
			if ((planet.m_Flag & Planet.PlanetFlagNoCapture) != 0 && (EM.IsEdit() || !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant)))) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.PlanetNoCapture, clr:0xff7394, ax:-1, ay:0, fontsize:12,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;
			}
			if((planet.m_Flag & Planet.PlanetFlagNoMove)!=0) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.PlanetNoMove, clr:0xff7394, ax:-1, ay:0, fontsize:12,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;
				needspace = true;
			}
		}

		if(needspace) { // Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		if((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge))==(Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
			str=Common.Txt.PulsarOn;
			if(planet.m_Flag & Planet.PlanetFlagStabilizer) str=Common.Txt.PulsarOff; 
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6 });
			y++;
		}

		if(planet.m_Flag & Planet.PlanetFlagWormholePrepare) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.WormholePrepare, clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6 });
			y++;
		}

		if(planet.m_Flag & Planet.PlanetFlagWormholeOpen) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.WormholeOpen, clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6 });
			y++;
		}

		if((planet.m_Flag & Planet.PlanetFlagWormhole) && !(planet.m_Flag & (Planet.PlanetFlagWormholePrepare | Planet.PlanetFlagWormholeOpen))) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.WormholeClose, clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6 });
			y++;
		}
		
		if(planet.m_Flag & Planet.PlanetFlagWormholePrepare) {
			t=(planet.m_NeutralCooldown-EM.m_ServerCalcTime)/1000;
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.WormholeOpenTime+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod(t), clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if ((planet.m_Flag & Planet.PlanetFlagWormholeOpen)) {
			if ((EM.m_CotlType == Common.CotlTypeCombat || EM.m_CotlType == Common.CotlTypeProtect) && (EM.m_OpsFlag & (Common.OpsFlagWormholeLong | Common.OpsFlagWormholeFast | Common.OpsFlagWormholeRoam)) == 0) {}
			else if(!(planet.m_Flag & Planet.PlanetFlagStabilizer)) {
				t=(planet.m_NeutralCooldown-EM.m_ServerCalcTime)/1000;
				
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.WormholeCloseTime+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod(t), clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

/*		if ((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun)) != 0) { }
		else if ((planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) { }
		else if (planet.m_Flag & Planet.PlanetFlagLarge) { }
		else {
			str = Common.PlanetAtmName[(planet.m_ATT) & 7] + " " + Common.RomanNum[1 + ((planet.m_ATT >> 7) & 7)];
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Atm+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			str = Common.PlanetTmpName[(planet.m_ATT>>3) & 3] + " " + Common.RomanNum[1 + ((planet.m_ATT >> 10) & 7)];
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Tmp+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			str = Common.PlanetTecName[(planet.m_ATT>>5) & 3] + " " + Common.RomanNum[1 + ((planet.m_ATT >> 13) & 7)];
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Tec+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}*/

		while(isvis && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))) {
//			if(planet.m_Owner==Server.Self.m_UserId) {
//				if(planet.m_Level>EM.DirValE(Server.Self.m_UserId,Common.DirPlanetLevelMax)) str="<font color='#ffffff'>"+planet.m_Level.toString()+"</font>";
//				else str=planet.m_Level.toString();
//				str+="/"+EM.DirValE(Server.Self.m_UserId,Common.DirPlanetLevelMax);
//			} else {
				str=planet.m_Level.toString();
//			}
			i = planet.PlanetLevelMax();
			if (i > 0) str += " / " + i.toString();
			
			if (planet.m_Owner == 0 && planet.m_Level == 0 && (planet.m_Flag & Planet.PlanetFlagNoCapture) != 0)  break;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Level+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			break;
		}

/*		while(isvis && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant)) && !occupy) {
			if(EM.m_CotlType!=Common.CotlTypeProtect && ti==5) break;

			user=UserList.Self.GetUser(Server.Self.m_UserId);
			if(user!=null) {
				var pm:int=planet.BuildingSpeed();
				
				if(EM.m_CotlType==Common.CotlTypeUser) {
					if((EM.m_CotlZoneLvl & 3)==3) {}
					else if((EM.m_CotlZoneLvl & 3)==2) pm+=pm>>1;
					else if((EM.m_CotlZoneLvl & 3)==1) pm+=pm;
					else  pm+=pm+(pm>>1);
				}
				
				if(EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeRich) pm*=EM.m_OpsModuleMul;
				else pm*=EM.m_ModuleMul;

				if(pm<=0) break;

				if(ti==2 && EM.m_UserEmpirePlanetCnt>EM.PlanetEmpireMax(Server.Self.m_UserId)) str="<font color='#ff0000'>"+pm.toString()+"</font>";
				else if(ti==4 && EM.m_UserEnclavePlanetCnt>EM.PlanetEnclaveMax(Server.Self.m_UserId)) str="<font color='#ff0000'>"+pm.toString()+"</font>";
				else if(ti==5 && EM.m_UserColonyPlanetCnt>EM.PlanetColonyMax(Server.Self.m_UserId)) str="<font color='#ff0000'>"+pm.toString()+"</font>";
				else str=pm.toString();
				if((EM.m_Access & Common.AccessPlusarModule) && (planet.m_Owner==Server.Self.m_UserId && ((EM.m_UserAddModuleEnd>EM.GetServerTime()) || (EM.m_UserControlEnd>EM.GetServerTime())))) {
					str+="<font color='#00ff00'>+"+((pm*Common.PlusarModuleBonus)>>8).toString()+"</font>";
				}

				if(EM.m_CotlType==Common.CotlTypeUser && planet.m_Owner==Server.Self.m_UserId && EM.m_UserMulTime>0) str="("+str+")x"+Common.MulFactor.toString();

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ResInc+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			break;
		}*/

/*		while(isvis && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant)) && planet.m_Owner==Server.Self.m_UserId) {
			if((EM.m_CotlType==Common.CotlTypeProtect || EM.m_CotlType==Common.CotlTypeRich) && (EM.m_OpsFlag & Common.OpsFlagBuildMask)==0 && EM.m_OpsCostBuildLvl==0 && EM.m_OpsModuleMul==0) break;
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Res+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:planet.m_ConstructionPoint, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			break;
		}*/

/*		while(isvis && planet.m_BuildItem!=Common.ItemTypeNone && !occupy) {
			if (EM.m_CotlType == Common.CotlTypeProtect && !EM.IsEdit()) break;
			if (EM.m_CotlType == Common.CotlTypeRich && (EM.m_OpsFlag & Common.OpsFlagEnclave) == 0) break;

			str=Common.ItemName[planet.m_BuildItem];
			v=((1+(Math.min(planet.m_Level,EM.DirValE(Server.Self.m_UserId,Common.DirPlanetLevelMax))>>6)))*EM.m_ResMul;
			if(planet.m_Flag & Planet.PlanetFlagRich) v*=Common.RichFactor;
			str+=" - "+v.toString();

			k=(v*EM.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8;
			if((EM.m_Access & Common.AccessPlusarModule) && (planet.m_Owner==Server.Self.m_UserId && ((EM.m_UserAddModuleEnd>EM.GetServerTime()) || (EM.m_UserControlEnd>EM.GetServerTime())))) k+=((v*Common.PlusarResBonus)>>8);
			if(k>0) str+="<font color='#00ff00'>+"+k.toString()+"</font>";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BuildItem+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			break;
		}*/

		if(isvis && planet.m_Refuel>0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.PlanetRefuel+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:planet.m_Refuel, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		while (isvis && planet.m_Owner != 0 && (planet.m_Owner & Common.OwnerAI) == 0) {
			user=UserList.Self.GetUser(planet.m_Owner);
			if (user == null) break;

			if (EM.m_CotlType != Common.CotlTypeRich) break;
			if ((EM.m_OpsFlag & Common.OpsFlagPlanetShield) == 0) break;
			if ( ti == 5) break;

			var planetShieldEnd:Number=EM.m_UserPlanetShieldEnd;
			var planetShieldCooldown:Number=EM.m_UserPlanetShieldCooldown;
			var hourPlanetShield:Number=EM.m_UserHourPlanetShield;
			
			if(planet.m_Owner!=Server.Self.m_UserId) {
				planetShieldEnd=user.m_PlanetShieldEnd;
				planetShieldCooldown=user.m_PlanetShieldCooldown;
				hourPlanetShield=user.m_HourPlanetShield;
			}

			if((EM.m_Access & Common.AccessPlusarShieldGlobal) && (planet.m_Owner!=0) && !(planet.m_Flag & Planet.PlanetFlagGlobalShield)) {
				var cd:Date = EM.GetServerDate();
	//EM.m_UserPlanetShieldCooldown=EM.GetServerTime()+(10+Common.GlobalShieldSleepPeriod*60)*60*1000;
				t=cd.getDate();
				if(hourPlanetShield<cd.getHours()) t++;
				var cd2:Date=new Date(cd.getFullYear(),cd.getMonth(),t,hourPlanetShield,0,0,0);
	
				t=(cd2.getTime()-cd.getTime());
				var te:Number = EM.GetServerGlobalTime() + t;
				if ((EM.m_Access & Common.AccessPlusarTech) && EM.PlusarTech()) te += Common.GlobalShieldSleepPeriodPlusar * 60 * 60 * 1000;
				else te += Common.GlobalShieldSleepPeriod * 60 * 60 * 1000;
	
				if (planetShieldCooldown > EM.GetServerGlobalTime()) {
					t = Math.max(t, planetShieldCooldown - EM.GetServerGlobalTime());
	
					if ((EM.GetServerGlobalTime() + t) > te) {
						cd2.setTime(EM.GetServerGlobalTime() + t);
						te = cd2.getDate();
						if (hourPlanetShield < cd2.getHours()) te++;
						cd2 = new Date(cd2.getFullYear(), cd2.getMonth(), te, hourPlanetShield, 0, 0, 0);

						t = (cd2.getTime() - cd.getTime());
					}
				} 
	
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.GlobalShieldFrom+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod(t/1000), clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		
			if((EM.m_Access & Common.AccessPlusarShieldGlobal) && (planet.m_Flag & Planet.PlanetFlagGlobalShield)) {
				v = Math.floor((planetShieldEnd - EM.GetServerGlobalTime()) / 1000);
				k=100;

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ShildPower+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:k.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.DeactivateShieldTime+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod(v), clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			
			break;
		}
		
		// Планетарный щит анклава
		while (isvis && planet.m_Owner != 0 && (planet.m_Owner & Common.OwnerAI) == 0 && (planet.m_Flag & Planet.PlanetFlagEnclave) != 0) {
			user=UserList.Self.GetUser(planet.m_Owner);
			if (user == null) break;

			if (EM.m_CotlType != Common.CotlTypeRich) break;
			if ((EM.m_OpsFlag & Common.OpsFlagEnclave) == 0)  break;
			
			if(1) { // Space
				ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
				y++;
			}
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.LocalShieldVal+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Math.round(100.0*planet.m_EPS_Val/Common.EPS_ValMax).toString()+"%", clr:0xffff00, ax: 1, ay:1, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			if (planet.m_Flag & Planet.PlanetFlagLocalShield) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.LocalShieldAtk+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push( { x:2, y:y, sx:1, sy:1, txt:Math.round(100.0*planet.m_EPS_AtkPower/Common.EPS_AtkMax).toString()+"%", clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.LocalShieldEnd+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push( { x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod((1000 * planet.m_EPS_TimeOff - EM.m_ServerCalcTime) / 1000), clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
			}
			break;
		}

		if (isvis && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant)) && (planet.m_ShieldEnd > EM.m_ServerCalcTime)) {
			v = Math.floor((planet.m_ShieldEnd - EM.m_ServerCalcTime) / 1000);

			if (planet.m_ShieldVal != 0) k = planet.m_ShieldVal;
			else k = 8 + (Math.floor(v / 3600) << 1);
			if (k < 0) k = 0;
			else if (k > 100) k = 100;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ShildPower+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:k.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.DeactivateShieldTime+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,								cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod(v), clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

/*		if(isvis && !(planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))) {
			if(!planet.m_Owner) str=Common.Txt.Neutral;
			else {
				//str=Common.Txt.Load;
				//user=UserList.Self.GetUser(planet.m_Owner);
				//if(user) str=user.m_Name;
				str=EM.Txt_CotlOwnerName(Server.Self.m_CotlId,planet.m_Owner);
			}

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Owner+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}*/

		// Radiation
		if(isvis && planet.m_Radiation!=0) {
			// space
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;

			if (planet.m_Flag & Planet.PlanetFlagLowRadiation) str = Common.Txt.RadiationLow;
			else str = Common.Txt.Radiation;
			ar.push({x:0, y:y, sx:3, sy:1, txt:str+": <font color='#ff0f0f'>"+BaseStr.FormatBigInt(planet.m_Radiation)+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

/*		if((planet.m_Flag & (Planet.PlanetFlagSun))) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ThreatSun+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Common.ThreatSun, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		if((planet.m_Flag & (Planet.PlanetFlagGigant)) && (planet.m_Flag & (Planet.PlanetFlagLarge))) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ThreatGigant+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Common.ThreatGigant, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		if((planet.m_Flag & (Planet.PlanetFlagGigant)) && !(planet.m_Flag & (Planet.PlanetFlagLarge))) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ThreatTini+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Common.ThreatTini, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}*/

		while ((planet.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
			if (EM.m_CotlType != Common.CotlTypeProtect && (planet.m_Flag & Planet.PlanetFlagStabilizer) && (planet.m_Flag & Planet.PlanetFlagNoCapture)) break;
			str=Common.Txt.PulsarTimeOff;
			if(planet.m_Flag & Planet.PlanetFlagStabilizer) str=Common.Txt.PulsarTimeOn; 
			ar.push({x:1, y:y, sx:1, sy:1, txt:str+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod((planet.m_NeutralCooldown-EM.m_ServerCalcTime)/1000), clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			break;
		}
		
/*		// Portal
		if (isvis && planet.m_PortalPlanet>0) {
			// space
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
			
			if (planet.m_Flag & Planet.PlanetFlagPortalFlagship) str = Common.Txt.PortalInfoFlagship;
			else if (planet.m_PortalCotlId != 0) str = Common.Txt.PortalInfoHyperspace;
			else str = Common.Txt.PortalInfo;
			
			var user_portal:User = UserList.Self.GetUser(planet.m_PortalOwner);
			if (user_portal != null) str = BaseStr.Replace(str, "<User>", user_portal.m_Name);

			ar.push({x:0, y:y, sx:3, sy:1, txt:BaseStr.FormatTag(str), clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// PortalCnt
		if(isvis && planet.m_PortalPlanet>0 && planet.m_PortalCnt>0) {
			str=BaseStr.FormatBigInt(planet.m_PortalCnt);
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.PortalCnt+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}*/

		// Space
		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Gravitor
		if (isvis && (planet.m_Flag & (Planet.PlanetFlagGravitor | Planet.PlanetFlagGravitorSci | Planet.PlanetFlagGravitorSciPrepare)) != 0) {
			if (planet.m_Flag & Planet.PlanetFlagGravitor) str = Common.Txt.ButGravitorFlagship;
			else if (planet.m_Flag & Planet.PlanetFlagGravitorSciPrepare) str = Common.Txt.GravitorPrepare;
			else str = Common.Txt.ButGravitorSci;

			if (planet.m_GravitorOwner != 0) {
				var user2:User = UserList.Self.GetUser(planet.m_GravitorOwner);
				if (user2 != null) str += " [clr](" + EmpireMap.Self.Txt_CotlOwnerName(0, user2.m_Id) + ")[/clr]";
			}

/*			if(planet.m_Flag & Planet.PlanetFlagGravitor) {
				var val:Number=0;
				for(i=0;i<Common.ShipOnPlanetMax;i++) {
					tgtship=planet.m_Ship[i];
					if(tgtship.m_Type!=Common.ShipTypeFlagship) continue;

					user=UserList.Self.GetUser(tgtship.m_Owner,false);
					if(user==null) continue;
					cpt=user.GetCpt(tgtship.m_Id);
					if (cpt == null) continue;

					if(!(cpt.m_Flag & Common.CptFlagGravitor)) continue;
					
					if (cpt.m_GravitorCooldown > EM.GetServerTime()) val = Math.max(val, cpt.m_GravitorCooldown - EM.GetServerTime());
					if (val > 0) str += ":  <font color='#ffff00'>" + Common.FormatPeriod(val / 1000) + "</font>"
					break;
				}
			} else*/
			if (planet.m_Flag & (Planet.PlanetFlagGravitorSciPrepare|Planet.PlanetFlagGravitor)) {
				str += ":  <font color='#ffff00'>" + Common.FormatPeriod((planet.m_GravitorTime-EM.m_ServerCalcTime) / 1000) + "</font>"
			}
			ar.push({x:0, y:y, sx:3, sy:1, txt:str+".", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		} else if (isvis && planet.m_GravitorTime > EM.m_ServerCalcTime) {
			str = Common.Txt.GravitorAccess;
			str += ":  <font color='#ffff00'>" + Common.FormatPeriod((planet.m_GravitorTime-EM.m_ServerCalcTime) / 1000) + "</font>"
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// GravitorSci
//		if(isvis && (planet.m_Flag & Planet.PlanetFlagGravitorSciPrepare)) {
//			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.GravitorPrepare+": <font color='#ffff00'>"+Common.FormatPeriod((planet.m_GravitorSciTime-EM.GetServerTime())/1000)+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
//		}
		
		if(EM.m_Debug) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:"Pos: <font color='#ffff00'>" + planet.m_Sector.m_SectorX.toString() +"," + planet.m_Sector.m_SectorY.toString() + "," + planet.m_PlanetNum.toString() + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;

			if(planet.m_Path!=0) {
				var tsecx:int = planet.m_Sector.m_SectorX;
				var tsecy:int = planet.m_Sector.m_SectorY;
				var tplanet:int = (planet.m_Path >> 4) & 7;
				if (planet.m_Path & 1) tsecx += 1; else if (planet.m_Path & 2) tsecx -= 1;
				if (planet.m_Path & 4) tsecy += 1; else if (planet.m_Path & 8) tsecy -= 1;
			
				ar.push( { x:0, y:y, sx:3, sy:1, txt:"Path: <font color='#ffff00'>" + tsecx.toString() + "," + tsecy.toString() + "," + tplanet + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
			}

			ar.push( { x:0, y:y, sx:3, sy:1, txt:"Flag: <font color='#ffff00'>" + (planet.m_Flag).toString(16) + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;

			if (planet.m_VisTime > EmpireMap.Self.m_ServerCalcTime) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:"VisTime: <font color='#ffff00'>" + Common.FormatPeriod((planet.m_VisTime-EmpireMap.Self.m_ServerCalcTime) / 1000) + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
			}
		}

		// GravWell
		if(isvis && (planet.m_Flag & Planet.PlanetFlagGravWell)) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.GravWellOff+": <font color='#ffff00'>"+Common.FormatPeriod((planet.m_GravWellCooldown-EM.m_ServerCalcTime)/1000)+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Potential
		if(isvis && (planet.m_Flag & Planet.PlanetFlagPotential)) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.PotentialOff+": <font color='#ffff00'>"+Common.FormatPeriod((planet.m_PotentialCooldown-EM.m_ServerCalcTime)/1000)+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		// Hint
		while(EM.m_Set_Hint && EM.m_CotlType!=Common.CotlTypeCombat) {
			str = null;
			if (!isvis) {}
			else if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0 && (planet.m_Flag & Planet.PlanetFlagLarge) != 0) str = CreateHint(Common.HintWormhole,Common.HintWormholeRoam);
			else if ((planet.m_Flag & Planet.PlanetFlagWormhole) != 0) str = CreateHint(Common.HintWormhole);
			else if ((planet.m_Flag & Planet.PlanetFlagSun) != 0 && (planet.m_Flag & Planet.PlanetFlagLarge) != 0) {
				if (planet.m_Flag & Planet.PlanetFlagNoCapture) break;
				str = CreateHint(Common.HintPulsar);
			}
			else if ((planet.m_Flag & Planet.PlanetFlagSun) != 0) str = CreateHint(Common.HintSun);
			else if ((planet.m_Flag & Planet.PlanetFlagGigant) && (planet.m_Flag & Planet.PlanetFlagLarge)!=0) str = CreateHint(Common.HintGigant);
			else if ((planet.m_Flag & Planet.PlanetFlagGigant) != 0) str = CreateHint(Common.HintTiny);
			else /*if (planet.m_Owner==Server.Self.m_UserId)*/ str = CreateHint(Common.HintPlanetNormal);
			if (str != null) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:/*"[justify]" +*/ Common.Txt.Hint + ": " + str /*+ "[/justify]"*/, clr:0x00ffa2, ax: -1, ay:0, fontsize:12,			cs_left:0, cs_right:0, cs_top: -3 + 5, cs_bottom: -3, auto_width:200 } );
				y++;
			}
			break;
		}

		BuildGrid(ar);

		var cx:int = EM.WorldToScreenX(planet.m_PosX, planet.m_PosY);
		var cy:int = EmpireMap.m_TWSPos.y;//EM.WorldToScreenY(planet.m_PosY);

		Prepare(cx-30,cy-30,cx+30,cy+30);
	}
	
	public function ShowPortal(secx:int,secy:int,planetnum:int):void
	{
		var planet:Planet=EM.GetPlanet(secx,secy,planetnum);
		if(planet==null) return;
		
		var str:String, str2:String;
		var user:User;
		var uni:Union;
		var ar:Array=new Array();
		var y:int = 0;

		var isvis:Boolean = planet.m_Vis;

		m_HintNew = !visible;
		Hide();

		if (!isvis) return;
		if (planet.m_PortalPlanet <= 0) return;

		// Portal
		if(true) {
			if (planet.m_Flag & Planet.PlanetFlagPortalFlagship) str = Common.Txt.PortalInfoFlagship;
			else if (planet.m_PortalCotlId != 0) str = Common.Txt.PortalInfoHyperspace;
			else str = Common.Txt.PortalInfo;
			
			if (planet.m_PortalCotlId != 0) {
				var cotl:SpaceCotl = EM.HS.GetCotl(planet.m_PortalCotlId);
				
				str2 = EmpireMap.Self.CotlName(planet.m_PortalCotlId);
				if (str2 != null && str2.length > 0) {
					str += " " + BaseStr.Replace((cotl != null && cotl.m_CotlType == Common.CotlTypeUser)?Common.Txt.PortalInfoHyperspaceCotlUser:Common.Txt.PortalInfoHyperspaceCotlOther, "<Name>", str2);
				}
			}

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,												cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+5 });
			y++;
		}
//			var user_portal:User = UserList.Self.GetUser(planet.m_PortalOwner);
//			if (user_portal != null) str = BaseStr.Replace(str, "<User>", user_portal.m_Name);

		// Owner
		if(planet.m_PortalOwner!=0) {
			str="";
			user = UserList.Self.GetUser(planet.m_Owner);
			if (user && (planet.m_Owner & Common.OwnerAI) == 0) str += Common.UserRankName[(user.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift] + " ";
			str += EM.Txt_CotlOwnerName(Server.Self.m_CotlId, planet.m_PortalOwner);
			
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Owner+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;
		} else {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Owner+": <font color='#ffff00'>"+Common.Txt.Neutral+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;
		}
		
		// Union
		while(planet.m_PortalOwner!=0) {
			user=UserList.Self.GetUser(planet.m_PortalOwner);
			if(user==null) break;
			if(user.m_UnionId==0) break;
			uni=UserList.Self.GetUnion(user.m_UnionId);
			if(uni==null) break;

			ar.push({x:0, y:y, sx:3, sy:1, txt:uni.NameUnion()+" "+uni.m_Name, clr:0x00b7ff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;

			break;
		}

		// PortalCnt
		if(planet.m_PortalCnt>0) {
			str=BaseStr.FormatBigInt(planet.m_PortalCnt);
			ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.PortalCnt + ": <font color='#ffff00'>" + str + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		BuildGrid(ar);

		var cx:int = EM.WorldToScreenX(planet.m_PosX - 90, planet.m_PosY - 90);
		var cy:int = EmpireMap.m_TWSPos.y;

		Prepare(cx-30,cy-30,cx+30,cy+30);
	}

	public function ShowItemEx(key:Object, itype:uint, icnt:int, iowner:uint, icomplate:int, ibroken:int, bx:int, by:int, sx:int, sy:int):void
	{
		var v:int, i:int, u:int, k:int, bt:int, lvl:int, cnt:int;
		var ship:Ship;
		var obj:Object, obj2:Object;
		var user:User;
		var uni:Union;
		var userm:User;
		
//		if(m_SectorX==secx && m_SectorY==secy && m_PlanetNum==planetnum && m_ShipNum==shipnum) return;
//trace(m_ItemKey,key);
		if (m_ItemKey == key) { return; }

		m_HintNew = !visible;
		Hide();
		m_ItemKey = key;

//		var ship:Ship=EM.GetShip(secx,secy,planetnum,shipnum);
//		if(ship==null) return;
		//if(ship.m_Type!=Common.ShipTypeNone) return;
//		if(ship.m_OrbitItemType==Common.ItemTypeNone) return;
		
//		var itemtype:int=ship.m_OrbitItemType;

//		m_SectorX=secx;
//		m_SectorY=secy;
//		m_PlanetNum=planetnum;
//		m_ShipNum=shipnum;

		var str:String,str2:String;
		var ar:Array=new Array();
		var y:int = 0;

		var pi:PlanetItem = null;
		if (key is PlanetItem) pi = key as PlanetItem;

		var idesc:Item = UserList.Self.GetItem(itype & 0xffff);
		if (idesc == null) return;

		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:EM.ItemName(itype), clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:EM.Txt_ItemDesc(itype & 0xffff), clr:0xD0D0D0, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 + 6, auto_width:200 } );
			y++;
		}

		// Owner
		var towner:uint = iowner;
		if (pi != null) towner = pi.m_Owner;
		if (towner != 0) {
			user = UserList.Self.GetUser(towner);
			str = "";
			if (user && (towner & Common.OwnerAI) == 0) str += Common.UserRankName[(user.m_Flag & Common.UserFlagRankMask) >> Common.UserFlagRankShift] + " ";
			str += EM.Txt_CotlOwnerName(Server.Self.m_CotlId, towner);

			ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.Owner+": <font color='#ffff00'>" + str + "</font>", clr:0xD0D0D0, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -2, cs_bottom: -2 } );
			y++;
		}
		
		// Union
		while(towner!=0) {
			user=UserList.Self.GetUser(towner);
			if(user==null) break;
			if(user.m_UnionId==0) break;
			uni=UserList.Self.GetUnion(user.m_UnionId);
			if(uni==null) break;
		
			ar.push( { x:0, y:y, sx:3, sy:1, txt:uni.NameUnion() + " " + uni.m_Name, clr:0x00b7ff, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -2, cs_bottom: -2 } );
			y++;

			break;
		}

		if(1) { // Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}
		

		if (1) {
			str = BaseStr.FormatBigInt(icnt);
			if (itype == Common.ItemTypeMoney) str += " cr";
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Count+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		for (i = 0; i < 4; i++) {
			if (idesc.m_BonusType[i] == 0) continue;
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ItemBonusName[idesc.m_BonusType[i]]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:"+" + Math.round(idesc.m_BonusVal[i] * 100.0 / 256.0).toString() + "%", clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}
		for (i = 0; i < 4; i++) {
			u = (itype >> (16 + i * 4)) & 15;
			if (u == 0) continue;
			if (idesc.m_BonusType[u] == 0) continue;
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ItemBonusName[idesc.m_BonusType[u]]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:"+" + Math.round(idesc.m_BonusVal[u] * 100.0 / 256.0).toString() + "%", clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		if(itype==Common.ItemTypePower || itype==Common.ItemTypePower2) {
			v=Common.BonusPower;
			if(itype==Common.ItemTypePower2) v=Common.BonusPower2;
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BonusPower+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:"+"+Math.round(v/256*100).toString()+"%", clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

		} else if(itype==Common.ItemTypeArmour || itype==Common.ItemTypeArmour2 || itype==Common.ItemTypeMonuk) {
			v=Common.BonusArmour;
			if(itype==Common.ItemTypeArmour2) v=Common.BonusArmour2;
			if(itype==Common.ItemTypeMonuk) v=Common.BonusMonuk;
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BonusArmour+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:"+"+Math.round(v/256*100).toString()+"%", clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

		} else if(itype==Common.ItemTypeRepair || itype==Common.ItemTypeRepair2) {
			v=Common.BonusRepair;
			if(itype==Common.ItemTypeRepair2) v=Common.BonusRepair2;
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BonusRepair+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:"+"+v.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if (itype == Common.ItemTypeMine) {
			v = Common.MinePower;
			if (iowner!=0) {
				user = UserList.Self.GetUser(iowner);
				if (user != null && user.m_UnionId != 0) {
					var union:Union = UserList.Self.GetUnion(user.m_UnionId);
					if (union != null) v += Common.CotlBonusValEx(Common.CotlBonusMinePower,union.m_Bonus[Common.CotlBonusMinePower]);
				}
			}
			//if (v > Common.MaxMinePower) v = Common.MaxMinePower;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.MinePower+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:v.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

//		if(iowner!=0) {
//			str=EM.Txt_CotlOwnerName(Server.Self.m_CotlId,iowner);
//			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.Owner+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
//		}
		
		// NewOwnerId
		if ((key is Object) && (key.hasOwnProperty("NewOwnerId")) && (key.NewOwnerId != 0)) {
			str=EM.Txt_CotlOwnerName(Server.Self.m_CotlId,key.NewOwnerId);

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormCombatNewOwner+":",  clr:0xffffff, ax:-1, ay:1, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3+5, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:1, fontsize:14,					cs_left:20, cs_right:0, cs_top:-3+5, cs_bottom:-3 });
			y++;
		}

		// BuildInfo
		while (pi != null) {
			var planet:Planet = EM.GetPlanet(EM.m_FormPlanet.m_SectorX, EM.m_FormPlanet.m_SectorY, EM.m_FormPlanet.m_PlanetNum);
			if (planet == null) break;
			
			var ownerid:uint = 0;
			if(planet.m_Owner==0) {
				for(u=0;u<Common.ShipOnPlanetMax;u++) {
					ship = planet.m_Ship[u];
					if(ship.m_Type!=Common.ShipTypeServiceBase) continue;
					if((ship.m_Flag & Common.ShipFlagBuild)!=0) continue;
					if(ship.m_Owner==0) continue;
					ownerid = ship.m_Owner;
					break;
				}
			} else ownerid=planet.m_Owner;
			if(ownerid==0) break;
			
//			var bf:Boolean = false;
//			for (i = 0; i < planet.m_Item.length; i++) {
//				if (planet.m_Item[i].m_Type != pi.m_Type) continue;
//				if (!(planet.m_Item[i].m_Flag & PlanetItem.PlanetItemFlagBuild)) bf = true;
//			}

			while (pi.m_Type == Common.ItemTypeModule) {
				if ((planet.m_Flag & Planet.PlanetFlagHomeworld) != 0) { }
				else if ((planet.m_Flag & Planet.PlanetFlagCitadel) != 0 && EM.IsWinMaxEnclave()) { }
				else break;
				
				cnt = Common.HomeworldModuleInc;

				if(EM.m_CotlType==Common.CotlTypeUser) {
					if((EM.m_CotlZoneLvl & 3)==3) {}
					else if((EM.m_CotlZoneLvl & 3)==2) cnt+=cnt>>1;
					else if((EM.m_CotlZoneLvl & 3)==1) cnt+=cnt;
					else  cnt+=cnt+(cnt>>1);
				} else if (EM.m_CotlType == Common.CotlTypeRich) {
					cnt = Common.BaseModuleInc;
					cnt *= EM.m_OpsModuleMul;
				}

				str = BaseStr.FormatBigInt(cnt);

				if (Common.ItemIsFinalLoop(pi.m_Type)) {
					if ((EM.m_Access & Common.AccessPlusarModule) && (ownerid == Server.Self.m_UserId && EM.PlusarManuf())) {
						str = str + "+" + BaseStr.FormatBigInt(cnt >> 1);
					}
				}

				if (EM.m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && EM.m_UserMulTime > 0) str = "(" + str + ")x" + Common.MulFactor.toString();

				if (1) { // Space
					ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
					y++;
				}
				
				str2 = Common.Txt.FormPlanetItemBuildIncBaseModule;
				if ((planet.m_Flag & Planet.PlanetFlagHomeworld) != 0) str2 = Common.Txt.FormPlanetItemBuildIncHomeworldModule;

				ar.push( { x:1, y:y, sx:1, sy:1, txt:str2 + ":",  clr:0xffffff, ax: -1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
					ar.push( { x:2, y:y, sx:1, sy:1, txt:"+" + str, clr:0x00ff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
				
				break;
			}

			if (1) { // Space
				ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
				y++;
			}

			if(icomplate>0) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ItemComplete+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(icomplate), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			// Производство
			cnt = 0;
			var range:int = 1;

			if (pi.m_Type == Common.ItemTypeHydrogen) {
				if ((planet.m_Flag & (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) == (Planet.PlanetFlagGigant | Planet.PlanetFlagLarge)) {
					for (i = 0; i < Common.ShipOnPlanetMax; i++) {
						ship = planet.m_Ship[i];
						if (ship.m_Type != Common.ShipTypeServiceBase) continue;
						if ((ship.m_Flag & Common.ShipFlagBuild) != 0) continue;
						cnt+=ship.m_Cnt;
					}
					if (cnt < 0) cnt = 0;
					else if (cnt > 4) cnt = 4;

					cnt = cnt * 13;
					range = 1;
				}

			} else if((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))==0) {
				for (i = 0; i < Common.BuildingItem.length; i++) {
					obj = Common.BuildingItem[i];
					if (obj.Build==0) continue;
					if (obj.ItemType != (pi.m_Type & 0xffff)) continue;

					for (u = 0; u < Planet.PlanetCellCnt; u++) {
						bt = planet.m_Cell[u] >> 3;
						lvl = planet.m_Cell[u] & 7;
						if (bt != obj.BuildingType) continue;
						if (planet.m_CellBuildFlag & (1 << u)) lvl--;
						if (lvl <= 0) continue;

						cnt += obj.Cnt[lvl];
						range = Math.max(range, obj.Build);
					}
				}
			}

			while (true) {
				if (cnt > 0) { }
				else if (pi.m_Type == Common.ItemTypeMoney && planet.ConstructionLvl(Common.BuildingTypeCity) > 0) { }
				else break;

				u = EM.CalcItemDifficult(planet,pi.m_Type);
				if (u <= 1) break;
				ar.push( { x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetItemDifficult + ":",  clr:0xffffff, ax: -1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
					ar.push( { x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(u), clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
				break;
			}
			
			// CityNalog
			if (pi.m_Type == Common.ItemTypeMoney && planet.ConstructionLvl(Common.BuildingTypeCity) > 0) {
				u = Common.BuildingCityNalog * planet.ConstructionLvl(Common.BuildingTypeCity);
				str = BaseStr.FormatBigInt(u);
				if ((EM.m_Access & Common.AccessPlusarModule) && (ownerid == Server.Self.m_UserId && EM.PlusarManuf())) {
					str = str + "+" + BaseStr.FormatBigInt(u >> 1);
				}
				if (EM.m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && EM.m_UserMulTime > 0) str = "(" + str + ")x" + Common.MulFactor.toString();

				ar.push( { x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetCityNalog2 + ":",  clr:0xffffff, ax: -1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
					ar.push( { x:2, y:y, sx:1, sy:1, txt:"+" + str, clr:0x00ff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
			}
			
			
			if (cnt > 0) {
				//ar.push( { x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetItemBuildBase + ":",  clr:0xffffff, ax: -1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top: -3 + 10, cs_bottom: -3 } );
				//y++;

				if (EM.IsWinMaxEnclave()) {
					if (Common.ItemIsFinalLoop(pi.m_Type)) cnt *= EM.m_OpsModuleMul;
				} else {
					if(pi.m_Type==Common.ItemTypeModule && EM.m_CotlType==Common.CotlTypeUser) {
						if((EM.m_CotlZoneLvl & 3)==3) {}
						else if((EM.m_CotlZoneLvl & 3)==2) cnt+=cnt>>1;
						else if((EM.m_CotlZoneLvl & 3)==1) cnt+=cnt;
						else  cnt+=cnt+(cnt>>1);
					}
					
					if ((EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && Common.ItemIsFinalLoop(pi.m_Type)) cnt *= EM.m_OpsModuleMul;
				}

				if ((planet.m_Flag & Planet.PlanetFlagRich) != 0) cnt *= 3;

				str = BaseStr.FormatBigInt(cnt);

				if (Common.ItemIsFinalLoop(pi.m_Type)) {
					if ((EM.m_Access & Common.AccessPlusarModule) && (ownerid == Server.Self.m_UserId && EM.PlusarManuf())) {
						str = str + "+" + BaseStr.FormatBigInt(cnt >> 1);
					}
				}

				if (EM.m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && EM.m_UserMulTime > 0) str = "(" + str + ")x" + Common.MulFactor.toString();
				if (ownerid & Common.OwnerAI) {
					userm = UserList.Self.GetUser(ownerid);
					if(userm!=null && userm.m_ManufMul>1) str = "(" + str + ")x" + userm.m_ManufMul.toString();
				}

//				if (range != 1) str = str + "/" + range.toString();

				ar.push( { x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetItemBuildInc + ":",  clr:0xffffff, ax: -1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
					ar.push( { x:2, y:y, sx:1, sy:1, txt:"+" + str, clr:0x00ff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
			}
			
			if ((cnt > 0) && !EM.IsWinMaxEnclave()) {
				cnt = planet.PlanetDefectFactor();
				if (cnt > 0) {
					ar.push( { x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetItemBuildDefectFactor + ":",  clr:0xffffff, ax: -1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
						ar.push( { x:2, y:y, sx:1, sy:1, txt:cnt.toString()+"%", clr:0xff4040, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
					y++;
				}
			}

			// Потребление
			cnt = 0;

			if ((planet.m_Flag & (Planet.PlanetFlagWormhole | Planet.PlanetFlagSun | Planet.PlanetFlagGigant))==0) {
				for (i = 0; i < Common.BuildingItem.length; i++) {
					obj = Common.BuildingItem[i];
					if (obj.Build == 0) continue;

					for (k = 0; k < Planet.PlanetItemCnt; k++) {
						if ((planet.m_Item[k].m_Type & 0xffff) != obj.ItemType) continue;
						if ((planet.m_Item[k].m_Flag & PlanetItem.PlanetItemFlagBuild) == 0) continue;
						break;
					}
					if (k >= Planet.PlanetItemCnt) continue;

					for (k = i + 1; k < Common.BuildingItem.length; k++) {
						obj2=Common.BuildingItem[k];
						if (obj.BuildingType != obj2.BuildingType) break;
						if (obj2.Build != 0) break;

						if (obj2.ItemType != pi.m_Type) continue;

						for (u = 0; u < Planet.PlanetCellCnt; u++) {
							bt = planet.m_Cell[u] >> 3;
							lvl = planet.m_Cell[u] & 7;
							if (bt != obj2.BuildingType) continue;
							if (planet.m_CellBuildFlag & (1 << u)) lvl--;
							if (lvl <= 0) continue;

							cnt += obj2.Cnt[lvl];
						}
					}
				}
			}

			if (cnt > 0) {
				str = BaseStr.FormatBigInt(cnt);
				if (EM.m_CotlType == Common.CotlTypeUser && ownerid == Server.Self.m_UserId && EM.m_UserMulTime > 0) str = "" + str + "x" + Common.MulFactor.toString();
				if (ownerid & Common.OwnerAI) {
					userm = UserList.Self.GetUser(ownerid);
					if(userm!=null && userm.m_ManufMul>1) str = "(" + str + ")x" + userm.m_ManufMul.toString();
				}

				ar.push( { x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetItemBuildDec + ":",  clr:0xffffff, ax: -1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
					ar.push( { x:2, y:y, sx:1, sy:1, txt:"-" + str, clr:0xffff00, ax: 1, ay:0, fontsize:14,					cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
			}

			for (i = 0; i < Planet.PlanetItemCnt; i++) {
				if (planet.m_Item[i] == pi) break;
			}
			if ((i < Planet.PlanetItemCnt) && (i >= planet.PlanetItemMax())/* && (pi.m_Flag & PlanetItem.PlanetItemFlagBuild) != 0*/) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:"[crt]"+Common.Txt.WarningOutWarehouse+"[/crt]", clr:0xffffff, ax: -1, ay:1, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3+5, cs_bottom: -3 } );
				y++;
			}

			break;
		}

		BuildGrid(ar);

//		var planet:Planet=EM.GetPlanet(secx,secy,planetnum);
//		if(planet==null) return;
//		var ra:Array=EM.CalcShipPlace(planet,shipnum);
//		var gsx:int=EM.WorldToScreenX(ra[0]);
//		var gsy:int=EM.WorldToScreenY(ra[1]);

		Prepare(bx,by,bx+sx,by+sy);
	}

	public function ShowBuilding(key:Object, btype:uint, blvl:int, build_time:Number, bx:int, by:int, sx:int, sy:int, fromconstructionform:Boolean=false):void
	{
		var v:int,i:int,u:int,cnt:int;
		var str:String;
		var obj:Object, obj2:Object;
		var bh:Boolean;
		var clrv:uint;

		if (m_ItemKey == key) { return; }

		m_HintNew = !visible;
		Hide();
		m_ItemKey = key;

		var ar:Array=new Array();
		var y:int = 0;

		if(1) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.BuildingName[btype] + " " + Common.RomanNum[blvl] , clr:0xffff00, ax: -1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		if(1) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.BuildingDesc[btype], clr:0xD0D0D0, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 + 6, auto_width:200 } );
			y++;
		}

		if(1) {
			v = Common.BuildingEnergy[btype * Common.BuildingLvlCnt + blvl - 1];
			str = v.toString();
			if (v >= 0) { str = "+" + str; clrv = 0x00ff00; }
			else clrv = 0xffff00;
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetEnergy+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:clrv, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if(1) {
			// space
			ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}
		
		if (btype == Common.BuildingTypeStorage) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetStorageSize+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:"+"+blvl.toString(), clr:0x00ff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if (btype == Common.BuildingTypeCity) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FormPlanetCityNalog+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:"+" + BaseStr.FormatBigInt(Common.BuildingCityNalog * blvl) + " / " + BaseStr.FormatBigInt(EM.CalcItemDifficult(null,Common.ItemTypeMoney)) + " cr", clr:0x00ff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		/// производство
		bh = false;
		for (i = 0; i < Common.BuildingItem.length; i++) {
			obj = Common.BuildingItem[i];
			if (obj.BuildingType != btype) continue;
			if (obj.Build == 0) continue;

			cnt = obj.Cnt[blvl];
			if (!fromconstructionform && (EM.m_CotlType == Common.CotlTypeProtect || EM.m_CotlType == Common.CotlTypeCombat) && Common.ItemIsFinalLoop(obj.ItemType)) cnt *= EM.m_OpsModuleMul;
			str = EM.ItemName(obj.ItemType) + " [clr]" + BaseStr.FormatBigInt(cnt) + "[/clr]";
			u = 0;
			if (obj.Build > 1)  u = obj.Build;
			else if (obj.Build < 0) u = EM.CalcItemDifficult(null,obj.ItemType);
			if (u > 1) str += " / [clr]" + BaseStr.FormatBigInt(u) + "[/clr]";

			for (u = i + 1; u < Common.BuildingItem.length; u++) {
				obj2 = Common.BuildingItem[u];
				if (obj2.BuildingType != btype) break;
				if (obj2.Build != 0) break;
				
				if (u == i + 1) str += " = ";
				else str += " + ";
				str += EM.ItemName(obj2.ItemType)+" [clr]"+BaseStr.FormatBigInt(obj2.Cnt[blvl])+"[/clr]";
			}

			if (!bh) {
				bh = true;
				ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.FormPlanetItemBuildChain+":",  clr:0xffffff, ax: -1, ay:1, fontsize:14,						cs_left:0, cs_right:0, cs_top: -3 + 7, cs_bottom: -3 } );
				y++;
			}

			ar.push( { x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax: -1, ay:1, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3, auto_width:350 } );
			y++;
		}
		
		if(fromconstructionform) {
			if (btype == Common.BuildingTypeCity || btype == Common.BuildingTypeFarm || btype == Common.BuildingTypeTech || btype == Common.BuildingTypeEngineer || btype == Common.BuildingTypeTechnician || btype == Common.BuildingTypeNavigator) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.FormPlanetBuildingNeedLargePlanet, clr:0xffff00, ax: -1, ay:1, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3 + 10, cs_bottom: -3, auto_width:200 } );
				y++;

			} else if (btype == Common.BuildingTypeModule || btype == Common.BuildingTypeFuel || btype == Common.BuildingTypePower || btype == Common.BuildingTypeArmour || btype == Common.BuildingTypeDroid || btype == Common.BuildingTypeMachinery || btype == Common.BuildingTypeMine) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.FormPlanetBuildingNeedLargePlanet, clr:0xffff00, ax: -1, ay:1, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3 + 10, cs_bottom: -3, auto_width:200 } );
				y++;
				
			} else if (btype == Common.BuildingTypeElectronics || btype == Common.BuildingTypeMetal || btype == Common.BuildingTypeAntimatter || btype == Common.BuildingTypePlasma) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.FormPlanetBuildingNeedSmallPlanet, clr:0xffff00, ax: -1, ay:1, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3 + 10, cs_bottom: -3, auto_width:200 } );
				y++;
			}
		}

		BuildGrid(ar);
		Prepare(bx,by,bx+sx,by+sy);
	}

	public function ShowPlanetOre(key:Object, itype:int, bx:int, by:int, sx:int, sy:int):void
	{
		var v:int;
		var str:String;

		if (m_ItemKey == key) { return; }

		m_HintNew = !visible;
		Hide();
		m_ItemKey = key;

		var ar:Array=new Array();
		var y:int = 0;

		if (1) {
			if (itype == Common.ItemTypeCrystal) str = Common.Txt.FormPlanetOreCrystalName;
			else if (itype == Common.ItemTypeTitan) str = Common.Txt.FormPlanetOreTitanName;
			else if (itype == Common.ItemTypeSilicon) str = Common.Txt.FormPlanetOreSiliconName;
			else return;

			ar.push( { x:0, y:y, sx:3, sy:1, txt:str , clr:0xffff00, ax: -1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		if(1) {
			if (itype == Common.ItemTypeCrystal) str = Common.Txt.FormPlanetOreCrystalDesc;
			else if (itype == Common.ItemTypeTitan) str = Common.Txt.FormPlanetOreTitanDesc;
			else if (itype == Common.ItemTypeSilicon) str = Common.Txt.FormPlanetOreSiliconDesc;
			else return;

			ar.push( { x:0, y:y, sx:3, sy:1, txt:str, clr:0xD0D0D0, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 + 6, auto_width:200 } );
			y++;
		}

		BuildGrid(ar);
		Prepare(bx,by,bx+sx,by+sy);
	}

/*	public function ShowRes(itemtype:int, sx:int, sy:int):void
	{
		m_HintNew = !visible;
		Hide();

		var v:int;
		var i:int, k:int;
		var kof:int;
		var str:String;
		var ar:Array=new Array();
		var y:int=0;

		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ItemName[itemtype], clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.ItemDesc[itemtype], clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6 });
			y++;
		}

		if(itemtype==Common.ItemTypePower || itemtype==Common.ItemTypePower2) {
			v=Common.BonusPower;
			if(itemtype==Common.ItemTypePower2) v=Common.BonusPower2;
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BonusPower+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:"+"+Math.round(v/256*100).toString()+"%", clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

		} else if(itemtype==Common.ItemTypeArmour || itemtype==Common.ItemTypeArmour2 || itemtype==Common.ItemTypeMonuk) {
			v=Common.BonusArmour;
			if(itemtype==Common.ItemTypeArmour2) v=Common.BonusArmour2;
			if(itemtype==Common.ItemTypeMonuk) v=Common.BonusMonuk;
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BonusArmour+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:"+"+Math.round(v/256*100).toString()+"%", clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

		} else if(itemtype==Common.ItemTypeRepair || itemtype==Common.ItemTypeRepair2) {
			v=Common.BonusRepair;
			if(itemtype==Common.ItemTypeRepair2) v=Common.BonusRepair2;
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.BonusRepair+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:"+"+v.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatResCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:EM.m_UserRes[itemtype], clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		k=0;
		if(itemtype==Common.ItemTypeAntimatter) {
			str=EM.m_UserStatAntimatterInc.toString();

			k=(EM.m_UserStatAntimatterInc*EM.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8;
			if((EM.m_Access & Common.AccessPlusarModule) && ((EM.m_UserAddModuleEnd>EM.GetServerTime()) || (EM.m_UserControlEnd>EM.GetServerTime()))) k+=((EM.m_UserStatAntimatterInc*Common.PlusarResBonus)>>8); 
			if(k>0) str+="<font color='#00ff00'>+"+k.toString()+"<font>";
			
			if(EM.m_UserStatAntimatterIncPact>0) str+="<font color='#ffff00'>+"+EM.m_UserStatAntimatterIncPact.toString()+"<font>";
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatResInc+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		var suplow:int=EM.DirValE(Server.Self.m_UserId,Common.DirSupplyNormal);
		var supnormal:int=suplow<<1;
		var supmuch:int=EM.DirValE(Server.Self.m_UserId,Common.DirSupplyMuch);

		if(itemtype==Common.ItemTypeAntimatter && EM.m_FormRes.m_UserStatShipCntAll>=suplow) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatResDec+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:EM.m_FormRes.m_UserStatAntimatterDecAll, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			for(i=0;i<Common.ShipTypeCnt;i++) {
				if(EM.m_UserStatShipCnt[i]<=0) continue;

				kof=(((1+(EM.m_UserStatShipCnt[i]>>Common.ShipSupplyS[i]))*EM.SupplyMul(Server.Self.m_UserId,i))>>8)*EM.m_SupplyMul;
				v=Common.ShipSupplyA[i]*kof;
				if(EM.m_FormRes.m_UserStatShipCntAll<supnormal) v=v>>1;
				else if(EM.m_FormRes.m_UserStatShipCntAll>supmuch) v=v<<1;

				ar.push({x:1, y:y, sx:1, sy:1, txt:"      "+Common.ShipNameForCnt[i]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:v.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			k=((EM.m_UserStatAntimatterInc+k)*EM.PactDecProc(Common.ItemTypeAntimatter))>>8;
			if(k>0) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:"      "+Common.Txt.SupplyByPact+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:k.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		k=0;
		if(itemtype==Common.ItemTypeMetal) {
			str=EM.m_UserStatMetalInc.toString();

			k=(EM.m_UserStatMetalInc*EM.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8;
			if((EM.m_Access & Common.AccessPlusarModule) && ((EM.m_UserAddModuleEnd>EM.GetServerTime()) || (EM.m_UserControlEnd>EM.GetServerTime()))) k+=((EM.m_UserStatMetalInc*Common.PlusarResBonus)>>8);
			if(k>0) str+="<font color='#00ff00'>+"+k.toString()+"<font>";
			
			if(EM.m_UserStatMetalIncPact>0) str+="<font color='#ffff00'>+"+EM.m_UserStatMetalIncPact.toString()+"<font>";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatResInc+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(itemtype==Common.ItemTypeMetal && EM.m_FormRes.m_UserStatShipCntAll>=suplow) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatResDec+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:EM.m_FormRes.m_UserStatMetalDecAll, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			for(i=0;i<Common.ShipTypeCnt;i++) {
				if(EM.m_UserStatShipCnt[i]<=0) continue;

				kof=(((1+(EM.m_UserStatShipCnt[i]>>Common.ShipSupplyS[i]))*EM.SupplyMul(Server.Self.m_UserId,i))>>8)*EM.m_SupplyMul;
				v=Common.ShipSupplyM[i]*kof;
//trace("ship:",i,"cnt:",EM.m_UserStatShipCnt[i],"v:",v,"SM:",EM.SupplyMul(Server.Self.m_UserId,i));
				if(EM.m_FormRes.m_UserStatShipCntAll<supnormal) v=v>>1;
				else if(EM.m_FormRes.
				All>supmuch) v=v<<1;

				ar.push({x:1, y:y, sx:1, sy:1, txt:"      "+Common.ShipNameForCnt[i]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:v.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			k=((EM.m_UserStatMetalInc+k)*EM.PactDecProc(Common.ItemTypeMetal))>>8;
			if(k>0) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:"      "+Common.Txt.SupplyByPact+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:k.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		k=0;
		if(itemtype==Common.ItemTypeElectronics) {
			str=EM.m_UserStatElectronicsInc.toString();

			k=(EM.m_UserStatElectronicsInc*EM.DirValE(Server.Self.m_UserId,Common.DirResSpeed,true))>>8;
			if((EM.m_Access & Common.AccessPlusarModule) && ((EM.m_UserAddModuleEnd>EM.GetServerTime()) || (EM.m_UserControlEnd>EM.GetServerTime()))) k+=((EM.m_UserStatElectronicsInc*Common.PlusarResBonus)>>8);
			if(k>0) str+="<font color='#00ff00'>+"+k.toString()+"<font>";

			if(EM.m_UserStatElectronicsIncPact>0) str+="<font color='#ffff00'>+"+EM.m_UserStatElectronicsIncPact.toString()+"<font>";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatResInc+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(itemtype==Common.ItemTypeElectronics && EM.m_FormRes.m_UserStatShipCntAll>=suplow) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatResDec+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:EM.m_FormRes.m_UserStatElectronicsDecAll, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			for(i=0;i<Common.ShipTypeCnt;i++) {
				if(EM.m_UserStatShipCnt[i]<=0) continue;

				kof=(((1+(EM.m_UserStatShipCnt[i]>>Common.ShipSupplyS[i]))*EM.SupplyMul(Server.Self.m_UserId,i))>>8)*EM.m_SupplyMul;
				v=Common.ShipSupplyE[i]*kof;
				if(EM.m_FormRes.m_UserStatShipCntAll<supnormal) v=v>>1;
				else if(EM.m_FormRes.m_UserStatShipCntAll>supmuch) v=v<<1;

				ar.push({x:1, y:y, sx:1, sy:1, txt:"      "+Common.ShipNameForCnt[i]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:v.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			k=((EM.m_UserStatElectronicsInc+k)*EM.PactDecProc(Common.ItemTypeElectronics))>>8;
			if(k>0) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:"      "+Common.Txt.SupplyByPact+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:k.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		BuildGrid(ar);


		Prepare(sx-60,sy-60,sx+60,sy+60);
	}*/

	public function ShowScore():void
	{
		m_HintNew = !visible;
		Hide();

		var i:int,v:int;
		var t:Number;
		var str:String;
		var ar:Array=new Array();
		var y:int=0;

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId,false);
		if(user==null) return;

		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Stat, clr:0xffff00, ax:-1, ay:0, fontsize:16,												cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+5 });
			y++;
		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserRating+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(user.m_Rating), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.CombatRating+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(user.m_CombatRating), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserScore+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(user.m_Score), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

//		if(1) {
//			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserRest+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//				ar.push({x:2, y:y, sx:1, sy:1, txt:user.m_Rest, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
//		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserExp+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(user.m_Exp), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserKlingDestroyCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:EM.m_UserKlingDestroyCnt, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserPlanetCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:EM.m_UserPlanetCnt, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			v = EM.PlanetEmpireMax(Server.Self.m_UserId);
			if(EM.m_UserEmpirePlanetCnt>v) str="<font color='#ff0000'>"+EM.m_UserEmpirePlanetCnt.toString()+"</font>";
			else str=EM.m_UserEmpirePlanetCnt.toString();
			str+="/"+v.toString();

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.EmpirePlanetCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			v = EM.PlanetEnclaveMax(Server.Self.m_UserId);
			if(EM.m_UserEnclavePlanetCnt>v) str="<font color='#ff0000'>"+EM.m_UserEnclavePlanetCnt.toString()+"</font>";
			else str=EM.m_UserEnclavePlanetCnt.toString();
			str+="/"+v.toString();

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.EnclavePlanetCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			v = EM.PlanetColonyMax(Server.Self.m_UserId);
			if(EM.m_UserColonyPlanetCnt>v) str="<font color='#ff0000'>"+EM.m_UserColonyPlanetCnt.toString()+"</font>";
			else str=EM.m_UserColonyPlanetCnt.toString();
			str+="/"+v.toString();

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ColonyPlanetCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if ((EM.m_Access & Common.AccessPlusarShieldGlobal) && (EM.m_UserPlanetShieldCooldown > EM.GetServerGlobalTime())) {
			ar.push( { x:1, y:y, sx:1, sy:1, txt:Common.Txt.GloablShieldCooldown + ":",  clr:0xffffff, ax: -1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				ar.push( { x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod((EM.m_UserPlanetShieldCooldown - EM.GetServerGlobalTime()) / 1000), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
			
		}

		if(1) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

/*		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserShipCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:EM.m_UserStatShipCnt, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}*/

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.GravitorSciCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:EM.m_UserGravitorSciCnt.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}
		
		if (1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatMineCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:EM.m_UserStatMineCnt.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		var shipcnt:int=0;
		for(i=0;i<Common.ShipTypeCnt;i++) {
			if(EM.m_UserStatShipCnt[i]<=0) continue;
			shipcnt+=EM.m_UserStatShipCnt[i];
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[i]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(EM.m_UserStatShipCnt[i]), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserShipCnt+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(shipcnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if(1) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,											cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		// Def mass
		if (1) {
			v = EM.CalcMaxMassAllShip(Server.Self.m_UserId, false);
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserShipMassDefMax+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(v), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		if (1) {
			v = EM.CalcMassAllShip(false);
			if (v > EM.CalcMaxMassAllShip(Server.Self.m_UserId, false)) str = "<font color='#ff0000'>" + BaseStr.FormatBigInt(v) + "</font>";
			else str = BaseStr.FormatBigInt(v);

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserShipMassDef+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		// Atk mass
		if (1) {
			v = EM.CalcMaxMassAllShip(Server.Self.m_UserId, true);
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserShipMassAtkMax+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(v), clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		if (1) {
			v = EM.CalcMassAllShip(true);
			if (v > EM.CalcMaxMassAllShip(Server.Self.m_UserId, true)) str = "<font color='#ff0000'>" + BaseStr.FormatBigInt(v) + "</font>";
			else str = BaseStr.FormatBigInt(v);

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserShipMassAtk+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

/*		if(1) {
			str=Common.Txt.ResSupplyNone;
			if(EM.m_FormRes.m_UserStatShipCntAll>=EM.DirValE(Server.Self.m_UserId,Common.DirSupplyNormal)) {
				if(EM.m_FormRes.m_UserStatShipCntAll<(EM.DirValE(Server.Self.m_UserId,Common.DirSupplyNormal)<<1)) str=Common.Txt.ResSupplyLow; 
				else if(EM.m_FormRes.m_UserStatShipCntAll>EM.DirValE(Server.Self.m_UserId,Common.DirSupplyMuch)) str=Common.Txt.ResSupplyH;
				else str=Common.Txt.ResSupplyNormal;
			}
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.StatResDec+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,											cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}*/
		
		if(1) { // space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,											cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.SDMMax+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(EM.m_UserSDMMax)+" sdm", clr:0xffff00, ax: 1, ay:0, fontsize:14,				cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.SDM+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(EM.m_UserSDM)+" sdm", clr:0xffff00, ax: 1, ay:0, fontsize:14,				cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(EM.m_EmpireLifeTime!=0 && EM.m_UserPlanetCnt>0) {
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.EmpireDestroyTime+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod((EM.m_UserEmpireCreateTime + EM.m_EmpireLifeTime * 1000 - EM.GetServerGlobalTime()) / 1000).toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,				cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		if(EM.m_UserMulTime>0) {
			// space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,											cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.MulTime+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod(EM.m_UserMulTime), clr:0xffff00, ax: 1, ay:0, fontsize:14,				cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		while(EM.m_SessionPeriod>0) {
			var ra:Array=EM.GameStateLeftTime();

			if(ra[0]==0) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.SessionEnd+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod(ra[1]).toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,				cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;

				break;
			} else {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.SessionBegin+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:Common.FormatPeriod(ra[1]).toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,				cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;

				break;
			}

			break;
		}

/*		if(EM.m_CotlType==Common.CotlTypeUser) {
			if(1) { // space
				ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
				y++;
			}

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.CotlOccupancy+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:EM.m_FormMiniMap.m_Occupancy.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,				cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}*/

		if (1) { // GalaxyAward
			str = Common.Txt.GalaxyAward;
			//str = BaseStr.Replace(str, "<Val>", BaseStr.FormatBigInt(EM.m_GalaxyAward));
			str = BaseStr.Replace(str, "<Val>", EM.m_GalaxyAward.toString());

			ar.push( { x:0, y:y, sx:3, sy:1, txt:"[p]"+str+"[/p]", clr:0x00ffa2, ax: -1, ay:0, fontsize:12,							cs_left:0, cs_right:0, cs_top: -3 + 10, cs_bottom: -3 + 5, auto_width:150 } );
			y++;
		}

//		if(1) { // space
//			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,							cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
//			y++;
//		}
		
		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.StatUpdateTime, clr:0xA0A0A0, ax:-1, ay:0, fontsize:12,		cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+5, auto_width:150 });
			y++;
		}

		BuildGrid(ar);
		
		var tp:Point=EM.m_FormInfoBar.localToGlobal(new Point(EM.m_FormInfoBar.m_TxtScore.x,EM.m_FormInfoBar.m_TxtScore.y));
		
		var bx:int=tp.x;
		var by:int=tp.y;
		var ex:int=bx+EM.m_FormInfoBar.m_TxtScore.width;
		var ey:int=by+EM.m_FormInfoBar.m_TxtScore.height;

		Prepare(bx,by,ex,ey);
	}

	public function ShowTechDir(dir:int, lvl:int, sx:int, sy:int, showfull:Boolean):void
	{
		m_HintNew = !visible;
		Hide();

		var val:Number;
		var val2:Number;
		var val3:Number;
		var i:int;
		var str:String;
		var ar:Array=new Array();
		var y:int=0;

		var pl:Array=EM.DirValAr(dir);
		
		var ad:Array=null;

		if(dir==Common.DirEmpireMax) ad=Common.DirEmpireMaxDesc;
		else if(dir==Common.DirEnclaveMax) ad=Common.DirEnclaveMaxDesc;
		else if(dir==Common.DirColonyMax) ad=Common.DirColonyMaxDesc;
		//else if(dir==Common.DirPlanetLevelMax) ad=Common.DirPlanetLevelMaxDesc;
		else if(dir==Common.DirShipMassMax) ad=Common.DirShipMassMaxDesc;
		else if(dir==Common.DirShipSpeed) ad=Common.DirShipSpeedDesc;
		else if(dir==Common.DirPlanetProtect) ad=Common.DirPlanetProtectDesc;
		else if(dir==Common.DirCaptureSlow) ad=Common.DirCaptureSlowDesc;

//		else if(dir==Common.DirModuleSpeed) ad=Common.DirModuleSpeedDesc;
//		else if(dir==Common.DirResSpeed) ad=Common.DirResSpeedDesc;
//		else if(dir==Common.DirSupplyNormal) ad=Common.DirSupplyNormalDesc;
//		else if(dir==Common.DirSupplyMuch) ad=Common.DirSupplyMuchDesc;
//		else if(dir==Common.DirModuleMax) ad=Common.DirModuleMaxDesc;
//		else if(dir==Common.DirResMax) ad=Common.DirResMaxDesc;
//		else if(dir==Common.DirCitadelCost) ad=Common.DirCitadelCostDesc;
//		else if(dir==Common.DirPlanetLavelCost) ad=Common.DirPlanetLavelCostDesc;

		else if(dir==Common.DirTransportPrice) ad=Common.DirTransportPriceDesc;
		else if(dir==Common.DirTransportCnt) ad=Common.DirTransportCntDesc;
		//else if(dir==Common.DirTransportSupply) ad=Common.DirTransportSupplyDesc;
		else if(dir==Common.DirTransportMass) ad=Common.DirTransportMassDesc;
//		else if(dir==Common.DirTransportFuel) ad=Common.DirTransportFuelDesc;
		else if(dir==Common.DirTransportArmour) ad=Common.DirTransportArmourDesc;
		else if(dir==Common.DirTransportWeapon) ad=Common.DirTransportWeaponDesc;
		else if(dir==Common.DirTransportCargo) ad=Common.DirTransportCargoDesc;

		else if(dir==Common.DirCorvettePrice) ad=Common.DirCorvettePriceDesc;
		else if(dir==Common.DirCorvetteCnt) ad=Common.DirCorvetteCntDesc;
		//else if(dir==Common.DirCorvetteSupply) ad=Common.DirCorvetteSupplyDesc;
		else if(dir==Common.DirCorvetteMass) ad=Common.DirCorvetteMassDesc;
//		else if(dir==Common.DirCorvetteFuel) ad=Common.DirCorvetteFuelDesc;
		else if(dir==Common.DirCorvetteArmour) ad=Common.DirCorvetteArmourDesc;
		else if(dir==Common.DirCorvetteWeapon) ad=Common.DirCorvetteWeaponDesc;
		else if(dir==Common.DirCorvetteAccuracy) ad=Common.DirCorvetteAccuracyDesc;
		else if(dir==Common.DirCorvetteStealth) ad=Common.DirCorvetteStealthDesc;
		
		else if(dir==Common.DirCruiserAccess) ad=Common.DirCruiserAccessDesc;
		else if(dir==Common.DirCruiserPrice) ad=Common.DirCruiserPriceDesc;
		else if(dir==Common.DirCruiserCnt) ad=Common.DirCruiserCntDesc;
		//else if(dir==Common.DirCruiserSupply) ad=Common.DirCruiserSupplyDesc;
		else if(dir==Common.DirCruiserMass) ad=Common.DirCruiserMassDesc;
//		else if(dir==Common.DirCruiserFuel) ad=Common.DirCruiserFuelDesc;
		else if(dir==Common.DirCruiserArmour) ad=Common.DirCruiserArmourDesc;
		else if(dir==Common.DirCruiserWeapon) ad=Common.DirCruiserWeaponDesc;
		else if(dir==Common.DirCruiserAccuracy) ad=Common.DirCruiserAccuracyDesc;

		else if(dir==Common.DirDreadnoughtAccess) ad=Common.DirDreadnoughtAccessDesc;
		else if(dir==Common.DirDreadnoughtPrice) ad=Common.DirDreadnoughtPriceDesc;
		else if(dir==Common.DirDreadnoughtCnt) ad=Common.DirDreadnoughtCntDesc;
		//else if(dir==Common.DirDreadnoughtSupply) ad=Common.DirDreadnoughtSupplyDesc;
		else if(dir==Common.DirDreadnoughtMass) ad=Common.DirDreadnoughtMassDesc;
//		else if(dir==Common.DirDreadnoughtFuel) ad=Common.DirDreadnoughtFuelDesc;
		else if(dir==Common.DirDreadnoughtArmour) ad=Common.DirDreadnoughtArmourDesc;
		else if(dir==Common.DirDreadnoughtWeapon) ad=Common.DirDreadnoughtWeaponDesc;
		else if(dir==Common.DirDreadnoughtAccuracy) ad=Common.DirDreadnoughtAccuracyDesc;

		else if(dir==Common.DirInvaderPrice) ad=Common.DirInvaderPriceDesc;
		else if(dir==Common.DirInvaderCnt) ad=Common.DirInvaderCntDesc;
		//else if(dir==Common.DirInvaderSupply) ad=Common.DirInvaderSupplyDesc;
		else if(dir==Common.DirInvaderMass) ad=Common.DirInvaderMassDesc;
//		else if(dir==Common.DirInvaderFuel) ad=Common.DirInvaderFuelDesc;
		else if(dir==Common.DirInvaderArmour) ad=Common.DirInvaderArmourDesc;
		else if(dir==Common.DirInvaderWeapon) ad=Common.DirInvaderWeaponDesc;
		else if(dir==Common.DirInvaderCaptureSpeed) ad=Common.DirInvaderCaptureSpeedDesc;

		else if(dir==Common.DirDevastatorAccess) ad=Common.DirDevastatorAccessDesc;
		else if(dir==Common.DirDevastatorPrice) ad=Common.DirDevastatorPriceDesc;
		else if(dir==Common.DirDevastatorCnt) ad=Common.DirDevastatorCntDesc;
		//else if(dir==Common.DirDevastatorSupply) ad=Common.DirDevastatorSupplyDesc;
		else if(dir==Common.DirDevastatorMass) ad=Common.DirDevastatorMassDesc;
//		else if(dir==Common.DirDevastatorFuel) ad=Common.DirDevastatorFuelDesc;
		else if(dir==Common.DirDevastatorArmour) ad=Common.DirDevastatorArmourDesc;
		else if(dir==Common.DirDevastatorWeapon) ad=Common.DirDevastatorWeaponDesc;
		else if(dir==Common.DirDevastatorAccuracy) ad=Common.DirDevastatorAccuracyDesc;
		else if(dir==Common.DirDevastatorBomb) ad=Common.DirDevastatorBombDesc;
		
		else if(dir==Common.DirWarBaseAccess) ad=Common.DirWarBaseAccessDesc;
		else if(dir==Common.DirWarBasePrice) ad=Common.DirWarBasePriceDesc;
		else if(dir==Common.DirWarBaseCnt) ad=Common.DirWarBaseCntDesc;
		//else if(dir==Common.DirWarBaseSupply) ad=Common.DirWarBaseSupplyDesc;
		else if(dir==Common.DirWarBaseMass) ad=Common.DirWarBaseMassDesc;
		else if(dir==Common.DirWarBaseArmour) ad=Common.DirWarBaseArmourDesc;
		else if(dir==Common.DirWarBaseAccuracy) ad=Common.DirWarBaseAccuracyDesc;
		else if(dir==Common.DirWarBaseRepair) ad=Common.DirWarBaseRepairDesc;
		else if(dir==Common.DirWarBaseArmourAll) ad=Common.DirWarBaseArmourAllDesc;

		else if(dir==Common.DirShipyardAccess) ad=Common.DirShipyardAccessDesc;
		else if(dir==Common.DirShipyardPrice) ad=Common.DirShipyardPriceDesc;
		else if(dir==Common.DirShipyardCnt) ad=Common.DirShipyardCntDesc;
		//else if(dir==Common.DirShipyardSupply) ad=Common.DirShipyardSupplyDesc;
		else if(dir==Common.DirShipyardMass) ad=Common.DirShipyardMassDesc;
		else if(dir==Common.DirShipyardArmour) ad=Common.DirShipyardArmourDesc;
		else if(dir==Common.DirShipyardAccuracy) ad=Common.DirShipyardAccuracyDesc;
		else if(dir==Common.DirShipyardRepair) ad=Common.DirShipyardRepairDesc;
		else if(dir==Common.DirShipyardRepairAll) ad=Common.DirShipyardRepairAllDesc;

		else if(dir==Common.DirSciBaseAccess) ad=Common.DirSciBaseAccessDesc;
		else if(dir==Common.DirSciBasePrice) ad=Common.DirSciBasePriceDesc;
		else if(dir==Common.DirSciBaseCnt) ad=Common.DirSciBaseCntDesc;
		//else if(dir==Common.DirSciBaseSupply) ad=Common.DirSciBaseSupplyDesc;
		else if(dir==Common.DirSciBaseMass) ad=Common.DirSciBaseMassDesc;
		else if(dir==Common.DirSciBaseArmour) ad=Common.DirSciBaseArmourDesc;
		else if(dir==Common.DirSciBaseAccuracy) ad=Common.DirSciBaseAccuracyDesc;
		else if(dir==Common.DirSciBaseRepair) ad=Common.DirSciBaseRepairDesc;
		else if (dir == Common.DirSciBaseStabilizer) ad = Common.DirSciBaseStabilizerDesc;
		
		else if (dir == Common.DirQuarkBaseAccess) ad = Common.DirQuarkBaseAccessDesc;
		//else if (dir == Common.DirQuarkBaseMass) ad = Common.DirQuarkBaseMassDesc;
		else if (dir == Common.DirQuarkBaseWeapon) ad = Common.DirQuarkBaseWeaponDesc;
		else if (dir == Common.DirQuarkBaseAccuracy) ad = Common.DirQuarkBaseAccuracyDesc;
		else if (dir == Common.DirQuarkBaseArmour) ad = Common.DirQuarkBaseArmourDesc;
		else if (dir == Common.DirQuarkBaseRepair) ad = Common.DirQuarkBaseRepairDesc;
		else if (dir == Common.DirQuarkBaseAntiGravitor) ad = Common.DirQuarkBaseAntiGravitorDesc;
		else if (dir == Common.DirQuarkBaseGravWell) ad = Common.DirQuarkBaseGravWellDesc;
		else if (dir == Common.DirQuarkBaseBlackHole) ad = Common.DirQuarkBaseBlackHoleDesc;
		else if (dir == Common.DirQuarkBaseHP) ad = Common.DirQuarkBaseHPDesc;
		else if (dir == Common.DirQuarkBaseShield) ad = Common.DirQuarkBaseShieldDesc;
		else if (dir == Common.DirQuarkBaseShieldReduce) ad = Common.DirQuarkBaseShieldReduceDesc;
		else if (dir == Common.DirQuarkBaseShieldInc) ad = Common.DirQuarkBaseShieldIncDesc;

		var offval:Boolean = (dir == Common.DirCorvetteStealth) || (dir == Common.DirCruiserAccess) || (dir == Common.DirDreadnoughtAccess) || (dir == Common.DirDevastatorAccess) || (dir == Common.DirWarBaseAccess) || (dir == Common.DirShipyardAccess) || (dir == Common.DirSciBaseAccess) || (dir == Common.DirQuarkBaseAccess);

		if(1) {
			str=Common.DirName[dir];
			if(!offval) {
				str+=" "+lvl.toString();
				if((pl!=null) && (lvl<pl.length-1)) str+="/"+(pl.length-1).toString();
			}
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if(ad!=null) {
			var iend:int=pl.length;
			if(offval) iend=Math.min(lvl+1,pl.length);
			else if(!showfull) iend=Math.min(lvl+2,pl.length);

//lvl=0;
			for(i=lvl;i<iend;i++) {
				if(i==lvl) {}
				else {
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.NextLvl+": "+i.toString(),  clr:0xC0C0C0, ax:-1, ay:1, fontsize:12,						cs_left:0, cs_right:0, cs_top:-3+15, cs_bottom:-3 });
					y++;
				}

				val = pl[i];
				val2 = 0;
				val3 = 0;

				//if(dir==Common.DirTransportSupply || dir==Common.DirCorvetteSupply || dir==Common.DirCruiserSupply || dir==Common.DirDreadnoughtSupply  || dir==Common.DirInvaderSupply || dir==Common.DirDevastatorSupply || dir==Common.DirWarBaseSupply || dir==Common.DirShipyardSupply || dir==Common.DirSciBaseSupply) val=Math.round((val*100)/256);
				//else
				if(dir==Common.DirTransportArmour || dir==Common.DirCruiserArmour || dir==Common.DirDreadnoughtArmour || dir==Common.DirInvaderArmour || dir==Common.DirDevastatorArmour || dir==Common.DirWarBaseArmour || dir==Common.DirShipyardArmour || dir==Common.DirSciBaseArmour || dir==Common.DirQuarkBaseArmour || dir==Common.DirQuarkBaseShieldReduce) val=Math.round((val*100)/256);
				else if(dir==Common.DirCorvetteArmour) { val=Math.round((val*100)/256); val2=val*3; }
				else if(dir==Common.DirCorvetteAccuracy || dir==Common.DirCruiserAccuracy || dir==Common.DirDreadnoughtAccuracy || dir==Common.DirWarBaseAccuracy || dir==Common.DirShipyardAccuracy || dir==Common.DirSciBaseAccuracy || dir==Common.DirQuarkBaseAccuracy) val=Math.round((val*100)/256);
				else if(dir==Common.DirDevastatorAccuracy) { val=Math.round((val*100)/256); val2=Math.round((Common.DirDevastatorAccuracyHitLvl[i]*100)/256); } 
				else if(dir==Common.DirInvaderCaptureSpeed) val=Math.round(((/*256+*/val)*100)/256);
				else if(dir==Common.DirWarBaseRepair || dir==Common.DirShipyardRepair || dir==Common.DirShipyardRepairAll || dir==Common.DirSciBaseRepair || dir==Common.DirQuarkBaseRepair) val2=val<<1;
				else if(dir==Common.DirWarBaseArmourAll) val=Math.round((val*100)/256);
				else if (dir == Common.DirQuarkBaseShieldInc) val2 = val * 3;
				else if (dir == Common.DirShipMassMax) { val2 = Common.DirShipMassMaxLvlEnc[i]; val3 = Common.DirShipMassMaxLvlDef[i]; }
				//else if(dir==Common.DirModuleMax) val2=val*Common.ModuleMaxMul;
				//else if(dir==Common.DirResSpeed) val-=100;

				if(i<ad.length) str=ad[i];
				else str=ad[ad.length-1];
				str = BaseStr.Replace(str, "<Val>", "<font color='#ffff00'>" + BaseStr.FormatBigInt(val) + "</font>");
				str = BaseStr.Replace(str, "<Val2>", "<font color='#ffff00'>" + BaseStr.FormatBigInt(val2) + "</font>");
				str = BaseStr.Replace(str, "<Val3>", "<font color='#ffff00'>" + BaseStr.FormatBigInt(val3) + "</font>");
//for(var u:int=0;u<str.length;u++) trace(str.charAt(u),"=",str.charCodeAt(u));
				ar.push({x:0, y:y, sx:3, sy:1, txt:str,  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			
			if (dir == Common.DirQuarkBaseGravWell) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.TechGravWell,  clr:0xffffff, ax: -1, ay:1, fontsize:14,						cs_left:0, cs_right:0, cs_top: -3 + 10, cs_bottom: -3, auto_width:300 } );
				y++;
			} else if (dir == Common.DirQuarkBaseBlackHole) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.TechBlackHole,  clr:0xffffff, ax: -1, ay:1, fontsize:14,						cs_left:0, cs_right:0, cs_top: -3 + 10, cs_bottom: -3, auto_width:300 } );
				y++;
			}

			if(i<pl.length) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.TechShowFullList,  clr:0x8f8f8f, ax:-1, ay:1, fontsize:12,						cs_left:0, cs_right:0, cs_top:-3+10, cs_bottom:-3, auto_width:300 });
				y++;
			}

		} else {
			var pll:int=pl[lvl];
			var plln:int=0; if(lvl+1<pl.length) plln=pl[lvl+1];
//			if(dir==Common.DirPlanetLavelCost) {
//				//if(EM.m_CotlType==Common.CotlTypeProtect) { pll=(pll * EM.m_OpsCostBuildLvl)>>8; plln=(plln * EM.m_OpsCostBuildLvl)>>8; }
//				//else {
//					pll=(pll * EM.m_InfrCostMul)>>8; plln=(plln * EM.m_InfrCostMul)>>8;
//				//}
//			}
			//if(dir==Common.DirTransportSupply || dir==Common.DirCorvetteSupply || dir==Common.DirCruiserSupply || dir==Common.DirDreadnoughtSupply || dir==Common.DirInvaderSupply || dir==Common.DirDevastatorSupply || dir==Common.DirWarBaseSupply || dir==Common.DirShipyardSupply || dir==Common.DirSciBaseSupply) {
			//	pll=(100*pll)>>8; plln=(100*plln)>>8;

			//} else
			if(dir==Common.DirTransportArmour || dir==Common.DirCorvetteArmour || dir==Common.DirCruiserArmour || dir==Common.DirDreadnoughtArmour || dir==Common.DirInvaderArmour || dir==Common.DirDevastatorArmour || dir==Common.DirWarBaseArmour || dir==Common.DirShipyardArmour || dir==Common.DirSciBaseArmour) {
				pll=(100*pll)>>8; plln=(100*plln)>>8;

			} else if(dir==Common.DirCorvetteAccuracy || dir==Common.DirCruiserAccuracy || dir==Common.DirDreadnoughtAccuracy || dir==Common.DirDevastatorAccuracy || dir==Common.DirWarBaseAccuracy || dir==Common.DirShipyardAccuracy || dir==Common.DirSciBaseAccuracy) {
				pll=(100*pll)>>8; plln=(100*plln)>>8;

			} else if(dir==Common.DirInvaderCaptureSpeed) {
				pll=(100*pll)>>8; plln=(100*plln)>>8;

			} else if(dir==Common.DirWarBaseArmourAll) {
				pll=(100*pll)>>8; plln=(100*plln)>>8;

			} else if(dir==Common.DirCruiserWeapon) {
				pll<<=1; plln<<=1;
			}

			if((pl!=null) && !offval && (lvl<pl.length)) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.DirPar[dir]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(pll)+Common.DirParSuf[dir], clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
	
			if((pl!=null) && !offval && (lvl+1<pl.length)) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.NextLvl+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(plln)+Common.DirParSuf[dir], clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		
//			if(lvl>=3) {
//				ar.push({x:1, y:y, sx:3, sy:1, txt:"<font color='#FFFF00'>"+Common.Txt.TechNeedPlusar+"</font>",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:5, cs_bottom:-3 });
//				y++;
//			}
		}

		BuildGrid(ar);

		Prepare(sx,sy,sx+50,sy+50);
	}

	public function ShowTalentVec(userid:uint, vec:int, lvl:int, sx:int, sy:int, showfull:Boolean):void
	{
		m_HintNew = !visible;
		Hide();

		var val:Number;
		var val2:Number;
		var val3:Number;
		var i:int;
		var str:String;
		var ar:Array=new Array();
		var y:int=0;

		var pl:Array=EM.VecValAr(vec);
		
		var ad:Array=null;

		if(vec==Common.VecMoveSpeed) ad=Common.VecMoveSpeedDesc;
//		else if(vec==Common.VecMoveFuel) ad=Common.VecMoveFuelDesc;
		else if(vec==Common.VecMoveIntercept) ad=Common.VecMoveInterceptDesc;
		else if(vec==Common.VecMoveAccelerator) ad=Common.VecMoveAcceleratorDesc;
		else if(vec==Common.VecMovePortal) ad=Common.VecMovePortalDesc;
		else if(vec==Common.VecMoveRadar) ad=Common.VecMoveRadarDesc;
		else if(vec==Common.VecMoveCover) ad=Common.VecMoveCoverDesc;
		else if(vec==Common.VecMoveExchange) ad=Common.VecMoveExchangeDesc;

		else if(vec==Common.VecProtectHP) ad=Common.VecProtectHPDesc;
		else if(vec==Common.VecProtectArmour) ad=Common.VecProtectArmourDesc;
		else if(vec==Common.VecProtectShield) ad=Common.VecProtectShieldDesc;
		else if(vec==Common.VecProtectShieldInc) ad=Common.VecProtectShieldIncDesc;
		else if(vec==Common.VecProtectShieldReduce) ad=Common.VecProtectShieldReduceDesc;
		else if(vec==Common.VecProtectInvulnerability) ad=Common.VecProtectInvulnerabilityDesc;
		else if (vec == Common.VecProtectRepair) ad = Common.VecProtectRepairDesc;
		else if(vec==Common.VecProtectAntiExchange) ad=Common.VecProtectAntiExchangeDesc;

		else if(vec==Common.VecAttackCannon) ad=Common.VecAttackCannonDesc;
		else if(vec==Common.VecAttackLaser) ad=Common.VecAttackLaserDesc;
		else if(vec==Common.VecAttackMissile) ad=Common.VecAttackMissileDesc;
		else if(vec==Common.VecAttackAccuracy) ad=Common.VecAttackAccuracyDesc;
		else if(vec==Common.VecAttackMine) ad=Common.VecAttackMineDesc;
		else if(vec==Common.VecAttackTransiver) ad=Common.VecAttackTransiverDesc;

		else if(vec==Common.VecSystemSensor) ad=Common.VecSystemSensorDesc;
		else if(vec==Common.VecSystemStealth) ad=Common.VecSystemStealthDesc;
		else if(vec==Common.VecSystemRecharge) ad=Common.VecSystemRechargeDesc;
		else if(vec==Common.VecSystemHacker) ad=Common.VecSystemHackerDesc;
		else if(vec==Common.VecSystemJummer) ad=Common.VecSystemJummerDesc;
		else if(vec==Common.VecSystemDisintegrator) ad=Common.VecSystemDisintegratorDesc;
		else if(vec==Common.VecSystemConstructor) ad=Common.VecSystemConstructorDesc;
		
		else if(vec==Common.VecMoveGravitor) ad=Common.VecMoveGravitorDesc;

		var offval:Boolean=false;//(vec==Common.VecMoveIntercept);

		if(1) {
			str=Common.VecName[vec];
			if(!offval) {
				str+=" "+lvl.toString();
				if((pl!=null) && /*(lvl<pl.length-1)*/pl.length>1) str+="/"+(pl.length-1).toString();
			}
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if(ad==null) return;
		
			var iend:int=pl.length;
			if(offval) iend=Math.min(lvl+1,pl.length);
			else if(!showfull) iend=Math.min(lvl+2,pl.length);

			for(i=lvl;i<iend;i++) {
				if(i==lvl) {}
				else {
					ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.NextLvl+": "+i.toString(),  clr:0xC0C0C0, ax:-1, ay:1, fontsize:12,						cs_left:0, cs_right:0, cs_top:-3+15, cs_bottom:-3 });
					y++;
				}

				val = pl[i];
				val2 = 0;
				val3 = 0;

				if (vec == Common.VecProtectArmour || vec == Common.VecProtectShieldReduce || vec == Common.VecAttackAccuracy || vec == Common.VecSystemDisintegrator) val = Math.round((val * 100) / 256);
				if (vec == Common.VecSystemSensor) { val2 = Common.VecSystemSensorLvlDestroy[i]; val3 = 100 - Math.round((Common.VecSystemSensorLvlDetonation[i] * 100) / 256); }
				if (vec == Common.VecMoveGravitor) val2 = Common.VecMoveGravitorPeriod[i];
				if (vec == Common.VecProtectShieldInc || vec == Common.VecAttackTransiver) val2 = val * 3;

				if(i<ad.length) str=ad[i];
				else str=ad[ad.length-1];
				str = BaseStr.Replace(str, "<Val>", "<font color='#ffff00'>" + BaseStr.FormatBigInt(val) + "</font>");
				str = BaseStr.Replace(str, "<Val2>", "<font color='#ffff00'>" + BaseStr.FormatBigInt(val2) + "</font>");
				str = BaseStr.Replace(str, "<Val3>", "<font color='#ffff00'>" + BaseStr.FormatBigInt(val3) + "</font>");
//for(var u:int=0;u<str.length;u++) trace(str.charAt(u),"=",str.charCodeAt(u));
				ar.push({x:0, y:y, sx:3, sy:1, txt:str,  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			
			if (EM.m_GameState & Common.GameStateTraining) { }
			else if (vec == Common.VecMovePortal) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.TechPortalNoPlusar,  clr:0xff4040, ax:-1, ay:1, fontsize:12,						cs_left:0, cs_right:0, cs_top:-3+10, cs_bottom:-3 });
				y++;
			}
			if(vec==Common.VecProtectAntiExchange) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.TechAntiExchangeNeed,  clr:0xffff00, ax:-1, ay:1, fontsize:13,						cs_left:0, cs_right:0, cs_top:-3+10, cs_bottom:-3 });
				y++;
			}

			if(i<pl.length) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.TechShowFullList,  clr:0x8f8f8f, ax:-1, ay:1, fontsize:12,						cs_left:0, cs_right:0, cs_top:-3+10, cs_bottom:-3 });
				y++;
			}


		BuildGrid(ar);

		Prepare(sx,sy,sx+50,sy+50);
	}
	
	public function TextTicket(tid:int):String
	{
		var union:Union;

		var ticket:Object=EM.m_FormInfoBar.GetTicket(tid);
		if(ticket==null) return null;

		var str:String,str2:String;

		var user:User = UserList.Self.GetUser(ticket.TargetUserId);
		
		var s:int = ticket.State;

		if(ticket.Type==Common.TicketTypeAttack) {
			if (ticket.State == 0) str = Common.Txt.TicketAttack;
			else str = Common.Txt.TicketAttackEnd;
			str = BaseStr.Replace(str, "<SectorX>", "[clr]" + (ticket.SectorX - ticket.m_SectorMinX + 1).toString() + "[/clr]");
			str = BaseStr.Replace(str, "<SectorY>", "[clr]" + (ticket.SectorY - ticket.m_SectorMinY + 1).toString() + "[/clr]");

		} else if(ticket.Type==Common.TicketTypePact) {
			if(ticket.State==0) str=Common.Txt.TicketPactSend;
			else if(ticket.State==1) str=Common.Txt.TicketPactQuery;
			else if(ticket.State==2) str=Common.Txt.TicketPactAccept;
			else if(ticket.State==3) str=Common.Txt.TicketPactReject;
			else if(ticket.State==4) str=Common.Txt.TicketPactComplate;
			else if(ticket.State==5) str=Common.Txt.TicketPactNoRes;
			else if(ticket.State==6) str=Common.Txt.TicketPactTimeOut;
			else if(ticket.State==7) str=Common.Txt.TicketPactChange;
			else if(ticket.State==8) str=Common.Txt.TicketPactBreak;
			else if(ticket.State==9) str=Common.Txt.TicketPactTimeOut2;
			else return null;

/*			if(user!=null) {
				union=UserList.Self.GetUnion(user.m_UnionId);
				if (union != null) {
					if(ticket.State==0) str=Common.Txt.TicketPactSend_Union;
					else if(ticket.State==1) str=Common.Txt.TicketPactQuery_Union;
					else if(ticket.State==2) str=Common.Txt.TicketPactAccept_Union;
					else if(ticket.State==3) str=Common.Txt.TicketPactReject_Union;
					else if(ticket.State==4) str=Common.Txt.TicketPactComplate_Union;
					else if(ticket.State==5) str=Common.Txt.TicketPactNoRes_Union;
					else if(ticket.State==6) str=Common.Txt.TicketPactTimeOut_Union;
					else if(ticket.State==7) str=Common.Txt.TicketPactChange_Union;
					else if(ticket.State==8) str=Common.Txt.TicketPactBreak_Union;
					else if(ticket.State==9) str=Common.Txt.TicketPactTimeOut2_Union;
					else return null;
					
					str2=union.NameUnion()+" "+union.m_Name;
					str = BaseStr.Replace(str, "<Union>", str2);
				}
			}*/

		} else if(ticket.Type==Common.TicketTypeCapture) {
			if(user) {
				if(ticket.State & 0x10000) str=Common.Txt.TicketCaptureCaptureUser;
				else str=Common.Txt.TicketCaptureLostUser;
			} else {
				if(ticket.State & 0x10000) str=Common.Txt.TicketCaptureCapture;
				else str=Common.Txt.TicketCaptureLost;
			}

			//if((ticket.State & 0xff)==Common.ItemTypeAntimatter) str+="\n"+Common.Txt.TicketCaptureAntimatter+": <font color='#ffff00'>"+BaseStr.FormatBigInt(ticket.Val)+"</font>";
			//else if((ticket.State & 0xff)==Common.ItemTypeMetal) str+="\n"+Common.Txt.TicketCaptureMetal+": <font color='#ffff00'>"+BaseStr.FormatBigInt(ticket.Val)+"</font>";
			//else if((ticket.State & 0xff)==Common.ItemTypeElectronics) str+="\n"+Common.Txt.TicketCaptureElectronics+": <font color='#ffff00'>"+BaseStr.FormatBigInt(ticket.Val)+"</font>";
			//else if((ticket.State & 0xff)==Common.ItemTypeProtoplasm) str+="\n"+Common.Txt.TicketCaptureProtoplasm+": <font color='#ffff00'>"+BaseStr.FormatBigInt(ticket.Val)+"</font>";
			//else if((ticket.State & 0xff)==Common.ItemTypeNodes) str+="\n"+Common.Txt.TicketCaptureNodes+": <font color='#ffff00'>"+BaseStr.FormatBigInt(ticket.Val)+"</font>";

		} else if(ticket.Type==Common.TicketTypeSack) {
			str=Common.Txt.TicketSack;
			str = BaseStr.Replace(str, "<Val>", "[clr]" + BaseStr.FormatBigInt(ticket.Val) + "[/clr]");
			
		} else if(ticket.Type==Common.TicketTypeUnionJoin) {
			if(ticket.State==0) str=Common.Txt.TicketUnionJoinFromQuery;
			else if(ticket.State==1) str=Common.Txt.TicketUnionJoinFromAccept;
			else if(ticket.State==2) str=Common.Txt.TicketUnionJoinFromCancel;
			else if(ticket.State==3) str=Common.Txt.TicketUnionJoinToQuery;
			else if(ticket.State==4) str=Common.Txt.TicketUnionJoinToAccept;
			else if(ticket.State==5) str=Common.Txt.TicketUnionJoinToCancel;
			else if(ticket.State==6) str=Common.Txt.TicketUnionJoinFromCancel2;
			else if(ticket.State==7) str=Common.Txt.TicketUnionJoinToCancel2;
			
			union=UserList.Self.GetUnion(ticket.Val);
			if(union!=null) {
				//str=str.replace(/<Union>/g,union.m_Name);
				str = BaseStr.Replace(str, "<Union>", "[clr]" + union.NameUnion() + " " + union.m_Name + "[/clr]");
			}

		} else if(ticket.Type==Common.TicketTypeAnnihilation) {
			str = Common.Txt.TicketAnnihilation;
			
		} else if (ticket.Type == Common.TicketTypeCombatInvite) {
			if (s == (Common.ttciDuel | Common.ttciQuery)) str=Common.Txt.TicketCombat_Duel_New_From_Query;
			else if (s == (Common.ttciDuel | Common.ttciNoAnser)) str = Common.Txt.TicketCombat_Duel_New_From_NoAnswer;
			else if (s == (Common.ttciDuel | Common.ttciOk)) str = Common.Txt.TicketCombat_Duel_New_From_Ok;
			else if (s == (Common.ttciDuel | Common.ttciCancel)) str = Common.Txt.TicketCombat_Duel_New_From_Cancel;

			else if (s == (Common.ttciDuel | Common.ttciTo | Common.ttciQuery)) str = Common.Txt.TicketCombat_Duel_New_To_Query;
			else if (s == (Common.ttciDuel | Common.ttciTo | Common.ttciNoAnser)) str = Common.Txt.TicketCombat_Duel_New_To_NoAnswer;
			else if (s == (Common.ttciDuel | Common.ttciTo | Common.ttciOk)) str = Common.Txt.TicketCombat_Duel_New_To_Ok;
			else if (s == (Common.ttciDuel | Common.ttciTo | Common.ttciCancel)) str = Common.Txt.TicketCombat_Duel_New_To_Cancel;

			else if (s == (Common.ttciDuel | Common.ttciJoin | Common.ttciQuery)) str = Common.Txt.TicketCombat_Duel_Join_From_Query;
			else if (s == (Common.ttciDuel | Common.ttciJoin | Common.ttciNoAnser)) str = Common.Txt.TicketCombat_Duel_Join_From_NoAnswer;
			else if (s == (Common.ttciDuel | Common.ttciJoin | Common.ttciOk)) str = Common.Txt.TicketCombat_Duel_Join_From_Ok;
			else if (s == (Common.ttciDuel | Common.ttciJoin | Common.ttciCancel)) str = Common.Txt.TicketCombat_Duel_New_From_Cancel;

			else if (s == (Common.ttciDuel | Common.ttciJoin | Common.ttciTo | Common.ttciQuery)) str = Common.Txt.TicketCombat_Duel_Join_To_Query;
			else if (s == (Common.ttciDuel | Common.ttciJoin | Common.ttciTo | Common.ttciNoAnser)) str = Common.Txt.TicketCombat_Duel_Join_To_NoAnswer;
			else if (s == (Common.ttciDuel | Common.ttciJoin | Common.ttciTo | Common.ttciOk)) str = Common.Txt.TicketCombat_Duel_Join_To_Ok;
			else if (s == (Common.ttciDuel | Common.ttciJoin | Common.ttciTo | Common.ttciCancel)) str = Common.Txt.TicketCombat_Duel_Join_To_Cancel;

			else if (s == (Common.ttciQuery)) str = Common.Txt.TicketCombat_Battle_New_From_Query;
			else if (s == (Common.ttciNoAnser)) str = Common.Txt.TicketCombat_Battle_New_From_NoAnswer;
			else if (s == (Common.ttciOk)) str = Common.Txt.TicketCombat_Battle_New_From_Ok;
			else if (s == (Common.ttciCancel)) str = Common.Txt.TicketCombat_Battle_New_From_Cancel;

			else if (s == (Common.ttciTo | Common.ttciQuery)) str = Common.Txt.TicketCombat_Battle_New_To_Query;
			else if (s == (Common.ttciTo | Common.ttciNoAnser)) str = Common.Txt.TicketCombat_Battle_New_To_NoAnswer;
			else if (s == (Common.ttciTo | Common.ttciOk)) str = Common.Txt.TicketCombat_Battle_New_To_Ok;
			else if (s == (Common.ttciTo | Common.ttciCancel)) str = Common.Txt.TicketCombat_Battle_New_To_Cancel;

			else if (s == (Common.ttciJoin | Common.ttciQuery)) str = Common.Txt.TicketCombat_Battle_Join_From_Query;
			else if (s == (Common.ttciJoin | Common.ttciNoAnser)) str = Common.Txt.TicketCombat_Battle_Join_From_NoAnswer;
			else if (s == (Common.ttciJoin | Common.ttciOk)) str = Common.Txt.TicketCombat_Battle_Join_From_Ok;
			else if (s == (Common.ttciJoin | Common.ttciCancel)) str = Common.Txt.TicketCombat_Battle_New_From_Cancel;

			else if (s == (Common.ttciJoin | Common.ttciTo | Common.ttciQuery)) str = Common.Txt.TicketCombat_Battle_Join_To_Query;
			else if (s == (Common.ttciJoin | Common.ttciTo | Common.ttciNoAnser)) str = Common.Txt.TicketCombat_Battle_Join_To_NoAnswer;
			else if (s == (Common.ttciJoin | Common.ttciTo | Common.ttciOk)) str = Common.Txt.TicketCombat_Battle_Join_To_Ok;
			else if (s == (Common.ttciJoin | Common.ttciTo | Common.ttciCancel)) str = Common.Txt.TicketCombat_Battle_Join_To_Cancel;
			
			else return null;

		} else return null;

		if(user!=null) {
			//str=str.replace(/<User>/g,user.m_Name);
			str = BaseStr.Replace(str, "<User>", "[clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id) + "[/clr]");

			union = null;
			if (user.m_UnionId) union = UserList.Self.GetUnion(user.m_UnionId);
			if (union != null) str = BaseStr.Replace(str, "<UserUnion>", "[clr]" + union.NameUnion() + " " + union.m_Name + "[/clr]");
			else {
				str = BaseStr.Replace(str, "(<UserUnion>)", "");
				str = BaseStr.Replace(str, "<UserUnion>", "");
			}
		} else {
			str = BaseStr.Replace(str, "(<UserUnion>)", "");
			str = BaseStr.Replace(str, "<UserUnion>", "");
		}

		str = BaseStr.Replace(str, "  ", " ");

		return str;
	}

	public function ShowTicket(tid:int, sx:int, sy:int):void
	{
		m_HintNew = !visible;
		Hide();

		var str:String = TextTicket(tid);
		if (str == null) return;

		var ar:Array=new Array();
		var y:int=0;

		ar.push({x:0, y:y, sx:3, sy:1, txt:BaseStr.FormatTag(str), clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });

		BuildGrid(ar);

		Prepare(sx,sy,sx+20,sy+30);
	} 

	public function ShowTicketEx(tid:int, sx:int, sy:int):void
	{
		var str:String;
		var obj:Object, obj2:Object;
		var i:int, u:int, k:int, cnt:int;
		var itemtype:uint;
		var clr:uint;
		var user:User;
		var union:Union;
		var ul:Array = new Array();
		
		m_HintNew = !visible;
		Hide();

		var ticket:Object=EM.m_FormInfoBar.GetTicket(tid);
		if(ticket==null) return;

		var ar:Array=new Array();
		var y:int=0;
		
		if (1) {
			if (ticket.Type == Common.TicketTypeAttack && ticket.State == 0) str = Common.Txt.TicketExAttack;
			else if (ticket.Type == Common.TicketTypeAttack && ticket.State != 0) str = Common.Txt.TicketExAttackEnd;
			else if (ticket.Type == Common.TicketTypeCapture && (ticket.State & 0x10000) != 0) str = Common.Txt.TicketCaptureTake;
			else if (ticket.Type == Common.TicketTypeCapture && (ticket.State & 0x10000) == 0) str = Common.Txt.TicketCaptureLost;
			else if (ticket.Type == Common.TicketTypeSack) str = Common.Txt.TicketExSack;

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		if (true) {
			str = "" + EM.CotlName(ticket.CotlId,true) + "";

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		if (ticket.Type == Common.TicketTypeSack) {
			user = UserList.Self.GetUser(ticket.TargetUserId);
			if (user != null) {
				str = Common.Txt.TicketExSackNewOwner + ": [clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id) + "[/clr]";

				if(user.m_UnionId!=0) {
					union = UserList.Self.GetUnion(user.m_UnionId);
					if (union != null) {
						str += " ([clr]" +union.m_Name + "[/clr])";
					}
				}
				
				ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		while (ticket.Type == Common.TicketTypeSack) {
			var itl:Vector.<uint> = new Vector.<uint>();
			var icl:Vector.<int> = new Vector.<int>();
			for (i = EM.m_FormInfoBar.m_TicketList.length - 1; i >= 0; i--) {
				obj = EM.m_FormInfoBar.m_TicketList[i];
				if (obj.Flag & 0x80000000) continue;
				if (obj.Duplicate >= 0) continue;
				if (obj == ticket || (obj.Parent >= 0 && EM.m_FormInfoBar.m_TicketList[obj.Parent] == ticket)) {
					itemtype = obj.State;
					k = itl.indexOf(itemtype);
					if (k < 0) { itl.push(itemtype); icl.push(obj.Val); }
					else { icl[k] += obj.Val; }
					
					for (u = 0; u < EM.m_FormInfoBar.m_TicketList.length; u++) {
						obj2 = EM.m_FormInfoBar.m_TicketList[u];
						if (obj2.Flag & 0x80000000) continue;
						if (obj2.Duplicate < 0) continue;
						if (EM.m_FormInfoBar.m_TicketList[obj2.Duplicate] != obj) continue;

						itemtype = obj2.State;
						k = itl.indexOf(itemtype);
						if (k < 0) { itl.push(itemtype); icl.push(obj2.Val); }
						else { icl[k] += obj2.Val; }
					}
				}
			}
			if (itl.length < 0) break;
			if(1) { // Space
				ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
				y++;
			}
			for (i = 0; i < itl.length; i++) {
				str = EM.ItemName(itl[i]) + ": [clr]" + BaseStr.FormatBigInt(icl[i]) + "[/clr]";
				ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:200 });
				y++;
			}
			break;
		}

		if(1) { // Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}

		if (1) {
			cnt = 0;
			for (i = EM.m_FormInfoBar.m_TicketList.length - 1; i >= 0; i--) {
				obj = EM.m_FormInfoBar.m_TicketList[i];
				if (obj.Flag & 0x80000000) continue;
				if (obj.Duplicate >= 0) continue;
				if (obj == ticket || (obj.Parent >= 0 && EM.m_FormInfoBar.m_TicketList[obj.Parent] == ticket)) {
					if (cnt >= 5) str = "...";
					else {
						str = "[" + (obj.SectorX - obj.SectorMinX + 1).toString() + "," + (obj.SectorY - obj.SectorMinY + 1).toString() + "]";
						if(obj.Type != Common.TicketTypeSack) {
							user = UserList.Self.GetUser(obj.TargetUserId);
							if (user != null) {
								str += " " + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
								ul.push(user.m_Id);
							}
						}
					}

					clr = 0xafafaf;
					if ((obj.Flag & 1) == 0) clr = 0xffffff;
					else {
						for (u = 0; u < EM.m_FormInfoBar.m_TicketList.length; u++) {
							obj2 = EM.m_FormInfoBar.m_TicketList[u];
							if (obj2.Flag & 0x80000000) continue;
							if (obj2.Duplicate < 0) continue;
							if (EM.m_FormInfoBar.m_TicketList[obj2.Duplicate] != obj) continue;
							
							if ((obj2.Flag & 1) == 0) {
								clr = 0xffffff;
								
								if (obj2.Type != Common.TicketTypeSack && ul.indexOf(obj2.TargetUserId) < 0) {
									user = UserList.Self.GetUser(obj2.TargetUserId);
									if (user != null) {
										str += ", " + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
										ul.push(user.m_Id);
									}
								}
							}
						}
					}

					ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:clr, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:200 });
					y++;
					if (cnt >= 5) break;
					cnt++;
				}
			}
		}
		
		BuildGrid(ar);

		Prepare(sx,sy,sx+20,sy+30);
	}

/*	public function ShowFleet(owner:uint, cpt_id:uint, sx:int, sy:int):void
	{
		var str:String;
		
		var user:User=UserList.Self.GetUser(owner);
		if(user==null) return;

		var cpt:Cpt=user.GetCpt(cpt_id);
		if(cpt==null) return;
		
		var cotl:Cotl=EM.m_FormGalaxy.GetCotl(cpt.m_CotlId);
		if(cotl==null) return;
		
		var cf:CotlFleet=cotl.FleetByCptId(cpt_id);
		if(cf==null) return;

		var ar:Array=new Array();
		var y:int=0;

		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.FleetCaption, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.FleetDesc, clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6 });
			y++;
		}
		
		if(1) {
			while(cpt!=null) {
				if(owner==Server.Self.m_UserId) {
					var obj:Object=EM.m_FormCptBar.CptDsc(cpt.m_Id);
					if(obj==null) break;
					str=obj.Name;
				} else {
					if(cpt.m_Name==null || cpt.m_Name.length<=0) break;
					str=cpt.m_Name;
				}
				
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Cpt+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
				y++;
				
				break;
			}
		}

		// Owner
		if(owner) {
			str=Common.Txt.Load;
			user=UserList.Self.GetUser(owner);
			if(user!=null) str=user.m_Name;

			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.Owner+": <font color='#ffff00'>"+str+"</font>", clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;
		}
		
		if(1) { // Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}
		
		// Fleet
		while((owner==Server.Self.m_UserId)) {
			
			if(cpt.m_StatTransportCnt!=0);
			else if(cpt.m_StatCorvetteCnt!=0);
			else if(cpt.m_StatCruiserCnt!=0);
			else if(cpt.m_StatDreadnoughtCnt!=0);
			else if(cpt.m_StatInvaderCnt!=0);
			else if(cpt.m_StatDevastatorCnt!=0);
			else if(cpt.m_StatGroupCnt!=0);
			else break;
			
			var pnax:int=1;

			if(cpt.m_StatGroupCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.FleetGroupCnt+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatGroupCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(true) { // space
				ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
				y++;
			}

			if(cpt.m_StatTransportCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeTransport]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatTransportCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatCorvetteCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeCorvette]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatCorvetteCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatCruiserCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeCruiser]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatCruiserCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatDreadnoughtCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeDreadnought]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatDreadnoughtCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatInvaderCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeInvader]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatInvaderCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(cpt.m_StatDevastatorCnt) {
				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ShipNameForCnt[Common.ShipTypeDevastator]+":",  clr:0xffffff, ax:pnax, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cpt.m_StatDevastatorCnt), clr:0xffff00, ax: 1, ay:0, fontsize:14,		cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}

			if(true) { // space
				ar.push({x:0, y:y, sx:3, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
				y++;
			}

			break;
		}
		
		// Arrival
		if(cf.m_Arrival!=0) {
			str=Common.FormatPeriod((cf.m_Arrival-EM.GetServerTime())/1000);
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.FleetArrival+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		BuildGrid(ar);

		Prepare(sx-20,sy-30,sx+20,sy+30);
	}*/

	public function ShowFleet(fleetid:uint):void
	{
		var str:String;
		
		Hide();
		
		//var df:FleetDyn = EM.m_Hyperspace.FleetDynById(fleetid);
		//if (df == null) return;
		var hf:HyperspaceFleet = EM.HS.HyperspaceFleetById(fleetid);
		if (hf == null) return;

		var ar:Array=new Array();
		var y:int = 0;
		
		var user:User = UserList.Self.GetUser(0);// df.m_Owner);
		if (user == null) return;
		var uni:Union = null;
		
		if (user.m_UnionId != 0) {
			uni = UserList.Self.GetUnion(user.m_UnionId);
		}
		
		if (1) {
			str = Common.Txt.FleetUser;
			if (user != null) str += " " + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(uni!=null) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:uni.NameUnion() + " " + uni.m_Name, clr:0x00b7ff, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -2, cs_bottom: -2 } );
			y++;
		}
		
		if(true) {
			// Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		} 

		while (user != null ) {
			str = user.m_Rating.toString();
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserRating+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			str = user.m_CombatRating.toString();
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.CombatRating+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			break;
		}

		BuildGrid(ar);
		
		var sx:int = 0;// EM.m_Hyperspace.WorldToMapX(hf.m_X);
		var sy:int = 0;// EM.m_Hyperspace.WorldToMapY(hf.m_Y);
		var r:int = 50;
		Prepare(sx-r,sy-r,sx+r,sy+r);
	}
	
	public function ShowCotl(planet:SpacePlanet, cotl:SpaceCotl, sx:int, sy:int, r:int, zonelvl:int = -1):void
	{
		var i:int,u:int;
		var uni:Union;

		m_HintNew = !visible;
		Hide();
		
		if(cotl==null) return;

		var user:User;
		var ar:Array=new Array();
		var y:int=0;
		var str:String;
		var str2:String;
		
		user = null;
		if(cotl.m_CotlType == Common.CotlTypeCombat) {}
		else if (cotl.m_CotlType == Common.CotlTypeUser) user = UserList.Self.GetUser(cotl.m_AccountId);

		uni = null;
		if (cotl.m_CotlType == Common.CotlTypeCombat) { }
		else if(cotl.m_CotlType==Common.CotlTypeUser) {
			if(user!=null && user.m_UnionId) uni=UserList.Self.GetUnion(user.m_UnionId);
		} else if(cotl.m_UnionId!=0) {
			uni=UserList.Self.GetUnion(cotl.m_UnionId);
		}

//		str=EM.Txt_CotlName(cotl.m_Id);
//		if(cotl.m_Type==Common.CotlTypeRich) {
//			str=Common.Txt.CotlRich+" "+str;
//		}
//		if(str=='' && cotl.m_Type==Common.CotlTypeUser) {
//			str=Common.Txt.CotlUser;
//			if(user!=null) str+=" "+user.m_Name;
//		}
//		if(str=='') str='-';

//		if (planet != null) {
//			str = Common.Txt.HyperspacePlanetName;
//			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0x00ff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
//		}

		if (1) {
			str = "";
			if (planet != null) {
				if ((planet.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeSun) str += Common.Txt.HyperspaceStar;
				else if ((planet.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypePlanet) str += Common.Txt.HyperspacePlanet;
				else if ((planet.m_PlanetFlag & SpacePlanet.FlagTypeMask) == SpacePlanet.FlagTypeSputnik) str += Common.Txt.HyperspaceSputnik;

				if (cotl.m_CotlType == Common.CotlTypeUser) str += " " + Common.Txt.HyperspaceInCotlUser;
				else str += " " + Common.Txt.HyperspaceInCotl;
			}

			if (cotl.m_CotlType == Common.CotlTypeCombat) str += " " + Common.Txt.HyperspaceCotlCombat;
			else str += " " + EM.CotlName(cotl.m_Id, planet == null);

			if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) str += " [crt](" +Common.Txt.HyperspaceCotlDevelopment + ")[/crt]";
			if (cotl.m_CotlFlag & SpaceCotl.fTemplate) str += " [crt](" +Common.Txt.HyperspaceCotlTemplate + ")[/crt]";

			ar.push({x:0, y:y, sx:3, sy:1, txt:BaseStr.Trim(str), clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) {
			str = "";
			if (cotl.m_DevTime <= EM.GetServerGlobalTime()) {
				str = Common.Txt.HyperspaceCotlDevNeed;
				ar.push( { x:0, y:y, sx:3, sy:1, txt:str, clr:0x00ff00, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
			} else {
				str = Common.Txt.HyperspaceCotlDevTime + ": ";
				str += Common.FormatPeriodLong((cotl.m_DevTime-EM.GetServerGlobalTime()) / 1000);
				ar.push( { x:0, y:y, sx:3, sy:1, txt:str, clr:0x00ff00, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
				y++;
			}
		}

		if (cotl.m_ProtectTime > EM.GetServerGlobalTime()) {
			if (((cotl.m_ProtectTime-EM.GetServerGlobalTime()) / 1000) > (60 * 60 * 24 * 30)) {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:"[crt]" +Common.Txt.CotlProtectPermanent + "[/crt]", clr:0xffff00, ax: -1, ay:0, fontsize:15,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			} else {
				ar.push( { x:0, y:y, sx:3, sy:1, txt:"[crt]" +Common.Txt.CotlProtect + " (" + Common.FormatPeriodLong((cotl.m_ProtectTime-EM.GetServerGlobalTime()) / 1000) + ")[/crt]", clr:0xffff00, ax: -1, ay:0, fontsize:15,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			}
			y++;
		}

		if (cotl.m_CotlType == Common.CotlTypeRich && cotl.m_TimeData == 1 && cotl.m_RestartTime * 1000 > EM.GetServerGlobalTime()) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:"[crt]" +Common.Txt.OccupyHomeworldTime + " (" + Common.FormatPeriodLong((cotl.m_RestartTime * 1000 - EM.GetServerGlobalTime()) / 1000) + ")[/crt]", clr:0xffff00, ax: -1, ay:0, fontsize:15,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		str=EM.Txt_CotlDesc(cotl.m_Id);
		if(str.length>0) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:str, clr:0xD0D0D0, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 + 6 } );
			y++;
		}

		if(uni!=null) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:uni.NameUnion() + " " + uni.m_Name, clr:0x00b7ff, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -2, cs_bottom: -2 } );
			y++;
		}

		if(true) {
			// Space
			ar.push( { x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax: -1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top: -5, cs_bottom: -5 } );
			y++;
		} 

		while(cotl.m_CotlType==Common.CotlTypeUser) {
			if(user==null) break;

			str = user.m_Rating.toString();

			if (zonelvl < 0) {
				//var zone:Zone=EM.m_Hyperspace.GetZone(Math.floor(cotl.m_X/EM.m_Hyperspace.m_ZoneSize),Math.floor(cotl.m_Y/EM.m_Hyperspace.m_ZoneSize));
				var zone:Zone = EM.HS.GetZone(Math.floor(cotl.m_ZoneX), Math.floor(cotl.m_ZoneY));
				if (zone != null) zonelvl = zone.m_Lvl;
			}

//			var zone:Zone=EM.m_Hyperspace.GetZone(Math.floor(cotl.m_X/EM.m_Hyperspace.m_ZoneSize),Math.floor(cotl.m_Y/EM.m_Hyperspace.m_ZoneSize));
			if(zonelvl>0 && !EM.TestRatingFlyCotl(cotl.m_AccountId,zonelvl)) str="<font color='#ff0000'>"+str+"</font>";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserRating+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			
			str = user.m_CombatRating.toString();
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.CombatRating+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

			break;
		}

		while(cotl.m_CotlType==Common.CotlTypeRich || cotl.m_CotlType==Common.CotlTypeProtect) {
			if (cotl.m_RewardExp == 0) break;
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.RewardExp+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:BaseStr.FormatBigInt(cotl.m_RewardExp)+" "+Common.Txt.Exp, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
			break;
		}

/*		if (cotl.m_ProtectTime > EM.GetServerTime()) {
			if (((cotl.m_ProtectTime-EM.GetServerTime()) / 1000) > (60 * 60 * 24 * 30)) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.CotlProtectPermanent, clr:0xffff00, ax:-1, ay:1, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3+5, cs_bottom:-3, auto_width:270 });
				y++;
			} else {
				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.CotlProtectTime+": [clr]"+Common.FormatPeriodLong((cotl.m_ProtectTime-EM.GetServerTime()) / 1000)+"[/clr]", clr:0xffffff, ax:-1, ay:1, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3+5, cs_bottom:-3, auto_width:270 });
				y++;
			}
		}*/
		
		var t:Number;
		
		while((cotl.m_CotlFlag & SpaceCotl.fPlanetShield)!=0) {
			var planetShieldEnd:Number = cotl.m_PlanetShieldEnd * 1000;
			var planetShieldCooldown:Number = cotl.m_PlanetShieldCooldown * 1000;
			var hourPlanetShield:Number = cotl.m_PlanetShieldHour;
			
			if((cotl.m_CotlFlag & SpaceCotl.fPlanetShieldOn)==0) {
				var cd:Date = EM.GetServerDate();
				t=cd.getDate();
				if(hourPlanetShield<cd.getHours()) t++;
				var cd2:Date=new Date(cd.getFullYear(),cd.getMonth(),t,hourPlanetShield,0,0,0);
	
				t=(cd2.getTime()-cd.getTime());
				var te:Number = EM.GetServerGlobalTime() + t;
//				if((EM.m_Access & Common.AccessPlusarTech) && ((EM.m_UserTechEnd>EM.GetServerTime()) || (EM.m_UserControlEnd>EM.GetServerTime()))) te+=Common.GlobalShieldSleepPeriodPlusar*60*60*1000;
//				else 
				te+=Common.GlobalShieldSleepPeriod*60*60*1000;
	
				if (planetShieldCooldown > EM.GetServerGlobalTime()) {
					t = Math.max(t, planetShieldCooldown - EM.GetServerGlobalTime());
	
					if ((EM.GetServerGlobalTime() + t) > te) {
						cd2.setTime(EM.GetServerGlobalTime() + t);
						te = cd2.getDate();
						if (hourPlanetShield < cd2.getHours()) te++;
						cd2 = new Date(cd2.getFullYear(), cd2.getMonth(), te, hourPlanetShield, 0, 0, 0);

						t = (cd2.getTime() - cd.getTime());
					}
				} 

				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.GlobalShieldFrom+": [clr]"+Common.FormatPeriod(t / 1000)+"[/clr]", clr:0xffffff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:270 });
				y++;
			} else {
				t = Math.floor((planetShieldEnd - EM.GetServerGlobalTime()) / 1000);

				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.DeactivateShieldTimeFull+": [clr]"+Common.FormatPeriod(t)+"[/clr]", clr:0xffffff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:270 });
				y++;
			}
			
			break;
		}

		while(cotl.m_CotlType==Common.CotlTypeProtect || cotl.m_CotlType==Common.CotlTypeCombat) {
			str="";
			str2="";

			if((cotl.m_TimeData & 0xffff0000)!=0) {
				if (cotl.m_RestartTime != 0 && (cotl.m_RestartTime * 1000 > EM.GetServerGlobalTime())) {
					str = Common.Txt.RestartTime + ": <font color='#ffff00'>" + Common.FormatPeriod((cotl.m_RestartTime * 1000 - EM.GetServerGlobalTime()) / 1000) + "</font>";
				} else if (cotl.m_RestartTime != 0 && ((cotl.m_RestartTime + Common.CotlRestartPeriod) * 1000 > EM.GetServerGlobalTime())) {
					str = Common.Txt.PrepareTime + ": <font color='#ffff00'>" + Common.FormatPeriod(((cotl.m_RestartTime + Common.CotlRestartPeriod) * 1000 - EM.GetServerGlobalTime()) / 1000) + "</font>";
				} else {
					u = Common.CotlProtectCalcPeriod((cotl.m_TimeData >> 16) * 60, (cotl.m_TimeData & 0xffff) * 60, EM.GetServerDate());
					if(u>=0) {
						str = Common.Txt.CotlSessionContinue + ": <font color='#ffff00'>" + Common.FormatPeriod(u).toString() + "</font>";
						str2 = Common.Txt.CotlSessionEnd + ": <font color='#ffff00'>" + Common.FormatPeriod((cotl.m_TimeData & 0xffff) * 60 - u).toString() + "</font>";
					} else {
						str = Common.Txt.CotlSessionBegin + ": <font color='#ffff00'>" + Common.FormatPeriod( -u).toString() + "</font>";
					}
				}
			} else {
				if (cotl.m_RestartTime != 0 && (cotl.m_RestartTime * 1000 > EM.GetServerGlobalTime())) {
					str = Common.Txt.RestartTime + ": <font color='#ffff00'>" + Common.FormatPeriod((cotl.m_RestartTime * 1000 - EM.GetServerGlobalTime()) / 1000) + "</font>";
				} else if (cotl.m_RestartTime != 0 && ((cotl.m_RestartTime + Common.CotlRestartPeriod) * 1000 > EM.GetServerGlobalTime())) {
					str = Common.Txt.PrepareTime + ": <font color='#ffff00'>" + Common.FormatPeriod(((cotl.m_RestartTime + Common.CotlRestartPeriod) * 1000 - EM.GetServerGlobalTime()) / 1000) + "</font>";
				}
			}

			if(str.length>0) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			if(str2.length>0) {
				ar.push({x:0, y:y, sx:3, sy:1, txt:str2, clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
			break;
		}

		if (cotl.m_BonusType0 != 0 || cotl.m_BonusType1 != 0 || cotl.m_BonusType2 != 0 || cotl.m_BonusType3 != 0) {
			// Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		} 

		for (i = 0; i < 4; i++) {
			var bt:int = 0;
			var bv:int = 0;
			if (i == 0) { bt = cotl.m_BonusType0; bv = cotl.m_BonusVal0; }
			else if (i == 1) { bt = cotl.m_BonusType1; bv = cotl.m_BonusVal1; }
			else if (i == 2) { bt = cotl.m_BonusType2; bv = cotl.m_BonusVal2; }
			else { bt = cotl.m_BonusType3; bv = cotl.m_BonusVal3; }

			if (bt == 0) continue;

			var lvl:int = 0;

			var curuni:Union = UserList.Self.GetUnion(EM.m_UnionId);

			if (true) {
				str = "";
				lvl++;
				while (true) {
					if (lvl > 1 && Common.CotlBonusValEx(bt, lvl - 1) == Common.CotlBonusValEx(bt, lvl)) break;
					bv = Common.CotlBonusValEx(bt, lvl);
					
					if (lvl > 1) str += "/";
					if (curuni != null && lvl <= curuni.m_Bonus[bt]) str += "[clr]";
					else if(curuni != null && lvl == curuni.m_Bonus[bt]+1) str += "<font color='#00ff00'>";
					
					if (bt == Common.CotlBonusShipyardSupply || bt == Common.CotlBonusSciBaseSupply) str += "-";
					else if (bv >= 0) str += "+";

					if(Common.CotlBonusProc[bt]) str+=Math.round(bv*100/256).toString();
					else str+=BaseStr.FormatBigInt(bv);
				
					if (Common.CotlBonusProc[bt]) str += "%";
					
					if (curuni != null && lvl <= curuni.m_Bonus[bt]) str += "[/clr]";
					else if(curuni != null && lvl == curuni.m_Bonus[bt]+1) str += "</font>";
					
					lvl++;
				}

				ar.push({x:0, y:y, sx:3, sy:1, txt:Common.CotlBonusName[bt]+":[br]"+str, clr:0xffffff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:270 });
				y++;
				
			} else {
				if (curuni != null) lvl = curuni.m_Bonus[bt];
				bv = Common.CotlBonusValEx(bt, lvl+1);

				if(Common.CotlBonusProc[bt]) str=Math.round(bv*100/256).toString();
				else str=BaseStr.FormatBigInt(bv);
			
				if (bt == Common.CotlBonusShipyardSupply || bt == Common.CotlBonusSciBaseSupply) str = "-" + str;
				else if (bv >= 0) str = "+" + str;

				if (Common.CotlBonusProc[bt]) str += "%";

				ar.push({x:1, y:y, sx:1, sy:1, txt:Common.CotlBonusName[bt]+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
					ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
				y++;
			}
		}

		while (true) {
			if (cotl.m_PriceCaptureType != 0 && cotl.m_PriceCaptureEgm != 0) {
				str = Common.Txt.CotlPriceEgm;

				str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(cotl.m_PriceCapture));
				str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[cotl.m_PriceCaptureType]);
				str = BaseStr.Replace(str, "<PriceEGM>", BaseStr.FormatBigInt(cotl.m_PriceCaptureEgm));

			} else if(cotl.m_PriceCaptureType != 0) {
				str = Common.Txt.CotlPrice;

				str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(cotl.m_PriceCapture));
				str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[cotl.m_PriceCaptureType]);

			} else if (cotl.m_PriceCaptureEgm != 0) {
				str = Common.Txt.CotlPrice;

				str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(cotl.m_PriceCaptureEgm));
				str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[Common.OpsPriceTypeEGM]);

			} else break;

/*			var first:Boolean = true;
			for(i=0;i<4;i++) {
				bt=0;
				bv=0;
				if(i==0) { bt=cotl.m_BonusType0; bv=cotl.m_BonusVal0; }
				else if(i==1) { bt=cotl.m_BonusType1; bv=cotl.m_BonusVal1; }
				else if(i==2) { bt=cotl.m_BonusType2; bv=cotl.m_BonusVal2; }
				else { bt=cotl.m_BonusType3; bv=cotl.m_BonusVal3; }

				if (bt == 0) continue;

				if (first) str += " ";
				else str += ", ";
				first = false;
				str += "[clr]" + Common.CotlBonusName[bt] + "[/clr]";
			}*/
		
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3+20, cs_bottom:-3, auto_width:270 });
			y++;
			
			break;
		}
		
		var user2:User;
		
		if (cotl.m_DefCnt > 0 || cotl.m_AtkCnt > 0) {
			// Space
			ar.push({x:1, y:y, sx:1, sy:1, txt:" ",  clr:0xffffff, ax:-1, ay:0, fontsize:10,						cs_left:0, cs_right:0, cs_top:-5, cs_bottom:-5 });
			y++;
		}
		
		if (cotl.m_DefCnt > 0 && (cotl.m_CotlType!=Common.CotlTypeCombat)) {
			str = Common.Txt.CotlDef + ": [clr]" + cotl.m_DefCnt.toString() + "[/clr] <font color='#808080'>(" + cotl.m_DefScoreAll.toString() + ")</font>";
			
			user2 = UserList.Self.GetUser(cotl.m_DefOwner0);
			if (user2 != null) str += ", [clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user2.m_Id) + "[/clr] <font color='#808080'>(" +cotl.m_DefScore0.toString() + ")</font>";
			user2 = UserList.Self.GetUser(cotl.m_DefOwner1);
			if (user2 != null) str += ", [clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user2.m_Id) + "[/clr] <font color='#808080'>(" +cotl.m_DefScore1.toString() + ")</font>";
			user2 = UserList.Self.GetUser(cotl.m_DefOwner2);
			if (user2 != null) str += ", [clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user2.m_Id) + "[/clr] <font color='#808080'>(" +cotl.m_DefScore2.toString() + ")</font>";

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:12,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:270 });
			y++;
		}

		if (cotl.m_AtkCnt > 0 && (cotl.m_CotlType!=Common.CotlTypeCombat)) {
			str = Common.Txt.CotlAtk + ": [clr]" + cotl.m_AtkCnt.toString()+"[/clr] <font color='#808080'>("+cotl.m_AtkScoreAll.toString()+")</font>";

			user2 = UserList.Self.GetUser(cotl.m_AtkOwner0);
			if (user2 != null) str += ", [clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user2.m_Id) + "[/clr] <font color='#808080'>(" +cotl.m_AtkScore0.toString() + ")</font>";
			user2 = UserList.Self.GetUser(cotl.m_AtkOwner1);
			if (user2 != null) str += ", [clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user2.m_Id) + "[/clr] <font color='#808080'>(" +cotl.m_AtkScore1.toString() + ")</font>";
			user2 = UserList.Self.GetUser(cotl.m_AtkOwner2);
			if (user2 != null) str += ", [clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user2.m_Id) + "[/clr] <font color='#808080'>(" +cotl.m_AtkScore2.toString() + ")</font>";

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:12,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:270 });
			y++;
		}

		if(EM.m_Debug) {
			str=((cotl.m_ServerAdr >> 0) & 255).toString();
			str+="."+((cotl.m_ServerAdr >> 8) & 255).toString();
			str+="."+((cotl.m_ServerAdr >> 16) & 255).toString();
			str+="."+((cotl.m_ServerAdr >> 24) & 255).toString();
			str+=":"+cotl.m_ServerPort.toString();
			str+=":"+cotl.m_ServerNum.toString();

			ar.push({x:0, y:y, sx:3, sy:1, txt:"CotlId: <font color='#ffff00'>"+cotl.m_Id.toString()+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			ar.push({x:0, y:y, sx:3, sy:1, txt:"ServerAdr: <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			ar.push({x:0, y:y, sx:3, sy:1, txt:"ServerMode: <font color='#ffff00'>"+cotl.m_ServerMode.toString()+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;

//			ar.push({x:1, y:y, sx:1, sy:1, txt:"ServerMode:",  clr:0xffffff, ax:-1, ay:0, fontsize:14,							cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
//				ar.push({x:2, y:y, sx:1, sy:1, txt:cotl.m_ServerMode.toString(), clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
//			y++;
		}		

		BuildGrid(ar);
		
		//var sx:int=EM.m_Hyperspace.WorldToMapX(cotl.m_X);
		//var sy:int=EM.m_Hyperspace.WorldToMapY(cotl.m_Y);
		
		r=Math.ceil(r*0.7);

		Prepare(sx-r,sy-r,sx+r,sy+r);
	}

/*	public function ShowCotlRadar(sx:int, sy:int, cotlid:uint, cotltype:int, cotlaccountid:uint, cotlunionid:uint, zonelvl:int, 
		bt0:int, bv0:int, bt1:int, bv1:int, bt2:int, bv2:int, bt3:int, bv3:int,
		price_enter_type:int, price_enter:int, price_capture_type:int, price_capture:int, price_capture_egm:int,
		protect_time:Number
		):void
	{
		var i:int;
		var user:User;
		var uni:Union;
		var ar:Array=new Array();
		var y:int=0;
		var str:String;

		user=null;
		if(cotltype==Common.CotlTypeUser) user=UserList.Self.GetUser(cotlaccountid);
//		if(cotlunionid) uni=UserList.Self.GetUnion(cotlunionid);

		uni=null;
		if(cotltype==Common.CotlTypeUser) {
			if(user!=null && user.m_UnionId) uni=UserList.Self.GetUnion(user.m_UnionId);
		} else if(cotlunionid!=0) {
			uni=UserList.Self.GetUnion(cotlunionid);
		}

//		str=EM.Txt_CotlName(cotlid);
//		if(cotltype==Common.CotlTypeRich) {
//			str=Common.Txt.CotlRich+" "+str;
//		}
//		if(str=='' && cotltype==Common.CotlTypeUser) {
//			str=Common.Txt.CotlUser;
//			if(user!=null) str+=" "+user.m_Name;
//		}
//		if(str=='') str='-';

		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:EM.CotlName(cotlid,true), clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		str=EM.Txt_CotlDesc(cotlid);
		if(str.length>0) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3+6 });
			y++;
		}

		if(uni!=null) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:uni.NameUnion()+" "+uni.m_Name, clr:0x00b7ff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-2, cs_bottom:-2 });
			y++;
		}

		while(cotltype==Common.CotlTypeUser) {
			if(user==null) break;

			str=user.m_Rating.toString();

			if(zonelvl!=0 && !EM.TestRatingFlyCotl(cotlaccountid,zonelvl)) str="<font color='#ff0000'>"+str+"</font>";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.UserRating+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
			break;
		}

		if (protect_time > EM.GetServerTime()) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.CotlProtectTime+": [clr]"+Common.FormatPeriod((protect_time-EM.GetServerTime()) / 1000)+"[/clr]", clr:0xffffff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3, auto_width:270 });
			y++;
		}
		
		for(i=0;i<4;i++) {
			var bt:int=0;
			var bv:int=0;
			if(i==0) { bt=bt0; bv=bv0; }
			else if(i==1) { bt=bt1; bv=bv1; }
			else if(i==2) { bt=bt2; bv=bv2; }
			else { bt=bt3; bv=bv3; }

			if(bt==0) continue;

			if(Common.CotlBonusProc[bt]) str=Math.round(bv*100/256).toString();
			else str=BaseStr.FormatBigInt(bv);
			
			if (bt == Common.CotlBonusShipyardSupply || bt == Common.CotlBonusSciBaseSupply) str = "-" + str;
			else if (bv >= 0) str = "+" + str;

			if (Common.CotlBonusProc[bt]) str += "%";

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.CotlBonusName[bt]+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,					cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		while (true) {
			if (price_capture_type != 0 && price_capture_egm != 0) {
				str = Common.Txt.CotlPriceEgm;

				str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(price_capture));
				str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[price_capture_type]);
				str = BaseStr.Replace(str, "<PriceEGM>", BaseStr.FormatBigInt(price_capture_egm));

			} else if(price_capture_type != 0) {
				str = Common.Txt.CotlPrice;

				str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(price_capture));
				str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[price_capture_type]);

			} else if (price_capture_egm != 0) {
				str = Common.Txt.CotlPrice;

				str = BaseStr.Replace(str, "<Price>", BaseStr.FormatBigInt(price_capture_egm));
				str = BaseStr.Replace(str, "<Val>", Common.OpsPriceTypeName2[Common.OpsPriceTypeEGM]);

			} else break;
			
			var first:Boolean = true;
			for(i=0;i<4;i++) {
				var bt:int=0;
				var bv:int=0;
				if(i==0) { bt=bt0; bv=bv0; }
				else if(i==1) { bt=bt1; bv=bv1; }
				else if(i==2) { bt=bt2; bv=bv2; }
				else { bt=bt3; bv=bv3; }

				if (bt == 0) continue;
				
				if (first) str += " ";
				else str += ", ";
				first = false;
				str += "[clr]" + Common.CotlBonusName[bt] + "[/clr]";
			}

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffffff, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3+20, cs_bottom:-3, auto_width:270 });
			y++;
			
			break;
		}

		BuildGrid(ar);

		Prepare(sx-5,sy-5,sx+5,sy+5);
	}*/

	public function ShowHyperspaceZone(sx:int, sy:int, zonelvl:int):void
	{
		var str:String;
		var ar:Array = new Array();

		var user:User=UserList.Self.GetUser(Server.Self.m_UserId,false);

		if (1) {
			if (zonelvl == 0) str = Common.Txt.Zone0;
			else if (zonelvl == 1) str = Common.Txt.Zone1;
			else if (zonelvl == 2) str = Common.Txt.Zone2;
			else if (zonelvl == 3) str = Common.Txt.Zone3;
			else str = "Unknow";
			
			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		
		if (1) {
			if (zonelvl == 0) str = "250%";
			else if (zonelvl == 1) str = "200%";
			else if (zonelvl == 2) str = "150%";
			else if (zonelvl == 3) str = "100%";
			else str = "Unknow";
			
			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.Txt.ZoneModuleMul+":",  clr:0xffffff, ax:1, ay:0, fontsize:14,		cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push({x:2, y:y, sx:1, sy:1, txt:str, clr:0xffff00, ax: 1, ay:0, fontsize:14,								cs_left:20, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if (user != null) {
			str = Common.Txt.ZoneRatingRangeAny;

			if(zonelvl!=0) {
				var proc:Number=0;
				if(zonelvl==1) proc=(100/3)/100;
				else if(zonelvl==2) proc=(100/5)/100;
				else proc = (100 / 11) / 100;

				var r:Number = user.m_Rating;

				var rmin:int = Math.floor((r * 2 - r * (1 + proc)) / (1 + proc));
				var rmax:int = Math.floor((r + r * proc) / (2 - 1 - proc));

				str = Common.Txt.ZoneRatingRange;
				str = BaseStr.Replace(str, "<Min>", rmin.toString());
				str = BaseStr.Replace(str, "<Max>", rmax.toString());
			}

			ar.push({x:0, y:y, sx:3, sy:1, txt:str, clr:0xD0D0D0, ax:-1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top:-3+10, cs_bottom:-3, auto_width:200 });
			y++;
		}

		BuildGrid(ar);

		Prepare(sx-5,sy-5,sx+5,sy+5);
	}
	
	public function ShowItemBonus(no:int, px:int, py:int, sx:int, sy:int):void
	{
		var i:int, u:int;
		var str:String;
		var ar:Array = new Array();
		var y:int=0;
		
		var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (user == null) return;
		
		var itype:uint;
		var idate:Number;
		
		if (no == 1) {
			itype = user.m_IB1_Type;
			idate = user.m_IB1_Date;
		} else {
			itype = user.m_IB2_Type;
			idate = user.m_IB2_Date;
		}
		if (itype==0) return;

		var idesc:Item = UserList.Self.GetItem(itype & 0x7fff);
		if (idesc == null) return;

		if(1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:EM.ItemName(itype&0xffff7fff), clr:0xffff00, ax:-1, ay:0, fontsize:16,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}

		if(1) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:EM.Txt_ItemDesc(itype & 0x7fff), clr:0xD0D0D0, ax: -1, ay:0, fontsize:13,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 + 6, auto_width:200 } );
			y++;
		}

		for (i = 0; i < 4; i++) {
			if (idesc.m_BonusType[i] == 0) continue;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ItemBonusName[idesc.m_BonusType[i]]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:"+" + Math.round(idesc.m_BonusVal[i] * 100.0 / 256.0).toString() + "%", clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}
		for (i = 0; i < 4; i++) {
			u = (itype >> (16 + i * 4)) & 15;
			if (u == 0) continue;
			if (idesc.m_BonusType[u] == 0) continue;

			ar.push({x:1, y:y, sx:1, sy:1, txt:Common.ItemBonusName[idesc.m_BonusType[u]]+":",  clr:0xffffff, ax:-1, ay:0, fontsize:14,						cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
				ar.push( { x:2, y:y, sx:1, sy:1, txt:"+" + Math.round(idesc.m_BonusVal[u] * 100.0 / 256.0).toString() + "%", clr:0xffff00, ax: 1, ay:0, fontsize:14,							cs_left:20, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		if (true) {
			if ((itype & 0x8000) != 0) str = Common.FormatPeriod((idate-EM.GetServerGlobalTime()) / 1000);
			else str = Common.FormatPeriod((idate) / 1000);
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.ItemBonusEndTime+": <font color='#ffff00'>"+str+"</font>", clr:0xffffff, ax:-1, ay:1, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3+10, cs_bottom:-3 });
			y++;
		}

		BuildGrid(ar);

		Prepare(px, py, px + sx, py + sy);
	}
	
	public function ShowSearchCombat():void
	{
		var i:int, u:int;
		var str:String;
		var ar:Array = new Array();
		var y:int = 0;
		
		m_HintNew = !visible;
		Hide();

		if (!EmpireMap.Self.m_FormBattleBar.m_Search) return;

		if (1) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.FormBattleWaitCnt+": <font color='#ffff00'>"+EmpireMap.Self.m_FormBattleBar.m_WaitCnt.toString()+"</font>", clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		if (EmpireMap.Self.m_FormBattleBar.m_WaitCnt < (EmpireMap.Self.m_FormBattleBar.m_Set_PlayerCnt * 2 * 2)) {
			ar.push({x:0, y:y, sx:3, sy:1, txt:Common.Txt.FormBattleWaitNeedCnt, clr:0xffffff, ax:-1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top:-3, cs_bottom:-3 });
			y++;
		}
		if (EmpireMap.Self.m_FormBattleBar.m_WaitEnd > EmpireMap.Self.GetServerGlobalTime()) {
			ar.push( { x:0, y:y, sx:3, sy:1, txt:Common.Txt.FormBattleWaitEnd + ": <font color='#ffff00'>" + Common.FormatPeriodLong((EmpireMap.Self.m_FormBattleBar.m_WaitEnd - EmpireMap.Self.GetServerGlobalTime()) / 1000) + "</font>", clr:0xffffff, ax: -1, ay:0, fontsize:14,			cs_left:0, cs_right:0, cs_top: -3, cs_bottom: -3 } );
			y++;
		}

		BuildGrid(ar);
		
		Prepare(EmpireMap.Self.m_FormBattleBar.x, EmpireMap.Self.m_FormBattleBar.y, EmpireMap.Self.m_FormBattleBar.x + 1, EmpireMap.Self.m_FormBattleBar.y + 35,1);
	}

	public function ShowSearchCombatLive():void
	{
		if(m_ShowType==TypeSearchCombat) {
			return;
		}

		Hide();
		m_ShowType = TypeSearchCombat;
		
		LiveUpdate();
	}
	
	public function ShowItemBonusLive(no:int, px:int, py:int, sx:int, sy:int):void
	{
		if(m_ShowType==TypeItemBonus) {
			if (m_CfgIB_No == no) return;
		}

		Hide();
		m_ShowType = TypeItemBonus;
		m_CfgIB_No = no;
		m_Cfg_PX = px;
		m_Cfg_PY = py;
		m_Cfg_SX = sx;
		m_Cfg_SY = sy;
		
		LiveUpdate();
	}

	public function ShowPlanetLive(secx:int, secy:int, planetnum:int):void
	{
		if(m_ShowType==TypePlanet) {
			if (m_Cfg_SectorX == secx && m_Cfg_SectorY == secy && m_Cfg_PlanetNum == planetnum) return;
		}

		m_HintNew = true;

		Hide();
		m_ShowType = TypePlanet;
		m_Cfg_SectorX = secx;
		m_Cfg_SectorY = secy;
		m_Cfg_PlanetNum = planetnum;

		LiveUpdate();
	}

	public function ShowShipLive(secx:int, secy:int, planetnum:int, shipnum:int):void
	{
		if(m_ShowType==TypeShip) {
			if (m_Cfg_SectorX == secx && m_Cfg_SectorY == secy && m_Cfg_PlanetNum == planetnum && m_Cfg_ShipNum == shipnum) return;
		}

		m_HintNew = true;

		Hide();
		m_ShowType = TypeShip;
		m_Cfg_SectorX = secx;
		m_Cfg_SectorY = secy;
		m_Cfg_PlanetNum = planetnum;
		m_Cfg_ShipNum = shipnum;
		
		LiveUpdate();
	}
	
	public function ShowCotlLive(planet:SpacePlanet, cotl:SpaceCotl, px:int, py:int, r:int, zonelvl:int=-1):void
	{
		if (planet == null && cotl == null) return;
		while(m_ShowType==TypeCotl) {
			if (m_Cfg_Cotl != null && cotl == null) break;
			if (m_Cfg_Cotl == null && cotl != null) break;
			if (m_Cfg_Cotl.m_Id != cotl.m_Id) break;
			if (m_Cfg_Planet != null && planet == null) break;
			if (m_Cfg_Planet == null && planet != null) break;
			if (m_Cfg_Planet == null || planet == null) return;
			if (m_Cfg_Planet.m_Id != planet.m_Id) break;
			return;
		}
//trace("ShowCotlLive", cotl.m_Id, (planet == null)?( -1):(planet.m_Id));

		m_HintNew = true;

		Hide();
		m_ShowType = TypeCotl;
		m_Cfg_Planet = planet;
		m_Cfg_Cotl = cotl;
		m_Cfg_PX = px;
		m_Cfg_PY = py;
		m_Cfg_SX = r;
		m_Cfg_SY = r;
		m_Cfg_Tmp = zonelvl;

		LiveUpdate();
	}

	private function LiveUpdate(event:Event=null):void
	{
		var savexy:Boolean = visible;

		var st:int = m_ShowType;
		Hide(false);
		
		var tx:int = x;
		var ty:int = y;

		if (st == TypeItemBonus) {
			ShowItemBonus(m_CfgIB_No, m_Cfg_PX, m_Cfg_PY, m_Cfg_SX, m_Cfg_SY);
		} else if (st == TypeShip) {
			ShowShip(m_Cfg_SectorX, m_Cfg_SectorY, m_Cfg_PlanetNum, m_Cfg_ShipNum);
		} else if (st == TypeCotl) {
			ShowCotl(m_Cfg_Planet,m_Cfg_Cotl, m_Cfg_PX, m_Cfg_PY, m_Cfg_SX, m_Cfg_Tmp);
		} else if (st == TypePlanet) {
			ShowPlanet(m_Cfg_SectorX, m_Cfg_SectorY, m_Cfg_PlanetNum);
		} else if (st == TypeSearchCombat) {
			ShowSearchCombat();
		}

		if (visible) {
			m_ShowType = st;
			if (!m_TimeLive.running) m_TimeLive.start();
			if(savexy) {
				x = tx;
				y = ty;
			}
		} else {
			visible = true;
			Hide();
		}
	}
	
	public function Update():void
	{
		if (visible && (m_ShowType != 0)) LiveUpdate();
	}
}

}
