//
//  SlideDocument.h
//  Herald
//
//  Created by Jason Terhorst on 5/23/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SlideDocument : NSManagedObject

@property (nonatomic, retain) NSString * backgroundColor;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * moreInfo;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) float backgroundImageOpacity;

@end
