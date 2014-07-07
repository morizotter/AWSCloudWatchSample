//
//  ACSViewController.m
//  AWSCloudwatchSample
//
//  Created by MORITA NAOKI on 2014/07/07.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import "ACSViewController.h"
#import <AWSCloudWatch/AWSCloudWatch.h>

@interface ACSViewController ()

@end

@implementation ACSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getData];
}

- (void)getData
{
#warning Enter your access key id and secret access key.
#warning Please take care not to make public your access key id and secret access key.
    
    AmazonCloudWatchClient *client =
    [[AmazonCloudWatchClient alloc] initWithAccessKey:@"YOUR_ACCESS_KEY_ID"
                                        withSecretKey:@"YOUR_SECRET_ACCESS_KEY"];
    
    CloudWatchDimension *dimension = [[CloudWatchDimension alloc] init];
    dimension.name = @"Currency";
    dimension.value = @"USD";
    NSDate *startDate = [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:[NSDate date]];
    NSDate *endDate = [NSDate date];
    
    CloudWatchGetMetricStatisticsRequest *request = [[CloudWatchGetMetricStatisticsRequest alloc] init];
    request.metricName = @"EstimatedCharges";
    request.namespace = @"AWS/Billing";
    request.statistics = @[@"Sum", @"Average", @"Minimum", @"Maximum"].mutableCopy;
    request.startTime = startDate;
    request.endTime = endDate;
    request.period = @60;
    [request addDimension:dimension];
    
    CloudWatchGetMetricStatisticsResponse *response = [client getMetricStatistics:request];
    
    if (response.error) {
        NSLog(@"error: %@", response.error);
        
        UIAlertView *aView = [[UIAlertView alloc] init];
        [aView setTitle:@"error"];
        [aView setMessage:response.error.localizedDescription];
        [aView show];
        return;
    }
    
    NSLog(@"label: %@\ndata points: %@", response.label, response.datapoints);
}

@end
