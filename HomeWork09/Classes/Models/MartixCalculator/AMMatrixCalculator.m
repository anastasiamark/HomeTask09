//
//  AMMatrixCalculator.m
//  HomeWork09
//
//  Created by Mark on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "AMMatrixCalculator.h"
#import "AMSquareMatrix.h"

dispatch_queue_t matrix_calculations_queue() {
    
    static dispatch_queue_t matrix_calculations_queue;
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        matrix_calculations_queue = dispatch_queue_create("matrix_calculations_queue", DISPATCH_QUEUE_CONCURRENT);
    });

    return matrix_calculations_queue;
}

@implementation AMMatrixCalculator

#pragma mark - Public methods

+ (void)subtractMatrix1:(AMSquareMatrix *)matrix1 andMatrix2:(AMSquareMatrix *)matrix2 withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion
{
    dispatch_queue_t serialQueue = dispatch_queue_create("matrix_calculations_subtract_queue", DISPATCH_QUEUE_SERIAL);

    __weak typeof(self)weakSelf = self;
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Subtract serial %@", [NSThread currentThread]);

        if (matrix1.dimension != matrix2.dimension) {
            if (compleion) {
                compleion(nil);
            } else {
                return;
            }
        }
        [weakSelf multiplyMatrix1:matrix2 andScalar:-1 withCompletion:^(AMSquareMatrix *resultMatrix) {
            [weakSelf addMatrix1:matrix1 andMatrix2:resultMatrix withCompletion:^(AMSquareMatrix *resultMatrix) {
                if (compleion) {
                    compleion(resultMatrix);
                }
            }];
        }];
    });
}

+ (void)multiplyMatrix1:(AMSquareMatrix *)matrix1 andScalar:(NSInteger)integer withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion
{
    dispatch_queue_t serialQueue = dispatch_queue_create("matrix_calculations_scalar_queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Scalar serial %@", [NSThread currentThread]);

        NSInteger dimension = matrix1.dimension;
        AMSquareMatrix *result = [AMSquareMatrix matrixWithDimension:dimension];
        for (NSInteger i = 0; i < dimension; i++) {
            for (NSInteger j = 0; j < dimension; j++) {
                NSInteger num = integer * [[matrix1 objectForRow:i andColumn:j] integerValue];
                [result setObject:[NSNumber numberWithInteger:num] forRow:i andColumn:j];
            }
        }
        if (compleion) {
            compleion(result);
        }
    });
}

+ (void)multiplyMatrix1:(AMSquareMatrix *)matrix1 andMatrix2:(AMSquareMatrix *)matrix2 withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion
{
    dispatch_queue_t serialQueue = dispatch_queue_create("matrix_calculations_multiply_queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Multiply serial %@", [NSThread currentThread]);

        if (matrix1.dimension != matrix2.dimension) {
            if (compleion) {
                compleion(nil);
            } else {
                return;
            }
        }
        NSInteger dimension = matrix1.dimension;
        AMSquareMatrix *multiplying = [AMSquareMatrix matrixWithDimension:dimension];
        
        for (NSInteger i = 0; i < dimension; i++) {
            for (NSInteger j = 0; j < dimension; j++) {
                NSInteger num = 0;
                for (NSInteger k = 0; k < dimension; k++) {
                    num += [[matrix1 objectForRow:i andColumn:k] integerValue] * [[matrix2 objectForRow:k andColumn:j] integerValue];
                }
                [multiplying setObject:[NSNumber numberWithInteger:num] forRow:i andColumn:j];
            }
        }
        if (compleion) {
            compleion(multiplying);
        }
    });
}

+ (void)addMatrix1:(AMSquareMatrix *)matrix1 andMatrix2:(AMSquareMatrix *)matrix2 withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion
{
    dispatch_queue_t serialQueue = dispatch_queue_create("matrix_calculations_add_queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Add serial %@", [NSThread currentThread]);

        if (matrix1.dimension != matrix2.dimension) {
            if (compleion) {
                compleion(nil);
            } else {
                return;
            }
        }
        NSInteger dimension = matrix1.dimension;
        AMSquareMatrix *sum = [AMSquareMatrix matrixWithDimension:dimension];
        for (NSInteger i = 0; i < dimension; i++) {
            for (NSInteger j = 0; j < dimension; j++) {
                NSInteger num = [[matrix1 objectForRow:i andColumn:j] integerValue] + [[matrix2 objectForRow:i andColumn:j] integerValue];
                [sum setObject:[NSNumber numberWithInteger:num] forRow:i andColumn:j];
            }
        }
        if (compleion) {
            compleion(sum);
        }
    });
}

+ (void)invertMatrix:(AMSquareMatrix *)matrix withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion
{
    dispatch_queue_t serialQueue = dispatch_queue_create("matrix_calculations_invert_queue", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self)weakSelf = self;
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Invert serial %@", [NSThread currentThread]);

        AMSquareMatrix *inverseMatrix = [AMSquareMatrix matrixWithDimension:matrix.dimension];
        NSInteger det = [self getDeterminantOfMartix:matrix];
        if (det == 0) {
            if (compleion) {
                compleion(nil);
            } else {
                return;
            }
        }
        
        [weakSelf getTransposeMatrix:matrix withCompletion:^(AMSquareMatrix *transpose) {
            
            for (NSInteger i = 0; i < matrix.dimension; i++) {
                for (NSInteger j = 0; j < matrix.dimension; j++) {
                    AMSquareMatrix *minor = [weakSelf getMinorOfMatrix:transpose forRow:i andColumn:j];
                    NSInteger detMinor = [weakSelf getDeterminantOfMartix:minor];
                    [inverseMatrix setObject:@((pow(-1, i+j)/det) * detMinor) forRow:i andColumn:j];
                }
            }
            if (compleion) {
                compleion(inverseMatrix);
            }
        }];
        
    });
}

#pragma mark - Private methods

+ (AMSquareMatrix *)getMinorOfMatrix:(AMSquareMatrix *)matrix forRow:(NSInteger)row andColumn:(NSInteger)column
{
    AMSquareMatrix *matrixMinor = [AMSquareMatrix matrixWithDimension:(matrix.dimension - 1)];
    NSInteger rowMinor = 0;
    for (NSInteger i = 0; i < matrix.dimension; i++)
    {
        NSInteger columnMinor = 0;
        if (i == row) {
            continue;
        }
        for (NSInteger j = 0; j < matrix.dimension; j++) {
            if (j == column) {
                continue;
            }
            
            [matrixMinor setObject:[matrix objectForRow:i andColumn:j] forRow:rowMinor andColumn:columnMinor];
            
            columnMinor++;
        }
        rowMinor++;
    }
    return matrixMinor;
}

+ (void)getTransposeMatrix:(AMSquareMatrix *)matrix withCompletion:(void(^)(AMSquareMatrix *resultMatrix))completion
{
    __block AMSquareMatrix *transposeMatrix = [AMSquareMatrix matrixWithDimension:matrix.dimension];
    dispatch_async(matrix_calculations_queue(), ^{
        NSLog(@"Concurrent %@", [NSThread currentThread]);

        for (NSInteger i = 0; i < matrix.dimension; i++) {
            for (NSInteger j = 0; j < matrix.dimension; j++) {
                [transposeMatrix setObject:[matrix objectForRow:j andColumn:i] forRow:i andColumn:j];
            }
        }
        if (completion) {
            completion(transposeMatrix);
        }
    });
}

+ (NSInteger)getDeterminantOfMartix:(AMSquareMatrix *)matrix
{
    if (matrix.dimension == 2) {
        NSInteger det = [[matrix  objectForRow:0 andColumn:0] integerValue] * [[matrix  objectForRow:1 andColumn:1] integerValue] - [[matrix  objectForRow:0 andColumn:1] integerValue] * [[matrix  objectForRow:1 andColumn:0] integerValue];
        return det;
    } else {
        NSInteger det = 0;
        for (NSInteger j = 0; j < matrix.dimension; j++) {
            NSInteger d = pow(-1, j) * [[matrix  objectForRow:0 andColumn:j] integerValue];
            AMSquareMatrix *minor = [self getMinorOfMatrix:matrix forRow:0 andColumn:j];
            NSInteger minorDeterminant = [self getDeterminantOfMartix:minor];
            d = d * minorDeterminant;
            det = det + d;
        }
        return det;
    }
}

@end
