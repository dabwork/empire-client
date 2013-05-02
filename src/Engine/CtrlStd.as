package Engine
{
import flash.display.*;
import flash.events.*;
	
public class CtrlStd extends Sprite
{
	public function CtrlStd():void
	{
//		addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
//		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}
	
/*	public function onAddToStage(e:Event):void
	{
		var p:DisplayObject = parent;
		while (p != null && !(p is CtrlPopupMenu) && !(p is FormStd)) p = p.parent;
		if (p) {
			p.addEventListener("beforeHide", onBeforeHide);
		}
	}

	public function onRemovedFromStage(e:Event):void
	{
		var p:DisplayObject = parent;
		while (p != null && !(p is CtrlPopupMenu) && !(p is FormStd)) p = p.parent;
		if (p) {
			p.removeEventListener("beforeHide", onBeforeHide);
		}
	}
	
	public function onBeforeHide(e:Event):void
	{
	}*/
	
	public function beforeHideOther(list:DisplayObjectContainer):void
	{
		var i:int;
		var d:DisplayObject;
		for (i = list.numChildren - 1; i >= 0; i--) {
			d = list.getChildAt(i);
			if (d is CtrlStd) CtrlStd(d).beforeHide();
			else if (d is DisplayObjectContainer) beforeHideOther(DisplayObjectContainer(d));
		}
	}
	
	public function beforeHide():void
	{
		var i:int;
		var d:DisplayObject;
		for (i = numChildren - 1; i >= 0; i--) {
			d = getChildAt(i);
			if (d is CtrlStd) CtrlStd(d).beforeHide();
			else if (d is DisplayObjectContainer) beforeHideOther(DisplayObjectContainer(d));
		}
	}
}
	
}