//
//  HealthKitManager.m
//  SleepTracker
//
//  Created by David Beilis on 8/14/16.
//  Copyright © 2016 Adriel Service. All rights reserved.
//

#import "HealthKitManager.h"
#import <HealthKit/HealthKit.h>

@interface HealthKitManager ()

@property (nonatomic, retain) HKHealthStore *healthStore;

@end

@implementation HealthKitManager

+ (HealthKitManager *)sharedManager {
    static dispatch_once_t pred = 0;
    static HealthKitManager *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[HealthKitManager alloc] init];
        instance.healthStore = [[HKHealthStore alloc] init];
    });
    return instance;
}

- (void)requestAuthorization {
    
    if ([HKHealthStore isHealthDataAvailable] == NO) {
        NSLog(@"Your device does not support HealthKit");
        return;
    }
    
    HKCategoryType* categoryType = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    [self.healthStore requestAuthorizationToShareTypes:[NSSet setWithArray:@[categoryType]] readTypes:[NSSet setWithArray:@[categoryType]] completion:^(BOOL success, NSError *error) {
         if(error) {
             NSLog(@"%@", error);
         } else {
             NSLog(@"Success is %d", success);
         }
     }];
}

- (void)readSleepData {
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];   // Convenience method of HKHealthStore to get date of birth directly.
    
    if (!dateOfBirth) {
        NSLog(@"Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.");
    }
    
    // return dateOfBirth;
}

- (void)writeSleepData:(NSDate*)startTime andEndTime:(NSDate*)endTime {
    
    HKCategoryType* categoryType = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    HKCategorySample *categorySample = [HKCategorySample categorySampleWithType:categoryType value:HKCategoryValueSleepAnalysisAsleep startDate:startTime endDate:endTime];
    
    [self.healthStore saveObject:categorySample withCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Saving workout to healthStore - success: %@", success ? @"YES" : @"NO");
        if (error != nil) {
            NSLog(@"error: %@", error);
        }
    }];
}

@end
