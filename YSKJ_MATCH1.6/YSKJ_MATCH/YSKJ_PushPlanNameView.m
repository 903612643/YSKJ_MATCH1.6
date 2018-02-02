//
//  YSKJ_PushPlanNameView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/14.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_PushPlanNameView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_PushPlanNameView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        
        [self addTarget:self action:@selector(firstResponderAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 356)/2, 270, 356, 229)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 12;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        
        UITextField *planName = [[UITextField alloc] initWithFrame:CGRectMake(33.5, 24.5, 290, 44)];
        _nameTextF = planName;
        planName.font = [UIFont systemFontOfSize:16];
        planName.borderStyle = UITextBorderStyleRoundedRect;
        planName.layer.borderColor = UIColorFromHex(0xc7c7c7).CGColor;
        planName.layer.borderWidth = 1;
        planName.placeholder = @"请输入方案名称";
        planName.delegate = self;
        [view addSubview:planName];
        
        UIButton *openBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 93, 44, 44)];
        [openBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [openBtn addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
        openBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
       // [view addSubview:openBtn];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(134, 93, 180, 44)];
        title.text = @"（方案对所有人可见）";
        title.textColor = UIColorFromHex(0xc7c7cd);
        title.font = [UIFont systemFontOfSize:14];
       // [view addSubview:title];
        
        UIButton *cancle = [[UIButton alloc] initWithFrame:CGRectMake(53.5, 161, 76, 44)];
        [cancle setTitle:@"取消" forState:UIControlStateNormal];
        [cancle setTitleColor:UIColorFromHex(0xc7c7cd) forState:UIControlStateNormal];
        cancle.layer.cornerRadius = 4;
        cancle.layer.masksToBounds = YES;
        cancle.layer.borderColor = UIColorFromHex(0xdddddd).CGColor;
        cancle.layer.borderWidth = 1;
        cancle.backgroundColor = UIColorFromHex(0xf4f4f4);
        [cancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancle];
        
        UIButton *sure = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - (76+53.5), 163, 76, 44)];
        _sureBtn = sure;
        sure.backgroundColor=UIColorFromHex(0x999999);
        sure.enabled=NO;
        [sure setTitle:@"确认" forState:UIControlStateNormal];
        [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sure.layer.cornerRadius = 4;
        sure.layer.masksToBounds = YES;
        [sure addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sure];
        
        //监听软键盘事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:UITextFieldTextDidChangeNotification object:self.nameTextF];
        
        
    }
    return self;
}

-(void)firstResponderAction
{
    [self.nameTextF resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification *) notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyBoardHeight = keyboardRect.size.height;
    
    //使视图上移
    CGRect viewFrame = self.superview.frame;
    viewFrame.origin.y = -keyBoardHeight+(150+63);
    self.superview.frame = viewFrame;
    
}
-(void)keyboardWillHide
{
    [self.nameTextF resignFirstResponder];
    
    //使视图还原
    CGRect viewFrame = self.superview.frame;
    viewFrame.origin.y = 0;
    self.superview.frame = viewFrame;
    
}

-(void)change
{
    if (self.nameTextF.text.length!=0 ) {
        _sureBtn.backgroundColor=UIColorFromHex(0x00abf2);
        _sureBtn.enabled=YES;
    }else{
        _sureBtn.backgroundColor=UIColorFromHex(0x999999);
        _sureBtn.enabled=NO;
    }
}

-(void)cancleAction
{
    [self removeFromSuperview];
    
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

-(void)sureAction
{
    [self removeFromSuperview];
    if (self.sureBlock) {
        self.sureBlock(self.nameTextF.text,_openBool);
    }
}

-(void)openAction:(UIButton *)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender  setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
        _openBool = YES;

    }else{
        sender.selected = NO;
        [sender  setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        _openBool = NO;

    }
}

-(instancetype)initPlanName
{
    if ([self initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)]) {
        
        _openBool = NO;
        
    }
    
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.nameTextF.text = self.title;
    
    if (title.length!=0) {
        _sureBtn.backgroundColor=UIColorFromHex(0x00abf2);
        _sureBtn.enabled=YES;
    }else{
        _sureBtn.backgroundColor=UIColorFromHex(0x999999);
        _sureBtn.enabled=NO;
    }
}

+(void)showInputPlanNameView:(NSString*)title CancleBlock:(cancleBlock)cancleBlock sureBlock:(sureBlock)sureBlock;
{
    YSKJ_PushPlanNameView *planNameView = [[YSKJ_PushPlanNameView alloc] initPlanName];
    
    planNameView.sureBlock = sureBlock;
    
    planNameView.cancleBlock = cancleBlock;
    
    planNameView.title = title;
    
    [[UIApplication sharedApplication].keyWindow addSubview:planNameView];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self.nameTextF resignFirstResponder];
    return YES;
}

@end

