// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import flash.display.*;
import flash.display3D.textures.Texture;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class GraphItem
{
	private var m_Map:EmpireMap;

	public var m_Type:int;
	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_ShipNum:int;
	
	public var m_PosX:Number;
	public var m_PosY:Number;
	
	public var m_ImgNum:int = 0;

	public var m_Tmp:int;

	public var m_CntVal:String = null;

	public static var m_TextQB:C3DQuadBatch = null;
	public static var m_TextOff:int = 0;
	public static var m_TextState:C3DState = null;

	public function GraphItem(map:EmpireMap)
	{
		m_Map=map;
	}

	public function Clear():void
	{
	}

	public function Update():void
	{
		var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if(planet==null) return;
		m_Map.CalcShipPlaceEx(planet, m_ShipNum, EmpireMap.m_TPos);
		m_PosX = EmpireMap.m_TPos.x;
		m_PosY = EmpireMap.m_TPos.y;

/*		x = m_Map.WorldToScreenX(ra[0], ra[1]);
		y = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(ra[1]);*/
	}

	public function SetCnt(i:String):void
	{
		if (m_CntVal == i) return;
		
		if (i == null || i.length <= 0) {
			m_CntVal = null;
		} else {
			if (m_CntVal != i) m_CntVal = i;
		}
	}

	public function SetColor(clr:uint):void
	{
		//m_Cnt.backgroundColor=clr;
	}

	public function SetType(type:int):void
	{
		if(m_Type==type) return;
		m_Type = type;
		m_ImgNum = 0;

		var idesc:Item = UserList.Self.GetItem(type);
		if (idesc == null) { m_Type = 0; return; }
		m_ImgNum = idesc.m_Img;
	}

	public static function GetImageByType(type:uint):Sprite
	{
		var idesc:Item = UserList.Self.GetItem(type & 0xffff);
		if (idesc == null) return null;
		
		return Common.ItemImgVec(idesc.m_Img);
	}
	
	public static function PrepareTextBegin():void
	{
		GraphShip.PrepareTex();

		if (m_TextQB == null) {
			m_TextQB = new C3DQuadBatch();
			m_TextQB.Init(128, 2, 0, 2, 4);
		}
		if (m_TextState == null) {
			m_TextState = new C3DState();
		}
		m_TextOff = 0;
		m_TextState.Clear();
	}

	public static function PrepareTextEnd():void
	{
		var cnt:int;
		var d:Vector.<Number> = m_TextQB.m_Data;
		var off:int = m_TextOff * 8 * 4;
		cnt = d.length - off;
		while (cnt>0) {
			d[off++] = 0;
			cnt--;
		}
		m_TextQB.Apply();
	}

	public static function TextStr(small:Boolean, px:Number, py:Number, str:String, clr:uint):void
	{
		if (str == null) return;
		var cnt:int = str.length;
		if (cnt <= 0) return;

		if ((m_TextOff + cnt) > m_TextQB.m_Cnt) {
			m_TextQB.ChangeCnt(m_TextOff + 128);
		}
		
		if (m_TextState.m_Last == null || m_TextState.m_Last.m_TexRaw != GraphShip.m_TextTex) { m_TextState.Add().m_Off = m_TextOff; m_TextState.m_Last.m_TexRaw = GraphShip.m_TextTex; }

		var ch:int, i:int, u:int, tx:int, ty:int, ttx:int, tty:int;
		var ttw:Number, tth:Number;

		var d:Vector.<Number> = m_TextQB.m_Data;
		
		var off:int = m_TextOff * 8 * 4;

		var clrr:Number, clrg:Number, clrb:Number, clra:Number;
		clrr = C3D.ClrToFloat * ((clr >> 16) & 255);
		clrg = C3D.ClrToFloat * ((clr >> 8) & 255);
		clrb = C3D.ClrToFloat * ((clr >> 0) & 255);
		clra = C3D.ClrToFloat * ((clr >> 24) & 255);

		for (i = 0; i < cnt; i++) {
			ch = str.charCodeAt(i);
			
			if (ch >= 48 && ch <= 57) u = ch - 48; // 0-9
			else if (ch == 37) u = 10; // %
			else if (ch == 45) u = 11; // -
			else continue;

			tx = Math.floor(px);
			ty = Math.floor(py);
			
			ttx = Math.round((px - tx) * 8.0);
			tty = Math.round((py - ty) * 8.0);
			if (ttx >= 8) { tx++; ttx = 0; }
			if (tty >= 8) { ty++; tty = 0; }
			ttx = (ttx + tty * 8) * 16;
			tty = (u + (small?12:0)) * 16;

			if (small) {
				ttw = GraphShip.m_TextWidthSmall[u];
				tth = GraphShip.m_TextHeightSmall;
			} else {
				ttw = GraphShip.m_TextWidth[u];
				tth = GraphShip.m_TextHeight;
			}

			// 1
			d[off++] = tx;
			d[off++] = -ty;
			d[off++] = (ttx) / GraphShip.m_TextTexWidth;
			d[off++] = (tty) / GraphShip.m_TextTexHeight;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 2
			d[off++] = ttw + tx;
			d[off++] = -ty;
			d[off++] = (ttw + ttx) / GraphShip.m_TextTexWidth;
			d[off++] = (tty) / GraphShip.m_TextTexHeight;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 3
			d[off++] = ttw + tx;
			d[off++] = -(tth + ty);
			d[off++] = (ttw + ttx) / GraphShip.m_TextTexWidth;
			d[off++] = (tth + tty) / GraphShip.m_TextTexHeight;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 4
			d[off++] = tx;
			d[off++] = -(tth + ty);
			d[off++] = (ttx) / GraphShip.m_TextTexWidth;
			d[off++] = (tth + tty) / GraphShip.m_TextTexHeight;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			if(small) px += GraphShip.m_TextXAdvanceSmall[u];
			else px += GraphShip.m_TextXAdvance[u];
			m_TextOff++;
			m_TextState.m_Last.m_Cnt++;
		}
	}
	
	public static function TextRect(px:Number, py:Number, width:Number, height:Number, clr:uint):void
	{
		if ((m_TextOff + 1) > m_TextQB.m_Cnt) {
			m_TextQB.ChangeCnt(m_TextOff + 128);
		}
		
		if (m_TextState.m_Last == null || m_TextState.m_Last.m_TexRaw != GraphShip.m_TextTex) { m_TextState.Add().m_Off = m_TextOff; m_TextState.m_Last.m_TexRaw = GraphShip.m_TextTex; }

		var d:Vector.<Number> = m_TextQB.m_Data;
		
		var off:int = m_TextOff * 8 * 4;

		var clrr:Number, clrg:Number, clrb:Number, clra:Number;
		clrr = C3D.ClrToFloat * ((clr >> 16) & 255);
		clrg = C3D.ClrToFloat * ((clr >> 8) & 255);
		clrb = C3D.ClrToFloat * ((clr >> 0) & 255);
		clra = C3D.ClrToFloat * ((clr >> 24) & 255);

		// 1
		d[off++] = px;
		d[off++] = -py;
		d[off++] = (2) / GraphShip.m_TextTexWidth;
		d[off++] = (496.0 + 2) / GraphShip.m_TextTexHeight;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 2
		d[off++] = width + px;
		d[off++] = -py;
		d[off++] = (3.0) / GraphShip.m_TextTexWidth;
		d[off++] = (496.0 + 2) / GraphShip.m_TextTexHeight;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 3
		d[off++] = width + px;
		d[off++] = -(height + py);
		d[off++] = (3.0) / GraphShip.m_TextTexWidth;
		d[off++] = (496.0 + 3) / GraphShip.m_TextTexHeight;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 4
		d[off++] = px;
		d[off++] = -(height + py);
		d[off++] = (2.0) / GraphShip.m_TextTexWidth;
		d[off++] = (496.0 + 3) / GraphShip.m_TextTexHeight;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		m_TextOff++;
		m_TextState.m_Last.m_Cnt++;
	}

	public static function TextImg(tex:Texture, px:Number, py:Number, width:Number, height:Number, clr:uint, u1:Number = 0.0, v1:Number = 0.0, u2:Number = 1.0, v2:Number = 1.0):void
	{
		if ((m_TextOff + 1) > m_TextQB.m_Cnt) {
			m_TextQB.ChangeCnt(m_TextOff + 128);
		}
		
		if (m_TextState.m_Last == null || m_TextState.m_Last.m_TexRaw != tex) { m_TextState.Add().m_Off = m_TextOff; m_TextState.m_Last.m_TexRaw = tex; }

		var d:Vector.<Number> = m_TextQB.m_Data;
		
		var off:int = m_TextOff * 8 * 4;

		var clrr:Number, clrg:Number, clrb:Number, clra:Number;
		clrr = C3D.ClrToFloat * ((clr >> 16) & 255);
		clrg = C3D.ClrToFloat * ((clr >> 8) & 255);
		clrb = C3D.ClrToFloat * ((clr >> 0) & 255);
		clra = C3D.ClrToFloat * ((clr >> 24) & 255);

		// 1
		d[off++] = px;
		d[off++] = -py;
		d[off++] = u1;
		d[off++] = v1;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 2
		d[off++] = width + px;
		d[off++] = -py;
		d[off++] = u2;
		d[off++] = v1;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 3
		d[off++] = width + px;
		d[off++] = -(height + py);
		d[off++] = u2;
		d[off++] = v2;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 4
		d[off++] = px;
		d[off++] = -(height + py);
		d[off++] = u1;
		d[off++] = v2;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		m_TextOff++;
		m_TextState.m_Last.m_Cnt++;
	}

	public function PrepareText():void
	{
		var clr:uint;
		var px:Number, py:Number, tx:Number, ty:Number, v:Number, k:Number;
		var texr:Texture;

		var planet:Planet = EmpireMap.Self.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;
		EmpireMap.Self.CalcShipPlaceEx(planet, m_ShipNum, EmpireMap.m_TPos);
		
		px = m_Map.WorldToScreenX(EmpireMap.m_TPos.x, EmpireMap.m_TPos.y);
		py = EmpireMap.m_TWSPos.y;
		
		var ww:Number = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
		if (ww > 1.0) ww = 1.0;

		while (m_ImgNum != 0) {
			texr = Common.ItemTex(m_ImgNum);
			if (texr == null) break;

			v = ww * 64 * Common.ItemScale(m_ImgNum);

			clr = C3D.ClrReplaceAlpha(0xffffff, 1.0, true);
			TextImg(texr, px - (v * 0.5), py - (v * 0.5), v, v, clr);

			break;
		}
		
		// Cnt
		if (m_CntVal != null && m_CntVal.length > 0) {
			k = GraphShip.TextWidth(true, m_CntVal);

			tx = px - ww * 15 - (k >> 1);
			ty = py - ww * 15 - (GraphShip.m_TextHeightSmall >> 1);

			clr = C3D.ClrReplaceAlpha(0x202020, 1.0, true);
			TextRect(tx, ty - 1, k, GraphShip.m_TextHeightSmall + 2, clr);

			clr = C3D.ClrReplaceAlpha(0xffffff, 1.0, true);
			TextStr(true, tx, ty, m_CntVal, clr);
		}
	}

	public static function DrawText():void
	{
		if (m_TextOff <= 0) return;

		var x:Number = 0;
		var y:Number = 0;

		C3D.SetVConst_n(0, x - C3D.m_SizeX * 0.5, -(y - C3D.m_SizeY * 0.5), 2.0 / C3D.m_SizeX, 2.0 / C3D.m_SizeY);
		C3D.SetVConst_n(1, 0.0, 0.5, 1.0, 2.0);

		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(1, 1.0, 1.0, 1.0, 1.0);
		C3D.SetFConst_n(2, 1.0, 1.0, 1.0, 1.0);

		C3D.ShaderText(false, true);
		C3D.VBQuadBatch(m_TextQB);
		var sb:C3DStateBatch = m_TextState.m_First;
		while(sb!=null) {
			C3D.SetTexture(0, sb.m_TexRaw);
			C3D.DrawQuadBatch(sb.m_Off, sb.m_Cnt);
			sb = sb.m_Next;
		}
		C3D.SetTexture(0, null);
	}
}

}