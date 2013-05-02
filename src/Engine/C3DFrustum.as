package Engine
{
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
	
public class C3DFrustum
{
	public var m_CenterX:Number, m_CenterY:Number, m_CenterZ:Number;
	public var m_LeftTopX:Number, m_LeftTopY:Number, m_LeftTopZ:Number;
	public var m_LeftBottomX:Number, m_LeftBottomY:Number, m_LeftBottomZ:Number;
	public var m_RightTopX:Number, m_RightTopY:Number, m_RightTopZ:Number;
	public var m_RightBottomX:Number, m_RightBottomY:Number, m_RightBottomZ:Number;
	public var m_LeftA:Number, m_LeftB:Number, m_LeftC:Number, m_LeftD:Number;
	public var m_RightA:Number, m_RightB:Number, m_RightC:Number, m_RightD:Number;
	public var m_TopA:Number, m_TopB:Number, m_TopC:Number, m_TopD:Number;
	public var m_BottomA:Number, m_BottomB:Number, m_BottomC:Number, m_BottomD:Number;
	public var m_BackA:Number, m_BackB:Number, m_BackC:Number, m_BackD:Number;

	public function C3DFrustum():void
	{
	}
	
	public function Clac(viewinv:Matrix3D, prj:Matrix3D):void
	{
		var k:Number,x:Number,y:Number,z:Number;

		var _11i:Number = 1.0 / prj.rawData[0 * 4 + 0];
		var _22i:Number = 1.0 / prj.rawData[1 * 4 + 1];

		var x1:Number = _11i * viewinv.rawData[0 * 4 + 0];
		var x2:Number = _11i * viewinv.rawData[0 * 4 + 1];
		var x3:Number = _11i * viewinv.rawData[0 * 4 + 2];

		var y1:Number = _22i * viewinv.rawData[1 * 4 + 0];
		var y2:Number = _22i * viewinv.rawData[1 * 4 + 1];
		var y3:Number = _22i * viewinv.rawData[1 * 4 + 2];

		x = viewinv.rawData[2 * 4 + 0];
		y = viewinv.rawData[2 * 4 + 1];
		z = viewinv.rawData[2 * 4 + 2];

		m_RightBottomX = -(x - x1 + y1);
		m_RightBottomY = -(y - x2 + y2);
		m_RightBottomZ = -(z - x3 + y3);
		k = 1.0 / Math.sqrt(m_RightBottomX * m_RightBottomX + m_RightBottomY * m_RightBottomY + m_RightBottomZ * m_RightBottomZ); m_RightBottomX *= k; m_RightBottomY *= k; m_RightBottomZ *= k;

		m_RightTopX = -(x - x1 - y1);
		m_RightTopY = -(y - x2 - y2);
		m_RightTopZ = -(z - x3 - y3);
		k = 1.0 / Math.sqrt(m_RightTopX * m_RightTopX + m_RightTopY * m_RightTopY + m_RightTopZ * m_RightTopZ); m_RightTopX *= k; m_RightTopY *= k; m_RightTopZ *= k;

		m_LeftBottomX = -(x1 + y1 + x);
		m_LeftBottomY = -(x2 + y2 + y);
		m_LeftBottomZ = -(x3 + y3 + z);
		k = 1.0 / Math.sqrt(m_LeftBottomX * m_LeftBottomX + m_LeftBottomY * m_LeftBottomY + m_LeftBottomZ * m_LeftBottomZ); m_LeftBottomX *= k; m_LeftBottomY *= k; m_LeftBottomZ *= k;

		m_LeftTopX = -(x1 - y1 + x);
		m_LeftTopY = -(x2 - y2 + y);
		m_LeftTopZ = -(x3 - y3 + z);
		k = 1.0 / Math.sqrt(m_LeftTopX * m_LeftTopX + m_LeftTopY * m_LeftTopY + m_LeftTopZ * m_LeftTopZ); m_LeftTopX *= k; m_LeftTopY *= k; m_LeftTopZ *= k;

		m_CenterX = viewinv.rawData[3 * 4 + 0];
		m_CenterY = viewinv.rawData[3 * 4 + 1];
		m_CenterZ = viewinv.rawData[3 * 4 + 2];

		m_BottomA = m_LeftBottomY * m_RightBottomZ - m_LeftBottomZ * m_RightBottomY;
        m_BottomB = m_LeftBottomZ * m_RightBottomX - m_LeftBottomX * m_RightBottomZ; 
        m_BottomC = m_LeftBottomX * m_RightBottomY - m_LeftBottomY * m_RightBottomX;
		k = 1.0 / Math.sqrt(m_BottomA * m_BottomA + m_BottomB * m_BottomB + m_BottomC * m_BottomC); m_BottomA *= k; m_BottomB *= k; m_BottomC *= k;
		m_BottomD = -(m_BottomA * m_CenterX + m_BottomB * m_CenterY + m_BottomC * m_CenterZ);

		m_TopA = m_LeftTopZ * m_RightTopY - m_LeftTopY * m_RightTopZ;
        m_TopB = m_LeftTopX * m_RightTopZ - m_LeftTopZ * m_RightTopX; 
        m_TopC = m_LeftTopY * m_RightTopX - m_LeftTopX * m_RightTopY;
		k = 1.0 / Math.sqrt(m_TopA * m_TopA + m_TopB * m_TopB + m_TopC * m_TopC); m_TopA *= k; m_TopB *= k; m_TopC *= k;
		m_TopD = -(m_TopA * m_CenterX + m_TopB * m_CenterY + m_TopC * m_CenterZ);

		m_LeftA = m_LeftBottomZ * m_LeftTopY - m_LeftBottomY * m_LeftTopZ;
        m_LeftB = m_LeftBottomX * m_LeftTopZ - m_LeftBottomZ * m_LeftTopX; 
        m_LeftC = m_LeftBottomY * m_LeftTopX - m_LeftBottomX * m_LeftTopY;
		k = 1.0 / Math.sqrt(m_LeftA * m_LeftA + m_LeftB * m_LeftB + m_LeftC * m_LeftC); m_LeftA *= k; m_LeftB *= k; m_LeftC *= k;
		m_LeftD = -(m_LeftA * m_CenterX + m_LeftB * m_CenterY + m_LeftC * m_CenterZ);

		m_RightA = m_RightTopZ * m_RightBottomY - m_RightTopY * m_RightBottomZ;
		m_RightB = m_RightTopX * m_RightBottomZ - m_RightTopZ * m_RightBottomX; 
		m_RightC = m_RightTopY * m_RightBottomX - m_RightTopX * m_RightBottomY;
		k = 1.0 / Math.sqrt(m_RightA * m_RightA + m_RightB * m_RightB + m_RightC * m_RightC); m_RightA *= k; m_RightB *= k; m_RightC *= k;
		m_RightD = -(m_RightA * m_CenterX + m_RightB * m_CenterY + m_RightC * m_CenterZ);

		//var v:Vector3D = viewinv.deltaTransformVector(new Vector3D(0.0, 0.0, 1.0));
		m_BackA = viewinv.rawData[2 * 4 + 0];
		m_BackB = viewinv.rawData[2 * 4 + 1];
		m_BackC = viewinv.rawData[2 * 4 + 2];
		k = 1.0 / Math.sqrt(m_BackA * m_BackA + m_BackB * m_BackB + m_BackC * m_BackC); m_BackA *= k; m_BackB *= k; m_BackC *= k;
		m_BackD = -(m_BackA * m_CenterX + m_BackB * m_CenterY + m_BackC * m_CenterZ);
	}

	public function IsIn(x:Number, y:Number, z:Number, r:Number):Boolean
	{
		if ((m_LeftA * (x - m_LeftA * r) + m_LeftB * (y - m_LeftB * r) + m_LeftC * (z - m_LeftC * r) + m_LeftD) > 0.0) return false;
		if ((m_RightA * (x - m_RightA * r) + m_RightB * (y - m_RightB * r) + m_RightC * (z - m_RightC * r) + m_RightD) > 0.0) return false;
		if ((m_TopA * (x - m_TopA * r) + m_TopB * (y - m_TopB * r) + m_TopC * (z - m_TopC * r) + m_TopD) > 0.0) return false;
		if ((m_BottomA * (x - m_BottomA * r) + m_BottomB * (y - m_BottomB * r) + m_BottomC * (z - m_BottomC * r) + m_BottomD) > 0.0) return false;

		r += 1.0 + 0.01;
		if ((m_BackA * (x - m_BackA * r) + m_BackB * (y - m_BackB * r) + m_BackC * (z - m_BackC * r) + m_BackD) > 0.0) return false;

		return true;
	}
}
	
}