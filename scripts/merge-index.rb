#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Deep-merge a pack's index.yml fragment into a repo's docs/standards/index.yml.
# Usage: merge-index.rb <target-index.yml> <fragment-index.yml>
require "yaml"

target_path, fragment_path = ARGV
abort "usage: merge-index.rb <target> <fragment>" unless target_path && fragment_path

def load_yaml(path)
  return {} unless File.exist?(path)
  data = YAML.load_file(path)
  data.is_a?(Hash) ? data : {}
rescue Psych::SyntaxError => e
  warn "warning: could not parse #{path} (#{e.message}); starting fresh"
  {}
end

base = load_yaml(target_path)
# Treat the agentic-workflow placeholder shape (`standards: []`) as empty.
base = {} if base.keys == ["standards"]

fragment = load_yaml(fragment_path)

deep_merge = lambda do |a, b|
  b.each do |k, v|
    a[k] = a[k].is_a?(Hash) && v.is_a?(Hash) ? deep_merge.call(a[k], v) : v
  end
  a
end

merged = deep_merge.call(base, fragment)

# Stable, sorted output (category, then standard name).
sorted = merged.sort.to_h
sorted.each { |k, v| sorted[k] = v.sort.to_h if v.is_a?(Hash) }

File.write(target_path, sorted.to_yaml(line_width: -1).sub(/\A---\n/, ""))
