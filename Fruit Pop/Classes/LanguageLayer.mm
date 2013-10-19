//
//  LanguageLayer.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-14.
//
//

#include "LanguageLayer.h"

void LanguageLayer::test(){
    CCLog("test");
}
const char* LanguageLayer::getChar(char* ttfName){
    NSString* _ttfName = [NSString stringWithUTF8String:ttfName];
    //NSString* str =  NSLocalizedString(@"welcome", nil);
    NSString* str =  NSLocalizedString(_ttfName, nil);
  //  NSLog(@"ssdf:%@",str);
    const char *str_char = [str UTF8String];
    return str_char;
}