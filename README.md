# BankPocket 🏦

個人の銀行口座を簡単に管理できるFlutterアプリです。複数の口座情報を一箇所で管理し、CSV形式でのデータインポート・エクスポートも可能です。

## 主な機能 ✨

### 口座管理
- 銀行口座の登録・編集・削除
- 口座情報の詳細管理（銀行名、支店名、口座番号など）
- 給与振込口座やクレジットカード連携の設定
- 自動引き落とし設定の管理
- 連携アプリやメモの記録

### データ管理
- **CSVインポート**: 既存の口座データを一括インポート
- **CSVエクスポート**: データのバックアップや他システムとの連携
- **ローカル保存**: データはデバイス内に安全に保存

### カスタマイズ
- **カスタムフィールド**: 独自の項目を追加可能
- **スワイプ削除**: 直感的な操作で口座を削除

## スクリーンショット 📱

*（開発中：スクリーンショットを追加予定）*

## インストール・使用方法 🚀

### 必要環境
- Flutter 3.7.2以上
- Dart SDK

### セットアップ
```bash
# リポジトリをクローン
git clone https://github.com/JunNakarai/BankPocket.git
cd BankPocket

# 依存関係をインストール
flutter pub get

# アプリを実行
flutter run
```

### 使い方
1. **口座追加**: 画面右下の「+」ボタンから新しい口座を登録
2. **口座編集**: リストの項目をタップして情報を編集
3. **口座削除**: 項目を左にスワイプして削除
4. **CSV操作**: 画面上部のアイコンからインポート・エクスポート
5. **カスタムフィールド**: 設定画面から独自の項目を追加

## 技術スタック 🛠️

- **Framework**: Flutter 3.7.2+
- **Language**: Dart
- **State Management**: StatefulWidget
- **Data Storage**: SharedPreferences
- **File Operations**: 
  - `file_picker` - CSVファイル選択
  - `csv` - CSV形式の読み書き
  - `share_plus` - ファイル共有
  - `path_provider` - ファイルパス取得

## プロジェクト構成 📁

```
lib/
├── main.dart                           # アプリのエントリーポイント
├── models/
│   └── bank_account.dart              # 口座データモデル
└── screens/
    ├── account_list_screen.dart       # 口座一覧画面
    ├── account_from_screen.dart       # 口座登録・編集画面
    └── custom_field_settings_screen.dart # カスタムフィールド設定画面
```

## 今後の予定 🗺️

- [ ] アプリアイコンの作成
- [ ] 多言語対応
- [ ] ダークモード対応
- [ ] データ暗号化機能
- [ ] クラウド同期機能

## ライセンス 📄

このプロジェクトはMITライセンスの下で公開されています。

## 開発者 👨‍💻

**JunNakarai**
- GitHub: [@JunNakarai](https://github.com/JunNakarai)

## 貢献 🤝

プルリクエストやイシューの報告を歓迎します！

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成