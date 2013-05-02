package Empire
{
import Base.*;
import Engine.*;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.*;
import flash.net.*;
import flash.system.*;
import flash.utils.*;

public class UserList extends EventDispatcher
{
	public static var Self:UserList=null;

	private var m_UserList:Dictionary=new Dictionary();
	private var m_UserArray:Array=new Array();

	private var m_UnionList:Dictionary=new Dictionary();
	private var m_UnionArray:Array=new Array();

	private var m_ItemList:Dictionary=new Dictionary();
	public var m_ItemArray:Array=new Array();

	public var m_Timer:Timer=new Timer(100);
	public var m_LockTime:Number=0;
	public var m_UnionLockTime:Number=0;
	public var m_ItemLockTime:Number=0;

//	public var m_TimerNewId:Timer=new Timer(100);
//	public var m_LockTimeNewId:Number=0;
	
	public var m_LoadNextNum:int=0;
	public var m_UnionLoadNextNum:int=0;
	public var m_ItemLoadNextNum:int=0;

	public function UserList()
	{
		m_Timer.addEventListener("timer",QueryUser);
		m_Timer.start();

//		m_TimerNewId.addEventListener("timer",QueryNewId);
//		m_TimerNewId.start();
	}
	
	public function FindUser(name:String):User
	{
		for each(var u:User in m_UserList) {
			if (EmpireMap.Self.Txt_CotlOwnerName(0, u.m_Id, true) == name) return u;
		}
		return null;
	}
	
	public function GetUser(id:uint, testload:Boolean=true, requery:Boolean=false/*true*/):User
	{
		if(id==0) return null;

		var user:User=null;
//trace("GetUser",id);

		if(m_UserList[id]==undefined) {
			user=new User();
			user.m_Id=id;
			m_UserArray.push(user);
			m_UserList[id]=user;
			user.m_GetTime=Common.GetTime();
			LoadUser(user);
		} else {
			user=m_UserList[id];

			if(requery) user.m_GetTime=Common.GetTime();
		}

		if(testload && user.m_LoadDate==0) return null;

		return user;
	}

	public function QueryUser(event:TimerEvent=null):void
	{
		var i:int;
		var user:User;
		
		QueryUnion();
		QueryItem();

		var ct:Number=Common.GetTime();
		if(ct<m_LockTime) return;
		if(!Server.Self.IsConnect()) return;
		if(!EmpireMap.Self.IsConnect()) return;
		m_LockTime=ct+100;

		var ba:ByteArray=new ByteArray();
		ba.endian=Endian.LITTLE_ENDIAN;
		var sl:SaveLoad=new SaveLoad();
		sl.SaveBegin(ba);

		sl.SaveDword(Server.Self.m_ServerNum);
//		sl.SaveDword(Server.Self.m_ConnNo);

		var cnt:int=0;

		if (m_LoadNextNum >= m_UserArray.length) m_LoadNextNum = 0; 
		for (i = m_LoadNextNum; i < m_UserArray.length; i++) {
			user = m_UserArray[i];

			if (user.m_LoadDate == 0 || ((ct > user.m_LoadDate + 10 * 1000) && (ct < (user.m_GetTime + 60 * 60 * 1000)))) {
				user.m_GetTime = 0;
				//if(val.length>0) val+="_";
				//val+=user.m_Id.toString()+"_"+user.m_Version.toString();
				sl.SaveDword(user.m_Id);
				sl.SaveDword(user.m_Version);
				cnt++;
//if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("QueryUser LD="+user.m_LoadDate+" Id="+user.m_Id.toString()+" Ver="+user.m_Version.toString());
			}
			//if(val.length>64) break;
			if(cnt>32) break;
		}
		m_LoadNextNum=i;

		if(cnt<=0) return;
//		if(val.length<=0) return;
//trace("emuser",val);

		m_LockTime=ct+5000;

		sl.SaveDword(0);

		sl.SaveEnd();

		Server.Self.QuerySmall("emuser",true,Server.sqUser,ba,AnswerUser);
//		Server.Self.Query("emuser","&val="+val,AnswerUser,false);
	}
	

	private function AnswerUser(errcode:uint, buf:ByteArray):void
	{
		if(EmpireMap.Self.ErrorFromServer(errcode)) return;
		if(buf==null || buf.length<=0) throw Error("AnswerUser");
		
		var i:int,u:int;
		var cptid:uint;

		m_LockTime=Common.GetTime()+100;

//trace(buf.bytesAvailable);

		var sl:SaveLoad=new SaveLoad();

		sl.LoadBegin(buf);
		
		var ru:Boolean = false;

		while (true) {
//trace("AU01");
			var userid:uint = sl.LoadDword();
//trace("AU01 userid:", userid.toString(16));
			if(userid==0) break;
			var user:User=GetUser(userid,false);
			user.m_LoadDate=Common.GetTime();
//trace("UserId0:", userid, "UserName:", user.m_Name, "Ver:", user.m_Version);

			var ver:uint=sl.LoadDword();
//if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("AnswerUser Id="+user.m_Id.toString()+" Ver="+ver);
			if(ver==0) continue;

			user.m_Version=ver;
			var len:int=buf.readUnsignedByte();
			if(len>0) user.m_SysName=buf.readUTFBytes(len);
//if(EmpireMap.Self.m_Debug) FormChat.Self.AddDebugMsg("AnswerUser Name="+user.m_Name);
//trace("UserId1:", userid, "UserName:", len, user.m_Name, "Ver:", ver);
			if(user.m_Id!=Server.Self.m_UserId) {
				user.m_Score=sl.LoadInt();
				user.m_Rest=sl.LoadInt();
				user.m_Exp=sl.LoadInt();
				user.m_Rating = sl.LoadInt();
				user.m_CombatRating = sl.LoadInt();
				user.m_ExitDate=1000*sl.LoadInt();
			} else {
				sl.LoadInt();
				sl.LoadInt();
				sl.LoadInt();
				sl.LoadInt();
				sl.LoadInt();
				sl.LoadDword();
			}
			user.m_Race = sl.LoadDword();
			user.m_Flag = sl.LoadDword();
			user.m_PlanetShieldEnd=1000*sl.LoadDword();
			user.m_PlanetShieldCooldown=1000*sl.LoadDword();
			user.m_HourPlanetShield=sl.LoadDword();
			user.m_HomeworldCotlId=sl.LoadDword();
			user.m_HomeworldSectorX=sl.LoadInt();
			user.m_HomeworldSectorY=sl.LoadInt();
			user.m_HomeworldPlanetNum=sl.LoadInt();
//			user.m_CitadelCotlId=sl.LoadDword();
//			user.m_CitadelSectorX=sl.LoadInt();
//			user.m_CitadelSectorY=sl.LoadInt();
//			user.m_CitadelPlanetNum=sl.LoadInt();
			user.m_UnionId = sl.LoadDword();
			user.m_CombatId = sl.LoadDword();
			user.m_PowerMul = sl.LoadDword();
			user.m_ManufMul = sl.LoadDword();
			if(user.m_Id!=Server.Self.m_UserId) {
				for (i = 0; i < Common.TechCnt; i++) user.m_Tech[i] = sl.LoadDword();

				user.m_IB1_Type = sl.LoadDword();
				if (user.m_IB1_Type != 0) user.m_IB1_Date = 1000 * sl.LoadDword();
				else user.m_IB1_Date = 0;
				user.m_IB2_Type = sl.LoadDword();
				if (user.m_IB2_Type != 0) user.m_IB2_Date = 1000 * sl.LoadDword();
				else user.m_IB2_Type = 0;

			} else {
				for(i=0;i<Common.TechCnt;i++) sl.LoadDword();

				var dw:uint;
				dw = sl.LoadDword();
				if (dw != 0) sl.LoadDword();
				dw = sl.LoadDword();
				if (dw != 0) sl.LoadDword();
			}
			if(user.m_Id!=Server.Self.m_UserId) {
				while(true) {
					cptid=sl.LoadDword();
					if(cptid==0) break;

					var cpt:Cpt=user.AddCpt(cptid);
					len = buf.readUnsignedByte();
					if (len > 0) cpt.m_Name = buf.readUTFBytes(len);
					else cpt.m_Name = "";
//trace("Cpt", cpt.m_Name, " id:", cptid.toString(16));

					cpt.m_Race=sl.LoadInt();
					cpt.m_Face=sl.LoadInt();

					for (u = 0; u < Common.TalentCnt; u++) cpt.m_Talent[u] = sl.LoadDword();
				}
				
			} else {
				while(true) {
					cptid=sl.LoadDword();
					if(cptid==0) break;

					len=buf.readUnsignedByte();
					if(len>0) buf.readUTFBytes(len);

					sl.LoadInt();
					sl.LoadInt();
					
					for(u=0;u<Common.TalentCnt;u++) sl.LoadDword();
				}
			}
			ru=true;
		}

		sl.LoadEnd();

		if (ru) {
			dispatchEvent(new Event("RecvUser")); 
			if (EmpireMap.Self.m_FormPactList.visible) EmpireMap.Self.m_FormPactList.UpdateName();
			if (EmpireMap.Self.m_FormCombat.visible) EmpireMap.Self.m_FormCombat.Update();
		}
	}

/*	public function AnswerUser(event:Event):void
	{
		var i:int,cnt:int,u:int;
		var ar:Array;

		m_LockTime=Common.GetTime()+100;

		var loader:URLLoader = URLLoader(event.target);

		var user:User=null;

		var al:Array=loader.data.split("\n");
		for(i=0;i<al.length;i++) {
			if(al[i].length<=0) break;

			var endname:int=al[i].indexOf("=");
			if(endname<0) continue;
			var name:String=al[i].slice(0,endname);
			var val:String=al[i].slice(endname+1);

			if(name=="Id") {
				if(user) { SaveUser(); user=null; }

				var id:uint=int(val);

				if(m_UserList[id]!=undefined) {
					user=m_UserList[id];
				}
				if(user!=null) {
					user.m_LoadDate=Common.GetTime();
				}
			} else if(name=="Name") {
				if(user!=null) user.m_Name=val;
			
			} else if(name=="EmpireSE") {
				if(user!=null) user.m_PlanetShieldEnd=1000*uint("0x"+val);
//trace(user.m_Name,user.m_PlanetShieldEnd.toString(16),val);

			} else if(name=="EmpireSCD") {
				if(user!=null) user.m_PlanetShieldCooldown=1000*uint("0x"+val);
//trace(user.m_Name,user.m_PlanetShieldCooldown.toString(16),val);

			} else if(name=="EmpireSH") {
				if(user!=null) user.m_HourPlanetShield=int(val);

			} else if(name=="EmpirePos") {
				if(user!=null) {
					ar=val.split(",");
					user.m_HomeworldSectorX=ar[0];
					user.m_HomeworldSectorY=ar[1];
					user.m_HomeworldPlanetNum=ar[2];
					user.m_CitadelSectorX=ar[3];
					user.m_CitadelSectorY=ar[4];
					user.m_CitadelPlanetNum=ar[5];
				}
			} else if(name=="EmpireTech") {
//trace(val);
				if(user!=null && user.m_Id!=Server.Self.m_UserId) {
					ar=val.split(",");
					for(u=0;u<user.m_Tech.length;u++) user.m_Tech[u]=0; 
					for(u=0;u<user.m_Tech.length && u<ar.length;u++) {
						user.m_Tech[u]=uint("0x"+ar[u]);
					}
				}

			} else if(name=="EmpireCpt") {
				if(user!=null && user.m_Id!=Server.Self.m_UserId) {
					ar=val.split(",");
					var cptid:uint=ar[1];

					if(user.m_Cpt==null) user.m_Cpt=new Array();
					var cpt:Cpt=null;
					cpt=user.AddCpt(cptid);
					cpt.m_Name=ar[0];
					for(u=0;u<Common.TalentCnt;u++) {
						cpt.m_Talent[u]=uint("0x"+ar[2+u]);
					}
//trace("cptok",cpt.m_Name,cpt.m_Id,cpt.m_Talent[0].toString(),cpt.m_Talent[1].toString(),cpt.m_Talent[2].toString(),cpt.m_Talent[3].toString());
				}

			} else if(name=="EmpireRace") {
				if(user!=null && user.m_Id!=Server.Self.m_UserId) {
					user.m_Race=uint(val);
//trace(user.m_Name,user.m_Race.toString(),val);
				}
			}
		}
		if(user) { 
			user=null;

			SaveUser();

			dispatchEvent(new Event("RecvUser")); 
//			if(m_Map.m_FormChat.visible) m_Map.m_FormChat.Update();
		}
	}*/

	public function SaveUser():void
	{
//trace("SaveUser",user.m_Id,user.m_Name);
/*
		var i,u:int;
		var user:User;
		var user2:User;
		var sl:Array=new Array();
		
		for(i=0;i<m_UserArray.length;i++) {
			user=m_UserArray[i];
			if(user.m_LoadDate==0) continue;

			for(u=0;u<sl.length;u++) {
				user2=sl[u];
				if(user.m_GetTime>user2.m_GetTime) break;
			}
			sl.splice(u,0,user);
			
			if(sl.length>100) sl.splice(100,sl.length-100);
		}

		var str:String="";

		for(i=0;i<sl.length;i++) {
			user=sl[i];
			str+="Id="+user.m_Id+"\n";
			str+="Name="+user.m_Name+"\n";
			str+="LoadDate="+user.m_LoadDate+"\n";
		}

		var so:SharedObject = SharedObject.getLocal("EGUser");
		so.data.val=str;*/
	}

	public function LoadUser(user:User):void
	{
/*		var i:int;

		var so:SharedObject = SharedObject.getLocal("EGUser");
		if(so.size==0) return;

		var find:Boolean=false;

		var al:Array=so.data.val.split("\n");
		for(i=0;i<al.length;i++) {
			if(al[i].length<=0) break;

			var endname:int=al[i].indexOf("=");
			if(endname<0) continue;
			var name:String=al[i].slice(0,endname);
			var val:String=al[i].slice(endname+1);

			if(name=="Id") {
				if(find) return;
				if(int(val)==user.m_Id) find=true;

			} else if(name=="Name") {
				if(find) user.m_Name=val;

			} else if(name=="LoadDate") {
				if(find) user.m_LoadDate=0;//Number(val);
			}
		}*/
	}
	
/*	public function ClearNewId():void
	{
		var i:int;
		var user:User;

		for(i=0;i<m_UserArray.length;i++) {
			user=m_UserArray[i];
			
			user.m_NewId=0;
			user.m_NewId2=0;
		}
	}

	public function QueryNewId(event:TimerEvent=null):void
	{
		var i:int;
		var user:User;

		var ct:Number=Common.GetTime();
		if(ct<m_LockTimeNewId) return;
		if(!Server.Self.IsConnect()) return;
		if(!EmpireMap.Self.IsConnect()) return;
		m_LockTimeNewId=ct+100;

		var val:String="";

		for(i=0;i<m_UserArray.length;i++) {
			user=m_UserArray[i];

			if(EmpireMap.Self.AccessControl(user.m_Id));
			else if(EmpireMap.Self.AccessBuild(user.m_Id));
			else continue;

			var newcntneed:int=0;
			if(user.m_NewId==0) newcntneed++; 
			if(user.m_NewId2==0) newcntneed++;

			if(newcntneed>0) {
				if(val.length>0) val+="_";
				val+=user.m_Id.toString()+"_"+newcntneed.toString();
			}

			if(val.length>64) break;			
		}

		if(val.length<=0) return;

		Server.Self.Query("emnewid","&val="+val,AnswerNewId,false);
	}

	public function AnswerNewId(event:Event):void
	{
		var i:int,cnt:int,u:int;
		var ar:Array;

		m_LockTimeNewId=Common.GetTime()+100;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EmpireMap.Self.ErrorFromServer(buf.readUnsignedByte())) return;

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);
		while(true) {
			var userid:uint=sl.LoadDword();
			if(userid==0) break;

			var newid:uint=sl.LoadDword();
			var newcnt:uint=sl.LoadDword();			

			var user:User=GetUser(userid,false);
			if(user==null) continue;
			if(newcnt<=0) continue;

			if(user.m_NewId==0 && newcnt>0) {
				user.m_NewId=newid;
				newid++;
				newcnt--;
			}

			if(user.m_NewId2==0 && newcnt>0) {
				user.m_NewId2=newid;
				newid++;
				newcnt--;
			}
		}
		sl.LoadEnd();
	}*/

	public function GetUnion(id:uint, testload:Boolean=true, requery:Boolean=true):Union
	{
		if(id==0) return null;

		var union:Union=null;
//trace("GetUser",id);

		if(m_UnionList[id]==undefined) {
			union=new Union();
			union.m_UnionId=id;
			m_UnionArray.push(union);
			m_UnionList[id]=union;
			union.m_GetTime=Common.GetTime();
		} else {
			union=m_UnionList[id];

			if(requery) union.m_GetTime=Common.GetTime();
		}

		if(testload && union.m_LoadDate==0) return null;

		return union;
	}
	
	public function ReloadUnion(id:uint):void
	{
		var union:Union=UserList.Self.GetUnion(id);
		if(union==null) return;
		union.m_LoadDate=Common.GetTime()-60*1000;
	}

	public function QueryUnion():void
	{
		var i:int;
		var union:Union;

		var ct:Number=Common.GetTime();
		if(ct<m_UnionLockTime) return;
		if(!Server.Self.IsConnect()) return;
		if(!EmpireMap.Self.IsConnect()) return;
		m_UnionLockTime=ct+100;

		var val:String="";

		if(m_UnionLoadNextNum>=m_UnionArray.length) m_UnionLoadNextNum=0; 
		for(i=m_UnionLoadNextNum;i<m_UnionArray.length;i++) {
			union=m_UnionArray[i];

			if(union.m_LoadDate==0 || ((ct>union.m_LoadDate+10*1000) && (ct<(union.m_GetTime+60*60*1000)))) {
				union.m_GetTime=0;
				if(val.length>0) val+="_";
				val+=union.m_UnionId.toString()+"_"+union.m_Version.toString()+"_"+union.m_BonusVer.toString();
			}
			if(val.length>64) break;			
		}
		m_UnionLoadNextNum=i;

		if(val.length<=0) return;

		m_UnionLockTime=ct+5000;

		Server.Self.Query("emunion","&val="+val,AnswerUnion,false);
	}

	public function AnswerUnion(event:Event):void
	{
		var i:int,u:int;
		var cptid:uint;
		var la:Loader;
		var loader:URLLoader = URLLoader(event.target);

		m_UnionLockTime=Common.GetTime()+100;

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion00 ", buf.length, ServerSocket.ByteArrayToString(buf));

		if(EmpireMap.Self.ErrorFromServer(buf.readUnsignedByte())) return;

		var ba:ByteArray=new ByteArray();

		while(true) {
			var unionid:uint=buf.readUnsignedInt();
			if(unionid==0) break;
			var union:Union=GetUnion(unionid,false);
			union.m_LoadDate=Common.GetTime();

			var ver:uint=buf.readUnsignedInt();
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion01", unionid,ver);
			if(ver!=0) {
				union.m_BonusVer = ver;
				union.m_BonusCotlCnt = buf.readInt();
				for(i=0;i<Common.CotlBonusCnt;i++) union.m_Bonus[i]=0; 
				while(true) {
					var bt:int=buf.readUnsignedByte();
					if(bt==0) break;
					union.m_Bonus[bt]=buf.readInt();
//if(EmpireMap.Self.m_Debug) trace("Bonus",bt,union.m_Bonus[bt]);
				}
			}

			ver=buf.readUnsignedInt();
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion02",ver);
			if(ver==0) continue;
			
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion03");
			union.m_Version=ver;

			union.m_MemberVersion = buf.readUnsignedInt();
			
			union.m_Type = buf.readUnsignedByte();

			var len:int=buf.readUnsignedByte();
			union.m_Name=buf.readUTFBytes(len);
//if(EmpireMap.Self.m_Debug) trace("Name:",union.m_Name);

			len=buf.readUnsignedByte();
			union.m_NameEng=buf.readUTFBytes(len);
//if(EmpireMap.Self.m_Debug) trace("NameEng:",union.m_NameEng);

			union.m_Lang=buf.readByte();
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion04");

			//union.m_Emblem=null;
			len=buf.readShort();
			while(len>0) { 
				ba.length=0;
				buf.readBytes(ba,0,len);
				ba.position=0;
				la=new Loader(); 
				union.m_EmblemLoader=la;
				la.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadEmblem);
				la.loadBytes(ba);

				//if(!(la.content is BitmapData)) break;

				//union.m_Emblem=la.content as BitmapData;
				break;
			}

//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion05");
			//union.m_EmblemSmall=null;
			len=buf.readShort();
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion05.01",len,buf.length-buf.position);
//trace("ES00",len);
			while(len>0) { 
				ba.length=0;
				buf.readBytes(ba,0,len);
				ba.position=0;
//trace("ES01",ba.length);
				la=new Loader();
				union.m_EmblemSmallLoader=la; 
				la.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoadEmblem);
				la.loadBytes(ba);
//trace("ES02",la.content);

				//if(!(la.content is BitmapData)) break;

				//union.m_EmblemSmall=la.content as BitmapData;
//trace("ES03",union.m_EmblemSmall.width,union.m_EmblemSmall.height);
				break;
			}
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion06");

			len=buf.readUnsignedShort();
			union.m_Desc=buf.readUTFBytes(len);

			len=buf.readUnsignedShort();
			union.m_DescEng=buf.readUTFBytes(len);

			len=buf.readUnsignedShort();
			union.m_Site=buf.readUTFBytes(len);

			union.m_CreateDate=1000*buf.readUnsignedInt();
			union.m_RootAdmin=buf.readUnsignedInt();

			len=buf.readUnsignedShort();
			union.m_Info=buf.readUTFBytes(len);
//if(EmpireMap.Self.m_Debug) trace("Info:",len,union.m_Info);

			len=buf.readUnsignedShort();
			union.m_Hello=buf.readUTFBytes(len);
//if(EmpireMap.Self.m_Debug) trace("Hello:",len,union.m_Hello);

			len=buf.readUnsignedShort();
			union.m_RankDesc=buf.readUTFBytes(len);
//if(EmpireMap.Self.m_Debug) trace("!!!AnswerUnion07");
			
			if (EmpireMap.Self.m_FormUnion.visible && EmpireMap.Self.m_FormUnion.m_UnionId == unionid) EmpireMap.Self.m_FormUnion.PageUpdate(); 
			if (EmpireMap.Self.m_FormPactList.visible) EmpireMap.Self.m_FormPactList.UpdateName();
		}
	}
	
	private function completeLoadEmblem(event:Event):void
	{
		var li:LoaderInfo=event.target as LoaderInfo;

		var i:int;
		var union:Union;
//trace("CLE00");
		
		for(i=0;i<m_UnionArray.length;i++) {
			union=m_UnionArray[i];
			if(union.m_EmblemSmallLoader==li.loader) {
//trace("CLE01",li.content);
				union.m_EmblemSmallLoader=null;
				if(li.content is Bitmap) {
					union.m_EmblemSmall = (li.content as Bitmap).bitmapData;
					union.CreateEmblemTexture();
//trace("CLE02",union.m_EmblemSmall.width,union.m_EmblemSmall.height);
				}
				else union.m_EmblemSmall=null;
				
				if(EmpireMap.Self.m_FormUnion.visible && EmpireMap.Self.m_FormUnion.m_UnionId==union.m_UnionId) EmpireMap.Self.m_FormUnion.PageUpdate();
			}
			else if(union.m_EmblemLoader==li.loader) {
//trace("CLE03",li.content);
				union.m_EmblemLoader=null;
				if(li.content is Bitmap) {
					union.m_Emblem=(li.content as Bitmap).bitmapData;
//trace("CLE04",union.m_Emblem.width,union.m_Emblem.height);
				}
				else union.m_Emblem=null;
				
				if(EmpireMap.Self.m_FormUnion.visible && EmpireMap.Self.m_FormUnion.m_UnionId==union.m_UnionId) EmpireMap.Self.m_FormUnion.PageUpdate();
			}
		}
	}
	
	public function GetUnionMember(id:uint):ByteArray
	{
		var un:Union=GetUnion(id);
		if(un==null) return null;
		
		if(un.m_MemberLoadVersion!=un.m_MemberVersion) {
			un.m_MemberLoadVersion=un.m_MemberVersion;
			Server.Self.Query("emunionmember","&val="+id.toString(),AnswerUnionMember,false);
		}
		
		return un.m_MemberList;
	}
	
	public function AnswerUnionMember(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EmpireMap.Self.ErrorFromServer(buf.readUnsignedByte())) return;

		var unionid:uint=buf.readUnsignedInt();
		var ver:uint=buf.readUnsignedInt();
		
		var un:Union=GetUnion(unionid);
		if(un==null) return;

		un.m_MemberLoadVersion=ver;

		if(un.m_MemberList==null) {
			un.m_MemberList=new ByteArray();
			un.m_MemberList.endian=Endian.LITTLE_ENDIAN;
		}

		un.m_MemberList.length=0;
		buf.readBytes(un.m_MemberList,0,buf.length-buf.position);
//trace("MemberList:",un.m_MemberList.length);

		if(EmpireMap.Self.m_FormUnion.visible && EmpireMap.Self.m_FormUnion.m_UnionId==unionid) EmpireMap.Self.m_FormUnion.UpdateMemberList();  
	}

	public function GetItem(id:uint, testload:Boolean=true, requery:Boolean=true):Item
	{
		id &= 0xffff;
		if(id==0) return null;
		
		var item:Item=null;
		
		if(m_ItemList[id]==undefined) {
			item=new Item();
			item.m_Id=id;
			m_ItemArray.push(item);
			m_ItemList[id]=item;
			item.m_GetTime=Common.GetTime();
		} else {
			item=m_ItemList[id];
			
			if(requery) item.m_GetTime=Common.GetTime();
		}
		
		if(testload && item.m_LoadDate==0) return null;
		
		return item;
	}
	
	public function QueryItem():void
	{
		var i:int;
		var item:Item;
		
		var ct:Number=Common.GetTime();
		if(ct<m_ItemLockTime) return;
		if(!Server.Self.IsConnect()) return;
		if(!EmpireMap.Self.IsConnect()) return;
		m_ItemLockTime=ct+100;
		
		var val:String="";
		
		if(m_ItemLoadNextNum>=m_ItemArray.length) m_ItemLoadNextNum=0; 
		for(i=m_ItemLoadNextNum;i<m_ItemArray.length;i++) {
			item=m_ItemArray[i];
			
			if(item.m_LoadDate==0 || ((ct>item.m_LoadDate+10*1000) && (ct<(item.m_GetTime+60*60*1000)))) {
				item.m_GetTime=0;
				if(val.length>0) val+="_";
				val+=item.m_Id.toString();
			}
			if(val.length>64) break;			
		}
		m_ItemLoadNextNum=i;
		
		if(val.length<=0) return;
		
		m_ItemLockTime=ct+5000;
		
		Server.Self.Query("emitem","&val="+val,AnswerItem,false);
	}
	
	public function AnswerItem(event:Event):void
	{
		var i:int,u:int;
		var cptid:uint;
		var la:Loader;
		var loader:URLLoader = URLLoader(event.target);
		
		m_ItemLockTime=Common.GetTime()+100;
		
		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		//trace("AnswerUnion:",buf.length);

		if(EmpireMap.Self.ErrorFromServer(buf.readUnsignedByte())) return;

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		var ba:ByteArray=new ByteArray();

		var itmrecv:Boolean=false;

		while(true) {
			var itemid:uint=sl.LoadDword();
			if(itemid==0) break;
			var item:Item=GetItem(itemid,false);
			item.m_LoadDate=Common.GetTime();

			var ver:int=sl.LoadInt();
			if(ver==0) continue;

			itmrecv=true;

			item.m_SlotType = sl.LoadInt();
			//item.m_StackMax=sl.LoadInt();
			item.m_Lvl = sl.LoadInt();
			item.m_StackMax = sl.LoadInt();
			item.m_Img = sl.LoadDword();
			item.m_Step = sl.LoadInt();
			item.m_OwnerId = sl.LoadDword();

			for(i=0;i<Item.BonusCnt;i++) {
				item.m_BonusType[i] = sl.LoadDword();
				item.m_BonusVal[i] = sl.LoadInt();
				item.m_BonusDif[i] = sl.LoadInt();
			}

//			if(EmpireMap.Self.m_FormUnion.visible && EmpireMap.Self.m_FormUnion.m_UnionId==unionid) EmpireMap.Self.m_FormUnion.PageUpdate(); 
		}

		sl.LoadEnd();

		if(itmrecv) {
			if (EmpireMap.Self.m_FormItemManager.visible) EmpireMap.Self.m_FormItemManager.UpdateItem();
			if (EmpireMap.Self.m_FormFleetBar.visible) EmpireMap.Self.m_FormFleetBar.Update();
			if (EmpireMap.Self.m_FormFleetItem.visible) EmpireMap.Self.m_FormFleetItem.Update();
			if (EmpireMap.Self.m_FormPlanet.visible) EmpireMap.Self.m_FormPlanet.Update();
			if (EmpireMap.Self.m_FormStorage.visible) EmpireMap.Self.m_FormStorage.Update();
		}
	}
	
	public function ItemClear():void
	{
		var i:int;
		for(i=0;i<m_ItemArray.length;i++) {
			var item:Item=m_ItemArray[i];
			if(item==null) continue;
			item.m_LoadDate=0;
		}
	}
}

}
