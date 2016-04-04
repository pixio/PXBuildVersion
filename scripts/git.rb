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

require_relative 'util/environment.rb'
require_relative 'util/export.rb'

# Ensure git executable exists
abort("Unable to find git") if !system("type git &> /dev/null")
abort("Project is not in a git repo") if !system("git status &> /dev/null")


# Helper method to get refs
# http://stackoverflow.com/a/6064223/1687011
def get_refs(refs)
    `git for-each-ref --format='%(objectname) %(refname:short)' #{refs} | awk "/^$(git rev-parse --verify HEAD)/ {print \\$2}"`.split(/\n+/)
end

# Helper to move an element to the begining of an array
# http://stackoverflow.com/a/31955478/1687011
class Array
    def promote_all(arr)
        arr.reverse_each { |e| promote(e) }
    end
    def promote(e)
        return self unless (found_index = find_index(e))
        unshift(delete_at(found_index))
    end
end




dirty = (`git status --porcelain 2>/dev/null | wc -l`.strip.to_i) > 0
commit = `git rev-parse --verify HEAD`.strip
short_commit = commit[0..7]
current_branch = `git rev-parse --abbrev-ref HEAD`.strip

# Get local branches and tags
local_branches = get_refs("refs/heads")
local_branches.promote(current_branch)
tags = get_refs("refs/tags")

# Get all the remote branches
#   Additionally, remove remote name from the ref and add to a separate array
remotes = `git remote`.split(/\n+/).promote("origin")
remote_branches = []
trimmed_branches = []
remotes.each { |r|
    branches = get_refs("refs/remotes/#{r}").reject { |e| e == "#{r}/HEAD" }

    remote_branches.concat(branches)
    trimmed_branches.concat(branches.map { |e| e[(r.length+1)..-1] })
}

# Arrange branch arrays
#   Promote common branch names to the front of the arrays
#   Then append the local branches
common_branches = ["master", "staging", "develop", "dev"]
trimmed_branches.promote_all(common_branches)
local_branches.promote_all(common_branches)

# Choose a branch name. Prioritize remote branches over local branches
branch = trimmed_branches.concat(local_branches).uniq.first


# Export metadata
metadata = {}
metadata[:build_timestamp] = Time.now.to_i
metadata[:commit] = commit
metadata[:short_commit] = short_commit
metadata[:branch] = branch
metadata[:local_branches] = local_branches.uniq
metadata[:remote_branches] = remote_branches
metadata[:tag] = tags.first
metadata[:tags] = tags
metadata[:build_is_dirty] = dirty
metadata[:environment_variables] = SharedOptions.env_vars

export_data(metadata)
