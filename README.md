# Cronmail

Ruby server-side script for periodic status messages via email.

These status messages includes the average load, currently logged in
users (number and origin), the uptime, free memory and a process list.

The email is send multipart'ed (text/plain and text/html).

## Requirements

You need at least this setup on your machine:

* Ruby and RubyGems,
* the actionmailer gem (`(sudo) gem install actionmailer`),
* a running cron daemon, and a sendmail-compatible MTA.

I've tested Cronmail with a Debian Squeeze (Ruby 1.9.2, RubyGems 1.3.7,
Vixie Cron 3.0, Postfix 2.7.1 and ActionMailer 3.0.5).

## Installation

First, clone this repository:

    $ git clone git://github.com/dmke/cronmail.git

Then edit the configuration file:

    $ cd /path/to/cloned/cronmail
    $ cp cronmail.yml.example cronmail.yml
    $ $EDITOR cronmail.yml

There, you may change the senders field (`:from`) and the list of
recipients (`:recipients`). The `:action_mailer` fields are for future
purpose and currently not supported.

After finishing the configuration, test your Cronmail installation:

    $ cd /path/to/cloned/cronmail
    $ ruby cronmail.rb

If there is no output and you've received an email with "I am alive!"
subject, you may continue with setting up a cronjob (else read the
FAQ, below):

    $ crontab -e
    $ # insert a line like this:
    $ # */10 * * * * /path/to/cloned/cronmail/cronmail.rb >/dev/null 2>&1

This will send your recipients every ten minutes a status report. See
`crontab(8)` for more details.

## FAQ

1. **I have an error or any output while testing.**
    * Consider this:
        * Ensure to have some current versions of Ruby, RubyGems, Cron
          and your MTA installed.
        * Ensure to have them configured correctly.
        * Check the log messages of your MTA, may be the recipients are
          rejecting your host for some (good) reason.

2. **I still receive no mail.**
    * Have you checked your junk filter?
    * Ensure Cron and your MTA are running.

3. **I'd like to have an email only at startup time, is that possible?**
    * Sure, if your cron daemon allows you to be configured this way,
      like Vixie Cron, why not?
    * RTFM, `crontab(8)`

4. **I don't have a cron daemon installed, is there another way to send
  status emails periodically?**
    * That might be possible in a future version of Cronmail.
    * Seriously? You're running a server without any crond? How do
      you...?

