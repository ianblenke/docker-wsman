# WSMAN - Windows / Linux Command Conversion

This is an adaptation of Jim Slaughter's article [WSMAN - Linux / Windows Conversion](http://en.community.dell.com/techcenter/systems-management/w/wiki/4375.wsman-windows-linux-command-conversion)

## SYSTEMS MANAGEMENT - WIKI

This article provides examples of WinRM commands and their OpenWSMAN equivalents for use with iDRAC7 on Dell PowerEdge Servers. 

For all of the commands that follow in the sections below, a WinRM command followed by the equivalent OpenWSMAN command is shown. Commands starting with "winrm" are for Windows management stations & commands starting with "wsman" are for Linux management stations with OpenWSMAN.

Note: Some commands shown may require the iDRAC7 to be at Express or Enterprise license level for successful execution.

### Identify

"identify" is a special command that enumerates a few properties related to vendor and versions. No class information is used.

    winrm id -u:root -p:calvin -r:https://172.26.9.56/wsman -SkipCNcheck -SkipCAcheck -encoding:utf-8 -a:basic

or

    docker run -ti --rm ianblenke/wsman identify -h 172.26.9.56 -P 443 -u root -p calvin -c Dummy -y basic -V –v

### Enumerate

"enumerate" returns all properties, values, and instances of a class.

    winrm e cimv2/root/dcim/DCIM_ComputerSystem -u:root -p:calvin -r:https://172.26.9.56/wsman -SkipCNcheck -SkipCAcheck -encoding:utf-8 -a:basic

or

    docker run -ti --rm ianblenke/wsman enumerate http://schemas.dell.com/wbem/wscim/1/cim-schema/2/root/dcim/DCIM_ComputerSystem -u root -p calvin -h 172.26.9.56 -P 443 -c Dummy -y basic -V –v -m 50

### Enumerate –epr

"epr" stands for Endpoint Reference. The "-epr" switch returns the key values (also known as selectors). The keys are used to uniquely identify a specific instance and are used in all get, invoke, and set commands. Using the -epr switch in the enumerate command is typically used to get the keys in order to build other commands.

    winrm e cimv2/root/dcim/DCIM_ComputerSystem -u:root -p:calvin -r:https://172.26.9.56/wsman -SkipCNcheck -SkipCAcheck -encoding:utf-8 -a:basic -returntype:epr

or

    docker run -ti --rm ianblenke/wsman enumerate http://schemas.dell.com/wbem/wscim/1/cim-schema/2/root/dcim/DCIM_ComputerSystem -u root -p calvin -h 172.26.9.56 -P 443 -c Dummy -y basic -V –v –M epr -m 50

#### Get

"get" is used to retrieve a single instance of a class and its properties and values.

    winrm g cimv2/root/dcim/DCIM_ComputerSystem?CreationClassName=DCIM_ComputerSystem+Name=srv:system -u:root -p:calvin -r:https://172.26.9.56/wsman -SkipCNcheck -SkipCAcheck -encoding:utf-8 -a:basic

or
 
    docker run -ti --rm ianblenke/wsman get http://schemas.dell.com/wbem/wscim/1/cim-schema/2/root/dcim/DCIM_ComputerSystem?CreationClassName="DCIM_ComputerSystem",Name="srv:system" -h 172.26.9.56 -P 443 -u root -p calvin -c Dummy -y basic -V –v

### Methods (Invokes)

Methods are used to make configuration changes or perform some action on the server (such as a reboot).

#### Single Parameter Example

    winrm i RequestStateChange cimv2/root/dcim/DCIM_ComputerSystem?CreationClassName=DCIM_ComputerSystem+Name=srv:system  -u:root -p:calvin -r:https://172.23.200.117/wsman -SkipCNcheck -SkipCAcheck -encoding:utf-8 -a:basic @{RequestedState="2"}

or

    docker run -ti --rm ianblenke/wsman invoke -a "RequestStateChange" http://schemas.dell.com/wbem/wscim/1/cim-schema/2/root/dcim/DCIM_ComputerSystem?CreationClassName="DCIM_ComputerSystem",Name="srv:system" -h 172.23.200.117 -P 443 -u root -p calvin -c Dummy -y basic -V –v -k "RequestedState=2"

#### Multi-Parameter Example

    winrm i GetAvailableDisks cimv2/root/dcim/DCIM_RAIDService?SystemCreationClassName=DCIM_ComputerSystem+CreationClassName=DCIM_RAIDService+SystemName=DCIM:ComputerSystem+Name=DCIM:RAIDService -u:root -p:calvin -r:https://172.23.200.117/wsman -SkipCNcheck -SkipCAcheck -encoding:utf-8 -a:basic@{Target="RAID.Integrated.1-1";DiskType="0";DiskProtocol="0";DiskEncrypt="0";RAIDLevel="4"}

or

    docker run -ti --rm ianblenke/wsman invoke -a "GetAvailableDisks"  http://schemas.dell.com/wbem/wscim/1/cim-schema/2/root/dcim/DCIM_RAIDService?SystemCreationClassName="DCIM_ComputerSystem",CreationClassName="DCIM_RAIDService",SystemName="DCIM:ComputerSystem",Name="DCIM:RAIDService" -h 172.23.200.117 -P 443 -u root -p calvin -c Dummy -y basic -V -v -k "Target=RAID.Integrated.1-1" -k "DiskType=0" -k "DiskProtocol=0" -k "DiskEncrypt=0" -k "RAIDLevel=4"

#### Use of .xml File Example

    winrm i GetAvailableDisks cimv2/root/dcim/DCIM_RAIDService?SystemCreationClassName=DCIM_ComputerSystem+CreationClassName=DCIM_RAIDService+SystemName=DCIM:ComputerSystem+Name=DCIM:RAIDService -u:root -p:calvin -r:https://172.23.200.117/wsman -SkipCNcheck -SkipCAcheck -encoding:utf-8 -a:basic -file:gad.xml

or
 
    docker run -ti --rm ianblenke/wsman invoke -a "GetAvailableDisks"  http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/root/dcim/DCIM_RAIDService?SystemCreationClassName="DCIM_ComputerSystem",CreationClassName="DCIM_RAIDService",SystemName="DCIM:ComputerSystem",Name="DCIM:RAIDService" -h 172.23.200.117 -P 443 -u root -p calvin -c Dummy -y basic -V -v -J gad.xml

Note: The schema specified in the .xml file must match the schema in the command.  For example, you can't use schemas.dell.com in the command and schemas.dmtf.org in the .xml file it references or the command will fail. Remember that for winrm, "cimv2" is an alias that contains schemas.dmtf.org.

### Set (winrm) - Put (Openwsman)

"set" is used to set a value (it is called a "put" in Linux). A set is similar to a method with the main difference being a set/put command does provide a return code.  

Note: This is not the same thing as a "SetAttribute" command. SetAttribute is a method name, not a "set" command.

    winrm s cimv2/root/dcim/DCIM_LCLogEntry?InstanceID=DCIM:LifeCycleLog:3 -u:root -p:calvin -r:https://172.26.9.56/wsman -encoding:utf-8 -a:basic -SkipCNcheck -SkipCAcheck@{Comment="This is a test comment in the 3rd log entry"} 

or

    docker run -ti --rm ianblenke/wsman put http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/root/dcim/DCIM_LCLogEntry?InstanceID="DCIM:LifeCycleLog:4" -h 172.26.9.56 -P 443 -u root -p calvin -c Dummy -y basic -V -v -k "Comment=This is a test comment in the 4th log entry"

### Enumeration Filtering Commands

Enumeration filtering is used when you want to filter Instances based on property values. This is different from the "get" command which always returns one instance. Enumeration filtering will return anywhere from 0 to an infinite number of instances based on a set of criteria.

There are two supported query languages: WQL and CQL.

#### WQL - Windows Management Instrumentation Query Language (winrm only)

    winrm e cimv2/DCIM_MemoryView -u:root -p:calvin -r:https://172.26.9.56/wsman -SkipCNcheck -SkipCAcheck -encoding:utf-8 -a:basic -dialect:http://schemas.microsoft.com/wbem/wsman/1/WQL -filter:"select * from DCIM_MemoryView WHERE BankLabel='A'"

#### CQL - Common Information Model Query Language (winrm and wsman)

    winrm e cimv2/DCIM_MemoryView -u:root -p:calvin -r:https://172.26.9.56/wsman -a:basic -encoding:utf-8 -skipCACheck -skipCNCheck -dialect:http://schemas.dmtf.org/wbem/cql/1/dsp0202.pdf -filter:"select * from DCIM_MemoryView WHERE BankLabel='A'"

or

    docker run -ti --rm ianblenke/wsman enumerate http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/root/dcim/DCIM_MemoryView -h 172.26.9.56 -P 443 -u root -p calvin -v -V -c Dummy -y basic --dialect=http://schemas.dmtf.org/wbem/cql/1/dsp0202.pdf --filter="select * from DCIM_MemoryView where BankLabel='A'"

### IPv6 Addresses

For IPv6 addresses, enclose the IPv6 address in [] in all commands. All other syntax is the same.

### Related Articles

[Web Services Management (WS-MAN) Windows Client Setup](http://en.community.dell.com/techcenter/systems-management/w/wiki/4138.web-services-management-ws-man-windows-client-setup.aspx)

[Web Services Management (WSMAN) Linux Client Installation & Setup](http://en.community.dell.com/techcenter/systems-management/w/wiki/4139.web-services-management-wsman-linux-client-installation-setup.aspx)

[How to Build and Execute WSMAN Method Commands](http://en.community.dell.com/techcenter/systems-management/w/wiki/4374.how-to-build-and-execute-wsman-method-commands.aspx)

