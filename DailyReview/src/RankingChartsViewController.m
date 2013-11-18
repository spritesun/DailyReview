//
//  RankingChartsViewController.m
//  DailyReview
//
//  Created by Long Sun on 9/11/12.
//  Copyright (c) 2012 Sunlong. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "RankingChartsViewController.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSArray+Additions.h"
#import "Behavior.h"
#import "BehaviorTableViewCell.h"
#import "UIColor+Additions.h"

@interface RankingChartsViewController () {
    NSArray *_tableData;
}

@end

@implementation RankingChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchTableData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchTableData];
    [[self tableView] reloadData];
}


- (void)fetchTableData {
    _tableData = @[[NSMutableArray array], [NSMutableArray array]];

    NSManagedObjectContext *ctx = [NSManagedObjectContext defaultContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Behavior"];
    __block NSArray *behaviors = nil;
    [ctx performBlockAndWait:^{
        behaviors = [ctx executeFetchRequest:request error:nil];
    }];

    [behaviors each:^(Behavior *behavior) {
        NSNumber *totalCount = [behavior valueForKeyPath:@"events.@sum.count"];
        if (totalCount.intValue > 0) {
            behavior.totalCount = totalCount;
            if (behavior.rank.intValue > 0) {
                [[_tableData first] addObject:behavior];
            } else {
                [[_tableData last] addObject:behavior];
            }
        }
    }];
    [[_tableData first] sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"totalCount" ascending:NO]]];
    [[_tableData last] sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"totalCount" ascending:NO]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSDictionary *) [_tableData objectAtIndex:(NSUInteger) section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BehaviorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BehaviorTableViewCell class])];
    if (nil == cell) {
        cell = [BehaviorTableViewCell cell];
    }

    Behavior *behavior = [[_tableData objectAtIndex:(NSUInteger) indexPath.section] objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = behavior.name;
    [cell displayEventCount:behavior.totalCount];
    return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"功德排行" : @"过失排行";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}
@end
