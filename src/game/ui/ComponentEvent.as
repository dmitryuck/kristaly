package game.ui 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 * e-mail dmitriy.mihaylichenko@gmail.com
	 */
	public class ComponentEvent extends Event 
	{
		public static const COMPONENT_LOADED:String = "COMPONENT_LOADED";
		
		public function ComponentEvent(type:String) 
		{
			super(type);
		}
		
	}

}