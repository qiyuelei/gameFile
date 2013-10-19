//
//  EquipMentScene.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-11.
//
//

#ifndef __Fruit_Pop__EquipMentScene__
#define __Fruit_Pop__EquipMentScene__

#include "cocos2d.h"
#include "cocos-ext.h"
USING_NS_CC;

class EquipMentScene:public CCLayer {
    
public:
    EquipMentScene();
    ~EquipMentScene();
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(EquipMentScene);
};

#endif /* defined(__Fruit_Pop__EquipMentScene__) */
