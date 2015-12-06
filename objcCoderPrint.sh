#!/bin/sh


#FUNCTIONS

propertyType () {
  if [ "$1" == "BOOL" ] || [ "$1" == "bool" ] || [ "$1" == "Boolean" ] || [ "$1" == "boolean_t" ]
  then
    echo "Bool"
  elif [ "$1" == "double" ] || [ "$1" == "NSTimeInterval" ]
  then
    echo "Double"
  elif [ "$1" == "float" ] || [ "$1" == "CGFloat" ]
  then
    echo "Float"
  elif [ "$1" == "int32_t" ]
  then
    echo "Int32"
  elif [ "$1" == "int64_t" ]
  then
    echo "Int64"
  elif [ "$1" == "NSInteger" ] || [ "$1" == "NSUInteger" ]
  then
    echo "Integer"
  elif [ "$1" == "int" ]
  then
    echo "Int"
  elif [ "$1" == "CGPoint" ]
  then
    echo "CGPoint"
  elif [ "$1" == "CGRect" ]
  then
    echo "CGRect"
  elif [ "$1" == "CGSize" ]
  then
    echo "CGSize"
  elif [ "$1" == "CGVector" ]
  then
    echo "CGVector"
  elif [ "$1" == "CGAffineTransform" ]
  then
    echo "CGAffineTransform"
  elif [ "$1" == "UIEdgeInsets" ]
  then
    echo "UIEdgeInsets"
  elif [ "$1" == "UIOffset" ]
  then
    echo "UIOffset"
  elif [[ ("$1" == *"NS"*) || ("$1" == "id") ]]
  then
    echo "Object";
  else
    echo "PropertyList"
  fi
}

initVal () {
  if [ "$1" == "BOOL" ] || [ "$1" == "bool" ] || [ "$1" == "Boolean" ] || [ "$1" == "boolean_t" ]
  then
    echo "false"
  elif [ "$1" == "double" ] || [ "$1" == "NSTimeInterval" ]
  then
    echo "0.0"
  elif [ "$1" == "float" ] || [ "$1" == "CGFloat" ]
  then
    echo "0.0f"
  elif [ "$1" == "int32_t" ] || [ "$1" == "int64_t" ] || [ "$1" == "NSInteger" ] || [ "$1" == "NSUInteger" ] || [ "$1" == "int" ]
  then
    echo "0"
  elif [ "$1" == "CGPoint" ]
  then
    echo "CGPointZero"
  elif [ "$1" == "CGRect" ]
  then
    echo "CGRectNull"
  elif [ "$1" == "CGSize" ]
  then
    echo "CGSizeZero"
  elif [ "$1" == "CGVector" ]
  then
    echo "CGVectorMake(0.0f, 0.0f)"
  elif [ "$1" == "CGAffineTransform" ]
  then
    echo "CGAffineTransformIdentity"
  elif [ "$1" == "UIEdgeInsets" ]
  then
    echo "UIEdgeInsetsZero"
  elif [ "$1" == "UIOffset" ]
  then
    echo "UIOffsetZero"
  elif [[ ("$1" == *"NS"*) || ("$1" == "id") ]]
  then
    echo "nil";
  else
    echo "0"
  fi
}

decoder () {
  s="self."
  t=" = [coder decode"
  u="ForKey:@\""
  v="\"];"

  IFS=' ' read -r -a array <<< "$1"
  name="${array[${#array[@]}-1]//\*/}"
  propType=$(propertyType "${array[${#array[@]}-2]//\*/}")

  echo $s${name}$t$propType$u${name}$v
}

encoder () {
  s="[coder encode"
  t=":self."
  u=" forKey:@\""
  v="\"];"

  IFS=' ' read -r -a array <<< "$1"
  name="${array[${#array[@]}-1]//\*/}"
  propType=$(propertyType "${array[${#array[@]}-2]//\*/}")

  echo $s$propType$t${name}$u${name}$v
}

init () {
  s="self."
  t=" = "
  u=";"

  IFS=' ' read -r -a array <<< "$1"
  name="${array[${#array[@]}-1]//\*/}"
  propType=$(initVal "${array[${#array[@]}-2]//\*/}")

  echo $s${name}$t$propType$u
}


#START OF PROGRAM
echo "Paste (on one line) all of your properties"
read properties
IFS=';' read -r -a array <<< "$properties"


printf "\n"
echo "DECODE"

for property in "${array[@]}"
do
  decoder "$property"
done


IFS=';' read -r -a array <<< "$properties"

printf "\n"
echo "ENCODE"

for property in "${array[@]}"
do
  encoder "$property"
done


IFS=';' read -r -a array <<< "$properties"

printf "\n"
echo "INITIALIZE"

for property in "${array[@]}"
do
  init "$property"
done
