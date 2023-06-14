cd ~

case "$__os_codename" in
impish | focal | bionic)
  ppa_name="okirby/qt6-backports" && ppa_installer
  echo "Installing dependencies..."
  case "$__os_codename" in
  focal | bionic)
    ppa_name="ubuntu-toolchain-r/test" && ppa_installer
    sudo apt install gcc-11 g++-11 -y || error "Could not install dependencies"
    ;;
  *) ;;
  esac
  ;;
*)
  echo "Installing dependencies..."
  ;;
esac

sudo apt install -y cmake libsdl2-dev libxrandr-dev pkg-config qt6-base-dev qt6-base-private-dev qt6-base-dev-tools qt6-tools-dev libevdev-dev git libcurl4-gnutls-dev libgbm-dev libdrm-dev ninja-build qt6-l10n-tools qt6-tools-dev-tools wget unzip || error "Could not install dependencies"

git clone https://github.com/stenzek/duckstation
cd duckstation
git pull || error "Could Not Pull Latest Source Code"
mkdir build
cd build
rm CMakeCache.txt
case "$__os_codename" in
focal | bionic)
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -GNinja -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11 .. || error "Cmake failed"
  ;;
*)
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-mcpu=native -DCMAKE_C_FLAGS=-mcpu=native -GNinja .. || error "Cmake failed"
  ;;
esac
# cmake -DCMAKE_BUILD_TYPE=Release ..
# ninja || error "Compilation failed"
# make -j$(nproc)
cmake --build . --parallel || error "Compilation failed"

cd ..
#install duckstation itself
cd ..
sudo cp -r duckstation/build/bin/ /usr/local/

#install icons for .desktop files
cd /usr/local/share/icons/hicolor/scalable/apps
sudo bash -c 'cat <<EOF > duckstation-qt.svg
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="512px" height="512px" viewBox="0 0 512 512" version="1.1">
<defs>
<filter id="alpha" filterUnits="objectBoundingBox" x="0%" y="0%" width="100%" height="100%">
  <feColorMatrix type="matrix" in="SourceGraphic" values="0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0"/>
</filter>
<mask id="mask0">
  <g filter="url(#alpha)">
<rect x="0" y="0" width="512" height="512" style="fill:rgb(0%,0%,0%);fill-opacity:0.2;stroke:none;"/>
  </g>
</mask>
<clipPath id="clip1">
  <rect x="0" y="0" width="512" height="512"/>
</clipPath>
<g id="surface5" clip-path="url(#clip1)">
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(0%,0%,0%);fill-opacity:1;" d="M 272.0625 288 L 248 301.875 L 248 407.28125 L 272.0625 421.21875 L 296.125 435.09375 L 320.1875 421.21875 L 320.1875 394.09375 L 296.125 380.1875 L 296.125 301.875 Z M 192.0625 340.90625 L 168 354.78125 L 168 460.1875 L 192.0625 474.125 L 216.125 488 L 240.1875 474.125 L 240.1875 447.03125 L 216.125 433.09375 L 216.125 354.78125 Z M 192.0625 340.90625 "/>
</g>
<mask id="mask1">
  <g filter="url(#alpha)">
<rect x="0" y="0" width="512" height="512" style="fill:rgb(0%,0%,0%);fill-opacity:0.2;stroke:none;"/>
  </g>
</mask>
<clipPath id="clip2">
  <rect x="0" y="0" width="512" height="512"/>
</clipPath>
<g id="surface8" clip-path="url(#clip2)">
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(0%,0%,0%);fill-opacity:1;" d="M 200 108.285156 L 328 182.183594 L 328 329.988281 L 200 403.886719 L 72 329.988281 L 72 182.183594 Z M 200 108.285156 "/>
</g>
<mask id="mask2">
  <g filter="url(#alpha)">
<rect x="0" y="0" width="512" height="512" style="fill:rgb(0%,0%,0%);fill-opacity:0.2;stroke:none;"/>
  </g>
</mask>
<clipPath id="clip3">
  <rect x="0" y="0" width="512" height="512"/>
</clipPath>
<g id="surface11" clip-path="url(#clip3)">
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(0%,0%,0%);fill-opacity:1;" d="M 280 52.066406 L 392 116.730469 L 392 246.058594 L 280 310.71875 L 168 246.058594 L 168 116.730469 Z M 280 52.066406 "/>
</g>
<mask id="mask3">
  <g filter="url(#alpha)">
<rect x="0" y="0" width="512" height="512" style="fill:rgb(0%,0%,0%);fill-opacity:0.2;stroke:none;"/>
  </g>
</mask>
<clipPath id="clip4">
  <rect x="0" y="0" width="512" height="512"/>
</clipPath>
<g id="surface14" clip-path="url(#clip4)">
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(0%,0%,0%);fill-opacity:1;" d="M 368 236.71875 L 304 247.375 L 304 268.71875 L 368 300.71875 L 432 268.71875 L 432 247.375 Z M 368 236.71875 "/>
</g>
<mask id="mask4">
  <g filter="url(#alpha)">
<rect x="0" y="0" width="512" height="512" style="fill:rgb(0%,0%,0%);fill-opacity:0.2;stroke:none;"/>
  </g>
</mask>
<clipPath id="clip5">
  <rect x="0" y="0" width="512" height="512"/>
</clipPath>
<g id="surface17" clip-path="url(#clip5)">
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(0%,0%,0%);fill-opacity:1;" d="M 112 66.582031 L 152 89.679688 L 152 135.867188 L 112 158.960938 L 72 135.867188 L 72 89.679688 Z M 112 66.582031 "/>
</g>
<mask id="mask5">
  <g filter="url(#alpha)">
<rect x="0" y="0" width="512" height="512" style="fill:rgb(0%,0%,0%);fill-opacity:0.2;stroke:none;"/>
  </g>
</mask>
<clipPath id="clip6">
  <rect x="0" y="0" width="512" height="512"/>
</clipPath>
<g id="surface20" clip-path="url(#clip6)">
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" d="M 280 36.0625 L 168 100.71875 L 174.921875 104.71875 L 280 44.0625 L 385.078125 104.71875 L 392 100.71875 Z M 280 36.0625 "/>
</g>
<mask id="mask6">
  <g filter="url(#alpha)">
<rect x="0" y="0" width="512" height="512" style="fill:rgb(0%,0%,0%);fill-opacity:0.2;stroke:none;"/>
  </g>
</mask>
<clipPath id="clip7">
  <rect x="0" y="0" width="512" height="512"/>
</clipPath>
<g id="surface23" clip-path="url(#clip7)">
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" d="M 112 58.59375 L 72 81.671875 L 78.921875 85.671875 L 112 66.59375 L 145.078125 85.671875 L 152 81.671875 Z M 112 58.59375 "/>
</g>
</defs>
<g id="surface1">
<use xlink:href="#surface5" mask="url(#mask0)"/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(72.941176%,17.254902%,0%);fill-opacity:1;" d="M 272.0625 358.316406 L 248 372.203125 L 248 399.292969 L 272.0625 413.203125 L 296.128906 427.09375 L 320.191406 413.203125 L 320.191406 386.117188 L 296.128906 372.203125 Z M 272.0625 358.316406 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,47.45098%,0%);fill-opacity:1;" d="M 272.0625 358.308594 L 248 372.195312 L 272.0625 386.109375 L 296.128906 399.996094 L 320.191406 386.109375 L 296.128906 372.195312 Z M 272.0625 358.308594 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,25.882353%,0%);fill-opacity:1;" d="M 272.0625 279.984375 L 296.128906 293.878906 L 296.128906 372.203125 L 272.0625 386.097656 L 248 372.203125 L 248 293.878906 Z M 272.0625 279.984375 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,25.882353%,0%);fill-opacity:1;" d="M 296.128906 427.09375 L 320.191406 413.203125 L 320.191406 386.109375 L 296.128906 399.996094 Z M 296.128906 427.09375 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(72.941176%,17.254902%,0%);fill-opacity:1;" d="M 272.0625 279.984375 L 272.0625 386.097656 L 248 372.203125 L 248 293.878906 Z M 272.0625 279.984375 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(72.941176%,17.254902%,0%);fill-opacity:1;" d="M 192.0625 411.222656 L 168 425.109375 L 168 452.199219 L 192.0625 466.113281 L 216.128906 480 L 240.191406 466.113281 L 240.191406 439.023438 L 216.128906 425.109375 Z M 192.0625 411.222656 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,25.882353%,0%);fill-opacity:1;" d="M 216.128906 480 L 240.191406 466.113281 L 240.191406 439.015625 L 216.128906 452.90625 Z M 216.128906 480 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,47.45098%,0%);fill-opacity:1;" d="M 192.0625 411.214844 L 168 425.105469 L 192.0625 439.015625 L 216.128906 452.90625 L 240.191406 439.015625 L 216.128906 425.105469 Z M 192.0625 411.214844 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,25.882353%,0%);fill-opacity:1;" d="M 192.0625 332.894531 L 216.128906 346.785156 L 216.128906 425.109375 L 192.0625 439.003906 L 168 425.109375 L 168 346.785156 Z M 192.0625 332.894531 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(72.941176%,17.254902%,0%);fill-opacity:1;" d="M 192.0625 332.894531 L 192.0625 439.003906 L 168 425.109375 L 168 346.785156 Z M 192.0625 332.894531 "/>
<use xlink:href="#surface8" mask="url(#mask1)"/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,80.784314%,0%);fill-opacity:1;" d="M 200 100.285156 L 328 174.183594 L 328 321.988281 L 200 395.886719 L 72 321.988281 L 72 174.183594 Z M 200 100.285156 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,40.392157%,0%);fill-opacity:1;" d="M 72 174.175781 L 72 321.988281 L 200 395.886719 L 200 248.09375 Z M 72 174.175781 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,76.078431%,0%);fill-opacity:1;" d="M 200 100.28125 L 72 174.175781 L 200 248.09375 L 328 174.175781 Z M 200 100.28125 "/>
<use xlink:href="#surface11" mask="url(#mask2)"/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,61.960784%,0.784314%);fill-opacity:1;" d="M 280 36.066406 L 392 100.730469 L 392 230.054688 L 280 294.71875 L 168 230.054688 L 168 100.730469 Z M 280 36.066406 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(24.705882%,24.705882%,24.705882%);fill-opacity:1;" d="M 296 193.96875 L 320 179.570312 L 320 211.96875 L 296 226.371094 Z M 296 193.96875 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,40.392157%,0%);fill-opacity:1;" d="M 168 100.71875 L 168 230.042969 L 280 294.730469 L 280 165.382812 Z M 168 100.71875 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,76.078431%,0%);fill-opacity:1;" d="M 280 36.058594 L 168 100.71875 L 280 165.382812 L 392 100.71875 Z M 280 36.058594 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(24.705882%,24.705882%,24.705882%);fill-opacity:1;" d="M 352 164 L 376 149.601562 L 376 182 L 352 196.398438 Z M 352 164 "/>
<use xlink:href="#surface14" mask="url(#mask3)"/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(72.941176%,17.254902%,0%);fill-opacity:1;" d="M 368 228.703125 L 368 292.703125 L 304 260.703125 L 304 239.371094 Z M 368 228.703125 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,47.45098%,0%);fill-opacity:1;" d="M 368 228.703125 L 368 292.703125 L 432 260.703125 L 432 239.371094 Z M 368 228.703125 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,25.882353%,0%);fill-opacity:1;" d="M 368.003906 207.398438 L 432 239.398438 L 368.003906 271.398438 L 304.003906 239.398438 Z M 368.003906 207.398438 "/>
<use xlink:href="#surface17" mask="url(#mask4)"/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,61.960784%,0.784314%);fill-opacity:1;" d="M 112 58.582031 L 152 81.679688 L 152 127.867188 L 112 150.960938 L 72 127.867188 L 72 81.679688 Z M 112 58.582031 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,40.392157%,0%);fill-opacity:1;" d="M 72 81.675781 L 72 127.867188 L 112 150.953125 C 112 150.960938 112 104.78125 112 104.78125 Z M 72 81.675781 "/>
<path style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,76.078431%,0%);fill-opacity:1;" d="M 112 58.589844 L 72 81.675781 L 112 104.78125 L 152 81.675781 Z M 112 58.589844 "/>
<use xlink:href="#surface20" mask="url(#mask5)"/>
<use xlink:href="#surface23" mask="url(#mask6)"/>
</g>
</svg>
EOF'

cd /usr/local/share/icons/hicolor/128x128/apps
sudo bash -c 'cat <<EOF > duckstation-qt.png
\89PNG

\00\00\00
IHDR\00\00\00\80\00\00\00\80\00\00\00\C3>a\CB\00\00piCCPicc\00\00(\91u\91\BDK\C3P\C5O[KE+Tq\C8Pš\85\A2 \8E\B5]\8A\94Z\C1\AAK\F2\9A\B4B\92\86\97)\AE\82\8BC\C1At\F1k\F0?\D0UpUEq\F1\F0k\91\EFk
-Ҿ\CB\CB\FDq\F2\CE\E5\E5\F0gtf\D8}	\C00\9EK\A7\A4\D5zG\90*L5*3\DBZ\C8f3\E8\B9~\E1\FD!.f\F5>\D7u
U\9B\BE~\E29fq\878I\9C\D9r,\C1{\C4#\AC,\89O\88c\9C.H|+t\C5\E37\C1%\8F\BF\F3|n\F0\8B\99R\A9\83\95fenOG
\BD\CAZ\F7_V͕e\EA\E3\B4'`#\874R\90\A0\A0\8AM\E8p\A7nRf\DD}\89\A6o	\F20zZ\A8\81\93\A3\842yc\A4Vi\AAJ]#]\A5\D2Q\B9\FF\CF\D3\D6fg\BC\E9\E1|u\DD\CFI \B44\EA\AE\FB{꺍3 \F0\\9Bm\85r\9A\FF&\BD\DE֢\C7@d\B8\BCik\CAp\B5\8C=[2\97\9BR\80\B6_Ӏ\8F`\A8\00\DF\EB^V\AD\F78\F2\DB\F4\8B\EE\80\C3#`\8A\CEG6\FE\00\81\F9gТ\FE\A1\D9\00\00\00	pHYs\00\00\00\00\D2\DD~\FC\00\00 \00IDATx^\ED]	\9CU\99\FF\AA\FA\9A{23I&\B9	~ʡ "`\00!\A0\82ຬ\91(.\BB\A0\BB?@\C5%\CF \AB"\C7.\A8@T\D8p%r\DFW$$0I\E6H2wOOwW\ED\FF\FF\AAޤ\D3stuw\F51\90\97_\A5gz\AA^\BD\F7\BE\FF\FB\AE\F7\BD\EF\89\EC.\BBG`\F7\8C<\F6\DFĴW\CB\C2\F7\F2\F8\98\EF\E5\CE\E5\D37\FBA\A9\91:\F9\BAT\C8r\FB\EFr\B2}\BD\F9Է\FB\D9q2\F6\C7D@\F0\ECG\E5Q\FBb\DBO\E0zT\B8\FEh?"'\DD\F0\DC\CCݨN*{\8D \F97|\F59|$\8E\9Fl\\A50\AE\A4\EC\C0\FF\D7\E3\FB\9F\97ϣ\\C67\EE\00i\BCZ\A6IP.\00\A1\CF\C6g\93\C4\§.\80/B
\EB\00\8Ce\00\C2M\00B\D37cӊ\00̬f̧԰&\E4\E7\B4\B6\8C-+\C2
\F6\90\F0\B2DL\B9\D7^h\89\9B\B9]\AE`\CB\DC\85q\B8\AC\CA\FCPy\DEQP\00@\91\8A\E0ߩ\EE\00\C0\92W0h?\C6,\BB\D58Z͵\92\C8\F9\A3Ѯo\E3Z\A4@v\9FM\E1\C89\DC`\9C\E36\F6	@x)\9B*\CA\E1ނ\00\BCH
\B0\81\81\E6[\F4\00s\D0(Wm\B9_͞#du1\DCh!\B8ѥhө\F8\8C\80|N{r-\B4\A3\FD\A0\E0\FE%\FA\F9KcQyp8/]\F2\00\E0\BD1\B0\DF\C4˗@\9EV\8E8\C0Z\A9JH\84\B8\AC\F7\00a\AD\97\E7z\E4\FCD\B4\E7\80\F2|\B4o\AAj\97\95km#<G\FD\80\A2\C1\92\97S8\DFR\D6\C57\00\D8Ay
ɹj\80\83XϞ\84l\C6\C0\FDw\F4\83\ED~\8E\98\BDJ\C1\F0\A5ݛ\F2A\CFr>\D7Fhg\81\C3Y\C5\E7p\D96;o\00\D86Ԩ'\E4$\B0Q\F0\FEJ\89\A22\95M\E1\CC\E1\B2\E4Y\WK\AF\AC4\E7\AF\C0n?\E62\D4\FCI\B4-{9\9FMR\EFM\E5p"7a<\96\D8\E5p\F945\D7g\D5s\CB\E5\EA\F0\9Er\89Q\C5_p\E5#O9{8x\A6|\DF8R\FE3׆\81\DD\CF7\BAϟ`U\E7-\E7smA\E7(\8A\E4p?~
\FD\C0W\97k\D3\F4s\9C{y\E3e\99׵\E2o\BE$kf\80t&H\E8ŔJ\AB\E8\C4pՠ\86:\99\93K\A3@\F8z\F8\99x\F6B0\FE\99\8A\F0\D9r\A3\^<\DA3\D41h\E7\E0g\C9гW\FA!\D4\C5ۍ\93}\D5@rnu\DEk\E1\A0$"}"[sˣbǶ\A1cA\92,\9D\B39\F3ec`,\DCg\E3\9F)\B5x&\92\84\EC[\C5\C0\C0~\83\BC
5\\83f*n䧒\97\F3+\E0\00\C1\90\95\C98YVBY>$\9F*\FDz6o\00\B0!\95`s\91\80}\9B\C5ܼZ\8C\8Eg\C5N\F4+ 8\00\AD\8A\F0$\FF7\959U\83+1s\F3 \D9C\FE\84\A7\FE\84*\F9\AC\8B24\85\D9㐜\80\B1\B9\EBׂk\CD\F6\8B\98\B9ԓ?\00\_\F9\DB\C0\AC\B7\93bt\AD\E9z]\92V]\D6\DC@\B7\D0!7\E7\E7}\00\97\93:\l\91\00\D8\CBL\E05x\9Az\FEgUeot\B9}s\B8S\80\F0
\\A1_\87E\DEW\F4\92?\00\DC&׀\C8\A8\CD)
\80!\DE/f\C7s\D8\F2\B0H_\8B"6I\C4\CB\D1Mx\BCWu\E6\FEc\85\AE\DA~L\CE\B7xP)z6\E4\FEh\BE\FB\CCՕ\EE\F2=A\C0\B2b\EF>\F4\EBS\B0\AA\8AZ|\80\C27@h\8Eo\A0fr\84\81mb\B6>*fۓb\81;\B0ۦ\92\F5\A9\85\D5\E3\E2\E7(p1\F3W9\BF\D7/P\D3<\81\EE\A1f=!5^/\82ױ\9E>
\85u\A5\FC]n\B3\EF\853\ADH%o+ \B5\9DU k\88\DEb\C1\B1\EF\8D\E8V1,t6P\AD\F8\C0\CE9\F3\C9\C6@\FF~\B3\C4\#\85\E6\CB\C7\CCI
F\E5\A3\E4\F9G\AC \B8\C1)\E0h/\A3\CA\EF\FBW\ED\E85\F9
\00\BE\86\BA@\F3|VF\B10\AF!\C1\F9=e\FF\B3\9F\F5N\D9(Vr\BBX\DBäo\BBq_1*\9A\\D0\99m\8006\D6,p4\93\C1Q\86\8BT|\00\F5\80Z\CC\FA.\D8ߞ܌\D4\FA#c\CF~\98xU\A8\ECt0\FFW#\A3s\8B\B1\BCނ	\E0\83\A0\FA\E4h㫐&pE\D1\EC\E6>'j\C9\E2\F5\C4w\00\90\F5\A8\B5\00p\D4\FCQ
\89ŷs\F6\8FQ@\FC\C5\98\CBQ\D1\BC\9F\92\A23\84\F5\C3ڐ\FE\CDx@@0\98\8E׭\FC\C5\C2?\9E\CBa\8Ez\ECt\8E (\A2\F3\AA \00\A1\83\F5 \C6\F6Lk윹l\C1𙛀}\BC7\FEv\86\86˶!\BDzGeS\89ڦ\B5E~\E9݈\EFqP=\D5E]\B98\81R\E1\E8\889J\9F\858"\C7fѓ\81\00(r\C9\00$\D6Ӽ\CE\E5\83\E8ܰ?\B3\C3\DA\E9\93\DEa\C7}\FB	\FDx\00`\9A\8A#H\9B34;\BB\A9l\BA\BA\AC
i\85~P=@@ w\A4AͲ\F2\9C\E3\83.\BB\8F+\CFȮ\A5ҝ\FDEc~\98\81\ABЭ\8Et\AF{HQ0\AC\E8\92\F5\F3\A6\F4;\E6\DC,\A0f\9A\B2\EFG\99\C9\C0aR\A7\C9ɺz7\89l~\DC\E7\E0\86\CFg\F2Fz\C6iv߃\D6u+gծc\CE\FESteЃ
\D5̼`\FC
Q0f\AC%\B7\A0{\BB`\BB\962oFC\ED\F4I'>g\BB\A3e\94\E53u\B8\D4Bk\83\DEHp\8C\AF\F0Fv\BF\89\DFـ\E1s\AEPc\EA\D4\EB\B0{\B2zK\BA\F0ۀ"\BC1\8C\F2>\CE~O\B3\FFM\CE\00\AA\AF\BF\92p}>\D7#j\B0\E9r\F3&M\ECT\A7\8F\EEg\BD&|\B2\9B\86@\C65] \C4{Eڟٲ\CA\E2\A7Mi\F3\CF\FFuɕ\CD$f<^\EC.u\8DD`-
)\8B\CC\FAu\C7}\80\AE\CCX!\F7\A2#\C7\F3\E7\E3\BB7\C9~\ABy\8A\AE\EC$\CD\ED\F4\E1\EF\DA\96\83\F6>\AA\98q\A4\BC\91\B8\A2\88A\DE\FA\88H\DB\F0!\90(\E9k~\C1\80r\9E\F6<\D9}ޒ\C8\007\8E~	g?\BB\ED+\007X!}\B8(\8E\C2u
\A6g3\AED\B4v\FA\F0F*{\8C\A8כ/r$}j
b\8C\E7\B5~\D0\F3\B6\AB\C0ϖ\E4\FB\FD\82\96󽮜\8FyW6\98r_\87\90\E5\D8\FF|\F3\00C\DC\E0:yb\E1b\B0\F6\A3\8C\84\FC\84\B2\8D\C0\81\83N\C2\E7\8D\EB\BE\C8t\CD"\D4$\FC\00`\F3\C3P\E5\B1\CCU?\D0r>
vO9U\EB\C3\E5|:\95\B4\94\B3\BF\C4%30S.\91V\E9\94ֺ0\00\FA\F3H|\9F\E5\D7*\E5~șL@\A0\81\ECrDB%@\D0\00\FFA\D7X\BC\E8 \DAmSJ\CDTDC\E03\D3\CBSǊ\C4\C9
\CA4\9E>\FF\BD`\00\C0\A6\90Z\B0\B8/cf\FC+\D8\DCl\F6y\A1ܵw\AEDF\B3\D8f\A2\FD\FD[\B1\B7r\CD,(\ACX\83\D195\96\FF\80/\A3_\C2\E1b͆\F0\9A\E3\94\C8\ECKǏ\EF\00\B0\AF\C2p&\9F\BA/\C3\F5Q5\98κwA\8Bv\F5\A4\ACDzy\A12\D1F\9A\8B\B4\EA\E7ü\9C\E5\88J\82#\E7\C2\EBp\B3l\9F\DA*\C2e0\FB\D9$_0\B4\BB\D6vw\D79B\A7\BD\A1H\8E\E4}
\D4\F0l\84\DD\F6\A2H\CF;\8EX\A8!\D7\D2\CB\CE$:\89\AF8r!\FEHN\AD\E4`yx\A6{|\00\A6õ\FBu\CC\FD\B3\80\ECF\A5\E0\99\F8\EChĪÀ\EE\C8q1eH?\E8\84~\F0(\89\D3D\9A\E0V\91HNPgv\EC>}\F4S\9D>\FCb\EB\D5\F5\86l\EB	\C9\E1\FB`\C0\BC\E8\99(\9A\E5\DF\F3\B2\EC\A4aLgîgx֥P\EE\E2\B3\E8\C1\F2\F3\D3C\E7FuyxVߢ\F4\B4\BB\9C``cʬϢ\8Ea\B7\A6\CE~8~v\F4\F2\A3[
9\EE\FB\F5\B2zmc\EE\96H>m\CAG\C4\FFW\85\82w%X\E4"\A5\D5ӓW\E8\E2\C1z\80pAG\A6\95Hm\D5@\F0pk\E6[*\84\BD\91\D3߹ڔ\DD\90\A7\DF4d\EA\8Cf\A9\A8\80\CB\D2C\DF2\BF$\FB;r\F1\C7\E5s\8E,\B2g\88\A8\C0|)F@\86G\D6N\E7\95\C1\98\B30\FB!\CB\E1	\D7\FA\CCS\AE\B8͔{\9E2%\91\B0e\E2\C4:ij\A8\93d\B2'\87J\FDy$gP\AB
S˃b\F7l@\C0'׹su\A8\F8ӗ\A1Z\E8\A2B\98\8B\9E\E6sS\9C\EAhi\C0\FA\BD[MY\F9l\9D2l\A9\AAH\F3\E4\C9\F8\\A1\B2_\F73g\00\80=\DA5\E8T\B2\BFO\88	_\BB=\C0\F2\F6ιV\FF\86_;\87J\C4Ywv\84
\C08\D9\00A2E\D3ohh\94\AA\AA*\B1,Μ\D2A5wR\B1c\94\B7\ɢn\B6\86\AD\C1\AE\A0\A7\C5F\94\CE\F0\CD \FE\D1\D6SM\DA9T\BA\A1E3\B5\D3Ǎ\F4QV\BE\8C\84\C3`\FF\E1\86\C6z16R\C4\A5ke\EE\00pɠ\B5n\C5\E6\B8+\E8M\B5+\C8\E8|
\9C-QZ h\E7PI\B9\00\9D>\E5\94FL\9E<IB\A1\B0\C4
\892wr<e\A3L\9B\9C\95@]\DF.Z\B7^pc\DB\80e5,\94d\F54\BD\E5%pv0!'\E7\90'>\E3pA\82߂\D5A\DDc\A8\A4\9A}\EE\97T\94*\ABk\A5\A6\D6rܖ\83fw\C9W>\BEU>2V@	Ɔ\CD\CA\00\ACd\98\D6\ED!\B6\BB\82\E0P\A9\9A
 \EC#v\A4I\AD\96\D5\E1\CE\D394&\E0\C8I\82\F0\B7<\90\FEd\A5\9C{8\A9\BAT\A7\CFP%\D8\FC<\A1YfM\8Cɗ>\B6EN8`\87D"Z7%bS\BE\00@/ɶ\A5y\FF\F4\82\F6\9A\D1v\B1\EB\E6\8A\C5\EE 7?\C3lLS\BDx&\9D?\EA\96\F1\F48\EC\F8\AB\EE2\E5\FE\B7\E5\C2\C5X<0\00\00G\CC;k\FD:\D2`\B0\00\8C\CD\D5r\D8\FE\DDr\E6\A26\99<T'\E1}\F0WxeV#\DD\E7\00X1\A3~F[\92u\E3\F4\8C\CEױ\85\FC]\B1&\EC\85d\B3\C5DQĂ\9F\CE!\F2̷;\B9\E6o\A6\DC\F8\98)\DD\993w2dz\8A-\9F\E9C0\E0\E2WW\9D\DA#Mu\F03\F3;\9E\B\EB\E3\99\00\97d]\B1\00\C1lw\E2\F8-\C4\F1\DB\8E\B3\B8\C0\B60\C5\B9\C0@>\CE!\D4qˣ\A6\FCǝ\D9Ўؖ\80%ӧ4Hu5\CD9ƚ\B9e\84HrɦZ4@\CBzrzO\89x\82\950.\81\E0`\D7S\E3\F5G3/\B4X\88v\889\80\8C"Xq\B3\C7o\877\D8u\E3h>\BC-\EDY-\A6Zs]\A4"L1K\EFx\D6T\C4\87l	\87#0\E7&9\D2̝\E9jF\8F\E9\E3\EC\8Dv\F4\AC3 j\D2\C0d\X\86F"\BB\E9\8D=\88\BE\80\AF\F2\AAu\BBqzF\CF&1\FA[\A1\CCk\F1v\A0\AAp\FAA6\91C\A3
[؍#\A4
O[>\9B\BE\BB_\8688m\FE\91\D6\FA\F5\8C`\BA\E97p1Y\AE
k\C5\CF\D8؂L'\A2N'\A8,\9Ef\90\B7 }\A0\A8u\93\DDz*\AEX\80	e\ECx\FE\83\870!\DE\C2r~\81\DCʾ9\87\D0\C0\EA\EAjil\C46e\FC\9C\B0\E0\CCI\A2v\F6;}\9B\BBk&\AAX&\92}\A2\90\86\E4?\8Aϑ+l\C0\F5\A8\BA\E7\F692\C1\D3\E6y\93\EF\00`{\B2^\92u\810\D8\B7\F2S\C8*\B2F\ECh\AB\DA9\E7\BB[\D9\E7\z\93\E1\C7gIΜ\F9\8D}r\DC(wz{\97&
	KM\9F\AC\DB\D6\81)/F\9A (	[U\EBU\F6\B98\A8\E2t\97\D1p\E2\BB\E0\8B\829.\C9\E9\ADbb\FB\B7]=\8A\E2B1\C2ujs\85o%\E7\C8!NTďU\D76H\A8\B2^\AAC1Yz`\9B|~\FF\99D\B3\8E\A3\A9\D9:?\B1sY\D8\D0\A3\8C\9D\D0\CE$C>\8C{\FF\84}7\F8\A1q\9D<\99\F1\D9n(\00؎|\96d\95و\AC2\90YĮ\DBS\92\F5\F3\B0ǃY}(\8Cb\FB:=./\A7\BE\D22\FD\93\E4S{u\C8m\95\BD\9A\E1\C6%8i\F3\BB\FA\81:V\82\84'\AB׀ȶ\DDN\E8=\A8'\E3\A7#\ED\AF\CAo\F0\9E\E5\00\D5G\DFJ\C1\00\A0\97d\F3Ѻ	\84dL\8C\ED/J\A0\8Fne\88\F8|Y9Q90\C8X\96\F7V!\EE\E3\B2\ED\C7\86\E5\EC\A9-r\CCĕ\B3%\B4\E7i\F6\91\FDӬ[\8Fk.?6\9E<\A9}\80	\B8
\F9\C4\C22\88\91\8D\EBU\86\A4\BC\8B/3j\B4V\F8\B2$\AB\DDʝp+w\8Aъ\C9"\FA{\D4\A2\98\A2ŒM\A1C\E9\82#\BA嘽A|\87\B3\94u\00o㢜\E7\CC'Ѽ*\C2^\A0\81`\C3X4\B0\EB*(\F7\C7{y4\D3=\80oZ7'\81\DB\D2^̸-@\C0v\FAT\F2\E4ԛ\95n'1\9B\9DJ\DBs\B8\98։\80\80pc
}\8F\8B\D4

 \F0ބnp\81܂k\BFLD\EB\EFY΁\EC_\E5\C59\94M\AD\A49\FD\EA;\C0b\C9'\C0\AEu\82l\B2.\A3\ADad\AC\8D\A0\E3\A7\84\AF\C1^\82@\AEr>\E3\8BƸ\81\F9FM\F9\EE8\FA\C1\C5؆\F7\FB\\AA+8\00\D8(&s\F0{IV\89_\00\A0\DE\C3^\CC\E4(a\95\F4#2k\9Ca\AC5\8C1D_\F7:\80\00\00\CCG\B0gcz\AE\82\\A8\E1\F5\EC\88+õ/\FC\87\91?I\CA\00a$W\AD{\AC1\D1tf\BE\A0\B0\DFZ\C8\E2&\8A\C9\FC;\CE
C\C6\C2[\D0l\B6\95\E9H\CFu\80uC%\98
\D0lp;|v2%cwޠ\B9\`Rb\9BȣB\853{Ʃ\B6\A0:@jײve1.\8A\CE\9C\DF\DF?\F3\A2b\E6qə\AB\98\CC9\94\95q7wR\8C \ACOށ\A7\EF)\98\EB\F1\C9eg/\E0ˢ\8BN\E3\82 <\97f\A0\F69P3'\BAk'Y5|׷
\00\DA9\94U\A7\B3\BCY\81\F68b\B0+Q\90iȁ\B8\87U6Z\D4\F23\8E%oH\CB飜x\F8o\BA\C9:,
>
\C7\CF\B8T]\B8И\DDt\C0d\C3\B4\D4ZA#\8F`ba\AC\8C\8D\CD<\80E\00\9B\92\93֝\B9\BBޡ\B5t&\A0\FC \AE\83qq\B5\8DΚ1\BC\89\9E\D70H\D0t\97\AF\DB
\84n\88\85\97 \9E:\F5\BA.\FD\E0\9AH5Z\8DS\9C\BC\C8|l&Nfr\96\8F} >\9BT%P\F7=\EF%\D9lQ\9B\FB\FE9[\E8\96}\97\ED\B5\99\96V\C5\F3\8F9\C4AO\89\F4A,\F2ע\BA\B4QԱ\81m\D0K\B6\C3d\9D\C0@?\B0\B1 \F3r\B7&lD\C9y\CC\A5\CF8ϱ/\"J%>\DF\CF]\94\95p\BC\A9u3\A9\B4O\00\CE	\B2\F6r&.\8A\85\BDp9\E7\FC
kDF1\A5g?\A5_b\E6a،
%\8Cq\81Cz!\B8Sy#|vO⤠\8D\FDH`6\D66\00G\CEc\9DY\C9yn%s\A0\CA\EF\C9\C5R\89OG\89C~q[n\C8<#\DFQT\C0&h\E7PVZw\AE\BD\D3\CFq\00I \9E\89ؙM\94܀\!mu.u
c\97ײ.\F5\EE<\F8R\9A!b戼\8Be\9AM\F0\80\C8&\DE\E1\C4\FF;E\8BlS3^\F7\D9{n\B5ؓ#\AE\A5\C2z\B5\9C\AFW\B3\9E\AC\DE\F1#j\F0\92\F8̫\A8\FD
\CE\F2\F1\B8\96\C1\B8ɸ,w\B7p\D1\C0~\E5\9A\CC!_\B9o9\98\FB\E3\E2\FEg\E8s\BC0\DFFSxzj\A4\8F\ABk\84\C1\96瞆	\FA	\AC\F6\FE\EB?\88\82\B6\A0(\B1\90\A3\B1\CFw)\00\D8s\A1\A7`;\BB\81z-%\DB,\ABg\BC&v3\BE\D1g\89|\96\9A\92\F2߸~j\*\EF\E6;&%\00\ED5r(\DF\8E\F8\BC\D68\B8x#9\83zA-\A6\FAR\95F\CE~\8E\96\FE\8E\BA\00\B9pӼ\D5@C\FF\00\92\E3M;\A6\E0\9D\F0T\BE꼙\89'R\8B\AB[\99\8C\A7\A4\ED\B3\87XSg\BA^-5\E04\F1\9D02\B7q\AE\CB3~\8DK\C9\00\A0\B5\EE\\96d\FD\EA\FC\8B\9D\8D9\D8pm\D10\83U\CC@j\00\A7N\C3YH\C2C.R#z\9DU;i:\C0\C95\B4\E5\AC\DD\A5\E0\A2\C3(\FD\BC\D7l4\FA\87\D5ΠXM\FC)\EE{\94\EFGs\DAr\DAv\B7\F1Sէ\92\80D\CCzI\D67ʧT\A4\F5\98\F1x\AE~Po
\FE\A6\82=\F5\EC\A7i\99\9A\E1<]\93\E5\EF\00O\00\9Fq,\94v\80a\D3\DF\D4j\B5P\94\BE\FFc\98\B3\D2Q\C1F\\E2'@r\E7	\D9\F2[\CCz\96\FE\97\92@/\C9\FA\91\CC!\EF\A1\D1\CA5\EDq!Ps|\FD	*\8E4#\9D\F3\9D\92Ʉ\A1\98\80\F9ǌ\E5{\9E\FD\E0y\FB\99\EF\CAsF\N"\C4Cy
\D3\BF#w\A1\B3\A7\C2(\CD>\89#g/Q|\A9`\A5\E8f`zO\94sȋ\AE`C\90V\B1\CE\86Y9"\9E\C7;2\[\A7u\CBD\FC\D4\EA(Bp\D5\EF-\DB]!\A7a{\F8Ix\FCq\AE\8D\FCC\85uR\97\98hE\E4\B0\FC\C5\C6E\F2\B5B\9F\EF/9\00\94\D6]̕4/@"AHppS\BB\\B3!|\FA;%P1U\ECů\CB=p/\86/\E0 \F5F@\E09A\D4A\9Eǡ\99\A7\C2Qu\88\CFВ\A2\94\92\8A\00\DDC\ADu{\C9\F4Y\F0Q\D1J\98\B6\BB\F3!|jcqj=\EE\E5\8B\~\EF\BEr\97i\CB7\F6v<D\CCo\E0\E8\B9\CE8K\ED(j)\00\E4\B4$[\C8a\A2\B2W\E0\EE\00e\FB\CFϑ\E6Yߦ\C6Q\9ARr\A0\BB\CD%Yr\BF&\Né\B5\F0Y\E5T\F7(\ED\FF\97\D2\BF,t\80\D4q\A1\ED\EDiI\D6O
\A4\D7E\E7\CEH[\BB
\F9\CE\D6]6\80c\E0yI\B6\A6?\E7\E2\F5\A5\AA\B3\AC\00\C0A\A0s\88&R\D1E\CE~\ED\DD+E\8A\FC޲@\C6%\D9B\90\B6\C3i\8By\85\E8\90\F7:\CB\00l:>g\AF\EF\BD\CF\C3\EF\E4\EC\D7\E7\E7S\CF8|\B6,\A0\97d\8B2\9E\9C\F14\FB2\9C^^\94\B6\94\E0%\F9\00 \DFp\C71\BB\AB\E3\F5ʑS\9D>\85\FC\82\8EU>M\CF\00L\E8\A2w\C3\E6ӂQ\9EՑC9\CE\FEB\9D\DC\C5\C6ӡ\E4,\E9˹\92 w\00p\99rP\EDF\81\A7;\D7׏\FD\A\9DCz\F5MG\DB\F8\DD\FAX	\ACA\E4\FC\B0q\96B\AC(	\F5\B3\EEE\DE\BBT\8F\C1[\BF
\F3\E9\85q9\B07\8C\B5ߌ5\F6\8C\C7\C0\E0\DD\BA\98\B6H%\A4̜u\8Cmeԭ\F6\F9g=t\A3<\C0)\E5\9D"\87\BA\\C2\FF\CE8X\C5\95eɝ\B8\DD\C1!\91\AB\D0YnU>\D7:\BFk.\88sH;}\C8\FE\FD*\9CJT$\91:a\DA?\C1\CC?\CA\D8O~V\CE\C4g\D7\F3\E6\00\A9\E3g\9F\8D\ED\00\CE\F9
\A2\D1\EB֬L4`\87X\8C\99\CC!@\000ƞ^??$3g<e\BC-w\E3\F3*\E3\00\84p\8D\93\E2+\00t\9F!\B4.\C5\EF\FF\84Ϡ\97\ADY\99Ƌ\B1\83\DB?j\83\BD@;}j\9Do\A1\9CwB\B4\9Fa\B0&R\C2\DCa,\F6\A3\B7\F96\CC\FB\F3\00_o\CF\C1\8Bq~\A0!\DF\C2uH\BE\FA7`n\88\91\D0#\F5\CF+\00\F8,@\F3\B1\FBw\CA\F9\86g\83\DD_V\CF\CC@\E3\AE\00C\DC\E0\A8Y\A6,\C5\EF\DF\C0\E7\9C|\C4B0\E7P\CE\00\D0N\86x\E5\C2\FA\B5Y\97TY\FFnD\DC\DE2\E3@\B5\B3`ܖ\82 \B3\00\80\8B\F0\FBR|⤤\EC\89@\9A1=Lt\A4|\BF\998\00\E6\CCe\B8u.\C1\CEF\C6\E6\DF\F0\i\EC\8F-Y\EF\81R4\00\E1\\88C.\C7 ~\C9:[8\89O+^\00\C0վl\B7U4\94\F3\87\A4\00{\F6>e\9C\E6K\9E\AA\B2\80O\DEf`\B6\BD\80\D9\F88\86\8F\B9\EF\FE xn(\A9\92Ǌt2\87\AC\DC
:\D2'\A7\A79\B4\E0\EF\C1\F53\F5\D9\F5^">\87\BC\E8\00\E0K\8D\DF"\C1\D7
\F9#d\E8'\C0R/\C3W\9B\B3\F10f \EB\C8!:|\BC\A6oq\F6\E0\89`\9F\9F"\FC_q1+_\F2A\ED\ED\AF\E9\EC\F7\BB\AD$\00нA\B2\C3\ED\C8n\F5CH֣0\E0\D7\E3\FB\A8\97\8C\*#!\F5\AEb-\D5\E9\93I\F1#@x\AD\C3\F5k\\B7\B8\AC\9F\80pF\8A9\DFS\A5\A4\00¯e-\80p6D\C2'\86\FB\D5`gh7\97z\8E\E2\EC\AB>\FE
\FB\00\FA \E7߹\8E\AE@K\B8\B9\93ߧ\C5M\CF\E5d?\94-h\CA\00C@\B8N\86M\FDi\FC~:\AEW\94\F25J=Ei\A7\8Fni\F6\BBf]F݆ۑ\C4\E1;\F08\DE+\96\91\C0ݜ\F5\E9\BBwL\F5\ED{\AA\DD
\F0:z\F6W\E0\AE1\E5|\\E7\82αi\85\CE!\BA\88q^\830Q\A4\BB$Xڹ(5\9AӇ\A4\A1[\9F\F1\EF\C4y\87\D8nl\8D\95=\A8A\EDVs\A0G\E0\E08\00\AE*sGH\FE\00q\F5c$mfR\D8q_\CA\00zdcK\8D%\8D?W\D6Z\D3ՌL\9B\C9<$\9A\A7\95
\00\C3Şt\A7Y:Hۅ\8D\9F\EBWJ\B2\E3Y\E9Gz\970\B6pG($\9Ct\00\E0\9CT\90\C4zA?rH\CA\E8\EC淖\CA\D8}-\00\F4\E81)\87\8D?<\94\95i\F8\AE\B8!\F2B\FB\86@[\D7\DBA\89q3=A\90[\E6\F7\A3i8\8Cóg\A9<\F4i\A6\BC\B5\FD%Y\FE̕\D2ێ\C3)PW
N/Ù҃\CB\C9\E9\C5e\9D0\F4\FE)0\A7C;\A8\94,\95\A5\CF\D9\E3\CD=\BCҳ\E5>\BF\926\97
:e\80O!\B5\8Ay\DA\D7d{K@1\97A\BBxh`\86T\E6@4\D0\E6\A7Ǐ\85s\D7@Z\E7\FC\F6\95r\D4\FDKeE\A2\83\FB\F8\99\9C\B7W⢦\80\9D\DB\C8\D9\D0dt!Ǡ\89͡u\F8{xX\8C\81@\C35C\EE\B2ϗ\9BgɼR1\9F\F7\96=\00x~\88kS\BE\DB\F8\A9\AFÔ\B5\AF\B2L8\CEو\EFU\E4X\BB\E2\A9Nm\BE
\93Ė\EBʅ\C6<لé*\94r\D7\00ЪzR\F7rw\A0\B2?f\B4\F8\F1. "\D1vsI\FB\FA\E0\F9\A2Tϖ\C5\E6б:\8FSBX\94\E3\8F\A3\C2\D7\DAg\CB \F2e\B4\E1X\99\FD\E7\C3<U\F9~\A1\A8\8Ct\F7r>'\B1\E5ږ`\9D\EE\E3ȝ\F9t\A7W\AAm;؉p#\CA\FD\D4Y\80C\A0B-\EF&B\81\F8\CC\A1\D8S\92\81P\C0\82\90Hi\A5#\86\B1^s\A0kb\98\A3F n)>3\EEJ\D9\C0"\85RD\FC\B6XR\E2\F8.@E\B9\FAc\C8\C1\C1>\FE»j\D9y\90Xw\83\E5o\923\8C_\AAl\FE\BB\94JI"A\B3gǴ$\A5G%\EF۩Zt\83\B1d\E8\8D7\93\C1\ADm\81\F8ܙ\C1\81\E6\C6$D\91\ADv
BE\BB[\CDd\FF\B3\80!$S\C3e\E5\9D.\A4\94=\00\\E5\8E\926\D9ҕ\C0ab.\F3\E6\A7\FA\91\876\C0U[\CF\F4.\AF\E1B\BA6\E8\E9I\F8G\8C\C5\A8\9E Q\C6,\AC\E1\AA \00`!c\97%Q\BA@`J7\EA\BD\DD\C9\F0\8B\AF\98֤I\81Ĝ=d0\B5=\ADF87\AAT⧲\B7\A3ƆZ\F9\C0\99\9C\B5ҁ\D9O\860l\CCI|d\BE\BF\87]\A2\84\95\FA6\AC\BF\BB\E5\8E~ֶ\BE3\E9\8D'B\B3\9FZ)\B5\EFȄ@@\AA\84	\BC\E2<\B1\CA7'\BB\97e\B6\B6Z\E1\FEhurf0\81d햑\9A\F5+\CD0)\97\C9\ED\A9e\00NJ\CCt\BBB\B6\ACz\CC	\C7?\EA\BD
;'\B3\88\DF\DE|\F3>\81@\F0b(	_0C\91H\CB>GH\FB\CCȌV\C9\CCWIe\A7L
\A5.K\8AF'N\A3H\9B\A3\8B \9F\87b
\CE\D8궰]q+\9B\B5FO\C4)\C6Me\80)8y
\B4\B7ɢ\B3,\8EgX~\D7\8Dz\DB\CE7L\E3<\00`J|0.\F1Ag+C\A2\B2N\D6z\8A\B4-8Df=}\B7L]\F7\98T \CD甊\90ԇ`v\82㐸#\A5\90!\DB\C01 B\80\9DC,\CBf\96\F6\F6\B2\C0Ċ\80\FDV\D7 t\B2\B3?u\89\C3H\AE>\F5k\A7V\C5\FA>\86\B4\92	(v\BBF\92H\F5\C0\D5\DF4C^;\F6\ٺס2\F7ɕ\D2\D8\F2\9AT\83\EDTT\A5\C4\EDH\D3\C8v\00\95$~\BFpeV#l\90\9C\EE(

\B4\A7ǿ\FE\\95òO\82\DF\9F\F2\D8
\B5\99\B3p\96g#\FA,A5YA\D6jc\8A\ACl \EE32\00\00IDAT?6\AE\9D\BA-4KR\D3q\EE\DA>\BDA\FDM\D3e+\B8A\DD$\A9\DE\DE"\FD]R\89\C4~\B5؜@\85ӆ\E7ȴH\F8\9CP\00P^e30hE*o\94\DAƫ\FFv\AF\CE:\EC\DF\00\B8\A6\B2\C0q\F5b\C0\D3w@`b\80\FAT>\95\94[\80N(\8BV$\98H6\E6$+d\86\92\E1\AA\E86\99\D5\F6\98\D4\F7\B7Hw\D54\E9U[\86\C8IFa\EB\E06\B2<wO] m\F3\82\EA\E5pۻ\89H
\8E
'ci\E9ċ`\FB\C1\F0ߍ\9A\FAs\8E|\BC\FB\DA\F1H|b\AB\ECp2h\86\A0%\EF=!\B4s\A9\96A\B4z\CE\92ɦР4\83|\95q,\E4(\ABQii$vC\CF;2\BB\E3		%d$!-\F7H	\FE\D5#X\92\91*阵\9Ft@Q\C4\FA\A4f\C7f\9C	\90\80\A9\88Y\BCe\84+.7f̻tѪ\8Dk<IZ}\D9\E0D\00\00\C1K0\DD\E7\BBf:\DB\ECm\B1)S*\AC\CA=`\95\D5\C4#\A6aF\9C܀Cg\D0N\ED|Uft\BE \D1P\9DtUqqqt\9B H,\89\D5N\94\88\85\81\A9\F3$\B4\AD\A5#\DEӳ®\AA;o\D1=ް\B6\9D\8BG㺔\BDX\CA\D3\90ƴI\B9\BE\BF\D6i\CB\DCz\D3h\AE\CBb̵\EF\95m\EF\CAܖ\DBe\F3\E2}%\81YNB\8FV\BC\9B\E1g838\DA2\EF#7mm\9A\B3\FC\F4\B3\CEF\ACи\DC2b7\CB\00#ic\91\A6\96\E3N\99\B7\B6ыCy^\EC\C2	j\CDa\99;Ò	UP\C6y_*]!?b\F1\B0tu`I\B9-&\83u\997%\838\BB\E0H&\93\F7\E3\F3\8A3>w\D2\EAq=\D5Gi|\D9\A0}\C02T\98\8A\AD\9C40\BD\D2=u\90\D9\ED-Qٱ-(Ӡ̞\9A\80\F6΃|\B8\A1\AE\DE\ED\E9k\C5\C2\CF\C0\A0b\EBc\C5B\BEK\97eY\AF\80\F0?N\C4㷞y\FA\97\FC8\AF\BA,\F1S\F6\00\E8\97 \D5\F6X5蝌\B3fjᠡS\88\9EAe\EE\BB,
\BB$\91`=\C0\D0\92Y\B3*\DE%\F0\DBK\A2\E7\B4P\FBw\A2yF,d\F7\A1\FD,\AB=\91H\AC\C0\F5\8B3\BFtZ\C9R\B8-e\80
\81	\F1\85\C1\E8E\96\9D\F8\B6i$O\AA\C3*}\D4\E6J\D7\FA\D2p0\E8ze\DD\99]\96\8A\C1(\BFS\D9\C9o\EF>v\9Be%\AF^\BAd\C9K\C5"@\A9\DF3nֲ\CE\FA\E2\E7\8D\DF\F4\97\CFT\D8\F1o\85\ED\E4\87)\E6\99=\84\AB\83\F4\D4\C5\F0\C5q\B9`
ˬڰT\C2\F4\D3>D\FE=S\AE\AD\B2I\D6-\B9!c\8D\908oڲ\D6\E0\BAr\E9\92/\FC_\A9	R\EC\F7\8F\00\E8\81y\F2\A8)\F5\93=g\86\ACą\88՚\C9\D37H|\B5\80\E3\AE\E4!
\FB.\00\A0\A0 `\B8\C0\B3zD\BC\A6Q\B6\F5\BFd\B0\B2n-\FC\86\CB\C0\EEo\FE\F2\97p\C7\EF\FB\AE\94\BDH\A7\C8\C1n\E5\D99\CB^:\B2iem2z\80\B0\81\A1\D5ars\87ܠ@\D0D8>(.O@O\82I\ECh\DF\CF\84\9F\9Cy\CA\E7Z\DEwTO\E9\F0\B8\E3\00\E9\C4ZwD\DDa\88\85\A0\95<.\F9O\B1@\93q{2(*\82\D2\DF\DF/\9D\00\00tH\F8\ED\E1\FA1\CD5\AE\F8ޢ'\FBx?^\F7\BD\EC\83B3i\C1\9A\EEG\EE\9A~\F8	\81Ȓ\B8x\91\8E\9BF(\88Ӱ8\DB\D1\83X\C0:-W\90\E6z3</<i\CA񻉿sT\C7=H\C8SG7O\9A\EF=7b%΃r7e=N\82\C6Z}\88\FF;;Y\B6\E8\A9\FE\8D\99\00\F5~\FB\FB{
\00\9Ax\AFٰ0\8F]\DE\8DOB\C1w=\9F\E0F\EF\DD\E5\FD49}\EE\D3G4\FC~\EA\F3\EE\BE\EE\81\ACG\E0\FF\FC\A6\EE.\C3F\BE\00\00\00\00IEND\AEB`\82
EOF'

cd /usr/local/share/icons/hicolor/16x16/apps
sudo bash -c 'cat <<EOF > duckstation-qt.png
\89PNG

\00\00\00
IHDR\00\00\00\00\00\00\00\00\00\F3\FFa\00\00\00bKGD\00\FF\00\FF\00\FF\A0\BD\A7\93\00\008IDAT8\8Dm\91?LSQ\87\BF\FB^_񵴴5\FE\A1%1F!0\A01\C1M\8C\E3`\D8pr .:8J\8Cё\D1
\89F\D6V\8D\83A\89DQ\DAP\ABH\A0\B4y\ED\A3<\E8{\BD\D0\A5g:\F7\9C\DF\FD\CE=\BF+\D8\F2GE+\E5s*C\80\87Qq\8B\8APJ\89=A\93%a@\BE\A5\95\CF\C0\E0!*q\F9\9E[\95\00QJ\8CA,\ADSo\E3GaKӇ\DC\ED\EF\A88\BCW8\F0\82Z\95LV\81\B0\9A\E2ҿI\84\93
\C0\E0\90#\83`\93\E0^\A6`}\84z\A5\87\AB\BAJ3(\BCyX|\FEF8\DCb\DFLJ\C1\D647l\EE\F7\C0\93!\9C\89rNfɱ3\D5\EF\B7\80lV\FF\C0\B7e\8D肎\EE.:UM\F4\AC\E2\F99\81ψ\91G\A1Ҷ{\AFgan\A8Y\A7%Q\E8\94Ct\00\D4(P\AB\C2\DA,\9E\DFq\BB\D3S\BA7\DB-\D3\F6' F\80,\CF\E5\DA\F7J`;`\ACa\D3
\A1p׃\BF\DE-c\D8\F5dh\E1)Ef\CB&\96ۻ\F6N\C1
5=@§Ao\E0\86\F9\95\EF\C1{,\EE\FB+\C0/\A0)\A8\81Y\B2I\00ue~2x\8A\98\E8߽\^A<#I\9A3\C0r\81\B6$\99#J\9EVq\96*\A2\BC\82gx,o3.\B3bAH\AF\E50\95x\E4\B3Z\BD\B9\F4\86\81\C8U\94ʂci&μ7\A1&'?\DE\FD\9B1\8E]\98^:\D1O\85.Wj\AB\00T\AF\CF;\DE\DCش6sm~\E0\FE\D4\CAɎ\E1\8EHz\AC\9AVT+F\FA\CF7\B9\F3\E9W\97\9E\E8~\F9\E5\BABV\D3\FC\88\98\C3\E3\B7\00\00\00\00IEND\AEB`\82
EOF'

cd /usr/local/share/icons/hicolor/24x24/apps
sudo bash -c 'cat <<EOF > duckstation-qt.png
\89PNG

\00\00\00
IHDR\00\00\00\00\00\00\00\00\00\E0w=\F8\00\00\00sRGB\00\AE\CE\E9\00\00aIDATHK\A5\94klSe\C7\EF\E9m\DDj\BBu\EC>6\AE\8B\802\D0\97E`s\D1\C9僙р#1\FAA\93\85\C8\D694F#D\83\E12\B2\F0A"ӄ)b\B8\C4Ka:\84\8C\EB6tt-\EB\D6\CBvz\8E9=m\A5Ђ\89O\D2\E4=\EF\FB\F4\FF\FE\FF\E7y_A\F2\80\9A\E4H\E4\E5\91~\B3\83S\97q\B1׃PR`D\B65\A0x\B8\EA\99\F0\E4#\BC\FE\F4\A3[\F6Х|Ώ\AE(\80\AB\81\FC\A6\D6`\A0\98\R\E0\AB\F7\DBٱ\A1\8D\A9HB\DB9g.\E0a@\C2\CCU\D7~V6\B7q\C2\DB\C5"\87\95\DD@\DE\DDE\C3?벪\D8!Ľj	^ch\A4\944\E7X	\CB\FD\D44\89t\9E\8Ah\8D\99\96|}\AAy'\B5\AE\FA\EFT\93@\A0\AE\E5\C8P\98J\E7r\CC\E4\E0\C3\CDϣ\87X8\96\F6I`\B0&5B&\88@"\DC\F2\8D\9CNI03[\F7K\BCmX\CE!(\C4A\F8\CB~
*!M3Ik\AB^\9A\8F!lH\F8\9B\F7S\E9\DAǙT&\F583Q\D8	̋$\81NA_Hw(-
\80\F0\CAo\D9 \FC\9B;\D5\D4r/\8Aؖ1\93\900F\FE\BE\D1A\C7\C1'\EBkGdO\D3׷\C7a\C9\F6l\9E-\AB\81\80\B7<\A5\CFjV\99$\DA=&\94\C2\F8%#\B6\C11@\86\A0Q\C1\A9\90ĉ\AB6j}\BFl\E5\99Y\FF\EE\A3@#pi\BF\82q\B2gpL\C6\CCQ\81\FDc\83\A3\AA\F6;\989\D9\CE\EE\D5\D7\E1lDm\E8\DDn\967\E6\8E\F5!>Ej=k\B4\DE\83{L?\B6\D8	;@\B2YQ\C60\AE\EA*2
\E1א\85y\A61\B2ܪ\DE+=<\C0\AE
\97ع\F1'\FE\D06\E2\9A\82L#\ED\8A
\9A
9:\F3B\80\C1%e@/\F8e\E4\829N6\98j\89\A5d6F}Vc\E4b\DEKi\9C\EE\F1xUH&(\AD\E1\F5w\B5BF9\;\97\A2\DA$|\F3J\C10
\AB\D7Ɩ[*\AE\E9.\86b\C5`\FF\83\91\B8\930eI\E4\89\DCUQ\AC\DF\EE\A5\FB\A4\8B\EE98\B7\F4\F2\91\EBHd,\E2q\8FE\B1ͪ\EB!\AB\FC\AB\C0\00\98\80\FC\84\E9\BB\DC*\96\A2i\D6\E6.!\E2C\AFR\97e\A6M\BBKZ\86ւ[\D1ُ[\A4\E4\00\89O\C6aQ\CEs\C9\C0,\AA\9F\8B\A9PP\D9\F4o\A2\B0L;)\FAh\AAjԢL@\FB\E9qY\81\AF\DF\DBʶ\C6V\CE\DF]y\EC;᱋m\BA_\A1\DAif\82\B7\B4^HP\FA\88¨5\BF\98\B8\9E\E97\DCܼs擑$%\88\94\E7"\AD\B4\9F\BDa\85e@\F1\8B [\BD։\B1\F0<=\D6"։V\BE\A2\B7&\B9\86\94Z\FAE\D2[\F5S\D5M\D3
T\D9[]\B6\F7\CA\9F\9D\83\8B\9D%V\B9\D0\BD\EA\D6\DC.\F9\9DT\F6$\F4 YҪ<jW\E4б _\84\CF=\B1t\E0줚I\F5\FDi*\F9\B6Q\DC\DB\C1E'<K\FFA݊\E3\87e\8Fۋ\FD\F6\A3\EB\B9^2_\B1\F5]p\A7\FDй\F1\F9/Oz?\F0*\98\EB0\9567\BB\9Fw\B1\C5i7z\8A\E7\\B9X\B1\F6\93\CD\AF\DF\D3\D3\D3\E3~\F8	\A2\00\96	\E98,\9C]\B7\F2\D8omW\BCx\FFp,\E7\EB9\92(\8DGBn\00\00\00\00IEND\AEB`\82
EOF'

cd /usr/local/share/icons/hicolor/256x256/apps
sudo bash -c 'cat <<EOF > duckstation-qt.png
\89PNG

\00\00\00
IHDR\00\00\00\00\00\00\00\00\00\r\A8f\00\00piCCPicc\00\00(\91u\91\BDK\C3P\C5O[KE+Tq\C8Pš\85\A2 \8E\B5]\8A\94Z\C1\AAK\F2\9A\B4B\92\86\97)\AE\82\8BC\C1At\F1k\F0?\D0UpUEq\F1\F0k\91\EFk
-Ҿ\CB\CB\FDq\F2\CE\E5\E5\F0gtf\D8}	\C00\9EK\A7\A4\D5zG\90*L5*3\DBZ\C8f3\E8\B9~\E1\FD!.f\F5>\D7u
U\9B\BE~\E29fq\878I\9C\D9r,\C1{\C4#\AC,\89O\88c\9C.H|+t\C5\E37\C1%\8F\BF\F3|n\F0\8B\99R\A9\83\95fenOG
\BD\CAZ\F7_V͕e\EA\E3\B4'`#\874R\90\A0\A0\8AM\E8p\A7nRf\DD}\89\A6o	\F20zZ\A8\81\93\A3\842yc\A4Vi\AAJ]#]\A5\D2Q\B9\FF\CF\D3\D6fg\BC\E9\E1|u\DD\CFI \B44\EA\AE\FB{꺍3 \F0\\9Bm\85r\9A\FF&\BD\DE֢\C7@d\B8\BCik\CAp\B5\8C=[2\97\9BR\80\B6_Ӏ\8F`\A8\00\DF\EB^V\AD\F78\F2\DB\F4\8B\EE\80\C3#`\8A\CEG6\FE\00\81\F9gТ\FE\A1\D9\00\00\00	pHYs\00\00\00\00\D2\DD~\FC\00\00 \00IDATx^\ED}\9C,U\99\EFW'\A7\98\9B\EF%\82w\91\8Ci]Q\D7,npA]\95\DD\FD\ED\BE]e\85\F5@\D9yꢫ$\C1DR$
I\97\9B&\DDɩ\A7\E3\FB\FFOՙ\E9\99;\D3]\D5]\D5]\DD]jznOթs\BEs\BE\8EH\D0 @ \80@\00\81\00 @ \80\80=\E4\EE\92\D7\E5\F6\EE\EE\F2B~P0\9Eځ\00\90\FFe\92wKV\CE\CC\DD.m\B53\F2`\A4F\00\8A\00N!\00\C4_\87g\FEZ\F9\98Ĥ[2\F8WV~\87\CF\8D\E5f\A7\FD\F7W\A8\ECk\EE͹_K+\FD\DD@\FCO\F1_\A0\9FwQD\FD>\87\9F?\C1\E7\C5 \D7\DCp\C0h\C0Ew:\E5\DC\EF\81\E2	y
~~F\C2r\A2z>\BDL/T(\A3\B8R2"9\F9&\AE/'H\9F\D3\F7\F7W\A8\ACk\F2M\B9;\E5 \FE?\E0z'\90;*I\D3 !\A0D\90\96'A.\F1\B8\D68?\83\E6;\C0wK\E2\8F\E5\EE\9050\F0}\88\FFq\88\FB\AB\C1թ\E7;k$9u݁g\FF\D2\C0\AF\9Cu\DC\ED5\E05\84k\AC\E8\F91 \ECۀ\F8\9F\BF?b^\CF/u\F6\81Yt\F1=\92/'C2\9A/ \00_,C\F5\91{!\C6\F0
\E8\F7\86|׫\A1\EBS\97w\AF-\D8@`\BE\89\E0r
\F7\B9\F7\82\A0\A7R Pw \F7K\AEqp\B0\B6\F1\EF\E5\C6'\95\B4\80\B8 \A0\F6\\EF\85\EEޤ\DF+\A8\91\B0\F0\CA\C8v\81\8BaS\F8\BEq\AA\923\82V\D4\80\FAX%\BA\86\E4\A5\AF\F2\BF\F8\FCt\CF\FB\AA\00[߿\BEN\C0\E8C\B8>q\83\B2\EC;\D5\F3K\9D%\EDY\90\99\9C܂\8B\F6\81ߕ\DAU\F0\\E9\A8\00\C4\DF\A4\FF\C0\F0Ap\B0\F6yѕ.\A9\B4L`\A3]\85\DF.\C3&\DBU:\A8\EA\E7\C9\DCM\E0\C1\F2fE,#\88\E6#\D2W\83k\FB@Z\A60\96\FF\C6.\85Z\F0l\FD@\DA\FF3\A9i\00\83U@|\AE\F3 \F6oV.\AA\A5\8C\E2&\B9͜\EC \00\B7\B9\9Bl\D2\FFK\E3\CD\E7\A5$RRh祸ow
\B4\C4p%e֏kt\D6h\CC\EE\E3\C1}\A5C\A0&	@\EEFl\DCNy#~^\80M|\8C\D2W\97Lɇ\89\00g\9B\96{\B0\C9>\8F\DFn\C4&\F3J\D3-}E<z\E2\FEf\CC\FF<HJg\CFKI~\9B=׈\C4 %\E1\E7\BF\E1\F3㔪\C8&\AD\82\FF\BA\AD9\00v$\C0\C8\C0\94\B7Co
\D9
Lɇ\BB\C9i(\F0\FE\AE\CFC-x\D4\CB\E2ވ`\E0k\94ޏ\EB\D3@\FC\AD\D5\F3K\9D\86\A9\BAQ\96\BB$\FAB\AC\D1\FD\A5v<W5C\00\AC\94\BF\C1t>
q\BF[!~\A9\8C\B3&!\98CȪ\C8\E5\D8j_5N\92\FEz\DB,\80\D9\EB\81\F84\8A\AF\E6VLJ\F2\00\D6húÊw\FBi\88\F50\DF\80\DCoT\CA\FB\00\EC\F3\81\F8\A9M\EC\96\C1j\C1>\F0z\BD׵\D8d3\B5\BE\B0@\FC\97(\9F!o׏\F9B\CF/\A8\F96\86\E7\E4놵\E1\94
ƕ\9E\F3-\C8݀\EDۅA`JD^\E5)\A3\EEirȻ\F0\F3\DFa\93\FE\A5\F1\FA\92\E5\B7\D7\C8v\F7{a\DF7\D3t\A3\D2S\96\94d\FB\AD\BAQ\DBpRp\C2m\88\B7\DE
N\A5\9C\96\9Ad\E5_\E3K\00v@\F1\\EFP	(nF\A4\82\B1\99\C9F\E5\E2\B8hx\A2\F2K\E2\FC\8D\B9\DB\BCUi\BA\9F\B1<\AC&\F4|\E7\D34\9F0\D7ȴ\E1\E4\E3q\A2\FC\A1Ԯ\82\E7L\BB\B8o\AAʬcʹX\E85U]	s\931d\F5+\E01߀\C8\E9ېU\CBS\00\B3\CFa\AC\A7*z-\E9\F9\A55Ƽ\BF\815\FA\BFX\A3\81R\BBk\E4\E7|A\00rO\83\83\F5\C1\AA/\B0T\C7\F2PJ5򕻢\84
uO\D3%\F5(\D2a\89\F8\A1q\94RZ\E1\D6{!\C6x>\C6\F6n|6W\85X\96\E7r\9F_\B0\FC]\FD\E4\82\EF!Ѩ\E6m8\E5\82\C5\C9\F3U'\00\89+\E4\A8\D8A\F2%#&'+y\A4R\E2\BE](Q0+\DF\FC\92\BA5\E2֟\B6\FB\A8\F7A\CF_mII\D4\F3()M׋\81U\B3O\9Dv\9CAڱ\A0\D1	\F2\B3j\A7\96ޭ\CD_\D5\F3\E4e\89A99|\A0db\9D\E0\B9Y\A0Y\B58\FF\F2PȩQu\CAi\F0B0g\AE*\00IN\B4\E7\BFc\A1\9E\A4"J,\C0\B4\B5'&'\81 \BEjѵ,D\FB\00%\83\A0\80@իǳ\D8\CA;D\F6\DE&\A1\D1\ED\92Φ\A0\C5R\B4\AB\BAl\821\84\D4X2\D8L!ق\AB*Vg\84<\FF9\94\A4c\D7\E0:R\99)\DDr\85\D6z\98Պ\E2\F8\EFl\C0\E9v\C0\EDs\B0+\AD\AA\A7)\BA=\97\AA\00N\A89\8E\B8\9C\8C\C3\DB%\BA\F7v1\A6\9E\CF\D9H\AA\D1\F5n*#$L\905OW\B9L9k\CE\D0\F3\B7`\A3\B8\A3x\83"D\8D`\E4+g\CD)=R2
\C1%\91q\DD\89\E0]\B9\9BUFHЖ@\C0\80c\EAFd^?7.\E1\81{$\D2\F7k\C9%\86\80\84!\B5\ED+Ө|\84\81b\FC\CC@\C3\CE\E2\CD|7S\8E(\91TH5\81\9E\DF\C4\FF\C6\C2\FA<\8D\F7\B6ՕO\BF\ABI	\89$<\82\A0\A8\90\FC?\AC\E1\F5 \A8fDd\D0\E6!\E0\AA\D8Dk\982q͘\E9\97pb\9F\84\DA\BD\DEu\98\91v%\8C{eм\D5\C0;"|+.H(\95@\FE܏1\BF\D5V\9AnX\8EV
G\A0症\AE$fX\F1\EBADO\804\F0\C0\F5Kpi\C7JP\F2K\C3"u\81i\A9\DF\C0/9ǟ\96\E8\D8ƞ\90L6\BD=\DDy}R\B0&\EF\CF*1q\C1\FA\C0\C1h\EE\EF\CE\DBV\EC\FFh \FFux\FBu\C9ъ{z\BE;P\D7j\81I*\8E\93\B0\DCi\E0 \EDv{\F1\C0"\C51\9A6"\BE\86'E\FC;\93\90\D0\F0\C3P\EE\80d\B0\DBr|\95k0y=m
\D4\ED\A3\FB)\FC\9E\87]1i\C8C\D1\E2\FE \FF%@\FC_b\A5\C6\E17Wh\ED\EE\EF\C5#\D7UH6֗\D2?xS\EE;\BE09W\CA\FE!\00\D6\F4;\E1w\8F,\F5\00X\84 1*\A1\FE\DFJ\A4\FFn\C9&\87\95\85\9ENCg\8DJ9\BE\D6\F3\C9\F9\976"<\FD\FF\E4!?\BF
\9B\EF\AF-=\FF\93\AA\C2A9\8EΠ\D0\D8w\EB\8D"r\F6\C2e\9B\FC\EBqt#\C576\00
\FC(\BA(9k\F7~t\C0$W\C6\F4\89 v ׾M2\9D\87I6\D2b\91\82\C2\C8J\C47\85j"=\8B\86jD~`\E2\E2\CE\C8=\80\F7NC5\93\9C\FELu\E8\F9.B\D8fW\DC+$\B8\F6Bv\97\94\9CI\EC\9B\D8!+n\98\B4c\DFI\00\\BEv ^\E8\B9>S-\C8\C2 8\F6'\89\EC\FD\95OI&\97\B1\EC˭\BF)\EEӁƐ\9EHA\E4\E7Ki\F4\F3\E0\AC[\95\E44
_>\CFϋ\F9I\8E\B7\9EM\8C\F5\E8\B6\FB@\A4>Yݎu\FA(\AF\9A<z\A3\AF\BA\F5%[\C1\82\90\B2Ԃ\F4\AC\84\F7=Bp\A7\C8l\9Fr\D2yg6\FA\F3\A9Q\93\D7k\B7^1\F0\F3^\FE؇K\E2?O\D9\C1\A6\FA7\F4x\FF=O$\F7\8B-D\85\FFNbL\89 $\83Y\\F4\BFkvZ\85GQ\F1\D7\F9\92\00
m\90\E8,\8A\83DX\DC\97a\B8\EF7\F8-\EC\A3ʲO\C4g8Q\C4vH_fF\FC\D9xq\F1\B5\CA="-+?\A8\F4\FC\B8\FC#F\B2:@\FC\E2p\AB\EA\BA4za\C5a\B9	i\BE\8B\8B\E9\E9u\D9|g\D0P&^w\C1\97\B0\A9S- ϟ\DA)\80\F4\86\93Ahp\D2tЏ\DC?\F9\FF \E2\E3\E0\8B\B0U\CCd\DA\C9@\82{\ABS\88C-xԴW\E7~!_\85\FAv\89\F1&\E1gu\D3|K\00\E1\F1̮\B1_\C7\E4\9C\EA\D6.\FD\A4\EF\91SC[\80\FC\9B%nRFJW\A4\8A\BA\D9y\B50s\D3Q\8A\"p\88ϗ\D8SC\B7;Fߪ\00z\9D Q!\BB\D8ow\D6\CB\DDGR\D8I\A2\9CN\9EmNH.\89zBb2\A6\9ES\F1f\8Ca\D0j\A6\9B8\83\D0Ԍ\AA@HC2\C3\D2\EB\AC\F9\9E\004-
\F2b4\F7\A7\EF߭%\C6jfѴ\84~/Q\E46\C8m0\8D\8B\BE\87\BA@\AE\91>M\90A间\8Cc\A5fU2\E3BH\EA\AE\F9Z\D0\D0f\88\F0\80\9Fq9\F3\97ѫ\A0\9F\8C\CA#6\EDCdrB\B3 \00\ED[\90\F8\84\AA\C8m0\B3\BD\98S\DDm\D3
M\88^#\D6\9C\E2'\81\F2$\C4\80\AA$\82{?\EF\9A\E0E\EA\C0Bx\86+:\E8\C7%x\E7\EE\91\C3\E1Lz-9\BDqV\E2?&0\81\94=\B7\8B\8CC=@탅\E4\97\DEtSLoQ
\A2~\\9FEh\C3\F3\AA =B5\81%%\CCۢo\A5=Y\E1\A7:\98)\84J\82\BB\A4\A6\9B\85A?\CC\F8s\81\BA \C1d
\F7Q \FE\C7Q\94\FB\00\C1ia\00J0\83fԙ\CAmH' \A0\96\ED\E4.Sh\DD`\FE\AD^\B9L\85\B7\8A\FDי\88\9F\85\98\9FS\A2\FE\D2\E8P\AA\84T\E3\EA\B8Մ
@\F8\EB\E0 \85Hn5\F4cq\E7R\BBEY\EE(x\C6[\C1)>\8B\DF^\AC\88I\9E\82iΌi\98\B1\88\97\C1\F7\B2\F6\C1\A8\C8\00\C5n]"Bg\ED39)h^B\80\F0\A7F?\87\9F\F7\99U\B2W\D1\DC\DF\E6\E0\E5t\CA\E9\BBf\00'\C9L\C1I ҬR\00\95U~x\95\B1\C0\88;\9B\E73\B8^\A7\C4|\D3\BC\A8\CD\C74\E0o\B9\BCw\D6}S\88<\9F\84\9A\B3\84\E0P\D0\86!\D3\E0TƸ\CA\D9u\FB\ACv륁\F20\CEb\ADx>\F2\FE"\A5\96\DD4
\FB\A85E\00"a\C4	7\A4\00vF\DD\DF\E4\8E\C4\FD\F1짰\8D\DE\AEߢ\BF@\AF.x2\B9\\92S\A0\F1=rd
^\E6n$:\89\A1+;]\F0\C0~\D0n=\86\F1$\AC\BA+\E9\92$\CC\E4\FE
\D0j\8A\00p=\9A\81,\AAr\90\83\E0\A0\FD\D6Q\BB\FDh\DDu\82\FC!\99\CB\FD
\C8\95\F9σ~\B8I!\BD\CDhE\ED\CD\C8.\F7΅\DCzв\EA\81j\81ZP:\9A>\AD\F4\FCn4"qmL\B7\9F\B3\BDQ\DA\E8\AA\FET\CD\D97\B5P\D6\C0)\AA;
\FAa͠\84\BC[\E8gV1\89M
\F1 &3i\CC,Dsh\A0\A1\B9
\82\DA2x\8Bq\BCgq\AD\A2\AAo\DF\C0\ED\B3\90\CCRʟ?\AD<\F9\85\91\9F\93\E2\DEp)\C4\F70\B2\B6U\B5\C7Y|Q\96\8C\90n\B5v,\D4x)R\00\B1\AF\94J?&\A2\FF\8D\B2
\D3\C0\E7Dr\C8?ݙ\94^Rx\BE\907C\D9p\CF\E4\F3*\86@:\CD:\FB\936\8B:Hqm\9A@\CDb\8D2J\CFO9$\9D\E4\FEe\85]\9BK:*\8B\91\BA4\BE)ltǕu\E5 GxX^\D0\83AM=\DF\D1KC\89Վ\DEl\ABY\D2\00\E3FC\FC\C0 8\96D\83\B0\E2\FDAh\BA\F5\D2\DF\CD\CA\9F\FE|'^c\DE\EDT-\B4\B5\90\FE\BD\A9\FA $\D7c\B9\DE=\A2\96\CB\E6\88tp\90cЖ\F4C\EE߽[\9C\97O(\C5ئ#!H!&}\F0~\A8\BF\81'\84Gaa\C5\E6\F2\9B\?\8D5\CA\00\F1C\F3F>\A7\9B\83\A2\BFkA&N_^\9D\FBm\A2\9Bw\833.\97\A4\F1
u\94\D3ɸ\FEo\EA\B7+\B4Q\9F.T9h\BFQ;
\FA!\86Rϧ\E5\D8iva\90\E8]\BBӽF\B5\80\F6\AA\FD\BF1\F8=\92	t\D6\C8\F6\EA\F9s\E0\F5D\FC)e\E4+mO\86u\F4\B3ܖ,
X\D0\E3
1\B84\FCD ۷\DAsUp\AD\B5v\B9\BF]љ\A2>ϙ-S\E4_ih\AD,xR\C4 \B8ҳVʳL>\87#\D5\EE\80\FB\EAA\96nHg\AF]\A8\F9\EF>mࣸ?\94\9F\84\81\8F\B9z\E54\DAV\CA로\B7W\EDY\DFMٸR\FE\89\E0C\90\FEK\FB3\C5& -\83\83\981XP\9C֮;A?\D4\F3\C9\F1\C9\F9m\CB\E8\CE\D7O{3TT`)M\BB
1\CE\E1GLB0\B9\A3\EC\D4\F3\E9֛Vz~X\F3\94Ӹ\C6\E4\FC
\E2\F6[
*\DF\00=@\81\DB\C1}\CF\C0b\9F\8D뉕\B8\DB<"\DA\9C%\DD~\85f\AB\F5|"\85\AC\ECj+F\BC\8Aln\ED6đjJ%\A0}`>\ED\B8T\E2RBy\F5\AC\C9\F53 \CEAy\F8ec\F7Ky\B7\FA\A9'X9\80\83o	\00\E7`\%s Wc\C9O\BD\BF_\ED[N\DFe堖\95\C4i\F2\BB\D2\F1^\FC;\C5g\97\F5|\BBk\A0NCra\F3)\FB\00\FA\99\E9\E9\BB\80B0Q\8Ae\C8j]-\D0\E2~Z\F9\F3Y_\A1t=\E9\A2\E8\90_\CAJ{v\F7B5\EE\F35\98\97\AE\94~\D8\FE\8Bt*\88\C1\B5
e\F3\D4n|"\92\E5:_\80\A3v\97\ADt\BC
{D\FC*\C8\B3b\DC\DA\CA>\00	f\99\88}w\E0\F3\8F\B0p\9E\B5Hh\E0c]\85I|\8Eϻ\F5\DC\C3\ED\F6s\AFǚ\EB\A9&\C0<!\F8\86<Bp&\C1\D8\BF\C9w\83\D1@\F7\DA~\88\C4Tߥ\C7{i=\9F\AE=\91|^\AD.\E3\E8\D6t\8B\E8\B4\E3\88۾\87M\FB\C0\F4.\CB>P+n\9B\86\D6\D4\F3犜\E5P\CA\C2h\BBPy\84R\DE\EC\ABgja;\EC0\A8\B7\E2\CB\D7b\9B\9C\8B\EBY\CD\DD4"\A9\F2\83~t\F9n\BD
\E9\F9vV\DBQp\90\9D\AD{\E6\EDV\DA1S\8FQ1ٿҀ\D6\F3\E7\80\FCt\EBQ\DC/v\82\93x,\BAUW\FAq\8D\EA\96:\90\EA>W\93\80 \83$0\8D\EBrl\90!&^\86\AF&\A3\B0\E4\92̯)\DD~\B4\EE\92\CBS\CC\D7n\BD\EA\C2|ٷ;r0V\E4\9AF\DA1\A3	qЪ*J\E2\AB\F8\F8\B4\9E\AF\DDz.\D8FVS\9DW\FA\B1\BB=j\96\00\E8	B؍\EB<\88\89\A7\E0\FA^\A7!\B3\88\E6\E7\E2\90(\FES\FF\E5f\AF\A2\9Eog1Tp\88\97\97{^\D9\98v\BB@\DF\ED(O\86\F4c\DAl\C7Fؙ\88\D3{L\B7^
A<,ǥ\C3w\9D\F6b\FF~-z|\EA\B3\FDU\F7Κ'\00\F3\E0\FB\B6<*\90\C4v\F6\E2\DBV\E0\92\B6\EE\FBH\DC/\B4\DCLsn*18\C8\F66\B2\E2\92S"C\98\F6\A9fR\9EJ\EE\86=\9F\E1\BBa\D7\DCz\C5\00\C1y2޿\92s-6\A6*\FE\BD\E6M 8z\8B\B6\E23`\BC\00\E2\FE\D1(\D3!M\AC\B1\C7\E6F\E1\90
.\F7f7\C0\96ת\A9\AEF\94\864\80\B0\E2\B6MfY\B2X\E1e\B5b-\E2$1Ef\EB\A5q\99\BA\BF\F7M\BB\FD\EE?\EB\9A&\00\A8\CA\F3r\CC\E43\D8Bo\F2\B3ē\D9jد\AB\9EL\96\92\EA\
YG\AAͧ3\E5\B8\E3\D0
t)l7)\91\9C*\E3x\8C+[%_\C3E\FD\94\00\A7z}\A4&	\00N\DB\DD\00\A1\F1o\C0C>
_\A7B\FC|n\EF榭\C2\CA3ՙ\E7 T\D2C\A9\8E\G\DE\C3\C8\E3\A8W\00c!\A5\81\B6\CDf\F2Qّ\91Dr\AE	\9Fq\FC\BD\92\88\CF5\DC~\CB\EE\E4\9A"\008\A5\B5
Xq&f\F2I \FEA\8A\9B\D8,\C7U<.\F9\95q \BDc\CB\D4,\B9S;j\FB\00Ҏ\87V\CC܂\EEÑ\B4\B4\D6z\D8)E҈O#,=0\B4\C5TJ\DC_:\DF \E8\A7v	\00\EA\F0Q\AC-\90\FF|\AFfR\87\88\9F\BFBtgNۨd\AF\9Dޣ\ED\AC9\C0\D2d\ED\90:Q\9F0\C6|
;\F6\CDݙIi\8A\FB\D5C|=y\AA45\AC:]C\BB\F7\FB^@\D9\EDc2\9F\C6\F5\E8\F9<\B5\A5!\9A\E2\B1b\D5j\DA>0\81\B4\E3i\D4 \E8dY2\!\E6U\AC\E4Y!\F2\F3o\E4\F8:\A3\B2\D2\E2~>\C0(\FAA?+n!\DF\00 >Ϗ\E1:\A7\F7\AC-Vv\BBZH\E2\E5{Y\F7\90\C6\C097\CEA(c\A0$ \F3ȣ\A6}\A0\87\A7mD\874\AAiB\A0\C5}">\F5|J
\D5\F7\97\CE\D5\CE:\91\A4\C6\EDGN\97\D9w\00\96\FDfl\9Cwa"\D4\F3_\A86X\9D\8B\FB+-\8FEgpЀܙ\FA4\A3\E4R\8EQ\A9\B8\B1$\F1\D5\BD\B1\A6\B8_M=) \ED\FD\90H\C6\C3#\86\B4@\B2i\8E\E3\A1"\BE
\87\00\D7?\C8#,\FCWaQ^\A8\B8~\8D\F18\A5\BCv\EF\D7Ǌ\F9eOΧ\EFEҎ\C7p\C6!y \AA\E4q}\BB\93\F3\FA>"\F7Ju\FE\F87x[P\B1\AE\BE5$\EF\FFz\8F<7\84/|\85^\C8Ԏ\AAހ\F801\C9\F9@\FE3\B1(M\B5\C0\E3%\00Up\F6\E5\A4 \BF\CEW\B9
ᥘ!\E8:\C0䢾`~\D0\CF\D2\E2X\A1\A2\DC\F6`H.\FEߐ\DC\F5D\93\BC\E4\B05\F8\E1\91
֪J\00\E0\CF\EF\C5=\88\FF\B7\F7P>\88\BB~\DB\ACĂ'e\9D\86\E4Ť,\B7a\C5}\FAv\E6\92\CF\FD5\E5$wǎj\A7!\FF\F1\E3\B0\{gs\B2i\D3jii\8EIv\D9#\9B켬v\EF\A9
@]\FB\88\DC-o\C7\F8,~;Jq\8D\F8մ\BB\B5\8E́\B6\80\D9
\B9\8E\8A\F7\C3\FDD\D1_K%\96\B8?:f\C87~\92+n	\C9\F3\83\86D\C29\E9\EEl\91\9E\9En\C9"K\AA\F1\BF\F2*@\E2K\B2!{\A3\jC\D1OF\813H\A4\DE9
\83\94\$\EA4\A4j[?\E9%z\AC:\E8\C72\F0%\B1\C7~\F4\EB\90|\E9\FA\B0<\F0\B4!a\C02\AEJ\80\B2f\EDZ	\87\C38l\85g\BF5^\AB\BC\F0\84l@ݺ7J\A6u\83:\AB-Tј\D7J\AC1	\80\FE\FBjUl\AE\BCC\EB\FE\8CU@\FB\EDc\86|\F1Ga\B9\F9\81\90d\A0\F7ǭ2\F2\D9lV\BA\BA\BB\A5\BD\BD\9C\C9x_\B9J\B4]\99\8FǝT\9C\00\80\F2fQ\D5U\FA\EF\95\D0\F4z\C9t\BEP\B2\F1n\D8\FDyjk#\92`\CC\E0 \9E-8\ECqq0\DF\CA\8D\F2\EF;\B9솰\FC\F7m!\85m/\86\EF\C3y\BB=\8A\EA1k\C1\FD
\FA7\E7\F7\9D\8B"\9B\BF\A14?\BA\8A\00r\FB8
=\B5\A3\D4\D3\C8N\89\CCH\AEQ\FD\9D\87H(ܬ\A4\81\80\D8<\9A\82z1\87M\DBx\DB\D5V1\E4\DC\FF\F9\FF\F3\FA\90D\B0\C35\D7\D7O\E7\C0\EE{zz\A4\B9\A9	\9C\DF\CCL\E2\87\FA\B5\C1Zռ\9E\CCx#UΤ\C4}\\A2{nc\E2iI\E7X\D6\EE\E9=
\B6X\9C\AE>
)@\FE%\8B\AFC~-\D1?"\C2>
-\D9\E1D\F8x<.\ABV\ADZ\D4oD#`\D5\007\B2:%\D7r%\A5\A7$4t\BFDY\D36\90fU\9D\BF)\8B߂\83|\AD%n\BFO\\C2֬Y#\B1X\CC\E2\FE\E6\E8s9n\B8\C6#\AB\95W\F2v\8F\F5\9A\80k+\C9Xw ;\C1?;$\E1Ĉ\84\DA7I\869\E9ю\C0>\B0\C1'\E5b&,\EC5\C5\FEb\87{\D2\D8\D7\DE\D6&\9D\9D\9D\8B\90A5\F0)\AB\E8 \AA\C7c!sQ
\E8^B\82T**\EC\00\C8@\8B@-\E3\E0\CB4
U\98jA\E3\E87+\91\806\A0ں?Lt\A5\9F"\FB#}\80\DC\DFt\FB-\86\FF\D8\00*J{̗Q\9C\E5\D1^\8B\96\C3Rp\E2\AD1\FC\A8D\F7\DE.\8AS\A4\B1@\D9\C0>\B0\B0Hn+V\85ew\EF\95\DA\EDW$Y\B9\FD\C0\F9\E9\F6[\8A\FC\A6\C0\FF\8F\C3TO\B0\B6\80ga\\F4!H\8EKh\F0^\89\F4\DF%\B9Ā\AA&\D8(\F128\A8ѥ\00\95~\88\F0\D4\F9\C9\FD\97k\D4\FF\93\99\C6C~¢\AA6\00\BD\EA\94\+\F7}\D9e\B0\EC3\83\B0\C3>\B0E\D2]\87\89i\EC
d\93\FBs\9F\D1\EA\DF4\EF\F6[ s鐴D\92\F2֣\E4\B0
ȸj\B0\ECS_\00.7\F2\8C\81\85\1\B4\C0Mh\8C?#\D1齒E\EC@\A6\E3`\D8c\8A4\A4B\DC\D0\C1Aܽ\8C\F9/`!\F7\A7\BF\BFQ\F9-\95A:NE9\FE\E0}\F2\E1\FB\E5\A8mVL\BAӺ\87\EE)3U\E9\C97@źC
(Z\D3RP\A1&4\FC\88\84\A6vI\A6\FBI\B5\AE\D5aX\B1\8Dm\A1\82\83|P9\C8\C6P\DFB\85\94\81y,\86jG"\D7| \00\8C5\D7n?\DA2YVe\91C׎\CBٯ\EA\97W\BFdR"f\EEF6\DF\00-\D8.\84i\829\9C*3\F0[	7\F7J\BA\E7p\84\AF\B2\FC
D\C9uL\C5P\AD\BA\AD\A4\9D\C1\E7\F8m\93\BC\EE\C5Yy\C9&Lf%q\9C\CFd\BA\FE
q\88\93\ED\9D\D2\D5\D5\C4\CFI2
bК\90w\D7/\EF<n.Al"~\83"\BFol\00\9A\F0\96"\CE\EA
\B63{%\92BX\F16\C4
c+\EC
\A4І2J5\CA\F3\F4
\B3Jׯ\BB'$_\BC5,ù^y\E5!C\98Dj\C6	\E5\FE\B0#\ED\8F\DC?\99	\E3ȵ\A4\BC\E9\C8!9\FB\84!\D9֋d
\EE\8D \A7\C2F\C0\FCͨ\C5Y9i\EA\E0ˌc\92\ED \E9\F6m\90$#\8Da\D0ޔ\84\CF*\AD\B8\86V\\C7\DDOr\D1Ma\F9\F9\E3\864\B7v\C8!\DB:\F0\C8\E0\CAK\9F_駈\EE\DF\DE\D1#\D1x\8B\B3eX>tb\9Fw\AA\95P
\CC\F1\97\D6W*\00\A7\C4Yl\8E!\87@ML\87\CF \AC\F8A	M>/\A8\A9fm\A8s/\BD)\8C\AB\A8ԱbN\F4\FC\BDVU\9Eg\F7"[\EF!\B9\E6waG%\E1xԐ\8D똝\C7 \9D=/	\F9]\E9ά\97\A3i\92sON\DEpԨ4\E9R\E6\A5쫒&Z\F9\8E\00lm7\F1l\A9\E2,	.\B8\C3}\BF\91\EAdz\8E\90l\B4\D2\00\A3=\EAx\A8cŊxS\AA\B25\89\B8\DB
\88^qgX\BE~{Xv\E1`Rd\E5")\CC\CC\CEkii\91l\859V"\00\BA\D2\8Dv\85\88D\FBw\FEyZ>r\FANY\B3
\A9\C1\F5\FCB\EB\EDK\C0\BD\C2\E1D\99F-\CB>`\C0S\99\84\DB\F0 \B8
̓/\EB\D6>\A0\8E\B3\E3M\A9$\C0ZҲ\FFc\E8\F9\FDUyv\A0*\C6Ȫ<\8B\82t@\B5UH\EEJc\B3\F4\A3Eo\C0\D9Q\A0\E7\i_\00\8EXǺ\BB!\CEZ_\86p\F0%݆Y$\A5L\82<\AE\C7\C0\C6T\D0-\98\F1C\A2\00ҽO\85\E4\94޾\F1\E0\BC\\9A\9F\BFz\F5j\A9\C7d\9D\9B\83\A0ՇuOB\8ES\90\F2T\92ZV\F6]\BE%\00\83
r\AB\A6eH1\ED\F8>\95[\90\85Z\90nZ\AB\92\8E\EB\AA,\99:V\DCr\B8҇\8B.ݻX\BF\9F>\92\F7]\91a#\D7\CF\DBq\E4\FE\AD\AD\AD*Hg\BE0q\A1\B9\FB5>G˿D\8D\DDs\D5Q\99J\9E\E7F\C3œ\8E\F8\8E:V\97#-\BE&\00\9E\C24\B3\A8\E1\BDèL\B4n\C3\C3`謯\B0\E2\E8\C9S\D8\CC\D5>V\ACox\E4\CFG|\BDY\8Ekqv\9EU\9Dg9G&#\FE\A8\94K\00\B8\FE\FA\DBa!?O\9D"A\C0\F9r.\D6	13R\A2\F9\9A\00p\C8\C9(Φ\B1\F0n\FA\B7\AD\83/Uڱ+Fh1\BE\AC\8B\FA\84\DC\C3%{S\\DC\FA<ތUx\976r|\E6\E5\B7T\B7\F4StȺR\F3n\DC\F9,\AE	\D1u\F5)$\D5	G\EBp\84\8B\DE\C8P|O\00"X8\AA^\B7lG\91\D2ݪI\BAm\A3\B2\A0\8Cl\D1m\E5\EBt\82U\C9\DE\8FfG\E4gN>\B9?\A5\80\FC\F4\DC\FDpN\FDh=\DD阴\9E\8Fc\CE\E5i\\FC\E4K\96\96\9D\D3\\FE\868$يk.\ABĘ\D3\D7\D6\CA\FD\BE'\00\A4:%\FAl\AA\\F1o\A5U\D1a\C5\E3F\DAqh
\F6\81\EE\C3%_c%ר8HW(k\CC\C1\9B\E2\E8J\D9\E8\BA('\DD~\CB\E5\E6ϏUs\86\FD:\9D\80\D6\F3yf\E1s\B8\C8\F9\E9\B4\F2
\967\9F!a\A0\F7\E9I\8]ĵI=\87\DA\E1\8EGQ
x*\FALM\00]\D3\EBXw\ED6\9C\EE\930J\931\AC8\DDy\A8dU\DA1\A2kq\F9y\A4\98\9F\82\83TQNd\E7\D1\F2\BF\F9\F73\C6\F3\94\F8V\BA\9F]\C0{yQ\B7'7߁\8BG\96\9B\A6^{M\F7\FB\85<l\82\CD0T\96\BBbVg\E3\00\00 \00IDAT \B18\EF\A28\CBH7\BB\FB\A0\9C\A1\A8\B0b\A4\8F=\85jD\B7Ih\FCqx\D4\D2 (g\EE\AA!\A2\9CA:x\96*\89\A8_\DA\CB\ED\B7\DCx\98\AD\97\D1\C59h\F5/R\E9gQZ\8C߃o\EF\C5\F5.\FCJ-'\A7\A5\85>\F4\F1 \AC?\94\8BrV\82\BAi5C\00\B8\E5V\B1\EB\B0℄\F6\FD\F5	o#\D9!\92q\84\84;\FB\8C\DE?\D4$\C7o[\E4\F6[\98)\EB\B2\F5z\DBfeS7dp\AD\FB\DB\81\E6\D84\E4=`qmr\EFB⾝~\F5=\EC'\838Ɯ\9C\8D>\EF\C8}D>\95\FB(\B6\AD\83VS[\99\B5)\D2VB
\98_[m@\DAq\FF\EF$\82\D4\E3\EC\DC\83\8Akz\B40>\A0ZM9\F8,\B7\8Bsj\F1\9F߳*O"\D6_\DE/W\BF\EDiy\D1:\C8\EF\E4\FCK
uK\AFuv\8A\F8\8F\E1\BA׀u\93kC\A30R\B0\EE_\C4o?!8#\F7\EEZ\94	\00Y6\80\FCu\AF\D6)\B9\8Bq\9AQ\FBV?\C0\B4㚰\A8\E0 ˛R
:\90C>~Ww\97\B4\E5\E5TUy\C0Z\8F\DF<$:v@^\B6ɪ\CAc\87\FB\C1\E6\BB\83yk\A0P\D1\C4\CF߀\DA \96c ^wፐ.6\AEP\E4\A7\E6Z\CD\00O\82\83,\9BrB\B0Ҏ30\A6;\B6@Ŏ\F9\DFm\D8\C1\98\8A*+F\E3y,\99?\8B\8F\87t\A6\C0M限s\8E\EE\97\D76!\E1\FC\AA<\AD\F7_N\D43\C5q\EA\E5\CF\E0b4_%\E91\A5\81(\C8\FF[0\9E\D3@\BE
\82p\A9q\A52=\D6L\AB9@\C8\F2\80L/\82\83l\AF\9A\B6\CCHx߃\9EF\DAq܆-\EBٚm\BFέ\94C;\8A\D7ޔ\A5\E3e\88O\CF*X\FF\9B%_nOSB\DE\F9\F2y\D7Q#\D2Ū<D&\BA\E8\88\F0$\CBU\FA\D1z>\83u\88\F8tё{\CD\F1\9F\E35\8F\81\EF\C08>\81\CF7@-\B8\92\C9\DFV\BE߷j\82\AFd\E0 u\DC<V\ACڍ\84\00\9CE\DAq\FF݈!\B8G\B2\A9q\CB>P
9\DB<hl\AA\907\85á\AE\CFj\BC\ED]p\FBAtz\E3\A1\FD\F2\ED\B7\FDI>v\FC>\E9j\B6JriNO\981\E47Wj\EEN\ED\80V}Z\F7i\E5g\F3\CB\EE\E5\F8͠\B1\831\A6\AF\A3\٭ \AF\B3\B1U\BF\C5hT(0SP+VR\EE=\A4\ED(@\99\90l\FB\C1\90\9CK\89˽\B7\B8\D3aE;J\B9\A9\D6vG\93Ʌ\A4\B3g\8D\BCbӔ|\F8ؽ\F2ʭ`\8CZ\8C\CF\EFd\B9\A0\A9\E73\88\87\C1<8\E6[-v1\E3\A0\DD\C1\B9}߂}\E0U\90f\8E\85Zp\A4\94\8B\A1\D0D\E9\CBVq\DCP\8Ep~o-eY@\A1>;\E8\B7|old\8A\BC\A8@\93\EBF[\FD[u[)\873Oըr6\00\E7\89*^\D2{\A4\85\94K\E7	D\BF\ED\8F1N4\C9_1	\98\E0rʕ\E0\C1\F8{F\FD\E9\C0\86\E42|\97\EE=6ߑ\D3\B0ք*\A3\8B\AFļ\BFl|S\FD\EE\ABV\CE\FA\9747	\00\F7Q<F~\8Bu'`\88<\9A\BA\87\D0\F2䣘\CF*1Kp/C\84\CB NE	\00\A1E\F8BZ9\FD\B4[\F73|\97\88OC	F-!\FER\ACX\98\FF\E3\F8ӗf\FC]\D8\CA,uS\EA-\FBP-\83V\ED-\8A\B3\A7b6\E0\CF8|"\C8\E4\9C{g\C4͢f)c|\D2\F49\9EH\EBǅ^D\91\BE
\A59\C6\E0\FFm\E9\D56\F2\B9\B1Vz\FE\86\8E\8Dz$\9C[Mx\92]\BB\D1GM\00@Ǻ{\BE\91K\846\89Σ\90\91Y\82
\91P!\F0	ԙ.\\CD\E0 R\88b?\F3\F1\89\F8\C2E\FEXj\F8n\89\EB\E4\F9c$f&A;\D7-\90\84\BF\89\EC\AB\DB|\B2\CBEl\BFO\84\FB\9C将 
\F4a\83'|I\D0\E8M\A9
\F1\D4n=\8A\FB\DBq\FDw+|\B7\BC-\E5\DDӦ\B7\A0	\EE\BF;A.\C8}\V{\F7\C2\C2=\FBol\C1E¬\D6F\B65B\F3&\AD\AA\CC@\D4\ED\9Bc(#\B9\D3L\AB\A8\C308\88\A7W\94P=B\89~\E5ϧf\CCc\00\B4\8D@s\CAz\FE$\A0\94\93\95\F0\F3\DF\F1\FB\ED\B9\F7\CA\DBso\AB\BC\A3f݀K\F1N\9F\92\EBv\E5 \F8m\FBVe\E4ƍC%\98v\C2PHq\DC`\CAq\85\83\83\BA\F0\EE\92\CEa(u\ACx\E7\FF\E1\D7\DF\DD\DFO\99\8A\A5N\A9\A4\E7HuM\F7\E7\8Bd=\EC\C9\E18|\A4\A4\BEJ|\A8n\80\F2\AArP\89\F0-\F8\98r\87\83\C3>0$\EC\86박\A7YV\B8\00I\D9\E70\94\00\9Cp\C0gQ\9D\A7a"\F4w
\ED\00lEJ\B8[\8Fp\9E,Eہk+\D6|=̠\A1\CA\D7\AA\C0u\A1\E0\97\E0 '\FB\84l\F6\81H\00-\90?@\979\B6FE$\82J6\F4\92\F0!x*\D1Z\B8I\B8\86uML\87\BCh88{\F0O\ADBe4\F5TB'\FBƍ{\EB\8A\00\D0pL\B7`\A5c\DD\DDX}\F6t\8BA\DA?\80$V P\E3\C6[V\EE\83\E70\B0rP\B9\C1A\B6FI\D1\C7*\F3E\84\AD6\81a\83\8D\A8\00\B4Ā%\C4+\8F\B6F_\FAM̊\8A\83\AC\F7\E0b\95\A9.\F0|m\FE\AB8\EA\9BӨ#`\FE\8ApW2ֽ\F4ݰ\FC\93\8A@\A7\DBH\91\\83\CD\C2 \8F\D5-TdC\F9\97\B0\DAҘ\E3s\F0܋\84\9F]\98;2\88='|n\AF߲\FDqL_\8D\8B\F5;\90\F2\94\8F\FC\C4\F2/\A9\C8zWr~\9C\90_\83\83\9C\C0\81A2%F\AA\\E3\95x\92W\A8\A0'\BD8\BBW\A7Z{ʌ\B8@L\F8Y\A6\A9\A09\FC\98\85J\F08\CAv?\80\AA>\FBh-\F7X\FAq%w\9B,\8B\83GR
\F1W\81\EC\F1<\AAn\FC^5\C7\DF\E2\F1ו
\A0\A7\A6\83\83*"\CE:\D8NoU\FB\9E\9B\881\F2/\B5\88\C0S\F8\B1\BE\F7\80|ko\8A'Ǌ\E9\90\DF"⽲p\9A\F31\E8\C18Wk\AD\D8\B4\9E\DF\8EσFZ\ACj\92\FC\9E\FF&\F0I\ABK@ت\CAA~<%\B7\94\85\D7\\8D\B5y\98\CB\C3-tv\9C\8B2ߛ\E2b\B7欉\F8Tgl6e\00\D2\ECA\B5\9F} \9B@6\FB\DD>@$\8F񻕅?J\C6H\B3\F9i\F8\F3TĲ	\\EB6x\88\B3xu\B7_
a\BA:?"\D1V\\C7\E1\E2QV,\A0\E1\B2Z\C0s\\E2\A6_\9A\EBo8\B4\B0\82\D03 x\F7A-@H\B5\9FpȜ\85v\EB\ADB=\AAk\9DjeL\E4'!\A3\C8\EF3\E4\E7\B0\EB\96\00prg\AB\EBns\93۾M'\97\90\93\A2&\A1"뭧]"D8\D7\AE\E8J?\B6'\BA\F8Fe\C0/\89lx6\82Q\B3Ou\9B\F7ە\9E\9F\A2\87!\F0\9Bi_\F9\C8\CF\C2>\E2\FChu\ABp\82\9E\8A\B3\D5\DDv\E6f\E2œm\8F\C2\C5pZ\86\D6\D2>\E0io\B6M\B1ڑ[W4\F7/	\B4\BBt\BC\8C!\E8!\DC\D7!\ED>E0\8D\F8͐\BFVᢞ\CF .=?S"@\80.}\CE`\B5\F7\CC2\EF\AFk\C0\F92ֽ\83\83l\EF\CD\F5{\F1uLVϡ}\80Ur\CBH\ACQ!\C2nT2u\E2y\BF\BF\EDy\B9\91\E3cq\D1]\96}`3\88\C0&\9E%\E99!\E0\9C\A2*\90'\A7\AA\86ԙ\EF\AD\E4w\81O\B8\B5\9C\DE\F5\A3cݽ{\83Oz&! 9?݆<\BF\86\FF.\E3\80SWR\AD\B5\DBo\89\A8\CEX\87\c#\D4\D9%Օ9\F4\F3$T\82\FB?\D0?k\86x\A2h=\BF\E2\FEf\BC\A3[q\FD#\DFk\FA\FC\9Ds~\9A\AB\A0\92׵
@\A3&\83\83*u\ACXUɁ\B6P\DC>ױ\B8x\DC5\BF/\D1>@)\A0\E4M\A2\B9\FF2\EE\BBU P\ED[n>\83r\9A&P	\99\E3\A1qɎ\A7\̲\\D0\F3i\E0\CBB\AC\8F(=\E9\B85\F23\C7Ϯ\D8O\D8p\B9\9F/)^\F7*\007\96k\E2l9\BB\B4\92\CFjq\94Vg\9Ft
}\97\C5\CD\E6\C0p\A6\83\83\C6aps\F0\989[R\8E\E5\DC~\E0ث9`\C7o\E0\E6\BBAO\E5C\AC\EE\E4\F8%\80\B5\8D!dY\8E&%\B7\A1Y2[[$\D4D\EEZ\8A\EDA?Ӥ\C4\FD,\E2\F7\EB\F9\F9k\AA\91\9F\AA\CF5(\F6>\C2\C6,zʄ\E8\8B\F1\86\EB\8CϨ\93+\DA\82\00\A2\F5\E4hw\90C\A1薢\8A\FCe.\E6\E2; \94\A6\81\B4\8ER\AD\B5\DBo\A5\E0\F4q:\F4\8DRPT\F4\B9;\91Áڹ\94B\F4\94є}\00U\9E\9FF\A9\F69\C9n\C1)\E4 <B\F6	\81\D6\F3\BBT$_\FF-\D6\F3\97"?\E7I\E4\E7iƅ\90\9Fp\E7\BD)\CD\CA\E5\F8\EDkƧ\94	\B7*\ADa\00\A1[W\C1Av\B7\8BV\B0\B5Ii$d0\DDh6\E4\FB\FCc\C5\EC\BEVmrr\FFB\C8`\FD\E8@\98\ECK\DF\00/Ƴ\B7#\82A
XF\F9oE\DF\F0#\91\91\D0'$ן\90ܶV\C9!\EDX\E7-?\AD\E7w:=
\EDMr\B4\D2<LB\B1\80\FC\85\D4\C2$\8D\F2i\F9>~\BB\88ϓ\AA\DA\8A\00\E8ࠒ\C4٪.\93/\D7j\C5\D3\E3b\EC\00
9\F9VK\C1\9708h#\89~\8AJ\E9Z\F7\B7\E3\9Aӈi`ͩ\B0\AB\C1\80ɓ\98w\DE
\A9}R(G-\B0\81\97\A1\F1\D8\D6 i\C7FGt\894\C0qP>h\B5\D2t[Z\96\F8	+u~\DA]VB~
\87\8C܅\BB.4>)?waE]颡\00!\E6i\AC\BB+K\E2q'\E1\A8\D0>\C0b\9C\CF\E1\82\BD\90Z\A0\83\83\86\EC\9C\C3@\D4)\C6\FDM\843\F5e\C62\91\80@\88\D0[\A0\ACy9\CE\FC\BC\C3ʤ`Pg\A5<+\C3N\DB`\81}`S\8Bd\E1:4\C0\CC,q\C5\F1Y\9A\9C\DF,\B6\EC/׭F~\8A\FD+\CDU\EB\F9iy
\A4\E5R\\D7\9FVZߴ\86#\00bl\C0H)F-\DF,\9B\D1a\C5[\D0\83U\9Eǵ\CDP+\D8X9\88	VE\83\83
\FD,\D6L\C4י\81\FA{K-\C09\8B\F2\C2\C2>\F0\E7P~\82Z(\8A\93Ŕ\A1\B0\9CFB\00[\86\81\B0b\C4 \BB\ADMr\EB\D7I\C6\E8Vz\BE\89\F8\C5xZ\C2\D1ȿ\94\F3k=?
\F9*\8DR_9\F9O\88\FB<\CD\D0w\ADLp\FAn>\B6\A4\B5%\CE\DA\EA\B1Fo\D2\F6\EA\B0@5]\86\B4\D0k\B0\8C}@\A7Z\AFx\AC\98F\AB\D8\C7~P\D1\FA2]d\E4\FC\85\82v\AC\81\AE\8A\89؆A\9C	\B8\E3f*\9F\F6J4\D3)	=\85\B8\81Ui\A2}ߎ;\92s \C7'\F2[Rˢy\9A\B1)\?\E2_įh\8D?\A7;\B1!	\80g\ABpJ\AE\D3ũ\D8\FD\9A\EB\F1d\A6o\C0\95$W\9E\E8\9D\EFMY4>-ғ\A3\F3\FE|.\CAߩ\F3\F0\BEC{\8AqZ\BE\80^<\DB{1\B6ݷ\99\F6\81\8ES\D2@j\81N;\B6\C5\F59\8E\97\F3\A3ο\94\C8icj\A7\E4\E4"\F9\A4\DCT\C6\D0*\B6\F4
I\00]ƺO\E2J\B8\EB^\B1%\F3\F0E!\F3ӎ\99_@\AD5O-\A07ef\B9TkJ\F9n\BF\E5\F4|\8DHN\A6\C1~@\A2  \DB\DE\8D\E5H7@P\B9\CCi\C2\E5[C\A1t@9?\EDVZ\CF\CF\C2\C1\9A\95/\83\F3\D3\F8\E9\F9\85\E6װ@
\F8\E6\946[۰27\E5\DBHv\E0b\90\8Db\BB>Vl,?\947\BF\D2O\BE\9EOq9\A9\A0\94\99p\X\AFVH(G|\8E\8C\E3-\FB\00Qg1z\B5\9B\F9^\AA,D~M\E0\F4\FCI\A8K׀ \q\9F\90\AA\A9\E6\C8j\A6H\CB \97Z\D7*
T\ADy\B57\AF\C05\C7\FC\9Ec0\95o,\D4ܟ\C8BIQ\9F"\BF\D6\F3\ED\88\FBv'h\A5w\BF\89\90/0%\817A*Al\D5;\AA\BC\DDW)N\CFyP\EC\D7\C8o\BA\F52\F8\EF&|~\88Em\B6\86&\00\\B2n@@W
\88\C02\9BX\82%i\C7\D1QxS\80\DC
\E6C~	@r|^N\F4\FCRp\C7R\C8\F57 ~\80n\C3\E7~"\FD\CF\DF*QH(\ABR\F8{\D94'\F9\89\F4\9C?\B3\F20\AE\8B@\00~\84\F0]W\E9M)\A0(\E7q`\E5t\EF\FFg\B58\EB\FF\91Vy\84z\9B\D3S\C0$#$u\80(Ę\D5G\AB8\B9$݉\F4\A5\AF\FE\EB\C5,BC*\F4\A1gɃ\D19
ف߃\81/C\97o\C9m)\E77Ye\90\FE\B3\F9O\D7g\EC~M#\BF\A6\DD%è^\AC\CB\CAA^-\F5~r\C1\CF\DF"\F02\FCN\AF\8B\A8\D8\F1\A3{16\D3>:\F9\F7\F2\F0ܐ\BC\B5΀\BF\FFn\861;\AE
\C59P\8A\A1\CE\CF91{"#Wbn' \8A\EFb\F9 \FF\D4Gkx\80\CB9\DC̔\C9\F1\C1\F9\A3\E4\F8D\BEj!\FEҡ?$\B17\81\C9Ϳ8R\EEH\A7\E5\FD\A0\E7\C79\90\C9LEY6\E7Au\87\C8\CFY\A5\E5g\96\9E\CF0޺k
\AF\E8ep6I\F9zc\DDm\91%"\82\D0"NC\A5^e+\DB\DE\00\ED\F4\87e\FA\D5\DB\E5\EB\E2I\FA\BAÜ\E4\AF\A8p$hf\8D\C5\ED\A0\EF\EF?\E2~]"?'H\00\D6\DEs\EB\EE\CD~\F5\AFD\EE\8A\C7K\83}|<\FA\D7nWN\CC\F3\F6"\F9>\C1\FA\94\FA	\BA\A8\99\F1\C3 j\97\F9\BF\82\B8\FD\AA\A5\E9V
\9C\81\90iƺ7D\E5\A0rvW~$_9\FDT\E1\D9\D7l\97\FB\80\F3o\C5\F5vx	\A2\98\FF\E3B\9C?\E4\BF_\9C=\FF\9F\F9	`\C9&,\EB^\85M\EB\9BW\92[2\FC\95\BA\BFOE~;\B0`\C1u\90~o\C1GZ\E2r\FE\\\9Ek^#\FFl\FC=\F4\FDk\81
\B0d\C1-\83\F9i\B3\93\E3_HB\80\A2\F2\85\87O\95vI\DF\E1_S\FFn\B8\80e\96\U\82娆\9D\BB\99\80`D`\B1rW"\BD\F9\AB\EAW\E5\A9\C8DWxI`X0<^\BC
\9C. \00p\B8K\B4ᯚ\BB5x\B7\EB\C0
 킛\CBq\00\89\EB\CB\E3\835\F7\A7PD,\88\BBC\C0
\F0T\C1AP~\CFS\E7\A7\EE\DF\F0\80p\F1\FC\D2[@\00
\ACK\875tp\90\8E\87\A7\F5?hu	\81\80\00XVONɭ\A5m\A4\D3zki\CC\C1XA  \00E\C0Ec \8D\82
's\C25\F4\E3\F8\E6\80\00Y|Vb̀r2Kkn\D5I\D0O\CD\C1\BD
\80
\A07[\C1A
#\E8\C2\C1;j\FB\96`\89m\AC\F1\81R@C\00\8BT\8E>\EA0\E8\C7\C6R7\DC-
\B1\A7\DDXU}\ACX\DDK\F7wc\BB\D4Lp\B0Tu\A4s\FD\8B\EB\E5\00f\C1\AD\FE\86@@\00\ACO\DD1臖\FF\A05\E0p\A9\EB68H\FD\985\F0\82\D6 \80Å\AE\DB\E0 \E6\852\D7?h
\81\80\00\94\B0\DC\ED@\96\BA
\D2Up\F3\8F\BC*.\C1#\B5\81\80\00\94\B0f4\94\B3f@]\E9\A0\FA\AC{G	\8B]\E7\8F\A0\C4֕\83\EAg\98\EBO`\D0\D5!\00!0\CF\EA\BCٵ\D6R\00C\85k\B6\D5K\A5\AE\81\99\B1X'\CB*\B7\A3*\8F\869ye\97\CFC\D9\E5]j\B9j\81T\E5\A0ZNҕ~*\BF\DC\DB\E1\B4[p\FC3r~\FE;.\FD\9AMT
\FDr\91\AD\E3\F9\B8>\00BЦ\98\A8\C1\C6C(\F7\E2\84̌\BA@\C7\D8\F4+\99\D6m\80\90\DB\F0\D1n?\9C\A9W\93\8D̃WJ\9E\82\ED\E2\8B8\A5\F4\BB\C6+%Q\93s\A9⠫F\00\F4\9CA\FER\C0\F8\F7\EB\954P\F4\EC\A6*Bk\85W\8F\82猤\DCf<#\00D~"\8F\BC\A6\E8\EC\F1\F2l\95\B4\B8\9FT\E7\F3}\84\F1\CB\C6Ѳ׳\F7\D5y\C7U\FE\8Co\C8o\E37a\9E	\E4Dm̪\8F\CA٪\D7dp\AD\FE\B5\86\FC\F7
\EC\929\F9!~\9En%\FF \BF\B3\BD\BA\F4\EE\AAK\00\F9\CA}\E7\B3\E4\E4\|\F7q\82^?\9F;\B7\90\90\86\\96<\93\004\F7\AF\BF?\83\94\B8S\D3\F2{쏋eZ\AE7^U\8B\B2by\C8\EA\C5Ӿ"\00\F3j\C1G\E5\FC\FEY\\EF\844\D0\EC\BA\FE\EB$)E\D3\90\80
\E3P=!\00h7\AEZ(\F4II\90Rʜ\EC\E2_\86\EBj\E3\E52\EE\C1\F25l\97n\EDUO\00\FB\C0\89\C0\A6\C4u\9Az\81\CF\ED\D3\DF\00\88\80[\CDu\A0\83~\A8\FB\FBY\CDZ\D0\F3\A7\81\F4Wa\B4\97/\93n\C15\E8g~\DE\FB\C0\9D@\FA7`\9C\83\EBI\BF\DBZ\00M\F9ڦ\C6l??\FD\90\E3sW\CE\C9\CD\00\E4\EB\80\F8 \BFw$\CB\D7@\FE\B4s\82\CD:$i\E0\C3\D8\C0\AB\FDj\A0
\D0)\C0
"\E0\AA\A0\83~x\B6W\9Dz>	S\86`\EA\F99\F9!\C4}XU\82\E6%\FC\B8
\CE\84\E0l\94O㦷\83 4\F9\D1>@c \8D\82\E5\D7U\C0\C1\AC\C6\E5\B7R_\E4\F64F\CEI~~\88\C4\CBM\F4\BD\00\81r\F7h\D5`	\FB\C0k\81a\9F\C1u\A2\84\8F\EC)\8CeoFkp\DDr\00\ECЕ~H\00\FC\D2"~R\EF|ץ\F5\9F\F4\CB\F0e\BE\B6Z\D8n\F7\BD\E56|\CEOa\C5Q@\95\B1\BEi\8B\9F\F7$\E2\9B\E2\FEm\F8\F9\97@\FC\8F\C8_\9D\DDR\83\AAΈ\97yk\EEò	\EA\C0\DF\E1O\E7\E0\B3SIn(\E1e̐ܟ\B6\80dR\80+\80\CE\F5\EF\A9>L\D2S\D7O\CA\95\9E\9F\91\FF1\8E\91\D92\C0<Z&\EA\82\00h@-8Z\A9\8C,y?\EF\D8\E5\B9B\00\FC\F4\A3\DDz)\D9\E2\FC5\80\F1rp\FC\87\E0n\F7\005\AB,\A8\F7ː\BC
\DC\E5\AD\D8h\F7+wRg\A8*a\F3WM\D1\C7{U+\E2O#\BE\9E\9F\92\EFbMN\E2\FFK\80\FC`r\89]֕\90\83\DC\A1
D\A0P
BP\AA\A4L#\8Bo\00\C1RZY\80\FAYk\89ݕ\A6B\DA\92\95_\83\FE\90\FE\A5\C0 x\C6[T\91?z;1\E3*\87D\F0%r\_\C7\DBf\AA\00\A3*U\A3f\00I{5\F7\D4n\BDa\BC\FFa\B9\B0m\80\FC\DE\EE\F5rz\AF[\A0\81b\)\CFW \B9(\B7aV~\AA\FCr\B4Ы\CAA\C1+
hr{\96\F7\AEd\9D?N\94\BE\?\C7EM\FF\EB\F2|\FA\FC&h>\85@E\F7e5a\00i\80\A2\E8\9Bq\BD\84\E0\95t\AA\CAA\95\AEt\A5T\AAX)\A4\B9CyZ\95\A7?h>\86\00iv\C34j\E3\DF˝\86T`\C8_\83k\AD\A9DX1\AB\CF\C0\C0zU\9E^\C8\FD\ED׌\CBk\BD\9F\84\86\93\D9iq\FD\ED\F8d\E5"\EE*\FE-\EB\EDTf\E3z8ц\91\00\F2ah|K\86A\FE6\EB\89\C0\C8\FF\C2\DFR^\AB\A2W\C0󦹿\97TFG\F1\B1&Ϗq\91\EB\FF\C1\9A\D9\E29z9
\CFA\D9/hH\A0\D6\F8\A6<\99\E0l\FC\FB\F5 wz\ED6\EC\00r\F0|A\CF\B3\F9\A5\FE\EF\C5K\C2wE\95\E0\FC*.\C6\F21\98W\EDX\8C5
\BD\BFj\81\804\FCWKF\C2_a^\91\F5C\B8\9E\F2\CA>uz)\B0o\86\FCz\81\FCz܏\A2\FF+p\FD׾\9E\C6\D64\F2\9E\00\CC\EF\D4+ej\C1\B7\A0\B5\9E\00i\E0" Ѩ\84\A0\84c\C5\EC\ADQ~Џ\9B;Z\BB\F5\F6\A0S\A6\EC|\D73\B8tU\DE\C2\EF
T\007\D7\BE\ECm.^\EC\D7.!
\F4\83\\00p*\C10ά\9B\F6\9CA\AD8\E9\A0\EE\E9\F7\B7\A2\F8\E6\C6%7\F6\F9\F7\EF\B7\FA\B7?\FE\E2cw\00\88\E0V\F7!\80`\8A\F8\81\87\90\A6\F2n ԛ@~\E7f5"O\82\83\DC:\DE\CB\D2\F3\B3pW\EC\FD\A5\C8\EF\FFM\B2{\842\9C\F4\E6\9BUy\9D4gw;\E99\B8\D7ا宼\AE\B6:1\BE\A3\BC\DB7"\DB\F0v\81\B3\F0\FBy0vm-\D7mH\AC\E82%ܨD\8E߄ˍB\DC
\98\F1(\F4\FCg"2\B7^n\BD\D5\D6QnN\A5\A7\F7\D7\D6\F6\A8\8B\D1\C0\C62B\98\C2m_\C9}T~\B7\E1\DF\E3\F7s \B4\97S\8DHM\00\C1\CAb\93|\98~)˕\8Ap|:\FD\F4.\917"\8D'5d`\D9aw\F0*\A9\E5\00\9D\B8\8AF\9A\8F!P\D6\DE\F3\F1\BC<Ҏ_\81\98i\C74\86\95xlWҪ\94]q\ADd \C1\D1`˿\A3\DCJ?\96\B8\9F\D9
q'Bx\88\E1WHo\EDy\96\D9\D2"\E3/\ECPg6o9\DCE\E9\EE\F92+3\FC~~.\D7 \FD\B78\F4*~G@\00J9\B2
\A3PޢAX\8ET\C8QBY2)ƣŖ[\88\A2\80\B1ķS\BF\BF\B7\9FKJn\F0>1\9E\BBAd\FCY\8C\92\00\AF\FCf\9B\00p\FE!\D8
\BA\F276]\EA\BE++\DB\9F/Ш\8A \AC\A0\D0g\89{΋\C7P&T\A1tcs8\93\91\C2Q\A8\89\00\DD[\00]\BA	@\A9\95~\ACD\A8\B1'\94\B8?;\F806#]\E0\FAM\CB1x\9B`q\FF\A3(:\CA2\AD]\80Gl\91\B4\A0sD~\F8\FC\A8T<.h>\80@@\00\Z\84'F~\D9{@\F6\D4X'\E0\9ER?	`\DF2Ǌ\ADH\00\88\A9\D3\C9\FD\ED\EA\E8\E4\EC\B8w\FE\FC?\85\85\FF.\F8`\D9\E2\CF\86L\A0\CB\E3\94xW>!(H\00\A8\E77!\EDg\B8z߀)\B24\E12\81{\BE\8D\EB2\A8\CC"Z!\B8]\FEܬd\C6\F6\84ehGDXm\92\D7\82\83\CC\;\B9v\96?\BCyx\EC1\B9\E5\FE%\B9\F3V\98\90\C2\F3@~*<-\A0\88?\8Ck\8Fd\9Dz~X\C6d\AD\F4\A3\D4Jȿ\CFF~\B6\92b\C3\F2	\w\C1\96r.ʼ\86B\97\F6`)\DD\A0\A8-\F3t\E7\90IS\86\EC\DB\96\91]aI%\F0\85Θ+\F0d\8B^8	\FA1\FD\F69\F0\E7\9F\00IO\FB\CD\F9r\E9\EC\FE&\E2\AB\C6\EEx\E1\9F-\B8\D6\F0\EB\N\F11cݲ0,S4\98\86\9C\B0G6#\8B\A2\B8\B2kN\BD\C5^\E3}$\86l\C1\B3_!\B8	\84\E0${w\B9
\81\80\00\B8Q \8DB"\99	\C9\E0\B3a\EF	\83j\8AUi\B5[9\88\E8X\ECx/\AA\E4\EB)y\A2\F6;\C7\F76\E3@y8\DA.a\A8'\CB\D2\8B(Z\849\ACƿY\AD\E4*GO2Ҭ8\FE\D0~5\A4\8F\B5*F\D2.\E2/\853U^!9#\BA\B6\94o!\DE\E2`\97\96#\E8\C6&`P\C5n\B3\F0~\FE6Zӳ) ,\83\CFDdz_\98\96\F2[\D1\CAA|\BEP\A5\F6Ϳgd7\9Cp\E7#f\E14\94\E3\BA\CEx\A5*C@Q!\C3"\CC[Z\85G:\F09\95\87e\BD\D1\AE\DFA\E6\D1T2\E2/\9D\BD\E9Bm)\F9 \AE;qD\FC\B9\A7D\ED(7Ŗ$\F8\BB
\C0\90l޲\BF\F9\D8C\89 	U`dwX\9E\FCSHF\E0sWh\B8*28\88\92\C0\8AL\95\CF蠟\FCAi=?\AE=\87\\BD\AC\9CĿ\D48\96\F9\9B5\868,\83k\93\A1-O\8E\C7;\E7\B2ӌW\94\8C\94\F0Ҭd\A02\B5\8D<>/5gZB\C1#%@\C0\AE
\B9\84\AE\EB\91B\920\CD\EB\D30\A7\EF\CA\CAn\94\CAZ\8FJ\BD[6\80\ED\E9\F0ݼ\87U\E5 \90\92\FD\82\83x\EFg\D8o\FE\CB\C8+\C9E\93p\B1\89|\88\E7J\90\C7c\A6\9Absi\F4k2s\E9\F8\8Eg3\F1\C1\A1Xb\DB\E6\C8\C4\FAU\A9X\C8\C84;uy\EE\F7Z\8B\E6221\B9/<=5\EAJ\A7\A4\92J\AB6\DAF\9D\DE\00\97\9C~Eix.+!w\ED\DC\E5\84`\F3z\C9m\84\FD<NZO\C7 \B4c\FB\8F)\A1\DDj\EC \FFx/\FDo\F3\94\9D\C7\F1\ECE\F8\FB\8D#\C1\FF\B4\EEX\A8;\99ͅ F\96\E1\CF\DE\EC\8E{f\\00\00\A5IDAT-#@br\AE\E9\F1'±==љ\83@V\B7\A7@\B2ђ\D43tyvf4461j\F7? \82+2\A4l\A5Z\EC\CD'\B8kpi3,\B5\E8n\A9\8C#\E6w:\BDP /\84\CD\CFD\A0'\9E\95\\B6{O/\00Sy\95	\DEL\E6y\F3!sDV\F8%\F7g#\D7O\C1@\97\91\AF\E0\FEo\A0\F2.\AD\F6E[{\D4\E8j\8F\84Cc\A9\8C\EC\9B\CB	\88\81mi@uN\95&\97	\8De\DA
\A7X\9F=pC:\D1֔\A2ОA\D0\E4\FA\A9\E4\AC1>\D1\CE\CDN\AB\AD\C0\A2\B3
n((zy\CF\C2\B0\9F\C0\BD\BC\B2\81\FB[\F8\9DO\BE\B3\9CV?.z\C3iv\C3g`\E5\A0!\D3on\FB0ݗ\9F\E4\F1\C0\AE?(2>\A7\EA\EF\DAnT\F8\CE\EEXX\D9F@\C6@\9C\8DhW-Pt\80\DC;\93\89\F4\ED\9Am\DEMn\DC\D04\B5\B57\8D\86\A1\AC\E44?\9BM\C9\F8\C4`xF\D1.HC-\CAk\E2\E4\E5\B6g\DCh\B0%;\F7\AC\E0	Mfd\A6\FD\EE\FBu\A57\FF4\FEBb@D\EF\86\00.?	\00\84".r\9E\FD+\O\80\FF\8F\C3\D2_bc\9F,Rz@<,\90\BB\87\E722\89\D3L\AB{:\91\8A=\FBL::0M\B856\B9\BE{\DC<۴\88\92`de
\E2\FEܢM餱\F0\E0\81\AC_\E2\BA\F5X@\00܂\A4\A0\BB#^\CFA\C4\B5{<0\A0A\BB=\92\8FC8ͷHo\D0\F0\C7b7\E1z\C0"\F4\E5w\DB\9E\9F\A1\91%\A2\83//n\A7\E2Ɔ\96|}Y%\A9\CCRPw\D8l\A6}\C0\98\99L6o\DF\8A\EF]\9B=xSv\B2\AB\F6\81\\8E֍\B9\B9icl|o8\84\CF\D5@|~ \BEM\F0z}[@\00܂\F0	@\FE\D2`\B7\B6\91Ic\95$϶AȲ\DC6BwUHWK\F4\E9\B0[v\9Dl\EB\CE\C9\DCb\C84\B4kk[;$\81\96pH\C6RY\81D\B0\rR!P\99N642\90h}`$\9C\EE]Ol\ED\CD$\E6\B3ٙ\B1P^\D9 \BE[\9Bͽ~\E0,\F3l\00\C4rԉ<ß\A3\D7XÀ\810\FC\98\F5\E4\E2\D0K\80\B6\D7\EB\D5߽\96\EB\FC\96GSs\E7\AEy\F2n\D9\F2\E0\CD\D2>\D6/\B9pČ_\B6ݕ\AB\E0\86h\87\940\DB\00\8D\97J\9C0\00\95\CEDv\ED̴\CD&\D75\F5\CE\EES{,\D0\F3\ED\ADU\A5\EF
\80{\9Fw]i\88@\F4\E5;A\9E\FD\86bJ\EB+5[]_}͵,^\F2Y\C30ΐ\966\D9s\E4kd\E8\C0\97\CB\E6\87~*\B7\DF.\F1\E4\B4dA\F4\8B8	8\F9\A5\B7	\F6
h\98.\C5>\C0Q\86)\EE;p\EAٚ\94{k\D6\F0=\C0\A5-\90dC1zH\E3\F1f.\D8\FD\D5߹vd\FDO`z\E7D\A3юt:-\E9TJE"\A7\DAz\E4\E9\DE+\87\BCR\B6\DC\BD\F4>\F7\80\84\91\B0\90e\96\90%
\F0\B3\F6\81f\D8&1\C61$\AC\E8$/\E65oM\E7\9A\B9\B3\82V\C0= \ABZ\EA\CE#˸\FD\DC{\8D\EAiE\D9\E0\AA\EF^\DB$?\F7\FC},\DBJ\C4O\F1\F3\9B\91ͨ&\D7"\8F\FD\C5'\A4\EF\99dA\CF\C0\D3\E8\EE|*X\84\80\F7uAh\83\8D`R\CD\BCN\ED\C5\E6\CEw\90\B8nS\99lSK\C4@1\A0\B9\F4\F7\80\00\B8Hlb@\AD\FF^p\C9%C]\F4\8Ao\FF\E0\BBa#\85Ӎ \EEG"\91WR\EAN&y\EA\CA-\94a\E8\FB/8N\C67\BDHz\BBC\B6<|\8B\B4M\C2>\00B`\D5\E3\C4\9B\B0&\82\DBy
\B4\C0\BEQ\AE\8A\C3	@P\82\A7$\8B+\A3~\C7{h.p\A04\B8\B4\80
\DAM@\00\Zx0\CDCl\C7!.W\A0-\92\00`\E4{)"X\A4\F4\AD@\FE\B9\BE\ED=\94NJ6\D6$\BB\8F~\83\EC;\E8\E5\B2\F1\A1[d\D3wH,9\BB\9FZ\86\AEk\86} \82\DB\F6\A7nC\8C\83'\94&\A8Z\00\F9	7\B6 3\CD\F6\AA\B9vc@\00\%\B9\E1064\B9X\B8?c\E6.\BB\E1\B6U]}\E7\C1\C0\F7\E0\FD*\A5\E7;A\FE\FC\B9\A3\FE	\C1\\E7Zy\FA\A4\C8\D0!\AF\90\AD\F7\FDD\D6>\FF\88*`
Xs+$\81f|G\82G$fX1[\A1\B9\EB\BFQ\DCg\CCm\CBA|.mˢ\DD\A0(\88\EC\DD\00\B1x4\B1\D8\CCq\F1\B0\81uB4O<x\DA\DB\CEl\9E\9D<!\8D\BF$Q~\A9\9E_\EA\B4}`|\E3\E1\F2h\EFA\B2\FAO\F7ʶn\94\AE\A1\E7\A1\80\E4\C5Ѓ\88#i\83\8D\80"<Ey\C0\E589\BFcL\D4(\9F\B9\9AP\E6nF\B8&CٖV\E8.\E3\A5N!x\CE\82\B4K\C0*t\EB\DBV厄4\FD2\EC\F146u܎@\CF\C1\FB\C0\D0^\FCv\C8J\A7;\9A\A6\B2"\91\AE\E8\F0\F1\F1\\EA\80}\F1^I\86\9A$\C4
\A2.6\83\FDA\AF\99:\E0@\844\90hj\95\B6\E1\DD\9FC̲\AA\BE0d\DAZa$\A4\A1\90\A3\A04@\D7_K{\BB\B4\A3\F2(\BF\A3\A4\D0?ː\E3\FDcT\B8\B3M\AD\BB\8C\AE\B5\E7\CFy\D2Ͼ{\EFcA\F9p\D7s\A5\AE\E0\90߷VN\83\8D\EC5Pg\D5O\F6Šۂ\96m\00	<\DD\9Bɬ\8B\A7\C2=\A9\96Hh\AE)\86\88\BE\F5\FB\92މ'd&\DE-\93ͽ \8Cv\99\C0c\90\8D\C4el\D3\B2o\CBK%\97IK\DB\C8n\89\A0\AA\A8\964\A3@\E2vHM\90H\A2\AD\A8A\82Aħ\9A\A0\93\8E\F2\A9`\86\FEc\B3\D9\F6\9E+\E4\A0#\CE>\E5\86\EDw\C8\EFҦ\B4\D1M@\00l\00\C9\CE-\EF]+'\E3Oƾg^sM\E0baMJ\CBڷ\8A\00\E0r&\99M\D0<c`4\C5"\B3-!\A4\E3\AA\F1Xf\C0\D6\D9a9p\F8\E9\98\90\F1\96u =֟\DCSD\E5!H\B5u\C9>\8D\F6,\B1\A9Qi\EF7E\97%\A7\89\90\9Bw@5`\00\D1\C0$\8AaK\FD\96\A4\8CaB\C86\B7\DF\EA\DDt\D6)\BF\DC\F9\AD\EF<\BA\8B0Z!\00\97\80
p\C0I\D4m\B9\B7)\E3\93\C8\CA"`L\EC%!X$\EA\AFH\00\F8\87P(\99\EAi\99ʭ\87b-\89\B6p6\B5\BC4\C1N!\AE\F7L>/\DB\F6\DD+\E1\ZF[7K*Ң\BE/\AE[\D8\80\EAc\9B\ED^/\83\BFB\A6\DA\D7H\CB\E8^i\9A\81\C0C\95 O-\E0\C4=}?\DCp1\FA\FAbMO\ED=\DF\FC\E6\8F\FDӫ\BE\FAc\9CJ\B4j@  \00.A]\00ˣ\A5\994C\EBX\EA\83\FA\AC\AA\CFd\88\E9W\EEG\00T8\A1\91N\B77M\A66\C4s\91ι֨\CCō\AC
\AB8\F5\8D̜\AC\D9.\C6\95\B9h\8BLB"\C8Q\F7\D5\DA'0\81@\A2\C1\83\8E\91d\A4IZ\87w!\ACx\D6
"R\99\BE2\95
I"\95\9E\E7\FE\ACy\98\8BĆ\8C\E6\F6\8BÛ\F9\F8I\B7<}\CFU?\BF\CB]\9Dť\F5l\94n\E0\D2J/G\00t\D7T\F0;{i\A0\98\C3wa\F4獀\B0\8De\9Ac\B3\A9u-\89\D0jh\FC\E1\D9\E6P\E4\A4YrvKb\D2\C0=\D2=\B3[&`\98nZ\ED\BAZ\C0aQ-\C8\C4[dt\CBKdx\F3\8B\C5H&\A4
Ave@\B4\00'k\84\C3\E9Ps\EB\F7\A5g\F5\D9'\DD9\F8\BFW?\DE\CF$\E7\A0Upi
\00\EBԔy\FA%\00\81~\8Fn\84\BF\A9)2;\B7\A6uFz\8Dh,6q?c\AF\BC\D6Jc\B7d=J-\88efd\B4e\A3$\A3\ADxL\FB@\B2\BDAD\C7\C8\F8\EA-\9B\92֩}\98`HR\A8
\B1\A6߅\DA:\FF\F6\C4ߎ}\FE\BF\9E\99\D8\E7ȃn\\80@@\00\\00"\BB\B0A\00t|\00\ED\94h[\EB\EE\EDȵm
K\B4e\B6-\92MF\A9c\BB֔Z\90\94ޱ?ʦ\B1\87d&\D6#\E3\CD\EB]\B5\CCK9\96\BDaf\F5&9\EC\CFd\B6\A5Kb\83\CF?\9E\96Ѕ\E1\D5\CE;\E1W\BBum^AG\AEA r
\94\F6;\B2\A2ߚ`,ozj4\93\9B\EB\8C\9B\BB\D2(\D3[\A1\DB1Ď\ED\93\8D\83\B7\C8\DEӎ\80g!c\9E\9B\94Ɯ{b\A9\B1T8\F6\E4\8Ec\DF\F2[\8E\F8\F1;\CE\FD\E4\B0\C8S\F6\81\DCYQ\C0%p\F3h0'(\A5\EE\87NMLO?2#\FDk\DAe\EB\96fY\D7:\91\9A\C5\00\CB\B3\FA\A63m2>\00w\DB\C0\A4\A4\D7z[\83Pd\89\E00\9FT29\92\CDf/q\F9\EA\87\FE\EA/Y\EA4h>\87@@\00\Z\A0\9E8Lwp\9A	\A8\BCg\C0\F6\E9\81	yl$"}\DB\E5\C0\F5i\E9\89\C1^\FD\B9\A4\86N(&81\97D?\CA'fL\DD\C5ʤ%\BDE=\84\E6d\80\FC\D7៟?\EB\CC\F7<Rzo\C1\93\95\86@@\00\\82xg,\D4\D9\B8r\8C\89w\j\9B\D6Xχw\8C\CA\F8`\\D6mk\93\A8\9B
B`\97\80\98\A4Cq\99\98n\95\A9~X\E2'\A6L k}\D9\ED\C3&<\C2p\92\F3\F9\87G\BE\90\CB\E5n:\FB\BDg\9A'\FD\ADf \00\97\96\8A*\00B\E1e-Jm\B3\C0&s\E6\99\EE\BAL\B6\DB\CAod\C8 \AE\CC\EC\9C\EC\FAcR\86\FA[d\F3\D6n\D9\D85#\D1,8y\B5\80\F5\FD\A6\92\AD21hHfxZP\D8\EC\CCe\93_j\B9>j
\EC@\E7\97b\CA\FF\F5\FE3\DF3\E9\83n*\81\80\00\B8p\E2'/Uj9󝰈\EDC\96˃\B1ٍ\CA3\83\EA\A0N\8CM˟IH\FF\AD\B2mS\ֶ@\94\E7Y\E3\F9\84\00H>\9Bm\95\B1\A1\98$\E6\E0\8B\C7E\C4W\C8\EF^Sz>Y\87@\FEo\A3\E7\CB \EE\EFt\EF
AOՀ@@\00܃\FA<\C6i\FClc\CE<\90fҀΙw\82\96*\E9Qē}\F2辨\AC\DE\D8&\DB\D6gpt\80ȑB\E0\F8d\8B\CC\F4\C1\B875	\9Cg.\AE\937؛<?\89\C8=\9D\CF>\F3\CC\FB\EC=\DC\E5w\C0\A5Bf\DCL,\84|x&\F0X}\920\94\AF\C7ʙg\85]\A6\C5:\B6\B0\9B;\F8ܘ\8C5Ɇ-\9D\B2\B6͐\99\A1\9CdF \EE\E3x]/\C4}\AD\E7g3\99r\D9\DC\80\FD\C8\EF\A0ܐK\C0
\BA\F1p	\B4\E9X\F3\BF@\FD\9Ei'\CEi\CAe:\C0\F4\E7\EDn\B4\BFE\C1\98Yj\9Bj+\EC2/\BE\FB@z*!;P\BB3\BD\AAS:'\87b\EB\BAu_\EB\F9\E0\F8{\91\89\FCe\FFʳ\DE{&\93\9A\82Vg\80K\FA\A2;\C7p\96\8F\9C\DF\E9\EB\BEם\9C\BA .\C97\C6s\D9\AB\E0h\DB\00_e\C5\96\A9\94\FB\80\F3\A3\B8tҝY\B0þ\B8\AF́E܀Zχ\B8?\E4\FFԌK\CE:\F3\CCg\QЍ!\00\97\E5\98_\F4ݏ.\DF\FC\87S֜ў\9A\F9\A7\96\\EA\E5Y\E8\EB\96p\DE~\C7C7P\D9CF\A1\D0m\C8\CE2\EC\9C\C8O\B9}v\A4A\92\E77\8B]
Z\CF\F2\FF4\9B\CB~\E1\AC\F7\BC\E7.\FBo\EE\ACUx\B5\E7j\AE\8D\FB\A5\B7
]\FFX\CFN\89\B6}:\8A\F47\D2\F9\89\BA\D4\F6j\D8\B6@"\A0\9D\80\DAMw\BD\96\A8n\EC\9CF-\BE\C9ܻ\F8
\D4\F3q~\00\8D|<\84\EC\CC\E9\E9\E93\E4wm\F8\BE#\FB2\A4\EF\A7\E2\DF\DEsR\EF\E6\EE\DC\EC?4e\E6\DE\DF"\99\D6\F3\80\F3\86\ABa\D6A\96ڞ*\E46\E4\83q\BBۥcfd\BEv\FE\ECu\8B\AA\EFRc\E8ꑾ\B3/\96Ls\BB\D2\AC(\BEA<\FB\D5L6\FB\F5\B3\CF|\E2\F6\83\D6HT\80
\AC\F6qw\F4\D3_\FE\F1\FBO\DFpMWr\E2\9Fc\B9\E4k\A3(\D5\C1v\D841h\81}`\A3>\8A˪\97\EF\94B+q\8EXUz\F7\ABç\E2\F6\91\90NϤ\D2\E9\EF!v\FF \FE\93\00C\F0
B  \00\\94\A3\B1\E7\9E\D5W\DC\FD\86ۿ\FFƷ\B7d\B4dS/B\ED"\FB\00\98Gq\B1\CA.\8F\E1R\F6\BA\F7\8B\8C\93\CF\E9\EA\BB\F420'\81-\9F\80\84\80\FC\CC\D8\B7\BF
\88y~U\C1\E9\AF\F2!\8A\ED+\B9\B6\87\B4\EF\A3\9E}\F1\C3\DF\B6m\CB\F1c\91\B6N\91!\DA\F2\82\88̒«V\BC	\C2\FEf;:ؗ\EAÞ\99\8C\F4\A1\AFNH\CAG~t\C56\9A\9D\FE\F8X\DB\EA\BF\90\BF\B6\F7\91[\A3w*a\BA\F5ޠ\F7\BEzӡ]\89\F1\CF5e\93\EFjB\A6>\E3\96\DA\F8o\C1\A5\8E\EA\A6\DE\00\C0F\D8\00:aH\A2\\A0:\B4s\85\00#\F1\FBF$\F6S\A3\A5\F3_N\FC\F5@\C5\EC\BEy\C0'\9B\E1\81S8\A5#5\FDO\AD\D9\D4I\F4\F1k\FB\80\9E\F1\81\FB㨲;\82\83\AB:\DAĘ\96!\E8t!.]HJ\ACӟ	G\9E\88\C4\E2\FF\BA\FE\F7\90/\DF\E4MA\00\9F\C00\86s\C09\CC<{\E2\B2s>;\FD\E9\DEӜN|\AEM\D2\B3\BE\C0\D2\FCZ"v\80\F4#\90hzzV\E9\00\F9\8B\C8\DFy\D8FJ£\91x\FC+\F1\EEU_>\EE\E7\BBF<t\D0qMC  \00>\\BE\BB^\BDm\CD\EA\E4\D8y i\91tw\BEZ\A0\AC\FC\C8\DA9\8BSu\E7R\8Bj|P\DC\CF!dG\BEmj\BA\E8\F8\DFNl\F7\E1\F4\82!\F9\F0\D1b,\CA}\AF\DEpd\C7\EC\F8g\9Br\E9\B7#\BF@yؖ\00V\8D\C0
\85\C7b\FF\FA\AAO\FC\F3\8Dƻ?\E3BQ1'\9A+\80+`\F4\B6\93GOY\FB\86\E64\B3\C9cCp\CE\C2g@	`\00\AD\FB\E0\FA\BB\A3\E1\F0\C6\DB;\BE}̝\C3\EA\00\92\A0\B0\81\80\00؁\92\EE\F9\E9;^Ѻy\F0\A9\B4\A4f?\D5dd\B7<?\83D\A2d:\81h\BEkb\B1\E8珻w\E693B\8DA  \005\B6`\F7\9C\BEiC\DB\DC\E43\89\B9m\C9L\FA\92\E3H\DDVcS\86@ \80@9\B8봍\C7\DD|\F7y\E5\F4<@ \80@\00\81\00 @ \80@\00\81\00
\81\FF\9D\EDG\848ub\00\00\00\00IEND\AEB`\82
EOF'

cd /usr/local/share/icons/hicolor/32x32/apps
sudo bash -c 'cat <<EOF > duckstation-qt.png
\89PNG

\00\00\00
IHDR\00\00\00 \00\00\00 \00\00\00szz\F4\00\00\00bKGD\00\FF\00\FF\00\FF\A0\BD\A7\93\00\00"IDATX\85\AD\96ih\U\C7\F7\BDY\D2Y23ٓۄ\AA\AD\B1\C4t)m\D5VP(\A5\8A~(V)Z
m\B5\85\A2T\B1\8AZ(V\B1\8B\82_\C5j\DB\A5&ic\A0-b\D7\D0%d\D25\99\C9:3\99f\D6w\FD0\998\93e\F2\FA\87\EF]\CE=\E7ǹ\E7\9C\F7\E0.H6\B1P\B6\B0l6g\95)\9D6\B3J6Q0M`\A7la*g\B4\C8\E3\95-T\CC@Lp\DA\CAh\EC\9E\86\EC"\8F\CFD\D11\89B+/ \D9
\8DsE\B2\95w\C5R\823I\A7y\F7\A0a\C0\C4 Vv\8Be| O\B0\C9\E7@\F54\BEo#\D8\C9R\BEm*\A3	W\A0\9C\C5q\FD\C6X\80~D1\E0\C2\C6\D0\F0;k\8D\B4\A5\89\D5\C4`\9AUF\94\FD\FC\C59و[7\80Q%aI@o\E2\98p\93\F5AvNP'\83\80\DE"\CA\00\F3\B93\00\E0\97\91\84\A2\A0a\BAf6^\CB\F1\82\E7\AENq2%\81D\E0\A7	\AC(Dt\88}lU\C1\9D[\C0%\E6p\83\A5HJ\00\CC
\D8T\E8;]
\E9\E7A\00*~\86\80>\80\9C,\A0\80a\FC\86l\A5\8C\9B,\82b\F3J\80\87[-`\B6C\E9c\A0\E4\00`ǘ\B1"q0\A7\C8\F9\80\E7\E50\ED\84y\95F`l\8D&Ѡ\80#
;\84\AE#\90\B86j7\AA@\D6efׯά\C8\000u\E3\F46`\8B\F5\E2\CF\9E\00\E04\82:\A1\813\D55,h\F3\94\E0\B2e\B7\CBL\B1D:\A87\FE\C0\E1k#!\E5\E4\83D\9C\E3/OB\C3\85-\9D`\86\97\E0\C0Fo<94\00`\8E\86{P=\87\B1\FB/s\95\D8x\BB\\8C\E3
p\DBϹt\B9\C0e\AA\C6\C3#p\B8H\ADn\00\80|#\88\D1\F7_\C4\D2uc4@0\BDd\85Hd\BA^\AC\D38\F8\F25\B8\B4@\B8\C6fYϟr#U\BA\00\8C\EC\EA\FF\EFZn\9E\C2ޣ\A0\C9r\A2\A9nU!'\CD\EE\ED\E5F58x_\DA\F2\B2\92AZ\E5[<3-\00\80\CB\00ʸB\BB\E3G\F1\\C1$kWr/?-1\E0\ECeh\EB\FF\00?\E0'ٞF\A9\C2B!\F9\BA\00T\91\D9n\CA\DC`\B6&\87
\D8\CB\E1\FE\B5\8E\C1\E9~8\EDgH\CB\C5\CF}ĩ\95\BD8\98\EEj\AA\008U\C6!.\A70(\F2!\EF
\88B\E50o>\94\AD\843{\F8\C7߁;\E8@s\94\F0/6\887\B90\DEE\B6\89\8Eɫ\C8*\8F\82R\99|0ڠ\F6=~Q5V\C5-l\EFS;Yp\98&\00vCr\AAE\A6\FA\A2\80)\86\CD\E3\ED\A3\9Dc\D9\FCg\CD@JyYf\F9\E8\E7z\D6\CA\D0\F8\C1N \9C\BE\9DNd,v\E3\A0\F1\8D\80I\D9\E5&ʉ\F3\82\F5\A9\BD\987\A3 %T\ACa\8As\C6\D1c\A8lՓ߷n\801\90\FA\CC\FF\BF\BEh\B2*V\83p@\EA\9FY\BF\9Fb\D78\A5\EC]\B0\8FfJY\BC\94\88\A3\B9\8C\A3\C3I\00N\D0\E2\C4:\88>\C6Cd=53\D0]>u\AA\D7V\A4\99
$\CEg\91\A2\84\EFN\EE \E8\EFQ\9E\AB\\|}\81\AD\DB
D\82\83\EA\EB\B9?%\BE\D6\EBWW\00\84\E3\CFwJ݄9D\FB\81\D3\FB\EBc\F6%KJr\85\D7\CFu\BBO\F6\CC
\DD\F6\CC\F1
\DDRV\E8\F5	:\E6@J\BEH\A2YJ\E6FŊ"j\A8\B3c\ED\F6b\AB\D7Âƽh=\FD֞D\DC\B69\8B\A1O7\C0d\CD5\A9\D6\F2\8A4\ECƚJ\B5H\BDQQ\E9\FB\DB֧\963X\BAo\F5*\A1\\8A\A3~\B8\FC\F7\CEͺ\A33\83\B8

Eppn\C7\F1|\EE\87(\F4u\93c\F0@\D9\C3WQ\C4\F6\A7\BE\F8\F1\E8L\A7\A4\BB\DCͽu\A1{m)\CEs\84e\97_o\80\84\F7Vsp\C0\B5xúu\B3
>k\B5\AEY\F8mӚ\9A\95w\C3\D79\D6\D4\D2P\BC\00\00\00\00IEND\AEB`\82
EOF'

cd /usr/local/share/icons/hicolor/48x48/apps
sudo bash -c 'cat <<EOF > duckstation-qt.png
\89PNG

\00\00\00
IHDR\00\00\000\00\00\000\00\00\00W\F9\87\00\00\00bKGD\00\FF\00\FF\00\FF\A0\BD\A7\93\00\00\93IDATh\81řilT\D7\C7\F7\BD7\9B=\F6x<\C66[0KB	\8B\81B.P\A1\A6A\ADT\F8R\A8\D4E%j@M\A8"Em#EB\95\A2&% "UU\A3\94\D0\A2\86\D4\E0\80 @!\CAb\8Cm\8Cױ=3\B6ǳ\BD\DB3\B6\F3f\FC\86\B1\E8_z\92}ߙ\F3\CE\FF\9E{\96{/<"\C8Z4Y\87{\A2\F5*\AD\D0\F2$kQ\B9\88䶬\E3%y\EBD\E9\A6\A8\E3\C7H\A6\E3\E1-1\8F\B0Y岖JT^6\8Eyu\F8\8D\A8\E6\93l5DZ\B2\96\B9(\BC\8E\E0\87\89\A1\9B^\AB\F80\ED\8B\9D\DF"\D8\D8҈֠\B0C\AC\E4j\86v\8F %\81\D8?yOq\F23@5x}'ψ\E5\F8\93\A5DP\CF$\BB\81R\936D\90\BCC\98W\C4:|\E6M\8F#%\81\C06:,U\D8l\C5\E4#\93\E4l\F8P\B1S\C8l\B1\84\E6\E3O\B1\C9\96gjD^$\AF\D2\C1\B1\89\98\D9\A5b\A7N\B0\AB׽\A4Ň\CA V"\84q\E1]\F24\E5\F2\81\B3Y\E0A\F0gJ9/ORm\F6GZ\BA\97\85h\F7\A1\DC\F9\AE\A9\DF'\AA\B9\D0p_Tz\&t\96\DB,f\A3\9BK&\B0\00\C1\B2\96\C7\C5\FA\C6N\9BFsTp$G\80
\E4%\FE\D6)\91\A78h\E9dn\D3!\94`Gb\f\F1\A8\F8\F0!J\E9B\9Aa\9B\DA\82K\C04\8Fw\87Wd~\82\B2\C4K\88\80SQ\A1@\85\B6z\B08\A0\EC{\A0\E5\98\F9tT\E9Gc\C0f\93uJ\88\BD\FC\D8`U\B8\9D\A7
:N\86\D3\C7\00$\CEa\D9|
,"Ah\FE\BA\BE\C4\DC\F4)D\91\E8$\87\C1Dq\CB5g\F8\B8$\8Eb\9E\CB\C5\FB\9FA\EC\84)x@\8Ex\BC#\D0
\8DA\A0\E3$,\00\81\8F4zF%\D8SȧA\DA \965x\B0\F0\8AU\B0P\D3Mk\AE
v\86\F4ѱ\AE\AF\C1{ʞ[QbPz\810\AE\FB\C0\91\99\F1\90\C2\F2y\92\EDXi@\F0&\E7%\D9\C3У\D0zZk@\F7\AFo\DC\EA8\91Y\00\E7\00^ŏ?\A4}\92J\8E]\89{\C2!ļ\A9\AD\F8\D31\95\E5\BFsr\E4\EB\C2\EC	\D8\DE=D^\F0.b\E8D!\E53fYy,&;\C4d\E4\C0\D1
E\C5e\C4df
\B2\A1\B4"\D0\DD*\B4\9D&\AF\E9\94H\BF\F9E\F1\AC4\EAB*`\A9\E53\AB$\C4_\B6\DC3\FB\A9\F8\F7R\BD\C8U\C1\A1@pZ>\C3\E5,%6i\83B$e\8Dpk\D0\83\98A\D0w\BB\A9Է\96s\E3\E5\A6x\DA\F0\FE\F3>fyM\E6\DFQ\A4\F5WrP\F6\B7\A36&\CFw\9DA)\88\A4U*\A0 \C5\D4\FC\FB\C1\E1˹\E4\E5\BB)Z\C0[\BE>Z\80\88\B9\CDVZ!\9B\CE1A\E9\BDJN\D3\C7XB]\F8PR\CFW\BE\ED\98\Z\C2<O\E4\00!\E0
\F0\F1\F4:\FC\C7\E56\9E\8F\80a\BCɭ\BCl\88Jh2\F6\ACՉ,/',\9A\8D7-1\E8HJ\99S\C3\F9.N\BB\E0\C9ia\E8nOƐ\FE\81\CEN\B1o\B4uOƸn\D2\B8R,\87p?\A2\F1:\B6\DE|b\B8\ECᇋ[2\9Ez,\C2lG\98\D0\80\B3\80\F0\A5|}l\C4\CFu\F9\CF\DA7\80\A2\A4\DCe\F4v\A0\F6\95\F8\AC=\B8\8E\BE\F3X\A05t\BF|\BE\F9
0\DF:\CE,\DA	1\95~\A6\B3\C0\E8\B5\E9@qTٱ\F0w#Y\CCa\A4v\DB\C67X!\82\CE>\A8\ED\81\E6\FA\CA4tJ\F11+3)\B3\00\F2T\B0\9A\91V\81ǀj`r\DC\E0\C2\E4\E2\96\EE0}5(Z\BCո\EEE\F9\BC\9B~\9FLDC!~f \A8\C0\C5$\82\A3\C0\EBY"\9E\DFM\C3,\00\96\83ŝ(nj\9C\80Z\B3~O\ED\86⪸xD\C7y\AE\CDW\C6\F2q#\98\C45\9E;yV\BC\C8ͬ@\A2\B8e\D8\EER\00\AC\80\82\85\A0\F7J\A2:&\C1\82\ED\F0\E4\AF9\DCG\B1\E0&\88\87]\B0P\EC\E4X:\F5\99\CC)\00\85\B4\9A>3\85\BA\98x\DE7@\C92\BC}\8F\B3\AA\E0[^\93R\C4O\C5N\BA\CD\E8͘\C0pq\EBτ\84\8D\94\C6cӇĀ\972=\E2z\A8\B3\D1\C2L;\CE\F6p\87\87"\90\AE\B8=\80\\D2.f	c\F1\89\B4
[\81\D4\F1\DC `\CC\C6\D1\9D\AFƕJC\E2]\F6\A2\F3H}z\AC\90\BA\E3A\E3E\D9+E\BFGSJ\A4>V\D9\CF
\B1\97\F5\E8\AC\E3\D0\CAW\8D;\CEͩw\F7\90le\DF\8B8\9D\89\C1F\9FI\B1\9F$\8B\80p\FF\CEL\88xZ5\C4\F0d2b\C0\8E3\C8\Q\C5>!\8CۃL`*\88\C5>"b/o\A01\C1\9B$\F5u\B9*؇
\95	}\8C{%p
\D8
\EC\E1\B1\92@\B6\86#\A3,$\DE\C2+\DEe;\82\A5\C0\A9\E1qO\C2B'\007#yv\E0\y\93&\EF\FFs&\EEz	\E2\00!w\A0\DC,)\97\95\9AE\D25<\EB\81\00zn\C6\D7\F01-\AAĹ\B6\82&Ӌ\C6b$E\E3E\F16\ED\D9\C8\EA\92\CF߫\F4\B5^\D7hh\86B)P\80\8E`:s\9A\E3C\A7Z\B79\E6t\95\B9bh,\82\9Fz\C5\FEl\8DϚ\80\D9\8Cq\BBD\83\F9:\B0\97O\C5"\B6\FE!P\DBW\EArT\DBU\C4P0\F7\D29߬3-\A5C}\91\BC\AF\DAn\A8^o\B3\B6\E6\FFN \A2˾\DEH<\91\C8(R\FB/\D0Dགྷ[;\AD\F5\DE\C5s\BF\DC\E3T.aF\9E\B7Ua\A0\B9\DDq\ABwjUxH\A9\E8
\EBY\E8\8A\D5\BF2@\B7\AB\AD\DDg\AE\A9\E8\BBt\98/\ADvn\AD\81\F3\FF\88\A5h2Ӝ2\D0G\E3`\8CWqc\B6\C6CƇ\D9\F7c\F3$\D6\CF"\C4\F7\FC\F2\98\DD=0\DD\F1\E6\CE\EC\FA\F7@3m\AE\F9\C4T+\D1\\ED\D61\90\EB\C1\D2qǫN\99\BB\B9\FAȵ\E7'\82@V\F0\D8\D4'\AAP\90r\E9\A5˽\957\94\B9ĄF\B7c:\B1km\D8{;\92\C5/\F6<\B1\B2\BA\FAXcѪ\BF\9F9\9C\9D٣Ȋ@\A8\A2\B2\AE$׮Ov\A8\A8CA\C2\D9\CEYϵ\A2\B5wB8\D0!\BFj\BAus\E9Ϸl\A9\9B\B3G\91\F5\CDⅪ*K\B4\D8\F7YQ_\F3j8F\D9L\8A:o\D3\8A\E1_\BB\E5hۊ\F5\9B\B7nڔ\F1\B6YL\D4\D5(\B5W\BA\82m'\E4@E$\95S*w\AC\FE\E8\F2\DB\A5\FF\91\A1~ò%\8F\F2{\FF\80\A3\CAmF\B6\00\00\00\00IEND\AEB`\82
EOF'

cd /usr/local/share/icons/hicolor/512x512/apps
sudo bash -c 'cat <<EOF > duckstation-qt.png
\89PNG

\00\00\00
IHDR\00\00\00\00\00\00\00\00\00\F4x\D4\FA\00\00!\9AzTXtRaw profile type exif\00\00xڭ\9Bg\92d\A9\96\AD\FF3\8AZ6`\F6f\D0\C3\EFoᑲ\B2\BA\EA>\EB\CB\F4H\E7\C0K\00\EE\CE\FF\BF\EB\FE\8B?=\E4\EEri\BD\8EZ=\F2\C8#N~\E9\FE\F3g\BC\83\CF\EF\DFo\E2׳\BF<﾿y*\F1\98>/\B4\F9y\93\E7ˏ|\BBGX\BF>\EF\FA\D7+\B1](\FCr_\9Ftg\FD\BE$\CF\C7\CF\F3!]h\9C\CF/u\F4\F6\F3P\D7ׅ\EC\EB\8Do(_\F3\F7a}\F4\F7\CB\8D(\EDR\8C'\85\E4\F97\A6\AF\A4\CF\DF\C9\DF\C1\BF!u\DE\E7\BF=\E3\DES\E3\EBb\E4\97\E9\FD\F0\CF\FA=\F8\E1\EC\F0\E7~~\9C_ϧ\DFbY\BFe\AD\FE\F9\85P~{>}\BFM\FC\F9\C6\E9\FB\88\E2\AF/\8C\CE_\A6\F3\F5\F7\DE\DD\EF=\9F\D9\CD\\89h\FD\AA\A8\EC\F0\ED2\BCq\F2\F4>V\F9i\FC-\FC\DE\DE\CF\E0\A7\FB鍔oo~\F1ca\84HV\AE9\EC0\C3
\E7=Z0\86\98㉍\C7-\A6\F7\O-\8Eh\E4'\A4\AC\9Fpc#{;uri\F1\B8\94x:~Kx\F7\EF~:wށ\B7\C6\C0\C5\F9\DB\F7\BF\BD\F8\9F\FC\B8{M!
\BE\8F㊪k\86\A1\CC\E9_\DEEB\C2\FD\CA[y\FE\F6\F3\BDi\FDO\89Md\B0\BC0w&8\FD\FA\b\95\F0\A3\B6\D2\CBs\E2}\85\C7O\D7\F6\D7\F7.&$2\E0kH%\D4\E0[\8C-\E2\D8I\D0d\E41\E5\B8\C8@(%nsJ5\BAi\EE\CDgZx\EF\8D%֨\A7\C1&QRM\8D\DC\D0_$+\E7B\FD\B4ܩ\A1YRɥ\94ZZ鮌2k\AA\B9\96Zk\AB\B9\D9R˭\B4\DAZ\EBm\B4\D9SϽ\F4\DA[\EF}\F49\E2H``u\B4\D1\C7sF7\B9\D1\E4Z\93\F7O\9EYq\A5\95WYu\B5\D5\D7X\D3(\CBV\ACZ\B3n\C3\E6\8E;m`b\D7\DDv\DFc\CF\DC)N>\E5\D4\D3N?\E3\CCK\AD\DDt\F3-\B7\DEv\FBw~\CF\DAWV\FF\F2\F3d-|e-\BEL\E9}\ED{\D6xֵ\F6\EDApR\9432s \E3M\A0\A0\A3r\E6!\8B\959\E5̏HS\94\C8 \8Br\E3vP\C6Ha>!\96\BE\E7\EEG\E6\FEU\DE\\E9\FF*o\F1\9F2町\FF\8B\CC9R\F7׼\FD!k[<g/c\9F.TL}\A2\FBx\FD\F4\E9b\9F"\B5\F9\FDqܐK\CC77ou\C7<\8Fe\AD\E6\92ZܟY\FB\FBJ(\87\F1\FAf\C1\D9\CE\F5;y\DC\C2<\F8\F5\B6Z\D2)9\D3`\AB\B6)̻Z\B9\B3\B4pO$U\BD\AEtB~\96j>\BB|\F6\AAi\9CT\F7kXm=\EDu`\CB֙\F5L\A3\F3\81UJ\CBs\D8N#޳\F2\B97\A6:\B6\9F\A0\EFMyT\D7+\C3Όq\CF\F5K.\E2\E1\8Fe\C1v\AD\97U\FA\EC*\C9e,\EB\B1\D6;j\EA\00\B4~\EA\DD
"\A6(q\94e&qY\D2m\91_k\DA\CC\EF2\D0\D2ܷSIy\9FH3\BCF\AEvI\F3\EE\BA\F5=\97\85j\A7M\F2\C6?\85[\CD"\F9N\AA\EBx\A4D`ڜ-Κ\8Be\8Ak\B8\D3\C7&\BD\850u\FA+\AEE\FAG\B6vC\9C\D2N\00صM\86׵{\BC1\C3hk\F3\B6m\AD\C7\DB'a\8F\EE\CCM\A1\8Fq\E1\BA;_\91\9F\FB\DDӼƛn;\C1\EE*m\9C\D2\D5c\FD\CCRv\86k&3\EE\96S\A0\ACC\FD\F4v\A7n\A0\D0Y\FA:\B6۱E\9CW\EF\CD\F6 \C1\BDq\A5N R?=\D3dCC\E7~\8Eފzk\85\A1\EFvP\CC`\A8\EBY.U\93Tu\9B\A2\A0~\C39\8B\E1\8DV|\9A\F1\E1\E88\BA;Ѿ\EB2o\97v\DDu\D1\E7\97)'\EA\960\F1TMP\8C`t\DAp\94\FEi\86\DD\AD\F7+\C0\F6\F9\E5Ӣ\B1\FA\B5\D4wY\96W̭\89{7\FD\BF\86we\B6\81\BAe\B0\E4\FA\D0Ug\B6A\A30\9AC\90º\94H\A78\89\DB>\EE\9C\E4o\83ꍪh\D9nr\BB\B7\B0}#25\ECJS\ECf\EA\FD6\BBf\E9Z]\95\99\DEJq\E4\8DYkѢ\8C\E0\F6\D2N\83G\8E\AB\A1k\A0\CC{\CF\C00\F7%\FDm'K\DC\85r[\DBFOu\8A\C2\D3}s\9F\BC\A8\84TF\F4,X\96\A8\E3\EAJT%̾\C8PQ\95$0b\B9\A2':7\86S\BD=\F0	\B9[	\F0\BDGT\D6
\BE1\BB\DETv\96\F9\A4\BB\81¥\F4\82В: 6m\92\FCI\EB\C3STF\9A \CDM\E8\E9\85a"˙\B2\B2@\CD샂i\F8\B8eP4|\98V\AA\CC >\A1\AB6\CDs\DA%\B2m׏\C5\B0\87\9D\A9U\BB\B1*\DD(\87\C4\FFg\EF\B3Ū\88:F:\9D\FB\9B\BF\91q%~\D3Aɚ\C5\F1a\C1\82$\D3݀ˡ\F5*\FDU\E6\B9ːs~\C0`Ф\9A\E7\82
<P_>g\A5\A6\A3\D8 S0$\A1\ADf<=L\FA\A1\BD\88\A4l+gj&\(\A7E\C0\85qtB+\C1J\D3\FC\83\81\CA\\882\840\DB)L\9F\B7\EC\F2\A77\E9Rm\AC\A6\82\F1\C7\C0۰i\91:jq\8D\BB\E0_\88\C01e@f@?\C5h*\FAv2[.D\FA\EB\F5\D6
\F8d\8AJB\93:\EA\9CQ\FB\BCݬ\8B\85\AA\8D\C56u\DC.\D3Z\A4d\9C\DD\E0\EA\C5\C7?p\CE{\E77\8Fhv=\81\87F\8A\D2\E2\C1\D1\001\EF\B8\E0\F0Sf\86KA\ED\81w\EA\C0$\F7MF\\DB\F5\C29\8B\B7n\E1:\ED\88\E0;\AB\86J\A02\95]U	\E4\ACđ\E3\8C\C2\98<Zۣ\00\BA\E6\F1y\ED\C07\9C\BC+\EAdDOD
\99\E6\DEi6x\8D\AE"\F0:h\A8%\A4n<6\C5g\A0A\CAIb\FA\F0=\C8\F8G\CF	\93\E5	r\AD\8Eb\E2\A6\F9.\B8M\D2\94a\A4\EF\D0\00Z:\A55\E6]\D1\C0ٌ-PM̞\D7\F18\B6\C0\C0|]\A4\E4}l~W\AA\9F\CF\DCX\90'uM\E4H\A7\F0\D0/\E8\8CzZ>\A1j\D2`\AA3\8DXUH\99z\DB\A1E/\BF\E4d\FBEL\FC\E9\F1\CEp\A8\C5EdrPO\E4&k\D4\C8\C6\C5	-\81c\DA\CBZrS\EF=\A9\FF\98ϴz&\BD{P]F\B9\B6Jځ\F1\8B"C
\80٢w8\9D\FARU\83?^Btd\E6\87\C9cN\FEAԵB\94=\B5L\B7/\84#ܕc\A1\E8\DD\EA\A0N\00\F9k\D0:B\D8l\C8\FD L\C4Ou!\A3ѪQ\F7;P\96x7\A1\EA\E8@R\B1'\98\AB$\FC\DA$x`\8E\88ev\00\90\9E\84\C3`Rz\8B\EA\84(\E6
\9D>\C0\8D/\F0\B1m\E6:\A8\A7\A4ɡĨ؛]܌\8E.\A9\BA4\BD}R\F7f\B4]\B4\8F\D2ƴ\F3\D6KO\B9Գ\E6\F2\F5\A9Ft\F0\85i\EE\F5\9C\B3\95\D7M\EA\A2\DA*\C1\E0e~\C8,\A7\E1&\C6V\BF\AC\%\F6\D0
\AD\80.\C5C\9D(>\85\C6Ck\9F\8Cr\85\DE y\CA/\C3f#h\C4\F9ϴ\92\8AA*I\FE\DCNē\91\D0\C4,\A8\97Vg@\81\80n\A3\A3P0\94{\A1\DF\E8\A2\FEyX\81a[\00\E8
Bx\AC\F1\B4\87Byۦ=l\8E\D48`\DEhP\82\DD~\B9ȄÅ\F6~
\DC\C5t\C6\FA\9C\EE \BF蹜\C1N)\88\F0yȪy\83|~\F9\D4>\E4~\FBV\F2\E1\8E\C0\99Oe\DF\E0\89\F1gQ;\A3\E3Q˵1\F3\8C\98\ECtuxbt!,1	}_\83\A8\E5\A7{\A7\F8B\98\9E\E6&
\8Af\A28\94\89]$\824\EA\FAP\D2n\A3߹r%]\B3\AFz\91\91\B9\C4\FE[\81\83\D1[~B>\A8͍:\83\D7x_\95<FNN\E6BQ&[\9F.\BF-\FBg\BDĀr\82\A0\B1G\C4\CC!$\00~*1(̄\B2
H	T^\F02a\A7#o#Y\94\82\C8:Ki\E3\E6\E42\98\96\DA\86\A9\ADj\F8\B8\D23\E8	\DC"\92\C0\87$\9C=\8D4k\E0\DB"|i]\A8\BB%\84WO\86\85:\DFY"\CB&\81XѴ_'t\A5b\CE3\84&\F4\B70\86\FC!A\CDݶ\80΢%%\AE\B3\A7tH\B1\91R\B2Q
\DAs\A1\F0V\D0\CA\E5U\C4\B4\D0֭ zHt\C2$\C6(\BEᗗ\CEÐ\B8M\B0\A2|\A5\8C\FE\B2B+Gp;\A0\A6K\C3L\DCW\82\D5\E0\D3\F2M%"҆ɜ\AB\E0A\A3\D5q\B0zP\BB\96i0\D8\DEh\A8\89\EB\EB\FC\8Bi\88D\BDL	\A2\9C\AEC\D8\82\89_)as
\E5\DF\F6՞怔(I\ADx\80"\8F䁉g\00@2	\B6\E5:\89B\EE6,\E36 \C3t-\DCj\F0\EC\98-d\F9\91@\C7	Q\A6d=\F8\8B>Z(\B2
\CFs\96_}\9DA\B6\A2\82W\A8\E5\C0m<\D2;\B33 \89ˌ
q6὾Mr0\C2cǣ13\C2\C1\D1֍B"\D4\E7F\B6\D4\DCG\C9a\A2@>\A9*\E0\85\C6\D5>`\DBNf\A8\FE(\85\E6a\A9T`?\F1F6\998\9F\9C\B8d}\C3B6\9C\FFB\8D!\CE\F1\B7\A2T;R\85zu\D9D\D0o\8F\F3\85*s\83$J\\C6\84\A3g\A8q\C0\93ɡ\88\CEgҞ\EE?r7\A9\B6\E1\EB\A2\C3\F1\E3p\BCZ\D90E\F10t	\B7*\82}@\D3\E0\C1\94\93\9FA\DD\ED\B0\C8Y\8F\B8\DF	\B7\CF5\B8&\#\85\C23;S\E9\D1&S\881\A5f\E4:\A0J\A4\BFt\95\97\8FoN\85+ M\BA[n\AAJ/\FB\81\A5\E9\B5\CA\E7#\BB\D5Z\E5In\84q\BA}\8B
\EA4C9\F0\9A7\BA\EF\8A\B7\80$k\AD\E6\\BArz\88\90\FB\F9聃whDD?\80`DJ\A0\DC	\B6\FC-/\D1\EA\E46*O\98gz#L\97\8E\8C\BC\E7ΉY\D1\D8S\F1\95Jg\80\AFe\C2>\D2\BEA\D9\C8\D0\FEV\B5\E6\83\E9{\DAf\EC\F8!\B0\A4kHv\EE\F7\CDRd\C8y\D0\AF2R#w%;\B5\88I\00\93\BBը!\B4\C8?k@Pz0\C4\CCIU\F0\B0\B3\9D\92\A3\D81D\8F\AEF\A0\C2\CD\C0\A7_\F5#o\8A\9C\A7\81\95s\B44\00vE\E3\AB\E0\E89:m
b\9F\EAh\FE\A0\D8\DAF\AB5S\F9MD\857\84\C8%\FA\B1\C2m
\D9\D2\CD#c5\F1N=\81?\A1\ED*闔\C3c];\F6\B4l\F8w\B3P?\A5"\D4rYZ\A2\E1W\80±+
\EFO\AA\D1U\A4y\8CoԀ+\F2\E6\B1\FB+\B4P\9F\D5\F2\E5\EB\D2=
\DBP_\AD\D6\84\8C`D"bD\CB;(\B1i9lҶ\E9R\8F\F7\CE\D3\F0hIn
\F7\BA\A8(b\00-\9B\BB\B4'R\85\F9VF߰~Hqs\D9c<\86\00\CB+\90\81\AD\855T\DDBf>\E1z\F0\86pU\D1J\8E\F3\8B\EC\D6\F8؞\B8\B7\CA\EE,\F4!ZuH׃\8A\88
Q\C11a\FE\00\91\D6kU\AC)\D4d\88o˘\CC\00\A8;b
\ADj\F0\DDZ\99\FCZ+\F2\9CV(a\C79\A0\D9jr\88ZBN\8E\B4>\C5;\A0\CD3\B1`\F2^9ReP,\B2T;\B6Q\D3X\C9U\86CRA\8F\A9\EBm\E0,J\B70\E4M\98͠\CB\E7\EAF\83 \8BbA\C8\E6\FD\91\00'*\8E
{\99<%\A1\90\C1\82ɦ'\BF\9Er\9F\E7*x\A5P\CEЁ\E8ҋ֋\91
\92A\82\96\A8\E6%$L\E9\9AxH|6\F2|\BDy\D7Ʌ0e\D0oK\B4\96\FD3\8C\89\AE\9F\F3\8F\CDBӒ6\BC
%B!DI7\C1\A6\84:\9B\80#ދ\97\EB\85b\A7\CE\F1\F9d\9A\81\C3\FF}\C0\CD\DCf\00\C4U\97h\F4ttrЏ1Rڰ\EB
Z\92,:\DD\C0(\90\B8<\FE\B0k\9F\C2\D9\C25\E9\8F\D1|f\A6ಙi\B2\A8\89\B7\D6"\C0I\BE|n\8F\93\F9iB\83\EE\9An\83#\BB\87\D0S`s\BA\A4,\FAC\8A\C4\97Qᆠ\C5\AE\DE\D1ҨS{9ı`\A4u\8F\ADu\A10\E4u\B1\91\BE\CE)s\CF\DD\A0\E3\85:-`zJ\E9F*\9E^L#'\C8\BF%\E3\E8\8B#\E3A2aoE\CB\FA\BDOj\F4\98\F4\B3v!\B0(!ӹ=\BEW&YzI֪-՞v\F6\FBϭ}a\94\9C`JZ\82\B9H\\E9\9D|\F2\EB\BD(\D8\F7n\C4
\92i j\FE\9A\C0 \9F\D6Z\A2s\B8\9C\E1d\97z\D4
\88\D9O0`\F3\EF\D5\F1ͅ\9A\85mRxuF\D4hh\87\FE\BB\88F-2\D9AP\EFF\9FݍE\B3\A3v#,\D4\FA"@B\B4$\FFM^\E4L\9C\B0\910-(\85~\DBp\C1O>\FCp\B5\CAl\C0\8DM>?\EAm\B5\8An\E2\B1% \EB\88Z\84\95IvZL\CC\EAj\E5x\A2\D4i
\D7r\A1r\F0?>\F0{L\F2\A5^\BB1bZ$Ket\F4\85\D4\00E\9DG'f$\85\88\C6P\96=\E5\D8dU|\F0\96\B8^\C6!IA\A0Ǡ#\FC\83F\82\C0\EB	\A8:\91Tť*\CDr\BB\ED\AD\A9\C7AF\BA\8A,\CD^\AB<\9A|v\9FL!\96謿\F4\F5\E7\t\9D\8B\FEܙ\CB˴\EE\DC\DCw\A1\8E\E8-\A7J\FA\98	d\EADzi\CD\F28\AE`\A0ƾD\D8\FD2\90e3%
b't\CAlp- \B2;1D\F0\90\E0\BE\C4c
\94(\AE\8B\A9\A8U\9D\83\F8\B1\C0\A01\9CSG '4\83ɇ6\EC \D2\C3ltdiin\C3ܫ\F3?\A4\D6\D3S\A7\B4\87\96\88DiӃH>!݁\F1\99G\B8\9D\9B'w\89H\97\A9\F6\EED\A4S\8ES\96{\83\E9\E4C\FFrT]K	WV6\8B\84\C3\D8}\90j\C0\9F4Ϡu\D4h\A4\E8\EC\8CM0\E0\BD)1\8EH\A8\AC\F0\C8\E7s\83\B1\E68HPP\81֞\B8pQ\AB\A8dFޛ\B0\9C\90^\8D+g\B5FB(뻹\C6;Y\B4\9B@e
\92\E8\DE2\A5ղ\C3!"\DC\F0\E1\DAп*mȐ\\B5\FAE!k\B7\D399\D42\A0I\8F\E0\8BgLw\B8j\D6\=N\870\D2c\F2\A4\A81:Ő\AC\87r\8D\C8\FC*\C1\97\94\9B0!ܪ=
Y\BA\A8\A5\CCy6\CC\C0\D10\DAP\DBڶ\E3\AD\D1j\FD\AFD\9Fޚ\B6\8C*\F6\F6ˀgj\C0\FE\A40\/\8C\DF5Fy\E3\DFK\F7\93\C6\D8\E1붝g\C4\E2M\CAx[Bn\AC\E2Az\90b\D5.ה\AE01\91\9FF?̛V\AFe\B5\F8\81\E3c\B2\D5{\00\84\AC\B5\80\ADU.-\C6E\99P\BD\80d\D94F\E5\ADC\F8 -\88Rb\A5\825\CF\DC"\DAo\94\D7n\E9\\A5%\9DXb\AD\B1\9CH4\C7\CA Ĥ\FB)\D5\DEM{\B7;\E4aܵ\A9\DD[\AApV-\CD"u\B4\B2hF\84\A5\E8\A4\DF\D0\C2=\B8\E8\AB\C8ג\E6$\A7
\86E9\B3\E3Q#\93\FC\FE~\EF?\F8\D2[\99ٴ\A4\8F \FA\C2p$Ak\BD%\807z\88L\E0wU\ED\FB(ߒ\FE\88\FC\A0\9D\91{r\A9hk\D27q\A1C\8DK\FE-\83eS\96\ACt\80\B4\A1p\80̗\E0\A8;	K\92ضt"\B4X\DA\D9v4P[\E0\B43Hԡ\A2o7ƈ.t\F4\91z\D1\C6M\81\D3\FDDtdTv\B2\DAZxowh\94̢\CE*\BA\B34\C8@\81֔\C5Ո\B4Ih\92O\85\BA\A1\82\8B\99\91\C5Ѳ\F7\8Ai\9C\E9\F8ltߥ	\FB\A0\95\E5ŊT\89\96\D6\FD`\00J\A5\B8(m)\80!]io-F\BB\91\8CI:\F3\F9E\BCo\EDxQ<f\DA\D7\C1@4M\FB\FC\F8\E4s\B5\C9
\93\871f\E4Ea\80>\FBCA\DF\E9\BEߛ\EFϭ\F7\8F\FE\FB\DEz\B0\C8\EF\9F\D1\FD]\FBE,\BB3\9C\B2U\F4-4\E0\FBG\FA:x&\C1x\88v<H\C1j\EE\DC\DC5\FEX\C5_Z\AC\C2Esd\B2\9C\82\95)Z\B4>\9D\F1\A65$\E3*\84Z:Egҫ:8s\CEF\9B \E9b\86\F2\A9\DA+\B8h\BA\91B\C1d\FAp%+\BA*ƍy	 \A9\A5\F3}\8D\89A\C6\E4m\AE\89z'\93\88~
\B0\82䵊\90#פֿ\8B\C5R`)D\AC\8C\8A\8C\FEGb\AC\80\89Fw-) 1\E1\E1rR\88\F8\89J,\BC\AA\DFc\BFQ|`Ę	\90LT\F7D\A0z)$\B8{\83X\BE2\C2\D4dD\B9Np!\95泦o\D9\DF\EFS\80X\A7\B9\B2V)\E1\BE5\81\9D섀V\FC\A0\CF@\D3\CCИ:|յT\D7޺%*\F2)\8B\8D6\E8hl\96\8F\00\C5V\99Cr\D4l\D5\CA@|ά\BB\8E\80\C4#\CB&\EF\84\DA=u\8Cb\D4\EE\ED\D2Z[\A6ע6\87\8Fך\A3,\CCJZz3-%\D0c\96ǡ{0\EF	\A8L\C6<KJH\8F\85\C0`3\EA!\9A\86p\E6\9EJ\AA\92\AA\82\AF\D8\B6C`Q\80\DB\E8ND\B0\A3H\80z*&@\F5C\8Cц]3\9D\A4\BCrq@$yC\A8\80{\D2B\81k\D9
Ս}WL\B2\AF6	r\FC\D3;\F9\B4A\FA\9E~\F5Z\AB!|\F0\80\9A\BBc\D5I\AC)\925R81ߋdHC\A7\89\B1\873\E9Mm\ABhi\A2\E9C\98\CBC	^X\96\CCG:eܞP\00-jWi\BDu
\B7\A3O'\B7\DAp?;`e\DAж\F8ݫ5\A6\85Q+\C0\8A\CEg\F4\AD\CD-\AA6#\\F0\92\93H]r\DAŪ>9TȊZ:\E5tU\߲><,.\C2\D6O\A1*\ADF\D1\DCb}w\AC߬\85\FB;o\F1\9FZ\F7o\F116\89Y\F5ow\8B\90^\DE]<}\AD\D5\C49\B4:\E8N\FE\CA
\A9S:\DA쬟\CD\DD\86/d\8C{\CF\F9\9A\827\8EPD5%-\A4Cvҡ|\F6"muJC\85\B5C{\A4\AAS\9EHk\ED"eL-\EA\D8\C3"\A8,\E2#\F1\B6\CC%<d\ED+\F7ѽ\96X\B5\AA\CE\DB\ED\EA\D4\C4I\DF\BB\94\B5\956\B1ȉF\F6q\9Au\B4.C\92\86+\E8\E3\FB\D7+\BC\CF#\B3%B\A9T\C3D\D6!v\F9`io\E5w\8B\F8ѩ\F4;\E1rZV\87\E9\A8\C4n!\F71\E6\E8\00\90\81&\91(<<hf5y\EA
\87D\F1GD\F0>',:B\AB,\8E\80ip\9E\F3q\B7\F4f=N\8F\CEƱ\ADa2\83@\E7295n\FD	\CFz\E1y\D1q]\84\FE\DB\DAa\A2o{\87>\95\F4?:\BFf)#o\C29\88[\91\96\DA-r\F7\8D\86u\B2\84\E0\C1~c700gd]\A7Y
\F8\BCt@\A4\ADW\A0j\C0\95/\A7\D3H\84\DBN:\B6\84\F3a\F0*8yW8J6\91\9Dר\BE\C1e\DAsw\BD\82\8D2\A9\A2\EC\C0 \B5\E7XS\F8a\B1\FA\D8\87a:~\86_\F8e\B9N\9E\C0\D2\00V4W^\CFc[We\D3|\B8\EC\A5|:$\F2O\9C\8A+\FEP*\81\BB:oB\D4cFx\B9\95*|&\AF\87h\F2B.вN֏\CEF\9C\B7{\8A\F6u\CF\E7\94D\9F=\E7\D3;\9E\8EE\CC\CEAx\82\AD8i\FA$\E6\B6G掮\C1:\D1Wvu\B9 \86\C2\F2:\BD\82\C5$1\C1\D5g\D00Ч\B3v\C8\F3\FFS\B95\8FR
:\C3\D7\DEq;\FC\8A\8E1N\E4kF\8D\B7lU[\C3Ȁ\99\E0/\84\BE\8Fu=!\E1\85
\C2\D4\EE\D7\E6\BA\8Ck\E1\8E໌\FD\C9\FD\BB\FF\F9\E7\93?\84\99\D6\DF(\85:\00,  \91M\F8\93\96(]\F8CNo\E4x剋I\B6\92\E2\A3#(\AAYp\80t0\A6\EA\A9\D7pڠ\00\C6R\8B\8F	\8F\F0"\BC\E3\F5\D4&\A1\B5z(\92:\B6\88c-\F1\B9K\D4\DA\F1Z/\ED\C7u\8A\D4\EBh%\FB\D5z\A3\CE\AD\E7\DC\E0zb\DE\D2תh\83\A6O[\DA\D9Ԟ\C5]m\C0B\80\94\DDx\9B	\B7\D8\D7bNo%A;[\94m6'J\DAH\87\A8\A8\C3P\B1^H\A6\ACS\9C\88\8EQ\90[t\DDd]\91Ltj\C9\A1eo\AD\F4\97%m\E7!+\E6on\B0`!<"7\B5x\F4+\AE\A7\BF\82?\B8\D0j׊\E2\C3zx\8D\EEW\93H\A3\E4`\DAD\9B\8F\B7\B8i\A8\83X\96 \CB~9\A6Ȯ\8E\E7\90\C4ܖ\F6N}\C0\C4\BD\97\00mGQ\BE:\D4\E4\98\CDԩO檍Z8i\00TMm\E2\980EX԰\D7'\B7\C9\B6\CFu\85N\\F2\B8\A3\82j\88F\E44\C4\EA{\C3Ij
B\A7N\83\E9\B8]\FA\BF!5`\A4\D6\E2\94V#\CA\81ᢏP\96\99\8E\F2E\AA\A2\94\907\98\9D\EB4\9BJEKL\80\B20nX\BAP5\C3O\E0\FF\9Dq\C8
\D4\F3\E4N(>\84#g\8C\9F\A0C3\F8\DB;_*\CBG[ \D6/\9A\96\87/\F1c\A8\F4;\A4\8F\B4\D2N\E8\BFLN\8B\F9_7\DA/\8F\EE\C7\83!b\E8\AA!}\B4y\92L\A7K\E5\E2@)g\D0mE\FA\91\FD!hO\EB\B9+\98\91|pxU\D04*\84\A7\F5`(\C2m\F5\BE\FAA\8E6\AD\8EШY\91
\DA
G\A8\B6\E0\BC\EA\DEi\CBQ$\C2umם\E8,
z\EB\86ІN,kO\FD\DBJ\C6\E1b\8C\D4B\B4\AD\FC\96\87ڡ\B1\AFCJNtR@\A8E\F2\81\C1B\E5~6Y\A0y\86\86ۓ\90\8E%\F4\B3\B4\EC\CAЦGb\E2+\CBH\EF\E0\B4\EF\96?\FB\86\A8\F8Fߴ=T_\B4憧\B3\C2B\E1SQڻ,\AC(\97bˠ˽)(\87=Wϻw\AA#\E9T'\DDǦ\AF:\84S\E2TpC<\97\97>asu^\88\CA\E8\A6\86\D5\EDX\FD\D67
\B9"\BE\88j\EA\AA#T1\C8N\DE\CA貢\83P\E5ჾ2\81\99C\F6y \DD\E4U[\DA\EC\D5\C1C\9DM\D2\83\F6P\93N6\B5hh\80\BDu\98K\B8\B5\84?-SVM\9E\819\82珶c\9C\CE\F30#u\B2\9A\8E\A9B\F7\88d\E8\A4Ν_\B1\C8Qǥ$\A2\BDhcתOvt*&\AB\8BdO\87r\B5\E1Q\C0-zq\84=\D74\E1j\BF]\8D\B2ң)\D9Cƌ\DC'h\CE\EBTF\AB\B5R\A9\A5\9E\9Dt\CEt\C1\86\BE\E3\CF:\89\D3t\E8\C2
^\87\E8\83\CE\CF\F2δ$\F2\96\9B\D4N;!\EA8|%\EB@̄\8C\92XA*\98\96\8A\E8i-\EE`\C1so\86\A2\C2p\AF\D2K\C6}\920l֐\C6+\882X\80\B4}Ҍ\99vz\CD*\D4\D4:\v\B0\E7x\BE\AF\C6&\98\E3[\AB:\FF\FF\D7\EC?\9D\FFC\EC\F8e\AEC\B2Rڵ\BB\FDkA\9D\848}\FA\94\ECʗ\9D\CB򐜶^\F0\D9[k\F0sJWU\F7V\D29[\AF-\84 \87(\81\CB .\DA\C0\D7\FE\B8ݠ\CCuB}3\B7\A9\93\9Fxӂ*\84\FEzX\D5i\CD\87NH\D1\C4˦N\A0S\E9\9D_n]\9B\D8\F8\B2\CFz(\83\FD\94wŦyp\A8U\E7\E8"\A2k\CDlhi	\B0\B7N\81\D5yp]\92(\F5\86\EA5\80]^\8Fd5\B95\93ֻg淤\ED\E0\E6\AA'Ŵ\DAFB\A5\A3)\C0~\B8G\9BpH\E6\A3o\A1Q\F3	+\C9\C0\B4\AF\B2MZ\BF\EA\8B%\BE\8F\E8R\D1T\B8\D0%\D3\D6\E9Q\9D\EBkZԒij\AA\83J\B7A\FD@\FAj\95jA_!\9DȢOGK\8E\9E\D1rQI\98;\B4}.\88Y\90/a㤺\86\84L\87\FA\B0%\FA\9A=^\CD
YH\F4\CDg\85Nҏf\A5\8Eqp:Xe\CD,\C8\FA\AD\A3\C8Zq\EF\9DGӡ\DD[_m\B3Bx\94A	\F7\DB6yT\81kip~\C1\A3D\83$\AE\9FU\C9t\F0\8D[\ACQ\CA\00
fZCa\8E:\8Box\84\BC\B9\AC\AD\97w\86ۀ\CE\BC\EA.QGz\87Xep\E6_\B1"rfUT\88\BC\8EJ}\E8\C1\D7ٿ\E8\9FhL\E8\A2O\DF\CEP\85\EC
\BAH-\82\FAZ'\E0t\A2\8Es\AD E\E6\A0-\94\F1|]׾\AEN5\C2\FD׷Fyc\BF\96\F5UR\E3\DF}5\C1\FD\9B\EF.\BC\AFJ\00V\BE\CCaAg
M\DF\E8Cx\D00̛0\A0FB\A2\FAc\CF21Iu\F6g\A0\83DM\881\88ġ\BD8E\D0?
\90F\D8M!L\D1H\D2wT%\8A\B55\C5Դ\D8l:\D3N\A1\00\F4\F6\B4\AAhN\98\8A\FA\D2\EE\99Gb\C2\C5ښ\A5\F7\A9\F7\8E\AAa\FD\E0\96\4\EE\AA\E3:A2p>u]\A3\E9;7
|FJ\BDmXt\F2\D6\E6\91\CE~&\EDP\8BN\89\AFkS'?\FA\DC\AD\9A\84\A7\D2\00\ADet\F8\B6\EE)zH\92\DA>(}(\A6\C2\82pцAB\ O\DA۸\D3\96@4P+\89\CB'\A4Gjk\82pg\A0i\F3;\EEH\95hs`\83\AB\E3א\C5\F8\D9+\A29d߀X}\A0e\E1\FD\AD/S\BF \C2\ED\A9\E2\A2Ћ\BE]\D2\CC\C84\BA\BC
\A8\87[I88d\8Ap\EB+/\DCA\CB;nbZr׹Y.\87\C0>\D0\FE<)lQ\AC\85h\8FllI_2\E8ՋzLZ\A0\E6B\DA\B5G\B3\FAF\80ᆑ\B26ޙ\9A\BC\E9Ӡ\E5\BA\EB ̋\88N:*\8BW\8B`:\BC\A1Ư\B3\AB\A4a\FFZC\FE{\B77\B5Bm$\B2\F5%L\B7kZ\FA\B8\C0;zQ\EBl\DA\D2@Fd!<\84M\A0\EA\F5
\9F\A3\AE(u\A2Wt\E6|k%\DA!\82`\B6\F6\B5NA\F3n_\AD\EE"Iu\F8+j\D5,h\EBP\EBH "
RD)^\85\AC/+\A0\E9hq\FCO\B8H\A5\F1\C8]\FE	G\90\8D0\9D`\EF\ECC\D0")z\C7\B14\8F\C4\CA\90m\AAR\DF&\ADC\E53;\FA\FE\91V/\B0\ACC\BB91J\88H\FE\E9|+B<\94\E1\F7I\FC\8F~\C9Af\EAX\86%G\A2kң)`\P\AB\F8"*k\FBykOv\A1\99\B2&\B2K-\C19
\96\83\D3QA\C5鱼|Q\A7}\00\92Ea\E1\00
\CE\:D1=\ACt\81p\B8R5\9E\BC\F5EԳc"\D8\E8%\E1t\F4ldh\84\9D\E4_\F4վ\F9\A7\AF\FD\FD\E9\D1\FD\FED\BBZ\C0\E2\85\FF
\B1cƆM	\00\00\86iCCPICC profile\00\00x\9C}\91=H\C3@\C5_SKU\AA"vq\C8P\9D,\88\8A.R\C5"X(m\85VL.\FD\82&
I\8A\8B\A3\E0Zp\F0c\B1\EA\E0⬫\83\AB ~\8089:)\BAH\89\FFK
-b=8\EEǻ{\8F\BBw\80P+1\D5\ECT\CD2ш\98ά\8A\FEWt\A1\BD\F0aVb\A6K.\A6\D0v|\DD\C3\C3׻0\CFj\EE\CFѣdMxD\E29\A6\F1\F1\F4\A6\A5s\DE'\B2\82\A4\9F\8FtA\E2G\AE\CB.\BFq\CE;,\F0̠\91J\CC\89\C5|\CB-\CC
\86J<ERT\8D\F2\85\B4\CB
\E7-\CEj\A9\C2\F7\E4/d\B5\95$\D7i#\8A%\C4\87Q\82\850\AD)&\B4i\E3r\FCqr\C9\E4*\82\91ce\A8\90?\F8\FC\EE\D6\CCMN\B8I\81\E0{\B1\ED\8F\C0\BFԫ\B6\FD}l\DB\F5\C0\FB\iM\B9\CC|\92^mj\A1#\A0o\B8\B8nj\F2p\B9>\E9\92!9\92\97\A6\90\CB\EFg\F4M`\E0\E8^s{k\EC\E3\F4HQW\CB7\C0\C1!0\9A\A7\EC\F56\EF\EEl\ED\ED\DF3\8D\FE~\00\8D\E8r\B2U\C6,\00\00\00bKGD\00\FF\00\FF\00\FF\A0\BD\A7\93\00\00\00	pHYs\00\00\00\00\00\9A\9C\00\00\00tIME\E4		5\D3\00\00 \00IDATx\DA\EC\9Dw\9CeU\95\EF\BF{\9Fsn\BE\95\AB\D8H$\99\90 \B4\A8`\98\E1#\E2Ƨ8*6\A2\A3\C78μ7\FA\9C\E0\F39:::\80\A3c\C08\EA<\91؁&\D9d:TwWUW\BA\F9\84\FD\FE8\A7\E8Xշ\AA\EE\BDu\C3\FA~>\A5(]\D5\DD\FB\EE\BD\D6o\AD\BD\F6Z \82 \82 \82 \82 \82 \82 \82 \82 \82 \82 \82 \82 \82 B\93\A2d	AX,\CC\85\85QgadE\A1qhYA\C5\F9߆^\FCp\AC\D9 \89 H@\84\F6u\FCQ\94\C8\E2\F3\F7(\DE\F49?D\F19b\8C\A8WH6@D\00\82\D0>\CE\FFv|x'p2\E0\EC\F5\AF\E0Q\E0J\FC\83:\9F\A2\AC\98 \88\00\A1\95\FF\92\F8\\00\
\BC\9C\E9\97e\E0V\E0G\D8\FCR\9DIYVPD\00\82\D0J\8E
1\E084\97\E7+\E7\F0\EDO\B7?\C4\E7N\F5*J\B2\A2\82 @\84fw\FE\EB8\F8S\E0}\C0\B1̿\E8\F8qWc\F8%\9EV\AF×\D5\00\82 4\9B\E3_\CFahN\C3\E7c\C09\80]\83\EBc\F8'w\A8s\D8*+-"\00Ah\8E\88?\81\E1\C5(>\\C4\EA\F0\DBT\80\9B\D0|\C5\EF\D5Y\E4e\E5A\80 \8B\E5\FC7\F0||>\00|H6\E0\B7̣\F8\8A!`\93:G\9E
\82\00A\E7\F8o$E\9C\F7\A1\F8_\84\EF\F9\D9\\CC\00\E3\C0)q\85:\9F)\F9DA\80 \F5\F4\BCb1ɻ0|\84\B0\9B\9F\B3\88\9C2\F0$\86\AFR\E2\EA\\F9\84A\80 \B5t\FCkP(^\8B\E2\BD\C0@w\93\D8\94\80_\A3\F8!p\8Dz\A5\\82\00A\E6]\EF\C2\C2\E5x\97\AFNhR\FB\E1[\81\FF\C2\F0*lT\AF! "\00A\98\9B\E3\BF\8DO/p	\86\81s[\E5\8F\AC\C7p=>?F\B3M\AD"\90OTD\00\82p(\BA\9E^g\A3\F8\00\86\F3\A9ϳ\BEz\00\D7a\F8!p\83:W
A\80 w\FC\EBHG\A0\B8\C3{\80\AE6\F8k1\FC\CDWP<\A5Ζ\FE\82 \A0U\8C\F2-hISj\95\DCk
5\DEcףH\B3Ż\80\8F3\F3\C0\9EV\B6x\A3\C0\BFW`U\E7H[a\A1sѲ-`\987\90\C6\E6Bln\C7\E1A\9B\9F\CBg'\D4p\8F\DDD\92$o@\B1\F8\A7\B6t\FE\00\86~\9F\C3p\F0V\B3\9E\B4|\FA\82d\00\84\E6\B3U\9B\D1<\CBi\C0׀ӀT\F4\AF*\C0\CD\BE\00ܭΕl\800\CF=v\9A)\CEF\F1e\C2\F7\FC\C9\FA뗀?b\F88i֨\97\E2ɎD\00\8Bo\98\D7\F3"\9F"\A1\BA\E4 \9F\95\EC\FE\C3W\81\C7Ds\DCc'c\F88\F0F\C2.~\9Djvk\D0|\893\B9Oi9G\82\00a1\8C\F2Z\8EB\F1\E0\DD\C0\F3\81\F8!\BE\C5\EE\AE\C7\E5\A4U\AF&\CC\EA\F8\8F\C6\F0N\E0\ED\C0Ѵfu\ADq\81-(~\8C\E1ju\94%D\00\8D1ʷ҅\C5\C5(\DE\ACbO\BA\BF\AAo\8F\84\C0u\AE%\C6O\D5dU\85\E76\C8:%\D2$x᤾\F3\AA\97\9DH\B8\F8	\8Ak\D5+\92%D\00\B57\CAQT\B0\F0\B9\00\C3\EB\81\F7\89\FE\D8a\D7\00?\C4\E7\B5J\84@\C7ﳻq(\F3z\E0
\C0{\C4\F1WE	\F8	p-y\AE%\83/\AD\85\00Bm\8C\F2z4\C7\F0f\AB\81\C3j\FC[<\8D\E1{(~D\C0\B3j\95H\E9\B8=\B6\86\C7\F0gQ\DF\B2*s&\8F\E1\CB(\AEA\F3\90:[
\00\C2|\8D\F2Z4\8AL\94\EA\FF+L\DD{\AA?\8C\E1\F3\C0Zu.#\F2	t\CC\EB\C2\F0v\8E\91\B3\BE\B0%%\AC\F8
6W\E31\A1^)\FD\00\C2\DCs8\C5\DF\AFn\E0o\ED\B0xX\AD\A2"\9FF\DB\EE\B18\8AӁ\FFM\EB\F4\EDo%!p'\8A\CFaX\A3Α\AC\9A @8\94ո
\8Db\8AAq!\8B7;}
\F8
\8A\BFU\AF\E4	\F9d\DAh\8F݀E\8C#\B0\B9\82\B0\C0ϑU\A9\AB\A0\BE\C5'\D1\FC^\9D%\D9\00A\80p0ü\91>\F2\FC#\F0'(V4\C1\9A\FB\C0\F0\BE\AEV\B1S>\A5\DFcw0\88\C7\E7\81\A9}-\890s6`\8A\9B\F1\F9\E3\AB7I\91\A0 @\00\CC\ED\F4p	\E1{\FEXxu\AD\C9vA\BB\C3O\D4*\99\92\D6r{l\FD\F8\FC\F0.\C2{\FE\A4\ACJ\C3	\80\87\80\FFB\F3
u6c\B2$\82\80N5ʷ\91\C1\E2\\E0\83\C0\CBi\EE\9E\EA\C8\BF\C1\F03~\A5^%3ӛ~\8F\AD#K\C0\B9h>\ED\B1>Y\95Eg\F8\F0=4\BFQg3.K"\88\00\E8\A3|\9A"\A7\A3\F8s\E0ʹ֓\AB\80\B0\EA\F7\81X\A7V\89h\BA=\F6(\8A\CEF\F16\E0-\BCE\B4\B0\B8\BF&໔ب^'\B7\82\80\F66\CC\EB9	x\9F\8C\EE\F9[uR\9F~\\83\E1)u\AE85\C1\FER\C0\C9\C09>\ACD&y6\FB9ڂ\E1k\C0\AD\EA\\90%D\00\B4\9BQV`8\C3ǀ3\DA\C8(\E0V\E0
|n\C2aJ\9D-N
\FF֢P\F4>\FD(\F0
q\FC-E\00<\86\E1\EF\F0ـ\CDNu\8E\9C#A@ke\87\97E\8E\FF"\C0nӿ\AE\87\E1\FFa\F1yO\AAWR\96Р}v+6/\89\F9\\DC\C6{\ACp1\|\C5Fu\8E\"\00Z\CF(\AFC\CF\C3\F01\97\D39SԦ0\FC\97\CF0\C9n\F5f\89b\EA\B6\C7\EE@\B0\9FϠ\F8\002\A9\AF\BD\84\00\\8D\E1\EA\6\CBr"\00Z\C70'q\F9(\8A\8F_uZ*\D6\00O\A1\F87W\A9\B3\C9ˮ\A8\E1\E2nD\E1\92\C2\E3c.\83\A6\E8!Ԟ\00\C5p\F0\CFXr\BD&\88\00h^üx?\86K\80vX\EB\E4u\9B\FE|\87\9F\AB3$\9DY\83=\E6`xp	pZ\F5\CB\D9lo<\E0~\E0'\F4\F3
u\A2\B4D\004\8FQ\BE\CD*,.V\BE\E7\97\F5\DA\C36`_'\E0nu\9ELI\9B\F3[C\CDy\C0j\C2"ҥ\B2*\9D\B5"A}\F0#<\AE\95s$\88\00X\CCy'%\8E\C6b5a\F5\F5I\B2*3\00[\81\00?W\E7\F0\90,I{\ECV+\B1\B8x-\F0BY\95\8E\E7q\E0f\E0\FBP\E7JF@\D08\A3|
\87\E5hތǻ\81\97\CA\FATMx\8B\ABЬQg\B0I\96d\86}\B6\8E#	x\9A\BF\88ĥ<\EB\F6f#\F0\9F\FC\9F\EA\D5R \88\00\A8o{#+T\9Cc\B8\C3k\D0\C4eU汓|*\C0\AF\F8y֪\99\90\85\89\FFZ\96aq
^\83T\F73\E3a\B8\F8\8Aߩsd`\97 \A0>\A1\EB\FF\A2\9B#\F8\A4}\A5\944\C1]\C0nR%\9FR\AF\E6\E2\F8\89\A1x\86ˣ6\D12\B0G\A8\96\8A\EB\80ϣ٤΢(K"Ԓ\8Eo.b
a\E77\B3\92\E3\B13\C7SԐ\92\A4\ECB\94I\l^\DA\F1\CE\FF6\96\A3x;\F09]\B29\849\92\C0\F0\E0\D5|Ŭ\E3\BB\C0v\E9&(Ԋ\8Ewu\96\C6$\E2<\85\B3\F9\BFIM>IMEr#s\96\929\CA(hRd;\B7\88\C9\DCKܬ\E5=X\DC|\C4\F9\A2\C3\FF&|6x\99YGJ\96DP#b\D2:L\87\8C>Jr\CBo\88\B6\92!ph_\87E\99e|R\B8\C4pP$\00\AB\F3.R\CC\E3h\B3\9E7\92\E7&W\CB\E4\8C	5B>E\FEg`\8DY\CFE\E6A,Yaaq\9B*!=6\8C\B8(7\C3\90\88oAu=\9Frj9Ha\E0~\D2\D1Ŧ\82G
\83A\A3\80\87Nr\FFѴ\BE\B3\D8ɥ\C0\EB\81~q\FCB\9DH/\C5\F0]&\F8\B5Y˕\C0\ED\EA\\B9D\00,H^g,\98\F0\C05\E0\97\B1
\DB\C1-`G	\BAǳ\BB1\9C\8Ew\FC
X\F8\C40Q\D9{9\9D`\8E\CC\ED(\\8E\C4\F0\E0\8D\C0\89 Q\99\D0s\D5
\BC\C5K\80\FF2\EB\F8\A9\F4\E1D\00,0\D0\EB\C0HeO\00\EB\8EcM\8C\A3+\E3\F8\C9\C3Q]\CBpu\D3a\9E\C6c\BA\CE \C0\C2\EC\E5\EC\90\EE\8CeE\B1\9B\EF\C6\E2
Q\D4/\97E\C2b\D8\EF\E3\80O/3븖
?F\D5k$# \88\00\983)\E5}\8F\8F*\EE\C0.\EE\C0\94\96Q\C9\83\95\EA\C1Uq,\826\8A \8A\F1}}\FB\A0\E9\FD\F1\B2ݬ'\CBga\F8\C0\9B"\D9#\8B\89E\D8[\E2U8\BC\F8\A5Y\CBM\EA\
\B24\82\809\BAa`\D8\FF@
\AD
;\88wB\F7q\B3G\B3\A0\AC\BD"\E3\F6q\FC\D04\F1\E7R\FD\FE\DA\D0
\B6\B12kI\A08\F8\00\C8i\9AN(\DE\\84\E1f
_6\ABU\94ei\84\99\FC\9D\B0I\B3\B8sc`\FC\A4\B7݂=\B9\8Dr\E0Q\C1\B4M\CA-\BC\D5\D7\F88\F0\B1q\A3I3\91\85v\AD\8C0\BFE\995\00܈\E1\93\E2\FC\85&'\83\E2r4\BFA\F1^\B3\96^\B3VjS\00U\BF\D0\E5\80u\88\98>\F0P\A3In\FD-va'et(m\8B
\B2U\ED\A0myn\EE$A\82sѬC\F1m\E0\F9r:\84\E2\F9(\FE
\C5\C0\CDm҅RP]@C֪ίye\AC\9Dw\91x\F6Fw\82\K6\B6(\E3P\C2`S!MP\A5K\EF\A2\ED.\92\CCm(\B3\9E\93p\B96j\C5\FAB\A4\C8Oh]\8EG\F1S,n2\B7q\9A\B9M\B2\82\80C2]X\95\D3\C0\9BDo\BB\9D\D4\D0\B4\9Bo!\A0\F0\89\91\C7`\E1'\98\83q\88A9\82\D6r\FE\EB8\9B+1\DC\9C\87\F9	m\D3\00gaq\9A\FF0x\81,\89 E\80\B3\90А\B5a\B7[\FD\B3\F6\A0\8C.\EE\84\F7\90\C8,\83\AE\A3([),L\93\AD\B5&@S\C4'\F8Y\B3\DE\F3L:\A6\DB'.6kY\81\E2πK1
$\E4m\C8
o\C3\E7\A5f?F\F3u6[dYD\00\93\CD\FD\B9xpǰ\C7\C71\A5<Vf)Af9\AE\B2\B1X쬋\C2G\E36NT\F27\F7}'\BC\FBou\C76G\93\FA^\D5+A8\E4\E9=\F84\E7\9Au|\C3
\EA\\C6diD\00{\D3a\87\C09	\80i\E7bP\C5g\B1K[\F0\CB\C7$\97`\D2K\A8\A0\885\FC̀\8A\9E\F4M\F78
_\F7\CF\EF\E5\BEE\D8\F5\AF\85\A3\F3\BB9\C5kQ\\DA^\F9A\A8\8A,\F0Z\E0\E5(~h\D6\F1kF\B9Q]\84/K#@\D8+\90\B1 7\CFca\D6\E4\B1\F2\9B	\DC\E3\F0\92\CBp\E2|VC\9CN\F1Q\8B^\8D\BF\C0"\A0D$\00Z\D1\F1\AF\C7ư\92	ތf5p\94\ECp\A1\C3\E9.\DEI\FFh\D6r\8F\AA\B3;o\A0\97\00\E1\C0ER\90\B1!\EF/\ACŽ_A\EF~\98\94\FD8\A6\FFt\8A\C9n\D2\DAyN\D4^L!Z\94\F1\89\E1\D5\E0\F3vZ3V6k\D0h2\C00|8]"~A\D8\CBZ@\8A/\EF\C4\F0/f\BF\C20\A9\CE!Ю\C8+\80j\83^fj\81WA\ED\Ovh
\94\F3\AF>\87I4\E0\92"\A8\91\D8KB\AB\CDE4k\89\A1x9\F0?F\F1
q\FE\820\A3O8\C3w\80\9Fg\9A5(\8A\00\E8\F4\85\8A\C6\D7\D2k\94s\E8m7\92\BA\E3W(\D6\E4٠\C2\C3!\87C@\85\FC~\C6-\FD\9B\8Dhs'\CB\D1|ŭ\C0\C4\F1Bվ\E1|\B7\A2\F8\81Y\CBJ\B3N\FC\85\80Ǝ\9A՚\E2.b[o"1|\B9y\B9(\85\8FM\9B\00\974n\9A}di\99K#\B3\9E,\FE\97;\A3\C1=\D2M\E6#\FBoG\B1\C3W͚v\EB\FC\D1\E1>M\96`.>6T\C0\ABq\BF_F\E5\B6a\95\A7H\A6W\E0\F7GUU\BCmp(`\E3?Wկ\EA`\C2\E2\BF&\8F\9F\CD:\B2\C0\BB1\B\D8\C1O\9E\F5	\C2\C2M\DFa(>\88\E2ts;?\AEPg˴A\00\86\D5Lx\D4\FC%\9F	P\95q,/\87)M\EF^\81\9FZ\81Aca\92\AD\B1)b\88\8B\F9\A9\BA\FF\9E\E6\DE-\E6V\E2hN>NX\E0\B7Tv\AB \D4<8\9D\80\95\C0\B9f\DF\C2\E6u&EY\00C\8F\C5\00\CAu\AA\8D
<TqNe'~*\99~\FC\E4 `a\00/\FA\E7pXoP\E7\B8<}5\A3\E3߈"ϋQ\BCx+\F0<\E4\9E_\EA\C9 \F0\A7\C0\89\F8\g\D6\F0,R\AFĕ\A5\D0\F6h\C2Z\00π_ǆ>~k\EAQ(ظ='c\FD\F1n<@E-}\EA_\8F?\FD7\E1\F8\B3\81)\F1J\E0\C3\C0\F1\CD\F9\A7\84\B6e%\86\A3y=\9A\AF\99۹Y\9D\CD\E3\B2,"\00ڞ\E9\BE\00\C5t\F4\F3=\9C\D1\FB \B9\94ʲӨ\A8Tq\92\CD\FD\FF\C1\A0\8E\BB\8Be\B8\BC\97\E7\A2\C5\F1\C2"\C6C\C7\E0\F2U\E0ns;_Ds\9F:\93!Y\00m\BD\EB\BBlp\DD\DA\CE(&\D1~\C7nT>E8\EA+?\C1r\F7\FE\C9\EE\E6J\E3`\A0\E1m\95A\D8\DFV8(\CE\C6㗸\m\AE\E5s\EAO\D9&#\A0mIZ\90\F4a\CAo\CB\BE\F9o\B2\BB\A7L\CF\E8͜\94=7֍\C1\93Ah
\9B\E1a\A8p2= \A0Ya\8B\97\B1×m\87E\FF͆\87Iz\C4\C7ב\DAvڝ\A4\CD:aq\80f\92	 O\85\963)\A0#\88ש9PSD\FF͘2\90\B2\C2\D6̕	\AC\EDH\EC\BAe\CALE\D3Ah\D4i\B4\98"\8C\92\C1\C7\C6y\CEn\C8Yl\E4
\A0
*M
\F4\DAe\CB'\A0\D9\FB}\A54\94,T\AE\F9\EDP)\90L-\81\9Ec)\EA\F1\83\F6M\A1\82\8F£\80\83K7\92\DE\F1ȣ(q\FF"\00:\88\84{\8CT\DA$\FAO\D0\F4\B9![Aڂ|\00Ơ*c\D8\EE\94\8B\D8]\CBQ\A9e\A0l1D\82PC\DB`Px\94\81
e&\F2!*\00"\BB[.\80j$b\ED\B0\9A)Z\A6ynBC\D7^\D7/&\80\E2\B38\BB6\A2\C66Aax/Q#\C2\FC\83M\8F\80\90GS\C2ާ\F3h\\C2I\00L,\9A\D8\F2\BB\A1\FA\FDOc)H\EB7\B1\F1a\FC\D9\00OCeJ\F6\A7 \CC\D3\F9{*\F8\E4\81<\FE~}7Tk\D9
A@}\82g
\C9V^\D1\CD?3O\EF\D3ǭ\B0\C3\C1\F0|\BDv\DD
\C5\A4Q\A9 T\EB\F8
\86\00C\91)&H\CE8a4\89\F4\E0 h\D6\B4$v$\00\9AxG\98\87Q<\9FÈ\91\DE;\F8\C8Z\B3?ŬL\C0\D0:ع!l\DCd\A4.@f\8F\FA%\F2\F8\8C\92\9Du\B4\B8\864$D\00\B4	\A7\B5d\F4\DF\C4\D9\DCG\8AI.g%?\A3\97\E7\ED\A3]4tWq\FDR\DC
[\AE\85\E1{\A2l\80\A4,aߨߢH\97a\92\949t8\D3\C3\C2\ECq\9FP\D33\BD6}Zi\A4\9B\D3!\9AG\B0\E3"r|x1q\EC\FDg\8E)B0\E5\81[Et\9F\DB\85\C8}/e!\AF\84\CE\C6"O\87\89\AA
\97	\00A\80\B0\87X\94h\99\C1\D9\E6\DB	f=
x\BBY
\BC\E8\F4Lo\8C\D0\ED\C0h\A5:_\94aj\94F!}\F4\AC\94\8C\80Ёъ\A6@\818e\92x\D1C\BFj\BF7.gF\80pPz(P1-\B0R\CDs\90\CD\EDh\Vb\F8p>\E1\98ߪ\92\8CYrJUF0\81\E5\F0\F2a\9D@v$W\C8\DE\DA\DE\F1\87\EF\F9= \87CM0G\E0H\F4/@\98\F9|\A8pXP\C5k\F2\A0\97\A6\A8\E05\8F\A2\A5\9B\80\F7b\F1༹\CAt[\E15\80?\E1\E5!\B7J\BB S\84\EC 8\DDȵ\80Ў\CE\DF\C3'\A0\8CEx\D2W
\9A\A6&\88\00h\CE,\80\81R\B3^84E\E1\9FYO\BB9\B8x=x\8C\98\B2!@ak\EE`\FCA(f\A0\EBDH\F4\80\93! \B4\89\E3\00C(/@\F67\89\DDD\0045a-@%\80\A0ٜ\88zX\D4
^\B3\96\8A\A3\80\CB0\BC+\FA-8\A9\D1m\83TWx0\CA9\BE\D2+\A0\EB\88e\C1\92\88GhM\C7\A0p)aQ\`\ECn\89\F3 TMFCQA\A1\D9@\9CE\BB\C337\A2\88\B1\B8\F8,\86\C3j\F9\F3QC&w\81\99\97\FCv\C8A\F6h\E8=,\94<yZ	\80%l
5j\F1\E5\88\D7 T/\98dm(\BBs\BB\97\AE{j\A2k\91\ACҝ\A4\A8p.\8AoGQ\87\F2Ct9P4a&`\A1ft\EAI\C8==GC\CFɠ\E4J@hv\E7\AFq)\90'US\BB!\95\FF"\00\84\B9G\A4)+|\A7\BE\E8(\C2\F6\A7\F1\CCm(l^\8A\CB?\A3xY\BD\F3\8E\82\AC\86\B1\A06W\F8&\80\B1'`\FC)<2\CF\DF'\CE\84\E68ۚ
*\8C\D6a\A4Wi\F9+@\98O c\85\85i\8B\9E\98n\FA\D3H翎Q|
\C3	\DF\D4=\91\AEsAX\83Q\B3\BF\8B\C3\C0\F8\93\D0w"\A4\96#\F3υfp\FC%*@\9E8N]\ECFL\A2\00¼\88\ABpt\ED\D8bg\D2
\8B\FE\B3\96~\97\81\E1\C8F\E7\A6'4Wj\EB\9FM\00\95IyC\D0u$\FAD\8B\80\A6\82\8F"\87\83\8B¯\93\8Bn\F29!\82\80\E6>\A7*|0\E9\C1\A2\BD
LҨi\8FW\00\DF.`g\C6u؏\A1P\87E\F7r\90ˁW\84\E4Ұ\91\90\9D 4$\EA\F71\F8\E4Q\B8\E8Y\F6,X\CA#\A9\00ϑ\86^Fk,m":̍\D8W\86\E3P\CF"'
\9D(\F3R\F4\EB\E7\97K;\A3\AF]\90>
2\83\A0c"\84\BA8\FE\00\83K	(c\D7\F5\8C)\89\FEE\00\B5;K\D8x\8Dv\E9\E8 7\EE\AF\DA4\B7\85	
\BB\FEE\98\C5P\DC	\95\A3 }$ĳ"\84\9A:~\83\87\C1\C3'G\9CF\F4\E3\93迭]\D7\E0\9B[[A\9F\D3`\EF8\AD\E2;\F4 \EB(А570\F94\AD\85\C9g\C1͇\85\83\820\EF\A5"\D7_\C6e\9B\\83\A4\FC\F4\8B!)\FC\D0Ƹ\C00а\F2\BC\B4Nl)\DB\F4\A7	#ޘ\86.\BB\B1k\B0\FBA\D8v3\E4\B6C\C8A\E6\E5\84+\B8T\C3&G\A2\A1g+\8E\E4\88E\00\B4\F9\F9\BA\8AI
\AC\C6\F0d\A3\84u\B7\DD a\AD	\C7\FD6J\C5\88z\8D7\99
@\A37|\E0\C1\F0\EF`\EBo\A14,'N\A8\C5\BBq\98 N\D0\E0\9D\A3\91i"\00:D\I\CD\F7Ir\F0?Q\8C\D5;\8E\CDXa=@\FD\D3
4\A6\F0o\DA\F1h`.en8\AA\C1Y\80\BD\F0\8A0t<{c8zXҪ\C2J5@1\C9nlF\C94\DC\F1O\ABei\FA#\A0\A3\CE\DD\F8\EAk\8C\00\FF\C5\F9Q\ABں\D6\EBg\ED\B0&\A0\8EQt\D7\D9٘h\95\8A\D17y\C1[\8F\DD\E0뗽\97\CAov\DC	;\EF
\EB!r\BA.P"\87b\8C4\E1\ED\FFb`#D\00t\E89\BC
\97\80{\B1\F9\EF~F\9D\9E\EE\A7t\9D\B3\00\99:\C2P*@\8B\DCqki\BD\B8\B8W

\DF\E3\BF$箃\BF\8F¥L\E2PB\E1/r\EC\ED\88g\E8\A4\C4\E3\E0"\C0\00\93\E6C\FC'>1l\C0\F0\F6\A8\87}M\EA\D9h\p)\A8\C3'\9B\AD\D3\F9\D1WD\FC\CD8P6\F5iT}: \ECP\86J\92\90]N\98\B5\91g\83\9D@8\B0\A7\84\C6EQFc\9A\C0\ED.\E2\94PA@s	\81ob\80M\C0\BF\9AK\B9x+\8A?\A6M\F5\C2\CF[ԩ\AE\A6@\D7)\FA\F6r\FC-\ծ_b\94\83ş\CD`\E46Aa\B8\C7Cr$zd\ECpG\FCᥙ\87MC\BD(\F7\FC3\D9
\A9O\E9 \C4\CCT{n\FF\9D{\81\BF\DE\FC\A9\D5\CF\CEX\E1\FC\FA\9A\E1D\A0\86\D1*{\AA\FB\DB\E0I[\C6
\85W\B3\00\E3\80\E1;`Ꙩ\80d\DA+\E2W<*L\A1\C8-Bu\FFl\C4hDk!A@\8B\8A\80o\A8\ABXC\C0\C5h.#,[\98\BF\8E\E6\A8Z(o\8B0\F5_\ABO֏\9C~\89EbP\9F,@\C6
׾\99\F0*0r?l\BF
\8A\E3\E13B\B9h\E7>\862\93\C08\99\BA
\EDY\88'\90i"\00\84\AA\B2u\BF\C2p6\F0`h\A1f:m\85-kL\9Cڍ\DE)G\F2\C6k\CF\CF1\A9\F4s>\BA\AB;n\83\A15P\C9əka\A5\E9&1\8C\92\C4kR\9B\9B@.\84E\00s\CC\EC\BE\BC\F8:05\EF\C0]A\F7B\DB\D5Z\84\A9\FF\85\AA\F8p\AEx\9DA6\C1秚3\B0\8F\9B\84\AD\B7\C0\8E
\A1(\90\DBB\96\D5"9\FE8n\83\C6p\CD\D7nH\F4/@\98\87\B9
\A3\AEb\F07\C0*\E0\97\F3u\9Dq>
\9C\81\85\BD\DFu	\F9T蘴s\C3[χ\00
;aۭ0r\AE\EB&\8E\F8\C1f\8A<\A3\A4q[ \AEN\88' ,T\E41\DC\BC\B8X3W7j\A9p\\B0\9E\8Fq\B7\99\FF\E0\8E\80\96{\CF_K{\9D\B2\C2Q\CD͎W\80ܳ\B0\E3.\98\F8cT$(B\A0Y6R\80\A6\8C\8B\CFn\92\A3\FE\A6\C9?!\89\FE;\B9\F5\A9\A5
\F87\97\F1s<\EE\C1\E2\C0E\84W\D5} :\EC
01\D7{\F7\EC<\A2\FF \8A\FA\FD\CEs\FC{\E3(\E8\B3aW\A5\F9\81\CE\A8\8CC\A5\99AH.\89\A4\BC.\86\E37(<*\CAXTP-\D4D7)a\A0\00\A1\B66\E1J<`\93\B9\8C/\B7c\B8\B8Xv(\AD\AD	S\D2S>\D5\F4\F8\9D\FF\F4{~\8F\B6\AA\EC_	f*-"\84\A6\FE\F9\CD\D0}<$\FB!\D1+\9FcC\D1Tp\9Fk\E4\A3\F0Z̞NG\FF\82\00\A1nB`\8D\F94\EBgc$^\B9k5[D\DAcØ[eP\97\A9\F2 \9B\BD\BF'\9F\CF>\B6P\C1\80C\E5\D6
\A4\83
\8C=\F9l(\E2\BD\CB\C8\E7Y\E7\A8\DF\C3G\E3P@5u\81\DF\CC\87\DA-\AEa\85\FA\9F\B5\FFC\A0\AE\E2\FB\F8\FC\8AO\00O޸\CFH\D6
\AF\BAR]\EB\CE \FAK\E2\FCg"\AEkܐ\A9\81T\A6±\C3#@y,B͝f\00\CA\E41L\90hI\E7?\FAI\F8'@\96\A0\81\F6\E3۔Օ|\9B\F3P\FC\E1\B3\C1`\A6\88\B4\FBPCk\D0\C5\ECM\89\F7\9F\D6'̺\9C\BDNk\8A\D2.ضv\FD<i"TKe
\B8\EC&M\A5\85\87\E5j %\A8 `q\CD7٦\AE\E4\D3\C0Y\C0\FF\8B\E2\F2\C8\D8\9F\CD\CC$\99\FD\EEߋY\C1\\B2\00i\AB\C53\A3&|6\F8\EC50\F6H\F4\D1K\AAw\BE\AA\D0`Qƥ\C40I\8A-~k\AE\AF%\FAD\00,\F2Y\BC\8A\87I\F0.\00w\B1_r^\AB\F0*\E0\80\C1*\FA\EA\9E\C1\B0O;\FE]\DD?_z\B0\DB\C4a\8E=\CF\c\8F\8B\98\87u,R\A2\C2q\A6j\D6_sq\B1\90i\82\80\A6_\A3\A8\AEd\86\B7\EF!\9C>\F8\\BC\9E\D1\E1\D7s\91Oq\E0`\E2\E9\F7\FCe\A4\BA8
Rm!\98\F8\AD\87ܖ\BDD\A40\93\93,Pa\9C8yb\D1\CD{\ACXZ\F8\F2BЦB\E0[l\C1\E1g(.\FEx\C2\E8?e\85\A9\CBb8@\CF^\DFl\FC\CAQ\F4/\E9\FE\D3U\AB\D9\CD"\A2\FEc\8F\C1\F0\83P\DA)"`?\83\CB$1&\B1q\D1m\E3\F8\89y\F6'\EC\85\DC5\93\F8\F0\B0\F9\00\9BQ\ACEq1\9A\8BҰ\B4\E4\A3\CA
\85\8D"\A9\F8\BD\9F\F5\F9\E2\F8k\9E\D0Pj\B3+w*\FC*\8F@:٥`g:|\EF(|<
\D8T0-ѾW\A2A@\DBf\A6\CCz\EEb'\C72\C2\C1$\9FF)L\9C\F0\FD\EE\DE\EF\F9\C5\F1ׅ\AC
e\F96\BCN\A9L@\E5(\F6B\F6XH\F6\81\9D갽:~\83T0\94\DA\D8=\C6%\FAD\004=f=	G`xK\B9\84A\9E\87\89.\B0'\D3x\A9\ECo\00Vt\FDR\F4۷\96\B24\A5\BB\A1k%d\8E'
V\BB;
E\80A\E1\E3Q
\C4\DB\DANW\FE˅\AF \A0\89\9D\FF:1\BC\F8,pf\CF\E1է@\AC\F9\FC\92\ACU\A3Hk(Z\90k\F3\A2\CAɧ`\EA鰛`\D7J\B0\9D6v\8A2%lr\9A\9D\D9!h_\85\00\00 \00IDATZѿ#gYЬQ\92\80Ӏo\A7p\B0\F2,$\A5n\AB\D1h\FD\F6Xa\8C?\93O@\FFI\90]I{e\99,\C2b\D9\DD$;&{\A68D\E3q\A1\A3\ED\9B,\C1\A2\e\EE\E0X\BF@qp\AA\D5\E6#\A6æL\9DB\E0\C1\F0\F0\F4\AF \BF5\B2\AD\BA+\D5^\FE]\C08\9DuuG
\FF\C9\004\9D󿍕\AC\E7S\C0\9B\809\A6͟\C8\FB\E0u\8A\F30`|\D8u/8O\C2\C0)ѴA\D5BToLҙ\F3/\A6[\FEJH!\88\00h\BB\BA\96>o>	m\D2a\AC\DD\8A;\8Etؐ\E3Ce7\DF\89>\E8^	\B1\EE&\FFC[\84\F759\C2\F9\9D:\FC*!\CE_\D0\86\F4l\92\BCş\E7YY\95\D6A\8E\AB\CA\EC\85;}\95!9\00\DD+@gh\AE\E7\D3ή@x\D7\DF\C9\A5\E5\AF \A0	\FF\C3h\C6x5\86ףx?2\85\BBum\AA\82>\86+\9D\FB\B3\B4=\FC\AA\EC\86\D4\F3 =z\FAi\EAb;\FEJ\F9\E9\ECJ\A2A\C0\E2:\FE۱0\C38\BC\C5\F1r$[\9F\E9\B6\CCn\87\F7`\C8o\85\C2v\A8<RG@<\BA\D1\D6d\BAa\BA\D6\D2c:\FA\8F\CB2"\00\EF\F8ס\F1\C9`x\86ˁ\B3\C5\F1\B7\9A(\E0B\D0\E1\CE\C60\B1	&\9F\86\FE\D3 5VT#\DEM;\98ǿ\CFM\8A\C5D\00,\86\F3\8F\A18
\CD'1\\84<\B3l\DB,@\82L\|N\8C\DC\96\FD/\87\D4\00\E8z\BEiQ\84)\FE)\C2"?a\D2\F4G\D0P\F8(\8A)\FA)\F3\E0\94T\F6\B73
趠\80/\91\E7s\F8.\EC\DA\00\B1,y9\C4\FA\A8\ED]\FC\B4\9C\9E\A0\B3\FCf[i\FA#\88\00h\A0\F3_O\86Q>\FC\87\CB\F1\EB\92\D2Ly\92}ޟJ\B6\AD\A7\96\BE\9C\EC\85\C0t#\9Fi\C7/~pb\FD"\00\E3\F8אD\F3g>\9CH\D8rC\E8\A04@&j\EC\8AC:\F0|\F8P\83\A1\DB!\B9\FAO\9B\A3\F3\9Ev\FCy\C2\E1W\9E\AC\EB\8CH\E1\9F \A0\86m1\^\81\E6\E3\C0K\81\B2*\9DI"j<&\F7\D03\F0\F2\90\DB^),\CC=<\84\B8B\BD\AAH\D4_\DDfk.\88\00\A8\9F-ۈ"ϩ\F8\BC\CD[\80#\90tǓ\B6\A0\E4C1\90\B5\98\F1\ECP\DC\A5P)\84\8D\842ˢ\DF\EC\E7\F8\89\BE˞w\FD¡\AD\B8\A4\FE\00u2`\EB9\9E\ABP\FC%p\AC\AC\9B0ML\85\AFD\00T'\A6\9E\80\C2\E0\9E\C9\C1h\BE\C0t\AA\DFeO#I\F7\CF-\FA\AFѫ\8B\E1	\CDY\F4\A4\CBz\E4CЩ\C6\EAv}\C0\99.^':[\98-\90P>0\F6(\E43\D0s$z\C0N\F6\EE\9F3GZ\ABTra\DB(\DC\F4\A0Ú\C7R\BC\E7<\8F׉\00\D0q\8E
\8A
\9A\80S\81\F7\97\8A\E3f=DQA`!\90\AB\EA\B9P\C9\C1\AE{\A0\A7\FAND\BAf\CC7\FA_\C0\BAS%\B8\EDaͧ\BFo1QY\C2\F1G\C51fH\D6V@\879\FFu(|\96\E7\FD\C0g\804r\CF/TA҂t\009\B9\B3\9EJ\81\B2\C5\F9ϋ\F8\C2,x`B\C7\FF?l\F1\F03
\A3l\FA\FBSd21\8C)+\A0\93\9C\FFf\B6p	\9AϢ8J\BF0\B4\82n'\BC\DB)\D4_91\81\81\9EV|\F1\97\BF\BD_S\8E2\FD}]tw\A7\F0}O\F6\B0\80\8E\89\FAm\E0\CD<\CB_/C\E7/̇Xt0%W\A7B#\A2\FF9\FEO\C1O\D6\DB\\BFQ\F3\E8p\A3\BAǶ\E9\EE\ED%\B3\00"\00\DA\DD\F1߂\C6\E6ீ\D7\00K\C5\F1
\CAz\ADpF\80\B4\EA\C6\F4\C0\9F9\B0s\AE\FF\9D\C5\ED\BFW\FC\FCNMe\BF\AB\AA%K\96\8Fǟ
ƈ)Ў\8E\FF^4y\96a\F8\8AU\84\CD|\A1&X:\CCLJ\8B`\A1^Ĩ\BAfb\AA\A8\D8\F0\98\E2\8E\C74_\BDN\E1\FA:v\C7qHg2h\FEPCmG8"\00\9A\C3\F9\AFg	.\EC9)=\EA\90\E8\B1\C3,\80\B4\EAb\B1\ABh:^(\C3\B6*\AE\DBh\F1\ED[5\BB\C6fدJ\B1b\C5
g\AF\87N&\EC\D9 \88\00h\C7
Y\BA9\97K\A8\F0z,\BA%\D9ߢ\B4\80a\B2dm\F7+\E1PT\96\A0juy\88
\A5\92\DBw+\EEۤ\F9\EA5\9A{\9F\9A\DD\D0\C5\E3qR\A9J\A9}>\F9HD\00\B4\87m\F9\BA\FC$'\AB\E5\FC<\D6K\85\F5\oq\D9\E5\ADg\00\8B\B4D{\D8.\F2>\94e\8F	\B5\B4։t\B1\81\B1<\F2\8C\E2\B3?\B2\B9\FF)uH\F1\A9\94b\F9\8AX\96u\C0A3!\89\00h|Ty-=\EApR\FE\89\E4\E2K\C8h\8DB\CBoI\DC\D6nZA\97
\BB])j\B1\A1+\FFb\B5\ߦ\F8\CC\D5\EB~\AF\A9T\F1
E)EWW\E9ԁ\F7	y\CA*\A0\8D\C8.\C7>z\EB\DDtYq\CC\C0\E4\BD$\91g\90BIG/\F2\D2HX(a\FA?6\EDP|\F9\BF-\AE\B9[3\9A\AB\FE\C7Y\96\C5\C0\C0\C0\8C\FF^\80\80\B6A\DA@ւ\F1jh\99\F4\FC\FE\93)Y,\8C\B4\FA\EA\B4e-(\92j\FDO*\BEw\8B\E6\C7k-\9E\DC	\EED\A6R\8A޾>\92\C9\E4\8C\CE_\9E\8A\00h;\D0\E3\84ј\EB\A3rCX\A5)\AC\C4\00\DE\C0\8B(\E9\D8L	6A\98?I\B2\C6]Ya\9E\EC\D5\F2\B7X\81\DFܫ\F9\E5\E1\9B\FE\9DSs\FFq\D9l\96\BE\DE\DEY\8D\E8U\00m\91\8D\85o\B4\95\97\83|\DB͡S\CB1\BDGS\C0"%0B-\85gRCN\81'VU\98\CFګ\F2\AA\A8\F8\FA\AF5w?\A1敦WJ\91\CDf\F7}\F6w0 \CF\00E\00\B4#\DDN8\B5\AD<\A7tUy˝\C0T\A6\B03\CB0\E9eT\D0\D2X\A8Q@\EF)\849\91\DE\D7J\94*j\DEw\F4}}}d\B3\D9*\95\87\D0	Aq\C7	\EA\AC\BE\D5ޛ\C0E\E57\B9F\9F\82\F2>%M\B1\84ڈ\80\98\D8Ta.X\D4t\B9eY\A4\D3il{\F6\B8O:\8A\00hk26\C4g\F8\9B\FB\F4\C4C\C4wn\80\C9!|\B7 "@X8q
\DD\F2\E6D\98\93j\AC\AD\85\EE\EF\EF\AF.\FA\97)"\00\DA=\D0e\813KD\E6U\B0G\EE"\B6c\A64B\C5\F7D\B4\E7$\A4\F9\B4\B0\D1"\91 \9B\CD\EE\D3\F1oV
 @@\BB\E3d\E34\DDIb\DBב\DA@\E0\E5ɉ2拭\C29\82pHҵ\8F\FE\89Du\CE\A4Z@\FBg2Vh\94\AB9\95Q\AC-7\D25\B2\DFLI6@\98\AF\F0LY\B2\C2,\C4j\FD\A7\D2iҙL\F5ѿd\00D\00t\F1\A8:\BBZ\ADkLn\C5z\E6\B7d&\FEHC\B9-\E6(<{m\A9\B1f\D9 \89\FE8\A5X:8\88c\CF-\F5$FM@G\9C\B5\94G\CF\EDdE\D4\EE\DF۶gr34e\B1\E8\C2\\84\A7d\84FD\FF\99L\86D2Yu\F4?m\E3\A4`g\D0\F17\921\DE\CB\EE\AA\CC\ED\FBL\80.\EFo\BB<\8EI-\C7K/\C7#\A8\A5~ڕ>ʁ4\F6ªm\F4oiͲe\CB2\ED\EFP\FE_\C9\80\80Ί\C8zOs\A0\B9\E0\97\B1\A6\9E\82\D2n\FC\F2*\D3O\EB×\F9\C2l8*\AC\98\F2d-\84\E9MQ[\8B\DC\DD\D3C,\9B\D7\F7\8A\FF\EF\E4QRd\8C{x/\EB\8Ec\8D?D|\F8\CC\E4\81_ē\FE¬Y\80Y\FAQ\E8\FCk\FD\C7b1\E7\96\FA\DF/ \88\00\E85\BA\97-\8Fa\8D\DCA|\D7=\F8\A5	\BC\C0\C5G\89\A0\C4Ra
\8A\C2g\BA\DF\8D\EAB,ˢ\B7\AF\EF\90\FD\FEg\8B\FE\E5
@@g-D\8D\DFhG\89\DDLl\F4!*~\91\B21\D2_K8\90.\C9N$\00jD2\99<䴿Y\80K\F6\A4\80N#\AE\C3\DE\00\B5\C2\00Sϐ\DCr#\89\B1Ǩ\90\97U\F6\CFd\ECgS\FD\D7\C8۶MOOϜ\FF\F6\AD\80\E5\99<\A7=\BF \9FM E\80\FB\D1\EB@\D1\BF\86?3\F0`\FCq\E2S\9Bq\FAO\A0\92YI \AF\84iR\8Ar\BE\ACE\C7Q\C3gJ)\BA\BB\BB\E9\EAꚻ\8D
\E9X\81O^\B0\93\F3O\9E$\EEH\F9\92\80\C4Q\90\B6a\B2\D6\D5\D9\FCz\E4!\9C\B1\A7a\E0\85\93+p0\D8r1 Y\80\8C\8E\A9d/t\9A\B0\F0\AFFѿeYte\B3h=\B7\A8U\99\AD\E1u\A7LЗ)\97\F7K"\00::`\87o\B4\CBu\C1\81\87
\C6`\D7\EF\88%G\F7E)ޏ\85\C1!й$t8\A0j\\9EvV\F4_\C3+\C7\C1\C1AR\E9t\F5\8E\DFT\B8\E0\84)\DEy\E6\87\F5\E5\C9&\E5# <W\9D]	\EAW\B5\E7\BBX\F9\A7\C1\9D\C0\CA\8EJ/\C5u\BA\81@\FAtd0\A8\C2W(\93\9E\99\E8\A6[\FE֨\F6#\9DJ\91J\A5\FD\ECπ1\AF\Y\E0\9Dgs\F4\B2)\FA2\B2\E3D\00\FB\D0\ED@\D9@\A1\CE\F7\B2\95\DD8\BBwcJ\CF\C3K\86I\F7\E3\EB`\90f\B1F\\875(\A3\AE\ACE3\E0pjy"\93Դ\BB\AF\BF\9Fd\F2P!\BCϪ\948\EB\98)\8E]\BE\93\9F'E'"\00\84\83Gd\84Y\A91\F7\B2\AA\B0\A7\B8S:
/\BDRY\99\D3QAaJÄ\92\C1\CD\C2\F0ls\F0\B1x\C9\A5\DA}\D0\F1ڝ\EC\DE\DE^R\A9Ԭ\BFfi\A6\CCk\8Eϱꄭ\9Cz\94/FEp(2Quv\BEAB\D9\D4\D4\D38S\9B\A1\EFD\F2\99#I\D8
\8D!\D08:\ACA\96,\C0\A2Rr\E1\E9a\C5\D7n\B5\B9(\CB\FB\CEԵ\00
H\D7.\FAWJ\D1\DB\DB;c\D3G\BC\E4\B0I.|\C9V^sR-VDPe@A\D6Z\84\A1-v?Bz\FC1\E8;\8D\\D7\E1\C4\D1R\D0)\A4m\98\F0\C3\A1\B1;'߿Ss孚1\B7\9F\A3\9F\97D\A9\A9\DAY\DC6\FD\E9\EB\EB#\8F\C4vz\9C\EF>ko=#GL,\BD `\EE$4\A4-\98X\84\EA\EC\C0\87\91\8Dd&\C7\F4\9FJ1\B9\85\91\FEm/<	\B3\00\BB*\D2:\B2\D1Q\FF\8F\EE\B1\F8\F2
[vC\80\A60C&\93$0\B5\89\FEk\92\FA7\80BkM\FF>M\8C\9B2r\D2>s\E1hm\EB\00\9D\98H[\E15\C0b\DD\CBV\A6P;\EE"\EF\C6<\95\A2\D3C\8C@\8A\DB:`\85\E2\B3(Y\80\BA\E3p\FDÚ\EF\AF\D7\DC\F9\94fw1\FC\FF{z\BA\E8Φ0\98\DA<ͨq\CB߁\81\81\E7R\FFƀ\A5<.|\D1\EF;o\94\FElY\9C\BF \A0\C4tس}\F7"\DE\CBU\C1\BA\9DX\83ǓSI\D22\B6\AB}鱡\E2\86\E8BΔ\81;6)nz\D4\E2\BB\EB5\A3\C5P\00h\AD\E9\EB\EB#\91\B0\F1w\E1\99]\BB\E8_)\85\8F\D3?0=\FBx\C5\BBY}\DE$G\8Cӓ\96\CFVP\BB,@\91Mz\8B^\9D\AD\BC*\9FǸ\C4Sˡ\FB(\8A:N#sڍ\A4I_Zך\C0\C0cCp\D7&\8B\EB\D2\\FF\A8:`\FAݒ%K\9E\BB[7\A6\E3<c\B5\89\FE
\A0-\9B\9E\9E%\A8\C0\B0\AC{\8AO^0\CE1\CBFY\D1'\E9"A@}JA\BF;+M\B9\A8\F2(Ne*tf	&9\80\A7\E3(\E9\D0^t\D9P1RX\AB\88˘\E2\E1-\9A\DF>\A2\F8\F7
\FA\A0co-\CB"\9B\CD\EE;P\C7, t\AFe\E1\9F\D1\C4	N\EES\~\DEG\8Eq\EC\F2\82\F9	"\00\EAz\DE\C9:
\DC&Iɚ\00\F2O/n\C6d_\88\97^\82I\F4
-W\EDABCR\8B\00X(\E3EشS\F3\83;4߽CS\99%\AB\B2|\D92bN
\DD\D4p\E0O2x\B5\C7`\F7\ABN(`i\B9D\004k\AF,@3\BB @M<\8A3\F5\BC\FE\D3\F0Kp\9CH6\A0]\B2\00\E5 lJ%̍B\86\A7W\DEf\F1\DD;4\E3\C5\D9}<'\93͢\F6\A8c\E6{\E0k\\F8דxۙS(\91\F7\82\80Ɠl\E2\EA\EC\C0\C7ވm'	\96\BC\84B|\80\8C\D2\CF%0\84ŉ^\A2\94yX-~\00c\C55h\FE\FE:\CD\F6\89C\A5˖.Ŷ4\8B\F3\BE\A8\F1\C0\9F\F0\CF)\9F\AF `QP@\B7
\E5J\F3m\F1\8A\E8\ED\B7\93M\F4\BE\82\9C\93&-\B5\AD\CD\F4ST\C9\9A\A2\B7\FC^\F1\A5\EBm6nQU\B7\F2\CEf\B3d\BB\BAt\FE\CF\FD\C7\E2F\FF\82 \A0	HY\E1W\DEo4\8E\DEz]\99\E5x}\A7R\B2\E28"Z\F4\A0*\E8rB\E1i$
pPpǓ\8A\FE\AD\C5}\9B5;rs\F0ն\CD@\FF\8C?x^K^\E3\81?\82 \A0I\98\BE\97u\9B\DC\A6\B6b&\B0\D2˩\BCE\\8A[\8FD4\A6:/\CF\E0\A1m\9A\9Fޭ\B9\E5̓Cs\FB^\A5\DD==\A4\D2\E9Y\C4\C5\8F\8B#\D6Uо\C6X\87Y\80\C5h<\94?S9\9C\CA&\B5\9C\A0g%e %\9Fdke\BA\EDpD\B5$B
\B8\E5\F7\9A\AF\DCl\F1ೊ\C2<\9Aue2z{{g\D2sYp\9D\ACf\97\D8\98\00ƀ^\A0G\F6\93\00\A1j\B2-V\9Dm\BA\B4*\95)\EC\CC Aj.\E1M\A5dZ\80\98
\B3O-"<\EBN\B17<\A2\B9s\D3\FC\B6\AFR\8AL&sЁ:\FBz\F49F\FF\CD~іv[\802\90\96\83\D1?"\00\84C\E3\94n\BD¬\A0\84\CEm"V\DAN\90.B\D7 \BEӅ"\BC\B1!\D0\C4LO\A8\9C\F2\9A\B7\B5\A1{\99=\ED{\E7Coo/])\FC;\C8\CAW\F9\8E\FBm\D6STƁg\A3\C8z\ED&\A2\AFq`)0\800\8A\00E\C6
@\A1\AD\B1WDO<H\BC\98\A1\D2}
*م\B1Shi+\DC\DC8\BAse-\C2t\F4\EF\A2鏡\CA+\97\E9i\CDxz|`\8A\A2\FE\99\ECՎ(3px\F4\95E\BA\89\88\00f\\C0h\p\B1\85\DFhWrĆ7@\BC\8F\F2\C0\A9\F8NG\DBs	{\84\86:.\C2,\C0\A4\DAua~\F4\F5\F5\91\CET\99\EF\AE\E6pkh\BAa\DD(F\8E\FD	\AAK\99H$GD_q\B1\ED\88|\A45 m\85\EDZ[\9D\F2n\E2\DBo#>|?\9E_&/\95fM,<\F48r_3_ǡ\A7\A7KWypuT\E4\FC\9B\C9\F8\C06\E0.\E0q\E6~g\E4OE߿-\FA߂d\00\84\FDT\94
S\B2\A5r\EB\DF\CB\F9-\C4
ۈu\AD\C4\ED?\85
0ڄtE\B5\00js\8F\FEQ\F8\B7\AFw?\E43@\8B\E6\B937\C0p\F1O\D6\E0畀G\EB\8E\FA$t \ECC\A\DA
r;`\98܄3\B5\BB\FF8\8A٣\9B\CA\C4	\84-a\BBlu\E5Y\E0\9C\CEj<Nw6\8B\AE2\FA?d
@\B3D\FF\D3\CF\FA6\BB\A8\FD\FD\D0$\F0\00\E1s\C1c\80n\D9K"\00\84\E7\B2\00=\D1m\BFM\AC\B11`J\A8\91\87\89OmG\F5M)u8\9A@\84@\B3\90\B5\C3\FAiT\ADhR,[\B6쐅s"\D6Ҹ<E\FE\F9:\FE>\EE^\BF\C72\C2BA\C9\8A\00\A2v\ADv\FBUg\9B\00]\86\91<vr\95^\81\9BZJ@@\>\F5Evh\845(\A5\A0}\84g=I&\93\A4R)Ԝ&ꘙ;i\B7\8B\86Kx??9\E6FQ\882
#\84E\82\834_\A4 \A0\D1\C68k\C1\A4מ\C6\D8+`Om\82\F28\94'1٥\F8v\83\91}\B4\98L?E\9D\94"\ADY\D1Z\B3|\F9r,k\EE\EF\DAf<\CE\F1E\8A\FE]\C27\FB[#ǿ\A0\80\F0Z\E0\84=\96\FDȳA\00\9D\9D\E8m\F3{\D9\CA(Ve]^\8E\9F>\9A ݋\A7c\D2?`1\99\CET\A4;\D0\CCB)\9B%\91\98O\98\AA\E2k®\8D\C4r\84O\F4\B6v\F1[\F4\C8 \CAB\EC\00\8E\D2\D8\F4I>@@\A7\9A\A8U\AB\DB\DE)YU\C2.A\F10\8A]/$O\E1+-\83\86OB\87])E\00\C7qX\BAt\E9S\FF{\85\FF;ˉ
\00Cx\CF?l\8A\FE\B9\D9\F0	_h\8E\A3\8B\B7\9B\D5LϨ\AB\A4]E\B3"[\9D\B5\D7\E9\9C\C5\CDm#9t\D6\D8c\94\FC\AE1\D57Oj\A4\C6\AF\E2r\A2<\8FZ\D3\D3\D3C<[\D8\EFM#\DFĸ\C0(\F0;\E0\D1&u\FE{\9F$c|
\F8p\B1YM\CA|P\82\00D\BAÌ\B110\FE\E9\AD7\E2L>M	(ʑop\94\AB\C3a_\92\C9$}}}t\FE\EA\C0\E8\BF\DEkm\EF\D67\F7R\DF\EA\FE\FA\F8\96Ӏ\9F\BF\C4p\9A\F9\A0T\88\00蠈\AC\CB\9Fv\BE\8B}\90\E4\B37/n\A7\8Cn\8A[ʎ\D9s)"\BC\F6\EAZ\D3\D3\DD=\EFg\8A\80\F5\F3\A6SF\F7\FC\9F6\D4\FD\FDKx8\8A\FA\C7i\E5c
\B8\00\C3\ED\AE6\E6y\E6/\C5\EF\88\00\E8\90,@\BA5\AF\AF\80\B5\F3^b[\D6\E2T\C6ȣ\A4\91h#\90\C1\FB\D2\D3\D3S崿\FD\FD\F1q\BE\F1'O\F3\AFog倻\97ʢ~\\9E\8C\FFv\DAe؃\92ގ\CB\CDT\F8\92\F9\B0n
{!KPP\F2۾ \F0\E06\B4\82
\86QCwO.\C3\EA=\86\A2\93%\86\91T`=\89\EB\B03e\A9ë0,\CB"\93\CDb\D9՛9\D2N\81\B8`\8C\A3'Ȕ\89Y\FBY\CCzX̀=\95\F4\BBi\D7Y\CF
8\B8\97\97\99\D5\FC͏\D5\E4\E4Ԋ\00hKR\CA\8Cup\FC\EB\B1s\9B\C1\CDcg\96Az9\AE\9DAI\FF\80:9>\FD1*\B7\AB\A9\8E\C1\C1A\D2\E9\EA\DA\D4c苗xߋ\A78~\E9n\8E[Z \E9\C4}\D5:\FA\9F\EE\DB?\C2\ECczۋ$pp4\E7\99\F24w\A8o\B6X\95\83\00\A1\AA\DD\8D.u\B256PޅSم)M\A4\97d\F1p\A4@=\88\E9p\DFuj\8B\E0x<N*\95\AA\AE߿\A9p\E1
\AC:z\88\97U"\E9̐:qjh1\C2\F7\FC;\A3ȿؑ\D3a\C0\DB8\C3\CF\CC\B9\CD\EF\D57\E5\91\806"\A1\F74j\E9t\A8\FCf\9C\C23\F8\95\E3\F1\92+ \D9E\80\C2B\AE\AEk\86\FA\9C\CEm<00@*\95\9A=\F2\C6\E3\FC\A3ʜ\B6b\98מ0FOb\96\85\D2Q\F4_\8B\88\BFB8\ACg+a\81\9Fp\86O`x\FF`Vs\A7\BA\8A'eYD\00\B4
)+T\DAA\835\FE\D6\C4\E3\98\FE\93(\A4'i\C70\A8\99ڮ	s\C5Qao\80I\AF\B3\9A2d\B3\D9YS\FF
\C3{+\9C\B6b7\9F\BA\83#z͡\D5T\8C\85?\FB\F3[\E7>I\F8\AE_\D8\8Bp\D8\F0\00w\98\D5|\C5=\EAʚ4D\00,\BE1\00\92\DF\DAK\A8\91Iۏa\FAOg*\DDO
-\FB\B2Vt\D9\E15\80\D7!\9BN)E_\FFA\9F\FD) \AE=^\D0=\C6߼v;/\F0\A9\AA1\A0\C5\C2\DDLw\F1\FBC\F9Kp(\9Ftp-\F0=\B3\9A\AF\E3\F1\B8\FA\8E\ACZ=\90\BB\D7\92\B0\C2{Y\E1 \C1Q\B5s=]\DBנ˓QTdUj$<\ED\CEI\A9twu\91J&\DA\F2\B7\C7\E3>\CE\BCc\C7V\E9\FC\E1\9B\FF\F9\9E\DBr\E4\F8\EF \AC\F07V\B5\B9\C4p\B0\8B0\EF\A7_\96D2\00-\8D\BD\D1.\FA\92\98\89\D28z\FBZ\C9~\BC\C1S)Zb\F2lp!d\ACpϵ\FB\F5\93R\8A\81\C1\C1}\A7\FDCZO\F2\E9U#\BC\FA\D8Ib\96aN\E3\00l\E6\D7\EF\DF#|\C7\FF4a\81\9F\F8\F9\92B\F1	,\DElV\F3
,\BE\A5\FEM\9A\8B\89\00hQ\E2*\AC\C8\CBx\8C1.\AA\B0{\FB\AC\E4\CC\C0\89䉑\92!C\F3<\E4jOj;\FB\A1\BE\DE^\E2\F1\B0E\9F	\C0\D6\FE\EA\8C1^s\FC(\DDI{\AE\F9\CE\F9D\FF\E1\FD\FEӄ\F7\FD\AE\EC\BF\F9\A9c\80/\E1\F3s\DF~\AE\AE\94|\8A\80V\8BR\80\FE\AEΞ\CBR\B9S(/\8F\A9䈥\97B\D7J
ʐD\8B\98+\D3 צ\C2Ӷ\E3\F4-Y
(4e>\F4\F2I^z\C4$\87uO\D03\DF\EA\FD\F8\A3\FF1\C21\BD;@bԺ\98\CEp>\86Q\BC\C6|\90\AB)\B2A}O\A6
\8A\00h\B1\88,eAΓ\CC\E0!\B3\AA\B4\A72\82)\B1z\BA\F0\E3F\9E\CEK\85M\A9\F2\EDv\FDd@i\87lw?\DB\F0ʣ&y\DDvsҊ\DDf\E8nbTW%5E\FD\CF \E9\FE\FA\A3\81\E7ax?\86S\88\F3s9\DFa\8Am\EAj"\00Z\84>\BBs[χ\C0G\E5\9F ^N\E1\F7Hh\8C\A3\00_\84@\D5Y\00\CA&ڨ+\A51\8AL\C2\E6U\C7).:qg=\C1a\DD5\F8&\AA\B0\8E\A5(\EA\DFN\D8\CDO\CEr\A3y\F0|\CE"\C9\CCj\AEWW1"\CB"\A0%"\B2\8C\E3@G\D5x\ACa \93&\E8\D2PZaDTԦ,\C8\E0\B7\C9\EDi\DCQ\BC\F1\E4
\83\DD[y\D1R\B7vc\E6S@\D8\C0g[\F4%\E7w\B13\AFFq6p\BD\F9\00\FF<\AE\BE%\FD\AA\DD\EAm\8D\F9>`\F8u\B3\FD\D9|;*P\96R\96\F9m^\DDILwcU\A2d\AD\E3\D9\CF0\EE6\CFl
\A5\A0g\00zOh\A2EJF_\EA \8BW&L\F5oF\9E\F45'\BB1\\FC;\B0]}K\CA0\A5\9E\84E\CCdm\D0\BB\CEϙ/\A0\9E\9DDO\C6p\E4\9D@5\8A?c\87\FD\84,b\E2 \CE?\00\9E6\00O\89\F3ob\FAP\FC
\8A\BB\81\F7\9A\F7\D3#K"\A0iIkH\8A1^\98`d\FD\CC$\AA\90\C4Ǒ<\C0l\D8
\BA\E5\F2o\E6\E8_\EF\E7\F8\B76\F2y\A4=U˰\C57\B0\B8\D7\\C6[̻\E7\D5\CDA\80P\FF,@ƒ\A2\F8v\8Damˣ\8Aq\E2\A7͘\B0\81\C2އ\91=-
0\DC9\FE)\E4z\A9\B5.\B0\C3wH\F0+\B3\9AW\99\BF\95\A1\80f:\EC\F0*@X8A\00eFr\A8\E1\AAlc$#p\90\83\AF\A0ז\B7\94\FB\A8\A2\E9~\F9\C8\E9?Lػ_n\91[\9D.\E7?b\84\AF\98՜"K\B2G!	M\A0rJ\9A\D5
\D7C\B9*\B4\DD)\D3\E5`\B4\F2Z`)f:\BEUE\96\D0v\DE\F5K\C4ߎ\BEn9\86ˁ3\CCe\FC\C5/\D4l ,\BE1\B6\A0\DB\C0n\896j\87\81R\CA\AA\9C\C0\A4H'\B4\8B\96ˁ\B0\BF/\BB\CA.<= \EC&|\CF\EF\C9\DEhcb\C0\E9^\82\E1ef5ב\E4?\D9EE\FD\B8\F3$\9F\4Ih	5\D6\E4\A8\91j\aJ\8C\85AK\8C\97P\EB\D4=D\8Ex<\FAoq\FE\9D\FC\BE\F8w\8A\FC_2\9CiV ,q-\D5\D9uN0>\86\B5\A39\E3\E9\E8\D9`\8B.E\98\E88\E1\E9F\FF\93\84\9D\FC\C4\F1w\AC\D9>\8C\E2\C0_\9BO\B0\CC|\A4s2\E3"\00\9A\8C\8C
\A1\8E\81\9F\81\E1	\F4\B6"\BA`\BB\B33q\A9N)4`v\8F\00O\B6\F35\F2\D5\E1_
\C32\C787\90\E7\8D\E6\FD\9D\91
\90x\B3ɰ\A27ڻ\E4\BDq\DD\F1=\D81\89\8E\C51\83)\82\B8\8B\EA\D4\D9]J
*m.\85r\DBa\E7XjH\82\B0'\D1\C7U\F4r\B1\F9w\AAϵw\B5\90\81&$mAB\87\E3[\85\FAS)\A3\B6WP	
K\FA\F1\ACv\A7\CD\8B\E9\D0!\8E\B9\ED]\FC\EE[\B0m\B6\96\A0?	\C7%\A3\AE\88R\F1\DF\D9(I\8A,\8Ef	\86\EEN\E8+*\A0)\F7"\F49\E1\9C\00\D4\8C\81\A2\DBǰR@O\9A\C0\F2:+#\90\B6\A0\84\EB\D0֟5P\F1`(SEX\92\84#R\80۩G\97~\A0\87G\00\8A\00:!Ф\C4u\98(Ȅ\EB\86⺨I\A0\@e\C8Ze"\83\D0\E68QW\CAb\A7\EC99J\98paI\96;\E15\9C\D0XT\E8\BA\B0\80\FF\CF\DE{\87\D9u\95\F7\FE\9F\B5\F6ާ\9F3}FU\F7n\83M \98\J\98jB\E1\92\00Vhi\E0\C0\CD\CD
\A4\F0KB\C8\E5n\821ls\8Di\8C)\86\C4\C6`\E3\AE\92eɲ,˒F\D3\DB9s\DA.\EB\F7\C7>c˲%͜2\A7\BD\9F\E79\8Fzf4\B3\F6^\EB\FD\BE\EFz\83\E8nˊ\D0\C2Q\80>\DC\00\\89\AC\B9\87X,\A3J-HX\98T\C6\E3h\00\00 \00IDATpQ\9D*\8EkH[\90\ED"\E1\E9\F90\E3Cօ\4\D2%\B1\A3
\89^l"h\C3\DFCW\A6ċ\00h\F1(@\D4WJ\94\9A#\BC\D0C,8\E0Z7\8BP\EEܣ\C2V\E1U@\CE\EF\D0k\F1\E3\94}\96}8\90\87\892\9C\92\93qӖ샎A\E3\91B\93Đ,l\D2@\9ApDW.\89\D0\D2\F4\D92\B4\A5\D9\F8.j.\8B\9At!gc\BCp\E7tl\8APLw\F0l
\E7ć}ك\87a{.\AC\C6)I\AE\DDE\9F!\8AO\C3\A4\88\A1\B0H}\95w\A2k5\91\D0\DA\E7\95
GK8\B2\F9xL\CE`\8D\FBP\8C`L\87v\D4*\00\BA_:\87\95\C5=
,\95\E0\81ؕ\87\AC\92\8E\D3vlzp\D9@\99~b\A8\CA\D3O\83t}\@\90\B2\A59P+Q.\C3\D8z\F0c\9Dx\88DT\D8\A0\83\BC@\88W\BC\FFU$t\93Kp\E7<\98sr\846y\DE	\8Al\A4\C80,\E2O\FC]\A2k\C3\FE"\00\DA0
бY\93ϡ0\E6t|z;\EF\FC\EC\B1;(#^\B1ʟUqc`"\B7\CC\C2Cyd\96TK\ABW\F2l\A2\C4b8$\9E\88\D3)\A0\B7b\FC\C5\F2\92\D86\C4u\F8Y\928dK\B8\C0\B0\9Epv\FC^ \DF\BF\9B\A5!Si\D4\F6Ď8\F4k\B8\B8\F18\94\D7dS6F\E4z\AEu<%\8A\A1\89\C3:*\DDs\D9\F8\F7#L@>(f$\E7}iZ\D6R\98\8Aa\89TD@?p\008t@;\E7^;\9D\E5vvy\ED\8A\00\A8\E3#_*\C1^\A6#\B0>#\8Eؕ\E6)U<z(\93!\86
\A8\A3\FC{]1\FE}b\FCE\00\B41ъG\B6 e\81\ADzA8\950\C1h8D[+6Ex\FD4\E7\B6iWJUg
8\F8]\A6P\F0`!v아ݵ|\B6|\D28\C4p\9Ef\F8\C5\F8\8B\00\E8(\FBR\A9\D1\CE\FA\D2"\B8\E5\85\C0\00\D0S9x&+\9F6}f\96<(\B6\E3\CF\EF\C0\E9_
a\C9
?s.l\88\C2`\E2blk\F8ӕ\E7\9ADa\A1y\A6[}\ABb\FC{\C5\F8\8B\00\E8\94(\80\82^f%
\D0\BBkcEd\80q \D7~B`9!\D0s\C1k\A7\9F}\F9jf\8DȖa\B7\E3\9C\85\93\F4\F0\A8\EB\8B\F8\F4\A0\B0\8FS\D4i\E1\F9\C7\DD"B;\EDI[\FA\95\B7I\C2k\81s\80
4,$\DDH\C4ڭl\CAY[\00a\B5\C0|\87\97\C2h\9Dh\F5ڗM@
\8F\p\B0\8F\B3\8B\F4\9E\BF \80N\C3Q\D0#Q\80\F6\A3\AF\F2\99\F6\00\B4M=\99"LB-\F9m2\9B\C2\A2\CDZ\C6\C0\E1L\94\E0\A44lt\C0\91\FC\80j^<C\8C\80~\96H\90Y\91K;@q\93\C5Щd\ECл\90AAm\C8@EL\00\BB\80mq-\D3aʂ\D7?n\A45N\B7 \80\BD\B0߂\93ӰY\CAW#\E2\\86(\91&U1\E9'6\FEC@J\8C\BF\80G+\E8q`\A6,e\81\ED\F9\00y\B2l\F00\F0\D0\E2\F5\F6\8Aʠ\A0\00\BCV\8E\X\B4\DC5\8B\E7\C3#p(\A7\A6`X\BA\D0oo\94Đ\C6A\93\\F1~&\BCn\E3/\A0+\A2\00,i(H[\B2\F6%
l\AAD\F6h\E1fOQ&\A1\CE-,<c\B4d\9Bנ2_`\87}Q8)\AE\A5\F0\84\C2\F4\E9\C5%\83\85\8D\83^\A1)\B7	\CBn\C5\F8\8B\00\E86\D26\94]\F0%оX\84\C3IN!\EC*\B8\98\A5e\F3b:\9CВS\F2lZ>\C9\D2\F7a\A6\007,\\85t7\A7c+q
\F4#\82S)\EB[\D9\8CF\D1\C4\F8\8B\00\E8FR\95\EE\809i\DC\FE,f	`\BA\98k\C1SC\AF\8E\CAm9
\90\A0-j\9B\8Cy\B2\C0\92\83\8E\85\A1." \8EK\9A),lfO/F\98韒\A3C@7G\AC\B0UkY\A2\00\9DA\8C\B0\\B0\AF"\A6\81\C5\D6\FA\A3\E2\F1\D9R\A7Y\9Eh\D3E\98.â\EB"a\FB\E5/\F3
\88\90\00\D2"( \BA*5)\C6_\80\B7 @Y\CA;E\D6<\8D\F0~sY\B4\C8|[\85́
\AD2\9BBU\BC\FFv5\9C\8C-\85e\83\E2aG\C1\84\EE\B8F-C\9F	\AA\99\D2\AD\88\E3\A4"\00 \BC
(m>\B4Ex:\CBu\CD\FDp\90\B0@X\DD\E5\B2\C0\96\B8~\8A6\FEis|\CF\C2X	ΊC\BF\83q4\AA\EDa?CeR8T{\DB\A9\E2\B8
"\00\84'\F7\85\86\94\86\B9@\CA;6"\B0	\F6W>\C5\E6\FFH\BD6\E4\83&Ϧ\D0\D4u\DA_+\E0\95a{\A2\EEY)\EC\81Z\B7\AB
\B00\F4\91\A5\974\AA\D3!L\92\8D\AE\D1\CB\DD%\FE\85\D0!\F6!iK\EF\F1\8E\C7N\9Elm\FE^\9EM%\BArWƎ\82\D5F\99v%\9F\C8\FD\8Bp\D7\DEb@{\C5\F7\BD\E48C=\CF8\ADo5\C6k\95%Y\F2X\9D\EFK\89\B9\E8 \9Cʠ \A9\86\E9b\C0\C0\F3\9B\F8\D0{\B0\9Bu\92X\AB3
\89Ax\D6[`\EB\8B@\B5I\FC\D3t\B6\8C}\EF,ܳ\88[0-n\98=\D9B\C0 ɚ\EDL\ACb\FC?\D7!\C0p#\AF\EEP\A2\E3/T\E5
\A0ÈZ\F3\A59PW\B0<\F4$A}\98o\C2!\A2 \A9a\A1\EF\\84U5\FDQ
Rpү@\FFip\E0V\98~L\EC\97r\80\9A-a\DF\EBàCyK\92H\B4\D5\D4~\8C(\A2D\B0P5K\D3$aL\E3\8D\FF\9D(>\8F\CF\F5xL\AB\BF\A4+
\ABE\00t\DAU\D0\E7@\B1$\B9\00]\C3\F2\DDh\82\B0o\C0\A3\84\F9k\F8\F4\D9P
\A0\B8\96\86\B4\BA\F2p\9F\C4a`+\C430|\B8	\B2\93`Z\FB\D8W\CB\FD\8AV>\C0F\F0G\A2X\8Ejr\E0ϡH?1,\A2\AB\AC\E7?i\C2l\FF\C6\FF\BD\C0׀\AFb\B1S}\B0\D5r\8B\00NdTX\90\95\E6@\DDE\9A\B0.\BA\87p\BE\C0ᠡ\B5F\A8\B0l\AD\ACaC\87\9A/1\FD\90\E8\83\CC\00L셱\9FCq\8A\96WϾ\C1\9A*\C2l	\95\F71\FDp@\AD\EDe\90\C1ƥ\9B\8A
\EAts\9E!\8CnE\F4s\87;\E3\FF\D7\F0}\F5\A1\EE\9C\DA,\A0ѕ\ED\9C/Q\80\AECU@\92\B0t\F0\00\E1\B5\C0\F4\E8\B1\C3\F6\C0Kk!<\A3\D4/\F3_Aj8\FD#p\F0!\98{J3\AD\FF\B8}\83\B5	s\A0\8895\96
\A6\ED\86\E7v\85\F5\FC1i|R\AB\CD\C4h\AA\F1/\B7\FF\81\C5ԟ\B5Jg
\00B=\9D#\CE	X\94\E6@ݻ\B3\87	C\A8\87*\9Flc=[\A5¾\00\A5\00\BCF*OEC\FA\FDk\FAN\86\CC\98\81\F7C\EE \F8\ADV\81\8Fړ\C5OؘS\92\A8^\A2\BA!р\80(z\81zW\E4g*\EFl\FD{:\94\81q\E0s>\A3\FE\9C9$D\00t\B4#\D8k\855ڞ$v\B1$,\\EC&i\E8\B5@\A2Ґ*\DBH\E1\A5\A1M\AC\AC?\F6\DF\87o\87\FC\81\D6\D4\AC%\B6/`\CA\E7&\88\A6"u+\F52\D8@\92\83(t:/\A4	\9B\FC\E8z/94\DF>\A6>\C09D\00t\C7\C3\D5a.\C0\824\A2\C09\84=tϭ	\FBT\83\A2\00\9A\C6N\FBS\84W=`E\E0\E4
\B0\E9\B0\FB[0ykة\AF
\84\80Z*\BD\B3L\D0\C3?'\89\B3j\CE\C6\CF1D\A7A=\F8҄\AB\FA>\D7p\8A\CB\D4\F8\B9"\00\BA\8E^
^\8B\8En֖\E5~\F9\CF&l'\FC0a\D5@\9Dߍ\A8T\CD5\C2X\AE\A2\E9OU߻\A7\F2\A7zr͜>8\FBm\B0\E5\E5\B0\EF\DB0\F9\F3p\9A_\A0g\8B\E8\DBKx#q\D4I\ACU2\C4(0B\87\8D\AA4\C8T<\FF\FA}\F7\00x\C5\FB\B0\B9M\FD	Y\D9\FC"\00\BA]\A9({\8E\F0\A2{\81\81	`\90\AB\EF;\97\B0![\EF\EB\A7喿\F56CV\C5\A7e\8D\B6!\BD\CE~\8C\BC\00\FF\CC?J[l*\CF`\8D\E5a\B1\8C7\C3lI\E0\9C0\CA\C1e\00\9F8\B1\BA\D4\F3\D3C!LV\AD_\D8\FF\F0\BEK\9C\FD\EA}r\EC\89\00\E8r\D2vx/\9B\97\\00\E1\C8h\80C8[\A0\B7"\A3n\D5\91JW\CA\E9z\BEs\F1:\9B\A1劉+\CB8Wa\FF\80\E1 \BD\A6w\C3\C1\AF\C3\D2\\EB?md=\ACR\B3\E0\C7\F1\D7Gp\D4\D3E\96KeR_M#\BB\C5\F6U>\F5\F9ƀ\AF\A1\F82\B0S]ƒlr\00²Gf\85MZDO\F3\AAS\EF7C8r\F8qj~Q\E1\98j۫S.\80E\FD\EE\FE\97G-ǫ\8B((
\89!\D84\00\E9\F50\F3\F86\F8\F9\96\BFP\E5\005U\C2d}t>\86\88\F4\DAXʢL\9A8\8AD\83
?\AF\BF\B7.\FFJŏ\81+\F8\89\BA\8C\D9\D4"\00\84\A3\C8\D8a\93\96Ei$\CB(U<\E2a\C1\D4\D4\D2\D5Q0\E8\C0D\B9\C6H\F9r\C3\EF9\C2\F8[5~;
}\A7@\EFzȬ\83\89`\EAV\F0\AD\FF\B4\8B־\E6\B0\A7\A5	7`\EC\DD\E0\A1ʪ\E2\F5\D7n\FC\E0f\E0Gh>\CFFf\D5oI\B8_\80pL\CBe\81\B2M\84c!.\D4Ox-\F08P\A8>"\D3\E1\C4\C0R-\85\E5\EB\8AZO\BAD%\DAQ\E7SO%\C2k\81\9E\CDг\C6\EE\84\FC\A3\E0[\FEi\AB\A2\8F\B5\A7\88\9B\89\B1u\83\BB\EA#<\FF\DA\FF^\E04\FF@\8C\C3\EA\BDb\F8E\00'$nA2\80i$\9C\F0e!\EC0\00쯈\81*\F2\B4\82~ƫ\8D,\87\EB\AB5Mˉ\83>P&\DA\9B_\C3\E7\C2\E3?\85\F1;\A1<\DEy\82jM\FE\85~\C2Su`	\F8/\9F\00nW\90M\00ª\F6`ʂ\BC\AEhfa%\A4\81s\81M\84\FDY\F5\B5@\DC
\A3OU\B5\B6\AB4\DC\CBQ\83^\9EZַĆ\E0\F4߀\8Dχ=߀\99\9Da~@ע+B\B2z\E3\00\F7`\F8[\E0\BB\EA21\FC"\00\84\AA\88\E80`ƕ\B5VA\F0K\C0,\B0X\A5A\EB\A9$\A1\FA\AB\9E\9A0l_ͩ\D6K\FD\ABVIb\CE{d\F7\C1C_\86l\9B\94
\D6\DD\F8U\84du\86\F8
|Q\FDEو"\00\84\A3\00\C9ʤ\C0\B2\E8ha5X\84
[~\B9r,\EFa\C5m\85c$V\DB"8\B2\CAʪ\9A\E5z~\D5\FC%\D36\F4\9C}f\86\BD_\85\A5\B1.2\FE\83U\FF"\F0\F7\84\FBS%^\BF\00\A1>\E7\B8
\E7\B7O\94e-\84*d\94\B0@?a\92\E0Vt-\90\A9
Z\91\F0\B4Y\F9|9]\F1\F63\95\AFS-\B6f\9C$\9D\99\CD0v\BAJ\9DܟΩ\BC\AB7\FEWb\F8*p\B7\BA\AC\9E-\AA\00B\D8\9D-Q\00\A1\EAh@8\AD\E2\E5",<N\88;\AA\C3\\80\BDs+\F5\FE\95O\93\C3\FD+\D2\C4`\EBˡ\EF\98\B8&\FE\DCN\BB\8E\8B\96\FA\AD\CE\F8\81\BBQ|
\C5\CF\D4\93M&@h``Ё\C3%i,\D4x\82\F1dK\D7I\C2AC\C7 mA\D9?AWJ\87'\FE\C5*F?A\CD\F5\FCk\BE\F7\A2\D02\F4\AC\83\9E\D3`j;L\DD\A6\C4x\B4b\FCS+\FE\8A\B0\AC\CF\F0\E0:uɦ \AC\C5^U\B5\A0(́\84Zq+\FA	C\F1\84E[G\A9KGA\\87\AD\A9\9F\F8+\F5\A4u\9Ck\D9돴\F7\92Y	\BD6AfL\DD\8B\B6\B1\88V\9Er\C5_\B1\8F\B0\99\CF')\B0S}9\89D\00k\85R0\E0\C0\E1\00	5\BFP\CF\EFt²\AF\83\95\88\80\FFT!\90:z6\85:\CA\F8G\8E\F1\BD\E3\95\EF\EB\ACe\8B\C3I\BF
'á\CD0u\94\E7\DAL8\95g\BE\B2\AA\8D9\E04\9F\00~\A8>\80\D4$\89\00\9AHZ\90\93i\81B=\E0\C9n\82\8F\F3O\8A\00\AB2\A1\B2p\A4\813<\99`\A8\8F2\FCv%\AA\90\A0\E5\EF\F9kO\99\93 \B3\D6]\00\FBn\80\D9\8C\D7\C0I|\F5"\AFH\98\F9\C0C(\FEŕ\EAR\D6'@h:=|i,4 "\B0\8E0G\E0\F0O\94
&*])\97\82#\A21\9E\DA\F2w\B9\AC/E\A3GӴԚ\F5\9D	\BD\A7\C1\9E\EB\F8\E6\A1\EF\F3l\AF\CCI-\BB`\84\95TlL\A1\B8\92\80\BFU\97\91\95\CD\D1hY!\A2ð\AC\92\A5\81l.&\BC\B0'c\85р'\88q*e*\86%ӝ\A7\94\B2\E0\F4\D7so߅\BCxaؼ\F5\8C\FF\BA\FF\F0y\BF\8C\E1/ԟ\8B\F1 \B4i+,\D3\84\86\B6\00\CFN\85\88\BEw\86\8AY.-&\EC<\D8\ED\F1I\8D:\F5\B78\88\E1KF\F1R\E0S\D0"s\EE\81v\ECD\CC\00ŷ\80W\EFǰO]\86L!i1\E4
@\00\C2\EC\ECd\A5Q\8B\DC
=q\B6\00'\83>2\F7\86\F9'\F4\E68\B4]Y_#\A9A\82\97?\88\DC\FB_gs\C8(\BEo\E0](^M\98\B9\F6\A4*\CF\EB\99=\FC\C5\FFC\F3C<\C6ԟK?\00B˓\AC\F4k_\92b\A1aJ\B3b8\A2\A1i\F5Cz\B1\E2\F5\CBit\~m'\93\C0\8F~t\BB\DCd\E0\80g\AD\E9ʥ	\A33O7\FE>0\8E\E2r\E0\C0=\EA\CFė \B4\CFˠ \A1\C3i\81\B2s\85\86y\8F\CBƣR6\A8S\B2,\AB\E1\E5\F2\F8m\CF\E7\8A\\8E0\BC\B8\84pfcc\C9<\A3\F17\845\FF|\93QnP\BF+Ǉ\00\A1m\A3\00\A5\00%
 ԛW\C3\DF,.\BE\D8\F7\E3g\F3a\D7\E5\DB\C0\9FfW\8C6L\B8\F5r\F4\9D\FF"\B0\F84שIY\9F\00\A1\AD\D1\CB}\A49\90\D0#\E2\C82ԓ\97܋\DC\FA\83s\B8S+~K\C1\BB\81\E7\B0\F2QJ+{n\83O\B1e\E00\F09\.W\C1\8C<	\00B\87\B3 \C0\82\E4\EC
\F5\A2r\E7/4\86W>\88\\F3\B33\F9\8F%\8B?5\8A\F7\AA0P[uo\92\B0\8FÓ\89\99\B3\C071|T\FD9\87d\E5\DB\DC\E1\93%\8EF=\B6\A8C\A1\8E/T\97\D6\F3\AF5/\D8E\D1h\FEų|(T\FD\CC҄u\FE\D6^\FF\8D(^@\84w\8B\F1 t0\96\82\8C(\00\A1đ\BB\FF5\E4\92\ED\98K\B63\C0\FF4\86_\AE\84U\DA\C9T<\85\EE^\BCQ}\90]ꏥ\9E_\80\D0\F9N\9B
\8E\BC!B\AD'Li3\D9^\B9?\80\BB\DF\DCǨ\C9?2\DFg\B9'\83f;\8A\F7W\8C\FF\AA\CBX\94U\ED,\C4\C7\8E}v+\E8\B5a\BA,e\81B\95\DD\DF_X[\F0 0w\C3\D9|Ckv\A1x1\86w\F3DS\E6\8A8*\CF)\F40\8E\C57\B0\B9\92\80\EA\83\CB\00BW\91԰\A0\A0,
@X-a\E9\98x\FFM\E7;1\C0\F6\BF\98\EE\F7*x\A3Q\FC0\A8\C1! ɵ\C4\F9ש?\AD2@ tN\A0߁)|\C2JQ\EF_N\98\96\E2%7c\80[xwk\C3;\E1O,\9B\8B\DC;I\F3m>̧\94#\F5\FC"\00\A1B܂\88\00\C2j\BC\FF\8C,C\ABr\C9v
\C0w\BE{\B7\F5\F4\F2\A1\85<_\EEq\B8O9r\DB'@\8Er\E6z(\97%
 \AC\00MX?.C}Z\9E_\88i\E22Y\89\EEݪ\82pBb:\CC\90\EB\\E1\84H\D3A tV e\83-o\8Cp\A2%!޿ \88\00:.
\90\B6$
 \87\D2\F4GD\00\9DH\CT\DEA\BCA t\D1J@\9EF\9A\A3\C7\C5
\82 @\E8$bV82X\9Er\92\C4\E5D\00BG\E3\A80!P\9E\A0W\BCA tG@\8B*\D8\EF_\00B\E7c\A9 \EC\F8'WB\82 @\E8$!P B8AN\00B\F7\A0\80\DEX\E8\DE@\FA\FD\82\00\A1;\B1\81\94D\BA\93\D2\F2WD\00\DDL\AF
y\93\BAP\F9\C92\82\00\A1\AB\B1T\D8@^\A6.\F3\FE%\F3_D\00B\8FD\BAI\FC\00\82p䋔\B6$!\B0k\BCi\FA#"\00a\99\A46:\DC\FBO\CA2\82\00A8\F2eRa\C0\96(@g\A2C\FF\8E,\85 \88\00\84\A3\90AALI\FC\00\82p\EC*)Q\80\CE\F4\FE\D3H\CB_A \C7quX tq$\F1OD\00\9DŸ\96\B2\C0\8Ez\A02\F0GD\00\C2J\88h\E8\83\D1\A4;\FF	\82 @VBL\CA;\E3\84H\C9I!"\00a\D8Jrڞ4R\F6'"\00a\F5$\AC\F0#\B4!VE\00\82 @V\8B"\9C(U\81m\F8\E0\D2rB\82\00A\A8\81\98\96\E6@mGT\BCA u\A0\CF[޶\F6\F1\FEH\D8FD\00B\ED8
\F2\B6\B5qd\E0\8F \88\00\84\FA\D1kKY`\CBc\8B\F7/"\00\A1޶EA\DC%ƥ\B5\BD\FF\84,\83 \88\00\84:\93\91(@\EB\E3/"\00\A1AX@J\83\96(@kz\FF2\F0GD\00B\A3HX\E1\B0 \A1\BDf\82 @P\90\B6\C3?\85A\FE\82\80ELM\8BU\90\92\E6@\AD\E3\FD\C7e\97\82\80N\C3\00\E0?\F1_B\CBDR\96\E4\B4\844\EE%L\CEZ\8D\B2,\81 \A0f\D8	\FC3pPy9\9E:\EC(4\91(\92\F8\D7z\CC_n\00<Y\A1\91\FA\BF+0\97\92\C2\F0|4\EF^\8C\C8\E3o>\AE\81\B1\F8m\9F\C9l\C68T\A4
}h
\8B\00h!J\C0\9D\C0\971|[]Ą,\89 \A0\9EB\E0\DD\F4\F0\DB\C0ۀg!\95\CFM'\EB\C3t\B9=\EFh\DAZ\00$\80\E4\EE\BF\8E%\E0\E0F\E0,0\AE^"W\96\82\80\C6\ED\B8w҇\C5G\81W\A7\C81\D8<\C2(@9\B0fX\EF_\AE`\9Am\F8\A7\81\9F\A0\F9\CA<\A8\9EK \CB"\88\00X\8B\DD\F7V4	\86\D1|
\C3ks\A1\85&\90\F3a\AA
\A3\00m)\00a\D9_\9F\BCwM\C4~\86\E1cnRϑ\BB~A@s\84\C0{\B0\81\E7\F0Q/\93i\8E+4^\82B\9B\F9?m)\00`\A9\FBoޫ\FE\8A\8FW\AAg\8B\E1\9A\874Կ᡹\C5뀷\00;\90\B2\C15W\A2=\D2hm:)ƿI\86?\87ᯉr1\F01\FE\82D\00Zm\97n\C3\C6b>o\FE\95uZ;\A6\CAaR\A0D\00D\8C0\F1O\EA\FE\D7\F84\86\AF\E1s\B7z\AE~A@k\81\F7b\E3\F3"\AF\DES9:\85S\80r\9B\C4_\DAN\00\F4\DE\FFkA\F8>aYߍ\94\98SKdQ\D0NB \8D\C7k\817\AF@\CAά\F3m\E2#\B5\95\00H&\FE\C9\C5_\A3)\BB\80\FES]\C8.YA@;\81?d\F0zoΔ\88@ݦ\00f\DC\F6Hl\A0+޿\C8׆\C0a\BF/\A9\B9G\96D\D0I;|\E7\EF^M\98 \FETX\F0B \A0N\A4	{\FEˎo\93\C0\DD\C0?\E5u\8E\DC\F3"\00:S\\8AB\F1l\E0\9F\80\8B\80Y\95\FA\E2\98r\A1\D0\E2	\81m!\00,`\90\B0\EF\BFPo\8A\C0>4\C7p\ADz6%YA@w\818\8A\FF8]\A2\F5e)\80\C9Rk\D7c\B6\85\00\E8\ADD\00d\B7כ\C0\BFb\F8\8C\BA\88EY\A1\DD\83U\8Bz\BA\82p\9A\8BQ\FC1pHV\A5~\C4$\A4\\AD6l\C2\E4?1\FE\F5$\8F\E2*\CA<\97<\FF$\C6_\90@\B7G\B6\C5g\CD\FB\80w\A1\E8\95U\A9\9Dbvl\D5|\C0\96\8F\00\F4\8B\00\A8#>p=\86\BFG\B3C=\9B\BC,\89 @xR\84c\87\9F\83\E6\BD\C0둞k5\980\B0U\9B\B5\B4\00p\87^K\9C\AF\E6m
\FC\F8"p=\F3\EA92\B4G <\D3i\F1.41R\94y3\86נx\95\ACu\F5\B8\95B1 `;{oU\BB\E1\DF|
\F86\B0K](\D9\FD\82\00a\A5B\C0p2o~x\B6\F8c՝\C2s-\DA\A8e@\94pܯ\EC\F0j\80E\E0\D7c\F3#u\81t\F0D\00\D5\B1m\BC\90p\D0\D0\EBg\B1\89X\BE\81\83\A5\F0O\00'\C0"\EC\F7/\AD\AA\AA!\FC\F8
ת\F3\F0eI\00B\ED"\E0hr\BC\9Ep\C8\D0s\91\00\ED\AA\98\F7\C2H@+i\80\96\00q\C2\F0\BF\EC\EE\D5P$\EC\E2w\F0u\A1d\F6"\00\84F\81\F7%\E0\B71\FC\B0I\0Vl\ADAA-'\00\EC\8A\F1\8F\C8\FB\B2\D2\ED,`\F8\F0	u\87eI\00B\E3O\9Em\ACG\F1\FB>ddENLև\99r\EB\94\B6\94\00P\84\93\FE\FA\E4=Y\85\D7p\99\BA\90\FBe9\84nCy^\96\C3X|\C30\	dU\8EOJC\\9A=32\EAwe\F8\C0\FD\F8\FC.o\E3/H@hn4\E0RQ\9C|x)r-pL\96\FCpN@+\94\B6L@\F1d\CB_\E1x\EC\C4\F0\8F\C0\8D\EA"\E9\DC)\88\00ZIlc\86KP\BC8_\9E\D13\AC0\EB\86E\00T\88\86\FEy?\8E\C1c\C0W\81\AB	xD=\87\B2,\89 @h\C5h\80\83ͩ\BCë\803eU\9EJ>;\BAMNh0@\D8\F2W8\9A\E0\D7`\B8E]HN\96DD\00\B4\BEx1\^\BCx	acW\A1sM\8E\B4\84\00H\86\FF%7≭C\98'\FA\9F\C0\F7\B0\F8\A2\BA\80%YA\D0~\A7\D96"\C06\E07\81\E7yu\FD\B3+U\A2\00\C5&F\9A.\00a[)i\FA\B3\8C\EC\BE\87\CF'XbZ\BDX\BA\F8	\82\80vo'A\94\FFQ\89\8C\D2\E5U\C8z0\EDv\B1\00HW\BC\D9\C9\B0\84\E2z,\FE?;\A5}\AF )l'\B5v%y\>\82ǯv,\EB\EAD&$,\88\E9.޽2\EA\C0\C3\F0c\E0\95ު\CE\E7A1\FE\82 \80\CE\F5~\B7\A1\81\E7\A2\F8+/\A7Ko\80
\90\F7a\A2IR\A8\A9\80\D0\D3ջ8\00\A0\F8f\F8\BA\FA5\9A"\00\9D\AF\DC>K\00܉\E1w0\FC6\F0\E8\BE\E5
\88\EB\F0\D3UX\84\E1\FFn5\FEK\E6o\88\F0׊\F1\89\00tg4\E0P8\9CIX)\F0´\B0\AEz\B6\A5\00\C6Jk?(\A8)\00u\84\F7\DFm\81\80}\FC\84\9F\B3M\DD\C4n9\A1:\A4\DB\'\A8\B8/`\80\87\CC\D9M\8E^\BC\B5"\BA\82H%
\90\BAd\D7v\DB\E4\88\B0\D8\EC\E6(c\93\97\DD/"\00@}\82\00\F8\A9\D9\C6\FD\FCͻ\81\E7\E6\89w\F6\EFD\A0\\AF\93ӿ4a\BF\FFn\89\EF\B8\C0$\F0\E1%\D7\F4'\97\92\F8\A5 \88\00\8E6\86\9Fe\B8\DE\FC!wcx+\F0&\E0\:\BCZ\DCQa \E7ӹ)\E0\BAg\E0\CF,a\DF+"\C0\A5\F9\8CH\00A\A8՟:U\Θ\FA,G\F3:\E0\EA\CAq\DA\D1\F4\D9`w\AAY\B0\E9\8EĿB\E5M\BD\F8
0\C13):%\85~\82 @8\91\F8cy\AF~D\8F\B65\A4\ED}\B1ctv'\00\8E\EC\B98\C8\F1\EAZZ"\00\82 @8\B1\B8
_}\8E]\BC\C3\81\BB;\F5wMYaR`\C7y\FF\9D\DC\F4'\FC\F8W`p\E2\00ª\84\C0\E7(?\C2\F0"\EF\F6\D2aW\E6\B6\EA\C0(@\92\F0\FE\BF\D3(?>
\DC\CCjz[\8A\F7/u\F0+\84nW\84}\D3ͻ\B8\C5\CD\C0;\80\F7\D0A\95\E5	
+Ll{ \DEa&/\00\EE\AF|v\AD\C8\E3:\89\00UG\\8FE\F1f\9F\A9\F2(n9,I\ABC^\F0ty\FF\B0\F8>\F0
\E0\C1\AA\DF8%\85\80\82 \00\A1\B6h\80\CA\E6\DD܀\CD픹\F8
\E0W+\BEg\DBא\B1`\BE\9D\A3\00\D1ʧ\FFT\C5ۿ8P\FB\AB+\BBWD\00\F5\9F\C1\00\F3\C0\E7\CC6n\DE@\D8?\E0\CCvZA܂E\BF\8D\87$\A4\DB\\86 G\98ira\BF:\BD\B2"A\80Po1\F0Yv\00;\CC6n\00\DE\BC
l\C77fA\8F
s\EDx\B1ks\EF\BFHع\EFf\C2\BE\F5\8DĈ\F1\84Z\9D$Y\E18B\E0\E7$x'\F0f\E0v\C2b\AD\F6\FA\80\94v	l\D0\F7\D7
\DBG\DAsȳ,\007\96\F5\DDWw\C4@7"\00\00 \00IDAT\E3.\BDH\00A\90\80\D0@\FAI<\E0F\F3\FB܎\CD\D1|\D8\D8N\E2\D1V\90\B1a\A61c\951
pG\93m\EA\FD\E7	;LܴrQZ\82D\00\845_$\8F\C75\FC\86\FFE\98\D2\D56Q\80\B4
Q\DDF\BB2C[\B9}c\EE#\AC翞\B5\88\89\F1\00\C2\8A\00\A3>\C7$\86\FF\8D\CF/c\F8W`\A9]^\F4\9Ev\89w%h\9B\C4?c`n'\DCs9\85\EB(3\C5Ze\\CA\80 Ԉ\\AB?y?Gx\D4\\CA_p\9A?.\A1\C5o\AC\93\C44[\B9$\C0\A1m\DA1-_\C0\E4mP\9E\A6\F4\AC\E1 \D3\00A\80\D04!p\F3\E6m\DCH\9A\BB\F1\F9]o \ECК?/\D0\E7\C0d\FCV\ED"\A3\E5\FF\F2\E30\BD\C6n\82\A5\C7!pÒ\CB5\EE\CC'\C6_D\00M5\AAW\00\B3\E6\FD\N\91\FFD\F3\E0\D7	\FB\B4\DC!\D3U\90oEkm\EF\DF_\84ɽ0uw\E8\F5\9B\E6\96V\8A\00\00BK\81O\E3\BBͥ|íh~x-\D6?`9
\E0\96\C1m%\A0	\FB\FD\B7`VNP\86\851\98\BA\A\ABtV\94+\00A \B4\90
}\C7\FC)ߣ\C0[\81?\C4p!-\D4\CD>\A2\C3H\80\DBJ-\82c\84\A5-\84\F1\A1\B4c\B7\C3\E3ׁ[h\A5
%)̂P\BB\DF!\F5?\9F?\89\AF.\E7*/>\8Cӈv0UFzpZ\E5\ED\B7*ƿU~~\C6w\FF-\EC\FDJ\CB\9B=\E6O%
 \B5\9C\85\82\D0x\9B\F2n6\F0A\E0\9D\84\C1\EE\A63\EFÜ\96\B2UK\CFf\E8;t-M{R@ok\80\C0\83\85=\B0\E7[\B0\B0k\9E\84b\FF\F3\FAI\D9\C4\EC\B2\E4\E9e'6\8A\92\E7[\EAjʲ\CBA\80Ъ"`6\E7\A3\F80\8A\D7\D1\E4k\D7\C0T\B9\B6\B2\C0\9A\80@\83\CD扟\8D\81\C2!\D8\FD}\98\BF\BCU6\F2i\B8\00Px\A4\F9}l\C4a\85]9\BF
\EEB\F1W|\97[\D4!\8C\EC4A \B4\AA\B8\94!\\D8L\DF7\E7\C1\94[}[\CD\A0\87p\E2_\BD\FF\D2<<v#L\EF\80\FC\DE*\F3F	\00E\898{ A\84!4\9E\DE&\C9\E6P|ͧ1\EC\A9L\B7A\80Т\813P\BC\C3{\81ӛ\F1>zf]\C8U\99\9DP\93\00\B0\80a\9A\D6\F5\AF\BC\88\99~\005v,n\BF\86\8D\BA\00E\9B1\FA\F1\893Hs\C24\C92\F0\00\F0U\E0*\F5\D9\F6iW-"\00\84\EED\97\B3	\D8\BCش\D6?Cއ\89ruQ\80\9A\C0\00a\DB\DF5ޅ^\E6Ì\DFC\EE\F0]L\9B6*U\9B\A9\A3\000\D8&\83!\89E\9F\A1U}}(\BE
\FC\80ר+\F1d\A7	\82\00\A1U\85\C0\A5dм\AC\98磑\E7hk\ED\DEM\DF\C0\BCU\98\89\AA\80
\8C\B0\B6]\FF\\98?\D3;\E1\D0\A0\BCH\C38\E1E\84&LG\AC\EA2\A3.\C0b\92\864y\92$*+T\B3\C0\D5\BEF\C0/\D4\E7qe\A7	\82\00\A1E\D9\FE\EBS7qi"\C4"Q\B3foh)\80å\D5ϱ\A9J\00(\C2\F6HkUa ?\F3{\E1\91/\85\B5\FDG\86;\94bCބ Q\F9\C9V%Mj\00MC\8F\93!\83\AA\FB\B8\E9\FB0|\81\80o`\98T\FF\8E/;M\A4\90\D0b\B8Ffǔ)\CEi\D2C>\B1L\80\B5oiDCƁ\F9\B5\F0#kf\FC\8D_B\CD\EC\86G\AF\81\DC\98gP8ư\AE\F2\9FL\D8@ؙ\A0\B1\D9	
M\89\8F1\84\9C\85iHL\E4Y(>\85\E6u\C0ߛ?\E4uy{L\B1\00B7a,\B6\EA\9D=daOiz\D6$z;\C2O\B2n\83\BB) \B3&\EB\94\E79\FC\D0U\8CN݇2+\FB\A56V\8C\FF\B0\D7\C0\D9*,P\ACwƠp\89\B3\97QP<o
\DA\FA*/^\DC`\DE\C5Q怺J\A2B\F7"\9D\00\85\D6z!\8F\F2\EA\953\8F[L\EE\B3)-5\D6F؄J\BC\E1޿\C1\E1\E1R\8E\DF\FE\97\FC\FB\C4=\B8fu&N\EB\80g+\C5\8A\BB\A0\AEIt>q\B6\B3\99\EDl\E0$\CFcm\AF"\AFAs1>f\B6\D1'\BBN -x\A6\FF\B3\94SL﷙=d\E1\95\F7\8Fg\EC\F0:\A0a
#\DDеˣ\F8_\BCb\EF\8D\FC\9F\D2eU}H]cX_\99\E3\B0\DFvC\8Da\F3(\F73\C2F\D9B\84hLta\A5\8C\00\FC\CCl\E3\ED\E6\DDDe\EB	݆\-E`\00\F3\CC\E1\C0\87\A5YM\B9\A0\88\A5
\99]\E77Xi\E6\82\D5'\9E\904\C8\CC\81\AB\80k\B1\B9K\9DG\E1\87\E7<!\EEk1\B0V\E53\AA\C3$\8A)`\E3*\CE\83\C3>\D2\E4ɰ\9B\8AD\8B8Q\E0,\E0	x\93y7G\8C\BB\D4'\E5Z@ \CDp\FFOX\8E\EFT\F8)A<cHdt\CDIƆ\82\F9z*\80a\8E}})\00w\00\97c\B8U]\C4X\83K\BC"%\FA\98\AA\FC\B9\E98#@3E\9A\D2\92 	\F45(ɯV\86\81Wp>y\BEb\B6q\AD\FA,\F7\C8nD\00\C2\A21+\AE\FD+.h\CAK\E1\F5@\AA\CF\89\A8:\A4l(\BBa\A7\C0\BAy\FF\F5\9B|\00\8Fa\B8\C5\F5\EABv\AD\D1\E3YN_\9C|\B3&l\BA\B3\FE\A8\878G\9CI,z\88Ck\90\E4W\8FǾx?\F02\B3\8D\C3\F0Cu\FBeW
"\00aMNacVc)\F2s\9A\F2\92!ѯHd\EC\88A\D5hn\92V\D8!0W\8F`p\AC\AE\DE\FF\A3\C0O\F8\B2lW/iJ\B8\BA\97\B0y\D04\86<\8AEE\E6\88!I\964e\B6`\DA\EEn=
\\00\FC\8A\AF\9AwsI~\AC>\C1\9C\ECN\A1\F3.Ah!\82J\C0j\F1ʊ\C5q\CD\CC~\8B¢\C2\F7jS\00
H\DB\E0\D4\C3o\8D\D7Ej\CF?\DEC\91K\D5s\B8\AFI\C6\FF\89%20\84\E2\A5\98U\E0\CD:\CE\C1`\9D\DE\CF\00=؜ކ\C6\FFh!\F06>\C3<o\98\FB
=$\BBS\90\80 4\96\9A\82\EEnI1󸍎dF}\92q\AA\CE\88iHj\98\AF\C5\CC\C6\E1\84#l\8E\8F\EC\FE
\F8\82\BA\90B\CB=0\C3V\80\C7tf\C1\F2K\E5\E1`\C9\D1\80ig#0\E3\FB*V\9A\D3oZ\98\D63\'\DBS \8Dr+\C3O\CD7\EF\B0w2=p\DAHƫ\FBY\92\E4
\94\ABI\\EE\AE_\BD\9C>\8F\C3߫\F3ȶ\BAj\CB\9E\E9\D91\A1I
\F7̜\B6\85\99k~=\AA\8E\99k\FB"\9A\9B\D6\F3\C5k\D8/\F2\\AD\F5\FF\95\DD)\88\00\84F\BA]`\B5ծ}â\E005s\B0il\85\C8*\FDDTx0S\AE\D2\FB\AF.^\BE\8C\C5\DFax\\9D\D7>\D3\ECL\90_\E8\BF6җ\EDϞ\BB\B1\F8h\CC\E4Ϡ}\E6\8E,\E6\F3\FA\C1\C5\D6\AE\CB
ͬ\ECLA\80 4ڀ\A8\DA\F2\C5
0S\F2q\8F\C8$\F0<\D8?\93s\B0q6\B1\E2\F9
Hh\C8\EAUF\AA\F3\FE
\8A\EFb\F8p6EuNuѐ\C0\80V\CD{\8A~\B9\AC\E6x\E9;\A7\88
nɞ907c\99\F2FNK\BEx\8A\A2[V;gY\9B\BD\BC\BA \F0\89!9R\82\00AX\C3s\D8PC \EF
\CFpg\B0\B4\8F쇅\C0p+\AAp\F4;0QZ\C5\DD\C4\EAF\E9\E0\E04?\C0琺\B0\B6>D\A3qKͺA\CA
L\93\9E\A4\C1\F8\BE./\A9\E8\F8\9E\AC^\9C\86\D6o\C8nH-)\87b\AAe\84\80\C5b9\CF\CCҜ+ϫ\AD\AE\A7Rƴ鵅 \88\00\DA\AD\AA5\FE\81\81钏g\8Em\F4|&\A6`fG1\EB\FB \95:\F1\BFQ\D5P\\89Yք-O\EC?\C08\86+\F8w\AB\A8\8B\C5\F61\BA/\A2\CFT\CE\C8{\CD\81\9Bwr\D3\CAٗ/糃C\FD\89\A5\A1\B4\8F\942M\F3\B2e\DFc\AA4\A7MvV\A5ܢ\8E\9A`\8D\C64	\82\00A8\D6\D9\\9D̺%\FF\C4_j\B8\EC\9C \B2\A9\F5X\C4+\FB1\A4\80]\89^I '\E8wg\80E\E0?P|\9B|W\BD\8E\BAZ\E8\9CkTT%ӎ&e+܀%\CFP\F4\9B'\BC|61\FE\B8\C5\EC|lqq\9D\E5e\A2ž\84W\C2\F7\D7r \8F	SŬV\85E\E5\95\E7t\D2\94]'\88\00\84\E6S\F5\9D\F7L9XU\DC\DC\00^\98&l֓\C76\DEQ
	\96\8EWh\86\FF\8F\DD \B7\80\E6^\E0_1|\ABQe}\FE\93b\8A\88VE-\92v\C0Bِ\F3\BEi\96\F0)/.e\F6/:f|(\96\DD:Bv0m\A7V\D9ŘF2F\91u\8B\A8RV\CF\E4&\AD!\CFg\8Bl7A\80 \B4\8A\F57cXU'?̔}\CA\D5\DCwۄ\81\F8<ag\FD\D0OضW?-2A\AFv4\C7]\D0s\E1E\sg\F3.u.3
\8E\A2<\8D\84\A5I\C4a\C15̗}\8A\BE\C14\EDI\BB\AA4\E5fvOY\99\83\FA\E7\CE\9E[\EAM\98a\8B\C0S\CFy\F0\82\00\B7\B4\A8\F7-\8C끲\AB\CET\EDS\95 "\00\89\00Ӕ\98+\9B\FA\FC\CBK!\90\9Fṇ\95\B2\C0\ACw\D4\AA\AF\CF\F0}\8B\C0\83\C0w)3\C1\D7\D5\8D5\FE'\A2\C7Qd\9B\85r\C0L\D9\C7
\9A\F9\D3\F8,\9A\EA\BB\E7\B0\EE\D8:t\E0\8C\E1y'a\95uI4@\B1TT\8F\E5٥|\9Eg\81X~A \B4\A6\F5_e```\A6\E8\D43\A4\DE\D0\E7y\B2\EB\FDр^;\9C\E8-N\AF\B2\93\8ENi\F3\80G\80c\95\FFo\8D=\A7\80\DEH\980W\98[\E5\F5I\DD	f\9D\D8tǡ\88\DE\DC;~\E6HI;\A60\\83\BD\F6\BD\80G\B2c\96\9B\9B\D7g\B5\E8BA O\00\B3\9A2\C0%?`\D1mP \DBf\80,\E1\B5@\E5n\DFV\90\B6`>8"^\91`yhn\C8!\E0F`_\E5\EBC\AB\ABZ\CD\FD\B4\B5b0f\91v4s\E5\80E7h\E2\B5\00%WM\EC]\99\9FJ\FA\C3\FB\A7\CF\E8_\\C2\F7\B6\AE\EA{hv\E6YVvAo2.\E3/"\00\84\D6'4\90+\B2An`Xt|\8Fm\FB\F2MUyoh\E83a\BF\AF"╟}\B8\B8\B7"\CCӾ\9Fj\C5%\8FY\8A\E1\98E\C6Q̖ò\C1\E6\83	\D0\C5\F9\82>X(\F5Υur㖁\B9\8D\89Y\8F\C0G4g\B4[\9C\D1#^Q%C#\93
A\80 \D4\D5T+\B7;9ϐ]\ABl\C8\DE\E7g\C0J\85\F9\00\96&\BC\AD^\B6\B7W\BC\F7\A7\B1$m\8D\A3y\CF0[\AAK\AC\AC>A\C9w\B2%m\EF-\F4|\BF\AC[\9F\9A\8C,\C60A\E2\88u4\C0|\A9\A8\A6\B2\93z\B0\BC\A4	<2F\CE6A \B4\9A\95\E5\00*\FD\FE\D7\8Fp0oz\92\95\D9ŏ\B3\84\BD\FCN43\C0\B4\BEG\D1
'\A2\88Ya\FF\80\9Cgh^G\C1@\95\97\F2\B1\F1\BCf>绣C{\CDB&\EAE\8C\F1\BDrQe\F3:\E6.\E8h\A9H\9Fx\FC\82 @hS,\859\D1	n\80\ACPhVSF\EC\E5\A6@\BB\81\85\F5\9A\A8\83o\B8,\BB\F3\9D\C8\ED\C3\8A\AB\FE\FA\E5k\81\88\B6Hن\B9r\B8\DE\CD\EA`L@a.\DB\F3\E8b\94\F1!=\BDu$\E1'\F1\CB\EEX\A9\9C/\EBe\90\DD#"\00\846Ƭ\E0\FE\C9X,-\F1ê\D5\F458
\F0\FF^s\8DN֗\FF\B5\FB\86F֕w\DC\C5\C8\FE\89.쮪\E7\AEV\90\B4q\CBb\DE
\93KM\EC`\FCK\E3>\ECo,\8DF4\F1\D2ᨸ\FC\82 @\E8\00\FC\80\C0̱\DC\00ߴ寧\B8\FAK\D7d|\C3/\FF\AC\B5u~\B1w\9D\DA\FB+\AF\E5\D0igs\F2\9D728\FD8N\F1PU\DF[+\E8\8Fhz\CDL\C9g\D1
\F0\9A\F9,+h\D6'"\00\84\E2\F8\F61[\E9io\DA\F5\D7k@\C0\DF\DDr\AB=x\E0\CC\C0>	\BC\88\F9\F7őS\D9\F9\9AS\88\DE˙?\FD
}\B3{QU\AE\A0\A5`8f\D1\B1\98.zd\DB\F9YB\97#Zh-\FB\A8\8Fm"c\98u\D3\D6;\AE\AE\E0W}yˆ\FD\FB?\AB\FC\E0V\A3x\D9\D1\C6\FFI]\A5(\AC?\85~\E32\EE\BB\E4\8F\C8FS\D4b\B9#\D6'l6&-\B6\E1A"\00\82P\AB\FFo\8Eݐn\D6mf6zkE\00>\F7\A5\AB\87le\FDw0\EFF\8Ei\F8\8F\BEen\EBy\DC\F7\E6\BFg\E8\A1\DB\D9t\F77Iz\C5\EA\9E\90\B44\B1\B8f\C9\98-\BD\8Ct.\F0eT\B0 @z\D6#\A2\EC\98+\F9\B4\BB\FD\C7\D4u\BB\EA\AA/ف\D6o@\F1^\E0"©\AB\FB,\9Br"\CD\E1^\C2\C2\D6g\B1\FE\C1[y\F0{DMu\89\95\96\82\8C\AD\89iE\CE3̔\FCv\CD\D1x97 뙘\B2\CC\E9\B2;\00\82\D0X\F9\B4V\C0:ǨTY\90]̪o\\F7\EDWJ\FD:\F0\E6\8A\E1\AFIL\B6Cn`\98\BD\CFy)\8B\9B\CFc\F0\B1\EE\BC\BBʻ\81\88V\F4GQ\AD\C8ymz]c\80\82\90u
y\CFP6\86^K\C5es
"\00\A1\F1\E7\EFS\CCF)hRӟ\00W~\E9KV\A0\AD\F3\FE\E3;׿\A5\DF\9CD\9D+	\82D/[{\99\EA\EDa\C3\E0(\83\8Fm\A7\EF\F1۪N\.\8C[\8AE7 \9E1,\B8\A1\F1/V\A7V\ABO-"\00\A1:<\F5@\86\C9B\84\FE\9F\947+2%W]u\95X\F6\80\81\D7`\CC\EFx!
n"\F4\8Ep\A0w\84\A9\E1Q6\F6\AEcp\EF\AD$\F2\93\A8*\9A\FFhG?!=C\D9o݊\DF@!0̕|\96<\A9kD\00\C2\DA\DB\83Q\95;\800k\9A\D7\F1\AFI|\F1\9Akb&~\F8c\E0\B5j\8D\ABu\8AÛydx\E3[Og뽷20\FE \96;[\95\FAp\B4b j\91v\C2k\9C%\CF\E0\99\D6y\9Eƀks\A5\80/\E8\A1)"\00\84\B6\C3z\D2G\F6\820\A1\AC\A3\CE\E4\E3D\00\BEt\ED\B5\B6\82\F5n\FC\A5Q\FAm@\AC\89R\8C\DC\C63ر\F1\FAv\FE\94S\EF\FA/R\C5)tP\A8\EA\BBE4\AC\8F[\94\C3Dѧ\E0\9A\AD<cX(\87\D5\BE~A\80 4\DB>\86\F6ޘ\B0\E9O\B1\D3Nf\F5\CC\DE\FC\BF\FC\E5\B4\98b\CC6²\BE\96a\EE\EC\F2\8B3.f`ǭ\9C\F1\F3눖窾\8B\88jŦ\84͒0YlδAC\98\DD?Y\F2\E9\94\D4A \B4=\DA'\C0`\8A\81a\C1\EDH\B7\EC)\B6\F3\EA\AF~%x\C1\DBL`\DE\9CDZR\98Y6\D3\E7\FD7r'\9D\CF\F0?fˎ	\BC\AA ek\E2I͢z\E0k\D5ߡ\E8\A6JaB\C2\FD\82\00Ah!,\85)\90\F3J\9DwB\AB\E5*\80\AB\AF\BA\D2q-\E7b\DF\F5?\9C\B6\BE:\B3(f\FA9\F4K\AFb\FE\CC_f\F4\B6o\B1\EE\D0=X5\F4\E8\8Dh\92\B6b\BE0\DF\C0\B2\C1r`\9Ef\E4H\FBbA \B4G\F3\9D\FA0\94\8A\BA/q\C5wn:\D7\CF>\F4m\CC+\81\AD\ED\F6k\F8\D18\8B\D1Q\8A/}+\B3ӯd\F4\EE\EF\D0;~?V\95р\88VF-\96bѫoɧW\93\8Bn@!\A8%\EF@)\91
\82\00Ah %\9Ew\CD>c̹
\9C\8E\B1\FDJ\FDD|\F1\F0I\A3\97\A8\B1\EF\FCn\90:\F54ݢ\E1\FE\95\9A\EEr\B2\97\C9D\F3\C9\DFdt\E2W\DA};\99\F1{\AA.(H9\9A\B8
q+l$Tk9^\D6
\C8y\86\ACP\AD\A4P
t\AC\CF\F8\FD\C3Ӱ[6\A8\D0QX\B2B+\F1\86^ӣ\E0\BF)\E8
\91ڨ\F7\D4\F4E\A0?\D2\C02;E\C9M&\CB~O̥b\E9\C4Y\A3\A4\87\CBV\D4*\DA\DD\E6\)\FCDC\A3̥\FB\B0\E2\EBЅ9"\A5\\D5B n)bZai\85ox\C6k+\D5K\CARDJ\8BGY\C2\C6Q\F3\E5\F0\AE\BFXe\EF\A8X빛T\CF\D7\F7\BC\E4\E2+\AE\BB\E9\FE\AC\ECPA"\00\82\D0({\A2\C3(\E0\D3\8A(U\F4\BCo2A`G\g\A94\98\F2U\8Ctқ\C88\B9=$s{\EF\E1፿\C5c\E7\B3M\83j\EF`\87Q\8A\FC\A63ص\F14z\87ֳ\F9\91\F4\EE\BF۸U}\BF\A8\A5\B2IK1\EF\E4VP\A3\EFW*G\E6܀R
WHʶQ:>n\F7\DEY\BF\F9\E3\E9曹\E9Qٜ\82D\00\A1\91\FC\DE\EB\BC\91\F0n|Œ\81ݕ\88\80:\E2Ӳ\00\A3\94\8F\A3\F9\D1\E1\C9`Pg\92z\A67\E2\E7\9E"\B6#~\89\F5s\F7\B2a\EEr\89QJ\91|m\D1\E0fk(\8C2\B9\F5t\CA:A,\EBq\8En\F0\B8b\ADH9\9A\98\A5p\F3D\BD\FE\91\80\E5\DE\FD\93ŀ\B9j\FA\95R\A0\CF\E9\E9S\A7\9E\FFG\F9\F7|\F2#/\BD\EC\AF\F7ɮ:\D6\E1\92%Z\89\9Eǳ\94\E1\E0\EC\A3\DE\D4C\F6\CF\EA5\98\C5?9	\A7$\EB(\84\95\F2\96\D6\F5\ED\A1\9F\93\EEbT\99\97\CA\F9\DAa<s\F7\9C\FC&f\92[:j[j\B7\CC\C6[\AEe\CB\EE\9F1\E5\DAB*݀\A9\92\8F5\B2\85\91\88&6s\80I7`\B1Ԕ\A2\A7\94"\92H\8A'_\F0^\FB\82\BE\E4\CD\FF \89\00B"\00\BF\F5Wi`#\F0(0iq\A5jN\A2\AB[\C0h\B5T\E8|\F1\94\E1d\8F\9EX\F1\8B\F6J\BD^m2\C5qN\9E\DAN\A68\C9lr\D7Nv\C4\F34\96\C5\C2\D6\F3\99<\E3\F9\E8\F9ҋ\E3UR
b\96"\E3h\B4\B6Y(\95\99\C9.\D5\D4*\DA\ECԀ\AB\B6\9E\F6\B9blݯ\AAK.\BC咷R\D2\FD\89\00B\CBD\00\9E\C4\E0\B02\8C\E2d ڴ\80f)\DFח\FA#v\C2̤\B0\B4\AD\83r\D5\FB*\D0\E7Tv\AF\BF\88\87\D6\FD
\AE\93\EEo\A3\\A4g\EA \A3\B7]\C9\F0ԡ\AA\85\00@\87\89R\80W*V\F9؀DO`\A7{\BEA\B2\EFc\D1ўG\9F\F9Os\B2\85nB\92\00\85vc9[n\D8(\CA\C0\9C1d\95\E2\D45\B4^1=0m\88\DAv>c\A9\82\D6x5\8Eu\E0\92,=\C4\8Fb4;\CB#\C3g\B3w\E0,\8C\8A\B5\FD\83\F3#1f7\9CB\FE`z\F2~\F2Ez\8A3U=\B4pBau8\BCC%㟎D\9D;/\FE\CE\FD{e[	"\00\A1}HT>y\BA\92SFQR\86
4xz\9E\89M\F8Cє\8E\F91\E5x1'(E1\F5\BD2\B6\82EFfo\A0g\FEv\86G\DF\C0\BE\FE\939\9C\D9J\FB\ED\C5t\E3\89$K\E9?ap\F20\A3w^K\B44\D7\F0\DF̲,\82\C4\C0\946\C5Q\83}?x\D1ww\DE-\DBH\E8f$@h)\8E\93p\BC\88@
(\A1\F0\94?\CE
\84\C0jr\00|߉,\96\86\D0=\E5\92I[\A9KI+(ڍ\EA\A708\A6\C8\C0\E2}\F4\E6\92\E4\D7J\86\E2팶('{X\E8d\A13:>J$;\83\ED-\AD\E8\CB\CBhr\BE!\F0\FD\AF\A3\B6P\F1\F4\B4\AD͕\91-\9B?\F1yW\BD\E03\B7\92\DD&H@\DA\A80*\FCX\A5߾!\A7\9B\A8\D1m\F6\C7q\FDD\C45	\F2偸/O\8D8^a
=\C3`\F6as{Xx!\8F\8D\BC\88\FD=\A3\B8V\AA\ED#Ɖ\B2p\F2yd7\9E\C6`\DF y\80\D4\D88uUJk\B0\ECEm\C5\EE\8F|'\BD\F5\8CO^\F0o7\F8|}\87\ECA\90\80\D0\80\A3\A5@/\D0L\00Y\C2v\BB\E6b\F7\B8\00\83\F6\88Z\C5R_&[I\F1\C8\FCH̛oj\FB\DEL~?fn#U*\90Kl\A4lE1J\B7\FDs7\96\CD\D2\F0&&7mE\F9I\A2^\AB0qLys\BC\80R\A0\94\85\8D\88\F5\F6}u\F1\AF\FE\FD\97]\F1\93\9F\\FE\F3G$\BB_\8E\F2\9C\A1eXA\C0\AA\BCw`_E\9COx%p\E4;\AC*\00\83R~\A1\B7\EFpy\BDO\B9A\CBϷ\DCZ\9C;7\BC\96ݣ/\A5lE;j;ۋ\9C\FA\B3\EF2|`\8E7\F7\B4\BF\CF\9B\F1r\80W*=\EDH\B3m]\B2\D2C?N\BE\E4\EC\DF{\CE\DF\DC4-\BBJD\00\DD'\00\96q1<\8E\A6\80\E1\9C#\DE\FBg\00\A5TbWa\CB\C0H\D2_\E8u\FCŖ\DF#\F3\89\ADܽ\F5\F5\8C\F5=_w\CC\FC$\94	\88N\E4\B4/gpn\EC)a\9Ag\00\96\D6X}#{\EC\88\F5\BA\E0\D0\E2\AE\EE\\8F_\8E\83\-E\CDW\00\C7z\CF=\C0\901\ECR\8A%\C2\C6B\EA\89+\00\85\E7\C6\E2\8FM\9Fu\9A\9B\8C\CFo\88\F3	+(\B5\85@\8E\B9\F3l\9E{\94\CD\8F1OP\88\B5\92 \80Rx\89\D3g\BE\90\85u\A7?\F80\B1J\EE\C5S\AE\00\B4\C6I\F5ΨD\CF\EB\A3	\E7#\C9\DE\F8\E1\E7\DD|X\8C\BF H@\90\C0S(T^\FC\83\9E!vf\8C\CC\E6Ѥ\9F\EA+\C5\EC\E9~ˊh;\C8:\ED:\FB=;\97\C3\FDgq\FF\E8E,\C67u\CEAD\F29\86\F6\DE\C7\C6;\BE\8C\E7y\CC\FB\E0\F9fAGS\9F\88\D9|\A3;}ϋt\9B/\BBHV\86T\DDF\C0\C0\B0\D6ʟQ\BDC\F1H"6\8B\E5(A\B1\AD\B9Dq[&v\92r羡Wp\B8\FF\B4\8E\88\AD)\A52L\9C\FB<J\83\9B\DD\CCC\BF\D8\DB\F5\D3\EF\AA\F4\C3ț\9F\FF\E3\E7\BD\FFz\E4\BA_D\00\E9Q\CC]\A3,\BD[
&\86p܉\B6\FE\A5|\9D\A4\E0\A7ѻ\A6o:\CD\F8ŧ`T\C7\DC\F4\B9\DD;v\F2\9F\EFI;?\BDt\C3\E2v\F5\B1\8B\DCy\BD\BC͂ @V\E3V\ADff\98\99\B1\98_7\C8\D0\87\8D\CE\00\E9H;ȁi\9Fk\00\A3\A3U\9CR1B\B6h\E3OQ\A9b\C7<)`F\C3\D7"\F0\95?\D3o\DE\B0M\DE`A 5\FA\CD\F8\E3\8C\8F+f6mf\D3\C6\EB\95ELЦ\D4\DA?\BAҸ&Aя1[\8Ebs\B1\CAX\D0\A0\C2p/\86\88:\F6M\BF\F3;\BF-w\FC\82 @\E8`\9Atimp\EC\E7у\9ACg\9D\C2\E9\BDy\D4\8E\F2\C0x-\B7H\81\8APR\D3\C1\FE\D8\D6\ECd'\BD%\E0 \F0\8F\AE\E6\9AK\F7-y\D9\82 @\E8`\9AH)\C0	\9A}7\A5\9D{\D8\E18\C4\CE\DE\CC\D9}\D0\E7>Z\D3\F8ں\C7,\94\C3X\E4\CC#S\A8\85X\A6\A3\AA\DE&\80+\E6So\EB[gdW\82\00\A1\80c\9Dگ\D5@\D17̕}\9A)\8C\EBR\D8\FE(\F7\C5\D3\F4\9F\B6\81S\FA!]:\D8\\AF\DFJ0eQ8\E0bM=\8A
\82Nz\FCy\A5\F8\96\EF\FB\FF\C3sݱm\EFx\87\84\FBA\80\D0-\B8\AA\DFA%mM\DAQ̔|r\AEi\9E\EF\FC\A5\D3;,\A4\A2\9F|
[SsĽ\D95m`,\9B9\BD\9E\A59\C6'\B1\8A\86z\8F nf@\C3\C0\CD\FE\B8\EFo{[Vv\82 \88\00\BAC\98\00\A0\81\98V\8C\C4,2\B6a\B6P\F0\9B%L9\A0<\E73\B6{\86l\8F\CB\C8\C6SX\EF\CC13\8D
\F4F
\B9\00w6\87\C9T\D1\ED\A4G~\F0\F9\00\BEf\EA\DE\F2\D6@v\81 \88\00l\A5H9\8A\A8\A5\C8zY\D7Pl\960Av\9E\85\9C"\CB\B9\A4a\B0o\C3N\CC\D6\FD\9F\CB;\EB(,\B9s.~\D6E-\E6:\A9u\E7n\E0\9B\AE\F5\BB\DE\F9\96\B7\B8\F2\B6\82\00A8\DA	&\A2\FD\8B\84eXtr\9E\C1mV\82\801\C7\C3abk\8B=\D3\F4j\E5/\D4\FC\DBzV\9A\BCciAQ\9E\B58\D7R	\88\B5\AC\B0\00|\D4w\F8\C1\DB\EFz\F2\86\82\00A8\A1\88[\8A\98e\AFD\96\BC\A0\89\89\82.\FEc\93<\A62L\9E\92bc\BFͰ\A3\89\E9,*X\BD]\F3T\9Cr\90 [\D4\E4gb\D8Sh:&"^~\8A\E1\B3}\BD_\F8\C0\AF\BFZ\BF \88\00\84\D5\81\8C\ADI\DB0WV,\B8e\BF\89\89\82f\91\FC#\8B\EC\89Ę8}\94S2=\CAǦ\00\FC\FF\ED\DD{\90\96U\F0\EF9\CF\F5}߽\BC{\E1\A2\897\D4IJ*/\A3n\981\88JB\BBk\84b3\CD\F4\87\E6XN%\96Z\EA\E0h\9Dql\92\AD)\C7L\D3T\94\BBHHIS
pWX\D8ݗ\DD}\EF\EF\FB\\CE\E9\8F\A7\94\C9\DD\F7\F6\C2\F7\F3\F7^\CFs\9E9\DFs\CE{~p\E7R\85\00\00	\B7IDAT\E7\D3?Ȯ\84\8D@\9BH\87\D5H\E7c\BB\DBa\EA\BE\D1\F2\B8<t(\8D\DF!\FC\CE5M\BD\EC\C1D\00De\811\B6D\B5%q\A0"\E9)\E5\B91\ED\90|{\B6Y.\E23>\83\D3E'\A2\E8;8\8Bׇ\FD4R\B2Ɍ\ECꄡFͅ6@\C0\FC0\B8\EB\FAŋ\DB\D8c\89\00\88\8E(C\00\F5\AE\81\B8-\91(\86H\E5\B1A\00\DA/\A0w\D3vl\AD\AE\C2\D8i\93p\BA\9D\83\EC\FF\C4\D7e\9Dq\E8\CE\DA\EFf \8B\A9\D1\F4H
\006B`ْ\E6\E6-\EC\A1D\00D>E\A9\95\80m)0>b\A2\DA\D2Hx
\F9`h\F7σd\9D\CF"U3\A6\9E\84\93\9CL\AFE\AB\9D^\E4\BF;a\E4{\81p\D4\EC\F3+\EC\95\F8\AE
\ADM\D7/\F9z\86\FD\99\88\80h`\B3\F9Hm\A7\A7Sya\BC\94\EF\00b\A6\80-
\E4B\81\EE\82B0der5\E0\87\C8w\F5\A2-o"QW\89\86\86i0\DBځ|t\BE0Z\8A\F9h\00\BB$\F4]\80X\97J\B8\DC\F8\BD+5{3\00р\B5Omx\C5ݕ]\EA\CB\C8\C2h^c\A8|I\CB\96\AA\A5\84#\B2\BEB\AF\AF\870\F8\D2>R\88@\BA\F5=\C4p\BFep\E0:\00\FCYJ\B4\9AR\FF\AByQK\91\BD\98\88\80h\D0\FC\EE\9Fy\00\CF=\F2\B5ڝ\E7droG}\85\AA\A4\F2J\BA\DF\D65\FAW"\A6F\D2W\C8
CVP0TP\F9bt\\DC\D3`\83\BAUkl\\DC\D4\D2\C7\DEK\C4\00@T\B6k\FFڶ\C0\F2\F5\B3&m\A8.\A4\AF\8B\C6\W\C7I\AD\BD" 5\C3@4H\F9\FDe\85\A9K\A1\00\BC"\80ga\AC\B8\A6yQ\9B\84\88\80\E8\88k\ն\C0֍WM{\BC\A6\AB\ED\96*\85\CFK\8CA	rT[\A6@\8F\A7\91	\8A!S\C0\00i\00\EFX\ABBqW\BA\CA\DE{\C3\FCl<"\00\A2\A3\EB\E2'\B7\AF\B0n\E5\FCS\96N\ED\EE\FC\81\AB
%)\E5&C\D49qK\A2\AB"7\94\DBGq\B4֞\A4~TN\00k4pG(\B0m\E9\E2&^\D8C4
6\8D4o\CC9\C5\CEx\99\9B\F2\B9\EF\BBa\AEZ\94я5\80B\A8\91(*d\8F\F2\B1A\8D\A3\AAa\C6\D8yT\8F\AF\FBoO\CCU\D4b\F7\B5ˡ\8D\92s\BE\F0\9A\92b\80u\D75q\E0'M$\9B\80F\9Aϭ|\CF\DBg\CA{z+\A6\9E\DAYQw\D1tK\AE+\E8~\81\A2&DL8\C6\C8\CD\C4J
!\DA2!z\8B\FDw$\94\F8\DF(\00\BB\85\C0R\DB0\B0\96\83?\D1\E8\C3-\00\91>\B7W{\BB\D7^v\F22D\9Db\F4\D7U^\F2RaIc\9E\00Pi	DMi_\E1@1D0B\B64\80\B4\AF\D0\EB)ʿ!\AB\81\9F\9A\C0\E3
\F8\B0\F9\8B8\F01\00
?3_ܙ\B0㥅Ӛd[\DFt#:\E6\F6X1\FD%\A1\BF\FF-\00\98\88\DBC \ED+\F4xjX_ě5z\8A!\F2J\A3\CC\8C\BC\E2a
<\E5i\FD\B7k[\9Ay\9E\9F\88\80h\F8\BB\E8O\DB\EB\815\ED\AA\BAgt%셑\C0\FF\A2\D0^IA\E0P\FD\00\D7H\BCzx8_\F5\D75H\F9^y\E7sx\C0#\D8\F8\CD\E6\A6N\F6&"\00\A2\A5\D0x\E2\BDtͻ\E1\CD-\85'ߙ\92+̳\B41\D7Q\DED\A1O\A0@\A5%\E1C#\F4\D7\CA:>\81\D2ȅ}\DE\C1\BF\A5\8C`\87\A2Uh\FD̷Z\9A\DFc"b\00 \D1\EA\9F\FE\85\F0\E2\E6\F6\EC\EA\F0\FA3\B6\C4\F3\BD\A3\A1\F9eC{\B6(aȴ\A4@\8D-3\C5G\B3n\FFW:tZ!\E9)\A4Un\A3\DD\00\D6@\E3\97\ED\C7o\FFIc#\CF\F31\00\8D\E7\9D\D3\00Zo\BBs\F6g\BD\BA\FD\E6xr\FF\E2\A8S\84\ADR\EA\D8R\A0\CE1Paj$
!
J\93\FA\9E\D2\C8\89bX\EE\EF; \80\B7-\EE0*ݗ\97̻2`/!:~\B1\007\B6}\F5'k\D5\F5$\B8\F0\A3\BA\E4c\B0@6\D0\E8.\84\F0\D4\C0\96\E2[@\C8\F8
]\85\D2N$Xc\EA\F1\E1u\CBf\81w\00,\87\D6O,ii)\B07W\00\E8\B81\FD\85=E\00K\B6\CE:\ED\87i?\F9\F0\98bv\96\A9
%\BD@\85)\8D\99Hz
\BC#{l0htC\E4ʜ\F2AБ\B5\9D\87\޿\A4\B99\C3^@D\87\B0wf\ACڱ\AFOʫ\B1q%\9C\F8V%\8D\92GY)\80\B8#1\B9\C2\C2Xǀ\E5-\AAyJc_!D{.(k\F0Rnl\8F\B9\BF\F3b_\D7\DF\CD\C1\9F\887\91!:n\BDz鄉\86\D4_\A8*\E8c\C1\81\F1\E5\BCJ\9E\D6\E8)*\A4\FDO\D6\F8[\00@OQ!(xe\FCR
\98f$\B7\F2>=\B6zE~\D2\CC~`\8B\F9\00\D1Ǎ\FF٥\D6\EF_\DB}\F6\84\EE\8EL;\FAc\D7O׋2\D8)
dC\85>O!\FB_\FB\87\00@\CAW\C8\BF\F4\A2CR\000m:\CEc\86R\AD\A2\F1\BC\8D޳\9A\C5|\88\88\80\E8\D3<\DE\D8`WD\EC+&gӳ-\CEu\94W]\FA\E4\D9Si\BF\FF\DA\E1|\A8\FF'\00\F4\EBSH\BC\96\B8\9C\CF\CBѦ\C0JӲV\D7N\AC}\F6\8C\BF|\B0\8BO\93\88\00\88\E9\D5y3cH\BF\F5\ED\B1\BE\B9\FA\978\DA7PƊ@.\EC\9Fݧ\ED*D\EBP\D7\FD>R\81F\CA\D7(\94\B3\DCoZ\B1\DDrck+\A3N\EB\F4u]\DB\F8\F4\88\88\80\A8L\CF\DC\DB\BFr\CD\DD\F1 s\89\ADp\96\80_\FA\FB\A2\81\B4\E1"\A9\86\EEڋ\U\FC\A4P02\D7\DAbTV\DF~\FE\BA\FD\F9\B4\88\88\80\E8\FBU\F3\99\93.\DC\DF{_U.q\89-E
\B4*\E9\BD	!\B0/4\91\C9\E6J~]\85D\C1\96\E6\BEh]\DD\ED3Vw\B4\F2\E9\00\D1Q\B4e\F6d\918\B5"_x\BA\B6\D0s\AA,\A1\88P\89}\CAD&\93-\E5E\D5Ҳ3\D1\EA\D8\85\EE\DE[\DFAȧBD\00D\C7Ȫ\CBN4j\EC\E8L'\DB\FD\9B?{\A2P_
(5\00H\C7	\A2\A6\B9B*}[Řh\E7Y/$x\AC\8F\88\00\88\8E\B5Ms\9BE\90YU[i\C7Z\DCt\F2\E7Q\9Ds\F2"
6\00\98\A6\A1-\D3~I;΍\A5ޟ\B19\95f\EB\00\D1\BB\F5\A1\AB\CC\F9\8Fn\F8\ACa\8891_\FD\C8RiK\81\00 \85\80i\BBm\A6\E9\DF$\A3\95\9B\CF_\DF\DB\C1\D6&"\00\A2a斖3j\E7w\F65ƽ\FC\E5\96F\93d\ADR\80\A6i|h\EA\E0\91\AAx|mU\8D\DA<\E5\A9$o\EC#"\00\A2\E1l\FD\9C\D3&E
}\CD5~a\8E\FA\E7\9Aʷ\00\84\940\A5\E8\AB*]\F7\F9\AA0\FB\D8)[\E0\B3E\89\88\80h\D9t\F5\F4\A9\91\CE]7W\86j\A6\A5\FC\93\C5\C1\EC<\00\F4\DF$\95a\C8M\8Ee>\8F\D7\DFw\E6\EAv\8F-HD\00D#أ\8B\CE>\EF\EC\BD{\F93M\E8\86\F8(\00!\B4!\B0\C7v\9C'\D6V,\9B\F2|\82\FB\FCD\C4\00@4Z\BCyY\83\EC0\EDy\93\B2ٻ-?7\B9[f:\93\F5*#\EE\DBF\D8\EC\F9\FE\BB\E7\BE^F\9Da""\00\A2\E1kì]\DBZ,\CFk\B2\B2}\CB\CEy#|\85\ADBD\00Dǁ\CD_9ٰT\C62\FBr\C5s^Os\D6ODDDDDDDDDDDDDDDDDDDDDDDDDDDDD\87\F3\DE\D4\E1D\87\C9O\9F\00\00\00\00IEND\AEB`\82
EOF'

cd /usr/local/share/icons/hicolor/64x64/apps
sudo bash -c 'cat <<EOF > duckstation-qt.png
\89PNG

\00\00\00
IHDR\00\00\00@\00\00\00@\00\00\00\AAiq\DE\00\00\00bKGD\00\FF\00\FF\00\FF\A0\BD\A7\93\00\00\E0IDATx\9C\ED\9Ayl\D5\C7?of\F6\F0\DA\EBc\9DÎC1BB\80 $$\AER\A1\B6\B5\DC\95C\A2\B4) H\89C\E2 \88mC۠\A6*(\E5jZD\A9\E3$IJq\80ā\9C\8E\93x\ED\DD\D8\DEû;;\F3\FA\C7x\9D\B5w\BD;{$\FC\D1~$\DB\F2̼\F7~\EF;\BF\F9\BD\DF;\E0\F1m\90B\B6S<\CC\C1\E0.\B1\98\8DG\A3\DDo]\00)QXǵH\9E&\A5.E\E1nq.{\8Fd\FB \D7rp\82eb!o\96Ҹlg1\92\E7\80S\C7y$\82\E4iL\9E\E7+\A5\AD\F1\B0-\80lc\82g\81\8B\D3J\AFA\B2D,\A2\A3\90Fe\C7 x\B8\CEf\91.\88\85\AC,\A4;\E4@n\C0\87΃n\D4,\8F\98\C0˨\DC-\E0\CFY\D7&<D\B8\C1\BD\80\BBk\8B<w\95y\88=\CFf\D7tf!q\E6\A8%A\E2\CE\CCv[J\EB\F8!\92\A7\81iś \B8\94\BCtP\BD\F7mz?$!\E3Ga\00\89\83*\AA\B2\95\97\EB\98K;됼F\E9\9DO\D9|\DBd;\F7\CA/s\BC\9B\95\E5\C4!\D0+\93\88\AE\F7\A9\E9i\C30MB\D6
"h$\A8\C1\83@CO/'\D71E\B6\B1\93O\80sJ1r\EA\90<A\80\D9\C6w\8A\ADD\B3Ւ\A1$D\A8\91\B7\F0N\9CA\C0;\83z\C0\92\B0z\F4\F3\D1\C7\F8a\FE\80\A0\B6X\C3
\E0D$\EF\CAU\BC".\B3TG\B0%\80"\A0\CE\81\E1w\AC\F7\A5\C3Z2\FC\A8B\B0\A8\E7j\EB\CF\CDS\A8I\A22D\95\D6b\8A\E7\FDRTk\E02@\E5\E1e\A7˵\B4\D1\C8/jt\D8\FBlScZ \84\9F
\928Q\89WM>A\EB\F8c\EE\D5px1\F1!\D8,p+P\A9B\B4v\BF	\83\DBm\B5f\C1\00Tx@E\F1U\E57)\C8\C0 T\A9Z\C0X\EE\9D N\9C(M\8C\C9|\8E\C3\FA\F4};߀!\BF\ADV\B3\A3b\88$}\D4`_\AB(\A1>;E\C5\EB$\C4r\96\A1s\F0b\BDc\B8\E9Z$I\89\E0DǕ\AD\ACC@u\BA$\AC\83}\EF\81\C7~\AA'N?^\A2iqK\A1\98tj\B6\B5+\D8/\96s\AB\AB\85\AB*\A7\C3D\A3\9A<\DFw\9D#\B3\91D\F6\AC\82ޏA\E6A`\F4\E2"\9C\A5\ABJ\9E\CE\D9\00\E4jQX\8A\E0\97.pb\D8+\A7\A8\D5 \98̼\EA\86\D00\F1T\F0\B6[\AC\8F)\80B\92\9Aq-\CF\EAw\85\91\D7\A4D\91\ED\\8FJ\E7p_p\E6U\E3\00-Ǜ\EA\FD\F6\BC
z\ABca\A0+\D3\8F\E1\E1\F5\C0\A1\D2\ \A7\00\F2.\A5\8DL\FE\88dl\FF\A4\91u\83\A1C\D7jHl\83\BC_\E3p\D7K*?~\BE1\CFù\C9\F9	\84W\F3\8CgS\95B\A3l4\F3R\95
\83
\C4\CC\CC{\A3\B0\913|\DC-\F8\FES\92\C2K\CB4o\81ƍ&g\D7*\83\84\BB\DF\C6{\A8\838j\E9\F9\BC\C0n\D8\E1\F4G


v\F4\CAIN\84@\D69\E0\D07\B8v\BE\81{\E8 \A1\E1\C8\\A9\E4\A8hҒ\9Ez\9F\87CcQk\B0\84
m\8C\E9\AE{`^\D5
S1\E0\A8':\E7\C1瀨a\CBӉ\C4\E1\B1\BA\98u\8C\C6UgD\AC1_\81\84\A11\A7U\E3\B9k\BEd\FA\E4\\912?\B6\BE\EEt\D75b\D0\F5>5\FE
RO\8D\C0!\ACyE>^ߤp\CAC^\E9h 0\A4Y\96\BF\FD\EB'x\E7\CE.\AB\F3z\CEj\F2bK\80l\AE>\88\BA\EBM\BC\83ۉJQ\98ْ\A3\B1<\BAJ%0\E4\C6\E7\F3!MF%=\AA\00m\C0N\C0(.!\B6](=\AFO\A7\EF<{\DE\C6\EFe\00\C5^LR\80Z\B1\B1\B1\A4\A4\A1\D68\9C}Āϱ:ߏ\E5\9D@;\F3\E4-\i\A7\FD\B1\B6\D8\C2!\C0;\8E\EB\9AI\E8n\A7f\DF{`$\B0S_\8DZ\8Eօ\D3\CB\C4*\93\DF\\BE\95+\CF
[Ac'\B0\D8Of\89\E1A𚼍\D5\F2ffڱ\F2d\D2\F2V>\E6\A5\FE7$t\C5\C8;\D46`\F8\ACIkN\81\C3\F8\A3\AFM=\9C>X\BF\D3ɂ\E9	k\CD!|\E5i\F80:\F0\92\FBŋ\F4\E5z\B0 \00\FA\93\B4\F9\C5Oi!\EE\E2ʕAt\C7 \9E\F66S\00$\A0\ED\82\E2\96:\00+R<!V\F2\C4x؞\A5\A8\D1`Ѐ\A4\8Dl`\FF\\9AS\A7S\BAqaf
^\EF\84\FD\F1\EC\E5\F6BW\B48aR\A1)\BF\00\EAЙ\C5\F7`|
\8E\9C\F0 [2	\BB\B7\E36\E7!\99B\86\CF\E5J\8E\84\C2\F0y|\86\A8\DD\CCC\84V\CCaU\B9\BD\BC\A8\A1\A3JW\81oD\BA\B0v\00瑱\8A\9Cu\84I\9F\EBKGa}\00>׭Q1+.K\8Cc\A9\A4'6F\9A\A2\93\EA\8Bݎ\F0\80ٌ\CC\E73F\B8a\E2\C9\D04D\9A\FEC\88\FD\E8\BBbi\91EA\D2\C0 \CD8\F1\E0\A6	\EB\E3\96l\C1`i.s\8A\A0伾	8h\B5\AC\A8\D3Ҍ~\FB\CEZ8\F9V\98\F7ԝp\B8\A8\C77\83\B8\D7G\AB8\C4q\80\97j\9C\C01\80F\00\C1\EDD\99#\EEeM.3
\82\E9\F84\FBy}VT\E0x\A0ԯ\A1\B6k\F8\9A\A8cdɽ\BA\E6>\00\BD\9FA\E7J̡\80\A5UҠ*\E8D\F7(\\C0\92V\A0󀸏^;&\94$\80C\B1\w\B0\B4\F9\88\D5\D1Ӡf\98^,\EF\C8c&\9E\F53	}p3\8F#y\88Ԓ\A8h\A0
'w\88;\D9RH\D3%\AF\D4\DB\C9\EBm!@\CC\B5\85\9Cى\E2D^\B4\85'\D1i\D6!8\C4d\AE\BFbq\A1\9D\87=\00,\8F\ADu\D8O\8E\C6\C5v\A2v\8A\8B:\D9,\94\D0\C4}9WsR\96\97\97/\AFϋ\80b\B7Qſ\8A\EF<\94\CF{\F1\952"T\93\FD\EC\C9Q\A0\\BBuTi\E0*\A66\95\8C\C4\E8hR6\00\EA\8BY\F4L\DF`\FD\C8-\80\E06\AC\B8-\DC
x
qe
\B2\ACI'\82k
(\91\97ܫ¿\E53\B1\9C\F3\80ˁ]v*\AC\D7
x\A1uv\E4\B07\B3\C5\E9\FC\C3v)\D8\FA\C4r\DE\C5\C3L`)\E4^u(\E0\B5\E3n\EC\EC\EB\9B\C0\9F\80\C5\9E3I\E4+P(\85\9F\BD\8D&LGp\EDx\E5
\86W\8E\D2r\E4\E6K0Uϰ\E0\98L\EE]F\C9`\898\A3|g\B3Qt\F8\917s&
ˀ\B3\B3\DD\EF\D7G\EF\8F\A0\86\8FXe2\00\AC\A6G<FC\B1\B6Bѣ\80\F8Y\CE\E0\E0\E0\D8\FB5ZƎ\B0\F9\9D%\E9\91:\EF\8F\BE\DFP,%
\83\A4X\CEJ\A2\8F\E0a\D2\F6u\C5\F0ɲ\E4\B0\00^F'=z>\85\AEG\D8\CC\FB\A4\B6ď\DA\C0Xֆ\E4-\B4D"\E2\C3\CA*9r"\B4;q\9A/\B5җ\C5"\FB\88|\B5\92p\FF6&O\F7\D0\DER\C5B<|I\95\DDh\FCL\BC\C0\9Er\DA8\96\B2&B\E2Ev\ECܮ\AC\EDݥ\A1Y\BD\B5#\M\AA\F3\FB\F5K>z\80\CA\FEm\F8\ACW+\880\8D\B54q2*\B3\80\EF\92\E4+yɟ\94zh|\CA*\00\80*\91\B1\B0\A0s\9B\C2_\83["=*\A9\BD\BD$\F0$QN\FAx	\AFh\96	v\C6+.\EC\F5\8D\8C\DEv\D0#Au\B1\97\B6\B0\DCv\A6(\BB\00&HSBo\CC\E4\80\92\BB\F4
\81\00/\F0{1\87\A5\E2\Bn
\F7qU\93\DC*\8A\00#<\A4~\B51кa\CF$}H\BA\BFчD\DB\FE\AD\8EDp\9Fr^<Q~;S\94\BC0)\90\81\84A2\95H\A7\F8 \AC\E8\BEr\E5_f|\A9\CF\F6mZE\EB\C67\A9v\E8\F8c&\83\BAId\9F߽!<\E1\F8L\E3x\B0v\A3\86Li?g,\90\B2+\ABK\D9Ld_\B8ֵ\8A\8A~y\99\A1[\80\8B{\E6^Ɔ\9BMw\F34\B85\9A+5*\D4\C3qy@7\D9I2\88kF\B9\EDLQ\F6Y\F8dV\AA\E3<\B6\92\98\AA\A0\86\A6M\DA)\A7(;͡\B3z\BD\AD\8AV\D3RQ	\9E0\9F\AD\F3\A9ٷ\95)f\89?g0)\D1&7oᬳ\BAb}g\D9\D3`8\E3\ED\EAS\B8QJV \E8v\9Fs\92\B7B6\BAN\AA\8A\F7\8D$\BE\A1\8A\C9ln\FE\BB'\CE\CF(_\D7\F9	\CD\EB^e0ihS[.]\F0\EA\A7\95\DB\C6t\CA<\9A\E2\8B&M\A4d20\F9\B3h5'\A2\8C\9A\F5R\A1i\F3{\EC\BE$S\80\E0\89\F3\D7\CC8k\C9
W_\DD\81r\9B\97A\D9\A8r\BBg7\C8\FE\B8IH7\DA\D3\CD\F6
|\A7\9D@K]\88`\BCm\D3\D78\D4\C1\D1%;@\DC}\D3uW\BFUn\9BrQ\F6 \E8\9F:\E3\E7\C1\9A\A6\8E\C6
\95i
\B7*@J\82\9Fmg\EB^\8E-\9Di\A2\9B#\812\82\E4a\92\89Y7\E5\CE\C3\F0\80_\DF<\00\9C\DA~\C5\EC\F9\DEC=oւB\BAIO\CC:\l}1\83~=	\F0\BAT\95\BBn\BAꪮr\DBa\97#>\E9X\C5\EC\FB'\F4\ECx\D8i$\D4ފzB\BDQ5\A7\C91-\CF,~g\EB=G\BA\FD|\95Y\97\BC\F2J\F5\D3\E8\BFW\99\A1\FE\C5	\97gSep\D2\F9s7o.u+\E5\FF\94\83\FF\F6\DAᘹx|\00\00\00\00IEND\AEB`\82
EOF'

#install .desktop file itself
sudo bash -c 'cat <<EOF > Duckstation.desktop
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=duckstation-qt
Name=DuckStation
Comment=Fast PlayStation 1 emulator
Icon=duckstation-qt
Categories=Game;Emulator;
EOF'

#done
echo "Done!"
