# VSCodeのインストール

Visual Studio Code、通称VSCodeは、Microsoftが中心となって開発を進めているオープンソースのエディタである。Windows/Mac/Linuxで動作するクロスプラットフォームであり、豊富なプラグインがあるためにユーザが増えている。以下ではVSCodeのインストールと、VSCodeからPythonを実行する環境まで構築する。なお、自分の好きな開発環境があるならそれを使ってよい。

## Windows編

### ダウンロードとインストール

[https://code.visualstudio.com/](https://code.visualstudio.com/)に行って、「Download for Windows Stable Build」をダウンロード、インストールする。

途中で「追加タスクの選択」が現れたら、「ファイルコンテキストメニュー」と「ディレクトリコンテキストメニュー」に「「Codeで開く」アクションを追加する」がチェックされていることを確認し、もしされていなかったらチェックしておく。

![セットアップ](fig/vscode_setup_win.png)

「デスクトップ上にアイコンを作成する」は、どちらでもかまわない。

インストール後、VSCodeを起動する。

### Python環境のセットアップ

VSCodeを起動する。例えばWindows 10なら左下の検索窓から「Visual Studio Code」として検索すれば見つかるはず。

VSCodeの左のメニューからExtentionsのアイコン(ブロックのマーク)をクリックし、現れた検索窓に「python」と入力、現れた「Python extension for Visual Studio Code」の「install」ボタンを押して、インストールする。「再読み込みが必要です」というボタンに変わったら、クリックして再読み込みをする。

Pythonのプラグインがインストールされたら、「ファイル」から「新規作成」を選ぶ(もしくはCtrl+Nを押す)。「Untitled-1」のようなファイル名でウィンドウが開かれるため、「保存(Ctrl+S)」を選んで、適当な場所に`test.py`という名前で保存する。

この時、先にPython環境が正しくインストールされていれば、エディタの左下に「Python 3.8.5. 64-bit」といった表示が現れるはずだ。

Pythonの実行環境が選ばれた状態で

```py
print("Hello Python")
```

と入力し、右上にある三角のマーク(ターミナルでPythonを実行)をクリックせよ。

![実行ボタン](fig/vscode_python_execute.png)

下にウィンドウが開いて実行結果(`Hello Python`)が表示されるはずだ。

### WSLとの連携

Windowsマシンでは、原則としてWindows Subsystem for Linux (WSL)上で作業を行う。VSCodeは、WindowsでもWSL上でもシームレスに利用できるが、そのためにプラグインを入れておく必要がある。

VSCodeの左のメニューからExtentionsのアイコン(ブロックのマーク)をクリックし、現れた検索窓に「WSL」と入力すると「Remote-WSL」が表示されるので、「Install」をクリックする。

![WSL](fig/wsl.png)

これをインストールした状態で、WSLのターミナルから適当なディレクトリで

```sh
code .
```

を実行する。VS Codeが開いて、左下に「WSL:Ubuntu」と表示されれば成功だ。

![WSL-VSCode](fig/wsl_vscode.png)

以降、WSLのファイルをシームレスにVS Codeで編集できるようになる。

## Mac編

### ダウンロードとインストール

[https://code.visualstudio.com/](https://code.visualstudio.com/)に行って、「Download for Mac Stable Build」をダウンロード、インストールする。

ダウンロードフォルダに「VSCode-darwin-stable.zip」がダウンロードされるので、クリックして解凍する。解凍されてできた「Visual Studio Code」を、アプリケーションフォルダに移動する。例えば「ダウンロード」を「Finderで開く」を選び、「Visual Studio Code」を「アプリケーション」にドラッグする。

![VSCodeのインストール](fig/vscode_install_mac.png)

VSCodeを起動する。「アプリケーション」から「Visual Studio Code」を起動する。今後よく使うので、Dockに追加しておこう。

VSCodeの左のメニューからExtentionsのアイコン(ブロックのマーク)をクリックし、現れた検索窓に「python」と入力、現れた「Python extension for Visual Studio Code」の「install」ボタンを押して、インストールする。「再読み込みが必要です」というボタンに変わったら、クリックして再読み込みをする。

Pythonのプラグインがインストールされたら、「ファイル」から「新規作成」を選ぶ(もしくはCtrl+Nを押す)。「Untitled-1」のようなファイル名でウィンドウが開かれるため、「保存(Ctrl+S)」を選んで、適当な場所に`test.py`という名前で保存する。

この時、先にPython環境が正しくインストールされていれば、エディタの左下に「Python 3.7.6. 64-bit ('base':conda)」といった表示が現れるはずだ。

Pythonの実行環境が選ばれた状態で

```py
print("Hello Python")
```

と入力し、右上にある三角のマーク(ターミナルでPythonを実行)をクリックせよ。

![実行ボタン](fig/vscode_python_execute.png)

下にウィンドウが開いて実行結果(`Hello Python`)が表示されるはずだ。これでVSCodeからPythonを実行する環境が整った。
