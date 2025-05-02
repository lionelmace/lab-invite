# 🚀 Skeleton for lab terraform and instructions 🧪

Have fun! 🎉

1. Use this repo as a [template](https://github.ibm.com/cloud-labs/skeleton/generate) for your lab preparation (with terraform!) and instructions (with docsify!).
1. Enable `Pages` in your repo, pointing to the `main` branch and the `docs` folder.
1. Eventually move this repo from GitHub Enterprise to GitHub public.
1. Obtain a [GHE token](https://github.ibm.com/settings/tokens/new). Token should have `admin:org`, `repo` permissions to read public and private repos.

## 📂 Directory structure

| File or directory | Description |
| --- | --- |
| [docs](./docs/) | Lab instructions |
| [terraform](./terraform/) | Automation to prepare the lab |

## 📖 Edit instructions

1. Use [docsify](https://docsify.js.org/#/) to create your lab instructions under [docs](./docs/).
1. View the website locally with:
   ```sh
   python -m http.server --directory docs --bind 0.0.0.0 8080
   ```

## 💻 Deploy locally

1. Copy `template.local.env` to `local.env`:
   ```sh
   cp template.local.env local.env
   ```
1. Configure `local.env`
1. Load environment:
   ```sh
   source local.env
   ```
1. Ensure you have the latest dependencies:
   ```sh
   git submodule update --recursive --remote
   ```
1. Apply:
   ```sh
   cd terraform
   terraform init
   terraform apply
   ```

## 🚀 Deploy through Schematics

You can choose to run terraform locally of course. Or you can decide to do it with Schematics so that the state is in the Cloud.

1. Copy `template.local.env` to `local.env`:
   ```sh
   cp template.local.env local.env
   ```
1. Configure `local.env`
1. Run `(source local.env && ./create-or-update-workspace.sh)` to create a Schematics workspace to deploy your resources.
1. Go to https://cloud.ibm.com/schematics/workspaces, select the workspace.
1. Under **Settings**, set variables.
1. Click **Apply plan**.
1. Use `(source local.env && ./get-credentials.sh)` to retrieve the `credentials.csv` file.

