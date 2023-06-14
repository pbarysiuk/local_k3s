1. it  all in progrees, do as i have time.
2. mkcert used on mac to make CA + cert + key to spin ingress with httpS:// within localhost environment.
> mkcert -key-file key.pem -cert-file cert.pem k8s.dev.localhost "*.k8s.dev.localhost" k8s.dev.localhost  grafana.k8s.dev.localhost
3. simple play&apply (some bags came out on init apply, wb fixed.)

things to be done
1. pv for storing some data like configs/data/resutls (grafana&prometheus first)
2. build simple go app which return echo with server name (pod name + timestamp)