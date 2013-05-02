package Base
{
import flash.utils.*;

public class Code
{
	public static const errOpcode:int = 1;
	public static const errNotImplement:int = 2;
	public static const errStack:int = 3;
	public static const errNameNotFound:int = 4;
	public static const errArgFunCnt:int = 5;
	public static const errNotFun:int = 6;
	public static const errOutRange:int = 7;
	public static const errNeedPrepare:int = 8;
	public static const errIsNotObject:int = 9;
	public static const errNotFoundProperty:int = 10;

	public var m_Env:CodeCompiler = null;
	public var m_Global:Array = new Array();
	public var m_This:Object = null;

	//public var m_Stack:Vector.<*>=null; - в векторе не могут undefined переменные содержаться
	public var m_Stack:Array = null;
	public var m_StackLen:int = 0;
	public var m_StackMax:int = 0;
	
	public var m_SysArg:Array = new Array();

	public var m_Error:int = 0;
	public var m_ErrorName:String = null;
	public var m_Line:int = -1;

	//[Inline]
	final public function error(v:int, name:String=null):void
	{
		m_Error = v;
		m_ErrorName = name;
	}
	public function get err():int { return m_Error; }
	public function get errName():String { return m_ErrorName; }
	
	public function importMethod(name:String, fun:Function):void
	{
		m_Global[name] = fun;
	}

	public function importStaticMethods(cd:Class):void
	{
		var desc:XML = null;
		var name:String = null;
		var list:* = describeType(cd);
		for each (desc in list.method) {
			name = desc.@name;

			m_Global[name] = cd[name];
		}
	}

	[Inline] final public function stackPushInt(v:int):void
	{
		if (m_StackLen >= m_StackMax) { m_StackMax += 16; m_Stack.length = m_StackMax; }
		m_Stack[m_StackLen++] = v;
	}
	
	[Inline] final public function stackPushUint(v:int):void
	{
		if (m_StackLen >= m_StackMax) { m_StackMax += 16; m_Stack.length = m_StackMax; }
		m_Stack[m_StackLen++] = v;
	}

	[Inline] final public function stackPush(v:*):void
	{
		if (m_StackLen >= m_StackMax) { m_StackMax += 16; m_Stack.length = m_StackMax; }
		m_Stack[m_StackLen++] = v;
	}

	[Inline] final public function stackRemoveOne():Boolean
	{
		if (m_StackLen < 1) return false;
		m_Stack[m_StackLen - 1] = undefined;
		m_StackLen--;
		return true;
	}

//	[Inline]
	final public function stackRemove(cnt:int=1):Boolean
	{
		if (m_StackLen < cnt) return false;
		while (cnt > 0) {
			m_Stack[m_StackLen - 1] = undefined;
			m_StackLen--;
			cnt--;
		}
		return true;
	}

	[Inline] final public function stackPrepareVar(cnt:int):void
	{
		if (m_StackLen + cnt > m_StackMax) {
			m_StackMax = m_StackLen + cnt + 16;
			if (m_StackMax & (16 - 1)) m_StackMax = (m_StackMax & ~(16 - 1)) + 16;
			m_Stack.length = m_StackMax;
		}
		m_StackLen += cnt;
	}
	
	public function runBlock(stack_var_begin:int, d:ByteArray, cc:CodeCompiler):void
	{
		var op:uint, dw:uint;
		var len:int, off:int;
		var name:String;
		var cd:CodeCompiler, cd2:CodeCompiler;
		var i:int, u:int, k:int;
		var r:*;
		var fun:Function;

		var stack_exp_begin:int = m_StackLen;

		while (d.position < d.length) {
			op = d.readUnsignedByte();
			if (op & 0xc0) {
				switch(op & 0xf0) {
					case CodeBlock.opPushDef:
						switch(op&15) {
							case CodeBlock.defZero: stackPushInt(0); break;
							case CodeBlock.defOne: stackPushInt(1); break;
							case CodeBlock.defTwo: stackPushInt(2); break;
							case CodeBlock.defTen: stackPushInt(10); break;
							case CodeBlock.defMOne: stackPushInt( -1); break;
							case CodeBlock.defMTwo: stackPushInt( -2); break;
							case CodeBlock.defMTen: stackPushInt( -10); break;
							case CodeBlock.defNull: stackPush( null); break;
							case CodeBlock.defUndefined: stackPush( undefined); break;
							case CodeBlock.defTrue: stackPush( true); break;
							case CodeBlock.defFalse: stackPush( false); break;
							default: error(errOpcode); return;
						}
						break;

					case CodeBlock.opPushConst:
						switch(op & 15) {
							case CodeBlock.dtByte: stackPushUint(d.readUnsignedByte()); break;
							case CodeBlock.dtWord: stackPushUint(d.readUnsignedShort()); break;
							case CodeBlock.dtDword: stackPushUint(d.readUnsignedInt()); break;
							case CodeBlock.dtChar: stackPushInt(d.readByte()); break;
							case CodeBlock.dtShort: stackPushInt(d.readShort()); break;
							case CodeBlock.dtInt: stackPushInt(d.readInt()); break;
							default: error(errOpcode); return;
						}
						break;

					case CodeBlock.opCallByName:
						op &= 15;
						len = d.readUnsignedByte();
						name = d.readUTFBytes(len);

						cd = cc.findEnvName(name);
						if (cd == null && m_Env != null) cd = m_Env.findEnvName(name);
						if (cd != null) {
							if (!(cd.m_Flag & CodeCompiler.FlagFun)) { error(errNotFun, name); return; }

							if (cd.m_ArgVarCnt < 0) { error(errNeedPrepare); return; }
							if (op > cd.m_ArgVarCnt) { error(errArgFunCnt, name); return; }
							if (m_StackLen - stack_exp_begin < op) { error(errStack); return; }
							u = op;
							if(op<cd.m_ArgVarCnt) {
								for (i = 0; i < cd.m_Decl.length; i++) {
									cd2 = cd.m_Decl[i];
									if ((cd2.m_Flag & (CodeCompiler.FlagVar | CodeCompiler.FlagArg)) != (CodeCompiler.FlagVar | CodeCompiler.FlagArg)) continue;
									u = cd.m_ArgVarCnt + cd2.m_Num;
									if (u < op) continue;
									if ((cd2.m_Flag & CodeCompiler.FlagDefaultVal) == 0) { error(errArgFunCnt, name); return; }

									stackPush(cd2.m_DataVal);
									u++;
								}
							}
							r = runFun(cd);
							if (err) return;

							stackRemove(u);

							stackPush(r);
							r = undefined;

							break;
						}

						r = m_Global[name];
						if (r != undefined)  {
							if (!(r is Function)) { error(errNotFun, name); return; }
							fun = r;
							//var xt:*= describeType(r);
							if (m_StackLen - stack_exp_begin < op) { error(errStack); return; }
							m_SysArg.length = op;
							for (i = 0; i < op; i++) m_SysArg[i] = m_Stack[m_StackLen - op + i];
							r = fun.apply(undefined, m_SysArg);
							
							stackRemove(op);

							stackPush(r);
							r = undefined;

							break;
						}

						error(errNameNotFound, name); return;
						break;

					case CodeBlock.opJump:
						if (op & CodeBlock.jmpLong) off = d.readShort();
						else off = d.readByte();
						
						switch(op & 14) {
							case CodeBlock.jmpGoTo: d.position = d.position + off; break;
							case CodeBlock.jmpIf:
								if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
								if (m_Stack[m_StackLen - 1]) d.position = d.position + off;
								break;
							case CodeBlock.jmpIfNot:
								if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
								if (!m_Stack[m_StackLen - 1]) d.position = d.position + off;
								break;
							
							default: error(errNotImplement); return;
						}
						
						break;

					case CodeBlock.opDesc:
					case CodeBlock.opDescFor:
						switch(op & 3) {
							case 0: m_Line = 0; break;
							case 1: m_Line = d.readUnsignedByte(); break;
							case 2: m_Line = d.readUnsignedShort(); break;
							case 3: m_Line = d.readUnsignedInt(); break;
						}
						while (m_StackLen > stack_exp_begin) {
							m_Stack[m_StackLen - 1] = undefined;
							m_StackLen--;
						}
						break;

					case CodeBlock.opPushLocal:
						if (op & 8) off = int(op & 7) - 4;
						else
						switch(op & 3) {
							case 0: off = 0; break;
							case 1: off = d.readByte(); break;
							case 2: off = d.readShort(); break;
							case 3: off = d.readInt(); break;
						}
						if (off < -cc.m_ArgVarCnt || off >= cc.m_LocalVarCnt) { error(errOutRange); return; }

						stackPush(m_Stack[stack_var_begin + off]);
						break;

					case CodeBlock.opAssumeLocal:
						if (op & 8) off = int(op & 7) - 4;
						else
						switch(op & 3) {
							case 0: off = 0; break;
							case 1: off = d.readByte(); break;
							case 2: off = d.readShort(); break;
							case 3: off = d.readInt(); break;
						}
						if (off < -cc.m_ArgVarCnt || off >= cc.m_LocalVarCnt) { error(errOutRange); return; }

						m_Stack[stack_var_begin + off] = m_Stack[m_StackLen - 1];
						break;

					default: error(errNotImplement); return;
				}
			} else {
				switch(op) {
					case CodeBlock.opNop:
						break;

					case CodeBlock.opWait:
						break;

					case CodeBlock.opPlus:
						if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
						m_Stack[m_StackLen - 1] = +m_Stack[m_StackLen - 1];
						break;

					case CodeBlock.opMinus:
						if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
						m_Stack[m_StackLen - 1] = -m_Stack[m_StackLen - 1];
						break;

					case CodeBlock.opNot:
						if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
						m_Stack[m_StackLen - 1] = ~m_Stack[m_StackLen - 1];
						break;

					case CodeBlock.opBoolNot:
						if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
						m_Stack[m_StackLen - 1] = !m_Stack[m_StackLen - 1];
						break;

					case CodeBlock.opBool:
						if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
						m_Stack[m_StackLen - 1] = Boolean(m_Stack[m_StackLen - 1]);
						break;

					case CodeBlock.opAdd:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] += m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opSub:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] -= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opAnd:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] &= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opOr:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] |= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opXor:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] ^= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opShl:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] <<= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opShr:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] >>= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opMul:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] *= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opDiv:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] = m_Stack[m_StackLen - 2] / m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opMod:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2] %= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opBoolOr:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2]	= m_Stack[m_StackLen - 2] || m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opBoolAnd:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2]	= m_Stack[m_StackLen - 2] && m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opLess:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2]	= m_Stack[m_StackLen - 2] < m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opMore:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2]	= m_Stack[m_StackLen - 2] > m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opEqual:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2]	= m_Stack[m_StackLen - 2] == m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opNotEqual:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2]	= m_Stack[m_StackLen - 2] != m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opLessEqual:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2]	= m_Stack[m_StackLen - 2] <= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;

					case CodeBlock.opMoreEqual:
						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						m_Stack[m_StackLen - 2]	= m_Stack[m_StackLen - 2] >= m_Stack[m_StackLen - 1];
						if(!stackRemoveOne()) { error(errStack); return; }
						break;
						
					case CodeBlock.opPushConstStr:
						stackPush(d.readUTF());
						d.position = d.position + 1;
						break;

					case CodeBlock.opPushVarByName:
						len = d.readUnsignedByte();
						name = d.readUTFBytes(len);

						if (m_This != null && m_This.hasOwnProperty(name)) {
							stackPush(m_This[name]);
							break;
						}

//						if (cc.m_Local != null) {
//							cd = cc.m_Local[name];
//							if (cd != null) {
//								if(!(cd.m_Flag & CodeCompiler.FlagVar)) { error(errNotImplement); return; }
//								stackPush(m_Stack[stack_var_begin + cd.m_Num]);
//								break;
//							}
//						}

						error(errNameNotFound, name); return;
						break;

					case CodeBlock.opAssumeVarByName:
						len = d.readUnsignedByte();
						name = d.readUTFBytes(len);

						if (m_This != null && m_This.hasOwnProperty(name)) {
							if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
							m_This[name]=m_Stack[m_StackLen - 1];
							break;
						}

//						if (cc.m_Local != null) {
//							cd = cc.m_Local[name];
//							if (cd != null) {
//								if(!(cd.m_Flag & CodeCompiler.FlagVar)) { error(errNotImplement); return; }
//								m_Stack[stack_var_begin + cd.m_Num] = m_Stack[m_StackLen - 1];
//								break;
//							}
//						}

						error(errNameNotFound, name); return;
						break;
						
					case CodeBlock.opPushMemberVarByName:
					case CodeBlock.opReplaceMemberVarByName:
						len = d.readUnsignedByte();
						name = d.readUTFBytes(len);

						if (m_StackLen - stack_exp_begin < 1) { error(errStack); return; }
						r = m_Stack[m_StackLen - 1];
						if (!(r is Object)) { error(errIsNotObject); return; }
						if (!r.hasOwnProperty(name)) { error(errNotFoundProperty); }
						
						if (op == CodeBlock.opReplaceMemberVarByName) stackRemoveOne();
						stackPush(r[name]);

						break;
						
					case CodeBlock.opAssumeMemberVarByName:
						len = d.readUnsignedByte();
						name = d.readUTFBytes(len);

						if (m_StackLen - stack_exp_begin < 2) { error(errStack); return; }
						r = m_Stack[m_StackLen - 2];
						if (!(r is Object)) { error(errIsNotObject); return; }
						if (!r.hasOwnProperty(name)) { error(errNotFoundProperty); }

						r[name] = m_Stack[m_StackLen - 1];
						
						m_Stack[m_StackLen - 2] = m_Stack[m_StackLen - 1];
						stackRemoveOne();
						break;
						
					default: error(errNotImplement); return;
				}
			}
		}
	}
	
	public function runFun(cc:CodeCompiler):*
	{
		var i:int, u:int, k:int;
		var cc2:CodeCompiler;
		var cd:CodeCompiler;
		var d:ByteArray;

		if (m_Stack == null) m_Stack = new Array();
		//if (m_Stack == null) m_Stack = new Vector.<*>();

		var stack_var_begin:int = m_StackLen;
		if (cc.m_LocalVarCnt > 0) stackPrepareVar(cc.m_LocalVarCnt);

		var stack_exp_begin:int = m_StackLen;

		if (cc.m_Block != null && !cc.m_Block.isEmpty) {
			d = cc.m_Block.m_Code;
			d.position = 0;
			runBlock(stack_var_begin, d, cc); if (err) return;
		}

		var ret:*= undefined;

		if (m_StackLen > stack_exp_begin) {
			ret = m_Stack[m_StackLen - 1];
		}

		for (i = m_StackLen - 1; i >= stack_var_begin; i--) {
			m_Stack[i] = undefined;
			m_StackLen--;
		}

		return ret;
	}
}

}