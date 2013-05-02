// Copyright (C) 2013 Elemental Games. All rights reserved.

package Base
{

public class CodeSrc
{
	public static const errSyntax:int = 1;
	public static const errNotImplement:int = 2;
	public static const errExpression:int = 3;
	public static const errExpressionStackEmpty:int = 4;
	public static const errNotLoop:int = 5;
	public static const errOpCode:int = 6;
	public static const errParseOpCode:int = 7;
	public static const errDeclAlreadyExist:int = 8;
	public static const errDeclNotFound:int = 9;
	public static const errReservedKeyword:int = 10;
	public static const errDecode:int = 11;
	public static const errEncode:int = 12;
	public static const errConst:int = 13;

	public var m_DefVarType:uint = CodeBlock.dtObject; // тип переменной если явно не задан тип
	public var m_MaskVarType:uint = (1 << CodeBlock.dtDword) | (1 << CodeBlock.dtInt) | (1 << CodeBlock.dtDouble) | (1 << CodeBlock.dtBool) | (1 << CodeBlock.dtString) | (1 << CodeBlock.dtObject); // допустимые типы переменных
	public var m_AccessClassType:Boolean = true;

	public var m_Src:String = null;

	public var m_Off:int = 0;
	public var m_Len:int = 0;
	public var m_Line:int = 0;
	public var m_Char:int = 0;

	public var m_Error:int = 0;
	public var m_ErrorName:String = null;
	
	public var m_WordLen:int = 0;

	public function CodeSrc(src:String):void
	{
		init(src);
	}

	public function error(v:int, name:String = null):void
	{
		m_Error = v;
		m_ErrorName = name;
	}
	public function get err():int { return m_Error; }
	public function get errName():String { return m_ErrorName; }
	
	public function init(src:String, off:int = 0, len:int = -1):void
	{
		m_Src = src;
		m_Off = off;
		m_Len = len;
		if (m_Off > m_Src.length) m_Off = m_Src.length;
		if (m_Off < 0) m_Off = 0;
		if (m_Len < 0) m_Len = src.length - m_Off;
		if (m_Len > (src.length - m_Off)) m_Len = src.length - m_Off;
	}
	
	public function get isEnd():Boolean
	{
		return m_Len <= 0;
	}
	
	public function copyPos(src:CodeSrc):void
	{
		m_Off = src.m_Off;
		m_Len = src.m_Len;
		m_Line = src.m_Line;
		m_Char = src.m_Char;
	}
	
	public function getChar():int
	{
		if (m_Len <= 0) return 0;
		var ch:int = m_Src.charCodeAt(m_Off);
		m_Off++;
		m_Len--;
		m_Char++;
		m_WordLen = 0;
		return ch;
	}
	
	public function pickChar(off:int = 0):int
	{
		if (off < 0) {
			if (m_Off + off < 0) return 0;
		} else {
			if (off >= m_Len) return 0;
		}
		return m_Src.charCodeAt(m_Off + off);
	}
	
	public function nextChar(cnt:int = 1):void
	{
		if (cnt == 0) return;
		m_Off += cnt;
		m_Len -= cnt;
		m_Char += cnt;
		m_WordLen = 0;
	}
	
	public function pickStr(len:int):String
	{
		if (len <= 0) return "";
		if (len > m_Len) len = m_Len;
		return m_Src.substr(m_Off, len);
	}

	public function getStr(len:int):String
	{
		if (len <= 0) return "";
		if (len > m_Len) len = m_Len;
		var str:String = m_Src.substr(m_Off, len);
		m_Off += len;
		m_Len -= len;
		m_Char += len;
		return str;
	}
	
	public function pickWord():String
	{
		var len:int = 0;
		var ch:int;
		
		m_WordLen = 0;

		if (m_Len <= 0) return null;
		
		while (len<m_Len) {
			ch = m_Src.charCodeAt(m_Off + len);
			if (ch >= 65 && ch <= 90) { } // AZ
			else if (ch >= 97 && ch <= 122) { } // az
			else if (len > 0 && ch >= 48 && ch <= 57) { } // 09
			else if (ch == 95) { } // _
			else break;
			len++;
		}
		if (len <= 0) return null;
		
		m_WordLen = len;
		return m_Src.substr(m_Off, len);
	}
	
	public function skipWord():void
	{
		if (m_WordLen <= 0) throw Error("CodeSrc.skipWord");
		nextChar(m_WordLen);
	}
	
	public function parseSpace():void
	{
		var ch:int;
		
		while (m_Len > 0) {
			ch = m_Src.charCodeAt(m_Off);
			if (ch == 32 || ch == 9 || ch == 13) {
				m_Off++;
				m_Len--;
				m_Char++;
			} else if (ch == 10) {
				m_Off++;
				m_Len--;
				m_Char = 0;
				m_Line++;
			} else if (ch == 47 && m_Len >= 2 && m_Src.charCodeAt(m_Off + 1) == 47) {
				m_Off += 2;
				m_Len -= 2;
				while (m_Len > 0 && m_Src.charCodeAt(m_Off) != 10) { m_Off++; m_Len--; }
				m_Char = 0;
				m_Line++;
			} else if (ch == 47 && m_Len >= 2 && m_Src.charCodeAt(m_Off + 1) == 42) {
				m_Off += 2;
				m_Len -= 2;
				m_Char += 2;
				while (m_Len > 0) {
					ch = m_Src.charCodeAt(m_Off);
					if (ch == 10) {
						m_Off++;
						m_Len--;
						m_Char = 0;
						m_Line++;
					} else if (ch == 42 && m_Len >= 2 && m_Src.charCodeAt(m_Off + 1) == 47) {
						m_Off += 2;
						m_Len -= 2;
						m_Char += 2;
						break;
					}
					m_Off++;
					m_Len--;
					m_Char++;
				}
			} else break;
		}
	}
}
	
}