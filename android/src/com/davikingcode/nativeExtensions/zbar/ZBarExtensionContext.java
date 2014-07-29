package com.davikingcode.nativeExtensions.zbar;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import net.sourceforge.zbar.Config;
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Symbol;

public class ZBarExtensionContext extends FREContext
{

	// ZBar Objects
	ImageScanner scanner;
	private boolean launched = false;

	private static final ZBarExtensionContext INSTANCE = new ZBarExtensionContext();

	private ZBarExtensionContext() {
		this.resetScanner();
	}

	public static ZBarExtensionContext getInstance() {
		return INSTANCE;
	}

	@Override
	public void dispose()
	{
		scanner.destroy();
		scanner = null;
	}

	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put( "decodeFromBitmapData", new ZBarDecodeFromBitmapData() );
		return functionMap;
	}

	private void resetScanner() {
		ImageScanner is = new ImageScanner();

		is.setConfig(0, Config.X_DENSITY, 1);
		is.setConfig(0, Config.Y_DENSITY, 1);
		is.setConfig(0, Config.ENABLE, 0);
		is.setConfig(Symbol.QRCODE, Config.ENABLE, 1);

		launched = true;
		scanner = is;
	}
	
	public boolean isLaunched() {
		return launched;
	}
	
	public ImageScanner getScanner() {
		return scanner;
	}
}
