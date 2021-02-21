//
//  DLPRDocumentInfo.h
//  DLPDFRenderer
//
//  Created by Vincent Esche on 12/4/13.
//  Copyright (c) 2013 Vincent Esche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLPRDocumentInfo : NSObject

@property (readwrite, copy, nonatomic) NSString *author;
@property (readwrite, copy, nonatomic) NSString *creator;
@property (readwrite, copy, nonatomic) NSString *title;
@property (readwrite, copy, nonatomic) NSString *ownerPassword;
@property (readwrite, copy, nonatomic) NSString *userPassword;
@property (readwrite, copy, nonatomic) NSString *subject;
@property (readwrite, copy, nonatomic) NSArray *keywords;
@property (readwrite, assign, nonatomic) NSUInteger encryptionKeyLength;
@property (readwrite, assign, nonatomic) BOOL allowsPrinting;
@property (readwrite, assign, nonatomic) BOOL allowsCopying;

- (NSDictionary *)asDictionary;

@end
