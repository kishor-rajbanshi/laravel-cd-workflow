# Laravel CD Workflow

This repository hosts scripts and configuration files tailored for a Continuous Deployment (CD) workflow, meticulously crafted to streamline the deployment of your Laravel project. These resources automate essential deployment tasks on your server, ensuring a hassle-free process.

## Folder structure

```
/.github
  /scripts
    - composer.sh
    - php.sh
    - deploy.sh
  /workflows
    - deploy.yml
README.md
LICENSE
```

## GitHub Actions Workflow Configuration

To ensure seamless integration with GitHub Actions, follow these steps:

1. **Create an SSH Key Pair**:

   Generate an SSH key pair on your local machine using the following command, replacing `your_email@example.com` with your email:

   ```shell
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. **Add Public Key to Server**:

   Copy the public key (`id_ed25519.pub`) to your server's `~/.ssh/authorized_keys` file for the user you'll use to connect via SSH.

3. **Set Up GitHub Actions Secret**:

   In your GitHub repository, navigate to "Settings" > "Secrets and variables" > "Actions" > "Secrets" and create a new secret named `SSHKEY`. Paste the private SSH key (`id_ed25519`) into this secret.

4. **Set Up GitHub Actions Variables**:

   In your GitHub repository, go to "Settings" > "Secrets and variables" > "Actions" > "Variables" and create the following variables for your GitHub Actions workflow:

   - `BASEPATH`: Absolute path on the server where your Laravel project is located.
   - `HOST`: IP address or hostname of your server.
   - `PORT`: SSH port (usually 22).
   - `USERNAME`: Username for SSH access.

## Running the Workflow

You can trigger the deployment workflow in several ways:

- Push code changes to the `main` branch.
- Create a pull request to the `main` branch.
- Manually run the workflow from the GitHub Actions page.

## Monitoring Deployment

The workflow will:

- SSH into your server.
- Set file permissions (recursively applying `chmod 775` to files owned by the current user).
- Check for the highest installed PHP version and ensure it meets your project's minimum requirement.
- Run Composer to install dependencies, optimize autoloaders, and remove development packages.
- Clear Laravel's optimization cache.
- Run database migrations with the `--force` option.
- Bring the application back up.

## Verifying Deployment

After the workflow completes successfully, verify your deployment to ensure everything is working as expected.
