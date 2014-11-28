//
//  MYgameField.h
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYgameElement.h"
#import "MYgameModel.h"

@interface MYgameField : UIView{
    CGImageRef emptyImage;
    CGImageRef selectedImage;
    int cellSize;
    BOOL gameStarted;
    MYgameModel *game;
}
-(void)startNewGame:(MYgameModel*)newGame;
-(void)tappedInPoint:(CGPoint)point;
@end
