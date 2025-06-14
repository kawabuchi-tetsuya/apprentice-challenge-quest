#!/bin/bash

mkdir -p password_info
echo "パスワードマネージャーへようこそ！"

source .env

while true; do
  read -r -p "次の選択肢から入力してください（Add Password/Get Password/Exit）: " input

  case "$input" in
    "Add Password")
      read -r -p "サービス名を入力してください： " service_name
      read -r -p "ユーザー名を入力してください： " user_name
      read -r -s -p "パスワードを入力してください： " password
      echo

      # 復号
      decrypted=$(gpg -d password_info/password.txt.asc 2>/dev/null || true)

      # 追加して再暗号化
      {
        echo "$decrypted"
        echo "$service_name:$user_name:$password"
      } | gpg -r "$GPG_FINGERPRINT" -e -a -o password_info/password.txt.asc

      echo "パスワードの追加は成功しました。"
      ;;

    "Get Password")
      read -r -p "サービス名を入力してください： " service_name

      # $service_name が空のとき
      if [ -z "$service_name" ]; then
        echo "サービス名が未入力です。"
        continue
      fi

      # 復号してサービス情報を取得
      service_info=$(gpg -d password_info/password.txt.asc 2>/dev/null | grep -m 1 "^$service_name:")

      # $service_info が空でないとき
      if [ -n "$service_info" ]; then
        user_name=$(echo "$service_info" | cut -d":" -f2)
        password=$(echo "$service_info" | cut -d":" -f3)

        echo "サービス名：$service_name"
        echo "ユーザー名：$user_name"
        echo "パスワード：$password"
      else
        echo "そのサービスは登録されていません。"
      fi
      ;;

    "Exit")
      echo "Thank you!"
      break
      ;;

    *)
      echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
      ;;
  esac
done
