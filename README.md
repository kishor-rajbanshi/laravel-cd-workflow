# Laravel CD Workflow

This repository hosts scripts and configuration files tailored for a Continuous Deployment (CD) workflow, meticulously crafted to streamline the deployment of your Laravel project. These resources automate essential deployment tasks on your server, ensuring a hassle-free process.

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

5. **Configure Workflow**: Inside your project's .github/workflows directory, you should have a cd.yml file. Make sure it's configured to your specific needs. This workflow is triggered on pushes and pull requests to the main branch.

## Running the Workflow

You can trigger the deployment workflow in several ways:

- Push code changes to the `main` branch.
- Create a pull request to the `main` branch.
- Manually run the workflow from the GitHub Actions page.

## Monitoring Deployment

During deployment, the workflow performs the following steps:

1. **Gracefully Takes Application Offline**: The script uses `($php artisan down) || true` to take the application offline, preventing downtime during deployment.

2. **Fetch Latest Changes**: `git pull origin main` fetches the latest changes from the `main` branch of your Git repository.

3. **Set File Permissions**: `find ./ -type f -user $(whoami) -exec chmod 775 {} \;` sets file permissions recursively, ensuring that files are owned by the current user with appropriate permissions.

4. **Install Composer Dependencies**: `$php $composer install --optimize-autoloader --no-dev --no-interaction --prefer-dist` installs Composer dependencies with optimizations and excludes development packages to reduce deployment size.

5. **Clear and Recache Optimization**: The script clears Laravel's optimization cache with `$php artisan optimize:clear` and then recaches it with `$php artisan optimize` for improved performance.

6. **Run Database Migrations**: `$php artisan migrate --force` executes database migrations with the `--force` option, suitable for non-interactive deployments.

7. **Bring Application Back Online**: After successful deployment, `$php artisan up` brings the application back online.

## Verifying Deployment

After the workflow completes successfully, verify your deployment to ensure everything is working as expected.
