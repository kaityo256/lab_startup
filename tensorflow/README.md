# TensorFlowでFashion-MNISTを学習させてウェブで読み込む

Fashion-MNISTというデータセットがある。MNISTは手書き数字だが、そのファッション版だ。このデータセットをTensorFlowを使ってニューラルネットに学習させ、そのデータをエクスポートし、ウェブで読み込んで、自分の描いた絵をニューラルネットに判定させてみよう。

## 環境設定

以下ではPython3の仮想環境を使う。WSLでは事前に以下を実行しておく必要がある。

```sh
sudo apt-get install python3-venv
```

まず、[kaityo256/fashion_mnist_check](https://github.com/kaityo256/fashion_mnist_check)をフォークしてからcloneせよ。ローカルでも研究室サーバでもかまわない。この際、sshでcloneすること。

```sh
cd github
git clone git clone git@github.com:youraccount/fashion_mnist_check.git
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

正しくTensorFlowがインストールされていれば学習が進み、最終的に以下のような出力がされるはずである。

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

ただし、JavaScriptはセキュリティのため、デフォルトではローカルに保存されたファイルにアクセスできない。回避する方法もあるのだが、ここではそのままGitHubにアップロードし、GitHub Pagesでウェブサイトとして公開することでアクセスしよう。

まず、作成されたディレクトリ`model`をリポジトリに追加する。

```sh
git add model
```

その後、commit、pushしよう。

```sh
git commit -m "adds model"
git push
```

## GitHub Pagesの公開

GitHubの、自分のリポジトリを見てみよう。ブラウザをリロードすると、`model`が追加されているはずである。この状態でSettingsをクリックする。

左のメニューに「Pages」という項目があるのでそこを選ぶ。

GitHub Pagesの「Source」のところが「None」になっているので、クリックして「main」を選んで「Save」を選ぶ。

![settings](fig/github_pages.png)

すると、GitHub Pagesのところに「Your site is ready to be published at https://youraccount.github.io/fashion_mnist_check/.」という文章が表示されるので、「数分待ってから」アクセスする。

以下のような画面が出てきたら成功だ。

![Fashion-MNIST Check](fig/fashion_mnist_check.png)

左に何か絵を描くと、それを28 x 28ピクセルに変換したデータが右に表示され、さらにそのデータを784次元のベクトルとして訓練済みニューラルネットに食わせた結果、その絵が何であるかを判定してくれる。

![result](fig/result.png)

上記の例では、サンダルと判定された。
