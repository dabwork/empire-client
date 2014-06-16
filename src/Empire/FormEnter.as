// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;

CONFIG::air {
import flash.desktop.NativeApplication;
}

import flash.system.Capabilities;
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;
import flash.text.Font;
import flash.system.*;

import com.adobe.crypto.MD5;

public class FormEnter extends FormStd
{
	private var m_Map:EmpireMap;
	
	static public const StateEnter:int = 1;
	static public const StateTraining:int = 2;
	static public const StateTrainingName:int = 3;
	
	private var m_State:int = 0;
	private var m_StateNewName:Boolean = false;

	private var m_Name:CtrlInput = null;
	private var m_Password:CtrlInput = null;
	private var m_ButEnter:CtrlBut = null;
	private var m_SaveName:CtrlCheckBox = null;
	private var m_SaveAll:CtrlCheckBox = null;

	private var m_TabTrainingText:TextField = null;
	private var m_TabLoginText:TextField = null;
	private var m_TabServerText:TextField = null;
	private var m_TabLanguageText:TextField = null;
	
	private var m_LabelTrainingText:TextField = null;
	private var m_LabelLoginNameText:TextField = null;
	private var m_LabelLoginPasswordText:TextField = null;
	private var m_LabelServerText:TextField = null;
	private var m_LabelProtocolText:TextField = null;
	
	private var m_Server:CtrlComboBox = null;
	private var m_Protocol:CtrlComboBox = null;
	private var m_Scale:CtrlComboBox = null;

	private var m_Ver:TextField = null;

	private var m_EnterKey:Boolean = false;

	public function FormEnter(map:EmpireMap)
	{
		super(false, true);

		var i:int;

		m_Map = map;

		scale = StdMap.Main.m_Scale;
		width = 360;
		height = 275;
		caption = Common.Txt.FormEnterCaption;
		closeDisable = true;

		m_TabTrainingText = TabGet( TabAdd(Common.Txt.FormEnterTabTraining) ).m_Caption;

		i = ItemLabel(Common.Txt.FormEnterTxtTraining, true); //ItemAlign(i, 1, 0); //ItemCellCnt(i, 2);
		m_LabelTrainingText = ( ItemObj( i ) as TextField );
		LocNextRow();
		
		m_TabLoginText = TabGet( TabAdd(Common.Txt.FormEnterTabLogin) ).m_Caption;

		i = ItemLabel(Common.Txt.FormEnterName + ":"); ItemAlign(i, 1, 0);
		m_LabelLoginNameText = ( ItemObj( i ) as TextField );
		i = ItemInput("", 33, true, Server.LANG_RUS, true, "@"); m_Name = ItemObj(i) as CtrlInput; //m_Name.input.addEventListener(Event.CHANGE, nameChange);
		//m_Name.input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		m_Name.input.addEventListener(Event.CHANGE, onNameChange);
		m_Name.restrict = null;
		LocNextRow();

		i = ItemLabel(Common.Txt.FormEnterPassword + ":"); ItemAlign(i, 1, 0);
		m_LabelLoginPasswordText = ( ItemObj( i ) as TextField );
		i = ItemInput("", 33, true, Server.LANG_RUS, true); m_Password = ItemObj(i) as CtrlInput; //m_Name.input.addEventListener(Event.CHANGE, nameChange);
		//m_Password.input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		m_Password.input.addEventListener(Event.CHANGE, onPasswordChange);
		m_Password.displayAsPassword = true;
		m_Password.restrict = null;
		LocNextRow();

		i = ItemCheckBox(Common.Txt.FormEnterSaveName); ItemCellCnt(i, 2); m_SaveName = ItemObj(i) as CtrlCheckBox;
		m_SaveName.addEventListener(MouseEvent.CLICK, onSaveNameClick);
		LocNextRow();

		i = ItemCheckBox(Common.Txt.FormEnterSaveAll); ItemCellCnt(i, 2); m_SaveAll = ItemObj(i) as CtrlCheckBox;
		m_SaveAll.addEventListener(MouseEvent.CLICK, onSaveAllClick);
		LocNextRow();
		
		m_TabServerText = TabGet( TabAdd(Common.Txt.FormEnterTabSet) ).m_Caption;
		
		i = ItemLabel(Common.Txt.FormEnterServer + ":"); ItemAlign(i, 1, 0);
		m_LabelServerText = ( ItemObj( i ) as TextField );
		i = ItemComboBox(); m_Server = ItemObj(i) as CtrlComboBox;
		LocNextRow();

		i = ItemLabel(Common.Txt.FormEnterProtocol + ":"); ItemAlign(i, 1, 0);
		m_LabelProtocolText = ( ItemObj( i ) as TextField );
		i = ItemComboBox(); m_Protocol = ItemObj(i) as CtrlComboBox;
		m_Protocol.ItemAdd(Common.Txt.FormEnterProtocolRaw, Server.ProtocolRaw);
		m_Protocol.ItemAdd(Common.Txt.FormEnterProtocolDefaultHTTP, Server.ProtocolDefaultHTTP);
		LocNextRow();

/*		i = ItemLabel(Common.Txt.FormEnterScale + ":"); ItemAlign(i, 1, 0);
		i = ItemComboBox(); m_Scale = ItemObj(i) as CtrlComboBox;
		m_Scale.ItemAdd("100%", 100);
		m_Scale.ItemAdd("125% ", 125);
		m_Scale.ItemAdd("150% ", 150);
		m_Scale.ItemAdd("175% ", 175);
		m_Scale.ItemAdd("200% ", 200);
		LocNextRow();*/

		//i = ItemBut(Common.Txt.FormEnterBut); ItemCellCnt(i, 2); ItemAlign(i, 1); ItemSpace(i, 0, 5); m_ButEnter = ItemObj(i) as CtrlBut; m_ButEnter.addEventListener(MouseEvent.CLICK, clickEnter);
		//LocNextRow();
		
		m_TabLanguageText = TabGet( TabAdd("language") ).m_Caption;
		( ItemObj( ItemBut("Русский") ) as CtrlBut ).addEventListener(MouseEvent.CLICK, 
			function(e:Event):void { 
				Localization.Load( Server.LANG_RUS, null, function():void {
					UpdateLocalization();
				}); 
				var so:SharedObject = SharedObject.getLocal("EGEmpireData");
				if (so != null) {
					so.data.lang = Server.LANG_RUS
				} 
			} );
		LocNextRow();
		( ItemObj( ItemBut("English") ) as CtrlBut ).addEventListener(MouseEvent.CLICK, 
			function(e:Event):void { 
				Localization.Load( Server.LANG_ENG, null, function():void {
					UpdateLocalization();
				});
				var so:SharedObject = SharedObject.getLocal("EGEmpireData");
				if (so != null) {
					so.data.lang = Server.LANG_ENG
				} 
			} );
		LocNextRow();
		
		m_ButEnter = new CtrlBut();
		addChild(m_ButEnter);
		m_ButEnter.caption = Common.Txt.FormEnterBut;
		m_ButEnter.addEventListener(MouseEvent.CLICK, clickEnter);
		
		
		tab = 0;
		
		addEventListener("page", onChangePage);

		CONFIG::air {
			addEventListener("close", clickClose);
			closeDisable = false;
		}
	}

	public function UpdateLocalization():void
	{
		if (tab == 0) m_ButEnter.caption = Common.Txt.FormEnterButTraining;
		else m_ButEnter.caption = Common.Txt.FormEnterBut;
		
		caption = Common.Txt.FormEnterCaption;
		
		m_TabTrainingText.htmlText = BaseStr.FormatTag( Common.Txt.FormEnterTabTraining );
		m_TabLoginText.htmlText = BaseStr.FormatTag( Common.Txt.FormEnterTabLogin );
		m_TabServerText.htmlText = BaseStr.FormatTag( Common.Txt.FormEnterTabSet );
		//m_TabLanguageText.htmlText = BaseStr.FormatTag( );
	
		m_LabelTrainingText.htmlText = BaseStr.FormatTag( Common.Txt.FormEnterTxtTraining, true, true );
		m_LabelLoginNameText.htmlText = BaseStr.FormatTag( Common.Txt.FormEnterName+":", true, true );
		m_LabelLoginPasswordText.htmlText = BaseStr.FormatTag( Common.Txt.FormEnterPassword+":", true, true );
		m_LabelServerText.htmlText = BaseStr.FormatTag( Common.Txt.FormEnterServer+":", true, true );
		m_LabelProtocolText.htmlText = BaseStr.FormatTag( Common.Txt.FormEnterProtocol+":", true, true );
		
		m_SaveName.Caption = Common.Txt.FormEnterSaveName;
		m_SaveAll.Caption = Common.Txt.FormEnterSaveAll;
		
		var i:int = m_Protocol.current;
		m_Protocol.ItemClear();
		m_Protocol.ItemAdd(Common.Txt.FormEnterProtocolRaw, Server.ProtocolRaw);
		m_Protocol.ItemAdd(Common.Txt.FormEnterProtocolDefaultHTTP, Server.ProtocolDefaultHTTP);
		m_Protocol.current = i;
	}
	
	public function onChangePage(e:Event):void
	{
		if (tab == 0) m_ButEnter.caption = Common.Txt.FormEnterButTraining;
		else m_ButEnter.caption = Common.Txt.FormEnterBut;
		m_ButEnter.x = width - m_ButEnter.width - 25;
		m_ButEnter.y = height - m_ButEnter.height - 35;
		
		m_ButEnter.disable = tab != 0 && (m_Password.text == null || m_Password.text.length <= 0);
	}
	
	override public function Show():void
	{
		var i:int;
		var so:SharedObject;
		
		m_State = StateEnter;
		
		tab = 0;
		
		m_Name.text = "";
		m_Name.setSelection(0, m_Name.text.length);

		m_SaveName.check = true;
		m_SaveAll.check = true;
		m_EnterKey = false;
		var loadserver:String = "";
		var loadprotocol:int = Set.m_Protocol;
		while(true) {
			so = SharedObject.getLocal("EGEmpireEnter");
			if (so.size == 0) break;

			if (so.data.savename != undefined) { m_SaveName.check = so.data.savename; }
			if (so.data.saveall != undefined) { m_SaveAll.check = so.data.saveall; }
			if (so.data.name != undefined && so.data.name.length > 0) {
				m_Name.text = so.data.name;
				if(m_Name.text.length>0) tab = 1;
				m_Name.setSelection(0, m_Name.text.length);
				if (so.data.key != undefined && so.data.key.length > 0) m_EnterKey = true;
			}
			if (so.data.server != undefined) loadserver = so.data.server;
			if (so.data.protocol != undefined) loadprotocol = so.data.protocol;

			break;
		}
		m_SaveAll.disable = !m_SaveName.check;

		if (m_EnterKey) {
			m_Password.text = "***";
			m_Password.setSelection(0, m_Password.text.length);
		} else {
			m_Password.text = "";
		}

		m_Server.ItemClear();
		for (i = 0; i < Set.m_ServerList.length; i++) {
			m_Server.ItemAdd(Set.m_ServerList[i].Name, Set.m_ServerList[i].Adr);
			if (Set.m_ServerList[i].Adr == loadserver) m_Server.current = m_Server.ItemCnt - 1;
		}
		if (m_Server.current<0 && m_Server.ItemCnt>0) m_Server.current=0;

		for (i = 0; i < m_Protocol.ItemCnt; i++) {
			if (m_Protocol.ItemData(i) == loadprotocol) { m_Protocol.current = i; break; }
		}
		if (m_Protocol.current<0 && m_Protocol.ItemCnt>0) m_Protocol.current=0;

		super.Show();
		if (m_Name.text == null || m_Name.text.length <= 0) m_Name.assignFocus();
		else m_Password.assignFocus();

		onChangePage(null);

		ShowVersion();
	}
	
	override public function Hide():void
	{
		super.Hide();
		EmpireMap.Self.m_FormBegin.visible = false;
	}

	//public var m_DisableTestGPU:Boolean = false;
	
	public function onFlashOps():void
	{
		var str:String = "";

		if (C3D.Context != null) {
			str = C3D.Context.driverInfo;
		}

//		m_DisableTestGPU = true;
//		Show();

		FormMessageBox.Run(Common.Txt.FormEnterHWOff + "\n\n" + str, Common.Txt.FormEnterFlashOps, "", null, onFlashOps);
		Security.showSettings(SecurityPanel.DISPLAY);
	}
	
	public function onFlashOpsLS():void
	{
		var str:String = "";

		FormMessageBox.Run(Common.Txt.NoCacheFlash, StdMap.Txt.ButClose, Common.Txt.FormEnterFlashOps, onFlashOpsLS, clockFlashOpsLSok);
		Security.showSettings(SecurityPanel.LOCAL_STORAGE);
	}
	
	public function clockFlashOpsLSok():void
	{
		var so:SharedObject = SharedObject.getLocal("EGEmpireData");
		if (so != null) so.data.test = 123;
		
		if (m_ShowTimer == null) {
			m_ShowTimer = new Timer(100, 1);
			m_ShowTimer.addEventListener(TimerEvent.TIMER, ShowTimer);
		}
		m_ShowTimer.start();
	}
	
	private var m_ShowTimer:Timer = null;
	public function ShowTimer(event:Event):void
	{
		m_ShowTimer.stop();
		Show();
	}

	public function ShowVersion():void
	{
		var str:String = "";

		if (C3D.Context != null /*&& (!m_DisableTestGPU)*/) {
			str = C3D.Context.driverInfo;
			if (str.indexOf("oldDriver") >= 0) {
				Hide();
				if (!FormMessageBox.Self.visible) {
					FormMessageBox.RunErr(Common.Txt.FormEnterHWOldDriver + "\n\n" + str, Common.Txt.FormEnterButExit, clickClose);
				}
				return;

			} else if (str.indexOf("userDisabled") >= 0 || str.indexOf("Software") >= 0 || str.indexOf("software") >= 0) {
				Hide();

				if (!FormMessageBox.Self.visible) {
					FormMessageBox.Run(Common.Txt.FormEnterHWOff + "\n\n" + str, Common.Txt.FormEnterFlashOps, "", null, onFlashOps);
					CONFIG::air {
						FormMessageBox.Run(Common.Txt.FormEnterHWOffAIR + "\n\n" + str, Common.Txt.FormEnterButExit, "", null, clickClose);
					}
				}
				return;
			}
		}

		var so:SharedObject;
		so = SharedObject.getLocal("EGEmpireData");
		if (so == null || so.data == null || so.data.test == undefined || so.data.test != 123) {
			Hide();

			if (!FormMessageBox.Self.visible) {
				FormMessageBox.Run(Common.Txt.NoCacheFlash, StdMap.Txt.ButClose, Common.Txt.FormEnterFlashOps, onFlashOpsLS, clockFlashOpsLSok);
//				CONFIG::air {
//					FormMessageBox.Run(EmpireMap.Txt.NoCacheFlashAIR, Common.Txt.FormEnterButExit, "", null, clickClose);
//				}
			}
			return;
		}

		if (!visible) return;
		EmpireMap.Self.m_FormBegin.visible = true;

		var gr:Graphics = EmpireMap.Self.m_FormBegin.graphics;
		gr.clear();
		gr.beginFill(0x000000);
		gr.drawRect(0, 0, C3D.m_SizeX, C3D.m_SizeY);
		gr.endFill();

		if (m_Ver == null) {
			m_Ver = new TextField();
			m_Ver.x=0;
			m_Ver.y=0;
			m_Ver.width=1;
			m_Ver.height=1;
			m_Ver.type=TextFieldType.DYNAMIC;
			m_Ver.selectable=false;
			m_Ver.border=false;
			m_Ver.background = false;
			m_Ver.multiline = false;
			m_Ver.autoSize=TextFieldAutoSize.LEFT;
			m_Ver.antiAliasType=AntiAliasType.ADVANCED;
			m_Ver.gridFitType=GridFitType.SUBPIXEL;
			m_Ver.defaultTextFormat = new TextFormat("Calibri", 13, 0xffffff);
			m_Ver.embedFonts = true;
			
			EmpireMap.Self.m_FormBegin.addChild(m_Ver);
		}

		str = "(C) 2012 Elemental Games. All rights reserved.";
		str += "   Version " + Math.floor(EmpireMap.GameVersion / 10000).toString() + "." + (EmpireMap.GameVersion % 10000).toString();
		if (EmpireMap.GameVersionSub != 0) str += "." + EmpireMap.GameVersionSub.toString();
		str += "                    ";
		if (C3D.Context != null) str += "   " + C3D.Context.driverInfo + "";
		CONFIG::air {
			str += "   AIR:" + NativeApplication.nativeApplication.runtimeVersion;
		}
		CONFIG::player {
			str += "   Player:" + Capabilities.version;
		}
//		str += " wmodeGPU:" + stage.wmodeGPU.toString();

		str += "   DPI:" + Capabilities.screenDPI.toString();

		m_Ver.htmlText = BaseStr.FormatTag(str, true, true);
		
		m_Ver.height;
		m_Ver.width;
		
		m_Ver.x = 10;
		m_Ver.y = C3D.m_SizeY - (30 >> 1) - (m_Ver.height >> 1);
	}
	
	override public function onStageResize(e:Event):void
	{
		super.onStageResize(e);
		ShowVersion();
	}
	
	override protected function onKeyDownModal(e:KeyboardEvent):void
	{
		super.onKeyDownModal(e);
		if (e.keyCode == 13) {
			clickEnter(e);
		}
	}
	
	private function clickClose(...args):void
	{
		CONFIG::air {
//			Hide();
			NativeApplication.nativeApplication.exit();
		}
	}

	private function onNameChange(event:Event):void
	{
		if (m_EnterKey) {
			m_EnterKey = false;
			m_Password.text = "";
			m_ButEnter.disable = tab != 0;
		}
	}
	
	private function onPasswordChange(event:Event):void
	{
		m_EnterKey = false;

		if(m_ButEnter!=null) m_ButEnter.disable = tab != 0 && (m_Password.text == null || m_Password.text.length <= 0);
	}
	
	private function onSaveNameClick(event:Event):void
	{
		if (m_SaveName.check) {
			m_SaveAll.disable = false;
		} else {
			m_SaveAll.check = false;
			m_SaveAll.disable = true;
		}
		
		if (m_EnterKey) {
			m_EnterKey = false;
			m_Password.text = "";
			m_ButEnter.disable = tab != 0;
		}
	}

	private function onSaveAllClick(event:Event):void
	{
		if (m_EnterKey) {
			m_EnterKey = false;
			m_Password.text = "";
			m_ButEnter.disable = tab != 0;
		}
	}

	private function clickEnter(event:Event):void
	{
		if (tab == 0) {
			Hide();

			var so:SharedObject = SharedObject.getLocal("EGEmpireEnter");

			if (so != null && so.data.userid != undefined && so.data.newkey != undefined) {
				m_State = StateTraining;
				SendEnter();
			} else {
				m_State = StateTrainingName;
				NewName();
			}
			return;
		}
		if (m_Password.text == null || m_Password.text.length <= 0) return;
		
		Hide();
		SendEnter();
	}
	
	private function SendEnter():void
	{
		if (m_Server.current < 0) return;
		var str:String = m_Server.ItemData(m_Server.current) as String;

		if (m_Protocol.current < 0) return;
		var protocol:int = m_Protocol.ItemData(m_Protocol.current) as int;

		var cc:String = Capabilities.serverString;

		Server.Self.m_ServerAdr = "http://" + str + "/";
		Server.Self.m_HyperserverServerAdr = Server.Self.m_ServerAdr;
		Server.Self.m_Protocol = protocol;

		var so:SharedObject = SharedObject.getLocal("EGEmpireEnter");
		var allFonts:Array = Font.enumerateFonts(true);
		allFonts.sortOn("fontName", Array.CASEINSENSITIVE);

		if (so != null) {
			so.data.server = str;
			so.data.protocol = protocol;
		}
			
		m_Map.m_FormHint.Show(Common.Hint.ConnectServer);

        var boundary:String=Server.Self.CreateBoundary();
		for (var i:int = 0; i < allFonts.length; i++) cc += "_" + allFonts[i].fontName + "_" + allFonts[i].fontStyle + "_" + allFonts[i].fontType;

        var d:String = "";
		
		if (m_State == StateTrainingName) {
			if (so != null) so.data.name = "";
			
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"acname\"\r\n\r\n";
			d += BaseStr.TrimRepeat(BaseStr.Trim(m_NewName.text)) + "\r\n";
			
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"newaccount\"\r\n\r\n";
			d += "1" + "\r\n";

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"acneedkey\"\r\n\r\n";
			d += "1\r\n";

		} else if (m_State == StateTraining) {
			if (so != null) so.data.name = "";
			
			if (so == null || so.data.userid == undefined || so.data.newkey == undefined) return;
			
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"acid\"\r\n\r\n";
			d += so.data.userid.toString() + "\r\n";
			
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"newaccount\"\r\n\r\n";
			d += "1" + "\r\n";

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"ackey\"\r\n\r\n";
			d += so.data.newkey + "\r\n"

			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"acneedkey\"\r\n\r\n";
			d += "1\r\n";

		} else if (m_State == StateEnter) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"acname\"\r\n\r\n";
			d += m_Name.text + "\r\n";
			
			if (m_SaveName.check && m_SaveAll.check && so != null && so.data.key != undefined && so.data.key.length > 0 && m_EnterKey) {
				d += "--" + boundary + "\r\n";
				d += "Content-Disposition: form-data; name=\"ackey\"\r\n\r\n";
				d += so.data.key + "\r\n"
			} else {
				if (m_SaveName.check && m_SaveAll.check) {
					d += "--" + boundary + "\r\n";
					d += "Content-Disposition: form-data; name=\"acneedkey\"\r\n\r\n";
					d += "1\r\n";
				}
				d += "--" + boundary + "\r\n";
				d+="Content-Disposition: form-data; name=\"acpassword\"\r\n\r\n";
				d+=m_Password.text+"\r\n"
			}
			
		} else return;
		
		if (m_StateNewName) {
			d += "--" + boundary + "\r\n";
			d += "Content-Disposition: form-data; name=\"newname\"\r\n\r\n";
			d += BaseStr.TrimRepeat(BaseStr.Trim(m_NewName.text)) + "\r\n";
		}

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"accomp\"\r\n\r\n";
		d += MD5.hash(cc) + "\r\n";

		d += "--" + boundary + "--\r\n";

		m_StateNewName = false;

        //Server.Self.QueryPost("acentersys","",d,boundary,RecvEnter);
		Server.Self.QueryPost("ementer", "", d, boundary, RecvEnter, false);
	}

	public function RecvEnter(event:Event):void
	{
		var str:String;

		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var so:SharedObject = SharedObject.getLocal("EGEmpireEnter");

		var err:int = buf.readUnsignedByte();
		if (err == Server.ErrorExist) {
			Server.Self.ConnectClose(false);
			m_Map.m_FormHint.Hide();
			m_StateNewName = true;
			NewName();
			return;
			
		} 

		if (m_State == StateTrainingName && so != null) {
			so.data.name = "";

		} else if (m_State == StateTraining && so != null) {
			so.data.name = "";

		} else if (m_State == StateEnter && so != null) {
			so.data.savename = m_SaveName.check;
			so.data.saveall = m_SaveAll.check;
			if (m_SaveName.check) so.data.name = m_Name.text;
			else so.data.name = "";
			if ((m_SaveName.check == false || m_SaveAll.check == false)) so.data.key = "";
		}
		m_Password.text = "";

		if (err != 0) {
			if (so != null && m_State == StateEnter) so.data.key = "";

			if (err == Server.ErrorLockIp) {
				str=Common.Hint.LockIP;
				str = BaseStr.Replace(str, "<Val>", buf.readUnsignedInt().toString());
				EmpireMap.Self.m_FormHint.Show(str);

				Server.Self.ConnectClose();
				return;
			}

			if (m_State == StateTraining && err == Server.ErrorNoAccess) {
				Server.Self.ConnectClose(false);
				m_Map.m_FormHint.Hide();
				m_State = StateTrainingName;
				NewName();
				return;
			}
			
			EmpireMap.Self.m_FormHint.Show(Common.Hint.IncorrectNameOrPassword);
			Server.Self.ConnectClose();
			return;
		}

		var userid:uint = buf.readUnsignedInt();
		var len:int = buf.readUnsignedByte();
		var ipsession:String = buf.readUTFBytes(len);

		if (so != null && (m_State == StateTraining || m_State == StateTrainingName)) so.data.userid = userid;

		var enterkey:String = "";
		len = buf.readUnsignedByte();
		if (len > 0) {
			enterkey = buf.readUTFBytes(len);

			if (so != null && (m_State == StateTraining || m_State == StateTrainingName)) so.data.newkey = enterkey;
			else if (so != null && m_SaveName.check && m_SaveAll.check) so.data.key = enterkey;
		}

		if (userid != 0 && ipsession.length > 0) {
			Server.Self.ConnectAccept(userid,ipsession);
			Connect();
		}
	}

	public function Connect():void
	{
		var i:int;
		
		m_Map.m_FormHint.Show(Common.Hint.ConnectServer);
		m_Map.BeforeConnect();

		var uid:uint=0;

		var so:SharedObject = SharedObject.getLocal("EGEmpireData");
		if(so==null || so.size==0 || so.data.uid==undefined) {
			if(Server.Self.m_Session.length>8) {
				uid=Server.Self.m_UserId;
				//uint("0x"+Server.Self.m_Session.substring(8,Server.Self.m_Session.length));
				//trace(uid);
				so.data.uid=uid;
			}
		} else uid=so.data.uid;
		
		if(uid==0) {
			m_Map.ErrorFromServer(0,Common.Txt.NoCacheFlash);
			return;
		}

		var cc:String = Capabilities.serverString;
		
		var allFonts:Array = Font.enumerateFonts(true);
		allFonts.sortOn("fontName", Array.CASEINSENSITIVE);
		for (i = 0; i < allFonts.length; i++) {
			cc += "_" + allFonts[i].fontName + "_" + allFonts[i].fontStyle + "_" + allFonts[i].fontType;
		}
		
		cc = MD5.hash(cc);

		if(Server.Self.m_ServerEnterKey.length>0) {
			//Server.Self.Query("empreconnect","&se="+Server.Self.m_ServerEnterKey,m_Map.PreconnectComplete,false,true);
			Server.Self.Query("empreconnect","&id="+uid.toString()+"&cap="+cc,m_Map.PreconnectComplete,false,true);
			Server.Self.m_ServerEnterKey="";
		} else Server.Self.Query("empreconnect","&id="+uid.toString()+"&cap="+cc,m_Map.PreconnectComplete,false);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	public var m_NewName:CtrlInput = null;
	public var m_NewNameTest:TextField = null;
	public var m_NewNameFreeTimer:Timer = null;
	
	public function NewName():void
	{
		if (m_NewNameFreeTimer == null) {
			m_NewNameFreeTimer = new Timer(250);
			m_NewNameFreeTimer.addEventListener(TimerEvent.TIMER, NewNameFreeTimer);
		}
		
		FI.Init(360, 240)
		if (m_StateNewName) {
			FI.caption = Common.Txt.FormEnterNewNameCaptionNewName;
			FI.AddLabel(Common.Txt.FormEnterNewNameTxtNewName, true);
		} else {
			FI.caption = Common.Txt.FormEnterNewNameCaption;
			FI.AddLabel(Common.Txt.FormEnterNewNameTxt, true);
		}
		m_NewName = FI.AddInput("", 16, true, Server.LANG_RUS, false);
		m_NewName.addEventListener(Event.CHANGE, NewNameTest);
		m_NewNameTest = FI.AddLabel("", true);
		FI.Run(NewNameSend, Common.Txt.FormEnterContinue, StdMap.Txt.ButCancel, NewNameCancel);
		
		m_NewName.assignFocus();
		NewNameTest(null);
	}
	
	public static function CharInAlphabet(ch:int, lang:int):Boolean
	{
		if (lang == Server.LANG_ENG) {
			if (ch >= 97 && ch <= 122) return true;
			else if (ch >= 65 && ch <= 90) return true;

		} else if (lang == Server.LANG_RUS) {
			if (ch >= 1072 && ch <= 1103) return true;
			else if (ch >= 1040 && ch <= 1071) return true;
			else if (ch == 1105) return true;
			else if (ch == 1025) return true;
		}
		return false;
	}
	
	public static function StrSingleAlphabet(src:String, off:int, len:int):Boolean
	{
		var ch:int, i:int;
		var sl:int = src.length;

		if (len <= 0) return false;
		if (off<0 || (off+len)>sl) return false;
		
		var m:uint;
		var lm:uint = 0xffffffff;
		
		for (i = 0; i < len; i++) {
			ch = src.charCodeAt(off + i);
			
			m = 0;
			if (CharInAlphabet(ch, Server.LANG_ENG)) m |= 1 << Server.LANG_ENG;
			if (CharInAlphabet(ch, Server.LANG_RUS)) m |= 1 << Server.LANG_RUS;
			lm &= ~m;
		}
		if (!lm) return false;
		
		// Проверка на взаимоисключающие алфавиты
		if (lm & (1 << Server.LANG_ENG)) {
			if (lm & (1 << Server.LANG_RUS)) return false;
		}
		if (lm & (1 << Server.LANG_RUS)) {
			if (lm & (1 << Server.LANG_ENG)) return false;
		}
		return true;
	}
	
	public function NewNameTest(e:Event):void
	{
		FI.m_ButOk.disable = true;
		m_NewNameFreeTimer.stop();

		var ch:int;
		var n:String = BaseStr.TrimRepeat(BaseStr.Trim(m_NewName.text));
		if (n.length < 2 || n.length > 16) {
			m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrLen + "[/crt]", true, true);
			return;
		}

		var i:int;
		var lang:int = 0;

		for (i = 0; i < n.length; i++) {
			ch = n.charCodeAt(i);
			if (ch == 32) { }
			else if (ch >= 48 && ch <= 57) { }
			else if (lang == 0) {
				if (CharInAlphabet(ch, Server.LANG_ENG)) lang = Server.LANG_ENG;
				else if (CharInAlphabet(ch, Server.LANG_RUS)) lang = Server.LANG_RUS;
				else { lang = 0; break; }
			} else {
				if (!CharInAlphabet(ch, lang)) { m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrChar + "[/crt]", true, true); return; }
			}
		}
		
		if (FormChat.ReplaceBadWord(n, Common.TxtChat.LikeLetter, Common.TxtChat.GoodWord, Common.TxtChat.BadWord) != n) {
			m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrBadWord + "[/crt]", true, true);
			return;
		}
		
		m_NewNameTest.text = "";
		m_NewNameFreeTimer.start();
	}

	public function NewNameFreeTimer(event:Event):void
	{
		m_NewNameFreeTimer.stop();
		
		var n:String = BaseStr.TrimRepeat(BaseStr.Trim(m_NewName.text));
		if (n.length < 2 || n.length > 16) return;
		
		if (m_Server.current < 0) return;
		var str:String = m_Server.ItemData(m_Server.current) as String;

		if (m_Protocol.current < 0) return;
		var protocol:int = m_Protocol.ItemData(m_Protocol.current) as int;

		Server.Self.m_ServerAdr = "http://" + str + "/";
		Server.Self.m_HyperserverServerAdr = Server.Self.m_ServerAdr;
		Server.Self.m_Protocol = protocol;
		
        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"lang\"\r\n\r\n";
        d += Server.Self.m_Lang.toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"name\"\r\n\r\n";
		d += n + "\r\n";

		d += "--" + boundary + "--\r\n";

		Server.Self.QueryPost("acisfreename", "", d, boundary, NewNameFreeRecv, true);
	}
	
	public function NewNameFreeRecv(event:Event):void
	{
		var str:String;
		
		var loader:URLLoader = URLLoader(event.target);

		Server.Self.ConnectClose(false);

		str = loader.data;
		if (!BaseStr.IsTagEqNCEng(str, 0, 5, "name=")) {
			return;
		}
		str = str.substr(5);

		var i:int = str.indexOf(",");
		if (i < 0) return;
		var val:String = str.substring(0, i);
		str = BaseStr.Trim(str.substr(i + 1));
		
		if (str != BaseStr.TrimRepeat(BaseStr.Trim(m_NewName.text))) {
			return;
		}

		if (val == "free") {
			m_NewNameTest.htmlText = BaseStr.FormatTag("[clr]" + Common.Txt.FormEnterNewNameErrNone + "[/clr]", true, true);
			FI.m_ButOk.disable = false;

		} else if (val == "use") {
			m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrUse + "[/crt]", true, true);

		} else if (val == "err_len") {
			m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrLen + "[/crt]", true, true);
			
		} else if (val == "err_char") {
			m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrChar + "[/crt]", true, true);

		} else if (val == "err_reserve") {
			m_NewNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrReserve + "[/crt]", true, true);
		}
	}

	public function NewNameCancel():void
	{
		m_NewNameFreeTimer.stop();
		
		Show();
		tab = 0;
		onChangePage(null);
	}

	public function NewNameSend():void
	{
		m_NewNameFreeTimer.stop();

		Hide();

		SendEnter();
	}

	/////////////////////////////////////////////////////////////////////////////////////
	public var m_RegEmail:CtrlInput = null;
	public var m_RegPassword:CtrlInput = null;
	public var m_RegTest:TextField = null;
	public var m_RegFreeTimer:Timer = null;
	
	public function RegEmailRun():void
	{
		if (m_RegFreeTimer == null) {
			m_RegFreeTimer = new Timer(250);
			m_RegFreeTimer.addEventListener(TimerEvent.TIMER, RegEmailFreeTimer);
		}

		FI.Init(450, 370, 2);
		FI.caption = Common.Txt.FormRegEmailCaption;

		FI.SetColSize(0, 0, 100);

		FI.AddLabel(Common.Txt.FormRegEmailText, true);

		FI.AddLabel(Common.Txt.FormRegEmail + ":");
		FI.Col();
		m_RegEmail = FI.AddInput("", 63, true, Server.LANG_ENG, true, "@-_");
		m_RegEmail.input.addEventListener(Event.CHANGE, RegEmailTest);

		FI.AddLabel(Common.Txt.FormRegPassword + ":");
		FI.Col();
		m_RegPassword = FI.AddInput("", 32, true, Server.LANG_ENG);
		m_RegPassword.restrict = null;
		m_RegPassword.displayAsPassword = true;
		m_RegPassword.input.addEventListener(Event.CHANGE, RegEmailTest);
		
		m_RegTest = FI.AddLabel("", true);

		FI.Run(RegEmailSend, Common.Txt.FormRegReg, StdMap.Txt.ButCancel);
		
		m_RegEmail.assignFocus();
		RegEmailTest(null);
	}
	
	public function RegEmailTest(e:Event):void
	{
		FI.m_ButOk.disable = true;
		m_RegFreeTimer.stop();

		var ch:int;
		var n:String = BaseStr.Trim(m_RegEmail.text);
		if (n.length < 2 || n.length >= 64) {
			m_RegTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormRegErrChar + "[/crt]", true, true);
			return;
		}
		
		m_RegTest.text = "";
		m_RegFreeTimer.start();
	}

	public function RegEmailFreeTimer(event:Event):void
	{
		m_RegFreeTimer.stop();
		
		var n:String = BaseStr.Trim(m_RegEmail.text);
		if (n.length < 2) return;

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"email\"\r\n\r\n";
		d += n + "\r\n";

		d += "--" + boundary + "--\r\n";

		Server.Self.QueryPostHS("acisfreeemail", "", d, boundary, RegEmailFreeRecv, true);
	}
	
	public function RegEmailFreeRecv(event:Event):void
	{
		var str:String;

		var loader:URLLoader = URLLoader(event.target);

		str = loader.data;
		if (!BaseStr.IsTagEqNCEng(str, 0, 6, "email=")) {
			return;
		}
		str = str.substr(6);

		var i:int = str.indexOf(",");
		if (i < 0) return;
		var val:String = str.substring(0, i);
		str = BaseStr.Trim(str.substr(i + 1));
		
		if (str != BaseStr.Trim(m_RegEmail.text)) {
			return;
		}

		if (val == "free") {
			str = BaseStr.Trim(m_RegPassword.text);
			if (str.length < 1) {
				m_RegTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormRegErrPwdLen + "[/crt]", true, true);
				return;
			}
			FI.m_ButOk.disable = false;

		} else if (val == "use") {
			m_RegTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormRegErrUse + "[/crt]", true, true);

		} else if (val == "err_len") {
			m_RegTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormRegErrChar + "[/crt]", true, true);
			
		} else if (val == "err_char") {
			m_RegTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormRegErrChar + "[/crt]", true, true);
		}
	}

	public function RegEmailSend():void
	{
		var n:String = BaseStr.Trim(m_RegEmail.text);
		if (n.length < 2) return;

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";

		Server.Self.m_Anm += 256;

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"email\"\r\n\r\n";
		d += n + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"password\"\r\n\r\n";
		d += m_RegPassword.text.toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"anm\"\r\n\r\n";
		d += Server.Self.m_Anm.toString() + "\r\n";

		d += "--" + boundary + "--\r\n";

		EmpireMap.Self.m_RecvUserAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_RecvUserAfterAnm_Time = EmpireMap.Self.m_CurTime;

		Server.Self.QueryPostHS("emregemail", "", d, boundary, RegEmailRecv, false);

		EmpireMap.Self.m_UserFlag &= ~Common.UserFlagAccountTmp;
	}
	
	public function RegEmailRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if (EmpireMap.Self.ErrorFromServer(buf.readUnsignedByte())) return;

		FormMessageBox.Run(Common.Txt.FormRegEmailComplate);
	}

	/////////////////////////////////////////////////////////////////////////////////////
	public var m_BuyName:CtrlInput = null;
	public var m_BuyNameTest:TextField = null;
	public var m_BuyNameFreeTimer:Timer = null;

	public function BuyNameRun():void
	{
		if (m_BuyNameFreeTimer == null) {
			m_BuyNameFreeTimer = new Timer(250);
			m_BuyNameFreeTimer.addEventListener(TimerEvent.TIMER, BuyNameFreeTimer);
		}

		FI.Init(420, 300)
		FI.caption = Common.Txt.FormBuyNameCaption;
		FI.AddLabelIdent(BaseStr.Replace(Common.Txt.FormBuyNameTxt, "<Price>", "[clr]" + BaseStr.FormatBigInt(Common.BuyNameCost) + "[/clr]"), true);
		m_BuyName = FI.AddInput("", 16, true, Server.LANG_RUS, false);
		m_BuyName.addEventListener(Event.CHANGE, BuyNameTest);
		m_BuyNameTest = FI.AddLabel("", true);
		FI.Run(BuyNameSend, Common.Txt.FormBuyNameButBuy,StdMap.Txt.ButClose);

		m_BuyName.assignFocus();
		BuyNameTest(null);
	}
	
	public function BuyNameTest(e:Event):void
	{
		FI.m_ButOk.disable = true;
		m_BuyNameFreeTimer.stop();

		var ch:int;
		var n:String = BaseStr.TrimRepeat(BaseStr.Trim(m_BuyName.text));
		if (n.length < 2 || n.length > 16) {
			m_BuyNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrLen + "[/crt]", true, true);
			return;
		}

		var i:int;
		var lang:int = 0;

		for (i = 0; i < n.length; i++) {
			ch = n.charCodeAt(i);
			if (ch == 32) { }
			else if (ch >= 48 && ch <= 57) { }
			else if (lang == 0) {
				if (CharInAlphabet(ch, Server.LANG_ENG)) lang = Server.LANG_ENG;
				else if (CharInAlphabet(ch, Server.LANG_RUS)) lang = Server.LANG_RUS;
				else { lang = 0; break; }
			} else {
				if (!CharInAlphabet(ch, lang)) { m_BuyNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrChar + "[/crt]", true, true); return; }
			}
		}
		
		if (FormChat.ReplaceBadWord(n, Common.TxtChat.LikeLetter, Common.TxtChat.GoodWord, Common.TxtChat.BadWord) != n) {
			m_BuyNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrBadWord + "[/crt]", true, true);
			return;
		}
		
		m_BuyNameTest.text = "";
		m_BuyNameFreeTimer.start();
	}

	public function BuyNameFreeTimer(event:Event):void
	{
		m_BuyNameFreeTimer.stop();
		
		var n:String = BaseStr.TrimRepeat(BaseStr.Trim(m_BuyName.text));
		if (n.length < 2 || n.length > 16) return;
		
        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";
        d+="--"+boundary+"\r\n";
        d+="Content-Disposition: form-data; name=\"lang\"\r\n\r\n";
        d += Server.Self.m_Lang.toString() + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"name\"\r\n\r\n";
		d += n + "\r\n";

		d += "--" + boundary + "--\r\n";

		Server.Self.QueryPost("acisfreename", "", d, boundary, BuyNameFreeRecv, true);
	}
	
	public function BuyNameFreeRecv(event:Event):void
	{
		var str:String;

		var loader:URLLoader = URLLoader(event.target);

		str = loader.data;
		if (!BaseStr.IsTagEqNCEng(str, 0, 5, "name=")) {
			return;
		}
		str = str.substr(5);

		var i:int = str.indexOf(",");
		if (i < 0) return;
		var val:String = str.substring(0, i);
		str = BaseStr.Trim(str.substr(i + 1));

		if (str != BaseStr.TrimRepeat(BaseStr.Trim(m_BuyName.text))) {
			return;
		}

		if (val == "free") {
			m_BuyNameTest.htmlText = BaseStr.FormatTag("[clr]" + Common.Txt.FormEnterNewNameErrNone + "[/clr]", true, true);
			FI.m_ButOk.disable = false;

		} else if (val == "use") {
			m_BuyNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrUse + "[/crt]", true, true);

		} else if (val == "err_len") {
			m_BuyNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrLen + "[/crt]", true, true);
			
		} else if (val == "err_char") {
			m_BuyNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrChar + "[/crt]", true, true);

		} else if (val == "err_reserve") {
			m_BuyNameTest.htmlText = BaseStr.FormatTag("[crt]" + Common.Txt.FormEnterNewNameErrReserve + "[/crt]", true, true);
		}
	}

	public function BuyNameSend():void
	{
		m_BuyNameFreeTimer.stop();

		if (EmpireMap.Self.m_UserEGM < Common.BuyNameCost) { FormMessageBox.RunErr(Common.Txt.NoEnoughEGM2); return; }
		
		var n:String = BaseStr.TrimRepeat(BaseStr.Trim(m_BuyName.text));
		if (n.length < 2) return;

        var boundary:String=Server.Self.CreateBoundary();

        var d:String="";

		Server.Self.m_Anm += 256;

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"name\"\r\n\r\n";
		d += n + "\r\n";

		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"anm\"\r\n\r\n";
		d += Server.Self.m_Anm.toString() + "\r\n";

		d += "--" + boundary + "--\r\n";

		EmpireMap.Self.m_RecvUserAfterAnm = Server.Self.m_Anm;
		EmpireMap.Self.m_RecvUserAfterAnm_Time = EmpireMap.Self.m_CurTime;

		Server.Self.QueryPostHS("embuyname", "", d, boundary, BuyNameRecv, false);

		EmpireMap.Self.m_UserFlag |= ~Common.UserFlagAccountFull;
	}

	public function BuyNameRecv(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint = buf.readUnsignedByte();
		if (err == Server.ErrorNoEnoughEGM) { FormMessageBox.RunErr(Common.Txt.NoEnoughEGM2); return; }
		else if (err == Server.ErrorExistName) { FormMessageBox.RunErr(Common.Txt.FormEnterNewNameErrUse); return; }
		else if(err==Server.ErrorData) { FormMessageBox.RunErr(Common.Txt.FormEnterNewNameErrName); return; }
		else if (EmpireMap.Self.ErrorFromServer(err)) return;

		FormMessageBox.Run(Common.Txt.FormBuyNameComplate);
		EmpireMap.Self.QuerySessionUser();
	}

	/////////////////////////////////////////////////////////////////////////////////////
	public var m_RegCloneName:CtrlInput = null;
	public var m_RegClonePass:CtrlInput = null;

	public function RegCloneRun():void
	{
		FI.Init(480, 440)
		FI.caption = Common.Txt.FormRegCloneCaption;
		FI.AddLabelIdent(Common.Txt.FormRegCloneTxt, true);
		
		FI.AddLabel(Common.Txt.FormEnterName + ":");
		FI.Col();
		m_RegCloneName = FI.AddInput("", 33, true, Server.LANG_RUS, true, "@");
		
		FI.AddLabel(Common.Txt.FormEnterPassword + ":");
		FI.Col();
		m_RegClonePass = FI.AddInput("", 33, true, Server.LANG_RUS, true);
		m_RegClonePass.displayAsPassword = true;

		FI.Run(RegCloneSend, Common.Txt.FormRegCloneBut,StdMap.Txt.ButClose);
		m_RegCloneName.assignFocus();
	}

	public function RegCloneSend():void
	{
        var boundary:String=Server.Self.CreateBoundary();
        var d:String = "";
		
		d += "--" + boundary + "\r\n";
		d += "Content-Disposition: form-data; name=\"acname\"\r\n\r\n";
		d += m_RegCloneName.text + "\r\n";
			
		d += "--" + boundary + "\r\n";
		d+="Content-Disposition: form-data; name=\"acpassword\"\r\n\r\n";
		d += m_RegClonePass.text + "\r\n"

		d += "--" + boundary + "--\r\n";

		Server.Self.QueryPost("emregclone", "", d, boundary, RegCloneAnswer, false);
	}
	
	public function RegCloneAnswer(event:Event):void
	{
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		var err:uint = buf.readUnsignedByte();
		if (err == Server.ErrorNoAccess) { FormMessageBox.RunErr(Common.Txt.FormRegCloneErrNoAccess); return; }
		else if (err == Server.ErrorExist) { FormMessageBox.RunErr(Common.Txt.FormRegCloneErrNeedOther); return; }
		else if (err == Server.ErrorNone) { EmpireMap.Self.m_UserExistClone = true; FormMessageBox.Run(Common.Txt.FormRegCloneComplate); return; }
		else if (EmpireMap.Self.ErrorFromServer(err)) return;
	}
		
}

}
