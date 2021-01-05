#!/bin/bash

TODIR=/cygdrive/c/texlive/texmf-local/fonts/
MORI=mori-pas

# if test ! -d ${TODIR}/tfm; then
#     mkdir -v ${TODIR}/tfm
# fi
# if test ! -d ${TODIR}/vf; then
#     mkdir -v ${TODIR}/vf
# fi
# if test ! -d ${TODIR}/ovp; then
#     mkdir -v ${TODIR}/ovp
# fi
# if test ! -d ${TODIR}/map; then
#     mkdir -v ${TODIR}/map
# fi

mkdir -vp ${TODIR}/tfm/${MORI}
mkdir -vp ${TODIR}/vf/${MORI}
mkdir -vp ${TODIR}/ofm/${MORI}
#mkdir -vp ${TODIR}/ovp/${MORI}
mkdir -vp ${TODIR}/map/${MORI}

cp -auv tfm/ ${TODIR}/tfm/${MORI}
cp -auv vf/  ${TODIR}/vf/${MORI}
cp -auv ofm/  ${TODIR}/ofm/${MORI}
#cp -auv ovp/ ${TODIR}/ovp/${MORI}
cp -auv map/ ${TODIR}/map/${MORI}

