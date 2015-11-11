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
      },
      {
        "id": 2,
        "name": "Non Reporting Test App 2",
        "language": "ruby",
        "health_status": "gray",
        "reporting": false,
        "last_reported_at": "2015-10-28T22:48:42+00:00",
      }
    ]
  }
end

def fake_pagerduty_oncall
  {
    "escalation_policies": [
      {
        "id": "PAM4FGS",
        "name": "All",
        "escalation_rules": [
          {
            "id": "PZ8X4N7",
            "escalation_delay_in_minutes": 30,
            "rule_object": {
              "id": "PEPV0NJ",
              "name": "Cordell Simonis",
              "type": "user",
              "email": "simonis_cordell@acme.com",
              "time_zone": "Eastern Time (US & Canada)",
              "color": "dark-slate-blue"
            }
          },
          {
            "id": "POQA264",
            "escalation_delay_in_minutes": 34,
            "rule_object": {
              "id": "PF9KMXH",
              "name": "Layered",
              "type": "schedule"
            }
          }
        ],
        "services": [
          {
            "id": "PBAZLIU",
            "name": "Service Alpha",
            "integration_email": "alpha@acme.pagerduty.dev",
            "html_url": "https://acme.pageduty.com/services/PBAZLIU",
            "escalation_policy_id": "PAM4FGS"
          },
          {
            "id": "PIJ90N7",
            "name": "Service Mail",
            "integration_email": "email_1@acme.pagerduty.dev",
            "html_url": "https://acme.pageduty.com/services/PIJ90N7",
            "escalation_policy_id": "PAM4FGS"
          }
        ],
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
        ],
        "num_loops": 0
      },
      {
        "id": "P29NBY9",
        "name": "Beta",
        "escalation_rules": [
          {
            "id": "PP3NI0M",
            "escalation_delay_in_minutes": 30,
            "rule_object": {
              "id": "PF9KMXH",
              "name": "Layered",
              "type": "schedule"
            }
          }
        ],
        "services": [
          {
            "id": "P2KFHAO",
            "name": "BetaDense",
            "service_key": "665ee8b4ab8446d1b7a8675b40047a2f",
            "html_url": "https://acme.pageduty.com/services/P2KFHAO",
            "escalation_policy_id": "P29NBY9"
          },
          {
            "id": "PUS0KTE",
            "name": "Note of Keys",
            "integration_email": "note-of-keys@acme.pagerduty.com",
            "html_url": "https://acme.pageduty.com/services/PUS0KTE",
            "escalation_policy_id": "P29NBY9"
          }
        ],
        "on_call": [
          {
            "level": 1,
            "start": "2014-03-03T20:00:00Z",
            "end": "2014-03-07T20:00:00Z",
            "user": {
              "id": "P9TX7YH",
              "name": "John Smith",
              "email": "john@example.com",
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
              "name": "Aliya Bradtke",
              "email": "email_1@acme.pagerduty.dev",
              "time_zone": "Pacific Time (US & Canada)",
              "color": "purple"
            }
          },
          {
            "level": 3,
            "start": nil,
            "end": nil,
            "user": {
              "id": "P3IMGZ3",
              "name": "Aliya Bradtke",
              "email": "email_1@acme.pagerduty.dev",
              "time_zone": "Pacific Time (US & Canada)",
              "color": "brown"
            }
          }
        ],
        "num_loops": 1
      }
    ],
    "limit": 25,
    "offset": 0,
    "total": 14
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
              "type": "us"
            }
          }
        ],
        "trigger_summary_data": {
          "subject": "Opened on the web ui"
        },
        "trigger_details_html_url": "https://acme.pagerduty.com/incidents/P2A6J96/log_entries/P2NQP6P",
        "last_status_change_on": "2012-09-11T22:49:21Z",
        "last_status_change_by": nil,
        "urgency": "high"
      },
      {
        "incident_number": 3,
        "created_on": "2012-09-11T22:54:08Z",
        "status": "acknowledged",
        "html_url": "https://acme.pagerduty.com/incidents/PBXG6JS",
        "incident_key": "=?UTF-8?B?SnVzdCBhbiBlbWFpbCBmcm9tIOWvjOWjq+WxsSBhbmQg8J2EnvCdlaXwnZ+2IPCggoo=?=",
        "pending_actions": [
          {
            "type": "unacknowledge",
            "at": "2012-09-12T00:25:49Z"
          }
        ],
        "service": {
          "id": "PFRV88L",
          "name": "Generic Email",
          "description": "Description for Generic Email Service.",
          "html_url": "https://acme.pagerduty.com/services/PFRV88L"
        },
        "assigned_to_user": {
          "id": "PEO3O45",
          "name": "John",
          "email": "john@acme.com",
          "html_url": "https://acme.pagerduty.com/users/PEO3O45"
        },
        "assigned_to": [
          {
            "at": "2012-09-11T22:54:08Z",
            "object": {
              "id": "PEO3O45",
              "name": "John",
              "email": "john@acme.com",
              "html_url": "https://acme.pagerduty.com/users/PEO3O45",
              "type": "user"
            }
          },
          {
            "at": "2012-09-11T22:54:08Z",
            "object": {
              "id": "PMI6007",
              "name": "James",
              "email": "james@acme.com",
              "html_url": "https://acme.pagerduty.com/users/PMI6007",
              "type": "user"
            }
          }
        ],
        "acknowledgers": [
          {
            "at": "2012-09-11T22:55:01Z",
            "object": {
              "id": "PMI6007",
              "name": "James",
              "email": "james@acme.com",
              "html_url": "https://acme.pagerduty.com/users/PMI6007",
              "type": "user"
            }
          },
          {
            "at": "2012-09-11T22:55:32Z",
            "object": {
              "type": "api"
            }
          },
          {
            "at": "2012-09-11T23:25:49Z",
            "object": {
              "id": "PMI6007",
              "name": "James",
              "email": "james@acme.com",
              "html_url": "https://acme.pagerduty.com/users/PMI6007",
              "type": "user"
            }
          }
        ],
        "trigger_summary_data": {
          "subject": "Just an email from 富士山 and 𝄞𝕥𝟶 𠂊"
        },
        "trigger_details_html_url": "https://acme.pagerduty.com/incidents/PBXG6JS/log_entries/P30IVAT",
        "last_status_change_on": "2012-09-11T22:55:01Z",
        "last_status_change_by": {
          "id": "PMI6007",
          "name": "James",
          "email": "james@acme.com",
          "html_url": "https://acme.pagerduty.com/users/PMI6007"
        },
        "urgency": "high"
      }
    ],
    "limit": 100,
    "offset": 0,
    "total": 2
  }
end

def unhealthy_app_response
  {
    "version": "2.4.5",
    "master_version": "GITHUB_MASTER_VERSION not configured",
    "health": {
      "database": {
        "is_healthy": true,
        "message": ""
      },
      "widgets": {
        "is_healthy": false,
        "message": "Has 1 Orphan Widgets"
      },
      "OVERALL": {
        "is_healthy": false,
        "message": ""
      }
    }
  }
end

def healthy_app_response
  {
    "version": "2.4.5",
    "master_version": "GITHUB_MASTER_VERSION not configured",
    "health": {
      "database": {
        "is_healthy": true,
        "message": ""
      },
      "widgets": {
        "is_healthy": true,
        "message": ""
      },
      "OVERALL": {
        "is_healthy": true,
        "message": ""
      }
    }
  }
end

def new_relic_get_request(url)
  stub_request(:get, url).
    with(:headers => { 'X-Api-Key'=>ENV['NEW_RELIC_API_KEY']}).
    to_return(:status => 200, :body => fake_new_relic_response.to_json)
end

def pagerduty_get_request(url, fake_response)
  stub_request(:get, url).
    with(:headers => {'Authorization'=>"Token token=#{ENV['PAGER_DUTY_API_KEY']}"}).
    to_return(:status => 200, :body => fake_response.to_json)
end

def g5_ops_health_request(url, fake_response)
  stub_request(:get, url).to_return(:status => 200, :body => fake_response.to_json)
end
