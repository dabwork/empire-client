// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{

import flash.display.*;
import flash.display3D.textures.Texture;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;
import flash.display3D.*;

public class HyperspaceCotl// extends Sprite
{
//	private var m_Map:EmpireMap=null;
	
	public var m_CotlId:int=0;
	public var m_Type:uint = 0;
	public var m_Size:int = 0;
	public var m_AccountId:uint=0;
	public var m_UnionId:uint=0;

	//public var m_Icon:Bitmap=null;
	//public var m_Name:TextField=null;
	//public var m_Rating:TextField=null;
	//public var m_ExitDateTxt:TextField=null;

	public var m_Tmp:int=0;

	//public var m_BG:Sprite=null;
	//public var m_BGSel:Sprite=null;

	public var m_ZoneX:Number = 0;
	public var m_ZoneY:Number = 0;
	public var m_X:Number = 0;
	public var m_Y:Number = 0;
	public var m_Z:Number = 0;
	public var m_Radius:int=0;

	public var m_Sel:Boolean = false;
	
	public var m_InDraw:Boolean = false;
	
	static public var m_PEmptyFirst:HyperspaceCotlParticle = null;
	static public var m_PEmptyLast:HyperspaceCotlParticle = null;

	public var m_PFirst:HyperspaceCotlParticle = null;
	public var m_PLast:HyperspaceCotlParticle = null;

	public var m_QuadBatch:C3DQuadBatch = new C3DQuadBatch();
	public var m_TextLine:C3DTextLine = new C3DTextLine();
	
	public var m_Time:Number = 0;
	
	public function HyperspaceCotl()
	{
//		m_Map=map;

//		m_Map.m_Hyperspace.m_CotlList.push(this);

		m_TextLine.SetFont("big");
		m_TextLine.SetColor(0xff000000);
		m_TextLine.SetFormat(0);

//		m_BG = null;
		
//		m_BGSel=new GraphCotlSel();
//		m_BGSel.visible=false;
//		addChild(m_BGSel);
		
//		m_Name=new TextField();
//		m_Name.width=1;
//		m_Name.height=1;
//		m_Name.type=TextFieldType.DYNAMIC;
//		m_Name.selectable=false;
//		m_Name.textColor=0x753d13;
//		m_Name.background=false;
//		m_Name.backgroundColor=0x80000000;
//		m_Name.alpha=1.0;
//		m_Name.multiline=false;
//		m_Name.autoSize=TextFieldAutoSize.LEFT;
//		m_Name.gridFitType=GridFitType.NONE;
//		m_Name.defaultTextFormat=new TextFormat("Calibri",14,0x012e4d/*0x753d13*/);
//		m_Name.embedFonts=true;
//		m_Name.visible=false;
//		addChild(m_Name);

//		m_Rating=new TextField();
//		m_Rating.width=1;
//		m_Rating.height=1;
//		m_Rating.type=TextFieldType.DYNAMIC;
//		m_Rating.selectable=false;
//		m_Rating.textColor=0x753d13;
//		m_Rating.background=false;
//		m_Rating.backgroundColor=0x80000000;
//		m_Rating.alpha=1.0;
//		m_Rating.multiline=false;
//		m_Rating.autoSize=TextFieldAutoSize.LEFT;
//		m_Rating.gridFitType=GridFitType.NONE;
//		m_Rating.defaultTextFormat=new TextFormat("Calibri",12,0x012e4d/*0x753d13*/);
//		m_Rating.embedFonts=true;
//		m_Rating.visible=false;
//		addChild(m_Rating);

//		m_ExitDateTxt=new TextField();
//		m_ExitDateTxt.width=1;
//		m_ExitDateTxt.height=1;
//		m_ExitDateTxt.type=TextFieldType.DYNAMIC;
//		m_ExitDateTxt.selectable=false;
//		m_ExitDateTxt.textColor=0xffffff;
//		m_ExitDateTxt.background=true;
//		m_ExitDateTxt.backgroundColor=0x80404000;
//		m_ExitDateTxt.alpha=1.0;
//		m_ExitDateTxt.multiline=false;
//		m_ExitDateTxt.autoSize=TextFieldAutoSize.LEFT;
//		m_ExitDateTxt.gridFitType=GridFitType.NONE;
//		m_ExitDateTxt.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
//		m_ExitDateTxt.embedFonts=true;
//		m_ExitDateTxt.visible=false;
//		addChild(m_ExitDateTxt);

		//mouseEnabled=false;
		//mouseChildren=false;
	}
	
	public function Clear():void
	{
//		var i:int = m_Map.m_Hyperspace.m_CotlList.indexOf(this);
//		if (i >= 0) m_Map.m_Hyperspace.m_CotlList.splice(i, 1);

		while (m_PFirst) PDel(m_PLast);

		m_TextLine.free();
		m_QuadBatch.free();
	}
	
	public function PAdd():HyperspaceCotlParticle 
	{
		var p:HyperspaceCotlParticle = m_PEmptyFirst;
		if (p != null) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_PEmptyLast == p) m_PEmptyLast = HyperspaceCotlParticle(p.m_Prev);
			if (m_PEmptyFirst == p) m_PEmptyFirst = HyperspaceCotlParticle(p.m_Next);
		} else {
			p = new HyperspaceCotlParticle();
		}
		if (m_PLast != null) m_PLast.m_Next = p;
		p.m_Prev = m_PLast;
		p.m_Next = null;
		m_PLast = p;
		if (m_PFirst == null) m_PFirst = p;
		return p;
	}

	public function PDel(p:HyperspaceCotlParticle):void
	{
		if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
		if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
		if (m_PLast == p) m_PLast = HyperspaceCotlParticle(p.m_Prev);
		if (m_PFirst == p) m_PFirst = HyperspaceCotlParticle(p.m_Next);

		p.Clear();

		if (m_PEmptyLast != null) m_PEmptyLast.m_Next = p;
		p.m_Prev = m_PEmptyLast;
		p.m_Next = null;
		m_PEmptyLast = p;
		if (m_PEmptyFirst == null) m_PEmptyFirst = p;
	}
	
/*	public function SetType(v:int):void
	{
		if (m_Type == v) return;
		m_Type = v;
		
//		if (m_BG) {
//			removeChild(m_BG);
//			m_BG = null;
//		}
		
		m_Map.m_Hyperspace.m_CotlLayer.removeChild(this);
		
		if (m_Type == Common.CotlTypeCombat) {
//			m_BG=new GraphCotlBG2();
//			addChildAt(m_BG,0);
			m_Map.m_Hyperspace.m_CotlLayer.addChild(this);
//			m_Name.defaultTextFormat=new TextFormat("Calibri",14,0x430000);
		} else {
//			m_BG=new GraphCotlBG1();
//			m_BG.blendMode=BlendMode.DIFFERENCE;
//			addChildAt(m_BG,0);
			m_Map.m_Hyperspace.m_CotlLayer.addChildAt(this, 0);
//			m_Name.defaultTextFormat=new TextFormat("Calibri",14,0x012e4d);// 0x753d13
		}
	}*/
	
	public function SetText(str:String):void
	{
		m_TextLine.SetText(str);
//		if (str == null) str = '';
//		m_TextLine.SetText(str);
//		if(m_Name.text==str) return;
//		m_Name.text=str;
//		m_Name.visible=str.length>0;
	}

//	public function SetRating(str:String):void
//	{
//		if(str==null) str='';
//		if(m_Rating.text==str) return;
//		m_Rating.htmlText=str;
//		m_Rating.visible=str.length>0;
//	}

//	public function SetExitDate(str:String):void
//	{
//		if(str==null) str='';
//		if(m_ExitDateTxt.text==str) return;
//		m_ExitDateTxt.htmlText=str;
//		m_ExitDateTxt.visible=str.length>0;
//	}
	
	public function SetIcon(d:BitmapData):void
	{
		if(d==null) {
//			if(m_Icon!=null) {
//				removeChild(m_Icon);
//				m_Icon=null;
//			}
		} else {
//			if(m_Icon==null) {
//				m_Icon=new Bitmap();
//				//m_Icon.pixelSnapping=PixelSnapping.NEVER;
//				//m_Icon.smoothing=true;
//				//m_Icon.scaleX=0.9; 
//				//m_Icon.scaleY=0.9;
//				addChild(m_Icon);
//			}
//			m_Icon.bitmapData=d;
		}
	}

	public function Update(scotl:SpaceCotl):void
	{
		m_ZoneX = scotl.m_ZoneX;
		m_ZoneY = scotl.m_ZoneY;
		m_X = scotl.m_PosX;
		m_Y = scotl.m_PosY;
		m_Z = scotl.m_PosZ;
		m_Type = scotl.m_CotlType;
		m_Size = scotl.m_CotlSize;
		m_AccountId = scotl.m_AccountId;
		m_UnionId = scotl.m_UnionId;

		m_Radius=Space.EmpireCotlSizeToRadius(m_Size);

//		var cotl:Cotl=m_Map.m_FormGalaxy.GetCotl(m_CotlId);
//		if(cotl==null) return;

//		x = m_Map.m_Hyperspace.WorldToMapX(cotl.m_X);
//		y = m_Map.m_Hyperspace.WorldToMapY(cotl.m_Y);

//		var sc:Number=(m_Radius*2.0)/200.0;
//		if (m_BG != null) {
//			m_BG.scaleX = sc;
//			m_BG.scaleY = sc;
//		}

		//m_BG.x=-(m_BG.width>>1);
		//m_BG.y=-(m_BG.height>>1);
		//m_BG.alpha=1.0;
		//m_BG.blendMode=BlendMode.MULTIPLY;

//		m_BGSel.visible=m_Sel;
//		m_BGSel.alpha=0.5;
//		m_BGSel.scaleX=sc;
//		m_BGSel.scaleY=sc;

		//if(m_BGSel.visible) {
		//	m_BGSel.x=-(m_BGSel.width>>1);
		//	m_BGSel.y=-(m_BGSel.height>>1);
		//}
//		if(m_Name.visible) {
//			m_Name.x=-(m_Name.width>>1);
//			m_Name.y=-(m_Name.height>>1);
//		}
//		if(m_Rating.visible) {
//			m_Rating.x=-(m_Rating.width>>1);
//			m_Rating.y=m_Name.y+m_Name.height;
//		}
//		if(m_ExitDateTxt.visible) {
//			m_ExitDateTxt.x=Math.sin(-Math.PI*0.75)*m_Radius-(m_ExitDateTxt.width>>1);
//			m_ExitDateTxt.y=Math.cos(-Math.PI*0.75)*m_Radius-(m_ExitDateTxt.height>>1);
//		}
//		if(m_Icon!=null) {
//			if(m_Name.visible) {
//				m_Icon.visible=true;
//				m_Icon.x=m_Name.x-m_Icon.width-5;
//				m_Icon.y=m_Name.y+(m_Name.height>>1)-(m_Icon.height>>1);
//			} else if(!m_Name.visible) {
//				m_Icon.visible=false;
//			}
//		} 
	}
	
	public function PInit():void
	{
return;
		var p:HyperspaceCotlParticle, pstart:HyperspaceCotlParticle;
		var px:Number, py:Number, pz:Number, kx:Number, ky:Number, kz:Number, r:Number, a:Number, a2:Number, minr:Number, maxr:Number, v:Number;
		var i:int, u:int, cnt:int;

		var rnd:PRnd = new PRnd();
		rnd.Set(m_CotlId);
		rnd.RndEx();
		rnd.RndEx();
		
		while (m_PFirst) PDel(m_PLast);

		// Center star
		p = PAdd();
		p.m_Flag |= C3DParticle.FlagShow;
		p.m_Type = 1;
		p.m_PlaceX = 0.0;
		p.m_PlaceY = 0.0;
		p.m_PlaceZ = 0.0;
		p.m_Size = 200.0;
		p.m_U1 = 0.0; p.m_V1 = 0.0;
		p.m_U2 = 0.5; p.m_V2 = 0.5;
		p.m_Color = 0xffffffff;//0x4fffffff;
		p.m_ColorTo = p.m_Color;
		
		var cntbig:int = 3;
		var cntsmall:int = 80;// 50;
		
		// Blue Gigant
		for (i = 0; i < cntbig; i++) {
			while(true) {
				r = rnd.RndFloat(0.6, 0.9);
				r *= 300;
				a = rnd.RndFloat( -Math.PI * 0.25, Math.PI * 0.25);

				a2 = rnd.RndFloat( -Math.PI, Math.PI);
				
				px = r * Math.cos(a) * Math.sin(a2);
				py = r * Math.cos(a) * Math.cos(a2);
				pz = r * Math.sin(a);
				
//				px = r * Math.sin(a);
//				py = r * Math.cos(a);
//				pz = rnd.RndFloat( -100, -200);
				
				minr = 150.0;
				maxr = 200.0;
				minr *= minr;
				maxr *= maxr;
				
//				if (i <= 2) {
//					if ((px * px + py * py + pz * pz) < mr) break;
//				}

				r = 1000000000.0;
				p = m_PFirst;
				while (p != null) {
					v = ((p.m_PlaceX - px) * (p.m_PlaceX - px) + (p.m_PlaceY - py) * (p.m_PlaceY - py) + (p.m_PlaceZ - pz) * (p.m_PlaceZ - pz));
					if (v < minr) break;
					if (v < r) r = v;
					p = HyperspaceCotlParticle(p.m_Next);
				}
				if (p == null) break;
			}
			
			p = PAdd();
			p.m_Flag |= C3DParticle.FlagShow;
			p.m_Type = 1;
			p.m_PlaceX = px;
			p.m_PlaceY = py;
			p.m_PlaceZ = pz;
			p.m_Size = rnd.RndFloat(100, 200);
			p.m_U1 = 0.0; p.m_V1 = 0.0;
			p.m_U2 = 0.5; p.m_V2 = 0.5;
			p.m_Color = 0xffffffff;
			p.m_ColorTo = p.m_Color;
		}

		// star field
		pstart = m_PLast;
		for (i = 0; i < 3; i++) {
			if (i == 0) cnt = 20;
			else if (i == 1) cnt = 15;
			else if (i == 2) cnt = 10;
			for (u = 0; u < cnt; u++) {
				while(true) {
					//a = (u / cnt) * 2.0 * Math.PI;
					r = 100.0 + i * 50.0;
					
					a = rnd.RndFloat( -Math.PI * 0.5, Math.PI * 0.5);
					a2 = rnd.RndFloat( -Math.PI, Math.PI);
					if (i == 1) { a *= 0.5; a2 = Math.PI * 2.0 * (u / cnt); }
					else if (i == 2) { a *= 0.25; a2 = Math.PI * 2.0 * (u / cnt); }
					
					px = r * Math.cos(a) * Math.sin(a2);
					py = r * Math.cos(a) * Math.cos(a2);
					pz = r * Math.sin(a);
					
					minr = 5.0;
					maxr = 200.0;
					minr *= minr;
					maxr *= maxr;

					//r = 1000000000.0;
					p = HyperspaceCotlParticle(pstart.m_Next);
					while (p != null) {
						v = ((p.m_PlaceX - px) * (p.m_PlaceX - px) + (p.m_PlaceY - py) * (p.m_PlaceY - py) + (p.m_PlaceZ - pz) * (p.m_PlaceZ - pz));
						if (v < minr) break;
						//if (v < r) r = v;
						p = HyperspaceCotlParticle(p.m_Next);
					}
					//if (r > maxr) continue;
					if (p == null) break;
				}

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagShow;
				p.m_Type = 1;
				p.m_PlaceX = px;
				p.m_PlaceY = py;
				p.m_PlaceZ = pz;
				p.m_Size = 250;// rnd.RndFloat(300, 400);
				p.m_U1 = 0.75; p.m_V1 = 0.75;
				p.m_U2 = 1.0; p.m_V2 = 1.0;
				p.m_Color = 0xffffffff;//0x8fffffff;
				p.m_ColorTo = p.m_Color;
			}
		}

/*		for (i = 0; i < (cntbig + cntsmall); i++) {
			while(true) {
				if (i < cntbig) r = rnd.RndFloat(0.6, 0.9);
				else {
					r = rnd.RndFloat(0.0, 0.5);
					r = r * r;// * r * r;
					r = 0.15 + r * 0.85;
				}
				r *= 700;
				
				if (i < cntbig) a = rnd.RndFloat( -Math.PI * 0.25, Math.PI * 0.25);
				else a = rnd.RndFloat( -Math.PI * 0.5, Math.PI * 0.5);
				
				a2 = rnd.RndFloat( -Math.PI, Math.PI);
				
				px = r * Math.cos(a) * Math.sin(a2);
				py = r * Math.cos(a) * Math.cos(a2);
				pz = r * Math.sin(a);
				
//				px = r * Math.sin(a);
//				py = r * Math.cos(a);
//				pz = rnd.RndFloat( -100, -200);
				
				minr = 5.0;
				maxr = 200.0;
				if (i < cntbig) minr = 150.0;
				minr *= minr;
				maxr *= maxr;
				
//				if (i <= 2) {
//					if ((px * px + py * py + pz * pz) < mr) break;
//				}

				r = 1000000000.0;
				p = m_PFirst;
				while (p != null) {
					v = ((p.m_PlaceX - px) * (p.m_PlaceX - px) + (p.m_PlaceY - py) * (p.m_PlaceY - py) + (p.m_PlaceZ - pz) * (p.m_PlaceZ - pz));
					if (v < minr) break;
					if (v < r) r = v;
					p = HyperspaceCotlParticle(p.m_Next);
				}
				if ((i >= cntbig) && (r > maxr)) continue;
				if (p == null) break;
			}

			p = PAdd();
			p.m_Flag |= C3DParticle.FlagShow;
			p.m_Type = 1;
			p.m_PlaceX = px;
			p.m_PlaceY = py;
			p.m_PlaceZ = pz;
			if (i < cntbig) { // Blue Gigant
				p.m_Size = rnd.RndFloat(300, 400);
				p.m_U1 = 0.0; p.m_V1 = 0.0;
				p.m_U2 = 0.5; p.m_V2 = 0.5;
				p.m_Color = 0xffffffff;
				p.m_ColorTo = p.m_Color;
			} else { // Other
				p.m_Size = 250;// rnd.RndFloat(300, 400);
//				p.m_U1 = 0.5; p.m_V1 = 0.0;
//				p.m_U2 = 1.0; p.m_V2 = 0.5;
//				p.m_U1 = 0.5; p.m_V1 = 0.5;
//				p.m_U2 = 1.0; p.m_V2 = 1.0;

//				p.m_U1 = 0.5; p.m_V1 = 0.0;
//				p.m_U2 = 1.0; p.m_V2 = 0.5;

				p.m_U1 = 0.75; p.m_V1 = 0.75;
				p.m_U2 = 1.0; p.m_V2 = 1.0;
				p.m_Color = 0xffffffff;//0x8fffffff;
				p.m_ColorTo = p.m_Color;
			}
		}*/
	}

	public function PTakt(ms:Number):void
	{
return;
/*		var p:HyperspaceCotlParticle, pnext:HyperspaceCotlParticle;
		var size:Number;

		var mv:Matrix3D = EmpireMap.Self.m_Hyperspace.m_MatViewInv;
		var dx:Number = mv.rawData[1 * 4 + 0];
		var dy:Number = mv.rawData[1 * 4 + 1];
		var dz:Number = mv.rawData[1 * 4 + 2];

		var nx:Number = mv.rawData[2 * 4 + 0];
		var ny:Number = mv.rawData[2 * 4 + 1];
		var nz:Number = mv.rawData[2 * 4 + 2];

//		var offx:Number = m_X - (m_Map.m_Hyperspace.m_CamPos.x + m_Map.m_Hyperspace.m_ZoneSize * ( m_Map.m_Hyperspace.m_CamZoneX));
//		var offy:Number = m_Y - (m_Map.m_Hyperspace.m_CamPos.y + m_Map.m_Hyperspace.m_ZoneSize * ( m_Map.m_Hyperspace.m_CamZoneY));
//		var offz:Number = -700.0 - (m_Map.m_Hyperspace.m_CamPos.z);

		var offx:Number = m_X - m_Map.m_Hyperspace.m_CamPos.x + m_Map.m_Hyperspace.m_ZoneSize * (m_ZoneX - m_Map.m_Hyperspace.m_CamZoneX);
		var offy:Number = m_Y - m_Map.m_Hyperspace.m_CamPos.y + m_Map.m_Hyperspace.m_ZoneSize * (m_ZoneY - m_Map.m_Hyperspace.m_CamZoneY);
		var offz:Number = m_Z - (m_Map.m_Hyperspace.m_CamPos.z);

		m_Time += ms;
		var a:Number = m_Time * 0.00005;
		var sa:Number = Math.sin(a);
		var ca:Number = Math.cos(a);
		
		var cnt:int = 0;
		pnext = m_PFirst;
		while (pnext != null) {
			p = pnext;
			pnext = HyperspaceCotlParticle(pnext.m_Next);
			
			p.m_TTL += ms;
			if (p.m_Life != 0 && p.m_TTL >= p.m_Life) {
				PDel(p);
				continue;
			}

			size = p.m_Size;

			p.m_PosX = offx + p.m_PlaceX * ca - p.m_PlaceY * sa - dx * size * 0.5;
			p.m_PosY = offy + p.m_PlaceX * sa + p.m_PlaceY * ca - dy * size * 0.5;
			p.m_PosZ = offz + p.m_PlaceZ - dz * size * 0.5;
			p.m_NormalX = nx;
			p.m_NormalY = ny;
			p.m_NormalZ = nz;
			p.m_DirX = dx;
			p.m_DirY = dy;
			p.m_DirZ = dz;
			
			//p.m_DirX = -sa;
			//p.m_DirY = ca;
			//p.m_DirZ = 0.0;
			
			p.m_Width = size;
			p.m_Height = size;
			//p.m_Color = 0xffffffff;
			//p.m_ColorTo = p.m_Color;

			cnt++;
		}*/
	}
	
	public function PDraw():void
	{
return;
/*		if (m_PFirst == null) return;

		var t_dif:C3DTexture = C3D.GetTexture("cotl_star4.jpg");
		if (t_dif.tex == null) return;
		
		var t_halo:C3DTexture = C3D.GetTexture("halo_full.png");		
		if (t_halo.tex == null) return;
		
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );

		var offx:Number = m_X - m_Map.m_Hyperspace.m_CamPos.x + m_Map.m_Hyperspace.m_ZoneSize * (m_ZoneX - m_Map.m_Hyperspace.m_CamZoneX);
		var offy:Number = m_Y - m_Map.m_Hyperspace.m_CamPos.y + m_Map.m_Hyperspace.m_ZoneSize * (m_ZoneY - m_Map.m_Hyperspace.m_CamZoneY);
		var offz:Number = m_Z - (m_Map.m_Hyperspace.m_CamPos.z);

		C3D.SetTexture(0, t_halo.tex);
		C3D.DrawHalo(Hyperspace.Self.m_MatViewPer, Hyperspace.Self.m_MatView, Hyperspace.Self.m_MatViewInv, offx, offy, offz, 300.0, 1.0, 400.0, 0xA0000000, false);
		C3D.SetTexture(0, null);
//		return;
		
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE );

//m_QuadBatch = new C3DQuadBatch();
		m_PFirst.ToQuadBatch(false,m_QuadBatch);

		C3D.SetVConstMatrix(0, EmpireMap.Self.m_Hyperspace.m_MatViewPer);
		C3D.SetVConst_n(8, 0.0, 0.0, 0.0, 1.0);

		C3D.ShaderParticle();

		C3D.SetTexture(0, t_dif.tex);
		
		C3D.VBQuadBatch(m_QuadBatch);
		
		C3D.DrawQuadBatch();
		
		C3D.SetTexture(0, null);

		var tx:int = 200;
		var ty:int = 200;
		
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );

		var v:Vector3D = new Vector3D(offx, offy, offz);
		Hyperspace.Self.WorldToScreen(v);		
//		v.x = 100.0;
//		v.y = 100.0;
		m_TextLine.Prepare();
		if(m_TextLine.m_Font!=null) {
			m_TextLine.Draw(0, -1, v.x, v.y - (m_TextLine.m_Font.lineHeight >> 1), 0, 1);
		}

		while (m_Type != Common.CotlTypeCombat) {
			if (m_TextLine.m_Font == null) break;

			var uni:Union = UserList.Self.GetUnion(m_UnionId);
			if (uni == null) break;
			if (uni.m_EmblemTexture == null) break;
			if (Hyperspace.Self.m_BG.m_QB == null) break;

			var wps:Number = 2.0 / Number(m_Map.m_StageSizeX);
			var hps:Number = 2.0 / Number(m_Map.m_StageSizeY);

			var px:Number = v.x - (m_TextLine.m_SizeX >> 1) + 4 - 16;
			var py:Number = v.y + 4;

			var x0:Number = (px - 0.5 * C3D.m_SizeX) * wps - 16 * wps;
			var y0:Number = -(py - 0.5 * C3D.m_SizeY) * hps + 16 * hps;
			var x1:Number = x0 + wps * 32;
			var y1:Number = y0 - hps * 32;

			C3D.SetFConst(1, new Vector3D(1.0, 1.0, 1.0, 1.0));

			C3D.SetTexture(0, uni.m_EmblemTexture);

			C3D.VBQuadBatch(Hyperspace.Self.m_BG.m_QB );
			C3D.ShaderImg();

			C3D.SetVConst_n(0, 0.0, 0.5, 1.0, 2.0);
			C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);

			C3D.SetVConst_n(1, x0, y0, 0.0, 0.0);
			C3D.SetVConst_n(2, x1, y0, 1.0, 0.0);
			C3D.SetVConst_n(3, x1, y1, 1.0, 1.0);
			C3D.SetVConst_n(4, x0, y1, 0.0, 1.0);

			C3D.DrawQuadBatch();

			C3D.SetTexture(0, null);

			break;
		}*/
	}
}

}

import Engine.*;

class HyperspaceCotlParticle extends C3DParticle
{
	public var m_PlaceX:Number = 0;
	public var m_PlaceY:Number = 0;
	public var m_PlaceZ:Number = 0;
	public var m_TTL:Number = 0;
	public var m_Alpha:Number = 0;
	public var m_Size:Number = 0;
	public var m_Life:Number = 0;
	public var m_Type:int = 0; // 1-Star Center

	public function HyperspaceCotlParticle():void
	{
	}

	public function Clear():void
	{
		//ClearData();
		m_PlaceX = 0;
		m_PlaceY = 0;
		m_PlaceZ = 0;
		m_TTL = 0;
		m_Alpha = 0;
		m_Size = 0;
		m_Life = 0;
		m_Type = 0;
	}
}

