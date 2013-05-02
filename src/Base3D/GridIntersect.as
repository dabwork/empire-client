// Copyright (C) 2013 Elemental Games. All rights reserved.

package Base3D
{

public class GridIntersect
{
	public var m_BeginX:Number;
	public var m_BeginY:Number;
	public var m_BeginZ:Number;
	public var m_SizeX:Number;
	public var m_SizeY:Number;
	public var m_SizeZ:Number;
	public var m_CntX:int;
	public var m_CntY:int;
	public var m_CntZ:int;

	public var m_SrcPosX:Number;
	public var m_SrcPosY:Number;
	public var m_SrcPosZ:Number;

	public var m_SrcDirX:Number;
	public var m_SrcDirY:Number;
	public var m_SrcDirZ:Number;
	
	public var m_SrcDist:Number;
	
    public var m_DirX:int;
	public var m_DirY:int;
	public var m_DirZ:int;

    public var m_LenX:Number;
	public var m_LenY:Number;
	public var m_LenZ:Number;

    public var m_NextX:Number;
	public var m_NextY:Number;
	public var m_NextZ:Number;

	public var m_CurX:Number;
	public var m_CurY:Number;
	public var m_CurZ:Number;

	public var m_X:int;
	public var m_Y:int;
	public var m_Z:int;

	public function GridIntersect():void
	{
	}

    public function Init(vbeginx:Number, vbeginy:Number, vbeginz:Number, vendx:Number, vendy:Number, vendz:Number, cntx:int, cnty:int, cntz:int):void
	{
		m_BeginX = Math.min(vbeginx, vendx);
		m_BeginY = Math.min(vbeginy, vendy);
		m_BeginZ = Math.min(vbeginz, vendz);
		m_SizeX = Math.max(vbeginx, vendx) - m_BeginX;
		m_SizeY = Math.max(vbeginy, vendy) - m_BeginY;
		m_SizeZ = Math.max(vbeginz, vendz) - m_BeginZ;
		m_CntX = cntx;
		m_CntY = cnty;
		m_CntZ = cntz;
	}
    
	public function IBegin(posx:Number, posy:Number, posz:Number, dirx:Number, diry:Number, dirz:Number, dist:Number, fl:uint = 0):Boolean  // dir - должно быть нормализованно
	{
		m_SrcDirX = dirx;
		m_SrcDirY = diry;
		m_SrcDirZ = dirz;

		m_SrcPosX = posx;
		m_SrcPosY = posy;
		m_SrcPosZ = posz;

		m_SrcDist = dist;
		
		var sizecellx:Number = m_SizeX / m_CntX;
		var sizecelly:Number = m_SizeY / m_CntY;
		var sizecellz:Number = m_SizeZ / m_CntZ;

		var kx:Number = Number(m_CntX) / m_SizeX;
		var ky:Number = Number(m_CntY) / m_SizeY;
		var kz:Number = Number(m_CntZ) / m_SizeZ;

		m_X = Math.floor((posx - m_BeginX) * kx);
		m_Y = Math.floor((posy - m_BeginY) * ky);
		m_Z = Math.floor((posz - m_BeginZ) * kz);

		m_DirX = 0; if (dirx<-0.0001) m_DirX=-1; else if(dirx>0.0001) m_DirX=1;
		m_DirY = 0; if (diry<-0.0001) m_DirY=-1; else if(diry>0.0001) m_DirY=1;
		m_DirZ = 0; if (dirz<-0.0001) m_DirZ=-1; else if(dirz>0.0001) m_DirZ=1;

		if (m_X < 0 && m_DirX <= 0) return false; else if (m_X >= m_CntX && m_DirX >= 0) return false;
		if (m_Y < 0 && m_DirY <= 0) return false; else if (m_Y >= m_CntY && m_DirY >= 0) return false;
		if (m_Z < 0 && m_DirZ <= 0) return false; else if (m_Z >= m_CntZ && m_DirZ >= 0) return false;
		
		var d:Number;

		if (m_DirX) {
			m_LenX = sizecellx / Math.abs(dirx);

			if (fl & 1) {
				if (m_X < 0) m_X = 0;
				else if (m_X >= m_CntX) m_X = m_CntX - 1;
			}

			if (m_DirX < 0) d = -(m_BeginX + sizecellx * Math.min(m_CntX, m_X));
			else d = -(m_BeginX + sizecellx * Math.max(0, m_X + 1));
			m_NextX = -(posx + d) / dirx;

			if (!(fl & 1)) {
				if (m_X < 0 || m_X >= m_CntX) {
					if (m_NextX > m_SrcDist) return false;
					return IBegin(
						m_SrcPosX + m_SrcDirX * m_NextX, 
						m_SrcPosY + m_SrcDirY * m_NextX, 
						m_SrcPosZ + m_SrcDirZ * m_NextX, 
						m_SrcDirX, m_SrcDirY, m_SrcDirZ,
						m_SrcDist -= m_NextX, fl | 1);
				}
			}
		}
		if (m_DirY) {
			m_LenY = sizecelly / Math.abs(diry);

			if (fl & 2) {
				if (m_Y < 0) m_Y = 0;
				else if (m_Y >= m_CntY) m_Y = m_CntY - 1;
			}

			if (m_DirY < 0) d = -(m_BeginY + sizecelly * Math.min(m_CntY, m_Y));
			else d = -(m_BeginY + sizecelly * Math.max(0, m_Y + 1));
			m_NextY = -(posy + d) / diry;

			if (!(fl & 2)) {
				if (m_Y < 0 || m_Y >= m_CntY) {
					if (m_NextY > m_SrcDist) return false;
					return IBegin(
						m_SrcPosX + m_SrcDirX * m_NextY,
						m_SrcPosY + m_SrcDirY * m_NextY,
						m_SrcPosZ + m_SrcDirZ * m_NextY,
						m_SrcDirX, m_SrcDirY, m_SrcDirZ,
						m_SrcDist -= m_NextY, fl | 2);
				}
			}
		}
		if (m_DirZ) {
			m_LenZ = sizecellz / Math.abs(dirz);

			if (fl & 4) {
				if (m_Z < 0) m_Z = 0;
				else if (m_Z >= m_CntZ) m_Z = m_CntZ - 1;
			}

			if (m_DirZ < 0) d = -(m_BeginZ + sizecellz * Math.min(m_CntZ, m_Z));
			else d = -(m_BeginZ + sizecellz * Math.max(0, m_Z + 1));
			m_NextZ = -(posz + d) / dirz;

			if (!(fl & 4)) {
				if (m_Z < 0 || m_Z >= m_CntZ) {
					if (m_NextZ > m_SrcDist) return false;
					return IBegin(
						m_SrcPosX + m_SrcDirX * m_NextZ,
						m_SrcPosY + m_SrcDirY * m_NextZ,
						m_SrcPosZ + m_SrcDirZ * m_NextZ,
						m_SrcDirX, m_SrcDirY, m_SrcDirZ,
						m_SrcDist -= m_NextZ, fl | 4);
				}
			}
		}

		m_CurX = m_SrcPosX;
		m_CurY = m_SrcPosY;
		m_CurZ = m_SrcPosZ;

		return true;
	}

    public function INext():Boolean
	{
		if (m_DirX && (!m_DirY || m_NextX <= m_NextY) && (!m_DirZ || m_NextX <= m_NextZ)) { // X
			if (m_NextX > m_SrcDist) return false;
			m_CurX = m_SrcPosX + m_SrcDirX * m_NextX;
			m_CurY = m_SrcPosY + m_SrcDirY * m_NextX;
			m_CurZ = m_SrcPosZ + m_SrcDirZ * m_NextX;
			m_NextX += m_LenX;
			m_X += m_DirX;
		} else if (m_DirY && (!m_DirZ || m_NextY <= m_NextZ)) { // Y
			if (m_NextY > m_SrcDist) return false;
			m_CurX = m_SrcPosX + m_SrcDirX * m_NextY;
			m_CurY = m_SrcPosY + m_SrcDirY * m_NextY;
			m_CurZ = m_SrcPosZ + m_SrcDirZ * m_NextY;
			m_NextY += m_LenY;
			m_Y += m_DirY;
		} else if (m_DirZ) { // Z
			if (m_NextZ > m_SrcDist) return false;
			m_CurX = m_SrcPosX + m_SrcDirX * m_NextZ;
			m_CurY = m_SrcPosY + m_SrcDirY * m_NextZ;
			m_CurZ = m_SrcPosZ + m_SrcDirZ * m_NextZ;
			m_NextZ += m_LenZ;
			m_Z += m_DirZ;
		}

		if (m_X < 0 && m_DirX <= 0) return false; else if (m_X >= m_CntX && m_DirX >= 0) return false;
		if (m_Y < 0 && m_DirY <= 0) return false; else if (m_Y >= m_CntY && m_DirY >= 0) return false;
		if (m_Z < 0 && m_DirZ <= 0) return false; else if (m_Z >= m_CntZ && m_DirZ >= 0) return false;

		return true;
	}
}
	
}