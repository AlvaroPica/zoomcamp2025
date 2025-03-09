
# Jupytext

Initial cell of any notebook:

```python
%load_ext autoreload
%autoreload 2
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"
```

`%load_ext autoreload` This loads the autoreload extension, which allows automatic reloading of imported modules. Normally, if you modify an imported module (import my_module), you need to restart the kernel or use importlib.reload(my_module). autoreload makes sure that every time you run a cell, updated modules are reloaded automatically.

`%autoreload 2` This enables automatic reloading of all modules in the project. Best for development, as you can edit `.py` files and see the changes without having to restart the kernel.

`from IPython.core.interactiveshell import InteractiveShell`: This imports InteractiveShell, a core part of IPython that manages the execution environment inside Jupyter.

`InteractiveShell.ast_node_interactivity = "all"`: Changes how Jupyter displays output in a cell. By default, Jupyter only shows the last expression's output in a cell. This command modifies that behavior:
    - `all`: Shows outputs from all statements in a cell.
    - `last_expr` (Default): Only shows the last statement's output in a cell.
    - `none`:  No output is displayed.
    - `last`: Only the last statement is displayed (like "last_expr").

## Combine .ipynb and .py files with Jupytext

To install (using poetry):

```bash
poetry add jupytext
```

Activate automatic conversion in the terminal (Every time you save the .ipynb, it will also update the .py)

```bash
jupytext --set-formats ipynb,py data_extraction_example.ipynb 
```

Convert script to notebook

```bash
jupytext --to notebook script.py
```

If you used synchronization with Jupytext, you can convert automatically with:

```bash
jupytext --sync script.py
```

```json

## Configure Jupytext globally

```bash
mkdir -p ~/.jupyter
nano ~/.jupyter/jupytext_config.py
```

```python
c = get_config()
c.Jupytext.formats = "ipynb,py"
c.Jupytext.auto_save = True
```

### Configure Jupytext in VSCode

```json
{
  "jupytext.formats": "ipynb,py",
  "jupyter.textOutputLimit": 100,
  "notebook.cellToolbarVisibility": "hover" # Show toolbar on hover in .py files
}
```

I have not managed to sync so when you click save on one changes the other.

## Clean notebook metadata for GIT

If you want Git to automatically clean notebooks before adding them to version control:

```bash
pip install nbstripout
```

```bash
nbstripout notebook.ipynb
```

Now, every time you commit, nbstripout will remove execution counts, metadata, and outputs before saving in Git.

## Add to .gitignore unneeded files

```bash
.ipynb_checkpoints/
```