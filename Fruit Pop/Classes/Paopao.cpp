//
//  Paopao.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-8.
//
//

#include "Paopao.h"
Paopao::Paopao(){}
Paopao::~Paopao(){}
NormalPaopao::NormalPaopao(){}
NormalPaopao::~NormalPaopao(){}
NormalPaopao* NormalPaopao::createNormalPaopao(CCTexture2D* PaopaoImg,int PaopaoType,int checkStat,int rowMoveNum){

    NormalPaopao* _paopao = new NormalPaopao();
    if (_paopao->initWithTexture(PaopaoImg, CCRectMake(100 * PaopaoType,100 * 0,100,100))) {
        
   // }
    //if (_paopao->initWithTexture(PaopaoImg, CCRect(64*PaopaoType, 0, 64, 64), true)) {
        _paopao->PaopaoType = PaopaoType;
       // _paopao->checkStat = checkStat;
        _paopao->checkStat = -1;
        _paopao->rowMoveNum = rowMoveNum;
        _paopao->special = 0;
        
    }
    return _paopao;
}