#!/bin/zsh

setopt null_glob
setopt extended_glob

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

rm *.xmp
exiftool -r "-FileModifyDate<CreateDate" ./*
exiftool -r "-FileModifyDate<DateCreated" ./*
