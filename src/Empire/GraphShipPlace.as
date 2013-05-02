package Empire
{
import Base.*;
import Engine.*;
import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

public class GraphShipPlace //extends MovieClip
{
	private var m_Map:EmpireMap;

	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_ShipNum:int;

	public var m_ShipType:int;

	public var m_Tmp:int;

//	private var m_BG:MovieClip;
//	private var m_Ship:Sprite;

//	public var m_Cnt:TextField;

	public function GraphShipPlace(map:EmpireMap, x:int, y:int, pn:int, sn:int)
	{
		m_Map=map;
		m_SectorX=x;
		m_SectorY=y;
		m_PlanetNum=pn;
		m_ShipNum=sn;
		m_ShipType=-1;
//		m_Cnt=null;

//		var planet:Planet=m_Map.GetPlanet(x,y,pn);
//		if(planet!=null && (planet.m_Flag & Planet.PlanetFlagWormhole) && !(sn & 1)) m_BG=new GraphShipPlace2();
//		else m_BG=new GraphShipPlace1();

//		addChild(m_BG);
	}

	public function Clear():void
	{
//		if(m_Cnt!=null) {
//			m_Map.m_TxtLayer.removeChild(m_Cnt);
//			m_Cnt=null;
//		}
	}

	public function Update():void
	{
/*
  		var pl:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if(pl==null) return;
		var ar:Array=m_Map.CalcShipPlace(pl,m_ShipNum);

		x = m_Map.WorldToScreenX(ar[0], ar[1]);
		y = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(ar[1]);

		if(m_Cnt!=null) {
			m_Cnt.x=x-10-m_Cnt.width/2;
			m_Cnt.y=y-20;
		}

		if(m_Ship!=null) {
			if(Common.IsBase(m_ShipType)) m_Ship.rotation=0;
			else m_Ship.rotation=ar[2]*180.0/Math.PI;
			
			var a:Number=(Common.GetTime() % 1000)/1000;
			if(a<0.5) a=a*2.0;
			else a=(1.0-a)*2.0;
			//m_Ship.alpha=0.5+0.5*a;
			
			alpha=0.3+0.5*a;
		}*/
	}

	public function SetType(t:int):void
	{	
		if(m_ShipType==t) return;
		m_ShipType=t;

//		if(m_Ship!=null) {
//			removeChild(m_Ship);
//			m_Ship=null;
//		}
//		m_Ship=GraphShip.GetImageByType(m_ShipType,m_Map.RaceByOwner(Server.Self.m_UserId));
//		addChild(m_Ship);
	}

//	public function SetColor(clr:uint):void
//	{
//		if(m_Cnt) m_Cnt.backgroundColor=clr;
//	}

/*	public function SetCnt(str:String):void
	{
		if(str.length<=0) {
			if(m_Cnt!=null) {
				m_Map.m_TxtLayer.removeChild(m_Cnt);
				m_Cnt=null;
			}
			return;
		}

		if(!m_Cnt) {
			m_Cnt=new TextField();
			m_Cnt.width=1;
			m_Cnt.height=1;
			m_Cnt.type=TextFieldType.DYNAMIC;
			m_Cnt.selectable=false;
			m_Cnt.textColor=0xffffff;
			m_Cnt.background=true;
			m_Cnt.backgroundColor=0x80404040;
			m_Cnt.multiline=false;
			m_Cnt.autoSize=TextFieldAutoSize.LEFT;
			m_Cnt.gridFitType=GridFitType.NONE;
			m_Cnt.defaultTextFormat=new TextFormat("Calibri",12,0xffffff);//m_Map.MyFont.defaultTextFormat;
			m_Cnt.embedFonts=true;
			
			m_Map.m_TxtLayer.addChild(m_Cnt);
		}

		if(m_Cnt.text==str) return;
		m_Cnt.text=str;
	}*/
	
	public function Draw():void
	{
		if (GraphPlanet.TexSun() == null) return;

  		var pl:Planet = m_Map.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (pl == null) return;

		EmpireMap.Self.CalcShipPlaceEx(pl, m_ShipNum, EmpireMap.m_TPos);

		var x:Number = m_Map.WorldToScreenX(EmpireMap.m_TPos.x, EmpireMap.m_TPos.y);
		var y:Number = EmpireMap.m_TWSPos.y;

		var fromx:int = 1029;
		//if (Common.IsLowOrbit(m_ShipNum)) fromx = 1063;
		if (m_ShipNum >= pl.ShipOnPlanetLow) fromx = 1063;
		else if ((pl.m_Flag & Planet.PlanetFlagWormhole) && !(m_ShipNum & 1)) fromx = 1063;
		
		var ww:Number = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
		ww = 32.0 * ww;
		if (ww > 32) ww = 32;

		C3D.DrawImg(GraphPlanet.TexSun(), 0xffffffff, x - ww * 0.5, y - ww * 0.5, ww, ww, fromx, 1720, 32, 32);
	}
}

}
