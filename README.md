# Laravel CD Workflow

This repository hosts scripts and configuration files tailored for a Continuous Deployment (CD) workflow, meticulously crafted to streamline the deployment of your Laravel project. These resources automate essential deployment tasks on your server, ensuring a hassle-free process.

## Configuration

### 1. Clone the Repository

Clone into the project's root directory.

```bash
git clone git@github.com:kishor-rajbanshi/laravel-cd-workflow.git .github
rm -rf .github/.git
```

### 2. Create an SSH Key Pair

Generate an SSH key pair on your local machine using the following command, replacing `kishorrajbanshi00@gmail.com` with your email:

```shell
ssh-keygen -t ed25519 -C "kishorrajbanshi00@gmail.com"
```

### 3. Add Public Key to Server

Copy the public key (`id_ed25519.pub`) to your server's `~/.ssh/authorized_keys` file for the user you'll use to connect via SSH.

### 3. Set Up GitHub Actions Secret

In your GitHub repository, navigate to "Settings" -> "Secrets and variables" -> "Actions" -> "Secrets" and create a new secret named `<BRANCH_NAME>_SSHKEY`, containing the private SSH key (`id_ed25519`).

Replace <BRANCH_NAME> with either "main" or "develop" depending on where you intend to execute the workflow.

### 4. Set Up GitHub Actions Variables

In your GitHub repository, go to "Settings" -> "Secrets and variables" -> "Actions" -> "Variables" and create the following variables for your GitHub Actions workflow:

- `<BRANCH_NAME>_BASEPATH`: Absolute path to the project's root folder on the remote machine.
- `<BRANCH_NAME>_HOST`: IP address or hostname of your remote machine.
- `<BRANCH_NAME>_PORT`: SSH port (usually 22).
- `<BRANCH_NAME>_USERNAME`: Username for SSH access.
- `<BRANCH_NAME>_MIN_PHP_VERSION`: Minimum PHP version required.
- `<BRANCH_NAME>_COMPOSER`: (Optional) Composer path if stored in a non-default location.
