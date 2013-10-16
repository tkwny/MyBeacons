//
//  RLBAppDelegate.m
//  MyBeacons
//
//  Created by Randy Bradshaw on 10/8/13.
//  Copyright (c) 2013 Randy Bradshaw. All rights reserved.
//

#import "RLBAppDelegate.h"

@implementation RLBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    /*
    NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:10];
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* notifiyAlarm = [[UILocalNotification alloc] init];
    if(notifiyAlarm)
    {
        notifiyAlarm.fireDate = alertTime;
        notifiyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifiyAlarm.repeatInterval = 0;
        notifiyAlarm.soundName = @"bell_tree.mp3";
        notifiyAlarm.alertBody = @"Locating iBeacons";
        [app scheduleLocalNotification:notifiyAlarm];
     }
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}
-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}


@end
