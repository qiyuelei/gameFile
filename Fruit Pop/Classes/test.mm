//
//  test.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-12.
//
//

#include "test.h"
Test::Test(){}
Test::~Test(){}
CCScene* Test::scene(){
    CCScene* scene = CCScene::create();
    scene->addChild(Test::create());
    return scene;
}
bool Test::init(){
    if (CCLayer::init()) {
        
    NSString* str =  NSLocalizedString(@"welcome", nil);
        NSLog(@"ssdf:%@",str);
     const char *str_char = [str UTF8String];
        CCLabelTTF* ttf = CCLabelTTF::create(str_char, "", 32);
        ttf->setPosition(ccp(100, 100));
        addChild(ttf);
        return true;
    }else{
        return false;
    }

}