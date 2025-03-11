## Dependencies

Dependencies are managed with Poetry.

From the root folder run:

- Windows and Powershell: `.\.venv\Scripts\activate`
- Windows and Git Bash: `source $( poetry env info --path )/Scripts/activate`
- MAC and ubuntu:  `source $( poetry env info --path )/bin/activate`

This assumes you have configured your Poetry to create the virtualenvs in project (```poetry config virtualenvs.in-project true```) and that you have `.venv` folder in the project root folder.

Check the configuration:

poetry config virtualenvs.in-project

Check environment info:

```bash
poetry env info
```

Install in new project:

Copy `pyproject.toml` from other repo and put the requirements.

Run `poetry lock` to create the `.venv` folder

Run `poetry insall`