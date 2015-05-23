//
//  Document.h
//  Herald
//
//  Created by Jason Terhorst on 5/19/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@interface Document : NSPersistentDocument
- (IBAction)importImage:(id)sender;
- (IBAction)exportImage:(id)sender;
- (IBAction)removeBackground:(id)sender;
@end
