//
//  NSDictionary+Json.h
//  AdMopubSDK
//
//  Created by 蒋龙 on 2019/9/2.
//  Copyright © 2019 com.YouLoft.CQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Json)

/**
 NSDictionary 转 jsonString
 
 @param jsonDic json字典
 @return json字符串
 */
+ (NSString *)convertNSDictionaryToJsonString:(NSDictionary *)jsonDic;

/**
 jsonString 转 NSDictionary
 
 @param jsonString json字符串
 @return 字典
 */
+ (NSDictionary *)convertJsonStringToNSDictionary:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
