package Engine
{
import Base.*;
import fl.controls.ComboBox;
import fl.controls.TextArea;
import flash.events.*;
import flash.geom.Vector3D;
import flash.utils.Dictionary;

public class HyperspacePlanetStyle
{
	static public var m_Map:Dictionary = null;

	static public const ShaderOff:int = 0;
	static public const ShaderSphere:int = 1;
	static public const ShaderHalo:int = 2;
	static public const ShaderSimple:int = 3;
	
	static public const BlendOff:int = 0;
	static public const BlendAlpha:int = 1;
	static public const BlendAdd:int = 2;
	static public const BlendScreen:int = 3;
	
	static public const LightFix:int = 0;
	static public const LightSun:int = 1;
	static public const LightView:int = 2;

	static public const ClassSun:int = 1;
	static public const ClassPlanet:int = 2;
	static public const ClassSputnik:int = 4;
	static public const ClassSmall:int = 8;
	static public const ClassNormal:int = 16;
	static public const ClassLarge:int = 32;
	static public const ClassAtmNo:int = 64;
	static public const ClassAtmExist:int = 128;
	static public const ClassAtmLive:int = 256;

	public static var TextureList:Array = [""]; //, "empire/halo_full.png", "empire/halo_smooth.png", "empire/planet00.jpg", "empire/planet01.jpg", "empire/planet02.jpg"
	
	static public function add(id:uint, layercnt:int = 5):Object
	{
		var i:int;
		var layer:Object;
		var style:Object = new Object();
		m_Map[id] = style;
		style.Id = id;
		style.Name = "";
		style.Class = 0;
		style.Layer = new Array();
		for (i = 0; i < layercnt; i++) { // Empty
			layer = new Object();
			style.Layer.push(layer);
			layer.Shader = ShaderOff;
			layer.Blend = BlendOff;
			layer.Texture = "";
			layer.InnerSize = 1.0;
			layer.OuterSize = 25.0;
			layer.RadiusMul = 1;
			layer.Light = LightFix;
			layer.Alpha = 0x78787878; // a=src_a+des_a+(src_r*des_r)+(src_g*des_g)+(src_b*des_b)
			layer.Color = 0xffffffff;
			layer.Ambient = 0xff00ff00;
			layer.Diffuse = 0xff0000ff;
			layer.Reflection = 0xB5ff0000;
			layer.Shadow = 0xB8000021;
			layer.Gamma = 0x7896c696;
			layer.Period = 100;
			layer.AngleA = 15.0;
			layer.AngleB = 45.0;
			layer.Rotate = 0;
		}
		return style;
	}
	
	static public function copy(style:Object, l:int):Object
	{
		if (l<0 || l>=style.Layer.length) return null;
		var src:Object = style.Layer[l];
		var des:Object = new Object();
		style.Layer.splice(l + 1, 0, des);

		des.Shader = src.Shader;
		des.Blend = src.Blend;
		des.Texture = src.Texture;
		des.InnerSize = src.InnerSize;
		des.OuterSize = src.OuterSize;
		des.RadiusMul = src.RadiusMul;
		des.Light = src.Light;
		des.Alpha = src.Alpha;
		des.Color = src.Color;
		des.Ambient = src.Ambient;
		des.Diffuse = src.Diffuse;
		des.Reflection = src.Reflection;
		des.Shadow = src.Shadow;
		des.Gamma = src.Gamma;
		des.Period = src.Period;
		des.AngleA = src.AngleA;
		des.AngleB = src.AngleB;
		des.Rotate = src.Rotate;

		return des;
	}
	
	static public function save(style:Object):String
	{
		var l:int;
		var str:String = "";
		if(BaseStr.Trim(style.Name).length<=0) str += "[style]\n";
		else str += "[style," + BaseStr.Trim(style.Name) + "]\n";
		str += "Class=" + style.Class.toString(16) + "\n";
		for (l = 0; l < style.Layer.length; l++) {
			var layer:Object = style.Layer[l];
			str += "[layer]\n";
			str += "Shader=" + layer.Shader + "\n";
			str += "Blend=" + layer.Blend + "\n";
			str += "Texture=" + layer.Texture + "\n";
			str += "InnerSize=" + layer.InnerSize.toString() + "\n";
			str += "OuterSize=" + layer.OuterSize.toString() + "\n";
			str += "RadiusMul=" + BaseStr.FormatFloat(layer.RadiusMul, 5) + "\n";
			str += "Light=" + layer.Light + "\n";
			str += "Alpha=" + C3D.TransformAlphaToStr(layer.Alpha) + "\n";
			str += "Color=" + BaseStr.FormatColor(layer.Color) + "\n";
			str += "Ambient=" + BaseStr.FormatColor(layer.Ambient) + "\n";
			str += "Diffuse=" + BaseStr.FormatColor(layer.Diffuse) + "\n";
			str += "Reflection=" + BaseStr.FormatColor(layer.Reflection) + "\n";
			str += "Shadow=" + BaseStr.FormatColor(layer.Shadow) + "\n";
			str += "Gamma=" + C3D.GammaToStr(layer.Gamma) + "\n";
			str += "Period=" + layer.Period.toString() + "\n";
			str += "AngleA=" + BaseStr.FormatFloat(layer.AngleA, 3) + "\n";
			str += "AngleB=" + BaseStr.FormatFloat(layer.AngleB, 3) + "\n";
			str += "Rotate=" + BaseStr.FormatFloat(layer.Rotate, 3) + "\n";
		}
		return str;
	}
	
	static public function prepare():Boolean
	{
		if (m_Map != null) return true;

		var src:String = LoadManager.Self.Get("planet/cfg.txt") as String;
		if (src == null) return false;

		m_Map = new Dictionary();
		load(src);

		return true;
	}

	static public function load(src:String, forstyle:int = -1):void
	{
		var i:int, u:int, k:int, type:int;
		var ibegin:int, iend:int;
		var ch:int;
		var len:int=src.length;
		var off:int = 0;
		var name:String, str:String;
		var style:Object = null;
		var layer:Object = null;
		var header:Boolean = false;
		var texture:Boolean = false;
		var line:int = 1;

		TextureList.length = 1;
		
		if (forstyle >= 0) {
			texture = false;
			header = true;

			if(m_Map[forstyle]==undefined) {
				style = new Object();
				style.Id = line;
				style.Layer = new Array();
				style.Name = "";
				m_Map[forstyle] = style;
			} else {
				style = m_Map[forstyle];
			}
			style.Layer.length = 0;
			layer = null;
		}

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
						if (BaseStr.IsTagEq(src, ibegin, iend - ibegin, "texture", "TEXTURE")) {
							texture = true;
							header = false;
							
						} else if (BaseStr.IsTagEq(src, ibegin, iend - ibegin, "style", "STYLE") && forstyle<0) {
							texture = false;
							header = true;

							style = new Object();
							style.Id = line;
							style.Layer = new Array();
							if (name == null) style.Name = "";
							else style.Name = name;
							m_Map[line] = style;
							layer = null;

						} else if (BaseStr.IsTagEq(src, ibegin, iend - ibegin, "layer", "LAYER") && style!=null) {
							texture = false;
							header = true;

							layer = new Object();
							style.Layer.push(layer);
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

					if(iend>ibegin && style!=null && layer==null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Class")) style.Class = uint("0x" + str);

					} else if(iend>ibegin && style!=null && layer!=null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Shader")) layer.Shader = int(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Blend")) layer.Blend = int(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Texture")) layer.Texture = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "InnerSize")) layer.InnerSize = Number(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "OuterSize")) layer.OuterSize = int(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "RadiusMul")) layer.RadiusMul = Number(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Light")) layer.Light = int(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Alpha")) layer.Alpha = C3D.TransformAlphaFromStr(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Color")) layer.Color = uint("0x" + str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Ambient")) layer.Ambient = uint("0x" + str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Diffuse")) layer.Diffuse = uint("0x" + str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Reflection")) layer.Reflection = uint("0x" + str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Shadow")) layer.Shadow = uint("0x" + str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Gamma")) layer.Gamma = C3D.GammaFromStr(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Period")) layer.Period = int(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "AngleA")) layer.AngleA = Number(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "AngleB")) layer.AngleB = Number(str);
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Rotate")) layer.Rotate = Number(str);
					}
				} else {
					header = false;

					ibegin=off;
					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend = off;

					while(iend>ibegin) { ch=src.charCodeAt(iend-1); if(ch==32 || ch==9 || ch==10 || ch==13) iend--; else break; }

					if (iend > ibegin && texture) {
						TextureList.push(src.substring(ibegin, iend));
					}
				}
			}
		}
	}
	
	public static function find(cl:int, vrnd:uint):int
	{
		if (!prepare()) return 0;

		var rnd:PRnd = new PRnd();
		rnd.Set(vrnd); rnd.RndEx();
		
		var ccc:int;
		var ret:uint = 0;
		var kv:int;

		for each (var style:Object in m_Map) {
			if ((style.Class & cl) != cl) continue;
			
			if (ret == 0) {
				ccc = 1;
				ret = style.Id;
			} else {
                ccc++;
                kv=10000000/ccc;
                if (rnd.Rnd(0, 10000000) <= kv) { ret = style.Id; }
			}
		}
		return ret;
	}
	
	public static function findByName(name:String):int
	{
		if (!prepare()) return 0;

		for each (var style:Object in m_Map) {
			if (style.Name == name) return style.Id;
		}
		return 0;
	}

/*	static public function init():void
	{
		var style:Object;
		var layer:Object;

		style = add(1);
		layer = style.Layer[0];
			layer.Shader = ShaderSphere;
			layer.Blend = BlendAlpha;
			layer.Texture = "empire/planet00.jpg";
			layer.InnerSize = 1.0;
			layer.OuterSize = 25.0;
			layer.RadiusMul = 1;
			layer.Light = LightFix;
			layer.Color = 0xFFFFFFFF;
			layer.Ambient = 0xFF322222;
			layer.Diffuse = 0xFF351C1C;
			layer.Reflection = 0xF21A0B0B;
			layer.Shadow = 0xB80E0E1D;
			layer.Gamma = 0x7896c696;
		layer = style.Layer[1];
			layer.Shader = ShaderHalo;
			layer.Blend = BlendScreen;
			layer.Texture = "empire/halo_full.png";
			layer.InnerSize = 1.0;
			layer.OuterSize = 25.0;
			layer.RadiusMul = 1;
			layer.Light = LightFix;
			layer.Color = 0xBEE8831E;
			layer.Ambient = 0xFF3F3F3F;
			layer.Diffuse = 0xFF1D1F2B;
			layer.Reflection = 0xB5112027;
			layer.Shadow = 0xB8000021;
			layer.Gamma = 0x7896c696;

		style = new Object(); style.Layer = new Array(); m_Map[2] = style;
		style.HaloBlend = 1;
		style.HaloTexture = "empire/halo_full.png";
		style.HaloInnerSize = 1.0;
		style.HaloOuterSize = 30.0;
		style.HaloRadiusMul = 1.001;
		style.HaloColor = 0x605D4700;
		style.HaloAmbient = 0xFF272727;
		style.HaloDiffuse = 0xFF1F1717;
		style.HaloReflection = 0xFF0D0B0B;
		style.HaloShadow = 0xB8000021;
		style.HaloGamma = 0;
		layer = new Object(); style.Layer.push(layer);
		layer.Tex = "empire/planet00.jpg";
		layer.Mesh = "empire/planet.mesh";
		layer.Ambient = 0xFF3F3030;
		layer.Diffuse = 0xFF271414;
		layer.Reflection = 0xFF190606;
	}*/
	
	static public var m_EditId:uint = 0;
	
	static public var m_SaveArea:CtrlInput = null;
	
	static public function Edit(id:uint):void
	{
		if (!prepare()) return;
		if (m_Map[id] == undefined) return;
		m_EditId = id;
		var style:Object = m_Map[id];

		var l:int, i:int;
		var str:String;
		var cb:CtrlComboBox;

		var fi:FormInputEx = StdMap.Main.FI;

		fi.Init(480, Math.max(400, C3D.m_SizeY - 100));
		fi.pageWidthMin = 100;
		fi.caption = "Planet style " + id.toString();

		var tab:int = fi.TabAdd("layer");
		fi.tab = 0;
		for (l = 0; l < style.Layer.length; l++) {
			var layer:Object = style.Layer[l];

			fi.PageAdd("Layer " + (l + 1).toString(), tab);
			if (l == 0) fi.page = 0;

			fi.AddLabel("Shader:");
			fi.Col();
			fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
			fi.AddItem("off", ShaderOff, ShaderOff == layer.Shader);
			fi.AddItem("sphere", ShaderSphere, ShaderSphere == layer.Shader);
			fi.AddItem("simple", ShaderSimple, ShaderSimple == layer.Shader);
			fi.AddItem("halo", ShaderHalo, ShaderHalo == layer.Shader);

			fi.AddLabel("Blend mode:");
			fi.Col();
			fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
			fi.AddItem("off", BlendOff, BlendOff == layer.Blend);
			fi.AddItem("alpha", BlendAlpha, BlendAlpha == layer.Blend);
			fi.AddItem("add", BlendAdd, BlendAdd == layer.Blend);
			fi.AddItem("screen", BlendScreen, BlendScreen == layer.Blend);

			fi.AddLabel("Texture:");
			fi.Col();
			cb = fi.AddComboBox();
			//cb.editable = true;
			cb.addEventListener(Event.CHANGE, EditChange);
			for (i = 0; i < TextureList.length; i++) {
				fi.AddItem(TextureList[i], TextureList[i], TextureList[i] == layer.Texture);
			}

			fi.AddLabel("Inner size:");
			fi.Col();
			fi.AddInput(Math.round(layer.InnerSize * 100).toString(), 10, true, 0, false).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Outer size:");
			fi.Col();
			fi.AddInput(Math.round(layer.OuterSize).toString(), 10, true, 0, false).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Radius mul:");
			fi.Col();
			fi.AddInput(layer.RadiusMul.toString(), 10, true, 0, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Light:");
			fi.Col();
			fi.AddComboBox().addEventListener(Event.CHANGE, EditChange);
			fi.AddItem("fix", LightFix, LightFix == layer.Light);
			fi.AddItem("sun", LightSun, LightSun == layer.Light);
			fi.AddItem("view", LightView, LightView == layer.Light);
			
			fi.AddLabel("Alpha:");
			fi.Col();
			fi.AddInput(C3D.TransformAlphaToStr(layer.Alpha), 20, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Color:");
			fi.Col();
			fi.AddColorPicker(layer.Color).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Ambient:");
			fi.Col();
			fi.AddColorPicker(layer.Ambient).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Diffuse:");
			fi.Col();
			fi.AddColorPicker(layer.Diffuse).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Reflection:");
			fi.Col();
			fi.AddColorPicker(layer.Reflection).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Shadow:");
			fi.Col();
			fi.AddColorPicker(layer.Shadow).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Gamma:");
			fi.Col();
			fi.AddInput(C3D.GammaToStr(layer.Gamma), 20, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Angle A:");
			fi.Col();
			fi.AddInput(BaseStr.FormatFloat(layer.AngleA, 3), 20, true, 0, true).addEventListener(Event.CHANGE, EditChange);
		
			fi.AddLabel("Angle B:");
			fi.Col();
			fi.AddInput(BaseStr.FormatFloat(layer.AngleB, 3), 20, true, 0, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Rotate:");
			fi.Col();
			fi.AddInput(BaseStr.FormatFloat(layer.Rotate, 3), 20, true, 0, true).addEventListener(Event.CHANGE, EditChange);

			fi.AddLabel("Period:");
			fi.Col();
			fi.AddInput(layer.Period.toString(), 20, true, 0, true).addEventListener(Event.CHANGE, EditChange);

		}

		fi.TabAdd("cfg");
		fi.AddLabel("Name:");
		fi.Col();
		fi.AddInput(style.Name.toString(), 20, true, Server.LANG_ENG, true).addEventListener(Event.CHANGE, EditChange);

		fi.AddCheckBox((style.Class & ClassSun) != 0, "Sun").addEventListener(Event.CHANGE, EditChange);
		fi.Col();
		fi.AddCheckBox((style.Class & ClassPlanet) != 0, "Planet").addEventListener(Event.CHANGE, EditChange);
		fi.Col();
		fi.AddCheckBox((style.Class & ClassSputnik)!=0, "Sputnik").addEventListener(Event.CHANGE, EditChange);
		fi.AddCheckBox((style.Class & ClassSmall) != 0, "Small").addEventListener(Event.CHANGE, EditChange);
		fi.Col();
		fi.AddCheckBox((style.Class & ClassNormal)!=0, "Normal").addEventListener(Event.CHANGE, EditChange);
		fi.Col();
		fi.AddCheckBox((style.Class & ClassLarge)!=0, "Large").addEventListener(Event.CHANGE, EditChange);
		fi.AddCheckBox((style.Class & ClassAtmNo) != 0, "AtmNo").addEventListener(Event.CHANGE, EditChange);
		fi.Col();
		fi.AddCheckBox((style.Class & ClassAtmExist)!=0, "AtmExist").addEventListener(Event.CHANGE, EditChange);
		fi.Col();
		fi.AddCheckBox((style.Class & ClassAtmLive) != 0, "AtmLive").addEventListener(Event.CHANGE, EditChange);

		fi.TabAdd("save");
		m_SaveArea = fi.AddCode(save(style), 1024 * 16, true, Server.LANG_ENG, true);
		m_SaveArea.heightMin = fi.contentHeight - 50;
		m_SaveArea.addEventListener(Event.CHANGE, SaveAreaChange);
		
		var but:CtrlBut;
		var tx:int = fi.innerLeft;
		var ty:int = fi.height - fi.innerBottom;
		
		but = new CtrlBut();
		but.caption = "Down";
		but.addEventListener(MouseEvent.CLICK, LayerDown);
		fi.CtrlAddPage(but,tab);
		but.x = tx;
		ty -= but.height;
		but.y = ty;
		but.width = 80;

		but = new CtrlBut();
		but.caption = "Up";
		but.addEventListener(MouseEvent.CLICK, LayerUp);
		fi.CtrlAddPage(but,tab);
		but.x = tx;
		ty -= but.height;
		but.y = ty;
		but.width = 80;
		
		tx = tx + but.width;
		ty = fi.height - fi.innerBottom;
		
		but = new CtrlBut();
		but.caption = "Copy";
		but.addEventListener(MouseEvent.CLICK, LayerCopy);
		fi.CtrlAddPage(but,tab);
		but.x = tx;
		but.y = ty - but.height;
		but.width = 80;
		tx += but.width;

		but = new CtrlBut();
		but.caption = "Del";
		but.addEventListener(MouseEvent.CLICK, LayerDel);
		fi.CtrlAddPage(but,tab);
		but.x = tx;
		but.y = ty - but.height;
		but.width = 80;
		tx += but.width;

		fi.Run(null, null, StdMap.Txt.ButClose);
	}
	
	static public function EditChange(e:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Object = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		var l:int, i:int;
		var off:int = 0;

		for (l = 0; l < style.Layer.length; l++) {
			var layer:Object = style.Layer[l];

			layer.Shader = fi.GetInt(off++);

			layer.Blend = fi.GetInt(off++);

			layer.Texture = fi.GetStr(off++);

			layer.InnerSize = Number(fi.GetInt(off++)) / 100;
			if (layer.InnerSize < 0.0) layer.InnerSize = 0.0;
			else if (layer.InnerSize > 1.0) layer.InnerSize = 1.0;

			layer.OuterSize = fi.GetInt(off++);
			if (layer.OuterSize < 0.0) layer.OuterSize = 0.0;
			else if (layer.OuterSize > 10000.0) layer.OuterSize = 10000.0;

			layer.RadiusMul = Number(fi.GetStr(off++));
			if (layer.RadiusMul < 0.0001) layer.RadiusMul = 0.0001;

			layer.Light = fi.GetInt(off++);

			layer.Alpha = C3D.TransformAlphaFromStr(fi.GetStr(off++));

			layer.Color = uint("0x" + fi.GetStr(off++));
			layer.Ambient = uint("0x" + fi.GetStr(off++));
			layer.Diffuse = uint("0x" + fi.GetStr(off++));
			layer.Reflection = uint("0x" + fi.GetStr(off++));
			layer.Shadow = uint("0x" + fi.GetStr(off++));

			layer.Gamma = C3D.GammaFromStr(fi.GetStr(off++));
			
			layer.AngleA = Number(fi.GetStr(off++));
			layer.AngleB = Number(fi.GetStr(off++));
			layer.Rotate = Number(fi.GetStr(off++));

			layer.Period = fi.GetInt(off++);
			if (layer.Period == 0) layer.Period = 1;
		}

		style.Name = BaseStr.Trim(fi.GetStr(off++));

		var cl:uint = 0;
		if (fi.GetInt(off++)) cl |= ClassSun;
		if (fi.GetInt(off++)) cl |= ClassPlanet;
		if (fi.GetInt(off++)) cl |= ClassSputnik;
		if (fi.GetInt(off++)) cl |= ClassSmall;
		if (fi.GetInt(off++)) cl |= ClassNormal;
		if (fi.GetInt(off++)) cl |= ClassLarge;
		if (fi.GetInt(off++)) cl |= ClassAtmNo;
		if (fi.GetInt(off++)) cl |= ClassAtmExist;
		if (fi.GetInt(off++)) cl |= ClassAtmLive;
		style.Class = cl;

		m_SaveArea.text = save(style);
	}
	
	static public function SaveAreaChange(e:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;

		load(m_SaveArea.text, m_EditId);

		var fi:FormInputEx = StdMap.Main.FI;
		fi.Hide();
		Edit(m_EditId);
		fi.tab = 2;
	}
	
	static public function LayerUp(e:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Object = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		if (style.Layer.length <= 1) return;
		var l:int = fi.page;
		if (l<0 || l>=style.Layer.length) return;

		if (l <= 0) return;

		var layer:Object = style.Layer[l];
		style.Layer.splice(l, 1);
		style.Layer.splice(l - 1, 0, layer);

		var px:int = fi.x;
		var py:int = fi.y;
		Edit(m_EditId);
		fi.x = px;
		fi.y = py;
		fi.page = l - 1;
	}

	static public function LayerDown(e:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Object = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		if (style.Layer.length <= 1) return;
		var l:int = fi.page;
		if (l<0 || l>=style.Layer.length) return;

		if (l >= (style.Layer.length - 1)) return;

		var layer:Object = style.Layer[l];
		style.Layer.splice(l, 1);
		style.Layer.splice(l + 1, 0, layer);

		var px:int = fi.x;
		var py:int = fi.y;
		Edit(m_EditId);
		fi.x = px;
		fi.y = py;
		fi.page = l + 1;
	}

	static public function LayerCopy(e:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Object = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;

		if (style.Layer.length >= 10) return;
		var l:int = fi.page;
		if (l<0 || l>=style.Layer.length) return;

		copy(style, l);

		var px:int = fi.x;
		var py:int = fi.y;
		Edit(m_EditId);
		fi.x = px;
		fi.y = py;
		fi.page = l + 1;
	}

	static public function LayerDel(e:Event):void
	{
		if (m_Map[m_EditId] == undefined) return;
		var style:Object = m_Map[m_EditId];

		var fi:FormInputEx = StdMap.Main.FI;
		
		if (style.Layer.length <= 1) return;
		var l:int = fi.page;
		if (l<0 || l>=style.Layer.length) return;

		style.Layer.splice(l, 1);
		
		var px:int = fi.x;
		var py:int = fi.y;
		Edit(m_EditId);
		fi.x = px;
		fi.y = py;
		if (l >= style.Layer.length) l = style.Layer.length - 1;
		fi.page=l;
	}
}
	
}