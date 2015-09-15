FactoryGirl.define do
  factory :organization do
    email "test-organization@herokumanager.com"
    guid "12345-ABCDE"
  end

  factory :app do
    organization
    name "test-app"
    app_details {
      {
        "id": "11111111-2222-3333-4444-555555555555",
        "git_url": "git@heroku.com:test-app.git",
        "web_url" => "https://example.com/test-app",
        "updated_at" => "2015-09-10T19:00:09Z"
      }
    }
    dynos {
      [
        {
            "app": {
              "id": "11111111-2222-3333-4444-555555555555",
              "name": "test-app"
            },
            "command": "bundle exec rails server -p $PORT -e $RACK_ENV",
            "created_at": "2015-07-02T19:06:07Z",
            "id": "222222222-33333-44444-5555-6666666666666",
            "type": "web",
            "quantity": 1,
            "size": "Standard-2X",
            "updated_at": "2015-08-25T22:05:27Z"
        }
      ]
    }
    config_variables {
      [
        {
          "LANG": "en_US.UTF-8",
          "RAILS_ENV": "production",
          "RACK_ENV": "production"
        }
      ]
    }
    addons {
      [
        {
          "config_vars": [],
          "created_at": "2015-07-10T04:19:18Z",
          "id": "5555-12345",
          "name": "crouching-tiger-85",
          "addon_service": {
            "id": "i'm so sick of inventing ids",
            "name": "scheduler"
          },
          "plan": {
            "id": "seriously nobody will ever see this",
            "name": "scheduler:standard"
          },
          "app": {
            "id": "11111111-2222-3333-4444-555555555555",
            "name": "test-app"
          },
          "provider_id": "118426",
          "updated_at": "2015-07-10T04:19:19Z",
          "web_url": "https://addons-sso.heroku.com/apps/g5-app-wrangler/addons/5555-12345"
        }
      ]
    }
    # Not accurate, but nobody cares about domains when it's not a CLW. I hope.
    domains {}
  end

  factory :clw_app, parent: :app do
    name "test-clw-app"
    domains {
      [
        {
          "app": {
            "id": "11111111-2222-3333-4444-555555555555",
            "name": "test-clw-app"
          },
          "created_at": "2015-07-02T19:06:06Z",
          "hostname": "example.com/test-app",
          "id": "blahblah",
          "updated_at": "2015-07-15T05:23:38Z"
        }
      ]
    }
  end

  factory :invoice do
    organization
    period_start "2015-09-12"
    period_end "2015-09-12"
    total 1000
    dyno_units 20.5
  end
end
