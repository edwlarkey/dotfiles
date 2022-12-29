return {
  settings = {
    json = {
      format = {
        enabled = true
      },
      schemas = {
        {
          description = 'Robin-deploy json config files',
          fileMatch = {'services/*/*.json'},
          url = 'https://gist.githubusercontent.com/edwlarkey/05dbe2b75bab01e52edb60b26f248315/raw/657da2b57726c840def7379fc8f80423fd067eaf/data.schema.json'
        },
      }
    },
  }
}
