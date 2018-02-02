//
//  YSKJ_CateoryTbCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/1.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_CateoryTbCell.h"

#import "YSKJ_CateCollCell.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_CateoryTbCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((([UIScreen mainScreen].bounds.size.width - 50)/2 - 64)/3, 100);
        
        _collect = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 54, 100, 80) collectionViewLayout:layout];
        _collect.backgroundColor = UIColorFromHex(0x354048);
        _collect.delegate=self;
        _collect.dataSource=self;
        [_collect registerClass:[YSKJ_CateCollCell class] forCellWithReuseIdentifier:@"cellid"];
        [self addSubview:_collect];

    }
    
    return self;
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.data.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YSKJ_CateCollCell *Cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    Cell.title = [self.data[indexPath.item] objectForKey:@"display_name"];
    
    Cell.imageName = _imageNameArr[indexPath.row];
    
    
    
    return Cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getCateoryDict:)]) {
        [self.delegate getCateoryDict:self.data[indexPath.item]];
    }
    
}


//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {10,16,10,16};
    return top;
}

-(void)setWidth:(float)width{
    
    _width = width;
    _collect.frame = CGRectMake(0, 0, width, 500);
    
}

-(void)setHeigth:(float)heigth
{
    _heigth = heigth;
    _collect.frame = CGRectMake(0, 0, self.width, heigth);
}

-(void)setData:(NSArray *)data
{
    _data = data;
    
    if (data.count == 10) {
        _imageNameArr = @[@"Sofa",@"Stool",@"chair",@"Cabinet",@"table",@"Bed",@"dengzi",@"shelf",@"TheMirror",@"TheOther"];
    }else{
        _imageNameArr = @[@"lamp",@"Ornaments",@"Carpet",@"picture",@"Accessories",@"WindowCurtains"];
    }
    
    [_collect reloadData];

}


@end
