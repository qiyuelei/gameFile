//
//  ParticleSysLayer.cpp
//  popStar
//
//  Created by long shenghua on 13-9-30.
//
//

#include "ParticleSysLayer.h"
ParticleSysLayer::ParticleSysLayer(){
    m_particleBatchNode = CCParticleBatchNode::create("FallingLeaves.png");
//    m_WaterTweenBatchNode = CCParticleBatchNode::create("WaterTween.png");
    CC_SAFE_RETAIN(m_particleBatchNode);
//    CC_SAFE_RETAIN(m_WaterTweenBatchNode);
    
   // m_LineLightBatchNode = CCParticleBatchNode::create("lineLight01.png");
    m_LineLightBatchNode = CCParticleBatchNode::create("lineLight01.png");
    CC_SAFE_RETAIN(m_LineLightBatchNode);
    
    m_explosionBatchNode = CCParticleBatchNode::create("explosion.png");
    CC_SAFE_RETAIN(m_explosionBatchNode);
}
ParticleSysLayer::~ParticleSysLayer(){
    CC_SAFE_RELEASE_NULL(m_particleBatchNode);
    CC_SAFE_RELEASE_NULL(m_LineLightBatchNode);
    CC_SAFE_RELEASE_NULL(m_explosionBatchNode);

}
bool ParticleSysLayer::init(){
    if (CCLayer::init()) {
        
        
       // CCSprite* sp = CCSprite::create("Icon.png");
      // sp->setPosition(ccp(100, 100));
       // addChild(sp);
        
        this->addChild(m_LineLightBatchNode);
        this->addChild(m_particleBatchNode);
        this->addChild(m_explosionBatchNode);
       // this->addChild(m_chargeBatchNode);
        //this->addChild(m_nebiaBatchNode);
       // this->addChild(m_magicBallBatchNode);
        
        //CCParticleBatchNode* _pp = CCParticleBatchNode::create("LineLight01.plist");
       // CCParticleSystemQuad* mParticle = CCParticleSystemQuad::create("LineLight01.plist");
        
      //  mParticle->setPosition(CCPointZero);
       // mParticle->setAutoRemoveOnFinish(true);
       // m_particleBatchNode->addChild(mParticle);
        
       // this->addChild(_pp);
       // _pp->addChild(_psq);
        
        return true;
    }else{
        return false;
    }
}
void ParticleSysLayer::ParticlePlay(int ParticleType, cocos2d::CCPoint location){

        //CCLog("particletype:%i",ParticleType);
        CCParticleSystemQuad* mParticle = CCParticleSystemQuad::create("FallingLeaves.plist");
        mParticle->setPosition(location);
        mParticle->setAutoRemoveOnFinish(true);
        m_particleBatchNode->addChild(mParticle);
    

    //mParticle->setPosVar(ccp(0, 200));
    //mParticle->setPosVar(ccp(200, 0));

    
}
//void ParticleSysLayer::WaterTweenPlay(int paopaoType, cocos2d::CCPoint location){
//
//    CCParticleSystemQuad* mParticle = CCParticleSystemQuad::create("WaterTween.plist");
//   // mParticle->setTexture(m_WaterTweenBatchNode->getTexture());
//    //mParticle->setTextureWithRect(m_WaterTweenBatchNode->getTexture(), CCRectMake(64*paopaoType, 0, 64, 64));
//    mParticle->setPosition(location);
//    //mParticle->setDuration(2.0f);
//    mParticle->setAutoRemoveOnFinish(true);
//    m_WaterTweenBatchNode->addChild(mParticle);
//}
//void ParticleSysLayer::ChargePlay(int paopaoType, cocos2d::CCPoint location){
//   // CCLog("paopaoType:%i",paopaoType);
//    CCParticleSystemQuad* mParticle = CCParticleSystemQuad::create("Charge.plist");
//    mParticle->setTextureWithRect(m_chargeBatchNode->getTexture(), CCRectMake(31*paopaoType, 0, 31, 31));
//    mParticle->setPosition(location);
//    //mParticle->setDuration(2.0f);
//    mParticle->setAutoRemoveOnFinish(true);
//    m_chargeBatchNode->addChild(mParticle);
//}
//void ParticleSysLayer::NebiaPlay(int paopaoType, cocos2d::CCPoint location){
//    
//    CCParticleSystemQuad* mParticle = CCParticleSystemQuad::create("Nebia.plist");
//    // mParticle->setTextureWithRect(m_chargeBatchNode->getTexture(), CCRectMake(0, 0, 64, 64));
//    mParticle->setPosition(location);
//    mParticle->setAutoRemoveOnFinish(true);
//    m_nebiaBatchNode->addChild(mParticle);
//}
//void ParticleSysLayer::MagicBallPlay(int paopaoType, cocos2d::CCPoint location){
//    
//    CCParticleSystemQuad* mParticle = CCParticleSystemQuad::create("MagicBall.plist");
//    // mParticle->setTextureWithRect(m_chargeBatchNode->getTexture(), CCRectMake(0, 0, 64, 64));
//    mParticle->setPosition(location);
//    mParticle->setAutoRemoveOnFinish(true);
//    mParticle->setZOrder(1);
//    m_magicBallBatchNode->addChild(mParticle);
//}
void ParticleSysLayer::LineLightPlay(int paopaoType,CCPoint location){

    CCParticleSystemQuad* mParticle = CCParticleSystemQuad::create("lineLight01.plist");
    mParticle->setPosition(location);
    mParticle->setAutoRemoveOnFinish(true);
    mParticle->setDuration(0.2);
    if (paopaoType == 1) {
        mParticle->setPosVar(ccp(5, 180));
        
    }else{
        mParticle->setPosVar(ccp(150, 5));
    }
    m_LineLightBatchNode->addChild(mParticle);
}
void ParticleSysLayer::ExplosionPlay(int paopaoType, cocos2d::CCPoint location){
    CCParticleSystemQuad* mParticle = CCParticleSystemQuad::create("explosion.plist");
    mParticle->setPosition(location);
    mParticle->setAutoRemoveOnFinish(true);
    // mParticle->setDuration(-1);
    //    if (paopaoType == 1) {
//        mParticle->setPosVar(ccp(5, 180));
//        
//    }else{
//        mParticle->setPosVar(ccp(150, 5));
//    }
    m_explosionBatchNode->addChild(mParticle);
}