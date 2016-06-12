//
//  WKAddressBookViewController.m
//  ZWK_wechat
//
//  Created by 周维康 on 16/3/28.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "WKAddressBookViewController.h"
#import "WKDBOperation.h"

static NSString *ContactReuseIdentifier = @"ContactReuseIdentifier";

@interface WKAddressBookViewController ()

@property (strong, nonatomic) WKDBOperation *operation;
@property (strong, nonatomic) UITableView *mainTableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSArray *funcArray;

@end

@implementation WKAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.operation = [[WKDBOperation alloc] init];
    [self.operation databaseOperation];
    self.funcArray = [[NSArray alloc] initWithObjects:@"新的朋友", @"群聊", @"标签", @"公众号", nil];
    [self.operation.capitalArray insertObject:@"" atIndex:0];
    [self.operation.capitalDic setObject:self.funcArray forKey:@""];
    [self initWKSearchController:self.searchController];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
    [self initWKTableView:self.mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWKSearchController:(UISearchController *)searchController
{
    self.searchArray = [NSMutableArray array];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    for(UIView *view in  [searchController.searchBar subviews]) {
        if([view isKindOfClass:UIButton.class]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(_searchController.searchBar.frame.origin.x, _searchController.searchBar.frame.origin.y, 375, 40);
    _searchController.searchBar.placeholder = @"搜索";
    _searchController.searchBar.keyboardType = UIKeyboardAppearanceDefault;
}

- (void)initWKTableView:(UITableView *)tableView
{
    tableView.rowHeight = 50;
    tableView.frame = CGRectMake(0, 0, 375, 667);
    tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    tableView.sectionIndexTrackingBackgroundColor = [UIColor whiteColor];
    tableView.sectionIndexColor = [UIColor darkGrayColor];
    tableView.tableHeaderView = self.searchController.searchBar;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, 375, 49)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:footerView.frame];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    NSString *footerString = [NSString stringWithFormat:@"%li位联系人", self.operation.friendNameArray.count];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    footerLabel.text = footerString;
    footerLabel.textColor = [UIColor lightGrayColor];
    [footerView addSubview:footerLabel];
    [footerView addSubview:line];
    tableView.tableFooterView = footerView;
    //    [tableView mas_makeConstraints:^(MASConstraintMaker *maker){
    //        maker.size.and.bottom.top.left.right.mas_equalTo(self.view);
    //    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active)
    {
        return 1;
    } else {
    return 27;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = self.operation.capitalArray[section];
    NSMutableArray *array = self.operation.capitalDic[string];
    return array.count;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.operation.capitalArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    NSString *charString = self.operation.capitalArray[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 20, 16)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:13];
    label.text = charString;
    [headerView addSubview:label];
        return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return 0;
    } else {
    NSString *charString = self.operation.capitalArray[section];
    NSMutableArray *array = self.operation.capitalDic[charString];
    if (array.count == 0 || section == 0)
    {
        return 0;
    }
    return 20;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return nil;
    } else {
    NSString *charString = self.operation.capitalArray[section];
    NSMutableArray *array = self.operation.capitalDic[charString];
    if (array.count == 0)
    {
        return nil;
    }
    return charString;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactReuseIdentifier];
    
    //头像
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 10, 30, 30);


    //名片
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.frame = CGRectMake(50, 20, 265, 10);
    
    NSString *charString = self.operation.capitalArray[indexPath.section];
    NSMutableArray *nameArray = self.operation.capitalDic[charString];
    NSString *nameString = [[NSString alloc] init];
    if (self.searchController.active)
    {
        nameString = self.searchArray[indexPath.row];
    } else {
        nameString = nameArray[indexPath.row];
    }
    nameLabel.text = nameString;
    imageView.image = [UIImage imageNamed:nameString];
    [cell addSubview:nameLabel];
    [cell addSubview:imageView];
    
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = self.searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS%@", searchString];
    if (self.searchArray != nil){
        [self.searchArray removeAllObjects];
    }
    self.searchArray = [NSMutableArray arrayWithArray:[self.operation.friendNameArray filteredArrayUsingPredicate:predicate]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
    });
    
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
