import os
import unittest

from scripts.test import shared


class BinaryenTestCase(unittest.TestCase):
    def input_path(self, filename):
        return os.path.join(shared.options.binaryen_test, 'unit', 'input',
                            filename)

    def roundtrip(self, filename, opts=[], debug=True):
        if debug:
            opts = opts + ['-g']
        path = self.input_path(filename)
        p = shared.run_process(shared.WASM_OPT + ['-o', 'a.wasm', path] +
                               opts)
        self.assertEqual(p.returncode, 0)
        with open(path, 'rb') as f:
            with open('a.wasm', 'rb') as g:
                self.assertEqual(g.read(), f.read())

    def disassemble(self, filename):
        path = self.input_path(filename)
        p = shared.run_process(shared.WASM_OPT +
                               ['--print', '-o', os.devnull, path],
                               check=False, capture_output=True)
        self.assertEqual(p.returncode, 0)
        self.assertEqual(p.stderr, '')
        return p.stdout

    def check_features(self, filename, features, opts=[]):
        path = self.input_path(filename)
        cmd = shared.WASM_OPT + \
            ['--print-features', '-o', os.devnull, path] + opts
        p = shared.run_process(cmd, check=False, capture_output=True)
        self.assertEqual(p.returncode, 0)
        self.assertEqual(p.stderr, '')
        self.assertEqual(p.stdout.splitlines(),
                         ['--enable-' + f for f in features])

    # similar to assertEqual, but while ignoring line ending differences such
    # as those between windows and unix
    def assert_equal_ignoring_line_endings(self, left, right):
        left = left.replace('\r\n', '\n')
        right = right.replace('\r\n', '\n')
        self.assertEqual(left, right)
