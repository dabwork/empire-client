// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

public class GalaxyRoute
{
	var m_P1x:Number;
	var m_P1y:Number;
	var m_P2x:Number;
	var m_P2y:Number;
	var m_P3x:Number;
	var m_P3y:Number;
	var m_P4x:Number;
	var m_P4y:Number;
	
	var m_Len:Number;
	
	public function BX(t:Number):Number
	{
		var emt=1.0-t;
		return emt*emt*emt*m_P1x+3*t*emt*emt*m_P2x+3*t*t*emt*m_P3x+t*t*t*m_P4x;
	} 

	public function BY(t:Number):Number
	{
		var emt=1.0-t;
		return emt*emt*emt*m_P1y+3*t*emt*emt*m_P2y+3*t*t*emt*m_P3y+t*t*t*m_P4y;
	}
	
	public function CalcLen()
	{
		m_Len=0;
		var t:Number=0;
		var px:Number=BX(t);
		var py:Number=BY(t);
		var nx:Number;
		var ny:Number;
		var setp:Number=0.01;
		t+=setp;
		while(t<1.0) {
			nx=BX(t);
			ny=BY(t);
			m_Len+=Math.sqrt((px-nx)*(px-nx)+(py-ny)*(py-ny));
			px=nx;
			py=ny;
			t+=setp;
		}
		nx=BX(1.0);
		ny=BY(1.0);
		m_Len+=Math.sqrt((px-nx)*(px-nx)+(py-ny)*(py-ny));
	} 
}

}