# LammpsとVMDのインストール

Lammps (Large-scale Atomic/Molecular Massively Parallel Simulator)は、サンディア国立研究所の古典分子動力学プログラムだ。性能が良く、比較的容易に使えて、並列化もなされているため、広く使われている。

## Lammpsのインストール

### Windows

WSLのターミナルで以下を実行する。

まずはリポジトリを追加する。

```sh
$ sudo add-apt-repository ppa:gladky-anton/lammps
$ sudo add-apt-repository ppa:openkim/latest
```

それぞれ「リポジトリを追加して良いか？」と聞いてくるので、エンターキーを押そう。

リポジトリが追加されたら、パッケージをアップデートしてからLAMMPSをインストールする。

```sh
$ sudo apt-get update
$ sudo apt-get install lammps-stable
```

これにより、`lmp_stable`という実行バイナリがインストールされる。バージョンを確認しよう。

```sh
$ echo info | lmp_stable
LAMMPS (3 Mar 2020)

Info-Info-Info-Info-Info-Info-Info-Info-Info-Info-Info
Printed on Mon May  2 15:12:31 2022


Info-Info-Info-Info-Info-Info-Info-Info-Info-Info-Info

Total wall time: 0:00:00
```

以下、`lmp_serial`を`lmp_stable`と読み替えて実行すること。

### Mac

「ターミナル」で以下を実行しよう。

```sh
brew install lammps
```

インストールが完了したら以下を実行せよ。

```sh
$ echo info | lmp_serial  
LAMMPS (29 Oct 2020)

Info-Info-Info-Info-Info-Info-Info-Info-Info-Info-Info
Printed on Tue Mar 30 16:29:46 2021


Info-Info-Info-Info-Info-Info-Info-Info-Info-Info-Info

Total wall time: 0:00:00
```

上記のようなバージョン情報が表示されれば問題なくインストールされている。

## サンプルコードの実行

インストールが完了したら、サンプルコードを実行してみよう。サンプルファイルをgitでcloneする。


```sh
cd github
git clone --depth 1 https://github.com/lammps/lammps.git
cd lammps/examples/melt
```

で目的の場所にいけるはず。異なるディレクトリにクローンした場合は適宜読み替えること。

この状態で、以下を実行しよう(Windowsの場合は`lmp_stable`)。

```sh
lmp_serial < in.melt
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

## in.meltの修正

次に、`in.melt`を修正しよう。

```sh
code in.melt
```

と入力すれば、VSCodeで直接`in.melt`が開かれるはず。

VSCodeでin.meltを開いたら、以下の行を探す。

```sh
#dump		id all atom 50 dump.melt
```

この行頭の`#`を削除して保存しよう。

```sh
dump		id all atom 50 dump.melt
```

この状態で、またlammpsを実行しよう。

```sh
lmp_serial < in.melt
```

すると、今度は同じフォルダに`dump.melt`が作成されたはずだ。`ls`で確認せよ。これは原子の起動を保存したファイルで、これを後からVMDで読み込んで可視化する。

### 研究室サーバで実行する場合

以下を実行せよ。

```sh
export PATH=$PATH:/home/apps/lammps
```

これにより、`lmp_serial`が使えるようになる。

## VMDのインストール

### Windows

次にVMDをダウンロード、インストールしよう。

[ここ](https://www.ks.uiuc.edu/Research/vmd/)に行って、「Download (all versions)」をクリックする。

次に「Version 1.9.4 LATEST ALPHA (2020-12-21) Platforms:」の、「Windows 64-bit, CUDA, OptiX, OSPRay (64-bit Intel x86_64) (Windows 10)」を選ぶ。

もし実行時にエラーが起きて開けなかった場合、アンインストールして32-bit版をダウンロードした方が良いかも。

すると、「Registration/Login」画面が現れるので、メールアドレスと、適当なパスワードを入力する。初回登録時には「New User Registration」画面となるので、必要事項を入力の上で「Register」を押す。

ライセンスに同意することを示すと、ダウンロードが始まる。ダウンロードが完了したら、インストールする。特に設定項目はない。

### Mac

[ここ](https://www.ks.uiuc.edu/Research/vmd/)に行って、「Download (all versions)」をクリックする。

M1 Macの場合は「MacOS 11.x, ARM64 (64-bit "M1" Macs) (Apple MacOS-X 11 or later)」を選ぶ。

すると、「Registration/Login」画面が現れるので、メールアドレスと、適当なパスワードを入力する。初回登録時には「New User Registration」画面となるので、必要事項を入力の上で「Register」を押す。

ライセンスに同意することを示すと、ダウンロードが始まる。ダウンロードが完了したら、インストールする。特に設定項目はない。

なお、ダウンロードしたイメージを実行しようとすると「"startup.command"は、開発元が未確認のため開けません。」というエラーがでる場合がある。この場合はシステム環境設定の「セキュリティとプライバシー」の「一般」タブを表示しながら再度実行せよ。すると「"startup.command"は開発元が確認できないため、使用がブロックされました。」というメッセージの隣に「このまま開く」というボタンが現れるため、それを押して現れるダイアログの「開く」をクリックすれば実行できる。

![open vmd](fig/open_vmd.png)

## VMDによる可視化

### Windowsの場合

WSLにおいて、まず`dump.melt`が存在するディレクトリで

```sh
open .
```

と入力し、そのフォルダを開く。まだopenをエイリアス設定していない場合は

```sh
alias open=explorer.exe
```

としておくこと。`.bashrc`に記載しておくことが望ましい。フォルダが開いたら、パスが表示されている場所(以下の赤で囲った部分)に「vmd」と入力すると、このディレクトリをカレントディレクトリとしてVMDが起動する。

![フォルダ](fig/folder.png)

VMDが起動したら、「VMD Main」の「File」から「New Molecule」を選び、「Browse」を押して先ほどの`dump.melt`を選ぶ。

file typeとして「LAMMPS Trajectory」を選んでから「Load」を押す。

![VMD](fig/vmd_dialog.png)

すると、直線が多数重なったような画面が出たはずだ。この状態で、「VMD Main」の画面で「dump.melt」の行を選び、「Graphics」の「Representation」を選ぶ。

ここで、「Drawing Method」を「VDW」にすると、画面が玉に変わるはず。その状態で「Sphere Scale」を小さくしよう。0.3くらいがちょうどよいと思う。

![Representation](fig/vmd_representation.png)

この状態で、VMD Mainの右下にある再生ボタン「Play Forward」を押せば、原子が凍った状態から解けていくアニメーション(6フレームしかないが)が表示されるはずである。マウスでドラッグすると角度を変えられるので試してみよ。

### Macの場合

VMDが起動したら、「VMD Main」の「File」から「New Molecule」を選び、「Browse」を押して先ほどの`dump.melt`を選ぶ。`/lammps`の中にあるはず。

file typeとして「LAMMPS Trajectory」を選んでから「Load」を押す。

![VMD](fig/vmd_dialog.png)

すると、直線が多数重なったような画面が出たはずだ。この状態で、「VMD Main」の画面で「dump.melt」の行を選び、「Graphics」の「Representation」を選ぶ。

ここで、「Drawing Method」を「VDW」にすると、画面が玉に変わるはず。その状態で「Sphere Scale」を小さくしよう。0.3くらいがちょうどよいと思う。

![Representation](fig/vmd_representation.png)

この状態で、VMD Mainの右下にある再生ボタン「Play Forward」を押せば、原子が凍った状態から解けていくアニメーション(6フレームしかないが)が表示されるはずである。マウスでドラッグすると角度を変えられるので試してみよ。
