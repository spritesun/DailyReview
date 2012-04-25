APP_NAME = DailyReview

default: proj test rea-common $(PRODUCTION_DEFAULT_TARGETS)

.PHONY: clean
clean:
	xcodebuild -project ${APP_NAME}/${APP_NAME}.xcodeproj -alltargets clean

.PHONY: update
update:
	git submodule sync
	git submodule update --init --recursive

.PHONY: install
install:
	FRUITSTRAP_CLI=1 xcodebuild -scheme UIAutomation -configuration Release -sdk iphoneos build $(EXTRA_XCODE_BUILD_ARGS)
  # FRUITSTRAP_CLI=1 xcodebuild -scheme Casa-Development -configuration Release -sdk iphoneos build $(EXTRA_XCODE_BUILD_ARGS)

.PHONY: rea-common
rea-common:
	cd rea-common && make
