//
//  Test.cpp
//  Pet Collapse
//
//  Created by long shenghua on 13-10-23.
//
//

#include "Test.h"
Test::Test(){}
Test::~Test(){}
CCScene* Test::scene(){
    CCScene* scene = CCScene::create();
    scene->addChild(Test::create());
    return scene;
}
bool Test::init(){
    if (CCLayer::init()) {
        initData();
        CCLog("test");
        return true;
    }else{
        return false;
    }
}
void Test::initData(){
    
//    _heartNum = CCUserDefault::sharedUserDefault()->getIntegerForKey("HeartNum",5);
//    heartTime = CCUserDefault::sharedUserDefault()->getIntegerForKey("heartTime", 0);
//    bestScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("BestScore",0);
//    TotalGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("TotalGold",0);
//    curGold = CCUserDefault::sharedUserDefault()->getIntegerForKey("curGold",0);
//    curScore = CCUserDefault::sharedUserDefault()->getIntegerForKey("curScore",0);
//    isNewGame = CCUserDefault::sharedUserDefault()->getIntegerForKey("isNewGame",true);
//    //isNewGame = false;
//    //curScore = 100;
//    //curGold = 20;
//    _heartNum = 6;
}