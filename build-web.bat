@echo off
flutter build web --release --base-href="/maps/" & scp -Cr build\web chris@backstreets.site:maps