//
//  WKMineViewController.m
//  ZWK_wechat
//
//  Created by 周维康 on 16/3/28.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "WKMineViewController.h"
#import "WKDBOperation.h"

static NSString *mineReuseIdentifier = @"mineReuseIdentifier";
@interface WKMineViewController ()

@property (strong, nonatomic)UITableView *mainTableView;
@property (strong, nonatomic)WKDBOperation *operation;
@property (strong, nonatomic)NSMutableDictionary *cellDic;

@end

@implementation WKMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setWKDictionary];
    self.operation = [[WKDBOperation alloc] init];
    [self.operation databaseOperation];
    self.mainTableView = [[UITableView alloc] init];
    [self initWKTableView:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWKDictionary
{
    self.cellDic = [NSMutableDictionary dictionary];
    NSArray *twoArray = [NSArray arrayWithObjects:@"相册", @"收藏", @"钱包", @"优惠券", nil];
    NSArray *threeArray = [NSArray arrayWithObjects:@"表情", nil];
    NSArray *fourArray = [NSArray arrayWithObjects:@"设置", nil];
    [self.cellDic setValue:twoArray forKey:@"1"];
    [self.cellDic setValue:threeArray forKey:@"2"];
    [self.cellDic setValue:fourArray forKey:@"3"];
}

- (void)initWKTableView:(UITableView *)tableView
{
    tableView.rowHeight = 50;
    tableView.frame = CGRectMake(0, 0, 375, 667);
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *blankHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
    UIView *blankFooterView = [[UIView alloc] init];
    blankFooterView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    tableView.tableHeaderView = blankHeaderView;
    tableView.tableFooterView = blankFooterView;
    //    [tableView mas_makeConstraints:^(MASConstraintMaker *maker){
    //        maker.size.and.bottom.top.left.right.mas_equalTo(self.view);
    //    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellDic.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    } else {
        NSString *string = [NSString stringWithFormat:@"%li",section];
        NSArray *array = self.cellDic[string];
        return array.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineReuseIdentifier];
    if (indexPath.section == 0)
    {
        UIImageView *imageView =[[UIImageView alloc] init];
        imageView.frame = CGRectMake(10, 10, 60, 60);
        
        UIImageView *detailImageView = [[UIImageView alloc] init];
        detailImageView.frame = CGRectMake(355, 28, 24, 24);
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.frame = CGRectMake(80, 20, 225, 18);
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentLeft;
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.font = [UIFont systemFontOfSize:13];
        numberLabel.frame = CGRectMake(80, 42, 225, 18);
        
        NSString *nameString = self.operation.mineDic[@"name"];
        NSString *numberString = [NSString stringWithFormat:@"微信号：%@",self.operation.mineDic[@"number"]];
        
        nameLabel.text = nameString;
        numberLabel.text = numberString;
        imageView.image = [UIImage imageNamed:nameString];
        detailImageView.image = [UIImage imageNamed:@"详情"];
        [cell addSubview:nameLabel];
        [cell addSubview:numberLabel];
        [cell addSubview:imageView];
        [cell addSubview:detailImageView];
    } else {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(12, 10, 26, 26);
    
    UIImageView *detailImageView = [[UIImageView alloc] init];
    detailImageView.frame = CGRectMake(355, 11, 24, 24);
    
    //应用名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.frame = CGRectMake(50, 11, 265, 24);
    
    NSString *cellString = [NSString stringWithFormat:@"%li",indexPath.section];
    NSArray *array = self.cellDic[cellString];
    NSString *nameString = array[indexPath.row];
    
    imageView.image = [UIImage imageNamed:nameString];
    detailImageView.image = [UIImage imageNamed:@"详情"];
    nameLabel.text = nameString;
    
    [cell addSubview:nameLabel];
    [cell addSubview:imageView];
    [cell addSubview:detailImageView];
    }
    return cell;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
