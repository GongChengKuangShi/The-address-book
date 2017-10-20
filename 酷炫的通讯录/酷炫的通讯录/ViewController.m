//
//  ViewController.m
//  酷炫的通讯录
//
//  Created by xrh on 2017/10/20.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import "ViewController.h"
#import "LGUIView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    LGUIView    *lgView;
    UITableView *_tableView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatTableView];
    [self creatLGView];
}

- (void)creatTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH - 40, HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (void)creatLGView {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i++) {
        unichar ch = 65 + i;
        NSString *str = [NSString stringWithUTF8String:(char *)&ch];
        [arr addObject:str];
    }
    
    lgView = [[LGUIView alloc] initWithFrame:CGRectMake(WIDTH - 40, 100, 40, HEIGHT - 140) indexArray:arr];
    [self.view addSubview:lgView];
    
    [lgView selectIndexBlock:^(NSInteger section) {
       [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionTop];
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    unichar ch = 65 + section;
    NSString *str = [NSString stringWithUTF8String:(char *)&ch];
    return str;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  26;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:35/255.0 green:94/255.0 blue:44/255.0 alpha:1.0f];
    return cell;
}

@end

