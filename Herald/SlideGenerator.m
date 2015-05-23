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

- (NSImage *)imageForTitle:(NSString *)title subtitle:(NSString *)subtitle details:(NSString *)details moreInfo:(NSString *)moreInfo textColor:(NSColor *)textColor backgroundColor:(NSColor *)backgroundColor backgroundImage:(NSImage *)backgroundImage width:(CGFloat)width;
{
	//CGFloat scale = [[NSScreen mainScreen] backingScaleFactor];
	CGFloat aspect = 9.0f/16.0f;
	CGSize size = {width,width * aspect};
    NSImage * img = [[NSImage alloc] initWithSize:size];
    [img lockFocusFlipped:YES];
    
    [backgroundColor set];
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, size.width, size.height)] fill];

	if (backgroundImage) {
		CGSize imageSize = [backgroundImage size];
		//CGFloat imageRatio = imageSize.height/imageSize.width;
		if (imageSize.width > imageSize.height) {
			CGFloat imageScale = imageSize.width/size.width;
			imageSize.width = imageSize.width * imageScale;
			imageSize.height = imageSize.height * imageScale;
		} else {
			CGFloat imageScale = imageSize.height/size.height;
			imageSize.height = imageSize.height * imageScale;
			imageSize.width = imageSize.width * imageScale;
		}

		CGRect imageRect = CGRectMake((size.width - imageSize.width)/2, (size.height - imageSize.height)/2, imageSize.width, imageSize.height);
		[backgroundImage drawInRect:imageRect];
	}

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

	CGFloat shadowOffset = (2.0/960.0)*size.width;
    CGFloat padding = size.width*0.0833;
    CGFloat textWidth = size.width - (padding*2);
    CGSize textAvailableSize = {textWidth,size.height};
    
    NSShadow * textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [[NSColor blackColor] colorWithAlphaComponent:0.5];
    textShadow.shadowBlurRadius = 0.5;
    textShadow.shadowOffset = NSMakeSize(shadowOffset, -shadowOffset);
	CGFloat titleFontSize = size.width*0.069;
    NSFont * titleFont = [NSFont fontWithName:@"MyriadPro-Bold" size:titleFontSize];
	if (!titleFont) {
		titleFont = [NSFont fontWithName:@"Helvetica-Bold" size:titleFontSize];
	}
    NSStringDrawingOptions options = NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesLineFragmentOrigin;

	CGFloat topSpacing = size.height*0.15;
	CGFloat extraWidth = size.width*0.019;
	CGFloat extraLineHeight = size.height * 0.013;

    NSDictionary * titleAttribs = @{NSFontAttributeName:titleFont,NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle, NSShadowAttributeName:textShadow};
	CGRect titleBoundingRect = [title boundingRectWithSize:textAvailableSize options:options attributes:titleAttribs];
	CGSize titleSize = titleBoundingRect.size;
	titleSize.width = titleSize.width + titleBoundingRect.origin.x;
	titleSize.height = titleSize.height + titleBoundingRect.origin.y;
    CGRect titleRect = {padding,topSpacing,titleSize.width + extraWidth,titleSize.height + extraLineHeight};
    [title drawWithRect:titleRect options:options attributes:titleAttribs];
    
    NSDictionary * subtitleAttribs = @{NSFontAttributeName:[NSFont fontWithName:[titleFont fontName] size:[titleFont pointSize]*0.85], NSForegroundColorAttributeName:[textColor colorWithAlphaComponent:0.7], NSParagraphStyleAttributeName:paragraphStyle};
	CGRect subtitleBoundingRect = [subtitle boundingRectWithSize:textAvailableSize options:options attributes:subtitleAttribs];
	CGSize subtitleSize = subtitleBoundingRect.size;
	subtitleSize.width = subtitleSize.width + subtitleBoundingRect.origin.x;
	subtitleSize.height = subtitleSize.height + subtitleBoundingRect.origin.y;
    CGRect subtitleRect = {titleRect.origin.x,titleRect.origin.y+titleRect.size.height+extraLineHeight,subtitleSize.width + extraWidth,subtitleSize.height+extraLineHeight};
    [subtitle drawWithRect:subtitleRect options:options attributes:subtitleAttribs];

    NSDictionary * detailAttribs = @{NSFontAttributeName:[NSFont fontWithName:[titleFont fontName] size:[titleFont pointSize]*0.7], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize detailSize = [details boundingRectWithSize:textAvailableSize options:options attributes:detailAttribs].size;
    CGRect detailRect = {titleRect.origin.x,subtitleRect.origin.y+subtitleRect.size.height+extraLineHeight,detailSize.width + extraLineHeight,detailSize.height + extraLineHeight};
    [details drawWithRect:detailRect options:options attributes:detailAttribs];

    NSFont * infoFont = [[NSFontManager sharedFontManager] convertFont:titleFont toNotHaveTrait:NSFontBoldTrait];
    NSDictionary * infoAttribs = @{NSFontAttributeName:[NSFont fontWithName:[infoFont fontName] size:[titleFont pointSize]*0.5], NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize infoSize = [moreInfo boundingRectWithSize:textAvailableSize options:options attributes:infoAttribs].size;
    CGRect infoRect = {titleRect.origin.x,detailRect.origin.y+detailRect.size.height + extraLineHeight,infoSize.width + extraWidth,infoSize.height + extraLineHeight};
    [moreInfo drawWithRect:infoRect options:options attributes:infoAttribs];
    
    
    [img unlockFocus];
    return img;
}

@end
