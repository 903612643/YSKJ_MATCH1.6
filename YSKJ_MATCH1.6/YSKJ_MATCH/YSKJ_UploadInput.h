//
//  YSKJ_UploadInput.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/18.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_UploadInput : UIView<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UIButton *upLoadBtn;
@property (strong, nonatomic) UIButton *faceBtn;
@property (strong, nonatomic) UITextField *proName;


@end
