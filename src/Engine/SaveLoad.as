package Engine
{
	import flash.utils.*;

	public class SaveLoad
	{
		public var b:ByteArray;
		public var off:uint;
		public var n:int;
		public var m:uint;
		public var type:int;
		
		public function SaveLoad()
		{
			type=0;
		}

		public function SaveBegin(buf:ByteArray):void
		{
			b=buf;
			n=0;
			type=123;
		}

		public function SaveEnd():void
		{
			if(n) {
				var oldp:uint=b.position;
				b.position=off;
				b.writeByte(m);
				b.position=oldp;
			}
			n=0;
			if(type!=123) throw Error("");
			type=0;
		}

		public function LoadBegin(buf:ByteArray):void
		{
			b=buf;
			n=0;
			type=456;
		}

		public function LoadEnd():void
		{
			n=0;
			if(type!=456) throw Error("");
			type=0;
		}

		public function SaveDword(v:uint):void
		{
			if(type!=123) throw Error("");
			
			if(n>=4) {
				var oldp:uint=b.position;
				b.position=off;
				b.writeByte(m);
				b.position=oldp;

				n=0;
			}
			if(!n) { off=b.position; b.writeByte(0); m=0; }
			
			if(v==0) {}
			else if(v<=0xff) { b.writeByte(v); m|=1<<(n<<1); }
			else if(v<=0xffff) { b.writeShort(v); m|=2<<(n<<1); }
			else { b.writeUnsignedInt(v); m|=3<<(n<<1); }
			n++;
		}

		public function SaveInt(v:int):void
		{
			if(type!=123) throw Error("");
			
			if(n>=4) {
				var oldp:uint=b.position;
				b.position=off;
				b.writeByte(m);
				b.position=oldp;
				
				n=0;
			}
			if(!n) { off=b.position; b.writeByte(0); m=0; }
			
			if(v==0) {}
			else if(v>=-128 && v<=127) { b.writeByte(v); m|=1<<(n<<1); }
			else if(v>=-32768 && v<=32767) { b.writeShort(v); m|=2<<(n<<1); }
			else { b.writeInt(v); m|=3<<(n<<1); }
			n++;
		}

		public function LoadDword():uint
		{
			if(type!=456) throw Error("");

			if(!n) m=b.readUnsignedByte();
			var i:int=(m>>(n<<1)) & 3;
			n=(n+1) & 3;

			if(i==0) return 0;
			else if(i==1) return b.readUnsignedByte();
			else if(i==2) return b.readUnsignedShort();
			else return b.readUnsignedInt();
		}

		public function LoadInt():int
		{
			if(type!=456) throw Error("");

			if(!n) m=b.readUnsignedByte();
			var i:int=(m>>(n<<1)) & 3;
			n=(n+1) & 3;

			if(i==0) return 0;
			else if(i==1) return b.readByte();
			else if(i==2) return b.readShort();
			else return b.readInt();
		}
	}
}
