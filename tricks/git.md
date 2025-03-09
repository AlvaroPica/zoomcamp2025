# Git tricks

- Check remote url:

```bash
git remote -v
```

Check SSH agent is working properly:

In Git Bash:

Check agent and add SSH key to agent:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_github_ed25519
```

In PowerShell:

```bash
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_github_ed25519
```

If it does not work PowerShell might be using the wrong SSH client. To ensure Git uses the correct one, run:

git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
