//
//  HealthKitManager.h
//  SleepTracker
//
//  Created by David Beilis on 8/14/16.
//  Copyright © 2016 Adriel Service. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthKitManager : NSObject

+ (HealthKitManager *)sharedManager;

- (void)requestAuthorization;

- (void)writeSleepData:(NSDate*)startTime andEndTime:(NSDate*)endTime;

@end
