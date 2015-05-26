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
#define kDistanceFilter 1 //25m, will not return a new position unless its 1m away, 1m between each point
#define kHeadingFilter 0
//these two used when refining the results further
#define kAccuracyFilter 1 //50m
#define kTimeFilter 0.2 //0.2 seconds

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    //add
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//kCLLocationAccuracyBestForNavigation;
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

//if the locations have passed the criteria, they're then set here:
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    //timestamp of cllocation object and check it against the current time to get its age and decide if it's recent enough to be useful.
    
    //fix degrees of inaccurate signals, turn negative float to positive values.
    NSTimeInterval timeSince = fabs([newLocation.timestamp timeIntervalSinceNow]);
    if ((newLocation.horizontalAccuracy < kAccuracyFilter) && (timeSince < kTimeFilter))
    {
        
       // [self.delegate waypoint:newLocation];
    } else {
        NSLog(@"Waypoint discarded. Accuracy : %f, Age : %f", newLocation.horizontalAccuracy, timeSince);
    }
    NSDate *eventsDate = newLocation.timestamp;
    NSTimeInterval eventinterval = [eventsDate timeIntervalSinceNow];
    
    //minimum of 5 seconds between points
    if (timeSince > 5)
    {
        //use the waypoint ..
        [latitudeLabel setText:[NSString stringWithFormat:
                                @"Latitude: %f",newLocation.coordinate.latitude]];
        [longitudeLabel setText:[NSString stringWithFormat:
                                 @"Longitude: %f",newLocation.coordinate.longitude]];
    } else {
        NSLog(@"Not 5s since previous so not adding");
    }
    

}

/*- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
       }*/

/*-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"%",[locations lastObject]);
}*/

/*-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
    [latitudeLabel setText:[NSString stringWithFormat:
                            @"Latitude: %f",newLocation.coordinate.latitude]];
    [longitudeLabel setText:[NSString stringWithFormat:
                             @"Longitude: %f",newLocation.coordinate.longitude]];
    NSLog(@"lat = %f, lon = %f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);
   
    
    
}*/

//to call to start and stop getting GPS from the receiver
- (void) startUpdates
{
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}

- (void) stopUpdates
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
}

@end
