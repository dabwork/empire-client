package Empire
{

import Base.*;
import Engine.*;
import flash.display.*;
import flash.events.*;
import flash.geom.Point;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

public class FormStorage extends FormStd
{
	private var EM:EmpireMap = null;

	public var m_CotlId:uint = 0;
	public var tabDesc:int = -1;
	public var tabJournal:int = -1;
	public var tabStorage:int = -1;
	public var tabImport:int = -1;
	public var tabExport:int = -1;
	public var tabSearch:int = -1;
	
	public var gridGoods:int = -1;
	
	public var m_ImportNeedMoney:TextField = null;

	private var m_ButOp:CtrlBut = null;
	private var m_ButChange:CtrlBut = null;
	private var m_ButAction:CtrlBut = null;
	private var m_ButEnter:CtrlBut = null;

	private var m_Desc:TextField = null;
	private var m_Journal:TextField = null;

	private var m_KindSearch:CtrlComboBox = null;
	private var m_ItemTypeSearch:CtrlComboBox = null;
	private var m_InputSearch:CtrlInput = null;
	private var m_ButSearch:CtrlBut = null;

	private var m_ButRight:CtrlBut = null;
	private var m_ButLeft:CtrlBut = null;
	private var m_LabelPage:TextField = null;

	public var m_ErrOpenInput:Boolean = false;

	public var m_StorageList:Vector.<StorageItem> = new Vector.<StorageItem>();

	public var m_SearchArray:Vector.<StorageSearch> = new Vector.<StorageSearch>();
	public var m_SearchRecvType:int = -1;

	public var m_List:Array = new Array();
	public var m_ListFilter:Array = null;
	public var m_Page:int = 0;
	public var m_GoToPage:int = -1;
	public var m_ChangeImageQuality:Boolean = false;
	
	private var m_Filter:Array = null;

	public function FormStorage(em:EmpireMap)
	{
		EM = em;

		super(true, false);
		
		var n:int;
		
		scrollLine = 2 + 47 + 2;

		width = 480;
		height = 505;
		scale = StdMap.Main.m_Scale;
		setPos(0.091, 0.0, -1, 0);
		caption = Common.Txt.StorageCaption;
		
		gridGoods = GridAdd();
		GridSizeX(gridGoods, 150, 150);

		var tf:TextFormat = new TextFormat("Calibri", 14, 0x000000, null, null, null, null, null, TextFormatAlign.JUSTIFY, null, null, 20);

		tabDesc = TabAdd(Common.Txt.StoragePageDesc);
//		tab = 0;
		n = ItemLabel("", true); m_Desc = ItemObj(n) as TextField; ItemSpace(n, 0, 0, 10, 0);
		m_Desc.defaultTextFormat = tf;
		m_Desc.condenseWhite=true;
		m_Desc.addEventListener(Event.FRAME_CONSTRUCTED,frConst);

		tabJournal = TabAdd(Common.Txt.StoragePageJournal);
		n = ItemLabel("", true); m_Journal = ItemObj(n) as TextField; ItemSpace(n, 0, 0, 10, 0);
		m_Journal.defaultTextFormat = tf;
		m_Journal.condenseWhite=true;
		m_Journal.addEventListener(Event.FRAME_CONSTRUCTED,frConst);

		tabStorage = TabAdd(Common.Txt.StoragePageStorage);
//		ItemBut(Common.Txt.StorageGoodsAdd.toUpperCase());
//		ItemBut(Common.Txt.StorageGoodsChange.toUpperCase());
//		ItemLabel("");

		tabImport = TabAdd(Common.Txt.StoragePageImport);
		m_ImportNeedMoney = new TextField();
		m_ImportNeedMoney.width=1;
		m_ImportNeedMoney.height=1;
		m_ImportNeedMoney.type = TextFieldType.DYNAMIC;
		m_ImportNeedMoney.selectable = false;
		m_ImportNeedMoney.border = false;
		m_ImportNeedMoney.background = false;
		m_ImportNeedMoney.multiline = false;
		m_ImportNeedMoney.autoSize = TextFieldAutoSize.LEFT;
		m_ImportNeedMoney.antiAliasType = AntiAliasType.ADVANCED;
		m_ImportNeedMoney.gridFitType = GridFitType.SUBPIXEL;
		m_ImportNeedMoney.defaultTextFormat = new TextFormat("Calibri", 13, 0);
		m_ImportNeedMoney.embedFonts = true;
		m_ImportNeedMoney.addEventListener(MouseEvent.CLICK, moneyAddForImport);
		CtrlAdd(m_ImportNeedMoney);

		tabExport = TabAdd(Common.Txt.StoragePageExport);

		tabSearch = TabAdd(Common.Txt.StoragePageFind);
		
		m_ButOp = new CtrlBut();
		m_ButOp.addEventListener(MouseEvent.CLICK, clickOp);
		CtrlAdd(m_ButOp);

		m_ButEnter = new CtrlBut();
		m_ButEnter.addEventListener(MouseEvent.CLICK, clickEnter);
		CtrlAdd(m_ButEnter);

//		m_ButAdd = new CtrlBut();
//		m_ButAdd.addEventListener(MouseEvent.CLICK, clickAdd);
//		m_ButAdd.captionTF.defaultTextFormat = new TextFormat("Calibri", 13, m_ButAdd.captionTF.defaultTextFormat.color);
//		CtrlAdd(m_ButAdd);

		m_ButChange = new CtrlBut();
		m_ButChange.addEventListener(MouseEvent.CLICK, clickChange);
		m_ButChange.captionTF.defaultTextFormat = new TextFormat("Calibri", 13, m_ButChange.captionTF.defaultTextFormat.color);
		//m_ButChange.captionOffsetY = -5;
		CtrlAdd(m_ButChange);

		m_ButAction = new CtrlBut();
		m_ButAction.addEventListener(MouseEvent.CLICK, clickAction);
		m_ButAction.captionTF.defaultTextFormat = new TextFormat("Calibri", 13, m_ButAction.captionTF.defaultTextFormat.color);
		CtrlAdd(m_ButAction);

		m_KindSearch = new CtrlComboBox();
		m_KindSearch.addEventListener(Event.CHANGE, KindSearchChange);
		m_KindSearch.ItemClear();
		m_KindSearch.ItemAdd(Common.Txt.StorageSearchImport, 1);
		m_KindSearch.ItemAdd(Common.Txt.StorageSearchExport, 0);
		m_KindSearch.ItemAdd(Common.Txt.StorageSearchCotl, 2);
		m_KindSearch.current = 0;
		CtrlAdd(m_KindSearch);

		m_ItemTypeSearch = new CtrlComboBox();
		CtrlAdd(m_ItemTypeSearch);

		m_InputSearch = new CtrlInput(this);
		m_InputSearch.text = "";
		CtrlAdd(m_InputSearch);

		m_ButSearch = new CtrlBut();
		m_ButSearch.addEventListener(MouseEvent.CLICK, clickSearch);
		CtrlAdd(m_ButSearch);

//		m_ButClose = new CtrlBut();
//		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
//		CtrlAdd(m_ButClose);

		m_ButRight = new CtrlBut();
		m_ButRight.icon = CtrlBut.IconRight;
		m_ButRight.style = CtrlBut.StyleBlue;
		m_ButRight.addEventListener(MouseEvent.CLICK, clickRight);
		CtrlAdd(m_ButRight);
		
		m_ButLeft = new CtrlBut();
		m_ButLeft.icon = CtrlBut.IconLeft;
		m_ButLeft.style = CtrlBut.StyleBlue;
		m_ButLeft.addEventListener(MouseEvent.CLICK, clickLeft);
		CtrlAdd(m_ButLeft);

		m_LabelPage = new TextField();
		m_LabelPage.visible = false;
		m_LabelPage.x=10;
		m_LabelPage.y=5;
		m_LabelPage.width=1;
		m_LabelPage.height=1;
		m_LabelPage.type=TextFieldType.DYNAMIC;
		m_LabelPage.selectable=false;
		m_LabelPage.border=false;
		m_LabelPage.background=false;
		m_LabelPage.multiline=false;
		m_LabelPage.autoSize=TextFieldAutoSize.LEFT;
		m_LabelPage.antiAliasType=AntiAliasType.ADVANCED;
		m_LabelPage.gridFitType=GridFitType.PIXEL;
		m_LabelPage.defaultTextFormat = new TextFormat("Calibri", 14, 0x0);
		m_LabelPage.embedFonts = true;
		m_LabelPage.addEventListener(MouseEvent.CLICK, clickPage);
		CtrlAdd(m_LabelPage);
		
		doubleClickEnabled = true;
		addEventListener(MouseEvent.DOUBLE_CLICK, clickDbl);
		
		addEventListener("page", changePage);
	}
	
	public function IsMouseInTop():Boolean
	{
//		if (!IsMouseIn()) return false;

		var pt:Point = new Point(stage.mouseX, stage.mouseY);
		var ar:Array = stage.getObjectsUnderPoint(pt);

		if (ar.length <= 0) return false;

		var obj:DisplayObject = ar[ar.length - 1];
		if (obj == EM.m_MoveItem) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		else if (obj == EM.m_FormFleetBar.m_MoveLayer) { if (ar.length <= 1) return false; obj = ar[ar.length - 2]; }
		while (obj!=null) {
			if (obj == this) return true;
			obj = obj.parent;
		}
		return false;
	}

	override public function Hide():void
	{
		super.Hide();
		
		StorageDelAll();
	}

	override public function Show():void
	{
		super.Show();

		captionEx = EM.CotlName(m_CotlId, true);

		m_ButOp.caption = Common.Txt.StorageOp.toUpperCase();
		m_ButEnter.caption = Common.Txt.StorageEnter.toUpperCase();

		if (StorageAccess()) {
			TabSetVisible(tabStorage, true);
		} else {
			TabSetVisible(tabStorage, false)
			if (tab == tabStorage) tab = tabImport;
		}

		m_ButSearch.caption = Common.Txt.StorageSearch.toUpperCase();
		m_ButSearch.x = width - innerRight - m_ButSearch.width;
		m_ButSearch.y = innerTop;

		m_KindSearch.x = innerLeft;
		m_KindSearch.y = m_ButSearch.y + (m_ButSearch.height >> 1) - (m_KindSearch.height >> 1);
		m_KindSearch.width = 120;

		m_ItemTypeSearch.x = m_KindSearch.x + m_KindSearch.width;
		m_ItemTypeSearch.y = m_ButSearch.y + (m_ButSearch.height >> 1) - (m_ItemTypeSearch.height >> 1);
		m_ItemTypeSearch.width = m_ButSearch.x - m_ItemTypeSearch.x;
		m_ItemTypeSearch.ItemClear();
		m_ItemTypeSearch.current = Common.FillMenuItem(m_ItemTypeSearch.menu, Common.ItemTypeModule, false);

		m_InputSearch.x = m_KindSearch.x + m_KindSearch.width;;
		m_InputSearch.y = m_ButSearch.y + (m_ButSearch.height >> 1) - (m_ItemTypeSearch.height >> 1);
		m_InputSearch.width = m_ButSearch.x - m_ItemTypeSearch.x;

		Update();

		if (tab == tabDesc || tab == tabJournal) ListQuery();
		else if (tab == tabStorage || tab == tabImport || tab == tabExport) StorageQuery();
	}
	
	private function clickDbl(e:Event):void
	{
		if (mouseX >= contentX && mouseX < contentX + contentWidth && mouseY >= contentY && mouseY < contentY + contentHeight) {
			if (tab == tabImport) clickAction(e);
			else if(tab==tabExport) clickAction(e);
			else clickChange(e);
		}
	}
	
	private function clickChange(e:Event):void
	{
		if (tab == tabStorage) storageClickChange(e);
		else if (tab == tabImport) importClickChange(e);
		else if (tab == tabExport) exportClickChange(e);
	}
	
	private var m_InputCnt:CtrlInput = null;

	public function storageClickChange(e:Event):void
	{
		if (!StorageAccess(storageCurrent, true)) return;

		if (e.target == m_ImportNeedMoney) storageChange(Common.ItemTypeMoney, ImportMoneyNeed(), false);
		else if (storageCurrent != null) storageChange(storageCurrent.m_Type, 0, true);
		else storageChange(Common.ItemTypeModule, 0, true);
	}

	public function storageChange(type:uint, cnt:int, clickmin:Boolean):void
	{
		//if (!StorageAccess(storageCurrent, true)) return;
		if (!StorageAccess(null, true)) return;

		var si:StorageItem = storageFindByType(type, StorageChangeCurOwner());

		FI.Init(410, 220);
		FI.caption = Common.Txt.StorageGoodsChangeCaption.toUpperCase();

		FI.AddLabel(Common.Txt.StorageGoods + ":");
		FI.Col();
		var cb:CtrlComboBox = FI.AddComboBox();
		//cb.current = Common.FillMenuItem(cb.menu, storageCurrent?storageCurrent.m_Type:(e.target == m_ImportNeedMoney?Common.ItemTypeMoney:Common.ItemTypeModule));
		cb.current = Common.FillMenuItem(cb.menu, type);

		FI.AddLabel(Common.Txt.StorageCnt + ":");
		FI.Col();
		//m_InputCnt = FI.AddInput(e.target == m_ImportNeedMoney?ImportMoneyNeed().toString():"0", 100, true, Server.LANG_ENG, true);
		m_InputCnt = FI.AddInput(cnt.toString(), 100, true, Server.LANG_ENG, true);
		
		if (si && si.m_Owner == StorageChangeCurOwner() && si.m_ImportCnt <= -3 && si.m_ExportCnt <= -3) {
			var butdel:CtrlBut = new CtrlBut();
			butdel.addEventListener(MouseEvent.CLICK, storageClickDel);
			butdel.caption = Common.Txt.StorageDel.toUpperCase();
			butdel.x = FI.contentX-10;
			butdel.y = FI.height - FI.innerBottom - butdel.height;
			FI.CtrlAdd(butdel);
		}
		
		var butmin:CtrlBut = new CtrlBut();
		butmin.caption = "MIN";
		butmin.addEventListener(MouseEvent.CLICK, storageChangeMin);
//		butmin.x = FI.width - FI.innerRight - butmin.width;
//		butmin.y = FI.height - FI.innerBottom - butmin.height * 2;
		FI.CtrlAdd(butmin);

		var butmax:CtrlBut = new CtrlBut();
		butmax.caption = "MAX";
		butmax.addEventListener(MouseEvent.CLICK, storageChangeMax);
//		butmax.x = FI.width - FI.innerRight - butmax.width;
//		butmax.y = FI.height - FI.innerBottom - butmax.height * 2;
		FI.CtrlAdd(butmax);

		FI.Run(storageChangeSend, Common.Txt.StorageChange.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());
		m_InputCnt.setSelection(0, m_InputCnt.text.length);
		m_InputCnt.assignFocus();
		
		butmax.x = FI.width - FI.innerRight - butmax.width;
		butmax.y = FI.contentY + m_InputCnt.y;
		
		butmin.x = butmax.x - butmin.width;
		butmin.y = butmax.y;

		m_InputCnt.width = m_InputCnt.width - butmax.width - butmin.width;

		if (clickmin) storageChangeMin(null);
	}
	
	private function storageChangeSend():void
	{
		var t:uint = FI.GetInt(0);
		var v:int = Common.CalcExpInt(FI.GetStr(1));
//trace(t.toString(16), v);

		var si:StorageItem = storageFindByType(t, StorageChangeCurOwner());
		if (!StorageAccess(si, true)) return;

		if(si!=null) {
			if(v>=0) {
				if (!EM.CanTransfer(si.m_Owner, Server.Self.m_UserId)) { FormMessageBox.RunErr(Common.Txt.WarningItemNoAccessOpByRank); return; }
			} else {
				if (!EM.CanTransfer(Server.Self.m_UserId, si.m_Owner)) { FormMessageBox.RunErr(Common.Txt.WarningItemNoAccessOpByRank); return; }
			}
		}

		if ((t != Common.ItemTypeMoney) && !EM.OnOrbitCotl(m_CotlId)) { FormMessageBox.RunErr(Common.Txt.WarningFleetFarEx); return; }

		m_ErrOpenInput = true;
		Server.Self.QueryHS("emstorageop", "&type=9&id=" + m_CotlId.toString() + "&t=" + t.toString() + "&v=" + v.toString() + (si == null?"":("&rid=" + si.m_RId.toString())), answerStorageOp, false);
	}

	private function storageClickDel(e:MouseEvent):void
	{
		var t:uint = FI.GetInt(0);

		var si:StorageItem = storageFindByType(t, StorageChangeCurOwner());
		if (si == null) return;
		if (!StorageAccess(si, true)) return;

		var v:int = -si.m_Cnt;

		FI.Hide();

		Server.Self.QueryHS("emstorageop", "&type=9&id=" + m_CotlId.toString() + "&t=" + t.toString() + "&v=" + v.toString() + "&del=1&rid=" + si.m_RId.toString(), answerStorageOp, false);
	}

	private function storageChangeMin(e:Event):void
	{
		var l:int;
		var t:uint = FI.GetInt(0);
		var cnt:int = 0;
		while(true) {
			var si:StorageItem = storageFindByType(t, Server.Self.m_UserId);
			if (!si) break;
			cnt = si.m_Cnt;
			
			if (t == Common.ItemTypeMoney) { }
			else if (t == Common.ItemTypeEGM) { }
			else {
				l = EM.m_FormFleetBar.FleetSysItemEmpty(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, t);
				if (cnt > l) cnt = l;
			}
			
			break;
		}
		m_InputCnt.text = (-cnt).toString();
		m_InputCnt.setSelection(0, m_InputCnt.text.length);
		m_InputCnt.assignFocus();
	}

	private function storageChangeMax(e:Event):void
	{
		var l:int;
		var t:uint = FI.GetInt(0);
		var cnt:int = 0;
		while (true) {
			var hcnt:int = 0;
			var si:StorageItem = storageFindByType(t, Server.Self.m_UserId);
			if (si) { hcnt = si.m_Cnt; }
			
			var item:Item = UserList.Self.GetItem(t & 0xffff);
			if (item == null) break;

			if (t == Common.ItemTypeMoney) {
				cnt = Math.max(0, EM.m_FormFleetBar.m_FleetMoney);
				if (hcnt + cnt > 1000000000) cnt = Math.max(0, 1000000000 - hcnt);
			}
			else if (t == Common.ItemTypeEGM) {
				cnt = Math.max(0, EM.m_UserEGM);
				if (hcnt + cnt > 1000000000) cnt = Math.max(0, 1000000000 - hcnt);
			}
			else {
				cnt = EM.m_FormFleetBar.FleetSysItemGet(t);
				if ((hcnt + cnt) > item.m_StackMax * Common.StorageMul) cnt = Math.max(0, item.m_StackMax * Common.StorageMul - hcnt);
			}
			
			break;
		}
		m_InputCnt.text = cnt.toString();
		m_InputCnt.setSelection(0, m_InputCnt.text.length);
		m_InputCnt.assignFocus();
	}

	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	private function sackClick(...arg):void
	{
		if (!SackAccess(storageCurrent)) return;

		if (!EM.OnOrbitCotl(m_CotlId)) { FormMessageBox.RunErr(Common.Txt.WarningFleetFarEx); return; }

		FI.Init(410, 200);
		FI.caption = Common.Txt.StorageSackCaption.toUpperCase();

		FI.AddLabel(Common.Txt.StorageGoods + ":");
		FI.Col();
		FI.AddLabel(EM.ItemName(storageCurrent.m_Type));

		var cnt:int = EM.m_FormFleetBar.FleetSysItemEmpty(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, storageCurrent.m_Type);
		if (cnt > storageCurrent.m_Cnt) cnt = storageCurrent.m_Cnt;

		FI.AddLabel(Common.Txt.StorageSackCnt + ":");
		FI.Col();
		var ic:CtrlInput = FI.AddInput(cnt.toString(), 100, true, Server.LANG_ENG, true);

		FI.Run(sackSend, Common.Txt.StorageSackCaption.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());
		ic.setSelection(0, ic.text.length);
		ic.assignFocus();
	}

	private function sackSend():void
	{
		if (!SackAccess(storageCurrent)) return;

		var t:uint = storageCurrent.m_Type;
		var v:int = Common.CalcExpInt(FI.GetStr(0));
		
		if (v <= 0) return;
		
		if (!EM.CanTransfer(Server.Self.m_UserId, storageCurrent.m_Owner)) { FormMessageBox.RunErr(Common.Txt.WarningItemNoAccessOpByRank); return; }

		var item:Item = UserList.Self.GetItem(t & 0xffff);
		if (!item) return;

		m_ErrOpenInput = true;

		Server.Self.QueryHS("emstorageop", "&type=10&id=" + m_CotlId.toString() + "&rid=" + storageCurrent.m_RId.toString() 
			+ "&v=" + v.toString()
			, answerStorageOp, false);
	}

	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	private var m_LabelStep:TextField = null;
	
	private function importClickChange(e:Event):void
	{
		if (importCurrent != null) importChange(importCurrent.m_Type);
		else importChange(Common.ItemTypeModule);
	}

	public function importChange(type:uint):void
	{
		var idesc:Item = UserList.Self.GetItem(type & 0xfffff);
		if (idesc == null) return;
		var si:StorageItem = storageFindByType(type, StorageChangeCurOwner());

		if (si && si.m_ImportPriceMin != si.m_ImportPriceMax) { importClickChange2(); return; }

		if (!MgnAccess(si, true)) return;

		FI.Init(410, 260);
		FI.caption = Common.Txt.StorageImportCaption.toUpperCase();

		FI.AddLabel(Common.Txt.StorageGoods + ":");
		FI.Col();
		var cb:CtrlComboBox = FI.AddComboBox();
		cb.current = Common.FillMenuItem(cb.menu, type, false);
		cb.addEventListener(Event.CHANGE, importUpdateInput);

		FI.AddLabel(Common.Txt.StorageLimitImport + ":");
		FI.Col();
		var limit:int = 0;
		if (si != null) limit = si.m_ImportLimit;
		else limit = idesc.m_StackMax * Common.StorageMul;
		var ic:CtrlInput = FI.AddInput((limit).toString(), 100, true, Server.LANG_ENG, true);

		FI.AddLabel(Common.Txt.StoragePrice + ":");
		FI.Col();
		var ip:CtrlInput = FI.AddInput((si?si.m_ImportPriceMax:0).toString(), 100, true, Server.LANG_ENG, true);

		FI.AddLabel("");
		FI.Col();
		m_LabelStep = FI.AddLabel("");

		if (si && si.m_Owner == StorageChangeCurOwner()) {
			var butdel:CtrlBut = new CtrlBut();
			butdel.addEventListener(MouseEvent.CLICK, importClickDel);
			butdel.caption = Common.Txt.StorageDel.toUpperCase();
			butdel.x = FI.contentX-10;
			butdel.y = FI.height - FI.innerBottom - butdel.height;
			FI.CtrlAdd(butdel);
		}

		FI.Run(importChangeSend, Common.Txt.StorageChange.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());
		importUpdateInput();
		ip.setSelection(0, ip.text.length);
		ic.setSelection(0, ic.text.length);
		ic.assignFocus();
	}
	
	private function importClickChange2(...args):void
	{
		var si:StorageItem = storageFindByType(importCurrent != null?importCurrent.m_Type:Common.ItemTypeModule, StorageChangeCurOwner());

		if (!MgnAccess(si, true)) return;
		
		var inp:CtrlInput;

		FI.Init(410, 320);
		FI.caption = Common.Txt.StorageImportCaption.toUpperCase();

		FI.AddLabel(Common.Txt.StorageGoods + ":");
		FI.Col();
		var cb:CtrlComboBox = FI.AddComboBox();
		cb.current = Common.FillMenuItem(cb.menu, si?si.m_Type:Common.ItemTypeModule, false);
		cb.addEventListener(Event.CHANGE, importUpdateInput);

		FI.AddLabel(Common.Txt.StorageLimitImport + ":");
		FI.Col();
		var ic:CtrlInput = FI.AddInput((si?si.m_ImportLimit:0).toString(), 100, true, Server.LANG_ENG, true);

		FI.AddLabel("");
		FI.Col();
		FI.AddLabel(Common.Txt.StorageMin + ":");
		FI.Col();
		FI.AddLabel(Common.Txt.StorageMax + ":");

		FI.AddLabel(Common.Txt.StorageCnt + ":");
		FI.Col();
		inp = FI.AddInput((si?si.m_ImportCntMin:0).toString(), 100, true, Server.LANG_ENG, true);
		inp.setSelection(0, inp.text.length);
		inp.widthMin = 150;
		FI.Col();
		inp = FI.AddInput((si?si.m_ImportCntMax:0).toString(), 100, true, Server.LANG_ENG, true);
		inp.setSelection(0, inp.text.length);

		FI.AddLabel(Common.Txt.StoragePrice + ":");
		FI.Col();
		inp = FI.AddInput((si?si.m_ImportPriceMin:0).toString(), 100, true, Server.LANG_ENG, true);
		inp.setSelection(0, inp.text.length);
		FI.Col();
		inp = FI.AddInput((si?si.m_ImportPriceMax:0).toString(), 100, true, Server.LANG_ENG, true);
		inp.setSelection(0, inp.text.length);

		FI.AddLabel("");
		FI.Col();
		m_LabelStep = FI.AddLabel("");

		if (si && si.m_Owner == StorageChangeCurOwner()) {
			var butdel:CtrlBut = new CtrlBut();
			butdel.addEventListener(MouseEvent.CLICK, importClickDel);
			butdel.caption = Common.Txt.StorageDel.toUpperCase();
			butdel.x = FI.contentX-10;
			butdel.y = FI.height - FI.innerBottom - butdel.height;
			FI.CtrlAdd(butdel);
		}

		FI.Run(importChangeSend2, Common.Txt.StorageChange.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());
		importUpdateInput();
		ic.setSelection(0, ic.text.length);
		ic.assignFocus();
	}

	private function importUpdateInput(e:Event = null):void
	{
		var t:uint = FI.GetInt(0);
		
		var step:int = 1;
		var item:Item = UserList.Self.GetItem(t & 0xffff);
		if (item != null) step = item.m_Step;
		
		m_LabelStep.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.StorageStep,"<Val>",BaseStr.FormatBigInt(step)), true, true);
	}

	private function importChangeSend():void
	{
		var t:uint = FI.GetInt(0);
		var v:int = Common.CalcExpInt(FI.GetStr(1));

		var item:Item = UserList.Self.GetItem(t & 0xffff);
		if (!item) return;

		var step:int = item.m_Step;
		var pmin:int = Common.CalcExpInt(FI.GetStr(2));
		var pmax:int = pmin;
		var cmin:int = 0;
		var cmax:int = 0;

		var si:StorageItem = storageFindByType(t, StorageChangeCurOwner());
		if (!MgnAccess(si, true)) return;

		m_ErrOpenInput = true;
		Server.Self.QueryHS("emstorageop", "&type=2&id=" + m_CotlId.toString() + "&t=" + t.toString() 
			+ "&v=" + v.toString()
			+ "&step=" + step.toString()
			+ "&pmin=" + pmin.toString()
			+ "&pmax=" + pmax.toString()
			+ "&cmin=" + cmin.toString()
			+ "&cmax=" + cmax.toString()
			+ (si == null?"":("&rid=" + si.m_RId.toString())), answerStorageOp, false);
	}
	
	private function importChangeSend2():void
	{
		var t:uint = FI.GetInt(0);
		var v:int = Common.CalcExpInt(FI.GetStr(1));

		var item:Item = UserList.Self.GetItem(t & 0xffff);
		if (!item) return;

		var step:int = item.m_Step;
		var cmin:int = Common.CalcExpInt(FI.GetStr(2));
		var cmax:int = Common.CalcExpInt(FI.GetStr(3));
		var pmin:int = Common.CalcExpInt(FI.GetStr(4));
		var pmax:int = Common.CalcExpInt(FI.GetStr(5));

		var si:StorageItem = storageFindByType(t, StorageChangeCurOwner());
		if (!MgnAccess(si, true)) return;

		m_ErrOpenInput = true;
		Server.Self.QueryHS("emstorageop", "&type=2&id=" + m_CotlId.toString() + "&t=" + t.toString() 
			+ "&v=" + v.toString()
			+ "&step=" + step.toString()
			+ "&pmin=" + pmin.toString()
			+ "&pmax=" + pmax.toString()
			+ "&cmin=" + cmin.toString()
			+ "&cmax=" + cmax.toString()
			+ (si == null?"":("&rid=" + si.m_RId.toString())), answerStorageOp, false);
	}

	private function importClickDel(e:MouseEvent):void
	{
		var t:uint = FI.GetInt(0);

		var si:StorageItem = storageFindByType(t, StorageChangeCurOwner());
		if (si == null) return;
		if (!MgnAccess(si, true)) return;

		FI.Hide();

		Server.Self.QueryHS("emstorageop", "&type=3&id=" + m_CotlId.toString() 
			+ "&rid=" + si.m_RId.toString(), answerStorageOp, false);
	}
	
	private function moneyAddForImport(event:Event):void
	{
		storageCurrentSetByType(Common.ItemTypeMoney, Server.Self.m_UserId);
		storageClickChange(event);
	}

	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	private function exportClickChange(e:Event):void
	{
		if (exportCurrent != null) exportChange(exportCurrent.m_Type);
		else exportChange(Common.ItemTypeModule);
	}
	
	public function exportChange(type:uint):void
	{
		var si:StorageItem = storageFindByType(type, StorageChangeCurOwner());
		
		if (si && si.m_ExportPriceMin != si.m_ExportPriceMax) { exportClickChange2(); return; }
		
		if (!MgnAccess(si, true)) return;

		FI.Init(410, 260);
		FI.caption = Common.Txt.StorageExportCaption.toUpperCase();

		FI.AddLabel(Common.Txt.StorageGoods + ":");
		FI.Col();
		var cb:CtrlComboBox = FI.AddComboBox();
		cb.current = Common.FillMenuItem(cb.menu, type, false);
		cb.addEventListener(Event.CHANGE, exportUpdateInput);

		FI.AddLabel(Common.Txt.StorageLimitExport + ":");
		FI.Col();
		var ic:CtrlInput = FI.AddInput((si?si.m_ExportLimit:0).toString(), 100, true, Server.LANG_ENG, true);

		FI.AddLabel(Common.Txt.StoragePrice + ":");
		FI.Col();
		var ip:CtrlInput = FI.AddInput((si?si.m_ExportPriceMax:0).toString(), 100, true, Server.LANG_ENG, true);

		FI.AddLabel("");
		FI.Col();
		m_LabelStep = FI.AddLabel("");

		if (si && si.m_Owner == StorageChangeCurOwner()) {
			var butdel:CtrlBut = new CtrlBut();
			butdel.addEventListener(MouseEvent.CLICK, exportClickDel);
			butdel.caption = Common.Txt.StorageDel.toUpperCase();
			butdel.x = FI.contentX-10;
			butdel.y = FI.height - FI.innerBottom - butdel.height;
			FI.CtrlAdd(butdel);
		}

		FI.Run(exportChangeSend, Common.Txt.StorageChange.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());
		exportUpdateInput();
		ip.setSelection(0, ip.text.length);
		ic.setSelection(0, ic.text.length);
		ic.assignFocus();
	}
	
	private function exportClickChange2(...args):void
	{
		var si:StorageItem = storageFindByType(exportCurrent != null?exportCurrent.m_Type:Common.ItemTypeModule, StorageChangeCurOwner());
		if (!MgnAccess(si, true)) return;
		
		var inp:CtrlInput;

		FI.Init(410, 320);
		FI.caption = Common.Txt.StorageExportCaption.toUpperCase();

		FI.AddLabel(Common.Txt.StorageGoods + ":");
		FI.Col();
		var cb:CtrlComboBox = FI.AddComboBox();
		cb.current = Common.FillMenuItem(cb.menu, si?si.m_Type:Common.ItemTypeModule, false);
		cb.addEventListener(Event.CHANGE, exportUpdateInput);

		FI.AddLabel(Common.Txt.StorageLimitExport + ":");
		FI.Col();
		var ic:CtrlInput = FI.AddInput((si?si.m_ExportLimit:0).toString(), 100, true, Server.LANG_ENG, true);

		FI.AddLabel("");
		FI.Col();
		FI.AddLabel(Common.Txt.StorageMin + ":");
		FI.Col();
		FI.AddLabel(Common.Txt.StorageMax + ":");

		FI.AddLabel(Common.Txt.StorageCnt + ":");
		FI.Col();
		inp = FI.AddInput((si?si.m_ExportCntMin:0).toString(), 100, true, Server.LANG_ENG, true);
		inp.setSelection(0, inp.text.length);
		inp.widthMin = 150;
		FI.Col();
		inp = FI.AddInput((si?si.m_ExportCntMax:0).toString(), 100, true, Server.LANG_ENG, true);
		inp.setSelection(0, inp.text.length);

		FI.AddLabel(Common.Txt.StoragePrice + ":");
		FI.Col();
		inp = FI.AddInput((si?si.m_ExportPriceMin:0).toString(), 100, true, Server.LANG_ENG, true);
		inp.setSelection(0, inp.text.length);
		FI.Col();
		inp = FI.AddInput((si?si.m_ExportPriceMax:0).toString(), 100, true, Server.LANG_ENG, true);
		inp.setSelection(0, inp.text.length);

		FI.AddLabel("");
		FI.Col();
		m_LabelStep = FI.AddLabel("");

		if (si && si.m_Owner == StorageChangeCurOwner()) {
			var butdel:CtrlBut = new CtrlBut();
			butdel.addEventListener(MouseEvent.CLICK, exportClickDel);
			butdel.caption = Common.Txt.StorageDel.toUpperCase();
			butdel.x = FI.contentX-10;
			butdel.y = FI.height - FI.innerBottom - butdel.height;
			FI.CtrlAdd(butdel);
		}

		FI.Run(exportChangeSend2, Common.Txt.StorageChange.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());
		exportUpdateInput();
		ic.setSelection(0, ic.text.length);
		ic.assignFocus();
	}

	private function exportUpdateInput(e:Event = null):void
	{
		var t:uint = FI.GetInt(0);
		
		var step:int = 1;
		var item:Item = UserList.Self.GetItem(t & 0xffff);
		if (item != null) step = item.m_Step;
		
		m_LabelStep.htmlText = BaseStr.FormatTag(BaseStr.Replace(Common.Txt.StorageStep,"<Val>",BaseStr.FormatBigInt(step)), true, true);
	}

	private function exportChangeSend():void
	{
		var t:uint = FI.GetInt(0);
		var v:int = Common.CalcExpInt(FI.GetStr(1));

		var item:Item = UserList.Self.GetItem(t & 0xffff);
		if (!item) return;

		var step:int = item.m_Step;
		var pmin:int = Common.CalcExpInt(FI.GetStr(2));
		var pmax:int = pmin;
		var cmin:int = 0;
		var cmax:int = 0;

		var si:StorageItem = storageFindByType(t, StorageChangeCurOwner());
		if (!MgnAccess(si, true)) return;

		m_ErrOpenInput = true;
		Server.Self.QueryHS("emstorageop", "&type=5&id=" + m_CotlId.toString() + "&t=" + t.toString() 
			+ "&v=" + v.toString()
			+ "&step=" + step.toString()
			+ "&pmin=" + pmin.toString()
			+ "&pmax=" + pmax.toString()
			+ "&cmin=" + cmin.toString()
			+ "&cmax=" + cmax.toString()
			+ (si == null?"":("&rid=" + si.m_RId.toString())), answerStorageOp, false);
	}
	
	private function exportChangeSend2():void
	{
		var t:uint = FI.GetInt(0);
		var v:int = Common.CalcExpInt(FI.GetStr(1));

		var item:Item = UserList.Self.GetItem(t & 0xffff);
		if (!item) return;

		var step:int = item.m_Step;
		var cmin:int = Common.CalcExpInt(FI.GetStr(2));
		var cmax:int = Common.CalcExpInt(FI.GetStr(3));
		var pmin:int = Common.CalcExpInt(FI.GetStr(4));
		var pmax:int = Common.CalcExpInt(FI.GetStr(5));

		var si:StorageItem = storageFindByType(t, StorageChangeCurOwner());
		if (!MgnAccess(si, true)) return;

		m_ErrOpenInput = true;
		Server.Self.QueryHS("emstorageop", "&type=5&id=" + m_CotlId.toString() + "&t=" + t.toString() 
			+ "&v=" + v.toString()
			+ "&step=" + step.toString()
			+ "&pmin=" + pmin.toString()
			+ "&pmax=" + pmax.toString()
			+ "&cmin=" + cmin.toString()
			+ "&cmax=" + cmax.toString()
			+ (si == null?"":("&rid=" + si.m_RId.toString())), answerStorageOp, false);
	}

	private function exportClickDel(e:MouseEvent):void
	{
		var t:uint = FI.GetInt(0);

		var si:StorageItem = storageFindByType(t, StorageChangeCurOwner());
		if (si == null) return;
		if (!MgnAccess(si, true)) return;

		FI.Hide();

		Server.Self.QueryHS("emstorageop", "&type=6&id=" + m_CotlId.toString() 
			+ "&rid=" + si.m_RId.toString(), answerStorageOp, false);
	}

	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	private function clickAction(e:Event):void
	{
		if (tab == tabImport) actionSell();
		else if (tab == tabExport) actionBuy();
	}

	private var m_LabelSum:TextField = null;

	private function actionSell():void
	{
		if (!importCurrent) return;
		if (importCurrent.m_ImportCnt <= 0) return;

		if (!EM.OnOrbitCotl(m_CotlId)) { FormMessageBox.RunErr(Common.Txt.WarningFleetFarEx); return; }

		FI.Init(350, 220);
		FI.caption = Common.Txt.StorageSell.toUpperCase();

		FI.AddLabel(Common.Txt.StorageGoods + ":");
		FI.Col();
		FI.AddLabel(EM.ItemName(importCurrent.m_Type));

		var cnt:int = Math.floor(Math.min(importCurrent.m_ImportCnt, EM.m_FormFleetBar.FleetSysItemGet(importCurrent.m_Type)) / importCurrent.m_ImportStep) * importCurrent.m_ImportStep;

		FI.AddLabel(Common.Txt.StorageCnt + ":");
		FI.Col();
		var ic:CtrlInput = FI.AddInput(Math.max(0, cnt).toString(), 100, true, Server.LANG_ENG, true);
		ic.addEventListener(Event.CHANGE, infoSell);

		FI.AddLabel(Common.Txt.StorageSum + ":");
		FI.Col();
		m_LabelSum = FI.AddLabel("0");

		FI.Run(SellSend, Common.Txt.StorageSell.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());
		ic.setSelection(0, ic.text.length);
		ic.assignFocus();

		infoSell(null);
	}

	private function infoSell(e:Event):void
	{
		if (importCurrent == null) return;
		var cnt:int = Math.max(0,Common.CalcExpInt(FI.GetStr(0)));
		var sum:int = Math.floor(cnt / importCurrent.m_ImportStep) * importCurrent.m_ImportPrice;
		sum = sum - Math.ceil(sum / 100) * Common.TradeNalog;
		m_LabelSum.text = BaseStr.FormatBigInt(sum) + " cr.";
		
		FI.m_ButOk.disable = (cnt <= 0) || (cnt>importCurrent.m_ImportCnt);
	}

	private function SellSend():void
	{
		if (importCurrent == null) return;
		var t:uint = importCurrent.m_Type;

		var cnt:int = FI.GetInt(0);

		if (!EM.CanTransfer(importCurrent.m_Owner, Server.Self.m_UserId)) { FormMessageBox.RunErr(Common.Txt.WarningItemNoAccessOpByRank); return; }
		if (importCurrent.m_ImportPrice != 0 && !EM.CanTransfer(Server.Self.m_UserId, importCurrent.m_Owner)) { FormMessageBox.RunErr(Common.Txt.WarningItemNoAccessOpByRank); return; }

		Server.Self.QueryHS("emstorageop", "&type=7&id=" + m_CotlId.toString()
			+ "&rid=" + importCurrent.m_RId.toString()
			+ "&t=" + t.toString()
			+ "&v=" + cnt.toString()
			+ "&step=" + importCurrent.m_ImportStep.toString()
			+ "&price=" + importCurrent.m_ImportPrice.toString()
			, answerStorageOp, false);
	}

	private function actionBuy():void
	{
		if (!exportCurrent) return;
		if (exportCurrent.m_ExportCnt <= 0) return;

		if (!EM.OnOrbitCotl(m_CotlId)) { FormMessageBox.RunErr(Common.Txt.WarningFleetFarEx); return; }

		FI.Init(350, 220);
		FI.caption = Common.Txt.StorageBuy.toUpperCase();

		FI.AddLabel(Common.Txt.StorageGoods + ":");
		FI.Col();
		FI.AddLabel(EM.ItemName(exportCurrent.m_Type));

		var cnt:int = Math.floor(Math.min(exportCurrent.m_ExportCnt, EM.m_FormFleetBar.FleetSysItemEmpty(EM.m_FormFleetBar.m_FormationOld, EM.m_FormFleetBar.m_HoldLvl, exportCurrent.m_Type)) / exportCurrent.m_ExportStep) * exportCurrent.m_ExportStep;

		FI.AddLabel(Common.Txt.StorageCnt + ":");
		FI.Col();
		var ic:CtrlInput = FI.AddInput(Math.max(0, cnt).toString(), 100, true, Server.LANG_ENG, true);
		ic.addEventListener(Event.CHANGE, infoBuy);

		FI.AddLabel(Common.Txt.StorageSum + ":");
		FI.Col();
		m_LabelSum = FI.AddLabel("0");

		FI.Run(BuySend, Common.Txt.StorageBuy.toUpperCase(), StdMap.Txt.ButCancel.toUpperCase());
		ic.setSelection(0, ic.text.length);
		ic.assignFocus();

		infoBuy(null);
	}

	private function infoBuy(e:Event):void
	{
		if (exportCurrent == null) return;
		var cnt:int = Math.max(0, Common.CalcExpInt(FI.GetStr(0)));
		var sum:int = Math.floor(cnt / exportCurrent.m_ExportStep) * exportCurrent.m_ExportPrice;
		sum = sum + Math.ceil(sum / 100) * Common.TradeNalog;
		if (sum > EM.m_FormFleetBar.m_FleetMoney) {
			m_LabelSum.htmlText = BaseStr.FormatTag("[crt]" + BaseStr.FormatBigInt(sum) + "[/crt] cr.", true, true);
		} else {
			m_LabelSum.htmlText = BaseStr.FormatBigInt(sum) + " cr.";
		}

		FI.m_ButOk.disable = (cnt <= 0) || (cnt > exportCurrent.m_ExportCnt) || (sum > EM.m_FormFleetBar.m_FleetMoney);
	}

	private function BuySend():void
	{
		if (exportCurrent == null) return;
		var t:uint = exportCurrent.m_Type;

		if (!EM.CanTransfer(Server.Self.m_UserId, exportCurrent.m_Owner)) { FormMessageBox.RunErr(Common.Txt.WarningItemNoAccessOpByRank); return; }
		if (exportCurrent.m_ExportPrice != 0 && !EM.CanTransfer(exportCurrent.m_Owner, Server.Self.m_UserId)) { FormMessageBox.RunErr(Common.Txt.WarningItemNoAccessOpByRank); return; }

		var cnt:int = FI.GetInt(0);

		Server.Self.QueryHS("emstorageop", "&type=8&id=" + m_CotlId.toString()
			+ "&rid=" + exportCurrent.m_RId.toString()
			+ "&t=" + t.toString()
			+ "&v=" + cnt.toString()
			+ "&step=" + exportCurrent.m_ExportStep.toString()
			+ "&price=" + exportCurrent.m_ExportPrice.toString()
			, answerStorageOp, false);
	}

	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	public function clickEnter(...args):void
	{
		if(EM.m_FormInput.visible) return;
		if(FormMessageBox.Self.visible) return;

		Hide();

		if (m_CotlId && (EM.IsEdit() || m_CotlId != Server.Self.m_CotlId) && EM.HS.GetCotl(m_CotlId) != null) {
			EM.GoTo(false, m_CotlId);
		} else if(m_CotlId && m_CotlId==Server.Self.m_CotlId) {
			EM.HS.Hide();
		}
	}

	private function clickOp(e:Event):void
	{
		var i:int;
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);

		var pm:CtrlPopupMenu = new CtrlPopupMenu();
		pm.parentCtrl = m_ButOp;
		
		if(tab==tabDesc || tab==tabJournal) {
			pm.ItemAdd(Common.Txt.FormHistAddCaption, 0, 0, clickAdd);
			while(cotl!=null) {
				if (m_Page<0 || m_Page>=m_ListFilter.length) break;
				
				if(EM.m_UserAccess & User.AccessGalaxyText) {}
				else {
					if(m_ListFilter[m_Page].Author!=Server.Self.m_UserId) break;
					if(cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
					else if ((m_ListFilter[m_Page].Prior + 15 * 60) * 1000 < EM.GetServerGlobalTime()) break;
					
				}
				pm.ItemAdd(Common.Txt.FormHistEditCaption, 0, 0, clickEdit);
				
				break;
			}
			while(cotl!=null) {
				if(m_Page<0 || m_Page>=m_ListFilter.length) break;
				
				if(EM.m_UserAccess & User.AccessGalaxyText) {}
				else {
					if(m_ListFilter[m_Page].Author==0) break;
					if(cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
					else if ((m_ListFilter[m_Page].Prior + 15 * 60) * 1000 < EM.GetServerGlobalTime()) break;
					else if(m_ListFilter[m_Page].Author!=Server.Self.m_UserId) break;
				}
				
				pm.ItemAdd(Common.Txt.FormHistDeleteCaption, 0, 0, clickDelete);
				
				break;
			}
		}
		
		if (tab == tabStorage && SackAccess(storageCurrent)) {
			pm.ItemAdd(Common.Txt.StorageSack, 0, 0, sackClick);
		}

		if(tab==tabImport && MgnAccess()) {
			pm.ItemAdd(Common.Txt.StorageChangeEx, 0, 0, importClickChange2);

		} else if(tab==tabExport && MgnAccess()) {
			pm.ItemAdd(Common.Txt.StorageChangeEx, 0, 0, exportClickChange2);
		}
		
//		if (tab == tabDesc || tabJournal) {
//			pm.ItemAdd(Common.Txt.StorageFilter, 0, 0, filterDialog);
//		}
		
		pm.ItemAdd();

//		if (EM.m_UserAccess & User.AccessGalaxyOps) {
//			pm.ItemAdd(Common.TxtEdit.ChangeCotlPos, 0, 0, clickChangeCotlPos);
//		}
		if (EM.CotlDevAccess(cotl.m_Id) & (SpaceCotl.DevAccessAssignRights | SpaceCotl.DevAccessEditCode | SpaceCotl.DevAccessEditMap | SpaceCotl.DevAccessEditOps)) {
			pm.ItemAdd(Common.TxtEdit.CotlSet, 0, 0, EditCotlBegin);
		}
		if (EM.CotlDevAccess(cotl.m_Id) & (SpaceCotl.DevAccessView)) {
			pm.ItemAdd(Common.TxtEdit.MapEdit, 0, 0, EditCotlMapEdit);
		}
		if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) {
			if (cotl.m_DevTime <= EM.GetServerGlobalTime()) {
				pm.ItemAdd(Common.Txt.HyperspaceCotlDevBuy, 0, 0, EditCotlDevBuy);

			} else if (EM.CotlDevAccess(cotl.m_Id) & (SpaceCotl.DevAccessAssignRights | SpaceCotl.DevAccessEditMap | SpaceCotl.DevAccessEditOps | SpaceCotl.DevAccessEditCode)) {
				pm.ItemAdd(Common.Txt.HyperspaceCotlDevBuyContinue, 0, 0, EditCotlDevBuyContinue);
			}
		}

		pm.ItemAdd();

		while (cotl != null) {
			if (cotl.m_CotlType != Common.CotlTypeUser) break;
			if (cotl.m_AccountId != Server.Self.m_UserId) break;
			i = pm.ItemAdd(Common.Txt.FormHistBeacon, 0, 0, clickBeacon);
			pm.itemCheckSet(i, (cotl.m_CotlFlag & SpaceCotl.fBeacon) != 0);
			break;
		}
		
		pm.ItemAdd(Common.Txt.ButClose, 0, 0, formClose);
		
		pm.Show();
	}

	private function EditCotlRecv(event:Event):void
	{
        EM.m_TxtTime = Common.GetTime() - 8000;
	}
	
	public function clickBeacon(...args):void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;

		if ((cotl.m_CotlFlag & SpaceCotl.fBeacon) == 0) {
			if (args.length > 0) {
				FormMessageBox.Run(Common.Txt.FormHistBeaconQuery, StdMap.Txt.ButNo, StdMap.Txt.ButYes, clickBeacon);
			} else {
				cotl.m_CotlFlag |= SpaceCotl.fBeacon;
		        Server.Self.QueryHS("emedcotlbeacon","&val=1",EditCotlRecv,false);
			}
		} else {
			cotl.m_CotlFlag &= ~SpaceCotl.fBeacon;
			Server.Self.QueryHS("emedcotlbeacon","&val=0",EditCotlRecv,false);
		}
	}
	
	public function formClose(...args):void
	{
		Hide();
	}
	
	public function answerStorageOp(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int = buf.readUnsignedByte();
		if(err==Server.ErrorNoAccess) { EM.m_Info.Hide(); FormMessageBox.Run(Common.Txt.StorageErrAccess,Common.Txt.ButClose);  }
		else if(err==Server.ErrorNoEnoughMoney) { EM.m_Info.Hide(); if(m_ErrOpenInput) FI.Show(); FormMessageBox.Run(Common.Txt.NoEnoughMoney,Common.Txt.ButClose);  }
		else if (err == Server.ErrorNoEnoughRes) { EM.m_Info.Hide(); if (m_ErrOpenInput) FI.Show(); FormMessageBox.Run(Common.Txt.NoEnoughRes, Common.Txt.ButClose);  }
		else if(err==Server.ErrorNoEnoughEGM) { EM.m_Info.Hide(); if(m_ErrOpenInput) FI.Show(); FormMessageBox.Run(Common.Txt.NoEnoughEGM2,Common.Txt.ButClose);  }
		else if (err == Server.ErrorOverload) { EM.m_Info.Hide(); if (m_ErrOpenInput) FI.Show(); FormMessageBox.Run(Common.Txt.ErrOverload, Common.Txt.ButClose);  }
		else if(err==Server.ErrorData) { EM.m_Info.Hide(); if(m_ErrOpenInput) FI.Show(); FormMessageBox.Run(Common.Txt.ErrData,Common.Txt.ButClose);  }
		else if (err == Server.ErrorNoHomeworld) { EM.m_Info.Hide(); FormMessageBox.Run(Common.Txt.ErrNoHomeworld, Common.Txt.ButClose);  }
		else if (EM.ErrorFromServer(err)) return;

		m_ErrOpenInput = false;

		StorageQuery();
	}
	
	public function StorageQuery():void
	{
		if (Server.Self.IsSendCommand("emstorage")) return;
		var str:String = "&id=" + m_CotlId.toString();
		Server.Self.QueryHS("emstorage", str, StorageAnswer, false);
	}
	
	public function StorageAnswer(event:Event):void
	{
		var s:StorageItem;
		var i:int;
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		for (i = 0; i < m_StorageList.length; i++) {
			m_StorageList[i].m_Tmp = 0;
		}

		var sl:SaveLoad=new SaveLoad();
		sl.LoadBegin(buf);

		while(true) {
			var rid:uint=sl.LoadDword();
			if (rid == 0) break;
			
			for (i = 0; i < m_StorageList.length; i++) {
				if (m_StorageList[i].m_RId == rid) break;
			}
			if (i >= m_StorageList.length) {
				s = new StorageItem();
				s.m_RId = rid;
				m_StorageList.push(s);
			} else {
				s = m_StorageList[i];
			}

			s.m_RDate = sl.LoadDword();
			s.m_Owner = sl.LoadDword();
			s.m_Type = sl.LoadDword();
			s.m_Cnt = sl.LoadInt();

			s.m_ImportLimit = sl.LoadInt();
			s.m_ImportCnt = sl.LoadInt();
			s.m_ImportStep = sl.LoadInt();
			s.m_ImportPrice = sl.LoadInt();
			s.m_ImportPriceMin = sl.LoadInt();
			s.m_ImportPriceMax = sl.LoadInt();
			s.m_ImportCntMin = sl.LoadInt();
			s.m_ImportCntMax = sl.LoadInt();

			s.m_ExportLimit = sl.LoadInt();
			s.m_ExportCnt = sl.LoadInt();
			s.m_ExportStep = sl.LoadInt();
			s.m_ExportPrice = sl.LoadInt();
			s.m_ExportPriceMin = sl.LoadInt();
			s.m_ExportPriceMax = sl.LoadInt();
			s.m_ExportCntMin = sl.LoadInt();
			s.m_ExportCntMax = sl.LoadInt();
			
			switch(s.m_Type & 0xffff) {
				case Common.ItemTypeMoney:
				case Common.ItemTypeEGM:
					s.m_Razdel = 1;
					break;

				case Common.ItemTypeHydrogen:
				case Common.ItemTypeXenon:
				case Common.ItemTypeTitan:
				case Common.ItemTypeSilicon:
				case Common.ItemTypeCrystal:
					s.m_Razdel = 2;
					break;
		
				case Common.ItemTypeAntimatter:
				case Common.ItemTypeMetal:
				case Common.ItemTypeElectronics:
				case Common.ItemTypeFood:
				case Common.ItemTypePlasma:
				case Common.ItemTypeProtoplasm:
					s.m_Razdel = 3;
					break;

				case Common.ItemTypeMachinery:
				case Common.ItemTypeEngineer:
					s.m_Razdel = 4;
					break;

				case Common.ItemTypeModule:
				case Common.ItemTypeFuel:
				case Common.ItemTypeMine:
				case Common.ItemTypeQuarkCore:
					s.m_Razdel = 5;
					break;

				case Common.ItemTypeArmour:
				case Common.ItemTypeArmour2:
				case Common.ItemTypePower:
				case Common.ItemTypePower2:
				case Common.ItemTypeRepair:
				case Common.ItemTypeRepair2:
				case Common.ItemTypeMonuk:
					s.m_Razdel = 6;
					break;
					
				case Common.ItemTypeTechnician:
				case Common.ItemTypeNavigator:
					s.m_Razdel = 7;
					break;
					
				default:
					s.m_Razdel = 8;
					break;
			}
			
			s.m_Tmp = 1;
		}
		sl.LoadEnd();

		m_StorageList.sort(StorageSort);

		var sp:StorageItem;
		for (i = 0; i < m_StorageList.length; i++) {
			s = m_StorageList[i];

			if (i == 0) {
				if (s.m_RId != 0 && s.m_Tmp != 0) { }
				else continue;
			} else {
				sp = m_StorageList[i - 1];
				
				if (sp.m_Razdel != s.m_Razdel && s.m_RId != 0 && s.m_Tmp != 0) { }
				else if (sp.m_Razdel == s.m_Razdel && sp.m_RId == 0 && s.m_RId != 0 && s.m_Tmp != 0) {
					sp.m_Tmp = 1;
					continue;
				}
				else continue;
			}

			sp = new StorageItem();
			sp.m_Razdel = s.m_Razdel;
			sp.m_RId = 0;
			sp.m_Owner = 0;
			sp.m_Tmp = 1;
			m_StorageList.splice(i, 0, sp);
		}

		for (i = m_StorageList.length - 1; i >= 0; i--) {
			s = m_StorageList[i];
			if (s.m_Tmp) continue;
			StorageDel(i);
		}

		//for (i = 0; i < m_StorageList.length; i++) { s = m_StorageList[i]; trace(s.m_Razdel, s.m_RId, s.m_Type); }

		Update();
	}
	
	public function StorageDelAll():void
	{
		var i:int;
		var s:StorageItem;
		
		for (i = m_StorageList.length - 1; i >= 0; i--) {
			s = m_StorageList[i];
			StorageDel(i);
		}
	}
	
	public function StorageDel(i:int):void
	{
		if (i<0 || i>=m_StorageList.length) return;

		var s:StorageItem = m_StorageList[i];

		s.m_SIcon = null;
		if (s.m_SRazdel != null) { ItemDelete(ItemByObj(s.m_SRazdel)); s.m_SRazdel = null; }
		if (s.m_SBox != null) { ItemDelete(ItemByObj(s.m_SBox)); s.m_SBox = null; }
		if (s.m_SName != null) { ItemDelete(ItemByObj(s.m_SName)); s.m_SName = null; }
		if (s.m_SOwner != null) { ItemDelete(ItemByObj(s.m_SOwner)); s.m_SOwner = null; }
		if (s.m_SCnt != null) { ItemDelete(ItemByObj(s.m_SCnt)); s.m_SCnt = null; }

		s.m_IIcon = null;
		if (s.m_IRazdel != null) { ItemDelete(ItemByObj(s.m_IRazdel)); s.m_IRazdel = null; }
		if (s.m_IBox != null) { ItemDelete(ItemByObj(s.m_IBox)); s.m_IBox = null; }
		if (s.m_IName != null) { ItemDelete(ItemByObj(s.m_IName)); s.m_IName = null; }
		if (s.m_IOwner != null) { ItemDelete(ItemByObj(s.m_IOwner)); s.m_IOwner = null; }
		if (s.m_ICnt != null) { ItemDelete(ItemByObj(s.m_ICnt)); s.m_ICnt = null; }
		if (s.m_IPrice != null) { ItemDelete(ItemByObj(s.m_IPrice)); s.m_IPrice = null; }
		if (s.m_IStep != null) { ItemDelete(ItemByObj(s.m_IStep)); s.m_IStep = null; }

		s.m_EIcon = null;
		if (s.m_ERazdel != null) { ItemDelete(ItemByObj(s.m_ERazdel)); s.m_ERazdel = null; }
		if (s.m_EBox != null) { ItemDelete(ItemByObj(s.m_EBox)); s.m_EBox = null; }
		if (s.m_EName != null) { ItemDelete(ItemByObj(s.m_EName)); s.m_EName = null; }
		if (s.m_EOwner != null) { ItemDelete(ItemByObj(s.m_EOwner)); s.m_EOwner = null; }
		if (s.m_ECnt != null) { ItemDelete(ItemByObj(s.m_ECnt)); s.m_ECnt = null; }
		if (s.m_EPrice != null) { ItemDelete(ItemByObj(s.m_EPrice)); s.m_EPrice = null; }
		if (s.m_EStep != null) { ItemDelete(ItemByObj(s.m_EStep)); s.m_EStep = null; }

		m_StorageList.splice(i, 1);
	}

	public function StorageSort(a:StorageItem, b:StorageItem):int
	{
		if (a.m_Razdel < b.m_Razdel) return -1;
		else if (a.m_Razdel > b.m_Razdel) return 1;

		if ((a.m_Type & 0xffff) < (b.m_Type & 0xffff)) return -1;
		else if ((a.m_Type & 0xffff) > (b.m_Type & 0xffff)) return 1;

		if (a.m_RId < b.m_RId) return -1;
		else if (a.m_RId > b.m_RId) return 1;

		return 0;
	}
	
	private function changePage(e:Event):void
	{
		if(tab==tabJournal) m_GoToPage=1000000000;
		else m_GoToPage=0;

		if (tab == tabDesc || tab == tabJournal) ListQuery();
		else if (tab == tabStorage || tab == tabImport || tab == tabExport) StorageQuery();
		Update();
	}
	
	public function Update():void
	{
		if (!visible) return;

		if (tab == tabSearch) {
			var t:int = m_KindSearch.ItemData(m_KindSearch.current);

			m_KindSearch.visible = true;
			m_ButSearch.visible = true;
			m_ItemTypeSearch.visible = (t == 0) || (t == 1);
			m_InputSearch.visible = !m_ItemTypeSearch.visible;
			contentSpaceTop = m_ButSearch.height + 10;
		} else {
			m_KindSearch.visible = false;
			m_ButSearch.visible = false;
			m_ItemTypeSearch.visible = false;
			m_InputSearch.visible = false;
			contentSpaceTop = 0;
		}

		if (tab == tabDesc) UpdateText();
		else if (tab == tabJournal) UpdateText();
		else if (tab == tabStorage) StorageUpdate();
		else if (tab == tabImport) ImportUpdate();
		else if (tab == tabExport) ExportUpdate();
		else if (tab == tabSearch) SearchUpdate();

		var tx:int = 0;
		var csp:int = 0;

		tx = innerLeft;// - 15;
		m_ButEnter.x = tx;
		m_ButEnter.y = height - innerBottom - m_ButEnter.height;

		tx = width - innerRight;// contentX + contentWidth;// +5;
		tx -= m_ButOp.width;
		m_ButOp.x = tx;
		m_ButOp.y = height - innerBottom - m_ButOp.height;
		if (m_ButOp.height > csp) csp = m_ButOp.height;

		var vis:Boolean = false;
		while (true) {
			if (tab == tabStorage && StorageAccess()) { }
			else if (tab == tabImport && MgnAccess()) { }
			else if (tab == tabExport && MgnAccess()) { }
			else break;

			vis = true;
			m_ButChange.caption = Common.Txt.StorageChange.toUpperCase();
			tx -= m_ButChange.width;
			m_ButChange.x = tx;
			m_ButChange.y = height - innerBottom - m_ButChange.height;
			break;
		}
		m_ButChange.visible = vis;

		if (tab == tabImport) {
			m_ButAction.visible = true;
			m_ButAction.caption = Common.Txt.StorageSell.toUpperCase();
			tx -= m_ButAction.width;
			m_ButAction.x = tx;
			m_ButAction.y = height - innerBottom - m_ButAction.height;

		} else if (tab == tabExport) {
			m_ButAction.visible = true;
			m_ButAction.caption = Common.Txt.StorageBuy.toUpperCase();
			tx -= m_ButAction.width;
			m_ButAction.x = tx;
			m_ButAction.y = height - innerBottom - m_ButAction.height;

		} else {
			m_ButAction.visible = false;
		}
		
		if ((tab == tabDesc || tab == tabJournal) && (m_List.length >= 2 || (m_Filter != null && m_Filter.length > 0))) {
			m_ButRight.visible = true;
			m_ButLeft.visible = true;
			m_LabelPage.visible = true;
			
			tx -= m_ButRight.width;
			m_ButRight.x = tx;
			m_ButRight.y = m_ButOp.y + (m_ButOp.height >> 1) - (m_ButRight.height >> 1);
			
			if (m_List.length != m_ListFilter.length) m_LabelPage.text = (m_Page + 1).toString() + "/" + (m_ListFilter.length).toString() + " (" + m_List.length.toString() + ")";
			else m_LabelPage.text = (m_Page + 1).toString() + "/" + (m_ListFilter.length).toString();
			tx -= m_LabelPage.width;
			m_LabelPage.x = tx;
			m_LabelPage.y = m_ButOp.y + (m_ButOp.height >> 1) - (m_LabelPage.height >> 1);

			tx -= m_ButLeft.width;
			m_ButLeft.x = tx;
			m_ButLeft.y = m_ButOp.y + (m_ButOp.height >> 1) - (m_ButLeft.height >> 1);

		} else {
			m_ButRight.visible = false;
			m_ButLeft.visible = false;
			m_LabelPage.visible = false;
		}

		m_ImportNeedMoney.visible = false;
		if (tab == tabImport && MgnAccess()) {
			var nm:Number = ImportMoneyNeed();
			if (nm > 0) {
				csp += 30;
				m_ImportNeedMoney.visible = true;
				m_ImportNeedMoney.htmlText = BaseStr.FormatTag("[crt]"+BaseStr.Replace(Common.Txt.StorageNeedMoney, "<Sum>", BaseStr.FormatBigInt(nm))+"[/crt]", true, true);
				m_ImportNeedMoney.width;
				m_ImportNeedMoney.height;
				m_ImportNeedMoney.x = innerLeft - 10;
				m_ImportNeedMoney.y = m_ButChange.y - m_ImportNeedMoney.height - 10;
			}
		}

		if (csp) {
			contentSpaceBottom = csp + 10;
		}
	}

	public function StorageUpdate():void
	{
		var s:StorageItem, s2:StorageItem;
		var i:int, n:int, u:int;
		var str:String;

		Loc(tabStorage, -1, gridGoods, 0, 0, 1, 1);

		var row:int = 0;

		var ropen:Boolean = false;

		for (i = 0; i < m_StorageList.length; i++) {
			s = m_StorageList[i];
			if (s.m_RId == 0) {
				if(s.m_SRazdel == null) {
					if (s.m_Razdel == 1) str = Common.Txt.ItemPageCurrency;
					else if (s.m_Razdel == 2) str = Common.Txt.ItemPageOre;
					else if (s.m_Razdel == 3) str = Common.Txt.ItemPageRefine;
					else if (s.m_Razdel == 4) str = Common.Txt.ItemPageSupply;
					else if (s.m_Razdel == 5) str = Common.Txt.ItemPageMaterial;
					else if (s.m_Razdel == 6) str = Common.Txt.ItemPageOutfit;
					else if (s.m_Razdel == 7) str = Common.Txt.ItemPagePilot;
					else str = Common.Txt.ItemPageOther;

					s.m_SRazdel = ItemObj(ItemCheckBox(str)) as CtrlCheckBox;
					s.m_SRazdel.section = true;
					s.m_SRazdel.addEventListener(Event.CHANGE, StorageRazdelChange);
				}
				n = ItemByObj(s.m_SRazdel); ItemCell(n, 0, row); ItemSpace(n, 0, 5, 0, 3); ItemCellCnt(n, 2, 1);
				
				for (u = i + 1; u < m_StorageList.length; u++) {
					s2 = m_StorageList[u];
					if (s2.m_Razdel != s.m_Razdel) continue;
					if (!s2.m_RId) continue;
					if (!StorageAccess(s2)) continue;
					break;
				}
				if (u < m_StorageList.length) {
					s.m_SRazdel.visible = true;
					ropen = s.m_SRazdel.check;
					row++;
				} else {
					s.m_SRazdel.visible = false;
					ropen = false;
				}
			}
			else if (!ropen || !StorageAccess(s)) {
				if (s.m_SBox != null) s.m_SBox.visible = false;
				if (s.m_SName != null) s.m_SName.visible = false;
				if (s.m_SOwner != null) s.m_SOwner.visible = false;
				if (s.m_SCnt != null) s.m_SCnt.visible = false;
			}
			else {
				var item:Item = null;
				if (s.m_Type != 0) item = UserList.Self.GetItem(s.m_Type & 0xffff);
				
				if (s.m_SBox == null) {
					s.m_SBox = ItemObj(ItemBox()) as CtrlBox;
					s.m_SBox.heightMin = 47;
					s.m_SBox.addEventListener(Event.CHANGE, StorageSelectChange);
					s.m_SBox.doubleClickEnabled = true;
					s.m_SBox.addEventListener(MouseEvent.DOUBLE_CLICK, clickDbl);
				}
				n = ItemByObj(s.m_SBox); ItemCell(n, 0, row); ItemSpace(n, 0, 2, 0, 2); ItemCellCnt(n, 2, 2);
				s.m_SBox.visible = true;

				if (s.m_SIcon == null && item!=null) {
					s.m_SIcon = Common.ItemImg(item.m_Img);
					if (s.m_SIcon != null) {
						s.m_SBox.addChild(s.m_SIcon);
						s.m_SIcon.mouseEnabled = false;
						s.m_SIcon.x = 35;
						s.m_SIcon.y = 47 >> 1;
					}
				}

				if (s.m_SName == null) {
					str = EM.ItemName(s.m_Type);
					s.m_SName = ItemObj(ItemLabel(str)) as TextField;
					s.m_SName.mouseEnabled = false;
				}
				n = ItemByObj(s.m_SName); ItemCell(n, 0, row); 
				if (s.m_Owner) { ItemSpace(n, 60, 2, 0, 0); ItemAlign(n, -1, 1); ItemCellCnt(n, 1, 1); }
				else { ItemSpace(n, 60, 2, 0, 2); ItemAlign(n, -1, 0); ItemCellCnt(n, 1, 2); }
				s.m_SName.visible = true;

				if(s.m_Owner) {
					if (s.m_SOwner == null) {
						str =  EM.Txt_CotlOwnerName(m_CotlId,s.m_Owner);
						s.m_SOwner = ItemObj(ItemLabel(str)) as TextField;
						s.m_SOwner.mouseEnabled = false;
					}
					n = ItemByObj(s.m_SOwner); ItemCell(n, 0, row + 1); ItemSpace(n, 60, 0, 0, 2); ItemAlign(n, -1, -1);
					s.m_SOwner.text = EM.Txt_CotlOwnerName(m_CotlId, s.m_Owner);
					s.m_SOwner.textColor = 0x404040;
					s.m_SOwner.visible = true;
				}

				if (s.m_SCnt == null) {
					s.m_SCnt = ItemObj(ItemLabel("")) as TextField;
					s.m_SCnt.mouseEnabled = false;
				}
				s.m_SCnt.text = BaseStr.FormatBigInt(s.m_Cnt);
				n = ItemByObj(s.m_SCnt); ItemCell(n, 1, row); ItemSpace(n, 10, 2, 30, 2); ItemAlign(n, 1, 0);  ItemCellCnt(n, 1, 2);
				s.m_SCnt.visible = true;

				row+=2;
			}
		}

		m_ButChange.disable = !(StorageAccess() && StorageAccess(storageCurrent, true));

		ContentBuild();
	}
	
	private function StorageSelectChange(e:Event):void
	{
		var i:int;
		var si:StorageItem;
		
		for (i = 0; i < m_StorageList.length; i++) {
			si = m_StorageList[i];
			if (!si.m_SBox) continue;
			if (si.m_SBox == e.target) continue;
			si.m_SBox.select = false;
		}

		m_ButChange.disable = !(StorageAccess() && StorageAccess(storageCurrent, true));
	}
	
	private function StorageRazdelChange(e:Event):void
	{
		Update();
	}
	
	public function ImportMoneyNeed():Number
	{
		var i:int,v:int;
		var s:StorageItem;

		var needmoney:Number = 0;
		var money:Number = 0;

		for (i = 0; i < m_StorageList.length; i++) {
			s = m_StorageList[i];
			if (!s.m_RId) continue;
			if (s.m_Owner != Server.Self.m_UserId) continue;

			if (s.m_Type == Common.ItemTypeMoney) money += s.m_Cnt;

			if (s.m_ImportCnt < -1) continue;
			
			var stackmax:int = 1000000;
			var idesc:Item = UserList.Self.GetItem(s.m_Type & 0xffff);
			if (idesc != null) stackmax = idesc.m_StackMax;

			var limit:int = s.m_ImportLimit;
			if(limit<0) limit=0;
			else if (limit > stackmax * Common.StorageMul) limit = stackmax * Common.StorageMul;

            v = limit - s.m_Cnt;
			if (v <= 0) continue;

			needmoney += Math.floor(Number(v) / s.m_ImportStep) * s.m_ImportPriceMax;
		}

		return needmoney - money;
	}
	
	public function ImportUpdate():void
	{
		var s:StorageItem, s2:StorageItem;
		var i:int, n:int, u:int;
		var str:String;

		Loc(tabImport, -1, gridGoods, 0, 0, 1, 1);

		var row:int = 0;

		var ropen:Boolean = false;

		for (i = 0; i < m_StorageList.length; i++) {
			s = m_StorageList[i];
			if (s.m_RId == 0) {
				if(s.m_IRazdel == null) {
					if (s.m_Razdel == 1) str = Common.Txt.ItemPageCurrency;
					else if (s.m_Razdel == 2) str = Common.Txt.ItemPageOre;
					else if (s.m_Razdel == 3) str = Common.Txt.ItemPageRefine;
					else if (s.m_Razdel == 4) str = Common.Txt.ItemPageSupply;
					else if (s.m_Razdel == 5) str = Common.Txt.ItemPageMaterial;
					else if (s.m_Razdel == 6) str = Common.Txt.ItemPageOutfit;
					else if (s.m_Razdel == 7) str = Common.Txt.ItemPagePilot;
					else str = Common.Txt.ItemPageOther;

					s.m_IRazdel = ItemObj(ItemCheckBox(str)) as CtrlCheckBox;
					s.m_IRazdel.section = true;
					s.m_IRazdel.addEventListener(Event.CHANGE, StorageRazdelChange);
				}
				n = ItemByObj(s.m_IRazdel); ItemCell(n, 0, row); ItemSpace(n, 0, 5, 0, 3); ItemCellCnt(n, 3, 1);
				
				for (u = i + 1; u < m_StorageList.length; u++) {
					s2 = m_StorageList[u];
					if (s2.m_Razdel != s.m_Razdel) continue;
					if (!s2.m_RId) continue;
					if (s2.m_ImportCnt <= -3) continue;
					if (!(TradeAccess() || MgnAccess(s2))) continue;
					if (!MgnAccess(s2) && s2.m_ImportCnt <= 0) continue;
					break;
				}
				if (u < m_StorageList.length) {
					s.m_IRazdel.visible = true;
					ropen = s.m_IRazdel.check;
					row++;
				} else {
					s.m_IRazdel.visible = false;
					ropen = false;
				}
			}
			else if (!ropen || s.m_ImportCnt<=-3 || !(TradeAccess() || MgnAccess(s)) || (!MgnAccess(s2) && s2.m_ImportCnt <= 0)) {
				if (s.m_IBox != null) s.m_IBox.visible = false;
				if (s.m_IName != null) s.m_IName.visible = false;
				if (s.m_IOwner != null) s.m_IOwner.visible = false;
				if (s.m_ICnt != null) s.m_ICnt.visible = false;
				if (s.m_IPrice != null) s.m_IPrice.visible = false;
				if (s.m_IStep != null) s.m_IStep.visible = false;
			}
			else {
				var item:Item = null;
				if (s.m_Type != 0) item = UserList.Self.GetItem(s.m_Type & 0xffff);

				if (s.m_IBox == null) {
					s.m_IBox = ItemObj(ItemBox()) as CtrlBox;
					s.m_IBox.heightMin = 47;
					s.m_IBox.addEventListener(Event.CHANGE, ImportSelectChange);
					s.m_IBox.doubleClickEnabled = true;
					s.m_IBox.addEventListener(MouseEvent.DOUBLE_CLICK, clickDbl);
				}
				n = ItemByObj(s.m_IBox); ItemCell(n, 0, row); ItemSpace(n, 0, 2, 0, 2); ItemCellCnt(n, 3, 2);
				s.m_IBox.visible = true;

				if (s.m_IIcon == null && item!=null) {
					s.m_IIcon = Common.ItemImg(item.m_Img);
					if (s.m_IIcon != null) {
						s.m_IBox.addChild(s.m_IIcon);
						s.m_IIcon.mouseEnabled = false;
						s.m_IIcon.x = 35;
						s.m_IIcon.y = 47 >> 1;
					}
				}

				if (s.m_IName == null) {
					str = EM.ItemName(s.m_Type);
					s.m_IName = ItemObj(ItemLabel(str)) as TextField;
					s.m_IName.mouseEnabled = false;
				}
				n = ItemByObj(s.m_IName); ItemCell(n, 0, row); 
				if (s.m_Owner) { ItemSpace(n, 60, 2, 0, 0); ItemAlign(n, -1, 1); ItemCellCnt(n, 1, 1); }
				else { ItemSpace(n, 60, 2, 0, 2); ItemAlign(n, -1, 0); ItemCellCnt(n, 1, 2); }
				s.m_IName.visible = true;

				if(s.m_Owner) {
					if (s.m_IOwner == null) {
						str =  EM.Txt_CotlOwnerName(m_CotlId,s.m_Owner);
						s.m_IOwner = ItemObj(ItemLabel(str)) as TextField;
						s.m_IOwner.mouseEnabled = false;
					}
					n = ItemByObj(s.m_IOwner); ItemCell(n, 0, row + 1); ItemSpace(n, 60, 0, 0, 2); ItemAlign(n, -1, -1);
					s.m_IOwner.text = EM.Txt_CotlOwnerName(m_CotlId, s.m_Owner);
					s.m_IOwner.textColor = 0x404040;
					s.m_IOwner.visible = true;
				}

				if (s.m_ICnt == null) {
					s.m_ICnt = ItemObj(ItemLabel("")) as TextField;
					s.m_ICnt.mouseEnabled = false;
				}
				s.m_ICnt.text = BaseStr.FormatBigInt(Math.max(0, s.m_ImportCnt));
				n = ItemByObj(s.m_ICnt); ItemCell(n, 1, row); ItemSpace(n, 10, 2, 20, 2); ItemAlign(n, 1, 0);  ItemCellCnt(n, 1, 2);
				s.m_ICnt.visible = true;

				if (s.m_IPrice == null) {
					s.m_IPrice = ItemObj(ItemLabel("")) as TextField;
					s.m_IPrice.mouseEnabled = false;
				}
				s.m_IPrice.text = BaseStr.FormatBigInt(s.m_ImportPrice) + " cr.";
				n = ItemByObj(s.m_IPrice); ItemCell(n, 2, row); ItemSpace(n, 10, 2, 30, 0); ItemAlign(n, 1, 1);  ItemCellCnt(n, 1, 1);
				s.m_IPrice.visible = true;

				if (s.m_IStep == null) {
					s.m_IStep = ItemObj(ItemLabel("")) as TextField;
					s.m_IStep.mouseEnabled = false;
				}
				s.m_IStep.text = BaseStr.FormatBigInt(s.m_ImportStep) + " " + Common.Txt.StorageEd;
				n = ItemByObj(s.m_IStep); ItemCell(n, 2, row + 1); ItemSpace(n, 10, 0, 30, 2); ItemAlign(n, 1, -1);  ItemCellCnt(n, 1, 1);
				s.m_IStep.textColor = 0x404040;
				s.m_IStep.visible = true;

				row+=2;
			}
		}

		ImportSelectChange();

		ContentBuild();
	}
	
	private function ImportSelectChange(e:Event = null):void
	{
		var i:int;
		var si:StorageItem;

		if(e!=null)
		for (i = 0; i < m_StorageList.length; i++) {
			si = m_StorageList[i];
			if (!si.m_IBox) continue;
			if (si.m_IBox == e.target) continue;
			si.m_IBox.select = false;
		}

		if (importCurrent == null) {
			m_ButChange.disable = !(MgnAccess());
		} else {
			si = storageFindByType(importCurrent.m_Type, StorageChangeCurOwner());
			m_ButChange.disable = !(MgnAccess() && MgnAccess(si, true));
		}

		//m_ButChange.disable = !(MgnAccess() && MgnAccess(importCurrent, true));

		if (importCurrent && importCurrent.m_ImportCnt > 0) m_ButAction.disable = false;
		else m_ButAction.disable = true;
	}

	public function ExportUpdate():void
	{
		var s:StorageItem, s2:StorageItem;
		var i:int, n:int, u:int;
		var str:String;

		Loc(tabExport, -1, gridGoods, 0, 0, 1, 1);

		var row:int = 0;

		var ropen:Boolean = false;

		for (i = 0; i < m_StorageList.length; i++) {
			s = m_StorageList[i];
			if (s.m_RId == 0) {
				if(s.m_ERazdel == null) {
					if (s.m_Razdel == 1) str = Common.Txt.ItemPageCurrency;
					else if (s.m_Razdel == 2) str = Common.Txt.ItemPageOre;
					else if (s.m_Razdel == 3) str = Common.Txt.ItemPageRefine;
					else if (s.m_Razdel == 4) str = Common.Txt.ItemPageSupply;
					else if (s.m_Razdel == 5) str = Common.Txt.ItemPageMaterial;
					else if (s.m_Razdel == 6) str = Common.Txt.ItemPageOutfit;
					else if (s.m_Razdel == 7) str = Common.Txt.ItemPagePilot;
					else str = Common.Txt.ItemPageOther;

					s.m_ERazdel = ItemObj(ItemCheckBox(str)) as CtrlCheckBox;
					s.m_ERazdel.section = true;
					s.m_ERazdel.addEventListener(Event.CHANGE, StorageRazdelChange);
				}
				n = ItemByObj(s.m_ERazdel); ItemCell(n, 0, row); ItemSpace(n, 0, 5, 0, 3); ItemCellCnt(n, 3, 1);

				for (u = i + 1; u < m_StorageList.length; u++) {
					s2 = m_StorageList[u];
					if (s2.m_Razdel != s.m_Razdel) continue;
					if (!s2.m_RId) continue;
					if (s2.m_ExportCnt <= -3) continue;
					if (!(TradeAccess() || MgnAccess(s2))) continue;
					if (!MgnAccess(s2) && s2.m_ExportCnt <= 0) continue;
					break;
				}
				if (u < m_StorageList.length) {
					s.m_ERazdel.visible = true;
					ropen = s.m_ERazdel.check;
					row++;
				} else {
					s.m_ERazdel.visible = false;
					ropen = false;
				}
			}
			else if (!ropen || s.m_ExportCnt<=-3 || !(TradeAccess() || MgnAccess(s)) || (!MgnAccess(s2) && s2.m_ExportCnt <= 0)) {
				if (s.m_EBox != null) s.m_EBox.visible = false;
				if (s.m_EName != null) s.m_EName.visible = false;
				if (s.m_EOwner != null) s.m_EOwner.visible = false;
				if (s.m_ECnt != null) s.m_ECnt.visible = false;
				if (s.m_EPrice != null) s.m_EPrice.visible = false;
				if (s.m_EStep != null) s.m_EStep.visible = false;
			}
			else {
				var item:Item = null;
				if (s.m_Type != 0) item = UserList.Self.GetItem(s.m_Type & 0xffff);

				if (s.m_EBox == null) {
					s.m_EBox = ItemObj(ItemBox()) as CtrlBox;
					s.m_EBox.heightMin = 47;
					s.m_EBox.addEventListener(Event.CHANGE, ExportSelectChange);
					s.m_EBox.doubleClickEnabled = true;
					s.m_EBox.addEventListener(MouseEvent.DOUBLE_CLICK, clickDbl);
				}
				n = ItemByObj(s.m_EBox); ItemCell(n, 0, row); ItemSpace(n, 0, 2, 0, 2); ItemCellCnt(n, 3, 2);
				s.m_EBox.visible = true;

				if (s.m_EIcon == null && item!=null) {
					s.m_EIcon = Common.ItemImg(item.m_Img);
					if (s.m_EIcon != null) {
						s.m_EBox.addChild(s.m_EIcon);
						s.m_EIcon.mouseEnabled = false;
						s.m_EIcon.x = 35;
						s.m_EIcon.y = 47 >> 1;
					}
				}

				if (s.m_EName == null) {
					str = EM.ItemName(s.m_Type);
					s.m_EName = ItemObj(ItemLabel(str)) as TextField;
					s.m_EName.mouseEnabled = false;
				}
				n = ItemByObj(s.m_EName); ItemCell(n, 0, row); 
				if (s.m_Owner) { ItemSpace(n, 60, 2, 0, 0); ItemAlign(n, -1, 1); ItemCellCnt(n, 1, 1); }
				else { ItemSpace(n, 60, 2, 0, 2); ItemAlign(n, -1, 0); ItemCellCnt(n, 1, 2); }
				s.m_EName.visible = true;

				if(s.m_Owner) {
					if (s.m_EOwner == null) {
						str =  EM.Txt_CotlOwnerName(m_CotlId,s.m_Owner);
						s.m_EOwner = ItemObj(ItemLabel(str)) as TextField;
						s.m_EOwner.mouseEnabled = false;
					}
					n = ItemByObj(s.m_EOwner); ItemCell(n, 0, row + 1); ItemSpace(n, 60, 0, 0, 2); ItemAlign(n, -1, -1);
					s.m_EOwner.text = EM.Txt_CotlOwnerName(m_CotlId, s.m_Owner);
					s.m_EOwner.textColor = 0x404040;
					s.m_EOwner.visible = true;
				}

				if (s.m_ECnt == null) {
					s.m_ECnt = ItemObj(ItemLabel("")) as TextField;
					s.m_ECnt.mouseEnabled = false;
				}
				s.m_ECnt.text = BaseStr.FormatBigInt(Math.max(0, s.m_ExportCnt));
				n = ItemByObj(s.m_ECnt); ItemCell(n, 1, row); ItemSpace(n, 10, 2, 20, 2); ItemAlign(n, 1, 0);  ItemCellCnt(n, 1, 2);
				s.m_ECnt.visible = true;

				if (s.m_EPrice == null) {
					s.m_EPrice = ItemObj(ItemLabel("")) as TextField;
					s.m_EPrice.mouseEnabled = false;
				}
				s.m_EPrice.text = BaseStr.FormatBigInt(s.m_ExportPrice) + " cr.";
				n = ItemByObj(s.m_EPrice); ItemCell(n, 2, row); ItemSpace(n, 10, 2, 30, 0); ItemAlign(n, 1, 1);  ItemCellCnt(n, 1, 1);
				s.m_EPrice.visible = true;

				if (s.m_EStep == null) {
					s.m_EStep = ItemObj(ItemLabel("")) as TextField;
					s.m_EStep.mouseEnabled = false;
				}
				s.m_EStep.text = BaseStr.FormatBigInt(s.m_ExportStep) + " " + Common.Txt.StorageEd;
				n = ItemByObj(s.m_EStep); ItemCell(n, 2, row + 1); ItemSpace(n, 10, 0, 30, 2); ItemAlign(n, 1, -1);  ItemCellCnt(n, 1, 1);
				s.m_EStep.textColor = 0x404040;
				s.m_EStep.visible = true;

				row+=2;
			}
		}

		ExportSelectChange();

		ContentBuild();
	}
	
	private function ExportSelectChange(e:Event = null):void
	{
		var i:int;
		var si:StorageItem;

		if(e!=null)
		for (i = 0; i < m_StorageList.length; i++) {
			si = m_StorageList[i];
			if (!si.m_EBox) continue;
			if (si.m_EBox == e.target) continue;
			si.m_EBox.select = false;
		}

		if (exportCurrent == null) {
			m_ButChange.disable = !(MgnAccess());
		} else {
			si = storageFindByType(exportCurrent.m_Type, StorageChangeCurOwner());
			m_ButChange.disable = !(MgnAccess() && MgnAccess(si, true));
		}

//		m_ButChange.disable = !(MgnAccess() && MgnAccess(exportCurrent, true));

		if (exportCurrent && exportCurrent.m_ExportCnt > 0) m_ButAction.disable = false;
		else m_ButAction.disable = true;
	}

	public function storageFindByType(it:uint, userid:uint):StorageItem
	{
		var i:int;
		var si:StorageItem;

		for (i = 0; i < m_StorageList.length; i++) {
			si = m_StorageList[i];
			if (si.m_Type != it) continue;
			if (si.m_Owner != userid) continue;
			
			return si;
		}
		return null;
	}
	
	public function get storageCurrent():StorageItem
	{
		var i:int;
		var si:StorageItem;

		for (i = 0; i < m_StorageList.length; i++) {
			si = m_StorageList[i];
			if (!si.m_SBox) continue;
			if (!si.m_SBox.select) continue;
			
			return si;
		}
		return null;
	}
	
	public function storageCurrentSetByType(it:uint, owner:uint):void
	{
		var i:int;
		var si:StorageItem;

		for (i = 0; i < m_StorageList.length; i++) {
			si = m_StorageList[i];
			if (!si.m_SBox) continue;
			if (!si.m_RId) { si.m_SBox.select = false; continue; }
			if (si.m_Owner != owner) { si.m_SBox.select = false; continue; }
			if (si.m_Type != it) { si.m_SBox.select = false; continue; }
			si.m_SBox.select = true;
			it = 0xffffffff;
		}
	}
	
	public function get importCurrent():StorageItem
	{
		var i:int;
		var si:StorageItem;

		for (i = 0; i < m_StorageList.length; i++) {
			si = m_StorageList[i];
			if (si.m_ImportCnt <= -3) continue;
			if (!si.m_IBox) continue;
			if (!si.m_IBox.select) continue;
			
			return si;
		}
		return null;
	}

	public function get exportCurrent():StorageItem
	{
		var i:int;
		var si:StorageItem;

		for (i = 0; i < m_StorageList.length; i++) {
			si = m_StorageList[i];
			if (si.m_ExportCnt <= -3) continue;
			if (!si.m_EBox) continue;
			if (!si.m_EBox.select) continue;
			
			return si;
		}
		return null;
	}
	
	public function StorageChangeCurOwner():uint
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return Server.Self.m_UserId;
		if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) return 0;
		return Server.Self.m_UserId;
	}
	
	public function SackAccess(si:StorageItem):Boolean
	{
		if (si == null) return false;
		if (si.m_Owner == 0) return false;
		if (si.m_Owner & Common.OwnerAI) return false;

		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return false;

		if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) return false;

		var clientuser:User = UserList.Self.GetUser(Server.Self.m_UserId);
		if (clientuser == null) return false;
		if (clientuser.m_UnionId == 0) return false;

		var siuser:User = UserList.Self.GetUser(si.m_Owner);
		if (siuser == null) return false;

		if (cotl.m_CotlType == Common.CotlTypeUser) {
			if (cotl.m_UnionId != 0) {
				if (cotl.m_UnionId == clientuser.m_UnionId && clientuser.m_UnionId != siuser.m_UnionId) return true;
			}
		} else if (cotl.m_CotlType == Common.CotlTypeRich || cotl.m_CotlType == Common.CotlTypeProtect) {
			if (cotl.m_UnionId == clientuser.m_UnionId && clientuser.m_UnionId != siuser.m_UnionId) return true;
		}
		
		return false;
	}

	public function StorageAccess(si:StorageItem = null, change:Boolean = false):Boolean
	{
		var ret:Boolean = false;
		
		var siuser:User;

		while (true) {
			var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
			if (cotl == null) break;

			var clientuser:User = UserList.Self.GetUser(Server.Self.m_UserId);
			if (clientuser == null) break;
			
			if ((cotl.m_CotlFlag & SpaceCotl.fDevelopment)) {
				// Созвездие в разработке

				if (si == null) {
					// Отображение хранилища
					if ((EM.m_UserAccess & User.AccessGalaxyOps) != 0) ret = true;
				} else {
					// Отображение конкретного товара
					if (si.m_Owner == 0) ret = true;
				}
				
			} else if (!change) {
				// Доступ на просмотр
				if (cotl.m_CotlType == Common.CotlTypeUser && cotl.m_UnionId != 0) {
					// Личка захвачена
					if (si == null) {
						// Отображение хранилища
						if (cotl.m_AccountId == clientuser.m_Id) ret = true;
						else if (cotl.m_UnionId == clientuser.m_UnionId) ret = true;
					} else {
						// Отображение конкретного товара
						if (si.m_Owner == clientuser.m_Id) ret = true;
						else if (si.m_Owner == cotl.m_AccountId) ret = true;
					}
					
				} else if (cotl.m_CotlType == Common.CotlTypeUser) {
					// Личка
					if (si == null) {
						// Отображение хранилища
						if (cotl.m_AccountId == clientuser.m_Id) ret = true;
					} else {
						// Отображение конкретного товара
						if (si.m_Owner == clientuser.m_Id) ret = true;
					}
					
				} else if (cotl.m_CotlType == Common.CotlTypeRich || cotl.m_CotlType == Common.CotlTypeProtect) {
					// Бот созвездия
					if (si == null) {
						// Отображение хранилища
						if (cotl.m_UnionId != 0 && cotl.m_UnionId == clientuser.m_UnionId) ret = true;
					} else {
						// Отображение конкретного товара
						if (si.m_Owner == clientuser.m_Id) ret = true;
						else if (si.m_Owner != clientuser.m_Id && si.m_Owner != 0 && clientuser.m_UnionId != 0) {
							siuser = UserList.Self.GetUser(si.m_Owner);
							if (siuser != null && siuser.m_UnionId != clientuser.m_UnionId) ret = true;
						}
					}
				}
				
			} else if (si == null) {
				// Добавить
				if (cotl.m_CotlType == Common.CotlTypeUser && cotl.m_UnionId != 0) {
					// Личка захвачена

				} else if (cotl.m_CotlType == Common.CotlTypeUser) {
					// Личка
					if (cotl.m_AccountId == clientuser.m_Id && cotl.m_UnionId == 0) ret = true;
					
				} else if (cotl.m_CotlType == Common.CotlTypeRich || cotl.m_CotlType == Common.CotlTypeProtect) {
					// Бот созвездия
					if (cotl.m_UnionId != 0 && cotl.m_UnionId == clientuser.m_UnionId) ret = true;
				}

			} else {
				// Изменить
				if (cotl.m_CotlType == Common.CotlTypeUser && cotl.m_UnionId != 0) {
					// Личка захвачена

				} else if (cotl.m_CotlType == Common.CotlTypeUser) {
					// Личка
					if (si.m_Owner == clientuser.m_Id && cotl.m_UnionId == 0) ret = true;

				} else if (cotl.m_CotlType == Common.CotlTypeRich || cotl.m_CotlType == Common.CotlTypeProtect) {
					// Бот созвездия
					if (si.m_Owner == clientuser.m_Id && cotl.m_UnionId != 0 && cotl.m_UnionId == clientuser.m_UnionId) ret = true;
				}
			}

			break;
		}
		
		return ret;
	}
	
/*	public function StorageAccessOld(si:StorageItem = null):Boolean
	{
		var ret:Boolean = false;

		while (true) {
			if ((EM.m_UserAccess & User.AccessGalaxyOps)) { 
				//if (si != null && si.m_Owner != 0) { }
				//else {
					ret = true; break;
				//}
			}
			// (si == null || si.m_Owner == 0) && 

			var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
			if (cotl == null) break;
			if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) break;

			var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
			if (user == null) break;

			if (cotl.m_CotlType == Common.CotlTypeUser) {
				if (cotl.m_UnionId) {
					if (user.m_UnionId != cotl.m_UnionId) break;
				} else {
					if (cotl.m_AccountId != user.m_Id) break;
				}

			} else if (cotl.m_CotlType == Common.CotlTypeRich || cotl.m_CotlType == Common.CotlTypeProtect) {
				if (!cotl.m_UnionId) break;
				if (user.m_UnionId != cotl.m_UnionId) break;

			} else break;

			if (si == null) ret = true;
			else if (si.m_Owner == Server.Self.m_UserId) ret = true;
			else if (cotl.m_CotlType == Common.CotlTypeUser && cotl.m_UnionId && user.m_UnionId == cotl.m_UnionId) {
				var user2:User = UserList.Self.GetUser(si.m_Owner);
				if (!user2) break;
				if (user2.m_UnionId != user.m_UnionId) ret = true;
			}

			break;
		}
		
		return ret;
	}*/

	public function MgnAccess(si:StorageItem = null, change:Boolean = false):Boolean
	{
		return StorageAccess(si, change);
/*		var ret:Boolean = false;

		while(true) {
			if (EM.m_UserAccess & User.AccessGalaxyOps) { ret = true; break; }

			var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
			if (cotl == null) break;
			if (cotl.m_CotlFlag & SpaceCotl.fDevelopment) break;

			var user:User = UserList.Self.GetUser(Server.Self.m_UserId);
			if (user == null) break;

			if (cotl.m_CotlType == Common.CotlTypeUser) {
				if (cotl.m_AccountId != user.m_Id) break;

			} else if (cotl.m_CotlType == Common.CotlTypeRich || cotl.m_CotlType == Common.CotlTypeProtect) {
				if (!cotl.m_UnionId) break;
				if (user.m_UnionId != cotl.m_UnionId) break;

			} else break;

			if (si == null) ret = true;
			else if (si.m_Owner == Server.Self.m_UserId) ret = true;

			break;
		}
		
		return ret;*/
	}
	
	public function TradeAccess():Boolean
	{
		return true;
	}

	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	public function KindSearchChange(e:Event):void
	{
		Update();
	}

	public function clickSearch(e:Event):void
	{
		var src:String;

		SearchDelAll();

		var t:int = m_KindSearch.ItemData(m_KindSearch.current);

		if (t==0 || t==1) {
			src = "&val=" + t.toString() + "_" + m_ItemTypeSearch.ItemData(m_ItemTypeSearch.current).toString();
			Server.Self.Query("emfind", "&cotlid=" + m_CotlId.toString() + "&type=3" + src, SearchRecv, false);

		} else if (t == 2) {
			src = BaseStr.Trim(m_InputSearch.text);

			var p_cotlid:uint = 0;
			var p_userid:uint = 0;

			p_cotlid = EM.TxtFind(EM.m_Txt, 1, src);
			if (p_cotlid == 0) {
				t = src.indexOf(":");
				if (t < 0) {
					var user:User = UserList.Self.FindUser(src);
					if (user != null) p_userid = user.m_Id;
				} else {
					p_userid = BaseStr.ParseUint(src.substr(0, t));
				}
			}

			if (p_cotlid != 0 || p_userid != 0) {
				src = "&val=" + p_cotlid.toString() + "_" + p_userid.toString();
				Server.Self.Query("emfind", "&cotlid=" + m_CotlId.toString() + "&type=2" + src, SearchRecv, false);
			}
		}
	}
	
	public function SearchDelAll():void
	{
		var i:int;
		var s:StorageSearch;

		m_SearchRecvType = -1;

		for (i = m_SearchArray.length - 1; i >= 0; i--) {
			s = m_SearchArray[i];
			SearchDelete(i);
		}
	}

	public function SearchDelete(i:int):void
	{
		if (i<0 || i>=m_SearchArray.length) return;

		var s:StorageSearch = m_SearchArray[i];

		s.m_IIcon = null;
		if (s.m_IBox != null) { ItemDelete(ItemByObj(s.m_IBox)); s.m_IBox = null; }
		if (s.m_IName != null) { ItemDelete(ItemByObj(s.m_IName)); s.m_IName = null; }
		if (s.m_IOwner != null) { ItemDelete(ItemByObj(s.m_IOwner)); s.m_IOwner = null; }
		if (s.m_ICnt != null) { ItemDelete(ItemByObj(s.m_ICnt)); s.m_ICnt = null; }
		if (s.m_IPrice != null) { ItemDelete(ItemByObj(s.m_IPrice)); s.m_IPrice = null; }
		if (s.m_IStep != null) { ItemDelete(ItemByObj(s.m_IStep)); s.m_IStep = null; }

		m_SearchArray.splice(i, 1);
	}
	
	private function SearchRecv(event:Event):void
	{
		var accountid:uint;
		var i:int, n:int;
		var cx:int;
		var cy:int;
		var dist:int;
		var inview:Boolean;
		var ax:Number, ay:Number;
		var str:String;
		var ss:StorageSearch;

		var loader:URLLoader = URLLoader(event.target);
		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint = buf.readUnsignedByte();
		if (err == Server.ErrorNotFound) {
			return;
		}
		else if (err == Server.ErrorNoEnoughMoney) {
			return;
		}
		else if (EM.ErrorFromServer(err)) return;

		var cotl_from:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl_from == null) return;

		var type:int = buf.readUnsignedByte();
		var cotlid:uint = buf.readUnsignedInt();

		SearchDelAll();
		m_SearchRecvType = type;

		if (type == 3) {
			var dir:int = buf.readUnsignedByte();
			var goodstype:int = buf.readUnsignedInt();

			while (true) {
				cotlid = buf.readUnsignedInt();
				if (cotlid == 0) break;

				accountid = buf.readUnsignedInt();
				inview = buf.readUnsignedByte() != 0;
				if(inview) {
					cx = buf.readInt();
					cy = buf.readInt();
				} else {
					cx = 0;
					cy = 0;
				}
				var goodstype2:uint = buf.readUnsignedInt();
				var cnt:int = buf.readInt();
				var step:int = buf.readInt();
				var price:int = buf.readInt();

				ss = new StorageSearch();
				m_SearchArray.push(ss);

				ss.m_CotlId = cotlid;
				ss.m_Owner = accountid;
				if (inview) {
					if (EM.m_RootCotlId == m_CotlId) {
						ax = cx - EM.m_HomeworldCotlX;
						ay = cy - EM.m_HomeworldCotlY;
					} else {
						ax = cx - (cotl_from.m_ZoneX * EM.HS.SP.m_ZoneSize + cotl_from.m_PosX);
						ay = cy - (cotl_from.m_ZoneY * EM.HS.SP.m_ZoneSize + cotl_from.m_PosY);
					}
					ss.m_Dist = Math.round(Math.sqrt(ax * ax + ay * ay) / EM.HS.SP.m_ZoneSize);
				} else {
					ss.m_Dist = -1;
				}
				ss.m_Type = goodstype2;
				ss.m_Cnt = cnt;
				ss.m_Price = price;
				ss.m_Step = step;
				ss.m_InView = inview;
				ss.m_CX = cx;
				ss.m_CY = cy;
			}

		} else if (type == 2) {
			while (true) {
				cotlid = buf.readUnsignedInt();
				if (cotlid == 0) break;

				accountid = buf.readUnsignedInt();
				inview = buf.readUnsignedByte() != 0;
				if(inview) {
					cx = buf.readInt();
					cy = buf.readInt();
				} else {
					cx = 0;
					cy = 0;
				}

				ss = new StorageSearch();
				m_SearchArray.push(ss);

				ss.m_CotlId = cotlid;
				ss.m_Owner = accountid;
				if(inview) {
					if (EM.m_RootCotlId == m_CotlId) {
						ax = cx - EM.m_HomeworldCotlX;
						ay = cy - EM.m_HomeworldCotlY;
					} else {
						ax = cx - (cotl_from.m_ZoneX * EM.HS.SP.m_ZoneSize + cotl_from.m_PosX);
						ay = cy - (cotl_from.m_ZoneY * EM.HS.SP.m_ZoneSize + cotl_from.m_PosY);
					}
					ss.m_Dist = Math.round(Math.sqrt(ax * ax + ay * ay) / EM.HS.m_ZoneSize);
				} else {
					ss.m_Dist = -1;
				}
				ss.m_InView = inview;
				ss.m_CX = cx;
				ss.m_CY = cy;
			}
		}

		SearchUpdate();
	}
	
	private function SearchUpdate():void
	{
		var i:int, n:int;
		var type:uint;
		var str:String;
		var ss:StorageSearch;

		Loc(tabSearch, -1, gridGoods, 0, 0, 1, 1);

		var row:int = 0;

		if (m_SearchRecvType == 3) {
			for (i = 0; i < m_SearchArray.length; i++) {
				ss = m_SearchArray[i];

				var item:Item = null;
				if (ss.m_Type != 0) item = UserList.Self.GetItem(ss.m_Type & 0xffff);

				if (ss.m_IBox == null) {
					ss.m_IBox = ItemObj(ItemBox()) as CtrlBox;
					ss.m_IBox.heightMin = 47;
					ss.m_IBox.addEventListener(Event.CHANGE, SearchSelectChange);
					ss.m_IBox.addEventListener(MouseEvent.MOUSE_OVER, SearchOver);
					ss.m_IBox.addEventListener(MouseEvent.MOUSE_OUT, SearchOut);
					ss.m_IBox.doubleClickEnabled = true;
				}
				n = ItemByObj(ss.m_IBox); ItemCell(n, 0, row); ItemSpace(n, 0, 2, 0, 2); ItemCellCnt(n, 3, 2);
				ss.m_IBox.visible = true;

				if (ss.m_IIcon == null && item!=null) {
					ss.m_IIcon = Common.ItemImg(item.m_Img);
					if (ss.m_IIcon != null) {
						ss.m_IBox.addChild(ss.m_IIcon);
						ss.m_IIcon.mouseEnabled = false;
						ss.m_IIcon.x = 35;
						ss.m_IIcon.y = 47 >> 1;
					}
				}

				if (ss.m_IName == null) {
					str = EM.ItemName(ss.m_Type);
					ss.m_IName = ItemObj(ItemLabel(str)) as TextField;
					ss.m_IName.mouseEnabled = false;
				}
				n = ItemByObj(ss.m_IName); ItemCell(n, 0, row); 
				/*if (ss.m_Owner) {*/ ItemSpace(n, 60, 2, 0, 0); ItemAlign(n, -1, 1); ItemCellCnt(n, 1, 1); //}
				//else { ItemSpace(n, 60, 2, 0, 2); ItemAlign(n, -1, 0); ItemCellCnt(n, 1, 2); }
				ss.m_IName.visible = true;

				//if(ss.m_Owner) {
					if (ss.m_IOwner == null) {
						str =  EM.Txt_CotlOwnerName(m_CotlId,ss.m_Owner);
						ss.m_IOwner = ItemObj(ItemLabel(str)) as TextField;
						ss.m_IOwner.mouseEnabled = false;
					}
					n = ItemByObj(ss.m_IOwner); ItemCell(n, 0, row + 1); ItemSpace(n, 60, 0, 0, 2); ItemAlign(n, -1, -1);
					//ss.m_IOwner.textColor = 0x404040;
					ss.m_IOwner.visible = true;
				//}
				str = "";
				if (ss.m_InView) str += ss.m_Dist.toString() + ", ";
				else str += "";
				ss.m_IOwner.text = str + EM.CotlName(ss.m_CotlId);//EM.Txt_CotlOwnerName(m_CotlId, ss.m_Owner);

				if (ss.m_ICnt == null) {
					ss.m_ICnt = ItemObj(ItemLabel("")) as TextField;
					ss.m_ICnt.mouseEnabled = false;
				}
				ss.m_ICnt.text = BaseStr.FormatBigInt(Math.max(0, ss.m_Cnt));
				n = ItemByObj(ss.m_ICnt); ItemCell(n, 1, row); ItemSpace(n, 10, 2, 20, 2); ItemAlign(n, 1, 0);  ItemCellCnt(n, 1, 2);
				ss.m_ICnt.visible = true;

				if (ss.m_IPrice == null) {
					ss.m_IPrice = ItemObj(ItemLabel("")) as TextField;
					ss.m_IPrice.mouseEnabled = false;
				}
				ss.m_IPrice.text = BaseStr.FormatBigInt(ss.m_Price) + " cr.";
				n = ItemByObj(ss.m_IPrice); ItemCell(n, 2, row); ItemSpace(n, 10, 2, 30, 0); ItemAlign(n, 1, 1);  ItemCellCnt(n, 1, 1);
				ss.m_IPrice.visible = true;

				if (ss.m_IStep == null) {
					ss.m_IStep = ItemObj(ItemLabel("")) as TextField;
					ss.m_IStep.mouseEnabled = false;
				}
				ss.m_IStep.text = BaseStr.FormatBigInt(ss.m_Step) + " " + Common.Txt.StorageEd;
				n = ItemByObj(ss.m_IStep); ItemCell(n, 2, row + 1); ItemSpace(n, 10, 0, 30, 2); ItemAlign(n, 1, -1);  ItemCellCnt(n, 1, 1);
				ss.m_IStep.textColor = 0x404040;
				ss.m_IStep.visible = true;

				row += 2;
			}
		} else if (m_SearchRecvType == 2) {
			for (i = 0; i < m_SearchArray.length; i++) {
				ss = m_SearchArray[i];

				if (ss.m_IBox == null) {
					ss.m_IBox = ItemObj(ItemBox()) as CtrlBox;
					ss.m_IBox.heightMin = 47;
					ss.m_IBox.addEventListener(Event.CHANGE, SearchSelectChange);
					ss.m_IBox.addEventListener(MouseEvent.MOUSE_OVER, SearchOver);
					ss.m_IBox.addEventListener(MouseEvent.MOUSE_OUT, SearchOut);
					ss.m_IBox.doubleClickEnabled = true;
				}
				n = ItemByObj(ss.m_IBox); ItemCell(n, 0, row); ItemSpace(n, 0, 2, 0, 2); ItemCellCnt(n, 3, 2);
				ss.m_IBox.visible = true;

				if (ss.m_IName == null) {
					str = EM.CotlName(ss.m_CotlId);
					ss.m_IName = ItemObj(ItemLabel(str)) as TextField;
					ss.m_IName.mouseEnabled = false;
				}
				n = ItemByObj(ss.m_IName); ItemCell(n, 0, row); 
				ItemSpace(n, 60, 2, 0, 2); ItemAlign(n, -1, 0); ItemCellCnt(n, 1, 2);
				ss.m_IName.visible = true;

				if (ss.m_ICnt == null) {
					ss.m_ICnt = ItemObj(ItemLabel("")) as TextField;
					ss.m_ICnt.mouseEnabled = false;
				}
				if (!ss.m_InView) ss.m_ICnt.text = "-";
				else ss.m_ICnt.text = ss.m_Dist.toString();
				n = ItemByObj(ss.m_ICnt); ItemCell(n, 1, row); ItemSpace(n, 10, 2, 20, 2); ItemAlign(n, 1, 0);  ItemCellCnt(n, 1, 2);
				ss.m_ICnt.visible = true;
			}
		}

		SearchSelectChange();

		ContentBuild();
	}

	private function SearchSelectChange(e:Event = null):void
	{
		var i:int;
		var ss:StorageSearch;

		if(e!=null)
		for (i = 0; i < m_SearchArray.length; i++) {
			ss = m_SearchArray[i];
			if (!ss.m_IBox) continue;
			if (ss.m_IBox == e.target) continue;
			ss.m_IBox.select = false;
		}
	}
	
	private function SearchOver(e:MouseEvent):void
	{
		var i:int, u:int;
		var r:Number, vx:Number, vy:Number;
		var ss:StorageSearch;
		var tx:Number, ty:Number;

		if (!EM.m_FormRadar.visible) return;

		for (i = 0; i < m_SearchArray.length; i++) {
			ss = m_SearchArray[i];
			if (!ss.m_IBox) continue;
			if (ss.m_IBox != e.target) continue;
			if (!ss.m_InView) continue;

			var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);
			if (cotl == null) return;

			if (m_CotlId == EM.m_RootCotlId) {
				tx = EM.m_HomeworldCotlX;
				ty = EM.m_HomeworldCotlY;
			} else {
				tx = cotl.m_ZoneX * EM.HS.SP.m_ZoneSize + cotl.m_PosX;
				ty = cotl.m_ZoneY * EM.HS.SP.m_ZoneSize + cotl.m_PosY;
			}
			//if (!EM.m_FormRadar.m_OpenFull) {
				var mr:Number = 1e20;
				for (u = 0; u < EM.SP.m_EntityList.length; u++) {
					var se:SpaceEntity = EM.SP.m_EntityList[u];
					if (se.m_EntityType != SpaceEntity.TypePlanet) continue;
					var sp:SpacePlanet = se as SpacePlanet;
					if (sp.m_CotlId != m_CotlId) continue;
					if ((sp.m_PlanetFlag & SpacePlanet.FlagTypeMask) != SpacePlanet.FlagTypePlanet) continue;

					vx = sp.m_ZoneX * EM.HS.SP.m_ZoneSize + sp.m_PosX - (EM.HS.m_CamZoneX * EM.HS.SP.m_ZoneSize + EM.HS.m_CamPos.x);
					vy = sp.m_ZoneY * EM.HS.SP.m_ZoneSize + sp.m_PosY - (EM.HS.m_CamZoneY * EM.HS.SP.m_ZoneSize + EM.HS.m_CamPos.y);
					r = vx * vx + vy * vy;
//trace(sp.m_CotlId.toString() + "_" + sp.m_Id.toString() + ":", vx, vy, r);

					if (r < mr) {
						mr = r;
						tx = sp.m_ZoneX * EM.HS.SP.m_ZoneSize + sp.m_PosX;
						ty = sp.m_ZoneY * EM.HS.SP.m_ZoneSize + sp.m_PosY;
					}
				}
				//if (mr >= 1e19) return;
//			}

			EM.m_FormRadar.ShowLine(ss.m_CX, ss.m_CY, tx, ty);
			break;
		}
	}

	private function SearchOut(e:MouseEvent):void
	{
		EM.m_FormRadar.HideLine();
	}
	
	public function SearchCotlUser(userid:uint):void
	{
		if (!userid) return;
		Hide();
		
		tab = tabSearch;
		m_KindSearch.current = 2;

		m_InputSearch.text = userid.toString() + ": " + EmpireMap.Self.Txt_CotlOwnerName(0, userid, true);
		
		Show();
		
		clickSearch(null);
	}

	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	public function ListQuery():void
	{
		m_List.length = 0;
		m_ListFilter = m_List;
		m_Journal.text = "";
		m_Desc.text = "";

		var str:String = "&type=1&id=" + m_CotlId.toString();
		if (tab == tabJournal) str += "&period=" + ( -30 * 24 * 60 * 60).toString(); 
		else str += "&period=10000";
		Server.Self.Query("emhist", str, ListAnswer, false);
	}

	public function ListAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if(EM.ErrorFromServer(buf.readUnsignedByte())) return;

		buf.readUnsignedInt();
		buf.readUnsignedInt();

		m_List.length=0;

		while(true) {
			var rid:uint=buf.readUnsignedInt();
			if(rid==0) break;
			var dt:uint=buf.readUnsignedInt();
			var author:uint=buf.readUnsignedInt();
			var tt:int=buf.readUnsignedByte();
			var len:int=buf.readUnsignedShort();
			var str:String=buf.readUTFBytes(len);

			var obj:Object=new Object();
			obj.Id=rid;
			obj.Prior=dt;
			obj.Author=author;
			obj.Type=tt;
			obj.Text=str;

			m_List.push(obj);
		}

		//if (tab == tabDesc || tab == tabJournal) UpdateText();
		Update();
	}

	public function BuildText(obj:Object):Boolean
	{
		var str:String = "";
		var user:User;
		var ret:Boolean = true;

		var addtolocal:Number = (new Date()).getTime() - EM.m_ConnectDate.getTime();

		var head:Boolean = false;
		if (tab == tabJournal) {
			var md:Date = EM.GetServerDate();
			md.setTime(md.getTime() + (obj.Prior * 1000 - EM.GetServerGlobalTime()) + addtolocal);

			str += Common.Hist.Date + ": [clr]" + Common.DateToStr(md, false) + "[/clr]<br>";
			head = true;
		}
		if (tab == tabJournal && obj.Author != 0) {
			user = UserList.Self.GetUser(obj.Author);
			if (obj.Author != 0 && user == null) return false;
			if (user != null) {
				str += Common.Hist.Author + " [clr]" + EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id) + "[/clr]:<br>";
				head = true;
			}
		}
		if (head) str += "<br>";

		if (obj.Type == 2) { if (FormHist.FormatSpecial(m_CotlId, obj)) str += obj.Final; else ret = false; }
		else if (obj.Type == 3) str += BaseStr.Replace(BaseStr.Replace(BaseStr.Replace(obj.Text, "\r\n", "<br>"), "\n", "<br>"), "\r", "<br>");
		else str += obj.Text;
		
		obj.Final = str;
		return ret;
	}

	public function UpdateText():void
	{
		var i:int, u:int;
		var str:String;

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);
		if(cotl==null) { Hide(); return; }

		m_ChangeImageQuality = true;
		
		var complatefull:Boolean = true;
	
		m_ListFilter = m_List;
		
		if (m_Filter != null && m_Filter.length >= 0) {
			for (i = 0; i < m_List.length; i++) {
				if(m_List[i].Complate==undefined) {
					if (!BuildText(m_List[i])) { complatefull = false; continue; }
					m_List[i].Complate = false;
					str = m_List[i].Final.toLowerCase();
					for (u = 0; u < m_Filter.length; u++) {
						if (str.indexOf(m_Filter[u]) < 0) break;
					}
					m_List[i].Complate = u >= m_Filter.length;
				}
			}
			if (complatefull) {
				m_ListFilter = new Array();
				for (i = 0; i < m_List.length; i++) {
					if (!m_List[i].Complate) continue;
					m_ListFilter.push(m_List[i]);
				}
			}
		}

		if (complatefull && m_List.length > 0) {
			if (m_GoToPage >= 0) {
				m_Page = m_GoToPage;
				m_GoToPage = -1;
			}
		}
		if (m_Page >= m_ListFilter.length) m_Page = m_ListFilter.length - 1;
		if (m_Page < 0) m_Page = 0;

		str = "";// "<img src='empire/quest/amnesia_01.jpg' width='171' height='196'>";
		if (m_Page >= 0 && m_Page < m_ListFilter.length) {
			//str+="<img src='empire/quest/amnesia_01.jpg' width='171' height='196' id='img01'>";
			//str+="<img src='empire/quest/amnesia_01.jpg' width='240' height='274' hspace='0' id='_sys_img0'>";

			if (BuildText(m_ListFilter[m_Page])) str = m_ListFilter[m_Page].Final;
		}

		if (tab == tabDesc) m_Desc.htmlText = BaseStr.FormatTag(str, true, true);
		else m_Journal.htmlText = BaseStr.FormatTag(str, true, true);

		ContentBuild();
	}

	public function frConst(e:Event):void
	{
		//if(!m_ChangeImageQuality) return;
		if(!visible) return;
		var i:int=0;
		var cc:Boolean = false;
		var text:TextField = e.target as TextField;
		while(true) {
			var lod:DisplayObject = text.getImageReference('_sys_img'+i.toString());
			if(lod==null) { if(cc) m_ChangeImageQuality=false; break; }
			i++;
			if(!(lod is Loader)) continue;
			var lo:Loader=lod as Loader;
			if(lo.content==null) continue;
			if(lo.content is Bitmap) {
				lo.x=5;
				(lo.content as Bitmap).smoothing=true;
				(lo.content as Bitmap).pixelSnapping=PixelSnapping.NEVER;
				cc=true;
			}
		}
			
//loadedObject.loaderInfo.addEventListener(Event.COMPLETE,imgLoadComplate);
//trace("frConst",loadedObject,loadedObject.loaderInfo,(loadedObject as Loader).content);
//var bm:Bitmap=(loadedObject as Loader).content as Bitmap;
//bm.smoothing=true;
//bm.pixelSnapping=PixelSnapping.NEVER;
	}
	
	private function clickRight(e:Event):void
	{
		if (m_Page >= m_ListFilter.length - 1) return;
		m_Page++;
		Update();
	}

	private function clickLeft(e:Event):void
	{
		if (m_Page <= 0) return;
		m_Page--;
		Update();
	}
	
	private function clickPage(e:Event):void
	{
		FI.Init(300, 220);
		FI.caption = Common.Txt.StorageGoToCaption;
		
		FI.AddLabel(Common.Txt.StorageGoToPage + ":");
		FI.Col();
		var ci:CtrlInput = FI.AddInput("1", 6, true, 0, false);
		
		FI.AddLabel(Common.Txt.StorageFilter + ":");
		FI.Col();
		var cik:CtrlInput = FI.AddInput((m_Filter == null || m_Filter.length <= 0)?"":(m_Filter.join(" ")), 100, true, Server.Self.m_Lang, true);
		cik.setSelection(0, cik.text.length);

		FI.Run(gotoPage, Common.Txt.StorageGoTo, StdMap.Txt.ButClose);
		ci.setSelection(0, ci.text.length);
		ci.assignFocus();
	}
	
	private function gotoPage():void
	{
//		var p:int = FI.GetInt(0) - 1;
//		if (p >= m_List.length) p = m_List.length - 1;
//		if (p < 0) p = 0;
//		m_Page = p;

		m_GoToPage = FI.GetInt(0) - 1;

		var i:int;
		var str:String = FI.GetStr(1);
		if (str != ((m_Filter == null || m_Filter.length <= 0)?"":(m_Filter.join(" ")))) {
			m_Filter = str.split(" ");
			for (i = m_Filter.length - 1; i >= 0; i--) {
				m_Filter[i] = BaseStr.Trim(m_Filter[i].toLowerCase());
				if (m_Filter[i] == null || m_Filter[i].length <= 0) {
					m_Filter.splice(i, 1);
				}
			}
			if (m_Filter.length <= 0) m_Filter = null;

			if(tab==tabJournal) m_GoToPage=1000000000;
			else m_GoToPage = 0;
			
			m_ListFilter = m_List;
			for (i = 0; i < m_List.length; i++) {
				m_List[i].Complate = undefined;
			}
		}

		Update();
	}
	
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	private var m_Input:CtrlInput = null;
	
	public function clickAdd(...args):void
	{
		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);

        var sp:String="";
		var i:int;
		if (tab == tabJournal) sp = Common.DateToSysStr(EM.GetServerDate());
		else { 
	        var p:int=0;
    	    for (i = 0; i < m_List.length; i++) {
        		p = Math.max(m_List[i].Prior + 1, p);
        	}
        	sp = p.toString();
		}

		FI.Init(480, 450);
		FI.caption = Common.Txt.FormHistAddCaption;

		while(true) {
			if (EM.m_UserAccess & User.AccessGalaxyText) { }
			else if (cotl != null && cotl.m_CotlType == Common.CotlTypeUser && cotl.m_AccountId == Server.Self.m_UserId) { }
			else break;

			FI.AddLabel(Common.Txt.FormHistDate + ":");
			FI.Col();
			FI.AddInput(sp, 19, true, Server.Self.m_Lang);
			break;
		}

		if (EM.m_UserAccess & User.AccessGalaxyText) {
			FI.AddLabel(Common.Txt.FormHistType + ":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(Common.Txt.FormHistTypeText, 1, true);
			FI.AddItem(Common.Txt.FormHistTypeExt, 2);
			FI.AddItem(Common.Txt.FormHistTypeLog, 3);
		}

		FI.AddLabel(Common.Txt.FormHistText + ":");
		m_Input = FI.AddCode("", 16384, true, Server.Self.m_Lang);// .textField.restrict = null;
		m_Input.restrict = null;
		m_Input.heightMin = 220;
		m_Input.wordWrap = true;

		FI.Run(AddSend, Common.Txt.FormHistAdd, StdMap.Txt.ButCancel);
	}

	private function AddSend():void
	{
        var boundary:String=Server.Self.CreateBoundary();

		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);

		var i:int=0;

        var d:String="";
		
		while(true) {
			if(EM.m_UserAccess & User.AccessGalaxyText) {}
			else if(cotl!=null && cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
			else break;
		
	        d+="--"+boundary+"\r\n";
    	    d+="Content-Disposition: form-data; name=\"date\"\r\n\r\n";
        	d+=FI.GetStr(i)+"\r\n";
			i++;
			
			break;
		}

		var tt:int=1;
		if(EM.m_UserAccess & User.AccessGalaxyText) {
			tt=FI.GetInt(i);
			i++;
		}

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"txt\"\r\n\r\n";
        d+=FI.GetStr(i)+"\r\n";
		i++;

        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emhistchange","&op=1&type=1&id="+m_CotlId.toString()+"&tt="+tt.toString(),d,boundary,AddRecv,false);
	}

	private var m_InputScrollOff:int=0;
	private var m_InputScrollLen:int=0;
	private function AddRecv(event:Event):void
	{
		var str:String;
		var off:int;
		
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int=buf.readUnsignedByte();
		if(err==Server.ErrorText) {
			EM.m_Info.Hide(); 
			FI.Show();// .visible = true;
			
			if ((buf.length - buf.position) <= 0) { FormMessageBox.Run(Common.Txt.FormHistErrTextLen, Common.Txt.ButClose); return; }
			off = buf.readInt();
			var ck:int = buf.readInt();
			m_InputScrollOff = off;
			m_InputScrollLen = 1;

			str = BaseStr.Replace(Common.Txt.FormHistErrText, "<Offset>", off.toString());
			m_Input.assignFocus();
			m_Input.setSelection(off, off + 1);
//			(EM.m_FormInput.GetInput(2) as TextArea).setFocus();
//			(EM.m_FormInput.GetInput(2) as TextArea).setSelection(off,off+1);

			if((buf.length-buf.position)<=0) {
				str=BaseStr.Replace(str,"<CharCode>","("+ck.toString()+")");
			} else {
				str=BaseStr.Replace(str,"<CharCode>","\""+buf.readUTFBytes(buf.length-buf.position)+"\""+" ("+ck.toString()+")");
			}

			FormMessageBox.Run(str,Common.Txt.ButClose,"",null,InputScrollTo);

			return;
		}
		else if(err==Server.ErrorTag) {
			EM.m_Info.Hide(); 
			FI.Show();// .visible = true;
			
			off=buf.readInt();
			var et:int=buf.readInt();
			m_InputScrollOff=off;
			m_InputScrollLen=0;
			
			str="Unknow";
			if(et==1) str=Common.Txt.FormHistErrTagUnknown;
			else if(et==2) str=Common.Txt.FormHistErrStackEmpty;
			else if(et==3) str=Common.Txt.FormHistErrStackFill;
			else if(et==4) str=Common.Txt.FormHistErrStackRemove;
			else if(et==5) str=Common.Txt.FormHistErrStackSmall;
			else if(et==6) str=Common.Txt.FormHistErrURL;
			else if(et==7) str=Common.Txt.FormHistErrText;

			str = BaseStr.Replace(str, "<Offset>", off.toString());
			m_Input.assignFocus();
			m_Input.setSelection(off, off + 1);
//			(EM.m_FormInput.GetInput(2) as TextArea).setFocus();
//			(EM.m_FormInput.GetInput(2) as TextArea).setSelection(off,off+1);

			if((buf.length-buf.position)<=0) {
			} else {
				str=BaseStr.Replace(str,"<Tag>",buf.readUTFBytes(buf.length-buf.position));
			}

			FormMessageBox.Run(str,Common.Txt.ButClose,"",null,InputScrollTo);

			return;
		} 
		else if(EM.ErrorFromServer(err)) return;

		m_GoToPage=1000000000;

//trace("ListQueryAfterAdd");
		ListQuery();
	}
	
	public function InputScrollTo():void
	{
		m_Input.assignFocus();
		m_Input.setSelection(m_InputScrollOff, m_InputScrollOff + m_InputScrollLen);


//		(EM.m_FormInput.GetInput(2) as TextArea).setFocus();
//		(EM.m_FormInput.GetInput(2) as TextArea).setSelection(m_InputScrollOff,m_InputScrollOff+m_InputScrollLen);
	}
	
	public function clickEdit(...args):void
	{
		var str:String;
		if(m_Page<0 || m_Page>=m_ListFilter.length) return;

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);

		FI.Init(480, 450);
		FI.caption = Common.Txt.FormHistEditCaption;

		while(true) {
			if(EM.m_UserAccess & User.AccessGalaxyText) {}
			else if(cotl!=null && cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
			else break;

			FI.AddLabel(Common.Txt.FormHistDate+":");
			FI.Col();
			if (tab == tabJournal) {
				var md:Date=EM.GetServerDate();
				md.setTime(md.getTime() + (m_ListFilter[m_Page].Prior * 1000 - EM.GetServerGlobalTime()));
				str=Common.DateToSysStr(md);
			}
			else str=m_ListFilter[m_Page].Prior.toString();
			FI.AddInput(str, 19, true, Server.Self.m_Lang);
			
			break;
		}

		if(EM.m_UserAccess & User.AccessGalaxyText) {
			FI.AddLabel(Common.Txt.FormHistType+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(Common.Txt.FormHistTypeText, 1, m_ListFilter[m_Page].Type == 1);
			FI.AddItem(Common.Txt.FormHistTypeExt, 2, m_ListFilter[m_Page].Type == 2);
			FI.AddItem(Common.Txt.FormHistTypeLog, 3, m_ListFilter[m_Page].Type == 3);
		}

		FI.AddLabel(Common.Txt.FormHistText+":");
		m_Input = FI.AddCode(m_ListFilter[m_Page].Text, 16384, true, Server.Self.m_Lang);// .textField.restrict = null;
		m_Input.restrict = null;
		m_Input.heightMin = 220;
		m_Input.wordWrap = true;
		
		FI.Run(EditSend, Common.Txt.FormHistEdit, StdMap.Txt.ButCancel);
	}

	private function EditSend():void
	{
        var boundary:String=Server.Self.CreateBoundary();

		var i:int=0;

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);

        var d:String="";

		while(true) {
			if(EM.m_UserAccess & User.AccessGalaxyText) {}
			else if(cotl!=null && cotl.m_CotlType==Common.CotlTypeUser && cotl.m_AccountId==Server.Self.m_UserId) {}
			else break;

	        d+="--"+boundary+"\r\n";
    	    d+="Content-Disposition: form-data; name=\"date\"\r\n\r\n";
        	d+=FI.GetStr(i)+"\r\n";
			i++;

			break;
		}

		var tt:int=1;
		if(EM.m_UserAccess & User.AccessGalaxyText) {
			tt=FI.GetInt(i);
			i++;
		}

        d+="--"+boundary+"\r\n";
   	    d+="Content-Disposition: form-data; name=\"txt\"\r\n\r\n";
       	d+=FI.GetStr(i)+"\r\n";
		i++;

        d+="--"+boundary+"--\r\n";

        Server.Self.QueryPost("emhistchange", "&op=2&type=1&id=" + m_CotlId.toString() + "&tt=" + tt.toString() + "&hid=" + m_ListFilter[m_Page].Id.toString(), d, boundary, AddRecv, false);
	}

	public function clickDelete(...args):void
	{
		FormMessageBox.Run(Common.Txt.FormHistDeleteQuery,StdMap.Txt.ButNo,StdMap.Txt.ButYes,SendDelete);
	}

	public function SendDelete():void
	{
		Server.Self.Query("emhistchange","&op=3&type=1&id="+m_CotlId.toString()+"&hid="+m_ListFilter[m_Page].Id.toString(),AddRecv,false);
	}

	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	private function EditCotlBegin(...args):void
	{
		var i:int;
		var str:String;
		var user:User;
		var md:Date;

		var cotl:SpaceCotl=EM.HS.GetCotl(m_CotlId);
		if(cotl==null) return;

		FI.Init(480, 520);
		FI.caption = Common.Txt.HyperspaceCotlEditCaption + " " + m_CotlId.toString();

		FI.TabAdd("main");

		if(EM.m_UserAccess & User.AccessGalaxyText) {
			FI.AddLabel(Common.Txt.HyperspaceCotlPfx + ":");
			FI.Col();
			FI.AddInput(EM.Txt_CotlPfx(cotl.m_Id), 32 - 1, true, Server.Self.m_Lang);

			FI.AddLabel(Common.Txt.HyperspaceCotlName + ":");
			FI.Col();
			FI.AddInput(EM.Txt_CotlName(cotl.m_Id), 32 - 1, true, Server.Self.m_Lang);

			FI.AddLabel(Common.Txt.HyperspaceCotlDesc + ":");
			FI.AddCode(EM.Txt_CotlDesc(cotl.m_Id), 512 - 1, true, Server.Self.m_Lang).heightMin = 100;
		}

		if(EM.CotlDevAccess(cotl.m_Id) & SpaceCotl.DevAccessEditMap) {
			FI.AddLabel(Common.Txt.HyperspaceCotlSize + ":");
			FI.Col();
			FI.AddInput(cotl.m_CotlSize.toString(), 5, true, 0);
		}

		FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fDevelopment) != 0, Common.Txt.HyperspaceCotlDevelopment);

		if(EM.m_UserAccess & User.AccessGalaxyOps) {
			FI.Col();
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fTemplate) != 0, Common.Txt.HyperspaceCotlTemplate);
			
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fPortalEnterShip) != 0, Common.Txt.HyperspaceCotlPortalEnterShip);
			FI.Col();
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fPortalEnterFlagship) != 0, Common.Txt.HyperspaceCotlPortalEnterFlagship);
			FI.Col();
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fPortalEnterAllItem) != 0, Common.Txt.HyperspaceCotlPortalEnterAllItem);
		}

		if(EM.m_UserAccess & User.AccessGalaxyAdmin) {
			FI.AddCheckBox((cotl.m_CotlFlag & SpaceCotl.fBeacon) != 0, Common.Txt.FormHistBeacon);
		}

		if(EM.m_UserAccess & User.AccessGalaxyAdmin) {
			FI.AddLabel(Common.Txt.HyperspaceCotlProtectDate + ":");
			FI.Col();
			if (cotl.m_ProtectTime <= 0) {
				FI.AddInput("0", 19, true, Server.Self.m_Lang);
			} else {
				md = EM.GetServerDate();
				md.setTime(md.getTime() + (cotl.m_ProtectTime-EM.GetServerGlobalTime()));
				FI.AddInput(Common.DateToSysStr(md), 19, true, Server.Self.m_Lang);
			}
		}

		if(EM.m_UserAccess & User.AccessGalaxyOps) {
			FI.TabAdd("bonus");

			// Bonus0
			FI.AddLabel(Common.Txt.HyperspaceCotlBonus+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(" ",0,cotl.m_BonusType0==0);
			for(i=1;i<Common.CotlBonusCnt;i++) {
				FI.AddItem(Common.CotlBonusName[i],i,cotl.m_BonusType0==i);
			}

			FI.AddLabel(" "/*Common.Txt.HyperspaceCotlBonusVal+":"*/);
			FI.Col();
			FI.AddInput(cotl.m_BonusVal0.toString(),5,true,0);

			// Bonus1
			FI.AddLabel(Common.Txt.HyperspaceCotlBonus+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(" ",0,cotl.m_BonusType1==0);
			for(i=1;i<Common.CotlBonusCnt;i++) {
				FI.AddItem(Common.CotlBonusName[i],i,cotl.m_BonusType1==i);
			}
			
			FI.AddLabel(" "/*Common.Txt.HyperspaceCotlBonusVal+":"*/);
			FI.Col();
			FI.AddInput(cotl.m_BonusVal1.toString(),5,true,0);

			// Bonus2
			FI.AddLabel(Common.Txt.HyperspaceCotlBonus+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(" ",0,cotl.m_BonusType2==0);
			for(i=1;i<Common.CotlBonusCnt;i++) {
				FI.AddItem(Common.CotlBonusName[i],i,cotl.m_BonusType2==i);
			}
			
			FI.AddLabel(" "/*Common.Txt.HyperspaceCotlBonusVal+":"*/);
			FI.Col();
			FI.AddInput(cotl.m_BonusVal2.toString(),5,true,0);

			// Bonus3
			FI.AddLabel(Common.Txt.HyperspaceCotlBonus+":");
			FI.Col();
			FI.AddComboBox();
			FI.AddItem(" ",0,cotl.m_BonusType3==0);
			for(i=1;i<Common.CotlBonusCnt;i++) {
				FI.AddItem(Common.CotlBonusName[i],i,cotl.m_BonusType3==i);
			}

			FI.AddLabel(" "/*Common.Txt.HyperspaceCotlBonusVal+":"*/);
			FI.Col();
			FI.AddInput(cotl.m_BonusVal3.toString(), 5, true, 0);
		}

		var da:uint;
		if (EM.CotlDevAccess(cotl.m_Id) & SpaceCotl.DevAccessAssignRights) {
			FI.TabAdd("dev");

			// Dev0
			FI.AddLabel(Common.Txt.HyperspaceCotlDev+" 1:");
			FI.Col();
			str = "";
			if (cotl.m_Dev0 != 0) {
				str += cotl.m_Dev0.toString() + ": ";
				user = UserList.Self.GetUser(cotl.m_Dev0);
				if (user != null) {
					str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				}
			}
			FI.AddInput(str, 128, true, Server.Self.m_Lang);

			da = (cotl.m_DevAccess >> 0) & 0xff;
			FI.AddCheckBox((da & SpaceCotl.DevAccessAssignRights) != 0, Common.Txt.HyperspaceCotlAccessAssignRights);
			FI.AddCheckBox((da & SpaceCotl.DevAccessView) != 0, Common.Txt.HyperspaceCotlAccessView);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditMap) != 0, Common.Txt.HyperspaceCotlAccessEditMap);
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditCode) != 0, Common.Txt.HyperspaceCotlAccessEditCode);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditOps) != 0, Common.Txt.HyperspaceCotlAccessEditOps);

			// Dev1
			FI.AddLabel(Common.Txt.HyperspaceCotlDev+" 2:");
			FI.Col();
			str = "";
			if (cotl.m_Dev1 != 0) {
				str += cotl.m_Dev1.toString() + ": ";
				user = UserList.Self.GetUser(cotl.m_Dev1);
				if (user != null) {
					str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				}
			}
			FI.AddInput(str, 128, true, Server.Self.m_Lang);
			
			da = (cotl.m_DevAccess >> 8) & 0xff;
			FI.AddCheckBox((da & SpaceCotl.DevAccessAssignRights) != 0, Common.Txt.HyperspaceCotlAccessAssignRights);
			FI.AddCheckBox((da & SpaceCotl.DevAccessView) != 0, Common.Txt.HyperspaceCotlAccessView);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditMap) != 0, Common.Txt.HyperspaceCotlAccessEditMap);
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditCode) != 0, Common.Txt.HyperspaceCotlAccessEditCode);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditOps) != 0, Common.Txt.HyperspaceCotlAccessEditOps);

			// Dev2
			FI.AddLabel(Common.Txt.HyperspaceCotlDev+" 3:");
			FI.Col();
			str = "";
			if (cotl.m_Dev2 != 0) {
				str += cotl.m_Dev2.toString() + ": ";
				user = UserList.Self.GetUser(cotl.m_Dev2);
				if (user != null) {
					str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				}
			}
			FI.AddInput(str, 128, true, Server.Self.m_Lang);

			da = (cotl.m_DevAccess >> 16) & 0xff;
			FI.AddCheckBox((da & SpaceCotl.DevAccessAssignRights) != 0, Common.Txt.HyperspaceCotlAccessAssignRights);
			FI.AddCheckBox((da & SpaceCotl.DevAccessView) != 0, Common.Txt.HyperspaceCotlAccessView);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditMap) != 0, Common.Txt.HyperspaceCotlAccessEditMap);
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditCode) != 0, Common.Txt.HyperspaceCotlAccessEditCode);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditOps) != 0, Common.Txt.HyperspaceCotlAccessEditOps);

			// Dev3
			FI.AddLabel(Common.Txt.HyperspaceCotlDev+" 4:");
			FI.Col();
			str = "";
			if (cotl.m_Dev3 != 0) {
				str += cotl.m_Dev3.toString() + ": ";
				user = UserList.Self.GetUser(cotl.m_Dev3);
				if (user != null) {
					str += EmpireMap.Self.Txt_CotlOwnerName(0, user.m_Id);
				}
			}
			FI.AddInput(str, 128, true, Server.Self.m_Lang);

			da = (cotl.m_DevAccess >> 24) & 0xff;
			FI.AddCheckBox((da & SpaceCotl.DevAccessAssignRights) != 0, Common.Txt.HyperspaceCotlAccessAssignRights);
			FI.AddCheckBox((da & SpaceCotl.DevAccessView) != 0, Common.Txt.HyperspaceCotlAccessView);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditMap) != 0, Common.Txt.HyperspaceCotlAccessEditMap);
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditCode) != 0, Common.Txt.HyperspaceCotlAccessEditCode);
			FI.Col();
			FI.AddCheckBox((da & SpaceCotl.DevAccessEditOps) != 0, Common.Txt.HyperspaceCotlAccessEditOps);
		}

		if (EM.m_UserAccess & User.AccessGalaxyAdmin) {		
			FI.TabAdd("dev time");

			FI.AddLabel(Common.Txt.HyperspaceCotlDevTime + ":");
			FI.Col();
			if (cotl.m_DevTime <= 0) {
				FI.AddInput("0", 19, true, Server.Self.m_Lang);
			} else {
				md = EM.GetServerDate();
				md.setTime(md.getTime() + (cotl.m_DevTime-EM.GetServerGlobalTime()));
				FI.AddInput(Common.DateToSysStr(md), 19, true, Server.Self.m_Lang);
			}

			FI.AddLabel(Common.Txt.HyperspaceCotlDevDays + ":");
			FI.Col();
			FI.AddInput((cotl.m_DevFlag & 0xff).toString(), 3, true, 0);
		}

		FI.tab = 0;
		FI.Run(EditCotlSend,StdMap.Txt.ButSave,StdMap.Txt.ButCancel);
	}
	
	private function EditCotlSend():void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;

		var tstr:String;
        var boundary:String = Server.Self.CreateBoundary();

        var d:String = "";
		
		var e:int = 0;

		var flag:uint = 0;

		if(EM.m_UserAccess & User.AccessGalaxyText) {
			tstr=FI.GetStr(e);
			if (tstr != EM.Txt_CotlPfx(cotl.m_Id)) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"pfx\"\r\n\r\n";
				d += tstr + "\r\n";
			}
			e++;

			tstr=FI.GetStr(e);
			if (tstr != EM.Txt_CotlName(cotl.m_Id)) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"name\"\r\n\r\n";
				d += tstr + "\r\n";
			}
			e++;

			tstr=FI.GetStr(e);
			if (tstr != EM.Txt_CotlDesc(cotl.m_Id)) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"desc\"\r\n\r\n";
				d += tstr + "\r\n";
			}
			e++;
		}

		if(EM.CotlDevAccess(cotl.m_Id) & SpaceCotl.DevAccessEditMap) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"size\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
		}
		
		if (FI.GetInt(e) != 0) flag |= SpaceCotl.fDevelopment;
		e++;
		
		if(EM.m_UserAccess & User.AccessGalaxyOps) {
			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fTemplate;
			e++;

			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fPortalEnterShip;
			e++;
			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fPortalEnterFlagship;
			e++;
			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fPortalEnterAllItem;
			e++;
		}

		if(EM.m_UserAccess & User.AccessGalaxyAdmin) {
			if (FI.GetInt(e) != 0) flag |= SpaceCotl.fBeacon;
			e++;
		}

		if(EM.m_UserAccess & User.AccessGalaxyAdmin) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"protectdate\"\r\n\r\n";
			d += FI.GetStr(e).toString() + "\r\n";
			e++;
		}

		if(EM.m_UserAccess & User.AccessGalaxyOps) {
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b0t\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b0v\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b1t\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b1v\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b2t\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
			
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b2v\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
				
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b3t\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
			
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"b3v\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
		}
			
		d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"lang\"\r\n\r\n";
        d += Server.Self.m_Lang.toString() + "\r\n";

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"id\"\r\n\r\n";
        d += m_CotlId.toString() + "\r\n";

        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"flag\"\r\n\r\n";
        d += flag.toString(16) + "\r\n";

		if (EM.CotlDevAccess(cotl.m_Id) & SpaceCotl.DevAccessAssignRights) {
			var devaccess:uint = 0;
			var da:uint;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"dev0\"\r\n\r\n";
			d += FI.GetStr(e) + "\r\n";
			e++;

			da = 0;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessAssignRights;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessView;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditMap;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditCode;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditOps;
			devaccess |= da << 0;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"dev1\"\r\n\r\n";
			d += FI.GetStr(e) + "\r\n";
			e++;
			
			da = 0;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessAssignRights;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessView;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditMap;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditCode;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditOps;
			devaccess |= da << 8;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"dev2\"\r\n\r\n";
			d += FI.GetStr(e) + "\r\n";
			e++;
			
			da = 0;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessAssignRights;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessView;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditMap;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditCode;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditOps;
			devaccess |= da << 16;

			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"dev3\"\r\n\r\n";
			d += FI.GetStr(e) + "\r\n";
			e++;

			da = 0;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessAssignRights;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessView;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditMap;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditCode;
			if (FI.GetInt(e++) != 0) da |= SpaceCotl.DevAccessEditOps;
			devaccess |= da << 24;

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"devaccess\"\r\n\r\n";
			d += devaccess.toString(16) + "\r\n";
		}

		if (EM.m_UserAccess & User.AccessGalaxyAdmin) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"devtime\"\r\n\r\n";
			d += FI.GetStr(e).toString() + "\r\n";
			e++;

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"devdays\"\r\n\r\n";
			d += FI.GetInt(e).toString() + "\r\n";
			e++;
		}

        d += "--" + boundary + "--\r\n";

        Server.Self.QueryPost("emedcotladd", "", d, boundary, EditCotlRecv, false);
	}

	private function EditCotlDevBuy(...args):void
	{
		var str:String = Common.Txt.HyperspaceCotlDevBuyQuery;
		str = BaseStr.Replace(str, "<Cost>", (Common.CotlDevCost).toString());
		FormMessageBox.Run(str, StdMap.Txt.ButCancel, Common.Txt.HyperspaceCotlDevBuy, EditCotlDevBuySend);
	}
	
	private function EditCotlDevBuySend():void
	{
		if (EM.m_FormFleetBar.m_FleetMoney < Common.CotlDevCost) { FormMessageBox.RunErr(Common.Txt.NoEnoughMoney); return; }
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;
		Server.Self.Query("emedcotlspecial", "&type=21&id=" + cotl.m_Id.toString(), EditCotlDevBuyRecv, false);
	}
	
	private function EditCotlDevBuyContinue(...args):void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;
		var cost:int = Common.CotlDevCost;
		var cnt:int = cotl.m_DevFlag & 0xff; if (cnt < 1) cnt = 1; else if(cnt>8) cnt=8;
		for (var i:int = 0; i < cnt; i++) cost *= 2;

		var str:String = Common.Txt.HyperspaceCotlDevBuyContinueQuery;
		str = BaseStr.Replace(str, "<Cost>", BaseStr.FormatBigInt(cost));
		FormMessageBox.Run(str, StdMap.Txt.ButCancel, Common.Txt.HyperspaceCotlDevBuyContinue, EditCotlDevBuyContinueSend);
	}

	private function EditCotlDevBuyContinueSend():void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;
		var cost:int = Common.CotlDevCost;
		var cnt:int = cotl.m_DevFlag & 0xff; if (cnt < 1) cnt = 1; else if(cnt>8) cnt=8;
		for (var i:int = 0; i < cnt; i++) cost *= 2;

		if (EM.m_FormFleetBar.m_FleetMoney < cost) { FormMessageBox.RunErr(Common.Txt.NoEnoughMoney); return; }

		Server.Self.Query("emedcotlspecial", "&type=22&id=" + cotl.m_Id.toString(), EditCotlDevBuyRecv, false);
	}

	private function EditCotlDevBuyRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);
		if (loader.data == null) return;
		var buf:ByteArray = loader.data;
		buf.endian = Endian.LITTLE_ENDIAN;
		
		var err:int = buf.readUnsignedByte();
		if (err == Server.ErrorNoEnoughMoney) { FormMessageBox.RunErr(Common.Txt.NoEnoughMoney); return; }
		else if(err) { EM.ErrorFromServer(err); return; }
		else FormMessageBox.Run(Common.Txt.OpComplate, StdMap.Txt.ButClose);
	}	

	private function EditCotlMapEdit(...args):void
	{
		var cotl:SpaceCotl = EM.HS.GetCotl(m_CotlId);
		if (cotl == null) return;

		Server.Self.Query("emedcotlspecial", "&type=1&id=" + cotl.m_Id.toString(), EditCotlMapEditRecv, false);
	}

	private function EditCotlMapEditRecv(event:Event):void
	{
		EM.ToOnlyHyperspace();

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:int = buf.readUnsignedByte();
		if (err == Server.ErrorExist) { EM.m_FormHint.Show(Common.TxtEdit.ErrorCotlInGameMode,Common.WarningHideTime);  return; }
		if(err) { EM.ErrorFromServer(err); return; }
		
		var cotlid:uint=buf.readUnsignedInt();
		var adr:uint=buf.readUnsignedInt();
		var port:int=buf.readInt();
		var num:int=buf.readInt();

		EM.m_Edit = true;
		
		if (EM.HS.visible) EM.HS.Hide();
		EM.m_GoCotlId = 0; EM.m_GoSectorX = 0; EM.m_GoSectorY = 0; EM.m_GoPlanet = -1; EM.m_GoShipNum = -1; EM.m_GoShipId = 0;
		EM.ChangeCotlServerEx(cotlid,adr,port,num);
		
		EM.SetCenter(0,0);
		//EM.m_FormMiniMap.SetCenter(0,0);
		
	}
}

}

import Engine.*;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.*;

class StorageItem
{
	public var m_RId:uint = 0;
	public var m_RDate:uint = 0;
	public var m_Owner:uint = 0;
	public var m_Type:uint = 0;
	public var m_Cnt:int = 0;

    public var m_ImportLimit:int; // Импортировать пока Cnt<Limit.
    public var m_ImportCnt:int; // -1=не импортировать так как не хватает денег. -2=не импортировать -3=не импортировать и не отображать.
    public var m_ImportStep:int;
    public var m_ImportPrice:int;
    public var m_ImportPriceMin:int;
    public var m_ImportPriceMax:int;
    public var m_ImportCntMin:int;
    public var m_ImportCntMax:int;

    public var m_ExportLimit:int; // Экспортировать пока Cnt>Limit.
    public var m_ExportCnt:int; // -2=не экспортировать. -3=не экспортировать и не отображать.
    public var m_ExportStep:int;
    public var m_ExportPrice:int;
    public var m_ExportPriceMin:int;
    public var m_ExportPriceMax:int;
    public var m_ExportCntMin:int;
    public var m_ExportCntMax:int;

	public var m_Tmp:int;
	public var m_Razdel:int;

	public var m_SRazdel:CtrlCheckBox;
	public var m_SIcon:Sprite;
	public var m_SBox:CtrlBox;
	public var m_SName:TextField;
	public var m_SOwner:TextField;
	public var m_SCnt:TextField;

	public var m_IRazdel:CtrlCheckBox;
	public var m_IIcon:Sprite;
	public var m_IBox:CtrlBox;
	public var m_IName:TextField;
	public var m_IOwner:TextField;
	public var m_ICnt:TextField;
	public var m_IPrice:TextField;
	public var m_IStep:TextField;

	public var m_ERazdel:CtrlCheckBox;
	public var m_EIcon:Sprite;
	public var m_EBox:CtrlBox;
	public var m_EName:TextField;
	public var m_EOwner:TextField;
	public var m_ECnt:TextField;
	public var m_EPrice:TextField;
	public var m_EStep:TextField;
}

class StorageSearch
{
	public var m_CotlId:uint = 0;
	public var m_Owner:uint = 0;
	public var m_Dist:int = -1;
	public var m_Type:uint = 0;
	public var m_Cnt:int = 0;
	public var m_Price:int = 0;
	public var m_Step:int = 0;
	public var m_InView:Boolean = false;
	public var m_CX:int = 0;
	public var m_CY:int = 0;

	public var m_IIcon:Sprite;
	public var m_IBox:CtrlBox;
	public var m_IName:TextField;
	public var m_IOwner:TextField;
	public var m_ICnt:TextField;
	public var m_IPrice:TextField;
	public var m_IStep:TextField;
}
