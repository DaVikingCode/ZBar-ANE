//
//  ZBarIosExtension.m
//  ZBarIosExtension
//
//  Created by Aymeric Lamboley on 28/07/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "zbar.h"
#import "ZBarReaderController.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

DEFINE_ANE_FUNCTION(decodeFromBitmapData) {
    
    ZBarReaderController *reader = nil;
    FREGetContextNativeData(context, (void*)&reader);
    FREObject retVal = NULL;
    
    FREObject       objectBitmapData = argv[0];
    FREBitmapData2  bitmapData;
    
    FREAcquireBitmapData2(objectBitmapData, &bitmapData);
    
    int width       = bitmapData.width;
    int height      = bitmapData.height;
    
    // make data provider from buffer
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
    
    // set up for CGImage creation
    
    int                     bitsPerComponent    = 8;
    int                     bitsPerPixel        = 32;
    int                     bytesPerRow         = 4 * width;
    CGColorSpaceRef         colorSpaceRef       = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo            bitmapInfo;
    
    if( bitmapData.hasAlpha) {
        if(bitmapData.isPremultiplied)
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
        else
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;
    } else {
        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    }
    
    CGColorRenderingIntent  renderingIntent     = kCGRenderingIntentDefault;
    CGImageRef              imageRef            = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    id <NSFastEnumeration> results = [reader scanImage:imageRef];
    
    ZBarSymbol *sym = nil;
    
    for(sym in results) {
        
        if (sym) {
            NSLog(@"Found barcode! quality: %d string: %@", sym.quality, sym.data);
            FREDispatchStatusEventAsync(context, (uint8_t*)[@"data" UTF8String], (uint8_t*)[sym.data UTF8String]);
            break;
        }
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    FREReleaseBitmapData(objectBitmapData);
    
    FRENewObjectFromBool((uint32_t)YES, &retVal);
    return retVal;
}

void ZBarContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    
    ZBarReaderController *reader = [[ZBarReaderController alloc] init];
    reader.sourceType = UIImagePickerControllerSourceTypeCamera;
    [reader.scanner setSymbology: 0
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    [reader.scanner setSymbology: ZBAR_QRCODE
                          config: ZBAR_CFG_ENABLE
                              to: 1];
    
    FRESetContextNativeData(ctx, CFBridgingRetain(reader));
    
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION(decodeFromBitmapData, NULL )
    };
    
    *numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = functionMap;
    
}

void ZBarContextFinalizer(FREContext ctx) {
    return;
}

void ZBarExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    
    extDataToSet = NULL; // This example does not use any extension data.
    *ctxInitializerToSet = &ZBarContextInitializer;
    *ctxFinalizerToSet = &ZBarContextFinalizer;
}

void ZBarExtensionFinalizer() {
    return;
}