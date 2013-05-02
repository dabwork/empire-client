package Empire
{

import Base.*;
import Engine.*;
import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.text.engine.*;
import flash.utils.*;

public class GraphBullet// extends Shape
{
	private var m_Map:EmpireMap;
	
	public var m_FromSectorX:int;
	public var m_FromSectorY:int;
	public var m_FromPlanetNum:int;
	public var m_FromShipNum:int;

	public var m_ToSectorX:int=0;
	public var m_ToSectorY:int=0;
	public var m_ToPlanetNum:int=-1;
	public var m_ToShipNum:int = -1;
	
	public var m_ToId:uint = 0;

	public var m_FromX:Number;
	public var m_FromY:Number;
	public var m_Angle:Number=0;
	public var m_ToX:Number;
	public var m_ToY:Number;
	public var m_BeginTime:Number;
	public var m_EndTime:Number;
	
	public var m_MoveDirX:Number;
	public var m_MoveDirY:Number;
	
	static public const TypePlasma:int=0;
	static public const TypeInvader:int=1;
	static public const TypeLaser:int=2;
	static public const TypeSimple:int=3;
	static public const TypeMissile:int=4;
	
	public var m_LastTime:Number=0;
	public var m_OldDist:Number=0;
	
	public var m_Type:int; // 0-Normal
	
	public var m_Color:uint=0xffffff;
	
	static public var m_EmptyFirst:GraphBulletParticle = null;
	static public var m_EmptyLast:GraphBulletParticle = null;
	static public var m_First:GraphBulletParticle = null;
	static public var m_Last:GraphBulletParticle = null;
	
	public static var m_QuadBatch:C3DQuadBatch = new C3DQuadBatch();
	
//	public static var m_Texture:C3DTexture = null;

	public function GraphBullet(map:EmpireMap)
	{
		m_Map=map;
		m_Type=TypePlasma;
	}

	public function Update():Boolean
	{
		var ra:Array;

		//graphics.clear();

		var ct:Number=(Common.GetTime()-m_BeginTime)/(m_EndTime-m_BeginTime);
		if(ct<=0.0) return true;
		if(m_Type!=TypeMissile && ct>=1.0) return false;

		var fx:Number,fy:Number,tx:Number,ty:Number,dirx:Number,diry:Number,dist:Number,len:Number,alpha:Number
		var gsfrom:GraphShip;
		var gsto:GraphShip;

		var toplanet:Planet=null;
		if(m_ToPlanetNum>=0) {
			toplanet=m_Map.GetPlanet(m_ToSectorX,m_ToSectorY,m_ToPlanetNum);
			if(toplanet==null) return true;
		} 

		if(m_Type==TypeSimple) {
			gsfrom=m_Map.GetGraphShip(m_FromSectorX,m_FromSectorY,m_FromPlanetNum,m_FromShipNum);
			if(gsfrom==null) return false;

/*			if(m_ToShipNum>=0) {
				gsto=m_Map.GetGraphShip(m_ToSectorX,m_ToSectorY,m_ToPlanetNum,m_ToShipNum);
				if(gsto==null) {
					ra=m_Map.CalcShipPlace(toplanet,m_ToShipNum);
					tx=ra[0];
					ty=ra[1];
				} else {
					tx=gsto.m_PosX;
					ty=gsto.m_PosY;
				}
			} else {
				tx=toplanet.m_PosX;
				ty=toplanet.m_PosY;
			}

			fx = m_Map.WorldToScreenX(gsfrom.m_PosX + m_FromX, gsfrom.m_PosY + m_FromY);
			fy = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(gsfrom.m_PosY+m_FromY);
			tx = m_Map.WorldToScreenX(tx + m_ToX + m_MoveDirX * ct, ty + m_ToY + m_MoveDirY * ct);
			ty = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(ty+m_ToY+m_MoveDirY*ct);

			dirx=tx-fx; diry=ty-fy;
			dist=Math.sqrt(dirx*dirx+diry*diry);
			dirx/=dist; diry/=dist;
			
			fx+=dirx*10.0;
			fy+=diry*10.0;
			
			if(ct<0.05) alpha=ct/0.05;
			else if(ct>0.95) alpha=(1.0-ct)/0.05;
			else alpha=1.0;

//			graphics.lineStyle(2,0xffff00,alpha);
//			graphics.lineGradientStyle(GradientType.LINEAR,[m_Color,m_Color,m_Color],[0,0,alpha],[0,128,255],Common.MatrixForGradientLine(fx,fy,tx,ty));//,SpreadMethod.PADD,InterpolationMethod.RGB);
//			graphics.moveTo(fx,fy);
//			graphics.lineTo(tx,ty);
*/
			return true;

		} else if(m_Type==TypeLaser) {
			gsfrom=m_Map.GetGraphShip(m_FromSectorX,m_FromSectorY,m_FromPlanetNum,m_FromShipNum);
			if (gsfrom == null) return false;
			
			gsto = m_Map.GetGraphShip(m_ToSectorX, m_ToSectorY, m_ToPlanetNum, m_ToShipNum);
			if (gsto == null) return false;
			if (m_ToId == 0) m_ToId = gsto.m_Id;
			else if (m_ToId != gsto.m_Id) return false;
			
/*			gsto=m_Map.GetGraphShip(m_ToSectorX,m_ToSectorY,m_ToPlanetNum,m_ToShipNum);
			if(gsto==null) {
				ra=m_Map.CalcShipPlace(toplanet,m_ToShipNum);
				tx=ra[0];
				ty=ra[1];
			} else {
				tx=gsto.m_PosX;
				ty=gsto.m_PosY;
			}

			fx = m_Map.WorldToScreenX(gsfrom.m_PosX + m_FromX, gsfrom.m_PosY + m_FromY);
			fy = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(gsfrom.m_PosY+m_FromY);
			tx = m_Map.WorldToScreenX(tx + m_ToX + m_MoveDirX * ct, ty + m_ToY + m_MoveDirY * ct);
			ty = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(ty+m_ToY+m_MoveDirY*ct);

			dirx=tx-fx; diry=ty-fy;
			dist=Math.sqrt(dirx*dirx+diry*diry);
			dirx/=dist; diry/=dist;

			fx+=dirx*10.0;
			fy+=diry*10.0;

			if(ct<0.2) alpha=ct/0.2;
			else if(ct>0.8) alpha=(1.0-ct)/0.2;
			else alpha=1.0;

//			graphics.lineStyle(2);
//			graphics.lineGradientStyle(GradientType.LINEAR,[m_Color,m_Color,m_Color],[0,alpha,alpha],[0,100,255],Common.MatrixForGradientLine(fx,fy,tx,ty));//,SpreadMethod.PADD,InterpolationMethod.RGB);
//			graphics.moveTo(fx,fy);
//			graphics.lineTo(tx,ty);
*/
			return true;

		} else if(m_Type==TypeMissile) {
			gsto=m_Map.GetGraphShip(m_ToSectorX,m_ToSectorY,m_ToPlanetNum,m_ToShipNum);
			if(gsto==null) {
				m_Map.CalcShipPlaceEx(toplanet,m_ToShipNum,EmpireMap.m_TPos);
				tx = EmpireMap.m_TPos.x;
				ty = EmpireMap.m_TPos.y;
			} else {
				tx = gsto.m_PosX;
				ty = gsto.m_PosY;
			}

			var vx:Number = tx - m_FromX;
			var vy:Number = ty - m_FromY;
			
			var needangle:Number = Math.atan2(vx, -vy);

			var cttt:Number = Common.GetTime();
			if (m_LastTime == 0) m_LastTime = cttt;
			var st:Number = cttt - m_LastTime;
			m_LastTime = cttt;

			var speed:Number = 0.15 * st;
			var aspeed:Number = Math.PI / 180 * 0.2 * st;

			if (ct > 1.0) {
				var ad:Number = BaseMath.AngleDist(m_Angle, needangle);
				if (Math.abs(ad) <= aspeed) m_Angle = needangle;
				else {
					if (ad < 0) m_Angle = BaseMath.AngleNorm(m_Angle-aspeed);
					else m_Angle = BaseMath.AngleNorm(m_Angle + aspeed);
				}
			}
			
			var cd2:Number = vx * vx + vy * vy;
			if (cd2 < 100) return false;
			if (ct > 3.0) {
				if (cd2 > m_OldDist) return false;
			}
			m_OldDist = cd2;

			m_FromX += speed * Math.sin(m_Angle);
			m_FromY += -speed * Math.cos(m_Angle);
			
/*			vx = m_Map.WorldToScreenX(m_FromX, m_FromY);
			vy = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(m_FromY);
			
			if(false) {
				if(m_Missile==null) {
					m_Missile=new Missile();
					m_Map.m_BulletLayer.addChild(m_Missile);
				} 
			} else {
				if(m_MissileBM==null) {
					m_MissileBM=new Bitmap();
					m_Map.m_BulletLayer.addChild(m_MissileBM);
				} 
			}
			
			if (m_Missile != null) {
				m_Missile.x = vx;
				m_Missile.y = vy;
				m_Missile.rotation = m_Angle * 180.0 / Math.PI;
				
			} else if (m_MissileBM != null) {
				m_MissileBM.bitmapData = m_Map.m_GraphShipImgs.GetMissile(m_Angle);
				m_MissileBM.x = vx-(m_MissileBM.bitmapData.width>>1);
				m_MissileBM.y = vy - (m_MissileBM.bitmapData.height >> 1);
			}

//			graphics.lineStyle(2,m_Color,0.9);
//			graphics.moveTo(vx,vy);
//			graphics.lineTo(vx+5.0*Math.sin(m_Angle),vy-5.0*Math.cos(m_Angle));
*/
			return true;
		}

/*		fx = m_Map.WorldToScreenX(m_FromX, m_FromY);
		fy = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(m_FromY);
		tx = m_Map.WorldToScreenX(m_ToX, m_ToY);
		ty = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(m_ToY);

		dirx=tx-fx; diry=ty-fy;
		dist=Math.sqrt(dirx*dirx+diry*diry);
		dirx/=dist; diry/=dist;

		if(m_Type==TypeInvader) {
			len=1.0;
			if(len>dist*(1.0-ct)) len=dist*(1.0-ct);
			
			tx=fx+dirx*dist*ct+dirx*len;
			ty=fy+diry*dist*ct+diry*len;

			len=1.0;
			if(len>dist*ct) len=dist*ct;

			fx+=dirx*dist*ct-dirx*len;
			fy+=diry*dist*ct-diry*len;

//			graphics.lineStyle(2,m_Color,0.5);
//			graphics.moveTo(fx,fy);
//			graphics.lineTo(tx,ty);

		} else {
			tx=fx+dirx*dist*ct;
			ty=fy+diry*dist*ct;
	
			len=5.0;
			if(len>dist*ct) len=dist*ct;
	
			fx+=dirx*dist*ct-dirx*len;
			fy+=diry*dist*ct-diry*len;
	
//			graphics.lineStyle(2,m_Color,0.9);
//			graphics.moveTo(fx,fy);
//			graphics.lineTo(tx,ty);
		}*/

		return true;
	}

	public function FromInit(x:Number,y:Number,rndradius:Number):void
	{
		m_FromX=x;
		m_FromY=y;
		if(rndradius>0) {
			var a:Number=Math.random()*Math.PI*2.0;
			m_FromX+=Math.sin(a)*rndradius;
			m_FromY+=Math.cos(a)*rndradius;
		}
	}

	public function ToInit(x:Number,y:Number,rndradius:Number, speed:Number=0):void
	{
		m_ToX=x;
		m_ToY=y;
		if(rndradius>0) {
			var a:Number=Math.random()*Math.PI*2.0;
			m_ToX+=Math.sin(a)*rndradius;
			m_ToY+=Math.cos(a)*rndradius;
		}
		var dirx:Number=m_ToX-m_FromX;
		var diry:Number=m_ToY-m_FromY;
		var dist:Number=Math.sqrt(dirx*dirx+diry*diry);

		if(speed==0) speed=0.15;

		m_EndTime=m_BeginTime+Math.round(dist/speed);
	}

	public function FromInitEx(secx:int,secy:int,planetnum:int,shipnum:int, rndradius:Number):void
	{
		m_Type=TypeLaser;

		m_FromSectorX=secx;
		m_FromSectorY=secy;
		m_FromPlanetNum=planetnum;
		m_FromShipNum=shipnum;
		m_FromX=0;
		m_FromY=0;
		if(rndradius>0) {
			var a:Number=Math.random()*Math.PI*2.0;
			m_FromX+=Math.sin(a)*rndradius;
			m_FromY+=Math.cos(a)*rndradius;
		}
	}

	public function ToInitEx(secx:int,secy:int,planetnum:int,shipnum:int, rndradius:Number, period:Number):void
	{
		m_ToSectorX=secx;
		m_ToSectorY=secy;
		m_ToPlanetNum=planetnum;
		m_ToShipNum=shipnum;
		m_ToX=0;
		m_ToY=0;
		m_MoveDirX=0;
		m_MoveDirY=0;
		if(rndradius>0) {
			var a:Number=Math.random()*Math.PI*2.0;
			m_ToX+=Math.sin(a)*rndradius;
			m_ToY+=Math.cos(a)*rndradius;

			m_MoveDirX=-m_ToX;
			m_MoveDirY=-m_ToY;
			var d:Number=1.0/Math.sqrt(m_MoveDirX*m_MoveDirX+m_MoveDirY*m_MoveDirY);
			m_MoveDirX*=d*rndradius*2.0;
			m_MoveDirY*=d*rndradius*2.0;
		}

		m_EndTime=m_BeginTime+period;
	}
	
	public static function PAdd():GraphBulletParticle 
	{
		var p:GraphBulletParticle = m_EmptyFirst;
		if (p != null) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_EmptyLast == p) m_EmptyLast = GraphBulletParticle(p.m_Prev);
			if (m_EmptyFirst == p) m_EmptyFirst = GraphBulletParticle(p.m_Next);
		} else {
			p = new GraphBulletParticle();
		}
		if (m_Last != null) m_Last.m_Next = p;
		p.m_Prev = m_Last;
		p.m_Next = null;
		m_Last = p;
		if (m_First == null) m_First = p;
		return p;
	}

	public static function PDel(p:GraphBulletParticle):void
	{
		if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
		if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
		if (m_Last == p) m_Last = GraphBulletParticle(p.m_Prev);
		if (m_First == p) m_First = GraphBulletParticle(p.m_Next);

		//p.Clear();

		if (m_EmptyLast != null) m_EmptyLast.m_Next = p;
		p.m_Prev = m_EmptyLast;
		p.m_Next = null;
		m_EmptyLast = p;
		if (m_EmptyFirst == null) m_EmptyFirst = p;
	}
	
	public static function PClear():void
	{
		var p:GraphBulletParticle;
		var pnext:GraphBulletParticle = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = GraphBulletParticle(pnext.m_Next);
			PDel(p);
		}
	}

	public function PPrepare():Boolean
	{
		var p:GraphBulletParticle;
		
		var ct:Number = (EmpireMap.Self.m_CurTime-m_BeginTime) / (m_EndTime-m_BeginTime);
		if (ct <= 0.0) return true;
		if (m_Type != TypeMissile && ct >= 1.0) return false;

		var fx:Number, fy:Number, tx:Number, ty:Number, dirx:Number, diry:Number, dist:Number, len:Number, alpha:Number, k:Number;
		var gsfrom:GraphShip;
		var gsto:GraphShip;

		var toplanet:Planet = null;
		if (m_ToPlanetNum >= 0) {
			toplanet = EmpireMap.Self.GetPlanet(m_ToSectorX, m_ToSectorY, m_ToPlanetNum);
			if (toplanet == null) return true;
		} 

		if (m_Type == TypeSimple) {
			return true;
		} else if (m_Type == TypeLaser) {
			gsfrom = m_Map.GetGraphShip(m_FromSectorX, m_FromSectorY, m_FromPlanetNum, m_FromShipNum);
			if (gsfrom == null) return false;
			gsto = m_Map.GetGraphShip(m_ToSectorX, m_ToSectorY, m_ToPlanetNum, m_ToShipNum);
			if (gsto == null) {
				EmpireMap.Self.CalcShipPlaceEx(toplanet, m_ToShipNum, EmpireMap.m_TPos);
				tx = EmpireMap.m_TPos.x;
				ty = EmpireMap.m_TPos.y;
			} else {
				tx = gsto.m_PosX;
				ty = gsto.m_PosY;
			}
			
			fx = gsfrom.m_PosX + m_FromX;
			fy = gsfrom.m_PosY + m_FromY;
			tx = tx + m_ToX + m_MoveDirX * ct;
			ty = ty + m_ToY + m_MoveDirY * ct;

			if (!EmpireMap.Self.m_Frustum.IsIn(fx - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize, fy - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize, 0, 20.0)) {
				if (!EmpireMap.Self.m_Frustum.IsIn(tx - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize, ty - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize, 0, 20.0)) {
					return true;
				}
			}

			dirx = tx - fx; diry = ty - fy;
			dist = Math.sqrt(dirx * dirx + diry * diry);
			k = 1.0 / dist; dirx *= k; diry *= k;

			fx += dirx * 10.0;
			fy += diry * 10.0;
			dist -= 10.0;

			if (ct < 0.2) alpha = ct / 0.2;
			else if (ct > 0.8) alpha = (1.0 - ct) / 0.2;
			else alpha = 1.0;

			p = PAdd();
			p.m_Flag = C3DParticle.FlagShow;
			p.m_PosX = fx - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize;
			p.m_PosY = fy - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize;
			p.m_PosZ = 0.0 - EmpireMap.Self.m_CamPos.z;
			p.m_DirX = dirx;
			p.m_DirY = diry;
			p.m_DirZ = 0.0;
			p.m_NormalX = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 0];
			p.m_NormalY = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 1];
			p.m_NormalZ = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 2];
			p.m_Width = 2.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
			p.m_Height = dist * 0.5;
			p.m_U1 = 1135.0 / 2048.0;
			p.m_V1 = 1734.0 / 2048.0;
			p.m_U2 = (1135.0 + 12) / 2048.0;
			p.m_V2 = (1734.0 + 12) / 2048.0;
			p.m_Color = C3D.ClrReplaceAlpha(m_Color, 0.0);
			p.m_ColorTo = C3D.ClrReplaceAlpha(m_Color, alpha);
			
			p = PAdd();
			p.m_Flag = C3DParticle.FlagShow | C3DParticle.FlagContinue;
			p.m_PosX = fx + dirx * dist * 0.5 - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize;
			p.m_PosY = fy + diry * dist * 0.5 - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize;
			p.m_PosZ = 0.0 - EmpireMap.Self.m_CamPos.z;
			p.m_DirX = dirx;
			p.m_DirY = diry;
			p.m_DirZ = 0.0;
			p.m_NormalX = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 0];
			p.m_NormalY = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 1];
			p.m_NormalZ = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 2];
			p.m_Width = 2.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
			p.m_Height = dist * 0.5;
			p.m_U1 = 1135.0 / 2048.0;
			p.m_V1 = 1734.0 / 2048.0;
			p.m_U2 = (1135.0 + 12) / 2048.0;
			p.m_V2 = (1734.0 + 12) / 2048.0;
			p.m_Color = C3D.ClrReplaceAlpha(m_Color, alpha);
			p.m_ColorTo = p.m_Color;

//			graphics.lineStyle(2);
//			graphics.lineGradientStyle(GradientType.LINEAR,[m_Color,m_Color,m_Color],[0,alpha,alpha],[0,100,255],Common.MatrixForGradientLine(fx,fy,tx,ty));//,SpreadMethod.PADD,InterpolationMethod.RGB);
//			graphics.moveTo(fx,fy);
//			graphics.lineTo(tx,ty);

			return true;
		} else if (m_Type == TypeMissile) {
/*			gsto = m_Map.GetGraphShip(m_ToSectorX, m_ToSectorY, m_ToPlanetNum, m_ToShipNum);
			if (gsto == null) {
				EmpireMap.Self.CalcShipPlaceEx(toplanet, m_ToShipNum, EmpireMap.m_TPos);
				tx = EmpireMap.m_TPos.x;
				ty = EmpireMap.m_TPos.y;
			} else {
				tx = gsto.m_PosX;
				ty = gsto.m_PosY;
			}

			var vx:Number = tx - m_FromX;
			var vy:Number = ty - m_FromY;
			
			var needangle:Number = Math.atan2(vx, -vy);

			var cttt:Number = EmpireMap.Self.m_CurTime;
			if (m_LastTime == 0) m_LastTime = cttt;
			var st:Number = cttt - m_LastTime;
			m_LastTime = cttt;

			var speed:Number = 0.15 * st;
			var aspeed:Number = Math.PI / 180 * 0.2 * st;

			if (ct > 1.0) {
				var ad:Number = Common.AngleDist(m_Angle, needangle);
				if (Math.abs(ad) <= aspeed) m_Angle = needangle;
				else {
					if (ad < 0) m_Angle = Common.AngleNorm(m_Angle-aspeed);
					else m_Angle = Common.AngleNorm(m_Angle + aspeed);
				}
			}
			
			var cd2:Number = vx * vx + vy * vy;
			if (cd2 < 100) return false;
			if (ct > 3.0) {
				if (cd2 > m_OldDist) return false;
			}
			m_OldDist = cd2;

			//m_FromX += speed * Math.sin(m_Angle);
			//m_FromY += -speed * Math.cos(m_Angle);
			
			vx = m_FromX;
			vy = m_FromY;
*/
			if (!EmpireMap.Self.m_Frustum.IsIn(m_FromX - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize, m_FromY - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize, 0, 10.0)) {
				return true;
			}

			p = PAdd();
			p.m_Flag = C3DParticle.FlagShow;
			p.m_Width = 8.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
			p.m_Height = 20.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
			p.m_DirX = Math.sin(m_Angle);
			p.m_DirY = -Math.cos(m_Angle);
			p.m_DirZ = 0.0;
			p.m_PosX = m_FromX - p.m_DirX * p.m_Height * 0.5 - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize;
			p.m_PosY = m_FromY - p.m_DirY * p.m_Height * 0.5 - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize;
			p.m_PosZ = 0.0 - EmpireMap.Self.m_CamPos.z;
			p.m_NormalX = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 0];
			p.m_NormalY = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 1];
			p.m_NormalZ = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 2];
			p.m_U1 = 1116.0 / 2048.0;
			p.m_V1 = (1666.0 + 32) / 2048.0;
			p.m_U2 = (1116.0 + 12) / 2048.0;
			p.m_V2 = 1666.0 / 2048.0;
//			p.m_U1 = 1133.0 / 2048.0;
//			p.m_V1 = (1666.0 + 58) / 2048.0;
//			p.m_U2 = (1133.0 + 18) / 2048.0;
//			p.m_V2 = 1666.0 / 2048.0;
			p.m_Color = C3D.ClrReplaceAlpha(0xffffff, 1.0);
			p.m_ColorTo = p.m_Color;

//			m_Missile.x = vx;
//			m_Missile.y = vy;
//			m_Missile.rotation = m_Angle * 180.0 / Math.PI;

			return true;
		}

		fx = m_FromX;
		fy = m_FromY;
		tx = m_ToX;
		ty = m_ToY;

		dirx = tx - fx; diry = ty - fy;
		dist = Math.sqrt(dirx * dirx + diry * diry);
		k = 1.0 / dist; dirx *= k; diry *= k;

		if(m_Type==TypeInvader) {
			len = 1.0;
			if (len > dist * (1.0 - ct)) len = dist * (1.0 - ct);
			
			tx = fx + dirx * dist * ct + dirx * len;
			ty = fy + diry * dist * ct + diry * len;

			len = 1.0;
			if (len > dist * ct) len = dist * ct;

			fx += dirx * dist * ct - dirx * len;
			fy += diry * dist * ct - diry * len;

//			graphics.lineStyle(2,m_Color,0.5);
//			graphics.moveTo(fx,fy);
//			graphics.lineTo(tx,ty);

		} else {
			tx = fx + dirx * dist * ct;
			ty = fy + diry * dist * ct;
	
			len = 5.0;
			if (len > dist * ct) len = dist * ct;
	
			fx += dirx * dist * ct - dirx * len;
			fy += diry * dist * ct - diry * len;
	
//			graphics.lineStyle(2,m_Color,0.9);
//			graphics.moveTo(fx,fy);
//			graphics.lineTo(tx,ty);
		}

		if (!EmpireMap.Self.m_Frustum.IsIn(fx - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize, fy - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize, 0, 10.0)) {
			return true;
		}
		dirx = tx - fx; diry = ty - fy;
		dist = Math.sqrt(dirx * dirx + diry * diry);
		k = 1.0 / dist; dirx *= k; diry *= k;

		p = PAdd();
		p.m_Flag = C3DParticle.FlagShow;
		p.m_PosX = fx - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_CamSectorX * EmpireMap.Self.m_SectorSize;
		p.m_PosY = fy - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_CamSectorY * EmpireMap.Self.m_SectorSize;
		p.m_PosZ = 0.0 - EmpireMap.Self.m_CamPos.z;
		p.m_DirX = dirx;
		p.m_DirY = diry;
		p.m_DirZ = 0.0;
		p.m_NormalX = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 0];
		p.m_NormalY = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 1];
		p.m_NormalZ = EmpireMap.Self.m_MatViewInv.rawData[2 * 4 + 2];
		p.m_Width = 2.0 * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
		p.m_Height = dist * EmpireMap.Self.m_FactorScr2WorldDist * EmpireMap.Self.m_CamDist;
		p.m_U1 = 1135.0 / 2048.0;
		p.m_V1 = 1734.0 / 2048.0;
		p.m_U2 = (1135.0 + 12) / 2048.0;
		p.m_V2 = (1734.0 + 12) / 2048.0;
		p.m_Color = C3D.ClrReplaceAlpha(m_Color, (m_Type == TypeInvader)?0.5:0.9);
		p.m_ColorTo = p.m_Color;

		return true;
	}
	
	public static function PApply():void
	{
		if (m_First == null) return;
		m_First.ToQuadBatch(false, m_QuadBatch);
	}
	
	public static function PDraw():void
	{
		if (m_First == null) return;

//		if (m_Texture == null) m_Texture = C3D.GetTexture("white");
//		if (m_Texture.tex == null) return;
		if (GraphPlanet.TexSun() == null) return;

		C3D.SetVConstMatrix(0, EmpireMap.Self.m_MatViewPer);
		C3D.SetVConst_n(8, 0, 0, 0, 1.0);

		C3D.ShaderParticle(false);

		C3D.SetTexture(0, GraphPlanet.TexSun().tex);

		C3D.VBQuadBatch(m_QuadBatch);

		C3D.DrawQuadBatch();

		C3D.SetTexture(0, null);
	}
}

}

import Engine.*;

class GraphBulletParticle extends C3DParticle
{
}

