class ResponseService
  extend Dry::Initializer

  option :client
  option :mapper_class
  option :errors, default: proc { [] }, optional: true

  attr_reader :response

  def success?
    errors.empty?
  end

  def get_user_repositories!(login)
    @response = client.user_repos(login)
    body = JSON.parse(response.body) if @response.success?

    errors << 'User login is incorrect' if body&.dig('data', 'repositoryOwner').nil?
    return unless success?

    mapper = mapper_class.new(
      schema_path:  'app/services/data_mapper/schemas/user_repo.yml', 
      input_hash:   body.merge(user_name_hash(login))
    )
    @response = mapper.call
  end

  def get_repo_commits!(login, repo_name)
    @response = client.user_repo_commits(login, repo_name)
    body = JSON.parse(response.body) if @response.success?

    @errors << 'repo name is incorrect' if body&.dig('data', 'repository').nil?
    return unless success?

    mapper = mapper_class.new(
      schema_path: 'app/services/data_mapper/schemas/repo_commits.yml', 
      input_hash: body.merge(repo_name_hash(repo_name)) 
    )
    @response = mapper.call
  end

  def decorated_errors
    {
      response: {
        error: errors.join(', ')
      }
    }
  end

  private

  def user_name_hash(login)
    { 'user' => { 'name' => login } }
  end

  def repo_name_hash(repo_name)
    { 'repo_name' => repo_name }
  end
end