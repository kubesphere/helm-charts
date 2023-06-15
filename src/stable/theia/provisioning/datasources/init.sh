#!/usr/bin/env bash

# Copyright 2022 Antrea Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $THIS_DIR/create_table.sh

# This function is kept to be compatible with version below v0.3.0
function setDataVersion {
    tables=$(clickhouse client -h 127.0.0.1 -q "SHOW TABLES")
    if [[ $tables == *"migrate_version"* ]]; then
        clickhouse client -h 127.0.0.1 -q "ALTER TABLE migrate_version DELETE WHERE version!=''"
    else
        clickhouse client -h 127.0.0.1 -q "CREATE TABLE migrate_version (version String) engine=MergeTree ORDER BY version"
    fi
    clickhouse client -h 127.0.0.1 -q "INSERT INTO migrate_version (*) VALUES ('{{ .Chart.Version }}')"
    echo "=== Set data schema version to {{ .Chart.Version }} ==="
}

../clickhouse-schema-management
createTable
setDataVersion

