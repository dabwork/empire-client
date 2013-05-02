// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import flash.display3D.*;
import Base.BaseStr;

public class Set
{
	public static var m_AntiAlias:int = 16;
	public static var m_Graph:String = Context3DProfile.BASELINE;
	public static var m_Protocol:int = Server.ProtocolRaw;
	public static var m_ServerList:Array = new Array();

	public static function Load(src:String):void
	{
		var i:int, u:int, k:int, type:int;
		var ibegin:int, iend:int;
		var ch:int;
		var len:int=src.length;
		var off:int = 0;
		var name:String, str:String;
		var header:Boolean = false;
		var server:Object = null;
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
						if (BaseStr.IsTagEq(src, ibegin, iend - ibegin, "server", "SERVER") /*&& name != null*/) {
							header = true;
							server = new Object();
							m_ServerList.push(server);
						}
					} else { if(StdMap.Main) StdMap.Main.AddDebugMsg("Error load set: Unknown section."); return;  }
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

					if (iend > ibegin && server == null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.EqNCEng(name, "Protocol")) {
							if (BaseStr.EqNCEng(str, "Raw")) m_Protocol = Server.ProtocolRaw;
							else if (BaseStr.EqNCEng(str, "DefaultHTPP")) m_Protocol = Server.ProtocolDefaultHTTP;

						} else if (BaseStr.EqNCEng(name, "Graph")) {
							if (BaseStr.EqNCEng(str, "Normal")) m_Graph = Context3DProfile.BASELINE;
							else /*if(BaseStr.EqNCEng(str, "Simple"))*/ m_Graph = Context3DProfile.BASELINE_CONSTRAINED;
						} else if (BaseStr.EqNCEng(name, "AntiAlias")) {
							m_AntiAlias = BaseStr.ParseIntLen(str, 0, str.length);
							if (m_AntiAlias != 0 && m_AntiAlias != 2 && m_AntiAlias != 4 && m_AntiAlias != 8 && m_AntiAlias != 16) m_AntiAlias = 0;
						}

					} else if (iend > ibegin && server != null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.EqNCEng(name, "Adr")) server.Adr = str;
						else if (BaseStr.EqNCEng(name, "Name")) server.Name = str;
					}
				} else {
					header = false;

					ibegin=off;
					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend = off;

					while(iend>ibegin) { ch=src.charCodeAt(iend-1); if(ch==32 || ch==9 || ch==10 || ch==13) iend--; else break; }

					if (iend > ibegin && server != null) {
						//LoadImgStyle(src.substring(ibegin, iend), imgstyle);
					}
				}
			}
		}
	}
}
	
}