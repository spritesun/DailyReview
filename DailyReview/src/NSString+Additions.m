// Created by Long Sun on 6/11/12.
//  Copyright (c) 2012 Sunlong. All rights reserved.

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (BOOL)isBlank {
    return [@"" isEqualToString:[self stringByTrimmingWhitespaceAndNewline]];
}

- (BOOL)isNotBlank {
    return self != nil && ([@"" isEqualToString:[self stringByTrimmingWhitespaceAndNewline]] == NO);
}

- (NSString *)stringByTrimmingWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end