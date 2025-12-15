# 古い情報

## 概要

最近のWindowsならWSLはデフォルトでX11が飛ぶはず。

## VcXsrvのインストール


[https://sourceforge.net/projects/vcxsrv/](https://sourceforge.net/projects/vcxsrv/)から、VcXsrvをインストールする。

インストール後に、XLaunchを起動する。Windows 10なら「ここに入力して検索」と表示されている検索窓にXLaunchと入力すれば起動する。

起動後にいろいろ聞かれる。

「Display settings」は、デフォルトの「Multiple windows」のままで良い。

![fig/xlaunch1.png](fig/xlaunch1.png)

「Client startup」も、デフォルトの「Start no client」で良い。

![fig/xlaunch2.png](fig/xlaunch2.png)

**「Extra settings」において「Additional parameters for VcXsrv」に「-ac」と追加するのを忘れないこと**。これを設定しないと、おそらく動かない。

![fig/xlaunch3.png](fig/xlaunch3.png)

「Finish configuration」では何もしないで「完了」で良い。

![fig/xlaunch4.png](fig/xlaunch4.png)


その後、Ubuntuのターミナルを開く。

X11の動作確認のため、`xeyes`をインストールしよう。
