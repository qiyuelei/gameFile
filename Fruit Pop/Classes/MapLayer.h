//
//  MapLayer.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-8.
//
//

#ifndef __Fruit_Pop__MapLayer__
#define __Fruit_Pop__MapLayer__

#include "MHeader.h"
#include "Paopao.h"
#include "ParticleSysLayer.h"
#include "Language.h"

class MapLayer:public CCLayer {
    
public:
    MapLayer();
    ~MapLayer();
    virtual bool init();
    CREATE_FUNC(MapLayer);
    
    Language* languageLayer;
    int LanguageType;
    
    CCSpriteBatchNode* _paopaoBatchNode;
    CCSpriteBatchNode* getpaopaoBatchNode();
    void initMap();
    void initBgUnit();

    void addNewPaopao(CCPoint targetPoint,int rowMoveNum);
    
    CCArray* _paopaoArray;
    CCArray* getPaopaoArray();
    
    //timeProgress
    CCTMXObjectGroup* _pgroupBgUnit;
    float ct_time;
    void initTimeProgress(int _curGameTime);
    CCProgressTimer* ct;
    CCLabelTTF* scoreTTF;
    CCLabelTTF* goldTTF;
    CCLabelTTF* getgoldTTF();
    CCLabelTTF* getscoreTTF();
    CCLabelTTF* timeTTF;
    void update(int _curGameTime,float _ct_time);
    void showTime(time_t _timep);
    //int curGameTime;
    //float curGameTimeSpan;
    
    //
    //process touch
    //void processFrTouch(CCPoint location);
    float MinX = 500;
    float MinY = 500;
    float MaxX = 0;
    float MaxY = 0;
    void addRowMoveNumToPaopao();
    void movePaopao();
    void movePaopaoFrUp();
    ParticleSysLayer* particleSysLayer;
    
    //Line
    void addLine(CCPoint LineStartPoint,CCPoint LineEndPoint);
    void loadLine(int LineType,CCPoint Linepoint);
    CCSpriteBatchNode* _LineBatchNode;
    CCSpriteBatchNode* getselPaopaoBatchNode();
    void initLastOnePaopao();
    void removeLineOne();
    void removeLineAll();
    
    //processEquipment
    bool _EquipmentWugui;
    bool _EquipmentZhadan;
    bool _EquipmentZhongbiao;
    
    void initData();
    void initEquipment();
    void initWugui();
    void initZhadan();
    void initZhongbiao();
    void initGoldBg();
    void addEquipmentBg(int _equipmentType);
    
    int _randGoldBgId;
    int _randWuguiId;
    int _randZhadanId;
    int _randZhongbiaoId;
    
    //show
   void showAddGold(CCPoint location,int goldNum);
    void showAddHightGold(int goldNum);
    void showTTFRemove(CCLabelTTF* pSender);
    void  showTimeOver();
    CCSprite* timeOverBg;
    void timeOverBgShow();
    void timeOverBgHide();
    
    //partical
    void playParticalLineLight(int particalType,CCPoint location);
    void playParticalExplosion(int particalType,CCPoint location);    
};

#endif /* defined(__Fruit_Pop__MapLayer__) */
