package 
{
	import away3d.materials.BitmapMaterial;
	import away3d.materials.MovieMaterial;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.utils.Timer;
	import uk.msfx.scrollers.core.ScrollBarCore;
	import uk.msfx.scrollers.core.ScrollEvent;
	import uk.msfx.view3d.panorama.fp10.InteractivePanorama;
	
	TweenPlugin.activate([ColorTransformPlugin]);
	
	/**
	 * ...
	 * @author MSFX Matt Stuttard
	 */
	public class Main extends MovieClip 
	{
		private var movieMaterial:MovieMaterial;
		private var panorama:InteractivePanorama;
		
		private var radiusScroller:ScrollBarCore;
		private var zoomScroller:ScrollBarCore;
		private var fovScroller:ScrollBarCore;
		private var focusScroller:ScrollBarCore;
		
		private var minRadius:int = 80;
		private var minZoom:int = 5;
		private var minFOV:int = 0;
		private var minFocus:int = 0;
		private var txt:TextField;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			// source: http://en.wikipedia.org/wiki/File:Very_Large_Telescope_Ready_for_Action.jpg
			loader.load(new URLRequest("image.jpg"));
			
			radiusScroller = new ScrollBarCore(new Track(), new Scrubber(), false);
			radiusScroller.name = "radiusScroller";
			radiusScroller.scrubber.buttonMode = radiusScroller.scrubber.useHandCursor = true;
			radiusScroller.addEventListener(ScrollEvent.START, scrollEventHandler);
			radiusScroller.addEventListener(ScrollEvent.SCROLLING, scrollEventHandler);
			radiusScroller.addEventListener(ScrollEvent.COMPLETE, scrollEventHandler);
			
			fovScroller = new ScrollBarCore(new Track(), new Scrubber(), false);
			fovScroller.name = "fovScroller";
			fovScroller.scrubber.buttonMode = fovScroller.scrubber.useHandCursor = true;
			
			zoomScroller = new ScrollBarCore(new Track(), new Scrubber(), false);
			zoomScroller.name = "zoomScroller";
			zoomScroller.scrubber.buttonMode = zoomScroller.scrubber.useHandCursor = true;
			zoomScroller.addEventListener(ScrollEvent.START, scrollEventHandler);
			zoomScroller.addEventListener(ScrollEvent.SCROLLING, scrollEventHandler);
			zoomScroller.addEventListener(ScrollEvent.COMPLETE, scrollEventHandler);
			
			focusScroller = new ScrollBarCore(new Track(), new Scrubber(), false);
			focusScroller.name = "focusScroller";
			focusScroller.scrubber.buttonMode = focusScroller.scrubber.useHandCursor = true;
			focusScroller.addEventListener(ScrollEvent.START, scrollEventHandler);
			focusScroller.addEventListener(ScrollEvent.SCROLLING, scrollEventHandler);
			focusScroller.addEventListener(ScrollEvent.COMPLETE, scrollEventHandler);
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
		}
		
		private function scrollEventHandler(e:ScrollEvent):void 
		{
			if (e.currentTarget.name == "zoomScroller")
			{
				panorama.zoom = minZoom + (e.data * 10);
			}
			else if (e.currentTarget.name == "radiusScroller")
			{
				panorama.radius = minRadius + (e.data * 100);
			}
			else if (e.currentTarget.name == "fovScroller")
			{
				//panorama.fov = minFOV + (e.data * 100);
			}
			else if (e.currentTarget.name == "focusScroller")
			{
				panorama.focus = minFocus + (e.data * 100);
			}
			
			panorama.render();
			updateTXT();
		}
		
		private function loaded(e:Event):void 
		{
			// add image to movieclip
			//var mc:MovieClip = MovieClip(e.currentTarget.content);
			//var nc:int = mc.numChildren;
			//var hotspot:Sprite;
			//
			//for (var i:int = 1; i < nc; i++) 
			//{
				//hotspot = Sprite(mc.getChildAt(i));
				//hotspot.buttonMode = hotspot.useHandCursor = true;
				//hotspot.addEventListener(MouseEvent.CLICK, mouseEventHandler);
				//hotspot.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
				//hotspot.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
			//}
			
			// init movie material for sphere with panom set autoupdate initially to false
			//movieMaterial = new MovieMaterial(mc);
			var bitmap:BitmapMaterial = new BitmapMaterial(Bitmap(e.currentTarget.content).bitmapData);
			bitmap.smooth = true;
			//movieMaterial.interactive = true;
			//movieMaterial.smooth = true;
			
			// init pano
			//panorama = new InteractivePanorama(movieMaterial, 80, 40, 40, 1024, 768, true);
			panorama = new InteractivePanorama(bitmap, 80, 60, 60, 1024, 768, true);
			//panorama.fov = 45;
			panorama.radius = 150;
			panorama.zoom = 10;
			panorama.focus = 80;
			addChild(panorama);
			
			// radius scroller
			addChild(radiusScroller);
			
			// zoom scroller
			addChild(zoomScroller);
			
			// zoom scroller
			//addChild(fovScroller);
			
			// focus scroller
			addChild(focusScroller);
			
			// add renderer and click and glide functionality
			panorama.alpha = 0;
			panorama.addRenderer();
			
			//debugging
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key);
			
			// debug
			txt = new TextField();
			txt.width = 200;
			txt.height = 200;
			txt.x = txt.y = 10;
			txt.textColor = 0x666666;
			txt.background = true;
			txt.backgroundColor = 0xFFFFFF;
			txt.border = true;
			txt.borderColor = 0xCCCCCC;
			addChild(txt);
			
			updateTXT();
			
			resizeHandler();
			
			TweenLite.to(panorama, 1, { alpha: 1, onComplete: done } );
		}
		
		private function done():void 
		{
			
			panorama.addClickAndGlide();
		}
		
		private function updateTXT():void 
		{
			txt.text = "Radius: " + panorama.radius + "\nZoom: " + panorama.zoom + "\nFocus: " + panorama.focus;
			txt.width = txt.textWidth + 5;
			txt.height = txt.textHeight + 5;
		}
		
		private function key(e:KeyboardEvent):void 
		{
			if (e.ctrlKey) 
			{
				stage.displayState = (stage.displayState == StageDisplayState.FULL_SCREEN)? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN;
			}
		}
		
		private function addHotspot(mc:MovieClip):void 
		{
			mc.addEventListener(MouseEvent.CLICK, mouseEventHandler);
			mc.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
			mc.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
			mc.buttonMode = mc.useHandCursor = true;
		}
		
		private function resizeHandler(e:Event = null):void 
		{
			panorama.width = stage.stageWidth;
			panorama.height = stage.stageHeight;
			
			
			// radius scroller
			radiusScroller.x = ((stage.stageWidth - radiusScroller.width) * 0.5);
			radiusScroller.y = (stage.stageHeight * .9);
			
			// zoom scroller
			zoomScroller.x = ((stage.stageWidth - zoomScroller.width) * 0.5);
			zoomScroller.y = (stage.stageHeight * .92);
			
			// fov scroller
			focusScroller.x = ((stage.stageWidth - focusScroller.width) * 0.5);
			focusScroller.y = (stage.stageHeight * .94);
		}
		
		private function mouseEventHandler(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case MouseEvent.CLICK:
					
					trace("clicked - " + e.currentTarget.name);
					
					if (e.currentTarget.name.indexOf("loadSpace") > 0) 
					{
						trace("load space - " + e.currentTarget.name.charAt(e.currentTarget.name.length - 1));
					}
					else if (e.currentTarget.name.indexOf("loadPano") > 0) 
					{
						trace("load pano - " + e.currentTarget.name.charAt(e.currentTarget.name.length - 1));
					}
				break;
				
				case MouseEvent.ROLL_OVER:
					panorama.animated = true;
					TweenLite.to(e.currentTarget, 0.5, { colorTransform: { tint: 0x00FF00, tintAmount: 0.7 }, onComplete: panoramaAnimationOff } );
				break;
				
				case MouseEvent.ROLL_OUT:
					panorama.animated = true;
					TweenLite.to(e.currentTarget, 0.5, { colorTransform: { tint: 0xFFFFFF, tintAmount: 0 }, onComplete: panoramaAnimationOff } );
				break;
			}
		}
		
		private function panoramaAnimationOff():void 
		{
			panorama.animated = false;
		}
		
	}
}