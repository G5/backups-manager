module AppRowHelper
  ALERT_CLASS_NAME = "alert-flag"

  def dyno_has_metadata?(dyno)
    dyno.class == Hash && dyno["quantity"] >= 1
  end

  def dyno_info_id(dyno)
    return ALERT_CLASS_NAME if dyno["quantity"] >= 3
  end

  def db_plan_id(plan)
    return ALERT_CLASS_NAME if (plan != "hobby-dev" && plan != "dev")
  end
end
