# infisical/manifests/secret.pp
define infisical::secret (
  String $secret_key,
  Optional[String] $project_token = hiera('infisical_project_token', undef),
  Optional[String] $api_endpoint  = hiera('infisical_api_endpoint', 'https://api.infisical.com'),
) {
  # Fetch the secret using the custom function and notify with the value
  $secret_value = infisical_lookup($secret_key, $project_token, $api_endpoint)
}

