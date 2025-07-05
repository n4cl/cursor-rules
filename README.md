# Cursor Rules

このリポジトリは、Cursorエディタで使用できる、共有可能なルールセットを管理します。

## クイックセットアップ

お使いのプロジェクトにルールをセットアップするには、プロジェクトのルートディレクトリで以下のコマンドを実行してください。必要なセットアップスクリプトがダウンロードされ、実行されます。

`{profile_name}` の部分を、希望するプロファイル名（例: `dev`, `blog`）に置き換えてください。

```bash
curl -sSL https://raw.githubusercontent.com/n4cl/cursor-rules/main/scripts/setup.sh | bash -s {profile_name}
```

**使用例 (`dev` プロファイルの場合):**
```bash
curl -sSL https://raw.githubusercontent.com/n4cl/cursor-rules/main/scripts/setup.sh | bash -s dev
```

このコマンドを実行すると、プロジェクト内に `.cursor` ディレクトリが作成され、このルールリポジトリが `.cursor/rules` にクローンされます。そして、選択されたプロファイルに応じたルールのシンボリックリンクが `.cursor` ディレクトリ内に作成されます。

### 利用可能なプロファイル

*   **`dev`**: 一般的なソフトウェア開発向け。Git、GitHub、Markdownの整形に関するルールが含まれます。
*   **`blog`**: 技術ブログやドキュメント執筆向け。Markdownの整形や効果的なコミュニケーションに関するルールが含まれます。

### ルールの更新

ルールをリポジトリの最新バージョンに更新するには、以下のコマンドを実行します。

```bash
curl -sSL https://raw.githubusercontent.com/n4cl/cursor-rules/main/scripts/setup.sh | bash -s update
```

### ルールの解除

プロジェクトからすべてのルール設定（シンボリックリンク）を解除するには、以下のコマンドを実行します。

```bash
curl -sSL https://raw.githubusercontent.com/n4cl/cursor-rules/main/scripts/setup.sh | bash -s clear
```

## 仕組み

セットアップスクリプトは、このリポジトリをあなたのプロジェクトの `.cursor/rules` ディレクトリにクローンします。次に、プロファイル定義ファイル（例: `profiles/dev.txt`）を読み込み、必要なルールファイルのパスを取得します。

最後に、`.cursor/` ディレクトリ内に、`.cursor/rules/` 内にある実際のルールファイルを指し示すシンボリックリンクを作成します。

このアプローチにより、プロジェクトのGit履歴を汚すことなく、ルールの簡単な更新とバージョン管理が可能になります。