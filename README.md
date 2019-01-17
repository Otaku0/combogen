```
    ################################################################################
    #           _____ ________  _________  _____ _____  _____ _   _                #
    #          /  __ \  _  |  \/  || ___ \|  _  |  __ \|  ___| \ | |               #
    #          | /  \/ | | | .  . || |_/ /| | | | |  \/| |__ |  \| |               #
    #          | |   | | | | |\/| || ___ \| | | | | __ |  __|| . ` |               #
    #          | \__/\ \_/ / |  | || |_/ /\ \_/ / |_\ \| |___| |\  |               #
    #           \____/\___/\_|  |_/\____/  \___/ \____/\____/\_| \_/               #
    #                                                                              #
    ################################################################################
```

## INTRODUCTION

#### About

Combogen is a combonation and permutation generator written in Bash and Perl.
Combogen is designed to perform three primary operations:

1) Generate combinations of a character set within a specified length
2) Generate permutations of the characters contained in a string
3) Generate permutations of the words contained in a string of words

Additional features are upcoming (such as handling symbolic characters), so stay tuned for future updates.
  
#### Version

combogen v.1.1
  
#### Source Code

- [pastebin.com](https://pastebin.com/raw/wJ0sjLEa)

- [github.com](https://github.com/h8rt3rmin8r/combogen)

## DISCLAIMERS

1) Local Execution Issues

If used incorrectly, this script can take up all of the local system memory and can crash or damage your system. Use your judgment when selecting the size of your desired outputs. _Unless you are running combogen on a super computer, dont try running something like '-uclc -100'_

2) Hacking

It just so happens that combogen is ... good at combinations. So when it comes to brute forcing something, combogen happens to be a pretty useful tool. For the record - please only hack things that belong to you. lol

I cannot and will not take any responsibility for what you decide to do with combogen (simply put).

## INSTALLATION

  Save this script locally as "combogen.sh" and make it executable:
      `sudo chmod +x combogen.sh`

  Run the script in the following manner:
      `./combogen.sh --help`

  Enable this script to have global execution availability by placing it
  into /usr/local/bin (or somewhere else in your user's PATH). By doing
  this, you can call "combogen.sh" from anywhere on the system.

## USAGE

```
combogen.sh <CHARACTER_SET> <OUTPUT_LENGTH>

combogen.sh -p <PERMUTATION_STRING>

combogen.sh --pw '<PERMUTATION_WORD_LIST>'
```

  ### CHARACTER SETS

```
      '-uc'      | Upper case letters (A-Z)
      '-lc'      | Lower case letters (a-z)
      '-nm'      | Numbers (0-9)
      '-uclc'    | Upper case and lower case letters (A-Z, a-z)
      '-ucnm'    | Upper case letters and numbers (A-Z, 0-9)
      '-lcnm'    | Lower case letters and numbers (a-z, 0-9)
```

  ### OUTPUT LENGTH

      Indicate one of '-[NUMBER]'
      Example: -7

  ### PERMUTATION

      Indicate one of: [-p,-P,--permutation] and a permutation string
      Example: --permutation 'abc123'
      Example: -p 'Bash Rocks'

  ### PERMUTATION WORD LIST

      Indicate one of: [--pw,--permutation-words] and a quoted word list
      Example: --pw 'this is awesome'

## LICENSE

  Copyright 2018 ResoNova International Consulting, LLC

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  
