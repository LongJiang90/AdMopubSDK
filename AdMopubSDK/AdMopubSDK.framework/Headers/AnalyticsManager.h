//
//  AnalyticsManager.h
//  AdMopubSDK
//
//  Created by 蒋龙 on 2019/9/2.
//  Copyright © 2019 com.YouLoft.CQ. All rights reserved.
//

#import <Foundation/Foundation.h>





NS_ASSUME_NONNULL_BEGIN

@interface AnalyticsManager : NSObject


/// 自定义统计事件
/// @param keyStr 事件名称
/// @param dicJsonStr 事件参数字典JSON字符串
+ (void)customEventWithKey:(NSString *)keyStr dicJsonStr:(NSString *)dicJsonStr;

/**
 视频填充是否成功

 @param isSuc YES-成功，NO-失败
 */
+ (void)videoFillSuccessfulOrFail:(BOOL)isSuc;

/**
 设置用户当前等级

 @param level 等级
 */
+ (void)setUserLevelId:(int)level DEPRECATED_MSG_ATTRIBUTE("由于友盟改版，该埋点无默认的事件Key，请自行使用自定义事件定义");

/** 玩家支付货币兑换虚拟币.
 
 @param cash 真实货币数量 >=1的整数,最多只保存小数点后2位
 @param source 支付渠道 1-App Store,2-支付宝,3-网银,4-财付通,5-移动通信,6-联通通信,7-电信通信,8-paypal
 @param coin 虚拟币数量 大于等于0的整数, 最多只保存小数点后2位
 */
+ (void)payWithCash:(double)cash source:(int)source coin:(double)coin;

/** 玩家支付货币购买道具.
 
 @param cash 真实货币数量
 @param source 支付渠道
 @param item 道具名称
 @param amount 道具数量
 @param price 道具单价
 */
+ (void)payWithCash:(double)cash source:(int)source item:(NSString *)item amount:(int)amount price:(double)price;

/**
 使用虚拟货币购买道具
 
 @param item 道具名称
 @param amount 道具数量
 @param price 道具单价
 */
+ (void)buyWithItem:(NSString *)item amount:(int)amount price:(double)price;

/**
 玩家使用道具的情况
 
 @param item 道具名称
 @param amount 道具数量
 @param price 道具单价
 */
+ (void)useWithItem:(NSString *)item amount:(int)amount price:(double)price;


/**
 关卡开始
 
 @param levelName 关卡名称
 */
+ (void)startLevel:(NSString *)levelName;

/**
 关卡完成
 
 @param levelName 关卡名称
 */
+ (void)finishLevel:(NSString *)levelName;

/**
 关卡失败
 
 @param levelName 关卡名称
 */
+ (void)failLevel:(NSString *)levelName;

/**
 额外奖励 虚拟货币
 
 @param coin 货币金额
 @param source 类型
 */
+ (void)bonus:(double)coin source:(int)source;

/**
 额外奖励 虚拟道具
 
 @param item 道具名称
 @param amount 道具个数
 @param price 道具单价
 @param source 类型
 */
+ (void)bonus:(NSString *)item amount:(int)amount price:(double)price source:(int)source;

@end

NS_ASSUME_NONNULL_END
