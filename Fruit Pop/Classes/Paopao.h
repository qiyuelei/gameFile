//
//  Paopao.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-8.
//
//

#ifndef __Fruit_Pop__Paopao__
#define __Fruit_Pop__Paopao__

#include "MHeader.h"

class Paopao:public CCSprite {
    
public:
    Paopao();
    ~Paopao();
    
    int PaopaoType;
    int checkStat;
    int rowMoveNum;
    int special;
};

class NormalPaopao:public Paopao {
    
public:
    NormalPaopao();
    ~NormalPaopao();
    static NormalPaopao* createNormalPaopao(CCTexture2D* PaopaoImg,int PaopaoType,int checkStat,int rowMoveNum);
};

#endif /* defined(__Fruit_Pop__Paopao__) */
