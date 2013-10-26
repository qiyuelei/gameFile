//
//  FirstScene.cpp
//  Pet Collapse
//
//  Created by long shenghua on 13-10-23.
//
//

#include "FirstScene.h"
#import "GameKitHelper.h"
#include "InAppPurchaseManager.h"
InAppPurchaseManager* inAppPurchaseManager;
FirstScene::FirstScene(){
    _heartBatch = CCSpriteBatchNode::create("xing.png");
    CC_SAFE_RETAIN(_heartBatch);
    _heartArray = CCArray::create();
    CC_SAFE_RETAIN(_heartArray);
    _soundBg = CCSpriteBatchNode::create("sound.png");
    CC_SAFE_RETAIN(_soundBg);
}
FirstScene::~FirstScene(){
    CC_SAFE_RELEASE_NULL(_heartBatch);
    CC_SAFE_RELEASE_NULL(_heartArray);
    CC_SAFE_RELEASE_NULL(_soundBg);
}
CCScene* FirstScene::scene(){
    CCScene* scene = CCScene::create();
    scene->addChild(FirstScene::create());
    return scene;
}
bool FirstScene::init(){
    if (CCLayer::init()) {
        initData();
        initUI();
        initLayer();
       initMenu();
        this->schedule(schedule_selector(FirstScene::updateHeartTime), 1.0f);
        initGameOver();

        return true;
    }else{
        return false;
    }
}
void FirstScene::initGameOver(){
    if (isNewGame == false) {
        pMenu->setPosition(ccp(-320, 0));
  
    gameOverNode = CCNode::create();
    addChild(gameOverNode);
    
    CCSprite* gameoverBg = CCSprite::create("game_overBg.png");
    gameoverBg->setPosition(ccp(160, 240));
    gameoverBg->setScale(0.5);
    gameOverNode->addChild(gameoverBg);
    
    CCLabelTTF* gameoverTitleTTF = CCLabelTTF::create(languageLayer->getChar("Game Score"), "Verdana-Bold", 45);
    gameoverTitleTTF->setPosition(ccp(160, 300));
    gameoverTitleTTF->setScale(0.5);
    gameoverTitleTTF->setColor(ccc3(217, 109, 27));
    gameOverNode->addChild(gameoverTitleTTF);
    
    CCSprite* GoldImg = CCSprite::create("sekuai.png", CCRectMake(64*5+0.5, 64, 64, 64));
    GoldImg->setPosition(ccp(137,250));
    GoldImg->setAnchorPoint(ccp(1, 0.5));
    GoldImg->setScale(0.4);
    gameOverNode->addChild(GoldImg);
    
    char TotalGoldChar[128];
    sprintf(TotalGoldChar, "%i",curGold);
    curGoldTTF = CCLabelTTF::create(TotalGoldChar, "Verdana-Bold", 45);
    curGoldTTF->setPosition(ccp(140, 250));
    curGoldTTF->setScale(0.3);
    curGoldTTF->setAnchorPoint(ccp(0, 0.5));
    curGoldTTF->setColor(ccc3(250, 35, 5));
    gameOverNode->addChild(curGoldTTF);
    
    
    CCLabelTTF* BestscoreImgTTF = CCLabelTTF::create(languageLayer->getChar("Score:"), "Verdana-Bold", 45);
    BestscoreImgTTF->setPosition(ccp(137, 225));
    BestscoreImgTTF->setScale(0.3);
    BestscoreImgTTF->setAnchorPoint(ccp(1, 0.5));
    BestscoreImgTTF->setColor(ccc3(217, 109, 27));
    gameOverNode->addChild(BestscoreImgTTF);
    
    char bestScoreChar[128];
    sprintf(bestScoreChar, "%i",curScore);
    curScoreTTF = CCLabelTTF::create(bestScoreChar, "Verdana-Bold", 45);
    curScoreTTF->setPosition(ccp(140, 225));
    curScoreTTF->setScale(0.3);
    curScoreTTF->setAnchorPoint(ccp(0, 0.5));
    curScoreTTF->setColor(ccc3(250, 35, 5));
    gameOverNode->addChild(curScoreTTF);
//        CCSprite* sp1 = CCSprite::create("shopCarBuyBtn.png");
//        sp1->setAnchorPoint(ccp(0.5,0.5));
//        CCSprite* sp2 = CCSprite::create("shopCarBuyBtn.png");
//        sp2->setScale(1.1);
//        sp2->setAnchorPoint(ccp(0.5,0.5));
//        CCMenuItemSprite* okBtn = CCMenuItemSprite::create(sp1, sp2, this, menu_selector(FirstScene::moveGameOverNode));
        //okBtn->setAnchorPoint(CCPointZero);
        
        
        CCMenuItemImage* okBtn = CCMenuItemImage::create("shopCarBuyBtn.png", "shopCarBuyBtn.png", this, menu_selector(FirstScene::moveGameOverNode));
        okBtn->setPosition(ccp(160,170));
        okBtn->setScale(0.5);
        CCMenu *overMenu = CCMenu::create(okBtn,NULL);
        overMenu->setPosition(CCPointZero);
        gameOverNode->addChild(overMenu);
        
        CCLabelTTF* okTTF = CCLabelTTF::create(languageLayer->getChar("OK"), "Verdana-Bold", 45);
        okTTF->setPosition(ccp(160,170));
        okTTF->setScale(0.3);
       // okTTF->setAnchorPoint(ccp(0, 0.5));
       // okTTF->setColor(ccc3(250, 35, 5));
        gameOverNode->addChild(okTTF);
        this->schedule(schedule_selector(FirstScene::checkScoreAndGold), 1.0f);//
    //checkScoreAndGold();
          }
}
void FirstScene::moveGameOverNode(){
    //CCLog("move");
    pMenu->setPosition(ccp(0, 0));
    removeChild(gameOverNode);
    CCUserDefault::sharedUserDefault()->setIntegerForKey("isNewGame",true);
    CCUserDefault::sharedUserDefault()->flush();
}
void FirstScene::update(){}
void FirstScene::updateHeartTime(){
    if (_heartNum < 8) {
    if (heartTime<100) {
        heartTime++;
    }else{
        heartTime = 0;
        _heartNum++;
        showHeart(_heartNum);
        char heartNumChar[128];
        sprintf(heartNumChar, "%i",_heartNum);
        HearNumTTF->setString(heartNumChar);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("HeartNum", _heartNum);
        CCUserDefault::sharedUserDefault()->flush();
    }
    setHeartTimer(heartTime);
            }
}
void FirstScene::checkScoreAndGold(){
    this->unschedule(schedule_selector(FirstScene::checkScoreAndGold));
//    if (curScore >0) {
//        char bestScoreChar[128];
//        sprintf(bestScoreChar, "%i",curScore);
//     CCLabelTTF* jiacurScoreTTF = CCLabelTTF::create(bestScoreChar, "Verdana-Bold", 45);
//        jiacurScoreTTF->setPosition(ccp(140, 230));
//        jiacurScoreTTF->setScale(0.3);
//        jiacurScoreTTF->setAnchorPoint(ccp(0, 0.5));
//        jiacurScoreTTF->setColor(ccc3(250, 35, 5));
//        jiacurScoreTTF->setTag(1);
//        addChild(jiacurScoreTTF);
//        //curScoreTTF->setString("0");
//        jiacurScoreTTF->runAction(CCSequence::create(CCMoveTo::create(1.0f, ccp(140, 405)),CCCallFuncN::create(this, callfuncN_selector(FirstScene::jiafenFinsh)),NULL));
//    }
    if (curGold > 0) {
        //CCLog("move and jiafen");
        char TotalGoldChar[128];
        sprintf(TotalGoldChar, "%i",curGold);
     CCLabelTTF*    jiacurGoldTTF = CCLabelTTF::create(TotalGoldChar, "Verdana-Bold", 45);
        jiacurGoldTTF->setPosition(ccp(140, 250));
        jiacurGoldTTF->setScale(0.3);
        jiacurGoldTTF->setAnchorPoint(ccp(0, 0.5));
        jiacurGoldTTF->setColor(ccc3(250, 35, 5));
        jiacurGoldTTF->setTag(2);
        addChild(jiacurGoldTTF);
        //curGoldTTF->setString("0");
        jiacurGoldTTF->runAction(CCSequence::create(CCMoveTo::create(1.0f, ccp(140, 430)),CCCallFuncN::create(this, callfuncN_selector(FirstScene::jiafenFinsh)),NULL));
        
    }

}
void FirstScene::jiafenFinsh(cocos2d::CCLabelTTF *pSender){
    removeChild(pSender);
    if (pSender->getTag() == 1) {
        char TotalScoreChar[128];
        bestScore = bestScore+curScore;
        sprintf(TotalScoreChar, "%i",bestScore);
        ScoreTTF->setString(TotalScoreChar);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("BestScore", bestScore);
        CCUserDefault::sharedUserDefault()->flush();
    }else{
        char TotalGoldChar[128];
        TotalGold = TotalGold+curGold;
        sprintf(TotalGoldChar, "%i",TotalGold);
        GoldTTF->setString(TotalGoldChar);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("TotalGold", TotalGold);
        CCUserDefault::sharedUserDefault()->flush();
    }

}
void FirstScene::setScoreTTF(){}
void FirstScene::setGoldTTF(){}
void FirstScene::initData(){
    //GameCenter登陆
    [[GameKitHelper sharedGameKitHelper] authenticateLocalUser];
    inAppPurchaseManager = [[InAppPurchaseManager alloc]init];
    _heartNum = CCUserDefault::sharedUserDefault()->getIntegerForKey("HeartNum",8);
    heartTime = CCUserDefault::sharedUserDefault()->getIntegerForKey("heartTime", 0);
    bestScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("BestScore",0);
    TotalGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("TotalGold",0);
    curGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("curGold",0);
    curScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("curScore",0);
    isNewGame = CCUserDefault::sharedUserDefault()->getIntegerForKey("isNewGame",true);
    winSize = CCDirector::sharedDirector()->getWinSize();
    isPurchasing = false;
    
    if (CCUserDefault::sharedUserDefault()->getBoolForKey("IsFirstTime",true) == true) {
    CCUserDefault::sharedUserDefault()->setBoolForKey("IsFirstTime",false);
    CCUserDefault::sharedUserDefault()->setIntegerForKey("backGroundMusic", 1);
    CCUserDefault::sharedUserDefault()->setIntegerForKey("soundMusic", 1);
    CCUserDefault::sharedUserDefault()->flush();
    }
    
    languageLayer = new LanguageLayer();
    //isNewGame = false;
    //curScore = 100;
    //curGold = 20;
   // _heartNum = 0;
   // bestScore = 33402;
    reportScoreToGameCenter(bestScore);
}
void FirstScene::initLayer(){
    soundLayer = new SoundLayer();
    soundLayer->playBgSound(1);
                  // SimpleAudioEngine::sharedEngine()->playBackgroundMusic("bg.caf", true);
}
void FirstScene::initUI(){
    CCSprite* bg = CCSprite::create("FirstBg.png");
    bg->setAnchorPoint(CCPointZero);
    bg->setScale(0.5);
    addChild(bg);
    
    for (int i = 0; i < 8; i++) {
        CCSprite* heartImg = CCSprite::create("xing-huise.png");
        heartImg->setPosition(ccp(20+30*i,460));
        heartImg->setScale(0.5);
        addChild(heartImg);
    }

    addChild(_heartBatch);
    showHeart(_heartNum);
    showprogessBar();
    
    CCSprite* GoldImg = CCSprite::create("sekuai.png", CCRectMake(64*5+0.5, 64, 64, 64));
    GoldImg->setPosition(ccp(137,430));
    GoldImg->setAnchorPoint(ccp(1, 0.5));
    GoldImg->setScale(0.4);
    addChild(GoldImg);
    
    char TotalGoldChar[128];
    sprintf(TotalGoldChar, "%i",TotalGold);
    GoldTTF = CCLabelTTF::create(TotalGoldChar, "Verdana-Bold", 45);
    GoldTTF->setPosition(ccp(140, 430));
    GoldTTF->setScale(0.3);
    GoldTTF->setAnchorPoint(ccp(0, 0.5));
    GoldTTF->setColor(ccc3(250, 35, 5));
    addChild(GoldTTF);
    

    CCLabelTTF* BestscoreImgTTF = CCLabelTTF::create(languageLayer->getChar("Best Score:"), "Verdana-Bold", 45);
    BestscoreImgTTF->setPosition(ccp(137, 405));
    BestscoreImgTTF->setScale(0.3);
    BestscoreImgTTF->setAnchorPoint(ccp(1, 0.5));
    BestscoreImgTTF->setColor(ccc3(217, 109, 27));
    addChild(BestscoreImgTTF);
    
    char bestScoreChar[128];
    sprintf(bestScoreChar, "%i",bestScore);
    ScoreTTF = CCLabelTTF::create(bestScoreChar, "Verdana-Bold", 45);
    ScoreTTF->setPosition(ccp(140, 405));
    ScoreTTF->setScale(0.3);
    ScoreTTF->setAnchorPoint(ccp(0, 0.5));
    ScoreTTF->setColor(ccc3(250, 35, 5));
    addChild(ScoreTTF);
    
    CCMenuItemImage* facebookBtn = CCMenuItemImage::create("facebook.png", "facebook_after.png",this,menu_selector(FirstScene::facebookBtnCallBack));
    facebookBtn->setScale(0.27);
    facebookBtn->setPosition(ccp(winSize.width*0.5-60, 40));
    
    addChild(_soundBg);
    CCMenuItemSprite *soundBgOn = CCMenuItemSprite::create( CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(0, 110, 110, 110)), CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(0, 0, 110, 110)));
    CCMenuItemSprite *soundBgOff = CCMenuItemSprite::create( CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(0, 0, 110, 110)), CCSprite::createWithTexture(_soundBg->getTexture(), CCRectMake(0, 110, 110, 110)));
    if (CCUserDefault::sharedUserDefault()->getIntegerForKey("backGroundMusic",0)==1) {
        //CCLog("bgok");
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
       // CCLog("efok");
        pEfAudio = CCMenuItemToggle::createWithTarget(this, menu_selector(FirstScene::menuBackGroundMusicback), soundEfOff,soundEfOn,NULL);
    }else{
        pEfAudio = CCMenuItemToggle::createWithTarget(this, menu_selector(FirstScene::menuBackGroundMusicback), soundEfOn,soundEfOff,NULL);
    }
    pEfAudio->setPosition(ccp(winSize.width*0.5+60,40));
    pEfAudio->setScale(0.27);
    pEfAudio->setTag(2);
    
    CCMenuItemImage* pTest = CCMenuItemImage::create("PLAY-IPHONE.png", "PLAY-IPHONE.png", this, menu_selector(FirstScene::pTestCallBack));
    pTest->setPosition(ccp(160,40));
    
    CCMenuItemImage* pGameTop = CCMenuItemImage::create("gameCenter.png", "gameCenter.png", this, menu_selector(FirstScene::pGameTopCallBack));
    pGameTop->setPosition(ccp(280,40));
    pGameTop->setScale(0.8);
    
    CCMenuItemImage* pPlay = CCMenuItemImage::create("playBtn.png", "playBtn_after.png",this,menu_selector(FirstScene::pPlayCallBack));
    //CCMenuItemImage* pPlay = CCMenuItemImage::create("PLAY-IPHONE.png", "PLAY-IPHONE.png", this, menu_selector(FirstScene::pPlayCallBack));
    pPlay->setPosition(ccp(160,100));
    pPlay->setScale(0.5);
    
    pMenu = CCMenu::create(pPlay,pGameTop,facebookBtn,pEfAudio,pBgAudio,NULL);
    //pMenu->setAnchorPoint(CCPointZero);
    pMenu->setPosition(CCPointZero);
    addChild(pMenu);
    
    char heartNumChar[128];
    sprintf(heartNumChar, "%i",_heartNum);
    HearNumTTF = CCLabelTTF::create(heartNumChar, "Verdana-Bold", 36);
    HearNumTTF->setPosition(ccp(263, 460));
    HearNumTTF->setScale(0.3);
    HearNumTTF->setAnchorPoint(ccp(1, 0.5));
    HearNumTTF->setColor(ccc3(250, 35, 5));
    addChild(HearNumTTF);
    
}
void FirstScene::facebookBtnCallBack(){
    //int bestScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("BestScore");
    ChannelClass* channel = new ChannelClass();
    channel->ShareFaceBook(CCUserDefault::sharedUserDefault()->getIntegerForKey("BestScore"));
}
void FirstScene::menuBackGroundMusicback(CCMenuItemSprite* pSender){
    if (pSender->getTag() == 2) {
        if (CCUserDefault::sharedUserDefault()->getIntegerForKey("backGroundMusic",0) == 1) {
            SimpleAudioEngine::sharedEngine()->stopBackgroundMusic();
            CCUserDefault::sharedUserDefault()->setIntegerForKey("backGroundMusic", 0);
        }else{
            CCUserDefault::sharedUserDefault()->setIntegerForKey("backGroundMusic", 1);
            soundLayer->playBgSound(1);
        }
    }else{
      //  CCLog("audio");
        if (CCUserDefault::sharedUserDefault()->getIntegerForKey("soundMusic",0) == 1) {
            CCUserDefault::sharedUserDefault()->setIntegerForKey("soundMusic", 0);
        }else{
            CCUserDefault::sharedUserDefault()->setIntegerForKey("soundMusic", 1);
        }
    }
    
    CCUserDefault::sharedUserDefault()->flush();
}
void FirstScene::pTestCallBack(){
    CCLog("pTestCallBack");
      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/pet-collapse/id731781280?ls=1&mt=8"]];
    
    //[[GameKitHelper sharedGameKitHelper] retrieveTopTenScores];
    //[[GameKitHelper sharedGameKitHelper] reportScore:32422 forCategory:@"PCT"];
}
void FirstScene::pGameTopCallBack(){
    soundLayer->playEffect(3);
   // CCLog("pGameTopCallBack");
    //显示排行榜
    [[GameKitHelper sharedGameKitHelper] showLeaderboard];
}
void FirstScene::reportScoreToGameCenter(int _BestScore){
    [[GameKitHelper sharedGameKitHelper] reportScore:_BestScore forCategory:@"PCT"];
}
void FirstScene::showprogessBar(){
    // CCSprite* heartSp = CCSprite::create("time-bg.png");
    //heartSp->setPosition(ccp(160, 350));
    // addChild(heartSp);
    
    CCSprite* progessBar = CCSprite::create("heartTimeBg.png");
    progessBar->setPosition(ccp(290, 460));
    progessBar->setScale(0.4);
    this->addChild(progessBar);
    
    ct = CCProgressTimer::create(CCSprite::create("heartTimeBar.png"));
    ct->setPosition(ccp(290, 460));
    // ct->setType(kCCProgressTimerTypeRadial);
     ct->setScale(0.4);
    ct->setType(kCCProgressTimerTypeBar);
    ct->setMidpoint(ccp(0, 0));
    ct->setBarChangeRate(ccp(1.0f, 0));
    ct->setReverseProgress(true);
    
    ct->setPercentage(heartTime);
    this->addChild(ct);
    
    char heartChar[128];
    sprintf(heartChar, "%i%%%",heartTime);
   // HeartTTF->setString(heartChar);
    HeartTTF = CCLabelTTF::create(heartChar, "Verdana-Bold", 36);
    HeartTTF->setPosition(ccp(290, 460));
    HeartTTF->setScale(0.3);
    //HeartTTF->setColor(ccc3(250, 35, 5));
    addChild(HeartTTF);
}
void FirstScene::setHeartTimer(int dt){
    ct->setPercentage(dt);
    char heartChar[128];
    sprintf(heartChar, "%i%%%",dt);
    HeartTTF->setString(heartChar);
    
}
void FirstScene::showHeart(int Heart){
    _heartBatch->removeAllChildren();
    int heartNumId;
    if (Heart >8) { heartNumId = 8;}else{heartNumId = Heart;}
    for (int i = 0; i < heartNumId; i++) {
        CCSprite* heartImg = CCSprite::createWithTexture(_heartBatch->getTexture());
        int posi = 30*(heartNumId-1)+20;
        heartImg->setPosition(ccp(posi-30*i,460));
        heartImg->setScale(0.5);
        heartImg->setTag(50);
        _heartBatch->addChild(heartImg);
    }
}
void FirstScene::pPlayCallBack(){
    soundLayer->playEffect(3);
    if (_heartNum >0) {
        _heartNum--;
        char heartNumChar[128];
        sprintf(heartNumChar, "%i",_heartNum);
        HearNumTTF->setString(heartNumChar);
        //CCLog("heartTime:%i",heartTime);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("HeartNum", _heartNum);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("heartTime", heartTime);
        CCUserDefault::sharedUserDefault()->flush();
       // _heartArray = (CCArray*)_heartBatch->getChildren();
        CCSprite* heart = (CCSprite*)_heartBatch->getChildByTag(50);
        heart->runAction(CCSequence::create(CCMoveTo::create(1.0f, ccp(160, 100)),CCCallFuncN::create(this, callfuncN_selector(FirstScene::PlayScene)),NULL));
    }else{
        //CCLog("need buy");
        ReqPurchase(1);
    }
    
}
void FirstScene::PlayScene(){
       // CCLog("play");
     CCDirector::sharedDirector()->replaceScene(GameScene::scene());
}
void FirstScene::pSoundControlCallBack(){}
void FirstScene::initMenu(){}

void FirstScene::ReqPurchase(int ProductId){
    if (isPurchasing == false) {
        isPurchasing = true;
    [inAppPurchaseManager purchaseProduct:ProductId];
    this->schedule(schedule_selector(FirstScene::ResPurchase));
        }
}
void FirstScene::ResPurchase(){
    int purchaseStat = [inAppPurchaseManager responPurchaseStat];
    if (purchaseStat>=0) {
        CCLog("success");
        this->unschedule(schedule_selector(FirstScene::ResPurchase));
        isPurchasing = false;
        _heartNum = _heartNum + 100;
        showHeart(_heartNum);
        char heartNumChar[128];
        sprintf(heartNumChar, "%i",_heartNum);
        HearNumTTF->setString(heartNumChar);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("HeartNum", _heartNum);
        CCUserDefault::sharedUserDefault()->flush();
        
        [inAppPurchaseManager showPurchaseSecess];
    }else if (purchaseStat == -1){
        this->unschedule(schedule_selector(FirstScene::ResPurchase));
        isPurchasing = false;
      //  CCLog("purchase Fail");
    }
}