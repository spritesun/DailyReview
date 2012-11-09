// Created by Long Sun on 6/11/12.
//  Copyright (c) 2012 Sunlong. All rights reserved.

@interface NSString (Additions)
- (BOOL)isBlank;

- (BOOL)isNotBlank;

- (NSString *)stringByTrimmingWhitespaceAndNewline;
@end