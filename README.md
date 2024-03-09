# narou_docker


## 概要
WEB小説からの電子書籍データ変換支援ツール
[Narou.rb](https://github.com/whiteleaf7/narou)をDocker上で動作させます。なるべくパッチは集めたはずですが、なろう運営が変わったので今後どうなるかわかりません。すでにこのNarou.rbは時代遅れかもしれません。

## 使い方

### 1. ファイルを集めます
[Narou.rbをdockerで起動](https://www.tenjiku.biz/2023/04/09/narou-rb%e3%82%92docker%e8%b5%b7%e5%8b%95/)
で説明しているAozoraEpub3-1.1.1b14Q2.zipとkindlegen_linux_2.6_i386_v2_9.tar.gzを同じフォルダに保存しておきます。

### 2. コンテナを起動します
`$ docker compose up -d --build`

### 3. 以下のURLを開きます
http://localhost:8200/
