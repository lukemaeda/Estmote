//
//  ViewController.m
//  Estmote
//
//  Created by MAEDAHAJIME on 2015/06/16.
//  Copyright (c) 2015年 MAEDAHAJIME. All rights reserved.
//
//  Estimote 距離
//  http://estimote.com/api/tutorials/distance.html

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /////////////////////////////////////////////////////////////
    // set up Estimote beacon manager
    
    // create a beacon manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    // create a sample region object (you can also pass major or major+minor arguments)
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"EstimoteSampleRegion"];
    
    // start looking for Estimote beacons in the region
    // when beacons are found in range, beaconManager:didRangeBeacons:inRegion: is invoked
    [self.beaconManager startRangingBeaconsInRegion:region];
    
    /////////////////////////////////////////////////////////////
    // setup view
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    /////////////////////////////////////////////////////////////
    // setup background image
    
    CGRect          screenRect          = [[UIScreen mainScreen] bounds];
    CGFloat         screenHeight        = screenRect.size.height;
    UIImageView*    backgroundImage;
    
    if (screenHeight > 480)
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundBig"]];
    else
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundSmall"]];
    
    [self.view addSubview:backgroundImage];
    
    /////////////////////////////////////////////////////////////
    // setup dot image
    
    self.positionDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotImage"]];
    [self.positionDot setCenter:self.view.center];
    [self.positionDot setAlpha:1.];
    
    [self.view addSubview:self.positionDot];
    
    self.dotMinPos = 150;
    self.dotRange = self.view.bounds.size.height  - 220;
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    ESTBeacon* closestBeacon;
    
    if([beacons count] > 0)
    {
        // beacon array is sorted based on distance
        // closest beacon is the first one
        closestBeacon = [beacons objectAtIndex:0];
        
        // calculate and set new y position
        float newYPos = self.dotMinPos + ((float)closestBeacon.rssi / -100.) * self.dotRange;
        self.positionDot.center = CGPointMake(self.view.bounds.size.width / 2, newYPos);
    }
}

@end
