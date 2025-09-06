#!/usr/bin/env bash
# Run dashboard demo from repo root
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/apps/dashboard_demo"
flutter pub get
flutter run -d web-server --web-port=8080
