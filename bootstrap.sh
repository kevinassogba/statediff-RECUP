#!/bin/bash
set -e

# === CONFIGURATION ===
# You can call this script like: ./bootstrap.sh /path/to/spack
SPACK_DIR=${1:-"$PWD/external/spack"}

if [ ! -d "$SPACK_DIR" ]; then
  echo "[INFO] Cloning Spack into $SPACK_DIR..."
  git clone --depth=1 https://github.com/spack/spack.git "$SPACK_DIR"
fi

# === Load Spack environment ===
SPACK_SETUP="$SPACK_DIR/share/spack/setup-env.sh"

if [ ! -f "$SPACK_SETUP" ]; then
  echo "[ERROR] Spack setup script not found at: $SPACK_SETUP"
  exit 1
fi

echo "[INFO] Using Spack from: $SPACK_DIR"
. "$SPACK_SETUP"


spack mirror remove binary_mirror || true
spack mirror add binary_mirror https://binaries.spack.io/releases/v0.21
spack buildcache keys --install --trust

# === Activate the environment ===
if [ ! -f "./spack/spack.yaml" ]; then
  echo "[ERROR] spack.yaml not found in ./spack"
  exit 1
fi

spack env activate ./spack

# === Install dependencies ===
spack install

# === Build project ===
export MPI_PREFIX=$(spack location -i openmpi)
export KOKKOS_PREFIX=$(spack location -i kokkos)
export LIBURING_PREFIX=$(spack location -i liburing)

# Construct GitHub-authenticated URL
# export LIBURING_REPO="https://${{ secrets.GITHUB_TOKEN }}@github.com/DataStates/liburing-loader.git"
export LIBURING_REPO="https://${GH_PAT_PRIV_REPOS}@github.com/DataStates/liburing-loader.git"

# mkdir -p build && cd build
# cmake \
# -DCMAKE_BUILD_TYPE=Release \
# -DCMAKE_CXX_FLAGS="-fPIC" \
# -DCMAKE_PREFIX_PATH="$MPI_PREFIX;$KOKKOS_PREFIX;$LIBURING_PREFIX" \
# -DLIBURING_LOADER_REPO=$LIBURING_REPO \
# ../external/state-diff
# cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/install
cmake -S . -B build \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_PREFIX_PATH="$MPI_PREFIX;$KOKKOS_PREFIX;$LIBURING_PREFIX" \
-DLIBURING_LOADER_REPO=$LIBURING_REPO \
-DLIBURING_LOADER_REPO=$LIBURING_REPO \
-DCMAKE_INSTALL_PREFIX=$PWD/install

cmake --build build --parallel
cmake --install build