class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://gitlab.com/garden-rs/garden"
  url "https://gitlab.com/garden-rs/garden/-/archive/v1.2.0/garden-v1.2.1.tar.gz"
  sha256 "facccb43e90dac24882a1b2799b71f3abdba3906ff8e72ba72e850f7b3148477"
  license "MIT"
  head "https://gitlab.com/garden-rs/garden.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"garden.yaml").write <<~EOS
      trees:
        current:
          path: ${GARDEN_CONFIG_DIR}
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${filename}
      variables:
        filename: $ echo output
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_predicate testpath/"current", :exist?
    assert_predicate testpath/"output", :exist?
  end
end
