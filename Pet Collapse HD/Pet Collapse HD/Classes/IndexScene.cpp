//
//  IndexScene.cpp
//  Pet Collapse
//
//  Created by long shenghua on 13-10-23.
//
//

#include "IndexScene.h"
IndexScene::IndexScene(){
    _heartBatch = CCSpriteBatchNode::create("xing.png");
    CC_SAFE_RETAIN(_heartBatch);
  //  _heartArray = CCArray::create();
   // CC_SAFE_RETAIN(_heartArray);
}
IndexScene::~IndexScene(){
    CC_SAFE_RELEASE_NULL(_heartBatch);
   // CC_SAFE_RELEASE_NULL(_heartArray);
}
CCScene* IndexScene::scene(){
    CCScene* scene = CCScene::create();
    scene->addChild(IndexScene::create());
    return scene;
}
bool IndexScene::init(){
    if (CCLayer::init()) {
       // initData();
        //initUI();
       // initLayer();
       // initMenu();
       // this->schedule(schedule_selector(IndexScene::updateHeartTime), 1.0f);
       // initGameOver();
        return true;
    }else{
        return false;
    }
}
void IndexScene::initGameOver(){
    if (isNewGame == false) {
        pMenu->setPosition(ccp(-320, 0));
        
        gameOverNode = CCNode::create();
        addChild(gameOverNode);
        
        CCSprite* gameoverBg = CCSprite::create("game_overBg.png");
        gameoverBg->setPosition(ccp(160, 240));
        gameoverBg->setScale(0.5);
        gameOverNode->addChild(gameoverBg);
        
        CCLabelTTF* gameoverTitleTTF = CCLabelTTF::create("Game Over", "Verdana-Bold", 45);
        gameoverTitleTTF->setPosition(ccp(160, 300));
        gameoverTitleTTF->setScale(0.5);
        gameoverTitleTTF->setColor(ccc3(217, 109, 27));
        gameOverNode->addChild(gameoverTitleTTF);
        
        CCSprite* GoldImg = CCSprite::create("sekuai.png", CCRectMake(64*5, 64, 64, 64));
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
        
        
        CCLabelTTF* BestscoreImgTTF = CCLabelTTF::create("Score:", "Verdana-Bold", 45);
        BestscoreImgTTF->setPosition(ccp(137, 230));
        BestscoreImgTTF->setScale(0.3);
        BestscoreImgTTF->setAnchorPoint(ccp(1, 0.5));
        BestscoreImgTTF->setColor(ccc3(217, 109, 27));
        gameOverNode->addChild(BestscoreImgTTF);
        
        char bestScoreChar[128];
        sprintf(bestScoreChar, "%i",curScore);
        curScoreTTF = CCLabelTTF::create(bestScoreChar, "Verdana-Bold", 45);
        curScoreTTF->setPosition(ccp(140, 230));
        curScoreTTF->setScale(0.3);
        curScoreTTF->setAnchorPoint(ccp(0, 0.5));
        curScoreTTF->setColor(ccc3(250, 35, 5));
        gameOverNode->addChild(curScoreTTF);
        //        CCSprite* sp1 = CCSprite::create("shopCarBuyBtn.png");
        //        sp1->setAnchorPoint(ccp(0.5,0.5));
        //        CCSprite* sp2 = CCSprite::create("shopCarBuyBtn.png");
        //        sp2->setScale(1.1);
        //        sp2->setAnchorPoint(ccp(0.5,0.5));
        //        CCMenuItemSprite* okBtn = CCMenuItemSprite::create(sp1, sp2, this, menu_selector(IndexScene::moveGameOverNode));
        //okBtn->setAnchorPoint(CCPointZero);
        CCMenuItemImage* okBtn = CCMenuItemImage::create("shopCarBuyBtn.png", "shopCarBuyBtn.png", this, menu_selector(IndexScene::moveGameOverNode));
        okBtn->setPosition(ccp(160,170));
        okBtn->setScale(0.5);
        CCMenu *overMenu = CCMenu::create(okBtn,NULL);
        overMenu->setPosition(CCPointZero);
        gameOverNode->addChild(overMenu);
        
        CCLabelTTF* okTTF = CCLabelTTF::create("OK", "Verdana-Bold", 45);
        okTTF->setPosition(ccp(160,170));
        okTTF->setScale(0.3);
        // okTTF->setAnchorPoint(ccp(0, 0.5));
        // okTTF->setColor(ccc3(250, 35, 5));
        gameOverNode->addChild(okTTF);
        this->schedule(schedule_selector(IndexScene::checkScoreAndGold), 1.0f);//
        //checkScoreAndGold();
    }
}
void IndexScene::moveGameOverNode(){
    CCLog("move");
    pMenu->setPosition(ccp(0, 0));
    removeChild(gameOverNode);
}
void IndexScene::update(){}
void IndexScene::updateHeartTime(){
    if (_heartNum < 8) {
        if (heartTime<10) {
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
void IndexScene::checkScoreAndGold(){
    this->unschedule(schedule_selector(IndexScene::checkScoreAndGold));
    if (curScore >0) {
        // CCLog("move and jiafen");
        char bestScoreChar[128];
        sprintf(bestScoreChar, "%i",curScore);
        CCLabelTTF* jiacurScoreTTF = CCLabelTTF::create(bestScoreChar, "Verdana-Bold", 45);
        jiacurScoreTTF->setPosition(ccp(140, 230));
        jiacurScoreTTF->setScale(0.3);
        jiacurScoreTTF->setAnchorPoint(ccp(0, 0.5));
        jiacurScoreTTF->setColor(ccc3(250, 35, 5));
        jiacurScoreTTF->setTag(1);
        addChild(jiacurScoreTTF);
        curScoreTTF->setString("0");
        jiacurScoreTTF->runAction(CCSequence::create(CCMoveTo::create(1.0f, ccp(140, 405)),CCCallFuncN::create(this, callfuncN_selector(IndexScene::jiafenFinsh)),NULL));
    }
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
        curGoldTTF->setString("0");
        jiacurGoldTTF->runAction(CCSequence::create(CCMoveTo::create(1.0f, ccp(140, 430)),CCCallFuncN::create(this, callfuncN_selector(IndexScene::jiafenFinsh)),NULL));
        
    }
    
}
void IndexScene::jiafenFinsh(cocos2d::CCLabelTTF *pSender){
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
void IndexScene::setScoreTTF(){}
void IndexScene::setGoldTTF(){}
void IndexScene::initData(){
    
    _heartNum = CCUserDefault::sharedUserDefault()->getIntegerForKey("HeartNum",5);
    heartTime = CCUserDefault::sharedUserDefault()->getIntegerForKey("heartTime", 0);
    bestScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("BestScore",0);
    TotalGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("TotalGold",0);
    curGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("curGold",0);
    curScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("curScore",0);
    isNewGame = CCUserDefault::sharedUserDefault()->getIntegerForKey("isNewGame",true);
    //isNewGame = false;
    //curScore = 100;
    //curGold = 20;
    _heartNum = 6;
}
void IndexScene::initLayer(){}
void IndexScene::initUI(){
    CCSprite* bg = CCSprite::create("FirstBg.png");
    bg->setAnchorPoint(CCPointZero);
    bg->setScale(0.5);
    addChild(bg);
    
    for (int i = 0; i < 8; i++) {
        CCSprite* heartImg = CCSprite::create("xing-huise.png");
        heartImg->setPosition(ccp(25+30*i,460));
        heartImg->setScale(0.5);
        addChild(heartImg);
    }
    
    addChild(_heartBatch);
    showHeart(_heartNum);
    showprogessBar();
    
    CCSprite* GoldImg = CCSprite::create("sekuai.png", CCRectMake(64*5, 64, 64, 64));
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
    
    
    CCLabelTTF* BestscoreImgTTF = CCLabelTTF::create("BestScore:", "Verdana-Bold", 45);
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
    
    CCMenuItemImage* pPlay = CCMenuItemImage::create("PLAY-IPHONE.png", "PLAY-IPHONE.png", this, menu_selector(IndexScene::pPlayCallBack));
    pPlay->setPosition(ccp(160,100));
    
    pMenu = CCMenu::create(pPlay,NULL);
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
void IndexScene::showprogessBar(){
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
    
    ct->setPercentage(50);
    this->addChild(ct);
    
    HeartTTF = CCLabelTTF::create("50%", "Verdana-Bold", 36);
    HeartTTF->setPosition(ccp(290, 460));
    HeartTTF->setScale(0.3);
    //HeartTTF->setColor(ccc3(250, 35, 5));
    addChild(HeartTTF);
}
void IndexScene::setHeartTimer(int dt){
    ct->setPercentage(dt);
    char heartChar[128];
    sprintf(heartChar, "%i%%%",dt);
    HeartTTF->setString(heartChar);
    
}
void IndexScene::showHeart(int Heart){
    _heartBatch->removeAllChildren();
    for (int i = 0; i < Heart; i++) {
        CCSprite* heartImg = CCSprite::createWithTexture(_heartBatch->getTexture());
        int posi = 30*(_heartNum-1)+25;
        heartImg->setPosition(ccp(posi-30*i,460));
        heartImg->setScale(0.5);
        heartImg->setTag(50);
        _heartBatch->addChild(heartImg);
    }
}
void IndexScene::pPlayCallBack(){
    if (_heartNum >0) {
        _heartNum--;
        char heartNumChar[128];
        sprintf(heartNumChar, "%i",_heartNum);
        HearNumTTF->setString(heartNumChar);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("HeartNum", _heartNum);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("heartTime", heartTime);
        CCUserDefault::sharedUserDefault()->flush();
        // _heartArray = (CCArray*)_heartBatch->getChildren();
        CCSprite* heart = (CCSprite*)_heartBatch->getChildByTag(50);
        heart->runAction(CCSequence::create(CCMoveTo::create(1.0f, ccp(160, 100)),CCCallFuncN::create(this, callfuncN_selector(IndexScene::PlayScene)),NULL));
    }else{
        CCLog("need buy");
    }
    
}
void IndexScene::PlayScene(){
    CCLog("play");
    CCDirector::sharedDirector()->replaceScene(GameScene::scene());
}
void IndexScene::pSoundControlCallBack(){}
void IndexScene::initMenu(){}