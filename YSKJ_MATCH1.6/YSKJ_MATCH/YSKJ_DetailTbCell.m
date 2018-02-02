//
//  YSKJ_DetailTbCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/1.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_DetailTbCell.h"

#import "YSKJ_SideDetaileView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_DetailTbCell

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
        
        YSKJ_LabelLayout* layout = [[YSKJ_LabelLayout alloc] init];
        layout.panding = 10;
        layout.rowPanding = 10;
        layout.delegate = self;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 110) collectionViewLayout:layout];
        self.collectionView = collectionView;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"YSKJ_CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        collectionView.backgroundColor = UIColorFromHex(0x354048);
        [self addSubview:collectionView];

    }
    
    return self;
}

#pragma mark OJLLabelLayoutDelegate
-(NSArray *)OJLLabelLayoutTitlesForLabel{
    return self.titles;
}
#pragma mark UICollectionViewDataSource,UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YSKJ_CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 5;
    
    cell.layer.masksToBounds = YES;
    
    [cell setTitle:[NSString stringWithFormat:@"%@",self.titles[indexPath.item]]];
    
    if (indexPath.item == self.titles.count - 1) {
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getLastCellOriY:)]) {
            [self.delegate getLastCellOriY:cell.frame.origin.y];
        }
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![(UITableView*)collectionView.superview.superview isKindOfClass:[UITableView class]]) {
        
        NSIndexPath *tabIndexPath = [(UITableView*)collectionView.superview.superview.superview indexPathForCell:(UITableViewCell*)collectionView.superview];
        
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getItem:section:)]) {
            
            [self.delegate getItem:self.titles[indexPath.row] section:tabIndexPath.section];
            
        }
    }else if([(UITableView*)collectionView.superview.superview isKindOfClass:[UITableView class]]){
        
        NSIndexPath *tabIndexPath = [(UITableView*)collectionView.superview.superview indexPathForCell:(UITableViewCell*)collectionView.superview];
        
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getItem:section:)]) {
            
            [self.delegate getItem:self.titles[indexPath.row] section:tabIndexPath.section];
            
        }
    }
    
    
}

-(void)setTitles:(NSMutableArray *)titles
{
    _titles = titles;
    [self.collectionView reloadData];
}

-(void)setWidth:(float)width{
    
    _width = width;
    self.collectionView.frame = CGRectMake(0, 0, width, 110);
    
}

-(void)setHeigth:(float)heigth
{
    _heigth = heigth;
    self.collectionView.frame = CGRectMake(0, 0, self.width, heigth);
}

@end
