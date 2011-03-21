#!/usr/bin/env ruby

require 'yaml'
require 'action_mailer'

begin
  CONFIG = YAML.load_file File.expand_path('../cronmail.yml', __FILE__)
rescue
  puts "*** Cronmail: You need to setup a cronmail.yml."
  puts "*** No mail send. Exiting."
end

ActionMailer::Base.raise_delivery_errors = CONFIG[:action_mailer][:raise_delivery_errors]
ActionMailer::Base.delivery_method       = CONFIG[:action_mailer][:delivery_method]
ActionMailer::Base.view_paths            = File.dirname(__FILE__)

class Cronmail < ActionMailer::Base
  def status
    @ps       = `ps aux`.gsub(/\s*$/, '')
    @ps_lines = @ps.split("\n")[1..-1]
    @who      = `who -a`
    @uptime   = `uptime`.split(',', 3).map{|e| e.strip }
    @freemem  = `free -m`
    @subject  = "I am alive! [#{Time.now}]"

    mail(:to => CONFIG[:cronmail][:recipients], :from => CONFIG[:cronmail][:from], :subject => @subject) do |format|
      format.text
      format.html
    end
  end
end

if ARGV.size > 0
  # start as daemon, and send mails periodically
else
  Cronmail.status.deliver
end

