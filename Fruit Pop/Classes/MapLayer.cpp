//
//  MapLayer.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-8.
//
//

#include "MapLayer.h"
MapLayer::MapLayer(){
    _paopaoBatchNode = CCSpriteBatchNode::create("sekuai.png");
    CC_SAFE_RETAIN(_paopaoBatchNode);
    _paopaoArray = CCArray::create();
    CC_SAFE_RETAIN(_paopaoArray);
    _LineBatchNode = CCSpriteBatchNode::create("line.png");
    CC_SAFE_RETAIN(_LineBatchNode);
}
MapLayer::~MapLayer(){
    CC_SAFE_RELEASE_NULL(_paopaoBatchNode);
    CC_SAFE_RELEASE_NULL(_LineBatchNode);
    CC_SAFE_RELEASE_NULL(_paopaoArray);
}
bool MapLayer::init(){
    if (CCLayer::init()) {
       // CCSize winSize = CCDirector::sharedDirector()->getWinSize();
      //  CCSize size = CCEGLView::sharedOpenGLView()->getFrameSize();
     //   CCLog("width:%f,height:%f",size.width,size.height);
       // curGameTime = 100;
        initData();
        languageLayer = new Language();
        LanguageType = CCUserDefault::sharedUserDefault()->getIntegerForKey("LanguageType", 0);
        LanguageType = 1;
        //languageLayer->loadConfig();
        ct_time = 100;
       // curGameTimeSpan = ct_time/curGameTime;
        CCTMXTiledMap* m_GameMap = CCTMXTiledMap::create("FruitPopMapOne.tmx");
        _pgroupBgUnit = m_GameMap->objectGroupNamed("BgUnit");
        m_GameMap->setScale(0.5);
        m_GameMap->setTag(m_GameMapTag);
        addChild(m_GameMap);
        
        timeOverBg = CCSprite::create("TimeOverShow.png");
        timeOverBg->setPosition(CCPoint(ccp(160, 240)));
        timeOverBg->setScale(0.5);
        timeOverBg->setTag(2);
        timeOverBg->setVisible(false);
        addChild(timeOverBg);
        
        particleSysLayer = ParticleSysLayer::create();
        addChild(particleSysLayer);
        addChild(_LineBatchNode,0,LineNodeTag);
        addChild(_paopaoBatchNode,0,PaopaoNodeTag);


        initMap();
       // addNewPaopao(CCPointMake(160, 240),0);
        initBgUnit();
       // initTimeProgress();
       // CCSprite* sp = CCSprite::createWithTexture(_paopaoBatchNode->getTexture());
       // sp->setPosition(CCPointMake(100, 100));
       // _paopaoBatchNode->addChild(sp);
        
        //CCTMXLayer* layer = map->layerNamed("bgLayer");
        
       // unsigned int m_gid = layer->tileGIDAt(ccp(1, 2));
       // CCLog("m_gid:%i",m_gid);
        
        //layer->setTileGID(m_gid, ccp((float)3, (float)7));
        //layer->removeTileAt(ccp(5.0, 5.0));
        //CCSprite* title0 = layer->tileAt(ccp(1, 2));
        //title0->setAnchorPoint(ccp(0, 0));
        //title0->setScale(0.5);
        
      //  NormalPaopao* _paopao1 = NormalPaopao::createNormalPaopao();
       // _paopao1->setPosition(ccp(160, 300));
      //  addChild(_paopao1);

        
        return true;
    }else{
        return false;
    }

}
void MapLayer::initTimeProgress(int _curGameTime){
    
   // CCSize size = CCDirector::sharedDirector()->getWinSize();
    CCDictionary* dic = _pgroupBgUnit->objectNamed("TimeProgress");
    float x = dic->valueForKey("x")->floatValue()*0.5;
    float y = dic->valueForKey("y")->floatValue()*0.5;
    
    CCSprite* timeBg = CCSprite::create("timeBg.png");
    timeBg->setPosition(ccp(x, y));
    timeBg->setScale(0.4);
    this->addChild(timeBg);
    
    CCSprite* progessBar = CCSprite::create("timeYellow.png");
    progessBar->setPosition(ccp(x, y));
    progessBar->setScale(0.4);
    this->addChild(progessBar,1);
    
    ct = CCProgressTimer::create(CCSprite::create("timeGreen.png"));
    ct->setPosition(ccp(x, y));
    // ct->setType(kCCProgressTimerTypeRadial);
    ct->setScale(0.4);
    ct->setType(kCCProgressTimerTypeBar);
    ct->setMidpoint(ccp(0, 0));
    ct->setBarChangeRate(ccp(1.0f, 0));
    ct->setReverseProgress(true);
    //ct->setOpacity(100);
    

    
    
    ct->setPercentage(ct_time);
    this->addChild(ct,2);
    
    
    timeTTF = CCLabelTTF::create("", "Verdana-Bold", 50);
    timeTTF->setPosition(ccp(x, y));
    timeTTF->setScale(0.3);
    this->addChild(timeTTF,3);
    
    //CCDictionary* dic1 = _pgroupBgUnit->objectNamed("ScoreTTF");
    showTime(_curGameTime);
    //ct_time = 100;
   // this->schedule(schedule_selector(MapLayer::update), 0.2f);
}
void MapLayer::showTime(time_t _timep){
    //显示时间
    //unsigned long long timestamp = time(NULL);
  //  struct tm *ptm = localtime((time_t*)&timestamp);
    time_t timep = _timep;
    struct tm *ptm = gmtime(&timep);
    char tmp[100] = {0};
    memset(tmp, 0x0, 100);
    strftime(tmp, sizeof(tmp), "%M:%S", ptm);
    timeTTF->setString(tmp);
}
void MapLayer::update(int _curGameTime,float _ct_time){
    //curGameTime--;
   // if (curGameTime <1) {
     //   this->unschedule(schedule_selector(MapLayer::update));
  //  }
   // ct_time = ct_time - curGameTimeSpan;
    //if (ct_time > 0) {
     //   ct_time = ct_time - 0.9;
    //}else{
    //    ct_time = 100;
    //    this->unschedule(schedule_selector(MapLayer::update));
    //}
    ct->setPercentage(_ct_time);
    showTime(_curGameTime);
   // CCLog("ct_time:%f,curgameTime:%i",_ct_time,_curGameTime);
}
void MapLayer::initBgUnit(){

    
    //CCDictionary* languageDIC = CCDictionary::createWithContentsOfFile("Language.plist");
   // CCDictionary* language = (CCDictionary*)languageDIC->objectForKey("Chinese");
    //CCDictionary* language = (CCDictionary*)languageDIC->objectForKey("English");
    //string* score = (string*)language->valueForKey("ScoreBgTTF")->getCString();
   // char* scoreChar = (char*)language->valueForKey(languageLayer->getlabelChar("ScoreBgTTF"))->getCString();
    //CCLog("score:%s",score);
    
    
    
    CCDictionary* dic = _pgroupBgUnit->objectNamed("ScoreTTFObj");
   // CCDictionary* dic = _pgroupBgUnit->objectNamed("TimeProgress");
    float x = dic->valueForKey("x")->floatValue()*0.5;
    float y = dic->valueForKey("y")->floatValue()*0.5;
    
    //CCLabelTTF* scoreBgTTF = CCLabelTTF::create("Score:", "MarkerFelt-Thin", 50);
    CCSprite* scoreBgTTF = CCSprite::create("zuanshi.png");
    //CCLabelTTF* scoreBgTTF = CCLabelTTF::create(languageLayer->getlabelChar("ScoreBgTTF",LanguageType), "MarkerFelt-Thin", 50);
    scoreBgTTF->setPosition(ccp(x, y));
    scoreBgTTF->setScale(0.4);
    scoreBgTTF->setAnchorPoint(ccp(1, 0.5));
    //scoreBgTTF->setColor(ccc3(107, 245, 5));
    this->addChild(scoreBgTTF);
    
    
    scoreTTF = CCLabelTTF::create("0", "Verdana-Bold", 50);
    scoreTTF->setPosition(ccp(x+5, y));
    scoreTTF->setScale(0.3);
    scoreTTF->setAnchorPoint(ccp(0, 0.5));
    //scoreTTF->setColor(ccc3(107, 245, 5));
    this->addChild(scoreTTF,4,ScoreTTFTag);
    
    CCDictionary* goldDic = _pgroupBgUnit->objectNamed("GoldTTFObj");
    
    //CCLabelTTF* goldBgTTF = CCLabelTTF::create("Gold", "MarkerFelt-Thin", 50);
    CCSprite* goldBgTTF = CCSprite::create("shopCarGoldBg.png");
    
    goldBgTTF->setPosition(ccp(goldDic->valueForKey("x")->floatValue()*0.5-2, goldDic->valueForKey("y")->floatValue()*0.5));
    goldBgTTF->setScale(0.2);
    goldBgTTF->setAnchorPoint(ccp(1, 0.5));
    //scoreBgTTF->setColor(ccc3(107, 245, 5));
    this->addChild(goldBgTTF);
    
    
    goldTTF = CCLabelTTF::create("0", "Verdana-Bold", 50);
    goldTTF->setPosition(ccp(goldDic->valueForKey("x")->floatValue()*0.5, goldDic->valueForKey("y")->floatValue()*0.5));
    goldTTF->setScale(0.3);
    goldTTF->setAnchorPoint(ccp(0, 0.5));
    //scoreTTF->setColor(ccc3(107, 245, 5));
    this->addChild(goldTTF,4);
    
   // ParticleSysLayer* particleSysLayer = ParticleSysLayer::create();
    //addChild(particleSysLayer);
    //particleSysLayer->WaterTweenPlay(1, ccp(160, 400));
    
    CCSprite* light = CCSprite::create("light.png");
   // CCSprite* light = CCSprite::create("Icon.png");
    light->setPosition(ccp(100, 400));
    light->setAnchorPoint(ccp(0, 1));
    light->setScale(0.5);
   // addChild(light);
    //light->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(5.0f, 180),CCRotateTo::create(5.0f, 360),NULL)) );
}
CCLabelTTF* MapLayer::getscoreTTF(){
    return scoreTTF;
}
CCLabelTTF* MapLayer::getgoldTTF(){
    return goldTTF;
}
void MapLayer::addNewPaopao(CCPoint targetPoint,int rowMoveNum){
   // CCLog("rowMoveNum:%i",rowMoveNum);
    int _paopaoType = arc4random()%5;
    //_paopaoType = 0;
    NormalPaopao* _myPaopao = NormalPaopao::createNormalPaopao(_paopaoBatchNode->getTexture(),_paopaoType,0,rowMoveNum);
    _myPaopao->setPosition(targetPoint);
    _myPaopao->setScale(0.6);

    // _myPaopao->runAction(CCRepeatForever::create(CCSequence::create(CCRotateTo::create(0.5f, -15),CCRotateTo::create(0.5f, 15),NULL)));
    _paopaoBatchNode->addChild(_myPaopao);
    _paopaoArray->addObject(_myPaopao);

}
void MapLayer::initMap(){

    CCTMXTiledMap* m_GameMap = (CCTMXTiledMap*)this->getChildByTag(m_GameMapTag);
    CCTMXObjectGroup* _pgroup = m_GameMap->objectGroupNamed("PaopaoLayer");
    CCObject* obj = NULL;

    CCARRAY_FOREACH(_pgroup->getObjects(), obj){
        CCDictionary* dic = (CCDictionary*)obj;
        float x = dic->valueForKey("x")->floatValue();
        float y = dic->valueForKey("y")->floatValue();
       // minX = x - 0;
        if ( MinX > x*0.5 ) {MinX = x*0.5;}
        if (MinY > y*0.5) {MinY = y*0.5;}
        if ( MaxX < x*0.5 ) {MaxX = x*0.5;}
        if (MaxY < y*0.5) {MaxY = y*0.5;}
        addNewPaopao(CCPointMake(x*0.5, y*0.5),0);
    }
    initEquipment();
}
void MapLayer::addRowMoveNumToPaopao(){
   // CCLog("maX:%f,minX:%f,maxY:%f,minY:%f",MaxX,MinX,MaxY,MinY);
    for (int i = 0; i <= (MaxX-MinX)/64; i++) {
    //for (int i = 0; i <= 1; i++) {
        float rowPointX = MinX+64*i;
        int rowMoveNum = 0;
        for (int j = 0; j <= (MaxY-MinY)/64; j++) {
            float rowPointY = MinY+64*j;
            //CCLOG("rowPointX:%f,rowPointY:%f",rowPointX,rowPointY);
            CCObject* obj = NULL;
            bool isPappao = false;
            CCARRAY_FOREACH(_paopaoBatchNode->getChildren(), obj){
                NormalPaopao* _myPaopao = (NormalPaopao*)obj;
                if (_myPaopao->boundingBox().containsPoint(CCPointMake(rowPointX, rowPointY))) {
                    _myPaopao->rowMoveNum = rowMoveNum;
                    isPappao = true;
                    break;
                }
            }
            if (isPappao == false) {
                rowMoveNum++;
                addNewPaopao(CCPointMake(rowPointX, MaxY+64*6), (rowMoveNum+5));
            }
        }

    }

    movePaopao();
    initEquipment();
}
void MapLayer::movePaopao(){
    CCObject* obj = NULL;
    CCARRAY_FOREACH(_paopaoBatchNode->getChildren(), obj){
        NormalPaopao* _myPaopao = (NormalPaopao*)obj;
        _myPaopao->runAction(CCSequence::create(CCMoveTo::create(0.1f, CCPointMake(_myPaopao->getPositionX(), _myPaopao->getPositionY()-64*_myPaopao->rowMoveNum)),NULL));
        _myPaopao->rowMoveNum = 0;
    }
}
void MapLayer::movePaopaoFrUp(){
    
}
CCSpriteBatchNode* MapLayer::getpaopaoBatchNode(){
    return _paopaoBatchNode;
}
CCArray* MapLayer::getPaopaoArray(){
    return _paopaoArray;
}

#pragma mark -
#pragma mark Line

void MapLayer::addLine(cocos2d::CCPoint LineStartPoint, cocos2d::CCPoint LineEndPoint){
   // CCLog("addLine");
   // CCLOG("StartX:%f,startY:%f,EndX:%f,End:%f",LineStartPoint.x,LineStartPoint.y,LineEndPoint.x,LineEndPoint.y);
    int LineType;
    if (LineStartPoint.x == LineEndPoint.x) {
        LineType = 1;
    }else if (LineStartPoint.y == LineEndPoint.y){
        LineType = 2;
        
    }else if (LineEndPoint.x > LineStartPoint.x && LineEndPoint.y > LineStartPoint.y){
       // CCLOG("a");
        LineType = 3;
    }else if (LineEndPoint.x > LineStartPoint.x && LineEndPoint.y < LineStartPoint.y){
       // CCLOG("b");
        LineType = 4;
    }else if (LineEndPoint.x < LineStartPoint.x && LineEndPoint.y > LineStartPoint.y){
       // CCLOG("c");
        LineType = 4;
    }else if (LineEndPoint.x < LineStartPoint.x && LineEndPoint.y < LineStartPoint.y){
        //CCLOG("d");
        LineType = 3;
    }
    
    loadLine(LineType, CCPointMake(LineStartPoint.x+(LineEndPoint.x-LineStartPoint.x)*0.5, LineStartPoint.y+(LineEndPoint.y-LineStartPoint.y)*0.5));
    
}
void MapLayer::loadLine(int LineType,CCPoint Linepoint){
    //CCLOG("LineType:%i",LineType);
    CCSprite* line = CCSprite::createWithTexture(_LineBatchNode->getTexture());
    line->setPosition(Linepoint);
    line->setTag(3);
    line->setScale(0.4);
    switch (LineType) {
        case 1:
            //CCLog("east");
            line->setRotation(90);
            break;
        case 2:
            //CCLog("west");
            
            break;
        case 3:
           // CCLog("south");
            line->setRotation(-45);
            break;
        case 4:
           // CCLog("north");
            line->setRotation(45);
            break;
        case 5:
            //CCLog("northeast");
            
            break;
        case 6:
            //CCLog("northwest");
            break;
        case 7:
            //CCLog("southeast");
            break;
        default:
            //CCLog("southwest");
            break;
    }
    _LineBatchNode->addChild(line);
}
void MapLayer::removeLineOne(){
    _LineBatchNode->removeChildAtIndex((_LineBatchNode->getChildren()->count()-1), true);
}
void MapLayer::removeLineAll(){
    _LineBatchNode->removeAllChildren();
}
#pragma mark -
#pragma mark process equipment

void MapLayer::initEquipment(){

    addEquipmentBg(8);
    addEquipmentBg(7);
    if (_EquipmentZhadan == true) {
        addEquipmentBg(6);
    }
}
void MapLayer::addEquipmentBg(int _equipmentType){
    _randGoldBgId = arc4random()%150;
    CCObject* obj = NULL;
    int i = 0;
             //   CCLog("goldBgId:%i",_randGoldBgId);
    CCARRAY_FOREACH(_paopaoBatchNode->getChildren(), obj){
        if (i == _randGoldBgId) {
            NormalPaopao* _myPaopao = (NormalPaopao*)obj;
            _myPaopao->setTextureRect(CCRectMake(100 * _equipmentType,100 * 0,100,100));
            _myPaopao->PaopaoType = _equipmentType;
            _myPaopao->special = _equipmentType;
        }
        i++;
    }
}
void MapLayer::initData(){
    CCUserDefault::sharedUserDefault()->getIntegerForKey("extraTime",0);
    _EquipmentWugui = CCUserDefault::sharedUserDefault()->getBoolForKey("EquipmentWugui",false);
    _EquipmentZhadan =  CCUserDefault::sharedUserDefault()->getBoolForKey("EquipmentZhadan",false);
    _EquipmentZhongbiao =  CCUserDefault::sharedUserDefault()->getBoolForKey("EquipmentZhongbiao",false);
}

#pragma mark -
#pragma mark show
void MapLayer::showAddGold(CCPoint location,int goldNum){
    char goldChar[128];
    sprintf(goldChar, "+%d",goldNum);
    CCLabelTTF* goldTTF = CCLabelTTF::create(goldChar, "Verdana-Bold", 25);
    goldTTF->setPosition(location);
    goldTTF->setScale(0.5);
    goldTTF->setColor(ccc3(245, 240, 5));;
    addChild(goldTTF,5);
    
       // CCDictionary* goldDic = _pgroupBgUnit->objectNamed("GoldTTFObj");
    goldTTF->runAction(CCSequence::create(CCMoveTo::create(0.6f, ccp(280,470)),CCCallFuncN::create(this, callfuncN_selector(MapLayer::showTTFRemove)),NULL));
}
void MapLayer::showAddHightGold(int goldNum){
    char goldChar[128];
    sprintf(goldChar, "+%d",goldNum);
    CCLabelTTF* goldHightTTF = CCLabelTTF::create(goldChar, "Verdana-Bold", 60);
    goldHightTTF->setPosition(ccp(160, 240));
    goldHightTTF->setScale(0.5);
    goldHightTTF->setColor(ccc3(245, 240, 5));
    addChild(goldHightTTF,5);
    
    //CCDictionary* goldDic = _pgroupBgUnit->objectNamed("GoldTTFObj");
    goldHightTTF->runAction(CCSequence::create(CCSpawn::create(CCScaleTo::create(0.8f, 0.1),CCMoveTo::create(0.8f,ccp(280, 470)),NULL),CCCallFuncN::create(this, callfuncN_selector(MapLayer::showTTFRemove)),NULL));
}
void MapLayer::showTTFRemove(CCLabelTTF* pSender){
    CCLabelTTF* goldTTF =(CCLabelTTF*)pSender;
    removeChild(goldTTF);
}
void MapLayer::showTimeOver(){
//    timeOverBg = CCSprite::create("TimeOverShow.png");
//    timeOverBg->setPosition(CCPoint(ccp(160, 240)));
//    timeOverBg->setScale(0.5);
//    timeOverBg->setTag(1);
//    addChild(timeOverBg,1);
   // this->schedule(schedule_selector(MapLayer::timeOverBgHide), 0.3f);
    if (timeOverBg->getTag() == 1) {
        timeOverBg->setVisible(false);
        timeOverBg->setTag(2);
    }else{
        timeOverBg->setVisible(true);
        timeOverBg->setTag(1);
    }

}
void MapLayer::timeOverBgShow(){
    //this->unschedule(schedule_selector(MapLayer::timeOverBgShow));
}
void MapLayer::timeOverBgHide(){
//    if (timeOverBg->getTag() == 1) {
//        timeOverBg->setVisible(false);
//        timeOverBg->setTag(2);
//    }else{
//        timeOverBg->setVisible(true);
//        timeOverBg->setTag(1);
//    }
        //this->unschedule(schedule_selector(MapLayer::timeOverBgShow));
    //this->schedule(schedule_selector(MapLayer::timeOverBgHide), 0.1f);
}
void MapLayer::playParticalLineLight(int particalType,CCPoint location){
    CCLog("x:%f,y:%f",location.x,location.y);
    //particleSysLayer->LineLightPlay(1, location);
    particleSysLayer->LineLightPlay(1, CCPointMake(location.x, 220));
    particleSysLayer->LineLightPlay(2, CCPointMake(160, location.y));
}
void MapLayer::playParticalExplosion(int particalType, cocos2d::CCPoint location){
    particleSysLayer->ExplosionPlay(1, location);
}