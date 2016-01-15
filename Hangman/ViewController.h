//
//  ViewController.h
//  Hangman
//
//  Created by Magfurul Abeer on 1/14/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

#pragma mark - IBOutlets

// Android Parts
@property (weak, nonatomic) IBOutlet UIImageView *androidHead;
@property (weak, nonatomic) IBOutlet UIImageView *androidBody;
@property (weak, nonatomic) IBOutlet UIImageView *androidLeftArm;
@property (weak, nonatomic) IBOutlet UIImageView *androidRightArm;
@property (weak, nonatomic) IBOutlet UIImageView *androidLeftLeg;
@property (weak, nonatomic) IBOutlet UIImageView *androidRightLeg;

// Other Elements
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

#pragma mark - Regular Properties
// Current word to guess
@property (strong, nonatomic) NSString *currentWord;

// String that will actually be displayed
@property (strong, nonatomic) NSMutableString *displayString;

// Number of strikes you currently have (5 to lose)
@property (nonatomic) NSUInteger strikes;

// Current letters left
@property (strong, nonatomic) NSMutableArray *alphabet;

#pragma mark - IBActions
- (IBAction)guessAnswer:(UIButton *)sender;
- (IBAction)hintButton:(UIButton *)sender;







@end

