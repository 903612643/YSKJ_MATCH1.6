//
//  YSKJ_HomeViewController.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/30.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_HomeViewController.h"

#import <SDAutoLayout/SDAutoLayout.h>

#import "YSKJ_LoginViewController.h"

#import "YSKJ_SideBarView.h"

#import "YSKJ_MatchViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "HttpRequestCalss.h"

#import "YSKJ_UpdateVersionView.h"

#define API_DOMAIN @"www.5164casa.com/api/assist" //正式服务器

#define GETVERSION @"http://"API_DOMAIN@"/sysconfig/getversion"  //获取版本号

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@interface YSKJ_HomeViewController ()
{
    UIImageView *_head;
    
    YSKJ_SideBarView *side;                                                                                                                                                                                                                                                                                                                                                                                                                                
    
    UIButton *_logOut;
}

@end

@implementation YSKJ_HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    for (UIView *sub in [UIApplication sharedApplication].keyWindow.subviews) {
        if (sub.tag == 100) {
            sub.frame = CGRectMake(0, 0, 80, [UIScreen mainScreen].bounds.size.height);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.view.backgroundColor = UIColorFromHex(0x354048);
    
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:18];
    UIColor *titleColor=UIColorFromHex(0xb1c0c8);
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: titleColor};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nabg"] forBarMetrics:UIBarMetricsDefault];

    side = [[YSKJ_SideBarView alloc] initWithFrame:CGRectMake(0, 0, 80, [UIScreen mainScreen].bounds.size.height)];
    side.tag = 100;
    [[UIApplication  sharedApplication].keyWindow addSubview:side];
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:bg];
    bg.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    UIImageView *head = [[UIImageView alloc] init];
    _head = head;
    head.layer.cornerRadius = 80;
    head.layer.masksToBounds = YES;
    [bg addSubview:head];
    head.sd_layout
    .topSpaceToView(bg,44)
    .widthIs(160)
    .heightIs(160)
    .leftSpaceToView(bg,472);
    
    UIButton *name = [[UIButton alloc] init];
    name.titleLabel.font = [UIFont systemFontOfSize:20];
    [name setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _name = name;
    [self.view addSubview:name];
    name.sd_layout
    .leftSpaceToView(self.view,(self.view.frame.size.width-500-80)/2+80)
    .topSpaceToView(self.view,244)
    .widthIs(500)
    .heightIs(20);
    
    UIButton *logOut = [[UIButton alloc] init];
    [logOut setTitle:@"退出登录" forState:UIControlStateNormal];
    _logOut = logOut;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        logOut.hidden = YES;
        side.image = [UIImage imageNamed:@"wode"];
        head.image = [UIImage imageNamed:@"head1"];
        [_name setTitle:@"请登录" forState:UIControlStateNormal];
    }else{
        logOut.hidden = NO;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
            [_name setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"name"] forState:UIControlStateNormal];
            NSString *url = [[NSUserDefaults standardUserDefaults]objectForKey:@"logo"];
            if (url.length!=0) {
                UIImageView *imageView = [[UIImageView alloc] init];
                //获取网络图片的Size
                [imageView sd_setImageWithPreviousCachedImageWithURL:[[NSURL alloc] initWithString:url] placeholderImage:[UIImage imageNamed:@"loading1"] options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    side.image = image;
                    _head.image = image;
                }];
                
          
            }else{
                side.image = [UIImage imageNamed:@"wuyanliushe"];
                _head.image = [UIImage imageNamed:@"head2"];
            }
        }
    }
    logOut.backgroundColor = UIColorFromHex(0xf32a00);
    logOut.titleLabel.font = [UIFont systemFontOfSize:18];
    [logOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOut.sd_cornerRadius = @(4);
    [self.view addSubview:logOut];
    logOut.sd_layout
    .leftSpaceToView(self.view,430)
    .rightSpaceToView(self.view,350)
    .topSpaceToView(self.view,318)
    .bottomSpaceToView(self.view,342);
    
    [logOut addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    
    [side.match addTarget:self action:@selector(matchAciton) forControlEvents:UIControlEventTouchUpInside];
    
    [name addTarget:self action:@selector(loginAciton) forControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotification) name:@"loginNotification" object:nil];
    
     [self httpsGetVersionforService];
    
}

#pragma mark 版本更新提示

-(void)httpsGetVersionforService
{
    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    
    [httpRequest postHttpDataWithParam:nil url:GETVERSION success:^(NSDictionary *dict, BOOL success) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        if ([app_Version floatValue]<[[dict objectForKey:@"version"] floatValue]) {
            
            YSKJ_UpdateVersionView *update=[[YSKJ_UpdateVersionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            update.versionStr = [dict objectForKey:@"version"];
            [update.updateButton addTarget:self action:@selector(updateVersionAction) forControlEvents:UIControlEventTouchUpInside];
            [[UIApplication sharedApplication].keyWindow addSubview:update];
            
        }
        
    }fail:^(NSError *error) {
        
    }];
    
}

-(void)updateVersionAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/yun-shang-kong-jian-hd/id1319208330?mt=8"]];
}

-(void)loginSuccessNotification
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"logo"]) {
        
        [_name setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"name"] forState:UIControlStateNormal];
        NSString *url = [[NSUserDefaults standardUserDefaults]objectForKey:@"logo"];
        
        if (url.length!=0) {
            
            [_head sd_setImageWithPreviousCachedImageWithURL:[[NSURL alloc] initWithString:url] placeholderImage:[UIImage imageNamed:@"loading1"] options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                side.image = image;
                _head.image = image;
                
            }];
            
            
        }else{
            
            side.image = [UIImage imageNamed:@"wuyanliushe"];
            _head.image = [UIImage imageNamed:@"head2"];
        }
        
    }
    
    _logOut.hidden = NO;

}

-(void)loginAciton
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        for (UIView *sub in [UIApplication sharedApplication].keyWindow.subviews) {
            if (sub.tag == 100) {
                sub.frame = CGRectMake(-80, 0, 80, [UIScreen mainScreen].bounds.size.height);
            }}
        YSKJ_LoginViewController *log=[[YSKJ_LoginViewController alloc] init];
        [self presentViewController:log animated:YES completion:nil];

    }
    
}

-(void)matchAciton
{
    for (UIView *sub in [UIApplication sharedApplication].keyWindow.subviews) {
        if (sub.tag == 100) {
            sub.frame = CGRectMake(-80, 20, 80, [UIScreen mainScreen].bounds.size.height-20);
    }}
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
        YSKJ_LoginViewController *log=[[YSKJ_LoginViewController alloc] init];
        [self presentViewController:log animated:YES completion:nil];
        
    }else{
        
        YSKJ_MatchViewController *match = [[YSKJ_MatchViewController alloc] init];
        [self.navigationController pushViewController:match animated:YES];
    }
}

-(void)logOutAction
{
    side.headBut.enabled = NO;
    side.match.enabled = NO;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您确定退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        side.image = [UIImage imageNamed:@"wode"];
        _head.image = [UIImage imageNamed:@"head1"];
        _logOut.hidden = YES;
        side.headBut.enabled = YES;
        side.match.enabled = YES;
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logo"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        [_name setTitle:@"请登录" forState:UIControlStateNormal];
        
        
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        side.headBut.enabled = YES;
        side.match.enabled = YES;
    }];
    [alertVC addAction:cancle];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:^{
        
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
