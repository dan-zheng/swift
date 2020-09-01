# ===--- test_update_option.py --------------------------------------------===#
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2020 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https:#swift.org/LICENSE.txt for license information
# See https:#swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
# ===----------------------------------------------------------------------===#

from . import scheme_mock


class UpdateOptionTestCase(scheme_mock.SchemeMockTestCase):

    def __init__(self, *args, **kwargs):
        super(UpdateOptionTestCase, self).__init__(*args, **kwargs)

    def test_update_option(self):
        # Check that the `--update` option does not crash.
        self.call([self.update_checkout_path,
                   '--config', self.config_path,
                   '--source-root', self.source_root,
                   '--clone', '--update'])
