#!/bin/bash

mkdir -p password_info
echo "パスワードマネージャーへようこそ！"

while true; do
  read -r -p "次の選択肢から入力してください（Add Password/Get Password/Exit）: " input

  case "$input" in
    "Add Password")
      read -r -p "サービス名を入力してください： " service_name
      read -r -p "ユーザー名を入力してください： " user_name
      read -r -s -p "パスワードを入力してください： " password
      echo

      echo "$service_name:$user_name:$password" >> password_info/password.txt
      echo "パスワードの追加は成功しました。"
      ;;

    "Get Password")
      read -r -p "サービス名を入力してください： " service_name

      if grep -q -m 1 "^$service_name:" password_info/password.txt; then
        service_info=$(grep -m 1 "^$service_name:" password_info/password.txt)

        user_name=$(echo "$service_info" | cut -d":" -f2)
        password=$(echo "$service_info" | cut -d":" -f3)

        echo "サービス名：$service_name"
        echo "ユーザー名：$user_name"
        echo "パスワード：$password"
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
