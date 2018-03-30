package game.core 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 * e-mail dmitriy.mihaylichenko@gmail.com
	 */
	public class ObjectEvent extends Event 
	{
		public static const OBJECT_LOADED:String = "OBJECT_LOADED";
		public static const OBJECT_CLICK:String = "OBJECT_CLICK";
		
		public var params:Object = {};
		
		public function ObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
		/*public function clone():Event 
		{ 
			return new ObjectEvent(type, bubbles, cancelable);
		}*/
	}
}