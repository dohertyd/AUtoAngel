//
//  CrashViewController.m
//  AutoAngel
//
//  Created by Derek Doherty on 23/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import "CrashViewController.h"

@interface CrashViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
#define METERS_PER_MILE 1609.344

@implementation CrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 53.375951;
    zoomLocation.longitude= -6.270500;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
    
    
    // Create your coordinate
    CLLocationCoordinate2D myCoordinate = {53.375951, -6.270500};
    //Create your annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    // Set your annotation to point at your coordinate
    point.coordinate = myCoordinate;
    //If you want to clear other pins/annotations this is how to do it
    for (id annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    //Drop pin on map
    [self.mapView addAnnotation:point];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
