module API
  module Graphql
    class Client < Base

      def user_repos(user_login)
        post(user_repo_query, { login: user_login })
      end

      def user_repo_commits(user_login, repo_name)
        variables = { login: user_login, repo_name: repo_name }
        post(user_repo_commits_query, variables)
      end

      private

      def user_repo_query
        %{  
          query ($login: String = "matz"){
            repositoryOwner(login: $login) {
              ... on User {
                repositories(first: 10) {
                  edges {
                    node {
                      name,
                      createdAt,
                      description
                    }
                  }
                }
              }
            }
          }
        }
      end

      def user_repo_commits_query
        %{
          query ($login: String = "matz", $repo_name: String = "streem"){
            repository(owner: $login, name: $repo_name) {
              object(expression:"master"){
                ... on Commit {
                  history(first: 10) {
                    edges {
                      node {
                        id
                        message
                        committedDate
                      }
                    }
                  }
                }
              }
            }
          }
        }
      end
    end
  end
end