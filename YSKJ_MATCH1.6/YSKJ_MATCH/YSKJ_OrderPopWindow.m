//
//  YSKJ_OrderPopWindow.m
//  YSKJ
//
//  Created by YSKJ on 17/7/27.
//  Copyright © 2017年 5164casa.com. All rights reserved.
//

#import "YSKJ_OrderPopWindow.h"

#import <SDAutoLayout/SDAutoLayout.h>

#define QINIU @"http://octjlpudx.qnssl.com/"      //七牛绝对路径

#import "YSKJ_CanvasLoading.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_OrderPopWindow

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tag.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tag];

        self.popView = [[UIView alloc] init];
        self.popView.backgroundColor = [UIColor whiteColor];
        self.popView.sd_cornerRadius = @10;
        [self addSubview:self.popView];
        self.popView.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(self,78)
        .widthIs(430)
        .heightIs(180);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"Bubble2"];
        [self addSubview:imageView];
        imageView.sd_layout
        .rightSpaceToView(self,32)
        .topSpaceToView(self,66)
        .widthIs(45)
        .heightIs(27);
         _triangleImageView = imageView;
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, 120, 32)];
        titleLable.text = @"文件网络路径：";
        self.titleLab = titleLable;
        titleLable.font = [UIFont systemFontOfSize:14];
        titleLable.textColor = UIColorFromHex(0x666666);
        [self.popView addSubview:titleLable];
        
        self.urlText = [[UITextField alloc] initWithFrame:CGRectMake(124, 40, self.popView.frame.size.width - 124 -30, 32)];
        self.urlText.layer.borderColor = UIColorFromHex(0x969696).CGColor;
        self.urlText.layer.borderWidth = 1;
        self.urlText.borderStyle = UITextBorderStyleRoundedRect;
        self.urlText.textColor = UIColorFromHex(0x030303);
        self.urlText.font = [UIFont systemFontOfSize:12];
        [self.popView addSubview:self.urlText];
        
        NSArray *title = @[@"复制",@"用浏览器打开"];
        
        for (int i = 0 ; i<title.count; i++) {
            UIButton *button = [UIButton new];
            [button setTitle:title[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.cornerRadius = 4;
            button.tag = 1000+i;
            button.layer.masksToBounds = YES;
            button.backgroundColor = UIColorFromHex(0x00abf2);
            [self.popView addSubview:button];
            button.sd_layout
            .leftSpaceToView(self.popView,34*i+60*(i+1)+108*i)
            .widthIs(108)
            .heightIs(44)
            .bottomSpaceToView(self.popView,20);
            
            [button addTarget:self action:@selector(copyUrlDown:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(copyUrlUpInside:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    return self;
    
}

-(void)copyUrlDown:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromHex(0xefefef);
    
}
-(void)copyUrlUpInside:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromHex(0x00abf2);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.alpha = 0.01;
        self.popView.alpha = 0.01;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        self.tagBlock();
        
    }];
    
    if (sender.tag == 1000) {
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"复制成功" loadType:finishing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            
        });
        
        self.copyBlock([NSString stringWithFormat:@"%@%@",QINIU,self.title]);
    
    }else{
        
        self.openUrlBlock([NSString stringWithFormat:@"%@%@",QINIU,self.title]);
        
    }

}

-(instancetype)initTitle:(NSString*)title triangleX:(CGFloat)triangleX
{
    if ([self initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]) {
        self.title = title;
        self.urlText.text = [NSString stringWithFormat:@"%@%@",QINIU,self.title];
        _triangleImageView.sd_layout
        .rightSpaceToView(self,triangleX);
        [_triangleImageView updateLayout];
        
    }
    return self;
}

+(void)showPopViewWithTitle:(NSString*)title triangleX:(CGFloat)triangleX CopyBlock:(copyBlock)copyBlock openUrlBlock:(openUrlBlock)openUrlBlock tagBlock:(tagBlock)tagBlock;
{
    YSKJ_OrderPopWindow *pop = [[YSKJ_OrderPopWindow alloc] initTitle:title triangleX:triangleX];
    pop.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    pop.copyBlock = copyBlock;
    pop.openUrlBlock = openUrlBlock;
    pop.tagBlock = tagBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:pop];
}

-(void)tap:(UITapGestureRecognizer*)ges
{
    self.tagBlock();
    [ges.view removeFromSuperview];
}

@end
