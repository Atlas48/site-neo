#!/usr/bin/bash
for i in $@; do
  echo $i
  sassc $i ../${i%.*}
done
