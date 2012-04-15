//  Created by Kevin O'Neill on 3/06/10.
//  Copyright 2010 REA Group. All rights reserved.

#ifdef DEBUG
#define AssertNotNilWithMessage(_var_, _msg_) NSAssert2((_var_ != nil), (@"%s must be supplied: %s"), (#_var_), (#_msg_))
#else
#define AssertNotNilWithMessage(_var_, _msg_) ((void)0)
#endif

#ifdef DEBUG
#define AssertNotNil(_var_) NSAssert1(_var_ != nil, @"%s must be supplied", #_var_)
#else
#define AssertNotNil(_var_) ((void)0)
#endif

#ifdef DEBUG
#define AssertNotEmpty(_string_) NSAssert1((_string_ != nil && [_string_ length] > 0u), @"%s must be supplied and not be empty", #_string_)
#else
#define AssertNotEmpty(_string_) ((void)0)
#endif

#ifdef DEBUG
#define AssertInstanceOf(_var_, _class_) NSAssert2([((id <NSObject>)_var_) isKindOfClass:[_class_ class]], @"%s must be and instance of %s", #_var_, #_class_)
#else
#define AssertInstanceOf(_var_, _class_) ((void)0)
#endif

#ifdef DEBUG
#define Assert(_exp_) NSAssert1(_exp_, @"assertion failed %s", #_exp_)
#else
#define Assert(_exp_) ((void)0)
#endif

#ifdef DEBUG
#define AssertWithMessage(_exp_, _desc_, ...) NSAssert(_exp_, _desc_, ##__VA_ARGS__)
#else
#define AssertWithMessage(_exp_, _desc_, ...) ((void)0)
#endif
