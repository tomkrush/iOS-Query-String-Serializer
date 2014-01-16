//
//  KRSQueryDataSerializer.h
//  HTTP Query Data Serializer
//
//  Created by Tom Krush on 1/16/14.
//  Copyright (c) 2014 Tom Krush. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * KRSHTTPBuildKeyPath(NSString *keyPath, NSString *key);

extern NSString * KRSHTTPKeyEncode(NSString *key);

extern NSString * KRSHTTPValueEncode(NSString *value);

extern NSString * KRSHTTPValue(NSString *keyPath, id value);

@interface KRSQueryDataSerializer : NSObject

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary;

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary withKeyPath:(NSString *)keyPath;

+ (NSString *)stringFromArray:(NSArray *)array withKeyPath:(NSString *)keyPath;

+ (NSString *)stringFromUnescapedString:(NSString *)string withKeyPath:(NSString *)keyPath;

@end
