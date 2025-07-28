# Changelog

このファイルには、BankPocketプロジェクトの重要な変更点がすべて記録されています。

フォーマットは[Keep a Changelog](https://keepachangelog.com/ja/1.0.0/)に基づいており、
このプロジェクトは[Semantic Versioning](https://semver.org/spec/v2.0.0.html)を採用しています。

## [未リリース]

## [1.0.1] - 2025-07-28

### 追加
- GitHub ActionsによるClaude AI開発支援システムの統合
  - issue、PR、コメントに対する自動応答機能
  - 日本語での開発サポート
  - Claude Code GitHub Workflowの追加

## [1.0.0] - 2025-06-24

### 追加
- アプリの基本構造と機能
  - 銀行口座情報の管理（追加、編集、削除）
  - 口座一覧表示画面
  - 口座情報編集画面
  - カスタムフィールド設定画面
- データモデル
  - BankAccountクラスの実装
  - JSON形式のシリアライズ/デシリアライズ
  - CSVインポート/エクスポート機能
- 設定
  - プロジェクトの初期設定（Flutter 3.7.2+）
  - 各種プラットフォーム（Android、iOS、Web、デスクトップ）の基本設定
- UI要素
  - スワイプで削除機能
  - カスタムフィールドのサポート
- データ保存
  - SharedPreferencesを使用したローカルストレージ

### 変更
- README.mdの更新：機能説明、使用方法、技術スタックの詳細を追加

## [0.1.0] - 2025-05-09

### 追加
- プロジェクト初期化
- 基本的なアプリ構造の設定