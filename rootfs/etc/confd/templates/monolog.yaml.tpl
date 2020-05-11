monolog:

  handlers:

    houdini:
      type: rotating_file
      path: /var/log/islandora/houdini.log
      level: {{getv "/houdini/log/level"}}
      max_files: 1
