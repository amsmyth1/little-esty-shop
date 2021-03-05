class GithubService < ApiService
  def self.repo_name(url)
    get_info(url)[:name]
  end

  def self.repo_object(url)
    if !repo_name(url).nil?
      name = repo_name(url)
      GithubInfo.new(name, url)
    end
  end

  def self.contributors(url)
    get_info("#{url}/contributors")
  end

  def self.contributor_logins(url)
    contributors.map do |contributor|
      # GithubInfo.add_contributor(contributor[:login])
      contributor[:login]
    end
  end
    # if contributors.is_a?(Hash)
    #   'API Limit Exceeded: Contributor Info Not Available'
    # else
    #   collaborators = [contributors[0], contributors[1], contributors[3], contributors[4]]
    #   people = collaborators.map do |data|
    #     Contributor.new(data)
    #   end
    #   people.map do |people|
    #     "#{people.user_name} - #{commit_objects(people.user_name)} Commits\n"
    #   end.to_sentence
    # end

  def self.pulls(url)
    get_info("#{url}#/pulls?state=all")
  end

  def self.pull_count(url)
    if pulls(url).is_a?(Hash)
      1
    else
      pulls(url).count
    end
  end
  #
  # def self.commits(user_name)
  #   get_info("https://api.github.com/repos/amsmyth1/little-esty-shop/commits?author=#{user_name}")
  #   binding.pry
  # end
  #
  # def self.commit_objects(user_name)
  #   commits(user_name).map do |data|
  #     Commit.new(data)
  #   end.size
  # end
end
