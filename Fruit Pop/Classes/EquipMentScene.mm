//
//  EquipMentScene.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-11.
//
//

#include "EquipMentScene.h"
EquipMentScene::EquipMentScene(){}
EquipMentScene::~EquipMentScene(){}
CCScene* EquipMentScene::scene(){
    CCScene* scene = CCScene::create();
    CCLayer* layer = EquipMentScene::create();
    scene->addChild(layer);
    return scene;
}
bool EquipMentScene::init(){
    if (CCLayer::init()) {
        CCSprite* sp = CCSprite::create("Icon.png");
        sp->setPosition(ccp(160, 240));
        addChild(sp);
        
        
        CCLog("equipment");
        return true;
    }else{
        return false;
    }
}