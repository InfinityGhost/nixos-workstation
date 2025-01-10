self: super: {
  mint-y-icons = super.mint-y-icons.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "linuxmint";
      repo = "mint-y-icons";
      rev = "29eb94bc16a8b77423cfaca60a84fc18c931f1b6";
      sha256 = "1jvz435jdy0x6kq1n9cxalhw88r7gg2sxlz78cghdm7cq8msvxi2";
    };
  });
}
