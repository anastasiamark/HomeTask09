//
//  AppDelegate.m
//  HomeWork09
//
//  Created by Mark on 16.09.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "AppDelegate.h"
#import "AMSquareMatrix.h"
#import "AMMatrixCalculator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AMSquareMatrix *matrix1 = [AMSquareMatrix matrixWithDimension:3];
    AMSquareMatrix *matrix2 = [AMSquareMatrix matrixWithDimension:3];
    [matrix1 setRandomElements];
    [matrix2 setRandomElements];
    
    NSLog(@"matrix1: %@", matrix1);
    NSLog(@"matrix2: %@", matrix2);
    
    AMSquareMatrix *matrix3 = [matrix1 copy];
    
    NSLog(@"matrix3: %@", matrix3);

    [matrix1 isEqual:matrix3] ? NSLog(@"matrix1 == martix3") : NSLog(@"matrix1 != martix3");
    [matrix1 isEqual:matrix2] ? NSLog(@"matrix1 == martix2") : NSLog(@"matrix1 != martix2");
    
    [AMMatrixCalculator invertMatrix:matrix1 withCompletion:^(AMSquareMatrix *resultMatrix) {
        NSLog(@"Inverse of matrix1: %@", resultMatrix);
    }];

    AMSquareMatrix *matrix4 = [AMSquareMatrix matrixWithDimension:5];
    [matrix4 setRandomElements];
    
    [AMMatrixCalculator addMatrix1:matrix1 andMatrix2:matrix2 withCompletion:^(AMSquareMatrix *resultMatrix) {
        NSLog(@"Adding matrix: %@", resultMatrix);
    }];
    
    [AMMatrixCalculator multiplyMatrix1:matrix1 andMatrix2:matrix3 withCompletion:^(AMSquareMatrix *resultMatrix) {
        NSLog(@"Multiplying matrix: %@", resultMatrix);
    }];

    [AMMatrixCalculator multiplyMatrix1:matrix1 andScalar:-1 withCompletion:^(AMSquareMatrix *resultMatrix) {
        NSLog(@"Multiply matrix and scalar: %@", resultMatrix);
    }];

    [AMMatrixCalculator subtractMatrix1:matrix1 andMatrix2:matrix3 withCompletion:^(AMSquareMatrix *resultMatrix) {
        NSLog(@"Subtracting matrix: %@", resultMatrix);
    }];
    
    [AMMatrixCalculator subtractMatrix1:matrix1 andMatrix2:matrix2 withCompletion:^(AMSquareMatrix *resultMatrix) {
        NSLog(@"Subtracting matrix: %@", resultMatrix);
    }];
    
    return YES;
}

@end
