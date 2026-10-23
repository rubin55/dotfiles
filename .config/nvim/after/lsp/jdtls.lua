return {
  settings = {
    java = {
      autobuild = { enabled = false },
      configuration = {
        runtimes = {
          { name = 'JavaSE-1.8', path = '/usr/lib/jvm/java-8-openjdk' },
          { name = 'JavaSE-21', path = '/usr/lib/jvm/java-21-openjdk' },
          { name = 'JavaSE-25', path = '/usr/lib/jvm/java-25-graalvm', default = true },
          -- { name = 'JavaSE-25', path = '/usr/lib/jvm/java-25-openj9' },
        },
      },
    },
  },
}
