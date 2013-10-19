//
//  GameScene.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-8.
//
//

#ifndef __Fruit_Pop__GameScene__
#define __Fruit_Pop__GameScene__

#include "MHeader.h"
#include "MapLayer.h"
#include "StageOverScene.h"
#include "FirstScene.h"
#include "LanguageLayer.h"
#include "DialogLayer.h"
#include "SoundLayer.h"
#include "ParticleSysLayer.h"

class GameScene:public CCLayer {
    
public:
    GameScene();
    ~GameScene();
    virtual bool init();
    static CCScene* scene();
    CREATE_FUNC(GameScene);
    
    int curClickStat;
    SoundLayer* soundLayer;
    LanguageLayer* languageLayer;
   // ParticleSysLayer* particleSysLayer;
    void loadconfig();
    
    void addRowMoveNumToPaopao();
    void movePaopao();
    
    CCSize winSize;
    bool isLineStartPoint;
    int curPaopaoType;
    int curCheckNum;
    int curScore = 0;
    int curGold = 0;
    
    CCPoint LineStartPoint;
    CCPoint LineendPoint;
    CCPoint LineLastPoint;
    MapLayer* mapLayer;
    CCArray* _selPaopaoArray;
    CCArray* _specielPaopaoArray;
    
    bool gameStat;
    CCNode* menuNode;
    void pauseBtnCallBack();
    void menuBtnCallBack(CCMenuItemImage* menuBtn);
    void moveMenuNode();
    void test();
    void testMove();
    void update();
    void baojin();
    void GameLogic();
    int curGameTime;
    float updateTime;
    float ct_time = 100;
    float ct_timeSpan;
    void showStageOver();
    void zhadanProcess(CCPoint location,int _curcheckNum);
    CCPointArray* _paopaoPointArray;
    void loadNewPaopao();
    
    //showGameover
    void showGameover();
    CCNode* GameoverNode;
    void showOverShare();
private:
    void loadLayer();
    void loadMenu();


    ////node process
    void isAddOrRemovePaoao(CCPoint pTouch);
    
  ////cctouch
    virtual bool ccTouchBegan(CCTouch* touch,CCEvent* event);
    virtual void ccTouchMoved(CCTouch* touch,CCEvent* event);
    virtual void ccTouchEnded(CCTouch* touch,CCEvent* event);
    void initPaopaoAll();
    void clearSelPaopao(int clearType);
    void removePaopaoFrSel(int _curCheckNum);
    void processSpecialPaopao(CCPoint pTouch);
    void caiseFruitProcess(CCPoint pTouch);
    
    virtual void onEnter();
    virtual void onExit();
};

#endif /* defined(__Fruit_Pop__GameScene__) */
