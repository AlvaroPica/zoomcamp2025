
# Powershell usefull commands

## Environment variables

Add variable current session:
`$env:DBT_BIGQUERY_SOURCE_DATASET = "my_nyc_tripdata"`

Add variable for all session current user:
`[System.Environment]::SetEnvironmentVariable('DBT_BIGQUERY_SOURCE_DATASET', 'my_nyc_tripdata', [System.EnvironmentVariableTarget]::User)`

Add variable for all sessions all users:
`[System.Environment]::SetEnvironmentVariable('DBT_BIGQUERY_SOURCE_DATASET', 'my_nyc_tripdata', [System.EnvironmentVariableTarget]::Machine)`

Remove variable:
`Remove-Item Env:DBT_BIGQUERY_PROJECT`

Remove variable for all sessions current user:
`[System.Environment]::SetEnvironmentVariable('DBT_BIGQUERY_SOURCE_DATASET', '', [System.EnvironmentVariableTarget]::User)`

Remove variable for all sessions all users:
`[System.Environment]::SetEnvironmentVariable('DBT_BIGQUERY_SOURCE_DATASET', '', [System.EnvironmentVariableTarget]::Machine)`

List all variables:
`Get-ChildItem Env:`

Print a given variable:
`$env:DBT_BIGQUERY_SOURCE_DATASET`


