module MessageHandler

  DEFAULT_MESSAGES = {
      :username => 'You have to provide script with Github username.(--username, -u option)',
      :password => 'Please provide me with user\'s Github password! (--password, -p option)',
      :input => 'Please provide me with source file! (--source, -s option)',
      :output => 'Please provide me with output file! (--output, -o option)',
      :owner => 'Please provide me with Github owner/organization! (--owner, --organization, -org, -own option)',
      :repo => 'Please provide me with Github repository name! (--repository, -r option)',
      :auth_failed => 'Github authentication failed! Please try again.'
  }

  def notice(msg)
    message(msg.to_sym, :notice)
  end

  def log(msg)
    message(msg.to_sym, :log)
  end

  def fatal(msg)
    message(msg.to_sym, :abort)
  end

  private

  def message(msg, type)

    abort "There's no such message like #{msg}." unless DEFAULT_MESSAGES.has_key? msg

    case type
    when :notice
      warn DEFAULT_MESSAGES[msg]
    when :log
      puts DEFAULT_MESSAGES[msg]
    when :abort
      warn DEFAULT_MESSAGES[msg]
      abort
    else
      puts 'There is no such type.'
    end
  end

end