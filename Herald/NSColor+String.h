//
//  NSColor+NSColor_String.h
//  Herald
//
//  Created by Jason Terhorst on 5/20/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (String)
- (NSString *)hexadecimalValue;
+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex;
@end
