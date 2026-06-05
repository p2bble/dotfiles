# =============================================================================
# DevOps / Infra 운영 aliases
# [CUSTOMIZE] 서버 hostname은 ~/.ssh/config 의 Host 명과 일치시킬 것
# =============================================================================

# ── SSH 단축키 ────────────────────────────────────────────────────────────────
alias ssh-bastion='ssh bastion'
alias ssh-app1='ssh app-server-01'
alias ssh-app2='ssh app-server-02'
alias ssh-gitlab='ssh gitlab'
alias ssh-db='ssh db-server'

# ── Docker ────────────────────────────────────────────────────────────────────
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dlog='docker logs --tail=100 -f'
alias dclean='docker system prune -f && docker volume prune -f'
alias dstats='docker stats --no-stream'

# ── Prometheus / Grafana ──────────────────────────────────────────────────────
alias prom-reload='ssh bastion "docker kill -s HUP prometheus" && echo "Prometheus reloaded"'
alias am-reload='ssh bastion "docker kill -s SIGHUP alertmanager" && echo "Alertmanager reloaded"'
alias grafana-open='echo "http://$(ssh bastion "hostname -I | awk \"{print \$1}\""):3000"'

# ── 인프라 점검 ───────────────────────────────────────────────────────────────
alias disk-all='for h in bastion app-server-01 app-server-02; do echo "=== $h ==="; ssh $h "df -h | grep -v tmpfs"; done'
alias mem-all='for h in bastion app-server-01 app-server-02; do echo "=== $h ==="; ssh $h "free -h"; done'
alias docker-all='for h in bastion app-server-01; do echo "=== $h ==="; ssh $h "docker ps --format \"{{.Names}} {{.Status}}\""; done'

# ── Git ───────────────────────────────────────────────────────────────────────
alias gs='git status'
alias gl='git log --oneline -10'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias ga='git add -A'

# ── 기타 유틸 ─────────────────────────────────────────────────────────────────
alias ll='ls -alh'
alias grep='grep --color=auto'
alias ports='ss -tlnp'
alias myip='curl -s ifconfig.me && echo'
