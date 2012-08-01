#!/usr/bin/env python
# 
# Copyright 2012 Yummy Melon Software LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#  Author: Charles Y. Choi <charles.choi@yummymelon.com>
#

EXEC=ygbutil
INSTALL_DIR=${HOME}/bin

install:
	cp ${EXEC}.py ${INSTALL_DIR}/${EXEC}
	chmod uog+x ${INSTALL_DIR}/${EXEC}

test: test_upgrade test_json test_plist

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
	cd tests; rm -f *upgrade.plist *fromjson.plist *.js *.backup



