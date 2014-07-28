package com.davikingcode.nativeExtensions.zbar;

import android.graphics.Bitmap;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREBitmapData;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import net.sourceforge.zbar.Image;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;
import net.sourceforge.zbar.SymbolSet;

public class ZBarDecodeFromBitmapData implements FREFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {

		FREObject retVal;
		retVal = null;

		try {
			FREBitmapData inputValue = (FREBitmapData)args[0];
			inputValue.acquire();
			int width = inputValue.getWidth();
			int height = inputValue.getHeight();
			int[] pixels = new int[width * height];
			Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
			bmp.copyPixelsFromBuffer(inputValue.getBits());
			
			bmp.getPixels(pixels, 0, width, 0, 0, width, height);
            

			ImageScanner reader = ZBarExtensionContext.getInstance().getScanner();
			Image myImage = new Image(width, height, "RGB4");
			myImage.setData(pixels);
			int result = reader.scanImage(myImage.convert("Y800"));

			inputValue.release();
			
			if (result != 0) {
				SymbolSet syms = reader.getResults();
				for (Symbol sym : syms) {
					ZBarExtensionContext freContext = ZBarExtensionContext.getInstance();
					freContext.dispatchStatusEventAsync("data", sym.getData());
					return null;
				}
			}
		} catch (Exception e) {
			return null;
		}

		return retVal;
	}
}