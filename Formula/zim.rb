class Zim < Formula
  desc "Meta-formula: installs zim-tools (zimdump and the openzim reader tools)"
  homepage "https://github.com/Mearman/homebrew-zim"
  url "https://github.com/Mearman/homebrew-zim/archive/3482ac9.tar.gz"
  sha256 "79a80ad7be4b251cdddf7919d6564726ac3ffc870f6c5a3faa7b3cb83ed30929"
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
