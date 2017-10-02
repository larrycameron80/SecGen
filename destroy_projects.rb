require 'fileutils'
require_relative 'lib/helpers/constants.rb'
require_relative 'lib/helpers/print.rb'
require_relative 'lib/helpers/gem_exec.rb'

current_directory = FileUtils.pwd
file_handle = File.open('week1_fixing/failed_projects', 'r')

file_handle.each_line { |dir_name|
  project_dir = "#{current_directory}/projects/#{dir_name.chomp}"
  Print.info "Destroying Project dir: #{project_dir}"
  if GemExec.exe('vagrant', project_dir, 'destroy')
    Print.info "successfully destroyed."
  else
    Print.err "destroy failed."
  end

}
