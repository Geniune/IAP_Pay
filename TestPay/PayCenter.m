//
//  PayCenter.m
//  TestPay
//
//  Created by Apple on 2019/10/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "PayCenter.h"
#import <StoreKit/StoreKit.h>

/**
 *  单例宏方法
 *
 *  @param block
 *
 *  @return 返回单例
 */
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

@interface PayCenter () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end

@implementation PayCenter

//https://www.jianshu.com/p/bfa265971ce5

+ (PayCenter *)sharedInstance{
    //初始化单例类
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[PayCenter alloc] init];
    });
}

- (id)init{
    self = [super init];
    if (self) {
        
        [self startManager];
    }
    
    return self;
}

- (void)startManager { //开启监听
    /*
     在程序启动时，设置监听，监听是否有未完成订单，有的话恢复订单。
     */
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)stopManager{ //移除监听
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)payItem:(NSString *)IAP_ID{
    
    //检查用户允许app内购
    if([SKPaymentQueue canMakePayments]){
        
        if(IAP_ID && IAP_ID.length > 0){
            
            NSArray *product = [[NSArray alloc] initWithObjects:IAP_ID, nil];
            NSSet *nsSet = [NSSet setWithArray:product];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsSet];
            request.delegate = self;
            [request start];
        }else{
           //商品为空
        }
    }else{
        //没有权限
    }
}

#pragma mark SKProductsRequestDelegate 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if (product.count == 0) {
        //无法获取商品信息
    } else {
        //发起购买请求
        SKPayment * payment = [SKPayment paymentWithProduct:product[0]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark SKProductsRequestDelegate 查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    //查询失败: [error localizedDescription];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        ///购买失败
    } else {
        //用户取消了交易
    }
    //将交易结束
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma Mark 购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing://正在交易
                break;
                
            case SKPaymentTransactionStatePurchased://交易完成
            {
                //获取receiptStr
                NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];//NSData 类型
                NSString *receiptStr = [receiptData base64EncodedStringWithOptions:0];//转成NSString类型
                //TODO:
                //这里取得receipt，POST请求进行二次验证
                //沙箱验证地址：https://sandbox.itunes.apple.com/verifyReceipt
                //正式打包验证地址：https://buy.itunes.apple.com/verifyReceipt
                
                
            }
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}


@end
