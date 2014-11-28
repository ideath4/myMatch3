//
//  MYgameModel.h
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYgameElement.h"

@interface MYgameModel : NSObject{
    MYgameElement *fieldArray [8] [8];
    NSMutableArray *selectedCells;
    int lastSelectedRow,lastSelectedColumn;
    int score;
}
-(BOOL)cellSelectedRow:(int)row Column:(int)column;
-(CGImageRef)imageRow:(int)row Column:(int)column;
-(void)cellTappedRow:(int)rowSelected Column:(int)columnSelected;
-(void)startGame;
-(NSString*)getScore;
@end
