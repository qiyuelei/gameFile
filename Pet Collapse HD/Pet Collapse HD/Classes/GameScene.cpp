//
//  GameScene.cpp
//  Pet Collapse
//
//  Created by long shenghua on 13-10-21.
//
//

#include "GameScene.h"
GameScene::GameScene(){
    _SelPaopaoArray = CCArray::create();
    CC_SAFE_RETAIN(_SelPaopaoArray);
}
GameScene::~GameScene(){
    CC_SAFE_RELEASE_NULL(_SelPaopaoArray);
}
CCScene* GameScene::scene(){
    CCScene* scene = CCScene::create();
    scene->addChild(GameScene::create());
    return scene;
}
bool GameScene::init(){
    if (CCLayer::init()) {

        initData();
        initLayer();
        initMenu();
        initLogic();
        //this->schedule(schedule_selector(GameScene::update),0.3f);
        return true;
    }else{
        return false;
    }
}
#pragma mark -
#pragma mark initData
void GameScene::initData(){
    gameTime = 60;
    gameTimeSpan = 100/gameTime;
    curTimePos = 0;
    ct_Time = 100;
    statNum = 0;
    curGameStat = true;
    curBaojinStat = 0;
    curGold = 0;
    curScore = 0;
    curUpdateSpeed = 0.8f;
    BestScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("BestScore",0);
    TotalGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("TotalGold",0);
    winSize = CCDirector::sharedDirector()->getWinSize();
}
#pragma mark -
#pragma mark initLayer
void GameScene::initLayer(){
    uiLayer = UiLayer::create();
    addChild(uiLayer);
    soundLayer = new SoundLayer();
}
#pragma mark -
#pragma mark initMenu
void GameScene::initMenu(){
    menuNode = CCNode::create();
    addChild(menuNode);
    
//    CCSprite* MenuBg = CCSprite::create("shopCarBg.png");
//    MenuBg->setPosition(ccp(winSize.width*0.5, winSize.height*0.5));
//    MenuBg->setScale(0.5);
//    menuNode->addChild(MenuBg);
    
    CCMenuItemImage* BackEquipmentBtn = CCMenuItemImage::create("playBtn.png", "playBtn_after.png",this,menu_selector(GameScene::puaseBtnCallBack));
    //BackEquipmentBtn->setScale(0.5);
    BackEquipmentBtn->setPosition(ccp(winSize.width*0.5,winSize.height*0.5+40));
    BackEquipmentBtn->setTag(1);
    // menuNode->addChild(BackEquipmentBtn);
    
    CCMenuItemImage* ResumeBtn = CCMenuItemImage::create("backHome.png", "backHome.png",this,menu_selector(GameScene::puaseBtnCallBack));
    ResumeBtn->setScale(0.4);
    ResumeBtn->setRotation(180);
    ResumeBtn->setPosition(ccp(winSize.width*0.5,winSize.height*0.5-80));
    ResumeBtn->setTag(2);
    //menuNode->addChild(ResumeBtn);
    
    CCMenu* pNodeMenu = CCMenu::create(BackEquipmentBtn,ResumeBtn,NULL);
    //pMenu->setAnchorPoint(ccp(0,0));
    pNodeMenu->setPosition(CCPointZero);
    menuNode->addChild(pNodeMenu);
    
    menuNode->setVisible(false);

    CCLabelTTF* btnttf = CCLabelTTF::create("TAP SPEED", "Airal", 64);
    CCMenuItemLabel* pspeedBtn = CCMenuItemLabel::create(btnttf, this, menu_selector(GameScene::setUpdateTime));
   // CCMenuItemImage* pspeedBtn = CCMenuItemImage::create("pauseBtn.png", "pauseBtn.png",this,menu_selector(GameScene::setUpdateTime));
    pspeedBtn->setPosition(ccp(winSize.width*0.5, 32));
    pspeedBtn->setScale(0.8);
    pspeedBtn->setTag(1);
    pspeedBtn->setOpacity(50);

    CCMenuItemImage* pauseBtn = CCMenuItemImage::create("pauseBtn.png", "pauseBtn.png",this,menu_selector(GameScene::puaseBtnCallBack));
    pauseBtn->setPosition(ccp(winSize.width-50, winSize.height-50));
    //pauseBtn->setScale(0.5);
    pauseBtn->setTag(3);
    
    CCMenu *pMenu = CCMenu::create(pauseBtn,pspeedBtn,NULL);
    pMenu->setPosition(CCPointZero);
    addChild(pMenu);

}
void GameScene::puaseBtnCallBack(CCMenuItemImage* pSender){
    //CCLog("pause:%i",pSender->getTag());
    switch (pSender->getTag()) {
        case 1:
            CCDirector::sharedDirector()->resume();
            this->setTouchEnabled(true);
            menuNode->setVisible(false);
            break;
        case 2:
            CCDirector::sharedDirector()->resume();
            this->setTouchEnabled(true);
             CCDirector::sharedDirector()->purgeCachedData();
            openScene();
            break;
            
        default:
            CCDirector::sharedDirector()->pause();
            this->setTouchEnabled(false);
            menuNode->setVisible(true);
            break;
    }
    //CCDirector::sharedDirector()->replaceScene(Test::scene());
   // this->unschedule(schedule_selector(GameScene::update));
       // this->schedule(schedule_selector(GameScene::openScene), 1.0f);
   // CCDirector::sharedDirector()->purgeCachedData();
   // CCScene* sc = FirstScene::scene();
    //CCDirector::sharedDirector()->replaceScene(sc);
}
#pragma mark -
#pragma mark initLogic
void GameScene::initLogic(){
    showStarNum();
    //this->schedule(schedule_selector(GameScene::showStarNum), 1.0f);
}
void GameScene::gameTimeDaoJiShi(){
    gameTime--;
    uiLayer->showTime(gameTime);
    ct_Time = ct_Time-gameTimeSpan;
    uiLayer->setct_time(ct_Time);
    if (gameTime == 0) {
        this->unschedule(schedule_selector(GameScene::update));
        this->unschedule(schedule_selector(GameScene::gameTimeDaoJiShi));
        this->setTouchEnabled(false);
        showGameOver();
    }else if (gameTime < 10 && gameTime > 0){
        this->schedule(schedule_selector(GameScene::setgameTimeBaojin), 0.3);
    }
}
void GameScene::setgameTimeBaojin(){
    soundLayer->playEffect(1);
    uiLayer->setgameTimeTTFCor();
}
void GameScene::showStarNum(){
   // CCLog("show");
            CCLabelTTF* startNumTTF = uiLayer->getStartNum();
    if (statNum < 3) {
        statNum++;
        soundLayer->playEffect(1);
        if (startNumTTF->getTag() == 1) {
           // CCLog("statNum:%i",statNum);
            char startNumChar[128];
            sprintf(startNumChar, "%d",(4-statNum));
            startNumTTF->setString(startNumChar);
            startNumTTF->setScale(0.1);
            startNumTTF->setVisible(true);
            startNumTTF->runAction(CCSequence::create(CCScaleTo::create(0.5, 0.5),CCDelayTime::create(0.5),CCCallFuncN::create(this, callfuncN_selector(GameScene::showStarNum)),NULL));
        }
        uiLayer->getStartNum()->getTag();
        //CCLog("startNum:%i,show:%i",statNum,(4-statNum));
    }else{
        startNumTTF->setVisible(false);
        this->unschedule(schedule_selector(GameScene::showStarNum));
        uiLayer->initPaopao();
        //curTimePos = 0;
        this->schedule(schedule_selector(GameScene::update), curUpdateSpeed);
        this->setTouchEnabled(true);
        this->schedule(schedule_selector(GameScene::gameTimeDaoJiShi), 1.0f);
    }
}
void GameScene::hidestartNum(cocos2d::CCLabelTTF *pSender){
    CCLog("hide");
    //CCLabelTTF* startNumTTF = (CCLabelTTF*)pSender;
   // startNumTTF->setTag(2);
   // startNumTTF->setVisible(false);
    showStarNum();
}
void GameScene::setUpdateTime(){
    curUpdateSpeed = curUpdateSpeed - 0.1;
    if (curUpdateSpeed < 0.15) {curUpdateSpeed = 0.15;}
    this->schedule(schedule_selector(GameScene::update), curUpdateSpeed);
}
void GameScene::update(){
    if (curTimePos< 12) {
     uiLayer-> gameLogic(curTimePos);
        curTimePos++;
    }else{
     movePaopaoToUp();
    }
}
#pragma mark -
#pragma mark ccTouchesEnded
void GameScene::ccTouchesEnded(CCSet *touches,CCEvent *event){
    curClickStat = -1;
    _SelPaopaoArray->removeAllObjects();
    CCTouch *touch = (CCTouch*)touches->anyObject();
    CCPoint location = touch->getLocationInView();
    location = this->convertTouchToNodeSpace(touch);
    int num = uiLayer->getMapPaopaoArray()->count();
   for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
        if (_myPaopao->boundingBox().containsPoint(location) && _myPaopao->PosType == 1 && _myPaopao->checkStat == 0) {
            if (_myPaopao->PaoPaoType == 5) {
                char TotalGoldChar[128];
                curGold = curGold+1;
                sprintf(TotalGoldChar, "%d",curGold);
                uiLayer->getgoldTTF()->setString(TotalGoldChar);
                _SelPaopaoArray->addObject(_myPaopao);
            }else if (_myPaopao->PaoPaoType == 6){
                curClickStat = 6;
                _SelPaopaoArray->addObject(_myPaopao);
                processZhadan(_myPaopao->getPosition());
               // ParticleSysLayer* particleSysLayer = ParticleSysLayer::create();
               // addChild(particleSysLayer);
                uiLayer->playParticalLineLight(1, _myPaopao->getPosition());
            }else{
               // CCLog("x:%f,y:%f",_myPaopao->getPositionX(),_myPaopao->getPositionY());
                _myPaopao->checkStat = 1;
                _SelPaopaoArray->addObject(_myPaopao);
                FindPaopaoToSel(location, _myPaopao->PaoPaoType);
            }
        }
    }
    ClearSelPaopao();


}
void GameScene::processZhadan(cocos2d::CCPoint location){
    CCPoint targetPoint;
    for (int j=0; j<4; j++) {
        switch (j) {
            case 0:
                    targetPoint = CCPointMake(location.x+64, location.y);
                break;
            case 1:
                targetPoint = CCPointMake(location.x-64, location.y);
                break;
            case 2:
                targetPoint = CCPointMake(location.x, location.y+64);
                break;
            default:
                 targetPoint = CCPointMake(location.x, location.y-64);
                break;
        }
    int num = uiLayer->getMapPaopaoArray()->count();
    for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
        if (_myPaopao->boundingBox().containsPoint(targetPoint) && _myPaopao->PosType == 1 && _myPaopao->checkStat == 0) {
            _myPaopao->checkStat = 1;
            _SelPaopaoArray->addObject(_myPaopao);
            //FindPaopaoToSel(location, _myPaopao->PaoPaoType);
        }
    }
      }
}
void GameScene::FindPaopaoToSel(CCPoint location,int _PaopaoType){
    for (int i = 0; i<4; i++) {
        switch (i) {
            case 0:
             FindPaopaoToSel_R(CCPointMake(location.x+64, location.y), _PaopaoType);
                break;
            case 1:
                FindPaopaoToSel_R(CCPointMake(location.x, location.y-64), _PaopaoType);
                break;
            case 2:
                FindPaopaoToSel_R(CCPointMake(location.x-64, location.y), _PaopaoType);
                break;
            case 3:
                FindPaopaoToSel_R(CCPointMake(location.x, location.y+64), _PaopaoType);
                break;
            default:
                break;
        }
    }
}
void GameScene::FindPaopaoToSel_R(CCPoint location,int _PaopaoType){
    int num = uiLayer->getMapPaopaoArray()->count();
    for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
        if (_myPaopao->boundingBox().containsPoint(location) && _myPaopao->PosType == 1 && _myPaopao->PaoPaoType == _PaopaoType && _myPaopao->checkStat == 0) {
            _myPaopao->checkStat = 1;
            _SelPaopaoArray->addObject(_myPaopao);
            FindPaopaoToSel(location, _myPaopao->PaoPaoType);
        }
    }

}
void GameScene::ClearSelPaopao(){
   // CCLog("count:%i",_SelPaopaoArray->count());
    if (curClickStat == 6) {
            soundLayer->playEffect(7);
        for (int i = 0; i<_SelPaopaoArray->count(); i++) {
            NormalPaoPao* _myPaopao = (NormalPaoPao*)_SelPaopaoArray->objectAtIndex(i);
            uiLayer->getMapPaopaoArray()->removeObject(_myPaopao);
            uiLayer->getChildByTag(_mSpriteBatchTag)->removeChild(_myPaopao);
        }
        AddMarkToPaopaoX();
    }else{
    if (_SelPaopaoArray->count()>2) {
        soundLayer->playEffect(6);
        curScore = _SelPaopaoArray->count()*_SelPaopaoArray->count()*5 + curScore;
        char curScoreChar[128];
        sprintf(curScoreChar, "%d",curScore);
        uiLayer->getScoreTTF()->setString(curScoreChar);
        for (int i = 0; i<_SelPaopaoArray->count(); i++) {
            NormalPaoPao* _myPaopao = (NormalPaoPao*)_SelPaopaoArray->objectAtIndex(i);
            uiLayer->showFenshu(1, (_SelPaopaoArray->count()*5), _myPaopao->getPosition());
            uiLayer->getMapPaopaoArray()->removeObject(_myPaopao);
            uiLayer->getChildByTag(_mSpriteBatchTag)->removeChild(_myPaopao);
        }
        AddMarkToPaopaoX();
        if (curScore > BestScore) {
            CCUserDefault::sharedUserDefault()->setIntegerForKey("BestScore", curScore);
            CCUserDefault::sharedUserDefault()->flush();
        }
    }else if (_SelPaopaoArray->count() == 1){
        NormalPaoPao* _myPaopao = (NormalPaoPao*)_SelPaopaoArray->objectAtIndex(0);
        if (_myPaopao->PaoPaoType == 5) {
            soundLayer->playEffect(3);
            uiLayer->showFenshu(2, 1, _myPaopao->getPosition());
            uiLayer->getMapPaopaoArray()->removeObject(_myPaopao);
            uiLayer->getChildByTag(_mSpriteBatchTag)->removeChild(_myPaopao);
            AddMarkToPaopaoX();
        }else{
            initPaopaoAll();
        }
    }else{
        initPaopaoAll();
    }
    }
    curClickStat = -1;

}
void GameScene::AddMarkToPaopaoX(){
    for (int i = 0; i<12; i++) {
        int rowX = 32+64*i;
        int moveNum = 0;
        bool isColNull = false;
        for (int j = 0; j<10; j++) {
            int rowY = 98+64*j;
            bool isPaopao = false;
            int num = uiLayer->getMapPaopaoArray()->count();
            for (int i = 0; i< num ; i++) {
                NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
                 if (_myPaopao->boundingBox().containsPoint(CCPointMake(rowX, rowY))) {
                     _myPaopao->rowNum = moveNum;
                     isPaopao = true;
                     isColNull = true;
                    //CCLog("jia:%i",moveNum);
                 }
            }
            if (isPaopao == false) {
                moveNum++;

            }
        }
        if (isColNull == false) {
            AddMarkToPaopaoY(i);
        }
    }
    MovePaopao();
}
void GameScene::AddMarkToPaopaoY(int ColNum){
    int num = uiLayer->getMapPaopaoArray()->count();
    for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
        if (_myPaopao->getPositionX() > (64*ColNum+32) && _myPaopao->PosType == 1) {
            _myPaopao->colNum++;
        }
    }
}
void GameScene::MovePaopao(){
    int num = uiLayer->getMapPaopaoArray()->count();
    for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
        if (_myPaopao->baojinCol>0 && _myPaopao->rowNum > 0) {
           moveBaojin(_myPaopao->getPositionX());
        }
        _myPaopao->runAction(CCSequence::create(CCMoveTo::create(0.1, CCPointMake(_myPaopao->getPositionX()-64*_myPaopao->colNum, _myPaopao->getPositionY()-64*_myPaopao->rowNum)),NULL));
        _myPaopao->rowNum = 0;
        _myPaopao->colNum = 0;
    }

}
void GameScene::movePaopaoToUp(){
    curBaojinStat = true;
    CCObject* obj = NULL;
    CCARRAY_FOREACH(uiLayer->getChildByTag(_mSpriteBatchTag)->getChildren(), obj){
        NormalPaoPao* _myPaopao = (NormalPaoPao*)obj;
        if (_myPaopao->getPositionY()>674) {
           // CCLog("over");
                curBaojinStat = false;
               this->unschedule(schedule_selector(GameScene::update));
               this->unschedule(schedule_selector(GameScene::movePaopaoToUp));
                this->setTouchEnabled(false);
                showGameOver();
        }
    }

    if (curBaojinStat == true) {
        curTimePos = 0;
        CCARRAY_FOREACH(uiLayer->getChildByTag(_mSpriteBatchTag)->getChildren(), obj){
            NormalPaoPao* _myPaopao = (NormalPaoPao*)obj;

                if (_myPaopao->getPositionY() > 610) {
                    AddBaojin(_myPaopao->getPositionX());
                }
                if (_myPaopao->PosType == 1) {
                    _myPaopao->setPosition(CCPointMake(_myPaopao->getPositionX(), _myPaopao->getPositionY()+64));
                }else{
                    _myPaopao->setPosition(CCPointMake(_myPaopao->getPositionX(), _myPaopao->getPositionY()+64+4));
                    _myPaopao->PosType = 1;
                }
            }
    }

}
void GameScene::initPaopaoAll(){
    int num = uiLayer->getMapPaopaoArray()->count();
    for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
            _myPaopao->checkStat = 0;
    }
}
void GameScene::showGameOver(){
   // CCLog("GameOver");
    CCUserDefault::sharedUserDefault()->setBoolForKey("isNewGame", false);
    CCUserDefault::sharedUserDefault()->setIntegerForKey("curScore", curScore);
    CCUserDefault::sharedUserDefault()->setIntegerForKey("curGold", curGold);
    CCUserDefault::sharedUserDefault()->flush();
    

    openScene();
    //this->schedule(schedule_selector(GameScene::openScene), 1.0f);
}
void GameScene::openScene(){
   // this->unschedule(schedule_selector(GameScene::openScene));
    //CCDirector::sharedDirector()->replaceScene(Test::scene());
       CCDirector::sharedDirector()->replaceScene(FirstScene::scene());
}
void GameScene::AddBaojin(float rowX){
    int num = uiLayer->getMapPaopaoArray()->count();
    for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
         if (_myPaopao->getPositionX() == rowX) {
             _myPaopao->baojinCol = rowX;
         }
    }
    showBaojinPaopao();
    
}
void GameScene::showBaojinPaopao(){
    int num = uiLayer->getMapPaopaoArray()->count();
    for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
        if (_myPaopao->baojinCol > 0) {
            //_myPaopao->setScale(0.3);
            CCSpawn* spawn = CCSpawn::create(CCScaleTo::create(0.05, 0.95),CCRotateTo::create(0.05, 3),NULL);
            CCSpawn* spawn1 = CCSpawn::create(CCScaleTo::create(0.05, 1),CCRotateTo::create(0.05, -3),NULL);
             _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(spawn,spawn1,NULL)));
        }
    }
}
void GameScene::moveBaojin(float rowX){
    //CCLog("MoveBaojin");
    int num = uiLayer->getMapPaopaoArray()->count();
    for (int i = 0; i< num ; i++) {
        NormalPaoPao* _myPaopao = (NormalPaoPao*)uiLayer->getMapPaopaoArray()->objectAtIndex(i);
        if (_myPaopao->getPositionX() == rowX) {
            _myPaopao->baojinCol = -1;
            _myPaopao->setRotation(0);
            _myPaopao->setScale(1);
            _myPaopao->stopAllActions();
        }
    }
}