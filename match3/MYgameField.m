//
//  MYgameField.m
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import "MYgameField.h"

@implementation MYgameField
int numberOfCells = 8;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self initField];
    [self drawField];

    
}

-(void)drawField{
    NSString *emptyCellName = [[NSString alloc]initWithFormat:@"emptyCell.png"];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:emptyCellName ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    CGImageRef image = CGImageRetain(img.CGImage);
    int cellSize = self.frame.size.width/numberOfCells;
    for (int i = 0; i < numberOfCells ; i++) {
        for (int j = 0; j < numberOfCells ; j++) {
            CGRect cellRect = CGRectMake(cellSize*i, cellSize*j, cellSize, cellSize);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, cellRect, image);
            CGContextDrawImage(context, cellRect, fieldArray[i][j].image);
        }
    }
}

-(void)initField{
    for (int i = 0; i < numberOfCells ; i++) {
        for (int j = 0; j < numberOfCells ; j++) {
            fieldArray [i] [j] = [MYgameElement initRandomElement];
        }
    }
}

@end
