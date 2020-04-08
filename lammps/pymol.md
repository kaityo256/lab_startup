次に、サンプルディレクトリをコピーしよう。

```sh
cp -r /usr/local/Cellar/lammps/2020-03-03/share/lammps/examples/ellipse .
```

長いが、タブ補完を駆使すれば入力が楽になるだろう。

できた`ellipse`ディレクトリに入って、lammpsを実行しよう。

```sh
cd ellipse
lmp_serial < in.ellipse.gayberne
```

いろいろ表示されて、最後に

```txt
Total # of neighbors = 3096
Ave neighs/atom = 7.74
Neighbor list builds = 46
Dangerous builds = 0

Please see the log.cite file for references relevant to this simulation

Total wall time: 0:00:01
```

といった表示が出れば実行は成功だ。

### 入力ファイルの修正

次に、入力ファイルを修正しよう。ターミナルで`in.ellipse.gayberne`があるディレクトリがカレントディレクトリになっている状態で、

```sh
code in.ellipse.gayberne
```

と入力すると、VSCodeで`in.ellipse.gayberne`が開かれるはず。もし`command not found`と言われたら、まずVSCodeを開き、Shift+Command+Pで「コマンドパレット」を開いて「shell」で検索して「シェルコマンド: PAHT内にVS Codeをインストールします (Shell Command: Install code command in PATH)」を選択し、実行する。その後、再度先程の命令を実行すると、VSCodeで`in.ellipse.gayberne`が開かれるはず。

VSCodeでin.ellipse.gayberneを開いたら、以下の行を探す。

```sh
#dump	     1 all custom 100 dump.ellipse.gayberne &
#	     id type x y z c_q[1] c_q[2] c_q[3] c_q[4]
```

この二行の行頭の`#`を削除して保存しよう。

```sh
dump	     1 all custom 100 dump.ellipse.gayberne &
	     id type x y z c_q[1] c_q[2] c_q[3] c_q[4]
```

この状態で、またlammpsを実行しよう。

```sh
lmp_serial < in.ellipse.gayberne 
```

すると、今度は同じディレクトリに`dump.ellipse.gayberne`ができているはず(`ls`で確認しよう)。

これは原子の起動を保存したファイルで、これを後からPyMolで読み込んで可視化する。

### PyMolのインストール

本当はVMDを使う予定だったのだが、最新のMacでVMDが動かないことがわかったので、とりあえずPyMolでしのぐことにする。

[ここ](https://pymol.org/2/)からmacOSのディスクイメージをダウンロードし、PyMolをアプリケーションにコピーしてインストールせよ。

その後PyMolを起動すると、Activationについて聞いてくるので、とりあえず「Skip Activation」を選ぶ(30日間の試用期間に入る)。

次に、LammpsのdumpファイルをPyMolのファイルに変換する。ターミナルで以下のディレクトリに移動せよ。

```sh
cd /usr/local/Cellar/lammps/2020-03-03/share/lammps/tools/pymol_asphere/src
```

そこで

```sh
make
```

を実行すること。すると、実行可能ファイルができるので、それをパスが通ったところにシンボリックリンクを作ろう。

```sh
cd /usr/local/bin 
ln -s /usr/local/Cellar/lammps/2020-03-03/share/lammps/tools/pymol_asphere/bin/asphere_vis
```

次に、色ファイルを設定する。先程、シミュレーションを実行したディレクトリに移動して、`colors.ellipse`ファイルを作成しよう。

```ls
cd
cd lammps
cd ellipse
code colors.ellipse
```

VSCodeが開き、`colors.ellipse`が新規作成されたはずだ。ファイルの中身は以下のように記入せよ(最後の改行を忘れないこと。全体で3行になる)。

```txt
1 marine 0.7 1
2 red 1.0 3 1 1

```

上記を保存したら、ターミナルで以下を実行せよ。

```sh
asphere_vis colors.ellipse dump.ellipse.gayberne ellipse.py -r 4 -o
```

以下のように出力されたら成功だ。

```txt
Read in 2 atom types from flavor_file.
Wrote 41 frames to output file.
```

もし、以下のように「1 atom」しか認識されなかった場合、最後の改行を忘れているので、再度ファイルを修正すること。

```txt
Read in 1 atom types from flavor_file.
Wrote 41 frames to output file.
```

このスクリプトにより`ellipse.py`が作成されたはずである(`ls`で確認せよ)。

PyMolの「File」「Run Script」から、先程作成した`ellipse.py`を選んで実行すると、こんな画面が表示されるはずだ。

![PyMol](fig/pymol_ellipse.png)

この状態で右上にある「Play」をクリックすると、アニメーションが表示されるはずである。