//
//  WebViewController.m
//  BeePlayTestDemo
//
//  Created by perfay on 2018/7/24.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property(nonatomic,strong) NSString *Url;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *v220 =  [[NSUserDefaults standardUserDefaults] objectForKey:@"default_home"];
    self.Url = v220;
    NSNotificationCenter *v218 = [NSNotificationCenter defaultCenter];
    NSNotificationCenter *v209 = v218;
    

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
