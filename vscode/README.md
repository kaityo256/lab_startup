# VSCodeのインストール

Visual Studio Code、通称VSCodeは、Microsoftが中心となって開発を進めているオープンソースのエディタである。Windows/Mac/Linuxで動作するクロスプラットフォームであり、豊富なプラグインがあるためにユーザが増えている。以下ではVSCodeのインストールと、VSCodeからPythonを実行する環境まで構築する。なお、自分の好きな開発環境があるならそれを使ってよい。

## Windows編

### ダウンロードとインストール

[https://code.visualstudio.com/](https://code.visualstudio.com/)に行って、「Download for Windows Stable Build」をダウンロード、インストールする。

途中で「追加タスクの選択」が現れたら、「ファイルコンテキストメニュー」と「ディレクトリコンテキストメニュー」に「「Codeで開く」アクションを追加する」がチェックされていることを確認し、もしされていなかったらチェックしておく。

![セットアップ](fig/vscode_setup_win.png)

「デスクトップ上にアイコンを作成する」は、どちらでもかまわない。

### WSLとの連携

Windowsマシンでは、原則としてWindows Subsystem for Linux (WSL)上で作業を行う。VSCodeは、WindowsでもWSL上でもシームレスに利用できるが、そのためにプラグインを入れておく必要がある。

VSCodeの左のメニューからExtentionsのアイコン(ブロックのマーク)をクリックし、現れた検索窓に「wsl」と入力するとMicrosoftによるWSL拡張「WSL」が表示されるので、「Install」をクリックする。

![WSL](fig/wsl.png)

これをインストールした状態で、WSLのターミナルから適当なディレクトリで

```sh
code .
```

を実行する。VS Codeが開いて、左下に「WSL:Ubuntu」と表示されれば成功だ。

![WSL-VSCode](fig/wsl_vscode.png)

以降、WSLのファイルをシームレスにVS Codeで編集できるようになる。

## Mac編

[https://code.visualstudio.com/](https://code.visualstudio.com/)に行って、「Download for Mac Stable Build」をダウンロード、インストールする。

ダウンロードフォルダに「VSCode-darwin-stable.zip」がダウンロードされるので、クリックして解凍する。解凍されてできた「Visual Studio Code」を、アプリケーションフォルダに移動する。例えば「ダウンロード」を「Finderで開く」を選び、「Visual Studio Code」を「アプリケーション」にドラッグする。

![VSCodeのインストール](fig/vscode_install_mac.png)

VSCodeを起動する。「アプリケーション」から「Visual Studio Code」を起動する。今後よく使うので、Dockに追加しておこう。

## 設定(Windows/Mac共通)

### 日本語化

VSCodeの左のメニューからExtentionsのアイコン(ブロックのマーク)をクリックし、現れた検索窓に「Japanese」と入力すると、「Japanese Language Pack for Visual Studio Code」が現れるのでインストールする。インストール後、右下に「Change Language and Restart」というボタンが現れるので、クリックするとVSCodeが再起動し、メニューなどが日本語化される。

### シェルコマンド`code`のインストール

ファイルを開く時、メニューから探しても良いが、ターミナルから

```sh
code filename
```

として開けるようにしておくと便利だ。この機能を使うにはコマンドパレット(Shift+Command+P)を開いて「shell command」と入力すると出てくる「Shell Command: Install 'code' command in PATH」を実行すれば良い。

![shellcommand](fig/shellcommand.png)

VSCodeではファイルではなくディレクトリを開くことが多い。カレントディレクトリをVSCodeで開くには

```sh
code .
```

とする。よく使うので覚えておこう。このとき、最初に以下のような「このディレクトリを信用するか？」という確認ダイアログが出ることがある。

![trust](fig/trust.png)

自分で作成し、管理しているディレクトリであれば問題ないので、「開く」を選んでよい。

### Python環境のセットアップ

適当なディレクトリで

```sh
code test.py
```

を実行せよ。新規ファイルとして`test.py`が開かれるはずだ。すると「Pythonにおすすめの拡張機能があるがインストールするか？」と聞かれるので、インストールする。聞かれなかった場合は、VSCodeの左のメニューからExtentionsのアイコン(ブロックのマーク)をクリックし、現れた検索窓に「python」と入力、現れた「Python extension for Visual Studio Code」の「install」ボタンを押して、インストールする。「再読み込みが必要です」というボタンに変わったら、クリックして再読み込みをする。

この時、先にPython環境が正しくインストールされていれば、エディタの右下に「Python」といった表示が現れているはずだ。

Pythonの実行環境が選ばれた状態で

```py
print("Hello Python")
```

と入力し、右上にある三角のマーク(ターミナルでPythonを実行)をクリックせよ。

![実行ボタン](fig/vscode_python_execute.png)

下にウィンドウが開いて実行結果(`Hello Python`)が表示されるはずだ。これでVSCodeからPythonを実行する環境が整った。

## Remote-SSHのインストールと接続。

注：ターミナルで研究室サーバにssh接続できることが前提。

1. 拡張機能から、「Remote - SSH」をインストールする。
2. Shift+Ctrl+P/Shift+CMD+Pで、コマンドパレットを表示し、「Remote-SSH: ホストに接続する」を選ぶ。
3. 「+ 新規SSHホストを追加する」を選択し、研究室サーバへの接続コマンド(ssh username@hostname -AY)を入力
4. 「更新するSSH構成ファイルを選択」では、Macなら`/Users/username/.ssh/config`、Windows(WSL)なら`C:\Users\username\.ssh\`を指定。
5. 接続時、Select the platformと出てきたらLinux
6. フィンガープリントを確認し、問題なければ「続行」

WindowsでWSLから実行している場合、上記の「続行」を押した後「接続を確立できません」と出てくるので、「リモートを閉じる」を実行後、ターミナルから以下を実行する。

```sh
cd .ssh
cp id_rsa /mnt/c/Users/username/.ssh
```

そして、「Remote-SSH: ホストに接続する」を選ぶと、先程追加したサーバがリストに表示されるので、それを選ぶ。するとパスフレーズを要求されるので、入力すると接続できる。