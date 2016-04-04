#
# Be sure to run `pod lib lint PXSCM.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

anchor_file = "pxbuildversion_anchor"
json_file = "com.pixio.pxbuildversion.generated.json"

Pod::Spec.new do |s|
  s.name             = "PXBuildVersion"
  s.version          = "0.7.0"
  s.summary          = "The easiest way to get build version information from git into your application."
  s.homepage         = "https://github.com/pixio/PXBuildVersion"
  s.license          = "MIT"
  s.author           = { "Kevin Wong" => "snarpel@gmail.com" }
  s.source           = { :git => "https://github.com/pixio/PXBuildVersion.git", :tag => s.version.to_s }

  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"

  s.requires_arc = true

  s.source_files = "PXBuildVersion/*.{h,m}"
  s.preserve_paths = "scripts/**/*.rb", "PXBuildVersion/generated/{.gitignore,#{anchor_file}}"

  s.resource_bundles = {
      "PXBuildVersion" => ["PXBuildVersion/generated/#{json_file}"]
    }

  # Create the anchor file.
  # Additionally, create a placeholder for the generated json so it can be seen in the generated Pods project
  s.prepare_command = <<-CMD
    touch PXBuildVersion/generated/{#{json_file},#{anchor_file}}
  CMD
end
