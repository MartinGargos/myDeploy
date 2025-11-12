#!/bin/bash
ENV=$1

# Mapování prostředí na větev
case $ENV in
  DEV)   BRANCH="dev"   ;;
  STAGE) BRANCH="stage" ;;
  PROD)  BRANCH="main"  ;;
  *)     echo "Neznámé prostředí: $ENV" >&2; exit 1 ;;
esac

# Dočasná složka
TMP_DIR="/tmp/myApp"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# Klonuj veřejné repo – žádný token!
git clone https://github.com/martincarpos/myApp.git "$TMP_DIR"
cd "$TMP_DIR" || exit 1

# Stáhni tagy
git fetch origin "$BRANCH" --tags 2>/dev/null || true

# Najdi poslední tag
TAG=$(git for-each-ref --sort=-version:refname --format='%(refname:short)' "refs/tags/myApp/*" | head -1)

if [ -z "$TAG" ]; then
  echo "Žádný tag nenalezen na větvi $BRANCH" >&2
  exit 1
fi

# Odstraň prefix
BUILD_ID=$(echo "$TAG" | sed 's/^myApp\///')

echo "myApp:$BUILD_ID"
