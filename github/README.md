# GitHubのアカウント作成と基本的な操作

## GitHubとは

GitHubは、Gitのホスティングサービスの一つである。Gitはローカルだけでも利用可能だが、リモートリポジトリを用意することで、どこからでもアクセスできたり、他の人と共同で開発したりすることができる。このリモートリポジトリの「置き場所」を提供するのがGitHubだ。GitHubはリモートリポジトリの置き場所を提供するのみならず、開発に便利な様々な機能を備えている。また、通常利用の範囲内においては無料である。最初は無料利用ではプライベートリポジトリ(自分だけが見ることができるリポジトリ)を作ることができず、全て公開リポジトリとなっていたが、現在では無料枠でプライベートリポジトリも作ることがでｋりうようになった。

本研究室では、原則としてプログラムの開発やドキュメントの執筆をGitHub上で行う。以下では、GitHubのアカウントの作成と、簡単な操作方法の確認をしておこう。

## アカウントの作成

まず[https://github.com/](https://github.com/)でアカウントを作成しよう。ユーザー名、メールアドレス、パスワードを入力して「Signup for Githup」を選ぶ。

ユーザー名は、今後長く使う可能性があるのでよく考えておこう。場合によっては本名よりも有名になる可能性もある。メールアドレスは、普段使うアドレスを設定しておく。このアドレスは公開されない(公開することもできる)。

パスワードは使いまわしをせず、ここでGitHub専用に新しく作成すること。LastPassがインストール済みなら、アイコンをクリックし、「Generate Secure Password」を選ぶことでパスワードを生成できる。

![パスワード生成](fig/generate_password.png)

パスワードマネージャを利用しているのならいちいちパスワードを覚える必要は無いので、なるべく長くて複雑なパスワードを使おう。最低でも12文字あると良い。

最初に「Verify Your Account」という画面でパズル認証があるので解く。

![パズル認証](fig/verify_account.png)

パズル認証を解いたら「Next: Select a plan」で次に進み、「Choose Free」をクリック。

最後にアンケートがあるので、適当に回答してから「Complete Setup」を押す。すると、先ほど登録したメールアドレスに確認メールが送られてくるので、メール中の「Verify email address」ボタンをクリックする。

すると「What do you want to do first?」と聞いてくるので「Skip this for now」をクリック。これでアカウントが作成され、次回からは、「Sign in」からユーザー名とパスワードでログインできるようになる。

![Sign in](fig/sign_in.png)

## 多要素認証

多くのサービスが「GitHubでログイン」という方法を用意している。これは、「認証をGitHubに任せるよ」という意味だ。具体的にはOAuthという技術を使っている(興味のある人は調べてみよ)。逆に言えば、多くのサービスがGitHubアカウントに依存することになるので、GitHubアカウントが乗っ取られてしまうと、芋づる式に別のサービスのアカウントも乗っ取られてしまうことになる。したがって、GitHubアカウントはしっかり守る必要がある。そこで、GitHubも多要素認証で守ることにしよう。

GitHubにログインした状態で、右上のアイコンをクリックするとメニューが現れるので「Settings」を選ぶ。

![Settings](fig/settings.png)

左にある「Personal settings」メニューの「Settings」をクリックし、現れた画面の左の「Security」の画面の下の「Enable two-factor authentification」をクリックする。再度パスワードを聞かれるので入力すること。

![Enable Two-Factor](fig/enable_two_factor.png)

多要素認証の方法として、アプリケーションを使った認証と、SMS(ショートメッセージ)を使った認証から選べる。ここではGoogle Autheticatorを使うため、アプリケーションを使った認証(Set up uusing an app)を選ぶ。

![多要素認証のセットアップ](fig/setup_using_app.png)

すると、次の画面で「1. Recovery codes」という画面が出てくる。これは、スマホをなくした、壊れた等の理由で二段階認証ができなくなった時の「緊急避難」用のコードである。ダウンロードして保存しておくのと同時に、LastPassの「Note」にも保存しておこう。LastPassのアイコンをクリックし、「Open My Vault」でLastPass管理画面を開く。そして、右下にある「+」マークをクリックすると「Add Item」画面が出てくるので「SECURE NOTE」を選ぶ。Nameは、例えば「GitHub Recovery Code」として、内容にリカバリコードをコピペして「Save」を押して保存しよう。

![LastPassにリカバリーコードを保存](fig/lastpass_note.png)

ローカルPCとLastPassにリカバリコードを保存したら、「Next」を押して次に進む。すると「2. Scan this barcode with your app.」という画面になり、二次元コードが出てくる。これをGoogle Authenticator (Google認証システム)で読み取ろう。スマホでGoogle Authenticatorを起動し、右下の赤い「+」をクリック、「バーコードをスキャン」を選んでカメラを起動、このコードを読み取ろう。もしスマホのカメラが壊れている場合は「提供されたキーを入力」することもできる。その場合は、「enter this text code」をクリックすると、「キー」が表示されるので、それをスマホに入力する。正しく入力すると、Google認証システムにGitHubの認証が追加される。いま追加されたアカウントに表示されている六桁の数字をGitHubに入力してEnableを押す。以下のような画面が表示されれば、二段階認証の設定完了である。

![二段階認証完了](fig/two_factor_enabled.png)

以後、GitHubにログインするとき、パスワードと数字を要求されるようになる。パスワードはLastPassが入力してくれるので、6桁の数字だけ入力するようにしよう。

## SSHの設定

GitHubのサーバはネットワークの向こう側にある。従って、そこと通信を行うためには、ネットワークの設定をしなければならない。GitHubとの通信にはSSH (Secure Shell)と呼ばれる仕組みを使うため、まずはその設定をしよう。

WindowsならGit Bash、Macならターミナルを開いて、ホームディレクトリ(`cd`を入力したら移動するディレクトリ)にて`ssh-keygen -t rsa`を実行せよ。

```sh
$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/watanabe/.ssh/id_rsa):　#ここはそのまま改行で良い
Created directory '/c/Users/watanabe/.ssh'.
Enter passphrase (empty for no passphrase): # ここはパスフレーズを入力すること
Enter same passphrase again: # もう一度同じパスフレーズを入力
Your identification has been saved in /c/Users/watanabe/.ssh/id_rsa
Your public key has been saved in /c/Users/watanabe/.ssh/id_rsa.pub

```

最初に鍵の置き場所を聞かれるが、これはデフォルトのままで良い。次に秘密鍵の「パスフレーズ」を聞かれる。これは「なし」にもできるのだが、必ず設定すること。パスフレーズはLastPassなどで生成して、Secure Note等に保存しておこう。

完了したら、ホームディレクトリに`.ssh`というディレクトリが作成され、その中に`id_rsa`と`id_rsa.pub`というファイルが作成されたはずである。

```txt
.ssh
├── id_rsa
└── id_rsa.pub
```

このうち、`id_rsa`が「秘密鍵」、`id_rsa.pub`が「公開鍵」である。この公開鍵をGitHubに置き、手元に「秘密鍵」を置くことで、「自分がGitHubにアクセスできる権利を持っている」ことを証明する。

では、GitHubに公開鍵を登録しよう。GitHubの右上のアイコンをクリックし、開いたメニューから「Settings」を選ぶ。現れた左のメニューから「SSH and GPG keys」を開くと、以下のような画面が現れるはずだ。

![SSH Keys](fig/ssh_and_gpg_keys.png)

まだ公開鍵を一つも登録していないので「There are no SSH keys associated with you account.」と表示されている。ここで「New SSH key」をクリックしよう。すると、TitleとKeyの入力画面になる。

Titleは「どのPCの鍵であるか」を自分で区別するためのものなのでなんでも良い。例えば「研究室のMac Book」などで良い。

Keyに公開鍵を入力する。ターミナルで

```ssh
cat .ssh/id_rsa.pub
```

を実行すると、例えば以下のように「ssh-rsa」から始まる表示がされるはずである(環境によって表示内容が異なる)。

```txt
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4/wWKWxcmPu6ygGXdGk6IQZsH5JxSbRfakGZ1KQDbZJo91r8H8khjpBPOxrNkji75i2I6yPu9YjhaloR5Pzck2HMmjj6Ko7zBpiwNACy/7r7ECcUGcpEFArcD+72riZof4MGstyGy0jQKMDZxyjaFYpF5Gn7sfjCVNtfvRDrniFpF57+827CywuwpscZSUy63DvQ+L5yUrgL1Xh8hNpktzrO4hpXiYzl19g/j79AeHoZwrjxT3Q2Ul7rZTWps2IRkKtrz6lLx4ReyNeu1Jjg+A/c/Oo/gKhJwXpImVBwwkyi3MYX4GyLZ+6Vx07TgdvxC9ZRFEzuFIHYWERej3yaYAXnSVkcbWAP4dD4gD7AbwIiTUnTwyhTBHn3a1d7D8+IFIyQUZPVp7PBRhsst/VYUUVv1N2ZaTonC3cPsWSdCyGSQU+Gxwig0MzXCLHO8VAeyQ3W1OPekBa23B6yPza0W9DKIXuztMeVlCPaOS4RIfGWl75YxJrmV+6af1oBj0Us= watanabe@DESKTOP-TB4E5C4
```

これは改行が入らず、一行であることに注意。これを(途中で改行が入らないように)コピペして、GitHubの「Key」のところに貼り付ける。

![鍵の追加](fig/add_key.png)

ここで、間違えて「秘密鍵」を貼り付けないこと。公開鍵は`ssh-rsa`という文字列から始まる一行のファイルだが、秘密鍵は`-----BEGIN RSA PRIVATE KEY-----`という文字列から始まる、複数行のファイルである。

以下のような画面になったら正しく登録されている。

![鍵の追加完了](fig/key_added.png)

公開鍵の登録は、GitHubにアクセスするパソコンごとに行う。今後、別のマシンでGitHubにアクセスしたくなったら、そのマシンで秘密鍵、公開鍵のペアを作成し、同様な手続きでGitHubに公開鍵を登録すること。

## リポジトリの作成とクローン

