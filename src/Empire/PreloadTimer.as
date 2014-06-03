// (C) mod0
package Empire {
	
	import Engine.Server;
 
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
				
				//Localization.Load( Server.Self.m_Lang );
				Localization.Load( Server.LANG_RUS );
				
				return false;
			} else {
				if ( Localization.IsLoadingDone() &&
				     true )
				{
					tm.stop();
					timeout = true;
					tm = null;
					return true;
				} else
				{
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
