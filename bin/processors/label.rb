class Label < GithubInteractor

  def import
    say 'Import called.'
    labels = array_from_json
    counter = 0

    labels.each do |label|
      add_label(label)
      counter += 1
    end

    say "Imported #{counter} labels."
  end

  def export
    labels = retrieve_labels
    save_as_json(labels)
  end

  private

  def retrieve_labels
    say "Retrieving Github labels from #{@repo}."
    labels = []
    page = 1

    loop do
      single_page_labels = @client.labels(@repo, :page => page)
      labels += single_page_labels
      break if single_page_labels.empty?
      page += 1
    end
    say "#{labels.size} labels retrieved."
    labels.map!(&:to_hash)
  end


  def add_label(l)
    @client.add_label(@repo, l['name'], l['color'])
    say "Successfully imported label: #{l['name']}"
  end


end