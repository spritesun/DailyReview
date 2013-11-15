//
//  TimeLineViewController.m
//  DailyReview
//
//  Created by Long Sun on 9/11/12.
//  Copyright (c) 2012 Sunlong. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TimeLineViewController.h"
#import "NSManagedObjectContext+Additions.h"
#import "NSFetchedResultsController+Additions.h"
#import "BehaviorTableViewCell.h"
#import "Event.h"
#import "BehaviorSectionHeaderView.h"
#import "NSArray+Additions.h"
#import "UIColor+Additions.h"

@interface TimeLineViewController () {
    NSFetchedResultsController *_resultsController;
    NSDateFormatter *_dateFormatter;
}
@end

@implementation TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self resultsController] performFetch:nil];

    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _dateFormatter.dateStyle = NSDateFormatterLongStyle;
    _dateFormatter.timeStyle = NSDateFormatterNoStyle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self resultsController] performFetch:nil];
    [[self tableView] reloadData];
}

- (NSFetchedResultsController *)resultsController {
    if (_resultsController == nil) {
        NSManagedObjectContext *context = [NSManagedObjectContext defaultContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];

        NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSSortDescriptor *countSorter = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
        NSSortDescriptor *rankSorter = [[NSSortDescriptor alloc] initWithKey:@"behavior.rank" ascending:YES];
        [request setSortDescriptors:@[dateSorter, countSorter, rankSorter]];

        request.fetchBatchSize = 20;

        _resultsController =
                [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context
                                                      sectionNameKeyPath:@"date" cacheName:@"TimelineResults"];
    }
    return _resultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.resultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultsController numberOfObjectsInSection:(NSUInteger) section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BehaviorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BehaviorTableViewCell class])];
    if (nil == cell) {
        cell = [BehaviorTableViewCell cell];
    }

    Event *event = [self.resultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = event.behavior.name;
    [cell displayEventCount:event.count];
    return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDate *date = ((Event *) [[[[self.resultsController sections] objectAtIndex:(NSUInteger) section] objects] first]).date;
    return [BehaviorSectionHeaderView viewWithTitle:[_dateFormatter stringFromDate:date]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}
@end
