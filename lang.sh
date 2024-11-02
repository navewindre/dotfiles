#!/bin/sh

ENGINES=$(ibus engine)
case "$ENGINES" in
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
