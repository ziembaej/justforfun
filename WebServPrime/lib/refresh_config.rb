## Single Command to update WebServPrime nginx.config

file = "~config/nginx.conf"
new = "/opt/homebrew/etc/nginx/nginx.config"

def refresh_config
  mv `file` `new`
end

inrb refresh_config
