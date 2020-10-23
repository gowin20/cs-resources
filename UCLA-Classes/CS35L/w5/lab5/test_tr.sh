#!/usr/bin/env bash
IN_FILE=
VERS=
if (( $# == 2 )); then
    IN_FILE=$1
    if test ! -f "$IN_FILE"; then
        printf "Invalid filename $IN_FILE\n"
        exit 1
    fi

    if [[ $2 == "-u" ]]; then
        VERS="./tr2u"
        printf "Testing tr2u\n"
    else if [[ $2 == "-b" ]]; then
             VERS="./tr2b"
             printf "Testing tr2b\n"
         fi
    fi
else
    printf "invalid arguments - try ./test_tr INPUT_FILE [-u or -b]\n"
    exit 1
fi



# Test 1 - Duplicate "from"
cat $IN_FILE | $VERS aa bc 2&> /dev/null
if (( $? != 1 )); then
    printf "Test 1 - FAILURE\n"
else
    printf "PASSED - Test 1\n"
fi

# Test 2 - len(from) > len(to)
cat $IN_FILE | $VERS abcde fghi 2&> /dev/null
if (( $? != 1 )); then
    printf "Test 2 - FAILURE\n"
else
    printf "PASSED - Test 2\n"
fi

# Test 3 - len(from) < len(to)
cat $IN_FILE | $VERS abcde fghijk 2&> /dev/null
if (( $? != 1 )); then
    printf "Test 3 - FAILURE\n"
else
    printf "PASSED - Test 3\n"
fi

# Test 4 - No arguments
cat $IN_FILE | $VERS 2&> /dev/null
if (( $? != 1 )); then
    printf "Test 4 - FAILURE\n"
else
    printf "PASSED - Test 4\n"
fi

# Test 5 - Only one argument
cat $IN_FILE | $VERS abc 2&> /dev/null
if (( $? != 1 )); then
    printf "Test 5 - FAILURE\n"
else
    printf "PASSED - Test 5\n"
fi

# Test 6 - Too many arguments
cat $IN_FILE | $VERS abc def ghi 2&> /dev/null
if (( $? != 1 )); then
    printf "Test 6 - FAILURE\n"
else
    printf "PASSED - Test 6\n"
fi
