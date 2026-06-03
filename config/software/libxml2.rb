#
# Copyright:: Chef Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "libxml2"
default_version "2.11.7"

license "MIT"
license_file "COPYING"
skip_transitive_dependency_licensing true

dependency "zlib"
dependency "liblzma"
dependency "config_guess"

# version_list: url=https://download.gnome.org/sources/libxml2/ filter=*.tar.xz
version("2.13.5") { source sha256: "37cdec8cd20af8ab0decfa2419b09b4337c2dbe9da5615d2a26f547449fecf2a" }
version("2.12.7") { source sha256: "a7c1277f4e859883ff3aaa09a545561b7515e078a97eb240bb92bf5a03ae03fc" }
version("2.12.5") { source sha256: "90f1b12db4b9f9b7282edf33ff15a104bb9caf88264fda05af4239330437e239" }
version("2.11.7") { source sha256: "9f8a53f0becb074e90d765a264b3d4f60a7e53cb6e3672764afbf05ffbd2f247" }
version("2.10.4") { source sha256: "1aa47bd54f9e0245686d494fbbbfa4e3e77b6fc4f988708383de8a1033292e66" }
version("2.9.14") { source sha256: "80efe9e6b48f8aa7b9b0c47be427e2ef2dbfb2999124220ffbc0f43ca6adb98c" }
version("2.9.13") { source sha256: "0d676b10cfd13ab966907a3917bd86b17a1c22befdf42144cdc1ad5bb9e65c45" }
version("2.9.12") { source sha256: "98bfa7a9a5e2a75638422050740448ee9f02bf4dc2075c9822d7747d5ff9e617" }
version("2.9.10") { source sha256: "f07dab13bf42d2b8db80620cce7419b3b87827cc937c8bb20fe13b8571ee9501" }
version("2.9.9")  { source sha256: "d490df9133f8871d4678eb9e899313c3b238e455d45aaf64c9b10b76495b19e7" }

minor_version = version.gsub(/\.\d+\z/, "")
# source url: "https://download.gnome.org/sources/libxml2/#{minor_version}/libxml2-#{version}.tar.xz"
source url: "https://gitlab.gnome.org/GNOME/libxml2/-/archive/v#{version}/libxml2-v#{version}.tar.gz"
internal_source url: "#{ENV["ARTIFACTORY_REPO_URL"]}/#{name}/#{name}-v#{version}.tar.gz",
                authorization: "X-JFrog-Art-Api:#{ENV["ARTIFACTORY_TOKEN"]}"

relative_path "libxml2-v#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_command = [
    "--with-zlib=#{install_dir}/embedded",
    "--with-lzma=#{install_dir}/embedded",
    "--with-sax1", # required for nokogiri to compile
    "--without-iconv",
    "--without-python",
    "--without-icu",
    "--without-debug",
    "--without-mem-debug",
    "--without-run-debug",
    "--without-legacy", # we don't need legacy interfaces
    "--without-catalog",
    "--without-docbook",
  ]

  update_config_guess

  configure(*configure_command, env: env)

  make "-j #{workers}", env: env
  make "install", env: env
end
