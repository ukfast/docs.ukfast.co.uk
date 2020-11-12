# Checking Inbound/Outbound server connectivity

What is covered within this guide?
```
- Testing outbound connectivity from your server
- Testing inbound connectivity to your server
- Troubleshooting inbound connectivity issues
```
## Testing Outbound connectivity from your server

To test general outbound connectivity from your server over a specific port. The following Powershell command is extremely useful;
```
Test-NetConnection {Hostname/IP} -port {Port}
```
This command provides us with the following information;

The name of the remote computer (If a DNS name has been used)
The IP of the remote computer
The port used
The network adapter used for the connection
The source IP used within the connection test
Whether or not the remote address is accessible via ping
The Round-Trip Time in MS it took for the ping to complete
Whether or not the remote address is accessible via the specified port

Example;
```
PS C:\Users\Administrator\> Test-NetConnection portquiz.net -port 80

ComputerName: portquiz.net
RemoteAddress: 52.47.209.216
RemotePort: 80
InterfaceAlias: Ethernet
SourceAddress: 10.0.0.23
PingSucceeded: True
PingReplyDetails (RTT): 6 ms
TcpTestSucceeded: True
```
Paired with the hostname "portquiz.net", which is a service in which is publicly accessible on all ports, we are able to gauge as to whether or not the port is open outbound through the firewall and can help indicate as to whether or not the connection is being blocked on the remote end.
```
Test-Netconnection portquiz.net -port 80
```
## Testing inbound connectivity to your server

The above Powershell command is also quite powerful when testing inbound connectivity to your server. As this helps determine as to whether or not your source device is able to communicate over the required ports.

Things to note here are;
```
- The server must be listening on the required port, For the connection to be accepted
- The relevant ports must be open on the firewall
- If Windows firewall is enabled, The ports must be opened here.
```

**Checking if a server is listening on a specific port**

The following CMD command can be ran to determine if a server is listening on a specific port;

netstat -ano | find ":PORT"

Example;
```
C:\Users\Administrator\>netstat -ano | find ":3389"

TCP 0.0.0.0:3389 0.0.0.0:0 LISTENING 320
TCP 10.0.0.23:3389 80.244.179.100:61548 ESTABLISHED 320
TCP [::]:3389 [::]:0 LISTENING 320
UDP 0.0.0.0:3389 \*:\* 320
UDP [::]:3389 \*:\* 320
```
**Checking if the port is open on your firewall**

Dependent upon on whether or not your server resides behind a dedicated or shared firewall, The following documentation will guide you through securely opening ports on your firewall;

Dedicated Firewall: [https://docs.ukfast.co.uk/network/firewalls/dedi\_lockdown.html](https://docs.ukfast.co.uk/network/firewalls/dedi_lockdown.html)

Shared Firewall: [https://docs.ukfast.co.uk/network/firewalls/shared\_lockdown.html](https://docs.ukfast.co.uk/network/firewalls/shared_lockdown.html)

**How to check if Windows firewall is enabled**

To check if Windows firewall is enabled you must;

Open the control panel > System and Security > Windows Defender Firewall.

Here is an example of a Windows firewall configuration which is not enabled

![windows-firewall](files/connectivity-testing/windows-firewall.png)

It is worth noting that, Typically Windows Firewall does not need to be enabled as ideally ports and traffic should be filtered via your UKFast firewall. This essentially reduced the load on the server as the server does not need to analyse and permit/reject traffic.

## Troubleshooting inbound connectivity issues

There are a wide variety of methods and tools in which you are able to troubleshoot network connectivity issues. Here are a few examples;

**Wireshark** ;

Wireshark can be used to monitor and capture traffic on a specific network interface. Filters can be applied when monitoring the traffic to help with troubleshooting. For example, The following filter would filter the results for traffic being transmitted over TCP port 3389;
```
tcp.port == 3389
```
![windows-wireshark](files/connectivity-testing/wireshark.png)

Wireshark is free to use and can be downloaded here; [https://www.wireshark.org/download.html](https://www.wireshark.org/download.html)

**Powershell;**

Powershell can be used to create artificial listeners on Windows, Which assists when testing connectivity to the server over a specific port.

The commands to create a listener on Windows via Powershell is as follows;

$Listener = [System.Net.Sockets.TcpListener]1234;
$Listener.Start();

The command to stop the listener would be;

$Listener.Stop();

Example;
```
Before running the commands;

C:\Users\Administrator\>netstat -ano | find ":1234"

After;

PS C:\Users\Administrator\> $Listener = [System.Net.Sockets.TcpListener]1234;
PS C:\Users\Administrator\? $Listener.Start();

C:\Users\Administrator\>netstat -ano | find ":1234"
TCP 0.0.0.0:1234 0.0.0.0:0 LISTENING 3180

To stop the listener run;

PS C:\Users\Administrator> $Listener.Stop();
```

```eval_rst
  .. title:: Troubleshooting inbound and outbound connectivity on Windows
  .. meta::
     :title: Troubleshooting inbound and outbound connectivity on Windows | UKFast Documentation
     :description: An in-depth guide on troubleshooting network connectivity issues on Windows
     :keywords: ukfast, network, tcp, connection, configure, tutorial, guide, server, cloud, powershell, firewall, ports
