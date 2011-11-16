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

#import <PhoneGap/PGPlugin.h>

@interface RCPGPushNotificationPlugin : PGPlugin {
    NSString* _callbackID;
}
@property (nonatomic, copy) NSString* callbackID;

- (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken;
- (void)applicationDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;


@end
