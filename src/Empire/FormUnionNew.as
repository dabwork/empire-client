package Empire
{
import Base.*;
import Engine.*;
import fl.controls.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;
import flash.net.*;

public class FormUnionNew extends FormUnionNewClass
{
	private var m_Map:EmpireMap;
	
	public var m_Access:Boolean=true;

	public function FormUnionNew(map:EmpireMap)
	{
		m_Map=map;
		
		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);

		ButCancel.addEventListener(MouseEvent.CLICK, clickCancel);
		ButCreate.addEventListener(MouseEvent.CLICK, clickCreate);
		
		addEventListener(MouseEvent.MOUSE_MOVE, obMouseMove);
		
		EditType.rowCount = 10;
		EditType.addItem( { label:Common.UnionTypeName[Common.UnionTypeAlliance], data:Common.UnionTypeAlliance } );
		EditType.addItem( { label:Common.UnionTypeName[Common.UnionTypePirate], data:Common.UnionTypePirate } );
		EditType.addItem( { label:Common.UnionTypeName[Common.UnionTypeClan], data:Common.UnionTypeClan } );
		EditType.addItem( { label:Common.UnionTypeName[Common.UnionTypeMercenary], data:Common.UnionTypeMercenary } );
		EditType.addItem( { label:Common.UnionTypeName[Common.UnionTypeTrader], data:Common.UnionTypeTrader } );
		EditType.addItem( { label:Common.UnionTypeName[Common.UnionTypeEmpire], data:Common.UnionTypeEmpire } );
		EditType.addItem( { label:Common.UnionTypeName[Common.UnionTypeRepublic], data:Common.UnionTypeRepublic } );
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		if(ButCancel.hitTestPoint(e.stageX,e.stageY)) return;
		if (ButCreate.hitTestPoint(e.stageX, e.stageY)) return;
		if (EditType.hitTestPoint(e.stageX, e.stageY)) return;
		if(EditName.hitTestPoint(e.stageX,e.stageY)) return;
		if(EditNameEng.hitTestPoint(e.stageX,e.stageY)) return;
		
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}
	
	public function obMouseMove(e:MouseEvent):void
	{
		m_Map.m_Info.Hide();
	}
	
	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) Show();
		x = Math.ceil(parent.stage.stageWidth / 2 - width / 2);
		y = Math.ceil(parent.stage.stageHeight / 2 - height / 2);
	}
	
	public function Hide():void
	{
		visible=false;
	}

	public function Show():void
	{
		var str:String;
		
		if(!m_Access) return;

		Common.UIStdLabel(LabelCaption,18,0xffffff);
		Common.UIStdLabel(LabelDesc, 13, 0xAfAfAf);
		Common.UIStdLabel(LabelType);
		Common.UIStdLabel(LabelName);
		Common.UIStdLabel(LabelNameEng);
		Common.UIStdBut(ButCreate);
		Common.UIStdBut(ButCancel);
		Common.UIStdComboBox(EditType);
		Common.UIStdInput(EditName);
		Common.UIStdInput(EditNameEng);
		
		EditType.selectedIndex = EditType.length-1;
		
		EditName.text='';
		EditName.textField.maxChars = 30;
		EditName.textField.restrict = "0-9 A-Za-zА-Яа-яЁё"; 
		EditNameEng.text='';
		EditNameEng.textField.restrict = "0-9 A-Za-z";
		EditNameEng.textField.maxChars=30;

		LabelCaption.text = Common.Txt.UnionNewCaption;
		LabelType.text=Common.Txt.UnionNewType+":";
		LabelName.text=Common.Txt.UnionNewCptName+":";
		LabelNameEng.text=Common.Txt.UnionNewCptNameEng+":";
		
		str=Common.Txt.UnionNewDesc;
		LabelDesc.htmlText=BaseStr.Replace(str,"<Val>",BaseStr.FormatBigInt(Common.CostNewUnion));

		ButCancel.label=Common.Txt.ButCancel;
		ButCreate.label=Common.Txt.UnionNewCreate;

		visible=true;

		StageResize();
	}

	private function clickCancel(event:MouseEvent):void
	{
		Hide();
	}

	private function clickCreate(event:MouseEvent):void
	{
		if(!m_Access) return;
		if(m_Map.m_UserEGM<Common.CostNewUnion) {
			FormMessageBox.Run(Common.Txt.NoEnoughEGM2,Common.Txt.ButClose);
			return;
		}
		
        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"name\"\r\n\r\n";
        d+=EditName.text+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"nameeng\"\r\n\r\n";
        d+=EditNameEng.text+"\r\n"

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"type\"\r\n\r\n";
        d += EditType.selectedItem.data + "\r\n"

        d+="--"+boundary+"--\r\n";

		m_Access=false;
		
        Server.Self.QueryPost("emunionnew","",d,boundary,RecvUnionNew,false);

        Hide();
	}

	public function RecvUnionNew(event:Event):void
	{
		m_Access=false;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int=buf.readUnsignedByte();
		if(err==Server.ErrorExistName) {
			FormMessageBox.Run(Common.Txt.UnionErrExistName,Common.Txt.ButClose);
			return;
		} else if(err==Server.ErrorExistNameEng) {
			FormMessageBox.Run(Common.Txt.UnionErrExistNameEng,Common.Txt.ButClose);
			return;	
		} else if(err==Server.ErrorNoEnoughEGM) {
			FormMessageBox.Run(Common.Txt.NoEnoughEGM2,Common.Txt.ButClose);
			return;
		} else if(err) {
			m_Map.ErrorFromServer(err);
			return;
		}

		m_Map.m_UnionId=buf.readUnsignedInt();

		UserList.Self.GetUnion(m_Map.m_UnionId);
//trace(m_Map.m_UnionId);
	}
}

}
