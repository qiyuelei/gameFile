//
//  ParticleSysLayer.h
//  popStar
//
//  Created by long shenghua on 13-9-30.
//
//

#ifndef __popStar__ParticleSysLayer__
#define __popStar__ParticleSysLayer__

#include "cocos2d.h"
#include "stdcheaders.h"
USING_NS_CC;
using namespace std;

class ParticleSysLayer:public CCLayer {
    
public:
    ParticleSysLayer();
    ~ParticleSysLayer();
    virtual bool init();
    CREATE_FUNC(ParticleSysLayer);
    
    CCParticleBatchNode* m_LineLightBatchNode;
    void LineLightPlay(int paopaoType,CCPoint location);
    
    CCParticleBatchNode* m_particleBatchNode;
    CCParticleBatchNode* m_ExplodingRingBatchNode;
//    CCParticleBatchNode* m_chargeBatchNode;
//    CCParticleBatchNode* m_nebiaBatchNode;
//    CCParticleBatchNode* m_magicBallBatchNode;
//
    void ExplodingRingPlay(cocos2d::CCPoint location);
    void ParticlePlay(int ParticleType,CCPoint location);
//    void TomatoPlay(int paopaoType,CCPoint location);
//    void ChargePlay(int paopaoType,CCPoint location);
//    void NebiaPlay(int paopaoType,CCPoint location);
//    void MagicBallPlay(int paopaoType,CCPoint location);
    
    CCParticleBatchNode* m_explosionBatchNode;
    void ExplosionPlay(int paopaoType,CCPoint location);
};

#endif /* defined(__popStar__ParticleSysLayer__) */
