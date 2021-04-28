# Apache-IAM HERD integration demo 

## Install APACHE OIDC module

On CentOS7 for instance:

```bash
yum -y install httpd httpd-tools mod_ssl curl
yum install -y https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.0/cjose-0.6.1.5-1.el7.x86_64.rpm
yum -y install https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.7/mod_auth_openidc-2.4.7-1.el7.x86_64.rpm
```

## Register IAM client

- go to `https://herd.cloud.cnaf.infn.it/`
- select the tab MitreID
- select the client self-registration tab and click on new client
- give a name to the client and indicate as redirect uri a "vanity" URL that must point to a path protected by this module but must NOT point to any content
  - e.g. if you want to protect `https://mysite.com/example`, a possible redirect uri will be `https://mysite.com/example/redirect_uri`
- then on tab Access and add the Scope `offline_access`
- also add the response type `code token id_token`
- click on save
- note down the client id, secret and other configuration secret

[VIDEO-DEMO](https://youtu.be/sVzloqCMNqg) 

## Protect a page: authorizing only members of a IAM group

To protect `https://mysite.com/example/` a config file will looks like: 

```
LogLevel debug

Listen 443
ServerName mysite.com

<VirtualHost _default_:443>

  SSLEngine on
  SSLCertificateFile "/certs/hostcert.pem"
  SSLCertificateKeyFile "/certs/hostcert.key"
  SSLCipherSuite HIGH:!aNULL:!MD5

  OIDCProviderMetadataURL https://herd.cloud.cnaf.infn.it/.well-known/openid-configuration
  OIDCClientID CLIENT_ID_HERE
  OIDCClientSecret CLIENT_SECRET_HERE

  # OIDCRedirectURI is a vanity URL that must point to a path protected by this module but must NOT point to any content
  OIDCRedirectURI https://mysite.com/example/redirect_uri
  OIDCCryptoPassphrase CHANGEME


  <Location /example/>
     AuthType openid-connect
     Require claim groups:herd
  </Location>

</VirtualHost>
```
