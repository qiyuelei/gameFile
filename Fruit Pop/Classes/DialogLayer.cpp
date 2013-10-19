//
//  DialogLayer.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-14.
//
//

#include "DialogLayer.h"
DialogLayer::DialogLayer(){}
DialogLayer::~DialogLayer(){}
bool DialogLayer::init(){
    if (CCLayer::init()) {
        return true;
    }else{
        return false;
    }
}
void DialogLayer::showAddGold(CCPoint location,int goldNum){
    CCLabelTTF* goldTTF = CCLabelTTF::create("12", "", 30);
    goldTTF->setPosition(location);
    goldTTF->setScale(0.5);
    addChild(goldTTF);
}