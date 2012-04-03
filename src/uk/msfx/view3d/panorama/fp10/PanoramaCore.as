/**
 * Panorama by MSFX Matt Stuttard Parker
 * Version 1.0
 * 02.04.2012
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
package uk.msfx.view3d.panorama.fp10
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.clip.RectangleClipping;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.Material;
	import away3d.materials.MovieMaterial;
	import away3d.primitives.Sphere;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * The core class of the Panorama Framework that handles the initialisation of the 3D scene in which a panoramic image is mapped to the inside of a sphere.
	 * 
	 * <p>This class <a href="http://away3d.com/download/away3d_3.6.0" target="_blank">requires Away3D 3.6.0</a>.</p>
	 * 
	 * @author MSFX Matt Stuttard Parker
	 */
	public class PanoramaCore extends Sprite 
	{
		/** @private **/
		protected var viewWidth:int;
		/** @private **/
		protected var viewHeight:int;
		/** @private **/
		protected var scene:Scene3D;
		/** @private **/
		protected var view:View3D;
		/** @private **/
		protected var viewClippingRect:RectangleClipping;
		/** @private **/
		protected var camera:Camera3D;
		
		// parent object to hold the sphere and perform X axis rotation
		/** @private **/
		protected var holder:ObjectContainer3D;
		
		// sphere to map the image onto and perform Y axis rotation
		/** @private **/
		protected var sphere:Sphere;
		
		// radius of the sphere the image is mapped onto
		/** @private **/
		protected var _radius:int;
		
		// zoom fator of the camera in the scene
		/** @private **/
		protected var _zoom:int = 10;
		
		// bitmap material for regular static images
		/** @private **/
		protected var bitmapMaterial:BitmapMaterial;
		
		// moviematerial should the image be animated at all
		/** @private **/
		protected var movieMaterial:MovieMaterial;
		
		// whether the movie material is to be updated / animated at all (defaults to false)
		/** @private **/
		protected var _animated:Boolean = false;
		
		// whether the movie material is interactive or not
		/** @private **/
		protected var _interactive:Boolean = false;
		
		// whether rendering
		/** @private **/
		protected var _rendering:Boolean = false;
		
		// field of view
		/** @private **/
		protected var _fov:Number = 0;
		
		// focus
		/** @private **/
		protected var _focus:Number = 80;
		
		// aperture
		/** @private **/
		protected var _aperture:Number = 22;
		
		
		/**
		 * Constructor for the Panorama Core.
		 * 
		 * <p>If all you need is a Sphere with a panoramic image without any interactivity, i.e. it rotates by itself then this class will suffice.</p>
		 * 
		 * @param	image		The panoramic image to be used, in either BitmapMaterial or MovieMaterial format
		 * @param	radius		<b>OPTIONAL</b> The radius of the sphere we're rendering onto (adjustable at runtime)
		 * @param	segmentsX	<b>OPTIONAL</b> The number of segments to make up the sphere (x axis)
		 * @param	segmentsY	<b>OPTIONAL</b> The number of segments to make up the sphere (y axis)
		 * @param	viewWidth	<b>OPTIONAL</b> The width of the 3d view (resizable at runtime via ".width")
		 * @param	viewHeight	<b>OPTIONAL</b> The height of the 3d view (resizable at runtime via ".height")
		 * @param	stats		<b>OPTIONAL</b> Whether to include Away3D stats on RMB
		 */
		public function PanoramaCore(image:*, radius:int = 200, segmentsX:int = 20, segmentsY:int = 20, viewWidth:int = 1024, viewHeight:int = 768, stats:Boolean = false):void 
		{
			// store variables
			this.viewWidth = viewWidth;
			this.viewHeight = viewHeight;
			this._radius = radius;
			
			// init scene
			scene = new Scene3D();
			
			// init view for the scene
			view = new View3D( { stats:stats } );
			view.x = viewWidth * 0.5;
			view.y = viewHeight * 0.5;
			view.scene = scene;
			addChild(view);
			
			// init clipping rectangle
			viewClippingRect = new RectangleClipping();
			viewClippingRect.minX = -(viewWidth * 0.5);
			viewClippingRect.maxX = (viewWidth * 0.5);
			viewClippingRect.minY = -(viewHeight * 0.5);
			viewClippingRect.maxY = (viewHeight * 0.5);
			
			// apply clipping
			view.clipping = viewClippingRect;
			
			// init camera for the view
			camera = new Camera3D();
			camera.x = camera.y = camera.z = 0;
			view.camera = camera;
			
			// init container
			holder = new ObjectContainer3D();
			holder.x = holder.y = holder.z = 0;
			holder.rotationX = holder.rotationY = holder.rotationZ = 0;
			scene.addChild(holder);
			
			// init sphere
			sphere = new Sphere();
			sphere.x = sphere.y = sphere.z = 0;
			sphere.rotationX = sphere.rotationY = sphere.rotationZ = 0;
			sphere.radius = _radius;
			sphere.segmentsW = segmentsX;
			sphere.segmentsH = segmentsY;
			sphere.invertFaces();
			
			// add sphere to container
			holder.addChild(sphere);
			
			// assign image to correct material holder and then to Sphere
			if (image is MovieMaterial) 
			{
				movieMaterial = image;
				sphere.material = movieMaterial;
			}
			else if (image is BitmapMaterial) // else bitmap material
			{
				bitmapMaterial = image;
				sphere.material = bitmapMaterial;
			}
			else // unsupported material
			{
				trace("*************************************")
				trace("******* UNSUPPORTED MATERIAL? *******");
				trace("*************************************")
			}
			
			// listner for being added to display list
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		/**
		 * Rotate the sphere to a particular Euler Angle on X and Y axis.
		 * 
		 * @param	xAxis 	X axis rotation
		 * @param	yAxis 	Y axis rotation
		 */
		public function rotateTo(xAxis:int, yAxis:int):void 
		{
			sphere.rotateTo(xAxis, yAxis, 0);
		}
		
		/**
		 * Reset the rotation of the sphere to 0,0,0.
		 */
		public function resetRotation():void 
		{
			holder.rotateTo(0, 0, 0);
			sphere.rotateTo(0, 0, 0);
		}
		
		/**
		 * Completes a single render of the current scene.
		 */
		public function render():void 
		{
			// render the scene
			view.render();
		}
		
		/**
		 * Add a render loop to the scene.
		 */
		public function addRenderer():void 
		{
			// add handler, set rendering to true
			this.addEventListener(Event.ENTER_FRAME, enterFrameRenderer);
			_rendering = true;
		}
		
		/**
		 * Remove the render loop from the scene.
		 */
		public function removeRenderer():void 
		{
			// remove handler, set rendering to false
			this.removeEventListener(Event.ENTER_FRAME, enterFrameRenderer);
			_rendering = false;
		}
		
		/**
		 * Trigger events once added to the display list.
		 * 
		 * @param	e 	Event.ADDED_TO_STAGE
		 * @private
		 */
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		/**
		 * Trigger events once removed from the display list.
		 * 
		 * @param	e 	Event.REMOVED_FROM_STAGE
		 * @private
		 */
		protected function removed(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		/**
		 * Render loop event handler.
		 * 
		 * @param	e EnterFrame Event to render the view
		 * @private
		 */
		protected function enterFrameRenderer(e:Event):void 
		{
			// render the scene
			view.render();
		}
		
		
		/**
		 * Whether the MovieMaterial is animated (updated per frame) or not.
		 */
		public function get animated():Boolean { return _animated; }
		
		/**
		 * The aperture for the Camera.
		 */
		public function get aperture():Number { return _aperture; }
		
		/**
		 * The focus for the Camera.
		 */
		public function get focus():Number { return _focus; }
		
		/**
		 * The field of view for the Camera.
		 */
		public function get fov():Number { return _fov; }
		
		/**
		 * Whether the MovieMaterial is interactive or not.
		 */
		public function get interactive():Boolean { return _interactive; }
		
		/**
		 * The radius of the sphere the panorama is mapped onto.
		 */
		public function get radius():int { return _radius; }
		
		/**
		 * Whether there is a current render loop.
		 */
		public function get rendering():Boolean { return _rendering; }
		
		/**
		 * The current zoom of the Camera.
		 */
		public function get zoom():int { return _zoom; }
		
		
		
		/** @private */
		public function set animated(value:Boolean):void { if (movieMaterial) _animated = movieMaterial.autoUpdate = value; }
		
		
		/** @private */
		public function set aperture(value:Number):void { camera.aperture = _aperture = value; }
		
		
		/** @private */
		public function set focus(value:Number):void { camera.focus = _focus = value; }
		
		
		/** @private */
		public function set fov(value:Number):void { camera.fov = _fov = value; }
		
		
		/** @private */
		public function set interactive(value:Boolean):void { if (movieMaterial) _interactive = movieMaterial.interactive = value; }
		
		
		/** @private */
		public function set radius(value:int):void { sphere.radius = _radius = value; }
		
		
		/** @private */
		public function set rendering(value:Boolean):void { _rendering = value; }
		
		
		/** @private */
		public function set zoom(value:int):void { camera.zoom = _zoom = value; }
		
		
		
		/**
		 * The width of the 3d view.
		 */
		override public function get width():Number { return viewWidth; }
		
		/**
		 * The height of the 3d view.
		 */
		override public function get height():Number { return viewHeight; }
		
		
		/** @private */
		override public function set width(value:Number):void 
		{ 
			viewWidth = value;
			
			// update the clipping
			viewClippingRect.minX = -(viewWidth * 0.5);
			viewClippingRect.maxX = (viewWidth * 0.5);
			
			// reposition view
			view.x = (viewWidth * 0.5);
			
			// reapply the clipping
			view.clipping = viewClippingRect;
		}
		
		/** @private */
		override public function set height(value:Number):void 
		{
			viewHeight = value;
			
			// update the clipping
			viewClippingRect.minY = -(viewHeight * 0.5);
			viewClippingRect.maxY = (viewHeight * 0.5);
			
			// reposition view
			view.y = (viewHeight * 0.5);
			
			// reapply the clipping
			view.clipping = viewClippingRect;
		}
		
	}
}