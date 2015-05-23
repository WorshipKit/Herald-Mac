//
//  AppDelegate.m
//  Herald
//
//  Created by Jason Terhorst on 5/19/15.
//  Copyright (c) 2015 Worship Kit. All rights reserved.
//

#import "AppDelegate.h"

#import <HockeySDK/HockeySDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application

	[[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"b732696f90b3decfe6e3c1b3035985b1"];
	[[BITHockeyManager sharedHockeyManager] startManager];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
