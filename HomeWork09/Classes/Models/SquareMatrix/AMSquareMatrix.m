//
//  AMSquareMatrix.m
//  HomeWork09
//
//  Created by Mark on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "AMSquareMatrix.h"

@interface AMSquareMatrix ()

@property (strong, nonatomic) NSMutableArray *rows;

@end

@implementation AMSquareMatrix

#pragma mark - Accessors

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"%@", [self printMatrix]];
    return desc;
}

#pragma mark - Lifecycle

- (instancetype)initWithDimension:(NSInteger)dimension
{
    self = [super init];
    if (self) {
        _dimension = dimension;
        [self createMatrixWithDimension:_dimension];
    }
    return self;
}

+ (instancetype)matrixWithDimension:(NSInteger)dimension
{
    return [[self alloc] initWithDimension:dimension];
}

#pragma mark - Public methods

- (id)objectForRow:(NSInteger)row andColumn:(NSInteger)column
{
    return self.rows[row][column];
}

- (void)setObject:(id)object forRow:(NSInteger)row andColumn:(NSInteger)column
{
    [self.rows[row] replaceObjectAtIndex:column withObject:object];
}

- (void)setRandomElements
{
    for (NSInteger i = 0; i < self.dimension; i++) {
        for (NSInteger j = 0; j < self.dimension; j++) {
            self.rows[i][j] = @(arc4random()%4);
        }
    }
}

#pragma mark - Private methods

- (NSMutableString *)printMatrix
{
    NSMutableString *matrixString = [NSMutableString string];
    for (NSInteger i = 0; i < self.dimension; i++) {
        NSMutableString *rowString = [NSMutableString string];
        for (NSInteger j = 0; j < self.dimension; j++) {
            [rowString appendFormat:@"%@ ", self.rows[i][j]]; ;
        }
        [matrixString appendFormat:@"\n%@", rowString];
    }
    return matrixString;
}

- (void)createMatrixWithDimension:(NSInteger)demension
{
    _rows = [NSMutableArray arrayWithCapacity:demension];
    for (NSInteger i = 0; i < demension; i++) {
        NSMutableArray *columns  = [NSMutableArray arrayWithCapacity:demension];
        for (NSInteger j = 0; j < demension; j++) {
            [columns setObject:[NSNull null] atIndexedSubscript:j];
        }
        [_rows setObject:columns atIndexedSubscript:i];
    }
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    if (!([[object class] isSubclassOfClass:[self class]]))
        return NO;
    
    return [self isEqualToMatrix:object];
}

- (BOOL)isEqualToMatrix:(AMSquareMatrix *)matrix
{
    if (!matrix)
        return  NO;
    for (NSInteger i = 0; i < self.dimension; i++) {
        for (NSInteger j = 0; j < self.dimension; j++) {
            if ([self.rows[i][j] integerValue] != [matrix.rows[i][j] integerValue]) {
                return  NO;
            }
        }
    }
    return YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    AMSquareMatrix *copy = [[[self class] allocWithZone:zone] initWithDimension:_dimension];
    copy.rows = _rows;
    return  copy;
}

@end
