# ParaViewの使い方

VMDは原子や粒子、すなわち「つぶつぶ」を可視化するためのツールだ。しかし、粒子数が増えてくると、全ての粒子を可視化するのは現実的ではない。そこで、空間を小さなセルに区切って「場の量」にすることが多い。「場の量」とは、温度や密度、速度場といったスカラー量、ベクトル量を、位置の関数として表現することだ。以下では、そんな「場の量」を可視化するParaViewというソフトウェアを使ってみよう。

## インストール

[https://www.paraview.org/](https://www.paraview.org/)に行き、「Download」をクリックする。

![Download](fig/download.png)

Nightlyではなく、その時点での最新版(本記事執筆時はv5.8)を選ぶと良いだろう。

Windowsの場合は、拡張子がexeで終わっており、かつMPI版ではないもの(本記事執筆時では`ParaView-5.8.0-Windows-Python3.7-msvc2015-64bit.exe`)を選ぶ。

![Windows](fig/windows_download.png)

Macの場合は、パッケージ版(拡張子がpkg)を選ぶと良いであろう。

![Mac](fig/mac_download.png)

直接インストーラで起動すると怒られる場合があるが、パッケージファイルを右クリックして出てきたメニューで「開く」を選べばインストールできるはずである。

インストール後、実行すると、 「Startup Screen」が現れる。不要なら「Don't show tihs window again」にチェックして「Close」すると、次回から現れなくなる。

以上でインストール完了だ。

## VTKファイルの構造

ParaViewは非常に多くの可視化ができる。このParaViewにデータを食わせる方法はいくつかあるが、最も簡単なのはVTKレガシーフォーマット(Visualization Toolkit Simple Legacy Format)を使うことだ。VTKレガシーフォーマットとは、「レガシー」の名前があることからわかるように現在ではXML形式のデータを使うことが推奨されているのだが、構造が非常に単純なのでプログラムから出力しやすい。

以下では、VTKレガシーフォーマットの構造を簡単に解説しよう。フォーマットの仕様は以下から参照できる。

[http://www.vtk.org/VTK/img/file-formats.pdf](http://www.vtk.org/VTK/img/file-formats.pdf)

### ファイルの構造

VTKファイルは、例えばこんな構造をしている。

```txt
# vtk DataFile Version 1.0
test
ASCII
DATASET STRUCTURED_POINTS
DIMENSIONS 21 21 21
ORIGIN 0.0 0.0 0.0
SPACING 1.0 1.0 1.0

POINT_DATA 9261

SCALARS intensity float
LOOKUP_TABLE default
0
0
0
0
(以下データが続く)
```

1. 最初の行はファイルのバージョン情報。大文字小文字は区別し、バージョンをあらわす数字x.x以外の場所はこの通りに記述する必要がある。
2. 次がファイルの名前。最大256文字。適当に書けばよいと思うが、個人的にはファイル名をここに記述している。
3. 次がファイルフォーマット。ASCIIかBINARYを記述する。ここではASCIIフォーマットのみ説明する。
4. 次がデータセットの構造。いくつか種類があるが、本稿では構造格子(Structured Grid)と非構造格子(Unstructured Grid)のみ扱う。
5. 最後がデータセット。点データ(POINT_DATA)とセルデータ(CELL_DATA)がある。

### 構造格子

ファイルの最初の三行がヘッダーで、四行目からデータ構造の記述になる。もっとも簡単なデータ構造は「構造格子(Structured Grid)」だ。

TODO: 続きを書く

## 可視化のサンプル

では、さっそく可視化をしてみよう。まずはサンプル用のリポジトリ`kaityo256/paraview-sample`をクローンする。後でpushするわけではないので、httpsでクローンして良い。

```sh
cd github
git clone https://github.com/kaityo256/paraview-sample.git
```

クローンしたらそのディレクトリに移動しておこう。

```sh
cd paraview-sample
```


### Simple

最初は最も簡単な構造格子(Structured Grid)のボリュームレンダリングをしてみよう。

ディレクトリ`simple`に`simple.py`があるので実行せよ。

```sh
cd simple
python simple.py
```

同じディレクトリに`simple.vtk`ができたはずだ。これをParaViewで開こう。

まずParaViewを起動し、Ctrl+O(もしくはFile→Open)で`simple.vtk`を開く。すると、Pipeline Browserに「simple.vtk」が追加され、目が閉じたアイコンが表示されたはず。この状態で「Properties」の「Apply」をクリックせよ。Pipeline Browserの「simple.vtk」の左にあるアイコンの目が開いたはずだ。

![simple-open](fig/simple_open.png)

次に、「Outline」となっている表示を「Volume」に変える。最初の実行で「Volumeレンダリングには時間がかかるが良いか？」と聞かれることがあるが、「わかったからもう聞かないで」を選ぶこと。

![simple-volume](fig/simple_volume.png)

ぼんやりと浮かぶ球体が表示されれば成功だ。

* Volumeを選んだ時に「Yes, and don't ask again」を選ぶ
