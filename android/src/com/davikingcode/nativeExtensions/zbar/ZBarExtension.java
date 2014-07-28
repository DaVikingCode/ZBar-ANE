package com.davikingcode.nativeExtensions.zbar;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class ZBarExtension implements FREExtension
{
	@Override
	public FREContext createContext( String label )
	{
		return ZBarExtensionContext.getInstance();
	}

	@Override
	public void dispose()
	{
		ZBarExtensionContext.getInstance().dispose();
	}

	@Override
	public void initialize()
	{
	}
}
