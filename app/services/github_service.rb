class GithubService < ApiService
  def self.repo_name(url)
    get_info(url)[:name]
  end

  def self.repo_object(url)
    if !repo_name(url).nil?
      name = repo_name(url)
      GithubInfo.new(name, url)
    else
     GithubInfo.new("validation error", url)
   end
  end

  def self.contributors(url)
    get_info("#{url}/contributors")
  end

  def self.contributor_logins(url)
    contributors(url).map do |contributor|
      contributor[:login]
    end
  end

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
end
