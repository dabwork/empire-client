// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.events.Event;
import flash.utils.*;

public class C3DQuadBatch
{
	public var m_Pos:int = 0;
	public var m_Normal:int = 0;
	public var m_UV:int = 0;
	public var m_Clr:int = 0;
	public var m_Dir:int = 0;
	public var m_A:int = 0;
	public var m_B:int = 0;
	
	public var m_Cnt:int = 0;
	
	public var m_Stride:int = 0;

	public var m_Raw:ByteArray = null;
	public var m_Data:Vector.<Number> = null;// new Vector.<Number>();
	
	public var m_DrawCnt:int = 0;
	public var m_VB:VertexBuffer3D = null;
	public var m_IB:IndexBuffer3D = null;
	
	public static var m_VBAlloc:int = 0;
	public static var m_IBAlloc:int = 0;
	
	public var m_EventOk:Boolean = false;

	public function C3DQuadBatch():void
	{
	}
	
	public function free():void
	{
		GraphClear();
	}
	
	public function GraphClear():void
	{
		//m_Data.length = 0;
		m_Data = null;
		m_Raw = null;

		if (m_VB != null) { m_VBAlloc--; m_VB.dispose(); m_VB = null; }
		if (m_IB != null) { m_IBAlloc--; m_IB.dispose(); m_IB = null; }
		m_DrawCnt = 0;

		if (m_EventOk) {
			m_EventOk = false;
			C3D.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}

	public function InitRaw(cnt:int, pos:int = 3, normal:int = 0, uv:int = 0, clr:int = 0, dir:int = 0, a:int = 0, b:int = 0):void
	{
		if (cnt * 4 >= 65536) throw Error("C3DQuadBatch.InitRaw");

		if (m_Data != null) {
			m_Data = null;
		}
		if (m_Raw == null) {
			m_Raw = new ByteArray();
			m_Raw.endian = Endian.LITTLE_ENDIAN;
		}

		m_Pos = pos; m_Stride = pos;
		m_Normal = normal; m_Stride += normal;
		m_UV = uv; m_Stride += uv;
		m_Clr = clr; m_Stride += (clr == -1)?(1):(clr);
		m_Dir = dir; m_Stride += dir;
		m_A = a; m_Stride += (a == -1)?(1):(a);
		m_B = b; m_Stride += (b == -1)?(1):(b);

		m_Cnt = cnt;
		m_Raw.length = cnt * 4 * m_Stride * 4;
	}

	public function Init(cnt:int, pos:int = 3, normal:int = 0, uv:int = 0, clr:int = 0, dir:int = 0, a:int = 0, b:int = 0):void
	{
		if (cnt * 4 >= 65536) throw Error("C3DQuadBatch.Init");

		if (m_Raw != null) {
			m_Raw = null;
		}
		if (m_Data == null) {
			m_Data = new Vector.<Number>();
		}

		m_Pos = pos; m_Stride = pos;
		m_Normal = normal; m_Stride += normal;
		m_UV = uv; m_Stride += uv;
		m_Clr = clr; m_Stride += clr;
		m_Dir = dir; m_Stride += dir;
		m_A = a; m_Stride += a;
		m_B = b; m_Stride += b;

		m_Cnt = cnt;
		m_Data.length = cnt * 4 * m_Stride;
	}
	
	public function ChangeCnt(cnt:int):void
	{
		if (m_Cnt == cnt) return;

		m_Cnt = cnt;
		if (m_Raw != null) {
			m_Raw.length = cnt * 4 * m_Stride * 4;

		} else if(m_Data!=null) {
			m_Data.length = cnt * 4 * m_Stride;
		}
	}

	public function SetPos(no:int, x:Number, y:Number, z:Number, w:Number = 0):void
	{
		var sme:int = no * m_Stride;
		if(m_Pos>=1) m_Data[sme + 0] = x;
		if(m_Pos>=2) m_Data[sme + 1] = y;
		if(m_Pos>=3) m_Data[sme + 2] = z;
		if(m_Pos>=4) m_Data[sme + 3] = w;
	}

	public function SetNormal(no:int, x:Number, y:Number, z:Number, w:Number = 0):void
	{
		var sme:int = no * m_Stride + m_Pos;
		if (m_Normal >= 1) m_Data[sme + 0] = x;
		if (m_Normal >= 2) m_Data[sme + 1] = y;
		if (m_Normal >= 3) m_Data[sme + 2] = z;
		if (m_Normal >= 4) m_Data[sme + 3] = w;
	}
	
	public function SetUV(no:int, x:Number, y:Number, z:Number = 0, w:Number = 0):void
	{
		var sme:int = no * m_Stride + m_Pos + m_Normal;
		if (m_UV >= 1) m_Data[sme + 0] = x;
		if (m_UV >= 2) m_Data[sme + 1] = y;
		if (m_UV >= 3) m_Data[sme + 2] = z;
		if (m_UV >= 4) m_Data[sme + 3] = w;
	}

	public function SetClr(no:int, clr:uint):void
	{
		var sme:int = no * m_Stride + m_Pos + m_Normal + m_UV;
		if (m_Clr >= 0) m_Data[sme] = clr;
	}

	public function SetDir(no:int, x:Number, y:Number, z:Number, w:Number = 0):void
	{
		var sme:int = no * m_Stride + m_Pos + m_Normal + m_UV + m_Clr;
		if (m_Dir >= 1) m_Data[sme + 0] = x;
		if (m_Dir >= 2) m_Data[sme + 1] = y;
		if (m_Dir >= 3) m_Data[sme + 2] = z;
		if (m_Dir >= 4) m_Data[sme + 3] = w;
	}

	public function Apply(off:int=0, cnt:int=-1):void
	{
		if (off >= m_Cnt) off = m_Cnt - 1;
		if (off < 0) off = 0;

		if (cnt < 0) cnt = m_Cnt - off;
		if (cnt <= 0) {
			m_DrawCnt = 0;
			if (m_IB != null) { m_IBAlloc--; m_IB.dispose(); m_IB = null; }
			if (m_VB != null) { m_VBAlloc--; m_VB.dispose(); m_VB = null; }
			if (m_EventOk) {
				m_EventOk = false;
				C3D.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
			}
			return;
		}

		if (cnt == 1) {
			if (m_IB != null) { m_IBAlloc--; m_IB.dispose(); m_IB = null; }

		} else if (m_IB == null || cnt != m_DrawCnt) {
			if (m_IB != null) { m_IBAlloc--; m_IB.dispose(); m_IB = null; }

			var i:int, u:int, k:int;
			var il:Vector.<uint> = new Vector.<uint>(cnt * 6);
			for (i = 0, u = 0, k = 0; i < cnt; i++, k += 4) {
				il[u++] = k + 0; il[u++] = k + 1; il[u++] = k + 2;
				il[u++] = k + 0; il[u++] = k + 2; il[u++] = k + 3;
			}

			m_IB = C3D.Context.createIndexBuffer(cnt * 6);
			m_IBAlloc++;
			m_IB.uploadFromVector(il, 0, cnt * 6);
		}

		if (m_VB == null || m_DrawCnt != cnt) {
			if (m_VB != null) { m_VBAlloc--; m_VB.dispose(); m_VB = null; }
			m_DrawCnt = cnt;
			m_VB = C3D.Context.createVertexBuffer(4 * m_DrawCnt, m_Stride);
			m_VBAlloc++;
		}
		if (m_Raw != null) m_VB.uploadFromByteArray(m_Raw, 0, off, 4 * m_DrawCnt);
		else if(m_Data!=null) m_VB.uploadFromVector(m_Data, off, 4 * m_DrawCnt);
		
		if (!m_EventOk) {
			m_EventOk = true;
			C3D.stage3D.addEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}
	
	public function Context3DCreate(e:Event):void
	{
		if (m_VB != null) { m_VBAlloc--; m_VB.dispose(); m_VB = null; }
		if (m_IB != null) { m_IBAlloc--; m_IB.dispose(); m_IB = null; }
		m_IB = null;
		m_VB = null;
		if (m_DrawCnt > 0) Apply(0, m_DrawCnt);
	}
}
	
}