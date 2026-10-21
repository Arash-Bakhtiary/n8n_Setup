# n8n Local Installation (Docker + PyCharm)

This project installs **n8n** on your own computer with one command.
It includes a **Python task runner**, so the n8n **Code node** can run Python
with libraries such as `scikit-learn`.

You only need to install three programs, clone this project, and run a setup
script. The rest is automatic.

> [!IMPORTANT]
> **Three golden rules**
> 1. **Never** share, upload or commit your `.env` file. It contains your secret keys.
> 2. **Never** run `docker compose down -v` unless you want to delete **all** your workflows.
> 3. **Never** change `N8N_ENCRYPTION_KEY` in `.env` after the first start.

---

## Contents

1. [What you need](#1-what-you-need)
2. [Install Docker Desktop](#2-install-docker-desktop)
3. [Install Git](#3-install-git)
4. [Install PyCharm](#4-install-pycharm)
5. [Clone this project in PyCharm](#5-clone-this-project-in-pycharm)
6. [Open the PyCharm terminal](#6-open-the-pycharm-terminal)
7. [Run the setup script](#7-run-the-setup-script)
8. [Check that n8n is running](#8-check-that-n8n-is-running)
9. [Open n8n and create your account](#9-open-n8n-and-create-your-account)
10. [Test the Python Code node](#10-test-the-python-code-node)
11. [Daily use](#11-daily-use)
12. [Back up your workflows](#12-back-up-your-workflows)
13. [Get course updates](#13-get-course-updates)
14. [Add Python packages](#14-add-python-packages)
15. [Public URL for Telegram and webhooks](#15-public-url-for-telegram-and-webhooks)
16. [Troubleshooting](#16-troubleshooting)
17. [What is in this project](#17-what-is-in-this-project)

---

## 1. What you need

| Requirement | Details |
| --- | --- |
| Computer | macOS (Apple Silicon or Intel), Windows 10/11 (64-bit), or Linux |
| Memory | 8 GB RAM or more recommended |
| Disk space | At least 10 GB free |
| Internet | Needed for the first installation (downloads about 2 GB) |
| Programs | Docker Desktop, Git, PyCharm (installed in steps 2–4) |

You do **not** need to install Python or n8n yourself. Both run inside Docker.

---

## 2. Install Docker Desktop

Docker runs n8n in isolated "containers" on your computer.

### macOS

1. Find out which chip your Mac has: **Apple menu  → About This Mac**.
   - **Chip: Apple M1 / M2 / M3 / M4** → you need the **Apple Silicon** version.
   - **Processor: Intel** → you need the **Intel chip** version.
2. Download Docker Desktop from **https://www.docker.com/products/docker-desktop/**
3. Open the downloaded `.dmg` file and drag **Docker** into **Applications**.
4. Open **Docker** from Applications and accept the terms.
5. Wait until the whale icon in the menu bar is steady and Docker Desktop shows **Engine running**.

### Windows

1. Download Docker Desktop from **https://www.docker.com/products/docker-desktop/**
2. Run the installer. Keep **Use WSL 2 instead of Hyper-V** checked.
3. Restart your computer when asked.
4. Open **Docker Desktop** and wait until it shows **Engine running**.

> [!TIP]
> If Docker says **WSL 2 installation is incomplete**, open **PowerShell as Administrator**,
> run `wsl --update`, then restart your computer.

### Linux

Install **Docker Engine** and the **Docker Compose plugin** for your distribution
(https://docs.docker.com/engine/install/), then allow your user to run Docker:

```bash
sudo usermod -aG docker $USER
```

Log out and back in for this to take effect.

### Recommended setting (all systems)

In Docker Desktop, open **Settings → Resources** and give Docker at least **4 GB of memory**.

> [!NOTE]
> Docker Desktop must be **running** every time you use n8n.

---

## 3. Install Git

Git downloads ("clones") this project from GitHub.

### macOS

Open the **Terminal** app and run:

```bash
git --version
```

- If a version number appears, Git is already installed.
- If a window asks to install **Command Line Developer Tools**, click **Install** and wait.

### Windows

1. Download Git from **https://git-scm.com/download/win**
2. Run the installer and keep all default options.

### Linux

```bash
sudo apt install git        # Ubuntu / Debian
```

---

## 4. Install PyCharm

1. Download PyCharm from **https://www.jetbrains.com/pycharm/download/**
2. Install and open it.

Any edition works.

---

## 5. Clone this project in PyCharm

1. In PyCharm, open the clone window:
   - On the **Welcome screen**: click **Clone Repository** (or **Get from VCS**).
   - If a project is already open: **File → New → Project from Version Control…**
2. In **URL**, paste:

   ```text
   https://github.com/Arash-Bakhtiary/n8n_Setup.git
   ```

3. In **Directory**, choose where to save the project, for example your `Documents` folder.
4. Click **Clone**.
5. If PyCharm asks whether to trust the project, click **Trust Project**.
6. If PyCharm asks to create a **virtual environment** or configure a **Python interpreter**,
   click **Cancel** or close the message. You don't need one, because Python runs inside Docker.

> [!TIP]
> **Prefer the terminal?** Run this instead, then open the folder in PyCharm with **File → Open…**:
>
> ```bash
> git clone https://github.com/Arash-Bakhtiary/n8n_Setup.git
> ```

---

## 6. Open the PyCharm terminal

Open the terminal inside PyCharm:

- **macOS:** **View → Tool Windows → Terminal**, or press **⌥ F12** (Option + F12)
- **Windows / Linux:** **View → Tool Windows → Terminal**, or press **Alt + F12**

Check that Docker works:

```bash
docker --version
docker compose version
```

Both commands should print a version number.

> [!WARNING]
> If you see `Cannot connect to the Docker daemon` or `command not found`,
> Docker Desktop is not running. Start it and wait for **Engine running**.

---

## 7. Run the setup script

Run **one** command, depending on your system.

### macOS / Linux

```bash
bash setup.sh
```

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1
```

The script will:

1. Check that Docker is running
2. Create your private `.env` file with two random secret keys
3. Build the Python task runner
4. Start n8n

> [!NOTE]
> The **first** run takes about **3–10 minutes**, because Docker downloads n8n and
> builds the Python libraries. Later starts take only a few seconds.

When it finishes, you'll see:

```text
==> n8n is starting. Open: http://localhost:5678
```

---

## 8. Check that n8n is running

```bash
docker compose ps
```

You should see **two** containers:

| NAME | STATUS |
| --- | --- |
| `n8n` | `Up ... (healthy)` |
| `n8n-runners` | `Up ...` |

If `n8n` shows `(health: starting)`, wait 30 seconds and run the command again.

---

## 9. Open n8n and create your account

1. Open **http://localhost:5678** in your browser.
2. Fill in the form to create your **owner account** (email, name and password).

This account exists **only on your computer**. Write down your password.

---

## 10. Test the Python Code node

1. In n8n, click **Create Workflow**.
2. Add a **Manual Trigger** node.
3. Click **+** after it and add a **Code** node.
4. In the Code node, set **Language** to **Python**.
5. Replace the code with:

   ```python
   from sklearn.preprocessing import StandardScaler

   data = [[1], [2], [3], [4]]
   scaler = StandardScaler()
   result = scaler.fit_transform(data)

   return [{"json": {"result": result.tolist()}}]
   ```

6. Click **Execute workflow**.

If the output shows a list of numbers, **your installation is complete.** 🎉

---

## 11. Daily use

Run all commands in the PyCharm terminal, inside the project folder.

| I want to… | Command |
| --- | --- |
| Start n8n | `docker compose up -d` |
| Stop n8n | `docker compose down` |
| See if it's running | `docker compose ps` |
| See n8n logs | `docker logs -f n8n` (press **Ctrl + C** to exit) |
| See runner logs | `docker logs -f n8n-runners` |
| Apply changes after editing a project file | `docker compose up -d --build` |

**Typical day:**

1. Start **Docker Desktop**.
2. Open the project in PyCharm.
3. Run `docker compose up -d`.
4. Open **http://localhost:5678**.

Your workflows are saved permanently. They survive `docker compose down`,
restarting your computer and updating the project.

---

## 12. Back up your workflows

### macOS / Linux

```bash
bash backup.sh
```

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File backup.ps1
```

Your workflows and credentials are exported to `backups/<date>/`.

> [!IMPORTANT]
> Exported credentials stay **encrypted**. They can only be restored with the same
> `N8N_ENCRYPTION_KEY`. Keep a private copy of your `.env` file together with your backups,
> for example in a password manager. Never upload it to GitHub.

---

## 13. Get course updates

When your teacher updates this project, get the new version:

1. In PyCharm: **Git → Pull…** and click **Pull**.
   (Or in the terminal: `git pull`)
2. Apply the update:

   ```bash
   docker compose up -d --build
   ```

Your workflows and your `.env` file are **not** changed by updates.

> [!NOTE]
> If Git says your **local changes would be overwritten**, you edited a project file
> (for example `requirements.txt`). Ask your teacher before continuing.

---

## 14. Add Python packages

To use another Python library in the Code node, change **two** files.

**1. Install it** by adding it to `requirements.txt`:

```text
scikit-learn==1.9.1
pandas
```

**2. Allow it** by adding the **import name** to `N8N_RUNNERS_EXTERNAL_ALLOW` in `n8n-task-runners.json`:

```json
"N8N_RUNNERS_EXTERNAL_ALLOW": "sklearn,pandas"
```

**3. Rebuild:**

```bash
docker compose up -d --build
```

> [!WARNING]
> **Installed ≠ allowed.** A package in `requirements.txt` but not in the allowlist gives
> `Import of module ... is disallowed`. A package in the allowlist but not in
> `requirements.txt` gives `No module named ...`.

The package name and the import name are not always the same:

| In `requirements.txt` | In your Python code | In the allowlist |
| --- | --- | --- |
| `scikit-learn` | `import sklearn` | `sklearn` |
| `beautifulsoup4` | `from bs4 import BeautifulSoup` | `bs4` |
| `pandas` | `import pandas` | `pandas` |

To allow a **standard library** module (for example `statistics`), add it to
`N8N_RUNNERS_STDLIB_ALLOW` in the same file.

---

## 15. Public URL for Telegram and webhooks

Services like Telegram cannot reach `localhost`. A free **Cloudflare Quick Tunnel**
gives your local n8n a temporary public HTTPS address.

**1. Install cloudflared** (one time):

- **macOS:** `brew install cloudflared` (needs Homebrew: https://brew.sh)
- **Windows:** `winget install --id Cloudflare.cloudflared`
- **Linux:** see https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/

**2. Start the tunnel** in a **second** terminal tab, and keep it open:

```bash
cloudflared tunnel --url http://localhost:5678
```

Copy the address it prints, for example `https://random-words.trycloudflare.com`.

**3. Edit `.env`** in PyCharm. Change both lines to your address and keep the `/` at the end:

```text
WEBHOOK_URL=https://random-words.trycloudflare.com/
N8N_EDITOR_BASE_URL=https://random-words.trycloudflare.com/
```

**4. Apply the change:**

```bash
docker compose up -d
```

**5. In n8n:** deactivate and then re-activate your Telegram workflow, so Telegram
receives the new address.

> [!NOTE]
> Every time you start the tunnel you get a **new** address, so repeat steps 2–5.
> When you're done, set both lines back to `http://localhost:5678/` and run `docker compose up -d`.

> [!WARNING]
> While the tunnel is running, your n8n login page is reachable from the internet.
> Use a strong password.

---

## 16. Troubleshooting

| Problem | Solution |
| --- | --- |
| `Cannot connect to the Docker daemon` | Start Docker Desktop and wait for **Engine running**. |
| Windows: `WSL 2 installation is incomplete` | In PowerShell **as Administrator**: `wsl --update`, then restart. |
| Windows: `running scripts is disabled on this system` | Use the exact command from step 7, including `-ExecutionPolicy Bypass`. |
| macOS: `xcrun: error: invalid active developer path` | Run `xcode-select --install`, then try again. |
| `Missing N8N_ENCRYPTION_KEY` | You skipped the setup script. Run step 7. |
| `The container name "/n8n" is already in use` | An older n8n is installed. If it contains work you need, **ask your teacher first**. Otherwise run `docker rm -f n8n n8n-runners`, then `docker compose up -d`. |
| `Bind for 127.0.0.1:5678 failed: port is already allocated` | Another program uses port 5678. In `.env`, change `N8N_PORT` and both URLs (e.g. to `5679`), then run `docker compose up -d`. |
| `dependency failed to start: container n8n is unhealthy` | Run `docker logs n8n --tail 30` and read the last lines. |
| `Mismatching encryption keys` | Your `.env` was changed or recreated. Restore your original `.env`. |
| `n8n-runners` shows `Restarting` | Run `docker logs n8n-runners --tail 30`. Usually fixed with `docker compose up -d --build`. |
| `Import of module ... is disallowed` | Add it to the allowlist. See [step 14](#14-add-python-packages). |
| `No module named ...` | Add it to `requirements.txt`. See [step 14](#14-add-python-packages). |
| Forgot your n8n password | Run `docker exec -it n8n n8n user-management:reset`, then open http://localhost:5678 and create the owner account again. Your workflows are kept. |
| First build is very slow | Normal. The first build compiles Python libraries and can take up to 10 minutes. |

**Start completely fresh** (⚠️ deletes **all** workflows, credentials and your account):

```bash
docker compose down -v
```

Then delete the `.env` file and run step 7 again.

---

## 17. What is in this project

```text
n8n_Setup/
├── README.md               This guide
├── compose.yaml            Defines the two Docker containers (n8n + task runner)
├── Dockerfile.runners      Builds the Python task runner with your packages
├── requirements.txt        Python packages to install
├── n8n-task-runners.json   Which Python/JavaScript imports are allowed
├── .env.example            Settings template (safe to share)
├── .env                    YOUR private settings, created by setup (never share)
├── setup.sh / setup.ps1    One-time setup (macOS-Linux / Windows)
├── backup.sh / backup.ps1  Backup (macOS-Linux / Windows)
├── backups/                Your backup exports
├── .gitignore              Keeps .env and backups out of Git
└── .gitattributes          Keeps scripts working on every operating system
```

### Which file do I change?

| I want to… | File | Then run |
| --- | --- | --- |
| Add a Python package | `requirements.txt` **and** `n8n-task-runners.json` | `docker compose up -d --build` |
| Allow a standard library module | `n8n-task-runners.json` | `docker compose up -d --build` |
| Change port, URL or timezone | `.env` | `docker compose up -d` |
| Add API keys (OpenAI, Telegram, Gmail…) | **n8n UI → Credentials** (not a file) | – |

### Where is my data?

Your workflows, credentials and account are stored in a Docker volume called
`n8n_setup_n8n_data`. It is **not** inside the project folder, and it is not
removed when you stop n8n, update the project or restart your computer.