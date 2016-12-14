class InputHandler
  include MessageHandler
  attr_reader :username, :password, :owner,
              :repository, :input, :output,
              :type, :entity

  AVAILABLE_ARGUMENTS = {
      :username => %w(u username),
      :password => %w(p password),
      :owner => %w(owner organization own org),
      :repository => %w(r repository),
      :input => %w(i input s source),
      :output => %w(o output),
      :entity => %w(entity e),
      :type => %w(type t)
  }

  VALID_VALUES = {
      :entity => %w(issue milestone label),
      :type => %w(import export)
  }

  def initialize(args)
    @arguments = format_arguments(args)
    set_operation_type!
    check_required_fields!
    validate_values!
    @arguments.each { |k, v| instance_variable_set("@#{k}",v)}
  end

  def export?
    @type == 'export'
  end

  def import?
    @type == 'import'
  end

  private

  def set_operation_type!
    fatal :type if @arguments[:type].nil?
    fatal :type_invalid unless VALID_VALUES[:type].index @arguments[:type]
    @type = @arguments[:type]
  end

  def validate_values!
    @arguments.each do |k, v|
      next unless VALID_VALUES.has_key? k
      unless VALID_VALUES[k].include? v
        say "Invalid value `#{v}` for `#{k}` argument!"
        say "Valid values: #{ VALID_VALUES[k].join(', ') }."
        fatal :value_invalid
      end
    end
  end

  def format_arguments(args)
    arguments = parse_arguments(args)
    formatted_arguments = {}

    AVAILABLE_ARGUMENTS.each do |key, value|
      valid_option = (value & arguments.keys).first
      formatted_arguments[key] = arguments[valid_option] if valid_option
    end

    formatted_arguments
  end

  def check_required_fields!
    keys = (send "required_#{@type}_keys").map!(&:to_sym)
    missed_arguments = keys - @arguments.keys
    fatal missed_arguments.first.to_sym if missed_arguments.any?
  end

  def required_export_keys
    required_keys << 'output'
  end

  def required_import_keys
    required_keys << 'input'
  end

  def parse_arguments(args)
    Hash[args.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/)]
  end

  def required_keys
    %w{username password owner repository entity type}
  end

end

