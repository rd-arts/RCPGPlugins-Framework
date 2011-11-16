/*
 *  Copyright (c) 2011 Rearden Commerce, Inc. All Rights Reserved.
 *
 *  THIS WORK IS SUBJECT TO U.S. AND INTERNATIONAL COPYRIGHT LAWS AND
 *  TREATIES. NO PART OF THIS WORK MAY BE USED, PRACTICED, PERFORMED
 *  COPIED, DISTRIBUTED, REVISED, MODIFIED, TRANSLATED, ABRIDGED,
 *  CONDENSED, EXPANDED, COLLECTED, COMPILED, LINKED, RECAST,
 *  TRANSFORMED OR ADAPTED WITHOUT THE PRIOR WRITTEN CONSENT OF
 *  REARDEN COMMERCE. ANY USE OR EXPLOITATION OF THIS WORK WITHOUT
 *  AUTHORIZATION COULD SUBJECT THE PERPETRATOR TO CRIMINAL AND CIVIL
 *  LIABILITY.
 */


#import "RCPGPushNotificationPlugin.h"


@implementation RCPGPushNotificationPlugin
@synthesize callbackID = _callbackID;

-(void)registerForNotifications:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
    //The first argument in the arguments parameter is the callbackID.
    //We use this to send data back to the successCallback or failureCallback
    //through PluginResult.   
    self.callbackID = [arguments pop];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
}

-(void)unregisterFromNotifications:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
#if !TARGET_IPHONE_SIMULATOR
    
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
	// Set the defaults to disabled unless we find otherwise...
	NSString *pushBadge = @"disabled";
	NSString *pushAlert = @"disabled";
	NSString *pushSound = @"disabled";
    
	// Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
	// one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
	// single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
	// true if those two notifications are on.  This is why the code is written this way
	if(rntypes == UIRemoteNotificationTypeBadge){
		pushBadge = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeAlert){
		pushAlert = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeSound){
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
		pushBadge = @"enabled";
		pushAlert = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)){
		pushBadge = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
		pushBadge = @"enabled";
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
    
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceUuid = dev.uniqueIdentifier;
    NSString *deviceName = dev.name;
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
    
	// Prepare the Device Token for Registration (remove spaces and < >)
	NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
	// Build URL String for Registration
	NSString *host = @"gateway.sandbox.push.apple.com:2195";
    
	NSString *urlString = [@"/apns.php?"stringByAppendingString:@"task=register"];
    
	urlString = [urlString stringByAppendingString:@"&appname="];
	urlString = [urlString stringByAppendingString:appName];
	urlString = [urlString stringByAppendingString:@"&appversion="];
	urlString = [urlString stringByAppendingString:appVersion];
	urlString = [urlString stringByAppendingString:@"&deviceuid="];
	urlString = [urlString stringByAppendingString:deviceUuid];
	urlString = [urlString stringByAppendingString:@"&devicetoken="];
	urlString = [urlString stringByAppendingString:deviceToken];
	urlString = [urlString stringByAppendingString:@"&devicename="];
	urlString = [urlString stringByAppendingString:deviceName];
	urlString = [urlString stringByAppendingString:@"&devicemodel="];
	urlString = [urlString stringByAppendingString:deviceModel];
	urlString = [urlString stringByAppendingString:@"&deviceversion="];
	urlString = [urlString stringByAppendingString:deviceSystemVersion];
	urlString = [urlString stringByAppendingString:@"&pushbadge="];
	urlString = [urlString stringByAppendingString:pushBadge];
	urlString = [urlString stringByAppendingString:@"&pushalert="];
	urlString = [urlString stringByAppendingString:pushAlert];
	urlString = [urlString stringByAppendingString:@"&pushsound="];
	urlString = [urlString stringByAppendingString:pushSound];
    
	// Register the Device Data
	NSURL *url = [[NSURL alloc] initWithScheme:@"https" host:host path:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
    NSURLResponse* response = nil;
    NSError* error = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSLog(@"Register URL: %@", url);
	NSLog(@"Return Data: %@", returnData);
        
#endif
}

- (void)applicationDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
#if !TARGET_IPHONE_SIMULATOR
    
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK 
                                                messageAsString:[[error localizedDescription] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];

#endif
}

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo {
    
#if !TARGET_IPHONE_SIMULATOR
    
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsDictionary:userInfo];
    [self writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];
    
#endif
}



@end
