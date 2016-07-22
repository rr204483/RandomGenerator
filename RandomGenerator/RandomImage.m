//
//  ViewController.m
//  RandomGenerator
//
//  Created by Ramesh on 10/07/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import "RandomImage.h"
#import <QuartzCore/QuartzCore.h>


@interface RandomImage ()

@end

@implementation RandomImage
@synthesize randomArray;
@synthesize randomColorArray;
@synthesize colors;
@synthesize arrNumbers;
@synthesize segmentedCtrl;
@synthesize howManyButtons;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image
//    UIImageView *backgroundIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
//    [self.view addSubview:backgroundIV];
//    [backgroundIV release];

    self.navigationItem.title=@"Colors Randomizer";
    self.colors= [[[NSArray alloc] initWithObjects:
                      [UIColor greenColor], [UIColor blueColor] , [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor cyanColor], [UIColor brownColor], [UIColor redColor],[UIColor grayColor], [UIColor darkGrayColor], [UIColor blackColor], nil] autorelease];
    
    UILabel *selectLabel =[self createLabel:0 Top:8 Width:100 Height:30 Tag:0
                                     Color:[UIColor blackColor] Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"Select:" Align:1 ] ;
    
    [self.view addSubview:selectLabel];
    //[selectLabel release];
   
    self.arrNumbers=[[[NSArray alloc] initWithObjects:@"2",@"3", @"4", @"5",@"6",nil] autorelease];
    //create a segmented control
    segmentedCtrl = [[UISegmentedControl alloc] initWithItems:self.arrNumbers];
    [segmentedCtrl setTag:10];
    segmentedCtrl.frame = CGRectMake(90, 8, 220, 35);
    segmentedCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedCtrl.enabled = true;
    segmentedCtrl.selectedSegmentIndex=0;
    [segmentedCtrl addTarget:self action:@selector(segmentChanges:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedCtrl];
    [segmentedCtrl release];
    //load buttons for default value which is 2 buttons
    [self loadButtons:2 left:10 top:100 width:140 height:140];
    self.howManyButtons=2;
    
    self.randomArray= [[[NSMutableArray alloc] init] autorelease];
    self.randomColorArray=[[[NSMutableArray alloc] init]autorelease];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(displayClearAlert)];
    tap.delegate=self;
    
    [self.view addGestureRecognizer:tap];


    
 }


-(void) segmentChanges:(id) sender {
    
    int howManyBtns=0; int left=0; int top=0; int width=0; int height=0;
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
 
    //remove the buttons
    for (UIView *subView in [self.view subviews]) {
        switch (subView.tag) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                [subView removeFromSuperview];
                break;
        }
        
    }

    switch (selectedSegment){
        case 0:
            howManyBtns=2;
            left=10; top=100; width=140;  height = 140;
            break;
        case 1:
            howManyBtns=3;
            left=10; top=60; width=140;  height = 140;
            break;
        case 2:
            howManyBtns=4;
            left=10; top=60; width=140;  height = 140;
            break;
        case 3:
            howManyBtns=5;
            left=30; top=60; width=100;  height = 100;
            break;
        case 4:
            howManyBtns=6;
            left=30; top=50; width=120;  height = 100;
            break;
    }
    
    self.howManyButtons=howManyBtns;

    [self loadButtons:howManyBtns left:left top:top width:width height:height];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can [be recreated.
}

-(void) loadButtons:(NSInteger) noOfButtons left:(NSInteger) left top:(NSInteger) top width:(NSInteger)width height:(NSInteger) height {
    
    int tags=1;
    int i=1;
    [self.randomArray removeAllObjects];
    [self.randomColorArray removeAllObjects];
    
    for (i=1; i<=noOfButtons ; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(left, top, width, height);
        button.backgroundColor= (UIColor *)[self.colors objectAtIndex: [self randomForColors]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:40];
        button.layer.cornerRadius=20;
        [button addTarget:self
                   action:@selector(populateRandomNumber:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTag:tags];
        [self.view addSubview:button];
        left=left+160;
        
        switch (noOfButtons) {
            case 3:
                if (i==2) {
                    top=210;
                    left=90;
                }
                break;
                
            case 4:
                if (i==2) {
                    top=210;
                    left=10;
                }

                break;
            case 5:
                if (i==2) {
                    top=155;
                    left=110;
                }
                
                if (i==3) {
                    top=250;
                    left=30;
                }
                break;
            case 6:
                if (i==2) {
                    top=155;
                    left=30;
                }
                
                if (i==4) {
                    top=260;
                    left=30;
                }
                break;
        
        }
        
        tags++;
    }

}

-(int) randomForColors {
    
    int randomNumber=0;
    
    do {
        randomNumber = arc4random_uniform(10);
    } while ( ([self.randomColorArray containsObject:[NSNumber numberWithInt:randomNumber]]));
    
    [self.randomColorArray addObject:[NSNumber numberWithInt:randomNumber]];
    return  randomNumber;
    
}

-(void) populateRandomNumber:(id) sender {
   
    UIButton *button = (UIButton *)sender ;
    int randomNumber=0;
    int arrCount= [self.randomArray count];
    
    if ( arrCount != self.howManyButtons )
        if ( [self isAnyButtonEmpty:sender])
            return;
  
    if (arrCount > (self.howManyButtons-1)) {
        [self displayClearAlert];
        return;
    }

    do {
        randomNumber = arc4random_uniform(self.howManyButtons+1);
        
    } while ( ([self.randomArray containsObject:[NSNumber numberWithInt:randomNumber]] || (randomNumber ==0) ));
    [self.randomArray addObject:[NSNumber numberWithInt:randomNumber]];
    [button setTitle:[NSString stringWithFormat:@"%d", randomNumber] forState:UIControlStateNormal];

}

-(void) displayClearAlert {
    
    UIAlertView *tmpAlert = [[UIAlertView alloc]
                             initWithTitle:nil
                             message:@"Clear the numbers ?"
                             delegate:self
                             cancelButtonTitle:@"No"
                             otherButtonTitles:@"Yes", nil];
    
    [tmpAlert show];
    tmpAlert.delegate=self;
    [tmpAlert autorelease];
    
}

-(void) displayWarning {
    
    UIAlertView *tmpAlert = [[UIAlertView alloc]
                             initWithTitle:nil
                             message:@"hey, tab other buttons"
                             delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"Ok", nil];
    
    [tmpAlert show];
    tmpAlert.delegate=self;
    [tmpAlert autorelease];
    
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1){
        int tags=1;
        [self.randomArray removeAllObjects];
        [self.randomColorArray removeAllObjects];
      
        for (int i=0; i<self.howManyButtons; i++) {
            UIButton *buttonToRemove = (UIButton *) [self.view viewWithTag:tags];
            [buttonToRemove setTitle:nil forState:UIControlStateNormal];
            buttonToRemove.backgroundColor= (UIColor *)[self.colors objectAtIndex: [self randomForColors]];
            tags =tags+1;
        }

     }
}

-(BOOL)isAnyButtonEmpty :(id) sender {
    
    UIButton *button1 = (UIButton *)sender ;
    int tags=1;
    for (int i=0; i<self.howManyButtons; i++) {

        UIButton *button = (UIButton *) [self.view viewWithTag:tags];
        
        if (( button.currentTitle != nil) ) {
            if ([button1 tag] == tags)  {
                [self displayWarning];
                return YES;
            }
        
        }
        tags =tags+1;
    }
    return NO;
    
}

-(UILabel *) createLabel:(float)left Top:(float)top Width:(float)width Height:(float)height Tag:(int) tag
                   Color:(UIColor *) color Font:(UIFont *) font Text:(NSString *) text Align:(NSTextAlignment) align {
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, width, height)];
    [tmpLabel setTag:tag];
    [tmpLabel setBackgroundColor:[UIColor clearColor]];
    [tmpLabel setTextColor:color];
    [tmpLabel setFont:font];
    [tmpLabel setTextAlignment:align];
    [tmpLabel setText:text];
    return [tmpLabel autorelease];
    
}

-(void) dealloc {
    [super dealloc];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ( [touch.view isKindOfClass:[UIButton class]] ||
         [touch.view isKindOfClass:[UISegmentedControl class]] ||
         ([self.randomArray count] == 0)
        ) {
        //we touched the button or there is no numbers on the images yet, ignore the touch
        return NO;
    }
    
    return YES; //handler the touch
}

@end
