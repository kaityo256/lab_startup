# LammpsとVMDのインストール

Lammps (Large-scale Atomic/Molecular Massively Parallel Simulator)は、サンディア国立研究所の古典分子動力学プログラムだ。性能が良く、比較的容易に使えて、並列化もなされているため、広く使われている。

## Windows編

### Lammpsのインストール

まずは[ここ](https://rpm.lammps.org/windows/)からLammpsをダウンロードしよう。並列版もあるが、とりあえずはシリアル版(並列化されていない)として、`LAMMPS-64bit-stable.exe`をダウンロードして、実行する。「WindowsによってPCが保護されました」というダイアログが出てきたら、「詳細情報」を押すと「実行」が出てくるので、それをクリックしてインストールする。

インストールが完了したら、サンプルコードを実行してみよう。

Lammpsのサンプルファイルは`C:\Program Files\LAMMPS 64-bit 3Mar2020\Examples`にある。そこに移動して「melt」というフォルダをコピーしよう。

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

### in.meltの修正

次に、`in.melt`を修正しよう。

PowerShellで当該フォルダを開いているのなら、

```sh
code in.melt
```

と入力すれば、VSCodeで直接`in.melt`が開かれるはず。

また、コピーした(ユーザーフォルダの下にある)`melt`フォルダの中の`in.melt`ファイルを右クリックしよう。VSCodeが正しくインストールされていれば「Codeで開く」という項目があるはずだ。それを選ぶと、`in.melt`ファイルがVSCodeで開かれるはずである。

コマンドライン(Windows Powershell)から開く方法と、こうしてエクスプローラーから開く方法の両方が使えるようになって欲しい。

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
cat .\in.melt | lmp_serial.exe
```

すると、今度は同じフォルダに`melt.dump`が作成されたはずだ。`ls`で確認せよ。

これは原子の起動を保存したファイルで、これを後からVMDで読み込んで可視化する。

### VMDのインストール

次にVMDをダウンロード、インストールしよう。

[ここ](https://www.ks.uiuc.edu/Research/vmd/)に行って、「Download (all versions)」をクリックする。

次に「Version 1.9.3 (2016-11-30) Platforms:」の、「Windows OpenGL (Microsoft Windows XP/Vista/7/8/10 (32-bit) using OpenGL)」を選ぶ。

すると、「Registration/Login」画面が現れるので、メールアドレスと、適当なパスワードを入力する。初回登録時には「New User Registration」画面となるので、必要事項を入力の上で「Register」を押す。

ライセンスに同意することを示すと、ダウンロードが始まる。ダウンロードが完了したら、インストールする。特に設定項目はない。

Windows 10なら、左下の「ここに入力して検索」で「vmd」で検索すればVMDが起動する。

VMDが起動したら、「VMD Main」の「File」から「New Molecule」を選び、「Browse」を押して先ほどの`dump.melt`を選ぶ。file typeとして「LAMMPS Trajectory」を選んでから「Load」を押す。

![VMD](fig/vmd_dialog.png)

すると、直線が多数重なったような画面が出たはずだ。この状態で、「VMD Main」の画面で「dump.melt」の行を選び、「Graphics」の「Representation」を選ぶ。

ここで、「Drawing Method」を「VDW」にすると、画面が玉に変わるはず。その状態で「Sphere Scale」を小さくしよう。0.3くらいがちょうどよいと思う。

![Representation](fig/vmd_representation.png)

この状態で、VMD Mainの右下にある再生ボタン「Play Forward」を押せば、原子が凍った状態から解けていくアニメーション(6フレームしかないが)が表示されるはずだ。
