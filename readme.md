# This repository contains scripts to migrate [ttssh2 SVN](http://svn.osdn.net/svnroot/ttssh2)

[![Run](https://github.com/m-tmatma/ttssh2migrate/actions/workflows/run.yml/badge.svg)](https://github.com/m-tmatma/ttssh2migrate/actions/workflows/run.yml)


[ttssh2 SVN](http://svn.osdn.net/svnroot/ttssh2) を git に変換するためのスクリプト、設定ファイル群

## 変換手順

```
sudo apt install -y svn-all-fast-export
./1.mirror-ttssh2.sh
./2.filter-svndmp.sh
./migrate.sh
```

### 成果物

|  説明  | パス  | GitHub Actions の artifacts でダウンロード  |
| ---- | ---- | ---- |
|  gitリポジトリ  |  `workdir/gitdir/ttssh2`  | 〇  |
|  フィルター後のsvnリポジトリ  |  `workdir/ttssh2`   | 〇  |
|  オリジナルsvnリポジトリ  |  `workdir/ttssh2.org`  | × (省略) |
|  フィルター後のsvnリポジトリの `svn log`  |  `workdir/ttssh2`   | 〇  |
|  オリジナルsvnリポジトリの `svn log`  |  `workdir/ttssh2.org`  | 〇  |

## 仕組み

https://github.com/svn-all-fast-export/svn2git を利用して、svn から git への変換を行う。

###  svn-all-fast-export

[svn-all-fast-export](https://manpages.ubuntu.com/manpages/trusty/man1/svn-all-fast-export.1.html) は apt でインストールする。

## 変換手順詳細

### svn sync

`svn sync` を利用してリモートにあるリポジトリをローカルに取得する。

[1.mirror-ttssh2.sh](1.mirror-ttssh2.sh) を使う。

### svndumpfilter

* `svnadmin dump` でダンプファイルを出力する。
* パイプでつないで、`svndumpfilter` で不要なファイルをフィルタリングする。
* パイプでつないで、`svnadmin load` で別のリポジトリにコミットする。

[2.filter-svndmp.sh](2.filter-svndmp.sh) を使う。

### svn-all-fast-export

* ルールファイル [input.rules](input.rules) を指定して `svn-all-fast-export` で変換する。

[migrate.sh](migrate.sh) を使う。

## 制限事項

* r1304 に追加された `/teraterm/branches/avendor/source/ttdlg/･ｳ･ﾔ｡ｼ ｡ﾁ ttpdlg.rc` を除外できない。
*  ([svn-all-fast-export](https://manpages.ubuntu.com/manpages/trusty/man1/svn-all-fast-export.1.html) で `--identity-map` を渡してないため) ユーザー名に `@localhost` が付与される

## リビジョングラフ

[TortoiseGitによるリビジョングラフ](ttssh2.svg)
リンクを押したあと RAW を選ぶ。
グラフが巨大なのでスクロールして確認したところに移動する。


