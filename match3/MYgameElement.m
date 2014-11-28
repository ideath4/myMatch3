//
//  MYgameElement.m
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import "MYgameElement.h"

@implementation MYgameElement
+(MYgameElement*)initRandomElement{
    MYgameElement *newElement = [[MYgameElement alloc]init];
    newElement.type = rand()%3;
    newElement.selected = NO;
    NSString *emptyCellName = [[NSString alloc]initWithFormat:@"%d.png",newElement.type];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:emptyCellName ofType:nil];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    CGImageRef image = CGImageRetain(img.CGImage);
    newElement.image = image;
    return newElement;
}
@end
