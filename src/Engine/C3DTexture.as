package Engine
{
import Base.*;
import fl.motion.AdjustColor;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display3D.textures.Texture;
import flash.filters.*;

public class C3DTexture
{
	public var m_Path:String = null;
	public var m_Mod:String = null;
	public var m_Texture:Texture = null;
	public var m_Width:int = 0;
	public var m_Height:int = 0;
	public var m_PremulAlpha:Boolean = false;
	
	public function C3DTexture():void
	{
	}
	
	public function Get():Texture
	{
		if (m_Texture != null) return m_Texture;

		var nomipmap:Boolean = false;
		var ac:AdjustColor=null;

		var add:int, iv:int;
		var filter:ColorMatrixFilter;
		var filters:Array;

		var path:String = m_Path;
		if (m_Mod != null) path += "~" + m_Mod;
		var off:int = 0;
		var len:int = path.length;
		var beginpath:int = 0;

		while (len>0) {
			if (path.charCodeAt(off) == 126) { // ~
				off++; len--; beginpath = off;

			} else if (BaseStr.IsTagEqNCEng(path, off, len, "nomipmap")) {
				nomipmap = true;
				off += 8; len -= 8; beginpath = off;
				
			} else if (BaseStr.IsTagEqNCEng(path, off, len, "id=")) {
				off += 3; len -= 3; beginpath = off;
				
				while (len > 0) {
					if (path.charCodeAt(off) == 126) { // ~
						break;
					}
					off++; len--; beginpath = off;
				}
				
			} else if (BaseStr.IsTagEqNCEng(path, off, len, "hue=")) {
				off += 4; len -= 4; beginpath = off;
				while (len > 0 && path.charCodeAt(off) == 32) { off ++; len --; beginpath = off; }
				
				add = BaseStr.ParseIntLen(path, off, len);
				if (add >= 0) {
					iv = int(path.substr(off, add));
					if (iv != 0) {
						if (ac == null) ac = new AdjustColor();
						ac.brightness = iv;
					}
					off += add; len -= add; beginpath = off;
				}

			} else if (BaseStr.IsTagEqNCEng(path, off, len, "hbcs=")) {
				off += 5; len -= 5; beginpath = off;
				
				while (len > 0 && path.charCodeAt(off) == 32) { off ++; len --; beginpath = off; }
				add = BaseStr.ParseIntLen(path, off, len);
				if (add >= 0) {
					iv = int(path.substr(off, add));
					if (iv != 0) {
						if (ac == null) { ac = new AdjustColor(); ac.brightness = 0; ac.contrast = 0; ac.hue = 0; ac.saturation = 0; }
						ac.hue = iv;
					}
					off += add; len -= add; beginpath = off;
				}

				while (len > 0 && path.charCodeAt(off) == 32) { off ++; len --; beginpath = off; }
				add = BaseStr.ParseIntLen(path, off, len);
				if (add >= 0) {
					iv = int(path.substr(off, add));
					if (iv != 0) {
						if (ac == null) { ac = new AdjustColor(); ac.brightness = 0; ac.contrast = 0; ac.hue = 0; ac.saturation = 0; }
						ac.brightness = iv;
					}
					off += add; len -= add; beginpath = off;
				}

				while (len > 0 && path.charCodeAt(off) == 32) { off ++; len --; beginpath = off; }
				add = BaseStr.ParseIntLen(path, off, len);
				if (add >= 0) {
					iv = int(path.substr(off, add));
					if (iv != 0) {
						if (ac == null) { ac = new AdjustColor(); ac.brightness = 0; ac.contrast = 0; ac.hue = 0; ac.saturation = 0; }
						ac.contrast = iv;
					}
					off += add; len -= add; beginpath = off;
				}

				while (len > 0 && path.charCodeAt(off) == 32) { off ++; len --; beginpath = off; }
				add = BaseStr.ParseIntLen(path, off, len);
				if (add >= 0) {
					iv = int(path.substr(off, add));
					if (iv != 0) {
						if (ac == null) { ac = new AdjustColor(); ac.brightness = 0; ac.contrast = 0; ac.hue = 0; ac.saturation = 0; }
						ac.saturation = iv;
					}
					off += add; len -= add; beginpath = off;
				}
			} else {
				break;
			}
		}
		
		path = path.substring(beginpath);

		if (path == 'empty') {
			m_Texture = C3D.CreateTextureFromBM(new BitmapData(1, 1, true, 0), false);
			m_Width = 1;
			m_Height = 1;

		} else if (path == 'black') {
			m_Texture = C3D.CreateTextureFromBM(new BitmapData(1, 1, true, 0xff000000), false);
			m_Width = 1;
			m_Height = 1;

		} else if (path == 'white') {
			m_Texture = C3D.CreateTextureFromBM(new BitmapData(1, 1, true, 0xffffffff), false);
			m_Width = 1;
			m_Height = 1;
			
		} else {
			var o:Object = LoadManager.Self.Get(path);
			if (o == null) return null;
			
			var bm:BitmapData = null;
			if (o is BitmapData) bm = o as BitmapData;
			else if (o is Bitmap) bm = (o as Bitmap).bitmapData;
			else throw Error("Texture.Get Unknown");

			m_Width = bm.width;
			m_Height = bm.height;

			if (ac != null) {
				var bmc:Bitmap = new Bitmap();
				bmc.bitmapData = bm;
				
				filter = new ColorMatrixFilter(ac.CalculateFinalFlatArray());
				filters = new Array();
				filters.push(filter);
				bmc.filters = filters;
				
				var tbm:BitmapData = new BitmapData(bm.width, bm.height, bm.transparent, 0x000000);
				tbm.draw(bmc, null);
				bm = tbm;
			}
			
			m_PremulAlpha = bm.transparent;// Особенность флэша. Когда есть альфа канал то он всегда в BitmapData хранит с цвет умноженный на альфу.

			m_Texture = C3D.CreateTextureFromBM(bm, !nomipmap);

			LoadManager.Self.Free(path);
		}
		return m_Texture;
	}

	public function get tex():Texture { if (m_Texture != null) return m_Texture; return Get(); }
}
	
}