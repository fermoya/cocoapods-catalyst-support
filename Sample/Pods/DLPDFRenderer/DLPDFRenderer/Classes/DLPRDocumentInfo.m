//
//  DLPRDocumentInfo.m
//  DLPDFRenderer
//
//  Created by Vincent Esche on 12/4/13.
//  Copyright (c) 2013 Vincent Esche. All rights reserved.
//

#import "DLPRDocumentInfo.h"

@implementation DLPRDocumentInfo

- (id)init {
	self = [super init];
	if (self) {
		self.encryptionKeyLength = 40;
		self.allowsPrinting = YES;
		self.allowsCopying = YES;
	}
	return self;
}

- (NSDictionary *)asDictionary {
	NSMutableDictionary *documentInfo = [NSMutableDictionary dictionary];
	if (self.author) {
		[documentInfo setObject:self.author forKey:(__bridge NSString *)kCGPDFContextAuthor];
	}
	if (self.creator) {
		[documentInfo setObject:self.creator forKey:(__bridge NSString *)kCGPDFContextCreator];
	}
	if (self.title) {
		[documentInfo setObject:self.title forKey:(__bridge NSString *)kCGPDFContextTitle];
	}
	if (self.ownerPassword) {
		[documentInfo setObject:self.ownerPassword forKey:(__bridge NSString *)kCGPDFContextOwnerPassword];
	}
	if (self.userPassword) {
		[documentInfo setObject:self.userPassword forKey:(__bridge NSString *)kCGPDFContextUserPassword];
	}
	if (self.allowsPrinting) {
		[documentInfo setObject:@(self.allowsPrinting) forKey:(__bridge NSString *)kCGPDFContextAllowsPrinting];
	}
	if (self.allowsCopying) {
		[documentInfo setObject:@(self.allowsCopying) forKey:(__bridge NSString *)kCGPDFContextAllowsCopying];
	}
	if (self.subject) {
		[documentInfo setObject:self.subject forKey:(__bridge NSString *)kCGPDFContextSubject];
	}
	if (self.keywords) {
		[documentInfo setObject:self.keywords forKey:(__bridge NSString *)kCGPDFContextKeywords];
	}
	if (self.encryptionKeyLength) {
		[documentInfo setObject:@(self.encryptionKeyLength) forKey:(__bridge NSString *)kCGPDFContextEncryptionKeyLength];
	}
	return documentInfo;
}

@end
