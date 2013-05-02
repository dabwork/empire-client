// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import Base3D.GridIntersect;
import Base3D.Math3D;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.utils.ByteArray;
import flash.utils.getTimer;

public class C3DHitMesh
{
	public var m_Vertex:Vector.<Number> = new Vector.<Number>();
	public var m_Index:Vector.<int> = new Vector.<int>();
	public var m_Cell:Vector.<int> = new Vector.<int>();

	public var m_MinX:Number=0;
	public var m_MinY:Number=0;
	public var m_MinZ:Number=0;

	public var m_SizeX:Number=0;
	public var m_SizeY:Number=0;
	public var m_SizeZ:Number=0;

	public var m_CenterX:Number=0;
	public var m_CenterY:Number=0;
	public var m_CenterZ:Number=0;

	public var m_Radius:Number = 0;
	public var m_RadiusTo0:Number = 0;

	public function C3DHitMesh():void
	{
	}

	public function Clear():void
	{
		m_MinX = 0;
		m_MinY = 0;
		m_MinZ = 0;

		m_SizeX = 0;
		m_SizeY = 0;
		m_SizeZ = 0;

		m_CenterX = 0;
		m_CenterY = 0;
		m_CenterZ = 0;

		m_Radius = 0;
		m_RadiusTo0 = 0;

		m_Vertex.length = 0;
		m_Index.length = 0;
		m_Cell.length = 0;

		m_Vertex.fixed = false;
		m_Index.fixed = false;
		m_Cell.fixed = false;
	}
	
	public function Add(mesh:C3DMesh, m:Matrix3D = null):void
	{
		var i:int;

		if (mesh.m_Frame.length <= 0) return;
		var fr:C3DMeshFrame = mesh.m_Frame[0];
		if (fr.m_VertexCnt <= 0) return;

		var vsrc:Vector.<Number> = new Vector.<Number>(3 * fr.m_VertexCnt, true);
		var vdes:Vector.<Number> = new Vector.<Number>(3 * fr.m_VertexCnt, true);

		var mr:Matrix3D = new Matrix3D();
		if (m != null) mr.copyFrom(m);
		else mr.identity();
		if (fr.m_MatrixNo >= 0) {
			mr.prepend(mesh.m_Matrix[fr.m_MatrixNo]);
		}

		var ss:uint = (mesh.m_Flag >> 8) & 255;

		var pt:uint = (mesh.m_Flag & 0x70000) >> 16;
		if (pt == 1) {}
		else if (pt == 2) {}
		else throw Error("C3DMesh.Flag.Position");

		for (i = 0; i < fr.m_VertexCnt; i++) {
			mesh.m_Raw.position = mesh.m_VertexSme + ss * (fr.m_VertexStart + i);

			vsrc[i * 3 + 0] = mesh.m_Raw.readFloat();
			vsrc[i * 3 + 1] = mesh.m_Raw.readFloat();
			vsrc[i * 3 + 2] = mesh.m_Raw.readFloat();
		}

		mr.transformVectors(vsrc, vdes);

		var start:int = m_Vertex.length;
		m_Vertex.length += fr.m_VertexCnt * 3;
		for (i = 0; i < fr.m_VertexCnt * 3; i++) {
			m_Vertex[start + i] = vdes[i];
		}
		start = Math.floor(start / 3);

		var starti:int = m_Index.length;
		m_Index.length += fr.m_TriCnt * 3;
		mesh.m_Raw.position = mesh.m_IndexSme + 2 * (fr.m_IndexStart);
		for (i = 0; i < fr.m_TriCnt * 3; i++) {
			m_Index[starti + i] = mesh.m_Raw.readUnsignedShort() - fr.m_VertexStart + start;
			if (m_Index[starti + i] < 0 || m_Index[starti + i] >= m_Vertex.length) throw Error("C3DHitMesh.Add");
		}
	}
	
	public function Calc():void
	{
		var i:int, u:int;

		if (m_Vertex.length <= 0) return;
		
		m_Vertex.fixed = true;
		m_Index.fixed = true;

		m_MinX = m_Vertex[0];
		m_MinY = m_Vertex[1];
		m_MinZ = m_Vertex[2];
		m_SizeX = m_Vertex[0];
		m_SizeY = m_Vertex[1];
		m_SizeZ = m_Vertex[2];

var t0:int = getTimer();
		for (i = 3; i < m_Vertex.length; i+=3) {
			m_MinX = Math.min(m_MinX, m_Vertex[i + 0]);
			m_MinY = Math.min(m_MinY, m_Vertex[i + 1]);
			m_MinZ = Math.min(m_MinZ, m_Vertex[i + 2]);
			m_SizeX = Math.max(m_SizeX, m_Vertex[i + 0]);
			m_SizeY = Math.max(m_SizeY, m_Vertex[i + 1]);
			m_SizeZ = Math.max(m_SizeZ, m_Vertex[i + 2]);
		}

var t1:int = getTimer();
		m_SizeX -= m_MinX;
		m_SizeY -= m_MinY;
		m_SizeZ -= m_MinZ;

		m_CenterX = m_MinX + m_SizeX * 0.5;
		m_CenterY = m_MinY + m_SizeY * 0.5;
		m_CenterZ = m_MinZ + m_SizeZ * 0.5;
		m_RadiusTo0 = Math.sqrt(m_CenterX * m_CenterX + m_CenterY * m_CenterY + m_CenterZ * m_CenterZ);

		var shlcell:int = 4;
		var cntcell:int = 1 << shlcell;
		var smetri:int = cntcell * cntcell * cntcell * 2;
		var cnt:int = Math.floor(m_Index.length / 3);
		m_Cell.length = smetri + cnt;

		var minmaxt:Vector.<int> = new Vector.<int>(cnt * 6, true);

		var v1x:Number, v1y:Number, v1z:Number;
		var v2x:Number, v2y:Number, v2z:Number;
		var v3x:Number, v3y:Number, v3z:Number;

		m_Radius = 0.0;

		var kx:Number = Number(cntcell) / m_SizeX;
		var ky:Number = Number(cntcell) / m_SizeY;
		var kz:Number = Number(cntcell) / m_SizeZ;
		for (i = 0; i < cnt; i++) {
			u = m_Index[i * 3 + 0] * 3;
			v1x = m_Vertex[u + 0];
			v1y = m_Vertex[u + 1];
			v1z = m_Vertex[u + 2];
			u = m_Index[i * 3 + 1] * 3;
			v2x = m_Vertex[u + 0];
			v2y = m_Vertex[u + 1];
			v2z = m_Vertex[u + 2];
			u = m_Index[i * 3 + 2] * 3;
			v3x = m_Vertex[u + 0];
			v3y = m_Vertex[u + 1];
			v3z = m_Vertex[u + 2];

			m_Radius = Math.max(m_Radius, (m_CenterX - v1x) * (m_CenterX - v1x) + (m_CenterY - v1y) * (m_CenterY - v1y) + (m_CenterZ - v1z) * (m_CenterZ - v1z));
			m_Radius = Math.max(m_Radius, (m_CenterX - v2x) * (m_CenterX - v2x) + (m_CenterY - v2y) * (m_CenterY - v2y) + (m_CenterZ - v2z) * (m_CenterZ - v2z));
			m_Radius = Math.max(m_Radius, (m_CenterX - v3x) * (m_CenterX - v3x) + (m_CenterY - v3y) * (m_CenterY - v3y) + (m_CenterZ - v3z) * (m_CenterZ - v3z));

			minmaxt[i * 6 + 0] = Math.floor((Math.min(v1x, v2x, v3x) - m_MinX) * kx);
			minmaxt[i * 6 + 1] = Math.floor((Math.min(v1y, v2y, v3y) - m_MinY) * ky);
			minmaxt[i * 6 + 2] = Math.floor((Math.min(v1z, v2z, v3z) - m_MinZ) * kz);
			minmaxt[i * 6 + 3] = Math.ceil((Math.max(v1x, v2x, v3x) - m_MinX) * kx);
			minmaxt[i * 6 + 4] = Math.ceil((Math.max(v1y, v2y, v3y) - m_MinY) * ky);
			minmaxt[i * 6 + 5] = Math.ceil((Math.max(v1z, v2z, v3z) - m_MinZ) * kz);
		}
		m_Radius = Math.sqrt(m_Radius);

		var csx:Number = m_SizeX / cntcell;
		var csy:Number = m_SizeY / cntcell;
		var csz:Number = m_SizeZ / cntcell;
		var cbx:Number, cby:Number, cbz:Number;

		var x:int, y:int, z:int, acnt:int;
		var listcelloff:int = 0;
		var indext:int = 0;
		var inter:Boolean;

var t2:int = getTimer();
var t2a:int = 0;
var t2b:int = 0;
var tA:int,tB:int;
		var iii:int;
		var iii2:int;
		var tricntall:int = 0;
		for (z = 0; z < cntcell; z++) {
			cbz = m_MinZ + csz * z;
			for (y = 0; y < cntcell; y++) {
				cby = m_MinY + csy * y;
				for (x = 0; x < cntcell; x++, listcelloff += 2) {
					cbx = m_MinX + csx * x;

					m_Cell[listcelloff + 0] = indext;
					acnt = 0;

					if ((smetri + indext + cnt) > m_Cell.length) {
//tA = getTimer();
						m_Cell.length += smetri + indext + cnt + 1024 * 16;
//tB = getTimer();
//t2b += tB - tA;
					}

					for (i = 0, iii = 0; i < cnt; i++, iii += 3) {
						iii2 = iii << 1;
						if (x<minmaxt[iii2+0] || x>=minmaxt[iii2+3]) continue;
						if (y<minmaxt[iii2+1] || y>=minmaxt[iii2+4]) continue;
						if (z<minmaxt[iii2+2] || z>=minmaxt[iii2+5]) continue;

						u = m_Index[iii + 0] * 3;
						v1x = m_Vertex[u + 0];
						v1y = m_Vertex[u + 1];
						v1z = m_Vertex[u + 2];
						u = m_Index[iii + 1] * 3;
						v2x = m_Vertex[u + 0];
						v2y = m_Vertex[u + 1];
						v2z = m_Vertex[u + 2];
						u = m_Index[iii + 2] * 3;
						v3x = m_Vertex[u + 0];
						v3y = m_Vertex[u + 1];
						v3z = m_Vertex[u + 2];

//tA = getTimer();
						inter = Math3D.IntersectAABBTri(cbx, cby, cbz, csx, csy, csz, v1x, v1y, v1z, v2x, v2y, v2z, v3x, v3y, v3z);
//tB = getTimer();
//t2a += tB - tA;
						if (inter) {
							m_Cell[smetri + indext] = i;
							acnt++;
							indext++;
						}
						tricntall++;
					}

					m_Cell[listcelloff + 1] = acnt;
				}
			}
		}
var t3:int = getTimer();
trace(t1 - t0, t2 - t1, t3 - t2, t2a, t2b, "tricntall:", tricntall);

		m_Cell.length = smetri + indext;
		m_Cell.fixed = true;
	}
	
	public function Save(out:ByteArray):void
	{
		var i:int;
		var u:uint;
		if (m_Vertex.length >= (65536 * 3)) throw Error("C3DMesh.Save00");
		out.writeInt(m_Vertex.length);
		out.writeInt(m_Index.length);
		out.writeInt(m_Cell.length);
		
		out.writeFloat(m_MinX);
		out.writeFloat(m_MinY);
		out.writeFloat(m_MinZ);

		out.writeFloat(m_SizeX);
		out.writeFloat(m_SizeY);
		out.writeFloat(m_SizeZ);

		out.writeFloat(m_Radius);

		for (i = 0; i < m_Vertex.length; i++) out.writeFloat(m_Vertex[i]);
		for (i = 0; i < m_Index.length; i++) {
			u = m_Index[i];
			if (u >= 65536) throw Error("C3DMesh.Save01");
			out.writeShort(u);
		}
		for (i = 0; i < m_Cell.length; i++) {
			u = m_Cell[i];
			if (u >= 65536) throw Error("C3DMesh.Save02");
			out.writeShort(u);
		}
	}
	
	public function Load(src:ByteArray):void
	{
		var i:int;
		
		Clear();
		
		m_Vertex.length = src.readInt();
		m_Index.length = src.readInt();
		m_Cell.length = src.readInt();
		m_Vertex.fixed = true;
		m_Index.fixed = true;
		m_Cell.fixed = true;
		
		m_MinX=src.readFloat();
		m_MinY=src.readFloat();
		m_MinZ=src.readFloat();

		m_SizeX=src.readFloat();
		m_SizeY=src.readFloat();
		m_SizeZ=src.readFloat();

		m_Radius = src.readFloat();
		
		m_CenterX = m_MinX + m_SizeX * 0.5;
		m_CenterY = m_MinY + m_SizeY * 0.5;
		m_CenterZ = m_MinZ + m_SizeZ * 0.5;
		m_RadiusTo0 = Math.sqrt(m_CenterX * m_CenterX + m_CenterY * m_CenterY + m_CenterZ * m_CenterZ);
		
		for (i = 0; i < m_Vertex.length; i++) {
			m_Vertex[i] = src.readFloat();
		}
		for (i = 0; i < m_Index.length; i++) {
			m_Index[i] = uint(src.readUnsignedShort());
		}
		for (i = 0; i < m_Cell.length; i++) {
			m_Cell[i] = uint(src.readUnsignedShort());
		}
	}

	private var gi:GridIntersect = new GridIntersect();
	private var ti:Vector3D = new Vector3D();

	public function Pick(posx:Number, posy:Number, posz:Number, dirx:Number, diry:Number, dirz:Number, out_normal:Vector3D = null):Number
	{
		var i:int, cnt:int, listcell:int, lit:int, ilist:int, i0:int, i1:int, i2:int;
		var v1x:Number, v1y:Number, v1z:Number;
		var v2x:Number, v2y:Number, v2z:Number;
		var v3x:Number, v3y:Number, v3z:Number;

		var shlcell:int = 4;
		var cntcell:int = 1 << shlcell;
		var smetri:int = cntcell * cntcell * cntcell * 2;
		gi.Init(m_MinX, m_MinY, m_MinZ, m_MinX + m_SizeX, m_MinY + m_SizeY, m_MinZ + m_SizeZ, cntcell, cntcell, cntcell);
		
//var tritest:int = 0;
//var celltest:int = 0;

		var dist:Number = Math.sqrt(dirx * dirx + diry * diry + dirz * dirz);
		var disto:Number = 1.0 / dist;
		if (gi.IBegin(posx, posy, posz, dirx * disto, diry * disto, dirz * disto, dist)) {
			while (true) {
				listcell = ((gi.m_X + (gi.m_Y << shlcell) + (gi.m_Z << (shlcell << 1))) << 1);
				lit = smetri + m_Cell[listcell + 0];
				cnt = m_Cell[listcell + 1];
				
//celltest++;

				for (i = 0; i < cnt; i++, lit++) {
					ilist = m_Cell[lit];
					ilist = ilist + ilist + ilist;
					i0 = m_Index[ilist + 0];
					i1 = m_Index[ilist + 1];
					i2 = m_Index[ilist + 2];
					i0 = i0 + i0 + i0;
					i1 = i1 + i1 + i1;
					i2 = i2 + i2 + i2;

					v1x = m_Vertex[i0 + 0]; v1y = m_Vertex[i0 + 1]; v1z = m_Vertex[i0 + 2];
					v2x = m_Vertex[i1 + 0]; v2y = m_Vertex[i1 + 1]; v2z = m_Vertex[i1 + 2];
					v3x = m_Vertex[i2 + 0]; v3y = m_Vertex[i2 + 1]; v3z = m_Vertex[i2 + 2];

//tritest++;
					if(Math3D.IntersectTriangle(posx, posy, posz,
									dirx, diry, dirz,
									v1x, v1y, v1z,
									v2x, v2y, v2z,
									v3x, v3y, v3z,
									ti))
					{
						if (ti.x >= 0.0 && ti.x <= 1.0) {
							if (out_normal != null) {
								out_normal.x = (v2y - v1y) * (v3z - v1z) - (v2z - v1z) * (v3y - v1y);
								out_normal.y = (v2z - v1z) * (v3x - v1x) - (v2x - v1x) * (v3z - v1z);
								out_normal.z = (v2x - v1x) * (v3y - v1y) - (v2y - v1y) * (v3x - v1x);
								out_normal.normalize();
							}
//trace(celltest, tritest);
							return ti.x;
						}
					}
				}
				if (!gi.INext()) break;
			}
		}
//trace(celltest, tritest);

		return -1e20;
	}
}

}