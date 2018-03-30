package game.core 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Display extends Sprite 
	{		
		public var size:Size;		
		
		public function Display(parent:Sprite)
		{
			addEventListener(Event.ADDED_TO_STAGE, onCreate);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);			
			
			parent.addChild(this);			
		}		
		
		// Дисплей создан
		private function onCreate(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onCreate);
			//addEventListener(Event.ENTER_FRAME, onUpdate);	
			
			scaleX = stage.stageWidth / 800;
			scaleY = stage.stageHeight / 480;
		}		
		
		// Дисплей удален
		private function onDestroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			//removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		/*private function onUpdate(e:Event):void 
		{
			
		}*/
		
		public function setResolution(width:int, height:int):void
		{
			size = new Size(width, height);
		}
		
		public function getDisplayWidth():int
		{
			return size.width;
		}
		
		public function getDisplayHeight():int
		{
			return size.height;
		}
		
	}

}