//
//  Test.h
//  Pet Collapse
//
//  Created by long shenghua on 13-10-23.
//
//

#ifndef __Pet_Collapse__Test__
#define __Pet_Collapse__Test__

#include "cocos2d.h"
USING_NS_CC;
class Test:public CCLayer {
    
public:
    Test();
    ~Test();
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(Test);
    
    void initData();
};


#endif /* defined(__Pet_Collapse__Test__) */
