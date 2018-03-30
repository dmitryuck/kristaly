package game.core 
{	
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.*;
	import flash.utils.Timer;
	
	import game.ui.Window;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import user.*;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Scene extends Sprite
	{
		public var source:Source;

		private var _scale:Number;
		
		public var backLayer:Layer;
		public var gameLayer:Layer;
		public var frontLayer:Layer;		

		public var activeLayer:Layer;
		
		public var gameObjects:Vector.<GameObject>;
		
		public var fileName:String;
		
		public function Scene() 
		{			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);

			source = new Source();
			
			gameObjects = new Vector.<GameObject>;
			
			backLayer = new Layer();
			backLayer.name = "backLayer";
			
			gameLayer = new Layer();
			gameLayer.name = "gameLayer";
			
			frontLayer = new Layer();
			frontLayer.name = "frontLayer";
			
			addChild(backLayer);
			addChild(gameLayer);
			addChild(frontLayer);
			
			activeLayer = gameLayer;			
		}
		
		// Имя текущей сцены
		public function getCurrentScene():String
		{
			return name;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// События связанные со сценой
		private function onAddedToStage(e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
			
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_LOADED));
		}
		
		protected function onSceneLoaded(e:SceneEvent):void
		{  
			removeEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeEventListener(Event.ENTER_FRAME, onUpdate);
		}		
		
		protected function onUpdate(e:Event):void {}	
		
		// Установить активный слой
		public function setActiveLayer(layer:Layer):void
		{			
			activeLayer = layer;
		}
		
		public function getActiveLayer():Layer
		{
			return activeLayer;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Загрузка сцены, следующая, предидущая
		public function emptyScene():void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject)
				{
					destroyObject(gameObject);
					gameObject = null;
				}
			}			
			
			backLayer.removeChildren();
			gameLayer.removeChildren();
			frontLayer.removeChildren();			
		}		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Работа с обьектами
		public function createObject(position:Position,
									   type:Class = null,
									   fileName:String = null,
									   name:String = null,
									   tag:String = null):GameObject
		{			
			var gameObject:GameObject = new (type ? type : GameObject)(fileName, name, tag);			
		
			gameObjects.push(gameObject);
			
			activeLayer.addChild(gameObject);
			
			gameObject.position = position;
			
			return gameObject;
		}
		
		// Удаоение обьекта
		public function destroyObject(object:GameObject):void
		{
			if (object)
			{
				object.deactivate();
			
				var i:int = 0;
				
				for each(var currentObject:GameObject in gameObjects)
				{
					if (currentObject == object) 
					{
						gameObjects[i] = null;
						break;
					}
					i++;
				}
			
				object.parent.removeChild(object);

				object = null;
			}
		}
		
		// Удаление обьектов
		public function destroyObjects(...objects):void
		{
			if (objects[0] is Vector.<GameObject>)
			{
				for each (var objectInVector:GameObject in objects[0])
				{
					if (objectInVector) destroyObject(objectInVector);
				}
			} else
			if (objects[0] is GameObject) 
			{			
				for each (var object:GameObject in objects)
				{
					if (object) destroyObject(object);
				}
			}
		}
		
		// Получить обьект по имени
		public function getObjectByName(name:String):GameObject
		{
			if (!name) return null;
			
			for each(var currentObject:GameObject in gameObjects)
			{
				if (currentObject && currentObject.name == name) return currentObject;				
			}			
			
			return null;
		}
		
		// Получить обьект по тагу
		public function getObjectByTag(tag:String):GameObject
		{
			if (!tag) return null;
			
			for each(var currentObject:GameObject in gameObjects)
			{
				if (currentObject && currentObject.tag == tag) return currentObject;				
			}
			
			return null;
		}
		
		// Получить обьекты по тагу
		public function getTaggedObjects(tag:String):Vector.<GameObject>
		{
			if (!tag) return null;
			
			var vector:Vector.<GameObject> = new Vector.<GameObject>;
			
			for each (var currentObject:GameObject in gameObjects)
			{
				if (currentObject && currentObject.tag == tag) vector.push(currentObject);
			}
			
			if (vector.length > 0) return vector; else return null;
		}
		
		public function setResolution(width:int, height:int):void {}		
		
		public function get scale():Number 
		{
			return _scale;
		}
		
		public function set scale(value:Number):void 
		{
			_scale = value;
			this.scaleX = this.scaleY = value;
		}

	}

}