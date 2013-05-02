package Base
{
import flash.utils.*;

public class CodeCompiler
{
	public static const FlagFun:uint = 1 << 30;
	public static const FlagVar:uint = 1 << 29;
	public static const FlagArg:uint = 1 << 28;
	public static const FlagConst:uint = 1 << 27;
	public static const FlagStatic:uint = 1 << 26;
	public static const FlagClass:uint = 1 << 25;
	public static const FlagDefaultVal:uint = 1 << 24;
	public static const FlagEnv:uint = 1 << 23;

	public static const optPoint:uint = 999;
	public static const optAssume:uint = 1000;
	public static const optAssumeAdd:uint = 1001;
	public static const optAssumeSub:uint = 1002;
	public static const optAssumeAnd:uint = 1003;
	public static const optAssumeOr:uint = 1004;
	public static const optAssumeXor:uint = 1005;
	public static const optAssumeShl:uint = 1006;
	public static const optAssumeShr:uint = 1007;
	public static const optAssumeMul:uint = 1008;
	public static const optAssumeDiv:uint = 1009;
	public static const optAssumeMod:uint = 1010;
	public static const optAssume_end:uint = 1011;

	public var m_Parent:CodeCompiler = null; // Для FlagEnv: m_Parent может не содержать предка.
	public var m_Name:String = null;
	public var m_Flag:uint = 0;
	public var m_DataClassType:String = null;
	public var m_DataVal:*= undefined;
	public var m_Decl:Vector.<CodeCompiler> = null;
	public var m_Local:Dictionary = null;
	public var m_Num:int = 0;
	public var m_Block:CodeBlock = null;

	public var m_Src:CodeSrc = null;
	
	public var m_PrepareForRun:Boolean = false;
	public var m_LocalVarCnt:int = 0;
	public var m_ArgVarCnt:int = -1;
	
	private static const jmpOffTmp:int = -32768;
	private static const jmpOffEnd:int = -32767;
	private static const jmpOffBreak:int = -32766;
	private static const jmpOffReturn:int = -32765;

	private static var m_ParseConstStd:*;
	private static var m_ExpStack:Vector.<StackUnit> = null;
	private static var m_ExpStackLen:int = 0;
	private static var m_ExpPushCnt:int = 0;

	public static const ReservedKeyword:Array = ["wait", "true", "false", "null", "undefined", "if", "else", "for", "while", "do", "break", "continue", "return", "var", "function", "const", "static", "void", "byte", "char", "word", "short", "dword", "uint", "int", "qword", "long", "float", "double", "number", "bool", "boolean", "string", "object"];
	
	public function CodeCompiler(src:CodeSrc = null):void
	{
		m_Src = src;
	}

	public function get decl():Vector.<CodeCompiler>
	{
		if (m_Decl == null) m_Decl = new Vector.<CodeCompiler>();
		if (m_Local == null) m_Local = new Dictionary();
		return m_Decl;
	}
	
	public function declNew(name:String):CodeCompiler
	{
		var cc:CodeCompiler = new CodeCompiler();
		cc.m_Parent = this;
		cc.m_Name = name;
		decl.push(cc);
		m_Local[name] = cc;
		return cc;
	}
	
	public function declDel(name:String):void
	{
		if (m_Local == null) return;
		if (m_Local[name] == undefined) return;
		var cc:CodeCompiler = m_Local[name];
		var i:int = decl.indexOf(cc);
		if (i < 0) throw Error("");
		if (cc.m_Parent == this) cc.m_Parent = null;
		decl.splice(i, 1);
	}
	
	public function declAdd(name:String, cc:CodeCompiler):void
	{
		declDel(name);
		if (cc.m_Parent != null) throw Error("");
		cc.m_Parent = this;
		cc.m_Name = name;
		decl.push(cc);
		m_Local[name] = cc;
	}

	public function setEnv(name:String, env:CodeCompiler):void
	{
		var old:CodeCompiler = env.m_Parent;
		declAdd(name, env);
		env.m_Parent = old;
		env.m_Flag |= FlagEnv;
		env.m_Flag &= ~(FlagFun | FlagVar);
	}

	public function get isBlockEmpty():Boolean
	{
		if (m_Block == null) return true;
		return m_Block.isEmpty;
	}

	public function findDeclByName(name:String):int
	{
		if (m_Decl == null) return -1;
		var cc:CodeCompiler;
		var i:int;
		for (i = 0; i < m_Decl.length; i++) {
			cc = m_Decl[i];
			if (cc.m_Name == null) continue;
			if (cc.m_Name == name) return i;
		}
		return -1;
	}
	
	public function findEnvName(name:String, parent:Boolean = true):CodeCompiler
	{
		var cd:CodeCompiler;

		var cc:CodeCompiler = this;
		while (cc != null) {
			if (m_Local != null) {
				cd = m_Local[name];
				if (cd != null) return cd;
			}
			if (!parent) break;
			cc = cc.m_Parent;
		}

		var i:int;
		if(m_Decl!=null)
		for (i = 0; i < m_Decl.length; i++) {
			cc = m_Decl[i];
			if ((cc.m_Flag & FlagEnv) == 0) continue;
			cd = cc.findEnvName(name, false);
			if (cd != null) return cd;
		}

		return null;
	}

	public function ParseUnaryOperator():uint
	{
		var len:int = 0;
		var ch:int;

		ch = m_Src.pickChar();
		if (ch == 0) return 0;
		len++;

		var ret:uint = 0;
		if(ch==43) ret = CodeBlock.opPlus;
		else if (ch == 45) ret = CodeBlock.opMinus;
		else if (ch == 126) ret = CodeBlock.opNot;
		else if (ch == 33) ret = CodeBlock.opBoolNot;
		else return 0;

		m_Src.nextChar(len);

		return ret;
	}
	
	public function ParseBinaryOperator(pick:Boolean = false):uint
	{
		var len:int = 0;
		var ch:int, ch2:int;

		ch = m_Src.pickChar();
		if (ch == 0) return 0;
		len++;

		ch2 = m_Src.pickChar(1);

		var ret:uint = 0;
		if (ch == 43 && ch2 == 61) { ret = optAssumeAdd; len++; }
		else if (ch == 45 && ch2 == 61) { ret = optAssumeSub; len++; }
		else if (ch == 38 && ch2 == 61) { ret = optAssumeAnd; len++; }
		else if (ch == 124 && ch2 == 61) { ret = optAssumeOr; len++; }
		else if (ch == 94 && ch2 == 61) { ret = optAssumeXor; len++; }
		else if (ch == 42 && ch2 == 61) { ret = optAssumeMul; len++; }
		else if (ch == 47 && ch2 == 61) { ret = optAssumeDiv; len++; }
		else if (ch == 37 && ch2 == 61) { ret = optAssumeMod; len++; }
		else if (ch == 60 && ch2 == 60 && m_Src.pickChar(2) == 61) { ret = optAssumeShl; len += 2; }
		else if (ch == 62 && ch2 == 62 && m_Src.pickChar(2) == 61) { ret = optAssumeShr; len += 2; }
		else if (ch == 60 && ch2 == 60) { ret = CodeBlock.opShl; len++; }
		else if (ch == 62 && ch2 == 62) { ret = CodeBlock.opShr; len++; }
		else if (ch == 43) ret = CodeBlock.opAdd;
		else if (ch == 45) ret = CodeBlock.opSub;
		else if (ch == 124 && ch2 == 124) { ret = CodeBlock.opBoolOr; len++; }
		else if (ch == 124) ret = CodeBlock.opOr;
		else if (ch == 38 && ch2 == 38) { ret = CodeBlock.opBoolAnd; len++; }
		else if (ch == 94) ret = CodeBlock.opXor;
		else if (ch == 38) ret = CodeBlock.opAnd;
		else if (ch == 42) ret = CodeBlock.opMul;
		else if (ch == 47) ret = CodeBlock.opDiv;
		else if (ch == 37) ret = CodeBlock.opMod;
		else if (ch == 60 && ch2 == 61) { ret = CodeBlock.opLessEqual; len++; }
		else if (ch == 62 && ch2 == 61) { ret = CodeBlock.opMoreEqual; len++; }
		else if (ch == 61 && ch2 == 61) { ret = CodeBlock.opEqual; len++; }
		else if (ch == 33 && ch2 == 61) { ret = CodeBlock.opNotEqual; len++; }
		else if (ch == 61) ret = optAssume;
		else if (ch == 60) ret = CodeBlock.opLess;
		else if (ch == 62) ret = CodeBlock.opMore;
		else if (ch == 46) ret = optPoint;
		else return 0;

		if(!pick) m_Src.nextChar(len);

		return ret;
	}
	
	public function ParseConstString():String
	{
		var chopen:int = m_Src.pickChar();
		if (chopen != 34 && chopen != 39) return null;

		m_Src.nextChar();

		var ch:int, ch2:int;
		var str:String = "";

		while (true) {
			ch = m_Src.pickChar();
			if (ch == chopen) {
				m_Src.nextChar();
				return str;
			} else if (ch == 92) { 
				ch2 = m_Src.pickChar(1);
				if (ch2 == 110) { ch = 10; m_Src.nextChar(); } // \n
				else if (ch2 == 114) { ch = 13; m_Src.nextChar(); } // \r
				else if (ch2 == 116) { ch = 9; m_Src.nextChar(); } // \t
				else if (ch2 == 34) { ch = 34; m_Src.nextChar(); } // "
				else if (ch2 == 39) { ch = 39; m_Src.nextChar(); } // '
			}
			str += String.fromCharCode(ch);
			m_Src.nextChar();
		}
		return null;
	}
	
	public function ParseConstStd(unaryop:uint = 0):uint
	{
		var len:int = 0;
		var ch:int;

		m_ParseConstStd = undefined;

		var hex:Boolean = false;
		var bin:Boolean = false;
		var sign:Boolean = false;
		
		var kw:String = m_Src.pickWord();
		if (kw == "true") {
			m_Src.skipWord();
			m_ParseConstStd = true;
			return CodeBlock.dtBool;

		} else if (kw == "false") {
			m_Src.skipWord();
			m_ParseConstStd = false;
			return CodeBlock.dtBool;
			
		} else if (kw == "null") {
			m_Src.skipWord();
			m_ParseConstStd = null;
			return CodeBlock.dtObject;

		} else if (kw == "undefined") {
			m_Src.skipWord();
			m_ParseConstStd = undefined;
			return CodeBlock.dtObject;
		}
		
		m_ParseConstStd = uint(0);

		if (!unaryop && m_Src.pickChar(len) == 45) {
			sign = true;
			len++;
		}

		if (m_Src.pickChar(len) == 48 && m_Src.pickChar(len + 1) == 120) { // x
			hex = true;
			len += 2;

		} else if (m_Src.pickChar(len) == 48 && m_Src.pickChar(len + 1) == 98) { // b
			bin = true;
			len += 2;
		}

		var cnt:int = 0;
		if (bin) {
			while (true) {
				ch = m_Src.pickChar(len);
				if (!ch) break;
				if (ch >= 48 && ch <= 49) m_ParseConstStd = (m_ParseConstStd << 1) + (ch - 48);
				else break;
				len++;
				cnt++;
			}
		} else if(hex) {
			while (true) {
				ch = m_Src.pickChar(len);
				if (!ch) break;
				if (ch >= 48 && ch <= 57) m_ParseConstStd = (m_ParseConstStd << 4) + (ch - 48);
				else if (ch >= 65 && ch <= 70) m_ParseConstStd = (m_ParseConstStd << 4) + (ch - 65 + 10);
				else if (ch >= 97 && ch <= 102) m_ParseConstStd = (m_ParseConstStd << 4) + (ch - 97 + 10);
				else break;
				len++;
				cnt++;
			}
 		} else {
			while (true) {
				ch = m_Src.pickChar(len);
				if (!ch) break;
				if ((sign || unaryop == CodeBlock.opMinus) && ch >= 48 && ch <= 57) m_ParseConstStd = uint(int(m_ParseConstStd) * 10 + (ch - 48));
				else if (ch >= 48 && ch <= 57) m_ParseConstStd = m_ParseConstStd * 10 + (ch - 48);
				else break;
				len++;
				cnt++;
			}
		}
		if (cnt <= 0) return 0;

		if (unaryop == CodeBlock.opMinus) m_ParseConstStd = uint( -int(m_ParseConstStd));
		else if (unaryop == CodeBlock.opPlus) {}
		else if (unaryop == CodeBlock.opBool) m_ParseConstStd = (m_ParseConstStd != 0)?1:0;
		else if (unaryop == CodeBlock.opBoolNot) m_ParseConstStd = (m_ParseConstStd != 0)?0:1;
		else if (unaryop == CodeBlock.opNot) m_ParseConstStd = ~m_ParseConstStd;
		else if (sign) m_ParseConstStd |= 0x80000000;
		
		m_Src.nextChar(len);

		if (unaryop == CodeBlock.opMinus || sign) {
			var v:int = m_ParseConstStd;
			if (v >= -128 && v <= 127) return CodeBlock.dtChar;
			else if (v >= -32768 && v <= 32767) return CodeBlock.dtShort;
			else return CodeBlock.dtInt;
		} else {
			if (m_ParseConstStd <= 255) return CodeBlock.dtByte;
			else if (m_ParseConstStd <= 65535) return CodeBlock.dtWord;
			else return CodeBlock.dtDword;
		}
	}
	
	public function OperatorPrior(op:uint):int
	{
		switch(op) {
			case optPoint: return 2;
			
			case CodeBlock.opMinus: return 3;
			case CodeBlock.opPlus: return 3;
			case CodeBlock.opBool: return 3;
			case CodeBlock.opBoolNot: return 3;
			case CodeBlock.opNot: return 3;
			
			case CodeBlock.opMul: return 5;
			case CodeBlock.opDiv: return 5;
			case CodeBlock.opMod: return 5;

			case CodeBlock.opSub: return 6;
			case CodeBlock.opAdd: return 6;

			case CodeBlock.opShl: return 7;
			case CodeBlock.opShr: return 7;

			case CodeBlock.opLess: return 8;
			case CodeBlock.opMore: return 8;
			case CodeBlock.opLessEqual: return 8;
			case CodeBlock.opMoreEqual: return 8;

			case CodeBlock.opEqual: return 9;
			case CodeBlock.opNotEqual: return 9;

			case CodeBlock.opAnd: return 10;
			case CodeBlock.opXor: return 11;
			case CodeBlock.opOr: return 12;

			case CodeBlock.opBoolAnd: return 13;
			case CodeBlock.opBoolOr: return 14;

			case optAssume: return 16;
			case optAssumeMul: return 16;
			case optAssumeDiv: return 16;
			case optAssumeMod: return 16;
			case optAssumeAdd: return 16;
			case optAssumeSub: return 16;
			case optAssumeShl: return 16;
			case optAssumeShr: return 16;
			case optAssumeAnd: return 16;
			case optAssumeOr: return 16;
			case optAssumeXor: return 16;
		}
		return -1;
	}
	
	public function IsAssume(op:uint):Boolean
	{
		return (op >= optAssume) && (op < optAssume_end);
	}
	
	public function IsRightOperator(op:uint):Boolean // OperatorRightAssociativity
	{
		switch(op) {
			case optAssume: return true;
			case optAssumeMul: return true;
			case optAssumeDiv: return true;
			case optAssumeMod: return true;
			case optAssumeAdd: return true;
			case optAssumeSub: return true;
			case optAssumeShl: return true;
			case optAssumeShr: return true;
			case optAssumeAnd: return true;
			case optAssumeOr: return true;
			case optAssumeXor: return true;
		}
		return false;
	}

	public function IsUnaryOperator(op:uint):Boolean
	{
		switch(op) {
			case CodeBlock.opMinus: return true;
			case CodeBlock.opPlus: return true;
			case CodeBlock.opBool: return true;
			case CodeBlock.opBoolNot: return true;
			case CodeBlock.opNot: return true;
		}
		return false;
	}

	public function ESPush(op:int, val:int = 0, name:String = null):void
	{
		if (m_ExpStackLen >= m_ExpStack.length) {
			for (var i:int = 0; i < 16; i++) m_ExpStack.push(new StackUnit());
		}
		var su:StackUnit = m_ExpStack[m_ExpStackLen];
		su.m_Op = op;
		su.m_Val = val;
		su.m_Name = name;
		m_ExpStackLen++;
	}

	public function ESPop():void
	{
		if (m_ExpStackLen <= 0) return;
		m_ExpStackLen--;
	}

	public function Word2DataType(kw:String, access:uint):int
	{
		if (kw == null) return -1;
		else if ((access & (1 << CodeBlock.dtNone)) != 0 && kw == "void") return CodeBlock.dtNone;
		else if ((access & (1 << CodeBlock.dtByte)) != 0 && kw == "byte") return CodeBlock.dtByte;
		else if ((access & (1 << CodeBlock.dtChar)) != 0 && kw == "char") return CodeBlock.dtChar;
		else if ((access & (1 << CodeBlock.dtWord)) != 0 && kw == "word") return CodeBlock.dtWord;
		else if ((access & (1 << CodeBlock.dtShort)) != 0 && kw == "short") return CodeBlock.dtShort;
		else if ((access & (1 << CodeBlock.dtDword)) != 0 && kw == "dword") return CodeBlock.dtDword;
		else if ((access & (1 << CodeBlock.dtDword)) != 0 && kw == "uint") return CodeBlock.dtDword;
		else if ((access & (1 << CodeBlock.dtInt)) != 0 && kw == "int") return CodeBlock.dtInt;
		else if ((access & (1 << CodeBlock.dtQword)) != 0 && kw == "qword") return CodeBlock.dtQword;
		else if ((access & (1 << CodeBlock.dtLong)) != 0 && kw == "long") return CodeBlock.dtLong;
		else if ((access & (1 << CodeBlock.dtQword)) != 0 && kw == "qword") return CodeBlock.dtQword;
		else if ((access & (1 << CodeBlock.dtFloat)) != 0 && kw == "float") return CodeBlock.dtFloat;
		else if ((access & (1 << CodeBlock.dtDouble)) != 0 && kw == "double") return CodeBlock.dtDouble;
		else if ((access & (1 << CodeBlock.dtDouble)) != 0 && kw == "number") return CodeBlock.dtDouble;
		else if ((access & (1 << CodeBlock.dtBool)) != 0 && kw == "bool") return CodeBlock.dtBool;
		else if ((access & (1 << CodeBlock.dtBool)) != 0 && kw == "boolean") return CodeBlock.dtBool;
		else if ((access & (1 << CodeBlock.dtString)) != 0 && kw == "string") return CodeBlock.dtString;
		else if ((access & (1 << CodeBlock.dtObject)) != 0 && kw == "object") return CodeBlock.dtObject;
		return -1;
	}

	public function ESOperatorToBlock(single:Boolean = false):void
	{
		var su:StackUnit;
		var op:uint;
		var assume:Boolean;
		
		while (m_ExpStackLen > 0) {
			su = m_ExpStack[m_ExpStackLen - 1];
			if (su.m_Op <= 0) break;
			if (OperatorPrior(su.m_Op) < 0) { m_Src.error(CodeSrc.errExpression); return; }
			
			assume = false;
			op = su.m_Op;
			
			switch(op) {
				case optAssume: assume = true; op = 0; break;
				case optAssumeAdd: assume = true; op = CodeBlock.opAdd; break;
				case optAssumeSub: assume = true; op = CodeBlock.opSub; break;
				case optAssumeAnd: assume = true; op = CodeBlock.opAnd; break;
				case optAssumeOr: assume = true; op = CodeBlock.opOr; break;
				case optAssumeXor: assume = true; op = CodeBlock.opXor; break;
				case optAssumeShl: assume = true; op = CodeBlock.opShl; break;
				case optAssumeShr: assume = true; op = CodeBlock.opShr; break;
				case optAssumeMul: assume = true; op = CodeBlock.opMul; break;
				case optAssumeDiv: assume = true; op = CodeBlock.opDiv; break;
				case optAssumeMod: assume = true; op = CodeBlock.opMod; break;
			}

			if (op != 0) m_Block.Op(op);

			if (assume) {
				if (m_ExpStackLen < 2) { m_Src.error(CodeSrc.errExpression); return; }
				su = m_ExpStack[m_ExpStackLen - 2]
				if (su.m_Op != 0 || su.m_Val != 0 || !Boolean(su.m_Name)) { m_Src.error(CodeSrc.errExpression); return; }
				
				if (su.m_Name.charCodeAt(0) == 46) {
					if (m_ExpPushCnt < 2) { m_Src.error(CodeSrc.errExpressionStackEmpty); return; }
					if (!m_Block.OpAssumeMemberVarByName(su.m_Name.substr(1))) { m_Src.error(CodeSrc.errOpCode); return; }
				} else {
					if (m_ExpPushCnt < 1) { m_Src.error(CodeSrc.errExpressionStackEmpty); return; }
					if (!m_Block.OpAssumeVarByName(su.m_Name)) { m_Src.error(CodeSrc.errOpCode); return; }
				}

				ESPop();
				ESPop();
			} else {
				if (IsUnaryOperator(op)) {
					if (m_ExpPushCnt < 1) { m_Src.error(CodeSrc.errExpressionStackEmpty); return; }
				} else {
					if (m_ExpPushCnt < 2) { m_Src.error(CodeSrc.errExpressionStackEmpty); return; }
					m_ExpPushCnt--;
				}
				ESPop();
			}

			if (single) break;
		}
	}
	
	public function parsePostfix(varname:String):String
	{
		var ch:int;
		var kw:String;

		var varread:Boolean = false;
		var ret:String = null;

		while (true) {
			m_Src.parseSpace();
			ch = m_Src.pickChar();

			if (ch == 46) { // .
				m_Src.nextChar();
				m_Src.parseSpace();
				kw = m_Src.pickWord();
				if (kw == null) { m_Src.error(CodeSrc.errSyntax); return null; }
				m_Src.skipWord();

				if (!varread) {
					varread = true;
					if(!m_Block.OpPushVarByName(varname)) { m_Src.error(CodeSrc.errOpCode); return null; }
					m_ExpPushCnt++;
				}
				ret = "." + kw;

				m_Src.parseSpace();
				ch = m_Src.pickChar();
				if (ch == 46) { // .
					if (!m_Block.OpReplaceMemberVarByName(kw)) { m_Src.error(CodeSrc.errOpCode); return null; }
					continue;

				} else if (ch == 40) { // (
					m_Src.error(CodeSrc.errNotImplement); return null;

				} else if (ch == 91) { // [
					m_Src.error(CodeSrc.errNotImplement); return null;

				} else {
					ret = "." + kw;
					break;
				}
			} else {
				if (!varread) {
					ret = varname;
				}
				break;
			}
		}
		return ret;
	}

	public function parseExpression(aflag:uint, desc:uint, endchar:int = 0, candeclvar:Boolean = true):void
	{
		var op:uint, dt:uint;
		var su:StackUnit;
		var i:int, curprior:int, sprior:int;
		var ch:int;
		var v:int;
		var kw:String;
		var cc:CodeCompiler;

		if (m_ExpStack == null) m_ExpStack = new Vector.<StackUnit>();
		m_ExpStackLen = 0;
		m_ExpPushCnt = 0;

		if (desc) { m_Block.m_WriteDesc = desc; m_Block.m_WriteLine = m_Src.m_Line; }

		var bio:Boolean = false; // бинарная операция. должен быть левый аргумент

		var declvar:Boolean = false; // объявление переменных
		kw = m_Src.pickWord();
		if (kw != null && kw == "var") {
			m_Src.skipWord();
			if (!candeclvar) { m_Src.error(CodeSrc.errSyntax); return; }
			declvar = true;
			candeclvar = true;
		}

		while (!m_Src.isEnd) {
			m_Src.parseSpace();
			if (m_Src.isEnd) break;

			if (bio) op = ParseBinaryOperator();
			else {
				op = ParseUnaryOperator();
				if(op) {
					dt = ParseConstStd(op);
					if (dt != 0) {
						if (dt == CodeBlock.dtByte || dt == CodeBlock.dtWord || dt == CodeBlock.dtDword) m_Block.OpPushConstDword(m_ParseConstStd);
						else if (dt == CodeBlock.dtChar || dt == CodeBlock.dtShort || dt == CodeBlock.dtInt) m_Block.OpPushConstInt(int(m_ParseConstStd));
						else if (dt == CodeBlock.dtBool && m_ParseConstStd) m_Block.Op(CodeBlock.opPushDef | CodeBlock.defTrue);
						else if (dt == CodeBlock.dtBool && !m_ParseConstStd) m_Block.Op(CodeBlock.opPushDef | CodeBlock.defFalse);
						else if (dt == CodeBlock.dtObject && m_ParseConstStd == undefined) m_Block.Op(CodeBlock.opPushDef | CodeBlock.defUndefined);
						else if (dt == CodeBlock.dtObject && m_ParseConstStd == 0) m_Block.Op(CodeBlock.opPushDef | CodeBlock.defNull);
						else { m_Src.error(CodeSrc.errNotImplement); return; }
						m_ExpPushCnt++;
						candeclvar = false;
						bio = true;
						continue;
					}
				}
			}
			if (op != 0) {
				curprior = OperatorPrior(op);
				if (curprior < 0) { m_Src.error(CodeSrc.errNotImplement); return; }

				while (m_ExpStackLen > 0) {
					su = m_ExpStack[m_ExpStackLen - 1];
					if (su.m_Op <= 0) break;
					sprior = OperatorPrior(su.m_Op);
					if (sprior < 0) break;
					if (bio && IsRightOperator(op)) {
						if (curprior < sprior) break;
					} else {
						if (curprior <= sprior) break;
					}
					ESOperatorToBlock(true); if (m_Src.err) return;
				}

				ESPush(op);
				candeclvar = false;
				if (bio) bio = false;
				continue;
			}

			dt = ParseConstStd();
			if (dt != 0) {
				if (dt == CodeBlock.dtByte || dt == CodeBlock.dtWord || dt == CodeBlock.dtDword) m_Block.OpPushConstDword(m_ParseConstStd);
				else if (dt == CodeBlock.dtChar || dt == CodeBlock.dtShort || dt == CodeBlock.dtInt) m_Block.OpPushConstInt(int(m_ParseConstStd));
				else if (dt == CodeBlock.dtBool && m_ParseConstStd) m_Block.Op(CodeBlock.opPushDef | CodeBlock.defTrue);
				else if (dt == CodeBlock.dtBool && !m_ParseConstStd) m_Block.Op(CodeBlock.opPushDef | CodeBlock.defFalse);
				else if (dt == CodeBlock.dtObject && m_ParseConstStd == undefined) m_Block.Op(CodeBlock.opPushDef | CodeBlock.defUndefined);
				else if (dt == CodeBlock.dtObject && m_ParseConstStd == 0) m_Block.Op(CodeBlock.opPushDef | CodeBlock.defNull);
				else { m_Src.error(CodeSrc.errNotImplement); return; }
				m_ExpPushCnt++;
				candeclvar = false;
				bio = true;
				continue;
			}
			
			kw = ParseConstString();
			if (kw != null) {
				m_Block.OpPushConstString(kw);
				m_ExpPushCnt++;
				candeclvar = false;
				bio = true;
				continue;
			}

			kw = m_Src.pickWord();
			if (kw != null) {
				m_Src.skipWord();
				m_Src.parseSpace();
				if (m_Src.pickChar() == 40) { // (
					ESPush(0, 0, kw);
				} else {
					if (declvar && candeclvar) {
						if (findDeclByName(kw) >= 0) { m_Src.error(CodeSrc.errDeclAlreadyExist); return; }
						
						cc = declNew(kw);
						cc.m_Flag = FlagVar | aflag;

						m_Src.parseSpace();
						ch = m_Src.pickChar();
						if (ch == 58) { // :
							m_Src.nextChar();

							m_Src.parseSpace();
							kw = m_Src.pickWord();
							m_Src.skipWord();
							v = Word2DataType(kw,m_Src.m_MaskVarType);
							if (v < 0) {
								if (ReservedKeyword[kw] != undefined) { m_Src.error(CodeSrc.errReservedKeyword); return; }
								if (!m_Src.m_AccessClassType) { m_Src.error(CodeSrc.errSyntax); return; }
								cc.m_DataClassType = kw;
							} else cc.m_Flag |= v;
							kw = cc.m_Name;
						} else {
							cc.m_Flag = m_Src.m_DefVarType;
						}
					}

					kw = parsePostfix(kw); if (m_Src.err) return;
					if(kw==null || kw.length<=0) { m_Src.error(CodeSrc.errSyntax); return; }
					m_Src.parseSpace();
					op = ParseBinaryOperator(true);

					if (op != optAssume) {
						if (kw.charCodeAt(0) == 46) {
							if(IsAssume(op)) {
								if (!m_Block.OpPushMemberVarByName(kw.substr(1))) { m_Src.error(CodeSrc.errOpCode); return; }
							} else {
								if (!m_Block.OpReplaceMemberVarByName(kw.substr(1))) { m_Src.error(CodeSrc.errOpCode); return; }
							}
							m_ExpPushCnt++;
						} else {
							if(!m_Block.OpPushVarByName(kw)) { m_Src.error(CodeSrc.errOpCode); return; }
							m_ExpPushCnt++;
						}
					}

					if (IsAssume(op)) {
						// Для операторов присваивания с изменением нужно два действия: загрузить в начале, и сохранить в конце. Для простого присваивания - загружать не нужно.
						ESPush(0, 0, kw);
					}
				}

				candeclvar = false;
				bio = true;
				continue;
			}

			m_Src.parseSpace();
			if (m_Src.isEnd) break;
			ch = m_Src.getChar();
			
			if (endchar != 0 && ch == endchar) {
				m_Src.nextChar( -1);
				break;
				
			} else if (ch == 40) { // (
				ESPush( -1, m_ExpPushCnt);
				m_ExpPushCnt = 0;
				candeclvar = false;
				bio = false;
				continue;
				
			} else if (ch == 41) { // )
				ESOperatorToBlock(); if (m_Src.err) return;

				if (m_ExpStackLen <= 0) {
					m_Src.nextChar( -1);
					break;
				}
				su = m_ExpStack[m_ExpStackLen - 1];
				if (su.m_Op != -1) { m_Src.error(CodeSrc.errExpression); return; }

				if (m_ExpStackLen >= 2 && m_ExpStack[m_ExpStackLen - 2].m_Op == 0) {
					if(!m_Block.OpCallByName(m_ExpPushCnt, m_ExpStack[m_ExpStackLen - 2].m_Name)) { m_Src.error(CodeSrc.errOpCode); return; }
					ESPop();
					ESPop();
					m_ExpPushCnt = su.m_Val + 1;
				} else {
					//m_ExpPushCnt = su.m_Val;
					m_ExpPushCnt = su.m_Val + 1;
					ESPop();
				}

				candeclvar = false;
				bio = true;
				continue;

			} else if (ch == 44) { // ,
				ESOperatorToBlock(); if (m_Src.err) return;
				
				candeclvar = true;
				bio = false;
				continue;

			} else if (ch == 59) { // ;
				m_Src.nextChar( -1);
				break;
			}

			m_Src.error(CodeSrc.errNotImplement);
			return;
		}

		ESOperatorToBlock(); if (m_Src.err) return;
		if (m_ExpStackLen > 0) { m_Src.error(CodeSrc.errExpression); return; }
		
		m_Block.m_WriteDesc = 0; m_Block.m_WriteLine = 0;

//trace(m_Block.print());
//trace("PushCnt:", m_ExpPushCnt);
	}
	
	public function ParseBlock(complex:Boolean = true, adr_continue:int = -1, access_break:Boolean = false, access_return:Boolean = false):void
	{
		var kw:String;
		var ifblock:CodeBlock, oldblock:CodeBlock;
		var adr_begin:int, adr_continue_inner:int, adr_tmp:int;
		var ch:int;
		var v:int;
		var fl:Boolean;
		var cc:CodeCompiler, ccv:CodeCompiler;

		var f_static:Boolean;
		var f_const:Boolean;

		while (!m_Src.isEnd) {
			f_static = false;
			f_const = false;

			while (true) {
				m_Src.parseSpace();
				kw = m_Src.pickWord();
				if (kw != null && kw == "static") {
					m_Src.skipWord();
					f_static = true;
				} else if (kw != null && kw == "const") {
					m_Src.skipWord();
					f_const = true;
				} else break;
			}

			m_Src.parseSpace();
			kw = m_Src.pickWord();
			if (kw != null && kw == "function") {
				m_Src.skipWord();

				m_Src.parseSpace();
				kw = m_Src.pickWord();
				if (kw == null) { m_Src.error(CodeSrc.errSyntax); return; }
				m_Src.skipWord();

				if (ReservedKeyword[kw] != undefined) { m_Src.error(CodeSrc.errReservedKeyword); return; }
				if (findDeclByName(kw) >= 0) { m_Src.error(CodeSrc.errDeclAlreadyExist); return; }

				cc = declNew(kw);
				cc.m_Flag = FlagFun;
				if (f_static) cc.m_Flag |= FlagStatic;
				if (f_const) cc.m_Flag |= FlagConst;

				m_Src.parseSpace(); if (m_Src.getChar() != 40) { m_Src.error(CodeSrc.errSyntax); return; }

				// arg
				while (true) {
					m_Src.parseSpace();	
					kw = m_Src.pickWord();

					if (kw != null) {
						m_Src.skipWord();
						if (ReservedKeyword[kw] != undefined) { m_Src.error(CodeSrc.errReservedKeyword); return; }
						if (cc.findDeclByName(kw) >= 0) { m_Src.error(CodeSrc.errDeclAlreadyExist); return; }

						ccv = cc.declNew(kw);
						ccv.m_Flag = FlagVar | FlagArg;

						m_Src.parseSpace();
						ch = m_Src.pickChar();
						if (ch == 58) { // :
							m_Src.nextChar();
							
							m_Src.parseSpace();
							kw = m_Src.pickWord();
							m_Src.skipWord();
							v = Word2DataType(kw, m_Src.m_MaskVarType);
							if (v < 0) {
								if (ReservedKeyword[kw] != undefined) { m_Src.error(CodeSrc.errReservedKeyword); return; }
								if (!m_Src.m_AccessClassType) { m_Src.error(CodeSrc.errSyntax); return; }
								ccv.m_DataClassType = kw;
							} else ccv.m_Flag |= v;
						} else {
							ccv.m_Flag |= m_Src.m_DefVarType;
						}

						m_Src.parseSpace();
						ch = m_Src.pickChar();
						if (ch == 61) { // =
							m_Src.nextChar();

							ccv.m_Block = new CodeBlock();
							ccv.m_Src = m_Src;

							ccv.parseExpression(0, CodeBlock.opDesc | CodeBlock.descSimple, 44, false); if (m_Src.err) return;
						}

						m_Src.parseSpace();
						ch = m_Src.pickChar();
						if (ch == 44) { // ,
							m_Src.nextChar();
							continue;
						}
					}

					m_Src.parseSpace();
					ch = m_Src.pickChar();
					if (ch != 41) { m_Src.error(CodeSrc.errSyntax); return; }
					m_Src.nextChar();
					break;
				}

				// return type
				m_Src.parseSpace();
				ch = m_Src.pickChar();
				if (ch == 58) { // :
					m_Src.nextChar();

					m_Src.parseSpace();
					kw = m_Src.pickWord();
					m_Src.skipWord();
					v = Word2DataType(kw, m_Src.m_MaskVarType | (1 << CodeBlock.dtNone));
					if (v < 0) {
						if (ReservedKeyword[kw] != undefined) { m_Src.error(CodeSrc.errReservedKeyword); return; }
						if (!m_Src.m_AccessClassType) { m_Src.error(CodeSrc.errSyntax); return; }
						cc.m_DataClassType = kw;
					} else cc.m_Flag |= v;
				} else {
					cc.m_Flag |= m_Src.m_DefVarType;
				}

				// body
				m_Src.parseSpace(); if (m_Src.getChar() != 123) { m_Src.error(CodeSrc.errSyntax); return; }
				cc.m_Src = m_Src;
				cc.parseFun(); if (m_Src.err) return;
				m_Src.parseSpace(); if (m_Src.getChar() != 125) { m_Src.error(CodeSrc.errSyntax); return; }

			} else if (kw != null && kw == "var" && isBlockEmpty) {
				m_Src.skipWord();

				while (true) {
					m_Src.parseSpace();
					kw = m_Src.pickWord();
					if (kw == null) { m_Src.error(CodeSrc.errSyntax); return; }
					m_Src.skipWord();

					if (findDeclByName(kw) >= 0) { m_Src.error(CodeSrc.errDeclAlreadyExist); return; }

					cc = declNew(kw);
					cc.m_Flag = FlagVar;
					if (f_static) cc.m_Flag |= FlagStatic;
					if (f_const) cc.m_Flag |= FlagConst;

					m_Src.parseSpace();
					ch = m_Src.pickChar();
					if (ch == 58) { // :
						m_Src.nextChar();

						m_Src.parseSpace();
						kw = m_Src.pickWord();
						m_Src.skipWord();
						v = Word2DataType(kw, m_Src.m_MaskVarType);
						if (v < 0) {
							if (ReservedKeyword[kw] != undefined) { m_Src.error(CodeSrc.errReservedKeyword); return; }
							if (!m_Src.m_AccessClassType) { m_Src.error(CodeSrc.errSyntax); return; }
							cc.m_DataClassType = kw;
						} else cc.m_Flag |= v;
					} else {
						cc.m_Flag |= m_Src.m_DefVarType;
					}

					m_Src.parseSpace();
					ch = m_Src.pickChar();
					if (ch == 61) { // =
						m_Src.nextChar();

						cc.m_Block = new CodeBlock();
						cc.m_Src = m_Src;

						cc.parseExpression(0, CodeBlock.opDesc | CodeBlock.descSimple, 44, false); if (m_Src.err) return;
					}

					m_Src.parseSpace();
					ch = m_Src.pickChar();
					if (ch == 44) { // ,
						m_Src.nextChar();
						continue;
					} else if (ch == 59) { // ;
						m_Src.nextChar();
						break;
					} else { m_Src.error(CodeSrc.errSyntax); return; }
				}
				
			} else if (kw != null && kw == "break") {
				if (f_static || f_const) { m_Src.error(CodeSrc.errSyntax); return; }
				if(m_Flag & FlagClass) { m_Src.error(CodeSrc.errSyntax); return; }
				m_Src.skipWord();
				m_Src.parseSpace(); if (m_Src.getChar() != 59) { m_Src.error(CodeSrc.errSyntax); return; }
				if (!access_break) { m_Src.error(CodeSrc.errNotLoop); return; }

				if(!m_Block.OpJump(CodeBlock.jmpGoTo, jmpOffBreak)) { m_Src.error(CodeSrc.errOpCode); return; }
				
			} else if (kw != null && kw == "continue") {
				if (f_static || f_const) { m_Src.error(CodeSrc.errSyntax); return; }
				if(m_Flag & FlagClass) { m_Src.error(CodeSrc.errSyntax); return; }
				m_Src.skipWord();
				m_Src.parseSpace(); if (m_Src.getChar() != 59) { m_Src.error(CodeSrc.errSyntax); return; }
				if (adr_continue < 0) { m_Src.error(CodeSrc.errNotLoop); return; }

				if (!m_Block.OpJumpAdr(CodeBlock.jmpGoTo, adr_continue)) { m_Src.error(CodeSrc.errOpCode); return; }
				
			} else if(kw!=null && kw=="return") {
				if (f_static || f_const) { m_Src.error(CodeSrc.errSyntax); return; }
				if (m_Flag & FlagClass) { m_Src.error(CodeSrc.errSyntax); return; }
				m_Src.skipWord();
				m_Src.parseSpace();
				if (m_Src.pickChar() == 59) {
					m_Src.nextChar();
				} else {
					ParseBlock(false, adr_continue_inner, access_break, access_return); if (m_Src.err) return;
				}
				//m_Src.parseSpace();
				//if (m_Src.getChar() != 59) { m_Src.error(CodeSrc.errSyntax); return; }

				if (!m_Block.OpJump(CodeBlock.jmpGoTo, jmpOffReturn)) { m_Src.error(CodeSrc.errOpCode); return; }
				
			} else if(kw!=null && kw=="wait") {
				if (f_static || f_const) { m_Src.error(CodeSrc.errSyntax); return; }
				if (m_Flag & FlagClass) { m_Src.error(CodeSrc.errSyntax); return; }
				m_Src.skipWord();
				m_Src.parseSpace(); if (m_Src.getChar() != 59) { m_Src.error(CodeSrc.errSyntax); return; }
				
				m_Block.Op(CodeBlock.opWait);

			} else if (kw != null && kw == "while") {
				if (f_static || f_const) { m_Src.error(CodeSrc.errSyntax); return; }
				if(m_Flag & FlagClass) { m_Src.error(CodeSrc.errSyntax); return; }
				m_Src.skipWord();
				m_Src.parseSpace(); if (m_Src.getChar() != 40) { m_Src.error(CodeSrc.errSyntax); return; }

				adr_begin = m_Block.code.length;

				// if
				adr_continue_inner = m_Block.code.length;
				parseExpression(0, CodeBlock.opDescFor | CodeBlock.descWhile); if (m_Src.err) return;
				m_Src.parseSpace(); if (m_Src.getChar() != 41) { m_Src.error(CodeSrc.errSyntax); return; }

				// if_test
				adr_tmp = m_Block.code.length;
				if(!m_Block.OpJump(CodeBlock.jmpIfNot, jmpOffBreak)) { m_Src.error(CodeSrc.errOpCode); return; }

				// inner
				m_Src.parseSpace();
				if (m_Src.pickChar() == 123) { // {
					m_Src.nextChar();
					ParseBlock(true, adr_continue_inner, true, access_return); if (m_Src.err) return;
					m_Src.parseSpace(); if (m_Src.getChar() != 125) { m_Src.error(CodeSrc.errSyntax); return; }

				} else {
					ParseBlock(false, adr_continue_inner, true, access_return); if (m_Src.err) return;
				}

				// continue
				if(!m_Block.OpJumpAdr(CodeBlock.jmpGoTo, adr_continue_inner)) { m_Src.error(CodeSrc.errOpCode); return; }

				// init: end, break
				if (!m_Block.ReplaceJumpLongAdrAll(adr_begin, jmpOffEnd, m_Block.code.length, jmpOffBreak, m_Block.code.length)) { m_Src.error(CodeSrc.errParseOpCode); return; }

			} else if (kw != null && kw == "for") {
				if (f_static || f_const) { m_Src.error(CodeSrc.errSyntax); return; }
				if(m_Flag & FlagClass) { m_Src.error(CodeSrc.errSyntax); return; }
				m_Src.skipWord();
				m_Src.parseSpace(); if (m_Src.getChar() != 40) { m_Src.error(CodeSrc.errSyntax); return; }

				adr_begin = m_Block.code.length;
				// init
				parseExpression(0, CodeBlock.opDescFor | CodeBlock.descForInit); if (m_Src.err) return;
				m_Src.parseSpace(); if (m_Src.getChar() != 59) { m_Src.error(CodeSrc.errSyntax); return; }

				// jump if
				adr_tmp = m_Block.code.length;
				if(!m_Block.OpJump(CodeBlock.jmpGoTo, jmpOffTmp)) { m_Src.error(CodeSrc.errOpCode); return; }

				// if
				oldblock = m_Block;	m_Block = new CodeBlock();
				parseExpression(0, CodeBlock.opDescFor | CodeBlock.descForIf); if (m_Src.err) return;
				ifblock = m_Block; m_Block = oldblock; oldblock = null;
				m_Src.parseSpace(); if (m_Src.getChar() != 59) { m_Src.error(CodeSrc.errSyntax); return; }

				// inc
				adr_continue_inner = m_Block.code.length;
				parseExpression(0, CodeBlock.opDescFor | CodeBlock.descForInc); if (m_Src.err) return;
				m_Src.parseSpace(); if (m_Src.getChar() != 41) { m_Src.error(CodeSrc.errSyntax); return; }

				// if add
				if(!m_Block.ReplaceJumpLongAdr(adr_tmp, m_Block.code.length)) { m_Src.error(CodeSrc.errOpCode); return; }
				m_Block.AddBlock(ifblock); ifblock = null;

				// if_test
				adr_tmp = m_Block.code.length;
				if(!m_Block.OpJump(CodeBlock.jmpIfNot, jmpOffBreak)) { m_Src.error(CodeSrc.errOpCode); return; }

				// inner
				m_Src.parseSpace();
				if (m_Src.pickChar() == 123) { // {
					m_Src.nextChar();
					ParseBlock(true, adr_continue_inner, true, access_return); if (m_Src.err) return;
					m_Src.parseSpace(); if (m_Src.getChar() != 125) { m_Src.error(CodeSrc.errSyntax); return; }

				} else {
					ParseBlock(false, adr_continue_inner, true, access_return); if (m_Src.err) return;
				}

				// continue
				if(!m_Block.OpJumpAdr(CodeBlock.jmpGoTo, adr_continue_inner)) { m_Src.error(CodeSrc.errOpCode); return; }

				// init: end, break
				if(!m_Block.ReplaceJumpLongAdrAll(adr_begin, jmpOffEnd, m_Block.code.length, jmpOffBreak, m_Block.code.length)) { m_Src.error(CodeSrc.errParseOpCode); return; }
//trace(m_Block.print());
			} else if (kw != null && kw == "if") {
				if (f_static || f_const) { m_Src.error(CodeSrc.errSyntax); return; }
				if(m_Flag & FlagClass) { m_Src.error(CodeSrc.errSyntax); return; }
				m_Src.skipWord();
				m_Src.parseSpace(); if (m_Src.getChar() != 40) { m_Src.error(CodeSrc.errSyntax); return; }
				
				adr_begin = m_Block.code.length;
				// if
				parseExpression(0, CodeBlock.opDesc | CodeBlock.descIf); if (m_Src.err) return;
				m_Src.parseSpace(); if (m_Src.getChar() != 41) { m_Src.error(CodeSrc.errSyntax); return; }

				// if_test
				adr_tmp = m_Block.code.length;
				if(!m_Block.OpJump(CodeBlock.jmpIfNot, jmpOffTmp)) { m_Src.error(CodeSrc.errOpCode); return; }
				
				// inner
				m_Src.parseSpace();
				if (m_Src.pickChar() == 123) { // {
					m_Src.nextChar();
					ParseBlock(true, adr_continue, access_break, access_return); if (m_Src.err) return;
					m_Src.parseSpace(); if (m_Src.getChar() != 125) { m_Src.error(CodeSrc.errSyntax); return; }

				} else {
					ParseBlock(false, adr_continue, access_break, access_return); if (m_Src.err) return;
				}

				// goto end
				if(!m_Block.OpJump(CodeBlock.jmpGoTo, jmpOffEnd)) { m_Src.error(CodeSrc.errOpCode); return; }

				// if_set
				if(!m_Block.ReplaceJumpLongAdr(adr_tmp, m_Block.code.length)) { m_Src.error(CodeSrc.errOpCode); return; }

				// loop
				fl = true;
				while (fl) {
					// else
					m_Src.parseSpace();
					kw = m_Src.pickWord();
					if (kw == null || kw != "else") break;
					m_Src.skipWord();

					m_Src.parseSpace();

					// else_if
					kw = m_Src.pickWord();
					if (kw == "if") {
						m_Src.skipWord();
						m_Src.parseSpace(); if (m_Src.getChar() != 40) { m_Src.error(CodeSrc.errSyntax); return; }

						// if
						parseExpression(0, CodeBlock.opDesc | CodeBlock.descElseIf); if (m_Src.err) return;
						m_Src.parseSpace(); if (m_Src.getChar() != 41) { m_Src.error(CodeSrc.errSyntax); return; }

						// if_test
						adr_tmp = m_Block.code.length;
						if(!m_Block.OpJump(CodeBlock.jmpIfNot, jmpOffTmp)) { m_Src.error(CodeSrc.errOpCode); return; }
					} else {
						fl = false;
					}

					// inner
					m_Src.parseSpace();
					if (m_Src.pickChar() == 123) { // {
						m_Src.nextChar();
						ParseBlock(true, adr_continue, access_break, access_return); if (m_Src.err) return;
						m_Src.parseSpace(); if (m_Src.getChar() != 125) { m_Src.error(CodeSrc.errSyntax); return; }

					} else {
						ParseBlock(false, adr_continue, access_break, access_return); if (m_Src.err) return;
					}
					
					// goto end
					if(!m_Block.OpJump(CodeBlock.jmpGoTo, jmpOffEnd)) { m_Src.error(CodeSrc.errOpCode); return; }
					
					if(fl) {
						// if_set
						if(!m_Block.ReplaceJumpLongAdr(adr_tmp, m_Block.code.length)) { m_Src.error(CodeSrc.errOpCode); return; }
					}
				}

				// init: end
				if(!m_Block.ReplaceJumpLongAdrAll(adr_begin, jmpOffEnd, m_Block.code.length)) { m_Src.error(CodeSrc.errParseOpCode); return; }

			} else {
//				if (f_static || f_const) { m_Src.error(CodeSrc.errSyntax); return; }

				var af:uint = 0;
				if (f_static) af |= FlagStatic;
				if (f_const) af |= FlagConst;

				//if(m_Flag & FlagClass) { m_Src.error(CodeSrc.errSyntax); return; }
				parseExpression(af, CodeBlock.opDesc | CodeBlock.descSimple); if (m_Src.err) return;
				m_Src.parseSpace();
				if (!m_Src.isEnd && m_Src.getChar() != 59) { m_Src.error(CodeSrc.errSyntax); return; }
			}

			if (!complex) break;
			m_Src.parseSpace(); 
			if (!m_Src.isEnd && m_Src.pickChar() == 125) break; // }
		}
	}

	public function parseFun():void
	{
		m_PrepareForRun = false;
		m_Block = new CodeBlock();
		ParseBlock(true, -1, false, true); if (m_Src.err) return;

		// init: return
		if (!m_Block.ReplaceJumpLongAdrAll(0, jmpOffReturn, m_Block.code.length)) { m_Src.error(CodeSrc.errParseOpCode); return; }

//m_Block.decode(m_Block.m_Code);
//var retry:Boolean = true;
//while(retry) {
//	retry = false;
//	if (m_Block.optimizerExp()) retry = true;
//	if (m_Block.optimizerJmp()) retry = true;
//}
//m_Block.encode();
//m_Block.pcClear();
//if(!m_Block.decode(m_Block.m_Code)) trace("error_decode");
//else trace(m_Block.print(),"\nSize code: ",m_Block.m_Code.length);
	}
	
	public function optimizerConstant(cb:CodeBlock, env:CodeCompiler):void
	{
		var i:int, u:int;
		var pc:CodePc;
		var op:uint;
		var cc:CodeCompiler;
		var cd:CodeCompiler;
		var v:*;
		var find:Boolean;

		if (cb.m_Pc == null) return;

		for (i = 0; i < cb.m_Pc.length; i++) {
			pc = cb.m_Pc[i];
			op = pc.m_Op;
			if (op == CodeBlock.opPushVarByName) {
				find = false;

//if(pc.m_Val == "ItemTypeModule") {
//	trace("e");
//}
				cc = this; // сначало текущие константы this и parent
				while (cc != null) {
					if(cc.m_Local!=null) {
						cd = cc.m_Local[pc.m_Val];
						if (cd != null && (cd.m_Flag & FlagStatic) == 0) {
							if ((cd.m_Flag & FlagVar) == 0 || (cd.m_Flag & FlagArg) != 0 || (cd.m_Flag & FlagConst) == 0) { if (m_Src != null) m_Src.error(CodeSrc.errConst); return; }
							if ((cd.m_Flag & FlagDefaultVal) == 0) { if (m_Src != null) m_Src.error(CodeSrc.errConst); return; }

							if (!CodeBlock.saveConstToPc(pc, cd.m_Flag & CodeBlock.dtMask, cd.m_DataVal)) { if (m_Src != null) m_Src.error(CodeSrc.errConst); return; }
							find = true;
							break;
						}
					}

					cc = cc.m_Parent;
				}
				if (!find) {
					cd = env.findEnvName(pc.m_Val);
					if (cd != null && (cd.m_Flag & FlagStatic) == 0) {
						if ((cd.m_Flag & FlagVar) == 0 || (cd.m_Flag & FlagArg) != 0 || (cd.m_Flag & FlagConst) == 0) { if (m_Src != null) m_Src.error(CodeSrc.errConst); return; }
						if ((cd.m_Flag & FlagDefaultVal) == 0) { if (m_Src != null) m_Src.error(CodeSrc.errConst); return; }

						if (!CodeBlock.saveConstToPc(pc, cd.m_Flag & CodeBlock.dtMask, cd.m_DataVal)) { if (m_Src != null) m_Src.error(CodeSrc.errConst); return; }
						find = true;
					}
				}
			}
		}

		var retry:Boolean = true;
		while(retry) {
			retry = false;
			if (cb.optimizerExp()) retry = true;
			if (cb.optimizerJmp()) retry = true;
		}
	}
	
	public function prepare(env:CodeCompiler = null):void
	{
		var i:int, u:int, k:int;
		var cc:CodeCompiler;
		var tbc:CodeBlock;
		var pc:CodePc;
		var op:uint;
		var v:*;
		
		if (m_Src != null && m_Src.err) return;

		if (!(m_Flag & FlagClass)) {
			m_LocalVarCnt = 0;
			m_ArgVarCnt = 0;

			var svarl:Array = new Array();

			var tb:CodeBlock = new CodeBlock();

			if (m_Decl != null) {
				// Аргументы функций
				for (i = 0; i < m_Decl.length; i++) {
					cc = m_Decl[i];
					if (!(cc.m_Flag & FlagVar)) continue;
					if (!(cc.m_Flag & FlagArg)) continue;
					m_ArgVarCnt++;

					if (cc.m_Block != null && !cc.m_Block.isEmpty) {
						tbc = new CodeBlock();
						if(!tbc.decode(cc.m_Block.m_Code)) { if (m_Src != null) m_Src.error(CodeSrc.errDecode); return; }
						optimizerConstant(tbc, env); if (m_Src.err) return;
						cc.m_DataVal = tbc.extractConst(cc.m_Flag & CodeBlock.dtMask);
						cc.m_Block = null;
						cc.m_Flag |= FlagDefaultVal;
					}
				}

				// Расчет констант и static переменных
				for (i = 0; i < m_Decl.length; i++) {
					cc = m_Decl[i];
					if (!(cc.m_Flag & FlagVar)) continue;
					if ((cc.m_Flag & FlagConst) != 0) { }
					else if ((cc.m_Flag & FlagStatic) != 0) { }
					else continue;

					if (cc.m_Block != null && !cc.m_Block.isEmpty) {
						tbc = new CodeBlock();
						if(!tbc.decode(cc.m_Block.m_Code)) { if (m_Src != null) m_Src.error(CodeSrc.errDecode); return; }
						optimizerConstant(tbc, env); if (m_Src.err) return;
						cc.m_DataVal = tbc.extractConst(cc.m_Flag & CodeBlock.dtMask);
						cc.m_Block = null;
						cc.m_Flag |= FlagDefaultVal;
					}
				}

				// Локальные переменные
				u = 0;
				for (i = 0; i < m_Decl.length; i++) {
					cc = m_Decl[i];
					if (!(cc.m_Flag & FlagVar)) continue;
					if ((cc.m_Flag & FlagConst) != 0) continue;
					if ((cc.m_Flag & FlagStatic) != 0) continue;

					if (cc.m_Flag & FlagArg) {
						k = -m_ArgVarCnt + u;
						u++;
					} else {
						k = /*m_ArgVarCnt +*/ m_LocalVarCnt;
						m_LocalVarCnt++;

						if (cc.m_Block != null && !cc.m_Block.isEmpty) {
							u = 0;
							if (tb.m_Pc != null) u = tb.m_Pc.length;
							tb.decode(cc.m_Block.m_Code);
							if(tb.m_Pc!=null)
							for (; u < tb.m_Pc.length; u++) {
								pc = tb.m_Pc[u];
								if ((pc.m_Op & 0xf0) == CodeBlock.opPushConst) break;
								else if ((pc.m_Op & 0xf0) == CodeBlock.opPushDef) break;
								else if ((pc.m_Op & 0xf0) == CodeBlock.opPushLocal) break;
								else if ((pc.m_Op & 0xf0) == CodeBlock.opPushVarByNum) break
								else if (pc.m_Op == CodeBlock.opPushVarByName) break;
								else if (pc.m_Op == CodeBlock.opCallByName) break;
								else if (pc.m_Op == CodeBlock.opCallByNum) break;
								else if (pc.m_Op == CodeBlock.opCallByNum) break;
							}
							if (tb.m_Pc != null && u < tb.m_Pc.length) {
								tb.m_Pc.push(new CodePc(CodeBlock.opAssumeLocal, k));
							}
						}
					}
					cc.m_Num = k;
					svarl[cc.m_Name] = k;
				}
			}

			if (m_Block != null) tb.decode(m_Block.m_Code);

			for (i = 0; i < tb.m_Pc.length; i++) {
				pc = tb.m_Pc[i];
				op = pc.m_Op;
				if (op == CodeBlock.opPushVarByName) {
					v = svarl[pc.m_Val]
					if (v != undefined) {
						pc.m_Op = CodeBlock.opPushLocal;
						pc.m_Val = v;
					}
				} else if (op == CodeBlock.opAssumeVarByName) {
//if(pc.m_Val == "ptr") {
//trace("assume_ptr");
//}
					v = svarl[pc.m_Val]
					if (v != undefined) {
						pc.m_Op = CodeBlock.opAssumeLocal;
						pc.m_Val = v;
					}
				}
			}
			optimizerConstant(tb, env);
			if (!tb.encode()) { if (m_Src != null) m_Src.error(CodeSrc.errEncode); return; }
			tb.pcClear();
			m_Block = tb;

//if(!m_Block.decode(m_Block.m_Code)) trace("error_decode");
//else if (!m_Block.isEmpty) trace(m_Block.print(), "\nSize code: ", m_Block.m_Code.length);

		} else {
			if (m_Src != null) m_Src.error(CodeSrc.errNotImplement); return;
		}

		// дочерние функции
		if (m_Decl != null) {
			for (i = 0; i < m_Decl.length; i++) {
				cc = m_Decl[i];
				if ((cc.m_Flag & FlagFun) == 0) continue;
				cc.prepare(env);
				if (m_Src != null && m_Src.err) return;
			}
		}
	}

	public function extractStaticVar(out:*):void
	{
		if (m_Src.err) return;
		if (m_Decl == null) return;

		var cd:CodeCompiler;

		var i:int;

		for (i = m_Decl.length - 1; i >= 0; i--) {
			cd = m_Decl[i];
			if (cd.m_Flag & FlagFun) continue;
			if (!(cd.m_Flag & FlagStatic)) continue;

			if (out.hasOwnProperty(cd.m_Name)) { m_Src.error(CodeSrc.errDeclAlreadyExist); return; }
			if (cd.m_Block != null) { m_Src.error(CodeSrc.errSyntax); return; }

			if (cd.m_Flag & FlagDefaultVal) out[cd.m_Name] = cd.m_DataVal;
			else {
				switch (cd.m_Flag & CodeBlock.dtMask) {
					case CodeBlock.dtByte: 
					case CodeBlock.dtWord:
					case CodeBlock.dtDword:
						out[cd.m_Name] = uint(0);
						break;

					case CodeBlock.dtChar: 
					case CodeBlock.dtShort:
					case CodeBlock.dtInt:
						out[cd.m_Name] = int(0);
						break;
						
					case CodeBlock.dtFloat:
					case CodeBlock.dtDouble:
						out[cd.m_Name] = Number(0.0);
						break;
						
					case CodeBlock.dtBool:
						out[cd.m_Name] = false;
						break;
						
					case CodeBlock.dtString:
						out[cd.m_Name] = null;
						break;

					case CodeBlock.dtObject:
						out[cd.m_Name] = null;
						break;

					default: out[cd.m_Name] = undefined;
				}
			}
			
			m_Decl.splice(i, 1);
			m_Local[cd.m_Name] = undefined;
		}
	}
	
	public function declConst(name:String, dt:uint, v:*):Boolean
	{
		if (name == null || name.length <= 0) return false;
		if (m_Local != null && m_Local[name] != undefined) return false;

		var cd:CodeCompiler = declNew(name);
		cd.m_Flag = FlagVar | FlagConst | FlagDefaultVal | dt;
		cd.m_DataVal = v;

		return true;
	}
	
	public function saveName(ba:ByteArray, name:String):int
	{
		var oldpos:uint = ba.position;
		ba.position = ba.length;
		var p:int = ba.position;
		ba.writeUTFBytes(name);
		ba.writeByte(0);
		ba.position = oldpos;
		return ba.length - 1 - p;
	}
	
	private static var m_SaveVal:uint = 0;

	public function saveValOrOff(ba:ByteArray, d:CodeCompiler):uint
	{
		var oldpos:uint;
		
		var dt:uint = d.m_Flag & CodeBlock.dtMask;
		m_SaveVal = 0;
		if (!(d.m_Flag & FlagDefaultVal)) {
			if (dt == CodeBlock.dtDword) { }
			else if (dt == CodeBlock.dtInt) { }
			else if (dt == CodeBlock.dtBool) { }
			else if (dt == CodeBlock.dtString) { }
			else { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return CodeBlock.dtNone; }
			return dt;
		}
		
		if (dt == CodeBlock.dtDword) {
			if (!(d.m_DataVal is Number)) { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return CodeBlock.dtNone; }
			if (d.m_DataVal < 256) { m_SaveVal = d.m_DataVal; return CodeBlock.dtByte; }
			else if (d.m_DataVal < 65536) { m_SaveVal = d.m_DataVal; return CodeBlock.dtWord; }
			else {
				oldpos = ba.position;
				ba.position = ba.length;
				m_SaveVal = ba.position;
				ba.writeUnsignedInt(d.m_DataVal);
				ba.position = oldpos;
				return CodeBlock.dtDword;
			}

		} else if (dt == CodeBlock.dtInt) {
			if (!(d.m_DataVal is Number)) { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return CodeBlock.dtNone; }
			if (d.m_DataVal>=-128 && d.m_DataVal<=127) { m_SaveVal = d.m_DataVal; return CodeBlock.dtChar; }
			else if (d.m_DataVal>=-32768 && d.m_DataVal<=32767) { m_SaveVal = d.m_DataVal; return CodeBlock.dtShort; }
			else {
				oldpos = ba.position;
				ba.position = ba.length;
				m_SaveVal = ba.position;
				ba.writeInt(d.m_DataVal);
				ba.position = oldpos;
				return CodeBlock.dtDword;
			}

		} else if (dt == CodeBlock.dtBool) {
			if (!(d.m_DataVal is Boolean)) { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return CodeBlock.dtNone; }
			if (d.m_DataVal) m_SaveVal = 1;
			else m_SaveVal = 0;
			return CodeBlock.dtBool;

		} else if (dt == CodeBlock.dtString) {
			if (!(d.m_DataVal is String)) { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return CodeBlock.dtNone; }
			oldpos = ba.position;
			ba.position = ba.length;
			m_SaveVal = ba.position;
			ba.writeUTF(d.m_DataVal);
			ba.writeByte(0);
			ba.position = oldpos;
			return CodeBlock.dtString;
		}
		m_Src.error(CodeSrc.errNotImplement, d.m_Name);
		return CodeBlock.dtNone;
	}

	public function saveFun(ba:ByteArray, fun:CodeBlock, staticlist:Vector.<CodeCompiler>, dlist:Vector.<CodeCompiler>, extfun:Dictionary):int
	{
		var tbc:CodeBlock;
		tbc = new CodeBlock();
		if (!tbc.decode(fun.m_Code)) { if (m_Src != null) m_Src.error(CodeSrc.errDecode); return 0; }
		
		var i:int, u:int;
		var pc:CodePc;
		var op:uint;
		
		for (i = 0; i < tbc.m_Pc.length; i++) {
			pc = tbc.m_Pc[i];
			op = pc.m_Op;
			if (op & 0xc0) {
				switch(op & 0xf0) {
					case CodeBlock.opCallByName:
						for (u = 0; u < dlist.length; u++) {
							if (dlist[u].m_Name == pc.m_Val) break;
						}
						if (u >= dlist.length) { 
							if (extfun[pc.m_Val] == undefined) { m_Src.error(CodeSrc.errDeclNotFound, pc.m_Val); return 0; }
							pc.m_Op = CodeBlock.opCallByNum | (0xf & op);
							pc.m_Val = uint(0x80000000) | extfun[pc.m_Val];
						} else {
							pc.m_Op = CodeBlock.opCallByNum | (0xf & op);
							pc.m_Val = u;
						}
						break;
				}
			} else {
				switch(op) {
					case CodeBlock.opAssumeVarByName:
						for (u = 0; u < staticlist.length; u++) {
							if (staticlist[u].m_Name == pc.m_Val) break;
						}
						if (u >= staticlist.length) { m_Src.error(CodeSrc.errDeclNotFound, pc.m_Val); return 0; }
						pc.m_Op = CodeBlock.opAssumeVarByNum;
						pc.m_Val = u;
						break;

					case CodeBlock.opPushVarByName:
						for (u = 0; u < staticlist.length; u++) {
							if (staticlist[u].m_Name == pc.m_Val) break;
						}
						if (u >= staticlist.length) { m_Src.error(CodeSrc.errDeclNotFound, pc.m_Val); return 0; }
						pc.m_Op = CodeBlock.opPushVarByNum;
						pc.m_Val = u;
						break;
				}
			}
//trace("op" + i.toString() + ":", pc.m_Op.toString(16));
		}

		tbc.encode();

		var oldpos:uint = ba.position;
		ba.position = ba.length;
		var p:int = ba.position;
		ba.writeBytes(tbc.m_Code);
		ba.position = oldpos;
		return ba.length - p;
	}

	public function save(ba:ByteArray, extfun:Dictionary):void
	{
		var i:int, u:int, k:int, no:int, no2:int;
		var localvarcnt:int;
		var argvarcnt:int;
		var d:CodeCompiler, d2:CodeCompiler;

		ba.position = ba.length;
		var off_begin:uint = ba.length;

		ba.writeShort(0x4345); // id
		ba.writeShort(1); // version
		var off_codeip:uint = ba.position; ba.writeShort(0); // CodeIp
		ba.writeShort(0); // CodeLen
		var off_localvarcnt:uint = ba.position; ba.writeShort(0); // LocalVarCnt
		var off_declcnt:uint = ba.position; ba.writeShort(0); // DeclCnt
		var off_decl:uint = ba.position;
		
		var declcnt:int = 0;
		var declcnt2:int = 0;
		
		const declsize:int = 18;
        const declFun:uint = 1 << 0;
        const declVar:uint = 1 << 1;
        const declArg:uint = 1 << 2;
        const declStatic:uint = 1 << 3;
        const declDefVal:uint = 1 << 4;

		var dlist:Vector.<CodeCompiler> = new Vector.<CodeCompiler>();
		var staticlist:Vector.<CodeCompiler> = new Vector.<CodeCompiler>();

		if (m_Decl != null && m_Decl.length > 0) {
			// Для начало рассчитываем количество
			localvarcnt = 0;

			// локальные переменные
			for (i = 0; i < m_Decl.length; i++) {
				d = m_Decl[i];
				
				if (d.m_Flag & FlagVar) {
					if ((d.m_Flag & CodeBlock.dtMask) == CodeBlock.dtDword) { }
					else if ((d.m_Flag & CodeBlock.dtMask) == CodeBlock.dtInt) { }
					else if ((d.m_Flag & CodeBlock.dtMask) == CodeBlock.dtBool) { }
					else if ((d.m_Flag & CodeBlock.dtMask) == CodeBlock.dtString) { }
					else { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return; }
				}

				if (d.m_Flag & FlagStatic) continue;
				if (d.m_Flag & FlagArg) { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return; }
				if (!(d.m_Flag & FlagVar)) continue;

				dlist.push(d);
				localvarcnt++;
				declcnt++;
			}
			if (localvarcnt != m_LocalVarCnt) throw Error("");
			
			ba.position = off_localvarcnt;
			ba.writeShort(localvarcnt);

			// статические переменные
			for (i = 0; i < m_Decl.length; i++) {
				d = m_Decl[i];
				if (!(d.m_Flag & FlagStatic)) continue;
				if (d.m_Flag & FlagArg) continue;
				if (!(d.m_Flag & FlagVar)) continue;
				
				staticlist.push(d);
				dlist.push(d);
				declcnt++;
			}

			// функции
			for (i = 0; i < m_Decl.length; i++) {
				d = m_Decl[i];
				if (!(d.m_Flag & FlagFun)) continue;

				dlist.push(d);
				declcnt++;

				if (d.m_Decl == null) continue;

				// аргументы
				for (k = 0; k < d.m_Decl.length; k++) {
					d2 = d.m_Decl[k];

					if ((d2.m_Flag & CodeBlock.dtMask) == CodeBlock.dtDword) { }
					else if ((d2.m_Flag & CodeBlock.dtMask) == CodeBlock.dtInt) { }
					else if ((d2.m_Flag & CodeBlock.dtMask) == CodeBlock.dtBool) { }
					else if ((d2.m_Flag & CodeBlock.dtMask) == CodeBlock.dtString) { }
					else { m_Src.error(CodeSrc.errNotImplement, d2.m_Name); return; }

					if (d2.m_Flag & FlagStatic) { m_Src.error(CodeSrc.errNotImplement,d2.m_Name); return; }
					if (!(d2.m_Flag & FlagArg)) continue;
					if (!(d2.m_Flag & FlagVar)) { m_Src.error(CodeSrc.errNotImplement,d2.m_Name); return; }
					declcnt2++;
				}

				// локальные переменные
				for (k = 0; k < d.m_Decl.length; k++) {
					d2 = d.m_Decl[k];
					if (d2.m_Flag & FlagStatic) { m_Src.error(CodeSrc.errNotImplement,d2.m_Name); return; }
					if (d2.m_Flag & FlagArg) continue;
					if (!(d2.m_Flag & FlagVar)) { m_Src.error(CodeSrc.errNotImplement,d2.m_Name); return; }
					declcnt2++;
				}
			}

			// Затем записываем
			ba.position = off_declcnt;
			ba.writeShort(declcnt);
			for (i = 0; i < (declcnt + declcnt2) * declsize; i++) ba.writeByte(0);

			no = 0;
			no2 = 0;
			// локальные переменные
			for (i = 0; i < m_Decl.length; i++) {
				d = m_Decl[i];
				if (d.m_Flag & FlagStatic) continue;
				if (d.m_Flag & FlagArg) { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return; }
				if (!(d.m_Flag & FlagVar)) continue;

				ba.position = off_decl + no * declsize;

				ba.writeByte(declVar); // Flag
				ba.writeByte(d.m_Flag & CodeBlock.dtMask); // DataType
				ba.writeShort(0); // DataValOrOff
				ba.writeShort(ba.length - off_begin); // NameOff
				ba.writeShort(saveName(ba, d.m_Name)); // NameLen
				ba.writeShort(0); // CodeIp
				ba.writeShort(0); // CodeLen
				ba.writeShort(0); // DeclOff
				ba.writeShort(0); // DeclCnt
				ba.writeByte(0); // LocalVarCnt
				ba.writeByte(0); // ArgVarCnt

				no++;
			}

			// статические переменные
			for (i = 0; i < m_Decl.length; i++) {
				d = m_Decl[i];
				if (!(d.m_Flag & FlagStatic)) continue;
				if (d.m_Flag & FlagArg) continue;
				if (!(d.m_Flag & FlagVar)) continue;

				ba.position = off_decl + no * declsize;

				ba.writeByte(declVar | declStatic | ((d.m_Flag & FlagDefaultVal)?declDefVal:0)); // Flag
				ba.writeByte(saveValOrOff(ba, d)); // DataType
				ba.writeShort(m_SaveVal); if (m_Src.err) return; // DataValOrOff
				ba.writeShort(ba.length - off_begin); // NameOff
				ba.writeShort(saveName(ba, d.m_Name)); // NameLen
				ba.writeShort(0); // CodeIp
				ba.writeShort(0); // CodeLen
				ba.writeShort(0); // DeclOff
				ba.writeShort(0); // DeclCnt
				ba.writeByte(0); // LocalVarCnt
				ba.writeByte(0); // ArgVarCnt

				no++;
			}

			// функции
			for (i = 0; i < m_Decl.length; i++) {
				d = m_Decl[i];
				if (!(d.m_Flag & FlagFun)) continue;

				if (d.m_Block == null || d.m_Block.isEmpty) { m_Src.error(CodeSrc.errNotImplement, d.m_Name); return; }

				var f_decloff:uint = 0;
				var f_declcnt:int = 0;
				localvarcnt = 0;
				argvarcnt = 0;

				if (d.m_Decl != null) {
					f_decloff = off_decl + (declcnt + no2) * declsize;

					// аргументы
					for (k = 0; k < d.m_Decl.length; k++) {
						d2 = d.m_Decl[k];
						if (d2.m_Flag & FlagStatic) { m_Src.error(CodeSrc.errNotImplement, d2.m_Name); return; }
						if (!(d2.m_Flag & FlagArg)) continue;
						if (!(d2.m_Flag & FlagVar)) { m_Src.error(CodeSrc.errNotImplement, d2.m_Name); return; }

						ba.position = f_decloff + f_declcnt * declsize;

						ba.writeByte(declVar | declArg | ((d2.m_Flag & FlagDefaultVal)?declDefVal:0)); // Flag
						ba.writeByte(saveValOrOff(ba, d2)); // DataType
						ba.writeShort(m_SaveVal); if (m_Src.err) return; // DataValOrOff
						ba.writeShort(ba.length - off_begin); // NameOff
						ba.writeShort(saveName(ba, d2.m_Name)); // NameLen
						ba.writeShort(0); // CodeIp
						ba.writeShort(0); // CodeLen
						ba.writeShort(0); // DeclOff
						ba.writeShort(0); // DeclCnt
						ba.writeByte(0); // LocalVarCnt
						ba.writeByte(0); // ArgVarCnt

						argvarcnt++;
						f_declcnt++;
						no2++;
					}

					// локальные переменные
					for (k = 0; k < d.m_Decl.length; k++) {
						d2 = d.m_Decl[k];
						if (d2.m_Flag & FlagStatic) { m_Src.error(CodeSrc.errNotImplement, d2.m_Name); return; }
						if (d2.m_Flag & FlagArg) continue;
						if (!(d2.m_Flag & FlagVar)) { m_Src.error(CodeSrc.errNotImplement, d2.m_Name); return; }

						ba.position = f_decloff + f_declcnt * declsize;

						ba.writeByte(declVar); // Flag
						ba.writeByte(d2.m_Flag & CodeBlock.dtMask); // DataType
						ba.writeShort(0); // DataValOrOff
						ba.writeShort(ba.length - off_begin); // NameOff
						ba.writeShort(saveName(ba, d2.m_Name)); // NameLen
						ba.writeShort(0); // CodeIp
						ba.writeShort(0); // CodeLen
						ba.writeShort(0); // DeclOff
						ba.writeShort(0); // DeclCnt
						ba.writeByte(0); // LocalVarCnt
						ba.writeByte(0); // ArgVarCnt

						localvarcnt++;
						f_declcnt++;
						no2++;
					}
				}

				if (localvarcnt != d.m_LocalVarCnt) throw Error("");
				if (argvarcnt != d.m_ArgVarCnt) throw Error("");

				ba.position = off_decl + no * declsize;

				ba.writeByte(declFun); // Flag
				ba.writeByte(d.m_Flag & CodeBlock.dtMask); // DataType
				ba.writeShort(0); // DataValOrOff
				ba.writeShort(ba.length - off_begin); // NameOff
				ba.writeShort(saveName(ba, d.m_Name)); // NameLen
				ba.writeShort(ba.length - off_begin); // CodeIp
				ba.writeShort(saveFun(ba, d.m_Block, staticlist, dlist, extfun)); if (m_Src.err) return; // CodeLen
				ba.writeShort((f_declcnt > 0)?f_decloff:0); // DeclOff
				ba.writeShort(f_declcnt); // DeclCnt
				ba.writeByte(localvarcnt); // LocalVarCnt
				ba.writeByte(argvarcnt); // ArgVarCnt

				no++;
			}

			if (no != declcnt || no2 != declcnt2) throw Error("");
		}

		if (m_Block != null && !m_Block.isEmpty) {
			ba.position = off_codeip;
			ba.writeShort(ba.length - off_begin); // CodeIp
			ba.writeShort(saveFun(ba, m_Block, staticlist, dlist, extfun)); if (m_Src.err) return; // CodeLen
		}

		ba.position = ba.length;
	}
}

}

{
class StackUnit {
	public var m_Op:int; // >0 - бинарный или унарный оператор; -1 - open
	public var m_Val:int;
	public var m_Name:String;
}
}
