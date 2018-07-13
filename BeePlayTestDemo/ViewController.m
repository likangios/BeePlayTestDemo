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
- (NSMutableDictionary *)defaultHeadDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"app_version"] = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    dic[@"app_key"] = @"5456ebbec93be";
    dic[@"ios_version"] = @"11.1";
    
    dic[@"bundle_id"] = [[NSBundle mainBundle] bundleIdentifier];
    dic[@"ios_model"] = [self deviceModel];
    dic[@"carrier_code"] = [self carrier_code];
    dic[@"bssid"] = [self bssid];

    dic[@"screen_width"] = [NSString stringWithFormat:@"%f",[UIScreen mainScreen].bounds.size.width];
    dic[@"screen_height"] = [NSString stringWithFormat:@"%f",[UIScreen mainScreen].bounds.size.height];
    dic[@"device_serial"] = [self idfa];
    dic[@"now_idfa"] = [self nowIdfa];
    dic[@"auth_nonce"] = [NSString stringWithFormat:@"%d",arc4random()%100000 + 100000];
    dic[@"auth_timestamp"] = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];

    
    return dic;
}

- (NSString *)deviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}
- (NSString *)carrier_code{
    if ([self hasCellularCoverage]) {
        CTTelephonyNetworkInfo *telep = [CTTelephonyNetworkInfo new];
        NSString * CountryCode =  telep.subscriberCellularProvider.mobileCountryCode;
        NSString * NetworkCode =  telep.subscriberCellularProvider.mobileNetworkCode;
        return [NSString stringWithFormat:@"%@%@",CountryCode,NetworkCode];
    }
    return nil;
}
//    return @"FABBE34C-C0EE-4B79-A18C-84301162BB90"

- (NSString *)idfa{
    return @"FABBE34C-C0EE-4B79-A18C-84301162BB9B";
    return [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
}
- (NSString *)nowIdfa{
    return @"FABBE34C-C0EE-4B79-A18C-84301162BB9B";
    return [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
}
- (NSString *)bssid{
    return @"78:8a:20:ff:b7:e5";
}
- (NSString *)authSignatureWithDictionary:(NSDictionary *)dic{
    NSString *parString = [self paramStringWithSortDictionary:dic];
    NSString *key = @"19207077765456ebbec9";

    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [parString cStringUsingEncoding:NSASCIIStringEncoding];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    NSMutableString *result = [NSMutableString string];
    for(int i =0; i < 20; i++) {
        [result appendFormat:@"%02x", cHMAC[i]];
    }
    
    return [result lowercaseString];

}
- (NSString  *)paramStringWithSortDictionary:(NSDictionary *)dic{
    
    NSArray *allkeys = dic.allKeys;
    NSArray *sortArray =  [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj1 < obj2;
    }];
    NSMutableString *muStr = [[NSMutableString alloc]init];
    [sortArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [muStr appendString:[NSString stringWithFormat:@"%@=%@",obj,dic[obj]]];
    }];
    return muStr;
}
-(BOOL)hasCellularCoverage{
    CTTelephonyNetworkInfo *telep = [CTTelephonyNetworkInfo new];
    return  [telep.subscriberCellularProvider isoCountryCode] != nil;
}
- (void)viewDidLoad {
//    http://www.xiaoyuzhuanqian.com/api/auth/config
    [super viewDidLoad];
    [self.view addSubview:self.wkView];
    [self.wkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:@{@"key1":@"value1",@"key2":@"value2"}];
//    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"funcation"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"funcation"];
//
//    NSString *string = [dic objectForKeyedSubscript:@"key1"];
//
//    NSData *base64Da = [[NSData alloc]initWithBase64EncodedString:string options:0];
//    NSLog(@"%@",[[NSString alloc]initWithData:base64Da encoding:NSUTF8StringEncoding]);
    
    DTDSNetworkManager  * manager = [DTDSNetworkManager shareInstance];
    NSString * urlString = @"/api/auth/config";
    NSMutableDictionary *tParams = [self defaultHeadDictionary];
    
    /*
     [HttpRequest authSignatureWithDictionary:@{@"key":@"value"}]
     @"26c1d610b83e796e4ef95cd0d77464feaab53a97"
     */
    
    NSDictionary *authDic = [NSDictionary dictionaryWithObjectsAndKeys:[self authSignatureWithDictionary:tParams],@"auth_signature", nil];
    [tParams addEntriesFromDictionary:authDic];
    NSLog(@"auth_signature====%@",[self authSignatureWithDictionary:@{@"key":@"value"}]);
    
    NSDictionary *dic = @{@"ios_version":@"9.3.2",@"carrier_code":@"46000",@"bundle_id":@"com.xiaoyu.qian",@"now_idfa":@"FABBE34C-C0EE-4B79-A18C-84301162BB90",@"app_version":@"9.2.0",@"auth_timestamp":@"1531471308",@"screen_height":@"736.000000",@"bssid":@"78:8a:20:ff:b7:e6",@"auth_nonce":@"137352",@"device_serial":@"FABBE34C-C0EE-4B79-A18C-84301162BB90",@"screen_width":@"414.000000",@"ios_model":@"iPhone7,1",@"app_key":@"5456ebbec93be",@"auth_signature":@"476e9a9dc7f46a2a7edbad7bbd5c281f8486d423"};
    
    [manager requestPOST:urlString parameters:dic success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        
        NSString *function = dic[@"return_data"][@"function"];
        [self.wkView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dic[@"return_data"][@"cert2_url"]]]];
        NSLog(@"dic is %@",dic);
    } failure:^(NSError *error) {
        
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
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
