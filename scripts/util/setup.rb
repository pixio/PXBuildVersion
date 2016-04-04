#!/usr/bin/env ruby
#
# Copyright (c) 2016 Pixio <pixio.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'xcodeproj'

# Implemented based on code from cocoapods gem
# https://github.com/cocoapods/cocoapods/blob/master/lib/cocoapods/installer/user_project_integrator/target_integrator.rb
def create_or_update_build_phase(target, phase_name, phase_class = Xcodeproj::Project::Object::PBXShellScriptBuildPhase)
  build_phases = target.build_phases.grep(phase_class)
  build_phases.find { |phase| phase.name == phase_name } ||
    build_phases.find { |phase| phase.name == phase_name }.tap { |p| p.name = phase_name if p } ||
    target.project.new(phase_class).tap do |phase|
      Pod::UI.info("Adding Build Phase '#{phase_name}' to Pods project.") do
        phase.name = phase_name
        phase.show_env_vars_in_log = '0'

        # Insert build phase at beginning
        target.build_phases.insert(0, phase)
      end
    end
end


def pxbuildversion_setup(installer, options = {})
  target = installer.pods_project.targets.find { |e| e.name == "PXBuildVersion-PXBuildVersion" }
  abort "PXBuildVersion: Unable to find resource bundle target. Aborting.".red if target.nil?

  phase = create_or_update_build_phase(target, "PXBuildVersion: Generate Version Data")
  phase.shell_script = options[:script] || %(\"${PODS_ROOT}/PXBuildVersion/scripts/git.rb\")
end
