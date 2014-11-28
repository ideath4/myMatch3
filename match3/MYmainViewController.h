//
//  MYmainViewController.h
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYgameField.h"
#import "MYgameModel.h"

@interface MYmainViewController : UIViewController
{
    MYgameModel *game;
}@property (weak, nonatomic) IBOutlet MYgameField *gameField;
@property (weak, nonatomic) IBOutlet UIButton *startPressed;
- (IBAction)startPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
