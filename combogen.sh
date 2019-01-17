#! /bin/bash
################################################################################
#           _____ ________  _________  _____ _____  _____ _   _                #
#          /  __ \  _  |  \/  || ___ \|  _  |  __ \|  ___| \ | |               #
#          | /  \/ | | | .  . || |_/ /| | | | |  \/| |__ |  \| |               #
#          | |   | | | | |\/| || ___ \| | | | | __ |  __|| . ` |               #
#          | \__/\ \_/ / |  | || |_/ /\ \_/ / |_\ \| |___| |\  |               #
#           \____/\___/\_|  |_/\____/  \___/ \____/\____/\_| \_/               #
#                                                                              #
################################################################################
#
## INTRODUCTION ---------------------------------------------------------------#
#
#    Script Name:   combogen.sh
#    Version:       combogen v.1.1
#    Pastebin:      https://pastebin.com/raw/wJ0sjLEa
#    Repository:    https://github.com/h8rt3rmin8r/combogen
#
#    A combonation and permutation generator written in Bash and Perl
#
#    Combogen is designed to perform three primary operations:
#
#        1) Generate combinations of a character set within a specified length
#        2) Generate permutations of the characters contained in a string
#        3) Generate permutations of the words contained in a string of words
#
#    Additional features are upcoming (such as handling symbolic characters)
#    so stay tuned for future updates.
#
#    NOTE: If used incorrectly, this script can take up all of the local
#    system memory and can crash or damage your system.
#
## INSTALLATION ---------------------------------------------------------------#
#
#    Save this script locally as "combogen.sh" and make it executable:
#        sudo chmod +x combogen.sh
#
#    Run the script in the following manner:
#        ./combogen.sh --help
#
#    Enable this script to have global execution availability by placing it 
#    into /usr/local/bin (or somewhere else in your user's PATH). By doing
#    this, you can call "combogen.sh" from anywhere on the system.
#
## USAGE ----------------------------------------------------------------------#
#
#    combogen.sh <CHARACTER_SET> <OUTPUT_LENGTH>
#    combogen.sh -p <PERMUTATION_STRING>
#    combogen.sh --pw '<PERMUTATION_WORD_LIST>'
#
#    CHARACTER SETS:
#
#        '-uc'      | Upper case letters (A-Z)
#        '-lc'      | Lower case letters (a-z)
#        '-nm'      | Numbers (0-9)
#        '-uclc'    | Upper case and lower case letters (A-Z, a-z)
#        '-ucnm'    | Upper case letters and numbers (A-Z, 0-9)
#        '-lcnm'    | Lower case letters and numbers (a-z, 0-9)
#
#    OUTPUT LENGTH:
#
#        Indicate one of '-[NUMBER]'
#        Example: -7
#
#    PERMUTATION:
#
#        Indicate one of: [-p,-P,--permutation] and a permutation string
#        Example: --permutation 'abc123'
#        Example: -p 'Bash Rocks'
#
#    PERMUTATION WORD LIST:
#
#        Indicate one of: [--pw,--permutation-words] and a quoted word list
#        Example: --pw 'this is awesome'
#
## LICENSE --------------------------------------------------------------------#
#
#    Copyright 2018 ResoNova International Consulting, LLC
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
################################################################################

#==============================================================================#
# VARIABLE ASSIGNMENTS

# VARIABLE GROUP: [ Operations ]-----------------------------------------------#

HERE=$(pwd)
SELF_NAME="combogen"
SELF_OUT="[${SELF_NAME}]"
SELF_VERSION=$(cat $0 | head -n 15 | tail -n 1 | sed 's/#.*com/com/g')
INPUTS="$@"
IN_MOD="${@:2}"
OUT_LEN="" # intentionally blank
CHR_SET="" # intentionally blank
DEPENDS_1=$(perl --version &>/dev/null; echo $?)
DEPENDS_2=$(echo 123 | base64 &>/dev/null; echo $?)

# VARIABLE GROUP: [ Verbosity ]------------------------------------------------#

VB_01="${SELF_OUT} ERROR: Improper input formatting! Use '--help' or '--manual' for more info."
VB_02="${SELF_OUT} ERROR: Required package 'perl' is not installed or is improperly configured!"
VB_03="${SELF_OUT} You should be able to install perl with 'sudo apt-get install perl'"
VB_04="${SELF_OUT} ERROR: Required package 'openssl' is not installed or is improperly configured!"
VB_05="${SELF_OUT} You should be able to install openssl with 'sudo apt-get install openssl'"

# VARIABLE GROUP: [ Perl Scripting ]-------------------------------------------#

P_A='IyEvdXNyL2Jpbi9wZXJsIC1uCnN1YiBwZXJtdXRlICgmQCkgewogICAgbXkgJGNvZGUgPSBzaGlmdDsKICAgIG1'
P_B='5IEBpZHggPSAwLi4kI187CiAgICB3aGlsZSAoICRjb2RlLT4oQF9bQGlkeF0pICkgewogICAgICAgIG15ICRwID'
P_C='0gJCNpZHg7CiAgICAgICAgLS0kcCB3aGlsZSAkaWR4WyRwLTFdID4gJGlkeFskcF07CiAgICAgICAgbXkgJHEgP'
P_D='SAkcCBvciByZXR1cm47CiAgICAgICAgcHVzaCBAaWR4LCByZXZlcnNlIHNwbGljZSBAaWR4LCAkcDsKICAgICAg'
P_E='ICArKyRxIHdoaWxlICRpZHhbJHAtMV0gPiAkaWR4WyRxXTsKICAgICAgICBAaWR4WyRwLTEsJHFdPUBpZHhbJHE'
P_F='sJHAtMV07CiAgICB9Cn0KcGVybXV0ZSB7IHByaW50ICJAX1xuIiB9IHNwbGl0Ow=='
P_SRC="${P_A}${P_B}${P_C}${P_D}${P_E}${P_F}"

#==============================================================================#
# FUNCTION DECLARATIONS

# FUNCTION GROUP: [ Operations ]-----------------------------------------------#

function helptext_out() {
    clear
    cat $0 | head -n 10 | tail -n +2 | sed 's/#//g' | sed 's/^\ \ //g'
    cat $0 | head -n 75 | tail -n +45 | sed 's/#//g' | sed 's/^\ \ //g'
    return
}

function manpage_out() {
    clear
    cat $0 | head -n 91 | tail -n +2 | sed 's/#//g' | sed 's/^\ \ //g'
    return
}

function version_out() {
    echo "${SELF_VERSION}"
    return
}

function check_depends() {
    local DEPENDS_CHECK_RESULT="PASS"
    if [[ ${DEPENDS_1} -gt 0 ]];
        then local DEPENDS_CHECK_RESULT="FAIL_1"
    fi
    if [[ ${DEPENDS_2} -gt 0 ]];
    then
        if [[ "${DEPENDS_CHECK_RESULT}" == "FAIL_1" ]];
            then local DEPENDS_CHECK_RESULT="FAIL_3"
            else local DEPENDS_CHECK_RESULT="FAIL_2"
        fi
    fi
    case ${DEPENDS_CHECK_RESULT} in
        FAIL_1)
            echo "${VB_02}"; echo "${VB_03}"
            exit 1
            ;;
        FAIL_2)
            echo "${VB_04}"; echo "${VB_05}"
            exit 1
            ;;
        FAIL_3)
            echo "${VB_02}"; echo "${VB_03}"
            echo "${VB_04}"; echo "${VB_05}"
            exit 0
            ;;
        PASS)
            return
            ;;
    esac
    return
}

# FUNCTION GROUP: [ Permutation Generation ]-----------------------------------#

function permutate() {
    if [ "${#1}" = 1 ]; then
        echo "${2}${1}"
    else
        for i in $(seq 0 $((${#1}-1)) ); do
            pre="${2}${1:$i:1}"
            seg1="${1:0:$i}"
            seg2="${1:$((i+1))}"
            seg="${seg1}${seg2}"
            permutate "$seg" "$pre"
        done
    fi
}

function permutate_words() {
    echo "${P_SRC}" | base64 -d > tempgen.pl
    echo "${IN_MOD[@]}" | (perl tempgen.pl)
    rm tempgen.pl
    return
}

# FUNCTION GROUP: [ Combo Generation ]-----------------------------------------#

function gen_uclcnm() {
    case ${CHR_SET} in
        uc)
            case ${OUT_LEN} in
                1) uc_gen_01 ;;
                2) uc_gen_02 ;;
                3) uc_gen_03 ;;
                4) uc_gen_04 ;;
                5) uc_gen_05 ;;
                6) uc_gen_06 ;;
                7) uc_gen_07 ;;
                8) uc_gen_08 ;;
                9) uc_gen_09 ;;
                10) uc_gen_10 ;;
            esac
            ;;
        lc) 
            case ${OUT_LEN} in
                1) lc_gen_01 ;;
                2) lc_gen_02 ;;
                3) lc_gen_03 ;;
                4) lc_gen_04 ;;
                5) lc_gen_05 ;;
                6) lc_gen_06 ;;
                7) lc_gen_07 ;;
                8) lc_gen_08 ;;
                9) lc_gen_09 ;;
                10) lc_gen_10 ;;
            esac
            ;;
        nm) 
            case ${OUT_LEN} in
                1) nm_gen_01 ;;
                2) nm_gen_02 ;;
                3) nm_gen_03 ;;
                4) nm_gen_04 ;;
                5) nm_gen_05 ;;
                6) nm_gen_06 ;;
                7) nm_gen_07 ;;
                8) nm_gen_08 ;;
                9) nm_gen_09 ;;
                10) nm_gen_10 ;;
            esac
            ;;
        uclc) 
            case ${OUT_LEN} in
                1) uclc_gen_01 ;;
                2) uclc_gen_02 ;;
                3) uclc_gen_03 ;;
                4) uclc_gen_04 ;;
                5) uclc_gen_05 ;;
                6) uclc_gen_06 ;;
                7) uclc_gen_07 ;;
                8) uclc_gen_08 ;;
                9) uclc_gen_09 ;;
                10) uclc_gen_10 ;;
            esac
            ;;
        ucnm) 
            case ${OUT_LEN} in
                1) ucnm_gen_01 ;;
                2) ucnm_gen_02 ;;
                3) ucnm_gen_03 ;;
                4) ucnm_gen_04 ;;
                5) ucnm_gen_05 ;;
                6) ucnm_gen_06 ;;
                7) ucnm_gen_07 ;;
                8) ucnm_gen_08 ;;
                9) ucnm_gen_09 ;;
                10) ucnm_gen_10 ;;
            esac
            ;;
        lcnm) 
            case ${OUT_LEN} in
                1) lcnm_gen_01 ;;
                2) lcnm_gen_02 ;;
                3) lcnm_gen_03 ;;
                4) lcnm_gen_04 ;;
                5) lcnm_gen_05 ;;
                6) lcnm_gen_06 ;;
                7) lcnm_gen_07 ;;
                8) lcnm_gen_08 ;;
                9) lcnm_gen_09 ;;
                10) lcnm_gen_10 ;;
            esac
            ;;
    esac; return
}

function uc_gen_01() {
    perl -le '@c = ("A".."Z"); for $a (@c){print "$a"}'
}

function uc_gen_02() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){print "$a$b"}}'
}

function uc_gen_03() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){for $c(@c){print "$a$b$c"}}}'
}

function uc_gen_04() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){print "$a$b$c$d"}}}}'
}

function uc_gen_05() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){print "$a$b$c$d$e"}}}}}'
}

function uc_gen_06() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){print "$a$b$c$d$e$f"}}}}}}'
}

function uc_gen_07() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){print "$a$b$c$d$e$f$g"}}}}}}}'
}

function uc_gen_08() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){print "$a$b$c$d$e$f$g$h"}}}}}}}}'
}

function uc_gen_09() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){print "$a$b$c$d$e$f$g$h$i"}}}}}}}}}'
}

function uc_gen_10() {
    perl -le '@c = ("A".."Z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){for $j(@c){print "$a$b$c$d$e$f$g$h$i$j"}}}}}}}}}}'
}

function lc_gen_01() {
    perl -le '@c = ("a".."z"); for $a (@c){print "$a"}'
}

function lc_gen_02() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){print "$a$b"}}'
}

function lc_gen_03() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){for $c(@c){print "$a$b$c"}}}'
}

function lc_gen_04() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){print "$a$b$c$d"}}}}'
}

function lc_gen_05() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){print "$a$b$c$d$e"}}}}}'
}

function lc_gen_06() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){print "$a$b$c$d$e$f"}}}}}}'
}

function lc_gen_07() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){print "$a$b$c$d$e$f$g"}}}}}}}'
}

function lc_gen_08() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){print "$a$b$c$d$e$f$g$h"}}}}}}}}'
}

function lc_gen_09() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){print "$a$b$c$d$e$f$g$h$i"}}}}}}}}}'
}

function lc_gen_10() {
    perl -le '@c = ("a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){for $j(@c){print "$a$b$c$d$e$f$g$h$i$j"}}}}}}}}}}'
}

function nm_gen_01() {
    perl -le '@c = ("0".."9"); for $a (@c){print "$a"}'
}

function nm_gen_02() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){print "$a$b"}}'
}

function nm_gen_03() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){for $c(@c){print "$a$b$c"}}}'
}

function nm_gen_04() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){print "$a$b$c$d"}}}}'
}

function nm_gen_05() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){print "$a$b$c$d$e"}}}}}'
}

function nm_gen_06() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){print "$a$b$c$d$e$f"}}}}}}'
}

function nm_gen_07() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){print "$a$b$c$d$e$f$g"}}}}}}}'
}

function nm_gen_08() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){print "$a$b$c$d$e$f$g$h"}}}}}}}}'
}

function nm_gen_09() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){print "$a$b$c$d$e$f$g$h$i"}}}}}}}}}'
}

function nm_gen_10() {
    perl -le '@c = ("0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){for $j(@c){print "$a$b$c$d$e$f$g$h$i$j"}}}}}}}}}}'
}

function uclc_gen_01() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){print "$a"}'
}

function uclc_gen_02() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){print "$a$b"}}'
}

function uclc_gen_03() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){for $c(@c){print "$a$b$c"}}}'
}

function uclc_gen_04() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){print "$a$b$c$d"}}}}'
}

function uclc_gen_05() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){print "$a$b$c$d$e"}}}}}'
}

function uclc_gen_06() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){print "$a$b$c$d$e$f"}}}}}}'
}

function uclc_gen_07() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){print "$a$b$c$d$e$f$g"}}}}}}}'
}

function uclc_gen_08() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){print "$a$b$c$d$e$f$g$h"}}}}}}}}'
}

function uclc_gen_09() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){print "$a$b$c$d$e$f$g$h$i"}}}}}}}}}'
}

function uclc_gen_10() {
    perl -le '@c = ("A".."Z","a".."z"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){for $j(@c){print "$a$b$c$d$e$f$g$h$i$j"}}}}}}}}}}'
}

function ucnm_gen_01() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){print "$a"}'
}

function ucnm_gen_02() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){print "$a$b"}}'
}

function ucnm_gen_03() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){for $c(@c){print "$a$b$c"}}}'
}

function ucnm_gen_04() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){print "$a$b$c$d"}}}}'
}

function ucnm_gen_05() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){print "$a$b$c$d$e"}}}}}'
}

function ucnm_gen_06() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){print "$a$b$c$d$e$f"}}}}}}'
}

function ucnm_gen_07() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){print "$a$b$c$d$e$f$g"}}}}}}}'
}

function ucnm_gen_08() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){print "$a$b$c$d$e$f$g$h"}}}}}}}}'
}

function ucnm_gen_09() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){print "$a$b$c$d$e$f$g$h$i"}}}}}}}}}'
}

function ucnm_gen_10() {
    perl -le '@c = ("A".."Z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){for $j(@c){print "$a$b$c$d$e$f$g$h$i$j"}}}}}}}}}}'
}

function lcnm_gen_01() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){print "$a"}'
}

function lcnm_gen_02() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){print "$a$b"}}'
}

function lcnm_gen_03() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){for $c(@c){print "$a$b$c"}}}'
}

function lcnm_gen_04() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){print "$a$b$c$d"}}}}'
}

function lcnm_gen_05() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){print "$a$b$c$d$e"}}}}}'
}

function lcnm_gen_06() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){print "$a$b$c$d$e$f"}}}}}}'
}

function lcnm_gen_07() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){print "$a$b$c$d$e$f$g"}}}}}}}'
}

function lcnm_gen_08() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){print "$a$b$c$d$e$f$g$h"}}}}}}}}'
}

function lcnm_gen_09() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){print "$a$b$c$d$e$f$g$h$i"}}}}}}}}}'
}

function lcnm_gen_10() {
    perl -le '@c = ("a".."z","0".."9"); for $a (@c){for $b(@c){for $c(@c){for $d(@c){for $e(@c){for $f(@c){for $g(@c){for $h(@c){for $i(@c){for $j(@c){print "$a$b$c$d$e$f$g$h$i$j"}}}}}}}}}}'
}

#==============================================================================#
# INPUT VALIDATION AND FILTERING

# Check for the presence of dependant software packages (perl and base64)
check_depends

# Additional information options filtering
case "$1" in
    -h|-help|--help)
        # Help text filter
        helptext_out; exit 0
        ;;
    -m|-man|--man|man|-manual|--manual|manual)
        # Manual pages filter
        manpage_out; exit 0
        ;;
    -v|-version|--version|version)
        # Script version filter
        version_out; exit 0
        ;;
esac

#==============================================================================#
# OPERATIONS EXECUTION

# Permutation of input characters
if [[ "$1" == "-p" || "$1" == "-permutate" || "$1" == "--permutate" ]];
    then permutate "$2"; exit 0
fi
if [[ "$1" == "-permutation" || "$1" == "--permutation" ]];
    then permutate "$2"; exit 0
fi
if [[ "$1" == "-P" || "$1" == "-permutations" || "$1" == "--permutations" ]];
    then permutate "$2"; exit 0
fi

# Permutation of input strings
if [[ "$1" == "--pw" || "$1" == "-pw" || "$1" == "--wp" || "$1" == "-wp" || "$1" == "--permutation-words" ]];
    then permutate_words; exit 0
fi

# Combonation generator
if [[ "$1" =~ ^-[0-9]+$ ]]; then OUT_LEN="${1//-}"; fi
if [[ "$2" =~ ^-[0-9]+$ ]]; then OUT_LEN="${2//-}"; fi
if [[ "$1" =~ ^-[ulcnm]+$ ]]; then CHR_SET="${1//-}"; fi
if [[ "$2" =~ ^-[ulcnm]+$ ]]; then CHR_SET="${2//-}"; fi
if [[ "$(echo -n ${OUT_LEN} | wc -c)" -lt 1 || "$(echo -n ${CHR_SET} | wc -c)" -lt 1 ]];
    then echo "${VB_01}"; exit 1
    else export OUT_LEN; export CHR_SET
    gen_uclcnm
fi

################################################################################
                                                   #                           #
                                                   #  "think outside the box"  #
                                                   #                           #
                                                   #    ($) ¯\_(ツ)_/¯ (฿)     #
                                                   #                           #
                                                   #############################
