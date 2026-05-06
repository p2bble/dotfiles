#!/bin/bash
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
info() { echo "[dotfiles] $*"; }
mkdir -p ~/.ssh
if [ ! -f ~/.ssh/config ]; then
    ln -sf "${DOTFILES_DIR}/ssh/config" ~/.ssh/config && info "SSH config 링크 생성"
else
    info "SSH config 이미 존재 — 수동 병합: ${DOTFILES_DIR}/ssh/config"
fi
if [ ! -f ~/.gitconfig ]; then
    ln -sf "${DOTFILES_DIR}/git/.gitconfig" ~/.gitconfig && info ".gitconfig 링크 생성"
else
    info ".gitconfig 이미 존재 — 수동 병합 필요"
fi
LINE="source ${DOTFILES_DIR}/shell/aliases.sh"
if ! grep -qF "${LINE}" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc && echo "# dotfiles aliases" >> ~/.bashrc && echo "${LINE}" >> ~/.bashrc
    info "aliases.sh ~/.bashrc 추가"
else
    info "aliases.sh 이미 등록됨"
fi
info "완료. 'source ~/.bashrc' 실행"
