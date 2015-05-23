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
@property (nonatomic, weak) IBOutlet NSColorWell * colorWell;
@property (nonatomic, strong) SlideGenerator * imageGenerator;
- (IBAction)colorChanged:(id)sender;
@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (IBAction)importImage:(id)sender
{
	NSOpenPanel * openImagePanel = [NSOpenPanel openPanel];
	[openImagePanel setAllowedFileTypes:@[@"png",@"jpg"]];
	[openImagePanel setAllowsMultipleSelection:NO];
	[openImagePanel setAllowsOtherFileTypes:NO];

	NSModalResponse response = [openImagePanel runModal];
	if (response == NSModalResponseOK) {
		NSURL * fileURL = [openImagePanel URL];
		NSImage * image = [[NSImage alloc] initWithContentsOfURL:fileURL];
		NSData * imageData = [image TIFFRepresentation];

		SlideDocument * document = _documentObjectController.content;
		document.imageData = imageData;

		[self _updateImage];
	}
}

- (IBAction)removeBackground:(id)sender
{
	SlideDocument * document = _documentObjectController.content;
	document.imageData = nil;

	[self _updateImage];
}

- (IBAction)exportImage:(id)sender
{
	NSSavePanel * imageSavePanel = [NSSavePanel savePanel];
	[imageSavePanel setAllowedFileTypes:@[@"png"]];

	NSModalResponse response = [imageSavePanel runModal];
	if (response == NSModalResponseOK) {
		NSURL * fileURL = [imageSavePanel URL];

		SlideDocument * document = _documentObjectController.content;
		NSColor * backgroundColor = [NSColor colorFromHexadecimalValue:document.backgroundColor];
		NSImage * backgroundImage = nil;
		if (document.imageData) {
			backgroundImage = [[NSImage alloc] initWithData:document.imageData];
		}

		NSImage * outputImage = [_imageGenerator imageForTitle:document.title subtitle:document.subtitle details:document.detail moreInfo:document.moreInfo textColor:[NSColor whiteColor] backgroundColor:backgroundColor backgroundImage:backgroundImage width:1920];

		CGImageRef cgRef = [outputImage CGImageForProposedRect:NULL
												 context:nil
												   hints:nil];
		NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
		[newRep setSize:[outputImage size]];   // if you want the same resolution
		NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
		[pngData writeToURL:fileURL atomically:YES];
	}
}

- (IBAction)colorChanged:(id)sender
{
	SlideDocument * document = _documentObjectController.content;
	NSString * colorString = [_colorWell.color hexadecimalValue];
	NSLog(@"color: %@", colorString);
	document.backgroundColor = colorString;

	[self _updateImage];
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
	[_documentObjectController.content addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];
	[_documentObjectController.content addObserver:self forKeyPath:@"imageData" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_updateImage) object:nil];
    [self _updateImage];
}

- (void)_updateImage
{
    SlideDocument * document = _documentObjectController.content;
    NSColor * backgroundColor = [NSColor colorFromHexadecimalValue:document.backgroundColor];
	NSImage * backgroundImage = nil;
	if (document.imageData) {
		backgroundImage = [[NSImage alloc] initWithData:document.imageData];
	}
	
	_imagePreview.image = [_imageGenerator imageForTitle:document.title subtitle:document.subtitle details:document.detail moreInfo:document.moreInfo textColor:[NSColor whiteColor] backgroundColor:backgroundColor backgroundImage:backgroundImage width:_imagePreview.bounds.size.width];
	_colorWell.color = [NSColor colorFromHexadecimalValue:document.backgroundColor];
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
