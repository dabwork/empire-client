package Engine {
	
	import Empire.Localization;
	import Empire.EmpireMap;
	
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
				tm = new Timer(300, 150);
				
				tm.addEventListener(TimerEvent.TIMER, onTick); 
				tm.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete); 
				
				tm.start();
				
				//Localization.LocalizationLoad( Server.Self.m_Lang );
				Localization.LocalizationLoad( Server.LANG_RUS );
				
				return false;
			} else {
				if ( CommonText.IsLoadingDone() &&
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
            //trace("tick " + event.target.currentCount); 
			EmpireMap.Self.init();
        } 
 
        static public function onTimerComplete(event:TimerEvent):void 
        { 
			timeout = true;
            EmpireMap.Self.init();
        } 
    } 
}