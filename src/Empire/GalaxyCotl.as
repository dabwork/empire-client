package Empire
{
import flash.display.*;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class GalaxyCotl extends Sprite
{
	private var m_Map:EmpireMap=null;
	
	public var m_CotlId:int=0;

	public var m_CurSprite:Sprite=null;
	public var m_Name:TextField=null;
	public var m_Name2:TextField=null;
	public var m_RatingTxt:TextField=null;
	public var m_ExitDateTxt:TextField=null;
	
	public var m_TargetList:Array=new Array();
	public var m_TargetShow:Boolean=false;
	
	public var m_CurShow:int=0;
	
	public var m_Tmp:int=0;
	
	public function GalaxyCotl(map:EmpireMap)
	{
		m_Map=map;

		m_Map.m_FormGalaxy.m_CotlLayer.addChild(this);
		
		m_Name=new TextField();
		m_Name.width=1;
		m_Name.height=1;
		m_Name.type=TextFieldType.DYNAMIC;
		m_Name.selectable=false;
		m_Name.textColor=0xffffff;
		m_Name.background=true;
		m_Name.backgroundColor=0x80000000;
		m_Name.alpha=1.0;
		m_Name.multiline=false;
		m_Name.autoSize=TextFieldAutoSize.LEFT;
		m_Name.gridFitType=GridFitType.NONE;
		m_Name.defaultTextFormat=new TextFormat("Calibri",13,0xAfAfAf);
		m_Name.embedFonts=true;
		addChild(m_Name);

		m_Name2=new TextField();
		m_Name2.width=1;
		m_Name2.height=1;
		m_Name2.type=TextFieldType.DYNAMIC;
		m_Name2.selectable=false;
		m_Name2.textColor=0xffffff;
		m_Name2.background=true;
		m_Name2.backgroundColor=0x80000000;
		m_Name2.alpha=1.0;
		m_Name2.multiline=false;
		m_Name2.autoSize=TextFieldAutoSize.LEFT;
		m_Name2.gridFitType=GridFitType.NONE;
		m_Name2.defaultTextFormat=new TextFormat("Calibri",15,0xffff00);
		m_Name2.embedFonts=true;
		addChild(m_Name2);

		m_RatingTxt=new TextField();
		m_RatingTxt.width=1;
		m_RatingTxt.height=1;
		m_RatingTxt.type=TextFieldType.DYNAMIC;
		m_RatingTxt.selectable=false;
		m_RatingTxt.textColor=0xffffff;
		m_RatingTxt.background=true;
		m_RatingTxt.backgroundColor=0x80000000;
		m_RatingTxt.alpha=1.0;
		m_RatingTxt.multiline=false;
		m_RatingTxt.autoSize=TextFieldAutoSize.LEFT;
		m_RatingTxt.gridFitType=GridFitType.NONE;
		m_RatingTxt.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_RatingTxt.embedFonts=true;
		addChild(m_RatingTxt);

		m_ExitDateTxt=new TextField();
		m_ExitDateTxt.width=1;
		m_ExitDateTxt.height=1;
		m_ExitDateTxt.type=TextFieldType.DYNAMIC;
		m_ExitDateTxt.selectable=false;
		m_ExitDateTxt.textColor=0xffffff;
		m_ExitDateTxt.background=true;
		m_ExitDateTxt.backgroundColor=0x80404000;
		m_ExitDateTxt.alpha=1.0;
		m_ExitDateTxt.multiline=false;
		m_ExitDateTxt.autoSize=TextFieldAutoSize.LEFT;
		m_ExitDateTxt.gridFitType=GridFitType.NONE;
		m_ExitDateTxt.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_ExitDateTxt.embedFonts=true;
		addChild(m_ExitDateTxt);

		mouseEnabled=false;
		mouseChildren=false;
	}
	
	public function Clear():void
	{
		var i:int;
		m_Map.m_FormGalaxy.m_CotlLayer.removeChild(this);
		
		for(i=0;i<m_TargetList.length;i++) {
			if(m_TargetList[i]==undefined || m_TargetList[i]==null) continue;
			removeChild(m_TargetList[i]);
			m_TargetList[i]=null;
		}
	}
	
	public function SetName(str:String):void
	{
		if(str==null) str='';
		if(m_Name.text==str) return;
		m_Name.text=str;
	}

	public function SetName2(str:String):void
	{
		if(str==null) str='';
		if(m_Name2.text==str) return;
		m_Name2.text=str;
	}

	public function TargetShow(v:Boolean):void
	{
		m_TargetShow=v;
	}

	public function CurShow(v:int):void
	{
		if(v==m_CurShow) return;
		m_CurShow=v;
		if(m_CurSprite!=null) {
			removeChild(m_CurSprite);
			m_CurSprite=null;
		}
		if(v==0) return;

		if(v==1) {
			m_CurSprite=new GraphShipPlace2();
			m_CurSprite.alpha=0.3;
			addChildAt(m_CurSprite,0);
		} else if(v==2) {
			m_CurSprite=new GraphShipPlace2();
			m_CurSprite.alpha=0.13;
			addChildAt(m_CurSprite,0);
		} else {
			m_CurSprite=new GraphShipPlace1();
			m_CurSprite.alpha=0.13;
			addChildAt(m_CurSprite,0);
		}
		if(m_CurSprite!=null) {
			m_CurSprite.mouseEnabled=false;
			m_CurSprite.mouseChildren=false;
		}
	}

	public function Update():void
	{
/*		var i:int;
		var ra:Array;
		
		var cotl:Cotl=m_Map.m_FormGalaxy.GetCotl(m_CotlId);
		if(cotl==null) return;
		
		var rs:Number=m_Map.m_FormGalaxy.WorldToMapR(Common.EmpireCotlSizeToRadius(cotl.m_Size));

		x=m_Map.m_FormGalaxy.WorldToMapX(cotl.m_X);
		y=m_Map.m_FormGalaxy.WorldToMapY(cotl.m_Y);

		var user:User=UserList.Self.GetUser(cotl.m_OwnerId);
//if(user!=null) trace(user.m_Name);

		var tstr:String="";
		if(cotl.m_Type==Common.CotlTypeRich) tstr+=Common.Txt.CotlRich;
		else if(cotl.m_Type==Common.CotlTypeUser) tstr+=Common.Txt.CotlUser;
		SetName(tstr);

		tstr="";
		if(Common.CotlName[m_CotlId]!=undefined) tstr+=Common.CotlName[m_CotlId];
		else if(user!=null && user.m_Name.length>0) tstr+=user.m_Name;
		SetName2(tstr);
		
		if(cotl.m_Type==Common.CotlTypeUser && user!=null) {
			m_RatingTxt.text=user.m_Rating.toString();
			m_RatingTxt.visible=true;
			
			if(m_Map.TestRatingFlyCotl(user.m_Id)) m_RatingTxt.backgroundColor=0x008000; 
			else m_RatingTxt.backgroundColor=0x800000;

		} else {
			m_RatingTxt.visible=false;
		}
		
		if(user!=null && user.m_ExitDate!=0) {
			m_ExitDateTxt.text=Common.FormatPeriod((user.m_ExitDate-m_Map.GetServerTime())/1000)
			m_ExitDateTxt.visible=true;
		} else {
			m_ExitDateTxt.visible=false;
		}
	
		var r:Number=m_Map.m_FormGalaxy.WorldToMapR(cotl.m_StarMaxY);
		m_Name.x=-(m_Name.width>>1);
		m_Name.y=-m_Name.height;//r;
		m_Name2.x=-(m_Name2.width>>1);
		m_Name2.y=m_Name.y+m_Name.height;
		m_RatingTxt.x=-(m_RatingTxt.width>>1);
		m_RatingTxt.y=m_Name2.y+m_Name2.height+10;
		
		m_ExitDateTxt.x=rs*Math.sin(-Math.PI*0.75)-(m_ExitDateTxt.width>>1);
		m_ExitDateTxt.y=rs*Math.cos(-Math.PI*0.75)-(m_ExitDateTxt.height>>1);

		//r=m_Map.m_FormGalaxy.WorldToMapR(Common.RG_CotlRadius);
		if(m_CurSprite!=null) {
			var scale:Number=rs/15.0;
			m_CurSprite.scaleX=scale;
			m_CurSprite.scaleY=scale;
		}

		if(m_TargetShow) {
			var slotcnt:int=cotl.m_SlotCnt;
			if(slotcnt<=0) slotcnt=3;

			for(i=0;i<slotcnt;i++) {
				if(i>=m_TargetList.length) {
					m_TargetList.push(new GraphShipPlace1());
					addChild(m_TargetList[i]);
				}
				if(m_TargetList[i]==undefined || m_TargetList[i]==null) {
					m_TargetList[i]=new GraphShipPlace1();
					addChild(m_TargetList[i]);
				} 
				var s:Sprite=m_TargetList[i];
				
				ra=CalcSlotPos(i);
				s.x=ra[0]-x;
				s.y=ra[1]-y;

//				var fr:Number=r*0.8;
//				if(i & 1) fr*=0.8;
//				s.x=fr*Math.sin(i/Common.SlotOnCotl*Math.PI*2.0);
//				s.y=fr*Math.cos(i/Common.SlotOnCotl*Math.PI*2.0);
			}
		} else {
			for(i=0;i<m_TargetList.length;i++) {
				if(m_TargetList[i]==undefined || m_TargetList[i]==null) continue;
				removeChild(m_TargetList[i]);
				m_TargetList[i]=null;
			}
		}*/
	}
	
	public function CalcSlotPos(i:int):Array
	{
		var cotl:Cotl=m_Map.m_FormGalaxy.GetCotl(m_CotlId);
		if(cotl==null) return null;

		var r:Number=m_Map.m_FormGalaxy.WorldToMapR(Common.EmpireCotlSizeToRadius(cotl.m_Size));
		
		if(cotl.m_Type==Common.CotlTypeRich) {
			//var k:Number=r*0.20;
			//return [x+(r-k-i*k)*Math.sin(-Math.PI*0.75),y+(r-k-i*k)*Math.cos(-Math.PI*0.75)];
			return [x+(-1+i)*r*0.4,y-r*0.6];
		}
		
		var slotcnt:int=cotl.m_SlotCnt;
		if(slotcnt<=16) slotcnt=16;
		
		var fr:Number=r*0.9;
		var t:int=i % 3;
		if(t==1) fr*=0.8;
		else if(t==2) fr*=0.55;
		return [x+fr*Math.sin(i/slotcnt*Math.PI*2.0), y-fr*Math.cos(i/slotcnt*Math.PI*2.0)];
	}
}

}