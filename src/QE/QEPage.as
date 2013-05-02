package QE
{

public class QEPage
{
	public var m_Name:String = null;
	public var m_Quest:QEQuest = null;
	public var m_If:Object = null;
	public var m_TextList:Vector.<QEText> = null;
	
	public var m_AnswerList:Vector.<QEAnswer> = null;
	
	public var m_SrcLine:int = -1;

	public function QEPage():void
	{
	}
}

}