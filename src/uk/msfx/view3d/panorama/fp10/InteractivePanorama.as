/**
 * Panorama() by MSFX Matt Stuttard Parker
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
package uk.msfx.view3d.panorama.fp10
{
	import away3d.events.MouseEvent3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import uk.msfx.view3d.panorama.events.PanoramaEvent;
	
	
	/**
	 * Adds the ability to navigate around the Panorama with the Mouse to the PanoramaCore class.
	 * 
	 * <p>Also adds the MouseWheel Zoom functionality</p>
	 * 
	 * <p>This class <a href="http://away3d.com/download/away3d_3.6.0" target="_blank">requires Away3D 3.6.0</a>.</p>
	 * 
	 * @author MSFX Matt Stuttard Parker
	 */
	public class InteractivePanorama extends PanoramaCore 
	{
		/**
		 * Whether to allow vertical movement when click and gliding.
		 */
		public var enableVerticalMovement:Boolean = true;
		
		/**
		 * Whether to allow horizontal movement when click and gliding.
		 */
		public var enableHorizontalMovement:Boolean = true;
		
		
		/**
		 * Whether to impose vertical rotation limits when click and gliding.
		 * 
		 * @see #verticalRotationLimitMin		Minimum rotation permitted
		 * @see #verticalRotationLimitMax		Maximum rotation permitted
		 */
		public var enableVerticalRotationLimits:Boolean = true;
		
		/**
		 * The minimum rotation permitted when vertical rotation limits are imposed.
		 */
		public var verticalRotationLimitMin:int = -70;
		
		/**
		 * The maximum rotation permitted when vertical rotation limits are imposed.
		 */
		public var verticalRotationLimitMax:int = 70;
		
		
		/**
		 * Whether to impose horizontal rotation limits when click and gliding.
		 * 
		 * @see #horizontalRotationLimitMin		Minimum rotation permitted
		 * @see #horizontalRotationLimitMax		Maximum rotation permitted
		 */
		public var enableHorizontalRotationLimits:Boolean = false;
		
		/**
		 * The minimum rotation permitted when horizontal rotation limits are imposed.
		 */
		public var horizontalRotationLimitMin:int = 0;
		
		/**
		 * The maximum rotation permitted when horizontal rotation limits are imposed.
		 */
		public var horizontalRotationLimitMax:int = 0;
		
		
		/**
		 * The easing value to provide a smooth user experience.  Set to 1 to remove.
		 */
		public var easing:Number = 0.3;
		
		/**
		 * The speed of X axis rotation.
		 */
		public var speedIncrementX:Number = 0.01;
		
		/**
		 * The speed of Y axis rotation.
		 */
		public var speedIncrementY:Number = 0.01;
		
		/**
		 * The increment used to increase/decrease the mouse wheel zoom.
		 */
		public var mouseWheelZoomIncrement:Number;
		
		/** 
		 * Assisting variable for easing calculation.
		 * @private 
		 */
		protected var newRotX:Number = 0;
		
		/** 
		 * Assisting variable for easing calculation.
		 * @private 
		 */
		protected var newRotY:Number = 0;
		
		/** 
		 * Assisting variable for easing calculation.
		 * @private 
		 */
		protected var rotX:Number = 0;
		
		/** 
		 * Assisting variable for easing calculation.
		 * @private 
		 */
		protected var rotY:Number = 0;
		
		/** 
		 * Whether the mouse is down.
		 * @private 
		 */
		protected var mouseDown:Boolean = false;
		
		
		/** 
		 * The point where the user clicked to calculate the direction to rotate.
		 * @private 
		 */
		protected var pointOfClick:Point = new Point(0, 0);
		
		
		/** 
		 * Whether we're using clickAndDrag.
		 * @private 
		 */
		protected var useClickAndDrag:Boolean = false;
		
		
		/**
		 * Minimum Zoom value.
		 * @private 
		 */
		protected var minimumZoom:Number;
		
		/**
		 * Maximum Zoom value.
		 * @private 
		 */
		protected var maximumZoom:Number;
		
		
		/**
		 * Constructor for the Interactive Panorama Class.
		 * 
		 * <p>If you wish to interact with the panorama, i.e. Click and Glide / Mouse Zoom then use this Class.</p>
		 * 
		 * 
		 * 
		 * @param	image		The panoramic image to be used, in either BitmapMaterial or MovieMaterial format
		 * @param	radius		<b>OPTIONAL</b> The radius of the sphere we're rendering onto (adjustable at runtime)
		 * @param	segmentsX	<b>OPTIONAL</b> The number of segments to make up the sphere (x axis)
		 * @param	segmentsY	<b>OPTIONAL</b> The number of segments to make up the sphere (y axis)
		 * @param	viewWidth	<b>OPTIONAL</b> The width of the 3d view (resizable at runtime via ".width")
		 * @param	viewHeight	<b>OPTIONAL</b> The height of the 3d view (resizable at runtime via ".height")
		 * @param	stats		<b>OPTIONAL</b> Whether to include Away3D stats on RMB
		 */
		public function InteractivePanorama(image:*, radius:int = 100, segmentsX:int = 10, segmentsY:int = 10, viewWidth:int = 1024, viewHeight:int = 768, stats:Boolean = false):void 
		{
			// pass variables to the the core (super)
			super(image, radius, segmentsX, segmentsY, viewWidth, viewHeight, stats);
		}
		
		/**
		 * Add Click and Glide Behaviour to the Panorama to allow the user to navigate and spin around etc.
		 * 
		 * <p>Requires renderer to work, see addRenderer().</p>
		 * 
		 * @see #enableVerticalMovement		Enable / Disable Vertical Movement
		 * @see #enableHorizontalMovement		Enable / Disable Horizontal Movement
		 * @see #enableVerticalRotationLimits		Enable / Disable Vertical Rotation Limits
		 * @see #enableHorizontalRotationLimits		Enable / Disable Hortizontal Rotation Limits
		 */
		public function addClickAndGlide():void 
		{
			// warning message
			if (!_rendering) trace("******\n\n\FYI: This functionality won't work unless you're rendering -> addRenderer()\n\n******");
			
			// handler for performing the rotation
			this.addEventListener(Event.ENTER_FRAME, mouseMovementHandler);
			
			// handler for the mouse down
			sphere.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseEventHandler);
		}
		
		/**
		 * Remove Click and Glide Behaviour from the scene.
		 */
		public function removeClickAndGlide():void 
		{
			// remove mouse down handler
			sphere.removeEventListener(MouseEvent3D.MOUSE_DOWN, mouseEventHandler);
		}
		
		/**
		 * Add Mouse Wheel Zoom to the scene
		 * 
		 * <p>Requires renderer to work, see addRenderer().</p>
		 * 
		 * @param	mouseWheelZoomIncrement		The increments that the zoom is increased/decreased by
		 * @param	minimumZoom					<b>OPTIONAL</b>The minimum zoom
		 * @param	maximumZoom					<b>OPTIONAL</b>The maximum zoom
		 */
		public function addMouseWheelZoom(mouseWheelZoomIncrement:Number = 1, minimumZoom:Number = 10, maximumZoom:Number = 20):void 
		{
			// warning message
			if (!_rendering) trace("******\n\n\FYI: This functionality won't work unless you're rendering -> addRenderer()\n\n******");
			
			// store params
			this.mouseWheelZoomIncrement = mouseWheelZoomIncrement;
			this.minimumZoom = minimumZoom
			this.maximumZoom = maximumZoom;
			
			// add mouse wheel handler
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelEventHandler);
		}
		
		/**
		 * Remove the Mouse Wheel Zoom from the scene.
		 */
		public function removeMouseWheelZoom():void 
		{
			// remove handler
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelEventHandler);
		}
		
		/**
		 * Mouse Wheel Event Handler.
		 * 
		 * @param	e	MouseEvent.MOUSE_WHEEL
		 */
		protected function mouseWheelEventHandler(e:MouseEvent):void 
		{
			// zoom in
			if (e.delta > 0)
			{
				_zoom += mouseWheelZoomIncrement;
			}
			else // zoom out
			{
				_zoom -= mouseWheelZoomIncrement;
			}
			
			// clamp zoom between min and max values
			// assign to zoom using setter
			zoom = Math.max(minimumZoom, Math.min(maximumZoom, _zoom));
		}
		
		/**
		 * Animate the rotation to a specfic euler angle.
		 * 
		 * <p>NB: This will only work if you're currently rendering.</p>
		 * 
		 * @param	xAxis		The angle of degrees on the x axis
		 * @param	yAxis		The angle of degrees on the y axis
		 */
		public function animateRotationTo(xAxis:int, yAxis:int):void 
		{
			newRotX = yAxis;
			newRotY = xAxis;
		}
		
		/**
		 * Overiding RotateTo()
		 * 
		 * @param	xAxis	Axis Rotation X
		 * @param	yAxis	Axis Rotation Y
		 */
		override public function rotateTo(xAxis:int, yAxis:int):void 
		{
			// update eased values as well as the holder/sphere values to prevent sphere easing back to original position
			holder.rotationX = rotY = newRotY = xAxis;
			sphere.rotationY = rotX = newRotX = yAxis;
		}
		
		/**
		 * MouseEvent3D Handler.
		 * 
		 * @param	e 	MouseEvent3D.MOUSE_DOWN
		 * @param	e 	MouseEvent3D.MOUSE_UP
		 * @private
		 */
		protected function mouseEventHandler(e:MouseEvent3D):void 
		{
			// identify the mouseevent triggered
			switch (e.type) 
			{
				case MouseEvent3D.MOUSE_DOWN:
					
					// indicate the mouse is down
					mouseDown = true;
					this.dispatchEvent(new PanoramaEvent(PanoramaEvent.MOUSE_DOWN, pointOfClick));
					
					// update point of click pos
					pointOfClick.x = view.mouseX;
					pointOfClick.y = view.mouseY;
					
					// add listeners for movement and release
					sphere.addEventListener(MouseEvent3D.MOUSE_UP, mouseEventHandler);
					
					// remove listener for initial click
					sphere.removeEventListener(MouseEvent3D.MOUSE_DOWN, mouseEventHandler);
					
					// stage mouse up handler
					stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpEventHandler);
					
				break;
				
				case MouseEvent3D.MOUSE_UP:
					
					// indicate the mouse has been released
					mouseDown = false;
					this.dispatchEvent(new PanoramaEvent(PanoramaEvent.MOUSE_UP));
					
					// remove listeners for movement and release
					sphere.removeEventListener(MouseEvent3D.MOUSE_UP, mouseEventHandler);
					
					// add listener for intial click
					sphere.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseEventHandler);
					
				break;
				
			}
		}
		
		/**
		 * Mouse Event UP Handler to detect the mouse being released outside of the Away3D view but within the Flash Player
		 * 
		 * @param	e	MouseEvent.UP
		 * @private
		 */
		protected function mouseUpEventHandler(e:MouseEvent):void 
		{
			// stage mouse up handler
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpEventHandler);
			
			// indicate the mouse has been released
			mouseDown = false;
			this.dispatchEvent(new PanoramaEvent(PanoramaEvent.MOUSE_UP));
			
			// remove listeners for movement and release
			sphere.removeEventListener(MouseEvent3D.MOUSE_UP, mouseEventHandler);
			
			// add listener for intial click
			sphere.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseEventHandler);
		}
		
		/**
		 * Mouse Leave Event Handler to detect the mouse being released outside of the Flash Player
		 * 
		 * @param	e	Event.MOUSE_LEAVE
		 * @private
		 */
		protected function mouseLeaveHandler(e:Event):void 
		{
			// indicate the mouse has been released
			mouseDown = false;
			
			// remove listeners for movement and release
			sphere.removeEventListener(MouseEvent3D.MOUSE_UP, mouseEventHandler);
			
			// add listener for intial click
			sphere.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseEventHandler);
		}
		
		
		/**
		 * EnterFrame Handler for Mouse Movement.
		 * 
		 * @param	e 	Event.ENTER_FRAME
		 * @private
		 */
		protected function mouseMovementHandler(e:Event):void 
		{
			// if mouse is down recalculate rotation
			if (mouseDown)
			{
				// vertical movement
				if (enableVerticalMovement)
				{
					// calculate difference between where mouse was originally pressed and current location
					var diffY:int = pointOfClick.y - view.mouseY;
					
					// limit vertical rotation (x axis)
					newRotY += (diffY * -speedIncrementY);
					
					// add restriction
					if (enableVerticalRotationLimits) newRotY = Math.min(Math.max(newRotY, verticalRotationLimitMin), verticalRotationLimitMax);
				}
				
				// horizontal movement
				if (enableHorizontalMovement)
				{
					// calculate difference between where mouse was originally pressed and current location
					var diffX:int = pointOfClick.x - view.mouseX;
					
					// multiply above difference with speed increment and append to new rotation position
					newRotX += (diffX * speedIncrementX);
					
					// add restriction
					if (enableHorizontalRotationLimits) newRotX = Math.min(Math.max(newRotX, horizontalRotationLimitMin), horizontalRotationLimitMax);
				}
				
			}
			
			// if horizontal movement is allowed update every frame (allows easing when mouse is released)
			if (enableHorizontalMovement)
			{
				// horizontal rotation with soft easing
				rotX += ((newRotX - sphere.rotationY) * easing);
				
				// apply the rotation
				sphere.rotationY = rotX;
			}
			
			// if vertical movement is allowed update every frame (allows easing when mouse is released)
			if (enableVerticalMovement)
			{
				// vertical rotation with soft easing
				rotY += ((newRotY - holder.rotationX) * easing);
				
				// apply the rotation
				holder.rotationX = rotY;
			}
			
			// output the x/y rotation values - useful if you want to use the restrictions
			//trace("horiz (y): " + Math.round(sphere.rotationY) + ", vert (x): " + Math.round(holder.rotationX));
		}
		
		/**
		 * Added To Stage Event Handler
		 * 
		 * @param	e	Event.ADDED_TO_STAGE
		 * @private
		 */
		override protected function added(e:Event):void 
		{
			super.added(e);
			
			// add mouse leave handler
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
		}
		
		/**
		 * Remove handlers when removed from display list (stage).
		 * 
		 * @param	e 	Event.REMOVED_FROM_STAGE
		 * @private
		 */
		override protected function removed(e:Event):void 
		{
			super.removed(e);
			
			// remove mouse leave handler
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			
			// kill the renderer
			this.removeEventListener(Event.ENTER_FRAME, mouseMovementHandler);
		}
		
		
	}
}