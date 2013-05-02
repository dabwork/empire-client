package Engine
{

//import fl.motion.AdjustColor;
import flash.display.*;
import flash.events.*;
import flash.filters.ColorMatrixFilter;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.utils.*;
import flash.display3D.textures.Texture;

public class HyperspaceBG extends Sprite
{
//	public var m_OffsetX:int=0;
//	public var m_OffsetY:int=0;
	
//	public var m_BitmapList:Array=new Array();
	
//	public var m_GridLayer:Sprite=new Sprite();
	
//	public var m_BGImage:BitmapData=null;

//	public var m_IL:Array = new Array();

	public var HS:HyperspaceBase = null;
	
	public var m_QB:C3DQuadBatch = null;
	
	public var m_GridLine:Vector.<C3DParticle> = new Vector.<C3DParticle>();
	public var m_GridLineQB:C3DQuadBatch = new C3DQuadBatch();
	public var m_GridText:C3DTextLine = new C3DTextLine();

	public function HyperspaceBG(hs:HyperspaceBase)
	{
		HS = hs;
	
/*		var i:int;
		
		for(i=0;i<9;i++) {
			var bm:Bitmap=new Bitmap();
			m_BitmapList.push(bm);
			addChild(bm);
    		//bm.filters = filters;
		}
		addChild(m_GridLayer);
		
		m_GridText.SetFont("small_outline");
		m_GridText.SetFormat(1);
		
		LoadManager.Self.addEventListener("Complete", LoadComplate);*/
	}
	
	public function LoadComplate(e:Event):void
	{
/*		if (m_BGImage != null) return;
		var lbm:DisplayObject = LoadManager.Self.Get("bg98.jpg") as DisplayObject;
		if (lbm == null) return;
		Prepare();
		NeedUpdate();*/
	}
	
	public function Prepare():void
	{
/*		var i:int;
		var bm:Bitmap;
//return;
		//if(m_Map.m_BG.m_BGImage==null) return;
		var lbm:DisplayObject = LoadManager.Self.Get("bg98.jpg") as DisplayObject;
		if (lbm == null) {
			return;
		}
		
		var abm:BitmapData = (lbm as Bitmap).bitmapData;

		m_BGImage=new BitmapData(abm.width,abm.height,false,0xffffffff);

        var ac:AdjustColor=new AdjustColor();
        ac.brightness=0;
	    ac.contrast=0;
    	ac.hue=-100;//m_Map.m_TmpVal;
    	ac.saturation=0;

    	var filter:ColorMatrixFilter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
		var filters:Array = new Array();
		filters.push(filter);

		bm=new Bitmap();
		bm.bitmapData = abm;// m_Map.m_BG.m_BGImage;
		bm.filters = filters;
		m_BGImage.draw(bm);

		for(i=0;i<9;i++) {
			bm=m_BitmapList[i];
			bm.bitmapData=m_BGImage; //m_Map.m_BG.m_BGImage;
		}*/
	}

	public function DrawContent():void
	{
/*		var i:int,cnt:int,x:int,y:int,cx:int,cy:int,tx:int,ty:int;
		var bm:Bitmap;
		
		graphics.clear();
		m_GridLayer.graphics.clear();

		graphics.lineStyle(0.0,0x4b250b+0x4b250b,0.0,false);
		graphics.beginFill(0x4b250b+0x4b250b,1.0);
		graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
		graphics.endFill();
		
		var sf:Boolean=m_Map.m_Set_BG;
		
		if(sf && m_BGImage==null) Prepare(); 

		if(sf && m_BGImage!=null) {
			//graphics.clear();
		
			x=Math.ceil(m_OffsetX*0.5) % m_BGImage.width;
			if(x<0) x=m_BGImage.width+x;

			y=Math.ceil(m_OffsetY*0.5) % m_BGImage.height;
			if(y<0) y=m_BGImage.height+y;

			x=-x;
			y=-y;

			//x=Math.floor(x/m_BGImage.width)*m_BGImage.width;
			//y=Math.floor(y/m_BGImage.height)*m_BGImage.height;

			i=0;
			for(cy=0;cy<3;cy++) {			
				for(cx=0;cx<3;cx++,i++) {
					bm=m_BitmapList[i];
					bm.x=x+cx*m_BGImage.width;
					bm.y=y+cy*m_BGImage.height;
					bm.blendMode=BlendMode.SUBTRACT;
					//bm.alpha=0.5;
					bm.visible=true;
				}
			}
			
//			var m:Matrix=new Matrix();
//			m.identity();
//			m.translate(-m_OffsetX*0.2, -m_OffsetY*0.2);
		
//			graphics.lineStyle(1,0x000099,0);
//			graphics.beginBitmapFill(m_Map.m_BG.m_BGImage,m,true);
//			graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
//			graphics.endFill();
		} else {
			
			for(i=0;i<9;i++) {
				bm=m_BitmapList[i];
				bm.visible=false;
			}
		}
		
		// Grid
		var hs:Hyperspace=m_Map.m_Hyperspace;
		if(m_Map.m_Set_Grid) {
			if(hs.m_ZoneSize>0) {
				m_GridLayer.graphics.lineStyle(2,0x4b250b,0.15,false);//,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,3);

				cx=Math.max(hs.m_ZoneMinX,Math.floor(hs.MapToWorldX(0)/hs.m_ZoneSize));
				cnt=Math.min(hs.m_ZoneMinX+hs.m_ZoneCntX,Math.floor(hs.MapToWorldX(stage.stageWidth)/hs.m_ZoneSize))-cx+1;
				
				var b:Number=hs.MapToWorldY(0);
				if(b<hs.m_ZoneMinY*hs.m_ZoneSize) b=hs.m_ZoneMinY*hs.m_ZoneSize;
				else if(b>=(hs.m_ZoneMinY+hs.m_ZoneCntY)*hs.m_ZoneSize) b=(hs.m_ZoneMinY+hs.m_ZoneCntY)*hs.m_ZoneSize;
				
				var e:Number=hs.MapToWorldY(stage.stageHeight);
				if(e<hs.m_ZoneMinY*hs.m_ZoneSize) e=hs.m_ZoneMinY*hs.m_ZoneSize;
				else if(e>=(hs.m_ZoneMinY+hs.m_ZoneCntY)*hs.m_ZoneSize) e=(hs.m_ZoneMinY+hs.m_ZoneCntY)*hs.m_ZoneSize;
				
				b=hs.WorldToMapY(b);
				e=hs.WorldToMapY(e);

				for(i=0; i<cnt; i++) {
					x=hs.WorldToMapX((cx+i)*hs.m_ZoneSize);

					m_GridLayer.graphics.moveTo(x,b);//hs.WorldToMapY(hs.m_ZoneMinY*hs.m_ZoneSize));
					m_GridLayer.graphics.lineTo(x, e);//hs.WorldToMapY((hs.m_ZoneMinY+hs.m_ZoneCntY)*hs.m_ZoneSize));
				}

				cy=Math.max(hs.m_ZoneMinY,Math.floor(hs.MapToWorldY(0)/hs.m_ZoneSize));
				cnt=Math.min(hs.m_ZoneMinY+hs.m_ZoneCntY,Math.floor(hs.MapToWorldY(stage.stageHeight)/hs.m_ZoneSize))-cy+1;

				b=hs.MapToWorldX(0);
				if(b<hs.m_ZoneMinX*hs.m_ZoneSize) b=hs.m_ZoneMinX*hs.m_ZoneSize;
				else if(b>=(hs.m_ZoneMinX+hs.m_ZoneCntX)*hs.m_ZoneSize) b=(hs.m_ZoneMinX+hs.m_ZoneCntX)*hs.m_ZoneSize;
				
				e=hs.MapToWorldX(stage.stageWidth);
				if(e<hs.m_ZoneMinX*hs.m_ZoneSize) e=hs.m_ZoneMinX*hs.m_ZoneSize;
				else if(e>=(hs.m_ZoneMinX+hs.m_ZoneCntX)*hs.m_ZoneSize) e=(hs.m_ZoneMinX+hs.m_ZoneCntX)*hs.m_ZoneSize;
				
				b=hs.WorldToMapX(b);
				e=hs.WorldToMapX(e);

				for(i=0; i<cnt; i++) {
					y=hs.WorldToMapY((cy+i)*hs.m_ZoneSize);

					m_GridLayer.graphics.moveTo(b);//hs.WorldToMapX(hs.m_ZoneMinX*hs.m_ZoneSize),y);
					m_GridLayer.graphics.lineTo(e);//hs.WorldToMapX((hs.m_ZoneMinX+hs.m_ZoneCntX)*hs.m_ZoneSize), y);
				}
			}
		}
		ILUpdate();*/
	}

	public function NeedUpdate():void
	{
//		m_OffsetX=-1000000000;
//		m_OffsetY=-1000000000;
	}

	public function SetOffset(x:int,y:int):void
	{
/*		if(m_OffsetX==x && m_OffsetY==y) return;
		m_OffsetX=x;
		m_OffsetY=y;
//trace("BG SetOffset process");
		DrawContent();*/
	}

/*	public function ILUpdate():void
	{
		var str:String;
		var obj:Object;
		var zone:Zone;
		var x:int, y:int, i:int, offx:int, offy:int;
		var tf:TextField;
		var user:User;
		
		var hs:Hyperspace=m_Map.m_Hyperspace;

		var sx:int=Math.max(hs.m_ZoneMinX,Math.floor(hs.MapToWorldX(0)/hs.m_ZoneSize));
		var sy:int=Math.max(hs.m_ZoneMinY,Math.floor(hs.MapToWorldY(0)/hs.m_ZoneSize));
		var ex:int=Math.min(hs.m_ZoneMinX+hs.m_ZoneCntX,Math.floor(hs.MapToWorldX(hs.stage.stageWidth)/hs.m_ZoneSize)+1);
		var ey:int=Math.min(hs.m_ZoneMinY+hs.m_ZoneCntY,Math.floor(hs.MapToWorldY(hs.stage.stageHeight)/hs.m_ZoneSize)+1);

		for(i=0;i<m_IL.length;i++) {
			m_IL[i].m_Del=true;
		}
		if(m_Map.m_Set_Grid)
		for(y=sy;y<ey;y++) {
			for(x=sx;x<ex;x++) {
				zone=hs.GetZone(x,y);
				if(zone==null) continue;
				
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
					//tf.antiAliasType=AntiAliasType.ADVANCED;
					tf.gridFitType=GridFitType.NONE;
					tf.defaultTextFormat=new TextFormat("Calibri",10,0x909000);
					tf.alpha=0.8;
					tf.embedFonts=true;
					tf.visible=true;
					//tf.addEventListener(MouseEvent.CLICK,SectorToChat);
					m_GridLayer.addChild(tf);
					obj.m_Txt=tf;
				}
				obj.m_Del=false;
				tf=obj.m_Txt;
				
				tf.width=1;
				tf.height=1;
				str="";

				if(zone.m_Dev0!=0) {				
					user=UserList.Self.GetUser(zone.m_Dev0);
					if(user!=null) {
						if(str.length>0) str+=',';
						str+=user.m_Name;
					}
				}
				if(zone.m_Dev1!=0 && zone.m_Dev1!=zone.m_Dev0) {				
					user=UserList.Self.GetUser(zone.m_Dev1);
					if(user!=null) {
						if(str.length>0) str+=',';
						str+=user.m_Name;
					}
				}
				if(zone.m_Dev2!=0 && zone.m_Dev2!=zone.m_Dev0 && zone.m_Dev2!=zone.m_Dev1) {				
					user=UserList.Self.GetUser(zone.m_Dev2);
					if(user!=null) {
						if(str.length>0) str+=',';
						str+=user.m_Name;
					}
				}

				if(str.length>0) str+="\n";
				
				if(zone.m_Lvl!=0) str+="<font color='#00ff00'>";

				str+=(x-hs.m_ZoneMinX+1).toString();
				str+=",";

				str+=(y-hs.m_ZoneMinY+1).toString();
				
				if(zone.m_Lvl!=0) str+="</font>";

				tf.htmlText=str;
				
				offx=hs.WorldToMapX((x+1)*hs.m_ZoneSize);
				offy=hs.WorldToMapY((y+1)*hs.m_ZoneSize);

				tf.x=offx-tf.width-2;
				tf.y=offy-tf.height-2;
			}
		}

		for(i=m_IL.length-1;i>=0;i--) {
			obj=m_IL[i];
			if(!obj.m_Del) continue;

			m_GridLayer.removeChild(obj.m_Txt);
			obj.m_Txt=null;
			m_IL.splice(i,1);
		}
	}*/

	public function Draw(offx:Number, offy:Number, layer:int):void
	{
		var x:Number, y:Number;

		if(m_QB==null) {
			m_QB = new C3DQuadBatch();
			m_QB.Init(1, 4);
			m_QB.SetPos(0, 1.0, 0.0, 0.0, 0.0);
			m_QB.SetPos(1, 0.0, 1.0, 0.0, 0.0);
			m_QB.SetPos(2, 0.0, 0.0, 1.0, 0.0);
			m_QB.SetPos(3, 0.0, 0.0, 0.0, 1.0);
//			m_QB.SetPos(0, -1.0, -1.0, 0.0, 0.0);
//			m_QB.SetPos(1,  1.0, -1.0, 0.0, 0.0);
//			m_QB.SetPos(2,  1.0,  1.0, 0.0, 0.0);
//			m_QB.SetPos(3, -1.0,  1.0, 0.0, 0.0);
			m_QB.Apply();
		}

		var wps:Number = 2.0 / Number(C3D.m_SizeX);
		var hps:Number = 2.0 / Number(C3D.m_SizeY);

		var minz:Number = 16;// 4;
		var cellsize:Number = 1900 * minz;

		var cellx:int = Math.floor(offx / cellsize);
		var celly:int = Math.floor(offy / cellsize);
		//offx = (offx - cellx * cellsize) % cellsize;
		//offy = (offy - celly * cellsize) % cellsize;
		
//		if (cellx != 0 && celly != 0) return;

		var t_dif:C3DTexture = null;

		var z:Number = 0;

		if (layer == 0) {
			//t_dif = C3D.GetTexture("bg08.jpg", false); if (t_dif == null) return;
//			t_dif = C3D.GetTexture("nomipmap~empire/bg41.jpg"); if (t_dif.tex == null) return;
//			C3D.SetFConst(1, new Vector3D(1.0, 1.0, 1.0, 0.7));
			//C3D.SetFConst(1, new Vector3D(1.0, 0.0, 0.0, 0.5));
			z = minz + 2;// 8;
		}
		else if (layer == 1) {
//			t_dif = C3D.GetTexture("nomipmap~empire/bg07.jpg"); if (t_dif.tex == null) return;
//			C3D.SetFConst(1, new Vector3D(1.0, 1.0, 1.0, 0.8/*0.8*/));
			//C3D.SetFConst(1, new Vector3D(0.0, 1.0, 0.0, 0.5));
			z = minz + 4;
		}
		else if (layer == 2) {
			//t_dif = C3D.GetTexture("bg12.jpg", false); if (t_dif == null) return;
//			t_dif = C3D.GetTexture("nomipmap~empire/bg07.jpg"); if (t_dif.tex == null) return;
//			C3D.SetFConst(1, new Vector3D(1.0, 1.0, 1.0, 1.0/*0.9*/));
			//C3D.SetFConst(1, new Vector3D(0.0, 0.0, 1.0, 0.5));
			z = minz;
		} else return;
		
//		offx /= z;
//		offy /= z;

		C3D.VBQuadBatch(m_QB);
		C3D.ShaderImg();

		C3D.SetVConst(0, new Vector3D(0.0, 0.5, 1.0, 2.0));
		C3D.SetFConst(0, new Vector3D(0.0, 0.5, 1.0, 2.0));
		
		var u:int;
		
		var rnd:PRnd = new PRnd();
		
		// 01 02
		// 04 05
		// 06
		// 07
		// 10 12
		// 14 15 16
		
		var kx:int, ky:int;

		for (y = -1; y <= 1; y++) {
			for (x = -1; x <= 1; x++) {

				//u = (10000 + cellx + x + 10000 + celly + y) % 4;
				//rnd.Set(10000 + cellx + x + 10000 + celly + y);
				//rnd.RndEx();
				//u = rnd.Rnd(0, 3);

				if (layer == 0) { t_dif = C3D.GetTexture("nomipmap~bg41.jpg"); C3D.SetFConst_n(1, 1.0, 1.0, 1.0, 0.7); }
				else {
					ky = (((10000 + cellx + x) >> 2) & 1) * 2;
					rnd.Set(((10000 + cellx + x) >> 2) + ((10000 + celly + y + ky) >> 2)); rnd.RndEx();
					u = rnd.Rnd(0, 5);
					
					if (u == 0) u = rnd.Rnd(10, 11);
					else if (u == 1) u = rnd.Rnd(20, 21);
					else if (u == 2) u = 30;
					else if (u == 3) u = 40;
					else if (u == 4) u = rnd.Rnd(50, 51);
					else if (u == 5) u = rnd.Rnd(60, 62);
					
					if (u == 10) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg01.jpg");
					else if (u == 11) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg02.jpg");
					else if (u == 20) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg04.jpg");
					else if (u == 21) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg05.jpg");
					else if (u == 30) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg06.jpg");
					else if (u == 40) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg07.jpg");
					else if (u == 50) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg10.jpg");
					else if (u == 51) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg12.jpg");
					else if (u == 60) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg14.jpg");
					else if (u == 61) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg15.jpg");
					else if (u == 62) t_dif = C3D.GetTexture("hbcs=0 0 10 10~nomipmap~bg16.jpg");
					else continue;
					
					C3D.SetFConst_n(1, 1.0, 1.0, 1.0, 1.0);
				}

				if (t_dif.tex == null) continue;

				C3D.SetTexture(0, t_dif.tex);
				
//				if ((cellx + x) == 0 && (celly + y) == 0) {}
//				else continue;
				
				var cx:Number = ((cellx + x) * cellsize - offx) + cellsize * 0.5;
				var cy:Number = ((celly + y) * cellsize - offy) + cellsize * 0.5;
				var cz:Number = z;
				
				//var x0:Number = -((x) * cellsize + offx) * wps;
				//var y0:Number = -((y) * cellsize + offy) * hps;
				var x0:Number = (cx / cz) * wps - 1024 * wps;
				var y0:Number = (cy / cz) * hps - 1024 * hps;
				var x1:Number = x0 + wps * 2048;
				var y1:Number = y0 + hps * 2048;

				if(layer==0) {
					C3D.SetVConst(1, new Vector3D( x0, y0, 0.0, 0.0));
					C3D.SetVConst(2, new Vector3D( x1, y0, 1.0, 0.0));
					C3D.SetVConst(3, new Vector3D( x1, y1, 1.0, 1.0));
					C3D.SetVConst(4, new Vector3D( x0, y1, 0.0, 1.0));
				} else if(layer==1) {
					C3D.SetVConst(1, new Vector3D( x0, y0, 1.0, 0.0));
					C3D.SetVConst(2, new Vector3D( x1, y0, 1.0, 1.0));
					C3D.SetVConst(3, new Vector3D( x1, y1, 0.0, 1.0));
					C3D.SetVConst(4, new Vector3D( x0, y1, 0.0, 0.0));
				} else if(layer==2) {
					C3D.SetVConst(1, new Vector3D( x0, y0, 1.0, 1.0));
					C3D.SetVConst(2, new Vector3D( x1, y0, 0.0, 1.0));
					C3D.SetVConst(3, new Vector3D( x1, y1, 0.0, 0.0));
					C3D.SetVConst(4, new Vector3D( x0, y1, 1.0, 0.0));
				}

				C3D.DrawQuadBatch();
			}
		}


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

		if (!HS.PickWorldCoord(0, 0, v0)) return;
		if (!HS.PickWorldCoord(C3D.m_SizeX, 0, v1)) return;
		if (!HS.PickWorldCoord(C3D.m_SizeX, C3D.m_SizeY, v2)) return;
		if (!HS.PickWorldCoord(0, C3D.m_SizeY, v3)) return;

		var minx:Number = Math.min(v0.x, v1.x, v2.x, v3.x);
		var maxx:Number = Math.max(v0.x, v1.x, v2.x, v3.x);
		var miny:Number = Math.min(v0.y, v1.y, v2.y, v3.y);
		var maxy:Number = Math.max(v0.y, v1.y, v2.y, v3.y);
		
		var zminx:int = Math.floor(minx / HS.SP.m_ZoneSize);
		var zminy:int = Math.floor(miny / HS.SP.m_ZoneSize);
		minx = zminx;
		miny = zminy;
		var cntx:int = (Math.floor(maxx / HS.SP.m_ZoneSize) - minx) + 2;
		var cnty:int = (Math.floor(maxy / HS.SP.m_ZoneSize) - miny) + 2;
		if (cntx * cnty > 100) return;
		minx *= HS.SP.m_ZoneSize;
		miny *= HS.SP.m_ZoneSize;

		var mv:Matrix3D = HS.m_MatViewInv;
		var nx:Number = mv.rawData[2 * 4 + 0];
		var ny:Number = mv.rawData[2 * 4 + 1];
		var nz:Number = mv.rawData[2 * 4 + 2];

		var cnt:int = 0;

		var s2w:Number = HS.FactorScr2WorldDist(0.0, 0.0, 0.0) * 2.0;

		for (i = 0, px = minx; i < cntx/*px <= maxx*/; i++, px += HS.SP.m_ZoneSize) {
			if (cnt >= m_GridLine.length) m_GridLine.push(new C3DParticle());
			p = m_GridLine[cnt++];
			p.m_PosX = px - (HS.m_CamZoneX * HS.SP.m_ZoneSize + HS.m_CamPos.x);
			p.m_PosY = miny - (HS.m_CamZoneY * HS.SP.m_ZoneSize + HS.m_CamPos.y);
			p.m_PosZ = 0.0 - HS.m_CamPos.z;
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
			p.m_Color = 0x1f00ffff;
			p.m_ColorTo = p.m_Color;
			p.m_Flag |= C3DParticle.FlagShow;
		}

		for (i=0, py = miny; i < cnty/*py <= maxy*/; i++, py += HS.SP.m_ZoneSize) {
			if (cnt >= m_GridLine.length) m_GridLine.push(new C3DParticle());
			p = m_GridLine[cnt++];
			p.m_PosX = minx - (HS.m_CamZoneX * HS.SP.m_ZoneSize + HS.m_CamPos.x);
			p.m_PosY = py - (HS.m_CamZoneY * HS.SP.m_ZoneSize + HS.m_CamPos.y);
			p.m_PosZ = 0.0 - HS.m_CamPos.z;
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
			p.m_Color = 0x1f00ffff;
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

		C3D.SetVConstMatrix(0, HS.m_MatViewPer);
		C3D.SetVConst(8, new Vector3D(0, 0, 0, 1.0));
		C3D.ShaderParticle();
		C3D.SetTexture(0, t_dif.tex);
		C3D.VBQuadBatch(m_GridLineQB);
		C3D.DrawQuadBatch();
		C3D.SetTexture(0, null);
		
//		var font:C3DFont = C3D.GetFont(m_GridText.m_FontName);
//		if (font == null) return;

		var str:String="";
		for (y = 0; y < (cnty - 1); y++) {
			for (x = 1; x < cntx; x++) {
				str += (zminx + x - 1).toString() + "," + (zminy + y).toString() + "\n";
			}
		}
		m_GridText.SetText(str);
		m_GridText.Prepare();
		if (m_GridText.m_Font == null || m_GridText.m_LineCnt <= 0) return;
		
		i = 0;
		for (y = 0, py = miny; y < (cnty - 1); y++, py += HS.SP.m_ZoneSize) {
			for (x = 1, px = minx + HS.SP.m_ZoneSize; x < cntx; x++, px += HS.SP.m_ZoneSize, i++) {
				v0.x = px - (HS.m_CamZoneX * HS.SP.m_ZoneSize + HS.m_CamPos.x);
				v0.y = py - (HS.m_CamZoneY * HS.SP.m_ZoneSize + HS.m_CamPos.y);
				v0.z = 0.0;
				HS.WorldToScreen(v0);
				m_GridText.Draw(i, 1, v0.x - 3, v0.y - 3 + (m_GridText.m_LineCnt - 1 - i) * m_GridText.m_Font.lineHeight, -1, -1, 0x4f00ffff);
			}
		}
	}
}

}
