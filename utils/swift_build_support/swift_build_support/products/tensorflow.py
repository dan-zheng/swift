# swift_build_support/products/tensorflow.py --------------------*- python -*-
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
# ----------------------------------------------------------------------------

import os
import subprocess

from . import product
from .. import shell
from .. import targets


class TensorFlowSwiftAPIs(product.Product):
    @classmethod
    def product_source_name(cls):
        return "tensorflow-swift-apis"

    @classmethod
    def is_build_script_impl_product(cls):
        return False

    def should_build(self, host_target):
        return self.args.build_tensorflow_swift_apis

    def build(self, host_target):
        toolchain_path = targets.toolchain_path(self.args.install_destdir,
                                                self.args.install_prefix)
        swiftc = os.path.join(toolchain_path, 'usr', 'bin', 'swiftc')

        tensorflow_source_dir = os.path.join(self.source_dir, '..',
                                             'tensorflow')
        tensorflow_source_dir = os.path.realpath(tensorflow_source_dir)

        if host_target.startswith('macosx'):
            lib_name = 'libtensorflow.dylib'
        elif host_target.startswith('linux'):
            lib_name = 'libtensorflow.so'
        else:
            raise RuntimeError("Unknown host target %s" % host_target)

        # FIXME: this is a workaround for CMake <3.16 which does not correctly
        # generate the build rules if you are not in the build directory.  As a
        # result, we need to create the build tree before we can use it and
        # change into it.
        #
        # NOTE: unfortunately, we do not know if the build is using Python
        # 2.7 or Python 3.2+.  In the latter, the `exist_ok` named parameter
        # would alleviate some of this issue.
        try:
            os.makedirs(self.build_dir)
        except OSError:
            pass

        with shell.pushd(self.build_dir):

            shell.call([
                self.toolchain.cmake,
                '-G', 'Ninja',
                '-D', 'BUILD_SHARED_LIBS=YES',
                '-D', 'CMAKE_INSTALL_PREFIX={}/usr'.format(
                    self.args.install_destdir),
                '-D', 'CMAKE_MAKE_PROGRAM={}'.format(self.toolchain.ninja),
                '-D', 'CMAKE_Swift_COMPILER={}'.format(swiftc),
                '-D', 'TensorFlow_INCLUDE_DIR={}'.format(tensorflow_source_dir),
                '-D', 'TensorFlow_LIBRARY={}'.format(
                    os.path.join(tensorflow_source_dir, 'bazel-bin', 'tensorflow',
                                 lib_name)),
                '-D', 'CMAKE_Swift_FLAGS={}'.format('-L{}'.format(
                    os.path.join(tensorflow_source_dir, 'bazel-bin', 'tensorflow'))
                ),
                '-B', self.build_dir,
                '-S', self.source_dir,
            ])
            shell.call([
                self.toolchain.cmake,
                '--build', self.build_dir,
            ])

    def should_test(self, host_target):
        return False

    def test(self, host_target):
        pass

    def should_install(self, host_target):
        return self.args.install_tensorflow_swift_apis

    def install(self, host_target):
        shell.call([
            self.toolchain.cmake,
            '--build', self.build_dir,
            '--target', 'install',
        ])


# SWIFT_ENABLE_TENSORFLOW
class TensorFlow(product.Product):
    @classmethod
    def product_source_name(cls):
        """product_source_name() -> str
        The name of the source code directory of this product.
        """
        return "tensorflow"

    @classmethod
    def is_build_script_impl_product(cls):
        return False

    def should_build(self, host_target):
        return self.args.build_tensorflow_swift_apis

    def build(self, host_target):
        # Run the TensorFlow configure script: `yes "" | ./configure`.
        configure_script_path = os.path.join(self.source_dir, 'configure')
        yes_process = shell.Popen(['yes', ''], stdout=subprocess.PIPE)
        shell.call([configure_script_path], stdin=yes_process.stdout)

        # Build TensorFlow via bazel.
        shell.call([
            self.toolchain.bazel,
            "build",
            "-c", "opt",
            "--define", "framework_shared_object=false",
            "//tensorflow:tensorflow",
        ])

        # bazel builds libraries with version suffixes, e.g.
        # "libtensorflow.{dylib,so}.x.y.z".
        # Create a symlink to the standard unsuffixed name:
        # "libtensorflow.{dylib,so}".
        if host_target.startswith('macosx'):
            suffixed_lib_name = 'libtensorflow.2.1.0.dylib'
            unsuffixed_lib_name = 'libtensorflow.dylib'
        elif host_target.startswith('linux'):
            suffixed_lib_name = 'libtensorflow.so.2.1.0'
            unsuffixed_lib_name = 'libtensorflow.so'
        else:
            raise RuntimeError('unknown host target {}'.format(host_target))

        # NOTE: ignore the race condition here ....
        try:
            os.unlink(os.path.join(self.source_dir, 'bazel-bin', 'tensorflow',
                                   unsuffixed_lib_name))
        except OSError:
            pass
        os.symlink(os.path.join(self.source_dir, 'bazel-bin', 'tensorflow',
                                suffixed_lib_name),
                   os.path.join(self.source_dir, 'bazel-bin', 'tensorflow',
                                unsuffixed_lib_name))

    def should_test(self, host_target):
        return False

    def test(self, host_target):
        pass

    def should_install(self, host_target):
        return False

    def install(self, host_target):
        pass
# SWIFT_ENABLE_TENSORFLOW END
