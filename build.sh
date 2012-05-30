#!/bin/sh
function prompt {
 echo 'please build your app first'
 echo 'make sure your output file is under /Users/twer/Library/Developer/Xcode/DerivedData/DailyReview-*'
 exit 1
}

function auto_set {
# TODO: find the latest DailyReview-* directory
 path="$(find ~/Library/Developer/Xcode/DerivedData/DailyReview-* -path '**/Debug-iphonesimulator/DailyReview Frankified.app')"
 [ "$path" ] || exit 1
 export APP_BUNDLE_PATH=$path
}

[ "$APP_BUNDLE_PATH" ] || auto_set
bundle exec cucumber DailyReview/features
echo $APP_BUNDLE_PATH
