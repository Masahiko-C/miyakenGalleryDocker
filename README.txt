下記ディレクトリに別のgitリポジトリからpull
./miyaken-gallery

ディレクトリ移動
cd ./ssl

1. 下記コマンドで秘密鍵
openssl genrsa 2048 > localhost.key

2. 共通鍵を秘密鍵から作成　(入力情報は全部EnterでskipしてOK)
openssl req -new -key localhost.key > localhost.csr

3. SSLサーバー証明書の作成
openssl x509 -days 3650 -req -signkey localhost.key < localhost.csr > localhost.crt

4. 下記コマンドで各々のファイルをディレクトリを移動(ここを元にコンテナに鍵をコピーする)
mv localhost.key ./private/
mv localhost.crt ./certs/

# コンテナ構築
5. docker-compose build

# コンテナ立ち上げ
6. docker-compose up -d

7. 下記コマンドでコンテナにアクセス
docker exec -it rails bash

8. ./miyaken-galleryであることを確認してrailsパッケージをインストール
bundle install

7. ブラウザで https://localhostでhelloworldが表示されるか確認
-> 表示されなければmnaruseに報告