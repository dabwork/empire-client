package B3DEffect
{
import Base.*;
import Engine.*;

public class TextureStyle
{
	public var m_Id:String = "";
	public var m_Path:String = null;
	public var m_ChannelMask:Boolean = false;
	public var m_ImgList:Vector.<ImgStyle> = new Vector.<ImgStyle>();

	public function TextureStyle():void
	{
	}

	public function ImgById(id:String):ImgStyle
	{
		var i:int;
		for (i = 0; i < m_ImgList.length; i++) {
			if (m_ImgList[i].m_Id == id) return m_ImgList[i];
		}
		return null;
	}
}

}