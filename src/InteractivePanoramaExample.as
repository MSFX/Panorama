package 
{
	import away3d.materials.BitmapMaterial;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import uk.msfx.view3d.panorama.fp10.InteractivePanorama;
	
	
	/**
	 * Interactive Panorama Example
	 * 
	 * @author MSFX Matt Stuttard
	 */
	public class InteractivePanoramaExample extends MovieClip 
	{
		// the panorama
		protected var panorama:InteractivePanorama;
		
		// spacing
		protected var spacing:int = 10;
		
		
		/**
		 * Interactive Panorama Example 
		 */
		public function InteractivePanoramaExample():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Added To Stage Handler
		 * 
		 * @param	e	Event.ADDED_TO_STAGE
		 */
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// setup the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// create the image (source: http://en.wikipedia.org/wiki/File:Very_Large_Telescope_Ready_for_Action.jpg)
			var image:BitmapMaterial = new BitmapMaterial(new PanoramicImage());
			image.smooth = true;
			
			// create the panorama, position and resize to include 10px border around the edge and add to stage
			panorama = new InteractivePanorama(image, 150, 60, 60, stage.stageWidth - (spacing * 2), stage.stageHeight - (spacing * 2));
			panorama.x = panorama.y = spacing;
			addChild(panorama);
			
			// add renderer 
			panorama.addRenderer();
			
			// add click and glide behaviour
			panorama.addClickAndGlide();
			
			// uncomment to remove the click and glide behaviour
			//panorama.removeClickAndGlide();
			
			// add mouse wheel zoom behaviour
			panorama.addMouseWheelZoom();
			
			// remove mouse wheel zoom behaviour
			//panorama.removeMouseWheelZoom();
			
			// uncomment to remove easing
			//panorama.easing = 1;
			
			// uncomment to disable horizontal movement
			//panorama.enableHorizontalMovement = false;
			
			// uncomment the following 3 lines to restrict the horizontal rotation (around the Y axis)
			//panorama.enableHorizontalRotationLimits = true;
			//panorama.horizontalRotationLimitMin = -90;
			//panorama.horizontalRotationLimitMax = 90;
			
			// uncomment to disable vertical movement
			//panorama.enableVerticalMovement = false;
			
			// uncomment the following 3 lines to restrict the vertical rotation (around the X axis)
			//panorama.enableVerticalMovement = true;
			//panorama.verticalRotationLimitMin = -20;
			//panorama.verticalRotationLimitMax = 20;
			
			// uncomment to rotate to a specific angle (i.e. to look at the people)
			//panorama.rotateTo(15, 120);
			
			// uncomment to perform a single render (ideal if panorama isn't interactive or being rotated)
			//panorama.render()
			
			// whether the panorama's MovieMaterial is animated 
			//trace(panorama.animated);
			
			// uncomment to rotate to particular angle (using the easing value to rotate sphere, must be rendering)
			//panorama.animateRotationTo(15, 120);
			
			// whether the panorama's MovieMaterial (if one is used) is interactive or not
			//trace(panorama.interactive);
			
			// whether the panorama is rendering
			//trace(panorama.rendering)
			
			// the zoom value of the camera
			//panorama.zoom
			
			// listen to stage resizing
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		
		/**
		 * Resize the panorama when containing window is resized
		 * 
		 * @param	e		Event.RESIZE
		 */
		protected function resizeHandler(e:Event = null):void 
		{
			// update panorama width/height taking into account spacing either side
			panorama.width = stage.stageWidth - (spacing * 2);
			panorama.height = stage.stageHeight - (spacing * 2);
		}
		
	}
}