class GithubRoutes < Application
  namespace '/user' do
    get '/:login' do
      service = ResponseService.new(
        client: API::Graphql::Client.new, 
        mapper_class: DataMapper::Base
      )
      
      service.get_user_repositories!(params[:login])
      render_result(service)
    end

    get '/:login/:repo' do
      service = ResponseService.new(
        client: API::Graphql::Client.new, 
        mapper_class: DataMapper::Base
      )
      
      service.get_repo_commits!(params[:login], params[:repo])
      render_result(service)
    end
  end

  private

  def render_result(service)
    if service.success?
      json service.response
    else
      json service.decorated_errors
    end
  end
end
