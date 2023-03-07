# SSHの設定

## SSH公開鍵の作成

ターミナルのホームディレクトリで、`ssh-keygen`コマンドを実行せよ。

```txt
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/watanabe/.ssh/id_rsa): (1.)
Created directory '/home/watanabe/.ssh'.
Enter passphrase (empty for no passphrase): (2.)
Enter same passphrase again: (3.)
```

1. コマンドを実行すると、まず鍵のペアを保存する場所の確認をする。Windowsなら`/home/ユーザー名/.ssh/id_rsa`、Macなら`/Users/ユーザー名/.ssh/id_rsa`などとなるはずだ。ここでは単にエンターキーを押せば良い。
2. パスフレーズを入力する。これは普段使うパスワードで良い。キー入力しても何も表示されないので注意。入力が終わったらエンターキーを押す。
3. パスフレーズを再入力する。入力が終わったらエンターキーを押す。一致していない場合は「Passphrases do not match.  Try again.」と言われてやり直しになる。

パスフレーズを二回入力し、それが一致したら以下のような画面になるはず。

```txt
Your identification has been saved in /home/watanabe/.ssh/id_rsa
Your public key has been saved in /home/watanabe/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:g76VjkiuoPB3Pxvu2UV6P8oaj4XOmAULqOOy4Zeyu1M watanabe@DESKTOP-TB4E5C4
The key's randomart image is:
+---[RSA 3072]----+
|                 |
|                 |
|                 |
|     . .         |
|    . o S   .    |
|   E . . = +     |
|+ + o . = = +    |
|=B *...*.X O ..  |
|oB@oo.ooXo*.+... |
+----[SHA256]-----+
```

これは、今回作成した秘密鍵が`/home/watanabe/.ssh/id_rsa`に、公開鍵が`/home/watanabe/.ssh/id_rsa.pub`に保存されたよ、というメッセージだ。

この状態で、公開鍵を表示しよう。`cat .ssh/id_rsa.pub`を実行せよ。

```sh
$ cat .ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXSYL6KWq92VWEUObU9BKoknPQ/wIOjIPSpGdyPQ8KumPALTielmekOGK/gwqLVhOmz2uL6ILSDN1/UnWY9JWbXeMmzPiRmY0DmtgOMzANulqUSUhkcn4qlvX1VSgqyWUXlZKTvxVw2A7+26gAdcM6JmK4MIISGz6LDZsuQSdKWy78ukQ8ke5knSHZ4mVrFitsWVUe/EJVzB7sVXx52/ViVDWcT6/h7EL2DK6p3DcQdthSq0S8gjWaoOB3puFZk0/fMZZkob7f2VhAeNTcvyly+r0eqjdK4aq8N78j0QQ3tP1BleP52yBzXVgEmf6s3pDZbIb2+zOZaqMZaYlq4fPK/Fy+kHbGJQgU3tDK2SG8HvTjPF9nKzY1MFbw4xtA326/jI8sd1vSK3x9nWcPlYhZncHCCbEblXXH6sZ6iFvyrtKqXiLevGd9wk+cyYR6jb+f+smCmd43vq90+Rpvu1cLT18VVmb7UhBL/fJEkjlON8Ef9/O7aPBb75eg51tl+C8= watanabe@DESKTOP-TB4E5C4
```

この`ssh-rsa`から始まる一行のテキストが公開鍵だ。これを希望のアカウント名とともに渡辺に知らせること。なお、`-----BEGIN OPENSSH PRIVATE KEY-----`で始まるテキストは秘密鍵なので他の人に知らせてはならない。

希望アカウント名と公開鍵を知らせたら、渡辺が研究室サーバにアカウントを作って知らせるので、ログインする。ログインは`ssh アカウント名@サーバー名`とする。

```sh
ssh username@server.example.org
```

サーバー名は別途知らせる。

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
/usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa
```

初回起動時にはパスフレーズを聞かれるので入力する。すると、`$HOME/.keychain`にいくつかシェルスクリプトが出来るので、それを実行する。

```sh
source $HOME/.keychain/$HOST-sh
```

これにより、`keychain`が`ssh-agent`を探し、既存のプロセスがあれば接続、なければ起動してくれる。

`keychain`の起動を毎回行うのは面倒なので、`.bashrc`の最後に

```sh
/usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa
source $HOME/.keychain/$HOST-sh
```

と書いておくと良い。Zshなども同様だが、cshやfishは、`$HOST-sh`の`-sh`を`-csh`や`-fish`にすること。

## 多段SSH

上記の手順では、SSHエージェントに秘密鍵の情報を覚えさせることで、一度`ssh-add`実行時にパスフレーズを入力したら、次回よりパスフレーズの入力を省略できるものである。それだけでも便利であるが、以下ではエージェント転送により、多段SSHを実行してみよう。

まず、研究室サーバに`-A`オプションをつけてSSHで接続せよ。

```sh
ssh username@place.of.server -A
```

その後、適当なディレクトリ(例えばgithub)にて、GitHubに自分が公開しているリポジトリをcloneしてみよ。

```sh
mkdir github
cd github
git clone git@github.com:yourname/yourrepository.git
```

パスフレーズの入力を求められずにcloneできれば成功である。なお、研究室サーバでgitのcommitやpushなどの操作をする前に、[Gitの設定](../git/README.md)を参考にユーザ名やメールアドレスの設定をしておくこと。
