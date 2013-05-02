package utils.eg {

public class HLSRGB
{
	public var r : Number = 0; // 0 - 255
	public var g : Number = 0; // 0 - 255
	public var b : Number = 0; // 0 - 255
	public var h : Number = 0; // 0.0 - 360.0
	public var l : Number = 0; // 0.0 - 1.0
	public var s : Number = 0; // 0.0 - 1.0

	public function HLSRGB ()
	{

	}

	public function getRGB():uint
	{
		return (uint(r) << 16) | (uint(g) << 8) | uint(b);
	}
	
	public function ToHLS ():void
	{
		var minval:Number = Math.min(r, Math.min(g, b));
		var maxval:Number = Math.max(r, Math.max(g, b));
		var mdiff:Number = maxval - minval;
		var msum:Number = maxval + minval;
		l = msum / 510;
		if(maxval == minval) {
			s = 0;
			h = 0;
		} else {
			var rnorm:Number = (maxval - r) / mdiff;
			var gnorm:Number = (maxval - g) / mdiff;
			var bnorm:Number = (maxval - b) / mdiff;
			s = (l <= .5) ? (mdiff / msum) : (mdiff / (510 - msum));
			if(r == maxval) {
				h = 60 * (6 + bnorm - gnorm);
			} else if (g == maxval) {
				h = 60 * (2 + rnorm - bnorm);
			} else if (b == maxval) {
				h = 60 * (4 + gnorm - rnorm);
			}
			h %= 360;
		}
	}

	public function ToRGB():void
	{
		if(s == 0){
			r = g = b = l * 255;
		} else {
			var rm1:Number;
			var rm2:Number;
			if(l <= 0.5) {
				rm2 = l + l * s;
			} else {
				rm2 = l + s - l * s;
			}
			rm1 = 2 * l - rm2;
			r = ToRGB1(rm1, rm2, h + 120);
			g = ToRGB1(rm1, rm2, h);
			b = ToRGB1(rm1, rm2, h - 120);
		}
	}

	private function ToRGB1(rm1:Number, rm2:Number, rh:Number):Number
	{
		if(rh > 360){
			rh -= 360;
		} else if (rh < 0) {
			rh += 360;
		}
		if(rh < 60) {
			rm1 = rm1 + (rm2 - rm1) * rh / 60;
		} else if (rh < 180) {
			rm1 = rm2;
		} else if (rh < 240) {
			rm1 = rm1 + (rm2 - rm1) * (240 - rh) / 60;
		}
		return(rm1 * 255);
	}

}

}