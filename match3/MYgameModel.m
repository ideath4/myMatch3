//
//  MYgameModel.m
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import "MYgameModel.h"

@implementation MYgameModel
-(void)startGame{
    selectedCells = [[NSMutableArray alloc]init];
    [self initField];
}
-(void)initField{
    for (int i = 0; i < NUMBER_OF_CELLS ; i++) {
        for (int j = 0; j < NUMBER_OF_CELLS ; j++) {
            fieldArray [i] [j] = [MYgameElement initRandomElement];
        }
    }
}

-(BOOL)cellSelectedRow:(int)row Column:(int)column{
    return fieldArray[row][column].selected;
}

-(CGImageRef)imageRow:(int)row Column:(int)column{
    return fieldArray[row][column].image;
}

-(void)cellTappedRow:(int)rowSelected Column:(int)columnSelected{
    if ([self isMovePossibleRow:rowSelected Column:columnSelected]) [self makeMoveRow:rowSelected Column:columnSelected];
    else
        [self unselectCells];
}

-(void)makeMoveRow:(int)row Column:(int)column{
    fieldArray[column][row].selected = !fieldArray[column][row].selected;
    [selectedCells addObject:fieldArray[column][row]];
    lastSelectedRow = row;
    lastSelectedColumn = column;
    if ((![self havePossibleMovesRow:row Column:column])&&([selectedCells count]>1)) [self removeSelectedCells];
}

-(void)unselectCells{
    for (int i = 0; i < NUMBER_OF_CELLS ; i++) {
        for (int j = 0; j < NUMBER_OF_CELLS ; j++) {
            fieldArray [i] [j].selected = NO ;
            [selectedCells removeAllObjects];
        }
    }
}

-(void)removeSelectedCells{
    [selectedCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        for (int i = 0; i<NUMBER_OF_CELLS; i++) {
            for (int j = 0; j<NUMBER_OF_CELLS; j++) {
                if ([fieldArray[i][j]isEqual:obj]) fieldArray[i][j] = 0;
            }
        }
    }];
    score += ([selectedCells count]-1)*30;
    [self dropCellsAtEmptyFields];
    [self createNewCells];
    [self unselectCells];
}

-(void)dropCellsAtEmptyFields{
    for (int column = 0; column<NUMBER_OF_CELLS; column++) [self dropCellsOnOneCellInColumn:column];
    
}

-(void)createNewCells{
    for (int i = 0; i<NUMBER_OF_CELLS; i++) {
        for (int j = 0; j<NUMBER_OF_CELLS; j++) {
            if (fieldArray[i][j]==0){
                fieldArray[i][j]= [MYgameElement initRandomElement];
            }
        }
    }
}

-(void)dropCellsOnOneCellInColumn:(int)column{
    for (int i = 0; i<NUMBER_OF_CELLS-1; i++) {
        for (int j = 0; j<NUMBER_OF_CELLS-1; j++) {
            if (fieldArray[column][j+1]==0){
                fieldArray[column][j+1]=fieldArray[column][j];
                fieldArray[column][j] = 0;
            }
        }
    }
}

-(BOOL)havePossibleMovesRow:(int)row Column:(int)column{
    //проверяем возможность хода для угловых клеток
    if ((column == 0)&&(row == 0)) {
        if ((fieldArray[column+1][row].type == fieldArray[column][row].type)&&(!fieldArray[column+1][row].selected)) return YES;
        if ((fieldArray[column][row+1].type == fieldArray[column][row].type)&&(!fieldArray[column][row+1].selected)) return YES;
        return NO;
    }
    if ((column == NUMBER_OF_CELLS-1)&&(row == 0)) {
        if ((fieldArray[column-1][row].type == fieldArray[column][row].type)&&(!fieldArray[column-1][row].selected)) return YES;
        if ((fieldArray[column][row+1].type == fieldArray[column][row].type)&&(!fieldArray[column][row+1].selected)) return YES;
        return NO;
    }
    if ((column == 0)&&(row == NUMBER_OF_CELLS - 1)) {
        if ((fieldArray[column+1][row].type == fieldArray[column][row].type)&&(!fieldArray[column+1][row].selected)) return YES;
        if ((fieldArray[column][row-1].type == fieldArray[column][row].type)&&(!fieldArray[column][row-1].selected)) return YES;
        return NO;
    }
    if ((column == NUMBER_OF_CELLS - 1)&&(row == NUMBER_OF_CELLS - 1)) {
        if ((fieldArray[column-1][row].type == fieldArray[column][row].type)&&(!fieldArray[column-1][row].selected)) return YES;
        if ((fieldArray[column][row-1].type == fieldArray[column][row].type)&&(!fieldArray[column][row-1].selected)) return YES;
        return NO;
    }
    
    
    
    //проверяем возможность хда для клеток у стенок поля
    if (column == 0){
        if ((fieldArray[column+1][row].type == fieldArray[column][row].type)&&(!fieldArray[column+1][row].selected)) return YES;
        if ((fieldArray[column][row-1].type == fieldArray[column][row].type)&&(!fieldArray[column][row-1].selected)) return YES;
        if ((fieldArray[column][row+1].type == fieldArray[column][row].type)&&(!fieldArray[column][row+1].selected)) return YES;
        return NO;
    }
    if (row == 0){
        if ((fieldArray[column-1][row].type == fieldArray[column][row].type)&&(!fieldArray[column-1][row].selected)) return YES;
        if ((fieldArray[column+1][row].type == fieldArray[column][row].type)&&(!fieldArray[column+1][row].selected)) return YES;
        if ((fieldArray[column][row+1].type == fieldArray[column][row].type)&&(!fieldArray[column][row+1].selected)) return YES;
        return NO;
    }
    if (column == NUMBER_OF_CELLS-1){
        if ((fieldArray[column-1][row].type == fieldArray[column][row].type)&&(!fieldArray[column-1][row].selected)) return YES;
        if ((fieldArray[column][row-1].type == fieldArray[column][row].type)&&(!fieldArray[column][row-1].selected)) return YES;
        if ((fieldArray[column][row+1].type == fieldArray[column][row].type)&&(!fieldArray[column][row+1].selected)) return YES;
        return NO;
    }
    if (row == NUMBER_OF_CELLS-1){
        if ((fieldArray[column-1][row].type == fieldArray[column][row].type)&&(!fieldArray[column-1][row].selected)) return YES;
        if ((fieldArray[column+1][row].type == fieldArray[column][row].type)&&(!fieldArray[column+1][row].selected)) return YES;
        if ((fieldArray[column][row-1].type == fieldArray[column][row].type)&&(!fieldArray[column][row-1].selected)) return YES;
        return NO;
    }
    
    //проверяем возможность хода у обычных клеток
    if ((fieldArray[column-1][row].type == fieldArray[column][row].type)&&(!fieldArray[column-1][row].selected)) return YES;
    if ((fieldArray[column+1][row].type == fieldArray[column][row].type)&&(!fieldArray[column+1][row].selected)) return YES;
    if ((fieldArray[column][row-1].type == fieldArray[column][row].type)&&(!fieldArray[column][row-1].selected)) return YES;
    if ((fieldArray[column][row+1].type == fieldArray[column][row].type)&&(!fieldArray[column][row+1].selected)) return YES;
    
    
    return NO;//если ходов нету то возвращаем значение NO
}

-(BOOL)isMovePossibleRow:(int)row Column:(int)column{
    
    MYgameElement *lastPressed = [selectedCells lastObject];
    if (fieldArray[column][row].selected) return NO;
    if (([selectedCells count]==0)&&([self havePossibleMovesRow:row Column:column])) return YES;//если выделенных клеток нету то ход правильный
    if ((fieldArray[column][row].type == lastPressed.type)&&((abs(column-lastSelectedColumn)==1)||(abs(row-lastSelectedRow)==1))&&(abs(row-lastSelectedRow)+abs(column-lastSelectedColumn))<=1) return YES;//проверка на правильность хода, клетка должна быть соседней по вертикали или горизонтали, но не одновременно
    return NO;
}
-(NSString*)getScore{
    return [NSString stringWithFormat:@"%d",score];
}
@end
