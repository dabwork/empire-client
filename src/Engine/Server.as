// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{

import Base.BaseStr;
import flash.events.*;
import flash.net.*;
import flash.utils.*;

public class Server extends EventDispatcher
{
	public static var Self:Server=null;

	static public const LANG_ENG:int=1;
	static public const LANG_RUS:int=2;
	static public const LangSysName:Array = ["", "ENG", "RUS"]

	static public const ErrorNone:uint=0;
	static public const ErrorNoAccess:uint=1;
	static public const ErrorIncorectVersion:uint=2;
	static public const ErrorData:uint=3;
	static public const ErrorLockIp:uint=4;
	static public const ErrorNoReady:uint=5;
	static public const ErrorSystem:uint=6;
	static public const ErrorExitTimeout:uint=7;
	static public const ErrorExistName:uint=8;
	static public const ErrorExistNameEng:uint=9;
	static public const ErrorNoEnoughEGM:uint=10;
	static public const ErrorNotFound:uint=11;
	static public const ErrorImgFormat:uint=12;
	static public const ErrorImgSize:uint=13;
	static public const ErrorText:uint=14;
	static public const ErrorOverload:uint=15;
	static public const ErrorExist:uint=16;
	static public const ErrorTag:uint=17;
	static public const ErrorBan:uint = 18;
	static public const ErrorNoEnoughMoney:uint = 19;
	static public const ErrorNoEnoughRes:uint = 20;
	static public const ErrorNoHomeworld:uint = 21;
	static public const ErrorProtocol:uint = 22;
	static public const ErrorInDevelopment:uint = 23;

	static public const sqFirst:uint=10000;
	static public const sqSector:uint=10001;
	static public const sqSUser:uint=10002;
	static public const sqUser:uint=10003;
	static public const sqCpt:uint=10004;
	static public const sqZoneS:uint=10005;
	static public const sqZoneD:uint=10006;
	static public const sqChatMsgGet:uint = 10007;
	static public const sqSpaceD:uint = 10008;
	static public const sqGv:uint = 10009;

//	public var m_ServerAdr:String="http://www.elementalgames.com:8888/";
//	public var m_ServerAdr:String="http://217.112.36.172:7777/";
	public var m_ServerAdr:String = "";// "http://217.112.36.172:8889/";
//	public var m_ServerAdr:String="http://217.112.36.171:80/";
//	public var m_ServerAdr:String="http://217.112.36.172:9999/";
	public var m_ServerNum:int = 0;
	public var m_ServerEnterKey:String = '';
	public var m_HyperserverServerAdr:String = '';
	public var m_SpaceServerAdr:String = '';

	public var m_LocalChatName:String="";//Empire.Andromeda";

	public var m_Anm:uint = 2;

	public var m_NoCacheStr:String="";
	public var m_NoCacheNo:int=0;
	
	public var m_ConnNo:int=0;
	public var m_ServerKey:int=-1;
	public var m_ClearCnt:int=-1;

	public var m_Lang:int = LANG_RUS;

	public var m_UserId:uint=0;
	public var m_CotlId:uint=0;
	public var m_Session:String="";

	public var m_IsConnect:Boolean=false;
	
	public var m_ErrCnt:int=0;
	
	public var m_QuerySend:Array=new Array();
	public var m_QueryWaitAnswer:Dictionary=new Dictionary(true);
	
	public var m_WaitAnswer:Boolean=false;
	
	public var m_Timer:Timer=new Timer(1000);
	
	public var m_SendTime:Number=0;
	
	public var m_CommandStatArray:Array=new Array();
	public var m_CommandStat:Dictionary=new Dictionary();
	
	public var m_SocketList:Array = new Array();
	
	static public const ProtocolRaw:uint = 1; // Внутренний протокол.
	static public const ProtocolWebSocket:uint = 2; // Один сокет WebSocket.
	static public const ProtocolSocketHTTP:uint = 3; // Один сокет HTTP.
	static public const ProtocolPostHTTP:uint = 4; // Стандартный HTTP интерфейс. POST запросы. (к сожелению flash блокирует их. и требует нажатие клавиш)
	static public const ProtocolDefaultHTTP:uint = 5; // Стандартный HTTP интерфейс. GET запросы.

	public var m_Protocol:int = ProtocolRaw;

	public function Server()
	{
		var now:Date = new Date();
		m_NoCacheStr=""+now.fullYear+""+now.month+""+now.date+""+now.hours+""+now.minutes+""+now.seconds;
		m_NoCacheNo=0;
		
		m_Timer.start();
		m_Timer.addEventListener("timer",Takt);
	}
	
	public function IsConnect():Boolean
	{
		return m_IsConnect;
	}
	
	public function ConnectAccept(userid:uint, session:String):void
	{
		//if (m_Protocol != ProtocolDefaultHTTP)
		SocketClose();

		m_UserId=userid;
		m_Session=session;
		m_IsConnect=true;
		m_ErrCnt=0;
		m_WaitAnswer = false;
		m_Anm = 2;
	}
	
	public function ConnectClose(sendevent:Boolean = true):void
	{
		m_ConnNo=0;
		m_WaitAnswer=false;
		m_IsConnect=false;
		m_QuerySend.length=0;
		m_QueryWaitAnswer.length=0;
		
		SocketClose();
	
		if(sendevent) dispatchEvent(new Event("ConnectClose"));
	}
	
	public function SocketClose():void
	{
		var i:int;
		for(i=0;i<m_SocketList.length;i++) {
			var ss:ServerSocketEG=m_SocketList[i];
			ss.ConnectClose();
		}
		m_SocketList.length=0;
	}

//var m_ListQuery:String="";
	public function QueryRequest(command:String, val:String, ignore_connect:Boolean=false):URLRequest
	{
		var sadd:String="";
//		if((!ignore_connect) && (m_Session.length>0)) sadd+="&ss="+m_Session;
		if((m_Session.length>0)) sadd+="&ss="+m_Session;

		var adr:String = m_ServerAdr + command + "?nc=" + m_NoCacheStr + "&lang=" + LangSysName[m_Lang] + "&cn=" + m_ConnNo.toString() + "&qn=" + m_NoCacheNo.toString() + "&sn=" + m_ServerNum + sadd + val;
//trace(adr);
		var lr:URLRequest = new URLRequest(adr);
		m_NoCacheNo++;

		return lr;
	}

	public function CommandStat(command:String):Object
	{
		var so:Object=null;
		
		if(m_CommandStat[command]==undefined) {
			so=new Object();
			m_CommandStat[command]=so;
			m_CommandStatArray.push(so);
			so.Command=command;
			so.SendCnt=0;
			so.RecvCnt=0;
			so.SendByte=0;
			so.RecvByte=0;
		} else {
			so=m_CommandStat[command];
		}
		return so;
	}
	
	public function CommandStatPrint():String
	{
		var i:int,u:int;
		var cs:Object;
		var out:String = "";
		
		out += "Protocol: ";
		if (m_Protocol == ProtocolRaw) out += "Raw\n";
		else if (m_Protocol == ProtocolWebSocket) out += "WebSocket\n";
		else if (m_Protocol == ProtocolSocketHTTP) out += "SocketHTTP\n";
		else if (m_Protocol == ProtocolPostHTTP) out += "PostHTTP\n";
		else if (m_Protocol == ProtocolDefaultHTTP) out += "DefaultHTTP\n";
		else out += "Unknown\n";

		for(i=0;i<m_CommandStatArray.length;i++) {
			cs=m_CommandStatArray[i];
			out+=cs.Command+" [Cnt:"+cs.SendCnt.toString()+" "+cs.RecvCnt.toString()+"][Byte:"+cs.SendByte.toString()+" "+cs.RecvByte.toString()+"]\n";
		}
		//out+="QueryWaitAnswer:"+m_QueryWaitAnswer.length.toString()+"\n";
		//out+="QuerySend:"+m_QuerySend.length.toString()+"\n";
		
		var ac:int=0;
		for(i=0;i<m_SocketList.length;i++) {
			var ss:ServerSocketEG;
			var obj:Object;
			ss = m_SocketList[i];

			out += "--- "+ss.m_Adr+":"+ss.m_Port+":"+ss.m_Num+" ("+ss.m_QueryList.length.toString()+") ---\n";

			for(u=0;u<Math.min(10,ss.m_QueryList.length);u++) {
				obj = ss.m_QueryList[u];
				var len:int = 0;
				if (obj.Data != null) len += obj.Data.length;
				out+=obj.Command+" ("+len.toString()+")\n";

				ac++;
				if(ac>=50) { break; }
			}
			if(ac>=50) { break; }
		}
		
		return out;
	}

/*	public function Query(command:String, val:String, fun:Function, recvtxt:Boolean=true, ignore_connect:Boolean=false):int
	{
//if(EmpireMap.Self.m_NetStatOn) return 0;
//if(EmpireMap.Self.m_NetStatOn && command=="emminimap") return 0;
//if(EmpireMap.Self.m_NetStatOn && command=="emsuser") return 0;
//if(EmpireMap.Self.m_NetStatOn && command=="chatmsgget") return 0;
//if(EmpireMap.Self.m_NetStatOn && command=="emmap") return 0;

		if((!ignore_connect) && (!IsConnect())) return 0;

		//var sadd:String="";
		//if((!ignore_connect) && (m_Session.length>0)) sadd+="&ss="+m_Session;

		var cs:Object=CommandStat(command);
		cs.SendCnt++;

		var loader:URLLoader = new URLLoader();
		if(recvtxt) loader.dataFormat = URLLoaderDataFormat.TEXT;
		else loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, QueryOk);
		loader.addEventListener(Event.COMPLETE, fun);
		loader.addEventListener(IOErrorEvent.IO_ERROR, QueryError);
//trace(m_ServerAdr+command+"?nc="+m_NoCacheStr+m_NoCacheNo+"&lang="+Common.LangSysName[m_Lang]+"&sn="+m_ServerNum+sadd+val);

//m_ListQuery+="\n"+m_ServerAdr+command+"?nc="+m_NoCacheStr+m_NoCacheNo+"&lang="+Common.LangSysName[m_Lang]+"&sn="+m_ServerNum+sadd+val
//EmpireMap.Self.m_FormHint.Show(m_ListQuery);

		//var adr:String=m_ServerAdr+command+"?nc="+m_NoCacheStr+"&lang="+Common.LangSysName[m_Lang]+"&cn="+m_ConnNo.toString()+"&qn="+m_NoCacheNo.toString()+"&sn="+m_ServerNum+sadd+val;
//trace(adr);
		//var lr:URLRequest = new URLRequest(adr);
		//m_NoCacheNo++;
		var lr:URLRequest=QueryRequest(command,val,ignore_connect);

//		lr.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
//		if(m_Session.length>0) lr.requestHeaders.push(new URLRequestHeader("SessionIPKey", m_Session));
//		if(m_Session.length>0) lr.requestHeaders.push(new URLRequestHeader("WWW-Authenticate", "SessionIPKey="+m_Session));
///		lr.requestHeaders.push(new URLRequestHeader("SessionIPKey", m_Session));

//		loader.load(lr);

		if(command=="empreconnect" || command=="emconnect" ||
			command=="emmap" ||
			command=="emrel" ||
			command=="emsuser" ||
			command=="empactlist" ||
			command=="emticketlist" ||
			command=="emonlineuser" ||
			command=="chatchlist" ||
			command=="chatmsgget" ||
			command=="emcpt" ||
			command=="emcptdsc" ||
			command=="emrgmap" ||
			command=="emcotl" ||
			command=="emminimap" ||
			command=="emmmowner" ||
			command=="emshipplayer" ||
			command=="emuser" ||
			command=="emunion"
			)
		{
			loader.load(lr);
			//var o:Object=new Object();
			//o.loader=loader;
			//o.lr=lr;
			//m_QueryWaitAnswer.push(o);
			m_QueryWaitAnswer[loader]=lr

		} else {
			var so:Object=new Object();
			so.loader=loader;
			so.lr=lr;
			m_QuerySend.push(so);

			QueryRealSend();
		}

		return m_NoCacheNo-1;
	}*/
	
	public function QuerySmallBuf(queryaction:uint, data:ByteArray):ByteArray
	{
		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;

		var querysize:int=0;
		if(data!=null) querysize=data.length;

		var fb:uint=0xf0;

		if(querysize==0) {}
		else if(querysize<=255) fb|=1;
		else if(querysize<=65535) fb|=2;
		else querysize|=3;

		if(queryaction==0) {}
		else if(queryaction<=255) fb|=1<<2;
		else if(queryaction<=65535) fb|=2<<2;
		else fb|=3<<2;

		ba.writeByte(fb);
//trace("!!!QuerySmall00",fb.toString(2));

		if(querysize==0) {}
		else if(querysize<=255) ba.writeByte(querysize);
		else if(querysize<=65535) ba.writeShort(querysize);
		else ba.writeUnsignedInt(querysize);

		if(queryaction==0) {}
		else if(queryaction<=255) ba.writeByte(queryaction);
		else if(queryaction<=65535) ba.writeShort(queryaction);
		else ba.writeUnsignedInt(queryaction);

		ba.writeShort(0x0a0a);
//trace("!!!QuerySmall01",querysize,queryaction,ba.length);

		if (querysize > 0) ba.writeBytes(data, 0, data.length);
		
		return ba;
	}

	public function QuerySmallHS(command:String, retry:Boolean, queryaction:uint, data:ByteArray, fun:Function):void
	{
		var oldadr:String = m_ServerAdr;
		m_ServerAdr = m_HyperserverServerAdr;
		QuerySmall(command, retry, queryaction, data, fun);
		m_ServerAdr=oldadr;
	}
	
	public function QuerySmallSS(command:String, retry:Boolean, queryaction:uint, data:ByteArray, fun:Function):void
	{
		var oldadr:String = m_ServerAdr;
		m_ServerAdr = m_SpaceServerAdr;
		QuerySmall(command, retry, queryaction, data, fun);
		m_ServerAdr=oldadr;
	}

	public function QuerySmall(command:String, retry:Boolean, queryaction:uint, data:ByteArray, fun:Function):void
	{
		if ((!IsConnect())) return;

		//if (m_Protocol == ProtocolSingleHTTP || m_Protocol == ProtocolMultiHTTP) return QuerySmallHTTP(command, retry, queryaction, data, fun);
		//else if(m_Protocol == ProtocolRaw) {
			var ba:ByteArray=QuerySmallBuf(queryaction, data);

			var cs:Object=CommandStat(command);
			cs.SendCnt++;

			cs.SendByte+=ba.length;

			var ss:ServerSocketEG=SocketGet();
			ss.QueryBin(command, ba, retry, QueryComplate, fun);
			ss.Send();
		//} else {
			//throw Error("QuerySmall: No support protocol.");
		//}
	}

	public function QueryHS(command:String, val:String, fun:Function, recvtxt:Boolean = true, ignore_connect:Boolean = false):int
	{
		var oldadr:String = m_ServerAdr;
		m_ServerAdr = m_HyperserverServerAdr;
		var r:int=Query(command, val, fun, recvtxt, ignore_connect);
		m_ServerAdr = oldadr;
		return r;
	}

	public function QuerySS(command:String, val:String, fun:Function, recvtxt:Boolean = true, ignore_connect:Boolean = false):int
	{
		var oldadr:String = m_ServerAdr;
		m_ServerAdr = m_SpaceServerAdr;
		var r:int=Query(command, val, fun, recvtxt, ignore_connect);
		m_ServerAdr = oldadr;
		return r;
	}

	public function Query(command:String, val:String, fun:Function, recvtxt:Boolean=true, ignore_connect:Boolean=false):int
	{
		if((!ignore_connect) && (!IsConnect())) return 0;

		var cs:Object=CommandStat(command);
		cs.SendCnt++;

		var retry:Boolean=false;
		if(command=="empreconnect" || command=="emconnect" ||
			command=="emtxt" ||
			command=="chatchlist" ||
			command=="chatmsgget" ||
			command=="emcptdsc" ||
			command=="emuser" ||
			command=="emsuser" ||
			command=="emminimap" ||
			command=="emmap" ||
			command=="emrel" ||
			command=="emonlineuser" ||
			command=="emfleet"
			) 
		{
			retry=true;
		}

		var socketno:int = 0;
		if (command == "emminimap") {
			socketno = 1;
		}

		var sadd:String = command + "?nc=" + m_NoCacheStr + "&lang=" + LangSysName[m_Lang] + "&cn=" + m_ConnNo.toString() + "&qn=" + m_NoCacheNo.toString() + "&sn=" + m_ServerNum;
		if ((m_Session.length > 0)) sadd += "&ss=" + m_Session;
		sadd += val;

		var ba:ByteArray=null;

		if (m_Protocol == ProtocolDefaultHTTP) {
			socketno = 1;
		} else {
			ba = new ByteArray();
			
			ba.writeUTFBytes("GET ");
			ba.writeUTFBytes("/"+sadd);
			ba.writeUTFBytes(" HTTP/1.1\n");
			ba.writeUTFBytes("User-Agent: Empire Client\n");
			ba.writeUTFBytes("Host: "+m_ServerAdr+"\n");
			ba.writeUTFBytes("Connection: Keep-Alive\n");
			ba.writeUTFBytes("Cache-Control: no-cache\n");
			ba.writeUTFBytes("\n");
		}

		var ss:ServerSocketEG=SocketGet(socketno);
		var qo:Object = ss.QueryBin(command, ba, retry, QueryComplate, fun, recvtxt);
		if (m_Protocol == ProtocolDefaultHTTP) qo.UrlDefaultHTTP = sadd;
		ss.Send();

		m_NoCacheNo++;
		return m_NoCacheNo-1;
	}
	
	public function QueryRealSend():void
	{
return;
/*		if(m_WaitAnswer) return;
		if(m_QuerySend.length<=0) return;
		
		m_WaitAnswer=true;
		
		var so:Object=m_QuerySend[0];
		m_QuerySend.splice(0,1);
		
		m_SendTime = Common.GetTime();
		
		//var o:Object=new Object();
		//o.loader=so.loader;
		//o.lr=so.lr;
		//m_QueryWaitAnswer.push(o);
		m_QueryWaitAnswer[so.loader]=so.lr;

		so.loader.load(so.lr);
		so.loader=null;
		so.lr=null;*/
	}

	public function CreateBoundary():String
	{
		var b:String="----------";
		for (var i:int = 0; i < 30; i++ ) {
			b += String.fromCharCode( int( 97 + Math.random() * 25 ) );
		}
		return b;
	}

	public function QueryPostHS(command:String, val:String, data:Object, boundary:String, fun:Function, recvtxt:Boolean=true):int
	{
		var oldadr:String = m_ServerAdr;
		m_ServerAdr = m_HyperserverServerAdr;
		var r:int = QueryPost(command, val, data, boundary, fun, recvtxt);
		m_ServerAdr = oldadr;
		return r;
	}

	public function QueryPost(command:String, val:String, data:Object, boundary:String, fun:Function, recvtxt:Boolean=true):int
	{
//if(EmpireMap.Self.m_NetStatOn) return 0;
		if (command != "acentersys" && command != "ementer" && command != "acisfreename" && !IsConnect()) return 0;

		var cs:Object=CommandStat(command);
		cs.SendCnt++;

		var datawrite:ByteArray=null;
		if(data is String) {
			datawrite=new ByteArray();
			datawrite.writeUTFBytes(data as String);
		}
		else if(data is ByteArray) datawrite=data as ByteArray;
		else throw Error("");

		var sadd:String = command + "?nc=" + m_NoCacheStr + "&lang=" + LangSysName[m_Lang] + "&cn=" + m_ConnNo.toString() + "&qn=" + m_NoCacheNo.toString() + "&sn=" + m_ServerNum;
		if (m_Session.length > 0) sadd += "&ss=" + m_Session;
		sadd += val;

		var ba:ByteArray = new ByteArray();

		var socketno:int = 1;

		if (m_Protocol == ProtocolDefaultHTTP) {
			socketno = 2;

			ba.writeBytes(datawrite);
		} else {
			ba.writeUTFBytes("POST ");
			ba.writeUTFBytes("/"+sadd);
			ba.writeUTFBytes(" HTTP/1.1\n");
			ba.writeUTFBytes("User-Agent: Empire Client\n");
			ba.writeUTFBytes("Host: "+m_ServerAdr+"\n");
			ba.writeUTFBytes("Content-Type: multipart/form-data; boundary="+boundary+"\n");
			ba.writeUTFBytes("Content-Length: "+datawrite.length.toString()+"\n");
			ba.writeUTFBytes("Connection: Keep-Alive\n");
			ba.writeUTFBytes("Cache-Control: no-cache\n");
			ba.writeUTFBytes("\n");
			ba.writeBytes(datawrite);
		}

		var ss:ServerSocketEG=SocketGet(socketno,m_Protocol == ProtocolDefaultHTTP);
		var qo:Object=ss.QueryBin(command,ba,false,QueryComplate,fun,recvtxt);
		if (m_Protocol == ProtocolDefaultHTTP) { qo.UrlDefaultHTTP = sadd; qo.Boundary = boundary; qo.PostHTTP = true; }
		ss.Send();

/*		var loader:URLLoader = new URLLoader();
		if(recvtxt) loader.dataFormat = URLLoaderDataFormat.TEXT;
		else loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, QueryOk);
		loader.addEventListener(Event.COMPLETE, fun);
		loader.addEventListener(IOErrorEvent.IO_ERROR, QueryError);
//trace(m_ServerAdr+command+"?nc="+m_NoCacheStr+"&lang="+Common.LangSysName[m_Lang]+"&cn="+m_ConnNo.toString()+"&qn="+m_NoCacheNo.toString()+"&sn="+m_ServerNum+sadd+val);
		var lr:URLRequest = new URLRequest(m_ServerAdr+command+"?nc="+m_NoCacheStr+"&lang="+Common.LangSysName[m_Lang]+"&cn="+m_ConnNo.toString()+"&qn="+m_NoCacheNo.toString()+"&sn="+m_ServerNum+sadd+val);
		lr.data = data;
		lr.method = URLRequestMethod.POST;
		lr.contentType="multipart/form-data; boundary="+boundary;

		loader.load(lr);*/

		m_NoCacheNo++;
		return m_NoCacheNo-1;
	}

	public function QueryComplate(cmd:String, recvsize:int):void
	{
//if(EmpireMap.Self.m_Debug) trace("!!!QueryComplate",cmd,recvsize);
		var cs:Object=CommandStat(cmd);
		cs.RecvCnt++;
		cs.RecvByte+=recvsize;
		
		m_ErrCnt=0;
	}

	public function QueryOk(event:Event):void
	{
		while(event.target is URLLoader) {
			if(m_QueryWaitAnswer[event.target]==undefined) break;
			
			var lr:URLRequest=m_QueryWaitAnswer[event.target];
			m_QueryWaitAnswer[event.target]=undefined;

			delete m_QueryWaitAnswer[event.target];

			//var i:int=m_QueryWaitAnswer.indexOf(event.target);
			//if(i<0) break;
			//var o:Object=m_QueryWaitAnswer[i];
			//m_QueryWaitAnswer.splice(i,1);

			var cmd:String=lr.url;
			var sme:int=m_ServerAdr.length;
			while(sme<cmd.length && cmd.charAt(sme)!='?') sme++;
			if(sme>=cmd.length) break;
			
			cmd=cmd.substring(m_ServerAdr.length,sme);
			if(cmd.length<=0) break; 
			
			var cs:Object=CommandStat(cmd);
			cs.RecvCnt++;
			cs.RecvByte+=(event.target as URLLoader).bytesTotal;

//if(cmd=="emuser") trace(lr.url);
			
			break;
		}
		
		m_WaitAnswer=false;
		m_ErrCnt=0;
		QueryRealSend();
	}

	public function QueryError(event:IOErrorEvent=null, errstr:String=""):Boolean
	{
//trace("!!!QueryError");
		m_WaitAnswer=false;
		m_ErrCnt++;
		if (m_ErrCnt < 5) {
			if(StdMap.Main) StdMap.Main.AddDebugMsg(StdMap.Txt.LostQuery + " (" + m_ErrCnt.toString() + "/10)") + errstr;

			dispatchEvent(new Event("LostQuery"));

			QueryRealSend();

			return true;
		} else {
			if(StdMap.Main) StdMap.Main.Hint(StdMap.Txt.NoServer);
			ConnectClose();
		}
		return false;
	}
	
	public function Takt(event:TimerEvent=null):void
	{
		if (m_QuerySend.length <= 0) return;
		if ((m_SendTime + 5000) > StdMap.Main.m_CurTime) return;

		QueryRealSend();		
	}
	
	public function SocketConnect():void
	{
	}
	
	public function SocketGet(num:int=0, testempty:Boolean=false):ServerSocketEG
	{
		if(m_Protocol==ProtocolRaw || m_Protocol==ProtocolWebSocket) num = 0;

		var i:int;
		var ss:ServerSocketEG;

		var adr:String=m_ServerAdr;
		//if (adr.substr(0, 7).toLocaleLowerCase() == "http://") {
		if (BaseStr.EqNCEng(adr.substr(0, 7), "http://")) {
			adr=adr.substr(7);
		}
		var off:int=adr.search("/");
		if(off>=0) {
			adr=adr.substr(0,off);
		}

		off=adr.search(":");
		if(off<0) throw Error("");

		var port:int=int(adr.substr(off+1));
		adr=adr.substr(0,off);

//		trace(m_ServerAdr,"["+adr+"]",port);

		for(i=0;i<m_SocketList.length;i++) {
			ss=m_SocketList[i];
			if (ss.m_Adr == adr && ss.m_Port == port && ss.m_Num == num && ((!testempty) || (ss.m_QueryList.length <= 0))) {
				if ((m_Session.length > 8) && ss.m_NeedFirstSend) {
					ss.m_NeedFirstSend = false;
					var tb:ByteArray = new ByteArray();
					tb.endian = Endian.LITTLE_ENDIAN;;
					tb.writeUnsignedInt(uint("0x" + m_Session.substr(0, 8)));
					tb.writeUnsignedInt(uint("0x" + m_Session.substr(8)));

					var ba:ByteArray = QuerySmallBuf(sqFirst, tb);

					ss.m_FirstSend = ba;
				}
				return ss;
			}
		}
		ss=new ServerSocketEG();
		ss.m_Adr = adr;
		ss.m_Port = port;
		ss.m_Num = num;
		m_SocketList.push(ss);

//trace("!!!SocketGet","["+ss.m_Adr+"]",ss.m_Port);

		//var sadd:String="";
		//if((m_Session.length>0)) sadd+="&ss="+m_Session;

		//if (!large) ss.m_MaxWait = 15;
		ss.m_MaxWait = 15;
		//if (m_Protocol == ProtocolRaw) ss.m_MaxWait = 15;
		//else if (m_Protocol == ProtocolWebSocket) ss.m_MaxWait = 15;
		//else if (m_Protocol == ProtocolSingleHTTP) ss.m_MaxWait = 15;

		if ((m_Protocol == ProtocolRaw) && (m_Session.length > 8) && ss.m_NeedFirstSend) {
			ss.m_NeedFirstSend = false;
			tb = new ByteArray();
			tb.endian = Endian.LITTLE_ENDIAN;;
//trace("Session:",m_Session);
			tb.writeUnsignedInt(uint("0x" + m_Session.substr(0, 8)));
			tb.writeUnsignedInt(uint("0x" + m_Session.substr(8)));

			ba = QuerySmallBuf(sqFirst, tb);

//			var ba:ByteArray=new ByteArray();
//			ba.writeUTFBytes("GET ");
//			ba.writeUTFBytes("/"+"emconnowner"+"?lang="+Common.LangSysName[m_Lang]+sadd);
//			ba.writeUTFBytes(" HTTP/1.1\n");
//			ba.writeUTFBytes("User-Agent: Empire Client\n");
//			ba.writeUTFBytes("Host: "+m_ServerAdr+"\n");
//			ba.writeUTFBytes("Connection: Keep-Alive\n");
//			ba.writeUTFBytes("Cache-Control: no-cache\n");
//			ba.writeUTFBytes("\n");

			ss.m_FirstSend = ba;
		}

		return ss;
	}
	
	public function IsSendCommand(command:String):Boolean
	{
		var i:int;
		var ss:ServerSocketEG;

		for(i=0;i<m_SocketList.length;i++) {
			ss = m_SocketList[i];
			if (ss.IsSendCommand(command)) return true;
		}
		return false;
	}
}

}
