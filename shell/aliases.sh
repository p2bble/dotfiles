# ============================================================
# CLOBOT 인프라 운영 aliases
# ============================================================

# SSH 단축키
alias ssh-pdk='ssh pdkcld1'
alias ssh-vm='ssh vm-server-01'
alias ssh-gitlab='ssh gitlab-srv'
alias ssh-gpu='ssh gpu-server'
alias ssh-dev='ssh dev-srv'

# Docker
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dlog='docker logs --tail=100 -f'

# 모니터링
alias prom-reload='curl -s -X POST http://pdkcld1:9099/-/reload && echo "Prometheus reloaded"'
alias graylog='echo "http://172.18.100.20:9000"'
alias grafana='echo "http://monitor.clobot.co.kr"'

# 백업 상태 확인
alias backup-status='ssh pdkcld1 "cat /var/lib/node_exporter/textfile/*.prom | grep -E \"success|timestamp\""'

# 자주 쓰는 git
alias gs='git status'
alias gl='git log --oneline -10'
alias gp='git push'
alias gpl='git pull'
