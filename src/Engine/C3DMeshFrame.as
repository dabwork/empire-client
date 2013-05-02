// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{

public class C3DMeshFrame
{
	public var m_VertexStart:uint=0;
    public var m_VertexCnt:uint=0;
    public var m_IndexStart:uint=0;
    public var m_TriCnt:uint=0;
    public var m_MatrixNo:int=-1; // -1-none
    public var m_MinX:Number=0;
	public var m_MinY:Number=0;
	public var m_MinZ:Number=0;
    public var m_MaxX:Number=0;
	public var m_MaxY:Number=0;
	public var m_MaxZ:Number=0;
    public var m_Radius:Number=0;

	public var m_EdgeStart:uint=0;
	public var m_EdgeCnt:uint=0;
	public var m_EdgeNearStart:uint=0;
	public var m_EdgeNearCnt:uint = 0;
	
	public function C3DMeshFrame():void
	{
	}
}

}
