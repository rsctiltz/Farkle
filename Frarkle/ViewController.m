//
//  ViewController.m
//  Frarkle
//
//  Created by Blake Mitchell on 5/21/14.
//  Copyright (c) 2014 Blake Mitchell. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"

@interface ViewController () <DieLabelDelegate>

@property (nonatomic, strong)IBOutlet DieLabel *die1;
@property (nonatomic, strong)IBOutlet DieLabel *die2;
@property (nonatomic, strong)IBOutlet DieLabel *die3;
@property (nonatomic, strong)IBOutlet DieLabel *die4;
@property (nonatomic, strong)IBOutlet DieLabel *die5;
@property (nonatomic, strong)IBOutlet DieLabel *die6;
@property NSArray *labelArray;
@property NSMutableArray *selectedDieArrayAfterRoll;
@property (nonatomic, strong)IBOutlet UILabel *userScore;
@property NSString *whichPlayer;
@property (nonatomic, strong)IBOutlet UILabel *whichPlayerLabel;
@property (nonatomic, strong)IBOutlet UILabel *playerOneScoreLabel;
@property (nonatomic, strong)IBOutlet UILabel *playerTwoScoreLabel;
@property (nonatomic, strong)IBOutlet UIButton *cashOutButton;
@property NSNumber *playerOneScore;
@property NSNumber *playerTwoScore;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.labelArray = [NSArray arrayWithObjects:self.die1,
                       self.die2,
                       self.die3,
                       self.die4,
                       self.die5,
                       self.die6,
                       nil];

    self.selectedDieArrayAfterRoll = [[NSMutableArray alloc]init];
    
    self.die1.delegate = self;
    self.die2.delegate = self;
    self.die3.delegate = self;
    self.die4.delegate = self;
    self.die5.delegate = self;
    self.die6.delegate = self;

    for (DieLabel *die in self.labelArray) {
        die.text = @"1";

    self.playerOneScore = 0;
    self.playerTwoScore = 0;

    }
}

- (IBAction)onRollButtonPressed:(id)sender
{

    if (self.selectedDieArrayAfterRoll.count == 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Turn Over" message:@"Switch Player" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self whichPlayersTurn];
        [self resetBoard];
    }

    for (DieLabel *eachDieLabel in self.labelArray) {

        eachDieLabel.value = [eachDieLabel.text intValue];

        if (![self.selectedDieArrayAfterRoll containsObject:eachDieLabel]) {
              [eachDieLabel roll];

                ///

        } else {
            if (!self.editing) {

                NSNumber *score = [self returnScore:self.selectedDieArrayAfterRoll exisitingScore:self.playerOneScore];
                self.playerOneScore = score;
                self.playerOneScoreLabel.text = [NSString stringWithFormat:@"%d", score.intValue];

            } else {
                NSNumber *score = [self returnScore:self.selectedDieArrayAfterRoll exisitingScore:self.playerTwoScore];
                self.playerTwoScore = score;
                self.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%d", score.intValue];

            }
        }
    }
}

- (void)didChooseDie:(DieLabel *)dieLabel
{
    [self.selectedDieArrayAfterRoll addObject:dieLabel];
}

- (void)whichPlayersTurn
{
    self.editing = ! self.editing;

    if (!self.editing) {
        [self.selectedDieArrayAfterRoll removeAllObjects];
        self.whichPlayerLabel.text = @"Player 1";

    } else {
        [self.selectedDieArrayAfterRoll removeAllObjects];
        self.whichPlayerLabel.text = @"Player 2";
    }
}

- (IBAction)onCashOutButton:(id)sender
{

    if (!self.editing) {

        NSNumber *score = [self returnScore:self.selectedDieArrayAfterRoll exisitingScore:self.playerOneScore];
        self.playerOneScore = score;
        self.playerOneScoreLabel.text = [NSString stringWithFormat:@"%d", score.intValue];
        [self whichPlayersTurn];
        [self resetBoard];

    } else {
        NSNumber *score = [self returnScore:self.selectedDieArrayAfterRoll exisitingScore:self.playerTwoScore];
        self.playerTwoScore = score;
        self.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%d", score.intValue];
        [self whichPlayersTurn];
        [self resetBoard];
    }
}




#pragma mark - Helper Method

- (void)resetBoard
{
    self.die1.backgroundColor = [UIColor redColor];
    self.die2.backgroundColor = [UIColor redColor];
    self.die3.backgroundColor = [UIColor redColor];
    self.die4.backgroundColor = [UIColor redColor];
    self.die5.backgroundColor = [UIColor redColor];
    self.die6.backgroundColor = [UIColor redColor];

}





- (NSNumber *)returnScore: (NSMutableArray *)array exisitingScore:(NSNumber *)number
{
    NSLog(@"selectedLabelsArray.count is %d", array.count);
    NSLog(@"previous score is %d", [number intValue]);


    number = 0;
    int score = [number intValue];

NSPredicate *diceEqualsOne = [NSPredicate predicateWithFormat:@"value = 1"];
NSArray *diceWithTheNumberOne = [array filteredArrayUsingPredicate:diceEqualsOne];


    if (diceWithTheNumberOne.count >= 3) {
        score += 1000;
    } else {
        score = (score + (diceWithTheNumberOne.count * 100));
    }

NSPredicate *diceEqualsTwo = [NSPredicate predicateWithFormat:@"value = 2"];
NSArray *diceWithTheNumberTwo = [array filteredArrayUsingPredicate:diceEqualsTwo];

    if (diceWithTheNumberTwo.count >= 3) {
        score += 200;
    } else {

    }

NSPredicate *diceEqualsThree = [NSPredicate predicateWithFormat:@"value = 3"];
NSArray *diceWithTheNumberThree = [array filteredArrayUsingPredicate:diceEqualsThree];

    if (diceWithTheNumberThree.count >= 3) {
        score += 300;
    } else {

    }

NSPredicate *diceEqualsFour = [NSPredicate predicateWithFormat:@"value = 4"];
NSArray *diceWithTheNumberFour = [array filteredArrayUsingPredicate:diceEqualsFour];

    if (diceWithTheNumberFour.count >= 3) {
        score += 400;
    } else {

    }

NSPredicate *diceEqualsFive = [NSPredicate predicateWithFormat:@"value = 5"];
NSArray *diceWithTheNumberFive = [array filteredArrayUsingPredicate:diceEqualsFive];



    if (diceWithTheNumberFive.count >= 3) {
        score += 500;
    } else {
        score = (score + (diceWithTheNumberFive.count * 50));
    }

NSPredicate *diceEqualsSix = [NSPredicate predicateWithFormat:@"value = 6"];
NSArray *diceWithTheNumberSix = [array filteredArrayUsingPredicate:diceEqualsSix];


    if (diceWithTheNumberSix.count >= 3) {
        score += 600;
    } else {

    }

NSNumber *newScore = [NSNumber numberWithInt:score];


    if ([newScore intValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Turn Over" message:@"Switch Player" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self whichPlayersTurn];
    }

    return newScore;
}

@end
