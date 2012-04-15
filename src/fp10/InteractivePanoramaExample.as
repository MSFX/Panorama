/**
 * Panorama() Example Code by MSFX Matt Stuttard
 * Version 1.0
 * 15.04.2012
 * 
 * Copyright (c) MSFX Matt Stuttard Parker
 * 
 * http://msfx.co.uk
 * http://labs.msfx.co.uk
 * 
 * <p>This class <a href="http://away3d.com/download/away3d_3.6.0" target="_blank">requires Away3D 3.6.0</a>.</p>
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/
package 
{
	import away3d.materials.BitmapMaterial;
	import away3d.materials.MovieMaterial;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
			
			
			/**
			 * 1) Standard Image Example
			 * 
			 * The panorama can support standard "plain static images" which don't contain any interactivity (i.e. hotspots) or animations.
			 * 
			 * Uncomment line 97 to declare and instantiate a new "PanoramicImage()" (BitmapData) from the FLA library
			 * and uncomment lines 100/101 to pass the panoramic image to the constructor of the BitmapMaterial so we 
			 * can then pass it to the panorama to render.
			 */
			
			// create the image (source: http://en.wikipedia.org/wiki/File:Very_Large_Telescope_Ready_for_Action.jpg)
			var image:BitmapData = new PanoramicImage();
			
			// create the BitmapMaterial to pass to the panorama
			var imageForPanorama:BitmapMaterial = new BitmapMaterial(image);
			imageForPanorama.smooth = true;
			
			
			/**
			 * 2) Interactive MovieClip Example
			 * 
			 * The panorama can also support interactive movieclips which contain hotspots and can be animated
			 * 
			 * Uncomment lines 118-123 to declare and instantiate a new "InteractivePanoramicImage()" (MovieClip) from the FLA library
			 * and uncomment lines 126-128 to pass the interactive panoramic image to the constructor of the MovieMaterial so we 
			 * can then pass it to the panorama to render.
			 * 
			 * NB: For an interactive panorama you MUST set either the MovieMaterial's "interactive" property to true (line 128) or set 
			 * the InteractivePanorama's "interactive" property to true once it's instantiated (i.e. panorama.interactive = true; )
			 */
			
			// create the interactive movieclip
			//var imageMC:MovieClip = new InteractivePanoramicImage();
			//imageMC.hotspot.buttonMode = imageMC.hotspot.useHandCursor = true;
			//imageMC.hotspot.addEventListener(MouseEvent.CLICK, mouseEventHandler);
			//imageMC.hotspot.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
			//imageMC.hotspot.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
			//imageMC.hotspot.alpha = 0;
			
			// create the MovieMaterial to pass to the panorama
			//var imageForPanorama:MovieMaterial = new MovieMaterial(imageMC);
			//imageForPanorama.smooth = true;
			//imageForPanorama.interactive = true; // this must be set to true for an interactive panorama
			
			// create the panorama, position and resize to include 10px border around the edge and add to stage
			panorama = new InteractivePanorama(imageForPanorama, 150, 60, 60, stage.stageWidth - (spacing * 2), stage.stageHeight - (spacing * 2));
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
		 * Mouse Event Handler for the Hotspot within the Interactive Panorama Example
		 * 
		 *  - On RollOver/RollOut toggle the transparency of the hotspot
		 *  - On Click output to the console and stop the panorama being interactive
		 * 
		 * @param	e	MouseEvent.CLICK
		 * @param	e	MouseEvent.ROLL_OUT
		 * @param	e	MouseEvent.ROLL_OVER
		 */
		protected function mouseEventHandler(e:MouseEvent):void 
		{
			// determine the type of MouseEvent
			switch (e.type) 
			{
				case MouseEvent.CLICK:
					trace("Clicked Hotspot");
					panorama.interactive = false;
				break;
				
				case MouseEvent.ROLL_OVER:
					DisplayObject(e.currentTarget).alpha = 1;
				break;
				
				case MouseEvent.ROLL_OUT:
					DisplayObject(e.currentTarget).alpha = 0;
				break;
			}
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