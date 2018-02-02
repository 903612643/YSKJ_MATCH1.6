//
//  YSKJ_ForgetViewController.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/30.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_ForgetViewController.h"

#import <SDAutoLayout/SDAutoLayout.h>

#import "HttpRequestCalss.h"

#import "ToolClass.h"

#import "AnimatedGif.h"

//#import "YSKJ_Hub.h"

#import "YSKJ_CanvasLoading.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

#define API_DOMAIN @"www.5164casa.com/api/saas"                  //正式服务器

#define GETCODE @"http://"API_DOMAIN@"/user/getphonecode" //获取验证码
#define VERIFYCODE @"http://"API_DOMAIN@"/user/checkphonecode"   //验证验证码
#define FORGETPASSWORD @"http://"API_DOMAIN@"/user/editpassword"  //忘记密码-修改密码


@interface YSKJ_ForgetViewController ()<UITextFieldDelegate>
{
    UITextField *_name;
    UITextField *_code;
    UIButton *_getCode;
    NSTimer *_timer;
    UIButton *_setPassBut;
    UIView *_alertLoading;
    
    //验证码成功进入
    UITextField *_newPassword;
    UIButton *_sureSetButton;
}

@end

@implementation YSKJ_ForgetViewController

-(void)viewWillAppear:(BOOL)animated
{
    setSuccess=NO;
    
    _name.hidden=NO;
    _code.hidden=NO;
    _getCode.hidden=NO;
    _setPassBut.hidden=NO;
    
    _newPassword.hidden = YES;
    _sureSetButton.hidden = YES;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
    waitTimes=60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    UILabel *titleLable=[UILabel new];
    titleLable.text=self.title;
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.font=[UIFont systemFontOfSize:20];
    titleLable.textColor=UIColorFromHex(0x333333);
    [self.view addSubview:titleLable];
    titleLable.sd_layout
    .topSpaceToView(self.view,190)
    .leftSpaceToView(self.view,(self.view.frame.size.width-100)/2)
    .heightIs(20)
    .rightSpaceToView(self.view,(self.view.frame.size.width-100)/2);
    
    [self addUserName];
    [self addCode];
    [self addCompanyLog];
    [self addCodeBut];
    [self addSetPassBut];
    
    [self addNewPass];
    [self addSureBut];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:_name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:_code];
    
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
    [_code resignFirstResponder];
    [_name resignFirstResponder];
    [_newPassword resignFirstResponder];
    //使视图还原
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    self.view.frame = viewFrame;
}

-(void)textChange
{
    if (_name.text.length!=0 && _code.text.length!=0) {
        _setPassBut.backgroundColor=UIColorFromHex(0x00abf2);
        _setPassBut.enabled=YES;
    }else{
        _setPassBut.backgroundColor=UIColorFromHex(0x999999);
        _setPassBut.enabled=NO;
    }
    
}
-(void)tapGes
{
    [_name resignFirstResponder];
    [_code resignFirstResponder];
    [_newPassword resignFirstResponder];
    
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
    userName.secureTextEntry = YES;
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

-(void)addCode
{
    UITextField *code=[UITextField new];
    code.delegate=self;
    _code = code;
    code.placeholder=@"请输入验证码";
    code.font=[UIFont systemFontOfSize:14];
    code.textAlignment=NSTextAlignmentCenter;
    code.clearButtonMode=UITextFieldViewModeWhileEditing;
    code.borderStyle=UITextBorderStyleRoundedRect;
    code.layer.borderWidth = 1;
    code.sd_cornerRadius = @(4);
    code.layer.borderColor = UIColorFromHex(0x333333).CGColor;
    [self.view addSubview:code];
    code.sd_layout
    .leftEqualToView(_name)
    .widthIs(120)
    .topSpaceToView(_name,24)
    .heightIs(44);
}
-(void)addCodeBut
{
    UIButton *getCode=[UIButton new];
    getCode.sd_cornerRadius = @(4);
    _getCode = getCode;
    getCode.enabled=YES;
    UIColor *titleCol=UIColorFromHex(0x999999);
    [getCode setTitleColor:titleCol forState:UIControlStateNormal];
    [getCode setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    getCode.titleLabel.font=[UIFont systemFontOfSize:14];
    getCode.backgroundColor=UIColorFromHex(0xffffff);
    [getCode addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCode];
    getCode.sd_layout
    .rightEqualToView(_name)
    .widthIs(120)
    .topSpaceToView(_name,24)
    .heightIs(44);
}
-(void)addSetPassBut
{
    UIButton *setPassWord=[UIButton new];
    setPassWord.sd_cornerRadius = @(4);
    _setPassBut = setPassWord;
    [setPassWord setTitle:@"设置新密码" forState:UIControlStateNormal];
    setPassWord.titleLabel.font=[UIFont systemFontOfSize:20];
    setPassWord.backgroundColor=UIColorFromHex(0x999999);
    setPassWord.enabled=NO;
    [setPassWord addTarget:self action:@selector(setPassWordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setPassWord];
    setPassWord.sd_layout
    .leftEqualToView(_name)
    .rightEqualToView(_name)
    .topSpaceToView(_code,48)
    .heightIs(44);
}
-(void)addNewPass
{
    UITextField *newPassword=[UITextField new];
    newPassword.delegate=self;
    _newPassword = newPassword;
    _newPassword.hidden = YES;
    newPassword.font=[UIFont systemFontOfSize:14];
    newPassword.placeholder=@"请输入新密码";
    newPassword.clearButtonMode=UITextFieldViewModeWhileEditing;
    newPassword.borderStyle=UITextBorderStyleRoundedRect;
    newPassword.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:newPassword];
    newPassword.sd_layout
    .leftSpaceToView(self.view,344)
    .rightSpaceToView(self.view,344)
    .topSpaceToView(self.view,278)
    .heightIs(44);

}

-(void)addSureBut
{
    UIButton *sureSetButton=[UIButton new];
    _sureSetButton = sureSetButton;
    _sureSetButton.hidden = YES;
    sureSetButton.sd_cornerRadius = @(4);
    [sureSetButton setTitle:@"确认" forState:UIControlStateNormal];
    sureSetButton.titleLabel.font=[UIFont systemFontOfSize:20];
    sureSetButton.backgroundColor=UIColorFromHex(0x999999);
    sureSetButton.enabled=NO;
    [sureSetButton addTarget:self action:@selector(setNewPassWordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureSetButton];
    sureSetButton.sd_layout
    .leftEqualToView(_newPassword)
    .rightEqualToView(_newPassword)
    .topSpaceToView(_newPassword,48)
    .heightIs(44);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPasswordChange) name:UITextFieldTextDidChangeNotification object:_newPassword];

}

-(void)setNewPassWordAction
{
    if (_newPassword.text.length>=6) {
        
        HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
        NSDictionary *dict=@{
                             @"mobile":_name.text,
                             @"phonecode":_code.text,
                             @"password":_newPassword.text
                             };
        
        [httpRequest postHttpDataWithParam:dict url:FORGETPASSWORD  success:^(NSDictionary *dict, BOOL success) {
            
            if ([[dict objectForKey:@"success"] boolValue]==1) {
                
                [YSKJ_CanvasLoading showNotificationViewWithText:@"设置成功" loadType:onlyText];
                
                [self dismissViewControllerAnimated:YES completion:^{
                }];
                
            }else{
            
                [YSKJ_CanvasLoading showNotificationViewWithText:@"设置失败" loadType:onlyText];
            }
            
        } fail:^(NSError *error) {
            
        }];
        
        
    }else{
    
        [YSKJ_CanvasLoading showNotificationViewWithText:@"密码为6-16字符" loadType:onlyText];
        
        
    }
}

-(void)newPasswordChange
{
    if (_newPassword.text.length!=0) {
        _sureSetButton.backgroundColor=UIColorFromHex(0x00abf2);
        _sureSetButton.enabled=YES;
    }else{
        _sureSetButton.backgroundColor=UIColorFromHex(0x999999);
        _sureSetButton.enabled=NO;
    }
}

-(void)getCodeAction
{
        
        if ([ToolClass phone:_name.text]==YES) {        //手机号码格式正确
            
            //开启定时器倒数60秒
            _getCode.enabled=YES;
            _getCode.backgroundColor=UIColorFromHex(0xdfdfdf);
            
            _timer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(waitCodeActionTimer:) userInfo:nil repeats:YES];
            
            HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
            NSDictionary *dict=@{
                                 @"mobile":_name.text,
                                 };
            [httpRequest postHttpDataWithParam:dict url:GETCODE  success:^(NSDictionary *dict, BOOL success) {
                
               
                
            } fail:^(NSError *error) {
                
            }];
            
            
        }else{                                             //手机格式不正确

            [YSKJ_CanvasLoading showNotificationViewWithText:@"手机号码格式不正确" loadType:onlyText];
            
        }
        

}
static int waitTimes=60;
-(void)waitCodeActionTimer:(NSTimer*)timer
{
    waitTimes--;
    if (waitTimes!=-1) {
        [_getCode setTitle:[NSString stringWithFormat:@"请等待%d秒",waitTimes] forState:UIControlStateNormal];
    }else{
        waitTimes=60;
        [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCode.backgroundColor=[UIColor whiteColor];
        _getCode.enabled=YES;
        [_timer invalidate];
    }
    
}
static bool setSuccess=NO;
-(void)setPassWordAction
{
    if ([ToolClass phone:_name.text]==YES) {        //手机号码格式正确
        
        [self showAlertImage];
        
        HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
        NSDictionary *dict=@{
                             @"mobile":_name.text,
                             @"phonecode":_code.text
                             };
        [httpRequest postHttpDataWithParam:dict url:VERIFYCODE  success:^(NSDictionary *dict, BOOL success) {
            
            [_alertLoading removeFromSuperview];
            
            if ([[[dict objectForKey:@"data"] objectForKey:@"message"] isEqualToString:@"phonecode error"]) {
                
                [YSKJ_CanvasLoading showNotificationViewWithText:@"验证码错误" loadType:onlyText];
                
                
            }else{
                
                setSuccess=YES;
                
                _name.hidden=YES;
                _code.hidden=YES;
                _getCode.hidden=YES;
                _setPassBut.hidden=YES;
                
                _newPassword.hidden = NO;
                _sureSetButton.hidden = NO;
                

            }
            
        } fail:^(NSError *error) {
   
            [_alertLoading removeFromSuperview];
        }];
        
    }else{                                             //手机格式不正确
    
         [YSKJ_CanvasLoading showNotificationViewWithText:@"手机号码格式不正确" loadType:onlyText];
    
        
    }
    
}

-(void)colse
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)showAlertImage
{
    _alertLoading = [UIView new];
    _alertLoading.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    _alertLoading.sd_layout
    .centerXEqualToView(_alertLoading.superview)
    .centerYEqualToView(_alertLoading.superview)
    .widthIs(self.view.frame.size.width)
    .heightIs(self.view.frame.size.height);
    
    UIImageView *imageView = [UIImageView new];
    NSURL *localUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
    imageView= [AnimatedGif getAnimationForGifAtUrl:localUrl];
    [_alertLoading addSubview:imageView];
    
    imageView.sd_layout
    .centerXEqualToView(imageView.superview)
    .centerYEqualToView(imageView.superview)
    .widthIs(48)
    .heightEqualToWidth();
    
    [[UIApplication sharedApplication].keyWindow addSubview:_alertLoading];
    
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
    if (_code==textField) {
        if (string.length == 0)
            return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
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
