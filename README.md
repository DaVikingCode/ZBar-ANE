ZBar-ANE
========

Based on [luarpro](https://github.com/luarpro/BitmapDataQRCodeScanner) ZBar's ANE. We wanted to have a default implementation for iOS & Android.

Note: This ANE doesn't manage camera stuff, it takes a bitmap data as an argument.

```actionscript3
var zbar:ZBar = new ZBar();
zbar.addEventListener(ZBarEvent.SCAN, _zbarEvt);

zbar.decodeFromBitmapData(new qrCodeBitmap().bitmapData);

private function _zbarEvt(zbEvt:ZBarEvent):void {

	trace(zbEvt.data);
}
```