## Dependencies

Dependencies are managed with Poetry.

From the root folder run:

- Windows and Powershell: `.\.venv\Scripts\activate`
- Windows and Git Bash: `source $( poetry env info --path )/Scripts/activate`
- MAC and ubuntu:  `source $( poetry env info --path )/bin/activate`

This assumes you have configured your Poetry to create the virtualenvs in project (```poetry config virtualenvs.in-project true```) and that you have `.venv` folder in the project root folder.
