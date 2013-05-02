// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{

public class  C3DTextLine extends C3DQuadBatch
{
	static public const ToFloatClr:Number = 1.0 / 255.0;

	public var m_Text:String = null;
	public var m_FontName:String = null;
	public var m_Width:int = -1;
	public var m_WordWrap:Boolean = false;
	public var m_AlignX:int = 0; // -1=left 0=center 1=right 2=justify 3-justify all
	public var m_Indent:int = 0;
	
	public var m_Font:C3DFont = null;
	public var m_Color:uint = 0xffffffff;

	public var m_Chars:Vector.<C3DTextLineChar> = new Vector.<C3DTextLineChar>();
	
	public var m_MinY:int = 0;
	public var m_MaxX:int = 0;
	public var m_MaxY:int = 0;
	public var m_LineCnt:int = 0;
	public var m_SizeX:int = 0;
	public var m_SizeY:int = 0;
	
	static public var m_TagFontClr:uint = 0;
	static public var m_TagStack:Vector.<C3DTextLineStack> = new Vector.<C3DTextLineStack>();

	public function C3DTextLine():void
	{
	}
	
	override public function free():void
	{
		super.free();
		Clear();
	}
	
	public function SetFont(str:String):void
	{
		if (m_FontName == str) return;
		m_FontName = str;
		m_Font = null;
		Clear();
	}

	public function SetColor(clr:uint):void
	{
		if (m_Color == clr) return;
		m_Color = clr;
		Clear();
	}

	public function SetText(str:String):void
	{
		if (m_Text == str) return;
		m_Text = str;
		Clear();
	}

	public function SetFormat(ax:int = -1, width:int = -1, word_wrap:Boolean = false, indent:int = 0):void
	{
		if ((m_Width == width) && (m_WordWrap == word_wrap) && (m_AlignX == ax) && (m_Indent == indent)) return;
		m_Width = width;
		m_WordWrap = word_wrap;
		m_AlignX = ax;
		m_Indent = indent;
		Clear();
	}

	public function Clear():void
	{
		m_Chars.length = 0;
		m_MinY = 0;
		m_MaxX = 0;
		m_MaxY = 0;
		m_LineCnt = 0;
		m_SizeX = 0;
		m_SizeY = 0;
	}
	
	public function IsWordEq(off:int, len:int, lc:String, uc:String):Boolean
	{
		if (len != lc.length) return false;
		var i:int, ch:int;
		for (i = 0; i < len; i++) {
			ch = m_Text.charCodeAt(off + i);
			if (ch != lc.charCodeAt(i) && ch != uc.charCodeAt(i)) return false;
		}
		return true;
	}

	public function ParseClr(off:int, len:int):uint
	{
		var ch:int;
		if (len <= 0) return 0xffffffff;
		
		if (m_Text.charCodeAt(off) == 35) { // #
			off++; len--;
			var clr:uint = 0;
			var alpha255:Boolean = len <= 6;
			while (len > 0) {
				ch = m_Text.charCodeAt(off);
				off++; len--;
				if (ch >= 48 && ch <= 57) clr = (clr << 4) + (ch - 48); // 0-9
				else if (ch >= 65 && ch <= 70) clr = (clr << 4) + (ch - 65 + 10); // A-F
				else if (ch >= 97 && ch <= 102) clr = (clr << 4) + (ch - 97 + 10); // a-f
			}
			if (alpha255) clr |= 0xff000000;
			return clr;
		}
		else if (IsWordEq(off, len, "clr", "CLR")) return 0xffffff00;
		else if (IsWordEq(off, len, "crt", "CRT")) return 0xffff4040;
		
		else if (IsWordEq(off, len, "red", "RED")) return 0xffff0000;
		else if (IsWordEq(off, len, "blue", "BLUE")) return 0xff0000ff;
		else if (IsWordEq(off, len, "green", "GREEN")) return 0xff00ff00;
		else if (IsWordEq(off, len, "yellow", "YELLOW")) return 0xffffff00;
		else if (IsWordEq(off, len, "black", "BLACK")) return 0xff000000;
		else if (IsWordEq(off, len, "white", "WHITE")) return 0xffffffff;

		return 0xffffffff;
	}
	
	public function ParseTagFont(off:int):int
	{
		m_TagFontClr = 0;
		
		var ch:int, kl:int, ko:int, vo:int, vl:int, vladd:int, opentype:int;
		var tl:int = 0;
		var len:int = m_Text.length - off;
		if (len <= 0) return 0;	ch = m_Text.charCodeAt(off); if (ch != 60) return 0; tl++; off++; len--; // <
		if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 70 && ch != 102) return 0; tl++; off++; len--; // f
		if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 79 && ch != 111) return 0; tl++; off++; len--; // o
		if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 78 && ch != 110) return 0; tl++; off++; len--; // n
		if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 84 && ch != 116) return 0; tl++; off++; len--; // t
		
		while (len > 0) {
			 // space
			while (len > 0) { ch = m_Text.charCodeAt(off); if (ch != 32 && ch != 9) break; tl++; off++; len--; }
			
			// End
			ch = m_Text.charCodeAt(off);
			if (ch == 62) { // >
				return tl + 1;
			}
			// key
			ko = off;
			kl = 0;
			while (kl < len) {
				ch = m_Text.charCodeAt(off + kl);
				if ((ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122) || ch==95 || ch==45) { // A-Z a-z _ -
					kl++;
					continue;
				}
				break;
			}
			if (kl <= 0) return 0;
			tl += kl; off += kl; len -= kl;

			 // space
			while (len > 0) { ch = m_Text.charCodeAt(off); if (ch != 32 && ch != 9) break; tl++; off++; len--; }
			
			 // =
			if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 61) return 0; tl++; off++; len--;

			// space
			while (len > 0) { ch = m_Text.charCodeAt(off); if (ch != 32 && ch != 9) break; tl++; off++; len--; }

			// val
			opentype = 0;
			if (len <= 0) return 0;
			ch = m_Text.charCodeAt(off);
			if (ch == 39) { opentype = 1; tl++; off++; len--; } // '
			else if (ch == 34)  { opentype = 2; tl++; off++; len--; } // "

			vo = off;
			vl = 0;
			vladd = 0;
			while (vl < len) {
				ch = m_Text.charCodeAt(off + vl);
				if (opentype == 0 && (ch == 32 || ch == 9 || ch==62)) { break; } // space tab >
				else if (opentype == 1 && ch == 39) { vladd = 1; break; }
				else if (opentype == 2 && ch == 34) { vladd = 1; break; }
				vl++;
			}
			if (vl >= len) return 0;
			tl += vl + vladd; off += vl + vladd; len -= vl + vladd;

			// color
			if (IsWordEq(ko, kl, "color", "COLOR")) {
				m_TagFontClr = ParseClr(vo, vl);
			}
		}
		
		
		return 0;
	}
	
	public function ParseTagFontEnd(off:int):int
	{
		var ch:int;
		var tl:int = 0;
		var len:int = m_Text.length - off;
		if (len <= 0) return 0;	ch = m_Text.charCodeAt(off); if (ch != 60) return 0; tl++; off++; len--; // <
		if (len <= 0) return 0;	ch = m_Text.charCodeAt(off); if (ch != 47) return 0; tl++; off++; len--; // /
		if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 70 && ch != 102) return 0; tl++; off++; len--; // f
		if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 79 && ch != 111) return 0; tl++; off++; len--; // o
		if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 78 && ch != 110) return 0; tl++; off++; len--; // n
		if (len <= 0) return 0; ch = m_Text.charCodeAt(off); if (ch != 84 && ch != 116) return 0; tl++; off++; len--; // t
		if (len <= 0) return 0;	ch = m_Text.charCodeAt(off); if (ch != 62) return 0; tl++; off++; len--; // >
		return tl;
	}
	
	public function Prepare():void
	{
		if (m_Chars.length > 0) return;
		if (m_Text == null || m_Text.length <= 0 || m_FontName == null || m_FontName.length <= 0) return;

		if (m_Font == null) {
			m_Font = C3D.GetFont(m_FontName);
			if (m_Font == null) return;
		}

		var i:int, u:int, k:int, cnt:int, sx:int, ax:int, spacecnt:int, taglen:int;
		var ch:C3DTextLineChar;

		var cx:int = m_Indent;
		var cy:int = 0;
		
		var prevcc:int = 0;

		var first:Boolean = true;

		var curclr:uint = m_Color;
		var stackcnt:int = 0;
		
		var drawcnt:int = 0;

		m_LineCnt = 1;
		m_MaxX = 0;
		var spacebegin:int = -1;
		var wordbegin:int = -1;
		for (i = 0; i < m_Text.length; i++) {
			var cc:int = m_Text.charCodeAt(i);

			if (cc == 60 && (taglen = ParseTagFont(i)) != 0) {
				if (stackcnt >= m_TagStack.length) m_TagStack.push(new C3DTextLineStack());
				m_TagStack[stackcnt].m_Tag = 1;
				m_TagStack[stackcnt].m_Clr = curclr;
				stackcnt++;
				curclr = m_TagFontClr;
				i += taglen - 1;
				continue;
			} else if (cc == 60 && (taglen = ParseTagFontEnd(i)) != 0) {
				if (stackcnt > 0 && m_TagStack[stackcnt - 1].m_Tag == 1) {
					curclr = m_TagStack[stackcnt - 1].m_Clr;
					stackcnt--;
				}
				i += taglen - 1;
				continue;
			}

			if (cc != 10 && m_Font.m_GlyphMap[cc] == undefined) continue;

			ch = new C3DTextLineChar();
			m_Chars.push(ch);
			ch.m_Char = cc;
			ch.m_Line = m_LineCnt - 1;

			if (cc == 10) {
				m_LineCnt++;
				spacebegin = -1;
				wordbegin = -1;
				first = true;
				prevcc = 0;
				cx = 0;
				cy += m_Font.lineHeight;
				continue;
			}

			drawcnt++;

			ch.m_Glyph = m_Font.m_GlyphMap[ch.m_Char];
			ch.m_Color = curclr;

			if (first) {
				first = false;
				//m_LineCnt++;
			}

			ch.m_X = cx;
			ch.m_Y = cy;
			if (prevcc != 0 && m_Font.m_KerningMap[(prevcc << 16) | cc] != undefined) {
				ch.m_X += m_Font.m_KerningMap[(prevcc << 16) | cc];
			}
			
			m_MaxX = Math.max(m_MaxX, ch.m_X + ch.m_Glyph.xoffset + ch.m_Glyph.width);

			cx += ch.m_Glyph.xadvance;

			prevcc = cc;

			if (cc == 32) {
				if (wordbegin >= 0) { wordbegin = -1; spacebegin = m_Chars.length - 1; }
				else if(spacebegin<0) spacebegin = m_Chars.length - 1;
				continue;
			}
			if (wordbegin < 0) wordbegin = m_Chars.length - 1;

			if (m_WordWrap && m_Width >= 0 && (ch.m_X + ch.m_Glyph.xoffset + ch.m_Glyph.width)>m_Width && wordbegin >= 0 && spacebegin >= 0) {
				sx = m_Chars[wordbegin].m_X;
				for (u = wordbegin; u < m_Chars.length; u++) {
					m_Chars[u].m_X -= sx;
					m_Chars[u].m_Y += m_Font.lineHeight;;
					m_Chars[u].m_Line++;
				}
				//for (u = wordbegin - 1; u >= spacebegin; u--) {
				if ((spacebegin + 1) < wordbegin) m_Chars.splice(spacebegin, wordbegin - (spacebegin+1));

				m_Chars[spacebegin].m_Char = -1;
				m_Chars[spacebegin].m_Glyph = null;
				
				m_LineCnt++;
				cx -= sx;
				cy += m_Font.lineHeight;
				spacebegin = -1;
				wordbegin = -1;
			}
		}
		
		m_SizeX = m_MaxX;
		if (m_Width > m_SizeX) m_SizeX = m_Width;
		u = 0;
		var linecnt:int = 0;
		while (u < m_Chars.length) {
			cnt = 0;
			sx = 0;
			spacecnt = 0;
			while (u + cnt < m_Chars.length) {
				ch = m_Chars[u + cnt];
//if(ch.m_Line != linecnt) { trace("ERR");  throw Error("ERR"); }
				if (ch.m_Char == 10 || ch.m_Char == -1) break;
				cnt++;
				sx = Math.max(sx, ch.m_X + ch.m_Glyph.xoffset + ch.m_Glyph.width);
				if (ch.m_Char == 32 || ch.m_Char == 9) spacecnt++;
			}
			linecnt++;

			if(m_AlignX == 0 || m_AlignX == 1) {
				if (m_AlignX == 1) sx = m_SizeX - sx;
				else if (m_AlignX == 0) sx = (m_SizeX - sx) >> 1;
				if (sx > 0) {
					for (i = 0; i < cnt; i++) {
						ch = m_Chars[u + i];
						ch.m_X += sx;
					}
				}
			} else if (((m_AlignX == 2 && linecnt != m_LineCnt) || m_AlignX == 3) && sx < m_SizeX && spacecnt > 0) {
				ax = (m_SizeX - sx) % spacecnt;
				sx = Math.floor((m_SizeX - sx) / spacecnt);
				k = 0;
				spacecnt = 0;
				for (i = 0; i < cnt; i++) {
					ch = m_Chars[u + i];
					ch.m_X += k;
					if (ch.m_Char == 32 || ch.m_Char == 9) {
						k += sx;
						if (spacecnt < ax) k++;
						spacecnt++;
					}
				}
			}
			
			u += cnt + 1;
		}

		var ncnt:int;
		var alignshift:int = 0;

		if (m_Stride != 8) {
			ncnt = ((/*m_Chars.length*/drawcnt >> alignshift) << alignshift);
			if ((ncnt & ((1 << alignshift) - 1)) != 0) ncnt += 1 << alignshift;

			Init(ncnt, 2, 0, 2, 4);
		}

		if (/*m_Chars.length*/drawcnt > m_Cnt) {
			ncnt = ((drawcnt >> alignshift) << alignshift);
			if ((ncnt & ((1 << alignshift) - 1)) != 0) ncnt += 1 << alignshift;
			ChangeCnt(ncnt);
		}
//trace("TL.Prepare00", m_Chars.length, drawcnt, m_Cnt);

		if (m_Data == null) return;
		var d:Vector.<Number> = m_Data;

		cnt = 0;
		var off:int = 0;

		//m_MinX = 0;
		m_MinY = 0;
		//m_MaxX = 0;
		m_MaxY = 0;
		first = true;
		
		var clrr:Number, clrg:Number, clrb:Number, clra:Number;

		for (i = 0; i < m_Chars.length; i++) {
			ch = m_Chars[i];
			ch.m_Quad = cnt >> 2;
			if (ch.m_Glyph == null) continue;

			if (first) {
				first = false;
//				m_MinX = ch.m_X + ch.m_Glyph.xoffset;
				m_MinY = ch.m_Y + ch.m_Glyph.yoffset;
//				m_MaxX = ch.m_X + ch.m_Glyph.xoffset + ch.m_Glyph.width;
				m_MaxY = ch.m_Y + ch.m_Glyph.yoffset + ch.m_Glyph.height;
			} else {
//				m_MinX = Math.min(m_MinX,ch.m_X + ch.m_Glyph.xoffset);
				m_MinY = Math.min(m_MinY,ch.m_Y + ch.m_Glyph.yoffset);
//				m_MaxX = Math.max(m_MaxX,ch.m_X + ch.m_Glyph.xoffset + ch.m_Glyph.width);
				m_MaxY = Math.max(m_MaxY,ch.m_Y + ch.m_Glyph.yoffset + ch.m_Glyph.height);
			}
			
			clrr = ToFloatClr * ((ch.m_Color >> 16) & 255);
			clrg = ToFloatClr * ((ch.m_Color >> 8) & 255);
			clrb = ToFloatClr * ((ch.m_Color >> 0) & 255);
			clra = ToFloatClr * ((ch.m_Color >> 24) & 255);

			// 1
			d[off++] = ch.m_X + ch.m_Glyph.xoffset;
			d[off++] = -(ch.m_Y + ch.m_Glyph.yoffset);
			d[off++] = Number(ch.m_Glyph.x) / m_Font.scaleW;
			d[off++] = Number(ch.m_Glyph.y) / m_Font.scaleH;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 2
			d[off++] = ch.m_X + ch.m_Glyph.xoffset + ch.m_Glyph.width;
			d[off++] = -(ch.m_Y + ch.m_Glyph.yoffset);
			d[off++] = Number(ch.m_Glyph.x + ch.m_Glyph.width) / m_Font.scaleW;
			d[off++] = Number(ch.m_Glyph.y) / m_Font.scaleH;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 3
			d[off++] = ch.m_X + ch.m_Glyph.xoffset + ch.m_Glyph.width;
			d[off++] = -(ch.m_Y + ch.m_Glyph.yoffset + ch.m_Glyph.height);
			d[off++] = Number(ch.m_Glyph.x + ch.m_Glyph.width) / m_Font.scaleW;
			d[off++] = Number(ch.m_Glyph.y + ch.m_Glyph.height) / m_Font.scaleH;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 4
			d[off++] = ch.m_X + ch.m_Glyph.xoffset;
			d[off++] = -(ch.m_Y + ch.m_Glyph.yoffset + ch.m_Glyph.height);
			d[off++] = Number(ch.m_Glyph.x) / m_Font.scaleW;
			d[off++] = Number(ch.m_Glyph.y + ch.m_Glyph.height) / m_Font.scaleH;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			cnt += 4;
			if (cnt >= (drawcnt << 2)) break;
		}
		m_SizeY = m_LineCnt * m_Font.lineHeight;

		cnt = d.length - off;
		while (cnt>0) {
			d[off++] = 0;
			cnt--;
		}

		Apply();
	}

	public function Draw(linefrom:int, linecnt:int, x:Number, y:Number, ax:int = 1, ay:int = 1, clr:uint = 0xffffffff, outline:uint = 0xffffffff):void
	{
		Prepare();
		if (m_Chars.length <= 0) return;
		if (m_Font.m_Texture.tex == null) return;

		var quadbegin:int = -1;
		var quadend:int = -1;
		if (linefrom != 0 || linecnt >= 0) {
			if (linefrom < 0) linefrom = 0;
			else if (linefrom >= m_LineCnt) linefrom = m_LineCnt - 1;
			if (linecnt < 0) linecnt = m_LineCnt - linefrom;
			if (linefrom + linecnt > m_LineCnt) m_LineCnt = m_LineCnt - linefrom;
			if (linecnt <= 0) return;

			var ch:C3DTextLineChar;
			var i:int;
			for (i = 0; i < m_Chars.length; i++) {
				ch = m_Chars[i];
				if (ch.m_Glyph == null) continue;
				if (ch.m_Line >= linefrom) {
					quadbegin = m_Chars[i].m_Quad;
					break;
				}
			}
			for (; i < m_Chars.length; i++) {
				ch = m_Chars[i];
				if (ch.m_Glyph == null) continue;
				if (ch.m_Line >= (linefrom + linecnt)) break;
				quadend = ch.m_Quad;
			}
			if (quadbegin < 0 || quadend < 0) return;
		}

		if (ax < 0) x -= m_SizeX;
		else if (ax == 0) x -= Math.floor(m_SizeX / 2);

		if (ay < 0) y -= m_SizeY;
		else if (ay == 0) y -= Math.floor(m_SizeY / 2);

		C3D.SetVConst_n(0, x - C3D.m_SizeX * 0.5, -(y - C3D.m_SizeY * 0.5), 2.0 / C3D.m_SizeX, 2.0 / C3D.m_SizeY);
		C3D.SetVConst_n(1, 0.0, 0.5, 1.0, 2.0);

		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(1, ((clr >> 16) & 255) / 255.0, ((clr >> 8) & 255) / 255.0, ((clr) & 255) / 255.0, ((clr >> 24) & 255) / 255.0);
		C3D.SetFConst_n(2, ((outline >> 16) & 255) / 255.0, ((outline >> 8) & 255) / 255.0, ((outline) & 255) / 255.0, ((outline >> 24) & 255) / 255.0);

		C3D.ShaderText(m_Font.outline);
		C3D.VBQuadBatch(this);
		C3D.SetTexture(0, m_Font.m_Texture.tex);
		if(quadbegin<0) C3D.DrawQuadBatch();
		else C3D.DrawQuadBatch(quadbegin, quadend - quadbegin + 1);
		C3D.SetTexture(0, null);
	}
}

}

import Engine.*;

class C3DTextLineChar
{
	public var m_Char:int = 0; // -1=принудительный перевод строки
	public var m_X:int = 0;
	public var m_Y:int = 0;
	public var m_Glyph:C3DFontGlyph = null;
	public var m_Line:int = 0;
	public var m_Quad:int = 0;
	public var m_Color:uint = 0;
	
	public function C3DTextLineChar():void
	{
	}
}
