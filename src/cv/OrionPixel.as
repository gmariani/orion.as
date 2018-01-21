/**
* Orion ©2009 Gabriel Mariani. February 9th, 2009
* Visit http://blog.coursevector.com/orion for documentation, updates and more free code.
*
*
* Copyright (c) 2009 Gabriel Mariani
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

// TweenLite helped too
// BetweenAS3 helped too
// http://blog.joa-ebert.com/2009/04/03/massive-amounts-of-3d-particles-without-alchemy-and-pixelbender/

package cv {
	
	import cv.orion.Orion;
	import cv.orion.interfaces.IFilter;
	import cv.orion.interfaces.IOutput;
	import cv.orion.ParticleVO;
	import cv.orion.events.ParticleEvent;
	import flash.geom.Point;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	//--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * <strong>Orion ©2009 Gabriel Mariani, coursevector.com.
	 * <br/>Visit http://blog.coursevector.com/orion for documentation, updates and more 
	 * free code.
	 * <br/>Licensed under the MIT license - see the source file header 
	 * for more information.</strong>
	 * <hr>
	 * Orion is an easy to use and light-weight particle system. It's instance 
	 * oriented much like GTween so you can re-use and modify easily. It's 
	 * also very fast, capable of handling over 3000 particles at more than 
	 * 30fps if your computer can handle it. But unless you're doing something 
	 * really intense you probably won't notice any slowdown. At it's smallest
	 * Orion will add about 6kb to your filesize.
	 * <br/><br/>
	 * The Orion class is the hub of particle system. It  
	 * determines <strong>where</strong> the particles will be generated.
	 * All particles are generated within the bounds of the Orion instance.
	 * So if you set it up to be 100x100, the particles will be generated 
	 * somewhere within that area. If you set the width and height below
	 * 1 (i.e. 0x0), it will generate all the particles at the center of the 
	 * instance.
	 * <br/><br/>
	 * To control where the particles can be displayed you can modify the 
	 * canvas property. The canvas is a simple rectange object, changing the
	 * height, width, and position of it will determine where the particles 
	 * will be displayed and when the edgeFilter will take action.
	 * <br/><br/>
	 * Orion is easy to use and incredibly flexible and customizable. To keep 
	 * it's size down, there are effectFilters, the more you add the more work 
	 * Orion has to do which can affect performance and filesize. So keep this 
	 * in mind before you use every filter and wonder why it's not handling 
	 * 3000 particles easily. Below are some examples to show you how to use 
	 * Orion and how quickly you can get up and running. Since Orion is so 
	 * customizable, I thought it would be nice to be able to save those 
	 * configurations so you can use the same settings again. This is what the 
	 * presets are used for. They will configure an instance of Orion with the 
	 * given settings. If you have to find a setting you like you can create 
	 * your own presets and load them as well.
	 * 
	 * @example The only requirement to use Orion is to have an item exported from the library.
	 * <br/><br/>
	 * <listing version="3.0">
	 * import cv.orion.Orion;
	 * import cv.orion.preset.Default; // A small set of common presets
	 * 
	 * var e:Orion = new Orion(linkageClass, null, Default.firework());
	 * this.addChild(e);
	 * 
	 * </listing>
	 * <br/><br/>
	 * That's it! Although that is a very basic setup but as you can see, it doesn't take much work to get a particle
	 * system up and running in your code.
     */
	public class OrionPixel extends Orion implements IOutput {
		
		/** @private */
		protected var _bitmapData:BitmapData;
		/** @private */
		protected var _buffer:Vector.<uint>;
		
		/**
		 * The constructor allows a few common settings to be specified during construction. Options such
		 * as the output class or any configuration settings.
		 * 
		 * @param	spriteClass This is the linkage class of the item you have exported from the library.
		 * @param	output	Here you can specify which output class you'd like to use. If you don't want to 
		 * use one, just leave this as <code>null</code>
		 * @param	config	Here you can pass in a <code>configuration</code> object. A <code>configuration</code> object is generated by a 
		 * preset or you can write one by hand. Each <code>configuration</code> object can contain an <code>effectFilters</code> vector, an
		 * <code>edgeFilter</code> object, and a <code>settings</code> object. The <code>settings</code> object can contain all the same properties that
		 * modifying the <code>settings</code> property directly allows.
		 * @param	useFrameCaching	Frame caching is useful for particles that have a lot of glow filters or native Flash filters applied.
		 * Turning on frame caching will cause Orion to take a snapshot of each frame of the particle and turn it into a Bitmap and use the Bitmap
		 * instead. This can greatly increase performance for complicated particles.
		 * 
		 * @see Orion#settings
		 * @see Orion#useFrameCaching
		 */
		public function OrionPixel(bitmapData:BitmapData, config:Object = null) {
			_bitmapData = bitmapData;
			_buffer = new Vector.<uint>(_bitmapData.width * _bitmapData.height, true);
			_particles = new ParticleVO();
			
			super(config);
		}
		
		//--------------------------------------
		//  Methods
		//--------------------------------------
		
		/**
		 * Updates all the particles and positions, updates the output class as well.
		 * 
		 * @param	e The event dispatched.
		 * @default null
		 */
		override public function render(e:Event = null):void {
			// Draw boxes for emitter and canvas
			if (debug) {
				this.graphics.clear();
				this.graphics.lineStyle(1, 0x00FF00, 1, true);
				this.graphics.drawRect(this.x, this.y, this.width, this.height);
				this.graphics.moveTo(this.x, this.y);
				this.graphics.lineTo(this.x, this.y);
				this.graphics.lineTo(this.x + this.width, this.y + this.height);
				this.graphics.moveTo(this.x + this.width, this.y);
				this.graphics.lineTo(this.x + this.width, this.y);
				this.graphics.lineTo(this.x, this.y + this.height);
				if(canvas) {
					this.graphics.lineStyle(1, 0xFF0000, 1, true);
					this.graphics.drawRect(canvas.x, canvas.y, canvas.width, canvas.height);
				}
			}
			
			if (paused) return;
			
			// Init Buffer
			var bufferMax:int = _buffer.length;
			var bufferIndex:int;
			var bufferMin:int = -1;
			var buffer:Vector.<uint> = _buffer;
			var bufferWidth:Number = _bitmapData.width;
			var i:uint = bufferMax;
			while (--i > -1) buffer[i] = 0x000000;
			
			// Variables used in the loop
			var lifeSpan:uint = settings.lifeSpan;
			var particle:ParticleVO = _particles;
			var numEmit:int = _emitQueue.length - 1;
			var numAdd:uint = output.getOutput(this);
			var length:uint = 0;
			var curTime:uint = Orion.time;
			var color:uint = 0xffffff;
			var effectFiltersLength:uint = effectFilters.length;
			var _effectFilters:Vector.<IFilter> = effectFilters;
			var _edgeFilter:IFilter = edgeFilter;
			var dispatch:Boolean = _dispatchUpdates;
			var event:ParticleEvent = _eventUpdate;
			var x:Number;
			var y:Number;
			var j:uint;
			var c:Point;
			
			do {
				if(particle.active) {
					// Too old
					if (lifeSpan) {
						if ((curTime - particle.timeStamp) > lifeSpan) {
							removeParticle(particle);
							continue;
						}
					}
					
					// Count particles
					++length;
					
					if (!particle.paused) {
						// Apply Filters
						if(effectFiltersLength) {
							i = effectFiltersLength;
							while (--i > -1) {
								_effectFilters[i].applyFilter(particle, this);
							}
						}
						
						// Position particle
						if (particle.velocityX != 0) particle.x += particle.velocityX;
						if (particle.velocityY != 0) particle.y += particle.velocityY;
						if (_edgeFilter) _edgeFilter.applyFilter(particle, this);
					}
					
					// Dispatch update event
					if (dispatch) {
						event.particle = particle;
						dispatchEvent(event);
					}
					
					// Draw
					x = int(particle.x), y = int(particle.y);
					if (bufferMin < (bufferIndex = x + int(y * bufferWidth)) && bufferIndex < bufferMax) {
						if (bufferMin < x && x < bufferWidth) {
							buffer[bufferIndex] = color;
						} else {
							removeParticle(particle);
						}
					}
				} else if (numAdd) {
					// Add new
					if(addParticle(particle)) --numAdd;
				} else if (numEmit >= 0) {
					// Emit new
					addParticle(particle, _emitQueue[numEmit].coord);
					
					// Reduce the amount and let the loop create more particles as necessary
					--_emitQueue[numEmit].amount;
					if (_emitQueue[numEmit].amount <= 0) {
						_emitQueue.pop();
						--numEmit;
					}
				}
				
				// If more particles need to be emitted and the list is at the end, add more particles
				if (particle.next == null && (numAdd || numEmit > -1)) {
					particle = particle.next = createParticle();
				} else {
					particle = particle.next;
				}
			} while (particle);	
			
			_numParticles = length;
			
			if ((_willTriggerFlags & 0x02) != 0)  dispatchEvent(_eventChange);
			
			_bitmapData.lock();
			_bitmapData.setVector(_bitmapData.rect, buffer);
			_bitmapData.unlock(_bitmapData.rect);
		}
		
		//--------------------------------------
		//  Private
		//--------------------------------------
		
		/**
		 * It runs faster when this is inline, but is not extensible
		 * 
		 * @param	p
		 */
		override protected function additionalInit(p:ParticleVO, pt:Point):void {
			// Update position
			p.x = _mtx.tx;
			p.y = _mtx.ty;
		}
	}
}