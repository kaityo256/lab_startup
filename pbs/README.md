# バッチシステムの使い方

## バッチシステムについて

### バッチ処理とは

限られた計算資源を複数人で使いたいことがある。昔は計算機が非常に高価であり、使いたい時に対話的に使うことができなかった(そうするとアイドルタイムができてもったいないため)。そこで、あらかじめ計算機にやらせたいことをファイルに記述しておき、実行を予約して使われていた。これをバッチ処理、やらせたいことをバッチジョブと呼ぶ。現代においても、スパコンや計算クラスタなどでバッチ処理が行われている。以下では、研究室クラスタでバッチ処理をしてみよう。ここでバッチ処理に慣れておき、将来的にはスパコンを利用することを見据える。

### ジョブスケジューラ

バッチ処理とは、やらせたいことをあらかじめ記述しておき、その実行を依頼する仕組みである。その処理の単位を「ジョブ」と呼ぶ。ジョブの実行をリクエストされた際、空いている計算資源を調べ、どのジョブをどのような順番で実行するのかを決めるのがジョブスケジューラだ。世の中には多数のジョブスケジューラがあるが、研究室クラスタで採用しているのはOpenPBSと呼ばれるスケジューラである。これはPBS(Portable Batch System)のオープン版だ。スパコンなどではそのプロ版であるPBS Proなどが使われている。

### バッチシステム

バッチシステムを利用するには、自分のやりたいことをバッチジョブの形にしなければならない。そのためには、

* (必要なら)実行可能ファイルを用意する
* ジョブスクリプトを書く
* ジョブを投入する

という手続きをする必要がある。

### ジョブスクリプト

バッチシステムは、ジョブスクリプトと呼ばれるスクリプトを記述し、それをジョブスケジューラに登録することで実行を予約する。ジョブスケジューラはジョブスクリプトを見て、このジョブがどのような計算資源をどの程度占有したいかを調べ、どのタイミングでどの計算資源に割り当てるかを決める。ジョブを計算資源に割り当てて実行することを「ジョブのディスパッチ」と呼ぶ。

大勢が使うシステムでは、優先度をつけて「多く使った人は優先度を下げる。まだあまり使っていない人は優先度を上げる」といった処理をする。これを「フェアシェア」と呼ぶ。しかし、研究室クラスタではいわゆる「FIFO」で運用されている。FIFOとは「First-in First-out」の略で、要するに「早い者勝ち」のシステムである。使う際は節度を守って利用すること。

ジョブスクリプトは、シェルスクリプトにジョブスケジューラ用の情報を付加したものだ。例えば以下のようなフォーマットだ。

```sh
#!/bin/bash
#PBS -l nodes=2:ppn=20

cd $PBS_O_WORKDIR

mpirun -np 40 ./a.out
```

ジョブスクリプトはシェルスクリプトなので、`#`以降はコメントである。しかし、いくつか「意味のあるコメント」がある。

最初の行の`#!/bin/bash`は、Shebang(シバン、シェバン)等と呼ばれ、このスクリプトをどのシェル(インタプリタ)で実行するかを指定するものだ。これはジョブスクリプトだけでなく、シェルスクリプト全般で使われる。

次の`#PBS`から始まる行が、ジョブスクリプトとしての情報を持つコメントである。それぞれ、

* `nodes=2` 2ノードを掴みなさい
* `ppn=20` ノードごとに20プロセスを割り当てなさい

という意味だ。

次に、`cd $PBS_O_WORKDIR`でカレントディレクトリを移動している。

### 良く使うコマンド

バッチシステムにおいて、良く使うコマンドは以下の通り。

* qsub
    * ジョブを投入する。投入されたジョブにはJOBIDという通し番号がつけられる。JOBIDは後からジョブの状態を調べたり、ジョブを停止したりするのに用いる。
* qstat
    * ジョブの状態を調べる。オプションなしで、現在のキューの状態が表示される。`qstat -f JOBID`とすることで、実行中のジョブの詳細を知ることができる。
* qdel
    * `qdel JOBID`とすることで、実行中のジョブを削除する。実行中のプログラムが強制停止される。

詳細については、manコマンドをつかうと良い。例えば`qstat`コマンドの詳細を知りたければ`man qstat`で調べることができる。

## ハンズオン

まずは研究室サーバにログインせよ。次に、`github`というディレクトリに移動せよ(なければ`mkdir`で作成せよ)。

```sh
cd github
```

次に、サンプルプログラムをcloneする。

```sh
git clone https://github.com/kaityo256/batch_sample.git
cd batch_sample
```

### 基本的な操作

まずは、簡単なジョブスクリプトを見てみよう。ディレクトリ`hostname`に移動せよ。

```sh
cd hostname
```

ここに、MPIを使った並列プログラムのサンプル`test.cpp`がある。

```cpp
#include <mpi.h>
#include <cstdio>
#include <unistd.h>

int main(int argc, char**argv){
  MPI_Init(&argc, &argv);
  int rank, procs;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &procs);
  char hostname[256];
  gethostname(hostname, sizeof(hostname));
  printf("%02d / %02d at %s\n",rank, procs, hostname);
  sleep(10);
  MPI_Finalize();
}
```

このプログラムは、全プロセス数と、自分のID(ランク)、そして実行されたホストの名前を表示し、最後に10秒待つプログラムだ。まずはこれをビルドしよう。並列プログラムは`mpic++`でコンパイルする。

```sh
mpic++ test.cpp
```

すると、`a.out`が作成されるので実行してみよう。

```sh
./a.out
```

ランク、プロセス数、そしてホスト名が表示されたはずだ。次に、並列実行してみよう。並列実行するためには`mpirun`を用いる。

```sh
mpirun -np 4 ./a.out
```

`mpirun`の`-np`の後に、何プロセスで実行するかを指定する。ここでは4プロセスで実行している。

さて、このプログラムを、バッチジョブとして実行してみよう。ジョブスクリプトは二つ用意してある。まずは、1ノードを占有実行する`test.sh`だ。

```sh
#!/bin/bash
#PBS -l nodes=1:ppn=20

cd $PBS_O_WORKDIR

mpirun -np 20 ./a.out
```

このジョブスクリプトを実行するには、`qsub`コマンドを用いる。

```sh
qsub test.sh
```

`qstat`コマンドによりジョブの状態を見ることができる。

```sh
$ qstat
Job id            Name             User              Time Use S Queue
----------------  ---------------- ----------------  -------- - -----
1254.hostname     test.sh          watanabe          00:00:00 R workq
1255.hostname     test.sh          watanabe          00:00:00 R workq
1256.hostname     test.sh          watanabe                 0 Q workq
1257.hostname     test.sh          watanabe                 0 Q workq
```

ジョブにはジョブIDが振られる。また、誰が投げたか、実行中(R)か、実行待ち(Q)かなどがわかる。

プログラムの標準出力と標準エラーは、ファイルに落とされる。この時、標準出力は「投入したシェルスクリプト名.oジョブID」、標準エラー出力は「投入したシェルスクリプト名.oジョブID」という名前で保存される。

例えば`test.sh`というジョブスクリプトを投入し、Job idが1254であった場合、標準出力は`test.sh.o1254`に、標準エラー出力は`test.sh.e1254`に保存される。

さて、自分の標準出力を見てみよ。実行のタイミングにより、`hostname`が異なるはずである。

次に、2ノード占有ジョブを実行してみよう。

```sh
#!/bin/bash
#PBS -l nodes=2:ppn=20

cd $PBS_O_WORKDIR

mpirun -np 40 ./a.out
```

`nodes=2`で2ノードを使うことを宣言し、`mpirun -np 40`で40プロセス実行することを宣言している。これは2ノードを占有するため、2ノードしかない計算資源では一度に一つしかジョブが走らない。

```sh
qsub test2.sh
```

実行が終わったら、標準出力を見てみよ。40プロセスのうち、20プロセスずつ別のホストで実行されたのがわかるはずだ。

### バルクジョブ

次に、「バルクジョブ」と呼ばれるジョブを実行する。リポジトリの`pi`というディレクトリに移動せよ。

```sh
cd ..
cd pi
```

そこに`cps`というディレクトリがあるはずだ。そこが空であることを確認せよ。

```sh
ls cps
```

実は、このディレクトリはGitのSubmoduleと呼ばれる仕組みで、別のリポジトリを取り込む場所として予約されているが、こちらで指示するまでは空ディレクトリになっている。

では、ここでSubmoduleを更新することで、そのリポジトリをcloneしよう。

```sh
git submodule update -i
```

また`pi`に移動し、`cps`の中身がcloneされたことを確認せよ。

```sh
$ cd pi
$ ls cps
LICENSE  README.md  cps.cpp  makefile  task.sh
```

なお、最初にcloneする際に`--recursive`オプションをつけておくと、サブモジュールも同時にcloneされるため、この工程が不要となる。

```sh
git clone --recursive https://github.com/kaityo256/batch_sample.git
```

Git Submoduleの詳細についてはここでは説明しない。気になった人は各自調べること。

さて、ディレクトリ`pi`には、モンテカルロ法で円周率を計算する`pi.py`がある。このスクリプトを実行すると入力待ちになるので、適当な数字を入力してみよう。その数字を乱数の種(シード)として円周率を計算する。

```sh
$ python3 pi.py
1
3.1420144
```

これを様々な種を与えて並列に計算し、あとで統計処理をすることを考えよう。例えば`seed00.dat`には`0`を、`seed01.dat`には`1`などと、異なるシードをファイルに保存しておき、

```sh
python3 pi.py < seed00.dat > result00.dat
python3 pi.py < seed01.dat > result01.dat
python3 pi.py < seed02.dat > result02.dat
python3 pi.py < seed03.dat > result03.dat
python3 pi.py < seed04.dat > result04.dat
...
```

といった計算を延々やりたい。これらのプログラムには全く依存関係がないから、同時に実行することができる。このようなジョブを自明並列(Trivial Parallelization)、別名「馬鹿パラ」と呼ぶ。

同じディレクトリに`makeseed.py`があるので実行せよ。

```sh
python3 makeseed.py
```

すると、`seed00.dat`から`seed18.dat`、そして`task.sh`が作成されたはずだ。`task.sh`には、並列実行したいタスクがずらずら記載されている。

このタスクを並列実行するために作った手抜きプログラムがCPS(Command Processor Scheduler)である。まずはビルドしよう。

```sh
cd cps
make
```

これで`cps`というプログラムができたはずだ。これは、やりたいことが一行に一つ書かれたスクリプトを読み込んで、適当に並列実行するプログラムだ。

先ほどのディレクトリ`pi`に戻ろう。

```sh
cd ..
```

ここに、`cps`を使って並列実行をするジョブスクリプト`pi.sh`がある。

```sh
#!/bin/bash
#PBS -l nodes=1:ppn=20

cd $PBS_O_WORKDIR
hostname
mpirun -np 20 ./cps/cps task.sh
```

さっそく投入してみよう。

```sh
qsub pi.sh
```

間違えて`task.sh`などを投入しないように気をつけよう。実行が終わったら、標準出力を見てみよ。実行されたホスト名が表示されているはずだ。これは`pi.sh`の中で`hostname`を実行しているためだ。

`cps`は、実行ログを`cps.log`というファイルに保存する。見てみよう。

```sh
$ cat cps.log
Number of tasks : 19
Number of processes : 20
Total execution time: 39.713 [s]
Elapsed time: 2.1 [s]
Parallel Efficiency : 0.995313

Task list:
Command : Elapsed time
python3 pi.py < seed00.dat > result00.dat : 2.098 [s]
python3 pi.py < seed01.dat > result01.dat : 2.087 [s]
python3 pi.py < seed02.dat > result02.dat : 2.098 [s]
python3 pi.py < seed03.dat > result03.dat : 2.086 [s]
python3 pi.py < seed04.dat > result04.dat : 2.089 [s]
python3 pi.py < seed05.dat > result05.dat : 2.087 [s]
python3 pi.py < seed06.dat > result06.dat : 2.098 [s]
python3 pi.py < seed07.dat > result07.dat : 2.077 [s]
python3 pi.py < seed08.dat > result08.dat : 2.098 [s]
python3 pi.py < seed09.dat > result09.dat : 2.086 [s]
python3 pi.py < seed10.dat > result10.dat : 2.1 [s]
python3 pi.py < seed11.dat > result11.dat : 2.086 [s]
python3 pi.py < seed12.dat > result12.dat : 2.097 [s]
python3 pi.py < seed13.dat > result13.dat : 2.065 [s]
python3 pi.py < seed14.dat > result14.dat : 2.092 [s]
python3 pi.py < seed15.dat > result15.dat : 2.086 [s]
python3 pi.py < seed16.dat > result16.dat : 2.096 [s]
python3 pi.py < seed17.dat > result17.dat : 2.088 [s]
python3 pi.py < seed18.dat > result18.dat : 2.099 [s]
```

全部で何個のタスクがあり、トータル何秒だったか、実際には何秒で実行できたか等が表示されている。

また、同じディレクトリに`result00.dat`から`result18.dat`までファイルができているはずだ。一つ見てみよう。

```sh
$ cat result01.dat
3.1420144
```

`result01.dat`は、乱数の種として「1」を入力した結果だ。先程Pythonで直接実行した時と同じ値が出ていることを確認せよ。乱数を使う計算では、「同じ乱数の種からは同じ結果が出る」という事実は覚えておきたい。Pythonの`random`モジュールは、デフォルトで乱数の種が固定されないため、実行される度に異なる結果を返す。これは「ランダムネス」という意味では良いが、数値計算においてはデバッグの障害となる。乱数を使うプログラムでは、乱数の種を指定しておく癖をつけておくこと。

さて、あとはこれらのファイルを集計するだけだ。Pythonを使うならこんなスクリプトになるだろう。

```py
import glob
import numpy as np

data = []
for filename in glob.glob('result*.dat'):
  with open(filename) as f:
    a = f.readlines()[0]
    data.append(float(a))

average = np.average(data)
error = np.std(data)

print(f"{average} +- {error}")
```

実行してみよう。

```sh
$ python3 average.py
3.1416488 +- 0.0006905991052778619
```

上記の手続き、すなわち

* 入力を受け取ってなにかを出力するシリアルプログラムを用意する
* 入力をたくさん用意する
* 馬鹿パラで実行する

というのは、非常に単純ながら効果的な手法なので覚えておくと良い。
