//
//  YSKJ_PlanView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSKJ_PlanViewDelegate <NSObject>

@optional

-(void)editPlan:(NSDictionary *)dict;

-(void)deletePlan:(NSDictionary *)dict;

-(void)addPlan;

@end

@interface YSKJ_PlanView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_dataSource;
    
    UIImageView *_nonePlan;
    UILabel *_noTitle;
    
    UIButton *_editBtn;
}

@property (nonatomic, strong) UICollectionView *listColl;

@property (nonatomic, copy)NSString *updata;

@property (nonatomic, retain) id <YSKJ_PlanViewDelegate>delegate;




@end
