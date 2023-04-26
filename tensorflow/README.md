# TensorFlowでFashion-MNISTを学習させてウェブで読み込む

Fashion-MNISTというデータセットがある。MNISTは手書き数字だが、そのファッション版だ。このデータセットをTensorFlowを使ってニューラルネットに学習させ、そのデータをエクスポートし、ウェブで読み込んで、自分の描いた絵をニューラルネットに判定させてみよう。

## 環境設定

以下ではPython3の仮想環境を使う。WSLでは事前に以下を実行しておく必要がある。

```sh
sudo apt-get install python3-venv
```

まず、[kaityo256/fashion_mnist_check](https://github.com/kaityo256/fashion_mnist_check)をhttpsでcloneせよ。

```sh
cd github
git clone https://github.com/kaityo256/fashion_mnist_check.git
```

cloneできたら、そこに移動しよう。

```sh
cd fashion_mnist_check
```

仮想環境を構築し、activateし、tensorflowとtensorflowjsをインストールする。

```sh
python3 -m venv tf  
source tf/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install tensorflow tensorflowjs
python3 -m pip install protobuf==3.20.*
```

仮想環境は`deactivate`で出ることができる。次回からは同じディレクトリで

```sh
source tf/bin/activate
```

を実行すれば、既にtensorflowとtensorflowjsがインストールされた環境に入ることができる。

## 学習とエクスポート

まず、データを学習させよう。機械学習の定番データといえば、手書き数字認識のMNIST(Modified National Institute of Standards and Technology)データセットだが、今回使うデータは「Fashion-MNIST」と呼ばれるもので、10種類の衣類を区別するものだ。

![Fashion-MNIST](fig/fashion-mnist.png)

これは28ピクセル x 28ピクセルの白黒画像である。各ピクセルは0から255までの輝度を持っているが、これを0から1までの実数に変換し、784次元の一次元ベクトルにしてニューラルネットに食わせて学習させる。

このデータはウェブに公開されているため、ダウンロードから学習まで一発でできる。まずはニューラルネットを学習させ、その結果を保存しよう。以下を実行せよ。

```sh
python3 train.py
```

正しくTensorFlowがインストールされていれば学習が進み、最終的に以下のような出力がされるはずである(出力される数字の詳細は異なる)。

```txt
Test accuracy: 0.8709999918937683

Predictions for zero input
[0.08157011 0.00318779 0.02768737 0.05093732 0.00741246 0.71254516
 0.07637644 0.02599602 0.01260033 0.00168701]

Model was saved.
```

最後の「Predictions for zero input」とは、全てがゼロ、すなわち「真っ黒な画像」が入力された時のニューラルネットの出力である。後でデバッグに用いる。

この結果、実行したディレクトリに以下のファイルが保存されている。

* `model.data-00000-of-00001`
* `model.index`

次に、このデータを読み込んで、TensorFlow.js用のデータをエクスポートする。以下を実行せよ。

```sh
python3 export.py
```

TensorFlow.jsが正しくインストールされていれば、以下のような出力になるはずだ。

```sh
Predictions for zero input
[0.08157011 0.00318779 0.02768737 0.05093732 0.00741246 0.71254516
 0.07637644 0.02599602 0.01260033 0.00168701]

Model was exported.
```

この結果、実行したディレクトリに`model`というディレクトリができており、その中に以下のようなファイルが作成されているはずである。

```txt
model
├── group1-shard1of1.bin
└── model.json
```

これをJavaScriptから読み込んで、自分で絵を書いて判定させてみよう。

ただし、JavaScriptはセキュリティのため、デフォルトではローカルに保存されたファイルにアクセスできない。そこで、ローカルのhttpサーバを起動することでそれを回避する。

まず、このリポジトリをカレントフォルダとしてVSCodeを起動せよ。

```sh
code .
```

VSCodeの拡張機能から「Live Server」を検索し、インストールせよ。

![liveserver](fig/liveserver.png)

そして、ファイルエクスプローラーからリポジトリにある`index.html`を選択し、右下のバーにある「Go Live」ボタンを押す。

以下のような画面が出てきたら成功だ。

![Fashion-MNIST Check](fig/fashion_mnist_check.png)

左に何か絵を描くと、それを28 x 28ピクセルに変換したデータが右に表示され、さらにそのデータを784次元のベクトルとして訓練済みニューラルネットに食わせた結果、その絵が何であるかを判定してくれる。

![result](fig/result.png)

上記の例では、サンダルと判定された。

## TensorFlowのインストールに失敗する場合

手順で

```sh
python3 -m pip install tensorflow tensorflowjs
```

を実行したときに、

```txt
no matching distribution found for tensorflow
```

と出て実行できないことがある。これはPythonのバージョンが新し過ぎて、対応するパッケージを見つけられない時に起きる。この時、Pythonのバージョンを落とすと実行できる可能性がある。

まず、現在仮想環境に入っている場合は外に出よう。

```sh
deactivate
```

現在のPythonのバージョンを確認しよう。

```sh
$ python3 -V 
Python 3.9.12
```

今は3.9.12が入っている。

複数のPythonのバージョンを管理するため、pyenvをインストールする。

```sh
brew install pyenv
```

インストールが済んだら、以下の行をホームディレクトリの`.bashrc`の最後に追記する。

```sh
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

その後、`.bashrc`を再読み込みする。

```sh
source .bashrc
```

次に、pyenv経由でPython 3.8.10をインストールする。

```sh
pyenv install 3.8.10
```

インストールできたことを確認しよう。

```sh
$ pyenv versions
* system (set by /Users/username/.pyenv/version)
  3.8.10
```

3.8.10が追加されていればインストールされている。

さて、先程cloneしたディレクトリに入ろう。

```sh
cd github/fashion_mnist_check
```

先程作成した仮想環境をクリアする。

```sh
python3 -m venv --clear tf 
```

このディレクトリ(`github/fashion_mnist_check`)でのみ、Pythonのバージョンを落としたいので、pyenvにlocal指定でバージョンを指定する。

```sh
pyenv local 3.8.10
```

すると、このディレクトリでのみ、Pythonのバージョンが3.8.10に変わる。

```sh
$ python3 -V
Python 3.8.10
```

これは、ローカルに`.python-version`というファイルが作成され、pyenvがそれを見ているからだ。

```sh
$ cat .python-version
3.8.10
```

さて、Pythonのバージョンが3.8.10の状態で仮想環境をactivateする。

```sh
source tf/bin/activate
```

後は同様に以下を実行する。

```sh
python3 -m pip install --upgrade pip
python3 -m pip install tensorflow tensorflowjs
```

`Requirement already satisfied: pip in ./tf/lib/python3.8/site-packages (21.1.1)`などと実行され、Python 3.8用のパッケージがインストールされることがわかる。

後はローカルで

```sh
python3 train.py
python3 export.py
```

が実行できるはずだ。
