//
//  XYViewController.m
//  BeePlayTestDemo
//
//  Created by perfay on 2018/7/16.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "XYViewController.h"
#import <WebViewJavascriptBridge.h>
#import <AdSupport/AdSupport.h>
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
