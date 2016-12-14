class Milestone < GithubInteractor


  def import
    say 'Import called.'
  end

  def export
    milestones = retrieve_milestones
    save_as_json(milestones)
  end

  private

  def retrieve_milestones(state = :all)
    say "Retrieving Github milestones from #{@repo}."
    milestones = []
    page = 0

    loop do
      single_page_milestones = @client.list_milestones(@repo, :state => state, :page => page)
      milestones += single_page_milestones
      break if single_page_milestones.empty?
      page += 1
    end
    say "#{milestones.size} milestones retrieved."
    milestones.map!(&:to_hash)
  end


end