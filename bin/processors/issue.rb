class Issue < GithubInteractor

  def import
    say 'Import called.'
    issues = format_issues(array_from_json)
    counter = 0
    issues.each do |issue|
      add_issue(issue)
      counter += 1
    end

    say "Imported #{counter} issues."
  end

  def export
    issues = retrieve_issues
    save_as_json(issues)
  end

  private

  def retrieve_issues(state = :open)
    say "Retrieving Github issues from #{@repo}."
    issues = []
    page = 1

    loop do
      single_page_issues = @client.list_issues(@repo, :state => state, :page => page)
      issues += single_page_issues
      break if single_page_issues.empty?
      page += 1
    end
    say "#{issues.size} issues retrieved."
    issues.map!(&:to_hash)
  end

  def add_issue(issue)
    @client.create_issue(@repo, issue[:title], issue[:body], issue[:options])
    say "Successfully imported issue: #{issue['title']}"
  end

  def format_issues(issues)
    formatted = []

    issues.each do |i|
      el = {
          title: i['title'],
          body: i['body'],
          options: {}
      }
      el[:options][:milestone] = i['milestone']['number'] if i['milestone']
      el[:options][:assignee] = i['assignee']['login'] if i['assignee']
      labels = i['labels'].map { |l| l['name']  }
      el[:options][:labels] = labels.join(',')

      formatted.push el

    end
    formatted
  end



end