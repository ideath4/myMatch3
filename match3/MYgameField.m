//
//  MYgameField.m
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import "MYgameField.h"
#import "MYConstants.h"

@implementation MYgameField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.width)];

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (!gameStarted) {
        [self initImages];
        [self initField];
        selectedCells = [[NSMutableArray alloc]init];
    }
    [self drawField];

    
}

-(void)drawField{

    cellSize = self.frame.size.width/NUMBER_OF_CELLS;
    for (int i = 0; i < NUMBER_OF_CELLS ; i++) {
        for (int j = 0; j < NUMBER_OF_CELLS ; j++) {
            CGRect cellRect = CGRectMake(cellSize*i, cellSize*j, cellSize, cellSize);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (fieldArray[i][j].selected) CGContextDrawImage(context, cellRect, selectedImage);
                else CGContextDrawImage(context, cellRect, emptyImage);
            
            CGContextDrawImage(context, cellRect, fieldArray[i][j].image);
        }
    }
}

-(void)initField{
    gameStarted = YES;
    for (int i = 0; i < NUMBER_OF_CELLS ; i++) {
        for (int j = 0; j < NUMBER_OF_CELLS ; j++) {
            fieldArray [i] [j] = [MYgameElement initRandomElement];
        }
    }
}

-(void)initImages{
    NSString *emptyCellName = [[NSString alloc]initWithFormat:@"emptyCell.png"];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:emptyCellName ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    emptyImage = CGImageRetain(img.CGImage);
    NSString *selectedCellName = [[NSString alloc]initWithFormat:@"selectedCell.png"];
    NSString *delectedImagePath = [[NSBundle mainBundle]pathForResource:selectedCellName ofType:nil];
    UIImage *selectedImg = [UIImage imageWithContentsOfFile:delectedImagePath];
    emptyImage = CGImageRetain(img.CGImage);
    selectedImage = CGImageRetain(selectedImg.CGImage);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if ([touch view]== self) {
        CGPoint pointPressed = [touch locationInView:self];
        int columnSelected = (int)pointPressed.x/cellSize;
        int rowSelected = (int)pointPressed.y/cellSize;
        if ([self isMovePossibleRow:rowSelected Column:columnSelected]) [self makeMoveRow:rowSelected Column:columnSelected];
        else
            [self unselectCells];
        [self setNeedsDisplay];
    }
}

-(void)makeMoveRow:(int)row Column:(int)column{
    fieldArray[column][row].selected = !fieldArray[column][row].selected;
    [selectedCells addObject:fieldArray[column][row]];
    lastSelectedRow = row;
    lastSelectedColumn = column;
    if ((![self havePossibleMovesRow:row Column:column])&&([selectedCells count]>1)) [self removeSelectedCells];
}

-(void)removeSelectedCells{
    [selectedCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        for (int i = 0; i<NUMBER_OF_CELLS; i++) {
            for (int j = 0; j<NUMBER_OF_CELLS; j++) {
                if ([fieldArray[i][j]isEqual:obj]) fieldArray[i][j] = 0;
            }
        }
    }];
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
-(void)unselectCells{
    for (int i = 0; i < NUMBER_OF_CELLS ; i++) {
        for (int j = 0; j < NUMBER_OF_CELLS ; j++) {
            fieldArray [i] [j].selected = NO ;
            [selectedCells removeAllObjects];
        }
    }
    [self setNeedsDisplay];
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
@end
