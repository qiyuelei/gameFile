//
//  StageOverScene.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-10.
//
//

#include "StageOverScene.h"
StageOverScene::StageOverScene(){}
StageOverScene::~StageOverScene(){}
CCScene* StageOverScene::scene(){
    CCScene* scene = CCScene::create();
    scene->addChild(StageOverScene::create());
    return scene;
}
bool StageOverScene::init(){
    if (CCLayer::init()) {
        
        scoreTTF = CCLabelTTF::create("test", "Airal", 21);
        scoreTTF->setPosition(ccp(160, 240));
        addChild(scoreTTF);
        return true;
    }else{
        return false;
    }

}
CCLabelTTF* StageOverScene::getScoreTTF(){
    return scoreTTF;
}