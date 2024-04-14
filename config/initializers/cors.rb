Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://0.0.0.0:3000'  # En développement, c'est OK, mais en production, remplacez '*' par les origines que vous voulez autoriser
      resource '*',  # Cela autorise l'accès à toutes les ressources
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        expose: ['Authorization']  # Utile si vous utilisez des jetons dans les en-têtes pour l'authentification
    end
  end
  