#!/bin/bash
set -e

# --- 設定 ---
# GitHub上の生ファイルコンテンツのベースURL
BASE_URL="https://raw.githubusercontent.com/n4cl/cursor-rules/main"
PROFILE=$1

# --- メイン処理 ---

# プロファイルが指定されていない場合は使用法を表示
if [ -z "$PROFILE" ]; then
  echo "使用法: curl -sSL <スクリプトURL> | bash -s {プロファイル名|clear}"
  echo "利用可能なプロファイル: dev, blog"
  exit 1
fi

# .cursorディレクトリが存在しない場合は作成
TARGET_DIR=".cursor"
mkdir -p "$TARGET_DIR"

# 'clear'コマンドの処理
if [ "$PROFILE" = "clear" ]; then
  echo "$TARGET_DIR/ から既存のルールをクリアしています..."
  # 他のユーザーファイルを削除しないように、.mdcファイルのみを削除
  find "$TARGET_DIR" -maxdepth 1 -type f -name "*.mdc" -delete
  echo "すべてのルールがクリアされました。"
  exit 0
fi

# プロファイル定義ファイルのURLを定義
PROFILE_URL="$BASE_URL/profiles/${PROFILE}.txt"

# プロファイル定義ファイルをダウンロード
echo "プロファイルを取得中: $PROFILE ($PROFILE_URL)"
# curlを-fオプション付きで使用し、404エラー時にサイレントに失敗させ、リストをキャプチャ
RULE_LIST=$(curl -fsSL "$PROFILE_URL")

if [ -z "$RULE_LIST" ]; then
  echo "エラー: プロファイル '$PROFILE' が見つからないか、空です。"
  echo "プロファイルが存在し、 $PROFILE_URL からアクセス可能であることを確認してください。"
  exit 1
fi

# まず、クリーンな状態を確保するために既存のルールをクリア
echo "既存のルールをクリアしています..."
find "$TARGET_DIR" -maxdepth 1 -type f -name "*.mdc" -delete

# プロファイルで指定された各ルールファイルをダウンロード
echo "プロファイルを設定中: $PROFILE"

# ダウンロードしたリストを処理するためのwhile-readループを使用
while IFS= read -r rule_path; do
  # 空行をスキップ
  if [ -z "$rule_path" ]; then
    continue
  fi

  # ファイルURLに 'rules/' プレフィックスを追加
  FILE_URL="$BASE_URL/rules/$rule_path"
  FILE_NAME=$(basename "$rule_path")
  DEST_PATH="$TARGET_DIR/$FILE_NAME"

  echo "  - $FILE_NAME をダウンロード中..."
  curl -fsSL "$FILE_URL" -o "$DEST_PATH"

done <<< "$RULE_LIST" # リストをループに渡すためのヒアストリング

echo "プロファイル '$PROFILE' が $TARGET_DIR/ に正常に設定されました。"