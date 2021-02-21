# DLPDFRenderer

**DLPDFRenderer** is a **lightweight solution** for generating **multi-page PDFs** from arbitrary **HTML input**.

## Features

* **Simple [API](DLPDFRenderer/Classes/DLPDFRenderer.h)** using **DataSource**/**Delegate**.
* Renders PDF into `NSData` or file.
* Individual page sizes and printable rects.
* Set page's width or height to `0.0` to have it deduced from web content. (experimental)
* Specify individual **media-**, **crop-**, **bleed-**, **trim-**, **art-boxes** per page (optional).
* Set document properties: **author**, **creator**, **title**, **keywords** (optional).
* **Secure** rendered PDF files with **owner-** and/or **user-password** (optional).
* Specify **encryption key length** (optional).
* Lock copying and/or printing (optional).

**DLPDFRenderer** works great when paired with an HTML **[templating engine](https://github.com/groue/GRMustache)**!

## Installation

Just copy the files in `"DLPDFRenderer/Classes/..."` into your project.

Alternatively you can install **DLPDFRenderer** into your project with [CocoaPods](http://beta.cocoapods.org/).  
Just add it to your Podfile: `pod 'DLPDFRenderer'`

## Usage

See [`DLPRRenderer.h`](DLPDFRenderer/Classes/DLPRRenderer.h) for the complete API and [`DLPRViewController.m`](DLPDFRenderer/DLPRViewController.m) for a simple use case.

### Example usage

```objc
- (void)startRender {
    // Init a renderer:
    self.renderer = [[DLPRRenderer alloc] initWithDataSource:self delegate:self];

    // start render, either to NSData:
    [self.renderer renderToDataWithDocumentInfo:nil];

    // or directly to a file:
    // [self.renderer renderToFile:@"path/to/test.pdf" withDocumentInfo:nil];
}

#pragma mark - DLPRRendererDataSource Protocol

- (BOOL)renderer:(DLPRRenderer *)renderer hasReachedLastPageAtIndex:(NSUInteger)pageIndex {
    return ...;
}

- (id<DLPRPage>)renderer:(DLPRRenderer *)renderer pageAtIndex:(NSUInteger)pageIndex {
    NSString *source = ...;
	DLPRSourcePage *page = [[DLPRSourcePage alloc] initWithSource:source];
	
	CGSize paperSize = [DLPRSourcePage paperSizeForISO216A:4 forOrientation:DLPRPageOrientationPortrait];
	page.paperSize = paperSize;
	
	CGFloat insetInInches = 0.5;
	CGFloat insetPixels = insetInInches * [DLPRSourcePage resolution];
	page.margins = DLPRPageMarginsMakeUniform(insetInPixels);
	
    return page;
}

#pragma mark - DLPRRendererDelegate Protocol

- (void)renderer:(DLPRRenderer *)renderer finishedWithData:(NSData *)data orFile:(NSString *)file {
	if (data) {
		[self.webview loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
	} else if (file) {
		[self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:file]]];
	}
}

- (void)renderer:(DLPRRenderer *)renderer failedWithError:(NSError *)error {
	// handle failure
}

```

### Custom Drawing

For those situations where you might want to draw a header/footer above/below or a watermark on top of the page content **DLPDFRenderer** provides you with an optional page-wise callback block:

The following sample snippet draws a red rect on top of the rendered page:

	renderer.pageCallbackBlock = ^(CGContextRef context, id<DLPRPage> page, CGRect pageBounds, CGRect paperRect, NSDictionary *boxInfo, NSUInteger currentPageIndex) {
		CGContextSetFillColorWithColor(context, [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor);
		CGContextFillRect(context, CGRectInset(pageBounds, 100.0, 100.0));
	};

### Advanced usage

For those situations where you'd rather want to inject assets (such as images) into your PDFs directly (without writing them to disk first, or if you want to include both local and remote assets), one can include them via a custom URL scheme: `<img src="test://asset_id" />` and have them handled by a custom NSURLProtocol subclass:

```objc

@interface YourCustomURLProtocol : NSURLProtocol

@end

@implementation YourCustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([request.URL.scheme caseInsensitiveCompare:@"test"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    if ([self isRequestForImage]) {
        [self loadPNGImageForURL:self.request.URL];
    } else {
        // ...
    }
}

- (void)stopLoading {
    
}

- (void)loadPNGImageForURL:(NSURL *)url {
    UIImage *image = [... inMemoryImageForURL:url]]; //cache it if appropriate
    NSData *data = UIImagePNGRepresentation(image);
    if (image) {
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:@"utf-8"];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    } else {
        [self.client URLProtocol:self didFailWithError:...];
    }
}

@end
```

Don't forget to call…

```objc
[NSURLProtocol registerClass:[YourCustomURLProtocol class]];
```

…at some point before starting the actual rendering.

## Demos

**DLPDFRenderer** contains a demo app giving you a quick overview of how to use the renderer class.

## ARC

**DLPDFRenderer** uses **automatic reference counting (ARC)**.

## Dependencies

None.

## Creator

Vincent Esche ([@regexident](http://twitter.com/regexident))

## License

**DLPDFRenderer** is available under a **modified BSD-3 clause license** with the **additional requirement of attribution**. See the `LICENSE` file for more info.
