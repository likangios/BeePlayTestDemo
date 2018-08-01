//
//  XYViewController.m
//  BeePlayTestDemo
//
//  Created by perfay on 2018/7/16.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "XYViewController.h"
#import <AdSupport/AdSupport.h>
//#import "BeePlayTestDemo-Swift.h"
@interface XYViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) UIWebView *webView;
@property(retain, nonatomic) JSContext *jsContext; // @synthesize jsContext=_jsContext;
@property WebViewJavascriptBridge* bridge;

@end

@implementation XYViewController
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateJSContext:) name:@"DidCreateContextNotification" object:nil];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSUserDefaults standardUserDefaults].mainURL]]];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://qianka.com/v4/key?lite=1"]]];
    [self.bridge registerHandler:@"openSafari" handler:^(NSDictionary  *data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC Echo called with: %@", data);
        NSString *url =[NSString stringWithFormat:@"%@&token=9aa60098f5b61f4433c2548e9055e231",data[@"backUrl"]];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        responseCallback(data);
    }];
//    A8F572A1-B2B3-410B-92C4-7F532D93105E
    [self.bridge callHandler:@"isUploaded" data:nil responseCallback:^(id responseData) {
        
    }];
    NSString *aPassword = @"1514e2f07add21f4a6aba875588592a";
    NSDictionary *dic = @{@"idfa":@"F943B5A0-D534-4A2E-9E30-C9BAD865B177"};
//    NSDictionary *dic =  @{@"dfsa":@"18fdfd-fd34-4A2E-9E30-C9BAD865B188"};
    NSData *data = [dic messagePack];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"originData" ofType:nil];
    
    NSString *structpath = [[NSBundle mainBundle] pathForResource:@"struceData" ofType:nil];
    NSData *structData = [NSData dataWithContentsOfFile:structpath];
    
    
    
    RNCryptorSettings  Struct2;
    [structData getBytes:&Struct2 length:sizeof(Struct2)];
    NSLog(@"Struct2");
    Struct2.keySettings.rounds = 1;
    Struct2.HMACKeySettings.rounds = 1;

    /*
     1.   将   infoStruct转换为NSData
     
     NSData * msgData = [[NSData alloc]initWithBytes:&infoStruct length:sizeof(infoStruct)];
     
     
     
     2.  将    msgData转换为  MYINFO  对象。
     
     
     
     struct  MYINFO  infoStruct2;
     
     [msgData getBytes:&infoStruct2 length:sizeof(infoStruct2)];
     */
    
//    NSMutableData *transferData = [[NSMutableData alloc]init];
//    [transferData appendData:data];
//
//    NSData *tmpData = [[NSData alloc] initWithBytes:"\xd9" length: 1];;
//
//    [transferData replaceBytesInRange:NSMakeRange(6, 2) withBytes:tmpData.bytes length:1];
//

    
    
    data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:Struct2
                                            password:aPassword
                                               error:&error];
    /*
<0301f626 2012d138 7a8b9a73 6af08db3 3c3b7b51 fe955519 bc70706b 95382a21 83af3c74 36a43219 e5ff3a60 745f9888 279d672f 1fbaa656 e098bc88 81c8884d a820e533 8a37dc83 4c047018 da2d4ef8 a3277653 588df33e c15b1275 07a7d9cd 09764a76 08ad7d63 39a9c586 3bb34c35 99ce>
     
     */
    
    NSData *encryptedData2 = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:aPassword
                                               error:&error];
    
    NSLog(@"kRNCryptorAES256Settings");
    /*
     (RNCryptorSettings) kRNCryptorAES256Settings = {
     algorithm = 0
     blockSize = 16
     IVSize = 16
     options = 1
     HMACAlgorithm = 2
     HMACLength = 32
     keySettings = {
     keySize = 32
     saltSize = 8
     PBKDFAlgorithm = 2
     PRF = 1
     rounds = 10000
     hasV2Password = NO
     }
     HMACKeySettings = {
     keySize = 32
     saltSize = 8
     PBKDFAlgorithm = 2
     PRF = 1
     rounds = 10000
     hasV2Password = NO
     }
     
     <0301e1c4 fa6242ec 2ef88174 a857fd10 88b7f05e d8559847 6c8cade5 6718bbf7 f194e1d1 78aa0bac b74ad75e 33aa81b8 429d78c5 0235811c af830272 1b4dd394 49075846 69d32a19 ddbfeea1 b9abe20d e0967388 94f26b58 a31e9000 199931d9 47f0db69 93f3e391 cf542b78 a01314f6 f7ca>
     
     *
    
    /*
     <81a46964 6661da00 24463934 33423541 302d4435 33342d34 4132452d 39453330 2d433942 41443836 35423137 37>
     <81a46964 6661da00 23393433 42354130 2d443533 342d3441 32452d39 4533302d 43394241 44383635 42313737>
     */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://qianka.com/s4k/lite.getToken"]];
    [request setValue:request.URL.host forHTTPHeaderField:@"Host"];
//    [request setValue:[NSString stringWithFormat:@"%f",NSDate.date.timeIntervalSince1970] forHTTPHeaderField:@"X-QK-TIME"];
    [request setValue:@"1532675001" forHTTPHeaderField:@"X-QK-TIME"];
    [request setValue:@"DB2B37D7ED61665BA27DD62E907F4871" forHTTPHeaderField:@"X-QK-SIGN"];
    request.HTTPMethod = @"POST";
    
    [request setValue:@"c26007f41f472932454ea80deabd612c" forHTTPHeaderField:@"X-QK-API-KEY"];
    NSString *udid = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    NSString *bundleIdentifier = @"bao.bao.qin";
    NSString *v302 = @"16195848-30b2-4fa1-bc49-f47d644fdd2f";//uuid key sskeychain
    NSString *v303 = udid;
    NSString *stru_10020E990 = @"";
    NSString *auth = [NSString stringWithFormat:@"%@|%@|%@",v303,v302,stru_10020E990];
    [request setValue:auth forHTTPHeaderField:@"X-QK-AUTH"];
    
    NSString *iphone_model = @"iPhone7,1";
    CGFloat versionNumber = NSFoundationVersionNumber;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *version = [infoDic objectForKey:(NSString *)kCFBundleVersionKey];//获取项目版本号
    NSString *shortVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];//获取项目版本号
    
    NSString *versionInfo = [NSString stringWithFormat:@"%@.%@",shortVersion,version];
    NSString *APPV = [NSString stringWithFormat:@"%@|%f|%@|%@",iphone_model,versionNumber,bundleIdentifier,versionInfo];
    [request setValue:APPV forHTTPHeaderField:@"X-QK-APPV"];
    [request setValue:bundleIdentifier forHTTPHeaderField:@"X-QK-SCHEME"];
    [request setValue:@"X-Qk-Auth, *" forHTTPHeaderField:@"Access-Control-Allow-Headers"];
    [request setValue:@"*" forHTTPHeaderField:@"Access-Control-Allow-Origin"];
    
    NSString *v104 = [UIDevice currentDevice].systemVersion;
    NSNumber *v105 = @([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]);
    NSString *v149 = @"121c83f76072cb6d448";//JPUSHService, "registrationID"
    
    NSString *extension = [NSString stringWithFormat:@"%@|%@|%@",v104,v105,v149];
    [request setValue:extension forHTTPHeaderField:@"X-QK-EXTENSION"];
    
    NSString *dsid = @"1835058406";
    [request setValue:dsid forHTTPHeaderField:@"X-QK-DSID"];
    
    [request setValue:dsid forHTTPHeaderField:@"X-QK-DSID"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSString *pushToken = @"<dd9e9622 58868e8c 33358b68 92e78329 a5628cdf da129cf5 84b02e2a f43a57e0>";
    NSData *pushData = [pushToken dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:pushToken forHTTPHeaderField:@"X-QK-TAG"];
    
    [request setHTTPBody:encryptedData];
    
    NSURLSession *session = [NSURLSession sharedSession];
   NSURLSessionDataTask *task =  [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [task resume];
    /*
     <0301d30c f3604121 1311c493 07ed4776 c67ce713 60e459d9 ad5adfa3 018faf74 3c50592a d01b55ef 58d6bed7 3f12b69f f9de72fa 3435c8a4 41f0b020 365700bc 4fa58cea 73c0966c 0134734a 0f0254cc 4c277c85 9e8da415 7912f597 8a8dbeb7 695150ca 0b60ba4d 15210c18 cce1690e 60d9>
     
     <0301b252 4230d4f6 11843d9c b04cd68c f022eab5 5858aa59 268417a5 20bd78fc 32c08bee b508fd16 8748e28a ab47e89c 09d8f0d3 109e2825 501ab4a2 6547bb3f 56099db6 ba3e3243 af0c2e81 14d4cc78 f65139e3 3e413dc9 863d914c 5981aa60 c3701457 d60c126e b9799383 dd6ac921 1bed>
     */

//
}
- (void)didCreateJSContext:(NSNotification *)notifObj{
    NSInteger hash =   self.webView.hash;
    NSString *indentifier = [NSString stringWithFormat:@"indentifier%lud",hash];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var %@ = '%@'",indentifier,indentifier]];
    //    if ([notifObj.object isKindOfClass:[NSDictionary class]]) {
    //   id obj =  [notifObj.object objectForKey:indentifier];
    //    if ([[obj toString] isEqualToString:indentifier]) {
    self.jsContext = notifObj.object;
    XYWebViewJSObject *webObj = [[XYWebViewJSObject alloc]init];
    self.jsContext[@"xynative"] = webObj;
    webObj.jsContext = self.jsContext;
    webObj.webView = self.webView;
    webObj.viewController = self;
    [self.jsContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
        
    }];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"shouldStartLoadWithRequest");
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
