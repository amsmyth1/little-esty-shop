class WelcomeController < ApplicationController
  def index
    @repo = GithubService.repo_object("https://api.github.com/repos/amsmyth1/little-esty-shop")
  end
end
