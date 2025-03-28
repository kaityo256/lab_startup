# SSHの設定

## SSHとは

SSH (Secure Shell)とは、それまで平文で通信していたtelnetやrsh、rloginを代替するために生まれたセキュアな通信手段である。SSHは規格であり、その実装が例えばOpenSSHとなる。ターミナルで`ssh -V`を実行すると、そのバージョンが分かる。

```sh
$ ssh -V
OpenSSH_8.2p1 Ubuntu-4ubuntu0.12, OpenSSL 1.1.1f  31 Mar 2020
```

SSHの役割は、通信の暗号化(通信を傍受されても内容がわからないよにすること)、及び通信相手の認証(自分の通信相手が真にその相手であることを保証する)の二点である。以下では、暗号化については触れず、認証についてのみ触れる。

認証には「ホスト認証」と「ユーザ認証」がある。ホスト認証とは、接続するクライアントが「これから接続しようとするホストが、正しい接続相手であること」を確認することであり、「ユーザ認証」は、ホストにログインしようとするユーザが、その権利を持つユーザであるかを確認することである。

SSHにおいてホストに接続する際、以下の順番でやりとりが行われる。

1. クライアントとホストで鍵交換を行い、以後の通信を暗号化する。
2. クライアントが、これから接続しようとしているホストが正しい相手かどうかを確認する(ホスト認証)。
3. ホストが、これから接続しようとするユーザがその権利を持つ相手かどうかを確認する(ユーザ認証)

## 公開鍵の作成と接続

### SSH公開鍵の作成

まず、ユーザ認証に用いる秘密鍵と公開鍵のペアを作成しよう。ユーザ認証は、サーバ側に公開鍵をなんらかの方法で登録しておき、後は「その公開鍵に対応する秘密鍵を持つユーザは、真にそのユーザである」という所持認証で認証を行う。

ターミナルのホームディレクトリで、`ssh-keygen`コマンドにより、鍵のペアを作成しよう。`-t ed25519`は鍵のタイプ(署名アルゴリズム)の指定である。

```txt
$ ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/watanabe/.ssh/id_ed25519): (1)
Enter passphrase (empty for no passphrase):  (2)
Enter same passphrase again:  (3)
```

1. コマンドを実行すると、まず鍵のペアを保存する場所の確認をする。Windowsなら`/home/ユーザー名/.ssh/id_ed25519`、Macなら`/Users/ユーザー名/.ssh/id_ed25519`などとなるはずだ。ここでは単にエンターキーを押せば良い。
2. パスフレーズを入力する。キー入力しても何も表示されないので注意。記号などを混ぜる必要はないが、ある程度長いものが望ましい。入力が終わったらエンターキーを押す。
3. パスフレーズを再入力する。入力が終わったらエンターキーを押す。一致していない場合は「Passphrases do not match.  Try again.」と言われてやり直しになる。

パスフレーズを二回入力し、それが一致したら以下のような画面になるはず。

```txt
Your identification has been saved in /Users/watanabe/.ssh/id_ed25519
Your public key has been saved in /Users/watanabe/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:SGmigMJdCQt6SuKCSSkH+p4GN4iYy8c1rGx1qgKC6D0 watanabe@hiroshinoiMac.local
The key's randomart image is:
+--[ED25519 256]--+
|.. ....          |
|=.+ o. .         |
|O=oo. +          |
|@X ..+ .         |
|&.=  =..S        |
|B=oo+ +          |
|=.=* .           |
| +oE.            |
|  ...            |
+----[SHA256]-----+
```

これは、今回作成した秘密鍵が`/home/watanabe/.ssh/id_ed25519`に、公開鍵が`/home/watanabe/.ssh/id_ed25519.pub`に保存されたよ、というメッセージだ。

この状態で、公開鍵を表示しよう。`cat .ssh/id_ed25519.pub`を実行せよ。

```sh
$ cat .ssh/id_ed25519.pub 
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEIUtrivdfrVAFUuf5YS9JluKK7aw/HEfwNvn36NpVbe watanabe@hiroshinoiMac.local
```

この`ssh-ed25519`から始まる一行のテキストが公開鍵だ。これを希望のアカウント名とともに渡辺に知らせること。なお、`-----BEGIN OPENSSH PRIVATE KEY-----`で始まるテキストは秘密鍵なので他の人に知らせてはならない。

希望アカウント名と公開鍵を知らせたら、渡辺が研究室サーバにアカウントを作って知らせるので、ログインする。ログインは`ssh アカウント名@サーバー名`とする。サーバー名は別途知らせる。

```sh
ssh username@name.of.server
```

すると、最初に

```txt
The authenticity of host 'name.of.server (xxx.xxx.xxx.xxx)' can't be established.
ECDSA key fingerprint is SHA256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

といったメッセージが表示される。これはホスト認証の確認であり、「初めて接続するホストだが、このフィンガープリントを持つホストはあなたが接続しようとしているホストで間違いないか？」と聞いてきている。ここで`yes`と入力すると、

```txt
Warning: Permanently added 'name.of.server,xxx.xxx.xxx.xxx' (ECDSA) to the list of known hosts.
```

という画面が表示される。これは「このサーバを『知っているホスト(known hosts)に登録したよ』という意味だ。「Warning(警告)」と出ているが、通常は気にしなくて良い。

その後、

```sh
Enter passphrase for key '/home/watanabe/.ssh/id_ed25519':
```

と、パスフレーズを要求されるので、先ほど鍵を作るのに使ったパスフレーズを入力すると、ログインできるはずである。この時、入力した文字列は表示されない。

ログインができたら、`exit`を入力してサーバからログアウトすること。

### GitHubへの公開鍵の登録

次に、先ほど作成した公開鍵をGitHubにも登録しよう。

```sh
cat .ssh/id_ed25519.pub
```

を実行した結果をクリップボードにコピーしておく。

その後、GitHubにログインし、以下の手順により公開鍵を登録せよ。

1. GitHubの一番右上のアイコンをクリックして現れるメニューの下の方の「Settings」を選ぶ。
1. 左に「Account settings」というメニューが現れるので「SSH and GPG keys」を選ぶ。
1. 「SSH keys」右にある「New SSH key」ボタンを押す
1. 「Title」と「Key」を入力する。Titleはなんでも良いが、例えば「Git Bash」もしくは「University PC」とする。Keyには、.ssh/id_ed25519ファイルの中身をコピペする。Git Bashで以下を実行せよ。
    ```
    cat .ssh/id_ed25519.pub
    ```
1. すると、ssh-rsaから始まるテキストが表示されるため、マウスで選択して右クリックから「Copy」、そして、先ほどのGitHubの画面の「Key」のところにペーストし、「Add SSH key」ボタンを押す。
1. `This is a list of SSH keys associated with your account. Remove any keys that you do not recognize.`というメッセージの下に、先ほどつけたTitleの鍵が表示されていれば登録成功だ。

GitHubに公開鍵の登録が済んだら、認証できる確認しよう。

```sh
ssh -T git@github.com
```

やはり初回接続時には

```txt
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

と聞かれるので、フィンガープリント(後述)を確認の上で`yes`と入力せよ。

```txt
Hi (GitHubアカウント名)! You've successfully authenticated, but GitHub does not provide shell access.
```

という出力が出たら認証成功である。

### known_hosts

先ほどのように、これまでに接続したことがないホストに接続しようとすると、「本当に正しいホストか？」と確認され、ユーザが`yes`(正しいです)と意志表示すると

```txt
Warning: Permanently added 'name.of.server,xxx.xxx.xxx.xxx' (ECDSA) to the list of known hosts.
```

というメッセージが表示された。これは、一度接続したホストの公開鍵を「知ってるホストリストに恒久的に追加したよ」という意味であり、その実体は`.ssh/known_hosts`というファイルである。

これまでに接続したことがないサーバに接続しようとすると、以下のような表示が出る。例えば、github.comに接続確認をしてみる。

```sh
$ ssh -T git@github.com
The authenticity of host 'github.com (20.27.177.113)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

これは、

* 20.27.177.113というIPアドレスを持つgithub.comにこれまで接続したことがないこと。
* このサイトのED25519 のフィンガープリント(指紋)が`SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU`であること

を伝えた上で、接続するか？と聞いている。GitHubはホスト鍵のfinger printを公開している。

[GitHub の SSH キーフィンガープリント](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)

これを見ると、GitHubの鍵のフィンガープリントは以下の通りである(2025年3月時点)。

* `SHA256:uNiVztksCsDhcc0u9e8BujQXVUpKZIDTMczCvj3tD2s` (RSA)
* `SHA256:br9IjFspm1vxR3iA35FWE+4VTyz1hYVLIE2t1/CeyWQ` (DSA - 終了)
* `SHA256:p2QAMXNIC1TJYWeIOttrVc98/R1BUFWu3/LiyKgUfQM` (ECDSA)
* `SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU` (Ed25519)

先ほど表示されたフィンガープリントは、このリストの最後の鍵と一致するので「接続相手が正しい」と判断できるから、`yes`を入力すると、

```sh
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
Hi kaityo256! You've successfully authenticated, but GitHub does not provide shell access.
```

と、`github.com`を「接続したことがあるホスト」のリストに追加したことが表示される。この「接続したことがあるホスト」のリストは、`.ssh/known_hosts`に保存される。

`known_hosts`に、既にホストの鍵が登録されているか確認するには`ssh-keygen -F`コマンドを用いる。

```sh
$ ssh-keygen -F github.com
# Host github.com found: line 3
|1|O/JuGv80cFBXGl4BSmfy4CcVOM4=|WB3zWF03NKs/JpnoE7GQL+J1l2E= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
```

これは、`github.com`というホストの情報を`known_hosts`の3行目に見つけたよ、という意味だ。

万が一、サーバの乗っ取りやDNS汚染などで、一度接続したサーバとは異なるサーバに接続されそうになったときには、警告がでて接続ができない。

例えば、`known_hosts`に保存された鍵を書き換えてから、再度githubにアクセスしようとすると、以下のように表示され、認証に失敗する。

```sh
$ ssh -T git@github.com
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ED25519 key sent by the remote host is
SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
Please contact your system administrator.
Add correct host key in /Users/watanabe/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/watanabe/.ssh/known_hosts:14
Host key for github.com has changed and you have requested strict checking.
Host key verification failed.
```

多くの場合、サーバの再インストールなどで鍵が変わってしまった、などが原因であるが、稀にDNS汚染などの攻撃の可能性もあるため、上記の表示が出たら接続前に確認すること。

研究室サーバの再インストールなどが原因であれば、`.ssh/known_hosts`を一度削除してから再度接続すれば、新たにフィンガープリントを保存しなおしてくれる。

## SSHエージェントの設定

SSHの秘密鍵はパスフレーズにより暗号化されており、毎回使う時にパスフレーズの入力が求められる。これは、「秘密鍵を持っている」という所持認証と、「パスフレーズを知っている」という「知識認証」を組みあせた多要素認証になっており、セキュリティは高まっているが、毎回パスフレーズを入力するのは面倒である。しかし、秘密鍵にパスフレーズを設定しないと、秘密鍵が漏れた場合に被害が大きい。

そこで、秘密鍵にパスフレーズを設定しつつ、毎回パスフレーズを入力しなくて良いようにしたい。そのための仕組みがSSHエージェントである。

SSHエージェントは、パスフレーズを入力して復号された秘密鍵をメモリにキャッシュし、次からはそちらを使うため、二度目からはパスフレーズの入力が必要なくなる。ただし、ログアウトするとメモリから消えるため、再度パスフレーズを入力する必要がある。

SSHエージェントの設定は、MacとWindows (WSL)で異なる。

### Macの場合

Macの場合は、デフォルトでSSHエージェントが起動している。ターミナルのホームディレクトリで

```sh
ssh-add
```

を実行せよ。秘密鍵のパスフレーズを聞かれるので、入力せよ。その後、研究室サーバにsshで接続してみよ。パスフレーズを聞かれずに接続できたら成功である。

パスフレーズは、Macのキーチェインに保存される。これはログアウトされると消えるため、必要な時に毎回`ssh-add`の実行が必要となる。

### Windowsの場合

まず、SSHエージェントを起動する必要がある。いくつか方法があるが、`keychain`を導入するのが簡単だ。

まず、不要なプロセスをすべて停止させる。WSLを停止した状態でWindowsのPowerShellを起動せよ。たとえば「Windowsキー+r」で「ファイル名を指定して実行」画面に「powershell」を入力するとPowerShellを起動できる。起動したら、以下を実行する。

```sh
wsl --shutdown
```

次に、WSL2のUbuntuを起動し、`keychain`をインストールする。

```sh
sudo apt-get install keychain
```

次に、`keychain`を起動する。

```sh
/usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
```

初回起動時にはパスフレーズを聞かれるので入力する。すると、`$HOME/.keychain`にいくつかシェルスクリプトが出来るので、それを実行する。

```sh
source $HOME/.keychain/$HOST-sh
```

これにより、`keychain`が`ssh-agent`を探し、既存のプロセスがあれば接続、なければ起動してくれる。

`keychain`の起動を毎回行うのは面倒なので、`.bashrc`の最後に

```sh
/usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
source $HOME/.keychain/$HOST-sh
```

と書いておくと良い。Zshなども同様だが、cshやfishは、`$HOST-sh`の`-sh`を`-csh`や`-fish`にすること。

## SSHエージェント転送による多段SSH

研究を進める上で、研究室サーバやスパコンを使うようになるだろう。このとき、そのようなリモートサーバ上からGitHubにアクセスしたくなる。すると、「リモートサーバにSSHでログインした上で、そのリモートサーバからさらにSSHでGitHubにアクセスする」という、多段SSHと呼ばれる状態になる。

最も単純には、リモートサーバに秘密鍵と公開鍵のペアを生成し、リモートサーバの公開鍵をGitHubに登録することが考えられる。このとき、リモートサーバでもう一度パスフレーズを入力すれば、GitHubにアクセスできる。しかし一般論として、リモートサーバに秘密鍵を置くことは避けた方が良い。IPアドレスが公開されているリモートサーバは、ローカルマシンに比べて外部からの攻撃を受けやすい。万が一、リモートサーバがハックされた際、そこに秘密鍵があると、リモートサーバからアクセスしていた別のサーバも攻撃されることがある。

実際にそのような事件が起きたことがある。あるユーザのスパコンアカウントが(おそらくキーロガーにより)クラックされた。クラックされたスパコンは被害が少なかったのだが、このスパコンに「パスフレーズ無しの秘密鍵」が置いてあり、攻撃者はそこを踏み台に別のスパコンにログインすることができた。そして別のスパコンのセキュリティホールをついて特権昇格に成功し、複数のスパコンが運用停止に追い込まれたことがある。パスフレーズにより暗号化されていても、原理的には時間をかければ解析できるため、リモートサーバには原則として秘密鍵を置かないようにしたい。

さて、リモートサーバには秘密鍵を置きたくないが、多段SSHを行うためには秘密鍵が必要だ。そこで、SSHにはエージェント転送という機能がある。これは、秘密鍵による署名を転送する仕組みだ。いま、ローカルPCからリモートサーバに接続し、そこからGitHubにアクセスしようとすると、GitHubから秘密鍵による署名を要求される。リモートサーバのSSHエージェントはそれをローカルPCに転送し、ローカルPCで署名を作成してリモートサーバに送信、リモートサーバはさらにそれをGitHubに転送することで認証が完了する。

この認証情報の転送を行うためには、リモートサーバ接続時に`-A`オプションをつける必要がある。

研究室サーバに`-A`オプションをつけてSSHで接続せよ。

```sh
ssh username@name.of.server -A
```

その後、研究室サーバにログインした状態でGitHubに公開鍵認証が通るか確認しよう。

```sh
ssh -T git@github.com
```

パスフレーズを聞かれずに、

```txt
Hi (GitHubアカウント名)! You've successfully authenticated, but GitHub does not provide shell access.
```

という表示が出たら認証に成功だ。以後、研究室サーバから`git pull/push`などの通信が可能となる。
