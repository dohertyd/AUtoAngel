//
//  AppDelegate.m
//  AutoAngel
//
//  Created by Derek Doherty on 23/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import "AppDelegate.h"
#import "libGolgi.h"
#import "GOLGI_KEYS.h"
#import "AutoAngelSvcGen.h"

@interface AppDelegate ()
@property (assign) int badgeCount;

@end

@implementation AppDelegate


- (void)setOurId:(NSString *)ourId
{
    [DemoSvc registerReportTempRequestHandler:^(id<DemoReportTempResultSender>resultSender, Temp *temp)
    {
        [resultSender success];
        int tempValueRec = (int)[temp getValue];
        
        NSLog(@"Received Report from Car Crash Detector >%d<  ", tempValueRec);
        _badgeCount++;
        [self setupLocalNotifications:@"Crash detected from User"];
        [self vibratePhone];
        
        // Adding a Badge to Icon if message received in the background
        if ( [UIApplication sharedApplication].applicationState == UIApplicationStateActive )
        {
            // app was already in the foreground
            NSLog(@"Received Message in foreground");
        } else
        {
            // app was just brought from background to foreground
            NSLog(@"Received Message in background ");
            //_badgeCount++;
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_badgeCount];
        }
        
    }];
    
    
    
    NSLog(@"SetOurID Function , Sending Golgi Registration: with Name = >%@<", ourId);
    
    // Registering with new API Format using Blocks
    [Golgi registerWithDevId:GOLGI_DEV_KEY
                       appId:GOLGI_APP_KEY
                      instId:ourId
            andResultHandler:^void(NSString *errText)
     {
         if(errText == nil)
         {
             NSLog(@"Golgi Registration: PASSED");
         } else
         {
             NSLog(@"Golgi Registration: FAIL => '%s'", [errText UTF8String]);
         }
     }];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken () , \nMy token is: %@", deviceToken);
    
#ifdef DEBUG
    [Golgi setDevPushToken:deviceToken];
    NSLog(@"Sending push token to Golgi Server for Development Pushes!");
#else
    [Golgi setProdPushToken:deviceToken];
    NSLog(@"Sending push token to Golgi Server for Production Pushes!");
#endif
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for remote notifications: %@", error);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    
    
    NSLog(@"applicationDidFinishLaunching()");
    
    _badgeCount = 0;
    
    if(launchOptions != nil) {
        NSLog(@"applicationDidFinishLaunching() but special case where Alert type notification has brought an off App back to Life");
        // Launched from push notification (Alert Type) Tapped on by user
        NSDictionary *d = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(d != nil) {
            [Golgi enteringBackground];
            [Golgi useEphemeralConnection];
        }
    }
    //
    // Lifted from StackOverflow, how to register for push
    // in a backwards compatible way for IOS 8 and IOS 7
    //
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    // Checking if Global pointer to ContactList is assigned, If not create a new one
    // use a local property to manipulate stuff in this class
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate setOurId:regId];
    [self setOurId:@"IOS"];
    
    _storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    if([Golgi isGolgiPushData:userInfo]) {
        NSLog(@"Received Push Notification(Routing to Golgi): %@", userInfo);
        
        [Golgi pushReceived:userInfo withCompletionHandler:completionHandler];
    } else {
        //
        // Not a PUSH for Golgi, handle as normal in the application
        //
        NSLog(@"Received Push Notification(Routing to App");
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    _badgeCount = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_badgeCount];
    //
    // GOLGI: Tell the framework that we are going into the background
    //
    NSLog(@"applicationDidEnterBackground()");
    [Golgi enteringBackground];
    [Golgi useEphemeralConnection];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    _badgeCount = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_badgeCount];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    _badgeCount = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_badgeCount];
    
    NSLog(@"applicationDidBecomeActive()");
    [Golgi enteringForeground];
    [Golgi usePersistentConnection];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
// NOTIFICATIONS

- (void)vibratePhone {
    
    if([[UIDevice currentDevice].model isEqualToString:@""]) {
        AudioServicesPlaySystemSound (1352); //works ALWAYS as of this post
        
    } else {
        // Not an iPhone, so doesn't have vibrate
        // play the less annoying tick noise or one of your own
        AudioServicesPlayAlertSound (1105);
    }
}

- (void)setupLocalNotifications:(NSString*) userName{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self registerForNotification];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 1 secs
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:1];
    
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = userName;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = _badgeCount; // increment
    
    //localNotification.userInfo = infoDict;
    
    localNotification.category = @"MSG"; //  Same as category identifier
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


- (void)registerForNotification {
    
    UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction1.identifier = @"Open";
    notificationAction1.title = @"Open";
    notificationAction1.activationMode = UIUserNotificationActivationModeForeground;
    notificationAction1.destructive = NO;
    notificationAction1.authenticationRequired = NO;
    
    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"MSG";
    [notificationCategory setActions:@[notificationAction1] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObjects:notificationCategory, nil];
    
    UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

@end
