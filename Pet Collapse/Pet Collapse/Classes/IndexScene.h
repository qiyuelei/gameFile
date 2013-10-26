//
//  IndexScene.h
//  Pet Collapse
//
//  Created by long shenghua on 13-10-23.
//
//

#ifndef __Pet_Collapse__IndexScene__
#define __Pet_Collapse__IndexScene__

#include "cocos2d.h"
#include "cocos-ext.h"
#include "stdcheaders.h"
#include "GameScene.h"
USING_NS_CC;
USING_NS_CC_EXT;
class IndexScene:public CCLayer {
    
public:
    IndexScene();
    ~IndexScene();
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(IndexScene);
    
    int bestScore;
    int curScore;
    int TotalGold;
    int curGold;
    int _heartNum;
    int heartTime;
    CCLabelTTF* HeartTTF;
    CCProgressTimer* ct;
    CCSpriteBatchNode* _heartBatch;
    CCArray* _heartArray;
    void update();
    void updateHeartTime();
    void setHeartTimer(int dt);
    void initData();
    void initLayer();
    void initUI();
    void initMenu();
    void pPlayCallBack();
    void PlayScene();
    void pSoundControlCallBack();
    void showprogessBar();
    void showHeart(int Heart);
    void checkScoreAndGold();
    void setScoreTTF();
    void setGoldTTF();
    
    CCMenu *pMenu;
    
    CCNode* gameOverNode;
    CCLabelTTF* curScoreTTF;
    CCLabelTTF* curGoldTTF;
    void initGameOver();
    CCLabelTTF* GoldTTF;
    CCLabelTTF* ScoreTTF;
    CCLabelTTF* HearNumTTF;
    bool isNewGame;
    
    void moveGameOverNode();
    void jiafenFinsh(CCLabelTTF* pSender);

};

#endif /* defined(__Pet_Collapse__IndexScene__) */
