//
//  YSKJ_CateoryTbCell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/1.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSKJ_CateoryTbCellDelegate <NSObject>

@optional

-(void)getCateoryDict:(NSDictionary*)dict;

@end

@interface YSKJ_CateoryTbCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collect;
    
    NSArray *_imageNameArr;
}

@property (nonatomic ,assign)float width;

@property (nonatomic ,assign)float heigth;

@property (nonatomic ,copy)NSArray *data;

@property (nonatomic, retain) id <YSKJ_CateoryTbCellDelegate>delegate;

@end
