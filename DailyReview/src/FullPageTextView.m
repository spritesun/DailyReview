// Created by Long Sun on 7/11/12.
//  Copyright (c) 2012 Sunlong. All rights reserved.

#import "FullPageTextView.h"
#import "UIColor+Additions.h"
#import "UIView+Additions.h"

@interface FullPageTextView ()
@property(strong, nonatomic) UITextView *textView;
@property(copy, nonatomic) NSString *content;
@end

@implementation FullPageTextView
- (id)initWithFrame:(CGRect)frame content:(NSString *)content {
  self = [self initWithFrame:frame];
  if (self) {
    self.content = content;
    [self initTextView];
  }
  return self;
}

- (void)initTextView {
  self.textView = [[UITextView alloc] initWithFrame:self.bounds];
  self.textView.backgroundColor = [UIColor creamColor];
  self.textView.textContainerInset = UIEdgeInsetsMake(20, 8, 20, 8);
  self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.textView.text = self.content;
  self.textView.font = [UIFont systemFontOfSize:21];
  self.textView.textColor = [UIColor colorWithRed:.247 green:.165 blue:.094];
  self.textView.editable = NO;
  [self addSubview:self.textView];
}

@end