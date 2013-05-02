// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
	
public class  PRnd
{
	public var m_Rnd:int;

	public function PRnd(rnd:int=0)
	{
		m_Rnd = rnd;
	}
	
	public function Set(rnd:int):void
	{
		m_Rnd = rnd;
	}
	
	public function Get():int
	{
		return m_Rnd;
	}
	
	public function RndEx():int
	{
		m_Rnd = 16807 * (m_Rnd % 127773) - 2836 * Math.floor(m_Rnd / 127773);
		if(m_Rnd<=0) m_Rnd=m_Rnd+2147483647;
		return m_Rnd-1;
	}
	
	public function RndFloatEx():Number
	{
		return Number(RndEx()) / (2147483647 - 2);
	}
	
	public function Rnd(vmin:int, vmax:int):int
	{
		if (vmin <= vmax) return vmin + (RndEx() % (vmax - vmin + 1));
		else return vmax + (RndEx() % (vmin - vmax + 1));
	}
	
	public function RndFloat(vmin:Number, vmax:Number):Number
	{	
		return vmin + RndFloatEx() * (vmax - vmin);
	}
}
	
}