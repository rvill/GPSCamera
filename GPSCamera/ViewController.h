//
//  ViewController.h
//  GPSCamera
//
//  Created by rvill on 5/25/15.
//  Copyright (c) 2015 rvill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationHandler.h"

@interface ViewController : UIViewController<LocationHandlerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UILabel *latitudeLabel;
    IBOutlet UILabel *longitudeLabel;
}
@property BOOL newMedia;
- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;
@property (strong,nonatomic) IBOutlet UIImageView *imageView;


@end


