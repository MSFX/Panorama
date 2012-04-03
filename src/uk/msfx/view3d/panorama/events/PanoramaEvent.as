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
package uk.msfx.view3d.panorama.events 
{
	import flash.events.Event;
	
	/**
	 * Events Dispatched using Panorama Classes
	 * 
	 * @author MSFX Matt Stuttard
	 */
	public class PanoramaEvent extends Event 
	{
		/**
		 * Data being sent with the Event
		 */
		public var data:*;
		
		/**
		 * MouseDown Event
		 */
		public static const MOUSE_DOWN:String = "mouseDown";
		
		/**
		 * MouseUp Event
		 */
		public static const MOUSE_UP:String = "mouseUp";
		
		
		/**
		 * Panorama Event Constructor.
		 * 
		 * @param	type The type of Event being dispatched
		 * @param	data Any data being sent with the Event
		 * @param	bubbles Whether the Event will bubble
		 * @param	cancelable Whether the Event is cancellable
		 */
		public function PanoramaEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
			
			// data to send with event
			this.data = data;
		} 
		
		/** @private */
		public override function clone():Event 
		{ 
			return new PanoramaEvent(type, data, bubbles, cancelable);
		} 
		
		/** @private */
		public override function toString():String 
		{ 
			return formatToString("PanoramaEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
}