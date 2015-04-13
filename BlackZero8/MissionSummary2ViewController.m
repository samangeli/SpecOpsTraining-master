//
//  MissionSummary2ViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-02-16.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "MissionSummary2ViewController.h"
#import "RLSimpleBarGraph.h"

@interface MissionSummary2ViewController ()

@end

@implementation MissionSummary2ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // This is the only call you actually need, but it's just a plain black bar graph
    [_yourRLSimpleBarGraph basicInit: @[@1,@2,@4,@6,@8,@10,@3,@1,@1,@15,@7]];
    
    //Now whichever bars are over 5.0 are color blue and lower are light gray
    //    [yourRLSimpleBarGraph setAchievementAt:5.0 setAchievedColor:[UIColor blueColor] andNotAchievedColor:[UIColor lightGrayColor]];
    
    
    [_yourRLSimpleBarGraph  alternateColors:@[[UIColor grayColor],[UIColor blackColor],[UIColor purpleColor]]];
    //    yourRLSimpleBarGraph.showScale = NO; //for no scale guides
    //    yourRLSimpleBarGraph.numOfScales = 3 //number of guides, default 5
    _yourRLSimpleBarGraph.scalePrecision = 1; //0 for no precision, 1 for 1.0, 2 for 2.00, 3 for 3.000
    _yourRLSimpleBarGraph.itemsPerPage = 4;
    //    yourRLSimpleBarGraph.fixedBarWidth = 21;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
