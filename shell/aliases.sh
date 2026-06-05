# ============================================================
# CLOBOT 인프라 운영 aliases
# SSH 접속: PEM 키 + Bastion Host(monitor-01) ProxyJump 방식
# ============================================================

# SSH 단축키
alias ssh-bastion='ssh bastion'
alias ssh-vm='ssh vm-server-01'
alias ssh-gitlab='ssh gitlab'
alias ssh-sonar='ssh sonarqube'
alias ssh-vm2='ssh vm-server-02'

# Docker
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dlog='docker logs --tail=100 -f'

# 모니터링
alias prom-reload='ssh bastion "docker kill -s HUP prometheus" && echo "Prometheus reloaded"'
alias grafana='echo "https://monitor.clobot.co.kr"'
alias graylog='ssh bastion "docker logs graylog --tail=50"'

# 백업 상태 확인
alias backup-status='ssh bastion "cat /var/lib/node_exporter/textfile/*.prom | grep -E \"success|timestamp\""'

# HAProxy reload (무중단)
alias haproxy-reload='ssh bastion "docker kill -s HUP haproxy" && echo "HAProxy reloaded"'

# 자주 쓰는 git
alias gs='git status'
alias gl='git log --oneline -10'
alias gp='git push'
alias gpl='git pull'
