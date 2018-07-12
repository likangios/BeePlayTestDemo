//
//  ViewController.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/11.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "ViewController.h"
//#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (NSMutableDictionary *)defaultHeadDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_version"] = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    dic[@"app_key"] = @"5456ebbec93be";
    dic[@"ios_version"] = [[UIDevice currentDevice]systemVersion];
    dic[@"bundle_id"] = [[NSBundle mainBundle] bundleIdentifier];
    dic[@"ios_model"] = [self deviceModel];
    dic[@"carrier_code"] = [self carrier_code];
    dic[@"screen_width"] = [NSString stringWithFormat:@"%f",[UIScreen mainScreen].bounds.size.width];
    dic[@"screen_height"] = [NSString stringWithFormat:@"%f",[UIScreen mainScreen].bounds.size.height];
    dic[@"device_serial"] = [self device_serial];
    dic[@"now_idfa"] = [self nowIdfa];
    dic[@"auth_nonce"] = [NSString stringWithFormat:@"%d",arc4random()%100000 + 100000];
    dic[@"auth_timestamp"] = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];

    
    return dic;
}
- (NSString *)deviceModel{
    return @"";
}
- (NSString *)carrier_code{
    return nil;
}
- (NSString *)device_serial{
    return @"";
}
- (NSString *)nowIdfa{
    return @"";
}
- (void)viewDidLoad {
//    http://www.xiaoyuzhuanqian.com/api/auth/config
    [super viewDidLoad];
    NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:@{@"key1":@"value1",@"key2":@"value2"}];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"funcation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"funcation"];
    
    NSString *string = [dic objectForKeyedSubscript:@"key1"];
    
    NSData *base64Da = [[NSData alloc]initWithBase64EncodedString:string options:0];
    NSLog(@"%@",[[NSString alloc]initWithData:base64Da encoding:NSUTF8StringEncoding]);
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSObject *_workspace = [NSClassFromString(@"LSApplicationWorkspace") new];
    [_workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:@"com.perfay.doutushenqi" afterDelay:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
