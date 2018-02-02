//
//  YSKJ_LoginViewController.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/30.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_LoginViewController.h"

#import <SDAutoLayout/SDAutoLayout.h>

#import "YSKJ_ForgetViewController.h"

#import "AnimatedGif.h"

#import "ToolClass.h"

#import "HttpRequestCalss.h"

#import "YSKJ_CanvasLoading.h"

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器

#define LOGINURL  @"http://"API_DOMAIN@"/login/index"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@interface YSKJ_LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_name;
    UITextField *_password;
    UIButton *_logbut;
    UIView *_alertLoading;
}

@end

@implementation YSKJ_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *loginBg=[[UIButton alloc]initWithFrame:self.view.bounds];
    loginBg.adjustsImageWhenHighlighted = NO;
    [loginBg setImage:[UIImage imageNamed:@"logBg"] forState:UIControlStateNormal];
    [loginBg addTarget:self action:@selector(tapGes) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBg];

    UIButton  *colse=[UIButton buttonWithType:UIButtonTypeCustom];
    [colse setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [colse addTarget:self action:@selector(colse) forControlEvents: UIControlEventTouchUpInside ];
    [self.view addSubview:colse];
    colse.sd_layout
    .rightSpaceToView(self.view,10)
    .topSpaceToView(self.view,20)
    .widthIs(60)
    .heightIs(60);
    
    [self addUserName];
    [self addPassword];
    [self addLogBut];
    [self addCompanyLog];
    [self addforgetBut];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:_name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:_password];
    
    //监听软键盘事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)keyboardWillShow:(NSNotification *) notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyBoardHeight = keyboardRect.size.height;
 
    //使视图上移
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = -keyBoardHeight+(150+63);
    self.view.frame = viewFrame;
    
}
-(void)keyboardWillHide
{
    [_password resignFirstResponder];
    [_name resignFirstResponder];
    
    //使视图还原
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    self.view.frame = viewFrame;
}

-(void)tapGes
{
    [_name resignFirstResponder];
    [_password resignFirstResponder];
}
-(void)addCompanyLog
{
    UIImageView *log=[UIImageView new];
    log.backgroundColor=[UIColor clearColor];
    log.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:log];
    log.sd_layout
    .leftSpaceToView(self.view,431)
    .rightSpaceToView(self.view,431)
    .topSpaceToView(self.view,93)
    .bottomSpaceToView(_name,125);
}
-(void)addUserName
{
    UITextField *userName=[UITextField new];
    userName.delegate=self;
    _name = userName;
    userName.placeholder=@"请输入手机号码";
    userName.font = [UIFont systemFontOfSize:14];
    userName.clearButtonMode=UITextFieldViewModeWhileEditing;
    userName.borderStyle=UITextBorderStyleRoundedRect;
    userName.keyboardType=UIKeyboardTypeNumberPad;
    userName.layer.borderWidth = 1;
    userName.sd_cornerRadius = @(4);
    userName.layer.borderColor = UIColorFromHex(0x333333).CGColor;
    [self.view addSubview:userName];
    userName.sd_layout
    .leftSpaceToView(self.view,344)
    .rightSpaceToView(self.view,344)
    .topSpaceToView(self.view,278)
    .heightIs(44);
}

-(void)addPassword
{
    UITextField *pass=[UITextField new];
    pass.delegate=self;
    _password = pass;
    pass.placeholder=@"请输入密码";
    pass.font = [UIFont systemFontOfSize:14];
    pass.clearButtonMode=UITextFieldViewModeWhileEditing;
    pass.borderStyle=UITextBorderStyleRoundedRect;
    pass.secureTextEntry = YES;
    pass.layer.borderWidth = 1;
    pass.sd_cornerRadius = @(4);
    pass.layer.borderColor = UIColorFromHex(0x333333).CGColor;
    [self.view addSubview:pass];
    pass.sd_layout
    .leftEqualToView(_name)
    .rightEqualToView(_name)
    .topSpaceToView(_name,24)
    .heightIs(44);
}

-(void)addLogBut
{
    UIButton *log=[UIButton new];
    log.sd_cornerRadius = @(4);
    [log setTitle:@"登录" forState:UIControlStateNormal];
    log.titleLabel.font = [UIFont systemFontOfSize:20];
    log.backgroundColor=UIColorFromHex(0x999999);
    log.enabled=NO;
    _logbut = log;
    [log addTarget:self action:@selector(logAciton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:log];
    log.sd_layout
    .leftEqualToView(_name)
    .rightEqualToView(_name)
    .topSpaceToView(_password,48)
    .heightIs(44);
}
-(void)addforgetBut
{
    UIButton *forget=[UIButton new];
    [forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    forget.backgroundColor=[UIColor clearColor];
    forget.titleLabel.font=[UIFont systemFontOfSize:14];
    [forget addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    forget.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    UIColor *titleCol=UIColorFromHex(0x666666);
    [forget setTitleColor:titleCol   forState:UIControlStateNormal];
    [forget setTitleEdgeInsets:UIEdgeInsetsMake(15, 2, 15, 2)];
   // [self.view addSubview:forget];
    forget.sd_layout
    .leftSpaceToView(_logbut,-78)
    .widthIs(80)
    .heightIs(44)
    .topSpaceToView(_logbut,15);
}

-(void)logAciton
{
    if ([ToolClass phone:_name.text]==YES) {        //手机号码格式正确
        
            if (_password.text.length>5) {             //密码小于6位
                
                [self httpLogin];
                
            }else{
                
                
                [YSKJ_CanvasLoading showNotificationViewWithText:@"密码不能小于6位" loadType:onlyText];
                
            }

    }else{                                             //手机格式不正确
        
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"手机格式不正确" loadType:onlyText];

        
        
    }

}

-(void)httpLogin
{
    [self showAlertImage];
    
    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    NSDictionary *dict=@{
                         @"mobile":_name.text,
                         @"password":_password.text
                         };
    [httpRequest postHttpDataWithParam:dict url:LOGINURL  success:^(NSDictionary *dict, BOOL success) {
        
        [_alertLoading removeFromSuperview];
        
        NSDictionary *dataDict=[dict objectForKey:@"data"];
        
        NSLog(@"dict=%@",dict);
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[dataDict objectForKey:@"logo"] forKey:@"logo"];
        [def setObject:[dataDict objectForKey:@"name"] forKey:@"name"];
        [def synchronize];
        
        if ([[dict objectForKey:@"success"] boolValue]==1) {
            
            NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
            [userdefault setValue:[dataDict objectForKey:@"id"] forKey:@"userId"];
            [userdefault synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:nil userInfo:nil];
            
         
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            
            
        }else if([[dict objectForKey:@"success"] boolValue]==0){
            
        
            if ([dataDict objectForKey:@"message"]) {
                
                if ([[dataDict objectForKey:@"message"] isEqualToString:@"user password error"]) {
                
                    [YSKJ_CanvasLoading showNotificationViewWithText:@"用户名或密码不正确" loadType:onlyText];
                    
                }else if ([[dataDict objectForKey:@"message"] isEqualToString:@"user no exist"]){
            
                     [YSKJ_CanvasLoading showNotificationViewWithText:@"用户未注册" loadType:onlyText];
                }
            }
 
        }
        
    } fail:^(NSError *error) {
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"当前网络不可用" loadType:onlyText];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_alertLoading removeFromSuperview];
            
        });
    }];
    
}


-(void)colse
{
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)forgetAction
{
    YSKJ_ForgetViewController *forget=[[YSKJ_ForgetViewController alloc] init];
    forget.title = @"忘记密码";
    [self presentViewController:forget animated:YES completion:nil];
}
-(void)textChange
{
    if (_name.text.length!=0 && _password.text.length!=0) {
        _logbut.backgroundColor=UIColorFromHex(0x00abf2);
        _logbut.enabled=YES;
    }else{
        _logbut.backgroundColor=UIColorFromHex(0x999999);
        _logbut.enabled=NO;
    }
}

- (void)showAlertImage
{
    _alertLoading = [UIView new];
    [[UIApplication sharedApplication].keyWindow addSubview:_alertLoading];
    _alertLoading.sd_layout
    .centerXEqualToView(_alertLoading.superview)
    .centerYEqualToView(_alertLoading.superview)
    .widthIs(self.view.frame.size.width)
    .heightIs(self.view.frame.size.height - 60);
    
    UIImageView *imageView = [UIImageView new];
    NSURL *localUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
    imageView= [AnimatedGif getAnimationForGifAtUrl:localUrl];
    [_alertLoading addSubview:imageView];
    
    imageView.sd_layout
    .centerXEqualToView(imageView.superview)
    .centerYEqualToView(imageView.superview)
    .widthIs(48)
    .heightEqualToWidth();
    
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    
    if (_name==textField) {
        if (string.length == 0)
            return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    if (_password==textField) {
        if (string.length == 0)
            return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
