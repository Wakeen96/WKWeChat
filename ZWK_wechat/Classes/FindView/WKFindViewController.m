//
//  WKFindViewController.m
//  ZWK_wechat
//
//  Created by 周维康 on 16/3/28.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "WKFindViewController.h"

static NSString *findReuseIdentifier = @"findReuseIdentifier";
@interface WKFindViewController ()

@property (strong, nonatomic) NSMutableDictionary *cellDic;
@property (strong, nonatomic) UITableView *mainTableView;
@end

@implementation WKFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setWKDictionary];
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

- (void)setWKDictionary
{
    self.cellDic = [NSMutableDictionary dictionary];
    NSArray *oneArray = [NSArray arrayWithObjects:@"朋友圈", nil];
    NSArray *twoArray = [NSArray arrayWithObjects:@"扫一扫", @"摇一摇", nil];
    NSArray *threeArray = [NSArray arrayWithObjects:@"附近的人", @"漂流瓶", nil];
    NSArray *fourArray = [NSArray arrayWithObjects:@"购物", @"游戏", nil];
    [self.cellDic setValue:oneArray forKey:@"0"];
    [self.cellDic setValue:twoArray forKey:@"1"];
    [self.cellDic setValue:threeArray forKey:@"2"];
    [self.cellDic setValue:fourArray forKey:@"3"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *numString = [NSString stringWithFormat:@"%li",section];
    NSArray *array = self.cellDic[numString];
    return array.count;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:findReuseIdentifier];
    //图片
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
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return headerView;
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
