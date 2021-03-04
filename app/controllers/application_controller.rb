class ApplicationController < ActionController::Base
before_action :repo_object,
              :contributor_objects,
              :pull_objects

  def repo_object
    @repo ||= GithubService.repo_object
  end

  def contributor_objects
    @contributors ||= GithubService.contributor_objects
  end

  def pull_objects
    @pulls ||= GithubService.pull_objects
  end
end
