//
//  FirstScene.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-9.
//
//

#ifndef __Fruit_Pop__FirstScene__
#define __Fruit_Pop__FirstScene__

#include "cocos2d.h"
#include "GameScene.h"
#include "ParticleSysLayer.h"
#include "EquipMentScene.h"
#include "LanguageLayer.h"
#include "SoundLayer.h"
#include "IAPClass.h"
#include "ChannelClass.h"
#include "cocos-ext.h"
#include <string>

USING_NS_CC;
USING_NS_CC_EXT;
using namespace std;

class FirstScene:public CCLayer {
    
public:
    FirstScene();
    ~FirstScene();
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(FirstScene);
    
    ChannelClass* channel;
  int showBuyStatMenuTag = 1000;
    SoundLayer* soundLayer;
    LanguageLayer* languageLayer;
    CCProgressTimer* ct;
    float ct_time;
    int extraTime;
    int extraTimeLeve;
    CCLabelTTF* equipmentTimeTTF;
    
    //ShopCar
    bool isPurshasing;
    void changeBuyStat();
    int changeBuyDt;
    int curPurchaseProductId;
    IAPClass* iAPClass;
    CCSpriteBatchNode* _shopCarGoldBgNode;
    CCSpriteBatchNode* _soundBg;
    CCNode* ShopCarNode;
    CCArray* _shopCarBtnArray;
    void initShopCar();
    void shopCarMove();
    void shopCarBtnCallBack(CCMenuItemImage* buyBtn);
    void shopCarAddGoldBg();
    void shopCarAddNumBg();
    void shopCarAddPriceBg();
    void shopCarAddBuyBtn();
    
    void showBuyStatWin(int ProductId);
    void showBuyBtn(CCMenuItemImage* showBuyBtn);
    CCNode* showBuyStatWinNode;
    CCLabelTTF* buyOkTTF;
    CCLabelTTF* buyStatTTF;
    CCMenuItemImage* ShowBuyokBtn;
    
    void ReqpurchaseProduct(int ProductId);
    void getPurchaseStat();
    
    void ReqProductPrice(int ProductId);
    void getProductPrice();
    void getProductPriceDelay();
    int purchaseStat;
    int curReqProductPriceId;
    //equipment
    int curGold;
    int equipmentOrder;
    void initequipment();
    void moveequipment();
    void increase15CallBack(CCObject* pSender);
    void equipmentCallBack(CCObject* pSender);
    void startBtnCallBack();
    void homeBtnCallBack();
    void buyBtnCallBack();
    
    bool _EquipmentWugui = false;
    bool _EquipmentZhadan = false;
    bool _EquipmentZhongbiao = false;
    
    CCNode* equipmentNode;
    CCSprite* zhongbiaobei;
    CCLabelTTF* zhongbiaoTitle;
    CCLabelTTF* zhongbiaoDec;
    CCSprite* zhadanbei;
    CCLabelTTF* zhadanTitle;
    CCLabelTTF* zhadanDec;
    CCSprite* wuguibei;
    CCLabelTTF* wugaiTitle;
    CCLabelTTF* wugaiDec;
    CCLabelTTF* goldTTF;
    
  //  int mapTag = 300;
    CCSize winSize;

    int pMenuTag = 100;
    int pLanguageMenuTag = 200;
    int pLanguageMenuNodeTag = 300;
    int footTTFTag = 201;
    int pLanguageTitleTTFTag = 202;
    
    int _curLanguageType;
    
    //Language* languageLayer;
    CCLabelTTF* titleTTF;
    
    CCTMXObjectGroup*  _languageObjGroup;
    CCTMXObjectGroup* _pgroup;
    CCMenuItemToggle* pBgAudio;
    CCMenuItemToggle* pEfAudio;
    CCArray* languageContentsArray;
    //CCArray* languageItemArray;
    CCArray* languageBtnArray;
    
    CCDictionary* languageDIC;
    
    void initBg();
    void initMenu();
    void initLanguageMenu();
    void moveLanguageMenu();
    void languageSelectCallBack(CCObject* pSender);
    
    void initGameData();
    void playerBtnCallBack();
    void facebookBtnCallBack();
    void configBtnCallBack();
    void menuBackGroundMusicback(CCMenuItemSprite* pSender);
    
    void onEnter();
    void onExit();
};

#endif /* defined(__Fruit_Pop__FirstScene__) */
