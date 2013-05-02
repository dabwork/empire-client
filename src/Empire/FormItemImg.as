// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{
	import Base.*;
	import Engine.*;
	import fl.containers.*;
	import fl.controls.*;
	import fl.controls.dataGridClasses.*;
	import fl.events.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class FormItemImg extends Sprite
	{
		private var m_Map:EmpireMap;
		
		static public const SizeX:int=550;
		static public const SizeY:int=400;

		static public const ScollViewSizeX:int=SizeX-40;
		static public const ScollViewSizeY:int=SizeY-80;
		
		public var m_ContentSizeY:int=0;
		
		public var m_LabelCaption:TextField=null;
		public var m_ButClose:Button=null;
		public var m_ButChange:Button=null;
		public var m_LayerImgScroll:Sprite=null;
		public var m_LayerImg:Sprite=null;
		public var m_ScrollBar:UIScrollBar=null;
		
		public var m_CurSprite:Sprite=null;
		
		public var m_CurNo:int=0;
		
		public function FormItemImg(map:EmpireMap)
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
			m_LabelCaption.text=Common.TxtEdit.FormItemImgCpation;
			addChild(m_LabelCaption);
			
			m_ButClose=new Button();
			m_ButClose.label = Common.Txt.ButClose;
			m_ButClose.width=100;
			Common.UIStdBut(m_ButClose);
			m_ButClose.addEventListener(MouseEvent.CLICK, clickClose);
			m_ButClose.x=SizeX-10-m_ButClose.width;
			m_ButClose.y=SizeY-10-m_ButClose.height;
			addChild(m_ButClose);
			
			m_ButChange=new Button();
			m_ButChange.label = "Change";
			m_ButChange.width=100;
			Common.UIStdBut(m_ButChange);
			m_ButChange.addEventListener(MouseEvent.CLICK, clickChange);
			m_ButChange.x=m_ButClose.x-10-m_ButChange.width;
			m_ButChange.y=m_ButClose.y;
			addChild(m_ButChange);

			var m:Sprite=new Sprite();
			m.x=10;
			m.y=40;
			m.graphics.clear();
			m.graphics.beginFill(0xFF0000);
			m.graphics.drawRect(0, 0, ScollViewSizeX, ScollViewSizeY);
			m.graphics.endFill();
			addChild(m);
			
			m_LayerImgScroll=new Sprite();
			m_LayerImgScroll.mask=m;
			m_LayerImgScroll.x=10;
			m_LayerImgScroll.y=40;
			addChild(m_LayerImgScroll);
			
			m_LayerImg=new Sprite();
			//m_LayerImg.mask
			m_LayerImg.x=0;
			m_LayerImg.y=0;
			m_LayerImgScroll.addChild(m_LayerImg);
			//m_LayerImg.width=SizeX-20;
			//m_LayerImg.height=m_ButClose.y-m_LayerImg.y-10;
			
			m_ScrollBar=new UIScrollBar();
			m_ScrollBar.direction=ScrollBarDirection.VERTICAL;
			m_ScrollBar.x=m_LayerImgScroll.x+ScollViewSizeX;
			m_ScrollBar.y=m_LayerImgScroll.y;
			m_ScrollBar.height=ScollViewSizeY;
			Common.UIChatBar(m_ScrollBar);
			addChild(m_ScrollBar);
			
			m_ScrollBar.addEventListener(ScrollEvent.SCROLL,ScrollChange);
			
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			if(FormMessageBox.Self.visible) return;
			if(m_ButClose.hitTestPoint(e.stageX,e.stageY)) return;
			if(m_ScrollBar.hitTestPoint(e.stageX,e.stageY)) return;

			if((e.stageX-x)>=m_LayerImgScroll.x && (e.stageX-x)<(m_LayerImgScroll.x+ScollViewSizeX) &&
				(e.stageY-y)>=m_LayerImgScroll.y && (e.stageY-y)<(m_LayerImgScroll.y+ScollViewSizeY))
			{
				var mx:int=m_LayerImg.mouseX;
				var my:int=m_LayerImg.mouseY;
				
				if(my<FormCptBar.SlotSize) {
					m_CurNo=0;
					m_CurSprite.x=0;
					m_CurSprite.y=0;
				} else {
					var i:int;
					for(i=0;i<Common.ItemImgArray.length;i++) {
						var io:Object=Common.ItemImgArray[i];
					
						if(mx>=io.OffX && mx<io.OffX+FormCptBar.SlotSize && my>=io.OffY && my<io.OffY+FormCptBar.SlotSize) {
							m_CurNo=io.No;
							m_CurSprite.x=io.OffX;
							m_CurSprite.y=io.OffY;
							break;
						}
					}
				}
					
				return;
			}
			
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true,999);
		}
		
		protected function onMouseUpDrag(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpDrag,true);
			stopDrag();
		}
		
		public function Hide():void
		{
			ClearItem();
			visible=false;
		}
		
		public function clickClose(event:MouseEvent):void
		{
			ClearItem();
			Hide();
		}

		public function Show():void
		{
			visible=true;
			
			x=Math.ceil(m_Map.stage.stageWidth/2-SizeX/2);
			y=Math.ceil(m_Map.stage.stageHeight/2-SizeY/2);
			
			ClearItem();
			UpdateItem();
		}

		public function ClearItem():void
		{
			var i:int;
			for(i=m_LayerImg.numChildren-1;i>=0;i--) {
				var dobj:DisplayObject=m_LayerImg.getChildAt(i);
				
				m_LayerImg.removeChild(dobj);
			}
			m_CurSprite=null;
		}

		public function UpdateItem():void
		{
			var i:int;
			var sx:int=0;
			var sy:int=0;
			
			m_CurSprite=new Sprite();
			m_CurSprite.alpha=0.4;
			m_CurSprite.graphics.clear();
			m_CurSprite.graphics.beginFill(0xFF0000);
			m_CurSprite.graphics.drawRect(0, 0, FormCptBar.SlotSize, FormCptBar.SlotSize);
			m_CurSprite.graphics.endFill();
			m_LayerImg.addChild(m_CurSprite);
			
			sy+=FormCptBar.SlotSize;

			for(i=0;i<Common.ItemImgArray.length;i++) {
				var io:Object = Common.ItemImgArray[i];
				
				io.OffX=sx;
				io.OffY=sy;
				
				if(m_CurNo==io.No) {
					m_CurSprite.x=io.OffX;
					m_CurSprite.y=io.OffY;
				}

				var sp:Sprite=null;

				if(io.VecName!=null) sp=Common.ItemImg(io.No,false);

				if(sp!=null) {
					sp.y=sy+FormCptBar.SlotSize-20;
					sp.x=sx+20;
					m_LayerImg.addChild(sp);
				}

				sx+=FormCptBar.SlotSize;
				if(sx+FormCptBar.SlotSize>ScollViewSizeX) {
				//if(sx>FormCptBar.SlotSize) {
					sx=0;
					sy+=FormCptBar.SlotSize;
				}
			}

			m_ContentSizeY=sy+FormCptBar.SlotSize;

			sy=m_CurSprite.y-ScollViewSizeY+FormCptBar.SlotSize;
			if(sy<0) sy=0;
			m_ScrollBar.setScrollProperties(ScollViewSizeY,0,Math.max(0,m_ContentSizeY-ScollViewSizeY),FormCptBar.SlotSize);
			//m_ScrollBar.pageScrollSize=FormCptBar.SlotSize;
			//m_ScrollBar.pageSize=Math.floor(ScollViewSizeY/FormCptBar.SlotSize);
			m_ScrollBar.scrollPosition=sy;
			m_LayerImg.y=-sy;
		}

		public function ScrollChange(event:ScrollEvent):void
		{
			m_LayerImg.y=-m_ScrollBar.scrollPosition;
		}

		public function ChangeCur(no:int):void
		{
			var i:int;
			var sy:int;

			m_CurNo=no;
			if(m_CurNo==0) {
				m_CurSprite.x=0;
				m_CurSprite.y=0;
			} else {
				for(i=0;i<Common.ItemImgArray.length;i++) {
					var io:Object=Common.ItemImgArray[i];
					if(io.No==no) {
						m_CurSprite.x=io.OffX;
						m_CurSprite.y=io.OffY;
						
						sy=m_CurSprite.y-ScollViewSizeY+FormCptBar.SlotSize;
						if(sy<0) sy=0;
						m_ScrollBar.scrollPosition=sy;
						m_LayerImg.y=-sy;
	
						return;
					}
				}
			}

			m_ScrollBar.scrollPosition=0;
			m_LayerImg.y=0;
		}

		public function clickChange(event:MouseEvent):void
		{
			var it:Item=UserList.Self.GetItem(m_Map.m_FormItemManager.m_ItemList.selectedItem.Id);
			if(it==null) return;

			var boundary:String=Server.Self.CreateBoundary();

			var d:String="";
			
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"img\"\r\n\r\n";
			d+=m_CurNo.toString()+"\r\n";
			
			d+="--"+boundary+"\r\n";
			d+="Content-Disposition: form-data; name=\"itemid\"\r\n\r\n";
			d+=it.m_Id.toString()+"\r\n";
			
			d+="--"+boundary+"--\r\n";
			
			Server.Self.QueryPost("emitemop","&op=3",d,boundary,OpAnswer,false);
		}

		public function OpAnswer(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			
			var buf:ByteArray=loader.data;
			buf.endian=Endian.LITTLE_ENDIAN;
			
			if(m_Map.ErrorFromServer(buf.readUnsignedByte())) return;
		}
	}
}
