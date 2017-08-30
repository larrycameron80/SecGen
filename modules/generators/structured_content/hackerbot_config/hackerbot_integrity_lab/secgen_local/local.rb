#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_generator.rb'
require 'erb'
require 'fileutils'
class HackerbotConfigGenerator < StringGenerator
  attr_accessor :accounts
  attr_accessor :flags
  attr_accessor :root_password
  LOCAL_DIR = File.expand_path('../../',__FILE__)
  TEMPLATE_PATH = "#{LOCAL_DIR}/templates/integrity_lab.xml.erb"

  def initialize
    super
    self.module_name = 'Hackerbot Config Generator'
    self.accounts = []
    self.flags = []
    self.root_password = ''
  end

  def get_options_array
    super + [['--root_password', GetoptLong::REQUIRED_ARGUMENT],
             ['--accounts', GetoptLong::REQUIRED_ARGUMENT],
             ['--flags', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
      when '--root_password'
        self.root_password << arg;
      when '--accounts'
        self.accounts << arg;
      when '--flags'
        self.flags << arg;
    end
  end

  def generate

    template_out = ERB.new(File.read(TEMPLATE_PATH), 0, '<>-')
    self.outputs << template_out.result(self.get_binding)
  end

  # Returns binding for erb files (access to variables in this classes scope)
  # @return binding
  def get_binding
    binding
  end
end


HackerbotConfigGenerator.new.run