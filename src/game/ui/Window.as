package game.ui 
{
	import game.core.Position;
	import game.core.Size;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * /**
	 * ...
	 * @author Dmitriy Mihaylenko (dmitriy.mihaylichenko@gmail.com)
	 * 
	 */	 
	public class Window extends Component
	{
		
		public function Window(name:String, fileName:String) 
		{
			super(fileName);
			
			this.name = name;
		}
		
		// Добавить новый компонент
		public function addComponent(position:Position, name:String, component:Component):Component
		{			
			if (name) component.name = name;
			
			addChild(component);
			
			setChildIndex(component, this.numChildren - 1);
			
			component.position = position;
			
			return component;
		}
		
		// Удалить компонент
		public function removeComponent(component:Component):void
		{
			if (component && this.getComponentByName(component.name)) this.removeChild(component);
			
			component = null;
		}
		
		// Получить компонент по имени
		public function getComponentByName(name:String):Component
		{
			return Component(this.getChildByName(name));
		}
		
		// Скрыть компонент
		public function hideComponent(component:Component):void
		{
			if (component && component.visible) component.visible = false;
		}
		
		// Показать компонент
		public function showComponent(component:Component):void
		{
			if (component && !component.visible) component.visible = true;
		}
		
		// Скрыть окно
		public function hideWindow():void
		{
			if (this.visible) this.visible = false;
		}
		
		// Показать окно
		public function showWindow():void
		{
			if (!this.visible) this.visible = true;
		}
	}

}