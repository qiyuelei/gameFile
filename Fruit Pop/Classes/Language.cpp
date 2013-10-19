//
//  Language.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-11.
//
//

#include "Language.h"

Language::Language(){
    languageDIC = CCDictionary::createWithContentsOfFile("Language.plist");
    languageContens = (CCArray*)languageDIC->objectForKey("contents");
    CC_SAFE_RETAIN(languageContens);
}
Language::~Language(){
    CC_SAFE_RELEASE_NULL(languageContens);
}
void Language::loadConfig(int LanguageType){

    switch (LanguageType) {
        case 1:
            languageUser = (CCDictionary*)languageDIC->objectForKey("Chinese");
            break;
        default:
            languageUser = (CCDictionary*)languageDIC->objectForKey("English");
            break;
    }

}
char* Language::getlabelChar(char* labelName,int LanguageType){
    loadConfig(LanguageType);
    char* labelChar = (char*)languageUser->valueForKey(labelName)->getCString();
   // CCLog("lo:%s,labelChar:%s,LanguageType:%i",labelName,labelChar,LanguageType);
    return labelChar;
}
CCArray* Language::getlanguageContens(){
    return languageContens;
}
CCDictionary* Language::getlanguageUser(int LanguageType){
    return languageUser;
}
void Language::test(){
    CCLog("test");
}