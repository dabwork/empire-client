package Engine
{
import flash.display3D.textures.Texture;
import flash.utils.Dictionary;

public class C3DFont
{
	public var m_Texture:C3DTexture = null;
	public var m_GlyphMap:Array = new Array();
	public var m_KerningMap:Dictionary = new Dictionary();
	
	public var lineHeight:int = 0;
	public var base:int = 0;
	public var scaleW:int = 0;
	public var scaleH:int = 0;
	public var outline:Boolean = false;
	
	public function C3DFont(tex:C3DTexture)
	{
		m_Texture = tex;
	}

	public function ParseFont(fontDesc:String):void
	{
		var fontLines:Array = fontDesc.split("\n");
		for (var i:int = 0; i < fontLines.length; i++) {
			var fontLine:Array = (fontLines[i] as String).split(" ");
			var keyWord:String = (fontLine[0] as String).toLowerCase();
			if (keyWord == "char") { ParseChar(fontLine); continue; }
			else if (keyWord == "info") { ParseInfo(fontLine); continue; }
			else if (keyWord == "common") { ParseCommon(fontLine); continue; }
			else if (keyWord == "kerning") { ParseKerning(fontLine); continue; }
		}
	}

	protected function ParseInfo(charLine:Array):void
	{
		for (var i:int = 1; i < charLine.length; i++) {
			var charEntry:Array = (charLine[i] as String).split("=");
			if (charEntry.length != 2) continue;
			
			if (charEntry[0] == "outline") outline = int(charEntry[1]) != 0;
		}
	}

	protected function ParseCommon(charLine:Array):void
	{
		for (var i:int = 1; i < charLine.length; i++) {
			var charEntry:Array = (charLine[i] as String).split("=");
			if (charEntry.length != 2) continue;

			var charKey:String = charEntry[0];
			var charVal:String = charEntry[1];
			
			if (hasOwnProperty(charKey)) this[charKey] = charVal;
		}
	}

	protected function ParseChar(charLine:Array):void
	{
		var g:C3DFontGlyph = new C3DFontGlyph();

		for (var i:int = 1; i < charLine.length; i++) {
			var charEntry:Array = (charLine[i] as String).split("=");
			if (charEntry.length != 2) continue;

			var charKey:String = charEntry[0];
			var charVal:String = charEntry[1];

			if(g.hasOwnProperty(charKey)) g[charKey] = charVal;
		}

		m_GlyphMap[g.id] = g;
	}
	
	protected function ParseKerning(charLine:Array):void
	{
		var first:uint = 0;
		var second:uint = 0;
		var amount:int = 0;
		for (var i:int = 1; i < charLine.length; i++) {
			var charEntry:Array = (charLine[i] as String).split("=");
			if (charEntry.length != 2) continue;

			if (charEntry[0] == "first") first = uint(charEntry[1]);
			else if (charEntry[0] == "second") second = uint(charEntry[1]);
			else if (charEntry[0] == "amount") amount = int(charEntry[1]);
		}
		if (first >= 65536 || second >= 65536) return;
		m_KerningMap[(first << 16) | second] = amount;
	}
	
}

}
