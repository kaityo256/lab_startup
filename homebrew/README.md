# Homebrewのインストール

## Homebrewとは

Homebrew(ホームブリュー)とは、主にMacで使われるパッケージ管理システムである。欲しいソフトウェアを簡単にインストールするのに使われる。一般にソフトウェアは別のライブラリに依存するが、パッケージ管理システムはその依存関係を認識して自動的に必要なライブラリもインストールしてくれる。今後、MacはHomebrewで必要なソフトウェアを管理するため、最初にインストールしておこう。

## Homebrewのインストール

もしインストールされていないのなら、まずHomebrewをインストールする。

まず「ターミナル」を開く。Command+Spaceでスポットライトを開き、Terminal.appを選べば起動する。実行したら、今後良く使うのでDockに追加しておこう。ターミナルが開いたら、以下を実行せよ。

```sh
brew
```

`zsh: command not found: brew`と言われたらインストールされていない。インストールするには[https://brew.sh/index_ja](https://brew.sh/index_ja)の指示に従い、ターミナルで以下のコマンドを実行する(以下のコマンドは変更される可能性があるため、最新版の指示に従うこと)。

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

上記をターミナルにコピペして実行せよ。途中、パスワードが要求されるので入力すること。

`Press RETURN/ENTER to continue or any other key to abort`と表示されたらエンターキーを押す。Home brewのインストールが終わったら、再度以下を実行せよ。

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

などと表示されればインストールできている。もし

```sh
Error: You have not agreed to the Xcode license. Please resolve this by running:
  sudo xcodebuild -license accept
```

というエラーが起きて実行できなかった場合、

```sh
sudo xcodebuild -license accept
```

を実行せよ(パスワードが必要)。

最後にHome Brewを最新版にする。以下を実行せよ。

```sh
brew update --force && brew upgrade
```

新規インストール時であれば、`Already up-to-date.`と表示されて終わるはずである。すでにHomebrewをインストールしていた場合は、パッケージが最新版にアップデートされる。
