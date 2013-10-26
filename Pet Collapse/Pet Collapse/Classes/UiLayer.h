//
//  UiLayer.h
//  Pet Collapse
//
//  Created by long shenghua on 13-10-21.
//
//

#ifndef __Pet_Collapse__UiLayer__
#define __Pet_Collapse__UiLayer__

#include "GHeader.h"
#include "PaoPao.h"

class UiLayer:public CCLayer {
    
public:
    UiLayer();
    ~UiLayer();
    virtual bool init();
    CREATE_FUNC(UiLayer);
    
    CCSize winSize;
    CCTMXObjectGroup* _pgroupPaopao;
    CCTMXObjectGroup* _pgroupFoot;
    CCArray* _mapPaopaoArray;
    CCArray* getMapPaopaoArray();
    CCArray* _footPaopaoArray;
    CCArray* getFootPaopaoArray();
    CCSpriteBatchNode* _mSpriteBatch;
    CCArray* _objFootArray;
    LanguageLayer* languageLayer;
    
    CCLabelTTF* StartNum;
    CCLabelTTF* getStartNum();
    CCLabelTTF* scoreTTF;
    CCLabelTTF* getScoreTTF();
    CCLabelTTF* goldTTF;
    CCLabelTTF* getgoldTTF();
    
    CCProgressTimer* ct;
    void setct_time(int ct_time);
    
    int footID;
    int curTimePos;
    void initConfigDate();
    void initMap();
    void initMenu();
    void initPaopao();
    void addPaopao(CCPoint location,int PosType);
    void movePaopao();
    //void movePaopaoToUp();
    
    void update();
    void gameLogic(int _curTimePos);
    
  void showTime(time_t _timep);
    CCLabelTTF* gameTimeTTF;
    CCLabelTTF* getgameTimeTTF();
    void setgameTimeTTFCor();
    void showprogessBar();
    void showStartNum();
    void hideStartNum();
    bool IsGold();
    bool IsZhaDan();
    
    void showFenshu(int FenshuType,int _Fenshu,CCPoint location);
    void showFenshuFinish(CCLabelTTF* pSender);
    ParticleSysLayer* particleSysLayer;
    void playParticalLineLight(int particalType,CCPoint location);
    
};

#endif /* defined(__Pet_Collapse__UiLayer__) */
