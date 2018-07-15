//
//  ViewController.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/11.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "ViewController.h"
//#import <objc/runtime.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "sys/utsname.h"
#import "DTDSNetworkManager.h"

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <AdSupport/AdSupport.h>
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "CertViewController.h"
#import "LSAW_model.h"
#import "LSAP_model.h"

@interface ViewController ()


@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) WKWebView *wkView;


@end

@implementation ViewController
- (WKWebView *)wkView{
    if (!_wkView) {
        _wkView = [[WKWebView alloc]init];
    }
    return _wkView;
}
- (void)viewDidLoad {
//    http://www.xiaoyuzhuanqian.com/api/auth/config
    [super viewDidLoad];
    [self.view addSubview:self.wkView];
    [self.wkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    DTDSNetworkManager  * manager = [DTDSNetworkManager shareInstance];
    NSString * urlString = @"/api/auth/config";
    NSMutableDictionary *tParams = [NSMutableDictionary dictionary];
    [manager requestPOST:urlString parameters:tParams success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        [self saveDataWith:dic[@"return_data"]];
        
        [self.wkView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dic[@"return_data"][@"cert2_url"]]]];
        NSLog(@"dic is %@",dic);
    } failure:^(NSError *error) {
        
    }];

}
- (void)saveDataWith:(NSDictionary *)dic{
    [NSUserDefaults standardUserDefaults].apply_tmout = dic[@"apply_tmout"];
    [NSUserDefaults standardUserDefaults].shareStatus = dic[@"share_status"];
    [NSUserDefaults standardUserDefaults].guidePics = dic[@"guide_pics"];
    [NSUserDefaults standardUserDefaults].mainURL = dic[@"cert2_url"];
    [NSUserDefaults standardUserDefaults].certURL = dic[@"cert_url"];
    [NSUserDefaults standardUserDefaults].shareStatus = dic[@"share_status"];
    [NSUserDefaults standardUserDefaults].apply_tmout = [NSString stringWithFormat:@"%@",dic[@"apply_tmout"]];
    [NSUserDefaults standardUserDefaults].updateURL = dic[@"update_url"];
    NSString *function = dic[@"function"];
    if (function) {
       NSString *replaceFunc =  [function replaceString];
        NSString *decodeFunc = [replaceFunc base64Decode];
        NSData *data =  [decodeFunc dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [NSUserDefaults standardUserDefaults].function = dic;
    }
    [NSUserDefaults standardUserDefaults].adHideStatus = dic[@"ad_hide"];
    if ([NSUserDefaults standardUserDefaults].updateURL.length) {
        [self checkUpdate];
    }
    else{
        NSString *uid = [MSKeyChain load:@"udid"];
        if (uid.length) {
            [self handleJumpToWhichXYDestination];
        }
        else{
            [MSKeyChain delete:@"udid"];
            [self handleUDID];
        }
    }
    
    LSAW_model *model =  [[LSAW_model alloc]init];
    NSArray *item = model.allItems;
    
    [item enumerateObjectsUsingBlock:^(LSAP_model *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"identifier=%@,isAppStoreInstalled=%u,isHasInstalled=%ld,isNotFirstInstalled=%ld,isNowInstalling=%ld,isNowInstalled=%ld\n",obj.identifier,obj.isAppStoreInstalled,obj.isHasInstalled,obj.isNotFirstInstalled,obj.isNowInstalling,obj.isNowInstalled);
    }];
// 注册 tencentoauth  weibo
}

- (BOOL)isValidIdfa{
    return YES;
}
- (void)handleJumpToWhichXYDestination{
    if ([self isValidIdfa]) {
        AppDelegate *appdele =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdele.isActive = YES;
        [appdele.socketServer start];
        [self doLogin];
    }
    else{
        [self toSettingGuideViewController];
    }
}
- (void)handleUDID{
    CertViewController *cert = [[CertViewController alloc]init];
    [cert setBackAction:^{
        [self handleJumpToWhichXYDestination];
    }];
    [self presentViewController:cert animated:YES completion:NULL];
}
- (void)doLogin{
    
}
- (void)toSettingGuideViewController{
    
}

- (void)checkUpdate{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSObject *_workspace = [NSClassFromString(@"LSApplicationWorkspace") new];
    [_workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:@") withObject:@"com.perfay.doutushenqi" afterDelay:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
