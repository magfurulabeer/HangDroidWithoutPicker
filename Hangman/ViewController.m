//
//  ViewController.m
//  Hangman
//
//  Created by Magfurul Abeer on 1/14/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
// TODO: Figure out how to check for multiple words aka Hello World
//

#import "ViewController.h"

@interface ViewController ()

@end



@implementation ViewController {
    NSArray *wordList;
    NSDictionary *wordDictionary;
    NSString *currentWordUnchanged;
    NSMutableArray *spaceIndexes;
}


#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Import dictionary from pList
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"words" withExtension:@"plist"];
    wordDictionary = [[NSDictionary alloc] initWithContentsOfURL:url];

    wordList = [wordDictionary allKeys];
  //@[ @"Flatiron", @"Hello", @"World"];
    [self newGame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



# pragma mark - Textfield methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *input = [textField.text uppercaseString];
    
    // If input is part of letters remaining. Check it and then remove it.
    if ( [self.alphabet containsObject:input] ) {
        [self checkIfLetterIsInWord:input];
    } else if (![input isEqualToString:@""]) {
        NSString *title = @"Whoops";
        
        // If input is a used letter, prepare an appropriate alert
        // else prepare an invalid input alert
        NSString *invalid = @"You entered an invalid input. Please enter an unused letter.";
        
        
        
        UIAlertController *invalidInputAlert = [UIAlertController alertControllerWithTitle:title message:invalid preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        [invalidInputAlert addAction:ok];
        [self presentViewController:invalidInputAlert animated:YES completion:nil];
    }
    [textField resignFirstResponder];
    return YES;
}


# pragma mark - Game methods

// Chooses a random word and displays it
// TODO: Reset buttons and picker items. Hide body parts.
-(void)newGame {
    // Initialize new alphabet
    self.alphabet = [[@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" componentsSeparatedByString:@" "] mutableCopy];

    // Initalize array for space index
    spaceIndexes = [@[] mutableCopy];

    // Select random word
    self.currentWord = [self randomWord];
    
    // Convert word into string of underscores and spaces
    self.displayString = [@"" mutableCopy];
    
    for (NSUInteger i = 0; i < [self.currentWord length]; i++) {
        
        NSString *character = [NSString stringWithFormat:@"%c", [self.currentWord characterAtIndex:i] ];
        
// If char is a space, keep index in array and replace the string character with 2 spaces
        if ( [character isEqualToString:@" "] ) {
            [spaceIndexes addObject:@(i)];
            self.displayString = [[self.displayString stringByAppendingString:@"  "] mutableCopy];
        } else {
            self.displayString = [[self.displayString stringByAppendingString:@" _"] mutableCopy];
        }
        
    }

    // Set label to new string
    self.label.text = self.displayString;
    
    // Hide all android body parts except head
    self.androidBody.hidden = YES;
    self.androidLeftArm.hidden = YES;
    self.androidLeftLeg.hidden = YES;
    self.androidRightArm.hidden = YES;
    self.androidRightLeg.hidden = YES;
    
    // Set strikes to 0
    self.strikes = 0;
    
    NSLog(@"%@", spaceIndexes);
}


-(NSString *)randomWord {
    NSUInteger rand = arc4random() % [wordList count];
    currentWordUnchanged = wordList[rand];
    NSString *uppercaseRandomWord = [currentWordUnchanged uppercaseString];
    return uppercaseRandomWord;
}

-(void)checkIfLetterIsInWord:(NSString *)letter {
    
    
    // If word contains the letter then ...
    if ([self.currentWord containsString:letter]) {
        
        // Go through each letter
        for (NSUInteger i = 0; i < [self.currentWord length]; i++) {
            
            NSString *character = [NSString stringWithFormat:@"%c", [self.currentWord characterAtIndex:i]];
            
            
            // If letter matches up with the selected letter, then
            // 1. Replace the appropriate underscore with the letter
            // 2. Remove letter from the current alphabet array
            if ([character isEqualToString:letter]) {
                NSUInteger index = [self convertIndexToUnderscorePosition:i];
                [self.displayString replaceCharactersInRange:NSMakeRange(index, 1) withString:letter];
                [self updateDisplay];
                NSLog(@"%lu", index);
            }
            
            // Check to see if player wins
            [self winCheck];
        }
        
        
        
    } else {
        [self addToHangman];
    }
    [self removeRowWithLetter:letter];

}

// Unnecessary for the most part now
-(NSUInteger)convertIndexToUnderscorePosition:(NSUInteger)index {

    // Default algorithm if word has no spaces or character is before any spaces
    NSUInteger underscorePosition = index * 2 + 1;
    
//    // Go through the index of each space
//    for (NSNumber* indexOfSpace in spaceIndexes) {
//        
//        // Convert the index NSNumber to a NSUInteger
//        NSUInteger indexOfSpaceInteger = [indexOfSpace integerValue];
//        
//        // If index of character is to the right of the space, add 1 to it's index
//        if (index > indexOfSpaceInteger) {
//            NSLog(@"after space");
//            underscorePosition += 0;
//        }
//        
//    }
    
    return underscorePosition;
}




-(void)winCheck {
    NSMutableString *whatTheyGot = [[self.displayString stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
    NSMutableString *whatItShouldBe = [[self.currentWord stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
//    for (NSNumber *indexOfSpace in spaceIndexes) {
//        NSUInteger i = [indexOfSpace integerValue];
//        NSLog(@"i is %lu", i);
//        [whatTheyGot insertString:@" " atIndex:i];
//    }
    
    //NSLog(@"%@", whatTheyGot);
    if ([whatTheyGot isEqualToString:whatItShouldBe]) {
        [self gameOverByWin:YES];
    }
}


-(void)removeRowWithLetter:(NSString *)letter {
    [self.alphabet removeObject:letter];
}

-(void)updateDisplay {
    self.label.text = self.displayString;

}

-(void)addToHangman {
    self.strikes++;
    switch (self.strikes) {
        case 1:
            self.androidBody.hidden = NO;
            break;
        case 2:
            self.androidLeftArm.hidden = NO;
            break;
        case 3:
            self.androidRightArm.hidden = NO;
            break;
        case 4:
            self.androidLeftLeg.hidden = NO;
            break;
        case 5:
            self.androidRightLeg.hidden = NO;
            [self gameOverByWin:NO];
            break;
        default:
            break;
    }
}

-(void)gameOverByWin:(BOOL)playerWon {
    NSString *title;
    NSString *msg;
    if (playerWon) {
        title = @"You win!";
        msg = [NSString stringWithFormat:@"You won!\nThe answer was '%@'!", self.currentWord];
    } else {
        title = @"Game Over";
        msg = [NSString stringWithFormat:@"You lost!\nThe answer was '%@'!", self.currentWord];

    }
    
    UIAlertController *gameOverAlert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restart = [UIAlertAction actionWithTitle:@"Restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self newGame];
    }];
    
    [gameOverAlert addAction:restart];
    
    [self presentViewController:gameOverAlert animated:YES completion:nil]; 
    
}












# pragma mark - Button Actions
// BRUH
- (IBAction)selectLetter:(UIButton *)sender {
    NSString *letter = @""; //[self pickerView:self.picker titleForRow:[self.picker selectedRowInComponent:0] forComponent:0];
    // TODO: Check if letter matches string then change accordingly
    [self checkIfLetterIsInWord:letter];
}

- (IBAction)guessAnswer:(UIButton *)sender {
    // Initialize Alert
    UIAlertController *guessAnswerAlert = [UIAlertController alertControllerWithTitle:@"Guess Answer" message:@"Try to guess the answer? If you're wrong, you lose!" preferredStyle:UIAlertControllerStyleAlert];
    
    [guessAnswerAlert addTextFieldWithConfigurationHandler:^(UITextField *textfield) {
        textfield.placeholder = @"Make a guess";
    }];
    
    // Initialize Alert Actions
    // TODO: Add lose function
    UIAlertAction *guess = [UIAlertAction actionWithTitle:@"Guess" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        // Grab the textfield
        UITextField *textfield = guessAnswerAlert.textFields.firstObject;
        
        // Grab the text and make it uppercase
        NSString *playerGuess = [textfield.text uppercaseString];;
        
        // Set it to the display string
        self.displayString = [playerGuess mutableCopy];
        
        // Check for win
        [self winCheck];
        
        [self gameOverByWin:NO];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    // Add actions to Alert
    [guessAnswerAlert addAction:cancel];
    [guessAnswerAlert addAction:guess];
    
    [self presentViewController:guessAnswerAlert animated:YES completion:nil];
}

- (IBAction)hintButton:(UIButton *)sender {
    NSString *leHint = [NSString stringWithFormat:@"HINT: %@", wordDictionary[currentWordUnchanged]];
    
    UIAlertController *hint = [UIAlertController alertControllerWithTitle:@"Hint" message:leHint preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [hint addAction:ok];
    
    [self presentViewController:hint animated:YES completion:nil];
}

























@end
