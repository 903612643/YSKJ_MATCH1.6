//
//  YSKJ_SingleCollCell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/9.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_SingleCollCell : UICollectionViewCell
{
    UIImage *panImage;
    float panScale;
}

@property (nonatomic, strong) UIButton *proBut;

@property (nonatomic, strong) UIButton *panBut;

@property (nonatomic ,retain)NSDictionary *obj;


@end
