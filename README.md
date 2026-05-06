# dotfiles

개인 개발 환경 설정 파일 모음. 새 환경에서 `install.sh` 하나로 복원 가능.

---

## 구성

```
.
├── install.sh          # 심볼릭 링크 자동 설정
│
├── ssh/
│   └── config          # SSH 서버 접속 설정 (ProxyJump, IdentityFile 등)
│
├── git/
│   └── .gitconfig      # 사용자 정보, alias, core 설정
│
└── shell/
    └── aliases.sh      # SSH 단축키, Docker, 모니터링 alias 모음
```

---

## 설치

```bash
git clone https://github.com/p2bble/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
source ~/.bashrc
```

---

## 주요 alias

| alias | 실제 명령 |
|---|---|
| `ssh-pdk` | `ssh pdkcld1` |
| `ssh-vm` | `ssh vm-server-01` |
| `ssh-gitlab` | `ssh gitlab-srv` |
| `ssh-gpu` | `ssh gpu-server` |
| `dc` | `docker compose` |
| `dps` | docker ps (포맷 정리) |
| `prom-reload` | Prometheus 설정 리로드 |
| `backup-status` | 모든 서버 백업 메트릭 확인 |
| `gs` / `gl` / `gp` | git status / log / push |

---

## SSH config 서버 목록

| Host | IP | 비고 |
|---|---|---|
| pdkcld1 | 172.19.100.10 | 모니터링 서버, KVM 호스트 |
| vm-server-01 | 172.18.100.20 | Graylog, SonarQube, n8n |
| gitlab-srv | 172.18.100.21 | GitLab CE |
| dev-srv | 172.18.100.48 | pdkcld1 2번 NIC |
| gpu-server | 172.19.100.21 | ProxyJump via pdkcld1 |
| kvmhost | 192.168.100.247 | — |
| k8s-incheon-airport | 192.168.100.201 | 인천공항 K8s |
