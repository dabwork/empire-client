package Base
{
	import flash.utils.ByteArray;
	
public class BaseStr
{
	public static var m_TagList:Array = new Array();
	
	public static const BaseChar:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];

	public static function Replace(str:String, part:String, val:String):String
	{ 
		return str.split(part).join(val);
	}
	
	static public function Trim(str:String):String
	{
		if (str == null) return "";
		var ch:int;
		var len:int = str.length;
		var start:int = 0;
		while (start < len) {
			ch = str.charCodeAt(start);
			if (ch != 32 && ch != 9 && ch != 10 && ch != 13) break;
			start++;
		}
		var end:int = len;
		while (end > 0) {
			ch = str.charCodeAt(end - 1);
			if (ch != 32 && ch != 9 && ch != 10 && ch != 13) break;
			end--;
		}
		if (end - start <= 0) return "";
		return str.substring(start, end);
	}

	static public function TrimBegin(str:String):String
	{
		if (str == null) return "";
		var ch:int;
		var len:int = str.length;
		var start:int = 0;
		while (start < len) {
			ch = str.charCodeAt(start);
			if (ch != 32 && ch != 9 && ch != 10 && ch != 13) break;
			start++;
		}
		var end:int = len;
		if (end - start <= 0) return "";
		return str.substring(start, end);
	}

	static public function TrimEnd(str:String):String
	{
		if (str == null) return "";
		var ch:int;
		var len:int = str.length;
		var start:int = 0;
		var end:int = len;
		while (end > 0) {
			ch = str.charCodeAt(end - 1);
			if (ch != 32 && ch != 9 && ch != 10 && ch != 13) break;
			end--;
		}
		if (end - start <= 0) return "";
		return str.substring(start, end);
	}

	static public function TrimRepeat(str:String):String
	{
		str = Replace(str, "\t", " ");

		var astr:String;
		while(true) {
			astr = Replace(str, "  ", " ");
			if (astr.length == str.length) break;
			str = astr;
		}
		return str;
	}
	
	public static function EqNCEng(str1:String, str2:String):Boolean
	{
		var cnt:int = str1.length;
		if(cnt!=str2.length) return false;

		var i:int, ch1:int, ch2:int;
		
		for (i = 0; i < cnt; i++) {
			ch1 = str1.charCodeAt(i);
			ch2 = str2.charCodeAt(i);
			if (ch1 >= 65 && ch1 <= 90) ch1 = ch1 - 65 + 97;
			if (ch2 >= 65 && ch2 <= 90) ch2 = ch2 - 65 + 97;
			if (ch1 != ch2) return false;
		}

		return true;
	}
	
	public static function ParseUint(str:String, base:int = 10):uint
	{
		if (str == null) return 0;
		var v:uint = 0;
		
		var off:int = 0;
		var len:int = str.length;
		var ch:int;

		while(off<len) {
			ch = str.charCodeAt(off);
			if (ch >= 48 && ch <= 57) { // 0-9
				if ((ch - 48) < base) v = v * base + (ch - 48);
			} else if (ch >= 65 && ch <= 90) { // A-Z
				if ((ch - 65 + 10) < base) v = v * base + (ch - 65 + 10);
			} else if (ch >= 97 && ch <= 122) { // a-z
				if ((ch - 97 + 10) < base) v = v * base + (ch - 97 + 10);
			}
			off++;
		}
		
		return v;
	}
	
	public static function CodeExtractSpace(src:String, off:int):String
	{
		var len:int = src.length;
		var i:int = off;
		var ch:int;
		while (i >= 0) {
			ch = src.charCodeAt(i);
			if (ch == 10) break;
			i--;
		}
		i++;
		var cnt:int = 0;
		while ((i + cnt) < len) {
			ch = src.charCodeAt(i + cnt);
			if (ch != 9 && ch != 32) break;
			cnt++;
		}
		if (cnt <= 0) return "";
		return src.substr(i, cnt);
	}

	public static function CodeBeginLine(src:String, off:int):int
	{
		var ch:int;
		while (off > 0) {
			ch = src.charCodeAt(off-1);
			if (ch == 10) break;
			off--;
		}
		return off;
	}
	
	public static function CodeNextLine(src:String, off:int):int
	{
		var ch:int;
		var len:int = src.length;
		while (off < len) {
			ch = src.charCodeAt(off);
			off++;
			if (ch == 10) break;
		}
		return off;
	}
	
	public static function FormatFloat(v:Number, zpz:int):String
	{
		var i:int;
		var minus:Boolean=false;
		var str:String = "";
		if (v < 0) { v = -v; minus = true; }

		var f:int = Math.floor(v);
		var s:int = 0;

		if(zpz>1) {
			var m:int = 1;
			for (i = 0; i < zpz; i++) m *= 10;
			s = Math.round((v - f) * m);
			f += Math.floor(s / m);
			s = s % m;
		}
		
		if (minus && (f != 0 || s != 0)) str += "-";
		str += f.toString();
		
		while (s>0) {
			var p:String = s.toString();
			while (p.length < zpz) p = "0" + p;
			
			i = p.length;
			while (i > 0) {
				if (p.charCodeAt(i - 1) != 48) break;
				i--;
			}

			str += "." + p.substr(0, i);

			break;
		}
		
		return str;
	}
	
	public static function FormatColor(clr:uint, showalpha:Boolean = true):String
	{
		var str:String = "";
		if (showalpha) {
			str += BaseChar[(clr >> (24 + 4)) & 15] + BaseChar[(clr >> (24 + 0)) & 15];
		}
		str += BaseChar[(clr >> (16 + 4)) & 15] + BaseChar[(clr >> (16 + 0)) & 15];
		str += BaseChar[(clr >> (8 + 4)) & 15] + BaseChar[(clr >> (8 + 0)) & 15];
		str += BaseChar[(clr >> (0 + 4)) & 15] + BaseChar[(clr >> (0 + 0)) & 15];
		return str;
	}
	
	public static function IsTagEq(str:String,from:int,len:int,s1:String,s2:String):Boolean
	{
		var cnt:int = Math.min(s1.length, s2.length);
		if (cnt <= 0) return false;
		if (len < cnt) return false;
		
		var i:int, ch:int;
		
		for (i = 0; i < cnt; i++) {
			ch = str.charCodeAt(from + i);
			if (ch != s1.charCodeAt(i) && ch != s2.charCodeAt(i)) return false;
		}
		
		return true;
	}

	public static function IsTagEqNCEng(str:String,from:int,len:int,s1:String):Boolean
	{
		var cnt:int = s1.length;
		if (cnt <= 0) return false;
		if (len < cnt) return false;
		
		var i:int, ch:int, ch2:int;
		
		for (i = 0; i < cnt; i++) {
			ch = str.charCodeAt(from + i);
			if (ch >= 65 && ch <= 90) ch = ch - 65 + 97;
			ch2 = s1.charCodeAt(i);
			if (ch2 >= 65 && ch2 <= 90) ch2 = ch2 - 65 + 97;
			if (ch != ch2) return false;
		}
		
		return true;
	}
	
	public static function ParseIntLen(str:String, sme:int, len:int):int
	{
		if(len<=0) return 0;
		
		var add:int=0;
		
		var ch:int=str.charCodeAt(sme);
		if(ch==45 || ch==43) { add++; sme++; len--; }
		
		while(len>0) {
			ch=str.charCodeAt(sme);
			if(ch<48 || ch>57) break;
			add++;
			sme++;
			len--;
		}
		
		return add;
	}
	
	public static function FormatBigInt(v:int):String
	{
		var str:String = v.toString();
		
		var i:int;
		var len:int = str.length;
		var from:int = 1;
		if (str.charAt(0) == '-') from = 2;
		
		for (i = str.length - 3; i >= from; i -= 3) {
			str = str.slice(0, i) + " " + str.slice(i, str.length);
		}

		return str;
	}

	public static function TagSetCallback(name:String, fun:Function):void
	{
		m_TagList[name] = fun;
	}
	
	public static function FormatTag(src:String, tagon:Boolean = true, bgwhite:Boolean = false):String
	{
		var i:int,len:int,ts:int,tl:int,add:int,width:int,height:int,off:int,stl:int;
		var namebegin:int,namelen:int,valbegin:int,vallen:int;
		var id:uint;
		var sme:int=0;
		var srclen:int = src == null?0:src.length;
		var ch:int;
		var link:String;
		var tagnamelen:int;
		var tagname:String;

		var sysimgnum:int=0;

		var out:String = "";
		
		var simplelen:int=0;

		while(sme<srclen) {
			ch=src.charCodeAt(sme);
			
			if(ch==91) { // [
				if(simplelen>0) { out+=src.substr(sme-simplelen,simplelen); simplelen=0; }

				len=0;			
				
				while(tagon) {
					len=1;
					
					var opencnt:int=1;
					while(sme+len<srclen) {
						ch=src.charCodeAt(sme+len);
						if(ch==91) opencnt++; // [
						else if(ch==93) { // ]
							opencnt--;
							if(opencnt<=0) break;
						}
						len++;
					}			
	                if(len<=1 || sme+len>=srclen) { len=0; break;}
    	            len++;
					
					tagnamelen = 0;
					while (1 + tagnamelen < len - 1) {
						ch = src.charCodeAt(sme+1+tagnamelen);
						if (ch == 32 || ch == 9) break;
						tagnamelen++;
					}
					
					if (tagnamelen <= 0) tagname = "";
					else tagname = src.substr(sme + 1, tagnamelen).toLowerCase();
					
					if (tagnamelen > 0 && m_TagList[tagname] != undefined) {
						i = len - 1 - (1 + tagnamelen + 1);
						if (i > 0) out += m_TagList[tagname](src.substr(sme + 1 + tagnamelen + 1, i));
						else out += m_TagList[tagname]("");
					}
/*    	            else if ((len - 2 >= 4) && IsTagEq(src, sme + 1, len - 2, "user", "USER")) {
    	            	ts=sme+1+4;
    	            	tl=len-2-4;
    	            	
    	            	while(tl>0 && src.charCodeAt(ts)==32) { ts++; tl--; }
    	            	
    	            	add=ParseIntLen(src,ts,tl);
    	            	if(add<=0) { len=0; break;}

    	            	id=uint(src.substr(ts,add));

    	            	var user:User=UserList.Self.GetUser(id);
    	            	if(user!=null) {
    	            		out += "[" + EmpireMap.Self.Txt_CotlOwnerName(0, id) + "]";
    	            	} else {
    	            		out+="[User "+id.toString()+"]";
    	            	}
    	            }*/
					else if((len-2>=1) && IsTagEq(src,sme+1,len-2,"p","P")) {
    	            	out+="<p>";

    	            } else if((len-2>=2) && IsTagEq(src,sme+1,len-2,"/p","/P")) {
    	            	out+="</p>";

    	            } else if ((len - 2 >= 3) && IsTagEq(src, sme + 1, len - 2, "clr", "CLR")) {
						if (bgwhite) out += "<font color='#2d15fc'>";
    	            	else out+="<font color='#ffff00'>";

    	            } else if((len-2>=4) && IsTagEq(src,sme+1,len-2,"/clr","/CLR")) {
    	            	out += "</font>";

    	            } else if((len-2>=3) && IsTagEq(src,sme+1,len-2,"crt","CRT")) {
    	            	if (bgwhite) out += "<font color='#880000'>";
						else out+="<font color='#ff4040'>";

    	            } else if((len-2>=4) && IsTagEq(src,sme+1,len-2,"/crt","/CRT")) {
    	            	out += "</font>";

    	            } else if((len-2>=6) && IsTagEq(src,sme+1,len-2,"center","CENTER")) {
    	            	out+="<p align='center'>";

    	            } else if((len-2>=7) && IsTagEq(src,sme+1,len-2,"/center","/CENTER")) {
    	            	out += "</p>";
						
    	            } else if((len-2>=6) && IsTagEq(src,sme+1,len-2,"justify","JUSTIFY")) {
    	            	out+="<p align='justify'>";

    	            } else if((len-2>=7) && IsTagEq(src,sme+1,len-2,"/justify","/JUSTIFY")) {
    	            	out += "</p>";
						
    	            } else if((len-2>=2) && IsTagEq(src,sme+1,len-2,"br","BR")) {
    	            	out+="<br>";

    	            } else if((len-2>=3) && IsTagEq(src,sme+1,len-2,"img","IMG")) {
    	            	ts=sme+1+3;
    	            	tl=len-2-3;

    	            	width=-1;
    	            	height=-1;
    	            	link="";
    	            	
    	            	while(tl>0) {
    	            		while(tl>0 && src.charCodeAt(ts)==32) { ts++; tl--; }
    	            		
    	            		namebegin=ts;
    	            		while(tl>0 && src.charCodeAt(ts)!=0x3d) { ts++; tl-- } // =
    	            		namelen=ts-namebegin;
    	            		if(namelen<=0) break;
    	            		if(tl<=0) break;
    	            		if(src.charCodeAt(ts)!=0x3d) break; // =
    	            		ts++;
    	            		tl--;
    	            		
    	            		valbegin=ts;
    	            		while(tl>0 && src.charCodeAt(ts)!=32) { ts++; tl--; }
    	            		vallen=ts-valbegin;
    	            		
    	            		if(IsTagEq(src,namebegin,namelen,"width","WIDTH")) {
    	            			width=int(src.substr(valbegin,vallen));
    	            			
    	            		} else if(IsTagEq(src,namebegin,namelen,"height","HEIGHT")) {
    	            			height=int(src.substr(valbegin,vallen));
    	            			
    	            		} else if(IsTagEq(src,namebegin,namelen,"src","SRC")) {
    	            			link=src.substr(valbegin,vallen);
    	            		}
    	            	}
    	            	
    	            	while(link.length>0) {
    	            		ts=sme+len;
    	            		tl=srclen-ts;
    	            		stl=0;
    	            		while(tl>0 && src.charCodeAt(ts)!=91) { ts++; tl--; stl++; } // [
    	            		if(tl<6) break;
    	            		if(!IsTagEq(src,ts,tl,"[/img]","[/IMG]")) break;
    	            		
    	            		if(tagon) {
    	            			out+="<img hspace='0'";
    	            			if(width>0) out+=" width='"+width.toString()+"'";
    	            			if(height>0) out+=" height='"+width.toString()+"'";
    	            			out+=" src='"+link+"'";
    	            			out+=" id='_sys_img"+sysimgnum+"'";
    	            			out+=">";
    	            			
    	            			sysimgnum++;
    	            		}
    	            		
    	            		len+=stl+6;
    	            		break;
    	            	}

    	            } else { len=0; break;}
    	            
    	            sme+=len;
    	            break;
				}
				if(len==0) {
					sme++;
					simplelen=1;
				}
			} else {
				sme++;
				simplelen++;
			}
		}

		if(simplelen>0) { out+=src.substr(sme-simplelen,simplelen); simplelen=0; }				

		return out;
	}
}
	
}