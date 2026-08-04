
# Configure Github secrets

In GitHub → Settings → Secrets and variables → Actions, add:
- `SSH_PRIVATE_KEY`
- `SSH_KNOWN_HOSTS`
- `SSH_HOST`
- `SSH_USER`
- `SSH_TARGET_DIR`

I've added the `SSH public key` to the repository; see `id_ed25519_deploy.pub` 

Get the values for `SSH_KNOWN_HOSTS` with this command: 

```shell
$ ssh-keyscan spider.knutsel.space
```

Copy all the lines to the `SSH_KNOWN_HOSTS` variable


# Configure low privilege user on `OpenBSD` webhost

The pattern: a locked-password account, whose SSH key is bound to a forced command running rrsync (a small, official rsync support script) in write-only mode against that one directory. That way, even if the private key leaked, it could only push files into that folder — no shell, no reading, no other paths.

## 1. Create the user — home dir, ordinary shell (needed below), no usable password

```shell
useradd -m -d /home/deploy -s /bin/ksh deploy
```

### confirm the password field is locked (should show '*')
```shell
$ grep deploy /etc/master.passwd
```

# 2. Prepare .ssh
```
su - deploy && cd
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

Check if `rrsync` is installed

```shell
pkg_info -L rsync | grep rrsync

/usr/local/bin/rrsync
/usr/local/man/man1/rrsync.1
```

# 4. Make the target dir writable by deploy, still readable by your web server user
```shell
chown deploy:www /var/www/htdocs/egbertpot.nl
chmod 750 /var/www/htdocs/egbertpot.nl
```

# 5. Lock the key down with a forced command
```shell
cat >> /home/deploy/.ssh/authorized_keys <<'EOF'
restrict,command="/usr/local/bin/rrsync -wo /var/www/htdocs/egbertpot.nl" ssh-ed25519 AAAA...your-deploy-public-key... github-actions-deploy
EOF

chmod 600 /home/deploy/.ssh/authorized_keys
chown deploy:deploy /home/deploy/.ssh/authorized_keys
```

- /bin/ksh not /sbin/nologin — counterintuitive, but nologin refuses to run any command, including the forced one, so it would break this entirely. Safety instead comes from the locked password (no valid hash → password/console login fails) plus the forced command below.
- command="..." — whatever the GitHub Actions runner asks for over SSH is ignored; rrsync runs instead every time, regardless.
- -wo — write-only: deploy can push into that directory but can't read anything back out.
- restrict — modern OpenSSH shorthand covering no-pty, no-port-forwarding, no-X11-forwarding, no-agent-forwarding, no-user-rc in one flag.
- The path baked into command= is what actually controls the destination — the SSH_TARGET_DIR secret in your workflow becomes cosmetic/must-match-for-clarity only; the server ignores whatever path the client sends and always writes here.

Test before wiring it into CI (use the deploy private key you generated earlier):

# dry run — should show what would transfer, nothing written

```shell
rsync -avzn --delete -e "ssh -i deploy_key" output/ deploy@your-vm-host:/var/www/htdocs/egbertpot.nl
```
Since the `authorized_keys` file alreayd holds the `/var/www/htdocs/egbertpot.nl` path, you should not specify the full path again. That is why the destination should look like `deploy@spider.knutsel.space:.`

e.g.

```shell
rsync -avzn --delete -e "ssh -i id_ed25519_deploy" output/ deploy@spider.knutsel.space:.
```

drop -n once that looks right

```
rsync -avz --delete -e "ssh -i id_ed25519_deploy" output/ deploy@spider.knutsel.space:.
```


Check if the `PGP Web Key Directory setup` is still correct via : [[https://www.webkeydirectory.com/]]
