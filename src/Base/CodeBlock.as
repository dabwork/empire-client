package Base
{
import flash.utils.*;
	
public class CodeBlock
{
	public static const dtMask:uint = 0xf;
    public static const dtNone:uint = 0;
    public static const dtByte:uint = 1;
    public static const dtChar:uint = 2;
    public static const dtWord:uint = 3;
    public static const dtShort:uint = 4;
    public static const dtDword:uint = 5;
    public static const dtInt:uint = 6;
    public static const dtQword:uint = 7;
    public static const dtLong:uint = 8;
    public static const dtFloat:uint = 9;
    public static const dtDouble:uint = 10;
	public static const dtBool:uint = 11;
    public static const dtString:uint = 12;
	public static const dtObject:uint = 13;

    public static const defZero:uint = 0;
    public static const defOne:uint = 1;
    public static const defTwo:uint = 2;
    public static const defTen:uint = 3;
    public static const defMOne:uint = 4;
    public static const defMTwo:uint = 5;
    public static const defMTen:uint = 6;
	public static const defNull:uint = 7;
	public static const defUndefined:uint = 8;
	public static const defTrue:uint = 9;
	public static const defFalse:uint = 10;

	public static const jmpLong:uint = 1; // однобайтный или двухбайтный переход
	public static const jmpGoTo:uint = 2;
	public static const jmpIf:uint = 4;
	public static const jmpIfNot:uint = 6;
	public static const jmpMask:uint = 0x0e;

	public static const descMask:uint = 3 << 2;
	public static const descSimple:uint = 0 << 2;
	public static const descIf:uint = 1 << 2;
	public static const descElseIf:uint = 2 << 2;
	public static const descElse:uint = 3 << 2;
	public static const descForInit:uint = 0 << 2;
	public static const descForIf:uint = 1 << 2;
	public static const descForInc:uint = 2 << 2;
	public static const descWhile:uint = 3 << 2;

	// возможные комбинации для сложных команд где есть установленный бит в старших двух битах:  0x40-0xf0
	public static const opPushConst:uint = 0xF0; // нижние 4 бита - тип данных
	public static const opPushDef:uint = 0xE0;
    public static const opPushLocal:uint = 0xD0; // 0x8 то: 0/1/2/3/4/5/6/7 = -4/-3/-2/-1/0/1/2/3 иначе: 1/2/3 = 1/2/4 количество байт для номера локальной переменной в стеке
    public static const opPop:uint = 0xC0; // нижние 4 бита кол-во выброшеных переменных
    public static const opAssumeLocal:uint = 0xB0; // 0x8 то: 0/1/2/3/4/5/6/7 = -4/-3/-2/-1/0/1/2/3 иначе: 1/2/3 = 1/2/4 количество байт для номера локальной переменной в стеке
	public static const opCallByName:uint = 0xA0; // нижние 4 бита количество аргументов, next byte - длина имени
	public static const opCallByNum:uint = 0x90; // bin: 0x8-внешняя функция 0/1/2/3 = количество байт для номера функции 0/1/2/4, next byte - количество аргументов; CodePc: m_Val=0x80000000-внешняя функция, m_Op & 0xf=кол-во аргументов
	public static const opJump:uint = 0x80;
	public static const opAssumeVarByNum:uint = 0x70; // 0x8 то: 0/1/2/3/4/5/6/7 = 0/1/2/3/4/5/6/7 иначе: 1/2/3 = 1/2/4 количество байт для номера глобальной переменной
	public static const opPushVarByNum:uint = 0x60; // 0x8 то: 0/1/2/3/4/5/6/7 = 0/1/2/3/4/5/6/7 иначе: 1/2/3 = 1/2/4 количество байт для номера глобальной переменной
	public static const opDesc:uint = 0x50; // 0/1/2/3 = количество байт для номера строки 0/1/2/4
	public static const opDescFor:uint = 0x40; // 0/1/2/3 = количество байт для номера строки 0/1/2/4

    public static const opNop:uint = 0;
    public static const opWait:uint = 1;
    public static const opBool:uint = 2;
    public static const opBoolNot:uint = 3;
    public static const opNot:uint = 4;
    public static const opMinus:uint = 5;
	public static const opPlus:uint = 6;

	public static const opPushConstStr:uint = 10; // next 2 byte - размер строки без учета 0-го байта
	
	public static const opAssumeVarByName:uint = 11; // next byte - длина имени
	public static const opAssumeMemberVarByName:uint = 12; // next byte - длина имени
	public static const opPushVarByName:uint = 13; // next byte - длина имени
	public static const opPushMemberVarByName:uint = 14; // next byte - длина имени
	public static const opReplaceMemberVarByName:uint = 15; // next byte - длина имени

    public static const opAdd:uint = 16;
    public static const opSub:uint = 17;
    public static const opAnd:uint = 18;
    public static const opOr:uint = 19;
    public static const opXor:uint = 20;
	public static const opShl:uint = 21;
	public static const opShr:uint = 22;
    public static const opMul:uint = 23;
    public static const opDiv:uint = 24;
	public static const opMod:uint = 25;
    public static const opBoolOr:uint = 26;
    public static const opBoolAnd:uint = 27;
    public static const opLess:uint = 28;
    public static const opMore:uint = 29;
    public static const opEqual:uint = 30;
    public static const opNotEqual:uint = 31;
    public static const opLessEqual:uint = 32;
    public static const opMoreEqual:uint = 33;
	
	public var m_Code:ByteArray = null;
	
	public var m_Pc:Vector.<CodePc> = null;
	
	public var m_LabelCnt:int = 0;
	
	public var m_WriteDesc:uint = 0;
	public var m_WriteLine:int = 0;

	public function get isEmpty():Boolean
	{
		return (m_Code == null) || (m_Code.length <= 0);
	}

	public function get code():ByteArray
	{
		if (m_Code == null) { m_Code = new ByteArray(); m_Code.endian = Endian.LITTLE_ENDIAN; }
		return m_Code;
	}
	
	public static function SaveStr(str:String, buf:ByteArray):int
	{
		var p:int = buf.position;
		buf.writeShort(0);
		if (str != null || str.length > 0) buf.writeUTFBytes(str);
		var t:int = buf.position;
		var len:int = t - p - 2;
		if (len > 0) {
			if (len >= 65536) return -1;
			buf.position = p;
			buf.writeShort(len);
			buf.position = t;
		}
		buf.writeByte(0);
		return len;
	}
	
	public function OpDesc(et:uint, line:uint):void
	{
		m_WriteDesc = 0;
		
		var size:int = 0;
		if (line == 0) size = 0;
		else if (line <= 255) size = 1;
		else if (line <= 65535) size = 2;
		else size = 3;
		code.writeByte(et | size);
		if (size == 1) code.writeByte(line);
		else if (size == 2) code.writeShort(line);
		else if (size == 3) code.writeUnsignedInt(line);
	}
	
	public function OpDescWrite():void
	{
		if (!m_WriteDesc) return;
		OpDesc(m_WriteDesc, m_WriteLine);
		m_WriteDesc = 0;
		m_WriteLine = 0;
	}

	public function Op(op:uint):void
	{
		OpDescWrite();
		code.writeByte(op);
	}

	public function OpPushConstDword(v:uint):void
	{
		OpDescWrite();
        if (v == 0) { code.writeByte(opPushDef | defZero); }
        else if (v == 1) { code.writeByte(opPushDef | defOne); }
        else if (v == 2) { code.writeByte(opPushDef | defTwo); }
        else if (v == 10) { code.writeByte(opPushDef | defTen); }
        else if (v <= 255) {
            code.writeByte(opPushConst | dtByte);
            code.writeByte(v);
        } else if(v<=65535) {
            code.writeByte(opPushConst | dtWord);
			code.writeShort(v);
        } else {
            code.writeByte(opPushConst | dtDword);
			code.writeUnsignedInt(v);
        }
	}

	public function OpPushConstInt(v:int):void
	{
		OpDescWrite();
        if (v == 0) { code.writeByte(opPushDef | defZero); }
        else if (v == 1) { code.writeByte(opPushDef | defOne); }
        else if (v == 2) { code.writeByte(opPushDef | defTwo); }
        else if (v == 10) { code.writeByte(opPushDef | defTen); }
        else if (v == -1) { code.writeByte(opPushDef | defMOne); }
        else if (v == -2) { code.writeByte(opPushDef | defMTwo); }
        else if (v == -10) { code.writeByte(opPushDef | defMTen); }
        else if (v >= -128 && v <= 127) {
            code.writeByte(opPushConst | dtChar);
            code.writeByte(v);
        } else if (v >= -32768 && v <= 32767) {
            code.writeByte(opPushConst | dtShort);
			code.writeShort(v);
        } else {
            code.writeByte(opPushConst | dtInt);
			code.writeInt(v);
        }
	}
	
	public function OpPushConstString(str:String):void
	{
		OpDescWrite();
		code.writeByte(opPushConstStr);
		SaveStr(str, code);
	}

	public function OpAssumeVarByName(name:String):Boolean
	{
		if (name == null || name.length <= 0 || name.length > 255) return false;
		OpDescWrite();
		code.writeByte(opAssumeVarByName);
		code.writeByte(name.length);
		code.writeUTFBytes(name);
		return true;
	}
	
	public function OpAssumeMemberVarByName(name:String):Boolean
	{
		if (name == null || name.length <= 0 || name.length > 255) return false;
		OpDescWrite();
		code.writeByte(opAssumeMemberVarByName);
		code.writeByte(name.length);
		code.writeUTFBytes(name);
		return true;
	}

	public function OpPushVarByName(name:String):Boolean
	{
		if (name == null || name.length <= 0 || name.length > 255) return false;
		OpDescWrite();
		code.writeByte(opPushVarByName);
		code.writeByte(name.length);
		code.writeUTFBytes(name);
		return true;
	}

	public function OpPushMemberVarByName(name:String):Boolean
	{
		if (name == null || name.length <= 0 || name.length > 255) return false;
		OpDescWrite();
		code.writeByte(opPushMemberVarByName);
		code.writeByte(name.length);
		code.writeUTFBytes(name);
		return true;
	}

	public function OpReplaceMemberVarByName(name:String):Boolean
	{
		if (name == null || name.length <= 0 || name.length > 255) return false;
		OpDescWrite();
		code.writeByte(opReplaceMemberVarByName);
		code.writeByte(name.length);
		code.writeUTFBytes(name);
		return true;
	}

	public function OpCallByName(argcnt:int, name:String):Boolean
	{
		if (argcnt < 0 || argcnt > 15) return false;
		if (name == null || name.length <= 0 || name.length > 255) return false;
		OpDescWrite();
		code.writeByte(opCallByName | argcnt);
		code.writeByte(name.length);
		code.writeUTFBytes(name);
		return true;
	}
	
	public function OpJump(jt:uint, offset:int):Boolean
	{
		if (offset >= -128 && offset <= 127) {
			OpDescWrite();
			code.writeByte(opJump | jt);
			code.writeByte(offset);
		} else if (offset >= -32768 && offset <= 32767) {
			OpDescWrite();
			code.writeByte(opJump | jt | jmpLong);
			code.writeShort(offset);
		} else return false;
		return true;
	}
	
	public function OpJumpAdr(jt:uint, adr:int):Boolean
	{
		var offset:int = adr - (code.position + 2);
		
		if (offset >= -128 && offset <= 127) {
			OpDescWrite();
			code.writeByte(opJump | jt);
			code.writeByte(offset);
		} else if (offset >= -32760 && offset <= 32760) {
			OpDescWrite();
			offset = adr - (code.position + 3);
			code.writeByte(opJump | jt | jmpLong);
			code.writeShort(offset);
		} else return false;
		return true;
	}

	public function ReplaceJumpLongAdr(from:int, adr:int):Boolean
	{
		if (from < 0 || (from + 3) > code.length) return false;

		var oldpos:int = code.position;
		code.position = from;

		var offset:int = adr - (from + 3);

		if (offset >= -32760 && offset <= 32760) {
			var op:uint = code.readUnsignedByte();
			if ((op & 0xf0) != opJump) return false;
			if ((op & jmpLong) == 0) return false;
			code.writeShort(offset);
			
		} else return false;
		
		code.position = oldpos;
		return true;
	}
	
	public function ReplaceJumpLongAdrAll(from:int, old1:int, adr1:int, old2:int = -1, adr2:int = 0):Boolean
	{
		if (m_Code == null) return false;
		if (from < 0) return false;
		
		var oldpos:int = m_Code.position;
		m_Code.position = from;
		
		var op:uint;
		var len:int;
		var v:int, offset:int;
		
		while (m_Code.position < m_Code.length) {
			op = m_Code.readUnsignedByte();
			if ((op & 0xf0) == opPushDef) {
			}
			else if ((op & 0xf0) == opPushConst) {
				op &= 15;
				if (op == dtByte) m_Code.position = m_Code.position + 1;
				else if (op == dtWord) m_Code.position = m_Code.position + 2;
				else if (op == dtDword) m_Code.position = m_Code.position + 4;
				else if (op == dtChar) m_Code.position = m_Code.position + 1;
				else if (op == dtShort) m_Code.position = m_Code.position + 2;
				else if (op == dtInt) m_Code.position = m_Code.position + 4;
				else return false;
			}
			else if ((op & 0xf0) == opCallByName) {
				op &= 15;
				len = m_Code.readUnsignedByte();
				m_Code.position = m_Code.position + len;
			}
			else if ((op & 0xf0) == opCallByNum) {
				m_Code.position = m_Code.position + 1;
				switch(op & 3) {
					case 1: m_Code.position = m_Code.position + 1; break;
					case 2: m_Code.position = m_Code.position + 2; break;
					case 3: m_Code.position = m_Code.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opJump) {
				if ((op & jmpLong) == 0) m_Code.position = m_Code.position + 1;
				else {
					v = m_Code.readShort();
					if (v == old1) {
						m_Code.position = m_Code.position - 2;
						offset = adr1 - (m_Code.position + 2);
						if (offset >= -32760 && offset <= 32760) m_Code.writeShort(offset);
						else return false;
					} else if (v == old2) {
						m_Code.position = m_Code.position - 2;
						offset = adr2 - (m_Code.position + 2);
						if (offset >= -32760 && offset <= 32760) m_Code.writeShort(offset);
						else return false;
					}
				}
			}
			else if ((op & 0xf0) == opDesc) {
				switch(op & 3) {
					case 1: m_Code.position = m_Code.position + 1; break;
					case 2: m_Code.position = m_Code.position + 2; break;
					case 3: m_Code.position = m_Code.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opDescFor) {
				switch(op & 3) {
					case 1: m_Code.position = m_Code.position + 1; break;
					case 2: m_Code.position = m_Code.position + 2; break;
					case 3: m_Code.position = m_Code.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opPushLocal) {
				if ((op & 8) == 0)
				switch(op & 3) {
					case 1: m_Code.position = m_Code.position + 1; break;
					case 2: m_Code.position = m_Code.position + 2; break;
					case 3: m_Code.position = m_Code.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opAssumeLocal) {
				if ((op & 8) == 0)
				switch(op & 3) {
					case 1: m_Code.position = m_Code.position + 1; break;
					case 2: m_Code.position = m_Code.position + 2; break;
					case 3: m_Code.position = m_Code.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opPushVarByNum) {
				if ((op & 8) == 0)
				switch(op & 3) {
					case 1: m_Code.position = m_Code.position + 1; break;
					case 2: m_Code.position = m_Code.position + 2; break;
					case 3: m_Code.position = m_Code.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opAssumeVarByNum) {
				if ((op & 8) == 0)
				switch(op & 3) {
					case 1: m_Code.position = m_Code.position + 1; break;
					case 2: m_Code.position = m_Code.position + 2; break;
					case 3: m_Code.position = m_Code.position + 4; break;
				}
			}
			else if (op == opAssumeVarByName || op==opAssumeMemberVarByName) {
				len = m_Code.readUnsignedByte();
				m_Code.position = m_Code.position + len;
			}
			else if (op == opPushVarByName || op == opPushMemberVarByName || op == opReplaceMemberVarByName) {
				len = m_Code.readUnsignedByte();
				m_Code.position = m_Code.position + len;
			}
			else if (op == opPushConstStr) {
				len = m_Code.readUnsignedShort();
				m_Code.position = m_Code.position + len + 1;
			}
			else if (op == opNop) { }
			else if (op == opWait) { }
			else if (op == opMinus) { }
			else if (op == opPlus) { }
			else if (op == opBool) { }
			else if (op == opBoolNot) { }
			else if (op == opNot) { }
			else if (op == opAdd) { }
			else if (op == opSub) { }
			else if (op == opAnd) { }
			else if (op == opOr) { }
			else if (op == opXor) { }
			else if (op == opShl) { }
			else if (op == opShr) { }
			else if (op == opMul) { }
			else if (op == opDiv) { }
			else if (op == opMod) { }
			else if (op == opBoolOr) { }
			else if (op == opBoolAnd) { }
			else if (op == opLess) { }
			else if (op == opMore) { }
			else if (op == opEqual) { }
			else if (op == opNotEqual) { }
			else if (op == opLessEqual) { }
			else if (op == opMoreEqual) { }
			else return false;
		}
		
		code.position = oldpos;
		return true;
	}
	
	public function AddBlock(block:CodeBlock):void
	{
		if (block.m_Code == null || block.m_Code.length <= 0) return;
		code.writeBytes(block.m_Code);
	}
	
	public static function error():void
	{
		trace("CodeBlock.error");
	}
	
	public static function BuildJumpList(d:ByteArray, out:Vector.<int>):Boolean
	{
		if (d == null) return true;
		
		var oldpos:int = d.position;
		d.position = 0;
		
		var op:uint;
		var len:int;
		var v:int, offset:int;
		
		while (d.position < d.length) {
			op = d.readUnsignedByte();
			if ((op & 0xf0) == opPushDef) {
			}
			else if ((op & 0xf0) == opPushConst) {
				op &= 15;
				if (op == dtByte) d.position = d.position + 1;
				else if (op == dtWord) d.position = d.position + 2;
				else if (op == dtDword) d.position = d.position + 4;
				else if (op == dtChar) d.position = d.position + 1;
				else if (op == dtShort) d.position = d.position + 2;
				else if (op == dtInt) d.position = d.position + 4;
				else { error(); return false; }
			}
			else if ((op & 0xf0) == opCallByName) {
				op &= 15;
				len = d.readUnsignedByte();
				d.position = d.position + len;
			}
			else if ((op & 0xf0) == opCallByNum) {
				d.position = d.position + 1;
				switch(op & 3) {
					case 1: d.position = d.position + 1; break;
					case 2: d.position = d.position + 2; break;
					case 3: d.position = d.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opJump) {
				if ((op & jmpLong) == 0) {
					v = d.readByte();
					out.push(d.position - 2);
					out.push(d.position + v);
				}
				else {
					v = d.readShort();
					out.push(d.position - 3);
					out.push(d.position + v);
				}
			}
			else if ((op & 0xf0) == opDesc) {
				switch(op & 3) {
					case 1: d.position = d.position + 1; break;
					case 2: d.position = d.position + 2; break;
					case 3: d.position = d.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opDescFor) {
				switch(op & 3) {
					case 1: d.position = d.position + 1; break;
					case 2: d.position = d.position + 2; break;
					case 3: d.position = d.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opPushLocal) {
				if ((op & 8) == 0)
				switch(op & 3) {
					case 1: d.position = d.position + 1; break;
					case 2: d.position = d.position + 2; break;
					case 3: d.position = d.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opAssumeLocal) {
				if ((op & 8) == 0)
				switch(op & 3) {
					case 1: d.position = d.position + 1; break;
					case 2: d.position = d.position + 2; break;
					case 3: d.position = d.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opPushVarByNum) {
				if ((op & 8) == 0)
				switch(op & 3) {
					case 1: d.position = d.position + 1; break;
					case 2: d.position = d.position + 2; break;
					case 3: d.position = d.position + 4; break;
				}
			}
			else if ((op & 0xf0) == opAssumeVarByNum) {
				if ((op & 8) == 0)
				switch(op & 3) {
					case 1: d.position = d.position + 1; break;
					case 2: d.position = d.position + 2; break;
					case 3: d.position = d.position + 4; break;
				}
			}
			else if (op == opAssumeVarByName || op == opAssumeMemberVarByName) {
				len = d.readUnsignedByte();
				d.position = d.position + len;
				
			}
			else if (op == opPushVarByName || op == opPushMemberVarByName || op == opReplaceMemberVarByName) {
				len = d.readUnsignedByte();
				d.position = d.position + len;
			}
			else if (op == opPushConstStr) {
				len = d.readUnsignedShort();
				d.position = d.position + len + 1;
			}
			else if (op == opNop) { }
			else if (op == opWait) { }
			else if (op == opMinus) { }
			else if (op == opPlus) { }
			else if (op == opBool) { }
			else if (op == opBoolNot) { }
			else if (op == opNot) { }
			else if (op == opAdd) { }
			else if (op == opSub) { }
			else if (op == opAnd) { }
			else if (op == opOr) { }
			else if (op == opXor) { }
			else if (op == opShl) { }
			else if (op == opShr) { }
			else if (op == opMul) { }
			else if (op == opDiv) { }
			else if (op == opMod) { }
			else if (op == opBoolOr) { }
			else if (op == opBoolAnd) { }
			else if (op == opLess) { }
			else if (op == opMore) { }
			else if (op == opEqual) { }
			else if (op == opNotEqual) { }
			else if (op == opLessEqual) { }
			else if (op == opMoreEqual) { }
			else { error(); return false; }
		}
		
		d.position = oldpos;
		return true;
	}
	
	public static function BuildLabelList(d:ByteArray, out:Vector.<int>):Boolean
	{
		var jl:Vector.<int> = new Vector.<int>();
		if (!BuildJumpList(d, jl)) return false;
		
		var i:int, u:int, v:int;
		for (i = 0; i < jl.length; i += 2) {
			v = jl[i + 1];
			for (u = 0; u < out.length; u++) {
				if (out[u] == v) break;
			}
			if (u >= out.length) out.push(v);
		}
		
		return true;
	}
	
	public function pcClear():void
	{
		m_Pc = null;
		m_LabelCnt = 0;
	}
	
	public function decode(d:ByteArray):Boolean
	{
		if (d == null) return true;
		if (m_Pc == null) m_Pc = new Vector.<CodePc>();

		var op:uint;
		var off:int, len:int;

		var ll:Vector.<int> = new Vector.<int>();
		if (!BuildLabelList(d, ll)) return false;

		var oldpos:int = d.position;
		d.position = 0;

		while (d.position < d.length) {

			off = ll.indexOf(d.position);
			if (off >= 0) {
				m_Pc.push(new CodePc(CodePc.opsLabel, m_LabelCnt + off));
			}

			op = d.readUnsignedByte();
			if (op & 0xc0) {
				switch(op & 0xf0) {
					case CodeBlock.opPushDef:
						m_Pc.push(new CodePc(op));
						break;

					case CodeBlock.opPushConst:
						switch(op & 15) {
							case CodeBlock.dtByte: m_Pc.push(new CodePc(op,d.readUnsignedByte())); break;
							case CodeBlock.dtWord: m_Pc.push(new CodePc(op,d.readUnsignedShort())); break;
							case CodeBlock.dtDword: m_Pc.push(new CodePc(op,d.readUnsignedInt())); break;
							case CodeBlock.dtChar: m_Pc.push(new CodePc(op,d.readByte())); break;
							case CodeBlock.dtShort: m_Pc.push(new CodePc(op,d.readShort())); break;
							case CodeBlock.dtInt: m_Pc.push(new CodePc(op,d.readInt())); break;
							default: error(); return false;
						}
						break;

					case CodeBlock.opCallByName:
						len = d.readUnsignedByte();
						m_Pc.push(new CodePc(op, d.readUTFBytes(len)));
						break;

					case CodeBlock.opCallByNum:
						len = d.readUnsignedByte();
						if (len > 15) { error(); return false; }
						switch(op & 3) {
							case 0: m_Pc.push(new CodePc(CodeBlock.opCallByNum | len, ((op & 0x8)?0x80000000:0))); break;
							case 1: m_Pc.push(new CodePc(CodeBlock.opCallByNum | len, ((op & 0x8)?0x80000000:0) | d.readUnsignedByte())); break;
							case 2: m_Pc.push(new CodePc(CodeBlock.opCallByNum | len, ((op & 0x8)?0x80000000:0) | d.readUnsignedShort())); break;
							case 3: m_Pc.push(new CodePc(CodeBlock.opCallByNum | len, ((op & 0x8)?0x80000000:0) | d.readUnsignedInt())); break;
						}
						break;

					case CodeBlock.opJump:
						if (op & CodeBlock.jmpLong) off = d.readShort();
						else off = d.readByte();
						
						off = ll.indexOf(d.position + off);
						if (off < 0) { error(); return false; }
						
						m_Pc.push(new CodePc(op, off));
						break;

					case CodeBlock.opDesc:
					case CodeBlock.opDescFor:
						switch(op & 3) {
							case 0: m_Pc.push(new CodePc(op, 0)); break;
							case 1: m_Pc.push(new CodePc(op,d.readUnsignedByte())); break;
							case 2: m_Pc.push(new CodePc(op,d.readUnsignedShort())); break;
							case 3: m_Pc.push(new CodePc(op,d.readUnsignedInt())); break;
						}
						break;
						
					case CodeBlock.opPushLocal:
					case CodeBlock.opAssumeLocal:
						if (op & 8) m_Pc.push(new CodePc(op, int(op & 7) - 4));
						else 
						switch(op & 3) {
							case 0: m_Pc.push(new CodePc(op, 0)); break;
							case 1: m_Pc.push(new CodePc(op,d.readByte())); break;
							case 2: m_Pc.push(new CodePc(op,d.readShort())); break;
							case 3: m_Pc.push(new CodePc(op,d.readInt())); break;
						}
						break;

					case CodeBlock.opPushVarByNum:
					case CodeBlock.opAssumeVarByNum:
						if (op & 8) m_Pc.push(new CodePc(op, int(op & 7)));
						else 
						switch(op & 3) {
							case 0: m_Pc.push(new CodePc(op, 0)); break;
							case 1: m_Pc.push(new CodePc(op,d.readByte())); break;
							case 2: m_Pc.push(new CodePc(op,d.readShort())); break;
							case 3: m_Pc.push(new CodePc(op,d.readInt())); break;
						}
						break;

					default: { error(); return false; }
				}
			} else {
				switch(op) {
					case CodeBlock.opPushVarByName:
					case CodeBlock.opAssumeVarByName:
					case CodeBlock.opPushMemberVarByName:
					case CodeBlock.opReplaceMemberVarByName:
					case CodeBlock.opAssumeMemberVarByName:
						len = d.readUnsignedByte();
						m_Pc.push(new CodePc(op, d.readUTFBytes(len)));
						break;

					case CodeBlock.opPushConstStr:
						len = d.readUnsignedShort();
						if (len <= 0) m_Pc.push(new CodePc(op, ""));
						else m_Pc.push(new CodePc(op, d.readUTFBytes(len)));
						d.position = d.position + 1;
						break;

					case CodeBlock.opNop:
					case CodeBlock.opWait:
					case CodeBlock.opPlus:
					case CodeBlock.opMinus:
					case CodeBlock.opNot:
					case CodeBlock.opBoolNot:
					case CodeBlock.opBool:
					case CodeBlock.opAdd:
					case CodeBlock.opSub:
					case CodeBlock.opAnd:
					case CodeBlock.opOr:
					case CodeBlock.opXor:
					case CodeBlock.opShl:
					case CodeBlock.opShr:
					case CodeBlock.opMul:
					case CodeBlock.opDiv:
					case CodeBlock.opMod:
					case CodeBlock.opBoolOr:
					case CodeBlock.opBoolAnd:
					case CodeBlock.opLess:
					case CodeBlock.opMore:
					case CodeBlock.opEqual:
					case CodeBlock.opNotEqual:
					case CodeBlock.opLessEqual:
					case CodeBlock.opMoreEqual:
						m_Pc.push(new CodePc(op));
						break;
						
					default: { error(); return false; }
				}
			}
		}

		off = ll.indexOf(d.position);
		if (off >= 0) {
			m_Pc.push(new CodePc(CodePc.opsLabel, m_LabelCnt + off));
		}

		d.position = oldpos;

		m_LabelCnt += ll.length;
		return true;
	}

	public function encode():Boolean
	{
		if (m_Pc == null || m_Pc.length <= 0) {
			if (m_Code != null) m_Code.length = 0;
			return true;
		}

		if (m_Code == null) { m_Code = new ByteArray(); m_Code.endian = Endian.LITTLE_ENDIAN; }
		m_Code.length = 0;

		var pc:CodePc;
		var op:uint;
		var i:int, u:int, k:int, off:int, size:int;

		// сначала рассчитываем размер каждой инструкции
		var sl:Vector.<int> = new Vector.<int>(m_Pc.length);
		for (i = 0; i < m_Pc.length; i++) sl[i] = 0;
		var change:Boolean = true;
		var existzero:Boolean = false;
		var alljmplong:Boolean = false;
		while (change) {
			change = false;
			existzero = false;

			for (i = 0; i < m_Pc.length; i++) {
				if (sl[i] != 0) continue;
				pc = m_Pc[i];
				op = pc.m_Op;

				if (op == CodePc.opsLabel) {
					continue;

				} else if (op & 0xc0) {
					switch(op & 0xf0) {
						case CodeBlock.opPushDef:
							sl[i] = 1;
							change = true;
							break;

						case CodeBlock.opPushConst:
							switch(op & 15) {
								case CodeBlock.dtByte: 
								case CodeBlock.dtWord: 
								case CodeBlock.dtDword: 
									if (pc.m_Val <= 255) sl[i] = 1 + 1;
									else if (pc.m_Val <= 65535) sl[i] = 1 + 2;
									else sl[i] = 1 + 4;
									change = true;
									break;
								case CodeBlock.dtChar: 
								case CodeBlock.dtShort: 
								case CodeBlock.dtInt: 
									if (pc.m_Val >= -128 && pc.m_Val <= 127) sl[i] = 1 + 1;
									else if (pc.m_Val >= -32768 && pc.m_Val <= 32767) sl[i] = 1 + 2;
									else sl[i] = 1 + 4;
									change = true;
									break;
								default: { error(); return false; }
							}
							break;

						case CodeBlock.opCallByName:
							sl[i] = 1 + 1 + pc.m_Val.length;
							change = true;
							break;

						case CodeBlock.opCallByNum:
							if (pc.m_Val == 0) sl[i] = 1 + 1;
							else if (pc.m_Val <= 255) sl[i] = 1 + 1 + 1;
							else if (pc.m_Val <= 65535) sl[i] = 1 + 1 + 2;
							else sl[i] = 1 + 1 + 4;
							break;

						case CodeBlock.opJump:
							for (u = 0; u < m_Pc.length; u++) {
								if (m_Pc[u].m_Op != CodePc.opsLabel) continue;
								if (m_Pc[u].m_Val != pc.m_Val) continue;
								break;
							}
							if (u >= m_Pc.length) { error(); return false; }
							if (u == i) { error(); return false; }

							if (u < i) {
								off = 0;
								while (u < i) {
									if (m_Pc[u].m_Op == CodePc.opsLabel) { }
									else if (alljmplong && sl[u] == 0 && (m_Pc[u].m_Op & 0xf0) == CodeBlock.opJump) off += 3;
									else if (sl[u] == 0) break;
									else off += sl[u];
									u++;
								}
								if (u < i) break;
								if (off + 2 <= 128) sl[i] = 2;
								else sl[i] = 3;
							} else {
								off = 0;
								k = i + 1;
								while (k < u) {
									if (m_Pc[k].m_Op == CodePc.opsLabel) { }
									else if (alljmplong && sl[u] == 0 && (m_Pc[u].m_Op & 0xf0) == CodeBlock.opJump) off += 3;
									else if (sl[k] == 0) break;
									else off += sl[k];
									k++;
								}
								if (k < u) break;
								if (off <= 127) sl[i] = 2;
								else sl[i] = 3;
							}
							alljmplong = false;
							change = true;
							break;
							
						case CodeBlock.opDesc:
						case CodeBlock.opDescFor:
							switch(op & 3) {
								case 0: sl[i] = 1; break;
								case 1: sl[i] = 1 + 1; break;
								case 2: sl[i] = 1 + 2; break;
								case 3: sl[i] = 1 + 4; break;
							}
							change = true;
							break;
							
						case CodeBlock.opPushLocal:
						case CodeBlock.opAssumeLocal:
							if (pc.m_Val >= -4 && pc.m_Val <= 3) sl[i] = 1;
							else if (pc.m_Val >= -128 && pc.m_Val <= 127) sl[i] = 1 + 1;
							else if (pc.m_Val >= -32768 && pc.m_Val <= 32767) sl[i] = 1 + 2;
							else sl[i] = 1 + 4;
							change = true;
							break;

						case CodeBlock.opPushVarByNum:
						case CodeBlock.opAssumeVarByNum:
							if (pc.m_Val <= 7) sl[i] = 1;
							else if (pc.m_Val <= 255) sl[i] = 1 + 1;
							else if (pc.m_Val <= 65535) sl[i] = 1 + 2;
							else sl[i] = 1 + 4;
							change = true;
							break;

						default: { error(); return false; }
					}
				} else {
					switch(op) {
						case CodeBlock.opPushVarByName:
						case CodeBlock.opAssumeVarByName:
						case CodeBlock.opPushMemberVarByName:
						case CodeBlock.opReplaceMemberVarByName:
						case CodeBlock.opAssumeMemberVarByName:
							sl[i] = 1 + 1 + pc.m_Val.length;
							change = true;
							break;
						case CodeBlock.opPushConstStr:
							var ba:ByteArray = new ByteArray();
							ba.endian = Endian.LITTLE_ENDIAN;
							u = SaveStr(pc.m_Val, ba);
							if (u < 0) { error(); return false; }
							sl[i] = 1 + 2 + u + 1;
							break;
							
						case CodeBlock.opNop:
						case CodeBlock.opWait:
						case CodeBlock.opPlus:
						case CodeBlock.opMinus:
						case CodeBlock.opNot:
						case CodeBlock.opBoolNot:
						case CodeBlock.opBool:
						case CodeBlock.opAdd:
						case CodeBlock.opSub:
						case CodeBlock.opAnd:
						case CodeBlock.opOr:
						case CodeBlock.opXor:
						case CodeBlock.opShl:
						case CodeBlock.opShr:
						case CodeBlock.opMul:
						case CodeBlock.opDiv:
						case CodeBlock.opMod:
						case CodeBlock.opBoolOr:
						case CodeBlock.opBoolAnd:
						case CodeBlock.opLess:
						case CodeBlock.opMore:
						case CodeBlock.opEqual:
						case CodeBlock.opNotEqual:
						case CodeBlock.opLessEqual:
						case CodeBlock.opMoreEqual:
							sl[i] = 1;
							change = true;
							break;
							
						default: { error(); return false; }
					}

				}

				if (sl[i] == 0) existzero = true;
			}

			if (!change && existzero) {
				if(alljmplong) {
					error();
					return false;
				}
				alljmplong = true;
				change = true;
			}
		}

		// записываем инструкции
		for (i = 0; i < m_Pc.length; i++) {
			pc = m_Pc[i];
			op = pc.m_Op;

			if (op == CodePc.opsLabel) continue;
			if (sl[i] == 0) { error(); return false; }
			
			if (op & 0xc0) {
				switch(op & 0xf0) {
					case CodeBlock.opPushDef:
						m_Code.writeByte(op);
						size += 1;
						break;

					case CodeBlock.opPushConst:
						switch(op & 15) {
							case CodeBlock.dtByte: 
							case CodeBlock.dtWord: 
							case CodeBlock.dtDword:
								if (sl[i] == 2) { m_Code.writeByte(CodeBlock.opPushConst | CodeBlock.dtByte); m_Code.writeByte(pc.m_Val); size += 1 + 1; }
								else if (sl[i] == 3) { m_Code.writeByte(CodeBlock.opPushConst | CodeBlock.dtWord); m_Code.writeShort(pc.m_Val); size += 1 + 2; }
								else if (sl[i] == 5) { m_Code.writeByte(CodeBlock.opPushConst | CodeBlock.dtDword); m_Code.writeUnsignedInt(pc.m_Val); size += 1 + 4; }
								else { error(); return false; }
								break;
							case CodeBlock.dtChar: 
							case CodeBlock.dtShort: 
							case CodeBlock.dtInt: 
								if (sl[i] == 2) { m_Code.writeByte(CodeBlock.opPushConst | CodeBlock.dtChar); m_Code.writeByte(pc.m_Val); size += 1 + 1; }
								else if (sl[i] == 3) { m_Code.writeByte(CodeBlock.opPushConst | CodeBlock.dtShort); m_Code.writeShort(pc.m_Val); size += 1 + 2; }
								else if (sl[i] == 5) { m_Code.writeByte(CodeBlock.opPushConst | CodeBlock.dtInt); m_Code.writeInt(pc.m_Val); size += 1 + 4; }
								else { error(); return false; }
								break;
							default: { error(); return false; }
						}
						break;

					case CodeBlock.opCallByName:
						m_Code.writeByte(op);
						m_Code.writeByte(pc.m_Val.length);
						m_Code.writeUTFBytes(pc.m_Val);
						size += 1 + 1 + pc.m_Val.length;
						break;

					case CodeBlock.opCallByNum:
						if (sl[i] == 2) { m_Code.writeByte(CodeBlock.opCallByNum | 0 | ((pc.m_Val & 0x80000000)?0x8:0)); m_Code.writeByte(op & 0xf); size += 1 + 1; }
						else if (sl[i] == 3) { m_Code.writeByte(CodeBlock.opCallByNum | 1 | ((pc.m_Val & 0x80000000)?0x8:0)); m_Code.writeByte(op & 0xf); m_Code.writeByte(pc.m_Val & (~0x80000000)); size += 1 + 1 + 1; }
						else if (sl[i] == 4) { m_Code.writeByte(CodeBlock.opCallByNum | 2 | ((pc.m_Val & 0x80000000)?0x8:0)); m_Code.writeByte(op & 0xf); m_Code.writeShort(pc.m_Val & (~0x80000000)); size += 1 + 1 + 2; }
						else if (sl[i] == 6) { m_Code.writeByte(CodeBlock.opCallByNum | 3 | ((pc.m_Val & 0x80000000)?0x8:0)); m_Code.writeByte(op & 0xf); m_Code.writeUnsignedInt(pc.m_Val & (~0x80000000)); size += 1 + 1 + 4; }
						else { error(); return false; }
						break;

					case CodeBlock.opJump:
						for (u = 0; u < m_Pc.length; u++) {
							if (m_Pc[u].m_Op != CodePc.opsLabel) continue;
							if (m_Pc[u].m_Val != pc.m_Val) continue;
							break;
						}
						if (u >= m_Pc.length) { error(); return false; }
						if (u == i) { error(); return false; }

						if (u < i) {
							off = 0;
							while (u < i) {
								if (m_Pc[u].m_Op == CodePc.opsLabel) { }
								else if (sl[u] == 0) break;
								else off += sl[u];
								u++;
							}
							if (u < i) { error(); return false; }
							if (sl[i] == 2) {
								off = -(off + 2);
								if (off < -128) { error(); return false; }
								m_Code.writeByte(op & (~jmpLong));
								m_Code.writeByte(off);
								size += 2;
							}
							else if (sl[i] == 3) { 
								off = -(off + 3); 
								if (off < -32768) { error(); return false; }
								m_Code.writeByte(op | jmpLong);
								m_Code.writeShort(off);
								size += 3;
							}
							else { error(); return false; }
						} else {
							k = i + 1;
							off = 0;
							while (k < u) {
								if (m_Pc[k].m_Op == CodePc.opsLabel) { }
								else if (sl[k] == 0) break;
								else off += sl[k];
								k++;
							}
							if (k < u) { error(); return false; }
							if (sl[i] == 2) {
								if (off > 127) { error(); return false; }
								m_Code.writeByte(op & (~jmpLong));
								m_Code.writeByte(off);
								size += 2;
							}
							else if (sl[i] == 3) { 
								if (off > 32767) { error(); return false; }
								m_Code.writeByte(op | jmpLong);
								m_Code.writeShort(off);
								size += 3;
							}
							else { error(); return false; }
						}
						break;

					case CodeBlock.opDesc:
					case CodeBlock.opDescFor:
						m_Code.writeByte(op);
						switch(op & 3) {
							case 0: size += 1; break;
							case 1: m_Code.writeByte(pc.m_Val); size += 1 + 1; break;
							case 2: m_Code.writeShort(pc.m_Val); size += 1 + 2; break;
							case 3: m_Code.writeUnsignedInt(pc.m_Val); size += 1 + 4; break;
						}
						change = true;
						break;

					case CodeBlock.opPushLocal:
					case CodeBlock.opAssumeLocal:
						if (sl[i] == 1) { m_Code.writeByte((op & 0xf0) | 8 | (pc.m_Val + 4)); size += 1; }
						else if (sl[i] == 2) { m_Code.writeByte((op & 0xf0) | 1); m_Code.writeByte(pc.m_Val); size += 1 + 1; }
						else if (sl[i] == 3) { m_Code.writeByte((op & 0xf0) | 2); m_Code.writeShort(pc.m_Val); size += 1 + 2; }
						else if (sl[i] == 4) { m_Code.writeByte((op & 0xf0) | 3); m_Code.writeInt(pc.m_Val); size += 1 + 4; }
						change = true;
						break;

					case CodeBlock.opPushVarByNum:
					case CodeBlock.opAssumeVarByNum:
						if (sl[i] == 1) { m_Code.writeByte((op & 0xf0) | 8 | (pc.m_Val)); size += 1; }
						else if (sl[i] == 2) { m_Code.writeByte((op & 0xf0) | 1); m_Code.writeByte(pc.m_Val); size += 1 + 1; }
						else if (sl[i] == 3) { m_Code.writeByte((op & 0xf0) | 2); m_Code.writeShort(pc.m_Val); size += 1 + 2; }
						else if (sl[i] == 4) { m_Code.writeByte((op & 0xf0) | 3); m_Code.writeInt(pc.m_Val); size += 1 + 4; }
						change = true;
						break;

					default: { error(); return false; }
				}
			} else {
				switch(op) {
					case CodeBlock.opPushVarByName:
					case CodeBlock.opAssumeVarByName:
					case CodeBlock.opPushMemberVarByName:
					case CodeBlock.opReplaceMemberVarByName:
					case CodeBlock.opAssumeMemberVarByName:
						m_Code.writeByte(op);
						m_Code.writeByte(pc.m_Val.length);
						m_Code.writeUTFBytes(pc.m_Val);
						size += 1 + 1 + pc.m_Val.length;
						break;

					case CodeBlock.opPushConstStr:
						m_Code.writeByte(op);
						u = SaveStr(pc.m_Val, m_Code);
						if (u < 0) { error(); return false; }
						size += 1 + 2 + u + 1;
						break;

					case CodeBlock.opNop:
					case CodeBlock.opWait:
					case CodeBlock.opPlus:
					case CodeBlock.opMinus:
					case CodeBlock.opNot:
					case CodeBlock.opBoolNot:
					case CodeBlock.opBool:
					case CodeBlock.opAdd:
					case CodeBlock.opSub:
					case CodeBlock.opAnd:
					case CodeBlock.opOr:
					case CodeBlock.opXor:
					case CodeBlock.opShl:
					case CodeBlock.opShr:
					case CodeBlock.opMul:
					case CodeBlock.opDiv:
					case CodeBlock.opMod:
					case CodeBlock.opBoolOr:
					case CodeBlock.opBoolAnd:
					case CodeBlock.opLess:
					case CodeBlock.opMore:
					case CodeBlock.opEqual:
					case CodeBlock.opNotEqual:
					case CodeBlock.opLessEqual:
					case CodeBlock.opMoreEqual:
						m_Code.writeByte(op);
						size += 1;
						break;

					default: { error(); return false; }
				}	
			}
		}

		// Проверяем правильно ли рассчитан размер
		if (m_Code.length != size) { error(); return false; }
		for (i = 0; i < sl.length; i++) size-= sl[i];
		if(size!=0) { error(); return false; }

		return true;
	}
	
	public function extractConstFromPc(dt:uint, pc:CodePc):*
	{
		var v:*= undefined;

		if ((pc.m_Op & 0xf0) == opPushDef) {
			switch(pc.m_Op & 15) {
				case defZero: v = 0; break;
				case defOne: v = 1; break;
				case defTwo: v = 2; break;
				case defTen: v = 10; break;
				case defMOne: v = -1; break;
				case defMTwo: v = -2; break;
				case defMTen: v = -10; break;
				case defNull: v = null; break;
				case defUndefined: v = undefined; break;
				case defTrue: v = true; break;
				case defFalse: v = false; break;
			}
		} else if ((pc.m_Op & 0xf0) == opPushConst) {
			v = pc.m_Val;
		}

		if (dt == dtByte || dt == dtWord || dt == dtDword) v = uint(v);
		else if (dt == dtChar || dt == dtShort || dt == dtInt) v = int(v);
		else if (dt == dtBool) v = Boolean(v);
		else if (dt == dtString) v = String(v);
		else if (dt == dtFloat || dt == dtDouble) v = Number(v);

		return v;
	}
	
	public function extractConst(dt:uint):*
	{
		var v:*=undefined;
		var i:int;
		var pc:CodePc;
		for (i = 0; i < m_Pc.length; i++) {
			pc = m_Pc[i];
			if ((pc.m_Op & 0xf0) == opPushDef) { v = extractConstFromPc(dt, pc); }
			else if ((pc.m_Op & 0xf0) == opPushConst) { v = extractConstFromPc(dt, pc); }
			else if ((pc.m_Op & 0xf0) == opDesc) { }
			else if ((pc.m_Op & 0xf0) == opDescFor) { }
			else return undefined;
		}
		return v;
	}
	
	public static function saveConstToPc(pc:CodePc, dt:uint, v:*):Boolean
	{
		if (dt == dtByte || dt == dtWord || dt == dtDword) v = uint(v);
		else if (dt == dtChar || dt == dtShort || dt == dtInt) v = int(v);
		else if (dt == dtBool) v = Boolean(v);
		else if (dt == dtString) v = String(v);
		else if (dt == dtFloat || dt == dtDouble) v = Number(v);

		if (v is Number) {
			if (v == 0) { pc.m_Op = opPushDef | defZero; pc.m_Val = undefined; }
			else if (v == 1) { pc.m_Op = opPushDef | defOne; pc.m_Val = undefined; }
			else if (v == 2) { pc.m_Op = opPushDef | defTwo; pc.m_Val = undefined; }
			else if (v == 10) { pc.m_Op = opPushDef | defTen; pc.m_Val = undefined; }
			else if (v == -1) { pc.m_Op = opPushDef | defMOne; pc.m_Val = undefined; }
			else if (v == -2) { pc.m_Op = opPushDef | defMTwo; pc.m_Val = undefined; }
			else if (v == -10) { pc.m_Op = opPushDef | defMTen; pc.m_Val = undefined; }
			else { pc.m_Op = opPushConst | dt; pc.m_Val = v; }
		} else if (v is Boolean) {
			if (v) { pc.m_Op = opPushDef | defTrue; pc.m_Val = undefined; }
			else { pc.m_Op = opPushDef | defFalse; pc.m_Val = undefined; }
		} else if (v == null) {
			pc.m_Op = opPushDef | defNull; pc.m_Val = undefined;
		} else if (v == undefined) {
			pc.m_Op = opPushDef | defUndefined; pc.m_Val = undefined;
		} else return false;
		return true;
	}
	
	public function labelFind(key:int):int
	{
		var i:int;
		var pc:CodePc;
		for (i = 0; i < m_Pc.length; i++) {
			if (m_Pc[i].m_Op == CodePc.opsLabel && m_Pc[i].m_Val == key) return i;
		}
		return -1;
	}
	
	public function optimizerJmp():Boolean
	{
		var ret:Boolean = false;
		var i:int, u:int, k:int;
		var pc:CodePc, pc2:CodePc;

		if (m_Pc == null) return false;

		// переадресуем пустые переходы
		for (i = 0; i < m_Pc.length; i++) {
			pc = m_Pc[i];
			if ((pc.m_Op & 0xf0) != opJump) continue;

			u = labelFind(pc.m_Val);
			k = u;
			for (; u >= 0 && k < m_Pc.length && u != i; k++) {
				pc2 = m_Pc[k];
				if (pc2.m_Op == CodePc.opsLabel) continue;
				if ((pc2.m_Op & 0xf0) != opJump) break;
				if ((pc2.m_Op & jmpMask) != jmpGoTo) break;
				u = labelFind(pc2.m_Val);
				k = u;
			}

			if (u >= 0 && pc.m_Val != m_Pc[u].m_Val) {
				pc.m_Val = m_Pc[u].m_Val;
				ret = true;
			}
		}

		// удаляем переходы на следующую инструкцию
		for (i = m_Pc.length - 1; i >= 0; i--) {
			pc = m_Pc[i];
			if ((pc.m_Op & 0xf0) != opJump) continue;
			u = labelFind(pc.m_Val);
			if (u <= i) continue;

			for (k = i + 1; k < u; k++) {
				pc2 = m_Pc[k];
				if (pc2.m_Op == CodePc.opsLabel) continue;
				break;
			}
			if (k < u) continue;
			
			m_Pc.splice(i, 1);
			ret = true;
		}

		// удаляем неиспользуемые метки
		for (i = m_Pc.length - 1; i >= 0; i--) {
			pc = m_Pc[i];
			if (pc.m_Op != CodePc.opsLabel) continue;
			
			for (u = 0; u < m_Pc.length; u++) {
				pc2 = m_Pc[u];
				if ((pc2.m_Op & 0xf0) != opJump) continue;
				if (pc.m_Val != pc2.m_Val) continue;
				break;
			}
			if (u < m_Pc.length) continue;
			
			m_Pc.splice(i, 1);
			ret = true;
		}
		
		// если перед переходом идет сразу же простой переход то удаляем его
		for (i = m_Pc.length - 1; i >= 1; i--) {
			pc = m_Pc[i];
			if ((pc.m_Op & 0xf0) != opJump) continue;
			
			pc2 = m_Pc[i - 1];
			if ((pc2.m_Op & 0xf0) != opJump) continue;
			if ((pc2.m_Op & jmpMask) != jmpGoTo) continue;
			
			m_Pc.splice(i, 1);
			ret = true;
		}
		
		return ret;
	}

	public function optimizerExp():Boolean
	{
		var ret:Boolean = false;
		var i:int;
		var pc:CodePc;
		var pc2:CodePc;
		var op:uint;
		var v1:*;
		var v2:*;

		if (m_Pc == null) return false;

		for (i = 0; i < m_Pc.length; i++) {
			pc = m_Pc[i];
			op = pc.m_Op;

			if (op & 0xc0) {
				switch(op & 0xf0) {
					default: break;
				}
			} else {
				switch(op) {
					case CodeBlock.opMinus:
					case CodeBlock.opPlus:
					case CodeBlock.opBool:
					case CodeBlock.opBoolNot:
					case CodeBlock.opNot:
						if (i < 1) break;
						pc2 = m_Pc[i - 1];
						if ((pc2.m_Op & 0xf0) == opPushDef) {
							if ((pc2.m_Op & 15) == defZero) v1 = 0;
							else if ((pc2.m_Op & 15) == defOne) v1 = 1;
							else if ((pc2.m_Op & 15) == defTwo) v1 = 2;
							else if ((pc2.m_Op & 15) == defTen) v1 = 10;
							else if ((pc2.m_Op & 15) == defMOne) v1 = -1;
							else if ((pc2.m_Op & 15) == defMTwo) v1 = -2;
							else if ((pc2.m_Op & 15) == defMTen) v1 = -10;
							else if ((pc2.m_Op & 15) == defNull) v1 = null;
							else if ((pc2.m_Op & 15) == defUndefined) v1 = undefined;
							else if ((pc2.m_Op & 15) == defTrue) v1 = true;
							else if ((pc2.m_Op & 15) == defFalse) v1 = false;
							else break;

						} else if ((pc2.m_Op & 0xf0) == opPushConst) {
							v1 = pc2.m_Val;

						} else if ((pc2.m_Op & 0xf0) == opPushConstStr) {
							v1 = pc2.m_Val;

						} else break;

						switch(op) {
							case CodeBlock.opMinus: v1 = -v1; break;
							case CodeBlock.opPlus: v1 = +v1; break;
							case CodeBlock.opBool: v1 = Boolean(v1); break;
							case CodeBlock.opBoolNot:  v1 = !v1; break;
							case CodeBlock.opNot:  v1 = ~v1; break;
						}

						if (v1 is Number) {
							if (v1 == 0) { pc2.m_Op = opPushDef | defZero; pc2.m_Val = undefined; }
							else if (v1 == 1) { pc2.m_Op = opPushDef | defOne; pc2.m_Val = undefined; }
							else if (v1 == 2) { pc2.m_Op = opPushDef | defTwo; pc2.m_Val = undefined; }
							else if (v1 == 10) { pc2.m_Op = opPushDef | defTen; pc2.m_Val = undefined; }
							else if (v1 == -1) { pc2.m_Op = opPushDef | defMOne; pc2.m_Val = undefined; }
							else if (v1 == -2) { pc2.m_Op = opPushDef | defMTwo; pc2.m_Val = undefined; }
							else if (v1 == -10) { pc2.m_Op = opPushDef | defMTen; pc2.m_Val = undefined; }
							else if ((pc2.m_Op & 0xf0) == opPushDef) { pc2.m_Op = opPushConst | dtInt; pc2.m_Val = v1; }
							else if ((pc2.m_Op & 0xf0) == opPushConst) pc2.m_Val = v1;
							else break;
						} else if (v1 is Boolean) {
							if (v1) { pc2.m_Op = opPushDef | defTrue; pc2.m_Val = undefined; }
							else { pc2.m_Op = opPushDef | defFalse; pc2.m_Val = undefined; }
						} else if (v1 is String) {
							pc2.m_Op = opPushConstStr; pc2.m_Val = v1;
						} else if (v1 == null) {
							pc2.m_Op = opPushDef | defNull; pc2.m_Val = undefined;
						} else if (v1 == null) {
							pc2.m_Op = opPushDef | defUndefined; pc2.m_Val = undefined;
						} else break;
						
						ret = true;
						m_Pc.splice(i, 1);
						i -= 1;
						break;

					case CodeBlock.opAdd:
					case CodeBlock.opSub:
					case CodeBlock.opAnd:
					case CodeBlock.opOr:
					case CodeBlock.opXor:
					case CodeBlock.opShl:
					case CodeBlock.opShr:
					case CodeBlock.opMul:
					case CodeBlock.opDiv:
					case CodeBlock.opMod:
					case CodeBlock.opBoolOr:
					case CodeBlock.opBoolAnd:
					case CodeBlock.opLess:
					case CodeBlock.opMore:
					case CodeBlock.opEqual:
					case CodeBlock.opNotEqual:
					case CodeBlock.opLessEqual:
					case CodeBlock.opMoreEqual:
						if (i < 2) break;
						pc2 = m_Pc[i - 2];
						if ((pc2.m_Op & 0xf0) == opPushDef) {
							if ((pc2.m_Op & 15) == defZero) v1 = 0;
							else if ((pc2.m_Op & 15) == defOne) v1 = 1;
							else if ((pc2.m_Op & 15) == defTwo) v1 = 2;
							else if ((pc2.m_Op & 15) == defTen) v1 = 10;
							else if ((pc2.m_Op & 15) == defMOne) v1 = -1;
							else if ((pc2.m_Op & 15) == defMTwo) v1 = -2;
							else if ((pc2.m_Op & 15) == defMTen) v1 = -10;
							else if ((pc2.m_Op & 15) == defNull) v1 = null;
							else if ((pc2.m_Op & 15) == defUndefined) v1 = undefined;
							else if ((pc2.m_Op & 15) == defTrue) v1 = true;
							else if ((pc2.m_Op & 15) == defFalse) v1 = false;
							else break;
							
						} else if ((pc2.m_Op & 0xf0) == opPushConst) {
							v1 = pc2.m_Val;
							
						} else if (pc2.m_Op == opPushConstStr) {
							v1 = pc2.m_Val;
							
						} else break;

						pc2 = m_Pc[i - 1];
						if ((pc2.m_Op & 0xf0) == opPushDef) {
							if ((pc2.m_Op & 15) == defZero) v2 = 0;
							else if ((pc2.m_Op & 15) == defOne) v2 = 1;
							else if ((pc2.m_Op & 15) == defTwo) v2 = 2;
							else if ((pc2.m_Op & 15) == defTen) v2 = 10;
							else if ((pc2.m_Op & 15) == defMOne) v2 = -1;
							else if ((pc2.m_Op & 15) == defMTwo) v2 = -2;
							else if ((pc2.m_Op & 15) == defMTen) v2 = -10;
							else if ((pc2.m_Op & 15) == defNull) v2 = null;
							else if ((pc2.m_Op & 15) == defUndefined) v2 = undefined;
							else if ((pc2.m_Op & 15) == defTrue) v2 = true;
							else if ((pc2.m_Op & 15) == defFalse) v2 = false;
							else break;
							
						} else if ((pc2.m_Op & 0xf0) == opPushConst) {
							v2 = pc2.m_Val;

						} else if (pc2.m_Op == opPushConstStr) {
							v2 = pc2.m_Val;

						} else break;
						
						switch(op) {
							case CodeBlock.opAdd: v1 = v1 + v2; break;
							case CodeBlock.opSub: v1 = v1 - v2; break;
							case CodeBlock.opAnd: v1 = v1 & v2; break;
							case CodeBlock.opOr: v1 = v1 | v2; break;
							case CodeBlock.opXor: v1 = v1 ^ v2; break;
							case CodeBlock.opShl: v1 = v1 << v2; break;
							case CodeBlock.opShr: v1 = v1 >> v2; break;
							case CodeBlock.opMul: v1 = v1 * v2; break;
							case CodeBlock.opDiv: v1 = v1 / v2; break;
							case CodeBlock.opMod: v1 = v1 % v2; break;
							case CodeBlock.opBoolOr: v1 = v1 || v2; break;
							case CodeBlock.opBoolAnd: v1 = v1 && v2; break;
							case CodeBlock.opLess: v1 = v1 < v2; break;
							case CodeBlock.opMore: v1 = v1 > v2; break;
							case CodeBlock.opEqual: v1 = v1 == v2; break;
							case CodeBlock.opNotEqual: v1 = v1 != v2; break;
							case CodeBlock.opLessEqual: v1 = v1 <= v2; break;
							case CodeBlock.opMoreEqual: v1 = v1 >= v2; break;
						}
						
						pc2 = m_Pc[i - 2];
						if (v1 is Number) {
							if (v1 == 0) { pc2.m_Op = opPushDef | defZero; pc2.m_Val = undefined; }
							else if (v1 == 1) { pc2.m_Op = opPushDef | defOne; pc2.m_Val = undefined; }
							else if (v1 == 2) { pc2.m_Op = opPushDef | defTwo; pc2.m_Val = undefined; }
							else if (v1 == 10) { pc2.m_Op = opPushDef | defTen; pc2.m_Val = undefined; }
							else if (v1 == -1) { pc2.m_Op = opPushDef | defMOne; pc2.m_Val = undefined; }
							else if (v1 == -2) { pc2.m_Op = opPushDef | defMTwo; pc2.m_Val = undefined; }
							else if (v1 == -10) { pc2.m_Op = opPushDef | defMTen; pc2.m_Val = undefined; }
							else if ((pc2.m_Op & 0xf0) == opPushDef) { pc2.m_Op = opPushConst | dtInt; pc2.m_Val = v1; }
							else if ((pc2.m_Op & 0xf0) == opPushConst) pc2.m_Val = v1;
							else break;
						} else if (v1 is Boolean) {
							if (v1) { pc2.m_Op = opPushDef | defTrue; pc2.m_Val = undefined; }
							else { pc2.m_Op = opPushDef | defFalse; pc2.m_Val = undefined; }
						} else if (v1 is String) {
							pc2.m_Op = opPushConstStr; pc2.m_Val = v1;
						} else if (v1 == null) {
							pc2.m_Op = opPushDef | defNull; pc2.m_Val = undefined;
						} else if (v1 == undefined) {
							pc2.m_Op = opPushDef | defUndefined; pc2.m_Val = undefined;
						} else break;
						
						ret = true;
						m_Pc.splice(i - 1, 2);
						i -= 2;
						break;

					default: break;
				}
			}
		}

		return ret;
	}

	public function print(sp:String = ""):String
	{
		var i:int, u:int, l:int, k:int, len:int;
		var v:int;
		var op:uint;
		var dw:uint;
		var adr:int, off:int;
		var fl:Boolean;
		var pc:CodePc;
		var out:String = "";
		
		if (m_Pc == null || m_Pc.length <= 0) return "empty";

		for (k = 0; k < m_Pc.length; k++) {
			pc = m_Pc[k];
			op = pc.m_Op;

			out += sp;
				
			if (op == CodePc.opsLabel) {
				if (pc.m_Val < 10) out += "@00" + pc.m_Val.toString() + ": ";
				else if (pc.m_Val < 100) out += "@0" + pc.m_Val.toString() + ": ";
				else out += "@" + pc.m_Val.toString() + ": ";
				out += "\n";
				continue;
			} else {
				out += "      ";
			}
			
			if (op & 0xc0) {
				switch(op & 0xf0) {
					case CodeBlock.opPushDef:
						switch(op & 15) {
							case defZero: out += "push const(zero)"; break;
							case defOne: out += "push const(one)"; break;
							case defTwo: out += "push const(two)"; break;
							case defTen: out += "push const(ten)"; break;
							case defMOne: out += "push const(-one)"; break;
							case defMTwo: out += "push const(-two)"; break;
							case defMTen: out += "push const(-ten)"; break;
							case defNull: out += "push const(null)"; break;
							case defUndefined: out += "push const(undefined)"; break;
							case defTrue: out += "push const(true)"; break;
							case defFalse: out += "push const(false)"; break;
							default: out += "push const(unknown)"; break;
						}
						break;

					case CodeBlock.opPushConst:
						switch(op & 15) {
							case dtByte: dw = pc.m_Val; out += "push " + dw.toString(10) + " (0x" + dw.toString(16) + ")"; break;
							case dtWord: dw = pc.m_Val; out += "push " + dw.toString(10) + " (0x" + dw.toString(16) + ")"; break;
							case dtDword: dw = pc.m_Val; out += "push " + dw.toString(10) + " (0x" + dw.toString(16) + ")"; break;
							case dtChar: v = pc.m_Val; out += "push " + v.toString(10) + ""; break;
							case dtShort: v = pc.m_Val; out += "push " + v.toString(10) + ""; break;
							case dtInt: v = pc.m_Val; out += "push " + v.toString(10) + ""; break;
							default: out += "push unknown"; return out;
						}
						break;

					case CodeBlock.opCallByName:
						op &= 15;
						out += "call " + pc.m_Val +" arg:" + op.toString();
						break;

					case CodeBlock.opCallByNum:
						op &= 15;
						out += "call_num " + pc.m_Val +" arg:" + op.toString();
						break;

					case CodeBlock.opDesc:
						v = pc.m_Val;
						switch(op & descMask) {
							case descSimple: out += "---line_exp " + v.toString(); break;
							case descIf: out += "---line_if " + v.toString(); break;
							case descElseIf: out += "---line_elseif " + v.toString(); break;
							case descElse: out += "---line_else " + v.toString(); break;
						}
						break;
						
					case CodeBlock.opDescFor:
						v = pc.m_Val;
						switch(op & descMask) {
							case descForInit: out += "---line_for_init " + v.toString(); break;
							case descForIf: out += "---line_for_if " + v.toString(); break;
							case descForInc: out += "---line_for_inc " + v.toString(); break;
							case descWhile: out += "---line_while " + v.toString(); break;
						}
						break;
						
					case CodeBlock.opJump:
						switch(op & 0xe) {
							case jmpGoTo: out += "goto"; break;
							case jmpIf: out += "if"; break;
							case jmpIfNot: out += "if_not"; break;
							default: out += "jump_unknown"; break;
						}
						v = pc.m_Val;
						if (v < 10) out += " @00" + v.toString();
						else if (v < 100) out += " @0" + v.toString();
						else out += " @" + v.toString();
						break;

					case CodeBlock.opPushLocal:
						out += "push_local " + (pc.m_Val).toString();
						break;

					case CodeBlock.opAssumeLocal:
						out += "assume_local " + (pc.m_Val).toString();
						break;

					case CodeBlock.opPushVarByNum:
						out += "push_var " + (pc.m_Val).toString();
						break;

					case CodeBlock.opAssumeVarByNum:
						out += "assume_var " + (pc.m_Val).toString();
						break;

					case CodeBlock.opAssumeLocal:

					default: out += "op unknown 0x" + op.toString(16); return out;
				}
			} else {
				switch(op) {
					case CodeBlock.opAssumeVarByName:
						out += "assume_name " + pc.m_Val + "";
						break;
						
					case CodeBlock.opPushVarByName:
						out += "push_name " + pc.m_Val + "";
						break;

					case CodeBlock.opAssumeMemberVarByName:
						out += "assume_name ." + pc.m_Val + "";
						break;
						
					case CodeBlock.opPushMemberVarByName:
						out += "push_name ." + pc.m_Val + "";
						break;

					case CodeBlock.opReplaceMemberVarByName:
						out += "replace_name ." + pc.m_Val + "";
						break;

					case CodeBlock.opPushConstStr:
						out += 'push const ("' + pc.m_Val + '")';
						break;

					case CodeBlock.opNop: out += "nop"; break;
					case CodeBlock.opWait: out += "wait"; break;
					case CodeBlock.opMinus: out += "minus"; break;
					case CodeBlock.opPlus: out += "plus"; break;
					case CodeBlock.opBool: out += "bool"; break;
					case CodeBlock.opBoolNot: out += "bool_not"; break;
					case CodeBlock.opNot: out += "not"; break;
					case CodeBlock.opAdd: out += "add"; break;
					case CodeBlock.opSub: out += "sub"; break;
					case CodeBlock.opAnd: out += "and"; break;
					case CodeBlock.opOr: out += "or"; break;
					case CodeBlock.opXor: out += "xor"; break;
					case CodeBlock.opShl: out += "shl"; break;
					case CodeBlock.opShr: out += "shr"; break;
					case CodeBlock.opMul: out += "mul"; break;
					case CodeBlock.opDiv: out += "div"; break;
					case CodeBlock.opMod: out += "mod"; break;
					case CodeBlock.opBoolOr: out += "bool_or"; break;
					case CodeBlock.opBoolAnd: out += "bool_and"; break;
					case CodeBlock.opLess: out += "less"; break;
					case CodeBlock.opMore: out += "more"; break;
					case CodeBlock.opEqual: out += "equal"; break;
					case CodeBlock.opNotEqual: out += "not_equal"; break;
					case CodeBlock.opLessEqual: out += "less_equal"; break;
					case CodeBlock.opMoreEqual: out += "more_equal"; break;

					default: out += "op unknown 0x" + op.toString(16); return out;
				}
			}

			out += "\n";
		}
		return out;
	}
}
	
}