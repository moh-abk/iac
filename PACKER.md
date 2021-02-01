# Packer
Packer is a free and open source tool for creating golden images for multiple platforms from a single source configuration.

## Usage 
Packer is used to create a Windows Virtual Machine image in Azure aka Golden Image.

Update the packer/windows-variables.json with SPN details and then execute:

```shell
packer build -var 'image-identifier=$(git rev-parse --short=5 HEAD)' -var-file=windows-variables.json windows-2019-iis.json`
```

To ensure images are not conflicting and implement versioning, the `sha` of the latest commit is appended to the image name.