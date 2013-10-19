//
//  test.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-12.
//
//

#ifndef __Fruit_Pop__test__
#define __Fruit_Pop__test__

#include <cocos2d.h>
#include <cocos-ext.h>
#include <string>
USING_NS_CC;
using namespace std;

class Test:public CCLayer {
    
public:
    Test();
    ~Test();
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(Test);
};

#endif /* defined(__Fruit_Pop__test__) */
