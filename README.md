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
    ├── todo_list_view.dart    # トップビュー（一覧・完了タブ）
    ├── todo_add_view.dart     # 追加ビュー
    └── todo_edit_view.dart    # 編集ビュー
```

### 各ファイルの説明

#### `lib/main.dart`
アプリのエントリポイント。`TodoApp`（`StatefulWidget`）がアクティブTODOリスト（`_activeTodos`）と完了TODOリスト（`_completedTodos`）を分けて保持し、以下のコールバックを`TodoListView`に渡す。

| コールバック | 説明 |
|---|---|
| `onAdd` | 新規TODOを`_activeTodos`に追加 |
| `onUpdate` | 既存TODOを更新（アクティブ・完了どちらも対応） |
| `onComplete` | `_activeTodos`からTODOを取り出し`isCompleted: true`で`_completedTodos`に移動 |
| `onDelete` | 両リストから指定IDのTODOを削除 |
| `onReorder` | `_activeTodos`内の順番を入れ替え |

#### `lib/models/todo.dart`
TODOのデータモデル。以下の5フィールドを持つ。

| フィールド | 型 | 説明 |
|---|---|---|
| `id` | `String` | 一意識別子（作成日時のマイクロ秒） |
| `title` | `String` | タイトル（必須） |
| `createdAt` | `DateTime` | 作成日時 |
| `deadline` | `DateTime?` | 締切日（任意） |
| `content` | `String` | 詳細内容 |
| `isCompleted` | `bool` | 完了フラグ（デフォルト: false） |

`copyWith`メソッドで編集・完了時に不変オブジェクトとしてコピーを生成する。

#### `lib/views/todo_list_view.dart`
トップビュー（一覧画面）。`StatefulWidget`で`TabController`を保持する。

- **TODOタブ**: `ReorderableListView`でアクティブなTODOを表示。ドラッグ＆ドロップで順番を入れ替え可能。締切が過ぎているTODOは赤字強調。
- **完了タブ**: 完了済みTODOを打ち消し線付きで表示。
- `FloatingActionButton`（追加ボタン）はTODOタブ表示中のみ表示。
- 各TODOタップで編集ビューへ遷移。戻り値の`TodoEditResult.isCompleted`で完了操作か編集操作かを判断。

#### `lib/views/todo_add_view.dart`
追加ビュー。タイトル（必須）、締切日（カレンダーピッカー）、詳細内容のフォームを提供。「追加」ボタン押下時にバリデーションを実行し、新規`Todo`オブジェクトを`Navigator.pop`で返す。

#### `lib/views/todo_edit_view.dart`
編集ビュー。既存TODOの内容をフォームに初期表示し編集できる。

- AppBarの **`check_circle_outline`アイコン**を押すと完了状態（`isCompleted: true`）に変更し、トップビューの完了タブに移動する。すでに完了済みのTODOにはアイコンを表示しない。
- 「保存」ボタンで編集内容を更新。
- AppBarの **削除アイコン**から確認ダイアログ経由でTODOを削除。
- 戻り値は`TodoEditResult`クラスで統一（`todo`フィールドと`isCompleted`フラグを持つ）。

## 画面遷移

```
TodoListView（TODOタブ）
  ├── [FAB] ───────────────→ TodoAddView（追加）
  │                              └── [追加ボタン] → 戻り値(Todo)で一覧に追加
  └── [TODOタップ] ────────→ TodoEditView（編集）
                                 ├── [保存ボタン]         → 一覧を更新
                                 ├── [✓完了ボタン]        → 完了タブに移動
                                 └── [削除ボタン]         → 一覧から削除

TodoListView（完了タブ）
  └── [TODOタップ] ────────→ TodoEditView（編集・完了状態）
                                 ├── [保存ボタン]         → 完了一覧を更新
                                 └── [削除ボタン]         → 完了一覧から削除
```

## 開発・実行方法

```bash
flutter pub get
flutter run
```
