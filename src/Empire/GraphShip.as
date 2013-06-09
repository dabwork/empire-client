// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import Base.*;
import Engine.*;
import flash.display.*;
import flash.display3D.*;
import flash.display3D.textures.Texture;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class GraphShip// extends Sprite
{
	private var m_Map:EmpireMap;
	
	public var m_NewNum:int = 0;
	private static var m_NewNumLast:int = 0;

	public var x:Number = 0;
	public var y:Number = 0;

	public var m_Owner:uint;
	public var m_Id:uint;	
	public var m_Type:int;
	public var m_SubType:int;
	public var m_Race:int;
	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_ShipNum:int;
	public var m_ShipNumLO:Boolean;
	public var m_Tmp:int;
	
	public var m_ItemType:int;
	public var m_ItemNum:int = 0;
	
	public var m_Flag:uint;
	public var m_FromSectorX:int;
	public var m_FromSectorY:int;
	public var m_FromPlanet:int;
	public var m_FromPlace:int;

	public var m_PointsType:int = 0;
	public var m_PointsVal:String = null;
	public var m_PointsImgNum:int = 0;
	
	public var m_PosX:Number;
	public var m_PosY:Number;
	public var m_Angle:Number;

	public var m_ArrivalTime:Number;

	public var m_LastTime:Number;

	public var m_FireTime:Number;
	public var m_FireTime2:Number;
	
	public var m_Battle:Boolean = false;
	public var m_NoBattle:Boolean = false;
	
	public var m_Clr:uint=0;
	
	public var m_BuildState:int = 0;
	public var m_BuildStateClr:uint = 0;
	public var m_EffectType:int=0;
	public var m_InvuOn:Boolean=false;
	
	public var m_Stealth:int=0;
	
	public var m_Prymo:Boolean=true;
	
	public var m_FirstInit:Boolean=true;
	public var m_AlphaVis:Number = 1.0;
	
	public var m_HPBarVal:int = 0;
	public var m_HPBarMax:int = 0;
	public var m_HPBarState:int = 0;

	public var m_ShieldBarVal:int = 0;
	public var m_ShieldBarMax:int = 0;
	public var m_ShieldBarState:int = 0;

	public static var m_TexShips:C3DTexture = null;

//	public var m_NameTL:C3DTextLine = null;
	
	public static var m_NameTF:TextField = null;
	public static var m_NameTest:Bitmap = null;
	public static var m_NameMatrix:Matrix = new Matrix();
	
	public var m_CntVal:String = null;
	public var m_CntVal2:String = null;
	public var m_CntRazdel:Boolean = false;
	public var m_FuelVal:String = null;
	public var m_ItemCntVal:String = null;
	public var m_AIRouteVal:Boolean = false;
	public var m_AIAttackVal:Boolean = false;
	
	public var m_Name:String = "";
	public var m_NameWidth:int = 0;
	public var m_NameWidthBM:int = 0;
	public var m_NameHeight:int = 0;
	public var m_NameTex:Texture = null;

	public var m_IsFlyOtherPlanet:Boolean = false;
	
	public var m_SpeedOld:Number = 0.0;

	public static var m_TextTex:Texture = null;
	public static var m_TextTexWidth:int = 0;
	public static var m_TextTexHeight:int = 0;
	public static var m_TextHeight:int = 0;
	public static var m_TextHeightSmall:int = 0;
	public static var m_TextWidth:Vector.<Number> = new <Number>[8, 7, 8, 8, 8, 8, 8, 8, 8, 8, 11, 6];
	public static var m_TextXAdvance:Vector.<Number> = new <Number>[6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 9, 4];
	public static var m_TextWidthSmall:Vector.<Number> = new <Number>[8, 7, 8, 8, 8, 8, 8, 8, 8, 8, 10, 6];
	public static var m_TextXAdvanceSmall:Vector.<Number> = new <Number>[5.4, 4.4, 5.4, 5.4, 5.4, 5.4, 5.4, 5.4, 5.4, 5.4, 7.4, 3.8];
	public static var m_TextQB:C3DQuadBatch = null;
	public static var m_TextOff:int = 0;
	public static var m_TextState:C3DState = null;

	public function GraphShip(map:EmpireMap)
	{
		m_Map = map;
		
		m_NewNum = m_NewNumLast++;

		m_Type=-1;
		m_SubType=0;
		m_Race=-1;
		m_ItemType=-1;

		m_PosX = 0;
		m_PosY = 0;
		m_Angle=0;
		m_LastTime=0;
		
		m_ArrivalTime=0;
		
		m_FireTime=0;
		m_FireTime2=0;
		
/*		var txtformat:ElementFormat = new ElementFormat(fontDescriptionNormal);
		txtformat.fontSize = 16;
		txtformat.color=0xffffff;
		var txtel:TextElement = new TextElement("0123456789", txtformat);
		m_TextBlock.content = txtel;
		var txtline:TextLine = m_TextBlock.createTextLine(null,600);
		txtline.x=100.5;
		addChild(txtline); */
		
//		m_Map.m_ShipLayer.addChild(this);

		//m_Map.MyFont.x+=0.1;
		//trace(m_Map.MyFont.defaultTextFormat);
		
		//flash.text.TextField.defaultTextFormat
		
//		UpdateTextFormat();
	}
	
	public function Clear():void
	{
//		if (m_NameTL != null) {
//			m_NameTL.Clear();
//			m_NameTL = null;
//		}
		if (m_NameTex != null) {
			m_NameTex.dispose();
			m_NameTex = null;
		}
//		m_Map.m_ShipLayer.removeChild(this);
		
		m_Prymo=true;
	}
	
/*	static public const m_Font1:TextFormat = new TextFormat("Calibri", 11, 0xffffff);
	static public const m_Font2:TextFormat = new TextFormat("Calibri", 10, 0xffffff);
	static public const m_Font3:TextFormat = new TextFormat("Calibri", 10, 0x000000);
	static public const m_Font4:TextFormat = new TextFormat("Calibri", 12, 0xffffff);

	public function UpdateTextFormat():void
	{
	}*/

	public function MoveTop():void
	{
	}
	
	public function Link(onlyotherplanet:Boolean = false):Planet
	{
		if (m_ShipNum<0 || m_ShipNum>Common.ShipOnPlanetMax) return null;
		var planet:Planet = m_Map.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return null;
		var ship:Ship = planet.m_Ship[m_ShipNum];
		if (ship == null) return null;
		if (ship.m_Link == 0) return null;
		
		var tp:Planet = m_Map.Link(planet, ship);
		if (tp == null) return null;
		
		if (onlyotherplanet && tp == planet) return null;
		return tp;
	}

	public function Update(isvis:Boolean):void
	{
		var cannon:int, laser:int, missile:int, transiver:int;
		var sx:int;
		var sy:int;
		var pn:int;
		var plto:Planet;
		var findfrom:int;
		var pl:Planet;
		var link:Planet;
		var ra:Array;
		//var bm:BitmapData=m_Map.m_ImgTransport;

		//m_BG.bitmapData=bm;
		//m_BG.x=-bm.width/2;
		//m_BG.y=-bm.height/2;
		
		var ct:Number = Common.GetTime();
		
		m_FirstInit = false;

		x = m_Map.WorldToScreenX(m_PosX, m_PosY);
		y = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(m_PosY);
		
		var simplebattle:Boolean = false; //m_Map.m_SimpleBattle

		var period:int=400;
		var period2:int=50;
		if(simplebattle) { period=4000; period2=4000; }
		else if(m_Type==Common.ShipTypeCruiser) period=200;
//		else if(m_Type==Common.ShipTypeInvader) period=50;
		else if (m_Type == Common.ShipTypeDreadnought) period = 2000;  
		else if (m_Type == Common.ShipTypeQuarkBase) period = 2000;  
		else if(m_Type==Common.ShipTypeWarBase) period=2000;
		else if(m_Type==Common.ShipTypeShipyard) period=2000;
		else if (m_Type == Common.ShipTypeSciBase) period = 2000;
		else if (m_Type == Common.ShipTypeServiceBase) period = 2000;
		else if(m_Type==Common.ShipTypeDevastator) period=2000;
		else if(m_Type==Common.ShipTypeFlagship) { period=200; period2=2000; }

		var gb:GraphBullet=null;
		
		if(m_FireTime+period>=ct && m_FireTime2+period>=ct) return; 

		while(m_FireTime+period<ct) {
			if(!m_Battle) break;

			if(m_ArrivalTime>m_Map.m_ServerCalcTime) {
				if(!((m_FromSectorX==m_SectorX) && (m_FromSectorY==m_SectorY) && (m_FromPlanet==m_PlanetNum))) break;
			}
			if(m_BuildState!=0) break;
			if (m_Flag & (Common.ShipFlagPhantom|Common.ShipFlagSiege)) break;

			pl=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
			if(pl==null) break;
			if (pl.m_Flag & Planet.PlanetFlagWormhole) break;
			
			if(!m_Map.m_Set_Bullet) break;

			m_FireTime=ct;

			var gs:GraphShip;
			var ie:int;

			if(m_Type==Common.ShipTypeFlagship) {
				if(!isvis/*m_Map.IsVis(pl)*/) break;

				cannon=m_Map.VecValE(m_Owner, m_Id, Common.VecAttackCannon);
				laser=m_Map.VecValE(m_Owner, m_Id, Common.VecAttackLaser);
				missile=m_Map.VecValE(m_Owner, m_Id, Common.VecAttackMissile);
				if(cannon==0 && laser==0 && missile==0) cannon=Common.VecAttackCannonLvl[1]>>1;

				while(cannon) {
					ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,true);
					if(ie<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) {
						ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,false);
					}
					if(ie<0) {
						ie=m_Map.FindForMine(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
						if(ie>=0) {
							gb=m_Map.BulletAdd();
							gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

							if(simplebattle) {
								gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
								gb.ToInitEx(m_SectorX,m_SectorY, m_PlanetNum, ie, 15, period);
								gb.m_Type=GraphBullet.TypeSimple;
							} else {
								ra=m_Map.CalcShipPlace(m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum),ie);
								gb.FromInit(m_PosX,m_PosY,5);
								gb.ToInit(ra[0],ra[1],10);
							}
						}
						break;
					}

					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if(!gs) break;

					gb=m_Map.BulletAdd();
					gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

					if(simplebattle) {
						gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
						gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
						gb.m_Type=GraphBullet.TypeSimple;
					} else {
						gb.FromInit(m_PosX,m_PosY,5);
						gb.ToInit(gs.m_PosX,gs.m_PosY,10);
					}
					break;
				}

			} else if(m_Type==Common.ShipTypeDreadnought || m_Type==Common.ShipTypeQuarkBase) {
				if(!isvis/*m_Map.IsVis(pl)*/) break;

				//ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,1<<Common.ShipTypeInvader,3);
				//if(ie<0) 

				if(m_Type==Common.ShipTypeDreadnought && m_Race==Common.RaceTechnol && (m_Flag & Common.ShipFlagTransiver)!=0) {
					while(true) {
						ie=m_Map.FindForTransiver(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
						if(ie<0) break;
						if(ie==m_ShipNum) break;

						gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
						if (!gs) break;

						gb=m_Map.BulletAdd();
						gb.m_Color=0x40ff40;

						if(simplebattle) {
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
							gb.m_Type=GraphBullet.TypeSimple;
						} else {
							gb.m_Type=GraphBullet.TypeLaser;
							gb.FromInitEx(m_SectorX, m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, 1700);
						}
						break;
					}
				} else {
					ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,3,true);
					if(ie<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,3,false);
					if(ie>=0) {
						gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
						if (gs) {
//							if (m_Type==Common.ShipTypeDreadnought && m_Owner==Server.Self.m_UserId && gs.m_Owner!=0 && (gs.m_Owner & Common.OwnerAI)==0) m_Map.m_ViewBattleTimeSelfWithUser = m_Map.m_CurTime;
							CheckViewBattleSelfWithUser(gs);
							
							gb=m_Map.BulletAdd();
							gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;
							
							if(simplebattle) {
								gb.FromInitEx(m_SectorX, m_SectorY, m_PlanetNum, m_ShipNum, 0);
								gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
								gb.m_Type=GraphBullet.TypeSimple;
							} else {
								gb.m_Type=GraphBullet.TypeLaser;
								gb.FromInitEx(m_SectorX, m_SectorY, m_PlanetNum, m_ShipNum, 0);
								gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, 1700);
							}
						}
					}
				}

			} else if(m_Type==Common.ShipTypeTransport || m_Type==Common.ShipTypeInvader) {
				if(!isvis/*m_Map.IsVis(pl)*/) break;
//trace("00");
				ie=0;
				ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,true);
//trace("01",ie);
				if(ie<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,false);
//trace("02",ie);
				while(ie>=0) {
//trace("03");
					if(m_Map.ShipPower(m_Owner,m_Type)<=0) break;
//trace("04");
					
					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if(gs) {
						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

						if(simplebattle) {
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
							gb.m_Type=GraphBullet.TypeSimple;
						} else {
							gb.FromInit(m_PosX,m_PosY,5);
							gb.ToInit(gs.m_PosX,gs.m_PosY,10);
						}
					}
					break;
				}
				
			} else if(m_Type==Common.ShipTypeShipyard || m_Type==Common.ShipTypeSciBase || m_Type==Common.ShipTypeServiceBase) {
				if(!isvis/*m_Map.IsVis(pl)*/) break;

				//ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,1<<Common.ShipTypeInvader,Common.ShipOnPlanetMax>>1);
				//if(ie<0)
				ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,Common.ShipOnPlanetMax>>1,true);
				if(ie<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,Common.ShipOnPlanetMax>>1,false);
				if(ie>=0) {
					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if(gs) {
						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

						if(simplebattle) {
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
							gb.m_Type=GraphBullet.TypeSimple;
						} else {
							gb.m_Type=GraphBullet.TypeLaser;
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, 1700);
						}
					}
				}

			} else if(m_Type==Common.ShipTypeCorvette) {
				if(!isvis/*m_Map.IsVis(pl)*/) break;
	
				ie=0;
				if(m_Owner==0) ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,true);
				else {
					ie = m_Map.FindNearEnemy(m_SectorX, m_SectorY, m_PlanetNum, m_ShipNum, ~((1 << Common.ShipTypeCruiser) | (1 << Common.ShipTypeCorvette)) /*(1 << Common.ShipTypeInvader) | (1 << Common.ShipTypeTransport) | (1 << Common.ShipTypeDreadnought) | (1 << Common.ShipTypeDevastator) | (1 << Common.ShipTypeFlagship) | (1 << Common.ShipTypeQuarkBase) | (1 << Common.ShipTypeShipyard) | (1 << Common.ShipTypeSciBase) | (1 << Common.ShipTypeServiceBase)*/, 2, true);
					if (ie < 0) ie = m_Map.FindNearEnemy(m_SectorX, m_SectorY, m_PlanetNum, m_ShipNum, 0xffffffff, 1, true);
				}
				if(ie<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,false);
				if(ie>=0) {
					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if (gs) {
						CheckViewBattleSelfWithUser(gs);

						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

						if(simplebattle) {
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
							gb.m_Type=GraphBullet.TypeSimple;
						} else {
							gb.FromInit(m_PosX,m_PosY,5);
							gb.ToInit(gs.m_PosX,gs.m_PosY,10);
						}
					}
				}

			} else if(m_Type==Common.ShipTypeCruiser || m_Type==Common.ShipTypeKling0 || m_Type==Common.ShipTypeKling1) {
				if(!isvis/*m_Map.IsVis(pl)*/) break;

				ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,true);
				if(ie<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) {
					ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,false);
				}
				if(ie>=0) {
					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if (gs) {
						CheckViewBattleSelfWithUser(gs);
						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;
						
						if(simplebattle) {
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
							gb.m_Type=GraphBullet.TypeSimple;
						} else {
							gb.FromInit(m_PosX,m_PosY,5);
							gb.ToInit(gs.m_PosX,gs.m_PosY,10);
						}
					}
				}
	
				if((m_Type==Common.ShipTypeCruiser) && (ie>=0)) {
	
					var ie2:int=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,true,ie);
					//if(ie2<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) ie2=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,1,false,ie);
					if(ie2>=0) ie=ie2;
					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if (gs) {
						CheckViewBattleSelfWithUser(gs);
						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

						if(simplebattle) {
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
							gb.m_Type=GraphBullet.TypeSimple;
						} else {
							gb.FromInit(m_PosX,m_PosY,5);
							gb.ToInit(gs.m_PosX,gs.m_PosY,10);
						}
					}
				}

			} else if(m_Type==Common.ShipTypeWarBase) {
				if(!isvis/*m_Map.IsVis(pl)*/) break;

				//ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,1<<Common.ShipTypeInvader,Common.ShipOnPlanetMax>>1);
				//if(ie<0)
				ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,Common.ShipOnPlanetMax>>1,true);
				if(ie<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,Common.ShipOnPlanetMax>>1,false);
				if(ie>=0) {
					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if (gs) {
						CheckViewBattleSelfWithUser(gs);
						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

						if(simplebattle) {
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
							gb.m_Type=GraphBullet.TypeSimple;
						} else {
							gb.m_Type=GraphBullet.TypeLaser;
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, 1700);
						}
					}
				}

				if(ie>=0) {
					//ie2=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,1<<Common.ShipTypeInvader,Common.ShipOnPlanetMax>>1,ie);
					//if(ie2<0)
					ie2 = m_Map.FindNearEnemy(m_SectorX, m_SectorY, m_PlanetNum, m_ShipNum, 0xffffffff & (~(1 << Common.ShipTypeDevastator)), Common.ShipOnPlanetMax >> 1, true, ie);
					//if(ie2<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) ie2=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,Common.ShipOnPlanetMax>>1,false,ie);
					if(ie2>=0) ie=ie2;
					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if (gs) {
						CheckViewBattleSelfWithUser(gs);
						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

						if(simplebattle) {
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period);
							gb.m_Type=GraphBullet.TypeSimple;
						} else {
							gb.m_Type=GraphBullet.TypeLaser;
							gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
							gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, 1700);
						}
					}
				}
			} else if(m_Type==Common.ShipTypeDevastator) {
				while(true) {
					sx = m_SectorX;
					sy = m_SectorY;
					pn = m_PlanetNum;
					plto = null;
					findfrom = m_ShipNum;

//@					if(m_Flag & Common.ShipFlagAutoReturn) { 
					link = Link(true);
					if (link != null) {
//@						plto=m_Map.GetPlanet(m_FromSectorX,m_FromSectorY,m_FromPlanet);
						plto = link;
						if(plto==null) break;

						if(pl.m_Flag & Planet.PlanetFlagGravitor) {}
						else if ((pl.m_Flag & Planet.PlanetFlagGravitorSci) && !(m_Owner == pl.m_GravitorOwner || m_Map.IsFriendEx(pl, m_Owner, m_Race, pl.m_GravitorOwner, Common.RaceNone))) { }
						else if (plto.m_Flag & Planet.PlanetFlagGravitor) { }
						else if ((plto.m_Flag & Planet.PlanetFlagGravitorSci) && !(m_Owner == plto.m_GravitorOwner || m_Map.IsFriendEx(plto, m_Owner, m_Race, plto.m_GravitorOwner, Common.RaceNone))) { }
						else {
//@							sx=m_FromSectorX; sy=m_FromSectorY; pn=m_FromPlanet;
							sx = link.m_Sector.m_SectorX; sy = link.m_Sector.m_SectorY; pn = link.m_PlanetNum;
						
							findfrom = m_Map.FindOwnerOtherPlanet(m_Owner, m_Race, sx, sy, pn, findfrom, true);
							if (findfrom < 0) break;
						}
					} else {
						plto=m_Map.GetPlanet(sx,sy,pn);
					}

					if(plto==null) break;

					if (!isvis/*m_Map.IsVis(pl)*/ && !plto.m_Vis) break;
					
					var sm:uint = 0xffffffff;
					if (sx != m_SectorX || sy != m_SectorY || pn != m_PlanetNum) sm &= ~(1<<Common.ShipTypeCorvette);

					ie = m_Map.FindEnemyOtherPlanet(m_Owner, m_Race, sx, sy, pn, findfrom, sm, true);
					if(ie<0 && !m_Map.HaveEnemyInBattle(plto, m_Owner, m_Race)) ie=m_Map.FindEnemyOtherPlanet(m_Owner, m_Race, sx,sy,pn, findfrom, sm, false);
					
					if(ie<0 && !(sx==m_SectorX && sy==m_SectorY && pn==m_PlanetNum)) {
						sx=m_SectorX;
						sy=m_SectorY;
						pn=m_PlanetNum;
						
						plto=m_Map.GetPlanet(sx,sy,pn);
						if(plto==null) break;

						ie=m_Map.FindNearEnemy(sx,sy,pn,m_ShipNum,0xffffffff,3,true);
						if(ie<0 && !m_Map.HaveEnemyInBattle(plto, m_Owner, m_Race)) ie=m_Map.FindNearEnemy(sx,sy,pn,m_ShipNum,0xffffffff,3,false);
					}

					if(ie>=0) {
						gs=m_Map.GetGraphShip(sx,sy,pn,ie);
						if (gs) {
							CheckViewBattleSelfWithUser(gs);
							gb=m_Map.BulletAdd();
							gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;
		
							gb.m_Type=GraphBullet.TypeMissile;
							gb.m_Angle=BaseMath.AngleNorm(m_Angle-Math.PI*0.2);
							gb.FromInit(m_PosX,m_PosY,5);
							gb.ToInit(gs.m_PosX,gs.m_PosY,10);
							gb.m_ToSectorX=gs.m_SectorX;
							gb.m_ToSectorY=gs.m_SectorY;
							gb.m_ToPlanetNum=gs.m_PlanetNum;
							gb.m_ToShipNum=gs.m_ShipNum;
							gb.m_EndTime=gb.m_BeginTime+500;
						}
					}
					break;
				}
			}			

			if(gb==null) m_FireTime=0;
			break;
		}

		while(m_FireTime2+period2<ct) {
			if(!m_Battle) break;

			if(m_ArrivalTime>m_Map.m_ServerCalcTime) {
				if(!((m_FromSectorX==m_SectorX) && (m_FromSectorY==m_SectorY) && (m_FromPlanet==m_PlanetNum))) break;
			}
			if(m_BuildState!=0) break;
			if (m_Flag & (Common.ShipFlagPhantom|Common.ShipFlagSiege)) break;

			pl=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
			if(pl==null) break;
			if(pl.m_Flag & Planet.PlanetFlagWormhole) break;

			if(!m_Map.m_Set_Bullet) break;

			m_FireTime2=ct;

			if(m_Type==Common.ShipTypeFlagship) {
				laser=m_Map.VecValE(m_Owner, m_Id, Common.VecAttackLaser);
				missile=m_Map.VecValE(m_Owner, m_Id, Common.VecAttackMissile);
				transiver=m_Map.VecValE(m_Owner, m_Id, Common.VecAttackTransiver);

				while(missile) {
					sx=m_SectorX;
					sy=m_SectorY;
					pn=m_PlanetNum;
					plto=null;
					findfrom=m_ShipNum;
//@					if(m_Flag & Common.ShipFlagAutoReturn) { 
					link = Link(true);
					if (link != null) {
//@						plto=m_Map.GetPlanet(m_FromSectorX,m_FromSectorY,m_FromPlanet);
						plto = link;
						if(plto==null) break;

						if (pl.m_Flag & Planet.PlanetFlagGravitor) { }
						else if ((pl.m_Flag & Planet.PlanetFlagGravitorSci) && !(m_Owner == pl.m_GravitorOwner || m_Map.IsFriendEx(pl, m_Owner, m_Race, pl.m_GravitorOwner, Common.RaceNone))) { }
						else if (plto.m_Flag & Planet.PlanetFlagGravitor) { }
						else if ((plto.m_Flag & Planet.PlanetFlagGravitorSci) && !(m_Owner == plto.m_GravitorOwner || m_Map.IsFriendEx(plto, m_Owner, m_Race, plto.m_GravitorOwner, Common.RaceNone))) { }
						else {
//@							sx=m_FromSectorX; sy=m_FromSectorY; pn=m_FromPlanet;
							sx = link.m_Sector.m_SectorX; sy = link.m_Sector.m_SectorY; pn = link.m_PlanetNum;

							findfrom = m_Map.FindOwnerOtherPlanet(m_Owner, m_Race, sx, sy, pn, findfrom, true);
							if(findfrom<0) break;
						}
					} else {
						plto=m_Map.GetPlanet(sx,sy,pn);
					}

					if(plto==null) break;

					if(!pl.m_Vis && !plto.m_Vis) break;

					ie=m_Map.FindEnemyOtherPlanet(m_Owner, m_Race, sx,sy,pn, findfrom, 0xffffffff, true);
					if(ie<0 && !m_Map.HaveEnemyInBattle(plto, m_Owner, m_Race)) ie=m_Map.FindEnemyOtherPlanet(m_Owner, m_Race, sx,sy,pn, findfrom, 0xffffffff, false);				

					if(ie<0 && !(sx==m_SectorX && sy==m_SectorY && pn==m_PlanetNum)) {
						sx=m_SectorX;
						sy=m_SectorY;
						pn=m_PlanetNum;

						plto=m_Map.GetPlanet(sx,sy,pn);
						if(plto==null) break;

						ie=m_Map.FindNearEnemy(sx,sy,pn,m_ShipNum,0xffffffff,3,true);
						if(ie<0 && !m_Map.HaveEnemyInBattle(plto, m_Owner, m_Race)) ie=m_Map.FindNearEnemy(sx,sy,pn,m_ShipNum,0xffffffff,3,false);
					}

					if(ie>=0) {
						gs=m_Map.GetGraphShip(sx,sy,pn,ie);
						if(gs) {
							gb=m_Map.BulletAdd();
							gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;
		
							gb.m_Type=GraphBullet.TypeMissile;
							gb.m_Angle=BaseMath.AngleNorm(m_Angle-Math.PI*0.2);
							gb.FromInit(m_PosX,m_PosY,5);
							gb.ToInit(gs.m_PosX,gs.m_PosY,10);
							gb.m_ToSectorX=gs.m_SectorX;
							gb.m_ToSectorY=gs.m_SectorY;
							gb.m_ToPlanetNum=gs.m_PlanetNum;
							gb.m_ToShipNum=gs.m_ShipNum;
							gb.m_EndTime=gb.m_BeginTime+500;
						}
					}
					break;
				}

				if(!pl.m_Vis) break;

				while(laser) {
					ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,3,true);
					if(ie<0 && !m_Map.HaveEnemyInBattle(pl, m_Owner, m_Race)) ie=m_Map.FindNearEnemy(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum,0xffffffff,3,false);
					if(ie<0) {
						ie=m_Map.FindForMine(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
						if(ie>=0) {
							gb=m_Map.BulletAdd();
							gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;
							if(simplebattle) {
								gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
								gb.ToInitEx(m_SectorX,m_SectorY, m_PlanetNum, ie, 15, period2);
								gb.m_Type=GraphBullet.TypeSimple;
							} else {
								gb.m_Type=GraphBullet.TypeLaser;
								gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
								gb.ToInitEx(m_SectorX,m_SectorY, m_PlanetNum, ie, 15, 1700);
							}
						}
						break;
					} 

					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if(!gs) break;

					gb=m_Map.BulletAdd();
					gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;

					if(simplebattle) {
						gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
						gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period2);
						gb.m_Type=GraphBullet.TypeSimple;
					} else {
						gb.m_Type=GraphBullet.TypeLaser;
						gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
						gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, 1700);
					}
					break;
				}

				while(transiver) {
					ie=m_Map.FindForTransiver(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
					if(ie<0) break;
					if(ie==m_ShipNum) break;

					gs=m_Map.GetGraphShip(m_SectorX,m_SectorY,m_PlanetNum,ie);
					if(!gs) break;

					gb=m_Map.BulletAdd();
					gb.m_Color=0x40ff40;

					if(simplebattle) {
						gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
						gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, period2);
						gb.m_Type=GraphBullet.TypeSimple;
					} else {
						gb.m_Type=GraphBullet.TypeLaser;
						gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
						gb.ToInitEx(gs.m_SectorX, gs.m_SectorY, gs.m_PlanetNum, gs.m_ShipNum, 15, 1700);
					}
					break;
				}

			} else if((m_Type==Common.ShipTypeInvader) || (m_Type==Common.ShipTypeKling1)) {
				if(!pl.m_Vis) break;

				var ship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
				var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);

				while(ship!=null && planet!=null && !(planet.m_Flag & Planet.PlanetFlagWormhole) && !m_Map.IsFriendEx(planet,ship.m_Owner,ship.m_Race,planet.m_Owner,planet.m_Race)) {
					if(m_Type==Common.ShipTypeKling1 && planet.m_Owner==0) break;
///					((!(planet.m_Flag & Planet.PlanetFlagWormhole)) || (planet.m_Owner!=0))

					if(ship.m_Owner!=0 && !(ship.m_Flag & Common.ShipFlagCapture)) break;

					if(simplebattle) {
						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;
						gb.FromInitEx(m_SectorX,m_SectorY, m_PlanetNum, m_ShipNum, 0);
						gb.ToInitEx(m_SectorX,m_SectorY, m_PlanetNum, -1, 15, period2);
						gb.m_Type=GraphBullet.TypeSimple;
					} else {
						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;
						gb.m_Type=GraphBullet.TypeInvader;
						gb.FromInit(m_PosX,m_PosY,5);
						gb.ToInit(planet.m_PosX,planet.m_PosY,15,0.05);

						gb=m_Map.BulletAdd();
						gb.m_Color=0xff8000; if(m_Map.IsFriendEx(pl,Server.Self.m_UserId,Common.RaceNone,m_Owner,m_Race)) gb.m_Color=0xffff00;
						gb.m_Type=GraphBullet.TypeInvader;
						gb.FromInit(planet.m_PosX,planet.m_PosY,15);
						gb.ToInit(m_PosX,m_PosY,5,0.05);
					}
					
					break;
				}
			}
			
			break;
		}
	}
	
	public function CheckViewBattleSelfWithUser(gs:GraphShip):void
	{
		if (m_Owner != Server.Self.m_UserId) return;
		if (gs.m_Owner == 0) return;
		if ((gs.m_Owner & Common.OwnerAI) != 0) return;

		if (m_Type == Common.ShipTypeCorvette) { }
		else if (m_Type == Common.ShipTypeCruiser) { }
		else if (m_Type == Common.ShipTypeDreadnought) { }
		else if (m_Type == Common.ShipTypeDevastator) { }
		else if (m_Type == Common.ShipTypeWarBase) { }
		else return;

		m_Map.m_ViewBattleTimeSelfWithUser = m_Map.m_CurTime;
	}
	
//	private static var m_STL_PelengD:Texture = null;
	
//	public static function GetTextureByType(type:int, race:int, subtype:int = 0):Texture
//	{
//		if (m_STL_PelengD == null) m_STL_PelengD = C3D.CreateTextureFromBM(Common.CreateByName("STL_PelengD") as BitmapData);
//		return m_STL_PelengD;
//	}
	
	public static function GetImageByType(type:int,race:int,subtype:int=0):Sprite
	{
		var sx:Number=1.0;
		var sy:Number=1.0;
		var name:String='';

		if(type==Common.ShipTypeFlagship) {
			if(subtype==0) { name="ImgFlagshipQ1"; sx=0.50; sy=0.50; }
			else if(subtype==1) { name="ImgFlagshipQ2"; sx=0.50; sy=0.50; }
			else if(subtype==2) { name="ImgFlagshipQ3"; sx=0.50; sy=0.50; }
			else if(subtype==3) { name="ImgFlagshipQ4"; sx=0.50; sy=0.50; }
			else if(subtype==4) { name="ImgFlagshipS1"; sx=0.50; sy=0.50; }
			else if(subtype==5) { name="ImgFlagshipS2"; sx=0.50; sy=0.50; }
			else if(subtype==6) { name="ImgFlagshipS3"; sx=0.50; sy=0.50; }
			else { name="ImgFlagshipS4"; sx=0.50; sy=0.50; }
		}
		else if(type==Common.ShipTypeWarBase) { name="ImgWarBase"; sx=0.9; sy=0.9; }
		else if(type==Common.ShipTypeShipyard) { name="ImgShipyard"; sx=0.9; sy=0.9; }
		else if (type == Common.ShipTypeSciBase) { name = "ImgSciBase"; sx = 0.9; sy = 0.9; }
		else if (type == Common.ShipTypeServiceBase) { name = "ImgServiceBase"; sx = 0.9; sy = 0.9; }
		else if (type == Common.ShipTypeQuarkBase) { name = "ImgQuarkBase"; sx = 0.9; sy = 0.9; }
		else if(race==Common.RaceGrantar) {
			if(type==Common.ShipTypeTransport) { name="ImgMalocT"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCorvette) { name="ImgMalocR"; sx=0.7; sy=0.7; }
			else if(type==Common.ShipTypeCruiser) { name="ImgMalocP"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgMalocW"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeInvader) { name="ImgMalocL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgMalocD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RacePeleng) {
			if(type==Common.ShipTypeTransport) { name="ImgPelengT"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeCorvette) { name="ImgPelengR"; sx=0.7; sy=0.7; }
			else if(type==Common.ShipTypeCruiser) { name="ImgPelengP"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgPelengW"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeInvader) { name="ImgPelengL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgPelengD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RacePeople) {
			if(type==Common.ShipTypeTransport) { name="ImgPeopleT"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeCorvette) { name="ImgPeopleR"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCruiser) { name="ImgPeopleP"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgPeopleW"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeInvader) { name="ImgPeopleL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgPeopleD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RaceTechnol) {
			if(type==Common.ShipTypeTransport) { name="ImgFeiT"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCorvette) { name="ImgFeiR"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCruiser) { name="ImgFeiP"; sx=0.95; sy=0.95; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgFeiW"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeInvader) { name="ImgFeiL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgFeiD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RaceGaal) {
			if(type==Common.ShipTypeTransport) { name="ImgGaalT"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCorvette) { name="ImgGaalR"; sx=0.7; sy=0.7; }
			else if(type==Common.ShipTypeCruiser) { name="ImgGaalP"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgGaalW"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeInvader) { name="ImgGaalL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgGaalD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RaceKling) {
			if(type==Common.ShipTypeKling0) { name="ImgKling0"; sx=0.6; sy=0.6; }
			else if(type==Common.ShipTypeKling1) { name="ImgKling1"; sx=0.9; sy=0.9; }
		}
		
		if(name.length<=0) { name="ImgGaalD"; sx=2; sy=2; }

		var cl:Class=ApplicationDomain.currentDomain.getDefinition(name) as Class;
		var s:Sprite=new cl();
		s.scaleX=sx;
		s.scaleY=sy;
		return s;
	}

	public function SetType(type:int, race:int, subtype:int, battle:Boolean = false, nobattle:Boolean = false):void
	{
		if(m_Type==type && m_Race==race && m_SubType==subtype && m_Battle==battle && m_NoBattle==nobattle) return;
		m_Type=type;
		m_Race=race;
		m_SubType=subtype;
		if (m_Battle != battle || m_NoBattle != nobattle) { m_Battle = battle; m_NoBattle = nobattle; } //UpdateTextFormat();
	}
	
	public function SetItemType(type:int):void
	{
		if (m_ItemType == type) return;
		m_ItemType = type;
		m_ItemNum = 0;

		if(type==Common.ItemTypeNone) return;

		var idesc:Item = UserList.Self.GetItem(type);
		if (idesc == null) { m_ItemType = 0; return; }
		m_ItemNum = idesc.m_Img;
	}

	public function SetCnt(i:String):void
	{
		if (i == null || i.length <= 0) {
			m_CntVal = null;
		} else {
			if (m_CntVal != i) m_CntVal = i;
		}
	}

	public function SetCnt2(i:String, r:Boolean=false):void
	{
		if (i == null || i.length <= 0) {
			m_CntVal2 = null;
			m_CntRazdel = false;
		} else {
			if (m_CntVal2 != i) m_CntVal2 = i;
			m_CntRazdel = r;
		}
	}

	public function SetPoints(type:uint, i:String):void
	{
		if (m_PointsType == type && m_PointsVal == i) return;
		m_PointsVal = i;

		if (m_PointsType == type) return;
		m_PointsType = type;
		m_PointsImgNum = 0;

		if (type == 0) return;

		var idesc:Item = UserList.Self.GetItem(type);
		if (idesc == null) { m_PointsType = 0; return; }
		m_PointsImgNum = idesc.m_Img;
	}

	public function SetFuel(i:String):void
	{
		if (m_FuelVal == i) return;
		if (i == null || i.length <= 0) {
			m_FuelVal = null;
		} else {
			m_FuelVal = i;
		}
	}

	public function SetItemCnt(i:String):void
	{
		if (m_ItemCntVal == i) return;
		if (i == null || i.length <= 0) {
			m_ItemCntVal = null;
		} else {
			m_ItemCntVal = i;
		}
	}

	public function SetColor(clr:uint):void
	{
		if(m_Clr==clr) return;
		m_Clr=clr;
	}
	
	public function SetBuildState(v:int, clr:uint=0xffff00):void
	{
		if(m_BuildState==v) return;
		m_BuildState = v;
		m_BuildStateClr = clr;
	}

	public function SetEffect(v:int):void
	{
		if(m_EffectType==v) return;
		m_EffectType=v;
	}

	public function SetInvu(v:Boolean):void
	{
		if(m_InvuOn==v) return;
		m_InvuOn = v;
	}

	public function SetAIRoute(v:Boolean):void
	{
		m_AIRouteVal = v;
	}

	public function SetAIAttack(v:Boolean):void
	{
		m_AIAttackVal = v;
	}

	public function SetName(v:String):void
	{
		if (v == null || v.length <= 0 || v == " ") {
//			if (m_NameTL != null) {
//				m_NameTL.Clear();
//				m_NameTL = null;
//			}
			m_Name = "";
			if (m_NameTex != null) {
				m_NameTex.dispose();
				m_NameTex = null;
				
			}
			return;			
		}
		
		if (m_Name == v && m_NameTex != null) return;
		m_Name = v;

//		if (m_NameTL == null) {
//			m_NameTL = new C3DTextLine();
//			m_NameTL.SetFont("small_outline");
//			m_NameTL.SetFormat(1);
//		}
//		m_NameTL.SetText(v);

		if(m_NameTF==null) {
			m_NameTF=new TextField();
			m_NameTF.width=1;
			m_NameTF.height=1;
			m_NameTF.type=TextFieldType.DYNAMIC;
			m_NameTF.selectable=false;
			m_NameTF.textColor=0xffffff;
			m_NameTF.alpha=0.7;
			m_NameTF.multiline=false;
			m_NameTF.autoSize=TextFieldAutoSize.LEFT;
			m_NameTF.gridFitType=GridFitType.NONE;
			m_NameTF.embedFonts=true;
			m_NameTF.defaultTextFormat=new TextFormat("Calibri",12,0xffffff);
		}
		m_NameTF.text = v;
		m_NameWidth = m_NameTF.width;
		if (m_NameWidth > 128) m_NameWidth = 128;
		m_NameHeight = m_NameTF.height - 3 - 2;

		if (m_NameWidth > 64) m_NameWidthBM = 128;
		else if (m_NameWidth > 32) m_NameWidthBM = 64;
		else if (m_NameWidth > 16) m_NameWidthBM = 32;
		else m_NameWidthBM = 16;

		var x:int, y:int;
		var tx:int, ty:int;
		var k:int;

		var bm:BitmapData = new BitmapData(m_NameWidthBM, 1024, true, 0x00000000);

		for (y = 0; y < 8; y++) {
			for (x = 0; x < 8; x++) {
				k = x + y * 8;
				tx = 0;
				ty = k * 16;
				m_NameMatrix.identity();
				m_NameMatrix.translate(Number(tx) + Number(x) / 8.0, Number(ty - 3) + Number(y) / 8.0);
				bm.draw(m_NameTF, m_NameMatrix, null, null, null, true);
			}
		}

		m_NameTex = C3D.CreateTextureFromBM(bm, false);

//		if (m_NameTest == null) {
//			m_NameTest = new Bitmap();
//			EmpireMap.Self.addChild(m_NameTest);
//		}
//		m_NameTest.bitmapData = bm;
	}
	
	public function SetStealth(v:int, dt:Number/*, alphavis:Number*/):void
	{
		//if(m_Stealth==v) return;
		m_Stealth=v;
		if(m_FirstInit) {
			if(m_Stealth==2 || m_Stealth==-1) m_AlphaVis=0.0;
			else m_AlphaVis=1.0;
			//m_AlphaVis=alphavis;
		} else {
			var needalpha:Number=0;
			if(m_Stealth==2 || m_Stealth==-1) needalpha=0.0;
			else needalpha=1.0;
			
			var d:Number=needalpha-m_AlphaVis;
			var speed:Number=0.0003*dt;
			if(Math.abs(d)<=speed) {
				m_AlphaVis=needalpha;
			} else if(needalpha<m_AlphaVis) m_AlphaVis-=speed;
			else m_AlphaVis+=speed;
			
		}
	}

	public function SetHPBar(v:int, m:int, s:int):void
	{
		if ((m_HPBarVal == v) && (m_HPBarMax == m) && (m_HPBarState==s)) return;
		m_HPBarVal = v;
		m_HPBarMax = m;
		m_HPBarState = s;
	}

	public function SetShieldBar(v:int, m:int, s:int):void
	{
		if ((m_ShieldBarVal == v) && (m_ShieldBarMax == m) && (m_ShieldBarState==s)) return;
		m_ShieldBarVal = v;
		m_ShieldBarMax = m;
		m_ShieldBarState = s;
	}

	public function CalcShipServerPos():Array
	{
		var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if(planet==null) return [0,0,0];
		var ra:Array = m_Map.CalcShipPlace(planet, m_ShipNum);
		var st:Number = m_Map.m_ServerCalcTime;
		if (m_ArrivalTime <= st) return ra;

		var ship:Ship=m_Map.GetShip(m_SectorX,m_SectorY,m_PlanetNum,m_ShipNum);
		if(ship==null) return ra; 

		var planet2:Planet=m_Map.GetPlanet(ship.m_FromSectorX,ship.m_FromSectorY,ship.m_FromPlanet);
		if(planet2==null) return ra;
		var ra2:Array=m_Map.CalcShipPlace(planet2,ship.m_FromPlace);

		st = 1.0 - (m_ArrivalTime-st) / (m_Map.CalcFlyTime(ship.m_Owner, ship.m_Id, ship.m_Type, ship.m_Race, planet, planet2) * 1000);
		if(st<0.0) st=0.0;
		else if(st>1.0) st=1.0;

		var dirx:Number=ra[0]-ra2[0];
		var diry:Number=ra[1]-ra2[1];

		return [ra2[0]+dirx*st,ra2[1]+diry*st,Math.atan2(dirx,-diry)];
	}	

	public function CalcPos():void
	{
		var k:Number;
		
		var ct:Number=Common.GetTime();// (new Date()).getTime();
		var st:Number = ct - m_LastTime;
		if (st > 1000) m_LastTime = 0;
		if(m_LastTime==0 || (m_Flag & Common.ShipFlagExchange)) {
			var ra:Array;
			ra = CalcShipServerPos();
			m_LastTime = ct;
			m_PosX = ra[0];
			m_PosY = ra[1];
			m_Angle = ra[2];
			return;
		}
		if (st < 10) return;
		m_LastTime=ct;

		var sec:Sector=m_Map.GetSector(m_SectorX,m_SectorY);
		if(!sec) return;
		var planet:Planet=sec.m_Planet[m_PlanetNum];

		m_Map.CalcShipPlaceEx(planet, m_ShipNum, EmpireMap.m_TPos);
		var needx:Number = EmpireMap.m_TPos.x;// ra[0];
		var needy:Number = EmpireMap.m_TPos.y;// ra[1];
		var needangle:Number = EmpireMap.m_TPos.z;// ra[2];

		var speed:Number = 0.05 * st;
		var aspeed:Number = Math.PI / 180 * 0.1 * st;
		if (Common.IsBase(m_Type)) aspeed = Math.PI;

		var dirx:Number = needx - m_PosX;
		var diry:Number = needy - m_PosY;
		var dist:Number = Math.sqrt(dirx * dirx + diry * diry);
		if (dist <= 0.001) { dirx = 0; diry = 0; }
		else { k = 1.0 / dist; dirx *= k; diry *= k; }

		var at:Number = m_Map.m_ServerCalcTime;
		if (m_ArrivalTime > at) {
			var speedold:Number = speed;
			speed = (dist / Math.max(1000, m_ArrivalTime - at));// * st;
			if (speed < 0.005) speed = 0.005;
			else if (speed > 10.0) speed = 10.0;
			
			m_SpeedOld = speed;
			speed *= st;

			if (speedold != 0) aspeed = speed / speedold * aspeed;
//if(m_Type==Common.ShipTypeCorvette && m_Owner==Server.Self.m_UserId) trace("speed = "+speed+" ServerTime="+at+" ArrivalTime="+m_ArrivalTime+" sub="+(m_ArrivalTime-at));
		} else if (m_SpeedOld > 0) {
			speed = m_SpeedOld * st;
		}

		if (dist > 10/*speed * 10*/) {
			needangle = Math.atan2(dirx, -diry);
		} else {
			m_Prymo = true;
		}

		var ad:Number = BaseMath.AngleDist(m_Angle, needangle);
		if (Math.abs(ad) <= aspeed) m_Angle = needangle;
		else {
			if (ad < 0) m_Angle = BaseMath.AngleNorm(m_Angle - aspeed);
			else m_Angle = BaseMath.AngleNorm(m_Angle + aspeed);
			
			if (dist < 200) {
				speed *= 1.0 - Math.abs(ad) / Math.PI;
			}
		}
		
		if (dist > 100) m_Prymo = false;		

		if (dist <= speed) {
			m_PosX = needx;
			m_PosY = needy;
		} else if (dist <= 10 || m_Prymo) {
			m_Prymo = true;
			m_PosX += dirx * speed;
			m_PosY += diry * speed;
		} else {
			m_Prymo = false;
			m_PosX += speed * Math.sin(m_Angle);
			m_PosY += -speed * Math.cos(m_Angle);
		}
	}
	
	public static function GetTexValByType(type:int, race:int, subtype:int, out:Object):void
	{
		var fx:Number = 0, fy:Number = 0;
		var cx:Number = 64, cy:Number = 64;
		var width:Number = 100;
		
		if(type==Common.ShipTypeFlagship) {
			if (subtype == 0) { fx = 1536; fy = 0; width = 60.0; cx = 1605; cy = 72; }
			else if(subtype==1) { fx = 1664; fy = 0; width = 60.0; cx = 1728; cy = 74; }
			else if(subtype==2) { fx = 1792; fy = 0; width = 60.0; cx = 1858; cy = 74; }
			else if (subtype == 3) { fx = 1920; fy = 0; width = 60.0; cx = 1988; cy = 72; }
			
			else if(subtype==4) { fx = 1536; fy = 128; width = 60.0; cx = 1602; cy = 190; }
			else if(subtype==5) { fx = 1664; fy = 128; width = 60.0; cx = 1726; cy = 192; }
			else if(subtype==6) { fx = 1792; fy = 128; width = 60.0; cx = 1855; cy = 191; }
			else { fx = 1920; fy = 128; width = 60.0; cx = 1987; cy = 191; }
		}
		else if(type==Common.ShipTypeWarBase) { fx = 768; fy = 256; width = 65.0; cx = 833; cy = 321; }
		else if(type==Common.ShipTypeShipyard) { fx = 1024; fy = 256; width = 60.0; cx = 1097; cy = 328; }
		else if (type == Common.ShipTypeSciBase) { fx = 896; fy = 256; width = 60.0; cx = 963; cy = 320; }
		else if (type == Common.ShipTypeServiceBase) { fx = 1152; fy = 256; width = 60.0; cx = 1217; cy = 315; }
		else if (type == Common.ShipTypeQuarkBase) { fx = 1280; fy = 256; width = 60.0; cx = 1347; cy = 317; }
		else if(race==Common.RaceGrantar) {
			if(type==Common.ShipTypeTransport) { fx = 512; fy = 0; width = 60.0; cx = 575; cy = 59; }
			else if(type==Common.ShipTypeCorvette) { fx = 384; fy = 0; width = 50.0; cx = 446; cy = 59; }
			else if(type==Common.ShipTypeCruiser) { fx = 256; fy = 0; width = 60.0; cx = 318; cy = 63; }
			else if(type==Common.ShipTypeDreadnought) { fx = 640; fy = 0; width = 50.0; cx = 704; cy = 67; }
			else if(type==Common.ShipTypeInvader) { fx = 128; fy = 0; width = 55.0; cx = 190; cy = 57; }
			else if (type == Common.ShipTypeDevastator) { fx = 0; fy = 0; width = 50.0; cx = 61; cy = 58; }
		}
		else if(race==Common.RacePeleng) {
			if(type==Common.ShipTypeTransport) { fx = 1280; fy = 0; width = 60.0; cx = 1344; cy = 61; }
			else if(type==Common.ShipTypeCorvette) { fx = 1152; fy = 0; width = 40.0; cx = 1217; cy = 49; }
			else if(type==Common.ShipTypeCruiser) { fx = 1024; fy = 0; width = 60.0; cx = 1088; cy = 64; }
			else if(type==Common.ShipTypeDreadnought) { fx = 1408; fy = 0; width = 50.0; cx = 1471; cy = 62; }
			else if(type==Common.ShipTypeInvader) { fx = 896; fy = 0; width = 55.0; cx = 961; cy = 58; }
			else if (type == Common.ShipTypeDevastator) { fx = 768; fy = 0; width = 50.0; cx = 832; cy = 62; }
		}
		else if(race==Common.RacePeople) {
			if(type==Common.ShipTypeTransport) { fx = 512; fy = 128; width = 65.0; cx = 577; cy = 189; }
			else if(type==Common.ShipTypeCorvette) { fx = 384; fy = 128; width = 50.0; cx = 447; cy = 189; }
			else if(type==Common.ShipTypeCruiser) { fx = 256; fy = 128; width = 60.0; cx = 320; cy = 207; }
			else if(type==Common.ShipTypeDreadnought) { fx = 640; fy = 128; width = 60.0; cx = 702; cy = 197; }
			else if(type==Common.ShipTypeInvader) { fx = 128; fy = 128; width = 45.0; cx = 190; cy = 199; }
			else if (type == Common.ShipTypeDevastator) { fx = 0; fy = 128; width = 45.0; cx = 60; cy = 191; }
		}
		else if(race==Common.RaceTechnol) {
			if(type==Common.ShipTypeTransport) { fx = 1280; fy = 128; width = 55.0; cx = 1344; cy = 187; }
			else if(type==Common.ShipTypeCorvette) { fx = 1152; fy = 128; width = 50.0; cx = 1214; cy = 195; }
			else if(type==Common.ShipTypeCruiser) { fx = 1024; fy = 128; width = 70.0; cx = 1086; cy = 191; }
			else if(type==Common.ShipTypeDreadnought) { fx = 1408; fy = 128; width = 45.0; cx = 1474; cy = 191; }
			else if(type==Common.ShipTypeInvader) { fx = 896; fy = 128; width = 50.0; cx = 958; cy = 198; }
			else if (type == Common.ShipTypeDevastator) { fx = 768; fy = 128; width = 50.0; cx = 830; cy = 200; }
		}
		else if(race==Common.RaceGaal) {
			if(type==Common.ShipTypeTransport) { fx = 512; fy = 256; width = 60.0; cx = 576; cy = 307; }
			else if(type==Common.ShipTypeCorvette) { fx = 384; fy = 256; width = 50.0; cx = 449; cy = 319; }
			else if(type==Common.ShipTypeCruiser) { fx = 256; fy = 256; width = 60.0; cx = 320; cy = 321; }
			else if(type==Common.ShipTypeDreadnought) { fx = 640; fy = 256; width = 50.0; cx = 705; cy = 323; }
			else if(type==Common.ShipTypeInvader) { fx = 128; fy = 256; width = 50.0; cx = 191; cy = 319; }
			else if (type == Common.ShipTypeDevastator) { fx = 0; fy = 256; width = 50.0; cx = 60; cy = 319; }
		}
		else if(race==Common.RaceKling) {
			if(type==Common.ShipTypeKling0) { fx = 1408; fy = 256; width = 60.0; cx = 1473; cy = 318; }
			else if(type==Common.ShipTypeKling1) { fx = 1536; fy = 256; width = 60.0; cx = 1603; cy = 309; }
		}

		out.fx = fx;
		out.fy = fy;
		out.cx = (cx - fx) / 128.0;
		out.cy = (cy - fy) / 128.0;
		out.width = width;
		
/*		var sx:Number=1.0;
		var sy:Number=1.0;
		var name:String='';

		if(type==Common.ShipTypeFlagship) {
			if(subtype==0) { name="ImgFlagshipQ1"; sx=0.50; sy=0.50; }
			else if(subtype==1) { name="ImgFlagshipQ2"; sx=0.50; sy=0.50; }
			else if(subtype==2) { name="ImgFlagshipQ3"; sx=0.50; sy=0.50; }
			else if(subtype==3) { name="ImgFlagshipQ4"; sx=0.50; sy=0.50; }
			else if(subtype==4) { name="ImgFlagshipS1"; sx=0.50; sy=0.50; }
			else if(subtype==5) { name="ImgFlagshipS2"; sx=0.50; sy=0.50; }
			else if(subtype==6) { name="ImgFlagshipS3"; sx=0.50; sy=0.50; }
			else { name="ImgFlagshipS4"; sx=0.50; sy=0.50; }
		}
		else if(type==Common.ShipTypeWarBase) { name="ImgWarBase"; sx=0.9; sy=0.9; }
		else if(type==Common.ShipTypeShipyard) { name="ImgShipyard"; sx=0.9; sy=0.9; }
		else if (type == Common.ShipTypeSciBase) { name = "ImgSciBase"; sx = 0.9; sy = 0.9; }
		else if (type == Common.ShipTypeServiceBase) { name = "ImgServiceBase"; sx = 0.9; sy = 0.9; }
		else if (type == Common.ShipTypeQuarkBase) { name = "ImgQuarkBase"; sx = 0.9; sy = 0.9; }
		else if(race==Common.RaceGrantar) {
			if(type==Common.ShipTypeTransport) { name="ImgMalocT"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCorvette) { name="ImgMalocR"; sx=0.7; sy=0.7; }
			else if(type==Common.ShipTypeCruiser) { name="ImgMalocP"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgMalocW"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeInvader) { name="ImgMalocL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgMalocD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RacePeleng) {
			if(type==Common.ShipTypeTransport) { name="ImgPelengT"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeCorvette) { name="ImgPelengR"; sx=0.7; sy=0.7; }
			else if(type==Common.ShipTypeCruiser) { name="ImgPelengP"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgPelengW"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeInvader) { name="ImgPelengL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgPelengD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RacePeople) {
			if(type==Common.ShipTypeTransport) { name="ImgPeopleT"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeCorvette) { name="ImgPeopleR"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCruiser) { name="ImgPeopleP"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgPeopleW"; sx=0.9; sy=0.9; }
			else if(type==Common.ShipTypeInvader) { name="ImgPeopleL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgPeopleD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RaceTechnol) {
			if(type==Common.ShipTypeTransport) { name="ImgFeiT"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCorvette) { name="ImgFeiR"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCruiser) { name="ImgFeiP"; sx=0.95; sy=0.95; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgFeiW"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeInvader) { name="ImgFeiL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgFeiD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RaceGaal) {
			if(type==Common.ShipTypeTransport) { name="ImgGaalT"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeCorvette) { name="ImgGaalR"; sx=0.7; sy=0.7; }
			else if(type==Common.ShipTypeCruiser) { name="ImgGaalP"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDreadnought) { name="ImgGaalW"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeInvader) { name="ImgGaalL"; sx=0.8; sy=0.8; }
			else if(type==Common.ShipTypeDevastator) { name="ImgGaalD"; sx=0.8; sy=0.8; }
		}
		else if(race==Common.RaceKling) {
			if(type==Common.ShipTypeKling0) { name="ImgKling0"; sx=0.6; sy=0.6; }
			else if(type==Common.ShipTypeKling1) { name="ImgKling1"; sx=0.9; sy=0.9; }
		}
		
		if(name.length<=0) { name="ImgGaalD"; sx=2; sy=2; }

		var cl:Class=ApplicationDomain.currentDomain.getDefinition(name) as Class;
		var s:Sprite=new cl();
		s.scaleX=sx;
		s.scaleY=sy;
		return s;*/
	}

	public function DrawShip():void
	{
		if (m_AlphaVis <= 0.001) return;
		
		if (m_TexShips == null) m_TexShips = C3D.GetTexture("ships.png");
		if (m_TexShips.tex == null) return;
		//if(m_Stealth==2) {

		var alpha:Number;
		if (m_Stealth > 0) alpha = 0.5 * m_AlphaVis;
		else alpha = 1.0 * m_AlphaVis;

		var px:Number = m_Map.WorldToScreenX(m_PosX, m_PosY);
		var py:Number = EmpireMap.m_TWSPos.y;

		var tv:Object = new Object();
		GetTexValByType(m_Type, m_Race, m_SubType, tv);

		var clr:uint = (uint(Math.round(alpha * 255)) << 24) | 0xffffff;

		var width:Number = tv.width;
		if (!m_Battle) width *= 0.8;
		if (m_ShipNumLO && !m_IsFlyOtherPlanet) {
			if(Common.IsBase(m_Type)) width *= 1.0;
			else width *= 0.8;
		}

		var ww:Number = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
		if (ww > 1.0) ww = 1.0;
		width *= ww;

		C3D.DrawImgRotate(m_TexShips, clr, px, py, width, width, Common.IsBase(m_Type)?0:m_Angle, tv.fx, tv.fy, 128, 128, tv.cx, tv.cy);

		var angle:Number;

		// Effect
		if (m_EffectType != 0 && GraphPlanet.TexSun()) {
			width = 50.0 * ww;

			angle = (Math.floor(EmpireMap.Self.m_CurTime / 10) % 360) * C3D.ToRad;
			clr = C3D.ClrMake(1.0, 1.0, 1.0, alpha);

			C3D.DrawImgRotate(GraphPlanet.TexSun(), clr, px, py, width, width, angle, 1098, 1721, 31, 31);
		}

		// Invu
		if (m_InvuOn && GraphPlanet.TexSun() != null) {
			width = 70.0 * ww;

			angle = (Math.floor(EmpireMap.Self.m_CurTime / 100) % 360) * C3D.ToRad;
			var a:Number = (Math.floor(EmpireMap.Self.m_CurTime / 10) % 100) / (100 - 1);
			a=0.5+Math.sin(a*2.0*Math.PI)*0.5;
			clr = C3D.ClrMake(1.0, 1.0, 1.0, alpha * (0.3 + 0.7 * a));

			C3D.DrawImgRotate(GraphPlanet.TexSun(), clr, px, py, width, width, angle, 1792, 1536, 256, 256);
		}
	}

	public function DrawName():void
	{
		if (m_AlphaVis <= 0.001) return;

		if (GraphPlanet.m_TexIntf == null || GraphPlanet.m_TexIntf.tex == null) return;

		var alpha:Number;
		if (m_Stealth > 0) alpha = 0.5 * m_AlphaVis;
		else alpha = 1.0 * m_AlphaVis;
		var clr:uint = (uint(Math.round(alpha * 255)) << 24) | 0xffffff;

		var i:int, tx:int, ty:int, ttx:int, tty:int;
		var ax:Number, ay:Number;
		var px:Number = m_Map.WorldToScreenX(m_PosX, m_PosY);
		var py:Number = EmpireMap.m_TWSPos.y;

		var ww:Number = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
		if (ww > 1.0) ww = 1.0;

		var by:Number = ww * 18;
		if (m_HPBarMax > 0) by += 5;
		if (m_ShieldBarMax > 0) by += 5;
	
		// Name
		if (m_NameTex != null) {
			ax = (px - (m_NameWidth >> 1));
			ay = (py + by);
			tx = Math.floor(ax);
			ty = Math.floor(ay);
			
			ttx = Math.round((ax - tx) * 8.0);
			tty = Math.round((ay - ty) * 8.0);
			if (ttx >= 8) { tx++; ttx = 0; }
			if (tty >= 8) { ty++; tty = 0; }
			i = ttx + tty * 8;
//if(m_Name == "Император") trace(ax, ay, tx.toString() + "+" + ttx.toString(), ty.toString() + "+" + tty.toString());

			C3D.DrawImg(GraphPlanet.m_TexIntf, (uint(Math.round(alpha * 0.5 * 255)) << 24), ax - 2, ay, m_NameWidth + 4, m_NameHeight + 1, 2, 2, 1, 1);

			C3D.DrawImgSimple(m_NameTex, true, 0xffffffff, tx, ty, m_NameWidth, m_NameHeight, 0, Number(i * 16) / 1024.0, Number(m_NameWidth) / Number(m_NameWidthBM), Number(i * 16 + m_NameHeight) / 1024.0);
		}
/*		if(m_NameTL!=null) {
			C3D.Context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );

			m_NameTL.Prepare();
			if (m_NameTL.m_Font != null && m_NameTL.m_LineCnt > 0) {

				ax = (px - (m_NameTL.m_SizeX >> 1));
				ay = (py + by);
				//C3D.DrawImg(GraphPlanet.m_TexIntf, (uint(Math.round(alpha * 0.5 * 255)) << 24), ax - 2, ay, m_NameTL.m_SizeX + 4, m_NameTL.m_SizeY, 2, 2, 1, 1);

				m_NameTL.Draw(0, -1, ax, ay, 1, 1, clr);
			}
		}*/
	}
	
	public static function PrepareTex():void
	{
		if (m_TextTex != null) return;
		
		var i:int, x:int, y:int, k:int, tx:int, ty:int, u:int;
		
		var tf:TextField = new TextField();
		tf.width=1;
		tf.height=1;
		tf.type=TextFieldType.DYNAMIC;
		tf.selectable=false;
		tf.textColor=0xffffff;
		tf.alpha=0.7;
		tf.multiline=false;
		tf.autoSize=TextFieldAutoSize.LEFT;
		tf.gridFitType=GridFitType.NONE;
		tf.embedFonts=true;
		tf.defaultTextFormat = new TextFormat("Calibri", 12, 0xffffff);

		var bm:BitmapData = new BitmapData(1024, 512, true, 0x00000000);
		
		m_TextHeight = 0;
		m_TextHeightSmall = 0;

		for (u = 0; true; u++) {
			if (u == 0) tf.text = "0";
			else if (u == 1) tf.text = "1";
			else if (u == 2) tf.text = "2";
			else if (u == 3) tf.text = "3";
			else if (u == 4) tf.text = "4";
			else if (u == 5) tf.text = "5";
			else if (u == 6) tf.text = "6";
			else if (u == 7) tf.text = "7";
			else if (u == 8) tf.text = "8";
			else if (u == 9) tf.text = "9";
			else if (u == 10) tf.text = "%";
			else if (u == 11) tf.text = "-";
			else if (u == 12) { tf.defaultTextFormat = new TextFormat("Calibri", 10, 0xffffff); tf.text = "0"; }
			else if (u == 13) tf.text = "1";
			else if (u == 14) tf.text = "2";
			else if (u == 15) tf.text = "3";
			else if (u == 16) tf.text = "4";
			else if (u == 17) tf.text = "5";
			else if (u == 18) tf.text = "6";
			else if (u == 19) tf.text = "7";
			else if (u == 20) tf.text = "8";
			else if (u == 21) tf.text = "9";
			else if (u == 22) tf.text = "%";
			else if (u == 23) tf.text = "-";
			else break;

			tf.width;
			tf.height;
			
			if (u >= 11) {
				if (tf.height > m_TextHeightSmall) m_TextHeightSmall = tf.height;
			} else {
				if (tf.height > m_TextHeight) m_TextHeight = tf.height;
			}

			for (y = 0; y < 8; y++) {
				for (x = 0; x < 8; x++) {
					k = x + y * 8;
					tx = k * 16;
					ty = u * 16;
					m_NameMatrix.identity();
					m_NameMatrix.translate(Number(tx) + Number(x) / 8.0, Number(ty - 3) + Number(y) / 8.0);
					bm.draw(tf, m_NameMatrix, null, null, null, true);
				}
			}
		}

		m_TextHeight += -5;
		m_TextHeightSmall += -5;

		var r:Rectangle = new Rectangle();
		r.top = 497; r.bottom = 497 + 4;
		for (i = 0; i < 10; i++) {
			r.left = 1 + i * 5;
			r.right = r.left + 4;
			bm.fillRect(r, 0xffffffff);
		}

		m_TextTex = C3D.CreateTextureFromBM(bm, false);
		m_TextTexWidth = bm.width;
		m_TextTexHeight = bm.height;

//		if (m_NameTest == null) {
//			m_NameTest = new Bitmap();
//			EmpireMap.Self.addChild(m_NameTest);
//		}
//		m_NameTest.bitmapData = bm;
	}
	
	public static function ClearTextTex():void
	{
		if (m_TextTex != null) {
			m_TextTex.dispose();
			m_TextTex = null;
		}
		if(m_TextState!=null) {
			m_TextState.Clear();
		}

		if (EmpireMap.Self.m_ShipList != null) {
			var i:int;
			for (i = 0; i < EmpireMap.Self.m_ShipList.length; i++) {
				var gs:GraphShip = EmpireMap.Self.m_ShipList[i];
				if (gs.m_NameTex != null) {
					gs.m_NameTex.dispose();
					gs.m_NameTex = null;
				}
			}
		}
	}
	
	public static function PrepareTextBegin():void
	{
		PrepareTex();

		if (m_TextQB == null) {
			m_TextQB = new C3DQuadBatch();
			m_TextQB.Init(128, 2, 0, 2, 4);
		}
		if (m_TextState == null) {
			m_TextState = new C3DState();
		}
		m_TextOff = 0;
		m_TextState.Clear();
	}

	public static function PrepareTextEnd():void
	{
		var cnt:int;
		var d:Vector.<Number> = m_TextQB.m_Data;
		var off:int = m_TextOff * 8 * 4;
		cnt = d.length - off;
		while (cnt>0) {
			d[off++] = 0;
			cnt--;
		}
		m_TextQB.Apply();
	}
	
	public static function TextWidth(small:Boolean, str:String):Number
	{
		if (str == null) return 0;
		var cnt:int = str.length;
		if (cnt <= 0) return 0;

		var i:int, u:int, ch:int;
		var ttw:Number;
		var w:Number = 0;
		var px:Number = 0;

		for (i = 0; i < cnt; i++) {
			ch = str.charCodeAt(i);
			
			if (ch >= 48 && ch <= 57) u = ch - 48; // 0-9
			else if (ch == 37) u = 10; // %
			else if (ch == 45) u = 11; // -
			else continue;

			if (small) {
				w = px + m_TextWidthSmall[u] + 2;
				px += m_TextXAdvanceSmall[u];
			} else {
				w = px + m_TextWidth[u]+2;
				px += m_TextXAdvance[u];
			}
		}		
		return w;
	}
	
	public static function TextStr(small:Boolean, px:Number, py:Number, str:String, clr:uint):void
	{
		if (str == null) return;
		var cnt:int = str.length;
		if (cnt <= 0) return;

		if ((m_TextOff + cnt) > m_TextQB.m_Cnt) {
			m_TextQB.ChangeCnt(m_TextOff + 128);
		}
		
		if (m_TextState.m_Last == null || m_TextState.m_Last.m_TexRaw != m_TextTex) { m_TextState.Add().m_Off = m_TextOff; m_TextState.m_Last.m_TexRaw = m_TextTex; }

		var ch:int, i:int, u:int, tx:int, ty:int, ttx:int, tty:int;
		var ttw:Number, tth:Number;

		var d:Vector.<Number> = m_TextQB.m_Data;
		
		var off:int = m_TextOff * 8 * 4;

		var clrr:Number, clrg:Number, clrb:Number, clra:Number;
		clrr = C3D.ClrToFloat * ((clr >> 16) & 255);
		clrg = C3D.ClrToFloat * ((clr >> 8) & 255);
		clrb = C3D.ClrToFloat * ((clr >> 0) & 255);
		clra = C3D.ClrToFloat * ((clr >> 24) & 255);

		for (i = 0; i < cnt; i++) {
			ch = str.charCodeAt(i);
			
			if (ch >= 48 && ch <= 57) u = ch - 48; // 0-9
			else if (ch == 37) u = 10; // %
			else if (ch == 45) u = 11; // -
			else continue;

			tx = Math.floor(px);
			ty = Math.floor(py);
			
			ttx = Math.round((px - tx) * 8.0);
			tty = Math.round((py - ty) * 8.0);
			if (ttx >= 8) { tx++; ttx = 0; }
			if (tty >= 8) { ty++; tty = 0; }
			ttx = (ttx + tty * 8) * 16;
			tty = (u + (small?12:0)) * 16;

			if (small) {
				ttw = m_TextWidthSmall[u];
				tth = m_TextHeightSmall;
			} else {
				ttw = m_TextWidth[u];
				tth = m_TextHeight;
			}

			// 1
			d[off++] = tx;
			d[off++] = -ty;
			d[off++] = (ttx) / m_TextTexWidth;
			d[off++] = (tty) / m_TextTexHeight;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 2
			d[off++] = ttw + tx;
			d[off++] = -ty;
			d[off++] = (ttw + ttx) / m_TextTexWidth;
			d[off++] = (tty) / m_TextTexHeight;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 3
			d[off++] = ttw + tx;
			d[off++] = -(tth + ty);
			d[off++] = (ttw + ttx) / m_TextTexWidth;
			d[off++] = (tth + tty) / m_TextTexHeight;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			// 4
			d[off++] = tx;
			d[off++] = -(tth + ty);
			d[off++] = (ttx) / m_TextTexWidth;
			d[off++] = (tth + tty) / m_TextTexHeight;
			d[off++] = clrr;
			d[off++] = clrg;
			d[off++] = clrb;
			d[off++] = clra;

			if(small) px += m_TextXAdvanceSmall[u];
			else px += m_TextXAdvance[u];
			m_TextOff++;
			m_TextState.m_Last.m_Cnt++;
		}
	}
	
	public static function TextRect(px:Number, py:Number, width:Number, height:Number, clr:uint):void
	{
		if ((m_TextOff + 1) > m_TextQB.m_Cnt) {
			m_TextQB.ChangeCnt(m_TextOff + 128);
		}
		
		if (m_TextState.m_Last == null || m_TextState.m_Last.m_TexRaw != m_TextTex) { m_TextState.Add().m_Off = m_TextOff; m_TextState.m_Last.m_TexRaw = m_TextTex; }

		var d:Vector.<Number> = m_TextQB.m_Data;
		
		var off:int = m_TextOff * 8 * 4;

		var clrr:Number, clrg:Number, clrb:Number, clra:Number;
		clrr = C3D.ClrToFloat * ((clr >> 16) & 255);
		clrg = C3D.ClrToFloat * ((clr >> 8) & 255);
		clrb = C3D.ClrToFloat * ((clr >> 0) & 255);
		clra = C3D.ClrToFloat * ((clr >> 24) & 255);

		// 1
		d[off++] = px;
		d[off++] = -py;
		d[off++] = (2) / m_TextTexWidth;
		d[off++] = (496.0 + 2) / m_TextTexHeight;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 2
		d[off++] = width + px;
		d[off++] = -py;
		d[off++] = (3.0) / m_TextTexWidth;
		d[off++] = (496.0 + 2) / m_TextTexHeight;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 3
		d[off++] = width + px;
		d[off++] = -(height + py);
		d[off++] = (3.0) / m_TextTexWidth;
		d[off++] = (496.0 + 3) / m_TextTexHeight;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 4
		d[off++] = px;
		d[off++] = -(height + py);
		d[off++] = (2.0) / m_TextTexWidth;
		d[off++] = (496.0 + 3) / m_TextTexHeight;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		m_TextOff++;
		m_TextState.m_Last.m_Cnt++;
	}

	public static function TextImg(tex:Texture, px:Number, py:Number, width:Number, height:Number, clr:uint, u1:Number = 0.0, v1:Number = 0.0, u2:Number = 1.0, v2:Number = 1.0):void
	{
		if ((m_TextOff + 1) > m_TextQB.m_Cnt) {
			m_TextQB.ChangeCnt(m_TextOff + 128);
		}
		
		if (m_TextState.m_Last == null || m_TextState.m_Last.m_TexRaw != tex) { m_TextState.Add().m_Off = m_TextOff; m_TextState.m_Last.m_TexRaw = tex; }

		var d:Vector.<Number> = m_TextQB.m_Data;
		
		var off:int = m_TextOff * 8 * 4;

		var clrr:Number, clrg:Number, clrb:Number, clra:Number;
		clrr = C3D.ClrToFloat * ((clr >> 16) & 255);
		clrg = C3D.ClrToFloat * ((clr >> 8) & 255);
		clrb = C3D.ClrToFloat * ((clr >> 0) & 255);
		clra = C3D.ClrToFloat * ((clr >> 24) & 255);

		// 1
		d[off++] = px;
		d[off++] = -py;
		d[off++] = u1;
		d[off++] = v1;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 2
		d[off++] = width + px;
		d[off++] = -py;
		d[off++] = u2;
		d[off++] = v1;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 3
		d[off++] = width + px;
		d[off++] = -(height + py);
		d[off++] = u2;
		d[off++] = v2;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		// 4
		d[off++] = px;
		d[off++] = -(height + py);
		d[off++] = u1;
		d[off++] = v2;
		d[off++] = clrr;
		d[off++] = clrg;
		d[off++] = clrb;
		d[off++] = clra;

		m_TextOff++;
		m_TextState.m_Last.m_Cnt++;
	}

	public function PrepareText():void
	{
		if (m_TextTex == null) return;
		if (m_AlphaVis <= 0.001) return;

		var texsun:C3DTexture = GraphPlanet.TexSun();
		if (texsun == null) return;

		var k:int, h:int, h2:int;
		var clr:uint;
		var a:Number, v:Number;
		var texr:Texture;

		var alpha:Number = m_AlphaVis;
		//if (m_Stealth > 0) alpha = 0.5 * m_AlphaVis;
		//else alpha = 1.0 * m_AlphaVis;

		var px:Number = m_Map.WorldToScreenX(m_PosX, m_PosY);
		var py:Number = EmpireMap.m_TWSPos.y;
		var tx:Number, ty:Number;

		var ww:Number = Number(C3D.m_SizeY >> 1) / (EmpireMap.Self.m_FovHalfTan * EmpireMap.Self.m_CamDist);
		if (ww > 1.0) ww = 1.0;
		
		// Build
		while (m_BuildState > 0) {
			tx = px - 15;
			ty = py - 4 + Math.round(10 * ww);

			clr = C3D.ClrReplaceAlpha(0x000000, alpha * 0.8, true);
			TextRect(tx - 2, ty - 2, 30 + 4, 5 + 4, clr);
			
			clr = C3D.ClrReplaceAlpha(m_BuildStateClr, alpha, true);
			TextRect(tx, ty, Math.round(30.0 * m_BuildState / 100), 5, clr);
			break;
		}
		
		// Cnt
		var cnt_right:Number = -100;
		var cnt_top:Number = -100;
		if (m_CntVal != null && m_CntVal.length > 0) {
			k = TextWidth(false, m_CntVal);
			h = m_TextHeight;
			h2 = m_TextHeight;
			if (m_CntVal2 != null && m_CntVal2.length > 0) {
				k = Math.max(k, TextWidth(false, m_CntVal2));
				h2 += m_TextHeight;
				if (!m_CntRazdel) h += m_TextHeight;
			}

			tx = px - ww * ((m_Type == Common.ShipTypeFlagship || m_Type == Common.ShipTypeQuarkBase)?25:20) - (k >> 1);
			ty = py - ww * ((m_Type == Common.ShipTypeFlagship || m_Type == Common.ShipTypeQuarkBase)?30:25) - (h2 >> 1);

			while(true) {
				a = 1.0;
				if (m_Battle) {}
				else if (m_ShipNumLO) break;
				else if (!m_NoBattle && (Math.floor(EmpireMap.Self.m_CurTime / 300) & 1) == 0) a = 0.6;
				else break;

				clr = C3D.ClrReplaceAlpha(0xffff00, alpha * a, true);
				//if ((m_Flag & Common.ShipFlagSiege) == 0) {
				if ((m_Flag & Common.ShipFlagNanits) == 0) {
					TextRect(tx - 1, ty - 1 - 1, k + 2, 2, clr);
					TextRect(tx - 1, ty + h + 1 - 1, k + 2, 2, clr);
				} else {
					TextRect(tx - 1, ty - 1 - 1, 5, 2, clr);
					TextRect(tx - 1, ty + h + 1 - 1, 5, 2, clr);
					TextRect(tx + 1 + k - 5, ty - 1 - 1, 5, 2, clr);
					TextRect(tx + 1 + k - 5, ty + h + 1 - 1, 5, 2, clr);
				}
				TextRect(tx - 1, ty - 1 + 1, 2, h - 0, clr);
				TextRect(tx + k - 1, ty - 1 + 1, 2, h - 0, clr);
				break;
			}
			clr = C3D.ClrReplaceAlpha(m_Clr, alpha * (m_Battle?1.0:0.5), true);
			TextRect(tx, ty - 1, k, h + 2, clr);
			if (m_CntRazdel && m_CntVal2 != null && m_CntVal2.length > 0) {
				clr = C3D.ClrReplaceAlpha(m_Clr, alpha * 0.7 * (m_Battle?1.0:0.5), true);
				TextRect(tx, ty - 1 + m_TextHeight + 3, k, h + 2, clr);
			}

			clr = C3D.ClrReplaceAlpha(0xffffff, alpha, true);
			TextStr(false, tx, ty, m_CntVal, clr);
			cnt_right = tx + k;
			cnt_top = ty;

			if (m_CntVal2 != null && m_CntVal2.length > 0) {
				clr = C3D.ClrReplaceAlpha(0xffffff, alpha, true);
				TextStr(false, tx, ty + m_TextHeight + (m_CntRazdel?3:0), m_CntVal2, clr);
				cnt_right = tx + k;
				cnt_top = ty;
			}
		}

		// AIAttackVal
		while (cnt_right != -100 && m_AIAttackVal) {
			tx = cnt_right - 1;
			ty = cnt_top + 1;
			cnt_right += 10;
			
			clr = C3D.ClrReplaceAlpha(0xffffff, alpha, true);
			TextImg(texsun.tex, tx, ty, 13, 13, clr, 1068 / texsun.m_Height, 1700 / texsun.m_Height, (1068 + 13) / texsun.m_Height, (1700 + 13) / texsun.m_Height);
			break;
		}

		// AIRouteVal
		while (cnt_right != -100 && m_AIRouteVal) {
			tx = cnt_right - 1;
			ty = cnt_top + 1;
			cnt_right += 10;
			
			clr = C3D.ClrReplaceAlpha(0xffffff, alpha, true);
			TextImg(texsun.tex, tx, ty, 13, 13, clr, 1083 / texsun.m_Height, 1700 / texsun.m_Height, (1083 + 13) / texsun.m_Height, (1700 + 13) / texsun.m_Height);
			break;
		}

		// Fuel
		if (m_FuelVal != null && m_FuelVal.length > 0) {
			k = TextWidth(false, m_FuelVal);

			tx = px - ww * 20 - (k >> 1);
			ty = py - (m_TextHeight >> 1);

			clr = C3D.ClrReplaceAlpha(0x202020, alpha, true);
			TextRect(tx, ty - 1, k, m_TextHeight + 2, clr);

			clr = C3D.ClrReplaceAlpha(0xffffff, alpha, true);
			TextStr(false, tx, ty, m_FuelVal, clr);
		}

		// Points
		if (m_PointsVal != null && m_PointsVal.length > 0) {
			k = 20 + TextWidth(true, m_PointsVal);

			tx = px + 10 * ww;
			ty = py - 20 * ww - (m_TextHeightSmall >> 1);

			clr = C3D.ClrReplaceAlpha(0xc9ed3b, alpha, true);
			TextRect(tx, ty - 2, k + 2, m_TextHeightSmall + 4, clr);
			
			clr = C3D.ClrReplaceAlpha(0x000000, alpha, true);
			TextStr(true, tx + 20, ty, m_PointsVal, clr);
			
//			m_PointsTL.Draw(0, -1, x, y, 1, 1);

			// img
			while (m_PointsImgNum != 0) {
				texr = Common.ItemTex(m_PointsImgNum);
				if (texr == null) break;

				v = 64 * Common.ItemScale(m_PointsImgNum);
				if (m_PointsType == Common.ItemTypeFuel) v *= 0.6;
				else v *= 0.7;

				clr = C3D.ClrReplaceAlpha(0xffffff, alpha, true);
				TextImg(texr, tx + 10 - (v * 0.5), ty + (m_TextHeightSmall >> 1) - (v * 0.5), v, v, clr);

				break;
			}
		}

		// Item
		while (m_ItemType != 0 && m_ItemNum != 0) {
			tx = px + ww * 20;
			ty = py + ww * 15 - (m_TextHeight >> 1);

			texr = Common.ItemTex(m_ItemNum);
			if (texr == null) break;

			v = 64 * Common.ItemScale(m_ItemNum) * 0.7;
			if (!m_Battle) v *= 0.8;

			clr = C3D.ClrReplaceAlpha(0xffffff, alpha, true);
			TextImg(texr, tx - (v * 0.5), ty + (m_TextHeight >> 1) - (v * 0.5), v, v, clr);

			break;
		}
		
		// ItemCnt
		if (m_ItemCntVal != null && m_ItemCntVal.length > 0) {
			k = TextWidth(false, m_ItemCntVal);

			tx = px + ww * 25;
			ty = py + ww * 15 - (m_TextHeight >> 1);

			clr = C3D.ClrReplaceAlpha(0x202020, alpha, true);
			TextRect(tx, ty - 1, k, m_TextHeight + 2, clr);

			clr = C3D.ClrReplaceAlpha(0xffffff, alpha, true);
			TextStr(false, tx, ty, m_ItemCntVal, clr);
		}
		
		// HP
		if (m_HPBarMax > 0) {
			tx = px - ((m_HPBarMax * 5 + 1) >> 1);
			ty = py + ww * 17;

			clr = C3D.ClrReplaceAlpha(0x000000, 0.5 * alpha, true);
			TextRect(tx, ty, m_HPBarMax * 5 + 1, 6, clr);

			clr = C3D.ClrReplaceAlpha(0xff0000, alpha * (m_HPBarState == 0?1.0:0.5), true);
			TextImg(m_TextTex, tx, ty, 1 + m_HPBarVal * 5, 5, clr, 0, 496.0 / 512.0, (1 + m_HPBarVal * 5) / 1024.0, (496.0 + 5.0) / 512.0);
		}

		// Shield
		if (m_ShieldBarMax > 0) {
			tx = px - ((m_ShieldBarMax * 5 + 1) >> 1);
			ty = py + ww * 17 + ((m_HPBarMax > 0)?6:0);

			clr = C3D.ClrReplaceAlpha(0x000000, 0.5 * alpha, true);
			TextRect(tx, ty, m_ShieldBarMax * 5 + 1, 6, clr);

			if (m_ShieldBarState == 2) clr = C3D.ClrReplaceAlpha(0xffff00, alpha, true);
			else clr = C3D.ClrReplaceAlpha(0x00e1dd, alpha * (m_ShieldBarState == 0?1.0:0.5), true);
			TextImg(m_TextTex, tx, ty, 1 + m_ShieldBarVal * 5, 5, clr, 0, 496.0 / 512.0, (1 + m_ShieldBarVal * 5) / 1024.0, (496.0 + 5.0) / 512.0);
		}
	}

	public static function DrawText():void
	{
		if (m_TextOff <= 0) return;

		var x:Number = 0;
		var y:Number = 0;

		C3D.SetVConst_n(0, x - C3D.m_SizeX * 0.5, -(y - C3D.m_SizeY * 0.5), 2.0 / C3D.m_SizeX, 2.0 / C3D.m_SizeY);
		C3D.SetVConst_n(1, 0.0, 0.5, 1.0, 2.0);

		C3D.SetFConst_n(0, 0.0, 0.5, 1.0, 2.0);
		C3D.SetFConst_n(1, 1.0, 1.0, 1.0, 1.0);
		C3D.SetFConst_n(2, 1.0, 1.0, 1.0, 1.0);

		C3D.ShaderText(false, true);
		C3D.VBQuadBatch(m_TextQB);
		var sb:C3DStateBatch = m_TextState.m_First;
		while(sb!=null) {
			C3D.SetTexture(0, sb.m_TexRaw);
			C3D.DrawQuadBatch(sb.m_Off, sb.m_Cnt);
			sb = sb.m_Next;
		}
		C3D.SetTexture(0, null);
	}
}

}
