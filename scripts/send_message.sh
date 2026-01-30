#!/bin/bash
# ============================================
# Multi-Agent Shogun - メッセージ送信ヘルパー
# ============================================
#
# send-keys の2分割ルールを強制するヘルパースクリプト
#
# 使用方法:
#   ./send_message.sh <target_pane> "<message>"
#
# 例:
#   ./send_message.sh multiagent:karo "新たな主命あり"
#   ./send_message.sh multiagent:ashigaru.0 "任務を確認せよ"
# ============================================

set -e

if [ $# -lt 2 ]; then
    echo "使用方法: $0 <target_pane> \"<message>\""
    echo ""
    echo "例:"
    echo "  $0 multiagent:karo \"新たな主命あり\""
    echo "  $0 multiagent:ashigaru.0 \"任務を確認せよ\""
    exit 1
fi

TARGET="$1"
MESSAGE="$2"

# send-keys を2回に分けて送信（規定通り）
tmux send-keys -t "$TARGET" "$MESSAGE"
sleep 0.1
tmux send-keys -t "$TARGET" Enter

echo "メッセージ送信完了: $TARGET <- \"$MESSAGE\""
