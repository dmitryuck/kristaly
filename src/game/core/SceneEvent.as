package game.core 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 * e-mail dmitriy.mihaylichenko@gmail.com
	 */
	public class SceneEvent extends Event 
	{
		public static const SCENE_LOADED:String = "SCENE_LOADED";
		//public static const SCENE_UNLOAD:String = "SCENE_UNLOAD";
		
		public function SceneEvent(type:String) 
		{
			super(type);
		}
		
	}

}