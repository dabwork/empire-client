package Base
{
	
public class BaseMath
{
	static public const pi:Number = 3.14159265358979;
	static public const ToRad:Number = pi / 180.0;
	static public const ToGrad:Number = 180.0 / pi;
	
	public static function AngleNorm(a:Number):Number
	{
	    while (a > BaseMath.pi) a -= 2.0 * BaseMath.pi;//Math.PI;
    	while (a <= -BaseMath.pi) a += 2.0 * BaseMath.pi;//Math.PI;
    	return a;
	}

	public static function AngleDist(afrom:Number,ato:Number):Number
	{
		while (afrom < 0.0) afrom += 2.0 * BaseMath.pi;//; Math.PI;
		while (ato < 0.0) ato += 2.0 * BaseMath.pi;//Math.PI;
	
	    var r:Number=ato-afrom;
	
		if(afrom < BaseMath.pi) {
	        if (r > BaseMath.pi) r -= 2.0 * BaseMath.pi;//Math.PI;
		} else {
	        if (r < -BaseMath.pi) r += 2.0 * BaseMath.pi;//Math.PI;
		}

		return r;
	}

	public static function C2Rn(x:Number,sou_start:Number,sou_end:Number,des_start:Number,des_end:Number):Number
	{
		return des_start + Math.min(1.0, Math.max(0.0, (x - sou_start) / (sou_end - sou_start))) * (des_end - des_start);
	}
	
	public static function Interpolate_n(arr:Vector.<Number>, t:Number):Number
	{
		var cnt:int = arr.length;
		if (cnt <= 0) return 0.0;
		
		if(cnt==1) return arr[0];

		if (t < 0.0) t = 0.0;
		else if (t > 1.0) t = 1.0;

		t = t * (cnt - 1);
		var n:int = Math.floor(t);
		if (n > (cnt - 2)) return arr[cnt - 1];

		t = Math.min(1.0, t - n);

		return arr[n] + (arr[n + 1] - arr[n]) * t;
	}

	public static function InterpolateKeys_n(arr:Vector.<Number>, keys:Vector.<Number>, t:Number):Number
	{
		var cnt:int = keys.length;
		if (cnt <= 0) return 0.0;
		if (cnt != arr.length) return 0.0;
		if (cnt == 1) return arr[0];

		var icur:int = 0;
		var istart:int = 0;
		var iend:int = cnt - 1;
		while(true) {
			icur=istart+((iend-istart) >> 1);
			if (t == keys[icur]) return arr[icur];
			else if (t < keys[icur]) iend = icur - 1;
			else istart = icur + 1;
			if (iend < istart) {
				if (t >= keys[icur]) icur++;
				break;
			}
		}
		if(icur==0) return arr[0];
		else if(icur>=cnt) return arr[cnt-1];

		t = (t - keys[icur - 1]) / (keys[icur] - keys[icur - 1]);

		return arr[icur - 1] + (arr[icur] - arr[icur - 1]) * t;
	}
	
	// s=missile_speed p=target_pos v=target_speed
	// aim_point=p+v*return
	public static function CalcAimWithVelocity(s:Number, pX:Number, pY:Number, pZ:Number, vX:Number, vY:Number, vZ:Number):Number
	{
		// x1=(-b-sqrt(b2-4ac))/(2a)	x2=(-b+sqrt(b2-4ac))/(2a)
		// x1=2c/(-b-sqrt(b2-4ac))		x2=2c/(-b+sqrt(b2-4ac))

		var a:Number = -s * s + vX * vX + vY * vY + vZ * vZ;
		//if(fabs(a)<0.00001) return 0.0f;
		var b:Number = 2.0 * (vX * pX + vY * pY + vZ * pZ);
		var c:Number = pX * pX + pY * pY + pZ * pZ;

		var k:Number = b * b - 4.0 * a * c;
		if(k<0.0) return 0.0;

		//k=(-b-sqrt(k))/(2.0*a);

		k=Math.sqrt(k);
		var x1:Number=-b+k;
		var x2:Number=-b-k;

		if(c<0.0) {
			c=-c;
			x1=-x1;
			x2=-x2;
		}

		k=Math.max(x1,x2);
		
		if(k<0.0000001) return 0.0;

		k = 2.0 * c / k;

		return k;
	}

	public static function CalcHitDist(xA:Number, yA:Number, uA:Number, xB:Number, yB:Number, uB:Number, xD:Number, yD:Number):Number
	{
		// A-положение корабля
		// B-положение цели
		// D-еденичное направление движения цели
		// uA-скорость корабля
		// uB-скорость цели

		var cc:Number = Math.sqrt((xA - xB) * (xA - xB) + (yA - yB) * (yA - yB)); // Дистанция между кораблем и целью
		if (cc <= 0.000001) return 0.0;
		var cosbb:Number = ((xA - xB) / cc) * xD + ((yA - yB) / cc) * yD; // Косинус при цели

		// -(bb^2) + (aa^2) + (cc^2) - (2*aa*cc*cosbb)=0  - Теорема косинусов
		// x - время
		// aa=uB*x - пройденый путь целью
		// bb=uA*x - пройденый путь кораблем
		// -(uA^2*x^2) + (uB^2*x^2) + (cc^2) - (2*uB*x*cc*cosbb)=0;
		// x^2*(-uA^2+uB^2) + x*(-2*uB*cc*cosbb) + cc^2 = 0  - Квадратное уровнение

		var a:Number = -uA * uA + uB * uB;
		var b:Number = -2.0 * uB * cc * cosbb;
		var c:Number = cc * cc;

		// x12=(-b(+-)sqrt(b^2-4*a*c))/(2*a)  - Решение квадратного уровнения

		var d:Number = b * b - 4.0 * a * c;
		if (d < 0) return 0.0; // Нет решения. А следовательно корабль не успеет за целью.
		d = Math.sqrt(d);

		var x1:Number=-b+d;
		var x2:Number=-b-d;

		if(c<0.0) {
			c=-c;
			x1=-x1;
			x2=-x2;
		}

		d=Math.max(x1,x2);
	
		if(d<0.0000001) return 0.0;

		d=2.0*c/d;

		return d;

/*		var x:Number = ( -b + d) / (2.0 * a);

		if(d!=0.0) {
			var x2:Number = ( -b + d) / (2.0 * a);
trace("d:", x, "d2:", x2);
			if ((x < 0) && (x2 < 0)) return 0.0; // Если в прошлом.
			if ((x < 0) || (x2 < x)) x = x2;
		} else {
trace("d:", x);
		}

		if (x < 0) return 0.0; // Если в прошлом.

		return x;*/
	}
}
	
}