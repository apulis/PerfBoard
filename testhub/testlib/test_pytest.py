# content of test_class.py
class TestClass:
    def test_one(self):
        x = "this"
        assert "h" in x

    def test_two(self):
        x = "hello"
        assert hasattr(x, "check")

class TestClassDemoInstance:
    def test_a(self):
        assert 0

    def test_b(self):
        assert 0

def test_needsfiles(tmpdir):
    print(tmpdir)
    assert 0


