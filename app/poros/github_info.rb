class GithubInfo
  attr_reader :repo_name,
              :contributors,
              :repo_url

  def initialize(repo_name, url)
    @repo_name = repo_name
    @contributors = []
    @repo_url = url
  end

  def add_contributor(contributor)
    GithubService.contributor_logins(@repo_url).each do |login|
      @contributors << login
    end
  end

  def name_formatted
    @repo_name.split("-").map(&:capitalize).join(" ")
  end

  def pull_count
    pulls = GithubService.pulls(@repo_url)
    if pulls.is_a?(Hash)
      1
    else
      pulls.count
    end
  end
end
