# This repository contains scripts to migrate [ttssh2 SVN](http://svn.osdn.net/svnroot/ttssh2)

[![Run](https://github.com/m-tmatma/ttssh2migrate/actions/workflows/run.yml/badge.svg)](https://github.com/m-tmatma/ttssh2migrate/actions/workflows/run.yml)


[ttssh2 SVN](http://svn.osdn.net/svnroot/ttssh2) を git に変換するためのスクリプト、設定ファイル群

## 変換手順

```
sudo apt install -y svn-all-fast-export
./1.mirror-ttssh2.sh
./2.filter-svndmp.sh
./3.svnlog.sh
./4.rewrite-svnlog.sh
./migrate.sh
```

### 成果物

|  説明                                     | パス                             | GitHub Actions の artifacts でダウンロード  |
| ----                                      | ----                             | ----                                        |
|  svnリポジトリ(オリジナル)                |  `workdir/ttssh2.org`            | × (省略)                                   |
|  svnリポジトリ(フィルター後)              |  `workdir/ttssh2.step2`          | × (省略)                                   |
|  svnリポジトリ(ログ書き換え)              |  `workdir/ttssh2`                | 〇                                          |
|  `svn log` (オリジナル)                   |  `workdir/svn-org.log`           | 〇                                          |
|  `svn log` (フィルター後)                 |  `workdir/svn-step2.log`         | 〇                                          |
|  `svn log` (ログ書き換え)                 |  `workdir/svn-step4-rewrite.log` | 〇                                          |
|  gitリポジトリ                            |  `workdir/gitdir/ttssh2`         | 〇                                          |


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

### svn log

オリジナルとフィルタリングした SVN のログを取得する。

[3.svnlog.sh](3.svnlog.sh) を使う。

### `svnlook log` & `svnadmin setlog`

* `svnlook log` でログを取得する゜
* [convert-svn-log.py](convert-svn-log.py) でログを修正する (revision, issue をリンクに変換して追記)
* `svnadmin setlog` でログを書き換える

[4.rewrite-svnlog.sh](4.rewrite-svnlog.sh) を使う。

### svn-all-fast-export

* ルールファイル [input.rules](input.rules) を指定して `svn-all-fast-export` で変換する。

[migrate.sh](migrate.sh) を使う。

## 制限事項

*  ([svn-all-fast-export](https://manpages.ubuntu.com/manpages/trusty/man1/svn-all-fast-export.1.html) で仮の値として [user-list.csv](user-list.csv) をもとに [make-identity-map.py](make-identity-map.py) で `identity-map` (svn ユーザー名と git の committer の対応関係) を生成して を渡して変換している。

## リビジョングラフ

[TortoiseGitによるリビジョングラフ](ttssh2.svg)
リンクを押したあと RAW を選ぶ。
グラフが巨大なのでスクロールして確認したところに移動する。


