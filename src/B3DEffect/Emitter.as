// Copyright (C) 2013 Elemental Games. All rights reserved.

package B3DEffect
{
import Base.*;
import Engine.*;
import flash.geom.Matrix3D;
	
public class Emitter
{
	public var m_EmitterStyle:EmitterStyle = null;
	public var m_ImgStyle:ImgStyle = null;
	
	public var m_AmountOst:Number = 0.0;
	
	public var m_Matrix:Matrix3D = new Matrix3D();
	
	public function Emitter():void
	{
	}
	
	public function Clear():void
	{
		m_EmitterStyle = null;
		m_ImgStyle = null;
	}
}
	
}