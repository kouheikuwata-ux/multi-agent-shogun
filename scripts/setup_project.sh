#!/bin/bash
# ============================================
# Multi-Agent Shogun - プロジェクト初期化スクリプト
# ============================================
#
# 使用方法:
#   ~/multi-agent-shogun/scripts/setup_project.sh [project_name]
#
# Cursorのターミナルから実行可能
# ============================================

set -e

SHOGUN_BASE="$HOME/multi-agent-shogun"
PROJECT_DIR="${1:-.}"

# 絶対パスに変換
if [[ "$PROJECT_DIR" != /* ]]; then
    PROJECT_DIR="$(pwd)/$PROJECT_DIR"
fi

echo "=== Multi-Agent Shogun プロジェクト初期化 ==="
echo "プロジェクトディレクトリ: $PROJECT_DIR"
echo ""

# プロジェクトディレクトリに移動
cd "$PROJECT_DIR"

# 必要なディレクトリ作成
echo "ディレクトリ構造を作成中..."
mkdir -p queue/tasks
mkdir -p queue/reports
mkdir -p status
mkdir -p skills
mkdir -p test_output

# シンボリックリンク作成（共通資産への参照）
echo "共通資産へのリンクを作成中..."

# instructions へのリンク
if [ ! -L "instructions" ] && [ ! -d "instructions" ]; then
    ln -s "$SHOGUN_BASE/instructions" instructions
    echo "  instructions -> $SHOGUN_BASE/instructions"
fi

# config へのリンク
if [ ! -L "config" ] && [ ! -d "config" ]; then
    ln -s "$SHOGUN_BASE/config" config
    echo "  config -> $SHOGUN_BASE/config"
fi

# scripts へのリンク
if [ ! -L "scripts" ] && [ ! -d "scripts" ]; then
    ln -s "$SHOGUN_BASE/scripts" scripts
    echo "  scripts -> $SHOGUN_BASE/scripts"
fi

# templates へのリンク
if [ ! -L "templates" ] && [ ! -d "templates" ]; then
    ln -s "$SHOGUN_BASE/templates" templates
    echo "  templates -> $SHOGUN_BASE/templates"
fi

# キューファイルの初期化
echo "キューファイルを初期化中..."
cp "$SHOGUN_BASE/queue/shogun_to_karo.yaml" queue/shogun_to_karo.yaml 2>/dev/null || true

for i in {1..8}; do
    cp "$SHOGUN_BASE/queue/tasks/ashigaru${i}.yaml" queue/tasks/ashigaru${i}.yaml 2>/dev/null || true
    cp "$SHOGUN_BASE/queue/reports/ashigaru${i}_report.yaml" queue/reports/ashigaru${i}_report.yaml 2>/dev/null || true
done

# ステータスファイルの初期化
echo "ステータスファイルを初期化中..."
cp "$SHOGUN_BASE/status/dashboard.md" status/dashboard.md 2>/dev/null || true
cp "$SHOGUN_BASE/status/master_status.yaml" status/master_status.yaml 2>/dev/null || true

# プロジェクト設定ファイル作成
echo "プロジェクト設定ファイルを作成中..."
PROJECT_NAME=$(basename "$PROJECT_DIR")
cat > multi_agent_config.yaml << EOF
# Multi-Agent Shogun - プロジェクト設定
# ================================

project:
  name: "$PROJECT_NAME"
  created_at: "$(date -Iseconds)"
  shogun_base: "$SHOGUN_BASE"

# GitHub設定（必要に応じて編集）
github:
  repository: ""
  default_branch: "main"
  auto_push: true

# Vercel設定（必要に応じて編集）
vercel:
  project_name: ""
  auto_deploy: true

# 言語設定
language: "ja"

# カスタム設定
custom:
  # プロジェクト固有の設定をここに追加
EOF

# .gitignore の更新
echo ".gitignore を更新中..."
if [ -f ".gitignore" ]; then
    # 既存の.gitignoreに追記
    grep -q "# Multi-Agent Shogun" .gitignore || cat >> .gitignore << 'EOF'

# Multi-Agent Shogun
test_output/
queue/tasks/*.yaml
queue/reports/*.yaml
!queue/tasks/.gitkeep
!queue/reports/.gitkeep
*.tmp
EOF
else
    # 新規作成
    cat > .gitignore << 'EOF'
# Multi-Agent Shogun
test_output/
queue/tasks/*.yaml
queue/reports/*.yaml
!queue/tasks/.gitkeep
!queue/reports/.gitkeep
*.tmp

# Node.js
node_modules/
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
EOF
fi

# .gitkeep ファイル作成（空ディレクトリをgit管理するため）
touch queue/tasks/.gitkeep
touch queue/reports/.gitkeep
touch status/.gitkeep
touch skills/.gitkeep
touch test_output/.gitkeep

echo ""
echo "=== プロジェクト初期化完了 ==="
echo ""
echo "ディレクトリ構成:"
echo "  queue/           - エージェント間通信"
echo "  queue/tasks/     - 足軽へのタスク"
echo "  queue/reports/   - 足軽からの報告"
echo "  status/          - ダッシュボード・ステータス"
echo "  skills/          - スキルパッケージ"
echo "  instructions/    -> $SHOGUN_BASE/instructions"
echo "  config/          -> $SHOGUN_BASE/config"
echo "  scripts/         -> $SHOGUN_BASE/scripts"
echo ""
echo "次のステップ:"
echo "  1. multi_agent_config.yaml を編集してGitHub/Vercel設定を追加"
echo "  2. git init && git remote add origin <your-repo>"
echo "  3. ./scripts/setup_tmux.sh でtmuxセッション作成"
echo "  4. ./scripts/start_agents.sh でエージェント起動"
echo ""
