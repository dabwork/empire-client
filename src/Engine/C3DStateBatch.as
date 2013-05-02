// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
import flash.display3D.textures.Texture;
	
public class C3DStateBatch
{
	public var m_Prev:C3DStateBatch = null;
	public var m_Next:C3DStateBatch = null;

	public var m_Off:int = 0;
	public var m_Cnt:int = 0;
	public var m_TexRaw:Texture = null;
	public var m_Tex:C3DTexture = null;

	public function C3DStateBatch():void
	{
	}

	public function Clear():void
	{
		m_Off = 0;
		m_Cnt = 0;
		m_TexRaw = null;
		m_Tex = null;
	}
}
	
}