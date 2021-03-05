class ApplicationController < ActionController::Base
before_action :repo_object,
              :contributor_objects,
              :pull_objects

  def repo_object
    @repo ||= GithubInfo.name
  end

  def contributor_objects
    # @contributors ||= GithubService.contributor_objects
    @contributors ||= GithubInfo.contributors
  end

  def pull_objects
    @pulls ||= GithubService.pull_count
  end
end
