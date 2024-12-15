FASTLANE := bundle exec fastlane

.PHONY: install
install:
	bundle install

.PHONY: test
test: scan_development

.PHONY: distribute_firebase
distribute_firebase:
	$(FASTLANE) distribute_firebase

.PHONY: distribute_testflight
distribute_testflight: pilot_appstore

.PHONY: submit_appstore
submit_appstore: deliver_appstore

.PHONY: gym_development
gym_development:
	$(FASTLANE) gym_development

.PHONY: gym_adhoc
gym_adhoc:
	$(FASTLANE) gym_adhoc

.PHONY: gym_appstore
gym_appstore:
	$(FASTLANE) gym_appstore

.PHONY: scan_development
scan_development:
	$(FASTLANE) scan_development

.PHONY: pilot_appstore
pilot_appstore:
	$(FASTLANE) pilot_appstore

.PHONY: deliver_appstore
deliver_appstore:
	$(FASTLANE) deliver_appstore

.PHONY: bump_patch_version
bump_patch_version:
	$(FASTLANE) bump_patch_version

.PHONY: bump_minor_version
bump_minor_version:
	$(FASTLANE) bump_minor_version

.PHONY: bump_major_version
bump_major_version:
	$(FASTLANE) bump_major_version

.PHONY: match_all
match_all:
	$(FASTLANE) match_development
	$(FASTLANE) match_adhoc
	$(FASTLANE) match_appstore

.PHONY: match_development
match_development:
	$(FASTLANE) match_development

.PHONY: match_adhoc
match_adhoc:
	$(FASTLANE) match_adhoc

.PHONY: match_appstore
match_appstore:
	$(FASTLANE) match_appstore

.PHONY: match_fetch_all
match_fetch_all:
	$(FASTLANE) match_fetch_development
	$(FASTLANE) match_fetch_adhoc
	$(FASTLANE) match_fetch_appstore

.PHONY: match_fetch_development
match_fetch_development:
	$(FASTLANE) match_fetch_development

.PHONY: match_fetch_adhoc
match_fetch_adhoc:
	$(FASTLANE) match_fetch_adhoc

.PHONY: match_fetch_appstore
match_fetch_appstore:
	$(FASTLANE) match_fetch_appstore

.PHONY: match_delete_all
match_delete_all:
	$(FASTLANE) match_delete_development
	$(FASTLANE) match_delete_adhoc
	$(FASTLANE) match_delete_appstore

.PHONY: match_delete_development
match_delete_development:
	$(FASTLANE) match_delete_development

.PHONY: match_delete_adhoc
match_delete_adhoc:
	$(FASTLANE) match_delete_adhoc

.PHONY: match_delete_appstore
match_delete_appstore:
	$(FASTLANE) match_delete_appstore

.PHONY: register_bundle_id
register_bundle_id:
	$(FASTLANE) produce -a $(id) -i

.PHONY: register_device
register_device:
	$(FASTLANE) run register_device name:$(name) udid:$(udid)
	$(MAKE) match_all
