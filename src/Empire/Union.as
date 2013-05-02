package Empire
{
import Base.*;
import Engine.*;
import flash.display.*;
import flash.display3D.textures.Texture;
import flash.geom.*;
import flash.system.*;
import flash.utils.*;

public class Union
{
	static public const AccessHeader:uint=1<<0;  
	static public const AccessInfo:uint=1<<1;
	static public const AccessInvite:uint=1<<2;
	static public const AccessExclusion:uint=1<<3;
	static public const AccessRank:uint=1<<4;
	static public const AccessAccess:uint=1<<5;
	static public const AccessChatEdit:uint=1<<6;

	public var m_UnionId:uint=0;
	public var m_Version:uint=0;
	public var m_MemberVersion:uint = 0;
	public var m_Type:int = 0;
	public var m_Name:String;
	public var m_NameEng:String;
	public var m_Lang:int=0;
	public var m_Emblem:BitmapData=null;
	public var m_EmblemSmall:BitmapData=null;
	public var m_Desc:String;
	public var m_DescEng:String;
	public var m_Site:String;
	public var m_CreateDate:Number=0;
	public var m_RootAdmin:uint=0;
	public var m_Info:String;
	public var m_Hello:String;
	public var m_RankDesc:String;

	public var m_LoadDate:Number=0;
	public var m_GetTime:Number=0;

	public var m_EmblemLoader:Loader = null;
	public var m_EmblemSmallLoader:Loader = null;
	
	public var m_EmblemTexture:Texture = null;

	public var m_MemberLoadVersion:uint=0;
	public var m_MemberList:ByteArray=null;
	
	public var m_Bonus:Array=new Array(Common.CotlBonusCnt);
	public var m_BonusVer:uint = 0;
	public var m_BonusCotlCnt:int = 0;

	public function Union()
	{
		var i:int;
		for(i=0;i<Common.CotlBonusCnt;i++) m_Bonus[i]=0;
	}

	public function GetDesc(num:int):String
	{
		var sme:int=0;
		var len:int=m_RankDesc.length;

		while(num>=1) {
			while(sme<len) {
				if(m_RankDesc.charCodeAt(sme)==126) break; //~
				sme++;
			}
			if(sme>=len) return "";
			num--;
			sme++;
		}
		var start:int=sme;

		while(sme<len) {
			if(m_RankDesc.charCodeAt(sme)==126) break;
			sme++;
		}
		return m_RankDesc.substr(start,sme-start);
	}

	public function NameUnion():String { var s:String=GetDesc(0); if(s.length>0) return s; return Common.Txt.FormUnionNameUnion; }
	public function NameRank():String { var s:String=GetDesc(2); if(s.length>0) return s; return Common.Txt.FormUnionNameRank; }
	public function NameAdmin():String { var s:String=GetDesc(4); if(s.length>0) return s; return Common.Txt.FormUnionNameAdmin; }
	public function ValRank(i:int):String {
		var s:String=GetDesc(6+i*2);
		if(s.length>0) return s;
		if(i==0) return Common.Txt.FormUnionNameRank0;
		else if(i==1) return Common.Txt.FormUnionNameRank1;
		else if(i==2) return Common.Txt.FormUnionNameRank2;
		else if(i==3) return Common.Txt.FormUnionNameRank3;
		else if(i==4) return Common.Txt.FormUnionNameRank4;
		return "unknown";
	}
	
	public function CreateEmblemTexture():void
	{
		if (m_EmblemTexture != null) {
			m_EmblemTexture.dispose();
			m_EmblemTexture = null;
		}

		if (m_EmblemSmall == null) return;

		var bm:BitmapData = new BitmapData(32, 32, true, 0x00000000);
		bm.draw(m_EmblemSmall);

		m_EmblemTexture = C3D.CreateTextureFromBM(bm, false);
	}
	
}

}
