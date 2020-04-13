#! /usr/bin/env ruby

require 'fileutils'

class RebuildsCommandT
  START_PATH = Dir.pwd
  BUILD_PATH = File.expand_path("~/.vim/pack/andydna/start/command-t/ruby/command-t/ext/command-t")

  def rebuild_to_match_vim
    cd_and_report(BUILD_PATH)
    
    rbenv_change_ruby_version_to(vim_ruby_version)
    extconf_and_make
    
    cd_and_report(START_PATH)
  end

  def cd_and_report(path)
    puts "cd #{path}"
    FileUtils.cd path
  end

  def rbenv_change_ruby_version_to(version)
    puts "  echo .#{version} > ruby-version"
    File.open('./ruby-version', 'w') { |f| f.write(version) }
    fail "  rbenv doesn't know about #{vim_ruby_version}" unless ruby_match?
  end

  def extconf_and_make
    puts "   ruby extconf.rb && make"
    `ruby extconf.rb && make`
    puts "   done"
  end

  def ruby_match?
    shell_ruby_version == vim_ruby_version
  end

  def shell_ruby_version
    `ruby -v`[/\d\.\d\.\d/]
  end

  def vim_ruby_version
    `vim --version`.scan(/rbenv\/versions\/(\d\.\d\.\d)/).first.first
  end
end

if __FILE__ == $0
  RebuildsCommandT.new.rebuild_to_match_vim
end
