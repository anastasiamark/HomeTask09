//
//  AMMatrixCalculator.h
//  HomeWork09
//
//  Created by Mark on 17.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMSquareMatrix;

@interface AMMatrixCalculator : NSObject

+ (void)invertMatrix:(AMSquareMatrix *)matrix withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion;
+ (void)addMatrix1:(AMSquareMatrix *)matrix1 andMatrix2:(AMSquareMatrix *)matrix2 withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion;
+ (void)multiplyMatrix1:(AMSquareMatrix *)matrix1 andMatrix2:(AMSquareMatrix *)matrix2 withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion;
+ (void)multiplyMatrix1:(AMSquareMatrix *)matrix1 andScalar:(NSInteger)integer withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion;
+ (void)subtractMatrix1:(AMSquareMatrix *)matrix1 andMatrix2:(AMSquareMatrix *)matrix2 withCompletion:(void(^)(AMSquareMatrix *resultMatrix))compleion;

@end
