# 🚀 Skeleton for lab terraform and instructions 🧪

Have fun! 🎉

1. Use this repo as a [template](https://github.ibm.com/cloud-labs/skeleton/generate)
1. Enable `Pages` in your repo, pointing to the `main` branch and the `docs` folder.

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

## 🚀 Deploy through Schematics

1. Copy `template.local.env` to `local.env`
1. Configure `local.env`
1. Source `local.env`
1. Run `./create-workspace.sh` to create a Schematics workspace to deploy your resources.
1. Go to https://cloud.ibm.com/schematics/workspaces, select the workspace.
1. Under **Settings**, set variables.
1. Click **Apply plan**.
