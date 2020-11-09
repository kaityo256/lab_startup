# LaTeXのインストール

PCにLaTeXの処理系をインストールし、実行できるようにする。かんたんな使い方を覚え、卒業論文用のリポジトリを作成し、指導教員をコラボレータとして招待する。

## インストール

### Windowsの場合

[Installing TeX Live over the Internet](https://www.tug.org/texlive/acquire-netinstall.html)から、 install-tl-windows.exeをダウンロードし、実行する。セキュリティの問題から、単にクリックしただけでは保存が実行されない場合がある。その場合は右クリックから「名前をつけて保存」を選び、ブラウザが文句を言った場合は「継続」を押すなどしてダウンロードすることができる(Chromeの場合）。また、実行時にWindowsが「WindowsによってPCが保護されました」などと言って実行させてくれない場合がある。この時には「詳細情報」をクリックして「実行」を押せば実行できる。

最初に「Install」「Unpack」のどちらかが選べるが、デフォルトの「Install」のままNextを押す。そして「Install」をクリックする。しばらくすると「TeX Live 2020インストーラ」というダイアログが出てくるので、何も変更しないまま「インストール」をクリック。フルインストールに **1〜2時間ほど** かかるので、時間に余裕がある時に行うこと。

### Macの場合

[ミラーサイト](https://texwiki.texjp.org/?TeX%20Live#tlnet)から`install-tl-unx.tar.gz`をダウンロードする。どこでも良いが、例えばJ[JAISTのサイト](http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/)からダウンロードすると良いだろう。

ターミナルを開き、以下を実行せよ(コピペで良い)。以下では「ダウンロード」にダウンロードしたと仮定しているが、もしデスクトップに落としたなら`mv ~/Desktop/install-tl-unx.tar.gz .`に変更せよ。

```sh
mkdir temp
cd temp
mv ~/Downloads/install-tl-unx.tar.gz .
tar xvf install-tl-unx.tar.gz
sudo ./install-tl -no-gui -repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/
```

すると、以下のような画面が表示されるので、「高度な設定」を選ぶ。

![install1.png](fig/install1.png)

以下の画面で「シンボリックリンクを標準ディレクトリに作成」にチェックを入れてから「インストール」をクリックする。

![install2.png](fig/install2.png)

フルインストールに **1〜2時間ほど** かかるので、時間に余裕がある時に行うこと。
