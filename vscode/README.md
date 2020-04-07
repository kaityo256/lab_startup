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

この時、先にPython環境が正しくインストールされていれば、エディタの左下に「Python 3.7.6. 64-bit ('base':conda)」といった表示が現れるはずだ。

Pythonの実行環境が選ばれた状態で

```py
print("Hello Python")
```

と入力し、右上にある三角のマーク(ターミナルでPythonを実行)をクリックせよ。下にウィンドウが開いて実行結果(`Hello Python`)が表示されるはずだ。

ただ、ここで

```txt
conda : 用語 'conda' は、コマンドレット、関数、スクリプト ファイル、または操作可能なプログラムの名前として認識されません
```

というエラーが表示される。これを防ぐには「ファイル」→「基本設定」→「設定」を開き、検索窓に「Activate」と入力すると「Python > Terminal: Activate Environment」が見つかるはず。そこの「Activate Python Environment in Terminal created using the Extension.」のチェックを外せば良い。
