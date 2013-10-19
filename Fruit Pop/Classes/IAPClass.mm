//
//  IAPClass.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-16.
//
//

#include "IAPClass.h"
#include "InAppPurchaseManager.h"
InAppPurchaseManager* _inAppPurchaseManager;
bool isHaveData;
int curProductId;
void shareMothed(int bestScore)
{
   // ShareViewController* share = [[ShareViewController alloc]init];
    //printf("ffff\n");
   // [share shareToSinaWeiboClickHandler:bestScore];
    //[share shareToWeixinClickHandler];
    //[share shareToFacebookClickHandler];
}
void shareFacebookMothed(int bestScore){
  //  ShareViewController* share = [[ShareViewController alloc]init];
  //  [share shareToFacebookClickHandler:bestScore];
    //printf("facebook\n");
    
}
void ReqProductPriceFrIAP(int productId){
    _inAppPurchaseManager = [[InAppPurchaseManager alloc] init];
    [_inAppPurchaseManager requestProduct:productId];
    //CCLOG("test");
}

void IAPClass::channel()
{
    shareMothed(1009);
}
void IAPClass::Sharefacebook(int bestScore){
    shareFacebookMothed(bestScore);
    // shareMothed(bestScore);
}

void IAPClass::ReqProductPrice(int productId){
    ReqProductPriceFrIAP(productId);
        isHaveData = false;
    curProductId = productId;
    priceLocale = NULL;
}
void IAPClass::ResProductPrice(){
    if (isHaveData == false) {
        if ([_inAppPurchaseManager responPriceLocaleNSString] != NULL) {
            char* lo = [_inAppPurchaseManager responPriceLocaleChar];
            NSLog(@"loValue:%s",lo);
            priceLocale = lo;
           // NSLog(@"priceLocaleCharValue:%s",[_inAppPurchaseManager responPriceLocaleChar]);
          NSLog(@"priceLocaleCharValue:%s",priceLocale);
            isHaveData = true;
            switch (curProductId) {
                case 0:
                    CCLOG("a");
                    //[priceLocaleNSString UTF8String];
                    break;
                case 1:
                    CCLOG("b");
                    break;
                case 2:
                    CCLOG("c");
                    break;
                case 3:
                    CCLOG("d");
                    break;
                case 4:
                    CCLOG("e");
                    break;
                default:
                    break;
            }
            // NSLog(@"sadfsdf:%@",priceLocaleNSString);
        };
    }
}
char* IAPClass::getpriceLocale(){
    return priceLocale;
}