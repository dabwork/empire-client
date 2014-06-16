/**
 * (C) Elemental Games
 * author: mod0
 */
package Empire {
	
	import Engine.Server;
	import Engine.C3D;
	import flash.net.SharedObject;
	import flash.events.TimerEvent; 
	import flash.utils.Timer;
	
	public class PreloadTimer
	{
		static private var tm: Timer = null;
		static private var timeout: Boolean = false;
        
        	static public function PreloadDone(): Boolean
        	{ 
			if (timeout) return true;
			if (tm == null)
			{
				tm = new Timer(100, 50);
				
				tm.addEventListener(TimerEvent.TIMER, onTick); 
				tm.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
				
				tm.start();
				
				var so:SharedObject = SharedObject.getLocal("EGEmpireData");
				var lng:int;
				if ( (so != null) && (so.data.lang != undefined) ) {
					lng = so.data.lang;
				} else {
					lng = Server.LANG_RUS;
				}
				Localization.Load(lng, 
					function():void{
						C3D.m_FatalError = "failed load localization";
					});
				return false;
			} else {
				if ( !Localization.IsWorking() &&
				     true ) {
					tm.stop();
					timeout = true;
					tm = null;
					return true;
				} else {
					return false;
				}
			}
		}
 
        	static public function onTick(event:TimerEvent):void 
		{ 
			EmpireMap.Self.init();
		}
		
		static public function onTimerComplete(event:TimerEvent):void 
		{
			timeout = true;
			EmpireMap.Self.init();
		}
	}
}
