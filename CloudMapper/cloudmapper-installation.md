CloudMapper
========

**Note** the Network Visualization functionality (command `prepare`) is no longer maintained.

CloudMapper helps you analyze your Amazon Web Services (AWS) environments. 
The original purpose was to generate network diagrams and display them in your browser (functionality no longer maintained). 
It now contains much more functionality, including auditing for security issues.

- [Network mapping demo](https://duo-labs.github.io/cloudmapper/)
- [Report demo](https://duo-labs.github.io/cloudmapper/account-data/report.html)
- [Intro post](https://duo.com/blog/introducing-cloudmapper-an-aws-visualization-tool)
- [Post to show spotting misconfigurations in networks](https://duo.com/blog/spotting-misconfigurations-with-cloudmapper)
- [Post on performing continuous auditing](https://duo.com/blog/continuous-auditing-with-cloudmapper)

# Commands

- `audit`: Check for potential misconfigurations.
- `collect`: Collect metadata about an account. More details [here](https://summitroute.com/blog/2018/06/05/cloudmapper_collect/).
- `find_admins`: Look at IAM policies to identify admin users and roles, or principals with specific privileges. More details [here](https://summitroute.com/blog/2018/06/12/cloudmapper_find_admins/).
- `find_unused`: Look for unused resources in the account.  Finds unused Security Groups, Elastic IPs, network interfaces, volumes and elastic load balancers.
- `prepare`/`webserver`: See [Network Visualizations](docs/network_visualizations.md)
- `public`: Find public hosts and port ranges. More details [here](https://summitroute.com/blog/2018/06/13/cloudmapper_public/).
- `sg_ips`: Get geoip info on CIDRs trusted in Security Groups. More details [here](https://summitroute.com/blog/2018/06/12/cloudmapper_sg_ips/).
- `stats`: Show counts of resources for accounts. More details [here](https://summitroute.com/blog/2018/06/06/cloudmapper_stats/).
- `weboftrust`: Show Web Of Trust. More details [here](https://summitroute.com/blog/2018/06/13/cloudmapper_wot/).
- `report`: Generate HTML report. Includes summary of the accounts and audit findings. More details [here](https://summitroute.com/blog/2019/03/04/cloudmapper_report_generation/).
- `iam_report`: Generate HTML report for the IAM information of an account. More details [here](https://summitroute.com/blog/2019/03/11/cloudmapper_iam_report_command/).


If you want to add your own private commands, you can create a `private_commands` directory and add them there.



```bash
# On macOS

# clone the repo
git clone https://github.com/duo-labs/cloudmapper.git

# Install pre-reqs for pyjq
brew install autoconf automake awscli freetype jq libtool python3 graphviz
cd cloudmapper/
# Create and activate virtual environment for Python
# 'deactivate' to deactivate virtual environment
python3 -m venv ./venv && source venv/bin/activate

pip install --prefer-binary -r requirements.txt
```

requirements.txt
```bash
astroid==2.8.4
autoflake==1.4
autopep8==1.6.0
boto3==1.19.10
botocore==1.22.10
certifi==2023.7.22
chardet==4.0.0
charset-normalizer==2.0.7
coverage==6.1.1
cycler==0.11.0
docutils==0.18
idna==3.3
isort==5.10.0
Jinja2==3.0.2
jmespath==0.10.0
json-cfg==0.4.2
kiwisolver==1.3.2
kwonly-args==1.0.10
lazy-object-proxy==1.6.0
MarkupSafe==2.0.1
matplotlib==3.4.3
mccabe==0.6.1
mock==4.0.3
netaddr==0.8.0
nose==1.3.7
numpy==1.22.0
pandas==1.3.4
parliament==1.5.2
Pillow==10.0.1
platformdirs==2.4.0
policyuniverse==1.4.0.20210819
pycodestyle==2.8.0
pyflakes==2.4.0
pyjq==2.4.0
pylint==2.11.1
pyparsing==3.0.4
python-dateutil==2.8.2
pytz==2021.3
PyYAML==6.0
requests==2.26.0
s3transfer==0.5.0
scipy==1.10.0
seaborn==0.11.2
six==1.16.0
toml==0.10.2
typed-ast==1.4.3
typing-extensions==3.10.0.2
urllib3==1.26.18
wrapt==1.13.3

```