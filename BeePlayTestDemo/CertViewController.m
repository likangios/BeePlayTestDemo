//
//  CertViewController.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "CertViewController.h"
#import <WebViewJavascriptBridge.h>

@interface CertViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) WKWebView *web;

@property(nonatomic,strong) WebViewJavascriptBridge *bridge;

@end

@implementation CertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateJSContext:) name:@"DidCreateContextNotification" object:nil];
    [self setup];
  self.bridge =  [WebViewJavascriptBridge bridgeForWebView:self.webView];

    [self.bridge registerHandler:@"ObjC Echo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC Echo called with: %@", data);
        responseCallback(data);
    }];
    [self.bridge callHandler:@"JS Echo" data:nil responseCallback:^(id responseData) {
        NSLog(@"ObjC received response: %@", responseData);
    }];
    
    
    // Do any additional setup after loading the view.
}
- (UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}
- (void)setup{
    NSURL *url = [NSURL URLWithString:[NSUserDefaults standardUserDefaults].certURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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
- (void)back{
    __weak typeof(self)weakSelf = self;

    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.backAction) {
            weakSelf.backAction();
            
        }
    }];
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
