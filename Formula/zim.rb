class Zim < Formula
  desc "Meta-formula: installs zim-tools (zimdump and the openzim reader tools)"
  homepage "https://github.com/Mearman/homebrew-zim"
  url "https://github.com/openzim/zim-tools/archive/refs/tags/3.7.0.tar.gz"
  sha256 "6ce3c63832234f65c23cd76f0bd5076182d24b186b107d7a6295fbc21e252b83"
  license "MIT"

  depends_on "Mearman/zim/zim-tools"

  def install
    pkgshare.mkpath
    (pkgshare/"README.md").write "Meta-formula for the Mearman/zim tap. Installs zim-tools (zimdump and friends)."
  end

  test do
    assert_predicate Formula["zim-tools"], :any_version_installed?
  end
end
