#!/bin/bash -eu

echo 'init process'

MYSQL="mysql -u isucon -pisucon isucon"
$MYSQL <<EOF
CREATE INDEX memos_idx_is_private_created_at ON memos (is_private,created_at);
CREATE INDEX memos_idx_user_created_at ON memos (user,created_at);
CREATE INDEX memos_idx_user_is_private_created_at ON memos (user,is_private,created_at);
EOF

# Migration
$MYSQL << EOF
DROP TABLE IF EXISTS public_memos;
CREATE TABLE public_memos (
  id int(11) NOT NULL AUTO_INCREMENT,
  memo int(11) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
INSERT INTO public_memos (memo) SELECT id FROM memos WHERE is_private=0 ORDER BY created_at, id;
EOF
