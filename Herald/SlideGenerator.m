//
//  SlideGenerator.m
//  Herald
//
//  Created by Jason Terhorst on 5/19/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import "SlideGenerator.h"
#import "NSColor+String.h"

@implementation SlideGenerator

- (NSImage *)imageForTitle:(NSString *)title subtitle:(NSString *)subtitle details:(NSString *)details moreInfo:(NSString *)moreInfo textColor:(NSColor *)textColor backgroundColor:(NSColor *)backgroundColor;
{
    CGSize imageSize = {960,720};
    NSImage * img = [[NSImage alloc] initWithSize:imageSize];
    [img lockFocusFlipped:YES];
    
    [backgroundColor set];
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, imageSize.width, imageSize.height)] fill];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGFloat padding = 50;
    CGFloat textWidth = imageSize.width - (padding*2);
    CGSize textAvailableSize = {textWidth,720};
    
    NSShadow * textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [[NSColor blackColor] colorWithAlphaComponent:0.5];
    textShadow.shadowBlurRadius = 0.5;
    textShadow.shadowOffset = NSMakeSize(2, -2);
    NSFont * titleFont = [NSFont fontWithName:@"Helvetica-Bold" size:72];
    NSStringDrawingOptions options = NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesLineFragmentOrigin;
    
    NSDictionary * titleAttribs = @{NSFontAttributeName:titleFont,NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
    CGSize titleSize = [title boundingRectWithSize:textAvailableSize options:options attributes:titleAttribs].size;
    CGRect titleRect = {padding,padding,titleSize.width,titleSize.height + 10};
    [title drawWithRect:titleRect options:options attributes:titleAttribs];
    
    NSDictionary * subtitleAttribs = @{NSFontAttributeName:[NSFont fontWithName:[titleFont fontName] size:[titleFont pointSize]*0.85], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
    CGSize subtitleSize = [subtitle boundingRectWithSize:textAvailableSize options:options attributes:subtitleAttribs].size;
    CGRect subtitleRect = {titleRect.origin.x,titleRect.origin.y+titleRect.size.height+10,subtitleSize.width,subtitleSize.height};
    [subtitle drawWithRect:subtitleRect options:options attributes:subtitleAttribs];
    
    NSDictionary * detailAttribs = @{NSFontAttributeName:[NSFont fontWithName:@"Helvetica" size:[titleFont pointSize]*0.75], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
    CGSize detailSize = [details boundingRectWithSize:textAvailableSize options:options attributes:detailAttribs].size;
    CGRect detailRect = {titleRect.origin.x,subtitleRect.origin.y+subtitleRect.size.height+20,detailSize.width,detailSize.height+20};
    [details drawWithRect:detailRect options:options attributes:detailAttribs];
    
    NSDictionary * infoAttribs = @{NSFontAttributeName:[NSFont fontWithName:@"Helvetica-BoldOblique" size:[titleFont pointSize]*0.5], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
    CGSize infoSize = [moreInfo boundingRectWithSize:textAvailableSize options:options attributes:infoAttribs].size;
    CGRect infoRect = {titleRect.origin.x,detailRect.origin.y+detailRect.size.height+20,infoSize.width,infoSize.height+20};
    [moreInfo drawWithRect:infoRect options:options attributes:infoAttribs];
    
    
    [img unlockFocus];
    return img;
}

@end
