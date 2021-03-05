class ApplicationController < ActionController::Base
before_action :repo_object
              # :contributor_objects,
              # :pull_objects

  def repo_object
    @repo = GithubService.repo_object("https://api.github.com/repos/amsmyth1/little-esty-shop")
  end

  # def contributor_objects
  #   # @contributors ||= GithubService.contributor_objects
  #   binding.pry
  #   @contributors ||= @repo.contributors
  # end
  #
  # def pull_objects
  #   @repo = GithubService.repo_object("https://api.github.com/repos/amsmyth1/little-esty-shop")
  #
  #   @pulls ||= @repo.pull_count
  # end
end
