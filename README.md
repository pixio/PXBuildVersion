# PXBuildVersion

[![Version](https://img.shields.io/cocoapods/v/PXBuildVersion.svg?style=flat)](http://cocoapods.org/pods/PXBuildVersion)
[![License](https://img.shields.io/cocoapods/l/PXBuildVersion.svg?style=flat)](http://cocoapods.org/pods/PXBuildVersion)
[![Platform](https://img.shields.io/cocoapods/p/PXBuildVersion.svg?style=flat)](http://cocoapods.org/pods/PXBuildVersion)

The easiest way to get build version information from git into your application.

PXBuildVersion is a set of scripts to generate build version information about your application. This includes the build date, version control information (git commit sha, branch, and tag), and any other environment variables captured at build time.

Supports Jenkins CI, Travis CI, and Circle CI build numbers.

## Installation

PXBuildVersion is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'PXBuildVersion'
```

You will also need to add a build script. The easiest way to do this is to add a post_install hook to your `Podfile`. If you already have a post_install section in your `Podfile`, add just the contents to the existing post_install as only one post_install hook is allowed per `Podfile`.

```ruby
post_install do |installer|
  if File.exists?('Pods/PXBuildVersion')
    require_relative 'Pods/PXBuildVersion/scripts/util/setup.rb'
    pxbuildversion_setup(installer)
  end
end
```

Once your `Podfile` is correctly configured, simply run `pod install` to install!

## Usage

It's simple to use!

#### Objective-C

```objective-c
NSLog(@"git sha: %@", [PXBuildVersion commit]);
if ([PXBuildVersion tag] != nil) {
    NSLog(@"git tag: %@", [PXBuildVersion tag]);
}
```

#### Swift

```swift
if let commit = PXBuildVersion.commit() {
    print("git sha: \(commit)")
}
if let tag = PXBuildVersion.tag() {
    print("git tag: \(tag)")
}
```

Add it to your settings pages. Or, add it to your crash reporting tool to help track down issues!

```objective-c
[[Crashlytics sharedInstance] setObjectValue:[PXBuildVersion commit] forKey:@"commit"];
```

# Configuration

By adjusting the setup script, you can control the environment variables that are generated in the version payload.

## Options

```
    -e, --env [NAMES]                Comma separated list of env variable names
        --all-env                    Dump all environment env variables found
        --exclude-default            Exclude default env variables
```

These options can be applied to the setup script in the `Podfile`.

### Example
Update the `pxbuildversion_setup` line in your Podfile to specify the exact script, specifying any options.

```ruby
if File.exists?('Pods/PXBuildVersion')
  require_relative 'Pods/PXBuildVersion/scripts/util/setup.rb'
  pxbuildversion_setup(installer, script: %(\"${PODS_ROOT}/PXBuildVersion/scripts/git.rb\" -e NODE_NAME,BUILD_URL --exclude-default))
end
```

Then access any captured environment variables as needed:

```swift
if let buildNode = PXBuildVersion.environmentVariables()["NODE_NAME"],
       buildUrl = PXBuildVersion.environmentVariables()["BUILD_URL"] {
    print("This was built by Travis CI on node: \(buildNode)")
    print("Access the build job details at: \(buildUrl)")
}
else {
    print("Perhaps we should automate our builds with a CI server")
}
```

## Author

[kwongius](https://github.com/kwongius)

## License

PXBuildVersion is available under the MIT license. See the LICENSE file for more info.
