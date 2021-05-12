# GNU Makeの使い方

make(メイク)は、ビルドツールと呼ばれるソフトウェアで、その名の通り、主にプログラムのビルドの自動化に使われる。プログラムは、通常、複数のコンポーネントから構成されている。これらのコンポーネントには「あるファイルを修正したら、このファイルとこのファイルをビルドしなおさなければならない」といった「依存関係」がある。一般に「〇〇したら〇〇しなければならない」もしくは「〇〇する前には〇〇しなければならない」といった状況は危険信号だ。依存関係が複雑になったら、自分の修正がどこまで波及するのかがわかりにくくなり、必ずミスが起きる。そのため、依存関係を認識し、ソフトウェアを正しくビルドするためのツールがビルドツールだ。makeは古典的なビルドツールで、better makeとしてのCMake、RubyによるRakeや、PythonのSConsなど、多くのビルドツールがあるが、まずはmakeを使えるようになってみよう。makeにも方言があるが、ここでは広く使われているGNU Makeの使い方を学ぶ。

## makeの基本的な使い方

makeは、makefileというファイルに「ルール」と呼ばれる **依存関係** と**処理**をまとめたもの記述する。

```makefile
ターゲット: 依存するファイル1 依存するファイル2...
    コマンド
```

という形になる。ルールは

* ターゲット：このルールが作りたいもの
* 依存ファイル： ターゲットを作る際に必要なもの
* コマンド：必要な物が全て揃った後に実行されるコマンド

から構成される。

まずは、簡単なmakefileを書いてみよう。まずは`github`ディレクトリに入り、練習用のリポジトリ`kaityo256/make_tutorial`をcloneせよ。

```sh
cd github
git clone https://github.com/kaityo256/make_tutorial.git
```

cloneできたら、リポジトリの`hello`というディレクトリに入ろう。そこには`hello.txt`というテキストファイルが置いてある。

```sh
$ cd make_tutorial
$ cd hello
$ cat hello.txt
Hello Make!
```

この`cat hello.txt`をmakeにやらせてみよう。vim で`makefile`を開き、以下の内容を入力せよ

```makefile
all:
    cat hello.txt
```

これは

* `all`というターゲットを作るルールで
* `all`には何も必要なファイル(依存関係)などはなく
* コマンドは`cat hello.txt`である

というルールである。

記述の際、以下の点に注意せよ。

* `all`の後にコロンを入れる
* `all`の後に空行をいれてはならない
* `cat hello.txt`の前は「タブ」を入力する(vimの設定によっては、`all:`で改行した時に自動的にタブが入るかもしれない)

入力が終わったら、実行してみよう。端末で`make`を実行せよ。

```sh
$ make
cat hello.txt
Hello Make!
```

この動作について説明しよう。

* まず、`make`はファイルを指定されずに実行されると、デフォルトのメイクファイルである`Makefile`もしくは`makefile`を探しに行く
* `make`はターゲットを指定しないと、デフォルトターゲットである`all`を指定したことになる
* `all`は何も必要なものがないので、コマンドが実行される
* makeは、これから実行するコマンド(今回は`cat hello.txt`)を表示する
* 最後に、`cat hello.txt`の実行結果として`Hello Make!`が表示された。

なお、コマンドに`@`をつけるとそのコマンドは表示されない。

```makefile
all:
    @cat hello.txt
```

```sh
$ make
Hello Make!
```

なお、もう一度makeすると、もう一度コマンドが実行される。

```sh
$ make
Hello Make!
```

makeは「ターゲットが存在しない」もしくは「ターゲットが依存するファイルが存在しないか、ターゲットより新しい」場合にコマンドを実行する。今回はターゲット`all`のコマンドを実行しても、`all`が作成されないので、何度でも実行される。

## 依存関係の記述

次に、依存関係を記述してみよう。同じディレクトリ(`hello`)で、makefileを以下のように書き直そう。

```makefile
all: result.txt

result.txt: hello.txt
    cat hello.txt > result.txt
```

これは、

* ターゲットallは `result.txt`に依存しており、`all`に関しては何もしなくて良い(コマンドが無い)
* ターゲット`result.txt`は `hello.txt`に依存しており、作成するコマンドは `cat hello.txt > result.txt`である。

ことを表している。makeしてみよう。

```sh
$ make
cat hello.txt > result.txt
```

コマンドが実行され、`result.txt`が作成された。catで確認せよ。

```sh
$ cat result.txt
Hello Make!
```

さて、前回と違って、今回はもう一度makeを実行すると、コマンドは実行されない。

```sh
$ make
make: `all' に対して行うべき事はありません.
```

実行されると、makeは以下のように考える。

* allを作るためには、result.txtが必要だ
* result.txtはhello.txtに依存している
* result.txtは既にあり、hello.txtよりもタイムスタンプが新しいのでコマンドは実行しなくてよい
* result.txtが既にある場合、allは何もする必要がない(コマンドがない)
* したがって、makeは何もコマンドを実行する必要はない

以上から、makeは何もしない。

次に、依存関係の処理について見てみよう。上記でmakeが何もしなかったは、`result.txt`のタイムスタンプが`hello.txt`より新しかったからだ。そこで、`hello.txt`のタイムスタンプを新しくしてみよう。タイムスタンプを変えるには`touch`コマンドを使う。

```sh
$ touch hello.txt
$ make
cat hello.txt > result.txt
```

makeすると、`hello.txt`から`result.txt`が作り直された。このように、makeはターゲットが依存するファイルのタイムスタンプをチェックして、どのターゲットを実行するべきかを決める。

## C++の分割コンパイル

次に、もう少し実戦的な例を見てみよう。リポジトリの`cpp`に移動せよ。

```sh
cd ..
cd cpp
```

そこには、以下の三つのファイルがある。

`main.cpp`

```cpp
#include "param.hpp"
#include <cstdio>

void show(void);

int main(void) {
  printf("main: N is %d\n", N);
  show();
}
```

`sub.cpp`

```cpp
#include "param.hpp"
#include <cstdio>

void show(void){
  printf("sub:  N is %d\n",N);
}
```

`param.hpp`

```cpp
const int N = 10;
```

パラメタを定義した`param.hpp`というヘッダファイルがあり、それを`main.cpp`と`sub.cpp`が依存している状況だ。

まずは手動でビルドしてみよう。C/C++は、分割コンパイルができる。まずはソースファイルからオブジェクトファイルを作成し、それをリンクすることで実行バイナリを作成するのだが、ソースからオブジェクトファイルを作るところをファイル毎に行うことができる。

コンパイラに`-c`オプションをつけると、コンパイルしてオブジェクトファイルを出力し、リンクしない。

```sh
$ g++ -c main.cpp
$ g++ -c sub.cpp
$ ls *.o
main.o  sub.o
```

作成されたオブジェクトファイルをリンクで「くっつける」と実行バイナリができあがる。

```sh
$ g++ main.o sub.o
$ ./a.out
main: N is 10
sub:  N is 10
```

実際にリンクしているのは「リンカ」と呼ばれるプログラムなのだが、`g++`が適切にコンパイラやリンカを呼び出して対処しているので、我々はあまり気にしなくて良い。

さて、ここで`param.hpp`の内容を修正しよう。

```cpp
const int N = 20;
```

そして、`sub.cpp`の再コンパイルを忘れ、`main.cpp`のみ再コンパイルして、リンクしてしまったとしよう。

```sh
$ g++ -c main.cpp
$ g++ main.o sub.o
$ ./a.out
main: N is 20
sub:  N is 10
```

この場合でも実行バイナリは更新され、実行できるのだが、本来同じであるべき値がずれてしまっている。このような依存関係を認識し、自動的に必要なファイルを再コンパイルしてくれるのがmakeである。

### クリーン

依存関係をどう扱うかは後で説明することにして、まずは分割コンパイル、リンクをするmakefileを書いてみよう。

```makefile
all: a.out

a.out: main.o sub.o
    g++ main.o sub.o

main.o: main.cpp
    g++ -c main.cpp

sub.o: sub.cpp
    g++ -c sub.cpp
```

書けたら、実行バイナリやオブジェクトファイルを削除してからmakeしてみよう。

```sh
$ rm -f a.out *.o
$ make
g++ -c main.cpp
g++ -c sub.cpp
g++ main.o sub.o
$ ./a.out
main: N is 20
sub:  N is 20
```

`a.out`をビルドするための一連の動作をmakeがやってくれた。また、全てゼロからビルドしたから当たり前だが、値が正しく表示される、正しい実行バイナリができている。この、「全てゼロからビルド」するために、中間ファイルやターゲットを削除することを「クリーン」と呼ぶ。makefileでは、慣習として`clean`というターゲット名で「クリーン」のためのルールを記述する。

先ほどの`makefile`の一番最後に、以下のルールを追加せよ。

```makefile
clean:
    rm -f a.out *.o
```

これにより、`make clean`と打つと、実行バイナリやオブジェクトファイルが削除される。

```sh
$ make clean
rm -f a.out *.o
```

これにより

```sh
make clean
make
```

すれば、必ずクリーンな状態からビルドすることができる。

### パターンルール

次に、ソースファイルから、オブジェクトファイルを作るコマンドが同じなので、ファイルが増えた時に毎回似たような処理を書くのは面倒だ。まとめてしまおう。

makefileの以下の部分を削除する。

```makefile
main.o: main.cpp
    g++ -c main.cpp

sub.o: sub.cpp
    g++ -c sub.cpp
```

削除後に、以下のルールを追加しよう。

```makefile
%.o: %.cpp
    g++ -c $<
```

これは「パターンルール」と呼ばれる構文で、「`%.o`というファイル名にマッチするものは、`%.cpp`から以下のコマンドで作れますよ」ということをmakeに教える。

`$<`とは、マクロ、もしくは自動変数と呼ばれるもので、「必要条件」に展開される。

最終的に、makefileは以下のようになったはずだ。

```makefile
all: a.out

a.out: main.o sub.o
            g++ main.o sub.o

%.o: %.cpp
        g++ -c $<

clean:
        rm -f a.out *.o
```

実際にmakeしてみよう。

```sh
$ make clean
rm -f a.out *.o
$ make
g++ -c main.cpp
g++ -c sub.cpp
g++ main.o sub.o
```

正しくビルドできた。

### 依存関係の出力とインクルード

ここまでで、makefileは`a.out`は`main.o`、`sub.o`に、`main.o`は`main.cpp`に、`sub.o`は`sub.cpp`に依存することを認識しているが、`main.cpp`と`sub.cpp`が`param.hpp`に依存していることは知らない。

したがって、makefileに正しく依存関係を記述してあげる必要があるのだが、そもそも「人間は複雑な依存関係を処理できなくてミスするよね」というのがスタート地点なのに、人間に「makefileに正しく依存関係を書け」というのもおかしな話である。なので、依存関係の抽出もプログラムにやらせよう。`g++`には、依存関係を抽出してmakefile用に出力してくれるオプション`-MM`が存在する。

```sh
$ g++ -MM *.cpp
main.o: main.cpp param.hpp
sub.o: sub.cpp param.hpp
```

これを、リダイレクトでファイルに落とそう。

```sh
g++ -MM *.cpp > makefile.dep
```

できた依存関係記述ファイルを、makefileでインクルードしてやる。makefileのインクルードは`-include`で行う。makefileの最後に以下の文を記述せよ。

```makefile
-include makefile.dep
```

最終的に、makefileは以下のようになったはずだ。

```makefile
all: a.out

a.out: main.o sub.o
      g++ main.o sub.o

%.o: %.cpp
  g++ -c $<

clean:
  rm -f a.out *.o

-include makefile.dep
```

このmakefileが、正しく依存関係を認識しているか調べてみよう。まずはクリーンビルドする。

```sh
make clean
make
```

この状態で、`sub.cpp`だけ更新してからmakeしてみよう。

```sh
$ touch sub.cpp
$ make
g++ -c sub.cpp
g++ main.o sub.o
```

正しく、`sub.cpp`のみ再コンパイルされて、実行できた。

次に`param.hpp`を更新してからmakeしてみよう。

```sh
$ touch param.hpp
$ make
g++ -c main.cpp
g++ -c sub.cpp
g++ main.o sub.o
```

正しく依存関係を認識し、`param.hpp`に依存する`main.cpp`と`sub.cpp`がどちらも再コンパイルされた。

### 変数の利用

最後に、変数を使ってみよう。場面によって、コンパイラが違うことがある。違うコンパイラを使う場合、

```makefile
a.out: main.o sub.o
            g++ main.o sub.o

%.o: %.cpp
        g++ -c $<
```

の二か所に出現する`g++`を修正しなければならない。「〇〇したら××しなければならない」は危険信号だ。一か所だけ修正したら全部修正できるように、変数を使おう。

makefileの変数は、`変数名=値`で宣言し、利用は変数名を`$()`で囲んだ`$(変数名)`とする。

まずは`makefile`の冒頭で、コンパイラを変数で定義しよう。慣習としてC++コンパイラは`CXX`とする。

```makefile
CXX=g++
```

そして、`g++`とあるところを`$(CXX)`に置換する。

最終的に、以下のようなmakefileになるはずだ。

```makefile
CXX=g++

all: a.out

a.out: main.o sub.o
            $(CXX) main.o sub.o

%.o: %.cpp
        $(CXX) -c $<

clean:
        rm -f a.out *.o

-include makefile.dep
```

GNU makeは非常に多機能だが、ここまででよく使う機能はだいたいカバーできたはずだ。

## 並列ビルドと変数置換

makeは依存関係があるものならなんでも使える。特に、変数置換と並列ビルドと組み合わせると、簡単なデータ処理などで便利な時がある。

リポジトリの`makej`ディレクトリに入ってみよう。

その中には、`input0.dat`から`input9.dat`までの10個のインプットファイルと、`convert.py`がある。`convert.py`にデータを食わせると、変換されたデータが出てくるものとしよう。

例えば

```sh
python convert.py < input0.dat > output0.dat
```

などとする。`convert.py`は単に入力をそのまま出力するだけのスクリプトだが、時間のかかる処理を模擬するために、内部で一秒待っている。

さて、これを10個のデータ全部に対してやりたい。もちろん、インプットデータが修正されたら、修正されたところだけアウトプットデータを修正したい。これをmakeにやらせよう。

まず、手元にあるものは`input0.dat`から`input9.dat`だ。これを変数`INPUT`に代入する。

```makefile
INPUTS=$(shell ls input*.dat)
```

GNU Makeでは、`変数名=$(shell コマンド)`とすると、そのコマンドを実行した結果を変数に代入できる。この場合、`INPUTS`には`input0.dat input1.dat ... input9.dat`が代入される。

欲しいのは、これらを全て変換した`output0.dat output1.dat ... output9.dat`だ。これをINPUTから作るために、変数の置換を利用する。

```makefile
OUTPUTS=$(INPUTS:input%=output%)
```

このように`DEST=$(SRC:パターン=パターン)`と記述することで、変換した結果を得ることができる。

今回のケースでは、`input0.dat`が`input%`にマッチし、`%`が`0.dat`となる。この`%`を`output%`を代入すると`output0.dat`が得られる。`input1.dat`なども同様である。こうして`OUTPUTS`に`output0.dat ... output9.dat`が代入された。

最終的に欲しいもの(ビルドターゲット)は`OUTPUTS`であるから、`all`ターゲットは

```makefile
all: $(OUTPUTS)
```

と書けばよい。

以上を実装した、以下のようなmakefileが用意されている。

```makefile
INPUTS=$(shell ls input*.dat)
OUTPUTS=$(INPUTS:input%=output%)


all: $(OUTPUTS)

output%: input%
  python convert.py < $< > $@

clean:
  rm -f $(OUTPUTS)
```

`input?.dat`から`output?.dat`を作るルール

```makefile
output%: input%
  python convert.py < $< > $@
```

にある`$@`は自動変数の一種で、ターゲットに展開される。

早速makeしてみよう。ただし、時間も測ってみる。

```sh
$ time make
python convert.py < input0.dat > output0.dat
python convert.py < input1.dat > output1.dat
python convert.py < input2.dat > output2.dat
python convert.py < input3.dat > output3.dat
python convert.py < input4.dat > output4.dat
python convert.py < input5.dat > output5.dat
python convert.py < input6.dat > output6.dat
python convert.py < input7.dat > output7.dat
python convert.py < input8.dat > output8.dat
python convert.py < input9.dat > output9.dat
make  0.33s user 1.66s system 15% cpu 12.898 total
```

内部で1秒待つので、最低でも10秒かかる。ここでは13秒かかっていた。

では、並列ビルドを試してみよう。並列ビルドは`make -j 並列数`で指定する。例えば、5並列で処理してみよう。

```sh
$ make clean
$ time make -j 5
python convert.py < input0.dat > output0.dat
python convert.py < input1.dat > output1.dat
python convert.py < input2.dat > output2.dat
python convert.py < input3.dat > output3.dat
python convert.py < input4.dat > output4.dat
python convert.py < input5.dat > output5.dat
python convert.py < input6.dat > output6.dat
python convert.py < input7.dat > output7.dat
python convert.py < input8.dat > output8.dat
python convert.py < input9.dat > output9.dat
make -j 5  0.66s user 1.78s system 90% cpu 2.680 total
```

5個ずつ処理されたのがわかると思う。なお、makeの`-j`オプションは**並列数を省略すると並列実行可能なタスクを全て同時に実行しようとする**。したがって、100個データがある場合は、100個プロセスを立ち上げて100個同時に実行する。非常にシステムに負荷をかけるため、並列ビルドをする時には必ず並列数を指定する癖をつけておくこと。最高でもCPUコア数までとする。

## 実戦的な例：アニメーション作成

先ほどの並列ビルドは、単に入力をそのまま出力に出すだけだった。もう少し実戦的な例として、シミュレーションデータを可視化して、アニメーションを作成してみよう。

リポジトリの`spiral`ディレクトリに入ろう。

```sh
cd ..
cd spiral
```

まず、シミュレーションをして、途中の結果をダンプする処理をしよう。

```sh
$ python3 makedata.py
spiral00.dat
spiral01.dat
spiral02.dat
spiral03.dat
spiral04.dat
spiral05.dat
spiral06.dat
spiral07.dat
spiral08.dat
spiral09.dat
spiral10.dat
spiral11.dat
spiral12.dat
spiral13.dat
spiral14.dat
spiral15.dat
```

実行すると`spiral00.dat`から`spiral15.dat`までの16個のデータが出力されたはずだ。これがシミュレーションデータだと思うことにしよう。

このデータを処理して、画像ファイルとして出力するスクリプト`convert.py`が用意してある。実行してみよう。

```sh
$ python3 convert.py spiral00.dat
spiral00.png
```

`spiral00.png`が出てきたはずだ。`eog`で見てみよう。

```sh
eog spiral00.png
```

らせん模様が見えただろうか？これを全て変換したいが、いちいちコマンドを入力するのは面倒だし、シミュレーションの途中でも可視化したいし、シミュレーションが終わったら、可視化していないデータのみ変換したい。こんな時はmakeの出番だ。

```makefile
DAT=$(shell ls *.dat)
PNG=$(DAT:%.dat=%.png)

all: $(PNG)


%.png: %.dat
        python3 convert.py $<


gif: $(PNG)
        convert -delay 5 -loop 0 -resize 50% spiral*.png spiral.gif

clean:
        rm -f spiral.gif spiral*.dat spiral*.png
```

もう何をやっているかはわかると思う。早速`make`してみよう。せっかくなので並列ビルドしてしまおう。

```sh
make -j
```

`spiral00.png`は作成済みであるから、`spiral01.png`から`spiral15.png`が作成されたはずだ。せっかく連番ファイルがえきたので、アニメーションgifを作ってみよう。ImageMagickのコマンドを毎回入力するのは面倒なので、それもmakeにやらせよう。

```sh
$ make gif
convert -delay 5 -loop 0 -resize 50% spiral*.png spiral.gif
```

`spiral.gif`が作成されたはずだ。見てみよう。

```sh
eog spiral.gif
```

うずまきがグルグル回っただろうか。

とにかく「何か依存関係のある処理」を自動化するのにmakeは便利だ。単に便利というのみならず、人為的なミスも防ぐし、自動化しておくと「あれ？このデータからこの画像はどうやって作るんだっけ？」と忘れた時に、makeを見ればやり方を思い出すだろう。論文を書く時にも、データを更新したらmake一発で図も更新してPDFまで作る環境を作っておくことが望ましい。
