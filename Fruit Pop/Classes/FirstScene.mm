//
//  FirstScene.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-9.
//
//

#include "FirstScene.h"
#include "InAppPurchaseManager.h"
InAppPurchaseManager* inAppPurchaseManager;
//NSString* priceLocale;
//char* priceLocale;
//#include "stdcheaders.h"
//using namespace std;
FirstScene::FirstScene(){
    _shopCarGoldBgNode = CCSpriteBatchNode::create("shopCarGoldBg.png");
    CC_SAFE_RETAIN(_shopCarGoldBgNode);
    _soundBg = CCSpriteBatchNode::create("sound.png");
    CC_SAFE_RETAIN(_soundBg);
    _shopCarBtnArray = CCArray::create();
    CC_SAFE_RETAIN(_shopCarBtnArray);
   // languageBtnArray = CCArray::create();
   // CC_SAFE_RETAIN(languageBtnArray);
}
FirstScene::~FirstScene(){
    CC_SAFE_RELEASE_NULL(_shopCarGoldBgNode);
    CC_SAFE_RELEASE_NULL(_shopCarBtnArray);
    CC_SAFE_RELEASE_NULL(_soundBg);
   // CC_SAFE_RELEASE_NULL(languageBtnArray);
}
CCScene* FirstScene::scene(){
    CCScene* scene = CCScene::create();
    scene->addChild(FirstScene::create(),100);
    return scene;
}
bool FirstScene::init(){
    if (CCLayer::init()) {
       // curGold = 100001;
        inAppPurchaseManager = [[InAppPurchaseManager alloc]init];

        extraTime = 0;
        isPurshasing = false;
        languageLayer = new LanguageLayer();
        initGameData();
        winSize = CCDirector::sharedDirector()->getWinSize();
        initBg();
        initMenu();
       // initLanguageMenu();
        initequipment();
        initShopCar();
        soundLayer = new SoundLayer();
        soundLayer->playBgSound(1);
        return true;
    }else{
        return false;
    }
}

void FirstScene::initBg(){
   // languageLayer = new Language();
    //languageLayer = Language::create();
   // addChild(languageLayer);
   // languageLayer->getlabelChar("ScoreBgTTF", 1);
   // CCLog("ttf:%s",languageLayer->getlabelChar("ScoreBgTTF", 1));
    
    CCTMXTiledMap* m_GameMap = CCTMXTiledMap::create("FruitPopMapFirstScene.tmx");
    m_GameMap->setScale(0.5);
    addChild(m_GameMap);
    
   // _pgroup = m_GameMap->objectGroupNamed("menuLayer");
   // _languageObjGroup = m_GameMap->objectGroupNamed("languageObjLayer");
    
    ParticleSysLayer* particleSysLayer = ParticleSysLayer::create();
    addChild(particleSysLayer);
    particleSysLayer->ParticlePlay(1,CCPointMake(100, 460));
}
void FirstScene::initMenu(){
    CCMenuItemImage* playerBtn = CCMenuItemImage::create("playBtn.png", "playBtn_after.png",this,menu_selector(FirstScene::playerBtnCallBack));
    playerBtn->setPosition(ccp(160, 120));
    playerBtn->setScale(0.5);
    
    CCMenuItemImage* facebookBtn = CCMenuItemImage::create("facebook.png", "facebook_after.png",this,menu_selector(FirstScene::facebookBtnCallBack));
    facebookBtn->setScale(0.27);
    facebookBtn->setPosition(ccp(winSize.width*0.5-60, 40));
    
    CCMenuItemSprite *soundBgOn = CCMenuItemSprite::create( CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(0, 110, 110, 110)), CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(0, 0, 110, 110)));
    CCMenuItemSprite *soundBgOff = CCMenuItemSprite::create( CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(0, 0, 110, 110)), CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(0, 110, 110, 110)));
    if (CCUserDefault::sharedUserDefault()->getIntegerForKey("backGroundMusic",0)==1) {
        pBgAudio = CCMenuItemToggle::createWithTarget(this, menu_selector(FirstScene::menuBackGroundMusicback), soundBgOff,soundBgOn,NULL);
    }else{
        pBgAudio = CCMenuItemToggle::createWithTarget(this, menu_selector(FirstScene::menuBackGroundMusicback), soundBgOn,soundBgOff,NULL);
    }
    pBgAudio->setPosition(ccp(winSize.width*0.5,40));
    pBgAudio->setScale(0.27);
    pBgAudio->setTag(1);
    
    CCMenuItemSprite *soundEfOn = CCMenuItemSprite::create( CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(110, 110, 110, 110)), CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(110, 0, 110, 110)));
    CCMenuItemSprite *soundEfOff = CCMenuItemSprite::create( CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(110, 0, 110, 110)), CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(110, 110, 110, 110)));
    if (CCUserDefault::sharedUserDefault()->getIntegerForKey("soundMusic",0)==1) {
        pEfAudio = CCMenuItemToggle::createWithTarget(this, menu_selector(FirstScene::menuBackGroundMusicback), soundEfOff,soundEfOn,NULL);
    }else{
        pEfAudio = CCMenuItemToggle::createWithTarget(this, menu_selector(FirstScene::menuBackGroundMusicback), soundEfOn,soundEfOff,NULL);
    }
    pEfAudio->setPosition(ccp(winSize.width*0.5+60,40));
    pEfAudio->setScale(0.27);
    pEfAudio->setTag(2);
    
    CCMenu* pMenu = CCMenu::create(playerBtn,facebookBtn,pBgAudio,pEfAudio,NULL);
    pMenu->setPosition(CCPointZero);
    addChild(pMenu,0,pMenuTag);
    
}
void FirstScene::menuBackGroundMusicback(CCMenuItemSprite* pSender){
    if (pSender->getTag() == 2) {
        if (CCUserDefault::sharedUserDefault()->getIntegerForKey("backGroundMusic") == 1) {
            SimpleAudioEngine::sharedEngine()->stopBackgroundMusic();
            CCUserDefault::sharedUserDefault()->setIntegerForKey("backGroundMusic", 0);
        }else{
            CCUserDefault::sharedUserDefault()->setIntegerForKey("backGroundMusic", 1);
            soundLayer->playBgSound(1);
        }
    }else{
        if (CCUserDefault::sharedUserDefault()->getIntegerForKey("soundMusic") == 1) {
            CCUserDefault::sharedUserDefault()->setIntegerForKey("soundMusic", 0);
        }else{
            CCUserDefault::sharedUserDefault()->setIntegerForKey("soundMusic", 1);
        }
    }
    
    CCUserDefault::sharedUserDefault()->flush();
}
void FirstScene::facebookBtnCallBack(){
    int bestScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("curGold");
    ChannelClass* channel = new ChannelClass();
    channel->ShareFaceBook(bestScore);
}
void FirstScene::configBtnCallBack(){
//    CCMenu* pMenu = (CCMenu*)this->getChildByTag(pMenuTag);
//    CCNode* languageNode =(CCNode*)this->getChildByTag(pLanguageMenuNodeTag);
//    pMenu->runAction(CCSequence::create(CCMoveTo::create(0.2f, ccp(pMenu->getPositionX(), pMenu->getPositionY()-480)),NULL));
//    languageNode->runAction(CCSequence::create(CCMoveTo::create(0.2f, ccp(languageNode->getPositionX()+320, languageNode->getPositionY())),NULL));
}
void FirstScene::playerBtnCallBack(){
    soundLayer->playEffect(2);
    moveequipment();
    //CCScene* sc = EquipMentScene::scene();
   // CCDirector::sharedDirector()->replaceScene(sc);
   // CCDirector::sharedDirector()->replaceScene(Test::scene());
}
void FirstScene::initGameData(){
    if (CCUserDefault::sharedUserDefault()->getIntegerForKey("IsFirstEnter",0) == 0) {
       // CCLog("first");
        // CCUserDefault::sharedUserDefault()->setIntegerForKey("LanguageType", 0);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("IsFirstEnter", 1);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("curGold",20000);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("backGroundMusic", 1);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("soundMusic", 1);
        CCUserDefault::sharedUserDefault()->flush();
    }
   // _curLanguageType =  CCUserDefault::sharedUserDefault()->getIntegerForKey("LanguageType", 0);
    curGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("curGold",0);
}
#pragma mark -
#pragma mark Equipment
void FirstScene::initequipment(){
    equipmentNode = CCNode::create();
    equipmentNode->setPosition(ccp(-320, 0));
    addChild(equipmentNode);
    
    CCSprite* equipmentBigBg = CCSprite::create("scondBg.png");
    equipmentBigBg->setPosition(ccp(winSize.width*0.5, winSize.height*0.5));
    equipmentBigBg->setScale(0.5);
    //equipmentBg->setScaleY(0.6);
    equipmentNode->addChild(equipmentBigBg);
    
    CCSprite* equipmentBg = CCSprite::create("equipmentshow.png");
    equipmentBg->setPosition(ccp(winSize.width*0.5, winSize.height*0.5));
    equipmentBg->setScale(0.5);
    //equipmentBg->setScaleY(0.6);
    equipmentNode->addChild(equipmentBg);
    
    CCSprite* timeProgessBar = CCSprite::create("timeProcessYellow.png");
    timeProgessBar->setPosition(ccp(winSize.width*0.5-23, 219));
    timeProgessBar->setScale(0.5);
    equipmentNode->addChild(timeProgessBar);
    
    ct = CCProgressTimer::create(CCSprite::create("timeProcessBack.png"));
    ct->setPosition(ccp(winSize.width*0.5-23, 219));
     //ct->setType(kCCProgressTimerTypeRadial);
    ct->setScale(0.5);
    ct->setType(kCCProgressTimerTypeBar);
    ct->setMidpoint(ccp(0, 0));
    ct->setBarChangeRate(ccp(1.0f, 0));
    ct->setReverseProgress(true);
    //ct->setOpacity(100);
    
    
    ct_time = 0.01;
    
    ct->setPercentage(ct_time);
    equipmentNode->addChild(ct);
    
    CCSprite* timeProcessTime = CCSprite::create("timeProcessTime.png");
    timeProcessTime->setPosition(ccp(winSize.width*0.5-122, 219));
    timeProcessTime->setScale(0.5);
    equipmentNode->addChild(timeProcessTime);
    
    CCSprite* goldBg = CCSprite::create("goldBg.png");
    goldBg->setPosition(ccp(winSize.width*0.5-65, 380));
    goldBg->setScaleY(0.5);
    goldBg->setScaleX(0.7);
    equipmentNode->addChild(goldBg);
    
    wugaiTitle = CCLabelTTF::create(languageLayer->getChar("tortoise"), "", 30);
    wugaiTitle->setScale(0.4);
    wugaiTitle->setColor(ccc3(0, 0, 0));
    wugaiTitle->setVisible(false);
    wugaiTitle->setPosition(ccp(winSize.width*0.5-75, 280));
    equipmentNode->addChild(wugaiTitle);
    
    wugaiDec = CCLabelTTF::create(languageLayer->getChar("Time slows down"), "Airal", 25, CCSizeMake(150, 80),kCCTextAlignmentCenter);
    wugaiDec->setScale(0.4);
    wugaiDec->setColor(ccc3(0, 0, 0));
    wugaiDec->setVisible(false);
    wugaiDec->setPosition(ccp(winSize.width*0.5-75, 255));
    equipmentNode->addChild(wugaiDec);
    
    wuguibei = CCSprite::create("2000bei.png");
    wuguibei->setPosition(ccp(winSize.width*0.5-75, 120));
    wuguibei->setScale(0.5);
    equipmentNode->addChild(wuguibei);
    
    CCMenuItemImage* wugui = CCMenuItemImage::create("wugui.png", "wugui.png",this,menu_selector(FirstScene::equipmentCallBack));
    wugui->setScale(0.5);
    wugui->setTag(1);
    wugui->setPosition(ccp(winSize.width*0.5-75, 160));
    
//    CCMenuItemImage* wuguiSel = CCMenuItemImage::create("wugui.png", "wugui.png",this,menu_selector(FirstScene::equipmentCallBack));
//    wuguiSel->setScale(0.5);
//    wuguiSel->setPosition(ccp(winSize.width*0.5-75, winSize.height-185));
    zhadanTitle = CCLabelTTF::create(languageLayer->getChar("Bomb"), "", 30);
    zhadanTitle->setScale(0.4);
    zhadanTitle->setColor(ccc3(0, 0, 0));
    zhadanTitle->setVisible(false);
    zhadanTitle->setPosition(ccp(winSize.width*0.5, 280));
    equipmentNode->addChild(zhadanTitle);
    
    zhadanDec = CCLabelTTF::create(languageLayer->getChar("Eliminate the surrounding fruit"), "Airal", 25, CCSizeMake(150, 80),kCCTextAlignmentCenter);
    zhadanDec->setScale(0.4);
    zhadanDec->setColor(ccc3(0, 0, 0));
    zhadanDec->setVisible(false);
    zhadanDec->setPosition(ccp(winSize.width*0.5, 255));
    equipmentNode->addChild(zhadanDec);
    
    zhadanbei = CCSprite::create("2000bei.png");
    zhadanbei->setPosition(ccp(winSize.width*0.5, 120));
    zhadanbei->setScale(0.5);
    equipmentNode->addChild(zhadanbei);
    
    CCMenuItemImage* zhadan = CCMenuItemImage::create("zhadan.png", "zhadan.png",this,menu_selector(FirstScene::equipmentCallBack));
    zhadan->setScale(0.5);
    zhadan->setTag(2);
    zhadan->setPosition(ccp(winSize.width*0.5, 160));
    
//    CCMenuItemImage* zhadanSel = CCMenuItemImage::create("wugui.png", "wugui.png",this,menu_selector(FirstScene::equipmentCallBack));
//    zhadanSel->setScale(0.5);
//    zhadanSel->setPosition(ccp(winSize.width*0.5, winSize.height-185));
    zhongbiaoTitle = CCLabelTTF::create(languageLayer->getChar("Alarm Clock"), "", 30);
    zhongbiaoTitle->setScale(0.4);
    zhongbiaoTitle->setColor(ccc3(0, 0, 0));
    zhongbiaoTitle->setVisible(false);
    zhongbiaoTitle->setPosition(ccp(winSize.width*0.5+75, 280));
    equipmentNode->addChild(zhongbiaoTitle);
    
    zhongbiaoDec = CCLabelTTF::create(languageLayer->getChar("Add 25 seconds"), "Airal", 25, CCSizeMake(150, 80),kCCTextAlignmentCenter);
    zhongbiaoDec->setScale(0.4);
    zhongbiaoDec->setColor(ccc3(0, 0, 0));
    zhongbiaoDec->setVisible(false);
    zhongbiaoDec->setPosition(ccp(winSize.width*0.5+75, 255));
    equipmentNode->addChild(zhongbiaoDec);
    
    zhongbiaobei = CCSprite::create("2000bei.png");
    zhongbiaobei->setPosition(ccp(winSize.width*0.5+75, 120));
    zhongbiaobei->setScale(0.5);
    equipmentNode->addChild(zhongbiaobei);
    
    CCMenuItemImage* zhongbiao = CCMenuItemImage::create("zhongbiao.png", "zhongbiao.png",this,menu_selector(FirstScene::equipmentCallBack));
    zhongbiao->setScale(0.5);
    zhongbiao->setTag(3);
    zhongbiao->setZOrder(1);
    zhongbiao->setPosition(ccp(winSize.width*0.5+75, 160));
    
    //CCMenuItemImage* zhongbiaoSel = CCMenuItemImage::create("zhongbiao.png", "zhongbiao.png",this,menu_selector(FirstScene::equipmentCallBack));
//    zhongbiaoSel->setScale(0.5);
//    zhongbiaoSel->setPosition(ccp(winSize.width*0.5+75, winSize.height-185));
    
    CCMenuItemImage* btn15 = CCMenuItemImage::create("btn15.png", "btn15.png",this,menu_selector(FirstScene::increase15CallBack));
    btn15->setScale(0.5);
    btn15->setPosition(ccp(winSize.width*0.5+105, 220));
    
    CCMenuItemImage* startBtn = CCMenuItemImage::create("playBtn.png", "playBtn.png",this,menu_selector(FirstScene::startBtnCallBack));
    startBtn->setScale(0.5);
    startBtn->setPosition(ccp(winSize.width*0.5, 50));
    
    CCMenuItemImage* HomeBtn = CCMenuItemImage::create("backHome.png", "backHome.png",this,menu_selector(FirstScene::homeBtnCallBack));
    HomeBtn->setScale(0.2);
    HomeBtn->setRotation(180);
    HomeBtn->setPosition(ccp(winSize.width*0.5-100, 50));
    
    CCMenuItemImage* BuyBtn = CCMenuItemImage::create("BuyBtn.png", "BuyBtn.png",this,menu_selector(FirstScene::shopCarMove));
    BuyBtn->setScale(0.5);
    //BuyBtn->setRotation(180);
    BuyBtn->setPosition(ccp(winSize.width*0.5+120, 380));
    
    CCMenu* equipMenu = CCMenu::create(btn15,wugui,zhongbiao,zhadan,startBtn,HomeBtn,BuyBtn,NULL);
    equipMenu->setPosition(CCPointZero);
    equipmentNode->addChild(equipMenu,3);

    
    CCLabelTTF* equipmentTitle = CCLabelTTF::create(languageLayer->getChar("Boosters"), "", 40);
    equipmentTitle->setScale(0.5);
    equipmentTitle->setColor(ccc3(0, 0, 0));
    equipmentTitle->setPosition(ccp(winSize.width*0.5, winSize.height-125));
    equipmentNode->addChild(equipmentTitle);
    
    CCLabelTTF* equipmentTimeExt = CCLabelTTF::create(languageLayer->getChar("Extra time"), "", 30);
    equipmentTimeExt->setScale(0.4);
    equipmentTimeExt->setColor(ccc3(0, 0, 0));
    equipmentTimeExt->setPosition(ccp(winSize.width*0.5-90, 232));
    equipmentNode->addChild(equipmentTimeExt);
    
    CCLabelTTF* equipmentCostTTF = CCLabelTTF::create(languageLayer->getChar("Cost:"), "", 30);
    equipmentCostTTF->setScale(0.4);
    equipmentCostTTF->setColor(ccc3(0, 0, 0));
    equipmentCostTTF->setAnchorPoint(ccp(1, 0.5));
    equipmentCostTTF->setPosition(ccp(winSize.width*0.5+40, 232));
    equipmentNode->addChild(equipmentCostTTF);
    
    CCLabelTTF* equipmentCostScoreTTF = CCLabelTTF::create("500", "", 30);
    equipmentCostScoreTTF->setScale(0.4);
    equipmentCostScoreTTF->setColor(ccc3(0, 0, 0));
    equipmentCostScoreTTF->setAnchorPoint(ccp(0, 0.5));
    equipmentCostScoreTTF->setPosition(ccp(winSize.width*0.5+40, 232));
    equipmentNode->addChild(equipmentCostScoreTTF);
    
    equipmentTimeTTF = CCLabelTTF::create("00:00", "", 30);
    equipmentTimeTTF->setScale(0.3);
    //equipmentTimeTTF->setColor(ccc3(0, 0, 0));
    equipmentTimeTTF->setPosition(ccp(winSize.width*0.5, 219));
    equipmentNode->addChild(equipmentTimeTTF);
    
    //CCLog("curGold:%i",curGold);
    char goldChar[128];
    sprintf(goldChar, "%d",curGold);
    CCLog("curgold:%i",curGold);
    goldTTF = CCLabelTTF::create(goldChar, "", 50);
    goldTTF->setPosition(ccp(winSize.width*0.5-65, 385));
    goldTTF->setScale(0.3);
    equipmentNode->addChild(goldTTF);
    
   // CCLabelTTF* goldFrTimeTTF = CCLabelTTF::create("08:23", "", 65);
  //  goldFrTimeTTF->setScale(0.4);
  //  goldFrTimeTTF->setPosition(ccp(winSize.width*0.5+100, 460));
  //  equipmentNode->addChild(goldFrTimeTTF);
    
 }
void FirstScene::moveequipment(){

        CCMenu* pMenu = (CCMenu*)this->getChildByTag(pMenuTag);
    if (equipmentNode->getPositionX()<0) {
        //equipmentNode->runAction(CCSequence::create(CCMoveTo::create(0.05f, ccp(0, 0)),NULL));
        equipmentNode->setPosition(ccp(0,0));
        pMenu->setPosition(ccp(pMenu->getPositionX(), pMenu->getPositionY()-480));
        //pMenu->runAction(CCSequence::create(CCMoveTo::create(0.2f, ccp(pMenu->getPositionX(), pMenu->getPositionY()-480)),NULL));
            CCLog("move");
    }else{
        equipmentNode->setPosition(ccp(-320,0));
        pMenu->setPosition(ccp(pMenu->getPositionX(), pMenu->getPositionY()+480));
//        equipmentNode->runAction(CCSequence::create(CCMoveTo::create(0.05f, ccp(-320, 0)),NULL));
//        pMenu->runAction(CCSequence::create(CCMoveTo::create(0.2f, ccp(pMenu->getPositionX(), pMenu->getPositionY()+480)),NULL));
    }

}
void FirstScene::increase15CallBack(cocos2d::CCObject *pSender){
    soundLayer->playEffect(2);
    if (curGold >=500) {
    extraTimeLeve++;
    if (extraTime >= 0 && extraTime < 60) {
        extraTime = extraTime + 15;
        ct_time = ct_time + 25;
        char goldChar[128];
        curGold = curGold-500;
        sprintf(goldChar, "%d",curGold);
        goldTTF->setString(goldChar);
        
        time_t timep = extraTime;
        struct tm *ptm = gmtime(&timep);
        char tmp[100] = {0};
        memset(tmp, 0x0, 100);
        strftime(tmp, sizeof(tmp), "%M:%S", ptm);
        equipmentTimeTTF->setString(tmp);
    }
    ct->setPercentage(ct_time);
 }
}
void FirstScene::startBtnCallBack(){
    soundLayer->playEffect(2);
    CCUserDefault::sharedUserDefault()->setIntegerForKey("curGold",curGold);
    CCUserDefault::sharedUserDefault()->setIntegerForKey("extraTime",extraTime);
    CCUserDefault::sharedUserDefault()->setBoolForKey("EquipmentWugui",_EquipmentWugui);
    CCUserDefault::sharedUserDefault()->setBoolForKey("EquipmentZhadan",_EquipmentZhadan);
    CCUserDefault::sharedUserDefault()->setBoolForKey("EquipmentZhongbiao",_EquipmentZhongbiao);
    CCUserDefault::sharedUserDefault()->flush();
    CCScene* scene = GameScene::scene();
    CCDirector::sharedDirector()->replaceScene(scene);
}
void FirstScene::homeBtnCallBack(){
    soundLayer->playEffect(2);
    moveequipment();
    //extraTimeLeve++;
   // if (extraTime >= 0 && extraTime < 60) {
      //  extraTime = extraTime + 15;
      //  ct_time = ct_time + 25;

        char goldChar[128];
        curGold = curGold+500*(extraTime/15);
        sprintf(goldChar, "%d",curGold);
        goldTTF->setString(goldChar);
        
        time_t timep = 0;
        struct tm *ptm = gmtime(&timep);
        char tmp[100] = {0};
        memset(tmp, 0x0, 100);
        strftime(tmp, sizeof(tmp), "%M:%S", ptm);
        equipmentTimeTTF->setString(tmp);
   // }
    ct_time = 0.01;
    ct->setPercentage(ct_time);
    extraTime = 0;
}
void FirstScene::buyBtnCallBack(){}
void FirstScene::equipmentCallBack(CCObject* pSender){
    soundLayer->playEffect(2);
    CCMenuItemImage* equipment = (CCMenuItemImage*)pSender;
   // CCLog("y:%f",equipment->getPositionY());
    if (equipment->getPositionY() < 300) {
        if (curGold >= 2000) {
            
        
        char goldChar[128];
        curGold = curGold-2000;
        sprintf(goldChar, "%d",curGold);
        goldTTF->setString(goldChar);
         equipment->runAction(CCSpawn::create(CCMoveTo::create(0.05f, ccp(equipment->getPositionX(), equipment->getPositionY()+150)),CCScaleTo::create(0.05f, 0.4),NULL));
        //equipment->runAction(CCSequence::create(CCMoveTo::create(0.05f, ccp(equipment->getPositionX(), equipment->getPositionY()+150)),NULL));
        switch (equipment->getTag()) {
            case 1:
               // CCLog("wugui");
                _EquipmentWugui = true;
                wugaiTitle->setVisible(true);
                wugaiDec->setVisible(true);
                wuguibei->setVisible(false);
                break;
            case 2:
              //  CCLog("zhadan");
                _EquipmentZhadan = true;
                zhadanTitle->setVisible(true);
                zhadanDec->setVisible(true);
                zhadanbei->setVisible(false);
                break;
            case 3:
               // CCLog("zhongbiao");
                _EquipmentZhongbiao = true;
                zhongbiaoTitle->setVisible(true);
                zhongbiaoDec->setVisible(true);
                zhongbiaobei->setVisible(false);
                break;
                
            default:
                break;
        }
            }
    }else{
         equipment->runAction(CCSpawn::create(CCMoveTo::create(0.05f, ccp(equipment->getPositionX(), equipment->getPositionY()-150)),CCScaleTo::create(0.05f, 0.5),NULL));
        //equipment->runAction(CCSequence::create(CCMoveTo::create(0.05f, ccp(equipment->getPositionX(), equipment->getPositionY()-150)),NULL));
        char goldChar[128];
        curGold = curGold+2000;
        sprintf(goldChar, "%d",curGold);
        goldTTF->setString(goldChar);
        switch (equipment->getTag()) {
            case 1:
               // CCLog("wugui");
                _EquipmentWugui = false;
                wugaiTitle->setVisible(false);
                wugaiDec->setVisible(false);
                wuguibei->setVisible(true);
                break;
            case 2:
              //  CCLog("zhadan");
                _EquipmentZhadan = false;
                zhadanTitle->setVisible(false);
                zhadanDec->setVisible(false);
                zhadanbei->setVisible(true);
                break;
            case 3:
              //  CCLog("zhongbiao");
                _EquipmentZhongbiao = false;
                zhongbiaoTitle->setVisible(false);
                zhongbiaoDec->setVisible(false);
                zhongbiaobei->setVisible(true);
                break;
                
            default:
                break;
        }
    }

    
}
#pragma mark -
#pragma mark ShopCar
void FirstScene::initShopCar(){
    ShopCarNode = CCNode::create();
    ShopCarNode->setPosition(ccp(-320, 0));
    addChild(ShopCarNode);
    
    CCSprite* equipmentBigBg = CCSprite::create("scondBg.png");
    equipmentBigBg->setPosition(ccp(winSize.width*0.5, winSize.height*0.5));
    equipmentBigBg->setScale(0.5);
    //equipmentBg->setScaleY(0.6);
    ShopCarNode->addChild(equipmentBigBg);
    
    CCSprite* shopCarBg = CCSprite::create("shopCarBg.png");
    shopCarBg->setPosition(ccp(winSize.width*0.5, winSize.height*0.5));
    shopCarBg->setScale(0.5);
    ShopCarNode->addChild(shopCarBg);
    
    
    CCLabelTTF* ShopNameTTF = CCLabelTTF::create(languageLayer->getChar("The Store"), "Verdana-Bold", 45);
    ShopNameTTF->setScale(0.4);
    ShopNameTTF->setPosition(ccp(160, 370));
    ShopNameTTF->setColor(ccc3(0, 0, 0));
    ShopCarNode->addChild(ShopNameTTF, 1);
    
    shopCarAddBuyBtn();
    shopCarAddNumBg();
    //ReqProductPrice(0);
    if (CCUserDefault::sharedUserDefault()->getBoolForKey("IsSaveIAPPrice",false) == true) {
        shopCarAddPriceBg();
    }else{
        ReqProductPrice(0);
    }

    shopCarAddGoldBg();
}
void FirstScene::shopCarMove(){
    soundLayer->playEffect(2);

    if (ShopCarNode->getPositionX()<0) {
        ShopCarNode->setPosition(ccp(0, 0));
        equipmentNode->setPosition(ccp(-320, 0));
        //ShopCarNode->runAction(CCSequence::create(CCMoveTo::create(0.05f, ccp(0, 0)),NULL));
       // equipmentNode->runAction(CCSequence::create(CCMoveTo::create(0.2f, ccp(-320, 0)),NULL));
    }else{
        isPurshasing = false;
        ShopCarNode->setPosition(ccp(-320, 0));
        equipmentNode->setPosition(ccp(0, 0));
       // ShopCarNode->runAction(CCSequence::create(CCMoveTo::create(0.05f, ccp(-320, 0)),NULL));
       // equipmentNode->runAction(CCSequence::create(CCMoveTo::create(0.2f, ccp(0,0)),NULL));
    }

}
void FirstScene::shopCarBtnCallBack(CCMenuItemImage* buyBtn){
    if (isPurshasing == false) {
        isPurshasing = true;
        //this->schedule(schedule_selector(FirstScene::changeBuyStat), 1.0f);
        soundLayer->playEffect(2);
        //CCLOG("carBtnTag:%i",buyBtn->getTag());
        showBuyStatWin(buyBtn->getTag());
        ReqpurchaseProduct(buyBtn->getTag());
    }


}
void FirstScene::shopCarAddGoldBg(){
    for (int i = 0; i < 5; i++) {
        CCPoint pt = CCPointMake(55, 330-i*50);
        for (int j = 0; j < i+1; j++) {
            CCPoint newpt = CCPointMake(pt.x+5*j, pt.y);
            CCSprite* shopCarGoldBg = CCSprite::createWithTexture(_shopCarGoldBgNode->getTexture());
            shopCarGoldBg->setScale(0.3);
            shopCarGoldBg->setPosition(newpt);
            _shopCarGoldBgNode->addChild(shopCarGoldBg, 1);
        }

    }
    ShopCarNode->addChild(_shopCarGoldBgNode);

}
void FirstScene::shopCarAddNumBg(){
 string productNumChar;
    for (int i = 0; i < 5; i++) {
        CCPoint pt = CCPointMake(110, 330-i*50);
        switch (i) {
            case 0:
               // string st = "20000";
           productNumChar = "20000";
                break;
            case 1:
            productNumChar = "50000";
                break;
            case 2:
                productNumChar = "135000";
                break;
            case 3:
               productNumChar = "300000";
                break;
            case 4:
                productNumChar = "700000";
                break;
            default:
                break;
        }
                  // productNumChar = "20000";
        CCLabelTTF* goldNumTTF = CCLabelTTF::create(productNumChar.c_str(), "Verdana-Bold", 45);
        goldNumTTF->setScale(0.2);
        goldNumTTF->setPosition(pt);
        goldNumTTF->setColor(ccc3(0, 0, 0));
        ShopCarNode->addChild(goldNumTTF, 1);
    }
}
void FirstScene::shopCarAddPriceBg(){
    this->unschedule(schedule_selector(FirstScene::shopCarAddPriceBg));
   // ReqProductPrice(0);
                char * priceString = "price_0";
    for (int i = 0; i < 5; i++) {
        CCPoint pt = CCPointMake(180, 330-i*50);
        switch (i) {
            case 0:
                priceString = "price_0";
                break;
            case 1:
                priceString = "price_1";
                break;
            case 2:
                priceString = "price_2";
                break;
            case 3:
                priceString = "price_3";
                break;
            case 4:
                priceString = "price_4";
                break;
            default:
                break;
        }
        
        CCLabelTTF* priceTTF = CCLabelTTF::create(CCUserDefault::sharedUserDefault()->getStringForKey(priceString,"").c_str(), "Verdana-Bold", 45);
        priceTTF->setScale(0.2);
        priceTTF->setPosition(pt);
        priceTTF->setColor(ccc3(0, 0, 0));
        ShopCarNode->addChild(priceTTF, 1);
    }

}
void FirstScene::shopCarAddBuyBtn(){
    soundLayer->playEffect(2);
    for (int i = 0; i< 5; i++) {
        CCPoint pt = CCPointMake(245, 330-i*50);
        CCMenuItemImage* buyBtn = CCMenuItemImage::create("shopCarBuyBtn.png", "shopCarBuyBtn.png",this,menu_selector(FirstScene::shopCarBtnCallBack));
        buyBtn->setScale(0.4);
        buyBtn->setPosition(pt);
        buyBtn->setTag(i);
        _shopCarBtnArray->addObject(buyBtn);
        
        CCLabelTTF* buyTTF = CCLabelTTF::create(languageLayer->getChar("Buy"), "", 50);
        buyTTF->setScale(0.3);
        buyTTF->setPosition(pt);
        buyTTF->setColor(ccc3(75, 250, 5));
        ShopCarNode->addChild(buyTTF, 1);
    }
       CCMenuItemImage* clostBtn = CCMenuItemImage::create("showWinClose.png", "showWinClose_after.png",this,menu_selector(FirstScene::shopCarMove));
        clostBtn->setPosition(ccp(280,380));
    clostBtn->setScale(0.5);
    _shopCarBtnArray->addObject(clostBtn);
    CCMenu* _shopCarMenu = CCMenu::createWithArray(_shopCarBtnArray);
    _shopCarMenu->setPosition(CCPointZero);
    ShopCarNode->addChild(_shopCarMenu);
    


}
void FirstScene::ReqpurchaseProduct(int ProductId){
    //CCLOG("productId:%i",ProductId);
    [inAppPurchaseManager purchaseProduct:ProductId];
    this->schedule(schedule_selector(FirstScene::getPurchaseStat));
}
void FirstScene::getPurchaseStat(){

    purchaseStat = [inAppPurchaseManager responPurchaseStat];
   // CCLOG("purchaseStat:%i",purchaseStat);

    if (purchaseStat>=0) {
        this->unschedule(schedule_selector(FirstScene::getPurchaseStat));
        ShowBuyokBtn->setVisible(true);
        ShowBuyokBtn->setTag(2);
        //buyStatTTF->setString("Your purchase was successful");
        buyStatTTF->setString(languageLayer->getChar("Your purchase was successful"));
        buyOkTTF->setString(languageLayer->getChar("OK"));
        buyOkTTF->setVisible(true);
        [inAppPurchaseManager showPurchaseSecess];
        switch (purchaseStat) {
            case 0:
                curGold = curGold + 20000;
                break;
            case 1:
                curGold = curGold + 50000;
                break;
            case 2:
                curGold = curGold + 135000;
                break;
            case 3:
                curGold = curGold + 300000;
                break;
            case 4:
                curGold = curGold + 700000;
                break;
            default:
                break;
        }
        char goldChar[128];
       // CCLOG("curGold:%i",curGold);
        sprintf(goldChar, "%d",curGold);
        goldTTF->setString(goldChar);
    }else if (purchaseStat == -1){
        this->unschedule(schedule_selector(FirstScene::getPurchaseStat));
        buyStatTTF->setString(languageLayer->getChar("Your purchase was failed"));
               // buyStatTTF->setString("Your purchase was fail");
        buyOkTTF->setString(languageLayer->getChar("Try Again"));
                //buyOkTTF->setString("Try Again");
        buyOkTTF->setVisible(true);
        ShowBuyokBtn->setVisible(true);
        ShowBuyokBtn->setTag(3);
       // CCLOG("purchase Fail");
    }
}

void FirstScene::ReqProductPrice(int ProductId){
    if (ProductId<5) {
       curReqProductPriceId = ProductId;
        [inAppPurchaseManager requestProduct:ProductId];
        this->schedule(schedule_selector(FirstScene::getProductPrice),0.2f);
       // CCLOG("sdfas:%i",curReqProductPriceId);
        //method 2
//        iAPClass = new IAPClass();
//        iAPClass->ReqProductPrice(ProductId);
//        this->schedule(schedule_selector(FirstScene::getProductPrice));
    }
}
void FirstScene::getProductPrice(){
    //method 4
  SKProduct *_proUpgradeProduct = [inAppPurchaseManager resPonproUpgradeProduct];

    if (_proUpgradeProduct) {
          //  CCLOG("fasdf:%f",[_proUpgradeProduct.price floatValue]);
            this->unschedule(schedule_selector(FirstScene::getProductPrice));
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:_proUpgradeProduct.priceLocale];
     NSString*  _formattedString = [numberFormatter stringFromNumber:_proUpgradeProduct.price];
        //NSLog(@"price %@",proUpgradeProduct.price);
        [numberFormatter release];
        NSLog(@"FirstScneformattedString:%@",_formattedString);
        
        switch (curReqProductPriceId) {
            case 0:
            CCUserDefault::sharedUserDefault()->setStringForKey("price_0", [_formattedString UTF8String]);
                break;
            case 1:
            CCUserDefault::sharedUserDefault()->setStringForKey("price_1", [_formattedString UTF8String]);
                break;
            case 2:
            CCUserDefault::sharedUserDefault()->setStringForKey("price_2", [_formattedString UTF8String]);
                break;
            case 3:
            CCUserDefault::sharedUserDefault()->setStringForKey("price_3", [_formattedString UTF8String]);
                break;
            case 4:
            CCUserDefault::sharedUserDefault()->setStringForKey("price_4", [_formattedString UTF8String]);
                CCUserDefault::sharedUserDefault()->setBoolForKey("IsSaveIAPPrice", true);
                break;
            default:
                break;
        }

        CCUserDefault::sharedUserDefault()->flush();
        if (curReqProductPriceId == 4) {
            this->schedule(schedule_selector(FirstScene::shopCarAddPriceBg), 0.2f);
        }
        
//        CCPoint pt = CCPointMake(180, 330-curReqProductPriceId*50);
//       CCLabelTTF* priceTTF = CCLabelTTF::create([_formattedString UTF8String], "Verdana-Bold", 64);
//        priceTTF->setScale(0.2);
//        priceTTF->setPosition(pt);
//       priceTTF->setColor(ccc3(0, 0, 0));
//       ShopCarNode->addChild(priceTTF, 1);
        
                curReqProductPriceId = curReqProductPriceId+1;
                this->schedule(schedule_selector(FirstScene::getProductPriceDelay), 0.1f);
        
    }
    //method 3
//    if ([inAppPurchaseManager responPriceLocaleNSString] != NULL) {
//            NSLog(@"sdfasd:%@",[inAppPurchaseManager responPriceLocaleNSString]);
//            this->unschedule(schedule_selector(FirstScene::getProductPrice));
//        CCPoint pt = CCPointMake(180, 330-curReqProductPriceId*50);
//        CCLabelTTF* priceTTF = CCLabelTTF::create([[inAppPurchaseManager responPriceLocaleNSString]cStringUsingEncoding:NSASCIIStringEncoding], "Verdana-Bold", 64);
//        priceTTF->setScale(0.2);
//        priceTTF->setPosition(pt);
//        priceTTF->setColor(ccc3(0, 0, 0));
//        ShopCarNode->addChild(priceTTF, 1);
//
//    }
    //method 1

     //   char* price = [inAppPurchaseManager responPriceLocaleChar];
//    if ([InAppPurchaseManager responPriceLocaleNSString] != NULL) {
//            //NSLog(@"FirstpriceLocaleCharValue:%s",[inAppPurchaseManager responPriceLocaleChar]);
//            this->unschedule(schedule_selector(FirstScene::getProductPrice));
//       // char* price = [inAppPurchaseManager responPriceLocaleChar];
//                CCPoint pt = CCPointMake(180, 330-curReqProductPriceId*50);
//                CCLabelTTF* priceTTF = CCLabelTTF::create([[InAppPurchaseManager responPriceLocaleNSString]cStringUsingEncoding:NSASCIIStringEncoding], "Verdana-Bold", 64);
//                priceTTF->setScale(0.2);
//                priceTTF->setPosition(pt);
//                priceTTF->setColor(ccc3(0, 0, 0));
//                ShopCarNode->addChild(priceTTF, 1);
//
//        curReqProductPriceId = curReqProductPriceId+1;
//        this->schedule(schedule_selector(FirstScene::getProductPriceDelay), 1.1f);
//    }
    //method 2
//    iAPClass->ResProductPrice();
//    if (iAPClass->getpriceLocale() != NULL) {
//                     NSLog(@"FirstpriceLocaleCharValue:%s",iAPClass->getpriceLocale());
//                this->unschedule(schedule_selector(FirstScene::getProductPrice));
//        curReqProductPriceId = curReqProductPriceId+1;
//        CCLOG("asdf:%i",curReqProductPriceId);
//        this->schedule(schedule_selector(FirstScene::getProductPriceDelay), 0.1f);
//    }

 }
void FirstScene::getProductPriceDelay(){
    this->unschedule(schedule_selector(FirstScene::getProductPriceDelay));
            ReqProductPrice(curReqProductPriceId);
}

void FirstScene::showBuyStatWin(int ProductId){
    curPurchaseProductId = ProductId;
    showBuyStatWinNode = CCNode::create();
    //showBuyStatWinNode->setPosition(ccp(-320, 0));
    addChild(showBuyStatWinNode);
    
    CCSprite* showBuyStatBg = CCSprite::create("ShowWinBuyStatBg.png");
    showBuyStatBg->setPosition(ccp(winSize.width*0.5, winSize.height*0.5));
    showBuyStatBg->setScaleX(0.5);
    showBuyStatBg->setScaleY(0.6);
    showBuyStatWinNode->addChild(showBuyStatBg);
    
    CCPoint pt = CCPointMake(150, 300);
    for (int j = 0; j < ProductId+1; j++) {
        CCPoint newpt = CCPointMake(pt.x+5*j, pt.y);
        CCSprite* shopCarGoldBg = CCSprite::createWithTexture(_shopCarGoldBgNode->getTexture());
        shopCarGoldBg->setScale(0.4);
        shopCarGoldBg->setPosition(newpt);
        showBuyStatWinNode->addChild(shopCarGoldBg, 1);
    }
    
    CCMenuItemImage* clostBtn = CCMenuItemImage::create("showWinClose.png", "showWinClose_after.png",this,menu_selector(FirstScene::showBuyBtn));
    clostBtn->setPosition(ccp(280,390));
    clostBtn->setScale(0.5);
    clostBtn->setTag(1);
    
    ShowBuyokBtn = CCMenuItemImage::create("showWinBtn.png", "showWinBtn_after.png",this,menu_selector(FirstScene::showBuyBtn));
    ShowBuyokBtn->setPosition(ccp(160,120));
    ShowBuyokBtn->setScale(0.5);
    ShowBuyokBtn->setTag(2);
    ShowBuyokBtn->setVisible(false);
    
    //_shopCarBtnArray->addObject(clostBtn);
    CCMenu* showBuyStatMenu = CCMenu::create(clostBtn,ShowBuyokBtn,NULL);
    showBuyStatMenu->setPosition(CCPointZero);
    showBuyStatMenu->setTag(showBuyStatMenuTag);
    showBuyStatWinNode->addChild(showBuyStatMenu);
    
    buyStatTTF = CCLabelTTF::create(languageLayer->getChar("Purchasing..."), "", 30);
    buyStatTTF->setScale(0.2);
    buyStatTTF->setPosition(ccp(160, 200));
    buyStatTTF->setColor(ccc3(0, 0, 0));
    showBuyStatWinNode->addChild(buyStatTTF, 1);
    
    buyOkTTF = CCLabelTTF::create(languageLayer->getChar("OK"), "Verdana-Bold", 45);
    buyOkTTF->setScale(0.3);
    buyOkTTF->setPosition(ccp(160, 120));
    //buyOkTTF->setColor(ccc3(0, 0, 0));
    buyOkTTF->setVisible(false);
    showBuyStatWinNode->addChild(buyOkTTF, 1);
    CCLog("productId:%i",ProductId);
   // char * buyNumChar = "20000 coins";
    char* buyNumChar;
    switch (ProductId) {
        case 0:
            //buyNumChar = "20000 coins";
     buyNumChar =  (char*)languageLayer->getChar("20000 coins");
            break;
        case 1:
            //buyNumChar = "50000 coins";
     buyNumChar =  (char*)languageLayer->getChar("50000 coins");
            break;
        case 2:
           // buyNumChar = "1350000 coins";
    buyNumChar =  (char*)languageLayer->getChar("135000 coins");
            break;
        case 3:
           // buyNumChar = "3000000 coins";
     buyNumChar =  (char*)languageLayer->getChar("300000 coins");
            break;
        case 4:
           // buyNumChar = "7000000 coins";
      buyNumChar =  (char*)languageLayer->getChar("700000 coins");
            break;
        default:
            break;
    }
    
    CCLabelTTF* buyNumTTF = CCLabelTTF::create(buyNumChar, "Verdana-Bold", 45);
    buyNumTTF->setScale(0.3);
    buyNumTTF->setPosition(ccp(160, 260));
    buyNumTTF->setColor(ccc3(0, 0, 0));
    showBuyStatWinNode->addChild(buyNumTTF, 1);

}
void FirstScene::showBuyBtn(CCMenuItemImage* showBuyBtn){
    soundLayer->playEffect(2);
    //CCLog("showBuyBtnTag:%i",showBuyBtn->getTag());
    switch (showBuyBtn->getTag()) {
        case 1:
            isPurshasing = false;
            showBuyStatWinNode->runAction(CCSequence::create(CCMoveTo::create(0.1f, ccp(-320, 0)),NULL));
           // removeChild(showBuyStatWinNode);
            break;
        case 2:
            isPurshasing = false;
            showBuyStatWinNode->runAction(CCSequence::create(CCMoveTo::create(0.1f, ccp(-320, 0)),NULL));
            break;
        case 3:
            ReqpurchaseProduct(curPurchaseProductId);
            buyStatTTF->setString(languageLayer->getChar("Purchasing..."));
            ShowBuyokBtn->setVisible(false);
            buyOkTTF->setVisible(false);
           // ReqProductPrice(curPurchaseProductId);
            break;
        default:
            break;
    }
}
void FirstScene::changeBuyStat(){

    if (changeBuyDt>5) {
        this->unschedule(schedule_selector(FirstScene::changeBuyStat));
        isPurshasing = false;
    }
    changeBuyDt++;

}
#pragma mark -
#pragma mark LanguageMenu
void FirstScene::initLanguageMenu(){
//    CCSprite* showBg = CCSprite::create("ShowWinBg.png");
//    showBg->setPosition(ccp(160,240));
//    showBg->setScaleX(0.65);
//    showBg->setScaleY(0.7);
//    CCLog("_curLanguageType:%i",_curLanguageType);
//    
//    titleTTF = CCLabelTTF::create(languageLayer->getlabelChar("TitleLanguageTTF", _curLanguageType), "", 54);
//    titleTTF->setScale(0.4);
//    titleTTF->setColor(ccc3(255, 5, 15));
//    titleTTF->setTag(pLanguageTitleTTFTag);
//    titleTTF->setPosition(ccp(winSize.width*0.5, winSize.height-80));
//    
//    CCLabelTTF* footTTF = CCLabelTTF::create("Englsh", "", 54);
//    footTTF->setScale(0.2);
//    footTTF->setAnchorPoint(ccp(0, 0.5));
//    footTTF->setTag(footTTFTag);
//    footTTF->setColor(ccc3(255, 5, 15));
//    footTTF->setPosition(ccp(winSize.width*0.5, 80));
//    
//    CCLabelTTF* CurLanguageTTF = CCLabelTTF::create(languageLayer->getlabelChar("CurLanguageTTF", _curLanguageType), "", 54);
//    CurLanguageTTF->setScale(0.2);
//    CurLanguageTTF->setAnchorPoint(ccp(1, 0.5));
//    CurLanguageTTF->setTag(footTTFTag);
//    CurLanguageTTF->setPosition(ccp(winSize.width*0.5, 80));
    
//   CCMenuItemImage* clostBtn = CCMenuItemImage::create("showWinClose.png", "showWinClose_after.png",this,menu_selector(FirstScene::moveLanguageMenu));
//    clostBtn->setPosition(ccp(280,420));
    //clostBtn->setScale(0.5);
    //languageBtnArray->addObject(clostBtn);
  //  CCMenu* pMenuLanguage = CCMenu::create(NULL);
    
//    CCObject* obj = NULL;
//    int i = 0;
//    CCARRAY_FOREACH(_languageObjGroup->getObjects(), obj){
//        CCDictionary* dic = (CCDictionary*)obj;
//        CCString* languageName = (CCString*)languageLayer->getlanguageContens()->objectAtIndex(i);
//        CCLabelTTF* btnttf = CCLabelTTF::create(languageName->getCString(), "Airal", 70);
//        CCMenuItemLabel* btn = CCMenuItemLabel::create(btnttf, this, menu_selector(FirstScene::languageSelectCallBack));
//       btn->setPosition(ccp(dic->valueForKey("x")->floatValue()*0.5, dic->valueForKey("y")->floatValue()*0.5));
//        btn->setTag(i);
//        btn->setScale(0.3);
//        languageBtnArray->addObject(btn);
//        i++;
//    }
//    pMenuLanguage->initWithArray(languageBtnArray);
//    pMenuLanguage->setPosition(CCPointZero);
//    pMenuLanguage->setTag(pLanguageMenuTag);
    
//    CCNode* languageNode = CCNode::create();
//    addChild(languageNode,0,pLanguageMenuNodeTag);
//    languageNode->addChild(showBg);
//    languageNode->addChild(titleTTF);
//    languageNode->addChild(footTTF);
//    languageNode->addChild(CurLanguageTTF);
//    languageNode->setPosition(ccp(-320, 0));
//    languageNode->addChild(pMenuLanguage);
}
void FirstScene::moveLanguageMenu(){
//    CCMenu* pMenu = (CCMenu*)this->getChildByTag(pMenuTag);
//    CCNode* languageNode =(CCNode*)this->getChildByTag(pLanguageMenuNodeTag);
//    pMenu->runAction(CCSequence::create(CCMoveTo::create(0.2f, ccp(pMenu->getPositionX(), pMenu->getPositionY()+480)),NULL));
//    languageNode->runAction(CCSequence::create(CCMoveTo::create(0.2f, ccp(languageNode->getPositionX()-320, languageNode->getPositionY())),NULL));

}
void FirstScene::languageSelectCallBack(CCObject* pSender){
//        languageLayer = new Language();
//    CCMenuItemImage* btnttf = (CCMenuItemImage*)pSender;
//
//    _curLanguageType = btnttf->getTag();
//
//    titleTTF->setString(languageLayer->getlabelChar("TitleLanguageTTF", _curLanguageType));
//    CCString* languageName = (CCString*)languageLayer->getlanguageContens()->objectAtIndex(btnttf->getTag());
//
//    CCLabelTTF* footTTF = (CCLabelTTF*)this->getChildByTag(pLanguageMenuNodeTag)->getChildByTag(footTTFTag);
//    footTTF->setString(languageName->getCString());
//    
//    CCUserDefault::sharedUserDefault()->setIntegerForKey("LanguageType", btnttf->getTag());
//    CCUserDefault::sharedUserDefault()->flush();

}
void FirstScene::onEnter(){
   // CCLOG("onEnter");
   // ReqProductPrice(0);

    CCLayer::onEnter();
}
void FirstScene::onExit(){
   // CCLOG("onExit price:%s",CCUserDefault::sharedUserDefault()->getStringForKey("price_1").c_str());
   // CCUserDefault::sharedUserDefault()->setIntegerForKey("curGold",curGold);
//    CCUserDefault::sharedUserDefault()->setIntegerForKey("extraTime",extraTime);
//    CCUserDefault::sharedUserDefault()->setBoolForKey("EquipmentWugui",_EquipmentWugui);
//    CCUserDefault::sharedUserDefault()->setBoolForKey("EquipmentZhadan",_EquipmentZhadan);
//    CCUserDefault::sharedUserDefault()->setBoolForKey("EquipmentZhongbiao",_EquipmentZhongbiao);
//    CCUserDefault::sharedUserDefault()->flush();
    CCLayer::onExit();
}