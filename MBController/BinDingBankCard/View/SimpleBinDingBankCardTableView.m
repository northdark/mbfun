//
//  AlreadyBinDingBankCardTableView.m
//  Wefafa
//
//  Created by Jiang on 2/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SimpleBinDingBankCardTableView.h"
#import "SimpleBinDingBankCardTableViewCell.h"
#import "MyBankCardModel.h"

@interface SimpleBinDingBankCardTableView ()<UITableViewDataSource, UITableViewDelegate, SimpleBinDingBankCardTableViewCellDelegate>

@end

@implementation SimpleBinDingBankCardTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"SimpleBinDingBankCardTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifie];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setMyBankCardModelArray:(NSArray *)myBankCardModelArray{
    _myBankCardModelArray = myBankCardModelArray;
    [self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBankCardModel *model = self.myBankCardModelArray[indexPath.row];
    SimpleBinDingBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifie forIndexPath:indexPath];
    [cell restatrState];
    cell.myBankCardModel = model;
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myBankCardModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

#pragma mark - cellDelegate

- (void)alreadyDeleteCellWithMode:(MyBankCardModel *)model{
    [self.alreadyTableViewDelegate alreadyTableDeleteCellWithMode:model];
}

- (void)alreadySettingDefalutCell:(MyBankCardModel *)model{
    [self.alreadyTableViewDelegate alreadyTableSettingDefalutCell:model];
}

- (void)alreadyStartDrag{
    self.scrollEnabled = NO;
}
- (void)alreadyEndDrag{
    self.scrollEnabled = YES;
}

@end
