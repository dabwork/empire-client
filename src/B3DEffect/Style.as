// Copyright (C) 2013 Elemental Games. All rights reserved.

package B3DEffect
{
import Base.*;
import Engine.*;
import utils.eg.HSVRGB;
	
public class Style
{
	public var m_Id:String = "";
	public var m_EmitterList:Vector.<EmitterStyle> = new Vector.<EmitterStyle>();
	public var m_Texture:String = "";
	public var m_Sort:int = 0; // 0=old to new 1-new to old
	public var m_A:Number = 0;
	public var m_B:Number = 0;

	public var m_FPS:Number = 50;
	
	public var m_FrameTime:Number = 0;
	public var m_Ready:Boolean = false;
	public var m_Ver:int = 1;

	public function Style():void
	{
	}
	
	public function Prepare():void
	{
		if (m_Ready) return;

		var i:int, u:int, framecnt:int;
		var t:Number,tn:Number;
		var es:EmitterStyle;
		var ef:EmitterFrame;
		var v:Number;

		var hsvrgb:HSVRGB = Effect.m_HSVRGB;

		m_FrameTime = 1000.0 / m_FPS;

		for (i = 0; i < m_EmitterList.length; i++) {
			es = m_EmitterList[i];
			framecnt = Math.floor(es.m_Period / m_FrameTime);

			u = es.m_Frame.length;
			es.m_Frame.length = framecnt;
			for (; u < framecnt; u++) es.m_Frame[u] = new EmitterFrame();

			t = 0.0;

			for (u = 0; u < framecnt; u++) {
				ef = es.m_Frame[u];

				tn = t / es.m_Period;

				ef.m_Radius = es.m_RadiusIV + es.m_RadiusID * IG(es.m_RadiusIG, tn);
				ef.m_RadiusR = es.m_RadiusRD * IG(es.m_RadiusRG, tn);

				ef.m_Angle = es.m_AngleIV + es.m_AngleID * IG(es.m_AngleIG, tn);
				ef.m_AngleR = es.m_AngleRD * IG(es.m_AngleRG, tn);

				ef.m_Rotate = es.m_RotateIV + es.m_RotateID * IG(es.m_RotateIG, tn);
				ef.m_RotateR = es.m_RotateRD * IG(es.m_RotateRG, tn);

				ef.m_Offset = es.m_OffsetIV + es.m_OffsetID * IG(es.m_OffsetIG, tn);
				ef.m_OffsetR = es.m_OffsetRD * IG(es.m_OffsetRG, tn);

				ef.m_Amount = (es.m_AmountIV + es.m_AmountID * IG(es.m_AmountIG, tn));
				ef.m_AmountR = (es.m_AmountRD * IG(es.m_AmountRG, tn));
				if (!es.m_FirstFrame) {
					ef.m_Amount /= m_FPS;
					ef.m_AmountR /= m_FPS;
				}

				ef.m_Life = es.m_LifeIV + es.m_LifeID * IG(es.m_LifeIG, tn);
				ef.m_LifeR = es.m_LifeRD * IG(es.m_LifeRG, tn);

				ef.m_Velocity = es.m_VelocityIV + es.m_VelocityID * IG(es.m_VelocityIG, tn);
				ef.m_VelocityR = es.m_VelocityRD * IG(es.m_VelocityRG, tn);

				ef.m_Spin = es.m_SpinIV + es.m_SpinID * IG(es.m_SpinIG, tn);
				ef.m_SpinR = es.m_SpinRD * IG(es.m_SpinRG, tn);

				ef.m_Width = es.m_WidthIV + es.m_WidthID * IG(es.m_WidthIG, tn);
				ef.m_WidthR = es.m_WidthRD * IG(es.m_WidthRG, tn);

				ef.m_Alpha = es.m_AlphaIV + es.m_AlphaID * IG(es.m_AlphaIG, tn);
				ef.m_AlphaR = es.m_AlphaRD * IG(es.m_AlphaRG, tn);
				
/*				ef.m_HueR = es.m_HueRD * IG(es.m_HueRG, tn);
				ef.m_SatR = es.m_SatRD * IG(es.m_SatRG, tn);
				ef.m_BriR = es.m_BriRD * IG(es.m_BriRG, tn);
			
				ef.m_Color = es.m_Color;
				
				if (es.m_AlphaIV != 0 || es.m_AlphaID != 0) {
					v = C3D.ClrToFloat * ((ef.m_Color >> 24) & 255);
					if (es.m_AlphaIV != 0) v += es.m_AlphaIV;
					if (es.m_AlphaID != 0) v += es.m_AlphaID * IG(es.m_AlphaIG, tn);
					if (v < 0) v = 0;
					else if (v > 1.0) v = 1.0;
					ef.m_Color = (uint(v * 255) << 24) | (ef.m_Color & 0xffffff);
				}
				if (es.m_HueIV != 0 || es.m_SatIV != 0 || es.m_BriIV != 0 || es.m_HueID != 0 || es.m_SatID != 0 || es.m_BriID != 0) {
					hsvrgb.r = (ef.m_Color >> 16) & 255;
					hsvrgb.g = (ef.m_Color >> 8) & 255;
					hsvrgb.b = (ef.m_Color) & 255;
					hsvrgb.ToHSV();

					if (es.m_HueIV != 0) hsvrgb.h += es.m_HueIV * 360;
					if (es.m_HueID != 0) hsvrgb.h += es.m_HueID * IG(es.m_HueIG, tn) * 360;
					if (hsvrgb.h < 0) hsvrgb.h = 0;
					else if (hsvrgb.h > 360) hsvrgb.h = 360;

					if (es.m_SatIV != 0) hsvrgb.s += es.m_SatIV * 255;
					if (es.m_SatID != 0) hsvrgb.s += es.m_SatID * IG(es.m_HueIG, tn) * 255;
					if (hsvrgb.s < 0) hsvrgb.s = 0;
					else if (hsvrgb.s > 255) hsvrgb.s = 255;

					if (es.m_BriIV != 0) hsvrgb.v += es.m_BriIV * 255;
					if (es.m_BriID != 0) hsvrgb.v += es.m_BriID * IG(es.m_HueIG, tn) * 255;
					if (hsvrgb.v < 0) hsvrgb.v = 0;
					else if (hsvrgb.v > 255) hsvrgb.v = 255;

					hsvrgb.ToRGB();
					ef.m_Color = (ef.m_Color & 0xff000000) | (hsvrgb.r << 16) | (hsvrgb.g << 8) | (hsvrgb.b);
				}*/

				t += m_FrameTime;
			}
		}
		
		m_Ready = true;
	}
	
	public static function IG(vl:Vector.<Number>, t:Number):Number
	{
		if (vl == null) return 1.0;
		else if (vl.length <= 0) return 1.0;
		else if (vl.length <= 2) return vl[0];

		if (t <= vl[1]) return vl[0];
		var cnt:int = vl.length >> 1;
		if (t >= vl[((cnt - 1) << 1) + 1]) return vl[(cnt - 1) << 1];

		var iv:Number;
		var icur:int = 0;
		var istart:int = 0;
		var iend:int = cnt - 1;
		while(true) {
			icur = istart + ((iend - istart) >> 1);
			iv = vl[(icur << 1) + 1];
			if (t == iv) return vl[icur << 1];
			else if (t < iv) iend = icur - 1;
			else istart = icur + 1;
			if (iend < istart) {
				if (t >= iv) icur++;
				break;
			}
		}
		if(icur==0) return vl[0];
		else if (icur >= cnt) return vl[(cnt - 1) << 1];

		var d:Number = vl[((icur - 1) << 1) + 1];
		t = (t - d) / (vl[(icur << 1) + 1] - d);

		return vl[(icur - 1) << 1] + (vl[icur << 1] - vl[(icur - 1) << 1]) * t;
	}
	
	public static function IC(vl:Vector.<uint>, t:Number):uint
	{
		if(vl==null) return 0xffffffff;
		else if (vl.length <= 0) return 0xffffffff;
		else if (vl.length <= 2) return vl[0];

		if (t <= (0.01 * vl[1])) return vl[0];
		var cnt:int = vl.length >> 1;
		if (t >= (0.01 * vl[((cnt - 1) << 1) + 1])) return vl[(cnt - 1) << 1];

		var iv:Number;
		var icur:int = 0;
		var istart:int = 0;
		var iend:int = cnt - 1;
		while(true) {
			icur = istart + ((iend - istart) >> 1);
			iv = 0.01 * vl[(icur << 1) + 1];
			if (t == iv) return vl[icur << 1];
			else if (t < iv) iend = icur - 1;
			else istart = icur + 1;
			if (iend < istart) {
				if (t >= iv) icur++;
				break;
			}
		}
		if(icur==0) return vl[0];
		else if (icur >= cnt) return vl[(cnt - 1) << 1];

		var d:Number = 0.01 * vl[((icur - 1) << 1) + 1];
		t = (t - d) / (0.01 * vl[(icur << 1) + 1] - d);

		var c0:uint = vl[(icur - 1) << 1];
		var c1:uint = vl[icur << 1];
		
		var ret:uint = uint(Number((c0 >> 0) & 255) + (Number((c1 >> 0) & 255) - Number((c0 >> 0) & 255)) * t);
		ret |= uint(Number((c0 >> 8) & 255) + (Number((c1 >> 8) & 255) - Number((c0 >> 8) & 255)) * t) << 8;
		ret |= uint(Number((c0 >> 16) & 255) + (Number((c1 >> 16) & 255) - Number((c0 >> 16) & 255)) * t) << 16;
		ret |= uint(Number((c0 >> 24) & 255) + (Number((c1 >> 24) & 255) - Number((c0 >> 24) & 255)) * t) << 24;
		return ret;
	}
	
	public static function SaveVector(v:Vector.<Number>):String
	{
		var str:String = "";
		if (v.length <= 0) return str;
		for (var i:int = 0; i < v.length; i++) {
			if (i != 0) str += " ";
			str += BaseStr.FormatFloat(v[i], 5);
		}
		return str;
	}

	public static function SaveVectorColor(v:Vector.<uint>):String
	{
		var str:String = "";
		if (v.length <= 0) return str;
		for (var i:int = 0; i < v.length; i++) {
			if (i != 0) str += " ";
			if ((i & 1) == 0) str += BaseStr.FormatColor(v[i]);
			else str += v[i].toString();
		}
		return str;
	}

	public function Save():String
	{
		var e:int;
		var ts:String;
		var str:String = "";
		if(BaseStr.Trim(m_Id).length<=0) str += "[style]\n";
		else str += "[style," + BaseStr.Trim(m_Id) + "]\n";
		str += "Texture=" + m_Texture + "\n";
		str += "Sort=" + m_Sort.toString() + "\n";
		if (m_A != 0) str += "A=" + BaseStr.FormatFloat(m_A, 5) + "\n";
		if (m_B != 0) str += "B=" + BaseStr.FormatFloat(m_B, 5) + "\n";
		for (e = 0; e < m_EmitterList.length; e++) {
			var es:EmitterStyle = m_EmitterList[e];
			str += "[emitter]\n";

			str += "Img=" + es.m_Img + "\n";
			str += "ImgCenter=" + BaseStr.FormatFloat(es.m_ImgCenterX, 5) + " " + BaseStr.FormatFloat(es.m_ImgCenterY, 5) + "\n";
			str += "ImgScale=" + BaseStr.FormatFloat(es.m_ImgScaleX, 5) + " " + BaseStr.FormatFloat(es.m_ImgScaleY, 5) + "\n";
			str += "ImgRnd=" + ((es.m_ImgRnd)?(1):(0)).toString() + "\n";
			str += "ImgAnim=" + ((es.m_ImgAnim)?(1):(0)).toString() + "\n";
			str += "ImgSpeed=" + BaseStr.FormatFloat(es.m_ImgSpeed, 5) + "\n";
			str += "ImgDist=" + BaseStr.FormatFloat(es.m_ImgDist, 5) + "\n";

			str += "PosType=" + es.m_PosType.toString() + "\n";
			str += "PosPath=" + BaseStr.FormatFloat(es.m_PosPath, 5) + "\n";

			if (es.m_RadiusIV != 0 || es.m_RadiusID != 0) str += "RadiusI=" + StyleManager.FormatRange(es.m_RadiusIV, es.m_RadiusID) + "\n";
			ts = SaveVector(es.m_RadiusIG); if (ts.length > 0) str += "RadiusIG=" + ts + "\n";
			if (es.m_RadiusRV != 0 || es.m_RadiusRD != 0) str += "RadiusR=" + StyleManager.FormatRange(es.m_RadiusRV, es.m_RadiusRD) + "\n";
			ts = SaveVector(es.m_RadiusRG); if (ts.length > 0) str += "RadiusRG=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_RadiusAAdd, es.m_RadiusAMul, es.m_RadiusAPow); if (ts.length > 0) str += "RadiusA=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_RadiusBAdd, es.m_RadiusBMul, es.m_RadiusBPow); if (ts.length > 0) str += "RadiusB=" + ts + "\n";
			
			str += "AngleI=" + StyleManager.FormatRange(es.m_AngleIV, es.m_AngleID) + "\n";
			ts = SaveVector(es.m_AngleIG); if (ts.length > 0) str += "AngleIG=" + ts + "\n";
			str += "AngleR=" + StyleManager.FormatRange(es.m_AngleRV, es.m_AngleRD) + "\n";
			ts = SaveVector(es.m_AngleRG); if (ts.length > 0) str += "AngleRG=" + ts + "\n";

			str += "RotateI=" + StyleManager.FormatRange(es.m_RotateIV, es.m_RotateID) + "\n";
			ts = SaveVector(es.m_RotateIG); if (ts.length > 0) str += "RotateIG=" + ts + "\n";
			str += "RotateR=" + StyleManager.FormatRange(es.m_RotateRV, es.m_RotateRD) + "\n";
			ts = SaveVector(es.m_RotateRG); if (ts.length > 0) str += "RotateRG=" + ts + "\n";

			if (es.m_OffsetIV != 0 || es.m_OffsetID != 0) str += "OffsetI=" + StyleManager.FormatRange(es.m_OffsetIV, es.m_OffsetID) + "\n";
			ts = SaveVector(es.m_OffsetIG); if (ts.length > 0) str += "OffsetIG=" + ts + "\n";
			if (es.m_OffsetRV != 0 || es.m_OffsetRD != 0) str += "OffsetR=" + StyleManager.FormatRange(es.m_OffsetRV, es.m_OffsetRD) + "\n";
			ts = SaveVector(es.m_OffsetRG); if (ts.length > 0) str += "OffsetRG=" + ts + "\n";
			if (es.m_OffsetOV != 0 || es.m_OffsetOD != 0) str += "OffsetO=" + StyleManager.FormatRange(es.m_OffsetOV, es.m_OffsetOD) + "\n";
			ts = SaveVector(es.m_OffsetOG); if (ts.length > 0) str += "OffsetOG=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_OffsetAAdd, es.m_OffsetAMul, es.m_OffsetAPow); if (ts.length > 0) str += "OffsetA=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_OffsetBAdd, es.m_OffsetBMul, es.m_OffsetBPow); if (ts.length > 0) str += "OffsetB=" + ts + "\n";

			str += "Period=" + es.m_Period.toString() + "\n";
			str += "Loop=" + ((es.m_Loop)?(1):(0)).toString() + "\n";
			str += "FirstFrame=" + ((es.m_FirstFrame)?(1):(0)).toString() + "\n";

			if (es.m_AmountIV != 0 || es.m_AmountID != 0) str += "AmountI=" + StyleManager.FormatRange(es.m_AmountIV, es.m_AmountID) + "\n";
			ts = SaveVector(es.m_AmountIG); if (ts.length > 0) str += "AmountIG=" + ts + "\n";
			if (es.m_AmountRV != 0 || es.m_AmountRD != 0) str += "AmountR=" + StyleManager.FormatRange(es.m_AmountRV, es.m_AmountRD) + "\n";
			ts = SaveVector(es.m_AmountRG); if (ts.length > 0) str += "AmountRG=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_AmountAAdd, es.m_AmountAMul, es.m_AmountAPow); if (ts.length > 0) str += "AmountA=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_AmountBAdd, es.m_AmountBMul, es.m_AmountBPow); if (ts.length > 0) str += "AmountB=" + ts + "\n";

			if (es.m_LifeIV != 0 || es.m_LifeID != 0) str += "LifeI=" + StyleManager.FormatRange(es.m_LifeIV, es.m_LifeID) + "\n";
			ts = SaveVector(es.m_LifeIG); if (ts.length > 0) str += "LifeIG=" + ts + "\n";
			if (es.m_LifeRV != 0 || es.m_LifeRD != 0) str += "LifeR=" + StyleManager.FormatRange(es.m_LifeRV, es.m_LifeRD) + "\n";
			ts = SaveVector(es.m_LifeRG); if (ts.length > 0) str += "LifeRG=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_LifeAAdd, es.m_LifeAMul, es.m_LifeAPow); if (ts.length > 0) str += "LifeA=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_LifeBAdd, es.m_LifeBMul, es.m_LifeBPow); if (ts.length > 0) str += "LifeB=" + ts + "\n";

			str += "WidthType=" + es.m_WidthType + "\n";
			str += "WidthI=" + StyleManager.FormatRange(es.m_WidthIV, es.m_WidthID) + "\n";
			ts = SaveVector(es.m_WidthIG); if (ts.length > 0) str += "WidthIG=" + ts + "\n";
			if (es.m_WidthRV != 0 || es.m_WidthRD != 0) str += "WidthR=" + StyleManager.FormatRange(es.m_WidthRV, es.m_WidthRD) + "\n";
			ts = SaveVector(es.m_WidthRG); if (ts.length > 0) str += "WidthRG=" + ts + "\n";
			if (es.m_WidthOV != 0 || es.m_WidthOD != 0) str += "WidthO=" + StyleManager.FormatRange(es.m_WidthOV, es.m_WidthOD) + "\n";
			ts = SaveVector(es.m_WidthOG); if (ts.length > 0) str += "WidthOG=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_WidthAAdd, es.m_WidthAMul, es.m_WidthAPow); if (ts.length > 0) str += "WidthA=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_WidthBAdd, es.m_WidthBMul, es.m_WidthBPow); if (ts.length > 0) str += "WidthB=" + ts + "\n";

			str += "HeightType=" + es.m_HeightType + "\n";

			str += "VelocityI=" + StyleManager.FormatRange(es.m_VelocityIV, es.m_VelocityID) + "\n";
			ts = SaveVector(es.m_VelocityIG); if (ts.length > 0) str += "VelocityIG=" + ts + "\n";
			if (es.m_VelocityRV != 0 || es.m_VelocityRD != 0) str += "VelocityR=" + StyleManager.FormatRange(es.m_VelocityRV, es.m_VelocityRD) + "\n";
			ts = SaveVector(es.m_VelocityRG); if (ts.length > 0) str += "VelocityRG=" + ts + "\n";
			str += "VelocityO=" + StyleManager.FormatRange(es.m_VelocityOV, es.m_VelocityOD) + "\n";
			ts = SaveVector(es.m_VelocityOG); if (ts.length > 0) str += "VelocityOG=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_VelocityAAdd, es.m_VelocityAMul, es.m_VelocityAPow); if (ts.length > 0) str += "VelocityA=" + ts + "\n";
			ts = StyleManager.FormatExtFactor(es.m_VelocityBAdd, es.m_VelocityBMul, es.m_VelocityBPow); if (ts.length > 0) str += "VelocityB=" + ts + "\n";

			if (es.m_SpinIV != 0 || es.m_SpinID != 0) str += "SpinI=" + StyleManager.FormatRange(es.m_SpinIV, es.m_SpinID) + "\n";
			ts = SaveVector(es.m_SpinIG); if (ts.length > 0) str += "SpinIG=" + ts + "\n";
			if (es.m_SpinRV != 0 || es.m_SpinRD != 0) str += "SpinR=" + StyleManager.FormatRange(es.m_SpinRV, es.m_SpinRD) + "\n";
			ts = SaveVector(es.m_SpinRG); if (ts.length > 0) str += "SpinRG=" + ts + "\n";
			if (es.m_SpinOV != 0 || es.m_SpinOD != 0) str += "SpinO=" + StyleManager.FormatRange(es.m_SpinOV, es.m_SpinOD) + "\n";
			ts = SaveVector(es.m_SpinOG); if (ts.length > 0) str += "SpinOG=" + ts + "\n";
			
			str += "ColorAdd=" + ((es.m_ColorAdd)?(1):(0)).toString() + "\n";
			ts = SaveVectorColor(es.m_ColorG); if (ts.length > 0) str += "Color=" + ts + "\n";
			
			str += "AlphaI=" + StyleManager.FormatRange(es.m_AlphaIV, es.m_AlphaID) + "\n";
			ts = SaveVector(es.m_AlphaIG); if (ts.length > 0) str += "AlphaIG=" + ts + "\n";
			if (es.m_AlphaRV != 0 || es.m_AlphaRD != 0) str += "AlphaR=" + StyleManager.FormatRange(es.m_AlphaRV, es.m_AlphaRD) + "\n";
			ts = SaveVector(es.m_AlphaRG); if (ts.length > 0) str += "AlphaRG=" + ts + "\n";
			if (es.m_AlphaOV != 0 || es.m_AlphaOD != 0) str += "AlphaO=" + StyleManager.FormatRange(es.m_AlphaOV, es.m_AlphaOD) + "\n";
			ts = SaveVector(es.m_AlphaOG); if (ts.length > 0) str += "AlphaOG=" + ts + "\n";

/*			str += "Color=" + Common.FormatColor(es.m_Color) + "\n";
			if (es.m_HueIV != 0 || es.m_HueID != 0) str += "HueI=" + StyleManager.FormatRange(es.m_HueIV, es.m_HueID) + "\n";
			ts = SaveVector(es.m_HueIG); if (ts.length > 0) str += "HueIG=" + ts + "\n";
			if (es.m_HueRV != 0 || es.m_HueRD != 0) str += "HueR=" + StyleManager.FormatRange(es.m_HueRV, es.m_HueRD) + "\n";
			ts = SaveVector(es.m_HueRG); if (ts.length > 0) str += "HueRG=" + ts + "\n";
			if (es.m_HueOV != 0 || es.m_HueOD != 0) str += "HueO=" + StyleManager.FormatRange(es.m_HueOV, es.m_HueOD) + "\n";
			ts = SaveVector(es.m_HueOG); if (ts.length > 0) str += "HueOG=" + ts + "\n";

			if (es.m_SatIV != 0 || es.m_SatID != 0) str += "SatI=" + StyleManager.FormatRange(es.m_SatIV, es.m_SatID) + "\n";
			ts = SaveVector(es.m_SatIG); if (ts.length > 0) str += "SatIG=" + ts + "\n";
			if (es.m_SatRV != 0 || es.m_SatRD != 0) str += "SatR=" + StyleManager.FormatRange(es.m_SatRV, es.m_SatRD) + "\n";
			ts = SaveVector(es.m_SatRG); if (ts.length > 0) str += "SatRG=" + ts + "\n";
			if (es.m_SatOV != 0 || es.m_SatOD != 0) str += "SatO=" + StyleManager.FormatRange(es.m_SatOV, es.m_SatOD) + "\n";
			ts = SaveVector(es.m_SatOG); if (ts.length > 0) str += "SatOG=" + ts + "\n";

			if (es.m_BriIV != 0 || es.m_BriID != 0) str += "BriI=" + StyleManager.FormatRange(es.m_BriIV, es.m_BriID) + "\n";
			ts = SaveVector(es.m_BriIG); if (ts.length > 0) str += "BriIG=" + ts + "\n";
			if (es.m_BriRV != 0 || es.m_BriRD != 0) str += "BriR=" + StyleManager.FormatRange(es.m_BriRV, es.m_BriRD) + "\n";
			ts = SaveVector(es.m_BriRG); if (ts.length > 0) str += "BriRG=" + ts + "\n";
			if (es.m_BriOV != 0 || es.m_BriOD != 0) str += "BriO=" + StyleManager.FormatRange(es.m_BriOV, es.m_BriOD) + "\n";
			ts = SaveVector(es.m_BriOG); if (ts.length > 0) str += "BriOG=" + ts + "\n";*/
		}
		return str;
	}
}
	
}