# Pytyhonのインストール

PCにPythonをインストールし、VSCodeから実行できるようにする。自分でインストールして使っているPythonがあったり、他に好きなエディタがあれば、以下の記述に関係なくそれを使ってかまわない。

なお、Windows/Macともにログイン名を英語にしておくことを推奨する。もし最初に日本語名でアカウントを作成してしまった場合、新たに英語名のログイン名のアカウントを作成し、そのアカウントに管理者権限を付与して、以降はそのアカウントをメインに使うのが良い。現在は日本語アカウント名のままでもなんとかなるかもしれないが、少なくとも昔はいろいろ不具合が起きたのでおすすめしない。

## Windows編

### Pythonのインストール

aptを使ってPython3をインストールする。

```sh
sudo apt-get update
sudo apt intall python3
```

また、後で必要なパッケージも入れておこう。

```shsudo -
python3 -m pip install numpy matplotlib
```

### Jupyter Notebookのインストール

Pythonの開発ではJupyter Notebookを使うと便利だ。以下でインストールしよう。

```sh
sudo apt install -y jupyter-notebook
```

Jupyter Notebookはブラウザ上でPythonを実行する環境であり、普通に実行すると字度うでブラウザが開かれるが、WSL2上で使うには少々工夫がいる。まず、Jupyter Notebookを、ブラウザなしモードで起動する。

```sh
jupyter notebook --no-browser
```

すると、以下のような表示がされるはずだ。

```txt
    To access the notebook, open this file in a browser:
        file:///home/watanabe/.local/share/jupyter/runtime/nbserver-985-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/?token=e4a7e2efbf7cf61ceb4d11652e8f538f67bc11b9aacdde54
     or http://127.0.0.1:8888/?token=e4a7e2efbf7cf61ceb4d11652e8f538f67bc11b9aacdde54
```

このうち、`http://localhost:8888`ではじまる行をブラウザのURLにコピペするとJupyter Notebookが開かれるので、右上の「New」ボタンから「Python 3」を選ぶ。

![newbook2.png](fig/newbook2.png)

新しいタブが開き、入力待ちになるので、そこで何かプログラムを入力する。例えば

```py
print("Hello Python")
```

と入力し「Shift+Return」もしくは上の「Run」ボタンをクリックする。

![run2.png](fig/run2.png)

セルの真下に「Hello Python」と表示されて、次のセルが入力待ちになれば成功である。これでPythonを実行する環境は整った。

最初に起動した画面の「Quit」を選ぶとJupyter Notebookは終了する。

## Mac編

### Home brewのインストール

もしインストールされていないのなら、まずHome Brewをインストールする。

まず「ターミナル」を開く。Command+Spaceでスポットライトを開き、Terminal.appを選べば起動する。実行したら、今後良く使うのでDockに追加しておこう。ターミナルが開いたら、以下を実行せよ。

```sh
brew
```

「Command not found」と言われたらインストールされていない。インストールするには[https://brew.sh/index_ja](https://brew.sh/index_ja)の指示に従い、ターミナルで以下のコマンドを実行する。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

ターミナルにコピペして実行せよ。途中、パスワードが要求されるので入力すること。Home brewのインストールが終わったら、再度以下を実行せよ。

```sh
brew
```

```txt
Example usage:
  brew search [TEXT|/REGEX/]
  brew info [FORMULA...]
(snip)
Further help:
  brew commands
  brew help [COMMAND]
  man brew
  https://docs.brew.sh
```

などと表示されればインストールできている。もし

```sh
Error: You have not agreed to the Xcode license. Please resolve this by running:
  sudo xcodebuild -license accept
```

というエラーが起きて実行できなかった場合、

```sh
sudo xcodebuild -license accept
```

を実行せよ(パスワードが必要)。

最後にHome Brewを最新版にする。以下を実行せよ(かなり時間がかかる)。

```sh
brew update --force && brew upgrade
```
### Python3のインストール

まずはPython3をインストールしよう。

```sh
brew install python3
```

Python3がインストールされたら、必要なパッケージをいれておこう。

```sh
python3 -m pip install numpy matplotlib
```

#### Jupyter Notebookのテスト

ターミナルから以下を実行せよ。

```sh
jupyter notebook
```

デフォルトのブラウザで、Jupyter Notebookが開かれるので、右上の「New」ボタンから「Python 3」を選ぶ。

![newbook2.png](fig/newbook2.png)

新しいタブが開き、入力待ちになるので、そこで何かプログラムを入力する。例えば

```py
print("Hello Python")
```

と入力し「Shift+Return」もしくは上の「Run」ボタンをクリックする。

![run2.png](fig/run2.png)

セルの真下に「Hello Python」と表示されて、次のセルが入力待ちになれば成功である。これでPythonを実行する環境は整った。

最初に起動した画面の「Quit」を選ぶとJupyter Notebookは終了する。

## VSCodeの設定 (Windows/Mac共通)

VSCodeを開き、左の歯車マークをクリック、もしくは「表示」メニューをクリックし、出てきたメニューから「拡張機能」を選ぶ。

検索窓に「Python」と入力すると、MicrosoftのPythonプラグインが表示されるのでインストールする。

その後、`test.py`というファイルを新規作成する。保存時に「Pythonインタプリタが見つからない」と言われたら、適宜選ぶこと。正しくプラグインがインストールされていれば、右上に緑色の三角形をした実行ボタンが表示されているはず。

例えば

```py
print("Hello Python")
```

と入力し、実行ボタンをクリックすれば、下に画面が開き、`Hello Python`と表示されるはずだ。これでVS CodeからPythonを実行する環境が整った。