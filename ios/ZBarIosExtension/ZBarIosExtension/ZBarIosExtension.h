//
//  ZBarIosExtension.m
//  ZBarIosExtension
//
// Created by Aymeric Lamboley on 01/08/2014.
// Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "zbar.h"
#import "ZBarReaderController.h"

@interface ZBarIosExtension : NSObject {

    ZBarReaderController *reader;
}

@property ZBarReaderController *reader;

+ (ZBarIosExtension *)sharedInstance;

@end