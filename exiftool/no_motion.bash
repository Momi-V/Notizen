#!/bin/bash

exiftool "-trailer:all=" "-FileCreateDate<CreateDate" "-FileModifyDate<CreateDate" ./*
