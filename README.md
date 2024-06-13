# prowler-check

Here's a README file for your GitHub Actions workflow that builds, packages, and runs Prowler checks based on a matrix defined in a JSON file:

# GitHub Actions Workflow: Build and Deploy with Prowler Checks

This GitHub Actions workflow is designed to build and deploy applications while running Prowler checks based on configurations provided in a `config.json` file.

## Prerequisites

- A GitHub repository with GitHub Actions enabled.
- A `config.json` file in the root directory of your repository containing the matrix data.
- Properly configured IAM role  with the necessary permissions for AWS actions.

## Workflow Explanation

1. **Configure Job:**
   - Checks out the repository.
   - Reads the `config.json` file and sets the matrix data.

2. **Build and Package Job:**
   - Runs based on the matrix configured in the previous job.
   - Installs Prowler.
   - Runs Prowler checks according to the matrix configuration.

## Workflow File

Create a `.github/workflows/build-and-deploy.yml` file in your repository with the following content:

```yaml
name: Build and Deploy

on:
  workflow_dispatch: {}

env:
  applicationfolder: core
  AWS_REGION: us-east-2

jobs:
  configure:
    runs-on: ubuntu-latest
    outputs:
      matrix: ${{ steps.set-matrix.outputs.matrix }}
    steps:
      - name: Checkout to repository
        uses: actions/checkout@v3

      - name: Set matrix data
        id: set-matrix
        run: echo "matrix=$(jq -c . < ./config.json)" >> $GITHUB_OUTPUT

  build:
    needs: configure
    name: Build and Package
    runs-on: ubuntu-latest
    strategy:
      matrix: ${{ fromJson(needs.configure.outputs.matrix) }}
    permissions:
      id-token: write
      contents: read
    steps:

      - name: Install Prowler
        run: |
          pip install prowler
          prowler -v

      - name: Run Prowler checks
        run: |
          prowler aws --compliance ${{ matrix.compliance }} --excluded-services ${{ matrix.exclude }}

      - name: Message
        run: |
          echo "Prowler run completed"
```

## `config.json` File

Create a `config.json` file in the root directory of your repository with the following content. This file should contain the matrix data to be used in the workflow:

```json
[
  {
    "compliance": "cis_1.2",
    "exclude": "ec2,rds"
  },
  {
    "compliance": "cis_1.3",
    "exclude": "s3,lambda"
  }
]
```

## How It Works

1. **Checkout to Repository:**
   - The `actions/checkout@v3` action checks out your repository code so the workflow can access the `config.json` file.

2. **Set Matrix Data:**
   - Reads the `config.json` file and sets the `matrix` output using the `jq` command to parse the JSON file.

3. **Build and Package:**
   - Uses the matrix data set in the `configure` job.
   - Installs Prowler, a tool to perform AWS security best practices checks.
   - Runs Prowler checks based on the compliance standards and excluded services specified in the matrix.

4. **Message:**
   - Prints a message indicating the completion of the Prowler run.

## Conclusion

This workflow automates the process of building, packaging, and performing security checks on your application using Prowler. By using a JSON file to define the matrix, you can easily manage and run multiple configurations in parallel.

For more information on GitHub Actions and using matrices, visit the [GitHub Actions documentation](https://docs.github.com/en/actions).

---

This README provides a clear and concise explanation of how the workflow operates, the structure of the JSON file, and how to set up and run the workflow in a GitHub repository.
