// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{

import flash.display3D.*;
import flash.events.Event;
import flash.geom.*;
import flash.utils.ByteArray;

public class C3DMesh
{
	public var m_Raw:ByteArray = null;
	
	public var m_Flag:uint = 0;
	//		0x       1 ( 0) - Index 32
	//		0x    ff00 ( 8) - Vertex size
	//		0x   70000 (16) - Position		0-off 1-3*4 2-4*4
	//		0x  380000 (19) - Normal		0-off 1-3*4 2-4*4 3-4*1
	//		0x 1c00000 (22) - Tex coord		0-off 1-2*4 2-2*2
	//		0x e000000 (25) - Tangent		0-off 1-3*4 2-4*4 3-4*1
	//		0x10000000 (28) - Binormal		0-off 1-on format from Tangent
	//		0x60000000 (29) - Bone			0-off 1-4*1*2 2-8*1*2
	
	public var m_RawVer:int = 0;
	public var m_VertexSme:int = 0;
	public var m_VertexCnt:int = 0;
	public var m_IndexSme:int = 0;
	public var m_IndexCnt:int = 0;
	public var m_MatrixSme:int = 0;
	public var m_MatrixCnt:int = 0;
	public var m_FrameSme:int = 0;
	public var m_FrameCnt:int = 0;
	public var m_ConnectSme:int = 0;
	public var m_ConnectCnt:int = 0;
	
	public var m_MinX:Number = 0;
	public var m_MinY:Number = 0;
	public var m_MinZ:Number = 0;
	public var m_MaxX:Number = 0;
	public var m_MaxY:Number = 0;
	public var m_MaxZ:Number = 0;
	public var m_Radius:Number = 0;
	
	public var m_EdgeSme:int = 0;
	public var m_EdgeCnt:int = 0;
	public var m_EdgeNearSme:int = 0;
	public var m_EdgeNearCnt:int = 0;
	
	public var m_Frame:Vector.<C3DMeshFrame> = new Vector.<C3DMeshFrame>();
	public var m_Matrix:Vector.<Matrix3D> = new Vector.<Matrix3D>();

	public var m_VB:VertexBuffer3D = null;
	public var m_IB:IndexBuffer3D = null;
	
	private var m_ShadowMeshFrom:C3DMesh = null;

	public var m_EventOk:Boolean = false;

	public function C3DMesh()
	{
	}
	
	public function Clear():void
	{
		GraphClear();
		m_Raw = null;
		m_Flag = 0;
		m_VertexSme = 0;
		m_VertexCnt = 0;
		m_IndexSme = 0;
		m_IndexCnt = 0;
		m_MatrixSme = 0;
		m_MatrixCnt = 0;
		m_FrameSme = 0;
		m_FrameCnt = 0;

		m_MinX = 0;
		m_MinY = 0;
		m_MinZ = 0;
		m_MaxX = 0;
		m_MaxY = 0;
		m_MaxZ = 0;
		m_Radius = 0;
	
		m_EdgeSme = 0;
		m_EdgeCnt = 0;
		m_EdgeNearSme = 0;
		m_EdgeNearCnt = 0;
		
		m_Frame.length = 0;
		m_Matrix.length = 0;
		
		m_ShadowMeshFrom = null;
	}
	
	public function IsInit():Boolean
	{
		return m_Raw != null;
	}
	
	public function IsInitGraph():Boolean
	{
		return m_VB != null;
	}

	public function Init(raw:ByteArray):void
	{
		var i:int, u:int;

		m_Raw = raw;

		m_Raw.position = 0;
		var ver:uint = m_Raw.readUnsignedInt();
		if (ver != 0x6873656d) throw Error("C3DMesh.Format");
		m_RawVer = m_Raw.readUnsignedInt();
		if (m_RawVer < 2) throw Error("C3DMesh.Ver");
		m_Flag = m_Raw.readUnsignedInt();

//		m_Flag &= ~0x380000;
//		m_Flag &= ~0x1c00000;

		m_VertexSme = m_Raw.readUnsignedInt();
		m_VertexCnt = m_Raw.readUnsignedInt();

		m_IndexSme = m_Raw.readUnsignedInt();
		m_IndexCnt = m_Raw.readUnsignedInt();

		m_MatrixSme = m_Raw.readUnsignedInt();
		m_MatrixCnt = m_Raw.readUnsignedInt();

		m_FrameSme = m_Raw.readUnsignedInt();
		m_FrameCnt = m_Raw.readUnsignedInt();

		m_ConnectSme = m_Raw.readUnsignedInt();
		m_ConnectCnt = m_Raw.readUnsignedInt();

		m_MinX = m_Raw.readFloat();
		m_MinY = m_Raw.readFloat();
		m_MinZ = m_Raw.readFloat();
		m_MaxX = m_Raw.readFloat();
		m_MaxY = m_Raw.readFloat();
		m_MaxZ = m_Raw.readFloat();
		m_Radius = m_Raw.readFloat();

		m_EdgeSme = m_Raw.readUnsignedInt();
		m_EdgeCnt = m_Raw.readUnsignedInt();

		m_EdgeNearSme = m_Raw.readUnsignedInt();
		m_EdgeNearCnt = m_Raw.readUnsignedInt();

		m_Raw.position = m_FrameSme;
		m_Frame.length = m_FrameCnt;
		for (i = 0; i < m_FrameCnt; i++) {
			var fr:C3DMeshFrame = new C3DMeshFrame();
			m_Frame[i] = fr;
			fr.m_VertexStart=m_Raw.readUnsignedInt();
			fr.m_VertexCnt=m_Raw.readUnsignedInt();
			fr.m_IndexStart=m_Raw.readUnsignedInt();
			fr.m_TriCnt=m_Raw.readUnsignedInt();
			fr.m_MatrixNo=m_Raw.readInt();
			fr.m_MinX=m_Raw.readFloat();
			fr.m_MinY=m_Raw.readFloat();
			fr.m_MinZ=m_Raw.readFloat();
			fr.m_MaxX=m_Raw.readFloat();
			fr.m_MaxY=m_Raw.readFloat();
			fr.m_MaxZ=m_Raw.readFloat();
			fr.m_Radius=m_Raw.readFloat();
			fr.m_EdgeStart=m_Raw.readUnsignedInt();
			fr.m_EdgeCnt=m_Raw.readUnsignedInt();
			fr.m_EdgeNearStart=m_Raw.readUnsignedInt();
			fr.m_EdgeNearCnt=m_Raw.readUnsignedInt();
		}

		if (m_MatrixCnt > 0) {
			var mv:Vector.<Number> = new Vector.<Number>(16, true);
			m_Raw.position = m_MatrixSme;
			m_Matrix.length = m_MatrixCnt;
			for (i = 0; i < m_MatrixCnt; i++) {
				for (u = 0; u < 16; u++) mv[u] = m_Raw.readFloat();
				m_Matrix[i] = new Matrix3D(mv);
			}
		}
	}
	
	public function Connect(connectno:int, frame:int):int
	{
		if (frame<0 || frame>=m_Frame.length) return -1;
		if (connectno<0 || connectno>=m_ConnectCnt) return -1;
		m_Raw.position = m_ConnectSme +(((m_FrameCnt + 1) * connectno) << 2) + ((frame + 1) << 2);
		return m_Raw.readInt();
	}
	
	public function ConnectId(connectno:int):uint
	{
		if (connectno<0 || connectno>=m_ConnectCnt) return 0;
		m_Raw.position = m_ConnectSme +(((m_FrameCnt + 1) * connectno) << 2);
		return m_Raw.readInt();
	}

	public function ConnectById(id:uint):int
	{
		var i:int;

		for (i = 0; i < m_ConnectCnt; i++) {
			m_Raw.position = m_ConnectSme +(((m_FrameCnt + 1) * i) << 2);
			if (m_Raw.readUnsignedInt() == id) return i;
		}

		return -1;
	}

	public function RawVersion():int
	{
		return m_RawVer;
	}

	public function RawPositionType():int
	{
		return (m_Flag & 0x70000) >> 16;
	}

	public function RawVertexStride():int
	{
		return (m_Flag >> 8) & 255;
	}

	public function RawIndex32():Boolean
	{
		return (m_Flag & 1) != 0;
	}

	public function GraphClear():void
	{
		if (m_VB != null) {
			m_VB.dispose();
			m_VB = null;
		}
		if (m_IB != null) {
			m_IB.dispose();
			m_IB = null;
		}
		if (m_EventOk) {
			m_EventOk = false;
			C3D.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}

	public function Context3DCreate(e:Event):void
	{
		if (m_VB != null) {
			if (m_ShadowMeshFrom!=null) GraphBuildShadowMesh(m_ShadowMeshFrom);
			else GraphPrepare();
		}
	}

	public function GraphPrepare():void
	{
		var i:int, s:int;

		GraphClear();

		var dpv:int = 0;
		var ss:uint = (m_Flag >> 8) & 255;
		
		var pt:uint = (m_Flag & 0x70000) >> 16;
		if (pt == 1) dpv += 3;
		else if (pt == 2) dpv += 4;
		else throw Error("C3DMesh.Flag.Position");

		var nt:uint = (m_Flag & 0x380000) >> 19;
		if (nt == 0) { }
		else if (nt == 1) dpv += 3;
		else if (nt == 2) dpv += 4;
		//else if (nt == 3) dpv += 1;
		else throw Error("C3DMesh.Flag.Normal");
		
		var tt:uint = (m_Flag & 0x1c00000) >> 22;
		if (tt == 0) { }
		else if (tt == 1) dpv += 2;
//		else if (tt == 2) dpv += 2;
		else throw Error("C3DMesh.Flag.Tex");

		if (m_VertexCnt <= 0 || dpv <= 0) return;
		if (m_Raw == null || m_Raw.length <= 0) return;

		var vd:Vector.<Number> = new Vector.<Number>(dpv * m_VertexCnt);

		s = 0;
		for (i = 0; i < m_VertexCnt;i++) {
			m_Raw.position = m_VertexSme + ss * i;

			vd[s++] = m_Raw.readFloat();
			vd[s++] = m_Raw.readFloat();
			vd[s++] = m_Raw.readFloat();
			if (pt == 2) vd[s++] = m_Raw.readFloat();

//m_Raw.readFloat();
//m_Raw.readFloat();
//m_Raw.readFloat();
			if (nt == 1) {
				vd[s++] = m_Raw.readFloat();
				vd[s++] = m_Raw.readFloat();
				vd[s++] = m_Raw.readFloat();
				
//var nl:Number = Math.sqrt(vd[s - 3] * vd[s - 3] + vd[s - 2] * vd[s - 2] + vd[s - 1] * vd[s - 1]);
//if((nl < 0.9) || (nl>1.1)) trace(nl);
			} else if (nt == 2) {
				vd[s++] = m_Raw.readFloat();
				vd[s++] = m_Raw.readFloat();
				vd[s++] = m_Raw.readFloat();
				vd[s++] = m_Raw.readFloat();
			}

			if (tt == 1) {
				vd[s++] = m_Raw.readFloat();
				vd[s++] = m_Raw.readFloat();
			}
		}

		m_VB = C3D.Context.createVertexBuffer(m_VertexCnt, dpv);
		m_VB.uploadFromVector(vd, 0, m_VertexCnt);

		m_IB = C3D.Context.createIndexBuffer(m_IndexCnt);
		if (m_Flag & 1) throw Error("C3DMesh.Flag.Index32");
//		m_Raw.position = m_IndexSme;
		m_IB.uploadFromByteArray(m_Raw, m_IndexSme, 0, m_IndexCnt);
		
		if (!m_EventOk) {
			m_EventOk = true;
			C3D.stage3D.addEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}
	
	static public const incSide:Array = [1, 2, 0];

	public function GraphBuildShadowMesh(mesh:C3DMesh):void
	{
		var i:int, u:int, k:int;
		var i0:uint, i1:uint, i2:uint;
		var tri0:uint, tri1:uint, side0:uint, side1:uint;
		var x0:Number, y0:Number, z0:Number;
		var x1:Number, y1:Number, z1:Number;
		var x2:Number, y2:Number, z2:Number;
		var xn:Number, yn:Number, zn:Number;
		var xa:Number, ya:Number, za:Number;
		var xb:Number, yb:Number, zb:Number;
		var d:Number;
		
		Clear();
		
		m_ShadowMeshFrom = mesh;

		if(mesh.RawVersion()<3) throw Error("BuildShadowMesh.Ver");
		var pt:int = mesh.RawPositionType();
		var vs:int = mesh.RawVertexStride();
		
		var edgestide:int = 4 * 2;
		if (mesh.m_EdgeNearCnt > 0) edgestide += 4 * 4;

		if (pt != 1 && pt != 2) throw Error("BuildShadowMesh.Pos");
		if (mesh.RawIndex32()) throw Error("BuildShadowMesh.Index32");

		m_VertexCnt = mesh.m_IndexCnt;
		if (m_VertexCnt > 65535) throw Error("BuildShadowMesh.VerCnt");

		m_IndexCnt = mesh.m_IndexCnt + mesh.m_EdgeCnt * 3 * 2;

		var vd:Vector.<Number> = new Vector.<Number>(6 * m_VertexCnt);
		var vadd:int = 0;

		var id:Vector.<uint> = new Vector.<uint>(m_IndexCnt);
		var iadd:int = 0;

		m_Frame.length = mesh.m_FrameCnt;
		for (i = 0; i < mesh.m_FrameCnt; i++) {
			var fr:C3DMeshFrame = new C3DMeshFrame();
			m_Frame[i] = fr;

			var fromfr:C3DMeshFrame = mesh.m_Frame[i];
			
			for (u = 0; u < i; u++) {
				var fromfr2:C3DMeshFrame = mesh.m_Frame[u];
				if (fromfr2.m_IndexStart == fromfr.m_IndexStart && fromfr2.m_TriCnt == fromfr.m_TriCnt && fromfr2.m_VertexStart == fromfr.m_VertexStart && fromfr2.m_VertexCnt == fromfr.m_VertexCnt) {
					fromfr = m_Frame[u];
					fr.m_VertexStart = fromfr.m_VertexStart;
					fr.m_VertexCnt = fromfr.m_VertexCnt;
					fr.m_IndexStart = fromfr.m_IndexStart;
					fr.m_TriCnt = fromfr.m_TriCnt;
					break;
				}
			}
			if (u < i) continue;

			fr.m_VertexStart = vadd;
			fr.m_VertexCnt = 0;
			fr.m_IndexStart = iadd;
			fr.m_TriCnt = 0;

			k = vadd * 6;
			for (u = 0; u < fromfr.m_TriCnt; u++) {
				mesh.m_Raw.position = mesh.m_IndexSme + fromfr.m_IndexStart * 2 + u * 3 * 2;
				i0 = mesh.m_Raw.readUnsignedShort();
				i1 = mesh.m_Raw.readUnsignedShort();
				i2 = mesh.m_Raw.readUnsignedShort();
//trace("Tri" + u.toString() + "/" + fromfr.m_TriCnt, i0, i1, i2);

				mesh.m_Raw.position = mesh.m_VertexSme + (fromfr.m_VertexStart + i0) * vs;
				x0 = mesh.m_Raw.readFloat();
				y0 = mesh.m_Raw.readFloat();
				z0 = mesh.m_Raw.readFloat();

				mesh.m_Raw.position = mesh.m_VertexSme + (fromfr.m_VertexStart + i1) * vs;
				x1 = mesh.m_Raw.readFloat();
				y1 = mesh.m_Raw.readFloat();
				z1 = mesh.m_Raw.readFloat();

				mesh.m_Raw.position = mesh.m_VertexSme + (fromfr.m_VertexStart + i2) * vs;
				x2 = mesh.m_Raw.readFloat();
				y2 = mesh.m_Raw.readFloat();
				z2 = mesh.m_Raw.readFloat();

				xa = x1 - x0;
				ya = y1 - y0;
				za = z1 - z0;

				xb = x2 - x0;
				yb = y2 - y0;
				zb = z2 - z0;

				xn = ya * zb - za * yb;
				yn = za * xb - xa * zb;
				zn = xa * yb - ya * xb;

				d = xn * xn + yn * yn + zn * zn;
				if (d > 0.0) {
					d = 1.0 / Math.sqrt(d);
					xn *= d;
					yn *= d;
					zn *= d;
				}

				vd[k++] = x0; vd[k++] = y0; vd[k++] = z0; vd[k++] = xn; vd[k++] = yn; vd[k++] = zn;
				vd[k++] = x1; vd[k++] = y1; vd[k++] = z1; vd[k++] = xn; vd[k++] = yn; vd[k++] = zn;
				vd[k++] = x2; vd[k++] = y2; vd[k++] = z2; vd[k++] = xn; vd[k++] = yn; vd[k++] = zn;

				vadd += 3;
				fr.m_VertexCnt += 3;

				id[iadd++] = u * 3 + 0;
				id[iadd++] = u * 3 + 1;
				id[iadd++] = u * 3 + 2;

				fr.m_TriCnt++;
			}

			mesh.m_Raw.position = mesh.m_EdgeSme + fromfr.m_EdgeStart * edgestide;
			for (u = 0; u < fromfr.m_EdgeCnt; u++) {
				tri0 = mesh.m_Raw.readUnsignedShort();
				tri1 = mesh.m_Raw.readUnsignedShort();
				side0 = mesh.m_Raw.readUnsignedByte();
				side1 = mesh.m_Raw.readUnsignedByte();
				mesh.m_Raw.readUnsignedShort();
				
				id[iadd++] = tri1 * 3 + incSide[side1];
				id[iadd++] = tri0 * 3 + incSide[side0];
				id[iadd++] = tri0 * 3 + side0;

				id[iadd++] = tri0 * 3 + incSide[side0];
				id[iadd++] = tri1 * 3 + incSide[side1];
				id[iadd++] = tri1 * 3 + side1;
			}
		}

		if (vadd != m_VertexCnt) throw Error("BuildShadowMesh.ResultVerCnt");
		if (iadd != m_IndexCnt) throw Error("BuildShadowMesh.ResultIndexCnt");

		m_VB = C3D.Context.createVertexBuffer(m_VertexCnt, 6);
		m_VB.uploadFromVector(vd, 0, m_VertexCnt);

		m_IB = C3D.Context.createIndexBuffer(m_IndexCnt);
		m_IB.uploadFromVector(id, 0, m_IndexCnt);

		m_Flag = ((6 * 4) << 8) | (1 << 16) | (1 << 19);

		if (!m_EventOk) {
			m_EventOk = true;
			C3D.stage3D.addEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}

	public function CreateSphere(radius:Number, cnt_rings:int):void
	{
		Clear();

		var x:uint, y:uint, vtx:uint, index:uint;
		var fDAng:Number;
		var fDAngY0:Number;
		var y0:Number, r0:Number, tv:Number, fDAngX0:Number, tu:Number;
		var vx:Number, vy:Number, vz:Number;
		var vyx:Number, vyy:Number, vyz:Number;
		var wNorthVtx:uint, wSouthVtx:uint;
		var p1:uint, p2:uint, p3:uint;

		m_VertexCnt = (cnt_rings * (2 * cnt_rings + 1) + 2);
		m_IndexCnt  = 6 * (cnt_rings * 2) * ((cnt_rings - 1) + 1);

		var stride:int = 3 + 3 + 2;
		var vd:Vector.<Number> = new Vector.<Number>(stride * m_VertexCnt);
		var id:Vector.<uint> = new Vector.<uint>(m_IndexCnt);

		vtx = 0; index = 0;
		fDAng   = Math.PI / cnt_rings;
		fDAngY0 = fDAng;

		for (y = 0; y < cnt_rings; y++) {
			y0 = Math.cos(fDAngY0);
			r0 = Math.sin(fDAngY0);
			tv = (1.0 - y0) / 2.0;
			
			for (x = 0; x < (cnt_rings * 2) + 1; x++) {
				fDAngX0 = x * fDAng;

				vx = r0 * Math.sin(fDAngX0);
				vy = y0;
				vz = r0 * Math.cos(fDAngX0);

				tu = 1.0 - Number(x) / (cnt_rings * 2.0);

				vd[vtx * stride + 0] = vx * radius;
				vd[vtx * stride + 1] = vy * radius;
				vd[vtx * stride + 2] = vz * radius;
				vd[vtx * stride + 3] = vx;
				vd[vtx * stride + 4] = vy;
				vd[vtx * stride + 5] = vz;
				vd[vtx * stride + 6] = tu;
				vd[vtx * stride + 7] = tv;

				vtx++;
			}
			fDAngY0 = fDAngY0 + fDAng;
		}

		for (y = 0; y < cnt_rings - 1; y++) {
			for (x = 0; x < cnt_rings * 2; x++) {
				id[index++] = ( (y + 0) * (cnt_rings * 2 + 1) + (x + 0) );
				id[index++] = ( (y + 1) * (cnt_rings * 2 + 1) + (x + 0) );
				id[index++] = ( (y + 0) * (cnt_rings * 2 + 1) + (x + 1) );
				id[index++] = ( (y + 0) * (cnt_rings * 2 + 1) + (x + 1) );
				id[index++] = ( (y + 1) * (cnt_rings * 2 + 1) + (x + 0) );
				id[index++] = ( (y + 1) * (cnt_rings * 2 + 1) + (x + 1) );
			}
		}

		y = cnt_rings - 1;

		vyx = 0; vyy = 1.0;  vyz = 0;
		wNorthVtx = vtx;
		vd[vtx * stride + 0] = vyx * radius;
		vd[vtx * stride + 1] = vyy * radius;
		vd[vtx * stride + 2] = vyz * radius;
		vd[vtx * stride + 3] = vyx;
		vd[vtx * stride + 4] = vyy;
		vd[vtx * stride + 5] = vyz;
		vd[vtx * stride + 6] = 0.5;
		vd[vtx * stride + 7] = 0.0;
		vtx++;
		wSouthVtx = vtx;
		vd[vtx * stride + 0] = -vyx * radius;
		vd[vtx * stride + 1] = -vyy * radius;
		vd[vtx * stride + 2] = -vyz * radius;
		vd[vtx * stride + 3] = -vyx;
		vd[vtx * stride + 4] = -vyy;
		vd[vtx * stride + 5] = -vyz;
		vd[vtx * stride + 6] = 0.5;
		vd[vtx * stride + 7] = 1.0;
		vtx++;

		for (x = 0; x < cnt_rings * 2; x++) {
			p1 = wSouthVtx;
			p2 = ( (y) * (cnt_rings * 2 + 1) + (x + 1) );
			p3 = ( (y) * (cnt_rings * 2 + 1) + (x + 0) );

			id[index++] = p1;
			id[index++] = p3;
			id[index++] = p2;
		}
		
		for (x = 0; x < cnt_rings * 2; x++) {
			p1 = wNorthVtx;
			p2 = ( (0) * (cnt_rings * 2 + 1) + (x + 1) );
			p3 = ( (0) * (cnt_rings * 2 + 1) + (x + 0) );

			id[index++] = p1;
			id[index++] = p3;
			id[index++] = p2;
		}

		if (vtx != m_VertexCnt) throw Error("CreateSphere.ResultVerCnt");
		if (index != m_IndexCnt) throw Error("CreateSphere.ResultIndexCnt");

		m_VB = C3D.Context.createVertexBuffer(m_VertexCnt, stride);
		m_VB.uploadFromVector(vd, 0, m_VertexCnt);

		m_IB = C3D.Context.createIndexBuffer(m_IndexCnt);
		m_IB.uploadFromVector(id, 0, m_IndexCnt);

		m_Flag = ((stride * 4) << 8) | (1 << 16) | (1 << 19) | (1 << 22);

		if (!m_EventOk) {
			m_EventOk = true;
			C3D.stage3D.addEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}

	public function CreateCone(vfromx:Number, vfromy:Number, vfromz:Number, vtox:Number, vtoy:Number, vtoz:Number, rfrom:Number, rto:Number, seg_cnt:int, fromcap:Boolean, tocap:Boolean):void
	{
		Clear();

		if (seg_cnt < 3) return;

		var vx:Number, vy:Number, vz:Number, k:Number, a:Number, az:Number, ay:Number;
		var v:Vector3D = new Vector3D();
		var vt:Vector3D;
		var vtx:uint, index:uint;
		var i:int;
		
		vtx = 0; index = 0;

		m_VertexCnt = seg_cnt * 2;
		m_IndexCnt = seg_cnt * 2 * 3;
		if (fromcap) m_IndexCnt += (seg_cnt - 2) * 3;
		if (tocap) m_IndexCnt += (seg_cnt - 2) * 3;

		var stride:int = 3 + 3 + 2;
		var vd:Vector.<Number> = new Vector.<Number>(stride * m_VertexCnt);
		var id:Vector.<uint> = new Vector.<uint>(m_IndexCnt);

		vx = vtox - vfromx;
		vy = vtoy - vfromy;
		vz = vtoz - vfromz;
		k = 1.0 / Math.sqrt(vx * vx + vy * vy + vz * vz); vx *= k; vy *= k; vz *= k;

		if (vx > 0) az = Math.atan(vy / vx);
		else if (vx < 0) az = Math.PI + Math.atan(vy / vx);
		else if ((vx = 0) && (vy >= 0)) az = 3.0 * Math.PI / 2.0;
		else az = Math.PI / 2.0;

		ay = Math.acos(vz / Math.sqrt(vx * vx + vy * vy + vz * vz));

		var m:Matrix3D = new Matrix3D();
		m.identity();
		m.appendRotation(ay * 180.0 / Math.PI, Vector3D.Y_AXIS);
		m.appendRotation(az * 180.0 / Math.PI, Vector3D.Z_AXIS);

		a = 0;
		for (i = 0; i < seg_cnt; i++) {
			v.x = Math.sin(a) * rfrom;
			v.y = -Math.cos(a) * rfrom;
			v.z = 0.0;
			vt = m.deltaTransformVector(v);
			
			vd[vtx * stride + 0] = vt.x + vfromx;
			vd[vtx * stride + 1] = vt.y + vfromy;
			vd[vtx * stride + 2] = vt.z + vfromz;
			vt.normalize();
			vd[vtx * stride + 3] = vt.x;
			vd[vtx * stride + 4] = vt.y;
			vd[vtx * stride + 5] = vt.z;
			vd[vtx * stride + 6] = a / (2.0 * Math.PI);
			vd[vtx * stride + 7] = 0.0;
			vtx++;

			a = a + 2.0 * Math.PI / seg_cnt;
		}
		a = 0;
		for (i = 0; i < seg_cnt; i++) {
			v.x = Math.sin(a) * rto;
			v.y = -Math.cos(a) * rto;
			v.z = 0.0;
			vt = m.deltaTransformVector(v);

			vd[vtx * stride + 0] = vt.x + vtox;
			vd[vtx * stride + 1] = vt.y + vtoy;
			vd[vtx * stride + 2] = vt.z + vtoz;
			vt.normalize();
			vd[vtx * stride + 3] = vt.x;
			vd[vtx * stride + 4] = vt.y;
			vd[vtx * stride + 5] = vt.z;
			vd[vtx * stride + 6] = a / (2.0 * Math.PI);
			vd[vtx * stride + 7] = 1.0;
			vtx++;

			a = a + 2.0 * Math.PI / seg_cnt;
		}
		
		index=0;
		for (i = 0; i < seg_cnt; i++) {
			id[index++] = i;
			id[index] = i + 1; if (id[index] >= seg_cnt) id[index] = 0;
			index++;
			id[index++] = i + seg_cnt;

			id[index] = i + 1; if (id[index] >= seg_cnt) id[index] = 0;
			index++;
			id[index] = i + 1 + seg_cnt; if (id[index] >= (seg_cnt + seg_cnt)) id[index] = seg_cnt;
			index++;
			id[index] = i + seg_cnt;
			index++;
		}
		
		if (fromcap) {
			for (i = 0; i < (seg_cnt - 2); i++) {
				id[index++] = 0;
				id[index++] = i + 2;
				id[index++] = i + 1;
			}
		}
		if (tocap) {
			for (i = 0; i < (seg_cnt - 2); i++) {
				id[index++] = seg_cnt + 0;
				id[index++] = seg_cnt + i + 1;
				id[index++] = seg_cnt + i + 2;
			}
		}
		
		if (vtx != m_VertexCnt) throw Error("CreateSphere.ResultVerCnt");
		if (index != m_IndexCnt) throw Error("CreateSphere.ResultIndexCnt");

		m_VB = C3D.Context.createVertexBuffer(m_VertexCnt, stride);
		m_VB.uploadFromVector(vd, 0, m_VertexCnt);

		m_IB = C3D.Context.createIndexBuffer(m_IndexCnt);
		m_IB.uploadFromVector(id, 0, m_IndexCnt);

		m_Flag = ((stride * 4) << 8) | (1 << 16) | (1 << 19) | (1 << 22);

		if (!m_EventOk) {
			m_EventOk = true;
			C3D.stage3D.addEventListener(Event.CONTEXT3D_CREATE, Context3DCreate);
		}
	}
}

}