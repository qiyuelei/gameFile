//
//  GameScene.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-8.
//
//

#include "GameScene.h"

GameScene::GameScene(){
    _selPaopaoArray = CCArray::create();
    CC_SAFE_RETAIN(_selPaopaoArray);
    _specielPaopaoArray = CCArray::create();
    CC_SAFE_RETAIN(_specielPaopaoArray);
}
GameScene::~GameScene(){
    CC_SAFE_RELEASE_NULL(_selPaopaoArray);
    CC_SAFE_RELEASE_NULL(_specielPaopaoArray);
}
CCScene* GameScene::scene(){
    CCScene* scene = CCScene::create();
    scene->addChild(GameScene::create());
    return scene;
}
bool GameScene::init(){
    if (CCLayer::init()) {
       winSize = CCDirector::sharedDirector()->getWinSize();

        languageLayer = new LanguageLayer();
        loadconfig();
        isLineStartPoint = true;
        
        loadLayer();
        //MapLayer* mapLayer =  (MapLayer*)this->getChildByTag(mapLayerTag);
        loadMenu();

        ct_timeSpan = ct_time/curGameTime;
        GameLogic();
        //this->setTouchEnabled(true);
        //showGameover();
        return true;
    }else{
        return false;
    }
}
void GameScene::moveMenuNode(){
   // CCLog("pos:%f",menuNode->getPositionX());
    if (gameStat == false) {
        menuNode->setVisible(true);
        CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
        CCDirector::sharedDirector()->pause();

       // menuNode->setPosition(ccp(10, 0));
    }
    
}
void GameScene::menuBtnCallBack(cocos2d::CCMenuItemImage *menuBtn){
    //CCLog("menuBtnCallBack");
        CCDirector::sharedDirector()->resume();
       // CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, false);
    if (menuBtn->getTag() == 1) {
        gameStat = true;
        menuNode->setVisible(false);
        CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, false);
    }else if (menuBtn->getTag() == 3){
        //int bestScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("curGold");
        ChannelClass* channel = new ChannelClass();
        channel->ShareFaceBook(curGold);
    }else{
        CCUserDefault::sharedUserDefault()->setIntegerForKey("curGold",curGold);
        CCUserDefault::sharedUserDefault()->flush();
        FirstScene* firstScene = FirstScene::create();
        firstScene->moveequipment();
        CCDirector::sharedDirector()->replaceScene((CCScene*)firstScene);
    }
}
void GameScene::pauseBtnCallBack(){
    if (gameStat == true) {
        gameStat = false;
        moveMenuNode();
    }

    //CCDirector::sharedDirector()->replaceScene(FirstScene::scene());
}

void GameScene::testMove(){
    mapLayer->addRowMoveNumToPaopao();
}
void GameScene::test(){
  //  CCLOG("test");
    //mapLayer->removeLineAll();
    //initPaopao();
    mapLayer->getChildByTag(PaopaoNodeTag)->removeAllChildren();
    mapLayer->getChildByTag(LineNodeTag)->removeAllChildren();
    mapLayer->initMap();
}
void GameScene::loadLayer(){
    soundLayer = new SoundLayer();
    
    mapLayer = MapLayer::create();
    addChild(mapLayer,0,mapLayerTag);
    
    //DialogLayer* dialogLayer = DialogLayer::create();
    //addChild(dialogLayer);
        //CCLog("curGold:%i",curGold);
    char goldChar[128];
    sprintf(goldChar, "%d",curGold);
    mapLayer->getgoldTTF()->setString(goldChar);
    
   // mapLayer->showAddGold(CCPointMake(100, 100), 14);
    //dialogLayer->showAddGold(CCPointMake(100, 100), 15);
//    particleSysLayer = ParticleSysLayer::create();
//    addChild(particleSysLayer);
   // particleSysLayer->WaterTweenPlay(1, ccp(160, 300));

}
void GameScene::loadMenu(){
    menuNode = CCNode::create();
    addChild(menuNode);
    
    CCSprite* MenuBg = CCSprite::create("shopCarBg.png");
    MenuBg->setPosition(ccp(winSize.width*0.5, winSize.height*0.5));
    MenuBg->setScale(0.5);
    menuNode->addChild(MenuBg);
    
    CCMenuItemImage* BackEquipmentBtn = CCMenuItemImage::create("playBtn.png", "playBtn_after.png",this,menu_selector(GameScene::menuBtnCallBack));
    BackEquipmentBtn->setScale(0.5);
    BackEquipmentBtn->setPosition(ccp(160,260));
    BackEquipmentBtn->setTag(1);
   // menuNode->addChild(BackEquipmentBtn);
    
    CCMenuItemImage* ResumeBtn = CCMenuItemImage::create("backHome.png", "backHome.png",this,menu_selector(GameScene::menuBtnCallBack));
    ResumeBtn->setScale(0.2);
    ResumeBtn->setRotation(180);
    ResumeBtn->setPosition(ccp(160,200));
    ResumeBtn->setTag(2);
    //menuNode->addChild(ResumeBtn);
    
    CCMenu* pNodeMenu = CCMenu::create(BackEquipmentBtn,ResumeBtn,NULL);
    //pMenu->setAnchorPoint(ccp(0,0));
    pNodeMenu->setPosition(CCPointZero);
    menuNode->addChild(pNodeMenu);
    
    menuNode->setVisible(false);
    
    CCLabelTTF* btnttf = CCLabelTTF::create("reload", "Airal", 32);
    CCMenuItemLabel* btn = CCMenuItemLabel::create(btnttf, this, menu_selector(GameScene::test));
    btn->setPosition(ccp(0, -200));
    
    CCMenuItemImage* pauseBtn = CCMenuItemImage::create("pauseBtn.png", "pauseBtn.png",this, menu_selector(GameScene::pauseBtnCallBack));
    //CCLabelTTF* movettf = CCLabelTTF::create("pause", "Airal", 32);
    //CCMenuItemLabel* movebtn = CCMenuItemLabel::create(movettf, this, menu_selector(GameScene::pauseBtnCallBack));
    pauseBtn->setPosition(ccp(300, 440));
    pauseBtn->setScale(0.4);
    
    CCMenu* pMenu = CCMenu::create(btn,pauseBtn,NULL);
    //pMenu->setAnchorPoint(ccp(0,0));
    pMenu->setPosition(CCPointZero);
    addChild(pMenu,0,pMenuTag);
}
void GameScene::update(){
    curGameTime--;
    if (curGameTime <1) {
        soundLayer->playEffect(5);
      //  CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
       // SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
        this->unschedule(schedule_selector(GameScene::update));
       // this->unschedule(schedule_selector(GameScene::baojin));
        this->schedule(schedule_selector(GameScene::showGameover), 1.0f);

        //showStageOver();
        //this->schedule(schedule_selector(GameScene::showStageOver), 3.0f);
       // showGameover();
        //CCLog("over");
    }
    
    //if (curGameTime < 50) {
        if (curGameTime == 9) {

            this->schedule(schedule_selector(GameScene::baojin), 3.0f);
        }else if (curGameTime == 4){
            this->unschedule(schedule_selector(GameScene::baojin));
        }


    //}
    ct_time = ct_time - ct_timeSpan;
    mapLayer->update(curGameTime, ct_time);
}
void GameScene::baojin(){
        //this->unschedule(schedule_selector(GameScene::baojin));
        //SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
        soundLayer->playEffect(9);
        mapLayer->showTimeOver();
}
void GameScene::GameLogic(){
    mapLayer->initTimeProgress(curGameTime);
    this->schedule(schedule_selector(GameScene::update), updateTime);
}
void GameScene::showGameover(){
    this->unschedule(schedule_selector(GameScene::showGameover));
    GameoverNode = CCNode::create();
   // GameoverNode->setPosition(CCPointZero);
    addChild(GameoverNode);
    
    CCSprite* showGameoverBg = CCSprite::create("shopCarBg.png");
    showGameoverBg->setPosition(ccp(160,240));
    showGameoverBg->setScale(0.5);
    GameoverNode->addChild(showGameoverBg);
    
    CCSprite* overScoreBg = CCSprite::create("zuanshi.png");
    overScoreBg->setPosition(ccp(80,280));
    overScoreBg->setScale(0.4);
    overScoreBg->setAnchorPoint(ccp(1,0.5));
    GameoverNode->addChild(overScoreBg);
    
    CCSprite* overGoldBg = CCSprite::create("shopCarGoldBg.png");
    overGoldBg->setPosition(ccp(80,240));
    overGoldBg->setScale(0.3);
    overGoldBg->setAnchorPoint(ccp(1, 0.5));
    GameoverNode->addChild(overGoldBg);
    

    CCLabelTTF* titleTTF = CCLabelTTF::create(languageLayer->getChar("Game Over"), "Verdana-Bold", 50);
    titleTTF->setScale(0.3);
    titleTTF->setPosition(ccp(160, 330));
    GameoverNode->addChild(titleTTF);
    
    char scoreChar[128];
    sprintf(scoreChar, "%d",curScore);
    CCLabelTTF* overScoreTTF = CCLabelTTF::create(scoreChar, "", 32);
    overScoreTTF->setScale(0.5);
    overScoreTTF->setAnchorPoint(ccp(0, 0.5));
    overScoreTTF->setPosition(ccp(82, 280));
    GameoverNode->addChild(overScoreTTF);
    
    char goldChar[128];
    sprintf(goldChar, "%d",curGold);
    CCLabelTTF* overGoldTTF = CCLabelTTF::create(goldChar, "", 32);
    overGoldTTF->setScale(0.5);
    overGoldTTF->setAnchorPoint(ccp(0, 0.5));
    overGoldTTF->setPosition(ccp(82, 240));
    GameoverNode->addChild(overGoldTTF);
    
    CCMenuItemImage* shareBtn = CCMenuItemImage::create("facebook.png", "facebook_after.png",this,menu_selector(GameScene::menuBtnCallBack));
    shareBtn->setScale(0.5);
    shareBtn->setTag(3);
    shareBtn->setPosition(ccp(220, 260));
    
    CCMenuItemImage* BackStartBtn = CCMenuItemImage::create("playBtn.png", "playBtn.png",this,menu_selector(GameScene::menuBtnCallBack));
    BackStartBtn->setScale(0.5);
    BackStartBtn->setTag(2);
    BackStartBtn->setPosition(ccp(winSize.width*0.5, 150));
    
    CCMenu* pOverMenu = CCMenu::create(shareBtn,BackStartBtn,NULL);
    pOverMenu->setPosition(CCPointZero);
    GameoverNode->addChild(pOverMenu);
    GameoverNode->setPosition(ccp(-320, 0));
    
    GameoverNode->runAction(CCSequence::create(CCMoveTo::create(0.1f, ccp(0, 0)),NULL));
    
}
void GameScene::showOverShare(){
    //CCLog("SHARE");
}
void GameScene::showStageOver(){
    //this->unschedule(schedule_selector(GameScene::showStageOver));
    
    
    //CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
    this->removeChild(mapLayer);
    StageOverScene* stageLayer = StageOverScene::create();
    char scoreChar[128];
    sprintf(scoreChar, "%d",curScore);
    stageLayer->getScoreTTF()->setString(scoreChar);
    addChild(stageLayer);
    CCMenu* pMenu = (CCMenu*)this->getChildByTag(pMenuTag);
    pMenu->runAction(CCSequence::create(CCMoveTo::create(0.016f, ccp(pMenu->getPositionX()-320, pMenu->getPositionY())),NULL));
    //CCScene* sc = StageOverScene::scene();
    //CCDirector::sharedDirector()->replaceScene(sc);
}

#pragma mark -
#pragma mark ccTouch
bool GameScene::ccTouchBegan(CCTouch* touch, CCEvent *event){
   // CCLog("ccTouchBegan");
    _specielPaopaoArray->removeAllObjects();
    _selPaopaoArray->removeAllObjects();
    curClickStat = -1;
    curCheckNum = 0;
        CCPoint location = touch->getLocation();
        CCObject* obj = NULL;
           CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
            NormalPaopao* _myPaopao = (NormalPaopao*)obj;
            if (_myPaopao->boundingBox().containsPoint(location) && curClickStat == -1) {
                    curClickStat = _myPaopao->PaopaoType;
                if (curClickStat == 8) {
                    _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
                    _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
                    _specielPaopaoArray->addObject(_myPaopao);
                    //CCLog("gold");
                }else if (curClickStat == 6){
                   // CCLog("zhadan");
                    _myPaopao->special = curClickStat;
                    _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
                    _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
                    _specielPaopaoArray->addObject(_myPaopao);
                    zhadanProcess(_myPaopao->getPosition(), curClickStat);
                }else if (curClickStat == 7){
                    _myPaopao->checkStat = curClickStat;
                    _myPaopao->special = curClickStat;
                    _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
                    _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
                    _specielPaopaoArray->addObject(_myPaopao);
                    caiseFruitProcess(_myPaopao->getPosition());
                }else{
                   // CCLog("Normal");
                    _myPaopao->checkStat = curCheckNum;
                    LineStartPoint = _myPaopao->getPosition();
                   _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
                    //                   // _myPaopao->setScale(0.6);
                    _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
                    _selPaopaoArray->addObject(_myPaopao);
                }
            }
           }
    return true;
}
void GameScene::ccTouchMoved(CCTouch *touch, CCEvent *event){
    //CCLog("ccTouchMoved");
    if (curClickStat >= 0 && curClickStat < 6) {
      //  CCLog("NormalMove");
            CCPoint location = touch->getLocation();
           CCObject* obj = NULL;
           CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
                NormalPaopao* _myPaopao = (NormalPaopao*)obj;
               if ((_myPaopao->boundingBox().containsPoint(location) && _myPaopao->PaopaoType == curClickStat && ccpDistance(_myPaopao->getPosition(), LineStartPoint) < 91)) {

                   //CCLog("asdf:%i",_myPaopao->checkStat);
                   if (_myPaopao->checkStat < 0) {
                       mapLayer->addLine(LineStartPoint, _myPaopao->getPosition());
                       CCLog("new Same type");
                       curCheckNum++;
                        LineStartPoint = _myPaopao->getPosition();
                       _myPaopao->checkStat = curCheckNum;
                       _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
                       //                   // _myPaopao->setScale(0.6);
                       _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
                       //_selPaopaoArray->addObject(_selPaopaoArray);
                       _selPaopaoArray->addObject(_myPaopao);

                   }else if (_myPaopao->checkStat == (curCheckNum-1)){
                       curCheckNum--;
                      // LineStartPoint = _myPaopao->getPosition();
                       CCLog("old Same type,count:%i",_selPaopaoArray->count());
                       //clearlastpaopapo
                       NormalPaopao* _myPaopao2 = (NormalPaopao*)_selPaopaoArray->objectAtIndex((_selPaopaoArray->count()-1));
                       _myPaopao2->checkStat = -1;
                       _myPaopao2->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 0,100,100));
                       _myPaopao2->stopAllActions();
                       _selPaopaoArray->removeLastObject();
                        mapLayer->removeLineOne();
                        LineStartPoint = _myPaopao->getPosition();
                       
                   }
                }
           }

    }
}
void GameScene::ccTouchEnded(CCTouch *touch, CCEvent *event){
    CCLog("ccTouchEnded");
    if (curClickStat >= 6) {
        clearSelPaopao(2);
    }else{
        clearSelPaopao(1);
        //initPaopaoAll();
    }
}
//bool GameScene::ccTouchBegan(CCTouch* touch, CCEvent *event){
//    _selPaopaoArray->removeAllObjects();
//    _specielPaopaoArray->removeAllObjects();
//    curCheckNum = 0;
//    CCPoint location = touch->getLocation();
//    CCObject* obj = NULL;
//       CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
//        NormalPaopao* _myPaopao = (NormalPaopao*)obj;
//        if (_myPaopao->boundingBox().containsPoint(location) && isLineStartPoint == true) {
//            switch (_myPaopao->PaopaoType) {
//                case 8:
//                    
//                    break;
//                case 7:
//                    
//                    break;
//                case 6:
//                    isLineStartPoint = false;
//                    _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
//                   // _myPaopao->setScale(0.6);
//                    _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
//                   // LineStartPoint = _myPaopao->getPosition();
//                    curPaopaoType = _myPaopao->PaopaoType;
//                    curCheckNum++;
//                   // _myPaopao->checkStat = curCheckNum;
//                    //_selPaopaoArray->addObject(_myPaopao);
//                    zhadanProcess(_myPaopao->getPosition(),curCheckNum);
//                    _specielPaopaoArray->addObject(_myPaopao);
//                    break;
//                default:
//                    isLineStartPoint = false;
//                    _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
//                    _myPaopao->setScale(0.6);
//                    _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
//                    LineStartPoint = _myPaopao->getPosition();
//                    curPaopaoType = _myPaopao->PaopaoType;
//                    curCheckNum++;
//                    _myPaopao->checkStat = curCheckNum;
//                    _selPaopaoArray->addObject(_myPaopao);
//                    break;
//            }
//
//        }
//    }
//    return true;
//}
//void GameScene::ccTouchMoved(CCTouch *touch, CCEvent *event){
//    //CCLOG("ccTouchMoved");
//    CCPoint location = touch->getLocation();
//    CCObject* obj = NULL;
//   CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
//        NormalPaopao* _myPaopao = (NormalPaopao*)obj;
//        if ((_myPaopao->boundingBox().containsPoint(location) && isLineStartPoint == false && _myPaopao->PaopaoType == curPaopaoType)) {
//           // if (_myPaopao->special >0 || _myPaopao->PaopaoType == curPaopaoType) {
//            if (_myPaopao->checkStat == 0) {
//              //  CCLog("distance:%f",ccpDistance(_myPaopao->getPosition(), LineStartPoint));
//                if (ccpDistance(_myPaopao->getPosition(), LineStartPoint) < 91) {
//                    _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
//                    _myPaopao->setScale(0.6);
//                    _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
//
//                    mapLayer->addLine(LineStartPoint, _myPaopao->getPosition());
//                    LineStartPoint = _myPaopao->getPosition();
//                    curCheckNum++;
//                    _myPaopao->checkStat = curCheckNum;
//                    if (_myPaopao->PaopaoType == 6) {
//                    }
//                    _selPaopaoArray->addObject(_myPaopao);
//                }
//            }else{
//                if (_myPaopao->checkStat == (curCheckNum - 1) && curCheckNum > 1) {
//                   // CCLog("ok");
//                    LineStartPoint = _myPaopao->getPosition();
//                    removePaopaoFrSel(curCheckNum);
//                    curCheckNum--;
//                }
//
//            }}
//      //  }
//    }
//}
//void GameScene::ccTouchEnded(CCTouch *touch, CCEvent *event){
//   // CCLOG("ccTouchEnded");
//    isLineStartPoint = true;
//    mapLayer->getChildByTag(LineNodeTag)->removeAllChildren();
//    int PaopaoNum = _selPaopaoArray->count();
//    if (PaopaoNum > 2) {
//        //clear SelPaopao
//
//            //showGaofen
//        if (PaopaoNum > 5 && PaopaoNum < 11) {
//
//            soundLayer->playEffect(4);
//            mapLayer->showAddHightGold(500);
//            char goldChar[128];
//            curGold = curGold+500;
//            sprintf(goldChar, "%d",curGold);
//            mapLayer->getgoldTTF()->setString(goldChar);
//        }else if (PaopaoNum > 10){
//            soundLayer->playEffect(4);
//            mapLayer->showAddHightGold(500);
//            char goldChar[128];
//            curGold = curGold+1000;
//            sprintf(goldChar, "%d",curGold);
//            mapLayer->getgoldTTF()->setString(goldChar);
//        }else{
//            soundLayer->playEffect(6);
//        }
//        curScore = curScore + PaopaoNum*PaopaoNum*5;
//        char scoreChar[128];
//        sprintf(scoreChar, "%d",curScore);
//        mapLayer->getscoreTTF()->setString(scoreChar);
//        clearSelPaopao(1);
//    }else if (PaopaoNum == 1){
//      //  processSpecialPaopao(touch->getLocation());
//        initPaopaoAll();
//    }else{
//        //init Paopao
//        initPaopaoAll();
//    }
//    if (_specielPaopaoArray->count() > 0) {
//        CCLog("is speceal");
//        processSpecialPaopao(touch->getLocation());
//    }
//}
void GameScene::removePaopaoFrSel(int _curCheckNum){
    CCObject* obj = NULL;
    CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
        NormalPaopao* _myPaopao = (NormalPaopao*)obj;
        if (_myPaopao->checkStat == _curCheckNum) {
        _myPaopao->checkStat = -1;
        _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 0,100,100));
        _myPaopao->stopAllActions();
        _myPaopao->setScale(0.6);
        _selPaopaoArray->removeObject(_myPaopao);
    }}
    _specielPaopaoArray->removeAllObjects();
    mapLayer->removeLineOne();
}
void GameScene::clearSelPaopao(int clearType){
    CCSpriteBatchNode* _paopaoBatchNode = (CCSpriteBatchNode*)mapLayer->getChildByTag(PaopaoNodeTag);
    if (clearType == 1) {
        int selPaopaoNum = _selPaopaoArray->count();
        if (selPaopaoNum > 2) {
            soundLayer->playEffect(6);
                   curScore = curScore + selPaopaoNum*selPaopaoNum*5;
                    char scoreChar[128];
                    sprintf(scoreChar, "%d",curScore);
                    mapLayer->getscoreTTF()->setString(scoreChar);
            for (int i = 0; i < selPaopaoNum; i++) {
                NormalPaopao* _myPaopao = (NormalPaopao*)_selPaopaoArray->objectAtIndex(i);
                _paopaoBatchNode->removeChild(_myPaopao, true);
            }
            mapLayer->addRowMoveNumToPaopao();
        }else{
            initPaopaoAll();
        }
    }else if (clearType == 2){
        CCLog("count:%i",_specielPaopaoArray->count());
        for (int i = 0; i<_specielPaopaoArray->count(); i++) {
            NormalPaopao* _myPaopao = (NormalPaopao*)_specielPaopaoArray->objectAtIndex(i);
            if (_myPaopao->PaopaoType == 8) {
                soundLayer->playEffect(4);
                char goldChar[128];
                curGold = curGold+100;
                sprintf(goldChar, "%d",curGold);
                mapLayer->showAddGold(_myPaopao->getPosition(), 100);
                mapLayer->getgoldTTF()->setString(goldChar);

            }else if (_myPaopao->PaopaoType == 6){
                if (_myPaopao->special == 6) {
                    soundLayer->playEffect(7);
                    mapLayer->playParticalExplosion(1, _myPaopao->getPosition());
                }
            }else if (_myPaopao->PaopaoType==7){
                if (_myPaopao->special == 7) {
                    soundLayer->playEffect(8);
                    mapLayer->playParticalLineLight(1, _myPaopao->getPosition());
                }
            }
            _paopaoBatchNode->removeChild(_myPaopao, true);
        }
        mapLayer->addRowMoveNumToPaopao();
    }
    mapLayer->removeLineAll();
}
//void GameScene::clearSelPaopao(int clearType){
//    CCSpriteBatchNode* _paopaoBatchNode = (CCSpriteBatchNode*)mapLayer->getChildByTag(PaopaoNodeTag);
//    for (int i = 0; i < _selPaopaoArray->count(); i++) {
//        NormalPaopao* _myPaopao = (NormalPaopao*)_selPaopaoArray->objectAtIndex(i);
//        switch (_myPaopao->special) {
//            case 8:
//                char goldChar[128];
//                curGold = curGold+200;
//                sprintf(goldChar, "%d",curGold);
//                //CCLog("curGold:%i",curGold);
//                mapLayer->showAddGold(_myPaopao->getPosition(), 200);
//                mapLayer->getgoldTTF()->setString(goldChar);
//
//                break;
//            case 6:
//                break;
//                
//            default:
//                break;
//        }
//        _paopaoBatchNode->cocos2d::CCNode::removeChild(_myPaopao);
//    }
//    for (int j = 0; j < _specielPaopaoArray->count(); j++) {
//        NormalPaopao* _myPaopao2 = (NormalPaopao*)_specielPaopaoArray->objectAtIndex(j);
//        _paopaoBatchNode->cocos2d::CCNode::removeChild(_myPaopao2);
//    }
//    mapLayer->addRowMoveNumToPaopao();
//
//}
void GameScene::loadNewPaopao(){
    this->unschedule(schedule_selector(GameScene::loadNewPaopao));
    mapLayer->addRowMoveNumToPaopao();
}
void GameScene::zhadanProcess(CCPoint location,int _curcheckNum){
//getPoint
    //CCLog("zhadan");
    CCPoint zhaPoint;
    for (int i = 0; i< 8; i++) {
        switch (i) {
           case 0:
                zhaPoint = CCPointMake(location.x+64, location.y);
                break;
            case 1:
                zhaPoint = CCPointMake(location.x+64, location.y+64);
                break;
            case 2:
                zhaPoint = CCPointMake(location.x+64, location.y-64);
                break;
            case 3:
                zhaPoint = CCPointMake(location.x-64, location.y);
                break;
            case 4:
                zhaPoint = CCPointMake(location.x-64, location.y+64);
                break;
            case 5:
                zhaPoint = CCPointMake(location.x-64, location.y-64);
                break;
            case 6:
                zhaPoint = CCPointMake(location.x, location.y+64);
                break;
            case 7:
                zhaPoint = CCPointMake(location.x, location.y-64);
                break;
            default:
                break;
       }
           // CCLog("i:%i",i);
        CCObject* obj = NULL;
        CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
            NormalPaopao* _myPaopao = (NormalPaopao*)obj;
            if (_myPaopao->checkStat == -1 && _myPaopao->boundingBox().containsPoint(zhaPoint)) {
               // CCLog("curcheckNum:%i",_curcheckNum);
               // _myPaopao->checkStat = _curcheckNum;
                _specielPaopaoArray->addObject(_myPaopao);
                //_selPaopaoArray->addObject(_myPaopao);
                _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
                _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
            }

        }
    }
    //clearSelPaopao();
    //selPaopao
    //delPaopao
    //addnewPaopao
}
void GameScene::initPaopaoAll(){
    //CCLog("initAll");
    CCObject* obj = NULL;
    CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
        NormalPaopao* _myPaopao = (NormalPaopao*)obj;
        _myPaopao->checkStat = -1;
        _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 0,100,100));
        _myPaopao->stopAllActions();
       // _myPaopao->setScale(0.6);
    }
    isLineStartPoint = true;
}
void GameScene::loadconfig(){
    gameStat = true;
    int zhongbiaoTime;
    CCUserDefault::sharedUserDefault()->getBoolForKey("EquipmentZhongbiao",false);
    if (CCUserDefault::sharedUserDefault()->getBoolForKey("EquipmentZhongbiao",false) == true) {
        zhongbiaoTime = 25;
    }else{
        zhongbiaoTime = 0;
    }
    curGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("curGold",0);
       // CCLog("curGold1:%i",curGold);
    curGameTime = 60+zhongbiaoTime+CCUserDefault::sharedUserDefault()->getIntegerForKey("extraTime",0);
    //curGameTime = 15;//test
    CCUserDefault::sharedUserDefault()->getBoolForKey("EquipmentWugui",false);
    if (CCUserDefault::sharedUserDefault()->getBoolForKey("EquipmentWugui",false) == true) {
        updateTime = 1.5;
    }else{
        updateTime = 1;
    }
}

//void GameScene::addRowMoveNumToPaopao(){
//    bool isMove = false;
//    int MaxX = 288;
//    int MinX = 32;
//    int MaxY = 384;
//    int MinY = 64;
//    for (int i = 0; i <= (MaxX-MinX)/64; i++) {
//        //for (int i = 0; i <= 1; i++) {
//        float rowPointX = MinX+64*i;
//        int rowMoveNum = 0;
//        for (int j = 0; j <= (MaxY-MinY)/64; j++) {
//            if (i == (MaxX-MinX)/64 && j == (MaxY-MinY)/64) {
//                isMove = true;
//            }
//            float rowPointY = MinY+64*j;
//            //CCLOG("rowPointX:%f,rowPointY:%f",rowPointX,rowPointY);
//            CCObject* obj = NULL;
//            bool isPappao = false;
//            CCARRAY_FOREACH(mapLayer->getpaopaoBatchNode()->getChildren(), obj){
//                NormalPaopao* _myPaopao = (NormalPaopao*)obj;
//                if (_myPaopao->boundingBox().containsPoint(CCPointMake(rowPointX, rowPointY))) {
//                    _myPaopao->rowMoveNum = rowMoveNum;
//                    isPappao = true;
//                    break;
//                }
//            }
//            if (isPappao == false) {
//                rowMoveNum++;
//               // CCLog("rowMoveNum:%i",rowMoveNum);
//                
//           // mapLayer->addNewPaopao(CCPointMake(rowPointX, 100), (rowMoveNum+1));
//           mapLayer->addNewPaopao(CCPointMake(rowPointX, MaxY+64*6), (rowMoveNum+5));
//            }
//        }
//        
//    }
//    
//    if (isMove == true) {
//        movePaopao();
//    }
//
//    
////    initEquipment();
//}
//void GameScene::movePaopao(){
//    CCObject* obj = NULL;
//    CCARRAY_FOREACH(mapLayer->getpaopaoBatchNode()->getChildren(), obj){
//        NormalPaopao* _myPaopao = (NormalPaopao*)obj;
//        _myPaopao->runAction(CCSequence::create(CCMoveTo::create(0.1f, CCPointMake(_myPaopao->getPositionX(), _myPaopao->getPositionY()-64*_myPaopao->rowMoveNum)),NULL));
//        _myPaopao->rowMoveNum = 0;
//       // _myPaopao->setScale(0.2);
//       // CCLog("rowMoveNum:%i",_myPaopao->rowMoveNum);
//    }
//}
void GameScene::processSpecialPaopao(cocos2d::CCPoint pTouch){
    //CCLog("special:x:%f,y:%f",pTouch.x,pTouch.y);
    //method 1
    for (int i = 0; i<_specielPaopaoArray->count(); i++) {
        NormalPaopao* _myPaopao = (NormalPaopao*)_specielPaopaoArray->objectAtIndex(i);
       // CCLog("Num:%i",_myPaopao->PaopaoType);
        switch (_myPaopao->PaopaoType) {
            case 8:
               // _myPaopao->setScale(0.2);
                clearSelPaopao(2);
                break;
            case 7:
                // _myPaopao->setScale(0.2);
                //clearSelPaopao();
                break;
            case 6:
                CCLog("clearZhadan");
                clearSelPaopao(2);
                //initPaopaoAll();
                break;
            default:
                initPaopaoAll();
                break;
        }
    }
}
void GameScene::caiseFruitProcess(CCPoint pTouch){
    CCLog("caiseFruit:x:%f,y:%f",pTouch.x,pTouch.y);
        CCPoint zhaPoint;
    //find x
    for (int i = 0; i< 5; i++) {
        zhaPoint = CCPointMake(288-(288/5)*i, pTouch.y);
        CCObject* obj = NULL;
        CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
            NormalPaopao* _myPaopao = (NormalPaopao*)obj;
            if (_myPaopao->checkStat == -1 && _myPaopao->boundingBox().containsPoint(zhaPoint)) {
                _specielPaopaoArray->addObject(_myPaopao);
                _myPaopao->checkStat = curClickStat;
                _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
                _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
            }
        }
    }


    //find y
    for (int i = 0; i< 6; i++) {
        zhaPoint = CCPointMake(pTouch.x,64+64*i);
    CCObject* obj = NULL;
    CCARRAY_FOREACH(mapLayer->getChildByTag(PaopaoNodeTag)->getChildren(), obj){
        NormalPaopao* _myPaopao = (NormalPaopao*)obj;
        if (_myPaopao->checkStat == -1 && _myPaopao->boundingBox().containsPoint(zhaPoint)) {
            _specielPaopaoArray->addObject(_myPaopao);
            _myPaopao->checkStat = curClickStat;
            _myPaopao->setTextureRect(CCRectMake(100 * _myPaopao->PaopaoType,100 * 1,100,100));
            _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, 30),CCRotateTo::create(0.5f, -30),NULL)) );
        }
    }    }
}
void GameScene::onEnter(){
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, false);
    CCLayer::onEnter();
}
void GameScene::onExit(){

    CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
    CCLayer::onExit();
}

