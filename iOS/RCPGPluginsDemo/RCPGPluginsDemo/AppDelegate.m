//
//  RCPGPluginsDemoAppDelegate.m
//  RCPGPluginsDemo
//
//  Created by Gayane Minasyants on 11-11-16.
//  Copyright 2011 R & D Arts, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import <PhoneGap/PhoneGapViewController.h>
#import <RCPGPlugins/RCPGPushNotificationPlugin.h>

@implementation AppDelegate

@synthesize window=_window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    self.window = [ [ [ UIWindow alloc ] initWithFrame:screenBounds ] autorelease ];
    self.window.autoresizesSubviews = YES;
    
	PhoneGapViewController* controller = [[[PhoneGapViewController alloc] initWithLocalRoot:@"www" andStartURL:@"plugins.html"] autorelease];
    
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
	return YES;
}

- (RCPGPushNotificationPlugin* )pushNotificationPlugin {
    PhoneGapViewController* controller = (PhoneGapViewController* )self.window.rootViewController;
    
    id cmd = [controller getCommandInstance:@"com.rearden.rcpgpushnotification"];
    if (cmd && [cmd isKindOfClass:[RCPGPushNotificationPlugin class]])  {
        return cmd;
    }
    return nil;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    RCPGPushNotificationPlugin* pushNotification = [self pushNotificationPlugin];
    if (pushNotification) {
        [pushNotification performSelectorOnMainThread:@selector(applicationDidRegisterForRemoteNotificationsWithDeviceToken:) withObject:devToken waitUntilDone:YES];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    RCPGPushNotificationPlugin* pushNotification = [self pushNotificationPlugin];
    if (pushNotification) {
        [pushNotification performSelectorOnMainThread:@selector(applicationDidFailToRegisterForRemoteNotificationsWithError:) withObject:error waitUntilDone:YES];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    RCPGPushNotificationPlugin* pushNotification = [self pushNotificationPlugin];
    if (pushNotification) {
        [pushNotification performSelectorOnMainThread:@selector(applicationDidReceiveRemoteNotification:) withObject:userInfo waitUntilDone:YES];
    }    
}


- (void)dealloc {
    [_window release];
	[ super dealloc ];
}

@end