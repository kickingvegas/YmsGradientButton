
EXEC=ygbutil
INSTALL_DIR=${HOME}/bin

install:
	cp ${EXEC}.py ${INSTALL_DIR}/${EXEC}
	chmod uog+x ${INSTALL_DIR}/${EXEC}


test_upgrade:
	python ${EXEC}.py -i tests/version1_1.plist -o tests/version1_1_upgrade.plist upgrade
	python ${EXEC}.py -i tests/version1_2.plist -o tests/version1_2_upgrade.plist upgrade

test_json:
	python ${EXEC}.py -i tests/version1_1_upgrade.plist convert
	python ${EXEC}.py -i tests/version1_2_upgrade.plist convert

test_plist:
	python ${EXEC}.py -i tests/version1_1_upgrade.js -o tests/version1_1_fromjson.plist convert
	python ${EXEC}.py -i tests/version1_2_upgrade.js -o tests/version1_2_fromjson.plist convert

clean_tests:
	cd tests; rm -f *upgrade.plist *fromjson.plist *.js



