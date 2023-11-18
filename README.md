# Cloud Bootstrapper CLI - docker
Run Cloud Bootstrapper CLI using Docker. The easy way to get started.


#### Prerequisites
Make sure you have Docker installed before running these scripts.

### Usage

#### Linux
In a Bash terminal, use the following command to build the Cloud Boot Docker image:

```shell
docker build -t "cloudboot:latest" - < <(curl -s "https://raw.githubusercontent.com/cloudboot/cli-docker/main/Dockerfile")
```

Then, run the configuration script:
```shell
sh <(curl -s "https://raw.githubusercontent.com/cloudboot/cli-docker/main/install.sh") 
```

#### Windows
To build the Docker image in a PowerShell terminal, run the following command:

```commandline
curl -s "https://raw.githubusercontent.com/cloudboot/cli-docker/main/Dockerfile" -OutFile Dockerfile ; docker build -t "cloudboot:latest" -f .\Dockerfile . ; Remove-Item -Path .\Dockerfile
```

Then, run the configuration script:
```commandline
curl -s "https://raw.githubusercontent.com/cloudboot/cli-docker/main/install.sh" | Invoke-Expression
```

##### Please note:

This product is not officially endorsed by Google.
You should use this product at your own risk.

##### Disclaimer:

Google is not responsible for any damages caused by the use of this product.

## License
This project is licensed under the MIT License.
