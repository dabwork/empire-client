package Empire
{
import Base.*;
import Engine.*;
import B3DEffect.Effect;
import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;
import flash.system.*;

public class GraphExplosion
{
	private var m_Map:EmpireMap;
	
	public var m_PosX:Number;
	public var m_PosY:Number;

	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_PlaceNum:int;
	public var m_Id:uint;
	public var m_DestroyTime:Number;

	public var m_CenterX:Number;
	public var m_CenterY:Number;

	public var m_Time:Number;
	
	public var m_Explosion:Effect = null;

	public function GraphExplosion(map:EmpireMap, big:Boolean)
	{
		m_Map=map;
		
		m_Explosion = new Effect();
		if(big) m_Explosion.Run("expl0");
		else m_Explosion.Run("expl_fs");
	}
	
	public function Clear():void
	{
		if (m_Explosion != null) {
			m_Explosion.Clear();
			m_Explosion = null;
		}
	}

	public function Update():void
	{
		var planet:Planet = m_Map.GetPlanet(m_SectorX, m_SectorY, m_PlanetNum);
		if (planet == null) return;
		if (m_PlaceNum == 100) {
			m_PosX = planet.m_PosX;
			m_PosY = planet.m_PosY;
		} else {
			m_Map.CalcShipPlaceEx(planet, m_PlaceNum, EmpireMap.m_TPos);
			m_PosX = EmpireMap.m_TPos.x;
			m_PosY = EmpireMap.m_TPos.y;
		}
	}
	
	public function DrawPrepare(dt:Number):void
	{
		if (m_Explosion != null) {
			var offx:Number = m_PosX - EmpireMap.Self.m_CamPos.x - EmpireMap.Self.m_SectorSize * EmpireMap.Self.m_CamSectorX;
			var offy:Number = m_PosY - EmpireMap.Self.m_CamPos.y - EmpireMap.Self.m_SectorSize * EmpireMap.Self.m_CamSectorY;
			var offz:Number = 0 - (EmpireMap.Self.m_CamPos.z);

			m_Explosion.SetPos(offx, offy, offz);
			m_Explosion.GraphTakt(dt);
		}
	}	

	public function Draw():void
	{
		if (m_Explosion != null) {
			m_Explosion.Draw(EmpireMap.Self.m_CurTime, EmpireMap.Self.m_MatViewPer, EmpireMap.Self.m_MatView, EmpireMap.Self.m_MatViewInv, EmpireMap.Self.m_FactorScr2WorldDist);
		}
	}
	
}

}