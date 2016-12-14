class Milestone < GithubInteractor


  def import
    say 'Import called.'
    milestones = array_from_json.sort_by { |m| m['number'] }
    counter = 0

    milestones.each do |milestone|
      add_milestone(milestone)
      counter += 1
    end

    say "Imported #{counter} milestones."
  end

  def export
    milestones = retrieve_milestones
    save_as_json(milestones)
  end

  private

  def retrieve_milestones(state = :all)
    say "Retrieving Github milestones from #{@repo}."
    milestones = []
    page = 1

    loop do
      single_page_milestones = @client.list_milestones(@repo, :state => state, :page => page)
      milestones += single_page_milestones
      break if single_page_milestones.empty?
      page += 1
    end
    say "#{milestones.size} milestones retrieved."
    milestones.map!(&:to_hash)
  end

  def add_milestone(m)

    options = {
        :state => m['state'],
        :description => m['description']
    }
    options[:due_on] = DateTime.parse(m['due_on']) if m['due_on']

    @client.create_milestone(@repo, m['title'], options)
    say "Successfully imported milestone: #{m['title']}"
  end


end