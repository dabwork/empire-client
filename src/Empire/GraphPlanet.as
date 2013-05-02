// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
// import fl.motion.AdjustColor;
import Base.*;
import Engine.*;
import Base3D.*;
import flash.display3D.textures.Texture;

import flash.display.*;
import flash.display3D.*;
import flash.events.*;
import flash.filters.ColorMatrixFilter;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.utils.*;

public class GraphPlanet //extends Sprite
{
	private var m_Map:EmpireMap;
	
	public var m_PosX:int;
	public var m_PosY:int;

	public var m_Path:uint = 0;
	public var m_Route0:uint = 0;
	public var m_Route1:uint = 0;
	public var m_Route2:uint = 0;

	public var m_Flag:uint;
	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_Tmp:int;
	public var m_ItemType:int;
	public var m_RaceType:int=Common.RaceNone;
	public var m_ShieldState:int = -1;
	public var m_Spawn:Boolean = false;

	public var m_BGNom:int;

	public var m_PointsType:uint = 0;
	public var m_PointsImg:int = 0;

	public var m_Refuel:Boolean = false;
	
	public var m_TmpVal:Number=0;
	
	public var m_GravitorTime:Number=0;
	
	public var m_Vis:Boolean = false;
	
	public var m_PortalState:int = 0;
	
	public var m_GravitorState:int = 0;
	public var m_RadiationState:Number = 0;
	public var m_GravWellState:Boolean = false;
	public var m_PotentialState:Boolean = false;

	public var m_ViewType:int = 0;
	public var m_Style:int = 0;

	public var m_LvlColor:uint = 0xffffffff;
	public var m_LvlTL:C3DTextLine = new C3DTextLine();
	public var m_NameTL:C3DTextLine = new C3DTextLine();
	public var m_PointsTL:C3DTextLine = new C3DTextLine();

	static public var m_EmptyFirst:GraphPlanetParticle = null;
	static public var m_EmptyLast:GraphPlanetParticle = null;
	static public var m_First:GraphPlanetParticle = null;
	static public var m_Last:GraphPlanetParticle = null;
	
	static public var m_QuadBatchL0:C3DQuadBatch = new C3DQuadBatch();

	static public var m_TexIntf:C3DTexture = null;
	static private var m_TexSun:C3DTexture = null;
	
	public function GraphPlanet(map:EmpireMap)
	{
		m_Map=map;

		m_NameTL.SetFont("normal_outline");
		m_NameTL.SetFormat(0);

		m_LvlTL.SetFont("small");
		m_LvlTL.SetFormat( -1);
		
		m_PointsTL.SetFont("small");
		m_PointsTL.SetFormat( -1);
		m_PointsTL.SetColor(0xff000000);

		m_ItemType=-1;

		m_BGNom=-1;
	}
	
	public function Clear():void
	{
		m_LvlTL.free();
		m_NameTL.free();
		m_PointsTL.free();
		m_ShieldState=-1;
	}

	public function Update():void
	{
		var cl:Class;

		var rnd:int=Math.abs(m_SectorX ^ m_SectorY ^ m_PlanetNum);
		rnd=16807*(rnd % 127773)-2836*Math.floor(rnd / 127773);
        if(rnd<=0) rnd=rnd+2147483647;
        rnd--;

		var i:int=rnd;
		if(m_Flag & Planet.PlanetFlagLarge) {
			i = i % 3;
		} else {
			i = (i % 3) + 10;//i%3;
		}
		if(m_Flag & Planet.PlanetFlagWormhole) {
			i = 100;
		}
		if(m_Flag & Planet.PlanetFlagSun) {
			if(m_Flag & Planet.PlanetFlagLarge) {
				i = 111;
			} else {
				i = 101;
			}
		}
		if(m_Flag & Planet.PlanetFlagGigant) {
			if(m_Flag & Planet.PlanetFlagLarge) {
				if(i%2==0) i=102;
				else i=103;
			}
			else i=104;
		}
		if(m_Flag & Planet.PlanetFlagRich) {
			i=105;
		}
		
		if (m_BGNom != i || m_Map.m_TmpVal != m_TmpVal) {
			m_TmpVal = m_Map.m_TmpVal;
			m_BGNom = i;
		}

		if (i != m_ViewType || m_Style==0) {
			m_ViewType = i;
			if (i == 0) m_Style=HyperspacePlanetStyle.findByName("simple_00");
			else if (i == 1) m_Style=HyperspacePlanetStyle.findByName("simple_01");
			else if (i == 2) m_Style=HyperspacePlanetStyle.findByName("simple_02");
			else if(i==10) m_Style=HyperspacePlanetStyle.findByName("simple_10");
			else if(i==11) m_Style=HyperspacePlanetStyle.findByName("simple_11");
			else if(i==12) m_Style=HyperspacePlanetStyle.findByName("simple_12");
			else if (i == 100) m_Style = 0;// name = "MoveWormhole";
			else if (i == 101) m_Style = 0;// name = "MoveSun";
			else if(i==102) m_Style=HyperspacePlanetStyle.findByName("simple_gigant");
			else if(i==103) m_Style=HyperspacePlanetStyle.findByName("simple_gigant2");
			else if(i==104) m_Style=HyperspacePlanetStyle.findByName("simple_luna");
			else if(i==105) m_Style=HyperspacePlanetStyle.findByName("simple_rich");
			else if (i == 111) m_Style = 0;// name = "MoveSun";
			else m_Style=HyperspacePlanetStyle.findByName("simple_00");
		}
	}

	public function SetLvl(i:String):void
	{
		if (m_LvlTL.m_Text == i) return;
		m_LvlTL.SetText(i);

		if (i == "∞") m_LvlTL.SetFont("big");
		else m_LvlTL.SetFont("small");
		
	}

	public function SetColor(clr:uint):void
	{
		m_LvlColor = clr;
	}
	
	public function SetPoints(type:uint, i:String):void
	{
		if (m_PointsType == type && m_PointsTL.m_Text == i) return;
		m_PointsTL.SetText(i);
		
		if (m_PointsType == type) return;
		m_PointsType = type;
		m_PointsImg = 0;

		if (type == 0) return;

		var idesc:Item = UserList.Self.GetItem(type);
		if (idesc == null) { m_PointsType = 0; return; }
		m_PointsImg = idesc.m_Img;
	}

	public function SetName(n:String):void
	{
		m_NameTL.SetText(n);
	}

	public function SetFlag(f:uint):void
	{
		if(m_Flag==f) return;
		m_Flag=f;
	}

	public function SetItemType(type:int):void
	{
		if(m_ItemType==type) return;
		m_ItemType=type;
	}
	
	public static function GetImageByRace(race:int):Sprite
	{
		var name:String='';
		var sx:Number=1.0;

		if(race==Common.RaceGrantar) { name="RaceGrantar"; sx=1.0; }
		else if(race==Common.RacePeleng) { name="RacePeleng"; sx=1.0; }
		else if(race==Common.RacePeople) { name="RacePeople"; sx=1.0; }
		else if(race==Common.RaceTechnol) { name="RaceTechnol"; sx=1.0; }
		else if(race==Common.RaceGaal) { name="RaceGaal"; sx=1.0; }
	
		if(name.length<=0) { name="RaceGrantar"; sx=2.0; }

		var cl:Class=ApplicationDomain.currentDomain.getDefinition(name) as Class;
		var s:Sprite=new cl();
		s.scaleX=sx;
		s.scaleY=sx;
		return s;
	}

	public function SetRaceType(race:int):void
	{
		if(m_RaceType==race) return;
		m_RaceType=race;
	}

	public function SetShield(v:int):void
	{
		if(m_ShieldState==v) return;
		m_ShieldState=v;
	}

	public function SetPortal(v:int):void
	{
		if (m_PortalState == v) return;
		m_PortalState = v;
	}

	public function SetGravitor(state:int):void
	{
		if(state==m_GravitorState) return;
		m_GravitorState=state;
	}
	
	public function SetGravWell(state:Boolean):void
	{
		if(state==m_GravWellState) return;
		m_GravWellState=state;
	}

	public function SetPotential(state:Boolean):void
	{
		if(state==m_PotentialState) return;
		m_PotentialState=state;
	}

	public function SetRadiation(state:Number):void
	{
		if (state < 0) state = 0;
		else if (state > 1.0) state = 1;

		if(state==m_RadiationState) return;
		m_RadiationState=state;
	}

	public function SetRefuel(v:Boolean):void
	{
		m_Refuel = v;
/*		if(v) {
			if(m_Refuel==null) {
				var cl:Class=ApplicationDomain.currentDomain.getDefinition("ItemFuel") as Class;
				m_Refuel=new cl();
				m_Refuel.scaleX=0.4;
				m_Refuel.scaleY=0.4;
				addChild(m_Refuel);
			}
		} else {
			if(m_Refuel!=null) {
				removeChild(m_Refuel);
				m_Refuel=null;
			}
		}*/
	}

/*	public function NameToChat(e:MouseEvent)
	{
trace("NameToChar00");
		if((e.ctrlKey || e.altKey || e.shiftKey)) {
trace("NameToChar01",m_SectorX,m_SectorY,m_PlanetNum);
			var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
			if(planet!=null) {
trace("NameToChar02",planet.m_Owner);
				var user:User=UserList.Self.GetUser(planet.m_Owner);
				if(user!=null) {
					FormChat.Self.MsgAddText("["+user.m_Name+"]");
				}
			}
		}
	}*/
	
	public function Radius():Number
	{
		var radius:Number = 35.0;
		
		if (m_ViewType == 10 || m_ViewType == 11 || m_ViewType == 12) radius = 25.0;
		else if (m_ViewType == 104) radius = 25.0;
		
		return radius;
	}

	public function Draw():void
	{
		var i:int;
		var clr2:uint;
		var w:Number, ww:Number, a:Number;
		var tex:C3DTexture = null;

		var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if (planet == null) return;

		var px:Number = m_Map.WorldToScreenX(planet.m_PosX, planet.m_PosY);
		var py:Number = EmpireMap.m_TWSPos.y;

		var clr:uint = 0xffffffff;
		var clrpm:uint = 0xffffffff;
		var alpha:Number = 1.0;

		if (!m_Vis && !m_Map.ScopeVis) {
			if(m_Flag & Planet.PlanetFlagWormhole) alpha = 0.5;
			else alpha = 0.3;
			clrpm = C3D.ClrReplaceAlpha(clr, alpha, true);
			clr = C3D.ClrReplaceAlpha(clr, alpha, false);
		}
		
		//if (!m_Vis) {
		if (!m_Vis && (EmpireMap.Self.m_CotlType == Common.CotlTypeCombat)) {
			alpha = 0.3;
			clrpm = C3D.ClrReplaceAlpha(clr, alpha, true);
			clr = C3D.ClrReplaceAlpha(clr, alpha, false);
		} else if ((m_Flag & Planet.PlanetFlagWormhole) != 0 && (m_Flag & (Planet.PlanetFlagWormholeOpen | Planet.PlanetFlagWormholeClose | Planet.PlanetFlagWormholePrepare)) == 0) {
			//if (m_Flag & Planet.PlanetFlagDestroyed) alpha = 0.25;
			//else
			alpha *= 0.75;
			clrpm = C3D.ClrReplaceAlpha(clr, alpha, true);
			clr = C3D.ClrReplaceAlpha(clr, alpha, false);
		}
/*		if(m_Vis || m_Map.m_Set_Vis) {
			clr = 0xffffffff;
		} else {
			clr = 0xccffffff;
			alpha = 0.8;
		}*/

		if (m_Flag & Planet.PlanetFlagSun) {
			if (m_Flag & Planet.PlanetFlagLarge) {
				if (m_Flag & Planet.PlanetFlagStabilizer) tex = C3D.GetTexture("hbcs=-180 0 0 0~planet/sun.png");
				else tex = C3D.GetTexture("hbcs=-140 0 0 0~planet/sun.png");

			} else {
				tex = C3D.GetTexture("planet/sun.png");
			}
			if (tex == null || tex.tex == null) return;

			i = 51 + (Math.floor(EmpireMap.Self.m_CurTime / 50) % 150);

			w = /*Number(C3D.m_SizeY >> 1)*/512.0 / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
			w = 121.778560268341 * w;

			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.NONE);
			C3D.DrawImg(tex, clr/*pm*/, Math.round(px) - 0.5 * w, Math.round(py) - 0.5 * w, w, w, (i & 15) * 128, (i >> 4) * 128, 128, 128);
			
		} else if (m_Flag & Planet.PlanetFlagWormhole) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) return;

			i = 0 + (Math.floor(EmpireMap.Self.m_CurTime / 50) % 51);

			w = /*Number(C3D.m_SizeY >> 1)*/512.0 / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
			w = 121.778560268341 * w;

			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.NONE);
			C3D.DrawImg(tex, clr/*pm*/, Math.round(px) - 0.5 * w, Math.round(py) - 0.5 * w, w, w, (i & 15) * 128, (i >> 4) * 128, 128, 128);

		} else {

			var l:int;
			var layer:Object;
			var texture:C3DTexture;
			var light:Vector3D;
			var mesh:C3DMesh;

			var offx:Number = (planet.m_PosX - planet.m_Sector.m_SectorX * EmpireMap.Self.m_SectorSize) - EmpireMap.Self.m_CamPos.x + EmpireMap.Self.m_SectorSize * (planet.m_Sector.m_SectorX - EmpireMap.Self.m_CamSectorX);
			var offy:Number = (planet.m_PosY - planet.m_Sector.m_SectorY * EmpireMap.Self.m_SectorSize) - EmpireMap.Self.m_CamPos.y + EmpireMap.Self.m_SectorSize * (planet.m_Sector.m_SectorY - EmpireMap.Self.m_CamSectorY);
			var offz:Number = 0 - EmpireMap.Self.m_CamPos.z;

			//m_Style = HyperspacePlanetStyle.findByName("simple_02");
			if (m_Style == 0) return;
			var style:Object = HyperspacePlanetStyle.m_Map[m_Style];

			var ok:Boolean = true;
			for (l = 0; l < style.Layer.length; l++) {
				layer = style.Layer[l];
				if (layer.Shader == HyperspacePlanetStyle.ShaderOff) continue;
				if(layer.Texture.length>0) {
					texture = C3D.GetTexture(layer.Texture);
					if (texture == null || texture.tex == null) ok = false;
				}
				if (layer.Shader == HyperspacePlanetStyle.ShaderSphere && HyperspacePlanet.MeshSphere() == null) ok = false;
				if (layer.Shader == HyperspacePlanetStyle.ShaderSimple && HyperspacePlanet.MeshSphere(true) == null) ok = false;
			}
			if (!ok) return;

			// ring 0
			while ((m_Flag & Planet.PlanetFlagGigant) != 0 && (m_Flag & Planet.PlanetFlagLarge) != 0) {
				tex = C3D.GetTexture("planet/sun.png");
				if (tex == null || tex.tex == null) break;

				w = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
				w = 250.0 * w;

				C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
				C3D.Context.setCulling(Context3DTriangleFace.NONE);
				C3D.DrawImg(tex, clrpm, px - 0.5 * w, py + 2 - 0.5 * w, w, w, 1280, 1792, 256, 256);

				break;
			}

			C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.FRONT);

			C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
			C3D.SetFConst_n(1, 0.1, 1.0 / 0.4, 0.5, 10.0);

			var vl:Vector3D = new Vector3D();
			var d:Number;
			
			var radius:Number = Radius();

			for (l = 0; l < style.Layer.length; l++) {
				layer = style.Layer[l];

				if (layer.Shader == HyperspacePlanetStyle.ShaderOff) continue;
				if (layer.Blend == HyperspacePlanetStyle.BlendOff) continue;
				
				if (layer.Texture.length <= 0) continue;

				texture = C3D.GetTexture(layer.Texture);
				if (texture == null) continue;

				if(layer.Blend==1) C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA ); // alpha
				else if(layer.Blend==2) C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE ); // add
				else C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR ); // screen

				C3D.SetFConst_Color(5, layer.Ambient, 3.0);
				C3D.SetFConst_Color(6, layer.Diffuse, 3.0);
				C3D.SetFConst_Color(7, layer.Reflection | 0xff000000, 3.0, (1.0 - Number((layer.Reflection >> 24) & 255) / 255.0) * 50.0);
				C3D.SetFConst_Color(8, layer.Shadow);
				C3D.SetFConst_Gamma(9, layer.Gamma);
				C3D.SetFConst_TransformAlpha(10, layer.Alpha);

				C3D.SetTexture(0, texture.tex);
				
				var r:Number = radius * layer.RadiusMul;

				vl.x = EmpireMap.Self.m_LightPlanet.x;
				vl.y = EmpireMap.Self.m_LightPlanet.y;
				vl.z = EmpireMap.Self.m_LightPlanet.z;
				if (layer.Light == HyperspacePlanetStyle.LightView) {
					vl.x = EmpireMap.Self.m_View.x-offx;
					vl.y = EmpireMap.Self.m_View.y-offy;
					vl.z = EmpireMap.Self.m_View.z-offz;
					vl.normalize();
				}

				clr2 = layer.Color;
				if (alpha != 1.0) {
					//clr2 = (uint(Math.round(Number((clr >> 24) & 255) * alpha)) << 24) | (clr & 0xffffff);
					clr2 = C3D.ClrReplaceAlpha(clr2, C3D.ClrToFloat * Number((clr2 >> 24) & 255) * alpha);
				}

				if (layer.Shader == HyperspacePlanetStyle.ShaderHalo) {
					C3D.DrawHalo(EmpireMap.Self.m_MatViewPer, EmpireMap.Self.m_MatView, EmpireMap.Self.m_MatViewInv, offx, offy, offz, r, layer.InnerSize, layer.OuterSize, clr2, true, vl, EmpireMap.Self.m_View);

				} else if (layer.Shader == HyperspacePlanetStyle.ShaderSphere || layer.Shader == HyperspacePlanetStyle.ShaderSimple) {
					mesh = HyperspacePlanet.MeshSphere(layer.Shader == HyperspacePlanetStyle.ShaderSimple);
					
					C3D.SetFConst_Color(4, clr2);

					var m:Matrix3D = new Matrix3D();
					m.identity();
					m.appendScale(r * 0.01, r * 0.01, r * 0.01);
					a = Number(Math.floor(EmpireMap.Self.m_CurTime) % Math.abs(layer.Period * 1000)) / Math.abs(layer.Period * 1000) * 2.0 * Math.PI;
					if (layer.Period < 0) a = -a;
					m.appendRotation((layer.Rotate + a) * Space.ToGrad, Vector3D.Z_AXIS);
					m.appendRotation(layer.AngleA, Vector3D.X_AXIS);
					m.appendRotation(layer.AngleB, Vector3D.Z_AXIS);
					m.appendTranslation(offx, offy, offz);

					var minv:Matrix3D = new Matrix3D();
					minv.copyFrom(m);
					minv.invert();

					m.append(EmpireMap.Self.m_MatViewPer);

					C3D.SetVConstMatrix(0, m);
			
					var v:Vector3D;
					v = minv.deltaTransformVector(vl);
					v.w = 0.0;
					v.normalize();
					C3D.SetFConst(2, v);

					vl.x = EmpireMap.Self.m_View.x-offx;
					vl.y = EmpireMap.Self.m_View.y-offy;
					vl.z = EmpireMap.Self.m_View.z-offz;
					v = minv.transformVector(vl);
					v.normalize();
					C3D.SetFConst_n(3, -v.x, -v.y, -v.z, 0.0);
					
					C3D.ShaderPlanet();
					C3D.VBMesh(mesh);
					C3D.DrawMesh();
				}

				C3D.SetTexture(0, null);
			}

			// asteroids
			while ((m_Flag & Planet.PlanetFlagGigant) != 0 && (m_Flag & Planet.PlanetFlagLarge) == 0) {
				tex = C3D.GetTexture("planet/sun.png");
				if (tex == null || tex.tex == null) break;
				
				w = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
				w = 250.0 * w;
				
				var rnd:int = Math.abs(m_SectorX ^ m_SectorY ^ m_PlanetNum);
				rnd = 16807 * (rnd % 127773) - 2836 * Math.floor(rnd / 127773);
				if (rnd <= 0) rnd = rnd + 2147483647;
				rnd--;

				a = ((rnd % 360) + (Math.floor(Common.GetTime() / 30) % 3600) / 10.0) * C3D.ToRad;

				C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
				C3D.Context.setCulling(Context3DTriangleFace.NONE);
				//C3D.DrawImg(tex, clr, px - 0.5 * w, py - 0.5 * w, w, w, 1792, 1792, 256, 256);
				C3D.DrawImgRotate(tex, clrpm, px, py, w, w, a, 1792, 1792, 256, 256);

				break;
			}

			// ring 1
			while ((m_Flag & Planet.PlanetFlagGigant) != 0 && (m_Flag & Planet.PlanetFlagLarge) != 0) {
				tex = C3D.GetTexture("planet/sun.png");
				if (tex == null || tex.tex == null) break;

				w = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
				w = 250.0 * w;

				C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
				C3D.Context.setCulling(Context3DTriangleFace.NONE);
				C3D.DrawImg(tex, clrpm, px - 0.5 * w, py + 2 - 0.5 * w, w, w, 1536, 1792, 256, 256);

				break;
			}
		}
		
		// portal
		while (m_PortalState > 0) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) break;

			ww = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
			w = 128.0 * ww;

			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.NONE);
			C3D.DrawImg(tex, clrpm, px - 90.0 * ww - 0.5 * w, py - 90.0 * ww - 0.5 * w, w, w, (m_PortalState == 1)?768:896, 1664, 128, 128);

			break;
		}

		// gravitor
		while (m_GravitorState > 0) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) break;

			ww = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
			w = 256.0 * ww;
			
			if (m_GravitorState == 1) clr2 = C3D.ClrReplaceAlpha(0xffffff, 0.5 * alpha, false);
			else if (m_GravitorState == 2) clr2 = C3D.ClrReplaceAlpha(0xffffffff, alpha, false);
			else if (m_GravitorState == 3) clr2 = C3D.ClrReplaceAlpha(0xffff00, alpha, false);
			else clr2 = C3D.ClrReplaceAlpha(0xffff00, alpha * 0.5, false);

			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.NONE);
			C3D.DrawImg(tex, clr2, px - 0.5 * w, py - 0.5 * w, w, w, 1024, 1792, 256, 256);
			break;
		}
		
		// radiation
		while (m_RadiationState != 0.0) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) break;

			clr2 = (uint(Math.round(255 * m_RadiationState * 0.8)) << 24) | 0xffffff;

			ww = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
			w = 256.0 * ww;

			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.NONE);
			C3D.DrawImg(tex, clr2, px - 0.5 * w, py - 0.5 * w, w, w, 768, 1792, 256, 256);
			break;
		}

		// potential
		while (m_PotentialState) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) break;

			ww = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
			w = 256.0 * ww;

			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.NONE);
			//C3D.DrawImg(tex, 0xffffffff, px - 0.5 * w, py - 0.5 * w, w, w, 512, 1792, 256, 256);
			
			a = 2.0 * Math.PI * (EmpireMap.Self.m_CurTime % 2000) / 2000;
			C3D.DrawImgRotate(tex, 0xffffffff, px, py, w, w, a, 512, 1792, 256, 256);
			break;
		}

		// GravWell
		while (m_GravWellState) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) break;

			ww = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
			w = 384.0 * ww;
			
			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.NONE);
			C3D.DrawImg(tex, 0xccffffff, px - 0.5 * w, py - 0.5 * w, w, w, 0, 1664, 384, 384);
			break;
		}
		
		// shield
		while (m_ShieldState >= 0) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) break;

			ww = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
			w = 256.0 * ww;

			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			C3D.Context.setCulling(Context3DTriangleFace.NONE);
			C3D.DrawImg(tex, (m_ShieldState == 0)?0x7fffffff:0xccffffff, px - 0.5 * w, py - 0.5 * w, w, w, 1536, 1536, 256, 256);
			break;
		}
	}

	public function DrawText():void
	{
		var w:Number, ww:Number;
		var tex:C3DTexture;
		var texr:Texture;
		var x:int, y:int;
		var v:Number;
		var str:String;

		var px:Number = m_Map.WorldToScreenX(m_PosX, m_PosY);
		var py:Number = EmpireMap.m_TWSPos.y;

		var clr2:uint;
		var clr:uint = 0xffffffff;
		var clrpm:uint = 0xffffffff;
		var alpha:Number = 1.0;
		if(!m_Vis) {
			alpha = 0.3;
			clrpm = C3D.ClrReplaceAlpha(clr, alpha, true);
			clr = C3D.ClrReplaceAlpha(clr, alpha, false);
		}
		
		var radius:Number = Radius();
		ww = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);

		if (m_TexIntf == null) m_TexIntf = C3D.GetTexture("font/intf.png");
		if (m_TexIntf.tex == null) return;
		
		// Spawn
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		while (m_Spawn) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) break;

			C3D.DrawImg(tex, clrpm, px - (20 >> 1), py - (27 >> 1), 20, 27, 1034, 1760, 20, 27);

			break;
		}

		// ItemType
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		while (m_ItemType == Common.ItemTypeCrystal || m_ItemType == Common.ItemTypeTitan || m_ItemType == Common.ItemTypeSilicon) {
			tex = C3D.GetTexture("planet/sun.png");
			if (tex == null || tex.tex == null) break;

			if (m_ItemType == Common.ItemTypeCrystal) x = 1057;
			else if (m_ItemType == Common.ItemTypeTitan) x = 1085;
			else if (m_ItemType == Common.ItemTypeSilicon) x = 1028;

			v = 20;
			if (m_Flag & (Planet.PlanetFlagLarge)) v = 22;
			else v = 17;
			
			C3D.DrawImg(tex, clrpm, px + ww * v - (27 >> 1), py + ww * v - (27 >> 1), 27, 27, x, 1668, 27, 27);

			break;
		}
		
		// Refuel
		while (m_Refuel) {
			texr = Common.ItemTex(7);
			if (texr == null) break;

			x = Math.round(px);
			y = Math.round(py + ww * radius * 0.80);

			v = 64 * Common.ItemScale(7) * 0.5;

			C3D.DrawImgSimple(texr, true, clrpm, x - v * 0.5, y - v * 0.5, v, v);
			break;
		}
		
		// Name
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		m_NameTL.Prepare();
		if (m_NameTL.m_Font != null && m_NameTL.m_LineCnt > 0) {
			m_NameTL.Draw(0, -1, Math.round(px), Math.round(py + ww * radius), 0, 1, clr);
		}
		
		// Lvl
		m_LvlTL.Prepare();
		if (m_LvlTL.m_Font != null && m_LvlTL.m_LineCnt > 0) {
			x = Math.round(px - ww * radius * 0.80 - (m_LvlTL.m_SizeX >> 1));
			y = Math.round(py - ww * radius * 0.75 - (m_LvlTL.m_SizeY >> 1));

			clr2 = C3D.ClrReplaceAlpha(0, alpha, false);
			C3D.DrawImg(m_TexIntf, clr2, x - 3, y, 2, m_LvlTL.m_SizeY, 2, 2, 1, 1);
			C3D.DrawImg(m_TexIntf, clr2, x + m_LvlTL.m_SizeX + 1, y, 2, m_LvlTL.m_SizeY, 2, 2, 1, 1);

			C3D.DrawImg(m_TexIntf, clr2, x - 3, y - 1, m_LvlTL.m_SizeX + 6, 2, 2, 2, 1, 1);
			C3D.DrawImg(m_TexIntf, clr2, x - 3, y + m_LvlTL.m_SizeY - 1, m_LvlTL.m_SizeX + 6, 2, 2, 2, 1, 1);
			
			clr2 = C3D.ClrReplaceAlpha(m_LvlColor, alpha, false);
			C3D.DrawImg(m_TexIntf, clr2, x - 2, y, m_LvlTL.m_SizeX + 4, m_LvlTL.m_SizeY, 2, 2, 1, 1);

			m_LvlTL.Draw(0, -1, x, y, 1, 1, clr);
		}
		
		// Points
		m_PointsTL.Prepare();
		if (m_PointsTL.m_Font != null && m_PointsTL.m_LineCnt > 0) {
			x = Math.round(px);
			y = Math.round(py - ww * radius * 0.90 - (m_PointsTL.m_SizeY >> 1));

			clr2 = C3D.ClrReplaceAlpha(0, alpha, false);
			C3D.DrawImg(m_TexIntf, clr2, x - 3, y, 2, m_PointsTL.m_SizeY, 2, 2, 1, 1);
			C3D.DrawImg(m_TexIntf, clr2, x + m_PointsTL.m_SizeX + 1, y, 2, m_PointsTL.m_SizeY, 2, 2, 1, 1);

			C3D.DrawImg(m_TexIntf, clr2, x - 3, y - 1, m_PointsTL.m_SizeX + 6, 2, 2, 2, 1, 1);
			C3D.DrawImg(m_TexIntf, clr2, x - 3, y + m_PointsTL.m_SizeY - 1, m_PointsTL.m_SizeX + 6, 2, 2, 2, 1, 1);

			clr2 = C3D.ClrReplaceAlpha(0xffc9ed3b, alpha, false);
			C3D.DrawImg(m_TexIntf, clr2, x - 2, y, m_PointsTL.m_SizeX + 4, m_PointsTL.m_SizeY, 2, 2, 1, 1);

			m_PointsTL.Draw(0, -1, x, y, 1, 1, clr);
			
			// img
			C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			while (m_PointsImg != 0) {
				texr = Common.ItemTex(m_PointsImg);
				if (texr == null) break;

				v = 64 * Common.ItemScale(m_PointsImg);
				if (m_PointsType == Common.ItemTypeFuel) v *= 0.8;
				else v *= 0.9;

				C3D.DrawImgSimple(texr, true, clrpm, x + 11 - v * 0.5, y + (m_PointsTL.m_SizeY >> 1) - v * 0.5, v, v);
				break;
			}
		}
	}
	
	public static function PAdd():GraphPlanetParticle 
	{
		var p:GraphPlanetParticle = m_EmptyFirst;
		if (p != null) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_EmptyLast == p) m_EmptyLast = GraphPlanetParticle(p.m_Prev);
			if (m_EmptyFirst == p) m_EmptyFirst = GraphPlanetParticle(p.m_Next);
		} else {
			p = new GraphPlanetParticle();
		}
		if (m_Last != null) m_Last.m_Next = p;
		p.m_Prev = m_Last;
		p.m_Next = null;
		m_Last = p;
		if (m_First == null) m_First = p;
		return p;
	}

	public static function PDel(p:GraphPlanetParticle):void
	{
		if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
		if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
		if (m_Last == p) m_Last = GraphPlanetParticle(p.m_Prev);
		if (m_First == p) m_First = GraphPlanetParticle(p.m_Next);

		//p.Clear();

		if (m_EmptyLast != null) m_EmptyLast.m_Next = p;
		p.m_Prev = m_EmptyLast;
		p.m_Next = null;
		m_EmptyLast = p;
		if (m_EmptyFirst == null) m_EmptyFirst = p;
	}
	
	public static function PClear():void
	{
		var p:GraphPlanetParticle;
		var pnext:GraphPlanetParticle = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = GraphPlanetParticle(pnext.m_Next);
			PDel(p);
		}
	}

	public static function PBuild():void
	{
		var i:int, u:int, tsecx:int, tsecy:int, tplanet:int, path:int;
		var p:GraphPlanetParticle;
		var gp:GraphPlanet, gp2:GraphPlanet;
		var fx:Number, fy:Number, fz:Number, dx:Number, dy:Number;
		var a1:Number, a2:Number, a3:Number;
		var dist:Number, v:Number;
		var clr:uint, clr1:uint, clr2:uint, clr3:uint;

		var mv:Matrix3D = EmpireMap.Self.m_MatViewInv;
		var nx:Number = mv.rawData[2 * 4 + 0];
		var ny:Number = mv.rawData[2 * 4 + 1];
		var nz:Number = mv.rawData[2 * 4 + 2];

		PClear();

		clr = 0xffffffff;
		if (EmpireMap.Self.m_BG.m_Cfg != null) clr = EmpireMap.Self.m_BG.m_Cfg.ColorTrade;

		for (i = 0; i < EmpireMap.Self.m_PlanetList.length; i++) {
			gp = EmpireMap.Self.m_PlanetList[i];
			
			while (gp.m_Path != 0) {
				tsecx=gp.m_SectorX;
				tsecy=gp.m_SectorY;
				tplanet=(gp.m_Path>>4)&7;
				if(gp.m_Path & 1) tsecx+=1;
				else if(gp.m_Path & 2) tsecx-=1;
				if(gp.m_Path & 4) tsecy+=1;
				else if(gp.m_Path & 8) tsecy-=1;
				if (gp.m_SectorX == tsecx && gp.m_SectorY == tsecy && gp.m_PlanetNum == tplanet) break;
				gp2 = EmpireMap.Self.GetGraphPlanet(tsecx, tsecy, tplanet);
				if (gp2 == null) break;
				
				if (gp.m_Vis == false && gp2.m_Vis == false) break;
				if ((gp.m_Flag & Planet.PlanetFlagNoCapture) && (gp2.m_Flag & Planet.PlanetFlagNoCapture) && !EmpireMap.Self.IsEdit()) break;

				a1 = gp.m_Vis?0.4:0.01;
				a2 = (gp.m_Vis && gp2.m_Vis)?0.8:0.1;
				a3 = gp2.m_Vis?1.0:0.01;
				clr1 = (uint(Math.round(((clr >> 24) & 255) * a1)) << 24) | (clr & 0xffffff);
				clr2 = (uint(Math.round(((clr >> 24) & 255) * a2)) << 24) | (clr & 0xffffff);
				clr3 = (uint(Math.round(((clr >> 24) & 255) * a3)) << 24) | (clr & 0xffffff);

				fx = gp.m_PosX - gp.m_SectorX * EmpireMap.Self.m_SectorSize - EmpireMap.Self.m_CamPos.x + EmpireMap.Self.m_SectorSize * (gp.m_SectorX - EmpireMap.Self.m_CamSectorX);
				fy = gp.m_PosY - gp.m_SectorY * EmpireMap.Self.m_SectorSize - EmpireMap.Self.m_CamPos.y + EmpireMap.Self.m_SectorSize * (gp.m_SectorY - EmpireMap.Self.m_CamSectorY);
				fz = 0.0 - EmpireMap.Self.m_CamPos.z;
				dx = gp2.m_PosX - gp.m_PosX;
				dy = gp2.m_PosY - gp.m_PosY;
				dist = Math.sqrt(dx * dx + dy * dy);
				v = 1.0 / dist; dx *= v; dy *= v;

				if(gp.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
					fx += dx * 40;
					fy += dy * 40;
					dist -= 40;
				} else {
					fx += dx * 30;
					fy += dy * 30;
					dist -= 30;
				}

				if(gp2.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
					dist -= 40;
				} else {
					dist -= 30;
				}

				var endl:Number = 20;

				p = PAdd();
				p.m_Layer = 0;
				p.m_PosX = fx;
				p.m_PosY = fy;
				p.m_PosZ = fz;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 30.0;
				p.m_Height = endl;
				p.m_U1 = 1152.0 / 2048;
				p.m_V1 = 1664.0 / 2048;
				p.m_U2 = (1152.0 + 45.0) / 2048;
				p.m_V2 = (1664.0 + 30.0) / 2048;
				p.m_Color = clr1;
				p.m_ColorTo = clr1;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagContinue;
				p.m_Layer = 0;
				p.m_PosX = fx + dx * endl;
				p.m_PosY = fy + dy * endl;
				p.m_PosZ = fz;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 30.0;
				p.m_Height = (dist - endl - endl) * 0.5;
				p.m_U1 = 1152.0 / 2048;
				p.m_V1 = (1664.0 + 30.0) / 2048;
				p.m_U2 = (1152.0 + 45.0) / 2048;
				p.m_V2 = (1664.0 + 128.0 - 30.0) / 2048;
				p.m_Color = clr1;
				p.m_ColorTo = clr2;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagContinue;
				p.m_Layer = 0;
				p.m_PosX = fx + dx * (endl + (dist - endl - endl) * 0.5);
				p.m_PosY = fy + dy * (endl + (dist - endl - endl) * 0.5);
				p.m_PosZ = fz;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 30.0;
				p.m_Height = (dist - endl - endl) * 0.5;
				p.m_U1 = 1152.0 / 2048;
				p.m_V1 = (1664.0 + 30.0) / 2048;
				p.m_U2 = (1152.0 + 45.0) / 2048;
				p.m_V2 = (1664.0 + 128.0 - 30.0) / 2048;
				p.m_Color = clr2;
				p.m_ColorTo = clr3;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagContinue;
				p.m_Layer = 0;
				p.m_PosX = fx + dx * (dist - endl);
				p.m_PosY = fy + dy * (dist - endl);
				p.m_PosZ = fz;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 30.0;
				p.m_Height = endl;
				p.m_U1 = 1152.0 / 2048;
				p.m_V1 = (1664.0 + 128.0 - 30.0) / 2048;
				p.m_U2 = (1152.0 + 45.0) / 2048;
				p.m_V2 = (1664.0 + 128.0) / 2048;
				p.m_Color = clr3;
				p.m_ColorTo = clr3;

				break;
			}
		}

		clr = 0xffffffff;
		if (EmpireMap.Self.m_BG.m_Cfg != null) clr = EmpireMap.Self.m_BG.m_Cfg.ColorRoute;

		for (i = 0; i < EmpireMap.Self.m_PlanetList.length; i++) {
			gp = EmpireMap.Self.m_PlanetList[i];
			
			for (u = 0; u < 3; u++) {
				if (u == 0) path = gp.m_Route0;
				else if (u == 1) path = gp.m_Route1;
				else path = gp.m_Route2;
				if (path == 0) continue;

				tsecx=gp.m_SectorX;
				tsecy=gp.m_SectorY;
				tplanet=(path>>4)&7;
				if(path & 1) tsecx+=1;
				else if(path & 2) tsecx-=1;
				if(path & 4) tsecy+=1;
				else if(path & 8) tsecy-=1;
				if (gp.m_SectorX == tsecx && gp.m_SectorY == tsecy && gp.m_PlanetNum == tplanet) continue;
				gp2 = EmpireMap.Self.GetGraphPlanet(tsecx, tsecy, tplanet);
				if (gp2 == null) continue;

				if (gp.m_Vis == false && gp2.m_Vis == false) continue;
				if ((gp.m_Flag & Planet.PlanetFlagNoCapture) && (gp2.m_Flag & Planet.PlanetFlagNoCapture) && !EmpireMap.Self.IsEdit()) continue;

				a1 = gp.m_Vis?0.4:0.01;
				a2 = (gp.m_Vis && gp2.m_Vis)?0.8:0.1;
				a3 = gp2.m_Vis?1.0:0.01;
				clr1 = (uint(Math.round(((clr >> 24) & 255) * a1)) << 24) | (clr & 0xffffff);
				clr2 = (uint(Math.round(((clr >> 24) & 255) * a2)) << 24) | (clr & 0xffffff);
				clr3 = (uint(Math.round(((clr >> 24) & 255) * a3)) << 24) | (clr & 0xffffff);

				fx = gp.m_PosX - gp.m_SectorX * EmpireMap.Self.m_SectorSize - EmpireMap.Self.m_CamPos.x + EmpireMap.Self.m_SectorSize * (gp.m_SectorX - EmpireMap.Self.m_CamSectorX);
				fy = gp.m_PosY - gp.m_SectorY * EmpireMap.Self.m_SectorSize - EmpireMap.Self.m_CamPos.y + EmpireMap.Self.m_SectorSize * (gp.m_SectorY - EmpireMap.Self.m_CamSectorY);
				fz = 0.0 - EmpireMap.Self.m_CamPos.z;
				dx = gp2.m_PosX - gp.m_PosX;
				dy = gp2.m_PosY - gp.m_PosY;
				dist = Math.sqrt(dx * dx + dy * dy);
				v = 1.0 / dist; dx *= v; dy *= v;

				if(gp.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
					fx += dx * 40;
					fy += dy * 40;
					dist -= 40;
				} else {
					fx += dx * 30;
					fy += dy * 30;
					dist -= 30;
				}

				if(gp2.m_Flag & (Planet.PlanetFlagSun | Planet.PlanetFlagLarge)) {
					dist -= 40;
				} else {
					dist -= 30;
				}

				endl = 20;

				p = PAdd();
				p.m_Layer = 0;
				p.m_PosX = fx;
				p.m_PosY = fy;
				p.m_PosZ = fz;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 15.0;
				p.m_Height = endl;
				p.m_U1 = 1197.0 / 2048;
				p.m_V1 = 1664.0 / 2048;
				p.m_U2 = (1197.0 + 30.0) / 2048;
				p.m_V2 = (1664.0 + 30.0) / 2048;
				p.m_Color = clr1;
				p.m_ColorTo = clr1;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagContinue;
				p.m_Layer = 0;
				p.m_PosX = fx + dx * endl;
				p.m_PosY = fy + dy * endl;
				p.m_PosZ = fz;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 15.0;
				p.m_Height = (dist - endl - endl) * 0.5;
				p.m_U1 = 1197.0 / 2048;
				p.m_V1 = (1664.0 + 30.0) / 2048;
				p.m_U2 = (1197.0 + 30.0) / 2048;
				p.m_V2 = (1664.0 + 128.0 - 30.0) / 2048;
				p.m_Color = clr1;
				p.m_ColorTo = clr2;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagContinue;
				p.m_Layer = 0;
				p.m_PosX = fx + dx * (endl + (dist - endl - endl) * 0.5);
				p.m_PosY = fy + dy * (endl + (dist - endl - endl) * 0.5);
				p.m_PosZ = fz;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 15.0;
				p.m_Height = (dist - endl - endl) * 0.5;
				p.m_U1 = 1197.0 / 2048;
				p.m_V1 = (1664.0 + 30.0) / 2048;
				p.m_U2 = (1197.0 + 30.0) / 2048;
				p.m_V2 = (1664.0 + 128.0 - 30.0) / 2048;
				p.m_Color = clr2;
				p.m_ColorTo = clr3;

				p = PAdd();
				p.m_Flag |= C3DParticle.FlagContinue;
				p.m_Layer = 0;
				p.m_PosX = fx + dx * (dist - endl);
				p.m_PosY = fy + dy * (dist - endl);
				p.m_PosZ = fz;
				p.m_NormalX = nx;
				p.m_NormalY = ny;
				p.m_NormalZ = nz;
				p.m_DirX = dx;
				p.m_DirY = dy;
				p.m_DirZ = 0.0;
				p.m_Width = 15.0;
				p.m_Height = endl;
				p.m_U1 = 1197.0 / 2048;
				p.m_V1 = (1664.0 + 128.0 - 30.0) / 2048;
				p.m_U2 = (1197.0 + 30.0) / 2048;
				p.m_V2 = (1664.0 + 128.0) / 2048;
				p.m_Color = clr3;
				p.m_ColorTo = clr3;
			}
		}

		if (m_First == null) return;
		for (i = 0; i < 1;i++) {
			p = m_First;
			while (p != null) {
				if (p.m_Layer == i) p.m_Flag |= C3DParticle.FlagShow;
				else p.m_Flag &= ~C3DParticle.FlagShow;
				p = GraphPlanetParticle(p.m_Next);
			}
			
			if(i==0) m_First.ToQuadBatch(false, m_QuadBatchL0);
		}
	}
	
	public static function TexSun():C3DTexture
	{
		if (m_TexSun == null) m_TexSun = C3D.GetTexture("planet/sun.png");
		if (m_TexSun.tex == null) return null;
		return m_TexSun;
	}
	
	public static function PDraw(layer:int):void
	{
		if (m_First == null) return;

		if (TexSun() == null) return;

		C3D.SetVConstMatrix(0, EmpireMap.Self.m_MatViewPer);
		C3D.SetVConst_n(8, 0.0, 0.0, 0.0, 1.0);
		
		C3D.ShaderParticle();

		C3D.SetTexture(0, TexSun().tex);

		if(layer==0) C3D.VBQuadBatch(m_QuadBatchL0);

		C3D.DrawQuadBatch();

		C3D.SetTexture(0, null);
	}
}

}

import Engine.*;

class GraphPlanetParticle extends C3DParticle
{
	public var m_Layer:int;
	
	public function GraphPlanetParticle():void
	{
	}
}
