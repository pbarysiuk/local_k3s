1. it  all in progrees, do as i have time.
2. mkcert used on mac to make CA + cert + key to spin ingress with httpS:// within localhost environment.
> mkcert -key-file key.pem -cert-file cert.pem k8s.dev.localhost "*.k8s.dev.localhost" k8s.dev.localhost  grafana.k8s.dev.localhost
3. simple play&apply (some bags came out on init apply, wb fixed.)