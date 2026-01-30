#!/bin/bash
# ============================================
# Multi-Agent Shogun - ステータス確認スクリプト
# ============================================

BASE_DIR="$HOME/multi-agent-shogun"
SESSION_NAME="multiagent"

echo "=== Multi-Agent Shogun ステータス ==="
echo ""

# tmuxセッション確認
echo "【tmux セッション】"
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "  状態: 稼働中"
    echo "  ウィンドウ:"
    tmux list-windows -t $SESSION_NAME 2>/dev/null | sed 's/^/    /'
else
    echo "  状態: 停止中"
fi
echo ""

# ダッシュボード確認
echo "【ダッシュボード】"
if [ -f "$BASE_DIR/status/dashboard.md" ]; then
    echo "  ファイル: $BASE_DIR/status/dashboard.md"
    echo "  最終更新: $(stat -c %y "$BASE_DIR/status/dashboard.md" 2>/dev/null || stat -f %Sm "$BASE_DIR/status/dashboard.md" 2>/dev/null || echo "不明")"
else
    echo "  ファイルなし"
fi
echo ""

# キューファイル確認
echo "【キューファイル】"
echo "  将軍→家老:"
if [ -f "$BASE_DIR/queue/shogun_to_karo.yaml" ]; then
    mission=$(grep "current_mission:" "$BASE_DIR/queue/shogun_to_karo.yaml" | head -1)
    echo "    $mission"
else
    echo "    ファイルなし"
fi

echo "  足軽タスク:"
for i in {1..8}; do
    if [ -f "$BASE_DIR/queue/tasks/ashigaru${i}.yaml" ]; then
        task=$(grep "current_task:" "$BASE_DIR/queue/tasks/ashigaru${i}.yaml" | head -1)
        echo "    足軽${i}: $task"
    fi
done
echo ""

# 成果物確認
echo "【成果物 (test_output/)】"
if [ -d "$BASE_DIR/test_output" ]; then
    files=$(ls -1 "$BASE_DIR/test_output" 2>/dev/null | head -10)
    if [ -n "$files" ]; then
        echo "$files" | sed 's/^/    /'
    else
        echo "    (空)"
    fi
else
    echo "    ディレクトリなし"
fi
echo ""

# スキル確認
echo "【登録済みスキル (skills/)】"
if [ -d "$BASE_DIR/skills" ]; then
    skills=$(ls -1 "$BASE_DIR/skills" 2>/dev/null)
    if [ -n "$skills" ]; then
        echo "$skills" | sed 's/^/    /'
    else
        echo "    (なし)"
    fi
else
    echo "    ディレクトリなし"
fi
echo ""

echo "=== 確認完了 ==="
