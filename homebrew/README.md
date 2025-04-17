# Homebrewのインストール

## Homebrewとは

Homebrew(ホームブリュー)とは、主にMacで使われるパッケージ管理システムである。欲しいソフトウェアを簡単にインストールするのに使われる。一般にソフトウェアは別のライブラリに依存するが、パッケージ管理システムはその依存関係を認識して自動的に必要なライブラリもインストールしてくれる。今後、MacはHomebrewで必要なソフトウェアを管理するため、最初にインストールしておこう。

## Homebrewのインストール

もしインストールされていないのなら、まずHomebrewをインストールする。

まず「ターミナル」を開く。Command+Spaceでスポットライトを開き、Terminal.appを選べば起動する。実行したら、今後良く使うのでDockに追加しておこう。ターミナルが開いたら、以下を実行せよ。

```sh
brew
```

`zsh: command not found: brew`と言われたらインストールされていない。インストールするには[https://brew.sh/ja](https://brew.sh/ja)の指示に従い、ターミナルで以下のコマンドを実行する(以下のコマンドは変更される可能性があるため、最新版の指示に従うこと)。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

上記をターミナルにコピペして実行せよ。途中、パスワードが要求されるので入力すること。

`Press RETURN/ENTER to continue or any other key to abort`と表示されたらエンターキーを押す。Home brewのインストールが終わったら、パスの設定を促すメッセージが出る。

```txt
==> Next steps:
- Run these commands in your terminal to add Homebrew to your PATH:
    echo >> /Users/watanabe/.zprofile
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> /Users/watanabe/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
```

このうち以下の三行(人によって異なる)を実行しておくこと。

```sh
echo >> /Users/watanabe/.zprofile
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> /Users/watanabe/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

これにより、`brew`にパスが通る。

もう一度`brew`を実行し、使い方が表示されればインストール成功である。

```sh
brew
```

```txt
Example usage:
  brew search [TEXT|/REGEX/]
  brew info [FORMULA...]
(snip)
Further help:
  brew commands
  brew help [COMMAND]
  man brew
  https://docs.brew.sh
```
