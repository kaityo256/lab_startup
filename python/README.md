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

```sh
python3 -m pip install numpy matplotlib
```

### Jupyter Notebookのインストール

Pythonの開発ではJupyter Notebookを使うと便利だ。以下でインストールしよう。

```sh
python3 -m pip install --upgrade pip
python3 -m pip install jupyter
```

Jupyter Notebookはブラウザ上でPythonを実行する環境であり、普通に実行すると自動でブラウザが開かれるが、WSL上で使うには少々工夫がいる。まず、Jupyter Notebookを、ブラウザなしモードで起動する。

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

このうち、`http://localhost:8888`ではじまる行(`token=...`を含む)をブラウザのURLにコピペするとJupyter Notebookが開かれるので、右上の「New」ボタンから「Python 3」を選ぶ。

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

### Python3のインストール

まずはPython3をインストールしよう。

```sh
brew install python3
```

Python3がインストールされたら、必要なパッケージをいれておこう。

```sh
python3 -m pip install numpy matplotlib
```

### Jupyter Notebookのテスト

次に、Jupyter Notebookをインストールしよう。

```sh
python3 -m pip install --upgrade pip
python3 -m pip install jupyter
```

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
