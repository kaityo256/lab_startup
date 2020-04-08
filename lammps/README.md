# LammpsとVMDのインストール

Lammps (Large-scale Atomic/Molecular Massively Parallel Simulator)は、サンディア国立研究所の古典分子動力学プログラムだ。性能が良く、比較的容易に使えて、並列化もなされているため、広く使われている。

## Lammpsのインストール

### Windows

まずは[ここ](https://rpm.lammps.org/windows/)からLammpsをダウンロードしよう。並列版もあるが、とりあえずはシリアル版(並列化されていない)として、`LAMMPS-64bit-stable.exe`をダウンロードして、実行する。「WindowsによってPCが保護されました」というダイアログが出てきたら、「詳細情報」を押すと「実行」が出てくるので、それをクリックしてインストールする。

### Mac

「ターミナル」で以下を実行しよう。

```sh
brew install lammps
```

## サンプルコードの実行

インストールが完了したら、サンプルコードを実行してみよう。

### Windows

Windowsの場合、Lammpsのサンプルファイルは`C:\Program Files\LAMMPS 64-bit 3Mar2020\Examples`にある。そこに移動して「melt」というフォルダをコピーしよう。

その後、自分のユーザフォルダに移動する。エクスプローラーで、「PC」→「Windows (C:)」→「ユーザー」→「自分のアカウント名」でいけるはず。

そこに「lammps」というフォルダを作り、その中に入ってから、先ほどコピーした「melt」を貼り付けよう。

次に、Windows Powershellを起動する。デフォルトでユーザーフォルダが表示されるはず。そこで、

```sh
cd lammps
cd melt
```

としてから、`ls`と打ってみよう。正しくコピーされていれば、以下のような表示になるはず。

```txt


    ディレクトリ: C:\Users\watanabe\lammps\melt


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2020/03/06      2:02            596 in.melt
-a----       2020/03/06      2:02           2939 log.27Nov18.melt.g++.1
```

この状態で、以下を実行しよう。

```sh
cat .\in.melt | lmp_serial.exe
```

いろいろ表示されて、最後に

```txt
Total # of neighbors = 151513
Ave neighs/atom = 37.8783
Neighbor list builds = 12
Dangerous builds not checked
Total wall time: 0:00:00
```

といった表示が出れば実行は成功だ。

### Mac

ターミナルで以下を実行せよ。

```sh
cd
mkdir lammps
cd lammps
cp -r /usr/local/Cellar/lammps/2020-03-03/share/lammps/examples/melt .
cd melt
```

ここまでやったら`ls`と入力してみよ。正しくコピーされていれば以下の３つのファイルがあるはずである。

```txt
in.melt  log.27Nov18.melt.g++.1  log.27Nov18.melt.g++.4
```

ではLammpsを実行しよう。

```sh
lmp_serial < in.melt 
```

最後に

```txt
Total # of neighbors = 151513
Ave neighs/atom = 37.8783
Neighbor list builds = 12
Dangerous builds not checked
Total wall time: 0:00:00
```

と表示されれば成功である。

## in.meltの修正

次に、`in.melt`を修正しよう。

PowerShellもしくはターミナルで当該フォルダを開いているのなら、

```sh
code in.melt
```

と入力すれば、VSCodeで直接`in.melt`が開かれるはず。

また、Windowsであれば、コピーした(ユーザーフォルダの下にある)`melt`フォルダの中の`in.melt`ファイルを右クリックすると、「Codeで開く」という項目があるはずだ。それを選ぶと、`in.melt`ファイルがVSCodeで開かれるはずである。

VSCodeでin.meltを開いたら、以下の行を探す。

```sh
#dump		id all atom 50 dump.melt
```

この行頭の`#`を削除して保存しよう。

```sh
dump		id all atom 50 dump.melt
```

この状態で、またlammpsを実行しよう。

WindowsならPowerShellで、

```sh
cat .\in.melt | lmp_serial.exe
```

Macならターミナルで

```sh
lmp_serial < in.melt 
```

と実行する。

すると、今度は同じフォルダに`melt.dump`が作成されたはずだ。`ls`で確認せよ。これは原子の起動を保存したファイルで、これを後からVMDで読み込んで可視化する。

## VMDのインストール

### Windows

次にVMDをダウンロード、インストールしよう。

[ここ](https://www.ks.uiuc.edu/Research/vmd/)に行って、「Download (all versions)」をクリックする。

次に「Version 1.9.3 (2016-11-30) Platforms:」の、「Windows OpenGL (Microsoft Windows XP/Vista/7/8/10 (32-bit) using OpenGL)」を選ぶ。

すると、「Registration/Login」画面が現れるので、メールアドレスと、適当なパスワードを入力する。初回登録時には「New User Registration」画面となるので、必要事項を入力の上で「Register」を押す。

ライセンスに同意することを示すと、ダウンロードが始まる。ダウンロードが完了したら、インストールする。特に設定項目はない。

Windows 10なら、左下の「ここに入力して検索」で「vmd」で検索すればVMDが起動する。

### Mac

最新版のMacではVMDが実行できないため、やや手間だがDocker経由で実行する。

#### XQuartzのインストール

まず、XQuartzをインストールしよう。[ここ](https://www.xquartz.org/)から、`XQuartz-2.7.11.dmg`をダウンロード、インストールする。

XQuartzは「アプリケーション」→「ユーティリティ」にインストールされるので起動する。「xterm」というウィンドウが開けばインストールできてる。

その後、XQuartzの「環境設定」の「セキュリティ」タブで、「接続を認証」と「ネットワーク・クライアントからの接続を許可」の両方にチェックを入れる(デフォルトで「接続を認証」にはチェックが入っているはず)。

![XQuartz](fig/xquartz.png)

さらに、ターミナルから

```sh
defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
```

を実行しておく。以上の変更を適用するためにXQuartzを再起動すること。

#### Dockerのインストール

次に、Dockerをインストールする。[ここ](https://www.docker.com/products/docker-desktop)から「Download for Mac」→「Get Docker」でダウンロードできるのでインストールする。

インストール後、Dockerを起動する。最初にDocker IDの入力を求められるウィンドウが出るが、無視して消して良い。右上にクジラのような小さいアイコンが表示されたらDockerが起動している。

Dockerの動作を確認しよう。ターミナルで、

```sh
docker ps
```

を実行し、

```txt
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

と表示されたらDockerが起動している。

```txt
Error response from daemon: dial unix docker.raw.sock: connect: connection refused
```

と表示されたらDockerが起動していないので起動すること。

#### Dockerイメージの作成

まず、Dockerイメージ作成用のディレクトリを作成し、そこにDockerfileをダウンロードしよう。

```sh
cd
mkdir docker-vmd
cd docker-vmd
wget https://kaityo256.github.io/lab_startup/lammps/Dockerfile
```

次に、Linux版のVMDをダウンロードする。[ここ](https://www.ks.uiuc.edu/Research/vmd/)に行って、「Download (all versions)」をクリックする。

次に「Version 1.9.4 LATEST ALPHA (2019-10-17) Platforms:」の「LINUX_64 OpenGL, CUDA, OptiX, OSPRay」を選ぶ。すると、「Registration/Login」画面が現れるので、メールアドレスと、適当なパスワードを入力する。初回登録時には「New User Registration」画面となるので、必要事項を入力の上で「Register」を押す。

ライセンスに同意することを示すと、ダウンロードが始まる。ダイアログが出たら「Save File」を選ぶこと。ダウンロードが完了したら、ダウンロードしたファイルを、先程作成したディレクトリ`docker-vmd`にコピーする。例えば、「ダウンロード」フォルダにダウンロードされたなら、

```sh
cp ~/Downloads/vmd*.tar.gz .
```

で現在のディレクトリにコピーされるはずである。

現在、`~/docker-vmd`ディレクトリには、以下のDockerファイルとtar.gzファイルの2つのファイルがあるはず。

```sh
$ ls
Dockerfile  vmd-1.9.4a38.bin.LINUXAMD64-CUDA10-OptiX600-RTX-OSPRay170.opengl.tar.gz
```

この状態でDockerイメージをビルドする。

```sh
docker build -t vmd .
```

最後に

```txt
Successfully tagged vmd:latest
```

と表示されたら正しくビルドされている。

次に、先程の`melt`ディレクトリに移動して、以下のコマンドを実行する。

```sh
cd
cd lammps
cd melt
docker run -e DISPLAY=$(hostname):0 -v ~/.Xauthority:/root/.Xauthority -v $(pwd):/lammps -it vmd
```

ここまで正しく実行されていればVMDが起動したはずである。

```txt
Can't open display: watanabe-mbp.local:0
```

などと言われたらXQuartzが起動していないので起動せよ。

## VMDによる可視化

VMDが起動したら、「VMD Main」の「File」から「New Molecule」を選び、「Browse」を押して先ほどの`dump.melt`を選ぶ。Macの場合は`/lammps`の中にあるはず。

file typeとして「LAMMPS Trajectory」を選んでから「Load」を押す。

![VMD](fig/vmd_dialog.png)

すると、直線が多数重なったような画面が出たはずだ。この状態で、「VMD Main」の画面で「dump.melt」の行を選び、「Graphics」の「Representation」を選ぶ。

ここで、「Drawing Method」を「VDW」にすると、画面が玉に変わるはず。その状態で「Sphere Scale」を小さくしよう。0.3くらいがちょうどよいと思う。

![Representation](fig/vmd_representation.png)

この状態で、VMD Mainの右下にある再生ボタン「Play Forward」を押せば、原子が凍った状態から解けていくアニメーション(6フレームしかないが)が表示されるはずである。マウスでドラッグすると角度を変えられるので試してみよ。
