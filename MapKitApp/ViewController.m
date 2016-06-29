//
//  ViewController.m
//  MapKitApp
//
//  Created by Delivery Resource on 02/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPointAnnotation* romaAnno;
@property (strong, nonatomic) MKPointAnnotation* dublinAnno;
@property (strong, nonatomic) MKPointAnnotation* stadiumAnno;
@property (strong,nonatomic) MKPointAnnotation* currentAnno;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (nonatomic, assign) BOOL mapIsMoving;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAnnotations];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    self.mapIsMoving = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)centerMap:(MKPointAnnotation*)anno {
    [self.mapView setCenterCoordinate:anno.coordinate animated:YES];
}

-(void)addAnnotations{
    self.romaAnno = [[MKPointAnnotation alloc] init];
    self.romaAnno.coordinate = CLLocationCoordinate2DMake(41.909986, 12.3959151);
    self.romaAnno.title = @"Rome, home of Italy!";
    
    self.dublinAnno = [[MKPointAnnotation alloc] init];
    self.dublinAnno.coordinate = CLLocationCoordinate2DMake(53.3242381, -6.3857853);
    self.dublinAnno.title = @"Dublin, in a few uears i wiil leave here!";
    
    self.stadiumAnno = [[MKPointAnnotation alloc] init];
    self.stadiumAnno.coordinate = CLLocationCoordinate2DMake(44.9713522, -93.2593085);
    self.stadiumAnno.title = @"U.S. Bank Stadium. SKOL Vikings!!";
    
    self.currentAnno= [[MKPointAnnotation alloc] init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.currentAnno.title = @"My Location!";
    
    [self.mapView addAnnotations:@[self.romaAnno, self.dublinAnno, self.stadiumAnno, self.currentAnno]];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    if (self.mapIsMoving == NO) {
        [self centerMap:self.currentAnno];
    }
}

- (IBAction)romaTapped:(id)sender {
    [self centerMap:self.romaAnno];
}

- (IBAction)dublinTapped:(id)sender {
    [self centerMap:self.dublinAnno];
}

- (IBAction)stadiumTapped:(id)sender {
    [self centerMap:self.stadiumAnno];
}

- (IBAction)switchTapped:(id)sender {
    if (self.switchButton.isOn) {
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    }
    else {
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
        
    }
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapIsMoving = YES;
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapIsMoving = NO;
}


@end
