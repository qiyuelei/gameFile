//
//  ChannelClass.cpp
//  Fruit Pop
//
//  Created by long shenghua on 13-10-18.
//
//

#include "ChannelClass.h"
#include "ShareViewController.h"

void shareMothed()
{
    ShareViewController* share = [[ShareViewController alloc]init];
    printf("ffff\n");
    [share shareToSinaWeiboClickHandler];
}


void ChannelClass::channel()
{
    shareMothed();
}
void shareFacebookothed(int _bestScore){
    ShareViewController* share = [[ShareViewController alloc]init];
    printf("ffff\n");
    [share shareToFacebookClickHandler:_bestScore];
}
void ChannelClass::ShareFaceBook(int bestScore){
    shareFacebookothed(bestScore);
}
