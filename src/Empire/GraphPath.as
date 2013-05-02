package Empire
{
import flash.display.*;
import flash.geom.*;
import flash.system.*;
import flash.text.*;
import flash.utils.*;

public class GraphPath extends Shape
{
	private var m_Map:EmpireMap;
	
	public var m_Type:int=0;

	public var m_SectorX:int;
	public var m_SectorY:int;
	public var m_PlanetNum:int;
	public var m_Vis:Boolean;
	
	public var m_TargetSectorX:int;
	public var m_TargetSectorY:int;
	public var m_TargetPlanetNum:int;
	public var m_TargetVis:Boolean;
	
	public var m_Tmp:int;

	public function GraphPath(map:EmpireMap)
	{
		m_Map=map;
	}
	
	public function Update():void
	{
		graphics.clear();
		
		if(m_Vis==false && m_TargetVis==false) return;

		var planet:Planet=m_Map.GetPlanet(m_SectorX,m_SectorY,m_PlanetNum);
		if(planet==null) return;

		var planet2:Planet=m_Map.GetPlanet(m_TargetSectorX,m_TargetSectorY,m_TargetPlanetNum);
		if(planet2==null) return;

		var fx:Number = m_Map.WorldToScreenX(planet.m_PosX, planet.m_PosY);
		var fy:Number = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(planet.m_PosY);
		var dx:Number = m_Map.WorldToScreenX(planet2.m_PosX, planet2.m_PosY);
		var dy:Number = EmpireMap.m_TWSPos.y;//m_Map.WorldToScreenY(planet2.m_PosY);

		dx-=fx; dy-=fy;
		var d:Number=Math.sqrt(dx*dx+dy*dy);
		dx/=d; dy/=d;

		var w:Number;
		var w2:Number;
		var h:Number;
		
		fx+=dx*40;
		fy+=dy*40;
		d-=80;
		
		if(m_Type==0) {
			w=7.0;
			w2=12.0;
			h=20.0;
		} else {
			w=3.0;
			w2=6.0;
			h=10.0;
		}
		
		var ps:Vector.<Number> = new Vector.<Number>(16, true);
		ps[00]=fx-dy*w;				ps[01]=fy+dx*w;
		ps[02]=fx+dx*(d-h)-dy*w;	ps[03]=fy+dy*(d-h)+dx*w;
		ps[04]=fx+dx*(d-h)-dy*w2;	ps[05]=fy+dy*(d-h)+dx*w2;
		ps[06]=fx+dx*(d);			ps[07]=fy+dy*(d);
		ps[08]=fx+dx*(d-h)+dy*w2;	ps[09]=fy+dy*(d-h)-dx*w2;
		ps[10]=fx+dx*(d-h)+dy*w;	ps[11]=fy+dy*(d-h)-dx*w;
		ps[12]=fx+dy*w;				ps[13]=fy-dx*w;
		ps[14]=fx-dy*w;				ps[15]=fy+dx*w;

		var cmds:Vector.<int> = new Vector.<int>(8, true);
		cmds[0]=GraphicsPathCommand.MOVE_TO;
		cmds[1]=GraphicsPathCommand.LINE_TO;
		cmds[2]=GraphicsPathCommand.LINE_TO;
		cmds[3]=GraphicsPathCommand.LINE_TO;
		cmds[4]=GraphicsPathCommand.LINE_TO;
		cmds[5]=GraphicsPathCommand.LINE_TO;
		cmds[6]=GraphicsPathCommand.LINE_TO;
		cmds[7]=GraphicsPathCommand.LINE_TO;

		var mat:Matrix=Common.MatrixForGradientLine(fx,fy,fx+dx*d,fy+dy*d);

		var clr:uint = 0;
		var aa:Number = 0.4;
		var a0:Number = 1.0;
		var a1:Number = 1.0;
		var a2:Number = 1.0;
		if(m_Vis==true && m_TargetVis==false) { a1=0.5; a2=0.0; }
		if(m_Vis==false && m_TargetVis==true) { a1=0.5; a0=0.0; }

		if (m_Type == 0) {
			clr = m_Map.m_BG.m_Cfg.ColorTrade & 0xffffff;
			aa = Number(Math.floor(m_Map.m_BG.m_Cfg.ColorTrade / 16777216)) / 255.0;
			graphics.lineStyle(3.0,0x000080,0.5,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
			graphics.lineGradientStyle(GradientType.LINEAR, [clr, clr, clr], [0.25 * aa * a0, aa * a1, aa * a2], [0, 150, 255], mat);//,SpreadMethod.PADD,InterpolationMethod.RGB);
		} else {
			clr = m_Map.m_BG.m_Cfg.ColorRoute & 0xffffff;
			aa = Number(Math.floor(m_Map.m_BG.m_Cfg.ColorRoute / 16777216)) / 255.0;
			graphics.lineStyle(3.0,0x800000,0.5,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
			graphics.lineGradientStyle(GradientType.LINEAR, [clr, clr, clr], [0.25 * aa * a0, aa * a1, aa * a2], [0, 150, 255], mat);//,SpreadMethod.PADD,InterpolationMethod.RGB);
		}
		//graphics.beginFill(0x000000,0.7);
		graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0x000000,0x000000],[0.3*a0,0.8*a1,0.8*a2],[0,150,255],mat);
		graphics.drawPath(cmds, ps);
		graphics.endFill();

		//graphics.moveTo(fx,fy);
		//graphics.lineTo(fx+dx*dist,fy+dy*dist);
	}
}

}
