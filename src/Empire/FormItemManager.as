package Empire
{
import Base.*;
import Engine.*;
import fl.containers.*;
import fl.controls.*;
import fl.controls.dataGridClasses.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormItemManager extends Sprite
{
	private var m_Map:EmpireMap;

	static public const SizeX:int=650;
	static public const SizeY:int=500;

	public var m_LabelCaption:TextField=null;
	public var m_ButClose:Button=null;
	public var m_ButImg:Button=null;
	public var m_LvlLabel:TextField=null;
	public var m_LvlMin:TextInput=null;
	public var m_LvlMax:TextInput=null;
	public var m_SlotTypeLabel:TextField=null;
	public var m_SlotType:ComboBox=null;
	public var m_SearchLabel:TextField=null;
	public var m_SearchEdit:TextInput=null;
	public var m_ButQuery:Button=null;
	public var m_ItemList:DataGrid=null;

	public function FormItemManager(map:EmpireMap)
	{
		m_Map=map;

		var fr:GrFrame=new GrFrame();
		fr.width=SizeX;
		fr.height=SizeY;
		addChild(fr);

		m_LabelCaption=new TextField();
		m_LabelCaption.x=10;
		m_LabelCaption.y=5;
		m_LabelCaption.width=1;
		m_LabelCaption.height=1;
		m_LabelCaption.type=TextFieldType.DYNAMIC;
		m_LabelCaption.selectable=false;
		m_LabelCaption.border=false;
		m_LabelCaption.background=false;
		m_LabelCaption.multiline=false;
		m_LabelCaption.autoSize=TextFieldAutoSize.LEFT;
		m_LabelCaption.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelCaption.gridFitType=GridFitType.PIXEL;
		m_LabelCaption.defaultTextFormat=new TextFormat("Calibri",18,0xffffff);
		m_LabelCaption.embedFonts=true;
		m_LabelCaption.text=Common.TxtEdit.FormItemManagerCpation;
		addChild(m_LabelCaption);

		m_ButClose=new Button();
		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width=100;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x=SizeX-10-m_ButClose.width;
		m_ButClose.y=SizeY-10-m_ButClose.height;
		addChild(m_ButClose);

		m_ButImg=new Button();
		m_ButImg.label = "Img";
		m_ButImg.width=100;
		Common.UIStdBut(m_ButImg);
		m_ButImg.addEventListener(MouseEvent.CLICK, clickImg);
		m_ButImg.x=10
		m_ButImg.y=SizeY-10-m_ButImg.height;
		addChild(m_ButImg);

		m_LvlLabel=new TextField();
		m_LvlLabel.x=10;
		m_LvlLabel.y=40;
		m_LvlLabel.width=1;
		m_LvlLabel.height=1;
		m_LvlLabel.type=TextFieldType.DYNAMIC;
		m_LvlLabel.selectable=false;
		m_LvlLabel.border=false;
		m_LvlLabel.background=false;
		m_LvlLabel.multiline=false;
		m_LvlLabel.autoSize=TextFieldAutoSize.LEFT;
		m_LvlLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_LvlLabel.gridFitType=GridFitType.PIXEL;
		m_LvlLabel.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_LvlLabel.embedFonts=true;
		m_LvlLabel.text="Lvl:";
		addChild(m_LvlLabel);

		m_LvlMin=new TextInput();
		m_LvlMin.x=m_LvlLabel.x+m_LvlLabel.width+5;
		m_LvlMin.y=m_LvlLabel.y;
		m_LvlMin.width=70;
		m_LvlMin.setStyle("focusRectSkin", focusRectSkinNone);
		m_LvlMin.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		m_LvlMin.setStyle("embedFonts", true);
		m_LvlMin.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_LvlMin.textField.gridFitType=GridFitType.PIXEL;
		m_LvlMin.textField.restrict = "0-9";
		m_LvlMin.textField.maxChars = 9;
		m_LvlMin.text="";
		addChild(m_LvlMin);

		m_LvlMax=new TextInput();
		m_LvlMax.x=m_LvlMin.x+m_LvlMin.width+5;
		m_LvlMax.y=m_LvlMin.y;
		m_LvlMax.width=70;
		m_LvlMax.setStyle("focusRectSkin", focusRectSkinNone);
		m_LvlMax.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		m_LvlMax.setStyle("embedFonts", true);
		m_LvlMax.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_LvlMax.textField.gridFitType=GridFitType.PIXEL;
		m_LvlMax.textField.restrict = "0-9";
		m_LvlMax.textField.maxChars = 9;
		m_LvlMax.text="";
		addChild(m_LvlMax);

		m_SlotTypeLabel=new TextField();
		m_SlotTypeLabel.x=m_LvlMax.x+m_LvlMax.width+15;
		m_SlotTypeLabel.y=m_LvlMax.y;
		m_SlotTypeLabel.width=1;
		m_SlotTypeLabel.height=1;
		m_SlotTypeLabel.type=TextFieldType.DYNAMIC;
		m_SlotTypeLabel.selectable=false;
		m_SlotTypeLabel.border=false;
		m_SlotTypeLabel.background=false;
		m_SlotTypeLabel.multiline=false;
		m_SlotTypeLabel.autoSize=TextFieldAutoSize.LEFT;
		m_SlotTypeLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_SlotTypeLabel.gridFitType=GridFitType.PIXEL;
		m_SlotTypeLabel.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_SlotTypeLabel.embedFonts=true;
		m_SlotTypeLabel.text="Slot:";
		addChild(m_SlotTypeLabel);
		
		m_SlotType=new ComboBox();
		m_SlotType.x=m_SlotTypeLabel.x+m_SlotTypeLabel.width+5;
		m_SlotType.y=m_SlotTypeLabel.y;
		m_SlotType.width=100;
		Common.UIStdComboBox(m_SlotType);
		m_SlotType.rowCount=20;
		m_SlotType.addItem( { label:" ", data:-1 } );
		m_SlotType.addItem( { label:"None", data:Common.HoldSlotTypeNone } );
		m_SlotType.addItem( { label:"Blue", data:Common.HoldSlotTypeBlue } );
		m_SlotType.addItem( { label:"Green", data:Common.HoldSlotTypeGreen } );
		m_SlotType.addItem( { label:"Red", data:Common.HoldSlotTypeRed } );
		m_SlotType.addItem( { label:"Yellow", data:Common.HoldSlotTypeYellow } );
		m_SlotType.selectedIndex=0;
		addChild(m_SlotType);

		m_SearchLabel=new TextField();
		m_SearchLabel.x=m_SlotType.x+m_SlotType.width+15;
		m_SearchLabel.y=m_SlotType.y;
		m_SearchLabel.width=1;
		m_SearchLabel.height=1;
		m_SearchLabel.type=TextFieldType.DYNAMIC;
		m_SearchLabel.selectable=false;
		m_SearchLabel.border=false;
		m_SearchLabel.background=false;
		m_SearchLabel.multiline=false;
		m_SearchLabel.autoSize=TextFieldAutoSize.LEFT;
		m_SearchLabel.antiAliasType=AntiAliasType.ADVANCED;
		m_SearchLabel.gridFitType=GridFitType.PIXEL;
		m_SearchLabel.defaultTextFormat=new TextFormat("Calibri",13,0xffffff);
		m_SearchLabel.embedFonts=true;
		m_SearchLabel.text="Search:";
		addChild(m_SearchLabel);
		
		m_SearchEdit=new TextInput();
		m_SearchEdit.x=m_SearchLabel.x+m_SearchLabel.width+5;
		m_SearchEdit.y=m_SearchLabel.y;
		m_SearchEdit.width=100;
		m_SearchEdit.setStyle("focusRectSkin", focusRectSkinNone);
		m_SearchEdit.setStyle("textFormat", new TextFormat("Calibri",13,0xc4fff2));
		m_SearchEdit.setStyle("embedFonts", true);
		m_SearchEdit.textField.antiAliasType=AntiAliasType.ADVANCED;
		m_SearchEdit.textField.gridFitType=GridFitType.PIXEL;
		m_SearchEdit.textField.maxChars = 100;
		m_SearchEdit.text="";
		addChild(m_SearchEdit);

		m_ButQuery=new Button();
		m_ButQuery.label = "Query";
		m_ButQuery.width=80;
		Common.UIStdBut(m_ButQuery);
		m_ButQuery.addEventListener(MouseEvent.CLICK, clickQuery);
		m_ButQuery.x=SizeX-10-m_ButClose.width;
		m_ButQuery.y=m_SearchEdit.y;
		addChild(m_ButQuery);

		m_ItemList=new DataGrid();
		m_ItemList.x=10;
		m_ItemList.y=70;
		m_ItemList.width=SizeX-20;
		m_ItemList.height=m_ButClose.y-10-m_ItemList.y;
		addChild(m_ItemList);

//		m_ItemList.addEventListener(Event.CHANGE,onMemberListChange);

		m_ItemList.setStyle("skin",ListOnlineUser_skin);
		m_ItemList.setStyle("cellRenderer",ItemListRenderer);
		
		m_ItemList.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
		m_ItemList.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
		m_ItemList.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
		m_ItemList.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);
		
		m_ItemList.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
		m_ItemList.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
		m_ItemList.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
		m_ItemList.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
		m_ItemList.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);
		
		m_ItemList.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
		m_ItemList.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
		m_ItemList.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
		m_ItemList.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);
		
		m_ItemList.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
		m_ItemList.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
		m_ItemList.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
		m_ItemList.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);
		
		m_ItemList.setStyle("headerTextFormat",new TextFormat("Calibri",14,0xffffff));
		m_ItemList.setStyle("headerУmbedFonts", true);
		m_ItemList.setStyle("headerTextPadding", 5);
		
		m_ItemList.rowHeight=22;

		var col:DataGridColumn;
		col=new DataGridColumn("Id"); col.headerText="Id"; col.width=80; m_ItemList.addColumn(col);
		col=new DataGridColumn("Name"); col.headerText="Name"; col.width=160; m_ItemList.addColumn(col);
		col=new DataGridColumn("Lvl"); col.headerText="Lvl"; col.width=80; m_ItemList.addColumn(col);
		col=new DataGridColumn("Slot"); col.headerText="Slot"; col.width=80; m_ItemList.addColumn(col);
		col=new DataGridColumn("Owner"); col.headerText="Owner"; col.width=160; m_ItemList.addColumn(col);
		m_ItemList.minColumnWidth=30;

		m_ItemList.doubleClickEnabled=true; 
		m_ItemList.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClickItemList);
		m_ItemList.addEventListener(Event.CHANGE,onItemChange);

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
//		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	
	public function IsScroll():Boolean
	{
		return false;
		// Заглушка так как неправильно устанавливается обработчик а UIScrollBar
		if (!visible) return false;
		
		if (!m_ItemList.verticalScrollBar.mouseChildren) return true;
		return false;
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		if(FormMessageBox.Self.visible) return;
		if(m_ItemList.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButImg.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_ButQuery.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_SearchEdit.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_SlotType.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_LvlMin.hitTestPoint(e.stageX,e.stageY)) return;
		if(m_LvlMax.hitTestPoint(e.stageX,e.stageY)) return;
		
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	public function onMouseUp(event:MouseEvent) : void
	{
		event.stopImmediatePropagation();
	}

	public function onMouseMove(e:MouseEvent) : void
	{
		if(!IsScroll()) e.stopImmediatePropagation();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function clickClose(event:MouseEvent):void
	{
		Hide();
	}

	public function Show():void
	{
		visible=true;

		x=Math.ceil(m_Map.stage.stageWidth/2-SizeX/2);
		y=Math.ceil(m_Map.stage.stageHeight/2-SizeY/2);
	}

	public function clickQuery(event:MouseEvent):void
	{
		var tstr:String;
		var boundary:String=Server.Self.CreateBoundary();

		var d:String="";

		tstr=m_SearchEdit.text;
		if(tstr.length>0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"search\"\r\n\r\n";
			d+=tstr+"\r\n";
		}

		tstr=m_LvlMin.text;
		if(tstr.length>0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"lvlmin\"\r\n\r\n";
			d+=int(tstr).toString()+"\r\n";
		}

		tstr=m_LvlMax.text;
		if(tstr.length>0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"lvlmax\"\r\n\r\n";
			d+=int(tstr).toString()+"\r\n";
		}

		if(m_SlotType.selectedItem.data>=0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"slottype\"\r\n\r\n";
			d+=m_SlotType.selectedItem.data.toString()+"\r\n";
		}

		if(d.length>0) {
			d+="--"+boundary+"--\r\n";

			Server.Self.QueryPost("emitemop","&op=1",d,boundary,QueryAnswer,false);
		} else {
			Server.Self.Query("emitemop","&op=1",QueryAnswer,false);
		}
	}

	public function QueryAnswer(e:Event):void
	{
		var loader:URLLoader = URLLoader(e.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(m_Map.ErrorFromServer(buf.readUnsignedByte())) return;
		
		m_ItemList.removeAll();

		while(buf.position<buf.length) {
			var iid:uint=buf.readUnsignedInt();

			var it:Item=UserList.Self.GetItem(iid,false);
			if(it==null) continue;
			
			var obj:Object={ Id:iid, Name:it.m_Id.toString(), Lvl:it.m_Lvl };
			
			if (it.m_OwnerId) {
				obj.Owner = EmpireMap.Self.Txt_CotlOwnerName(0, it.m_OwnerId);
				//var user:User=UserList.Self.GetUser(it.m_OwnerId);
				//if(user==null) obj.Owner="Load...";
				//else obj.Owner=user.m_Name;
			}

			m_ItemList.addItem(obj);
		}

		UpdateItem();
	}
	
	public function UpdateItem():void
	{
		var i:int;
		
		for(i=0;i<m_ItemList.length;i++) {
			var obj:Object=m_ItemList.getItemAt(i);

			var it:Item=UserList.Self.GetItem(obj.Id,false);
			if(it==null) continue;
//trace(obj.Id,it.m_Lvl);

			obj.Lvl=it.m_Lvl;

			obj.Name=m_Map.Txt_ItemName(obj.Id);

			if(it.m_SlotType==Item.stBlue) obj.Slot="Blue";
			else if(it.m_SlotType==Item.stGreen) obj.Slot="Green";
			else if(it.m_SlotType==Item.stRed) obj.Slot="Red";
			else if(it.m_SlotType==Item.stYellow) obj.Slot="Yellow";
			else obj.Slot="";

			if(it.m_OwnerId) {
				var user:User = UserList.Self.GetUser(it.m_OwnerId);
				obj.Owner = EmpireMap.Self.Txt_CotlOwnerName(0, it.m_OwnerId);
				//if(user==null) obj.Owner="Load...";
				//else obj.Owner=user.m_Name;
			}
			
//			m_ItemList.invalidateItem(obj);
		}
		m_ItemList.invalidateList();
	}

	public function onDoubleClickItemList(event:Event):void
	{
		var i:int,u:int,k:int;

		event.stopImmediatePropagation();
		
		if(m_ItemList.selectedItem==null) return;
		
		var it:Item=UserList.Self.GetItem(m_ItemList.selectedItem.Id);
		if(it==null) return;

		m_Map.m_FormInput.Init(500);
		m_Map.m_FormInput.AddLabel(Common.TxtEdit.EditItemCaption + ":", 18);
		
		m_Map.m_FormInput.PageAdd("Main");

		m_Map.m_FormInput.AddLabel(Common.TxtEdit.ItemName+":");
		m_Map.m_FormInput.Col();
		m_Map.m_FormInput.AddInput(m_Map.Txt_ItemName(it.m_Id),32-1,true,Server.Self.m_Lang);

		m_Map.m_FormInput.AddLabel(Common.TxtEdit.ItemDesc+":");
		m_Map.m_FormInput.AddArea(100,true,m_Map.Txt_ItemDesc(it.m_Id),512-1,true,Server.Self.m_Lang);
		
		m_Map.m_FormInput.AddLabel(Common.TxtEdit.ItemSlotType+":");
		m_Map.m_FormInput.Col();
		m_Map.m_FormInput.AddComboBox();
		m_Map.m_FormInput.AddItem("None",Item.stNone,it.m_SlotType==Item.stNone);
		m_Map.m_FormInput.AddItem("Blue",Item.stBlue,it.m_SlotType==Item.stBlue);
		m_Map.m_FormInput.AddItem("Green",Item.stGreen,it.m_SlotType==Item.stGreen);
		m_Map.m_FormInput.AddItem("Red",Item.stRed,it.m_SlotType==Item.stRed);
		m_Map.m_FormInput.AddItem("Yellow",Item.stYellow,it.m_SlotType==Item.stYellow);

		m_Map.m_FormInput.AddLabel(Common.TxtEdit.ItemLvl+":");
		m_Map.m_FormInput.Col();
		m_Map.m_FormInput.AddInput(it.m_Lvl.toString(),6,true,0);

		m_Map.m_FormInput.AddLabel(Common.TxtEdit.ItemStackMax+":");
		m_Map.m_FormInput.Col();
		m_Map.m_FormInput.AddInput(it.m_StackMax.toString(),9,true,0);

		for (i = 0; i < 4;i++) {
			m_Map.m_FormInput.PageAdd("Bonus" + i.toString());

			for (u = 0; u < 4;u++) {
				m_Map.m_FormInput.AddLabel("Type" + (i * 4 + u).toString() + ":");
				m_Map.m_FormInput.Col();
				m_Map.m_FormInput.AddComboBox();
				m_Map.m_FormInput.AddItem("None", 0, 0 == it.m_BonusType[i * 4 + u]);
				for (k = 1; k < Common.ItemBonusCnt; k++) {
					m_Map.m_FormInput.AddItem(Common.ItemBonusName[k], k, k == it.m_BonusType[i * 4 + u]);
				}

				m_Map.m_FormInput.AddLabel("Val" + (i * 4 + u).toString() + ":");
				m_Map.m_FormInput.Col();
				m_Map.m_FormInput.AddInput(it.m_BonusVal[i * 4 + u].toString(), 6, true, 0);

				m_Map.m_FormInput.AddLabel("Difficult" + (i * 4 + u).toString() + ":");
				m_Map.m_FormInput.Col();
				m_Map.m_FormInput.AddInput(it.m_BonusDif[i * 4 + u].toString(), 6, true, 0);
			}
		}

		m_Map.m_FormInput.ColAlign();
		m_Map.m_FormInput.Run(EditItemSend);
	}

	private function EditItemSend():void
	{
		var i:int, u:int, k:int;
		var tstr:String;
		var boundary:String=Server.Self.CreateBoundary();

		var it:Item=UserList.Self.GetItem(m_ItemList.selectedItem.Id);
		if(it==null) return;

		var d:String = "";

		k = 0;

		tstr=m_Map.m_FormInput.GetStr(k++);
		if(tstr.length>0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"iname\"\r\n\r\n";
			d+=tstr+"\r\n";
		}

		tstr=m_Map.m_FormInput.GetStr(k++);
		if(tstr.length>0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"idesc\"\r\n\r\n";
			d+=tstr+"\r\n";
		}

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"slottype\"\r\n\r\n";
		d += m_Map.m_FormInput.GetInt(k++).toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"lvl\"\r\n\r\n";
		d += m_Map.m_FormInput.GetInt(k++).toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"smax\"\r\n\r\n";
		d += m_Map.m_FormInput.GetInt(k++).toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"itemid\"\r\n\r\n";
		d += it.m_Id.toString() + "\r\n";

		tstr = "";
		for (i = 0; i < 4; i++) {
			for (u = 0; u < 4; u++) {
				if (i != 0 || u != 0) tstr += "~";
				tstr += m_Map.m_FormInput.GetInt(k++).toString();
				tstr += "~";
				tstr += m_Map.m_FormInput.GetInt(k++).toString();
				tstr += "~";
				tstr += m_Map.m_FormInput.GetInt(k++).toString();
			}
		}
		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"itembonus\"\r\n\r\n";
		d += tstr + "\r\n";

		d+="--"+boundary+"--\r\n";

		Server.Self.QueryPost("emitemop","&op=2",d,boundary,OpAnswer,false);
	}

	public function OpAnswer(e:Event):void
	{
		var loader:URLLoader = URLLoader(e.target);
		
		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;
		
		if(m_Map.ErrorFromServer(buf.readUnsignedByte())) return;

		m_Map.QueryTxt();
	}

	public function clickImg(event:MouseEvent):void
	{
		if(m_Map.m_FormItemImg.visible) m_Map.m_FormItemImg.Hide();
		else {
//			if(m_ItemList.item
			var it:Item=UserList.Self.GetItem(m_ItemList.selectedItem.Id);
			if(it!=null) {
				m_Map.m_FormItemImg.m_CurNo=it.m_Img;
				m_Map.m_FormItemImg.Show();
			}
		}
	}
	
	public function onItemChange(e:Event):void
	{
		if(m_Map.m_FormItemImg.visible) {
			var it:Item=UserList.Self.GetItem(m_ItemList.selectedItem.Id);
			if(it!=null) {
				m_Map.m_FormItemImg.ChangeCur(it.m_Img);
			}
		}
	}
}

}

import fl.controls.listClasses.CellRenderer;
import fl.events.ComponentEvent;
import flash.text.*;

class ItemListRenderer extends CellRenderer
{
	public function ItemListRenderer() {
		var originalStyles:Object = CellRenderer.getStyleDefinition();
		setStyle("upSkin",CellRenderer_OU_upSkin);
		setStyle("downSkin",CellRendere_PL_selectedUpSkin);
		setStyle("overSkin",CellRendere_PL_selectedUpSkin);
		setStyle("selectedUpSkin",CellRendere_PL_selectedUpSkin);
		setStyle("selectedDownSkin",CellRendere_PL_selectedUpSkin);
		setStyle("selectedOverSkin",CellRendere_PL_selectedUpSkin);
		setStyle("textFormat",new TextFormat("Calibri",14,0xffffff));
		setStyle("embedFonts", true);
		setStyle("textPadding",5);
		
//		addEventListener(ComponentEvent.LABEL_CHANGE, labelChangeHandler);
	}
	
//	function labelChangeHandler(event:ComponentEvent):void
//	{
//		if(FormChat.Self.UserIsOnline(data.User)) {
//			setStyle("textFormat",new TextFormat("Calibri",14,0xffffff));
//		} else {
//			setStyle("textFormat",new TextFormat("Calibri",14,0x808080));
//		}
//	}
}
