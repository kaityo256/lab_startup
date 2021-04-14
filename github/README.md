# GitHubのアカウント作成と基本的な操作

## GitHubとは

GitHubは、Gitのホスティングサービスの一つである。Gitはローカルだけでも利用可能だが、リモートリポジトリを用意することで、どこからでもアクセスできたり、他の人と共同で開発したりすることができる。このリモートリポジトリの「置き場所」を提供するのがGitHubだ。GitHubはリモートリポジトリの置き場所を提供するのみならず、開発に便利な様々な機能を備えている。また、通常利用の範囲内においては無料である。最初は無料利用ではプライベートリポジトリ(自分だけが見ることができるリポジトリ)を作ることができず、全て公開リポジトリとなっていたが、現在では無料枠でプライベートリポジトリも作ることができるようになった。

本研究室では、原則としてプログラムの開発やドキュメントの執筆をGitHub上で行う。以下では、GitHubのアカウントの作成と、簡単な操作方法の確認をしておこう。

## GitHubのセットアップ

### アカウントの作成

まず[https://github.com/](https://github.com/)でアカウントを作成しよう。ユーザー名、メールアドレス、パスワードを入力して「Signup for GitHub」を選ぶ。

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

### 多要素認証

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

### SSHの設定と公開鍵の登録

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

また、SSHエージェントを用いて鍵を覚えさせておこう。ホームディレクトリで

```sh
ssh-add
```

と入力して、パスフレーズを入力しておけば、以後、Macなら再ログインまで、WSLならターミナルを閉じるまで、SSHのパスフレーズを聞かれなくなる(必要になったら自動で入力される)。

## GitHubの操作

### リポジトリの作成とクローン

では、実際にGitHubと通信して、データのやり取りをしてみよう。

まずはGitHub上でリポジトリを作成して、ローカルに取ってくる(clone)してみよう。

まず、GitHubのホーム画面を表示しよう。GitHubの左上のネコのようなアイコンをクリックすると、ホームに戻ることができる。

![リポジトリを新規作成](fig/create_new_repository.png)

ホーム画面に戻ったら「Create repository」を押してリポジトリを新規作成しよう。

![リポジトリの設定](fig/new_repository.png)

リポジトリの新規作成画面では、以下の項目を設定しよう。

* Repository name: リポジトリの名前。Gitでアクセスするので、英数字だけにしよう。ここでは`test`としておく。
* Descrption: リポジトリの説明(任意)。ここは日本語でも良いが、とりあえず「test repository」にしておこう。
* Public/Private: ここで「Public」を選ぶと、全世界の人から見ることができるリポジトリとなる。とりあえずは「Private (自分だけがアクセスできる)」を選んでおこう。
* Initialize this repository with: リポジトリを作成する際に一緒に作るもの。ここをチェックすると自動で作ってくれる。ここでは、「Add a README file」と「Choose a license」をチェックしよう。「Choose a license」をクリックすると選択性が現れるが、ここでは「MIT License」を選んでおこう。

以上の設定をして「Create repository」をクリックすると、リポジトリが作成され、以下のような画面が表示される。

![新規作成されたリポジトリ](fig/test_rep.png)

このリポジトリは`README.md`と`LICENSE`という二つのファイルが最初に登録され、`initial commit`というコミットメッセージでコミットされた状態になっている。

このリポジトリを、ローカルマシンにクローンしてみよう。

右にある「↓ Code」をクリックし、「SSH」をクリックする。

![Use SSH](fig/use_ssh.png)

すると、下に`git@github.com:アカウント名/test.git`という表示がされるので、これをコピーする(右にあるコピーボタンを押しても良い)。

次に、ローカルマシンのターミナルで、`github`ディレクトリを作り、その下にリポジトリをクローンしよう。以下を実行してみよう。

```sh
cd
mkdir github
cd github
git clone git@github.com:アカウント名/test.git
```

すると、パスフレーズを要求されるので、先ほど設定した秘密鍵のパスフレーズを入力しよう。正しく公開鍵が登録されていたらクローンできるはずだ。

### ローカルの修正とpush

手元にクローンしたリポジトリを修正し、GitHubに修正をpushしてみよう。

まず、クローンしたリポジトリの`README.md`を修正しよう。先ほどクローンされた`test`に移動し、VSCodeで`README.md`を開こう。

```sh
cd test
code README.md
```

すると、以下のような内容が表示されるはずだ。

```sh
# test
test repository
```

ここで内容を修正してみよう。

```md
# test
test repository

Hello GitHub
```

この状態で、`README.md`の修正を`git add`して`git commit`しよう。ターミナルで以下を実行せよ。

```sh
git add README.md
git commit -m "modifies README.md"
```

これでローカルの「歴史」は、GitHubが記憶している「歴史」よりも先に進んだ。歴史を見てみよう。

```sh
$ git log --oneline
be064a8 (HEAD -> master) modifies README.md
083bc2d (origin/master, origin/HEAD) Initial commit
```

なお、左に表示されるコミットハッシュ(`be064a8`等)は環境によって異なる。

ローカルのリポジトリにはコミットが二つあるが、GitHubにはまだコミットが一つしかない。この「新しくなった歴史」をGitHubに教えよう。ターミナルで以下を実行せよ。

```sh
git push
```

パスフレーズを聞かれるので入力せよ。これでローカルの修正がリモート(GitHub)に反映された。もう一度ブラウザでGitHubのリポジトリを見てみよう。ブラウザをリロードしてみよ。ローカルの変更が反映されたはずだ。

![修正されたリポジトリ](fig/modified_readme.png)

下に表示されている`README.md`の内容が変更されている。`README.md`のコミットメッセージが「modified README.md」になっていることもわかる。

以上で、「GitHubでリポジトリを作成し、ローカルにクローンする」作業が完了した。以上の作業をまとめると以下のようになる。

![Flow1](fig/github_flow1.png)

### ローカルで作成したリポジトリをGitHubにpush

次に、ローカルで作成したリポジトリをリモートにpushする作業を試してみよう。

ローカルのターミナルで、`github`ディレクトリの下に、`test2`というディレクトリを作ろう。

```sh
cd
cd github
mkdir test2
cd test2
```

ここでまた`README.md`ファイルを作ろう。

```sh
code README.md
```

`README.md`の内容はなんでも良いが、たとえば以下の内容として保存しよう。

```md
# test2

2nd repository
```

この状態で、Gitリポジトリとして初期化し、最初のコミットをしよう。

```sh
git init
git add README.md
git commit -m "initial commit"
```

さて、このリポジトリをGitHubに登録する。まず、GitHubのホーム画面の左上の「Repositories」の右にある「New」をクリックしよう。

![New](fig/test2_new.png)

Repository nameは`test2`、Descriptionは無くても良いが、とりあえず`2nd repository`としておこう。また、今回もPrivateリポジトリとする。

それ以外はデフォルトのまま、すなわち`README.md`も作らず、ライセンスファイルも追加しないまま`Create repository`をクリックする。

![Create test2](fig/test2_create.png)

すると、先ほどとは異なり、全くファイルを含まない空のリポジトリが作成される。

![Empty Repository](fig/test2_empty.png)

そこには「次にすべきこと」がいくつか書いてあるが、ここでは「既に存在するリポジトリをpushする(push an existing repository from the command line)」を選びたいので、そこに書かれているコマンド、

```sh
git remote add origin git@github.com:アカウント名/test2.git
git branch -M main
git push -u origin main
```

を、先ほどのリポジトリ(`test2`ディレクトリの中)で実行する。右にある「コピー」ボタンをクリックすると、コマンド内容がコピーされるので、ターミナルに貼り付けて実行しても良い。実行すると、ローカルで作成されたリポジトリが、GitHubに作られた空のリポジトリにコピーされる。

この状態で、もう一度GitHubの当該リポジトリを見てみよう。ブラウザをリロードせよ。リポジトリに`README.md`が作成された状態になるはずだ。

以上の操作をまとめると、以下のようになる。

![Flow 2](fig/github_flow2.png)

GitHubでリポジトリを作ってからローカルにcloneした場合は、ローカルは「リモートリポジトリはどこにあるか」、すなわち「どこにpushすれば良いか」の情報を知っている。しかし、ローカルでリポジトリを作った場合、ローカルリポジトリは「どこにpushすれば良いか」がわからない。従って、まずその場所を教えてやらなければならない。

先ほどの

```sh
git remote add origin git@github.com:アカウント名/test2.git
git branch -M main
git push -u origin main
```

という操作は、

1. `git@github.com:アカウント名/test2.git`というリポジトリに`origin`という名前をつけて保存する。
2. ローカルのブランチ名を`main`に変更する
3. 先ほど名前をつけた`origin`というリポジトリに`main`ブランチを`push`する。その際、この`main`ブランチと`origin`を紐づける(`-u`オプション)

ということをやっている。

以上で、ローカルで作成したリポジトリをGitHubに登録することができた。

今後、ローカルとGitHubのどちらでリポジトリを作っても良いが、慣れるまではとりあえずローカルでリポジトリを作成・作業し、必要になったらGitHubに登録するのが良いだろう。

## Issueの管理

### ITS

Gitでは、原則としてメインブランチで作業をしない。これから作業をする内容によってブランチを作成し、そのブランチ上で作業し、完成したらメインブランチにマージする、という作業を繰り返すことで開発をすすめる。それぞれの作業に対応するブランチを作業ブランチ(トピックブランチ)と呼ぶ。

一般に、必要な作業は複数同時に発生する。このとき、どのタスクを実行中で、どのタスクが手つかずか、タスク管理をしたくなる。原則としてタスクと作業ブランチは一対一に対応するのであるから、それらをツールで一度に管理したくなるのは自然であろう。それがGitHubのissueである。

GitHubを使う場合、

* これから行う作業をissueに登録する。
* 登録されたissueのうち、これから手をつけるissueに対応した作業ブランチを作成する
* 作業ブランチで作業し、修正をコミットする
* メインブランチにマージする

という流れで開発をすすめる。issueとは「課題」という意味であり、一般に課題を管理するシステムをIssue Tracking System (ITS)と呼ぶ。一種のTodo リストだと思えば良い。GitHubはITSの機能を持っている。

### Issueの作り方

では、既存のリポジトリでissueを作ってみよう。GitHubのページで、先ほど作った`test`リポジトリに移動し、以下の作業をせよ。

* 上のタブから「Issues」をクリックし、「New Issue」ボタンを押す。
* Titleに「READMEの修正」と書く
* コメントに「内容を追加」と書く。
* Labelsとして「enhancement」を選ぶ。

こんな画面になったはず。

![new_issue](fig/new_issue.png)

以上で「Submit new issue」を押すとissueが作成され、「READMEの修正 #1」というタイトルがついたはずだ。この「#1」がissue番号であり、後で使う。

![issue open](fig/issue_open.png)

この画面は後で使うので、そのままブラウザを閉じないこと。

次にローカルのリポジトリで、このissueに対応するブランチを作成する。ブランチの命名規則には様々な流儀があるが、先ほどつけたラベル、issue番号、そして修正内容を含めるのが一般的だ。ここではディレクトリ型の命名規則を採用しよう。ディレクトリ型の命名規則では「ラベル/issue番号/内容」という名前のブランチを作成する。今回、「enhancement」というラベルをつけたが、これは「新しい機能(feature)を追加する」という意味なので、「feat」とする。あとはissue番号1番、READMEの修正なので、全てまとめて`feat/1/README`というブランチを作ることにする。

```sh
$ git co -b feat/1/README
Switched to a new branch 'feat/1/README'
```

このブランチ上で、`README.md`に一行追加しよう。

```md
# test
test repository

Hello GitHub
modifies README
```

コミットする時に、`closes #1`というメッセージにする。シャープ`#`を忘れたり、全角にしたり、数字との間に空白を挟んだりしないこと。

```sh
git add README.md
git commit -m "closes #1" 
```

修正を`main`に取り込もう。

```sh
$ git checkout main
$ git merge feat/1/README 
Updating a6b44f4..bfefb58
Fast-forward
 README.md | 1 +
 1 file changed, 1 insertion(+)
```

以上の修正をpushする。pushする前に、先ほどのissueの画面をブラウザで表示しておくこと。

```sh
git push
```

先程のissueの画面を見てみよう。push後に自動的にissueが閉じられたはずだ。

![issue closed](fig/issue_closed.png)

このように、`fixes`、`closes`といった動詞と`#1`のような形でissue番号が含まれたコミットメッセージを含むコミットがpushされると、GitHubがそれを検知して自動的に対応するissueを閉じてくれる。

不要になったブランチは消しておこう。

```sh
$ git branch -d feat/1/README
Deleted branch feat/1/README (was bfefb58).
```

## Projectの利用

issueには「open (未完了)」と「closed (完了)」の二状態しかないが、issueが増えてくると、いまどのissueがどういう状態なのかをより細かく管理したくなる。例えば未完了と完了の間に、「作業中」という状態が欲しくなる。このような状態を管理するのがProjectだ。以下では、もっとも基本的なProjectであるKanbanを使ってみよう。

GitHubのリポジトリの「Projects」タブから、「Create a project」をクリックし、現れた画面で以下を設定する。

* 「Project board name」は「カンバン」
* 「Description 」も「カンバン」
* 「Project template」は「Automated Kanban」

![kanban](fig/kanban_new.png)

設定が済んだら「Create project」ボタンでProjectを作成しよう。こんな画面になるはずだ。

![kanban created](fig/kanban_created.png)

デフォルトで「To do (未完了)」「In progress (作業中)」「Done (完了)」の三つのカラムがある。「To do」にいくつか項目があるが、これは「カード」と呼ばれる。「カンバン」とは、「看板」のことで、トヨタの生産管理法「カンバン方式」に由来する。

カンバン方式では、タスクを「カード」で管理し、看板に貼り付けたり、別の看板に移動させたりすることで管理する。最初からTo doにあるカードは不要なので、それぞれのカードの右上にある「・・・」マークから「Archive」を選んでアーカイブしてしまおう。

さて、このProjectは、issueと連動している。新しくissueを作ってみよう。上のタブから「Issues」をクリックし、「New Issue」ボタンを押し、Titleに「READMEの修正」と書く。ラベルは先ほどと異なるもので試したいので、「documentation」を選ぼう。

次にコメントを書くのだが、Issuesのコメントは、他のissueを参照したり、チェックボックスをつけたりする機能があるので試してみよう。コメントに以下のような内容を記述せよ。

```md
- [ ] 修正1 (#1 に追加)
- [ ] 修正2
```

ここで「#」と数字の間には空白をいれず、「#1」の後には半角空白を入れるのをわすれないこと。

この状態で「Preview」タブをクリックすると、以下のようにチェックボックスになるはず。

![issue preview](fig/issue_preview.png)

このチェックボックスをクリックするとチェックがつき、このissueのサブタスクを管理することができるが、ここでは扱わない。そういうことができる、ということだけ知っておくと良い。

また、`#1`がリンクになっている。このように、関連するissueなど、別のissueを参照したい場合、GitHubで`#1`などのように`#`に続けてissue番号を書けばリンクが作成される。

次に「Projects」をクリックし、先ほど作った「カンバン」を選択しよう。

以上の作業が終わったら、「Submit new issue」をクリックし、issueを作成せよ。なお、Projectやラベルはissueを作成した後でも設定、変更が可能だ。

issueが作られたら「Projects」タブから「カンバン」を選んで見てみよう。いま作ったissueがカードになり、「To do」に追加されているはずだ。

![kanban added](fig/kanban_added.png)

一般には、To doには多数のやるべきことが積んである。大量のカードに気が滅入りつつ、気合を入れて一つ選んで作業をはじめよう。ここではTo doにカードが一つしかないので、それをマウスでドラッグして「In progress」に移動しよう。

「In progress」とは「作業中」の意味だ。タスクをここに移動したら、対応するブランチを作ろう。ラベルがドキュメント、issue番号が2番、内容がREADMEの修正なので、`doc/2/README`としよう。ターミナルで以下を実行せよ。

```sh
$ git co -b doc/2/README
Switched to a new branch 'doc/2/README'
```

また`README.md`を修正しよう。以下の一行を追加せよ。

```md
# test
test repository

Hello GitHub
modifies README
Hello Kanban
```

ファイルを保存したら、今度は`fixes #2`というメッセージでコミットする。

```sh
git add README.md
git commit -m "fixes #2"
```

また`main`ブランチに戻って、修正を取り込もう。まだpushしないこと。

```sh
git checkout main
git merge doc/2/README
```

ここで、`git merge d`まで入力したら、タブ補完が効くはずである。

マージが終了したら、先ほどの「カンバン」の画面を見よう。まだカードは「In progress」にある。

![kanban in progress](fig/kanban_inprogress.png)

ブラウザでこの画面を表示したまま、ターミナルで`git push`しよう。

```sh
git push
```

issueがとじると同時に、カードが自動的に「In progress」から「Done」に移ったはずだ。

![kanban done](fig/kanban_done.png)

このように、カンバンとissueを連動して管理することができる。

Automated Kanbanを利用すると、作成したissueは自動的に「To do」に登録される。そして、あるissueに関連する作業を開始する時に、issueをTo doからIn progressに移動すると同時に対応するブランチを作成し、閉じたissueに対応するブランチを消すようにしていると、「In progress」にあるカードの数とトピックブランチの数が一致するので、いろいろ確認がしやすくなって便利である。

カンバンの使い方やブランチの命名規則、issueの管理方法などは人によって異なるので、いろいろ試して自分にとって便利な方法を見つけて欲しい(ただし、開発チームに所属した場合は、そのチームのルールに従うこと)。
