//
//  DLPRRenderer.h
//  DLPDFRenderer
//
//  Created by Vincent Esche on 12/4/13.
//  Copyright (c) 2013 Vincent Esche. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLPRPage.h"
#import "DLPRDocumentInfo.h"

@class DLPRRenderer;

@protocol DLPRRendererDataSource <NSObject>

- (BOOL)renderer:(DLPRRenderer *)renderer hasReachedLastPageAtIndex:(NSUInteger)pageIndex;
- (id<DLPRPage>)renderer:(DLPRRenderer *)renderer pageAtIndex:(NSUInteger)pageIndex;

@end

@protocol DLPRRendererDelegate <NSObject>

- (void)renderer:(DLPRRenderer *)renderer finishedWithData:(NSData *)data orFile:(NSString *)file;
- (void)renderer:(DLPRRenderer *)renderer failedWithError:(NSError *)error;

@optional
- (void)renderer:(DLPRRenderer *)renderer preparePageAtIndex:(NSUInteger)index;
- (void)renderer:(DLPRRenderer *)renderer finishedPageAtIndex:(NSUInteger)index;
- (void)renderer:(DLPRRenderer *)renderer failedPageAtIndex:(NSUInteger)index;

@end

typedef void(^DLPRRendererPageCallbackBlock)(CGContextRef context, id<DLPRPage> page, CGRect pageBounds, CGRect paperRect, NSDictionary *boxInfo, NSUInteger currentPageIndex);

@interface DLPRRenderer : NSObject

@property (readonly, weak, nonatomic) id<DLPRRendererDataSource> dataSource;
@property (readonly, weak, nonatomic) id<DLPRRendererDelegate> delegate;

@property (readwrite, strong, nonatomic) NSURL *defaultBaseURL;
@property (readwrite, copy, nonatomic) DLPRRendererPageCallbackBlock pageCallbackBlock;

- (id)initWithDataSource:(id<DLPRRendererDataSource>)dataSource delegate:(id<DLPRRendererDelegate>)delegate;
- (id)initWithWebView:(UIWebView *)webview dataSource:(id<DLPRRendererDataSource>)dataSource delegate:(id<DLPRRendererDelegate>)delegate;

- (void)renderToDataWithDocumentInfo:(DLPRDocumentInfo *)documentInfo;
- (void)renderToFile:(NSString *)file withDocumentInfo:(DLPRDocumentInfo *)documentInfo;

@end
