# ianblenke/docker-wsman

[ianblenke/docker-wsman](github.com/ianblenke/docker-wsman) is the public git repo for the docker hub image [ianblenke/wsman](https://registry.hub.docker.com/u/ianblenke/wsman/)

wsman is the command-line client that is part of the Openswman project's [wsmancli](https://github.com/Openwsman/wsmancli)

This is a command-line client for managing WS-Management API enabled hosts.

This project uses the opensuse base docker image as the latest version of wsmancli is available at the [open build service](https://build.opensuse.org/package/show/Openwsman/wsmancli)

Most RPM-based Linux distributions ship the wsmancli package as well.

## Usage

    docker run -ti --rm ianblenke/wsman [Option...] <action> <Resource Uri>

### Help Options

The common `[Option...]` parameters include:

    -?, --help
    --help-all          Show help options
    --help-enumeration  Enumeration Options
    --help-tests        Test Cases
    --help-cim          CIM Options
    --help-flags        Request Flags
    --help-event        Subscription Options

### Application Options

Application specific `[Option...]` parameters include:

    -q, --version                          Display application version
    -d, --debug=1-6                        Set the verbosity of debugging output.
    -j, --encoding                         Set request message encoding
    -c, --cacert=<filename>                Certificate file to verify the peer
    -A, --cert=<filename>                  Certificate file. The certificate must be in PEM format.
    -K, --sslkey=<key>                     SSL Key.
    -u, --username=<username>              User name
    -g, --path=<path>                      Service Path (default: 'wsman')
    -J, --input=<filename>                 File with resource for Create and Put operations in XML, can be a SOAP envelope
    -p, --password=<password>              User Password
    -h, --hostname=<hostname>              Host name
    -b, --endpoint=<url>                   End point
    -P, --port=<port>                      Server Port
    -X, --proxy=<proxy>                    Proxy name
    -Y, --proxyauth=<proxyauth>            Proxy user:pwd
    -y, --auth=<basic|digest|gss>          Authentication Method
    -a, --method=<custom method>           Method (Works only with 'invoke')
    -k, --prop=<key=val>                   Properties with key value pairs (For 'put', 'invoke' and 'create')
    -C, --config-file=<file>               Alternate configuration file
    -O, --out-file=<file>                  Write output to file
    -V, --noverifypeer                     Not to verify peer certificate
    -v, --noverifyhost                     Not to verify hostname
    -I, --transport-timeout=<time in sec>  Transport timeout in seconds

### Identify

Using `wsman identify` is the simplest way to ensure correct client-server communication.

Run it as

    docker run -ti --rm ianblenke/wsman identify -h <hostname> -P <port> -u <user> -p <pass>

    docker run -ti --rm ianblenke/wsman identify -h localhost -P 5985 -u wsman -p secret

### Enumerate

Enumeration requires a `[[resource path]]` to address the correct CIM class

    docker run -ti --rm ianblenke/wsman enumerate -h localhost -P 5985 -u wsman -p secret http://sblim.sf.net/wbem/wscim/1/cim-schema/2/Linux_ComputerSystem

This call will return an XML representation of the matching resource(s).

## WSMAN - Windows / Linux Command Conversion

There is a great [WSMAN - Windows / Linux Command Conversion](./README-Commands.md) in the [README-Commands.md](./README-Commands.md) document.

## Further links

[Dell](http://www.dell.com) has put together a document about [Programmatic scripting with WSMAN](http://en.community.dell.com/techcenter/extras/m/white_papers/20097326/download.aspx&ei=d7xbUriGDM2k0AW8zYHgCQ&usg=AFQjCNF28G78x1dFIwk66YMVvaeWQSCA8w&sig2=KCDsb1XWOgbe1KSgxb1Z7A)

