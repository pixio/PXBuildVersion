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

require 'find'
require 'fileutils'
require 'json'

def export_data(metadata)
    anchor_name = "pxbuildversion_anchor"
    output_name = "com.pixio.pxbuildversion.generated.json"

    output_directory = nil

    Find.find(File.expand_path("../..", File.dirname(__FILE__))) do |p|
        if File.basename(p) == anchor_name then
            output_directory = File.dirname(p)
            break
        end
    end

    # Unable to find the anchor
    abort("Unable to find directory to export") if output_directory.nil?

    File.open(File.join(output_directory, output_name), "w") do |f|
        f.write metadata.to_json
    end
end
