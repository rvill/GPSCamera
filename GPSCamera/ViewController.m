//
//  ViewController.m
//  GPSCamera
//
//  Created by rvill on 5/25/15.
//  Copyright (c) 2015 rvill. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>
@property(strong, nonatomic) CLLocationManager *locationManager;
@end

//first two used in setting up the CLLocationManager
#define kDistanceFilter 25
#define kHeadingFilter 0
//these two used when refining the results further
#define kAccuracyFilter 50
#define kTimeFilter 0.2

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    //add
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kDistanceFilter;
    self.locationManager.headingFilter = kHeadingFilter;
    
    //end add
    
    //check for ios 8, without code crashes silently.
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    
    [[LocationHandler getSharedInstance]setDelegate:self];
    [[LocationHandler getSharedInstance]startUpdating];
    // Do any additional setup after loading the view, typically from a nib.
    
  
    
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSTimeInterval timeSince = fabs([newLocation.timestamp timeIntervalSinceNow]);
    if ((newLocation.horizontalAccuracy < kAccuracyFilter) && (timeSince < kTimeFilter))
    {
        //[self.delegate waypoint:newLocation];
    } else {
        NSLog(@"Waypoint discarded. Accuracy : %f, Age : %f", newLocation.horizontalAccuracy, timeSince);
    }
    NSDate *eventsDate = newLocation.timestamp;
    NSTimeInterval eventinterval = [eventsDate timeIntervalSinceNow];
    
   
    if (timeSince > 5)
    {
        //use the waypoint ..
    } else {
        NSLog(@"Not 5s since previous so not adding");
    }
    

}

/*- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
       }*/

/*-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"%",[locations lastObject]);
}*/

-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
    [latitudeLabel setText:[NSString stringWithFormat:
                            @"Latitude: %f",newLocation.coordinate.latitude]];
    [longitudeLabel setText:[NSString stringWithFormat:
                             @"Longitude: %f",newLocation.coordinate.longitude]];
    NSLog(@"lat = %f, lon = %f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    //NSLog(@"lon= %f", newLocation.coordinate.longitude);
    
    
}



@end
