#!/bin/zsh

setopt null_glob
setopt extended_glob

# ---- Phase 1: fehlende Daten aus XMP-Sidecars übernehmen --------------------
for media in ^*.xmp; do
    base="${media:r}"
    xmp="${base}.xmp"

    # No matching XMP file
    [[ -f "$xmp" ]] || continue

    # Check whether either CreateDate or DateCreated already exists
    unset existing
    existing="$(exiftool -s3 \
        -CreateDate \
        -DateCreated \
        "$media" 2>/dev/null)"

    if [[ -n "$existing" && "$existing" != "0000:00:00 00:00:00" ]]; then
        print "SKIP: $media — already has CreateDate/DateCreated"
        continue
    fi

    print "COPY: $xmp -> $media"

    exiftool \
        -overwrite_original \
        -TagsFromFile "$xmp" \
        "-CreateDate<DateCreated" "$media"
done

mkdir .XMP
mv *.xmp .XMP/

# ---- Phase 2: mtime aus dem hinterlegten Aufnahmedatum ----------------------

exiftool \
    "-FileModifyDate<CreateDate" \
    ./*

exiftool \
    "-FileModifyDate<DateCreated" \
    ./*

exiftool \
    "-FileModifyDate<Keys::CreationDate" \
    ./*.mov
