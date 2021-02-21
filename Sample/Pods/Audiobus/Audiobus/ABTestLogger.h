//
//  ABTestLogger.h
//  Audiobus SDK
//
//  Created by Michael Tyson on 10/2/19.
//  Copyright © 2019 Audiobus Pty. Ltd. All rights reserved.
//

/*!
 * Quick-and-dirty log utility for debugging issues
 *
 *  Don't use this in production code (as it will briefly hold a lock), but it can be useful
 *  for debugging issues with realtime code, as it's much faster than using log statements and
 *  won't spam the console.
 *
 *  Use ABTestLogDump() from the debugger to dump the last 100 lines.
 */
void ABTestLog(const char * log, ...);

/*!
 * Print out last 100 log lines
 */
void ABTestLogDump(void);
