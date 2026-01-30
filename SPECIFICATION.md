# Multi-Agent Shogun 仕様書

> 現在の開発環境（Windows + Cursor + Claude Code）で動作する設計

## 環境要件（全て既存）

| 項目 | バージョン | 状態 |
|------|-----------|------|
| Node.js | v22.18.0 | ✓ インストール済み |
| npm | 10.9.3 | ✓ インストール済み |
| Git | 2.49.0 | ✓ インストール済み |
| Claude Code | - | ✓ インストール済み |
| Cursor | - | ✓ 使用中 |

**新規インストール不要**

---

## アーキテクチャ

### 従来設計（tmux依存）→ 新設計（Claude Code Task機能）

```
【従来】tmux + 複数Claude Codeインスタンス
  └─ WSL2必須、tmux必須

【新設計】単一Claude Code + Task機能によるサブエージェント
  └─ 現在の環境でそのまま動作
```

### エージェント構成

```
人間（主君）
  │
  ▼ 指示
┌─────────────┐
│   将軍      │  ← メインのClaude Codeセッション（Cursor内）
│  (Shogun)   │     人間と直接対話、全体統括
└─────┬───────┘
      │ Task機能でサブエージェント起動
      ▼
┌─────────────┐
│   家老      │  ← Task(subagent_type="general-purpose")
│   (Karo)    │     タスク分解、足軽への割り振り
└─────┬───────┘
      │ Task機能で並列サブエージェント起動
      ▼
┌─────────────────────────────────────────┐
│  足軽1  │  足軽2  │  足軽3  │  ...     │  ← 並列Task
│ (Ashigaru)                              │     実際のタスク実行
└─────────────────────────────────────────┘
```

---

## 通信方式

### ファイルベース通信（維持）

```
queue/
├── shogun_to_karo.yaml      # 将軍→家老
├── tasks/
│   └── task_{id}.yaml       # 家老→足軽（タスク単位）
└── reports/
    └── report_{id}.yaml     # 足軽→家老
```

### Task機能による起動（新規）

```javascript
// 将軍が家老を起動
Task({
  subagent_type: "general-purpose",
  prompt: "instructions/karo.md を読み、queue/shogun_to_karo.yaml のタスクを実行せよ",
  description: "家老タスク実行"
})

// 家老が足軽を並列起動
Task({
  subagent_type: "general-purpose",
  prompt: "足軽として queue/tasks/task_001.yaml を実行せよ",
  run_in_background: true  // 並列実行
})
```

---

## ディレクトリ構成

```
~/multi-agent-shogun/
├── instructions/           # 役職別指示書
│   ├── shogun.md
│   ├── karo.md
│   └── ashigaru.md
├── queue/                  # 通信キュー
│   ├── shogun_to_karo.yaml
│   ├── tasks/
│   └── reports/
├── status/                 # 状態管理
│   ├── dashboard.md
│   └── master_status.yaml
├── skills/                 # スキルパッケージ
├── config/
│   └── settings.yaml
└── test_output/            # テスト成果物
```

---

## ワークフロー

### 1. 人間が将軍に指示

```
人間: 「3つのファイルを並列で作成せよ」
```

### 2. 将軍が計画策定・家老起動

```yaml
# queue/shogun_to_karo.yaml
mission_id: "20240130-120000"
objective: "3つのファイルを並列作成"
files: ["hello1.md", "hello2.md", "hello3.md"]
```

```
将軍 → Task(家老) を起動
```

### 3. 家老がタスク分解・足軽起動

```yaml
# queue/tasks/task_001.yaml
task_id: "TASK-001"
assignee: "ashigaru"
file: "hello1.md"
persona: "senior_engineer"
```

```
家老 → Task(足軽1), Task(足軽2), Task(足軽3) を並列起動
```

### 4. 足軽がタスク実行・報告

```yaml
# queue/reports/report_001.yaml
task_id: "TASK-001"
status: "completed"
deliverables: ["test_output/hello1.md"]
```

### 5. 家老が集約・将軍に報告

```
家老 → dashboard.md を更新
```

### 6. 将軍が人間に報告

```
将軍: 「全タスク完了。成果物: hello1.md, hello2.md, hello3.md」
```

---

## 禁止事項（維持）

### 将軍
- 自分でタスクを実行しない
- 足軽に直接指示しない

### 家老
- 自分でファイルを編集しない
- 将軍を通さず人間に報告しない

### 足軽
- 将軍に直接報告しない
- 他の足軽のタスクに干渉しない
- 担当外ファイルを編集しない

---

## 最小権限の原則（維持）

各足軽は自分専用のタスクファイルのみ参照：

| 足軽 | 読取可能 | 書込可能 |
|------|---------|---------|
| タスク1担当 | task_001.yaml | report_001.yaml, hello1.md |
| タスク2担当 | task_002.yaml | report_002.yaml, hello2.md |
| タスク3担当 | task_003.yaml | report_003.yaml, hello3.md |

---

## ペルソナ自動割当（維持）

| タスク内容 | ペルソナ |
|-----------|---------|
| コード作成 | senior_engineer（熟練の技師）|
| ドキュメント | technical_writer（記録係）|
| 調査・分析 | analyst（軍師）|
| UI/デザイン | ui_designer（意匠師）|
| テスト | tester（検分役）|
| デプロイ | devops（陣地構築師）|

---

## Git/GitHub/Vercel連携（維持）

### 自動コミット

```bash
git add <成果物>
git commit -m "feat(task-001): hello1.md を作成

- 担当: 足軽 (熟練の技師)
- 影響範囲: test_output/hello1.md"
git push
```

### Vercel自動デプロイ

- GitHubプッシュで自動プレビュー
- URLをdashboard.mdに記録

---

## スキル自動生成（維持）

1. 将軍がパターン検知（3回以上の繰り返し）
2. 既存スキルとの比較
3. 人間に提案（承認必須）
4. skills/{skill_name}/ に保存

---

## コスト管理

- Task機能はClaude Maxサブスクリプション内で動作
- 並列実行もAPI呼び出しとしてカウント
- 待機中の消費なし（イベント駆動）

---

## 使用方法

### Cursor内で将軍として起動

1. Cursorでプロジェクトを開く
2. Claude Codeを起動（サイドバーまたはターミナル）
3. 将軍として指示を与える：

```
あなたは将軍です。instructions/shogun.md を読み、
以下のタスクを実行してください：
「3つのファイルを並列で作成せよ」
```

### ダッシュボード監視

Cursorで `status/dashboard.md` を開いてプレビュー表示。

---

## 変更点まとめ

| 項目 | 従来 | 新設計 |
|------|------|--------|
| マルチエージェント | tmux + 複数CLI | Task機能 |
| 環境 | WSL2必須 | Windows直接 |
| 新規インストール | tmux, WSL2 | なし |
| 通信 | send-keys | Task戻り値 + YAML |
| 並列実行 | tmuxペイン | run_in_background |
