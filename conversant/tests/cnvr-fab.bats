#!/usr/bin/env bats

#
# IMPORTANT: this script needs to be run
# from the directory in which it is located.
#

CNVR_FAB='../cnvr-fab'

prefix="Would have executed"
@test "with no hosts" {
  result=`DRY_RUN=1 $CNVR_FAB -H`
  [ "$result" = "$prefix: -H" ]
}

@test "with one host" {
  result=`DRY_RUN=1 $CNVR_FAB -H host1`
  [ "$result" = "$prefix: -H host1" ]
}

@test "with two hosts" {
  result=`DRY_RUN=1 $CNVR_FAB -H host1,host2`
  [ "$result" = "$prefix: -H host1,host2" ]
}

@test "with two hosts followed by an argumentless option" {
  result=`DRY_RUN=1 $CNVR_FAB -H host1,host2 -g`
  [ "$result" = "$prefix: -H host1,host2 -g" ]
}

@test "with two hosts followed by an option with an argument" {
  result=`DRY_RUN=1 $CNVR_FAB -H host1,host2 -g`
  [ "$result" = "$prefix: -H host1,host2 -g" ]
}

@test "with two hosts followed by an option with an argument" {
  result=`DRY_RUN=1 $CNVR_FAB -H host1,host2 -g some_arg`
  [ "$result" = "$prefix: -H host1,host2 -g some_arg" ]
}

@test "with two hosts followed by an option with an argument, followed by another -H" {
  result=`DRY_RUN=1 $CNVR_FAB -H host1,host2 -g some_arg -H`
  [ "$result" = "$prefix: -H host1,host2 -g some_arg -H" ]
}

@test "with two hosts followed by an option with an argument, followed by another -H and one host" {
  result=`DRY_RUN=1 $CNVR_FAB -H host1,host2 -g some_arg -H host1`
  [ "$result" = "$prefix: -H host1,host2 -g some_arg -H host1" ]
}

@test "with two hosts followed by an option with an argument, followed by another -H and two hosts" {
  result=`DRY_RUN=1 $CNVR_FAB -H host1,host2 -g some_arg -H host1 host2`
  [ "$result" = "$prefix: -H host1,host2 -g some_arg -H host1,host2" ]
}

# vim: ft=sh:
