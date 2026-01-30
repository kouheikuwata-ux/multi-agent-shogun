#!/bin/bash
# ============================================
# Multi-Agent Shogun - tmux セッション構築スクリプト
# ============================================

set -e

SESSION_NAME="multiagent"
BASE_DIR="$HOME/multi-agent-shogun"

echo "=== Multi-Agent Shogun セットアップ開始 ==="

# tmuxがインストールされているか確認
if ! command -v tmux &> /dev/null; then
    echo "エラー: tmux がインストールされていません"
    echo "インストール: sudo apt install tmux (Ubuntu/Debian)"
    exit 1
fi

# 既存のセッションがあれば終了
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "既存の $SESSION_NAME セッションを終了します..."
    tmux kill-session -t $SESSION_NAME
fi

echo "新しい tmux セッション '$SESSION_NAME' を作成します..."

# セッション作成（最初のウィンドウは shogun）
tmux new-session -d -s $SESSION_NAME -n shogun

# karo ウィンドウ作成
tmux new-window -t $SESSION_NAME -n karo

# ashigaru ウィンドウ作成（8ペインに分割）
tmux new-window -t $SESSION_NAME -n ashigaru

# ashigaru ウィンドウを8ペインに分割
# まず4分割（2x2）
tmux select-window -t $SESSION_NAME:ashigaru
tmux split-window -h -t $SESSION_NAME:ashigaru
tmux split-window -v -t $SESSION_NAME:ashigaru.0
tmux split-window -v -t $SESSION_NAME:ashigaru.2

# さらに8分割
tmux split-window -h -t $SESSION_NAME:ashigaru.0
tmux split-window -h -t $SESSION_NAME:ashigaru.2
tmux split-window -h -t $SESSION_NAME:ashigaru.4
tmux split-window -h -t $SESSION_NAME:ashigaru.6

# レイアウトを均等に
tmux select-layout -t $SESSION_NAME:ashigaru tiled

echo "tmux セッション構成:"
echo "  0:shogun  - 将軍ウィンドウ"
echo "  1:karo    - 家老ウィンドウ"
echo "  2:ashigaru - 足軽ウィンドウ (8ペイン)"

# 各ウィンドウに移動して作業ディレクトリを設定
tmux send-keys -t $SESSION_NAME:shogun "cd $BASE_DIR && clear" Enter
tmux send-keys -t $SESSION_NAME:karo "cd $BASE_DIR && clear" Enter

for i in {0..7}; do
    tmux send-keys -t $SESSION_NAME:ashigaru.$i "cd $BASE_DIR && clear" Enter
done

echo ""
echo "=== セットアップ完了 ==="
echo ""
echo "接続コマンド: tmux attach -t $SESSION_NAME"
echo ""
echo "ウィンドウ切り替え:"
echo "  Ctrl+b 0  - 将軍"
echo "  Ctrl+b 1  - 家老"
echo "  Ctrl+b 2  - 足軽"
echo ""
echo "ペイン切り替え (足軽ウィンドウ内):"
echo "  Ctrl+b 矢印キー"
echo ""
