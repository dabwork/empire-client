package Engine
{
	
import Base.Base64;
import flash.events.*;
import flash.net.*;
import flash.utils.*;

public class ServerSocketEG
{
	public var m_Adr:String="";
	public var m_Port:int = 0;
	public var m_Num:int = 0;
	
	public var m_Ordenum:uint = 0;
	
	public var m_Socket:Socket=null;
	public var m_SocketReady:Boolean=false;
	
	public var m_QueryList:Array=new Array();
	public var m_WaitAnswer:int=0;
	
	public var m_RecvData:ByteArray=new ByteArray();

	public var m_Timer:Timer=new Timer(5);
	public var m_TimerReconnect:Timer = new Timer(1000, 1);
	
	public var m_MaxWait:int = 1;
	
	public var m_NeedFirstSend:Boolean = true;
	
	//public var m_EventList:Array=new Array();
	
	public var m_FirstSend:ByteArray=null;

	public function ServerSocketEG()
	{
		m_RecvData.endian=Endian.LITTLE_ENDIAN;

		m_Timer.addEventListener("timer",Takt);
		m_TimerReconnect.addEventListener("timer",TaktReconnect);
	}
	
	public function get ServerAdr():String
	{
		return "http://" + m_Adr + ":" + m_Port.toString() + "/";
	}
	
	public function Connect():void
	{
		SocketClose();
		m_Timer.start();
		
		if (Server.Self.m_Protocol == Server.ProtocolPostHTTP || Server.Self.m_Protocol == Server.ProtocolDefaultHTTP) {
			connectHandler(null);
		} else {
			m_Socket=new Socket();
			//m_Socket.endian=Endian.LITTLE_ENDIAN;
			m_Socket.addEventListener(Event.CONNECT, connectHandler);
			m_Socket.addEventListener(Event.CLOSE, closeHandler);
			m_Socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			m_Socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			m_Socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			m_Socket.connect(m_Adr, m_Port);
		}
		
//if(EmpireMap.Self.m_Debug) trace("SocketConnect",m_Adr,m_Port);
	}
	
	public function SocketClose():void
	{
		if(m_Socket!=null) {
			//m_Socket.flush();
			if(m_SocketReady) m_Socket.close();
			m_Socket=null;
		}
		m_SocketReady=false;
		//m_EventList.length=0;
	}
	
	public function ConnectClose():void
	{
		SocketClose();
//trace("ConnectClose");
		//m_EventList.length=0;
		m_RecvData.length=0;
		m_QueryList.length=0;
		m_Timer.stop();
		m_TimerReconnect.stop();
	}

	public function Reconnect():Boolean
	{
//if(EmpireMap.Self.m_Debug) trace("SocketReconnect");
		var i:int;
		
		SocketClose();
		m_RecvData.length=0;
		if(m_QueryList.length<=0) return false;
		
		var err:Boolean=false;
		var errstr:String="";
		
		for(i=m_WaitAnswer-1;i>=0;i--) {
			var obj:Object=m_QueryList[i];
			if(obj.Retry) continue;
			
			obj.Data=null;
			obj.FunComplate=null;
			obj.Fun=null;
			m_QueryList.splice(i,1);
			
			m_WaitAnswer--;
			err=true;
			errstr=" C:"+obj.Command;
		}
		
		if(m_WaitAnswer<0 || m_WaitAnswer>m_QueryList.length) throw Error("SS Reconnect"+m_WaitAnswer.toString());
		m_WaitAnswer=0;
		
		if(!err || Server.Self.QueryError(null,errstr)) Connect();

		return err;
	}

	public function TaktReconnect(event:TimerEvent=null):void
	{
		Reconnect();
	}

	private function connectHandler(event:Event):void
	{
//if(EmpireMap.Self.m_Debug) trace("SocketConnectComplate",m_SocketReady);
		if (!m_Timer.running) return; // Значит закрыли сокет до того как установили соединение
		m_SocketReady=true;

		if(m_FirstSend!=null) {
			SendCancel("emconnowner");

			var obj:Object=new Object();
			obj.Command="emconnowner";
			obj.Data=m_FirstSend;
			obj.FunComplate=null;
			obj.Fun = null;// RecvConnOwner;
			obj.Retry = false;
			obj.RecvTxt = false;

			m_QueryList.splice(0,0,obj);
		}

		SendQuery();
	}

/*	private function RecvConnOwner(errcode:uint, buf:ByteArray):void
	{
		if (buf != null && (buf.length - buf.position) >= 4) {
			m_Ordenum = buf.readUnsignedInt();
		}
	}*/

	private function closeHandler(event:Event):void
	{
//if(EmpireMap.Self.m_Debug) trace("SocketClose",m_Adr,m_Port);

		m_SocketReady=false;
		//socketDataHandler();

		m_TimerReconnect.stop();
		m_TimerReconnect.start();

//		m_Timer.stop();
//		Reconnect();
	}

	private function ioErrorHandler(event:IOErrorEvent):void
	{
//if(EmpireMap.Self.m_Debug) trace("SocketError",m_Adr,m_Port);

		m_Timer.stop();
		if(Server.Self.QueryError()) Reconnect();
	}
	
	private function securityErrorHandler(event:SecurityErrorEvent):void
	{
//if(EmpireMap.Self.m_Debug) trace("SocketErrorSecurity",m_Adr,m_Port);

		m_Timer.stop();
		//EmpireMap.Self.ErrorFromServer(Server.ErrorData,"SS SEH");
		if(Server.Self.QueryError()) Reconnect();
	}

	public function Takt(event:TimerEvent=null):void
	{
//if(EmpireMap.Self.m_Debug) trace("SS: QueryCnt",m_QueryList.length,"WaitAnswer:",m_WaitAnswer,"RecvData:",m_RecvData.length,"Socket",m_Socket,m_SocketReady);
		//socketDataHandler();
		ProcessRecvData();
		SendQuery();		
	}
	
	static public function ByteArrayToString(ba:ByteArray):String
	{
		var i:int;
		var oldp:uint=ba.position;
		ba.position=0;
		var str:String="";
		for(i=0;i<ba.length;i++) {
			str+=" "+ba.readUnsignedByte().toString(16);
		}
		ba.position=oldp;
		return str;
	}

	public function SendQuery():void
	{
		var i:int, u:int, cnt:int;
		var obj:Object;
		var sadd:String, boundary:String, strbegin:String, strend:String;
		var loader:URLLoader;
		var lr:URLRequest;
		var ba:ByteArray;
//trace("SocketSendQuery00");
		//if(m_WaitAnswer) return;
//trace("SocketSendQuery01",m_QueryList.length);
		//if(m_QueryList.length<=0) return;
//trace("SocketSendQuery02");
		//var obj:Object=m_QueryList[0];
		
		//m_Socket.writeBytes(obj.Data);
		//m_WaitAnswer=true;
		
		if(!m_SocketReady) return;
//		if(m_Socket==null) return;

		if(m_WaitAnswer>=m_MaxWait) return;

		if (Server.Self.m_Protocol == Server.ProtocolDefaultHTTP) {
			if (m_WaitAnswer != 0) return;
			if (m_QueryList.length <= 0) return;
			
			obj = m_QueryList[0];
			if (obj.UrlDefaultHTTP != undefined) {
				if ((obj.PostHTTP != undefined) && obj.PostHTTP) {
					loader = new URLLoader();
					if(obj.RecvTxt) loader.dataFormat = URLLoaderDataFormat.TEXT;
					else loader.dataFormat = URLLoaderDataFormat.BINARY;
					loader.addEventListener(Event.COMPLETE, dhttpComplate);
					loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					lr = new URLRequest(ServerAdr+obj.UrlDefaultHTTP);
					lr.data = obj.Data;
					lr.method = URLRequestMethod.POST;
					lr.contentType="multipart/form-data; boundary="+obj.Boundary;

					loader.load(lr);

					m_WaitAnswer++;
					
				} else {
					loader = new URLLoader();
					if(obj.RecvTxt) loader.dataFormat = URLLoaderDataFormat.TEXT;
					else loader.dataFormat = URLLoaderDataFormat.BINARY;
					loader.addEventListener(Event.COMPLETE, dhttpComplate);
					loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					lr = new URLRequest(ServerAdr+obj.UrlDefaultHTTP);

					loader.load(lr);

					m_WaitAnswer++;
				}
			} else {
				ba = new ByteArray();

				allsize = 0;
				cnt = Math.min(m_MaxWait, m_QueryList.length);
				for (i = 0; i < cnt; i++) {
					obj = m_QueryList[i];
					if (obj.UrlDefaultHTTP != undefined) break;

					if(obj.Data==null) throw Error("");
					if(obj.Data.length<=0) throw Error("");

					if (((allsize + obj.Data.length) > 160) && i!=0) break;
					if ((allsize + obj.Data.length) > 512) break;
					allsize += obj.Data.length;
					ba.writeBytes(obj.Data);
				}
				cnt = i;
				if (cnt <= 0) { StdMap.Main.ErrorFromServer(Server.ErrorProtocol); throw Error("Size send large"); }

				strbegin = Base64.encodeByteArrayForURL(ba) + "_";
//trace("small:", strbegin, "["+ByteArrayToString(ba)+"]");

				sadd="";
				if (Server.Self.m_Session.length > 0) sadd += "&ss=" + Server.Self.m_Session;

				loader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE, posthttpComplate);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				lr = new URLRequest(ServerAdr + "emu?nc=" + Server.Self.m_NoCacheStr + "&qn=" + Server.Self.m_NoCacheNo.toString() + sadd + "&v=" + strbegin);
				
				Server.Self.m_NoCacheNo++;

				loader.load(lr);

				m_WaitAnswer+=cnt;
			}

		} else if (Server.Self.m_Protocol == Server.ProtocolPostHTTP) {
			if (m_WaitAnswer != 0) return;
			if (m_QueryList.length <= 0) return;

			sadd="";
			if (Server.Self.m_Session.length > 0) sadd += "&ss=" + Server.Self.m_Session;

			boundary = Server.Self.CreateBoundary() + "-HPXY-";

			strbegin="--"+boundary+"\r\n";
	        strbegin+="Content-Disposition: form-data; name=\"data\"\r\n";
			strbegin+="Content-Type: application/octet-stream\r\n";
			strbegin+="Content-Transfer-Encoding: binary\r\n";
			strbegin += "\r\n";
			
			strend = "--" + boundary + "--\r\n";

			ba = new ByteArray();
			ba.writeUTFBytes(strbegin);
			
			cnt = Math.min(m_QueryList.length, m_MaxWait);
			for (i = 0; i < cnt; i++) {
				obj = m_QueryList[i];

				if (obj.Data == null) throw Error("");
				if (obj.Data.length <= 0) throw Error("");
				
				ba.writeBytes(obj.Data);
			}

			m_WaitAnswer += cnt;

			ba.writeUTFBytes(strend);

			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, posthttpComplate);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			lr = new URLRequest(ServerAdr+"emp?nc="+Server.Self.m_NoCacheStr+"&qn="+Server.Self.m_NoCacheNo.toString()+sadd);
			lr.data = ba;
			lr.method = URLRequestMethod.POST;
			lr.contentType="multipart/form-data; boundary="+boundary;

			Server.Self.m_NoCacheNo++;

			loader.load(lr);
			
		} else if (Server.Self.m_Protocol == Server.ProtocolSocketHTTP) {
			if (m_WaitAnswer != 0) return;
			if (m_QueryList.length <= 0) return;

			sadd="";
			if (Server.Self.m_Session.length > 0) sadd += "&ss=" + Server.Self.m_Session;

			cnt = Math.min(m_QueryList.length, m_MaxWait);
			var allsize:int = 0;
			for (i = 0; i < cnt; i++) {
				obj = m_QueryList[i];

				if (obj.Data == null) throw Error("");
				if (obj.Data.length <= 0) throw Error("");

				allsize += obj.Data.length;
			}

			boundary = Server.Self.CreateBoundary() + "-HPXY-";

			strbegin="--"+boundary+"\r\n";
	        strbegin+="Content-Disposition: form-data; name=\"data\"\r\n";
			strbegin+="Content-Type: application/octet-stream\r\n";
			strbegin+="Content-Transfer-Encoding: binary\r\n";
			strbegin += "\r\n";
			
			strend = "--" + boundary + "--\r\n";


//			var ba:ByteArray=new ByteArray();

			m_Socket.writeUTFBytes("POST ");
			m_Socket.writeUTFBytes("/emp?nc="+Server.Self.m_NoCacheStr+"&qn="+Server.Self.m_NoCacheNo.toString()+sadd);
			m_Socket.writeUTFBytes(" HTTP/1.1\n");
			m_Socket.writeUTFBytes("User-Agent: Empire Client\n");
			//m_Socket.writeUTFBytes("Host: "+Server.Self.m_ServerAdr+"\n");
			m_Socket.writeUTFBytes("Host: "+ServerAdr+"\n");
			m_Socket.writeUTFBytes("Content-Type: multipart/form-data; boundary="+boundary+"\n");
			m_Socket.writeUTFBytes("Content-Length: "+(strbegin.length+allsize+strend.length).toString()+"\n");
			m_Socket.writeUTFBytes("Connection: Keep-Alive\n");
			m_Socket.writeUTFBytes("Cache-Control: no-cache\n");
			m_Socket.writeUTFBytes("\n");
			m_Socket.flush();

			Server.Self.m_NoCacheNo++;
			
			m_Socket.writeUTFBytes(strbegin);

			for (i = 0; i < cnt; i++) {
				obj = m_QueryList[i];
				
				m_Socket.writeBytes(obj.Data);
			}

	        m_Socket.writeUTFBytes(strend);

			//m_Socket.writeBytes(ba);
			m_Socket.flush();

			m_WaitAnswer += cnt;
			
		} else {
			for(i=m_WaitAnswer;i<m_QueryList.length;i++) {
				obj=m_QueryList[i];
				if(obj.Data==null) throw Error("");
				if(obj.Data.length<=0) throw Error("");
//if(EmpireMap.Self.m_Debug) trace("Send:",obj.Command," Size:",obj.Data.length);
//if(EmpireMap.Self.m_Debug) trace("["+ByteArrayToString(obj.Data)+"]");
				//obj.Data.position=0;
				m_Socket.writeBytes(obj.Data);
				m_Socket.flush();
				m_WaitAnswer++;
				if(m_WaitAnswer!=i+1) throw Error("");

				if(m_WaitAnswer>=m_MaxWait) break;
			}
		}
	}
	
	public function IsSendCommand(command:String):Boolean
	{
		var i:int;
		for(i=0;i<m_QueryList.length;i++) {
			var obj:Object=m_QueryList[i];
			if (obj.Command == command) return true;
		}
		return false;
	}

	public function SendCancel(command:String):void
	{
		var i:int;
		for(i=m_QueryList.length-1;i>=m_WaitAnswer;i--) {
			var obj:Object=m_QueryList[i];
			if(obj.Command==command) {
				obj.Data=null;
				obj.FunComplate=null;
				obj.Fun=null;
				m_QueryList.splice(i,1);
			}
		}
	}

	public function QueryBin(command:String, ba:ByteArray, retry:Boolean, funComplate:Function, fun:Function, recvtxt:Boolean=true):Object
	{
		var obj:Object=new Object();
		obj.Command=command;
		obj.Data=ba;
		obj.FunComplate=funComplate;
		obj.Fun=fun;
		obj.Retry=retry;
		obj.RecvTxt=recvtxt;
		
		m_QueryList.push(obj);

		return obj;
	}
	
	public function Send():void
	{
//if(EmpireMap.Self.m_Debug) trace("ConnectAndSendQuery");
		if (!m_SocketReady && m_Socket==null) Connect();
		if (m_SocketReady) SendQuery();
	}

	public function dhttpComplate(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

//		var buf:ByteArray=loader.data;
//		buf.endian = Endian.LITTLE_ENDIAN;

		if (!m_SocketReady) return; // Соединение закрыто

		if(m_QueryList.length<=0) {
			StdMap.Main.ErrorFromServer(Server.ErrorProtocol);
			throw Error("");
		}
		var oq:Object=m_QueryList[0];

//trace("dhttpComplate",oq.Command);

		m_QueryList.splice(0,1);

		m_WaitAnswer--;
		if (m_WaitAnswer < 0) { StdMap.Main.ErrorFromServer(Server.ErrorProtocol); throw Error(""); }
		
		var len:int = 0;
		if (loader.data != undefined && loader.data != null) {
			if (loader.data is ByteArray) len = (loader.data as ByteArray).length;
			else if (loader.data is String) len = (loader.data as String).length;
		}

		if (oq.FunComplate != null) oq.FunComplate(oq.Command, len);

		if (oq.Fun != null) {
var t00:int = getTimer();
			oq.Fun(event);
var t01:int = getTimer();
if((t01 - t00) > 50 && StdMap.Main.m_Debug) StdMap.Main.AddDebugMsg("!SLOW.CalcServerRecv " + oq.Command + " " + (t01 - t00).toString());

//			var ul:URLLoader=new URLLoader();
//			if(oq.RecvTxt) ul.dataFormat=URLLoaderDataFormat.TEXT;
//			else ul.dataFormat=URLLoaderDataFormat.BINARY;
//			ul.data=loader.data;
//			ul.bytesLoaded=http_content_len;
//			ul.bytesTotal=http_content_len;
//			ul.addEventListener(Event.COMPLETE, oq.Fun);
//			ul.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
	
	public function posthttpComplate(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian = Endian.LITTLE_ENDIAN;
		
		buf.readBytes(m_RecvData, m_RecvData.length, buf.length);
	}

	public function socketDataHandler(event:ProgressEvent=null):void
	{
//trace("!!!SDH In");
		
//if(EmpireMap.Self.m_Debug) trace("loaddata00",m_Socket.bytesAvailable,m_RecvData.length);

		if(m_Socket!=null && m_SocketReady && m_Socket.bytesAvailable>0) {
			if(event!=null && event.target!=m_Socket) {}
			else {
				var oldp:int = m_RecvData.position;
				m_Socket.readBytes(m_RecvData, m_RecvData.length, m_Socket.bytesAvailable);
				m_RecvData.position = oldp;
//if(EmpireMap.Self.m_Debug) trace("loaddata01",m_Socket.bytesAvailable,m_RecvData.length);
			}
		}
	}

	public function ProcessRecvData():void
	{
		if(m_RecvData.position>=m_RecvData.length) {
//trace("!!!SDH Out1");			
			return;
		}

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp__", m_RecvData.position, m_RecvData.length);

		var pstart:int = m_RecvData.position;

		var len:int,sme:int,pt:int;
		var rb:uint;
		var str:String;

//		m_RecvData.position=0;
//		if(m_RecvData.length<1) {
//			EmpireMap.Self.ErrorFromServer(Server.ErrorData);
//			throw Error("");
//		}

		var id:uint = m_RecvData.readUnsignedByte();
		
		
/*		var id:uint = 0;
		while(m_RecvData.position<m_RecvData.length) {
			id = m_RecvData.readUnsignedByte();
			if (id != 0) break;
		}
		if (id == 0 && m_RecvData.position >= m_RecvData.length) {
			m_RecvData.length = 0;
			return;
		}*/

		if(m_QueryList.length<=0) {
			StdMap.Main.ErrorFromServer(Server.ErrorProtocol);
			throw Error("");
		}
		var oq:Object=m_QueryList[0];

		var retdata:Object=null;
		var small:Boolean=false;
		var smallerrcode:uint=0;

		if(id==0x48) { // H
			if ((m_RecvData.length - m_RecvData.position) < 3) { m_RecvData.position = pstart; return; }// Не все данные пришли
			// T
			id=m_RecvData.readUnsignedByte();
			if(id!=0x54) { StdMap.Main.ErrorFromServer(Server.ErrorProtocol); throw Error(""); }
			// TP
			id=m_RecvData.readUnsignedShort();
			if(id!=0x5054) { StdMap.Main.ErrorFromServer(Server.ErrorProtocol); throw Error(""); }

			// Header
			var http_err_code:int=0;
			var http_content_len:int=0;
			var firststr:Boolean = true;
			var http_proxy:Boolean = false;
			while(true) {
//trace("    ",m_RecvData.position,m_RecvData.length);
				len=0;
				sme=m_RecvData.position;
				while(m_RecvData.position<m_RecvData.length) {
					rb=m_RecvData.readUnsignedByte();
					if(rb==10) break;
					if(rb!=13) len++;
				}
				if(m_RecvData.position>=m_RecvData.length) {
					//var addstr:String=" ("+m_RecvData.position.toString()+"/"+m_RecvData.length.toString()+")";
					//trace("HTTP bad answer. Command="+oq.Command+addstr);
					m_RecvData.position = pstart;
					return; // Не все данные пришли
					//EmpireMap.Self.ErrorFromServer(Server.ErrorData);
					//throw Error("HTTP bad answer. Command="+oq.Command+addstr);
				}
				pt=m_RecvData.position;
				
				m_RecvData.position=sme;
				str=m_RecvData.readUTFBytes(len);
				m_RecvData.position=pt;

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp00:",str);

				if(firststr) {
					if(str.length<8) {
						StdMap.Main.ErrorFromServer(Server.ErrorProtocol);
						throw Error("");
					}
					if(str.substr(0,5)!="/1.1 ") {
						StdMap.Main.ErrorFromServer(Server.ErrorProtocol);
						throw Error("");
					}
					http_err_code=int(str.substr(5,3));
					
				} else if(str.substr(0,15).toLowerCase()=="content-length:") {
					http_content_len=int(str.substr(15));

				} else if (str.substr(0, 5).toLowerCase() == "hpxy:") {
					http_proxy = true;

				} else if(str.length<=0) {
					break;
				}

				firststr=false;
			}

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp01","http_err_code:",http_err_code,"http_content_len:",http_content_len,"ost:",m_RecvData.length-m_RecvData.position);

			if(http_content_len>0) {
				if((m_RecvData.length-m_RecvData.position)<http_content_len) {
//trace("!!!SDH Out2");			
					m_RecvData.position = pstart;
					return;
				}
				if (http_proxy) {
					// Для прокcи HTTP ответа просто пропускаем заголовок
					ProcessRecvData(); 
					return;
				}
/*				if ((m_RecvData.length - m_RecvData.position) >= 4) {
					if (m_RecvData.readUnsignedInt() != 0x59585048) { // HPXY - прокcи ответ
						m_RecvData.position = m_RecvData.position - 4;
					} else {
						// Для прокcи HTTP ответа просто пропускаем заголовок
						ProcessRecvData(); 
						return;
					}
				}*/
				if(oq.RecvTxt) {
//trace("!!!AnswerHttp11");
					retdata=m_RecvData.readUTFBytes(http_content_len);
//trace("!!!AnswerHttp12");
				} else {
					retdata=new ByteArray();
					retdata.endian=Endian.LITTLE_ENDIAN;
//trace("!!!AnswerHttp21");
					m_RecvData.readBytes(retdata as ByteArray,0,http_content_len);
//trace("!!!AnswerHttp22");
				}
			}

		} else if((id&0xf0)==0xf0) {
//			EmpireMap.Self.ErrorFromServer(Server.ErrorData);
//			throw Error("Answer Short");

			var sh:uint=id&3;
			var smallsize:uint=0;
//trace("!!!AnswerSmall00 id:", id, "sh:", sh);
			if(sh==0) {
			} else if(sh==1) {
				if ((m_RecvData.length - m_RecvData.position) < 1) { m_RecvData.position = pstart; return; } // Не все данные пришли
				smallsize=m_RecvData.readUnsignedByte();
			} else if(sh==2) {
				if ((m_RecvData.length - m_RecvData.position) < 2) { m_RecvData.position = pstart; return; } // Не все данные пришли
				smallsize=m_RecvData.readUnsignedShort();
			} else if(sh==3) {
				if ((m_RecvData.length - m_RecvData.position) < 4) { m_RecvData.position = pstart; return; } // Не все данные пришли
				smallsize=m_RecvData.readUnsignedInt();
			}

			sh=(id>>2)&3;
//trace("!!!AnswerSmall01", "sh:", sh);
			if(sh==0) {
			} else if(sh==1) {
				if ((m_RecvData.length - m_RecvData.position) < 1) { m_RecvData.position = pstart; return; } // Не все данные пришли
				smallerrcode=m_RecvData.readUnsignedByte();
			} else if(sh==2) {
				if ((m_RecvData.length - m_RecvData.position) < 2) { m_RecvData.position = pstart; return; } // Не все данные пришли
				smallerrcode=m_RecvData.readUnsignedShort();
			} else if(sh==3) {
				if ((m_RecvData.length - m_RecvData.position) < 4) { m_RecvData.position = pstart; return; } // Не все данные пришли
				smallerrcode=m_RecvData.readUnsignedInt();
			}

			if((m_RecvData.length-m_RecvData.position)<2) { m_RecvData.position = pstart; return; } // Не все данные пришли

			if(m_RecvData.readUnsignedShort()!=0x0a0a) { StdMap.Main.ErrorFromServer(Server.ErrorProtocol); throw Error("Answer Short Header"); }

//trace("!!!AnswerSmall02",smallsize,smallerrcode);
			if(smallsize>0) {
				if((m_RecvData.length-m_RecvData.position)<smallsize) { m_RecvData.position = pstart; return; } // Не все данные пришли

				retdata=new ByteArray();
				retdata.endian=Endian.LITTLE_ENDIAN;
				m_RecvData.readBytes(retdata as ByteArray,0,smallsize);
			}
			
			small=true;

		} else {
			StdMap.Main.ErrorFromServer(Server.ErrorProtocol);
			throw Error("");
		}
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp30");

		var loadbyte:int=m_RecvData.position-pstart;

		if (m_RecvData.position >= m_RecvData.length) { m_RecvData.position = 0; m_RecvData.length = 0; }
/*		else {
			var nrd:ByteArray=new ByteArray();
			nrd.endian=Endian.LITTLE_ENDIAN;
			m_RecvData.readBytes(nrd,0,m_RecvData.length-m_RecvData.position);
			m_RecvData=nrd;
		}*/
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp31");

		m_QueryList.splice(0,1);

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp32");
		m_WaitAnswer--;
		if(m_WaitAnswer<0) {
			StdMap.Main.ErrorFromServer(Server.ErrorProtocol);
			throw Error("");
		}
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp33",oq.FunComplate);
//		SendQuery();

//trace("!!!FunComplate Before",oq.Command,http_content_len);
		if(oq.FunComplate!=null) oq.FunComplate(oq.Command,loadbyte);
//trace("!!!FunComplate After");

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp34", oq.Fun);

/*		if (og.FunProxy != undefined) {
if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp70", oq.Fun);
			og.FunProxy(oq, retdata);
if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp71", oq.Fun);

		} else*/
		if(oq.Fun!=null) {
			if(small) {
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp80", oq.Fun);
var t00:int = getTimer();
				oq.Fun(smallerrcode, retdata);
var t01:int = getTimer();
if((t01 - t00) > 50 && StdMap.Main.m_Debug) StdMap.Main.AddDebugMsg("!SLOW.CalcServerRecv " + oq.Command + " " + (t01 - t00).toString());

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp81", oq.Fun);
			} else {
				var ul:URLLoader=new URLLoader();
				//m_EventList.push(ul);
				if(oq.RecvTxt) ul.dataFormat=URLLoaderDataFormat.TEXT;
				else ul.dataFormat=URLLoaderDataFormat.BINARY;
				ul.data=retdata;
				ul.bytesLoaded=http_content_len;
				ul.bytesTotal=http_content_len;
				ul.addEventListener(Event.COMPLETE, oq.Fun);
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp90");
				ul.dispatchEvent(new Event(Event.COMPLETE));
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp91");
			}
		}

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerHttp99",m_RecvData.position,m_RecvData.length);		
//trace("!!!SDH Out3");			

		if(m_RecvData.position<m_RecvData.length) ProcessRecvData(); 
	}
}

}
