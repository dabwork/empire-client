package Engine {
// http://wscg.zcu.cz/wscg2005/Papers_2005/Short/B61-full.pdf
// http://code.google.com/p/kri/wiki/Quaternions
// http://habrahabr.ru/blogs/Flash_Platform/130454/

/*
alpha:
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
add+alpha:
		C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE );
screen:
		return 1.0-(1.0-s)*(1.0-d)
	or
		return s+d*(1.0-s)
	or
		C3D.Context.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR );
		если нужно учитывать прозрачность то в шейдере умножаем цвет на альфу
overlay:
	if(a < 0.5) return 2.0*a*b;
	else return 1.0 - 2.0 * (1 - a) * (1 - b)
*/


import fl.events.InteractionInputType;
import flash.display.Stage;
import flash.display3D.textures.Texture;
import flash.events.*;
import flash.display.*;
import flash.display3D.*;
import com.adobe.utils.AGALMiniAssembler;
import com.adobe.utils.PerspectiveMatrix3D;
import flash.geom.*;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import Base.*;

public class C3D
{
	static public const ToRad:Number = Math.PI / 180.0;
	static public const ToGrad:Number = 180.0 / Math.PI;
	static public const pi:Number = 3.14159265358979;
	static public const ClrToFloat:Number = 1.0 / 255.0;

	static public var stage:Stage = null;
	static public var stage3D:Stage3D = null;
	static public var Context:Context3D = null;
	static public var m_MainRenderTexture:Texture = null;
	
	static public var m_GraphSimple:Boolean = true;
	
	static public var m_SizeX:int = 0;
	static public var m_SizeY:int = 0;
	static public var m_SizeNativeX:int = 0;
	static public var m_SizeNativeY:int = 0;

	static public var m_Shader_State:int = 0;
	static public var m_Shader_TextureMask:uint = 0;
	static public var m_Shader_Simple:Program3D = null;
	static public var m_Shader_Ship:Vector.<Program3D> = new Vector.<Program3D>(8);
	static public var m_Shader_ShipTextureMask:Vector.<uint> = new Vector.<uint>(8);
	static public var m_Shader_MeshShadow:Program3D = null;
	static public var m_Shader_Planet:Program3D = null;
	static public var m_Shader_Helper:Program3D = null;
	static public var m_Shader_RectShadow:Program3D = null;
	static public var m_Shader_Circle:Vector.<Program3D> = new Vector.<Program3D>(2);
	static public var m_Shader_CircleContour:Program3D = null;
	static public var m_Shader_RedZone:Vector.<Program3D> = new Vector.<Program3D>(1);
	static public var m_Shader_MainTexture:Program3D = null;
	static public var m_Shader_Img:Vector.<Program3D> = new Vector.<Program3D>(2);
	static public var m_Shader_Dust:Program3D = null;
	static public var m_Shader_Particle:Vector.<Program3D> = new Vector.<Program3D>(2);
	static public var m_Shader_Text:Vector.<Program3D> = new Vector.<Program3D>(4);
	//static public var m_Shader_TextOutline:Program3D = null;
	static public var m_Shader_Halo:Vector.<Program3D> = new Vector.<Program3D>(2);

	static public var m_VB_State:int = 0;
	static public var m_VB_Cnt:int = 0;
	static public var m_VB_Simple:VertexBuffer3D = null;
	static public var m_VB_Img:VertexBuffer3D = null;
	static public var m_VB_RectShadow:VertexBuffer3D = null;
	static public var m_VB_MainTexture:VertexBuffer3D = null;
	static public var m_VB_Mesh:C3DMesh = null;
	static public var m_VB_QuadBatch:C3DQuadBatch = null;
	static public var m_VB_Halo:C3DHalo = null;

	static public var m_IB_Quad:IndexBuffer3D = null;

	static public var m_MatrixOrto:Matrix3D = null;
	static public var m_MatrixPerps:PerspectiveMatrix3D = null;

	static public var m_TextureMap:Dictionary = new Dictionary();
	
	static public var m_FontMap:Dictionary = new Dictionary();

	static public var m_VConst:Vector.<Number> = new Vector.<Number>(128 * 4);
	static public var m_FConst:Vector.<Number> = new Vector.<Number>(28 * 4);
	static public var m_VConstSet:Vector.<Number> = new Vector.<Number>(128 * 4);
	static public var m_FConstSet:Vector.<Number> = new Vector.<Number>(28 * 4);

	static public var _x:Vector3D = new Vector3D();
	static public var _y:Vector3D = new Vector3D();
	static public var _z:Vector3D = new Vector3D();
	static public var _w:Vector3D = new Vector3D();
	static public var _m:Vector.<Number> = new Vector.<Number>(16);

	static public var m_ShowState:int = 0;

	static public const PassZ:uint = 1;
	static public const PassShadow:uint = 2;
	static public const PassDif:uint = 3;
	static public const PassDifShadow:uint = 4;
	static public const PassLum:uint = 5;
	static public const PassParticle:uint = 6;
	static public var m_Pass:uint = 0;
	
	static public var m_FatalError:String = "";

/*	CONFIG::player {
		static public var m_AntiAlias:int = 16;
	}
	CONFIG::desktop {
		static public var m_AntiAlias:int = 16;
	}
	CONFIG::mobil {
		static public var m_AntiAlias:int = 0;
	}*/
	
	static public var m_Halo:C3DHalo = null;
	
	public static function ClrReplaceAlpha(clr:uint, alpha:Number, premulalpha:Boolean = false):uint
	{
		if (alpha <= 0.0) return clr & 0xffffff;
		else if (alpha >= 1.0) return clr | 0xff000000;
		else if (!premulalpha) return (uint(alpha * 255) << 24) | (clr & 0xffffff);

		var r:uint = (clr >> 16) & 255;
		var g:uint = (clr >> 8) & 255;
		var b:uint = (clr) & 255;

		return (uint(alpha * r) << 16) | (uint(alpha * g) << 8) | (uint(alpha * b)) | (uint(alpha * 255) << 24);
	}

	public static function ClrMake(r:Number, g:Number, b:Number, alpha:Number, premulalpha:Boolean = false):uint
	{
		if (r < 0.0) r = 0.0;
		else if (r > 1.0) r = 1.0;
		if (g < 0.0) g = 0.0;
		else if (g > 1.0) g = 1.0;
		if (b < 0.0) b = 0.0;
		else if (b > 1.0) b = 1.0;
		
		if (alpha < 0.0) alpha = 0.0;
		else if (alpha > 1.0) alpha = 1.0;
	
		if (premulalpha) {
			r *= alpha;
			g *= alpha;
			b *= alpha;
		}

		return (uint(255.0 * r) << 16) | (uint(255.0 * g) << 8) | (uint(255.0 * b)) | (uint(255.0 * alpha) << 24);
	}

    public static function getNextPowerOfTwo(number:int):int
    {
		var result:int = 1;
		while (result < number) result *= 2;
		return result;   
    }
	
	public static function Deinit():void
	{
		//if (stage3D == null) return;
		//stage3D.context3D.dispose();
		//Context = null;
		//stage3D = null;
//		if (Context != null) {
//			Context.dispose();
//			Context = null;
//		}
	}

	public static function Init(stage:Stage):void
	{
		var i:int;
		for (i = 0; i < 128 * 4; i++) {
			m_VConst[i] = 0.0;
			m_VConstSet[i] = 0.0;
		}
		for (i = 0; i < 28 * 4; i++) {
			m_FConst[i] = 0.0;
			m_FConstSet[i] = 0.0;
		}
		Init2(stage);
	}

	public static function Init2(cur_stage:Stage):void
	{
		stage = cur_stage;
		stage3D = stage.stage3Ds[0];

		stage3D.addEventListener(Event.CONTEXT3D_CREATE, InitInitializeFirst, false, 999);
		stage3D.addEventListener(ErrorEvent.ERROR, InitErrorFirst);

		m_GraphSimple = Set.m_Graph == Context3DProfile.BASELINE_CONSTRAINED;
		stage3D.requestContext3D(Context3DRenderMode.AUTO, Set.m_Graph);
	}
	
	public static function InitErrorFirst(event:ErrorEvent):void
	{
//trace("ERROR in requestContext3D", event.text);
		stage3D.removeEventListener(ErrorEvent.ERROR, InitErrorFirst);
		stage3D.addEventListener(ErrorEvent.ERROR, InitError);
		
		stage3D.removeEventListener(Event.CONTEXT3D_CREATE, InitInitializeFirst, false);
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, InitInitialize, false, 999);
		
		m_GraphSimple = true;
		stage3D.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.BASELINE_CONSTRAINED);
	}

	public static function InitError(event:ErrorEvent):void
	{
		if (event != null) m_FatalError += "requestContext3D: " + event.toString() + "\n";
		else m_FatalError += "requestContext3D\n";
	}
	
	public static function InitInitializeFirst(e:Event):void
	{
		while (true) {
			var ct:Context3D = (e.currentTarget as Stage3D).context3D;
			if (ct == null) break;
			var str:String = ct.driverInfo;

			if (str.indexOf("oldDriver") >= 0) break;
			if (str.indexOf("userDisabled") >= 0) break;
			if (str.indexOf("Software") >= 0) break;
			if (str.indexOf("software") >= 0) break;
			if (str.indexOf("unavailable") >= 0) break;
			if (str.indexOf("explicit") >= 0) break;
			
			InitInitialize(e);
			return;
		}

		if (m_GraphSimple) {
			InitError(null);
			return;
		}

		InitErrorFirst(null);
	}
	
	public static function InitInitialize(e:Event):void
	{
		var i:int;
		//var stage3D:Stage3D = e.target as Stage3D;
		stage3D = e.currentTarget as Stage3D;

		Context = stage3D.context3D;
		if (Context == null) throw Error("Context3D");
//trace(Context.driverInfo);
		
		// Чистим для переинициализации если потерян девайс
		m_Shader_State = 0;
		m_Shader_TextureMask = 0;
		m_Shader_Simple = null;
		for (i = 0; i < m_Shader_Ship.length; i++) m_Shader_Ship[i] = null;
		m_Shader_MeshShadow = null;
		m_Shader_Planet = null;
		m_Shader_Helper = null;
		m_Shader_RectShadow = null;
		for (i = 0; i < m_Shader_Circle.length; i++) m_Shader_Circle[i] = null;
		m_Shader_CircleContour = null;
		for (i = 0; i < m_Shader_RedZone.length; i++) m_Shader_RedZone[i] = null;
		m_Shader_MainTexture = null;
		for (i = 0; i < m_Shader_Img.length; i++) m_Shader_Img[i] = null;
		for (i = 0; i < m_Shader_Particle.length; i++) m_Shader_Particle[i] = null;
		m_Shader_Dust = null;
		for (i = 0; i < m_Shader_Text.length; i++) m_Shader_Text[i] = null;
		for (i = 0; i < m_Shader_Halo.length; i++) m_Shader_Halo[i] = null;

		m_VB_State = 0;
		m_VB_Cnt = 0;
		m_VB_Simple = null;
		m_VB_Img = null;
		m_VB_RectShadow = null;
		m_VB_MainTexture = null;
		m_VB_Mesh = null;
		m_VB_QuadBatch = null;
		m_VB_Halo = null;

		m_IB_Quad = null;

		for each ( var t:C3DTexture in m_TextureMap) {
			if(t!=null) t.m_Texture = null;
		}

		m_SizeX = stage.stageWidth; if (m_SizeX < 32) m_SizeX = 32;
		m_SizeY = stage.stageHeight; if (m_SizeY < 32) m_SizeY = 32;
		m_SizeNativeX = m_SizeX;// getNextPowerOfTwo(m_SizeX);
		m_SizeNativeY = m_SizeY;// getNextPowerOfTwo(m_SizeY);
		
//trace("C3D.InitInitialize");

		//trace(Context.driverInfo);
		try {
			Context.configureBackBuffer(m_SizeX, m_SizeY, Set.m_AntiAlias, true, false);
		} catch (e:*) {
			m_FatalError = "configureBackBuffer: " + e.toString() + "\n";
			return;
		}

		//m_MainRenderTexture = Context.createTexture(m_SizeNativeX, m_SizeNativeY, Context3DTextureFormat.BGRA, true);
		
//		ShaderCircle(false);
//		ShaderCircle(true);

		CONFIG::debug {
			Context.enableErrorChecking = true;
		}
		CONFIG::release {
			Context.enableErrorChecking = false;
		}
		
//		EmpireMap.Self.init();
		
		StdMap.Main.InitializeC3D();
		
//		trace(Context.driverInfo);
	}

//	private static function handleEnterFrame(event:Event) : void
//	{
//		Context.clear(0.5, 0.5, 0.5, 1);
//		Context.present();
//	}

	public static function IsReady():Boolean
	{
		if (Context == null || Context.driverInfo == "Disposed") return false;
		return true;
	}

	public static function Resize():void
	{
		m_SizeX = stage.stageWidth; if (m_SizeX < 32) m_SizeX = 32;
		m_SizeY = stage.stageHeight; if (m_SizeY < 32) m_SizeY = 32;
		m_SizeNativeX = m_SizeX;// getNextPowerOfTwo(m_SizeX);
		m_SizeNativeY = m_SizeY;// getNextPowerOfTwo(m_SizeY);

		m_MatrixOrto = null;
		m_MatrixPerps = null;
		
		if (Context != null && Context.driverInfo != "Disposed") {

			try {
				// непонятно почему для андроида не нужно реконфигурировать буфер.
				CONFIG::player {
					Context.configureBackBuffer(m_SizeX, m_SizeY, Set.m_AntiAlias, true);
				}
				CONFIG::desktop {
					Context.configureBackBuffer(m_SizeX, m_SizeY, Set.m_AntiAlias, true);
				}
			} catch (e:*) {
				m_FatalError = "configureBackBuffer: " + e.toString() + "\n";
				return;
			}
		
		}

		if (m_MainRenderTexture != null) {
			m_MainRenderTexture.dispose();
			m_MainRenderTexture = null;
		}
		
		//m_MainRenderTexture = Context.createTexture(m_SizeNativeX, m_SizeNativeY, Context3DTextureFormat.BGRA, true);
	}

	public static function SetMainRanderTexture():void
	{
		Context.setRenderToTexture(m_MainRenderTexture, true, Set.m_AntiAlias);
		Context.clear(0.0, 0, 0, 0, 1.0, 0);

		Context.setScissorRectangle(new Rectangle(0,0,m_SizeX,m_SizeY));
	}
	
	public static function RanderMainTexture():void
	{
		Context.setRenderToBackBuffer();
		C3D.Context.setDepthTest(false, Context3DCompareMode.ALWAYS);
		C3D.Context.setColorMask(true, true, true, true);
		C3D.Context.setCulling(Context3DTriangleFace.NONE);
		C3D.Context.setStencilActions();

		Context.setScissorRectangle(null);

		C3D.Context.setTextureAt(0, m_MainRenderTexture);

		C3D.ShaderMainTexture();
		C3D.VBMainTexture();

		var x0:Number = -1.0;
		var y0:Number =  1.0;
		var x1:Number =  1.0;
		var y1:Number = -1.0;

		var u:Number = m_SizeX / m_SizeNativeX;
		var v:Number = m_SizeY / m_SizeNativeY;

		C3D.SetVConst(0, new Vector3D(0.0, 0.5, 1.0, 2.0));
		C3D.SetVConst(1, new Vector3D( x0, y0, 0.0, 0.0));
		C3D.SetVConst(2, new Vector3D( x1, y0, u  , 0.0));
		C3D.SetVConst(3, new Vector3D( x1, y1, u  , v));
		C3D.SetVConst(4, new Vector3D( x0, y1, 0.0, v));

		C3D.DrawQuad();

		C3D.Context.setTextureAt(0, null);
	}

	public static function ShaderSimple():void
	{
		if (m_Shader_State == 1) return;
		m_Shader_State = 1;
		m_Shader_TextureMask = (1 << 0);

		if(m_Shader_Simple==null) {
			var vertexShader:Array =
			[
				"dp4 op.x, va0, vc0",
				"dp4 op.y, va0, vc1",
				"dp4 op.z, va0, vc2",
				"dp4 op.w, va0, vc3",
				"mov v0, va1.xyzw"
			];
			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, vertexShader.join("\n"));

			var fragmentShader:Array =
			[
				"mov ft0, v0\n",
				"tex ft1, ft0, fs0 <2d,clamp,linear,miplinear,-0.5>\n",
				"mov oc, ft1\n"
			];
			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, fragmentShader.join("\n"));

			m_Shader_Simple=Context.createProgram();
			m_Shader_Simple.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Simple);
	}
	
	public static function ShaderRectShadow():void
	{
		if (m_Shader_State == 3) return;
		m_Shader_State = 3;
		m_Shader_TextureMask = 0;
		
		if (m_Shader_RectShadow == null) {
			// Const
			var fcClr:String = "fc0";

			var vPos:String = "va0";

			// Var

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.mov("op", vPos);

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.mov("oc", fcClr);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_RectShadow=Context.createProgram();
			m_Shader_RectShadow.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_RectShadow);
	}
	
	public static function ShaderMeshShadow():void
	{
		if (m_Shader_State == 2) return;
		m_Shader_State = 2;
		m_Shader_TextureMask = 0;
		
		if (m_Shader_MeshShadow == null) {
			// Const
			var vcWorldViewProj:String = "vc0";
			var vcLight:String = "vc4";
			var vcDir:String = "vc5";
			var vcConstBase:String = "vc6"; // x=0.0 y=0.5 z=1.0 w=2.0

			var fcConstBase:String = "fc1"; // x=0.0 y=0.5 z=1.0 w=2.0

			var vPos:String = "va0";
			var vNormal:String = "va1";

			// Var
			var vtPos:String = "vt0";
			var vtL:String = "vt5";
			var vtA:String = "vt6";

			var iLI:String = "v0";

			var ftA:String = "ft6";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			
			// Diffuse Light
			AGAL.dp3(vtL, vNormal+".xyz", vcLight);
			AGAL.sat(vtL + ".x", vtL + ".x");

			// Write light
			AGAL.mov(iLI, vtL);

			// Pos
			AGAL.slt(vtA + ".x", vtL + ".y", vcConstBase + ".x");
			//AGAL.mov(vtA + ".x", vcConstBase + ".z");
			AGAL.mul(vtA, vcDir, vtA + ".xxxx");
			//AGAL.mov(vtA, vcDir);
			AGAL.add(vtPos, vPos, vtA);

			AGAL.m44(vtPos, vtPos, vcWorldViewProj);
			AGAL.mov("op", vtPos);
			
			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.mov(ftA, iLI + ".xxxx");
AGAL.mul(ftA, ftA, fcConstBase + ".yyyy");
AGAL.add(ftA, ftA, fcConstBase + ".yyyy");
			AGAL.mov(ftA + ".w", fcConstBase + ".z");
			AGAL.mov("oc", ftA);
			
			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_MeshShadow=Context.createProgram();
			m_Shader_MeshShadow.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_MeshShadow);
	}

	public static function ShaderShip(dif:Boolean, shadow:Boolean, lum:Boolean):void
	{
		var kk:int = 0;
		if (dif) kk |= 1;
		if (shadow) kk |= 2;
		if (lum) kk |= 4;
		if (m_Shader_State == (0x10000 | kk)) return;
		m_Shader_State = 0x10000 | kk;

//m_Shader_Ship = null;
		if (m_Shader_Ship[kk] == null) {
			m_Shader_TextureMask = 0;
			
			// Const
			var vcWorldViewProj:String = "vc0";
			var vcLight:String = "vc4";
			var vcViewPos:String = "vc5";
			var vcConstBase:String = "vc6"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcConstShadow:String = "vc7"; // x=0.1 y=1.0/0.4 z=0.5 w=10.0

			//var fcLight:String = "fc0";
			var fcConstBase:String = "fc1"; // x=0.0 y=0.5 z=1.0 w=2.0
			var fcConstShadow:String = "fc2"; // x=0.1 y=1.0/0.4 z=0.5 w=10.0
			var fcViewPos:String = "fc3";

			var fcColor:String = "fc4";
			var fcColorAmbient:String="fc5";
			var fcColorDiffuse:String = "fc6";
			var fcColorReflection:String = "fc7";
			var fcColorShadow:String = "fc8";

			// Var
			var texDif:String = "fs0";
			var texSelf:String = "fs1";
			var texColor:String = "fs2";
			
			var vPos:String = "va0";
			var vNormal:String = "va1";
			var vTexPos:String = "va2";
			
			var vtPos:String = "vt0";
			var vtL:String = "vt4";
			var vtA:String = "vt3";
			var vtB:String = "vt2";
			var vtC:String = "vt1";
			
			var iTexPos:String = "v0";
			var iLI:String = "v1"; // x-Diffuse y-reflect z-Shadow w-view
			
			var ftOut:String = "ft0";
			var ftClr:String = "ft1";
			var ftNormal:String = "ft2";
			var ftC:String = "ft3";
			var ftK:String = "ft4";
			var ftA:String = "ft5";
			var ftB:String = "ft6";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.m44(vtPos, vPos, vcWorldViewProj);
			AGAL.mov("op", vtPos);
			if(dif || lum) {
				AGAL.mov(iTexPos, vTexPos);
			}

			// Diffuse Light
			if(dif || shadow) {
				AGAL.dp3(vtL, vNormal+".xyz", vcLight);
				//AGAL.max(vtL, vtL, vcConstBase + ".xxxx");
				AGAL.sat(vtL, vtL);
			}

			// Shadow kof
			if(shadow) {
				AGAL.max(vtL + ".z", vtL + ".z", vcConstShadow + ".x");
				AGAL.min(vtL + ".z", vtL + ".z", vcConstShadow + ".z");
				AGAL.sub(vtL + ".z", vtL + ".z", vcConstShadow + ".x");
				AGAL.mul(vtL + ".z", vtL + ".z", vcConstShadow + ".y");
				AGAL.sub(vtL + ".z", vcConstBase + ".z", vtL + ".z");
				AGAL.mul(vtL + ".z", vtL + ".z", vtL + ".z");
			}

			// View kof
			if(dif) {
				AGAL.mov(vtA, vcViewPos);
				AGAL.neg(vtA, vtA);
				AGAL.dp3(vtL + ".w", vtA + ".xyz", vNormal + ".xyz");
				AGAL.add(vtL + ".w", vtL + ".w", vtL + ".w");
				//AGAL.mul(vtL + ".w", vtL + ".w", vcConstShadow+".w");
				AGAL.sat(vtL + ".w", vtL + ".w");
//				AGAL.mul(vtL + ".w", vtL + ".w", vtL + ".w");
//				AGAL.mul(vtL + ".w", vtL + ".w", vtL + ".w");
			}

			// Reflect
			if(dif) {
				//AGAL.sub(vtA, vPos, vcViewPos);
				//AGAL.nrm(vtA + ".xyz", vtA + ".xyz");
				AGAL.mov(vtA, vcViewPos);

				AGAL.dp3(vtB + ".x", vtA + ".xyz", vNormal + ".xyz"); // b=view*normal
				AGAL.mul(vtB + ".xyz", vNormal + ".xyz", vtB + ".x"); // b*=normal
				AGAL.add(vtB + ".xyz", vtB + ".xyz", vtB + ".xyz"); // b*=2
				AGAL.sub(vtB + ".xyz", vtA + ".xyz", vtB + ".xyz"); // reflect b=view-b

//AGAL.nrm(vtB + ".xyz", vtB + ".xyz");

				AGAL.dp3(vtL + ".y", vtB + ".xyz", vcLight + ".xyz");
				AGAL.sat(vtL + ".y", vtL + ".y");
				AGAL.mul(vtL + ".y", vtL + ".y", vtL + ".w");
			}

			 // Write light
			 if(dif || shadow) {
				AGAL.mov(iLI, vtL);
			 }

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			if(dif) {
				AGAL.tex(ftClr, iTexPos, texDif, "2d", "clamp", "linear,miplinear,-0.4");
				m_Shader_TextureMask |= 1 << 0;
			}

			// Color
			if(dif) {
				AGAL.tex(ftA, iTexPos, texColor, "2d", "clamp", "linear,miplinear,-0.4");
				m_Shader_TextureMask |= 1 << 2;

/*				AGAL.mul(ftB, ftClr, fcColor);
				AGAL.mul(ftB, ftB, fcConstBase + ".wwwz");
				//AGAL.mov(ftClr, ftA+".xxxx");
				//AGAL.lerp(ftClr + ".xyz", ftClr + ".xyz", ftB + ".xyz", ftA + ".xxx");
				AGAL.sub(ftB + ".xyz", ftB + ".xyz", ftClr + ".xyz");
				AGAL.mul(ftB + ".xyz", ftB + ".xyz", ftA + ".xxx");
				AGAL.add(ftClr + ".xyz", ftClr + ".xyz", ftB + ".xyz");*/

				AGAL.mul(ftB, ftClr, fcColor);
				AGAL.mul(ftB+".xyz", ftB, fcConstBase + ".w");
				AGAL.sub(ftB + ".xyz", ftB, ftClr);
				AGAL.mul(ftB + ".xyz", ftB, ftA + ".xxx");
				AGAL.add(ftClr + ".xyz", ftClr, ftB);
			}
			
			// Ambient
			if(dif || shadow) {
				AGAL.mul(ftOut, ftClr, fcColorAmbient);
				AGAL.mov(ftOut + ".w", fcConstBase + ".z");
				//AGAL.mov(ftOut, ftClr);
//				AGAL.mov(ftOut, fcConstBase + ".yyyz");
//				AGAL.mul(ftOut, ftOut, fcConstBase + ".yyyz");
			} else if (lum) {
			} else {
				AGAL.mov(ftOut, fcConstBase + ".xxxz");
			}

			// Diffuse
			if(dif) {
				AGAL.mov(ftA, iLI + ".xxxx");
				AGAL.mul(ftA, ftA, ftA); // pow2
				AGAL.mul(ftA, ftA, ftClr);
				AGAL.mul(ftA, ftA, fcColorDiffuse);
				AGAL.add(ftOut + ".xyz", ftOut, ftA);
			}

			// Reflect
			if(dif) {
				AGAL.pow(ftA + ".y", iLI + ".y", fcConstShadow + ".w");
				AGAL.mul(ftA, ftA + ".yyyy", fcColorReflection);
				AGAL.add(ftOut + ".xyz", ftOut, ftA);
//if(s == 0)	AGAL.add(ftOut + ".xyz", ftOut, iLI + ".yyy");
//if(s == 1)	AGAL.mov(ftOut + ".xyz", iLI + ".yyy");
//if(s == 2)	AGAL.mul(ftOut + ".xyz", iLI + ".yyy", iLI + ".www");
//if(s==1)	AGAL.mov(ftOut + ".xyz", iLI + ".www");
			}

			// Shadow
			if(shadow) {
				AGAL.sub(ftA + ".xyz", fcColorShadow, ftOut);
//				AGAL.mul(ftA + ".xyz", ftA + ".xyz", iLI + ".zzz");
//AGAL.mul(ftA, ftA + ".xyz", iLI);
//				AGAL.mul(ftA + ".xyz", ftA + ".xyz", fcColorShadow + ".www");
//for(var rrr:int = 0; rrr < 101; rrr++)
//AGAL.mul(ftA + ".x", ftA+".x", iLI + ".zzz");

				AGAL.mul(ftA + ".xyz", ftA, iLI + ".zzz");
				AGAL.mul(ftA + ".xyz", ftA, fcColorShadow + ".www");

				//AGAL.add(ftOut + ".xyz", ftA + ".xyz", ftOut + ".xyz");
				AGAL.add(ftOut + ".xyz", ftA, ftOut);
			}

			// Luminescence
			if ((dif || shadow) && lum) {
				m_Shader_TextureMask |= 1 << 1;
				AGAL.tex(ftA, iTexPos, texSelf, "2d", "clamp", "linear,miplinear,-0.4");
				AGAL.sub(ftA + ".xyz", ftA, ftOut);
				AGAL.mul(ftA + ".xyz", ftA, ftA + ".www");
				AGAL.add(ftOut + "xyz", ftOut, ftA);
			} else if (lum) {
				m_Shader_TextureMask |= 1 << 1;
				AGAL.tex(ftOut, iTexPos, texSelf, "2d", "clamp", "linear,miplinear,-0.4");
			}
			
			//AGAL.mov(ftClr, ftA + "xyz"); AGAL.mov(ftClr+".w", fcConstBase + "x");
			//AGAL.mov(ftOut + ".w", fcConstBase + ".z");
			AGAL.mov("oc", ftOut);
			
//var debug:Boolean = dif == true && shadow == true && lum == false;
//if(debug) {
//trace("======================================================");
//trace(AGAL.code);
//trace("======================================================");
//}
			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_ShipTextureMask[kk] = m_Shader_TextureMask;
			m_Shader_Ship[kk]=Context.createProgram();
//if(debug) trace("Code length:", fa.agalcode.length);
			m_Shader_Ship[kk].upload(va.agalcode, fa.agalcode);
		}

		m_Shader_TextureMask = m_Shader_ShipTextureMask[kk];
		Context.setProgram(m_Shader_Ship[kk]);
	}
	
/*	public static function ShaderShip(s:int = 0):void
	{
		if (m_Shader_State == 2+s) return;
		m_Shader_State = 2+s;
m_Shader_Ship = null;
		if (m_Shader_Ship == null) {
			// Const
			var vcWorldViewProj:String = "vc0";
			var vcLight:String = "vc4";
			var vcViewPos:String = "vc5";

			var fcLight:String = "fc0";
			var fcConstBase:String = "fc1"; // x=0.0 y=0.5 z=1.0 w=2.0
			var fcConstShadow:String = "fc2"; // x=0.1 y=1.0/0.4 z=0.5 w=10.0
			var fcViewPos:String = "fc3";

			var fcColor:String = "fc4";
			var fcColorAmbient:String="fc5";
			var fcColorDiffuse:String = "fc6";
			var fcColorReflection:String = "fc7";
			var fcColorShadow:String = "fc8";

			// Var
			var texDif:String = "fs0";
			var texSelf:String = "fs1";
			var texColor:String = "fs2";
			
			var vPos:String = "va0";
			var vNormal:String = "va1";
			var vTexPos:String = "va2";
			
			var vtPos:String = "vt0";
			var vtA:String = "vt6";
			var vtB:String = "vt7";
			
			var iPos:String = "v0";
			var iTexPos:String = "v1";
			var iNormal:String = "v2";
			//var iLight:String = "v3";
			//var iView:String = "v4";
			
			var ftOut:String = "ft0";
			var ftClr:String = "ft1";
			var ftNormal:String = "ft2";
			var ftC:String = "ft4";
			var ftK:String = "ft5";
			var ftA:String = "ft6";
			var ftB:String = "ft7";

			// Vertex shader
			AGAL.init();
			AGAL.m44(vtPos, vPos, vcWorldViewProj);
			AGAL.mov("op", vtPos);
			AGAL.mov(iPos, vPos);
			AGAL.mov(iTexPos, vTexPos);
			AGAL.mov(iNormal, vNormal);

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader
			AGAL.init();
			AGAL.tex(ftClr, iTexPos, texDif, "2d", "clamp", "linear,miplinear,-0.5");
			//AGAL.nrm(ftNormal + ".xyz", iNormal + ".xyz"); AGAL.mov(ftNormal + ".w", fcConstBase + ".x");
			AGAL.nrm(ftNormal + ".xyz", iNormal); AGAL.mov(ftNormal + ".w", fcConstBase + ".x");
			//AGAL.mov(ftNormal, iNormal); AGAL.mov(ftNormal + ".w", fcConstBase + ".x");

			// Color
			AGAL.tex(ftA, iTexPos, texColor, "2d", "clamp", "linear,miplinear,-0.5");

			AGAL.mul(ftB, ftClr, fcColor);
			AGAL.mul(ftB, ftB, fcConstBase + ".wwwz");
			//AGAL.mov(ftClr, ftA+".xxxx");
			//AGAL.lerp(ftClr + ".xyz", ftClr + ".xyz", ftB + ".xyz", ftA + ".xxx");
			AGAL.sub(ftB + ".xyz", ftB + ".xyz", ftClr + ".xyz");
			AGAL.mul(ftB + ".xyz", ftB + ".xyz", ftA + ".xxx");
			AGAL.add(ftClr + ".xyz", ftClr + ".xyz", ftB + ".xyz");

			// Ambient
			AGAL.mul(ftOut, ftClr, fcColorAmbient);
			//AGAL.mov(ftOut, fcConstBase + ".xxxz");

			// Diffuse
			AGAL.dp3(ftA, ftNormal, fcLight);
			AGAL.max(ftA, ftA, fcConstBase + ".xxxx");
			AGAL.mov(ftK, ftA); // for shadow
			AGAL.mul(ftA, ftA, ftA); // pow2
			AGAL.mul(ftA, ftA, ftClr);
			AGAL.mul(ftA, ftA, fcColorDiffuse);
			AGAL.add(ftOut, ftOut, ftA);

			// Reflect
			AGAL.sub(ftA, fcViewPos, iPos);
			AGAL.nrm(ftA + ".xyz", ftA + ".xyz");
			//AGAL.reflect(ftB, ftA + ".xyz", ftNormal + ".xyz");
			
			AGAL.dp3(ftB + ".x", ftA + ".xyz", ftNormal + ".xyz"); // b=view*normal
//if(s==0) AGAL.mov(ftOut + ".xyz", ftB + ".xxx");
//if(s==1) AGAL.mov(ftOut + ".xyz", ftA + ".xyz");
//if(s==2) AGAL.mov(ftOut + ".xyz", ftNormal + ".xyz");
			AGAL.mul(ftB + ".xyz", ftNormal + ".xyz", ftB + ".x"); // b*=normal
			AGAL.add(ftB + ".xyz", ftB + ".xyz", ftB + ".xyz"); // b*=2
			AGAL.sub(ftB + ".xyz", ftA + ".xyz", ftB + ".xyz"); // reflect b=view-b
			
			AGAL.dp3(ftA + ".x", ftB + ".xyz", fcLight + ".xyz");

AGAL.dp3(ftC + ".x", ftNormal + ".xyz", ftNormal + ".xyz");
AGAL.sqt(ftC + ".x", ftC + ".x");
AGAL.sge(ftA + ".w", ftC + ".x", fcConstBase + ".w"); // sge	dst = (src1 >= src2) ? 1 : 0
//AGAL.slt(ftA + ".w", ftC + ".x", fcConstBase + ".y");

//AGAL.min(ftA + ".x", ftA + ".x", fcConstShadow + ".x");
//AGAL.max(ftA + ".x", ftA + ".x", fcConstBase + ".x");
//AGAL.sge(ftA + ".w", ftA + ".x", fcConstBase + ".z");
//AGAL.dp3(ftA, ftA, ftNormal);
//			AGAL.max(ftA + ".x", ftA + ".x", fcConstBase+".x");
//			AGAL.min(ftA + ".x", ftA + ".x", fcConstBase+".z");
//			AGAL.sat(ftA+".x", ftA+".x");
			//AGAL.pow(ftA + ".x", ftA + ".x", fcColorShadow + ".w");
			
//			AGAL.mul(ftOut, ftOut, fcConstBase + ".xxxz");
			//AGAL.mov(ftOut + ".xyz", ftA + ".xww");
//			AGAL.mov(ftOut + ".w", fcConstBase + ".z");

			// Shadow
			AGAL.max(ftK + ".x", ftK + ".x", fcConstShadow + ".x");
			AGAL.min(ftK + ".x", ftK + ".x", fcConstShadow + ".z");
			AGAL.sub(ftK + ".x", ftK + ".x", fcConstShadow + ".x");
			AGAL.mul(ftK + ".x", ftK + ".x", fcConstShadow + ".y");
			AGAL.sub(ftK + ".x", fcConstBase + ".z", ftK + ".x");
			AGAL.mul(ftK + ".x", ftK + ".x", ftK + ".x");
			AGAL.mul(ftK + ".x", ftK + ".x", fcColorShadow + ".w");

			AGAL.sub(ftA + ".xyz", fcColorShadow + ".xyz", ftOut + ".xyz");
			AGAL.mul(ftA + ".xyz", ftA + ".xyz", ftK + ".xxx");
if(s==0 || s==1)	AGAL.add(ftOut + ".xyz", ftA + ".xyz", ftOut + ".xyz");
			
			// Self
			AGAL.tex(ftA, iTexPos, texSelf, "2d", "clamp", "linear,miplinear,-0.5");
			AGAL.sub(ftA + ".xyz", ftA + ".xyz", ftOut + ".xyz");
			AGAL.mul(ftA + ".xyz", ftA + ".xyz", ftA + ".www");
if(s==0)	AGAL.add(ftOut + "xyz", ftOut + "xyz", ftA + ".xyz");
			

			//AGAL.mov(ftClr, ftA + "xyz"); AGAL.mov(ftClr+".w", fcConstBase + "x");
			//AGAL.mov(ftOut + ".w", fcConstBase + ".z");
			AGAL.mov("oc", ftOut);
			
			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_Ship=Context.createProgram();
			m_Shader_Ship.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Ship);
	}*/
	
	public static function ShaderPlanet():void
	{
		if (m_Shader_State == 9) return;
		m_Shader_State = 9;
		m_Shader_TextureMask = 1 << 0;

//m_Shader_Ship = null;
		if (m_Shader_Planet == null) {
			// Const
			var vcWorldViewProj:String = "vc0";

			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var fcConstShadow:String = "fc1"; // x=0.1 y=1.0/0.4 z=0.5 w=10.0
			var fcLight:String = "fc2";
			var fcView:String = "fc3";

			var fcColor:String = "fc4";
			var fcColorAmbient:String = "fc5";
			var fcColorDiffuse:String = "fc6";
			var fcColorReflection:String = "fc7";
			var fcColorShadow:String = "fc8";
			var fcGamma:String = "fc9";
			var fcAlpha:String = "fc10";

			// Var
			var texDif:String = "fs0";

			var vPos:String = "va0";
			var vNormal:String = "va1";
			var vTexPos:String = "va2";

			var vtPos:String = "vt0";
			var vtA:String = "vt6";

			var iTexPos:String = "v0";
			var iNormal:String = "v1";

			var ftOut:String = "ft0";
			var ftClr:String = "ft1";
			var ftA:String = "ft4";
			var ftB:String = "ft3";
			var ftL:String = "ft2";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.m44(vtPos, vPos, vcWorldViewProj);
			AGAL.mov("op", vtPos);
			AGAL.mov(iNormal, vNormal);
			AGAL.mov(iTexPos, vTexPos);
				
			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.tex(ftClr, iTexPos, texDif, "2d", "clamp", "linear,miplinear,-0.5");
//			AGAL.dp3(ftA + ".x", ftClr, fcAlpha);
//			AGAL.add(ftA + ".x", ftA + ".x", fcAlpha + ".w");
//			AGAL.add(ftA + ".x", ftA + ".x", ftClr + ".w");
			AGAL.dp3(ftA, ftClr, fcAlpha);
			AGAL.add(ftA + ".x", ftA, fcAlpha + ".w");
			AGAL.add(ftA + ".x", ftA, ftClr + ".w");
			AGAL.sat(ftClr + ".w", ftA + ".x");
			AGAL.mul(ftClr, ftClr, fcColor);

			// Light
			AGAL.dp3(ftL, fcLight, iNormal);
			AGAL.sat(ftL, ftL);
			
			// Shadow kof
			AGAL.max(ftL + ".z", ftL + ".z", fcConstShadow + ".x");
			AGAL.min(ftL + ".z", ftL + ".z", fcConstShadow + ".z");
			AGAL.sub(ftL + ".z", ftL + ".z", fcConstShadow + ".x");
			AGAL.mul(ftL + ".z", ftL + ".z", fcConstShadow + ".y");
			AGAL.sub(ftL + ".z", fcConstBase + ".z", ftL + ".z");
			AGAL.mul(ftL + ".z", ftL + ".z", ftL + ".z");

			// View kof - коэффициент не параллельности плоскости к камере. (для уменьшения мерцающих точек на границе)
			AGAL.mov(ftA, fcView);
			AGAL.neg(ftA, ftA);
			AGAL.dp3(ftL + ".w", ftA, iNormal);
			//AGAL.dp3(ftL + ".w", ftA + ".xyz", iNormal + ".xyz");
			//AGAL.add(ftL + ".w", ftL + ".w", ftL + ".w");
			//AGAL.sat(ftL + ".w", ftL + ".w");
			AGAL.add(ftL + ".w", ftL, ftL);
			AGAL.sat(ftL + ".w", ftL);

			// ambient
			AGAL.mul(ftOut, ftClr, fcColorAmbient);

			// diffuse
			AGAL.mul(ftA, ftL + ".xxx", fcColorDiffuse);
			AGAL.mul(ftA, ftA, ftClr);
			AGAL.add(ftOut, ftOut, ftA);

			// reflect
//			AGAL.dp3(ftB + ".x", fcView + ".xyz", iNormal + ".xyz"); // b=view*normal
//			AGAL.mul(ftB + ".xyz", iNormal + ".xyz", ftB + ".x"); // b*=normal
//			AGAL.add(ftB + ".xyz", ftB + ".xyz", ftB + ".xyz"); // b*=2
//			AGAL.sub(ftB + ".xyz", fcView + ".xyz", ftB + ".xyz"); // reflect b=view-b

//for(var zzz:int = 0; zzz < 100; zzz++)
			AGAL.dp3(ftB, fcView, iNormal); // b=view*normal
			AGAL.mul(ftB + ".xyz", iNormal, ftB + ".x"); // b*=normal
			AGAL.add(ftB + ".xyz", ftB, ftB); // b*=2
			AGAL.sub(ftB + ".xyz", fcView, ftB); // reflect b=view-b

			AGAL.dp3(ftA, fcLight, ftB);
			//AGAL.dp3(ftA, fcLight+".xyz", ftB+".xyz");
			AGAL.sat(ftA, ftA);
			AGAL.pow(ftA + ".x", ftA + ".x", fcColorReflection + ".w");
			//AGAL.mul(ftA + ".x", ftA + ".x", ftL + ".w");
			AGAL.mul(ftA + ".x", ftA, ftL + ".w");
			
			AGAL.mul(ftA, ftA + ".xxx", fcColorReflection);
			AGAL.add(ftOut, ftOut, ftA);
			//AGAL.mov(ftOut, ftA + ".xxx");
//AGAL.mov(ftOut, ftL + ".www");

			// Shadow
			//AGAL.sub(ftA + ".xyz", fcColorShadow + ".xyz", ftOut + ".xyz");
			//AGAL.mul(ftA + ".xyz", ftA + ".xyz", ftL + ".zzz");
			//AGAL.mul(ftA + ".xyz", ftA + ".xyz", fcColorShadow + ".www");
			//AGAL.add(ftOut + ".xyz", ftA + ".xyz", ftOut + ".xyz");
			AGAL.sub(ftA + ".xyz", fcColorShadow, ftOut);
			AGAL.mul(ftA + ".xyz", ftA, ftL + ".zzz");
			AGAL.mul(ftA + ".xyz", ftA, fcColorShadow + ".www");
			AGAL.add(ftOut + ".xyz", ftA, ftOut);

			// Gamma
			//clr=saturate((clr-vGamma.x)*vGamma.y+vGamma.z)+vGamma.w;
			AGAL.sub(ftOut, ftOut, fcGamma + ".xxx");
			AGAL.mul(ftOut, ftOut, fcGamma + ".yyy");
			AGAL.add(ftOut, ftOut, fcGamma + ".zzz");
			AGAL.sat(ftOut, ftOut);
			AGAL.add(ftOut, ftOut, fcGamma + ".www");

			// Write
			AGAL.mov(ftOut + ".w", ftClr + ".w");
			//AGAL.mul(ftOut + ".xyz", ftOut + ".xyz", ftOut + ".w");
			AGAL.mul(ftOut + ".xyz", ftOut, ftOut + ".w");
			AGAL.mov("oc", ftOut);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_Planet=Context.createProgram();
			m_Shader_Planet.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Planet);
	}
/*
float4x4 	mWorldViewProj		: siWorldViewProj;
float4x4 	mWorld				: siWorld;
float4   	vViewPos			: siViewPos;
float4   	vLight				: siLight;

struct VS_INPUT_STRUCT
{
    float3 	pos     			: POSITION;
    float3	normal       		: NORMAL;
    float4	diffuse				: COLOR;
    float2	texcoordq			: TEXCOORD;
//    float3	tang         		: TANGENT;
//    float3	binormal     		: BINORMAL;
};

struct VS_OUTPUT
{
	float4 pos     				: POSITION;
	float2 texcoordq     		: TEXCOORD0;
	float3 light        		: TEXCOORD1;
	float3 normal       		: TEXCOORD2;
	float3 view					: TEXCOORD3;
//	float4 pos        			: TEXCOORD2;
};

VS_OUTPUT VSMain( VS_INPUT_STRUCT inp)
{
	VS_OUTPUT outp;

	outp.pos=mul(float4(inp.pos.xyz,1.0f),mWorldViewProj);
	outp.texcoordq = inp.texcoordq;
//	outp.pos=outp.position;
	
//	float3 n = normalize( mul( inp.normal, mWorld ));
//	outp.light=max(dot(n, vLight),0.0);

	outp.light=float3(vLight.x,vLight.y,vLight.z);
	outp.normal=normalize( mul( inp.normal,(float3x3)mWorld ));
	outp.view=normalize((vViewPos-mul(float4(inp.pos.x,inp.pos.y,inp.pos.z,1.0f),mWorld)).xyz);

	return outp;
}

///////////////////////////////////////////////////////////////////////////////
float4   	vColorAmbient		: siColorAmbient;
float4   	vColorDiffuse		: siColorDiffuse;
float4   	vColorReflection	: siColorReflection;
float4   	vColorShadow		: siColorShadow;

struct PS_INPUT_STRUCT
{
	float2 texcoordq			: TEXCOORD0;
	float3 light				: TEXCOORD1;
	float3 normal				: TEXCOORD2;
	float3 view					: TEXCOORD3;
//	float4 pos        			: TEXCOORD2;
};

sampler2D m_Tex1	: register(s0);
//sampler2D m_TexDet	: register(s1);

float4 PSMain(PS_INPUT_STRUCT inp):COLOR
{
	float4 tx_base = tex2D( m_Tex1, inp.texcoordq );

	//tx_base=float4(1.0,1.0,1.0,1.0);

	//float3 tx_base = tex2D( m_Tex1, inp.texcoord )*(0.3+inp.light.x*0.7);

	//float3 tx_det = tex2D( m_TexDet, inp.texcoord*16 );
	//float k=1.0-min(1.0,max(0,inp.pos.z/3000.0));
	//k=k*k;
	//tx_base=(1-k+k*tx_det*2)*tx_base;

	//return float4(tx_base.xyz,1.0f);//inp.light.w);

	float3 norm=inp.normal;
	float3 v=inp.view;
	float3 light=inp.light;
	float3 view=inp.view;

	float3 refl=reflect(-view,norm);

	float refl_light=pow(saturate(dot(refl, light)),10);

	float def=saturate(dot(norm, light));

	float4 def_col=tx_base;//float4(tx_base.x,tx_base.y,tx_base.z);
	float4 c=def_col*vColorAmbient+def_col*def*vColorDiffuse+refl_light*vColorReflection;

	float k=dot(norm, light);
	k=1.0-(clamp(k,0.1,0.5)-0.1)/0.4;
	c=lerp(c,vColorShadow,k*k*vColorShadow.w);

	return float4(c.xyz,tx_base.w*vColorAmbient.w);
}*/

	public static function ShaderHelper():void
	{
		if (m_Shader_State == 11) return;
		m_Shader_State = 11;
		m_Shader_TextureMask = 0;

		if (m_Shader_Helper == null) {
			// Const
			var vcWorldViewProj:String = "vc0";

//			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0

			var fcColor:String = "fc0";

			// Var
			var texDif:String = "fs0";

			var vPos:String = "va0";
//			var vNormal:String = "va1";
//			var vTexPos:String = "va2";

			var vtPos:String = "vt0";
			var vtA:String = "vt6";

//			var iTexPos:String = "v0";

			var ftOut:String = "ft0";
			var ftA:String = "ft4";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.m44(vtPos, vPos, vcWorldViewProj);
			AGAL.mov("op", vtPos);
				
			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.mov(ftOut, fcColor);
			AGAL.mov("oc", ftOut);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_Helper=Context.createProgram();
			m_Shader_Helper.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Helper);
	}

	public static function ShaderImg(img_premul_alpha:Boolean = false):void
	{
		var kk:int = 0;
		if (img_premul_alpha) kk |= 1;
		if (m_Shader_State == (0x50000 | kk)) return;
		m_Shader_State = 0x50000 | kk;

		m_Shader_TextureMask = 1 << 0;

		if (m_Shader_Img[kk] == null) {
			// Const
			var vcConstBase:String = "vc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcP0:String = "vc1";
			var vcP1:String = "vc2";
			var vcP2:String = "vc3";
			var vcP3:String = "vc4";

			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcMulClr:String = "fc1";

			// Var
			var texDif:String = "fs0";

			var vPos:String = "va0";

			var vtA:String = "vt0";
			var vtB:String = "vt1";

			var iTexCoord:String = "v0";

			var ftA:String = "ft0";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.mul(vtA, vPos+".xxxx", vcP0);
			AGAL.mul(vtB, vPos+".yyyy", vcP1);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".zzzz", vcP2);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".wwww", vcP3);
			AGAL.add(vtA, vtA, vtB);

			AGAL.mov(iTexCoord + ".xyzw", vtA + ".zwxy");
			AGAL.mov(vtA + ".zw", vcConstBase + ".xz");

			AGAL.mov("op", vtA);
//			AGAL.mov("op", vPos);

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.tex(ftA, iTexCoord, texDif, "2d", "repeat", "linear,mipnone");// clamp nearest "linear,miplinear,-0.5");
			AGAL.mul(ftA, ftA, vcMulClr);
			if (img_premul_alpha) {
				AGAL.mul(ftA + ".xyz", ftA + ".xyz", vcMulClr + ".www");
			}
			//AGAL.mov(ftA, vcMulClr);
			AGAL.mov("oc", ftA);
//			AGAL.mov("oc", fcConstBase + ".zzzz");

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_Img[kk]=Context.createProgram();
			m_Shader_Img[kk].upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Img[kk]);
	}

	public static function ShaderParticle(channelmask:Boolean = false):void
	{
		var kk:int = 0;
		if (channelmask) kk |= 1;
		if (m_Shader_State == (0x30000 | kk)) return;
		m_Shader_State = 0x30000 | kk;
		
		m_Shader_TextureMask = 1 << 0;

		if (m_Shader_Particle[kk] == null) {
			// Const
			var vcViewProj:String = "vc0";
			var vcProj:String = "vc4";
			var vcOffset:String = "vc8"; // x,y,z, w=1
			//var vcConstBase:String = "vc5"; // x=0.0 y=0.5 z=1.0 w=2.0
			
			var fcConstBase:String = "fc0"; // only for channelmask==true: x=0.0 y=0.5 z=1.0 w=2.0 

			// Var
			var texDif:String = "fs0";

			var vPos:String = "va0";
			var vNor:String = "va1";
			var vTexCoord:String = "va2";
			var vClr:String = "va3";
			var vPosTo:String = "va4";
			var vColorMask:String = "va5";
			var vAlphaMask:String = "va6";

			// posX,posY,posZ,basevX
			// norX,norY,norZ,basevY
			// tcU,tcV,mulalpha
			// clr
			// postoX,postoY,postoZ,width
			
			var vtA:String = "vt0";
			var vtB:String = "vt1";

			var iTexCoord:String = "v0";
			var iClr:String = "v1";
			var iColorMask:String = "v2";
			var iAlphaMask:String = "v3";

			var ftA:String = "ft0";
			var ftB:String = "ft1";
			var ftC:String = "ft2";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

//	float3 vx=inp.posto-inp.pos;
//	float3 vy=float4(normalize(cross(vx,-inp.nor))*inp.width,0.0);
//
//	float4 v;
//	v.x=inp.basev.x*vx.x+inp.basev.y*vy.x+inp.pos.x+vOffset.x;
//	v.y=inp.basev.x*vx.y+inp.basev.y*vy.y+inp.pos.y+vOffset.y;
//	v.z=inp.basev.x*vx.z+inp.basev.y*vy.z+inp.pos.z+vOffset.z;
//	v.w=1.0;
//	outp.pos=mul(v,mViewProj);
//
//	outp.tc=inp.tc;
//	outp.clr=inp.clr;

			AGAL.sub(vtA + ".xyz", vPosTo + ".xyz", vPos + ".xyz");
			AGAL.crs(vtB + ".xyz", vtA + ".xyz", vNor + ".xyz");
			AGAL.nrm(vtB + ".xyz", vtB + ".xyz");
			AGAL.mul(vtB + ".xyz", vtB + ".xyz", vPosTo + ".www");

			AGAL.mul(vtA + ".xyz", vPos + ".www", vtA + ".xyz");
			AGAL.mul(vtB + ".xyz", vNor + ".www", vtB + ".xyz");
			AGAL.add(vtA + ".xyz", vtA + ".xyz", vtB + ".xyz");
			AGAL.add(vtA + ".xyz", vtA + ".xyz", vPos + ".xyz");
			AGAL.add(vtA + ".xyz", vtA + ".xyz", vcOffset + ".xyz");
			AGAL.mov(vtA + ".w", vcOffset+".w");

			AGAL.m44("op", vtA, vcViewProj);

			AGAL.mov(iTexCoord + ".xyzw", vTexCoord + ".xyzz");
			AGAL.mov(iClr, vClr);
			if (channelmask) {
				AGAL.mov(iColorMask, vColorMask);
				AGAL.mov(iAlphaMask, vAlphaMask);
			}

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.tex(ftA, iTexCoord, texDif, "2d", "repeat", "linear,miplinear,0.0"); //"linear nomip miplinear,0.0"); clamp repeat
			//AGAL.div(ftA + ".xyz", ftA + ".xyz", ftA + ".w");
			if (channelmask) {
				//AGAL.dp4(ftC + ".x", iColorMask, iColorMask);
				//AGAL.slt(ftC + ".x", fcConstBase + ".x", ftC + ".x");
				//AGAL.sub(ftC + ".x", fcConstBase + ".z", ftC + ".x");
				AGAL.dp4(ftC, iColorMask, iColorMask);
				AGAL.slt(ftC + ".x", fcConstBase, ftC);
				AGAL.sub(ftC + ".x", fcConstBase + ".z", ftC);

				//AGAL.dp4(ftB + ".xyz", ftA, iColorMask);
				AGAL.dp4(ftB, ftA, iColorMask);
				//AGAL.add(ftB + ".xyz", ftB + ".xyz", ftC + ".xxx");
				AGAL.add(ftB + ".xyz", ftB, ftC + ".xxx");
				AGAL.dp4(ftB + ".w", ftA, iAlphaMask);
				AGAL.mov(ftA, ftB);
			}
			AGAL.mul(ftA, ftA, iClr);
			//AGAL.mul(ftA + ".xyz", ftA + ".xyz", ftA + ".www");
			AGAL.mul(ftA + ".xyz", ftA, ftA + ".www");
			//AGAL.mul(ftA + ".w", ftA + ".w", iTexCoord + ".w");
			AGAL.mul(ftA + ".w", ftA, iTexCoord);
			AGAL.mov("oc", ftA);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_Particle[kk]=Context.createProgram();
			m_Shader_Particle[kk].upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Particle[kk]);
	}

	public static function ShaderDust(/*channelmask:Boolean = false*/):void
	{
		if (m_Shader_State == 10) return;
		m_Shader_State = 10;
		m_Shader_TextureMask = 1 << 0;

		if (m_Shader_Dust == null) {
			// Const
			var vcViewProj:String = "vc0";
			var vcProj:String = "vc4";
			var vcOffset:String = "vc8"; // x,y,z, w=1
			var vcViewPos:String = "vc9";
			var vcViewY:String = "vc10";
			var vcZmod:String = "vc11"; // zmin,zdist,off,camdist
			var vcCamDist:String = "vc12"; // cam min,cam dist
			
			// Var
			var texDif:String = "fs0";

			var vPos:String = "va0";
			var vTexCoord:String = "va1";
			var vClr:String = "va2";
			var vBase:String = "va3";
//			var vColorMask:String = "va5";
//			var vAlphaMask:String = "va6";

			// posX,posY,posZ
			// tcU,tcV,
			// clr
			// basevX,basevY

			var vtA:String = "vt0";
			var vtB:String = "vt1";
			var vtC:String = "vt2";
			var vtPos:String = "vt3";
			var vtClr:String = "vt4";

			var iTexCoord:String = "v0";
			var iClr:String = "v1";
//			var iColorMask:String = "v2";
//			var iAlphaMask:String = "v3";

			var ftA:String = "ft0";
			var ftB:String = "ft1";
			var ftC:String = "ft2";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			
			AGAL.mov(vtClr, vClr);

			AGAL.mov(vtPos, vPos);
			AGAL.add(vtPos + ".z", vtPos + ".z", vcZmod + ".z");
			AGAL.frc(vtPos + ".z", vtPos + ".z");
			
			AGAL.mul(vtA + ".xyzw", vtPos + ".z", vtPos + ".z"); // Чем ближе к концу, тем прозрачней
			AGAL.mul(vtA, vtA, vtA);
			AGAL.mul(vtA, vtA, vtA);
			AGAL.mul(vtA, vtA, vtA);
			AGAL.mul(vtA, vtA, vtA);
			AGAL.sub(vtA, vcOffset + ".w", vtA);
			AGAL.mul(vtClr + ".w", vtClr, vtA + ".z");

			AGAL.mul(vtPos + ".z", vtPos + ".z", vcZmod + ".y");
			AGAL.add(vtPos + ".z", vtPos + ".z", vcZmod + ".x");

//		float3 nor=inp.pos-viewpos;
//		float3 vx=normalize(cross(viewy,nor));
//		float3 vy=normalize(cross(vx,nor));
			AGAL.add(vtC + ".xyz", vtPos + ".xyz", vcOffset + ".xyz");
			AGAL.sub(vtC + ".xyz", vtC + ".xyz", vcViewPos);
			AGAL.length(vtC + ".w", vtC + ".xyz");
			AGAL.crs(vtA + ".xyz", vcViewY, vtC);
			AGAL.nrm(vtA + ".xyz", vtA + ".xyz");
			AGAL.crs(vtB + ".xyz", vtA + ".xyz", vtC);
			AGAL.nrm(vtB + ".xyz", vtB + ".xyz");
			
			AGAL.sub(vtC + ".w", vtC, vcCamDist + ".x") // Чем ближе к камере, тем прозрачней
			AGAL.mul(vtC + ".w", vtC, vcCamDist + ".y");
			AGAL.sat(vtC + ".w", vtC);
			AGAL.sub(vtC + ".w", vcOffset, vtC);
			AGAL.mul(vtC + ".w", vtC, vtC);
			AGAL.mul(vtC + ".w", vtC, vtC);
			AGAL.sub(vtC + ".w", vcOffset, vtC);
			AGAL.mul(vtClr + ".w", vtClr, vtC);

//	float4 v;
//	v.x=inp.basev.x*vx.x+inp.basev.y*vy.x+inp.pos.x+vOffset.x;
//	v.y=inp.basev.x*vx.y+inp.basev.y*vy.y+inp.pos.y+vOffset.y;
//	v.z=inp.basev.x*vx.z+inp.basev.y*vy.z+inp.pos.z+vOffset.z;
//	v.w=1.0;
			AGAL.mul(vtA + ".xyz", vBase + ".xxx", vtA + ".xyz");
			AGAL.mul(vtB + ".xyz", vBase + ".yyy", vtB + ".xyz");
			AGAL.add(vtA + ".xyz", vtA + ".xyz", vtB + ".xyz");
			AGAL.add(vtA + ".xyz", vtA + ".xyz", vtPos + ".xyz");
			AGAL.add(vtA + ".xyz", vtA + ".xyz", vcOffset + ".xyz");
			AGAL.mov(vtA + ".w", vcOffset+".w");

//	outp.pos=mul(v,mViewProj);
			AGAL.m44("op", vtA, vcViewProj);

			AGAL.mov(iTexCoord + ".xyzw", vTexCoord + ".xyxy");
			AGAL.mov(iClr, vtClr);
//			if (channelmask) {
//				AGAL.mov(iColorMask, vColorMask);
//				AGAL.mov(iAlphaMask, vAlphaMask);
//			}

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.tex(ftA, iTexCoord, texDif, "2d", "repeat", "linear,miplinear,0.0"); //"linear nomip miplinear,0.0"); clamp repeat
//			if (channelmask) {
//				AGAL.dp4(ftC, iColorMask, iColorMask);
//				AGAL.slt(ftC + ".x", fcConstBase, ftC);
//				AGAL.sub(ftC + ".x", fcConstBase + ".z", ftC);

//				AGAL.dp4(ftB, ftA, iColorMask);
//				AGAL.add(ftB + ".xyz", ftB, ftC + ".xxx");
//				AGAL.dp4(ftB + ".w", ftA, iAlphaMask);
//				AGAL.mov(ftA, ftB);
//			}
			AGAL.mul(ftA, ftA, iClr);
//			AGAL.mul(ftA + ".xyz", ftA, ftA + ".www");
//			AGAL.mul(ftA + ".w", ftA, iTexCoord);
			AGAL.mov("oc", ftA);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_Dust=Context.createProgram();
			m_Shader_Dust.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Dust);
	}

	public static function ShaderMainTexture():void
	{
		if (m_Shader_State == 6) return;
		m_Shader_State = 6;
		m_Shader_TextureMask = 1 << 0;

		if (m_Shader_MainTexture == null) {
			// Const
			var vcConstBase:String = "vc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcP0:String = "vc1";
			var vcP1:String = "vc2";
			var vcP2:String = "vc3";
			var vcP3:String = "vc4";
			
			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcMulClr:String = "fc1";

			// Var
			var texDif:String = "fs0";

			var vPos:String = "va0";

			var vtA:String = "vt0";
			var vtB:String = "vt1";

			var iTexCoord:String = "v0";

			var ftA:String = "ft0";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.mul(vtA, vPos+".xxxx", vcP0);
			AGAL.mul(vtB, vPos+".yyyy", vcP1);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".zzzz", vcP2);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".wwww", vcP3);
			AGAL.add(vtA, vtA, vtB);

			AGAL.mov(iTexCoord + ".xyzw", vtA + ".zwxy");
			AGAL.mov(vtA + ".zw", vcConstBase + ".xz");

			AGAL.mov("op", vtA);
//			AGAL.mov("op", vPos);

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.tex(ftA, iTexCoord, texDif, "2d", "clamp", "nearest,mipnone");// nearest "linear,miplinear,-0.5");
			AGAL.mov("oc", ftA);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_MainTexture=Context.createProgram();
			m_Shader_MainTexture.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_MainTexture);
	}

	public static function ShaderText(outline:Boolean = false, rgba:Boolean = false):void
	{
		var kk:int = 0;
		if (outline) kk |= 1;
		if (rgba) kk |= 2;
		if (m_Shader_State == (0x40000 | kk)) return;
		m_Shader_State = 0x40000 | kk;
		
		m_Shader_TextureMask = 1 << 0;

		if (m_Shader_Text[kk] == null) {
			// Const
			var vcOffset:String = "vc0"; // x,y - offset z,w-scale
			var vcConstBase:String = "vc1"; // x=0.0 y=0.5 z=1.0 w=2.0
			
			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcMulClr:String = "fc1";
			var vcOutlineClr:String = "fc2";

			// Var
			var texDif:String = "fs0";

			var vPos:String = "va0";
			var vTexCoord:String = "va1";
			var vClr:String = "va2";
			
			var vtA:String = "vt0";

			var iTexCoord:String = "v0";
			var iClr:String = "v1";

			var ftA:String = "ft0";
			var ftB:String = "ft1";
			var ftC:String = "ft2";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.add(vtA + ".xy", vPos + ".xy", vcOffset + ".xy");
			AGAL.mul("op" + ".xy", vtA + ".xy", vcOffset + ".zw");
			AGAL.mov("op.zw", vcConstBase + ".xz");

			AGAL.mov(iTexCoord + ".xyzw", vTexCoord + ".xyxy");
			AGAL.mov(iClr, vClr);

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.tex(ftA, iTexCoord, texDif, "2d", "repeat", "linear,nomip,0.0"); //"nearest linear nomip miplinear,0.0");
			
			if (rgba) {
				AGAL.mov(ftC, iClr);
				AGAL.mul(ftC, ftC, ftA);
				AGAL.mul(ftC, ftC, vcMulClr);
				AGAL.mov("oc", ftC);

			} else if(outline) {
				AGAL.slt(ftB, fcConstBase + ".yyyy", ftA);
				AGAL.mul(ftC + ".xyzw", ftA + ".xxxx", fcConstBase + ".wwww");
				AGAL.sub(ftC + ".xyz", ftC + ".xyz", fcConstBase + ".zzz");
				AGAL.mul(ftC + ".xyz", ftC + ".xyz", ftB + ".xxx");
				AGAL.add(ftC + ".w", ftC + ".w", ftB + ".x");
				AGAL.min(ftC + ".w", ftC + ".w", fcConstBase + ".z");
				
				AGAL.mul(ftC, ftC, iClr);
				AGAL.mul(ftC, ftC, vcMulClr);
				AGAL.mov("oc", ftC);
			} else {
				AGAL.mov(ftC, iClr);
				AGAL.mul(ftC + ".w", ftC + ".w", ftA + ".x");
				AGAL.mul(ftC, ftC, vcMulClr);
				AGAL.mov("oc", ftC);
			}
			
//			AGAL.mul(ftA, ftA, iClr);
//			AGAL.mul(ftA, ftA, vcMulClr);
//			AGAL.mov("oc", ftA);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_Text[kk]=Context.createProgram();
			m_Shader_Text[kk].upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Text[kk]);
	}

	public static function ShaderHalo(forplanet:Boolean):void
	{
		var kk:int = 0;
		if (forplanet) kk |= 1;
		if (m_Shader_State == (0x20000 | kk)) return;
		m_Shader_State = 0x20000 | kk;
		
		m_Shader_TextureMask = 1 << 0;
		
		if (m_Shader_Halo[kk] == null) {
			// Const
			var vcWorldViewProj:String = "vc0";
			var vcConstBase:String = "vc4"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcFactor:String = "vc5"; // x=a y=aaa z=r w=size_outer

			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var fcConstShadow:String = "fc1"; // x=0.1 y=1.0/0.4 z=0.5 w=10.0  - if forplanet
			var fcLight:String = "fc2";
			var fcView:String = "fc3";

			var fcClr:String = "fc4";
			var fcColorAmbient:String = "fc5";
			var fcColorDiffuse:String = "fc6";
			var fcColorReflection:String = "fc7";
			var fcColorShadow:String = "fc8";
			var fcGamma:String = "fc9";

			// Var
			var texDif:String = "fs0";

			var vPos:String = "va0";
			//var vNormal:String = "va1";
			var vTexCoord:String = "va1";
			
			var vtA:String = "vt0";
			var vtB:String = "vt1";

			var iTexCoord:String = "v0";
			//var iClr:String = "v1";
			var iNormal:String = "v1";

			var ftOut:String = "ft0";
			var ftClr:String = "ft1";
			var ftA:String = "ft4";
			var ftB:String = "ft3";
			var ftL:String = "ft2";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.mul(vtB + ".x", vPos + ".w", vcFactor + ".w");
			AGAL.add(vtB + ".x", vtB + ".x", vcFactor + ".z"); // r

			AGAL.mul(vtA + ".x", vcFactor + ".y", vPos+".z");
			AGAL.sub(vtA + ".x", vcFactor + ".x", vtA + ".x"); // a2 = a - aaa * a2;
			AGAL.sin(vtA + ".y", vtA + ".x");
			AGAL.cos(vtA + ".z", vtA + ".x");
			AGAL.mov(vtA + ".x", vtA + ".y"); // ny ny nz
			AGAL.mul(vtA + ".xy", vtA + ".xy", vPos + ".xy"); // normal xyz
			if (forplanet) {
				AGAL.mov(iNormal + ".xyz", vtA + ".xyz");
				AGAL.mov(iNormal + ".w", vcConstBase + ".x");
			}
			AGAL.mul(vtA + ".xyz", vtA + ".xyz", vtB + ".xxx");
			AGAL.mov(vtA + ".w", vcConstBase + ".z"); // Pos xyzw

			AGAL.m44(vtA, vtA, vcWorldViewProj);
			AGAL.mov("op", vtA);
			//AGAL.mov(vtA, vNormal);
			AGAL.mov(iTexCoord + ".xy", vTexCoord + ".xy");
			AGAL.mov(iTexCoord + ".zw", vcConstBase + ".xx");

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			if(!forplanet) {
				AGAL.tex(ftClr, iTexCoord, texDif, "2d", "clamp", "linear,miplinear,0.0"); //"nearest linear nomip miplinear,0.0");
				AGAL.mul(ftOut, ftClr, fcClr);
//				AGAL.mov(ftA, vcMulClr);
			} else {
				AGAL.mov(ftClr, fcClr);

				// Light
				AGAL.dp3(ftL, fcLight, iNormal);
				AGAL.sat(ftL, ftL);

				// Shadow kof
				AGAL.max(ftL + ".z", ftL + ".z", fcConstShadow + ".x");
				AGAL.min(ftL + ".z", ftL + ".z", fcConstShadow + ".z");
				AGAL.sub(ftL + ".z", ftL + ".z", fcConstShadow + ".x");
				AGAL.mul(ftL + ".z", ftL + ".z", fcConstShadow + ".y");
				AGAL.sub(ftL + ".z", fcConstBase + ".z", ftL + ".z");
				AGAL.mul(ftL + ".z", ftL + ".z", ftL + ".z");

				// View kof - коэффициент не параллельности плоскости к камере. (для уменьшения мерцающих точек на границе)
				AGAL.mov(ftA, fcView);
				AGAL.neg(ftA, ftA);
				//AGAL.dp3(ftL + ".w", ftA + ".xyz", iNormal + ".xyz");
				//AGAL.add(ftL + ".w", ftL + ".w", ftL + ".w");
				//AGAL.sat(ftL + ".w", ftL + ".w");
				AGAL.dp3(ftL + ".w", ftA, iNormal);
				AGAL.add(ftL + ".w", ftL, ftL);
				AGAL.sat(ftL + ".w", ftL);

				// ambient
				AGAL.mul(ftOut, ftClr, fcColorAmbient);

				// diffuse
				AGAL.mul(ftA, ftL + ".xxx", fcColorDiffuse);
				AGAL.mul(ftA, ftA, ftClr);
				AGAL.add(ftOut, ftOut, ftA);

				// reflect
				//AGAL.dp3(ftB + ".x", fcView + ".xyz", iNormal + ".xyz"); // b=view*normal
				//AGAL.mul(ftB + ".xyz", iNormal + ".xyz", ftB + ".x"); // b*=normal
				//AGAL.add(ftB + ".xyz", ftB + ".xyz", ftB + ".xyz"); // b*=2
				//AGAL.sub(ftB + ".xyz", fcView + ".xyz", ftB + ".xyz"); // reflect b=view-b
				AGAL.dp3(ftB, fcView, iNormal); // b=view*normal
				AGAL.mul(ftB + ".xyz", iNormal, ftB + ".x"); // b*=normal
				AGAL.add(ftB + ".xyz", ftB, ftB); // b*=2
				AGAL.sub(ftB + ".xyz", fcView, ftB); // reflect b=view-b

				//AGAL.dp3(ftA, fcLight+".xyz", ftB+".xyz");
				AGAL.dp3(ftA, fcLight, ftB);
				AGAL.sat(ftA, ftA);
				AGAL.pow(ftA + ".x", ftA, fcColorReflection + ".w");
				AGAL.mul(ftA + ".x", ftA, ftL + ".w");

				AGAL.mul(ftA, ftA + ".xxx", fcColorReflection);
				AGAL.add(ftOut, ftOut, ftA);
				//AGAL.mov(ftOut, ftA + ".xxx");
	//AGAL.mov(ftOut, ftL + ".www");

				// Shadow
				//AGAL.sub(ftA + ".xyz", fcColorShadow + ".xyz", ftOut + ".xyz");
				//AGAL.mul(ftA + ".xyz", ftA + ".xyz", ftL + ".zzz");
				//AGAL.mul(ftA + ".xyz", ftA + ".xyz", fcColorShadow + ".www");
				//AGAL.add(ftOut + ".xyz", ftA + ".xyz", ftOut + ".xyz");
				AGAL.sub(ftA + ".xyz", fcColorShadow, ftOut);
				AGAL.mul(ftA + ".xyz", ftA, ftL + ".z");
				AGAL.mul(ftA + ".xyz", ftA, fcColorShadow + ".w");
				AGAL.add(ftOut + ".xyz", ftA, ftOut);

				// Gamma
				//clr=saturate((clr-vGamma.x)*vGamma.y+vGamma.z)+vGamma.w;
				AGAL.sub(ftOut, ftOut, fcGamma + ".xxx");
				AGAL.mul(ftOut, ftOut, fcGamma + ".yyy");
				AGAL.add(ftOut, ftOut, fcGamma + ".zzz");
				AGAL.sat(ftOut, ftOut);
				AGAL.add(ftOut, ftOut, fcGamma + ".www");

				// Alpha
				AGAL.tex(ftClr, iTexCoord, texDif, "2d", "clamp", "linear,miplinear,0.0"); //"nearest linear nomip miplinear,0.0"); clamp, repeat, wrap
				//AGAL.mov(ftOut, ftClr);
				//AGAL.mov(ftOut + ".w", ftClr + ".x");
				//AGAL.mov(ftOut + ".xyzw", ftClr + ".xxxx");
				//AGAL.mov(ftOut + ".xyz", fcConstBase + ".zzz");
				AGAL.mul(ftOut + ".w", ftClr, fcClr);

				//
				AGAL.mul(ftOut + ".xyz", ftOut, ftOut + ".w");
			}

			AGAL.mov("oc", ftOut);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_Halo[kk]=Context.createProgram();
			m_Shader_Halo[kk].upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_Halo[kk]);
	}

	public static function ShaderCircle(contour:Boolean):void
	{
		var kk:int = 0;
		if (contour) kk |= 1;
		if (m_Shader_State == (0x60000 | kk)) return;
		m_Shader_State = 0x60000 | kk;

		m_Shader_TextureMask = 0;

		if (m_Shader_Circle[kk] == null) {
			// Const
			var vcWorldViewProj:String = "vc0";
			var vcConstBase:String = "vc4"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcP0:String = "vc5";
			var vcP1:String = "vc6";
			var vcP2:String = "vc7";
			var vcP3:String = "vc8";

			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var fcRadius:String = "fc1"; // x=start y=start-len z=end w=end-len
			var fcClr:String = "fc2";
			var fcClrContour:String = "fc3";

			// Var
			var vPos:String = "va0";

			var iPos:String = "v0";

			var vtA:String = "vt0";
			var vtB:String = "vt1";

			var ftOut:String = "ft0";
			var ftA:String = "ft3";
			var ftB:String = "ft2";
			var ftC:String = "ft1";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.mul(vtA, vPos+".xxxx", vcP0);
			AGAL.mul(vtB, vPos+".yyyy", vcP1);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".zzzz", vcP2);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".wwww", vcP3);
			AGAL.add(vtA, vtA, vtB);

//			AGAL.mov(iTexCoord + ".xyzw", vtA + ".zwxy");
			AGAL.mov(vtA + ".zw", vcConstBase + ".xz");

			AGAL.mov(iPos, vtA);
			AGAL.m44(vtA, vtA, vcWorldViewProj);
			AGAL.mov("op", vtA);

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			
			AGAL.mov(ftC, iPos + ".xyxy");
			
			AGAL.sub(ftB, ftC, ftC); // ftB==zero
			
			AGAL.sub(ftA, ftC, "fc" + (4 + 0).toString());
			AGAL.mul(ftA, ftA, ftA);
			//AGAL.add(ftB + ".xy", ftA + ".xz", ftA + ".yw");
//for(var zzz:int = 0; zzz < 100; zzz++)
			AGAL.add(ftB + ".x", ftA, ftA + ".y");
			AGAL.add(ftB + ".z", ftA, ftA + ".w");
			//AGAL.mov(ftD, ftA + ".yyww");
			//AGAL.add(ftB, ftA, ftD);
//trace("ShaderCircle00");
			
			var cnt:int = 24;
//			CONFIG::mobil {
//				// на моюильниках больше 12 очеь долго загружает upload. или даже виснет. и вообще не правильно шейдер работает!
//				cnt = 12;
//			}
			for (var i:int = 1; i < cnt; i++) {
//				AGAL.sub(ftA + ".xyzw", iPos + ".xyxy", "fc" + (4 + i).toString() + ".xyzw");
//				AGAL.mul(ftA, ftA, ftA);
//				AGAL.add(ftA + ".xy", ftA + ".xz", ftA + ".yw");
//				AGAL.min(ftB + ".xy", ftB + ".xy", ftA + ".xy");

				AGAL.sub(ftA, ftC, "fc" + (4 + i).toString());
				AGAL.mul(ftA, ftA, ftA);
				//AGAL.add(ftA + ".xy", ftA + ".xz", ftA + ".yw");
				AGAL.add(ftA + ".x", ftA, ftA + ".y");
				AGAL.add(ftA + ".z", ftA, ftA + ".w");
				AGAL.min(ftB, ftB, ftA);
			}
//trace("ShaderCircle01");
			AGAL.mov(ftA, ftB + ".z");
			AGAL.min(ftB, ftB, ftA);
			AGAL.sqt(ftB + ".x", ftB + ".x");
			AGAL.mov(ftB, ftB + ".x");
			//AGAL.min(ftB + ".x", ftB + ".x", ftB + ".y");
			//AGAL.sqt(ftB + ".x", ftB + ".x");

			AGAL.mov(ftOut, fcClr);
			
			if (contour) {
				AGAL.sub(ftA + ".x", ftB, fcRadius + ".x");
				AGAL.mul(ftA + ".x", ftA, fcRadius + ".y");
				AGAL.sat(ftA + ".x", ftA);
				
				AGAL.sub(ftA + ".y", fcRadius + ".z", ftB);
				AGAL.mul(ftA + ".y", ftA, fcRadius + ".w");
				AGAL.sat(ftA + ".y", ftA);
				
				AGAL.mov(ftB, fcClrContour);
				AGAL.sub(ftB, ftB, fcClr);
				AGAL.mul(ftB, ftB, ftA + ".yyy");
				AGAL.add(ftOut, ftB, fcClr);
				
			} else {
//				AGAL.sub(ftA + ".x", ftB + ".x", fcRadius + ".x");
//				AGAL.mul(ftA + ".x", ftA + ".x", fcRadius + ".y");
//				AGAL.sat(ftA + ".x", ftA + ".x");

				AGAL.sub(ftA + ".x", ftB, fcRadius);
				AGAL.mul(ftA + ".x", ftA, fcRadius + ".y");
				AGAL.sat(ftA + ".x", ftA + ".x");
			}
//trace("ShaderCircle02");

			//AGAL.mul(ftOut + ".w", ftOut + ".w", ftA + ".x");
			AGAL.mul(ftOut + ".w", ftOut, ftA + ".x");

//for(var zzz:int = 0; zzz < 100; zzz++)
			AGAL.mov("oc", ftOut);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);
//trace("ShaderCircle03", fa.error);

			// Final
			m_Shader_Circle[kk]=Context.createProgram();
//trace("ShaderCircle04");
			//try {
				m_Shader_Circle[kk].upload(va.agalcode, fa.agalcode);
			//} catch (e:Error) {	trace(e); }

//trace("ShaderCircle05");
		}

		Context.setProgram(m_Shader_Circle[kk]);
	}
	
	public static function ShaderCircleContour():void
	{
		if (m_Shader_State == 4) return;
		m_Shader_State = 4;

		m_Shader_TextureMask = 0;

		if (m_Shader_CircleContour == null) {
			// Const
			var vcWorldViewProj:String = "vc0";
			var vcConstBase:String = "vc4"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcP0:String = "vc5";
			var vcP1:String = "vc6";
			var vcP2:String = "vc7";
			var vcP3:String = "vc8";

			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var fcRadius:String = "fc1"; // x=start y=start-len z=end w=end-len
			var fcClr:String = "fc2";
			var fcClrContour:String = "fc3";

			// Var
			var vPos:String = "va0";

			var iPos:String = "v0";

			var vtA:String = "vt0";
			var vtB:String = "vt1";

			var ftOut:String = "ft0";
			var ftA:String = "ft3";
			var ftB:String = "ft2";
			var ftC:String = "ft1";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.mul(vtA, vPos+".xxxx", vcP0);
			AGAL.mul(vtB, vPos+".yyyy", vcP1);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".zzzz", vcP2);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".wwww", vcP3);
			AGAL.add(vtA, vtA, vtB);

//			AGAL.mov(iTexCoord + ".xyzw", vtA + ".zwxy");
			AGAL.mov(vtA + ".zw", vcConstBase + ".xz");

			AGAL.mov(iPos, vtA);
			AGAL.m44(vtA, vtA, vcWorldViewProj);
			AGAL.mov("op", vtA);

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			
			AGAL.mov(ftC, iPos + ".xyxy");
			
			AGAL.sub(ftB, ftC, ftC); // ftB==zero
			
			AGAL.sub(ftA, ftC, "fc4");
			AGAL.mul(ftA, ftA, ftA);
			AGAL.add(ftB + ".x", ftA, ftA + ".y");
			AGAL.sqt(ftB + ".x", ftB + ".x");
			AGAL.mov(ftB, ftB + ".x");

			AGAL.sub(ftA + ".x", ftB, fcRadius + ".x");
			AGAL.mul(ftA + ".x", ftA, fcRadius + ".y");
			AGAL.sat(ftA + ".x", ftA);
			
			AGAL.sub(ftA + ".y", fcRadius + ".z", ftB);
			AGAL.mul(ftA + ".y", ftA, fcRadius + ".w");
			AGAL.sat(ftA + ".y", ftA);
			
			AGAL.mov(ftB, fcClrContour);
			AGAL.sub(ftB, ftB, fcClr);
			AGAL.mul(ftB, ftB, ftA + ".yyy");
			AGAL.add(ftOut, ftB, fcClr);
				
			AGAL.mul(ftOut + ".w", ftOut, ftA + ".x");
			AGAL.mov("oc", ftOut);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);

			// Final
			m_Shader_CircleContour=Context.createProgram();
			m_Shader_CircleContour.upload(va.agalcode, fa.agalcode);
		}

		Context.setProgram(m_Shader_CircleContour);
	}

	public static function ShaderRedZone():void
	{
		var kk:int = 0;
		if (m_Shader_State == (0x70000 | kk)) return;
		m_Shader_State = 0x70000 | kk;

		m_Shader_TextureMask = 0;

		if (m_Shader_RedZone[kk] == null) {
			// Const
			var vcWorldViewProj:String = "vc0";
			var vcConstBase:String = "vc4"; // x=0.0 y=0.5 z=1.0 w=2.0
			var vcP0:String = "vc5";
			var vcP1:String = "vc6";
			var vcP2:String = "vc7";
			var vcP3:String = "vc8";

			var fcConstBase:String = "fc0"; // x=0.0 y=0.5 z=1.0 w=2.0
			var fcRadius:String = "fc1"; // x=min dist; y=max dist-deadspace; z=max dist+deadspace
			var fcClr:String = "fc2";
			var fcClrContour:String = "fc3";

			// Var
			var vPos:String = "va0";

			var iPos:String = "v0";

			var vtA:String = "vt0";
			var vtB:String = "vt1";

			var ftOut:String = "ft0";
			var ftA:String = "ft3";
			var ftB:String = "ft2";
			var ftC:String = "ft1";

			// Vertex shader ////////////////////////////////////////////////////////////////////////////////////
			AGAL.init();
			AGAL.mul(vtA, vPos+".xxxx", vcP0);
			AGAL.mul(vtB, vPos+".yyyy", vcP1);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".zzzz", vcP2);
			AGAL.add(vtA, vtA, vtB);
			AGAL.mul(vtB, vPos+".wwww", vcP3);
			AGAL.add(vtA, vtA, vtB);

//			AGAL.mov(iTexCoord + ".xyzw", vtA + ".zwxy");
			AGAL.mov(vtA + ".zw", vcConstBase + ".xz");

			AGAL.mov(iPos, vtA);
			AGAL.m44(vtA, vtA, vcWorldViewProj);
			AGAL.mov("op", vtA);

			var va:AGALMiniAssembler = new AGALMiniAssembler();
			va.assemble(flash.display3D.Context3DProgramType.VERTEX, AGAL.code);

			// Fragment shader ///////////////////////////////////////////////////////////////////////////////////
			AGAL.init();

			AGAL.sub(ftA, iPos, "fc4");
			AGAL.mul(ftA, ftA, ftA);
			AGAL.add(ftB, ftA, ftA + ".y");
			AGAL.slt(ftA + ".xz", ftB + ".x", fcRadius);
			AGAL.sge(ftA + ".y", ftB + ".x", fcRadius);
			AGAL.mul(ftA + ".z", ftA, ftA + ".y");
			AGAL.add(ftA + ".x", ftA, ftA + ".z");
//trace("ShaderCircle00");
			
			AGAL.sat(ftA, ftA);
			AGAL.mul(ftOut, fcClr, ftA + ".xxxx");

/*			AGAL.sub(ftA + ".xyzw", iPos + ".xyxy", "fc" + (4 + 0).toString() + ".xyzw");
			AGAL.mul(ftA, ftA, ftA);
			AGAL.add(ftB + ".xy", ftA + ".xz", ftA + ".yw");
			AGAL.slt(ftA + ".xyzw", ftB + ".xyxy", fcRadius + ".xxzz");
			AGAL.sge(ftB + ".xy", ftB + ".xy", fcRadius + ".yy");
			AGAL.mul(ftB + ".xy", ftB + ".xy", ftA + ".zw");
			AGAL.add(ftC + ".xy", ftB + ".xy", ftA + ".xy");
//trace("ShaderCircle00");
			
			var cnt:int = 24;
			CONFIG::mobil {
				// на моюильниках больше 12 очеь долго загружает upload. или даже виснет. и вообще не правильно шейдер работает!
				cnt = 12;
			}
			for (var i:int = 1; i < cnt; i++) {
				AGAL.sub(ftA + ".xyzw", iPos + ".xyxy", "fc" + (4 + i).toString() + ".xyzw");
				AGAL.mul(ftA, ftA, ftA);
				AGAL.add(ftB + ".xy", ftA + ".xz", ftA + ".yw");
				AGAL.slt(ftA + ".xyzw", ftB + ".xyxy", fcRadius + ".xxzz");
				AGAL.sge(ftB + ".xy", ftB + ".xy", fcRadius + ".yy");
				AGAL.mul(ftB + ".xy", ftB + ".xy", ftA + ".zw");
				AGAL.add(ftB + ".xy", ftB + ".xy", ftA + ".xy");
				AGAL.add(ftC + ".xy", ftC + ".xy", ftB + ".xy");
			}
//trace("ShaderCircle01");

			AGAL.add(ftC + ".x", ftC + ".x", ftC + ".y");
			AGAL.sat(ftC + ".x", ftC + ".x");
			AGAL.mul(ftOut, fcClr, ftC + ".xxxx");*/

			AGAL.mov("oc", ftOut);

			var fa:AGALMiniAssembler = new AGALMiniAssembler();
			fa.assemble(flash.display3D.Context3DProgramType.FRAGMENT, AGAL.code);
//trace("ShaderCircle03", fa.error);

			// Final
			m_Shader_RedZone[kk]=Context.createProgram();
//trace("ShaderCircle04");
			try {
				m_Shader_RedZone[kk].upload(va.agalcode, fa.agalcode);
			} catch (e:Error) {	trace(e); }

//trace("ShaderCircle05");
		}

		Context.setProgram(m_Shader_RedZone[kk]);
	}

	public static function VBSimple():void
	{
		var i:int;
		
		if (m_VB_State == 1) return;
		m_VB_State = 1;
		m_VB_Mesh = null;
		m_VB_QuadBatch = null;
		m_VB_Halo = null;

		if(m_VB_Simple==null) {
			m_VB_Simple = Context.createVertexBuffer(4, 5); //x, y, u, v

			m_VB_Simple.uploadFromVector(Vector.<Number>
			([
				0.0, 0.0, 0.9, 0.0, 0.0,
				1.0, 0.0, 0.9, 1.0, 0.0,
				1.0, 1.0, 0.9, 1.0, 1.0,
				0.0, 1.0, 0.9, 0.0, 1.0
				 
//				-1.0, 1.0, 0.0, 1.0,
//				-1.0,-1.0, 0.0, 0.0,
//				 1.0,-1.0, 1.0, 0.0,
//				 1.0, 1.0, 1.0, 1.0
			]), 0, 4);
		}

		Context.setVertexBufferAt(0, m_VB_Simple, 0, Context3DVertexBufferFormat.FLOAT_3); //xyz
		Context.setVertexBufferAt(1, m_VB_Simple, 3, Context3DVertexBufferFormat.FLOAT_2); //uv
		
		for (i = 2; i < m_VB_Cnt; i++) Context.setVertexBufferAt(i, null);
		m_VB_Cnt = 2;
	}
	
	public static function VBImg():void
	{
		var i:int;
		
		if (m_VB_State == 6) return;
		m_VB_State = 6;
		m_VB_Mesh = null;
		m_VB_QuadBatch = null;
		m_VB_Halo = null;

		if(m_VB_Img==null) {
			m_VB_Img = Context.createVertexBuffer(4, 4); //x, y, u, v

			m_VB_Img.uploadFromVector(Vector.<Number>
			([
				1.0, 0.0, 0.0, 0.0,
				0.0, 1.0, 0.0, 0.0,
				0.0, 0.0, 1.0, 0.0,
				0.0, 0.0, 0.0, 1.0
			]), 0, 4);
		}

		Context.setVertexBufferAt(0, m_VB_Img, 0, Context3DVertexBufferFormat.FLOAT_4);

		for (i = 1; i < m_VB_Cnt; i++) Context.setVertexBufferAt(i, null);
		m_VB_Cnt = 1;
	}

	public static function VBRectShadow():void
	{
		var i:int;
		
		if (m_VB_State == 2) return;
		m_VB_State = 2;
		m_VB_Mesh = null;
		m_VB_QuadBatch = null;
		m_VB_Halo = null;

		if(m_VB_RectShadow==null) {
			m_VB_RectShadow = Context.createVertexBuffer(4, 4);
			
			var x1:Number = -1.0;
			var y1:Number = -1.0;
			var x2:Number = 1.0;
			var y2:Number = 1.0;

			m_VB_RectShadow.uploadFromVector(Vector.<Number>
			([
				x1, y1, 0.0, 1.0,
				x2, y1, 0.0, 1.0,
				x2, y2, 0.0, 1.0,
				x1, y2, 0.0, 1.0,
			]), 0, 4);
		}

		Context.setVertexBufferAt(0, m_VB_RectShadow, 0, Context3DVertexBufferFormat.FLOAT_4);
		
		for (i = 1; i < m_VB_Cnt; i++) Context.setVertexBufferAt(i, null);
		m_VB_Cnt = 1;
	}
	
	public static function VBMainTexture():void
	{
		var i:int;

		if (m_VB_State == 5) return;
		m_VB_State = 5;
		m_VB_Mesh = null;
		m_VB_QuadBatch = null;
		m_VB_Halo = null;

		if(m_VB_MainTexture==null) {
			m_VB_MainTexture = Context.createVertexBuffer(4, 4);

			m_VB_MainTexture.uploadFromVector(Vector.<Number>
			([
				1.0, 0.0, 0.0, 0.0,
				0.0, 1.0, 0.0, 0.0,
				0.0, 0.0, 1.0, 0.0,
				0.0, 0.0, 0.0, 1.0,
			]), 0, 4);
		}

		Context.setVertexBufferAt(0, m_VB_MainTexture, 0, Context3DVertexBufferFormat.FLOAT_4);
		
		for (i = 1; i < m_VB_Cnt; i++) Context.setVertexBufferAt(i, null);
		m_VB_Cnt = 1;
	}
	
	public static function VBMesh(mesh:C3DMesh, normal:Boolean = true, tcoord:Boolean = true):void
	{
		var i:int;
		
		if (mesh.m_VB == null) {
			return;
		}
		
		var state:uint = 3;
		if (normal) state |= 1 << 16;
		if (tcoord) state |= 1 << 17;

		if ((m_VB_State == state) && (m_VB_Mesh == mesh)) return;
		m_VB_State = state;
		m_VB_Mesh = mesh;
		m_VB_QuadBatch = null;
		m_VB_Halo = null;

		var s:int = 0;
		var cnt:int = 0;

		var pt:uint = (m_VB_Mesh.m_Flag & 0x70000) >> 16;
		if (pt == 1) { Context.setVertexBufferAt(cnt, m_VB_Mesh.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); s += 3; cnt++; }
		else if (pt == 2) { Context.setVertexBufferAt(cnt, m_VB_Mesh.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); s += 4; cnt++; }
		else throw Error("C3DMesh.Flag.Position");

		var nt:uint = (m_VB_Mesh.m_Flag & 0x380000) >> 19;
		if (nt == 0) { }
		else if (nt == 1)  {
			if (normal) Context.setVertexBufferAt(cnt, m_VB_Mesh.m_VB, s, Context3DVertexBufferFormat.FLOAT_3);
			else Context.setVertexBufferAt(cnt, null);
			s += 3;
			cnt++;
		}
		else if (nt == 2)  {
			if (normal) Context.setVertexBufferAt(cnt, m_VB_Mesh.m_VB, s, Context3DVertexBufferFormat.FLOAT_4);
			else Context.setVertexBufferAt(cnt, null);
			s += 4;
			cnt++;
		}
		//else if (nt == 3) dpv += 1;
		else throw Error("C3DMesh.Flag.Normal");

		var tt:uint = (m_VB_Mesh.m_Flag & 0x1c00000) >> 22;
		if (tt == 0) { }
		else if (tt == 1) {
			if (tcoord) Context.setVertexBufferAt(cnt, m_VB_Mesh.m_VB, s, Context3DVertexBufferFormat.FLOAT_2);
			else Context.setVertexBufferAt(cnt, null);
			s += 2;
			cnt++;
		}
//		else if (tt == 2) dpv += 2;
		else throw Error("C3DMesh.Flag.Tex");
//trace("VBMesh:", pt, nt, tt, "cnt:", cnt, "s:", s, "tMask:", m_Shader_TextureMask.toString(2));

		for (i = cnt; i < m_VB_Cnt; i++) Context.setVertexBufferAt(i, null);
		m_VB_Cnt = cnt;
	}

	public static function VBQuadBatch(qb:C3DQuadBatch, normal:Boolean = true, tcoord:Boolean = true, clr:Boolean = true, dir:Boolean = true):void
	{
		var i:int;

		var state:uint = 4;
		if (normal) state |= 1 << 16;
		if (tcoord) state |= 1 << 17;
		if (clr) state |= 1 << 18;
		if (dir) state |= 1 << 19;

		if (m_VB_State == state && m_VB_QuadBatch==qb) return;
		m_VB_State = state;
		m_VB_Mesh = null;
		m_VB_QuadBatch = qb;
		m_VB_Halo = null;

		if (m_VB_QuadBatch.m_VB == null) return;

		var s:int = 0;
		var cnt:int = 0;

		if (qb.m_Pos == 1) { Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_1); s += 1; cnt++; } 
		else if (qb.m_Pos == 2) { Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_2); s += 2; cnt++; } 
		else if (qb.m_Pos == 3) { Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); s += 3; cnt++; } 
		else if (qb.m_Pos == 4) { Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); s += 4; cnt++; }

		if (qb.m_Normal == 1) { if (normal) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_1); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_Normal == 2) { if (normal) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_2); else Context.setVertexBufferAt(cnt, null); s += 2; cnt++; }
		else if (qb.m_Normal == 3) { if (normal) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); else Context.setVertexBufferAt(cnt, null); s += 3; cnt++; }
		else if (qb.m_Normal == 4) { if (normal) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); else Context.setVertexBufferAt(cnt, null); s += 4; cnt++; }

		if (qb.m_UV == 1) { if (tcoord) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_1); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_UV == 2) { if (tcoord) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_2); else Context.setVertexBufferAt(cnt, null); s += 2; cnt++; }
		else if (qb.m_UV == 3) { if (tcoord) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); else Context.setVertexBufferAt(cnt, null); s += 3; cnt++; }
		else if (qb.m_UV == 4) { if (tcoord) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); else Context.setVertexBufferAt(cnt, null); s += 4; cnt++; }

		if (qb.m_Clr == -1) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.BYTES_4); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_Clr == 1) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_1); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_Clr == 2) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_2); else Context.setVertexBufferAt(cnt, null); s += 2; cnt++; }
		else if (qb.m_Clr == 3) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); else Context.setVertexBufferAt(cnt, null); s += 3; cnt++; }
		else if (qb.m_Clr == 4) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); else Context.setVertexBufferAt(cnt, null); s += 4; cnt++; }

		if (qb.m_Dir == 1) { if (dir) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_1); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_Dir == 2) { if (dir) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_2); else Context.setVertexBufferAt(cnt, null); s += 2; cnt++; }
		else if (qb.m_Dir == 3) { if (dir) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); else Context.setVertexBufferAt(cnt, null); s += 3; cnt++; }
		else if (qb.m_Dir == 4) { if (dir) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); else Context.setVertexBufferAt(cnt, null); s += 4; cnt++; }

		if (qb.m_A == -1) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.BYTES_4); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_A == 1) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_1); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_A == 2) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_2); else Context.setVertexBufferAt(cnt, null); s += 2; cnt++; }
		else if (qb.m_A == 3) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); else Context.setVertexBufferAt(cnt, null); s += 3; cnt++; }
		else if (qb.m_A == 4) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); else Context.setVertexBufferAt(cnt, null); s += 4; cnt++; }

		if (qb.m_B == -1) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.BYTES_4); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_B == 1) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_1); else Context.setVertexBufferAt(cnt, null); s += 1; cnt++; }
		else if (qb.m_B == 2) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_2); else Context.setVertexBufferAt(cnt, null); s += 2; cnt++; }
		else if (qb.m_B == 3) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); else Context.setVertexBufferAt(cnt, null); s += 3; cnt++; }
		else if (qb.m_B == 4) { if (clr) Context.setVertexBufferAt(cnt, m_VB_QuadBatch.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); else Context.setVertexBufferAt(cnt, null); s += 4; cnt++; }

		if (s != qb.m_Stride) throw Error("VBQuadBatch.Stide");

		for (i = cnt; i < m_VB_Cnt; i++) Context.setVertexBufferAt(i, null);
		m_VB_Cnt = cnt;
	}

	public static function VBHalo(halo:C3DHalo):void
	{
		var i:int;

		if (halo.m_VB == null) return;

		if (m_VB_State == 5 && m_VB_Halo == halo) return;
		m_VB_State = 5;
		m_VB_Mesh = null;
		m_VB_QuadBatch = null;
		m_VB_Halo = halo;

		var s:int = 0;
		var cnt:int = 0;

		Context.setVertexBufferAt(cnt, m_VB_Halo.m_VB, s, Context3DVertexBufferFormat.FLOAT_4); s += 4; cnt++;
//		Context.setVertexBufferAt(cnt, m_VB_Halo.m_VB, s, Context3DVertexBufferFormat.FLOAT_3); s += 3; cnt++;
		Context.setVertexBufferAt(cnt, m_VB_Halo.m_VB, s, Context3DVertexBufferFormat.FLOAT_2); s += 2; cnt++;

		for (i = cnt; i < m_VB_Cnt; i++) Context.setVertexBufferAt(i, null);
		m_VB_Cnt = cnt;
	}

	public static function SetTexture(sampler:int, t:Texture):void
	{
		Context.setTextureAt(sampler, t);
	}

	public static function FrameBegin(clear:Boolean = true):void
	{
		if (clear) Context.clear(0.0, 0, 0, 0, 1.0, 0);

		Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		Context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
		Context.setColorMask(true, true, true, false);
	}

	public static function FrameEnd():void
	{
		Context.present();
	}

	public static function SetVConst_n(reg:int, x:Number, y:Number, z:Number, w:Number):void
	{
		m_VConstSet[0] = x;
		m_VConstSet[1] = y;
		m_VConstSet[2] = z;
		m_VConstSet[3] = w;
		Context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, reg, m_VConstSet, 1);
	}

	public static function SetVConst(reg:int, v:Vector3D):void
	{
		var i:int = reg << 2;;
		m_VConstSet[0] = v.x;
		m_VConstSet[1] = v.y;
		m_VConstSet[2] = v.z;
		m_VConstSet[3] = v.w;
		Context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, reg, m_VConstSet, 1);
	}

	public static function SetVConstMatrix(reg:int, mvp:Matrix3D):void
	{
		Context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, reg, mvp, true);
	}
	
	public static function SetFConst_n(reg:int, x:Number, y:Number, z:Number, w:Number):void
	{
		m_FConstSet[0] = x;
		m_FConstSet[1] = y;
		m_FConstSet[2] = z;
		m_FConstSet[3] = w;
		Context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, reg, m_FConstSet, 1);
	}

	public static function SetFConst(reg:int, v:Vector3D):void
	{
		var i:int = reg << 2;;
		m_FConstSet[0] = v.x;
		m_FConstSet[1] = v.y;
		m_FConstSet[2] = v.z;
		m_FConstSet[3] = v.w;
		Context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, reg, m_FConstSet, 1);
	}

	public static function SetFConst_Color(reg:int, clr:uint, mul:Number = 1.0, mula:Number = 1.0):void
	{
		var i:int = reg << 2;
		m_FConstSet[0] = mul * Number((clr >> 16) & 255) / 255;
		m_FConstSet[1] = mul * Number((clr >> 8) & 255) / 255;
		m_FConstSet[2] = mul * Number((clr >> 0) & 255) / 255;
		m_FConstSet[3] = mula * Number((clr >> 24) & 255) / 255;

		Context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, reg, m_FConstSet, 1);
	}
	
	public static function SetFConst_Gamma(reg:int, g:uint):void
	{
		m_FConstSet[0] = BaseMath.C2Rn((g >> 0) & 255, 0, 240, -2, 2);
		m_FConstSet[1] = BaseMath.C2Rn((g >> 8) & 255, 0, 240, -2, 2);
		m_FConstSet[2] = BaseMath.C2Rn((g >> 16) & 255, 0, 240, -2, 2);
		m_FConstSet[3] = BaseMath.C2Rn((g >> 24) & 255, 0, 240, -2, 2);
		Context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, reg, m_FConstSet, 1);
	}
	
	public static function SetFConst_TransformAlpha(reg:int, g:uint):void
	{
		m_FConstSet[0] = BaseMath.C2Rn((g >> 0) & 255, 0, 240, -2, 2);
		m_FConstSet[1] = BaseMath.C2Rn((g >> 8) & 255, 0, 240, -2, 2);
		m_FConstSet[2] = BaseMath.C2Rn((g >> 16) & 255, 0, 240, -2, 2);
		m_FConstSet[3] = BaseMath.C2Rn((g >> 24) & 255, 0, 240, -2, 2);
		Context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, reg, m_FConstSet, 1);
	}

	public static function DrawQuad():void
	{
		if (m_IB_Quad == null) {
			m_IB_Quad = Context.createIndexBuffer(6);
			m_IB_Quad.uploadFromVector(Vector.<uint>([0, 1, 2, 0, 2, 3]), 0, 6);
		}
		//Context.enableErrorChecking = false;
		Context.drawTriangles(m_IB_Quad, 0, 2);
	}

	public static function DrawMesh():void
	{
		if (m_VB_Mesh == null) return;
		if (m_VB_Mesh.m_IB == null) return;

		Context.drawTriangles(m_VB_Mesh.m_IB, 0);// , m_VB_Mesh.m_IndexCnt / 3);
	}

	public static function DrawQuadBatch(from:int = 0, cnt:int = -1):void
	{
		if (m_VB_QuadBatch == null) return;
		if (m_VB_QuadBatch.m_DrawCnt <= 0) return;
		if (m_VB_QuadBatch.m_DrawCnt==1) {
			DrawQuad();
			return;
		}

		if (from < 0) from = 0;
		if (from >= m_VB_QuadBatch.m_DrawCnt) from = m_VB_QuadBatch.m_DrawCnt - 1;
		if (cnt < 0) cnt = m_VB_QuadBatch.m_DrawCnt - from;
		if (from + cnt > m_VB_QuadBatch.m_DrawCnt) cnt = m_VB_QuadBatch.m_DrawCnt - from;

		if (m_VB_QuadBatch.m_IB != null) Context.drawTriangles(m_VB_QuadBatch.m_IB, from * 6, cnt * 2/*m_VB_QuadBatch.m_DrawCnt * 2*/);
	}
	
	public static function DrawImgSimple(tex:Texture, premul_alpha:Boolean, clr:uint, des_x:Number, des_y:Number, des_width:Number, des_height:Number, u1:Number = 0, v1:Number = 0, u2:Number = 1, v2:Number = 1):void
	{
		if (tex == null) return;

		var wps:Number = 2.0 / Number(m_SizeX);
		var hps:Number = 2.0 / Number(m_SizeY);

		var x0:Number = (des_x - 0.5 * C3D.m_SizeX) * wps;
		var y0:Number = -(des_y - 0.5 * C3D.m_SizeY) * hps;
		var x1:Number = x0 + wps * des_width;
		var y1:Number = y0 - hps * des_height;

		C3D.SetFConst_n(1, ClrToFloat * ((clr >> 16) & 255), ClrToFloat * ((clr >> 8) & 255), ClrToFloat * ((clr) & 255), ClrToFloat * ((clr >> 24) & 255));

		C3D.SetTexture(0, tex);

		C3D.VBImg();
		C3D.ShaderImg(premul_alpha);

		C3D.SetVConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);

		C3D.SetVConst_n(1, x0, y0, u1, v1);
		C3D.SetVConst_n(2, x1, y0, u2, v1);
		C3D.SetVConst_n(3, x1, y1, u2, v2);
		C3D.SetVConst_n(4, x0, y1, u1, v2);

		C3D.DrawQuad();

		C3D.SetTexture(0, null);
	}

	public static function DrawImg(tex:C3DTexture, clr:uint, des_x:Number, des_y:Number, des_width:Number, des_height:Number, src_x:int, src_y:int, src_width:int, src_height:int):void
	{
		if (tex == null) return;
		if (tex.tex == null) return;

		var wps:Number = 2.0 / Number(m_SizeX);
		var hps:Number = 2.0 / Number(m_SizeY);

		var x0:Number = (des_x - 0.5 * C3D.m_SizeX) * wps;
		var y0:Number = -(des_y - 0.5 * C3D.m_SizeY) * hps;
		var x1:Number = x0 + wps * des_width;
		var y1:Number = y0 - hps * des_height;

		C3D.SetFConst_n(1, ClrToFloat * ((clr >> 16) & 255), ClrToFloat * ((clr >> 8) & 255), ClrToFloat * ((clr) & 255), ClrToFloat * ((clr >> 24) & 255));

		C3D.SetTexture(0, tex.tex);

		C3D.VBImg();
		C3D.ShaderImg(tex.m_PremulAlpha);

		C3D.SetVConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
		
		wps = 1.0 / tex.m_Width;
		hps = 1.0 / tex.m_Height;

		C3D.SetVConst_n(1, x0, y0, src_x * wps, src_y * hps);
		C3D.SetVConst_n(2, x1, y0, (src_x + src_width) * wps, src_y * hps);
		C3D.SetVConst_n(3, x1, y1, (src_x + src_width) * wps, (src_y + src_height) * hps);
		C3D.SetVConst_n(4, x0, y1, src_x * wps, (src_y + src_height) * hps);

		C3D.DrawQuad();

		C3D.SetTexture(0, null);
	}

	public static function DrawImgRotate(tex:C3DTexture, clr:uint, des_x:Number, des_y:Number, des_width:Number, des_height:Number, des_angle:Number, src_x:int, src_y:int, src_width:int, src_height:int, src_center_x:Number = 0.5, src_center_y:Number = 0.5):void
	{
		if (tex == null) return;
		if (tex.tex == null) return;

		var wps:Number = 2.0 / Number(m_SizeX);
		var hps:Number = 2.0 / Number(m_SizeY);
		
		var tx:Number, ty:Number;
		
		var asin:Number = Math.sin(des_angle);
		var acos:Number = Math.cos(des_angle);
		
		tx = - des_width * src_center_x;
		ty = - des_height * src_center_y;
		var p0x:Number = acos * tx - asin * ty + des_x;
		var p0y:Number = asin * tx + acos * ty + des_y;

		tx = des_width * (1.0 - src_center_x);
		ty = - des_height * src_center_y;
		var p1x:Number = acos * tx - asin * ty + des_x;
		var p1y:Number = asin * tx + acos * ty + des_y;

		tx = des_width * (1.0 - src_center_x);
		ty = des_height * (1.0 - src_center_y);
		var p2x:Number = acos * tx - asin * ty + des_x;
		var p2y:Number = asin * tx + acos * ty + des_y;

		tx = - des_width * src_center_x;
		ty = des_height * (1.0 - src_center_y);
		var p3x:Number = acos * tx - asin * ty + des_x;
		var p3y:Number = asin * tx + acos * ty + des_y;

		C3D.SetFConst_n(1, ClrToFloat * ((clr >> 16) & 255), ClrToFloat * ((clr >> 8) & 255), ClrToFloat * ((clr) & 255), ClrToFloat * ((clr >> 24) & 255));

		C3D.SetTexture(0, tex.tex);

		C3D.VBImg();
		C3D.ShaderImg(tex.m_PremulAlpha);

		C3D.SetVConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);

		p0x = (p0x - 0.5 * C3D.m_SizeX) * wps; p0y = -(p0y - 0.5 * C3D.m_SizeY) * hps;
		p1x = (p1x - 0.5 * C3D.m_SizeX) * wps; p1y = -(p1y - 0.5 * C3D.m_SizeY) * hps;
		p2x = (p2x - 0.5 * C3D.m_SizeX) * wps; p2y = -(p2y - 0.5 * C3D.m_SizeY) * hps;
		p3x = (p3x - 0.5 * C3D.m_SizeX) * wps; p3y = -(p3y - 0.5 * C3D.m_SizeY) * hps;

		wps = 1.0 / tex.m_Width;
		hps = 1.0 / tex.m_Height;

		C3D.SetVConst_n(1, p0x, p0y, src_x * wps, src_y * hps);
		C3D.SetVConst_n(2, p1x, p1y, (src_x + src_width) * wps, src_y * hps);
		C3D.SetVConst_n(3, p2x, p2y, (src_x + src_width) * wps, (src_y + src_height) * hps);
		C3D.SetVConst_n(4, p3x, p3y, src_x * wps, (src_y + src_height) * hps);

		C3D.DrawQuad();

		C3D.SetTexture(0, null);
	}

	public static function DrawHalo(mwvp:Matrix3D, view:Matrix3D, viewinv:Matrix3D, px:Number, py:Number, pz:Number, r:Number, size_inner:Number, size_outer:Number, clr:uint, forplanet:Boolean, poslight:Vector3D = null, posview:Vector3D = null):void
	{
		if (m_Halo == null) {
			m_Halo = new C3DHalo();
		}
		
		var dir:Vector3D = new Vector3D();
		dir.x = viewinv.rawData[3 * 4 + 0] - px;
		dir.y = viewinv.rawData[3 * 4 + 1] - py;
		dir.z = viewinv.rawData[3 * 4 + 2] - pz;
		var d:Number = Math.sqrt(dir.x * dir.x + dir.y * dir.y + dir.z * dir.z);
		dir.w = 0.0;
		dir.normalize();
		
		var v1:Vector3D = new Vector3D(view.rawData[0 * 4 + 0], view.rawData[1 * 4 + 0], view.rawData[2 * 4 + 0], 0.0);
		var v2:Vector3D = null;// new Vector3D();
		v2 = dir.crossProduct(v1);
		v1 = dir.crossProduct(v2);
		v2 = dir.crossProduct(v1);
		
		v1.normalize();
		v2.normalize();
		
		var m:Matrix3D = new Matrix3D(Vector.<Number>
			([
				v1.x, v1.y, v1.z, 0,
				v2.x, v2.y, v2.z, 0,
				dir.x,dir.y,dir.z,0.0,
				0, 0, 0, 1
			]));

		//m.invert();
		//m.identity();
		m.appendTranslation(px, py, pz);
		
		if (forplanet) {
			var mi:Matrix3D = new Matrix3D();
			mi.copyFrom(m);
			mi.invert();

			v1 = mi.deltaTransformVector(poslight);
			v1.w = 0.0;
			v1.normalize();
			C3D.SetFConst(2, v1);

			v1.x = posview.x - px;
			v1.y = posview.y - py;
			v1.z = posview.z - pz;
			v1 = mi.transformVector(v1);
			v1.w = 0.0;
			v1.normalize();
			C3D.SetFConst_n(3, -v1.x, -v1.y, -v1.z, 0.0);
		}

		m.append(mwvp);

		m_Halo.Draw(m, d, r, size_inner, size_outer, clr, forplanet);
	}

	public static function GetTexture(path:String):C3DTexture
	{
		if (m_TextureMap[path] != undefined) {
			return m_TextureMap[path];
		}
		
		var t:C3DTexture = new C3DTexture();
		t.m_Path = path;
		m_TextureMap[path] = t;

		return t;
	}
	
	public static function GetTextureEx(path:String, mod:String):C3DTexture
	{
		var t:C3DTexture;

		if (m_TextureMap[path] != undefined) {
			t = m_TextureMap[path];
			if (t.m_Mod != mod) {
				t.m_Mod = mod;

				if (t.m_Texture != null) {
					t.m_Texture.dispose();
					t.m_Texture = null;
				}
			}
			return t;
		}
		
		t = new C3DTexture();
		t.m_Path = path;
		t.m_Mod = mod;
		m_TextureMap[path] = t;

		return t;
	}

	public static function CreateTextureFromBM(bm:BitmapData, mipmap:Boolean=true):Texture
	{
		var t:Texture = null;
		
/*		if (bm.width == 2048 && bm.height == 1024) {
//			trace("pixel:", bm.getPixel32(200, 550).toString(16));

			var bmt:BitmapData = new BitmapData(bm.width, bm.height, false, 0);
			var x:int, y:int;
			var clr:uint;
			for (y = 0; y < bm.height; y++) {
				for (x = 0; x < bm.height; x++) {
					clr = (bm.getPixel32(x,y) >> 0) & 255;
					bmt.setPixel32(x, y, clr);
				}
			}
			var vbm:Bitmap = new Bitmap();
			vbm.bitmapData = bmt;
			EmpireMap.Self.addChild(vbm);
		}*/

		if (!mipmap) {
			t = Context.createTexture(bm.width, bm.height, Context3DTextureFormat.BGRA, false);
			t.uploadFromBitmapData(bm);

		} else {
			var skiplvl:int=0;
			t = Context.createTexture(bm.width >> skiplvl, bm.height >> skiplvl, Context3DTextureFormat.BGRA, false);
			if(skiplvl==0) t.uploadFromBitmapData(bm);
			//t.uploadFromBitmapData(bm, 1);
			//t.uploadFromBitmapData(bm, 2);
			//t.uploadFromBitmapData(bm, 3);
			//t.uploadFromBitmapData(bm, 4);
			
			if (true) {
				var currentWidth:int  = bm.width  >> 1;
				var currentHeight:int = bm.height >> 1;
				var level:int = 1 - skiplvl;
				var canvas:BitmapData = new BitmapData(currentWidth, currentHeight, bm.transparent, 0);
				var transform:Matrix = new Matrix(.5, 0, 0, .5);
				
				while (currentWidth >= 1 || currentHeight >= 1) {
					canvas.fillRect(new Rectangle(0, 0, currentWidth, currentHeight), 0);
					canvas.draw(bm, transform, null, null, null, true);
					if(level>=0) t.uploadFromBitmapData(canvas, level);
					transform.scale(0.5, 0.5);
					currentWidth  = currentWidth  >> 1;
					currentHeight = currentHeight >> 1;
					level++;
				}
				
				canvas.dispose();
			}
		}

		return t;
	}
	
	public static function CreateTextureFromSprite(sx:int,sy:int,sp:Sprite,offx:Number,offy:Number):Texture
	{
		var bm:BitmapData=new BitmapData(sx,sy,true,0x0);
		var m:Matrix=new Matrix();
		m.identity();

		m.scale(sp.scaleX,sp.scaleY);
		m.translate(offx, offy);

		bm.draw(sp,m);

		var t:Texture = Context.createTexture(bm.width, bm.height, Context3DTextureFormat.BGRA, false);
		t.uploadFromBitmapData(bm);
		return t;
	}
	
	public static function GetFont(name:String):C3DFont
	{
		if (m_FontMap[name] != undefined) {
			return m_FontMap[name];
		}

/*		if (name == "normal") { }
		else if (name == "normal_outline") {}
		else if (name == "small") { }
		else if (name == "small_outline") {}
		else throw Error("");*/

		var tex:C3DTexture = GetTexture("nomipmap~font/" + name + ".png");
		var o:Object = LoadManager.Self.Get("font/" + name + ".txt");
		if (tex == null) return null;
		if (o == null) return null;

		var f:C3DFont = new C3DFont(tex);
		f.ParseFont(o as String);

		LoadManager.Self.Free("font/" + name + ".txt");

		if (f == null) return null;
		m_FontMap[name] = f;
		return f;
	}

	public static function MatrixOrto():Matrix3D
	{
		if (m_MatrixOrto == null) {
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			var n:Number = 0.0;
			var f:Number = 1.0;

			m_MatrixOrto=new Matrix3D(Vector.<Number>
			([
				2/w, 0  ,       0,        0,
				0  , -2/h,       0,        0,
				0  , 0  , 1/(f-n), -n/(f-n),
				0  , 0  ,       0,        1
			]));
		}
		return m_MatrixOrto;
	}
	
	public static function MatrixPerspRH():Matrix3D
	{
		if (m_MatrixPerps == null) {
			var fovY:Number = Math.PI * 0.25;
			var aspect:Number = Number(stage.stageWidth) / stage.stageHeight;
			var ys:Number = Math.cos(fovY / 2)/Math.sin(fovY / 2);// Math.cot(fovY / 2);
			var xs:Number = ys / aspect;
			var n:Number = 1.0;
			var f:Number = 10000.0;
			
			//var pm:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			m_MatrixPerps = new PerspectiveMatrix3D();
			m_MatrixPerps.perspectiveFieldOfViewRH(45.0, aspect, 1.0, 10000.0);
			
			
			//m_MatrixPerps.perspectiveFieldOfViewRH(

/*			m_MatrixPerps=new Matrix3D(Vector.<Number>
			([
				xs , 0  ,       0,        0,
				0  , ys ,       0,        0,
				0  , 0  , f/(n-f), n*f/(n-f),
				0  , 0  ,      -1,        1
			]));*/
//			m_MatrixPerps=new Matrix3D(Vector.<Number>
//			([
//				xs , 0  ,        0,        0,
//				0  , ys ,        0,        0,
//				0  , 0  ,  f/(n-f),       -1,
//				0  , 0  ,n*f/(n-f),        1
//			]));
		//D3DXMatrixPerspectiveFovRH(&(m_Camera.m_Proj),g_CameraFov,float(g_ScreenSizeAA.x)/g_ScreenSizeAA.y, 0.9f, 9000.0f);//m_WP.MinZ, m_WP.MaxZ);
		}
		return m_MatrixPerps;
	}

	public static function CalcMatrixShipOri(out:Matrix3D, angle:Number, pitch:Number, roll:Number):void
	{
		var cosx:Number = Math.cos(pitch);
		var sinx:Number = Math.sin(pitch);

		var cosy:Number = Math.cos(roll);
		var siny:Number = Math.sin(roll);

		var cosz:Number = Math.cos( -angle);
		var sinz:Number = Math.sin( -angle);

		out.identity();

		_m[4*0+0]=cosy*cosz-siny*sinx*sinz;
		_m[4*0+1]=cosy*sinz+siny*sinx*cosz;
		_m[4*0+2]=-siny*cosx;
		_m[4*0+3]=0.0;
		
		_m[4*1+0]=-cosx*sinz;
		_m[4*1+1]=cosx*cosz;
		_m[4*1+2]=sinx;
		_m[4*1+3]=0.0;
		
		_m[4*2+0]=siny*cosz+cosy*sinx*sinz;
		_m[4*2+1]=siny*sinz-cosy*sinx*cosz;
		_m[4*2+2]=cosy*cosx;
		_m[4*2+3]=0.0;

		_m[4 * 3 + 0] = 0.0;
		_m[4 * 3 + 1] = 0.0;
		_m[4 * 3 + 2] = 0.0;
		_m[4 * 3 + 3] = 1.0;
		
		out.copyRawDataFrom(_m, 0);
	}
	
	public static function CalcMatrixShipOriInv(out:Matrix3D, angle:Number, pitch:Number, roll:Number):void
	{
		var cosx:Number = Math.cos(-pitch);
		var sinx:Number = Math.sin(-pitch);

		var cosy:Number = Math.cos(-roll);
		var siny:Number = Math.sin(-roll);

		var cosz:Number = Math.cos(angle);
		var sinz:Number = Math.sin(angle);

		out.identity();

		_m[4*0+0]=cosy*cosz+siny*sinx*sinz;
		_m[4*0+1]=cosx*sinz;
		_m[4*0+2]=-siny*cosz+cosy*sinx*sinz;
		_m[4*0+3]=0.0;
		
		_m[4*1+0]=-cosy*sinz+siny*sinx*cosz;
		_m[4*1+1]=cosx*cosz;
		_m[4*1+2]=siny*sinz+cosy*sinx*cosz;
		_m[4*1+3]=0.0;
		
		_m[4*2+0]=siny*cosx;
		_m[4*2+1]=-sinx;
		_m[4*2+2]=cosy*cosx;
		_m[4*2+3]=0.0;

		_m[4 * 3 + 0] = 0.0;
		_m[4 * 3 + 1] = 0.0;
		_m[4 * 3 + 2] = 0.0;
		_m[4 * 3 + 3] = 1.0;
		
		out.copyRawDataFrom(_m, 0);
	}

	public static function CalcBarrelMatrix(out:Matrix3D, angle:Number, angle2:Number, posx:Number, posy:Number, posz:Number):void
	{
		//mw1.RotateX(*sw->m_Angle2);
		//mw2.Translate(sw->m_BarrelPos);
		//mw3.RotateZ(-(*sw->m_Angle));
		//mw1*mw2*mw3

		// maple
		// rx := array(1 .. 4, 1 .. 4, [[1, 0, 0,0], [0, cos(ax), sin(ax),0], [0, -sin(ax), cos(ax),0], [0,0,0,1]]);
		// ry := array(1 .. 4, 1 .. 4, [[cos(ay), 0, -sin(ay),0], [0, 1, 0,0], [sin(ay), 0, cos(ay),0],[0,0,0,1]]);
		// rz := array(1 .. 4, 1 .. 4, [[cos(az), sin(az), 0,0], [-sin(az), cos(az), 0,0], [0, 0, 1,0],[0,0,0,1]]);
		// tr := array(1 .. 4, 1 .. 4, [[1, 0, 0,0], [0, 1, 0,0], [0, 0, 1,0],[tx,ty,tz,1]]);
		// evalm(`&*`(`&*`(rx, tr), rz));

		angle = -angle;

		var cosx:Number, sinx:Number, cosz:Number, sinz:Number;
		
		cosx = Math.cos(angle2);
		sinx = Math.sin(angle2);

		cosz = Math.cos(angle);
		sinz = Math.sin(angle);

		_m[0 * 4 + 0] = cosz;
		_m[0 * 4 + 1] = sinz;
		_m[0 * 4 + 2] = 0.0;
		_m[0 * 4 + 3] = 0.0;

		_m[1 * 4 + 0] = -cosx * sinz;
		_m[1 * 4 + 1] = cosx * cosz;
		_m[1 * 4 + 2] = sinx;
		_m[1 * 4 + 3] = 0.0;

		_m[2 * 4 + 0] = sinx * sinz;
		_m[2 * 4 + 1] = -sinx * cosz;
		_m[2 * 4 + 2] = cosx;
		_m[2 * 4 + 3] = 0.0;

		_m[3 * 4 + 0] = posx * cosz - posy * sinz;
		_m[3 * 4 + 1] = posx * sinz + posy * cosz;
		_m[3 * 4 + 2] = posz;
		_m[3 * 4 + 3] = 1.0;

		out.copyRawDataFrom(_m, 0);
	}
	

	static public function GammaToStr(g:uint):String
	{
		var str:String = "";
		var g_s:Number = BaseMath.C2Rn((g >> 0) & 255, 0, 240, -2, 2);
		var g_m:Number = BaseMath.C2Rn((g >> 8) & 255, 0, 240, -2, 2);
		var g_a:Number = BaseMath.C2Rn((g >> 16) & 255, 0, 240, -2, 2);
		var g_o:Number = BaseMath.C2Rn((g >> 24) & 255, 0, 240, -2, 2);//3.969

//		if (Math.abs(g_s - 0.5) <= 0.01) g_s = 0.5;
//		if (Math.abs(g_m - 1.0) <= 0.01) g_m = 1.0;
//		if (Math.abs(g_a - 0.5) <= 0.01) g_a = 0.5;
//		if (Math.abs(g_o - 0.0) <= 0.01) g_o = 0.0;

		str = BaseStr.FormatFloat(g_m, 2);
		if ((g_s == g_a) && (g_s != 0.5) && (g_o == 0.0)) {
			str += " " + BaseStr.FormatFloat(g_s, 2);
			
		} else if ((g_s != 0.5 || g_a != 0.5) && g_o == 0.0) {
			str += " " + BaseStr.FormatFloat(g_s, 2);
			str += " " + BaseStr.FormatFloat(g_a, 2);

		} else if (g_s != 0.5 || g_a != 0.5 || g_o != 0.0) {
			str += " " + BaseStr.FormatFloat(g_s, 2);
			str += " " + BaseStr.FormatFloat(g_a, 2);
			str += " " + BaseStr.FormatFloat(g_o, 2);
		}
		
		return str;
	}
	
	static public function GammaFromStr(str:String):uint
	{
		str = BaseStr.Replace(str, "\t", " ");
		str = BaseStr.Replace(str, "\n", " ");
		str = BaseStr.Replace(str, ",", " ");
		str = BaseStr.Replace(str, ";", " ");
		str = BaseStr.Trim(BaseStr.TrimRepeat(str));

		var ar:Array = str.split(" ");
		
		var g_s:Number = 0.5;
		var g_m:Number = 1.0;
		var g_a:Number = 0.5;
		var g_o:Number = 0.0;
		if (ar.length == 1) {
			g_m = Number(ar[0]);

		} else if (ar.length == 2) {
			g_m = Number(ar[0]);
			g_s = g_a = Number(ar[1]);

		} else if (ar.length == 3) {
			g_m = Number(ar[0]);
			g_s = Number(ar[1]);
			g_a = Number(ar[2]);

		} else if (ar.length >= 4) {
			g_m = Number(ar[0]);
			g_s = Number(ar[1]);
			g_a = Number(ar[2]);
			g_o = Number(ar[3]);
		}
		
		var s:uint = Math.round(BaseMath.C2Rn(g_s, -2, 2, 0, 240));
		var m:uint = Math.round(BaseMath.C2Rn(g_m, -2, 2, 0, 240));
		var a:uint = Math.round(BaseMath.C2Rn(g_a, -2, 2, 0, 240));
		var o:uint = Math.round(BaseMath.C2Rn(g_o, -2, 2, 0, 240));
		
		return s | (m << 8) | (a << 16) | (o << 24);
	}	

	static public function TransformAlphaToStr(g:uint):String
	{
		var str:String = "";
		var a:Number = BaseMath.C2Rn((g >> 0) & 255, 0, 240, -2, 2);
		var b:Number = BaseMath.C2Rn((g >> 8) & 255, 0, 240, -2, 2);
		var c:Number = BaseMath.C2Rn((g >> 16) & 255, 0, 240, -2, 2);
		var d:Number = BaseMath.C2Rn((g >> 24) & 255, 0, 240, -2, 2);//3.969

//		if (Math.abs(g_s - 0.5) <= 0.01) g_s = 0.5;
//		if (Math.abs(g_m - 1.0) <= 0.01) g_m = 1.0;
//		if (Math.abs(g_a - 0.5) <= 0.01) g_a = 0.5;
//		if (Math.abs(g_o - 0.0) <= 0.01) g_o = 0.0;

		str = BaseStr.FormatFloat(c, 2);
		str += " " + BaseStr.FormatFloat(b, 2);
		str += " " + BaseStr.FormatFloat(a, 2);
		str += " " + BaseStr.FormatFloat(d, 2);
		
		return str;
	}

	static public function TransformAlphaFromStr(str:String):uint
	{
		str = BaseStr.Replace(str, "\t", " ");
		str = BaseStr.Replace(str, "\n", " ");
		str = BaseStr.Replace(str, ",", " ");
		str = BaseStr.Replace(str, ";", " ");
		str = BaseStr.Trim(BaseStr.TrimRepeat(str));

		var ar:Array = str.split(" ");
		
		var a:Number = 0.0;
		var b:Number = 0.0;
		var c:Number = 0.0;
		var d:Number = 0.0;

		if (ar.length >= 4) {
			a = Number(ar[0]);
			b = Number(ar[1]);
			c = Number(ar[2]);
			d = Number(ar[3]);
		}

		var c1:uint = Math.round(BaseMath.C2Rn(c, -2, 2, 0, 240));
		var c2:uint = Math.round(BaseMath.C2Rn(b, -2, 2, 0, 240));
		var c3:uint = Math.round(BaseMath.C2Rn(a, -2, 2, 0, 240));
		var c4:uint = Math.round(BaseMath.C2Rn(d, -2, 2, 0, 240));

		return c1 | (c2 << 8) | (c3 << 16) | (c4 << 24);
	}	
}

}
