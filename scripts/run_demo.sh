#!/bin/bash
# ============================================
# Multi-Agent Shogun - デモタスク実行スクリプト
# ============================================
#
# 「3つのファイルを並列で作成するテスト」を実行
# ============================================

set -e

SESSION_NAME="multiagent"
BASE_DIR="$HOME/multi-agent-shogun"

echo "=== Multi-Agent Shogun デモタスク ==="
echo ""
echo "テスト内容: 3つのファイル (hello1.md, hello2.md, hello3.md) を並列作成"
echo ""

# tmuxセッションが存在するか確認
if ! tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "エラー: tmux セッション '$SESSION_NAME' が存在しません"
    echo "先に ./setup_tmux.sh と ./start_agents.sh を実行してください"
    exit 1
fi

# test_output ディレクトリを初期化
echo "test_output ディレクトリを初期化中..."
rm -rf "$BASE_DIR/test_output"
mkdir -p "$BASE_DIR/test_output"

# 将軍にデモタスクを送信
echo ""
echo "将軍にデモタスクを送信します..."
echo ""

# 将軍ウィンドウにメッセージ送信
tmux send-keys -t $SESSION_NAME:shogun "テストして"
sleep 0.1
tmux send-keys -t $SESSION_NAME:shogun Enter

echo "デモタスクが開始されました。"
echo ""
echo "進捗確認方法:"
echo "  1. tmux attach -t $SESSION_NAME でセッションに接続"
echo "  2. status/dashboard.md を監視"
echo "  3. test_output/ の内容を確認"
echo ""
echo "期待される結果:"
echo "  - test_output/hello1.md (足軽1番が作成)"
echo "  - test_output/hello2.md (足軽2番が作成)"
echo "  - test_output/hello3.md (足軽3番が作成)"
echo ""
