package Engine
{
	import flash.utils.ByteArray;

public class C3DParticle
{
	static public const FlagShow:uint = 1;
	//static public const FlagLine:uint = 2;
	static public const FlagContinue:uint = 4;
	//static public const FlagCenterPoint:uint = 8;
	static public const FlagColorAdd:uint = 16;

	public var m_Prev:C3DParticle = null;
	public var m_Next:C3DParticle = null;

	public var m_DirX:Number = 0; // Y - вектор ориентации
	public var m_DirY:Number = 0;
	public var m_DirZ:Number = 0;

	public var m_NormalX:Number = 0; // Нормаль к плоскости
	public var m_NormalY:Number = 0;
	public var m_NormalZ:Number = 0;

	public var m_Width:Number = 0; // ширина. в доль X - ориентации
	public var m_Height:Number = 0; // высота. в доль Y - ориентации 

	public var m_U1:Number = 0;
	public var m_V1:Number = 0;
	public var m_U2:Number = 0;
	public var m_V2:Number = 0;

	public var m_PosX:Number = 0; // Pos - Начало частицы. Pos+Dir*Height - конец частицы.
	public var m_PosY:Number = 0;
	public var m_PosZ:Number = 0;
	
	public var m_CenterX:Number = 0.5;
	public var m_CenterY:Number = 0.0;
	public var m_Spin:Number = 0.0;
	
	public var m_ScaleX:Number = 1.0;
	public var m_ScaleY:Number = 1.0;

	public var m_Color:uint = 0;
	public var m_ColorTo:uint = 0;
	
	public var m_ColorMask:uint = 0;
	public var m_AlphaMask:uint = 0;

//	public var m_Z:Number = 0;

	public var m_Flag:uint = 0;

//	public var m_PosToX:Number = 0;
//	public var m_PosToY:Number = 0;
//	public var m_PosToZ:Number = 0;
	
/*
 float4x4 	mViewProj;
float4 		vOffset;

struct VS_INPUT_STRUCT // 64 byte
{
    float3 pos	    			: POSITION;
	float3 posto				: TEXCOORD1;
	float3 nor					: NORMAL;
	float2 tc    				: TEXCOORD;
    float4 clr      			: COLOR;
	float3 basev				: TEXCOORD2;
	float width					: TEXCOORD3;
};
VS_OUTPUT VSMain( VS_INPUT_STRUCT inp)
{
	VS_OUTPUT outp;

	float3 vx=inp.posto-inp.pos;
	float3 vy=float4(normalize(cross(vx,-inp.nor))*inp.width,0.0);

	float4 v;
	v.x=inp.basev.x*vx.x+inp.basev.y*vy.x+inp.pos.x+vOffset.x;
	v.y=inp.basev.x*vx.y+inp.basev.y*vy.y+inp.pos.y+vOffset.y;
	v.z=inp.basev.x*vx.z+inp.basev.y*vy.z+inp.pos.z+vOffset.z;
	v.w=1.0;
	outp.pos=mul(v,mViewProj);

	outp.tc=inp.tc;
	outp.clr=inp.clr;
	return outp;
}*/
	public function C3DParticle():void
	{
	}

	public function ClearData():void
	{
		m_DirX = 0;
		m_DirY = 0;
		m_DirZ = 0;

		m_NormalX = 0;
		m_NormalY = 0;
		m_NormalZ = 0;

		m_Width = 0;
		m_Height = 0;

		m_U1 = 0;
		m_V1 = 0;
		m_U2 = 0;
		m_V2 = 0;

		m_PosX = 0;
		m_PosY = 0;
		m_PosZ = 0;

		m_Color = 0;
		m_ColorTo = 0;
		
		m_Flag = 0;
	}

	public function ClearList():void
	{
		var p:C3DParticle, pnext:C3DParticle;
		pnext = m_Prev;
		while (pnext != null) {
			p = pnext;
			pnext = pnext.m_Prev;
			p.m_Prev = null;
			p.m_Next = null;
		}
		pnext = m_Next;
		while (pnext != null) {
			p = pnext;
			pnext = pnext.m_Next;
			p.m_Prev = null;
			p.m_Next = null;
		}
		m_Prev = null;
		m_Next = null;
	}
	
	public function ToQuadBatch(back:Boolean, qb:C3DQuadBatch, mask:Boolean=false, alignshift:int = 0):void
	{
		var px:Number, py:Number, pz:Number;
		var _px:Number, _py:Number, _pz:Number;
		var ncnt:int;

		var cnt:int = 0;
		var p:C3DParticle = this;
		while (p != null) {
			if ((p.m_Flag & FlagShow) != 0) cnt++;
			if(back) p = p.m_Prev;
			else p = p.m_Next;
		}

		// posX,posY,posZ,basevX
		// norX,norY,norZ,basevY
		// tcU,tcV,mulalpha
		// clr
		// postoX,postoY,postoZ,width
		
		var da:Boolean = true;

		if(da) {
			if (qb.m_Stride != ((mask)?(27):(19))) {
				ncnt = ((cnt >> alignshift) << alignshift);
				if ((ncnt & ((1 << alignshift) - 1)) != 0) ncnt += 1 << alignshift;

				qb.Init(ncnt, 4, 4, 3, 4, 4, ((mask)?(4):(0)), ((mask)?(4):(0)));
			}
		} else {
			if (qb.m_Stride != ((mask)?(18):(16))) {
				ncnt = ((cnt >> alignshift) << alignshift);
				if ((ncnt & ((1 << alignshift) - 1)) != 0) ncnt += 1 << alignshift;

				qb.InitRaw(ncnt, 4, 4, 3, -1, 4, ((mask)?( -1):(0)), ((mask)?( -1):(0)));
			}
		}

		if (cnt > qb.m_Cnt) {
			ncnt = ((cnt >> alignshift) << alignshift);
			if ((ncnt & ((1 << alignshift) - 1)) != 0) ncnt += 1 << alignshift;
			qb.ChangeCnt(ncnt);
		}

		var d:Vector.<Number> = null;
		var w:ByteArray = null;
		if (da) {
			d = qb.m_Data;
			if (d == null) return;
		}
		else {
			w = qb.m_Raw;
			w.position = 0;
			if (w == null) return;
		}

		cnt = 0;

		var bx:Number, by:Number;
		var b1x:Number, b1y:Number;
		var b2x:Number, b2y:Number;
		var b3x:Number, b3y:Number;
		var b4x:Number, b4y:Number;
		var cs:Number, ss:Number;
		
		var clrmask0:Number, clrmask1:Number, clrmask2:Number, clrmask3:Number;
		var alphamask0:Number, alphamask1:Number, alphamask2:Number, alphamask3:Number;
		var clrmask:uint;
		var alphamask:uint;

		var off:int = 0;
		var pp:C3DParticle, _p:C3DParticle;
		var pnext:C3DParticle = this;
		while (pnext != null) {
			p = pnext;
			if(back) pnext = pnext.m_Prev;
			else pnext = pnext.m_Next;

			if ((p.m_Flag & FlagShow) == 0) continue;
			
			pp = null;
			if ((p.m_Flag & FlagContinue) != 0 && p.m_Spin == 0) pp = p.m_Prev;
			
			if (pp != null) {
				_px = pp.m_PosX + pp.m_DirX * pp.m_Height;
				_py = pp.m_PosY + pp.m_DirY * pp.m_Height;
				_pz = pp.m_PosZ + pp.m_DirZ * pp.m_Height;
			}

			px = p.m_PosX + p.m_DirX * p.m_Height;
			py = p.m_PosY + p.m_DirY * p.m_Height;
			pz = p.m_PosZ + p.m_DirZ * p.m_Height;

			//_p = (pp != null)?pp:p;
			if (pp != null) {
				b1x = (pp.m_CenterX + 0.5)*pp.m_ScaleX;
				b1y = (pp.m_CenterY + 0.5)*pp.m_ScaleY;
				b2x = (pp.m_CenterX + 0.5)*pp.m_ScaleX;
				b2y = (pp.m_CenterY - 0.5)*pp.m_ScaleY;
			} else {
				b1x = (p.m_CenterX - 0.5)*p.m_ScaleX;// 0.0;// 0.0;
				b1y = (p.m_CenterY + 0.5)*p.m_ScaleY;//0.5;// -0.5;
				b2x = (p.m_CenterX - 0.5)*p.m_ScaleX;// 0.0;// 1.0;
				b2y = (p.m_CenterY - 0.5)*p.m_ScaleY;//-0.5;// -0.5;
			}
			b3x = (p.m_CenterX + 0.5)*p.m_ScaleX;//1.0;// 1.0;
			b3y = (p.m_CenterY - 0.5)*p.m_ScaleY;//-0.5;// 0.5;
			b4x = (p.m_CenterX + 0.5)*p.m_ScaleX;// 1.0;// 0.0;
			b4y = (p.m_CenterY + 0.5)*p.m_ScaleY;//0.5;// 0.5;
			if (p.m_Spin != 0) {
				cs = Math.cos(p.m_Spin);
				ss = Math.sin(p.m_Spin);

				bx = b1x * cs + b1y * ss;
				by = -b1x * ss + b1y * cs;
				b1x = bx; b1y = by; 

				bx = b2x * cs + b2y * ss;
				by = -b2x * ss + b2y * cs;
				b2x = bx; b2y = by; 

				bx = b3x * cs + b3y * ss;
				by = -b3x * ss + b3y * cs;
				b3x = bx; b3y = by; 

				bx = b4x * cs + b4y * ss;
				by = -b4x * ss + b4y * cs;
				b4x = bx; b4y = by; 
			}

			// 1
			_p = (pp != null)?pp:p;
			if (da) {
				d[off++] = _p.m_PosX;
				d[off++] = _p.m_PosY;
				d[off++] = _p.m_PosZ;
				d[off++] = b1x;
				d[off++] = -_p.m_NormalX;
				d[off++] = -_p.m_NormalY;
				d[off++] = -_p.m_NormalZ;
				d[off++] = b1y;
				d[off++] = p.m_U1;
				d[off++] = p.m_V1;
				d[off++] = ((p.m_Flag & FlagColorAdd) != 0)?(0.0):(1.0);
				d[off++] = C3D.ClrToFloat * Number((p.m_Color >> 16) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_Color >> 8) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_Color >> 0) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_Color >> 24) & 0xff);
				if (pp != null) { d[off++] = _px; d[off++] = _py; d[off++] = _pz; }
				else { d[off++] = px; d[off++] = py; d[off++] = pz; }
				d[off++] = _p.m_Width;
				if (mask) {
					clrmask0 = C3D.ClrToFloat * Number((p.m_ColorMask >> 16) & 0xff);
					clrmask1 = C3D.ClrToFloat * Number((p.m_ColorMask >> 8) & 0xff);
					clrmask2 = C3D.ClrToFloat * Number((p.m_ColorMask >> 0) & 0xff);
					clrmask3 = C3D.ClrToFloat * Number((p.m_ColorMask >> 24) & 0xff);
					alphamask0 = C3D.ClrToFloat * Number((p.m_AlphaMask >> 16) & 0xff);
					alphamask1 = C3D.ClrToFloat * Number((p.m_AlphaMask >> 8) & 0xff);
					alphamask2 = C3D.ClrToFloat * Number((p.m_AlphaMask >> 0) & 0xff);
					alphamask3 = C3D.ClrToFloat * Number((p.m_AlphaMask >> 24) & 0xff);
					
					d[off++] = clrmask0;
					d[off++] = clrmask1;
					d[off++] = clrmask2;
					d[off++] = clrmask3;
					d[off++] = alphamask0;
					d[off++] = alphamask1;
					d[off++] = alphamask2;
					d[off++] = alphamask3;
				}
			} else {
				w.writeFloat(_p.m_PosX);
				w.writeFloat(_p.m_PosY);
				w.writeFloat(_p.m_PosZ);
				w.writeFloat(b1x);
				w.writeFloat(-_p.m_NormalX);
				w.writeFloat(-_p.m_NormalY);
				w.writeFloat(-_p.m_NormalZ);
				w.writeFloat(b1y);
				w.writeFloat(p.m_U1);
				w.writeFloat(p.m_V1);
				w.writeFloat(((p.m_Flag & FlagColorAdd) != 0)?(0.0):(1.0));
				//d.writeUnsignedInt(p.m_Color);
				w.writeUnsignedInt((p.m_Color & 0xff00ff00) | ((p.m_Color & 0x00ff0000) >> 16) | ((p.m_Color & 0x000000ff) << 16));
				if (pp != null) { w.writeFloat(_px); w.writeFloat(_py); w.writeFloat(_pz); }
				else { w.writeFloat(px); w.writeFloat(py); w.writeFloat(pz); }
				w.writeFloat(_p.m_Width);
				if (mask) {
					clrmask = (p.m_ColorMask & 0xff00ff00) | ((p.m_ColorMask & 0x00ff0000) >> 16) | ((p.m_ColorMask & 0x000000ff) << 16);
					alphamask = (p.m_AlphaMask & 0xff00ff00) | ((p.m_ColorMask & 0x00ff0000) >> 16) | ((p.m_ColorMask & 0x000000ff) << 16);
					w.writeUnsignedInt(clrmask);
					w.writeUnsignedInt(alphamask);
				}
			}

			// 2
			_p = (pp != null)?pp:p;
			if(da) {
				d[off++] = _p.m_PosX;
				d[off++] = _p.m_PosY;
				d[off++] = _p.m_PosZ;
				d[off++] = b2x;
				d[off++] = -_p.m_NormalX;
				d[off++] = -_p.m_NormalY;
				d[off++] = -_p.m_NormalZ;
				d[off++] = b2y;
				d[off++] = p.m_U2;
				d[off++] = p.m_V1;
				d[off++] = ((p.m_Flag & FlagColorAdd) != 0)?(0.0):(1.0);
				d[off++] = C3D.ClrToFloat * Number((p.m_Color >> 16) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_Color >> 8) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_Color >> 0) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_Color >> 24) & 0xff);
				if (pp != null) { d[off++] = _px; d[off++] = _py; d[off++] = _pz; }
				else { d[off++] = px; d[off++] = py; d[off++] = pz; }
				d[off++] = _p.m_Width;
				if (mask) {
					d[off++] = clrmask0;
					d[off++] = clrmask1;
					d[off++] = clrmask2;
					d[off++] = clrmask3;
					d[off++] = alphamask0;
					d[off++] = alphamask1;
					d[off++] = alphamask2;
					d[off++] = alphamask3;
				}
			} else {
				w.writeFloat(_p.m_PosX);
				w.writeFloat(_p.m_PosY);
				w.writeFloat(_p.m_PosZ);
				w.writeFloat(b2x);
				w.writeFloat(-_p.m_NormalX);
				w.writeFloat(-_p.m_NormalY);
				w.writeFloat(-_p.m_NormalZ);
				w.writeFloat(b2y);
				w.writeFloat(p.m_U2);
				w.writeFloat(p.m_V1);
				w.writeFloat(((p.m_Flag & FlagColorAdd) != 0)?(0.0):(1.0));
				//d.writeUnsignedInt(p.m_Color);
				w.writeUnsignedInt((p.m_Color & 0xff00ff00) | ((p.m_Color & 0x00ff0000) >> 16) | ((p.m_Color & 0x000000ff) << 16));
				if (pp != null) { w.writeFloat(_px); w.writeFloat(_py); w.writeFloat(_pz); }
				else { w.writeFloat(px); w.writeFloat(py); w.writeFloat(pz); }
				w.writeFloat(_p.m_Width);
				if (mask) {
					w.writeUnsignedInt(clrmask);
					w.writeUnsignedInt(alphamask);
				}
			}

			// 3
			_p = p;
			if(da) {
				d[off++] = _p.m_PosX;
				d[off++] = _p.m_PosY;
				d[off++] = _p.m_PosZ;
				d[off++] = b3x;
				d[off++] = -_p.m_NormalX;
				d[off++] = -_p.m_NormalY;
				d[off++] = -_p.m_NormalZ;
				d[off++] = b3y;
				d[off++] = p.m_U2;
				d[off++] = p.m_V2;
				d[off++] = ((p.m_Flag & FlagColorAdd) != 0)?(0.0):(1.0);
				d[off++] = C3D.ClrToFloat * Number((p.m_ColorTo >> 16) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_ColorTo >> 8) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_ColorTo >> 0) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_ColorTo >> 24) & 0xff);
				d[off++] = px;
				d[off++] = py;
				d[off++] = pz;
				d[off++] = _p.m_Width;
				if (mask) {
					d[off++] = clrmask0;
					d[off++] = clrmask1;
					d[off++] = clrmask2;
					d[off++] = clrmask3;
					d[off++] = alphamask0;
					d[off++] = alphamask1;
					d[off++] = alphamask2;
					d[off++] = alphamask3;
				}
			} else {
				w.writeFloat(_p.m_PosX);
				w.writeFloat(_p.m_PosY);
				w.writeFloat(_p.m_PosZ);
				w.writeFloat(b3x);
				w.writeFloat(-_p.m_NormalX);
				w.writeFloat(-_p.m_NormalY);
				w.writeFloat(-_p.m_NormalZ);
				w.writeFloat(b3y);
				w.writeFloat(p.m_U2);
				w.writeFloat(p.m_V2);
				w.writeFloat(((p.m_Flag & FlagColorAdd) != 0)?(0.0):(1.0));
				//d.writeUnsignedInt(p.m_Color);
				w.writeUnsignedInt((p.m_ColorTo & 0xff00ff00) | ((p.m_ColorTo & 0x00ff0000) >> 16) | ((p.m_ColorTo & 0x000000ff) << 16));
				w.writeFloat(px);
				w.writeFloat(py);
				w.writeFloat(pz);
				w.writeFloat(_p.m_Width);
				if (mask) {
					w.writeUnsignedInt(clrmask);
					w.writeUnsignedInt(alphamask);
				}
			}

			// 4
			_p = p;
			if(da) {
				d[off++] = _p.m_PosX;
				d[off++] = _p.m_PosY;
				d[off++] = _p.m_PosZ;
				d[off++] = b4x;
				d[off++] = -_p.m_NormalX;
				d[off++] = -_p.m_NormalY;
				d[off++] = -_p.m_NormalZ;
				d[off++] = b4y;
				d[off++] = p.m_U1;
				d[off++] = p.m_V2;
				d[off++] = ((p.m_Flag & FlagColorAdd) != 0)?(0.0):(1.0);
				d[off++] = C3D.ClrToFloat * Number((p.m_ColorTo >> 16) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_ColorTo >> 8) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_ColorTo >> 0) & 0xff);
				d[off++] = C3D.ClrToFloat * Number((p.m_ColorTo >> 24) & 0xff);
				d[off++] = px;
				d[off++] = py;
				d[off++] = pz;
				d[off++] = _p.m_Width;
				if (mask) {
					d[off++] = clrmask0;
					d[off++] = clrmask1;
					d[off++] = clrmask2;
					d[off++] = clrmask3;
					d[off++] = alphamask0;
					d[off++] = alphamask1;
					d[off++] = alphamask2;
					d[off++] = alphamask3;
				}
			} else {
				w.writeFloat(_p.m_PosX);
				w.writeFloat(_p.m_PosY);
				w.writeFloat(_p.m_PosZ);
				w.writeFloat(b4x);
				w.writeFloat(-_p.m_NormalX);
				w.writeFloat(-_p.m_NormalY);
				w.writeFloat(-_p.m_NormalZ);
				w.writeFloat(b4y);
				w.writeFloat(p.m_U1);
				w.writeFloat(p.m_V2);
				w.writeFloat(((p.m_Flag & FlagColorAdd) != 0)?(0.0):(1.0));
				//d.writeUnsignedInt(p.m_Color);
				w.writeUnsignedInt((p.m_ColorTo & 0xff00ff00) | ((p.m_ColorTo & 0x00ff0000) >> 16) | ((p.m_ColorTo & 0x000000ff) << 16));
				w.writeFloat(px);
				w.writeFloat(py);
				w.writeFloat(pz);
				w.writeFloat(_p.m_Width);
				if (mask) {
					w.writeUnsignedInt(clrmask);
					w.writeUnsignedInt(alphamask);
				}
			}

			cnt += 4;
		}

		if (da) {
			cnt = d.length - off;
			while (cnt>0) {
				d[off++] = 0;
				cnt--;
			}
		} else {
			cnt = w.length - w.position;
			while (cnt > 4) {
				w.writeUnsignedInt(0);
				cnt -= 4;
			}
		}

		qb.Apply();
	}
}

}