//
//  YSKJ_CanvasLoading.h
//  YSKJ
//
//  Created by YSKJ on 17/9/21.
//  Copyright © 2017年 5164casa.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    loading = 0,
    finishing = 1,
    isBack = 2,  
    fail = 3,
    done = 4,
    onlyText = 5,
    
}LoadingStatus;

@interface YSKJ_CanvasLoading : UIView

@property (nonatomic, strong) UILabel *bgView;

@property (nonatomic, strong) UILabel *lable;

@property (nonatomic, strong) UIImageView *loadingGifView;

@property (nonatomic, strong) UIImageView *onlyGifImageView;

@property (nonatomic, strong) UIImageView *finishImageView;

+(void)showNotificationViewWithText:(NSString *)text loadType:(LoadingStatus)type;



@end
