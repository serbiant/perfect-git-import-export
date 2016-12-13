class InputHandler
  include MessageHandler
  attr_reader :username, :password, :owner,
              :repository, :input, :output

  AVAILABLE_ARGUMENTS = {
      :username => %w(u username),
      :password => %w(p password),
      :owner => %w(owner organization own org),
      :repository => %w(r repository),
      :input => %w(i input s source),
      :output => %w(o output)
  }

  def initialize(args, type) #type is :export or :import
    arguments = format_arguments(args)
    check_required_fields! arguments, type
  end

  private

  def format_arguments(args)
    arguments = parse_arguments(args)
    formatted_arguments = {}

    AVAILABLE_ARGUMENTS.each do |key, value|
      valid_option = (value & arguments.keys).first
      formatted_arguments[key] = arguments[valid_option] if valid_option
    end

    formatted_arguments
  end

  def check_required_fields! (args, type)
    keys = (send "required_#{type}_keys").map!(&:to_sym)
    missed_arguments = keys - args.keys
    fatal missed_arguments.first.to_sym if missed_arguments.any?
  end

  def required_export_keys
    required_keys << 'input'
  end

  def required_import_keys
    required_keys << 'output'
  end

  def parse_arguments(args)
    Hash[args.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/)]
  end

  def required_keys
    %w{username password owner repository}
  end

end

