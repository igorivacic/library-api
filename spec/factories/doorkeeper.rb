FactoryBot.define do
  factory :access_grant, class: 'Doorkeeper::AccessGrant' do
    sequence(:resource_owner_id) { |n| n }
    application
    redirect_uri { 'https://app.com/callback' }
    expires_in { 100 }
    scopes { 'public write' }
  end

  factory :access_token, class: 'Doorkeeper::AccessToken' do
    sequence(:resource_owner_id) { |n| n }
    application
    expires_in { 2.hours }

    factory :clientless_access_token do
      application { nil }
    end
  end

  factory :doorkeeper_app, class: 'Doorkeeper::Application' do
    sequence(:name) { |n| "Application #{n}" }
    secret { '123' }
    redirect_uri { 'https://example.com' }
    scopes { 'library_app' }
  end
end
