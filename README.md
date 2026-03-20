# CopilotTodoApp

Copilotで作ったFlutterのTODOアプリ

## ファイル設計

### ディレクトリ構成

```
lib/
├── main.dart                      # エントリポイント・状態管理ルート
├── models/
│   └── todo.dart                  # TODOデータモデル
├── services/
│   └── todo_storage.dart          # 永続化サービス（SharedPreferences）
└── views/
    ├── todo_list_view.dart        # トップビュー（一覧・完了タブ）
    ├── todo_add_view.dart         # 追加ビュー
    └── todo_edit_view.dart        # 編集ビュー
```

### 各ファイルの説明

#### `lib/main.dart`
アプリのエントリポイント。`TodoApp`（`StatefulWidget`）がアクティブTODOリスト（`_activeTodos`）と完了TODOリスト（`_completedTodos`）を分けて保持する。`initState`で`TodoStorage.load()`を呼び出して永続化データを復元し、ロード中は`CircularProgressIndicator`を表示する。各操作後に`_persist()`で`TodoStorage.save()`を呼び出して即時保存する。

| コールバック | 説明 |
|---|---|
| `onAdd` | 新規TODOを`_activeTodos`に追加して保存 |
| `onUpdate` | 既存TODOを更新して保存（アクティブ・完了どちらも対応） |
| `onComplete` | `_activeTodos`からTODOを取り出し`isCompleted: true`で`_completedTodos`に移動して保存 |
| `onDelete` | 両リストから指定IDのTODOを削除して保存 |
| `onReorder` | `_activeTodos`内の順番を入れ替えて保存 |

#### `lib/models/todo.dart`
TODOのデータモデル。以下のフィールドを持つ。

| フィールド | 型 | 説明 |
|---|---|---|
| `id` | `String` | 一意識別子（作成日時のマイクロ秒） |
| `title` | `String` | タイトル（必須） |
| `createdAt` | `DateTime` | 作成日時 |
| `deadline` | `DateTime?` | 締切日（任意） |
| `content` | `String` | 詳細内容 |
| `isCompleted` | `bool` | 完了フラグ（デフォルト: false） |

`copyWith`で不変オブジェクトとしてコピーを生成。`toJson`/`fromJson`で永続化用のJSON変換を提供する。

#### `lib/services/todo_storage.dart`
`shared_preferences`を使ってTODOを永続化するサービス。アクティブTODOと完了TODOをそれぞれ`active_todos`・`completed_todos`キーにJSON配列として保存する。

| メソッド | 説明 |
|---|---|
| `load()` | ストレージからTODOを読み込み、`({active, completed})`レコードで返す |
| `save(active, completed)` | 両リストをJSON文字列に変換してストレージに保存する |

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
- AppBarの **削除アイコン**から確認ダイアログ経由でTODOを削除（削除されたTODOは永続化から除外される）。
- 戻り値は`TodoEditResult`クラスで統一（`todo`フィールドと`isCompleted`フラグを持つ）。

## 画面遷移

```
TodoListView（TODOタブ）
  ├── [FAB] ───────────────→ TodoAddView（追加）
  │                              └── [追加ボタン] → 一覧に追加＆永続化
  └── [TODOタップ] ────────→ TodoEditView（編集）
                                 ├── [保存ボタン]     → 一覧を更新＆永続化
                                 ├── [✓完了ボタン]    → 完了タブに移動＆永続化
                                 └── [削除ボタン]     → 一覧から削除＆永続化から除外

TodoListView（完了タブ）
  └── [TODOタップ] ────────→ TodoEditView（編集・完了状態）
                                 ├── [保存ボタン]     → 完了一覧を更新＆永続化
                                 └── [削除ボタン]     → 完了一覧から削除＆永続化から除外
```

## 依存パッケージ

| パッケージ | 用途 |
|---|---|
| `shared_preferences` | TODOデータのローカル永続化 |

## 開発・実行方法

```bash
flutter pub get
flutter run
```
