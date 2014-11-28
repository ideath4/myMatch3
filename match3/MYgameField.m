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
    }
    [self drawField];

    
}

-(void)drawField{

    cellSize = self.frame.size.width/NUMBER_OF_CELLS;
    for (int i = 0; i < NUMBER_OF_CELLS ; i++) {
        for (int j = 0; j < NUMBER_OF_CELLS ; j++) {
            CGRect cellRect = CGRectMake(cellSize*i, cellSize*j, cellSize, cellSize);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if ([game cellSelectedRow:i Column:j]) CGContextDrawImage(context, cellRect, selectedImage);
                else CGContextDrawImage(context, cellRect, emptyImage);
            CGContextDrawImage(context, cellRect, [game imageRow:i Column:j]);
        }
    }
}
-(void)startNewGame:(MYgameModel *)newGame{
    game = newGame;
    [self setNeedsDisplay];

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

-(void)tappedInPoint:(CGPoint)point{
    int columnSelected = point.x/cellSize;
    int rowSelected = point.y/cellSize;
    [game cellTappedRow:rowSelected Column:columnSelected];
    [self setNeedsDisplay];
}
@end
