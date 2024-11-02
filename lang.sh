#!/bin/sh

ENGINES=$(ibus engine)
case "$ENGINES" in
  *en*)
    echo "EN"
    ;;
  *pl*)
    echo "PL"
    ;;
  *anthy*)
    echo "JA"
    ;;
  *)
    echo "??"
    ;;
esac
