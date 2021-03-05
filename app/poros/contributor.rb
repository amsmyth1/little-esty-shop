class Contributor
  attr_reader :user_name,
              :commit_count

  def initialize(data)
    @user_name = data[:login]
    @commits = []
    @commit_count = @commits.count
  end
end
