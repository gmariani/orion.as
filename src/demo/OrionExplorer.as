import cv.orion.Orion;
import cv.OrionBitmap;
import cv.OrionContainer;
import cv.OrionMouse;
import cv.orion.filters.*;
import cv.orion.interfaces.IFilter;
import cv.orion.output.*;
import cv.orion.presets.Default;
import cv.orion.renderers.*;

import demo.Circle;

import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.events.FlexEvent;
import mx.managers.CursorManager;

[Bindable]
public var strCode:String = "";

// Embed the cursor symbol.
[Embed(source="assets/picker.png")]
private var waitCursorSymbol:Class;

[Embed(source="assets/OrionExplorerAssets.swf", symbol="Arrow")]
[Bindable]
private var Arrow:Class;

[Embed(source="assets/OrionExplorerAssets.swf", symbol="Smoke")]
private var Smoke:Class;

[Embed(source="assets/OrionExplorerAssets.swf", symbol="Spark")]
private var Spark:Class;

[Embed(source="assets/OrionExplorerAssets.swf", symbol="Star")]
private var Star:Class;

[Embed(source="assets/OrionExplorerAssets.swf", symbol="Numbers")]
private var Numbers:Class;

[Embed(source="assets/OrionExplorerAssets.swf", symbol="Person")]
private var Person:Class;

[Bindable]
public var acOrion:ArrayCollection = new ArrayCollection(
    [ {label:"Orion", data:1}, 
      {label:"Orion Bitmap", data:2}, 
      {label:"Orion Container", data:3}, 
      {label:"Orion Mouse", data:4} ]);

[Bindable]
public var acPreset:ArrayCollection = new ArrayCollection(
    [ {label:"None", data:1}, 
      {label:"Snow", data:2}, 
      {label:"Smoke", data:3}, 
      {label:"Rain", data:4}, 
      {label:"Fountain", data:5}, 
      {label:"Fireworks", data:6}, 
      {label:"Explode", data:7}, 
      {label:"Collide", data:8},
      {label:"Sparkler", data:9},
      {label:"Dust", data:10} ]);

[Bindable]
public var acEdge:ArrayCollection = new ArrayCollection(
    [ {label:"None", data:1}, 
      {label:"Bounce", data:2}, 
      {label:"Wrap", data:3}, 
      {label:"Stop", data:4}]);

[Bindable]
public var acOutput:ArrayCollection = new ArrayCollection(
    [ {label:"None", data:1}, 
      {label:"Burst", data:2}, 
      {label:"Function", data:3}, 
      {label:"Key Down", data:4}, 
      {label:"Steady", data:5}, 
      {label:"Timed", data:6}]);

[Bindable]
public var acRender:ArrayCollection = new ArrayCollection(
    [ {label:"None", data:1}, 
      {label:"Bitmap", data:2}, 
      {label:"Pixel", data:3}]);

[Bindable]
public var acSettings:ArrayCollection = new ArrayCollection(
	[ {label:"None", data:1},
	  {label:"Set Value", data:2},
	  {label:"Range", data:3}]);

[Bindable]
public var acPixelSnapping:ArrayCollection = new ArrayCollection(
	[ {label:"Never", data:PixelSnapping.NEVER},
	  {label:"Always", data:PixelSnapping.ALWAYS},
	  {label:"Auto", data:PixelSnapping.AUTO}]);
	 
[Bindable]
public var acSprites:ArrayCollection = new ArrayCollection(
	[ {label:"Circle", data:Circle},
	  {label:"Smoke", data:Smoke},
	  {label:"Spark", data:Spark},
	  {label:"Star", data:Star},
	  {label:"Numbers", data:Numbers},
	  {label:"Arrow", data:Arrow}]);
	  
[Bindable]
public var version:String = "1.0.1 | Orion v" + Orion.VERSION;

private var o:Orion;
private var ob:OrionBitmap;
private var oc:OrionContainer;
private var om:OrionMouse;
private var currentOrion:Orion;
private var pickerBMP:BitmapData = new BitmapData(1, 1, false, 0);
private var efBounce:BounceEdgeFilter = new BounceEdgeFilter();
private var efWrap:WrapEdgeFilter = new WrapEdgeFilter();
private var efStop:StopEdgeFilter = new StopEdgeFilter();
private var opBurst:BurstOutput = new BurstOutput(20, false);
private var opFunction:FunctionOutput = new FunctionOutput(pulseFunc);
private var opKeyDown:KeyDownOutput;
private var opSteady:SteadyOutput = new SteadyOutput(20);
private var opTimed:TimedOutput = new TimedOutput(5000, 20);
private var intKey:uint = 65;
private var rndBitmap:BitmapRenderer = new BitmapRenderer();
private var rndPixel:PixelRenderer = new PixelRenderer();
private var ftrCollision:CollisionFilter = new CollisionFilter();
private var ftrColor:ColorFilter = new ColorFilter();
private var ftrDrag:DragFilter = new DragFilter();
private var ftrFade:FadeFilter = new FadeFilter();
private var ftrFrame:FrameFilter = new FrameFilter();
private var ftrGravity:GravityFilter = new GravityFilter();
private var ftrMouseGravity:MouseGravityFilter = new MouseGravityFilter();
private var ftrMouseSpring:MouseSpringFilter = new MouseSpringFilter();
private var ftrTurnToPath:TurnToPathFilter = new TurnToPathFilter();
private var ftrScale:ScaleFilter = new ScaleFilter();
private var ftrWander:WanderFilter = new WanderFilter();
private var ftrWind:WindFilter = new WindFilter();
private var obj:Object = new Object();
private var strPreset:String = "null";
// Define a variable to hold the cursor ID.
private var cursorID:Number = 0;
private var ftrGlow:GlowFilter = new GlowFilter(0xFF0000, .5);
private var ftrBlur:BlurFilter = new BlurFilter();

private var mcPerson:DisplayObject;

private function init(event:FlexEvent):void {
	opKeyDown = new KeyDownOutput(intKey, Application.application.stage, 20);
	
	o = new Orion(Circle);
	o.paused = true;
	o.mouseEnabled = false;
	o.mouseChildren = false;
	o.canvas = new Rectangle(100, 100, 100, 100);
	canOrion.rawChildren.addChild(o);
	
	ob = new OrionBitmap(Circle);
	ob.paused = true;
	ob.mouseEnabled = false;
	ob.mouseChildren = false;
	ob.target = car;
	ob.canvas = new Rectangle(100, 100, 100, 100);
	canOrionBitmap.rawChildren.addChild(ob);
	
	om = new OrionMouse(Circle);
	om.paused = true;
	om.mouseEnabled = false;
	om.mouseChildren = false;
	om.canvas = new Rectangle(100, 100, 100, 100);
	canOrionMouse.rawChildren.addChild(om);
	
	rndPixel.visible = false;
	rndBitmap.visible = false;
	
	// waits for components to init before adding Orion
	setTimeout(update, 100);
	
	// Fixes masking of ViewStack
	setTimeout(hdbViewer.moveDivider, 100, 0, -1);
	
	// waits for components to update again so presets are set correctly
	setTimeout(update, 200);
	
	this.invalidateSize();
}

public function checkColor(event:Event):void {
	pickerBMP.setPixel(0, 0, 0xFFFFFF); // enter background color of your SWF
	pickerBMP.draw(car, new Matrix(1, 0, 0, 1, -car.mouseX, -car.mouseY));
}

public function startDropper(event:Event):void {
	car.addEventListener(MouseEvent.MOUSE_MOVE, checkColor);
	car.addEventListener(MouseEvent.MOUSE_OVER, showCursor);
	car.addEventListener(MouseEvent.MOUSE_OUT, hideCursor);
}

public function stopDropper(event:Event):void {
	car.removeEventListener(MouseEvent.MOUSE_MOVE, checkColor);
	car.removeEventListener(MouseEvent.MOUSE_OVER, showCursor);
	car.removeEventListener(MouseEvent.MOUSE_OUT, hideCursor);
	ob.targetColor = cpColor.selectedColor = pickerBMP.getPixel(0, 0);
	CursorManager.removeAllCursors();
}

private function resetContainer():void {
	if(oc) canOrionContainer.rawChildren.removeChild(oc);
	if(mcPerson) canOrionContainer.rawChildren.removeChild(mcPerson);
	mcPerson = new Person() as DisplayObject;
	mcPerson.x = mcPerson.y = 100;
	canOrionContainer.rawChildren.addChild(mcPerson as DisplayObject);
	oc = new OrionContainer(mcPerson as DisplayObjectContainer);
	oc.canvas = new Rectangle(100, 100, 100, 100);
	canOrionContainer.rawChildren.addChildAt(oc, 0);
}

private function showCursor(event:Event):void {
	cursorID = CursorManager.setCursor(waitCursorSymbol, 2, 0, -16);
}

private function hideCursor(event:Event):void {
	CursorManager.removeAllCursors();
}

private function togglePausePlay(event:Event = null):void {
	currentOrion.paused = (tbbToggle.selectedIndex == 0);
}

private function applyPreset(event:Event):void {
	switch(cbPresets.selectedItem.label) {
		case "Snow" :
			obj = Default.snow();
			break;
		case "Smoke" :
			obj = Default.smoke();
			break;
		case "Rain" :
			obj = Default.rain();
			break;
		case "Fountain" :
			obj = Default.fountain();
			break;
		case "Fireworks" :
			obj = Default.firework();
			break;
		case "Explode" :
			obj = Default.explode();
			break;
		case "Dust" :
			obj = Default.dust();
			break;
		case "Collide" :
			obj = Default.collide();
			break;
		case "Sparkler" :
			obj = Default.sparkler();
		default :
			strPreset = "null";
	}
	
	update(true);
	
	obj = new Object();
	obj.settings = new Object();
	strPreset = "null";
}

private function update(fromApply:Boolean = false):void {	
	
	// Main
	var newOrion:Orion;
	var strClass:String = "";
	switch(cbOrion.selectedItem.label) {
		case "Orion Bitmap" :
			strClass = "OrionBitmap";
			strCode = "import cv.OrionBitmap;<br>";
			newOrion = ob;
			vsOrion.selectedChild = bitmapConfig;
			vsView.selectedChild = canOrionBitmap;
			break;
		case "Orion Container" :
			strClass = "OrionContainer";
			strCode = "import cv.OrionContainer;<br>";
			resetContainer();
			newOrion = oc;
			vsOrion.selectedChild = containConfig;
			vsView.selectedChild = canOrionContainer;
			break;
		case "Orion Mouse" :
			strClass = "OrionMouse";
			strCode = "import cv.OrionMouse;<br>";
			newOrion = om;
			vsOrion.selectedChild = mouseConfig;
			vsView.selectedChild = canOrionMouse;
			break;
		default :
			strClass = "Orion";
			strCode = "import cv.orion.Orion;<br>";
			newOrion = o;
			vsOrion.selectedChild = blankConfig;
			vsView.selectedChild = canOrion;
			break;
	}
	
	//if(fromApply) strCode += "import cv.orion.presets.Default;<br>";
	
	if(newOrion != currentOrion) {
		if(currentOrion) {
			currentOrion.pause();
			currentOrion.removeAllParticles();
		}
		currentOrion = newOrion;
	}
	
	// Disable if set to OrionContainer
	cbSprites.enabled = (currentOrion != oc);
	nsXPos.enabled = (currentOrion != oc); 
	nsYPos.enabled = (currentOrion != oc);
	nsWidth.enabled = (currentOrion != oc); 
	nsHeight.enabled = (currentOrion != oc); 
	
	currentOrion.useCacheAsBitmap = cbCacheBMP.selected;
	if(cbCacheFrame.selected != currentOrion.useFrameCaching) currentOrion.useFrameCaching = cbCacheFrame.selected;
	if(currentOrion.spriteClass != cbSprites.selectedItem.data) currentOrion.spriteClass = cbSprites.selectedItem.data;
	currentOrion.x = nsXPos.value;
	currentOrion.y = nsYPos.value;
	currentOrion.width = nsWidth.value;
	currentOrion.height = nsHeight.value;
	currentOrion.canvas.x = nsXPosCanvas.value;
	currentOrion.canvas.y = nsYPosCanvas.value;
	currentOrion.canvas.width = nsWidthCanvas.value;
	currentOrion.canvas.height = nsHeightCanvas.value;
	currentOrion.debug = cbDebug.selected;
	
	togglePausePlay();
	
	currentOrion.applyPreset(null, true);
	if(!obj.hasOwnProperty("settings")) obj.settings = new Object();
	
	// Settings
	var strSettings:String = "";
	// Life Span
	if(obj.settings.hasOwnProperty("lifeSpan")) nsLifeSpan.value = obj.settings.lifeSpan;
	currentOrion.settings.lifeSpan = nsLifeSpan.value;
	strSettings += "<br>o.settings.lifeSpan = " + String(currentOrion.settings.lifeSpan) + ";";
	
	// Mass
	if(obj.settings.hasOwnProperty("mass")) nsMass.value = obj.settings.mass;
	currentOrion.settings.mass = nsMass.value;
	strSettings += "<br>o.settings.mass = " + String(currentOrion.settings.mass) + ";";
	
	// Alpha
	if(obj.settings.hasOwnProperty("alphaMin") && obj.settings.hasOwnProperty("alphaMax")) {
		vsAlpha.selectedIndex = 2;
		nsInitAlphaMin.value = obj.settings.alphaMin;
		nsInitAlphaMax.value = obj.settings.alphaMax;
	} else if(obj.settings.hasOwnProperty("alpha")) {
		vsAlpha.selectedIndex = 1;
		nsInitAlpha.value = obj.settings.alpha;
	} else if(fromApply) {
		vsAlpha.selectedIndex = 0;
	}
	if(vsAlpha.selectedIndex == 2) {
		currentOrion.settings.alphaMin = nsInitAlphaMin.value;
		currentOrion.settings.alphaMax = nsInitAlphaMax.value;
		strSettings += "<br>o.settings.alphaMin = " + currentOrion.settings.alphaMin + ";";
		strSettings += "<br>o.settings.alphaMax = " + currentOrion.settings.alphaMax + ";";
	} else if(vsAlpha.selectedIndex == 1) {
		currentOrion.settings.alpha = nsInitAlpha.value;
		strSettings += "<br>o.settings.alpha = " + currentOrion.settings.alpha + ";";
	}
	
	// Velocity X
	if(obj.settings.hasOwnProperty("velocityXMin") && obj.settings.hasOwnProperty("velocityXMax")) {
		vsVelX.selectedIndex = 2;
		nsInitVelXMin.value = obj.settings.velocityXMin;
		nsInitVelXMax.value = obj.settings.velocityXMax;
	} else if(obj.settings.hasOwnProperty("velocityX")) {
		vsVelX.selectedIndex = 1;
		nsInitVelX.value = obj.settings.velocityX;
	} else if(fromApply) {
		vsVelX.selectedIndex = 0;
	}
	if(vsVelX.selectedIndex == 2) {
		currentOrion.settings.velocityXMin = nsInitVelXMin.value;
		currentOrion.settings.velocityXMax = nsInitVelXMax.value;
		strSettings += "<br>o.settings.velocityXMin = " + currentOrion.settings.velocityXMin + ";";
		strSettings += "<br>o.settings.velocityXMax = " + currentOrion.settings.velocityXMax + ";";
	} else if(vsVelX.selectedIndex == 1) {
		currentOrion.settings.velocityX = nsInitVelX.value;
		strSettings += "<br>o.settings.velocityX = " + currentOrion.settings.velocityX + ";";
	}
	
	// Velocity Y
	if(obj.settings.hasOwnProperty("velocityYMin") && obj.settings.hasOwnProperty("velocityYMax")) {
		vsVelY.selectedIndex = 2;
		nsInitVelYMin.value = obj.settings.velocityYMin;
		nsInitVelYMax.value = obj.settings.velocityYMax;
	} else if(obj.settings.hasOwnProperty("velocityY")) {
		vsVelY.selectedIndex = 1;
		nsInitVelY.value = obj.settings.velocityY;
	} else if(fromApply) {
		vsVelY.selectedIndex = 0;
	}
	if(vsVelY.selectedIndex == 2) {
		currentOrion.settings.velocityYMin = nsInitVelYMin.value;
		currentOrion.settings.velocityYMax = nsInitVelYMax.value;
		strSettings += "<br>o.settings.velocityYMin = " + currentOrion.settings.velocityYMin + ";";
		strSettings += "<br>o.settings.velocityYMax = " + currentOrion.settings.velocityYMax + ";";
	} else if(vsVelY.selectedIndex == 1) {
		currentOrion.settings.velocityY = nsInitVelY.value;
		strSettings += "<br>o.settings.velocityY = " + currentOrion.settings.velocityY + ";";
	}
	
	// Velocity Rotate
	if(obj.settings.hasOwnProperty("velocityRotateMin") && obj.settings.hasOwnProperty("velocityRotateMax")) {
		vsVelR.selectedIndex = 2;
		nsInitVelRMin.value = obj.settings.velocityRotateMin;
		nsInitVelRMax.value = obj.settings.velocityRotateMax;
	} else if(obj.settings.hasOwnProperty("velocityRotate")) {
		vsVelR.selectedIndex = 1;
		nsInitVelR.value = obj.settings.velocityRotate;
	} else if(fromApply) {
		vsVelR.selectedIndex = 0;
	}
	if(vsVelR.selectedIndex == 2) {
		currentOrion.settings.velocityRotateMin = nsInitVelRMin.value;
		currentOrion.settings.velocityRotateMax = nsInitVelRMax.value;
		strSettings += "<br>o.settings.velocityRotateMin = " + currentOrion.settings.velocityRotateMin + ";";
		strSettings += "<br>o.settings.velocityRotateMax = " + currentOrion.settings.velocityRotateMax + ";";
	} else if(vsVelR.selectedIndex == 1) {
		currentOrion.settings.velocityRotate = nsInitVelR.value;
		strSettings += "<br>o.settings.velocityRotate = " + currentOrion.settings.velocityRotate + ";";
	}
	
	// Velocity Angle
	if(obj.settings.hasOwnProperty("velocityAngleMin") && obj.settings.hasOwnProperty("velocityAngleMax")) {
		vsVelA.selectedIndex = 2;
		nsInitVelAMin.value = obj.settings.velocityAngleMin;
		nsInitVelAMax.value = obj.settings.velocityAngleMax;
	} else if(obj.settings.hasOwnProperty("velocityAngle")) {
		vsVelA.selectedIndex = 1;
		nsInitVelA.value = obj.settings.velocityAngle;
	} else if(fromApply) {
		vsVelA.selectedIndex = 0;
	}
	if(vsVelA.selectedIndex == 2) {
		currentOrion.settings.velocityAngleMin = nsInitVelAMin.value;
		currentOrion.settings.velocityAngleMax = nsInitVelAMax.value;
		strSettings += "<br>o.settings.velocityAngleMin = " + currentOrion.settings.velocityAngleMin + ";";
		strSettings += "<br>o.settings.velocityAngleMax = " + currentOrion.settings.velocityAngleMax + ";";
	} else if(vsVelA.selectedIndex == 1) {
		currentOrion.settings.velocityAngle = nsInitVelA.value;
		strSettings += "<br>o.settings.velocityAngle = " + currentOrion.settings.velocityAngle + ";";
	}
	
	// Rotation
	if(obj.settings.hasOwnProperty("rotateMin") && obj.settings.hasOwnProperty("rotateMax")) {
		vsRotation.selectedIndex = 2;
		nsInitRotateMin.value = obj.settings.rotateMin;
		nsInitRotateMax.value = obj.settings.rotateMax;
	} else if(obj.settings.hasOwnProperty("rotate")) {
		vsRotation.selectedIndex = 1;
		nsInitRotate.value = obj.settings.rotate;
	} else if(fromApply) {
		vsRotation.selectedIndex = 0;
	}
	if(vsRotation.selectedIndex == 2) {
		currentOrion.settings.rotateMin = nsInitRotateMin.value;
		currentOrion.settings.rotateMax = nsInitRotateMax.value;
		strSettings += "<br>o.settings.rotateMin = " + currentOrion.settings.rotateMin + ";";
		strSettings += "<br>o.settings.rotateMax = " + currentOrion.settings.rotateMax + ";";
	} else if(vsRotation.selectedIndex == 1) {
		currentOrion.settings.rotate = nsInitRotate.value;
		strSettings += "<br>o.settings.rotate = " + currentOrion.settings.rotate + ";";
	}
	
	// Scale
	if(obj.settings.hasOwnProperty("scaleMin") && obj.settings.hasOwnProperty("scaleMax")) {
		vsScale.selectedIndex = 2;
		nsInitScaleMin.value = obj.settings.scaleMin;
		nsInitScaleMax.value = obj.settings.scaleMax;
	} else if(obj.settings.hasOwnProperty("scale")) {
		vsScale.selectedIndex = 1;
		nsInitScale.value = obj.settings.scale;
	} else if(fromApply) {
		vsScale.selectedIndex = 0;
	}
	if(vsScale.selectedIndex == 2) {
		currentOrion.settings.scaleMin = nsInitScaleMin.value;
		currentOrion.settings.scaleMax = nsInitScaleMax.value;
		strSettings += "<br>o.settings.scaleMin = " + currentOrion.settings.scaleMin + ";";
		strSettings += "<br>o.settings.scaleMax = " + currentOrion.settings.scaleMax + ";";
	} else if(vsScale.selectedIndex == 1) {
		currentOrion.settings.scale = nsInitScale.value;
		strSettings += "<br>o.settings.scale = " + currentOrion.settings.scale + ";";
	}
	
	// Color
	if(obj.settings.hasOwnProperty("colorMin") && obj.settings.hasOwnProperty("colorMax")) {
		vsColor.selectedIndex = 2;
		cpInitColorMin.selectedColor = obj.settings.colorMin;
		cpInitColorMax.selectedColor = obj.settings.colorMax;
	} else if(obj.settings.hasOwnProperty("color")) {
		vsColor.selectedIndex = 1;
		cpInitColor.selectedColor = obj.settings.color;
	} else if(fromApply) {
		vsColor.selectedIndex = 0;
	}
	if(vsColor.selectedIndex == 2) {
		currentOrion.settings.colorMin = cpInitColorMin.selectedColor;
		currentOrion.settings.colorMax = cpInitColorMax.selectedColor;
		strSettings += "<br>o.settings.colorMin = " + currentOrion.settings.colorMin + ";";
		strSettings += "<br>o.settings.colorMax = " + currentOrion.settings.colorMax + ";";
	} else if(vsColor.selectedIndex == 1) {
		currentOrion.settings.color = cpInitColor.selectedColor;
		strSettings += "<br>o.settings.color = " + currentOrion.settings.color + ";";
	}
	
	// Random Frame
	if(obj.settings.hasOwnProperty("selectRandomFrame")) {
		cbRandomFrame.selected = obj.settings.selectRandomFrame;
	} else if(fromApply) {
		cbRandomFrame.selected = false;
	}
	if(cbRandomFrame.selected) {
		currentOrion.settings.selectRandomFrame = true;
		strSettings += "<br>o.settings.selectRandomFrame = true;";
	}
	
	// Filters
	var strFilters:String = "<br>o.effectFilters = [";
	// Collision Filter
	var f:IFilter = findEffect(obj.effectFilters, CollisionFilter);
	if(f) {
		cbCollision.selected = true;
	} else if(fromApply) {
		cbCollision.selected = false;
	}
	if(cbCollision.selected) {
		currentOrion.effectFilters.push(ftrCollision);
		strFilters += "new CollisionFilter(), ";
	}
	
	// Color Filter
	f = findEffect(obj.effectFilters, ColorFilter);
	if(f) {
		cbColorFilter.selected = true;
		cpColorFilter.selectedColor = ColorFilter(f).color;
	} else if(fromApply) {
		cbColorFilter.selected = false;
	}
	if(cbColorFilter.selected) {
		ftrColor.color = cpColorFilter.selectedColor;
		currentOrion.effectFilters.push(ftrColor);
		strFilters += "new ColorFilter(0x" + ftrColor.color.toString(16).toUpperCase() + "), ";
	}
	hbColor.visible = cbColorFilter.selected;
	
	// Drag Filter
	f = findEffect(obj.effectFilters, DragFilter);
	if(f) {
		cbDragFilter.selected = true;
		nsDragFilter.value = DragFilter(f).friction;
	} else if(fromApply) {
		cbDragFilter.selected = false;
	}
	if(cbDragFilter.selected) {
		ftrDrag.friction = nsDragFilter.value;
		currentOrion.effectFilters.push(ftrDrag);
		strFilters += "new DragFilter(" + ftrDrag.friction + "), ";
	}
	hbDrag.visible = cbDragFilter.selected;
	
	// Fade Filter
	f = findEffect(obj.effectFilters, FadeFilter);
	if(f) {
		cbFadeFilter.selected = true;
		nsFadeFilter.value = FadeFilter(f).value;
	} else if(fromApply) {
		cbFadeFilter.selected = false;
	}
	if(cbFadeFilter.selected) {
		ftrFade.value = nsFadeFilter.value;
		currentOrion.effectFilters.push(ftrFade);
		strFilters += "new FadeFilter(" + ftrFade.value + "), ";
	}
	hbFade.visible = cbFadeFilter.selected;
	
	// Frame Filter
	f = findEffect(obj.effectFilters, FrameFilter);
	if(f) {
		cbFrameFitler.selected = true;
		cbFrameLoop.selected = FrameFilter(f).loop;
	} else if(fromApply) {
		cbFrameFitler.selected = false;
	}
	if(cbFrameFitler.selected) {
		ftrFrame.loop = cbFrameLoop.selected;
		currentOrion.effectFilters.push(ftrFrame);
		strFilters += "new FrameFilter(" + ftrFrame.loop + "), ";
	}
	hbFrame.visible = cbFadeFilter.selected;
	
	// Gravity Filter
	f = findEffect(obj.effectFilters, GravityFilter);
	if(f) {
		cbGravityFilter.selected = true;
		nsGravityFilter.value = GravityFilter(f).value;
	} else if(fromApply) {
		cbGravityFilter.selected = false;
	}
	if(cbGravityFilter.selected) {
		ftrGravity.value = nsGravityFilter.value;
		currentOrion.effectFilters.push(ftrGravity);
		strFilters += "new GravityFilter(" + ftrGravity.value + "), ";
	}
	hbGravity.visible = cbGravityFilter.selected;
	
	// Mouse Gravity Filter
	f = findEffect(obj.effectFilters, MouseGravityFilter);
	if(f) {
		cbMouseGravityFilter.selected = true;
		nsMouseGravity.value = MouseGravityFilter(f).mass;
	} else if(fromApply) {
		cbMouseGravityFilter.selected = false;
	}
	if(cbMouseGravityFilter.selected) {
		ftrMouseGravity.mass = nsMouseGravity.value;
		currentOrion.effectFilters.push(ftrMouseGravity);
		strFilters += "new MouseGravityFilter(" + ftrMouseGravity.mass + "), ";
	}
	hbMouseGravity.visible = cbMouseGravityFilter.selected;
	
	// Mouse Spring Filter
	f = findEffect(obj.effectFilters, MouseSpringFilter);
	if(f) {
		cbMouseSpringFilter.selected = true;
		nsMouseSpring.value = MouseSpringFilter(f).springStrength;
		nsMouseDist.value = MouseSpringFilter(f).minDist;
	} else if(fromApply) {
		cbMouseSpringFilter.selected = false;
	}
	if(cbMouseSpringFilter.selected) {
		ftrMouseSpring.springStrength = nsMouseSpring.value;
		ftrMouseSpring.minDist = nsMouseDist.value;
		currentOrion.effectFilters.push(ftrMouseSpring);
		strFilters += "new MouseSpringFilter(" + ftrMouseSpring.springStrength + ", " + ftrMouseSpring.minDist + "), ";
	}
	hbMouseSpring1.visible = hbMouseSpring2.visible = cbMouseSpringFilter.selected;
	
	// Scale Filter
	f = findEffect(obj.effectFilters, ScaleFilter);
	if(f) {
		cbScaleFilter.selected = true;
		nsScale.value = ScaleFilter(f).value;
	} else if(fromApply) {
		cbScaleFilter.selected = false;
	}
	if(cbScaleFilter.selected) {
		ftrScale.value = nsScale.value;
		currentOrion.effectFilters.push(ftrScale);
		strFilters += "new ScaleFilter(" + ftrScale.value + "), ";
	}
	hbScale.visible = cbScaleFilter.selected;
	
	// Turn To Path Filter
	f = findEffect(obj.effectFilters, TurnToPathFilter);
	if(f) {
		cbTurnFilter.selected = true;
	} else if(fromApply) {
		cbTurnFilter.selected = false;
	}
	if(cbTurnFilter.selected) {
		currentOrion.effectFilters.push(ftrTurnToPath);
		strFilters += "new TurnToPathFilter(), ";
	}
	
	// Wander Filter
	f = findEffect(obj.effectFilters, WanderFilter);
	if(f) {
		cbWanderFilter.selected = true;
		nsWander.value = WanderFilter(f).value;
		nsWanderFriction.value = WanderFilter(f).friction;
	} else if(fromApply) {
		cbWanderFilter.selected = false;
	}
	if(cbWanderFilter.selected) {
		ftrWander.value = nsWander.value;
		ftrWander.friction = nsWanderFriction.value;
		currentOrion.effectFilters.push(ftrWander);
		strFilters += "new WanderFilter(" + ftrWander.value + ", " + ftrWander.friction + "), ";
	}
	hbWander1.visible = hbWander2.visible = cbWanderFilter.selected;
	
	// Wind Filter
	f = findEffect(obj.effectFilters, WindFilter);
	if(f) {
		cbWindFilter.selected = true;
		nsWind.value = WindFilter(f).value;
	} else if(fromApply) {
		cbWindFilter.selected = false;
	}
	if(cbWindFilter.selected) {
		ftrWind.value = nsWind.value;
		currentOrion.effectFilters.push(ftrWind);
		strFilters += "new WindFilter(" + ftrWind.value + "), ";
	}
	hbWind.visible = cbWindFilter.selected;
	
	if(strFilters.substr(-2, 2) == ", ") {
		strFilters = strFilters.substr(0, strFilters.length - 2);
		strFilters += "];";
	} else {
		strFilters = "";
	}
	
	// Edge
	if(obj.hasOwnProperty("edgeFilter")) {
		if(obj.edgeFilter is BounceEdgeFilter) {
			nsBounce.value = BounceEdgeFilter(obj.edgeFilter).value;
			cbEdge.selectedIndex = 1;
		} else if(obj.edgeFilter is WrapEdgeFilter) {
			cbEdge.selectedIndex = 2;
		} else if(obj.edgeFilter is StopEdgeFilter) {
			cbEdge.selectedIndex = 3;
		} else {
			cbEdge.selectedIndex = 0;
		}
	}
	switch(cbEdge.selectedItem.label) {
		case "Bounce" :
			strCode += "import cv.orion.filters.BounceEdgeFilter;<br>";
			efBounce.value = nsBounce.value;
			currentOrion.edgeFilter = efBounce;
			vsEdge.selectedChild = bounceConfig;
			strSettings += "<br>o.edgeFilter = new BounceEdgeFilter();"; 
			break;
		case "Wrap" :
			strCode += "import cv.orion.filters.WrapEdgeFilter;<br>";
			currentOrion.edgeFilter = efWrap;
			vsEdge.selectedChild = blankConfig2;
			strSettings += "<br>o.edgeFilter = new WrapEdgeFilter();";
			break;
		case "Stop" :
			strCode += "import cv.orion.filters.StopEdgeFilter;<br>";
			currentOrion.edgeFilter = efStop;
			vsEdge.selectedChild = blankConfig2;
			strSettings += "<br>o.edgeFilter = new StopEdgeFilter();";
			break;
		default :
			currentOrion.edgeFilter = null;
			vsEdge.selectedChild = blankConfig2;
	}
	
	// Output
	var strOutput:String;
	switch(cbOutput.selectedItem.label) {
		case "Burst" :
			strCode += "import cv.orion.output.BurstOutput;<br>";
			opBurst.continous = cbContinous.selected;
			opBurst.particles = nsParticles.value;
			currentOrion.output = opBurst;
			vsOutput.selectedChild = burstConfig;
			strOutput = "new BurstOutput(" + opBurst.particles + ", " + opBurst.continous +")";
			break;
		case "Function" :
			strCode += "import cv.orion.output.FunctionOutput;<br>";
			currentOrion.output = opFunction;
			vsOutput.selectedChild = functionConfig;
			strOutput = "new FunctionOutput(pulseFunc)";
			break;
		case "Key Down" :
			strCode += "import cv.orion.output.KeyDownOutput;<br>";
			opKeyDown.particlesPerSecond = nsKeyPPS.value;
			opKeyDown.key = intKey;
			currentOrion.output = opKeyDown;
			vsOutput.selectedChild = keydownConfig;
			strOutput = "new KeyDownOutput(" + opKeyDown.key + ", this.stage, " + opKeyDown.particlesPerSecond + ")";
			break;
		case "Steady" :
			strCode += "import cv.orion.output.SteadyOutput;<br>";
			opSteady.particlesPerSecond = nsSteadyPPS.value;
			currentOrion.output = opSteady;
			vsOutput.selectedChild = steadyConfig;
			strOutput = "new SteadyOutput(" + opSteady.particlesPerSecond + ")";
			break;
		case "Timed" :
			strCode += "import cv.orion.output.TimedOutput;<br>";
			opTimed.duration = nsDuration.value;
			opTimed.particlesPerSecond = nsTimedPPS.value;
			currentOrion.output = opTimed;
			vsOutput.selectedChild = timedConfig;
			strOutput = "new TimedOutput(" + opTimed.duration + ", " + opTimed.particlesPerSecond + ")";
			break;
		default :
			strOutput = "null";
			currentOrion.output = null;
			vsOutput.selectedChild = blankConfig3;
	}
	
	// Renderer
	switch(cbRender.selectedItem.label) {
		case "Bitmap" :
			strCode += "import cv.orion.renderers.BitmapRenderer;<br><br>var bmpRdr:BitmapRenderer = new BitmapRenderer();<br>";
			rndBitmap.visible = true;
			rndBitmap.pixelSnapping = ddBmpPixelSnap.selectedItem.data;
			if(rndBitmap.pixelSnapping != PixelSnapping.AUTO) strCode += "bmpRdr.pixelSnapping = '" + rndBitmap.pixelSnapping + "';<br>";
			rndBitmap.smoothing = cbBmpSmoothing.selected;
			if(rndBitmap.smoothing) strCode += "bmpRdr.smoothing = " + cbBmpSmoothing.selected + ";<br>";
			rndBitmap.preFilters = new Array();
			if(cbBmpBlur.selected) {
				if(rndBitmap.smoothing) strCode += "bmpRdr.preFilters.push(new flash.filters.BlurFilter());<br>";
				rndBitmap.preFilters.push(ftrBlur);
			}
			if(cbBmpGlow.selected) {
				if(rndBitmap.smoothing) strCode += "bmpRdr.preFilters.push(new flash.filters.GlowFilter(0xFF0000, .5));<br>";
				rndBitmap.preFilters.push(ftrGlow);
			}
			strCode += "bmpRdr.drawTargets = [o];<br>";
			strCode += "this.addChild(bmpRdr);<br><br>";
			rndBitmap.drawTargets = [currentOrion];
			vsRender.selectedChild = bitmapRenderConfig;
			rndPixel.drawTargets = new Array();
			rndPixel.visible = false;
			
			if(rndPixel.parent) Canvas(rndPixel.parent).rawChildren.removeChild(rndPixel);
			Canvas(currentOrion.parent).rawChildren.addChild(rndBitmap);
			currentOrion.visible = false;
			break;
		case "Pixel" :
			strCode += "import cv.orion.renderers.PixelRenderer;<br><br>var pxlRdr:PixelRenderer = new PixelRenderer();<br>";
			rndPixel.visible = true;
			rndPixel.pixelSnapping = ddBmpPixelSnap.selectedItem.data;
			if(rndPixel.pixelSnapping != PixelSnapping.AUTO) strCode += "pxlRdr.pixelSnapping = '" + rndPixel.pixelSnapping + "';<br>";
			rndPixel.smoothing = cbBmpSmoothing.selected;
			if(rndPixel.smoothing) strCode += "pxlRdr.smoothing = " + cbBmpSmoothing.selected + ";<br>";
			rndPixel.preFilters = new Array();
			if(cbBmpBlur.selected) {
				if(rndPixel.smoothing) strCode += "pxlRdr.preFilters.push(new flash.filters.BlurFilter());<br>";
				rndPixel.preFilters.push(ftrBlur);
			}
			if(cbBmpGlow.selected) {
				if(rndPixel.smoothing) strCode += "pxlRdr.preFilters.push(new flash.filters.GlowFilter(0xFF0000, .5));<br>";
				rndPixel.preFilters.push(ftrGlow);
			}
			strCode += "pxlRdr.drawTargets = [o];<br>";
			strCode += "this.addChild(pxlRdr);<br><br>";
			rndPixel.drawTargets = [currentOrion];
			vsRender.selectedChild = bitmapRenderConfig;
			rndBitmap.drawTargets = new Array();
			rndBitmap.visible = false;
			
			if(rndBitmap.parent) Canvas(rndBitmap.parent).rawChildren.removeChild(rndBitmap);
			Canvas(currentOrion.parent).rawChildren.addChild(rndPixel);
			currentOrion.visible = false;
			break;
		default :
			rndPixel.drawTargets = new Array();
			rndBitmap.drawTargets = new Array();
			rndPixel.visible = false;
			rndBitmap.visible = false;
			if(rndPixel.parent) Canvas(rndPixel.parent).rawChildren.removeChild(rndPixel);
			if(rndBitmap.parent) Canvas(rndBitmap.parent).rawChildren.removeChild(rndBitmap);
			vsRender.selectedChild = blankConfig4;
			currentOrion.visible = true;
	}
	
	if(currentOrion == oc) {
		strCode += "// mcPerson is the name of the movieclip on the stage<br>var o:" + strClass + " = new " + strClass + "(mcPerson, " + strOutput + ", " + strPreset + ");";
	} else {
		strCode += "var o:" + strClass + " = new " + strClass + "(" + cbSprites.selectedLabel + ", " + strOutput + ", " + strPreset + ", " + String(currentOrion.useFrameCaching) + ");";
	}
	strCode += "<br>o.canvas = new Rectangle(" + nsXPosCanvas.value + ", " + nsYPosCanvas.value + ", " + nsWidthCanvas.value + ", " + nsHeightCanvas.value + ");";
	strCode += strFilters;
	if(cbCacheBMP.selected) strSettings += "<br>o.useCacheAsBitmap = " + cbCacheBMP.selected;
	strSettings += "<br>o.x = " + nsXPos.value + ";";
	strSettings += "<br>o.y = " + nsYPos.value + ";";
	strSettings += "<br>o.width = " + nsWidth.value + ";";
	strSettings += "<br>o.height = " + nsHeight.value + ";";
	if(currentOrion == oc) {
		oc.applySettings();
		togglePausePlay();
		strSettings += "<br>o.applySettings();";
		strSettings += "<br>o.paused = false;";
	}
	strSettings += "<br>this.addChild(o);";
	if(currentOrion.output == opFunction) {
		strSettings += "<br><br>private function pulseFunc(startTime:uint, currentTime:uint):Boolean {";
		strSettings += "<br>\tvar modT:uint = (currentTime - startTime) % 1000;";
		strSettings += "<br>\tif(modT &lt; 500) return true;";
		strSettings += "<br>\treturn false;";
		strSettings += "<br>};";
	}
	strCode += strSettings;
}

private function findEffect(arr:Array, filter:Class):IFilter {
	if(!arr) return null;
	var i:uint = arr.length;
	while(i--) {
		if(arr[i] is filter) {
			return arr[i];
		}
	}
	return null;
}

private function updateKey(event:KeyboardEvent):void {
	intKey = opKeyDown.key = event.keyCode;
	tiKey.text = String.fromCharCode(event.charCode);
	Application.application.stage.focus = Application.application.stage;
}

private function pulseFunc(startTime:uint, currentTime:uint):Boolean {
	var modT:uint = (currentTime - startTime) % 1000;
	if(modT < 500) return true;
	return false;
}