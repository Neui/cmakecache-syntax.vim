#!/bin/sh
NAME="cmakecache-syntax"
VERSION="1.0.0"
FNAME="$NAME"-"$VERSION"
SOURCES="README.md \
	LICENSE \
	example.gif \
	example.png \
	ftdetect/ \
	syntax/ \
"
unset IFS
set -x

OPWD="$PWD"
# Generate vim8 structure
VIM8TMP="$PWD"/vim8tmp
VIM8DIR="$VIM8TMP"/"$NAME"/start/"$NAME"
rm -rf "$VIM8TMP" && echo "Removed leftover files. Did previous attempt fail?"
mkdir -p "$VIM8DIR"
cp -r -- $SOURCES "$VIM8DIR"

run_for_vim8() {
	cd "$VIM8TMP"
	$*
	cd "$VIM8DIR"
}
cd "$VIM8DIR"
ls -l *

if command -v 7z; then
	rm -f "$OPWD"/"$FNAME".7z "$OPWD"/"$FNAME".vim8.7z
	7z a "$OPWD"/"$FNAME".7z .
	run_for_vim8 7z a "$OPWD"/"$FNAME".vim8.7z "$NAME"
else
	echo "Couldn't find tool 7z for packaging into 7z!" >&2
fi

if command -v tar; then
	if command -v gzip; then
		rm -f "$OPWD"/"$NAME".tar.gz "$OPWD"/"$FNAME".vim8.tar.gz
		tar -c . | gzip -9c > "$OPWD"/"$FNAME".tar.gz
		run_for_vim8 tar -c "$NAME" | gzip -9c > "$OPWD"/"$FNAME".vim8.tar.gz
	else
		echo "Couldn't find tool gzip for packaging into tar.gz!" >&2
	fi
else
	echo "Couldn't find tool tar for packaging into tar!" >&2
fi

if command -v zip; then
	rm -f "$OPWD"/"$FNAME".zip "$OPWD"/"$FNAME".vim8.zip
	zip -9r "$OPWD"/"$FNAME".zip .
	run_for_vim8 zip -9r "$OPWD"/"$FNAME".vim8.zip "$NAME"
elif command -v 7z; then
	rm -f "$OPWD"/"$FNAME".zip "$OPWD"/"$FNAME".vim8.zip
	7z a "$OPWD"/"$FNAME".zip .
	run_for_vim8 7z a "$OPWD"/"$FNAME".vim8.zip "$NAME"
else
	echo "Couldn't find tool zip or 7z for packaging into zip!" >&2
fi

cd "$OPWD"
rm -rf "$VIM8TMP"
