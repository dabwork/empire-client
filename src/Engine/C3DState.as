// Copyright (C) 2013 Elemental Games. All rights reserved.

package Engine
{
	
public class C3DState
{
	static public var m_EmptyFirst:C3DStateBatch = null;
	static public var m_EmptyLast:C3DStateBatch = null;

	public var m_First:C3DStateBatch = null;
	public var m_Last:C3DStateBatch = null;

	public function C3DState():void
	{
	}

	public function Add():C3DStateBatch 
	{
		var p:C3DStateBatch = m_EmptyFirst;
		if (p != null) {
			if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
			if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
			if (m_EmptyLast == p) m_EmptyLast = C3DStateBatch(p.m_Prev);
			if (m_EmptyFirst == p) m_EmptyFirst = C3DStateBatch(p.m_Next);
		} else {
			p = new C3DStateBatch();
		}
		if (m_Last != null) m_Last.m_Next = p;
		p.m_Prev = m_Last;
		p.m_Next = null;
		m_Last = p;
		if (m_First == null) m_First = p;
		return p;
	}

	public function Del(p:C3DStateBatch):void
	{
		if (p.m_Prev != null) p.m_Prev.m_Next = p.m_Next;
		if (p.m_Next != null) p.m_Next.m_Prev = p.m_Prev;
		if (m_Last == p) m_Last = C3DStateBatch(p.m_Prev);
		if (m_First == p) m_First = C3DStateBatch(p.m_Next);

		p.Clear();

		if (m_EmptyLast != null) m_EmptyLast.m_Next = p;
		p.m_Prev = m_EmptyLast;
		p.m_Next = null;
		m_EmptyLast = p;
		if (m_EmptyFirst == null) m_EmptyFirst = p;
	}
	
	public function Clear():void
	{
		var p:C3DStateBatch;
		var pnext:C3DStateBatch = m_First;
		while (pnext != null) {
			p = pnext;
			pnext = C3DStateBatch(pnext.m_Next);
			Del(p);
		}
	}
}
	
}