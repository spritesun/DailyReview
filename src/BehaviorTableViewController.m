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
  cell.textLabel.text = ((Behavior *)[[BehaviorFactory sharedMerits] objectAtIndex:indexPath.row]).name;
  
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[BehaviorFactory sharedMerits] count];
}

@end
