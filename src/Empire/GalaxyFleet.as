package Empire
{
import flash.display.*;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class GalaxyFleet extends Sprite
{
	private var m_Map:EmpireMap=null;

	public var m_CptId:int=0;
	
	public var m_Race:int=Common.RaceNone;
	public var m_Face:int=0;

	public var m_Ship:Sprite=null;
	public var m_Img:Bitmap=null;
	public var m_Cur:Sprite=null;
	
	public var m_Tmp:int=0;

	public var m_Name:TextField=null;
	public var m_Time:TextField=null;

	public function GalaxyFleet(map:EmpireMap)
	{
		m_Map=map;
		
		m_Map.m_FormGalaxy.m_FleetLayer.addChild(this);
		
//		var cl:Class=ApplicationDomain.currentDomain.getDefinition("ImgFlagship") as Class;
//		m_Ship=new cl();
//		m_Ship.scaleX=0.3;
//		m_Ship.scaleY=0.3;
//		addChild(m_Ship);

		m_Ship=new GrFrame();
		m_Ship.width=40;
		m_Ship.height=60;
		addChild(m_Ship);
		
		
		m_Img=new Bitmap();
		addChild(m_Img);
		
		m_Cur=new Sprite();
		addChild(m_Cur);
		
		var size:Number=5;
		var rx:Number=22;
		var ry:Number=32;
		var tx:Number=0;
		var ty:Number=0;

		m_Cur.graphics.lineStyle(1.5,0xffffff,1.0,true);

		m_Cur.graphics.moveTo(tx-rx,ty-ry+size);
		m_Cur.graphics.lineTo(tx-rx,ty-ry);
		m_Cur.graphics.lineTo(tx-rx+size,ty-ry);

		m_Cur.graphics.moveTo(tx+rx,ty-ry+size);
		m_Cur.graphics.lineTo(tx+rx,ty-ry);
		m_Cur.graphics.lineTo(tx+rx-size,ty-ry);

		m_Cur.graphics.moveTo(tx-rx,ty+ry-size);
		m_Cur.graphics.lineTo(tx-rx,ty+ry);
		m_Cur.graphics.lineTo(tx-rx+size,ty+ry);

		m_Cur.graphics.moveTo(tx+rx,ty+ry-size);
		m_Cur.graphics.lineTo(tx+rx,ty+ry);
		m_Cur.graphics.lineTo(tx+rx-size,ty+ry);

		m_Name=new TextField();
		m_Name.width=1;
		m_Name.height=1;
		m_Name.type=TextFieldType.DYNAMIC;
		m_Name.selectable=false;
		m_Name.textColor=0xffffff;
		m_Name.background=true;;
		m_Name.backgroundColor=0x80000000;
		m_Name.alpha=0.7;
		m_Name.multiline=false;
		m_Name.autoSize=TextFieldAutoSize.LEFT;
		m_Name.gridFitType=GridFitType.NONE;
		m_Name.defaultTextFormat=new TextFormat("Calibri",12,0xffffff);
		m_Name.embedFonts=true;
		m_Map.m_FormGalaxy.m_TxtLayer.addChild(m_Name);

		m_Time=new TextField();
		m_Time.width=1;
		m_Time.height=1;
		m_Time.type=TextFieldType.DYNAMIC;
		m_Time.selectable=false;
		m_Time.textColor=0xffffff;
		m_Time.background=true;
		m_Time.backgroundColor=0x800000ff;
		m_Time.alpha=0.7;
		m_Time.multiline=false;
		m_Time.autoSize=TextFieldAutoSize.LEFT;
		m_Time.gridFitType=GridFitType.NONE;
		m_Time.defaultTextFormat=new TextFormat("Calibri",12,0xffffff);
		m_Time.embedFonts=true;
		m_Time.visible=false;
		m_Map.m_FormGalaxy.m_TxtLayer.addChild(m_Time);
	}

	public function Clear():void
	{
		m_Map.m_FormGalaxy.m_FleetLayer.removeChild(this);

		if(m_Ship!=null) {
			removeChild(m_Ship);
			m_Ship=null;
		}
		if(m_Img!=null) {
			removeChild(m_Img);
			m_Img=null;
		}
		if(m_Name!=null) {
			m_Map.m_FormGalaxy.m_TxtLayer.removeChild(m_Name);
			m_Name=null;
		}
		if(m_Time!=null) {
			m_Map.m_FormGalaxy.m_TxtLayer.removeChild(m_Time);
			m_Time=null;
		}
	}

	public function SetName(str:String):void
	{
		if(str==null) str='';
		if(m_Name.text==str) return;
		m_Name.text=str;
	}

	public function SetTime(str:String):void
	{
		if(str==null) str='';
		if(m_Time.text==str) return;
		m_Time.text=str;
		m_Time.visible=str.length>0;
	}
	
	public function SetFace(race:int, face:int):void
	{
		if(m_Race==race && m_Face==face) return;
		m_Race=race;
		m_Face=face;
		
		var clname:String=(m_Face % Common.RaceFaceCnt[m_Race]).toString();
		if(clname.length==1) clname="0"+clname;
		clname="Face"+Common.RaceSysName[m_Race]+clname;

		var cl:Class=ApplicationDomain.currentDomain.getDefinition(clname) as Class;
		m_Img.bitmapData=new cl(0,0);//93>>2,104>>2);
		m_Img.scaleX=0.4;
		m_Img.scaleY=0.4;
		m_Img.x=-(m_Img.width>>1);
		m_Img.y=15-m_Img.height;
	
		m_Ship.x=m_Img.x-2;	
		m_Ship.y=m_Img.y-2;
		m_Ship.width=m_Img.width+4;
		m_Ship.height=m_Img.height+4;
	}
	
	public function SetCur(v:Boolean):void
	{
		m_Cur.visible=v;
	}
	
	public function SetColor(v:uint):void
	{
		m_Name.backgroundColor=v;
	}
	
	public function Update(px:Number, py:Number):void
	{
		x=px;
		y=py;
		m_Name.x=x-(m_Name.width>>1);
		m_Name.y=y+17;
		
		m_Time.x=x+20-(m_Time.width>>1);
		m_Time.y=y-40;
	}
}

}
