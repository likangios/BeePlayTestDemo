//
//  AppDelegate.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/11.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UMConfigure initWithAppkey:@"5affe86c8f4a9d1bf80001ae" channel:@"企业"];
    [WXApi registerApp:@"wx5f45fbed1936646e"];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return YES;
}
- (XYSocketServer *)socketServer{
    if (!_socketServer) {
        NSString *port =  [NSUserDefaults standardUserDefaults].port;
        if (port) {
            _socketServer = [[XYSocketServer alloc]initWithPort:port.intValue];
        }
    }
    return _socketServer;
}
- (void)requestAuthor{
    
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
            }];
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
            }];
            
        } else {
            [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        }
        
}

- (void)initSever:(NSInteger)port{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"web" ofType:nil];
    NSFileManager *fileManager =  [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *webPath = [paths.lastObject stringByAppendingString:@"/web"];
    if (![fileManager isExecutableFileAtPath:webPath]) {
        [self copyMissingFile:path toPath:webPath];
    }
    [self playBackground];
    [self configLocalHttpServer:port];
}
- (void)playBackground{
    
}
- (void)configLocalHttpServer:(NSInteger)port{
    
}
- (void)copyMissingFile:(NSString *)file toPath:(NSString *)path{
    
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    NSMutableDictionary *v60 = [[NSMutableDictionary alloc]init];
    NSArray *array = [url.query componentsSeparatedByString:@"$"];
    [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *keyValue = [obj componentsSeparatedByString:@"=="];
        [v60 setObject:keyValue[1] forKey:keyValue[0]];
    }];
    if ([v60[@"action"] isEqualToString:@"cert"]) {
        NSString *udid = v60[@"udid"];
        udid = [udid URLDecode];
        udid = [[udid replaceString] base64Decode];
        [MSKeyChain save:@"udid" data:udid];
    }
    else{
        if (!self.isActive) {
            return NO;
        }
        self.hideADs = YES;
        //分享
        if ([v60[@"action"] isEqualToString:@"share"]) {
            
        }
        //体现
        else if ([v60[@"action"] isEqualToString:@"exchange"]){
           
            
        }
        else if ([v60[@"action"] isEqualToString:@"service"]){
            [self openService];
            return YES;
        }
        else if ([v60[@"action"] isEqualToString:@"jumpsafari"]){
            self.jumpStatus = @"1";
            return YES;
        }
        else if ([v60[@"action"] isEqualToString:@"systemshare"]){
            return YES;
        }
        else{
            return YES;
        }
    }
    
    return YES;
}
- (void)openSafari{
    [[[LSAW_model alloc]init] openAppWithIdentifier:@"com.apple.mobilesafari"];
}
- (void)openService{
    
}
- (UIViewController *)currentViewController{
    UIViewController *v6;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
        while (v6.presentedViewController) {
            v6 = v6.presentedViewController;
        }
    }
    return v6;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
