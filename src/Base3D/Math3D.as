package Base3D
{
import flash.geom.Vector3D;
	
public class  Math3D
{
	static public const pi:Number = 3.14159265358979;
	static public const ToRad:Number = pi / 180.0;
	static public const ToGrad:Number = 180.0 / pi;

	[Inline]
	public static function PlaneIntersectLine(a:Number, b:Number, c:Number, d:Number, px:Number, py:Number, pz:Number, nx:Number, ny:Number, nz:Number):Number
	{
		var ki:Number = a * nx + b * ny + c * nz;
		if (ki == 0.0) return NaN;
		return -((a) * (px) + (b) * (py) + (c) * (pz) + (d)) / ki;
	}

	[Inline] public static function PlaneFromPointNormal(posx:Number, posy:Number, posz:Number, normalx:Number, normaly:Number, normalz:Number, out:Vector3D):void
	{
		out.x = normalx;
		out.y = normaly;
		out.z = normalz;
		out.w = 0;
		var d:Number = out.x * out.x + out.y * out.y + out.z * out.z;
		if (d > 0.0) {
			d = 1.0 / Math.sqrt(d);
			out.x *= d; out.y *= d; out.z *= d;
		}
		out.w = -(out.x * posx + out.y * posy + out.z * posz);
	}

	public static function IntersectTriangle(origx:Number, origy:Number, origz:Number,
					dirx:Number, diry:Number, dirz:Number, 
					v0x:Number, v0y:Number, v0z:Number,
					v1x:Number, v1y:Number, v1z:Number,
					v2x:Number, v2y:Number, v2z:Number,
					out:Vector3D):Boolean
	{
		var edge1x:Number, edge1y:Number, edge1z:Number;
		var edge2x:Number, edge2y:Number, edge2z:Number;
		var pvecx:Number, pvecy:Number, pvecz:Number;
		var tvecx:Number, tvecy:Number, tvecz:Number;
		var qvecx:Number, qvecy:Number, qvecz:Number;
		var det:Number;

		edge1x = v1x - v0x; edge1y = v1y - v0y; edge1z = v1z - v0z;
		edge2x = v2x - v0x; edge2y = v2y - v0y; edge2z = v2z - v0z;

		pvecx = diry * edge2z - dirz * edge2y;
		pvecy = dirz * edge2x - dirx * edge2z; 
		pvecz = dirx * edge2y - diry * edge2x;

		det = edge1x * pvecx + edge1y * pvecy + edge1z * pvecz;
		if (det < 0.0001) return false;

		tvecx = origx - v0x; tvecy = origy - v0y; tvecz = origz - v0z;

		var uu:Number = tvecx * pvecx + tvecy * pvecy + tvecz * pvecz;
		if ((uu<0.0) || (uu > det)) return false;

		qvecx = tvecy * edge1z - tvecz * edge1y;
		qvecy = tvecz * edge1x - tvecx * edge1z; 
		qvecz = tvecx * edge1y - tvecy * edge1x;

		var vv:Number = dirx * qvecx + diry * qvecy + dirz * qvecz;
		if ((vv<0.0) || ((uu + vv)>det)) return false;

		var tt:Number = edge2x * qvecx + edge2y * qvecy + edge2z * qvecz;
		var fInvDet:Number = 1.0 / det;

		out.x = tt * fInvDet;
		out.y = uu * fInvDet;
		out.z = vv * fInvDet;

		return true;
	}

	public static function IntersectAABBTri(posx:Number, posy:Number, posz:Number, 
		sizex:Number, sizey:Number, sizez:Number, 
		pnt1x:Number, pnt1y:Number, pnt1z:Number,
		pnt2x:Number, pnt2y:Number, pnt2z:Number,
		pnt3x:Number, pnt3y:Number, pnt3z:Number):Boolean
	{
		var Ex:Number = sizex * 0.5;
		var Ey:Number = sizey * 0.5;
		var Ez:Number = sizez * 0.5;
		
		var Px:Number = posx + Ex;
		var Py:Number = posy + Ey;
		var Pz:Number = posz + Ez;
		
		var nx:Number, ny:Number, nz:Number;			// проверяемая ось

		var p:Number; // расстояние от pnt1 до центра OBB вдоль оси
		var d0:Number, d1:Number;	// + к p для pnt2, pnt3
		var R:Number; // "радиус" OBB вдоль оси
		
		// расстояние от pnt1 до центра OBB
		var Dx:Number = pnt1x - Px;
		var Dy:Number = pnt1y - Py;
		var Dz:Number = pnt1z - Pz;
		
		// стороны треугольника
		var E0x:Number = pnt2x - pnt1x;
		var E0y:Number = pnt2y - pnt1y;
		var E0z:Number = pnt2z - pnt1z;
		var E1x:Number = pnt3x - pnt1x;
		var E1y:Number = pnt3y - pnt1y;
		var E1z:Number = pnt3z - pnt1z;
		var E2x:Number = E1x - E0x;
		var E2y:Number = E1y - E0y;
		var E2z:Number = E1z - E0z;
		
		// нормаль треугольника
		nx = E0y * E1z - E0z * E1y;
		ny = E0z * E1x - E0x * E1z;
		nz = E0x * E1y - E0y * E1x;

		// проверяем нормаль треугольника
		if (Math.abs(nx * Dx + ny * Dy + nz * Dz) > (Ex * Math.abs(nx/* | M0*/) + Ey * Math.abs(ny/* | M1*/) + Ez * Math.abs(nz/* | M2*/)) ) return false;
		
		// проверяем оси OBB
		p = /*M0 | */Dx;
		d0 =/*M0 | */E0x;
		d1 =/*M0 | */E1x;
		R = Ex;
		if ((Math.min(p, Math.min(p + d0, p + d1)) > R) || (Math.max(p, Math.max(p + d0, p + d1)) < -R)) return false;

		p = /*M1 |*/ Dy;
		d0 =/*M1 |*/ E0y;
		d1 =/*M1 |*/ E1y;
		R = Ey;
		if ((Math.min(p, Math.min(p + d0, p + d1)) > R) || (Math.max(p, Math.max(p + d0, p + d1)) < -R)) return false;

		p = /*M2 |*/ Dz;
		d0 =/*M2 |*/ E0z;
		d1 =/*M2 |*/ E1z;
		R = Ez;
		if ((Math.min(p, Math.min(p + d0, p + d1)) > R) || (Math.max(p, Math.max(p + d0, p + d1)) < -R)) return false;
		
		// проверяем M0 ^ E0
		//n = CVector3(0.0f,-E0.z,E0.y);//M0 ^ E0;
		p = -E0z * Dy   +E0y * Dz;//n | D;
		d0 = -E0z * E1y  +E0y * E1z;//n | E1;

		R = Ey * Math.abs(/*M2 | */E0z) + Ez * Math.abs(/*M1 | */E0y);

		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;
		
		// проверяем M0 ^ E1
		//n = CVector3(0.0f,-E1.z,E1.y);//M0 ^ E1;
		p = -E1z * Dy   +E1y * Dz;//n | D;
		d0 = -E1z * E0y  +E1y * E0z;//n | E0;
		R = Ey * Math.abs(/*M2 | */E1z) + Ez * Math.abs(/*M1 | */E1y);
		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;

		// проверяем M0 ^ E2
		//n = CVector3(0.0f,-E2.z,E2.y);//M0 ^ E2;
		p = -E2z * Dy   +E2y * Dz;//n | D;
		d0 = -E2z * E0y  +E2y * E0z;//n | E0;
		R = Ey * Math.abs(/*M2 | */E2z) + Ez * Math.abs(/*M1 | */E2y);
		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;

		// проверяем M1 ^ E0
		//n = CVector3(E0.z,0.0f,-E0.x);//M1 ^ E0;
		p = E0z * Dx    -E0x * Dz;//n | D;
		d0 = E0z * E1x   -E0x * E1z;// n | E1;
		R = Ex * Math.abs(/*M2 | */E0z) + Ez * Math.abs(/*M0 | */E0x);
		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;
		
		// проверяем M1 ^ E1
		//n = CVector3(E1.z,0.0f,-E1.x);//M1 ^ E1;
		p = E1z * Dx    -E1x * Dz;//n | D;
		d0 = E1z * E0x   -E1x * E0z;//n | E0;
		R = Ex * Math.abs(/*M2 | */E1z) + Ez * Math.abs(/*M0 | */E1x);
		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;

		// проверяем M1 ^ E2
		//n = CVector3(E2.z,0.0f,-E2.x);//M1 ^ E2;
		p = E2z * Dx    -E2x * Dz;//n | D;
		d0 = E2z * E0x   -E2x * E0z;//n | E0;
		R = Ex * Math.abs(/*M2 | */E2z) + Ez * Math.abs(/*M0 | */E2x);
		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;
		
		// проверяем M2 ^ E0
		//n = CVector3(-E0.y,E0.x,0.0f);//M2 ^ E0;
		p = -E0y * Dx   +E0x * Dy;//n | D;
		d0 = -E0y * E1x  +E0x * E1y;//n | E1;
		R = Ex * Math.abs(/*M1 | */E0y) + Ey * Math.abs(/*M0 | */E0x);
		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;

		// проверяем M2 ^ E1
		//n = CVector3(-E1.y,E1.x,0.0f);//M2 ^ E1;
		p = -E1y * Dx   +E1x * Dy;//n | D;
		d0 = -E1y * E0x  +E1x * E0y;//n | E0;
		R = Ex * Math.abs(/*M1 | */E1y) + Ey * Math.abs(/*M0 | */E1x);
		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;

		// проверяем M2 ^ E2
		//n = CVector3(-E2.y,E2.x,0.0f);//M2 ^ E2;
		p = -E2y * Dx   +E2x * Dy;//n | D;
		d0 = -E2y * E0x   +E2x * E0y;//n | E0;
		R = Ex * Math.abs(/*M1 | */E2y) + Ey * Math.abs(/*M0 | */E2x);
		if ((Math.min(p, p + d0) > R) || (Math.max(p, p + d0) < -R)) return false;

		return true;
	}
	
}
	
}