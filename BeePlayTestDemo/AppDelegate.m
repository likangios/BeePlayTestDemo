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
    NSString *string = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    if ([string isEqualToString:@"com.apple.mobilesafari"]) {
        self.jumpStatus = @"1";
    }
    self.bgTask = [[BackgroundTask alloc]init];
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
    if (![[self currentViewController] isKindOfClass:[NSClassFromString(@"QYSessionViewController") class]]) {
        NSLog(@"打开小鱼赚钱客服");
    }
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (userInfo) {
        if (userInfo[@"nim"]) {
            [self openService];
        }
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

    if ([[notification alertAction] isEqualToString:@"打开"]) {
        [self openService];
    }
}
- (void)onBack:(id)arg1{
    __weak typeof(self)weakSelf = self;
    [[self currentViewController] dismissViewControllerAnimated:YES completion:^{
        [weakSelf openSafari];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    self.jumpStatus = @"0";
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if (self.isActive) {
        [_bgTask stopBackgroundTask];
        [self.timer invalidate];
    }
    if ([self isLogin] ) {
        [self.socketServer detectTaskWithoutTimer];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [MobClick endLogPageView:NSStringFromClass(self.class)];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:@"99"];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [MobClick endLogPageView:NSStringFromClass(self.class)];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (BOOL)isLogin{
    return [NSUserDefaults standardUserDefaults].uid.length;
}
- (void)dataUpdate:(id)arg1{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0 && self.isLogin) {
        LSAW_model *model =  [[LSAW_model alloc]init];
        [model appsDataUpdate];
    }
    if (self.socketServer) {
        [self.socketServer start];
    }
}
- (int)isScreenLocked{
    return 1;
}

- (BOOL)isJailBreak{
    return NO;
}
- (void)registerPushForIOS8{
    UIMutableUserNotificationAction *action =  [[UIMutableUserNotificationAction alloc]init];
    action.identifier = @"ACCEPT_IDENTIFIER";
    action.title = @"Accept";
    action.activationMode = UIUserNotificationActivationModeForeground;
    action.destructive = NO;
    action.authenticationRequired = NO;
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
    category.identifier = @"INVITE_CATEGORY";
    [category setActions:@[action] forContext:0];
    [category setActions:@[action] forContext:1];
    NSSet *aset = [NSSet setWithObjects:category, nil];
   UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:7 categories:aset];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:7];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
