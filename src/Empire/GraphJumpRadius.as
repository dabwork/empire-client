// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

public class GraphJumpRadius extends Shape
{
	private var m_Map:EmpireMap;

	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;

	public function GraphJumpRadius(map:EmpireMap)
	{
		m_Map=map;
		m_PlanetNum=-1;
	}

	public function Update():void
	{
		graphics.clear();

		if(m_PlanetNum<0) return;

		var pl:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if(pl==null) return;

		var cx:Number = m_Map.WorldToScreenX(pl.m_PosX, pl.m_PosY);
		var cy:Number = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(pl.m_PosY);
		
		graphics.beginFill(0x000000,0.5);
		
		graphics.drawRect(-100,-100,m_Map.stage.stageWidth+200,m_Map.stage.stageHeight+200);

		graphics.lineStyle(1.5,0xffffff,1.0);
		graphics.drawCircle(cx,cy,m_Map.m_OpsJumpRadius);

		graphics.endFill();
	}
}

}
