// Copyright (C) 2013 Elemental Games. All rights reserved.

package Base
{
import flash.utils.ByteArray;
	
public class CRC32
{
	private static var crcTable:Vector.<uint> = makeCrcTable();
	private static var m_TmpBuf:ByteArray = new ByteArray();
        
	private static function makeCrcTable():Vector.<uint>
	{
		var crcTable:Vector.<uint> = new Vector.<uint>(256);
		for (var n:int = 0; n < 256; n++) {
			var c:uint = n;
			for (var k:int = 8; --k >= 0; ) {
				if((c & 1) != 0) c = 0xedb88320 ^ (c >>> 1);
				else c = c >>> 1;
			}
			crcTable[n] = c;
		}
		return crcTable;
	}
	
	public static function calcRaw(crc:uint, buf:ByteArray):uint
	{
		var off:uint = 0;
		var len:uint = buf.length;
		var c:uint = ~crc;
		while (--len >= 0) c = crcTable[(c ^ buf[off++]) & 0xff] ^ (c >>> 8);
		crc = ~c;
		return crc;
	}
	
	public static function calc(crc:uint, str:String):uint
	{
		m_TmpBuf.length = 0;
		m_TmpBuf.writeUTFBytes(str);
		return calcRaw(crc, m_TmpBuf);
	}

}
	
}