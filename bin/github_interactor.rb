
class GithubInteractor
  include MessageHandler

  def initialize(entry)
    @client = Octokit::Client.new(:login => entry.username,
                                  :password => entry.password)

    @repo = "#{entry.owner}/#{entry.repository}"
    @input = entry.input if entry.import?
    @output = entry.output if entry.export?
  end

  def import
    fatal :override
  end

  def export
    fatal :override
  end

  private

  def save_as_json(entities)
    say "Saving as JSON to the file: #{@output}"
    File.open(@output, 'w') do |f|
      f.write(entities.to_json)
    end
    say 'Successfully saved data.'
  end

end