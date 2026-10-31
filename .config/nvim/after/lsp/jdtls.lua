return {
  settings = {
    java = {
      autobuild = { enabled = false },
      settings = { url = '/home/rubin/.config/jdtls/settings.prefs' },
      configuration = {
        runtimes = {
          { name = 'JavaSE-1.8', path = '/usr/lib/jvm/java-8-openjdk' },
          { name = 'JavaSE-25', path = '/usr/lib/jvm/java-25-openjdk', default = true },
          -- { name = 'JavaSE-25', path = '/usr/lib/jvm/java-25-graalvm' },
          -- { name = 'JavaSE-25', path = '/usr/lib/jvm/java-25-openj9' },
        },
      },
    },
  },
}
