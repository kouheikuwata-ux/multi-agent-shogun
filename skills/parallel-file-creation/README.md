# parallel-file-creation スキル

> 複数のファイルを足軽に分担させて並列作成する

## 概要

このスキルは、複数のファイルを並列で作成する際に使用します。
将軍→家老→足軽の階層構造を活用し、各足軽に1ファイルずつ
担当させることで、効率的かつ安全にファイル作成を行います。

## 使用方法

### 基本的な使い方

```
parallel-file-creationスキルを使って、
以下のファイルを作成してください：
- file1.md
- file2.md
- file3.md
```

### 内容を指定する場合

```
parallel-file-creationスキルを使って、以下を作成：
- README.md: プロジェクトの説明
- CONTRIBUTING.md: 貢献ガイド
- LICENSE.md: ライセンス情報
```

### 出力先を指定する場合

```
parallel-file-creationスキルを使って、
docs/ ディレクトリに以下を作成：
- guide.md
- api.md
- faq.md
```

## 入力パラメータ

| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| files | array | Yes | 作成するファイルのリスト |
| files[].name | string | Yes | ファイル名 |
| files[].content | string | No | ファイル内容 |
| output_dir | string | No | 出力ディレクトリ（デフォルト: test_output） |
| persona | string | No | ペルソナ（デフォルト: technical_writer） |

## 出力

| フィールド | 型 | 説明 |
|-----------|-----|------|
| success | boolean | 全ファイル作成成功か |
| created_files | array | 作成されたファイルパス |
| failed_files | array | 失敗したファイル |
| reports | array | 報告ファイルパス |

## 実行フロー

```
1. 将軍がミッション作成
   └─ queue/shogun_to_karo.yaml

2. 家老がタスク分解
   ├─ queue/tasks/task_001.yaml (→ 足軽1)
   ├─ queue/tasks/task_002.yaml (→ 足軽2)
   └─ queue/tasks/task_003.yaml (→ 足軽3)

3. 足軽が並列実行
   ├─ file1.md 作成 + report_001.yaml
   ├─ file2.md 作成 + report_002.yaml
   └─ file3.md 作成 + report_003.yaml

4. 家老が集約・ダッシュボード更新

5. 将軍が結果報告
```

## 制約事項

- 各足軽は自分の担当ファイルのみ作成
- ファイル間に依存関係がある場合は使用不可
- 単一ファイルの場合は直接作成を推奨

## 推奨ペルソナ

- **technical_writer（記録係）**: ドキュメント作成
- **senior_engineer（熟練の技師）**: コード生成

## 変更履歴

- 1.0.0 (2026-01-30): 初版作成
