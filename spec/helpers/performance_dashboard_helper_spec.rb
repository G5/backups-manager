require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:unsorted_unhealthy) { unhealthy_unsorted_apps }
  let(:sorted_healthy) { sorted_unhealthy_apps }
  let(:markup) { "<li><a href=\"javascript:void(0)\" class=\"js-accordion-trigger\">CLS (2)</a><ul class=\"submenu\"><li><div class='tooltip-item'>g5-cls-unhealthy-app1<div class='tooltip'><h6>REPUTATION: </h6><p>Unexpected error: {\"error\":\"Unauthorized\"} (status code: 401)</p><h6>CXM: </h6><p>Unexpected error: {\"error\":\"Unauthorized\"} (status code: 401)</p><h6>HUB: </h6><p>undefined method `all' for #<G5HubApi::NotificationService:0x007fb85f11da40></p><p></p></div></div><div class='tooltip-item'>g5-cls-unhealthy-app2<div class='tooltip'><h6>FAILED LEADS LAST 7 DAYS: </h6><p>Failed leads: 18</p><p></p></div></div></li></ul></li><li><a href=\"javascript:void(0)\" class=\"js-accordion-trigger\">CMS (1)</a><ul class=\"submenu\"><li><div class='tooltip-item'>g5-cms-unhealthy-app<div class='tooltip'><h6>LAST HTML FORM LEAD: </h6><p>No HtmlFormPayload leads found</p><h6>LAST VOICESTAR CALL LEAD: </h6><p>No VoicestarCallPayload leads found</p><p></p></div></div></li></ul></li>" }

  describe "#sort_unhealthy_apps_by_type" do
    subject { helper.sort_unhealthy_apps_by_type(unsorted_unhealthy) }

    it { should eq(sorted_healthy)}
  end

  describe "#wrangle_unhealthy_apps" do
    subject { helper.wrangle_unhealthy_apps(unsorted_unhealthy) }

    it { should eq(markup) }
  end
end
