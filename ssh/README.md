# SSHの設定

## SSH公開鍵の作成

ターミナルのホームディレクトリで、`ssh-keygen`コマンドにより、鍵のペアを作成する。`-t ed25519`は鍵のタイプ(署名アルゴリズム)の指定である。


```txt
$ ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/watanabe/.ssh/id_ed25519): (1)
Enter passphrase (empty for no passphrase):  (2)
Enter same passphrase again:  (3)
```

1. コマンドを実行すると、まず鍵のペアを保存する場所の確認をする。Windowsなら`/home/ユーザー名/.ssh/id_ed25519`、Macなら`/Users/ユーザー名/.ssh/id_ed25519`などとなるはずだ。ここでは単にエンターキーを押せば良い。
2. パスフレーズを入力する。これは普段使うパスワードで良い。キー入力しても何も表示されないので注意。入力が終わったらエンターキーを押す。
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

希望アカウント名と公開鍵を知らせたら、渡辺が研究室サーバにアカウントを作って知らせるので、ログインする。ログインは`ssh アカウント名@サーバー名`とする。

```sh
ssh username@server.example.org
```

サーバー名は別途知らせる。


## known_hosts

これまでに接続したことがないサーバに接続しようとすると、以下のような表示が出る。
例えばgithub.comに接続確認をしてみる。

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

を伝えた上で、接続するか？と聞いている。ここで`yes`を入力すると、

```sh
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
Hi kaityo256! You've successfully authenticated, but GitHub does not provide shell access.
```

と、`github.com`を「接続したことがあるホスト」のリストに追加したことが表示される。この「接続したことがあるホスト」のリストは、`.ssh/known_hosts`に保存される。

`known_host`に保存されているホストのフィンガープリントを表示するには、`ssh-keygen -l`を使う。

```sh
$ ssh-keygen -l -f ~/.ssh/known_hosts | grep github
256 SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU github.com (ED25519)
3072 SHA256:uNiVztksCsDhcc0u9e8BujQXVUpKZIDTMczCvj3tD2s github.com (RSA)
256 SHA256:p2QAMXNIC1TJYWeIOttrVc98/R1BUFWu3/LiyKgUfQM github.com (ECDSA)
```

3つの鍵が表示されたが、そのうちED25519の鍵のフィンガープリントが

```txt
SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU
```

であることがわかる。これは先程の表示と一致する。

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

ほとんどないことであるが、もし研究室サーバの再インストールなどで鍵が変わってしまった場合、`.ssh/known_hosts`を一度削除してから再度接続すれば、新たにフィンガープリントを保存しなおしてくれる。

## SSHエージェント転送の設定

SSHでリモートサーバにアクセスする場合、一般的に公開鍵認証を用いる。これは、ローカルマシンにある秘密鍵と、ログインしたサーバに登録した公開鍵を突き合わせることで「確かにこの公開鍵を登録した人がアクセスしている」と認証する仕組みだ。SSH公開鍵認証は、GitHubへのアクセスにも用いられる。実際には公開鍵認証はわりと複雑なことをしているのだが、とりあえずは「公開鍵に対応する秘密鍵を持つ人が、正当なアクセス権を持つ人と認証している」と思えばよい。

![公開鍵認証](fig/publickey.png)

秘密鍵は、認証したい人が持つ鍵で、文字通り秘密にしなければならない。一般には、秘密鍵を「パスフレーズ」と呼ばれる文字列を使って暗号化する。「パスワード認証」とは異なり、「パスフレーズ」は秘密鍵の暗号化を解くのに用いられ、ネットワークを流れることはない。パスフレーズをつけないこともできるのだが、個人的にはパスフレーズ無しの秘密鍵は推奨できないので、なるべく長いパスフレーズをつけるようにして欲しい。

さて、いま「リモートサーバに公開鍵でアクセスし、そのリモートサーバからGitHubにアクセスしたい」と思ったとしよう。いわゆる「多段SSH」もしくは「踏み台サーバ」という状態である。なお、既にローカルPCからGitHubには公開鍵認証でアクセスできる(公開鍵が登録してある)ものとする。

![踏み台SSH](fig/fumidai.png)

この時、最も単純には、リモートサーバに秘密鍵と公開鍵のペアを生成し、公開鍵をGitHubに登録することが考えられる。さらに手抜きをして、リモートサーバにローカルと同じ秘密鍵を置いてしまえばGitHubに登録する公開鍵はそのままで良い。いずれも、リモートサーバでもう一度パスフレーズを入力すれば、多段SSHできる。

![案1](fig/plan_1.png)
![案2](fig/plan_2.png)

しかし一般論として、リモートサーバに秘密鍵を置くことは避けた方が良い。IPアドレスが公開されているリモートサーバは、ローカルマシンに比べて外部からの攻撃を受けやすい。万が一、リモートサーバがハックされた際、そこに秘密鍵があると、リモートサーバからアクセスしていた別のサーバも攻撃されることがある。

実際にそのような事件が起きたことがある。あるユーザのスパコンアカウントが(おそらくキーロガーにより)クラックされた。クラックされたスパコンは被害が少なかったのだが、このスパコンに「パスフレーズ無しの秘密鍵」が置いてあり、攻撃者はそこを踏み台に別のスパコンにログインすることができた。そして別のスパコンのセキュリティホールをついて特権昇格に成功し、複数のスパコンが運用停止に追い込まれたことがある。パスフレーズにより暗号化されていても、原理的には時間をかければ解析できるため、リモートサーバには原則として秘密鍵を置かないようにしたい。

さて、リモートサーバには秘密鍵を置きたくないが、多段SSHを行うためには秘密鍵が必要だ。そこで、SSHにはエージェント転送という機能がある。これは、ローカルマシンの秘密鍵の情報を、リモートサーバに持っていき、リモートサーバから別のサーバに接続する際にそれを使う機能だ。以下、SSHエージェント転送を使ってGitHubにアクセスする。

![SSHエージェント転送](fig/ssh-agent.png)

## SSHエージェントの設定

MacとWindowsで設定方法が異なる。

### Macの場合

Macの場合は、デフォルトでSSHエージェントが起動している。ターミナルのホームディレクトリで

```sh
ssh-add
```

を実行せよ。秘密鍵のパスフレーズを聞かれるので、入力せよ。その後、研究室サーバにsshで接続してみよ。パスフレーズを聞かれずに接続できたら成功である。

パスフレーズは、Macのキーチェインに保存される。これはログアウトされると消えるため、必要な時に毎回`ssh-add`の実行が必要となる。

ターミナルを開いた時に自動でパスフレーズを聞かれるようにしたい場合は、`.bashrc`の最後に以下の記述を追加しておく。

```sh
ssh-add
```

こうするとターミナルを開くたびに(まだ入力していなければ)パスフレーズを聞かれるようになる。必要な時に`ssh-add`を実行するか、`.bashrc`に記述してしまうかはお好みで。

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

## 多段SSH

上記の手順では、SSHエージェントに秘密鍵の情報を覚えさせることで、一度`ssh-add`実行時にパスフレーズを入力したら、次回よりパスフレーズの入力を省略できるものである。それだけでも便利であるが、以下ではエージェント転送により、多段SSHを実行してみよう。

まず、GitHubに手元のPCの公開鍵を登録しよう。

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


GitHubに公開鍵の登録が済んだら、研究室サーバに`-A`オプションをつけてSSHで接続せよ。

```sh
ssh username@name.of.server -A
```

その後、GitHubに公開鍵認証が通るか確認しよう。

```sh
ssh -T git@github.com
```

パスフレーズを聞かれずに、

```txt
Hi (GitHubアカウント名)! You've successfully authenticated, but GitHub does not provide shell access.
```

という表示が出たら認証に成功だ。
