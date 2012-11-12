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
        UIColor *bgColor = [UIColor colorWithRed:0.961 green:0.937 blue:0.863];
        self.backgroundColor = bgColor;
        [self initTextView];
        [self initBgView];
    }
    return self;
}
static const CGFloat inset = 10;

- (void)initTextView {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(inset, 0, self.width - 2 * inset, self.height)];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.text = self.content;
    self.textView.font = [UIFont systemFontOfSize:21];
    self.textView.textColor = [UIColor colorWithRed:.247 green:.165 blue:.094];
    self.textView.editable = NO;
//    self.textView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.textView];
}

- (void)initBgView {
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about-bg"]];
    self.textView.backgroundView = bgView;

    CGSize contentSize = self.textView.contentSize;
    bgView.top = contentSize.height;
    bgView.left = 190;
    self.textView.contentSize = CGSizeMake(contentSize.width, contentSize.height + bgView.height + 20);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textView.frame = CGRectMake(inset, 0, self.width - 2 * inset, self.height);
}

@end