//
//  SoundLayer.cpp
//  popStar
//
//  Created by long shenghua on 13-9-18.
//
//

#include "SoundLayer.h"
SoundLayer::SoundLayer(){}
SoundLayer::~SoundLayer(){}

void SoundLayer::playBgSound(int audioType){
    if (CCUserDefault::sharedUserDefault()->getIntegerForKey("backGroundMusic",1)==1) {
        
        switch (audioType) {
            case 1:
              //  SimpleAudioEngine::sharedEngine()->setBackgroundMusicVolume(0.2);
                CCLog("bg");
               SimpleAudioEngine::sharedEngine()->playBackgroundMusic("music1.caf", true);
                //SimpleAudioEngine::sharedEngine()->playEffect("bg.caf");
                break;
            case 2:
              //  SimpleAudioEngine::sharedEngine()->playEffect("xiaopaopao.wav");
                break;
            case 3:
              //  SimpleAudioEngine::sharedEngine()->playEffect("xiaopaopao.wav");
                break;
            case 4:
             //   SimpleAudioEngine::sharedEngine()->playEffect("xiaopaopao.wav");
                break;
            case 5:
              //  SimpleAudioEngine::sharedEngine()->playEffect("xiaopaopao.wav");
                break;
            case 6:
              //  SimpleAudioEngine::sharedEngine()->playEffect("xiaopaopao.wav");
                break;
            case 7:
               // SimpleAudioEngine::sharedEngine()->playEffect("xiaopaopao.wav");
                break;
            case 8:
               // SimpleAudioEngine::sharedEngine()->playEffect("xiaopaopao.wav");
                break;
            default:
                break;
        }
        
    }

}
void SoundLayer::playEffect(int audioType){
    if (CCUserDefault::sharedUserDefault()->getIntegerForKey("soundMusic",1)==1) {
        
        switch (audioType) {
            case 1:
              //  SimpleAudioEngine::sharedEngine()->setEffectsVolume(1);
               SimpleAudioEngine::sharedEngine()->playEffect("water_drip_009.caf");
                break;
            case 2:
              //  SimpleAudioEngine::sharedEngine()->playEffect("good.caf");
                SimpleAudioEngine::sharedEngine()->playEffect("water_drip.caf");
                break;
            case 3:
                SimpleAudioEngine::sharedEngine()->playEffect("click.caf");
                break;
            case 4:
                SimpleAudioEngine::sharedEngine()->playEffect("gaofen.caf");
                break;
            case 5:
              //  SimpleAudioEngine::sharedEngine()->setEffectsVolume(0.1);
                SimpleAudioEngine::sharedEngine()->playEffect("gameover.caf");
                //SimpleAudioEngine::sharedEngine()->setEffectsVolume(1);
                break;
            case 6:
            //    SimpleAudioEngine::sharedEngine()->setEffectsVolume(0.1);
               SimpleAudioEngine::sharedEngine()->playEffect("clearOfClick.caf");
               // SimpleAudioEngine::sharedEngine()->setEffectsVolume(1);
                break;
            case 7:
                SimpleAudioEngine::sharedEngine()->playEffect("zhadan.caf");
                break;
            case 8:
               SimpleAudioEngine::sharedEngine()->playEffect("voice12.caf");
                break;
            case 9:
                SimpleAudioEngine::sharedEngine()->playEffect("overTime.caf");
                break;
            default:
                break;
        }
        
    }


}
void SoundLayer::stopBgSound(int audioType){}
void SoundLayer::stopEffect(int audioType){}