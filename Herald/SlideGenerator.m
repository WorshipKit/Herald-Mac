//
//  SlideGenerator.m
//  Herald
//
//  Created by Jason Terhorst on 5/19/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import "SlideGenerator.h"

@implementation SlideGenerator

- (NSImage *)imageForTitle:(NSString *)title subtitle:(NSString *)subtitle details:(NSString *)details moreInfo:(NSString *)moreInfo;
{
    NSImage * img = [[NSImage alloc] initWithSize:NSMakeSize(960, 720)];
    [img lockFocusFlipped:YES];
    
    [[NSColor blackColor] set];
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, 960, 720)] fill];
    
    
    
    [img unlockFocus];
    return img;
}

@end
