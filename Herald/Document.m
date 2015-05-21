//
//  Document.m
//  Herald
//
//  Created by Jason Terhorst on 5/19/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import "Document.h"
#import "SlideGenerator.h"
#import "SlideDocument.h"
#import "NSColor+String.h"

@interface Document ()
@property (nonatomic, weak) IBOutlet NSObjectController * documentObjectController;
@property (nonatomic, weak) IBOutlet NSImageView * imagePreview;
@property (nonatomic, strong) SlideGenerator * imageGenerator;
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
    
    SlideDocument * document = nil;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SlideDocument"];
    NSArray * sermons = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([sermons count] > 0)
    {
        document = [sermons firstObject];
    }
    else
    {
        document = [NSEntityDescription insertNewObjectForEntityForName:@"SlideDocument" inManagedObjectContext:self.managedObjectContext];
    }
    
    _documentObjectController.content = document;
    
    _imageGenerator = [[SlideGenerator alloc] init];
    [self _updateImage];

	[_documentObjectController.content addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
	[_documentObjectController.content addObserver:self forKeyPath:@"subtitle" options:NSKeyValueObservingOptionNew context:nil];
	[_documentObjectController.content addObserver:self forKeyPath:@"detail" options:NSKeyValueObservingOptionNew context:nil];
	[_documentObjectController.content addObserver:self forKeyPath:@"moreInfo" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_updateImage) object:nil];
    [self _updateImage];
}

- (void)_updateImage
{
    SlideDocument * document = _documentObjectController.content;
    NSColor * backgroundColor = [NSColor purpleColor];//[NSColor colorFromHexadecimalValue:document.backgroundColor];
    
    _imagePreview.image = [_imageGenerator imageForTitle:document.title subtitle:document.subtitle details:document.detail moreInfo:document.moreInfo textColor:[NSColor whiteColor] backgroundColor:backgroundColor];
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
