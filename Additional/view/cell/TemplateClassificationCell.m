//
//  TemplateClassificationCell.m
//  Wefafa
//
//  Created by Miaoz on 15/4/1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "TemplateClassificationCell.h"
#import "ModuleCategoryInfo.h"
#import "Globle.h"
#import "Utils.h"
@implementation TemplateClassificationCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TemplateClassificationCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        CGFloat borderWidth = 0.25f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
        self.layer.borderWidth = borderWidth;
        [_lockButton addTarget:self action:@selector(lockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setModuleCategoryInfo:(ModuleCategoryInfo *)moduleCategoryInfo{
    _moduleCategoryInfo = moduleCategoryInfo;
    
    
    NSString *imageurl =[CommMBBusiness changeStringWithurlString:_moduleCategoryInfo.picUrl size:3];
    
    NSString *url = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImageFromURLTOCache([NSURL URLWithString:url], url, ^(UIImage *image) {
        _imageView.image = image;
    }, ^{
        _imageView.image = [UIImage imageNamed:DEFAULT_LOADING_IMAGE];
    });
    _nameLab.text = [NSString stringWithFormat:@"%@",moduleCategoryInfo.name];
    if (_moduleCategoryInfo.isLocked.intValue == 1) {
        _lockButton.hidden = NO;
    }else{
        _lockButton.hidden = YES;
    
    }
}

-(void)lockButtonClick:(id)sender{
    [Utils alertMessage:_moduleCategoryInfo.unLockTip];
}
- (void)awakeFromNib {
    // Initialization code
}

@end
