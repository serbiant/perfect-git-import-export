class Label < GithubInteractor

  def import
    say 'Import called.'
  end

  def export
    labels = retrieve_labels
    save_as_json(labels)
  end

  private

  def retrieve_labels
    say "Retrieving Github labels from #{@repo}."
    labels = []
    page = 0

    loop do
      single_page_labels = @client.labels(@repo, :page => page)
      labels += single_page_labels
      break if single_page_labels.empty?
      page += 1
    end
    say "#{labels.size} labels retrieved."
    labels.map!(&:to_hash)
  end


end