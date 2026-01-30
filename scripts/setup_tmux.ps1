# ============================================
# Multi-Agent Shogun - tmux セッション構築スクリプト (PowerShell)
# ============================================
# 注意: このスクリプトはWSL2内のtmuxを操作します
# WSL2がインストールされている必要があります

$SESSION_NAME = "multiagent"
$BASE_DIR = "~/multi-agent-shogun"

Write-Host "=== Multi-Agent Shogun セットアップ開始 ===" -ForegroundColor Cyan
Write-Host ""

# WSL2が利用可能か確認
try {
    wsl --status | Out-Null
} catch {
    Write-Host "エラー: WSL2がインストールされていないか、起動していません" -ForegroundColor Red
    Write-Host "WSL2をインストールしてください: wsl --install" -ForegroundColor Yellow
    exit 1
}

Write-Host "WSL2経由でtmuxセッションを構築します..."
Write-Host ""

# WSL2内でbashスクリプトを実行
$script = @"
cd ~/multi-agent-shogun
chmod +x scripts/*.sh
./scripts/setup_tmux.sh
"@

wsl bash -c $script

Write-Host ""
Write-Host "=== セットアップ完了 ===" -ForegroundColor Green
Write-Host ""
Write-Host "WSL2に接続してセッションにアタッチ:" -ForegroundColor Yellow
Write-Host "  wsl -e tmux attach -t multiagent"
Write-Host ""
