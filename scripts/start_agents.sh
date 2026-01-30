#!/bin/bash
# ============================================
# Multi-Agent Shogun - エージェント起動スクリプト
# ============================================

set -e

SESSION_NAME="multiagent"
BASE_DIR="$HOME/multi-agent-shogun"

echo "=== Multi-Agent Shogun エージェント起動 ==="

# tmuxセッションが存在するか確認
if ! tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "エラー: tmux セッション '$SESSION_NAME' が存在しません"
    echo "先に ./setup_tmux.sh を実行してください"
    exit 1
fi

# Claude Code がインストールされているか確認
if ! command -v claude &> /dev/null; then
    echo "エラー: Claude Code がインストールされていません"
    echo "インストール: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

echo ""
echo "各ペインでエージェントを起動します..."
echo ""

# 将軍を起動
echo "将軍を起動中..."
tmux send-keys -t $SESSION_NAME:shogun "claude --print 'instructions/shogun.md を読み込んでください。汝は将軍なり。人間からの指示を待て。'"
tmux send-keys -t $SESSION_NAME:shogun Enter

sleep 1

# 家老を起動
echo "家老を起動中..."
tmux send-keys -t $SESSION_NAME:karo "claude --print 'instructions/karo.md を読み込んでください。汝は家老なり。将軍からの指示を待て。'"
tmux send-keys -t $SESSION_NAME:karo Enter

sleep 1

# 足軽を起動（8名）
echo "足軽を起動中..."
for i in {0..7}; do
    ashigaru_num=$((i + 1))
    echo "  足軽${ashigaru_num}番を起動中..."
    tmux send-keys -t $SESSION_NAME:ashigaru.$i "claude --print 'instructions/ashigaru.md を読み込んでください。汝は足軽${ashigaru_num}番なり。家老からの指示を待て。自分専用のファイルは queue/tasks/ashigaru${ashigaru_num}.yaml である。'"
    tmux send-keys -t $SESSION_NAME:ashigaru.$i Enter
    sleep 0.5
done

echo ""
echo "=== エージェント起動完了 ==="
echo ""
echo "全10体のエージェントが起動しました:"
echo "  - 将軍: 1体"
echo "  - 家老: 1体"
echo "  - 足軽: 8体"
echo ""
echo "将軍ウィンドウに移動してタスクを与えてください:"
echo "  tmux select-window -t $SESSION_NAME:shogun"
echo ""
echo "または: tmux attach -t $SESSION_NAME"
echo ""
