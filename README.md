# infisical


This is a POC to have puppet secret values looked up from Infisical

This module dos NOT setup Infisical 

It will query a secret from an infisical server so it can be used in a puppet project

```
$api_endpoint = 'http://127.0.0.1'
$project_token = 'st.someslongstringoesherethatstartswithst'


  infisical::secret { "infisical_secret_HASH}":
      secret_key    => 'HASH',
      api_endpoint  => $api_endpoint,
      project_token => $project_token,
    }
    infisical::secret { "infisical_secret_domain}":
      secret_key    => 'DOMAIN',
      api_endpoint  => $api_endpoint,
      project_token => $project_token,
  }
```

