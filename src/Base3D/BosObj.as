package Base3D
{
	
public class BosObj
{
	public var m_ObjPrev:BosObj = null;
	public var m_ObjNext:BosObj = null;
	public var m_Node:BosNode = null;
	public var m_X:Number = 0;
	public var m_Y:Number = 0;
	public var m_Z:Number = 0;
	public var m_Radius:Number = 0;
	
	public var m_Ptr:Object = null;
	public var m_User:Object = null;

	public function BosObj():void
	{
	}
	
	public function Clear():void
	{
		m_ObjPrev = null;
		m_ObjNext = null;
		m_Node = null;
		m_Ptr = null;
		m_User = null;
	}
}
	
}