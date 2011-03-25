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
    @ps       = `ps aux`.strip.gsub(/\s*$/, '')
    @ps_lines = @ps.split("\n")[1..-1]
    @who      = `who -a`.strip
    `uptime`.match(/up (.*?),  (\d) users,  load average: (.*)$/) do |m|
      @uptime = {
        :uptime   => m[1],
        :users    => m[2],
        :load_avg => m[3]
      }
    end
    @freedisk = `df -h`.strip 
    @freemem  = `free -m`.strip
    @hostname = `hostname`.strip
    @subject  = "#{@hostname}: I am alive! [#{Time.now}]"

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

