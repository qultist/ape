#!/bin/sh

xcrun llvm-cov report \
    .build/x86_64-apple-macosx/debug/ApePackageTests.xctest/Contents/MacOS/ApePackageTests \
    -instr-profile=.build/x86_64-apple-macosx/debug/codecov/default.profdata \
    -ignore-filename-regex=".build|Tests" \
    -use-color
