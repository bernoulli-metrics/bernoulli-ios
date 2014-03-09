//
//  Bernoulli.h
//  Bernoulli
//
//  Created by Joe Gasiorek on 3/8/14.
//  Copyright (c) 2014 Joe Gasiorek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bernoulli : NSObject
+ (BOOL)getExperimentsForIds:(NSArray*)experimentIds
                            clientId:(NSString *)clientId
                           userId:(NSString *)userId
                         userData:(NSDictionary *)userData
                          success:(void (^)(NSArray *experiments))successBlock
                            error:(void (^)(NSString *message))errorBlock;

+ (BOOL)goalAttainedForId:(NSString*)experimentId
                 clientId:(NSString*)clientId
                   userId:(NSString*)userId
                 callback:(void (^)(BOOL))callbackBlock;

extern NSString *const URL;
@end
