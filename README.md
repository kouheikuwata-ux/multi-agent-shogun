# Multi-Agent Shogun

> 戦国風マルチエージェントオーケストレーション基盤
> Windows + Cursor + Claude Code で動作

人間は指示と承認のみを行い、それ以外の設計・タスク分解・実行・改善・知識化はAIに任せるシステムです。

## 概要

```
人間（主君）
  │ 指示
  ▼
┌─────────┐
│  将軍   │ ← メインのClaude Codeセッション
└────┬────┘
     │ Task機能
     ▼
┌─────────┐
│  家老   │ ← サブエージェント（タスク分解）
└────┬────┘
     │ Task機能（並列）
     ▼
┌─────────────────────────┐
│ 足軽1 │ 足軽2 │ 足軽3  │ ← 並列実行
└─────────────────────────┘
```

## 環境要件（全て既存、新規インストール不要）

| 項目 | 状態 |
|------|------|
| Node.js | ✓ |
| Git | ✓ |
| Claude Code | ✓ |
| Cursor | ✓ |

## クイックスタート

### 1. 将軍モードで起動

Cursor内のClaude Codeで以下を入力：

```
あなたは将軍です。
~/multi-agent-shogun/instructions/shogun.md を読み、
以下のタスクを実行してください：

「3つのファイルを並列で作成せよ」
```

### 2. 結果を確認

- `test_output/` に成果物が作成される
- `status/dashboard.md` で進捗を確認

## ディレクトリ構成

```
~/multi-agent-shogun/
├── instructions/          # 役職別指示書
│   ├── shogun.md         # 将軍
│   ├── karo.md           # 家老
│   └── ashigaru.md       # 足軽
├── queue/                 # 通信キュー
│   ├── shogun_to_karo.yaml
│   ├── tasks/            # タスク定義
│   └── reports/          # 報告
├── status/
│   ├── dashboard.md      # 進捗ダッシュボード
│   └── master_status.yaml
├── skills/                # スキルパッケージ
├── config/
│   └── settings.yaml
├── test_output/           # 成果物
├── SPECIFICATION.md       # 詳細仕様書
└── README.md
```

## 通信フロー

```yaml
# 1. 将軍が家老に指示
queue/shogun_to_karo.yaml:
  mission_id: "20240130-120000"
  objective: "3つのファイルを並列作成"

# 2. 家老が足軽にタスク割当
queue/tasks/task_001.yaml:
  task_id: "TASK-001"
  objective: "hello1.md を作成"
  output_path: "test_output/hello1.md"

# 3. 足軽が報告
queue/reports/report_001.yaml:
  task_id: "TASK-001"
  status: "completed"
  deliverables: ["test_output/hello1.md"]
```

## 禁止事項

| 役職 | 禁止事項 |
|------|---------|
| 将軍 | 自分でタスク実行、足軽への直接指示 |
| 家老 | ファイル編集、人間への直接報告 |
| 足軽 | 他タスクへの干渉、将軍への直接報告 |

## ペルソナ

| ID | 日本語 | 専門 |
|----|--------|------|
| senior_engineer | 熟練の技師 | コーディング |
| technical_writer | 記録係 | ドキュメント |
| analyst | 軍師 | 調査・分析 |
| ui_designer | 意匠師 | デザイン |
| tester | 検分役 | テスト |
| devops | 陣地構築師 | デプロイ |

## 使用例

### 並列ファイル作成

```
人間: 「3つのファイルを並列で作成せよ」

将軍: 「主命を承った。家老を呼び出す。」
      → Task(家老)起動

家老: 「将軍より命を受けた。3名の足軽を編成する。」
      → Task(足軽1), Task(足軽2), Task(足軽3) 並列起動

足軽1: 「hello1.md を作成いたした。」
足軽2: 「hello2.md を作成いたした。」
足軽3: 「hello3.md を作成いたした。」

家老: 「全軍、任務完了。」

将軍: 「見事なり。成果物: hello1.md, hello2.md, hello3.md」
```

### ダッシュボード監視

Cursorで `status/dashboard.md` を開いてプレビュー表示。

## 新規プロジェクトへの適用

```bash
# プロジェクトディレクトリで初期化
~/multi-agent-shogun/scripts/setup_project.sh
```

## Git/Vercel連携

- 足軽が成果物をコミット
- GitHubプッシュでVercel自動デプロイ
- プレビューURLをdashboard.mdに記録

## コスト

- Claude Maxサブスクリプション内で動作
- 待機中のAPI消費なし（イベント駆動）
- 月額$100以内で運用可能
