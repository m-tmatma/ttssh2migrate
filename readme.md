# This repository contains scripts to migrate [ttssh2 SVN](http://svn.osdn.net/svnroot/ttssh2)

[ttssh2 SVN](http://svn.osdn.net/svnroot/ttssh2) を git に変換するためのスクリプト、設定ファイル群

## 変換手順

```
sudo apt install -y svn-all-fast-export
./1.mirror-ttssh2.sh
./2.filter-svndmp.sh
./migrate.sh
```

### 成果物

|  説明  | パス  |
| ---- | ---- |
|  gitリポジトリ  |  `workdir/gitdir/ttssh2`  |
|  変換元svnリポジトリ  |  `workdir/ttssh2`   |
|  オリジナルsvnリポジトリ  |  `workdir/ttssh2.org`  |

## 仕組み

https://github.com/svn-all-fast-export/svn2git を利用して、svn から git への変換を行う。

###  svn-all-fast-export

svn-all-fast-export は apt でインストールする。

## 変換手順詳細

### svn sync

`svn sync` を利用してリモートにあるリポジトリをローカルに取得する。
[1.mirror-ttssh2.sh](1.mirror-ttssh2.sh) を使う。

### svndumpfilter

* svnadmin dump` でダンプファイルを出力する。
* パイプでつないで、`svndumpfilter` で不要なファイルをフィルタリングする。
* パイプでつないで、`svnadmin load` で別のリポジトリにコミットする。

[2.filter-svndmp.sh](2.filter-svndmp.sh) を使う。

### svn-all-fast-export

* ルールファイル [input.rules](input.rules) を指定して `svn-all-fast-export` で変換する。

[migrate.sh](migrate.sh) を使う。


