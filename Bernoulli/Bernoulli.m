//
//  Bernoulli.m
//  Bernoulli
//
//  Created by Joe Gasiorek on 3/8/14.
//  Copyright (c) 2014 Joe Gasiorek. All rights reserved.
//

#import "Bernoulli.h"
#import <AFNetworking.h>

@implementation Bernoulli

NSString *const URL = @"http://localhost:5000/api/client/experiments/";

+ (BOOL)getExperimentsForIds:(NSArray*)experimentIds
                         clientId:(NSString *)clientId
                           userId:(NSString *)userId
                         userData:(NSDictionary *)userData
                          success:(void (^)(NSArray *experiments))successBlock
                            error:(void (^)(NSString *message))errorBlock {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (clientId == nil) {
        [NSException raise:@"Invalid clientId" format:@"clientId"];
    }
    
    NSMutableDictionary *dict = [userData mutableCopy];
    [dict setObject:clientId forKey:@"clientId"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:[experimentIds componentsJoinedByString:@","] forKey:@"experimentIds"];
    
    [manager GET:URL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
 
        NSString *status = [responseObject objectForKey:@"status"];
        if (![status isEqualToString:@"ok"]) {
            errorBlock(@"Unable to fetch experiments");
            return;
        }
        
        successBlock([responseObject objectForKey:@"value"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(@"Unable to fetch experiments");
    }];
    
    return TRUE;
}
@end
