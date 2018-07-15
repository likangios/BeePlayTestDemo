//
//  XYWebViewJSObject.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/15.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol XYWebViewAPI <JSExport>
- (NSDictionary *)xyopensafari:(NSDictionary *)arg1;
- (NSDictionary *)xycheckjumptosafari:(NSDictionary *)arg1;
- (NSDictionary *)xycompletecert:(NSDictionary *)arg1;
- (NSDictionary *)xycheckudid:(NSDictionary *)arg1;
- (NSDictionary *)xyloadingpage:(NSDictionary *)arg1;
- (NSDictionary *)xyservice:(NSDictionary *)arg1;
@end

@interface XYWebViewJSObject : NSObject<XYWebViewAPI>

@property(retain, nonatomic) UIWindow *jumpWindow; // @synthesize jumpWindow=_jumpWindow;
@property(retain, nonatomic) NSTimer *timer; // @synthesize timer=_timer;
@property(nonatomic) __weak UIWebView *webView; // @synthesize webView=_webView;
@property(nonatomic) __weak JSContext *jsContext; // @synthesize jsContext=_jsContext;
@property(nonatomic) __weak UIViewController *viewController; // @synthesize viewController=_viewController;
- (id)xyopensafari:(id)arg1;
- (id)xycheckjumptosafari:(id)arg1;
- (id)xycompletecert:(id)arg1;
- (id)xycheckudid:(id)arg1;
- (id)xyloadingpage:(id)arg1;
- (id)xyservice:(id)arg1;
- (_Bool)isAppStoreInstalledWithIdentifier:(id)arg1;
- (_Bool)isHasInstalledWithIdentifier:(id)arg1;
- (_Bool)isNotFirstInstalledWithIdentifier:(id)arg1;
- (_Bool)isNowInstallingWithIdentifier:(id)arg1;
- (_Bool)isNowInstalledWithIdentifier:(id)arg1;
- (void)appsDataAppend:(id)arg1;
- (void)appsDataUpdate;
- (void)openAppWithIdentifier:(id)arg1;
- (id)allInstalledItems;
- (id)allItems;
@end
