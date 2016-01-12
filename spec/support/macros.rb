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

def unhealthy_unsorted_apps
  {:data => [{"name"=>"g5-cls-unhealthy-app1",
    "health"=>
    {"database"=>{"is_healthy"=>true, "message"=>""},
    "redis"=>{"is_healthy"=>true, "message"=>"PONG"},
    "reputation"=>
    {"is_healthy"=>false, "message"=>"Unexpected error: {\"error\":\"Unauthorized\"} (status code: 401)"},
    "cxm"=>{"is_healthy"=>false, "message"=>"Unexpected error: {\"error\":\"Unauthorized\"} (status code: 401)"},
    "core"=>{"is_healthy"=>true, "message"=>""},
    "hub"=>
    {"is_healthy"=>false, "message"=>"undefined method `all' for #<G5HubApi::NotificationService:0x007fb85f11da40>"},
    "OVERALL"=>{"is_healthy"=>false, "message"=>""}}},
    {"name"=>"g5-cls-unhealthy-app2",
      "health"=>
      {"Total Failed Leads"=>{"is_healthy"=>true, "message"=>"Total failed leads: 332"},
      "Failed Leads Last 7 days"=>{"is_healthy"=>false, "message"=>"Failed leads: 18"},
      "Last Html Form Lead"=>{"is_healthy"=>true, "message"=>"Last lead submitted at: 2015-11-19 09:41:54 -0800"},
      "Last Voicestar Call Lead"=>{"is_healthy"=>true, "message"=>"Last lead submitted at: 2015-11-19 09:43:43 -0800"},
      "Call Tracking"=>{"is_healthy"=>true, "message"=>"No backfilled calls"},
      "Core Store location_urn Existence"=>{"is_healthy"=>true, "message"=>"No Stores lacking a location_urn"},
      "database"=>{"is_healthy"=>true, "message"=>""},
      "OVERALL"=>{"is_healthy"=>false, "message"=>""}}},
      {"name"=>"g5-cms-unhealthy-app",
        "health"=>
        {"Total Failed Leads"=>{"is_healthy"=>true, "message"=>"Total failed leads: 0"},
        "Failed Leads Last 7 days"=>{"is_healthy"=>true, "message"=>"No failed leads"},
        "Last Html Form Lead"=>{"is_healthy"=>false, "message"=>"No HtmlFormPayload leads found"},
        "Last Voicestar Call Lead"=>{"is_healthy"=>false, "message"=>"No VoicestarCallPayload leads found"},
        "Call Tracking"=>{"is_healthy"=>true, "message"=>"No backfilled calls"},
        "Core Store location_urn Existence"=>{"is_healthy"=>true, "message"=>"No Stores lacking a location_urn"},
        "database"=>{"is_healthy"=>true, "message"=>""},
        "OVERALL"=>{"is_healthy"=>false, "message"=>""}}}]}
end

def sorted_unhealthy_apps
  {
    "cls" => [
      {"name"=>"g5-cls-unhealthy-app1",
      "health"=>
       {"database"=>{"is_healthy"=>true, "message"=>""},
        "redis"=>{"is_healthy"=>true, "message"=>"PONG"},
        "reputation"=>
         {"is_healthy"=>false, "message"=>"Unexpected error: {\"error\":\"Unauthorized\"} (status code: 401)"},
        "cxm"=>{"is_healthy"=>false, "message"=>"Unexpected error: {\"error\":\"Unauthorized\"} (status code: 401)"},
        "core"=>{"is_healthy"=>true, "message"=>""},
        "hub"=>
         {"is_healthy"=>false, "message"=>"undefined method `all' for #<G5HubApi::NotificationService:0x007fb85f11da40>"},
        "OVERALL"=>{"is_healthy"=>false, "message"=>""}}},
     {"name"=>"g5-cls-unhealthy-app2",
      "health"=>
       {"Total Failed Leads"=>{"is_healthy"=>true, "message"=>"Total failed leads: 332"},
        "Failed Leads Last 7 days"=>{"is_healthy"=>false, "message"=>"Failed leads: 18"},
        "Last Html Form Lead"=>{"is_healthy"=>true, "message"=>"Last lead submitted at: 2015-11-19 09:41:54 -0800"},
        "Last Voicestar Call Lead"=>{"is_healthy"=>true, "message"=>"Last lead submitted at: 2015-11-19 09:43:43 -0800"},
        "Call Tracking"=>{"is_healthy"=>true, "message"=>"No backfilled calls"},
        "Core Store location_urn Existence"=>{"is_healthy"=>true, "message"=>"No Stores lacking a location_urn"},
        "database"=>{"is_healthy"=>true, "message"=>""},
        "OVERALL"=>{"is_healthy"=>false, "message"=>""}}}
    ],
    "cms" => [
      {"name"=>"g5-cms-unhealthy-app",
       "health"=>
        {"Total Failed Leads"=>{"is_healthy"=>true, "message"=>"Total failed leads: 0"},
         "Failed Leads Last 7 days"=>{"is_healthy"=>true, "message"=>"No failed leads"},
         "Last Html Form Lead"=>{"is_healthy"=>false, "message"=>"No HtmlFormPayload leads found"},
         "Last Voicestar Call Lead"=>{"is_healthy"=>false, "message"=>"No VoicestarCallPayload leads found"},
         "Call Tracking"=>{"is_healthy"=>true, "message"=>"No backfilled calls"},
         "Core Store location_urn Existence"=>{"is_healthy"=>true, "message"=>"No Stores lacking a location_urn"},
         "database"=>{"is_healthy"=>true, "message"=>""},
         "OVERALL"=>{"is_healthy"=>false, "message"=>""}}}
    ]
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

def pagerduty_incident_webhook
  {
    "messages": [
      {
        "id": "bb8b8fe0-e8d5-11e2-9c1e-22000afd16cf",
        "created_on": "2013-07-09T20:25:44Z",
        "type": "incident.trigger",
        "data": {
          "incident": {
            "id": "PIJ90N7",
            "incident_number": 1,
            "created_on": "2013-07-09T20:25:44Z",
            "status": "triggered",
            "html_url": "https://acme.pagerduty.com/incidents/PIJ90N7",
            "incident_key": "null",
            "service": {
              "id": "PBAZLIU",
              "name": "service",
              "html_url": "https://acme.pagerduty.com/services/PBAZLIU"
            },
            "assigned_to_user": {
              "id": "PPI9KUT",
              "name": "Alan Kay",
              "email": "alan@pagerduty.com",
              "html_url": "https://acme.pagerduty.com/users/PPI9KUT"
            },
            "trigger_summary_data": {
              "subject": "45645"
            },
            "trigger_details_html_url": "https://acme.pagerduty.com/incidents/PIJ90N7/log_entries/PIJ90N7",
            "last_status_change_on": "2013-07-09T20:25:44Z",
            "last_status_change_by": "null"
          }
        }
      },
      {
        "id": "8a1d6420-e9c4-11e2-b33e-f23c91699516",
        "created_on": "2013-07-09T20:25:45Z",
        "type": "incident.resolve",
        "data": {
          "incident": {
            "id": "PIJ90N7",
            "incident_number": 2,
            "created_on": "2013-07-09T20:25:44Z",
            "status": "resolved",
            "html_url": "https://acme.pagerduty.com/incidents/PIJ90N7",
            "incident_key": "null",
            "service": {
              "id": "PBAZLIU",
              "name": "service",
              "html_url": "https://acme.pagerduty.com/services/PBAZLIU"
            },
            "assigned_to_user": "null",
            "resolved_by_user": {
              "id": "PPI9KUT",
              "name": "Alan Kay",
              "email": "alan@pagerduty.com",
              "html_url": "https://acme.pagerduty.com/users/PPI9KUT"
            },
            "trigger_summary_data": {
              "subject": "45645"
            },
            "trigger_details_html_url": "https://acme.pagerduty.com/incidents/PIJ90N7/log_entries/PIJ90N7",
            "last_status_change_on": "2013-07-09T20:25:45Z",
            "last_status_change_by": {
              "id": "PPI9KUT",
              "name": "Alan Kay",
              "email": "alan@pagerduty.com",
              "html_url": "https://acme.pagerduty.com/users/PPI9KUT"
            }
          }
        }
      }
    ]
  }
end
