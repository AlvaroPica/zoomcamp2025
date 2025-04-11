## Install Poetry

Recommended through their official script:
```bash
curl -sSL https://install.python-poetry.org | python3 -
```

Ideally we have previous:

1. installed python with `pyenv`
2. Install python version with `pyenv install 3.12`
3. Set the global Python through `pyenv global 3.12`
4. Check status with `pyenv versions`

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

Run `poetry lock` to create the `.venv` folder (make sure the `virtualenvs.in-project` is true for it to be created in the project folder)

Run `poetry insall`

## Pyenv

```shell
pyenv shell <version> - modifies Python for the current shell session
pyenv local <version> - modifies the Python used in the current directory (or subdirectories)
pyenv global <version> - modifies the Python used for your user account
```

## uv

New backend to replace pip, poetry, pyenv...

Installed with:

`poetry config experimental.new-installer true`