package game.core
{	
	import adobe.utils.CustomActions;
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	
	import fl.motion.easing.Linear;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.utils.*;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import game.ui.*;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import user.*;

	/**
	 * ...
	 * @author Dmitriy Mihaylenko
	 * e-mail dmitriy.mihaylichenko@gmail.com
	 */	

	public class Game extends Sprite
	{
		// Архив игровых ресурсов
		[Embed(source = "/../assets/assets.zip",  mimeType="application/octet-stream")]
		public static var Assets:Class;
		
		//[Embed(source="C:\\arialuni.ttf", fontName="ArialUnicodeMS",  mimeType="application/x-font")]       
		//[Embed(source="C:\\WINDOWS\\Fonts\\Calibri.ttf", fontName="ArialUnicodeMS",  mimeType="application/x-font")]       
		//public static var ArialUnicodeMS:Class;
		
		// Embed classes
		/*Scene1, Scene2, Scene3, Scene4, Scene5, Scene6, Scene7, Scene8, Scene9, Scene10, Scene11, Scene12, Scene13, Scene14, Scene15;
		Scene16, Scene17, Scene18, Scene19, Scene20, Scene21, Scene22, Scene23, Scene24, Scene25;
		
		DialogCrab1, DialogCrab2, DialogSlizen1, DialogSlizen2, DialogSlizen3, DialogPopugay1, DialogPopugay2, DialogPopugay3;
		
		Fruit, Natty, Exit, Menu, Key, Grog, Banan, Karta, Slides;*/
		
		public static var assets:FZip;
		
		public static var ui:Ui;
		public static var display:Display;
		public static var scene:Scene;
		
		public var selObj1:GameObject;
		public var selObj2:GameObject;
		
		public var isObjectsActive:Boolean;
		
		public var objPref:String = "K_";
		
		public var dialogTextStyle:Object = { color:"#000000", fontFamily:"Arial", fontSize:"16", width:"190" };
		
		public var timeMin:int;
		public var timeSec:int;
		
		public var combinedObjects:Vector.<GameObject>;
		public var combMaxCount:int = 3;
		
		public var rowMaxCnt:int = 8;
		public var colMaxCnt:int = 8;
		
		public var figureSize:int = 48;
		
		public var startX:int = 320;
		public var startY:int = 80;
		
		public var startSteps:int = 10;
		public var startPoints:int = 0;
		
		private var _steps:int;
		private var _points:int;
	
		public var wandActive:Boolean;

		public var isPlaying:Boolean;
		
		public function Game()
		{
			assets = new FZip();
			assets.loadBytes(new Assets() as ByteArray);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage (e:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			scene = new Scene();
			scene.addEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
			
			ui = new Ui();
			
			display = new Display(this);
			
			display.addChild(scene);
			display.addChild(ui);
		}
		
		// Сцена загружена
		private function onSceneLoaded(e:SceneEvent):void
		{
			scene.removeEventListener(SceneEvent.SCENE_LOADED, onSceneLoaded);
			
			loadMenu();
		}
		
		// Загрузка игрового меню
		private function loadMenu():void
		{
			scene.destroyObject(scene.getObjectByName("bg"));
			
			scene.createObject(new Position(), null, "textures/menu_bg.jpg", "bg");

			Audio.playMusic("sounds/menu_music.mp3", true);
			
			var menuWnd:Window = Game.loadWindow(new Position(), "menu_wnd", null, "interface/menu_wnd.png");
			menuWnd.addComponent(new Position(368, 80), "btn_start", new Button("interface/btn_start_64.png", "interface/btn_start_64_down.png", onStartClick));
		
			function onStartClick():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				startGame();
			}
		}
		
		// Начало игры
		private function startGame():void
		{
			scene.destroyObject(scene.getObjectByName("bg"));
		
			scene.createObject(new Position(), null, "textures/game_bg.jpg", "bg");
			
			Game.destroyWindow(Game.findWindow("menu_wnd"));
			
			Audio.playMusic("sounds/game_music.mp3", true);
			
			var gameWnd:Window = Game.loadWindow(new Position(), "game_wnd", null);	
			
			var style:Object = { color:"#ffffff", fontFamily:"Arial", fontSize:"24", width:"150", height:"100" };
			gameWnd.addComponent(new Position(0, 0), "steps", new Text("Steps: " + startSteps.toString(), style));
			gameWnd.addComponent(new Position(0, 100), "points", new Text("Points: " + startPoints.toString(), style));
			
			steps = startSteps;
			
			isPlaying = true;
			
			genFigures();
		}
		
		public function remStep():void
		{
			steps --;
		}
		
		public function get steps():int
		{
			return _steps;
		}
		
		public function set steps(val:int):void
		{
			_steps = val;
			
			var gameWnd:Window = Game.findWindow("game_wnd");
			
			if (gameWnd != null)
			{			
				var stepText:Text = Text(gameWnd.getComponentByName("steps"));
				
				var stepsVal:String = (val >= 0 ? val.toString() : "0");
				
				if (stepText != null)
				{
					stepText.setText("Steps: " + stepsVal);
				}
			}
		}
		
		public function addPoints(val:int):void
		{
			points = points + val;
		}
		
		public function get points():int 
		{
			return _points;
		}
		
		public function set points(val:int):void
		{
			_points = val;
			
			var gameWnd:Window = Game.findWindow("game_wnd");
			
			if (gameWnd != null)
			{
				var stepText:Text = Text(gameWnd.getComponentByName("points"));
				
				if (stepText != null)
				{
					stepText.setText("Points: " + val.toString());
				}
			}
		}
		
		// Сгенерировать фигуры
		private function genFigures():void
		{			
			isObjectsActive = true;
			
			for (var r:int = 0; r < rowMaxCnt; r++) 
			{
				for (var c:int = 0; c < colMaxCnt; c++)
				{
					var fig:Number = Math.floor(Math.random() * 7);
					
					var obj:GameObject = scene.createObject(new Position(startX+(figureSize*c), startY+(figureSize*r)), null, "textures/kris_"+fig+".png", objPref+r+"_"+c, fig.toString());
					
					obj.addEventListener(ObjectEvent.OBJECT_CLICK, onFigureClick);
				}
			}
		}
		
		// Обработчик нажатия на кристалл
		private function onFigureClick(e:ObjectEvent):void
		{
			var targObj:GameObject = e.params.target as GameObject;
			
			if (isObjectsActive == true)
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				if (isObjectSelected(targObj))
				{							
					resetSelObjs();
				} else {
					selectObj(targObj);
					
					if (getSelectedCount() == 2)
					{
						if (isObjectsNearby())
						{
							isObjectsActive = false;
							
							Audio.playSound("sounds/obj_change_position.mp3");
							
							remStep();
							
							changeObjPos(onChangePosCompleted);							
						} else {
							resetSelObjs();
							
							selectObj(targObj);
						}
					}
				}
				
				function onChangePosCompleted():void
				{
					isObjectsActive = true;
					
					checkCombinedObjs(selObj1);
					checkCombinedObjs(selObj2);	

					resetSelObjs();
				}
			}			
		}
				
		// Уровень проигран
		public function gameEnd():void 
		{
			isPlaying = false;
			
			isObjectsActive = false;
			
			Game.destroyWindow(Game.findWindow("game_wnd"));
			
			Audio.playMusic("sounds/level_end.mp3");
			
			var completeWnd:Window = Game.loadWindow(new Position(), "game_end", null, "interface/level_end.png");						
			
			completeWnd.addComponent(new Position(336, 290), "btn_again", new Button("interface/btn_reset_128.png", "interface/btn_reset_128_down.png", onAgainClick));
			
			var style:Object = { color:"#ffffff", fontFamily:"Arial", fontSize:"48", width:"250", height:"150" };
			completeWnd.addComponent(new Position(280, 120), "txt_points", new Text("Points: " + points.toString(), style));
			
			_steps = startSteps;
			_points = startPoints;
			
			//completeWnd.addComponent(new Position(387, 216), "txt_step", new Text(usedSteps.toString(), txtStyle));
			
			/*var title:Object = { color:"#2E2F30", fontFamily:"Arial", fontSize:"24", width:"240" };
			
			completeWnd.addComponent(new Position(326, 104), "title", new Text("The End!", title));
			
			// Перейти в меню
			function onMenuClick():void
			{
				Audio.playSound("sounds/click.mp3");
				
				isObjectsActive = true;
				
				Game.destroyWindow(completeWnd);
				
				//Game.loadScene("scenes/menu.scn");				
			}*/
			
			// Играть снова
			function onAgainClick():void
			{
				Audio.playSound("sounds/btn_click.mp3");
				
				scene.emptyScene();
				
				isObjectsActive = true;
				
				Game.destroyWindow(Game.findWindow("game_end"));
				
				startGame();
			}	
		}
		
		// Проверка нет ли скомбинированных обьектов
		public function checkCombinedObjs(targObj:GameObject):void
		{
			if (!isPlaying) return;
			
			var objsToCheck:Vector.<GameObject> = new Vector.<GameObject>();
			
			var horizCombined:Vector.<GameObject> = getHorizCombined(targObj);
			var vertCombined:Vector.<GameObject> = getVertCombined(targObj);
			
			var isCombined:Boolean = isObjsCombined(horizCombined, vertCombined);
			
			var targRow:int = getObjRow(targObj.name);
			var targCol:int = getObjCol(targObj.name);
			
			if (isCombined == true)
			{
				isObjectsActive = false;
				
				Audio.playSound("sounds/kris_combined.mp3");
				
				var namesHorizArr:Array = new Array();
				var namesVertArr:Array = new Array();
				
				var namesLeaveArr:Array = new Array();
				var namesDownArr:Array = new Array();
				
				var downObjsCount:int = 0;
				
				var allCombObjs:Vector.<GameObject> = getCombinedObjs(targObj, horizCombined, vertCombined);
				
				for each (var currObj:GameObject in vertCombined)
				{
					namesVertArr.push(currObj.name);					
				}
				
				for each (var currObj:GameObject in horizCombined)
				{
					namesHorizArr.push(currObj.name);
				}
				
				for each (var currObj:GameObject in allCombObjs)
				{
					namesLeaveArr.push(currObj.name);
					
					currObj.name = "";
					
					currObj.moveTo(new Position(-figureSize, -figureSize), 0.5, null, true, onLeaveCompleted);
					
					setTimeout(destroy, 1000, currObj);
					
					function destroy(obj:GameObject):void
					{
						scene.destroyObject(obj);
					}
				}
				
				var vertLeaveCompl:Boolean = false;
				
				// Кристаллы покинули поле
				var objsLeaveCompleted:int = 0;				
				function onLeaveCompleted():void
				{
					objsLeaveCompleted ++;
					
					if (objsLeaveCompleted == allCombObjs.length)
					{
						Audio.playSound("sounds/point_add.mp3");
						
						addPoints(namesLeaveArr.length);
						
						for(var name:String in namesLeaveArr)
						{
							var row:int = getObjRow(namesLeaveArr[name]);
							var col:int = getObjCol(namesLeaveArr[name]);
							
							if(col != targCol)
							{
								for (var a:int = row-1; a >= 0; a--)
								{
									var currUpObj:GameObject = scene.getObjectByName(objPref + a + "_" + col);
										
									if (currUpObj != null)
									{									
										namesDownArr.push(currUpObj.name);
										
										downObjsCount ++;
										
										moveObjDown(currUpObj, 1, onDownCompleted);
										
										objsToCheck.push(currUpObj);
									}									
								}
							} else if (col == targCol)
							{
								if (vertCombined.length < combMaxCount-1)
								{
									for (var b:int = row-1; b >= 0; b--)
									{
										var currUpObj:GameObject = scene.getObjectByName(objPref + b + "_" + col);
											
										if (currUpObj != null)
										{									
											namesDownArr.push(currUpObj.name);
											
											downObjsCount ++;
											
											moveObjDown(currUpObj, 1, onDownCompleted);
											
											objsToCheck.push(currUpObj);
										}
									}
								} else if (vertCombined.length >= combMaxCount-1)
								{
									if (vertLeaveCompl == false)
									{
										vertLeaveCompl = true;
										
										var minRowVal:int = 10;
										
										for (var name:String in namesVertArr)
										{
											var row:int = getObjRow(namesVertArr[name]);
											var col:int = getObjCol(namesVertArr[name]);
											
											if (row < minRowVal) 
											{
												minRowVal = row;
											}
										}
										
										var slotsDownVert:int = vertCombined.length + 1;
										
										for (var c:int = minRowVal-1; c >= 0; c--)
										{
											var currUpObj:GameObject = scene.getObjectByName(objPref + c + "_" + col);
											
											if (currUpObj != null)
											{
												namesDownArr.push(currUpObj.name);
												
												downObjsCount ++;
												
												moveObjDown(currUpObj, slotsDownVert, onDownCompleted);
												
												objsToCheck.push(currUpObj);
											}
										}
									}
								}
							}
							
							if (downObjsCount == 0)
							{
								onDownCompleted();
							}							
						}
						
						var vertDownCompl:Boolean = false;
						var allDownCompl:Boolean = false;
						
						// Кристаллы опущены
						var objsDownCompl:int = 0;							
						function onDownCompleted():void
						{	
							if (namesDownArr.length > 0) objsDownCompl ++;
							//trace(objsDownCompl, downObjsCount);
							if (objsDownCompl == downObjsCount  && allDownCompl == false)
							{
								allDownCompl = true;
								
								Audio.playSound("sounds/obj_born.mp3");
								
								for (var name:String in namesLeaveArr)
								{
									var row:int = getObjRow(namesLeaveArr[name]);
									var col:int = getObjCol(namesLeaveArr[name]);
									
									if(col != targCol)
									{										
										var fig:Number = Math.floor(Math.random() * 7);
										
										var obj:GameObject = scene.createObject(new Position(startX+(figureSize*col), startY+(figureSize*0)), null, "textures/kris_"+fig+".png", objPref+(0)+"_"+col, fig.toString());
										
										obj.addEventListener(ObjectEvent.OBJECT_CLICK, onFigureClick);
										
										objsToCheck.push(obj);
									} else if (col == targCol)
									{
										if (vertDownCompl == false)
										{
											vertDownCompl = true;
											
											if (vertCombined.length < combMaxCount-1)
											{
												var fig:Number = Math.floor(Math.random() * 7);
												
												var obj:GameObject = scene.createObject(new Position(startX+(figureSize*col), startY+(figureSize*i)), null, "textures/kris_"+fig+".png", objPref+(i)+"_"+col, fig.toString());
												
												obj.addEventListener(ObjectEvent.OBJECT_CLICK, onFigureClick);
												
												objsToCheck.push(obj);
											} else if (vertCombined.length >= combMaxCount-1)
											{
												for (var i:int = 0; i < vertCombined.length+1; i++) 
												{
													var fig:Number = Math.floor(Math.random() * 7);
													
													var obj:GameObject = scene.createObject(new Position(startX+(figureSize*col), startY+(figureSize*i)), null, "textures/kris_"+fig+".png", objPref+(i)+"_"+col, fig.toString());
													
													obj.addEventListener(ObjectEvent.OBJECT_CLICK, onFigureClick);
													
													objsToCheck.push(obj);
												}
											}
										}
									}									
								}
								
								setTimeout(checkRecursCombined, 1000, objsToCheck);
								
								function checkRecursCombined(objsVec:Vector.<GameObject>):void
								{
									if (isObjectsActive == true)
									{
										for each (var currObj:GameObject in objsVec)
										{
											if (currObj != null)
											{
												checkCombinedObjs(currObj);
											}
										}										
									}
								}							
							}
						}
						
						isObjectsActive = true;
					}
				}
			}			
			
			if (isObjectsActive == true)
			{
				if (steps <= 0)
				{
					gameEnd();
				}
			}
		}
		
		// Массив скомбинированных обьектов
		public function getCombinedObjs(targObj:GameObject, horizCombObjs:Vector.<GameObject>, vertCombObjs:Vector.<GameObject>):Vector.<GameObject>
		{
			var combObjs:Vector.<GameObject> = new Vector.<GameObject>();
			
			var isCombined:Boolean = false;
			
			if (horizCombObjs.length >= combMaxCount-1)
			{				
				for each (var currObj:GameObject in horizCombObjs)
				{
					combObjs.push(currObj);
				}
				
				isCombined = true;
			}
			
			if (vertCombObjs.length >= combMaxCount-1)
			{
				for each (var currObj:GameObject in vertCombObjs)
				{
					combObjs.push(currObj);
				}
				
				isCombined = true;
			}
			
			if (isCombined == true)
			{
				combObjs.push(targObj);
			}
			
			return combObjs;
		}
		
		// Проверка комбинации по одному из направлений
		public function isObjsCombined(horizCombObjs:Vector.<GameObject>, vertCombObjs:Vector.<GameObject>):Boolean
		{			
			var isCombined:Boolean = false;
			
			if (horizCombObjs.length >= combMaxCount-1)
			{
				isCombined = true;
			}
			
			if (vertCombObjs.length >= combMaxCount-1)
			{				
				isCombined = true;
			}
			
			return isCombined;
		}
		
		// Проверка наличия одинаковых обьектов
		public function getHorizCombined(targObj:GameObject):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var horizCombObjs:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(targObj.name);
			var col:int = getObjCol(targObj.name);
			
			var tag:String = targObj.tag;
			
			combObjsTmp = getCombLeft(tag, row, col);
			if (combObjsTmp.length > 0)
			{
				for each (var currCombObj:GameObject in combObjsTmp)
				{
					horizCombObjs.push(currCombObj);
				}
			}
			
			combObjsTmp = getCombRight(tag, row, col);			
			if (combObjsTmp.length > 0)
			{
				for each (var currCombObj:GameObject in combObjsTmp)
				{
					horizCombObjs.push(currCombObj);
				}
			}
			
			return horizCombObjs;
		}
		
		// Проверка наличия одинаковых обьектов
		public function getVertCombined(targObj:GameObject):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();

			var vertCombObjs:Vector.<GameObject> = new Vector.<GameObject>();
			
			var row:int = getObjRow(targObj.name);
			var col:int = getObjCol(targObj.name);
			
			var tag:String = targObj.tag;
			
			combObjsTmp = getCombUp(tag, row, col);			
			if (combObjsTmp.length > 0)
			{
				for each (var currCombObj:GameObject in combObjsTmp)
				{
					vertCombObjs.push(currCombObj);
				}
			}
			
			combObjsTmp = getCombDown(tag, row, col);			
			if (combObjsTmp.length > 0)
			{
				for each (var currCombObj:GameObject in combObjsTmp)
				{
					vertCombObjs.push(currCombObj);
				}
			}
			
			return vertCombObjs;
		}
		
		// Скомбинированные влево
		public function getCombLeft(tag:String, row:int, col:int):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var ind:int = col-1;
			
			for (var i:int = col-1; i >= 0; i--)
			{
				var currObj:GameObject = scene.getObjectByName(objPref + row + "_" + i);
				
				if (currObj != null)
				{
					if (currObj.tag == tag)
					{
						if (i == ind)
						{
							ind --;							
							
							combObjsTmp.push(currObj);
						}
					}
				}
			}
			
			return combObjsTmp;
		}
		
		// Скомбинированные справа
		public function getCombRight(tag:String, row:int, col:int):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var ind:int = col+1;
			
			for (var i:int = col+1; i < rowMaxCnt; i++)
			{
				var currObj:GameObject = scene.getObjectByName(objPref + row + "_" + i);
				
				if (currObj != null)
				{
					if (currObj.tag == tag)					
					{
						if (i == ind)
						{
							ind ++;
							
							combObjsTmp.push(currObj);
						}
					}
				}
			}
			
			/*if (indCnt < combMaxCount)
			{
				for (var a:int = combObjsTmp.length-1; a >= 0; a--)
				{
					combObjsTmp.pop();
				}
			}*/
			
			return combObjsTmp;
		}
		
		// Скомбинированные сверху
		public function getCombUp(tag:String, row:int, col:int):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var ind:int = row-1;
			
			for (var i:int = row-1; i >= 0; i--)
			{
				var currObj:GameObject = scene.getObjectByName(objPref + i + "_" + col);
				
				if (currObj != null)
				{
					if (currObj.tag == tag)
					{
						if (i == ind)
						{
							ind --;
							
							combObjsTmp.push(currObj);
						}
					}
				}
			}
			
			return combObjsTmp;
		}
		
		//  Скомбинированные снизу
		public function getCombDown(tag:String, row:int, col:int):Vector.<GameObject>
		{
			var combObjsTmp:Vector.<GameObject> = new Vector.<GameObject>();
			
			var ind:int = row+1;
			
			for (var i:int = row+1; i < rowMaxCnt; i++)
			{
				var currObj:GameObject = scene.getObjectByName(objPref + i + "_" + col);
				
				if (currObj != null)
				{
					if (currObj.tag == tag)
					{
						if (i == ind)
						{
							ind ++;
							
							combObjsTmp.push(currObj);
						}
					}
				}
			}
			
			return combObjsTmp;
		}
		
		// Переместить обьект ниже
		public function moveObjDown(targObj:GameObject, slotsCount:int, onMoveCompleted:Function = null):void
		{
			var newPos:Position = new Position(targObj.position.x, targObj.position.y  + figureSize * slotsCount);
			
			var row:int = getObjRow(targObj.name);
			var col:int = getObjCol(targObj.name);
			
			targObj.name = objPref + (row+slotsCount).toString() + "_" + col;
			
			targObj.moveTo(newPos, 0.5, null, false, onMoveCompleted);			
		}
		
		// Поменять местами обьекты
		public function changeObjPos(completed:Function):void
		{
			if (!selObj1 || !selObj2) return;
			
			var objName1:String = selObj1 ? selObj1.name : "";
			var objName2:String = selObj2 ? selObj2.name : "";
			
			selObj2.name = objName1;
			selObj1.name = objName2;
			
			var obj2Position:Position = selObj2.position;
			var obj1Position:Position = selObj1.position;
			
			selObj2.moveTo(obj1Position, 0.5, null, false, completed);			
			selObj1.moveTo(obj2Position, 0.5, null, false, null);			
		}
		
		// Выделить обьект
		public function selectObj(obj:GameObject):void
		{
			selObj1 = selObj2;
			selObj2 = obj;
			
			obj.addChildObject(new Position(0, 0), null, "textures/ramka.png", "ramka");			
		}
		
		// Количество выделенных обьектов
		public function getSelectedCount():int
		{
			var selCnt:int = 0;
			
			if (selObj1 != null)
			{
				selCnt += 1;
			}
			
			if (selObj2 != null)
			{
				selCnt += 1;
			}
			
			return selCnt;
		}
				
		// Выделен ли обьект
		public function isObjectSelected(obj:GameObject):Boolean
		{
			var ramka:GameObject = obj.getChildObjectByName("ramka");
			
			if (ramka != null)
			{
				return true;
			}
			
			return false;
		}
		
		// Убрать выделение
		public function unSelectObject(obj:GameObject):void
		{
			var ramka:GameObject = obj.getChildObjectByName("ramka");
			
			if (ramka != null)
			{
				obj.removeChildObject(ramka);
			}
		}
		
		// Обнулить первый выделенный обьект
		public function resetSelObjs():void
		{	
			resetSelObj1();
			resetSelObj2();
		}
		
		// Снять выделение с первого обьекта
		public function resetSelObj1():void
		{
			if (selObj1 == null) return;
			
			var ramka:GameObject = selObj1.getChildObjectByName("ramka");
			
			if (selObj1 != null && ramka != null)
			{
				selObj1.removeChildObject(ramka);
				selObj1 = null;
			}			
		}
		
		// Снять выделение со второго обьекта
		public function resetSelObj2():void
		{
			if (selObj2 == null) return;
			
			var ramka:GameObject = selObj2.getChildObjectByName("ramka");
			
			if (selObj2 != null && ramka != null)
			{
				selObj2.removeChildObject(ramka);
				selObj2 = null;
			}			
		}
		
		// Первый выделенный обьект
		public function getSelObj1():GameObject
		{
			return selObj1 ? selObj1 : null;
		}
		
		// Второй выделенный обьект
		public function getSelObj2():GameObject
		{
			return selObj2 ? selObj2 : null;
		}
		
		// Находяться ли выделенные обьекты рядом
		public function isObjectsNearby():Boolean
		{			
			var objName1:String = selObj1 ? selObj1.name : "";
			var objName2:String = selObj2 ? selObj2.name : "";

			if (!objName1 || !objName2) return false;
			
			if (objName1 == getUpObj(objName2) ||
				objName1 == getDownObj(objName2) ||
				objName1 == getLeftObj(objName2) ||
				objName1 == getRightObj(objName2))
			{
				return true;
			}
			
			resetSelObj1();
			
			return false;
		}
		
		// Определение колонки, рядка в имени
		public function getRowColNumber(objName:String, numberType:String):int
		{
			if (objName.charAt(0) != objPref.charAt(0)) return 0;	
			
			function isCharNumb(char:String):Boolean
			{
				if (char.charAt(0) == "1" ||
					char.charAt(0) == "2" ||
					char.charAt(0) == "3" ||
					char.charAt(0) == "4" ||
					char.charAt(0) == "5" ||
					char.charAt(0) == "6" ||
					char.charAt(0) == "7" ||
					char.charAt(0) == "8" ||
					char.charAt(0) == "9" ||
					char.charAt(0) == "0")
				{
					return true;
				}
				
				return false;
			}
			
			var numb:int;
			
			for (var n:int = 0; n < objName.length; n++)
			{
				if (isCharNumb(objName.charAt(n)))
				{
					objName = objName.slice(objName.indexOf(objPref) + 2, objName.length);
					
					if (numberType == "row")
					{						
						if (isCharNumb(objName.charAt(1)))
						{
							numb = int(objName.slice(0, 2));
						} else numb = int(objName.slice(0, 1));
					} else if (numberType == "col")
					{
						objName = objName.slice(objName.indexOf("_") + 1, objName.length);
						
						if (isCharNumb(objName.charAt(1)))
						{
							numb = int(objName.slice(0, 2));
						} else numb = int(objName.slice(0, 1));
					}
					
					break;
				}
			}
			
			return numb;
		}
		
		// Взять выше
		public function getUpObj(objName:String):String
		{
			if (!objName) return "";
			
			var row:int = getObjRow(objName) - 1;
			var col:int = getObjCol(objName);
			
			// Если в крайнем положении соседняя равна null
			if (row < 0 || col < 0) return "";
			
			return String(objPref + row + "_" + col);
		}
		
		// Взять ниже
		public function getDownObj(objName:String):String
		{
			if (!objName) return "";			
			
			var row:int = getObjRow(objName) + 1;
			var col:int = getObjCol(objName);
			
			// Если в крайнем положении соседняя равна null
			if (row < 0 || col < 0) return "";
			
			return String(objPref + row + "_" + col);
		}
		
		// Взять левее
		public function getLeftObj(objName:String):String
		{
			if (!objName) return "";			
			
			var row:int = getObjRow(objName);
			var col:int = getObjCol(objName) - 1;
			
			// Если в крайнем положении соседняя равна null
			if (row < 0 || col < 0) return "";
			
			return String(objPref + row + "_" + col);
		}
		
		// Взять правее
		public function getRightObj(objName:String):String
		{	
			if (!objName) return "";
			
			var row:int = getObjRow(objName);
			var col:int = getObjCol(objName) + 1;
			
			// Если в крайнем положении соседняя равна null
			if (row < 0 || col < 0) return "";
			
			return String(objPref + row + "_" + col);
		}
		
		// Подсчет рядка
		public function getObjRow(objName:String):int
		{
			return getRowColNumber(objName, "row");
		}
		
		// Подсчет колонки
		public function getObjCol(objName:String):int
		{			
			return getRowColNumber(objName, "col");
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Загрузка окна
		public static function loadWindow(position:Position, name:String, type:Class = null, fileName:String = null):Window
		{
			var window:Window = new (type ? type : Window)(name, fileName);
			
			ui.addChild(window);
			
			window.position = position;
			
			return window;
		}
		
		// Найти окно по имени
		public static function findWindow(name:String):Window
		{
			return Window(ui.getChildByName(name));
		}
		
		// Удалить окно
		public static function destroyWindow(window:Window):void
		{
			ui.removeChild(window);
			
			window = null;
		}
		
		// Удалить все окна
		public static function destroyAllWindows():void
		{
			ui.removeChildren();
		}
		
		// Скрыть окно
		public static function hideWindow(window:Window):void
		{
			window.hideWindow();
		}
		
		// Показать окно
		public static function showWindow(window:Window):void
		{
			window.showWindow();
		}
	}	
}