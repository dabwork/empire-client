// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import flash.geom.Vector3D;
import flash.utils.*;
	
public class SpacePath
{
	public static const ConnectEngine0:uint = 0x100;// 256;
	public static const ConnectEngine1:uint = 0x101;// 257;
	public static const ConnectEngine2:uint = 0x102;// 258;
	public static const ConnectEngine3:uint = 0x103;// 259;
	public static const ConnectEngine4:uint = 0x104;// 260;
	public static const ConnectWeapon0:uint = 0x200;// 512;
	public static const ConnectWeapon1:uint = 0x201;// 513;
	public static const ConnectWeapon2:uint = 0x202;// 514;
	public static const ConnectWeapon3:uint = 0x203;// 515;
	public static const ConnectWeapon4:uint = 0x204;// 516;
	public static const ConnectWeaponL0:uint = 0x300;// 768;
	public static const ConnectTakeoff0:uint = 0x1000;
	public static const ConnectTakeoff1:uint = 0x1001;
	public static const ConnectTakeoff2:uint = 0x1002;
	public static const ConnectTakeoff3:uint = 0x1003;
	public static const ConnectOpen0:uint = 0x1100;
	public static const ConnectOpen1:uint = 0x1101;
	public static const ConnectOpen2:uint = 0x1102;
	public static const ConnectOpen3:uint = 0x1103;
	public static const ConnectDock0:uint = 0x2000;
	public static const ConnectUndock0:uint = 0x2010;
	public static const ConnectDock1:uint = 0x2100;
	public static const ConnectUndock1:uint = 0x2110;
	public static const ConnectDock2:uint = 0x2200;
	public static const ConnectUndock2:uint = 0x2210;
	public static const ConnectDock3:uint = 0x2300;
	public static const ConnectUndock3:uint = 0x2310;
	public static const ConnectDock4:uint = 0x2400;
	public static const ConnectUndock4:uint = 0x2410;
	public static const ConnectAimStart:uint = 0x3000;
	public static const ConnectAimEnd:uint = 0x3001;
	
	public var m_Length:Number;
	
	public var m_Unit:Vector.<PathUnit> = new Vector.<PathUnit>();
	
	public static var m_PathList:Array = new Array();
	
	public function SpacePath():void
	{
		m_Length = 0;
	}
	
	public function Clear():void
	{
		m_Length = 0;
		m_Unit.length = 0;
	}
	
	public function Load(mesh:C3DMesh, connect:uint):void
	{
		var i:int, u:int;
		var v:Vector3D;
		var pu:PathUnit;

		var vpos:Vector3D = new Vector3D(0, 0, 0, 0);
		var vdir:Vector3D = new Vector3D(0, 1.0, 0, 0);
		var vup:Vector3D = new Vector3D(0, 0, 1.0, 0);

		Clear();

		var no:int = mesh.ConnectById(connect);
		if (no < 0) throw Error("");

		var cnt:int = mesh.m_FrameCnt;
		if (cnt <= 0) throw Error("");

		for (i = 0; i < cnt; i++) {
			u = mesh.Connect(no, i);
			if (u < 0) throw Error("");

			pu = new PathUnit();
			m_Unit.push(pu);

			v = mesh.m_Matrix[u].transformVector(vpos);
			pu.m_PosX = v.x;
			pu.m_PosY = v.y;
			pu.m_PosZ = v.z;

			v = mesh.m_Matrix[u].deltaTransformVector(vdir);
			v.normalize();
			pu.m_DirX = v.x;
			pu.m_DirY = v.y;
			pu.m_DirZ = v.z;

			v = mesh.m_Matrix[u].deltaTransformVector(vup);
			v.normalize();
			pu.m_UpX = v.x;
			pu.m_UpY = v.y;
			pu.m_UpZ = v.z;
		}
		
		m_Length = 0;
		m_Unit[0].m_Length = 0;
		for (i = 1; i < m_Unit.length; i++) {
			vpos.x = m_Unit[i].m_PosX - m_Unit[i - 1].m_PosX;
			vpos.y = m_Unit[i].m_PosY - m_Unit[i - 1].m_PosY;
			vpos.z = m_Unit[i].m_PosZ - m_Unit[i - 1].m_PosZ;
			m_Unit[i].m_Length = Math.sqrt(vpos.x * vpos.x + vpos.y * vpos.y + vpos.z * vpos.z);
			m_Length += m_Unit[i].m_Length;
		}
	}

	public function FindByLength(l:Number):Number
	{
		var i:int;
		var s:Number;

		if (l <= 0.0) return 0.0;

		for (i = 1; i < m_Unit.length; i++) {
			if (l < m_Unit[i].m_Length) {
				s = (1.0 / Number(m_Unit.length - 1));
				return Number(i - 1) * s + (l / m_Unit[i].m_Length) * s;
			}
			l -= m_Unit[i].m_Length;
		}
		return 1.0;
	}
	
	public function Get(t:Number, out_pos:Vector3D, out_dir:Vector3D, out_up:Vector3D):void
	{
		var pu:PathUnit;
		if (t <= 0.0001) {
			pu = m_Unit[0];
			if (out_pos) { out_pos.x = pu.m_PosX; out_pos.y = pu.m_PosY; out_pos.z = pu.m_PosZ; out_pos.w = 0; }
			if (out_dir) { out_dir.x = pu.m_DirX; out_dir.y = pu.m_DirY; out_dir.z = pu.m_DirZ; out_dir.w = 0; }
			if (out_up) { out_up.x = pu.m_UpX; out_up.y = pu.m_UpY; out_up.z = pu.m_UpZ; out_up.w = 0; }
			return;
		} else if (t >= 0.9999) {
			pu = m_Unit[m_Unit.length - 1];
			if (out_pos) { out_pos.x = pu.m_PosX; out_pos.y = pu.m_PosY; out_pos.z = pu.m_PosZ; out_pos.w = 0; }
			if (out_dir) { out_dir.x = pu.m_DirX; out_dir.y = pu.m_DirY; out_dir.z = pu.m_DirZ; out_dir.w = 0; }
			if (out_up) { out_up.x = pu.m_UpX; out_up.y = pu.m_UpY; out_up.z = pu.m_UpZ; out_up.w = 0; }
			return;
		}

		t = t * (m_Unit.length - 1);
		var n:int = Math.floor(t);
		if (n > m_Unit.length - 2) {
			pu = m_Unit[m_Unit.length - 1];
			if (out_pos) { out_pos.x = pu.m_PosX; out_pos.y = pu.m_PosY; out_pos.z = pu.m_PosZ; out_pos.w = 0; }
			if (out_dir) { out_dir.x = pu.m_DirX; out_dir.y = pu.m_DirY; out_dir.z = pu.m_DirZ; out_dir.w = 0; }
			if (out_up) { out_up.x = pu.m_UpX; out_up.y = pu.m_UpY; out_up.z = pu.m_UpZ; out_up.w = 0; }
			return;
		}

		t = Math.min(1.0, t - n);

		pu = m_Unit[n];
		var pu2:PathUnit = m_Unit[n + 1];

		if(out_pos) {
			out_pos.x = pu.m_PosX + (pu2.m_PosX - pu.m_PosX) * t;
			out_pos.y = pu.m_PosY + (pu2.m_PosY - pu.m_PosY) * t;
			out_pos.z = pu.m_PosZ + (pu2.m_PosZ - pu.m_PosZ) * t;
			out_pos.w = 0;
		}

		if(out_dir) {
			out_dir.x = pu.m_DirX + (pu2.m_DirX - pu.m_DirX) * t;
			out_dir.y = pu.m_DirY + (pu2.m_DirY - pu.m_DirY) * t;
			out_dir.z = pu.m_DirZ + (pu2.m_DirZ - pu.m_DirZ) * t;
			out_dir.w = 0;
			out_dir.normalize();
		}

		if(out_up) {
			out_up.x = pu.m_UpX + (pu2.m_UpX - pu.m_UpX) * t;
			out_up.y = pu.m_UpY + (pu2.m_UpY - pu.m_UpY) * t;
			out_up.z = pu.m_UpZ + (pu2.m_UpZ - pu.m_UpZ) * t;
			out_up.w = 0;
			out_up.normalize();
		}
	}
	
	[Inline] public static function GetPath(gst:uint, connect:uint):SpacePath
	{
		var sp:SpacePath = m_PathList[(gst << 16) | connect];
		if (sp == null) throw Error("");
		return sp;
	}
	
	public static function Init(gst:uint, mpl:Array):Boolean
	{
		var i:int, u:int, id:uint;
		var o:Object;
		var mesh:C3DMesh;
		var sp:SpacePath;

		if (m_PathList[gst << 16] != undefined) return true;

		for (i = 0; i < mpl.length; i++) {
			o = LoadManager.Self.Get(mpl[i]);
			if (o == null) return false;
		}

		for (i = 0; i < mpl.length; i++) {
			o = LoadManager.Self.Get(mpl[i]);
			if (o==null || !(o is ByteArray)) Error("");

			(o as ByteArray).endian = Endian.LITTLE_ENDIAN;
			mesh = new C3DMesh();
			mesh.Init(o as ByteArray);

			for (u = 0; u < mesh.m_ConnectCnt; u++) {
				id = mesh.ConnectId(u);
//trace(id.toString(16));
				if (id == ConnectTakeoff0) { }
				else if (id == ConnectTakeoff1) { }
				else if (id == ConnectTakeoff2) { }
				else if (id == ConnectTakeoff3) { }
				else if (id == ConnectDock0) { }
				else if (id == ConnectDock1) { }
				else if (id == ConnectDock2) { }
				else if (id == ConnectDock3) { }
				else if (id == ConnectUndock0) { }
				else if (id == ConnectUndock1) { }
				else if (id == ConnectUndock2) { }
				else if (id == ConnectUndock3) { }
				else continue;

				sp = new SpacePath();
				sp.Load(mesh, id);

				m_PathList[(gst << 16) | id] = sp;
			}
		}

		m_PathList[gst << 16] = true;
		return true;
	}
}
	
}

import Engine.*;

class PathUnit
{
	public var m_PosX:Number;
	public var m_PosY:Number;
	public var m_PosZ:Number;

	public var m_DirX:Number;
	public var m_DirY:Number;
	public var m_DirZ:Number;

	public var m_UpX:Number;
	public var m_UpY:Number;
	public var m_UpZ:Number;

	public var m_Length:Number;
}
