GitHub Codespaces

Tool to have as a remote machine

Free account:
    - 2-core (60h free/month)
    - 4-core (30h free/month)

- Create a repo
- Create Codespaces
- Open in VSCode

The CodeSpace already have:
Python, Docker

Install terraform:

```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

Also install Jupyter:

`pip install jupyter`

Check jupyter notebook and that Port has been forwarded properly.