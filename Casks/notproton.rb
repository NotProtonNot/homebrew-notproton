cask "notproton" do
  version "1.2.4"
  sha256 "196ea6e0a93dfe8d0cf16292bdff83f14aaeb5a6ad817b91838bb1316052d053"

  url "https://github.com/NotProtonNot/NotProton/releases/download/v#{version}/NotProton.zip"
  name "NotProton"
  desc "Makes Steam Play and CrossOver work together"
  homepage "https://github.com/NotProtonNot/NotProton"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "NotProton.app"

  uninstall quit: "com.notproton.NotProton"

  zap early_script: {
        executable: "/bin/test",
        args:       ["-x", "#{staged_path}/NotProton.app/Contents/MacOS/NotProtonApp"],
      },
      script:       {
        executable: "NotProton.app/Contents/MacOS/NotProtonApp",
        args:       ["--remove-everything"],
      },
      trash:        [
        "~/Library/Caches/com.notproton.NotProton",
        "~/Library/HTTPStorages/com.notproton.NotProton",
        "~/Library/HTTPStorages/com.notproton.NotProton.binarycookies",
        "~/Library/Preferences/com.notproton.NotProton.plist",
        "~/Library/WebKit/com.notproton.NotProton",
      ]

  caveats <<~EOS
    This application is not signed with Apple Developer ID. That will change, but for now you need to run:

      xattr -dr com.apple.quarantine "#{appdir}/NotProton.app"
  EOS
end
