
require "../src/redirect_to_www"

full_cmd = ARGV.map(&.strip).join(' ')


case
when full_cmd == "service run"
  Redirect_To_WWW.service_run

else
  DA.exit_with_error!("!!! No command found for: #{full_cmd}")
end # case
