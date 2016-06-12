//
//  ViewController.m
//  ZWK_wechat
//
//  Created by 周维康 on 16/3/21.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "WKMainViewController.h"
#import "Masonry.h"
#import "WKDBOperation.h"

static NSString *usernameReuseIdentifier = @"usernameReuseIdentifier";

@interface WKMainViewController ()

@property (strong, nonatomic)WKDBOperation *operation;
@property (strong, nonatomic)UITableView *mainTableView;
@property (strong, nonatomic)UISearchController *searchController;
@property (strong, nonatomic)NSMutableArray *searchArray;
@property (strong, nonatomic)NSMutableArray *friendSearchArray;

@end

@implementation WKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.searchArray = [NSMutableArray array];
    self.friendSearchArray = [NSMutableArray array];
    self.operation = [[WKDBOperation alloc] init];
    [self.operation databaseOperation];
    [self initWKSearchController:self.searchController];
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
     [self initWKTableView:self.mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWKTableView:(UITableView *)tableView
{
    tableView.rowHeight = 60;
    tableView.frame = CGRectMake(0, 0, 375, 667);
    tableView.tableHeaderView = self.searchController.searchBar;
//    [tableView mas_makeConstraints:^(MASConstraintMaker *maker){
//        maker.size.and.bottom.top.left.right.mas_equalTo(self.view);
//    }];
 
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return self.searchArray.count;
    } else {
    return self.operation.messageDic.count;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:usernameReuseIdentifier];
    
    
//    CGFloat cellH = cell.frame.size.height;
//    CGFloat mainViewW = self.view.frame.size.width;
    //头像图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 10, 40, 40);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 3.0;
//    [imageView mas_makeConstraints:^(MASConstraintMaker *maker){
//        maker.left.and.top.bottom.mas_equalTo(-10);
//        maker.height.and.width.mas_equalTo(cellH - 20);
//    }];
//    
//    CGFloat imageViewH = imageView.frame.size.height;
//    CGFloat imageViewW = imageView.frame.size.width;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor grayColor];
    [timeLabel.font fontWithSize:10.0];
    timeLabel.frame = CGRectMake(325, 15, 40, 15);
//    [timeLabel mas_makeConstraints:^(MASConstraintMaker *maker){
//        maker.top.mas_equalTo(-15);
//        maker.height.mas_equalTo(imageViewH/2-10);
//        maker.right.mas_equalTo(-10);
//        maker.width.mas_equalTo(imageViewW - 10);
//    }];
    
//    CGFloat timeLabelW = timeLabel.frame.size.width;
    
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.frame = CGRectMake(60, 13, 265, 15);
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *maker){
//        maker.top.mas_equalTo(-15);
//        maker.height.mas_equalTo(imageViewH/2-10);
//        maker.left.mas_equalTo(20+imageViewW);
//        maker.width.mas_equalTo(mainViewW - imageViewW - timeLabelW - 40);
//    }];
    
    //信息
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.font = [UIFont systemFontOfSize:12];
    messageLabel.frame = CGRectMake(60, 36, 265, 9);
//    [messageLabel mas_makeConstraints:^(MASConstraintMaker *maker){
//        maker.bottom.mas_equalTo(-15);
//        maker.width.and.left.and.height.mas_equalTo(nameLabel);
//    }];
    NSString *nameString = [[NSString alloc] init];
    NSString *messageString = [[NSString alloc] init];
    self.friendSearchArray[indexPath.row] = nameString;
    if (self.searchController.active)
    {
        nameString = self.searchArray[indexPath.row];
        messageString = self.operation.messageDic[nameString];
        NSLog(@"active%@",nameString);
    } else {
    nameString = self.operation.friendNameArray[indexPath.row];
    messageString = self.operation.messageDic[nameString];
    }
    if (![messageString  isEqual: @""])
    {
    nameLabel.text = nameString;
    messageLabel.text = messageString;
    imageView.image = [UIImage imageNamed:nameString];
    
    [cell addSubview:imageView];
    [cell addSubview:timeLabel];
    [cell addSubview:nameLabel];
    [cell addSubview:messageLabel];
    }
    return cell;
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = self.searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS%@", searchString];
    if (self.searchArray != nil){
        [self.searchArray removeAllObjects];
    }
    self.searchArray = [NSMutableArray arrayWithArray:[self.friendSearchArray filteredArrayUsingPredicate:predicate]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
    });
    
}

@end
