//
//  YSKJ_SerLbLayout.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/1.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSKJ_SerLayoutDelegate <NSObject>
/**
 *  数据源代理
 *
 *  @return 标签的标题数组
 */
-(NSArray*)serchLabelLayoutTitlesForLabel;

@end

@interface YSKJ_SerLbLayout : UICollectionViewLayout

@property (nonatomic, weak) id <YSKJ_SerLayoutDelegate> delegate;
/**
 *  同一行之间标签的间距
 */
@property (nonatomic, assign) CGFloat panding;
/**
 *  同一列之间标签的间距
 */
@property (nonatomic, assign) CGFloat rowPanding;

@end

