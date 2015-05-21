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
	//CGFloat scale = [[NSScreen mainScreen] backingScaleFactor];
    CGSize imageSize = {960,720};
    NSImage * img = [[NSImage alloc] initWithSize:imageSize];
    [img lockFocusFlipped:YES];
    
    [backgroundColor set];
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, imageSize.width, imageSize.height)] fill];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGFloat padding = 80;
    CGFloat textWidth = imageSize.width - (padding*2);
    CGSize textAvailableSize = {textWidth,720};
    
    NSShadow * textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [[NSColor blackColor] colorWithAlphaComponent:0.5];
    textShadow.shadowBlurRadius = 0.5;
    textShadow.shadowOffset = NSMakeSize(2, -2);
    NSFont * titleFont = [NSFont fontWithName:@"MyriadPro-Bold" size:72];
	if (!titleFont) {
		titleFont = [NSFont fontWithName:@"Helvetica-Bold" size:72];
	}
    NSStringDrawingOptions options = NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesLineFragmentOrigin;
    
    NSDictionary * titleAttribs = @{NSFontAttributeName:titleFont,NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
	CGRect titleBoundingRect = [title boundingRectWithSize:textAvailableSize options:options attributes:titleAttribs];
	CGSize titleSize = titleBoundingRect.size;
	titleSize.width = titleSize.width + titleBoundingRect.origin.x;
	titleSize.height = titleSize.height + titleBoundingRect.origin.y;
    CGRect titleRect = {padding,130,titleSize.width + 20,titleSize.height + 30};
    [title drawWithRect:titleRect options:options attributes:titleAttribs];
    
    NSDictionary * subtitleAttribs = @{NSFontAttributeName:[NSFont fontWithName:[titleFont fontName] size:[titleFont pointSize]*0.85], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
	CGRect subtitleBoundingRect = [subtitle boundingRectWithSize:textAvailableSize options:options attributes:subtitleAttribs];
	CGSize subtitleSize = subtitleBoundingRect.size;
	subtitleSize.width = subtitleSize.width + subtitleBoundingRect.origin.x;
	subtitleSize.height = subtitleSize.height + subtitleBoundingRect.origin.y;
    CGRect subtitleRect = {titleRect.origin.x,titleRect.origin.y+titleRect.size.height+20,subtitleSize.width + 20,subtitleSize.height+30};
    [subtitle drawWithRect:subtitleRect options:options attributes:subtitleAttribs];

	NSFont * detailFont = [[NSFontManager sharedFontManager] convertFont:titleFont toNotHaveTrait:NSFontBoldTrait];
    NSDictionary * detailAttribs = @{NSFontAttributeName:[NSFont fontWithName:[detailFont fontName] size:[titleFont pointSize]*0.75], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
    CGSize detailSize = [details boundingRectWithSize:textAvailableSize options:options attributes:detailAttribs].size;
    CGRect detailRect = {titleRect.origin.x,subtitleRect.origin.y+subtitleRect.size.height+20,detailSize.width + 20,detailSize.height+20};
    [details drawWithRect:detailRect options:options attributes:detailAttribs];
    
    NSDictionary * infoAttribs = @{NSFontAttributeName:[NSFont fontWithName:[titleFont fontName] size:[titleFont pointSize]*0.5], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
    CGSize infoSize = [moreInfo boundingRectWithSize:textAvailableSize options:options attributes:infoAttribs].size;
    CGRect infoRect = {titleRect.origin.x,detailRect.origin.y+detailRect.size.height+20,infoSize.width + 20,infoSize.height+40};
    [moreInfo drawWithRect:infoRect options:options attributes:infoAttribs];
    
    
    [img unlockFocus];
    return img;
}

@end
