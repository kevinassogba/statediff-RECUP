from spack.package import CMakePackage

class Statediff(CMakePackage):
    """state-diff is a project that depends on Kokkos, liburing, and cereal."""
    homepage = "https://github.com/kevinassogba/statediff-RECUP"
    git      = "https://github.com/kevinassogba/statediff-RECUP.git"

    version('v0.1', branch='main', submodules=True) 

    variant(
        "build_type",
        default="Release",
        description="CMake build type",
        values=("Debug", "Release", "RelWithDebInfo"),
    )

    build_directory = "build"

    depends_on('kokkos+openmp')
    depends_on('cmake', type="build")

    root_cmakelists_dir = "state-diff"

    def cmake_args(self):
        args = [
            self.define('CMAKE_BUILD_TYPE', self.spec.variants['build_type'].value),
            self.define('CMAKE_CXX_COMPILER', self.spec["kokkos"].kokkos_cxx),
            self.define('CMAKE_CXX_FLAGS', '-fPIC'),
            self.define('CMAKE_INSTALL_PREFIX', self.prefix+'/build'),
            self.define('Kokkos_DIR', self.spec['kokkos'].prefix.lib64.cmake.Kokkos)
        ]
        return args
