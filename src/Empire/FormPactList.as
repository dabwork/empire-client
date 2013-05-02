package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import fl.controls.dataGridClasses.*;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormPactList extends FormPactListClass
{
	private var m_Map:EmpireMap;
	
	public var m_List:Array=new Array();
	
	public function FormPactList(map:EmpireMap)
	{
		m_Map=map;
		
		Common.UIStdBut(ButClose);
		
		Common.UIStdLabel(Caption,18);

		addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

		ButClose.addEventListener(MouseEvent.CLICK, clickClose);

		PList.setStyle("skin",ListOnlineUser_skin);
		PList.setStyle("cellRenderer",PactListRenderer);

		PList.setStyle("trackUpSkin",Chat_ScrollTrack_skin);
		PList.setStyle("trackOverSkin",Chat_ScrollTrack_skin);
		PList.setStyle("trackDownSkin",Chat_ScrollTrack_skin);
		PList.setStyle("trackDisabledSkin",Chat_ScrollTrack_skin);

		PList.setStyle("thumbUpSkin",Chat_ScrollThumb_upSkin);
		PList.setStyle("thumbOverSkin",Chat_ScrollThumb_upSkin);
		PList.setStyle("thumbDownSkin",Chat_ScrollThumb_upSkin);
		PList.setStyle("thumbDisabledSkin",Chat_ScrollThumb_upSkin);
		PList.setStyle("thumbIcon",Chat_ScrollBar_thumbIcon);

		PList.setStyle("upArrowDownSkin",Chat_ScrollArrowUp_upSkin);
		PList.setStyle("upArrowOverSkin",Chat_ScrollArrowUp_upSkin);
		PList.setStyle("upArrowUpSkin",Chat_ScrollArrowUp_upSkin);
		PList.setStyle("upArrowDisabledSkin",Chat_ScrollArrowUp_upSkin);

		PList.setStyle("downArrowDownSkin",Chat_ScrollArrowDown_upSkin);
		PList.setStyle("downArrowOverSkin",Chat_ScrollArrowDown_upSkin);
		PList.setStyle("downArrowUpSkin",Chat_ScrollArrowDown_upSkin);
		PList.setStyle("downArrowDisabledSkin",Chat_ScrollArrowDown_upSkin);

		PList.setStyle("headerTextFormat",new TextFormat("Calibri",14,0xffffff));
		PList.setStyle("headerУmbedFonts", true);
		PList.setStyle("headerTextPadding",5);
		
		PList.doubleClickEnabled=true; 
		PList.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
		
		PList.rowHeight=35;
		
		//PList.columns = ["Name","Antimatter"];
		
		var col:DataGridColumn;
		col = new DataGridColumn("Name"); col.headerText = Common.Txt.PactListName; PList.addColumn(col);
		col=new DataGridColumn("Union"); col.headerText=Common.Txt.PactListUnion; col.width=250; PList.addColumn(col);
		col=new DataGridColumn("Date"); col.headerText=Common.Txt.PactListDate; col.width=120; PList.addColumn(col);
		//col=new DataGridColumn("Res"); col.headerText=Common.Txt.PactListRes; PList.addColumn(col);
		
//		col=new DataGridColumn("Antimatter"); col.headerText=Common.ItemName[Common.ItemTypeAntimatter]; PList.addColumn(col);
//		col=new DataGridColumn("Metal"); col.headerText=Common.ItemName[Common.ItemTypeMetal]; PList.addColumn(col);
//		col=new DataGridColumn("Electronics"); col.headerText=Common.ItemName[Common.ItemTypeElectronics]; PList.addColumn(col);
//		col=new DataGridColumn("Protoplasm"); col.headerText=Common.ItemName[Common.ItemTypeProtoplasm]; PList.addColumn(col);
//		col=new DataGridColumn("Nodes"); col.headerText=Common.ItemName[Common.ItemTypeNodes]; PList.addColumn(col);

		PList.minColumnWidth=30;
	}

	public function StageResize():void
	{
		if (!visible) return;// && EmpireMap.Self.IsResize()) Show();
		x = Math.ceil(m_Map.stage.stageWidth / 2 - width / 2);
		y = Math.ceil(m_Map.stage.stageHeight / 2 - height / 2);
	}

	protected function onMouseWheel(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
	}

	protected function onMouseMove(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		m_Map.m_Info.Hide();
	}

	protected function onMouseDown(e:MouseEvent):void
	{
		e.stopImmediatePropagation();

		if(ButClose.hitTestPoint(e.stageX,e.stageY)) return;
		if(PList.hitTestPoint(e.stageX,e.stageY)) return;

		startDrag();
		m_Map.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		m_Map.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	private function clickClose(event:MouseEvent):void
	{
		Hide();
	}

	public function Hide():void
	{
		visible=false;
	}

	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		return mouseX>=0 && mouseX<width && mouseY>=0 && mouseY<height;
	}

	public function Show():void
	{
		var str:String;
		visible=true;

		StageResize();

		Caption.htmlText=Common.Txt.PactListCaption;

		ButClose.label=Common.Txt.ButClose;

		Update();
		//CallPactQuery();
	}

	public function AnswerPactList(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(m_Map.ErrorFromServer(buf.readUnsignedByte())) return;

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		var ver:uint=sl.LoadDword();
		if(ver<m_Map.m_PactVersion) return;
		m_Map.m_PactVersion=ver;

		m_List.length=0;

		while(true) {
			var user1:uint=sl.LoadDword();
			if(user1==0) break;
			var user2:uint=sl.LoadDword();
//trace("Pact",user1,user2);

			var flag1:uint=sl.LoadDword();
			var flag2:uint=sl.LoadDword();
			var dateend:Number=1000*sl.LoadDword();
			var period:int=sl.LoadInt();

			m_List.push({User1:user1, User2:user2, Flag1:flag1, Flag2:flag2, DateEnd:dateend, Period:period});
		}

		sl.LoadEnd();
		
		Update();
		//CallPactQuery();
		m_Map.m_FormPact.HideIfCancelQuery();
	}
	
/*	public function CallPactQuery():void
	{
		var i:int;
		
		if(m_Map.m_FormPact.visible) return;

		for(i=0;i<m_List.length;i++) {
			if(m_List[i].Period>0 && m_List[i].User2==Server.Self.m_UserId) {
				
				var user:User=UserList.Self.GetUser(m_List[i].User1);
				if(user!=null) {
					m_Map.CancelAll();
					m_Map.CloseForModal();
					m_Map.m_FormPact.m_UserId=m_List[i].User1;
					m_Map.m_FormPact.Show(FormPact.ModeQuery);

					return;
				}
			}
		}
	}*/

	public function PactFindByMode(userid:uint, mode:int):int
	{
		var i:int;
		for(i=0;i<m_List.length;i++) {
			if(mode==FormPact.ModeQuery) {
				if(m_List[i].Period>0 && m_List[i].User2==Server.Self.m_UserId && m_List[i].User1==userid) {
					return i;
				}
			} else if(mode==FormPact.ModePreset) {
				if(m_List[i].Period>0 && m_List[i].User1==Server.Self.m_UserId && m_List[i].User2==userid) {
					return i;
				}
			} else {
				if(m_List[i].Period<=0 && m_List[i].User2==Server.Self.m_UserId && m_List[i].User1==userid) {
					return i;

				} else if(m_List[i].Period<=0 && m_List[i].User1==Server.Self.m_UserId && m_List[i].User2==userid) {
					return i;
				}
			}
		}
		if(mode!=FormPact.ModePreset) return -1;
		for(i=0;i<m_List.length;i++) {
			if(m_List[i].Period<=0 && m_List[i].User2==Server.Self.m_UserId && m_List[i].User1==userid) {
				return i;

			} else if(m_List[i].Period<=0 && m_List[i].User1==Server.Self.m_UserId && m_List[i].User2==userid) {
				return i;
			}
		}
		return -1;
	}

	public function CallPact(userid:uint, mode:int):void
	{
		var i:int;
		var user:User;

		for(i=0;i<m_List.length;i++) {
			user=null;
			if(mode==FormPact.ModeQuery) {
				if(m_List[i].Period>0 && m_List[i].User2==Server.Self.m_UserId && m_List[i].User1==userid) {
					user=UserList.Self.GetUser(m_List[i].User1);
				}

			} else if(mode==FormPact.ModePreset) {
				if(m_List[i].Period>0 && m_List[i].User1==Server.Self.m_UserId && m_List[i].User2==userid) {
					user=UserList.Self.GetUser(m_List[i].User2);
				}

			} else {
				if(m_List[i].Period<=0 && m_List[i].User2==Server.Self.m_UserId && m_List[i].User1==userid) {
					user=UserList.Self.GetUser(m_List[i].User1);

				} else if(m_List[i].Period<=0 && m_List[i].User1==Server.Self.m_UserId && m_List[i].User2==userid) {
					user=UserList.Self.GetUser(m_List[i].User2);

				}
			}
			if(user!=null) {
				m_Map.CancelAll();
				m_Map.FormHideAll();
				m_Map.m_FormPact.m_UserId=user.m_Id;
				m_Map.m_FormPact.Show(mode);
				return;
			}
		}
	}

	public function DeleteQuery(userid:uint):void
	{
		var i:int;

		for(i=0;i<m_List.length;i++) {
			if(m_List[i].Period>0 && m_List[i].User2==Server.Self.m_UserId && m_List[i].User1==userid) {
				m_List.splice(i,1);
				break;
			}
		}
	}
	
	public function Update():void
	{
		var i:int;
		//var user:User;
		var userid:uint;
		//var union:Union;
		//var str:String;

		PList.removeAll();
		
		for(i=0;i<m_List.length;i++) {
			if(m_List[i].Period>0) continue;
			if(m_List[i].User1==Server.Self.m_UserId) userid=m_List[i].User2;
			else if(m_List[i].User2==Server.Self.m_UserId) userid=m_List[i].User1;
			else continue;
			//if(user==null) continue; 
//trace(m_List[i].DateEnd,m_Map.GetServerTime());

			//var flag1:uint=m_List[i].Flag1;
			//var flag2:uint=m_List[i].Flag2;
			//if(m_List[i].User2==Server.Self.m_UserId) {
			//	flag1=m_List[i].Flag2;
			//	flag2=m_List[i].Flag1;
			//}

/*			str='';			
			if(flag1 & 0xffff0000) {
				str+=" -"+((Common.PactPercent[((flag1 >> (16)) & 7)]*100)>>8)+"%";
				str+=" -"+((Common.PactPercent[((flag1 >> (16+3)) & 7)]*100)>>8)+"%";
				str+=" -"+((Common.PactPercent[((flag1 >> (16+6)) & 7)]*100)>>8)+"%";
				str+=" -"+((Common.PactPercent[((flag1 >> (16+9)) & 7)]*100)>>8)+"%";
				str+=" -"+((Common.PactPercent[((flag1 >> (16+12)) & 7)]*100)>>8)+"%";
			}
			if(flag2 & 0xffff0000) {
				if(str.length>0) str+="\n";
				str+=" +"+((Common.PactPercent[((flag2 >> (16)) & 7)]*100)>>8)+"%";
				str+=" +"+((Common.PactPercent[((flag2 >> (16+3)) & 7)]*100)>>8)+"%";
				str+=" +"+((Common.PactPercent[((flag2 >> (16+6)) & 7)]*100)>>8)+"%";
				str+=" +"+((Common.PactPercent[((flag2 >> (16+9)) & 7)]*100)>>8)+"%";
				str+=" +"+((Common.PactPercent[((flag2 >> (16+12)) & 7)]*100)>>8)+"%";
			}*/

			//str = "";
			
			PList.addItem( { Name:"", Union:"", Date:Common.FormatPeriod((m_List[i].DateEnd - m_Map.GetServerGlobalTime()) / 1000), User:userid/*user.m_Id, Res:str*/ } );
		}
		UpdateName();
	}
	
	public function UpdateName():void
	{
		var i:int;
		
		for (i = 0; i < PList.length; i++) {
			var obj:Object = PList.getItemAt(i);
			
			var user:User = UserList.Self.GetUser(obj.User);
			if (user == null) continue;
			
			var change:Boolean = false;
			
			if (obj.Name != EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id)) { obj.Name = EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id); change = true; }

			var union:Union=UserList.Self.GetUnion(user.m_UnionId);
			if (union != null) {
				if ((union.NameUnion() + " " + union.m_Name) != obj.Union) { obj.Union = union.NameUnion() + " " + union.m_Name; change = true; }
			}

			if (change) PList.invalidateItemAt(i);
		}
	}

	public function onDoubleClick(event:Event):void
	{
		if(PList.selectedItem==null) return;
		
		if(m_Map.m_FormPact.visible) return;

		m_Map.m_FormPact.m_UserId=PList.selectedItem.User;
		m_Map.m_FormPact.Show(FormPact.ModeView); 
	}
}

}

import fl.controls.listClasses.CellRenderer;
import fl.events.ComponentEvent;
import flash.text.*;

class PactListRenderer extends CellRenderer
{
    public function PactListRenderer() {
        var originalStyles:Object = CellRenderer.getStyleDefinition();
        setStyle("upSkin",CellRenderer_OU_upSkin);
        setStyle("downSkin",CellRendere_PL_selectedUpSkin);
        setStyle("overSkin",CellRendere_PL_selectedUpSkin);
        setStyle("selectedUpSkin",CellRenderer_OU_upSkin);
        setStyle("selectedDownSkin",CellRendere_PL_selectedUpSkin);
        setStyle("selectedOverSkin",CellRendere_PL_selectedUpSkin);
		setStyle("textFormat",new TextFormat("Calibri",14,0xffffff));
		setStyle("embedFonts", true);
		setStyle("textPadding",5);
		
		//textField.alpha=0.2;
		//textField.htmlText="aaa";
		
//		addEventListener(ComponentEvent.LABEL_CHANGE, labelChangeHandler);
    }
		
//	function labelChangeHandler(event:ComponentEvent):void
//	{
//trace(textField.text);
//		textField.htmlText="<font color='#ff0000'>"+textField.text+"</font>";
//	}
}
