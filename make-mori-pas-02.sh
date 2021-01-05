#!/bin/bash

#
# This script is a part of otfbeta-uptex (a.k.a. japanese-otf-uptex).
#


ALL_FACE=();                    # 全フォント・ウェイト
MORISAWA_FACE=();               # モリサワ全フォント・ウェイト
MORISAWA_Ryumin_FACE=();        # モリサワ リュウミン フォント・ウェイト
HIRAGINO_FACE=();               # ヒラギノ全フォント・ウェイト
HIRAGINO_Min_FACE=();           # ヒラギノ明朝 ウェイト
HIRAGINO_notMin_FACE=();        # ヒラギノ明朝以外(角ゴ・丸ゴ)ウェイト
TBKOIN_FACE=();                 # TB古印


# モリサワとヒラギノとTBのフェイス作成
function set_face(){

    local face
    local wait

    # モリサワのファミリーとウェイト
    # local morisawa_family=(Ryumin ShinGo ShinMGo)
    # local morisawa_wait=(l r m b eb h eh u)

    # # モリサワ連結
    # for face in ${morisawa_family[@]}
    # do
    #     for wait in ${morisawa_wait[@]}
    #     do
    #         MORISAWA_FACE+=($face$wait)
    #     done
    # done

    # モリサワリュウミン。l r m b eb h eh u オールドとの混植もある
    for wait in l r m b eb h eh u
    do
        MORISAWA_FACE+=(Ryumin$wait)
        MORISAWA_Ryumin_FACE+=(Ryumin$wait)
    done

    # モリサワ・新ゴウェイト
    for wait in el l r m db b h u
    do
        MORISAWA_FACE+=(ShinGo$wait)
    done

    # モリサワ・新丸ゴウェイト
    for wait in l r m db b h u
    do
        MORISAWA_FACE+=(ShinMGo$wait)
    done

    # ヒラギノ明朝のウェイト W2-W8
    for wait in {2..8}
    do
        HIRAGINO_Min_FACE+=(HiraMinw$wait)
    done
    

    # ヒラギノ角ゴのウェイト W0-W9
    for wait in {0..9}
    do
        HIRAGINO_Kaku_FACE+=(HiraKakuw$wait)
    done

    # ヒラギノ丸ゴのウェイト W2-W6, W8
    for wait in {2..6} 8
    do
        HIRAGINO_Maru_FACE+=(HiraMaruw$wait)
    done

    HIRAGINO_notMin_FACE+=(${HIRAGINO_Kaku_FACE[@]} ${HIRAGINO_Maru_FACE[@]})
    
    HIRAGINO_FACE+=(${HIRAGINO_Min_FACE[@]} ${HIRAGINO_Kaku_FACE[@]} ${HIRAGINO_Maru_FACE[@]})

    # TB古印は1個だけ。
    TBKOIN_FACE=(TBkoinm);

    # 全結合
    ALL_FACE+=(${MORISAWA_FACE[@]} ${HIRAGINO_FACE[@]} ${TBKOIN_FACE[@]})

}


# pre処理にフォルダ作成
function pre_mkdir(){
    # setting for ovp2ovf & uppltotf
    . ./umakeotf_pre

    if test ! -d tfm; then
        mkdir tfm
    fi
    if test ! -d vf; then
        mkdir vf
    fi
}

# TFM 作成
function make_tfm(){
    # CID 用 tfm 作成
    perl script/mp-mktfm.pl ${ALL_FACE[@]}

    # 普通にtfmファイルを生成
    for face in ${ALL_FACE[@]}
    do
        for hv in h v
        do
            echo ${face}-${hv}
            # pLaTeX
            #        ppltotf basepl/base-${hv}.pl tfm/${face}-${hv}
            ppltotf basepl/base-${hv}.pl tfm/nml${face}-${hv}
            ppltotf basepl/base-${hv}.pl tfm/exp${face}-${hv}
            ppltotf basepl/base-${hv}.pl tfm/ruby${face}-${hv}
            ppltotf basepl/brsg-${hv}.pl tfm/brsgnml${face}-${hv}
            ppltotf basepl/brsg-${hv}.pl tfm/brsgexp${face}-${hv}
            # pLaTeX jis2004
            #        ppltotf basepl/base-${hv}.pl tfm/${face}n-${hv}
            ppltotf basepl/base-${hv}.pl tfm/nml${face}n-${hv}
            ppltotf basepl/base-${hv}.pl tfm/exp${face}n-${hv}
            ppltotf basepl/brsg-${hv}.pl tfm/brsgnml${face}n-${hv}
            ppltotf basepl/brsg-${hv}.pl tfm/brsgexp${face}n-${hv}
            # upLaTex
            #        uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/up${face}-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upnml${face}-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upexp${face}-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upruby${face}-${hv}
            uppltotf -kanji=uptex basepl/ubrsg-${hv}.pl tfm/upbrsgnml${face}-${hv}
            uppltotf -kanji=uptex basepl/ubrsg-${hv}.pl tfm/upbrsgexp${face}-${hv}
            # upLaTex jis2004
            #        uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/up${face}n-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upnml${face}n-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upexp${face}n-${hv}
            uppltotf -kanji=uptex basepl/ubrsg-${hv}.pl tfm/upbrsgnml${face}n-${hv}
            uppltotf -kanji=uptex basepl/ubrsg-${hv}.pl tfm/upbrsgexp${face}n-${hv}
        done
    done

    # cid 用作成
    for face in ${ALL_FACE[@]}
    do
        ppltotf basepl/base0-h.pl tfm/cidj${face}0-h.tfm
        ppltotf basepl/base2-h.pl tfm/cidj${face}2-h.tfm
        ppltotf basepl/base2-v.pl tfm/cidj${face}2-v.tfm
        ppltotf basepl/base3-v.pl tfm/cidj${face}3-v.tfm
    done
}

# オールドがな用TFM作成
function make_tfm_old(){
    # リュウミン＋リュウミンオールドがな用tfm作成
    for face in ${MORISAWA_Ryumin_FACE[@]}
    do
        for hv in h v
        do
            echo ${face}-${hv} old
            ppltotf basepl/base-${hv}.pl tfm/old${face}-${hv}
            ppltotf basepl/brsg-${hv}.pl tfm/brsgold${face}-${hv}
            ppltotf basepl/base-${hv}.pl tfm/old${face}n-${hv}
            ppltotf basepl/brsg-${hv}.pl tfm/brsgold${face}n-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upold${face}-${hv}
            uppltotf -kanji=uptex basepl/ubrsg-${hv}.pl tfm/upbrsgold${face}-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upold${face}n-${hv}
            uppltotf -kanji=uptex basepl/ubrsg-${hv}.pl tfm/upbrsgold${face}n-${hv}
        done
    done

    # ヒラギノ明朝＋游築五号仮名用tfm作成
    for face in ${HIRAGINO_Min_FACE[@]}
    do
        for hv in h v
        do
            echo ${face}-${hv} old
            ppltotf basepl/base-${hv}.pl tfm/old${face}-${hv}
            ppltotf basepl/brsg-${hv}.pl tfm/brsgold${face}-${hv}
            ppltotf basepl/base-${hv}.pl tfm/old${face}n-${hv}
            ppltotf basepl/brsg-${hv}.pl tfm/brsgold${face}n-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upold${face}-${hv}
            uppltotf -kanji=uptex basepl/ubrsg-${hv}.pl tfm/upbrsgold${face}-${hv}
            uppltotf -kanji=uptex basepl/ubase-${hv}.pl tfm/upold${face}n-${hv}
            uppltotf -kanji=uptex basepl/ubrsg-${hv}.pl tfm/upbrsgold${face}n-${hv}
        done
    done
}


# VF 作成 UTF CID
function make_vf_utfcid(){
    echo "making vf (wait a while)..."

    perl script/mp-mkutfvf.pl ${ALL_FACE[@]}
    echo "vf for utf finished. making vf for cid..."

    perl script/mp-mkcidvf.pl ${ALL_FACE[@]}
    echo "vf for cid finished."

    #perl script/mp-mkmlcidvf.pl ${ALL_FACE[@]}
    #echo "making vf for alt. utf..."
    #perl script/mp-mkaltutfvf.pl ${ALL_FACE[@]}

    echo "making tfm/vf for UTF jp04 (wait a while)..."
    perl script/mp-mkjp04tfmvf.pl ${ALL_FACE[@]}
    echo "tfm/vf for UTF jp04 finished"

}

# ruby, expert, cid_minute(-cm), cid_quote(-cq), jis2004, cid_hankana(-chk)
# ならば、&get_faceしている。

# pLaTeX用もumkjvfで作ってみる。

# 混植などしない普通のvf作成
function make_vf_normal(){
    local DSCALE_COM
    local dscale
    
    dscale=$1
    shift
   
    if [ `echo "!($dscale == 1 || $dscale == 0)" | bc` == 1 ] ;then
        DSCALE_COM="-dscale $dscale"
    fi

    for face in $@
    do
        echo ${face}

        ./mp-umkjvf               $DSCALE_COM         -CID cidj${face}           nml${face}-h  h${face}-h
        ./mp-umkjvf       -cm -cp $DSCALE_COM         -CID cidj${face}           nml${face}-v  h${face}-v
        ./mp-umkjvf               $DSCALE_COM -expert -CID cidj${face}           exp${face}-h  h${face}-h
        ./mp-umkjvf       -cm -cp $DSCALE_COM -expert -CID cidj${face}           exp${face}-v  h${face}-v
        ./mp-umkjvf               $DSCALE_COM -ruby   -CID cidj${face}          ruby${face}-h  h${face}-h
        ./mp-umkjvf       -cm -cp $DSCALE_COM -ruby   -CID cidj${face}          ruby${face}-v  h${face}-v
        
        ./mp-umkjvf -sage         $DSCALE_COM         -CID cidj${face}       brsgnml${face}-h  h${face}-h
        ./mp-umkjvf -sage -cm -cp $DSCALE_COM         -CID cidj${face}       brsgnml${face}-v  h${face}-v
        ./mp-umkjvf -sage         $DSCALE_COM -expert -CID cidj${face}       brsgexp${face}-h  h${face}-h
        ./mp-umkjvf -sage -cm -cp $DSCALE_COM -expert -CID cidj${face}       brsgexp${face}-v  h${face}-v
        
        ./mp-umkjvf -jp04               $DSCALE_COM         -CID cidj${face}     nml${face}n-h h${face}n-h
        ./mp-umkjvf -jp04 -cm -cp       $DSCALE_COM         -CID cidj${face}     nml${face}n-v h${face}n-v
        ./mp-umkjvf -jp04               $DSCALE_COM -expert -CID cidj${face}     exp${face}n-h h${face}n-h
        ./mp-umkjvf -jp04 -cm -cp       $DSCALE_COM -expert -CID cidj${face}     exp${face}n-v h${face}n-v
        ./mp-umkjvf -jp04 -sage         $DSCALE_COM         -CID cidj${face} brsgnml${face}n-h h${face}n-h
        ./mp-umkjvf -jp04 -sage -cm -cp $DSCALE_COM         -CID cidj${face} brsgnml${face}n-v h${face}n-v
        ./mp-umkjvf -jp04 -sage         $DSCALE_COM -expert -CID cidj${face} brsgexp${face}n-h h${face}n-h
        ./mp-umkjvf -jp04 -sage -cm -cp $DSCALE_COM -expert -CID cidj${face} brsgexp${face}n-v h${face}n-v
        

        ./mp-umkjvf -ucs -sp 1       -cq     $DSCALE_COM         -CID cidj${face}     upnml${face}-h  uph${face}-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp $DSCALE_COM         -CID cidj${face}     upnml${face}-v  uph${face}-v
        ./mp-umkjvf -ucs -sp 1       -cq     $DSCALE_COM -expert -CID cidj${face}     upexp${face}-h  uph${face}-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp $DSCALE_COM -expert -CID cidj${face}     upexp${face}-v  uph${face}-v
        ./mp-umkjvf -ucs -sp 1       -cq     $DSCALE_COM -ruby   -CID cidj${face}    upruby${face}-h  uph${face}-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp $DSCALE_COM -ruby   -CID cidj${face}    upruby${face}-v  uph${face}-v

        ./mp-umkjvf -ucs -sp 1 -sage -cq     $DSCALE_COM         -CID cidj${face} upbrsgnml${face}-h  uph${face}-h
        ./mp-umkjvf -ucs -sp 1 -sage -cm -cp $DSCALE_COM         -CID cidj${face} upbrsgnml${face}-v  uph${face}-v
        ./mp-umkjvf -ucs -sp 1 -sage -cq     $DSCALE_COM -expert -CID cidj${face} upbrsgexp${face}-h  uph${face}-h
        ./mp-umkjvf -ucs -sp 1 -sage -cm -cp $DSCALE_COM -expert -CID cidj${face} upbrsgexp${face}-v  uph${face}-v

        # jp04
        ./mp-umkjvf -ucs -sp 1       -cq     $DSCALE_COM         -CID cidj${face}     upnml${face}n-h uph${face}n-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp $DSCALE_COM         -CID cidj${face}     upnml${face}n-v uph${face}n-v
        ./mp-umkjvf -ucs -sp 1       -cq     $DSCALE_COM -expert -CID cidj${face}     upexp${face}n-h uph${face}n-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp $DSCALE_COM -expert -CID cidj${face}     upexp${face}n-v uph${face}n-v
        ./mp-umkjvf -ucs -sp 1 -sage -cq     $DSCALE_COM         -CID cidj${face} upbrsgnml${face}n-h uph${face}n-h
        ./mp-umkjvf -ucs -sp 1 -sage -cm -cp $DSCALE_COM         -CID cidj${face} upbrsgnml${face}n-v uph${face}n-v
        ./mp-umkjvf -ucs -sp 1 -sage -cq     $DSCALE_COM -expert -CID cidj${face} upbrsgexp${face}n-h uph${face}n-h
        ./mp-umkjvf -ucs -sp 1 -sage -cm -cp $DSCALE_COM -expert -CID cidj${face} upbrsgexp${face}n-v uph${face}n-v
    done
}


# モリサワ用VF作成
function make_vf_morisawa(){
    echo "making vf for morisawa"

    make_vf_normal 0 ${MORISAWA_FACE[@]}
}

# リュウミン＋リュウミンオールドがな用VF作成
function make_vf_morisawa_old(){

    # リュウミン＋リュウミンオールドがな
    for face in ${MORISAWA_Ryumin_FACE[@]}
    do
        echo ${face} old

        ./mp-umkjvf                             -CID cidj${face}     old${face}-h  h${face}-h  r-${face}old-h
        ./mp-umkjvf             -cm -cp         -CID cidj${face}     old${face}-v  h${face}-v  r-${face}old-v
        ./mp-umkjvf       -sage                 -CID cidj${face} brsgold${face}-h  h${face}-h  r-${face}old-h
        ./mp-umkjvf       -sage -cm -cp         -CID cidj${face} brsgold${face}-v  h${face}-v  r-${face}old-v
        
        ./mp-umkjvf -jp04                       -CID cidj${face}     old${face}n-h h${face}n-h r-${face}old-h
        ./mp-umkjvf -jp04       -cm -cp         -CID cidj${face}     old${face}n-v h${face}n-v r-${face}old-v
        ./mp-umkjvf -jp04 -sage                 -CID cidj${face} brsgold${face}n-h h${face}n-h r-${face}old-h
        ./mp-umkjvf -jp04 -sage -cm -cp         -CID cidj${face} brsgold${face}n-v h${face}n-v r-${face}old-v

        ./mp-umkjvf -ucs -sp 1       -cq        -CID cidj${face}          upold${face}-h  uph${face}-h  upr-${face}old-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp    -CID cidj${face}          upold${face}-v  uph${face}-v  upr-${face}old-v
        ./mp-umkjvf -ucs -sp 1 -sage -cq        -CID cidj${face}      upbrsgold${face}-h  uph${face}-h  upr-${face}old-h
        ./mp-umkjvf -ucs -sp 1 -sage -cm -cp    -CID cidj${face}      upbrsgold${face}-v  uph${face}-v  upr-${face}old-v

        # jp04
        ./mp-umkjvf -ucs -sp 1       -cq        -CID cidj${face}          upold${face}n-h uph${face}n-h upr-${face}old-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp    -CID cidj${face}          upold${face}n-v uph${face}n-v upr-${face}old-v
        ./mp-umkjvf -ucs -sp 1 -sage -cq        -CID cidj${face}      upbrsgold${face}n-h uph${face}n-h upr-${face}old-h
        ./mp-umkjvf -ucs -sp 1 -sage -cm -cp    -CID cidj${face}      upbrsgold${face}n-v uph${face}n-v upr-${face}old-v
    done
}

# ヒラギノ用VF作成
function make_vf_hiragino(){
    # ヒラギノ明朝・角ゴ・丸ゴ

    make_vf_normal 1.1351 ${HIRAGINO_Min_FACE[@]}
    make_vf_normal 1.1351 ${HIRAGINO_Kaku_FACE[@]}
    make_vf_normal 1.2063 ${HIRAGINO_Maru_FACE[@]}

    # ヒラギノ明朝 W4 W5 の横組用
    for face in HiraMinw4
    do
        echo ${face}

        ./mp-umkjvf               -dscale 1.1351         -CID cidj${face}           exp${face}-h  h${face}-h  r-HiraMinHKw4-h
        ./mp-umkjvf -sage         -dscale 1.1351         -CID cidj${face}       brsgexp${face}-h  h${face}-h  r-HiraMinHKw4-h
        ./mp-umkjvf -jp04         -dscale 1.1351         -CID cidj${face}           exp${face}n-h h${face}n-h r-HiraMinHKw4-h
        ./mp-umkjvf -jp04 -sage   -dscale 1.1351         -CID cidj${face}       brsgexp${face}n-h h${face}n-h r-HiraMinHKw4-h

        ./mp-umkjvf -ucs -sp 1       -cq     -dscale 1.1351         -CID cidj${face}     upexp${face}-h  uph${face}-h upr-HiraMinHKw4-h
        ./mp-umkjvf -ucs -sp 1 -sage -cq     -dscale 1.1351         -CID cidj${face} upbrsgexp${face}-h  uph${face}-h upr-HiraMinHKw4-h
        ./mp-umkjvf -ucs -sp 1       -cq     -dscale 1.1351         -CID cidj${face}     upexp${face}n-h uph${face}n-h upr-HiraMinHKw4-h
        ./mp-umkjvf -ucs -sp 1 -sage -cq     -dscale 1.1351         -CID cidj${face} upbrsgexp${face}n-h uph${face}n-h upr-HiraMinHKw4-h
    done

    for face in HiraMinw5
    do
        echo ${face}

        ./mp-umkjvf               -dscale 1.1351         -CID cidj${face}           exp${face}-h  h${face}-h  r-HiraMinHKw5-h
        ./mp-umkjvf -sage         -dscale 1.1351         -CID cidj${face}       brsgexp${face}-h  h${face}-h  r-HiraMinHKw5-h
        ./mp-umkjvf -jp04         -dscale 1.1351         -CID cidj${face}           exp${face}n-h h${face}n-h r-HiraMinHKw5-h
        ./mp-umkjvf -jp04 -sage   -dscale 1.1351         -CID cidj${face}       brsgexp${face}n-h h${face}n-h r-HiraMinHKw5-h

        ./mp-umkjvf -ucs -sp 1       -cq     -dscale 1.1351         -CID cidj${face}     upexp${face}-h  uph${face}-h upr-HiraMinHKw5-h
        ./mp-umkjvf -ucs -sp 1 -sage -cq     -dscale 1.1351         -CID cidj${face} upbrsgexp${face}-h  uph${face}-h upr-HiraMinHKw5-h
        ./mp-umkjvf -ucs -sp 1       -cq     -dscale 1.1351         -CID cidj${face}     upexp${face}n-h uph${face}n-h upr-HiraMinHKw5-h
        ./mp-umkjvf -ucs -sp 1 -sage -cq     -dscale 1.1351         -CID cidj${face} upbrsgexp${face}n-h uph${face}n-h upr-HiraMinHKw5-h
    done

}

# ヒラギノ明朝＋游築五号仮名
function make_vf_hiragino_yutuki(){
    # ヒラギノ明朝＋游築五号仮名
    for face in ${HIRAGINO_Min_FACE[@]}
    do
        echo ${face} old

        ./mp-umkjvf                     -ck -dscale 1.1351       -CID cidj${face}       old${face}-h  h${face}-h  r-${face}old-h
        ./mp-umkjvf             -cm -cp -ck -dscale 1.1351       -CID cidj${face}       old${face}-v  h${face}-v  r-${face}old-v
        ./mp-umkjvf       -sage         -ck -dscale 1.1351       -CID cidj${face}   brsgold${face}-h  h${face}-h  r-${face}old-h
        ./mp-umkjvf       -sage -cm -cp -ck -dscale 1.1351       -CID cidj${face}   brsgold${face}-v  h${face}-v  r-${face}old-v
        
        ./mp-umkjvf -jp04               -ck -dscale 1.1351       -CID cidj${face}       old${face}n-h h${face}n-h r-${face}old-h
        ./mp-umkjvf -jp04       -cm -cp -ck -dscale 1.1351       -CID cidj${face}       old${face}n-v h${face}n-v r-${face}old-v
        ./mp-umkjvf -jp04 -sage         -ck -dscale 1.1351       -CID cidj${face}   brsgold${face}n-h h${face}n-h r-${face}old-h
        ./mp-umkjvf -jp04 -sage -cm -cp -ck -dscale 1.1351       -CID cidj${face}   brsgold${face}n-v h${face}n-v r-${face}old-v

        ./mp-umkjvf -ucs -sp 1       -cq     -ck -dscale 1.1351  -CID cidj${face}            upold${face}-h  uph${face}-h  upr-${face}old-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp -ck -dscale 1.1351  -CID cidj${face}            upold${face}-v  uph${face}-v  upr-${face}old-v
        ./mp-umkjvf -ucs -sp 1 -sage -cq     -ck -dscale 1.1351  -CID cidj${face}        upbrsgold${face}-h  uph${face}-h  upr-${face}old-h
        ./mp-umkjvf -ucs -sp 1 -sage -cm -cp -ck -dscale 1.1351  -CID cidj${face}        upbrsgold${face}-v  uph${face}-v  upr-${face}old-v

        # jp04
        ./mp-umkjvf -ucs -sp 1       -cq     -ck -dscale 1.1351  -CID cidj${face}            upold${face}n-h uph${face}n-h upr-${face}old-h
        ./mp-umkjvf -ucs -sp 1       -cm -cp -ck -dscale 1.1351  -CID cidj${face}            upold${face}n-v uph${face}n-v upr-${face}old-v
        ./mp-umkjvf -ucs -sp 1 -sage -cq     -ck -dscale 1.1351  -CID cidj${face}        upbrsgold${face}n-h uph${face}n-h upr-${face}old-h
        ./mp-umkjvf -ucs -sp 1 -sage -cm -cp -ck -dscale 1.1351  -CID cidj${face}        upbrsgold${face}n-v uph${face}n-v upr-${face}old-v
    done
}
    

# TB古印用VF作成
function make_vf_TBkoin(){
    # TB古印

    make_vf_normal 1.1351 ${TBKOIN_FACE[@]}
}


# supplementary plane
function make_supplementary_plane(){
    echo "making tfm for supplementary plane ..."
    perl script/mp-mktfm_sp.pl ${ALL_FACE[@]}
    echo "making vf for supplementary plane ..."
    perl script/mp-mkutfvf_sp.pl ${ALL_FACE[@]}



    echo "making ofm file for dvipdfmx in CVS"
    perl script/mp-mkcidofm.pl ${ALL_FACE[@]}
    # perl script/mkpropofm.pl

    # echo "making tfm/vf for UTF jp04 (wait a while)..."
    # perl script/mkjp04tfmvf.pl
    # echo "making tfm for jp04 ..."

    # echo "making tfm for supplementary plane ..."
    # perl script/mktfm_sp.pl
    # echo "making vf for supplementary plane ..."
    # perl script/mkutfvf_sp.pl
}

# 最後
function finish_func(){
    echo "finishing ..."
    if test ! -d vf; then
        mkdir vf
    fi
    mv *.vf vf/
    mv *.tfm tfm/
    rm -rf ovp
}

# ここから実際の処理をスタート
# ::start


# モリサワとヒラギノとTBのフェイス作成
set_face
echo ${ALL_FACE[@]}

# pre処理にフォルダ作成
pre_mkdir

# TFM 作成
make_tfm

# オールドがな用TFM作成
make_tfm_old

# VF 作成 UTF CID
make_vf_utfcid

# モリサワ用VF作成
make_vf_morisawa

# リュウミン＋リュウミンオールドがな用VF作成
make_vf_morisawa_old

# ヒラギノ用VF作成
make_vf_hiragino

# ヒラギノ明朝＋游築五号仮名用VF作成
make_vf_hiragino_yutuki

# TB古印用VF作成
make_vf_TBkoin

# supplementary plane
make_supplementary_plane

# 最後
finish_func

