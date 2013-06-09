// Copyright (C) 2013 Elemental Games. All rights reserved.

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

public class FormItemManager extends FormStd
{
	private var EM:EmpireMap = null;

	public var gridItems:int = -1;

	public var m_SearchArray:Vector.<ItemSearch> = new Vector.<ItemSearch>();

	private var m_ButQuery:CtrlBut = null;
	private var m_ButChange:CtrlBut = null;
	private var m_ButImg:CtrlBut = null;

	public function FormItemManager(em:EmpireMap)
	{
		EM = em;

		super(true, false);

		width = 480;
		height = 480;
		scale = StdMap.Main.m_Scale;
		caption = Common.TxtEdit.FormItemManagerCpation;

		gridItems = GridAdd();
		GridSizeX(gridItems, 150, 150);

		m_ButQuery = new CtrlBut();
		m_ButQuery.addEventListener(MouseEvent.CLICK, clickQuery);
		CtrlAdd(m_ButQuery);

		m_ButChange = new CtrlBut();
		m_ButChange.addEventListener(MouseEvent.CLICK, clickChange);
		CtrlAdd(m_ButChange);

		m_ButImg = new CtrlBut();
		m_ButImg.addEventListener(MouseEvent.CLICK, clickImg);
		CtrlAdd(m_ButImg);

		contentSpaceTop = m_ButQuery.height + 10;
		contentSpaceBottom = m_ButImg.height + 10;

		doubleClickEnabled = true;
		addEventListener(MouseEvent.DOUBLE_CLICK, clickDbl);
	}
	
	override public function Hide():void
	{
		super.Hide();
	}

	override public function Show():void
	{
		super.Show();

		m_ButQuery.caption = "Query";
		m_ButQuery.x = width - innerRight - m_ButQuery.width;
		m_ButQuery.y = innerTop;
		
		m_ButChange.caption = "Change";
		m_ButChange.x = width - innerRight - m_ButChange.width;
		m_ButChange.y = height - innerBottom - m_ButChange.height;
		
		m_ButImg.caption = "Img";
		m_ButImg.x = width - innerRight - m_ButImg.width - m_ButChange.width;
		m_ButImg.y = height - innerBottom - m_ButImg.height;
	}

	public function clickQuery(event:MouseEvent):void
	{
		var tstr:String;
		var boundary:String=Server.Self.CreateBoundary();

		var d:String="";

/*		tstr=m_SearchEdit.text;
		if(tstr.length>0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"search\"\r\n\r\n";
			d+=tstr+"\r\n";
		}

		tstr = m_LvlMin.text;
		if (tstr.length > 0) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"lvlmin\"\r\n\r\n";
			d += int(tstr).toString() + "\r\n";
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
		}*/

		if(d.length>0) {
			d+="--"+boundary+"--\r\n";

			Server.Self.QueryPost("emitemop","&op=1",d,boundary,QueryAnswer,false);
		} else {
			Server.Self.Query("emitemop","&op=1",QueryAnswer,false);
		}
	}

	public function SearchDelAll():void
	{
		var i:int;
		var s:ItemSearch;

		for (i = m_SearchArray.length - 1; i >= 0; i--) {
			s = m_SearchArray[i];
			SearchDelete(i);
		}
	}

	public function SearchDelete(i:int):void
	{
		if (i<0 || i>=m_SearchArray.length) return;

		var s:ItemSearch = m_SearchArray[i];

		s.m_IIcon = null;
		if (s.m_IBox != null) { ItemDelete(ItemByObj(s.m_IBox)); s.m_IBox = null; }
		if (s.m_IName != null) { ItemDelete(ItemByObj(s.m_IName)); s.m_IName = null; }
		if (s.m_IOwner != null) { ItemDelete(ItemByObj(s.m_IOwner)); s.m_IOwner = null; }
		if (s.m_ICnt != null) { ItemDelete(ItemByObj(s.m_ICnt)); s.m_ICnt = null; }
		if (s.m_IPrice != null) { ItemDelete(ItemByObj(s.m_IPrice)); s.m_IPrice = null; }
		if (s.m_IStep != null) { ItemDelete(ItemByObj(s.m_IStep)); s.m_IStep = null; }

		m_SearchArray.splice(i, 1);
	}

	public function QueryAnswer(e:Event):void
	{
		var loader:URLLoader = URLLoader(e.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		SearchDelAll();

		while(buf.position<buf.length) {
			var iid:uint=buf.readUnsignedInt();

			var it:Item=UserList.Self.GetItem(iid,false);
			if (it == null) continue;

			var ss:ItemSearch = new ItemSearch();
			ss.m_ItemType = iid;
			m_SearchArray.push(ss);
		}

		UpdateItem();
	}
	
	public function UpdateItem():void
	{
		var i:int, n:int, u:int;
		var str:String;
		var ss:ItemSearch;

		Loc( -1, -1, gridItems, 0, 0, 1, 1);

		var row:int = 0;

		for (i = 0; i < m_SearchArray.length; i++) {
			ss = m_SearchArray[i];

			var item:Item = null;
			if (ss.m_ItemType != 0) item = UserList.Self.GetItem(ss.m_ItemType & 0xffff);

			if (ss.m_IBox == null) {
				ss.m_IBox = ItemObj(ItemBox()) as CtrlBox;
				ss.m_IBox.heightMin = 47;
				ss.m_IBox.addEventListener(Event.CHANGE, SearchSelectChange);
				//ss.m_IBox.addEventListener(MouseEvent.MOUSE_OVER, SearchOver);
				//ss.m_IBox.addEventListener(MouseEvent.MOUSE_OUT, SearchOut);
				ss.m_IBox.doubleClickEnabled = true;
			}
			n = ItemByObj(ss.m_IBox); ItemCell(n, 0, row); ItemSpace(n, 0, 2, 0, 2); ItemCellCnt(n, 3, 2);
			ss.m_IBox.visible = true;

			if (ss.m_IIcon == null && item!=null) {
				ss.m_IIcon = Common.ItemImg(item.m_Img);
				if (ss.m_IIcon != null) {
					ss.m_IBox.addChild(ss.m_IIcon);
//					ss.m_IIcon.mouseEnabled = false;
					ss.m_IIcon.x = 35;
					ss.m_IIcon.y = 47 >> 1;
				}
			}

			if (ss.m_IName == null) {
				str = ss.m_ItemType.toString() + " - " + EM.ItemName(ss.m_ItemType);

				if (item != null) {
					var bitcnt:int = 0;
					for (u = 0; u < Item.BonusCnt; u++) {
						if (!item.m_BonusType[u]) continue;
						if (Common.ItemBonusParent[item.m_BonusType[u]]) continue;
						bitcnt += item.m_CoefBit[u];
					}
					if (bitcnt > 0) {
						str += " (bit:" + bitcnt.toString() + ")";

						//for (u = 0; u < Item.BonusCnt; u++) {
						//	if (!item.m_BonusType[u]) continue;
						//	str += " " + item.m_CoefShift[u].toString() + ":" + item.m_CoefBit[u].toString();
						//}
					}
				}
				
				ss.m_IName = ItemObj(ItemLabel(str)) as TextField;
				ss.m_IName.mouseEnabled = false;
			}
			n = ItemByObj(ss.m_IName); ItemCell(n, 0, row); 
			/*if (ss.m_Owner) {*/ ItemSpace(n, 60, 2, 0, 0); ItemAlign(n, -1, 1); ItemCellCnt(n, 1, 1); //}
			//else { ItemSpace(n, 60, 2, 0, 2); ItemAlign(n, -1, 0); ItemCellCnt(n, 1, 2); }
			ss.m_IName.visible = true;

			//if(ss.m_Owner) {
				if (ss.m_IOwner == null) {
					str =  "own";// EM.Txt_CotlOwnerName(m_CotlId, ss.m_Owner);
					ss.m_IOwner = ItemObj(ItemLabel(str)) as TextField;
					ss.m_IOwner.mouseEnabled = false;
				}
				n = ItemByObj(ss.m_IOwner); ItemCell(n, 0, row + 1); ItemSpace(n, 60, 0, 0, 2); ItemAlign(n, -1, -1);
				//ss.m_IOwner.textColor = 0x404040;
				ss.m_IOwner.visible = true;
			//}
			if (item == null) str = "-";
			else str = BaseStr.FormatBigInt(item.m_StackMax);
			ss.m_IOwner.text = str;

			if (ss.m_ICnt == null) {
				ss.m_ICnt = ItemObj(ItemLabel("")) as TextField;
				ss.m_ICnt.mouseEnabled = false;
			}
			if (item == null) ss.m_ICnt.text = "";
			else ss.m_ICnt.text = item.m_Lvl.toString();// "0";// BaseStr.FormatBigInt(Math.max(0, ss.m_Cnt));
			n = ItemByObj(ss.m_ICnt); ItemCell(n, 1, row); ItemSpace(n, 10, 2, 20, 2); ItemAlign(n, 1, 0);  ItemCellCnt(n, 1, 2);
			ss.m_ICnt.visible = true;

			if (ss.m_IPrice == null) {
				ss.m_IPrice = ItemObj(ItemLabel("")) as TextField;
				ss.m_IPrice.mouseEnabled = false;
			}
			ss.m_IPrice.text = "";// BaseStr.FormatBigInt(ss.m_Price) + " cr.";
			n = ItemByObj(ss.m_IPrice); ItemCell(n, 2, row); ItemSpace(n, 10, 2, 30, 0); ItemAlign(n, 1, 1);  ItemCellCnt(n, 1, 1);
			ss.m_IPrice.visible = true;

			if (ss.m_IStep == null) {
				ss.m_IStep = ItemObj(ItemLabel("")) as TextField;
				ss.m_IStep.mouseEnabled = false;
			}
			ss.m_IStep.text = "";// BaseStr.FormatBigInt(ss.m_Step) + " " + Common.Txt.StorageEd;
			n = ItemByObj(ss.m_IStep); ItemCell(n, 2, row + 1); ItemSpace(n, 10, 0, 30, 2); ItemAlign(n, 1, -1);  ItemCellCnt(n, 1, 1);
			ss.m_IStep.textColor = 0x404040;
			ss.m_IStep.visible = true;

			row += 2;
		}
		
		SearchSelectChange();
		
		ContentBuild();
	}
	
	private function SearchSelectChange(e:Event = null):void
	{
		var i:int;
		var ss:ItemSearch;

		if(e!=null)
		for (i = 0; i < m_SearchArray.length; i++) {
			ss = m_SearchArray[i];
			if (!ss.m_IBox) continue;
			if (ss.m_IBox == e.target) continue;
			ss.m_IBox.select = false;
		}
		onItemChange(e);
	}
	
	public function SearchCurItemType():uint
	{
		var i:int;
		var ss:ItemSearch;

		for (i = 0; i < m_SearchArray.length; i++) {
			ss = m_SearchArray[i];
			if (!ss.m_IBox) continue;
			if (ss.m_IBox.select) return ss.m_ItemType;
		}
		return 0;
	}

	private function clickDbl(e:Event):void
	{
		if (mouseX >= contentX && mouseX < contentX + contentWidth && mouseY >= contentY && mouseY < contentY + contentHeight) {
			clickChange(e);
		}
	}

	public function clickChange(event:Event):void
	{
		var i:int, u:int, k:int, j:int;
		var str:String;
		var cb:CtrlComboBox;

		var it:Item = UserList.Self.GetItem(SearchCurItemType());
		if (it == null) return;

		FI.Init(480, 500);
		FI.caption = Common.TxtEdit.EditItemCaption;

		FI.TabAdd("Main");
		FI.tab = 0;

		FI.AddLabel(Common.TxtEdit.ItemName + ":");
		FI.Col();
		FI.AddInput(EM.Txt_ItemName(it.m_Id), 32 - 1, true, Server.Self.m_Lang);

		FI.AddLabel(Common.TxtEdit.ItemDesc + ":");
		FI.AddCode(EM.Txt_ItemDesc(it.m_Id), 512 - 1, true, Server.Self.m_Lang).heightMin = 100;

		//FI.AddLabel(Common.TxtEdit.ItemSlotType+":");
		FI.AddLabel(Common.Txt.HangarAddSlotType + ":");
		FI.Col();
		FI.AddComboBox();
		FI.AddItem("None", Hangar.stNone, it.m_SlotType == Hangar.stNone);
		FI.AddItem(Common.Txt.HangarSlotEnergy, Hangar.stEnergy, it.m_SlotType == Hangar.stEnergy);
		FI.AddItem(Common.Txt.HangarSlotCharge, Hangar.stCharge, it.m_SlotType == Hangar.stCharge);
		FI.AddItem(Common.Txt.HangarSlotCore, Hangar.stCore, it.m_SlotType == Hangar.stCore);
		FI.AddItem(Common.Txt.HangarSlotSupply, Hangar.stSupply, it.m_SlotType == Hangar.stSupply);
		
//	static public const stNone:int = 0;
//	static public const stEnergy:int = 1;
//	static public const stCharge:int = 2;
//	static public const stCore:int = 3;
//	static public const stSupply:int = 4;

		FI.AddLabel(Common.TxtEdit.ItemLvl + ":");
		FI.Col();
		FI.AddInput(it.m_Lvl.toString(), 6, true, 0);

		FI.AddLabel(Common.TxtEdit.ItemStackMax+":");
		FI.Col();
		FI.AddInput(it.m_StackMax.toString(),9,true,0);

		var tb:int = FI.TabAdd("Bonus");

		for (i = 0; i < 16; i++) {
			//FI.TabAdd("" + i.toString());
			FI.PageAdd(i.toString(), tb);
			FI.page = 0;

			for (u = 0; u < 1; u++) {
				j = i * 1 + u;

				FI.AddLabel("Type" + j.toString() + ":");
				FI.Col();
				cb = FI.AddComboBox();
				FI.AddItem("", 0, 0 == it.m_BonusType[j]);
				cb.current = Common.FillBonusItem(cb.menu, it.m_BonusType[j]);

				FI.AddLabel("Val" + j.toString() + ":");
				FI.Col();
				FI.AddInput(it.m_BonusVal[j].toString(), 6, true, 0);

				FI.AddLabel("Difficult" + j.toString() + ":");
				FI.Col();
				FI.AddInput(it.m_BonusDif[j].toString(), 6, true, 0);

				str = "";
				for (k = 0; k < it.m_CoefCnt[j]; k++) {
					if (k != 0) str += ", ";
					str += it.m_Coef[j * Item.CoefCnt + k].toString();
				}

				FI.AddLabel("Coef" + j.toString() + ":");
				FI.Col();
				FI.AddInput(str, 255, true, 0, true, "-,");
			}
		}

		FI.Run(EditItemSend, StdMap.Txt.ButSave, StdMap.Txt.ButCancel);
	}

	private function EditItemSend():void
	{
		var i:int, u:int, k:int, j:int, srclen:int, vlen:int, v:int, sme:int;
		var tstr:String, src:String;
		var boundary:String = Server.Self.CreateBoundary();

		var it:Item = UserList.Self.GetItem(SearchCurItemType());
		if(it==null) return;

		var d:String = "";

		k = 0;

		tstr = FI.GetStr(k++);
		if(tstr.length>0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"iname\"\r\n\r\n";
			d+=tstr+"\r\n";
		}

		tstr=FI.GetStr(k++);
		if(tstr.length>0) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"idesc\"\r\n\r\n";
			d+=tstr+"\r\n";
		}

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"slottype\"\r\n\r\n";
		d += FI.GetInt(k++).toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"lvl\"\r\n\r\n";
		d += FI.GetInt(k++).toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"smax\"\r\n\r\n";
		d += FI.GetInt(k++).toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"itemid\"\r\n\r\n";
		d += it.m_Id.toString() + "\r\n";

		tstr = "";
		for (i = 0; i < 16; i++) {
			for (u = 0; u < 1; u++) {
				if (i != 0 || u != 0) tstr += "~";
				tstr += FI.GetInt(k++).toString();
				tstr += "~";
				tstr += FI.GetInt(k++).toString();
				tstr += "~";
				tstr += FI.GetInt(k++).toString();

				tstr += "~";
				src = FI.GetStr(k++);
				srclen = src.length;
				sme = 0;
				for (j = 0; j < Item.CoefCnt; j++) {
					while (srclen > 0 && src.charCodeAt(sme) == 32) { sme++; srclen--; }

					vlen = BaseStr.ParseIntLen(src, sme, srclen);
					if (vlen <= 0) break;

					v = int(src.substr(sme, vlen));
					if (j != 0) tstr += "_";
					tstr += v.toString();

					sme += vlen;
					srclen -= vlen;

					while (srclen > 0 && src.charCodeAt(sme) == 32) { sme++; srclen--; }

					if (srclen <= 0) break;
					if (src.charCodeAt(sme) != 44) break;
					sme++;
					srclen--;
				}
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
		
		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

//		m_Map.QueryTxt();
	}

	public function clickImg(event:MouseEvent):void
	{
		if(EM.m_FormItemImg.visible) EM.m_FormItemImg.Hide();
		else {
			var it:Item = UserList.Self.GetItem(SearchCurItemType());
			if (it != null) {
				EM.m_FormItemImg.Show();
				EM.m_FormItemImg.ChangeCur(it.m_Img);
			}
		}
	}
	
	public function onItemChange(e:Event):void
	{
		if(EM.m_FormItemImg.visible) {
			var it:Item = UserList.Self.GetItem(SearchCurItemType());
			if (it != null) {
				EM.m_FormItemImg.ChangeCur(it.m_Img);
			}
		}
	}
}

}

import Engine.*;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.*;

class ItemSearch
{
	public var m_ItemType:uint = 0;

	public var m_IIcon:DisplayObject;
	public var m_IBox:CtrlBox;
	public var m_IName:TextField;
	public var m_IOwner:TextField;
	public var m_ICnt:TextField;
	public var m_IPrice:TextField;
	public var m_IStep:TextField;
}
