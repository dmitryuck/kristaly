package user 
{
	import starling.events.Event;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.core.Game;
	import game.ui.ComponentEvent;	
	
	import game.ui.Window;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Interface extends Window 
	{
		public var timer:Timer;
		
		
		public function Interface(name:String, fileName:String) 
		{
			super(name, fileName);
			
			Game.timeMin = 0;
			Game.timeSec = 0;
		}
		
		override protected function onCreate(e:ComponentEvent):void 
		{
			super.onCreate(e);
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		public function onTimer(e:TimerEvent):void
		{
			Game.timeSec ++;
			
			if (Game.timeSec >= 60)
			{
				Game.timeSec = 0;
				Game.timeMin ++;
			}
		}
		
		override protected function onDestroy(e:Event):void 
		{
			super.onDestroy(e);
			
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
		}
	}

}