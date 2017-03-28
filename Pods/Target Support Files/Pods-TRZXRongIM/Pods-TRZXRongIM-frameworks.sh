#!/bin/sh
set -e

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

SWIFT_STDLIB_PATH="${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"

install_framework()
{
  if [ -r "${BUILT_PRODUCTS_DIR}/$1" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$1"
  elif [ -r "${BUILT_PRODUCTS_DIR}/$(basename "$1")" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$(basename "$1")"
  elif [ -r "$1" ]; then
    local source="$1"
  fi

  local destination="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

  if [ -L "${source}" ]; then
      echo "Symlinked..."
      source="$(readlink "${source}")"
  fi

  # use filter instead of exclude so missing patterns dont' throw errors
  echo "rsync -av --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${source}\" \"${destination}\""
  rsync -av --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${source}" "${destination}"

  local basename
  basename="$(basename -s .framework "$1")"
  binary="${destination}/${basename}.framework/${basename}"
  if ! [ -r "$binary" ]; then
    binary="${destination}/${basename}"
  fi

  # Strip invalid architectures so "fat" simulator / device frameworks work on device
  if [[ "$(file "$binary")" == *"dynamically linked shared library"* ]]; then
    strip_invalid_archs "$binary"
  fi

  # Resign the code if required by the build settings to avoid unstable apps
  code_sign_if_enabled "${destination}/$(basename "$1")"

  # Embed linked Swift runtime libraries. No longer necessary as of Xcode 7.
  if [ "${XCODE_VERSION_MAJOR}" -lt 7 ]; then
    local swift_runtime_libs
    swift_runtime_libs=$(xcrun otool -LX "$binary" | grep --color=never @rpath/libswift | sed -E s/@rpath\\/\(.+dylib\).*/\\1/g | uniq -u  && exit ${PIPESTATUS[0]})
    for lib in $swift_runtime_libs; do
      echo "rsync -auv \"${SWIFT_STDLIB_PATH}/${lib}\" \"${destination}\""
      rsync -auv "${SWIFT_STDLIB_PATH}/${lib}" "${destination}"
      code_sign_if_enabled "${destination}/${lib}"
    done
  fi
}

# Signs a framework with the provided identity
code_sign_if_enabled() {
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" -a "${CODE_SIGNING_REQUIRED}" != "NO" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
    # Use the current code_sign_identitiy
    echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
    local code_sign_cmd="/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} ${OTHER_CODE_SIGN_FLAGS} --preserve-metadata=identifier,entitlements '$1'"

    if [ "${COCOAPODS_PARALLEL_CODE_SIGN}" == "true" ]; then
      code_sign_cmd="$code_sign_cmd &"
    fi
    echo "$code_sign_cmd"
    eval "$code_sign_cmd"
  fi
}

# Strip invalid architectures
strip_invalid_archs() {
  binary="$1"
  # Get architectures for current file
  archs="$(lipo -info "$binary" | rev | cut -d ':' -f1 | rev)"
  stripped=""
  for arch in $archs; do
    if ! [[ "${VALID_ARCHS}" == *"$arch"* ]]; then
      # Strip non-valid architectures in-place
      lipo -remove "$arch" -output "$binary" "$binary" || exit 1
      stripped="$stripped $arch"
    fi
  done
  if [[ "$stripped" ]]; then
    echo "Stripped $binary of architectures:$stripped"
  fi
}


if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworking/AFNetworking.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AXNavigationBackItemInjection/AXNavigationBackItemInjection.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AXWebViewController/AXWebViewController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Aspects/Aspects.framework"
  install_framework "$BUILT_PRODUCTS_DIR/CTMediator/CTMediator.framework"
  install_framework "$BUILT_PRODUCTS_DIR/DVSwitch/DVSwitch.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FDStackView/FDStackView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FMDB/FMDB.framework"
  install_framework "$BUILT_PRODUCTS_DIR/IQKeyboardManager/IQKeyboardManager.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LCActionSheet/LCActionSheet.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MJExtension/MJExtension.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MJRefresh/MJRefresh.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MLLabel/MLLabel.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Masonry/Masonry.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NJKWebViewProgress/NJKWebViewProgress.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ReactiveCocoa/ReactiveCocoa.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SDAutoLayout/SDAutoLayout.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SDWebImage/SDWebImage.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXComplaint/TRZXComplaint.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXDIYRefresh/TRZXDIYRefresh.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXDVSwitch/TRZXDVSwitch.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXFriendCircle/TRZXFriendCircle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXInvestorDetail/TRZXInvestorDetail.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXInvestorDetailCategory/TRZXInvestorDetailCategory.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXKit/TRZXKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXLogin/TRZXLogin.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXMSSBrowse/TRZXMSSBrowse.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXMyTheme/TRZXMyTheme.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXMyWallet/TRZXMyWallet.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXNavigationTableViewHeaderView/TRZXNavigationTableViewHeaderView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXNetwork/TRZXNetwork.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalAppointment/TRZXPersonalAppointment.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalCustomerCenter/TRZXPersonalCustomerCenter.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalHome/TRZXPersonalHome.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalJump/TRZXPersonalJump.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalProfile/TRZXPersonalProfile.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProject/TRZXProject.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProjectDetail/TRZXProjectDetail.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProjectDetailCategory/TRZXProjectDetailCategory.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProjectScreening/TRZXProjectScreening.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProjectScreeningBusinessCategory/TRZXProjectScreeningBusinessCategory.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXShare/TRZXShare.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXShareView/TRZXShareView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXShufflingView/TRZXShufflingView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXWebView/TRZXWebView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXWebViewCategory/TRZXWebViewCategory.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXZJWPhotoPicker/TRZXZJWPhotoPicker.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TZImagePickerController/TZImagePickerController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/WMPageController/WMPageController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/YYCache/YYCache.framework"
  install_framework "$BUILT_PRODUCTS_DIR/YYText/YYText.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ZBCellConfig/ZBCellConfig.framework"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworking/AFNetworking.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AXNavigationBackItemInjection/AXNavigationBackItemInjection.framework"
  install_framework "$BUILT_PRODUCTS_DIR/AXWebViewController/AXWebViewController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Aspects/Aspects.framework"
  install_framework "$BUILT_PRODUCTS_DIR/CTMediator/CTMediator.framework"
  install_framework "$BUILT_PRODUCTS_DIR/DVSwitch/DVSwitch.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FDStackView/FDStackView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FMDB/FMDB.framework"
  install_framework "$BUILT_PRODUCTS_DIR/IQKeyboardManager/IQKeyboardManager.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LCActionSheet/LCActionSheet.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MJExtension/MJExtension.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MJRefresh/MJRefresh.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MLLabel/MLLabel.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Masonry/Masonry.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NJKWebViewProgress/NJKWebViewProgress.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ReactiveCocoa/ReactiveCocoa.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SDAutoLayout/SDAutoLayout.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SDWebImage/SDWebImage.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXComplaint/TRZXComplaint.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXDIYRefresh/TRZXDIYRefresh.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXDVSwitch/TRZXDVSwitch.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXFriendCircle/TRZXFriendCircle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXInvestorDetail/TRZXInvestorDetail.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXInvestorDetailCategory/TRZXInvestorDetailCategory.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXKit/TRZXKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXLogin/TRZXLogin.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXMSSBrowse/TRZXMSSBrowse.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXMyTheme/TRZXMyTheme.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXMyWallet/TRZXMyWallet.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXNavigationTableViewHeaderView/TRZXNavigationTableViewHeaderView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXNetwork/TRZXNetwork.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalAppointment/TRZXPersonalAppointment.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalCustomerCenter/TRZXPersonalCustomerCenter.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalHome/TRZXPersonalHome.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalJump/TRZXPersonalJump.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXPersonalProfile/TRZXPersonalProfile.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProject/TRZXProject.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProjectDetail/TRZXProjectDetail.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProjectDetailCategory/TRZXProjectDetailCategory.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProjectScreening/TRZXProjectScreening.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXProjectScreeningBusinessCategory/TRZXProjectScreeningBusinessCategory.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXShare/TRZXShare.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXShareView/TRZXShareView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXShufflingView/TRZXShufflingView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXWebView/TRZXWebView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXWebViewCategory/TRZXWebViewCategory.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TRZXZJWPhotoPicker/TRZXZJWPhotoPicker.framework"
  install_framework "$BUILT_PRODUCTS_DIR/TZImagePickerController/TZImagePickerController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/WMPageController/WMPageController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/YYCache/YYCache.framework"
  install_framework "$BUILT_PRODUCTS_DIR/YYText/YYText.framework"
  install_framework "$BUILT_PRODUCTS_DIR/ZBCellConfig/ZBCellConfig.framework"
fi
if [ "${COCOAPODS_PARALLEL_CODE_SIGN}" == "true" ]; then
  wait
fi