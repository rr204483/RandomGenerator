//
//  RangeRandom.h
//  RandomGenerator
//
//  Created by Ramesh on 26/07/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RangeRandom : UIViewController<UITextFieldDelegate> {
    UITextField *minLimit;
    UITextField *maxLimit;
    UILabel *randomLabel;
}

@property (nonatomic) NSInteger minNumber;
@property (nonatomic) NSInteger maxNumber;


@end
