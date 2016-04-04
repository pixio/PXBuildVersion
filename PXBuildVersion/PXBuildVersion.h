//
//  PXBuildVersion.h
//
// Copyright (c) 2016 Pixio <pixio.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>

/// PXBuildVersion contains numerous class methods exposing information about the build of the application.
@interface PXBuildVersion : NSObject

/// Display application version from the app Info.plist
+ (nullable NSString*) displayVersion;

/// Build version from the app Info.plist
+ (nullable NSString*) buildVersion;


#pragma mark -

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

/// Date that the build was initiated.
+ (nonnull NSDate*) buildDate;

/// The commit hash
+ (nullable NSString*) commit;

/// An abbreviated version of the commit hash
+ (nullable NSString*) shortCommit;

/**
 *  The branch that was built. In the case of multiple branches corresponding to
 *  the same commit, this will return a branch chosen from the list of all
 *  branches, prioritizing remote branches over local branches. The branch name
 *  returned does not include the remote name.
 */
+ (nullable NSString*) branch;

/// A list of local branches corresponding to the commit.
+ (nonnull NSArray<NSString*>*) localBranches;

/**
 *  A list of remote branches corresponding to the commit.
 *
 *  @note Branches here will include the remote name.
 */
+ (nonnull NSArray<NSString*>*) remoteBranches;

/// Tag corresponding to the commit.
+ (nullable NSString*) tag;

/// A list of tags corresponding to the commit.
+ (nonnull NSArray<NSString*>*) tags;

/// Whether or not the build was made when the repo status was dirty.
+ (BOOL) isDirty;

/**
 *  A dictionary of environment variable key-value pairs
 *
 *  By default, only a few select key-value pairs are pulled in (see categories
 *  below). To add more, adjust the Pod setup script. Consult the README for
 *  more additional details.
 */
+ (nonnull NSDictionary<NSString*, NSString*>*)environmentVariables;

/// Alias for `+environmentVariables`
+ (nonnull NSDictionary<NSString*, NSString*>*)ENV;

@end



@interface PXBuildVersion (Xcode)

/**
 *  The Xcode build configuration
 *
 *  @note Env variable: CONFIGURATION
 */
+ (nullable NSString*) buildConfiguration;

@end



@interface PXBuildVersion (ContinuousIntegration)

/**
*  JenkinsCI Build Number
*
*  @note Env variable: BUILD_NUMBER
*/
+ (nullable NSNumber*)jenkinsBuildNumber;

/**
 *  Travis CI Build Number
 *
 *  @note Env variable: TRAVIS_BUILD_NUMBER
 */
+ (nullable NSNumber*)travisBuildNumber;

/**
 *  Travis CI Job Number
 *
 *  Example:  4563.1
 *
 *  @note Env variable: TRAVIS_JOB_NUMBER
 */
+ (nullable NSString*)travisJobNumber;

/**
 *  Circle CI Build Number
 *
 *  @note Env variable: CIRCLE_BUILD_NUM
 */
+ (nullable NSString*)circleBuildNumber;

@end
