// Copyright (C) 2013 Elemental Games. All rights reserved.

package B3DEffect
{
import Base.*;
import Engine.*;
import fl.controls.ComboBox;
import fl.controls.TextArea;
import fl.controls.TextInput;
import flash.display.DisplayObject;
import flash.events.*;
import flash.geom.Vector3D;
import flash.utils.Dictionary;

public class StyleManager
{
	static public var m_Map:Dictionary = null;
	static public var m_TextureMap:Dictionary = null;

	static public var m_EditId:String = "";

	static public const PagesPerEmitter:int = 4;

	static public var m_EditStyle:String = "";

	static public function prepare():Boolean
	{
		if (m_Map != null) return true;

		var src:String = LoadManager.Self.Get("effect/cfg.txt") as String;
		if (src == null) return false;

		m_Map = new Dictionary();
		m_TextureMap = new Dictionary();
		Load(src);

/*		var ts:TextureStyle;
		var ims:ImgStyle;

		ts = new TextureStyle(); ts.m_Id = "motor0"; m_TextureMap[ts.m_Id] = ts; ts.m_Path = "empire/effect/motor0.png";
			ims = new ImgStyle(); ims.m_Id = "00"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.0,  0.0,  0.25, 0.25);
			ims = new ImgStyle(); ims.m_Id = "10"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.25, 0.0,  0.5,  0.25);
			ims = new ImgStyle(); ims.m_Id = "20"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.5,  0.0,  0.75, 0.25);
			ims = new ImgStyle(); ims.m_Id = "30"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.75, 0.0,  1.0,  0.25);
			ims = new ImgStyle(); ims.m_Id = "01"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.0,  0.25, 0.25, 0.5);
			ims = new ImgStyle(); ims.m_Id = "11"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.25, 0.25, 0.5,  0.5);
			ims = new ImgStyle(); ims.m_Id = "21"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.5,  0.25, 0.75, 0.5);
			ims = new ImgStyle(); ims.m_Id = "31"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.75, 0.25, 1.0,  0.5);
			ims = new ImgStyle(); ims.m_Id = "02"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.0,  0.5,  0.25, 0.75);
			ims = new ImgStyle(); ims.m_Id = "12"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.25, 0.5,  0.5,  0.75);
			ims = new ImgStyle(); ims.m_Id = "22"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.5,  0.5,  0.75, 0.75);
			ims = new ImgStyle(); ims.m_Id = "32"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.75, 0.5,  1.0,  0.75);
			ims = new ImgStyle(); ims.m_Id = "03"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.0,  0.75, 0.25, 1.0);
			ims = new ImgStyle(); ims.m_Id = "13"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.25, 0.75, 0.5,  1.0);
			ims = new ImgStyle(); ims.m_Id = "23"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.5,  0.75, 0.75, 1.0);
			ims = new ImgStyle(); ims.m_Id = "33"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.75, 0.75, 1.0,  1.0);

		ts = new TextureStyle(); ts.m_Id = "laser0"; m_TextureMap[ts.m_Id] = ts; ts.m_Path = "empire/effect/laser0.png";
			ims = new ImgStyle(); ims.m_Id = "stream"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.0,  0.0,  0.5, 1.0);
			ims = new ImgStyle(); ims.m_Id = "00"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.5,  0.0,  0.75, 0.5);
			ims = new ImgStyle(); ims.m_Id = "10"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.75, 0.0,  1.0,  0.5);
			ims = new ImgStyle(); ims.m_Id = "20"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.5,  0.5,  0.75, 1.0);
			ims = new ImgStyle(); ims.m_Id = "30"; ts.m_ImgList.push(ims); ims.m_UVList.push(0.75, 0.5,  1.0,  1.0);*/

/*		var style:Style;
		var es:EmitterStyle;

		style = new Style();
		style.m_Texture = "laser0";
		es = new EmitterStyle();
		es.m_Img = "30";
		style.m_EmitterList.push(es);
		m_Map[1] = style;*/

		return true;
	}

	static public function Load(src:String):void
	{
		var i:int, u:int, k:int, type:int;
		var ibegin:int, iend:int;
		var ch:int;
		var len:int=src.length;
		var off:int = 0;
		var name:String, str:String;
		var style:Style = null;
		var emitter:EmitterStyle = null;
		var header:Boolean = false;
		var texture:TextureStyle = null;
		var imgstyle:ImgStyle = null;
		var line:int = 1;
		
		header = true;

		while(off<len) {
			while (off < len) { ch = src.charCodeAt(off); if (ch == 32 || ch == 9 || ch == 13) off++; else if (ch == 10) { off++; line++; } else break; }
			if(off>=len) break;

			ch=src.charCodeAt(off);
			if(ch==0x5b) { // []
				off++;
				while (off < len) { ch = src.charCodeAt(off); if (ch == 32 || ch == 9 || ch == 10) off++; else if (ch == 10) { off++; line++; } else break; }

				ibegin=off;
				while(off<len) { ch=src.charCodeAt(off); if(ch!=0x5D) off++; else break; }
				if(off>=len) break;

				iend=off; off++;
				while(iend>ibegin) { ch=src.charCodeAt(iend-1); if(ch==32 || ch==9 || ch==10 || ch==13) iend--; else break; }

				if (iend > ibegin) {
					u = src.indexOf(",", ibegin);
					name = null;
					if (u > ibegin && u < iend) {
						name = src.substring(u + 1, iend);
						iend = u;
					}
					
					if (iend > ibegin) {
						if (BaseStr.IsTagEq(src, ibegin, iend - ibegin, "texture", "TEXTURE") && name != null) {
							header = true;
							style = null;
							emitter = null;
							imgstyle = null;

							texture = new TextureStyle();
							texture.m_Id = name;
							m_TextureMap[texture.m_Id] = texture;
							
						} else if (BaseStr.IsTagEq(src, ibegin, iend - ibegin, "img", "IMG") && name != null && texture != null) {
							header = false;
							emitter = null;

							imgstyle = new ImgStyle();
							imgstyle.m_Id = name;
							texture.m_ImgList.push(imgstyle);

						} else if (BaseStr.IsTagEq(src, ibegin, iend - ibegin, "style", "STYLE") && name != null) {
							texture = null;
							header = true;
							emitter = null;
							imgstyle = null;

							style = new Style();
							style.m_Id = name;
							m_Map[style.m_Id] = style;

						} else if (BaseStr.IsTagEq(src, ibegin, iend - ibegin, "emitter", "EMITTER") && style!=null) {
							texture = null;
							header = true;
							imgstyle = null;

							emitter = new EmitterStyle();
							style.m_EmitterList.push(emitter);
						}
					} else { if(StdMap.Main) StdMap.Main.AddDebugMsg("Error load news: Unknown section."); return;  }
				}

			} else if(ch==0x2f) { // /
				off++; if(off>=len) break;
				if(src.charCodeAt(off)!=0x2f) continue;

				while (off < len) { ch = src.charCodeAt(off); if (ch != 10) off++; else break; }

			} else { // Par or Text
				ibegin = off;
				var par:Boolean = header;
				if(par) {
					while (ibegin < len) {
						ch = src.charCodeAt(ibegin);
						ibegin++;
						if (ch == 61) break;
						else if (ch == 32 || ch == 9 || ch==10) { par = false; break;  }
					}
					if (ibegin >= len) par = false;
				}

				if (par) {
					name = src.substring(off, ibegin-1);
					off = ibegin;

					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend = off;

					if (iend > ibegin && style == null && emitter == null && texture == null && imgstyle == null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.EqNCEng(name, "Edit")) m_EditStyle = str;
						
					} else if (iend > ibegin && texture != null && imgstyle == null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.EqNCEng(name, "Path")) texture.m_Path = str;
						else if (BaseStr.EqNCEng(name, "ChannelMask")) texture.m_ChannelMask = int(str) != 0;

					} else if(iend>ibegin && style!=null && emitter==null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.EqNCEng(name, "Texture")) style.m_Texture = str;
						else if (BaseStr.EqNCEng(name, "Sort")) style.m_Sort = int(str);
						else if (BaseStr.EqNCEng(name, "A")) style.m_A = Number(str);
						else if (BaseStr.EqNCEng(name, "B")) style.m_B = Number(str);

					} else if(iend>ibegin && style!=null && emitter!=null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.EqNCEng(name, "Img")) emitter.m_Img = str;
						else if (BaseStr.EqNCEng(name, "ImgCenter")) { ParseRange(str); emitter.m_ImgCenterX = m_ParseRangeV; emitter.m_ImgCenterY = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "ImgScale")) { ParseRange(str); emitter.m_ImgScaleX = m_ParseRangeV; emitter.m_ImgScaleY = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "ImgRnd")) emitter.m_ImgRnd = int(str) != 0;
						else if (BaseStr.EqNCEng(name, "ImgAnim")) emitter.m_ImgAnim = int(str) != 0;
						else if (BaseStr.EqNCEng(name, "ImgSpeed")) emitter.m_ImgSpeed = Number(str);
						else if (BaseStr.EqNCEng(name, "ImgDist")) emitter.m_ImgDist = Number(str);

						else if (BaseStr.EqNCEng(name, "PosType")) emitter.m_PosType = int(str);
						else if (BaseStr.EqNCEng(name, "PosPath")) emitter.m_PosPath = Number(str);

						else if (BaseStr.EqNCEng(name, "RadiusI")) { ParseRange(str); emitter.m_RadiusIV = m_ParseRangeV; emitter.m_RadiusID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "RadiusIG")) LoadVector(str, emitter.m_RadiusIG);
						else if (BaseStr.EqNCEng(name, "RadiusR")) { ParseRange(str); emitter.m_RadiusRV = m_ParseRangeV; emitter.m_RadiusRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "RadiusRG")) LoadVector(str, emitter.m_RadiusRG);
						else if (BaseStr.EqNCEng(name, "RadiusA")) { ParseExtFactor(str); emitter.m_RadiusAAdd = m_ParseExtFactorAdd; emitter.m_RadiusAMul = m_ParseExtFactorMul; emitter.m_RadiusAPow = m_ParseExtFactorPow; }
						else if (BaseStr.EqNCEng(name, "RadiusB")) { ParseExtFactor(str); emitter.m_RadiusBAdd = m_ParseExtFactorAdd; emitter.m_RadiusBMul = m_ParseExtFactorMul; emitter.m_RadiusBPow = m_ParseExtFactorPow; }

						else if (BaseStr.EqNCEng(name, "AngleI")) { ParseRange(str); emitter.m_AngleIV = m_ParseRangeV; emitter.m_AngleID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "AngleIG")) LoadVector(str, emitter.m_AngleIG);
						else if (BaseStr.EqNCEng(name, "AngleR")) { ParseRange(str); emitter.m_AngleRV = m_ParseRangeV; emitter.m_AngleRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "AngleRG")) LoadVector(str, emitter.m_AngleRG);

						else if (BaseStr.EqNCEng(name, "RotateI")) { ParseRange(str); emitter.m_RotateIV = m_ParseRangeV; emitter.m_RotateID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "RotateIG")) LoadVector(str, emitter.m_RotateIG);
						else if (BaseStr.EqNCEng(name, "RotateR")) { ParseRange(str); emitter.m_RotateRV = m_ParseRangeV; emitter.m_RotateRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "RotateRG")) LoadVector(str, emitter.m_RotateRG);

						else if (BaseStr.EqNCEng(name, "OffsetI")) { ParseRange(str); emitter.m_OffsetIV = m_ParseRangeV; emitter.m_OffsetID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "OffsetIG")) LoadVector(str, emitter.m_OffsetIG);
						else if (BaseStr.EqNCEng(name, "OffsetR")) { ParseRange(str); emitter.m_OffsetRV = m_ParseRangeV; emitter.m_OffsetRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "OffsetRG")) LoadVector(str, emitter.m_OffsetRG);
						else if (BaseStr.EqNCEng(name, "OffsetO")) { ParseRange(str); emitter.m_OffsetOV = m_ParseRangeV; emitter.m_OffsetOD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "OffsetOG")) LoadVector(str, emitter.m_OffsetOG);
						else if (BaseStr.EqNCEng(name, "OffsetA")) { ParseExtFactor(str); emitter.m_OffsetAAdd = m_ParseExtFactorAdd; emitter.m_OffsetAMul = m_ParseExtFactorMul; emitter.m_OffsetAPow = m_ParseExtFactorPow; }
						else if (BaseStr.EqNCEng(name, "OffsetB")) { ParseExtFactor(str); emitter.m_OffsetBAdd = m_ParseExtFactorAdd; emitter.m_OffsetBMul = m_ParseExtFactorMul; emitter.m_OffsetBPow = m_ParseExtFactorPow; }

						else if (BaseStr.EqNCEng(name, "Period")) emitter.m_Period = int(str);
						else if (BaseStr.EqNCEng(name, "Loop")) emitter.m_Loop = int(str) != 0;
						else if (BaseStr.EqNCEng(name, "FirstFrame")) emitter.m_FirstFrame = int(str) != 0;
 						
						else if (BaseStr.EqNCEng(name, "AmountI")) { ParseRange(str); emitter.m_AmountIV = m_ParseRangeV; emitter.m_AmountID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "AmountIG")) LoadVector(str, emitter.m_AmountIG);
						else if (BaseStr.EqNCEng(name, "AmountR")) { ParseRange(str); emitter.m_AmountRV = m_ParseRangeV; emitter.m_AmountRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "AmountRG")) LoadVector(str, emitter.m_AmountRG);
						else if (BaseStr.EqNCEng(name, "AmountA")) { ParseExtFactor(str); emitter.m_AmountAAdd = m_ParseExtFactorAdd; emitter.m_AmountAMul = m_ParseExtFactorMul; emitter.m_AmountAPow = m_ParseExtFactorPow; }
						else if (BaseStr.EqNCEng(name, "AmountB")) { ParseExtFactor(str); emitter.m_AmountBAdd = m_ParseExtFactorAdd; emitter.m_AmountBMul = m_ParseExtFactorMul; emitter.m_AmountBPow = m_ParseExtFactorPow; }

						else if (BaseStr.EqNCEng(name, "LifeI")) { ParseRange(str); emitter.m_LifeIV = m_ParseRangeV; emitter.m_LifeID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "LifeIG")) LoadVector(str, emitter.m_LifeIG);
						else if (BaseStr.EqNCEng(name, "LifeR")) { ParseRange(str); emitter.m_LifeRV = m_ParseRangeV; emitter.m_LifeRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "LifeRG")) LoadVector(str, emitter.m_LifeRG);
						else if (BaseStr.EqNCEng(name, "LifeA")) { ParseExtFactor(str); emitter.m_LifeAAdd = m_ParseExtFactorAdd; emitter.m_LifeAMul = m_ParseExtFactorMul; emitter.m_LifeAPow = m_ParseExtFactorPow; }
						else if (BaseStr.EqNCEng(name, "LifeB")) { ParseExtFactor(str); emitter.m_LifeBAdd = m_ParseExtFactorAdd; emitter.m_LifeBMul = m_ParseExtFactorMul; emitter.m_LifeBPow = m_ParseExtFactorPow; }

						else if (BaseStr.EqNCEng(name, "WidthType")) emitter.m_WidthType = int(str);
						else if (BaseStr.EqNCEng(name, "WidthI")) { ParseRange(str); emitter.m_WidthIV = m_ParseRangeV; emitter.m_WidthID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "WidthIG")) LoadVector(str, emitter.m_WidthIG);
						else if (BaseStr.EqNCEng(name, "WidthR")) { ParseRange(str); emitter.m_WidthRV = m_ParseRangeV; emitter.m_WidthRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "WidthRG")) LoadVector(str, emitter.m_WidthRG);
						else if (BaseStr.EqNCEng(name, "WidthO")) { ParseRange(str); emitter.m_WidthOV = m_ParseRangeV; emitter.m_WidthOD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "WidthOG")) LoadVector(str, emitter.m_WidthOG);
						else if (BaseStr.EqNCEng(name, "WidthA")) { ParseExtFactor(str); emitter.m_WidthAAdd = m_ParseExtFactorAdd; emitter.m_WidthAMul = m_ParseExtFactorMul; emitter.m_WidthAPow = m_ParseExtFactorPow; }
						else if (BaseStr.EqNCEng(name, "WidthB")) { ParseExtFactor(str); emitter.m_WidthBAdd = m_ParseExtFactorAdd; emitter.m_WidthBMul = m_ParseExtFactorMul; emitter.m_WidthBPow = m_ParseExtFactorPow; }

						else if (BaseStr.EqNCEng(name, "HeightType")) emitter.m_HeightType = int(str);

						else if (BaseStr.EqNCEng(name, "VelocityI")) { ParseRange(str); emitter.m_VelocityIV = m_ParseRangeV; emitter.m_VelocityID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "VelocityIG")) LoadVector(str, emitter.m_VelocityIG);
						else if (BaseStr.EqNCEng(name, "VelocityR")) { ParseRange(str); emitter.m_VelocityRV = m_ParseRangeV; emitter.m_VelocityRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "VelocityRG")) LoadVector(str, emitter.m_VelocityRG);
						else if (BaseStr.EqNCEng(name, "VelocityO")) { ParseRange(str); emitter.m_VelocityOV = m_ParseRangeV; emitter.m_VelocityOD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "VelocityOG")) LoadVector(str, emitter.m_VelocityOG);
						else if (BaseStr.EqNCEng(name, "VelocityA")) { ParseExtFactor(str); emitter.m_VelocityAAdd = m_ParseExtFactorAdd; emitter.m_VelocityAMul = m_ParseExtFactorMul; emitter.m_VelocityAPow = m_ParseExtFactorPow; }
						else if (BaseStr.EqNCEng(name, "VelocityB")) { ParseExtFactor(str); emitter.m_VelocityBAdd = m_ParseExtFactorAdd; emitter.m_VelocityBMul = m_ParseExtFactorMul; emitter.m_VelocityBPow = m_ParseExtFactorPow; }
						
						else if (BaseStr.EqNCEng(name, "SpinI")) { ParseRange(str); emitter.m_SpinIV = m_ParseRangeV; emitter.m_SpinID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "SpinIG")) LoadVector(str, emitter.m_SpinIG);
						else if (BaseStr.EqNCEng(name, "SpinR")) { ParseRange(str); emitter.m_SpinRV = m_ParseRangeV; emitter.m_SpinRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "SpinRG")) LoadVector(str, emitter.m_SpinRG);
						else if (BaseStr.EqNCEng(name, "SpinO")) { ParseRange(str); emitter.m_SpinOV = m_ParseRangeV; emitter.m_SpinOD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "SpinOG")) LoadVector(str, emitter.m_SpinOG);

						else if (BaseStr.EqNCEng(name, "ColorAdd")) emitter.m_ColorAdd = int(str) != 0;
						else if (BaseStr.EqNCEng(name, "Color")) LoadVectorColor(str, emitter.m_ColorG);

						else if (BaseStr.EqNCEng(name, "AlphaI")) { ParseRange(str); emitter.m_AlphaIV = m_ParseRangeV; emitter.m_AlphaID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "AlphaIG")) LoadVector(str, emitter.m_AlphaIG);
						else if (BaseStr.EqNCEng(name, "AlphaR")) { ParseRange(str); emitter.m_AlphaRV = m_ParseRangeV; emitter.m_AlphaRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "AlphaRG")) LoadVector(str, emitter.m_AlphaRG);
						else if (BaseStr.EqNCEng(name, "AlphaO")) { ParseRange(str); emitter.m_AlphaOV = m_ParseRangeV; emitter.m_AlphaOD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "AlphaOG")) LoadVector(str, emitter.m_AlphaOG);

/*						else if (BaseStr.EqNCEng(name, "HueI")) { ParseRange(str); emitter.m_HueIV = m_ParseRangeV; emitter.m_HueID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "HueIG")) LoadVector(str, emitter.m_HueIG);
						else if (BaseStr.EqNCEng(name, "HueR")) { ParseRange(str); emitter.m_HueRV = m_ParseRangeV; emitter.m_HueRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "HueRG")) LoadVector(str, emitter.m_HueRG);
						else if (BaseStr.EqNCEng(name, "HueO")) { ParseRange(str); emitter.m_HueOV = m_ParseRangeV; emitter.m_HueOD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "HueOG")) LoadVector(str, emitter.m_HueOG);

						else if (BaseStr.EqNCEng(name, "SatI")) { ParseRange(str); emitter.m_SatIV = m_ParseRangeV; emitter.m_SatID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "SatIG")) LoadVector(str, emitter.m_SatIG);
						else if (BaseStr.EqNCEng(name, "SatR")) { ParseRange(str); emitter.m_SatRV = m_ParseRangeV; emitter.m_SatRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "SatRG")) LoadVector(str, emitter.m_SatRG);
						else if (BaseStr.EqNCEng(name, "SatO")) { ParseRange(str); emitter.m_SatOV = m_ParseRangeV; emitter.m_SatOD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "SatOG")) LoadVector(str, emitter.m_SatOG);

						else if (BaseStr.EqNCEng(name, "BriI")) { ParseRange(str); emitter.m_BriIV = m_ParseRangeV; emitter.m_BriID = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "BriIG")) LoadVector(str, emitter.m_BriIG);
						else if (BaseStr.EqNCEng(name, "BriR")) { ParseRange(str); emitter.m_BriRV = m_ParseRangeV; emitter.m_BriRD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "BriRG")) LoadVector(str, emitter.m_BriRG);
						else if (BaseStr.EqNCEng(name, "BriO")) { ParseRange(str); emitter.m_BriOV = m_ParseRangeV; emitter.m_BriOD = m_ParseRangeD; }
						else if (BaseStr.EqNCEng(name, "BriOG")) LoadVector(str, emitter.m_BriOG);*/
					}
				} else {
					header = false;

					ibegin=off;
					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend = off;

					while(iend>ibegin) { ch=src.charCodeAt(iend-1); if(ch==32 || ch==9 || ch==10 || ch==13) iend--; else break; }

					if (iend > ibegin && texture != null && imgstyle != null) {
						LoadImgStyle(src.substring(ibegin, iend), imgstyle);
						//LoadVector(src.substring(ibegin, iend), imgstyle.m_UVList, true);
					}
				}
			}
		}
	}
	
	static public function LoadImgStyle(src:String, imgs:ImgStyle):void
	{
		if (src.length <= 0) return;

		src = BaseStr.Replace(src, "\t", " ");
		src = BaseStr.Replace(src, "\n", " ");
		src = BaseStr.Replace(src, ",", " ");
		src = BaseStr.Replace(src, ";", " ");
		src = BaseStr.TrimRepeat(src);
		src = BaseStr.Trim(src);
		if (src.length <= 0) return;

		var ar:Array = src.split(" ");
		if (ar.length <= 0) return;
		
		var u1:Number = 0.0;
		var v1:Number = 0.0;
		var u2:Number = 0.0;
		var v2:Number = 0.0;
		var mclr:uint = 0x00ffffff;
		var malpha:uint = 0xff000000;

		if (ar.length >= 1) u1 = Number(ar[0]);
		if (ar.length >= 2) v1 = Number(ar[1]);
		if (ar.length >= 3) u2 = Number(ar[2]);
		if (ar.length >= 4) v2 = Number(ar[3]);
		if (ar.length >= 5) {
			mclr = uint("0x" + ar[4]);
		}
		if (ar.length >= 6) malpha = uint("0x" + ar[5]);

		imgs.m_UVList.push(u1);
		imgs.m_UVList.push(v1);
		imgs.m_UVList.push(u2);
		imgs.m_UVList.push(v2);
		imgs.m_MaskList.push(mclr);
		imgs.m_MaskList.push(malpha);
		imgs.m_MaskList.push(0);
		imgs.m_MaskList.push(0);
	}

	static public function LoadVector(src:String, des:Vector.<Number>, add:Boolean = false):void
	{
		if(!add) des.length = 0;
		if (src.length <= 0) return;

		src = BaseStr.Replace(src, "\t", " ");
		src = BaseStr.Replace(src, "\n", " ");
		src = BaseStr.Replace(src, ",", " ");
		src = BaseStr.Replace(src, ";", " ");
		src = BaseStr.TrimRepeat(src);
		src = BaseStr.Trim(src);
		if (src.length <= 0) return;

		var ar:Array = src.split(" ");
		if (ar.length <= 0) return;

		var i:int;
		if (add) {
			for (i = 0; i < ar.length; i++) {
				des.push(Number(ar[i]));
			}
		} else {
			des.length = ar.length;
		
			for (i = 0; i < ar.length; i++) {
				des[i] = Number(ar[i]);
			}
		}
	}

	static public function LoadVectorColor(src:String, des:Vector.<uint>, add:Boolean = false):void
	{
		if(!add) des.length = 0;
		if (src.length <= 0) return;

		src = BaseStr.Replace(src, "\t", " ");
		src = BaseStr.Replace(src, "\n", " ");
		src = BaseStr.Replace(src, ",", " ");
		src = BaseStr.Replace(src, ";", " ");
		src = BaseStr.TrimRepeat(src);
		src = BaseStr.Trim(src);
		if (src.length <= 0) return;

		var ar:Array = src.split(" ");
		if (ar.length <= 0) return;

		var i:int;
		if (add) {
			for (i = 0; i < ar.length; i++) {
				if ((i & 1) == 0) des.push(uint("0x" + ar[i]));
				else des.push(int(ar[i]));
			}
		} else {
			des.length = ar.length;
		
			for (i = 0; i < ar.length; i++) {
				if ((i & 1) == 0) des[i] = uint("0x" + ar[i]);
				else des[i] = int(ar[i]);
			}
		}
		if ((des.length & 1) != 0) {
			des.push(100);
		}
	}

	static public function FormatRange(v:Number, d:Number):String
	{
		var str:String = BaseStr.FormatFloat(v, 5);
		if (d != 0.0) str += " " + BaseStr.FormatFloat(d, 5);
		return str;
	}
	
	static public function FormatExtFactor(add:Number, mul:Number, pow:Number):String
	{
		var str:String = "";
		if (add != 1.0 || mul != 0.0 || pow != 1.0) {
			str += BaseStr.FormatFloat(add, 5);
			str += " " + BaseStr.FormatFloat(mul, 5);
			if (pow != 1.0) str += " " + BaseStr.FormatFloat(pow, 5);
		}
		return str;
	}
	
	static public var m_ParseRangeV:Number = 0;
	static public var m_ParseRangeD:Number = 0;
	
	static public function ParseRange(str:String):void
	{
		str = BaseStr.Replace(str, "\t", " ");
		str = BaseStr.Replace(str, "\n", " ");
		str = BaseStr.Replace(str, ",", " ");
		str = BaseStr.Replace(str, ";", " ");
		str = BaseStr.TrimRepeat(str);
		str = BaseStr.Trim(str);

		m_ParseRangeV = 0.0;
		m_ParseRangeD = 0.0;
		if (str.length <= 0) return;

		var ar:Array = str.split(" ");

		if (ar.length >= 1) m_ParseRangeV = Number(ar[0]);
		if (ar.length >= 2) m_ParseRangeD = Number(ar[1]);
	}

	static public var m_ParseExtFactorAdd:Number = 0;
	static public var m_ParseExtFactorMul:Number = 0;
	static public var m_ParseExtFactorPow:Number = 0;

	static public function ParseExtFactor(str:String):void
	{
		str = BaseStr.Replace(str, "\t", " ");
		str = BaseStr.Replace(str, "\n", " ");
		str = BaseStr.Replace(str, ",", " ");
		str = BaseStr.Replace(str, ";", " ");
		str = BaseStr.TrimRepeat(str);
		str = BaseStr.Trim(str);
		
		m_ParseExtFactorAdd = 1.0;
		m_ParseExtFactorMul = 0.0;
		m_ParseExtFactorPow = 1.0;
		if (str.length <= 0) return;

		var ar:Array = str.split(" ");

		if (ar.length >= 1) m_ParseExtFactorAdd = Number(ar[0]);
		if (ar.length >= 2) m_ParseExtFactorMul = Number(ar[1]);
		if (ar.length >= 3) m_ParseExtFactorPow = Number(ar[2]);
	}

	static public var m_SaveArea:CtrlInput = null;

	static public function Edit(id:String):void
	{
		if (!prepare()) return;
		if (m_Map[id] == undefined) return;
		m_EditId = id;
		var style:Style = m_Map[id];

		var fi:FormInputEx = StdMap.Main.FI;

		var e:int, i:int;
		var ts:TextureStyle;
		var inp:TextInput;
		var str:String;

		fi.Init(480, Math.max(400, C3D.m_SizeY - 100));
		fi.pageWidthMin = 100;
		fi.caption = "Effect style " + id.toString();
		
		var dobj:DisplayObject = null;
		
		var tab:int = fi.TabAdd("emitter");
		fi.tab = 0;

		for (e = 0; e < style.m_EmitterList.length; e++) {
			var em:EmitterStyle = style.m_EmitterList[e];

			fi.PageAdd("Emitter " + (e + 1).toString(), tab);
			if (e == 0) fi.page = 0;

			// Image
			fi.AddLabel("Image:");
			fi.Col();
			fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
			if (m_TextureMap[style.m_Texture] != undefined) {
				ts = m_TextureMap[style.m_Texture];
				for (i = 0; i < ts.m_ImgList.length;i++) {
					fi.AddItem(ts.m_ImgList[i].m_Id, ts.m_ImgList[i].m_Id, ts.m_ImgList[i].m_Id == em.m_Img);
				}
			}

			// Image center
			fi.AddLabel("Image center:");
			fi.Col();
			fi.AddInput(BaseStr.FormatFloat(em.m_ImgCenterX, 5) + " " + BaseStr.FormatFloat(em.m_ImgCenterY, 5), 20, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);
	
			// Image scale
			fi.AddLabel("Image scale:");
			fi.Col();
			fi.AddInput(BaseStr.FormatFloat(em.m_ImgScaleX, 5) + " " + BaseStr.FormatFloat(em.m_ImgScaleY, 5), 20, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			// Rnd Anim
			fi.AddCheckBox(em.m_ImgRnd, "Image random").addEventListener(Event.CHANGE, EditChange);
			fi.Col();
			fi.AddCheckBox(em.m_ImgAnim, "Image animation").addEventListener(Event.CHANGE, EditChange);

			// Image speed
			fi.AddLabel("    Image speed:");
			fi.Col();
			fi.AddInput(BaseStr.FormatFloat(em.m_ImgSpeed, 5), 20, true, 0, true).addEventListener(Event.CHANGE, EditChange);

			// Image dist
			fi.AddLabel("    Image dist:");
			fi.Col();
			fi.AddInput(BaseStr.FormatFloat(em.m_ImgDist, 5), 20, true, 0, true).addEventListener(Event.CHANGE, EditChange);

			// Radius
			fi.AddLabel("Position type:");
			fi.Col();
			fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
			fi.AddItem("center", 0, 0 == em.m_PosType);
			fi.AddItem("view", 1, 1 == em.m_PosType);
			fi.AddItem("dir", 2, 2 == em.m_PosType);
			fi.AddItem("normal", 3, 3 == em.m_PosType);

			// Position path
			fi.AddLabel("Position path:");
			fi.Col();
			fi.AddInput(BaseStr.FormatFloat(em.m_PosPath, 5), 20, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			// Radius
			fi.AddLabel("Radius:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_RadiusIV, em.m_RadiusID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_RadiusIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Radius random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_RadiusRV, em.m_RadiusRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_RadiusRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Radius A:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_RadiusAAdd, em.m_RadiusAMul, em.m_RadiusAPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("    Radius B:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_RadiusBAdd, em.m_RadiusBMul, em.m_RadiusBPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);
			
			// Angle
			fi.AddLabel("Angle:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_AngleIV, em.m_AngleID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_AngleIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Angle random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_AngleRV, em.m_AngleRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_AngleRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			// Rotate
			fi.AddLabel("Rotate:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_RotateIV, em.m_RotateID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_RotateIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Rotate random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_RotateRV, em.m_RotateRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_RotateRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);
			
			// Offset
			fi.AddLabel("Offset:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_OffsetIV, em.m_OffsetID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_OffsetIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Offset random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_OffsetRV, em.m_OffsetRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_OffsetRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Offset overtime:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_OffsetOV, em.m_OffsetOD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_OffsetOG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Offset A:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_OffsetAAdd, em.m_OffsetAMul, em.m_OffsetAPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("    Offset B:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_OffsetBAdd, em.m_OffsetBMul, em.m_OffsetBPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			//  Birth page ///////////////////////////////////////////////////////////////////////
			fi.PageAdd("    Birth",tab);
			
			// Period
			fi.AddLabel("Period:");
			fi.Col();
			fi.AddInput(em.m_Period.toString(), 10, true, 0, false).addEventListener(Event.CHANGE, EditChange);

			// Loop and FirstFrame
			fi.AddCheckBox(em.m_Loop, "Loop").addEventListener(Event.CHANGE, EditChange);
			fi.Col();
			fi.AddCheckBox(em.m_FirstFrame, "First frame").addEventListener(Event.CHANGE, EditChange);

			// Amount
			fi.AddLabel("Amount:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_AmountIV, em.m_AmountID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_AmountIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Amount random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_AmountRV, em.m_AmountRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_AmountRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Amount A:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_AmountAAdd, em.m_AmountAMul, em.m_AmountAPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("    Amount B:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_AmountBAdd, em.m_AmountBMul, em.m_AmountBPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			// Life
			fi.AddLabel("Life:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_LifeIV, em.m_LifeID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_LifeIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Life random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_LifeRV, em.m_LifeRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_LifeRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Life A:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_LifeAAdd, em.m_LifeAMul, em.m_LifeAPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("    Life B:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_LifeBAdd, em.m_LifeBMul, em.m_LifeBPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			// Particle page ///////////////////////////////////////////////////////////////////////
			fi.PageAdd("    Particle",tab);

			// Height
			fi.AddLabel("Height type:");
			fi.Col();
			fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
			fi.AddItem("=width", 0, 0 == em.m_HeightType);
			fi.AddItem("target", 1, 1 == em.m_HeightType);

			// Width
			fi.AddLabel("Width type:");
			fi.Col();
			fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
			fi.AddItem("world", 0, 0 == em.m_WidthType);
			fi.AddItem("screen", 1, 1 == em.m_WidthType);
			
			fi.AddLabel("    Width:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_WidthIV, em.m_WidthID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_WidthIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Width random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_WidthRV, em.m_WidthRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_WidthRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Width overtime:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_WidthOV, em.m_WidthOD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_WidthOG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Width A:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_WidthAAdd, em.m_WidthAMul, em.m_WidthAPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("    Width B:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_WidthBAdd, em.m_WidthBMul, em.m_WidthBPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			// Velocity
			fi.AddLabel("Velocity:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_VelocityIV, em.m_VelocityID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_VelocityIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Velocity random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_VelocityRV, em.m_VelocityRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_VelocityRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Velocity overtime:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_VelocityOV, em.m_VelocityOD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_VelocityOG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Velocity A:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_VelocityAAdd, em.m_VelocityAMul, em.m_VelocityAPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("    Velocity B:");
			fi.Col();
			fi.AddInput(FormatExtFactor(em.m_VelocityBAdd, em.m_VelocityBMul, em.m_VelocityBPow).toString(), 30, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			// Spin
			fi.AddLabel("Spin:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_SpinIV, em.m_SpinID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_SpinIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Spin random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_SpinRV, em.m_SpinRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_SpinRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Spin overtime:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_SpinOV, em.m_SpinOD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_SpinOG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			// Color page ///////////////////////////////////////////////////////////////////////
			fi.PageAdd("    Color",tab);

			fi.AddCheckBox(em.m_ColorAdd, "Color add").addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Color:");
			fi.Col();
			//fi.AddColorPicker(em.m_Color).addEventListener(Event.CHANGE, EditChange);
			dobj = fi.AddInput(Style.SaveVectorColor(em.m_ColorG), 1024, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_ColorG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditColorGrid);
			dobj.addEventListener(MouseEvent.CLICK, EditColorGrid);

			// Alpha
			fi.AddLabel("Alpha:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_AlphaIV, em.m_AlphaID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_AlphaIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Alpha random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_AlphaRV, em.m_AlphaRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_AlphaRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Alpha overtime:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_AlphaOV, em.m_AlphaOD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(em.m_AlphaOG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

/*			// Hue
			fi.AddLabel("Hue:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_HueIV, em.m_HueID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_HueIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Hue random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_HueRV, em.m_HueRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_HueRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Hue overtime:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_HueOV, em.m_HueOD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_HueOG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			// Sat
			fi.AddLabel("Saturation:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_SatIV, em.m_SatID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_SatIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Saturation  random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_SatRV, em.m_SatRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_SatRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Saturation  overtime:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_SatOV, em.m_SatOD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_SatOG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			// Bri
			fi.AddLabel("Brightness:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_BriIV, em.m_BriID).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_BriIG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Brightness random:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_BriRV, em.m_BriRD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_BriRG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);

			fi.AddLabel("    Brightness overtime:");
			fi.Col();
			dobj = fi.AddInput(FormatRange(em.m_BriOV, em.m_BriOD).toString(), 20, true, Server.LANG_ENG, true);
			fi.SetUserData(dobj, em.m_BriOG);
			dobj.addEventListener(Event.CHANGE, EditChange);
			dobj.addEventListener(FocusEvent.FOCUS_IN, EditGraph);
			dobj.addEventListener(MouseEvent.CLICK, EditGraph);*/
		}

		fi.TabAdd("options");

		// Texture
		fi.AddLabel("Texture:");
		fi.Col();
		fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
		for each(ts in m_TextureMap) {
			fi.AddItem(ts.m_Id, ts.m_Id, ts.m_Id == style.m_Texture);
		}

		// Sort
		fi.AddLabel("Sort:");
		fi.Col();
		fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
		fi.AddItem("old to new", 0, 0 == style.m_Sort);
		fi.AddItem("new to old", 1, 1 == style.m_Sort);

		// A
		fi.AddLabel("A:");
		fi.Col();
		fi.AddInput(BaseStr.FormatFloat(style.m_A, 5), 20, true, Server.LANG_ENG, false).addEventListener(Event.CHANGE, EditChange);

		// B
		fi.AddLabel("B:");
		fi.Col();
		fi.AddInput(BaseStr.FormatFloat(style.m_B, 5), 20, true, Server.LANG_ENG, false).addEventListener(Event.CHANGE, EditChange);

		//
		fi.TabAdd("save");
		m_SaveArea = fi.AddCode(style.Save(), 1024 * 16, true, Server.LANG_ENG, true);
		m_SaveArea.heightMin = fi.contentHeight - 50;

		var but:CtrlBut;
		var tx:int = fi.innerLeft;
		var ty:int = fi.height - fi.innerBottom;
		
		but = new CtrlBut();
		but.caption = "Down";
		but.addEventListener(MouseEvent.CLICK, EmitterDown);
		fi.CtrlAddPage(but,tab);
		but.x = tx;
		ty -= but.height;
		but.y = ty;
		but.width = 80;

		but = new CtrlBut();
		but.caption = "Up";
		but.addEventListener(MouseEvent.CLICK, EmitterUp);
		fi.CtrlAddPage(but,tab);
		but.x = tx;
		ty -= but.height;
		but.y = ty;
		but.width = 80;
		
		tx = tx + but.width;
		ty = fi.height - fi.innerBottom;
		
		but = new CtrlBut();
		but.caption = "Copy";
		but.addEventListener(MouseEvent.CLICK, EmitterCopy);
		fi.CtrlAddPage(but,tab);
		but.x = tx;
		but.y = ty - but.height;
		but.width = 80;
		tx += but.width;

		but = new CtrlBut();
		but.caption = "Del";
		but.addEventListener(MouseEvent.CLICK, EmitterDel);
		fi.CtrlAddPage(but,tab);
		but.x = tx;
		but.y = ty - but.height;
		but.width = 80;
		tx += but.width;

		fi.Run(null, null, StdMap.Txt.ButClose);

		if (!m_InputSetCallback) {
			m_InputSetCallback = true;
			fi.addEventListener("page", InputPageChange);
			fi.addEventListener("close", InputHide);
		}
	}
	
	private static var m_InputSetCallback:Boolean = false;
	
	static public function InputPageChange(event:Event):void
	{
		StdMap.Main.m_FormInputTimeline.Hide();
		StdMap.Main.m_FormInputColor.Hide();
	}

	static public function InputHide(event:Event):void
	{
//		m_EditId = "";
		StdMap.Main.m_FormInputTimeline.Hide();
		StdMap.Main.m_FormInputColor.Hide();
		if (m_InputSetCallback) {
			m_InputSetCallback = false;

			var fi:FormInputEx = StdMap.Main.m_FormInputEx;
			fi.removeEventListener("page", InputPageChange);
			fi.removeEventListener("close", InputHide);
		}
	}

	static public function EditChange(event:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;
		
		var ar:Array;
		var str:String;
		var e:int, i:int;
		var reedit:Boolean = false;
		var off:int = 0;

		for (e = 0; e < style.m_EmitterList.length; e++) {
			var em:EmitterStyle = style.m_EmitterList[e];

			em.m_Img = fi.GetStr(off++);
			
			str = fi.GetStr(off++);
			str = BaseStr.Replace(str, "\t", " ");
			str = BaseStr.Replace(str, "\n", " ");
			str = BaseStr.Replace(str, ",", " ");
			str = BaseStr.Replace(str, ";", " ");
			str = BaseStr.TrimRepeat(str);
			str = BaseStr.Trim(str);
			ar = str.split(" ");
			if (ar.length >= 1) em.m_ImgCenterX = Number(ar[0]); else em.m_ImgCenterX = 0;
			if (ar.length >= 2) em.m_ImgCenterY = Number(ar[1]); else em.m_ImgCenterY = 0;

			str = fi.GetStr(off++);
			str = BaseStr.Replace(str, "\t", " ");
			str = BaseStr.Replace(str, "\n", " ");
			str = BaseStr.Replace(str, ",", " ");
			str = BaseStr.Replace(str, ";", " ");
			str = BaseStr.TrimRepeat(str);
			str = BaseStr.Trim(str);
			ar = str.split(" ");
			if (ar.length >= 1) em.m_ImgScaleX = Number(ar[0]); else em.m_ImgScaleX = 1.0;
			if (ar.length >= 2) em.m_ImgScaleY = Number(ar[1]); else em.m_ImgScaleY = 1.0;

			em.m_ImgRnd = fi.GetInt(off++) != 0;
			em.m_ImgAnim = fi.GetInt(off++) != 0;
			em.m_ImgSpeed = Number(fi.GetStr(off++));
			em.m_ImgDist = Number(fi.GetStr(off++));

			em.m_PosType = fi.GetInt(off++);;
			em.m_PosPath = Number(fi.GetStr(off++));

			ParseRange(fi.GetStr(off++)); em.m_RadiusIV = m_ParseRangeV; em.m_RadiusID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_RadiusRV = m_ParseRangeV; em.m_RadiusRD = m_ParseRangeD;
			ParseExtFactor(fi.GetStr(off++)); em.m_RadiusAAdd = m_ParseExtFactorAdd; em.m_RadiusAMul = m_ParseExtFactorMul; em.m_RadiusAPow = m_ParseExtFactorPow;
			ParseExtFactor(fi.GetStr(off++)); em.m_RadiusBAdd = m_ParseExtFactorAdd; em.m_RadiusBMul = m_ParseExtFactorMul; em.m_RadiusBPow = m_ParseExtFactorPow;

			ParseRange(fi.GetStr(off++)); em.m_AngleIV = m_ParseRangeV; em.m_AngleID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_AngleRV = m_ParseRangeV; em.m_AngleRD = m_ParseRangeD;

			ParseRange(fi.GetStr(off++)); em.m_RotateIV = m_ParseRangeV; em.m_RotateID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_RotateRV = m_ParseRangeV; em.m_RotateRD = m_ParseRangeD;

			ParseRange(fi.GetStr(off++)); em.m_OffsetIV = m_ParseRangeV; em.m_OffsetID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_OffsetRV = m_ParseRangeV; em.m_OffsetRD = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_OffsetOV = m_ParseRangeV; em.m_OffsetOD = m_ParseRangeD;
			ParseExtFactor(fi.GetStr(off++)); em.m_OffsetAAdd = m_ParseExtFactorAdd; em.m_OffsetAMul = m_ParseExtFactorMul; em.m_OffsetAPow = m_ParseExtFactorPow;
			ParseExtFactor(fi.GetStr(off++)); em.m_OffsetBAdd = m_ParseExtFactorAdd; em.m_OffsetBMul = m_ParseExtFactorMul; em.m_OffsetBPow = m_ParseExtFactorPow;

			em.m_Period = int(fi.GetStr(off++));
			em.m_Loop = fi.GetInt(off++) != 0;
			em.m_FirstFrame = fi.GetInt(off++) != 0;

			ParseRange(fi.GetStr(off++)); em.m_AmountIV = m_ParseRangeV; em.m_AmountID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_AmountRV = m_ParseRangeV; em.m_AmountRD = m_ParseRangeD;
			ParseExtFactor(fi.GetStr(off++)); em.m_AmountAAdd = m_ParseExtFactorAdd; em.m_AmountAMul = m_ParseExtFactorMul; em.m_AmountAPow = m_ParseExtFactorPow;
			ParseExtFactor(fi.GetStr(off++)); em.m_AmountBAdd = m_ParseExtFactorAdd; em.m_AmountBMul = m_ParseExtFactorMul; em.m_AmountBPow = m_ParseExtFactorPow;

			ParseRange(fi.GetStr(off++)); em.m_LifeIV = m_ParseRangeV; em.m_LifeID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_LifeRV = m_ParseRangeV; em.m_LifeRD = m_ParseRangeD;
			ParseExtFactor(fi.GetStr(off++)); em.m_LifeAAdd = m_ParseExtFactorAdd; em.m_LifeAMul = m_ParseExtFactorMul; em.m_LifeAPow = m_ParseExtFactorPow;
			ParseExtFactor(fi.GetStr(off++)); em.m_LifeBAdd = m_ParseExtFactorAdd; em.m_LifeBMul = m_ParseExtFactorMul; em.m_LifeBPow = m_ParseExtFactorPow;
			
			em.m_HeightType = int(fi.GetStr(off++));
			em.m_WidthType = int(fi.GetStr(off++));

			ParseRange(fi.GetStr(off++)); em.m_WidthIV = m_ParseRangeV; em.m_WidthID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_WidthRV = m_ParseRangeV; em.m_WidthRD = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_WidthOV = m_ParseRangeV; em.m_WidthOD = m_ParseRangeD;
			ParseExtFactor(fi.GetStr(off++)); em.m_WidthAAdd = m_ParseExtFactorAdd; em.m_WidthAMul = m_ParseExtFactorMul; em.m_WidthAPow = m_ParseExtFactorPow;
			ParseExtFactor(fi.GetStr(off++)); em.m_WidthBAdd = m_ParseExtFactorAdd; em.m_WidthBMul = m_ParseExtFactorMul; em.m_WidthBPow = m_ParseExtFactorPow;

			ParseRange(fi.GetStr(off++)); em.m_VelocityIV = m_ParseRangeV; em.m_VelocityID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_VelocityRV = m_ParseRangeV; em.m_VelocityRD = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_VelocityOV = m_ParseRangeV; em.m_VelocityOD = m_ParseRangeD;
			ParseExtFactor(fi.GetStr(off++)); em.m_VelocityAAdd = m_ParseExtFactorAdd; em.m_VelocityAMul = m_ParseExtFactorMul; em.m_VelocityAPow = m_ParseExtFactorPow;
			ParseExtFactor(fi.GetStr(off++)); em.m_VelocityBAdd = m_ParseExtFactorAdd; em.m_VelocityBMul = m_ParseExtFactorMul; em.m_VelocityBPow = m_ParseExtFactorPow;

			ParseRange(fi.GetStr(off++)); em.m_SpinIV = m_ParseRangeV; em.m_SpinID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_SpinRV = m_ParseRangeV; em.m_SpinRD = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_SpinOV = m_ParseRangeV; em.m_SpinOD = m_ParseRangeD;

			em.m_ColorAdd = fi.GetInt(off++) != 0;
			fi.GetStr(off++);
			//em.m_Color = uint("0x" + fi.GetStr(off++));

			ParseRange(fi.GetStr(off++)); em.m_AlphaIV = m_ParseRangeV; em.m_AlphaID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_AlphaRV = m_ParseRangeV; em.m_AlphaRD = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_AlphaOV = m_ParseRangeV; em.m_AlphaOD = m_ParseRangeD;

/*			ParseRange(fi.GetStr(off++)); em.m_HueIV = m_ParseRangeV; em.m_HueID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_HueRV = m_ParseRangeV; em.m_HueRD = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_HueOV = m_ParseRangeV; em.m_HueOD = m_ParseRangeD;
			
			ParseRange(fi.GetStr(off++)); em.m_SatIV = m_ParseRangeV; em.m_SatID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_SatRV = m_ParseRangeV; em.m_SatRD = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_SatOV = m_ParseRangeV; em.m_SatOD = m_ParseRangeD;

			ParseRange(fi.GetStr(off++)); em.m_BriIV = m_ParseRangeV; em.m_BriID = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_BriRV = m_ParseRangeV; em.m_BriRD = m_ParseRangeD;
			ParseRange(fi.GetStr(off++)); em.m_BriOV = m_ParseRangeV; em.m_BriOD = m_ParseRangeD;*/
		}

		str = fi.GetStr(off++);
		if (style.m_Texture != str) {
			style.m_Texture = str;
			reedit = true;
		}

		style.m_Sort = fi.GetInt(off++);
		style.m_A = Number(fi.GetStr(off++));
		style.m_B = Number(fi.GetStr(off++));

		style.m_Ready = false;
		style.m_Ver++;

		if (reedit) {
			var p:int = fi.page;

			var px:int = fi.x;
			var py:int = fi.y;
			Edit(m_EditId);
			fi.x = px;
			fi.y = py;
			fi.page = p;
		} else {
			m_SaveArea.text = style.Save();
		}
	}

	static public function EditGraph(event:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		var p:int = fi.page;
		var e:int = Math.floor(p / PagesPerEmitter);
		if (e<0 || e>=style.m_EmitterList.length) return;

		var obj:Object = fi.ItemUserData(fi.ItemByObj(event.currentTarget as DisplayObject));
		if (obj == null) return;
		StdMap.Main.m_FormInputTimeline.Run(obj as Vector.<Number>, EditGraphChange);

		//var em:EmitterStyle = style.m_EmitterList[e];
	}

	static public function EditGraphChange():void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		style.m_Ready = false;
		style.m_Ver++;
		m_SaveArea.text = style.Save();
	}
	
	private static var m_InputCur:DisplayObject = null;

	static public function EditColorGrid(event:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		var p:int = fi.page;
		var e:int = Math.floor(p / PagesPerEmitter);
		if (e<0 || e>=style.m_EmitterList.length) return;
		
		m_InputCur = event.currentTarget as DisplayObject;
		var obj:Object = fi.ItemUserData(fi.ItemByObj(m_InputCur));
		if (obj == null) return;
		StdMap.Main.m_FormInputColor.Run(Style.IC(obj as Vector.<uint>, 0), EditColorGridChange);
		StdMap.Main.m_FormInputColor.SetGrid(obj as Vector.<uint>);
	}
	
	static public function EditColorGridChange():void
	{
		if (m_InputCur == null) return;
		(m_InputCur as CtrlInput).text = Style.SaveVectorColor(StdMap.Main.m_FormInputColor.m_Grid);

		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		style.m_Ready = false;
		style.m_Ver++;
		m_SaveArea.text = style.Save();
	}
	
	static public function EmitterUp(event:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		if (style.m_EmitterList.length <= 1) return;
		var p:int = fi.page;
		var e:int = Math.floor(p / PagesPerEmitter);
		if (e<0 || e>=style.m_EmitterList.length) return;

		if (e <= 0) return;

		var em:EmitterStyle = style.m_EmitterList[e];
		style.m_EmitterList.splice(e, 1);
		style.m_EmitterList.splice(e - 1, 0, em);

		style.m_Ready = false;
		style.m_Ver++;

		var px:int = fi.x;
		var py:int = fi.y;
		Edit(m_EditId);
		fi.x = px;
		fi.y = py;
		fi.page = p - PagesPerEmitter;
	}

	static public function EmitterDown(event:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;
		var p:int = fi.page;
		var e:int = Math.floor(p / PagesPerEmitter);
		if (e<0 || e>=style.m_EmitterList.length) return;

		if (e >= (style.m_EmitterList.length - 1)) return;

		var em:EmitterStyle = style.m_EmitterList[e];
		style.m_EmitterList.splice(e, 1);
		style.m_EmitterList.splice(e + 1, 0, em);

		style.m_Ready = false;
		style.m_Ver++;

		var px:int = fi.x;
		var py:int = fi.y;
		Edit(m_EditId);
		fi.x = px;
		fi.y = py;
		fi.page = p + PagesPerEmitter;
	}

	static public function EmitterCopy(event:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		if (style.m_EmitterList.length >= 7) return;
		var p:int = fi.page;
		var e:int = Math.floor(p / PagesPerEmitter);
		if (e<0 || e>=style.m_EmitterList.length) return;

		var des:EmitterStyle = new EmitterStyle();
		des.CopyFrom(style.m_EmitterList[e]);
		style.m_EmitterList.splice(e + 1, 0, des);

		style.m_Ready = false;
		style.m_Ver++;

		var px:int = fi.x;
		var py:int = fi.y;
		Edit(m_EditId);
		fi.x = px;
		fi.y = py;
		fi.page = p + PagesPerEmitter;
	}

	static public function EmitterDel(event:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Style = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		if (style.m_EmitterList.length <= 1) return;
		var p:int = fi.page;
		var e:int = Math.floor(p / PagesPerEmitter);
		if (e<0 || e>=style.m_EmitterList.length) return;
		
		style.m_EmitterList.splice(e, 1);

		style.m_Ready = false;
		style.m_Ver++;

		var px:int = fi.x;
		var py:int = fi.y;
		Edit(m_EditId);
		fi.x = px;
		fi.y = py;
		if (e >= style.m_EmitterList.length) p = p - PagesPerEmitter;
		fi.page = p;
	}
}

}