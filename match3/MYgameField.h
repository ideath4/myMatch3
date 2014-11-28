//
//  MYgameField.h
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYgameElement.h"

@interface MYgameField : UIView{
    MYgameElement *fieldArray [8] [8];
    CGImageRef emptyImage;
    CGImageRef selectedImage;
    int cellSize,lastSelectedRow,lastSelectedColumn;
    BOOL gameStarted;
    NSMutableArray *selectedCells;
    
}

@end
