// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import flash.display.*;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.utils.*;
import flash.events.*;
import flash.filters.*;

public class GraphBG extends Sprite
{
	static public const FonImages:Array = new Array();
	
	private var m_Map:EmpireMap;

	private var m_TexFill:C3DTexture = null;
	private var m_TexFon:Vector.<C3DTexture> = new Vector.<C3DTexture>(4 * 4, true);

//	public var m_OffsetX:int;
//	public var m_OffsetY:int;

//	public var m_BGImage:BitmapData=null;
	
//	public var m_IL:Array = new Array();
	
	public var m_Cfg:Object = new Object();
	
	public var m_SaveList:Dictionary = new Dictionary();
	
	public var m_GridLine:Vector.<C3DParticle> = new Vector.<C3DParticle>();
	public var m_GridLineQB:C3DQuadBatch = new C3DQuadBatch();
	public var m_GridText:C3DTextLine = new C3DTextLine();

	public function GraphBG(map:EmpireMap)
	{
		var i:int;
		
		m_Map = map;

		m_GridText.SetFont("small_outline");
		m_GridText.SetFormat(1);
		
		FonImageAdd(01, "Fon01", "nomipmap~bg01.jpg", 0x9c603000, 0xccf09000, 0x66808000, 0x66F00000);
		FonImageAdd(02, "Fon02", "nomipmap~bg02.jpg");
		FonImageAdd(03, "Fon03", "nomipmap~bg03.jpg");
		FonImageAdd(04, "Fon04", "nomipmap~bg04.jpg");
		FonImageAdd(05, "Fon05", "nomipmap~bg05.jpg", 0x9c306000, 0xcc609000, 0x66608000); // green
		FonImageAdd(06, "Fon06", "nomipmap~bg06.jpg", 0x9c306000, 0xcc609000, 0x66608000); // green
		FonImageAdd(07, "Fon07", "nomipmap~bg07.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(08, "Fon08", "nomipmap~bg08.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(09, "Fon09", "nomipmap~bg09.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(10, "Fon10", "nomipmap~bg10.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(11, "Fon11", "nomipmap~bg11.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(12, "Fon12", "nomipmap~bg12.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(13, "Fon13", "nomipmap~bg13.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(14, "Fon14", "nomipmap~bg14.jpg", 0x8c903000, 0xccE09000, 0x66C08000); // red
		FonImageAdd(15, "Fon15", "nomipmap~bg15.jpg", 0x8c903000, 0xccE09000, 0x66C08000); // red
		FonImageAdd(16, "Fon16", "nomipmap~bg16.jpg", 0x8c903000, 0xccE09000, 0x66C08000); // red
		FonImageAdd(21, "Fon21", "nomipmap~bg21.jpg", 0xac600060, 0xcc904090, 0x66603060);
		FonImageAdd(22, "Fon22", "nomipmap~bg22.jpg");
		FonImageAdd(23, "Fon23", "nomipmap~bg23.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(24, "Fon24", "nomipmap~bg24.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(25, "Fon25", "nomipmap~bg25.jpg");
		FonImageAdd(26, "Fon26", "nomipmap~bg26.jpg", 0x8c903000, 0xccE09000, 0x66C08000); // red
		FonImageAdd(31, "Fon31", "nomipmap~bg31.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(32, "Fon32", "nomipmap~bg32.jpg", 0x9c006060, 0xcc009090, 0x66308060); // blue
		FonImageAdd(41, "Fon41", "nomipmap~bg41.jpg");

		//m_BGImage=null;//new ImgBG(0,0);

//		m_OffsetX=0;
//		m_OffsetY = 0;
		
		//LoadManager.Self.addEventListener("Complete", onLoadComplate);

		CfgClear();
/*		m_Cfg.BGLayer = new Array();
		m_Cfg.Size = 2000 + 2000 - 250 - 250;
		m_Cfg.OffX = 0;
		m_Cfg.OffY = 0;
		m_Cfg.Z = 5;
		m_Cfg.FillColor = 0x00000000;
		m_Cfg.FillImg = 3;
		m_Cfg.ColorGrid = uint(0x4c303000);
		m_Cfg.ColorCoord = uint(0xcc909000);
		m_Cfg.ColorTrade = uint(0x66608000);
		m_Cfg.ColorRoute = uint(0x66F00000);
		var bglayer:Object = new Object();
		m_Cfg.BGLayer.push(bglayer);
		bglayer.BeginX = 0;
		bglayer.BeginY = 0;
		
		bglayer.Img1 = 1;
		bglayer.Rotate1 = 0;
		bglayer.FlipX1 = false;
		bglayer.FlipY1 = false;
		bglayer.Hue1 = 0;
		bglayer.Contrast1 = 10;
		bglayer.Brightness1 = 0;
		bglayer.Saturation1 = 10;
		
		bglayer.Img2 = 1;
		bglayer.Rotate2 = 0;
		bglayer.FlipX2 = false;
		bglayer.FlipY2 = false;
		bglayer.Hue2 = 0;
		bglayer.Contrast2 = 10;
		bglayer.Brightness2 = 0;
		bglayer.Saturation2 = 10;
		
		bglayer.Img3 = 1;
		bglayer.Rotate3 = 0;
		bglayer.FlipX3 = false;
		bglayer.FlipY3 = false;
		bglayer.Hue3 = 0;
		bglayer.Contrast3 = 10;
		bglayer.Brightness3 = 0;
		bglayer.Saturation3 = 10;
		
		bglayer.Img4 = 1;
		bglayer.Rotate4 = 0;
		bglayer.FlipX4 = false;
		bglayer.FlipY4 = false;
		bglayer.Hue4 = 0;
		bglayer.Contrast4 = 10;
		bglayer.Brightness4 = 0;
		bglayer.Saturation4 = 10;
		
		for (i = 0; i < 3; i++) {
			bglayer = new Object();
			m_Cfg.BGLayer.push(bglayer);
			bglayer.BeginX = 0;
			bglayer.BeginY = 0;
			
			bglayer.Img1 = 0;
			bglayer.Rotate1 = 0;
			bglayer.FlipX1 = false;
			bglayer.FlipY1 = false;
			bglayer.Hue1 = 0;
			bglayer.Contrast1 = 0;
			bglayer.Brightness1 = 0;
			bglayer.Saturation1 = 0;

			bglayer.Img2 = 0;
			bglayer.Rotate2 = 0;
			bglayer.FlipX2 = false;
			bglayer.FlipY2 = false;
			bglayer.Hue2 = 0;
			bglayer.Contrast2 = 0;
			bglayer.Brightness2 = 0;
			bglayer.Saturation2 = 0;
			
			bglayer.Img3 = 0;
			bglayer.Rotate3 = 0;
			bglayer.FlipX3 = false;
			bglayer.FlipY3 = false;
			bglayer.Hue3 = 0;
			bglayer.Contrast3 = 0;
			bglayer.Brightness3 = 0;
			bglayer.Saturation3 = 0;
			
			bglayer.Img4 = 0;
			bglayer.Rotate4 = 0;
			bglayer.FlipX4 = false;
			bglayer.FlipY4 = false;
			bglayer.Hue4 = 0;
			bglayer.Contrast4 = 0;
			bglayer.Brightness4 = 0;
			bglayer.Saturation4 = 0;
		}*/
		
		//NeedUpdate();
	}
	
	public function CfgClear():void
	{
		var i:int;

		m_Cfg.Size = 2000 + 2000 - 250 - 250;
		m_Cfg.OffX = 0;
		m_Cfg.OffY = 0;
//		m_Cfg.Z = 5;
		m_Cfg.FillColor = 0x00000000;
		m_Cfg.FillImg = 0;
		m_Cfg.ColorGrid = uint(0x4c303000);
		m_Cfg.ColorCoord = uint(0xcc909000);
		m_Cfg.ColorTrade = uint(0xb0608000);
		m_Cfg.ColorRoute = uint(0xb0F00000);
		
		var bglayer:Object;
		
		m_Cfg.BGLayer = new Array();
		
		for (i = 0; i < 4; i++) {
			if (i < m_Cfg.BGLayer.length) bglayer = m_Cfg.BGLayer[i];
			else { bglayer = new Object(); m_Cfg.BGLayer.push(bglayer); }

			bglayer.Z = 5;
			bglayer.BeginX = 0;
			bglayer.BeginY = 0;

			bglayer.Img1 = 0;
			bglayer.Clr1 = 0xffffffff;
			bglayer.Rotate1 = 0;
			bglayer.FlipX1 = false;
			bglayer.FlipY1 = false;
			bglayer.Hue1 = 0;
			bglayer.Contrast1 = 0;
			bglayer.Brightness1 = 0;
			bglayer.Saturation1 = 0;

			bglayer.Img2 = 0;
			bglayer.Clr2 = 0xffffffff;
			bglayer.Rotate2 = 0;
			bglayer.FlipX2 = false;
			bglayer.FlipY2 = false;
			bglayer.Hue2 = 0;
			bglayer.Contrast2 = 0;
			bglayer.Brightness2 = 0;
			bglayer.Saturation2 = 0;
			
			bglayer.Img3 = 0;
			bglayer.Clr3 = 0xffffffff;
			bglayer.Rotate3 = 0;
			bglayer.FlipX3 = false;
			bglayer.FlipY3 = false;
			bglayer.Hue3 = 0;
			bglayer.Contrast3 = 0;
			bglayer.Brightness3 = 0;
			bglayer.Saturation3 = 0;
			
			bglayer.Img4 = 0;
			bglayer.Clr4 = 0xffffffff;
			bglayer.Rotate4 = 0;
			bglayer.FlipX4 = false;
			bglayer.FlipY4 = false;
			bglayer.Hue4 = 0;
			bglayer.Contrast4 = 0;
			bglayer.Brightness4 = 0;
			bglayer.Saturation4 = 0;
		}
	}
	
	public function CfgSave():String
	{
		var i:int;
		
		var str:String = "2";
		str += "~" + m_Cfg.Size.toString();
		str += "~" + m_Cfg.OffX.toString();
		str += "~" + m_Cfg.OffY.toString();
//		str += "~" + m_Cfg.Z.toString();
		
		str += "~" + m_Cfg.FillColor.toString(16);
		str += "~" + m_Cfg.FillImg.toString();
		
		str += "~" + m_Cfg.ColorGrid.toString(16);
		str += "~" + m_Cfg.ColorCoord.toString(16);
		str += "~" + m_Cfg.ColorTrade.toString(16);
		str += "~" + m_Cfg.ColorRoute.toString(16);
		
		for (i = 0; i < 4; i++) {
			var bglayer:Object = m_Cfg.BGLayer[i];
			
			str += "~" + bglayer.Z.toString();
			str += "~" + bglayer.BeginX.toString();
			str += "~" + bglayer.BeginY.toString();
			
			str += "~" + bglayer.Img1.toString();
			str += "~" + bglayer.Clr1.toString(16);
			str += "~" + bglayer.Rotate1.toString();
			if(bglayer.FlipX1) str += "~1"; else str += "~0";
			if(bglayer.FlipY1) str += "~1"; else str += "~0";
			str += "~" + bglayer.Hue1.toString();
			str += "~" + bglayer.Brightness1.toString();
			str += "~" + bglayer.Contrast1.toString();
			str += "~" + bglayer.Saturation1.toString();

			str += "~" + bglayer.Img2.toString();
			str += "~" + bglayer.Clr2.toString(16);
			str += "~" + bglayer.Rotate2.toString();
			if(bglayer.FlipX2) str += "~1"; else str += "~0";
			if(bglayer.FlipY2) str += "~1"; else str += "~0";
			str += "~" + bglayer.Hue2.toString();
			str += "~" + bglayer.Brightness2.toString();
			str += "~" + bglayer.Contrast2.toString();
			str += "~" + bglayer.Saturation2.toString();
			
			str += "~" + bglayer.Img3.toString();
			str += "~" + bglayer.Clr3.toString(16);
			str += "~" + bglayer.Rotate3.toString();
			if(bglayer.FlipX3) str += "~1"; else str += "~0";
			if(bglayer.FlipY3) str += "~1"; else str += "~0";
			str += "~" + bglayer.Hue3.toString();
			str += "~" + bglayer.Brightness3.toString();
			str += "~" + bglayer.Contrast3.toString();
			str += "~" + bglayer.Saturation3.toString();
			
			str += "~" + bglayer.Img4.toString();
			str += "~" + bglayer.Clr4.toString(16);
			str += "~" + bglayer.Rotate4.toString();
			if(bglayer.FlipX4) str += "~1"; else str += "~0";
			if(bglayer.FlipY4) str += "~1"; else str += "~0";
			str += "~" + bglayer.Hue4.toString();
			str += "~" + bglayer.Brightness4.toString();
			str += "~" + bglayer.Contrast4.toString();
			str += "~" + bglayer.Saturation4.toString();
		}
		
		return str;
	}
	
	public function CfgLoad(str:String):Boolean
	{
		var i:int;
		var a:Array = str.split("~");
		var no:int = 0;
		
		if (a.length <= 0) return false;
		
		var ver:int = int(a[no++]);
		if (ver<2 || ver>2) return false;

		if ((no + 4) > a.length) return false;
		m_Cfg.Size=int(a[no++]);
		m_Cfg.OffX=int(a[no++]);
		m_Cfg.OffY=int(a[no++]);
		//m_Cfg.Z = int(a[no++]);
		
		if (m_Cfg.Size<2500 || m_Cfg.Size>4000-100) return false;
		if (m_Cfg.OffX<-10000 || m_Cfg.OffX>10000) return false;
		if (m_Cfg.OffY<-10000 || m_Cfg.OffY>10000) return false;
		//if (m_Cfg.Z<0 || m_Cfg.Z>100) return false;
		
		if ((no + 2) > a.length) return false;
		m_Cfg.FillColor = uint("0x" + a[no++]);
		m_Cfg.FillImg = int(a[no++]);

		if (m_Cfg.FillImg<0 || m_Cfg.FillImg>3) return false;

		if ((no + 4) > a.length) return false;
		m_Cfg.ColorGrid = uint("0x" + a[no++]);
		m_Cfg.ColorCoord = uint("0x" + a[no++]);
		m_Cfg.ColorTrade = uint("0x" + a[no++]);
		m_Cfg.ColorRoute = uint("0x" + a[no++]);

		for (i = 0; i < 4; i++) {
			var bglayer:Object = m_Cfg.BGLayer[i];

			if ((no + 2) > a.length) return false;
			bglayer.Z = int(a[no++]);
			if (bglayer.Z<0 || bglayer.Z>100) return false;
			bglayer.BeginX = int(a[no++]);
			bglayer.BeginY = int(a[no++]);

			if (bglayer.BeginX<0 || bglayer.BeginX>100) return false;
			if (bglayer.BeginY<0 || bglayer.BeginY>100) return false;

			if ((no + 9) > a.length) return false;
			bglayer.Img1 = int(a[no++]);
			bglayer.Clr1 = uint("0x" + a[no++]);
			bglayer.Rotate1 = int(a[no++]);
			bglayer.FlipX1 = int(a[no++]) != 0;
			bglayer.FlipY1 = int(a[no++]) != 0;
			bglayer.Hue1 = int(a[no++]);
			bglayer.Brightness1 = int(a[no++]);
			bglayer.Contrast1 = int(a[no++]);
			bglayer.Saturation1 = int(a[no++]);

			if (bglayer.Img1!=0 && FontImageObjById(bglayer.Img1) == null) return false;
			if (bglayer.Rotate1 != 0 && bglayer.Rotate1 != 90 && bglayer.Rotate1 != 180 && bglayer.Rotate1 != 270) return false;
			if (bglayer.Hue1<-1000 || bglayer.Hue1>1000) return false;
			if (bglayer.Contrast1<-1000 || bglayer.Contrast1>1000) return false;
			if (bglayer.Brightness1<-1000 || bglayer.Brightness1>1000) return false;
			if (bglayer.Saturation1<-1000 || bglayer.Saturation1>1000) return false;

			if ((no + 9) > a.length) return false;
			bglayer.Img2 = int(a[no++]);
			bglayer.Clr2 = uint("0x" + a[no++]);
			bglayer.Rotate2 = int(a[no++]);
			bglayer.FlipX2 = int(a[no++]) != 0;
			bglayer.FlipY2 = int(a[no++]) != 0;
			bglayer.Hue2 = int(a[no++]);
			bglayer.Brightness2 = int(a[no++]);
			bglayer.Contrast2 = int(a[no++]);
			bglayer.Saturation2 = int(a[no++]);

			if (bglayer.Img2!=0 && FontImageObjById(bglayer.Img2) == null) return false;
			if (bglayer.Rotate2 != 0 && bglayer.Rotate2 != 90 && bglayer.Rotate2 != 180 && bglayer.Rotate2 != 270) return false;
			if (bglayer.Hue2<-1000 || bglayer.Hue2>1000) return false;
			if (bglayer.Contrast2<-1000 || bglayer.Contrast2>1000) return false;
			if (bglayer.Brightness2<-1000 || bglayer.Brightness2>1000) return false;
			if (bglayer.Saturation2<-1000 || bglayer.Saturation2>1000) return false;

			if ((no + 9) > a.length) return false;
			bglayer.Img3 = int(a[no++]);
			bglayer.Clr3 = uint("0x" + a[no++]);
			bglayer.Rotate3 = int(a[no++]);
			bglayer.FlipX3 = int(a[no++]) != 0;
			bglayer.FlipY3 = int(a[no++]) != 0;
			bglayer.Hue3 = int(a[no++]);
			bglayer.Brightness3 = int(a[no++]);
			bglayer.Contrast3 = int(a[no++]);
			bglayer.Saturation3 = int(a[no++]);

			if (bglayer.Img3!=0 && FontImageObjById(bglayer.Img3) == null) return false;
			if (bglayer.Rotate3 != 0 && bglayer.Rotate3 != 90 && bglayer.Rotate3 != 180 && bglayer.Rotate3 != 270) return false;
			if (bglayer.Hue3<-1000 || bglayer.Hue3>1000) return false;
			if (bglayer.Contrast3<-1000 || bglayer.Contrast3>1000) return false;
			if (bglayer.Brightness3<-1000 || bglayer.Brightness3>1000) return false;
			if (bglayer.Saturation3<-1000 || bglayer.Saturation3>1000) return false;

			if ((no + 9) > a.length) return false;
			bglayer.Img4 = int(a[no++]);
			bglayer.Clr4 = uint("0x" + a[no++]);
			bglayer.Rotate4 = int(a[no++]);
			bglayer.FlipX4 = int(a[no++]) != 0;
			bglayer.FlipY4 = int(a[no++]) != 0;
			bglayer.Hue4 = int(a[no++]);
			bglayer.Brightness4 = int(a[no++]);
			bglayer.Contrast4 = int(a[no++]);
			bglayer.Saturation4 = int(a[no++]);

			if (bglayer.Img4!=0 && FontImageObjById(bglayer.Img4) == null) return false;
			if (bglayer.Rotate4 != 0 && bglayer.Rotate4 != 90 && bglayer.Rotate4 != 180 && bglayer.Rotate4 != 270) return false;
			if (bglayer.Hue4<-1000 || bglayer.Hue4>1000) return false;
			if (bglayer.Contrast4<-1000 || bglayer.Contrast4>1000) return false;
			if (bglayer.Brightness4<-1000 || bglayer.Brightness4>1000) return false;
			if (bglayer.Saturation4<-1000 || bglayer.Saturation4>1000) return false;
		}

		return no==a.length;
	}

	public function CfgRandom(seed:int):void
	{
		var r:int;
		var rnd:PRnd = new PRnd(seed);
		rnd.RndEx();

		while (true) {
			var imgno:int = rnd.Rnd(1, FonImages.length - 1);
			var imgobj:Object = FonImages[imgno];
			if (imgobj.Id == 41) continue;
			if (imgobj.Id == 8) continue;
			if (imgobj.Id == 9) continue;
			if (imgobj.Id == 11) continue;
			if (imgobj.Id == 13) continue;
			if (imgobj.Id == 21) continue;
			if (imgobj.Id == 22) continue;
			if (imgobj.Id == 25) continue;
			if (imgobj.Id == 23) continue;
			if (imgobj.Id == 31) continue;

			CfgClear();
			
			m_Cfg.FillImg = 1;
			
			m_Cfg.ColorGrid = imgobj.ColorGrid;
			m_Cfg.ColorCoord = imgobj.ColorCoord;
			m_Cfg.ColorTrade = imgobj.ColorTrade;
			m_Cfg.ColorRoute = imgobj.ColorRoute;
			
			m_Cfg.BGLayer[0].Img1 = imgobj.Id;
			m_Cfg.BGLayer[0].Img2 = imgobj.Id;
			m_Cfg.BGLayer[0].Img3 = imgobj.Id;
			m_Cfg.BGLayer[0].Img4 = imgobj.Id;

			m_Cfg.BGLayer[0].Contrast1 = 10;
			m_Cfg.BGLayer[0].Contrast2 = 10;
			m_Cfg.BGLayer[0].Contrast3 = 10;
			m_Cfg.BGLayer[0].Contrast4 = 10;

			m_Cfg.BGLayer[0].Saturation1 = 10;
			m_Cfg.BGLayer[0].Saturation2 = 10;
			m_Cfg.BGLayer[0].Saturation3 = 10;
			m_Cfg.BGLayer[0].Saturation4 = 10;
			
			r = rnd.Rnd(0, 100);
			if (r < 25) m_Cfg.BGLayer[0].Rotate1 = 0;
			else if (r < 50) m_Cfg.BGLayer[0].Rotate1 = 90;
			else if (r < 75) m_Cfg.BGLayer[0].Rotate1 = 180;
			else m_Cfg.BGLayer[0].Rotate1 = 270;
			
			r = rnd.Rnd(0, 100);
			if (r < 25) m_Cfg.BGLayer[0].Rotate2 = 0;
			else if (r < 50) m_Cfg.BGLayer[0].Rotate2 = 90;
			else if (r < 75) m_Cfg.BGLayer[0].Rotate2 = 180;
			else m_Cfg.BGLayer[0].Rotate2 = 270;

			r = rnd.Rnd(0, 100);
			if (r < 25) m_Cfg.BGLayer[0].Rotate3 = 0;
			else if (r < 50) m_Cfg.BGLayer[0].Rotate3 = 90;
			else if (r < 75) m_Cfg.BGLayer[0].Rotate3 = 180;
			else m_Cfg.BGLayer[0].Rotate3 = 270;

			r = rnd.Rnd(0, 100);
			if (r < 25) m_Cfg.BGLayer[0].Rotate4 = 0;
			else if (r < 50) m_Cfg.BGLayer[0].Rotate4 = 90;
			else if (r < 75) m_Cfg.BGLayer[0].Rotate4 = 180;
			else m_Cfg.BGLayer[0].Rotate4 = 270;
			
			if (rnd.Rnd(0, 100) > 50) m_Cfg.BGLayer[0].FlipX1 = true;
			if (rnd.Rnd(0, 100) > 50) m_Cfg.BGLayer[0].FlipY1 = true;

			if (rnd.Rnd(0, 100) > 50) m_Cfg.BGLayer[0].FlipX2 = true;
			if (rnd.Rnd(0, 100) > 50) m_Cfg.BGLayer[0].FlipY2 = true;

			if (rnd.Rnd(0, 100) > 50) m_Cfg.BGLayer[0].FlipX3 = true;
			if (rnd.Rnd(0, 100) > 50) m_Cfg.BGLayer[0].FlipY3 = true;

			if (rnd.Rnd(0, 100) > 50) m_Cfg.BGLayer[0].FlipX4 = true;
			if (rnd.Rnd(0, 100) > 50) m_Cfg.BGLayer[0].FlipY4 = true;
			break;
		}
	}

	public function FonImageAdd(id:int, name:String, path:String, colorgrid:uint = 0xac303000, colorcoord:uint = 0xcc909000, colortrade:uint = 0xb0608000, colorroute:uint = 0xb0F00000):void
	{
		var obj:Object = new Object();
		obj.Id = id;
		obj.Name = name;
		obj.Path = path;
		obj.ColorGrid = colorgrid;
		obj.ColorCoord = colorcoord;
		obj.ColorTrade = colortrade;
		obj.ColorRoute = colorroute;
		obj.BM = null;
		FonImages.push(obj);
	}
	
	public function FontImageObjById(id:int):Object
	{
		var i:int;
		for (i = 0; i < FonImages.length; i++) {
			var obj:Object = FonImages[i];
			if (obj.Id != id) continue;
			
			return obj;
		}
		return null;
	}
	
/*	
  	public function FontImageById(id:int):Bitmap //Data
	{
		var i:int;
		for (i = 0; i < FonImages.length; i++) {
			var obj:Object = FonImages[i];
			if (obj.Id != id) continue;

			if (obj.BM != null) return obj.BM;

			var lo:DisplayObject = LoadManager.Self.Get(obj.Path) as DisplayObject;
			if (lo==null) return null;

			obj.BM = (lo as Bitmap);// .bitmapData;

			return obj.BM;
		}
		return null;
	}
	*/

  	public function FonPathById(id:int):String
	{
		var i:int;
		for (i = 0; i < FonImages.length; i++) {
			var obj:Object = FonImages[i];
			if (obj.Id != id) continue;
			return obj.Path;
		}
		return null;
	}

//	public function AfterLoadGraph():void
//	{
//		var cl:Class=ApplicationDomain.currentDomain.getDefinition("ImgBG") as Class;
//		m_BGImage=new cl(0,0);
//		NeedUpdate();
//	}

	public function Clear():void
	{
		var i:int;
		m_TexFill = null;
		for (i = 0; i < m_TexFon.length; i++) m_TexFon[i] = null;
		
//		m_GridText.free();
//		m_GridLineQB.free();

/*		var i:int;
		var obj:Object;

		if (m_BGImage != null) {
			m_BGImage.dispose();
			m_BGImage = null;
		}
		
		for(i=m_IL.length-1;i>=0;i--) {
			obj=m_IL[i];

			removeChild(obj.m_Txt);
			obj.m_Txt=null;
			m_IL.splice(i,1);
		}*/
	}

//	public function onLoadComplate(e:Event):void
//	{
//		if (m_BGImage != null) return;
//		Prepare();
//		if (m_BGImage != null) DrawContent();
//	}

/*	public function Prepare():void
	{
		if (m_BGImage != null) return;

		//var lo:DisplayObject = LoadManager.Self.Get("empire/bg25.jpg");
		//if (!lo) return;
		//m_BGImage = (lo as Bitmap).bitmapData;
		
		var layer:int,tx:int,ty:int;
		var tbm:BitmapData;
		var ac:AdjustColor;
		var filter:ColorMatrixFilter;
		var filters:Array;
		var m:Matrix = new Matrix();
		var um:Matrix;
		var r:Rectangle = new Rectangle();

		var bm1:IBitmapDrawable = null;
		var bm2:IBitmapDrawable = null;
		var bm3:IBitmapDrawable = null;
		var bm4:IBitmapDrawable = null;

		if (m_Cfg.FillImg!=0) {
			bm1 = LoadManager.Self.Get("empire/stars" + m_Cfg.FillImg.toString() + ".png") as DisplayObject;
			if (bm1 == null) return;
		}

		for (layer = 0; layer < 4;layer++) {
			bm1 = null;
			bm2 = null;
			bm3 = null;
			bm4 = null;
			
			if(m_Cfg.BGLayer[layer].Img1!=0) {
				bm1 = FontImageById(m_Cfg.BGLayer[layer].Img1);
				if (bm1 == null) return;
			}
			if(m_Cfg.BGLayer[layer].Img2!=0) {
				bm2 = FontImageById(m_Cfg.BGLayer[layer].Img2);
				if (bm2 == null) return;
			}
			if(m_Cfg.BGLayer[layer].Img3!=0) {
				bm3 = FontImageById(m_Cfg.BGLayer[layer].Img3);
				if (bm3 == null) return;
			}
			if(m_Cfg.BGLayer[layer].Img4!=0) {
				bm4 = FontImageById(m_Cfg.BGLayer[layer].Img4);
				if (bm4 == null) return;
			}
		}

		var bs:int = m_Cfg.Size; // 2000+2000-250*2 и кратное 512
		if (bs < 2500) { bs = 2500; m_Cfg.Size = bs;  }
		else if (bs >= 4000 - 100) { bs = 4000 - 100; m_Cfg.Size = bs;  }
		
		m_BGImage = new BitmapData(bs, bs, false, m_Cfg.FillColor);
		
		if (m_Cfg.FillImg!=0) {
			bm1 = LoadManager.Self.Get("empire/stars" + m_Cfg.FillImg.toString() + ".png") as DisplayObject;
			if (bm1 == null) return;
			
			for (ty = 0; ty < bs; ty += (bm1 as Bitmap).height) {
				for (tx = 0; tx < bs; tx += (bm1 as Bitmap).width) {
					m.identity(); m.translate(tx, ty); m_BGImage.draw(bm1, m, null, BlendMode.SCREEN);
				}
			}
		}

		for (layer = 0; layer < 4;layer++) {
			var lo:Object = m_Cfg.BGLayer[layer];

			bm1 = null;
			bm2 = null;
			bm3 = null;
			bm4 = null;

			var beginx:int = m_Cfg.BGLayer[layer].BeginX;
			if (beginx < 0) { beginx = 0;  m_Cfg.BGLayer[layer].BeginX = beginx; }
			else if (beginx > 100) { beginx = 100; m_Cfg.BGLayer[layer].BeginX = beginx; }
			
			var beginy:int = m_Cfg.BGLayer[layer].BeginY;
			if (beginy < 0) { beginy = 0;  m_Cfg.BGLayer[layer].BeginY = beginy; }
			else if (beginy > 100) { beginy = 100; m_Cfg.BGLayer[layer].BeginY = beginy; }
			
			beginx = Math.floor((bs - 2000 - 1) * Number(beginx) / 100);
			beginy = Math.floor((bs - 2000 - 1) * Number(beginy) / 100);

			var offx:int = bs - (2000 - ((2000 * 2 - bs) >> 1)) + beginx;
			var offy:int = bs - (2000 - ((2000 * 2 - bs) >> 1)) + beginy;

			if(m_Cfg.BGLayer[layer].Img1!=0) {
				bm1 = FontImageById(m_Cfg.BGLayer[layer].Img1);
				if (bm1 == null) return;
			}
			if(m_Cfg.BGLayer[layer].Img2!=0) {
				bm2 = FontImageById(m_Cfg.BGLayer[layer].Img2);
				if (bm2 == null) return;
			}
			if(m_Cfg.BGLayer[layer].Img3!=0) {
				bm3 = FontImageById(m_Cfg.BGLayer[layer].Img3);
				if (bm3 == null) return;
			}
			if(m_Cfg.BGLayer[layer].Img4!=0) {
				bm4 = FontImageById(m_Cfg.BGLayer[layer].Img4);
				if (bm4 == null) return;
			}
			
			if (bm1 != null) {
				ac = null;
				um = null;
				if (lo.Hue1 != 0 || lo.Contrast1 != 0 || lo.Brightness1 != 0 || lo.Saturation1 != 0) ac = new AdjustColor();
				if (lo.FlipX1 || lo.FlipY1 || lo.Rotate1 != 0) um = m;

				if (ac != null || um!=null) {
					tx = (bm1 as Bitmap).width;
					ty = (bm1 as Bitmap).height;

					if(ac!=null) {
						ac.brightness = lo.Brightness1;
						ac.contrast = lo.Contrast1;
						ac.hue = lo.Hue1;
						ac.saturation = lo.Saturation1;
						filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
						filters = new Array();
						filters.push(filter);
						(bm1 as Bitmap).filters = filters;
					}

					if(um!=null) {
						um.identity();
						um.translate( -tx / 2, -ty / 2);
						if (lo.FlipX1 && lo.FlipY1) um.scale( -1.0, -1.0);
						else if (lo.FlipX1) um.scale( -1.0, 1.0);
						else if (lo.FlipY1) um.scale( 1.0, -1.0);
						if(lo.Rotate1!=0) um.rotate(lo.Rotate1 * (Math.PI / 180));
						um.translate(tx / 2, ty / 2);
					}

					tbm = new BitmapData(tx, ty, false, 0x000000);
					tbm.draw(bm1,um);
					(bm1 as Bitmap).filters = null;
					bm1 = tbm;
				}
			}
			if (bm2 != null) {
				ac = null;
				um = null;
				if (lo.Hue2 != 0 || lo.Contrast2 != 0 || lo.Brightness2 != 0 || lo.Saturation2 != 0) ac = new AdjustColor();
				if (lo.FlipX2 || lo.FlipY2 || lo.Rotate2 != 0) um = m;

				if (ac != null || um!=null) {
					tx = (bm2 as Bitmap).width;
					ty = (bm2 as Bitmap).height;

					if(ac!=null) {
						ac.brightness = lo.Brightness2;
						ac.contrast = lo.Contrast2;
						ac.hue = lo.Hue2;
						ac.saturation = lo.Saturation2;
						filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
						filters = new Array();
						filters.push(filter);
						(bm2 as Bitmap).filters = filters;
					}

					if(um!=null) {
						um.identity();
						um.translate( -tx / 2, -ty / 2);
						if (lo.FlipX2 && lo.FlipY2) um.scale( -1.0, -1.0);
						else if (lo.FlipX2) um.scale( -1.0, 1.0);
						else if (lo.FlipY2) um.scale( 1.0, -1.0);
						if(lo.Rotate2!=0) um.rotate(lo.Rotate2 * (Math.PI / 180));
						um.translate(tx / 2, ty / 2);
					}

					tbm = new BitmapData(tx, ty, false, 0x000000);
					tbm.draw(bm2,um);
					(bm2 as Bitmap).filters = null;
					bm2 = tbm;
				}
			}
			if (bm3 != null) {
				ac = null;
				um = null;
				if (lo.Hue3 != 0 || lo.Contrast3 != 0 || lo.Brightness3 != 0 || lo.Saturation3 != 0) ac = new AdjustColor();
				if (lo.FlipX3 || lo.FlipY3 || lo.Rotate3 != 0) um = m;

				if (ac != null || um!=null) {
					tx = (bm3 as Bitmap).width;
					ty = (bm3 as Bitmap).height;

					if(ac!=null) {
						ac.brightness = lo.Brightness3;
						ac.contrast = lo.Contrast3;
						ac.hue = lo.Hue3;
						ac.saturation = lo.Saturation3;
						filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
						filters = new Array();
						filters.push(filter);
						(bm3 as Bitmap).filters = filters;
					}

					if(um!=null) {
						um.identity();
						um.translate( -tx / 2, -ty / 2);
						if (lo.FlipX3 && lo.FlipY3) um.scale( -1.0, -1.0);
						else if (lo.FlipX3) um.scale( -1.0, 1.0);
						else if (lo.FlipY3) um.scale( 1.0, -1.0);
						if(lo.Rotate3!=0) um.rotate(lo.Rotate3 * (Math.PI / 180));
						um.translate(tx / 2, ty / 2);
					}

					tbm = new BitmapData(tx, ty, false, 0x000000);
					tbm.draw(bm3,um);
					(bm3 as Bitmap).filters = null;
					bm3 = tbm;
				}
			}
			if (bm4 != null) {
				ac = null;
				um = null;
				if (lo.Hue4 != 0 || lo.Contrast4 != 0 || lo.Brightness4 != 0 || lo.Saturation4 != 0) ac = new AdjustColor();
				if (lo.FlipX4 || lo.FlipY4 || lo.Rotate4 != 0) um = m;

				if (ac != null || um!=null) {
					tx = (bm4 as Bitmap).width;
					ty = (bm4 as Bitmap).height;

					if(ac!=null) {
						ac.brightness = lo.Brightness4;
						ac.contrast = lo.Contrast4;
						ac.hue = lo.Hue4;
						ac.saturation = lo.Saturation4;
						filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
						filters = new Array();
						filters.push(filter);
						(bm4 as Bitmap).filters = filters;
					}

					if(um!=null) {
						um.identity();
						um.translate( -tx / 2, -ty / 2);
						if (lo.FlipX4 && lo.FlipY4) um.scale( -1.0, -1.0);
						else if (lo.FlipX4) um.scale( -1.0, 1.0);
						else if (lo.FlipY4) um.scale( 1.0, -1.0);
						if(lo.Rotate4!=0) um.rotate(lo.Rotate4 * (Math.PI / 180));
						um.translate(tx / 2, ty / 2);
					}

					tbm = new BitmapData(tx, ty, false, 0x000000);
					tbm.draw(bm4,um);
					(bm4 as Bitmap).filters = null;
					bm4 = tbm;
				}
			}
//			if(bm2!=null) {
//			if(m_Cfg.BGLayer[layer].Hue2!=0 || m_Cfg.BGLayer[layer].Contrast2!=0 || m_Cfg.BGLayer[layer].Brightness2!=0 || m_Cfg.BGLayer[layer].Saturation2!=0) {
//					ac=new AdjustColor();
//					ac.brightness = m_Cfg.BGLayer[layer].Brightness2;
//					ac.contrast = m_Cfg.BGLayer[layer].Contrast2;
//					ac.hue = m_Cfg.BGLayer[layer].Hue2;
//					ac.saturation = m_Cfg.BGLayer[layer].Saturation2;
//					filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
//					filters = new Array();
//					filters.push(filter);
//					(bm2 as Bitmap).filters = filters;
//				
//					tbm = new BitmapData((bm2 as Bitmap).width, (bm2 as Bitmap).height, false, 0x000000);
//					tbm.draw(bm2);
//					(bm2 as Bitmap).filters = null;
//					bm2 = tbm;
//				}
//			}
//			if(bm3!=null) {
//				if(m_Cfg.BGLayer[layer].Hue3!=0 || m_Cfg.BGLayer[layer].Contrast3!=0 || m_Cfg.BGLayer[layer].Brightness3!=0 || m_Cfg.BGLayer[layer].Saturation3!=0) {
//					ac=new AdjustColor();
//					ac.brightness = m_Cfg.BGLayer[layer].Brightness3;
//					ac.contrast = m_Cfg.BGLayer[layer].Contrast3;
//					ac.hue = m_Cfg.BGLayer[layer].Hue3;
//					ac.saturation = m_Cfg.BGLayer[layer].Saturation3;
//					filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
//					filters = new Array();
//					filters.push(filter);
//					(bm3 as Bitmap).filters = filters;
//				
//					tbm = new BitmapData((bm3 as Bitmap).width, (bm3 as Bitmap).height, false, 0x000000);
//					tbm.draw(bm3);
//					(bm3 as Bitmap).filters = null;
//					bm3 = tbm;
//				}
//			}
//			if(bm4!=null) {
//				if(m_Cfg.BGLayer[layer].Hue4!=0 || m_Cfg.BGLayer[layer].Contrast4!=0 || m_Cfg.BGLayer[layer].Brightness4!=0 || m_Cfg.BGLayer[layer].Saturation4!=0) {
//					ac=new AdjustColor();
//					ac.brightness = m_Cfg.BGLayer[layer].Brightness4;
//					ac.contrast = m_Cfg.BGLayer[layer].Contrast4;
//					ac.hue = m_Cfg.BGLayer[layer].Hue4;
//					ac.saturation = m_Cfg.BGLayer[layer].Saturation4;
//					filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
//					filters = new Array();
//					filters.push(filter);
//					(bm4 as Bitmap).filters = filters;
//
//					tbm = new BitmapData((bm4 as Bitmap).width, (bm4 as Bitmap).height, false, 0x000000);
//					tbm.draw(bm4);
//					(bm4 as Bitmap).filters = null;
//					bm4 = tbm;
//				}
//			}

			if (bm1 != null) { m.identity(); m.translate(beginx, beginy); m_BGImage.draw(bm1, m, null, BlendMode.SCREEN); }

			if (bm2 != null) { m.identity(); m.translate(offx, beginy); m_BGImage.draw(bm2, m, null, BlendMode.SCREEN); }
			if (bm2 != null) { m.identity(); m.translate( -(bs - offx), beginy); m_BGImage.draw(bm2, m, null, BlendMode.SCREEN); }

			if (bm3 != null) { m.identity(); m.translate(beginx, offy); m_BGImage.draw(bm3, m, null, BlendMode.SCREEN); }
			if (bm3 != null) { m.identity(); m.translate(beginx, -(bs - offy)); m_BGImage.draw(bm3, m, null, BlendMode.SCREEN); }

			if (bm4 != null) { m.identity(); m.translate(offx, offy); m_BGImage.draw(bm4, m, null, BlendMode.SCREEN); }
			if (bm4 != null) { m.identity(); m.translate( -(bs - offx), offy); m_BGImage.draw(bm4, m, null, BlendMode.SCREEN); }
			if (bm4 != null) { m.identity(); m.translate(offx, -(bs - offy)); m_BGImage.draw(bm4, m, null, BlendMode.SCREEN); }
			if (bm4 != null) { m.identity(); m.translate( -(bs - offx), -(bs - offy)); m_BGImage.draw(bm4, m, null, BlendMode.SCREEN); }
		}
	}*/

	public function DrawContent():void
	{
/*		var i:int, cnt:int, x:int, y:int, cx:int, cy:int, ex:int, ey:int;

		graphics.clear();
//		if(m_BGImage==null) return;
//return;

		if (m_Map.m_Set_BG) {
			Prepare();
			if (m_BGImage == null) {
				graphics.lineStyle(1,0x000099,0);
				graphics.beginFill(0x000000);
				graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
				graphics.endFill();
			} else {
				var m:Matrix=new Matrix();
				m.identity();
				m.translate( -m_OffsetX * (1.0/m_Cfg.Z) + m_Cfg.OffX, -m_OffsetY * (1.0/m_Cfg.Z) + m_Cfg.OffY);
				//m.translate( -m_OffsetX * 1.0, -m_OffsetY * 1.0);
		
				graphics.lineStyle(1,0x000099,0);
				graphics.beginBitmapFill(m_BGImage,m,true);
				graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
				graphics.endFill();
			}
		} else {
			graphics.lineStyle(1,0x000099,0);
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}

		// Grid
		if(m_Map.m_Set_Grid) {
			if (m_Map.m_SectorSize > 0) {
				graphics.lineStyle(2,m_Cfg.ColorGrid,Number(Math.floor(m_Cfg.ColorGrid/16777216))/255.0);

				cx=Math.max(m_Map.m_SectorMinX,Math.floor(m_Map.ScreenToWorldX(0)/m_Map.m_SectorSize));
				cnt=Math.min(m_Map.m_SectorMinX+m_Map.m_SectorCntX,Math.floor(m_Map.ScreenToWorldX(stage.stageWidth)/m_Map.m_SectorSize))-cx+1;

				var b:Number=m_Map.ScreenToWorldY(0);
				if(b<m_Map.m_SectorMinY*m_Map.m_SectorSize) b=m_Map.m_SectorMinY*m_Map.m_SectorSize;
				else if(b>=(m_Map.m_SectorMinY+m_Map.m_SectorCntY)*m_Map.m_SectorSize) b=(m_Map.m_SectorMinY+m_Map.m_SectorCntY)*m_Map.m_SectorSize;
				
				var e:Number=m_Map.ScreenToWorldY(stage.stageHeight);
				if(e<m_Map.m_SectorMinY*m_Map.m_SectorSize) e=m_Map.m_SectorMinY*m_Map.m_SectorSize;
				else if(e>=(m_Map.m_SectorMinY+m_Map.m_SectorCntY)*m_Map.m_SectorSize) e=(m_Map.m_SectorMinY+m_Map.m_SectorCntY)*m_Map.m_SectorSize;
				
				b=m_Map.WorldToScreenY(b);
				e=m_Map.WorldToScreenY(e);

				for(i=0; i<cnt; i++) {
					x=m_Map.WorldToScreenX((cx+i)*m_Map.m_SectorSize);

					graphics.moveTo(x,b); //m_Map.WorldToScreenY(m_Map.m_SectorMinY*m_Map.m_SectorSize)
					graphics.lineTo(x,e); //m_Map.WorldToScreenY((m_Map.m_SectorMinY+m_Map.m_SectorCntY)*m_Map.m_SectorSize)
				}

				cy=Math.max(m_Map.m_SectorMinY,Math.floor(m_Map.ScreenToWorldY(0)/m_Map.m_SectorSize));
				cnt=Math.min(m_Map.m_SectorMinY+m_Map.m_SectorCntY,Math.floor(m_Map.ScreenToWorldY(stage.stageHeight)/m_Map.m_SectorSize))-cy+1;

				b=m_Map.ScreenToWorldX(0);
				if(b<m_Map.m_SectorMinX*m_Map.m_SectorSize) b=m_Map.m_SectorMinX*m_Map.m_SectorSize;
				else if(b>=(m_Map.m_SectorMinX+m_Map.m_SectorCntX)*m_Map.m_SectorSize) b=(m_Map.m_SectorMinX+m_Map.m_SectorCntX)*m_Map.m_SectorSize;
				
				e=m_Map.ScreenToWorldX(stage.stageWidth);
				if(e<m_Map.m_SectorMinX*m_Map.m_SectorSize) e=m_Map.m_SectorMinX*m_Map.m_SectorSize;
				else if(e>=(m_Map.m_SectorMinX+m_Map.m_SectorCntX)*m_Map.m_SectorSize) e=(m_Map.m_SectorMinX+m_Map.m_SectorCntX)*m_Map.m_SectorSize;
				
				b=m_Map.WorldToScreenX(b);
				e=m_Map.WorldToScreenX(e);

				for(i=0; i<cnt; i++) {
					y=m_Map.WorldToScreenY((cy+i)*m_Map.m_SectorSize);

					graphics.moveTo(b,y);//m_Map.WorldToScreenX(m_Map.m_SectorMinX*m_Map.m_SectorSize)
					graphics.lineTo(e,y);//m_Map.WorldToScreenX((m_Map.m_SectorMinX+m_Map.m_SectorCntX)*m_Map.m_SectorSize)
				}
			}
		}
		
		// Cell
		if (false) {
			cx = Math.max(m_Map.m_SectorMinX, Math.floor(m_Map.ScreenToWorldX(0) / m_Map.m_SectorSize));
			cy = Math.max(m_Map.m_SectorMinY, Math.floor(m_Map.ScreenToWorldY(0) / m_Map.m_SectorSize));

			ex = Math.min(m_Map.m_SectorMinX + m_Map.m_SectorCntX, Math.floor(m_Map.ScreenToWorldX(stage.stageWidth) / m_Map.m_SectorSize)) + 1;
			ey = Math.min(m_Map.m_SectorMinY + m_Map.m_SectorCntY, Math.floor(m_Map.ScreenToWorldY(stage.stageHeight) / m_Map.m_SectorSize)) + 1;
			
			for (y = cy; y < ey; y++) {
				for (x = cx; x < ex; x++) {
					for (i = 0; i < m_Map.m_MB_LoadSector.length; i++) {
						if (m_Map.m_MB_LoadSector[i].m_SectorX == x && m_Map.m_MB_LoadSector[i].m_SectorY == y) break;
					}
					if (i >= m_Map.m_MB_LoadSector.length) continue;
					
					graphics.lineStyle(0, 0, 0);
					graphics.beginFill(0xff0000, 0.5);
					graphics.drawRect(
						m_Map.WorldToScreenX(x * m_Map.m_SectorSize)+2, 
						m_Map.WorldToScreenY(y * m_Map.m_SectorSize)+2, 
						m_Map.WorldToScreenX(x * m_Map.m_SectorSize + m_Map.m_SectorSize) - m_Map.WorldToScreenX(x * m_Map.m_SectorSize)-4, 
						m_Map.WorldToScreenY(y * m_Map.m_SectorSize + m_Map.m_SectorSize) - m_Map.WorldToScreenY(y * m_Map.m_SectorSize)-4);
					graphics.endFill();
				}
			}
		}
		
		ILUpdate();*/
	}
	
/*	public function NeedUpdate():void
	{
		m_OffsetX=-1000000000;
		m_OffsetY=-1000000000;
	}

	public function SetOffset(x:int,y:int):void
	{
		if(m_OffsetX==x && m_OffsetY==y) return;
		m_OffsetX=x;
		m_OffsetY=y;
//trace("BG SetOffset process");
		DrawContent();
	}
	
	public function ILUpdate():void
	{
		var str:String;
		var obj:Object;
		var sec:Sector;
		var x:int, y:int, i:int, offx:int, offy:int;
		var tf:TextField;

		var sx:int=Math.max(m_Map.m_SectorMinX,Math.floor(m_Map.ScreenToWorldX(0)/m_Map.m_SectorSize));
		var sy:int=Math.max(m_Map.m_SectorMinY,Math.floor(m_Map.ScreenToWorldY(0)/m_Map.m_SectorSize));
		var ex:int=Math.min(m_Map.m_SectorMinX+m_Map.m_SectorCntX,Math.floor(m_Map.ScreenToWorldX(m_Map.stage.stageWidth)/m_Map.m_SectorSize)+1);
		var ey:int = Math.min(m_Map.m_SectorMinY + m_Map.m_SectorCntY, Math.floor(m_Map.ScreenToWorldY(m_Map.stage.stageHeight) / m_Map.m_SectorSize) + 1);
		
		var dtf:TextFormat = new TextFormat("Calibri", 10, m_Cfg.ColorCoord & 0xffffff);
//trace((m_Cfg.ColorCoord & 0xffffff).toString(16));

		for(i=0;i<m_IL.length;i++) {
			m_IL[i].m_Del=true;
		}
		if(m_Map.m_Set_Grid)
		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				sec=m_Map.GetSector(x,y);
				if(sec==null) continue;
				
				if(sec.m_Planet.length<=0) continue;
				
				for(i=0;i<m_IL.length;i++) {
					obj=m_IL[i];
					if(obj.m_X==x && obj.m_Y==y) break;
				}
				if(i>=m_IL.length) {
					obj=new Object();
					m_IL.push(obj);
					obj.m_X=x;
					obj.m_Y=y;
					tf=new TextField();
					tf.type=TextFieldType.DYNAMIC;
					tf.selectable=false;
					tf.textColor=0xffff00;
					tf.border=false;
					tf.background=false;
					tf.multiline=false;
					tf.autoSize=TextFieldAutoSize.LEFT;
					tf.antiAliasType=AntiAliasType.ADVANCED;
					tf.gridFitType=GridFitType.PIXEL;
					tf.embedFonts=true;
					tf.visible=true;
					tf.addEventListener(MouseEvent.CLICK,SectorToChat);
					addChild(tf);
					obj.m_Txt=tf;
				}
				obj.m_Del=false;
				tf=obj.m_Txt;
				tf.defaultTextFormat=dtf;
				tf.alpha = Number(Math.floor(m_Cfg.ColorCoord / 16777216)) / 255.0;
//trace(tf.alpha);

				tf.width=1;
				tf.height=1;
				str="";
				if(EmpireMap.Self.m_Debug) str+="<font color='#404000'>("+sec.m_Infl.toString(16)+")</font> ";
				
				//str+=String.fromCharCode(65+Math.floor((x-m_Map.m_SectorMinX)/26));
				//str+=String.fromCharCode(65+((x-m_Map.m_SectorMinX) % 26));
				//if((x-m_Map.m_SectorMinX+1)<10) str+="0";
				str+=(x-m_Map.m_SectorMinX+1).toString();
				str+=",";

				//if((y-m_Map.m_SectorMinY+1)<10) str+="0";
				str+=(y-m_Map.m_SectorMinY+1).toString();

				tf.htmlText=str;//+x.toString()+","+y.toString();

				offx=m_Map.WorldToScreenX((x+1)*m_Map.m_SectorSize);
				offy=m_Map.WorldToScreenY((y+1)*m_Map.m_SectorSize);

				tf.x=offx-tf.width-2;
				tf.y=offy-tf.height-2;
			}
		}

		for(i=m_IL.length-1;i>=0;i--) {
			obj=m_IL[i];
			if(!obj.m_Del) continue;

			removeChild(obj.m_Txt);
			obj.m_Txt=null;
			m_IL.splice(i,1);
		}
	}*/
	
/*	public function ProcessClickChatSector():Boolean
	{
		var i:int;
		var tf:TextField;
		
		for(i=0;i<m_IL.length;i++) {
			tf=m_IL[i].m_Txt;
			if(tf.hitTestPoint(stage.mouseX,stage.mouseY)) {
				FormChat.Self.MsgAddText("["+tf.text+"]");
				return true;
			}
		}
		return false;
	}*/

	public function SectorToChat(e:MouseEvent):void
	{
		if((e.ctrlKey || e.altKey || e.shiftKey)) {
			var t:TextField=e.target as TextField;
			FormChat.Self.MsgAddText("["+t.text+"]");
		}
	}

	public function Prepare():Boolean
	{
		var layer:int, u:int, i:int, img:int, ajh:int, ajb:int, ajc:int, ajs:int;
		var ret:Boolean = true;
		var path:String;
		var mod:String;
		
		var st:Dictionary = null;
		var stcnt:int = 0;

		if (m_Cfg.FillImg == 0) {
			m_TexFill = null;
		} else {
			if (m_TexFill == null) m_TexFill = C3D.GetTexture("stars" + m_Cfg.FillImg.toString() + ".png");
			if (m_TexFill == null || m_TexFill.tex == null) ret = false;
		}

		for (layer = 0; layer < 4; layer++) {
			for (u = 0; u < 4; u++) {
				if (u == 0) { img = m_Cfg.BGLayer[layer].Img1; ajh=m_Cfg.BGLayer[layer].Hue1; ajb=m_Cfg.BGLayer[layer].Brightness1; ajc=m_Cfg.BGLayer[layer].Contrast1; ajs=m_Cfg.BGLayer[layer].Saturation1; }
				else if (u == 1) { img = m_Cfg.BGLayer[layer].Img2; ajh=m_Cfg.BGLayer[layer].Hue2; ajb=m_Cfg.BGLayer[layer].Brightness2; ajc=m_Cfg.BGLayer[layer].Contrast2; ajs=m_Cfg.BGLayer[layer].Saturation2; }
				else if (u == 2) { img = m_Cfg.BGLayer[layer].Img3; ajh=m_Cfg.BGLayer[layer].Hue3; ajb=m_Cfg.BGLayer[layer].Brightness3; ajc=m_Cfg.BGLayer[layer].Contrast3; ajs=m_Cfg.BGLayer[layer].Saturation3; }
				else { img = m_Cfg.BGLayer[layer].Img4; ajh = m_Cfg.BGLayer[layer].Hue4; ajb = m_Cfg.BGLayer[layer].Brightness4; ajc = m_Cfg.BGLayer[layer].Contrast4; ajs = m_Cfg.BGLayer[layer].Saturation4; }

				path = FonPathById(img);
				mod = null;
				if (ajh != 0 || ajb != 0 || ajc != 0 || ajs != 0) {
					if (st == null) st = new Dictionary();
					mod = "hbcs=" + ajh.toString() + " " + ajb.toString() + " " + ajc.toString() + " " + ajs.toString() + "~" + path;
					if (st[mod] == undefined) {
						path = "id=gbg" + stcnt.toString();
						st[mod] = stcnt;
						stcnt++;
					} else {
						path = "id=gbg" + st[mod].toString();
					}
				}

				i = layer * 4 + u;
				if (img == 0) {
					if (m_TexFon[i] != null) m_TexFon[i] = null;
				} else {
					if (m_TexFon[i] == null) m_TexFon[i] = C3D.GetTextureEx(path, mod);
					if (m_TexFon[i] == null || m_TexFon[i].tex == null) ret = false;
				}
			}
		}

		return ret;
	}

	public function Draw(offx:Number, offy:Number, layer:int):void
	{
		var x:int, y:int, tx:int, ty:int, k:int, i:int;
		var tex:C3DTexture;
		var ox:Number, oy:Number;

		var minz:Number = 100;// m_Cfg.BGLayer[0].Z;
		for (i = 0; i < 3; i++) {
			if (m_Cfg.BGLayer[i].Img1 == 0 && m_Cfg.BGLayer[i].Img2 == 0 && m_Cfg.BGLayer[i].Img3 == 0 && m_Cfg.BGLayer[i].Img3 == 0) continue;
			minz = Math.min(minz, m_Cfg.BGLayer[i].Z);
		}

		if (layer == -1) {
			if (m_TexFill == null) return;

			ox = Math.round(offx * (1.0 / minz) + m_Cfg.OffX);
			oy = Math.round(offy * (1.0 / minz) + m_Cfg.OffY);

			C3D.DrawImg(m_TexFill, 0xffffffff, 0, 0, C3D.m_SizeX, C3D.m_SizeY, ox, oy,  C3D.m_SizeX, C3D.m_SizeY);
			return;
		}
		
		var wps:Number = 2.0 / Number(C3D.m_SizeX);
		var hps:Number = 2.0 / Number(C3D.m_SizeY);

		var bs:int = m_Cfg.Size; // 2000+2000-250*2 и кратное 512
		if (bs < 2500) { bs = 2500; m_Cfg.Size = bs;  }
		else if (bs >= 4000 - 100) { bs = 4000 - 100; m_Cfg.Size = bs;  }

		var cellsize:Number = (bs >> 1) * minz;

		var z:Number = m_Cfg.BGLayer[layer].Z;
		
		C3D.VBImg();
		C3D.ShaderImg();

		C3D.SetVConst(0, new Vector3D(0.0, 0.5, 1.0, 2.0));
		C3D.SetFConst(0, new Vector3D(0.0, 0.5, 1.0, 2.0));
		
		var u0:Number, v0:Number;
		var u1:Number, v1:Number;
		var u2:Number, v2:Number;
		var u3:Number, v3:Number;
		var s:Number;
		var rotate:int;
		var flipx:Boolean, flipy:Boolean;
		var clr:uint;

		//var kk:int;
		//for (kk = 0; kk < 4;kk++) {
			for (y = -1; y <= 1; y++) {
				for (x = -1; x <= 1; x++) {
					ox = offx - m_Cfg.OffX * minz - m_Cfg.BGLayer[layer].BeginX * z;
					oy = offy - m_Cfg.OffY * minz - m_Cfg.BGLayer[layer].BeginY * z;
					
					var cellx:int = Math.floor(ox / cellsize);
					var celly:int = Math.floor(oy / cellsize);
			
					k = (((1000000 + cellx + x) & 1) + ((1000000 + celly + y) & 1) * 2);
					//if (k != kk) continue;
					tex = m_TexFon[layer * 4 + k];
					if (tex == null) continue;
					
					C3D.SetTexture(0, tex.tex);
					
					var cx:Number = ((cellx + x) * cellsize - ox) + cellsize * 0.5;
					var cy:Number = ((celly + y) * cellsize - oy) + cellsize * 0.5;
					var cz:Number = z;
					
					var x0:Number = (cx / cz) * wps - 1024 * wps;
					var y0:Number = -((cy / cz) * hps - 1024 * hps);
					var x1:Number = x0 + wps * 2048;
					var y1:Number = y0 - hps * 2048;
					
					if (k == 0) { flipx = m_Cfg.BGLayer[layer].FlipX1; flipy = m_Cfg.BGLayer[layer].FlipY1; rotate = m_Cfg.BGLayer[layer].Rotate1; clr = m_Cfg.BGLayer[layer].Clr1; }
					else if (k == 1) { flipx = m_Cfg.BGLayer[layer].FlipX2; flipy = m_Cfg.BGLayer[layer].FlipY2; rotate = m_Cfg.BGLayer[layer].Rotate2; clr = m_Cfg.BGLayer[layer].Clr2; }
					else if (k == 1) { flipx = m_Cfg.BGLayer[layer].FlipX3; flipy = m_Cfg.BGLayer[layer].FlipY3; rotate = m_Cfg.BGLayer[layer].Rotate3; clr = m_Cfg.BGLayer[layer].Clr3; }
					else { flipx = m_Cfg.BGLayer[layer].FlipX4; flipy = m_Cfg.BGLayer[layer].FlipY4; rotate = m_Cfg.BGLayer[layer].Rotate4; clr = m_Cfg.BGLayer[layer].Clr4; }
					
					if(rotate==0) {
						u0 = 0.0; v0 = 0.0;
						u1 = 1.0; v1 = 0.0;
						u2 = 1.0; v2 = 1.0;
						u3 = 0.0; v3 = 1.0;
	//					if (flipx) { s = u0; u0 = u1; u1 = s; s = u2; u2 = u3; u3 = s; }
	//					if (flipy) { s = v0; v0 = v3; v3 = s; s = v1; v1 = v2; v2 = s; }
					} else if (rotate == 270) {
						u0 = 1.0; v0 = 0.0;
						u1 = 1.0; v1 = 1.0;
						u2 = 0.0; v2 = 1.0;
						u3 = 0.0; v3 = 0.0;
					} else if (rotate == 180) {
						u0 = 1.0; v0 = 1.0;
						u1 = 0.0; v1 = 1.0;
						u2 = 0.0; v2 = 0.0;
						u3 = 1.0; v3 = 0.0;
	//					if (flipx) { s = u0; u0 = u1; u1 = s; s = u2; u2 = u3; u3 = s; }
	//					if (flipy) { s = v0; v0 = v3; v3 = s; s = v1; v1 = v2; v2 = s; }
					} else {
						u0 = 0.0; v0 = 1.0;
						u1 = 0.0; v1 = 0.0;
						u2 = 1.0; v2 = 0.0;
						u3 = 1.0; v3 = 1.0;
					}
					if (flipx) {
						s = u0; u0 = u1; u1 = s; 
						s = u2; u2 = u3; u3 = s;
						s = v0; v0 = v1; v1 = s;
						s = v2; v2 = v3; v3 = s; 
					}
					if (flipy) {
						s = u0; u0 = u3; u3 = s;
						s = u1; u1 = u2; u2 = s;
						s = v0; v0 = v3; v3 = s;
						s = v1; v1 = v2; v2 = s;
					}
					
					C3D.SetVConst(1, new Vector3D( x0, y0, u0, v0));
					C3D.SetVConst(2, new Vector3D( x1, y0, u1, v1));
					C3D.SetVConst(3, new Vector3D( x1, y1, u2, v2));
					C3D.SetVConst(4, new Vector3D( x0, y1, u3, v3));

	/*					if(um!=null) {
							um.identity();
							um.translate( -tx / 2, -ty / 2);
							if (lo.FlipX1 && lo.FlipY1) um.scale( -1.0, -1.0);
							else if (lo.FlipX1) um.scale( -1.0, 1.0);
							else if (lo.FlipY1) um.scale( 1.0, -1.0);
							if(lo.Rotate1!=0) um.rotate(lo.Rotate1 * (Math.PI / 180));
							um.translate(tx / 2, ty / 2);
						}*/

					C3D.SetFConst_n(1, C3D.ClrToFloat * ((clr >> 16) & 255), C3D.ClrToFloat * ((clr >> 8) & 255), C3D.ClrToFloat * ((clr) & 255), C3D.ClrToFloat * ((clr >> 24) & 255));
					//C3D.SetFConst_n(1, 1, 1, 1, 1);
					
					C3D.DrawQuad();

	//				ox = cx / cz - 1024;
	//				oy = cy / cz - 1024;
	//				C3D.DrawImg(tex, 0xffffffff, ox, oy, 2048, 2048, 0, 0, 2048, 2048);
				}
			}
//		}
		
		C3D.SetTexture(0, null);
	}

	public function DrawGrid():void
	{
		var i:int;
		var p:C3DParticle;
		var px:Number, py:Number;
		var x:int, y:int;

		var v0:Vector3D = new Vector3D();
		var v1:Vector3D = new Vector3D();
		var v2:Vector3D = new Vector3D();
		var v3:Vector3D = new Vector3D();

		if (!EmpireMap.Self.PickWorldCoord(0, 0, v0)) return;
		if (!EmpireMap.Self.PickWorldCoord(C3D.m_SizeX, 0, v1)) return;
		if (!EmpireMap.Self.PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, v2)) return;
		if (!EmpireMap.Self.PickWorldCoord(0, C3D.m_SizeY, v3)) return;

		var minx:Number = Math.min(v0.x, v1.x, v2.x, v3.x);
		var maxx:Number = Math.max(v0.x, v1.x, v2.x, v3.x);
		var miny:Number = Math.min(v0.y, v1.y, v2.y, v3.y);
		var maxy:Number = Math.max(v0.y, v1.y, v2.y, v3.y);
		
		var zminx:int = Math.floor(minx / EmpireMap.Self.m_SectorSize);
		var zminy:int = Math.floor(miny / EmpireMap.Self.m_SectorSize);
		if (zminx < EmpireMap.Self.m_SectorMinX) zminx = EmpireMap.Self.m_SectorMinX;
		if (zminy < EmpireMap.Self.m_SectorMinY) zminy = EmpireMap.Self.m_SectorMinY;
		minx = zminx;
		miny = zminy;
		
		var zmax:int = Math.floor(maxx / EmpireMap.Self.m_SectorSize) + 1;
		var zmay:int = Math.floor(maxy / EmpireMap.Self.m_SectorSize) + 1;
		if (zmax > EmpireMap.Self.m_SectorMinX + EmpireMap.Self.m_SectorCntX) zmax = EmpireMap.Self.m_SectorMinX + EmpireMap.Self.m_SectorCntX;
		if (zmay > EmpireMap.Self.m_SectorMinY + EmpireMap.Self.m_SectorCntY) zmay = EmpireMap.Self.m_SectorMinY + EmpireMap.Self.m_SectorCntY;

		var cntx:int = (zmax - minx);
		var cnty:int = (zmay - miny);
		if (cntx <= 0) return;
		if (cnty <= 0) return;
		if (cntx * cnty > 100) return;
		
		minx *= EmpireMap.Self.m_SectorSize;
		miny *= EmpireMap.Self.m_SectorSize;
		
		maxx = zmax * EmpireMap.Self.m_SectorSize;
		maxy = zmay * EmpireMap.Self.m_SectorSize;

		var mv:Matrix3D = EmpireMap.Self.m_MatViewInv;
		var nx:Number = mv.rawData[2 * 4 + 0];
		var ny:Number = mv.rawData[2 * 4 + 1];
		var nz:Number = mv.rawData[2 * 4 + 2];

		var cnt:int = 0;

		var s2w:Number = EmpireMap.Self.FactorScr2WorldDist(0.0, 0.0, 0.0) * 2.0;

		var clr:uint = m_Cfg.ColorGrid;

		for (i = 0, px = minx; i <= cntx; i++, px += EmpireMap.Self.m_SectorSize) { // px <= maxx
			if (cnt >= m_GridLine.length) m_GridLine.push(new C3DParticle());
			p = m_GridLine[cnt++];
			p.m_PosX = px - (EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize + EmpireMap.Self.m_CamPos.x);
			p.m_PosY = miny - (EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize + EmpireMap.Self.m_CamPos.y);
			p.m_PosZ = 0.0 - EmpireMap.Self.m_CamPos.z;
			p.m_NormalX = nx;// 0.0;
			p.m_NormalY = ny;// 0.0;
			p.m_NormalZ = nz;// 1.0;
			p.m_DirX = 0.0;
			p.m_DirY = 1.0;
			p.m_DirZ = 0.0;
			p.m_Width = s2w;
			p.m_Height = maxy - miny;
			p.m_U1 = 0.0;
			p.m_V1 = 0.0;
			p.m_U2 = 1.0;
			p.m_V2 = 1.0;
			p.m_Color = clr;
			p.m_ColorTo = p.m_Color;
			p.m_Flag |= C3DParticle.FlagShow;
		}

		for (i=0, py = miny; i <= cnty; i++, py += EmpireMap.Self.m_SectorSize) { //py <= maxy
			if (cnt >= m_GridLine.length) m_GridLine.push(new C3DParticle());
			p = m_GridLine[cnt++];
			p.m_PosX = minx - (EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize + EmpireMap.Self.m_CamPos.x);
			p.m_PosY = py - (EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize + EmpireMap.Self.m_CamPos.y);
			p.m_PosZ = 0.0 - EmpireMap.Self.m_CamPos.z;
			p.m_NormalX = nx;// 0.0;
			p.m_NormalY = ny;// 0.0;
			p.m_NormalZ = nz;// 1.0;
			p.m_DirX = 1.0;
			p.m_DirY = 0.0;
			p.m_DirZ = 0.0;
			p.m_Width = s2w;
			p.m_Height = maxx - minx;
			p.m_U1 = 0.0;
			p.m_V1 = 0.0;
			p.m_U2 = 1.0;
			p.m_V2 = 1.0;
			p.m_Color = clr;
			p.m_ColorTo = p.m_Color;
			p.m_Flag |= C3DParticle.FlagShow;
		}

		if (cnt < 2) return;

		m_GridLine[0].m_Prev = null; m_GridLine[0].m_Next = m_GridLine[1];
		m_GridLine[cnt-1].m_Prev = m_GridLine[cnt-2]; m_GridLine[cnt-1].m_Next = null;
		for (i = 1; i < (cnt - 1); i++) { m_GridLine[i].m_Prev = m_GridLine[i - 1]; m_GridLine[i].m_Next = m_GridLine[i + 1]; }
		m_GridLine[0].ToQuadBatch(false,m_GridLineQB);

		var t_dif:C3DTexture = C3D.GetTexture("white");
		if (t_dif.tex == null) return;

		C3D.SetVConstMatrix(0, EmpireMap.Self.m_MatViewPer);
		C3D.SetVConst(8, new Vector3D(0, 0, 0, 1.0));
		C3D.ShaderParticle();
		C3D.SetTexture(0, t_dif.tex);
		C3D.VBQuadBatch(m_GridLineQB);
		C3D.DrawQuadBatch();
		C3D.SetTexture(0, null);

//		var font:C3DFont = C3D.GetFont(m_GridText.m_FontName);
//		if (font == null) return;

		var str:String="";
		for (y = 0; y <= (cnty); y++) {
			for (x = 1; x <= cntx; x++) {
				str += ((zminx + x - 1) - EmpireMap.Self.m_SectorMinX + 1).toString() + "," + ((zminy + y) - EmpireMap.Self.m_SectorMinX + 1).toString() + "\n";
			}
		}
		m_GridText.SetText(str);
		m_GridText.Prepare();
		if (m_GridText.m_Font == null || m_GridText.m_LineCnt <= 0) return;
		
		clr = m_Cfg.ColorCoord;

		i = 0;
		for (y = 1, py = miny + EmpireMap.Self.m_SectorSize; y <= (cnty); y++, py += EmpireMap.Self.m_SectorSize) {
			for (x = 1, px = minx + EmpireMap.Self.m_SectorSize; x <= cntx; x++, px += EmpireMap.Self.m_SectorSize, i++) {
				v0.x = px - (EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize + EmpireMap.Self.m_CamPos.x);
				v0.y = py - (EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize + EmpireMap.Self.m_CamPos.y);
				v0.z = 0.0;
				EmpireMap.Self.WorldToScreen(v0);
				m_GridText.Draw(i, 1, Math.round(v0.x) - 3, Math.round(v0.y) - 3 + (m_GridText.m_LineCnt - 1 - i) * m_GridText.m_Font.lineHeight, -1, -1, clr);
			}
		}
	}
}

}
