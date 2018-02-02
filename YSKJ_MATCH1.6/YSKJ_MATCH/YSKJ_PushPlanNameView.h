//
//  YSKJ_PushPlanNameView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/14.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cancleBlock)(void);

typedef void (^sureBlock)(NSString *planName,BOOL open);

@interface YSKJ_PushPlanNameView : UIButton<UITextFieldDelegate>
{
    BOOL _openBool;
    NSString *_nameStr;
    UIButton *_sureBtn;
}

@property (nonatomic, copy)cancleBlock cancleBlock;

@property (nonatomic, copy)sureBlock sureBlock;

@property (nonatomic, strong)UITextField *nameTextF;

@property (nonatomic, strong)NSString *title;

+(void)showInputPlanNameView:(NSString*)title CancleBlock:(cancleBlock)cancleBlock sureBlock:(sureBlock)sureBlock;



@end
