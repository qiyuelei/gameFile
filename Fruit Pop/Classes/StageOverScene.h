//
//  StageOverScene.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-10.
//
//

#ifndef __Fruit_Pop__StageOverScene__
#define __Fruit_Pop__StageOverScene__

#include "MHeader.h"

class StageOverScene:public CCLayer {
    
public:
    StageOverScene();
    ~StageOverScene();
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(StageOverScene);
    
    CCLabelTTF* scoreTTF;
    CCLabelTTF* getScoreTTF();
};

#endif /* defined(__Fruit_Pop__StageOverScene__) */
