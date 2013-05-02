// Copyright (C) 2013 Elemental Games. All rights reserved.

package Base
{

public class CodePc
{
	public static const opsLabel:uint = 0x10000000;
	
	public var m_Op:uint;
	public var m_Val:*;
	
	public function CodePc(op:uint, val:*=undefined):void
	{
		m_Op = op;
		m_Val = val;
	}
}
	
}