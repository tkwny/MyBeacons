//
//  RLBViewController.h
//  MyBeacons
//
//  Created by Randy Bradshaw on 10/8/13.
//  Copyright (c) 2013 Randy Bradshaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface RLBViewController : UIViewController <CLLocationManagerDelegate, CBPeripheralManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *advertisingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rangingSwitch;
@property (weak, nonatomic) IBOutlet UITableView *beaconsTableView;

@end
