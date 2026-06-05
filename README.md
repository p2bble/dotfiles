# dotfiles

개인 개발 환경 설정 파일 모음. 새 환경에서 `install.sh` 하나로 복원 가능.

---

## 구성

```
.
├── install.sh          # 심볼릭 링크 자동 설정
│
├── ssh/
│   └── config          # Bastion + ProxyJump 기반 SSH 접속 설정
│
├── git/
│   └── .gitconfig      # 사용자 정보, alias, core 설정
│
├── shell/
│   └── aliases.sh      # SSH 단축키, Docker, 모니터링 alias 모음
│
└── docs/
    └── SSH_접근관리_가이드.md   # PEM 키 + Bastion 환경 세팅 가이드
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

## SSH 접속 방식

**PEM 키 + Bastion Host(monitor-01) ProxyJump** 방식을 사용합니다.

```bash
# 1. PEM 키 준비
cp clobot_infra ~/.ssh/clobot_infra
chmod 600 ~/.ssh/clobot_infra

# 2. SSH config 적용 (install.sh가 자동으로 심볼릭 링크 생성)
bash install.sh

# 3. 접속
ssh bastion       # monitor-01 직접 접속
ssh vm-server-01  # bastion 경유 자동 ProxyJump
ssh gitlab        # bastion 경유 자동 ProxyJump
```

> 상세 설정 가이드: [docs/SSH_접근관리_가이드.md](./docs/SSH_접근관리_가이드.md)

---

## SSH config 서버 목록

| Host | IP | 역할 |
|---|---|---|
| `bastion` | 172.18.100.48 | monitor-01 내부 (Bastion Host) |
| `bastion-dmz` | 172.19.100.10 | monitor-01 DMZ (외부 접속용) |
| `vm-server-01` | 172.18.100.20 | DevOps 서비스, GitLab Runner |
| `gitlab` | 172.18.100.21 | GitLab CE |
| `sonarqube` | 172.18.100.22 | 코드 품질 분석 |
| `vm-server-02` | 172.18.100.49 | KVM 호스트, 팀/개인 VM |
| `croms-rx-core-dev` | 172.18.100.122 | CROMS RX Core 개발 |
| `croms-rx-core-stage` | 172.18.100.123 | CROMS RX Core QA |
| `k8s-rx-dev-master` | 172.18.100.124 | 세방 K8s 마스터 |
| `croms-rx-UXUI` | 172.18.100.127 | RX 시뮬레이터 개발 |
| `croms-core-UXUI` | 172.18.100.131 | CROMS UI/UX 개선 |
| `prod-croms-rx` | 10.10.150.119 | 세방 AMR 현장 (VPN 경유) |

---

## 주요 alias

| alias | 실제 명령 | 설명 |
|---|---|---|
| `ssh-bastion` | `ssh bastion` | monitor-01 접속 |
| `ssh-vm` | `ssh vm-server-01` | DevOps 서버 접속 |
| `ssh-gitlab` | `ssh gitlab` | GitLab 서버 접속 |
| `ssh-sonar` | `ssh sonarqube` | SonarQube 서버 접속 |
| `dc` | `docker compose` | Docker Compose 단축 |
| `dps` | `docker ps` (포맷 정리) | 컨테이너 목록 |
| `dlog` | `docker logs --tail=100 -f` | 컨테이너 로그 |
| `prom-reload` | Prometheus 설정 리로드 | bastion 경유 |
| `backup-status` | 백업 메트릭 확인 | bastion 경유 |
| `gs` / `gl` / `gp` | git status / log / push | Git 단축 |
