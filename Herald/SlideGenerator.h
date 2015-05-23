//
//  SlideGenerator.h
//  Herald
//
//  Created by Jason Terhorst on 5/19/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface SlideGenerator : NSObject

- (NSImage *)imageForTitle:(NSString *)title subtitle:(NSString *)subtitle details:(NSString *)details moreInfo:(NSString *)moreInfo textColor:(NSColor *)textColor backgroundColor:(NSColor *)backgroundColor backgroundImage:(NSImage *)backgroundImage imageOpacity:(float)imageOpacity width:(CGFloat)width;

@end
