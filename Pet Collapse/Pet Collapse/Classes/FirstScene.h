//
//  FirstScene.h
//  Pet Collapse
//
//  Created by long shenghua on 13-10-23.
//
//

#ifndef __Pet_Collapse__FirstScene__
#define __Pet_Collapse__FirstScene__

//#include "cocos2d.h"
//#include "cocos-ext.h"
//#include "stdcheaders.h"
//#include "GameScene.h"
//USING_NS_CC;
//USING_NS_CC_EXT;
#include "GHeader.h"
#include "GameScene.h"
#include "ChannelClass.h"


class FirstScene:public CCLayer {
    
public:
    FirstScene();
    ~FirstScene();
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(FirstScene);

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
    
    LanguageLayer* languageLayer;
    SoundLayer* soundLayer;
    void update();
    void updateHeartTime();
    void setHeartTimer(int dt);
    void initData();
    void initLayer();
    void initUI();
    void initMenu();
    void pPlayCallBack();
    void pGameTopCallBack();
    void pTestCallBack();
    void PlayScene();
    void pSoundControlCallBack();
    void showprogessBar();
    void showHeart(int Heart);
    void checkScoreAndGold();
    void setScoreTTF();
    void setGoldTTF();
    
    CCMenu *pMenu;
    void facebookBtnCallBack();
    void menuBackGroundMusicback(CCMenuItemSprite* pSender);
    CCMenuItemToggle* pBgAudio;
    CCMenuItemToggle* pEfAudio;
    CCSize winSize;
    CCSpriteBatchNode* _soundBg;
    
    CCNode* gameOverNode;
    CCLabelTTF* curScoreTTF;
    CCLabelTTF* curGoldTTF;
    void initGameOver();
    CCLabelTTF* GoldTTF;
    CCLabelTTF* ScoreTTF;
    CCLabelTTF* HearNumTTF;
    bool isNewGame;
    bool isPurchasing;
    
    void moveGameOverNode();
    void jiafenFinsh(CCLabelTTF* pSender);
    
    void ReqPurchase(int ProductId);
    void ResPurchase();
    
    void reportScoreToGameCenter(int _BestScore);
    
};

#endif /* defined(__Pet_Collapse__FirstScene__) */
