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

  factory :ssl_app, parent: :app do
    addons {
      [
        {
          "config_vars" => [],
          "created_at" => "2015-06-30T19:56:20Z",
          "id" => "whatevs",
          "name" => "dont-matter",
          "addon_service" =>  { "id" => "whatevs", "name" => "ssl" },
          "plan" => { "id" => "whatevs", "name" => "ssl:endpoint" },
          "app" => { "id" => "whatevs", "name" => "g5-cms-12345-test" },
          "provider_id" => "testing@heroku.com",
          "updated_at" => "2015-06-30T19:56:21Z",
          "web_url" => nil
        },
      ]
    }
  end

  factory :paid_db_app, parent: :app do
    addons {
      [
        {
          "config_vars" => ["DATABASE_URL", "HEROKU_POSTGRESQL_PINK_URL"],
          "created_at" => "2015-09-08T17:22:12Z",
          "id" => "noooope",
          "name" => "postgresql-angular-1",
          "addon_service" =>  { "id" => "noooope", "name" => "heroku-postgresql" },
          "plan" => { "id" => "noooope", "name" => "heroku-postgresql:hobby-basic" },
          "app" => { "id" => "noooope", "name" => "g5-cms-12345-testing" },
          "provider_id" => "9629603",
          "updated_at" => "2015-09-08T17:22:12Z",
          "web_url" => "https://postgres.heroku.com/discover?hid=testing@heroku.com"
        },
        {
          "config_vars" => ["DATABASE_URL", "HEROKU_POSTGRESQL_PINK_URL"],
          "created_at" => "2015-09-08T17:22:12Z",
          "id" => "noooope",
          "name" => "postgresql-angular-2",
          "addon_service" =>  { "id" => "noooope", "name" => "heroku-postgresql" },
          "plan" => { "id" => "noooope", "name" => "heroku-postgresql:hobby-dev" },
          "app" => { "id" => "noooope", "name" => "g5-cms-12345-testing" },
          "provider_id" => "9629603",
          "updated_at" => "2015-09-08T17:22:12Z",
          "web_url" => "https://postgres.heroku.com/discover?hid=testing@heroku.com"
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
