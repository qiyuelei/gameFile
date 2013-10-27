//
//  UiLayer.cpp
//  Pet Collapse
//
//  Created by long shenghua on 13-10-21.
//
//

#include "UiLayer.h"
UiLayer::UiLayer(){
    _mapPaopaoArray = CCArray::create();
    CC_SAFE_RETAIN(_mapPaopaoArray);
    _footPaopaoArray = CCArray::create();
    CC_SAFE_RETAIN(_footPaopaoArray);
    _mSpriteBatch = CCSpriteBatchNode::create("sekuai.png");
    CC_SAFE_RETAIN(_mSpriteBatch);
    _objFootArray = CCArray::create();
    CC_SAFE_RETAIN(_objFootArray);
}
UiLayer::~UiLayer(){
    CC_SAFE_RELEASE_NULL(_mapPaopaoArray);
    CC_SAFE_RELEASE_NULL(_footPaopaoArray);
    CC_SAFE_RELEASE_NULL(_mSpriteBatch);
    CC_SAFE_RELEASE_NULL(_objFootArray);
}
bool UiLayer::init(){
    if (CCLayer::init()) {
        initConfigDate();
        initMap();
        //initMenu();
        return true;
    }else{
        return false;
    }

}
void UiLayer::initConfigDate(){
    winSize = CCDirector::sharedDirector()->getWinSize();
    curTimePos = 0;
    footID = 0;
    languageLayer = new LanguageLayer();
}
void UiLayer::initMap(){
    CCTMXTiledMap* m_GameMap = CCTMXTiledMap::create("GameSceneMap.tmx");
    addChild(m_GameMap);
    particleSysLayer = ParticleSysLayer::create();
    addChild(particleSysLayer,3);
    addChild(_mSpriteBatch,0,_mSpriteBatchTag);
    _pgroupPaopao = m_GameMap->objectGroupNamed("PaopaoLayer");

    
    showprogessBar();
    
    gameTimeTTF = CCLabelTTF::create("00.00", "Verdana-Bold", 45);
    gameTimeTTF->setPosition(ccp(winSize.width*0.5, winSize.height-70));
    gameTimeTTF->setScale(0.8);
    addChild(gameTimeTTF);
    
  CCLabelTTF* scoreImgTTF = CCLabelTTF::create(languageLayer->getChar("Score"), "Verdana-Bold", 45);
    scoreImgTTF->setPosition(ccp(winSize.width*0.5+80, winSize.height-160));
    scoreImgTTF->setScale(0.8);
    scoreImgTTF->setColor(ccc3(250, 35, 5));
    addChild(scoreImgTTF);
    
    CCSprite* scoreBg = CCSprite::create("terget-IPAD.png");
    scoreBg->setPosition(ccp(winSize.width*0.5+255, winSize.height-160));
    //scoreBg->setScale(0.5);
    addChild(scoreBg);
    
    scoreTTF = CCLabelTTF::create("0", "Verdana-Bold", 45);
    scoreTTF->setScale(0.6);
    scoreTTF->setPosition(ccp(winSize.width*0.5+255, winSize.height-160));
    addChild(scoreTTF);
    
    CCSprite* goldImg = CCSprite::createWithTexture(_mSpriteBatch->getTexture(), CCRectMake(64*5+0.5, 64, 64, 64));
    goldImg->setPosition(ccp(50, winSize.height-160));
    goldImg->setScale(0.9);
    addChild(goldImg);
    
    CCSprite* goldBg = CCSprite::create("terget-IPAD.png");
    goldBg->setPosition(ccp(200, winSize.height-160));
   // goldBg->setScale(0.5);
    addChild(goldBg);
    
    goldTTF = CCLabelTTF::create("0", "Verdana-Bold", 45);
    goldTTF->setScale(0.6);
    goldTTF->setPosition(ccp(200, winSize.height-160));
    addChild(goldTTF);
    
    StartNum = CCLabelTTF::create("1", "Verdana-Bold", 200);
    //StartNum->setScale(0.5);
    StartNum->setPosition(ccp(winSize.width*0.5, winSize.height/2));
    StartNum->setTag(1);
    StartNum->setVisible(false);
    addChild(StartNum);
    
    int _gameTime = 60;
    showTime(_gameTime);
}
CCLabelTTF* UiLayer::getStartNum(){
    return StartNum;
}
CCLabelTTF* UiLayer::getScoreTTF(){
    return scoreTTF;
}
CCLabelTTF* UiLayer::getgoldTTF(){
    return goldTTF;
}
bool UiLayer::IsGold(){
    bool goldTag = false;
    int randId = arc4random()%500;
    if (randId < 10) {
        goldTag = true;
    }
    return goldTag;
}
bool UiLayer::IsZhaDan(){
    bool goldTag = false;
    int randId = arc4random()%500;
    if (randId < 10) {
        goldTag = true;
    }
    return goldTag;
}
void UiLayer::showTime(time_t _timep){
    //显示时间
    //unsigned long long timestamp = time(NULL);
    //  struct tm *ptm = localtime((time_t*)&timestamp);
    time_t timep = _timep;
    struct tm *ptm = gmtime(&timep);
    char tmp[100] = {0};
    memset(tmp, 0x0, 100);
    strftime(tmp, sizeof(tmp), "%M:%S", ptm);
    gameTimeTTF->setString(tmp);
}
CCLabelTTF* UiLayer::getgameTimeTTF(){
    return gameTimeTTF;
}
void UiLayer::setgameTimeTTFCor(){
    if (gameTimeTTF->getTag() == 1) {
        gameTimeTTF->setTag(2);
        gameTimeTTF->setColor(ccc3(255, 0, 0));
    }else{
        gameTimeTTF->setTag(1);
        gameTimeTTF->setColor(ccc3(255, 255, 255));
    }
}
void UiLayer::showprogessBar(){
   // CCSprite* heartSp = CCSprite::create("time-bg.png");
    //heartSp->setPosition(ccp(160, 350));
   // addChild(heartSp);
    
    CCSprite* progessBar = CCSprite::create("time-bg.png");
    progessBar->setPosition(ccp(winSize.width*0.5, winSize.height-70));
    //progessBar->setScale(2.1);
    this->addChild(progessBar);
    
    ct = CCProgressTimer::create(CCSprite::create("time.png"));
    ct->setPosition(ccp(winSize.width*0.5, winSize.height-70));
    // ct->setType(kCCProgressTimerTypeRadial);
    // ct->setScale(2.1);
    ct->setType(kCCProgressTimerTypeBar);
    ct->setMidpoint(ccp(0, 0));
    ct->setBarChangeRate(ccp(1.0f, 0));
    ct->setReverseProgress(true);
    
    ct->setPercentage(100);
     this->addChild(ct);
}
void UiLayer::setct_time(int ct_time){
    ct->setPercentage(ct_time);
}
void UiLayer::gameLogic(int _curTimePos){
    //_objFootArray = (CCArray*)_pgroupFoot->getObjects();
    //CCDictionary* dic = (CCDictionary*)_objFootArray->objectAtIndex(_curTimePos);
    
    addPaopao(CCPointMake(32+64*footID, 32+4),2);
    if (footID<11) {
        footID++;
    }else{
        footID = 0;
    }
   // CCLog("footID:%i",footID);
}

CCArray* UiLayer::getMapPaopaoArray(){
    return _mapPaopaoArray;
}
void UiLayer::initMenu(){}
void UiLayer::initPaopao(){
    CCObject* obj = NULL;
    
    CCARRAY_FOREACH(_pgroupPaopao->getObjects(), obj){
        CCDictionary* dic = (CCDictionary*)obj;
        addPaopao(CCPointMake(dic->valueForKey("x")->floatValue(), dic->valueForKey("y")->floatValue()+8),1);
    }

}
void UiLayer::addPaopao(CCPoint location,int PosType){
    int _paopaoType = arc4random()%3;
    if (IsGold() == true) {_paopaoType = 5;}
    if (IsZhaDan() == true) {_paopaoType = 6;}
    NormalPaoPao* _myPaopao = NormalPaoPao::createPaoPao(_paopaoType,PosType, 0, 0, _mSpriteBatch->getTexture());
    _myPaopao->setPosition(location);
   // _myPaopao->setScale(0.5);
    _mSpriteBatch->addChild(_myPaopao);
        _mapPaopaoArray->addObject(_myPaopao);
}
void UiLayer::movePaopao(){}
void UiLayer::showFenshu(int FenshuType,int _Fenshu,CCPoint location){
    CCPoint targetPoint;
    char fenChar[128];
    sprintf(fenChar, "+%d",_Fenshu);
   CCLabelTTF* fenTTF = CCLabelTTF::create(fenChar, "Verdana-Bold", 45);
    fenTTF->setScale(0.6);
    fenTTF->setPosition(location);
    addChild(fenTTF);
    if (FenshuType == 1) {
        targetPoint = CCPointMake(winSize.width*0.5+255, winSize.height-160);
    }else{
        targetPoint = CCPointMake(200, winSize.height-160);
        fenTTF->setColor(ccc3(245, 240, 5));
    }
    fenTTF->runAction(CCSequence::create(CCMoveTo::create(1.0f, targetPoint),CCCallFuncN::create(this, callfuncN_selector(UiLayer::showFenshuFinish)),NULL));

}
void UiLayer::showFenshuFinish(CCLabelTTF* pSender){
    removeChild(pSender);
}
void UiLayer::playParticalLineLight(int particalType,CCPoint location){
   // CCLog("x:%f,y:%f",location.x,location.y);
    //particleSysLayer->LineLightPlay(1, location);
   // particleSysLayer->LineLightPlay(2, location);
    particleSysLayer->ExplodingRingPlay(location);
}