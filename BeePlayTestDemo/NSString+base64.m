//
//  NSString+base64.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "NSString+base64.h"

@implementation NSString (base64)
- (NSString *)base64Encode{
    NSData *data =  [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
- (NSString *)base64Decode{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
- (NSString *)replaceString{
    NSMutableString *muString = [NSMutableString stringWithString:self];
    NSArray *currentStrings = @[@"-",@"_",@"c",@"e",@"#",@"x",@"z",
                                @"#",@"C",@"E",@"#",@"X",@"Z",@"#",];
    NSArray *withStrings = @[@"+",@"/",@"#",@"c",@"e",@"#",@"x",
                             @"z",@"#",@"C",@"E",@"#",@"X",@"Z",];
    [currentStrings enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [muString replaceOccurrencesOfString:obj withString:withStrings[idx] options:2 range:NSMakeRange(0, muString.length)];
    }];
    return muString;

}
- (NSString *)replaceString2{
    NSMutableString *muString = [NSMutableString stringWithString:self];
    NSArray *currentStrings = @[@"-",@"_",@"c",@"e",@"#",@"x",@"z",
                                @"#",@"C",@"E",@"#",@"X",@"Z",@"#",];
    currentStrings = [[currentStrings reverseObjectEnumerator] allObjects];
    NSArray *withStrings = @[@"+",@"/",@"#",@"c",@"e",@"#",@"x",
                             @"z",@"#",@"C",@"E",@"#",@"X",@"Z",];
    withStrings = [[withStrings reverseObjectEnumerator] allObjects];
    [withStrings enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [muString replaceOccurrencesOfString:obj withString:currentStrings[idx] options:2 range:NSMakeRange(0, muString.length)];
    }];
    return muString;
    
}
//+ (NSString *)networkingStatesFromStatebar{
//
//}
- (NSString *)URLDecode{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
(__bridge CFStringRef)self,
CFSTR(""),
CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
@end
