//
//  RangeRandom.m
//  RandomGenerator
//
//  Created by Ramesh on 26/07/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import "RangeRandom.h"
#define RAND_FROM_TO(min,max) (min + arc4random_uniform(max - min + 1))

@interface RangeRandom ()

@end

@implementation RangeRandom

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Range Randomizer";
    self.view.backgroundColor=[UIColor lightGrayColor];
 
    [self displayTextBoxForRange];
    
}

-(void) displayTextBoxForRange {
    
    UILabel *rangeLabel =[self createLabel:0 Top:20 Width:180 Height:30 Tag:0
                                   Color:[UIColor blackColor] Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"Enter the Range :" Align:1 ];
    
    [self.view addSubview:rangeLabel];
    //[rangeLabel release];

    
    UILabel *minLabel =[self createLabel:36 Top:60 Width:90 Height:40 Tag:0
                                          Color:[UIColor blueColor] Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"Min :" Align:1 ];

    [self.view addSubview:minLabel];
    //[minLabel release];
    
    minLimit =[self createText:120 Top:60 Width:120 Height:40 Tag:1 Color:[UIColor whiteColor] Font:[UIFont fontWithName:@"Helvetica" size:20] BorderStyle:UITextBorderStyleRoundedRect Align:UITextAlignmentLeft Keyboard:UIKeyboardTypeNumberPad ReturnKeyType:UIReturnKeyDone];
    
    minLimit.delegate=self;
    minLimit.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    
    UILabel *maxLabel =[self createLabel:36 Top:110 Width:90 Height:40 Tag:2
                                   Color:[UIColor blueColor] Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"Max :" Align:1 ];
    
    [self.view addSubview:maxLabel];
    //[maxLabel release];
    
    maxLimit =[self createText:120 Top:110 Width:120 Height:40 Tag:3 Color:[UIColor whiteColor] Font:[UIFont fontWithName:@"Helvetica" size:20] BorderStyle:UITextBorderStyleRoundedRect Align:UITextAlignmentLeft Keyboard:UIKeyboardTypeNumberPad ReturnKeyType:UIReturnKeyDone];
    
    maxLimit.delegate=self;
    maxLimit.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad) ] autorelease],
                           [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
                           [[[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)] autorelease],
                           nil] ;
    
    [numberToolbar sizeToFit];
    
    minLimit.inputAccessoryView = numberToolbar;
    maxLimit.inputAccessoryView = numberToolbar;
    
    [numberToolbar release];
    
    [self.view addSubview:minLimit];
    [self.view addSubview:maxLimit];

    
    
    UIButton *goBtn =[self createButton:250 Top:110 Width:50 Height:40 Tag:4
                                        Color:[UIColor magentaColor]
                                   Font:[UIFont fontWithName:@"Helvetica" size:20] Text:@"Go!" Align:1 ];
    
    [goBtn addTarget:self
                        action:@selector(populateRandom:)
              forControlEvents:UIControlEventTouchDown];
        
    [self.view addSubview:goBtn];
    //[goBtn release] ;
    
    randomLabel =[self createLabel:120 Top:190 Width:120 Height:40 Tag:2
                             Color:[UIColor blackColor] Font:[UIFont boldSystemFontOfSize:40] Text:@"" Align:1 ];
    [self.view addSubview:randomLabel];
   // [rangeLabel release];

    
}

- (NSInteger)randomValueBetween {
    int min= [minLimit.text integerValue];
    int max= [maxLimit.text integerValue];
    return (NSInteger)(min + arc4random_uniform(max - min + 1));
}

-(void) displayAlert:(NSString *)title Message:(NSString *)message {
    
    UIAlertView *tmpAlert = [[UIAlertView alloc]
                             initWithTitle:title
                             message:message
                             delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:@"Ok", nil];
    
    [tmpAlert show];
    [tmpAlert autorelease];
    
}


- (BOOL)isMaxEmpty {
   return (maxLimit.text == nil || [@"" isEqualToString:maxLimit.text]);
}

- (BOOL)isMinEmpty {
    return (minLimit.text == nil || [@"" isEqualToString:minLimit.text]);
}

-(BOOL) isValidRange:(NSInteger) min andMax:(NSInteger) max {
    return( min > max );
    
}


-(void) populateRandom:(id) sender {
    
    int randomNumber, min, max;
    
    [self dismissKeyboard];
    
    randomLabel.text=@"";
    
    if ( [self isMaxEmpty] ) {
        [self displayAlert:@"No Max" Message:@"Max value can not be empty"];
        [self dismissKeyboard];
        return;
    }
    
    min= [minLimit.text integerValue];
    max= [maxLimit.text integerValue];

    if ( [self isValidRange:min andMax:max]) {
        [self displayAlert:@"Invalid Range" Message:@"Max value should be greater than Min value"];
        [self dismissKeyboard];
        return;
    }

    if ( [self isMinEmpty] )
        minLimit.text=@"0";
  
    randomNumber = (NSInteger)(min + arc4random_uniform(max - min + 1));
    
    randomLabel.text=[NSString stringWithFormat:@"%d", randomNumber];
    [randomLabel setTextAlignment:NSTextAlignmentCenter];
    [randomLabel sizeToFit];
    
}

-(void) dismissKeyboard {
    [minLimit resignFirstResponder];
    [maxLimit resignFirstResponder];
}

-(void)cancelNumberPad{
    
    if ( [minLimit isFirstResponder])
        minLimit.text=@"";
    else
        maxLimit.text=@"";
    
    [self dismissKeyboard];

}

-(void)doneWithNumberPad {
    [self dismissKeyboard];
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


-(UITextField *) createText:(float)left Top:(float)top Width:(float)width Height:(float)height Tag:(int) tag
Color:(UIColor *) color Font:(UIFont *) font BorderStyle:(UITextBorderStyle) borderStyle Align:(NSTextAlignment) align Keyboard:(UIKeyboardType) keyBoardType ReturnKeyType:(UIKeyboardType) keyBoardReturn {
    
    UITextField *tmpTxt = [[UITextField alloc] initWithFrame:CGRectMake(left, top, width, height)];
    [tmpTxt setTag:tag];
    [tmpTxt setFont:font];
    [tmpTxt setTextAlignment:align];
    [tmpTxt setBackgroundColor:color];
    [tmpTxt setBorderStyle:borderStyle];
    [tmpTxt setKeyboardType:keyBoardType];
    [tmpTxt setReturnKeyType:keyBoardReturn];

    return [tmpTxt autorelease];
    
}


-(UIButton *) createButton:(float)left Top:(float)top Width:(float)width Height:(float)height Tag:(int) tag
                     Color:(UIColor *) color Font:(UIFont *) font Text:(NSString *) text Align:(NSTextAlignment) align {
    
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpBtn.frame=CGRectMake(left,top,width,height);
    [tmpBtn setTitleColor:color forState:UIControlStateNormal];
    [tmpBtn setTitle:text forState:UIControlStateNormal];
    tmpBtn.titleLabel.font= font;
    [tmpBtn setTag:tag];
    [tmpBtn setBackgroundColor:[UIColor whiteColor]];
    return tmpBtn;
    
}

-(void) dealloc {
    [super dealloc];
    [minLimit release];
    [maxLimit release];
}

@end
