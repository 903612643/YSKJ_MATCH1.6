//
//  YSKJ_SideView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/31.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectIndexBlock)(NSInteger selectIndex,UIButton *button);


@interface YSKJ_SideView : UIView
{
    NSArray *image;
    NSArray *image1;
}

@property (nonatomic, copy)SelectIndexBlock selectBlock;

@property (nonatomic, retain)NSMutableArray *sideButtonArr;

@end
