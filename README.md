# CopilotTodoApp

Copilotで作ったFlutterのTODOアプリ

## ファイル設計

### ディレクトリ構成

```
lib/
├── main.dart                  # エントリポイント・状態管理ルート
├── models/
│   └── todo.dart              # TODOデータモデル
└── views/
    ├── todo_list_view.dart    # トップビュー（一覧画面）
    ├── todo_add_view.dart     # 追加ビュー
    └── todo_edit_view.dart    # 編集ビュー
```

### 各ファイルの説明

#### `lib/main.dart`
アプリのエントリポイント。`TodoApp`（`StatefulWidget`）がTODOリストの状態（`List<Todo>`）を保持し、追加・更新・削除のコールバックを`TodoListView`に渡す。状態管理は`setState`で行うシンプルな構成。

#### `lib/models/todo.dart`
TODOのデータモデル。以下の4フィールドを持つ。

| フィールド | 型 | 説明 |
|---|---|---|
| `id` | `String` | 一意識別子（作成日時のマイクロ秒） |
| `title` | `String` | タイトル（必須） |
| `createdAt` | `DateTime` | 作成日時 |
| `deadline` | `DateTime?` | 締切日（任意） |
| `content` | `String` | 詳細内容 |

`copyWith`メソッドで編集時に不変オブジェクトとしてコピーを生成する。

#### `lib/views/todo_list_view.dart`
トップビュー（一覧画面）。  
- TODOを`ListView`で表示  
- 締切が過ぎているTODOは赤字で強調  
- 右下の`FloatingActionButton`で追加ビューへ遷移  
- 各TODOタイルをタップすると編集ビューへ遷移  
- ナビゲーションの戻り値でTODOの追加・更新を受け取る

#### `lib/views/todo_add_view.dart`
追加ビュー。タイトル（必須）、締切日（カレンダーピッカー）、詳細内容のフォームを提供。「追加」ボタン押下時にバリデーションを実行し、新規`Todo`オブジェクトを`Navigator.pop`で返す。

#### `lib/views/todo_edit_view.dart`
編集ビュー。既存TODOの内容をフォームに初期表示し、編集後「保存」ボタンで`copyWith`を使い更新済み`Todo`を返す。AppBarの削除アイコンから確認ダイアログ経由でTODOを削除できる。

## 画面遷移

```
TodoListView（トップ）
  ├── [FAB] ──────────→ TodoAddView（追加）
  │                         └── [追加ボタン] → 戻り値(Todo)で一覧に追加
  └── [TODOタップ] ──→ TodoEditView（編集）
                            ├── [保存ボタン] → 戻り値(Todo)で一覧を更新
                            └── [削除ボタン] → コールバックで一覧から削除
```

## 開発・実行方法

```bash
flutter pub get
flutter run
```
