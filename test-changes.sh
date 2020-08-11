#!/bin/bash
####################################
# 执行增量单元测试
####################################

#!/bin/bash

# 要匹配的文件夹
testList=("__test__" "__tests__")
# 变更文件夹
LIST=`git diff-index --name-only --diff-filter=d HEAD | grep -E '\.(vue|js|ts|tsx|json)$' | xargs -n1 dirname | grep -E '[^\.]$'| uniq`
# 声明一个存放最后test的数组文件夹
temp=()

function getTest() {
    exist=0
    for t in ${testList[*]}
    do
        test="$1/$t"
        if [ -d "$test" ];then
            exist=1
            temp[${#temp[*]}]=$test
        fi
    done
    return $exist
}

# 判断查重后的list[0]是不是有值
if [ "${LIST[0]}" != '' ]
then
    for l in $LIST
    do
        #echo "first $l"
        getTest $l
        exist=$?
        if [ $exist -eq 0 ];then
            parent=`dirname $l`
            # echo "second $parent"
            getTest $parent
        fi
    done
    jest `echo ${temp[@]}`
else
    echo "no test run"
    exit
fi

