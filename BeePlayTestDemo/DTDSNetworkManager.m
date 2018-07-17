//
//  JKDSNetworkManager.m
//  jkds
//
//  Created by perfay on 2018/3/26.
//  Copyright © 2018年 perfaylk. All rights reserved.
//

#import "DTDSNetworkManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "sys/utsname.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <AdSupport/AdSupport.h>

static const NSTimeInterval outTime = 30;
static DTDSNetworkManager *networkManager;
static DTDSNetworkManager *networkManager2;

@implementation DTDSNetworkManager

+ (id)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[DTDSNetworkManager alloc]initWithBaseURL:[[self alloc] getBaseUrl]];
    });
    networkManager.requestSerializer.timeoutInterval = [NSUserDefaults standardUserDefaults].apply_tmout.doubleValue;
    return networkManager;
}
+ (id)noBaseUrlShareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager2 = [[DTDSNetworkManager alloc]init];
    });
    networkManager2.requestSerializer.timeoutInterval = outTime;
    return networkManager2;
}
+(NSString *)requestGetURL:(NSString *)url params:(NSDictionary *)params
{
    NSString * urlParamString = @"";//拼接的get参数
    for (NSString * key in [params allKeys]) {
        NSString *value = [NSString stringWithFormat:@"%@", params[key]];
        NSString * keyStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)value, NULL, (CFStringRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        NSString * string = [NSString stringWithFormat:@"&%@=%@",key,keyStr];
        urlParamString = [urlParamString stringByAppendingString:string];
    }
    NSString * tURL =[NSString stringWithFormat:@"%@?%@",url,urlParamString];
    tURL = [tURL stringByReplacingOccurrencesOfString:@"?&" withString:@"?"];
    
    return tURL;
}
- (NSURL *)getBaseUrl{
    return [NSURL URLWithString:@"http://www.xiaoyuzhuanqian.com"];
}

- (AFSecurityPolicy *)customSecurityPolicy {
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"doubotv" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    return securityPolicy;
}
- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
    AFHTTPResponseSerializer * responseSerialize = [AFHTTPResponseSerializer serializer];
    responseSerialize.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"*/*", nil];
        
    self.responseSerializer =responseSerialize;
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
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
//    return @"iPhone7,1";
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
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *sortArray = [allkeys sortedArrayUsingComparator:sort];
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

#pragma action

/*
 @"app_key=5456ebbec93beapp_version=9.2.0auth_nonce=137352auth_timestamp=1531471308bssid=78:8a:20:ff:b7:e6bundle_id=com.xiaoyu.qiancarrier_code=46000device_serial=FABBE34C-C0EE-4B79-A18C-84301162BB90ios_model=iPhone7,1ios_version=9.3.2now_idfa=FABBE34C-C0EE-4B79-A18C-84301162BB90screen_height=736.000000screen_width=414.000000"
 */

/*
 NSDictionary *dic = @{@"ios_version":@"9.3.2",@"carrier_code":@"46000",@"bundle_id":@"com.xiaoyu.qian",@"now_idfa":@"FABBE34C-C0EE-4B79-A18C-84301162BB90",@"app_version":@"9.2.0",@"auth_timestamp":@"1531471308",@"screen_height":@"736.000000",@"bssid":@"78:8a:20:ff:b7:e6",@"auth_nonce":@"137352",@"device_serial":@"FABBE34C-C0EE-4B79-A18C-84301162BB90",@"screen_width":@"414.000000",@"ios_model":@"iPhone7,1",@"app_key":@"5456ebbec93be",@"auth_signature":@"476e9a9dc7f46a2a7edbad7bbd5c281f8486d423"};
 */

- (void)requestPOST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *tParams = [self defaultHeadDictionary];
    [tParams addEntriesFromDictionary:parameters];
    
    NSDictionary *authDic = [NSDictionary dictionaryWithObjectsAndKeys:[self authSignatureWithDictionary:tParams],@"auth_signature", nil];
    [tParams addEntriesFromDictionary:authDic];
    NSLog(@"auth_signature====%@",authDic[@"auth_signature"]);
    
    [self POST:URLString parameters:tParams progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * responseString =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
        NSLog(@"%@",responseString);
        int code = [responseDic[@"return_code"] intValue];
        if (code == RequestSuc) {
            success(responseString);
        }else{
            NSError *error = [NSError errorWithDomain:task.currentRequest.URL.description code:code userInfo:@{NSLocalizedDescriptionKey:responseDic[@"return_msg"]}];
            [self failWithError:error];
            failure(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failWithError:error];
        failure(error);
    }];
}
- (void)requestGET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * responseString =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        NSLog(@"%@",responseString);
        int code = [responseDic[@"code"] intValue];
        if (code == RequestSuc) {
            success(responseString);
        }else{
            NSError *error = [NSError errorWithDomain:task.currentRequest.URL.description code:code userInfo:@{NSLocalizedDescriptionKey:responseDic[@"msg"]}];
            [self failWithError:error];
            failure(error);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failWithError:error];
        failure(error);
    }];
    
}
- (void)requestUploadFile:(NSString *)URLString
            FileUrl:(NSURL *)fileUrl
              FileName:(NSString *)fileName
        parameters:(id)parameters
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:fileUrl name:fileName error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * responseString =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
        NSLog(@"%@",responseString);
        int code = [responseDic[@"code"] intValue];
        if (code == RequestSuc) {
            success(responseString);
        }else{
            NSError *error = [NSError errorWithDomain:task.currentRequest.URL.description code:code userInfo:@{NSLocalizedDescriptionKey:responseDic[@"msg"]}];
            failure(error);
            [self failWithError:error];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [self failWithError:error];
    }];
}
- (void)failWithError:(NSError *)error{
    NSInteger  code = error.code;
    switch (code) {
        case -1009:
//            [MBProgressHUD showErrorMessage:@"无网络连接，请检查设置"];
            break;
        case -1005:
            break;
        case 1:
            //三方登录返回未注册
            break;
        default:
//            ShowError(error);
            break;
    }
    NSLog(@"ERROR========%@",error.description);
//    DDLogError(@"error is %@",error);
}








@end
