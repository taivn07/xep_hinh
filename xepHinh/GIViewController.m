//
//  GIViewController.m
//  xepHinh
//
//  Created by MAI THE TAI on 2014/02/15.
//  Copyright (c) 2014年 MAI THE TAI. All rights reserved.
//

#import "GIViewController.h"
#import "UIImage+Cutter.h"

@interface GIViewController ()

@property (nonatomic) int currentEmptyPossition;
@property (nonatomic) int row;
@property (nonatomic) int col;
@property (nonatomic) int width;
@property (nonatomic) int height;

@end

@implementation GIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _row = 4;
    _col = 3;
    _width = 300;
    _height = 400;
    
    _currentEmptyPossition = _row * _col - 1;
    [self drawView:self.col rowNum:self.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawView: (int)colNum rowNum: (int)rowNum {
    // create backgroundView
    CGRect frame = CGRectMake(10.0f, 100.0f, (CGFloat)self.width, (CGFloat)self.height);
    UIView  *backGroundView = [[UIView alloc] initWithFrame:frame];
    backGroundView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backGroundView];
    
    // create elementImageView inside backgroundView
    CGFloat subViewWidth = (self.width/colNum);
    CGFloat subViewHeight = (self.height/rowNum);
    
    // cut image
    NSArray *images = [UIImage cutImage:[UIImage imageNamed:@"trang.png"] withColumn:self.col row:self.row];
    NSLog(@"%i", images.count);
    
    int tag = 0;
    // row = 4, col = 3
    for (int i=0; i < rowNum; i++) {
        for (int j=0; j < colNum; j++) {
            NSLog(@"%i", tag);
            if (tag < (rowNum * colNum - 1)) {
                CGRect subFrame = CGRectMake((CGFloat)((j % colNum) * subViewWidth), (CGFloat)((i %rowNum) * subViewHeight), subViewWidth, subViewHeight);

                UIImageView *subImageView = [[UIImageView alloc] initWithImage:images[tag]];
                subImageView.frame = subFrame;
                subImageView.userInteractionEnabled = YES;
                subImageView.tag = tag;
                
                // add swipe left or right guesture
                UISwipeGestureRecognizer *swipeLeftRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandle:)];
                [swipeLeftRightGesture setDirection:(UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight)];
                [subImageView addGestureRecognizer:swipeLeftRightGesture];
                // add swipe up or down guesture
                UISwipeGestureRecognizer *swipeUpDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandle:)];
                [swipeUpDownGesture setDirection:(UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp)];
                [subImageView addGestureRecognizer:swipeUpDownGesture];
                
                [backGroundView addSubview:subImageView];
            }
            tag++;
        }
    }
}

- (NSArray *)possibleMovePosition: (int)position colNum: (int)colNum rowNum: (int)rowNum {
    NSMutableArray *array = [NSMutableArray new];
    
    if (!(position % colNum == 0)) {
        [array addObject:@(position - 1)];
    }
    
    if (!(position < colNum)) {
        [array addObject:@(position - colNum)];
    }
    
    if (!((position + 1) % colNum == 0)) {
        [array addObject:@(position + 1)];
    }
    
    if (!((position + colNum) > colNum * rowNum - 1)) {
        [array addObject:@(position + colNum)];
    }

    NSLog(@"%@", array);
    return [array copy];
}

- (BOOL) isMove: (int)move possibleForPosition: (int)position colNum: (int)colNum rowNum: (int)rowNum {
    NSArray *possitionMoves = [self possibleMovePosition:position colNum: colNum rowNum:rowNum];
    
    for ( NSNumber *moveable in  possitionMoves) {
        if (move == moveable.intValue) {
            return YES;
        }
    }
    
    return NO;
}

- (CGPoint) locationForPosition: (int) position colNum: (int)colNum rowNum: (int)rowNum {
    CGFloat subViewWidth = (self.width/colNum);
    CGFloat subViewHeight = (self.height/rowNum);
    
    
    return CGPointMake(subViewWidth/2 + (position % colNum)*subViewWidth,
                       subViewHeight/2 + round(position / colNum)*subViewHeight);
}

- (void)pinchHandle: (UISwipeGestureRecognizer *)sender {
    int tag = sender.view.tag;
    
    if ([self isMove:tag possibleForPosition:self.currentEmptyPossition colNum:self.col rowNum:self.row]) {
        sender.view.center = [self locationForPosition:self.currentEmptyPossition colNum:self.col rowNum:self.row];
        sender.view.tag = self.currentEmptyPossition;
        self.currentEmptyPossition = tag;
    }
}

@end
