//
//  GameScene.h
//  Pet Collapse
//
//  Created by long shenghua on 13-10-21.
//
//

#ifndef __Pet_Collapse__GameScene__
#define __Pet_Collapse__GameScene__

#include "GHeader.h"
#include "UiLayer.h"
#include "FirstScene.h"
#include "IndexScene.h"
#include "Test.h"


class GameScene:public CCLayer {
    
public:
    GameScene();
    ~GameScene();
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(GameScene);
    
    SoundLayer* soundLayer;
    CCArray* _SelPaopaoArray;
    bool curGameStat;
    int gameTime;
    int gameTimeSpan;
    int ct_Time;
    int curBaojinStat;
    int curTimePos;
    int curGold;
    int curScore;
    int BestScore;
    int TotalGold;
    int statNum;
    int curClickStat;
    UiLayer* uiLayer;
    CCNode *menuNode;
    CCSize winSize;
    
    float curUpdateSpeed;
    void setUpdateTime();
    void setgameTimeBaojin();
    void gameTimeDaoJiShi();
    void initData();
    void initLayer();
    void initMenu();
    void initLogic();
    void showStarNum();
    void hidestartNum(CCLabelTTF* pSender);
    void puaseBtnCallBack(CCMenuItemImage* pSender);

    void update();
    virtual void ccTouchesEnded(CCSet *touches,CCEvent *event);
    void FindPaopaoToSel(CCPoint location,int _PaopaoType);
    void FindPaopaoToSel_R(CCPoint location,int _PaopaoType);
    void FindPaopaoToSel_D(CCPoint location,int _PaopaoType);
    void FindPaopaoToSel_L(CCPoint location,int _PaopaoType);
    void FindPaopaoToSel_U(CCPoint location,int _PaopaoType);
    void ClearSelPaopao();
    void AddMarkToPaopaoX();
    void AddMarkToPaopaoY(int ColNum);
    void MovePaopao();
    void movePaopaoToUp();
    void initPaopaoAll();
    void showGameOver();
    void AddBaojin(float rowX);
    void showBaojinPaopao();
    void moveBaojin(float rowX);
    
    void processZhadan(CCPoint location);
    
    void openScene();
    
};

#endif /* defined(__Pet_Collapse__GameScene__) */
