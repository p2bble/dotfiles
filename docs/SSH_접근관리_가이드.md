# CLOBOT 인프라 SSH 접근 관리 가이드

> **작성자**: 심제범 (Stephen) | **작성일**: 2026-06-05  
> **대상**: 신규 IT 인프라 담당자  
> **목표**: PEM 키 + Bastion Host 기반으로 전체 서버에 패스워드 없이 접근

---

## 목차

1. [접근 구조 개요](#1-접근-구조-개요)
2. [전체 서버 목록](#2-전체-서버-목록)
3. [최초 환경 설정 (신규 담당자)](#3-최초-환경-설정-신규-담당자)
4. [서버 접속 방법](#4-서버-접속-방법)
5. [Windows VM 접근 (RDP)](#5-windows-vm-접근-rdp)
6. [신규 서버 키 배포 방법](#6-신규-서버-키-배포-방법)
7. [담당자 교체 시 처리 절차](#7-담당자-교체-시-처리-절차)

---

## 1. 접근 구조 개요

모든 서버 접근은 **monitor-01을 Bastion Host로 경유**합니다.  
PEM 키 1개로 전체 인프라에 접근 가능하며, 담당자 교체 시 Bastion 키 1개만 삭제하면 됩니다.

```
[관리자 PC]
    │  ~/.ssh/clobot_infra (PEM 개인키)
    ▼
 monitor-01 ── Bastion Host
 172.18.100.48 (Internal)
 172.19.100.10 (DMZ, 외부 접근 시)
    │
    ├── vm-server-01   172.18.100.20   KVM / GitLab Runner / DevOps 서비스
    ├── gitlab         172.18.100.21   GitLab CE
    ├── sonarqube      172.18.100.22   코드 정적 분석
    ├── vm-server-02   172.18.100.49   cAdvisor
    ├── Team VM        172.18.100.12x  개발 VM
    └── User VM        172.18.100.20x  개발자 개인 VM
```

> **finance-vm-01 (172.18.100.16)** 은 Windows VM으로 RDP 접근 사용 → [5장 참조](#5-windows-vm-접근-rdp)

---

## 2. 전체 서버 목록

### 2-1. 인프라 / DevOps 서버

| hostname | IP (Internal) | IP (DMZ) | 역할 | OS | 접근 |
|----------|--------------|----------|------|----|------|
| monitor-01 | 172.18.100.48 | 172.19.100.10 | HAProxy, KVM 호스트, 모니터링 스택 | Ubuntu | SSH PEM |
| vm-server-01 | 172.18.100.20 | — | KVM 호스트, GitLab Runner, DevOps 서비스 5종 | Ubuntu | SSH PEM |
| gitlab | 172.18.100.21 | — | GitLab CE v16.11.10 | Ubuntu | SSH PEM |
| sonarqube | 172.18.100.22 | — | SonarQube v25.7 코드 분석 | Ubuntu | SSH PEM |
| vm-server-02 | 172.18.100.49 | 172.19.100.20 | cAdvisor (구 dev-server) | Ubuntu | SSH PEM |
| finance-vm-01 | 172.18.100.16 | — | ERP / 재무 서버 | **Windows** | **RDP** |
| DiskStation | 172.18.100.10 | — | NAS Storage | DSM | Web UI |

### 2-2. 팀 VM (KVM on vm-server-01 / monitor-01)

| hostname | IP | 역할 | 패스워드 그룹 |
|----------|----|------|-------------|
| croms-rx-core-dev | 172.18.100.122 | CROMS RX Core 개발 | Ansdufdj11** |
| croms-rx-core-stage | 172.18.100.123 | CROMS RX Core QA | Ansdufdj11** |
| k8s-rx-dev-master | 172.18.100.124 | 세방 개발 (K8s Master) | Ansdufdj11** |
| dev-croms-incheon-airport | 172.18.100.125 | 인천국제공항 개발 | clobot1q2w#er |
| croms-rx-dev | 172.18.100.126 | 화신 봉동 개발 | clobot1q2w#er |
| croms-rx-UXUI | 172.18.100.127 | RX 시뮬레이터 개발 | clobot1q2w#er |
| cros-stage | 172.18.100.128 | 시뮬레이션 배포 | 확인 필요 |
| croms-rx-enterprise | 172.18.100.130 | CROMS 고객 시현용 | clobot1q2w#er |
| croms-core-UXUI | 172.18.100.131 | CROMS UI/UX 개선 작업용 | Ansdufdj11** |

### 2-3. 개발자 개인 VM (block 200~214)

| hostname | IP | 담당자 |
|----------|----|--------|
| user-bay | 172.18.100.200 | — |
| user-elliot | 172.18.100.201 | — |
| user-geo | 172.18.100.202 | — |
| user-harry | 172.18.100.203 | — |
| user-hugo | 172.18.100.204 | — |
| user-jacob | 172.18.100.205 | — |
| user-jade | 172.18.100.206 | — |
| user-jaxtyn | 172.18.100.207 | — |
| user-kai | 172.18.100.208 | — |
| user-lea | 172.18.100.209 | — |
| user-rain-02 | 172.18.100.211 | — |
| user-rohan | 172.18.100.212 | — |
| user-zero | 172.18.100.213 | — |
| user-wade-vm | 172.18.100.214 | — |

### 2-4. DMZ 서버 (VLAN 190)

| hostname | IP (DMZ) | 역할 |
|----------|----------|------|
| monitor-01 | 172.19.100.10 | HAProxy (외부 트래픽 진입점) |
| clobot-erp | 172.19.100.11 | ERP 서버 |
| vm-server-02 | 172.19.100.20 | DMZ NIC |
| lions-agent | 172.19.100.21 | Robot App Team (Lions) |
| 삼성 엔지니어링 | 172.19.100.23 / 172.19.100.24 | 삼성E&A 서버 / 모니터링 |
| 구)스카우트 서버 | 172.19.100.25 | 데모 서버 (외부 노출) |

### 2-5. iDRAC / 서버 관리 (block 240~246)

| 대상 서버 | iDRAC IP | 모델 |
|----------|---------|------|
| VM 서버 | 172.18.100.240 | Dell PowerEdge R750xs |
| ERP 서버 | 172.18.100.241 | Dell PowerEdge R740 |
| DEV 서버 2 | 172.18.100.242 | Dell PowerEdge R740 |
| DEV 서버 | 172.18.100.243 | — |
| 연구소 서버 | 172.18.100.244 | Dell Precision 7960 Rack |
| UPS | 172.18.100.246 | UPS Management |

---

## 3. 최초 환경 설정 (신규 담당자)

### Step 1. PEM 키 수령
인수인계 폴더에서 `clobot_infra.pem` 파일을 받아 아래 경로에 저장합니다.

```
Windows: C:\Users\<이름>\.ssh\clobot_infra
Mac/Linux: ~/.ssh/clobot_infra
```

```bash
# 권한 설정 (Mac/Linux만 필요)
chmod 600 ~/.ssh/clobot_infra
```

### Step 2. SSH config 적용
`Keys/bastion/ssh_config_template` 파일을 `~/.ssh/config`에 복사합니다.

```powershell
# Windows PowerShell
copy "C:\...\Keys\bastion\ssh_config_template" "$env:USERPROFILE\.ssh\config"
```

### Step 3. 접속 확인
```bash
ssh bastion          # monitor-01 접속 확인
ssh vm-server-01     # ProxyJump 자동 경유 확인
ssh gitlab           # GitLab 서버 접속 확인
```

---

## 4. 서버 접속 방법

### 일반 SSH 접속 (config 적용 후)
```bash
ssh bastion          # monitor-01
ssh vm-server-01
ssh gitlab
ssh sonarqube
ssh vm-server-02
ssh croms-rx-core-dev
ssh user-bay
# ... (ssh_config_template에 정의된 모든 hostname 사용 가능)
```

### 파일 전송 (SCP)
```bash
scp ./파일.txt vm-server-01:/tmp/
scp vm-server-01:/data/backup.tar.gz ./
```

### 외부(VPN 없이) 접속 시
```bash
# DMZ IP로 Bastion 접속
ssh bastion-dmz      # 172.19.100.10 경유
```

---

## 5. Windows VM 접근 (RDP)

**finance-vm-01** (172.18.100.16) 은 SSH 미사용. Windows 원격 데스크톱으로 접근합니다.

```
접속 방법: 원격 데스크톱 연결 (mstsc)
주소: 172.18.100.16
계정: clobot
※ 비밀번호는 패스워드 매니저 참조
```

**원격 데스크톱 연결 (Windows)**
1. `Win + R` → `mstsc` 입력
2. 컴퓨터: `172.18.100.16` 입력 후 연결
3. 계정 `clobot` 으로 로그인

---

## 6. 신규 서버 키 배포 방법

신규 VM 생성 시 아래 절차로 PEM 키를 배포합니다.

### monitor-01에서 직접 배포 (권장)
```bash
# monitor-01 접속
ssh bastion

# inventory.ini에 신규 서버 추가 후
vi /data/infra-key-setup/inventory.ini

# 해당 서버만 배포
/opt/ansible_venv/bin/ansible-playbook \
  -i /data/infra-key-setup/inventory.ini \
  /data/infra-key-setup/deploy_ssh_key.yml \
  -e pub_key_file=/data/infra-key-setup/clobot_infra.pub \
  --limit <서버명>
```

### 로컬에서 전체 재배포
```powershell
# Windows PowerShell
cd C:\...\Keys\bastion
.\run_full_setup.ps1
```

---

## 7. 담당자 교체 시 처리 절차

### 신규 담당자 키 등록 (Step 1~3 이후)
```bash
# 신규 담당자 공개키 수령 후 monitor-01에 등록
ssh bastion
echo '<신규담당자_공개키_내용>' >> ~/.ssh/authorized_keys

# Ansible으로 전 서버 배포
/opt/ansible_venv/bin/ansible-playbook \
  -i /data/infra-key-setup/inventory.ini \
  /data/infra-key-setup/deploy_ssh_key.yml \
  -e pub_key_file=/tmp/successor.pub
```

### 전임자 키 삭제
```bash
ssh bastion
# authorized_keys에서 전임자 키 라인 삭제
vi ~/.ssh/authorized_keys
```

> Bastion(monitor-01) authorized_keys 1개만 삭제하면  
> 전임자는 **모든 내부 서버 접근이 즉시 차단**됩니다.

---

## 참고 파일 위치

| 파일 | 경로 | 설명 |
|------|------|------|
| PEM 개인키 | `인수인계/clobot_infra.pem` | 보안 채널로 전달 필수 |
| SSH config 템플릿 | `Keys/bastion/ssh_config_template` | ~/.ssh/config 적용용 |
| Ansible inventory | `Keys/bastion/ansible/inventory.ini` | 전체 서버 목록 |
| Ansible playbook | `Keys/bastion/ansible/deploy_ssh_key.yml` | 키 배포 플레이북 |
| 전체 자동화 스크립트 | `Keys/bastion/run_full_setup.ps1` | 신규 키 생성 및 배포 |
| 서버 관리대장 | `인수인계/Inf_관리대장.pdf` | 전체 IP/서버 목록 원본 |
