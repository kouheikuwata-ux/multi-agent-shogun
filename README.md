# Multi-Agent Shogun

> 戦国風マルチエージェントオーケストレーション基盤

人間は指示と承認のみを行い、それ以外の設計・タスク分解・実行・改善・知識化はAIに任せるシステムです。

## 概要

- **将軍** (1体): 人間からの指示を受け取り、全体戦略を司る
- **家老** (1体): タスクを分解し、足軽に割り振る
- **足軽** (8体): 実際のタスクを並列で実行する

## クイックスタート

### 1. 前提条件

```bash
# Claude Code のインストール
npm install -g @anthropic-ai/claude-code

# tmux のインストール（未インストールの場合）
# Ubuntu/Debian:
sudo apt install tmux
# macOS:
brew install tmux
```

### 2. tmux セッション構築

```bash
cd ~/multi-agent-shogun
chmod +x scripts/*.sh
./scripts/setup_tmux.sh
```

### 3. エージェント起動

```bash
./scripts/start_agents.sh
```

### 4. セッションに接続

```bash
tmux attach -t multiagent
```

### 5. タスクを与える

将軍ウィンドウ (Ctrl+b 0) で:
```
テストして
```

## ディレクトリ構成

```
multi-agent-shogun/
├── config/
│   └── settings.yaml          # 全体設定
├── instructions/
│   ├── shogun.md              # 将軍の指示書
│   ├── karo.md                # 家老の指示書
│   └── ashigaru.md            # 足軽の指示書
├── queue/
│   ├── shogun_to_karo.yaml    # 将軍→家老の指示
│   ├── tasks/
│   │   └── ashigaru{N}.yaml   # 家老→足軽Nへの指示
│   └── reports/
│       └── ashigaru{N}_report.yaml  # 足軽N→家老への報告
├── status/
│   ├── dashboard.md           # 進捗ダッシュボード
│   └── master_status.yaml     # 全体ステータス
├── skills/
│   └── {skill_name}/          # スキルパッケージ
├── scripts/
│   ├── setup_tmux.sh          # tmuxセッション構築
│   ├── start_agents.sh        # エージェント起動
│   ├── setup_project.sh       # プロジェクト初期化
│   ├── send_message.sh        # メッセージ送信ヘルパー
│   ├── run_demo.sh            # デモタスク実行
│   └── check_status.sh        # ステータス確認
├── templates/
│   └── skill_template/        # スキルテンプレート
└── test_output/               # テスト成果物
```

## tmux 操作

| キー | 動作 |
|------|------|
| Ctrl+b 0 | 将軍ウィンドウ |
| Ctrl+b 1 | 家老ウィンドウ |
| Ctrl+b 2 | 足軽ウィンドウ |
| Ctrl+b 矢印 | ペイン切り替え (足軽内) |
| Ctrl+b d | デタッチ |

## 通信規定

### イベント駆動

- **ポーリング禁止**: 待機中のAPI消費ゼロ
- **send-keys駆動**: tmux send-keys で起こされてから実行

### send-keys 2分割ルール

```bash
# 正しい例
tmux send-keys -t multiagent:karo "メッセージ"
tmux send-keys -t multiagent:karo Enter

# 誤った例（禁止）
tmux send-keys -t multiagent:karo "メッセージ" Enter
```

### 通信禁止事項

- 足軽→将軍への直接送信
- 家老→将軍への直接send-keys
- 人間への直接話しかけ

## 最小権限の原則

各足軽は自分専用のファイルのみ操作可能:

| 足軽 | 読み取り可能 | 書き込み可能 |
|------|-------------|-------------|
| 足軽1 | ashigaru1.yaml | ashigaru1_report.yaml, 担当ファイル |
| 足軽2 | ashigaru2.yaml | ashigaru2_report.yaml, 担当ファイル |
| ... | ... | ... |

## ペルソナ

| ID | 日本語名 | 英語名 | 専門 |
|----|---------|--------|------|
| senior_engineer | 熟練の技師 | Senior Software Engineer | コーディング |
| technical_writer | 記録係 | Technical Writer | ドキュメント |
| analyst | 軍師 | Analyst | 調査・分析 |
| ui_designer | 意匠師 | UI Designer | デザイン |
| tester | 検分役 | QA Tester | テスト |
| devops | 陣地構築師 | DevOps Engineer | デプロイ |

## 新規プロジェクトへの適用

```bash
# 新しいプロジェクトディレクトリに移動
cd /path/to/your/project

# 初期化スクリプト実行
~/multi-agent-shogun/scripts/setup_project.sh

# multi_agent_config.yaml を編集
# Git/Vercel設定を追加

# tmuxセッション構築 & エージェント起動
./scripts/setup_tmux.sh
./scripts/start_agents.sh
```

## Git/GitHub/Vercel 連携

### 自動コミット

足軽は成果物作成後、自動でコミット:

```
feat(ashigaru1): hello1.md を作成

- 影響範囲: test_output/hello1.md
- レビュー観点: ファイル内容の確認
- 担当: 足軽1番 (熟練の技師)
```

### Vercel 自動デプロイ

- GitHub へのプッシュで自動プレビュー
- デプロイURLは dashboard.md に記録
- 人間はプレビューを確認して承認

## コスト管理

- **目標**: 月額 $100 以内
- **方式**: イベント駆動（待機中のAPI消費ゼロ）
- **最適化**: 必要最小限の足軽動員

## デモタスク

```bash
# 3つのファイルを並列作成するテスト
./scripts/run_demo.sh
```

期待される結果:
- `test_output/hello1.md` (足軽1番)
- `test_output/hello2.md` (足軽2番)
- `test_output/hello3.md` (足軽3番)

## トラブルシューティング

### セッションが存在しない

```bash
./scripts/setup_tmux.sh
```

### エージェントが応答しない

```bash
# セッション再構築
tmux kill-session -t multiagent
./scripts/setup_tmux.sh
./scripts/start_agents.sh
```

### ステータス確認

```bash
./scripts/check_status.sh
```

## ライセンス

Private - 個人使用のみ
