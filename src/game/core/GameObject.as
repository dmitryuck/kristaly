package game.core 
{	
	import com.flashdynamix.motion.Tweensy;
	import com.flashdynamix.motion.TweensySequence;
	import com.flashdynamix.motion.TweensyTimeline;
	
	import fl.motion.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	import game.utils.Geom;
	
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.DisplayObject;	
	import starling.display.MovieClip;	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */	
	public class GameObject extends Sprite
	{
		public var tag:String;	
		public var type:String;
		
		public var fileName:String;	
		
		private var _position:Position;
		private var _scale:Number;
		
		private var active:Boolean;
		private var _relativeCenter:Boolean;
		
		public var source:Source;		
		
		//public var animationController:Animator;
		public var tween:TweensySequence;
		//public var body:Body;
		
		// Обьект отображения текущего игрового обьекта
		public var displayObject:Image;
		
		private var loader:Loader;
		
		public var enabled:Boolean = true;
		
		public var onClick:Function;
		
		
		public function GameObject(fileName:String = "", name:String = "", tag:String = "") 
		{			
			this.type = "";
			this.fileName = fileName;
			this.name = name;
			this.tag = tag;
			
			position = new Position();			
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);			
			
			source = new Source(fileName);			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Установка свойств
		public function get scale():Number 
		{			
			return this.scaleX;
		}
		
		public function set scale(value:Number):void 
		{			
			this.scaleX = this.scaleY = value;
		}		
		
		// Изменение позиции обьекта
		public function get position():Position 
		{
			_position.x = this.x;
			_position.y = this.y;
			
			return _position;
		}
		
		public function set position(value:Position):void 
		{
			this.x = value.x;
			this.y = value.y;
			
			_position = value;			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Добавление, удаление листенеров
		private function addListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onUpdate);			
			addEventListener(TouchEvent.TOUCH, onObjectTouch);
		}
		
		private function removeListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, onUpdate);			
			removeEventListener(TouchEvent.TOUCH, onObjectTouch);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// События связанные с обьектом
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			
			addEventListener(ObjectEvent.OBJECT_LOADED, onCreate);
			
			if (fileName) loadDisplayObject(); else dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_LOADED));
		}
		
		protected function onCreate(e:ObjectEvent):void
		{
			removeEventListener(ObjectEvent.OBJECT_LOADED, onCreate);
			addListeners();
		}
		
		protected function onDestroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			removeListeners();
		}
		
		protected function onUpdate(e:Event):void {}
		
		protected function onObjectTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			
			if (touch != null)
			{
				if (touch.phase == TouchPhase.BEGAN) {}
				
				if (touch.phase == TouchPhase.ENDED)
				{			
					if (enabled)
					{
						var event:ObjectEvent = new ObjectEvent(ObjectEvent.OBJECT_CLICK);
						event.params.target = this;
						
						dispatchEvent(event);
						
						if(onClick != null)
						{
							onClick();		
						}
					}
				}
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Отобразить обьект ресурса
		public function loadDisplayObject():void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onDisplayObjectLoaded);
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onDisplayObjectProgress);
			
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContext.allowCodeImport = true;			
				
			loader.loadBytes(source.getSource(), loaderContext);
		}
		
		// Прцесс загрузки обьекта отображения
		/*private function onDisplayObjectProgress(e:ProgressEvent):void 
		{
			
		}*/
		
		private function onDisplayObjectLoaded(e:flash.events.Event):void
		{	
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDisplayObjectLoaded);
			
			// Если тело меняет ресурс, то удалить тело и перерисовать новое
			if (displayObject != null) removeChild(displayObject);
			
			var dispObj:Bitmap = e.target.content as Bitmap;

			var bitmapData:BitmapData = new BitmapData(dispObj.width, dispObj.height, true, 0);
			bitmapData.draw(dispObj);
			
			var tex:Texture = Texture.fromBitmapData(bitmapData, false, false);
			
			displayObject = new Image(tex);
			addChildAt(displayObject, 0);
			
			dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_LOADED));
		}
		
		public function setCenter():void
		{
			displayObject.x = displayObject.width / 2 * ( -1);
			displayObject.y = displayObject.height / 2 * ( -1);
		}
		
		public function setCorner():void
		{
			displayObject.x = 0;
			displayObject.y = 0;
		}			
		
		// Сделать обьект верхним
		public function sendToFront():void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Движение обьекта		
		public function moveTo(position:Position, duration:Number = 1, ease:Function = null, autoRotation:Boolean = true, onComplete:Function = null, ...nextPosition):void
		{			
			if (!tween) tween = new TweensySequence(); 
			else 
			{
				tween.dispose();
				tween = null;
				tween = new TweensySequence();
			}			
			
			if (nextPosition.length == 0) tween.push(this, { x:position.x, y:position.y, rotation:autoRotation ? Geom.rotateToPoint(this.rotation, this.position, position) : 0 }, duration, ease, 0, 0, null, onComplete);
			else
			{
				var rotation0:Number = autoRotation ? Geom.rotateToPoint(this.rotation, this.position, position) : 0;
				tween.push(this, { x:position.x, y:position.y, rotation:rotation0 }, duration, ease);
				
				var positionLength:int = nextPosition.length;
				
				var rotation:Array = new Array();
				
				for (var i:int = 0; i < positionLength; i++)
				{
					rotation[i] = autoRotation ? Geom.rotateToPoint(i == 0 ? rotation0 : rotation[i - 1], i > 0 ? nextPosition[i - 1] : position, nextPosition[i]) : 0;
					
					if (i < positionLength - 1)
					{
						tween.push(this, { x:nextPosition[i].x, y:nextPosition[i].y, rotation:rotation[i] }, duration, ease);				
					}
					else if (i == positionLength - 1)
					{
						tween.push(this, { x:nextPosition[i].x, y:nextPosition[i].y, rotation:rotation[i] }, duration, ease, 0, 0, null, onComplete);					
					}
				}
			}
			
			tween.start();
		}
		
		// Остановить движение обьекта
		public function stopMove():void
		{
			if (tween) tween.stop();
		}
		
		// Поставить на паузу движение
		public function pauseMove():void
		{
			if (tween) tween.pause();
		}
		
		// Продолжить преостановленное движение
		public function resumeMove():void
		{
			if (tween && tween.paused) tween.resume();
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
		// Child - добавление удаление, показ скрытие		
		public function addChildObject(position:Position,
														   type:Class = null,													   
													       fileName:String = "",													   
													       name:String = ""):GameObject
		{
			var child:GameObject = new (type ? type : GameObject)(fileName, name);			
			
			this.addChild(child);
			
			child.position = position;
			
			return child;
		}
		
		// Удалить дочерный обьект
		public function removeChildObject(child:GameObject):void
		{			
			child.parent.removeChild(child);
			
			child = null;
		}
		
		// Получить дочерный обьект по имени
		public function getChildObjectByName(name:String):GameObject
		{
			//if (!name) return null;			
			
			return GameObject(this.getChildByName(name));
		}
		
		// Показать дочерный обьект
		public function showChild(child:GameObject):void
		{
			if (child && !child.visible) child.visible = true;
		}
		
		// Спрятать дочерный обьект
		public function hideChild(child:GameObject):void
		{
			if (child && child.visible) child.visible = false;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Управление видимостью обьекта		
		public function showObject():void
		{
			if (displayObject && !displayObject.visible) displayObject.visible = true;
		}
		
		public function hideObject():void
		{
			if (displayObject && displayObject.visible) displayObject.visible = false;
		}		

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Активность игрового обьекта		
		// Активировать обьект
		public function activate():void
		{
			if (!isActive())
			{
				active = true;				
				loadDisplayObject();
				addListeners();
			}
		}
		
		// Деактивировать обьект
		public function deactivate():void
		{
			if (isActive())
			{
				active = false;
				
				removeListeners();				
				removeChildren();
				
				displayObject = null;
			}
		}		
		
		// Проверка активен ли обьект
		public function isActive():Boolean
		{
			return active;
		}
		
	}

}