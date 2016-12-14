class Issue < GithubInteractor

  def import
    say 'import called.'
  end

  def export
    issues = retrieve_issues
    save_as_json(issues)
  end

  private

  def retrieve_issues(state = :open)
    say "Retrieving Github issues from #{@repo}."
    issues = []
    page = 0

    loop do
      single_page_issues = @client.list_issues(@repo, :state => state, :page => page)
      issues += single_page_issues
      break if single_page_issues.empty?
      page += 1
    end
    say "#{issues.size} issues retrieved."
    issues.map!(&:to_hash)
  end



end