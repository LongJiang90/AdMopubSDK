//
//  UnityAdapter.m
//  Unity-iPhone
//
//  Created by 蒋龙 on 2019/8/27.
//

/*
 在Unity中需要调用的类中定义以下方法以便调用
 //广告相关函数
 [DllImport("__Internal")]
 private static extern void InitUnityAdSdk(string adUnitsJson, string appAppleId, string umengId);
 
 [DllImport("__Internal")]
 private static extern void LoadAndShowBannerAd(string adPostion);
 
 [DllImport("__Internal")]
 private static extern void HideBannerAd();
 
 [DllImport("__Internal")]
 private static extern void LoadInterstitialAd();
 
 [DllImport("__Internal")]
 private static extern void ShowInterstitialAd();
 
 [DllImport("__Internal")]
 private static extern void LoadRewardedVideoAd();
 
 [DllImport("__Internal")]
 private static extern bool HasRewardedVideo();
 
 [DllImport("__Internal")]
 private static extern void ShowRewardedVideoAd();
 
 //统计相关函数
 [DllImport("__Internal")]
 private static extern void SetUserLevelId(int level);
 
 [DllImport("__Internal")]
 private static extern void Pay(double cash, int source, double coin);
 
 [DllImport("__Internal")]
 private static extern void PayItem(double cash, int source, string itemName, int amount, double price);
 
 [DllImport("__Internal")]
 private static extern void Buy(string itemName, int amount, double price);
 
 [DllImport("__Internal")]
 private static extern void Use(string itemName, int amount, double price);
 
 [DllImport("__Internal")]
 private static extern void StartLevel(string levelName);
 
 [DllImport("__Internal")]
 private static extern void FinishLevel(string levelName);
 
 [DllImport("__Internal")]
 private static extern void FailLevel(string levelName);
 
 [DllImport("__Internal")]
 private static extern void Bonus(double coin, int source);
 
 [DllImport("__Internal")]
 private static extern void BonusItem(string itemName, int amount, double price, int source);
 
 */

#import "UnityAdapter.h"

#import <UIKit/UIKit.h>
#import <AdMopubSDK/iOSAdMoPubSDK.h>

#ifdef PLATFORM_IOS
#import "Unity/UnityInterface.h"
#endif


//固定代码
#if defined(__cplusplus)
extern "C"{
#endif
    extern void UnitySendMessage(const char* obj, const char* method, const char* msg);
//    extern NSString* _CreateNSString (const char* string);
#if defined(__cplusplus)
}
#endif

@interface UnityAdapter ()<AdManagerDelegate>

@end


@implementation UnityAdapter

- (UIViewController *)getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

-(BOOL) isAbse {
    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
    if ([localeLanguageCode hasSuffix:@"_CN"] || [localeLanguageCode hasSuffix:@"_HK"] || [localeLanguageCode hasSuffix:@"_MO"] || [localeLanguageCode hasSuffix:@"_TW"]) {
        return NO;
    }else{
        return YES;
    }
}

// SDK中初始化方法
-(void)initUnityAdSdkWithAdUnitsJson:(const char *)adUnitsJson appAppleId:(const char *)appAppleId umengId:(const char *)umengId {
    NSString *adUnitsJsonStr = [NSString stringWithCString:adUnitsJson encoding:NSUTF8StringEncoding];
    NSString *appAppleIdStr = [NSString stringWithCString:appAppleId encoding:NSUTF8StringEncoding];
    NSString *umengIdStr = [NSString stringWithCString:umengId encoding:NSUTF8StringEncoding];
    
//    [AdManager sharedManager].bannerUnitIdsArr = @[@"0ac59b0996d947309c33f59d6676399f"];
//    [AdManager sharedManager].interstitialUnitIdsArr = @[@"4f117153f5c24fa6a3a92b818a5eb630", @"b23d7be60ff047dab5f5d1d03245029f"];
//    if ([self isAbse] == NO) {
//        [AdManager sharedManager].rewardedVideoUnitIdsArr = @[@"926701984"];
//    }else{
//        [AdManager sharedManager].rewardedVideoUnitIdsArr = @[@"98c29e015e7346bd9c380b1467b33850",@"a96ae2ef41d44822af45c6328c4e1eb1"];
//    }
    
    [AdManager sharedManager].delegate = self;
    [[AdManager sharedManager] initAdWithAdUnitsJson:adUnitsJsonStr appAppleId:appAppleIdStr umengId:umengIdStr];
    
}


-(void)loadAndShowBannerAdWithAdPostion:(const char *)adPostion {
//    TopLeft,
//    TopCenter,
//    TopRight,
//    Centered,
//    BottomLeft,
//    BottomCenter,
//    BottomRight
    if (adPostion != nil) {
        float adW = 320;
        float adH = 50;
        NSString *adPostionStr = [NSString stringWithCString:adPostion encoding:NSUTF8StringEncoding];
        CGRect frame = CGRectZero;
        if ([adPostionStr isEqualToString:@"TopLeft"]) {
            frame = CGRectMake(0, Height_StatusBar, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"TopCenter"]) {
            frame = CGRectMake((kDeviceWidth-adW) / 2.0, Height_StatusBar, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"TopRight"]) {
            frame = CGRectMake(kDeviceWidth-adW, Height_StatusBar, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"Centered"]) {
            frame = CGRectMake((kDeviceWidth-adW) / 2.0, (KDeviceHeight/2.0 - adH/2.0), adW, adH);
        }
        if ([adPostionStr isEqualToString:@"BottomLeft"]) {
            frame = CGRectMake(0, KDeviceHeight - adH, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"BottomCenter"]) {
            frame = CGRectMake((kDeviceWidth-adW) / 2.0, KDeviceHeight - adH, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"BottomRight"]) {
            frame = CGRectMake(kDeviceWidth-adW, KDeviceHeight - adH, adW, adH);
        }
        
        UIViewController *rootVC = [self getRootViewController];
        [[AdManager sharedManager] loadAndShowBannerAdWithFrame:frame InView:rootVC.view];
    }
}

-(void)hideBannerAd {
    [[AdManager sharedManager] hiddenBannerAd];
}

-(void)loadInterstitialAd {
    [[AdManager sharedManager] loadInterstitialAd];
}

-(void)showInterstitialAd {
    UIViewController *rootVC = [self getRootViewController];
    [[AdManager sharedManager] showInterstitialAdWithViewController:rootVC];
}

-(void)loadRewardedVideoAd {
    [[AdManager sharedManager] loadRewardedVideoAd];
}

-(bool)hasRewardedVideo {
    return [[AdManager sharedManager] hasRewardedVideo];
}

-(void)showRewardedVideoAd {
    UIViewController *rootVC = [self getRootViewController];
    [[AdManager sharedManager] showRewardedVideoAdWithViewController:rootVC];
}

#pragma mark - 协议函数
/**
 UnitySendMessage(<#const char *#>, <#const char *#>, <#const char *#>);
 *  第一个参数：是unity那边创建的场景对象名
 *  第二个参数：这个对象绑定的C#脚本中的方法
 *  第三个参数：是iOS这边要传给unity那边的参数
 */

//banner加载成功
-(void)bannerDidLoadAd {
    UnitySendMessage("PottingMobile", "bannerDidLoadAd", "");
}

//banner加载失败
-(void)bannerDidFailToLoadWithMsg:(NSString *)errMsg {
    UnitySendMessage("PottingMobile", "bannerDidFailToLoadWithMsg", [self nsstringToCharWithStr:errMsg]);
}

//banner接收到点击事件
-(void)bannerDidReceiveTapEvent {
    UnitySendMessage("PottingMobile", "bannerDidReceiveTapEvent", "");
}


/**
 interstitial加载成功
 */
-(void)interstitialDidLoadAd {
    UnitySendMessage("PottingMobile", "interstitialDidLoadAd", "");
}
/**
 interstitial加载失败， 仅在手动加载单条广告且加载失败时才会调用
 
 @param errMsg 错误msg
 */
-(void)interstitialDidFailToLoadWithMsg:(NSString *)errMsg {
    UnitySendMessage("PottingMobile", "interstitialDidFailToLoadWithMsg",  [self nsstringToCharWithStr:errMsg]);
}
/**
 interstitial接收到点击事件
 */
-(void)interstitialDidReceiveTapEvent {
    UnitySendMessage("PottingMobile", "interstitialDidReceiveTapEvent", "");
}
/**
 interstitial已经显示
 */
-(void)interstitialDidAppear {
    UnitySendMessage("PottingMobile", "interstitialDidAppear", "");
}
/**
 interstitial已经关闭
 */
-(void)interstitialDidDisappear {
    UnitySendMessage("PottingMobile", "interstitialDidDisappear", "");
}



/**
 rewardedVideo加载成功
 */
-(void)rewardedVideoDidLoadAd {
    UnitySendMessage("PottingMobile", "rewardedVideoDidLoadAd", "");
}
/**
 rewardedVideo加载失败， 仅在手动加载单条广告且加载失败时才会调用
 
 @param errMsg 错误msg
 */
-(void)rewardedVideoDidFailToLoadWithMsg:(NSString *)errMsg {
    UnitySendMessage("PottingMobile", "rewardedVideoDidFailToLoadWithMsg",  [self nsstringToCharWithStr:errMsg]);
}
/**
 rewardedVideo接收到点击事件
 */
-(void)rewardedVideoDidReceiveTapEvent {
    UnitySendMessage("PottingMobile", "rewardedVideoDidReceiveTapEvent", "");
}
/**
 rewardedVideo已经显示
 */
-(void)rewardedVideoDidAppear {
    UnitySendMessage("PottingMobile", "rewardedVideoDidAppear", "");
}
/**
 rewardedVideo已经关闭
 */
-(void)rewardedVideoDidDisappear {
    UnitySendMessage("PottingMobile", "rewardedVideoDidDisappear", "");
}
/**
 rewardedVideo播放完成，应该给予奖励
 */
-(void)rewardedVideoAdShouldReward {
    UnitySendMessage("PottingMobile", "rewardedVideoAdShouldReward", "");
}


-(void)showAlertWithTitle:(const char*)title {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithCString:title encoding:NSUTF8StringEncoding] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:okAction];
    UIViewController *rootVC = [self getRootViewController];
    [rootVC presentViewController:alertVC animated:YES completion:nil];
}

-(const char *)nsstringToCharWithStr:(NSString *)str {
    const char *charString = NULL;
    if ([str canBeConvertedToEncoding:NSUTF8StringEncoding]) {
        charString = [str cStringUsingEncoding:NSUTF8StringEncoding];
    }
    return charString;
}



#pragma mark - C++方法

#if defined(__cplusplus)
extern "C"{
#endif
    static UnityAdapter *helper;
    
    //TODO:供u3d调用的c函数
    ///adUnitsJson 同firebase的json字符串
    void InitUnityAdSdk(const char * adUnitsJson,const char * appAppleId,const char * umengId) {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper initUnityAdSdkWithAdUnitsJson:adUnitsJson appAppleId:appflyersId umengId:umengId];
    }
    
    void LoadAndShowBannerAd(const char *adPostion) {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper loadAndShowBannerAdWithAdPostion:adPostion];
    }
    
    void HideBannerAd() {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper hideBannerAd];
    }
    
    void LoadInterstitialAd() {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper loadInterstitialAd];
    }
    
    void ShowInterstitialAd() {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper showInterstitialAd];
    }
    
    void LoadRewardedVideoAd() {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper loadRewardedVideoAd];
    }
    
    bool HasRewardedVideo() {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        return [helper hasRewardedVideo];
    }
    
    void ShowRewardedVideoAd() {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper showRewardedVideoAd];
    }
    
    void ShowOneAlertView(const char *mesStr) {
        
        [helper showAlertWithTitle:mesStr];
        
    }
    
    //统计相关函数
    void SetUserLevelId(int level) {
        [AnalyticsManager setUserLevelId:level];
    }
    
    void Pay(double cash, int source, double coin) {
        [AnalyticsManager payWithCash:cash source:source coin:coin];
    }
    
    void PayItem(double cash, int source, const char * itemName, int amount, double price) {
        NSString *itemNameStr = [NSString stringWithCString:itemName encoding:NSUTF8StringEncoding];
        [AnalyticsManager payWithCash:cash source:source item:itemNameStr amount:amount price:price];
    }
    void Buy(const char * itemName, int amount, double price) {
        NSString *itemNameStr = [NSString stringWithCString:itemName encoding:NSUTF8StringEncoding];
        [AnalyticsManager buyWithItem:itemNameStr amount:amount price:price];
    }
    void Use(const char * itemName, int amount, double price) {
        NSString *itemNameStr = [NSString stringWithCString:itemName encoding:NSUTF8StringEncoding];
        [AnalyticsManager useWithItem:itemNameStr amount:amount price:price];
    }
    void StartLevel(const char * levelName) {
        NSString *levelNameStr = [NSString stringWithCString:levelName encoding:NSUTF8StringEncoding];
        [AnalyticsManager startLevel:levelNameStr];
    }
    void FinishLevel(const char * levelName) {
        NSString *levelNameStr = [NSString stringWithCString:levelName encoding:NSUTF8StringEncoding];
        [AnalyticsManager finishLevel:levelNameStr];
    }
    void FailLevel(const char * levelName) {
        NSString *levelNameStr = [NSString stringWithCString:levelName encoding:NSUTF8StringEncoding];
        [AnalyticsManager failLevel:levelNameStr];
    }
    void Bonus(double coin, int source) {
        [AnalyticsManager bonus:coin source:source];
    }
    
    void BonusItem(const char * itemName, int amount, double price, int source) {
        NSString *itemNameStr = [NSString stringWithCString:itemName encoding:NSUTF8StringEncoding];
        [AnalyticsManager bonus:itemNameStr amount:amount price:price source:source];
    }
    
    
#if defined(__cplusplus)
}
#endif

@end
