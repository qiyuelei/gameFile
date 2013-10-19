//
//  InAppPurchaseManager.m
//  popStar
//
//  Created by long shenghua on 13-9-25.
//
//

#import "InAppPurchaseManager.h"
//#define kInAppPurchaseProUpgradeProductId @"com.long.popStar.MagicPopx2"


@implementation InAppPurchaseManager
- (void)requestProUpgradeProductData
{
   // NSSet *productIdentifiers = [NSSet setWithObject:@"com.long.popStar.MagicPopx2" ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    proUpgradeProduct = [products count] == 1 ? [[products firstObject] retain] : nil;
    if (proUpgradeProduct)
    {
       // NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        //NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        //NSLog(@"Product price: %@" , proUpgradeProduct.price);
        //NSLog(@"Product priceLocale: %@" , proUpgradeProduct.priceLocale);
       // NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
        //productPrice = proUpgradeProduct.price;
       // productPrice = [proUpgradeProduct.price floatValue];
       // NSLog(@"price :%0.2f",productPrice);
        
        //NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
       // [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
       // [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
       // [numberFormatter setLocale:proUpgradeProduct.priceLocale];
       // formattedString = [numberFormatter stringFromNumber:proUpgradeProduct.price];
        //NSLog(@"price %@",proUpgradeProduct.price);
        //[numberFormatter release];
        //  NSLog(@"formattedString:%@",formattedString);
       // priceLocaleCharValue = [formattedString cStringUsingEncoding:NSASCIIStringEncoding];
      //  NSLog(@"priceLocaleCharValue:%s",priceLocaleCharValue);
       // priceLocale = [formattedString UTF8String];
        //[priceLocale release];
       // NSLog(@"priceLocale:%s",priceLocale);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    //NSLog(@"finishTranscation");
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
       // NSLog(@"wasSuccessful");
        
        purchaseStat = _productID;
          //  NSLog(@"puchaseStat:%i",purchaseStat);
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        //[SaveDefaults setInteger:productID forKey:@"purchaseStat"];
    }
    else
    {
        NSLog(@"purchase Failed");
        purchaseStat = -1;
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                purchaseStat = -1;
                NSLog(@"stateFailed");
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"staterestored");
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}
//
//request Product
//
- (void)requestProduct:(int)productID{
        proUpgradeProduct = NULL;
    switch (productID) {
        case 0:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.20000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.20000Coins";
            break;
        case 1:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.50000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.50000Coins";
            break;
        case 2:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.135000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.135000Coins";
            break;
        case 3:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.300000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.300000Coins";
            break;
        case 4:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.700000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.700000Coins";
            break;
        default:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.700000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.700000Coins";
            break;
    }
    productPrice = 0;
    priceLocaleCharValue = NULL;
    //priceLocale = [[NSString alloc] init];
    //priceLocale = NULL;
    //formattedString = [[NSString alloc] init];
    formattedString = NULL;

   // priceLocale = NULL;
    //formattedString = NULL;
    [self loadStore];
}
- (float)responPrice{
    return productPrice;
}
- (const char)responPriceLocale{
    NSLog(@"responPriceLocale:%s",priceLocale);
    return priceLocale;
}
- (NSString *)responPriceLocaleNSString{
    return formattedString;
}
- (char *)responPriceLocaleChar{
    return priceLocaleCharValue;
}
- (SKProduct *)resPonproUpgradeProduct{
    return proUpgradeProduct;
}
//
//purchase Product
//
- (void)purchaseProduct:(int)productID{
   // NSLog(@"puchaseStat:%i",productID);
    switch (productID) {
        case 0:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.20000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.20000Coins";
            break;
        case 1:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.50000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.50000Coins";
            break;
        case 2:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.135000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.135000Coins";
            break;
        case 3:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.300000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.300000Coins";
            break;
        case 4:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.700000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.700000Coins";
            break;
        default:
            productIdentifiers = [NSSet setWithObject:@"com.Long.FruitPop.700000Coins"];
            kInAppPurchaseProUpgradeProductId = @"com.Long.FruitPop.700000Coins";
            break;
    }
    //NSLog(@"id:%i",productID);
    _productID = productID;
    productPrice = 0;
   // priceLocale = NULL;
    purchaseStat = -1001;
    [self loadStore];
    if ([self canMakePurchases] == true) {
        [self purchaseProUpgrade];
    }
}
- (int)responPurchaseStat{
   // NSLog(@"puchaseStat:%i",purchaseStat);
    return purchaseStat;
}

-(void)showPurchaseSecess{
    NSString* _title = NSLocalizedString(@"Thank You",nil);
    NSString* _message = NSLocalizedString(@"Your purchase was successful",nil);
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:_title
                                                       message:_message
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"OK",nil)otherButtonTitles:nil];
    
    [alerView show];
    [alerView release];
}
@end
