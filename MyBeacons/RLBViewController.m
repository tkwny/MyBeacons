//
//  RLBViewController.m
//  MyBeacons
//
//  Created by Randy Bradshaw on 10/8/13.
//  Copyright (c) 2013 Randy Bradshaw. All rights reserved.
//

#import "RLBViewController.h"

static NSString * const kUUID = @"00000000-0000-0000-0000-000000000000";
static NSString * const kIdentifier = @"SomeIdentifier";
static NSString * const kCellIdentifier = @"BeaconCell";


@interface RLBViewController ()

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLBeaconRegion *beaconRegion;
@property (nonatomic,strong) CBPeripheralManager * peripheralManager;
@property (nonatomic,strong) NSArray *detectedBeacons;

@end

@implementation RLBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.advertisingSwitch addTarget:self
                               action:@selector(changeAdvertisingState:)
                     forControlEvents:UIControlEventValueChanged];
    [self.rangingSwitch addTarget:self
                           action:@selector(changeRangingState:)
                 forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Beacon ranging
- (void)createBeaconRegion
{
    if(self.beaconRegion)
        return;
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
    
}

-(void)turnOnRanging
{
    NSLog(@"Turning on ranging.");
    
    if(![CLLocationManager isRangingAvailable])
    {
        NSLog(@"Unable to turn on ranging: Ranging is not available.");
        self.rangingSwitch.on = NO;
        return;
    }
    
    if(self.locationManager.rangedRegions.count > 0)
    {
        NSLog(@"Didn't turn on ranging: Ranging already on.");
        return;
    }
    
    [self createBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    NSLog(@"Ranging turned on for region:%@.", self.beaconRegion);
}

-(void)changeRangingState:sender
{
    UISwitch *theSwitch = (UISwitch *)sender;
    
    if(theSwitch.on)
    {
        [self startRangingForBeacons];
    }
    else
    {
        [self stopRangingForBeacons];
    }
}

-(void)startRangingForBeacons
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self turnOnRanging];
     
}

-(void)stopRangingForBeacons
{
    if(self.locationManager.rangedRegions.count == 0)
    {
        NSLog(@"Unable to turn off ranging: Ranging already off.");
        return;
    }
    
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    
    self.detectedBeacons = nil;
    [self.beaconsTableView reloadData];
    
    NSLog(@"Turned off ranging.");
    
}

#pragma mark - Beacon ranging delegate methods
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Unable to turn on ranging: Location services are not enabled.");
        self.rangingSwitch.on = NO;
        return;
    }
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized)
    {
        NSLog(@"Unable to turn on ranging: Location services not authorized");
        self.rangingSwitch.on = NO;
        return;
    }
    self.rangingSwitch.on = YES;
}

-(void)locationManager:(CLLocationManager *)manager
       didRangeBeacons:(NSArray *)beacons
              inRegion:(CLBeaconRegion *)region
{
    if ([beacons count] == 0)
    {
        NSLog(@"No beacons found nearby.");
    }
    else
    {
        NSLog(@"Found beacons!");
    }
    self.detectedBeacons = beacons;
    [self.beaconsTableView reloadData];
}

#pragma mark - Beacon advertising
-(void)turnOnAdvertising
{
    if(self.peripheralManager.state != 5)
    {
        NSLog(@"Peripheral Manager is off.");
        self.advertisingSwitch.on = NO;
        return;
    }
    
    time_t t;
    srand((unsigned) time(&t));
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.beaconRegion.proximityUUID
                                                                     major:rand()
                                                                     minor:rand()
                                                                identifier:self.beaconRegion.identifier];
    
    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    
}

-(void)changeAdvertisingState:sender
{
    UISwitch *theSwitch = (UISwitch *)sender;
    if(theSwitch.on)
    {
        [self startAdvertisingBeacon];
    }
    else
    {
        [self stopAdvertisingBeacon];
    }
}
-(void)startAdvertisingBeacon
{
    NSLog(@"Turning on beacon advertising.");
    [self createBeaconRegion];
    
    if(!self.peripheralManager)
    {
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
        [self turnOnAdvertising];
    }
}

-(void)stopAdvertisingBeacon
{
    [self.peripheralManager stopAdvertising];
    NSLog(@"Turned off beacon advertising.");
}

#pragma mark - Beacon advertising delegate method
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheralManager error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Could not turn on iBeacon advertising: %@", error);
        self.advertisingSwitch.on = NO;
        return;
    }
    if (peripheralManager.isAdvertising) {
        NSLog(@"Turned on iBeacon advertising");
        self.advertisingSwitch.on = YES;
    }
    
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
    if(peripheralManager.state != 5)
    {
        NSLog(@"Peripheral manager is off.");
        self.advertisingSwitch.on = NO;
        return;
    }
    NSLog(@"Peripheral manager is on.");
    [self turnOnAdvertising];
}

#pragma mark - Table view functionality
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLBeacon *beacon = self.detectedBeacons[indexPath.row];
    
    UITableViewCell  *defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    
    defaultCell.textLabel.text = beacon.proximityUUID.UUIDString;
    
    NSString *proximityString;
    switch (beacon.proximity) {
        case CLProximityNear:
            proximityString =@"Beacon near!";
            break;
        case CLProximityImmediate:
            proximityString =@"Beacon immediate!";
            break;
        case CLProximityFar:
            proximityString =@"Beacon far away!";
            break;
        case CLProximityUnknown:
            proximityString =@"Beacon location unknown";
            break;
    }
    
    defaultCell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@ • %@ • %f • %li",
                                        beacon.major.stringValue, beacon.minor.stringValue, proximityString, beacon.accuracy, (long)beacon.rssi];
    defaultCell.detailTextLabel.textColor = [UIColor blueColor];
    
    return defaultCell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detectedBeacons.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Detected Beacons";
}

@end
