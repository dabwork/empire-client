package Empire
{

import Base.*;
import Engine.*;
import fl.controls.*;
import fl.events.*;
import flash.sampler.NewObjectSample;

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;
import flash.ui.*;

public class FormNews extends Sprite
{
	static public const NewsTypeExport:int = 1;
	static public const NewsTypeImport:int = 2;
	static public const NewsTypeManufacture:int = 3;
	static public const NewsTypeDestroyFlagship:int = 4;
	static public const NewsTypeDestroyQuarkBase:int = 5;
	static public const NewsTypeCombatStart:int = 6;
	static public const NewsTypeCombatEnd:int = 7;
	static public const NewsTypeDuelStart:int = 8;
	static public const NewsTypeCotlPrepare:int = 9;
	static public const NewsTypeCotlReady:int = 10;
	static public const NewsTypeCotlCapture:int = 11;
	static public const NewsTypeCotlCtrl:int = 12;
	static public const NewsTypeHomeworldCapture:int = 13;
	static public const NewsTypeInvasion:int = 14;
	static public const NewsTypeBattle:int = 15;

    static public const CotlUser:uint=1;
    static public const CotlCombat:uint=2;
    static public const CotlCommon:uint=3;

    static public const CotlShift:uint=5;
    static public const CotlMask:uint=3<<CotlShift;

    static public const UnionMask:uint=0xf0;
    static public const UnionShift:uint=4;

	public static var Self:FormNews = null;
	private var EM:EmpireMap = null;
	
	public static const SizeX:int = 650;
	public static const SizeY:int = 550;
	public static const ContentPosX:int = 20;
	public static const ContentPosY:int = 50;
	public static const ContentSizeX:int = SizeX - 20 - 25;
	public static const ContentSizeY:int = SizeY - 50 - 50;

	public var m_News:Array = new Array();
	public var m_NewsMap:Dictionary = new Dictionary(true);
	
	public var m_Timer:Timer = new Timer(1000);
	
	public var m_NewsForUserVer:uint = 0;
	
	public var m_List:Array = new Array();
	
	public var m_Frame:Sprite=new GrFrame();
	public var m_Title:TextField=new TextField();
	public var m_ButClose:Button = new Button();
	
	public var m_Content:Sprite = new Sprite();
	public var m_ContentSB:UIScrollBar = new UIScrollBar();
	
	public var m_ContentTF:TextFormat = null; 
	
	public var m_ContentLineSize:int = 0;
	
	public var m_SelectSprite:Sprite = null;
	
	public var m_NewsCur:Number = 0;

	public function FormNews(map:EmpireMap)
	{
		EM = map;
		Self = this;

		m_Timer.addEventListener("timer", TimerUpdate);

		m_ContentTF=new TextFormat("Calibri",14,0xffffff,null,null,null,null,null,TextFormatAlign.JUSTIFY,null,null,20);
		m_ContentTF.rightMargin=5;
		m_ContentTF.leftMargin = 10;
		
		m_ContentLineSize = 17;

		m_Frame.width = SizeX;
		m_Frame.height = SizeY;
		addChild(m_Frame);

		m_Title.x = 10;
		m_Title.y = 5;
		m_Title.width = 1;
		m_Title.height = 1;
		m_Title.type = TextFieldType.DYNAMIC;
		m_Title.selectable = false;
		m_Title.border = false;
		m_Title.background = false;
		m_Title.multiline = false;
		m_Title.autoSize = TextFieldAutoSize.LEFT;
		m_Title.antiAliasType = AntiAliasType.ADVANCED;
		m_Title.gridFitType = GridFitType.PIXEL;
		m_Title.defaultTextFormat = new TextFormat("Calibri", 18, 0xc4fff2);
		m_Title.embedFonts = true;
		m_Title.text = Common.Txt.FormNewsCaption;
		addChild(m_Title);

		var mask:Sprite = new Sprite();
		mask.graphics.clear();
		mask.graphics.beginFill(0xFF0000);
		mask.graphics.drawRect(ContentPosX, ContentPosY, ContentSizeX, ContentSizeY);
		mask.graphics.endFill();
		addChild(mask);

		m_Content.x = ContentPosX;
		m_Content.y = ContentPosY;
		m_Content.mask = mask;
		addEventListener(MouseEvent.MOUSE_WHEEL, onContentMouseWell);
		addChild(m_Content);

		Common.UIChatBar(m_ContentSB);
		m_ContentSB.visible = false;
		m_ContentSB.addEventListener(ScrollEvent.SCROLL, onContentScroll);
		m_ContentSB.setScrollProperties(ContentSizeY, 0, 0, ContentSizeY);
		m_ContentSB.lineScrollSize = m_ContentLineSize;
		addChild(m_ContentSB);

		m_ButClose.label = Common.Txt.ButClose;
		m_ButClose.width = 90;
		Common.UIStdBut(m_ButClose);
		m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
		m_ButClose.x = SizeX - m_ButClose.width - 10;
		m_ButClose.y = SizeY - m_ButClose.height - 15;
		addChild(m_ButClose);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}

	public function StageResize():void
	{
		if (!visible) return;// && EM.IsResize()) Show();
		x = (EM.stage.stageWidth >> 1) - (SizeX >> 1);
		y = (EM.stage.stageHeight >> 1) - (SizeY >> 1);
	}

	public function ClearForNewConn():void
	{
		m_NewsForUserVer = 0;
	}
	
	public function IsMouseIn():Boolean
	{
		if(!visible) return false;
		if(mouseX>=0 && mouseX<SizeX && mouseY>=0 && mouseY<SizeY) return true;
		return false;
	}

	public function Show():void
	{
		if (!m_Timer.running) m_Timer.start();
		//if(!Prepare()) return;

		EM.FloatTop(this);

		visible = true;
		
		m_ContentSB.scrollPosition = 0;

		StageResize();
	}

	public function Hide():void
	{
		m_Timer.stop();
		visible = false;
	}

	public function clickClose(...args):void
	{
		if(EM.m_FormInput.visible) return;
		if (FormMessageBox.Self.visible) return;
		Hide();
	}

	public function onMouseDown(e:MouseEvent) : void
	{
		e.stopImmediatePropagation();
		EM.FloatTop(this);

		if (FormMessageBox.Self.visible) return;
		if (EM.m_FormInput.visible) return;

		if (m_ButClose.hitTestPoint(e.stageX, e.stageY)) return;
		if (m_ContentSB.hitTestPoint(e.stageX, e.stageY)) return;
		//if ((e.stageX >= (x + ContentPosX)) && (e.stageX < (x + ContentPosX + ContentSizeX)) && (e.stageY >= (y + ContentPosY)) && (e.stageY < (y + ContentPosY + ContentSizeY))) return;
		
		onMouseMove(e);
		if (m_NewsCur != 0) {
			onLinkClick();
			return;
		}

		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDrag, true, 999);
		return;
	}

	protected function onMouseUpDrag(e:MouseEvent):void
	{
		e.stopImmediatePropagation();
		stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
		stopDrag();
	}

	public function onMouseMove(e:MouseEvent) : void
	{
		if(e!=null) e.stopImmediatePropagation();

		if (EM.m_FormMenu.visible) return;
		if (EM.m_FormInput.visible) return;
		
		var hideinfo:Boolean = true;
		
		var cur:Number = PickNews();
		if (cur != m_NewsCur) {
			m_NewsCur = cur;
			if (m_NewsCur == 0) Mouse.cursor = MouseCursor.AUTO;
			else Mouse.cursor = MouseCursor.BUTTON;
			Update();
		}
		
		if (hideinfo) EM.m_Info.Hide();
	}

	public function onMouseOut(e:MouseEvent) : void
	{
		if (m_NewsCur != 0) {
			m_NewsCur = 0;
			Mouse.cursor = MouseCursor.AUTO;
			Update();
		}
	}

	public function TimerUpdate(event:TimerEvent=null):void
	{
		Prepare();
		if (visible) Update();
	}

	public function LoadNews(src:String):void
	{
		var i:int, u:int, k:int, type:int;
		var ibegin:int, iend:int;
		var ch:int;
		var len:int=src.length;
		var off:int = 0;
		var name:String, str:String;
		var gr:Object=null;
		var header:Boolean = false;

		for (i = 0; i < m_News.length; i++) {
			gr = m_News[i];
			delete m_NewsMap[gr.Name];
		}
		m_News.length = 0;

		//trace("==LoadNews==");

		while(off<len) {
			while(off<len) { ch=src.charCodeAt(off); if(ch==32 || ch==9 || ch==13 || ch==10) off++; else break; }
			if(off>=len) break;

			ch=src.charCodeAt(off);
			if(ch==0x5b) { // []
				off++;
				while(off<len) { ch=src.charCodeAt(off); if(ch==32 || ch==9 || ch==10 || ch==13) off++; else break; }

				ibegin=off;
				while(off<len) { ch=src.charCodeAt(off); if(ch!=0x5D) off++; else break; }
				if(off>=len) break;

				iend=off; off++;
				while(iend>ibegin) { ch=src.charCodeAt(iend-1); if(ch==32 || ch==9 || ch==10 || ch==13) iend--; else break; }

				if (iend > ibegin) {

					u = src.indexOf(",", ibegin);
					if (u > ibegin && u < iend) {
						//str = src.substring(ibegin, u);
						if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "export", "EXPORT")) type = NewsTypeExport;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "import", "IMPORT")) type = NewsTypeImport;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "manufacture", "MANUFACTURE")) type = NewsTypeManufacture;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "destroyflagship", "DESTROYFLAGSHIP")) type = NewsTypeDestroyFlagship;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "destroyquarkbase", "DESTROYQUARKBASE")) type = NewsTypeDestroyQuarkBase;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "combatstart", "COMBATSTART")) type = NewsTypeCombatStart;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "combatend", "COMBATEND")) type = NewsTypeCombatEnd;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "duelstart", "DUELSTART")) type = NewsTypeDuelStart;

						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "cotlprepare", "COTLPREPARE")) type = NewsTypeCotlPrepare;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "cotlready", "COTLREADY")) type = NewsTypeCotlReady;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "cotlcapture", "COTLCAPTURE")) type = NewsTypeCotlCapture;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "cotlctrl", "COTLCTRL")) type = NewsTypeCotlCtrl;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "homeworldcapture", "HOMEWORLDCAPTURE")) type = NewsTypeHomeworldCapture;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "invasion", "INVASION")) type = NewsTypeInvasion;
						else if (BaseStr.IsTagEq(src, ibegin, u - ibegin, "battle", "BATTLE")) type = NewsTypeBattle;

						else { FormChat.Self.AddDebugMsg("Error load news: Unknown news type:"+src.substring(ibegin,u)); return;  }

						header = true;

						gr=new Object();
						gr.Type = type;
						gr.Name = src.substring(u + 1, iend);
						if (m_NewsMap[gr.Name] != undefined) { FormChat.Self.AddDebugMsg("Error load news: Duplicate name: " + gr.Name); return;  }
						m_News.push(gr);
						m_NewsMap[gr.Name] = gr;
//						trace("News {" + type.toString() + " "+ gr.Name + "}");
					} else { FormChat.Self.AddDebugMsg("Error load news: Unknown news type."); return;  }
				}

			} else if(ch==0x2f) { // /
				off++; if(off>=len) break;
				if(src.charCodeAt(off)!=0x2f) continue;

				while (off < len) { ch = src.charCodeAt(off); if (ch != 10 && ch != 13) off++; else break; }

			} else { // Par or Text
				ibegin = off;
				var par:Boolean = header;
				if(par) {
					while (ibegin < len) {
						ch = src.charCodeAt(ibegin);
						ibegin++;
						if (ch == 61) break;
						else if (ch == 32 || ch == 9 || ch==10) { par = false; break;  }
					}
					if (ibegin >= len) par = false;
				}

				if (par) {
					name = src.substring(off, ibegin-1);
					off = ibegin;

					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend = off;

					if(iend>ibegin && gr!=null) {
						str = src.substring(ibegin, iend);

						if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnionNone")) gr.FUnionNone = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnionPirate")) gr.FUnionPirate = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnionClan")) gr.FUnionClan = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnionMercenary")) gr.FUnionMercenary = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnionTrader")) gr.FUnionTrader = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnionEmpire")) gr.FUnionEmpire = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnionRepublic")) gr.FUnionRepublic = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnionAlliance")) gr.FUnionAlliance = str;

						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnionNone")) gr.SUnionNone = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnionPirate")) gr.SUnionPirate = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnionClan")) gr.SUnionClan = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnionMercenary")) gr.SUnionMercenary = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnionTrader")) gr.SUnionTrader = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnionEmpire")) gr.SUnionEmpire = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnionRepublic")) gr.SUnionRepublic = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnionAlliance")) gr.SUnionAlliance = str;

						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "CotlUser")) gr.CotlUser = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "CotlCombat")) gr.CotlCombat = str;
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "CotlCommon")) gr.CotlCommon = str;

//						trace("Par {" +name + "=" + str + "}");
					}
				} else {
					header = false;

					ibegin=off;
					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend=off;

					while(iend>ibegin) { ch=src.charCodeAt(iend-1); if(ch==32 || ch==9 || ch==10 || ch==13) iend--; else break; }

					if(iend>ibegin && gr!=null) {
						if (gr.TextList == undefined) gr.TextList = new Array();
						gr.TextList.push(src.substring(ibegin,iend));
//						if(gr.TextList.length<=0) gr.TextList.push(src.substring(ibegin,iend));
//						else {
//							if(gr.TextList[gr.TextList.length-1].length>0) gr.TextList[gr.TextList.length-1]+="\n\n"; 
//							gr.TextList[gr.TextList.length-1]+=src.substring(ibegin,iend);
//						}

//						trace("Text {" + gr.TextList[gr.TextList.length - 1] + "}");
					}
				}
			}
		}
	}

	public function Prepare():Boolean
	{
//if(test) EM.m_FormHint.Show("###FormNews00");
		if (m_News.length > 0) return true;

//if(test) EM.m_FormHint.Show("###FormNews01");
		var str:String = LoadManager.Self.Get("news_rus.txt") as String;
		//var str:String = LoadManager.Self.Get("news_rus.txt") as String;
//if(test) EM.m_FormHint.Show("###FormNews02");
		if (str == null) return false;
//if(test) EM.m_FormHint.Show("###FormNews03");
		LoadNews(str);
//if(test) EM.m_FormHint.Show("###FormNews04");

		return true;
	}

	public function Update():void
	{
		var i:int, a:int;
		var n:Object, d:Object;
		var str:String;

		Prepare();
		
		var sy:int = 0;
		var sy2:int = 0;

		var inbegin:Boolean = m_ContentSB.scrollPosition == 0;
		var havenew:Boolean = false;
		var lasty:int = 0;
		var newy:int = 0;
		var findy:Boolean = false;

		var addtolocal:Number = (new Date()).getTime() - EM.m_ConnectDate.getTime();
		
		var dictor:int = -1;
		var showfull:Boolean = true;
		var lastface:DisplayObject = null;
		
		if(m_SelectSprite==null) {
			m_SelectSprite = new Sprite();
			m_Content.addChild(m_SelectSprite);
			m_SelectSprite.graphics.lineStyle(0.0, 0, 0.0);
			m_SelectSprite.graphics.beginFill(0x0f2738, 1.0);
			m_SelectSprite.graphics.drawRect(100, 0, ContentSizeX - 100, 10);
			m_SelectSprite.graphics.endFill();
		}
		m_SelectSprite.visible = false;

		for (i = 0; i < Math.min(40, m_List.length); i++) {
			n = m_List[i];

			if (n.m_TextId.length <= 0) continue;
			
			if (sy != 0) sy += m_ContentLineSize;

			d = null;
			if (m_NewsMap[n.m_TextId] != undefined) {
				d = m_NewsMap[n.m_TextId];
				if (d.TextList == undefined) continue;
			}

			//d = null;

			if (n.Text == undefined) {
				str = FormatNews(n, d);
				if (str == null) continue;

				n.IFace = null;

				var md:Date=EM.GetServerDate();
				md.setTime(md.getTime() + (n.m_ChangeDate - EM.GetServerGlobalTime()) + addtolocal);

				n.TDate = new TextField();
				n.TDate.x = 130;
				n.TDate.width = 1;// SizeX - n.Text.x - 20;
				n.TDate.height = 1;
				n.TDate.type = TextFieldType.DYNAMIC;
				n.TDate.selectable = false;
				n.TDate.border = false;
				n.TDate.background = false;
				n.TDate.multiline = false;
				n.TDate.wordWrap = false;
				n.TDate.condenseWhite=true;
				//n.TDate.alwaysShowSelection=true;
				n.TDate.autoSize = TextFieldAutoSize.LEFT;
				n.TDate.antiAliasType = AntiAliasType.ADVANCED;
				n.TDate.gridFitType = GridFitType.PIXEL;
				n.TDate.defaultTextFormat = new TextFormat("Calibri", m_ContentTF.size, 0x808080);
				n.TDate.embedFonts = true;
				n.TDate.htmlText = Common.DateToStrEx(md,false);
				m_Content.addChild(n.TDate);
				
				n.Link = new TextField();
//				n.Link.addEventListener(MouseEvent.MOUSE_MOVE, onLinkMove);
//				n.Link.addEventListener(MouseEvent.MOUSE_OUT, onLinkOut);
//				n.Link.addEventListener(MouseEvent.CLICK, onLinkClick);
				n.Link.x = n.TDate.x + n.TDate.width + 15;
				n.Link.width = 1;
				n.Link.height = 1;
				n.Link.type = TextFieldType.DYNAMIC;
				n.Link.selectable = false;
				n.Link.border = false;
				n.Link.background = false;
				n.Link.multiline = false;
				n.Link.wordWrap = false;
				n.Link.condenseWhite=true;
				n.Link.autoSize = TextFieldAutoSize.LEFT;
				n.Link.antiAliasType = AntiAliasType.ADVANCED;
				n.Link.gridFitType = GridFitType.PIXEL;
				n.Link.defaultTextFormat = new TextFormat("Calibri", m_ContentTF.size, 0x00ff00);
				n.Link.embedFonts = true;
//				n.Link.useHandCursor = true;
				if (n.m_Type == NewsTypeImport) n.Link.text = Common.Txt.FormNewsLinkImport;
				else if (n.m_Type == NewsTypeExport) n.Link.text = Common.Txt.FormNewsLinkExport;
				m_Content.addChild(n.Link);

				n.Text = new TextField();
				n.Text.x = 100;
				n.Text.width = ContentSizeX - n.Text.x;
				n.Text.height = 1;
				n.Text.type = TextFieldType.DYNAMIC;
				n.Text.selectable = false;
				n.Text.border = false;
				n.Text.background = false;
				n.Text.multiline = true;
				n.Text.wordWrap = true;
				n.Text.condenseWhite=true;
				n.Text.alwaysShowSelection=true;
				n.Text.autoSize = TextFieldAutoSize.LEFT;
				n.Text.antiAliasType = AntiAliasType.ADVANCED;
				n.Text.gridFitType = GridFitType.PIXEL;
				n.Text.defaultTextFormat = m_ContentTF;
				n.Text.embedFonts = true;
				n.Text.htmlText = str;
				m_Content.addChild(n.Text);

				n.Text.height;
			}

			if (dictor != n.m_Dictor) {
				showfull = true;
				if(sy2!=0) sy = sy2 + m_ContentLineSize;
				dictor = n.m_Dictor;
				if(n.IFace==undefined || n.IFace==null) {
					n.IFace = new Bitmap();
					n.IFace.bitmapData = Common.CreateByName("Face"+Common.RaceSysName[dictor]+"News");
					n.IFace.x = 0;
					m_Content.addChild(n.IFace);
				}
				lastface = n.IFace;
			} else {
				showfull = d != null;
				if (n.IFace != undefined || n.IFace != null) {
					m_Content.removeChild(n.IFace);
					n.IFace = null;
				}
			}
			
			if(n.LastY==undefined || findy) {
				n.LastY = sy;
			} else {
				findy = true;
				lasty = n.LastY;
				n.LastY = sy;
				newy = sy;
			}

			if (n.IFace != null) n.IFace.y = sy;
			if (showfull) {
				n.TDate.visible = true;
				n.Link.visible = true;

				n.TDate.y = sy - 2;
				n.Link.y = sy - 2;
				n.Text.y = sy + m_ContentLineSize * 2 - 2;
			} else {
				n.TDate.visible = false;
				n.Link.visible = false;

				n.Text.y = sy - 2;
			}

			if (lastface != null) a = Math.max(n.Text.y + n.Text.height - sy - 2, lastface.y + lastface.height - sy);
			else a = n.Text.y + n.Text.height - sy - 2;
			a = Math.ceil(a / m_ContentLineSize) * m_ContentLineSize;
			sy2 = sy + a;

			a = n.Text.y + n.Text.height - sy - 2;
			a = Math.ceil(a / m_ContentLineSize) * m_ContentLineSize;
			sy += a;

			if (m_NewsCur == n.m_ChangeDate) {
				m_SelectSprite.visible = true;
				m_SelectSprite.y = n.Text.y - 2;
				m_SelectSprite.height = n.Text.height + 4;
			}
		}

		while (i < m_List.length) {
			n = m_List[i];
			if (n.IFace != undefined || n.IFace != null) {
				m_Content.removeChild(n.IFace);
				n.IFace = null;
			}
			if (n.Link != undefined || n.Link != null) {
				m_Content.removeChild(n.Link);
				n.Link = null;
			}
			if (n.TDate != undefined || n.TDate != null) {
				m_Content.removeChild(n.TDate);
				n.TDate = null;
			}
			if (n.Text != undefined || n.Text != null) {
				m_Content.removeChild(n.Text);
				n.Text = null;
			}
			m_List.splice(i, 1);
		}
		
		if (inbegin) {
			m_ContentSB.scrollPosition = 0;
//			if ((newy - lasty) != 0) {
//				m_NTScroll += newy - lasty;
//				m_ScrollTimer.start();
//			}
		} else {
			m_ContentSB.scrollPosition = m_ContentSB.scrollPosition + (newy - lasty);
		}
		
		m_ContentSB.move(ContentPosX+ContentSizeX, ContentPosY);
		m_ContentSB.setSize(m_ContentSB.width, ContentSizeY);
		if (sy <= ContentSizeY) {
			m_ContentSB.visible = false;
		} else {
			m_ContentSB.visible = true;
			//m_ContentSB.setScrollProperties(ContentSizeY, 0, sy, ContentSizeY);
			m_ContentSB.maxScrollPosition = Math.max(0,sy-ContentSizeY);
//			m_ContentSB.update();
		}
		m_Content.y = ContentPosY - Math.ceil(m_ContentSB.scrollPosition / m_ContentLineSize) * m_ContentLineSize;
	}
	
	public function PickNews():Number
	{
		var i:int;
		var n:Object;

		if (!m_Content.hitTestPoint(stage.mouseX, stage.mouseY)) return 0;

		for (i = 0; i < m_List.length; i++) {
			n = m_List[i];
			if (n.Text == undefined) continue;

			if (n.Text.hitTestPoint(stage.mouseX, stage.mouseY)) return n.m_ChangeDate;
		}

		return 0;
	}
	
	public function onLinkMove(e:MouseEvent):void
	{
		var f:TextField = e.currentTarget as TextField;
		f.textColor = 0xffff00;
		Mouse.cursor = MouseCursor.BUTTON;
	}
	
	public function onLinkOut(e:MouseEvent):void
	{
		var f:TextField = e.currentTarget as TextField;
		f.textColor = 0x00ff00;
		Mouse.cursor = MouseCursor.AUTO;
	}
	
	public function onLinkClick(e:MouseEvent=null):void
	{
		var i:int;
		var n:Object;

		for (i = 0; i < m_List.length; i++) {
			n = m_List[i];
			if (e!=null) {
				if (n.Link == e.currentTarget) break;
			} else {
				if (n.m_ChangeDate == m_NewsCur) break;
			}
		}
		if (i >= m_List.length) return;

		if (n.m_Type == NewsTypeImport || n.m_Type == NewsTypeExport) {
			if (n.F == undefined) return;
			var user:User = UserList.Self.GetUser(n.F, true, false);
			if (user == null) return;

			if (!EM.HS.visible) EM.m_FormInfoBar.clickGalaxy(null);
			if (EM.HS.visible) {
				EM.FormHideAll();

				if (EM.m_FormHist.visible) EM.m_FormHist.Hide();
				EM.m_FormHist.m_CotlId=Server.Self.m_CotlId;
				EM.m_FormHist.Show();
				EM.m_FormHist.ChangeMode(EM.m_FormHist.m_ModeFind);

				if(n.m_Type == NewsTypeImport) EM.m_FormHist.m_FindQuery.text = Common.Txt.FindImportKeyword + " " + Common.Txt.FindCotlKeyword + " " + EM.Txt_CotlOwnerName(0, user.m_Id);
				else EM.m_FormHist.m_FindQuery.text = Common.Txt.FindExportKeyword + " " + Common.Txt.FindCotlKeyword + " " + EM.Txt_CotlOwnerName(0, user.m_Id);
				EM.m_FormHist.clickFind(null);
			}

		} else if (n.m_Type == NewsTypeCotlCapture || n.m_Type == NewsTypeCotlCtrl || n.m_Type == NewsTypeCotlPrepare) {
			var str:String = EM.CotlName(n.m_CotlId);
			if (str==null || str.length<=0) return;

			if (!EM.HS.visible) EM.m_FormInfoBar.clickGalaxy(null);
			if (EM.HS.visible) {
				EM.FormHideAll();
				
				if (EM.m_FormHist.visible) EM.m_FormHist.Hide();
				EM.m_FormHist.m_CotlId=Server.Self.m_CotlId;
				EM.m_FormHist.Show();
				EM.m_FormHist.ChangeMode(EM.m_FormHist.m_ModeFind);

				EM.m_FormHist.m_FindQuery.text = Common.Txt.FindCotlKeyword + " " + str;
				EM.m_FormHist.clickFind(null);
			}

		} else if (n.m_Type == NewsTypeCotlReady) {
			if (Server.Self.m_CotlId == n.m_CotlId) {
				if (EM.HS.visible) {
					EM.HS.Hide();
					EM.FormHideAll();
				}
			} else {
				EM.GoTo(false, n.m_CotlId);
			}

		} else if (n.m_Type == NewsTypeCombatStart || n.m_Type == NewsTypeDuelStart || n.m_Type == NewsTypeCombatEnd) {
			EM.FormHideAll();

			EM.m_FormCombat.ShowEx(n.m_RId);

		} else if (n.m_Type == NewsTypeDestroyFlagship || n.m_Type == NewsTypeDestroyQuarkBase || n.m_Type == NewsTypeHomeworldCapture || n.m_Type == NewsTypeInvasion || n.m_Type == NewsTypeBattle) {
			if (((n.m_Flag & CotlMask)>>CotlShift)==CotlCombat) {
				EM.m_FormCombat.ShowEx(n.m_CotlId);
			} else {
				EM.GoTo(true, n.m_CotlId, n.m_SecX, n.m_SecY, n.m_PlanetNum);
			}

		} else return;

		Mouse.cursor = MouseCursor.AUTO;
		Hide();
	}

	public function onContentScroll(e:ScrollEvent):void
	{
		m_Content.y = ContentPosY - Math.ceil(e.position / m_ContentLineSize) * m_ContentLineSize;
	}
	
	public function onContentMouseWell(e:MouseEvent):void
	{
		//trace(e.delta);
		e.stopImmediatePropagation();
		m_ContentSB.scrollPosition -= e.delta * m_ContentLineSize;
		
		onMouseMove(null);
	}

	public function NewsForUserQuery():void
	{
		if (Server.Self.IsSendCommand("emnews")) return;
		Server.Self.QueryHS("emnews",'&val='+m_NewsForUserVer.toString(),NewsForUserAnswer,false);
	}

	public function NewsForUserAnswer(event:Event):void
	{
		var i:int, len:int;
		var n:Object;
		var loader:URLLoader = URLLoader(event.target);

		var buf:ByteArray=loader.data;
		buf.endian=Endian.LITTLE_ENDIAN;

		if (EM.ErrorFromServer(buf.readUnsignedByte())) return;

		var ver:uint = buf.readUnsignedInt();
		if (ver <= m_NewsForUserVer) return;

		m_NewsForUserVer = ver;

//		var rp:int = buf.position;
//		for (i = 0; i < 10; i++) {
//			buf.position = rp;

			var sl:SaveLoad=new SaveLoad();
			sl.LoadBegin(buf);

			while (true) {
				var changedate:uint = sl.LoadDword();
				if (changedate == 0) break;

				n = new Object();
				n.m_ChangeDate = Number(1000)*Number(changedate);

				n.m_Type = sl.LoadInt();
				n.m_Flag=sl.LoadDword();
				n.m_RId=sl.LoadDword();
				n.m_Kind=sl.LoadDword();
				n.m_Cnt = sl.LoadInt();
				n.m_Lvl = sl.LoadDword();
				n.m_Race = sl.LoadDword();
				n.m_CotlId=sl.LoadDword();
				n.m_SecX=sl.LoadInt();
				n.m_SecY=sl.LoadInt();
				n.m_PlanetNum=sl.LoadInt();
				n.m_FFlag=sl.LoadDword();
				n.m_FRating=sl.LoadInt();
				n.m_FRank=sl.LoadInt();
				n.m_SFlag=sl.LoadDword();
				n.m_SRating=sl.LoadInt();
				n.m_SRank=sl.LoadInt();
				n.m_TFlag=sl.LoadDword();
				n.m_TRating=sl.LoadInt();
				n.m_TRank = sl.LoadInt();

				n.m_Dictor = sl.LoadDword();

				len = sl.LoadInt();
				if (len <= 0) n.m_TextId = "";
				else n.m_TextId = buf.readUTFBytes(len);

				len = sl.LoadInt();
				if (len <= 0) n.m_Val = "";
				else n.m_Val = buf.readUTFBytes(len);
//trace(n.m_Type,n.m_TextId);

				m_List.push(n);
			}

			sl.LoadEnd();
//		}

		m_List.sort(sortList);

		Prepare();
	}

	public function sortList(a:Object, b:Object):int
	{
		if (a.m_ChangeDate < b.m_ChangeDate) return 1;
		else if (a.m_ChangeDate > b.m_ChangeDate) return -1;
		else return 0;
	}
	
	public function FormatNews(n:Object, d:Object):String
	{
		var i:int,ibegin:int,iend:int,ch:int
		var name:String, str:String, s:String;
		var user:User;
		var union:Union;
		var cpt:Cpt;
		var objcd:Object;
		var ar:Array;

		var val_F:uint = 0;
		var val_FUnion:uint = 0;
		var val_S:uint = 0;
		var val_SUnion:uint = 0;
		var val_Price:int = 0;
		var val_Step:int = 0;
		var val_FList:Array = null;
		var val_SList:Array = null;
		var val_Id1:uint = 0;
		var val_Id2:uint = 0;
		var val_Id3:uint = 0;
		var val_Exp:uint = 0;
		var val_Period:int = 0;

		var o:String = "";

		if (d == null) {
			if (n.m_Type == NewsTypeExport || n.m_Type == NewsTypeImport) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				if (((n.m_Flag & CotlMask) >> CotlShift) > 1) {
					if (n.m_Type == NewsTypeExport) d.TextList.push(Common.News.Export2);
					else d.TextList.push(Common.News.Import2);
				} else {
					if (n.m_Type == NewsTypeExport) d.TextList.push(Common.News.Export);
					else d.TextList.push(Common.News.Import);
				}

			} else if (n.m_Type == NewsTypeCombatStart || n.m_Type == NewsTypeDuelStart || n.m_Type == NewsTypeCombatEnd) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				if (n.m_Cnt > 1) {
					if ((n.m_Flag & 1) != 0) d.TextList.push(Common.News.CombatWinAtk2);
					else if ((n.m_Flag & 2) != 0) d.TextList.push(Common.News.CombatWinDef2);
					else if (n.m_Type == NewsTypeDuelStart) d.TextList.push(Common.News.DuelBegin2);
					else d.TextList.push(Common.News.CombatBegin2);
				} else {
					if ((n.m_Flag & 1) != 0) d.TextList.push(Common.News.CombatWinAtk);
					else if ((n.m_Flag & 2) != 0) d.TextList.push(Common.News.CombatWinDef);
					else if (n.m_Type == NewsTypeDuelStart) d.TextList.push(Common.News.DuelBegin);
					else d.TextList.push(Common.News.CombatBegin);
				}
			} else if (n.m_Type == NewsTypeDestroyFlagship) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				if (n.m_Cnt == 1) d.TextList.push(Common.News.DestroyFlagship1);
				else if (n.m_Cnt == 2) d.TextList.push(Common.News.DestroyFlagship2);
				else if (n.m_Cnt == 3) d.TextList.push(Common.News.DestroyFlagship3);
				
			} else if (n.m_Type == NewsTypeDestroyQuarkBase) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				d.TextList.push(Common.News.DestroyQuarkBase);

			} else if (n.m_Type == NewsTypeCotlCapture) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				d.TextList.push(Common.News.CotlCapture);
				
			} else if (n.m_Type == NewsTypeCotlCtrl) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				if (((n.m_SFlag & UnionMask) >> UnionShift) == 0) d.TextList.push(Common.News.CotlCtrl);
				else d.TextList.push(Common.News.CotlCtrl2);
				
			} else if (n.m_Type == NewsTypeCotlPrepare) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				d.TextList.push(Common.News.CotlPrepare);
				
			} else if (n.m_Type == NewsTypeCotlReady) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				d.TextList.push(Common.News.CotlReady);
				
			} else if (n.m_Type == NewsTypeHomeworldCapture) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				d.TextList.push(Common.News.HomeworldCapture);

			} else if (n.m_Type == NewsTypeInvasion) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				d.TextList.push(Common.News.Invasion);

			} else if (n.m_Type == NewsTypeBattle) {
				d = new Object();
				d.Type = n.m_Type;
				d.TextList = new Array();
				if(((n.m_Flag & CotlMask) >> CotlShift)==CotlUser) d.TextList.push(Common.News.Battle2);
				else d.TextList.push(Common.News.Battle);
			}
		}
		
		if (d == null) return o;

		//o = d.TextList.join("\n");
		for (i = 0; i < d.TextList.length; i++) {
			o += "[p]" + d.TextList[i] + "[/p]\n";
		}

		var src:String = n.m_Val;
		var len:int = src.length;
		var off:int = 0;

		while (off < len) {
			while(off<len) { ch=src.charCodeAt(off); if(ch==32 || ch==9 || ch==13 || ch==10) off++; else break; }
			if(off>=len) break;

			ch=src.charCodeAt(off);
			if(ch==0x2f) { // /
				off++; if(off>=len) break;
				if(src.charCodeAt(off)!=0x2f) continue;

				while (off < len) { ch = src.charCodeAt(off); if (ch != 10 && ch != 13) off++; else break; }
			} else { // Par or Text
				ibegin = off;
				var par:Boolean = true;
				if(par) {
					while (ibegin < len) {
						ch = src.charCodeAt(ibegin);
						ibegin++;
						if (ch == 61) break;
						else if (ch == 32 || ch == 9 || ch==10) { par = false; break;  }
					}
					if (ibegin >= len) par = false;
				}

				if (par) {
					name = src.substring(off, ibegin-1);
					off = ibegin;

					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend = off;

					if(iend>ibegin) {
						str = src.substring(ibegin, iend);

						if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FList")) {
							ar = str.split(",");
							if (ar.length > 0) {
								val_FList = new Array();
								for (i = 0; i < ar.length; i++) val_FList.push(int(ar[i]));
							}
						} else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SList")) {
							ar = str.split(",");
							if (ar.length > 0) {
								val_SList = new Array();
								for (i = 0; i < ar.length; i++) val_SList.push(int(ar[i]));
							}
						}
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Id1")) { val_Id1 = int(str); n.Id1 = val_Id1; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Id2")) { val_Id2 = int(str); n.Id2 = val_Id2; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Id3")) { val_Id3 = int(str); n.Id3 = val_Id3; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Step")) { val_Step = int(str); n.Step = val_Step; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "FUnion")) { val_FUnion = int(str); n.FUnion = val_FUnion; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "F")) { val_F = int(str); n.F = val_F; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "SUnion")) { val_SUnion = int(str); n.SUnion = val_SUnion; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "S")) { val_S = int(str); n.S = val_S; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Price")) { val_Price = int(str); n.Price = val_Price; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Exp")) { val_Exp = int(str); n.Exp = val_Exp; }
						else if (BaseStr.IsTagEqNCEng(name, 0, name.length, "Period")) { val_Period = int(str); n.Period = val_Period; }

//						trace("Par {" +name + "=" + str + "}");
					}
				} else {
					ibegin=off;
					while(off<len) { ch=src.charCodeAt(off); if(ch!=10 && ch!=13) off++; else break; }
					iend=off;
				}
				
			}
		}
		
		if (n.m_Type == NewsTypeExport || 
			n.m_Type == NewsTypeImport ||
			n.m_Type == NewsTypeCombatStart ||
			n.m_Type == NewsTypeDuelStart ||
			n.m_Type == NewsTypeCombatEnd ||
			n.m_Type == NewsTypeDestroyFlagship ||
			n.m_Type == NewsTypeDestroyQuarkBase ||
			n.m_Type == NewsTypeCotlCapture ||
			n.m_Type == NewsTypeCotlCtrl ||
			n.m_Type == NewsTypeHomeworldCapture ||
			n.m_Type == NewsTypeInvasion ||
			n.m_Type == NewsTypeBattle) 
		{
			user = UserList.Self.GetUser(val_F);
			if (user == null) return null;
			else o = BaseStr.Replace(o, "<F>", "[clr]" + EM.Txt_CotlOwnerName(0, user.m_Id) + "[/clr]");

			if (val_FUnion == 0) {
				s = "";
				if (d.FUnionNone != undefined) s = BaseStr.Replace(d.FUnionNone, "<Name>", s);
				o = BaseStr.Replace(o, "(<FUnion>)", s);
				o = BaseStr.Replace(o, "<FUnion>", s);
			} else {
				union = UserList.Self.GetUnion(val_FUnion);
				if (union == null) return null;
				else {
					s = "[clr]" + union.m_Name + "[/clr]";
					if (union.m_Type == Common.UnionTypeAlliance && d.FUnionAlliance != undefined) s = BaseStr.Replace(d.FUnionAlliance, "<Name>", s);
					else if (union.m_Type == Common.UnionTypePirate && d.FUnionPirate != undefined) s = BaseStr.Replace(d.FUnionPirate, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeClan && d.FUnionClan != undefined) s = BaseStr.Replace(d.FUnionClan, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeMercenary && d.FUnionMercenary != undefined) s = BaseStr.Replace(d.FUnionMercenary, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeTrader && d.FUnionTrader != undefined) s = BaseStr.Replace(d.FUnionTrader, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeEmpire && d.FUnionEmpire != undefined) s = BaseStr.Replace(d.FUnionEmpire, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeRepublic && d.FUnionRepublic != undefined) s = BaseStr.Replace(d.FUnionRepublic, "<Name>", s);
					
					o = BaseStr.Replace(o, "<FUnion>", s);
				}
			}

			o = BaseStr.Replace(o, "<FRating>", "[clr]" + BaseStr.FormatBigInt(n.m_FRating) + "[/clr]");
			o = BaseStr.Replace(o, "<FRank>", "[clr]" + BaseStr.FormatBigInt(n.m_FRank) + "[/clr]");
		}

		if (n.m_Type == NewsTypeCombatStart ||
			n.m_Type == NewsTypeDuelStart ||
			n.m_Type == NewsTypeCombatEnd ||
			n.m_Type == NewsTypeDestroyFlagship ||
			n.m_Type == NewsTypeDestroyQuarkBase ||
			n.m_Type == NewsTypeCotlCtrl ||
			n.m_Type == NewsTypeHomeworldCapture ||
			n.m_Type == NewsTypeInvasion ||
			n.m_Type == NewsTypeBattle)
		{
			if(n.m_Type != NewsTypeCotlCtrl) {
				user = UserList.Self.GetUser(val_S);
				if (user == null) return null;
				else o = BaseStr.Replace(o, "<S>", "[clr]" + EM.Txt_CotlOwnerName(0, user.m_Id) + "[/clr]");
			}

			if (val_SUnion == 0) {
				s = "";
				if (d.FUnionNone != undefined) s = BaseStr.Replace(d.FUnionNone, "<Name>", s);
				o = BaseStr.Replace(o, "(<SUnion>)", s);
				o = BaseStr.Replace(o, "<SUnion>", s);
			} else {
				union = UserList.Self.GetUnion(val_SUnion);
				if (union == null) return null;
				else {
					s = "[clr]" + union.m_Name + "[/clr]";
					if (union.m_Type == Common.UnionTypeAlliance && d.SUnionAlliance != undefined) s = BaseStr.Replace(d.SUnionAlliance, "<Name>", s);
					else if (union.m_Type == Common.UnionTypePirate && d.SUnionPirate != undefined) s = BaseStr.Replace(d.SUnionPirate, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeClan && d.SUnionClan != undefined) s = BaseStr.Replace(d.SUnionClan, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeMercenary && d.SUnionMercenary != undefined) s = BaseStr.Replace(d.SUnionMercenary, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeTrader && d.SUnionTrader != undefined) s = BaseStr.Replace(d.SUnionTrader, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeEmpire && d.SUnionEmpire != undefined) s = BaseStr.Replace(d.SUnionEmpire, "<Name>", s);
					else if (union.m_Type == Common.UnionTypeRepublic && d.SUnionRepublic != undefined) s = BaseStr.Replace(d.SUnionRepublic, "<Name>", s);
					
					o = BaseStr.Replace(o, "<SUnion>", s);
				}
			}

			o = BaseStr.Replace(o, "<SRating>", "[clr]" + BaseStr.FormatBigInt(n.m_SRating) + "[/clr]");
			o = BaseStr.Replace(o, "<SRank>", "[clr]" + BaseStr.FormatBigInt(n.m_SRank) + "[/clr]");
		}

		if (n.m_Type == NewsTypeCombatStart || n.m_Type == NewsTypeDuelStart || n.m_Type == NewsTypeCombatEnd) {
			if (val_FList == null || val_FList.length <= 0) {
				s = "";
				o = BaseStr.Replace(o, "(<FList>)", s);
				o = BaseStr.Replace(o, "<FList>", s);
			} else {
				s = "";
				for (i = 0; i < val_FList.length; i++) {
					user = UserList.Self.GetUser(val_FList[i]);
					if (user == null) return null;
					if (s.length > 0) s += ", ";
					s += "[clr]" + EM.Txt_CotlOwnerName(0, user.m_Id) + "[/clr]";
				}
				o = BaseStr.Replace(o, "<FList>", s);
			}
		}

		if (n.m_Type == NewsTypeCombatStart || n.m_Type == NewsTypeDuelStart || n.m_Type == NewsTypeCombatEnd) {
			if (val_SList == null || val_SList.length <= 0) {
				s = "";
				o = BaseStr.Replace(o, "(<SList>)", s);
				o = BaseStr.Replace(o, "<SList>", s);
			} else {
				s = "";
				for (i = 0; i < val_SList.length; i++) {
					user = UserList.Self.GetUser(val_SList[i]);
					if (user == null) return null;
					if (s.length > 0) s += ", ";
					s += "[clr]" + EM.Txt_CotlOwnerName(0, user.m_Id) + "[/clr]";
				}
				o = BaseStr.Replace(o, "<SList>", s);
			}
		}

		if (n.m_Type == NewsTypeDestroyFlagship) {
			user = UserList.Self.GetUser(val_S);
			if (user == null) return null;

			if (val_Id1 != 0) {
				if (user.m_Id == Server.Self.m_UserId) {
					objcd=EM.m_FormCptBar.CptDsc(val_Id1);
					if(objcd==null) return null
					s = "[clr]" + objcd.Name + "[/clr]";
				} else {
					cpt = user.GetCpt(val_Id1);
					if (cpt == null) return null;
					if (cpt.m_Name == null) return null;
					s = "[clr]" + cpt.m_Name + "[/clr]";
				}

				o = BaseStr.Replace(o, "<Name1>", s);
			}
			if(val_Id2!=0) {
				if (user.m_Id == Server.Self.m_UserId) {
					objcd=EM.m_FormCptBar.CptDsc(val_Id2);
					if(objcd==null) return null
					s = "[clr]" + objcd.Name + "[/clr]";
				} else {
					cpt = user.GetCpt(val_Id2);
					if (cpt == null) return null;
					if (cpt.m_Name == null) return null;
					s = "[clr]" + cpt.m_Name + "[/clr]";
				}

				o = BaseStr.Replace(o, "<Name2>", s);
			}
			if(val_Id3!=0) {
				if (user.m_Id == Server.Self.m_UserId) {
					objcd=EM.m_FormCptBar.CptDsc(val_Id3);
					if(objcd==null) return null
					s = "[clr]" + objcd.Name + "[/clr]";
				} else {
					cpt = user.GetCpt(val_Id3);
					if (cpt == null) return null;
					if (cpt.m_Name == null) return null;
					s = "[clr]" + cpt.m_Name + "[/clr]";
				}

				o = BaseStr.Replace(o, "<Name3>", s);
			}
		}
		
		if (n.m_Type == NewsTypeDestroyFlagship) {
			if ((n.m_Lvl & 255) == 0) {
				s = "";
				o = BaseStr.Replace(o, "(<Lvl1>)", s);
				o = BaseStr.Replace(o, "<Lvl1>", s);
			} else {
				s = "[clr]" + (n.m_Lvl & 255).toString() + "[/clr]";
				o = BaseStr.Replace(o, "<Lvl1>", s);
			}
			if (((n.m_Lvl>>8) & 255) == 0) {
				s = "";
				o = BaseStr.Replace(o, "(<Lvl2>)", s);
				o = BaseStr.Replace(o, "<Lvl2>", s);
			} else {
				s = "[clr]" + ((n.m_Lvl>>8) & 255).toString() + "[/clr]";
				o = BaseStr.Replace(o, "<Lvl2>", s);
			}
			if (((n.m_Lvl>>16) & 255) == 0) {
				s = "";
				o = BaseStr.Replace(o, "(<Lvl3>)", s);
				o = BaseStr.Replace(o, "<Lvl3>", s);
			} else {
				s = "[clr]" + ((n.m_Lvl>>16) & 255).toString() + "[/clr]";
				o = BaseStr.Replace(o, "<Lvl3>", s);
			}
		}

		if (n.m_Type == NewsTypeImport ||
			n.m_Type == NewsTypeExport ||
			n.m_Type == NewsTypeDestroyFlagship ||
			n.m_Type == NewsTypeDestroyQuarkBase ||
			n.m_Type == NewsTypeCotlCapture ||
			n.m_Type == NewsTypeCotlCtrl ||
			n.m_Type == NewsTypeCotlPrepare ||
			n.m_Type == NewsTypeCotlReady ||
			n.m_Type == NewsTypeHomeworldCapture ||
			n.m_Type == NewsTypeBattle)
		{
			if (n.m_Flag & 1) {
				s = "";
				o = BaseStr.Replace(o, "(<Cotl>)", s);
				o = BaseStr.Replace(o, "<Cotl>", s);
			} else {
				var cotl:SpaceCotl = EM.HS.GetCotl(n.m_CotlId);
				if (cotl == null) {
					//EM.m_FormGalaxy.LoadCotlById(n.m_CotlId, true);
					return null;
				}
				
//				if (((n.m_Flag & CotlMask) >> CotlShift) == CotlUser) {
//					UserList.Self.GetUser(
//				}

				s = "[clr]" + EM.CotlName(n.m_CotlId) + "[/clr]";

				if (((n.m_Flag & CotlMask) >> CotlShift) == CotlUser && d.CotlUser != undefined) s = BaseStr.Replace(d.CotlUser, "<Name>", s);
				else if (((n.m_Flag & CotlMask) >> CotlShift) == CotlCombat && d.CotlCombat != undefined) s = BaseStr.Replace(d.CotlCombat, "<Name>", s);
				else if (((n.m_Flag & CotlMask) >> CotlShift) == CotlCommon && d.CotlCommon != undefined) s = BaseStr.Replace(d.CotlCommon, "<Name>", s);

				o = BaseStr.Replace(o, "<Cotl>", s);
			}
		}

		if (n.m_Type == NewsTypeExport || n.m_Type == NewsTypeImport) {
			o = BaseStr.Replace(o, "<Goods>", "[clr]" + Common.ChangeWordForNews(EM.ItemName(n.m_Kind),n.m_Cnt)/*.toLowerCase()*/ + "[/clr]");
			o = BaseStr.Replace(o, "<Cnt>", "[clr]" + BaseStr.FormatBigInt(n.m_Cnt) + "[/clr]");
			o = BaseStr.Replace(o, "<Price>", "[clr]" + BaseStr.FormatBigInt(val_Price) + "[/clr]");
			o = BaseStr.Replace(o, "<Step>", "[clr]" + BaseStr.FormatBigInt(val_Step) + "[/clr]");
		}

		if (n.m_Type == NewsTypeCotlCapture || n.m_Type == NewsTypeCotlCtrl || n.m_Type == NewsTypeCotlPrepare || n.m_Type == NewsTypeCotlReady || n.m_Type == NewsTypeHomeworldCapture) {
			o = BaseStr.Replace(o, "<Exp>", "[clr]" + BaseStr.FormatBigInt(val_Exp) + "[/clr]");
		}

		if (n.m_Type == NewsTypeCotlPrepare || n.m_Type == NewsTypeCotlReady) {
			o = BaseStr.Replace(o, "<Period>", "[clr]" + BaseStr.FormatBigInt(val_Period) + "[/clr]");
		}

		o = BaseStr.Replace(o, "  ", " ")
		o = BaseStr.Replace(o, " .", ".")
		o = BaseStr.Replace(o, " ,", ",")

		return BaseStr.FormatTag(o);
	}
}

}
