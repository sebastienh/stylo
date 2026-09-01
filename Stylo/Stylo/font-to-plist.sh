/usr/libexec/PlistBuddy -c "Delete :UIAppFonts" Info.plist
/usr/libexec/PlistBuddy -c "Add :UIAppFonts array" Info.plist
find ./fonts -name "*.ttf" -o -name "*.otf" -type f > fonts-list.txt
cat fonts-list.txt | while read line
do
   # do something with $line here
   /usr/libexec/PlistBuddy -c "Add :UIAppFonts: string $line" Info.plist 
done
