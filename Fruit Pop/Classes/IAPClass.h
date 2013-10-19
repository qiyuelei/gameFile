//
//  IAPClass.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-16.
//
//

#ifndef __Fruit_Pop__IAPClass__
#define __Fruit_Pop__IAPClass__

#include "cocos2d.h"

USING_NS_CC;
class IAPClass
{
    
public:


    void channel();
    void Sharefacebook(int bestScore);
    void ReqProductPrice(int productId);
    void ResProductPrice();
    char* priceLocale;
    char* getpriceLocale();
    
};

#endif /* defined(__Fruit_Pop__IAPClass__) */
