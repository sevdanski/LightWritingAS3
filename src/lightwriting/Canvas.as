/**
 * lightwriting.Canvas
 *  * 
 * @author Andrew Sevenson
 */

package lightwriting
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Canvas extends BitmapData
	{
		private static const ZERO_POINT:Point = new Point();
		
		private var _brushPoint:Point = new Point(0, 0);
		private var _speedScale:Number = 1;
		
		public var brush:BitmapData;
		public var useSpeedScale:Boolean = false;
		public var blendMode:String = BlendMode.NORMAL;;
		
		
		/**
		 * Creates a new instance of the Canvas class.
		 */
		public function Canvas (width:Number=600, height:Number=400, transparent:Boolean = true, fillColor:uint = 0xffffffff) : void
		{
			super(width, height, transparent, fillColor);
		}
		
		
		// STATIC PUBLIC FUNCTIONS
		// ------------------------------------------------------------------------------------------
		
		
		// STATIC PRIVATE FUNCTIONS
		// ------------------------------------------------------------------------------------------
		
		
		// PUBLIC FUNCTIONS
		// ------------------------------------------------------------------------------------------
		/**
		 * A clean up routine that destroys all external references to prepare the class for garbage collection.
		 */
		public function destroy () : void
		{
			dispose();
			brush = null;
		}
		
		
		/**
		 * Moves the brush head to the given point without drawing a line
		 * @param	x
		 * @param	y
		 */
		public function moveTo(x:Number, y:Number):void
		{
			_brushPoint.x = x;
			_brushPoint.y = y;
		}
		
		
		/**
		 * Draws the current brush from the last point to this new point
		 * @param	x
		 * @param	y
		 */
		public function lineTo(x:Number, y:Number):void
		{
			if (!brush) return;	// bail if there are no brushes
			
			var dir:Point = new Point(x - _brushPoint.x, y - _brushPoint.y);
			var len:Number = Math.sqrt(dir.x * dir.x + dir.y * dir.y);
			var steps:uint = Math.ceil(len);
			
			// normalize the direction
			dir.x /= len;
			dir.y /= len;
			
			var speedScalePerc:Number = (useSpeedScale) ? 1 - clamp( (len - 10) / 20, 0.01, 0.5) : 1;
			var drawPT:Point = new Point();
			
			// reset the draw point
			drawPT.x = _brushPoint.x + dir.x;
			drawPT.y = _brushPoint.y + dir.y
			
			// loop through all of the steps
			for (var i:uint = 0; i < steps; i++) {
				drawPT.x += dir.x;
				drawPT.y += dir.y;
				if (i == steps - 1) { drawPT.x = x, drawPT.y = y; }
				drawBrushAtPoint(drawPT.x, drawPT.y, speedScalePerc);
			}
			
			// store this as the last place the brush was
			_brushPoint.x = x;
			_brushPoint.y = y;
			
		}
		
		

		private function clamp (value:Number, lowerBound:Number = 5e-324, upperBound:Number = 1.79e+308) : Number
		{
			if (value < lowerBound) return lowerBound;
			if (value > upperBound) return upperBound;
			return value;
		}		
		
		
		// PRIVATE FUNCTIONS
		// ------------------------------------------------------------------------------------------
		
		/**
		 * Draws the current brush bitmap at the given point
		 * @param	x
		 * @param	y
		 */
		private function drawBrushAtPoint(x:Number, y:Number, targetScale:Number=1):void
		{
			if (!brush) return;
			
			if (useSpeedScale) {
				_speedScale += (targetScale - _speedScale) * 0.2;
				
				var m:Matrix = new Matrix();
				m.scale(_speedScale, _speedScale);
				m.translate(x - (brush.width*_speedScale) * 0.5, y - (brush.height*_speedScale) * 0.5);
				
				draw(brush, m, null, blendMode, null, true);				
				
			} else {
				_speedScale = 1;
				var pt:Point = new Point( Math.round(x - brush.width*0.5), Math.round(y - brush.width*0.5) );
				copyPixels(brush, brush.rect, pt, brush,  ZERO_POINT, true);
			}
			

			
		}
		
		
		// EVENT HANDLERS
		// ------------------------------------------------------------------------------------------
		
		
		
		// GETTERS & SETTERS
		// ------------------------------------------------------------------------------------------
		
		
	}
}