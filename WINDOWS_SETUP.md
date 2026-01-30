# Windows環境でのセットアップガイド

## 前提条件

### 1. WSL2 のインストール

```powershell
# 管理者権限のPowerShellで実行
wsl --install
```

再起動後、Ubuntuを設定します。

### 2. Claude Code のインストール

WSL2内で:
```bash
# Node.js のインストール（未インストールの場合）
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Claude Code のインストール
npm install -g @anthropic-ai/claude-code
```

### 3. tmux のインストール

WSL2内で:
```bash
sudo apt update
sudo apt install tmux
```

## セットアップ手順

### 方法1: Cursor のターミナルから

1. Cursor を起動
2. ターミナルを開く (Ctrl+`)
3. WSL2 に接続:
   ```
   wsl
   ```
4. セットアップスクリプト実行:
   ```bash
   cd ~/multi-agent-shogun
   chmod +x scripts/*.sh
   ./scripts/setup_tmux.sh
   ./scripts/start_agents.sh
   ```

### 方法2: PowerShell から

```powershell
cd C:\Users\kouhe\multi-agent-shogun\scripts
.\setup_tmux.ps1
```

## tmux への接続

### Cursor のターミナルから

```bash
wsl -e tmux attach -t multiagent
```

### Windows Terminal から

```
wsl
tmux attach -t multiagent
```

## 日常的な操作

### セッションにアタッチ
```bash
wsl -e tmux attach -t multiagent
```

### セッションからデタッチ
```
Ctrl+b d
```

### ウィンドウ切り替え
```
Ctrl+b 0  # 将軍
Ctrl+b 1  # 家老
Ctrl+b 2  # 足軽
```

### セッション終了
```bash
wsl -e tmux kill-session -t multiagent
```

## Cursor との連携

### ダッシュボード監視

1. Cursor で `status/dashboard.md` を開く
2. プレビュー表示 (Ctrl+Shift+V)
3. リアルタイムで進捗を確認

### ファイル変更の監視

1. Cursor の Explorer で `test_output/` を監視
2. エージェントが作成したファイルを確認

## トラブルシューティング

### WSL2 が起動しない

```powershell
# 再起動
wsl --shutdown
wsl
```

### tmux セッションが見つからない

```bash
# WSL2内で確認
tmux ls

# セッションがなければ再作成
./scripts/setup_tmux.sh
```

### Claude Code が見つからない

```bash
# WSL2内でパス確認
which claude

# インストールされていなければ
npm install -g @anthropic-ai/claude-code
```
