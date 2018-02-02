//
//  YSKJ_MoveImageView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/7.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MoveBlock)(NSInteger index);

@interface YSKJ_MoveImageView : UIButton

@property (nonatomic ,copy) MoveBlock block;

+(void)showMoveView:(MoveBlock)block;

@end
