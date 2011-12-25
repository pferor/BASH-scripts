#!/bin/bash
#
# Pferor <pferor [AT] gmail [DOT] com>
# Wed Apr  8 11:42:35 UTC 2009
#
# REQUIREMENTS
#  * qsdown.sh (must be in the same directory as this script)
#
# USAGE EXAMPLES
#  1. Downloads "Leisure Suit Larry", "Space Quest" and "King's
#     Quest" soundtracks
#       $ ./sierra_st -LSK
#
#  2. Downloads "Heart of China" soundtrack in "my_folder" folder
#       $ ./sierra_st -d my_folder -H
#
# TODO
#  * Make qsdown.sh be anywhere in path... it's easy, but
#    qsdown.sh's output must be refered to this script CWD.
#
#  * Make this script more... harmonic.
#


# Folders information
F_SOUNDTRACKS="Soundtracks" # default download folder
F_CURRENT="$(pwd)/"         # current directory


# usage
function show_usage
{
    echo "Usage: $(basename ${0}) <options>"
    echo ""
    echo "  Main options:"
    echo "    -a       Download all soundtracks"
    echo "    -d <dir> Download folder (default: './$F_SOUNDTRACKS')"
    echo "    -h       Displays this help"
    echo ""
    echo "  Soundtracks:"
    echo "    -A       Conquests of Camelot"
    echo "    -B       The Colonel's Bequest"
    echo "    -C       Code-Name: Iceman"
    echo "    -D       Laura Bow in the Dagger of Amon Ra"
    echo "    -E       Eco Quest"
    echo "    -H       Heart of China"
    echo "    -I       Inca/Inca 2"
    echo "    -K       King's Quest (V, VI)"
    echo "    -L       Leisure Suit Larry (I, III, V, VI)"
    echo "    -O       Sorcerian"
    echo "    -P       Police Quest (I, II, III)"
    echo "    -Q       Quest for Glory (II, III, IV, V)"
    echo "    -R       Hero's Quest"
    echo "    -S       Space Quest (I, IV, V, VI)"
    echo "    -T       Betrayal at Krondor"
    echo "    -Z       Silpheed"
}


# initial values (classical boolean style)
D_COC=0 # download Conquests of Camelot soundtrack
D_CBQ=0 # download Colonel's Bequest soundtrack
D_CNI=0 # download Code-Name: Iceman soundtrack
D_DAR=0 # download Laura Bow in the Dagger of Amon Ra soundtrack
D_EQ=0  # download Eco Quest soundtrack
D_HOC=0 # download Heart of China soundtrack
D_KQ=0  # download King's Quest soundtrack
D_INC=0 # download Inca/Inca 2 soundtrack
D_LSL=0 # download Leisure Suit Larry soundtrack
D_SOR=0 # download Sorcerian soundtrack
D_PQ=0  # download Police Quest soundtrack
D_QG=0  # download Quest for Glory soundtrack
D_HQ=0  # download Hero's Quest soundtrack
D_SQ=0  # download Space Quest soundtrack
D_BK=0  # download Betrayal at Krondor soundtrack
D_SIL=0 # download Silpheed soundtrack

# get options
while getopts "ad:hABCDEHIKLOPQRSTZ" OPTION
do
    case $OPTION in
        a)
            D_COC=1 # download Conquests of Camelot soundtrack
            D_CBQ=1 # download Colonel's Bequest soundtrack
            D_CNI=1 # download Code-Name: Iceman soundtrack
            D_DAR=1 # download Laura Bow in the Dagger of Amon Ra soundtrack
            D_EQ=1  # download Eco Quest soundtrack
            D_HOC=1 # download Heart of China soundtrack
            D_KQ=1  # download King's Quest soundtrack
            D_INC=1 # download Inca/Inca 2 soundtrack
            D_LSL=1 # download Leisure Suit Larry soundtrack
            D_SOR=1 # download Sorcerian soundtrack
            D_PQ=1  # download Police Quest soundtrack
            D_QG=1  # download Quest for Glory soundtrack
            D_HQ=1  # download Hero's Quest soundtrack
            D_SQ=1  # download Space Quest soundtrack
            D_BK=1  # download Betrayal at Krondor soundtrack
            D_SIL=1 # download Silpheed soundtrack
            ;;
        d)
            F_SOUNDTRACKS="$OPTARG"
            ;;
        h)
            show_usage
            exit 0
            ;;
        A)
            D_COC=1 # download Conquests of Camelot soundtrack
            ;;
        B)
            D_CBQ=1 # download Colonel's Bequest soundtrack
            ;;
        C)
            D_CNI=1 # download Code-Name: Iceman
            ;;
        D)
            D_DAR=1 # download Laura Bow in the Dagger of Amon Ra soundtrack
            ;;
        E)
            D_EQ=1 # download Eco Quest soundtrack
            ;;
        H)
            D_HOC=1 # download Heart of China soundtrack
            ;;
        I)
            D_INC=1 # download Inca/Inca 2 soundtrack
            ;;
        K)
            D_KQ=1 # dwonload King's Quest soundtrack
            ;;
        L)
            D_LSL=1 # download Leisure Suit Larry soundtrack
            ;;
        O)
            D_SOR=1 # download Sorcerian soundtrack
            ;;
        P)
            D_PQ=1 # download Police Quest soundtrack
            ;;
        Q)
            D_QG=1 # download Quest for Glory soundtrack
            ;;
        R)
            D_HQ=1 # download Hero's Quest soundtrack
            ;;
        S)
            D_SQ=1 # download Space Quest soundtrack
            ;;
        T)
            D_BK=1 # download Betrayal at Krondor soundtrack
            ;;
        Z)
            D_SIL=1 # download Silpheed soundtrack
            ;;
        ?)
            show_usage
            exit 1
            ;;
    esac
done

## VALIDATION ########################################################
# There must be at least one argument
if [[ ${#} -lt 1 ]]
then
    show_usage
    exit 1
fi

# check files --------------------
if [[ ! -x "${F_CURRENT}qsdown.sh" ]]
then
    echo "Error: qsdown.sh not found" >&2
    exit 1
fi


## DOWNLOAD ##########################################################
# begin --------------------------
echo "All soundtracks are downloaded from http://queststudios.com/"
echo ""


if [[ ! -d ${F_SOUNDTRACKS} ]]
then
    echo "Creating soundtracks folder (${F_SOUNDTRACKS})..."
    echo ""
    mkdir ${F_SOUNDTRACKS}
fi


# download conquests of camelot soundtrack
if [[ ${D_COC} -eq 1 ]]
then
    echo "CONQUESTS OF CAMELOT -------------------------------------"

        # directories
    F_COC=${F_SOUNDTRACKS}"/Conquests_of_Camelot"

    # coc
    echo "Preparing to download Conquests of Camelot soundtrack..."
    if [[ ! -d ${F_COC} ]]
    then
        echo "Creating folder ${F_COC}..."
        mkdir -p ${F_COC}
    fi
    echo ""

    cd ${F_COC}
    sh ${F_CURRENT}qsdown.sh -F camelot -t 27 -z
    cd ../..
fi


# download colonel's bequest soundtrack
if [[ ${D_CBQ} -eq 1 ]]
then
    echo "THE COLONEL'S BEQUEST ------------------------------------"

    # directories
    F_CBQ=${F_SOUNDTRACKS}"/Colonels_Bequest__The"

    # cbq
    echo "Preparing to download The Colonel's Bequest soundtrack..."
    if [[ ! -d ${F_CBQ} ]]
    then
        echo "Creating folder ${F_CBQ}..."
        mkdir -p ${F_CBQ}
    fi
    echo ""

    cd ${F_CBQ}
    sh ${F_CURRENT}qsdown.sh -F cbcd -t 31 -z
    cd ../..
fi


# download code name iceman soundtrack
if [[ ${D_CNI} -eq 1 ]]
then
    echo "CODE-NAME: ICEMAN ----------------------------------------"

    # directories
    F_CNI=${F_SOUNDTRACKS}"/Code-Name__Iceman"

    # cdi
    echo "Preparing to download Code-Name: Iceman soundtrack..."
    if [[ ! -d ${F_CNI} ]]
    then
        echo "Creating folder ${F_CNI}..."
        mkdir -p ${F_CNI}
    fi
    echo ""

    cd ${F_CNI}
    sh ${F_CURRENT}qsdown.sh -F cnicd -p CNI -t 24 -z
    cd ../..
fi


# download dagger of amon ra soundtrack
if [[ ${D_DAR} -eq 1 ]]
then
    echo "LAURA BOW IN THE DAGGER OF AMON RA -----------------------"

    # directories
    F_DAR=${F_SOUNDTRACKS}"/Laura_Bow_in__The_Dagger_of_Amon_Ra"

    # dar
    echo "Preparing to download Laura Bow and the Dagger of Amon Ra soundtrack..."
    if [[ ! -d ${F_DAR} ]]
    then
        echo "Creating folder ${F_DAR}..."
        mkdir -p ${F_DAR}
    fi
    echo ""

    cd ${F_DAR}
    sh ${F_CURRENT}qsdown.sh -F lb2cd -t 35 -z
    cd ../..
fi


# download eco quest soundtrack
if [[ ${D_EQ} -eq 1 ]]
then
    echo "ECO QUEST ------------------------------------------------"

    # directories
    F_EQ=${F_SOUNDTRACKS}"/Eco_Quest"

    # eq
    echo "Preparing to download Eco Quest soundtrack..."
    if [[ ! -d ${F_EQ} ]]
    then
        echo "Creating folder ${F_EQ}..."
        mkdir -p ${F_EQ}
    fi
    echo ""

    cd ${F_EQ}
    sh ${F_CURRENT}qsdown.sh -F eq1cd -t 26 -z
    cd ../..
fi


# download heart of china soundtrack
if [[ ${D_HOC} -eq 1 ]]
then
    echo "HEART OF CHINA -------------------------------------------"

    # directories
    F_HOC=${F_SOUNDTRACKS}"/Heart_of_China"

    # hoc
    echo "Preparing to download Heart of China soundtrack..."
    if [[ ! -d ${F_HOC} ]]
    then
        echo "Creating folder ${F_HOC}..."
        mkdir -p ${F_HOC}
    fi
    echo ""

    cd ${F_HOC}
    sh ${F_CURRENT}qsdown.sh -F hoc -t 41 -z
    cd ../..
fi


# download inca soundtrack
if [[ ${D_INC} -eq 1 ]]
then
    echo "INCA/INCA 2 ----------------------------------------------"

    # directories
    F_INC=${F_SOUNDTRACKS}"/Inca__I_II"

    # hoc
    echo "Preparing to download Inca soundtrack..."
    if [[ ! -d ${F_INC} ]]
    then
        echo "Creating folder ${F_INC}..."
        mkdir -p ${F_INC}
    fi
    echo ""

    cd ${F_INC}
    sh ${F_CURRENT}qsdown.sh -F incacd -t 26 -z
    cd ../..
fi


# download leisure suit larry soundtrack
if [[ ${D_LSL} -eq 1 ]]
then
    echo "LEISURE SUIT LARRY ---------------------------------------"

    # directories
    F_LSL=${F_SOUNDTRACKS}"/Leisure_Suit_Larry"
    F_LSL1=${F_LSL}"/Leisure_Suit_Larry__1"
    F_LSL3=${F_LSL}"/Leisure_Suit_Larry__3"
    F_LSL5=${F_LSL}"/Leisure_Suit_Larry__5"
    F_LSL6=${F_LSL}"/Leisure_Suit_Larry__6"

    # lsl1
    echo "Preparing to download Leisure suit Larry 1 soundtrack..."
    if [[ ! -d ${F_LSL1} ]]
    then
        echo "Creating folder ${F_LSL1}..."
        mkdir -p ${F_LSL1}
    fi
    echo ""

    cd ${F_LSL1}
    sh ${F_CURRENT}qsdown.sh -F lsl1cd -p LSL1 -t 17 -z
    cd ../../..


    # lsl3
    echo "Preparing to download Leisure suit Larry 3 soundtrack..."
    if [[ ! -d ${F_LSL3} ]]
    then
        echo "Creating folder ${F_LSL3}..."
        mkdir -p ${F_LSL3}
    fi
    echo ""

    cd ${F_LSL3}
    sh ${F_CURRENT}qsdown.sh -F lsl3cd -t 37 -T track -z
    cd ../../..


    # lsl5
    echo "Preparing to download Leisure suit Larry 5 soundtrack..."
    if [[ ! -d ${F_LSL5} ]]
    then
        echo "Creating folder ${F_LSL5}..."
        mkdir -p ${F_LSL5}
    fi
    echo ""

    cd ${F_LSL5}
    sh ${F_CURRENT}qsdown.sh -F lsl5cd -t 36 -z
    cd ../../..


    # lsl6
    echo "Preparing to download Leisure suit Larry 6 soundtrack..."
    if [[ ! -d ${F_LSL6} ]]
    then
        echo "Creating folder ${F_LSL6}..."
        mkdir -p ${F_LSL6}
    fi
    echo ""

    cd ${F_LSL6}
    sh ${F_CURRENT}qsdown.sh -F lsl6cd -t 24 -P LSL6_ -m mp3 -z
    cd ../../..
fi


# download sorcerian soundtrack
if [[ ${D_SOR} -eq 1 ]]
then
    echo "SORCERIAN ------------------------------------------------"

    # directories
    F_SOR=${F_SOUNDTRACKS}"/Sorcerian"
    F_SOR_1=${F_SOR}"/CD1"
    F_SOR_2=${F_SOR}"/CD2"

    # sor - cd 1
    echo "Preparing to download Sorcerian Disc #1 soundtrack..."
    if [[ ! -d ${F_SOR_1} ]]
    then
        echo "Creating folder ${F_SOR_1}..."
        mkdir -p ${F_SOR_1}
    fi
    echo ""

    cd ${F_SOR_1}
    sh ${F_CURRENT}qsdown.sh -F Sorcerian -p SOR_CD1_ -t 30 -m mp3 -z
    cd ../../..


    # sor - cd 2
    echo "Preparing to download Sorcerian Disc #2 soundtrack..."
    if [[ ! -d ${F_SOR_2} ]]
    then
        echo "Creating folder ${F_SOR_2}..."
        mkdir -p ${F_SOR_2}
    fi
    echo ""

    cd ${F_SOR_2}
    sh ${F_CURRENT}qsdown.sh -F Sorcerian -p SOR_CD2_ -f 31 -t 59 -m mp3 -z
    cd ../../..
fi


# download police quest soundtrack
if [[ ${D_PQ} -eq 1 ]]
then
    echo "POLICE QUEST ---------------------------------------------"

    # directories
    F_PQ=${F_SOUNDTRACKS}"/Police_Quest"
    F_PQ1=${F_PQ}"/Police_Quest__1"
    F_PQ2=${F_PQ}"/Police_Quest__2"
    F_PQ3=${F_PQ}"/Police_Quest__3"

    # pq1
    echo "Preparing to download Police Quest 1 soundtrack..."
    if [[ ! -d ${F_PQ1} ]]
    then
        echo "Creating folder ${F_PQ1}..."
        mkdir -p ${F_PQ1}
    fi

    cd ${F_PQ1}
    sh ${F_CURRENT}qsdown.sh -F pq1digital -T pq1\( -S \) -t 26 -m mp3
	cd ../../..


    # pq2
	echo "Preparing to download Police Quest 2 soundtrack..."
	if [[ ! -d ${F_PQ2} ]]
	then
            echo "Creating folder ${F_PQ2}..."
            mkdir -p ${F_PQ2}
	fi
	echo ""

	cd ${F_PQ2}
	sh ${F_CURRENT}qsdown.sh -F pq2digital -t 12 -z
	cd ../../..


    # pq3
	echo "Preparing to download Police Quest 3 soundtrack..."
	if [[ ! -d ${F_PQ3} ]]
	then
            echo "Creating folder ${F_PQ3}..."
            mkdir -p ${F_PQ3}
	fi
	echo ""

	cd ${F_PQ3}
	sh ${F_CURRENT}qsdown.sh -F pq3digital -t 28 -z
	cd ../../..
fi

# download quest for glory soundtrack
if [[ ${D_QG} -eq 1 ]]
then
    echo "QUEST FOR GLORY ------------------------------------------"

    # directories
    F_QG=${F_SOUNDTRACKS}"/Quest_for_Glory"
    F_QG2=${F_QG}"/Quest_for_Glory__2"
    F_QG3=${F_QG}"/Quest_for_Glory__3"
    F_QG4=${F_QG}"/Quest_for_Glory__4"
    F_QG4_1=${F_QG4}"/CD1"
    F_QG4_2=${F_QG4}"/CD2"
    F_QG5=${F_QG}"/Quest_for_Glory__5"

    # qg2
    echo "Preparing to download Quest for Glory II soundtrack..."
    if [[ ! -d ${F_QG2} ]]
    then
        echo "Creating folder ${F_QG2}..."
        mkdir -p ${F_QG2}
    fi
    echo ""

    cd ${F_QG2}
    sh ${F_CURRENT}qsdown.sh -F qfg2cd -t 29 -z
    cd ../../..


    # qg3
    echo "Preparing to download Quest for Glory III soundtrack..."
    if [[ ! -d ${F_QG3} ]]
    then
        echo "Creating folder ${F_QG3}..."
        mkdir -p ${F_QG3}
    fi
    echo ""

    cd ${F_QG3}
    sh ${F_CURRENT}qsdown.sh -F qfg3cd -t 44 -z
    cd ../../..


    # qg4 - cd 1
    echo "Preparing to download Quest for Glory IV Disc #1 soundtrack..."
    if [[ ! -d ${F_QG4_1} ]]
    then
        echo "Creating folder ${F_QG4_1}..."
        mkdir -p ${F_QG4_1}
    fi
    echo ""

    cd ${F_QG4_1}
    sh ${F_CURRENT}qsdown.sh -F qfg4cd -p QFG4 -t 31 -z
    cd ../../../..


    # qg4 - cd 2
    echo "Preparing to download Quest for Glory IV Disc #2 soundtrack..."
    if [[ ! -d ${F_QG4_2} ]]
    then
        echo "Creating folder ${F_QG4_2}..."
        mkdir -p ${F_QG4_2}
    fi
    echo ""

    cd ${F_QG4_2}
    sh ${F_CURRENT}qsdown.sh -F qfg4cd -p QFG4CD2 -f 2 -t 10 -z
    sh ${F_CURRENT}qsdown.sh -F qfg4cd -p QFG4CD2 -f 11 -t 22 -z
    cd ../../../..


    # qg5
    echo "Preparing to download Quest for Glory V soundtrack..."
    if [[ ! -d ${F_QG5} ]]
    then
        echo "Creating folder ${F_QG5}..."
        mkdir -p ${F_QG5}
    fi
    echo ""

    cd ${F_QG5}
    sh ${F_CURRENT}qsdown.sh -F qfg5cd -T qfg5- -t 5 -m mp3 -z
    sh ${F_CURRENT}qsdown.sh -F qfg5cd -T qfg5- -f 8 -t 12 -m mp3 -z
    sh ${F_CURRENT}qsdown.sh -F qfg5cd -T qfg5- -f 14 -t 23 -m mp3 -z
    sh ${F_CURRENT}qsdown.sh -F qfg5cd -T qfg5- -f 27 -t 27 -m mp3 -z
    sh ${F_CURRENT}qsdown.sh -F qfg5cd -T qfg5- -f 30 -t 31 -m mp3 -z
    sh ${F_CURRENT}qsdown.sh -F qfg5cd -T qfg5- -f 33 -t 33 -m mp3 -z
    sh ${F_CURRENT}qsdown.sh -F qfg5cd -T qfg5- -f 35 -t 35 -m mp3 -z
    cd ../../..
fi


# download hero's quest soundtrack
if [[ ${D_HQ} -eq 1 ]]
then
    echo "HERO'S QUEST ---------------------------------------------"

    # directories
    F_HQ=${F_SOUNDTRACKS}"/Heros_Quest"

    # hq
    echo "Preparing to download Hero's Quest soundtrack..."
    if [[ ! -d ${F_HQ} ]]
    then
        echo "Creating folder ${F_HQ}..."
        mkdir -p ${F_HQ}
    fi
    echo ""

    cd ${F_HQ}
    sh ${F_CURRENT}qsdown.sh -F hqcd  -p HQ -t 23 -z
    cd ../..
fi


# download space quest soundtrack
if [[ ${D_SQ} -eq 1 ]]
then
    echo "SPACE QUEST ----------------------------------------------"

    # directories
    F_SQ=${F_SOUNDTRACKS}"/Space_Quest"
    F_SQ1=${F_SQ}"/Space_Quest__1"
    F_SQ4=${F_SQ}"/Space_Quest__4"
    F_SQ5=${F_SQ}"/Space_Quest__5"
    F_SQ6=${F_SQ}"/Space_Quest__6"

    # sq1
    echo "Preparing to download Space Quest I soundtrack..."
    if [[ ! -d ${F_SQ1} ]]
    then
        echo "Creating folder ${F_SQ1}..."
        mkdir -p ${F_SQ1}
    fi
    echo ""

    cd ${F_SQ1}
    sh ${F_CURRENT}qsdown.sh -F sq1cd -p SQ1 -t 24 -z
    cd ../../..

    # sq4
    echo "Preparing to download Space Quest IV soundtrack..."
    if [[ ! -d ${F_SQ4} ]]
    then
        echo "Creating folder ${F_SQ4}..."
        mkdir -p ${F_SQ4}
    fi
    echo ""

    cd ${F_SQ4}
    sh ${F_CURRENT}qsdown.sh -F sq4cd -t 27 -z
    cd ../../..


    # sq5
    echo "Preparing to download Space Quest V soundtrack..."
    if [[ ! -d ${F_SQ5} ]]
    then
        echo "Creating folder ${F_SQ5}..."
        mkdir -p ${F_SQ5}
    fi
    echo ""

    cd ${F_SQ5}
    sh ${F_CURRENT}qsdown.sh -F miscellaneous/sq5cd -t 24 -z
    cd ../../..


    # sq6
    echo "Preparing to download Space Quest 6 soundtrack..."
    if [[ ! -d ${F_SQ6} ]]
    then
        echo "Creating folder ${F_SQ6}..."
        mkdir -p ${F_SQ6}
    fi
    echo ""

    cd ${F_SQ6}
    sh ${F_CURRENT}qsdown.sh -F sq6cd -t 33 -z
    cd ../../..
fi


# download king's quest soundtrack
if [[ ${D_KQ} -eq 1 ]]
then
    echo "KING'S QUEST ---------------------------------------------"

    # directories
    F_KQ=${F_SOUNDTRACKS}"/Kings_Quest"
    F_KQ5=${F_KQ}"/Kings_Quest__5"
    F_KQ6=${F_KQ}"/Kings_Quest__6"

    # kq5
    echo "Preparing to download Space Quest I soundtrack..."
    if [[ ! -d ${F_KQ5} ]]
    then
        echo "Creating folder ${F_KQ5}..."
        mkdir -p ${F_KQ5}
    fi
    echo ""

    cd ${F_KQ5}
    sh ${F_CURRENT}qsdown.sh -F kq5cd -t 40 -z
    cd ../../..


    # kq6
    echo "Preparing to download Space Quest IV soundtrack..."
    if [[ ! -d ${F_KQ6} ]]
    then
        echo "Creating folder ${F_KQ6}..."
        mkdir -p ${F_KQ6}
    fi
    echo ""

    cd ${F_KQ6}
    sh ${F_CURRENT}qsdown.sh -F miscellaneous/kq6cd -p KQ6 -t 33 -z
    cd ../../..
fi


# download betrayal at krondor soundtrack
if [[ ${D_BK} -eq 1 ]]
then
    echo "BETRAYAL AT KRONDOR --------------------------------------"

    # directories
    F_BK=${F_SOUNDTRACKS}"/Betrayal_at_Krondor"

    # bk
    echo "Preparing to download Betrayal at Krondor soundtrack..."
    if [[ ! -d ${F_BK} ]]
    then
        echo "Creating folder ${F_BK}..."
        mkdir -p ${F_BK}
    fi
    echo ""

    cd ${F_BK}
    sh ${F_CURRENT}qsdown.sh -F Bak -T BAKXG -f 1 -t 1 -z
    sh ${F_CURRENT}qsdown.sh -F Bak -T BAKGM -f 2 -t 33 -z
    cd ../..
fi


# download silpheed soundtrack
if [[ ${D_SIL} -eq 1 ]]
then
    echo "SILPHEED -------------------------------------------------"

    # directories
    F_SIL=${F_SOUNDTRACKS}"/Silpheed"

    # sil
    echo "Preparing to download Silpheed soundtrack..."
    if [[ ! -d ${F_SIL} ]]
    then
        echo "Creating folder ${F_SIL}..."
        mkdir -p ${F_SIL}
    fi
    echo ""

    cd ${F_SIL}
    sh ${F_CURRENT}qsdown.sh -F Silpheed -p SILPH_ -t 11 -z
    cd ../..
fi


## Exit successfully
echo "Done!"
exit 0

