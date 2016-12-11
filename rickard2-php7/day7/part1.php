<?php

require 'lib.php';

$ipAddresses               = IpAddress::createFromFile('input');
$ipAddressesWithTLSSupport = array_filter($ipAddresses, function (IpAddress $ipAddress) {
    return $ipAddress->supportsTLS();
});

printf('There are %d IPs that supports TLS' . PHP_EOL, count($ipAddressesWithTLSSupport));