package Engine
{

import Base.BaseStr;
import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.system.*;
import flash.utils.*;

public class LoadManager extends EventDispatcher
{
	public static const DataPath:String = "empire/";

	public static var Self:LoadManager = null;

	public var m_LoadList:Dictionary=new Dictionary();
	public var m_LoadArray:Array = new Array();

	public var m_VerList:Dictionary = new Dictionary();
	
	public function LoadManager()
	{
	}

	public function Free(path:String):void
	{
		if (m_LoadList[path] == undefined) return;
		if (m_LoadList[path] == null) return;

		var obj:Object = m_LoadList[path];
		obj.Path = null;
		obj.Complate = false;
		obj.data = null;
		obj.Loader = null;
		
		m_LoadList[path] = undefined;
	}

	public function GetObj(path:String):Object
	{
		if (C3D.m_FatalError.length > 0) return null;
		if (m_LoadList[path] != undefined) {
			return m_LoadList[path];
		}
		
		var re:URLRequest=null;
		
		var obj:Object = new Object();
		obj.Path = path;
		obj.Complete = false;
		obj.data = null;
		m_LoadList[path] = obj;
		m_LoadArray.push(obj);

		obj.FTxt = (path.indexOf(".txt") > 0) || (path.indexOf(".htm") > 0) || (path.indexOf(".html") > 0) || (path.indexOf(".xml") > 0);
		obj.FGzip = path.indexOf(".gz") > 0;
		obj.FBin = (path.indexOf(".mesh") > 0) || (path.indexOf(".hit") > 0);

		if (obj.FTxt || obj.FGzip || obj.FBin) {
			obj.Loader = new URLLoader();
			if(obj.FGzip || obj.FBin) obj.Loader.dataFormat = URLLoaderDataFormat.BINARY;
			else obj.Loader.dataFormat = URLLoaderDataFormat.TEXT;
			obj.Loader.addEventListener(ProgressEvent.PROGRESS,onPreloaderUpdate);
			obj.Loader.addEventListener(Event.COMPLETE,onPreloaderComplete);
			obj.Loader.addEventListener(IOErrorEvent.IO_ERROR, onPreloaderyError);
			obj.Loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onPreloaderyErrorSec);

			re = new URLRequest(GetFileFromPath(path));
			try {
				obj.Loader.load(re);
			} catch (e:Object) {
				C3D.m_FatalError += "LoadManager.LoadTxt: " + e.toString() + "\n";
				dispatchEvent(new Event("LoadError")); 
			}
			
/*		} else if (path.indexOf(".mesh") > 0 || path.indexOf(".gz") > 0) {
			obj.Loader=new URLLoader();
			obj.Loader.dataFormat = URLLoaderDataFormat.BINARY;
			obj.Loader.addEventListener(ProgressEvent.PROGRESS,onPreloaderUpdate);
			obj.Loader.addEventListener(Event.COMPLETE,onPreloaderComplete);
			obj.Loader.addEventListener(IOErrorEvent.IO_ERROR, onPreloaderyError);
			
			re = new URLRequest(path);
			try {
				obj.Loader.load(re);
			} catch (e:Object) {
				m_FatalError += "LoadManager.LoadTxt: " + e.toString() + "\n";
				dispatchEvent(new Event("LoadError")); 
			}*/

		} else {
			var ctx:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		
			obj.Loader = new Loader();
			obj.Loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onPreloaderUpdate);
			obj.Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPreloaderComplete);
			obj.Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPreloaderyError);
		
			re = new URLRequest(GetFileFromPath(path));
			try {
				obj.Loader.load(re, ctx);
			} catch (e:Object) {
				C3D.m_FatalError += "LoadManager.LoadTxt: " + e.toString() + "\n";
				dispatchEvent(new Event("LoadError")); 
			}
		}

		return obj;
	}

	public function Get(path:String):Object
	{
		var obj:Object = GetObj(path);
		if (obj == null) return null;
		if (!obj.Complete) return null;

		if (obj.data != null) return obj.data;

		if (obj.Loader is Loader) {
			obj.data = obj.Loader.content;
			obj.Loader = null;
			return obj.data;

		} else if (obj.Loader is URLLoader) {
			try {
				var d:Object = (obj.Loader as URLLoader).data;
				if (d is ByteArray) {
					var b:ByteArray = d as ByteArray;
					if (obj.FGzip) {
						b.position = 0;
						var nb:ByteArray = ExtractGzip(b);
						if (nb != null) { b = nb; d = nb; }
					}
					if (obj.FTxt) d = b.readUTFBytes(b.length);
				}
				obj.data = d;
			} catch (e:Object) {
				C3D.m_FatalError += "LoadManager.LoadTxt: " + e.toString() + "\n";
				dispatchEvent(new Event("LoadError")); 
				return null;
			}
			obj.Loader = null;
			return obj.data;
		}

		return null;
	}
	
	private function onPreloaderUpdate(evt:ProgressEvent):void
	{
//trace("LoadManager.Update");
		dispatchEvent(evt);
//		EmpireMap.Self.PreloaderUpdate();
	}

	private function onPreloaderComplete(evt:Event):void
	{
		var i:int;
		var obj:Object;

//trace("LoadManager.Complate");

		for (i = 0; i < m_LoadArray.length; i++) {
			obj = m_LoadArray[i];
			
			if ((obj.Loader is URLLoader) && (obj.Loader as URLLoader)== evt.target) {
				obj.Complete = true;
				break;
			} else if ((obj.Loader is Loader) && obj.Loader.contentLoaderInfo == evt.target) {
				obj.Complete = true;
				break;
			}
		}
		if (i >= m_LoadArray.length) return;

//		EmpireMap.Self.PreloaderComplate(evt);

		dispatchEvent(new Event("Complete")); 
		
//trace("LoadManager.Ok:",obj.Loader.content);
	}

	public function onPreloaderyError(event:IOErrorEvent):void
	{
//EmpireMap.Self.m_FormHint.Show("###LMERROR " + event.toString());
//trace(event.target);
		var i:int;
		var obj:Object;

//trace("LoadManager.Complate");

		C3D.m_FatalError += "LoadManager.Error: " + event.text + "\n";//URL: " + event.target.loaderURL.toString() + "\n";
		
		if (event.target is URLLoader) { }
		else {
			for (i = 0; i < m_LoadArray.length; i++) {
				obj = m_LoadArray[i];
				if (obj.Loader == event.target.loader) {
					C3D.m_FatalError += "Path: " + obj.Path + "\n";
					break;
				}
			}
		}

		dispatchEvent(new Event("LoadError")); 
	}

	public function onPreloaderyErrorSec(event:SecurityErrorEvent):void
	{
//EmpireMap.Self.m_FormHint.Show("###LMERRORSEC "+event.toString());
		C3D.m_FatalError += "LoadManager.ErrorSecurity: " + event.text + "\n";
		dispatchEvent(new Event("LoadError")); 
	}
	
	public static function ExtractGzip(src:ByteArray):ByteArray
	{
		var len:int;
		
		src.endian = Endian.LITTLE_ENDIAN;
		if ((src.length - src.position) < 10) return null;
		var f:uint = src.readUnsignedInt();
		if ((f & 0xffffff) != 0x88b1f) return null;
		f >>= 24;
		
		src.readUnsignedInt(); // MTIME
		src.readUnsignedByte(); // XFL
		src.readUnsignedByte(); // OS
		
		if (f & (1 << 2)) { // FEXTRA
			len = src.readUnsignedShort();
			src.position = src.position + len;
		}
		
		if (f & (1 << 3)) { // FNAME
			len = 0;
			while (src.readUnsignedByte() != 0) len++;
			len++;
			src.position = src.position - len;
			var name:String = src.readUTFBytes(len);
		}
		
		if (f & (1 << 4)) { // FCOMMENT
			len = 0;
			while (src.readUnsignedByte() != 0) len++;
			len++;
		}

		if (f & (1 << 1)) { // FHCRC
			return null;
		}
		
		var out:ByteArray = new ByteArray();
		src.readBytes(out);// , src.position, src.length - src.position);
		//out.inflate();
		out.uncompress(CompressionAlgorithm.DEFLATE);

		return out;
	}
	
	public function GetFileFromPath(path:String):String
	{
		if (m_VerList[path] == undefined) return DataPath + path;
		
		var str:String = m_VerList[path];
		var end:int = str.indexOf(",");
		if (end <= 0) return DataPath + path;

		return DataPath + path + "?ver=" + str.substr(0, end);
	}
	
	public function ParseVer(src:String):void
	{
		var ar:Array = src.split("\n");
		var i:int;
		for (i = 0; i < ar.length; i++) {
			var str:String = BaseStr.Trim(ar[i]);
			if (str.length <= 2) continue;
			if (str.substr(0, 2) == '//') continue;
			
			var endname:int = str.indexOf("=");
			if (endname <= 0) continue;
			
			var name:String = BaseStr.Trim(str.substr(0, endname));
			if (name.length <= 0) continue;
			
			str = BaseStr.Trim(str.substr(endname + 1));
			if (str.length <= 0) continue;
			
			m_VerList[name] = str;
		}
	}
}
	
}