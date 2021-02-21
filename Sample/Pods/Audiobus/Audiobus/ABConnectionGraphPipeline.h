//
//  ABConnectionGraphPipeline.h
//  Audiobus SDK
//
//  Created by Michael Tyson on 3/4/19.
//  Copyright © 2019 Audiobus Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//! Connection graph pipeline type
typedef enum {
    ABConnectionGraphPipelineTypeAudio, //!< Audio pipeline
    ABConnectionGraphPipelineTypeMIDI, //!< MIDI pipeline
} ABConnectionGraphPipelineType;

@class ABPort;

/*!
 * Connection graph pipeline
 *
 * Represents a connection pipeline from within Audiobus.
 */
@interface ABConnectionGraphPipeline : NSObject
@property (nonatomic, readonly) ABConnectionGraphPipelineType type; //!< The pipeline type
@property (nonatomic, readonly) uint32_t identifier; //!< The numeric identifier for this pipeline
@property (nonatomic, strong, readonly) NSArray <ABPort *> * ports; //!< The ports in this pipeline
@end

NS_ASSUME_NONNULL_END
