class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://github.com/davvid/garden"
  url "https://github.com/davvid/garden/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "4b319db036765d7cb8600f41ebb86d6d70509c3aaa3da0eba68bdc25a9bf5ebf"
  license "MIT"
  head "https://github.com/davvid/garden.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"garden.yaml").write <<~EOS
      trees:
        current:
          path: .
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${name}
      variables:
        name: $ echo garden
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_predicate testpath/"garden", :exist?
    assert_predicate testpath/"current", :exist?
  end
end
