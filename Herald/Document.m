//
//  Document.m
//  Herald
//
//  Created by Jason Terhorst on 5/19/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import "Document.h"

@interface Document ()
@property (nonatomic, weak) IBOutlet NSObjectController * documentObjectController;
@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    NSManagedObject * document = nil;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Document"];
    NSArray * sermons = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([sermons count] > 0)
    {
        document = [sermons firstObject];
    }
    else
    {
        document = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:self.managedObjectContext];
    }
    
    _documentObjectController.content = document;
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

@end
