//
//  YSKJ_FavCollCell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/22.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSKJ_FavCollCellDelegate <NSObject>

@optional

-(void)favGetRow:(NSInteger)row;


@end


@interface YSKJ_FavCollCell : UICollectionViewCell

@property (strong, nonatomic)UIButton *button;
@property (strong, nonatomic)UILabel *titleLable;
@property (strong, nonatomic)UILabel *moneyLab;

@property (strong, nonatomic)UIButton *panBut;

@property (strong, nonatomic)UIButton *favBtn;

@property (copy, nonatomic)NSString *url;
@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *money;

@property (nonatomic, copy)NSDictionary *objDict;

@property (nonatomic, copy)NSString *fav;

@property (nonatomic, retain) id <YSKJ_FavCollCellDelegate>delegate;


@end
