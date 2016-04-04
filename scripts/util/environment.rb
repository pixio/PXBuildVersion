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

require 'optparse'


module SharedOptions
    class << self
        attr_accessor :env_vars
    end
end


def get_env_variables_hash()
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: environment.rb [options]"

      opts.on("-e", "--env [NAMES]", Array, "Comma separated list of env variable names") do |o|
          options[:env] = o
      end
      opts.on("--all-env", "Dump all environment env variables found") do |o|
          options[:allenv] = o
      end
      opts.on("--exclude-default", "Exclude default env variables") do |o|
          options[:nodefault] = o
      end
    end.parse!

    # Default env variables that will be added
    default_env_variables = [
        # Xcode
        "CONFIGURATION",

        # Jenkins CI
        "BUILD_NUMBER",

        # Travis CI
        "TRAVIS_BUILD_NUMBER", "TRAVIS_JOB_NUMBER",

        # Circle CI
        "CIRCLE_BUILD_NUM",
    ]



    # Return all env variable if requested
    if options[:allenv]
        SharedOptions.env_vars = ENV.to_h
        return
    end

    env_vars = {}
    # Merge the list of user supplied env var names with the defaults
    env_names = options[:nodefault] ? [] : default_env_variables
    env_names = env_names + options[:env] if !options[:env].nil?

    # Append the env vars that exist
    env_names.each do |k|
        k.strip!
        env_vars[k] = ENV[k] if ENV[k] != nil
    end

    SharedOptions.env_vars = env_vars
end

get_env_variables_hash
