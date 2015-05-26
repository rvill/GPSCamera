//
//  ViewController.m
//  GPSCamera
//
//  Created by rvill on 5/25/15.
//  Copyright (c) 2015 rvill. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>
@property(strong, nonatomic) CLLocationManager *locationManager;
@end

//first two used in setting up the CLLocationManager
//#define kDistanceFilter 1 //25m, will not return a new position unless its 1m away, 1m between each point
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
   // self.locationManager.distanceFilter = kDistanceFilter;
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
       // [latitudeLabel setText:[NSString stringWithFormat:
                            //    @"Latitude: %f",newLocation.coordinate.latitude]];
       // [longitudeLabel setText:[NSString stringWithFormat:
                             //    @"Longitude: %f",newLocation.coordinate.longitude]];

    } else {
        NSLog(@"Waypoint discarded. Accuracy : %f, Age : %f", newLocation.horizontalAccuracy, timeSince);
    }
    NSDate *eventsDate = newLocation.timestamp;
    NSTimeInterval eventinterval = [eventsDate timeIntervalSinceNow];
    
    //minimum of 5 seconds between points
    if (timeSince > 5)
    {
        //use the waypoint ..
      //  [latitudeLabel setText:[NSString stringWithFormat:
                            //    @"Latitude: %f",newLocation.coordinate.latitude]];
       // [longitudeLabel setText:[NSString stringWithFormat:
                             //    @"Longitude: %f",newLocation.coordinate.longitude]];

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
    
    
    NSTimeInterval timeSince = fabs([newLocation.timestamp timeIntervalSinceNow]);
    
    if ((newLocation.horizontalAccuracy < kAccuracyFilter) && (timeSince < kTimeFilter))
    {
        
        // [self.delegate waypoint:newLocation];
         [latitudeLabel setText:[NSString stringWithFormat:
            @"Latitude: %f",newLocation.coordinate.latitude]];
         [longitudeLabel setText:[NSString stringWithFormat:
            @"Longitude: %f",newLocation.coordinate.longitude]];
        
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

    ///original from this method
    
   /* [latitudeLabel setText:[NSString stringWithFormat:
                            @"Latitude: %f",newLocation.coordinate.latitude]];
    [longitudeLabel setText:[NSString stringWithFormat:
                             @"Longitude: %f",newLocation.coordinate.longitude]];
    NSLog(@"lat = %f, lon = %f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);*/
   
    
    
}

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

//Camera, Image picker
- (void) useCamera:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker= [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;    }
}

//Camera roll
- (void) useCameraRoll:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
