//
//  Language.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-11.
//
//

#ifndef __Fruit_Pop__Language__
#define __Fruit_Pop__Language__

#include "MHeader.h"
#include "stdcheaders.h"

using namespace std;

class Language{
    
public:
    Language();
    ~Language();
  //  virtual bool init();
  //  CREATE_FUNC(Language);
    
    CCDictionary* languageDIC;
    CCDictionary* languageDeafault;
    CCDictionary* languageUser;
    CCDictionary* getlanguageUser(int LanguageType);
    
    CCArray* languageContens;
    CCArray* getlanguageContens();
    
    void loadConfig(int LanguageType);
    char* getlabelChar(char* labelName,int LanguageType);
    void test();
};

#endif /* defined(__Fruit_Pop__Language__) */
