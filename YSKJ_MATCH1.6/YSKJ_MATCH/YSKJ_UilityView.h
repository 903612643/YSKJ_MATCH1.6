//
//  YSKJ_UilityView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_UilityView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_dataSoure;
}

@property (nonatomic, strong) UICollectionView *uilityColl;

@property (nonatomic, strong) UILabel *spaTitle ;

@property (nonatomic, strong) UILabel *listTitle;

@property (nonatomic , strong) UIButton *returnSpa;

@end
