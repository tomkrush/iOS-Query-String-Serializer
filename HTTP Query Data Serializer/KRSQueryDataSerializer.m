//
//  KRSQueryDataSerializer.m
//  HTTP Query Data Serializer
//
//  Created by Tom Krush on 1/16/14.
//  Copyright (c) 2014 Tom Krush. All rights reserved.
//

#import "KRSQueryDataSerializer.h"

NSString * KRSHTTPBuildKeyPath(NSString *keyPath, NSString *key) {
    key = KRSHTTPKeyEncode(key);

    if ( ! keyPath )
    {
        return key;
    }

    keyPath = [NSString stringWithFormat:@"%@[%@]", keyPath, key];
    
    return keyPath;
}

NSString * KRSHTTPKeyEncode(NSString *key) {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *escaped = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)key,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#",
                                                            kCFStringEncodingUTF8));
    return escaped;
}

NSString * KRSHTTPValueEncode(NSString *value) {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *escaped = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)value,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                            kCFStringEncodingUTF8));
    return escaped;
}

NSString * KRSHTTPValue(NSString *keyPath, id value) {

    NSString *output = nil;
        
    if ( [value isKindOfClass:[NSString class]] )
    {
        output = [KRSQueryDataSerializer stringFromUnescapedString:value withKeyPath:keyPath];
    }
    else if ( [value isKindOfClass:[NSNumber class]] )
    {
        output = [KRSQueryDataSerializer stringFromUnescapedString:[value stringValue] withKeyPath:keyPath];
    }
    else if ( [value isKindOfClass:[NSArray class]] )
    {
        output = [KRSQueryDataSerializer stringFromArray:value withKeyPath:keyPath];
    }
    else if ( [value isKindOfClass:[NSDictionary class]] )
    {
        output = [KRSQueryDataSerializer stringFromDictionary:value withKeyPath:keyPath];
    }

    return output;
}

@implementation KRSQueryDataSerializer

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary
{
    return [self stringFromDictionary:dictionary withKeyPath:nil];
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary withKeyPath:(NSString *)keyPath
{
    NSMutableArray *pairs = [NSMutableArray array];
    
    for (NSString *key in [dictionary keyEnumerator])
    {
        id value = [dictionary objectForKey:key];
        NSString *output = KRSHTTPValue(KRSHTTPBuildKeyPath(keyPath, key), value);
        
        if ( output )
        {
            [pairs addObject:output];
        }
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)stringFromArray:(NSArray *)array withKeyPath:(NSString *)keyPath
{
    NSMutableArray *pairs = [NSMutableArray array];

    NSInteger index = 0;

    for ( id value in array )
    {
        NSString *key = [NSString stringWithFormat:@"%d", index];
        NSString *output = KRSHTTPValue(KRSHTTPBuildKeyPath(keyPath, key), value);
        
        if ( output )
        {
            [pairs addObject:output];
        }
    
        index++;
    }

    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)stringFromUnescapedString:(NSString *)string withKeyPath:(NSString *)keyPath
{
    NSString *escapedString = KRSHTTPValueEncode(string);
    
    return [NSString stringWithFormat:@"%@=%@", keyPath, escapedString];
}

@end
