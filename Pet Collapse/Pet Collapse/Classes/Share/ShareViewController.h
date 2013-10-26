//
//  ShareViewController.h
//  Fruit Pop
//
//  Created by long shenghua on 13-10-18.
//
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController
-(void)shareMothed;
- (void)shareToSinaWeiboClickHandler;
- (void)shareToFacebookClickHandler:(int)bestScore;
-(void)loginSina;
- (void)initializePlat;
@end