//
//  DialogLayer.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-14.
//
//

#ifndef __Fruit_Pop__DialogLayer__
#define __Fruit_Pop__DialogLayer__

#include "MHeader.h"

class DialogLayer:public CCLayer {
    
public:
    DialogLayer();
    ~DialogLayer();
    virtual bool init();
    CREATE_FUNC(DialogLayer);
    
    void showAddGold(CCPoint location,int goldNum);
};

#endif /* defined(__Fruit_Pop__DialogLayer__) */
