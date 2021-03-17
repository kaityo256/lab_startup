# Dockerの簡単な使い方

## はじめに

既にPython等で、パッケージのバージョンに依存した問題や、環境によってコードが動いたり動かなかったりしているのを経験しているはずだ。また、サーバ管理者をしてみると、「いろいろやって」動くようになったサーバが死んで、別のサーバに同じような環境を構築しようとしたら、どうやって動くようになっていたか全く思い出せない、なんてことがザラにある。また、自分のサーバはCentOSなのに、Ubuntu用の説明しか見つからず、そのままでは動いてくれなかった、ということもある。こんな悩みを解決する技術がDockerだ。Dockerはコンテナ型の仮想化技術を用いて、仮想環境を構築、管理、配布するための技術だ。特に、環境構築の手順をコード化する「Infrastructure as Code（IaC）」と呼ばれる仕組みは非常に便利だ。今後、何かしらの開発をするにあたって、Dockerが必須とまでは言わないが、知っていると便利なのは確実だ。以下、Dockerの詳細には触れず、簡単な使い方だけ紹介する。また、「コンテナ」や「イメージ」といった単語の説明もしないので、必要に応じて調べて欲しい。

## Dockerを使ってみる

まずは研究室サーバにログインし、Dockerコマンドを叩いてみよう。Dockerは`docker`コマンドにより制御できる。まずは以下のコマンドを実行せよ。

```sh
docker ps
```

`permission denied`と言われ、実行が拒否されたはずだ。Dockerではセキュリティのため、デフォルトでは一般ユーザの利用が許可されていない。そこで、一時的にDockerグループに所属しよう。

```sh
newgrp docker
```

パスワードを聞かれるので事前に伝えたパスワードを入力せよ。これでDockerが使えるようになる。再度以下のコマンドを実行せよ。

```sh
docker ps
```

これは、現在実行中のコンテナを表示するコマンドだ。こんな表示がされたはずである。

```txt
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

現在は実行中のコンテナがひとつもないため、何も表示されていない。

次に、現在、ローカルに保存されているイメージを確認しよう。

```sh
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              18.04               329ed837d508        13 days ago         63.3MB
```

ubuntuの18.04があるはずだ(うちの研究室では)。イメージがない場合、リモートから取ってくることができる。それが`pull`コマンドだ。

```sh
docker pull ubuntu:18.04
```

これは、ubuntuの「18.04」というタグのついたイメージを持ってきなさい、という命令だ。タグは、多くの場合バージョンの指定に使われる。省略すると`latest`を指定したことになる。

今回はローカルに既にイメージがあるために

```txt
Status: Image is up to date for ubuntu:18.04
```

と言って何もしない。

次に、このイメージからコンテナを作成し、ログインしてみよう。

```sh
$ docker run -it ubuntu:18.04
```

`root@06e9b4bcd4c6:/#`といった文字列が出てきたはずである。この`root@`の右側は毎回異なる。この文字列を3桁くらい覚えておくこと。

さて、今まっさらなubuntuにログインした。まずはパッケージをアップデートしよう。

```sh
apt-get update
```

アップデートが終わったら、何かインストールしてみよう。今回は「Bastard Tetris(いやがらせテトリス), bastet」をインストールしてみよう。以下のコマンドを実行せよ。

```sh
apt-get install -y bastet
```

ここで`-y`を指定するのを忘れないこと。これは「確認無しにインストールせよ」というオプションだ。

インストールが終わったら、実行して遊んでみよう。

```sh
/usr/games/bastet
```

見た目は普通のテトリスに見えるが、しばらくやってみると、なかなかラインが消せないのがわかるだろう。実はこのテトリスはブロックがランダムではなく「プレイヤーが一番要らなそうな奴」を選んで出してくる。「Bastard Tetris(いやがらせテトリス)」と呼ばれる所以である。

さて、ゲームオーバーしてQuitを選ぶか、Ctrl+Cで終了し、さらにこの仮想環境を`exit`で抜けよう。

その後、またコンテナを表示してみよう。

```sh
docker ps
```

何も表示されないはずである(command not found等と言われたら、あなたはまだ仮想環境の中にいるのでexitすること)。これは「現在実行中」のコンテナを表示しているからだ。`-a`オプションをつけることで終了したコンテナも表示できる。

```sh
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                            PORTS               NAMES
06e9b4bcd4c6        ubuntu:18.04        "/bin/bash"         16 minutes ago      Exited (127) About a minute ago                       stupefied_sammet
```

終了したコンテナが表示されたはずだ。複数人で実行した場合は複数表示されるので、先ほど覚えたIDを使う。終了したコンテナを再び起動してみよう。先ほど覚えた3桁のIDを入力せよ(他のコンテナIDと区別できる最低限の桁数を指定すれば良いので、一つしかなければ最初の1桁でも良い)。

```sh
docker start 06e
```

すると、STATUSが実行中(UP)になるはずだ。

```sh
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
06e9b4bcd4c6        ubuntu:18.04        "/bin/bash"         19 minutes ago      Up 51 seconds                           stupefied_sammet
```

この実行中のコンテナに接続(attach)しよう。

```sh
$ docker attach 06e
root@06e9b4bcd4c6:/#        
```

ログインできたはずだ。このコンテナには既にbastetがインストールされているはずなので実行してみよ。

```sh
/usr/games/bastet
```

実行できるはずだ。また終了して、仮想環境を抜けておくこと。

仮想環境を抜けたらコンテナを消しておこう。それには`rm`コマンドを使う。

```sh
docker rm 06e
```

ちゃんと削除されたか、`docker ps -a`コマンドで確認すること。

## Dockerfileを書いてみる

Dockerを使う最大のメリットは、手順をファイルに書いておき、ファイルから環境を構築できることだ。これは「Infrastructure as Code（IaC）」と呼ばれ、ChefやAnsibleなどが有名だ(気になったら調べてみよ)。ここでは、先ほど行った手順をコード化し、イメージ作成を自動化してみよう。

まず、適当なディレクトリを掘ろう。ここでは`docker`とするが、好きな名前にしてかまわない。

```sh
mkdir docker
cd docker
```

次に、`Dockerfile`を作成する。最初が大文字であることに注意。

```sh
vim Dockerfile
```

まずは以下の内容のファイルを作成せよ。

```yaml
FROM ubuntu:18.04

RUN apt-get update
```

`FROM`は、元にするイメージを指定する。ここでは`ubuntu:18.04`にしよう。`RUN`は実行するコマンドだ。最初はパッケージのアップデートをする。

ファイルが作成できたら、`docker build`によりイメージを作成しよう。

```sh
docker build -t watanabe/bastet .
```

`-t`オプションで名前を指定する。「自分の名前/bastet」にしよう。最後のピリオドを忘れないように。これは`Dockerfile`へのパスを表す。今回はカレントディレクトリにあるので`.`で良い。

実行に成功すれば

```txt
Successfully built 876b1067a73b
Successfully tagged watanabe/bastet:latest
```

などと表示されるはずだ。イメージが出来ているか見てみよう。

```sh
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
watanabe/bastet     latest              876b1067a73b        About a minute ago   92.8MB
ubuntu              18.04               c3c304cb4f22        6 weeks ago          64.2MB
```

このIMAGE ID(`876b1067a73b`)の最初の数桁(`876`)も覚えておこう。

さて、先ほどはパッケージのアップデートしなかったので、bastetのインストールを追加しよう。`Dockerfile`を以下のように修正せよ。

```yaml
FROM ubuntu:18.04

RUN apt-get update && apt-get -y install bastet
```

`&&`は、前のコマンドが成功した時にのみ次を実行するものだ。一方、`;`を使うと、前のコマンドの成否に関わらず次を実行する。また、`apt-get -y install bastet`の`-y`オプションを忘れないこと。

ファイルを更新したら、もう一度`build`を走らせよう。

```sh
docker build -t watanabe/bastet .
```

先ほどとは違うImage IDが表示されたはずだ。

```txt
Successfully built 6e343ebe467b
Successfully tagged watanabe/bastet:latest
```

イメージ一覧を見てみよう。

```sh
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
watanabe/bastet     latest              6e343ebe467b        About a minute ago   94.9MB
<none>              <none>              876b1067a73b        9 minutes ago        92.8MB
ubuntu              18.04               c3c304cb4f22        6 weeks ago          64.2MB
```

イメージを更新し、そちらに`watanabe/bastet`という同じ名前(タグ)を付けたため、名無しのイメージ`<none>`が出来たことがわかる。サイズもわりと大きいので消しておこう。イメージの削除は`rmi`を使う。

```sh
docker rmi 876
```

不要なイメージが消えたはずだ。

せっかくイメージを作成したので、そこからコンテナを作ってみよう。

```sh
docker run -it watanabe/bastet
```

最初からbastetがインストール済みなので、そのまま実行できるはずである。

```sh
/usr/games/bastet
```

実行を確認したら、また仮想環境を抜けよう。

次に、先ほど作ったイメージを消してみよう。名前でもIDでもどちらでも消すことができる。

```sh
$ docker rmi watanabe/bastet
Error response from daemon: conflict: unable to remove repository reference "watanabe/bastet" (must force) - container 4716a1ed11c2 is using its referenced image 6e343ebe467b
```

「このイメージはコンテナ(4716a1ed11c2)が使っているから消せないよ」と文句を言われたはずだ。まずはそのコンテナを消してからイメージを消そう。

```sh
$ docker rm 471
471
$ docker rmi watanabe/bastet
Untagged: watanabe/bastet:latest
Deleted: sha256:6e343ebe467bc4d03fad86ee8ab104fa7412ba1f3a15a937aa85d62cd92c7788
Deleted: sha256:151596245487e3a389315bf4a41f5926959ee12b71865391c09cae6f1293ad92
```

今度は消せたはずだ。

以後、このDockerfileからイメージを作れば、間違いなくbastetが実行できる環境となる。また、この環境を作るのにどんなコマンドが必要だったかも全てファイルに残っている。まさにInfrastructure as Codeである。

ここでは研究室サーバを使ったが、もし興味があればローカルマシンでやってみると良い。その場合はdockerグループへの所属は不要である。