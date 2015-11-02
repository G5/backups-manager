def fake_new_relic_response
  {
    "applications": [
      {
        "id": 1,
        "name": "Test App",
        "language": "ruby",
        "health_status": "green",
        "reporting": true,
        "last_reported_at": "2015-10-28T22:48:42+00:00",
        "application_summary": {
          "response_time": 435,
          "throughput": 1620,
          "error_rate": 0,
          "apdex_target": 0.5,
          "apdex_score": 0.86,
          "host_count": 8,
          "instance_count": 44
        },
        "end_user_summary": {
          "response_time": 3.64,
          "throughput": 287,
          "apdex_target": 4,
          "apdex_score": 0.85
        },
        "settings": {
          "app_apdex_threshold": 0.5,
          "end_user_apdex_threshold": 4,
          "enable_real_user_monitoring": true,
          "use_server_side_config": true
        }
      }
    ]
  }
end

def fake_pagerduty_oncall
  {
    "on_call": [
      {
        "level": 1,
        "start": "2014-03-03T20:00:00Z",
        "end": "2014-03-07T20:00:00Z",
        "user": {
          "id": "P9TX7YH",
          "name": "Cordell Simonis",
          "email": "email_1@acme.pagerduty.dev",
          "time_zone": "Pacific Time (US & Canada)",
          "color": "dark-goldenrod"
        }
      },
      {
        "level": 2,
        "start": "2014-03-04T19:00:00Z",
        "end": "2014-03-11T18:00:00Z",
        "user": {
          "id": "P5NKEIA",
          "name": "John Smith",
          "email": "jsmith@example.com",
          "time_zone": "Pacific Time (US & Canada)",
          "color": "purple"
        }
      }
    ]
  }
end

def fake_pagerduty_incidents
  {
    "incidents": [
      {
        "incident_number": 1,
        "created_on": "2012-09-11T22:49:21Z",
        "status": "triggered",
        "html_url": "https://acme.pagerduty.com/incidents/P2A6J96",
        "incident_key": nil,
        "pending_actions": [
          {
            "type": "escalate",
            "at": "2012-09-11T22:59:21Z"
          }
        ],
        "service": {
          "id": "PBF77WY",
          "name": "Generic Api",
          "description": "Description for Generic Api Service.",
          "html_url": "https://acme.pagerduty.com/services/PBF77WY"
        },
        "assigned_to_user": {
          "id": "PEO3O45",
          "name": "John",
          "email": "john@acme.com",
          "html_url": "https://acme.pagerduty.com/users/PEO3O45"
        },
        "assigned_to": [
          {
            "at": "2012-09-11T22:49:21Z",
            "object": {
              "id": "PEO3O45",
              "name": "John",
              "email": "john@acme.com",
              "html_url": "https://acme.pagerduty.com/users/PEO3O45",
              "type": "user"
            }
          }
        ],
      }]
  }
end

def new_relic_get_request(url)
  stub_request(:get, url).
    with(:headers => { 'X-Api-Key'=>ENV['NEW_RELIC_API_KEY']}).
    to_return(:status => 200, :body =>new_relic_response .to_json)
end

def pagerduty_get_request(url, fake_response)
  stub_request(:get, url).
    with(:headers => {'Authorization'=>"Token token=#{ENV['PAGER_DUTY_API_KEY']}"}).
    to_return(:status => 200, :body => fake_response.to_json)
end
