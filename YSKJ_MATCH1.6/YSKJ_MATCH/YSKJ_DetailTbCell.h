//
//  YSKJ_DetailTbCell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/1.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YSKJ_LabelLayout.h"
#import "YSKJ_CollectionViewCell.h"

@protocol DetailTbDelegate <NSObject>

@optional
-(void)getItem:(NSString*)item section:(NSInteger)section;

-(void)getLastCellOriY:(float)y;

@end

@interface YSKJ_DetailTbCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,YSKJ_LabelLayoutDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSoure;
    
    
}

@property (nonatomic, weak) UICollectionView* collectionView;

@property (nonatomic, strong) NSMutableArray* titles;

@property (nonatomic ,assign)float width;

@property (nonatomic ,assign)float heigth;

@property (nonatomic, retain) id <DetailTbDelegate> delegate;


@end
