//
//  AMSquareMatrix.h
//  HomeWork09
//
//  Created by Mark on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMSquareMatrix : NSObject

@property (nonatomic, readonly) NSInteger dimension;

+ (instancetype)matrixWithDimension:(NSInteger)dimension;

- (void)setRandomElements;
- (id)objectForRow:(NSInteger)row andColumn:(NSInteger)colum;
- (void)setObject:(id)object forRow:(NSInteger)row andColumn:(NSInteger)column;

@end
