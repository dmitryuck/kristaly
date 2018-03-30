package game.ui 
{	
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import game.core.*;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */
	public class Component extends Sprite 
	{
		private var _size:Size;
		private var _position:Position;		
		private var _scale:Number;
		
		public var fileName:String;
		
		public var source:Source;
		
		// Обьект отображения компонента
		public var displayObject:Image;
		
		private var loader:Loader;
		
		
		public function Component(fileName:String) 
		{			
			this.fileName = fileName;
			
			position = new Position();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);			
			
			source = new Source(fileName);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Добавление, удаление листенеров
		private function addListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onUpdate);			
			//addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function removeListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, onUpdate);			
			//removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// События связанные с обьектом
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			
			addEventListener(ComponentEvent.COMPONENT_LOADED, onCreate);
			
			if (fileName) loadDisplayObject(); else dispatchEvent(new ComponentEvent(ComponentEvent.COMPONENT_LOADED));
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		protected function onCreate(e:ComponentEvent):void
		{
			removeEventListener(ComponentEvent.COMPONENT_LOADED, onCreate);
			addListeners();
		}
		
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeListeners();
		}
		
		protected function onUpdate(e:Event):void
		{
			
		}
		import flash.system.ApplicationDomain;
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Отобразить обьект ресурса
		public function loadDisplayObject():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onDisplayObjectLoaded);
			
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContext.allowCodeImport = true;
			//loaderContext.allowLoadBytesCodeExecution = true;			
				
			loader.loadBytes(source.getSource(), loaderContext);
		}
		
		private function onDisplayObjectLoaded(e:flash.events.Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDisplayObjectLoaded);
			
			// Если тело меняет ресурс, то удалить тело и перерисовать новое
			if (displayObject) removeChild(displayObject);
			
			var dispObj:Bitmap = e.target.content as Bitmap;
			
			var bitmapData:BitmapData = new BitmapData(dispObj.width, dispObj.height, true, 0);
			bitmapData.draw(dispObj);
			
			var tex:Texture = Texture.fromBitmapData(bitmapData, false, false);
			
			displayObject = new Image(tex);
			addChildAt(displayObject, 0);
			
			dispatchEvent(new ComponentEvent(ComponentEvent.COMPONENT_LOADED));
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Установить новый ресурс отображения для обьекта displayObject
		public function setSource(fileName:String):void
		{
			if (source)
			{
				source.setSource(fileName);
			} else {
				source = new Source(fileName);	
			}
			
			this.fileName = fileName;
			
			loadDisplayObject();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Установка свойств компонента
		public function get position():Position 
		{
			_position.x = this.x;
			_position.y = this.y;
			
			return _position;
		}
		
		// Установка положения обьекта
		public function set position(value:Position):void 
		{
			this.x = value.x;
			this.y = value.y;
			
			_position = value;
		}
		
		// Размер компонента
		public function get size():Size 
		{
			_size.width = this.width;
			_size.height = this.height;
			
			return _size;
		}
		
		/*public function set size(value:Size):void 
		{
			this.width = value.width;
			this.height = value.height;
			
			_size = value;
		}*/
		
		// Скалирование компонента get
		public function get scale():Number 
		{			
			return this.scaleX;
		}
		
		// Скалирование компонента set
		public function set scale(value:Number):void 
		{			
			this.scaleX = this.scaleY = value;
		}		
	}

}