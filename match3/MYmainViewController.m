//
//  MYmainViewController.m
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import "MYmainViewController.h"

@interface MYmainViewController ()

@end

@implementation MYmainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startPressed:(id)sender {
    game = [[MYgameModel alloc]init];
    _scoreLabel.text = @"0";
    [game startGame];
    [_gameField startNewGame:game];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if ([touch view] == self.gameField) {
        CGPoint pointPressed = [touch locationInView:self.gameField];
        [self.gameField tappedInPoint:pointPressed];
        _scoreLabel.text = [NSString stringWithFormat:@"%@",[game getScore]];
    }
}
@end
