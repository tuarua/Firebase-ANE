   #!/bin/sh

#  build_all.sh
#  FirebaseANE
#
#  Created by Eoin Landy on 08/09/2018.
#  Copyright © 2018 Tua Rua Ltd. All rights reserved.

red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'


echo ${grn}"MLKitANE" ${white}
cd /Users/eoinlandy/flash/Firebase-ANE/native_extension/MLKitANE/ane || exit
/Users/eoinlandy/flash/Firebase-ANE/native_extension/MLKitANE/ane/build_multi.sh

echo ${grn}"BarcodeANE" ${white}
cd /Users/eoinlandy/flash/Firebase-ANE/native_extension/VisionBarcodeANE/ane || exit
/Users/eoinlandy/flash/Firebase-ANE/native_extension/VisionBarcodeANE/ane/build_multi.sh

echo ${grn}"FaceANE" ${white}
cd /Users/eoinlandy/flash/Firebase-ANE/native_extension/VisionFaceANE/ane || exit
/Users/eoinlandy/flash/Firebase-ANE/native_extension/VisionFaceANE/ane/build_multi.sh

echo ${grn}"LabelANE" ${white}
cd /Users/eoinlandy/flash/Firebase-ANE/native_extension/VisionLabelANE/ane || exit
/Users/eoinlandy/flash/Firebase-ANE/native_extension/VisionLabelANE/ane/build_multi.sh

echo ${grn}"TextANE" ${white}
cd /Users/eoinlandy/flash/Firebase-ANE/native_extension/VisionTextANE/ane || exit
/Users/eoinlandy/flash/Firebase-ANE/native_extension/VisionTextANE/ane/build_multi.sh

echo ${grn}"LanguageIdentificationANE" ${white}
cd /Users/eoinlandy/flash/Firebase-ANE/native_extension/LanguageIdentificationANE/ane || exit
/Users/eoinlandy/flash/Firebase-ANE/native_extension/LanguageIdentificationANE/ane/build_multi.sh


echo ${grn}"Complete" ${white}
