//
//  PXBuildVersion.m
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

#import "PXBuildVersion.h"

@implementation PXBuildVersion

+ (NSDictionary*)metadata
{
    static NSDictionary* metadata = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle* bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:self] URLForResource:@"PXBuildVersion" withExtension:@"bundle"]];

        NSString* jsonFilePath = [bundle pathForResource:@"com.pixio.pxbuildversion.generated" ofType:@"json"];

        NSError* deserializationError;
        metadata = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:0 error:&deserializationError];

        NSAssert(deserializationError == nil && [metadata count] > 0, @"Unable to find the metadata JSON. Ensure the post_install hook is set up properly in your Podfile. Consult the README for more information.");
    });

    return metadata;
}

#pragma mark - Info.plist version

+ (NSString*) displayVersion
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleShortVersionString"];
}

+ (NSString*) buildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:(NSString *)kCFBundleVersionKey];
}

#pragma mark - PXBuildVersion

+ (NSDate*)buildDate
{
    NSNumber* epochTime = [self property:@"build_timestamp"];
    NSAssert(epochTime != nil, @"Unable to parse build date");

    return [NSDate dateWithTimeIntervalSince1970:[epochTime doubleValue]];
}

+ (NSString*) commit
{
    return [self property:@"commit"];
}

+ (NSString*) shortCommit
{
    return [self property:@"short_commit"];
}

+ (NSString*) branch
{
  return [self property:@"branch"];
}

+ (NSArray<NSString*>*) localBranches
{
  return [self property:@"local_branches"] ?: @[];
}

+ (NSArray<NSString*>*) remoteBranches
{
    return [self property:@"remote_branches"] ?: @[];
}

+ (NSString*) tag
{
    return [self property:@"tag"];
}

+ (NSArray<NSString*>*) tags
{
    return [self property:@"tags"] ?: @[];
}

+ (BOOL)isDirty
{
    return [[self property:@"build_is_dirty"] boolValue];
}

+ (NSDictionary*)environmentVariables
{
    return [self property:@"environment_variables"] ?: @{};
}

+ (NSDictionary*)ENV
{
    return [self environmentVariables];
}

#pragma mark - Xcode

+ (NSString*)buildConfiguration
{
    return [self envProperty:@"CONFIGURATION"];
}


#pragma mark - Continuous Integration

+ (NSNumber*)jenkinsBuildNumber
{
    NSString* buildNumber = [self envProperty:@"BUILD_NUMBER"];

    // Convert the string environment variable to an NSNumber
    return (buildNumber ? @([buildNumber integerValue]) : nil);
}

+ (NSNumber*)travisBuildNumber
{
    NSString* buildNumber = [self envProperty:@"TRAVIS_BUILD_NUMBER"];

    // Convert the string environment variable to an NSNumber
    return (buildNumber ? @([buildNumber integerValue]) : nil);
}

+ (NSString*)travisJobNumber
{
    return [self envProperty:@"TRAVIS_JOB_NUMBER"];
}

+ (NSString*)circleBuildNumber
{
    return [self envProperty:@"CIRCLE_BUILD_NUM"];
}

#pragma mark - Helper methods

+ (id)property:(NSString*)keyPath
{
    id value = [[self metadata] valueForKeyPath:keyPath];
    if ([value isEqual:[NSNull null]])
    {
        return nil;
    }

    return value;
}

+ (id)envProperty:(NSString*)key
{
    return [[self environmentVariables] objectForKey:key];
}

@end
