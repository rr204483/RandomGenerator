//
//  ViewController.h
//  RandomGenerator
//
//  Created by Ramesh on 10/07/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomImage : UIViewController<UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *randomArray;
@property (nonatomic, strong) NSMutableArray *randomColorArray;
@property(nonatomic, strong) NSArray *colors;

@property(nonatomic,strong) NSArray *arrNumbers;

@property(nonatomic,strong) UISegmentedControl *segmentedCtrl ;

@property(nonatomic) NSInteger howManyButtons;

@end
