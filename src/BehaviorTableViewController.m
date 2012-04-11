//
//  BehaviorTableViewController.m
//  MeritDemeritCell
//
//  Created by Long Sun on 10/04/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

NSString * const kBehaviorTableViewCell = @"BehaviorTableViewCell";

#import "BehaviorTableViewController.h"
#import "Behavior.h"
#import "BehaviorFactory.h"

@interface BehaviorTableViewController ()

@end

@implementation BehaviorTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBehaviorTableViewCell];
  
  cell = cell ? cell : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBehaviorTableViewCell];
  Behavior *behavior = [[[BehaviorFactory sharedMerits] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  cell.textLabel.text = behavior.name;
  
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[BehaviorFactory sharedMerits] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[[BehaviorFactory sharedMerits] objectAtIndex:section] count];
}

@end
