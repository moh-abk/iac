# GitOps

GitOps works by using Git as a single source of truth for declarative infrastructure and applications.
This repository utilizes [GitHub Actions](https://docs.github.com/en/actions).

## GitOps Flow

On every commit to master (For demo purposes only);

- [x] Checkout master branch
- [x] Build Windows Server IIS image
- [x] Deploy new image with Terraform
- [x] Implement any changes to infrastructure e.g. scaling VMSS etc
