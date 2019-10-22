//
//  PayCenter.h
//  TestPay
//
//  Created by Apple on 2019/10/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

//在App Store Connect中创建内购项目的product_id
#define IAP1_ProductID @""
#define IAP2_ProductID @""

NS_ASSUME_NONNULL_BEGIN

@interface PayCenter : NSObject


//全局管理对象
+ (PayCenter *)sharedInstance;

//- (void)payWithMoney:(NSInteger)money andType:(PayType)type dataDic:(NSDictionary *)dataDic;


- (void)startManager;
- (void)stopManager;



- (void)payItem:(NSString *)IAP_ID;


@end

NS_ASSUME_NONNULL_END
