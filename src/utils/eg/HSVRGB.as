package utils.eg
{
	
public class  HSVRGB
{
	public var r : int = 0; // 0 - 255
	public var g : int = 0; // 0 - 255
	public var b : int = 0; // 0 - 255
	public var h : int = 0; // 0 - 360.0
	public var s : int = 0; // 0 - 255
	public var v : int = 0; // 0 - 255

	public function HSVRGB():void
	{
	}

	public function ToRGB():void
	{
		var _min:Number, _max:Number, delta:Number, hue:Number;

		if ((h == 0) && (s == 0)) {
			r = v; g = v; b = v;
		}

		_max = v;
		delta = (_max * s) / 255.0;
		_min = _max - delta;

		hue = h;
		if ((h > 300) || (h <= 60)) {
			r = int(_max);
			if (h > 300) {
				g = int(_min);
				hue = (hue - 360.0) / 60.0;
				b = int((hue * delta - _min) * -1);
			} else {
				b = int(_min);
				hue = hue / 60.0;
				g = int(hue * delta + _min);
			}
		} else if ((h > 60) && (h < 180)) {
			g = int(_max);
			if (h < 120) {
				b = int(_min);
				hue = (hue / 60.0 - 2.0 ) * delta;
				r = int(_min - hue);
			} else {
				r = int(_min);
				hue = (hue / 60 - 2.0) * delta;
				b = int(_min + hue);
			}
		} else {
			b = int(_max);
			if(h < 240) {
				r = int(_min);
				hue = (hue/60.0 - 4.0 ) * delta;
				g = int(_min - hue);
			} else {
				g = int(_min);
				hue = (hue/60 - 4.0) * delta;
				r = int(_min + hue);
			}
		}
	}

	public function ToHSV():void
	{
		var _min:Number = Math.min(r, g, b);
		var _max:Number = Math.max(r, g, b);
		var delta:Number = _max - _min;
		var temp:Number;

		v = int(_max);
		if (delta == 0) {
			h=0;
			s=0;
		} else {
			temp = delta / _max;
			s = int(temp * 255);

			if (r == int(_max)) {
				temp = (Number(g - b)) / delta;
			} else {
				if(g == int(_max)) {
					temp = 2.0 + (Number(b - r) / delta);
				} else {
					temp = 4.0 + (Number(r - g) / delta);
				}
			}
			temp = temp * 60;
			if (temp < 0) temp = temp + 360;
			if (temp == 360) temp = 0;
			h = int(temp);
		}
	}
}
	
}