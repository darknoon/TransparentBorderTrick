//
//  AppDelegate.m
//  TransparentBorderTrick
//
//  Created by Andrew Pouliot on 2/27/12.
//  Copyright (c) 2012 Darknoon. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
