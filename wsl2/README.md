# WSL2のセットアップ(Windowsのみ)

Windowsマシンでは、原則としてWSL(Windows Subsystem for Linux)上で作業を行う。そのためにWSLをインストールする。Linuxディストリビューションとしては、Ubuntu 22.04を用いる。

基本的にはMicrosoftのドキュメントの[WSL を使用して Windows に Linux をインストールする](https://learn.microsoft.com/ja-jp/windows/wsl/install)に記載されている手順に従えばよい。

以下はIntelもしくはAMDのCPUが乗ったWindowsマシンを想定してるが、ARM64などの場合は別途対応が必要な場合がある。上記インストールガイドを参照のこと。

## WSLを有効にする

最初に「管理者」としてPowerShellを実行する。左下の「ここに入力して検索」とある場所(以下、検索窓)に「powershell」として表示された「WIndows PowerShell」の、右側のメニューの「管理者とて実行する」を選べば良い。

![PowerShellを管理者として実行](fig/powershell.png)

その後、開いたシェルで以下を実行する。

```sh
wsl --install
```

## Ubuntu 22.04のインストール

検索窓に「Microsoft Store」と入力してMicrosoft Storeを開く。右上の「検索」に「ubuntu」と入力し、現れた候補の中から「Ubuntu 24.04.1 LTS」を選択、インストールする。

インストール後の最初に起動でUNIX usernameとパスワードを聞かれるので、アカウント名とパスワードを入力する。

以上でUbuntuのインストールは完了である。

## 環境設定

### デスクトップへのシンボリックリンク

WSL側からWindows側のデスクトップにシンボリックリンクを張っておくと後々便利だ。

```sh
ln -s /mnt/c/Users/username/Desktop
```

上記の「username」を自分のWindowsのアカウント名にすること。アカウント名がわからない場合はWSLで以下のコマンドを実行することで確認できる。

```sh
cmd.exe /c echo %USERNAME% 2> /dev/null
```

なお、OneDriveを利用している場合は、Desktopがその下にある。その場合は、

```sh
ln -s /mnt/c/Users/username/OneDrive/Desktop
```

とすること。

### explorer.exeへのエイリアス

WSLのディレクトリをエクスプローラで開くことができると便利だ。以下の一行を`.bashrc`の最後に記載しておくこと。

```sh
alias open=explorer.exe
```

保存したら、

```sh
source .bashrc
```

で読み込んだ後、

```sh
open .
```

により、現在のディレクトリがエクスプローラで開かれることを確認せよ。
