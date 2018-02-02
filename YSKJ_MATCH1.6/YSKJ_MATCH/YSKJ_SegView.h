//
//  YSKJ_SegView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/3.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_SegView : UIView

typedef void (^selectIndexBlock)(NSInteger selectIndex);

@property (nonatomic, copy) selectIndexBlock selectBlock;

@property (nonatomic ,copy) NSArray *titeleArray;

@end
