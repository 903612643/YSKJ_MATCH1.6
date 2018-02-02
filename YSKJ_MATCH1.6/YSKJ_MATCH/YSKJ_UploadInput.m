//
//  YSKJ_UploadInput.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/18.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_UploadInput.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_UploadInput

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 446, 281)];
        view.image = [UIImage imageNamed:@"Bubble1"];
        [self addSubview:view];
        
        UIButton *cancle = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+13, 60, 50)];
        [cancle setTitle:@"关闭" forState:UIControlStateNormal];
        _cancleBtn = cancle;
        [cancle setTitleColor:UIColorFromHex(0x00abf2) forState:UIControlStateNormal];
        cancle.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:cancle];
        
        UIButton *upLoad = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.origin.x +view.frame.size.width - 60, view.frame.origin.y+13, 60, 50)];
        [upLoad setTitle:@"上传" forState:UIControlStateNormal];
        _upLoadBtn = upLoad;
        [upLoad setTitleColor:UIColorFromHex(0x00abf2) forState:UIControlStateNormal];
         upLoad.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:upLoad];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(37, 66, 100, 44)];
        nameLab.text = @"商品名称";
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.textColor = UIColorFromHex(0x333333);
        [view addSubview:nameLab];
        
        UITextField *nameTextf = [[UITextField alloc] initWithFrame:CGRectMake(143, 66, view.frame.size.width-143-30, 44)];
        nameTextf.placeholder = @"请输入商品名称";
        nameTextf.delegate = self;
        nameTextf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _proName = nameTextf;
        nameTextf.font = [UIFont systemFontOfSize:14];
        [self addSubview:nameTextf];
        
        UILabel *faceLab = [[UILabel alloc] initWithFrame:CGRectMake(37, 104, 100, 44)];
        faceLab.text = @"上传封面图片";
        faceLab.textAlignment = NSTextAlignmentLeft;
        faceLab.font = [UIFont systemFontOfSize:14];
        faceLab.textColor = UIColorFromHex(0x333333);
        [view addSubview:faceLab];
        
        UIButton *faceImageView = [[UIButton alloc] initWithFrame:CGRectMake(143+view.frame.origin.x, view.frame.origin.y+114, 76, 76)];
        [faceImageView setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
        _faceBtn = faceImageView;
        [self addSubview:faceImageView];
        
        UITextView *tip = [[UITextView alloc] initWithFrame:CGRectMake(138, faceLab.frame.origin.y+86+8, view.frame.size.width - 138-30, 50)];
        tip.text = @"支持PNG,JPG格式的图片，图片宽度不小于100像素，图片大小限制在5MB以内，只能上传一张图片。";
        tip.editable = NO;
        tip.textColor = UIColorFromHex(0x999999);
        [view addSubview:tip];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    
    return self;
}

- (void)tapBG:(UITapGestureRecognizer *)gesture {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}



@end
