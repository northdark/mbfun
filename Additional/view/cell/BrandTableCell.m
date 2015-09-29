//
//  BrandTableCell.m
//  newdesigner
//
//  Created by Miaoz on 14/10/22.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import "BrandTableCell.h"

@implementation BrandTableCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BrandTableCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UITableViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
    }
    _checkImageView.image = [UIImage imageNamed:@"icon_create_check@2x.png"];
    return self;
}

-(void)setBrandMapping:(BrandMapping *)brandMapping{
    _brandMapping = brandMapping;
    _brandNamLab.text = _brandMapping.branD_NAME;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
