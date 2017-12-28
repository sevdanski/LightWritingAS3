/**
 * lightwriting.FreeDraw
 * 
 * @author Andrew Sevenson
*/

package lightwriting
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import lightwriting.Canvas;

	
	public class LightWriting extends Sprite
	{
		
		private static var ZERO_PT:Point = new Point();

		[Embed(source='../../lib/background.jpg')]
		private var BD_background:Class;		
		
		[Embed(source='../../lib/WhiteSoft.png')]
		private var BD_whiteSoft:Class;
		
		[Embed(source='../../lib/WhiteInner.png')]
		private var BD_whiteInner:Class;
		
		private var _background:Bitmap;
		private var _fadedGlowCanvas:Canvas, _fadedGlowCanvasBMP:Bitmap;
		private var _whiteOverlayCanvas:Canvas, _whiteOverlayCanvasBMP:Bitmap;
		private var _lastPoint:Point = new Point(0, 0);	
		private var _fadedGlowBlurFilter:BlurFilter;
		private var _whiteOverlayBlurFilter:BlurFilter;
		
		
		/**
		 * Creates a new instance of the Main class.
		 */
		public function LightWriting () : void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		// STATIC PUBLIC FUNCTIONS
		// ------------------------------------------------------------------------------------------
		
		
		// STATIC PRIVATE FUNCTIONS
		// ------------------------------------------------------------------------------------------
		
		
		// PUBLIC FUNCTIONS
		// ------------------------------------------------------------------------------------------
		
		
		// PRIVATE FUNCTIONS
		// ------------------------------------------------------------------------------------------
		/**
		 * Initialises the application.
		 * @param	e	The Event object.
		 */
		private function init (e:Event = null) : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_background = new BD_background();
			_background.width = 1024;
			_background.height = 768;
			addChild(_background);
			
			// fading glow thingy - note I have made it bigger than it needs to be
			_fadedGlowCanvas = new Canvas(1024, 768, true, 0x00000000);
			_fadedGlowCanvasBMP = new Bitmap(_fadedGlowCanvas);
			addChild(_fadedGlowCanvasBMP);
			
			_fadedGlowCanvas.useSpeedScale = true;
			_fadedGlowCanvas.brush = new BD_whiteSoft().bitmapData;
			_fadedGlowCanvas.moveTo(_fadedGlowCanvasBMP.mouseX, _fadedGlowCanvasBMP.mouseY);
			
			
			// white overlay glow thingy
			_whiteOverlayCanvas = new Canvas(_fadedGlowCanvas.width, _fadedGlowCanvas.height, true, 0x00000000);
			_whiteOverlayCanvasBMP = new Bitmap(_whiteOverlayCanvas);
			addChild(_whiteOverlayCanvasBMP);
			
			_whiteOverlayCanvas.useSpeedScale = true;
			_whiteOverlayCanvas.brush = new BD_whiteInner().bitmapData;
			_whiteOverlayCanvas.moveTo(_whiteOverlayCanvasBMP.mouseX, _whiteOverlayCanvasBMP.mouseY);			
			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			var blurFactor:Number = 6;
			_fadedGlowBlurFilter = new BlurFilter(blurFactor,blurFactor);
			_whiteOverlayBlurFilter = new BlurFilter(blurFactor/3,blurFactor/3);
			
		}

		
		
		// EVENT HANDLERS
		// ------------------------------------------------------------------------------------------
		
		
		
		private function onEnterFrame(e:Event):void 
		{
			_fadedGlowCanvas.applyFilter(_fadedGlowCanvas, _fadedGlowCanvas.rect, ZERO_PT, _fadedGlowBlurFilter);
			_whiteOverlayCanvas.applyFilter(_whiteOverlayCanvas, _whiteOverlayCanvas.rect, ZERO_PT, _whiteOverlayBlurFilter);
			
			_fadedGlowCanvas.lineTo(_fadedGlowCanvasBMP.mouseX, _fadedGlowCanvasBMP.mouseY);
			_whiteOverlayCanvas.lineTo(_whiteOverlayCanvasBMP.mouseX, _whiteOverlayCanvasBMP.mouseY);
		}		
		
		// GETTERS & SETTERS
		// ------------------------------------------------------------------------------------------
	}
}