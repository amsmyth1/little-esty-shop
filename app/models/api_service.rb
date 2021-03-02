require 'faraday'
require 'pry'
require 'json'
require_relative 'repo'
require_relative 'contributor'
require_relative 'pull'
require_relative 'commit'

class ApiService

  def self.get_info(uri)
    response = Faraday.get("https://api.github.com/repos/avjohnston/little-esty-shop#{uri}")
    parsed = JSON.parse(response.body, symbolize_names: true)
  end

  def self.repo
    get_info('')[:name]
  end

  def self.repo_object
    Repo.new(repo).name
  end

  def self.contributors
    get_info('/contributors')
  end

  def self.contributor_objects
    contributors.map do |data|
      Contributor.new(data)
    end
  end

  def self.pulls
    get_info('/pulls?state=all')
  end

  def self.pull_objects
    pulls.map do |data|
      Pull.new(data)
    end.size
  end

  def self.commits(user_name)
    get_info("/commits?author=#{user_name}")
  end

  def self.commit_objects(user_name)
    commits(user_name).map do |data|
      Commit.new(data)
    end.size
  end

  # def self.repo
  #   my_repo = Faraday.get 'https://api.github.com/repos/avjohnston/little-esty-shop'
  #   my_body = my_repo.body
  #   JSON.parse(my_body)
  # end
  #
  # def self.repo_name
  #   repo['name'].gsub('-', ' ').titleize
  # end
  #
  # def self.contributors
  #   contributors = Faraday.get 'https://api.github.com/repos/avjohnston/little-esty-shop/contributors'
  #   contributors_body = contributors.body
  #   JSON.parse(contributors_body)
  # end
  #
  # def self.contributor_names
  #   [repo['owner']['login'], contributors[0]['login'], contributors[1]['login'], contributors[4]['login']]
  # end
  #
  # def self.pull_requests
  #   pulls = Faraday.get 'https://api.github.com/repos/avjohnston/little-esty-shop/pulls?state=all'
  #   pulls_body = pulls.body
  #   JSON.parse(pulls_body)
  # end
  #
  # def self.closed_pr_count
  #   pull_requests.find_all do |pull|
  #     pull['state'] == 'closed'
  #   end.count
  # end
  #
  # def self.branches
  #   branches = Faraday.get 'https://api.github.com/repos/avjohnston/little-esty-shop/branches'
  #   branches_body = branches.body
  #   JSON.parse(branches_body)
  # end
  #
  # def self.user_commits(user_name)
  #   branches = Faraday.get "https://api.github.com/repos/avjohnston/little-esty-shop/commits?author=#{user_name}"
  #   branches_body = branches.body
  #   JSON.parse(branches_body).count
  # end
  #
  # def self.users_closed_prs(user_name)
  #   pull_requests.find_all do |pull|
  #     pull['user']['login'] == user_name
  #   end
  # end
  #
  # def self.user_closed_pr_shas(user_name)
  #   users_closed_prs(user_name).map do |pull|
  #     pull['merge_commit_sha']
  #   end
  # end
  #
  # def self.user_commit_count(user_name)
  #   user_closed_pr_shas(user_name).map do |sha|
  #     commits = Faraday.get "https://api.github.com/repos/avjohnston/little-esty-shop/commits/#{sha}"
  #     JSON.parse(commits.body).count
  #   end.sum
  # end
end
