package {

	import com.davikingcode.nativeExtensions.zbar.ZBar;
	import com.davikingcode.nativeExtensions.zbar.ZBarEvent;

	import flash.display.Sprite;

	[SWF(width='320', height='480', frameRate='30', backgroundColor='#000000')]

	public class ZBarTest extends Sprite {
		
		[Embed(source="/../../embed/qrcode.jpg")]
		private const qrCodeBitmap:Class;
		
		[Embed(source="/../../embed/logo.jpg")]
		private const logoBitmap:Class;

		public function ZBarTest() {
			
			var zbar:ZBar = new ZBar();
			zbar.addEventListener(ZBarEvent.SCAN, _zbarEvt);
			
			zbar.decodeFromBitmapData(new qrCodeBitmap().bitmapData);
			//zbar.decodeFromBitmapData(new logoBitmap().bitmapData);
		}

		private function _zbarEvt(zbEvt:ZBarEvent):void {
			
			trace(zbEvt.data);
		}
	}
}