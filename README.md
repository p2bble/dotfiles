# dotfiles

개인 개발 환경 설정 파일 모음. 새 환경에서 `install.sh` 하나로 복원 가능.

---

## 구성

```
.
├── install.sh              # 심볼릭 링크 자동 설정
│
├── ssh/
│   └── config              # Bastion + ProxyJump SSH 접속 설정 (플레이스홀더)
│
├── git/
│   └── .gitconfig          # 사용자 정보, alias, core 설정
│
├── shell/
│   └── aliases.sh          # SSH 단축키, Docker, 모니터링 alias
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

**PEM 키 + Bastion Host ProxyJump** 패턴을 사용합니다.  
`ssh/config`의 `[CUSTOMIZE]` 항목을 실제 환경 값으로 교체하세요.

```bash
# ~/.ssh/config 적용 후 (install.sh가 심볼릭 링크 생성)
ssh bastion          # 게이트웨이/모니터링 서버
ssh app-server-01    # bastion 경유 자동 ProxyJump
ssh gitlab           # bastion 경유 자동 ProxyJump
```

> 상세 가이드: [docs/SSH_접근관리_가이드.md](./docs/SSH_접근관리_가이드.md)

---

## SSH config 커스터마이징

`ssh/config` 파일에서 `[CUSTOMIZE]` 주석이 있는 값을 교체합니다.

| 항목 | 설명 |
|------|------|
| `HostName` | 실제 서버 IP |
| `User` | SSH 계정명 |
| `IdentityFile` | PEM 개인키 경로 (`~/.ssh/your_key`) |

Host 이름은 aliases.sh의 `ssh-*` 단축키와 일치시켜 사용합니다.

---

## 주요 alias

| alias | 설명 |
|-------|------|
| `ssh-bastion` | Bastion 서버 접속 |
| `ssh-app1 / app2` | 앱 서버 접속 |
| `dc` | docker compose 단축 |
| `dps` | 컨테이너 목록 (포맷 정리) |
| `dlog` | 컨테이너 로그 tail |
| `prom-reload` | Prometheus 설정 무중단 반영 |
| `disk-all` | 전체 서버 디스크 현황 일괄 확인 |
| `mem-all` | 전체 서버 메모리 현황 일괄 확인 |
| `gs / gl / gp` | git status / log / push |
