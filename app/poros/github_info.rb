class GithubInfo
  attr_reader :repo_name,
              :contributors,
              :repo_url

  def initialize(repo_name, url)
    @repo_name = repo_name
    @contributors = []
    @repo_url = url
  end

  def contributors
    if @repo_name != "validation error"
      GithubService.contributor_logins(@repo_url).each do |login|
        @contributors << login
      end
    else
      @contributors = []
    end
  end

  def name_formatted
    if @repo_name != "validation error"
      @repo_name.split("-").map(&:capitalize).join(" ")
    end
  end

  def pull_count
    if @repo_name != "validation error"
      pulls = GithubService.pulls(@repo_url)
      if pulls.is_a?(Hash)
        1
      elsif pulls.nil?
        0
      else
        pulls.count
      end
    else
      1
    end
  end
end
