//
//  UnityAdapter.m
//  Unity-iPhone
//
//  Created by 蒋龙 on 2019/8/27.
//

/*
 在Unity中需要调用的类中定义以下方法以便调用
 [DllImport("__Internal")]
 private static extern void InitUnityAdSdk(string bannerAdUnits, string interstitialAdUnits, string rewardedVideoAdUnits);
 
 [DllImport("__Internal")]
 private static extern void LoadAndShowBannerAd(bool isTop);
 
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
 
 */

#import "UnityAdapter.h"

#import <UIKit/UIKit.h>
#import <AdMopubSDK/iOSAdMoPubSDK.h>
#import "Unity/UnityInterface.h"

//固定代码
#if defined(__cplusplus)
extern "C"{
#endif
    extern void UnitySendMessage(const char *, const char *, const char *);
    extern NSString* _CreateNSString (const char* string);
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
-(void)initUnityAdSdkWithBannerAdUnits:(const char *)bannerAdUnits interstitialAdUnits:(const char *)interstitialAdUnits rewardedVideoAdUnits:(const char *)rewardedVideoAdUnits {
    NSString *bannerIDsStr = [NSString stringWithCString:bannerAdUnits encoding:NSUTF8StringEncoding];
    NSString *interstitialIDsStr = [NSString stringWithCString:interstitialAdUnits encoding:NSUTF8StringEncoding];
    NSString *rewardedVideoIDsStr = [NSString stringWithCString:rewardedVideoAdUnits encoding:NSUTF8StringEncoding];
    
    NSString *sepStr = @",";
    NSArray *bannerIdsArr = [bannerIDsStr containsString:sepStr]?@[bannerIDsStr]:[bannerIDsStr componentsSeparatedByString:sepStr];
    NSArray *interstitialIdsArr = [interstitialIDsStr containsString:sepStr]?@[interstitialIDsStr]:[interstitialIDsStr componentsSeparatedByString:sepStr];
    NSArray *rewardedIdsArr = [rewardedVideoIDsStr containsString:sepStr]?@[rewardedVideoIDsStr]:[rewardedVideoIDsStr componentsSeparatedByString:sepStr];
    
    [AdManager sharedManager].bannerUnitIdsArr = @[@"0ac59b0996d947309c33f59d6676399f"];
    [AdManager sharedManager].interstitialUnitIdsArr = @[@"4f117153f5c24fa6a3a92b818a5eb630", @"b23d7be60ff047dab5f5d1d03245029f"];
    if ([self isAbse] == NO) {
        [AdManager sharedManager].rewardedVideoUnitIdsArr = @[@"926701984"];
    }else{
        [AdManager sharedManager].rewardedVideoUnitIdsArr = @[@"98c29e015e7346bd9c380b1467b33850",@"a96ae2ef41d44822af45c6328c4e1eb1"];
    }
    
    [AdManager sharedManager].delegate = self;
    [[AdManager sharedManager] initAd];
    
}
-(void)loadAndShowBannerAdWithIsTop:(BOOL)isTop {
    UIViewController *rootVC = [helper getRootViewController];
    CGRect frame = isTop?CGRectMake(0, 20, 320, 50) : CGRectMake(0, rootVC.view.frame.size.height -51, 320, 50);
    [[AdManager sharedManager] loadAndShowBannerAdWithFrame:frame InView:rootVC.view];
}

-(void)hideBannerAd {
    [[AdManager sharedManager] hiddenBannerAd];
}

-(void)loadInterstitialAd {
    [[AdManager sharedManager] loadInterstitialAd];
}

-(void)showInterstitialAd {
    UIViewController *rootVC = [helper getRootViewController];
    [[AdManager sharedManager] showInterstitialAdWithViewController:rootVC];
}

-(void)loadRewardedVideoAd {
    //单次加载
    [[AdManager sharedManager] loadRewardedVideoAd];
    //自动缓存
    //        UIViewController *rootVC = [helper getRootViewController];
    //        [[AdManager sharedManager] showRewardedVideoAdWithViewController:rootVC];
}

-(bool)hasRewardedVideo {
    return [[AdManager sharedManager] hasRewardedVideo];
}

-(void)showRewardedVideoAd {
    //单次加载
    //    [[AdManager sharedManager] loadRewardedVideoAd];
    //自动缓存
    UIViewController *rootVC = [helper getRootViewController];
    [[AdManager sharedManager] showRewardedVideoAdWithViewController:rootVC];
}

#pragma mark - 协议函数
/**
 UnitySendMessage(<#const char *#>, <#const char *#>, <#const char *#>);
 *  第一个参数：是unity那边创建的场景对象名
 *  第二个参数：这个对象绑定的C#脚本中的方法
 *  第三个参数：是iOS这边要传给unity那边的参数
 */
-(void)interstitialDidLoadAd {
//    UnitySendMessage("SdkUse", "GetIosMessage", "interstitialDidLoadAd");
}

-(void)rewardedVideoDidLoadAd {
    UnitySendMessage("Main Camera", "GetIosMessage", "rewardedVideoDidLoadAd");
}
-(void)rewardedVideoDidDisappear {
//    UnitySendMessage("SdkUse", "GetIosMessage", "rewardedVideoDidDisappear");
}
-(void)rewardedVideoAdShouldReward {
//    UnitySendMessage("SdkUse", "GetIosMessage", "rewardedVideoAdShouldReward");
}

-(void)showAlertWithTitle:(const char*)title {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithCString:title encoding:NSUTF8StringEncoding] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:okAction];
    UIViewController *rootVC = [helper getRootViewController];
    [rootVC presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - C++方法

#if defined(__cplusplus)
extern "C"{
#endif
    static UnityAdapter *helper;
    
    //TODO:供u3d调用的c函数
    ///bannerAdUnits、interstitialAdUnits、rewardedVideoAdUnits如有多个时，用","隔开
    void InitUnityAdSdk(const char * bannerAdUnits,const char * interstitialAdUnits,const char * rewardedVideoAdUnits) {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper initUnityAdSdkWithBannerAdUnits:bannerAdUnits interstitialAdUnits:interstitialAdUnits rewardedVideoAdUnits:rewardedVideoAdUnits];
        
    }
    
    void LoadAndShowBannerAd(bool isTop) {
        if(helper == NULL){
            helper = [UnityAdapter new];
        }
        [helper loadAndShowBannerAdWithIsTop:isTop];
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
    
    
#if defined(__cplusplus)
}
#endif
@end
